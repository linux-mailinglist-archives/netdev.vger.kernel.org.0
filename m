Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B2B83546D3
	for <lists+netdev@lfdr.de>; Mon,  5 Apr 2021 20:58:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235320AbhDES6m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 14:58:42 -0400
Received: from hs01.dk-develop.de ([173.249.23.66]:48088 "EHLO
        hs01.dk-develop.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234913AbhDES6i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Apr 2021 14:58:38 -0400
Date:   Mon, 5 Apr 2021 20:58:07 +0200
From:   Danilo Krummrich <danilokrummrich@dk-develop.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        davem@davemloft.net, hkallweit1@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, jeremy.linton@arm.com
Subject: Re: [PATCH 2/2] net: mdio: support c45 peripherals on c22 busses
Message-ID: <YGtdv++nv3H5K43E@arch-linux>
References: <20210331141755.126178-3-danilokrummrich@dk-develop.de>
 <YGSi+b/r4zlq9rm8@lunn.ch>
 <6f1dfc28368d098ace9564e53ed92041@dk-develop.de>
 <20210331183524.GV1463@shell.armlinux.org.uk>
 <2f0ea3c3076466e197ca2977753b07f3@dk-develop.de>
 <20210401084857.GW1463@shell.armlinux.org.uk>
 <YGZvGfNSBBq/92D+@arch-linux>
 <20210402125858.GB1463@shell.armlinux.org.uk>
 <YGoSS7llrl5K6D+/@arch-linux>
 <YGsRwxwXILC1Tp2S@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YGsRwxwXILC1Tp2S@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 05, 2021 at 03:33:55PM +0200, Andrew Lunn wrote:
> On Sun, Apr 04, 2021 at 09:23:55PM +0200, Danilo Krummrich wrote:
> > So currently every driver should check for the flag MII_ADDR_C45 and report an
> > error in case it's unsupported.
> > 
> > What do you think about checking the bus' capabilities instead in
> > mdiobus_c45_*()? This way the check if C45 is supported can even happen before
> > calling the driver at all. I think that would be a little cleaner than having
> > two places where information of the bus' capabilities are stored (return value
> > of read/write functions and the capabilities field).
> > 
> > I think there are not too many drivers setting their capabilities though, but
> > it should be easy to derive this information from how and if they handle the
> > MII_ADDR_C45 flag.
> 
> I actually don't think anything needs to change. The Marvell PHY
> probably probes due to its C22 IDs. The driver will then requests C45
> access which automagically get converted into C45 over C22 for your
> hardware, but remain C45 access for bus drivers which support C45.
> 
Thanks Andrew - I agree, for the Marvell PHY to work I likly don't need any
change, since I also expect that it will probe with the C22 IDs. I'll try
this soon.

However, this was about something else - Russell wrote:
> > > We have established that MDIO drivers need to reject accesses for
> > > reads/writes that they do not support [..]
The MDIO drivers do this by checking the MII_ADDR_C45 flag if it's a C45 bus
request. In case they don't support it they return -EOPNOTSUPP. So basically,
the bus drivers read/write functions (should) encode the capability of doing
C45 transfers.

I just noted that this is redundant to the bus' capabilities field of
struct mii_bus which also encodes the bus' capabilities of doing C22 and/or C45
transfers.

Now, instead of encoding this information of the bus' capabilities at both
places, I'd propose just checking the mii_bus->capabilities field in the
mdiobus_c45_*() functions. IMHO this would be a little cleaner, than having two
places where this information is stored. What do you think about that?
> 	  Andrew
