Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11DCD649FF
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 17:46:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728298AbfGJPqM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 11:46:12 -0400
Received: from smtprelay0051.hostedemail.com ([216.40.44.51]:58243 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725832AbfGJPqL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 11:46:11 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay05.hostedemail.com (Postfix) with ESMTP id C502F1802912E;
        Wed, 10 Jul 2019 15:46:09 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::::::::::::::::::::,RULES_HIT:41:355:379:599:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2553:2559:2562:2692:2731:2828:2917:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:4250:4321:5007:6691:6742:7875:7904:10004:10400:10848:11026:11232:11473:11658:11914:12296:12297:12740:12760:12895:13069:13311:13357:13439:14096:14097:14659:21080:21220:21326:21451:21627:30012:30034:30054:30056:30090:30091,0,RBL:23.242.196.136:@perches.com:.lbl8.mailshell.net-62.14.0.180 64.201.201.201,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:neutral,Custom_rules:0:0:0,LFtime:25,LUA_SUMMARY:none
X-HE-Tag: range96_50d7d845d712e
X-Filterd-Recvd-Size: 3121
Received: from XPS-9350 (cpe-23-242-196-136.socal.res.rr.com [23.242.196.136])
        (Authenticated sender: joe@perches.com)
        by omf13.hostedemail.com (Postfix) with ESMTPA;
        Wed, 10 Jul 2019 15:45:54 +0000 (UTC)
Message-ID: <b9c3b83c9be50286062ae8cefd5d38e2baa0fb22.camel@perches.com>
Subject: Re: [PATCH 00/12] treewide: Fix GENMASK misuses
From:   Joe Perches <joe@perches.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Johannes Berg <johannes@sipsolutions.net>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Patrick Venture <venture@google.com>,
        Nancy Yuen <yuenn@google.com>,
        Benjamin Fair <benjaminfair@google.com>,
        Andrew Jeffery <andrew@aj.id.au>, openbmc@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-aspeed@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org, netdev@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-wireless@vger.kernel.org, linux-media@vger.kernel.org,
        linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        alsa-devel@alsa-project.org, linux-mmc@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Date:   Wed, 10 Jul 2019 08:45:53 -0700
In-Reply-To: <20190710094337.wf2lftxzfjq2etro@shell.armlinux.org.uk>
References: <cover.1562734889.git.joe@perches.com>
         <5fa1fa6998332642c49e2d5209193ffe2713f333.camel@sipsolutions.net>
         <20190710094337.wf2lftxzfjq2etro@shell.armlinux.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.30.5-0ubuntu0.18.10.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2019-07-10 at 10:43 +0100, Russell King - ARM Linux admin wrote:
> On Wed, Jul 10, 2019 at 11:17:31AM +0200, Johannes Berg wrote:
> > On Tue, 2019-07-09 at 22:04 -0700, Joe Perches wrote:
> > > These GENMASK uses are inverted argument order and the
> > > actual masks produced are incorrect.  Fix them.
> > > 
> > > Add checkpatch tests to help avoid more misuses too.
> > > 
> > > Joe Perches (12):
> > >   checkpatch: Add GENMASK tests
> > 
> > IMHO this doesn't make a lot of sense as a checkpatch test - just throw
> > in a BUILD_BUG_ON()?

I tried that.

It'd can't be done as it's used in declarations
and included in asm files and it uses the UL()
macro.

I also tried just making it do the right thing
whatever the argument order.

Oh well.

> My personal take on this is that GENMASK() is really not useful, it's
> just pure obfuscation and leads to exactly these kinds of mistakes.
> 
> Yes, I fully understand the argument that you can just specify the
> start and end bits, and it _in theory_ makes the code more readable.
> 
> However, the problem is when writing code.  GENMASK(a, b).  Is a the
> starting bit or ending bit?  Is b the number of bits?  It's confusing
> and causes mistakes resulting in incorrect code.  A BUILD_BUG_ON()
> can catch some of the cases, but not all of them.

It's a horrid little macro and I agree with Russell.

I also think if it existed at all it should have been
GENMASK(low, high) not GENMASK(high, low).

I

