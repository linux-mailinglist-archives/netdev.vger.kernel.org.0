Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EF6D21A6B8
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 20:14:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726889AbgGISOn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 14:14:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726671AbgGISOm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 14:14:42 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75D60C08C5CE;
        Thu,  9 Jul 2020 11:14:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=3HK5dzGZffo3FC4Lz3VncXykzeVEWKCwQGScTvdaavw=; b=GM1diqZnyPzok52Yrt36qVBNd
        GnIATjnFZxVPsyfBxHQ4rc/gxUXaYmqlvzBGf4ekevcY5PSCoon4zQdQmdrm3Gsk3W1gYiG09mXK8
        eYS41Ej429grWLtex5xT1tEm3+OMi90YDqazJBfdFGeJL/JQY2aR5jt/jaOqD/J1vAVFNpDmC3YYy
        9hmidW/hwN02Kbhb2OnWWsfmOTKxcmWxY+E5ZLgEWZdFADVhVpCyE98jzMZIluQvTQrMsIIA4s8R5
        UGUsKHqxY2BXhJ9ns3TAaiblz2PlvHSj/6dPEBVme6Vbg7Tm9NS7/IhsOFfrslUb2gTJSOBFzZmdK
        9SLeMcB4g==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:37408)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jtb49-0000td-4k; Thu, 09 Jul 2020 19:14:37 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jtb48-0002SB-3T; Thu, 09 Jul 2020 19:14:36 +0100
Date:   Thu, 9 Jul 2020 19:14:36 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Calvin Johnson <calvin.johnson@oss.nxp.com>
Cc:     Jeremy Linton <jeremy.linton@arm.com>, Jon <jon@solid-run.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        linux-acpi@vger.kernel.org, linux.cj@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [net-next PATCH v4 4/6] net: phy: introduce phy_find_by_fwnode()
Message-ID: <20200709181435.GH1551@shell.armlinux.org.uk>
References: <20200709175722.5228-1-calvin.johnson@oss.nxp.com>
 <20200709175722.5228-5-calvin.johnson@oss.nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200709175722.5228-5-calvin.johnson@oss.nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 09, 2020 at 11:27:20PM +0530, Calvin Johnson wrote:
> The PHYs on an mdiobus are probed and registered using mdiobus_register().
> Later, for connecting these PHYs to MAC, the PHYs registered on the
> mdiobus have to be referenced.
> 
> For each MAC node, a property "mdio-handle" is used to reference the
> MDIO bus on which the PHYs are registered. On getting hold of the MDIO
> bus, use phy_find_by_fwnode() to get the PHY connected to the MAC.
> 
> Introduce fwnode_mdio_find_bus() to find the mii_bus that corresponds
> to given mii_bus fwnode.
> 
> Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
> 
> ---
> 
> Changes in v4:
> - release fwnode_mdio after use
> - return ERR_PTR instead of NULL
> 
> Changes in v3:
> - introduce fwnode_mdio_find_bus()
> - renamed and improved phy_find_by_fwnode()
> 
> Changes in v2: None
> 
>  drivers/net/phy/mdio_bus.c   | 25 +++++++++++++++++++++++++
>  drivers/net/phy/phy_device.c | 22 ++++++++++++++++++++++
>  include/linux/phy.h          |  2 ++
>  3 files changed, 49 insertions(+)
> 
> diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
> index 3c2749e84f74..dcac8cd8f5cd 100644
> --- a/drivers/net/phy/mdio_bus.c
> +++ b/drivers/net/phy/mdio_bus.c
> @@ -435,6 +435,31 @@ struct mii_bus *of_mdio_find_bus(struct device_node *mdio_bus_np)
>  }
>  EXPORT_SYMBOL(of_mdio_find_bus);
>  
> +/**
> + * fwnode_mdio_find_bus - Given an mii_bus fwnode, find the mii_bus.
> + * @mdio_bus_fwnode: fwnode of the mii_bus.
> + *
> + * Returns a reference to the mii_bus, or NULL if none found.  The
> + * embedded struct device will have its reference count incremented,
> + * and this must be put once the bus is finished with.
> + *
> + * Because the association of a fwnode and mii_bus is made via
> + * mdiobus_register(), the mii_bus cannot be found before it is
> + * registered with mdiobus_register().
> + *
> + */
> +struct mii_bus *fwnode_mdio_find_bus(struct fwnode_handle *mdio_bus_fwnode)
> +{
> +	struct device *d;
> +
> +	if (!mdio_bus_fwnode)
> +		return NULL;
> +
> +	d = class_find_device_by_fwnode(&mdio_bus_class, mdio_bus_fwnode);
> +	return d ? to_mii_bus(d) : NULL;
> +}
> +EXPORT_SYMBOL(fwnode_mdio_find_bus);
> +
>  /* Walk the list of subnodes of a mdio bus and look for a node that
>   * matches the mdio device's address with its 'reg' property. If
>   * found, set the of_node pointer for the mdio device. This allows
> diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> index 7cda95330aea..97a25397348c 100644
> --- a/drivers/net/phy/phy_device.c
> +++ b/drivers/net/phy/phy_device.c
> @@ -25,6 +25,7 @@
>  #include <linux/netdevice.h>
>  #include <linux/phy.h>
>  #include <linux/phy_led_triggers.h>
> +#include <linux/platform_device.h>
>  #include <linux/property.h>
>  #include <linux/sfp.h>
>  #include <linux/skbuff.h>
> @@ -964,6 +965,27 @@ struct phy_device *phy_find_first(struct mii_bus *bus)
>  }
>  EXPORT_SYMBOL(phy_find_first);
>  
> +struct phy_device *phy_find_by_fwnode(struct fwnode_handle *fwnode)

This should be documented, and I'm not sure that the name is a
particularly good idea.  The way I read this name leads me to believe
that the "fwnode" passed in is the fwnode for the PHY device itself,
rather than something that contains the reference information to lookup
the PHY device.

In other words, it leads me (incorrectly) down the path of assuming
that this function is a fwnode variant of of_phy_find_device().

Since fwnodes cover both ACPI and DT, I think, as this does not
implement the recognised DT style of describing a PHY, it really
should error out if the fwnode is a DT node to prevent it becoming
an unintended DT binding.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
