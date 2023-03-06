Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCB5A6ABE16
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 12:23:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229892AbjCFLXM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 06:23:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229995AbjCFLXH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 06:23:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 433A728211;
        Mon,  6 Mar 2023 03:22:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DE6D4B80D9D;
        Mon,  6 Mar 2023 11:22:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2836EC433D2;
        Mon,  6 Mar 2023 11:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678101749;
        bh=XSuslucGlRTd1bcn4GkSZJtnllYQrEXlDKp3lH223IQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cVvMtOzWwIv6G3ckUtmQ/D8GqHi4B8QKrd2dI+KFPMuZCb5CUquYzpqe9qA7/VD3g
         1DkPpRaRMPkLJ+fSlIkePmfOSFSRnKXPDD8c5J25ItJeedVFxLyTXfn+gywpI73WGP
         qfloQC5NwVyxFpfj6N2h2PLdWw07iWVTnAA2Rs9CrOIAx4OzliU8Sa8y6j84QjwTKE
         0wJwVSR6optfa4Y9lf/rLJmDP0kJ6qAuCDTZ/uh2EJiwd82HUdUQjHEA/gUxXMwQ8Z
         7w9nK98k/UI1JdtlkNOY/ed/YZUKw8liawb3kWNNDQXIkTAyVxX4lKn2vexPhx5yKP
         WuBWQKuvDAVbg==
Date:   Mon, 6 Mar 2023 12:22:26 +0100
From:   Frederic Weisbecker <frederic@kernel.org>
To:     "Paul E. McKenney" <paulmck@kernel.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Jakub Kicinski <kuba@kernel.org>, peterz@infradead.org,
        jstultz@google.com, edumazet@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] softirq: avoid spurious stalls due to need_resched()
Message-ID: <ZAXM8hmZRNnCm/Hb@lothringen>
References: <20230303133143.7b35433f@kernel.org>
 <87r0u3hqtw.ffs@tglx>
 <20230305224211.GN1301832@paulmck-ThinkPad-P17-Gen-1>
 <ZAUfCH7gk98FDtSI@lothringen>
 <20230306043033.GO1301832@paulmck-ThinkPad-P17-Gen-1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230306043033.GO1301832@paulmck-ThinkPad-P17-Gen-1>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 05, 2023 at 08:30:33PM -0800, Paul E. McKenney wrote:
> On Mon, Mar 06, 2023 at 12:00:24AM +0100, Frederic Weisbecker wrote:
> > On Sun, Mar 05, 2023 at 02:42:11PM -0800, Paul E. McKenney wrote:
> > > On Sun, Mar 05, 2023 at 09:43:23PM +0100, Thomas Gleixner wrote:
> > > Indeed, as you well know, CONFIG_RCU_NOCB_CPU=y in combination with the
> > > rcutree.use_softirq kernel boot parameter in combination with either the
> > > nohz_full or rcu_nocbs kernel boot parameter and then the callbacks are
> > > invoked within separate kthreads so that the scheduler has full control.
> > > In addition, this dispenses with all of the heuristics that are otherwise
> > > necessary to avoid invoking too many callbacks in one shot.
> > > 
> > > Back in the day, I tried making this the default (with an eye towards
> > > making it the sole callback-execution scheme), but this resulted in
> > > some ugly performance regressions.  This was in part due to the extra
> > > synchronization required to queue a callback and in part due to the
> > > higher average cost of a wakeup compared to a raise_softirq().
> > > 
> > > So I changed to the current non-default arrangement.
> > > 
> > > And of course, you can do it halfway by booting kernel built with
> > > CONFIG_RCU_NOCB_CPU=n with the rcutree.use_softirq kernel boot parameter.
> > > But then the callback-invocation-limit heuristics are still used, but
> > > this time to prevent callback invocation from preventing the CPU from
> > > reporting quiescent states.  But if this was the only case, simpler
> > > heuristics would suffice.
> > > 
> > > In short, it is not hard to make RCU avoid using softirq, but doing so
> > > is not without side effects.  ;-)
> > 
> > Right but note that, threaded or not, callbacks invocation happen
> > within a local_bh_disable() section, preventing other softirqs from running.
> > 
> > So this is still subject to the softirq per-CPU BKL.
> 
> True enough!  But it momentarily enables BH after invoking each callback,
> so the other softirq vectors should be able to get a word in.

Indeed it's still less worse than having it in softirqs.
