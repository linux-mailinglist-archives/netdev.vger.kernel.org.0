Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74C41F12B
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 09:19:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726475AbfD3HSS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 03:18:18 -0400
Received: from first.geanix.com ([116.203.34.67]:43620 "EHLO first.geanix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725769AbfD3HSR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Apr 2019 03:18:17 -0400
Received: from localhost (unknown [193.163.1.7])
        by first.geanix.com (Postfix) with ESMTPSA id E6AD7308E93;
        Tue, 30 Apr 2019 07:18:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=geanix.com; s=first;
        t=1556608687; bh=OrBUw1UUtDJ19G3bEoHHjtwTOE++0vX20c/tzez0qlk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=RZ0AUEyV3YeaPacaLtU6AqfBCf2kFa7Zbi4WOWj78PIj+hzE4oFodp5PnjKSxi0PL
         Ll4QVErvDpJjJrUx3YJ0PfrLnzlBkVHFkBOAQ9ij15Uhl4V6k9V6XlLZuY4fXc4nf9
         VFCUfUQzy6LTkJkmAYCv9YjyCcl9GwLHZMdKo1sfGQlU5ch9EcsPqLOC1SKEeiVmxb
         Kvzd1HrZjCbE1VRebpjNoZyf//JhX42dNlULvBlc6tlO+/WrzgkwscPYffkGWm9wZy
         9frA7QpDz8/cKU/sQ8hVwy1vkYwz3Fl1J7V65IkPUbn68TIwvaPRM66WPrKonXyx3l
         VIvD5W72UtkkA==
From:   Esben Haabendal <esben@geanix.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Michal Simek <michal.simek@xilinx.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Yang Wei <yang.wei9@zte.com.cn>,
        YueHaibing <yuehaibing@huawei.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v3 02/12] net: ll_temac: Extend support to non-device-tree platforms
Date:   Tue, 30 Apr 2019 09:17:49 +0200
Message-Id: <20190430071759.2481-3-esben@geanix.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190430071759.2481-1-esben@geanix.com>
References: <20190429083422.4356-1-esben@geanix.com>
 <20190430071759.2481-1-esben@geanix.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,UNPARSEABLE_RELAY,URIBL_BLOCKED
        autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on b7bf6291adac
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Support initialization with platdata, so the driver can be used on
non-device-tree platforms.

For currently supported device-tree platforms, the driver should behave
as before.

Signed-off-by: Esben Haabendal <esben@geanix.com>
---
 drivers/net/ethernet/xilinx/ll_temac.h        |   3 +
 drivers/net/ethernet/xilinx/ll_temac_main.c   | 187 +++++++++++++++++---------
 drivers/net/ethernet/xilinx/ll_temac_mdio.c   |  23 +++-
 include/linux/platform_data/xilinx-ll-temac.h |  19 +++
 4 files changed, 166 insertions(+), 66 deletions(-)
 create mode 100644 include/linux/platform_data/xilinx-ll-temac.h

diff --git a/drivers/net/ethernet/xilinx/ll_temac.h b/drivers/net/ethernet/xilinx/ll_temac.h
index 4557578..e338b4f 100644
--- a/drivers/net/ethernet/xilinx/ll_temac.h
+++ b/drivers/net/ethernet/xilinx/ll_temac.h
@@ -334,6 +334,9 @@ struct temac_local {
 
 	/* Connection to PHY device */
 	struct device_node *phy_node;
+	/* For non-device-tree devices */
+	char phy_name[MII_BUS_ID_SIZE + 3];
+	phy_interface_t phy_interface;
 
 	/* MDIO bus data */
 	struct mii_bus *mii_bus;	/* MII bus reference */
diff --git a/drivers/net/ethernet/xilinx/ll_temac_main.c b/drivers/net/ethernet/xilinx/ll_temac_main.c
index c4e85a9..fddd1b3 100644
--- a/drivers/net/ethernet/xilinx/ll_temac_main.c
+++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
@@ -33,6 +33,7 @@
 #include <linux/module.h>
 #include <linux/mutex.h>
 #include <linux/netdevice.h>
+#include <linux/if_ether.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
 #include <linux/of_irq.h>
@@ -51,6 +52,7 @@
 #include <linux/slab.h>
 #include <linux/interrupt.h>
 #include <linux/dma-mapping.h>
+#include <linux/platform_data/xilinx-ll-temac.h>
 
 #include "ll_temac.h"
 
@@ -187,7 +189,7 @@ static int temac_dcr_setup(struct temac_local *lp, struct platform_device *op,
 
 /*
  * temac_dcr_setup - This is a stub for when DCR is not supported,
- * such as with MicroBlaze
+ * such as with MicroBlaze and x86
  */
 static int temac_dcr_setup(struct temac_local *lp, struct platform_device *op,
 				struct device_node *np)
@@ -857,7 +859,14 @@ static int temac_open(struct net_device *ndev)
 			dev_err(lp->dev, "of_phy_connect() failed\n");
 			return -ENODEV;
 		}
-
+		phy_start(phydev);
+	} else if (strlen(lp->phy_name) > 0) {
+		phydev = phy_connect(lp->ndev, lp->phy_name, temac_adjust_link,
+				     lp->phy_interface);
+		if (!phydev) {
+			dev_err(lp->dev, "phy_connect() failed\n");
+			return -ENODEV;
+		}
 		phy_start(phydev);
 	}
 
@@ -977,11 +986,13 @@ static const struct ethtool_ops temac_ethtool_ops = {
 	.set_link_ksettings = phy_ethtool_set_link_ksettings,
 };
 
-static int temac_of_probe(struct platform_device *op)
+static int temac_probe(struct platform_device *pdev)
 {
-	struct device_node *np;
+	struct ll_temac_platform_data *pdata = dev_get_platdata(&pdev->dev);
+	struct device_node *temac_np = dev_of_node(&pdev->dev), *dma_np;
 	struct temac_local *lp;
 	struct net_device *ndev;
+	struct resource *res;
 	const void *addr;
 	__be32 *p;
 	int rc = 0;
@@ -991,8 +1002,8 @@ static int temac_of_probe(struct platform_device *op)
 	if (!ndev)
 		return -ENOMEM;
 
-	platform_set_drvdata(op, ndev);
-	SET_NETDEV_DEV(ndev, &op->dev);
+	platform_set_drvdata(pdev, ndev);
+	SET_NETDEV_DEV(ndev, &pdev->dev);
 	ndev->flags &= ~IFF_MULTICAST;  /* clear multicast */
 	ndev->features = NETIF_F_SG;
 	ndev->netdev_ops = &temac_netdev_ops;
@@ -1014,79 +1025,129 @@ static int temac_of_probe(struct platform_device *op)
 	/* setup temac private info structure */
 	lp = netdev_priv(ndev);
 	lp->ndev = ndev;
-	lp->dev = &op->dev;
+	lp->dev = &pdev->dev;
 	lp->options = XTE_OPTION_DEFAULTS;
 	spin_lock_init(&lp->rx_lock);
 	mutex_init(&lp->indirect_mutex);
 
 	/* map device registers */
-	lp->regs = devm_of_iomap(&op->dev, op->dev.of_node, 0, NULL);
-	if (!lp->regs) {
-		dev_err(&op->dev, "could not map temac regs.\n");
-		return -ENOMEM;
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	lp->regs = devm_ioremap_nocache(&pdev->dev, res->start,
+					resource_size(res));
+	if (IS_ERR(lp->regs)) {
+		dev_err(&pdev->dev, "could not map TEMAC registers\n");
+		return PTR_ERR(lp->regs);
 	}
 
 	/* Setup checksum offload, but default to off if not specified */
 	lp->temac_features = 0;
-	p = (__be32 *)of_get_property(op->dev.of_node, "xlnx,txcsum", NULL);
-	if (p && be32_to_cpu(*p)) {
-		lp->temac_features |= TEMAC_FEATURE_TX_CSUM;
+	if (temac_np) {
+		p = (__be32 *)of_get_property(temac_np, "xlnx,txcsum", NULL);
+		if (p && be32_to_cpu(*p))
+			lp->temac_features |= TEMAC_FEATURE_TX_CSUM;
+		p = (__be32 *)of_get_property(temac_np, "xlnx,rxcsum", NULL);
+		if (p && be32_to_cpu(*p))
+			lp->temac_features |= TEMAC_FEATURE_RX_CSUM;
+	} else if (pdata) {
+		if (pdata->txcsum)
+			lp->temac_features |= TEMAC_FEATURE_TX_CSUM;
+		if (pdata->rxcsum)
+			lp->temac_features |= TEMAC_FEATURE_RX_CSUM;
+	}
+	if (lp->temac_features & TEMAC_FEATURE_TX_CSUM)
 		/* Can checksum TCP/UDP over IPv4. */
 		ndev->features |= NETIF_F_IP_CSUM;
-	}
-	p = (__be32 *)of_get_property(op->dev.of_node, "xlnx,rxcsum", NULL);
-	if (p && be32_to_cpu(*p))
-		lp->temac_features |= TEMAC_FEATURE_RX_CSUM;
-
-	/* Find the DMA node, map the DMA registers, and decode the DMA IRQs */
-	np = of_parse_phandle(op->dev.of_node, "llink-connected", 0);
-	if (!np) {
-		dev_err(&op->dev, "could not find DMA node\n");
-		return -ENODEV;
-	}
 
-	/* Setup the DMA register accesses, could be DCR or memory mapped */
-	if (temac_dcr_setup(lp, op, np)) {
+	/* Setup LocalLink DMA */
+	if (temac_np) {
+		/* Find the DMA node, map the DMA registers, and
+		 * decode the DMA IRQs.
+		 */
+		dma_np = of_parse_phandle(temac_np, "llink-connected", 0);
+		if (!dma_np) {
+			dev_err(&pdev->dev, "could not find DMA node\n");
+			return -ENODEV;
+		}
 
-		/* no DCR in the device tree, try non-DCR */
-		lp->sdma_regs = devm_of_iomap(&op->dev, np, 0, NULL);
-		if (lp->sdma_regs) {
+		/* Setup the DMA register accesses, could be DCR or
+		 * memory mapped.
+		 */
+		if (temac_dcr_setup(lp, pdev, dma_np)) {
+			/* no DCR in the device tree, try non-DCR */
+			lp->sdma_regs = devm_of_iomap(&pdev->dev, dma_np, 0,
+						      NULL);
+			if (IS_ERR(lp->sdma_regs)) {
+				dev_err(&pdev->dev,
+					"unable to map DMA registers\n");
+				of_node_put(dma_np);
+				return PTR_ERR(lp->sdma_regs);
+			}
 			lp->dma_in = temac_dma_in32;
 			lp->dma_out = temac_dma_out32;
-			dev_dbg(&op->dev, "MEM base: %p\n", lp->sdma_regs);
-		} else {
-			dev_err(&op->dev, "unable to map DMA registers\n");
-			of_node_put(np);
-			return -ENOMEM;
+			dev_dbg(&pdev->dev, "MEM base: %p\n", lp->sdma_regs);
 		}
-	}
-
-	lp->rx_irq = irq_of_parse_and_map(np, 0);
-	lp->tx_irq = irq_of_parse_and_map(np, 1);
 
-	of_node_put(np); /* Finished with the DMA node; drop the reference */
+		/* Get DMA RX and TX interrupts */
+		lp->rx_irq = irq_of_parse_and_map(dma_np, 0);
+		lp->tx_irq = irq_of_parse_and_map(dma_np, 1);
+
+		/* Finished with the DMA node; drop the reference */
+		of_node_put(dma_np);
+	} else if (pdata) {
+		/* 2nd memory resource specifies DMA registers */
+		res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
+		lp->sdma_regs = devm_ioremap_nocache(&pdev->dev, res->start,
+						     resource_size(res));
+		if (IS_ERR(lp->sdma_regs)) {
+			dev_err(&pdev->dev,
+				"could not map DMA registers\n");
+			return PTR_ERR(lp->sdma_regs);
+		}
+		lp->dma_in = temac_dma_in32;
+		lp->dma_out = temac_dma_out32;
 
-	if (!lp->rx_irq || !lp->tx_irq) {
-		dev_err(&op->dev, "could not determine irqs\n");
-		return -ENOMEM;
+		/* Get DMA RX and TX interrupts */
+		lp->rx_irq = platform_get_irq(pdev, 0);
+		lp->tx_irq = platform_get_irq(pdev, 1);
 	}
 
+	/* Error handle returned DMA RX and TX interrupts */
+	if (lp->rx_irq < 0) {
+		if (lp->rx_irq != -EPROBE_DEFER)
+			dev_err(&pdev->dev, "could not get DMA RX irq\n");
+		return lp->rx_irq;
+	}
+	if (lp->tx_irq < 0) {
+		if (lp->tx_irq != -EPROBE_DEFER)
+			dev_err(&pdev->dev, "could not get DMA TX irq\n");
+		return lp->tx_irq;
+	}
 
-	/* Retrieve the MAC address */
-	addr = of_get_mac_address(op->dev.of_node);
-	if (!addr) {
-		dev_err(&op->dev, "could not find MAC address\n");
-		return -ENODEV;
+	if (temac_np) {
+		/* Retrieve the MAC address */
+		addr = of_get_mac_address(temac_np);
+		if (!addr) {
+			dev_err(&pdev->dev, "could not find MAC address\n");
+			return -ENODEV;
+		}
+		temac_init_mac_address(ndev, addr);
+	} else if (pdata) {
+		temac_init_mac_address(ndev, pdata->mac_addr);
 	}
-	temac_init_mac_address(ndev, addr);
 
 	rc = temac_mdio_setup(lp, pdev);
 	if (rc)
-		dev_warn(&op->dev, "error registering MDIO bus\n");
-
-	lp->phy_node = of_parse_phandle(op->dev.of_node, "phy-handle", 0);
-	if (lp->phy_node)
-		dev_dbg(lp->dev, "using PHY node %pOF (%p)\n", np, np);
+		dev_warn(&pdev->dev, "error registering MDIO bus\n");
+
+	if (temac_np) {
+		lp->phy_node = of_parse_phandle(temac_np, "phy-handle", 0);
+		if (lp->phy_node)
+			dev_dbg(lp->dev, "using PHY node %pOF\n", temac_np);
+	} else if (pdata) {
+		snprintf(lp->phy_name, sizeof(lp->phy_name),
+			 PHY_ID_FMT, lp->mii_bus->id, pdata->phy_addr);
+		lp->phy_interface = pdata->phy_interface;
+	}
 
 	/* Add the device attributes */
 	rc = sysfs_create_group(&lp->dev->kobj, &temac_attr_group);
@@ -1106,19 +1167,21 @@ static int temac_of_probe(struct platform_device *op)
 err_register_ndev:
 	sysfs_remove_group(&lp->dev->kobj, &temac_attr_group);
 err_sysfs_create:
-	of_node_put(lp->phy_node);
+	if (lp->phy_node)
+		of_node_put(lp->phy_node);
 	temac_mdio_teardown(lp);
 	return rc;
 }
 
-static int temac_of_remove(struct platform_device *op)
+static int temac_remove(struct platform_device *pdev)
 {
-	struct net_device *ndev = platform_get_drvdata(op);
+	struct net_device *ndev = platform_get_drvdata(pdev);
 	struct temac_local *lp = netdev_priv(ndev);
 
 	unregister_netdev(ndev);
 	sysfs_remove_group(&lp->dev->kobj, &temac_attr_group);
-	of_node_put(lp->phy_node);
+	if (lp->phy_node)
+		of_node_put(lp->phy_node);
 	temac_mdio_teardown(lp);
 	return 0;
 }
@@ -1132,16 +1195,16 @@ static const struct of_device_id temac_of_match[] = {
 };
 MODULE_DEVICE_TABLE(of, temac_of_match);
 
-static struct platform_driver temac_of_driver = {
-	.probe = temac_of_probe,
-	.remove = temac_of_remove,
+static struct platform_driver temac_driver = {
+	.probe = temac_probe,
+	.remove = temac_remove,
 	.driver = {
 		.name = "xilinx_temac",
 		.of_match_table = temac_of_match,
 	},
 };
 
-module_platform_driver(temac_of_driver);
+module_platform_driver(temac_driver);
 
 MODULE_DESCRIPTION("Xilinx LL_TEMAC Ethernet driver");
 MODULE_AUTHOR("Yoshio Kashiwagi");
diff --git a/drivers/net/ethernet/xilinx/ll_temac_mdio.c b/drivers/net/ethernet/xilinx/ll_temac_mdio.c
index a0b365e..c5307e5 100644
--- a/drivers/net/ethernet/xilinx/ll_temac_mdio.c
+++ b/drivers/net/ethernet/xilinx/ll_temac_mdio.c
@@ -14,6 +14,7 @@
 #include <linux/of_address.h>
 #include <linux/slab.h>
 #include <linux/of_mdio.h>
+#include <linux/platform_data/xilinx-ll-temac.h>
 
 #include "ll_temac.h"
 
@@ -59,6 +60,7 @@ static int temac_mdio_write(struct mii_bus *bus, int phy_id, int reg, u16 val)
 
 int temac_mdio_setup(struct temac_local *lp, struct platform_device *pdev)
 {
+	struct ll_temac_platform_data *pdata = dev_get_platdata(&pdev->dev);
 	struct device_node *np = dev_of_node(&pdev->dev);
 	struct mii_bus *bus;
 	u32 bus_hz;
@@ -66,9 +68,16 @@ int temac_mdio_setup(struct temac_local *lp, struct platform_device *pdev)
 	int rc;
 	struct resource res;
 
+	/* Get MDIO bus frequency (if specified) */
+	bus_hz = 0;
+	if (np)
+		of_property_read_u32(np, "clock-frequency", &bus_hz);
+	else if (pdata)
+		bus_hz = pdata->mdio_clk_freq;
+
 	/* Calculate a reasonable divisor for the clock rate */
 	clk_div = 0x3f; /* worst-case default setting */
-	if (of_property_read_u32(np, "clock-frequency", &bus_hz) == 0) {
+	if (bus_hz != 0) {
 		clk_div = bus_hz / (2500 * 1000 * 2) - 1;
 		if (clk_div < 1)
 			clk_div = 1;
@@ -86,9 +95,15 @@ int temac_mdio_setup(struct temac_local *lp, struct platform_device *pdev)
 	if (!bus)
 		return -ENOMEM;
 
-	of_address_to_resource(np, 0, &res);
-	snprintf(bus->id, MII_BUS_ID_SIZE, "%.8llx",
-		 (unsigned long long)res.start);
+	if (np) {
+		of_address_to_resource(np, 0, &res);
+		snprintf(bus->id, MII_BUS_ID_SIZE, "%.8llx",
+			 (unsigned long long)res.start);
+	} else if (pdata && pdata->mdio_bus_id >= 0) {
+		snprintf(bus->id, MII_BUS_ID_SIZE, "%.8llx",
+			 pdata->mdio_bus_id);
+	}
+
 	bus->priv = lp;
 	bus->name = "Xilinx TEMAC MDIO";
 	bus->read = temac_mdio_read;
diff --git a/include/linux/platform_data/xilinx-ll-temac.h b/include/linux/platform_data/xilinx-ll-temac.h
new file mode 100644
index 0000000..82e2f80
--- /dev/null
+++ b/include/linux/platform_data/xilinx-ll-temac.h
@@ -0,0 +1,19 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __LINUX_XILINX_LL_TEMAC_H
+#define __LINUX_XILINX_LL_TEMAC_H
+
+#include <linux/if_ether.h>
+#include <linux/phy.h>
+
+struct ll_temac_platform_data {
+	bool txcsum;		/* Enable/disable TX checksum */
+	bool rxcsum;		/* Enable/disable RX checksum */
+	u8 mac_addr[ETH_ALEN];	/* MAC address (6 bytes) */
+	/* Clock frequency for input to MDIO clock generator */
+	u32 mdio_clk_freq;
+	unsigned long long mdio_bus_id; /* Unique id for MDIO bus */
+	int phy_addr;		/* Address of the PHY to connect to */
+	phy_interface_t phy_interface; /* PHY interface mode */
+};
+
+#endif /* __LINUX_XILINX_LL_TEMAC_H */
-- 
2.4.11

