Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9E9FD91D9
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 15:01:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391656AbfJPNBP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 09:01:15 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:48348 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728878AbfJPNBP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Oct 2019 09:01:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=BAfO031wkM2nBG9tuVmAEJLRsTorfk1k6nlx8Yt3qAQ=; b=JXRIjv2J8zjrcgPeaWIqx92ho8
        Z+FyMW8BZ6tISPZqyhIfHG+ZjmCbTZ9Y7R/e/3vLAV5ss8dwIxoi/Hv21oyiTJ66aJEIfaP8gEvSj
        zztwk2nzj17NjxVKTxPU7opLJORhZHC25Z1fG3dassVmdVDTzLkXZJItW6lWjMnM35/Y=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iKivB-0007UA-H6; Wed, 16 Oct 2019 15:00:57 +0200
Date:   Wed, 16 Oct 2019 15:00:57 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Chris Snook <chris.snook@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        James Hogan <jhogan@kernel.org>,
        Jay Cliburn <jcliburn@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Paul Burton <paul.burton@mips.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-mips@vger.kernel.org
Subject: Re: [PATCH v1 4/4] net: dsa: add support for Atheros AR9331 build-in
 switch
Message-ID: <20191016130057.GF4780@lunn.ch>
References: <20191014061549.3669-1-o.rempel@pengutronix.de>
 <20191014061549.3669-5-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191014061549.3669-5-o.rempel@pengutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +++ b/drivers/net/dsa/qca/ar9331.c
> @@ -0,0 +1,822 @@
> +// SPDX-License-Identifier: GPL-2.0-only

I think C files should use /*  */, and header files //, for SPDX.

> +// Copyright (c) 2019 Pengutronix, Oleksij Rempel <kernel@pengutronix.de>
> +
> +#include <linux/bitfield.h>
> +#include <linux/module.h>
> +#include <linux/of_irq.h>
> +#include <linux/of_mdio.h>
> +#include <linux/regmap.h>
> +#include <linux/reset.h>
> +#include <net/dsa.h>
> +
> +#define AR9331_SW_NAME				"ar9331_switch"
> +#define AR9331_SW_PORTS				6
> +
> +/* dummy reg to change page */
> +#define AR9331_SW_REG_PAGE			BIT(18)
> +
> +/* Global Interrupt */
> +#define AR9331_SW_REG_GINT			0x10
> +#define AR9331_SW_REG_GINT_MASK			0x14
> +#define AR9331_SW_GINT_PHY_INT			BIT(2)
> +
> +#define AR9331_SW_REG_FLOOD_MASK		0x2c
> +#define AR9331_SW_FLOOD_MASK_BROAD_TO_CPU	BIT(26)
> +
> +#define AR9331_SW_REG_GLOBAL_CTRL		0x30
> +#define AR9331_SW_GLOBAL_CTRL_MFS_M		GENMASK(13, 0)
> +
> +#define AR9331_SW_REG_MDIO_CTRL			0x98
> +#define AR9331_SW_MDIO_CTRL_BUSY		BIT(31)
> +#define AR9331_SW_MDIO_CTRL_MASTER_EN		BIT(30)
> +#define AR9331_SW_MDIO_CTRL_CMD_READ		BIT(27)
> +#define AR9331_SW_MDIO_CTRL_PHY_ADDR_M		GENMASK(25, 21)
> +#define AR9331_SW_MDIO_CTRL_REG_ADDR_M		GENMASK(20, 16)
> +#define AR9331_SW_MDIO_CTRL_DATA_M		GENMASK(16, 0)
> +
> +#define AR9331_SW_REG_PORT_STATUS(_port)	(0x100 + (_port) * 0x100)
> +
> +/* FLOW_LINK_EN - enable mac flow control config auto-neg with phy.
> + * If not set, mac can be config by software.
> + */
> +#define AR9331_SW_PORT_STATUS_FLOW_LINK_EN	BIT(12)
> +
> +/* LINK_EN - If set, MAC is configured from PHY link status.
> + * If not set, MAC should be configured by software.
> + */
> +#define AR9331_SW_PORT_STATUS_LINK_EN		BIT(9)
> +#define AR9331_SW_PORT_STATUS_DUPLEX_MODE	BIT(6)
> +#define AR9331_SW_PORT_STATUS_RX_FLOW_EN	BIT(5)
> +#define AR9331_SW_PORT_STATUS_TX_FLOW_EN	BIT(4)
> +#define AR9331_SW_PORT_STATUS_RXMAC		BIT(3)
> +#define AR9331_SW_PORT_STATUS_TXMAC		BIT(2)
> +#define AR9331_SW_PORT_STATUS_SPEED_M		GENMASK(1, 0)
> +#define AR9331_SW_PORT_STATUS_SPEED_1000	2
> +#define AR9331_SW_PORT_STATUS_SPEED_100		1
> +#define AR9331_SW_PORT_STATUS_SPEED_10		0
> +
> +#define AR9331_SW_PORT_STATUS_MAC_MASK \
> +	(AR9331_SW_PORT_STATUS_TXMAC | AR9331_SW_PORT_STATUS_RXMAC)
> +
> +#define AR9331_SW_PORT_STATUS_LINK_MASK \
> +	(AR9331_SW_PORT_STATUS_LINK_EN | AR9331_SW_PORT_STATUS_FLOW_LINK_EN | \
> +	 AR9331_SW_PORT_STATUS_DUPLEX_MODE | \
> +	 AR9331_SW_PORT_STATUS_RX_FLOW_EN | AR9331_SW_PORT_STATUS_TX_FLOW_EN | \
> +	 AR9331_SW_PORT_STATUS_SPEED_M)
> +
> +/* Phy bypass mode
> + * ------------------------------------------------------------------------
> + * Bit:   | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 |10 |11 |12 |13 |14 |15 |
> + *
> + * real   | start |   OP  | PhyAddr           |  Reg Addr         |  TA   |
> + * atheros| start |   OP  | 2'b00 |PhyAdd[2:0]|  Reg Addr[4:0]    |  TA   |
> + *
> + *
> + * Bit:   |16 |17 |18 |19 |20 |21 |22 |23 |24 |25 |26 |27 |28 |29 |30 |31 |
> + * real   |  Data                                                         |
> + * atheros|  Data                                                         |
> + *
> + * ------------------------------------------------------------------------
> + * Page address mode
> + * ------------------------------------------------------------------------
> + * Bit:   | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 |10 |11 |12 |13 |14 |15 |
> + * real   | start |   OP  | PhyAddr           |  Reg Addr         |  TA   |
> + * atheros| start |   OP  | 2'b11 |                          8'b0 |  TA   |
> + *
> + * Bit:   |16 |17 |18 |19 |20 |21 |22 |23 |24 |25 |26 |27 |28 |29 |30 |31 |
> + * real   |  Data                                                         |
> + * atheros|                       | Page [9:0]                            |
> + */
> +/* In case of Page Address mode, Bit[18:9] of 32 bit register address should be
> + * written to bits[9:0] of mdio data register.
> + */
> +#define AR9331_SW_ADDR_PAGE			GENMASK(18, 9)
> +
> +/* ------------------------------------------------------------------------
> + * Normal register access mode
> + * ------------------------------------------------------------------------
> + * Bit:   | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 |10 |11 |12 |13 |14 |15 |
> + * real   | start |   OP  | PhyAddr           |  Reg Addr         |  TA   |
> + * atheros| start |   OP  | 2'b10 |  low_addr[7:0]                |  TA   |
> + *
> + * Bit:   |16 |17 |18 |19 |20 |21 |22 |23 |24 |25 |26 |27 |28 |29 |30 |31 |
> + * real   |  Data                                                         |
> + * atheros|  Data                                                         |
> + * ------------------------------------------------------------------------
> + */
> +#define AR9331_SW_LOW_ADDR_PHY			GENMASK(8, 6)
> +#define AR9331_SW_LOW_ADDR_REG			GENMASK(5, 1)
> +
> +#define AR9331_SW_MDIO_PHY_MODE_M		GENMASK(4, 3)
> +#define AR9331_SW_MDIO_PHY_MODE_PAGE		3
> +#define AR9331_SW_MDIO_PHY_MODE_REG		2
> +#define AR9331_SW_MDIO_PHY_MODE_BYPASS		0
> +#define AR9331_SW_MDIO_PHY_ADDR_M		GENMASK(2, 0)
> +
> +/* Empirical determined values */
> +#define AR9331_SW_MDIO_POLL_SLEEP_US		1
> +#define AR9331_SW_MDIO_POLL_TIMEOUT_US		20
> +
> +struct ar9331_sw_priv {
> +	struct device *dev;
> +	struct dsa_switch *ds;
> +	struct dsa_switch_ops ops;
> +	struct irq_domain *irqdomain;
> +	struct mii_bus *mbus; /* mdio master */
> +	struct mii_bus *sbus; /* mdio slave */
> +	struct regmap *regmap;
> +	struct reset_control *sw_reset;
> +};
> +
> +/* Warning: switch reset will reset last AR9331_SW_MDIO_PHY_MODE_PAGE request
> + * If some kind of optimization is used, the request should be repeated.
> + */
> +static int ar9331_sw_reset(struct ar9331_sw_priv *priv)
> +{
> +	int ret;
> +
> +	ret = reset_control_assert(priv->sw_reset);
> +	if (ret)
> +		goto error;
> +
> +	/* AR9331 doc do not provide any information about proper reset
> +	 * sequence. The AR8136 (the closes switch to the AR9331) doc says:
> +	 * reset duration should be greater than 10ms. So, let's use this value
> +	 * for now.
> +	 */
> +	usleep_range(10000, 15000);
> +	ret = reset_control_deassert(priv->sw_reset);
> +	if (ret)
> +		goto error;

Any comments in the documentation about needing to wait for the reset
to complete?


> +
> +	return 0;
> +error:
> +	dev_err_ratelimited(priv->dev, "%s: %i\n", __func__, ret);
> +	return ret;
> +}
> +
> +static int ar9331_sw_mbus_write(struct mii_bus *mbus, int port, int regnum,
> +				u16 data)
> +{
> +	struct ar9331_sw_priv *priv = mbus->priv;
> +	struct regmap *regmap = priv->regmap;
> +	u32 val;
> +	int ret;
> +
> +	ret = regmap_write(regmap, AR9331_SW_REG_MDIO_CTRL,
> +			   AR9331_SW_MDIO_CTRL_BUSY |
> +			   AR9331_SW_MDIO_CTRL_MASTER_EN |
> +			   FIELD_PREP(AR9331_SW_MDIO_CTRL_PHY_ADDR_M, port) |
> +			   FIELD_PREP(AR9331_SW_MDIO_CTRL_REG_ADDR_M, regnum) |
> +			   FIELD_PREP(AR9331_SW_MDIO_CTRL_DATA_M, data));
> +	if (ret)
> +		goto error;
> +
> +	ret = regmap_read_poll_timeout(regmap, AR9331_SW_REG_MDIO_CTRL, val,
> +				       !(val & AR9331_SW_MDIO_CTRL_BUSY),
> +				       AR9331_SW_MDIO_POLL_SLEEP_US,
> +				       AR9331_SW_MDIO_POLL_TIMEOUT_US);
> +	if (ret)
> +		goto error;
> +
> +	return 0;
> +error:
> +	dev_err_ratelimited(priv->dev, "PHY write error: %i\n", ret);
> +	return ret;
> +}
> +
> +static int ar9331_sw_mbus_read(struct mii_bus *mbus, int port, int regnum)
> +{
> +	struct ar9331_sw_priv *priv = mbus->priv;
> +	struct regmap *regmap = priv->regmap;
> +	u32 val;
> +	int ret;
> +
> +	ret = regmap_write(regmap, AR9331_SW_REG_MDIO_CTRL,
> +			   AR9331_SW_MDIO_CTRL_BUSY |
> +			   AR9331_SW_MDIO_CTRL_MASTER_EN |
> +			   AR9331_SW_MDIO_CTRL_CMD_READ |
> +			   FIELD_PREP(AR9331_SW_MDIO_CTRL_PHY_ADDR_M, port) |
> +			   FIELD_PREP(AR9331_SW_MDIO_CTRL_REG_ADDR_M, regnum));
> +	if (ret)
> +		goto error;
> +
> +	ret = regmap_read_poll_timeout(regmap, AR9331_SW_REG_MDIO_CTRL, val,
> +				       !(val & AR9331_SW_MDIO_CTRL_BUSY),
> +				       AR9331_SW_MDIO_POLL_SLEEP_US,
> +				       AR9331_SW_MDIO_POLL_TIMEOUT_US);
> +	if (ret)
> +		goto error;
> +
> +	ret = regmap_read(regmap, AR9331_SW_REG_MDIO_CTRL, &val);
> +	if (ret)
> +		goto error;
> +
> +	return FIELD_GET(AR9331_SW_MDIO_CTRL_DATA_M, val);
> +
> +error:
> +	dev_err_ratelimited(priv->dev, "PHY read error: %i\n", ret);
> +	return ret;
> +}
> +
> +static int ar9331_sw_mbus_init(struct ar9331_sw_priv *priv)
> +{
> +	struct device *dev = priv->dev;
> +	static struct mii_bus *mbus;
> +	struct device_node *np, *mnp;
> +	int ret;
> +
> +	np = dev->of_node;
> +
> +	mbus = devm_mdiobus_alloc(dev);
> +	if (!mbus)
> +		return -ENOMEM;
> +
> +	mbus->name = np->full_name;
> +	snprintf(mbus->id, MII_BUS_ID_SIZE, "%pOF", np);
> +
> +	mbus->read = ar9331_sw_mbus_read;
> +	mbus->write = ar9331_sw_mbus_write;
> +	mbus->priv = priv;
> +	mbus->parent = dev;
> +
> +	mnp = of_get_child_by_name(np, "mdio");

You should check if mnp is NULL. You want it to mandatory. The current
code will pass NULL to of_mdiobus_register(), which is legal, and it
will look one level higher for the PHYs.


> +	ret = of_mdiobus_register(mbus, mnp);
> +	of_node_put(mnp);
> +	if (ret)
> +		return ret;
> +
> +	priv->mbus = mbus;
> +
> +	return 0;
> +}
> +
> +static int ar9331_sw_setup(struct dsa_switch *ds)
> +{
> +	struct ar9331_sw_priv *priv = (struct ar9331_sw_priv *)ds->priv;
> +	struct regmap *regmap = priv->regmap;
> +	int ret;
> +
> +	ret = ar9331_sw_reset(priv);
> +	if (ret)
> +		return ret;
> +
> +	/* Reset will set proper defaults. CPU - Port0 will be enabled and
> +	 * configured. All other ports (ports 1 - 5) are disabled
> +	 */

Nice, some hardware engineer thought about that.

> +	ret = ar9331_sw_mbus_init(priv);
> +	if (ret)
> +		return ret;
> +
> +	/* Do not drop broadcast frames */
> +	ret = regmap_write_bits(regmap, AR9331_SW_REG_FLOOD_MASK,
> +				AR9331_SW_FLOOD_MASK_BROAD_TO_CPU,
> +				AR9331_SW_FLOOD_MASK_BROAD_TO_CPU);
> +	if (ret)
> +		goto error;
> +
> +	/* Sync max frame size with value used in
> +	 * drivers/net/ethernet/atheros/ag71xx.c for ar9330 SoC.
> +	 * TODO: In both drivers this value seems to be not real maximal size
> +	 * The switch is able to configure 0x3fff and ethernet controller
> +	 * 0xffff. Are there any better way to sync this values?
> +	 */
> +	ret = regmap_write_bits(regmap, AR9331_SW_REG_GLOBAL_CTRL,
> +				AR9331_SW_GLOBAL_CTRL_MFS_M,
> +				FIELD_PREP(AR9331_SW_GLOBAL_CTRL_MFS_M, 1540));
> +	if (ret)
> +		goto error;

Jumbo is not so easy. I would avoid the plain number 1540. There
should be a #define. Also, you might want to allow space for a VLAN
header? Does enabbling jumbo have a performance impact? If not, you
can configure the switch to its maximum size.

> +
> +	return 0;
> +error:
> +	dev_err_ratelimited(priv->dev, "%s: %i\n", __func__, ret);
> +	return ret;
> +}
> +
> +static int ar9331_sw_port_enable(struct dsa_switch *ds, int port,
> +				 struct phy_device *phy)
> +{
> +	struct ar9331_sw_priv *priv = (struct ar9331_sw_priv *)ds->priv;
> +	struct regmap *regmap = priv->regmap;
> +	int ret;
> +
> +	/* nothing to enable. Just set link to initial state */
> +	ret = regmap_write(regmap, AR9331_SW_REG_PORT_STATUS(port), 0);
> +	if (ret)
> +		dev_err_ratelimited(priv->dev, "%s: %i\n", __func__, ret);
> +
> +	return ret;
> +}
> +
> +static void ar9331_sw_port_disable(struct dsa_switch *ds, int port)
> +{
> +	struct ar9331_sw_priv *priv = (struct ar9331_sw_priv *)ds->priv;
> +	struct regmap *regmap = priv->regmap;
> +	int ret;
> +
> +	ret = regmap_write(regmap, AR9331_SW_REG_PORT_STATUS(port), 0);
> +	if (ret)
> +		dev_err_ratelimited(priv->dev, "%s: %i\n", __func__, ret);
> +}

port_enable() and port_disable() look the same?

> +
> +static enum dsa_tag_protocol ar9331_sw_get_tag_protocol(struct dsa_switch *ds,
> +							int port)
> +{
> +	return DSA_TAG_PROTO_AR9331;
> +}
> +
> +static void ar9331_sw_phylink_validate(struct dsa_switch *ds, int port,
> +				       unsigned long *supported,
> +				       struct phylink_link_state *state)
> +{
> +	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
> +
> +	switch (port) {
> +	case 0:
> +		if (state->interface != PHY_INTERFACE_MODE_GMII)
> +			goto unsupported;
> +
> +		phylink_set(mask, 1000baseT_Full);
> +		phylink_set(mask, 1000baseT_Half);
> +		break;
> +	case 1:
> +	case 2:
> +	case 3:
> +	case 4:
> +	case 5:
> +		if (state->interface != PHY_INTERFACE_MODE_INTERNAL)
> +			goto unsupported;
> +		break;
> +	default:
> +		bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
> +		dev_err(ds->dev, "Unsupported port: %i\n", port);
> +		return;
> +	}
> +
> +	phylink_set_port_modes(mask);
> +	phylink_set(mask, Pause);
> +	phylink_set(mask, Asym_Pause);
> +
> +	phylink_set(mask, 10baseT_Half);
> +	phylink_set(mask, 10baseT_Full);
> +	phylink_set(mask, 100baseT_Half);
> +	phylink_set(mask, 100baseT_Full);

So the CPU port is 1G capable. All the other ports are only Fast Ethernet?

> +
> +	bitmap_and(supported, supported, mask,
> +		   __ETHTOOL_LINK_MODE_MASK_NBITS);
> +	bitmap_and(state->advertising, state->advertising, mask,
> +		   __ETHTOOL_LINK_MODE_MASK_NBITS);
> +
> +	return;
> +
> +unsupported:
> +	bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
> +	dev_err(ds->dev, "Unsupported interface: %d, port: %d\n",
> +		state->interface, port);
> +}
> +
> +static void ar9331_sw_phylink_mac_config(struct dsa_switch *ds, int port,
> +					 unsigned int mode,
> +					 const struct phylink_link_state *state)
> +{
> +	struct ar9331_sw_priv *priv = (struct ar9331_sw_priv *)ds->priv;
> +	struct regmap *regmap = priv->regmap;
> +	int ret;
> +	u32 val;
> +
> +	switch (state->speed) {
> +	case SPEED_1000:
> +		val = AR9331_SW_PORT_STATUS_SPEED_1000;
> +		break;
> +	case SPEED_100:
> +		val = AR9331_SW_PORT_STATUS_SPEED_100;
> +		break;
> +	case SPEED_10:
> +		val = AR9331_SW_PORT_STATUS_SPEED_10;
> +		break;
> +	default:
> +		return;
> +	}
> +
> +	if (state->duplex)
> +		val |= AR9331_SW_PORT_STATUS_DUPLEX_MODE;
> +
> +	if (state->pause & MLO_PAUSE_TX)
> +		val |= AR9331_SW_PORT_STATUS_TX_FLOW_EN;
> +
> +	if (state->pause & MLO_PAUSE_RX)
> +		val |= AR9331_SW_PORT_STATUS_RX_FLOW_EN;
> +
> +	ret = regmap_update_bits(regmap, AR9331_SW_REG_PORT_STATUS(port),
> +				 AR9331_SW_PORT_STATUS_LINK_MASK, val);
> +	if (ret)
> +		dev_err_ratelimited(priv->dev, "%s: %i\n", __func__, ret);
> +}
> +
> +static void ar9331_sw_phylink_mac_link_down(struct dsa_switch *ds, int port,
> +					    unsigned int mode,
> +					    phy_interface_t interface)
> +{
> +	struct ar9331_sw_priv *priv = (struct ar9331_sw_priv *)ds->priv;
> +	struct regmap *regmap = priv->regmap;
> +	int ret;
> +
> +	ret = regmap_update_bits(regmap, AR9331_SW_REG_PORT_STATUS(port),
> +				 AR9331_SW_PORT_STATUS_MAC_MASK, 0);
> +	if (ret)
> +		dev_err_ratelimited(priv->dev, "%s: %i\n", __func__, ret);
> +}
> +
> +static void ar9331_sw_phylink_mac_link_up(struct dsa_switch *ds, int port,
> +					  unsigned int mode,
> +					  phy_interface_t interface,
> +					  struct phy_device *phydev)
> +{
> +	struct ar9331_sw_priv *priv = (struct ar9331_sw_priv *)ds->priv;
> +	struct regmap *regmap = priv->regmap;
> +	int ret;
> +
> +	ret = regmap_update_bits(regmap, AR9331_SW_REG_PORT_STATUS(port),
> +				 AR9331_SW_PORT_STATUS_MAC_MASK,
> +				 AR9331_SW_PORT_STATUS_MAC_MASK);
> +	if (ret)
> +		dev_err_ratelimited(priv->dev, "%s: %i\n", __func__, ret);
> +}
> +
> +static const struct dsa_switch_ops ar9331_sw_ops = {
> +	.get_tag_protocol = ar9331_sw_get_tag_protocol,
> +	.setup = ar9331_sw_setup,
> +	.port_enable = ar9331_sw_port_enable,
> +	.port_disable = ar9331_sw_port_disable,
> +	.phylink_validate	= ar9331_sw_phylink_validate,
> +	.phylink_mac_config	= ar9331_sw_phylink_mac_config,
> +	.phylink_mac_link_down	= ar9331_sw_phylink_mac_link_down,
> +	.phylink_mac_link_up	= ar9331_sw_phylink_mac_link_up,
> +};
> +
> +static irqreturn_t ar9331_sw_irq(int irq, void *data)
> +{
> +	struct ar9331_sw_priv *priv = data;
> +	struct regmap *regmap = priv->regmap;
> +	u32 stat;
> +	int ret;
> +
> +	ret = regmap_read(regmap, AR9331_SW_REG_GINT, &stat);
> +	if (ret) {
> +		dev_err(priv->dev, "can't read interrupt status\n");
> +		return IRQ_NONE;
> +	}
> +
> +	if (!stat)
> +		return IRQ_NONE;
> +
> +	if (stat & AR9331_SW_GINT_PHY_INT) {
> +		int child_irq;
> +
> +		child_irq = irq_find_mapping(priv->irqdomain, 0);
> +		handle_nested_irq(child_irq);
> +	}
> +
> +	ret = regmap_write(regmap, AR9331_SW_REG_GINT, stat);
> +	if (ret) {
> +		dev_err(priv->dev, "can't write interrupt status\n");
> +		return IRQ_NONE;
> +	}
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static void ar9331_sw_mask_irq(struct irq_data *d)
> +{
> +	struct ar9331_sw_priv *priv = irq_data_get_irq_chip_data(d);
> +	struct regmap *regmap = priv->regmap;
> +	int ret;
> +
> +	ret = regmap_update_bits(regmap, AR9331_SW_REG_GINT_MASK,
> +				 AR9331_SW_GINT_PHY_INT, 0);
> +	if (ret)
> +		dev_err(priv->dev, "could not mask IRQ\n");
> +}
> +
> +static void ar9331_sw_unmask_irq(struct irq_data *d)
> +{
> +	struct ar9331_sw_priv *priv = irq_data_get_irq_chip_data(d);
> +	struct regmap *regmap = priv->regmap;
> +	int ret;
> +
> +	ret = regmap_update_bits(regmap, AR9331_SW_REG_GINT_MASK,
> +				 AR9331_SW_GINT_PHY_INT,
> +				 AR9331_SW_GINT_PHY_INT);
> +	if (ret)
> +		dev_err(priv->dev, "could not unmask IRQ\n");
> +}
> +
> +static struct irq_chip ar9331_sw_irq_chip = {
> +	.name = AR9331_SW_NAME,
> +	.irq_mask = ar9331_sw_mask_irq,
> +	.irq_unmask = ar9331_sw_unmask_irq,
> +};
> +
> +static int ar9331_sw_irq_map(struct irq_domain *domain, unsigned int irq,
> +			     irq_hw_number_t hwirq)
> +{
> +	irq_set_chip_data(irq, domain->host_data);
> +	irq_set_chip_and_handler(irq, &ar9331_sw_irq_chip, handle_simple_irq);
> +	irq_set_nested_thread(irq, 1);
> +	irq_set_noprobe(irq);
> +
> +	return 0;
> +}
> +
> +static void ar9331_sw_irq_unmap(struct irq_domain *d, unsigned int irq)
> +{
> +	irq_set_nested_thread(irq, 0);
> +	irq_set_chip_and_handler(irq, NULL, NULL);
> +	irq_set_chip_data(irq, NULL);
> +}
> +
> +static const struct irq_domain_ops ar9331_sw_irqdomain_ops = {
> +	.map = ar9331_sw_irq_map,
> +	.unmap = ar9331_sw_irq_unmap,
> +	.xlate = irq_domain_xlate_onecell,
> +};
> +
> +static int ar9331_sw_irq_init(struct ar9331_sw_priv *priv)
> +{
> +	struct device_node *np = priv->dev->of_node;
> +	struct device *dev = priv->dev;
> +	int ret, irq;
> +
> +	irq = of_irq_get(np, 0);
> +	if (irq <= 0) {
> +		dev_err(dev, "failed to get parent IRQ\n");
> +		return irq ? irq : -EINVAL;
> +	}
> +
> +	ret = devm_request_threaded_irq(dev, irq, NULL, ar9331_sw_irq,
> +					IRQF_ONESHOT, AR9331_SW_NAME, priv);
> +	if (ret) {
> +		dev_err(dev, "unable to request irq: %d\n", ret);
> +		return ret;
> +	}
> +
> +	priv->irqdomain = irq_domain_add_linear(np, 1, &ar9331_sw_irqdomain_ops,
> +						priv);
> +	if (!priv->irqdomain) {
> +		dev_err(dev, "failed to create IRQ domain\n");
> +		return -EINVAL;
> +	}
> +
> +	irq_set_parent(irq_create_mapping(priv->irqdomain, 0), irq);
> +
> +	return 0;
> +}
> +
> +static int __ar9331_mdio_write(struct mii_bus *sbus, u8 mode, u16 reg, u16 val)
> +{
> +	u8 r, p;
> +
> +	p = FIELD_PREP(AR9331_SW_MDIO_PHY_MODE_M, mode) |
> +		FIELD_GET(AR9331_SW_LOW_ADDR_PHY, reg);
> +	r = FIELD_GET(AR9331_SW_LOW_ADDR_REG, reg);
> +
> +	return sbus->write(sbus, p, r, val);

Why not use the mdiobus_write() and mdiobus_read()?

> +static int ar9331_sw_probe(struct mdio_device *mdiodev)
> +{
> +	struct ar9331_sw_priv *priv;
> +	int ret;
> +
> +	/* allocate the private data struct so that we can probe the switches
> +	 * ID register
> +	 */

I don't see the code actually getting the ID register?


> +	priv = devm_kzalloc(&mdiodev->dev, sizeof(*priv), GFP_KERNEL);
> +	if (!priv)
> +		return -ENOMEM;
> +
> +	priv->regmap = devm_regmap_init(&mdiodev->dev, &ar9331_sw_bus, priv,
> +					&ar9331_mdio_regmap_config);
> +	if (IS_ERR(priv->regmap)) {
> +		ret = PTR_ERR(priv->regmap);
> +		dev_err(&mdiodev->dev, "regmap init failed: %d\n", ret);
> +		return ret;
> +	}
> +
> +	priv->sw_reset = devm_reset_control_get(&mdiodev->dev, "switch");
> +	if (IS_ERR(priv->sw_reset)) {
> +		dev_err(&mdiodev->dev, "missing switch reset\n");
> +		return PTR_ERR(priv->sw_reset);
> +	}
> +
> +	priv->sbus = mdiodev->bus;
> +	priv->dev = &mdiodev->dev;
> +
> +	ret = ar9331_sw_irq_init(priv);
> +	if (ret)
> +		return ret;
> +
> +	priv->ds = dsa_switch_alloc(&mdiodev->dev, AR9331_SW_PORTS);
> +	if (!priv->ds)
> +		return -ENOMEM;
> +
> +	priv->ds->priv = priv;
> +	priv->ops = ar9331_sw_ops;
> +	priv->ds->ops = &priv->ops;
> +	dev_set_drvdata(&mdiodev->dev, priv);
> +
> +	return dsa_register_switch(priv->ds);
> +}
> +
> +static void ar9331_sw_remove(struct mdio_device *mdiodev)
> +{
> +	struct ar9331_sw_priv *priv = dev_get_drvdata(&mdiodev->dev);
> +
> +	mdiobus_unregister(priv->mbus);
> +	dsa_unregister_switch(priv->ds);
> +
> +	reset_control_assert(priv->sw_reset);
> +}
> +
> +static const struct of_device_id ar9331_sw_of_match[] = {
> +	{ .compatible = "qca,ar9331-switch" },
> +	{ },
> +};
> +
> +static struct mdio_driver ar9331_sw_mdio_driver = {
> +	.probe = ar9331_sw_probe,
> +	.remove = ar9331_sw_remove,
> +	.mdiodrv.driver = {
> +		.name = AR9331_SW_NAME,
> +		.of_match_table = ar9331_sw_of_match,
> +	},
> +};
> +
> +mdio_module_driver(ar9331_sw_mdio_driver);
> +
> +MODULE_AUTHOR("Oleksij Rempel <kernel@pengutronix.de>");
> +MODULE_DESCRIPTION("Driver for Atheros AR9331 switch");
> +MODULE_LICENSE("GPL v2");
> diff --git a/include/net/dsa.h b/include/net/dsa.h
> index 541fb514e31d..89a334e68d42 100644
> --- a/include/net/dsa.h
> +++ b/include/net/dsa.h
> @@ -42,6 +42,7 @@ struct phylink_link_state;
>  #define DSA_TAG_PROTO_8021Q_VALUE		12
>  #define DSA_TAG_PROTO_SJA1105_VALUE		13
>  #define DSA_TAG_PROTO_KSZ8795_VALUE		14
> +#define DSA_TAG_PROTO_AR9331_VALUE		15
>  
>  enum dsa_tag_protocol {
>  	DSA_TAG_PROTO_NONE		= DSA_TAG_PROTO_NONE_VALUE,
> @@ -59,6 +60,7 @@ enum dsa_tag_protocol {
>  	DSA_TAG_PROTO_8021Q		= DSA_TAG_PROTO_8021Q_VALUE,
>  	DSA_TAG_PROTO_SJA1105		= DSA_TAG_PROTO_SJA1105_VALUE,
>  	DSA_TAG_PROTO_KSZ8795		= DSA_TAG_PROTO_KSZ8795_VALUE,
> +	DSA_TAG_PROTO_AR9331		= DSA_TAG_PROTO_AR9331_VALUE,
>  };
>  
>  struct packet_type;
> diff --git a/net/dsa/Kconfig b/net/dsa/Kconfig
> index 29e2bd5cc5af..6e015309a7fe 100644
> --- a/net/dsa/Kconfig
> +++ b/net/dsa/Kconfig
> @@ -107,4 +107,10 @@ config NET_DSA_TAG_TRAILER
>  	  Say Y or M if you want to enable support for tagging frames at
>  	  with a trailed. e.g. Marvell 88E6060.
>  
> +config NET_DSA_TAG_AR9331
> +	tristate "Tag driver for Atheros AR9331 SoC with build-in switch"
> +	help
> +	  Say Y or M if you want to enable support for tagging frames for
> +	  the Atheros AR9331 SoC with build-in switch.
> +

These are somewhat sorted, based on the tristate string. So this
should go before NET_DSA_TAG_BRCM_COMMON.


>  endif
> diff --git a/net/dsa/Makefile b/net/dsa/Makefile
> index 2c6d286f0511..67caebf602be 100644
> --- a/net/dsa/Makefile
> +++ b/net/dsa/Makefile
> @@ -15,3 +15,4 @@ obj-$(CONFIG_NET_DSA_TAG_MTK) += tag_mtk.o
>  obj-$(CONFIG_NET_DSA_TAG_QCA) += tag_qca.o
>  obj-$(CONFIG_NET_DSA_TAG_SJA1105) += tag_sja1105.o
>  obj-$(CONFIG_NET_DSA_TAG_TRAILER) += tag_trailer.o
> +obj-$(CONFIG_NET_DSA_TAG_AR9331) += tag_ar9331.o

Please keep with the sorting.

> diff --git a/net/dsa/tag_ar9331.c b/net/dsa/tag_ar9331.c
> new file mode 100644
> index 000000000000..b32a8d3d48b9
> --- /dev/null
> +++ b/net/dsa/tag_ar9331.c
> @@ -0,0 +1,97 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (c) 2019 Pengutronix, Oleksij Rempel <kernel@pengutronix.de>
> + */
> +
> +
> +#include <linux/bitfield.h>
> +#include <linux/etherdevice.h>
> +
> +#include "dsa_priv.h"
> +
> +#define AR9331_HDR_LEN			2
> +#define AR9331_HDR_VERSION		1
> +
> +#define AR9331_HDR_VERSION_MASK		GENMASK(15, 14)
> +#define AR9331_HDR_PRIORITY_MASK	GENMASK(13, 12)
> +#define AR9331_HDR_TYPE_MASK		GENMASK(10, 8)
> +#define AR9331_HDR_BROADCAST		BIT(7)
> +#define AR9331_HDR_FROM_CPU		BIT(6)
> +/* AR9331_HDR_RESERVED - not used or may be version filed.

field

> + * According to the AR8216 doc it should 0b10. On AR9331 it is 0b11 on RX path
> + * and should be set to 0b11 to make it work.
> + */
> +#define AR9331_HDR_RESERVED_MASK	GENMASK(5, 4)
> +#define AR9331_HDR_PORT_NUM_MASK	GENMASK(3, 0)
> +
> +static struct sk_buff *ar9331_tag_xmit(struct sk_buff *skb,
> +				       struct net_device *dev)
> +{
> +	struct dsa_port *dp = dsa_slave_to_port(dev);
> +	__le16 *phdr;
> +	u16 hdr;
> +
> +	if (skb_cow_head(skb, 0) < 0)
> +		return NULL;
> +
> +	phdr = skb_push(skb, AR9331_HDR_LEN);
> +
> +	hdr = FIELD_PREP(AR9331_HDR_VERSION_MASK, AR9331_HDR_VERSION);
> +	hdr |= AR9331_HDR_FROM_CPU | dp->index;
> +	/* 0b10 for AR8216 and 0b11 for AR9331 */
> +	hdr |= AR9331_HDR_RESERVED_MASK;
> +
> +	phdr[0] = cpu_to_le16(hdr);
> +
> +	return skb;
> +}
> +
> +static struct sk_buff *ar9331_tag_rcv(struct sk_buff *skb,
> +				      struct net_device *ndev,
> +				      struct packet_type *pt)
> +{
> +	u8 ver, port;
> +	u16 hdr;
> +
> +	if (unlikely(!pskb_may_pull(skb, AR9331_HDR_LEN)))
> +		return NULL;
> +
> +	hdr = le16_to_cpu(*(__le16 *)skb_mac_header(skb));
> +
> +	ver = FIELD_GET(AR9331_HDR_VERSION_MASK, hdr);
> +	if (unlikely(ver != AR9331_HDR_VERSION)) {
> +		netdev_warn(ndev, "%s:%i wrong header version 0x%2x\n",
> +			    __func__, __LINE__, hdr);

This would should probably be rate limited.

> +		return NULL;
> +	}
> +
> +	if (unlikely(hdr & AR9331_HDR_FROM_CPU)) {
> +		netdev_warn(ndev, "%s:%i packet should not be from cpu 0x%2x\n",
> +			    __func__, __LINE__, hdr);

This as well.

     Andrew
