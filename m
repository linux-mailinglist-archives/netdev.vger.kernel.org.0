Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 811D8356D42
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 15:26:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241600AbhDGN0i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 09:26:38 -0400
Received: from hs01.dk-develop.de ([173.249.23.66]:56120 "EHLO
        hs01.dk-develop.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236579AbhDGN0h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Apr 2021 09:26:37 -0400
Date:   Wed, 7 Apr 2021 15:26:10 +0200
From:   Danilo Krummrich <danilokrummrich@dk-develop.de>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>, davem@davemloft.net,
        hkallweit1@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, jeremy.linton@arm.com
Subject: Re: [PATCH 2/2] net: mdio: support c45 peripherals on c22 busses
Message-ID: <YG2y8j6nXW7ODcou@arch-linux>
References: <6f1dfc28368d098ace9564e53ed92041@dk-develop.de>
 <20210331183524.GV1463@shell.armlinux.org.uk>
 <2f0ea3c3076466e197ca2977753b07f3@dk-develop.de>
 <20210401084857.GW1463@shell.armlinux.org.uk>
 <YGZvGfNSBBq/92D+@arch-linux>
 <20210402125858.GB1463@shell.armlinux.org.uk>
 <YGoSS7llrl5K6D+/@arch-linux>
 <YGsRwxwXILC1Tp2S@lunn.ch>
 <YGtdv++nv3H5K43E@arch-linux>
 <20210405211236.GD1463@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210405211236.GD1463@shell.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I somehow missed this mail..

On Mon, Apr 05, 2021 at 10:12:36PM +0100, Russell King - ARM Linux admin wrote:
> On Mon, Apr 05, 2021 at 08:58:07PM +0200, Danilo Krummrich wrote:
> > On Mon, Apr 05, 2021 at 03:33:55PM +0200, Andrew Lunn wrote:
> > However, this was about something else - Russell wrote:
> > > > > We have established that MDIO drivers need to reject accesses for
> > > > > reads/writes that they do not support [..]
> > The MDIO drivers do this by checking the MII_ADDR_C45 flag if it's a C45 bus
> > request. In case they don't support it they return -EOPNOTSUPP. So basically,
> > the bus drivers read/write functions (should) encode the capability of doing
> > C45 transfers.
> > 
> > I just noted that this is redundant to the bus' capabilities field of
> > struct mii_bus which also encodes the bus' capabilities of doing C22 and/or C45
> > transfers.
> > 
> > Now, instead of encoding this information of the bus' capabilities at both
> > places, I'd propose just checking the mii_bus->capabilities field in the
> > mdiobus_c45_*() functions. IMHO this would be a little cleaner, than having two
> > places where this information is stored. What do you think about that?
> 
> It would be good to clean that up, but that's a lot of work given the
> number of drivers - not only in terms of making the changes but also
> making sure that the changes are as correct as would be sensibly
> achievable... then there's the problem of causing regressions by doing
> so.
> 
As mentioned in the answer to Andrew, I think it wouldn't be too many as we'd
only need to look for the ones considering MII_ADDR_C45 at all.
> The two ways were introduced at different times to do two different
> things: the checking in the read/write methods in each driver was the
> first method, which was being added to newer drivers. Then more
> recently came the ->capabilities field.
> 
> So now we have some drivers that:
> - do no checks and don't fill in ->capabilities either (some of which
>   are likely C22-only.)
Guess they could be left untouched completely and simply go for MDIOBUS_NO_CAP
implicitly and therefore C45 requests would be correctly rejected by
mdiobus_c45_*() functions. I think this would be the main advantage apart from
making it more clean.
> - check in their read/write methods for access types they don't support
>   (e.g. drivers/net/ethernet/marvell/mvmdio.c) and don't fill in
>   ->capabilities. Note, mvmdio supports both C22-only and C45-only
>   interfaces with no C22-and-C45 interfaces.
Yes, I think the correct capability could still be easily assigned per instance
within the probe() function:
	switch (type) {
	case BUS_TYPE_SMI:
		bus->capabilities = MDIOBUS_C22;
		[...]
		break;
	case BUS_TYPE_XSMI:
		bus->capabilities = MDIOBUS_C45;
		[...]
		break;
	}
> - do fill in ->capabilities with MDIOBUS_C22_C45 (and hence have no
>   checks in their read/write functions).
> 
Nothing to be done for them.
> Sometimes, its best to leave stuff alone... if it ain't broke, don't
> make regressions.
> 
Yes, I can perfectly understand that.

However, maybe I go for a patch anyways, and if so I will also send it. If it's
taken by you in the end is on another piece of paper.

Thanks again!

Danilo

> -- 
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
