Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6A055F204A
	for <lists+netdev@lfdr.de>; Sun,  2 Oct 2022 00:16:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229495AbiJAWQ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Oct 2022 18:16:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiJAWQ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Oct 2022 18:16:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43D525A829
        for <netdev@vger.kernel.org>; Sat,  1 Oct 2022 15:16:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EF0B6B80B07
        for <netdev@vger.kernel.org>; Sat,  1 Oct 2022 22:16:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8515C433C1;
        Sat,  1 Oct 2022 22:16:21 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="FbYXMh7W"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1664662580;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BLxZtMdrPKLvV9Ue1pSrPntloJcpH2QGnu49hNbPCME=;
        b=FbYXMh7WdcxhDeL6bbwrK/1mBHP2GZLpKcFJz7xn9BC1Hd/R47cPNSCjiyCJ+YzY2jAC4A
        05bABw1zZdvpTesDXM4tkU1NfhZPlpLRHyPzwa2EIVgqMRGlnw3JaN4h3zT3QeXEYgwD1p
        Tdbisx2LrIrjuE/NFV1iVw2d4USLEsg=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id f2abe0f4 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Sat, 1 Oct 2022 22:16:19 +0000 (UTC)
Date:   Sun, 2 Oct 2022 00:16:17 +0200
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Dworken <ddworken@google.com>,
        Willem de Bruijn <willemb@google.com>,
        "David S. Miller" <davem@davemloft.net>, bigeasy@linutronix.de
Subject: Re: 126 ms irqsoff Latency - Possibly due to commit 190cc82489f4
 ("tcp: change source port randomizarion at connect() time")
Message-ID: <Yzi8Md2tkSYDnF1B@zx2c4.com>
References: <03a06114-bc63-bc01-be38-535bcc394612@csgroup.eu>
 <CANn89iKzfzOUPc+g0Brfzyi2efnXE0jLUebBz5fQMWVt9UCtfA@mail.gmail.com>
 <CANn89iLAEYBaoYajy0Y9UmGFff5GPxDUoG-ErVB2jDdRNQ5Tug@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CANn89iLAEYBaoYajy0Y9UmGFff5GPxDUoG-ErVB2jDdRNQ5Tug@mail.gmail.com>
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

(CC+Sebastian)

Hi Eric, Christophe,

I'm trying to understand the context of this and whether/why there's a
problem. Some overview on how get_random_bytes() works:

Most of the time, get_random_bytes() is completely lockless and operates
over per-CPU data structures. get_random_bytes() calls
_get_random_bytes(), which calls crng_make_state(), and then operates
over stack data to churn out some random bytes. crng_make_state() is
where all the meat happens.

In crng_make_state(), there are three unlikely conditionals where locks
are taken. The first is:

    if (!crng_ready()) {
        ... do some expensive things involving locks ...
	... but only during early boot before the rng is initialized ...
    }

The second one is:

    if (unlikely(time_is_before_jiffies(READ_ONCE(base_crng.birth) + crng_reseed_interval()))) {
        ... do something less expensive involving locks ...
	... which happens approximately once per minute ...
    }

The third one is:

    if (unlikely(crng->generation != READ_ONCE(base_crng.generation))) {
        ... do something even less expensive involving locks ...
	... which happens when after a different cpu hit the above ...
    }

So all three of these conditions are pretty darn unlikely, with the
exception of the first one that happens all the time during early boot
before the RNG is initialized, after which it is static-branched out and
never triggers again. So as far as /locks/ are concerned, things should
be good here.

However, in order to operate on per-cpu data, and therefore be lockless
most of the time, it does take a "local lock", which is basically just
disabling interrupts on non-RT to do a short operation:

    local_lock_irqsave(&crngs.lock, flags);
    crng = raw_cpu_ptr(&crngs);
    crng_fast_key_erasure(...);
    local_unlock_irqrestore(&crngs.lock, flags);

crng_fast_key_erasure(), in turn, computes a single block of chacha20,
which should be relatively fast. So the critical section is very short
there.

The reason that's local_lock_irqsave() rather than local_lock() (which
would only disable preemption, I believe), is because IRQ handlers are
supposed to be able to have access to random bytes too. It seems like it
wouldn't be a super nice thing to remove that capability.

It might be possible to double the amount of per-cpu data and have a
separate state for IRQ than for non-IRQ, but that seems kind of wasteful
and complex/hairy to implement.

So that leads me to wonder more about the context: why does this matter?
It looks like you're hitting this from a DO_ONCE() thing, which are
usually only hit, as the name says, once, and then incur the overhead of
firing off a worker to change the once-static-branch, which means
DO_ONCE()es aren't very fast anyway? Or does that not accurately reflect
what's happening?

I'll also CC Sebastian here, who worked with me on that local lock and
might have some insights on IRQ latency as well.

Regards,
Jason
