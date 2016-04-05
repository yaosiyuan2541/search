//
//  ViewController.m
//  iOS25_UI_TestSearch
//
//  Created by 姚思远 on 16/3/31.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchDisplayDelegate>
{
    UISearchDisplayController * disPlay;
    UITableView * mytableView;
}
@property (strong,nonatomic) NSMutableArray  *dataList;

@property (strong,nonatomic) NSMutableArray  *searchList;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.dataList=[NSMutableArray arrayWithCapacity:100];
    for (NSInteger i=0; i<100; i++) {
        [self.dataList addObject:[NSString stringWithFormat:@"%ld-dataSource",(long)i]];
    }
    
    self.searchList = [[NSMutableArray alloc]init];
    
    /*创建searchBar*/
    UISearchBar * search = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    search.placeholder = @"请输入关键字";
    /*创建searchDisPlayController管理searchBar*/
    disPlay = [[UISearchDisplayController alloc]initWithSearchBar:search contentsController:self];
    /*指定controller的代理*/
    disPlay.delegate = self;
    disPlay.searchResultsDelegate = self;
    disPlay.searchResultsDataSource = self;
    disPlay.active = NO;
    
    mytableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 20, 320, 548) style:UITableViewStylePlain];
    mytableView.delegate = self;
    mytableView.dataSource = self;
    /*指定刚刚创建的searchbar为tableView的头视图*/
    mytableView.tableHeaderView = disPlay.searchBar;
    [self.view addSubview:mytableView];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    if (tableView == disPlay.searchResultsTableView) {
        return [self.searchList count];
    }else{
        return [self.dataList count];
    }
}
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
    NSLog(@"%@",searchString);
    /*self.searchList在最开始创建用来存放搜索结果*/
    if (self.searchList.count != 0) {
        [self.searchList removeAllObjects];
    }
    /*遍历源数组当中的全部元素，与搜索内容进行比较看看源字符串当中是否存在搜索内容，如果有则添加到搜索结果当中*/
    for (NSString * str in self.dataList) {
        NSRange range = [str rangeOfString:searchString];
        if (range.length > 0) {
            [self.searchList addObject:str];
        }
    }
    //刷新表格
    return YES;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    if (tableView==disPlay.searchResultsTableView) {
        [cell.textLabel setText:self.searchList[indexPath.row]];
    }
    else{
        [cell.textLabel setText:self.dataList[indexPath.row]];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [disPlay.searchBar resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
