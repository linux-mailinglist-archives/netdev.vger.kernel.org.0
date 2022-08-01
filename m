Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0BD6586574
	for <lists+netdev@lfdr.de>; Mon,  1 Aug 2022 09:00:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229446AbiHAHAu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 03:00:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbiHAHAp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 03:00:45 -0400
Received: from forward501j.mail.yandex.net (forward501j.mail.yandex.net [IPv6:2a02:6b8:0:801:2::111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 103FB1839E
        for <netdev@vger.kernel.org>; Mon,  1 Aug 2022 00:00:37 -0700 (PDT)
Received: from vla5-4f2bb2e137e4.qloud-c.yandex.net (vla5-4f2bb2e137e4.qloud-c.yandex.net [IPv6:2a02:6b8:c18:3588:0:640:4f2b:b2e1])
        by forward501j.mail.yandex.net (Yandex) with ESMTP id D5BAA62372E;
        Mon,  1 Aug 2022 10:00:35 +0300 (MSK)
Received: by vla5-4f2bb2e137e4.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id 8yuJS9ZfiS-0YlWj9bc;
        Mon, 01 Aug 2022 10:00:35 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ya.ru; s=mail; t=1659337235;
        bh=pXVEcWTYas2lPpsUtu+H/3BBu/vYDdbdI4KKIES9OvQ=;
        h=In-Reply-To:Subject:References:Date:Message-ID:From:To;
        b=IHXrpvFCUpLDPk9jxkHHm4Lkjz0zNxdSouMAgwz14dY3RqIDgGViHUfUAgE0FyDB/
         UMUjqQuMuPHAqTiajsbaVkoGaEGH9HcCGfMhF9X8/Xd1rhGgXRXKnqsHt2mJVie9Xt
         1WnXRMRYZzrqYW2Bm28P00y1v8IAU4Uk1SgxSQwg=
Authentication-Results: vla5-4f2bb2e137e4.qloud-c.yandex.net; dkim=pass header.i=@ya.ru
Subject: Re: [PATCH] net: skb content must be visible for lockless skb_peek()
 and its variations
To:     Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
References: <de516124-ffd7-d159-2848-00c65a8573a8@ya.ru>
 <411a78f9aedc13cfba3ebf7790281f6c7046a172.camel@redhat.com>
From:   Kirill Tkhai <tkhai@ya.ru>
Message-ID: <37a0d4e5-0d40-ba8d-dd4e-5056c2c8e84d@ya.ru>
Date:   Mon, 1 Aug 2022 10:00:33 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <411a78f9aedc13cfba3ebf7790281f6c7046a172.camel@redhat.com>
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

On 01.08.2022 09:52, Paolo Abeni wrote:
> On Sun, 2022-07-31 at 23:39 +0300, Kirill Tkhai wrote:
>> From: Kirill Tkhai <tkhai@ya.ru>
>>
>> Currently, there are no barriers, and skb->xxx update may become invisible on cpu2.
>> In the below example var2 may point to intial_val0 instead of expected var1:
>>
>> [cpu1]					[cpu2]
>> skb->xxx = initial_val0;
>> ...
>> skb->xxx = var1;			skb = READ_ONCE(prev_skb->next);
>> <no barrier>				<no barrier>
>> WRITE_ONCE(prev_skb->next, skb);	var2 = skb->xxx;
>>
>> This patch adds barriers and fixes the problem. Note, that __skb_peek() is not patched,
>> since it's a lowlevel function, and a caller has to understand the things it does (and
>> also __skb_peek() is used under queue lock in some places).
>>
>> Signed-off-by: Kirill Tkhai <tkhai@ya.ru>
>> ---
>> Hi, David, Eric and other developers,
>>
>> picking unix sockets code I found this problem, 
> 
> Could you please report exactly how/where the problem maifests (e.g.
> the involved call paths/time sequence)?

I didn't get why call paths in the patch description are not enough for you. Please, explain
what you want.
 
>> and for me it looks like it exists. If there
>> are arguments that everything is OK and it's expected, please, explain.
> 
> I don't see why such barriers are needed for the locked peek/tail
> variants, as the spin_lock pair implies a full memory barrier.

This is for lockless skb_peek() calls and the patch is called in that way :). For locked skb_peek()
this is not needed. I'm not sure we need separate skb_peek() and skb_peek_lockless(). Do we?
