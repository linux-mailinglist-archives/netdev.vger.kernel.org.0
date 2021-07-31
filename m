Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 754E93DC88C
	for <lists+netdev@lfdr.de>; Sun,  1 Aug 2021 00:05:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231779AbhGaWFi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Jul 2021 18:05:38 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55516 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229560AbhGaWFh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 31 Jul 2021 18:05:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=MXXfRvh2b8PuxEin99HbUG03NW+7u7VDu/JhwY7Oahw=; b=JDDyCJR0fdSb+1ODOJF5+hSOnT
        v11BkeW3mVAMkJ2EPrwQ92ONytPZrg7bc7/3Twl3CDkS2N5XpKVLX3jmuncT5/1OmjZQ+6dKQZziV
        gusFgRTyA3EW+I6bENx3UlNUEFk51iNsgXUq/b2NYT5m6zgtCW+nJc4VqP+kzFHT1EhE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1m9x6a-00Ff1q-2F; Sun, 01 Aug 2021 00:05:16 +0200
Date:   Sun, 1 Aug 2021 00:05:16 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Prasanna Vengateshan <prasanna.vengateshan@microchip.com>,
        netdev@vger.kernel.org, robh+dt@kernel.org,
        UNGLinuxDriver@microchip.com, Woojung.Huh@microchip.com,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v3 net-next 05/10] net: dsa: microchip: add DSA support
 for microchip lan937x
Message-ID: <YQXJHA+z+hXjxe6+@lunn.ch>
References: <20210723173108.459770-1-prasanna.vengateshan@microchip.com>
 <20210723173108.459770-6-prasanna.vengateshan@microchip.com>
 <20210731150416.upe5nwkwvwajhwgg@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210731150416.upe5nwkwvwajhwgg@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > +void lan937x_mac_config(struct ksz_device *dev, int port,
> > +			phy_interface_t interface)
> > +{
> > +	u8 data8;
> > +
> > +	lan937x_pread8(dev, port, REG_PORT_XMII_CTRL_1, &data8);
> > +
> > +	/* clear MII selection & set it based on interface later */
> > +	data8 &= ~PORT_MII_SEL_M;
> > +
> > +	/* configure MAC based on interface */
> > +	switch (interface) {
> > +	case PHY_INTERFACE_MODE_MII:
> > +		lan937x_config_gbit(dev, false, &data8);
> > +		data8 |= PORT_MII_SEL;
> > +		break;
> > +	case PHY_INTERFACE_MODE_RMII:
> > +		lan937x_config_gbit(dev, false, &data8);
> > +		data8 |= PORT_RMII_SEL;
> > +		break;
> > +	case PHY_INTERFACE_MODE_RGMII:
> > +	case PHY_INTERFACE_MODE_RGMII_ID:
> > +	case PHY_INTERFACE_MODE_RGMII_TXID:
> > +	case PHY_INTERFACE_MODE_RGMII_RXID:
> > +		lan937x_config_gbit(dev, true, &data8);
> > +		data8 |= PORT_RGMII_SEL;
> > +
> > +		/* Add RGMII internal delay for cpu port*/
> > +		if (dsa_is_cpu_port(dev->ds, port)) {
> 
> Why only for the CPU port? I would like Andrew/Florian to have a look
> here, I guess the assumption is that if the port has a phy-handle, the
> RGMII delays should be dealt with by the PHY, but the logic seems to be
> "is a CPU port <=> has a phy-handle / isn't a CPU port <=> doesn't have
> a phy-handle"? What if it's a fixed-link port connected to a downstream
> switch, for which this one is a DSA master?

The marvell driver applies delays unconditionally. And as far as i
remember, it is only used in the use case you suggest, a DSA link,
which is using RGMII. For marvell switches, that is pretty unusual,
most boards use 1000BaseX or higher SERDES speeds for links between
switches.

I'm not sure if we have the case of an external PHY using RGMII. I
suspect it might actually be broken, because i think both the MAC and
the PHY might add the same delay. For phylib in general, if the MAC
applies the delays, it needs to manipulate the value passed to the PHY
so it also does not add delays. And i'm not sure DSA does that.

So limiting RGMII delays to only the CPU port is not
unreasonable. However, i suspect you are correct about chained
switches not working.

We might need to look at this at a higher level, when the PHY is
connected to the MAC and what mode gets passed to it.
 
> > +			if (interface == PHY_INTERFACE_MODE_RGMII_ID ||
> > +			    interface == PHY_INTERFACE_MODE_RGMII_RXID)
> > +				data8 |= PORT_RGMII_ID_IG_ENABLE;
> > +
> > +			if (interface == PHY_INTERFACE_MODE_RGMII_ID ||
> > +			    interface == PHY_INTERFACE_MODE_RGMII_TXID)
> > +				data8 |= PORT_RGMII_ID_EG_ENABLE;
> > +		}
> > +		break;
> > +	default:
> > +		dev_err(dev->dev, "Unsupported interface '%s' for port %d\n",
> > +			phy_modes(interface), port);
> > +		return;
> > +	}
> > +
> > +	/* Write the updated value */
> > +	lan937x_pwrite8(dev, port, REG_PORT_XMII_CTRL_1, data8);
> > +}
> 
> > +static int lan937x_mdio_register(struct dsa_switch *ds)
> > +{
> > +	struct ksz_device *dev = ds->priv;
> > +	int ret;
> > +
> > +	dev->mdio_np = of_get_child_by_name(ds->dev->of_node, "mdio");
> 
> So you support both the cases where an internal PHY is described using
> OF bindings, and where the internal PHY is implicitly accessed using the
> slave_mii_bus of the switch, at a PHY address equal to the port number,
> and with no phy-handle or fixed-link device tree property for that port?
> 
> Do you need both alternatives? The first is already more flexible than
> the second.

The first is also much more verbose in DT, and the second generally
just works without any DT. What can be tricky with the second is
getting PHY interrupts to work, but it is possible, the mv88e6xxx does
it.

	Andrew
