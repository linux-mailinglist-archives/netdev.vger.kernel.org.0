Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA5796AA731
	for <lists+netdev@lfdr.de>; Sat,  4 Mar 2023 02:16:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbjCDBQX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Mar 2023 20:16:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbjCDBQW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Mar 2023 20:16:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DE5A64850;
        Fri,  3 Mar 2023 17:15:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EE7D4B81A0C;
        Sat,  4 Mar 2023 01:14:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE623C433D2;
        Sat,  4 Mar 2023 01:14:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677892475;
        bh=VhonvLy8O+pflz+3Bd7drjd0a4V6yJlZnzkfpNCtEj4=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=lQHP3DaD4PBx+3x405C1VZgAeU5jrxn4dCM66jYzzVSaviK9HPyWl8uYqnUOeZhQa
         shuW7QjIDugNMgZ2y2XUsNNAaKj0p9lu85dDw2Ux6hvsWE9UcSbhPBRQP+rJgZkr/0
         RFdKz9j+hgU7WO3yvEny35Q+u6oduYMT+OD3rtjmzhrhduZJRLDbzG4xLo3o4UP8DO
         b11r0ZRRCLa3PyfZ7UD7kkTv7YtGEp6PTXapZ5DH6PumuXCsfeM+w8s1yeayvUEUjR
         xEsbLkPDpgR7t7ovIjMZlJUqwuRhbqylSnGBUj1wmvrlVjdeEFgRFqv5eQ8cozLebL
         qX0djSPKL12Ig==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id 4E6515C0278; Fri,  3 Mar 2023 17:14:35 -0800 (PST)
Date:   Fri, 3 Mar 2023 17:14:35 -0800
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Dave Taht <dave.taht@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, peterz@infradead.org,
        jstultz@google.com, edumazet@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] softirq: avoid spurious stalls due to need_resched()
Message-ID: <20230304011435.GE1301832@paulmck-ThinkPad-P17-Gen-1>
Reply-To: paulmck@kernel.org
References: <20221222221244.1290833-1-kuba@kernel.org>
 <20221222221244.1290833-3-kuba@kernel.org>
 <87r0u6j721.ffs@tglx>
 <20230303133143.7b35433f@kernel.org>
 <20230303223739.GC1301832@paulmck-ThinkPad-P17-Gen-1>
 <CAA93jw5nHjHTFiN9D4wCeOJ4UYmP2537Ar+5ZsCYftzhg7RLPw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAA93jw5nHjHTFiN9D4wCeOJ4UYmP2537Ar+5ZsCYftzhg7RLPw@mail.gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 03, 2023 at 03:25:32PM -0800, Dave Taht wrote:
> On Fri, Mar 3, 2023 at 2:56 PM Paul E. McKenney <paulmck@kernel.org> wrote:
> >
> > On Fri, Mar 03, 2023 at 01:31:43PM -0800, Jakub Kicinski wrote:
> > > On Fri, 03 Mar 2023 14:30:46 +0100 Thomas Gleixner wrote:
> > > > > -         if (time_before(jiffies, end) && !need_resched() &&
> > > > > -             --max_restart)
> > > > > +         unsigned long limit;
> > > > > +
> > > > > +         if (time_is_before_eq_jiffies(end) || !--max_restart)
> > > > > +                 limit = SOFTIRQ_OVERLOAD_TIME;
> > > > > +         else if (need_resched())
> > > > > +                 limit = SOFTIRQ_DEFER_TIME;
> > > > > +         else
> > > > >                   goto restart;
> > > > >
> > > > > +         __this_cpu_write(overload_limit, jiffies + limit);
> > > >
> > > > The logic of all this is non-obvious and I had to reread it 5 times to
> > > > conclude that it is matching the intent. Please add comments.
> > > >
> > > > While I'm not a big fan of heuristical duct tape, this looks harmless
> > > > enough to not end up in an endless stream of tweaking. Famous last
> > > > words...
> > >
> > > Would it all be more readable if I named the "overload_limit"
> > > "overloaded_until" instead? Naming..
> > > I'll add comments, too.
> > >
> > > > But without the sched_clock() changes the actual defer time depends on
> > > > HZ and the point in time where limit is set. That means it ranges from 0
> > > > to 1/HZ, i.e. the 2ms defer time ends up with close to 10ms on HZ=100 in
> > > > the worst case, which perhaps explains the 8ms+ stalls you are still
> > > > observing. Can you test with that sched_clock change applied, i.e. the
> > > > first two commits from
> > > >
> > > >   git://git.kernel.org/pub/scm/linux/kernel/git/peterz/queue.git core/softirq
> > > >
> > > > 59be25c466d9 ("softirq: Use sched_clock() based timeout")
> > > > bd5a5bd77009 ("softirq: Rewrite softirq processing loop")
> > >
> > > Those will help, but I spent some time digging into the jiffies related
> > > warts with kprobes - while annoying they weren't a major source of wake
> > > ups. (FWIW the jiffies noise on our workloads is due to cgroup stats
> > > disabling IRQs for multiple ms on the timekeeping CPU).
> > >
> > > Here are fresh stats on why we wake up ksoftirqd on our Web workload
> > > (collected over 100 sec):
> > >
> > > Time exceeded:      484
> > > Loop max run out:  6525
> > > need_resched():   10219
> > > (control: 17226 - number of times wakeup_process called for ksirqd)
> > >
> > > As you can see need_resched() dominates.
> > >
> > > Zooming into the time exceeded - we can count nanoseconds between
> > > __do_softirq starting and the check. This is the histogram of actual
> > > usecs as seen by BPF (AKA ktime_get_mono_fast_ns() / 1000):
> > >
> > > [256, 512)             1 |                                                    |
> > > [512, 1K)              0 |                                                    |
> > > [1K, 2K)             217 |@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@         |
> > > [2K, 4K)             266 |@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@|
> > >
> > > So yes, we can probably save ourselves ~200 wakeup with a better clock
> > > but that's just 1.3% of the total wake ups :(
> > >
> > >
> > > Now - now about the max loop count. I ORed the pending softirqs every
> > > time we get to the end of the loop. Looks like vast majority of the
> > > loop counter wake ups are exclusively due to RCU:
> > >
> > > @looped[512]: 5516
> > >
> > > Where 512 is the ORed pending mask over all iterations
> > > 512 == 1 << RCU_SOFTIRQ.
> > >
> > > And they usually take less than 100us to consume the 10 iterations.
> > > Histogram of usecs consumed when we run out of loop iterations:
> > >
> > > [16, 32)               3 |                                                    |
> > > [32, 64)            4786 |@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@|
> > > [64, 128)            871 |@@@@@@@@@                                           |
> > > [128, 256)            34 |                                                    |
> > > [256, 512)             9 |                                                    |
> > > [512, 1K)            262 |@@                                                  |
> > > [1K, 2K)              35 |                                                    |
> > > [2K, 4K)               1 |                                                    |
> > >
> > > Paul, is this expected? Is RCU not trying too hard to be nice?
> >
> > This is from way back in the day, so it is quite possible that better
> > tuning and/or better heuristics should be applied.
> >
> > On the other hand, 100 microseconds is a good long time from an
> > CONFIG_PREEMPT_RT=y perspective!
> 
> All I have to add to this conversation is the observation that
> sampling things at the
> nyquist rate helps to observe problems like these.
> 
> So if you care about sub 8ms response time, a sub 4ms sampling rate is needed.

My guess is that Jakub is side-stepping Nyquist by sampling every call
to and return from the rcu_do_batch() function.

> > > # cat /sys/module/rcutree/parameters/blimit
> > > 10
> > >
> > > Or should we perhaps just raise the loop limit? Breaking after less
> > > than 100usec seems excessive :(
> 
> 
> > But note that RCU also has rcutree.rcu_divisor, which defaults to 7.
> > And an rcutree.rcu_resched_ns, which defaults to three milliseconds
> > (3,000,000 nanoseconds).  This means that RCU will do:
> >
> > o       All the callbacks if there are less than ten.
> >
> > o       Ten callbacks or 1/128th of them, whichever is larger.
> >
> > o       Unless the larger of them is more than 100 callbacks, in which
> >         case there is an additional limit of three milliseconds worth
> >         of them.
> >
> > Except that if a given CPU ends up with more than 10,000 callbacks
> > (rcutree.qhimark), that CPU's blimit is set to 10,000.
> >
> > So there is much opportunity to tune the existing heuristics and also
> > much opportunity to tweak the heuristics themselves.
> 
> This I did not know, and to best observe rcu in action nyquist is 1.5ms...

This is not an oscillator, and because this all happens within a
single system, you cannot you hang your hat on speed-of-light delays.
In addition, an application can dump thousands of callbacks down RCU's
throat in a very short time, which changes RCU's timing.  Also, the
time constants for expedited grace periods are typically in the tens
of microseconds.  Something about prioritizing survivability over
measurability.  ;-)

But that is OK because ftrace and BPF can provide fine-grained
measurements quite cheaply.

> Something with less constants and more curves seems in order.

In the immortal words of MS-DOS, are you sure?

							Thanx, Paul

> > But let's see a good use case before tweaking, please.  ;-)
> >
> >                                                         Thanx, Paul
> >
> > > > whether that makes a difference? Those two can be applied with some
> > > > minor polishing. The rest of that series is broken by f10020c97f4c
> > > > ("softirq: Allow early break").
> > > >
> > > > There is another issue with this overload limit. Assume max_restart or
> > > > timeout triggered and limit was set to now + 100ms. ksoftirqd runs and
> > > > gets the issue resolved after 10ms.
> > > >
> > > > So for the remaining 90ms any invocation of raise_softirq() outside of
> > > > (soft)interrupt context, which wakes ksoftirqd again, prevents
> > > > processing on return from interrupt until ksoftirqd gets on the CPU and
> > > > goes back to sleep, because task_is_running() == true and the stale
> > > > limit is not after jiffies.
> > > >
> > > > Probably not a big issue, but someone will notice on some weird workload
> > > > sooner than later and the tweaking will start nevertheless. :) So maybe
> > > > we fix it right away. :)
> > >
> > > Hm, Paolo raised this point as well, but the overload time is strictly
> > > to stop paying attention to the fact ksoftirqd is running.
> > > IOW current kernels behave as if they had overload_limit of infinity.
> > >
> > > The current code already prevents processing until ksoftirqd schedules
> > > in, after raise_softirq() from a funky context.
> 
> 
> 
> -- 
> A pithy note on VOQs vs SQM: https://blog.cerowrt.org/post/juniper/
> Dave Täht CEO, TekLibre, LLC
