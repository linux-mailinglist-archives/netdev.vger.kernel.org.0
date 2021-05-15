Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAFB5381827
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 13:07:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230168AbhEOLI7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 May 2021 07:08:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbhEOLI6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 May 2021 07:08:58 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81FC2C061573
        for <netdev@vger.kernel.org>; Sat, 15 May 2021 04:07:45 -0700 (PDT)
Date:   Sat, 15 May 2021 13:07:40 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1621076862;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eXLzkodLqz/pnRdv6tWoPJQwxkqgFPFSe7RYqcy6tck=;
        b=Ov/zDA7P/1MBcbn7BuEIgImRqhVT35TvpjUQRxsazW+A8JfpM+0FkWkrITSHhWyxAKwMGf
        PbFUV+98JiI8bE9KxpJaSJirb+bS0gPl8ZW24buAz9dl6aVyZ4hHrgpoWijLf/9cmuEZ2a
        BcVnsBLn+N3wkoSTtj7+r8XDVAUIYfXB4d8BaYJJK8Pixyx/eLcJhdfvYEjgvWG6tbPg1A
        0WL5PPbXkO3tNem+TD4Z6TW2ncOh5r2bif9lgUzpn/wCbTS/gcK0C2E1k9DX2IOJsKnjH0
        uiNmp349CMOHlf81eaB6M6MVpAN7ZOsUYlFDRDjWwtWNzHfMeR0DxGI0vpmVtg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1621076862;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eXLzkodLqz/pnRdv6tWoPJQwxkqgFPFSe7RYqcy6tck=;
        b=mLrbBwfdewJG+HWcu92KGjHSD6cbEZZbTFrN4A4zNoQiFIDJWs8EWiNbRnIeH0WWP/BpcO
        how2dkmKU2druKBg==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, tglx@linutronix.de, netdev@vger.kernel.org,
        eric.dumazet@gmail.com, simon.horman@netronome.com,
        oss-drivers@netronome.com
Subject: Re: [PATCH net-next 1/2] net: add a napi variant for RT-well-behaved
 drivers
Message-ID: <20210515110740.lwt6wlw6wq73ifat@linutronix.de>
References: <20210514222402.295157-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210514222402.295157-1-kuba@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-05-14 15:24:01 [-0700], Jakub Kicinski wrote:
> Most networking drivers use napi_schedule_irqoff() to schedule
> NAPI from hardware IRQ handler. Unfortunately, as explained in
> commit 8380c81d5c4f ("net: Treat __napi_schedule_irqoff() as
> __napi_schedule() on PREEMPT_RT") the current implementation
> is problematic for RT.
> 
> The best solution seems to be to mark the irq handler with
> IRQF_NO_THREAD, to avoid going through an irq thread just
> to schedule NAPI and therefore wake up ksoftirqd.

I'm not sure whether this is the best solution.
Having a threaded handler, the primary handler simply wakes the thread
and the IRQ thread (almost only) schedules NAPI by setting the matching
softirq bit. Since the threaded handler is invoked with disabled BH,
upon enabling BH again (after the routine of the threaded completed) the
(just raised) softirq handler gets invoked. This still happens in the
context of the IRQ thread with the higher (SCHED_FIFO) thread priority.
No ksoftirqd is involved here.

One deviation from the just described flow is when the timer-tick comes
into the mix. The hardirq handler (for the timer) schedules
TIMER_SOFTIRQ. Since this softirq can not be handled at the end of the
hardirq on PREEMPT_RT, it wakes the ksoftirqd which will handle it.
Once ksoftirqd is in state TASK_RUNNING then all the softirqs which are
raised later (as the NAPI softirq) won't be handled in the IRQ-thread
but also by the ksoftird thread.
From now on we have to hop HARDIRQ -> IRQ-THREAD -> KSOFTIRQD.

ksoftirqd runs as SCHED_OTHER and competes with other SCHED_OTHER tasks
for CPU resources. The IRQ-thread (which is SCHED_FIFO) was obviously
preferred. Once the ksoftirqd is running, it won't be preempted on
!PREEMPT_RT due the implicit disabled preemption as part of
local_bh_disable(). On PREEMPT_RT preemption may happen by a thread with
higher priority.
Once things get mangled into ksoftirq, all thread priority is lost (for
the non RT veteran readers here: we had various softirq handling
strategies over the years like "only handle the in-context raised
softirqs" just to mention one of them. It all comes with a price in
terms bugs / duct tape. What we have now as softirq handling is very
close to what !RT does resulting in zero patches as duct tape).

Now assume another interrupt comes in which wakes a force-threaded
handler (while ksoftirqd is preempted). Before the forced-threaded
handler is invoked, BH is disabled via local_bh_disable(). Since
ksoftirqd is preempted with BH disabled, disabling BH forces the
ksoftirqd thread to the priority of the interrupt thread (SCHED_FIFO,
prio 50 by default) due to the priority inheritance protocol. The
threaded handler will run once ksoftirqd is done which has now been
accelerated.

Part of the problem from RT perspective is the heavy use of softirq and
the BH disabled regions which act as a BKL. I *think* having the network
driver running in a thread would be better (in terms of prioritisation).
I know, davem explained the benefits of NAPI/softirq when it comes to
routing/forwarding (incl. NET_RX/TX priority) and part where NAPI kicks
in during a heavy load (say a packet flood) and system is still
responsible.

> Since analyzing the 40 callers of napi_schedule_irqoff()
> to figure out which handlers are light-weight enough to
> warrant IRQF_NO_THREAD seems like a larger effort add
> a new helper for drivers which set IRQF_NO_THREAD.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Sebastian
