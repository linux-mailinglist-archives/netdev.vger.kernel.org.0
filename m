Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB44E587077
	for <lists+netdev@lfdr.de>; Mon,  1 Aug 2022 20:43:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233181AbiHASnC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 14:43:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233212AbiHASnB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 14:43:01 -0400
X-Greylist: delayed 350 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 01 Aug 2022 11:42:59 PDT
Received: from forward500p.mail.yandex.net (forward500p.mail.yandex.net [IPv6:2a02:6b8:0:1472:2741:0:8b7:110])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D029515714
        for <netdev@vger.kernel.org>; Mon,  1 Aug 2022 11:42:59 -0700 (PDT)
Received: from vla1-62318bfe5573.qloud-c.yandex.net (vla1-62318bfe5573.qloud-c.yandex.net [IPv6:2a02:6b8:c0d:3819:0:640:6231:8bfe])
        by forward500p.mail.yandex.net (Yandex) with ESMTP id 41DEAF01EE3;
        Mon,  1 Aug 2022 21:37:06 +0300 (MSK)
Received: by vla1-62318bfe5573.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id VdLiXzFHnn-b5iqSYdA;
        Mon, 01 Aug 2022 21:37:05 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ya.ru; s=mail; t=1659379025;
        bh=mHyJbrw3ldr7Aps6WpDUY7P2MeMFLqKArrJPy3+zkvE=;
        h=In-Reply-To:Subject:References:Date:Message-ID:From:To;
        b=Rrfu8Fxlz+0uuRTbXZ4wD21kqoxpJ7bLdoTXq2uv7qt2E3rBR2SpUyPjN6PrtMJzi
         evfO8rx93+cPKAuYG+nshPPl78E8ouGWAtY+tCfehrgO/rj+EeENieDbDHQJzew4S6
         steFRq7fgOeBdIZz7/e1uEJbcq7qdi/5ydN9OROs=
Authentication-Results: vla1-62318bfe5573.qloud-c.yandex.net; dkim=pass header.i=@ya.ru
Subject: Re: [PATCH] net: skb content must be visible for lockless skb_peek()
 and its variations
To:     Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
References: <de516124-ffd7-d159-2848-00c65a8573a8@ya.ru>
 <411a78f9aedc13cfba3ebf7790281f6c7046a172.camel@redhat.com>
 <37a0d4e5-0d40-ba8d-dd4e-5056c2c8e84d@ya.ru>
 <baea599f33ba06873a15fadf4e84a704feaaa652.camel@redhat.com>
From:   Kirill Tkhai <tkhai@ya.ru>
Message-ID: <26921b69-6f15-a233-9401-acf9bce65ba0@ya.ru>
Date:   Mon, 1 Aug 2022 21:37:05 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <baea599f33ba06873a15fadf4e84a704feaaa652.camel@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01.08.2022 12:59, Paolo Abeni wrote:
> On Mon, 2022-08-01 at 10:00 +0300, Kirill Tkhai wrote:
>> On 01.08.2022 09:52, Paolo Abeni wrote:
>>> On Sun, 2022-07-31 at 23:39 +0300, Kirill Tkhai wrote:
>>>> From: Kirill Tkhai <tkhai@ya.ru>
>>>>
>>>> Currently, there are no barriers, and skb->xxx update may become invisible on cpu2.
>>>> In the below example var2 may point to intial_val0 instead of expected var1:
>>>>
>>>> [cpu1]					[cpu2]
>>>> skb->xxx = initial_val0;
>>>> ...
>>>> skb->xxx = var1;			skb = READ_ONCE(prev_skb->next);
>>>> <no barrier>				<no barrier>
>>>> WRITE_ONCE(prev_skb->next, skb);	var2 = skb->xxx;
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
> 
> You mentioned the unix socket, so I expect to see something alike (I'm
> totally making up the symbols lists just to give an example): 
> 
> CPU0					CPU1
> unix_stream_read_generic()		unix_stream_sendmsg()
> skb_peek()				skb_queue_tail(other->sk_receive_queue)
> 
> plus some wording on how the critical race is reached, if not
> completely obvious.

Ah, you mean specific functions. Yes, this example and the rest of places, skb_peek{,tail} are
used without queue lock, e.g., unix_stream_data_wait().
 
>>  
>>>> and for me it looks like it exists. If there
>>>> are arguments that everything is OK and it's expected, please, explain.
>>>
>>> I don't see why such barriers are needed for the locked peek/tail
>>> variants, as the spin_lock pair implies a full memory barrier.
>>
>> This is for lockless skb_peek() calls and the patch is called in that way :). For locked skb_peek()
>> this is not needed. 
> 
> But you are also unconditioanlly adding barriers to the locked
> append/enqueue functions - which would possibly make sense only when
> the latters are paired with lockless read access.
> 
> As Eric said, if any new barrier is needed, we want to apply it only
> where needed, and not to every skb_queue*()/skb_peek() user, so very
> likely a new helper (o a new pair of helpers) will be needed.

Ok, thanks, Paolo.

Kirill
