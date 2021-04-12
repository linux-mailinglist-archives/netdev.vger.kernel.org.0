Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17EEF35C959
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 17:02:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242651AbhDLPCO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 11:02:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:36696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241539AbhDLPCN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 11:02:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AE7CF61287;
        Mon, 12 Apr 2021 15:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618239715;
        bh=5UW8HbUYX4iQh5QgJmFd1pvxwupAcZPnuAATxqfNAFU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OfcOrgnTKmxGMezf+WFS5sQyG4IWu3kkwTPNpUv54N8/2HZ+HATh/SoOPe6mh2Vg4
         U1y2TQ7PtukxURrHYMOuuIY5fZTYiMGJ3CK78/h/ZAwGzjuhYcYJtlIyArICPmsGWF
         a4JisaiRtlT7FQThYA8B/mRKAscgCvD3HhhSOXku+1bau/Pib0xTPczbibkV9BIHBa
         TKSh8Vbqvmf0s0aP2FmeuYY6ZyY2V8XezUqSC0yqifBEOY4+VZ9yqYTvZpOyAv+mLT
         /cymuEDEr0KugPWh7HGjA1RE2DgmMbc88OROI/wm+6XepcVb0l/d3U7kfMv4Dmk8s7
         LjXDJqRibTgQw==
Received: by pali.im (Postfix)
        id 12E71687; Mon, 12 Apr 2021 17:01:52 +0200 (CEST)
Date:   Mon, 12 Apr 2021 17:01:52 +0200
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
Message-ID: <20210412150152.pbz5zt7mu3aefbrx@pali>
References: <20210412121430.20898-1-pali@kernel.org>
 <YHRH2zWsYkv/yjYz@lunn.ch>
 <20210412133447.fyqkavrs5r5wbino@pali>
 <YHRcu+dNKE7xC8EG@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YHRcu+dNKE7xC8EG@lunn.ch>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Monday 12 April 2021 16:44:11 Andrew Lunn wrote:
> On Mon, Apr 12, 2021 at 03:34:47PM +0200, Pali Rohár wrote:
> > On Monday 12 April 2021 15:15:07 Andrew Lunn wrote:
> > > > +static u16 mv88e6xxx_physid_for_family(enum mv88e6xxx_family family);
> > > > +
> > > 
> > > No forward declaration please. Move the code around. It is often best
> > > to do that in a patch which just moves code, no other changes. It
> > > makes it easier to review.
> > 
> > Avoiding forward declaration would mean to move about half of source
> > code. mv88e6xxx_physid_for_family depends on mv88e6xxx_table which
> > depends on all _ops structures which depends on all lot of other
> > functions.
> 
> So this is basically what you are trying to do:
> 
> diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
> index 903d619e08ed..ef4dbcb052b7 100644
> --- a/drivers/net/dsa/mv88e6xxx/chip.c
> +++ b/drivers/net/dsa/mv88e6xxx/chip.c
> @@ -3026,6 +3026,18 @@ static int mv88e6xxx_setup(struct dsa_switch *ds)
>         return err;
>  }
>  
> +static const enum mv88e6xxx_model family_model_table[] = {
> +       [MV88E6XXX_FAMILY_6095] = MV88E6XXX_PORT_SWITCH_ID_PROD_6095,
> +       [MV88E6XXX_FAMILY_6097] = MV88E6XXX_PORT_SWITCH_ID_PROD_6097,
> +       [MV88E6XXX_FAMILY_6185] = MV88E6XXX_PORT_SWITCH_ID_PROD_6185,
> +       [MV88E6XXX_FAMILY_6250] = MV88E6XXX_PORT_SWITCH_ID_PROD_6250,
> +       [MV88E6XXX_FAMILY_6320] = MV88E6XXX_PORT_SWITCH_ID_PROD_6320,
> +       [MV88E6XXX_FAMILY_6341] = MV88E6XXX_PORT_SWITCH_ID_PROD_6341,
> +       [MV88E6XXX_FAMILY_6351] = MV88E6XXX_PORT_SWITCH_ID_PROD_6351,
> +       [MV88E6XXX_FAMILY_6352] = MV88E6XXX_PORT_SWITCH_ID_PROD_6352,
> +       [MV88E6XXX_FAMILY_6390] = MV88E6XXX_PORT_SWITCH_ID_PROD_6390,
> +};

Ok, no problem. I can change it in this way. I just thought that if
prod_id is already defined for every model in mv88e6xxx_table[] table I
could reuse it, instead of duplicating it...

Anyway, now I'm looking at phy/marvell.c driver again and it supports
only 88E6341 and 88E6390 families from whole 88E63xxx range.

So do we need to define for now table for more than
MV88E6XXX_FAMILY_6341 and MV88E6XXX_FAMILY_6390 entries?

> +
>  static int mv88e6xxx_mdio_read(struct mii_bus *bus, int phy, int reg)
>  {
>         struct mv88e6xxx_mdio_bus *mdio_bus = bus->priv;
> @@ -3056,7 +3068,7 @@ static int mv88e6xxx_mdio_read(struct mii_bus *bus, int phy, int reg)
>                          * a PHY,
>                          */
>                         if (!(val & 0x3f0))
> -                               val |= MV88E6XXX_PORT_SWITCH_ID_PROD_6390 >> 4;
> +                               val |= family_model_table[chip->info->family] >> 4;
>         }
> 
> and it compiles. No forward declarations needed. It is missing all the
> error checking etc, but i don't see why that should change the
> dependencies.
> 
> 	Andrew
