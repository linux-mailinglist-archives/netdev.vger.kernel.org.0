Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9C0B6AB304
	for <lists+netdev@lfdr.de>; Sun,  5 Mar 2023 23:42:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229780AbjCEWmR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Mar 2023 17:42:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbjCEWmQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Mar 2023 17:42:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E835AC650;
        Sun,  5 Mar 2023 14:42:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 77622B80AD6;
        Sun,  5 Mar 2023 22:42:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAF85C433D2;
        Sun,  5 Mar 2023 22:42:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678056131;
        bh=QxHMDEcOiQZynDNt09BTVoxUgOfSvSzH85lFohl+3DU=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=dGZ8yu0J7A/wDY0iSDk//T8ho93nPB47ePJ2mCZCzJEA+/yR4PDGxqXnbLeG/GYDc
         mS4KURxfVpCrrjMq/+5DTcO4OMd3xDVEm/5EGrN2kq9tcs27HSfPF+Y98FVebPySSv
         B7QaEH/vs6cuA4I9Fodh+f3CF3ZGy1Pwhd3bEJFT00MTsHYZTPPoj+5qKEi6sJSmKC
         Y5WgpM3Qmdk4xxDVdt+xxWi9HWgDAunX9sP2j+rcIOD6DZ7FADT4Js3FKhzjo2lwtP
         32l3MX3J2MkW7ERpVBtck+pTEh0VBRqtTiZXJOSDR+AQALI+HMscJZGlnFrkt0x8XM
         aaEKgHXTA2oEw==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id 76AA35C035B; Sun,  5 Mar 2023 14:42:11 -0800 (PST)
Date:   Sun, 5 Mar 2023 14:42:11 -0800
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Jakub Kicinski <kuba@kernel.org>, peterz@infradead.org,
        jstultz@google.com, edumazet@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Frederic Weisbecker <frederic@kernel.org>
Subject: Re: [PATCH 2/3] softirq: avoid spurious stalls due to need_resched()
Message-ID: <20230305224211.GN1301832@paulmck-ThinkPad-P17-Gen-1>
Reply-To: paulmck@kernel.org
References: <20230303133143.7b35433f@kernel.org>
 <87r0u3hqtw.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87r0u3hqtw.ffs@tglx>
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 05, 2023 at 09:43:23PM +0100, Thomas Gleixner wrote:
> On Fri, Mar 03 2023 at 13:31, Jakub Kicinski wrote:
> > On Fri, 03 Mar 2023 14:30:46 +0100 Thomas Gleixner wrote:

[ . . . ]

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

Indeed, as you well know, CONFIG_RCU_NOCB_CPU=y in combination with the
rcutree.use_softirq kernel boot parameter in combination with either the
nohz_full or rcu_nocbs kernel boot parameter and then the callbacks are
invoked within separate kthreads so that the scheduler has full control.
In addition, this dispenses with all of the heuristics that are otherwise
necessary to avoid invoking too many callbacks in one shot.

Back in the day, I tried making this the default (with an eye towards
making it the sole callback-execution scheme), but this resulted in
some ugly performance regressions.  This was in part due to the extra
synchronization required to queue a callback and in part due to the
higher average cost of a wakeup compared to a raise_softirq().

So I changed to the current non-default arrangement.

And of course, you can do it halfway by booting kernel built with
CONFIG_RCU_NOCB_CPU=n with the rcutree.use_softirq kernel boot parameter.
But then the callback-invocation-limit heuristics are still used, but
this time to prevent callback invocation from preventing the CPU from
reporting quiescent states.  But if this was the only case, simpler
heuristics would suffice.

In short, it is not hard to make RCU avoid using softirq, but doing so
is not without side effects.  ;-)

							Thanx, Paul
