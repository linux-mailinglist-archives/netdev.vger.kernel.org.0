Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 392C75F1E7E
	for <lists+netdev@lfdr.de>; Sat,  1 Oct 2022 20:00:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229595AbiJAR7B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Oct 2022 13:59:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbiJAR67 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Oct 2022 13:58:59 -0400
Received: from mail-yw1-x1134.google.com (mail-yw1-x1134.google.com [IPv6:2607:f8b0:4864:20::1134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3C133B96F
        for <netdev@vger.kernel.org>; Sat,  1 Oct 2022 10:58:58 -0700 (PDT)
Received: by mail-yw1-x1134.google.com with SMTP id 00721157ae682-345528ceb87so72584537b3.11
        for <netdev@vger.kernel.org>; Sat, 01 Oct 2022 10:58:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=RHJMlZ5OGL8HnTv7SAxdXpropECpS+4W9KAJOZkErP8=;
        b=WeUnYL+pLBvPkMOtEJ9BxDQAYfGoup65PbgCzY1Xae3w91hPZlWpB+Gw+DzvDrsobL
         7y2/1FrdeKd4RLNeMrXSxuPTVSs8BeVwijeRQAqQmnuPjzxMRLJylWzgpnrH2EmuUyAQ
         /OOSYucl55pfy3b0s4LMZ7b5O/fnNSjeOw0ZCfbuD6C2DDXLy8hITTJbotNKn9I1yPYy
         7F44JuX6Q+B/kfUjysptN7bTVmHO7liVv2Kqdf6f+bnZLwerXN1vj6Jwb+f2Pwk7b67J
         POD23CFkBbuSFcK3FFxrF+xoODdo8I66NfOKPn7uFNzskC/EcJQtwu1e/i5XP10z8XxK
         W3wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=RHJMlZ5OGL8HnTv7SAxdXpropECpS+4W9KAJOZkErP8=;
        b=RpudYtFR4kWcHeMxgxvd12yy9zpchcjJ6IdFKNHeW/f+N+hH7/yhZ2GuCyG4cgur9F
         URjBqJod6GzssE0F19MHaKcUetdgW4LXAyzZwFm9jJznTUwi/2xbhUUVe3kL6NQYKNsZ
         Q7yhc7o2vqUDTykFaoyPnYp+pb8GgKJHQAkXi8v4faodHEVmPIYzj8C1eHMai/0m+Kju
         wJPOlhC0opQmWQdAPqVmkgLEy+CXNLPOCn303hd+A2xwan7DDz7zs0NKob8p/p0FFoxA
         WDeWJhGxeeRUihWn8QzQw6m0mkcHAeKs8oGrQNAyfDaFlrNKGlMcIHKNlG3swyr+9S9F
         7FMQ==
X-Gm-Message-State: ACrzQf1F9BUc3PXA/M3troMe5q9ksdi+ZGEt09BCTO1U5AbLmqpZJsQT
        XKKma8xmMij6Lk7PKJRxdLxWUCB4QcYikbsUvIljyA==
X-Google-Smtp-Source: AMsMyM50dVcxdoFgBI4rTCSdDQc+5mJ8+Vz/ZPqytu7hHmi0nwiuyO7LRUcZm+hiJPcYWc5NaTkwhBUYSNYWJJGesgs=
X-Received: by 2002:a81:48d6:0:b0:355:8d0a:d8a1 with SMTP id
 v205-20020a8148d6000000b003558d0ad8a1mr10943366ywa.467.1664647137841; Sat, 01
 Oct 2022 10:58:57 -0700 (PDT)
MIME-Version: 1.0
References: <03a06114-bc63-bc01-be38-535bcc394612@csgroup.eu> <CANn89iKzfzOUPc+g0Brfzyi2efnXE0jLUebBz5fQMWVt9UCtfA@mail.gmail.com>
In-Reply-To: <CANn89iKzfzOUPc+g0Brfzyi2efnXE0jLUebBz5fQMWVt9UCtfA@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Sat, 1 Oct 2022 10:58:46 -0700
Message-ID: <CANn89iLAEYBaoYajy0Y9UmGFff5GPxDUoG-ErVB2jDdRNQ5Tug@mail.gmail.com>
Subject: Re: 126 ms irqsoff Latency - Possibly due to commit 190cc82489f4
 ("tcp: change source port randomizarion at connect() time")
To:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Dworken <ddworken@google.com>,
        Willem de Bruijn <willemb@google.com>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 1, 2022 at 10:43 AM Eric Dumazet <edumazet@google.com> wrote:
>
> On Sat, Oct 1, 2022 at 10:16 AM Christophe Leroy
> <christophe.leroy@csgroup.eu> wrote:
> >
> > Hi,
> >
> > With recent kernels I have a huge irqsoff latency in my boards, shortly
> > after startup, from the call to net_get_random_once() in
> > __inet_hash_connect().
> >
> > On a non instrumented kernel, IRQs are disabled during approximately 80
> > milliseconds. With the traces in goes to 126 milliseconds.
> >
> > Was apparently introduced by commit 190cc82489f4 ("tcp: change source
> > port randomizarion at connect() time")
> >
> > Trace below.
> >
> > Would there be a way to perform the call to get_random_bytes() without
> > disabling IRQ ?
>
> This looks a question for drivers/char/random.c maintainer, because we
> do not block interrupts at this point in __inet_hash_connect()

Oh well, this is probably coming from __do_once_start() / __do_once_done()

We need something better for process contexts...


>
>
>
>
> >
> > Thanks
> > Christophe
> >
> > # tracer: irqsoff
> > #
> > # irqsoff latency trace v1.1.5 on 6.0.0-rc5-s3k-dev-02351-gebc95f69a7d4
> > # --------------------------------------------------------------------
> > # latency: 126337 us, #8207/8207, CPU#0 | (M:preempt VP:0, KP:0, SP:0 HP:0)
> > #    -----------------
> > #    | task: CORSurv-352 (uid:0 nice:0 policy:0 rt_prio:0)
> > #    -----------------
> > #  => started at: _raw_spin_lock_irqsave
> > #  => ended at:   _raw_spin_unlock_irqrestore
> > #
> > #
> > #                    _------=> CPU#
> > #                   / _-----=> irqs-off/BH-disabled
> > #                  | / _----=> need-resched
> > #                  || / _---=> hardirq/softirq
> > #                  ||| / _--=> preempt-depth
> > #                  |||| / _-=> migrate-disable
> > #                  ||||| /     delay
> > #  cmd     pid     |||||| time  |   caller
> > #     \   /        ||||||  \    |    /
> >   CORSurv-352       0d....    4us : _raw_spin_lock_irqsave
> >   CORSurv-352       0d....   13us+: preempt_count_add
> > <-_raw_spin_lock_irqsave
> >   CORSurv-352       0d..1.   25us+: do_raw_spin_lock
> > <-_raw_spin_lock_irqsave
> >   CORSurv-352       0d..1.   36us : get_random_bytes <-__inet_hash_connect
> >   CORSurv-352       0d..1.   45us : _get_random_bytes.part.0
> > <-__inet_hash_connect
> >   CORSurv-352       0d..1.   55us : crng_make_state
> > <-_get_random_bytes.part.0
> >   CORSurv-352       0d..1.   65us+: ktime_get_seconds <-crng_make_state
> >   CORSurv-352       0d..1.   77us+: crng_fast_key_erasure <-crng_make_state
> >   CORSurv-352       0d..1.   89us+: chacha_block_generic
> > <-crng_fast_key_erasure
> >   CORSurv-352       0d..1.  101us+: chacha_permute <-chacha_block_generic
> >   CORSurv-352       0d..1.  129us : chacha_block_generic
> > <-_get_random_bytes.part.0
> >   CORSurv-352       0d..1.  139us+: chacha_permute <-chacha_block_generic
> >   CORSurv-352       0d..1.  160us : chacha_block_generic
> > <-_get_random_bytes.part.0
> >   CORSurv-352       0d..1.  170us+: chacha_permute <-chacha_block_generic
> >   CORSurv-352       0d..1.  191us : chacha_block_generic
> > <-_get_random_bytes.part.0
> >   CORSurv-352       0d..1.  200us+: chacha_permute <-chacha_block_generic
> >   CORSurv-352       0d..1.  221us : chacha_block_generic
> > <-_get_random_bytes.part.0
> >   CORSurv-352       0d..1.  231us+: chacha_permute <-chacha_block_generic
> >
> >         8182 x the above two line
> >
>
> It seems hard irqs are blocked for short periods, no worries here.
>
> But perhaps your problem is a lack of cond_resched() in a long loop
> (_get_random_bytes() I guess)
>
> Problem is : I do not think _get_random_bytes() can always schedule,
> we probably would need to add
> extra parameters.
>
> >   CORSurv-352       0d..1. 126275us : chacha_block_generic
> > <-_get_random_bytes.part.0
> >   CORSurv-352       0d..1. 126285us+: chacha_permute <-chacha_block_generic
> >   CORSurv-352       0d..1. 126309us : _raw_spin_unlock_irqrestore
> > <-__do_once_done
> >   CORSurv-352       0d..1. 126318us+: do_raw_spin_unlock
> > <-_raw_spin_unlock_irqrestore
> >   CORSurv-352       0d..1. 126330us+: _raw_spin_unlock_irqrestore
> >   CORSurv-352       0d..1. 126346us+: trace_hardirqs_on
> > <-_raw_spin_unlock_irqrestore
> >   CORSurv-352       0d..1. 126387us : <stack trace>
> >   => tcp_v4_connect
> >   => __inet_stream_connect
> >   => inet_stream_connect
> >   => __sys_connect
> >   => system_call_exception
> >   => ret_from_syscall
