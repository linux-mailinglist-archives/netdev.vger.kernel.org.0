Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBABD6AD379
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 01:51:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbjCGAvk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 19:51:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbjCGAvh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 19:51:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BF2B3C7AF;
        Mon,  6 Mar 2023 16:51:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 008A7B81203;
        Tue,  7 Mar 2023 00:51:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54B45C433D2;
        Tue,  7 Mar 2023 00:51:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678150292;
        bh=irKLQBk6LEo94GmcQJ8hApWRibEIYXlKNa1lIb6ZDRg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nVWL5Kfwd80xjZTdOhQ05NBjOM1gjR6sBrF14qEm2gHP3iOJKUF6zNPQINEsyslzt
         PyBlqRtshD+OuXy/0ZLLPLSM5XF52AGIohWT1ARm0NmhafMJxzOnQOTaWExgoM8X4/
         ReNsbhObYzUTweHo+NDNYU0Djb3ZjedSejuE2asx+3Y6+BauEX2/zf+4NRiWAc9Q8Y
         Ag9oF4/it4bUe9/PiiD8It5BmZq1RGiMFougJ8IKt0tHEpoo7yMkGaGUg9s6fkr9T+
         1+22Q7q9IlTYS5Yx1ldKqgq0ksqBmTuWtga4/PAjs+ef3ssLnydKLmg1TUUDvvUHjL
         T/4PhL6MW04/g==
Date:   Mon, 6 Mar 2023 16:51:31 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     peterz@infradead.org, jstultz@google.com, edumazet@google.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Frederic Weisbecker <frederic@kernel.org>
Subject: Re: [PATCH 2/3] softirq: avoid spurious stalls due to
 need_resched()
Message-ID: <20230306165131.11b7b475@kernel.org>
In-Reply-To: <87r0u3hqtw.ffs@tglx>
References: <20230303133143.7b35433f@kernel.org>
 <87r0u3hqtw.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 05 Mar 2023 21:43:23 +0100 Thomas Gleixner wrote:
> > Would it all be more readable if I named the "overload_limit"
> > "overloaded_until" instead? Naming..  
> 
> While naming matters it wont change the 'heuristical duct tape' property
> of this, right?

I also hate heuristics, I hope we are on the same page there.

The way I see it we allowed 2 heuristics already into the kernel:

 - ksoftirq running means overload
 - need_resched() means we should stop immediately (and wake ksoftirqd)

Those two are clearly at odds with each other.
And the latter is as weak / hacky as it gets :|

See at the end for work in progress/"real solutions" but for this 
patch - can I replace the time limit with a simple per core 
"bool wa_for_yield" and change the overload check to:

	if (ksoftirqd_running() && !wa_for_yeild)

? That's not a heuristic, right? No magic values, predictable,
repeatable behavior.

> > I'll add comments, too.  
> 
> They are definitely appreciated, but I'd prefer to have code which is
> self explanatory and does at least have a notion of a halfways
> scientific approach to the overall issue of softirqs.
> 
> The point is that softirqs are just the proliferation of an at least 50
> years old OS design paradigm. Back then everyhting which run in an
> interrupt handler was "important" and more or less allowed to hog the
> CPU at will.
> 
> That obviously caused problems because it prevented other interrupt
> handlers from being served.
> 
> This was attempted to work around in hardware by providing interrupt
> priority levels. No general purpose OS utilized that ever because there
> is no way to get this right. Not even on UP, unless you build a designed
> for the purpose "OS".
> 
> Soft interrupts are not any better. They avoid the problem of stalling
> interrupts by moving the problem one level down to the scheduler.
> 
> Granted they are a cute hack, but at the very end they are still evading
> the resource control mechanisms of the OS by defining their own rules:
> 
>     - NET RX defaults to 2ms with the ability to override via /proc
>     - RCU defaults to 3ms with the ability to override via /sysfs
> 
> while the "overload detection" in the core defines a hardcoded limit of
> 2ms. Alone the above does not sum up to the core limit and most of the
> other soft interrupt handlers do not even have the notion of limits.
> 
> That clearly does not even remotely allow to do proper coordinated
> resource management.

FWIW happy to delete all the procfs knobs we have in net. Anyone who
feels like they need to tweak those should try to use/work on a real
solution.

> Not to talk about the sillyness of the jiffy based timouts which result
> in a randomized granularity of 0...1/Hz as mentioned before.
> 
> I'm well aware of the fact that consulting a high resolution hardware
> clock frequently can be slow and hurting performance, but there are well
> understood workarounds, aka batching, which mitigate that. 
> 
> There is another aspect to softirqs which makes them a horror show:
> 
>   While they are conceptually seperate, at the very end they are all
>   lumped together and especially the network code has implicit
>   assumptions about that. It's simply impossible to seperate the
>   processing of the various soft interrupt incarnations.

Was that just about running in threads or making them preemptible?
Running Rx in threads is "mostly solved", see at the end.

> IOW, resource control by developer preference and coincidence of
> events. That truly makes an understandable and to be relied on OS.
> 
> We had seperate softirq threads and per softirq serialization (except
> NET_RX/TX which shared) in the early days of preempt RT, which gave fine
> grained control. Back then the interaction between different softirqs
> was halfways understandable and the handful of interaction points which
> relied on the per CPU global BH disable were fixable with local
> serializations. That lasted a year or two until we stopped maintaining
> that because the interaction between softirqs was becoming a whack a
> mole game. So we gave up and enjoy the full glory of a per CPU global
> lock, because that's what local BH disable actually is.
> 
> I completely understand that ***GB networking is a challenge, but ***GB
> networking does not work without applications wwich use it. Those
> applications are unfortunately^Wrightfully subject to the scheduler,
> aka. resource control.
> 
> IMO evading resource control is the worst of all approaches and the
> amount of heuristics you can apply to mitigate that, is never going to
> cover even a subset of the overall application space.
> 
> Just look at the memcache vs. webserver use case vs. need_resched() and
> then the requirements coming from the low latency audio folks.

Let me clarify that we only need the default to not be silly for
applications which are _not_ doing a lot of networking. The webserver
in my test is running a website (PHP?), not serving static content.
It's doing maybe a few Gbps on a 25/50 Gbps NIC.

> I know the usual approach to that is to add some more heuristics which
> are by nature supposed to fail or to add yet another 'knob'. We have
> already too many knobs which are not comprehensible on their own. But
> even if a particular knob is comprehensible there is close to zero
> documentation and I even claim close to zero understanding of the
> interaction of knobs.
> 
> Just for the record. Some of our engineers are working on TSN based
> real-time networking which is all about latency anc accuracy. Guess how
> well that works with the current overall design. That's not an esoteric
> niche use case as low-latency TSN is not restricted to the automation
> space. There are quite some use cases which go there even in the high
> end networking space.

TSN + ksoftirqd is definitely a bad idea :S

> > Those will help, but I spent some time digging into the jiffies related
> > warts with kprobes - while annoying they weren't a major source of wake
> > ups. (FWIW the jiffies noise on our workloads is due to cgroup stats
> > disabling IRQs for multiple ms on the timekeeping CPU).  
> 
> What? That's completely insane and needs to be fixed.

Agreed, I made the right people aware..

> > Here are fresh stats on why we wake up ksoftirqd on our Web workload
> > (collected over 100 sec):
> >
> > Time exceeded:      484
> > Loop max run out:  6525
> > need_resched():   10219
> > (control: 17226 - number of times wakeup_process called for ksirqd)
> >
> > As you can see need_resched() dominates.  
> 
> > Zooming into the time exceeded - we can count nanoseconds between
> > __do_softirq starting and the check. This is the histogram of actual
> > usecs as seen by BPF (AKA ktime_get_mono_fast_ns() / 1000):
> >
> > [256, 512)             1 |                                                    |
> > [512, 1K)              0 |                                                    |
> > [1K, 2K)             217 |@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@         |
> > [2K, 4K)             266 |@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@|
> >
> > So yes, we can probably save ourselves ~200 wakeup with a better clock
> > but that's just 1.3% of the total wake ups :(  
> 
> Fair enough. Though that does not make our time limit handling any more
> consistent and we need to fix that too to handle the other issues.
> 
> > Now - now about the max loop count. I ORed the pending softirqs every
> > time we get to the end of the loop. Looks like vast majority of the
> > loop counter wake ups are exclusively due to RCU:
> >
> > @looped[512]: 5516  
> 
> If the loop counter breaks without consuming the time budget that's
> silly.

FWIW my initial reaction was to read the jiffies from the _local_ core,
because if we're running softirq the can't have IRQs masked.
So local clock will be ticking. But I'm insufficiently competent to
code that up, and you'd presumably have done this already if it was a
good idea.

> > Where 512 is the ORed pending mask over all iterations
> > 512 == 1 << RCU_SOFTIRQ.
> >
> > And they usually take less than 100us to consume the 10 iterations.
> > Histogram of usecs consumed when we run out of loop iterations:
> >
> > [16, 32)               3 |                                                    |
> > [32, 64)            4786 |@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@|
> > [64, 128)            871 |@@@@@@@@@                                           |
> > [128, 256)            34 |                                                    |
> > [256, 512)             9 |                                                    |
> > [512, 1K)            262 |@@                                                  |
> > [1K, 2K)              35 |                                                    |
> > [2K, 4K)               1 |                                                    |
> >
> > Paul, is this expected? Is RCU not trying too hard to be nice?
> >
> > # cat /sys/module/rcutree/parameters/blimit
> > 10
> >
> > Or should we perhaps just raise the loop limit? Breaking after less 
> > than 100usec seems excessive :(  
> 
> No. Can we please stop twiddling a parameter here and there and go and
> fix this whole problem space properly. Increasing the loop count for RCU
> might work for your particular usecase and cause issues in other
> scenarios.
> 
> Btw, RCU seems to be a perfect candidate to delegate batches from softirq
> into a seperate scheduler controllable entity.

Indeed, it knows how many callbacks it has, I wish we knew how many
packets had arrived :)

> > Hm, Paolo raised this point as well, but the overload time is strictly
> > to stop paying attention to the fact ksoftirqd is running.
> > IOW current kernels behave as if they had overload_limit of infinity.
> >
> > The current code already prevents processing until ksoftirqd schedules
> > in, after raise_softirq() from a funky context.  
> 
> Correct and it does so because we are just applying duct tape over and
> over.
> 
> That said, I have no brilliant solution for that off the top of my head,
> but I'm not comfortable with applying more adhoc solutions which are
> contrary to the efforts of e.g. the audio folks.

We are trying:

Threaded NAPI was added in Feb 2021. We can create a thread per NAPI
instance, then all Rx runs in dedicated kernel threads. Unfortunately
for workloads I tested it negatively impacts RPS and latency.
If the workload doesn't run the CPUs too hot it works well, 
but scheduler gets in the way.

I have a vague recollection that Google proposed patches to the
scheduler at some point to support isosync processing, but they were
rejected? I'm very likely misremembering. But I do feel like we'll need
better scheduler support to move network processing to threads. Maybe
the upcoming BPF scheduler patches can help us with that. We'll see.

The other way to go is to let the application take charge. We added
support for applications pledging that they will "busy poll" a given
queue. This turns off IRQs and expects an application to periodically
call into NAPI. I think that's the future for high RPS applications,
but real life results are scarce (other than pure forwarding workloads,
I guess, which are trivial).

Various folks in netdev had also experimented with using workqueues and
kthreads which are not mapped statically to NAPI.

So we are trying, and will continue to try.

There are unknowns, however, which make me think it's worth addressing
the obvious silliness in ksoftirqd behavior, tho. One - I'm not sure
whether we can get to a paradigm which is as fast and as easy to use 
for 100% of use cases as softirq. Two - the solution may need tuning 
and infrastructure leaving smaller users behind. And the ksoftirqd
experience is getting worse, which is why I posted the patches 
(I'm guessing scheduler changes, I don't even want to know who changed 
their heuristics).
