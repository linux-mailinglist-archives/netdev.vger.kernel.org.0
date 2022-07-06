Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92987568A83
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 16:01:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233621AbiGFOBe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 10:01:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233210AbiGFOBY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 10:01:24 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58E371AF0E;
        Wed,  6 Jul 2022 07:01:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ouRvW6OEP3qkY26xFcBJ9tiIR5hvG8wwzWSrM+uEL/I=; b=r22GQMcjL2cTA+cmoNxVKQaYIQ
        dwhyEH3B7jMmYNkgOavl/Jkw8ahF4pUqGA50knBcMnA+T7sUrrZ34FNLk4CpwNXFlmdCBQuXuMgC6
        AwUQVVNBvUsYsvtg7SJXC+mM8yy+m6Yfn9zYum2In+mCHyjoDJoEwkrrZFDQZ6zu2qEi08X4EGXjG
        nqFhc+W39vckzfBqTLqNhD57KglAOvtgqwC9xCwGrEpzefP77PX2X4XR0rU0k/TUHqxUt8Hfpbgu0
        VA0+lOt3y9ds9A8wP/CLThg+mPx0CMIJgQ3BWj69BlplgxU6U7cObaHqud6BY2yAxc6mtQbeVyZWS
        MeY41few==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o95aN-001hHB-5i; Wed, 06 Jul 2022 14:00:59 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 727A9300779;
        Wed,  6 Jul 2022 16:00:58 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 53F5E201E7FAD; Wed,  6 Jul 2022 16:00:58 +0200 (CEST)
Date:   Wed, 6 Jul 2022 16:00:58 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Will Deacon <will@kernel.org>
Cc:     Florian Westphal <fw@strlen.de>,
        Kajetan Puchalski <kajetan.puchalski@arm.com>,
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
        regressions@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [Regression] stress-ng udp-flood causes kernel panic on Ampere
 Altra
Message-ID: <YsWVmrMA6aFE8oDr@hirez.programming.kicks-ass.net>
References: <20220702205651.GB15144@breakpoint.cc>
 <YsKxTAaIgvKMfOoU@e126311.manchester.arm.com>
 <YsLGoU7q5hP67TJJ@e126311.manchester.arm.com>
 <YsQYIoJK3iqJ68Tq@e126311.manchester.arm.com>
 <20220705105749.GA711@willie-the-truck>
 <20220705110724.GB711@willie-the-truck>
 <20220705112449.GA931@willie-the-truck>
 <YsVmbOqzACeo1rO4@e126311.manchester.arm.com>
 <20220706120201.GA7996@breakpoint.cc>
 <20220706122246.GI2403@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220706122246.GI2403@willie-the-truck>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 06, 2022 at 01:22:50PM +0100, Will Deacon wrote:

> > @@ -300,6 +300,9 @@ static inline bool nf_ct_is_expired(const struct nf_conn *ct)
> >  /* use after obtaining a reference count */
> >  static inline bool nf_ct_should_gc(const struct nf_conn *ct)
> >  {
> > +	/* ->status and ->timeout loads must happen after refcount increase */
> > +	smp_rmb();
> 
> Sorry I didn't suggest this earlier, but if all of these smp_rmb()s are
> for upgrading the ordering from refcount_inc_not_zero() then you should
> use smp_acquire__after_ctrl_dep() instead. It's the same under the hood,
> but it illustrates what's going on a bit better.

But in that case if had better also be near an actual condition,
otherwise things become too murky for words :/

That is, why is this sprinkled all over instead of right after
an successfull refcount_inc_not_zero() ?

Code like:

	if (!refcount_inc_not_zero())
		return;

	smp_acquire__after_ctrl_dep();

is fairly self-evident, whereas encountering an
smp_acquire__after_ctrl_dep() in a different function, completely
unrelated to any condition is quite crazy.

> > @@ -1775,6 +1784,16 @@ init_conntrack(struct net *net, struct nf_conn *tmpl,
> >  	if (!exp)
> >  		__nf_ct_try_assign_helper(ct, tmpl, GFP_ATOMIC);
> >  
> > +	/* Other CPU might have obtained a pointer to this object before it was
> > +	 * released.  Because refcount is 0, refcount_inc_not_zero() will fail.
> > +	 *
> > +	 * After refcount_set(1) it will succeed; ensure that zeroing of
> > +	 * ct->status and the correct ct->net pointer are visible; else other
> > +	 * core might observe CONFIRMED bit which means the entry is valid and
> > +	 * in the hash table, but its not (anymore).
> > +	 */
> > +	smp_wmb();
> > +
> >  	/* Now it is going to be associated with an sk_buff, set refcount to 1. */
> >  	refcount_set(&ct->ct_general.use, 1);
> 
> Ideally that refcount_set() would be a release, but this is definitely
> (ab)using refcount_t in way that isn't anticipated by the API! It looks
> like a similar pattern exists in net/core/sock.c as well, so I wonder if
> it's worth extending the API.
> 
> Peter, what do you think?

Bah; you have reminded me that I have a fairly sizable amount of
refcount patches from when Linus complained about it last that don't
seem to have gone anywhere :/

Anyway, I suppose we could do a refcount_set_release(), but it had
better get a fairly big comment on how you're on your own if you use it.
