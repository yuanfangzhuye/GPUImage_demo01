//
//  ViewController.m
//  GPUImage_demo01
//
//  Created by tlab on 2020/8/25.
//  Copyright © 2020 yuanfangzhuye. All rights reserved.
//

#import "ViewController.h"
#import <GPUImage/GPUImage.h>
#import <PhotosUI/PhotosUI.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface ViewController ()

@property (nonatomic, strong) GPUImageStillCamera *stillCamera;

@property (nonatomic, strong) GPUImageFilter *mFilter;
@property (nonatomic, strong) GPUImageView *mImageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //添加GPUImage
    [self addFilterCamera];
    
    //添加一个按钮触发拍照
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake((self.view.bounds.size.width-80)*0.5, self.view.bounds.size.height-120, 100, 100)];
    btn.backgroundColor = [UIColor redColor];
    [btn setTitle:@"拍照" forState:UIControlStateNormal];
    
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(takePhoto) forControlEvents:UIControlEventTouchUpInside];
}

- (void)addFilterCamera {
    
    //1.第一个参数表示相片的尺寸，第二个参数表示前、后摄像头 AVCaptureDevicePositionFront/AVCaptureDevicePositionBack
    _stillCamera = [[GPUImageStillCamera alloc] initWithSessionPreset:AVCaptureSessionPreset640x480 cameraPosition:AVCaptureDevicePositionFront];
    
    //2.切换摄像头
    [_stillCamera rotateCamera];
    
    //3.竖屏方向
    _stillCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    
    //4.设置滤镜对象
    _mFilter = [[GPUImageGrayscaleFilter alloc] init];
    
    _mImageView = [[GPUImageView alloc] initWithFrame:self.view.bounds];
    
    [_stillCamera addTarget:_mFilter];
    [_mFilter addTarget:_mImageView];
    [self.view addSubview:_mImageView];
    
    [_stillCamera startCameraCapture];
}

- (void)takePhoto {
    
    //7.将图片通过PhotoKit add 相册中
    [_stillCamera capturePhotoAsJPEGProcessedUpToFilter:_mFilter withCompletionHandler:^(NSData *processedJPEG, NSError *error) {
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            
            [[PHAssetCreationRequest creationRequestForAsset] addResourceWithType:PHAssetResourceTypePhoto data:processedJPEG options:nil];
            
        } completionHandler:^(BOOL success, NSError * _Nullable error) {
            
        }];
        
        //获取拍摄的图片
        UIImage * image = [UIImage imageWithData:processedJPEG];
    }];
}


@end
