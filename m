Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF56B58707A
	for <lists+netdev@lfdr.de>; Mon,  1 Aug 2022 20:45:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233181AbiHASpV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 14:45:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232842AbiHASpU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 14:45:20 -0400
X-Greylist: delayed 79533 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 01 Aug 2022 11:45:17 PDT
Received: from forward501j.mail.yandex.net (forward501j.mail.yandex.net [5.45.198.251])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB6F9115B
        for <netdev@vger.kernel.org>; Mon,  1 Aug 2022 11:45:17 -0700 (PDT)
Received: from iva1-adaa4d2a0364.qloud-c.yandex.net (iva1-adaa4d2a0364.qloud-c.yandex.net [IPv6:2a02:6b8:c0c:a0e:0:640:adaa:4d2a])
        by forward501j.mail.yandex.net (Yandex) with ESMTP id 443D9623240;
        Mon,  1 Aug 2022 21:45:15 +0300 (MSK)
Received: by iva1-adaa4d2a0364.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id xrpxCZ2PY5-jEhWT33Z;
        Mon, 01 Aug 2022 21:45:14 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ya.ru; s=mail; t=1659379514;
        bh=4whM0yQX0GEYWoS6B3rd6i4gGhqRl1hv8R0Wi9WAhmg=;
        h=Cc:References:Date:Message-ID:In-Reply-To:From:To:Subject;
        b=fjT0G6MDOFURHDvg52bnhI11G8X4oqVI/VP5q7L2tg7pS8SUI6orHqrvAtkENSoqH
         o1cLwKtPDXezJFu5HnAmUFJGaH8W6asKpUlPS0yRSGCEIncLT7HW8iDV/no/KAkio5
         LBnnsqY2cpawvNn9+kAE628c5ksBE742romgNTeQ=
Authentication-Results: iva1-adaa4d2a0364.qloud-c.yandex.net; dkim=pass header.i=@ya.ru
Subject: Re: [PATCH] net: skb content must be visible for lockless skb_peek()
 and its variations
To:     Eric Dumazet <edumazet@google.com>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
References: <de516124-ffd7-d159-2848-00c65a8573a8@ya.ru>
 <411a78f9aedc13cfba3ebf7790281f6c7046a172.camel@redhat.com>
 <37a0d4e5-0d40-ba8d-dd4e-5056c2c8e84d@ya.ru>
 <CANn89iJzB6TJ7HLg6Njp494p4gFo5n=4u2D4JT3qE3nNH7autg@mail.gmail.com>
From:   Kirill Tkhai <tkhai@ya.ru>
Message-ID: <ec94e091-5f9b-7795-a5e9-fba2fc3e393a@ya.ru>
Date:   Mon, 1 Aug 2022 21:45:13 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <CANn89iJzB6TJ7HLg6Njp494p4gFo5n=4u2D4JT3qE3nNH7autg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01.08.2022 10:39, Eric Dumazet wrote:
> On Mon, Aug 1, 2022 at 9:00 AM Kirill Tkhai <tkhai@ya.ru> wrote:
>>
>> On 01.08.2022 09:52, Paolo Abeni wrote:
>>> On Sun, 2022-07-31 at 23:39 +0300, Kirill Tkhai wrote:
>>>> From: Kirill Tkhai <tkhai@ya.ru>
>>>>
>>>> Currently, there are no barriers, and skb->xxx update may become invisible on cpu2.
>>>> In the below example var2 may point to intial_val0 instead of expected var1:
>>>>
>>>> [cpu1]                                       [cpu2]
>>>> skb->xxx = initial_val0;
>>>> ...
>>>> skb->xxx = var1;                     skb = READ_ONCE(prev_skb->next);
>>>> <no barrier>                         <no barrier>
>>>> WRITE_ONCE(prev_skb->next, skb);     var2 = skb->xxx;
>>>>
>>>> This patch adds barriers and fixes the problem. Note, that __skb_peek() is not patched,
>>>> since it's a lowlevel function, and a caller has to understand the things it does (and
>>>> also __skb_peek() is used under queue lock in some places).
>>>>
>>>> Signed-off-by: Kirill Tkhai <tkhai@ya.ru>
>>>> ---
>>>> Hi, David, Eric and other developers,
>>>>
>>>> picking unix sockets code I found this problem,
>>>
>>> Could you please report exactly how/where the problem maifests (e.g.
>>> the involved call paths/time sequence)?
>>
>> I didn't get why call paths in the patch description are not enough for you. Please, explain
>> what you want.
>>
>>>> and for me it looks like it exists. If there
>>>> are arguments that everything is OK and it's expected, please, explain.
>>>
>>> I don't see why such barriers are needed for the locked peek/tail
>>> variants, as the spin_lock pair implies a full memory barrier.
>>
>> This is for lockless skb_peek() calls and the patch is called in that way :). For locked skb_peek()
>> this is not needed. I'm not sure we need separate skb_peek() and skb_peek_lockless(). Do we?
> 
> We prefer explicit _lockless variants to document the precise points
> they are needed.
> 
> A new helper (and its initial usage) will clearly point to the problem
> you saw in af_unix.

The problem is:

unix_stream_sendmsg()	unix_stream_read_generic()
  skb->len = size;	  skb = skb_peek();
  skb_queue_tail(skb);	  unix_skb_len(skb); <- here we read wrong len

 
> BTW, smp_mb__after_spinlock() in your patch does not really make sense to me.
> Please add in your changelog the precise issue you are seeing.

What is about queue part, do you recommend to have a separate helper for that?
skb_queue_tail_for_lockless()?
