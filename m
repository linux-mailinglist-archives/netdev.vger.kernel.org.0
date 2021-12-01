Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21F9F464575
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 04:30:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346461AbhLADdw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 22:33:52 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:60854 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346457AbhLADdv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Nov 2021 22:33:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=GNwsx/ftSm60AbNlPVu5nGzjW/JWKbSzeBUqa2jTAq8=; b=HNOve7z3JUTdWNpk8OhN2XzS2/
        8JhwiA0HnZ2cHZjKjyV7/p+R6FniMWRxbKedltpDdRa7N49XFMPmg2T19nH8bXd8EbSejfp/pb9tq
        XMa/gA/2Ohy89fFSTSLm5BrKrJKdS/8r9aI+ej6hFABAGSL+tZEFnviXiXMMmeIDk7yo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1msGK7-00FATs-Uy; Wed, 01 Dec 2021 04:30:23 +0100
Date:   Wed, 1 Dec 2021 04:30:23 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Wells Lu <wellslutw@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, p.zabel@pengutronix.de,
        wells.lu@sunplus.com, vincent.shih@sunplus.com
Subject: Re: [PATCH net-next v3 2/2] net: ethernet: Add driver for Sunplus
 SP7021
Message-ID: <YabsT0/dASvYUH2p@lunn.ch>
References: <1638266572-5831-1-git-send-email-wellslutw@gmail.com>
 <1638266572-5831-3-git-send-email-wellslutw@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1638266572-5831-3-git-send-email-wellslutw@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +++ b/drivers/net/ethernet/sunplus/spl2sw_define.h
> @@ -0,0 +1,301 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/* Copyright Sunplus Technology Co., Ltd.
> + *       All rights reserved.
> + */
> +
> +#ifndef __SPL2SW_DEFINE_H__
> +#define __SPL2SW_DEFINE_H__
> +
> +#include <linux/module.h>
> +#include <linux/errno.h>
> +#include <linux/types.h>
> +#include <linux/interrupt.h>
> +#include <linux/netdevice.h>
> +#include <linux/etherdevice.h>
> +#include <linux/skbuff.h>
> +#include <linux/ethtool.h>
> +#include <linux/platform_device.h>
> +#include <linux/phy.h>
> +#include <linux/mii.h>
> +#include <linux/io.h>
> +#include <linux/dma-mapping.h>
> +#include <linux/of_address.h>
> +#include <linux/of_mdio.h>
> +#include <linux/bitfield.h>

Please put these in the .c file, and only include those that are
needed in each .c file.

> +int spl2sw_rx_descs_init(struct spl2sw_common *comm)
> +{
> +	struct spl2sw_skb_info *rx_skbinfo;
> +	struct spl2sw_mac_desc *rx_desc;
> +	struct sk_buff *skb;
> +	u32 i, j;
> +
> +	for (i = 0; i < RX_DESC_QUEUE_NUM; i++) {
> +		comm->rx_skb_info[i] = kcalloc(comm->rx_desc_num[i], sizeof(*rx_skbinfo),
> +					       GFP_KERNEL | GFP_DMA);
> +		if (!comm->rx_skb_info[i])
> +			goto mem_alloc_fail;
> +
> +		rx_skbinfo = comm->rx_skb_info[i];
> +		rx_desc = comm->rx_desc[i];
> +		for (j = 0; j < comm->rx_desc_num[i]; j++) {
> +			skb = __dev_alloc_skb(comm->rx_desc_buff_size, GFP_KERNEL | GFP_DMA);

I generally don't look to closely at buffer handling in drivers. But
the __ caught my eye. There is a comment:

/* legacy helper around __netdev_alloc_skb() */

Since this is legacy, you probably should not be using it. I don't
know what you should be using though.

> +static u32 spl2sw_init_netdev(struct platform_device *pdev, int eth_no,
> +			      struct net_device **r_ndev)
> +{
> +	struct net_device *ndev;
> +	struct spl2sw_mac *mac;
> +	char *m_addr_name;
> +	ssize_t otp_l = 0;
> +	char *otp_v;
> +	int ret;
> +
> +	m_addr_name = (eth_no == 0) ? "mac_addr0" : "mac_addr1";
> +
> +	/* Allocate the devices, and also allocate spl2sw_mac,
> +	 * we can get it by netdev_priv().
> +	 */
> +	ndev = devm_alloc_etherdev(&pdev->dev, sizeof(*mac));
> +	if (!ndev) {
> +		*r_ndev = NULL;
> +		return -ENOMEM;
> +	}
> +	SET_NETDEV_DEV(ndev, &pdev->dev);
> +	ndev->netdev_ops = &netdev_ops;
> +
> +	mac = netdev_priv(ndev);
> +	mac->ndev = ndev;
> +
> +	/* Get property 'mac-addr0' or 'mac-addr1' from dts. */
> +	otp_v = spl2sw_otp_read_mac(&pdev->dev, &otp_l, m_addr_name);
> +	if (otp_l < ETH_ALEN || IS_ERR_OR_NULL(otp_v)) {
> +		dev_err(&pdev->dev, "OTP mac %s (len = %zd) is invalid, using default!\n",
> +			m_addr_name, otp_l);
> +		otp_l = 0;

This is not actually an error, in that you keep going and use the
default. So dev_info() would be better, here and the other calls in
this function.

> +	} else {
> +		/* Check if MAC address is valid or not. If not, copy from default. */
> +		ether_addr_copy(mac->mac_addr, otp_v);
> +
> +		/* Byte order of Some samples are reversed. Convert byte order here. */
> +		spl2sw_check_mac_vendor_id_and_convert(mac->mac_addr);
> +
> +		if (!is_valid_ether_addr(mac->mac_addr)) {
> +			dev_err(&pdev->dev, "Invalid mac in OTP[%s] = %pM, use default!\n",
> +				m_addr_name, mac->mac_addr);
> +			otp_l = 0;
> +		}
> +	}
> +	if (otp_l != 6) {
> +		/* MAC address is invalid. Generate one using random number. */
> +		ether_addr_copy(mac->mac_addr, spl2sw_def_mac_addr);
> +		mac->mac_addr[3] = get_random_int() % 256;
> +		mac->mac_addr[4] = get_random_int() % 256;
> +		mac->mac_addr[5] = get_random_int() % 256;
> +	}
> +
> +	eth_hw_addr_set(ndev, mac->mac_addr);
> +	dev_info(&pdev->dev, "HW Addr = %pM\n", mac->mac_addr);
> +
> +	ret = register_netdev(ndev);
> +	if (ret) {
> +		dev_err(&pdev->dev, "Failed to register net device \"%s\"!\n",
> +			ndev->name);
> +		free_netdev(ndev);
> +		*r_ndev = NULL;
> +		return ret;
> +	}
> +	netdev_info(ndev, "Registered net device \"%s\" successfully.\n", ndev->name);

netdev_dbg().

> +	*r_ndev = ndev;
> +	return 0;
> +}

> +
> +static int spl2sw_probe(struct platform_device *pdev)
> +{
> +	struct device_node *eth_ports_np;
> +	struct device_node *port_np;
> +	struct spl2sw_common *comm;
> +	struct device_node *phy_np;
> +	phy_interface_t phy_mode;
> +	struct net_device *ndev;
> +	struct spl2sw_mac *mac;
> +	struct resource *rc;
> +	int irq, i;
> +	int ret;
> +
> +	if (platform_get_drvdata(pdev))
> +		return -ENODEV;
> +
> +	/* Allocate memory for 'spl2sw_common' area. */
> +	comm = devm_kzalloc(&pdev->dev, sizeof(*comm), GFP_KERNEL);
> +	if (!comm)
> +		return -ENOMEM;
> +	comm->pdev = pdev;
> +
> +	spin_lock_init(&comm->rx_lock);
> +	spin_lock_init(&comm->tx_lock);
> +	spin_lock_init(&comm->mdio_lock);
> +
> +	/* Get memory resoruce "emac" from dts. */

resource

> +	/* Enable clock. */
> +	clk_prepare_enable(comm->clk);
> +	udelay(1);
> +
> +	reset_control_assert(comm->rstc);
> +	udelay(1);
> +	reset_control_deassert(comm->rstc);
> +	udelay(1);
> +
> +	/* Get child node ethernet-ports. */
> +	eth_ports_np = of_get_child_by_name(pdev->dev.of_node, "ethernet-ports");
> +	if (!eth_ports_np) {
> +		dev_err(&pdev->dev, "No ethernet-ports child node found!\n");

You should disable the clock before returning.

> +		return -ENODEV;
> +	}
> +
> +	for (i = 0; i < MAX_NETDEV_NUM; i++) {
> +		/* Get port@i of node ethernet-ports. */
> +		port_np = spl2sw_get_eth_child_node(eth_ports_np, i);
> +		if (!port_np)
> +			continue;
> +
> +		/* Get phy-mode. */
> +		if (of_get_phy_mode(port_np, &phy_mode)) {
> +			dev_err(&pdev->dev, "Failed to get phy-mode property of port@%d!\n",
> +				i);
> +			continue;
> +		}
> +
> +		/* Get phy-handle. */
> +		phy_np = of_parse_phandle(port_np, "phy-handle", 0);
> +		if (!phy_np) {
> +			dev_err(&pdev->dev, "Failed to get phy-handle property of port@%d!\n",
> +				i);
> +			continue;
> +		}
> +
> +		/* Get address of phy. */
> +		if (of_property_read_u32(phy_np, "reg", &comm->phy_addr[i])) {

This does not appear to be used.

> +			dev_err(&pdev->dev, "Failed to get reg property of phy node!\n");
> +			continue;
> +		}
> +
> +		if (comm->phy_addr[i] >= PHY_MAX_ADDR - 1) {
> +			dev_err(&pdev->dev, "Invalid phy address (reg = <%d>)!\n",
> +				comm->phy_addr[i]);
> +			continue;
> +		}

phylib should validate this.

> +
> +		if (!comm->mdio_node) {
> +			comm->mdio_node = of_get_parent(phy_np);
> +			if (!comm->mdio_node) {
> +				dev_err(&pdev->dev, "Failed to get mdio_node!\n");
> +				return -ENODATA;
> +			}
> +		}

This does not look correct. The PHY could be on any MDIO bus. It does
not have to be the bus of this device. There should not be any need to
follow the pointer. 

> +static int spl2sw_bit_pos_to_port_num(int n)
> +{
> +	int i;
> +
> +	for (i = 0; i < MAX_NETDEV_NUM; i++) {
> +		if (n & 1)
> +			break;
> +		n >>= 1;
> +	}
> +	return i;

Look at the ffs() helper. But since MAX_NETDEV_NUM is two, the
compiler might be smart enough to unroll the loop and just use simple
logic operations which could be faster.

> +void spl2sw_mac_addr_add(struct spl2sw_mac *mac)
> +{
> +	struct spl2sw_common *comm = mac->comm;
> +	u32 reg;
> +
> +	/* Write 6-octet MAC address. */
> +	writel((mac->mac_addr[0] << 0) + (mac->mac_addr[1] << 8),
> +	       comm->l2sw_reg_base + L2SW_W_MAC_15_0);
> +	writel((mac->mac_addr[2] << 0) + (mac->mac_addr[3] << 8) +
> +	       (mac->mac_addr[4] << 16) + (mac->mac_addr[5] << 24),
> +	       comm->l2sw_reg_base + L2SW_W_MAC_47_16);
> +
> +	/* Set learn port = cpu_port, aging = 1 */
> +	reg = MAC_W_CPU_PORT_0 | FIELD_PREP(MAC_W_VID, mac->vlan_id) |
> +	      FIELD_PREP(MAC_W_AGE, 1) | MAC_W_MAC_CMD;
> +	writel(reg, comm->l2sw_reg_base + L2SW_WT_MAC_AD0);
> +
> +	/* Wait for completing. */
> +	do {
> +		reg = readl(comm->l2sw_reg_base + L2SW_WT_MAC_AD0);
> +		ndelay(10);
> +		netdev_dbg(mac->ndev, "wt_mac_ad0 = %08x\n", reg);
> +	} while (!(reg & MAC_W_MAC_DONE));

linux/iopoll.h 


> +
> +	netdev_dbg(mac->ndev, "mac_ad0 = %08x, mac_ad = %08x%04x\n",
> +		   readl(comm->l2sw_reg_base + L2SW_WT_MAC_AD0),
> +		   (u32)FIELD_GET(MAC_W_MAC_47_16,
> +		   readl(comm->l2sw_reg_base + L2SW_W_MAC_47_16)),
> +		   (u32)FIELD_GET(MAC_W_MAC_15_0,
> +		   readl(comm->l2sw_reg_base + L2SW_W_MAC_15_0)));
> +}
> +
> +void spl2sw_mac_addr_del(struct spl2sw_mac *mac)
> +{
> +	struct spl2sw_common *comm = mac->comm;
> +	u32 reg;
> +
> +	/* Write 6-octet MAC address. */
> +	writel((mac->mac_addr[0] << 0) + (mac->mac_addr[1] << 8),
> +	       comm->l2sw_reg_base + L2SW_W_MAC_15_0);
> +	writel((mac->mac_addr[2] << 0) + (mac->mac_addr[3] << 8) +
> +	       (mac->mac_addr[4] << 16) + (mac->mac_addr[5] << 24),
> +	       comm->l2sw_reg_base + L2SW_W_MAC_47_16);
> +
> +	/* Set learn port = lan_port0 and aging = 0
> +	 * to wipe (age) out the entry.
> +	 */
> +	reg = MAC_W_LAN_PORT_0 | FIELD_PREP(MAC_W_VID, mac->vlan_id) | MAC_W_MAC_CMD;
> +	writel(reg, comm->l2sw_reg_base + L2SW_WT_MAC_AD0);
> +
> +	/* Wait for completing. */
> +	do {
> +		reg = readl(comm->l2sw_reg_base + L2SW_WT_MAC_AD0);
> +		ndelay(10);
> +		netdev_dbg(mac->ndev, "wt_mac_ad0 = %08x\n", reg);
> +	} while (!(reg & MAC_W_MAC_DONE));

Here as well. Any where you need to wait for some sort of completion,
it is best you use these helpers. They will also do a timeout, just in
case the hardware dies.

> +static int spl2sw_mii_read(struct mii_bus *bus, int addr, int regnum)
> +{
> +	struct spl2sw_common *comm = bus->priv;
> +	int ret;
> +
> +	if (regnum & MII_ADDR_C45)
> +		return -EOPNOTSUPP;
> +
> +	ret = spl2sw_mdio_access(comm, SPL2SW_MDIO_READ_CMD, addr, regnum, 0);
> +	if (ret < 0)
> +		return -EOPNOTSUPP;

spl2sw_mdio_access() returns an error code, -ETIMEDOUT. So us it.

> +u32 spl2sw_mdio_init(struct spl2sw_common *comm)
> +{
> +	struct mii_bus *mii_bus;
> +	int ret;
> +
> +	mii_bus = devm_mdiobus_alloc(&comm->pdev->dev);
> +	if (!mii_bus)
> +		return -ENOMEM;
> +
> +	mii_bus->name = "sunplus_mii_bus";
> +	mii_bus->parent = &comm->pdev->dev;
> +	mii_bus->priv = comm;
> +	mii_bus->read = spl2sw_mii_read;
> +	mii_bus->write = spl2sw_mii_write;
> +	snprintf(mii_bus->id, MII_BUS_ID_SIZE, "%s-mii", dev_name(&comm->pdev->dev));
> +
> +	ret = of_mdiobus_register(mii_bus, comm->mdio_node);

Here you should be looking into the device tree to find the mdio node
and passing it.

> +	if (ret) {
> +		dev_err(&comm->pdev->dev, "Failed to register mdiobus!\n");
> +		return ret;
> +	}
> +
> +	comm->mii_bus = mii_bus;
> +	return ret;
> +}

> +int spl2sw_phy_connect(struct spl2sw_common *comm)
> +{
> +	struct phy_device *phydev;
> +	struct net_device *ndev;
> +	struct spl2sw_mac *mac;
> +	int i;
> +
> +	for (i = 0; i < MAX_NETDEV_NUM; i++)
> +		if (comm->ndev[i]) {
> +			ndev = comm->ndev[i];
> +			mac = netdev_priv(ndev);
> +			phydev = of_phy_connect(ndev, mac->phy_node, spl2sw_mii_link_change,
> +						0, mac->phy_mode);
> +			if (!phydev)
> +				return -ENODEV;
> +
> +			linkmode_copy(phydev->advertising, phydev->supported);

There should not be any need to do this.

> +
> +			/* Enable polling mode */
> +			phydev->irq = PHY_POLL;

And that should be the default, so no need to set it.

> +		}
> +
> +	return 0;
> +}

This is looking a lot better.

     Andrew
