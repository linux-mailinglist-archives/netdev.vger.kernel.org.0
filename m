Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A58C452B198
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 06:41:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229951AbiEREj3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 00:39:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229949AbiEREj0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 00:39:26 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF80739153
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 21:39:24 -0700 (PDT)
Received: from canpemm500006.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4L30bY6M9cz1JC83;
        Wed, 18 May 2022 12:38:01 +0800 (CST)
Received: from [10.174.179.200] (10.174.179.200) by
 canpemm500006.china.huawei.com (7.192.105.130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 18 May 2022 12:39:22 +0800
Subject: Re: [PATCH net-next v2] net: wwan: t7xx: fix GFP_KERNEL usage in
 spin_lock context
To:     Loic Poulain <loic.poulain@linaro.org>
CC:     <chandrashekar.devegowda@intel.com>, <linuxwwan@intel.com>,
        <chiranjeevi.rapolu@linux.intel.com>, <haijun.liu@mediatek.com>,
        <m.chetan.kumar@linux.intel.com>,
        <ricardo.martinez@linux.intel.com>, <ryazanov.s.a@gmail.com>,
        <johannes@sipsolutions.net>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>
References: <20220517064821.3966990-1-william.xuanziyang@huawei.com>
 <CAMZdPi-ibG9O9C2m3qVeEAbO6=TLA-8jZzX9Gbm2MQOwT_1vPg@mail.gmail.com>
From:   "Ziyang Xuan (William)" <william.xuanziyang@huawei.com>
Message-ID: <ff9866ff-7149-e9d2-80e8-777482ab6711@huawei.com>
Date:   Wed, 18 May 2022 12:39:21 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CAMZdPi-ibG9O9C2m3qVeEAbO6=TLA-8jZzX9Gbm2MQOwT_1vPg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.200]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 canpemm500006.china.huawei.com (7.192.105.130)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-6.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Hi Ziyang,
> 
> On Tue, 17 May 2022 at 08:30, Ziyang Xuan <william.xuanziyang@huawei.com> wrote:
>>
>> t7xx_cldma_clear_rxq() call t7xx_cldma_alloc_and_map_skb() in spin_lock
>> context, But __dev_alloc_skb() in t7xx_cldma_alloc_and_map_skb() uses
>> GFP_KERNEL, that will introduce scheduling factor in spin_lock context.
>>
>> Because t7xx_cldma_clear_rxq() is called after stopping CLDMA, so we can
>> remove the spin_lock from t7xx_cldma_clear_rxq().
>>
>> Fixes: 39d439047f1d ("net: wwan: t7xx: Add control DMA interface")
>> Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
>> ---
> 
> You should normally indicate what changed in this v2.
> 
>>  drivers/net/wwan/t7xx/t7xx_hif_cldma.c | 7 ++++---
>>  1 file changed, 4 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/net/wwan/t7xx/t7xx_hif_cldma.c b/drivers/net/wwan/t7xx/t7xx_hif_cldma.c
>> index 46066dcd2607..7493285a9606 100644
>> --- a/drivers/net/wwan/t7xx/t7xx_hif_cldma.c
>> +++ b/drivers/net/wwan/t7xx/t7xx_hif_cldma.c
>> @@ -782,10 +782,12 @@ static int t7xx_cldma_clear_rxq(struct cldma_ctrl *md_ctrl, int qnum)
>>         struct cldma_queue *rxq = &md_ctrl->rxq[qnum];
>>         struct cldma_request *req;
>>         struct cldma_gpd *gpd;
>> -       unsigned long flags;
>>         int ret = 0;
>>
>> -       spin_lock_irqsave(&rxq->ring_lock, flags);
>> +       /* CLDMA has been stopped. There is not any CLDMA IRQ, holding
>> +        * ring_lock is not needed.
> 
> If it makes sense to explain why we don't need locking, the next
> sentence is not needed:

I want to remind the possible developer if he or she want to add spin_lock
here again in future, he or she should check whether there is a scheduling
factor or not here firstly.

> 
> 
>>  Thus we can use functions that may
>> +        * introduce scheduling.
>> +        */
>>         t7xx_cldma_q_reset(rxq);
>>         list_for_each_entry(req, &rxq->tr_ring->gpd_ring, entry) {
>>                 gpd = req->gpd;
>> @@ -808,7 +810,6 @@ static int t7xx_cldma_clear_rxq(struct cldma_ctrl *md_ctrl, int qnum)
>>
>>                 t7xx_cldma_gpd_set_data_ptr(req->gpd, req->mapped_buff);
>>         }
>> -       spin_unlock_irqrestore(&rxq->ring_lock, flags);
>>
>>         return ret;
>>  }
>> --
>> 2.25.1
>>
> .
> 
