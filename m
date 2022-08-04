Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A17358A0A0
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 20:40:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240020AbiHDSk2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Aug 2022 14:40:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240032AbiHDSk0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Aug 2022 14:40:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91F7F61D86
        for <netdev@vger.kernel.org>; Thu,  4 Aug 2022 11:40:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B21BF61568
        for <netdev@vger.kernel.org>; Thu,  4 Aug 2022 18:40:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1270EC433C1;
        Thu,  4 Aug 2022 18:40:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659638423;
        bh=Q4hILSbjr4bPo4eWxzA+Gu1201CrbjLNLbXH3cD48QM=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=XaSNasOYYmJuI+BG673cCcchRKEUyHtDqT6dLp17TQcztztx+ppZ1WQr/CUQNGnkV
         kISxzrjgFY3zdqsTKza7C6ImfFOKjaP8mxqx9pDRZy5j91rv1edE3J+wr51iNPopXw
         yJRsN1g1wAE5elNPiYx3qHS5wQotFI8zEyZhPAlB+ifRtrKoHgEN79/dxrf4oCkbrZ
         YtvcqDKgrw9n+Im5Hjl7jWjHs04+gMc1zIyzbK5ezkDkI7o0xIGO4RrnCENT2/9u5a
         wQ836IB757S7Oo6iuryTGSIKs8m7tmMQx1uuh0A1UnN8lULCQN3oy4gwS2Gp9neVGT
         H8Qz9lzwSFSBw==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id AECD55C0921; Thu,  4 Aug 2022 11:40:22 -0700 (PDT)
Date:   Thu, 4 Aug 2022 11:40:22 -0700
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Maxim Mikityanskiy <maximmi@nvidia.com>
Cc:     "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Tariq Toukan <tariqt@nvidia.com>,
        Gal Pressman <gal@nvidia.com>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Boris Pismenny <borisp@nvidia.com>
Subject: Re: [PATCH net-next] net/tls: Use RCU API to access tls_ctx->netdev
Message-ID: <20220804184022.GR2125313@paulmck-ThinkPad-P17-Gen-1>
Reply-To: paulmck@kernel.org
References: <20220801080053.21849-1-maximmi@nvidia.com>
 <20220801124239.067573de@kernel.org>
 <380eb27278e581012524cdc16f99e1872cee9be0.camel@nvidia.com>
 <20220802083731.22291c3b@kernel.org>
 <8bf08924a111d4e0875721af264f082cc9c44587.camel@nvidia.com>
 <20220803074957.33783ad4@kernel.org>
 <20220803163437.GF2125313@paulmck-ThinkPad-P17-Gen-1>
 <dc8a86b89350e05841aaecfba5939cfb63a084ba.camel@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dc8a86b89350e05841aaecfba5939cfb63a084ba.camel@nvidia.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 04, 2022 at 08:08:37AM +0000, Maxim Mikityanskiy wrote:
> On Wed, 2022-08-03 at 09:34 -0700, Paul E. McKenney wrote:
> > On Wed, Aug 03, 2022 at 07:49:57AM -0700, Jakub Kicinski wrote:
> > > On Wed, 3 Aug 2022 09:33:48 +0000 Maxim Mikityanskiy wrote:
> > > > > > The documentation of rcu_access_pointer says it shouldn't be used on
> > > > > > the update side, because we lose lockdep protection:
> > > > > > 
> > > > > > --cut--
> > > > > > 
> > > > > > Although rcu_access_pointer() may also be used in cases
> > > > > > where update-side locks prevent the value of the pointer from changing,
> > > > > > you should instead use rcu_dereference_protected() for this use case.  
> > > > > 
> > > > > I think what this is trying to say is to not use the
> > > > > rcu_access_pointer() as a hack against lockdep:  
> > > > 
> > > > Well, maybe we understand it in different ways. This is how I parsed it
> > > > (the whole comment):
> > > > 
> > > > 1. rcu_access_pointer is not for the read side. So, it's either for the
> > > > write side or for usage outside all locks.
> > 
> > RCU readers really are permitted to use rcu_access_pointer().  As is
> > pretty much any other code.
> > 
> > See for example Documentation/RCU/rcu_dereference.rst:
> > 
> > 	Note that if checks for being within an RCU read-side critical
> > 	section are not required and the pointer is never dereferenced,
> > 	rcu_access_pointer() should be used in place of rcu_dereference().
> > 
> > OK, s/should be/can be/, but I will fix that.
> > 
> > Or, for that matter, the rcu_access_pointer() docbook header comment:
> > 
> > /**
> >  * rcu_access_pointer() - fetch RCU pointer with no dereferencing
> >  * @p: The pointer to read
> >  *
> >  * Return the value of the specified RCU-protected pointer, but omit the
> >  * lockdep checks for being in an RCU read-side critical section.  This is
> >  * useful when the value of this pointer is accessed, but the pointer is
> >  * not dereferenced, for example, when testing an RCU-protected pointer
> >  * against NULL.  Although rcu_access_pointer() may also be used in cases
> >  * where update-side locks prevent the value of the pointer from changing,
> >  * you should instead use rcu_dereference_protected() for this use case.
> >  *
> >  * It is also permissible to use rcu_access_pointer() when read-side
> >  * access to the pointer was removed at least one grace period ago, as
> >  * is the case in the context of the RCU callback that is freeing up
> >  * the data, or after a synchronize_rcu() returns.  This can be useful
> >  * when tearing down multi-linked structures after a grace period
> >  * has elapsed.
> >  */
> > 
> > So the restriction is that the pointer returned from rcu_access_pointer()
> > cannot be dereferenced or that the structure is beyond being updated.
> > 
> > So this is OK:
> > 
> > 	// Not in an RCU reader.  Or even in an RCU updater.
> > 	if (rcu_access_pointer(my_rcu_pointer))
> > 		do_something();
> > 	...
> > 
> > And so is this:
> > 
> > 	p = xchg(&my_rcu_pointer, NULL);
> > 	if (p) {
> > 		synchronize_rcu();
> > 		// No one else has access to this list!
> > 		while (p) {
> > 			q = rcu_access_pointer(p->next);
> > 			kfree(p);
> > 			q = p;
> > 			// But why are you hand-crafting list???
> > 			// Any why not use rcu_dereference_protected()?
> > 		}
> > 	}
> > 
> > But this is not:
> > 
> > 	p = rcu_access_pointer(my_rcu_pointer);
> > 	do_something_with(p->a); // BUG!!!  Even in an RCU reader.
> > 
> > In this second case, you must instead use rcu_dereference() or
> > similar.
> > 
> > > > 2. It's not for dereferencing. So, it's for reading the pointer's value
> > > > on the write side or outside all locks.
> > 
> > True enough, you are not permitted to dereference the value returned
> > from rcu_access_pointer().  Unless you have the only copy.
> > 
> > But it is just fine to check the value of the pointer, compare it, or
> > do arithmetic on it.  Just don't dereference it and don't dereference
> > any value computed from it.
> > 
> > > > 3. Although it can be used on the write side, rcu_dereference_protected
> > > > should be used. So, it's for reading the pointer's value outside all
> > > > locks.
> > 
> > Yes, if an RCU updater is going to dereference a pointer, it should
> > use rcu_dereference_protected() rather than rcu_access_pointer().
> > 
> > So rcu_access_pointer() does what it it says.  It permits the caller
> > to access the value of the pointer, and only to access that value.
> > Not dereference that value.
> > 
> > > Using rcu_deref* when we don't dereference the pointer does not compute
> > > for me, but it's not a big deal. 
> > 
> > It is OK to use rcu_dereference*() to access a pointer without
> > dereferencing it.
> > 
> > One key difference between rcu_dereference() and rcu_access_pointer()
> > is that rcu_access_pointer() can be used outside of an RCU reader.
> > For example:
> > 
> > 	// Not in an RCU reader.  Or even in an RCU updater.
> > 	if (rcu_access_pointer(my_rcu_pointer)) {
> > 		rcu_read_lock();
> > 		p = rcu_dereference(my_rcu_pointer);
> > 		if (p)
> > 			do_something_with(p);
> > 		rcu_read_unlock();
> > 	}
> > 
> > This example is silly because the overhead of the extra check might well
> > exceed that of the rcu_read_lock() and rcu_read_unlock() put together,
> > especially in CONFIG_PREEMPTION=n kernels.  A less-silly example might
> > schedule a workqueue or similar to handle the RCU-protected data, and
> > the overhead of the extra check might be very worthwhile in that case.
> 
> That's essentially one of our cases, we check a pointer and queue a
> work if it's not NULL, and the work dereferences it. But we don't use
> rcu_read_lock there, because it's the teardown flow, and there are no
> concurrent users anymore (refcount is 0).

Very good!

> > > Let me CC Paul for clarification of the docs, as it may also be
> > > confusing to others and therefore worth rewording. But our case is 
> > > not that important so unless Paul chimes in clearly indicating one
> > > interpretation is right - either way is fine by me for v2.
> > 
> > Hope this helps!
> 
> Thanks a lot for your detailed explanation! It's truly useful,
> especially the examples are helpful.

Would you like to nominate a simple use case for addition to the
official documentation?

> As far as I understood, rcu_access_pointer can be used in any context,
> including RCU updater, as long as we don't dereference the pointer. At
> the same time, it's OK to use rcu_dereference* without dereferencing.
> So, is there any preference, which helper to use, in the context where
> it can't be changed concurrently, if we don't dereference it, but just
> compare the value?

If you are in an RCU reader, there is little reason to use
rcu_access_pointer(), though it might be a good documentation aid.
It can also be helpful in code that is called both from an RCU reader
and from either and updater or an RCU outsider.

> Specifically, we have two (simplified) cases:
> 
> 1. We set the pointer to NULL under the write-lock, but only if it
> matches another pointer.
> 
>  down_write(&lock);
>  ctx_netdev = rcu_dereference_protected(ctx->netdev,
>                                         lockdep_is_held(&lock));
>  if (ctx_netdev == netdev) {
>          rcu_assign_pointer(ctx->netdev, NULL);
>          synchronize_rcu();
>  }
>  up_write(&lock);

I suggest keeping rcu_dereference_protected() here because it documents
the locking.  This might seem silly in this case because you just
acquired that lock, but code can grown functions and then be subject to
copy-pasta-induced bugs, and that call to rcu_dereference_protected()
can help locate such bugs.  In contrast, rcu_assign_pointer() will
cheerfully aid and abet the creation of this sort of bug.

> 2. ctx->refcount goes down to 0, no one can access ctx->netdev anymore,
> we tear down ctx and need to check whether ctx->netdev is NULL.
> 
>  if (!refcount_dec_and_test(&ctx->refcount))
>          return;
>  netdev = rcu_dereference_protected(ctx->netdev,
>                                     !refcount_read(&ctx->refcount));
>  if (netdev)
>          queue_work(...);
> 
> It's somewhat similar to the "structure is beyond being updated" case,
> but it's ensured by refcount, not by RCU (i.e. you example assigned
> my_rcu_pointer = NULL and called synchronize_rcu() to ensure no one
> touches it, and I ensure that we are the only user of ctx by dropping
> refcount to zero).

If that refcount_dec_and_test() is in an RCU callback or if RCU
readers are otherwise guaranteed to no longer be accessing this
object, then rcu_access_pointer() would work.  But again, that
rcu_dereference_protected() has the advantage of protecting against
copy-pasta bugs.

Otherwise, I would need to better understand the example.

> So, hoping that my understanding of your explanation is correct, both
> cases can use any of rcu_access_pointer or rcu_dereference_protected.
> Is there some rule of thumb which one to pick in such case?

If you have something meaningful to put into the lockdep condition of
rcu_dereference_protected(), you should use rcu_dereference_protected().
If not, and if either:

a.	There are no concurrent updates possible, or

b.	There will be no dereferencing of the returned pointer,

then rcu_access_pointer() can be useful.

Also, rcu_access_pointer() can sometimes simplify common code.

> Thanks,
> Max
> 
> > 
> > And please let me know if it does not.
> > 
> > 							Thanx, Paul
> 
