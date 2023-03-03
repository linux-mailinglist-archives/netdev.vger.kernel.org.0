Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8183A6A9866
	for <lists+netdev@lfdr.de>; Fri,  3 Mar 2023 14:30:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229914AbjCCNaz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Mar 2023 08:30:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230098AbjCCNav (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Mar 2023 08:30:51 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CBB43B21F;
        Fri,  3 Mar 2023 05:30:49 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1677850247;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WFrf+4KjnDqnjIJPa+3ulKTimlZVcklP8uEfLCofwrw=;
        b=JA0DmwiHaxxZZEZXV9Ior1fRwq42c3rhJN29dTUwSCFS4G0Ek97w/4WJzkgfI6rQ6Vuiu2
        a1RJLTf5KEuyAkIpm42KdQoNnD2k8/QLpq5BeI3kZxooTdgutse83tndn76EyU6yWo09eW
        boWQKuz0bYVwpTkDv3/dHgZ1Z0QYs9b2JYZtKVhKbVAWPlEwA/HHfOV4iPuuSiY4GBCvln
        mFkHmTYgD5OD/ySJGZe4aSxQdRJPUn6gneChS6JlpqBFhsGD6LtdSOGRffNlE638hLGQgq
        Bf2WlvSQ3Q1yaioIgbwYYRxEDouD+fiyEL4Au4pcVPhvLoCpZfdEV61+Yo1Hfw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1677850247;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WFrf+4KjnDqnjIJPa+3ulKTimlZVcklP8uEfLCofwrw=;
        b=KQKixg7ykHH5xju6FJaXfBKIIJIeGQ1j2HhBA6SS8mi3tzFccuPuKbY0aNYjp4DWnq6Spu
        tIKllozHcvzXVkAA==
To:     Jakub Kicinski <kuba@kernel.org>, peterz@infradead.org
Cc:     jstultz@google.com, edumazet@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH 2/3] softirq: avoid spurious stalls due to need_resched()
In-Reply-To: <20221222221244.1290833-3-kuba@kernel.org>
References: <20221222221244.1290833-1-kuba@kernel.org>
 <20221222221244.1290833-3-kuba@kernel.org>
Date:   Fri, 03 Mar 2023 14:30:46 +0100
Message-ID: <87r0u6j721.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub!

On Thu, Dec 22 2022 at 14:12, Jakub Kicinski wrote:
>  DEFINE_PER_CPU(struct task_struct *, ksoftirqd);
> +static DEFINE_PER_CPU(unsigned long, overload_limit);
>  
>  const char * const softirq_to_name[NR_SOFTIRQS] = {
>  	"HI", "TIMER", "NET_TX", "NET_RX", "BLOCK", "IRQ_POLL",
> @@ -89,10 +90,15 @@ static void wakeup_softirqd(void)
>  static bool ksoftirqd_should_handle(unsigned long pending)
>  {
>  	struct task_struct *tsk = __this_cpu_read(ksoftirqd);
> +	unsigned long ov_limit;
>  
>  	if (pending & SOFTIRQ_NOW_MASK)
>  		return false;
> -	return tsk && task_is_running(tsk) && !__kthread_should_park(tsk);
> +	if (likely(!tsk || !task_is_running(tsk) || __kthread_should_park(tsk)))
> +		return false;
> +
> +	ov_limit = __this_cpu_read(overload_limit);
> +	return time_is_after_jiffies(ov_limit);

	return time_is_after_jiffies(__this_cpu_read(overload_limit));

Plus a comment explaining the magic, please.

>  }
>  
>  #ifdef CONFIG_TRACE_IRQFLAGS
> @@ -492,6 +498,9 @@ asmlinkage __visible void do_softirq(void)
>  #define MAX_SOFTIRQ_TIME  msecs_to_jiffies(2)
>  #define MAX_SOFTIRQ_RESTART 10
>  
> +#define SOFTIRQ_OVERLOAD_TIME	msecs_to_jiffies(100)
> +#define SOFTIRQ_DEFER_TIME	msecs_to_jiffies(2)
> +
>  #ifdef CONFIG_TRACE_IRQFLAGS
>  /*
>   * When we run softirqs from irq_exit() and thus on the hardirq stack we need
> @@ -588,10 +597,16 @@ asmlinkage __visible void __softirq_entry __do_softirq(void)
>  
>  	pending = local_softirq_pending();
>  	if (pending) {
> -		if (time_before(jiffies, end) && !need_resched() &&
> -		    --max_restart)
> +		unsigned long limit;
> +
> +		if (time_is_before_eq_jiffies(end) || !--max_restart)
> +			limit = SOFTIRQ_OVERLOAD_TIME;
> +		else if (need_resched())
> +			limit = SOFTIRQ_DEFER_TIME;
> +		else
>  			goto restart;
>  
> +		__this_cpu_write(overload_limit, jiffies + limit);

The logic of all this is non-obvious and I had to reread it 5 times to
conclude that it is matching the intent. Please add comments.

While I'm not a big fan of heuristical duct tape, this looks harmless
enough to not end up in an endless stream of tweaking. Famous last
words...

But without the sched_clock() changes the actual defer time depends on
HZ and the point in time where limit is set. That means it ranges from 0
to 1/HZ, i.e. the 2ms defer time ends up with close to 10ms on HZ=100 in
the worst case, which perhaps explains the 8ms+ stalls you are still
observing. Can you test with that sched_clock change applied, i.e. the
first two commits from

  git://git.kernel.org/pub/scm/linux/kernel/git/peterz/queue.git core/softirq

59be25c466d9 ("softirq: Use sched_clock() based timeout")
bd5a5bd77009 ("softirq: Rewrite softirq processing loop")

whether that makes a difference? Those two can be applied with some
minor polishing. The rest of that series is broken by f10020c97f4c
("softirq: Allow early break").

There is another issue with this overload limit. Assume max_restart or
timeout triggered and limit was set to now + 100ms. ksoftirqd runs and
gets the issue resolved after 10ms.

So for the remaining 90ms any invocation of raise_softirq() outside of
(soft)interrupt context, which wakes ksoftirqd again, prevents
processing on return from interrupt until ksoftirqd gets on the CPU and
goes back to sleep, because task_is_running() == true and the stale
limit is not after jiffies.

Probably not a big issue, but someone will notice on some weird workload
sooner than later and the tweaking will start nevertheless. :) So maybe
we fix it right away. :)

Thanks,

        tglx
