Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74BDE327F8
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 07:26:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726541AbfFCF0j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 01:26:39 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:53536 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726257AbfFCF0j (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Jun 2019 01:26:39 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hXfUO-0001EU-Sq; Mon, 03 Jun 2019 13:26:32 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hXfUI-0002FC-5j; Mon, 03 Jun 2019 13:26:26 +0800
Date:   Mon, 3 Jun 2019 13:26:26 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     "Paul E. McKenney" <paulmck@linux.ibm.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Boqun Feng <boqun.feng@gmail.com>,
        Fengguang Wu <fengguang.wu@intel.com>, LKP <lkp@01.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: rcu_read_lock lost its compiler barrier
Message-ID: <20190603052626.nz2qktwmkswxfnsd@gondor.apana.org.au>
References: <20150910005708.GA23369@wfg-t540p.sh.intel.com>
 <20150910102513.GA1677@fixme-laptop.cn.ibm.com>
 <20150910171649.GE4029@linux.vnet.ibm.com>
 <20150911021933.GA1521@fixme-laptop.cn.ibm.com>
 <20150921193045.GA13674@lerouge>
 <20150921204327.GH4029@linux.vnet.ibm.com>
 <20190602055607.bk5vgmwjvvt4wejd@gondor.apana.org.au>
 <CAHk-=whLGKOmM++OQi5GX08_dfh8Xfz9Wq7khPo+MVtPYh_8hw@mail.gmail.com>
 <20190603024640.2soysu4rpkwjuash@gondor.apana.org.au>
 <20190603034707.GG28207@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190603034707.GG28207@linux.ibm.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 02, 2019 at 08:47:07PM -0700, Paul E. McKenney wrote:
> 
> 1.	These guarantees are of full memory barriers, -not- compiler
> 	barriers.

What I'm saying is that wherever they are, they must come with
compiler barriers.  I'm not aware of any synchronisation mechanism
in the kernel that gives a memory barrier without a compiler barrier.

> 2.	These rules don't say exactly where these full memory barriers
> 	go.  SRCU is at one extreme, placing those full barriers in
> 	srcu_read_lock() and srcu_read_unlock(), and !PREEMPT Tree RCU
> 	at the other, placing these barriers entirely within the callback
> 	queueing/invocation, grace-period computation, and the scheduler.
> 	Preemptible Tree RCU is in the middle, with rcu_read_unlock()
> 	sometimes including a full memory barrier, but other times with
> 	the full memory barrier being confined as it is with !PREEMPT
> 	Tree RCU.

The rules do say that the (full) memory barrier must precede any
RCU read-side that occur after the synchronize_rcu and after the
end of any RCU read-side that occur before the synchronize_rcu.

All I'm arguing is that wherever that full mb is, as long as it
also carries with it a barrier() (which it must do if it's done
using an existing kernel mb/locking primitive), then we're fine.

> Interleaving and inserting full memory barriers as per the rules above:
> 
> 	CPU1: WRITE_ONCE(a, 1)
> 	CPU1: synchronize_rcu	
> 	/* Could put a full memory barrier here, but it wouldn't help. */

	CPU1: smp_mb();
	CPU2: smp_mb();

Let's put them in because I think they are critical.  smp_mb() also
carries with it a barrier().

> 	CPU2: rcu_read_lock();
> 	CPU1: b = 2;	
> 	CPU2: if (READ_ONCE(a) == 0)
> 	CPU2:         if (b != 1)  /* Weakly ordered CPU moved this up! */
> 	CPU2:                 b = 1;
> 	CPU2: rcu_read_unlock
> 
> In fact, CPU2's load from b might be moved up to race with CPU1's store,
> which (I believe) is why the model complains in this case.

Let's put aside my doubt over how we're even allowing a compiler
to turn

	b = 1

into

	if (b != 1)
		b = 1

Since you seem to be assuming that (a == 0) is true in this case
(as the assignment b = 1 is carried out), then because of the
presence of the full memory barrier, the RCU read-side section
must have started prior to the synchronize_rcu.  This means that
synchronize_rcu is not allowed to return until at least the end
of the grace period, or at least until the end of rcu_read_unlock.

So it actually should be:

	CPU1: WRITE_ONCE(a, 1)
	CPU1: synchronize_rcu called
	/* Could put a full memory barrier here, but it wouldn't help. */

	CPU1: smp_mb();
	CPU2: smp_mb();

	CPU2: grace period starts
	...time passes...
	CPU2: rcu_read_lock();
	CPU2: if (READ_ONCE(a) == 0)
	CPU2:         if (b != 1)  /* Weakly ordered CPU moved this up! */
	CPU2:                 b = 1;
	CPU2: rcu_read_unlock
	...time passes...
	CPU2: grace period ends

	/* This full memory barrier is also guaranteed by RCU. */
	CPU2: smp_mb();

	CPU1 synchronize_rcu returns
	CPU1: b = 2;	

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
