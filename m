Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AA011B85BE
	for <lists+netdev@lfdr.de>; Sat, 25 Apr 2020 12:47:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726108AbgDYKrR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Apr 2020 06:47:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726053AbgDYKrQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Apr 2020 06:47:16 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3023EC09B04A;
        Sat, 25 Apr 2020 03:47:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=UcPyzDSmAlpvs6USWTK+Q8/Nb28cO4vwEOAm0T/Tcak=; b=V9HxQjBM7jdzA3jGh8A32Siwg
        wRpc0Dx9V24lqnL1AYO/AGAJznr983DYn+waOT2+IbyzigSPfs4faG8uX94IQSqdebDnL8rNALmy0
        l8LDUlA0MfNdHI0I81ZAUzh5xPvp6/Y+PeKWwW41mMSb4cX0H93Ax5/ml9Jg//eBVzmawf4rO56DZ
        qig/D+71rsBPh9IsrEZfMlBaSOnOPPPGvTvmRleVnwkr0jbWJKYIuqscrzGJ7UDUsAyP2OGOQe7VZ
        lplPZRhyV3PkvWoynvykGSrlaLzJ9lO9p6c8Hun+TAFO4NXAfMCrKSv/3DguTs17JZBTWsSTDsYPK
        NlQN61mkA==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:43516)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jSIKz-000287-OM; Sat, 25 Apr 2020 11:47:10 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jSIKx-0004Y1-SI; Sat, 25 Apr 2020 11:47:07 +0100
Date:   Sat, 25 Apr 2020 11:47:07 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Florinel Iordache <florinel.iordache@nxp.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        robh+dt@kernel.org, mark.rutland@arm.com, kuba@kernel.org,
        corbet@lwn.net, shawnguo@kernel.org, leoyang.li@nxp.com,
        madalin.bucur@oss.nxp.com, ioana.ciornei@nxp.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 6/9] net: phy: add backplane kr driver support
Message-ID: <20200425104707.GY25745@shell.armlinux.org.uk>
References: <1587732391-3374-1-git-send-email-florinel.iordache@nxp.com>
 <1587732391-3374-7-git-send-email-florinel.iordache@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1587732391-3374-7-git-send-email-florinel.iordache@nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 24, 2020 at 03:46:28PM +0300, Florinel Iordache wrote:
> Add support for backplane kr generic driver including link training
> (ieee802.3ap/ba) and fixed equalization algorithm

This looks like it's still very much modelled on being a phylib driver,
which I thought we discussed shouldn't be the case.

Some further comments inline, but given the size of this patch I haven't
spent too long reviewing it.

> diff --git a/drivers/net/phy/backplane/Kconfig b/drivers/net/phy/backplane/Kconfig
> new file mode 100644
> index 0000000..9ec54b5
> --- /dev/null
> +++ b/drivers/net/phy/backplane/Kconfig
> @@ -0,0 +1,20 @@
> +# SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause)
> +config ETH_BACKPLANE
> +	tristate "Ethernet Backplane support"
> +	depends on OF_MDIO
> +	help
> +	  This module provides driver support for Ethernet Operation over
> +	  Electrical Backplanes. It includes Backplane generic
> +	  driver including support for Link Training (IEEE802.3ap/ba).
> +	  Based on the link quality, a signal equalization is required.
> +	  The standard specifies that a start-up algorithm should be in place
> +	  in order to get the link up.
> +
> +config ETH_BACKPLANE_FIXED
> +	tristate "Fixed: No Equalization algorithm"
> +	depends on ETH_BACKPLANE
> +	help
> +	  This module provides a driver to setup fixed user configurable
> +	  coefficient values for backplanes equalization. This means
> +	  No Equalization algorithm is used to adapt the initial coefficients
> +	  initially set by the user.
> \ No newline at end of file

Please fix.

> +static u32 le_ioread32(void __iomem *reg)
> +{
> +	return ioread32(reg);
> +}
> +
> +static void le_iowrite32(u32 value, void __iomem *reg)
> +{
> +	iowrite32(value, reg);
> +}
> +
> +static u32 be_ioread32(void __iomem *reg)
> +{
> +	return ioread32be(reg);
> +}
> +
> +static void be_iowrite32(u32 value, void __iomem *reg)
> +{
> +	iowrite32be(value, reg);
> +}

Do these accessors really add any value - they just rename our existing
accessors, and therefore make the learning curve to understand this
code unnecessarily harder than it needs to be.

> +/* Read AN Link Status */
> +static int is_an_link_up(struct phy_device *phydev)
> +{
> +	struct backplane_device *bpdev = phydev->priv;
> +	int ret, val = 0;
> +
> +	mutex_lock(&bpdev->bpphy_lock);
> +
> +	/* Read twice because Link_Status is LL (Latched Low) bit */
> +	val = phy_read_mmd(phydev, MDIO_MMD_AN, MDIO_STAT1);
> +	val = phy_read_mmd(phydev, MDIO_MMD_AN, MDIO_STAT1);

What if an error occurs? while reading?

Do you care if the link went down momentarily?

> +/* backplane_write_mmd - Wrapper function for phy_write_mmd
> + * for writing a register on an MMD on a given PHY.
> + *
> + * Same rules as for phy_write_mmd();
> + */

Exported functions ought to have proper kerneldoc documentation.

> +int backplane_write_mmd(struct lane_device *lane, int devad, u32 regnum,
> +			u16 val)
> +{
> +	struct backplane_device *bpdev = lane->bpdev;
> +	struct phy_device *phydev = lane->phydev;
> +	int mdio_addr = phydev->mdio.addr;
> +	int err;
> +
> +	mutex_lock(&bpdev->bpphy_lock);
> +
> +	if (devad == MDIO_MMD_AN && backplane_is_multi_lane(bpdev)) {
> +		/* Multilane AN: prepare mdio address
> +		 * for writing phydev AN registers on respective lane
> +		 * AN MDIO address offset for multilane is equal
> +		 * to number of lanes
> +		 */
> +		phydev->mdio.addr = bpdev->num_lanes + lane->idx;
> +	}
> +
> +	err = phy_write_mmd(phydev, devad, regnum, val);
> +	if (err)
> +		bpdev_err(phydev,
> +			  "Writing PHY (%p) MMD = 0x%02x register = 0x%02x failed with error code: 0x%08x\n",
> +			  phydev, devad, regnum, err);
> +
> +	if (devad == MDIO_MMD_AN && backplane_is_multi_lane(bpdev)) {
> +		/* Multilane AN: restore mdio address */
> +		phydev->mdio.addr = mdio_addr;
> +	}
> +
> +	mutex_unlock(&bpdev->bpphy_lock);
> +
> +	return err;
> +}
> +EXPORT_SYMBOL(backplane_write_mmd);

Consider EXPORT_SYMBOL_GPL().

> +
> +/* backplane_read_mmd - Wrapper function for phy_read_mmd
> + * for reading a register from an MMD on a given PHY.
> + *
> + * Same rules as for phy_read_mmd();
> + */
> +int backplane_read_mmd(struct lane_device *lane, int devad, u32 regnum)
> +{
> +	struct backplane_device *bpdev = lane->bpdev;
> +	struct phy_device *phydev = lane->phydev;
> +	int mdio_addr = phydev->mdio.addr;
> +	int ret;
> +
> +	mutex_lock(&bpdev->bpphy_lock);
> +
> +	if (devad == MDIO_MMD_AN && backplane_is_multi_lane(bpdev)) {
> +		/* Multilane AN: prepare mdio address
> +		 * for reading phydev AN registers on respective lane
> +		 * AN MDIO address offset for multilane is equal to
> +		 * number of lanes
> +		 */
> +		phydev->mdio.addr = bpdev->num_lanes + lane->idx;
> +	}
> +
> +	ret = phy_read_mmd(phydev, devad, regnum);
> +
> +	if (devad == MDIO_MMD_AN && backplane_is_multi_lane(bpdev)) {
> +		/* Multilane AN: restore mdio address */
> +		phydev->mdio.addr = mdio_addr;
> +	}
> +
> +	mutex_unlock(&bpdev->bpphy_lock);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL(backplane_read_mmd);

I think the above two functions are coding implementation specifics into
what is trying to be a generic layer here.  What guarantee do we have
that all KR PHYs will live at consecutive addresses for each lane?

This brings me on to another issue - I thought we discussed the point of
reusing struct phy_device, and we strongly recommended against it ?
I think it would make more sense for struct lane_device to contain a
'struct mdio_device' or maybe a new 'struct pcs_mdio_device' which
points to the specific MDIO device for this lane.  That would have the
nice effect of avoiding the implementation specifics here.

> +bool backplane_is_mode_kr(phy_interface_t interface)
> +{
> +	return (interface >= PHY_INTERFACE_MODE_10GKR &&
> +		interface <= PHY_INTERFACE_MODE_40GKR4);

This really should not be here - you're reliant on no one
inappropriately adding between these enumeration values - but this code
is divorsed from its definition.  It should be in linux/phy.h to
complement things like phy_interface_mode_is_rgmii() et.al.

> +}
> +EXPORT_SYMBOL(backplane_is_mode_kr);
> +
> +bool backplane_is_valid_mode(phy_interface_t interface)
> +{
> +	return (interface >= PHY_INTERFACE_MODE_10GKR &&
> +		interface <= PHY_INTERFACE_MODE_40GKR4);

Same problem - it looks the same as backplane_is_mode_kr().

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
