Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE3A0282E41
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 01:14:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725888AbgJDXOJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Oct 2020 19:14:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:59088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725836AbgJDXOI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 4 Oct 2020 19:14:08 -0400
Received: from localhost (unknown [94.238.213.162])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 675D8206DD;
        Sun,  4 Oct 2020 23:14:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601853246;
        bh=FNpEto5J+pO6yfM26EUOVZycEApETlAlT1K1Tm0Pxn8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WFu6JMHEx04FXLLEehlEAWzw2IVPd9HpDJ1RVTjLWd1MiBQhKQOt2b+Ef0noZKGaV
         uoIFNjAU1y1Dh9bGdSh6aqnvYp+x2BdJkGGpfnUcVoqqBW/MZPQst1RA9xeFtrI1n6
         3BDY52R9GqH9baBlAQbo3NLqrckpRc+zHXxU520Y=
Date:   Mon, 5 Oct 2020 01:14:04 +0200
From:   Frederic Weisbecker <frederic@kernel.org>
To:     Alex Belits <abelits@marvell.com>
Cc:     "mingo@kernel.org" <mingo@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "will@kernel.org" <will@kernel.org>,
        Prasun Kapoor <pkapoor@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [EXT] Re: [PATCH v4 03/13] task_isolation: userspace hard
 isolation from kernel
Message-ID: <20201004231404.GA66364@lothringen>
References: <04be044c1bcd76b7438b7563edc35383417f12c8.camel@marvell.com>
 <b18546567a2ed61073ae86f2d9945257ab285dfa.camel@marvell.com>
 <20201001135640.GA1748@lothringen>
 <7e54b3c5e0d4c91eb64f2dd1583dd687bc34757e.camel@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7e54b3c5e0d4c91eb64f2dd1583dd687bc34757e.camel@marvell.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 04, 2020 at 02:44:39PM +0000, Alex Belits wrote:
> On Thu, 2020-10-01 at 15:56 +0200, Frederic Weisbecker wrote:
> > External Email
> > 
> > -------------------------------------------------------------------
> > ---
> > On Wed, Jul 22, 2020 at 02:49:49PM +0000, Alex Belits wrote:
> > > +/*
> > > + * Description of the last two tasks that ran isolated on a given
> > > CPU.
> > > + * This is intended only for messages about isolation breaking. We
> > > + * don't want any references to actual task while accessing this
> > > from
> > > + * CPU that caused isolation breaking -- we know nothing about
> > > timing
> > > + * and don't want to use locking or RCU.
> > > + */
> > > +struct isol_task_desc {
> > > +	atomic_t curr_index;
> > > +	atomic_t curr_index_wr;
> > > +	bool	warned[2];
> > > +	pid_t	pid[2];
> > > +	pid_t	tgid[2];
> > > +	char	comm[2][TASK_COMM_LEN];
> > > +};
> > > +static DEFINE_PER_CPU(struct isol_task_desc, isol_task_descs);
> > 
> > So that's quite a huge patch that would have needed to be split up.
> > Especially this tracing engine.
> > 
> > Speaking of which, I agree with Thomas that it's unnecessary. It's
> > too much
> > code and complexity. We can use the existing trace events and perform
> > the
> > analysis from userspace to find the source of the disturbance.
> 
> The idea behind this is that isolation breaking events are supposed to
> be known to the applications while applications run normally, and they
> should not require any analysis or human intervention to be handled.

Sure but you can use trace events for that. Just trace interrupts, workqueues,
timers, syscalls, exceptions and scheduler events and you get all the local
disturbance. You might want to tune a few filters but that's pretty much it.

As for the source of the disturbances, if you really need that information,
you can trace the workqueue and timer queue events and just filter those that
target your isolated CPUs.

> 
> A process may exit isolation because some leftover delayed work, for
> example, a timer or a workqueue, is still present on a CPU, or because
> a page fault or some other exception, normally handled silently, is
> caused by the task. It is also possible to direct an interrupt to a CPU
> that is running an isolated task -- currently it's perfectly valid to
> set interrupt smp affinity to a CPU running isolated task, and then
> interrupt will cause breaking isolation. While it's probably not the
> best way of handling interrupts, I would rather not prohibit this
> explicitly.

Sure, but you can trace all these events with the existing tracing
interface we have.

> 
> There is also a matter of avoiding race conditions on entering
> isolation. Once CPU entered isolation, other CPUs should avoid
> disturbing it when they know that CPU is running a task in isolated
> mode. However for a short time after entering isolation other CPUs may
> be unaware of this, and will still send IPIs to it. Preventing this
> scenario completely would be very costly in terms of what other CPUs
> will have to do before notifying others, so similar to how EINTR works,
> we can simply specify that this is allowed, and task is supposed to re-
> enter isolation after this. It's still a bad idea to specify that
> isolation breaking can continue happening while application is running
> in isolated mode, however allowing some "grace period" after entering
> is acceptable as long as application is aware of this happening.

Right but that doesn't look related to tracing. Anyway I guess we
can make the CPU enter some specific mode after calling synchronize_rcu().

> 
> In libtmc I have moved this handling of isolation breaking into a
> separate thread, intended to become a separate daemon if necessary. In
> part it was done because initial implementation of isolation made it
> very difficult to avoid repeating delayed work on isolated CPUs, so
> something had to watch for it from non-isolated CPU. It's possible that
> now, when delayed work does not appear on isolated CPUs out of nowhere,
> the need in isolation manager thread will disappear, and task itself
> will be able to handle all isolation breaking, like original
> implementation by Chris was supposed to.
> 
> However in either case it's still useful for the task, or isolation
> manager, to get a description of the isolation-breaking event. This is
> what those things are intended for. Now they only produce log messages
> because this is where initially all description of isolation-breaking
> events went, however I would prefer to make logging optional but always
> let applications read those events descriptions, regardless of any
> tracing mechanism being used. I was more focused on making the
> reporting mechanism properly detect the cause of isolation breaking
> because that functionality was not quite working in earlier work by
> Chris and Yuri, so I have kept logging as the only output, but made it
> suitable for producing events that applications will be able to
> receive. Application, or isolation manager, will receive clear and
> unambiguous reporting, so there will be no need for any additional
> analysis or guesswork.

That still look like a job for userspace, based on trace events.

Thanks.
