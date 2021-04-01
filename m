Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51141350BD7
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 03:24:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232601AbhDABXb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 21:23:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbhDABXM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Mar 2021 21:23:12 -0400
Received: from hs01.dk-develop.de (hs01.dk-develop.de [IPv6:2a02:c207:3002:6234::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2BD4C061574;
        Wed, 31 Mar 2021 18:23:11 -0700 (PDT)
Received: from mail.dk-develop.de (hs01.dk-develop.de [IPv6:::1])
        by hs01.dk-develop.de (Postfix) with ESMTP id 43E66240605;
        Thu,  1 Apr 2021 03:23:05 +0200 (CEST)
MIME-Version: 1.0
Date:   Thu, 01 Apr 2021 03:23:05 +0200
From:   danilokrummrich@dk-develop.de
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>, davem@davemloft.net,
        hkallweit1@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, jeremy.linton@arm.com
Subject: Re: [PATCH 2/2] net: mdio: support c45 peripherals on c22 busses
In-Reply-To: <20210331183524.GV1463@shell.armlinux.org.uk>
References: <20210331141755.126178-1-danilokrummrich@dk-develop.de>
 <20210331141755.126178-3-danilokrummrich@dk-develop.de>
 <YGSi+b/r4zlq9rm8@lunn.ch> <6f1dfc28368d098ace9564e53ed92041@dk-develop.de>
 <20210331183524.GV1463@shell.armlinux.org.uk>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <2f0ea3c3076466e197ca2977753b07f3@dk-develop.de>
X-Sender: danilokrummrich@dk-develop.de
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-03-31 20:35, Russell King - ARM Linux admin wrote:
> On Wed, Mar 31, 2021 at 07:58:33PM +0200, danilokrummrich@dk-develop.de 
> wrote:
>> For this cited change the only thing happening is that if 
>> get_phy_device()
>> already failed for probing with is_c45==false (C22 devices) it tries 
>> to
>> probe with is_c45==true (C45 devices) which then either results into 
>> actual
>> C45 frame transfers or indirect accesses by calling mdiobus_c45_*() 
>> functions.
> 
> Please explain why and how a PHY may not appear to be present using
> C22 frames to read the ID registers, but does appear to be present
> when using C22 frames to the C45 indirect registers - and summarise
> which PHYs have this behaviour.
> 
> It seems very odd that any PHY would only implement C45 indirect
> registers in the C22 register space.
Honestly, I can't list examples of that case (at least none that have an
upstream driver already). This part of my patch, to fall back to c45 bus
probing when c22 probing does not succeed, is also motivated by the fact
that this behaviour was already introduced with this patch:

commit 0cc8fecf041d3e5285380da62cc6662bdc942d8c
Author: Jeremy Linton <jeremy.linton@arm.com>
Date:   Mon Jun 22 20:35:32 2020 +0530

     net: phy: Allow mdio buses to auto-probe c45 devices

     The mdiobus_scan logic is currently hardcoded to only
     work with c22 devices. This works fairly well in most
     cases, but its possible that a c45 device doesn't respond
     despite being a standard phy. If the parent hardware
     is capable, it makes sense to scan for c22 devices before
     falling back to c45.

     As we want this to reflect the capabilities of the STA,
     lets add a field to the mii_bus structure to represent
     the capability. That way devices can opt into the extended
     scanning. Existing users should continue to default to c22
     only scanning as long as they are zero'ing the structure
     before use.

     Signed-off-by: Jeremy Linton <jeremy.linton@arm.com>
     Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
     Signed-off-by: David S. Miller <davem@davemloft.net>

In this patch i.a. the following lines were added.

+       case MDIOBUS_C22_C45:
+               phydev = get_phy_device(bus, addr, false);
+               if (IS_ERR(phydev))
+                       phydev = get_phy_device(bus, addr, true);
+               break;

I'm applying the same logic for MDIOBUS_NO_CAP and MDIOBUS_C22, since
with my patch MDIO controllers with those capabilities can handle c45 
bus
probing with indirect accesses.

[By the way, I'm unsure if this order for MDIO bus controllers with the
capability MDIOBUS_C22_C45 makes sense, because if we assume that the
majority of c45 PHYs responds well to c22 probing (which I'm convinced 
of)
the PHY would still be registered as is_c45==false, which results in the 
fact
that even though the underlying bus is capable of real c45 framing only
indirect accessing would be performed. But this is another topic and
unrelated to the patch.]

However, this is not the main motivation of my patch. The main driver is
of_mdiobus_register_phy():

	is_c45 = of_device_is_compatible(child,
					 "ethernet-phy-ieee802.3-c45");

	if (!is_c45 && !of_get_phy_id(child, &phy_id))
		phy = phy_device_create(mdio, addr, phy_id, 0, NULL);
	else
		phy = get_phy_device(mdio, addr, is_c45);

In the case a PHY is registered as a c45 compatible PHY in the device 
tree,
it is probed in c45 mode and therefore finally  mdiobus_c45_read() is 
called,
which as by now just expects the underlying MDIO bus controller to be 
capable
to do c45 framing and therefore the operation would fail in case it is 
not.
Hence, in my opinion it is useful to fall back to indirect accesses in 
such a
case to be able to support those PHYs.

There is a similar issue in phy_mii_ioctl(). Let's assume a c45 capable 
PHY is
connected to a MDIO bus controller that is not capable of c45 framing. 
We can
also assume that it was probed with c22 bus probing, since without this 
patch
nothing else is possible.
Now, there might be an ioctl() asking for a c45 transfer by specifying
MDIO_PHY_ID_C45_MASK e.g. in order to access a different MMD's register,
since the PHY is actually capable of c45. Currently, this would result 
in

devad = mdiobus_c45_addr(devad, mii_data->reg_num);
mii_data->val_out = mdiobus_read(phydev->mdio.bus, prtad, devad);

calls, which would fail, since the bus doesn't support it. Instead 
falling back
to indirect access might be the better option. Surely, the userspace 
program
could implement the indirect access as well, but I think this way it's 
just more
convenient, e.g. "phytool read iface/addr:devad/reg".
