Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F57A5B1C70
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 14:11:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231561AbiIHMKN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 08:10:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230481AbiIHMJc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 08:09:32 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F14E11C168;
        Thu,  8 Sep 2022 05:09:12 -0700 (PDT)
Received: from canpemm500006.china.huawei.com (unknown [172.30.72.55])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4MNdCg4N2KzHnj3;
        Thu,  8 Sep 2022 20:07:11 +0800 (CST)
Received: from [10.174.179.200] (10.174.179.200) by
 canpemm500006.china.huawei.com (7.192.105.130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 8 Sep 2022 20:09:07 +0800
Subject: Re: [PATCH 2/2] can: bcm: check the result of can_send() in
 bcm_can_tx()
To:     Oliver Hartkopp <socketcan@hartkopp.net>, <mkl@pengutronix.de>,
        <edumazet@google.com>, <kuba@kernel.org>,
        <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>
References: <cover.1662606045.git.william.xuanziyang@huawei.com>
 <5c0f2f1bd1dc7bbb9500afd4273e36378e00a35d.1662606045.git.william.xuanziyang@huawei.com>
 <1caf3e52-c862-e702-c833-153f130b790a@hartkopp.net>
From:   "Ziyang Xuan (William)" <william.xuanziyang@huawei.com>
Message-ID: <88a5cdf5-d8e3-3822-7864-80aecf3c4ac3@huawei.com>
Date:   Thu, 8 Sep 2022 20:09:06 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <1caf3e52-c862-e702-c833-153f130b790a@hartkopp.net>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.200]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 canpemm500006.china.huawei.com (7.192.105.130)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Sorry, but NACK.
> 
> The curr_frame counter handles the sequence counter of multiplex messages.
> 
> Even when this single send attempt failed the curr_frame counter has to continue.
> 
> For that reason the comment about statistics *before* the curr_frame++ might be misleading.
> 
> A potential improvement could be:
> 
>     if (!(can_send(skb, 1)))
>         op->frames_abs++;
> 
>     op->currframe++;
> 
> But as op->frames_abs is a functional unused(!) value for tx ops and only displayed via procfs I would NOT tag such improvement as a 'fix' which might then be queued up for stable.
> 
I will modify and remove 'Fixes' tag in v2.

Thank you for your review.

> This could be something for the can-next tree ...
> 
> Best regards,
> Oliver
> 
> 
> On 08.09.22 05:04, Ziyang Xuan wrote:
>> If can_send() fail, it should not update statistics in bcm_can_tx().
>> Add the result check for can_send() in bcm_can_tx().
>>
>> Fixes: ffd980f976e7 ("[CAN]: Add broadcast manager (bcm) protocol")
>> Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
>> ---
>>   net/can/bcm.c | 3 ++-
>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/net/can/bcm.c b/net/can/bcm.c
>> index e2783156bfd1..8f5d704a409f 100644
>> --- a/net/can/bcm.c
>> +++ b/net/can/bcm.c
>> @@ -298,7 +298,8 @@ static void bcm_can_tx(struct bcm_op *op)
>>       /* send with loopback */
>>       skb->dev = dev;
>>       can_skb_set_owner(skb, op->sk);
>> -    can_send(skb, 1);
>> +    if (can_send(skb, 1))
>> +        goto out;
>>         /* update statistics */
>>       op->currframe++;
> .
