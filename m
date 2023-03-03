Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BBD66AA5C4
	for <lists+netdev@lfdr.de>; Sat,  4 Mar 2023 00:44:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229702AbjCCXoU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Mar 2023 18:44:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbjCCXoT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Mar 2023 18:44:19 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C58C15561;
        Fri,  3 Mar 2023 15:44:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 0182FCE219E;
        Fri,  3 Mar 2023 23:44:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFCC4C433EF;
        Fri,  3 Mar 2023 23:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677887055;
        bh=hUBPfedUHUf2qIWt0fMGkboSyz9En+RM5tZoa2+btkE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=aJGeUUTjMJxkk/DrqL2ohG24Ly+xzkqeDKPb3VJ1RQDEMwUdpQVS5bykMsQFW5Yzl
         uKMOYPEXYJSCrinjq19tCdv5XER1eTspcDbyN+3nsVx2Psf66yjLMvWk3xWSzmwZdX
         JUTvlQUUJf08drPOjN7UBr40gFztCwQuuWB9ktIUY7nvGQ57WO6LdojIKsiBkLu1as
         DaOBgt4D7vyB1Zxw+gJWisCHAZFbFpX4yPOMxql/7aFpo3Tuw0m8r+lzRWByYvh9hA
         pcg0YuP4CkE8EU5U5ouujFoysnyRwezl7wr2qbnhelYONxsUWTLlqfcmA6FnliwBXE
         uNuPSDoArtT2w==
Date:   Fri, 3 Mar 2023 15:44:13 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Paul E. McKenney" <paulmck@kernel.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>, peterz@infradead.org,
        jstultz@google.com, edumazet@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] softirq: avoid spurious stalls due to
 need_resched()
Message-ID: <20230303154413.1d846ac3@kernel.org>
In-Reply-To: <20230303233627.GA2136520@paulmck-ThinkPad-P17-Gen-1>
References: <20221222221244.1290833-1-kuba@kernel.org>
        <20221222221244.1290833-3-kuba@kernel.org>
        <87r0u6j721.ffs@tglx>
        <20230303133143.7b35433f@kernel.org>
        <20230303223739.GC1301832@paulmck-ThinkPad-P17-Gen-1>
        <20230303233627.GA2136520@paulmck-ThinkPad-P17-Gen-1>
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

On Fri, 3 Mar 2023 15:36:27 -0800 Paul E. McKenney wrote:
> On Fri, Mar 03, 2023 at 02:37:39PM -0800, Paul E. McKenney wrote:
> > On Fri, Mar 03, 2023 at 01:31:43PM -0800, Jakub Kicinski wrote:  
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
> >   
> > > # cat /sys/module/rcutree/parameters/blimit
> > > 10
> > > 
> > > Or should we perhaps just raise the loop limit? Breaking after less 
> > > than 100usec seems excessive :(  
> > 
> > But note that RCU also has rcutree.rcu_divisor, which defaults to 7.
> > And an rcutree.rcu_resched_ns, which defaults to three milliseconds
> > (3,000,000 nanoseconds).  This means that RCU will do:
> > 
> > o	All the callbacks if there are less than ten.
> > 
> > o	Ten callbacks or 1/128th of them, whichever is larger.
> > 
> > o	Unless the larger of them is more than 100 callbacks, in which
> > 	case there is an additional limit of three milliseconds worth
> > 	of them.
> > 
> > Except that if a given CPU ends up with more than 10,000 callbacks
> > (rcutree.qhimark), that CPU's blimit is set to 10,000.  
> 
> Also, if in the context of a softirq handler (as opposed to ksoftirqd)
> that interrupted the idle task with no pending task, the count of
> callbacks is ignored and only the 3-millisecond limit counts.  In the
> context of ksoftirq, the only limit is that which the scheduler chooses
> to impose.
> 
> But it sure seems like the ksoftirqd case should also pay attention to
> that 3-millisecond limit.  I will queue a patch to that effect, and maybe
> Eric Dumazet will show me the error of my ways.

Just to be sure - have you seen Peter's patches?

  git://git.kernel.org/pub/scm/linux/kernel/git/peterz/queue.git core/softirq

I think it feeds the time limit to the callback from softirq,
so the local 3ms is no more?
