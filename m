Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 157AD4BCD61
	for <lists+netdev@lfdr.de>; Sun, 20 Feb 2022 09:49:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241053AbiBTItR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Feb 2022 03:49:17 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235445AbiBTItR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Feb 2022 03:49:17 -0500
Received: from smtp.smtpout.orange.fr (smtp06.smtpout.orange.fr [80.12.242.128])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69D2554BCB
        for <netdev@vger.kernel.org>; Sun, 20 Feb 2022 00:48:56 -0800 (PST)
Received: from [192.168.1.18] ([90.126.236.122])
        by smtp.orange.fr with ESMTPA
        id LhtknwpeDuCn2Lhtlnufcr; Sun, 20 Feb 2022 09:48:54 +0100
X-ME-Helo: [192.168.1.18]
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Sun, 20 Feb 2022 09:48:54 +0100
X-ME-IP: 90.126.236.122
Message-ID: <a4006848-3dfe-8511-5010-37daa31df464@wanadoo.fr>
Date:   Sun, 20 Feb 2022 09:48:52 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] ravb: Use GFP_KERNEL instead of GFP_ATOMIC when possible
Content-Language: en-US
To:     Biju Das <biju.das.jz@bp.renesas.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>
References: <3d67f0369909010d620bd413c41d11b302eb0ff8.1645342015.git.christophe.jaillet@wanadoo.fr>
 <OS0PR01MB5922D806D40856485CDD612086399@OS0PR01MB5922.jpnprd01.prod.outlook.com>
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
In-Reply-To: <OS0PR01MB5922D806D40856485CDD612086399@OS0PR01MB5922.jpnprd01.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 20/02/2022 à 08:53, Biju Das a écrit :
> Hi Christophe,
> 
> Thanks for the patch.
> 
> Just a  question, As per [1], former can be allocated from interrupt context.
> But nothing mentioned for the allocation using the patch you mentioned[2]. I agree GFP_KERNEL
> gives more opportunities of successful allocation.

Hi,

netdev_alloc_skb() uses an implicit GFP_ATOMIC, that is why it can be 
safely called from an interrupt context.
__netdev_alloc_skb() is the same as netdev_alloc_skb(), except that you 
can choose the GFP flag you want to use. ([1])

Here, the netdev_alloc_skb() is called just after some 
"kcalloc(GFP_KERNEL);"

So this function can already NOT be called from interrupt context.

So if GFP_KERNEL is fine here for kcalloc(), it is fine also for 
netdev_alloc_skb(), hence __netdev_alloc_skb(GFP_KERNEL).

> 
> Q1) Here it allocates 8K instead of 1K on each loop, Is there any limitation for netdev_alloc_skb for allocating 8K size?

Not sure to understand.
My patch does NOT change anything on the amount of memory allocated. it 
only changes a GFP_ATOMIC into a GFP_KERNEL.

I'm not aware of specific limitation for netdev_alloc_skb().
My understanding is that in the worst case, it will behave just like 
malloc() ([3])

So, if it was an issue before, it is still an issue after my patch.

> Q2) In terms of allocation performance which is better netdev_alloc_skb or __netdev_alloc_skb?

AFAIK, there should be no difference, but __netdev_alloc_skb(GFP_KERNEL) 
can succeed where netdev_alloc_skb() can fail. In such a case, it would 
be slower but most importantly, it would succeed.


CJ

[1]: 
https://elixir.bootlin.com/linux/v5.17-rc4/source/include/linux/skbuff.h#L2945

[2]: 
https://elixir.bootlin.com/linux/v5.17-rc4/source/drivers/net/ethernet/renesas/ravb_main.c#L470

[3]: 
https://elixir.bootlin.com/linux/v5.17-rc3/source/net/core/skbuff.c#L488


> 
> [1] https://www.kernel.org/doc/htmldocs/networking/API-netdev-alloc-skb.html
> [2] https://www.kernel.org/doc/htmldocs/networking/API---netdev-alloc-skb.html
> 
> Regards,
> Biju
> 
>> Subject: [PATCH] ravb: Use GFP_KERNEL instead of GFP_ATOMIC when possible
>>
>> 'max_rx_len' can be up to GBETH_RX_BUFF_MAX (i.e. 8192) (see
>> 'gbeth_hw_info').
>> The default value of 'num_rx_ring' can be BE_RX_RING_SIZE (i.e. 1024).
>>
>> So this loop can allocate 8 Mo of memory.
>>
>> Previous memory allocations in this function already use GFP_KERNEL, so
>> use __netdev_alloc_skb() and an explicit GFP_KERNEL instead of a implicit
>> GFP_ATOMIC.
>>
>> This gives more opportunities of successful allocation.
>>
>> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>> ---
>>   drivers/net/ethernet/renesas/ravb_main.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/ethernet/renesas/ravb_main.c
>> b/drivers/net/ethernet/renesas/ravb_main.c
>> index 24e2635c4c80..525d66f71f02 100644
>> --- a/drivers/net/ethernet/renesas/ravb_main.c
>> +++ b/drivers/net/ethernet/renesas/ravb_main.c
>> @@ -475,7 +475,7 @@ static int ravb_ring_init(struct net_device *ndev, int
>> q)
>>   		goto error;
>>
>>   	for (i = 0; i < priv->num_rx_ring[q]; i++) {
>> -		skb = netdev_alloc_skb(ndev, info->max_rx_len);
>> +		skb = __netdev_alloc_skb(ndev, info->max_rx_len, GFP_KERNEL);
>>   		if (!skb)
>>   			goto error;
>>   		ravb_set_buffer_align(skb);
>> --
>> 2.32.0
> 
> 

