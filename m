Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63D243205FB
	for <lists+netdev@lfdr.de>; Sat, 20 Feb 2021 16:53:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229876AbhBTPwj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Feb 2021 10:52:39 -0500
Received: from mail.pr-group.ru ([178.18.215.3]:54248 "EHLO mail.pr-group.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229844AbhBTPwi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 20 Feb 2021 10:52:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
        d=metrotek.ru; s=mail;
        h=from:subject:date:message-id:to:cc:mime-version:content-type:in-reply-to:
         references;
        bh=ZeVJn+bzlK9YCwcj/xhE/8T+IbC8yXMF/yJM+6WIWqw=;
        b=XxDd92BzsQ1ffyc87sz8XDNTc2DmkloGwb8t8Va501TkHNobcdJGzYRtIafh6izMhh3jy3CAhmT3q
         gpTs586Vj5aMh4JRB6W5yiHb+p0I5h553PJAw94IY4c23bJWp8QtLtVhIDdmQBNMcWjNT6WgJ2Dlb9
         LNoq/d6pmkUU/Xzjn5WnM/xdXQYXW6pJRMYb5YVOLWuI/tWhKcOzehphBMQCEDEW2Xg++NGlymoEpo
         Fa+1hiQcNi5UREqCZEMDjUmp+ymXnzXjWQh3rLkLV98/PmR4mfH3/2khUch771Iy5jFWuZ46Alj3gY
         b1yTVLh+Z4x9CXbe1Orww+Fh/hk5yXg==
X-Spam-Status: No, hits=0.0 required=3.4
        tests=AWL: 0.000, BAYES_00: -1.665, CUSTOM_RULE_FROM: ALLOW,
        TOTAL_SCORE: -1.665,autolearn=ham
X-Spam-Level: 
X-Footer: bWV0cm90ZWsucnU=
Received: from dhcp-179.ddg ([85.143.252.66])
        (authenticated user i.bornyakov@metrotek.ru)
        by mail.pr-group.ru with ESMTPSA
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256 bits));
        Sat, 20 Feb 2021 18:51:39 +0300
Date:   Sat, 20 Feb 2021 18:51:31 +0300
From:   Ivan Bornyakov <i.bornyakov@metrotek.ru>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, system@metrotek.ru, andrew@lunn.ch,
        hkallweit1@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: phy: add Marvell 88X2222 transceiver support
Message-ID: <20210220155130.4p3fufzmnp32sqhl@dhcp-179.ddg>
References: <20210201192250.gclztkomtsihczz6@dhcp-179.ddg>
 <20210220094621.tl6fawj7c5hjrp6s@dhcp-179.ddg>
 <20210220115303.GL1463@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210220115303.GL1463@shell.armlinux.org.uk>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 20, 2021 at 11:53:04AM +0000, Russell King - ARM Linux admin wrote:
> On Sat, Feb 20, 2021 at 12:46:23PM +0300, Ivan Bornyakov wrote:
> > +
> > +	switch (sfp_interface) {
> > +	case PHY_INTERFACE_MODE_10GBASER:
> > +		phydev->speed = SPEED_10000;
> > +		phy_write_mmd(phydev, MDIO_MMD_VEND2, MV_PCS_CONFIG,
> > +			      MV_PCS_HOST_XAUI | MV_PCS_LINE_10GBR);
> > +		break;
> > +	case PHY_INTERFACE_MODE_1000BASEX:
> > +		phydev->speed = SPEED_1000;
> > +		phy_write_mmd(phydev, MDIO_MMD_VEND2, MV_PCS_CONFIG,
> > +			      MV_PCS_HOST_XAUI | MV_PCS_LINE_1GBX_AN);
> > +		break;
> > +	case PHY_INTERFACE_MODE_SGMII:
> > +		phydev->speed = SPEED_1000;
> > +		phy_write_mmd(phydev, MDIO_MMD_VEND2, MV_PCS_CONFIG,
> > +			      MV_PCS_HOST_XAUI | MV_PCS_LINE_SGMII_AN);
> > +		phy_modify_mmd(phydev, MDIO_MMD_PCS, MV_1GBX_CTRL,
> > +			       BMCR_SPEED1000 | BMCR_SPEED100, BMCR_SPEED1000);
> 
> Isn't this forcing 1000Mbit, but SGMII relies on AN for the slower
> speeds.
> 

It was intended as default, but you have a good point, there is no need
for this, I can just trigger config_aneg() instead.

> > +		break;
> > +	default:
> > +		dev_err(dev, "Incompatible SFP module inserted\n");
> > +
> > +		return -EINVAL;
> > +	}
> 
> I don't think you should set phydev->speed in this function - apart
> from the rtnl lock, there is no other locking here, so this is fragile.
> 
> > +	linkmode_and(phydev->supported, priv->supported, sfp_supported);
> 
> I don't think this is a good idea; phylink does not expect the supported
> mask to change, and I suspect _no_ network device expects it to change.
> One of the things that network drivers and phylink does is to adjust the
> supported mask for a PHY according to the capabilities of the network
> device. For example, if they don't support pause modes, or something
> else. Overriding it in this way has the possibility to re-introduce
> modes that the network driver does not support.
> 

OK, but how can I exclude modes unsupported by inserted SFP?
Or I shouldn't exclude any at all?

> > +/* switch line-side interface between 10GBase-R and 1GBase-X
> > + * according to speed */
> > +static void mv2222_update_interface(struct phy_device *phydev)
> > +{
> > +	struct mv2222_data *priv = phydev->priv;
> > +
> > +	if (phydev->speed == SPEED_10000 &&
> > +	    priv->line_interface == PHY_INTERFACE_MODE_1000BASEX) {
> > +		priv->line_interface = PHY_INTERFACE_MODE_10GBASER;
> > +
> > +		phy_write_mmd(phydev, MDIO_MMD_VEND2, MV_PCS_CONFIG,
> > +			      MV_PCS_HOST_XAUI | MV_PCS_LINE_10GBR);
> > +		mv2222_soft_reset(phydev);
> > +	}
> > +
> > +	if (phydev->speed == SPEED_1000 &&
> > +	    priv->line_interface == PHY_INTERFACE_MODE_10GBASER) {
> > +		priv->line_interface = PHY_INTERFACE_MODE_1000BASEX;
> > +
> > +		phy_write_mmd(phydev, MDIO_MMD_VEND2, MV_PCS_CONFIG,
> > +			      MV_PCS_HOST_XAUI | MV_PCS_LINE_1GBX_AN);
> > +		mv2222_soft_reset(phydev);
> > +	}
> 
> Wouldn't it be better to have a single function to set the line
> interface, used by both this function and your sfp_module_insert
> function? I'm thinking something like:
> 
> static int mv2222_set_line_interface(struct phy_device *phydev,
> 				     phy_interface_t line_interface)
> {
> ...
> }
> 
> and calling that from both these locations to configure the PHY for
> 10GBASE-R, 1000BASE-X and SGMII modes.
> 

I'll think about it, thanks.

> > +
> > +static int mv2222_config_aneg(struct phy_device *phydev)
> > +{
> > +	struct mv2222_data *priv = phydev->priv;
> > +	int ret, adv;
> > +
> > +	/* SFP is not present, do nothing */
> > +	if (priv->line_interface == PHY_INTERFACE_MODE_NA)
> > +		return 0;
> > +
> > +	if (phydev->autoneg == AUTONEG_DISABLE ||
> > +	    phydev->speed == SPEED_10000) {
> > +		if (phydev->speed == SPEED_10000 &&
> > +		    !mv2222_is_10g_capable(phydev))
> > +			return -EINVAL;
> > +
> > +		if (priv->line_interface == PHY_INTERFACE_MODE_SGMII) {
> > +			ret = mv2222_set_sgmii_speed(phydev);
> > +			if (ret < 0)
> > +				return ret;
> > +		} else {
> > +			mv2222_update_interface(phydev);
> > +		}
> > +
> > +		return mv2222_disable_aneg(phydev);
> > +	}
> > +
> > +	/* Try 10G first */
> > +	if (mv2222_is_10g_capable(phydev)) {
> > +		phydev->speed = SPEED_10000;
> > +		mv2222_update_interface(phydev);
> > +
> > +		ret = phy_read_mmd(phydev, MDIO_MMD_PCS, MV_10GBR_STAT_RT);
> > +		if (ret < 0)
> > +			return ret;
> > +
> > +		if (ret & MDIO_STAT1_LSTATUS) {
> > +			phydev->autoneg = AUTONEG_DISABLE;
> > +
> > +			return mv2222_disable_aneg(phydev);
> > +		}
> > +
> > +		/* 10G link was not established, switch back to 1G
> > +		 * and proceed with true autonegotiation */
> > +		phydev->speed = SPEED_1000;
> > +		mv2222_update_interface(phydev);
> 
> This doesn't look right. If the user specifies that they want 10G,
> why should we switch back to 1G?
> 

This is for enabled autoneg. Try 10g, if link is established - stay and
disable autoneg, otherwise continue with true autonegotiation.
For explicitly specified 10g mode there is case above.

Thanks again for in-depth review, Russell.

