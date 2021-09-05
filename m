Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D3DD40121D
	for <lists+netdev@lfdr.de>; Mon,  6 Sep 2021 01:37:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235390AbhIEXiE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Sep 2021 19:38:04 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:33686 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229666AbhIEXiC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Sep 2021 19:38:02 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1630885017;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to; bh=XRDBwmPSq0OtExDtrXwn2TezsW0Z/MUnaN5kkmANKDA=;
        b=Tq23GPbTpOfmoAuO1nJdHdzP5Ssdddhg48q3UTqIpcbzKlydMr15p7s58F4AmhFuhS5vcy
        UX+w5VNwG5BN3BYpZTlHpHZyVq4x8UvnGXsP0gkI9bUujM3+RGP7tVm/sxb5oA6TpKJ+79
        l1xlfrFpSkdfnFw/0CGV7aATjn7dMu+Jn5glKBNupuCYhphlORdHnIhuK5AGeap+gvBrQX
        nT0kmaZDcB2TrxznfVzm8FXJ2VAmQO/io251fc7H7w8duD7uXjcoWMdL1slcF5phxT8qto
        Ju/LAeUhZsedjuCgnuM66kNhhsvkKSJAg7or526uy3lrzZfzCPvbgsDQiQ2BbA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1630885017;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to; bh=XRDBwmPSq0OtExDtrXwn2TezsW0Z/MUnaN5kkmANKDA=;
        b=AkyuB/Ns+u8qG59Tjk4QQpec7V5GBsNxQdnPNioHu8BzdnEWKGmWuzpHxd5EScozlVJyWD
        izyUAw1mDYSxQbBw==
To:     Hillf Danton <hdanton@sina.com>,
        syzbot <syzbot+a9b681dcbc06eb2bca04@syzkaller.appspotmail.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, eric.dumazet@gmail.com
Subject: Re: [syzbot] INFO: task hung in __lru_add_drain_all
In-Reply-To: <20210903111011.2811-1-hdanton@sina.com>
Date:   Mon, 06 Sep 2021 01:36:56 +0200
Message-ID: <87k0jua92f.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hillf,

On Fri, Sep 03 2021 at 19:10, Hillf Danton wrote:
>
> See if ksoftirqd is preventing bound workqueue work from running.

What?

> --- a/kernel/softirq.c
> +++ b/kernel/softirq.c
> @@ -521,6 +521,7 @@ asmlinkage __visible void __softirq_entr
>  	bool in_hardirq;
>  	__u32 pending;
>  	int softirq_bit;
> +	bool is_ksoftirqd = __this_cpu_read(ksoftirqd) == current;
>  
>  	/*
>  	 * Mask out PF_MEMALLOC as the current task context is borrowed for the
> @@ -565,6 +566,8 @@ restart:
>  		}
>  		h++;
>  		pending >>= softirq_bit;
> +		if (is_ksoftirqd && in_task())

Can you please explain how this would ever be true?

 #define in_task()	(!(in_nmi() | in_hardirq() | in_serving_softirq()))

in_task() is guaranteed to be false here, because in_serving_softirq()
is guaranteed to be true simply because this is the softirq processing
context.

> +			cond_resched();

___do_softirq() returns after 2 msec of softirq processing whether it is
invoked on return from interrupt or in ksoftirqd context. On return from
interrupt this wakes ksoftirqd and returns. In ksoftirqd this is a
rescheduling point.

But that only works when the action handlers, e.g. net_rx_action(),
behave well and respect that limit as well.

net_rx_action() has it's own time limit: netdev_budget_usecs

That defaults to: 2 * USEC_PER_SEC / HZ 

The config has HZ=100, so this loop should terminate after

    2 * 1e6 / 100 = 20000us = 20ms

The provided C-reproducer does not change that default.

But again this loop can only terminate if napi_poll() and the
subsequently invoked callchain behaves well.

So instead of sending obviously useless "debug" patches, why are you not
grabbing the kernel config and the reproducer and figure out what the
root cause is?

Enable tracing, add some trace_printks and let ftrace_dump_on_oops spill
it out when the problem triggers. That will pinpoint the issue.

Thanks,

        tglx


