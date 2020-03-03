Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01EE3177A3C
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 16:20:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729380AbgCCPUB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 10:20:01 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:50639 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729026AbgCCPUB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 10:20:01 -0500
X-Originating-IP: 90.89.41.158
Received: from localhost (lfbn-tou-1-1473-158.w90-89.abo.wanadoo.fr [90.89.41.158])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id 6973360003;
        Tue,  3 Mar 2020 15:19:59 +0000 (UTC)
Date:   Tue, 3 Mar 2020 16:19:58 +0100
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 2/3] net: phy: marvell10g: add energy detect
 power down tunable
Message-ID: <20200303151958.GE3179@kwain>
References: <20200303144259.GM25745@shell.armlinux.org.uk>
 <E1j98mA-00057r-U8@rmk-PC.armlinux.org.uk>
 <20200303150741.GC3179@kwain>
 <20200303151232.GO25745@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200303151232.GO25745@shell.armlinux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 03, 2020 at 03:12:32PM +0000, Russell King - ARM Linux admin wrote:
> On Tue, Mar 03, 2020 at 04:07:41PM +0100, Antoine Tenart wrote:
> > On Tue, Mar 03, 2020 at 02:44:02PM +0000, Russell King wrote:
> > >  drivers/net/phy/marvell10g.c | 111 ++++++++++++++++++++++++++++++++++-
> > >  
> > > +static int mv3310_maybe_reset(struct phy_device *phydev, u32 unit, bool reset)
> > > +{
> > > +	int retries, val, err;
> > > +
> > > +	if (!reset)
> > > +		return 0;
> > 
> > You could also call mv3310_maybe_reset after testing the 'reset'
> > condition, that would make it easier to read the code.
> 
> I'm not too convinced:
> 
> diff --git a/drivers/net/phy/marvell10g.c b/drivers/net/phy/marvell10g.c
> index ef1ed9415d9f..3daf73e61dff 100644
> --- a/drivers/net/phy/marvell10g.c
> +++ b/drivers/net/phy/marvell10g.c
> @@ -279,13 +279,10 @@ static int mv3310_power_up(struct phy_device *phydev)
>  				  MV_V2_PORT_CTRL_PWRDOWN);
>  }
>  
> -static int mv3310_maybe_reset(struct phy_device *phydev, u32 unit, bool reset)
> +static int mv3310_reset(struct phy_device *phydev, u32 unit)
>  {
>  	int retries, val, err;
>  
> -	if (!reset)
> -		return 0;
> -
>  	err = phy_modify_mmd(phydev, MDIO_MMD_PCS, unit + MDIO_CTRL1,
>  			     MDIO_CTRL1_RESET, MDIO_CTRL1_RESET);
>  	if (err < 0)
> @@ -684,10 +681,10 @@ static int mv3310_config_mdix(struct phy_device *phydev)
>  
>  	err = phy_modify_mmd_changed(phydev, MDIO_MMD_PCS, MV_PCS_CSCR1,
>  				     MV_PCS_CSCR1_MDIX_MASK, val);
> -	if (err < 0)
> +	if (err <= 0)
>  		return err;
>  
> -	return mv3310_maybe_reset(phydev, MV_PCS_BASE_T, err > 0);
> +	return mv3310_reset(phydev, MV_PCS_BASE_T);
>  }
>  
>  static int mv3310_config_aneg(struct phy_device *phydev)
> 
> The change from:
> 
> 	if (err < 0)
> 
> to:
> 
> 	if (err <= 0)
> 
> could easily be mistaken as a bug, and someone may decide to try to
> "fix" that back to being the former instead.  The way I have the code
> makes the intention explicit.

Using a single line to test both the error and the 'return 0'
conditions, yes, I agree. Another solution would be to do something of
the like:

	phy_modify_mmd_changed()
	if (err < 0)
		return err;

	if (err)
		mv3310_reset();

	return 0;

I find it more readable, but this kind of thing is also a matter of
personal taste.

Antoine

-- 
Antoine Ténart, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
