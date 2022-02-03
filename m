Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 865C34A836C
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 13:00:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350364AbiBCMAK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 07:00:10 -0500
Received: from mail.toke.dk ([45.145.95.12]:36709 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230463AbiBCMAI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Feb 2022 07:00:08 -0500
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1643889606; bh=ggDOzYkSSb/83yHB/nJSzFSJ1gt4mFlHA28pdSx+OjA=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=sXIFcc6he/qsLKpcMHhqEQ3ZCZ6AFpDEfw6zNupYfilXwnI0UxDfWH6JCrKaJ8KCs
         ol7Tf2XOTCo5ocjyZoASPa8/3q0e0tbXNZUeUDYBeGm8UWjULIpwuQr+RM/qzcsjKK
         P3wJnrw+ckVux+Y0klGEWV6qgiV3rhYcRayQnMJuAJUXnzFPcPUnPkSKSAz8ZTpwv1
         rhuh2akZ7nLsXhwSosv5mifdErDhq294wA5nA6uAxBRGNsmaSU1Akax1QNrcjVhExR
         jO4GNYHNje8AxotuKseAEolK9QRvmLir5lgwdgxqtlCM/NeA4j5ZAVKSPmi2E3+ic9
         yLj6rbHjC1hBA==
To:     Eric Dumazet <edumazet@google.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
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
In-Reply-To: <CANn89iJm9krQ-kjVBxFzxh0nG46O5RWDg=QyXhiq1nA3Erf9KQ@mail.gmail.com>
References: <20220202122848.647635-1-bigeasy@linutronix.de>
 <20220202122848.647635-2-bigeasy@linutronix.de>
 <CANn89iJm9krQ-kjVBxFzxh0nG46O5RWDg=QyXhiq1nA3Erf9KQ@mail.gmail.com>
Date:   Thu, 03 Feb 2022 13:00:06 +0100
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87v8xwb1o9.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eric Dumazet <edumazet@google.com> writes:

> On Wed, Feb 2, 2022 at 4:28 AM Sebastian Andrzej Siewior
> <bigeasy@linutronix.de> wrote:
>>
>> The preempt_disable() and rcu_disable() section was introduced in commit
>>    bbbe211c295ff ("net: rcu lock and preempt disable missing around generic xdp")
>>
>> The backtrace shows that bottom halves were disabled and so the usage of
>> smp_processor_id() would not trigger a warning.
>> The "suspicious RCU usage" warning was triggered because
>> rcu_dereference() was not used in rcu_read_lock() section (only
>> rcu_read_lock_bh()). A rcu_read_lock() is sufficient.
>>
>> Remove the preempt_disable() statement which is not needed.
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
>
>
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

This is mostly so that the CPU ID stays the same throughout that section
of code, though, right? So wouldn't it work to replace the
preempt_disable() with a migrate_disable()? That should keep _RT happy,
no?

-Toke
