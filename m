Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CD3E5668CD
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 12:59:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233089AbiGEK67 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 06:58:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229718AbiGEK6A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 06:58:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 456B43BC;
        Tue,  5 Jul 2022 03:57:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EE1FCB817A9;
        Tue,  5 Jul 2022 10:57:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32422C341C7;
        Tue,  5 Jul 2022 10:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657018676;
        bh=6p53rkYHdVLZl9lYsEKs8jgyKZZ0Db786dF8PxFtvgU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MoxZvKexk8ZixDALaCF90CcCD6feW2SxVDZ6Qri0Lk2w05uev5QLutZvNQd8tJ15F
         6TVaz8CUS5H2QCC77H6X3P9e5ghmui6ghiJiQ2W5NPc/WaHYTQXXLBzE1ii75D6Rp9
         1Y+puj7XWBvcB0Zzw9LuTOgpLLcrnVEjaEjc5HK7OGtGRlx+EwNOFwzS5N+5bwLsWp
         QOhPNPV3XtjclhHxBSKK0dcQvMpnkt8BakkCCOMexfqr1eS3VJDB0uz7bqSK66P5HX
         gETuM8NZX8OcyOv8MDTP0PZeJHXICOnJrmBTdEkzufastunsA/GpDkFITobYQVc95v
         F8Oik4Qr+XPlA==
Date:   Tue, 5 Jul 2022 11:57:49 +0100
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
Message-ID: <20220705105749.GA711@willie-the-truck>
References: <Yr7WTfd6AVTQkLjI@e126311.manchester.arm.com>
 <20220701200110.GA15144@breakpoint.cc>
 <YsAnPhPfWRjpkdmn@e126311.manchester.arm.com>
 <20220702205651.GB15144@breakpoint.cc>
 <YsKxTAaIgvKMfOoU@e126311.manchester.arm.com>
 <YsLGoU7q5hP67TJJ@e126311.manchester.arm.com>
 <YsQYIoJK3iqJ68Tq@e126311.manchester.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YsQYIoJK3iqJ68Tq@e126311.manchester.arm.com>
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

On Tue, Jul 05, 2022 at 11:53:22AM +0100, Kajetan Puchalski wrote:
> On Mon, Jul 04, 2022 at 10:22:24AM +0100, Kajetan Puchalski wrote:
> > On Sat, Jul 02, 2022 at 10:56:51PM +0200, Florian Westphal wrote:
> > > > That would make sense, from further experiments I ran it somehow seems
> > > > to be related to the number of workers being spawned by stress-ng along
> > > > with the CPUs/cores involved.
> > > >
> > > > For instance, running the test with <=25 workers (--udp-flood 25 etc.)
> > > > results in the test running fine for at least 15 minutes.
> > > 
> > > Ok.  I will let it run for longer on the machines I have access to.
> > > 
> > > In mean time, you could test attached patch, its simple s/refcount_/atomic_/
> > > in nf_conntrack.
> > > 
> > > If mainline (patch vs. HEAD 69cb6c6556ad89620547318439) crashes for you
> > > but works with attached patch someone who understands aarch64 memory ordering
> > > would have to look more closely at refcount_XXX functions to see where they
> > > might differ from atomic_ ones.
> > 
> > I can confirm that the patch seems to solve the issue.
> > With it applied on top of the 5.19-rc5 tag the test runs fine for at
> > least 15 minutes which was not the case before so it looks like it is
> > that aarch64 memory ordering problem.
> 
> I'm CCing some people who should be able to help with aarch64 memory
> ordering, maybe they could take a look.
> 
> (re-sending due to a typo in CC, sorry for duplicate emails!)

Sorry, but I have absolutely no context here. We have a handy document
describing the differences between atomic_t and refcount_t:

	Documentation/core-api/refcount-vs-atomic.rst

What else do you need to know?

Will
