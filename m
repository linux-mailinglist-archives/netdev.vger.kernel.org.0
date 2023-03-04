Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCE8E6AA73E
	for <lists+netdev@lfdr.de>; Sat,  4 Mar 2023 02:25:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229579AbjCDBZj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Mar 2023 20:25:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbjCDBZi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Mar 2023 20:25:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BBDC1EBF6;
        Fri,  3 Mar 2023 17:25:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1056B61994;
        Sat,  4 Mar 2023 01:25:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A105C433D2;
        Sat,  4 Mar 2023 01:25:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677893136;
        bh=cD03O8hsJm+YS6YyRbl5aS8A9Wz5ofu4B302OFvDbWE=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=ahvtOHvy3dzGuNJTHwt6c0ea8EzBFdpZPUj4iOzzIOmoVVQ4hcpe9OgDl+givCVFK
         lYWuRh6O37xXfnWz63hGVp9qrO0Bon3bv1PzeiuikE2rR6VuA4L/9bQphuSPR17/ts
         BMzwoi8QBLFtkECfxDKTCfFA3s+rLKnEnIN02vW/6HZIaGU8GojetQnptcjjByYhV8
         iYvQzNpOjkvreNmjTeHpqwpV6/HbwpFImkaSo83jiRq6TxmaplQvoQfSiRsBJam3M/
         CyBwAsBYrn597WuHHxBqqciSUyhZt2yoqytJ565CGltEXOMyIFbt+RdoZBJJZWSVQ9
         MwOq1hhDPI7kQ==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id E8A115C0278; Fri,  3 Mar 2023 17:25:35 -0800 (PST)
Date:   Fri, 3 Mar 2023 17:25:35 -0800
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>, peterz@infradead.org,
        jstultz@google.com, edumazet@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] softirq: avoid spurious stalls due to need_resched()
Message-ID: <20230304012535.GF1301832@paulmck-ThinkPad-P17-Gen-1>
Reply-To: paulmck@kernel.org
References: <20221222221244.1290833-1-kuba@kernel.org>
 <20221222221244.1290833-3-kuba@kernel.org>
 <87r0u6j721.ffs@tglx>
 <20230303133143.7b35433f@kernel.org>
 <20230303223739.GC1301832@paulmck-ThinkPad-P17-Gen-1>
 <20230303233627.GA2136520@paulmck-ThinkPad-P17-Gen-1>
 <20230303154413.1d846ac3@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230303154413.1d846ac3@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 03, 2023 at 03:44:13PM -0800, Jakub Kicinski wrote:
> On Fri, 3 Mar 2023 15:36:27 -0800 Paul E. McKenney wrote:
> > On Fri, Mar 03, 2023 at 02:37:39PM -0800, Paul E. McKenney wrote:
> > > On Fri, Mar 03, 2023 at 01:31:43PM -0800, Jakub Kicinski wrote:  
> > > > Now - now about the max loop count. I ORed the pending softirqs every
> > > > time we get to the end of the loop. Looks like vast majority of the
> > > > loop counter wake ups are exclusively due to RCU:
> > > > 
> > > > @looped[512]: 5516
> > > > 
> > > > Where 512 is the ORed pending mask over all iterations
> > > > 512 == 1 << RCU_SOFTIRQ.
> > > > 
> > > > And they usually take less than 100us to consume the 10 iterations.
> > > > Histogram of usecs consumed when we run out of loop iterations:
> > > > 
> > > > [16, 32)               3 |                                                    |
> > > > [32, 64)            4786 |@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@|
> > > > [64, 128)            871 |@@@@@@@@@                                           |
> > > > [128, 256)            34 |                                                    |
> > > > [256, 512)             9 |                                                    |
> > > > [512, 1K)            262 |@@                                                  |
> > > > [1K, 2K)              35 |                                                    |
> > > > [2K, 4K)               1 |                                                    |
> > > > 
> > > > Paul, is this expected? Is RCU not trying too hard to be nice?  
> > > 
> > > This is from way back in the day, so it is quite possible that better
> > > tuning and/or better heuristics should be applied.
> > > 
> > > On the other hand, 100 microseconds is a good long time from an
> > > CONFIG_PREEMPT_RT=y perspective!
> > >   
> > > > # cat /sys/module/rcutree/parameters/blimit
> > > > 10
> > > > 
> > > > Or should we perhaps just raise the loop limit? Breaking after less 
> > > > than 100usec seems excessive :(  
> > > 
> > > But note that RCU also has rcutree.rcu_divisor, which defaults to 7.
> > > And an rcutree.rcu_resched_ns, which defaults to three milliseconds
> > > (3,000,000 nanoseconds).  This means that RCU will do:
> > > 
> > > o	All the callbacks if there are less than ten.
> > > 
> > > o	Ten callbacks or 1/128th of them, whichever is larger.
> > > 
> > > o	Unless the larger of them is more than 100 callbacks, in which
> > > 	case there is an additional limit of three milliseconds worth
> > > 	of them.
> > > 
> > > Except that if a given CPU ends up with more than 10,000 callbacks
> > > (rcutree.qhimark), that CPU's blimit is set to 10,000.  
> > 
> > Also, if in the context of a softirq handler (as opposed to ksoftirqd)
> > that interrupted the idle task with no pending task, the count of
> > callbacks is ignored and only the 3-millisecond limit counts.  In the
> > context of ksoftirq, the only limit is that which the scheduler chooses
> > to impose.
> > 
> > But it sure seems like the ksoftirqd case should also pay attention to
> > that 3-millisecond limit.  I will queue a patch to that effect, and maybe
> > Eric Dumazet will show me the error of my ways.
> 
> Just to be sure - have you seen Peter's patches?
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/peterz/queue.git core/softirq
> 
> I think it feeds the time limit to the callback from softirq,
> so the local 3ms is no more?

I might or might not have back in September of 2020.  ;-)

But either way, the question remains:  Should RCU_SOFTIRQ do time checking
in ksoftirqd context?  Seems like the answer should be "yes", independently
of Peter's patches.

							Thanx, Paul
