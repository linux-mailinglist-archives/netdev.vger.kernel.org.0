Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4967E646AB9
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 09:40:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbiLHIkj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 03:40:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbiLHIki (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 03:40:38 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC88E6176F
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 00:40:37 -0800 (PST)
Received: from dggpemm500007.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4NSSJL5yzQzJqN2;
        Thu,  8 Dec 2022 16:39:46 +0800 (CST)
Received: from [10.174.178.174] (10.174.178.174) by
 dggpemm500007.china.huawei.com (7.185.36.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 8 Dec 2022 16:40:35 +0800
Subject: Re: [PATCH net v2] ethernet: s2io: don't call dev_kfree_skb() under
 spin_lock_irqsave()
To:     Leon Romanovsky <leon@kernel.org>
CC:     <netdev@vger.kernel.org>, <jdmason@kudzu.us>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>
References: <20221207012540.2717379-1-yangyingliang@huawei.com>
 <Y5GYqsgKxhUpfTn/@unreal>
From:   Yang Yingliang <yangyingliang@huawei.com>
Message-ID: <f31d0ce3-50fc-6206-bc7a-2a67ec0951db@huawei.com>
Date:   Thu, 8 Dec 2022 16:40:35 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <Y5GYqsgKxhUpfTn/@unreal>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.174.178.174]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
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


On 2022/12/8 15:56, Leon Romanovsky wrote:
> On Wed, Dec 07, 2022 at 09:25:40AM +0800, Yang Yingliang wrote:
>> It is not allowed to call consume_skb() from hardware interrupt context
>> or with interrupts being disabled. So replace dev_kfree_skb() with
>> dev_consume_skb_irq() under spin_lock_irqsave().
>>
>> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
>> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
>> ---
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
> And why did you use dev_consume_skb_irq() and not dev_kfree_skb_irq()?
I chose dev_consume_skb_irq(), because dev_kfree_skb() is consume_skb().

Thanks,
Yang
>
> Thanks
>
>>   				cnt++;
>>   			}
>>   		}
>> -- 
>> 2.25.1
>>
> .
