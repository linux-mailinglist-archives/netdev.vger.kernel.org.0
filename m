Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54970326C1
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 04:47:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726837AbfFCCqy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jun 2019 22:46:54 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:44096 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726270AbfFCCqx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 2 Jun 2019 22:46:53 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hXczn-0007pq-Vp; Mon, 03 Jun 2019 10:46:48 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hXczg-0001y1-8M; Mon, 03 Jun 2019 10:46:40 +0800
Date:   Mon, 3 Jun 2019 10:46:40 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Boqun Feng <boqun.feng@gmail.com>,
        Fengguang Wu <fengguang.wu@intel.com>, LKP <lkp@01.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: rcu_read_lock lost its compiler barrier
Message-ID: <20190603024640.2soysu4rpkwjuash@gondor.apana.org.au>
References: <20150910005708.GA23369@wfg-t540p.sh.intel.com>
 <20150910102513.GA1677@fixme-laptop.cn.ibm.com>
 <20150910171649.GE4029@linux.vnet.ibm.com>
 <20150911021933.GA1521@fixme-laptop.cn.ibm.com>
 <20150921193045.GA13674@lerouge>
 <20150921204327.GH4029@linux.vnet.ibm.com>
 <20190602055607.bk5vgmwjvvt4wejd@gondor.apana.org.au>
 <CAHk-=whLGKOmM++OQi5GX08_dfh8Xfz9Wq7khPo+MVtPYh_8hw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=whLGKOmM++OQi5GX08_dfh8Xfz9Wq7khPo+MVtPYh_8hw@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 02, 2019 at 01:54:12PM -0700, Linus Torvalds wrote:
> On Sat, Jun 1, 2019 at 10:56 PM Herbert Xu <herbert@gondor.apana.org.au> wrote:
> >
> > You can't then go and decide to remove the compiler barrier!  To do
> > that you'd need to audit every single use of rcu_read_lock in the
> > kernel to ensure that they're not depending on the compiler barrier.
> 
> What's the possible case where it would matter when there is no preemption?

The case we were discussing is from net/ipv4/inet_fragment.c from
the net-next tree:

void fqdir_exit(struct fqdir *fqdir)
{
	...
	fqdir->dead = true;

	/* call_rcu is supposed to provide memory barrier semantics,
	 * separating the setting of fqdir->dead with the destruction
	 * work.  This implicit barrier is paired with inet_frag_kill().
	 */

	INIT_RCU_WORK(&fqdir->destroy_rwork, fqdir_rwork_fn);
	queue_rcu_work(system_wq, &fqdir->destroy_rwork);
}

and

void inet_frag_kill(struct inet_frag_queue *fq)
{
		...
		rcu_read_lock();
		/* The RCU read lock provides a memory barrier
		 * guaranteeing that if fqdir->dead is false then
		 * the hash table destruction will not start until
		 * after we unlock.  Paired with inet_frags_exit_net().
		 */
		if (!fqdir->dead) {
			rhashtable_remove_fast(&fqdir->rhashtable, &fq->node,
					       fqdir->f->rhash_params);
			...
		}
		...
		rcu_read_unlock();
		...
}

I simplified this to

Initial values:

a = 0
b = 0

CPU1				CPU2
----				----
a = 1				rcu_read_lock
synchronize_rcu			if (a == 0)
b = 2					b = 1
				rcu_read_unlock

On exit we want this to be true:
b == 2

Now what Paul was telling me is that unless every memory operation
is done with READ_ONCE/WRITE_ONCE then his memory model shows that
the exit constraint won't hold.  IOW, we need

CPU1				CPU2
----				----
WRITE_ONCE(a, 1)		rcu_read_lock
synchronize_rcu			if (READ_ONCE(a) == 0)
WRITE_ONCE(b, 2)			WRITE_ONCE(b, 1)
				rcu_read_unlock

Now I think this bullshit because if we really needed these compiler
barriers then we surely would need real memory barriers to go with
them.

In fact, the sole purpose of the RCU mechanism is to provide those
memory barriers.  Quoting from
Documentation/RCU/Design/Requirements/Requirements.html:

<li>	Each CPU that has an RCU read-side critical section that
	begins before <tt>synchronize_rcu()</tt> starts is
	guaranteed to execute a full memory barrier between the time
	that the RCU read-side critical section ends and the time that
	<tt>synchronize_rcu()</tt> returns.
	Without this guarantee, a pre-existing RCU read-side critical section
	might hold a reference to the newly removed <tt>struct foo</tt>
	after the <tt>kfree()</tt> on line&nbsp;14 of
	<tt>remove_gp_synchronous()</tt>.
<li>	Each CPU that has an RCU read-side critical section that ends
	after <tt>synchronize_rcu()</tt> returns is guaranteed
	to execute a full memory barrier between the time that
	<tt>synchronize_rcu()</tt> begins and the time that the RCU
	read-side critical section begins.
	Without this guarantee, a later RCU read-side critical section
	running after the <tt>kfree()</tt> on line&nbsp;14 of
	<tt>remove_gp_synchronous()</tt> might
	later run <tt>do_something_gp()</tt> and find the
	newly deleted <tt>struct foo</tt>.

My review of the RCU code shows that these memory barriers are
indeed present (at least when we're not in tiny mode where all
this discussion would be moot anyway).  For example, in call_rcu
we eventually get down to rcu_segcblist_enqueue which has an smp_mb.
On the reader side (correct me if I'm wrong Paul) the memory
barrier is implicitly coming from the scheduler.

My point is that within our kernel whenever we have a CPU memory
barrier we always have a compiler barrier too.  Therefore my code
example above does not need any extra compiler barriers such as
the ones provided by READ_ONCE/WRITE_ONCE.

I think perhaps Paul was perhaps thinking that I'm expecting
rcu_read_lock/rcu_read_unlock themselves to provide the memory
or compiler barriers.  That would indeed be wrong but this is
not what I need.  All I need is the RCU semantics as documented
for there to be memory and compiler barriers around the whole
grace period.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
