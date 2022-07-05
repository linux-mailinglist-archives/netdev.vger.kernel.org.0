Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08A49566914
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 13:25:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230154AbiGELY7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 07:24:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbiGELY7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 07:24:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5836A13F3C;
        Tue,  5 Jul 2022 04:24:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E811860AF6;
        Tue,  5 Jul 2022 11:24:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0597C341C7;
        Tue,  5 Jul 2022 11:24:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657020297;
        bh=3LS7NP9802fYkg8HRQJ51yyKgN0uHeE9jliLF0YiGGk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RTwDG0o3ZrwGG/2CBVCXKN4bqqXuozeJsZtMsjta91M4NFUSio4d0IsliSn+JDf9l
         UVEJaRPl26gPbhxKmVcUTntJx2QgTZnE8XzSkoPDfb4hx7TwiGEY/dSHq93qgX7L31
         Qz60U1diZuPDlpLflhbeGTm6WlxU36K3liJmaT7jPaDJ1pg9gQklwTN82w6lX8T/kk
         dbJvicL/qa8wYC005+wYOeSwfCax8VylYNB+rtLgzN9N1oen5gIkE8TOgn2AA7j3iV
         Jf3WOE2sjOObLudXUW/JBZMUJIjexkopIzUBfJO5B5aKhnln9zxUTu3oOYcQMZ4Mtd
         eqp4lONiWidzQ==
Date:   Tue, 5 Jul 2022 12:24:49 +0100
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
Message-ID: <20220705112449.GA931@willie-the-truck>
References: <Yr7WTfd6AVTQkLjI@e126311.manchester.arm.com>
 <20220701200110.GA15144@breakpoint.cc>
 <YsAnPhPfWRjpkdmn@e126311.manchester.arm.com>
 <20220702205651.GB15144@breakpoint.cc>
 <YsKxTAaIgvKMfOoU@e126311.manchester.arm.com>
 <YsLGoU7q5hP67TJJ@e126311.manchester.arm.com>
 <YsQYIoJK3iqJ68Tq@e126311.manchester.arm.com>
 <20220705105749.GA711@willie-the-truck>
 <20220705110724.GB711@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220705110724.GB711@willie-the-truck>
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

On Tue, Jul 05, 2022 at 12:07:25PM +0100, Will Deacon wrote:
> On Tue, Jul 05, 2022 at 11:57:49AM +0100, Will Deacon wrote:
> > On Tue, Jul 05, 2022 at 11:53:22AM +0100, Kajetan Puchalski wrote:
> > > On Mon, Jul 04, 2022 at 10:22:24AM +0100, Kajetan Puchalski wrote:
> > > > On Sat, Jul 02, 2022 at 10:56:51PM +0200, Florian Westphal wrote:
> > > > > > That would make sense, from further experiments I ran it somehow seems
> > > > > > to be related to the number of workers being spawned by stress-ng along
> > > > > > with the CPUs/cores involved.
> > > > > >
> > > > > > For instance, running the test with <=25 workers (--udp-flood 25 etc.)
> > > > > > results in the test running fine for at least 15 minutes.
> > > > > 
> > > > > Ok.  I will let it run for longer on the machines I have access to.
> > > > > 
> > > > > In mean time, you could test attached patch, its simple s/refcount_/atomic_/
> > > > > in nf_conntrack.
> > > > > 
> > > > > If mainline (patch vs. HEAD 69cb6c6556ad89620547318439) crashes for you
> > > > > but works with attached patch someone who understands aarch64 memory ordering
> > > > > would have to look more closely at refcount_XXX functions to see where they
> > > > > might differ from atomic_ ones.
> > > > 
> > > > I can confirm that the patch seems to solve the issue.
> > > > With it applied on top of the 5.19-rc5 tag the test runs fine for at
> > > > least 15 minutes which was not the case before so it looks like it is
> > > > that aarch64 memory ordering problem.
> > > 
> > > I'm CCing some people who should be able to help with aarch64 memory
> > > ordering, maybe they could take a look.
> > > 
> > > (re-sending due to a typo in CC, sorry for duplicate emails!)
> > 
> > Sorry, but I have absolutely no context here. We have a handy document
> > describing the differences between atomic_t and refcount_t:
> > 
> > 	Documentation/core-api/refcount-vs-atomic.rst
> > 
> > What else do you need to know?
> 
> Hmm, and I see a tonne of *_inc_not_zero() conversions in 719774377622
> ("netfilter: conntrack: convert to refcount_t api") which mean that you
> no longer have ordering to subsequent reads in the absence of an address
> dependency.

I think the patch above needs auditing with the relaxed behaviour in mind,
but for the specific crash reported here possibly something like the diff
below?

Will

--->8

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 082a2fd8d85b..5ad9fcc84269 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1394,6 +1394,7 @@ static unsigned int early_drop_list(struct net *net,
                 * already fired or someone else deleted it. Just drop ref
                 * and move to next entry.
                 */
+               smp_rmb();      /* XXX: Why? */
                if (net_eq(nf_ct_net(tmp), net) &&
                    nf_ct_is_confirmed(tmp) &&
                    nf_ct_delete(tmp, 0, 0))

