Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7AC118A9DE
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 01:34:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727236AbgCSAdz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 20:33:55 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:41354 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726596AbgCSAdy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 20:33:54 -0400
Received: by mail-qt1-f195.google.com with SMTP id i26so366056qtq.8
        for <netdev@vger.kernel.org>; Wed, 18 Mar 2020 17:33:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=cHl5FEDU/in/tKhyh8KADSkZ8t44HVVU6qSIiQF7HDk=;
        b=vKjz15irrUHQOxGKx3YJZSYaREZiLBQ5dkdKASVNi/DUnapYI1oeMp9PSbchikzKPl
         RL8eE9BxcoQ9gT2Z+96oGA/M+zvf4M7Ww0jlnMdeOCV7wPsoaRRDYZ+t1YRHJBhYvxmw
         JQHaOq18/lt39V3Rogoc35Lu1FpkxEJUwdFM4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=cHl5FEDU/in/tKhyh8KADSkZ8t44HVVU6qSIiQF7HDk=;
        b=BcmCXQwZrUuMNGdpzO8hTFyBP6nyz4Z74W38QonQa0CkWPfqcbYmmp9JOpnJaiZAcP
         8aoy2Dd3aybtgbKUkQpSGpVQmH8aKVBNsNG0bSt4NiPZzRSWHGzulItAr2dg+JBYQaor
         io23PDRCBkDqq1c8jcivfChLITbiOuHBkHad7q9g2MSRQ9uvB8jfBJPNtEx6e2VzwyRr
         KyqgajIgtEUwT1f8oTg/5xycYS0DcmfrHk1sK6cnADYOXZpHwV45OKhmky7hwPebwA9s
         Xcb+80ik5vlJBH/emaelFIjOvz7expdfv9pvWNmFBZE0bKnYHWN/dGnF2T/UopbKYYfx
         UQIA==
X-Gm-Message-State: ANhLgQ1K8Z9aNfYezJV20LxnpTqhFPoGEJz3+ByS/+6N3xjWTT9X134h
        7rFcMfngBsxXU7bdY4YO+yQTIA==
X-Google-Smtp-Source: ADFU+vte9vg5yrKnsJYwQUFLJMp35Yp0oNpQIim2wyXmoa5rkeGpiqYzRFosPkhMiCPa11iAMkqA+g==
X-Received: by 2002:ac8:1762:: with SMTP id u31mr389327qtk.359.1584578032733;
        Wed, 18 Mar 2020 17:33:52 -0700 (PDT)
Received: from localhost ([2620:15c:6:12:9c46:e0da:efbf:69cc])
        by smtp.gmail.com with ESMTPSA id f13sm456312qkm.19.2020.03.18.17.33.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Mar 2020 17:33:52 -0700 (PDT)
Date:   Wed, 18 Mar 2020 20:33:51 -0400
From:   Joel Fernandes <joel@joelfernandes.org>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Will Deacon <will@kernel.org>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Logan Gunthorpe <logang@deltatee.com>,
        Kurt Schwemmer <kurt.schwemmer@microsemi.com>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Michael Ellerman <mpe@ellerman.id.au>,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [patch V2 11/15] completion: Use simple wait queues
Message-ID: <20200319003351.GA211584@google.com>
References: <20200318204302.693307984@linutronix.de>
 <20200318204408.521507446@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200318204408.521507446@linutronix.de>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Thomas,

On Wed, Mar 18, 2020 at 09:43:13PM +0100, Thomas Gleixner wrote:
> From: Thomas Gleixner <tglx@linutronix.de>
> 
> completion uses a wait_queue_head_t to enqueue waiters.
> 
> wait_queue_head_t contains a spinlock_t to protect the list of waiters
> which excludes it from being used in truly atomic context on a PREEMPT_RT
> enabled kernel.
> 
> The spinlock in the wait queue head cannot be replaced by a raw_spinlock
> because:
> 
>   - wait queues can have custom wakeup callbacks, which acquire other
>     spinlock_t locks and have potentially long execution times

Cool, makes sense.

>   - wake_up() walks an unbounded number of list entries during the wake up
>     and may wake an unbounded number of waiters.

Just to clarify here, wake_up() will really wake up just 1 waiter if all the
waiters on the queue are exclusive right? So in such scenario at least, the
"unbounded number of waiters" would not be an issue if everything waiting was
exclusive and waitqueue with wake_up() was used. Please correct me if I'm
wrong about that though.

So the main reasons to avoid waitqueue in favor of swait (as you mentioned)
would be the sleep-while-atomic issue in truly atomic context on RT, and the
fact that callbacks can take a long time.

> 
> For simplicity and performance reasons complete() should be usable on
> PREEMPT_RT enabled kernels.
> 
> completions do not use custom wakeup callbacks and are usually single
> waiter, except for a few corner cases.
> 
> Replace the wait queue in the completion with a simple wait queue (swait),
> which uses a raw_spinlock_t for protecting the waiter list and therefore is
> safe to use inside truly atomic regions on PREEMPT_RT.
> 
> There is no semantical or functional change:
> 
>   - completions use the exclusive wait mode which is what swait provides
> 
>   - complete() wakes one exclusive waiter
> 
>   - complete_all() wakes all waiters while holding the lock which protects
>     the wait queue against newly incoming waiters. The conversion to swait
>     preserves this behaviour.
> 
> complete_all() might cause unbound latencies with a large number of waiters
> being woken at once, but most complete_all() usage sites are either in
> testing or initialization code or have only a really small number of
> concurrent waiters which for now does not cause a latency problem. Keep it
> simple for now.
> 
> The fixup of the warning check in the USB gadget driver is just a straight
> forward conversion of the lockless waiter check from one waitqueue type to
> the other.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Arnd Bergmann <arnd@arndb.de>

Reviewed-by: Joel Fernandes (Google) <joel@joelfernandes.org>

thanks,

 - Joel


> ---
> V2: Split out the orinoco and usb gadget parts and amended change log
> ---
>  drivers/usb/gadget/function/f_fs.c |    2 +-
>  include/linux/completion.h         |    8 ++++----
>  kernel/sched/completion.c          |   36 +++++++++++++++++++-----------------
>  3 files changed, 24 insertions(+), 22 deletions(-)
> 
> --- a/drivers/usb/gadget/function/f_fs.c
> +++ b/drivers/usb/gadget/function/f_fs.c
> @@ -1703,7 +1703,7 @@ static void ffs_data_put(struct ffs_data
>  		pr_info("%s(): freeing\n", __func__);
>  		ffs_data_clear(ffs);
>  		BUG_ON(waitqueue_active(&ffs->ev.waitq) ||
> -		       waitqueue_active(&ffs->ep0req_completion.wait) ||
> +		       swait_active(&ffs->ep0req_completion.wait) ||
>  		       waitqueue_active(&ffs->wait));
>  		destroy_workqueue(ffs->io_completion_wq);
>  		kfree(ffs->dev_name);
> --- a/include/linux/completion.h
> +++ b/include/linux/completion.h
> @@ -9,7 +9,7 @@
>   * See kernel/sched/completion.c for details.
>   */
>  
> -#include <linux/wait.h>
> +#include <linux/swait.h>
>  
>  /*
>   * struct completion - structure used to maintain state for a "completion"
> @@ -25,7 +25,7 @@
>   */
>  struct completion {
>  	unsigned int done;
> -	wait_queue_head_t wait;
> +	struct swait_queue_head wait;
>  };
>  
>  #define init_completion_map(x, m) __init_completion(x)
> @@ -34,7 +34,7 @@ static inline void complete_acquire(stru
>  static inline void complete_release(struct completion *x) {}
>  
>  #define COMPLETION_INITIALIZER(work) \
> -	{ 0, __WAIT_QUEUE_HEAD_INITIALIZER((work).wait) }
> +	{ 0, __SWAIT_QUEUE_HEAD_INITIALIZER((work).wait) }
>  
>  #define COMPLETION_INITIALIZER_ONSTACK_MAP(work, map) \
>  	(*({ init_completion_map(&(work), &(map)); &(work); }))
> @@ -85,7 +85,7 @@ static inline void complete_release(stru
>  static inline void __init_completion(struct completion *x)
>  {
>  	x->done = 0;
> -	init_waitqueue_head(&x->wait);
> +	init_swait_queue_head(&x->wait);
>  }
>  
>  /**
> --- a/kernel/sched/completion.c
> +++ b/kernel/sched/completion.c
> @@ -29,12 +29,12 @@ void complete(struct completion *x)
>  {
>  	unsigned long flags;
>  
> -	spin_lock_irqsave(&x->wait.lock, flags);
> +	raw_spin_lock_irqsave(&x->wait.lock, flags);
>  
>  	if (x->done != UINT_MAX)
>  		x->done++;
> -	__wake_up_locked(&x->wait, TASK_NORMAL, 1);
> -	spin_unlock_irqrestore(&x->wait.lock, flags);
> +	swake_up_locked(&x->wait);
> +	raw_spin_unlock_irqrestore(&x->wait.lock, flags);
>  }
>  EXPORT_SYMBOL(complete);
>  
> @@ -58,10 +58,12 @@ void complete_all(struct completion *x)
>  {
>  	unsigned long flags;
>  
> -	spin_lock_irqsave(&x->wait.lock, flags);
> +	WARN_ON(irqs_disabled());
> +
> +	raw_spin_lock_irqsave(&x->wait.lock, flags);
>  	x->done = UINT_MAX;
> -	__wake_up_locked(&x->wait, TASK_NORMAL, 0);
> -	spin_unlock_irqrestore(&x->wait.lock, flags);
> +	swake_up_all_locked(&x->wait);
> +	raw_spin_unlock_irqrestore(&x->wait.lock, flags);
>  }
>  EXPORT_SYMBOL(complete_all);
>  
> @@ -70,20 +72,20 @@ do_wait_for_common(struct completion *x,
>  		   long (*action)(long), long timeout, int state)
>  {
>  	if (!x->done) {
> -		DECLARE_WAITQUEUE(wait, current);
> +		DECLARE_SWAITQUEUE(wait);
>  
> -		__add_wait_queue_entry_tail_exclusive(&x->wait, &wait);
>  		do {
>  			if (signal_pending_state(state, current)) {
>  				timeout = -ERESTARTSYS;
>  				break;
>  			}
> +			__prepare_to_swait(&x->wait, &wait);
>  			__set_current_state(state);
> -			spin_unlock_irq(&x->wait.lock);
> +			raw_spin_unlock_irq(&x->wait.lock);
>  			timeout = action(timeout);
> -			spin_lock_irq(&x->wait.lock);
> +			raw_spin_lock_irq(&x->wait.lock);
>  		} while (!x->done && timeout);
> -		__remove_wait_queue(&x->wait, &wait);
> +		__finish_swait(&x->wait, &wait);
>  		if (!x->done)
>  			return timeout;
>  	}
> @@ -100,9 +102,9 @@ static inline long __sched
>  
>  	complete_acquire(x);
>  
> -	spin_lock_irq(&x->wait.lock);
> +	raw_spin_lock_irq(&x->wait.lock);
>  	timeout = do_wait_for_common(x, action, timeout, state);
> -	spin_unlock_irq(&x->wait.lock);
> +	raw_spin_unlock_irq(&x->wait.lock);
>  
>  	complete_release(x);
>  
> @@ -291,12 +293,12 @@ bool try_wait_for_completion(struct comp
>  	if (!READ_ONCE(x->done))
>  		return false;
>  
> -	spin_lock_irqsave(&x->wait.lock, flags);
> +	raw_spin_lock_irqsave(&x->wait.lock, flags);
>  	if (!x->done)
>  		ret = false;
>  	else if (x->done != UINT_MAX)
>  		x->done--;
> -	spin_unlock_irqrestore(&x->wait.lock, flags);
> +	raw_spin_unlock_irqrestore(&x->wait.lock, flags);
>  	return ret;
>  }
>  EXPORT_SYMBOL(try_wait_for_completion);
> @@ -322,8 +324,8 @@ bool completion_done(struct completion *
>  	 * otherwise we can end up freeing the completion before complete()
>  	 * is done referencing it.
>  	 */
> -	spin_lock_irqsave(&x->wait.lock, flags);
> -	spin_unlock_irqrestore(&x->wait.lock, flags);
> +	raw_spin_lock_irqsave(&x->wait.lock, flags);
> +	raw_spin_unlock_irqrestore(&x->wait.lock, flags);
>  	return true;
>  }
>  EXPORT_SYMBOL(completion_done);
> 
