Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49641646AB5
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 09:39:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229575AbiLHIjH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 03:39:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbiLHIjG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 03:39:06 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A082361760
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 00:39:05 -0800 (PST)
Received: from dggpemm500007.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4NSSBj09JvzqSQ0;
        Thu,  8 Dec 2022 16:34:53 +0800 (CST)
Received: from [10.174.178.174] (10.174.178.174) by
 dggpemm500007.china.huawei.com (7.185.36.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 8 Dec 2022 16:39:03 +0800
Subject: Re: [PATCH net v2 1/2] net: apple: mace: don't call dev_kfree_skb()
 under spin_lock_irqsave()
To:     Leon Romanovsky <leon@kernel.org>
CC:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>
References: <20221207012959.2800421-1-yangyingliang@huawei.com>
 <Y5GZJ2rBuMZoZ0e7@unreal>
From:   Yang Yingliang <yangyingliang@huawei.com>
Message-ID: <0d01feea-973a-0331-e669-bc362ba93f56@huawei.com>
Date:   Thu, 8 Dec 2022 16:39:03 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <Y5GZJ2rBuMZoZ0e7@unreal>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.174.178.174]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpemm500007.china.huawei.com (7.185.36.183)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2022/12/8 15:58, Leon Romanovsky wrote:
> On Wed, Dec 07, 2022 at 09:29:58AM +0800, Yang Yingliang wrote:
>> It is not allowed to call consume_skb() from hardware interrupt context
>> or with interrupts being disabled. So replace dev_kfree_skb() with
>> dev_consume_skb_irq() under spin_lock_irqsave().
>>
>> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
>> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
>> ---
>> v1 -> v2:
>>    Add a fix tag.
>> ---
>>   drivers/net/ethernet/apple/mace.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/ethernet/apple/mace.c b/drivers/net/ethernet/apple/mace.c
>> index d0a771b65e88..77b4ed05140b 100644
>> --- a/drivers/net/ethernet/apple/mace.c
>> +++ b/drivers/net/ethernet/apple/mace.c
>> @@ -846,7 +846,7 @@ static void mace_tx_timeout(struct timer_list *t)
>>       if (mp->tx_bad_runt) {
>>   	mp->tx_bad_runt = 0;
>>       } else if (i != mp->tx_fill) {
>> -	dev_kfree_skb(mp->tx_bufs[i]);
>> +	dev_consume_skb_irq(mp->tx_bufs[i]);
> Same question, why did you chose dev_consume_skb_irq and not dev_kfree_skb_irq?
I chose dev_consume_skb_irq(), because dev_kfree_skb() is consume_skb().

Thanks,
Yang
>
> Thanks
>
>>   	if (++i >= N_TX_RING)
>>   	    i = 0;
>>   	mp->tx_empty = i;
>> -- 
>> 2.25.1
>>
> .
