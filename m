Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10945646B61
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 10:04:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230125AbiLHJEd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 04:04:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230000AbiLHJDy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 04:03:54 -0500
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F4816A74A
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 01:03:23 -0800 (PST)
Received: from dggpemm500007.china.huawei.com (unknown [172.30.72.54])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4NSSlT6RgVzJp3Q;
        Thu,  8 Dec 2022 16:59:49 +0800 (CST)
Received: from [10.174.178.174] (10.174.178.174) by
 dggpemm500007.china.huawei.com (7.185.36.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 8 Dec 2022 17:03:21 +0800
Subject: Re: [PATCH net v2] ethernet: s2io: don't call dev_kfree_skb() under
 spin_lock_irqsave()
To:     Leon Romanovsky <leon@kernel.org>
CC:     <netdev@vger.kernel.org>, <jdmason@kudzu.us>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>
References: <20221207012540.2717379-1-yangyingliang@huawei.com>
 <Y5GYqsgKxhUpfTn/@unreal> <f31d0ce3-50fc-6206-bc7a-2a67ec0951db@huawei.com>
 <Y5GlfDf9iQgFl8yc@unreal>
From:   Yang Yingliang <yangyingliang@huawei.com>
Message-ID: <2e425086-b96e-65ac-f004-99f55af2e8d0@huawei.com>
Date:   Thu, 8 Dec 2022 17:03:20 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <Y5GlfDf9iQgFl8yc@unreal>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.174.178.174]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
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


On 2022/12/8 16:51, Leon Romanovsky wrote:
> On Thu, Dec 08, 2022 at 04:40:35PM +0800, Yang Yingliang wrote:
>> On 2022/12/8 15:56, Leon Romanovsky wrote:
>>> On Wed, Dec 07, 2022 at 09:25:40AM +0800, Yang Yingliang wrote:
>>>> It is not allowed to call consume_skb() from hardware interrupt context
>>>> or with interrupts being disabled. So replace dev_kfree_skb() with
>>>> dev_consume_skb_irq() under spin_lock_irqsave().
>>>>
>>>> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
>>>> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
>>>> ---
>>>> v1 -> v2:
>>>>     Add fix tag.
>>>> ---
>>>>    drivers/net/ethernet/neterion/s2io.c | 2 +-
>>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>>
>>>> diff --git a/drivers/net/ethernet/neterion/s2io.c b/drivers/net/ethernet/neterion/s2io.c
>>>> index 1d3c4474b7cb..a83d61d45936 100644
>>>> --- a/drivers/net/ethernet/neterion/s2io.c
>>>> +++ b/drivers/net/ethernet/neterion/s2io.c
>>>> @@ -2386,7 +2386,7 @@ static void free_tx_buffers(struct s2io_nic *nic)
>>>>    			skb = s2io_txdl_getskb(&mac_control->fifos[i], txdp, j);
>>>>    			if (skb) {
>>>>    				swstats->mem_freed += skb->truesize;
>>>> -				dev_kfree_skb(skb);
>>>> +				dev_consume_skb_irq(skb);
>>> And why did you use dev_consume_skb_irq() and not dev_kfree_skb_irq()?
>> I chose dev_consume_skb_irq(), because dev_kfree_skb() is consume_skb().
> Your commit message, title and actual change are totally misleading.
> You replaced *_kfree_* with *_consume_* while talking about running it
> in interrupts disabled context.
I didn't mention dev_kfree_skb() is same as consume_skb(), I can add it 
to my
commit message and send a new version.

Thanks,
Yang
>
> Thanks
>
>> Thanks,
>> Yang
>>> Thanks
>>>
>>>>    				cnt++;
>>>>    			}
>>>>    		}
>>>> -- 
>>>> 2.25.1
>>>>
>>> .
> .
