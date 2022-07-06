Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77D3C568836
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 14:23:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233541AbiGFMXD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 08:23:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231875AbiGFMXC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 08:23:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0810E1EC6C;
        Wed,  6 Jul 2022 05:23:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C2AD1B81CAA;
        Wed,  6 Jul 2022 12:22:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B999AC3411C;
        Wed,  6 Jul 2022 12:22:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657110178;
        bh=1ZJb/iEn73TDHU7Q+jBF1YIGpL32MfjdqyaRDa+4uPI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XalUi/XI2nsHYiD3CPNszAkwYcFxWNOexTwjpjDPfmf6QVGp0AtWwtcg2DgRSOCVV
         MxhzT5F7u/DfuThdMmCMSpqWjCakX8FFncELCHyUgxNkpfoL1zVenq2X7hCjoFLtEa
         qATXweuz5Mu866Z9uAwVwfT/7nnWmjMiGN/uCqJGl9jVFc9VMsIBikcOwfyskUBsNJ
         OjauqhfhBgrjQbHhxirS+6BOselkn7Ic3ow6ZwXWHq0uJZXCLiYZPovzwY8SijVSSG
         emsD7EskYoVIP8fIZbqld2DBKMTs5Nd9l3h9tejvvIp0pg7LtoPXCJ2IEIJWMFlbhm
         w56Gp35pX8YKQ==
Date:   Wed, 6 Jul 2022 13:22:50 +0100
From:   Will Deacon <will@kernel.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     Kajetan Puchalski <kajetan.puchalski@arm.com>,
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
Message-ID: <20220706122246.GI2403@willie-the-truck>
References: <YsAnPhPfWRjpkdmn@e126311.manchester.arm.com>
 <20220702205651.GB15144@breakpoint.cc>
 <YsKxTAaIgvKMfOoU@e126311.manchester.arm.com>
 <YsLGoU7q5hP67TJJ@e126311.manchester.arm.com>
 <YsQYIoJK3iqJ68Tq@e126311.manchester.arm.com>
 <20220705105749.GA711@willie-the-truck>
 <20220705110724.GB711@willie-the-truck>
 <20220705112449.GA931@willie-the-truck>
 <YsVmbOqzACeo1rO4@e126311.manchester.arm.com>
 <20220706120201.GA7996@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220706120201.GA7996@breakpoint.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 06, 2022 at 02:02:01PM +0200, Florian Westphal wrote:
> Kajetan Puchalski <kajetan.puchalski@arm.com> wrote:
> > On Tue, Jul 05, 2022 at 12:24:49PM +0100, Will Deacon wrote:
> > > > > Sorry, but I have absolutely no context here. We have a handy document
> > > > > describing the differences between atomic_t and refcount_t:
> > > > > 
> > > > > 	Documentation/core-api/refcount-vs-atomic.rst
> > > > > 
> > > > > What else do you need to know?
> > > > 
> > > > Hmm, and I see a tonne of *_inc_not_zero() conversions in 719774377622
> > > > ("netfilter: conntrack: convert to refcount_t api") which mean that you
> > > > no longer have ordering to subsequent reads in the absence of an address
> > > > dependency.
> > > 
> > > I think the patch above needs auditing with the relaxed behaviour in mind,
> > > but for the specific crash reported here possibly something like the diff
> > > below?
> > > 
> > > Will
> > > 
> > > --->8
> > > 
> > > diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
> > > index 082a2fd8d85b..5ad9fcc84269 100644
> > > --- a/net/netfilter/nf_conntrack_core.c
> > > +++ b/net/netfilter/nf_conntrack_core.c
> > > @@ -1394,6 +1394,7 @@ static unsigned int early_drop_list(struct net *net,
> > >                  * already fired or someone else deleted it. Just drop ref
> > >                  * and move to next entry.
> > >                  */
> > > +               smp_rmb();      /* XXX: Why? */
> > >                 if (net_eq(nf_ct_net(tmp), net) &&
> > >                     nf_ct_is_confirmed(tmp) &&
> > >                     nf_ct_delete(tmp, 0, 0))
> > > 
> > 
> > Just to follow up, I think you're right, the patch in question should be
> > audited further for other missing memory barrier issues.
> > While this one smp_rmb() helps a lot, ie lets the test run for at least
> > an hour or two, an overnight 6 hour test still resulted in the same
> > crash somewhere along the way so it looks like it's not the only one
> > that's needed.
> 
> Yes, I don't think that refcount_inc_not_zero is useable as-is for conntrack.
> Here is a patch, I hope this will get things back to a working order without
> a revert to atomic_t api.
> 
> Subject: [nf] netfilter: conntrack: fix crash due to confirmed bit load reordering
> 
> Kajetan Puchalski reports crash on ARM, with backtrace of:
> 
> __nf_ct_delete_from_lists
> nf_ct_delete
> early_drop
> __nf_conntrack_alloc
> 
> Unlike atomic_inc_not_zero, refcount_inc_not_zero is not a full barrier.
> conntrack uses SLAB_TYPESAFE_BY_RCU, i.e. it is possible that a 'newly'
> allocated object is still in use on another CPU:
> 
> CPU1						CPU2
> 						enounters 'ct' during hlist walk
>  delete_from_lists
>  refcount drops to 0
>  kmem_cache_free(ct);
>  __nf_conntrack_alloc() // returns same object
> 						refcount_inc_not_zero(ct); /* might fail */
> 
> 						/* If set, ct is public/in the hash table */
> 						test_bit(IPS_CONFIRMED_BIT, &ct->status);
> 
> In case CPU1 already set refcount back to 1, refcount_inc_not_zero()
> will succeed.
> 
> The expected possibilities for a CPU that obtained the object 'ct'
> (but no reference so far) are:
> 
> 1. refcount_inc_not_zero() fails.  CPU2 ignores the object and moves to
>    the next entry in the list.  This happens for objects that are about
>    to be free'd, that have been free'd, or that have been reallocated
>    by __nf_conntrack_alloc(), but where the refcount has not been
>    increased back to 1 yet.
> 
> 2. refcount_inc_not_zero() succeeds. CPU2 checks the CONFIRMED bit
>    in ct->status.  If set, the object is public/in the table.
> 
>    If not, the object must be skipped; CPU2 calls nf_ct_put() to
>    un-do the refcount increment and moves to the next object.
> 
> Parallel deletion from the hlists is prevented by a
> 'test_and_set_bit(IPS_DYING_BIT, &ct->status);' check, i.e. only one
> cpu will do the unlink, the other one will only drop its reference count.
> 
> Because refcount_inc_not_zero is not a full barrier, CPU2 may try to
> delete an object that is not on any list:
> 
> 1. refcount_inc_not_zero() successful (refcount inited to 1 on other CPU)
> 2. CONFIRMED test also successful (load was reordered or zeroing
>    of ct->status not yet visible)
> 3. delete_from_lists unlinks entry not on the hlist, because
>    IPS_DYING_BIT is 0 (already cleared).
> 
> 2) is already wrong: CPU2 will handle a partially initited object
> that is supposed to be private to CPU1.
> 
> This change adds smp_rmb() whenever refcount_inc_not_zero() was successful.
> 
> It also inserts a smp_wmb() before the refcount is set to 1 during
> allocation.
> 
> Because other CPU might still 'see' the object, refcount_set(1)
> "resurrects" the object, so we need to make sure that other CPUs will
> also observe the right contents.  In particular, the CONFIRMED bit test
> must only pass once the object is fully initialised and either in the
> hash or about to be inserted (with locks held to delay possible unlink from
> early_drop or gc worker).
> 
> I did not change flow_offload_alloc(), as far as I can see it should call
> refcount_inc(), not refcount_inc_not_zero(): the ct object is attached to
> the skb so its refcount should be >= 1 in all cases.
> 
> Reported-by: Kajetan Puchalski <kajetan.puchalski@arm.com>
> Diagnosed-by: Will Deacon <will@kernel.org>
> Fixes: 719774377622 ("netfilter: conntrack: convert to refcount_t api")
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  include/net/netfilter/nf_conntrack.h |  3 +++
>  net/netfilter/nf_conntrack_core.c    | 19 +++++++++++++++++++
>  2 files changed, 22 insertions(+)
> 
> diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
> index a32be8aa7ed2..3dc3646ffba2 100644
> --- a/include/net/netfilter/nf_conntrack.h
> +++ b/include/net/netfilter/nf_conntrack.h
> @@ -300,6 +300,9 @@ static inline bool nf_ct_is_expired(const struct nf_conn *ct)
>  /* use after obtaining a reference count */
>  static inline bool nf_ct_should_gc(const struct nf_conn *ct)
>  {
> +	/* ->status and ->timeout loads must happen after refcount increase */
> +	smp_rmb();

Sorry I didn't suggest this earlier, but if all of these smp_rmb()s are
for upgrading the ordering from refcount_inc_not_zero() then you should
use smp_acquire__after_ctrl_dep() instead. It's the same under the hood,
but it illustrates what's going on a bit better.

> @@ -1775,6 +1784,16 @@ init_conntrack(struct net *net, struct nf_conn *tmpl,
>  	if (!exp)
>  		__nf_ct_try_assign_helper(ct, tmpl, GFP_ATOMIC);
>  
> +	/* Other CPU might have obtained a pointer to this object before it was
> +	 * released.  Because refcount is 0, refcount_inc_not_zero() will fail.
> +	 *
> +	 * After refcount_set(1) it will succeed; ensure that zeroing of
> +	 * ct->status and the correct ct->net pointer are visible; else other
> +	 * core might observe CONFIRMED bit which means the entry is valid and
> +	 * in the hash table, but its not (anymore).
> +	 */
> +	smp_wmb();
> +
>  	/* Now it is going to be associated with an sk_buff, set refcount to 1. */
>  	refcount_set(&ct->ct_general.use, 1);

Ideally that refcount_set() would be a release, but this is definitely
(ab)using refcount_t in way that isn't anticipated by the API! It looks
like a similar pattern exists in net/core/sock.c as well, so I wonder if
it's worth extending the API.

Peter, what do you think?

Will
