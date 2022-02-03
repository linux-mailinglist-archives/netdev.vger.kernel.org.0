Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 285FF4A88E3
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 17:44:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352380AbiBCQoi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 11:44:38 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:54424 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352392AbiBCQoe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 11:44:34 -0500
Date:   Thu, 3 Feb 2022 17:44:32 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1643906673;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FYvZgFIClpGWgYjjDZmm3AR9Fk7V2vEytBiOzm8FV34=;
        b=XRQ6tO8YEuyEiC5XXUveL1cxECgQAHWZ7ea8c12k5Lf6EQxX9sSWZBDJCPgyzNzHQOgDdO
        Ol43709M0jrXs/nW3m2WPPUyGAyXYrDFjPmaAk0TuWAB/1gViOhkjqct6GYhk51NAvbugR
        BHKHtObOKWL6nJOzRVui97hQfkjkq1fM/abPFO+yyQDdKoTB/nbS5JDmQ1Oih32kIC1Z6V
        IDCxGqUlSbrdUx/RumkMrNz7hYKRzVfNirWYsRup17jLrz+0gjcIT0a+jAaF6TD6c+eDdq
        iWhfL/pimlIqUQgTgP73B9EwCRM86sROUj8lvb2wjFkFco92S6c7oCStMDLLiA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1643906673;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FYvZgFIClpGWgYjjDZmm3AR9Fk7V2vEytBiOzm8FV34=;
        b=hz/xAWtsNus1jq+WmycwLafPNzQcgwt0HeAQtBpK+VJwgiJZM6o/rpCZOUOgwMqfCfNI6v
        vJmhoe3Ao3bC8TBg==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Eric Dumazet <edumazet@google.com>
Cc:     bpf <bpf@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH net-next 3/4] net: dev: Makes sure netif_rx() can be
 invoked in any context.
Message-ID: <YfwGcHv6XQytcq68@linutronix.de>
References: <20220202122848.647635-1-bigeasy@linutronix.de>
 <20220202122848.647635-4-bigeasy@linutronix.de>
 <CANn89iLVPnhybrdjRh6ccv6UZHW-_W0ZHRO5c7dnWU44FUgd_g@mail.gmail.com>
 <YfvwbsKm4XtTUlsx@linutronix.de>
 <CANn89i+66MvzQVp=eTENzZY6s8+B+jQCoKEO_vXdzaDeHVTH5w@mail.gmail.com>
 <Yfv3c+5XieVR0xAh@linutronix.de>
 <CANn89i+t4TgrryvSBmBMfsY63m6Fhxi+smiKfOwHTRAKxvcPLQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CANn89i+t4TgrryvSBmBMfsY63m6Fhxi+smiKfOwHTRAKxvcPLQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-02-03 08:18:34 [-0800], Eric Dumazet wrote:
> > So we still end up with two interfaces. Do I move a few callers like the
> > one you already mentioned over to the __netif_rx() interface or will it
> > be the one previously mentioned for now?
> 
> 
> I would say vast majority of drivers would use netif_rx()
> 
> Only the one we consider critical (loopback traffic) would use
> __netif_rx(), after careful inspection.
> 
> As we said modern/high performance NIC are using NAPI and GRO these days.
> 
> Only virtual drivers might still use legacy netif_rx() and be in critical paths.

Let me then update something to the documentation so it becomes obvious.

> >  static inline void local_bh_enable(void)
> >  {
> > -       __local_bh_enable_ip(_THIS_IP_, SOFTIRQ_DISABLE_OFFSET);
> > +       if (unlikely(softirq_count() == SOFTIRQ_DISABLE_OFFSET)) {
> > +               __local_bh_enable_ip(_THIS_IP_, SOFTIRQ_DISABLE_OFFSET);
> > +       } else {
> > +               preempt_count_sub(SOFTIRQ_DISABLE_OFFSET);
> > +               barrier();
> > +       }
> >  }
> >
> >  #ifdef CONFIG_PREEMPT_RT
> >
> > lower the overhead to acceptable range? (I still need to sell this to
> > peterz first).
> 
> I guess the cost of the  local_bh_enable()/local_bh_disable() pair
> will be roughly the same, please measure it :)

We would avoid that branch maybe that helps. Will measure.

Sebastian
