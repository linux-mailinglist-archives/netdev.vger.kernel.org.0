Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A9D45F8C4C
	for <lists+netdev@lfdr.de>; Sun,  9 Oct 2022 18:23:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230114AbiJIQX4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Oct 2022 12:23:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230108AbiJIQXr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Oct 2022 12:23:47 -0400
Received: from bg4.exmail.qq.com (bg4.exmail.qq.com [43.154.221.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CE9E2A273;
        Sun,  9 Oct 2022 09:23:44 -0700 (PDT)
X-QQ-mid: bizesmtp62t1665332597ty859gma
Received: from localhost.localdomain ( [58.247.70.42])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Mon, 10 Oct 2022 00:23:16 +0800 (CST)
X-QQ-SSF: 01100000002000G0Z000B00A0000000
X-QQ-FEAT: Fc2LLDWeHZ9FuDdCABd4ojd+cA6d1/mnzanCc8JN/9JdtuDPtwI4qh4qsxyDG
        0zAIGKgvWcE6WThtla5s2zwbkMuhOTjDMaUM/+QbCLrCWQjHZv00G11cN0nZFX9htRfr3dW
        rc27axNE6sodx2KggvSUf0iP/Zp0HbmwFSXLz6zfjlf+CnL+eWP1i/MhGtaYK3PWQY4EG+3
        WMRC1rGyFzjGg7Fm04v4jWrzxY1HjjDflY+6yxCklmPbGPs48csMqp0OQ+I7y2BkIL3PSQi
        +C6CrYnmQGlLuCjZh49wV3MFNdd9o8I9DyHhVdi7Ov73HMpuVUDrLuFO5rNI55+Vp6yh5HT
        Uj8BPtUT+0Bk2m9VaERft50utrxi5gMrJwtTpMbUBMqH4f1BBvNkafqa+KEyw==
X-QQ-GoodBg: 0
From:   Soha Jin <soha@lohu.info>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Yangyu Chen <cyy@cyyself.name>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Soha Jin <soha@lohu.info>
Subject: [PATCH 1/3] net: stmmac: use fwnode instead of of to configure driver
Date:   Mon, 10 Oct 2022 00:22:45 +0800
Message-Id: <20221009162247.1336-2-soha@lohu.info>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009162247.1336-1-soha@lohu.info>
References: <20221009162247.1336-1-soha@lohu.info>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:lohu.info:qybglogicsvr:qybglogicsvr3
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To support devices described with not only device tree but also ACPI, the
commit refactors stmmac's configuration probing codes and dwmac's generic
driver with fwnode functions.

This commit also renames stmmac_{probe,remove}_config_dt to
stmmac_platform_{probe,remove}_config. Old names are still available by
adding two macros.

Signed-off-by: Soha Jin <soha@lohu.info>
Tested-by: Yangyu Chen <cyy@cyyself.name>
---
 .../ethernet/stmicro/stmmac/dwmac-generic.c   |  17 +-
 .../net/ethernet/stmicro/stmmac/dwmac-rk.c    |   9 +-
 .../net/ethernet/stmicro/stmmac/dwmac-sun8i.c |   2 +-
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |   7 +-
 .../net/ethernet/stmicro/stmmac/stmmac_mdio.c |  14 +-
 .../ethernet/stmicro/stmmac/stmmac_platform.c | 409 ++++++++++--------
 .../ethernet/stmicro/stmmac/stmmac_platform.h |  10 +-
 include/linux/stmmac.h                        |   7 +-
 8 files changed, 270 insertions(+), 205 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-generic.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-generic.c
index 5e731a72cce8..4d272605a8b7 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-generic.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-generic.c
@@ -26,17 +26,14 @@ static int dwmac_generic_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
-	if (pdev->dev.of_node) {
-		plat_dat = stmmac_probe_config_dt(pdev, stmmac_res.mac);
-		if (IS_ERR(plat_dat)) {
-			dev_err(&pdev->dev, "dt configuration failed\n");
-			return PTR_ERR(plat_dat);
-		}
-	} else {
+	plat_dat = stmmac_platform_probe_config(pdev, stmmac_res.mac);
+	if (IS_ERR(plat_dat)) {
+		dev_info(&pdev->dev, "failed to configure via properties: %ld",
+			 PTR_ERR(plat_dat));
 		plat_dat = dev_get_platdata(&pdev->dev);
 		if (!plat_dat) {
-			dev_err(&pdev->dev, "no platform data provided\n");
-			return  -EINVAL;
+			dev_err(&pdev->dev, "failed to get platform data\n");
+			return -EINVAL;
 		}
 
 		/* Set default value for multicast hash bins */
@@ -64,7 +61,7 @@ static int dwmac_generic_probe(struct platform_device *pdev)
 		plat_dat->exit(pdev, plat_dat->bsp_priv);
 err_remove_config_dt:
 	if (pdev->dev.of_node)
-		stmmac_remove_config_dt(pdev, plat_dat);
+		stmmac_platform_remove_config(pdev, plat_dat);
 
 	return ret;
 }
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
index f7269d79a385..b13e8f4e4bf5 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
@@ -1525,7 +1525,7 @@ static int rk_gmac_clk_init(struct plat_stmmacenet_data *plat)
 	}
 
 	if (plat->phy_node && bsp_priv->integrated_phy) {
-		bsp_priv->clk_phy = of_clk_get(plat->phy_node, 0);
+		bsp_priv->clk_phy = of_clk_get(to_of_node(plat->phy_node), 0);
 		if (IS_ERR(bsp_priv->clk_phy)) {
 			ret = PTR_ERR(bsp_priv->clk_phy);
 			dev_err(dev, "Cannot get PHY clock: %d\n", ret);
@@ -1645,6 +1645,7 @@ static struct rk_priv_data *rk_gmac_setup(struct platform_device *pdev,
 {
 	struct rk_priv_data *bsp_priv;
 	struct device *dev = &pdev->dev;
+	struct device_node *phy_node = to_of_node(plat->phy_node);
 	struct resource *res;
 	int ret;
 	const char *strings = NULL;
@@ -1723,11 +1724,11 @@ static struct rk_priv_data *rk_gmac_setup(struct platform_device *pdev,
 	bsp_priv->php_grf = syscon_regmap_lookup_by_phandle(dev->of_node,
 							    "rockchip,php-grf");
 
-	if (plat->phy_node) {
-		bsp_priv->integrated_phy = of_property_read_bool(plat->phy_node,
+	if (phy_node) {
+		bsp_priv->integrated_phy = of_property_read_bool(phy_node,
 								 "phy-is-integrated");
 		if (bsp_priv->integrated_phy) {
-			bsp_priv->phy_reset = of_reset_control_get(plat->phy_node, NULL);
+			bsp_priv->phy_reset = of_reset_control_get(phy_node, NULL);
 			if (IS_ERR(bsp_priv->phy_reset)) {
 				dev_err(&pdev->dev, "No PHY reset control found.\n");
 				bsp_priv->phy_reset = NULL;
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
index f834472599f7..573e0e0e9eda 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
@@ -940,7 +940,7 @@ static int sun8i_dwmac_set_syscon(struct device *dev,
 		/* Force EPHY xtal frequency to 24MHz. */
 		reg |= H3_EPHY_CLK_SEL;
 
-		ret = of_mdio_parse_addr(dev, plat->phy_node);
+		ret = of_mdio_parse_addr(dev, to_of_node(plat->phy_node));
 		if (ret < 0) {
 			dev_err(dev, "Could not parse MDIO addr\n");
 			return ret;
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 65c96773c6d2..220ce6b8e671 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -17,6 +17,7 @@
 #include <linux/clk.h>
 #include <linux/kernel.h>
 #include <linux/interrupt.h>
+#include <linux/property.h>
 #include <linux/ip.h>
 #include <linux/tcp.h>
 #include <linux/skbuff.h>
@@ -45,7 +46,6 @@
 #include "stmmac.h"
 #include "stmmac_xdp.h"
 #include <linux/reset.h>
-#include <linux/of_mdio.h>
 #include "dwmac1000.h"
 #include "dwxgmac2.h"
 #include "hwif.h"
@@ -1123,10 +1123,9 @@ static void stmmac_check_pcs_mode(struct stmmac_priv *priv)
 static int stmmac_init_phy(struct net_device *dev)
 {
 	struct stmmac_priv *priv = netdev_priv(dev);
-	struct fwnode_handle *fwnode;
+	struct fwnode_handle *fwnode = priv->plat->phylink_node;
 	int ret;
 
-	fwnode = of_fwnode_handle(priv->plat->phylink_node);
 	if (!fwnode)
 		fwnode = dev_fwnode(priv->device);
 
@@ -1162,7 +1161,7 @@ static int stmmac_init_phy(struct net_device *dev)
 static int stmmac_phy_setup(struct stmmac_priv *priv)
 {
 	struct stmmac_mdio_bus_data *mdio_bus_data = priv->plat->mdio_bus_data;
-	struct fwnode_handle *fwnode = of_fwnode_handle(priv->plat->phylink_node);
+	struct fwnode_handle *fwnode = priv->plat->phylink_node;
 	int max_speed = priv->plat->max_speed;
 	int mode = priv->plat->phy_interface;
 	struct phylink *phylink;
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
index 5f177ea80725..b67c3e4bb956 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
@@ -13,7 +13,10 @@
 #include <linux/gpio/consumer.h>
 #include <linux/io.h>
 #include <linux/iopoll.h>
+#include <linux/acpi.h>
+#include <linux/of.h>
 #include <linux/mii.h>
+#include <linux/acpi_mdio.h>
 #include <linux/of_mdio.h>
 #include <linux/pm_runtime.h>
 #include <linux/phy.h>
@@ -434,9 +437,9 @@ int stmmac_mdio_register(struct net_device *ndev)
 	int err = 0;
 	struct mii_bus *new_bus;
 	struct stmmac_priv *priv = netdev_priv(ndev);
-	struct fwnode_handle *fwnode = of_fwnode_handle(priv->plat->phylink_node);
+	struct fwnode_handle *fwnode = priv->plat->phylink_node;
 	struct stmmac_mdio_bus_data *mdio_bus_data = priv->plat->mdio_bus_data;
-	struct device_node *mdio_node = priv->plat->mdio_node;
+	struct fwnode_handle *mdio_node = priv->plat->mdio_node;
 	struct device *dev = ndev->dev.parent;
 	struct fwnode_handle *fixed_node;
 	int addr, found, max_addr;
@@ -482,7 +485,12 @@ int stmmac_mdio_register(struct net_device *ndev)
 	new_bus->phy_mask = mdio_bus_data->phy_mask;
 	new_bus->parent = priv->device;
 
-	err = of_mdiobus_register(new_bus, mdio_node);
+	if (is_of_node(mdio_node))
+		err = of_mdiobus_register(new_bus, to_of_node(mdio_node));
+	else if (is_acpi_node(mdio_node))
+		err = acpi_mdiobus_register(new_bus, mdio_node);
+	else
+		err = mdiobus_register(new_bus);
 	if (err != 0) {
 		dev_err_probe(dev, err, "Cannot register the MDIO bus\n");
 		goto bus_register_fail;
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
index 50f6b4a14be4..cc1cd03623bf 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
@@ -12,16 +12,15 @@
 #include <linux/pm_runtime.h>
 #include <linux/module.h>
 #include <linux/io.h>
+#include <linux/etherdevice.h>
+#include <linux/property.h>
 #include <linux/of.h>
-#include <linux/of_net.h>
-#include <linux/of_device.h>
-#include <linux/of_mdio.h>
+#include <linux/fwnode_mdio.h>
+#include <linux/clk-provider.h>
 
 #include "stmmac.h"
 #include "stmmac_platform.h"
 
-#ifdef CONFIG_OF
-
 /**
  * dwmac1000_validate_mcast_bins - validates the number of Multicast filter bins
  * @dev: struct device of the platform device
@@ -85,59 +84,64 @@ static int dwmac1000_validate_ucast_entries(struct device *dev,
 }
 
 /**
- * stmmac_axi_setup - parse DT parameters for programming the AXI register
+ * stmmac_axi_setup - parse properties for programming the AXI register
  * @pdev: platform device
  * Description:
- * if required, from device-tree the AXI internal register can be tuned
- * by using platform parameters.
+ * if required, the AXI internal register can be tuned by using platform
+ * parameters.
  */
 static struct stmmac_axi *stmmac_axi_setup(struct platform_device *pdev)
 {
-	struct device_node *np;
+	struct fwnode_handle *fwnode;
 	struct stmmac_axi *axi;
 
-	np = of_parse_phandle(pdev->dev.of_node, "snps,axi-config", 0);
-	if (!np)
+	fwnode = fwnode_find_reference(dev_fwnode(&pdev->dev),
+				       "snps,axi-config", 0);
+	if (IS_ERR(fwnode))
 		return NULL;
 
 	axi = devm_kzalloc(&pdev->dev, sizeof(*axi), GFP_KERNEL);
 	if (!axi) {
-		of_node_put(np);
+		fwnode_handle_put(fwnode);
 		return ERR_PTR(-ENOMEM);
 	}
 
-	axi->axi_lpi_en = of_property_read_bool(np, "snps,lpi_en");
-	axi->axi_xit_frm = of_property_read_bool(np, "snps,xit_frm");
-	axi->axi_kbbe = of_property_read_bool(np, "snps,axi_kbbe");
-	axi->axi_fb = of_property_read_bool(np, "snps,axi_fb");
-	axi->axi_mb = of_property_read_bool(np, "snps,axi_mb");
-	axi->axi_rb =  of_property_read_bool(np, "snps,axi_rb");
+	axi->axi_lpi_en = fwnode_property_read_bool(fwnode, "snps,lpi_en");
+	axi->axi_xit_frm = fwnode_property_read_bool(fwnode, "snps,xit_frm");
+	axi->axi_kbbe = fwnode_property_read_bool(fwnode, "snps,axi_kbbe");
+	axi->axi_fb = fwnode_property_read_bool(fwnode, "snps,axi_fb");
+	axi->axi_mb = fwnode_property_read_bool(fwnode, "snps,axi_mb");
+	axi->axi_rb =  fwnode_property_read_bool(fwnode, "snps,axi_rb");
 
-	if (of_property_read_u32(np, "snps,wr_osr_lmt", &axi->axi_wr_osr_lmt))
+	if (fwnode_property_read_u32(fwnode, "snps,wr_osr_lmt",
+				     &axi->axi_wr_osr_lmt))
 		axi->axi_wr_osr_lmt = 1;
-	if (of_property_read_u32(np, "snps,rd_osr_lmt", &axi->axi_rd_osr_lmt))
+	if (fwnode_property_read_u32(fwnode, "snps,rd_osr_lmt",
+				     &axi->axi_rd_osr_lmt))
 		axi->axi_rd_osr_lmt = 1;
-	of_property_read_u32_array(np, "snps,blen", axi->axi_blen, AXI_BLEN);
-	of_node_put(np);
+	fwnode_property_read_u32_array(fwnode, "snps,blen", axi->axi_blen,
+				       AXI_BLEN);
+	fwnode_handle_put(fwnode);
 
 	return axi;
 }
 
 /**
- * stmmac_mtl_setup - parse DT parameters for multiple queues configuration
+ * stmmac_mtl_setup - parse properties for multiple queues configuration
  * @pdev: platform device
  * @plat: enet data
  */
 static int stmmac_mtl_setup(struct platform_device *pdev,
 			    struct plat_stmmacenet_data *plat)
 {
-	struct device_node *q_node;
-	struct device_node *rx_node;
-	struct device_node *tx_node;
+	struct fwnode_handle *fwnode = dev_fwnode(&pdev->dev);
+	struct fwnode_handle *q_node;
+	struct fwnode_handle *rx_node;
+	struct fwnode_handle *tx_node;
 	u8 queue = 0;
 	int ret = 0;
 
-	/* For backwards-compatibility with device trees that don't have any
+	/* For backwards-compatibility with properties that don't have any
 	 * snps,mtl-rx-config or snps,mtl-tx-config properties, we fall back
 	 * to one RX and TX queues each.
 	 */
@@ -151,47 +155,48 @@ static int stmmac_mtl_setup(struct platform_device *pdev,
 	plat->rx_queues_cfg[0].mode_to_use = MTL_QUEUE_DCB;
 	plat->tx_queues_cfg[0].mode_to_use = MTL_QUEUE_DCB;
 
-	rx_node = of_parse_phandle(pdev->dev.of_node, "snps,mtl-rx-config", 0);
-	if (!rx_node)
+	rx_node = fwnode_find_reference(fwnode, "snps,mtl-rx-config", 0);
+	if (IS_ERR(rx_node))
 		return ret;
 
-	tx_node = of_parse_phandle(pdev->dev.of_node, "snps,mtl-tx-config", 0);
-	if (!tx_node) {
-		of_node_put(rx_node);
+	tx_node = fwnode_find_reference(fwnode, "snps,mtl-tx-config", 0);
+	if (IS_ERR(tx_node)) {
+		fwnode_handle_put(rx_node);
 		return ret;
 	}
 
 	/* Processing RX queues common config */
-	if (of_property_read_u32(rx_node, "snps,rx-queues-to-use",
-				 &plat->rx_queues_to_use))
+	if (fwnode_property_read_u32(rx_node, "snps,rx-queues-to-use",
+				     &plat->rx_queues_to_use))
 		plat->rx_queues_to_use = 1;
 
-	if (of_property_read_bool(rx_node, "snps,rx-sched-sp"))
+	if (fwnode_property_read_bool(rx_node, "snps,rx-sched-sp"))
 		plat->rx_sched_algorithm = MTL_RX_ALGORITHM_SP;
-	else if (of_property_read_bool(rx_node, "snps,rx-sched-wsp"))
+	else if (fwnode_property_read_bool(rx_node, "snps,rx-sched-wsp"))
 		plat->rx_sched_algorithm = MTL_RX_ALGORITHM_WSP;
 	else
 		plat->rx_sched_algorithm = MTL_RX_ALGORITHM_SP;
 
 	/* Processing individual RX queue config */
-	for_each_child_of_node(rx_node, q_node) {
+	fwnode_for_each_child_node(rx_node, q_node) {
 		if (queue >= plat->rx_queues_to_use)
 			break;
 
-		if (of_property_read_bool(q_node, "snps,dcb-algorithm"))
+		if (fwnode_property_read_bool(q_node, "snps,dcb-algorithm"))
 			plat->rx_queues_cfg[queue].mode_to_use = MTL_QUEUE_DCB;
-		else if (of_property_read_bool(q_node, "snps,avb-algorithm"))
+		else if (fwnode_property_read_bool(q_node,
+						   "snps,avb-algorithm"))
 			plat->rx_queues_cfg[queue].mode_to_use = MTL_QUEUE_AVB;
 		else
 			plat->rx_queues_cfg[queue].mode_to_use = MTL_QUEUE_DCB;
 
-		if (of_property_read_u32(q_node, "snps,map-to-dma-channel",
-					 &plat->rx_queues_cfg[queue].chan))
+		if (fwnode_property_read_u32(q_node, "snps,map-to-dma-channel",
+					     &plat->rx_queues_cfg[queue].chan))
 			plat->rx_queues_cfg[queue].chan = queue;
 		/* TODO: Dynamic mapping to be included in the future */
 
-		if (of_property_read_u32(q_node, "snps,priority",
-					&plat->rx_queues_cfg[queue].prio)) {
+		if (fwnode_property_read_u32(q_node, "snps,priority",
+			&plat->rx_queues_cfg[queue].prio)) {
 			plat->rx_queues_cfg[queue].prio = 0;
 			plat->rx_queues_cfg[queue].use_prio = false;
 		} else {
@@ -199,15 +204,16 @@ static int stmmac_mtl_setup(struct platform_device *pdev,
 		}
 
 		/* RX queue specific packet type routing */
-		if (of_property_read_bool(q_node, "snps,route-avcp"))
+		if (fwnode_property_read_bool(q_node, "snps,route-avcp"))
 			plat->rx_queues_cfg[queue].pkt_route = PACKET_AVCPQ;
-		else if (of_property_read_bool(q_node, "snps,route-ptp"))
+		else if (fwnode_property_read_bool(q_node, "snps,route-ptp"))
 			plat->rx_queues_cfg[queue].pkt_route = PACKET_PTPQ;
-		else if (of_property_read_bool(q_node, "snps,route-dcbcp"))
+		else if (fwnode_property_read_bool(q_node, "snps,route-dcbcp"))
 			plat->rx_queues_cfg[queue].pkt_route = PACKET_DCBCPQ;
-		else if (of_property_read_bool(q_node, "snps,route-up"))
+		else if (fwnode_property_read_bool(q_node, "snps,route-up"))
 			plat->rx_queues_cfg[queue].pkt_route = PACKET_UPQ;
-		else if (of_property_read_bool(q_node, "snps,route-multi-broad"))
+		else if (fwnode_property_read_bool(q_node,
+						   "snps,route-multi-broad"))
 			plat->rx_queues_cfg[queue].pkt_route = PACKET_MCBCQ;
 		else
 			plat->rx_queues_cfg[queue].pkt_route = 0x0;
@@ -221,15 +227,15 @@ static int stmmac_mtl_setup(struct platform_device *pdev,
 	}
 
 	/* Processing TX queues common config */
-	if (of_property_read_u32(tx_node, "snps,tx-queues-to-use",
-				 &plat->tx_queues_to_use))
+	if (fwnode_property_read_u32(tx_node, "snps,tx-queues-to-use",
+				     &plat->tx_queues_to_use))
 		plat->tx_queues_to_use = 1;
 
-	if (of_property_read_bool(tx_node, "snps,tx-sched-wrr"))
+	if (fwnode_property_read_bool(tx_node, "snps,tx-sched-wrr"))
 		plat->tx_sched_algorithm = MTL_TX_ALGORITHM_WRR;
-	else if (of_property_read_bool(tx_node, "snps,tx-sched-wfq"))
+	else if (fwnode_property_read_bool(tx_node, "snps,tx-sched-wfq"))
 		plat->tx_sched_algorithm = MTL_TX_ALGORITHM_WFQ;
-	else if (of_property_read_bool(tx_node, "snps,tx-sched-dwrr"))
+	else if (fwnode_property_read_bool(tx_node, "snps,tx-sched-dwrr"))
 		plat->tx_sched_algorithm = MTL_TX_ALGORITHM_DWRR;
 	else
 		plat->tx_sched_algorithm = MTL_TX_ALGORITHM_SP;
@@ -237,39 +243,39 @@ static int stmmac_mtl_setup(struct platform_device *pdev,
 	queue = 0;
 
 	/* Processing individual TX queue config */
-	for_each_child_of_node(tx_node, q_node) {
+	fwnode_for_each_child_node(tx_node, q_node) {
 		if (queue >= plat->tx_queues_to_use)
 			break;
 
-		if (of_property_read_u32(q_node, "snps,weight",
-					 &plat->tx_queues_cfg[queue].weight))
+		if (fwnode_property_read_u32(q_node, "snps,weight",
+			&plat->tx_queues_cfg[queue].weight))
 			plat->tx_queues_cfg[queue].weight = 0x10 + queue;
 
-		if (of_property_read_bool(q_node, "snps,dcb-algorithm")) {
+		if (fwnode_property_read_bool(q_node, "snps,dcb-algorithm")) {
 			plat->tx_queues_cfg[queue].mode_to_use = MTL_QUEUE_DCB;
-		} else if (of_property_read_bool(q_node,
-						 "snps,avb-algorithm")) {
+		} else if (fwnode_property_read_bool(q_node,
+						     "snps,avb-algorithm")) {
 			plat->tx_queues_cfg[queue].mode_to_use = MTL_QUEUE_AVB;
 
 			/* Credit Base Shaper parameters used by AVB */
-			if (of_property_read_u32(q_node, "snps,send_slope",
+			if (fwnode_property_read_u32(q_node, "snps,send_slope",
 				&plat->tx_queues_cfg[queue].send_slope))
 				plat->tx_queues_cfg[queue].send_slope = 0x0;
-			if (of_property_read_u32(q_node, "snps,idle_slope",
+			if (fwnode_property_read_u32(q_node, "snps,idle_slope",
 				&plat->tx_queues_cfg[queue].idle_slope))
 				plat->tx_queues_cfg[queue].idle_slope = 0x0;
-			if (of_property_read_u32(q_node, "snps,high_credit",
+			if (fwnode_property_read_u32(q_node, "snps,high_credit",
 				&plat->tx_queues_cfg[queue].high_credit))
 				plat->tx_queues_cfg[queue].high_credit = 0x0;
-			if (of_property_read_u32(q_node, "snps,low_credit",
+			if (fwnode_property_read_u32(q_node, "snps,low_credit",
 				&plat->tx_queues_cfg[queue].low_credit))
 				plat->tx_queues_cfg[queue].low_credit = 0x0;
 		} else {
 			plat->tx_queues_cfg[queue].mode_to_use = MTL_QUEUE_DCB;
 		}
 
-		if (of_property_read_u32(q_node, "snps,priority",
-					&plat->tx_queues_cfg[queue].prio)) {
+		if (fwnode_property_read_u32(q_node, "snps,priority",
+			&plat->tx_queues_cfg[queue].prio)) {
 			plat->tx_queues_cfg[queue].prio = 0;
 			plat->tx_queues_cfg[queue].use_prio = false;
 		} else {
@@ -285,17 +291,17 @@ static int stmmac_mtl_setup(struct platform_device *pdev,
 	}
 
 out:
-	of_node_put(rx_node);
-	of_node_put(tx_node);
-	of_node_put(q_node);
+	fwnode_handle_put(rx_node);
+	fwnode_handle_put(tx_node);
+	fwnode_handle_put(q_node);
 
 	return ret;
 }
 
 /**
- * stmmac_dt_phy - parse device-tree driver parameters to allocate PHY resources
+ * stmmac_parse_phy - parse driver parameters to allocate PHY resources
  * @plat: driver data platform structure
- * @np: device tree node
+ * @fwnode: fwnode handle
  * @dev: device pointer
  * Description:
  * The mdio bus will be allocated in case of a phy transceiver is on board;
@@ -317,25 +323,22 @@ static int stmmac_mtl_setup(struct platform_device *pdev,
  *
  * It returns 0 in case of success otherwise -ENODEV.
  */
-static int stmmac_dt_phy(struct plat_stmmacenet_data *plat,
-			 struct device_node *np, struct device *dev)
+static int stmmac_parse_phy(struct plat_stmmacenet_data *plat,
+			    struct fwnode_handle *fwnode)
 {
-	bool mdio = !of_phy_is_fixed_link(np);
-	static const struct of_device_id need_mdio_ids[] = {
-		{ .compatible = "snps,dwc-qos-ethernet-4.10" },
-		{},
-	};
-
-	if (of_match_node(need_mdio_ids, np)) {
-		plat->mdio_node = of_get_child_by_name(np, "mdio");
+	struct device *dev = fwnode->dev;
+	bool mdio = !fwnode_phy_is_fixed_link(fwnode);
+
+	if (fwnode_is_compatible(fwnode, "snps,dwc-qos-ethernet-4.10")) {
+		plat->mdio_node = fwnode_get_named_child_node(fwnode, "mdio");
 	} else {
 		/**
-		 * If snps,dwmac-mdio is passed from DT, always register
+		 * If snps,dwmac-mdio is passed from properties, always register
 		 * the MDIO
 		 */
-		for_each_child_of_node(np, plat->mdio_node) {
-			if (of_device_is_compatible(plat->mdio_node,
-						    "snps,dwmac-mdio"))
+		fwnode_for_each_child_node(fwnode, plat->mdio_node) {
+			if (fwnode_is_compatible(plat->mdio_node,
+						 "snps,dwmac-mdio"))
 				break;
 		}
 	}
@@ -359,20 +362,20 @@ static int stmmac_dt_phy(struct plat_stmmacenet_data *plat,
 }
 
 /**
- * stmmac_of_get_mac_mode - retrieves the interface of the MAC
- * @np: - device-tree node
+ * stmmac_get_mac_mode - retrieves the interface of the MAC
+ * @fwnode: fwnode handle
  * Description:
- * Similar to `of_get_phy_mode()`, this function will retrieve (from
- * the device-tree) the interface mode on the MAC side. This assumes
- * that there is mode converter in-between the MAC & PHY
+ * Similar to `fwnode_get_phy_mode()`, this function will retrieve
+ * (from the fwnode properties) the interface mode on the MAC side.
+ * This assumes that there is mode converter in-between the MAC & PHY
  * (e.g. GMII-to-RGMII).
  */
-static int stmmac_of_get_mac_mode(struct device_node *np)
+static int stmmac_get_mac_mode(struct fwnode_handle *fwnode)
 {
 	const char *pm;
 	int err, i;
 
-	err = of_property_read_string(np, "mac-mode", &pm);
+	err = fwnode_property_read_string(fwnode, "mac-mode", &pm);
 	if (err < 0)
 		return err;
 
@@ -385,20 +388,78 @@ static int stmmac_of_get_mac_mode(struct device_node *np)
 }
 
 /**
- * stmmac_probe_config_dt - parse device-tree driver parameters
+ * stmmac_prepare_csr_clock - prepare MAC's CSR clock
+ * @fwnode: fwnode handle
+ * @plat: platform data
+ * Description:
+ * Get CSR clock associated to the device with device tree. If device is
+ * described by ACPI, then try to create a fixed clock with the
+ * clock-frequency property.
+ */
+static int stmmac_prepare_csr_clock(struct fwnode_handle *fwnode,
+				    struct plat_stmmacenet_data *plat)
+{
+	struct device *dev = fwnode->dev;
+	const char *name = dev_name(dev);
+	int freq;
+	int ret = 0;
+
+	plat->stmmac_clk = devm_clk_get(dev, STMMAC_RESOURCE_NAME);
+	if (!IS_ERR(plat->stmmac_clk))
+		goto finish;
+
+	/* Try create a fixed clock if there is no clock assoicate */
+	if (fwnode_property_read_u32(fwnode, "clock-frequency", &freq)) {
+		ret = -ENODEV;
+		goto error;
+	}
+	plat->created_stmmac_clk = true;
+
+	plat->stmmac_clk = clk_register_fixed_rate(dev, name, NULL, 0, freq);
+	if (IS_ERR(plat->stmmac_clk)) {
+		ret = PTR_ERR(plat->stmmac_clk);
+		goto error;
+	}
+
+finish:
+	clk_prepare_enable(plat->stmmac_clk);
+	return 0;
+error:
+	plat->stmmac_clk = NULL;
+	plat->created_stmmac_clk = false;
+	return ret;
+}
+
+/**
+ * stmmac_unprepare_csr_clock - unprepare MAC's CSR clock
+ * @plat: platform data
+ * Description:
+ * Disable and unprepare CSR clock.
+ */
+static int stmmac_unprepare_csr_clock(struct plat_stmmacenet_data *plat)
+{
+	clk_disable_unprepare(plat->stmmac_clk);
+	if (plat->created_stmmac_clk)
+		clk_unregister_fixed_rate(plat->stmmac_clk);
+	return 0;
+}
+
+/**
+ * stmmac_platform_probe_config - parse driver parameters from fwnode properties
  * @pdev: platform_device structure
  * @mac: MAC address to use
  * Description:
- * this function is to read the driver parameters from device-tree and
+ * this function is to read the driver parameters from fwnode and
  * set some private fields that will be used by the main at runtime.
  */
 struct plat_stmmacenet_data *
-stmmac_probe_config_dt(struct platform_device *pdev, u8 *mac)
+stmmac_platform_probe_config(struct platform_device *pdev, u8 *mac)
 {
-	struct device_node *np = pdev->dev.of_node;
+	struct fwnode_handle *fwnode = dev_fwnode(&pdev->dev);
 	struct plat_stmmacenet_data *plat;
 	struct stmmac_dma_cfg *dma_cfg;
 	int phy_mode;
+	int bus_id = 0;
 	void *ret;
 	int rc;
 
@@ -406,7 +467,7 @@ stmmac_probe_config_dt(struct platform_device *pdev, u8 *mac)
 	if (!plat)
 		return ERR_PTR(-ENOMEM);
 
-	rc = of_get_mac_address(np, mac);
+	rc = fwnode_get_mac_address(fwnode, mac);
 	if (rc) {
 		if (rc == -EPROBE_DEFER)
 			return ERR_PTR(rc);
@@ -414,28 +475,31 @@ stmmac_probe_config_dt(struct platform_device *pdev, u8 *mac)
 		eth_zero_addr(mac);
 	}
 
-	phy_mode = device_get_phy_mode(&pdev->dev);
+	phy_mode = fwnode_get_phy_mode(fwnode);
 	if (phy_mode < 0)
 		return ERR_PTR(phy_mode);
 
 	plat->phy_interface = phy_mode;
-	plat->interface = stmmac_of_get_mac_mode(np);
+	plat->interface = stmmac_get_mac_mode(fwnode);
 	if (plat->interface < 0)
 		plat->interface = plat->phy_interface;
 
 	/* Some wrapper drivers still rely on phy_node. Let's save it while
 	 * they are not converted to phylink. */
-	plat->phy_node = of_parse_phandle(np, "phy-handle", 0);
+	plat->phy_node = fwnode_find_reference(fwnode, "phy-handle", 0);
+	if (IS_ERR(plat->phy_node))
+		plat->phy_node = NULL;
 
 	/* PHYLINK automatically parses the phy-handle property */
-	plat->phylink_node = np;
+	plat->phylink_node = fwnode;
 
-	/* Get max speed of operation from device tree */
-	of_property_read_u32(np, "max-speed", &plat->max_speed);
+	/* Get max speed of operation from property */
+	fwnode_property_read_u32(fwnode, "max-speed", &plat->max_speed);
 
-	plat->bus_id = of_alias_get_id(np, "ethernet");
-	if (plat->bus_id < 0)
-		plat->bus_id = 0;
+	if (fwnode_property_read_u32(fwnode, "bus_id", &bus_id) != 0 &&
+	    is_of_node(fwnode))
+		bus_id = of_alias_get_id(to_of_node(fwnode), "ethernet");
+	plat->bus_id = bus_id < 0 ? 0 : bus_id;
 
 	/* Default to phy auto-detection */
 	plat->phy_addr = -1;
@@ -444,32 +508,33 @@ stmmac_probe_config_dt(struct platform_device *pdev, u8 *mac)
 	 * or get clk_csr from device tree.
 	 */
 	plat->clk_csr = -1;
-	if (of_property_read_u32(np, "snps,clk-csr", &plat->clk_csr))
-		of_property_read_u32(np, "clk_csr", &plat->clk_csr);
+	if (fwnode_property_read_u32(fwnode, "snps,clk-csr", &plat->clk_csr))
+		fwnode_property_read_u32(fwnode, "clk_csr", &plat->clk_csr);
 
 	/* "snps,phy-addr" is not a standard property. Mark it as deprecated
 	 * and warn of its use. Remove this when phy node support is added.
 	 */
-	if (of_property_read_u32(np, "snps,phy-addr", &plat->phy_addr) == 0)
+	if (fwnode_property_read_u32(fwnode,
+				     "snps,phy-addr", &plat->phy_addr) == 0)
 		dev_warn(&pdev->dev, "snps,phy-addr property is deprecated\n");
 
-	/* To Configure PHY by using all device-tree supported properties */
-	rc = stmmac_dt_phy(plat, np, &pdev->dev);
+	/* To Configure PHY by using all supported properties */
+	rc = stmmac_parse_phy(plat, fwnode);
 	if (rc)
 		return ERR_PTR(rc);
 
-	of_property_read_u32(np, "tx-fifo-depth", &plat->tx_fifo_size);
+	fwnode_property_read_u32(fwnode, "tx-fifo-depth", &plat->tx_fifo_size);
 
-	of_property_read_u32(np, "rx-fifo-depth", &plat->rx_fifo_size);
+	fwnode_property_read_u32(fwnode, "rx-fifo-depth", &plat->rx_fifo_size);
 
 	plat->force_sf_dma_mode =
-		of_property_read_bool(np, "snps,force_sf_dma_mode");
+		fwnode_property_read_bool(fwnode, "snps,force_sf_dma_mode");
 
 	plat->en_tx_lpi_clockgating =
-		of_property_read_bool(np, "snps,en-tx-lpi-clockgating");
+		fwnode_property_read_bool(fwnode, "snps,en-tx-lpi-clockgating");
 
 	/* Set the maxmtu to a default of JUMBO_LEN in case the
-	 * parameter is not present in the device tree.
+	 * parameter is not present in the properties.
 	 */
 	plat->maxmtu = JUMBO_LEN;
 
@@ -484,10 +549,12 @@ stmmac_probe_config_dt(struct platform_device *pdev, u8 *mac)
 	 * are provided. All other properties should be added
 	 * once needed on other platforms.
 	 */
-	if (of_device_is_compatible(np, "st,spear600-gmac") ||
-		of_device_is_compatible(np, "snps,dwmac-3.50a") ||
-		of_device_is_compatible(np, "snps,dwmac-3.70a") ||
-		of_device_is_compatible(np, "snps,dwmac")) {
+	if (fwnode_is_compatible(fwnode, "st,spear600-gmac") ||
+	    fwnode_is_compatible(fwnode, "snps,dwmac-3.50a") ||
+	    fwnode_is_compatible(fwnode, "snps,dwmac-3.70a") ||
+	    fwnode_is_compatible(fwnode, "snps,dwmac") ||
+	    /* for ACPI devices as default */
+	    !fwnode_property_string_array_count(fwnode, "compatible")) {
 		/* Note that the max-frame-size parameter as defined in the
 		 * ePAPR v1.1 spec is defined as max-frame-size, it's
 		 * actually used as the IEEE definition of MAC Client
@@ -495,11 +562,12 @@ stmmac_probe_config_dt(struct platform_device *pdev, u8 *mac)
 		 * the definition is max-frame-size, but usage examples
 		 * are clearly MTUs
 		 */
-		of_property_read_u32(np, "max-frame-size", &plat->maxmtu);
-		of_property_read_u32(np, "snps,multicast-filter-bins",
-				     &plat->multicast_filter_bins);
-		of_property_read_u32(np, "snps,perfect-filter-entries",
-				     &plat->unicast_filter_entries);
+		fwnode_property_read_u32(fwnode, "max-frame-size",
+					 &plat->maxmtu);
+		fwnode_property_read_u32(fwnode, "snps,multicast-filter-bins",
+					 &plat->multicast_filter_bins);
+		fwnode_property_read_u32(fwnode, "snps,perfect-filter-entries",
+					 &plat->unicast_filter_entries);
 		plat->unicast_filter_entries = dwmac1000_validate_ucast_entries(
 				&pdev->dev, plat->unicast_filter_entries);
 		plat->multicast_filter_bins = dwmac1000_validate_mcast_bins(
@@ -508,7 +576,7 @@ stmmac_probe_config_dt(struct platform_device *pdev, u8 *mac)
 		plat->pmt = 1;
 	}
 
-	if (of_device_is_compatible(np, "snps,dwmac-3.40a")) {
+	if (fwnode_is_compatible(fwnode, "snps,dwmac-3.40a")) {
 		plat->has_gmac = 1;
 		plat->enh_desc = 1;
 		plat->tx_coe = 1;
@@ -516,74 +584,73 @@ stmmac_probe_config_dt(struct platform_device *pdev, u8 *mac)
 		plat->pmt = 1;
 	}
 
-	if (of_device_is_compatible(np, "snps,dwmac-4.00") ||
-	    of_device_is_compatible(np, "snps,dwmac-4.10a") ||
-	    of_device_is_compatible(np, "snps,dwmac-4.20a") ||
-	    of_device_is_compatible(np, "snps,dwmac-5.10a")) {
+	if (fwnode_is_compatible(fwnode, "snps,dwmac-4.00") ||
+	    fwnode_is_compatible(fwnode, "snps,dwmac-4.10a") ||
+	    fwnode_is_compatible(fwnode, "snps,dwmac-4.20a") ||
+	    fwnode_is_compatible(fwnode, "snps,dwmac-5.10a")) {
 		plat->has_gmac4 = 1;
 		plat->has_gmac = 0;
 		plat->pmt = 1;
-		plat->tso_en = of_property_read_bool(np, "snps,tso");
+		plat->tso_en = fwnode_property_read_bool(fwnode, "snps,tso");
 	}
 
-	if (of_device_is_compatible(np, "snps,dwmac-3.610") ||
-		of_device_is_compatible(np, "snps,dwmac-3.710")) {
+	if (fwnode_is_compatible(fwnode, "snps,dwmac-3.610") ||
+	    fwnode_is_compatible(fwnode, "snps,dwmac-3.710")) {
 		plat->enh_desc = 1;
 		plat->bugged_jumbo = 1;
 		plat->force_sf_dma_mode = 1;
 	}
 
-	if (of_device_is_compatible(np, "snps,dwxgmac")) {
+	if (fwnode_is_compatible(fwnode, "snps,dwxgmac")) {
 		plat->has_xgmac = 1;
 		plat->pmt = 1;
-		plat->tso_en = of_property_read_bool(np, "snps,tso");
+		plat->tso_en = fwnode_property_read_bool(fwnode, "snps,tso");
 	}
 
 	dma_cfg = devm_kzalloc(&pdev->dev, sizeof(*dma_cfg),
 			       GFP_KERNEL);
 	if (!dma_cfg) {
-		stmmac_remove_config_dt(pdev, plat);
+		stmmac_platform_remove_config(pdev, plat);
 		return ERR_PTR(-ENOMEM);
 	}
 	plat->dma_cfg = dma_cfg;
 
-	of_property_read_u32(np, "snps,pbl", &dma_cfg->pbl);
+	fwnode_property_read_u32(fwnode, "snps,pbl", &dma_cfg->pbl);
 	if (!dma_cfg->pbl)
 		dma_cfg->pbl = DEFAULT_DMA_PBL;
-	of_property_read_u32(np, "snps,txpbl", &dma_cfg->txpbl);
-	of_property_read_u32(np, "snps,rxpbl", &dma_cfg->rxpbl);
-	dma_cfg->pblx8 = !of_property_read_bool(np, "snps,no-pbl-x8");
-
-	dma_cfg->aal = of_property_read_bool(np, "snps,aal");
-	dma_cfg->fixed_burst = of_property_read_bool(np, "snps,fixed-burst");
-	dma_cfg->mixed_burst = of_property_read_bool(np, "snps,mixed-burst");
-
-	plat->force_thresh_dma_mode = of_property_read_bool(np, "snps,force_thresh_dma_mode");
+	fwnode_property_read_u32(fwnode, "snps,txpbl", &dma_cfg->txpbl);
+	fwnode_property_read_u32(fwnode, "snps,rxpbl", &dma_cfg->rxpbl);
+	dma_cfg->pblx8 = !fwnode_property_read_bool(fwnode, "snps,no-pbl-x8");
+
+	dma_cfg->aal = fwnode_property_read_bool(fwnode, "snps,aal");
+	dma_cfg->fixed_burst = fwnode_property_read_bool(fwnode,
+							 "snps,fixed-burst");
+	dma_cfg->mixed_burst = fwnode_property_read_bool(fwnode,
+							 "snps,mixed-burst");
+
+	plat->force_thresh_dma_mode = fwnode_property_read_bool(fwnode,
+								"snps,force_thresh_dma_mode");
 	if (plat->force_thresh_dma_mode) {
 		plat->force_sf_dma_mode = 0;
 		dev_warn(&pdev->dev,
 			 "force_sf_dma_mode is ignored if force_thresh_dma_mode is set.\n");
 	}
 
-	of_property_read_u32(np, "snps,ps-speed", &plat->mac_port_sel_speed);
+	fwnode_property_read_u32(fwnode, "snps,ps-speed",
+				 &plat->mac_port_sel_speed);
 
 	plat->axi = stmmac_axi_setup(pdev);
 
 	rc = stmmac_mtl_setup(pdev, plat);
 	if (rc) {
-		stmmac_remove_config_dt(pdev, plat);
+		stmmac_platform_remove_config(pdev, plat);
 		return ERR_PTR(rc);
 	}
 
 	/* clock setup */
-	if (!of_device_is_compatible(np, "snps,dwc-qos-ethernet-4.10")) {
-		plat->stmmac_clk = devm_clk_get(&pdev->dev,
-						STMMAC_RESOURCE_NAME);
-		if (IS_ERR(plat->stmmac_clk)) {
+	if (!fwnode_is_compatible(fwnode, "snps,dwc-qos-ethernet-4.10")) {
+		if (stmmac_prepare_csr_clock(fwnode, plat))
 			dev_warn(&pdev->dev, "Cannot get CSR clock\n");
-			plat->stmmac_clk = NULL;
-		}
-		clk_prepare_enable(plat->stmmac_clk);
 	}
 
 	plat->pclk = devm_clk_get_optional(&pdev->dev, "pclk");
@@ -623,40 +690,28 @@ stmmac_probe_config_dt(struct platform_device *pdev, u8 *mac)
 error_hw_init:
 	clk_disable_unprepare(plat->pclk);
 error_pclk_get:
-	clk_disable_unprepare(plat->stmmac_clk);
+	stmmac_unprepare_csr_clock(plat);
 
 	return ret;
 }
+EXPORT_SYMBOL_GPL(stmmac_platform_probe_config);
 
 /**
- * stmmac_remove_config_dt - undo the effects of stmmac_probe_config_dt()
+ * stmmac_platform_remove_config - undo the effects of stmmac_platform_probe_config()
  * @pdev: platform_device structure
  * @plat: driver data platform structure
  *
- * Release resources claimed by stmmac_probe_config_dt().
+ * Release resources claimed by stmmac_platform_probe_config().
  */
-void stmmac_remove_config_dt(struct platform_device *pdev,
-			     struct plat_stmmacenet_data *plat)
+void stmmac_platform_remove_config(struct platform_device *pdev,
+				   struct plat_stmmacenet_data *plat)
 {
-	clk_disable_unprepare(plat->stmmac_clk);
+	stmmac_unprepare_csr_clock(plat);
 	clk_disable_unprepare(plat->pclk);
-	of_node_put(plat->phy_node);
-	of_node_put(plat->mdio_node);
-}
-#else
-struct plat_stmmacenet_data *
-stmmac_probe_config_dt(struct platform_device *pdev, u8 *mac)
-{
-	return ERR_PTR(-EINVAL);
-}
-
-void stmmac_remove_config_dt(struct platform_device *pdev,
-			     struct plat_stmmacenet_data *plat)
-{
+	fwnode_handle_put(plat->phy_node);
+	fwnode_handle_put(plat->mdio_node);
 }
-#endif /* CONFIG_OF */
-EXPORT_SYMBOL_GPL(stmmac_probe_config_dt);
-EXPORT_SYMBOL_GPL(stmmac_remove_config_dt);
+EXPORT_SYMBOL_GPL(stmmac_platform_remove_config);
 
 int stmmac_get_platform_resources(struct platform_device *pdev,
 				  struct stmmac_resources *stmmac_res)
@@ -716,7 +771,7 @@ int stmmac_pltfr_remove(struct platform_device *pdev)
 	if (plat->exit)
 		plat->exit(pdev, plat->bsp_priv);
 
-	stmmac_remove_config_dt(pdev, plat);
+	stmmac_platform_remove_config(pdev, plat);
 
 	return ret;
 }
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.h b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.h
index 3fff3f59d73d..e6b33ccfbf9d 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.h
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.h
@@ -12,9 +12,13 @@
 #include "stmmac.h"
 
 struct plat_stmmacenet_data *
-stmmac_probe_config_dt(struct platform_device *pdev, u8 *mac);
-void stmmac_remove_config_dt(struct platform_device *pdev,
-			     struct plat_stmmacenet_data *plat);
+stmmac_platform_probe_config(struct platform_device *pdev, u8 *mac);
+void stmmac_platform_remove_config(struct platform_device *pdev,
+				   struct plat_stmmacenet_data *plat);
+
+#define stmmac_probe_config_dt(_d, _m) stmmac_platform_probe_config(_d, _m)
+#define stmmac_remove_config_dt(_d, _p) stmmac_platform_remove_config(_d, _p)
+
 
 int stmmac_get_platform_resources(struct platform_device *pdev,
 				  struct stmmac_resources *stmmac_res);
diff --git a/include/linux/stmmac.h b/include/linux/stmmac.h
index fb2e88614f5d..a449a72a9543 100644
--- a/include/linux/stmmac.h
+++ b/include/linux/stmmac.h
@@ -192,9 +192,9 @@ struct plat_stmmacenet_data {
 	int interface;
 	phy_interface_t phy_interface;
 	struct stmmac_mdio_bus_data *mdio_bus_data;
-	struct device_node *phy_node;
-	struct device_node *phylink_node;
-	struct device_node *mdio_node;
+	struct fwnode_handle *phy_node;
+	struct fwnode_handle *phylink_node;
+	struct fwnode_handle *mdio_node;
 	struct stmmac_dma_cfg *dma_cfg;
 	struct stmmac_est *est;
 	struct stmmac_fpe_cfg *fpe_cfg;
@@ -271,5 +271,6 @@ struct plat_stmmacenet_data {
 	int msi_tx_base_vec;
 	bool use_phy_wol;
 	bool sph_disable;
+	bool created_stmmac_clk;
 };
 #endif
-- 
2.30.2

