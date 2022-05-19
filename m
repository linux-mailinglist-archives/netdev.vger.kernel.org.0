Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA3F052C975
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 03:52:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232680AbiESBwg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 21:52:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232429AbiESBwe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 21:52:34 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 081A8C3D01;
        Wed, 18 May 2022 18:52:33 -0700 (PDT)
Received: from dggpemm500022.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4L3XsR0bBgzhZ9w;
        Thu, 19 May 2022 09:51:55 +0800 (CST)
Received: from dggpemm500007.china.huawei.com (7.185.36.183) by
 dggpemm500022.china.huawei.com (7.185.36.162) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 19 May 2022 09:52:31 +0800
Received: from [10.174.178.174] (10.174.178.174) by
 dggpemm500007.china.huawei.com (7.185.36.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 19 May 2022 09:52:30 +0800
Subject: Re: [PATCH -next] net: wwan: t7xx: use GFP_ATOMIC under spin lock in
 t7xx_cldma_gpd_set_next_ptr()
To:     Loic Poulain <loic.poulain@linaro.org>
CC:     <linux-kernel@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>, <netdev@vger.kernel.org>,
        <haijun.liu@mediatek.com>, <chandrashekar.devegowda@intel.com>,
        <ricardo.martinez@linux.intel.com>, <davem@davemloft.net>,
        <kuba@kernel.org>
References: <20220518090738.2694556-1-yangyingliang@huawei.com>
 <CAMZdPi9uvh4E70-AXpGrdzkgh35mfWQbhL8Kxw_o9_DsfL2gbw@mail.gmail.com>
From:   Yang Yingliang <yangyingliang@huawei.com>
Message-ID: <53b384f6-5507-b767-f64a-574cfd511e13@huawei.com>
Date:   Thu, 19 May 2022 09:52:30 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <CAMZdPi9uvh4E70-AXpGrdzkgh35mfWQbhL8Kxw_o9_DsfL2gbw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.174.178.174]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpemm500007.china.huawei.com (7.185.36.183)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-6.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 2022/5/18 17:13, Loic Poulain wrote:
> Hi Yang,
>
> On Wed, 18 May 2022 at 10:57, Yang Yingliang <yangyingliang@huawei.com> wrote:
>> Sometimes t7xx_cldma_gpd_set_next_ptr() is called under spin lock,
>> so add a parameter in t7xx_cldma_gpd_set_next_ptr() to make if it
>> use GFP_ATOMIC flag.
>>
>> Fixes: 39d439047f1d ("net: wwan: t7xx: Add control DMA interface")
>> Reported-by: Hulk Robot <hulkci@huawei.com>
>> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
>> ---
>>   drivers/net/wwan/t7xx/t7xx_hif_cldma.c | 13 ++++++++-----
>>   1 file changed, 8 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/net/wwan/t7xx/t7xx_hif_cldma.c b/drivers/net/wwan/t7xx/t7xx_hif_cldma.c
>> index 0c52801ed0de..1fa9bb763831 100644
>> --- a/drivers/net/wwan/t7xx/t7xx_hif_cldma.c
>> +++ b/drivers/net/wwan/t7xx/t7xx_hif_cldma.c
>> @@ -91,9 +91,12 @@ static void t7xx_cldma_gpd_set_next_ptr(struct cldma_gpd *gpd, dma_addr_t next_p
>>   }
>>
>>   static int t7xx_cldma_alloc_and_map_skb(struct cldma_ctrl *md_ctrl, struct cldma_request *req,
>> -                                       size_t size)
>> +                                       size_t size, bool is_atomic)
> Would be simpler to directly pass the gfp_mask as a parameter.
Yes, I will send a v2 with this change later.

Thanks,
Yang
>
>
>>   {
>> -       req->skb = __dev_alloc_skb(size, GFP_KERNEL);
>> +       if (is_atomic)
>> +               req->skb = __dev_alloc_skb(size, GFP_ATOMIC);
>> +       else
>> +               req->skb = __dev_alloc_skb(size, GFP_KERNEL);
>>          if (!req->skb)
>>                  return -ENOMEM;
>>
>> @@ -174,7 +177,7 @@ static int t7xx_cldma_gpd_rx_from_q(struct cldma_queue *queue, int budget, bool
>>                  spin_unlock_irqrestore(&queue->ring_lock, flags);
>>                  req = queue->rx_refill;
>>
>> -               ret = t7xx_cldma_alloc_and_map_skb(md_ctrl, req, queue->tr_ring->pkt_size);
>> +               ret = t7xx_cldma_alloc_and_map_skb(md_ctrl, req, queue->tr_ring->pkt_size, false);
>>                  if (ret)
>>                          return ret;
>>
>> @@ -402,7 +405,7 @@ static struct cldma_request *t7xx_alloc_rx_request(struct cldma_ctrl *md_ctrl, s
>>          if (!req->gpd)
>>                  goto err_free_req;
>>
>> -       val = t7xx_cldma_alloc_and_map_skb(md_ctrl, req, pkt_size);
>> +       val = t7xx_cldma_alloc_and_map_skb(md_ctrl, req, pkt_size, false);
>>          if (val)
>>                  goto err_free_pool;
>>
>> @@ -801,7 +804,7 @@ static int t7xx_cldma_clear_rxq(struct cldma_ctrl *md_ctrl, int qnum)
>>                  if (req->skb)
>>                          continue;
>>
>> -               ret = t7xx_cldma_alloc_and_map_skb(md_ctrl, req, rxq->tr_ring->pkt_size);
>> +               ret = t7xx_cldma_alloc_and_map_skb(md_ctrl, req, rxq->tr_ring->pkt_size, true);
>>                  if (ret)
>>                          break;
>>
>> --
>> 2.25.1
>>
> .
