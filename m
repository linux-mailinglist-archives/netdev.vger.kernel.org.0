Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B3E958BCDA
	for <lists+netdev@lfdr.de>; Sun,  7 Aug 2022 22:18:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230127AbiHGUSG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Aug 2022 16:18:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229645AbiHGUSD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Aug 2022 16:18:03 -0400
Received: from forward502p.mail.yandex.net (forward502p.mail.yandex.net [IPv6:2a02:6b8:0:1472:2741:0:8b7:121])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 525D2614D
        for <netdev@vger.kernel.org>; Sun,  7 Aug 2022 13:18:01 -0700 (PDT)
Received: from sas1-0701b3ebb6ca.qloud-c.yandex.net (sas1-0701b3ebb6ca.qloud-c.yandex.net [IPv6:2a02:6b8:c08:21a5:0:640:701:b3eb])
        by forward502p.mail.yandex.net (Yandex) with ESMTP id D3D1FB812AE;
        Sun,  7 Aug 2022 23:17:55 +0300 (MSK)
Received: by sas1-0701b3ebb6ca.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id 5NXxPRi0q2-HshumCmS;
        Sun, 07 Aug 2022 23:17:55 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ya.ru; s=mail; t=1659903475;
        bh=k2rlELKItJsZv8EhkxuJfrxszX7Cy9xv6GZXD5LD/1I=;
        h=Cc:References:Date:Message-ID:In-Reply-To:To:From:Subject;
        b=EFYhAFMy0llqH0V3LM3n2Gw7hL8pPCfSvK5ttFG1u9FGCqLu1vxOK9f7dpxfN9xo5
         3skk9yoJXMTqeb5H2kVFnj6i+KXl4xvDb191W0GhVJYZMFXsLa14tqeUriilpN+T24
         29RRfHdeThh7rhae2cK7oGobvQWj5UF81PBUpNoQ=
Authentication-Results: sas1-0701b3ebb6ca.qloud-c.yandex.net; dkim=pass header.i=@ya.ru
Subject: Re: [PATCH] net: skb content must be visible for lockless skb_peek()
 and its variations
From:   Kirill Tkhai <tkhai@ya.ru>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
References: <de516124-ffd7-d159-2848-00c65a8573a8@ya.ru>
 <411a78f9aedc13cfba3ebf7790281f6c7046a172.camel@redhat.com>
 <37a0d4e5-0d40-ba8d-dd4e-5056c2c8e84d@ya.ru>
 <CANn89iJzB6TJ7HLg6Njp494p4gFo5n=4u2D4JT3qE3nNH7autg@mail.gmail.com>
 <ec94e091-5f9b-7795-a5e9-fba2fc3e393a@ya.ru>
Message-ID: <6aa849e4-3411-d71a-44a7-8ef927c1e270@ya.ru>
Date:   Sun, 7 Aug 2022 23:17:54 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <ec94e091-5f9b-7795-a5e9-fba2fc3e393a@ya.ru>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01.08.2022 21:45, Kirill Tkhai wrote:
> On 01.08.2022 10:39, Eric Dumazet wrote:
>> On Mon, Aug 1, 2022 at 9:00 AM Kirill Tkhai <tkhai@ya.ru> wrote:
>>>
>>> On 01.08.2022 09:52, Paolo Abeni wrote:
>>>> On Sun, 2022-07-31 at 23:39 +0300, Kirill Tkhai wrote:
>>>>> From: Kirill Tkhai <tkhai@ya.ru>
>>>>>
>>>>> Currently, there are no barriers, and skb->xxx update may become invisible on cpu2.
>>>>> In the below example var2 may point to intial_val0 instead of expected var1:
>>>>>
>>>>> [cpu1]                                       [cpu2]
>>>>> skb->xxx = initial_val0;
>>>>> ...
>>>>> skb->xxx = var1;                     skb = READ_ONCE(prev_skb->next);
>>>>> <no barrier>                         <no barrier>
>>>>> WRITE_ONCE(prev_skb->next, skb);     var2 = skb->xxx;
>>>>>
>>>>> This patch adds barriers and fixes the problem. Note, that __skb_peek() is not patched,
>>>>> since it's a lowlevel function, and a caller has to understand the things it does (and
>>>>> also __skb_peek() is used under queue lock in some places).
>>>>>
>>>>> Signed-off-by: Kirill Tkhai <tkhai@ya.ru>
>>>>> ---
>>>>> Hi, David, Eric and other developers,
>>>>>
>>>>> picking unix sockets code I found this problem,
>>>>
>>>> Could you please report exactly how/where the problem maifests (e.g.
>>>> the involved call paths/time sequence)?
>>>
>>> I didn't get why call paths in the patch description are not enough for you. Please, explain
>>> what you want.
>>>
>>>>> and for me it looks like it exists. If there
>>>>> are arguments that everything is OK and it's expected, please, explain.
>>>>
>>>> I don't see why such barriers are needed for the locked peek/tail
>>>> variants, as the spin_lock pair implies a full memory barrier.
>>>
>>> This is for lockless skb_peek() calls and the patch is called in that way :). For locked skb_peek()
>>> this is not needed. I'm not sure we need separate skb_peek() and skb_peek_lockless(). Do we?
>>
>> We prefer explicit _lockless variants to document the precise points
>> they are needed.
>>
>> A new helper (and its initial usage) will clearly point to the problem
>> you saw in af_unix.
> 
> The problem is:
> 
> unix_stream_sendmsg()	unix_stream_read_generic()
>   skb->len = size;	  skb = skb_peek();
>   skb_queue_tail(skb);	  unix_skb_len(skb); <- here we read wrong len

Oh, there are unix_state_lock(). Please, ignore this patch...
