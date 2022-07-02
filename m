Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 785FB563FB6
	for <lists+netdev@lfdr.de>; Sat,  2 Jul 2022 13:10:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232532AbiGBLKI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Jul 2022 07:10:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232506AbiGBLJw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Jul 2022 07:09:52 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 78A1E165AC;
        Sat,  2 Jul 2022 04:09:06 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 765DC23A;
        Sat,  2 Jul 2022 04:08:57 -0700 (PDT)
Received: from e126311.manchester.arm.com (unknown [10.57.71.6])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7524E3F66F;
        Sat,  2 Jul 2022 04:08:53 -0700 (PDT)
Date:   Sat, 2 Jul 2022 12:08:46 +0100
From:   Kajetan Puchalski <kajetan.puchalski@arm.com>
To:     Florian Westphal <fw@strlen.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
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
Message-ID: <YsAnPhPfWRjpkdmn@e126311.manchester.arm.com>
References: <Yr7WTfd6AVTQkLjI@e126311.manchester.arm.com>
 <20220701200110.GA15144@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220701200110.GA15144@breakpoint.cc>
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 01, 2022 at 10:01:10PM +0200, Florian Westphal wrote:
> Kajetan Puchalski <kajetan.puchalski@arm.com> wrote:
> > While running the udp-flood test from stress-ng on Ampere Altra (Mt.
> > Jade platform) I encountered a kernel panic caused by NULL pointer
> > dereference within nf_conntrack.
> > 
> > The issue is present in the latest mainline (5.19-rc4), latest stable
> > (5.18.8), as well as multiple older stable versions. The last working
> > stable version I found was 5.15.40.
> 
> Do I need a special setup for conntrack?

I don't think there was any special setup involved, the config I started
from was a generic distribution config and I didn't change any
networking-specific options. In case that's helpful here's the .config I
used.

https://pastebin.com/Bb2wttdx

> 
> No crashes after more than one hour of stress-ng on
> 1. 4 core amd64 Fedora 5.17 kernel
> 2. 16 core amd64, linux stable 5.17.15
> 3. 12 core intel, Fedora 5.18 kernel
> 4. 3 core aarch64 vm, 5.18.7-200.fc36.aarch64
> 

That would make sense, from further experiments I ran it somehow seems
to be related to the number of workers being spawned by stress-ng along
with the CPUs/cores involved.

For instance, running the test with <=25 workers (--udp-flood 25 etc.)
results in the test running fine for at least 15 minutes.
Running the test with 30 workers results in a panic sometime before it
hits the 15 minute mark.
Based on observations there seems to be a corellation between the number
of workers and how quickly the panic occurs, ie with 30 it takes a few
minutes, with 160 it consistently happens almost immediately. That also
holds for various numbers of workers in between.

On the CPU/core side of things, the machine in question has two CPU
sockets with 80 identical cores each. All the panics I've encountered
happened when stress-ng was ran directly and unbound.
When I tried using hwloc-bind to bind the process to one of the CPU
sockets, the test ran for 15 mins with 80 and 160 workers with no issues,
no matter which CPU it was bound to.

Ie the specific circumstances under which it seems to occur are when the
test is able to run across multiple CPU sockets with a large number
of workers being spawned.

> I used standard firewalld ruleset for all of these and manually tuned
> conntrack settings to make sure the early evict path (as per backtrace)
> gets exercised.
