Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21AEB32062D
	for <lists+netdev@lfdr.de>; Sat, 20 Feb 2021 17:32:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229937AbhBTQbV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Feb 2021 11:31:21 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:50732 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229803AbhBTQbT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 20 Feb 2021 11:31:19 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lDV9J-007XVe-Gy; Sat, 20 Feb 2021 17:30:29 +0100
Date:   Sat, 20 Feb 2021 17:30:29 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Ivan Bornyakov <i.bornyakov@metrotek.ru>, netdev@vger.kernel.org,
        system@metrotek.ru, hkallweit1@gmail.com, davem@davemloft.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: phy: add Marvell 88X2222 transceiver support
Message-ID: <YDE5Ja/O4sk4hewj@lunn.ch>
References: <20210201192250.gclztkomtsihczz6@dhcp-179.ddg>
 <20210220094621.tl6fawj7c5hjrp6s@dhcp-179.ddg>
 <20210220115303.GL1463@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210220115303.GL1463@shell.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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

Agreed. This got me confused, wondering where the SGMII handling was.

	Andrew
