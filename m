Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F5775687A5
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 14:03:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231246AbiGFMCa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 08:02:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233027AbiGFMC2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 08:02:28 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 633F929C90;
        Wed,  6 Jul 2022 05:02:25 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1o93jF-00040B-IJ; Wed, 06 Jul 2022 14:02:01 +0200
Date:   Wed, 6 Jul 2022 14:02:01 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Kajetan Puchalski <kajetan.puchalski@arm.com>
Cc:     Will Deacon <will@kernel.org>, Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Mel Gorman <mgorman@suse.de>,
        lukasz.luba@arm.com, dietmar.eggemann@arm.com,
        mark.rutland@arm.com, broonie@kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, stable@vger.kernel.org,
        regressions@lists.linux.dev, linux-kernel@vger.kernel.org,
        peterz@infradead.org
Subject: Re: [Regression] stress-ng udp-flood causes kernel panic on Ampere
 Altra
Message-ID: <20220706120201.GA7996@breakpoint.cc>
References: <20220701200110.GA15144@breakpoint.cc>
 <YsAnPhPfWRjpkdmn@e126311.manchester.arm.com>
 <20220702205651.GB15144@breakpoint.cc>
 <YsKxTAaIgvKMfOoU@e126311.manchester.arm.com>
 <YsLGoU7q5hP67TJJ@e126311.manchester.arm.com>
 <YsQYIoJK3iqJ68Tq@e126311.manchester.arm.com>
 <20220705105749.GA711@willie-the-truck>
 <20220705110724.GB711@willie-the-truck>
 <20220705112449.GA931@willie-the-truck>
 <YsVmbOqzACeo1rO4@e126311.manchester.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YsVmbOqzACeo1rO4@e126311.manchester.arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kajetan Puchalski <kajetan.puchalski@arm.com> wrote:
> On Tue, Jul 05, 2022 at 12:24:49PM +0100, Will Deacon wrote:
> > > > Sorry, but I have absolutely no context here. We have a handy document
> > > > describing the differences between atomic_t and refcount_t:
> > > > 
> > > > 	Documentation/core-api/refcount-vs-atomic.rst
> > > > 
> > > > What else do you need to know?
> > > 
> > > Hmm, and I see a tonne of *_inc_not_zero() conversions in 719774377622
> > > ("netfilter: conntrack: convert to refcount_t api") which mean that you
> > > no longer have ordering to subsequent reads in the absence of an address
> > > dependency.
> > 
> > I think the patch above needs auditing with the relaxed behaviour in mind,
> > but for the specific crash reported here possibly something like the diff
> > below?
> > 
> > Will
> > 
> > --->8
> > 
> > diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
> > index 082a2fd8d85b..5ad9fcc84269 100644
> > --- a/net/netfilter/nf_conntrack_core.c
> > +++ b/net/netfilter/nf_conntrack_core.c
> > @@ -1394,6 +1394,7 @@ static unsigned int early_drop_list(struct net *net,
> >                  * already fired or someone else deleted it. Just drop ref
> >                  * and move to next entry.
> >                  */
> > +               smp_rmb();      /* XXX: Why? */
> >                 if (net_eq(nf_ct_net(tmp), net) &&
> >                     nf_ct_is_confirmed(tmp) &&
> >                     nf_ct_delete(tmp, 0, 0))
> > 
> 
> Just to follow up, I think you're right, the patch in question should be
> audited further for other missing memory barrier issues.
> While this one smp_rmb() helps a lot, ie lets the test run for at least
> an hour or two, an overnight 6 hour test still resulted in the same
> crash somewhere along the way so it looks like it's not the only one
> that's needed.

Yes, I don't think that refcount_inc_not_zero is useable as-is for conntrack.
Here is a patch, I hope this will get things back to a working order without
a revert to atomic_t api.

Subject: [nf] netfilter: conntrack: fix crash due to confirmed bit load reordering

Kajetan Puchalski reports crash on ARM, with backtrace of:

__nf_ct_delete_from_lists
nf_ct_delete
early_drop
__nf_conntrack_alloc

Unlike atomic_inc_not_zero, refcount_inc_not_zero is not a full barrier.
conntrack uses SLAB_TYPESAFE_BY_RCU, i.e. it is possible that a 'newly'
allocated object is still in use on another CPU:

CPU1						CPU2
						enounters 'ct' during hlist walk
 delete_from_lists
 refcount drops to 0
 kmem_cache_free(ct);
 __nf_conntrack_alloc() // returns same object
						refcount_inc_not_zero(ct); /* might fail */

						/* If set, ct is public/in the hash table */
						test_bit(IPS_CONFIRMED_BIT, &ct->status);

In case CPU1 already set refcount back to 1, refcount_inc_not_zero()
will succeed.

The expected possibilities for a CPU that obtained the object 'ct'
(but no reference so far) are:

1. refcount_inc_not_zero() fails.  CPU2 ignores the object and moves to
   the next entry in the list.  This happens for objects that are about
   to be free'd, that have been free'd, or that have been reallocated
   by __nf_conntrack_alloc(), but where the refcount has not been
   increased back to 1 yet.

2. refcount_inc_not_zero() succeeds. CPU2 checks the CONFIRMED bit
   in ct->status.  If set, the object is public/in the table.

   If not, the object must be skipped; CPU2 calls nf_ct_put() to
   un-do the refcount increment and moves to the next object.

Parallel deletion from the hlists is prevented by a
'test_and_set_bit(IPS_DYING_BIT, &ct->status);' check, i.e. only one
cpu will do the unlink, the other one will only drop its reference count.

Because refcount_inc_not_zero is not a full barrier, CPU2 may try to
delete an object that is not on any list:

1. refcount_inc_not_zero() successful (refcount inited to 1 on other CPU)
2. CONFIRMED test also successful (load was reordered or zeroing
   of ct->status not yet visible)
3. delete_from_lists unlinks entry not on the hlist, because
   IPS_DYING_BIT is 0 (already cleared).

2) is already wrong: CPU2 will handle a partially initited object
that is supposed to be private to CPU1.

This change adds smp_rmb() whenever refcount_inc_not_zero() was successful.

It also inserts a smp_wmb() before the refcount is set to 1 during
allocation.

Because other CPU might still 'see' the object, refcount_set(1)
"resurrects" the object, so we need to make sure that other CPUs will
also observe the right contents.  In particular, the CONFIRMED bit test
must only pass once the object is fully initialised and either in the
hash or about to be inserted (with locks held to delay possible unlink from
early_drop or gc worker).

I did not change flow_offload_alloc(), as far as I can see it should call
refcount_inc(), not refcount_inc_not_zero(): the ct object is attached to
the skb so its refcount should be >= 1 in all cases.

Reported-by: Kajetan Puchalski <kajetan.puchalski@arm.com>
Diagnosed-by: Will Deacon <will@kernel.org>
Fixes: 719774377622 ("netfilter: conntrack: convert to refcount_t api")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_conntrack.h |  3 +++
 net/netfilter/nf_conntrack_core.c    | 19 +++++++++++++++++++
 2 files changed, 22 insertions(+)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index a32be8aa7ed2..3dc3646ffba2 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -300,6 +300,9 @@ static inline bool nf_ct_is_expired(const struct nf_conn *ct)
 /* use after obtaining a reference count */
 static inline bool nf_ct_should_gc(const struct nf_conn *ct)
 {
+	/* ->status and ->timeout loads must happen after refcount increase */
+	smp_rmb();
+
 	return nf_ct_is_expired(ct) && nf_ct_is_confirmed(ct) &&
 	       !nf_ct_is_dying(ct);
 }
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 082a2fd8d85b..072cabf1b296 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -795,6 +795,9 @@ __nf_conntrack_find_get(struct net *net, const struct nf_conntrack_zone *zone,
 		 */
 		ct = nf_ct_tuplehash_to_ctrack(h);
 		if (likely(refcount_inc_not_zero(&ct->ct_general.use))) {
+			/* re-check key after refcount */
+			smp_rmb();
+
 			if (likely(nf_ct_key_equal(h, tuple, zone, net)))
 				goto found;
 
@@ -1393,7 +1396,11 @@ static unsigned int early_drop_list(struct net *net,
 		 * We steal the timer reference.  If that fails timer has
 		 * already fired or someone else deleted it. Just drop ref
 		 * and move to next entry.
+		 *
+		 * smp_rmb to ensure ->ct_net and ->status are loaded after
+		 * refcount increase.
 		 */
+		smp_rmb();
 		if (net_eq(nf_ct_net(tmp), net) &&
 		    nf_ct_is_confirmed(tmp) &&
 		    nf_ct_delete(tmp, 0, 0))
@@ -1536,6 +1543,8 @@ static void gc_worker(struct work_struct *work)
 			if (!refcount_inc_not_zero(&tmp->ct_general.use))
 				continue;
 
+			/* load ct->status after refcount */
+			smp_rmb();
 			if (gc_worker_skip_ct(tmp)) {
 				nf_ct_put(tmp);
 				continue;
@@ -1775,6 +1784,16 @@ init_conntrack(struct net *net, struct nf_conn *tmpl,
 	if (!exp)
 		__nf_ct_try_assign_helper(ct, tmpl, GFP_ATOMIC);
 
+	/* Other CPU might have obtained a pointer to this object before it was
+	 * released.  Because refcount is 0, refcount_inc_not_zero() will fail.
+	 *
+	 * After refcount_set(1) it will succeed; ensure that zeroing of
+	 * ct->status and the correct ct->net pointer are visible; else other
+	 * core might observe CONFIRMED bit which means the entry is valid and
+	 * in the hash table, but its not (anymore).
+	 */
+	smp_wmb();
+
 	/* Now it is going to be associated with an sk_buff, set refcount to 1. */
 	refcount_set(&ct->ct_general.use, 1);
 
-- 
2.35.1

