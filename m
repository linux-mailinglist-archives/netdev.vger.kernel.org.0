Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00C4650A4AA
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 17:49:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1390330AbiDUPvj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 11:51:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390322AbiDUPvi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 11:51:38 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F353847392
        for <netdev@vger.kernel.org>; Thu, 21 Apr 2022 08:48:48 -0700 (PDT)
Date:   Thu, 21 Apr 2022 17:48:46 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1650556127;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dFc2WSaU9QdI7av6wroJbMzXxjbsZVFagOXqb76zXLE=;
        b=TRq1+lTXKgM8Ha+T7Yfq8UKc3+iz5LSyrhArVF0lQmXOa6cKRM7U9JvlRrxKeYAkBKYOVZ
        IwcuqnqHRpsAMLgPwAwXLR5oAfrKZf4OkQc11lSWoXmS3FHDrGY0t/oulsGZbVpZwjvtnX
        zYkRFbTwQ+ZQNykxSAK0mArgA+cPziLFvoanzfc0B8eZJ/naKjR2XagtJD7HEG/7ZLpJrg
        VY4X9g8bSY1Aa17+47vZCt1qQVLlhDSdCrH9L0fQsxF9mvsF3CzgdWAKDtklgTPP4vk9SB
        U5xpBWO3YppxVbjQGaMIxSdqGGim+5c5Ag63gF0XL5dAJ27J1xLqMiz6WVit3Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1650556127;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dFc2WSaU9QdI7av6wroJbMzXxjbsZVFagOXqb76zXLE=;
        b=nyc4pzfJXtUv5T22TMRogBnKDKD9TLEBTHf0etGyOZqc82jeCD254vLJRebTTP6hnL4e+S
        lwiAXl7D+JITgYCw==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Eric Dumazet <edumazet@google.com>
Cc:     netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH net] net: Use this_cpu_inc() to increment net->core_stats
Message-ID: <YmF83t3VLNMp1q5i@linutronix.de>
References: <YmFjdOp+R5gVGZ7p@linutronix.de>
 <CANn89i+0u=DmAd1_vv-vJsJ53L2y6v7pvvTgrVN9D=rGo9-ifA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CANn89i+0u=DmAd1_vv-vJsJ53L2y6v7pvvTgrVN9D=rGo9-ifA@mail.gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-04-21 08:32:30 [-0700], Eric Dumazet wrote:
> On Thu, Apr 21, 2022 at 7:00 AM Sebastian Andrzej Siewior
> <bigeasy@linutronix.de> wrote:
> >
> > The macro dev_core_stats_##FIELD##_inc() disables preemption and invokes
> > netdev_core_stats_alloc() to return a per-CPU pointer.
> > netdev_core_stats_alloc() will allocate memory on its first invocation
> > which breaks on PREEMPT_RT because it requires non-atomic context for
> > memory allocation.
> 
> Can you elaborate on this, I am confused ?
> 
> You are saying that on PREEMPT_RT, we can not call
> alloc_percpu_gfp(XXX, GFP_ATOMIC | __GFP_NOWARN);
> under some contexts ?

Correct. On PREEMPT_RT you must not explicitly create an atomic context
by
- using preempt_disable()
- acquiring a raw_spinlock_t lock
- using local_irq_disable()

while allocating memory. GFP_ATOMIC won't save you. The internal locks
within mm (kmalloc() and per-CPU memory) are sleeping locks and can not
be acquired in atomic context.

> preemption might be disabled by callers of net->core_stats anyways...

It won't be disabled by
- acquiring a spinlock_t lock
- running in softirq or interrupt handler

I haven't seen any splats (with RT enabled) other than this
preempt_disable() section so far. However only the first caller
allocates memory so maybe I add a check later on to be sure.

Sebastian
