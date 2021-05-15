Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C7A1381B00
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 22:31:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234912AbhEOUcV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 May 2021 16:32:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:39812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234919AbhEOUcS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 15 May 2021 16:32:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E3C0F61370;
        Sat, 15 May 2021 20:31:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621110665;
        bh=Ry0uQj03w86nvBEXynxGwW+G+EsTNdvjx43+M9P6eSE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=eM9tgO1w/eMcYoeyWNa6C1HCc+pFAl9IsJATErjgcFIhxeKUtsTM9hpBhmv8LNexL
         /njYboPK/N4mSPAccfFvJ7332edv09m+gW6Cu45tX9cLeqxNgB+20/fClhj9cu6OnH
         1XsJdrjeaB+C6T6gu3L7u5GoTaf9DA73aLci0OJv/nazblE9XaBwKMF1Qu9nYB2wqO
         vy+mQdQrrBDy0e6wK/X/92ulv6vGZfzR/N4zyOlZjbKpuTV+zoyz5HMkqFVtek98Yh
         MSXpkwP2F3TCHkPDhy+Cmxf1Fj3pnx2HFoldhMd9YEDOQRLa7QFCWAtvS5XVx2DqY1
         C3phBCeWsdcXw==
Date:   Sat, 15 May 2021 13:31:04 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     davem@davemloft.net, tglx@linutronix.de, netdev@vger.kernel.org,
        eric.dumazet@gmail.com, simon.horman@netronome.com,
        oss-drivers@netronome.com
Subject: Re: [PATCH net-next 1/2] net: add a napi variant for
 RT-well-behaved drivers
Message-ID: <20210515133104.491fc691@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20210515110740.lwt6wlw6wq73ifat@linutronix.de>
References: <20210514222402.295157-1-kuba@kernel.org>
        <20210515110740.lwt6wlw6wq73ifat@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 15 May 2021 13:07:40 +0200 Sebastian Andrzej Siewior wrote:
> On 2021-05-14 15:24:01 [-0700], Jakub Kicinski wrote:
> > Most networking drivers use napi_schedule_irqoff() to schedule
> > NAPI from hardware IRQ handler. Unfortunately, as explained in
> > commit 8380c81d5c4f ("net: Treat __napi_schedule_irqoff() as
> > __napi_schedule() on PREEMPT_RT") the current implementation
> > is problematic for RT.
> > 
> > The best solution seems to be to mark the irq handler with
> > IRQF_NO_THREAD, to avoid going through an irq thread just
> > to schedule NAPI and therefore wake up ksoftirqd.  
> 
> I'm not sure whether this is the best solution.
> Having a threaded handler, the primary handler simply wakes the thread
> and the IRQ thread (almost only) schedules NAPI by setting the matching
> softirq bit. Since the threaded handler is invoked with disabled BH,
> upon enabling BH again (after the routine of the threaded completed) the
> (just raised) softirq handler gets invoked. This still happens in the
> context of the IRQ thread with the higher (SCHED_FIFO) thread priority.
> No ksoftirqd is involved here.
> 
> One deviation from the just described flow is when the timer-tick comes
> into the mix. The hardirq handler (for the timer) schedules
> TIMER_SOFTIRQ. Since this softirq can not be handled at the end of the
> hardirq on PREEMPT_RT, it wakes the ksoftirqd which will handle it.
> Once ksoftirqd is in state TASK_RUNNING then all the softirqs which are
> raised later (as the NAPI softirq) won't be handled in the IRQ-thread
> but also by the ksoftird thread.
> From now on we have to hop HARDIRQ -> IRQ-THREAD -> KSOFTIRQD.
> 
> ksoftirqd runs as SCHED_OTHER and competes with other SCHED_OTHER tasks
> for CPU resources. The IRQ-thread (which is SCHED_FIFO) was obviously
> preferred. Once the ksoftirqd is running, it won't be preempted on
> !PREEMPT_RT due the implicit disabled preemption as part of
> local_bh_disable(). On PREEMPT_RT preemption may happen by a thread with
> higher priority.
> Once things get mangled into ksoftirq, all thread priority is lost (for
> the non RT veteran readers here: we had various softirq handling
> strategies over the years like "only handle the in-context raised
> softirqs" just to mention one of them. It all comes with a price in
> terms bugs / duct tape. What we have now as softirq handling is very
> close to what !RT does resulting in zero patches as duct tape).
> 
> Now assume another interrupt comes in which wakes a force-threaded
> handler (while ksoftirqd is preempted). Before the forced-threaded
> handler is invoked, BH is disabled via local_bh_disable(). Since
> ksoftirqd is preempted with BH disabled, disabling BH forces the
> ksoftirqd thread to the priority of the interrupt thread (SCHED_FIFO,
> prio 50 by default) due to the priority inheritance protocol. The
> threaded handler will run once ksoftirqd is done which has now been
> accelerated.

Thanks for the explanation. I'm not married to the patch, if you prefer
we can keep the status quo.

I'd think, however, that always deferring to ksoftirqd is conceptually
easier to comprehend. For power users who need networking there is
prefer-busy-poll (which allows application to ask the kernel to service
queues when it wants to, with some minimal poll frequency guarantees)
and threaded NAPI - which some RT users already started to adapt.

Your call.

> Part of the problem from RT perspective is the heavy use of softirq and
> the BH disabled regions which act as a BKL. I *think* having the network
> driver running in a thread would be better (in terms of prioritisation).
> I know, davem explained the benefits of NAPI/softirq when it comes to
> routing/forwarding (incl. NET_RX/TX priority) and part where NAPI kicks
> in during a heavy load (say a packet flood) and system is still
> responsible.

Right, although with modern multi-core systems where only a subset 
of cores process network Rx things look different.
