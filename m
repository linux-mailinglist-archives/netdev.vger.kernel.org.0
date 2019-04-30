Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03CEAF10E
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 09:18:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726445AbfD3HSJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 03:18:09 -0400
Received: from first.geanix.com ([116.203.34.67]:43604 "EHLO first.geanix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725769AbfD3HSI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Apr 2019 03:18:08 -0400
Received: from localhost (unknown [193.163.1.7])
        by first.geanix.com (Postfix) with ESMTPSA id AE5F3308E91;
        Tue, 30 Apr 2019 07:17:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=geanix.com; s=first;
        t=1556608679; bh=KW17p1JVOB8B4RAEjylmuKU7YJEfD12MGWZdK2FEDjY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=dCAFO65/n8KRgqWm0+y5R+GV3AmyZ3E6IZl15dQNHtk0y44d8cwlPaPbNVME89x24
         JpFjcRD951rwA2BiYDmRJWZlVjy2ljYcUvRVIV9lvX/7r5aHrh5ZyrSE/1XfASRuHP
         uxAQyURcjuLX69SW2VNaNymMo33ox0zmutdYOstS3Mnv6dQIUOeBFV/zPmq5cUOkPO
         hpEING27idLNZ3JnPfi8k2J383pRlY0IKeEuXGjc9RZ3fTqQ6eCdYHhiMKTOoV9so8
         WWSJlXsTjKGmnPgY/nNDWKRZ7pNhhiafqDxKFRsSSmJgbZHQnsuo+NdzelU5oeovXy
         VwdafplXE6CWw==
From:   Esben Haabendal <esben@geanix.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Michal Simek <michal.simek@xilinx.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Yang Wei <yang.wei9@zte.com.cn>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 01/12] net: ll_temac: Fix and simplify error handling by using devres functions
Date:   Tue, 30 Apr 2019 09:17:48 +0200
Message-Id: <20190430071759.2481-2-esben@geanix.com>
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

As a side effect, a few error cases are fixed.

If of_iomap() of sdma_regs failed, no error code was returned.  Fixed to
return -ENOMEM similar to of_iomap() fail of regs.

If sysfs_create_group() or register_netdev() failed, lp->phy_node was not
released.

Finally, the order in remove function is corrected to be reverse order
of what is done in probe, i.e. calling temac_mdio_teardown() last, so we
unregister the netdev that most likely is using the mdio_bus first.

Signed-off-by: Esben Haabendal <esben@geanix.com>
---
 drivers/net/ethernet/xilinx/ll_temac.h      |  2 +-
 drivers/net/ethernet/xilinx/ll_temac_main.c | 48 ++++++++++-------------------
 drivers/net/ethernet/xilinx/ll_temac_mdio.c | 14 +++------
 3 files changed, 22 insertions(+), 42 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/ll_temac.h b/drivers/net/ethernet/xilinx/ll_temac.h
index 1075752..4557578 100644
--- a/drivers/net/ethernet/xilinx/ll_temac.h
+++ b/drivers/net/ethernet/xilinx/ll_temac.h
@@ -378,7 +378,7 @@ void temac_indirect_out32(struct temac_local *lp, int reg, u32 value);
 
 
 /* xilinx_temac_mdio.c */
-int temac_mdio_setup(struct temac_local *lp, struct device_node *np);
+int temac_mdio_setup(struct temac_local *lp, struct platform_device *pdev);
 void temac_mdio_teardown(struct temac_local *lp);
 
 #endif /* XILINX_LL_TEMAC_H */
diff --git a/drivers/net/ethernet/xilinx/ll_temac_main.c b/drivers/net/ethernet/xilinx/ll_temac_main.c
index 44efffb..c4e85a9 100644
--- a/drivers/net/ethernet/xilinx/ll_temac_main.c
+++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
@@ -225,7 +225,6 @@ static void temac_dma_bd_release(struct net_device *ndev)
 		dma_free_coherent(ndev->dev.parent,
 				sizeof(*lp->tx_bd_v) * TX_BD_NUM,
 				lp->tx_bd_v, lp->tx_bd_p);
-	kfree(lp->rx_skb);
 }
 
 /**
@@ -237,7 +236,8 @@ static int temac_dma_bd_init(struct net_device *ndev)
 	struct sk_buff *skb;
 	int i;
 
-	lp->rx_skb = kcalloc(RX_BD_NUM, sizeof(*lp->rx_skb), GFP_KERNEL);
+	lp->rx_skb = devm_kcalloc(&ndev->dev, RX_BD_NUM, sizeof(*lp->rx_skb),
+				  GFP_KERNEL);
 	if (!lp->rx_skb)
 		goto out;
 
@@ -987,7 +987,7 @@ static int temac_of_probe(struct platform_device *op)
 	int rc = 0;
 
 	/* Init network device structure */
-	ndev = alloc_etherdev(sizeof(*lp));
+	ndev = devm_alloc_etherdev(&pdev->dev, sizeof(*lp));
 	if (!ndev)
 		return -ENOMEM;
 
@@ -1020,11 +1020,10 @@ static int temac_of_probe(struct platform_device *op)
 	mutex_init(&lp->indirect_mutex);
 
 	/* map device registers */
-	lp->regs = of_iomap(op->dev.of_node, 0);
+	lp->regs = devm_of_iomap(&op->dev, op->dev.of_node, 0, NULL);
 	if (!lp->regs) {
 		dev_err(&op->dev, "could not map temac regs.\n");
-		rc = -ENOMEM;
-		goto nodev;
+		return -ENOMEM;
 	}
 
 	/* Setup checksum offload, but default to off if not specified */
@@ -1043,15 +1042,14 @@ static int temac_of_probe(struct platform_device *op)
 	np = of_parse_phandle(op->dev.of_node, "llink-connected", 0);
 	if (!np) {
 		dev_err(&op->dev, "could not find DMA node\n");
-		rc = -ENODEV;
-		goto err_iounmap;
+		return -ENODEV;
 	}
 
 	/* Setup the DMA register accesses, could be DCR or memory mapped */
 	if (temac_dcr_setup(lp, op, np)) {
 
 		/* no DCR in the device tree, try non-DCR */
-		lp->sdma_regs = of_iomap(np, 0);
+		lp->sdma_regs = devm_of_iomap(&op->dev, np, 0, NULL);
 		if (lp->sdma_regs) {
 			lp->dma_in = temac_dma_in32;
 			lp->dma_out = temac_dma_out32;
@@ -1059,7 +1057,7 @@ static int temac_of_probe(struct platform_device *op)
 		} else {
 			dev_err(&op->dev, "unable to map DMA registers\n");
 			of_node_put(np);
-			goto err_iounmap;
+			return -ENOMEM;
 		}
 	}
 
@@ -1070,8 +1068,7 @@ static int temac_of_probe(struct platform_device *op)
 
 	if (!lp->rx_irq || !lp->tx_irq) {
 		dev_err(&op->dev, "could not determine irqs\n");
-		rc = -ENOMEM;
-		goto err_iounmap_2;
+		return -ENOMEM;
 	}
 
 
@@ -1079,12 +1076,11 @@ static int temac_of_probe(struct platform_device *op)
 	addr = of_get_mac_address(op->dev.of_node);
 	if (!addr) {
 		dev_err(&op->dev, "could not find MAC address\n");
-		rc = -ENODEV;
-		goto err_iounmap_2;
+		return -ENODEV;
 	}
 	temac_init_mac_address(ndev, addr);
 
-	rc = temac_mdio_setup(lp, op->dev.of_node);
+	rc = temac_mdio_setup(lp, pdev);
 	if (rc)
 		dev_warn(&op->dev, "error registering MDIO bus\n");
 
@@ -1096,7 +1092,7 @@ static int temac_of_probe(struct platform_device *op)
 	rc = sysfs_create_group(&lp->dev->kobj, &temac_attr_group);
 	if (rc) {
 		dev_err(lp->dev, "Error creating sysfs files\n");
-		goto err_iounmap_2;
+		goto err_sysfs_create;
 	}
 
 	rc = register_netdev(lp->ndev);
@@ -1107,16 +1103,11 @@ static int temac_of_probe(struct platform_device *op)
 
 	return 0;
 
- err_register_ndev:
+err_register_ndev:
 	sysfs_remove_group(&lp->dev->kobj, &temac_attr_group);
- err_iounmap_2:
-	if (lp->sdma_regs)
-		iounmap(lp->sdma_regs);
- err_iounmap:
-	iounmap(lp->regs);
- nodev:
-	free_netdev(ndev);
-	ndev = NULL;
+err_sysfs_create:
+	of_node_put(lp->phy_node);
+	temac_mdio_teardown(lp);
 	return rc;
 }
 
@@ -1125,15 +1116,10 @@ static int temac_of_remove(struct platform_device *op)
 	struct net_device *ndev = platform_get_drvdata(op);
 	struct temac_local *lp = netdev_priv(ndev);
 
-	temac_mdio_teardown(lp);
 	unregister_netdev(ndev);
 	sysfs_remove_group(&lp->dev->kobj, &temac_attr_group);
 	of_node_put(lp->phy_node);
-	lp->phy_node = NULL;
-	iounmap(lp->regs);
-	if (lp->sdma_regs)
-		iounmap(lp->sdma_regs);
-	free_netdev(ndev);
+	temac_mdio_teardown(lp);
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/xilinx/ll_temac_mdio.c b/drivers/net/ethernet/xilinx/ll_temac_mdio.c
index f5e83ac..a0b365e 100644
--- a/drivers/net/ethernet/xilinx/ll_temac_mdio.c
+++ b/drivers/net/ethernet/xilinx/ll_temac_mdio.c
@@ -57,8 +57,9 @@ static int temac_mdio_write(struct mii_bus *bus, int phy_id, int reg, u16 val)
 	return 0;
 }
 
-int temac_mdio_setup(struct temac_local *lp, struct device_node *np)
+int temac_mdio_setup(struct temac_local *lp, struct platform_device *pdev)
 {
+	struct device_node *np = dev_of_node(&pdev->dev);
 	struct mii_bus *bus;
 	u32 bus_hz;
 	int clk_div;
@@ -81,7 +82,7 @@ int temac_mdio_setup(struct temac_local *lp, struct device_node *np)
 	temac_indirect_out32(lp, XTE_MC_OFFSET, 1 << 6 | clk_div);
 	mutex_unlock(&lp->indirect_mutex);
 
-	bus = mdiobus_alloc();
+	bus = devm_mdiobus_alloc(&pdev->dev);
 	if (!bus)
 		return -ENOMEM;
 
@@ -98,23 +99,16 @@ int temac_mdio_setup(struct temac_local *lp, struct device_node *np)
 
 	rc = of_mdiobus_register(bus, np);
 	if (rc)
-		goto err_register;
+		return rc;
 
 	mutex_lock(&lp->indirect_mutex);
 	dev_dbg(lp->dev, "MDIO bus registered;  MC:%x\n",
 		temac_indirect_in32(lp, XTE_MC_OFFSET));
 	mutex_unlock(&lp->indirect_mutex);
 	return 0;
-
- err_register:
-	mdiobus_free(bus);
-	return rc;
 }
 
 void temac_mdio_teardown(struct temac_local *lp)
 {
 	mdiobus_unregister(lp->mii_bus);
-	mdiobus_free(lp->mii_bus);
-	lp->mii_bus = NULL;
 }
-
-- 
2.4.11

