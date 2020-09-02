Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E5D925AE2A
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 17:00:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727815AbgIBNtX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 09:49:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726979AbgIBNrr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 09:47:47 -0400
Received: from caffeine.csclub.uwaterloo.ca (caffeine.csclub.uwaterloo.ca [IPv6:2620:101:f000:4901:c5c:0:caff:e12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AFF7C061245;
        Wed,  2 Sep 2020 06:47:42 -0700 (PDT)
Received: by caffeine.csclub.uwaterloo.ca (Postfix, from userid 20367)
        id E12B2460FF9; Wed,  2 Sep 2020 09:47:34 -0400 (EDT)
Date:   Wed, 2 Sep 2020 09:47:34 -0400
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org
Subject: Re: [Intel-wired-lan] VRRP not working on i40e X722 S2600WFT
Message-ID: <20200902134734.fvtyn5tbhpyssrbq@csclub.uwaterloo.ca>
References: <20200827183039.hrfnb63cxq3pmv4z@csclub.uwaterloo.ca>
 <20200828155616.3sd2ivrml2gpcvod@csclub.uwaterloo.ca>
 <20200831103512.00001fab@intel.com>
 <20200901013519.rfmavd4763gdzw4r@csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200901013519.rfmavd4763gdzw4r@csclub.uwaterloo.ca>
User-Agent: NeoMutt/20170113 (1.7.2)
From:   lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 31, 2020 at 09:35:19PM -0400,  wrote:
> On Mon, Aug 31, 2020 at 10:35:12AM -0700, Jesse Brandeburg wrote:
> > Thanks for the report Lennart, I understand your frustration, as this
> > should probably work without user configuration.
> > 
> > However, please give this command a try:
> > ethtool --set-priv-flags ethX disable-source-pruning on
> 
> Hmm, our 4.9 kernel is just a touch too old to support that.  And yes
> that really should not require a flag to be set, given the card has no
> reason to ever do that pruning.  There is no justification you could
> have for doing it in the first place.

So backporting the patch that enabled that flag does allow it to work.
Of course there isn't a particularly good place to put an ethtool command
in the boot up to make sure it runs before vrrp is started.  This has to
be the default. I know I wasted about a week trying things to get this to
work, and clearly lots of other people have wasted a ton of time on this
"feature" too (calling it a feature is clearly wrong, it is a bug).

By default the NIC should work as expected.  Any weird questionable
optimizations have to be turned on by the user explicitly when they
understand the consequences.  I can't find any use case documented
anywhere for this bug, I can only find things it has broken (like
apparently arp monitoring on bonding, and vrrp).

So who should make the patch to change this to be the default?  Clearly
the current behaviour is harming and confusing more people than could
possibly be impacted by changing the current default setting for the flag
(in fact I would just about be willing to bet there are no people that
want the current behaviour.  After all no other NIC does this, so clearly
there is no need for it to be done).

-- 
Len Sorensen
