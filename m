Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A1905672AB
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 17:30:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231639AbiGEPaP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 11:30:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231670AbiGEPaK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 11:30:10 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 29EF81A806;
        Tue,  5 Jul 2022 08:30:03 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2E7C4D6E;
        Tue,  5 Jul 2022 08:30:03 -0700 (PDT)
Received: from e126311.manchester.arm.com (unknown [10.57.71.227])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1AB343F66F;
        Tue,  5 Jul 2022 08:29:59 -0700 (PDT)
Date:   Tue, 5 Jul 2022 16:29:51 +0100
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
        peterz@infradead.org
Subject: Re: [Regression] stress-ng udp-flood causes kernel panic on Ampere
 Altra
Message-ID: <YsRY7xx2bPcE/tJL@e126311.manchester.arm.com>
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

With this patch applied the issue goes away as well. The test runs fine
well beyond where it would crash previously so looks good, thanks!
