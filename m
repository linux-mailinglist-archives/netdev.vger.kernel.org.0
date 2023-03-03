Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3D3E6AA139
	for <lists+netdev@lfdr.de>; Fri,  3 Mar 2023 22:31:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231764AbjCCVbw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Mar 2023 16:31:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231408AbjCCVbv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Mar 2023 16:31:51 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C01518A8E;
        Fri,  3 Mar 2023 13:31:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id AE496CE225F;
        Fri,  3 Mar 2023 21:31:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5469BC433D2;
        Fri,  3 Mar 2023 21:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677879104;
        bh=e50m2NHbLD9NoP+yfVDDhz9HJIZgAzAYVpSchQdi13c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cefp0NCs+xrovA6txVpCeNXZ1IJ7dYjcbAd5Rv6OaQmbZOnJmTi1iKlsV0PnyicIb
         UTwWVUQetLx8ItofwDd+r4O0XyyXuLXHzCVuVT8AGBq+5Rt1NkLeZTU+isgGbLT6CN
         9/9Wps/TBamz33eXa3iuT7uvDP5Kj8DjYx9yb+yy2Ivk28OFaTde5b3gxE8wuvGdba
         6XV1wO3/zVaISk0XPDWAmpInjFCWmNbyUX298JWShZnfdIpr2CShgYl3Y1f9YmtsVP
         rN8aNYPaKHs7/WfiiJEGOxL33EPNRkUu1TblE0QnjR5XI1wP7wtjfVAFwks8+bCIwW
         nRcTUg2nmzr2g==
Date:   Fri, 3 Mar 2023 13:31:43 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     peterz@infradead.org, jstultz@google.com, edumazet@google.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@kernel.org>
Subject: Re: [PATCH 2/3] softirq: avoid spurious stalls due to
 need_resched()
Message-ID: <20230303133143.7b35433f@kernel.org>
In-Reply-To: <87r0u6j721.ffs@tglx>
References: <20221222221244.1290833-1-kuba@kernel.org>
        <20221222221244.1290833-3-kuba@kernel.org>
        <87r0u6j721.ffs@tglx>
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

On Fri, 03 Mar 2023 14:30:46 +0100 Thomas Gleixner wrote:
> > -		if (time_before(jiffies, end) && !need_resched() &&
> > -		    --max_restart)
> > +		unsigned long limit;
> > +
> > +		if (time_is_before_eq_jiffies(end) || !--max_restart)
> > +			limit = SOFTIRQ_OVERLOAD_TIME;
> > +		else if (need_resched())
> > +			limit = SOFTIRQ_DEFER_TIME;
> > +		else
> >  			goto restart;
> >  
> > +		__this_cpu_write(overload_limit, jiffies + limit);  
> 
> The logic of all this is non-obvious and I had to reread it 5 times to
> conclude that it is matching the intent. Please add comments.
> 
> While I'm not a big fan of heuristical duct tape, this looks harmless
> enough to not end up in an endless stream of tweaking. Famous last
> words...

Would it all be more readable if I named the "overload_limit"
"overloaded_until" instead? Naming..
I'll add comments, too.

> But without the sched_clock() changes the actual defer time depends on
> HZ and the point in time where limit is set. That means it ranges from 0
> to 1/HZ, i.e. the 2ms defer time ends up with close to 10ms on HZ=100 in
> the worst case, which perhaps explains the 8ms+ stalls you are still
> observing. Can you test with that sched_clock change applied, i.e. the
> first two commits from
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/peterz/queue.git core/softirq
> 
> 59be25c466d9 ("softirq: Use sched_clock() based timeout")
> bd5a5bd77009 ("softirq: Rewrite softirq processing loop")

Those will help, but I spent some time digging into the jiffies related
warts with kprobes - while annoying they weren't a major source of wake
ups. (FWIW the jiffies noise on our workloads is due to cgroup stats
disabling IRQs for multiple ms on the timekeeping CPU).

Here are fresh stats on why we wake up ksoftirqd on our Web workload
(collected over 100 sec):

Time exceeded:      484
Loop max run out:  6525
need_resched():   10219
(control: 17226 - number of times wakeup_process called for ksirqd)

As you can see need_resched() dominates.

Zooming into the time exceeded - we can count nanoseconds between
__do_softirq starting and the check. This is the histogram of actual
usecs as seen by BPF (AKA ktime_get_mono_fast_ns() / 1000):

[256, 512)             1 |                                                    |
[512, 1K)              0 |                                                    |
[1K, 2K)             217 |@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@         |
[2K, 4K)             266 |@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@|

So yes, we can probably save ourselves ~200 wakeup with a better clock
but that's just 1.3% of the total wake ups :(


Now - now about the max loop count. I ORed the pending softirqs every
time we get to the end of the loop. Looks like vast majority of the
loop counter wake ups are exclusively due to RCU:

@looped[512]: 5516

Where 512 is the ORed pending mask over all iterations
512 == 1 << RCU_SOFTIRQ.

And they usually take less than 100us to consume the 10 iterations.
Histogram of usecs consumed when we run out of loop iterations:

[16, 32)               3 |                                                    |
[32, 64)            4786 |@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@|
[64, 128)            871 |@@@@@@@@@                                           |
[128, 256)            34 |                                                    |
[256, 512)             9 |                                                    |
[512, 1K)            262 |@@                                                  |
[1K, 2K)              35 |                                                    |
[2K, 4K)               1 |                                                    |

Paul, is this expected? Is RCU not trying too hard to be nice?

# cat /sys/module/rcutree/parameters/blimit
10

Or should we perhaps just raise the loop limit? Breaking after less 
than 100usec seems excessive :(

> whether that makes a difference? Those two can be applied with some
> minor polishing. The rest of that series is broken by f10020c97f4c
> ("softirq: Allow early break").
> 
> There is another issue with this overload limit. Assume max_restart or
> timeout triggered and limit was set to now + 100ms. ksoftirqd runs and
> gets the issue resolved after 10ms.
> 
> So for the remaining 90ms any invocation of raise_softirq() outside of
> (soft)interrupt context, which wakes ksoftirqd again, prevents
> processing on return from interrupt until ksoftirqd gets on the CPU and
> goes back to sleep, because task_is_running() == true and the stale
> limit is not after jiffies.
> 
> Probably not a big issue, but someone will notice on some weird workload
> sooner than later and the tweaking will start nevertheless. :) So maybe
> we fix it right away. :)

Hm, Paolo raised this point as well, but the overload time is strictly
to stop paying attention to the fact ksoftirqd is running.
IOW current kernels behave as if they had overload_limit of infinity.

The current code already prevents processing until ksoftirqd schedules
in, after raise_softirq() from a funky context.
