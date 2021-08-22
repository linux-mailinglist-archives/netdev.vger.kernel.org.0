Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F17E33F4240
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 01:04:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233578AbhHVXFF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Aug 2021 19:05:05 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:35644 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229969AbhHVXFF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 22 Aug 2021 19:05:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=kqOfZkiM1fyfpjgWvAbrg98C0JSgqONnGqU5IgTuDKI=; b=eM
        6yHnyx12LFME3b4CXIee/lD+4DJNhNesTxbSF3A0s5aZ+l49jP8TUqPr3HBZFD5xeecX4iEw0DAgr
        JOFMD444KQm87wGRtD58kQM6Ob/MWOwAynh7kpqJedAWm6E7DvaPaQO+CQ1Z8qLvxVVaxVH65wqsX
        0EGAiIl5bheGX9M=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mHwVi-003O3n-BN; Mon, 23 Aug 2021 01:04:14 +0200
Date:   Mon, 23 Aug 2021 01:04:14 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Alvin =?utf-8?Q?=C5=A0ipraga?= <alvin@pqrs.dk>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, mir@bang-olufsen.dk,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH net-next 4/5] net: dsa: realtek-smi: add rtl8365mb
 subdriver for RTL8365MB-VC
Message-ID: <YSLX7qhyZ4YGec83@lunn.ch>
References: <20210822193145.1312668-1-alvin@pqrs.dk>
 <20210822193145.1312668-5-alvin@pqrs.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210822193145.1312668-5-alvin@pqrs.dk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Signed-off-by: Alvin Šipraga <alsi@bang-olufsen.dk>
> Co-developed-by: Michael Rasmussen <mir@bang-olufsen.dk>
> Signed-off-by: Michael Rasmussen <mir@bang-olufsen.dk>

Hi Alvin

Since you are submitting the patch, your SOB goes last.

> +/* Port mapping macros
> + *
> + * PORT_NUM_x2y: map a port number from domain x to domain y
> + * PORT_MASK_x2y: map a port mask from domain x to domain y
> + *
> + * L = logical port domain, i.e. dsa_port.index
> + * P = physical port domain, used by the Realtek ASIC for port indexing;
> + *     for ports with internal PHYs, this is also the PHY index
> + * E = extension port domain, used by the Realtek ASIC for managing EXT ports
> + *
> + * The terminology is borrowed from the vendor driver. The extension port domain
> + * is mostly used to navigate the labyrinthine layout of EXT port configuration
> + * registers and is not considered intuitive by the author.
> + *
> + * Unless a function is accessing chip registers, it should be using the logical
> + * port domain. Moreover, function arguments for port numbers and port masks
> + * must always be in the logical domain. The conversion must be done as close as
> + * possible to the register access to avoid chaos.
> + *
> + * The mappings vary between chips in the family supported by this driver. Here
> + * is an example of the mapping for the RTL8365MB-VC:
> + *
> + *    L | P | E | remark
> + *   ---+---+---+--------
> + *    0 | 0 |   | user port
> + *    1 | 1 |   | user port
> + *    2 | 2 |   | user port
> + *    3 | 3 |   | user port
> + *    4 | 6 | 1 | extension (CPU) port

Did you consider not bothering with this. Just always use the Physical
port number? The DSA framework does not care if there are ports
missing. If it makes the code simpler, ignore the logical number, and
just enforce that the missing ports are not used, by returning -EINVAL
in the port_enable() callback.

> +/* Interrupt control register - enable or disable specific interrupt types */
> +#define RTL8365MB_INTR_CTRL				0x1101
> +#define   RTL8365MB_INTR_CTRL_SLIENT_START_2_MASK	0x1000
> +#define   RTL8365MB_INTR_CTRL_SLIENT_START_MASK		0x800
> +#define   RTL8365MB_INTR_CTRL_ACL_ACTION_MASK		0x200
> +#define   RTL8365MB_INTR_CTRL_CABLE_DIAG_FIN_MASK	0x100
> +#define   RTL8365MB_INTR_CTRL_INTERRUPT_8051_MASK	0x80
> +#define   RTL8365MB_INTR_CTRL_LOOP_DETECTION_MASK	0x40
> +#define   RTL8365MB_INTR_CTRL_GREEN_TIMER_MASK		0x20
> +#define   RTL8365MB_INTR_CTRL_SPECIAL_CONGEST_MASK	0x10
> +#define   RTL8365MB_INTR_CTRL_SPEED_CHANGE_MASK		0x8
> +#define   RTL8365MB_INTR_CTRL_LEARN_OVER_MASK		0x4
> +#define   RTL8365MB_INTR_CTRL_METER_EXCEEDED_MASK	0x2
> +#define   RTL8365MB_INTR_CTRL_LINK_CHANGE_MASK		0x1
> +
> +
> +/* Interrupt status register */
> +#define RTL8365MB_INTR_STATUS_REG			0x1102
> +#define   RTL8365MB_INTR_STATUS_SLIENT_START_2_MASK	0x1000
> +#define   RTL8365MB_INTR_STATUS_SLIENT_START_MASK	0x800
> +#define   RTL8365MB_INTR_STATUS_ACL_ACTION_MASK		0x200
> +#define   RTL8365MB_INTR_STATUS_CABLE_DIAG_FIN_MASK	0x100
> +#define   RTL8365MB_INTR_STATUS_INTERRUPT_8051_MASK	0x80
> +#define   RTL8365MB_INTR_STATUS_LOOP_DETECTION_MASK	0x40
> +#define   RTL8365MB_INTR_STATUS_GREEN_TIMER_MASK	0x20
> +#define   RTL8365MB_INTR_STATUS_SPECIAL_CONGEST_MASK	0x10
> +#define   RTL8365MB_INTR_STATUS_SPEED_CHANGE_MASK	0x8
> +#define   RTL8365MB_INTR_STATUS_LEARN_OVER_MASK		0x4
> +#define   RTL8365MB_INTR_STATUS_METER_EXCEEDED_MASK	0x2
> +#define   RTL8365MB_INTR_STATUS_LINK_CHANGE_MASK	0x1
> +#define   RTL8365MB_INTR_STATUS_ALL_MASK                      \

Interrupt control and status registers are generally identical. So you
don't need to define the values twice.

 +static void rtl8365mb_phylink_validate(struct dsa_switch *ds, int port,
> +				       unsigned long *supported,
> +				       struct phylink_link_state *state)
> +{
> +	struct realtek_smi *smi = ds->priv;
> +	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0 };
> +
> +	/* include/linux/phylink.h says:
> +	 *     When @state->interface is %PHY_INTERFACE_MODE_NA, phylink
> +	 *     expects the MAC driver to return all supported link modes.
> +	 */
> +	if (state->interface != PHY_INTERFACE_MODE_NA &&
> +	    !rtl8365mb_phy_mode_supported(ds, port, state->interface)) {
> +		dev_err(smi->dev, "phy mode %s is unsupported on port %d\n",
> +			phy_modes(state->interface), port);
> +		linkmode_zero(supported);
> +		return;
> +	}
> +
> +	phylink_set_port_modes(mask);
> +
> +	phylink_set(mask, Autoneg);
> +	phylink_set(mask, Pause);
> +	phylink_set(mask, Asym_Pause);
> +
> +	phylink_set(mask, 10baseT_Half);
> +	phylink_set(mask, 10baseT_Full);
> +	phylink_set(mask, 100baseT_Half);
> +	phylink_set(mask, 100baseT_Full);
> +	phylink_set(mask, 1000baseT_Full);
> +	phylink_set(mask, 1000baseT_Half);

Does the documentation actually mention 1000baseT_Half? Often it is
not implemented.

> +static int rtl8365mb_port_enable(struct dsa_switch *ds, int port,
> +				 struct phy_device *phy)
> +{
> +	struct realtek_smi *smi = ds->priv;
> +	int val;
> +
> +	if (dsa_is_user_port(ds, port)) {
> +		/* Power up the internal PHY and restart autonegotiation */
> +		val = rtl8365mb_phy_read(smi, port, MII_BMCR);
> +		if (val < 0)
> +			return val;
> +
> +		val &= ~BMCR_PDOWN;
> +		val |= BMCR_ANRESTART;
> +
> +		return rtl8365mb_phy_write(smi, port, MII_BMCR, val);
> +	}

There should not be any need to do this. phylib should do it. In
generally, you should not need to touch any PHY registers, you just
need to allow access to the PHY registers.

I want to take another look at the interrupt code. But this looks
pretty nice in general.

       Andrew
