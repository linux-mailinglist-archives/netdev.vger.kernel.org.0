Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F7405685CB
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 12:40:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232450AbiGFKjy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 06:39:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbiGFKjx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 06:39:53 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AADAE2716B;
        Wed,  6 Jul 2022 03:39:52 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8006F1042;
        Wed,  6 Jul 2022 03:39:52 -0700 (PDT)
Received: from e126311.manchester.arm.com (unknown [10.57.71.227])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2C5EF3F66F;
        Wed,  6 Jul 2022 03:39:49 -0700 (PDT)
Date:   Wed, 6 Jul 2022 11:39:40 +0100
From:   Kajetan Puchalski <kajetan.puchalski@arm.com>
To:     Will Deacon <will@kernel.org>
Cc:     Florian Westphal <fw@strlen.de>,
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
        peterz@infradead.org, kajetan.puchalski@arm.com
Subject: Re: [Regression] stress-ng udp-flood causes kernel panic on Ampere
 Altra
Message-ID: <YsVmbOqzACeo1rO4@e126311.manchester.arm.com>
References: <Yr7WTfd6AVTQkLjI@e126311.manchester.arm.com>
 <20220701200110.GA15144@breakpoint.cc>
 <YsAnPhPfWRjpkdmn@e126311.manchester.arm.com>
 <20220702205651.GB15144@breakpoint.cc>
 <YsKxTAaIgvKMfOoU@e126311.manchester.arm.com>
 <YsLGoU7q5hP67TJJ@e126311.manchester.arm.com>
 <YsQYIoJK3iqJ68Tq@e126311.manchester.arm.com>
 <20220705105749.GA711@willie-the-truck>
 <20220705110724.GB711@willie-the-truck>
 <20220705112449.GA931@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220705112449.GA931@willie-the-truck>
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 05, 2022 at 12:24:49PM +0100, Will Deacon wrote:
> > > Sorry, but I have absolutely no context here. We have a handy document
> > > describing the differences between atomic_t and refcount_t:
> > > 
> > > 	Documentation/core-api/refcount-vs-atomic.rst
> > > 
> > > What else do you need to know?
> > 
> > Hmm, and I see a tonne of *_inc_not_zero() conversions in 719774377622
> > ("netfilter: conntrack: convert to refcount_t api") which mean that you
> > no longer have ordering to subsequent reads in the absence of an address
> > dependency.
> 
> I think the patch above needs auditing with the relaxed behaviour in mind,
> but for the specific crash reported here possibly something like the diff
> below?
> 
> Will
> 
> --->8
> 
> diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
> index 082a2fd8d85b..5ad9fcc84269 100644
> --- a/net/netfilter/nf_conntrack_core.c
> +++ b/net/netfilter/nf_conntrack_core.c
> @@ -1394,6 +1394,7 @@ static unsigned int early_drop_list(struct net *net,
>                  * already fired or someone else deleted it. Just drop ref
>                  * and move to next entry.
>                  */
> +               smp_rmb();      /* XXX: Why? */
>                 if (net_eq(nf_ct_net(tmp), net) &&
>                     nf_ct_is_confirmed(tmp) &&
>                     nf_ct_delete(tmp, 0, 0))
> 

Just to follow up, I think you're right, the patch in question should be
audited further for other missing memory barrier issues.
While this one smp_rmb() helps a lot, ie lets the test run for at least
an hour or two, an overnight 6 hour test still resulted in the same
crash somewhere along the way so it looks like it's not the only one
that's needed.
