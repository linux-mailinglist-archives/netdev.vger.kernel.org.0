Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D91F844F022
	for <lists+netdev@lfdr.de>; Sat, 13 Nov 2021 00:59:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233128AbhKMABw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Nov 2021 19:01:52 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:59190 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231261AbhKMABv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Nov 2021 19:01:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=MBOs/AjY5zcm+4rGWB/QgkLatksippMCYzVgh7elE48=; b=eKc/iAD/CUz3oMOkcdOXzBdk+0
        UCpyNaVFn1/k2rW3L6zdHrn21TjDjK2hknrYkT/4OCgQr6FkfgnNOfXFP+Lw6Z26+8f7EdYtA6TCL
        vpt0d5P+7ub8JH4JUAHn+lcC/F3/6rf1E8FNt8i1+kvYK55L82YH+lqlPKePOEndWqtg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mlgRb-00DIlI-Bp; Sat, 13 Nov 2021 00:58:55 +0100
Date:   Sat, 13 Nov 2021 00:58:55 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Wells Lu <wellslutw@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, p.zabel@pengutronix.de,
        vincent.shih@sunplus.com, Wells Lu <wells.lu@sunplus.com>
Subject: Re: [PATCH v2 2/2] net: ethernet: Add driver for Sunplus SP7021
Message-ID: <YY7/v1msiaqJF3Uy@lunn.ch>
References: <cover.1636620754.git.wells.lu@sunplus.com>
 <519b61af544f4c6920012d44afd35a0f8761b24f.1636620754.git.wells.lu@sunplus.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <519b61af544f4c6920012d44afd35a0f8761b24f.1636620754.git.wells.lu@sunplus.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +void rx_descs_flush(struct sp_common *comm)

As both Florian and I have said, you need a prefix for all your
functions, structures, etc. sp_ is not the best prefix either, it is
not very unique. spl2sw_ would be better.

> +void rx_descs_clean(struct sp_common *comm)
> +{
> +	u32 i, j;
> +	struct mac_desc *rx_desc;
> +	struct skb_info *rx_skbinfo;

netdev wants reverse christmas tree. You need to change the order of
your local variables, longest lines first, shorted last.

> +
> +	for (i = 0; i < RX_DESC_QUEUE_NUM; i++) {
> +		if (!comm->rx_skb_info[i])
> +			continue;
> +
> +		rx_desc = comm->rx_desc[i];
> +		rx_skbinfo = comm->rx_skb_info[i];
> +		for (j = 0; j < comm->rx_desc_num[i]; j++) {
> +			rx_desc[j].cmd1 = 0;
> +			wmb();	// Clear OWN_BIT and then set other fields.
> +			rx_desc[j].cmd2 = 0;
> +			rx_desc[j].addr1 = 0;
> +
> +			if (rx_skbinfo[j].skb) {
> +				dma_unmap_single(&comm->pdev->dev, rx_skbinfo[j].mapping,
> +						 comm->rx_desc_buff_size, DMA_FROM_DEVICE);
> +				dev_kfree_skb(rx_skbinfo[j].skb);
> +				rx_skbinfo[j].skb = NULL;
> +				rx_skbinfo[j].mapping = 0;
> +			}
> +		}
> +
> +		kfree(rx_skbinfo);
> +		comm->rx_skb_info[i] = NULL;
> +	}
> +}

> +int rx_descs_init(struct sp_common *comm)
> +{
> +	struct sk_buff *skb;
> +	u32 i, j;
> +	struct mac_desc *rx_desc;
> +	struct skb_info *rx_skbinfo;
> +
> +	for (i = 0; i < RX_DESC_QUEUE_NUM; i++) {
> +		comm->rx_skb_info[i] = kmalloc_array(comm->rx_desc_num[i],
> +						     sizeof(struct skb_info), GFP_KERNEL);
> +		if (!comm->rx_skb_info[i])
> +			goto MEM_ALLOC_FAIL;
> +
> +		rx_skbinfo = comm->rx_skb_info[i];
> +		rx_desc = comm->rx_desc[i];
> +		for (j = 0; j < comm->rx_desc_num[i]; j++) {
> +			skb = __dev_alloc_skb(comm->rx_desc_buff_size + RX_OFFSET,
> +					      GFP_ATOMIC | GFP_DMA);
> +			if (!skb)
> +				goto MEM_ALLOC_FAIL;
> +
> +			skb->dev = comm->ndev;
> +			skb_reserve(skb, RX_OFFSET);	/* +data +tail */
> +
> +			rx_skbinfo[j].skb = skb;
> +			rx_skbinfo[j].mapping = dma_map_single(&comm->pdev->dev, skb->data,
> +							       comm->rx_desc_buff_size,
> +							       DMA_FROM_DEVICE);
> +			rx_desc[j].addr1 = rx_skbinfo[j].mapping;
> +			rx_desc[j].addr2 = 0;
> +			rx_desc[j].cmd2 = (j == comm->rx_desc_num[i] - 1) ?
> +					  EOR_BIT | comm->rx_desc_buff_size :
> +					  comm->rx_desc_buff_size;
> +			wmb();	// Set OWN_BIT after other fields are effective.
> +			rx_desc[j].cmd1 = OWN_BIT;
> +		}
> +	}
> +
> +	return 0;
> +
> +MEM_ALLOC_FAIL:

lower case labels. Didn't somebody already say that?

> +int descs_init(struct sp_common *comm)
> +{
> +	u32 i, ret;
> +
> +	// Initialize rx descriptor's data
> +	comm->rx_desc_num[0] = RX_QUEUE0_DESC_NUM;
> +#if RX_DESC_QUEUE_NUM > 1
> +	comm->rx_desc_num[1] = RX_QUEUE1_DESC_NUM;
> +#endif

Avoid #if statements. Why is this needed?

> +++ b/drivers/net/ethernet/sunplus/sp_driver.c
> @@ -0,0 +1,606 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright Sunplus Technology Co., Ltd.
> + *       All rights reserved.
> + */
> +
> +#include <linux/clk.h>
> +#include <linux/reset.h>
> +#include <linux/nvmem-consumer.h>
> +#include <linux/of_net.h>
> +#include "sp_driver.h"
> +#include "sp_phy.h"
> +
> +static const char def_mac_addr[ETHERNET_MAC_ADDR_LEN] = {
> +	0xfc, 0x4b, 0xbc, 0x00, 0x00, 0x00

This does not have the locally administered bit set. Should it? Or is
this and address from your OUI?

> +static void ethernet_set_rx_mode(struct net_device *ndev)
> +{
> +	if (ndev) {

How can ndev be NULL?

> +++ b/drivers/net/ethernet/sunplus/sp_hal.c
> @@ -0,0 +1,331 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright Sunplus Technology Co., Ltd.
> + *       All rights reserved.
> + */
> +
> +#include <linux/iopoll.h>
> +#include "sp_hal.h"
> +
> +void hal_mac_stop(struct sp_mac *mac)

I suggest you avoid any references to hal. It makes people think you
have ported a driver from some other operating system and then put a
layer of code on top of it. That is not how you do it in Linux. This
is a Linux driver, nothing else.

> +void hal_mac_reset(struct sp_mac *mac)
> +{
> +}
> +

Should not exist.

> +void hal_mac_addr_set(struct sp_mac *mac)
> +{
> +	struct sp_common *comm = mac->comm;
> +	u32 reg;
> +
> +	// Write MAC address.
> +	writel(mac->mac_addr[0] + (mac->mac_addr[1] << 8),
> +	       comm->sp_reg_base + SP_W_MAC_15_0);
> +	writel(mac->mac_addr[2] + (mac->mac_addr[3] << 8) + (mac->mac_addr[4] << 16) +
> +	      (mac->mac_addr[5] << 24),	comm->sp_reg_base + SP_W_MAC_47_16);
> +
> +	// Set aging=1
> +	writel((mac->cpu_port << 10) + (mac->vlan_id << 7) + (1 << 4) + 0x1,
> +	       comm->sp_reg_base + SP_WT_MAC_AD0);

Is this actually adding an entry into the address translation table?
If so, make this clear in the function name. You are not setting the
MAC address, you are just adding a static forwarding entry.

> +
> +	// Wait for completing.
> +	do {
> +		reg = readl(comm->sp_reg_base + SP_WT_MAC_AD0);
> +		ndelay(10);
> +		netdev_dbg(mac->ndev, "wt_mac_ad0 = %08x\n", reg);
> +	} while ((reg & (0x1 << 1)) == 0x0);
> +
> +	netdev_dbg(mac->ndev, "mac_ad0 = %08x, mac_ad = %08x%04x\n",
> +		   readl(comm->sp_reg_base + SP_WT_MAC_AD0),
> +		   readl(comm->sp_reg_base + SP_W_MAC_47_16),
> +		   readl(comm->sp_reg_base + SP_W_MAC_15_0) & 0xffff);
> +}

> +void hal_rx_mode_set(struct net_device *ndev)
> +{
> +	struct sp_mac *mac = netdev_priv(ndev);
> +	struct sp_common *comm = mac->comm;
> +	u32 mask, reg, rx_mode;
> +
> +	netdev_dbg(ndev, "ndev->flags = %08x\n", ndev->flags);
> +
> +	mask = (mac->lan_port << 2) | (mac->lan_port << 0);
> +	reg = readl(comm->sp_reg_base + SP_CPU_CNTL);
> +
> +	if (ndev->flags & IFF_PROMISC) {	/* Set promiscuous mode */
> +		// Allow MC and unknown UC packets
> +		rx_mode = (mac->lan_port << 2) | (mac->lan_port << 0);
> +	} else if ((!netdev_mc_empty(ndev) && (ndev->flags & IFF_MULTICAST)) ||
> +		   (ndev->flags & IFF_ALLMULTI)) {
> +		// Allow MC packets
> +		rx_mode = (mac->lan_port << 2);
> +	} else {
> +		// Disable MC and unknown UC packets
> +		rx_mode = 0;
> +	}
> +
> +	writel((reg & (~mask)) | ((~rx_mode) & mask), comm->sp_reg_base + SP_CPU_CNTL);
> +	netdev_dbg(ndev, "cpu_cntl = %08x\n", readl(comm->sp_reg_base + SP_CPU_CNTL));

This looks like it belongs in the ethtool code.

> +int hal_mdio_access(struct sp_mac *mac, u8 op_cd, u8 phy_addr, u8 reg_addr, u32 wdata)
> +{
> +	struct sp_common *comm = mac->comm;
> +	u32 val, ret;
> +
> +	writel((wdata << 16) | (op_cd << 13) | (reg_addr << 8) | phy_addr,
> +	       comm->sp_reg_base + SP_PHY_CNTL_REG0);
> +
> +	ret = read_poll_timeout(readl, val, val & op_cd, 10, 1000, 1,
> +				comm->sp_reg_base + SP_PHY_CNTL_REG1);
> +	if (ret == 0)
> +		return val >> 16;
> +	else
> +		return ret;
> +}

Should go with the other mdio code.

> +void hal_phy_addr(struct sp_mac *mac)
> +{
> +	struct sp_common *comm = mac->comm;
> +	u32 reg;
> +
> +	// Set address of phy.
> +	reg = readl(comm->sp_reg_base + SP_MAC_FORCE_MODE);
> +	reg = (reg & (~(0x1f << 16))) | ((mac->phy_addr & 0x1f) << 16);
> +	if (mac->next_ndev) {
> +		struct net_device *ndev2 = mac->next_ndev;
> +		struct sp_mac *mac2 = netdev_priv(ndev2);
> +
> +		reg = (reg & (~(0x1f << 24))) | ((mac2->phy_addr & 0x1f) << 24);
> +	}
> +	writel(reg, comm->sp_reg_base + SP_MAC_FORCE_MODE);
> +}

As i said before, the hardware never directly communicates with the
PHY. So you can remove this.

> +static void port_status_change(struct sp_mac *mac)
> +{
> +	u32 reg;
> +	struct net_device *ndev = mac->ndev;
> +
> +	reg = read_port_ability(mac);
> +	if (!netif_carrier_ok(ndev) && (reg & PORT_ABILITY_LINK_ST_P0)) {
> +		netif_carrier_on(ndev);

phylib should be handling the carrier for you.

> +	if (mac->next_ndev) {
> +		struct net_device *ndev2 = mac->next_ndev;
> +
> +		if (!netif_carrier_ok(ndev2) && (reg & PORT_ABILITY_LINK_ST_P1)) {
> +			netif_carrier_on(ndev2);
> +			netif_start_queue(ndev2);
> +		} else if (netif_carrier_ok(ndev2) && !(reg & PORT_ABILITY_LINK_ST_P1)) {
> +			netif_carrier_off(ndev2);
> +			netif_stop_queue(ndev2);
> +		}

Looks very odd. The two netdev should be independent.

> diff --git a/drivers/net/ethernet/sunplus/sp_mdio.c b/drivers/net/ethernet/sunplus/sp_mdio.c
> new file mode 100644
> index 0000000..f6a7e64
> --- /dev/null
> +++ b/drivers/net/ethernet/sunplus/sp_mdio.c
> @@ -0,0 +1,90 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright Sunplus Technology Co., Ltd.
> + *       All rights reserved.
> + */
> +
> +#include "sp_mdio.h"
> +
> +u32 mdio_read(struct sp_mac *mac, u32 phy_id, u16 regnum)
> +{
> +	int ret;
> +
> +	ret = hal_mdio_access(mac, MDIO_READ_CMD, phy_id, regnum, 0);
> +	if (ret < 0)
> +		return -EOPNOTSUPP;
> +
> +	return ret;
> +}
> +
> +u32 mdio_write(struct sp_mac *mac, u32 phy_id, u32 regnum, u16 val)
> +{
> +	int ret;
> +
> +	ret = hal_mdio_access(mac, MDIO_WRITE_CMD, phy_id, regnum, val);
> +	if (ret < 0)
> +		return -EOPNOTSUPP;
> +
> +	return 0;
> +}
> +
> +static int mii_read(struct mii_bus *bus, int phy_id, int regnum)
> +{
> +	struct sp_mac *mac = bus->priv;

What happened about my request to return -EOPNOTSUPP for C45 requests?

     Andrew
