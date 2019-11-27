Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E69BB10ACAA
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 10:35:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726296AbfK0Jf2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 04:35:28 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:44127 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726130AbfK0Jf2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 04:35:28 -0500
Received: from bigeasy by Galois.linutronix.de with local (Exim 4.80)
        (envelope-from <bigeasy@linutronix.de>)
        id 1iZtjF-0003Tf-UB; Wed, 27 Nov 2019 10:35:21 +0100
Date:   Wed, 27 Nov 2019 10:35:21 +0100
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Eric Dumazet <edumazet@google.com>
Cc:     netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH net 2/2] net: gro: Let the timeout timer expire in
 softirq context with `threadirqs'
Message-ID: <20191127093521.6achiubslhv7u46c@linutronix.de>
References: <20191126222013.1904785-1-bigeasy@linutronix.de>
 <20191126222013.1904785-3-bigeasy@linutronix.de>
 <CANn89iJtCwB=RdYnAYXU-uZvv=gHJgYD=dcfhohuLi_Qjfv6Ag@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CANn89iJtCwB=RdYnAYXU-uZvv=gHJgYD=dcfhohuLi_Qjfv6Ag@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-11-26 14:39:47 [-0800], Eric Dumazet wrote:
> On Tue, Nov 26, 2019 at 2:20 PM Sebastian Andrzej Siewior
> <bigeasy@linutronix.de> wrote:
> >
> > The timer callback (napi_watchdog()) invokes __napi_schedule_irqoff()
> > with disabled interrupts. With the `threadirqs' commandline option all
> > interrupt handler are threaded and using __napi_schedule_irqoff() is not
> > an issue because everyone is using it in threaded context which is
> > synchronised with local_bh_disable().
> > The napi_watchdog() timer is still expiring in hardirq context and may
> > interrupt a threaded handler which is in the middle of
> > __napi_schedule_irqoff() leading to list corruption.
> 
> Sorry, I do not understand this changelog.
> 
> Where/how do you get list corruption  exactly ?
> 
>  __napi_schedule_irqoff() _has_ to be called with hard IRQ disabled.
> 
> Please post a stack trace.

I don't have a stack trace, this is based on review.
__napi_schedule_irqoff() is used in IRQ context and this is only the
primary IRQ handler. There is no other in-IRQ usage (like SMP-function
call or so (excluding the HV network driver)) but there is the hrtimer.

With `threadirqs' you don't have the in-IRQ usage from the IRQ handler
anymore. The IRQ-handler for two different NICs don't interrupt/
preempt each other because the handler is invoked with disabled softirq
(which also disables preemption). This is all safe.
The hrtimer fires always in IRQ context no matter if `threadirqs' is
used or not. Which brings us to the following race condition:

One CPU, 2 NICs:

    threaded_IRQ of NIC1                     hard-irq context, hrtimer
       local_bh_disable()
         nic_irq_handler()
	  if (napi_schedule_prep())
	    __napi_schedule_irqoff()
	       ____napi_schedule(this_cpu_ptr(&softnet_data), n);
->	         list_add_tail(, &sd->poll_list);

                                        hrtimer_interrupt()
                                          __hrtimer_run_queues()
                                             napi_watchdog()
                                               __napi_schedule_irqoff()
                                    	       ____napi_schedule(this_cpu_ptr(&softnet_data), n);
->	                                         list_add_tail(&napi->poll_list, &sd->poll_list);

The same per-CPU list modified again.
If the callback is moved to softirq instead:

    threaded_IRQ of NIC1                     hard-irq context, hrtimer
       local_bh_disable()
         nic_irq_handler()
	  if (napi_schedule_prep())
	    __napi_schedule_irqoff()
	       ____napi_schedule(this_cpu_ptr(&softnet_data), n);
->	         list_add_tail(, &sd->poll_list);

                                        hrtimer_interrupt()
                                          raise_softirq_irqoff(HRTIMER_SOFTIRQ);
                 list_add_tail() completes
       local_bh_enable()
          if (unlikely(!in_interrupt() && local_softirq_pending())) {
             do_softirq();
                                               napi_watchdog()
                                                 __napi_schedule_irqoff()
                                    	           ____napi_schedule(this_cpu_ptr(&softnet_data), n);
	                                             list_add_tail(, &sd->poll_list);

> > Let the napi_watchdog() expire in softirq context if `threadirqs' is
> > used.
> >
> > Fixes: 3b47d30396bae ("net: gro: add a per device gro flush timer")
> 
> Are you sure this commit is the root cause of the problem you see ?

This commit was introduced in v3.19-rc1 and threadirqs was introduced in
commit
   8d32a307e4faa ("genirq: Provide forced interrupt threading")

which is v2.6.39-rc1. Based on my explanation above this problem exists
with the timer and `threadirqs'. The hrtimer always expired in hardirq
context.

> > Cc: Eric Dumazet <edumazet@google.com>
> > Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> > ---
> >  net/core/dev.c | 6 +++++-
> >  1 file changed, 5 insertions(+), 1 deletion(-)
> >
> > diff --git a/net/core/dev.c b/net/core/dev.c
> > index 99ac84ff398f4..ec533d20931bc 100644
> > --- a/net/core/dev.c
> > +++ b/net/core/dev.c
> > @@ -5994,6 +5994,8 @@ bool napi_complete_done(struct napi_struct *n, int work_done)
> >                 napi_gro_flush(n, !!timeout);
> >                 if (timeout)
> >                         hrtimer_start(&n->timer, ns_to_ktime(timeout),
> > +                                     force_irqthreads ?
> 
> Honestly something is wrong with this patch, force_irqthreads should
> not be used in net/ territory,
> that is some layering problem.

I'm not aware of an other problems of this kind.
Most drivers do spin_lock_irqsave() and in that case in does not matter
if the interrupt is threaded or not vs the hrtimer callback. Which means
they do not assume that the IRQ handler runs with interrupts disabled.
The timeout timers are usually timer_list timer which run in softirq
context and since the force-IRQ-thread runs also with disabled softirq
it is fine using just spin_lock().

If you don't want this here maybe tglx can add some hrtimer annotation.

Sebastian
