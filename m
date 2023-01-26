Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4506867D7E6
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 22:47:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230404AbjAZVru (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 16:47:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229931AbjAZVru (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 16:47:50 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B71724EEE
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 13:47:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 22A98CE2553
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 21:47:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28FDBC433D2;
        Thu, 26 Jan 2023 21:47:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674769665;
        bh=/yHCRlRTtV6wqDR4OhLkosp/5KRFdGKA3nZ6EPSBa6c=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=ASp0M3C5FSGXd4cvG/DzTr5ZFN7OK6vRHOapYWjwOSyOO8eh6bVNfUVfLa2CgJlcw
         h3mTEJJH+/2VHcleHzsGWLtMX0V7e19P7U9567SLtEiWDjSuYw+3LrwBQY4kvVvjrY
         xukmagVIR/gwNMGcI/Wqfuq6oQSlkcpAOPR0l7ZwXgyuSAyKCB4bX5o8TV8aTXvRFA
         P11UH+c9671l+NsPtkLqTRs8jtz7QfdiMOxu2AsoQwjcksXtja4j+mTUPwhRUxcp8d
         hFTiclVZ+RJlf2FSY7fJaRqiwb2K2FxLuEuHUcchtYW1Wyf9jlNi5GVgTdZ7Pm+Zpi
         BdZRpPEmm0Kpw==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id BE8625C1C6D; Thu, 26 Jan 2023 13:47:44 -0800 (PST)
Date:   Thu, 26 Jan 2023 13:47:44 -0800
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Kirill Tkhai <tkhai@ya.ru>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        kuniyu@amazon.com, gorcunov@gmail.com
Subject: Re: [PATCH net-next] unix: Guarantee sk_state relevance in case of
 it was assigned by a task on other cpu
Message-ID: <20230126214744.GN2948950@paulmck-ThinkPad-P17-Gen-1>
Reply-To: paulmck@kernel.org
References: <72ae40ef-2d68-2e89-46d3-fc8f820db42a@ya.ru>
 <20230124173557.2b13e194@kernel.org>
 <6953ec3b-6c48-954e-f3db-63450a5ab886@ya.ru>
 <20230125221053.301c0341@kernel.org>
 <20230126202511.GL2948950@paulmck-ThinkPad-P17-Gen-1>
 <20230126133322.3bfab5e0@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230126133322.3bfab5e0@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 26, 2023 at 01:33:22PM -0800, Jakub Kicinski wrote:
> On Thu, 26 Jan 2023 12:25:11 -0800 Paul E. McKenney wrote:
> > > Me trying to prove that memory ordering is transitive would be 100%
> > > speculation. Let's ask Paul instead - is the above valid? Or the fact
> > > that CPU1 observes state from CPU0 and is strongly ordered with CPU2
> > > implies that CPU2 will also observe CPU0's state?  
> > 
> > Hmmm...  What is listen() doing?  There seem to be a lot of them
> > in the kernel.
> > 
> > But proceeding on first principles...
> > 
> > Sometimes.  Memory ordering is transitive only when the ordering is
> > sufficiently strong.
> > 
> > In this case, I do not see any ordering between CPU 0 and anything else.
> > If the listen() function were to acquire the same mutex as CPU1 and CPU2
> > did, and if it acquired it first, then CPU2 would be guaranteed to see
> > anything CPU0 did while holding that mutex.
> 
> The fuller picture would be:
> 
> [CPU0]                     [CPU1]                [CPU2]
> WRITE_ONCE(sk->sk_state,
>            TCP_LISTEN);
>                            val = READ_ONCE(sk->sk_state) 
>                            mutex_lock()
>                            shared_mem_var = val
>                            mutex_unlock()
>                                                   mutex_lock()
>                                                   if (shared_mem_var == TCP_LISTEN)
>                                                      BUG_ON(READ_ONCE(sk->sk_state)
>                                                             != TCP_LISTEN)
>                                                   mutex_unlock()

And just to make sure that I represented your example correctly, please
see the litmus test below.

LKMM says that the bad outcome cannot happen, that is, if CPU1 sees
CPU0's write to sk->sk_state ("ss" in the litmus test) and if CPU2
sees CPU1's write to shared_mem_var ("smv" in the litmus test), then
it cannot be the case that CPU2 sees the old value of sk->sk_state that
was overwritten by CPU0.

And as you note below, it is no surprise that LKMM has this opinion.  ;-)

But I need to make sure that I didn't misrepresent your diagram above.

> > Alternatively, if CPU0 wrote to some memory, and CPU1 read that value
> > before releasing the mutex (including possibly before acquiring that
> > mutex), then CPU2 would be guaranteed to see that value (or the value
> > written by some later write to that same memory) after acquiring that
> > mutex.
> 
> Which I believe is exactly what happens in the example.
> 
> > So here are some things you can count on transitively:
> > 
> > 1.	After acquiring a given lock (or mutex or whatever), you will
> > 	see any values written or read prior to any earlier conflicting
> > 	release of that same lock.
> > 
> > 2.	After an access with acquire semantics (for example,
> > 	smp_load_acquire()) you will see any values written or read
> > 	prior to any earlier access with release semantics (for example,
> > 	smp_store_release()).
> > 
> > Or in all cases, you might see later values, in case someone else also
> > did a write to the location in question.
> > 
> > Does that help, or am I missing a turn in there somewhere?
> 
> Very much so, thank you!

------------------------------------------------------------------------

C C-Jakub-listen

(*
 * Result: Never
 *
 * Message-ID: <20230126133322.3bfab5e0@kernel.org>
 *)

{
}

P0(int *ss, int *smv, spinlock_t *gbl)
{
	WRITE_ONCE(*ss, 1);
}

P1(int *ss, int *smv, spinlock_t *gbl)
{
        int r1;

	r1 = READ_ONCE(*ss);
	spin_lock(gbl);
	WRITE_ONCE(*smv, 1);
	spin_unlock(gbl);
}

P2(int *ss, int *smv, spinlock_t *gbl)
{
	int r1;
        int r2;

	spin_lock(gbl);
	r1 = READ_ONCE(*smv);
	r2 = READ_ONCE(*ss);
	spin_unlock(gbl);
}

exists
(1:r1=1 /\ 2:r1=1 /\ 2:r2=0)
