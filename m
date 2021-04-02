Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECE243524F3
	for <lists+netdev@lfdr.de>; Fri,  2 Apr 2021 03:10:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234170AbhDBBKw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 21:10:52 -0400
Received: from hs01.dk-develop.de ([173.249.23.66]:33516 "EHLO
        hs01.dk-develop.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231179AbhDBBKw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Apr 2021 21:10:52 -0400
Date:   Fri, 2 Apr 2021 03:10:49 +0200
From:   Danilo Krummrich <danilokrummrich@dk-develop.de>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>, davem@davemloft.net,
        hkallweit1@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, jeremy.linton@arm.com
Subject: Re: [PATCH 2/2] net: mdio: support c45 peripherals on c22 busses
Message-ID: <YGZvGfNSBBq/92D+@arch-linux>
References: <20210331141755.126178-1-danilokrummrich@dk-develop.de>
 <20210331141755.126178-3-danilokrummrich@dk-develop.de>
 <YGSi+b/r4zlq9rm8@lunn.ch>
 <6f1dfc28368d098ace9564e53ed92041@dk-develop.de>
 <20210331183524.GV1463@shell.armlinux.org.uk>
 <2f0ea3c3076466e197ca2977753b07f3@dk-develop.de>
 <20210401084857.GW1463@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210401084857.GW1463@shell.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 01, 2021 at 09:48:58AM +0100, Russell King - ARM Linux admin wrote:
> On Thu, Apr 01, 2021 at 03:23:05AM +0200, danilokrummrich@dk-develop.de wrote:
> > On 2021-03-31 20:35, Russell King - ARM Linux admin wrote:
> > > On Wed, Mar 31, 2021 at 07:58:33PM +0200, danilokrummrich@dk-develop.de
> > > wrote:
> > > > For this cited change the only thing happening is that if
> > > > get_phy_device()
> > > > already failed for probing with is_c45==false (C22 devices) it tries
> > > > to
> > > > probe with is_c45==true (C45 devices) which then either results into
> > > > actual
> > > > C45 frame transfers or indirect accesses by calling mdiobus_c45_*()
> > > > functions.
> > >
> > > Please explain why and how a PHY may not appear to be present using
> > > C22 frames to read the ID registers, but does appear to be present
> > > when using C22 frames to the C45 indirect registers - and summarise
> > > which PHYs have this behaviour.
> > >
> > > It seems very odd that any PHY would only implement C45 indirect
> > > registers in the C22 register space.
> >
> > Honestly, I can't list examples of that case (at least none that have an
> > upstream driver already). This part of my patch, to fall back to c45 bus
> > probing when c22 probing does not succeed, is also motivated by the fact
> > that this behaviour was already introduced with this patch:
>
> So, if I understand what you've just said, you want to make a change to
> the kernel to add support for something that you don't need and don't
> know that there's any hardware that needs it.  Is that correct?
>
No, not at all. As I explained this part of the patch in mdiobus_scan() I did
based on the patch of Jeremy only. It was an indicator for me that there might
be c45 PHYs that don't respond to c22 requests. I interpreted his commit
message in a way that those c45 PHYs are capable of processing c22 requests in
general but implement the indirect registers only, since he said "its possible
that a c45 device doesn't respond despite being a standard phy".

You said that this behaviour would be very odd and I agree. Now, likely I just
misinterpreted this and Jeremy actually tells that the PHYs he's referring to
don't support c22 access at all. In this case we can for sure just forget
about the changes in mdiobus_scan() of this patch. I'll remove them.

Again, just to sort this out, this part of the patch is not it's main purpose.
However, since I implemented the fallback to indirect accesses anyways I
thought it doesn't hurt to consider the case that a PHY implements indirect
access registers only. Anyways, I admit that this is likely pointless and as
said, I'll remove it from the patch.
> > commit 0cc8fecf041d3e5285380da62cc6662bdc942d8c
> > Author: Jeremy Linton <jeremy.linton@arm.com>
> > Date:   Mon Jun 22 20:35:32 2020 +0530
> >
> >     net: phy: Allow mdio buses to auto-probe c45 devices
> >
> >     The mdiobus_scan logic is currently hardcoded to only
> >     work with c22 devices. This works fairly well in most
> >     cases, but its possible that a c45 device doesn't respond
> >     despite being a standard phy. If the parent hardware
> >     is capable, it makes sense to scan for c22 devices before
> >     falling back to c45.
> >
> >     As we want this to reflect the capabilities of the STA,
> >     lets add a field to the mii_bus structure to represent
> >     the capability. That way devices can opt into the extended
> >     scanning. Existing users should continue to default to c22
> >     only scanning as long as they are zero'ing the structure
> >     before use.
> >
> >     Signed-off-by: Jeremy Linton <jeremy.linton@arm.com>
> >     Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
> >     Signed-off-by: David S. Miller <davem@davemloft.net>
> >
> > In this patch i.a. the following lines were added.
> >
> > +       case MDIOBUS_C22_C45:
> > +               phydev = get_phy_device(bus, addr, false);
> > +               if (IS_ERR(phydev))
> > +                       phydev = get_phy_device(bus, addr, true);
> > +               break;
> >
> > I'm applying the same logic for MDIOBUS_NO_CAP and MDIOBUS_C22, since
> > with my patch MDIO controllers with those capabilities can handle c45 bus
> > probing with indirect accesses.
>
> If the PHY doesn't respond to C22 accesses but is a C45 PHY, then how
> can this work (you seem to have essentially said it doesn't above.)
>
As stated above likely I wrongly interpreted his commit message as if only the
indirect registers are implemented.
> > [By the way, I'm unsure if this order for MDIO bus controllers with the
> > capability MDIOBUS_C22_C45 makes sense, because if we assume that the
> > majority of c45 PHYs responds well to c22 probing (which I'm convinced of)
>
> There are some which don't - Clause 45 allows PHYs not to implement
> support for Clause 22 accesses.
>
Yes, I agree.
> > the PHY would still be registered as is_c45==false, which results in the
> > fact
> > that even though the underlying bus is capable of real c45 framing only
> > indirect accessing would be performed. But this is another topic and
> > unrelated to the patch.]
>
> We make no distinction between IDs found via Clause 22 probing and IDs
> found via Clause 45 probing; the PHY driver will match either way. We
> don't know of any cases where the IDs are different between these two.
> So we still end up with the same driver being matched.
>
True, I don't say that it doesn't work or the driver is not matched. I just
say that if the c45 capable PHY is already matched with c22 probing (which is
performed first) the struct phy_device is created with is_c45=false. Hence,
phy_*_mmd() functions will perform an indirect access, although a direct
c45 access would be possible, which is less efficient. Admittedly, this is
pretty minor.
> Also note that there are MDIO controllers that support clause 22 and
> clause 45, but which require clause 22 to be probed first. Not
> everything is MDIO at the bus level anymore - there's PHYs that support
> I2C, and the I2C format of a clause 45 read is identical to a clause 22
> write.
>
> > In the case a PHY is registered as a c45 compatible PHY in the device tree,
> > it is probed in c45 mode and therefore finally  mdiobus_c45_read() is
> > called,
> > which as by now just expects the underlying MDIO bus controller to be
> > capable
> > to do c45 framing and therefore the operation would fail in case it is not.
> > Hence, in my opinion it is useful to fall back to indirect accesses in such
> > a
> > case to be able to support those PHYs.
>
> Do you actually have a requirement for this?
>
Yes, the Marvell 88Q2112 1000Base-T1 PHY. But actually, I just recognize that it
should be possible to just register it with the compatible string
"ethernet-phy-ieee802.3-c22" instead of "ethernet-phy-ieee802.3-c45", this
should result in probing it as c22 PHY and doing indirect accesses through
phy_*_mmd().

> > There is a similar issue in phy_mii_ioctl(). Let's assume a c45 capable PHY
> > is
> > connected to a MDIO bus controller that is not capable of c45 framing. We
> > can
> > also assume that it was probed with c22 bus probing, since without this
> > patch
> > nothing else is possible.
> > Now, there might be an ioctl() asking for a c45 transfer by specifying
> > MDIO_PHY_ID_C45_MASK e.g. in order to access a different MMD's register,
> > since the PHY is actually capable of c45. Currently, this would result in
> >
> > devad = mdiobus_c45_addr(devad, mii_data->reg_num);
> > mii_data->val_out = mdiobus_read(phydev->mdio.bus, prtad, devad);
> >
> > calls, which would fail, since the bus doesn't support it. Instead falling
> > back
> > to indirect access might be the better option. Surely, the userspace program
> > could implement the indirect access as well, but I think this way it's just
> > more
> > convenient, e.g. "phytool read iface/addr:devad/reg".
>
> One could also argue this is a feature, and it allows userspace to
> know whether C45 cycles are supported or not.
>
No, if the userspace requests such a transfer although the MDIO controller
does not support real c45 framing the kernel will call mdiobus_c45_addr() to
join the devaddr and  and regaddr in one parameter and pass it to
mdiobus_read() or mdiobus_write(). A bus driver not supporting c45 framing
will not care and just mask/shift the joined value and write it to the
particular register. Obviously, this will result into complete garbage being
read or (even worse) written.

Now, to fix this up we can either check for the bus capabilities in
phy_mii_ioctl(), or even better in the mdiobus_c45_*() functions, and return
a proper error code in case the bus is not capable to do real c45 framing or
we can fall back to indirect accesses, as my patch does. I'd still prefer to
fall back to an indirect access in this case.

What do you prefer?
> In summary, I think you need to show us that you have a real world
> use case for these changes - in other words, a real world PHY setup
> that doesn't work today.
>
My concrete setup would have been the PHY I mentioned above, but if I'm right
with my assumption that I can just use "ethernet-phy-ieee802.3-c22" for it,
I don't have a concreate setup anymore.

However, the kernel provides the option to register arbitrary MDIO drivers with
mdio_driver_register() where a device could support c45 and live on a c22 only
bus. For such devices the fallback to indirect accesses would be useful as well,
since they can't use the existing indirect access functions, because they're
specific to PHYs. However, currently there aren't such drivers in the kernel.
I just want to mention this for completeness.
> Thanks.
>
Thanks to you, Russell!
> --
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
