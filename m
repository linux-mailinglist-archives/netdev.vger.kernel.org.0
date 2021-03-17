Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79DEE33F566
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 17:24:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232424AbhCQQXt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 12:23:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:46584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232445AbhCQQXZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Mar 2021 12:23:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7A2F964F17;
        Wed, 17 Mar 2021 16:23:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615998204;
        bh=fvIdYkUgwL/EJ5wwa8huQmbkmcdH/xW7ELzonYzo/Nc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qVt6gWhHGtNNfaVhk7IoGqtrVnaid3uvDHYY2z1U3cClh1kSYaaUgEuQkzXDJ5Ozd
         7YK0Kifm++nb/mJay9RU2gbY+kaUnzLNOGgqsXXffrejyf1OsshdFTMTyN4vIntM6Y
         ILVA6zH+SaM1xwjqGLOkfx03/RTyWiR12yskbZr3JnTkAs731YCAEgUkaJyRT/b526
         IKtMH3VSFzKJWaF8XcDQuXWCKRC7x8bW3fRiCBmOtbu70zdBYOEnmPp3Nk8eC1l546
         Crnb1yfkHJUG4jfAgU3mNSTpO25SafsTf+qomgJoh+aJSx5BQRmYA5bVvVcsu/w39E
         6W+BkKPHj4+YA==
Received: from johan by xi.lan with local (Exim 4.93.0.4)
        (envelope-from <johan@kernel.org>)
        id 1lMYxP-0001kV-MY; Wed, 17 Mar 2021 17:23:39 +0100
Date:   Wed, 17 Mar 2021 17:23:39 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-serial@vger.kernel.org
Subject: Re: [patch 1/1] genirq: Disable interrupts for force threaded
 handlers
Message-ID: <YFItC/biHWUCkKt0@hovoldconsulting.com>
References: <20210317143859.513307808@linutronix.de>
 <20210317144806.y4dogv6n2s62fpnw@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210317144806.y4dogv6n2s62fpnw@linutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 17, 2021 at 03:48:06PM +0100, Sebastian Andrzej Siewior wrote:
> On 2021-03-17 15:38:52 [+0100], Thomas Gleixner wrote:
> > With interrupt force threading all device interrupt handlers are invoked
> > from kernel threads. Contrary to hard interrupt context the invocation only
> > disables bottom halfs, but not interrupts. This was an oversight back then
> > because any code like this will have an issue:
> > 
> > thread(irq_A)
> >   irq_handler(A)
> >     spin_lock(&foo->lock);
> > 
> > interrupt(irq_B)
> >   irq_handler(B)
> >     spin_lock(&foo->lock);
> 
> It will not because both threads will wake_up(thread).

Note that the above says "interrupt(irq_B)" suggesting it's a
non-threaded interrupt unlike irq_A.

> It is an issue if
> - if &foo->lock is shared between a hrtimer and threaded-IRQ
> - if &foo->lock is shared between a non-threaded and thread-IRQ

So this is the above case.

> - if &foo->lock is shared between a printk() in hardirq context and
>   thread-IRQ as I learned today.

But generally it's any lock taken by a threaded handler that can end up
being taken in hard interrupt context.

> > This has been triggered with networking (NAPI vs. hrtimers) and console
> > drivers where printk() happens from an interrupt which interrupted the
> > force threaded handler.
> > 
> > Now people noticed and started to change the spin_lock() in the handler to
> > spin_lock_irqsave() which affects performance or add IRQF_NOTHREAD to the
> > interrupt request which in turn breaks RT.
> >
> > Fix the root cause and not the symptom and disable interrupts before
> > invoking the force threaded handler which preserves the regular semantics
> > and the usefulness of the interrupt force threading as a general debugging
> > tool.
> > 
> > For not RT this is not changing much, except that during the execution of
> > the threaded handler interrupts are delayed until the handler
> > returns. Vs. scheduling and softirq processing there is no difference.
> > 
> > For RT kernels there is no issue.
> 
> Acked-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

Reviewed-by: Johan Hovold <johan@kernel.org>

> > Fixes: 8d32a307e4fa ("genirq: Provide forced interrupt threading")
> > Reported-by: Johan Hovold <johan@kernel.org>
> > Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Eric Dumazet <edumazet@google.com>
> > Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> > Cc: netdev <netdev@vger.kernel.org>
> > Cc: "David S. Miller" <davem@davemloft.net>
> > Cc: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
> > CC: Peter Zijlstra <peterz@infradead.org>
> > Cc: linux-serial@vger.kernel.org
> > Cc: netdev <netdev@vger.kernel.org>
> > ---
> >  kernel/irq/manage.c |    4 ++++
> >  1 file changed, 4 insertions(+)
> > 
> > --- a/kernel/irq/manage.c
> > +++ b/kernel/irq/manage.c
> > @@ -1142,11 +1142,15 @@ irq_forced_thread_fn(struct irq_desc *de
> >  	irqreturn_t ret;
> >  
> >  	local_bh_disable();
> > +	if (!IS_ENABLED(CONFIG_PREEMPT_RT))
> > +		local_irq_disable();
> >  	ret = action->thread_fn(action->irq, action->dev_id);
> >  	if (ret == IRQ_HANDLED)
> >  		atomic_inc(&desc->threads_handled);
> >  
> >  	irq_finalize_oneshot(desc, action);
> > +	if (!IS_ENABLED(CONFIG_PREEMPT_RT))
> > +		local_irq_enable();
> >  	local_bh_enable();
> >  	return ret;
> >  }

Johan
