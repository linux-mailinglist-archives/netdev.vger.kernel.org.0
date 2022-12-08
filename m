Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EF1A646CC2
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 11:31:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229776AbiLHKbJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 05:31:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229773AbiLHKbG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 05:31:06 -0500
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 290127DA63
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 02:31:03 -0800 (PST)
Received: from dggpemm500007.china.huawei.com (unknown [172.30.72.57])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4NSVhd40kHzJp8s;
        Thu,  8 Dec 2022 18:27:29 +0800 (CST)
Received: from [10.174.178.174] (10.174.178.174) by
 dggpemm500007.china.huawei.com (7.185.36.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 8 Dec 2022 18:31:01 +0800
Subject: Re: [PATCH net v3] ethernet: s2io: don't call dev_kfree_skb() under
 spin_lock_irqsave()
To:     Leon Romanovsky <leon@kernel.org>
CC:     <netdev@vger.kernel.org>, <jdmason@kudzu.us>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>
References: <20221208092411.1961448-1-yangyingliang@huawei.com>
 <Y5GxxIc9EY6h/qj2@unreal>
From:   Yang Yingliang <yangyingliang@huawei.com>
Message-ID: <840947dc-8560-ca51-f4d6-0e2628c181b1@huawei.com>
Date:   Thu, 8 Dec 2022 18:31:00 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <Y5GxxIc9EY6h/qj2@unreal>
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


On 2022/12/8 17:43, Leon Romanovsky wrote:
> On Thu, Dec 08, 2022 at 05:24:11PM +0800, Yang Yingliang wrote:
>> The dev_kfree_skb() is defined as consume_skb(), and it is not allowed
>> to call consume_skb() from hardware interrupt context or with interrupts
>> being disabled. So replace dev_kfree_skb() with dev_consume_skb_irq()
>> under spin_lock_irqsave().
> While dev_kfree_skb and consume_skb are the same, the dev_kfree_skb_irq
> and dev_consume_skb_irq are not. You can't blindly replace
> dev_kfree_skb with dev_consume_skb_irq. You should check every place, analyze
> and document why specific option was chosen.
While calling dev_kfree_skb(consume_skb), the SKB will not be marked as 
dropped,
to keep the same meaning, so replace it with dev_consume_skb_irq()

Thanks,
Yang
>
>    3791 static inline void dev_kfree_skb_irq(struct sk_buff *skb)
>    3792 {
>    3793         __dev_kfree_skb_irq(skb, SKB_REASON_DROPPED);
>    3794 }
>    3795
>    3796 static inline void dev_consume_skb_irq(struct sk_buff *skb)
>    3797 {
>    3798         __dev_kfree_skb_irq(skb, SKB_REASON_CONSUMED);
>    3799 }
>
> Thanks
>
>
>> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
>> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
>> ---
>> v2 -> v3:
>>    Update commit message.
>>
>> v1 -> v2:
>>    Add fix tag.
>> ---
>>   drivers/net/ethernet/neterion/s2io.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/ethernet/neterion/s2io.c b/drivers/net/ethernet/neterion/s2io.c
>> index 1d3c4474b7cb..a83d61d45936 100644
>> --- a/drivers/net/ethernet/neterion/s2io.c
>> +++ b/drivers/net/ethernet/neterion/s2io.c
>> @@ -2386,7 +2386,7 @@ static void free_tx_buffers(struct s2io_nic *nic)
>>   			skb = s2io_txdl_getskb(&mac_control->fifos[i], txdp, j);
>>   			if (skb) {
>>   				swstats->mem_freed += skb->truesize;
>> -				dev_kfree_skb(skb);
>> +				dev_consume_skb_irq(skb);
>>   				cnt++;
>>   			}
>>   		}
>> -- 
>> 2.25.1
>>
> .
