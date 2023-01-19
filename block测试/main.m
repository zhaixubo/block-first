//
//  main.m
//  block测试
//
//  Created by 翟旭博 on 2023/1/13.
//

#import <Foundation/Foundation.h>
void interceptAutomaticVariable(void);
void interceptObject(void);
void the__block(void);
void theNSGlobalBlock(void);
void theNSStackBlock(void);
void theNSMallocBlock(void);
void superBlock(void);
int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
//        the__block();
//        interceptObject();
//        interceptAutomaticVariable();
//        theNSGlobalBlock();
//       theNSStackBlock();
//        theNSMallocBlock();
        superBlock();
    }
    return 0;
}

void interceptAutomaticVariable() {       //截获自动变量
    int dmy = 256;
    int val = 10;
    const char *fmt = "val = %d\n";
    void (^blk)(void) = ^{
        printf(fmt, val);
    };
    val = 2;
    fmt = "These values were changed. val = %d\n";
    blk();
}

void interceptObject() {       //截获oc对象
    id array = [[NSMutableArray alloc] init];
    void (^blk) (void) = ^ {
        id obj = [[NSObject alloc] init];
        [array addObject:obj];
    };
    
//    id array2 = [[NSMutableArray alloc] init];
//    void (^blk2) (void) = ^ {
//        array2 = array;
//    };
}

void the__block() {     //__block测试
    __block int val = 0;
    void (^blk) (void) = ^{
        val = 1;
    };
    blk();
    printf("val = %d\n", val);
}

void theNSGlobalBlock() {     //对象存储在数据区
    //block1没有引用到局部变量
    int a = 10;
    void (^block1)(void) = ^{
         NSLog(@"hello world");
    };
    NSLog(@"block1:%@", block1);

    //    block2中引入的是静态变量
    static int a1 = 20;
    void (^block2)(void) = ^{
        NSLog(@"hello - %d",a1);
    };
    NSLog(@"block2:%@", block2);
    //如果一个 block 没有访问外部局部变量，或者访问的是全局变量，或者静态局部变量，此时的 block 就是一个全局 block ，并且数据存储在全局区。
}

void theNSStackBlock() {     //对象存储在栈区
    int b = 10;
    NSLog(@"%@", ^{
        NSLog(@"hello - %d",b);
    });
    
    int c = 10;
    NSLog(@"%@", (__weak)^{
        NSLog(@"hello - %d",c);
    });
    
    int a = 10;
    NSLog(@"%@", [^{
        NSLog(@"hello - %d",a);
    } description]);
    
    int age = 15;
    NSLog(@"%@", [^{
        NSLog(@"block----%d", age);
    } class]);

    //在arc中默认会将block从栈复制到堆上，而在非arc中，则需要手动copy.
}

void theNSMallocBlock() {     //对象存储在堆区
    int a = 10;
    void (^block1)(void) = ^{
        NSLog(@"%d",a);
    };
    NSLog(@"block1:%@", [block1 copy]);

    __block int b = 10;
    void (^block2)(void) = ^{
        NSLog(@"%d",b);
    };
    NSLog(@"block2:%@", [block2 copy]);

}

void superBlock() {      //block的父类
    void (^block1)(void) = ^{
        NSLog(@"block1");
    };
    NSLog(@"%@",[block1 class]);
    NSLog(@"%@",[[block1 class] superclass]);
    NSLog(@"%@",[[[block1 class] superclass] superclass]);
    NSLog(@"%@",[[[[block1 class] superclass] superclass] superclass]);
}
