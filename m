Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01C6A35111E
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 10:49:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233665AbhDAIt1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 04:49:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233629AbhDAItP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Apr 2021 04:49:15 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E7D4C0613E6;
        Thu,  1 Apr 2021 01:49:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=K7WgbM0otihd5+OzwoBKLFHucMhxXN2uqoKgJOceexc=; b=AdWJMm52PndOndwEITtwPLSN4
        cvr1yfq+dqY5PfV/3IWYAjcfN6/Ir1M9X1u4ozfPzEZEBoCoKXUjPhBaiPr8wws7Wj6exo7kw3PGE
        Y3QM1moEzGlTr2cCOPrpHeJfyi3TXXV3W8+AL+0ET+Z1c5XIUUPt6PTbgFqXQeD2KJj5Tg9L+31xN
        UuwpaH25o6X4gagYhQKCpIELO4H4pjybEW18xoaizpCChtIEdps43DzvzgpdUC6put3osxAz2GFMP
        R8hiLKocNd+jNSRjAX+o4pfFeqKAugS6FV88KHOga7svgkYOyUAHjz+CGEsJHEsQKqmBS1VmJA9Nz
        VtGGcJB0A==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:52002)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1lRt0d-0002rN-Uz; Thu, 01 Apr 2021 09:48:59 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1lRt0c-0004nP-24; Thu, 01 Apr 2021 09:48:58 +0100
Date:   Thu, 1 Apr 2021 09:48:58 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     danilokrummrich@dk-develop.de
Cc:     Andrew Lunn <andrew@lunn.ch>, davem@davemloft.net,
        hkallweit1@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, jeremy.linton@arm.com
Subject: Re: [PATCH 2/2] net: mdio: support c45 peripherals on c22 busses
Message-ID: <20210401084857.GW1463@shell.armlinux.org.uk>
References: <20210331141755.126178-1-danilokrummrich@dk-develop.de>
 <20210331141755.126178-3-danilokrummrich@dk-develop.de>
 <YGSi+b/r4zlq9rm8@lunn.ch>
 <6f1dfc28368d098ace9564e53ed92041@dk-develop.de>
 <20210331183524.GV1463@shell.armlinux.org.uk>
 <2f0ea3c3076466e197ca2977753b07f3@dk-develop.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2f0ea3c3076466e197ca2977753b07f3@dk-develop.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 01, 2021 at 03:23:05AM +0200, danilokrummrich@dk-develop.de wrote:
> On 2021-03-31 20:35, Russell King - ARM Linux admin wrote:
> > On Wed, Mar 31, 2021 at 07:58:33PM +0200, danilokrummrich@dk-develop.de
> > wrote:
> > > For this cited change the only thing happening is that if
> > > get_phy_device()
> > > already failed for probing with is_c45==false (C22 devices) it tries
> > > to
> > > probe with is_c45==true (C45 devices) which then either results into
> > > actual
> > > C45 frame transfers or indirect accesses by calling mdiobus_c45_*()
> > > functions.
> > 
> > Please explain why and how a PHY may not appear to be present using
> > C22 frames to read the ID registers, but does appear to be present
> > when using C22 frames to the C45 indirect registers - and summarise
> > which PHYs have this behaviour.
> > 
> > It seems very odd that any PHY would only implement C45 indirect
> > registers in the C22 register space.
>
> Honestly, I can't list examples of that case (at least none that have an
> upstream driver already). This part of my patch, to fall back to c45 bus
> probing when c22 probing does not succeed, is also motivated by the fact
> that this behaviour was already introduced with this patch:

So, if I understand what you've just said, you want to make a change to
the kernel to add support for something that you don't need and don't
know that there's any hardware that needs it.  Is that correct?

> commit 0cc8fecf041d3e5285380da62cc6662bdc942d8c
> Author: Jeremy Linton <jeremy.linton@arm.com>
> Date:   Mon Jun 22 20:35:32 2020 +0530
> 
>     net: phy: Allow mdio buses to auto-probe c45 devices
> 
>     The mdiobus_scan logic is currently hardcoded to only
>     work with c22 devices. This works fairly well in most
>     cases, but its possible that a c45 device doesn't respond
>     despite being a standard phy. If the parent hardware
>     is capable, it makes sense to scan for c22 devices before
>     falling back to c45.
> 
>     As we want this to reflect the capabilities of the STA,
>     lets add a field to the mii_bus structure to represent
>     the capability. That way devices can opt into the extended
>     scanning. Existing users should continue to default to c22
>     only scanning as long as they are zero'ing the structure
>     before use.
> 
>     Signed-off-by: Jeremy Linton <jeremy.linton@arm.com>
>     Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
>     Signed-off-by: David S. Miller <davem@davemloft.net>
> 
> In this patch i.a. the following lines were added.
> 
> +       case MDIOBUS_C22_C45:
> +               phydev = get_phy_device(bus, addr, false);
> +               if (IS_ERR(phydev))
> +                       phydev = get_phy_device(bus, addr, true);
> +               break;
> 
> I'm applying the same logic for MDIOBUS_NO_CAP and MDIOBUS_C22, since
> with my patch MDIO controllers with those capabilities can handle c45 bus
> probing with indirect accesses.

If the PHY doesn't respond to C22 accesses but is a C45 PHY, then how
can this work (you seem to have essentially said it doesn't above.)

> [By the way, I'm unsure if this order for MDIO bus controllers with the
> capability MDIOBUS_C22_C45 makes sense, because if we assume that the
> majority of c45 PHYs responds well to c22 probing (which I'm convinced of)

There are some which don't - Clause 45 allows PHYs not to implement
support for Clause 22 accesses.

> the PHY would still be registered as is_c45==false, which results in the
> fact
> that even though the underlying bus is capable of real c45 framing only
> indirect accessing would be performed. But this is another topic and
> unrelated to the patch.]

We make no distinction between IDs found via Clause 22 probing and IDs
found via Clause 45 probing; the PHY driver will match either way. We
don't know of any cases where the IDs are different between these two.
So we still end up with the same driver being matched.

Also note that there are MDIO controllers that support clause 22 and
clause 45, but which require clause 22 to be probed first. Not
everything is MDIO at the bus level anymore - there's PHYs that support
I2C, and the I2C format of a clause 45 read is identical to a clause 22
write.

> In the case a PHY is registered as a c45 compatible PHY in the device tree,
> it is probed in c45 mode and therefore finally  mdiobus_c45_read() is
> called,
> which as by now just expects the underlying MDIO bus controller to be
> capable
> to do c45 framing and therefore the operation would fail in case it is not.
> Hence, in my opinion it is useful to fall back to indirect accesses in such
> a
> case to be able to support those PHYs.

Do you actually have a requirement for this?

> There is a similar issue in phy_mii_ioctl(). Let's assume a c45 capable PHY
> is
> connected to a MDIO bus controller that is not capable of c45 framing. We
> can
> also assume that it was probed with c22 bus probing, since without this
> patch
> nothing else is possible.
> Now, there might be an ioctl() asking for a c45 transfer by specifying
> MDIO_PHY_ID_C45_MASK e.g. in order to access a different MMD's register,
> since the PHY is actually capable of c45. Currently, this would result in
> 
> devad = mdiobus_c45_addr(devad, mii_data->reg_num);
> mii_data->val_out = mdiobus_read(phydev->mdio.bus, prtad, devad);
> 
> calls, which would fail, since the bus doesn't support it. Instead falling
> back
> to indirect access might be the better option. Surely, the userspace program
> could implement the indirect access as well, but I think this way it's just
> more
> convenient, e.g. "phytool read iface/addr:devad/reg".

One could also argue this is a feature, and it allows userspace to
know whether C45 cycles are supported or not.

In summary, I think you need to show us that you have a real world
use case for these changes - in other words, a real world PHY setup
that doesn't work today.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
