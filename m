Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA3EC65CB6B
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 02:30:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234142AbjADBaj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 20:30:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233577AbjADBah (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 20:30:37 -0500
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8852B13F24
        for <netdev@vger.kernel.org>; Tue,  3 Jan 2023 17:30:36 -0800 (PST)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.53])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4NmsQ254bGzJppd;
        Wed,  4 Jan 2023 09:26:34 +0800 (CST)
Received: from [10.174.178.66] (10.174.178.66) by
 dggpeml500026.china.huawei.com (7.185.36.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Wed, 4 Jan 2023 09:30:33 +0800
Message-ID: <d245e68f-7105-6c12-b732-90d9fef8fb77@huawei.com>
Date:   Wed, 4 Jan 2023 09:30:33 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.2
Subject: Re: [PATCH] 9p/rdma: unmap receive dma buffer in rdma_request()
To:     Leon Romanovsky <leon@kernel.org>
CC:     <v9fs-developer@lists.sourceforge.net>, <netdev@vger.kernel.org>,
        <ericvh@gmail.com>, <lucho@ionkov.net>, <asmadeus@codewreck.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <linux_oss@crudebyte.com>,
        <tom@opengridcomputing.com>, <weiyongjun1@huawei.com>,
        <yuehaibing@huawei.com>
References: <20221220031223.3890143-1-shaozhengchao@huawei.com>
 <Y6wN4uBZwPV+rKXi@unreal>
From:   shaozhengchao <shaozhengchao@huawei.com>
In-Reply-To: <Y6wN4uBZwPV+rKXi@unreal>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.178.66]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpeml500026.china.huawei.com (7.185.36.106)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022/12/28 17:35, Leon Romanovsky wrote:
> On Tue, Dec 20, 2022 at 11:12:23AM +0800, Zhengchao Shao wrote:
>> When down_interruptible() failed in rdma_request(), receive dma buffer
>> is not unmapped. Add unmap action to error path.
>>
>> Fixes: fc79d4b104f0 ("9p: rdma: RDMA Transport Support for 9P")
>> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
>> ---
>>   net/9p/trans_rdma.c | 2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/net/9p/trans_rdma.c b/net/9p/trans_rdma.c
>> index 83f9100d46bf..da83023fecbf 100644
>> --- a/net/9p/trans_rdma.c
>> +++ b/net/9p/trans_rdma.c
>> @@ -499,6 +499,8 @@ static int rdma_request(struct p9_client *client, struct p9_req_t *req)
>>   
>>   	if (down_interruptible(&rdma->sq_sem)) {
>>   		err = -EINTR;
>> +		ib_dma_unmap_single(rdma->cm_id->device, c->busa,
>> +				    c->req->tc.size, DMA_TO_DEVICE);
>>   		goto send_error;
>>   	}
> 
> It is not the only place where ib_dma_unmap_single() wasn't called.
> Even at the same function if ib_post_send() fails, the unmap is not
> called. Also post_recv() is missing call to ib_dma_unmap_single() too.
> 
> Thanks
> 
Hi Leon：
	Thank you for your review. I'm sorry I haven't answered your
message for so long, I've got Coronavirus and it's a terrible feeling.
I will send v2 soon.

Zhengchao Shao
>>   
>> -- 
>> 2.34.1
>>
