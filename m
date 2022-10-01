Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9CE25F2054
	for <lists+netdev@lfdr.de>; Sun,  2 Oct 2022 00:34:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229462AbiJAWep (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Oct 2022 18:34:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbiJAWen (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Oct 2022 18:34:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0DE760CC
        for <netdev@vger.kernel.org>; Sat,  1 Oct 2022 15:34:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 798C660C6D
        for <netdev@vger.kernel.org>; Sat,  1 Oct 2022 22:34:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA2BDC433D7;
        Sat,  1 Oct 2022 22:34:40 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="LXS+bXnK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1664663679;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JKQLrxzpFPkNQ9zmqohGsXq5r2912csyuFBetZ8Iv2o=;
        b=LXS+bXnK1xk6B3Gm++g0LM4IyhfWpYBHyVIPiBquv06hm3ncUIdvKXvlZ0HyKOniQEQn06
        /iwWo+sgqVtwbqTIuYY5AIdv7BsMB7l8QGGEFcp7xVHehiwDB3XwFzIovg2lqgvVD91wQi
        1mdpEU2nBPGi6hClZ5Clidx7wYolV3E=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id a7aac72e (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Sat, 1 Oct 2022 22:34:39 +0000 (UTC)
Date:   Sun, 2 Oct 2022 00:34:37 +0200
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Dworken <ddworken@google.com>,
        Willem de Bruijn <willemb@google.com>,
        "David S. Miller" <davem@davemloft.net>, bigeasy@linutronix.de
Subject: Re: 126 ms irqsoff Latency - Possibly due to commit 190cc82489f4
 ("tcp: change source port randomizarion at connect() time")
Message-ID: <YzjAfdip8giWBF4+@zx2c4.com>
References: <03a06114-bc63-bc01-be38-535bcc394612@csgroup.eu>
 <CANn89iKzfzOUPc+g0Brfzyi2efnXE0jLUebBz5fQMWVt9UCtfA@mail.gmail.com>
 <CANn89iLAEYBaoYajy0Y9UmGFff5GPxDUoG-ErVB2jDdRNQ5Tug@mail.gmail.com>
 <Yzi8Md2tkSYDnF1B@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Yzi8Md2tkSYDnF1B@zx2c4.com>
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi again,

Actually, ignore everything I said before. I looked more closely at the
trace, and this seems like a bogus report. Let me explain:

The part of the trace that concerns my last email is tiny:

  CORSurv-352       0d..1.   36us : get_random_bytes <-__inet_hash_connect
  CORSurv-352       0d..1.   45us : _get_random_bytes.part.0 <-__inet_hash_connect
  CORSurv-352       0d..1.   55us : crng_make_state <-_get_random_bytes.part.0
  CORSurv-352       0d..1.   65us+: ktime_get_seconds <-crng_make_state
  CORSurv-352       0d..1.   77us+: crng_fast_key_erasure <-crng_make_state
  CORSurv-352       0d..1.   89us+: chacha_block_generic <-crng_fast_key_erasure
  CORSurv-352       0d..1.  101us+: chacha_permute <-chacha_block_generic

After those lines, crng_make_state() returns back into
_get_random_bytes(), where _get_random_bytes() proceeds to call chacha20
totally unlocked, having released all interrupts:

  CORSurv-352       0d..1.  129us : chacha_block_generic <-_get_random_bytes.part.0
  CORSurv-352       0d..1.  139us+: chacha_permute <-chacha_block_generic
  ...
  CORSurv-352       0d..1. 126275us : chacha_block_generic <-_get_random_bytes.part.0
  CORSurv-352       0d..1. 126285us+: chacha_permute <-chacha_block_generic

I guess it's generating a lot of blocks, and this is a slow board?
Either way, no interrupts are held here, and no locks either.

But then let's zoom out to see if we can figure out what is disabling
IRQs. This time, pasting from the top and the bottom of the stack trace,
rather than from the middle:

  CORSurv-352       0d....    4us : _raw_spin_lock_irqsave
  ...
  CORSurv-352       0d..1. 126309us : _raw_spin_unlock_irqrestore <-__do_once_done
  CORSurv-352       0d..1. 126318us+: do_raw_spin_unlock <-_raw_spin_unlock_irqrestore
  CORSurv-352       0d..1. 126330us+: _raw_spin_unlock_irqrestore
  CORSurv-352       0d..1. 126346us+: trace_hardirqs_on <-_raw_spin_unlock_irqrestore

Oh, hello hello __do_once_done(). Let's have a look at you:

  bool __do_once_start(bool *done, unsigned long *flags)
      __acquires(once_lock)
  {
      spin_lock_irqsave(&once_lock, *flags);
      if (*done) {
          spin_unlock_irqrestore(&once_lock, *flags);
          /* Keep sparse happy by restoring an even lock count on
           * this lock. In case we return here, we don't call into
           * __do_once_done but return early in the DO_ONCE() macro.
           */
          __acquire(once_lock);
          return false;
      }
  
      return true;
  }
  EXPORT_SYMBOL(__do_once_start);
  
  void __do_once_done(bool *done, struct static_key_true *once_key,
              unsigned long *flags, struct module *mod)
      __releases(once_lock)
  {
      *done = true;
      spin_unlock_irqrestore(&once_lock, *flags);
      once_disable_jump(once_key, mod);
  }
  EXPORT_SYMBOL(__do_once_done);

Well then! It looks like DO_ONCE() takes an irqsave spinlock. So, as far
as get_random_bytes() is concerned, interrupts are not being held
abnormally long. This is something having to do with the code that's
calling into it. So... doesn't seem like an RNG issue?

Jason
