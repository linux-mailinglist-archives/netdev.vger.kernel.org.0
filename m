Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B2BA35C750
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 15:15:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238145AbhDLNP3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 09:15:29 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45428 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236976AbhDLNP2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 09:15:28 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lVwPD-00GGfR-0f; Mon, 12 Apr 2021 15:15:07 +0200
Date:   Mon, 12 Apr 2021 15:15:07 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: phy: marvell: fix detection of PHY on Topaz switches
Message-ID: <YHRH2zWsYkv/yjYz@lunn.ch>
References: <20210412121430.20898-1-pali@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210412121430.20898-1-pali@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static u16 mv88e6xxx_physid_for_family(enum mv88e6xxx_family family);
> +

No forward declaration please. Move the code around. It is often best
to do that in a patch which just moves code, no other changes. It
makes it easier to review.

>  static int mv88e6xxx_mdio_read(struct mii_bus *bus, int phy, int reg)
>  {
>  	struct mv88e6xxx_mdio_bus *mdio_bus = bus->priv;
> @@ -3040,24 +3042,9 @@ static int mv88e6xxx_mdio_read(struct mii_bus *bus, int phy, int reg)
>  	err = chip->info->ops->phy_read(chip, bus, phy, reg, &val);
>  	mv88e6xxx_reg_unlock(chip);
>  
> -	if (reg == MII_PHYSID2) {
> -		/* Some internal PHYs don't have a model number. */
> -		if (chip->info->family != MV88E6XXX_FAMILY_6165)
> -			/* Then there is the 6165 family. It gets is
> -			 * PHYs correct. But it can also have two
> -			 * SERDES interfaces in the PHY address
> -			 * space. And these don't have a model
> -			 * number. But they are not PHYs, so we don't
> -			 * want to give them something a PHY driver
> -			 * will recognise.
> -			 *
> -			 * Use the mv88e6390 family model number
> -			 * instead, for anything which really could be
> -			 * a PHY,
> -			 */
> -			if (!(val & 0x3f0))
> -				val |= MV88E6XXX_PORT_SWITCH_ID_PROD_6390 >> 4;
> -	}
> +	/* Some internal PHYs don't have a model number. */
> +	if (reg == MII_PHYSID2 && !(val & 0x3f0))
> +		val |= mv88e6xxx_physid_for_family(chip->info->family);
>  
>  	return err ? err : val;
>  }
> @@ -5244,6 +5231,39 @@ static const struct mv88e6xxx_info *mv88e6xxx_lookup_info(unsigned int prod_num)
>  	return NULL;
>  }
>  
> +/* This table contains representative model for every family */
> +static const enum mv88e6xxx_model family_model_table[] = {
> +	[MV88E6XXX_FAMILY_6095] = MV88E6095,
> +	[MV88E6XXX_FAMILY_6097] = MV88E6097,
> +	[MV88E6XXX_FAMILY_6185] = MV88E6185,
> +	[MV88E6XXX_FAMILY_6250] = MV88E6250,
> +	[MV88E6XXX_FAMILY_6320] = MV88E6320,
> +	[MV88E6XXX_FAMILY_6341] = MV88E6341,
> +	[MV88E6XXX_FAMILY_6351] = MV88E6351,
> +	[MV88E6XXX_FAMILY_6352] = MV88E6352,
> +	[MV88E6XXX_FAMILY_6390] = MV88E6390,
> +};

This table is wrong. MV88E6390 does not equal
MV88E6XXX_PORT_SWITCH_ID_PROD_6390. MV88E6XXX_PORT_SWITCH_ID_PROD_6390
was chosen because it is already an MDIO device ID, in register 2 and
3. It probably will never clash with a real Marvell PHY ID. MV88E6390
is just a small integer, and there is a danger it will clash with a
real PHY.

> --- a/drivers/net/phy/marvell.c
> +++ b/drivers/net/phy/marvell.c
> @@ -3021,9 +3021,34 @@ static struct phy_driver marvell_drivers[] = {
>  		.get_stats = marvell_get_stats,
>  	},
>  	{
> -		.phy_id = MARVELL_PHY_ID_88E6390,
> +		.phy_id = MARVELL_PHY_ID_88E6341_FAMILY,
>  		.phy_id_mask = MARVELL_PHY_ID_MASK,
> -		.name = "Marvell 88E6390",
> +		.name = "Marvell 88E6341 Family",

You cannot just replace the MARVELL_PHY_ID_88E6390. That will break
the 6390! You need to add the new PHY for the 88E6341.

    Andrew
