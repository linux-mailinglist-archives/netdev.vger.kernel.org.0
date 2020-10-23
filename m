Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48584296A2A
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 09:19:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S374103AbgJWHTZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 03:19:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S369274AbgJWHTY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Oct 2020 03:19:24 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 706E0C0613CE;
        Fri, 23 Oct 2020 00:19:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=f2zG0rse0rP2KMvxNrYyo4BrFzXK52fXqXFpWjS+UJM=; b=KM9p6HAHydkdVAr48tQn8+RqNd
        H0CBbXtOAQHVSWkRBySQs1qJTutTJAbSTO5x1+V/1fJbyHewmKzc5jalKusP2kPYxqQcSxa0sTGQy
        V5krYT+EyRkZozcMWAiDL/fK75plVEXvCC0ZvepZaFnI23WwamSwYRMWVbPN3wGBGzkgBmBK1Ogj9
        877xRZd9XOIJCCAdevUybXx7rIUKjNbD/zxFwpswX/Oj/pgci7Fv7EGYWvcISyQI3h1dI2O32pK7B
        /Xb/avXNb8uqZrBHVKQJwwX2nNNherwfQXs+XRYarbD8Pwz9W47zOI9ejy9L8tRy88DvTLXL54E5l
        ouPk+0mg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kVrLu-00088z-Kk; Fri, 23 Oct 2020 07:19:06 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id A65D5304D28;
        Fri, 23 Oct 2020 09:19:05 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 8FA0E203D09CB; Fri, 23 Oct 2020 09:19:05 +0200 (CEST)
Date:   Fri, 23 Oct 2020 09:19:05 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Josh Don <joshdon@google.com>, g@hirez.programming.kicks-ass.net
Cc:     Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, Xi Wang <xii@google.com>
Subject: Re: [PATCH 1/3] sched: better handling for busy polling loops
Message-ID: <20201023071905.GL2611@hirez.programming.kicks-ass.net>
References: <20201023032944.399861-1-joshdon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201023032944.399861-1-joshdon@google.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 22, 2020 at 08:29:42PM -0700, Josh Don wrote:
> Busy polling loops in the kernel such as network socket poll and kvm
> halt polling have performance problems related to process scheduler load
> accounting.

AFAICT you're not actually fixing the load accounting issue at all.

> This change also disables preemption for the duration of the busy
> polling loop. This is important, as it ensures that if a polling thread
> decides to end its poll to relinquish cpu to another thread, the polling
> thread will actually exit the busy loop and potentially block. When it
> later becomes runnable, it will have the opportunity to find an idle cpu
> via wakeup cpu selection.

At the cost of inducing a sleep+wake cycle; which is mucho expensive. So
this could go either way. No data presented.

> +void prepare_to_busy_poll(void)
> +{
> +	struct rq __maybe_unused *rq = this_rq();
> +	unsigned long __maybe_unused flags;
> +
> +	/* Preemption will be reenabled by end_busy_poll() */
> +	preempt_disable();
> +
> +#ifdef CONFIG_SMP
> +	raw_spin_lock_irqsave(&rq->lock, flags);
> +	/* preemption disabled; only one thread can poll at a time */
> +	WARN_ON_ONCE(rq->busy_polling);
> +	rq->busy_polling++;
> +	raw_spin_unlock_irqrestore(&rq->lock, flags);
> +#endif

Explain to me the purpose of that rq->lock usage.

> +}
> +EXPORT_SYMBOL(prepare_to_busy_poll);

_GPL

> +
> +int continue_busy_poll(void)
> +{
> +	if (!single_task_running())
> +		return 0;

Why? If there's more, we'll end up in the below condition anyway.

> +
> +	/* Important that we check this, since preemption is disabled */
> +	if (need_resched())
> +		return 0;
> +
> +	return 1;
> +}
> +EXPORT_SYMBOL(continue_busy_poll);

_GPL

> +
> +/*
> + * Restore any state modified by prepare_to_busy_poll(), including re-enabling
> + * preemption.
> + *
> + * @allow_resched: If true, this potentially calls schedule() as part of
> + * enabling preemption. A busy poll loop can use false in order to have an
> + * opportunity to block before rescheduling.
> + */
> +void end_busy_poll(bool allow_resched)
> +{
> +#ifdef CONFIG_SMP
> +	struct rq *rq = this_rq();
> +	unsigned long flags;
> +
> +	raw_spin_lock_irqsave(&rq->lock, flags);
> +	BUG_ON(!rq->busy_polling); /* not paired with prepare() */
> +	rq->busy_polling--;
> +	raw_spin_unlock_irqrestore(&rq->lock, flags);
> +#endif

Again, please explain this lock usage.

> +
> +	/*
> +	 * preemption needs to be kept disabled between prepare_to_busy_poll()
> +	 * and end_busy_poll().
> +	 */
> +	BUG_ON(preemptible());
> +	if (allow_resched)
> +		preempt_enable();
> +	else
> +		preempt_enable_no_resched();

NAK on @allow_resched

> +}
> +EXPORT_SYMBOL(end_busy_poll);

_GPL

> +
>  #ifdef CONFIG_CGROUP_SCHED
>  /* task_group_lock serializes the addition/removal of task groups */
>  static DEFINE_SPINLOCK(task_group_lock);
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 1a68a0536add..58e525c74cc6 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -5460,6 +5460,11 @@ static int sched_idle_cpu(int cpu)
>  {
>  	return sched_idle_rq(cpu_rq(cpu));
>  }
> +
> +static int sched_idle_or_polling_cpu(int cpu)
> +{
> +	return sched_idle_cpu(cpu) || polling_cpu(cpu);
> +}
>  #endif
>  
>  /*
> @@ -5880,6 +5885,7 @@ find_idlest_group_cpu(struct sched_group *group, struct task_struct *p, int this
>  	u64 latest_idle_timestamp = 0;
>  	int least_loaded_cpu = this_cpu;
>  	int shallowest_idle_cpu = -1;
> +	int found_polling = 0;
>  	int i;
>  
>  	/* Check if we have any choice: */
> @@ -5914,10 +5920,14 @@ find_idlest_group_cpu(struct sched_group *group, struct task_struct *p, int this
>  				shallowest_idle_cpu = i;
>  			}
>  		} else if (shallowest_idle_cpu == -1) {
> +			int polling = polling_cpu(i);
> +
>  			load = cpu_load(cpu_rq(i));
> -			if (load < min_load) {
> +			if ((polling == found_polling && load < min_load) ||
> +			    (polling && !found_polling)) {
>  				min_load = load;
>  				least_loaded_cpu = i;
> +				found_polling = polling;
>  			}
>  		}
>  	}
> @@ -6085,7 +6095,7 @@ static int select_idle_smt(struct task_struct *p, int target)
>  	for_each_cpu(cpu, cpu_smt_mask(target)) {
>  		if (!cpumask_test_cpu(cpu, p->cpus_ptr))
>  			continue;
> -		if (available_idle_cpu(cpu) || sched_idle_cpu(cpu))
> +		if (available_idle_cpu(cpu) || sched_idle_or_polling_cpu(cpu))
>  			return cpu;
>  	}
>  
> @@ -6149,7 +6159,7 @@ static int select_idle_cpu(struct task_struct *p, struct sched_domain *sd, int t
>  	for_each_cpu_wrap(cpu, cpus, target) {
>  		if (!--nr)
>  			return -1;
> -		if (available_idle_cpu(cpu) || sched_idle_cpu(cpu))
> +		if (available_idle_cpu(cpu) || sched_idle_or_polling_cpu(cpu))
>  			break;
>  	}
>  
> @@ -6179,7 +6189,7 @@ select_idle_capacity(struct task_struct *p, struct sched_domain *sd, int target)
>  	for_each_cpu_wrap(cpu, cpus, target) {
>  		unsigned long cpu_cap = capacity_of(cpu);
>  
> -		if (!available_idle_cpu(cpu) && !sched_idle_cpu(cpu))
> +		if (!available_idle_cpu(cpu) && !sched_idle_or_polling_cpu(cpu))
>  			continue;
>  		if (task_fits_capacity(p, cpu_cap))
>  			return cpu;
> @@ -6223,14 +6233,14 @@ static int select_idle_sibling(struct task_struct *p, int prev, int target)
>  	}
>  
>  symmetric:
> -	if (available_idle_cpu(target) || sched_idle_cpu(target))
> +	if (available_idle_cpu(target) || sched_idle_or_polling_cpu(target))
>  		return target;
>  
>  	/*
>  	 * If the previous CPU is cache affine and idle, don't be stupid:
>  	 */
>  	if (prev != target && cpus_share_cache(prev, target) &&
> -	    (available_idle_cpu(prev) || sched_idle_cpu(prev)))
> +	    (available_idle_cpu(prev) || sched_idle_or_polling_cpu(prev)))
>  		return prev;
>  
>  	/*
> @@ -6252,7 +6262,8 @@ static int select_idle_sibling(struct task_struct *p, int prev, int target)
>  	if (recent_used_cpu != prev &&
>  	    recent_used_cpu != target &&
>  	    cpus_share_cache(recent_used_cpu, target) &&
> -	    (available_idle_cpu(recent_used_cpu) || sched_idle_cpu(recent_used_cpu)) &&
> +	    (available_idle_cpu(recent_used_cpu) ||
> +	     sched_idle_or_polling_cpu(recent_used_cpu)) &&
>  	    cpumask_test_cpu(p->recent_used_cpu, p->cpus_ptr)) {
>  		/*
>  		 * Replace recent_used_cpu with prev as it is a potential


None of this affects load-tracking

> diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
> index 28709f6b0975..45de468d0ffb 100644
> --- a/kernel/sched/sched.h
> +++ b/kernel/sched/sched.h
> @@ -1003,6 +1003,8 @@ struct rq {
>  
>  	/* This is used to determine avg_idle's max value */
>  	u64			max_idle_balance_cost;
> +
> +	unsigned int		busy_polling;

This is a good location, cache-wise, because?

>  #endif /* CONFIG_SMP */
>  
>  #ifdef CONFIG_IRQ_TIME_ACCOUNTING
