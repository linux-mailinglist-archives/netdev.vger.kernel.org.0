Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C260296A54
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 09:34:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S375701AbgJWHdk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 03:33:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S374332AbgJWHdj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Oct 2020 03:33:39 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71320C0613D2
        for <netdev@vger.kernel.org>; Fri, 23 Oct 2020 00:33:39 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id a28so527593ljn.3
        for <netdev@vger.kernel.org>; Fri, 23 Oct 2020 00:33:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6JAQeHYMqXpMldk8JQobgvhauwplXDCUcYMagMcGHGM=;
        b=NlxqnO4oMlZ2ZoJdItkVl7kcfZZyYS1s35hmQJX7uITJ7BnN+y0E6C69/VDT3RD3gP
         1a9D4AwM4RaIOyZ4m28HvhpifXumj41YzualgJlDoOupuRnBepfZPxTsT65A4GCKo0TP
         MdjgOuwN+qvnQZ8tQnpWQGO8sT1raxxVKimVrpscJVk35fVuw/qM3GGIYdQjTd9fwFbt
         tU51TReVLUI8Ow2BVUYvlLgZjZ/0BbHGrQhZtySIiw5POyAHMce8mRWqTRco5fAQBFFl
         s7sYtOi+CBBP93OzUvIXYpKRVWFc8Vfwh64r8EykF7i4rHB2VXkzzkkGAaIJl5UAiTzv
         bpSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6JAQeHYMqXpMldk8JQobgvhauwplXDCUcYMagMcGHGM=;
        b=g/ggdHyB1x4O5jLmVdQrzcLspcergraYoDpZf/beLNxP6BvTqgjtobbJ5JGDCbBp58
         Tx1923SAeslrfpw1TKtL73QFanzfMYQSp7d9XGAkzc+nPJH+JJsXO83vF44qMvW/57pC
         WfFUlAwgadQcmFHqH47Bh9VkJ8ISGlqYc+jlqXSIr1uZmOHCiohGeyD6lx4Mvyudp7cJ
         aJf5O1UMw+DmKNVtNFZpzIrPUbOtEEG89+hVBH7uiQx8/24s09Tk+Yo0vmbb4qwUTWGw
         1UIpghe/t6kbbkVcEvzJgopt3PNrczOGVjTRZJKMBje9Wx6qDo1uDMUR+OxyKi6BW32G
         aapA==
X-Gm-Message-State: AOAM532Wz2F1G49k2mdF3638OF/HgkbzCbMDOnmbIenQdymauvXdvcX2
        8FvbOEO0ahBtPJh77M83W6RBOQWKebIe3awu1JOrOA==
X-Google-Smtp-Source: ABdhPJxey4rsinYXHX3dT6YhKnbNtHZFQi2Hu0l/py8Kl6WUTXgp8TdU9Gc2zDE1IBRKkYrgxtAWz4QmXjxLpMVjshM=
X-Received: by 2002:a2e:8787:: with SMTP id n7mr363627lji.111.1603438417652;
 Fri, 23 Oct 2020 00:33:37 -0700 (PDT)
MIME-Version: 1.0
References: <20201023032944.399861-1-joshdon@google.com>
In-Reply-To: <20201023032944.399861-1-joshdon@google.com>
From:   Vincent Guittot <vincent.guittot@linaro.org>
Date:   Fri, 23 Oct 2020 09:33:26 +0200
Message-ID: <CAKfTPtAEP9nzW3UD8qdB8vyGjjoXzYHZA0eiHrdBW3Oh0MJWmQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] sched: better handling for busy polling loops
To:     Josh Don <joshdon@google.com>
Cc:     Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, kvm@vger.kernel.org,
        Xi Wang <xii@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 23 Oct 2020 at 05:30, Josh Don <joshdon@google.com> wrote:
>
> Busy polling loops in the kernel such as network socket poll and kvm
> halt polling have performance problems related to process scheduler load
> accounting.
>
> Both of the busy polling examples are opportunistic - they relinquish
> the cpu if another thread is ready to run. This design, however, doesn't
> extend to multiprocessor load balancing very well. The scheduler still
> sees the busy polling cpu as 100% busy and will be less likely to put
> another thread on that cpu. In other words, if all cores are 100%
> utilized and some of them are running real workloads and some others are
> running busy polling loops, newly woken up threads will not prefer the
> busy polling cpus. System wide throughput and latency may suffer.
>
> This change allows the scheduler to detect busy polling cpus in order to
> allow them to be more frequently considered for wake up balancing.
>
> This change also disables preemption for the duration of the busy
> polling loop. This is important, as it ensures that if a polling thread
> decides to end its poll to relinquish cpu to another thread, the polling
> thread will actually exit the busy loop and potentially block. When it
> later becomes runnable, it will have the opportunity to find an idle cpu
> via wakeup cpu selection.
>
> Suggested-by: Xi Wang <xii@google.com>
> Signed-off-by: Josh Don <joshdon@google.com>
> Signed-off-by: Xi Wang <xii@google.com>
> ---
>  include/linux/sched.h |  5 +++
>  kernel/sched/core.c   | 94 +++++++++++++++++++++++++++++++++++++++++++
>  kernel/sched/fair.c   | 25 ++++++++----
>  kernel/sched/sched.h  |  2 +
>  4 files changed, 119 insertions(+), 7 deletions(-)
>
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index afe01e232935..80ef477e5a87 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1651,6 +1651,7 @@ extern int can_nice(const struct task_struct *p, const int nice);
>  extern int task_curr(const struct task_struct *p);
>  extern int idle_cpu(int cpu);
>  extern int available_idle_cpu(int cpu);
> +extern int polling_cpu(int cpu);
>  extern int sched_setscheduler(struct task_struct *, int, const struct sched_param *);
>  extern int sched_setscheduler_nocheck(struct task_struct *, int, const struct sched_param *);
>  extern void sched_set_fifo(struct task_struct *p);
> @@ -2048,4 +2049,8 @@ int sched_trace_rq_nr_running(struct rq *rq);
>
>  const struct cpumask *sched_trace_rd_span(struct root_domain *rd);
>
> +extern void prepare_to_busy_poll(void);
> +extern int continue_busy_poll(void);
> +extern void end_busy_poll(bool allow_resched);
> +
>  #endif
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 2d95dc3f4644..2783191d0bd4 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -5107,6 +5107,24 @@ int available_idle_cpu(int cpu)
>         return 1;
>  }
>
> +/**
> + * polling_cpu - is a given CPU currently running a thread in a busy polling
> + * loop that could be preempted if a new thread were to be scheduled?
> + * @cpu: the CPU in question.
> + *
> + * Return: 1 if the CPU is currently polling. 0 otherwise.
> + */
> +int polling_cpu(int cpu)
> +{
> +#ifdef CONFIG_SMP
> +       struct rq *rq = cpu_rq(cpu);
> +
> +       return unlikely(rq->busy_polling);
> +#else
> +       return 0;
> +#endif
> +}
> +
>  /**
>   * idle_task - return the idle task for a given CPU.
>   * @cpu: the processor in question.
> @@ -7191,6 +7209,7 @@ void __init sched_init(void)
>
>                 rq_csd_init(rq, &rq->nohz_csd, nohz_csd_func);
>  #endif
> +               rq->busy_polling = 0;
>  #endif /* CONFIG_SMP */
>                 hrtick_rq_init(rq);
>                 atomic_set(&rq->nr_iowait, 0);
> @@ -7417,6 +7436,81 @@ void ia64_set_curr_task(int cpu, struct task_struct *p)
>
>  #endif
>
> +/*
> + * Calling this function before entering a preemptible busy polling loop will
> + * help the scheduler make better load balancing decisions. Wake up balance
> + * will treat the polling cpu as idle.
> + *
> + * Preemption is disabled inside this function and re-enabled in
> + * end_busy_poll(), thus the polling loop must periodically check
> + * continue_busy_poll().
> + *
> + * REQUIRES: prepare_to_busy_poll(), continue_busy_poll(), and end_busy_poll()
> + * must be used together.
> + */
> +void prepare_to_busy_poll(void)
> +{
> +       struct rq __maybe_unused *rq = this_rq();
> +       unsigned long __maybe_unused flags;
> +
> +       /* Preemption will be reenabled by end_busy_poll() */
> +       preempt_disable();
> +
> +#ifdef CONFIG_SMP
> +       raw_spin_lock_irqsave(&rq->lock, flags);
> +       /* preemption disabled; only one thread can poll at a time */
> +       WARN_ON_ONCE(rq->busy_polling);
> +       rq->busy_polling++;
> +       raw_spin_unlock_irqrestore(&rq->lock, flags);
> +#endif
> +}
> +EXPORT_SYMBOL(prepare_to_busy_poll);
> +
> +int continue_busy_poll(void)
> +{
> +       if (!single_task_running())
> +               return 0;
> +
> +       /* Important that we check this, since preemption is disabled */
> +       if (need_resched())
> +               return 0;
> +
> +       return 1;
> +}
> +EXPORT_SYMBOL(continue_busy_poll);
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
> +       struct rq *rq = this_rq();
> +       unsigned long flags;
> +
> +       raw_spin_lock_irqsave(&rq->lock, flags);
> +       BUG_ON(!rq->busy_polling); /* not paired with prepare() */
> +       rq->busy_polling--;
> +       raw_spin_unlock_irqrestore(&rq->lock, flags);
> +#endif
> +
> +       /*
> +        * preemption needs to be kept disabled between prepare_to_busy_poll()
> +        * and end_busy_poll().
> +        */
> +       BUG_ON(preemptible());
> +       if (allow_resched)
> +               preempt_enable();
> +       else
> +               preempt_enable_no_resched();
> +}
> +EXPORT_SYMBOL(end_busy_poll);
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
>         return sched_idle_rq(cpu_rq(cpu));
>  }
> +
> +static int sched_idle_or_polling_cpu(int cpu)
> +{
> +       return sched_idle_cpu(cpu) || polling_cpu(cpu);
> +}
>  #endif
>
>  /*
> @@ -5880,6 +5885,7 @@ find_idlest_group_cpu(struct sched_group *group, struct task_struct *p, int this
>         u64 latest_idle_timestamp = 0;
>         int least_loaded_cpu = this_cpu;
>         int shallowest_idle_cpu = -1;
> +       int found_polling = 0;
>         int i;
>
>         /* Check if we have any choice: */
> @@ -5914,10 +5920,14 @@ find_idlest_group_cpu(struct sched_group *group, struct task_struct *p, int this
>                                 shallowest_idle_cpu = i;
>                         }
>                 } else if (shallowest_idle_cpu == -1) {
> +                       int polling = polling_cpu(i);
> +
>                         load = cpu_load(cpu_rq(i));
> -                       if (load < min_load) {
> +                       if ((polling == found_polling && load < min_load) ||
> +                           (polling && !found_polling)) {

This really looks like a horrible hack.
This case is used to compare the load when there is no idle cpu.

>                                 min_load = load;
>                                 least_loaded_cpu = i;
> +                               found_polling = polling;
>                         }
>                 }
>         }
> @@ -6085,7 +6095,7 @@ static int select_idle_smt(struct task_struct *p, int target)
>         for_each_cpu(cpu, cpu_smt_mask(target)) {
>                 if (!cpumask_test_cpu(cpu, p->cpus_ptr))
>                         continue;
> -               if (available_idle_cpu(cpu) || sched_idle_cpu(cpu))
> +               if (available_idle_cpu(cpu) || sched_idle_or_polling_cpu(cpu))
>                         return cpu;
>         }
>
> @@ -6149,7 +6159,7 @@ static int select_idle_cpu(struct task_struct *p, struct sched_domain *sd, int t
>         for_each_cpu_wrap(cpu, cpus, target) {
>                 if (!--nr)
>                         return -1;
> -               if (available_idle_cpu(cpu) || sched_idle_cpu(cpu))
> +               if (available_idle_cpu(cpu) || sched_idle_or_polling_cpu(cpu))
>                         break;
>         }
>
> @@ -6179,7 +6189,7 @@ select_idle_capacity(struct task_struct *p, struct sched_domain *sd, int target)
>         for_each_cpu_wrap(cpu, cpus, target) {
>                 unsigned long cpu_cap = capacity_of(cpu);
>
> -               if (!available_idle_cpu(cpu) && !sched_idle_cpu(cpu))
> +               if (!available_idle_cpu(cpu) && !sched_idle_or_polling_cpu(cpu))
>                         continue;
>                 if (task_fits_capacity(p, cpu_cap))
>                         return cpu;
> @@ -6223,14 +6233,14 @@ static int select_idle_sibling(struct task_struct *p, int prev, int target)
>         }
>
>  symmetric:
> -       if (available_idle_cpu(target) || sched_idle_cpu(target))
> +       if (available_idle_cpu(target) || sched_idle_or_polling_cpu(target))
>                 return target;
>
>         /*
>          * If the previous CPU is cache affine and idle, don't be stupid:
>          */
>         if (prev != target && cpus_share_cache(prev, target) &&
> -           (available_idle_cpu(prev) || sched_idle_cpu(prev)))
> +           (available_idle_cpu(prev) || sched_idle_or_polling_cpu(prev)))
>                 return prev;
>
>         /*
> @@ -6252,7 +6262,8 @@ static int select_idle_sibling(struct task_struct *p, int prev, int target)
>         if (recent_used_cpu != prev &&
>             recent_used_cpu != target &&
>             cpus_share_cache(recent_used_cpu, target) &&
> -           (available_idle_cpu(recent_used_cpu) || sched_idle_cpu(recent_used_cpu)) &&
> +           (available_idle_cpu(recent_used_cpu) ||
> +            sched_idle_or_polling_cpu(recent_used_cpu)) &&
>             cpumask_test_cpu(p->recent_used_cpu, p->cpus_ptr)) {
>                 /*
>                  * Replace recent_used_cpu with prev as it is a potential
> diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
> index 28709f6b0975..45de468d0ffb 100644
> --- a/kernel/sched/sched.h
> +++ b/kernel/sched/sched.h
> @@ -1003,6 +1003,8 @@ struct rq {
>
>         /* This is used to determine avg_idle's max value */
>         u64                     max_idle_balance_cost;
> +
> +       unsigned int            busy_polling;
>  #endif /* CONFIG_SMP */
>
>  #ifdef CONFIG_IRQ_TIME_ACCOUNTING
> --
> 2.29.0.rc1.297.gfa9743e501-goog
>
