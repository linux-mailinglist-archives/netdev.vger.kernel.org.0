Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70ED04A83A6
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 13:16:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240241AbiBCMQw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 07:16:52 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:52798 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232508AbiBCMQw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 07:16:52 -0500
Date:   Thu, 3 Feb 2022 13:16:50 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1643890611;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0+DbHUWMagPgOKRQ2haCBtdxPtzgZGpsjaUsnJhpju4=;
        b=plSENnkIWZTeNcR9BTk/Jw6zrDCbhOSG11brenMac7xJ+PM8/ehL67JV/6nD8XYzj5W+XM
        DlB/0megjdzbHwPoHNC+NEOHqKdFo8bAbhSTc4msEGbqahwtDxBoFJU4c1JXZ3UV4VcDDs
        eaG+i3yzHIXaPaC4XyNKTG/UygyoEr9W+rDmNYDw93lpnnrMUh6FfZ1WguIS68jLaMcSjK
        CUV9E4Jwky+WXVpLw7X5YeQ22veUO4A7WJRbFzM1Pz241WpL2nTD/87RwtCGY8BJLZKL0h
        eVNPofdI7cb+uF5bE4hetDJlNF21GlkAPw/yaIjTe6286PJNIIYBxFK1RGX2CA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1643890611;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0+DbHUWMagPgOKRQ2haCBtdxPtzgZGpsjaUsnJhpju4=;
        b=5g57Rg1HjzlIjCg7LiVDWyiGfFG59sqPIgDRaM6dEhfESuUT1cPnTVHXe7npRx8asNzMTs
        tCYdw4p/RnusH9DQ==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Eric Dumazet <edumazet@google.com>
Cc:     bpf <bpf@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH net-next 1/4] net: dev: Remove the preempt_disable() in
 netif_rx_internal().
Message-ID: <YfvHstBs/FCBtVhU@linutronix.de>
References: <20220202122848.647635-1-bigeasy@linutronix.de>
 <20220202122848.647635-2-bigeasy@linutronix.de>
 <CANn89iJm9krQ-kjVBxFzxh0nG46O5RWDg=QyXhiq1nA3Erf9KQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CANn89iJm9krQ-kjVBxFzxh0nG46O5RWDg=QyXhiq1nA3Erf9KQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-02-02 09:10:10 [-0800], Eric Dumazet wrote:
> On Wed, Feb 2, 2022 at 4:28 AM Sebastian Andrzej Siewior
> <bigeasy@linutronix.de> wrote:
> >
> > The preempt_disable() and rcu_disable() section was introduced in commit
> >    bbbe211c295ff ("net: rcu lock and preempt disable missing around generic xdp")
> >
> > The backtrace shows that bottom halves were disabled and so the usage of
> > smp_processor_id() would not trigger a warning.
> > The "suspicious RCU usage" warning was triggered because
> > rcu_dereference() was not used in rcu_read_lock() section (only
> > rcu_read_lock_bh()). A rcu_read_lock() is sufficient.
> >
> > Remove the preempt_disable() statement which is not needed.
> 
> I am confused by this changelog/analysis of yours.
> 
> According to git blame, you are reverting this patch.
> 
> commit cece1945bffcf1a823cdfa36669beae118419351
> Author: Changli Gao <xiaosuo@gmail.com>
> Date:   Sat Aug 7 20:35:43 2010 -0700
> 
>     net: disable preemption before call smp_processor_id()
> 
>     Although netif_rx() isn't expected to be called in process context with
>     preemption enabled, it'd better handle this case. And this is why get_cpu()
>     is used in the non-RPS #ifdef branch. If tree RCU is selected,
>     rcu_read_lock() won't disable preemption, so preempt_disable() should be
>     called explictly.
> 
>     Signed-off-by: Changli Gao <xiaosuo@gmail.com>
>     Signed-off-by: David S. Miller <davem@davemloft.net>

Nut sure if I ignored it or made a wrong turn somewhere. But I remember
reading it. But here, preempt_disable() was added because
| Although netif_rx() isn't expected to be called in process context with
| preemption enabled, it'd better handle this case.

and this isn't much of a good reason. Simply because netif_rx()
shouldn't not be called from preemptible context.

> But I am not sure we can.
> 
> Here is the code in larger context:
> 
> #ifdef CONFIG_RPS
>     if (static_branch_unlikely(&rps_needed)) {
>         struct rps_dev_flow voidflow, *rflow = &voidflow;
>         int cpu;
> 
>         preempt_disable();
>         rcu_read_lock();
> 
>         cpu = get_rps_cpu(skb->dev, skb, &rflow);
>         if (cpu < 0)
>             cpu = smp_processor_id();
> 
>         ret = enqueue_to_backlog(skb, cpu, &rflow->last_qtail);
> 
>         rcu_read_unlock();
>         preempt_enable();
>     } else
> #endif
> 
> This code needs the preempt_disable().

But why? netif_rx_internal() should be invoked with disabled BH so I
don't see a reason why preemption needs additionally be disabled in this
section.
On PREEMPT_RT we can get preempted but the task remains on the CPU and
other network activity will be block on the BH-lock.

Sebastian
