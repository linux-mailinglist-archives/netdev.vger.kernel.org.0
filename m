Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83381353977
	for <lists+netdev@lfdr.de>; Sun,  4 Apr 2021 21:24:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231407AbhDDTYL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Apr 2021 15:24:11 -0400
Received: from hs01.dk-develop.de ([173.249.23.66]:46914 "EHLO
        hs01.dk-develop.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231284AbhDDTYJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Apr 2021 15:24:09 -0400
Date:   Sun, 4 Apr 2021 21:23:55 +0200
From:   Danilo Krummrich <danilokrummrich@dk-develop.de>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>, davem@davemloft.net,
        hkallweit1@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, jeremy.linton@arm.com
Subject: Re: [PATCH 2/2] net: mdio: support c45 peripherals on c22 busses
Message-ID: <YGoSS7llrl5K6D+/@arch-linux>
References: <20210331141755.126178-1-danilokrummrich@dk-develop.de>
 <20210331141755.126178-3-danilokrummrich@dk-develop.de>
 <YGSi+b/r4zlq9rm8@lunn.ch>
 <6f1dfc28368d098ace9564e53ed92041@dk-develop.de>
 <20210331183524.GV1463@shell.armlinux.org.uk>
 <2f0ea3c3076466e197ca2977753b07f3@dk-develop.de>
 <20210401084857.GW1463@shell.armlinux.org.uk>
 <YGZvGfNSBBq/92D+@arch-linux>
 <20210402125858.GB1463@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210402125858.GB1463@shell.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 02, 2021 at 01:58:58PM +0100, Russell King - ARM Linux admin wrote:
> On Fri, Apr 02, 2021 at 03:10:49AM +0200, Danilo Krummrich wrote:
> > On Thu, Apr 01, 2021 at 09:48:58AM +0100, Russell King - ARM Linux admin wrote:
> > > One could also argue this is a feature, and it allows userspace to
> > > know whether C45 cycles are supported or not.
> > >
> > No, if the userspace requests such a transfer although the MDIO controller
> > does not support real c45 framing the kernel will call mdiobus_c45_addr() to
> > join the devaddr and  and regaddr in one parameter and pass it to
> > mdiobus_read() or mdiobus_write(). A bus driver not supporting c45 framing
> > will not care and just mask/shift the joined value and write it to the
> > particular register. Obviously, this will result into complete garbage being
> > read or (even worse) written.
> 
> 
> We have established that MDIO drivers need to reject accesses for
> reads/writes that they do not support - this isn't something that
> they have historically checked for because it is only recent that
> phylib has really started to support clause 45 PHYs.
> 
I see, that's why you consider it a feature - because it is.
What do you think about adding a flag MDIO_PHY_ID_MMD (or similar) analog to
MDIO_PHY_ID_C45 for phy_mii_ioctl() to check for, such that userspace can ask
for an indirect access in order to save userspace doing the indirect access
itself. A nice side effect would be saving 3 syscalls per request.
> More modern MDIO drivers check the requested access type and error
> out - we need the older MDIO drivers to do the same.
> 
So currently every driver should check for the flag MII_ADDR_C45 and report an
error in case it's unsupported.

What do you think about checking the bus' capabilities instead in
mdiobus_c45_*()? This way the check if C45 is supported can even happen before
calling the driver at all. I think that would be a little cleaner than having
two places where information of the bus' capabilities are stored (return value
of read/write functions and the capabilities field).

I think there are not too many drivers setting their capabilities though, but
it should be easy to derive this information from how and if they handle the
MII_ADDR_C45 flag.
