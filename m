Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46AF15668E4
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 13:07:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232557AbiGELHg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 07:07:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231703AbiGELHe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 07:07:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 126041402E;
        Tue,  5 Jul 2022 04:07:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9E75D6103F;
        Tue,  5 Jul 2022 11:07:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BEFAC341C7;
        Tue,  5 Jul 2022 11:07:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657019253;
        bh=s7uIwx4/KhnTz5Vqkm5gM2z8b9anZC8yzAB3ZypeG10=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RH2U60dklemlOAU3ucknIjczljTkZgvCU0Cl7gsdYdy7LMP37Sd3j6mDApiUhUMAJ
         sSF3HiehbcCpWUP7yYjoWBsByRKJK+elXyot+UY82DbHH65wTWMHTA/PSdJg7WBSTs
         77icbx9AFFr2+LHvH6f23pMQCPv+Uu6NS5NPRxSIqFRw9rGizc+Prbj8VdomqQbacg
         DfemT3Osg8ngmSZTnyxQRodOeX/uJrsRGn3yOIoKLT5wcOWrN51q125ZheuMo1tQ4t
         eKEA3uU65v5eQfTZFSOKuCF5uSNuFRF4hE8xyKNRkOApC1zbdcbcFIuXDgVlgm7rMY
         frRf/oDJGd+1A==
Date:   Tue, 5 Jul 2022 12:07:25 +0100
From:   Will Deacon <will@kernel.org>
To:     Kajetan Puchalski <kajetan.puchalski@arm.com>
Cc:     Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Mel Gorman <mgorman@suse.de>,
        lukasz.luba@arm.com, dietmar.eggemann@arm.com,
        mark.rutland@arm.com, mark.brown@arm.com,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, stable@vger.kernel.org,
        regressions@lists.linux.dev, linux-kernel@vger.kernel.org,
        peterz@infradead.org
Subject: Re: [Regression] stress-ng udp-flood causes kernel panic on Ampere
 Altra
Message-ID: <20220705110724.GB711@willie-the-truck>
References: <Yr7WTfd6AVTQkLjI@e126311.manchester.arm.com>
 <20220701200110.GA15144@breakpoint.cc>
 <YsAnPhPfWRjpkdmn@e126311.manchester.arm.com>
 <20220702205651.GB15144@breakpoint.cc>
 <YsKxTAaIgvKMfOoU@e126311.manchester.arm.com>
 <YsLGoU7q5hP67TJJ@e126311.manchester.arm.com>
 <YsQYIoJK3iqJ68Tq@e126311.manchester.arm.com>
 <20220705105749.GA711@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220705105749.GA711@willie-the-truck>
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

On Tue, Jul 05, 2022 at 11:57:49AM +0100, Will Deacon wrote:
> On Tue, Jul 05, 2022 at 11:53:22AM +0100, Kajetan Puchalski wrote:
> > On Mon, Jul 04, 2022 at 10:22:24AM +0100, Kajetan Puchalski wrote:
> > > On Sat, Jul 02, 2022 at 10:56:51PM +0200, Florian Westphal wrote:
> > > > > That would make sense, from further experiments I ran it somehow seems
> > > > > to be related to the number of workers being spawned by stress-ng along
> > > > > with the CPUs/cores involved.
> > > > >
> > > > > For instance, running the test with <=25 workers (--udp-flood 25 etc.)
> > > > > results in the test running fine for at least 15 minutes.
> > > > 
> > > > Ok.  I will let it run for longer on the machines I have access to.
> > > > 
> > > > In mean time, you could test attached patch, its simple s/refcount_/atomic_/
> > > > in nf_conntrack.
> > > > 
> > > > If mainline (patch vs. HEAD 69cb6c6556ad89620547318439) crashes for you
> > > > but works with attached patch someone who understands aarch64 memory ordering
> > > > would have to look more closely at refcount_XXX functions to see where they
> > > > might differ from atomic_ ones.
> > > 
> > > I can confirm that the patch seems to solve the issue.
> > > With it applied on top of the 5.19-rc5 tag the test runs fine for at
> > > least 15 minutes which was not the case before so it looks like it is
> > > that aarch64 memory ordering problem.
> > 
> > I'm CCing some people who should be able to help with aarch64 memory
> > ordering, maybe they could take a look.
> > 
> > (re-sending due to a typo in CC, sorry for duplicate emails!)
> 
> Sorry, but I have absolutely no context here. We have a handy document
> describing the differences between atomic_t and refcount_t:
> 
> 	Documentation/core-api/refcount-vs-atomic.rst
> 
> What else do you need to know?

Hmm, and I see a tonne of *_inc_not_zero() conversions in 719774377622
("netfilter: conntrack: convert to refcount_t api") which mean that you
no longer have ordering to subsequent reads in the absence of an address
dependency.

Will
