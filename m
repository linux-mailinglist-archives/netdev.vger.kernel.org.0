Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 874836AC423
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 15:57:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230354AbjCFO5k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 09:57:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230290AbjCFO5g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 09:57:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB9E732E4E;
        Mon,  6 Mar 2023 06:57:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4AFAC60FFA;
        Mon,  6 Mar 2023 14:57:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83B87C433D2;
        Mon,  6 Mar 2023 14:57:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678114647;
        bh=9ekaUPu9EVBLlisIqNAVB0GB6wygYnAhWQmwRm9LXmM=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=a7NsWO2XDftM665GOkoCuwRWmVfs+2q4QmAdKTGNLoiIxKZPk77eiE/q9Ki8w92b2
         jMKoizi9GXyy0dBzhIGV/29h1lcYlPej+CvBeh5+hADxd1muU4T/WB9AvzGeYdo5xv
         EdqMRr+swJLbRZRnDroRaHWnnXzZ0YYI1ES7/NvqRLff9T9nkXz1ZM1NgsEpjyVled
         HCJNVaYVe29twusxjBRPPSBpJ7GjsVGjGFypLtM0esTqyUAEVchKgurm1IrQ2Skayh
         A97AznmoI/ce5+q6vtNxWUft7apYU+0zRvR3ppqju/xM0aigV0RMFY0wXkoc08+kzg
         5DRAR42ew3OdA==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id 2C85A5C00F1; Mon,  6 Mar 2023 06:57:27 -0800 (PST)
Date:   Mon, 6 Mar 2023 06:57:27 -0800
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Frederic Weisbecker <frederic@kernel.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Jakub Kicinski <kuba@kernel.org>, peterz@infradead.org,
        jstultz@google.com, edumazet@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] softirq: avoid spurious stalls due to need_resched()
Message-ID: <20230306145727.GS1301832@paulmck-ThinkPad-P17-Gen-1>
Reply-To: paulmck@kernel.org
References: <20230303133143.7b35433f@kernel.org>
 <87r0u3hqtw.ffs@tglx>
 <ZAXVF0tPKLErAkpT@lothringen>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZAXVF0tPKLErAkpT@lothringen>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 06, 2023 at 12:57:11PM +0100, Frederic Weisbecker wrote:
> On Sun, Mar 05, 2023 at 09:43:23PM +0100, Thomas Gleixner wrote:
> > That said, I have no brilliant solution for that off the top of my head,
> > but I'm not comfortable with applying more adhoc solutions which are
> > contrary to the efforts of e.g. the audio folks.
> > 
> > I have some vague ideas how to approach that, but I'm traveling all of
> > next week, so I neither will be reading much email, nor will I have time
> > to think deeply about softirqs. I'll resume when I'm back.
> 
> IIUC: the problem is that some (rare?) softirq vector callbacks rely on the
> fact they can not be interrupted by other local vectors and they rely on
> that to protect against concurrent per-cpu state access, right?
> 
> And there is no automatic way to detect those cases otherwise we would have
> fixed them all with spinlocks already.
> 
> So I fear the only (in-)sane idea I could think of is to do it the same way
> we did with the BKL. Some sort of pushdown: vector callbacks known for having
> no such subtle interaction can re-enable softirqs.
> 
> For example known safe timers (either because they have no such interactions
> or because they handle them correctly via spinlocks) can carry a
> TIMER_SOFTIRQ_SAFE flag to tell about that. And RCU callbacks something alike.

When a given RCU callback causes latency problems, the usual quick fix
is to have them instead spawn a workqueue, either from the callback or
via queue_rcu_work().

But yes, this is one of the reasons that jiffies are so popular.  Eric
batched something like 30 RCU callbacks per costly time check, and you
would quite possible need similar batching to attain efficiency for
lightly loaded softirq vectors.  But 30 long-running softirq handlers
would be too many.

One option is to check the expensive time when either a batch of (say)
30 completes or when jiffies says too much time has elapsed.

> Of course this is going to be a tremendous amount of work but it has the
> advantage of being iterative and it will pay in the long run. Also I'm confident
> that the hottest places will be handled quickly. And most of them are likely to
> be in core networking code.
> 
> Because I fear no hack will ever fix that otherwise, and we have tried a lot.

Indeed, if it was easy within current overall code structure, we would
have already fixed it.

							Thanx, Paul
