Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12278326D6
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 05:03:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726816AbfFCDDg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jun 2019 23:03:36 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:44406 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725872AbfFCDDf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 2 Jun 2019 23:03:35 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hXdFy-000817-M0; Mon, 03 Jun 2019 11:03:30 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hXdFs-0001zg-Qt; Mon, 03 Jun 2019 11:03:24 +0800
Date:   Mon, 3 Jun 2019 11:03:24 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     "Paul E. McKenney" <paulmck@linux.ibm.com>
Cc:     Frederic Weisbecker <fweisbec@gmail.com>,
        Boqun Feng <boqun.feng@gmail.com>,
        Fengguang Wu <fengguang.wu@intel.com>, LKP <lkp@01.org>,
        LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: rcu_read_lock lost its compiler barrier
Message-ID: <20190603030324.kl3bckqmebzis2vw@gondor.apana.org.au>
References: <20150910005708.GA23369@wfg-t540p.sh.intel.com>
 <20150910102513.GA1677@fixme-laptop.cn.ibm.com>
 <20150910171649.GE4029@linux.vnet.ibm.com>
 <20150911021933.GA1521@fixme-laptop.cn.ibm.com>
 <20150921193045.GA13674@lerouge>
 <20150921204327.GH4029@linux.vnet.ibm.com>
 <20190602055607.bk5vgmwjvvt4wejd@gondor.apana.org.au>
 <20190603000617.GD28207@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190603000617.GD28207@linux.ibm.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 02, 2019 at 05:06:17PM -0700, Paul E. McKenney wrote:
>
> Please note that preemptible Tree RCU has lacked the compiler barrier on
> all but the outermost rcu_read_unlock() for years before Boqun's patch.

Actually this is not true.  Boqun's patch (commit bb73c52bad36) does
not add a barrier() to __rcu_read_lock.  In fact I dug into the git
history and this compiler barrier() has existed in preemptible tree
RCU since the very start in 2009:

: commit f41d911f8c49a5d65c86504c19e8204bb605c4fd
: Author: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
: Date:   Sat Aug 22 13:56:52 2009 -0700
:
:     rcu: Merge preemptable-RCU functionality into hierarchical RCU
:
: +/*
: + * Tree-preemptable RCU implementation for rcu_read_lock().
: + * Just increment ->rcu_read_lock_nesting, shared state will be updated
: + * if we block.
: + */
: +void __rcu_read_lock(void)
: +{
: +       ACCESS_ONCE(current->rcu_read_lock_nesting)++;
: +       barrier();  /* needed if we ever invoke rcu_read_lock in rcutree.c */
: +}
: +EXPORT_SYMBOL_GPL(__rcu_read_lock);

However, you are correct that in the non-preempt tree RCU case,
the compiler barrier in __rcu_read_lock was not always present.
In fact it was added by:

: commit 386afc91144b36b42117b0092893f15bc8798a80
: Author: Linus Torvalds <torvalds@linux-foundation.org>
: Date:   Tue Apr 9 10:48:33 2013 -0700
:
:     spinlocks and preemption points need to be at least compiler barriers

I suspect this is what prompted you to remove it in 2015.

> I do not believe that reverting that patch will help you at all.
> 
> But who knows?  So please point me at the full code body that was being
> debated earlier on this thread.  It will no doubt take me quite a while to
> dig through it, given my being on the road for the next couple of weeks,
> but so it goes.

Please refer to my response to Linus for the code in question.

In any case, I am now even more certain that compiler barriers are
not needed in the code in question.  The reasoning is quite simple.
If you need those compiler barriers then you surely need real memory
barriers.

Vice versa, if real memory barriers are already present thanks to
RCU, then you don't need those compiler barriers.

In fact this calls into question the use of READ_ONCE/WRITE_ONCE in
RCU primitives such as rcu_dereference and rcu_assign_pointer.  IIRC
when RCU was first added to the Linux kernel we did not have compiler
barriers in rcu_dereference and rcu_assign_pointer.  They were added
later on.

As compiler barriers per se are useless, these are surely meant to
be coupled with the memory barriers provided by RCU grace periods
and synchronize_rcu.  But then those real memory barriers would have
compiler barriers too.  So why do we need the compiler barriers in
rcu_dereference and rcu_assign_pointer?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
