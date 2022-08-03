Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9558B589096
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 18:34:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236474AbiHCQel (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 12:34:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230163AbiHCQek (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 12:34:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DE34C78
        for <netdev@vger.kernel.org>; Wed,  3 Aug 2022 09:34:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BD5786176E
        for <netdev@vger.kernel.org>; Wed,  3 Aug 2022 16:34:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EA27C433D6;
        Wed,  3 Aug 2022 16:34:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659544478;
        bh=O5+p2mqlAynXzbgqf9IUcgpKMEhwoC4/NDM/nCCCneo=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=pFwvb3J/ijQ0BBsdk9GiO8YhYGwBVFmstvPZ4JphNSUThEKEtQ+LJxxA/JdWPLsa4
         aiAihz3kF8NK7XOcA+wAoQo3iF9S/4zmYiaZXCc8wkgIrtLbBK1eEd2MVlPe8Hz7g8
         hjb7hSIP2rxs/SAHt9bc3yEKdr/IR70A2Uy00RsSK65ds9KPl2rWAaQDbQ3XaZq1z3
         A9izzcnYBEImwm+KaHBUKxBFbgjyQvHWmCdAgAFwk7gCf7/OShbs+TUN3XcZvEpfdn
         6l6WwPHbYWgO+YXYVxAJCiheE3tGwF4vWdA7ln7PHwvdFKb5wAU3nqCtMtfHDXLqpZ
         L+rcLCRyCm2nA==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id B4F0E5C092A; Wed,  3 Aug 2022 09:34:37 -0700 (PDT)
Date:   Wed, 3 Aug 2022 09:34:37 -0700
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Maxim Mikityanskiy <maximmi@nvidia.com>,
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
Message-ID: <20220803163437.GF2125313@paulmck-ThinkPad-P17-Gen-1>
Reply-To: paulmck@kernel.org
References: <20220801080053.21849-1-maximmi@nvidia.com>
 <20220801124239.067573de@kernel.org>
 <380eb27278e581012524cdc16f99e1872cee9be0.camel@nvidia.com>
 <20220802083731.22291c3b@kernel.org>
 <8bf08924a111d4e0875721af264f082cc9c44587.camel@nvidia.com>
 <20220803074957.33783ad4@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220803074957.33783ad4@kernel.org>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 03, 2022 at 07:49:57AM -0700, Jakub Kicinski wrote:
> On Wed, 3 Aug 2022 09:33:48 +0000 Maxim Mikityanskiy wrote:
> > > > The documentation of rcu_access_pointer says it shouldn't be used on
> > > > the update side, because we lose lockdep protection:
> > > > 
> > > > --cut--
> > > > 
> > > > Although rcu_access_pointer() may also be used in cases
> > > > where update-side locks prevent the value of the pointer from changing,
> > > > you should instead use rcu_dereference_protected() for this use case.  
> > > 
> > > I think what this is trying to say is to not use the
> > > rcu_access_pointer() as a hack against lockdep:  
> > 
> > Well, maybe we understand it in different ways. This is how I parsed it
> > (the whole comment):
> > 
> > 1. rcu_access_pointer is not for the read side. So, it's either for the
> > write side or for usage outside all locks.

RCU readers really are permitted to use rcu_access_pointer().  As is
pretty much any other code.

See for example Documentation/RCU/rcu_dereference.rst:

	Note that if checks for being within an RCU read-side critical
	section are not required and the pointer is never dereferenced,
	rcu_access_pointer() should be used in place of rcu_dereference().

OK, s/should be/can be/, but I will fix that.

Or, for that matter, the rcu_access_pointer() docbook header comment:

/**
 * rcu_access_pointer() - fetch RCU pointer with no dereferencing
 * @p: The pointer to read
 *
 * Return the value of the specified RCU-protected pointer, but omit the
 * lockdep checks for being in an RCU read-side critical section.  This is
 * useful when the value of this pointer is accessed, but the pointer is
 * not dereferenced, for example, when testing an RCU-protected pointer
 * against NULL.  Although rcu_access_pointer() may also be used in cases
 * where update-side locks prevent the value of the pointer from changing,
 * you should instead use rcu_dereference_protected() for this use case.
 *
 * It is also permissible to use rcu_access_pointer() when read-side
 * access to the pointer was removed at least one grace period ago, as
 * is the case in the context of the RCU callback that is freeing up
 * the data, or after a synchronize_rcu() returns.  This can be useful
 * when tearing down multi-linked structures after a grace period
 * has elapsed.
 */

So the restriction is that the pointer returned from rcu_access_pointer()
cannot be dereferenced or that the structure is beyond being updated.

So this is OK:

	// Not in an RCU reader.  Or even in an RCU updater.
	if (rcu_access_pointer(my_rcu_pointer))
		do_something();
	...

And so is this:

	p = xchg(&my_rcu_pointer, NULL);
	if (p) {
		synchronize_rcu();
		// No one else has access to this list!
		while (p) {
			q = rcu_access_pointer(p->next);
			kfree(p);
			q = p;
			// But why are you hand-crafting list???
			// Any why not use rcu_dereference_protected()?
		}
	}

But this is not:

	p = rcu_access_pointer(my_rcu_pointer);
	do_something_with(p->a); // BUG!!!  Even in an RCU reader.

In this second case, you must instead use rcu_dereference() or
similar.

> > 2. It's not for dereferencing. So, it's for reading the pointer's value
> > on the write side or outside all locks.

True enough, you are not permitted to dereference the value returned
from rcu_access_pointer().  Unless you have the only copy.

But it is just fine to check the value of the pointer, compare it, or
do arithmetic on it.  Just don't dereference it and don't dereference
any value computed from it.

> > 3. Although it can be used on the write side, rcu_dereference_protected
> > should be used. So, it's for reading the pointer's value outside all
> > locks.

Yes, if an RCU updater is going to dereference a pointer, it should
use rcu_dereference_protected() rather than rcu_access_pointer().

So rcu_access_pointer() does what it it says.  It permits the caller
to access the value of the pointer, and only to access that value.
Not dereference that value.

> Using rcu_deref* when we don't dereference the pointer does not compute
> for me, but it's not a big deal. 

It is OK to use rcu_dereference*() to access a pointer without
dereferencing it.

One key difference between rcu_dereference() and rcu_access_pointer()
is that rcu_access_pointer() can be used outside of an RCU reader.
For example:

	// Not in an RCU reader.  Or even in an RCU updater.
	if (rcu_access_pointer(my_rcu_pointer)) {
		rcu_read_lock();
		p = rcu_dereference(my_rcu_pointer);
		if (p)
			do_something_with(p);
		rcu_read_unlock();
	}

This example is silly because the overhead of the extra check might well
exceed that of the rcu_read_lock() and rcu_read_unlock() put together,
especially in CONFIG_PREEMPTION=n kernels.  A less-silly example might
schedule a workqueue or similar to handle the RCU-protected data, and
the overhead of the extra check might be very worthwhile in that case.

> Let me CC Paul for clarification of the docs, as it may also be
> confusing to others and therefore worth rewording. But our case is 
> not that important so unless Paul chimes in clearly indicating one
> interpretation is right - either way is fine by me for v2.

Hope this helps!

And please let me know if it does not.

							Thanx, Paul
