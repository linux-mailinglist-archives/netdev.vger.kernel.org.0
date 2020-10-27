Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BFA429CD3B
	for <lists+netdev@lfdr.de>; Wed, 28 Oct 2020 02:47:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726086AbgJ1Bic (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 21:38:32 -0400
Received: from mail-qv1-f68.google.com ([209.85.219.68]:45354 "EHLO
        mail-qv1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1833067AbgJ0X6X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 19:58:23 -0400
Received: by mail-qv1-f68.google.com with SMTP id w5so1581794qvn.12
        for <netdev@vger.kernel.org>; Tue, 27 Oct 2020 16:58:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=be4icrz0RAthBmHkcsABA0cMrKaZCZOUSHSUverl/k4=;
        b=eKymfijEAdnFIVb0Cvy9/o6PON2ivrDulc3gRFHoiPKBnxlM9a1I2JQ/GttbZLDQZ3
         x86v5uOzbm66/vtT8mwN/bie4dkbiGunMkScqZlKJp/MvYBoc6oJE63kavE/92REjhBP
         ftxqBeeDI/IplysVilpwVsfcU54kTCMb2rr+7oEYEXahA8xupZcfBAkotzhk6PHKCIjk
         XxpT8cWfxQDo0H3Kyr44xfQDsFkb/DKDneBkUAriyGhjREmbaZs0qZiKW2/+ZnjRUiCZ
         NZwtu1IwBrt2YX3HKL6xuhCGZHp8O86xKjhHPdgTPGflG/316P5T2LD3z0R/t+78FOGK
         044A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=be4icrz0RAthBmHkcsABA0cMrKaZCZOUSHSUverl/k4=;
        b=E7ta/fRyvgidEOYLUao4ccQEIV0dZmsAQG3b6vJmYpBoQPWqXQ0kOKVwnRvazttjOi
         Y3s3UUYqUeisgTiXagZgZNhXyde/EApKpotRti5IPJLDbnXGNwIDhN1QPeIhUnBDSru9
         8NXEL/yKSZRk8HpDrWWD1OCh8RTw0+0iBtOqe9hnxDPvTu2D7+89z9okUROcTo4bvhVZ
         cPu7pQDZg85TRQUWQIerpfnsXYXKdTX2h9/SqRb51pQawHi/tXoRjPPBrTtuXmkIXj9q
         LaAaNmVgb6AGGU6NJgvQ4ODhNAuHMY/yKluPKwORNdORm58Q6Gemv4c5MXX3aPApWBzH
         HMig==
X-Gm-Message-State: AOAM533x9PcEfd2Ts3QA66e4pdyOA6xcUHJU6bHD308OdZX0ZYXvn7gS
        SZj2aS3CGpdRUlRY7DRhm4+PfuoNbWcw9yptmtBxlQ==
X-Google-Smtp-Source: ABdhPJxcnBN07/uyrfs5vPqa195E2asvmD4q2KcE10PaE0bEECOQ+GmWWJIQjVXz/CZXIcowM1fD5dpIbDHEzB6LuDY=
X-Received: by 2002:a0c:ecce:: with SMTP id o14mr5519869qvq.2.1603843100009;
 Tue, 27 Oct 2020 16:58:20 -0700 (PDT)
MIME-Version: 1.0
References: <20201023032944.399861-1-joshdon@google.com> <20201023071905.GL2611@hirez.programming.kicks-ass.net>
In-Reply-To: <20201023071905.GL2611@hirez.programming.kicks-ass.net>
From:   Josh Don <joshdon@google.com>
Date:   Tue, 27 Oct 2020 16:58:08 -0700
Message-ID: <CABk29Ns8mhLUwSs+ZbREnx3yaX+xKwVeHf61OTe=5zNWxpmyag@mail.gmail.com>
Subject: Re: [PATCH 1/3] sched: better handling for busy polling loops
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     g@hirez.programming.kicks-ass.net, Ingo Molnar <mingo@redhat.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
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

On Fri, Oct 23, 2020 at 12:19 AM Peter Zijlstra <peterz@infradead.org> wrote:
>
> On Thu, Oct 22, 2020 at 08:29:42PM -0700, Josh Don wrote:
> > Busy polling loops in the kernel such as network socket poll and kvm
> > halt polling have performance problems related to process scheduler load
> > accounting.
>
> AFAICT you're not actually fixing the load accounting issue at all.

Halt polling is an ephemeral state, and the goal is not to adjust the
accounting, but rather to allow wake up balance to identify polling
cpus.

> > This change also disables preemption for the duration of the busy
> > polling loop. This is important, as it ensures that if a polling thread
> > decides to end its poll to relinquish cpu to another thread, the polling
> > thread will actually exit the busy loop and potentially block. When it
> > later becomes runnable, it will have the opportunity to find an idle cpu
> > via wakeup cpu selection.
>
> At the cost of inducing a sleep+wake cycle; which is mucho expensive. So
> this could go either way. No data presented.

I can take a look at getting some data on that. What I do have is data
that reflects an overall improvement in machine efficiency. On heavily
loaded hosts, we were able to recoup ~2% of cycles.

> > +void prepare_to_busy_poll(void)
> > +{
> > +     struct rq __maybe_unused *rq = this_rq();
> > +     unsigned long __maybe_unused flags;
> > +
> > +     /* Preemption will be reenabled by end_busy_poll() */
> > +     preempt_disable();
> > +
> > +#ifdef CONFIG_SMP
> > +     raw_spin_lock_irqsave(&rq->lock, flags);
> > +     /* preemption disabled; only one thread can poll at a time */
> > +     WARN_ON_ONCE(rq->busy_polling);
> > +     rq->busy_polling++;
> > +     raw_spin_unlock_irqrestore(&rq->lock, flags);
> > +#endif
>
> Explain to me the purpose of that rq->lock usage.

This was required in a previous iteration, but failed to drop after a refactor.

> > +int continue_busy_poll(void)
> > +{
> > +     if (!single_task_running())
> > +             return 0;
>
> Why? If there's more, we'll end up in the below condition anyway.
>

Migrating a task over won't necessarily set need_resched. Though it
does make sense to allow check_preempt_curr to set it directly in this
case.

> > diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
> > index 28709f6b0975..45de468d0ffb 100644
> > --- a/kernel/sched/sched.h
> > +++ b/kernel/sched/sched.h
> > @@ -1003,6 +1003,8 @@ struct rq {
> >
> >       /* This is used to determine avg_idle's max value */
> >       u64                     max_idle_balance_cost;
> > +
> > +     unsigned int            busy_polling;
>
> This is a good location, cache-wise, because?
>
> >  #endif /* CONFIG_SMP */
> >
> >  #ifdef CONFIG_IRQ_TIME_ACCOUNTING

Good call out, I didn't consider that.
