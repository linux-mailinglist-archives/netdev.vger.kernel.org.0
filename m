Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FA1B444649
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 17:51:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232925AbhKCQyO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 12:54:14 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45476 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229894AbhKCQyO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Nov 2021 12:54:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=LoVd7Wmm4TPrtbMmrNBoE6nwq6Zb/G9Z6/gwUQBowxM=; b=eyTZKTEHMYWjzs0RERchgXYL1B
        oeu7zlVS1lKjoUzkuPeLKc67E69yIhc/S0XOkXr85JDKz2f5p/qvpF4xLGLXYi/gAPMZpTMxvn7Nb
        KQot8Nw6ynKUeWOuW+qUsYmC/8pH7HKe2XBlFvTWzbYx4n31vKe3e9xZ1BMAAubJmmz8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1miJU1-00CWZP-Av; Wed, 03 Nov 2021 17:51:29 +0100
Date:   Wed, 3 Nov 2021 17:51:29 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Wells Lu <wellslutw@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, p.zabel@pengutronix.de,
        Wells Lu <wells.lu@sunplus.com>
Subject: Re: [PATCH 2/2] net: ethernet: Add driver for Sunplus SP7021
Message-ID: <YYK+EeCOu/BXBXDi@lunn.ch>
References: <cover.1635936610.git.wells.lu@sunplus.com>
 <650ec751dd782071dd56af5e36c0d509b0c66d7f.1635936610.git.wells.lu@sunplus.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <650ec751dd782071dd56af5e36c0d509b0c66d7f.1635936610.git.wells.lu@sunplus.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +config NET_VENDOR_SUNPLUS
> +	tristate "Sunplus Dual 10M/100M Ethernet (with L2 switch) devices"

The "with L2 Switch" is causing lots of warning bells to ring for me.

I don't see any references to switchdev or DSA in this driver. How is
the switch managed? There have been a few examples in the past of
similar two port switches being first supported in Dual MAC
mode. Later trying to actually use the switch in the Linux was always
ran into problems, and basically needed a new driver. So i want to
make sure you don't have this problem.

In the Linux world, Ethernet switches default to having there
ports/interfaces separated. This effectively gives you your dual MAC
mode by default.  You then create a Linux bridge, and add the
ports/interfaces to the bridge. switchdev is used to offload the
bridge, telling the hardware to enable the L2 switch between the
ports.

So you don't need the mode parameter in DT. switchdev tells you
this. Switchdev gives user space access to the address table etc.

> +obj-$(CONFIG_NET_VENDOR_SUNPLUS) += sp_l2sw.o
...
> +struct l2sw_common {

Please change your prefix. l2sw is a common prefix, there are other
silicon vendors using l2sw. I would suggest sp_l2sw or spl2sw.

> +static int ethernet_do_ioctl(struct net_device *net_dev, struct ifreq *ifr, int cmd)
> +{
> +	struct l2sw_mac *mac = netdev_priv(net_dev);
> +	struct l2sw_common *comm = mac->comm;
> +	struct mii_ioctl_data *data = if_mii(ifr);
> +	unsigned long flags;
> +
> +	pr_debug(" if = %s, cmd = %04x\n", ifr->ifr_ifrn.ifrn_name, cmd);
> +	pr_debug(" phy_id = %d, reg_num = %d, val_in = %04x\n", data->phy_id,
> +		 data->reg_num, data->val_in);

You should not be using any of the pr_ functions. You have a net_dev,
so netdev_dbg().

> +
> +	// Check parameters' range.
> +	if ((cmd == SIOCGMIIREG) || (cmd == SIOCSMIIREG)) {
> +		if (data->reg_num > 31) {
> +			pr_err(" reg_num (= %d) excesses range!\n", (int)data->reg_num);

Don't spam the kernel log for things like this.

> +			return -EINVAL;
> +		}
> +	}
> +
> +	switch (cmd) {
> +	case SIOCGMIIPHY:
> +		if (comm->dual_nic && (strcmp(ifr->ifr_ifrn.ifrn_name, "eth1") == 0))

You cannot rely on the name, systemd has probably renamed it. If you
have using phylib correctly, net_dev->phydev is what you want.


> +			return comm->phy2_addr;
> +		else
> +			return comm->phy1_addr;
> +
> +	case SIOCGMIIREG:
> +		spin_lock_irqsave(&comm->ioctl_lock, flags);
> +		data->val_out = mdio_read(data->phy_id, data->reg_num);
> +		spin_unlock_irqrestore(&comm->ioctl_lock, flags);
> +		pr_debug(" val_out = %04x\n", data->val_out);
> +		break;
> +
> +	case SIOCSMIIREG:
> +		spin_lock_irqsave(&comm->ioctl_lock, flags);
> +		mdio_write(data->phy_id, data->reg_num, data->val_in);
> +		spin_unlock_irqrestore(&comm->ioctl_lock, flags);
> +		break;
> +

You should be using phylink_mii_ioctl() or phy_mii_ioctl().

You locking is also suspect.

> +static int ethernet_change_mtu(struct net_device *ndev, int new_mtu)
> +{
> +	if (netif_running(ndev))
> +		return -EBUSY;
> +
> +	if (new_mtu < 68 || new_mtu > ETH_DATA_LEN)
> +		return -EINVAL;

The core will do this for you, if you set the values in the ndev
correct at probe time.

> +
> +	ndev->mtu = new_mtu;
> +
> +	return 0;
> +}
> +


> +static int mdio_access(u8 op_cd, u8 dev_reg_addr, u8 phy_addr, u32 wdata)
> +{
> +	u32 value, time = 0;
> +
> +	HWREG_W(phy_cntl_reg0, (wdata << 16) | (op_cd << 13) | (dev_reg_addr << 8) | phy_addr);
> +	wmb();			// make sure settings are effective.

That suggests you are using the wrong macros to access the registers.

> +	do {
> +		if (++time > MDIO_RW_TIMEOUT_RETRY_NUMBERS) {
> +			pr_err(" mdio failed to operate!\n");
> +			time = 0;
> +		}
> +
> +		value = HWREG_R(phy_cntl_reg1);
> +	} while ((value & 0x3) == 0);

include/linux/iopoll.h.


> +	if (time == 0)
> +		return -1;

-ETIMDEOUT. One of the advantages of iopoll.h is that reusing code
 avoids issues like this.

> +u32 mdio_read(u32 phy_id, u16 regnum)
> +{
> +	int ret;

Please check for C45 and return -EOPNOTSUPP.

> +
> +	ret = mdio_access(MDIO_READ_CMD, regnum, phy_id, 0);
> +	if (ret < 0)
> +		return -EIO;
> +
> +	return ret;
> +}
> +
> +u32 mdio_write(u32 phy_id, u32 regnum, u16 val)
> +{
> +	int ret;
> +

Please check for C45 and return -EOPNOTSUPP.

> +	ret = mdio_access(MDIO_WRITE_CMD, regnum, phy_id, val);
> +	if (ret < 0)
> +		return -EIO;
> +
> +	return 0;
> +}
> +
> +inline void tx_trigger(void)

No inline functions in C code. Let the compiler decide.

> +int phy_cfg(struct l2sw_mac *mac)
> +{
> +	// Bug workaround:
> +	// Flow-control of phy should be enabled. L2SW IP flow-control will refer
> +	// to the bit to decide to enable or disable flow-control.
> +	mdio_write(mac->comm->phy1_addr, 4, mdio_read(mac->comm->phy1_addr, 4) | (1 << 10));
> +	mdio_write(mac->comm->phy2_addr, 4, mdio_read(mac->comm->phy2_addr, 4) | (1 << 10));

This should be in the PHY driver. The MAC driver should never need to
touch PHY registers.

> +++ b/drivers/net/ethernet/sunplus/l2sw_mdio.c
> @@ -0,0 +1,118 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright Sunplus Technology Co., Ltd.
> + *       All rights reserved.
> + */
> +
> +#include "l2sw_mdio.h"
> +
> +static int mii_read(struct mii_bus *bus, int phy_id, int regnum)
> +{
> +	return mdio_read(phy_id, regnum);
> +}
> +
> +static int mii_write(struct mii_bus *bus, int phy_id, int regnum, u16 val)
> +{
> +	return mdio_write(phy_id, regnum, val);
> +}
> +
> +u32 mdio_init(struct platform_device *pdev, struct net_device *net_dev)
> +{
> +	struct l2sw_mac *mac = netdev_priv(net_dev);
> +	struct mii_bus *mii_bus;
> +	struct device_node *mdio_node;
> +	u32 ret;
> +
> +	mii_bus = mdiobus_alloc();
> +	if (!mii_bus) {
> +		pr_err(" Failed to allocate mdio_bus memory!\n");
> +		return -ENOMEM;
> +	}
> +
> +	mii_bus->name = "sunplus_mii_bus";
> +	mii_bus->parent = &pdev->dev;
> +	mii_bus->priv = mac;
> +	mii_bus->read = mii_read;
> +	mii_bus->write = mii_write;
> +	snprintf(mii_bus->id, MII_BUS_ID_SIZE, "%s-mii", dev_name(&pdev->dev));
> +
> +	mdio_node = of_get_parent(mac->comm->phy1_node);
> +	ret = of_mdiobus_register(mii_bus, mdio_node);
> +	if (ret) {
> +		pr_err(" Failed to register mii bus (ret = %d)!\n", ret);
> +		mdiobus_free(mii_bus);
> +		return ret;
> +	}
> +
> +	mac->comm->mii_bus = mii_bus;
> +	return ret;
> +}
> +
> +void mdio_remove(struct net_device *net_dev)
> +{
> +	struct l2sw_mac *mac = netdev_priv(net_dev);
> +
> +	if (mac->comm->mii_bus) {
> +		mdiobus_unregister(mac->comm->mii_bus);
> +		mdiobus_free(mac->comm->mii_bus);
> +		mac->comm->mii_bus = NULL;
> +	}
> +}

You MDIO code is pretty scattered around. Please bring it all together
in one file.

> +static void mii_linkchange(struct net_device *netdev)
> +{
> +}

Nothing to do? Seems very odd. Don't you need to tell the MAC it
should do 10Mbps or 100Mbps? What about pause?

> +
> +int mac_phy_probe(struct net_device *netdev)
> +{
> +	struct l2sw_mac *mac = netdev_priv(netdev);
> +	struct phy_device *phydev;
> +	int i;
> +
> +	phydev = of_phy_connect(mac->net_dev, mac->comm->phy1_node, mii_linkchange,
> +				0, PHY_INTERFACE_MODE_RGMII_ID);

You should not hard code PHY_INTERFACE_MODE_RGMII_ID. Use the DT
property "phy-mode"

> +	if (!phydev) {
> +		pr_err(" \"%s\" has no phy found\n", netdev->name);
> +		return -1;

-ENODEV;

Never use -1, pick an error code.

> +	}
> +
> +	if (mac->comm->phy2_node) {
> +		of_phy_connect(mac->net_dev, mac->comm->phy2_node, mii_linkchange,
> +			       0, PHY_INTERFACE_MODE_RGMII_ID);
> +	}
> +
> +	linkmode_clear_bit(ETHTOOL_LINK_MODE_Pause_BIT, phydev->supported);
> +	linkmode_clear_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT, phydev->supported);

So the MAC does not support pause? I'm then confused about phy_cfg().

   Andrew
