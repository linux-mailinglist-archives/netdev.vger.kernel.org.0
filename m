Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F10C2666922
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 03:56:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233380AbjALC4K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 21:56:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230329AbjALC4J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 21:56:09 -0500
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 651615F8E
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 18:56:07 -0800 (PST)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.54])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4Nspwq1Y4szJqBd;
        Thu, 12 Jan 2023 10:51:55 +0800 (CST)
Received: from [10.67.102.37] (10.67.102.37) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 12 Jan
 2023 10:56:02 +0800
Subject: Re: [PATCH net] net: hns3: fix wrong use of rss size during VF rss
 config
To:     Alexander H Duyck <alexander.duyck@gmail.com>,
        <davem@davemloft.net>, <kuba@kernel.org>
References: <20230110115359.10163-1-lanhao@huawei.com>
 <f2e3a02cd2a584aa1ed036e90c5c71764e0b8373.camel@gmail.com>
CC:     <yisen.zhuang@huawei.com>, <salil.mehta@huawei.com>,
        <edumazet@google.com>, <pabeni@redhat.com>,
        <richardcochran@gmail.com>, <shenjian15@huawei.com>,
        <wangjie125@huawei.com>, <netdev@vger.kernel.org>
From:   Hao Lan <lanhao@huawei.com>
Message-ID: <7a93e4f9-0db4-a520-e5fd-8e52d860c2cf@huawei.com>
Date:   Thu, 12 Jan 2023 10:56:02 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <f2e3a02cd2a584aa1ed036e90c5c71764e0b8373.camel@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.102.37]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2023/1/12 0:31, Alexander H Duyck wrote:
> On Tue, 2023-01-10 at 19:53 +0800, Hao Lan wrote:
>> From: Jie Wang <wangjie125@huawei.com>
>>
>> Currently, it used old rss size to get current tc mode. As a result, the
>> rss size is updated, but the tc mode is still configured based on the old
>> rss size.
>>
>> So this patch fixes it by using the new rss size in both process.
>>
>> Fixes: 93969dc14fcd ("net: hns3: refactor VF rss init APIs with new common rss init APIs")
>> Signed-off-by: Jie Wang <wangjie125@huawei.com>
>> Signed-off-by: Hao Lan <lanhao@huawei.com>
>> ---
>>  drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
>> index 081bd2c3f289..e84e5be8e59e 100644
>> --- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
>> +++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
>> @@ -3130,7 +3130,7 @@ static int hclgevf_set_channels(struct hnae3_handle *handle, u32 new_tqps_num,
>>  
>>  	hclgevf_update_rss_size(handle, new_tqps_num);
>>  
>> -	hclge_comm_get_rss_tc_info(cur_rss_size, hdev->hw_tc_map,
>> +	hclge_comm_get_rss_tc_info(kinfo->rss_size, hdev->hw_tc_map,
>>  				   tc_offset, tc_valid, tc_size);
>>  	ret = hclge_comm_set_rss_tc_mode(&hdev->hw.hw, tc_offset,
>>  					 tc_valid, tc_size);
> 
> I can see how this was confused. It isn't really clear that handle is
> being used to update the kinfo->rss_size value. Maybe think about
> adding a comment to prevent someone from reverting this without
> realizing that? It might also be useful to do a follow-on patch for
> net-next that renames cur_rss_size to orig_rss_size to make it more
> obvious that the value is changing.
> 
> Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
> .
> 
Hi Alexander Duyck,
Thank you for your reviewed.And thank you for your valuable advice.
Would it be better if we changed it to the following.

-	u16 cur_rss_size = kinfo->rss_size;
-	u16 cur_tqps = kinfo->num_tqps;
+	u16 orig_rss_size = kinfo->rss_size;
+	u16 orig_tqps = kinfo->num_tqps;
 	u32 *rss_indir;
 	unsigned int i;
 	int ret;

 	hclgevf_update_rss_size(handle, new_tqps_num);

-	hclge_comm_get_rss_tc_info(cur_rss_size, hdev->hw_tc_map,
+	/* RSS size will be updated after hclgevf_update_rss_size,
+	 * so we use kinfo->rss_size instead of orig_rss_size.
+	 */
+	hclge_comm_get_rss_tc_info(kinfo->rss_size, hdev->hw_tc_map,
