Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4D5D5F1E6F
	for <lists+netdev@lfdr.de>; Sat,  1 Oct 2022 19:43:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229516AbiJARns (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Oct 2022 13:43:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiJARnr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Oct 2022 13:43:47 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4B14657C
        for <netdev@vger.kernel.org>; Sat,  1 Oct 2022 10:43:46 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id j7so8758045ybb.8
        for <netdev@vger.kernel.org>; Sat, 01 Oct 2022 10:43:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=K7RL4KHqHxuZwmWsZ29nGLrAAVcPUdpk3QwdLJk41Mo=;
        b=KkKJSaE8BKJykxZGc4y0IBg7xCoQrvmZ9CplhEiShGPNXoEOGr9biGs/8ZRZRoyPp1
         dHko8eA5JZb6fG4WrlxG7/xjSfAQeGB58mtYocFLbLDdkPcMikjBnzyO/3Z+A4J0uD2R
         GHEEE5IzUMMYfoZr5ZHiQlz4ho7VKSmHeJQJvK6IRdlxB9+SbMK8Lc+a5GD2nLMqF4O3
         wnghie4hq7n1IBrxgipSYz5qcJX5mdY2KdmfvEkv0IHMtCxyeZmOKPaOGoosCWhuhrBu
         FgMT4EtZCjgkHP9ai/hauJf8pShlzcr7qrDQeUyvgQQOEucDrIw3si9BE+CsLuXwL8iv
         IOxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=K7RL4KHqHxuZwmWsZ29nGLrAAVcPUdpk3QwdLJk41Mo=;
        b=zuV4kNBeaAnAQDHrWUlo9zh1diBdKQ7y+ejSDMn6SOCgOUu53fA5byrxgTHwBhXVJu
         XumHfxRhdeywQkvfWWH+TpvXDKwEd/8BiEDJLODyY2+uM7AFyifHfY3vjIkPFSYZ+fF2
         ualRrfabUR+SNlU8SuwNaa+JzCfRKm9gofLJxgXJkbk5DqSDVGu4m3bTbZPOFNphycOQ
         tuoZMYw7H57EdqpIZmVNhTyfrcYOfDSgNjFXoir/2bBOOnct0Wekb2FTlYxUyNsOQ+hr
         c7PK7j+yKkjto3IuFOep7SIGxoHu4DvwGni2oW3wgFYYjpDQUM2adRwzUYEsk3UoD58+
         Y7zw==
X-Gm-Message-State: ACrzQf3XZesthslWJK8mfHXnLDKnPm+O3eKc7GMWEXGRYZKDbcFJZhDc
        l/zaC+8DGGk5rzljGLALox5iB95nUsV+/PDTbEnLwZ51CIu36w==
X-Google-Smtp-Source: AMsMyM4UNSvOh3aWinm2fQ8iFvdnsPF1w1Y1gT4FvHsh3ypkVTW58g3yznBhklaeUBKXqGv2wXofTBVJZRKpXKviOnU=
X-Received: by 2002:a25:7a01:0:b0:6b0:820:dd44 with SMTP id
 v1-20020a257a01000000b006b00820dd44mr12276041ybc.387.1664646225645; Sat, 01
 Oct 2022 10:43:45 -0700 (PDT)
MIME-Version: 1.0
References: <03a06114-bc63-bc01-be38-535bcc394612@csgroup.eu>
In-Reply-To: <03a06114-bc63-bc01-be38-535bcc394612@csgroup.eu>
From:   Eric Dumazet <edumazet@google.com>
Date:   Sat, 1 Oct 2022 10:43:34 -0700
Message-ID: <CANn89iKzfzOUPc+g0Brfzyi2efnXE0jLUebBz5fQMWVt9UCtfA@mail.gmail.com>
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

On Sat, Oct 1, 2022 at 10:16 AM Christophe Leroy
<christophe.leroy@csgroup.eu> wrote:
>
> Hi,
>
> With recent kernels I have a huge irqsoff latency in my boards, shortly
> after startup, from the call to net_get_random_once() in
> __inet_hash_connect().
>
> On a non instrumented kernel, IRQs are disabled during approximately 80
> milliseconds. With the traces in goes to 126 milliseconds.
>
> Was apparently introduced by commit 190cc82489f4 ("tcp: change source
> port randomizarion at connect() time")
>
> Trace below.
>
> Would there be a way to perform the call to get_random_bytes() without
> disabling IRQ ?

This looks a question for drivers/char/random.c maintainer, because we
do not block interrupts at this point in __inet_hash_connect()




>
> Thanks
> Christophe
>
> # tracer: irqsoff
> #
> # irqsoff latency trace v1.1.5 on 6.0.0-rc5-s3k-dev-02351-gebc95f69a7d4
> # --------------------------------------------------------------------
> # latency: 126337 us, #8207/8207, CPU#0 | (M:preempt VP:0, KP:0, SP:0 HP:0)
> #    -----------------
> #    | task: CORSurv-352 (uid:0 nice:0 policy:0 rt_prio:0)
> #    -----------------
> #  => started at: _raw_spin_lock_irqsave
> #  => ended at:   _raw_spin_unlock_irqrestore
> #
> #
> #                    _------=> CPU#
> #                   / _-----=> irqs-off/BH-disabled
> #                  | / _----=> need-resched
> #                  || / _---=> hardirq/softirq
> #                  ||| / _--=> preempt-depth
> #                  |||| / _-=> migrate-disable
> #                  ||||| /     delay
> #  cmd     pid     |||||| time  |   caller
> #     \   /        ||||||  \    |    /
>   CORSurv-352       0d....    4us : _raw_spin_lock_irqsave
>   CORSurv-352       0d....   13us+: preempt_count_add
> <-_raw_spin_lock_irqsave
>   CORSurv-352       0d..1.   25us+: do_raw_spin_lock
> <-_raw_spin_lock_irqsave
>   CORSurv-352       0d..1.   36us : get_random_bytes <-__inet_hash_connect
>   CORSurv-352       0d..1.   45us : _get_random_bytes.part.0
> <-__inet_hash_connect
>   CORSurv-352       0d..1.   55us : crng_make_state
> <-_get_random_bytes.part.0
>   CORSurv-352       0d..1.   65us+: ktime_get_seconds <-crng_make_state
>   CORSurv-352       0d..1.   77us+: crng_fast_key_erasure <-crng_make_state
>   CORSurv-352       0d..1.   89us+: chacha_block_generic
> <-crng_fast_key_erasure
>   CORSurv-352       0d..1.  101us+: chacha_permute <-chacha_block_generic
>   CORSurv-352       0d..1.  129us : chacha_block_generic
> <-_get_random_bytes.part.0
>   CORSurv-352       0d..1.  139us+: chacha_permute <-chacha_block_generic
>   CORSurv-352       0d..1.  160us : chacha_block_generic
> <-_get_random_bytes.part.0
>   CORSurv-352       0d..1.  170us+: chacha_permute <-chacha_block_generic
>   CORSurv-352       0d..1.  191us : chacha_block_generic
> <-_get_random_bytes.part.0
>   CORSurv-352       0d..1.  200us+: chacha_permute <-chacha_block_generic
>   CORSurv-352       0d..1.  221us : chacha_block_generic
> <-_get_random_bytes.part.0
>   CORSurv-352       0d..1.  231us+: chacha_permute <-chacha_block_generic
>
>         8182 x the above two line
>

It seems hard irqs are blocked for short periods, no worries here.

But perhaps your problem is a lack of cond_resched() in a long loop
(_get_random_bytes() I guess)

Problem is : I do not think _get_random_bytes() can always schedule,
we probably would need to add
extra parameters.

>   CORSurv-352       0d..1. 126275us : chacha_block_generic
> <-_get_random_bytes.part.0
>   CORSurv-352       0d..1. 126285us+: chacha_permute <-chacha_block_generic
>   CORSurv-352       0d..1. 126309us : _raw_spin_unlock_irqrestore
> <-__do_once_done
>   CORSurv-352       0d..1. 126318us+: do_raw_spin_unlock
> <-_raw_spin_unlock_irqrestore
>   CORSurv-352       0d..1. 126330us+: _raw_spin_unlock_irqrestore
>   CORSurv-352       0d..1. 126346us+: trace_hardirqs_on
> <-_raw_spin_unlock_irqrestore
>   CORSurv-352       0d..1. 126387us : <stack trace>
>   => tcp_v4_connect
>   => __inet_stream_connect
>   => inet_stream_connect
>   => __sys_connect
>   => system_call_exception
>   => ret_from_syscall
