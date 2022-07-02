Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76EED563FFB
	for <lists+netdev@lfdr.de>; Sat,  2 Jul 2022 13:58:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232187AbiGBLzZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Jul 2022 07:55:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229668AbiGBLzY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Jul 2022 07:55:24 -0400
Received: from 1wt.eu (wtarreau.pck.nerim.net [62.212.114.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0609A13EA2;
        Sat,  2 Jul 2022 04:55:22 -0700 (PDT)
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 262BskFx025867;
        Sat, 2 Jul 2022 13:54:46 +0200
Date:   Sat, 2 Jul 2022 13:54:46 +0200
From:   Willy Tarreau <w@1wt.eu>
To:     Kajetan Puchalski <kajetan.puchalski@arm.com>
Cc:     Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Mel Gorman <mgorman@suse.de>,
        lukasz.luba@arm.com, dietmar.eggemann@arm.com,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, stable@vger.kernel.org,
        regressions@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [Regression] stress-ng udp-flood causes kernel panic on Ampere
 Altra
Message-ID: <20220702115446.GA25840@1wt.eu>
References: <Yr7WTfd6AVTQkLjI@e126311.manchester.arm.com>
 <20220701200110.GA15144@breakpoint.cc>
 <YsAnPhPfWRjpkdmn@e126311.manchester.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YsAnPhPfWRjpkdmn@e126311.manchester.arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 02, 2022 at 12:08:46PM +0100, Kajetan Puchalski wrote:
> On Fri, Jul 01, 2022 at 10:01:10PM +0200, Florian Westphal wrote:
> > Kajetan Puchalski <kajetan.puchalski@arm.com> wrote:
> > > While running the udp-flood test from stress-ng on Ampere Altra (Mt.
> > > Jade platform) I encountered a kernel panic caused by NULL pointer
> > > dereference within nf_conntrack.
> > > 
> > > The issue is present in the latest mainline (5.19-rc4), latest stable
> > > (5.18.8), as well as multiple older stable versions. The last working
> > > stable version I found was 5.15.40.
> > 
> > Do I need a special setup for conntrack?
> 
> I don't think there was any special setup involved, the config I started
> from was a generic distribution config and I didn't change any
> networking-specific options. In case that's helpful here's the .config I
> used.
> 
> https://pastebin.com/Bb2wttdx
> 
> > 
> > No crashes after more than one hour of stress-ng on
> > 1. 4 core amd64 Fedora 5.17 kernel
> > 2. 16 core amd64, linux stable 5.17.15
> > 3. 12 core intel, Fedora 5.18 kernel
> > 4. 3 core aarch64 vm, 5.18.7-200.fc36.aarch64
> > 
> 
> That would make sense, from further experiments I ran it somehow seems
> to be related to the number of workers being spawned by stress-ng along
> with the CPUs/cores involved.
> 
> For instance, running the test with <=25 workers (--udp-flood 25 etc.)
> results in the test running fine for at least 15 minutes.

Another point to keep in mind is that modern ARM processors (ARMv8.1 and
above) have a more relaxed memory model than older ones (and x86), that
can easily exhibit a missing barrier somewhere. I faced this situation
already in the past the first time I ran my code on Graviton2, which
caused crashes that would never happen on A53/A72/A73 cores nor x86.

ARMv8.1 SoCs are not yet widely available for end users like us. A76
is only coming, and A55 has now been available for a bit more than a
year. So testing on regular ARM devices like RPi etc may not exhibit
such differences.

> Running the test with 30 workers results in a panic sometime before it
> hits the 15 minute mark.
> Based on observations there seems to be a corellation between the number
> of workers and how quickly the panic occurs, ie with 30 it takes a few
> minutes, with 160 it consistently happens almost immediately. That also
> holds for various numbers of workers in between.
> 
> On the CPU/core side of things, the machine in question has two CPU
> sockets with 80 identical cores each. All the panics I've encountered
> happened when stress-ng was ran directly and unbound.
> When I tried using hwloc-bind to bind the process to one of the CPU
> sockets, the test ran for 15 mins with 80 and 160 workers with no issues,
> no matter which CPU it was bound to.
> 
> Ie the specific circumstances under which it seems to occur are when the
> test is able to run across multiple CPU sockets with a large number
> of workers being spawned.

This could further fuel the possibliity explained above.

Regards,
Willy
