Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35FD810B452
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 18:22:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727142AbfK0RWW convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 27 Nov 2019 12:22:22 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:45039 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727107AbfK0RWW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 12:22:22 -0500
Received: from bigeasy by Galois.linutronix.de with local (Exim 4.80)
        (envelope-from <bigeasy@linutronix.de>)
        id 1ia113-0002Tf-7w; Wed, 27 Nov 2019 18:22:13 +0100
Date:   Wed, 27 Nov 2019 18:22:13 +0100
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Eric Dumazet <edumazet@google.com>
Cc:     netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH net 2/2] net: gro: Let the timeout timer expire in
 softirq context with `threadirqs'
Message-ID: <20191127172213.unwma3k7z2xicnkg@linutronix.de>
References: <20191126222013.1904785-1-bigeasy@linutronix.de>
 <20191126222013.1904785-3-bigeasy@linutronix.de>
 <CANn89iJtCwB=RdYnAYXU-uZvv=gHJgYD=dcfhohuLi_Qjfv6Ag@mail.gmail.com>
 <20191127093521.6achiubslhv7u46c@linutronix.de>
 <CANn89iL=q2wwjdSj1=veBE0hDATm_K=akKhz3Dyddnk28DRJhg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <CANn89iL=q2wwjdSj1=veBE0hDATm_K=akKhz3Dyddnk28DRJhg@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-11-27 08:15:52 [-0800], Eric Dumazet wrote:
> > One CPU, 2 NICs:
> >
> >     threaded_IRQ of NIC1                     hard-irq context, hrtimer
> >        local_bh_disable()
> >          nic_irq_handler()
> >           if (napi_schedule_prep())
> >             __napi_schedule_irqoff()
> >
> 
> And _which_ driver would call this variant without being sure hard irq are
> disabled ?

->
|$ git grep __napi_schedule_irqoff drivers/net/

returns for instance drivers/net/ethernet/rdc/r6040.c. It invokes
r6040_interrupt() from the hardirq handler. Everything is correct.

> Hard irq handlers are supposed to run with hard irq being disabled.

This is the case except for…

> Who decided that this was no longer the case ?

the system was bootet with the `threadirqs' on command line.

> This conflicts with hrtimer being delivered from hard irq context, this is
> the root cause of the problem.

correct. That is why moved them softirq context if the system is booted
with `threadirqs'.

> You are telling us napi_schedule_irqoff() should never be used, because we
> do not know if hard irqs are masked or not.

If interrupts are forced-threaded, correct. From kernel/irq/manage.c,
irq_forced_thread_fn() is used as the "handler" in this case:
| /*
|  * Interrupts which are not explicitly requested as threaded
|  * interrupts rely on the implicit bh/preempt disable of the hard irq
|  * context. So we need to disable bh here to avoid deadlocks and other
|  * side effects.
|  */
| static irqreturn_t
| irq_forced_thread_fn(struct irq_desc *desc, struct irqaction *action)
| {
|         irqreturn_t ret;
| 
|         local_bh_disable();
|         ret = action->thread_fn(action->irq, action->dev_id);
|         if (ret == IRQ_HANDLED)
|                 atomic_inc(&desc->threads_handled);
| 
|         irq_finalize_oneshot(desc, action);
|         local_bh_enable();
|         return ret;
| }

> Honestly this is a nightmare, we can not trust anymore stuff that has been
> settled 20 years ago.

This changes only if the `threadirqs' command line switch has been used.
We didn't have threaded interrupts 20 years ago.
Also, if the hrtimer was already expired at the time of programming then
the hrtimer used to fire in softirq context until commit
    c6eb3f70d4482 ("hrtimer: Get rid of hrtimer softirq")

This could happen if you program the timer to 50ns instead of 50us in
case you missed a few zeros in your echo to the sysfs file.

> If you want to get rid of hard irq completely, make all handlers being run
> from threaded_IRQ,
> not only a subset of them ?

`threadirqs' threads only IRQ handlers. All of them. The hrtimers
infrastructure is not affected by this change. Also smp_function call
and irqwork continue to fire in hardirq context. Also the direct
interrupts vectors as used by the HyperV driver is not affected by this
switch but I think it should. 

> > I'm not aware of an other problems of this kind.
> > Most drivers do spin_lock_irqsave() and in that case in does not matter
> > if the interrupt is threaded or not vs the hrtimer callback. Which means
> > they do not assume that the IRQ handler runs with interrupts disabled.
> >
> 
> Most NIC drivers simply raises a softirq.

Yes. For those it does not matter because they use __napi_schedule()
which disables interrupts.

> > The timeout timers are usually timer_list timer which run in softirq
> > context and since the force-IRQ-thread runs also with disabled softirq
> > it is fine using just spin_lock().
> >
> > If you don't want this here maybe tglx can add some hrtimer annotation.
> >
> 
> I only want to understand how many other points in the stack we have to
> audit and ' fix' ...
Okay. Looking now over all hrtimer in net/ look good, most of them
expire in softirq context. Looking at drivers/net they also look fine.
They acquire spin_lock_irqsave() within the driver, schedule a tasklet
or wake a net queue.

Sebastian
