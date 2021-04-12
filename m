Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 534FD35C7BF
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 15:34:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241859AbhDLNfJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 09:35:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:42548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241897AbhDLNfI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 09:35:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D8FC06128B;
        Mon, 12 Apr 2021 13:34:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618234490;
        bh=Ad1BduDIgN1NcosMNCRBRGTwSB5hfR5PikbO2SrTq7w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DDY3o1e/UYSRbuxKAD54G7FsTW8qdhqRF81/zVS2j1FbsZS6tT4y85PPvCttH+qhw
         Jih/g9IDbJDGNMTIPP2d3IQHrALuR+h0nMaMk4U5eRH3wTRqjGo0KP+93Z7BqClDRo
         hdFkBB3TouyxR/xDcW4rUDl8xuleoraE8SubPKOh70FRAAneQ+2OmL6kW2yexcmKNL
         Ah45SVVs34F2N93d8i8nomPDLV6+i9Z1bGiNGinFrnJLmKY34zj6zwaKK+JPJN9ETC
         ugBpFRKVtuStBpKjvS5G+ExhRhLUfj7VPeiIh++5MQanBY00KHxGUpuAtRnG/XQf0r
         3WFyvbNtnFb1A==
Received: by pali.im (Postfix)
        id 7ECB4687; Mon, 12 Apr 2021 15:34:47 +0200 (CEST)
Date:   Mon, 12 Apr 2021 15:34:47 +0200
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: phy: marvell: fix detection of PHY on Topaz switches
Message-ID: <20210412133447.fyqkavrs5r5wbino@pali>
References: <20210412121430.20898-1-pali@kernel.org>
 <YHRH2zWsYkv/yjYz@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YHRH2zWsYkv/yjYz@lunn.ch>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Monday 12 April 2021 15:15:07 Andrew Lunn wrote:
> > +static u16 mv88e6xxx_physid_for_family(enum mv88e6xxx_family family);
> > +
> 
> No forward declaration please. Move the code around. It is often best
> to do that in a patch which just moves code, no other changes. It
> makes it easier to review.

Avoiding forward declaration would mean to move about half of source
code. mv88e6xxx_physid_for_family depends on mv88e6xxx_table which
depends on all _ops structures which depends on all lot of other
functions.

I wanted to create a small fixup patch which can be easily backported to
stable releases which are affected by this issue.

If you do not like forward declarations, I can create a followup patch
which moves this half of code in this file to avoid forward declaration.
But having it in one patch would mean to complicate reviewing code...

> >  static int mv88e6xxx_mdio_read(struct mii_bus *bus, int phy, int reg)
> >  {
> >  	struct mv88e6xxx_mdio_bus *mdio_bus = bus->priv;
> > @@ -3040,24 +3042,9 @@ static int mv88e6xxx_mdio_read(struct mii_bus *bus, int phy, int reg)
> >  	err = chip->info->ops->phy_read(chip, bus, phy, reg, &val);
> >  	mv88e6xxx_reg_unlock(chip);
> >  
> > -	if (reg == MII_PHYSID2) {
> > -		/* Some internal PHYs don't have a model number. */
> > -		if (chip->info->family != MV88E6XXX_FAMILY_6165)
> > -			/* Then there is the 6165 family. It gets is
> > -			 * PHYs correct. But it can also have two
> > -			 * SERDES interfaces in the PHY address
> > -			 * space. And these don't have a model
> > -			 * number. But they are not PHYs, so we don't
> > -			 * want to give them something a PHY driver
> > -			 * will recognise.
> > -			 *
> > -			 * Use the mv88e6390 family model number
> > -			 * instead, for anything which really could be
> > -			 * a PHY,
> > -			 */
> > -			if (!(val & 0x3f0))
> > -				val |= MV88E6XXX_PORT_SWITCH_ID_PROD_6390 >> 4;
> > -	}
> > +	/* Some internal PHYs don't have a model number. */
> > +	if (reg == MII_PHYSID2 && !(val & 0x3f0))
> > +		val |= mv88e6xxx_physid_for_family(chip->info->family);
> >  
> >  	return err ? err : val;
> >  }
> > @@ -5244,6 +5231,39 @@ static const struct mv88e6xxx_info *mv88e6xxx_lookup_info(unsigned int prod_num)
> >  	return NULL;
> >  }
> >  
> > +/* This table contains representative model for every family */
> > +static const enum mv88e6xxx_model family_model_table[] = {
> > +	[MV88E6XXX_FAMILY_6095] = MV88E6095,
> > +	[MV88E6XXX_FAMILY_6097] = MV88E6097,
> > +	[MV88E6XXX_FAMILY_6185] = MV88E6185,
> > +	[MV88E6XXX_FAMILY_6250] = MV88E6250,
> > +	[MV88E6XXX_FAMILY_6320] = MV88E6320,
> > +	[MV88E6XXX_FAMILY_6341] = MV88E6341,
> > +	[MV88E6XXX_FAMILY_6351] = MV88E6351,
> > +	[MV88E6XXX_FAMILY_6352] = MV88E6352,
> > +	[MV88E6XXX_FAMILY_6390] = MV88E6390,
> > +};
> 
> This table is wrong. MV88E6390 does not equal
> MV88E6XXX_PORT_SWITCH_ID_PROD_6390. MV88E6XXX_PORT_SWITCH_ID_PROD_6390
> was chosen because it is already an MDIO device ID, in register 2 and
> 3. It probably will never clash with a real Marvell PHY ID. MV88E6390
> is just a small integer, and there is a danger it will clash with a
> real PHY.

So... how to solve this issue? What should be in the mapping table?

> > --- a/drivers/net/phy/marvell.c
> > +++ b/drivers/net/phy/marvell.c
> > @@ -3021,9 +3021,34 @@ static struct phy_driver marvell_drivers[] = {
> >  		.get_stats = marvell_get_stats,
> >  	},
> >  	{
> > -		.phy_id = MARVELL_PHY_ID_88E6390,
> > +		.phy_id = MARVELL_PHY_ID_88E6341_FAMILY,
> >  		.phy_id_mask = MARVELL_PHY_ID_MASK,
> > -		.name = "Marvell 88E6390",
> > +		.name = "Marvell 88E6341 Family",
> 
> You cannot just replace the MARVELL_PHY_ID_88E6390. That will break
> the 6390! You need to add the new PHY for the 88E6341.

I have not replaced anything. I just put there a new phy_id section for
88E6341. You are probably confused by 'git diff' output as quickly
looking at it, somebody can think that there is phy replacement. But
there is no replacement, I only added a new PHY. Entry for 88E6390 is
still there!

Also this is reason why I wanted to avoid big code movement. It will be
harder to read the 'git diff' output in this patch.
