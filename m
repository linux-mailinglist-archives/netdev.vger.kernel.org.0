Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE0CC444B3C
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 00:07:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229780AbhKCXKW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 19:10:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:56544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229561AbhKCXKV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Nov 2021 19:10:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E35B061108;
        Wed,  3 Nov 2021 23:07:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635980864;
        bh=ksVBAHxaotyoaSheG1DS+q0WjnPxmPNhpLsMd9Xw3qs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qNrfBTlRKmry4asedm/zMIlYDQiQskAQyiV34Ja1UQx4nSB2Yy+QcZdVATpIyLRJT
         2rEOQ5gt61mYnTQBSfoP/3cQfIMK+yGNxMb6qIZw5dd3uDU/lpxPLOVUrHDQyZ9K46
         DnULkVvvJs7U400vTRASjU9Y+RIQUk1TONsdKd0JO1UrvHPlWyW/yj2I7baflBKmXv
         WHWt7Wl3cmTK/Uci2Jvlrz3NZU0HLDLao5oha1ELkqIZ8dhz4RZg7SlnJkuGKD8bBk
         5Z2OD4WEFLmybOhfzEhIUWVfZ3GGvMBxrZqJKZyyE+/MrEcXBQ6f/QQ4djS5IQqhi6
         mThMIppguLRbw==
Date:   Wed, 3 Nov 2021 16:07:42 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Grygorii Strashko <grygorii.strashko@ti.com>
Cc:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        <linux-omap@vger.kernel.org>, Tony Lindgren <tony@atomide.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH net-next v2 2/3] net: ethernet: ti: am65-cpsw: enable
 bc/mc storm prevention support
Message-ID: <20211103160742.51218d7d@kicinski-fedora-PC1C0HJN>
In-Reply-To: <81a427a1-b969-4039-0c3f-567b3073abc1@ti.com>
References: <20211101170122.19160-1-grygorii.strashko@ti.com>
        <20211101170122.19160-3-grygorii.strashko@ti.com>
        <20211102173840.01f464ec@kicinski-fedora-PC1C0HJN>
        <81a427a1-b969-4039-0c3f-567b3073abc1@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 4 Nov 2021 00:20:30 +0200 Grygorii Strashko wrote:
> On 03/11/2021 02:38, Jakub Kicinski wrote:
> > On Mon, 1 Nov 2021 19:01:21 +0200 Grygorii Strashko wrote:  
> >>   - 01:00:00:00:00:00 fixed value has to be used for MC packets rate
> >>     limiting (exact match)  
> > 
> > This looks like a stretch, why not use a mask? You can require users to
> > always install both BC and MC rules if you want to make sure the masked
> > rule does not match BC.
> >   
> 
> Those matching rules are hard coded in HW for packet rate limiting and SW only
> enables them and sets requested pps limit.
> - 1:BC: HW does exact match on BC MAC address
> - 2:MC: HW does match on MC bit (the least-significant bit of the first octet)
> 
> Therefore the exact match done in this patch for above dst_mac's with
> is_broadcast_ether_addr() and ether_addr_equal().

Right but flower supports masked matches for dest address, as far as I
can tell. So you should check the mask is what you expect as well, not
just look at the key. Mask should be equal to key in your case IIUC, so:

	if (is_broadcast_ether_addr(match.key->dst) &&
	    is_broadcast_ether_addr(match.mask->dst))

and

	if (!memcmp(match.key->dst, mc_mac, ETH_ALEN) &&
	    !memcmp(match.mask->dst, mc_mac, ETH_ALEN))

I think you should also test that the mask, not the key of source addr
is zero.

Note that ether_addr_equal() assumes the mac address is alinged to 2,
which I'm not sure is the case here.

Also you can make mc_mac a static const.

> The K3 cpsw also supports number configurable policiers (bit rate limit) in
> ALE for which supports is to be added, and for them MC mask (sort of, it uses
> number of ignored bits, like FF-FF-FF-00-00-00) can be used.
