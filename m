Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C21FB6AB220
	for <lists+netdev@lfdr.de>; Sun,  5 Mar 2023 21:43:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229509AbjCEUna (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Mar 2023 15:43:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbjCEUn3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Mar 2023 15:43:29 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69E4DA242;
        Sun,  5 Mar 2023 12:43:26 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1678049004;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to; bh=qikMftU4McbbMDOItj8zDivTHsi/s5Yx4YWzM1jznj0=;
        b=St2ETDfTVzXulSS0RLDZJzpasv3zGeWgEE/9URiv+jHKRTZJyHSAVHraYZEPQ8xiBbMH4Q
        9lezofaOyytCQUqBSRrmg2ey11W+7lmftj6mMEdwpGuVHMFLX49TO1X14ftd4OTCyn0Jov
        vJUk7VL8NIWn0hOW8EWb2dkagdjR8SYciwvGdXJTrt7lVyVfG4kEBC0NAbQiBGGx4aPFUn
        cFlK8t0euxH+MKSl8CNKhqgqEKQ5fO8RfvFHF1BXypMA1tIHUwMvXilYiFBBRSdJ/vXu1J
        1y1m0PEleUVL9iOgL77K2y1DALlQxPqc9UtpNTWhqPy/JSkmD9hEHKdTRM7j+w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1678049004;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to; bh=qikMftU4McbbMDOItj8zDivTHsi/s5Yx4YWzM1jznj0=;
        b=Lm8souzxfvW9nVYij9O9ZRQtKADSbdTo2Zx/SFAaR5c97ZUAz21gqvJ9CmXJAvAzaej7rb
        pX3UUH+fQsQ1weCQ==
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     peterz@infradead.org, jstultz@google.com, edumazet@google.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Frederic Weisbecker <frederic@kernel.org>
Subject: Re: [PATCH 2/3] softirq: avoid spurious stalls due to need_resched()
In-Reply-To: <20230303133143.7b35433f@kernel.org>
Date:   Sun, 05 Mar 2023 21:43:23 +0100
Message-ID: <87r0u3hqtw.ffs@tglx>
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

On Fri, Mar 03 2023 at 13:31, Jakub Kicinski wrote:
> On Fri, 03 Mar 2023 14:30:46 +0100 Thomas Gleixner wrote:
>> > +		__this_cpu_write(overload_limit, jiffies + limit);  
>> 
>> The logic of all this is non-obvious and I had to reread it 5 times to
>> conclude that it is matching the intent. Please add comments.
>> 
>> While I'm not a big fan of heuristical duct tape, this looks harmless
>> enough to not end up in an endless stream of tweaking. Famous last
>> words...
>
> Would it all be more readable if I named the "overload_limit"
> "overloaded_until" instead? Naming..

While naming matters it wont change the 'heuristical duct tape' property
of this, right?

> I'll add comments, too.

They are definitely appreciated, but I'd prefer to have code which is
self explanatory and does at least have a notion of a halfways
scientific approach to the overall issue of softirqs.

The point is that softirqs are just the proliferation of an at least 50
years old OS design paradigm. Back then everyhting which run in an
interrupt handler was "important" and more or less allowed to hog the
CPU at will.

That obviously caused problems because it prevented other interrupt
handlers from being served.

This was attempted to work around in hardware by providing interrupt
priority levels. No general purpose OS utilized that ever because there
is no way to get this right. Not even on UP, unless you build a designed
for the purpose "OS".

Soft interrupts are not any better. They avoid the problem of stalling
interrupts by moving the problem one level down to the scheduler.

Granted they are a cute hack, but at the very end they are still evading
the resource control mechanisms of the OS by defining their own rules:

    - NET RX defaults to 2ms with the ability to override via /proc
    - RCU defaults to 3ms with the ability to override via /sysfs

while the "overload detection" in the core defines a hardcoded limit of
2ms. Alone the above does not sum up to the core limit and most of the
other soft interrupt handlers do not even have the notion of limits.

That clearly does not even remotely allow to do proper coordinated
resource management.

Not to talk about the sillyness of the jiffy based timouts which result
in a randomized granularity of 0...1/Hz as mentioned before.

I'm well aware of the fact that consulting a high resolution hardware
clock frequently can be slow and hurting performance, but there are well
understood workarounds, aka batching, which mitigate that. 

There is another aspect to softirqs which makes them a horror show:

  While they are conceptually seperate, at the very end they are all
  lumped together and especially the network code has implicit
  assumptions about that. It's simply impossible to seperate the
  processing of the various soft interrupt incarnations.

IOW, resource control by developer preference and coincidence of
events. That truly makes an understandable and to be relied on OS.

We had seperate softirq threads and per softirq serialization (except
NET_RX/TX which shared) in the early days of preempt RT, which gave fine
grained control. Back then the interaction between different softirqs
was halfways understandable and the handful of interaction points which
relied on the per CPU global BH disable were fixable with local
serializations. That lasted a year or two until we stopped maintaining
that because the interaction between softirqs was becoming a whack a
mole game. So we gave up and enjoy the full glory of a per CPU global
lock, because that's what local BH disable actually is.

I completely understand that ***GB networking is a challenge, but ***GB
networking does not work without applications wwich use it. Those
applications are unfortunately^Wrightfully subject to the scheduler,
aka. resource control.

IMO evading resource control is the worst of all approaches and the
amount of heuristics you can apply to mitigate that, is never going to
cover even a subset of the overall application space.

Just look at the memcache vs. webserver use case vs. need_resched() and
then the requirements coming from the low latency audio folks.

I know the usual approach to that is to add some more heuristics which
are by nature supposed to fail or to add yet another 'knob'. We have
already too many knobs which are not comprehensible on their own. But
even if a particular knob is comprehensible there is close to zero
documentation and I even claim close to zero understanding of the
interaction of knobs.

Just for the record. Some of our engineers are working on TSN based
real-time networking which is all about latency anc accuracy. Guess how
well that works with the current overall design. That's not an esoteric
niche use case as low-latency TSN is not restricted to the automation
space. There are quite some use cases which go there even in the high
end networking space.

>> But without the sched_clock() changes the actual defer time depends on
>> HZ and the point in time where limit is set. That means it ranges from 0
>> to 1/HZ, i.e. the 2ms defer time ends up with close to 10ms on HZ=100 in
>> the worst case, which perhaps explains the 8ms+ stalls you are still
>> observing. Can you test with that sched_clock change applied, i.e. the
>> first two commits from
>> 
>>   git://git.kernel.org/pub/scm/linux/kernel/git/peterz/queue.git core/softirq
>> 
>> 59be25c466d9 ("softirq: Use sched_clock() based timeout")
>> bd5a5bd77009 ("softirq: Rewrite softirq processing loop")
>
> Those will help, but I spent some time digging into the jiffies related
> warts with kprobes - while annoying they weren't a major source of wake
> ups. (FWIW the jiffies noise on our workloads is due to cgroup stats
> disabling IRQs for multiple ms on the timekeeping CPU).

What? That's completely insane and needs to be fixed.

> Here are fresh stats on why we wake up ksoftirqd on our Web workload
> (collected over 100 sec):
>
> Time exceeded:      484
> Loop max run out:  6525
> need_resched():   10219
> (control: 17226 - number of times wakeup_process called for ksirqd)
>
> As you can see need_resched() dominates.

> Zooming into the time exceeded - we can count nanoseconds between
> __do_softirq starting and the check. This is the histogram of actual
> usecs as seen by BPF (AKA ktime_get_mono_fast_ns() / 1000):
>
> [256, 512)             1 |                                                    |
> [512, 1K)              0 |                                                    |
> [1K, 2K)             217 |@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@         |
> [2K, 4K)             266 |@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@|
>
> So yes, we can probably save ourselves ~200 wakeup with a better clock
> but that's just 1.3% of the total wake ups :(

Fair enough. Though that does not make our time limit handling any more
consistent and we need to fix that too to handle the other issues.

> Now - now about the max loop count. I ORed the pending softirqs every
> time we get to the end of the loop. Looks like vast majority of the
> loop counter wake ups are exclusively due to RCU:
>
> @looped[512]: 5516

If the loop counter breaks without consuming the time budget that's
silly.

> Where 512 is the ORed pending mask over all iterations
> 512 == 1 << RCU_SOFTIRQ.
>
> And they usually take less than 100us to consume the 10 iterations.
> Histogram of usecs consumed when we run out of loop iterations:
>
> [16, 32)               3 |                                                    |
> [32, 64)            4786 |@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@|
> [64, 128)            871 |@@@@@@@@@                                           |
> [128, 256)            34 |                                                    |
> [256, 512)             9 |                                                    |
> [512, 1K)            262 |@@                                                  |
> [1K, 2K)              35 |                                                    |
> [2K, 4K)               1 |                                                    |
>
> Paul, is this expected? Is RCU not trying too hard to be nice?
>
> # cat /sys/module/rcutree/parameters/blimit
> 10
>
> Or should we perhaps just raise the loop limit? Breaking after less 
> than 100usec seems excessive :(

No. Can we please stop twiddling a parameter here and there and go and
fix this whole problem space properly. Increasing the loop count for RCU
might work for your particular usecase and cause issues in other
scenarios.

Btw, RCU seems to be a perfect candidate to delegate batches from softirq
into a seperate scheduler controllable entity.

>> So for the remaining 90ms any invocation of raise_softirq() outside of
>> (soft)interrupt context, which wakes ksoftirqd again, prevents
>> processing on return from interrupt until ksoftirqd gets on the CPU and
>> goes back to sleep, because task_is_running() == true and the stale
>> limit is not after jiffies.
>> 
>> Probably not a big issue, but someone will notice on some weird workload
>> sooner than later and the tweaking will start nevertheless. :) So maybe
>> we fix it right away. :)
>
> Hm, Paolo raised this point as well, but the overload time is strictly
> to stop paying attention to the fact ksoftirqd is running.
> IOW current kernels behave as if they had overload_limit of infinity.
>
> The current code already prevents processing until ksoftirqd schedules
> in, after raise_softirq() from a funky context.

Correct and it does so because we are just applying duct tape over and
over.

That said, I have no brilliant solution for that off the top of my head,
but I'm not comfortable with applying more adhoc solutions which are
contrary to the efforts of e.g. the audio folks.

I have some vague ideas how to approach that, but I'm traveling all of
next week, so I neither will be reading much email, nor will I have time
to think deeply about softirqs. I'll resume when I'm back.

Thanks,

        tglx
