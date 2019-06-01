Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DF40318A6
	for <lists+netdev@lfdr.de>; Sat,  1 Jun 2019 02:09:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727087AbfFAAIp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 20:08:45 -0400
Received: from mailgw02.mediatek.com ([216.200.240.185]:33677 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726944AbfFAAIa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 20:08:30 -0400
X-UUID: 2af49424811f4517bc250af39235dfd8-20190531
X-UUID: 2af49424811f4517bc250af39235dfd8-20190531
Received: from mtkcas68.mediatek.inc [(172.29.94.19)] by mailgw02.mediatek.com
        (envelope-from <sean.wang@mediatek.com>)
        (musrelay.mediatek.com ESMTP with TLS)
        with ESMTP id 355522189; Fri, 31 May 2019 16:03:26 -0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 MTKMBS62DR.mediatek.inc (172.29.94.18) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Fri, 31 May 2019 17:03:25 -0700
Received: from mtkswgap22.mediatek.inc (172.21.77.33) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Sat, 1 Jun 2019 08:03:24 +0800
From:   <sean.wang@mediatek.com>
To:     <john@phrozen.org>, <davem@davemloft.net>
CC:     <nbd@openwrt.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>,
        Sean Wang <sean.wang@mediatek.com>
Subject: [PATCH net-next v1 4/6] net: ethernet: mediatek: Integrate hardware path from GMAC to PHY variants
Date:   Sat, 1 Jun 2019 08:03:13 +0800
Message-ID: <1559347395-14058-5-git-send-email-sean.wang@mediatek.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1559347395-14058-1-git-send-email-sean.wang@mediatek.com>
References: <1559347395-14058-1-git-send-email-sean.wang@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sean Wang <sean.wang@mediatek.com>

All path route on various SoCs all would be managed in common function
mtk_setup_hw_path that is determined by the both applied devicetree
regarding the path between GMAC and the target PHY or switch by the
capability of target SoC in the runtime.

Signed-off-by: Sean Wang <sean.wang@mediatek.com>
---
 drivers/net/ethernet/mediatek/Makefile       |   3 +-
 drivers/net/ethernet/mediatek/mtk_eth_path.c | 323 +++++++++++++++++++
 drivers/net/ethernet/mediatek/mtk_eth_soc.c  |  70 +---
 drivers/net/ethernet/mediatek/mtk_eth_soc.h  | 123 ++++++-
 4 files changed, 450 insertions(+), 69 deletions(-)
 create mode 100644 drivers/net/ethernet/mediatek/mtk_eth_path.c

diff --git a/drivers/net/ethernet/mediatek/Makefile b/drivers/net/ethernet/mediatek/Makefile
index b8206605154e..212c86f9982f 100644
--- a/drivers/net/ethernet/mediatek/Makefile
+++ b/drivers/net/ethernet/mediatek/Makefile
@@ -3,4 +3,5 @@
 # Makefile for the Mediatek SoCs built-in ethernet macs
 #
 
-obj-$(CONFIG_NET_MEDIATEK_SOC)			+= mtk_eth_soc.o mtk_sgmii.o
+obj-$(CONFIG_NET_MEDIATEK_SOC)                 += mtk_eth_soc.o mtk_sgmii.o \
+						  mtk_eth_path.o
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_path.c b/drivers/net/ethernet/mediatek/mtk_eth_path.c
new file mode 100644
index 000000000000..61f705d945e5
--- /dev/null
+++ b/drivers/net/ethernet/mediatek/mtk_eth_path.c
@@ -0,0 +1,323 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (c) 2018-2019 MediaTek Inc.
+
+/* A library for configuring path from GMAC/GDM to target PHY
+ *
+ * Author: Sean Wang <sean.wang@mediatek.com>
+ *
+ */
+
+#include <linux/phy.h>
+#include <linux/regmap.h>
+
+#include "mtk_eth_soc.h"
+
+struct mtk_eth_muxc {
+	int (*set_path)(struct mtk_eth *eth, int path);
+};
+
+static const char * const mtk_eth_mux_name[] = {
+	"mux_gdm1_to_gmac1_esw", "mux_gmac2_gmac0_to_gephy",
+	"mux_u3_gmac2_to_qphy", "mux_gmac1_gmac2_to_sgmii_rgmii",
+	"mux_gmac12_to_gephy_sgmii",
+};
+
+static const char * const mtk_eth_path_name[] = {
+	"gmac1_rgmii", "gmac1_trgmii", "gmac1_sgmii", "gmac2_rgmii",
+	"gmac2_sgmii", "gmac2_gephy", "gdm1_esw",
+};
+
+static int set_mux_gdm1_to_gmac1_esw(struct mtk_eth *eth, int path)
+{
+	bool updated = true;
+	u32 val, mask, set;
+
+	switch (path) {
+	case MTK_ETH_PATH_GMAC1_SGMII:
+		mask = ~(u32)MTK_MUX_TO_ESW;
+		set = 0;
+		break;
+	case MTK_ETH_PATH_GDM1_ESW:
+		mask = ~(u32)MTK_MUX_TO_ESW;
+		set = MTK_MUX_TO_ESW;
+		break;
+	default:
+		updated = false;
+		break;
+	};
+
+	if (updated) {
+		val = mtk_r32(eth, MTK_MAC_MISC);
+		val = (val & mask) | set;
+		mtk_w32(eth, val, MTK_MAC_MISC);
+	}
+
+	dev_dbg(eth->dev, "path %s in %s updated = %d\n",
+		mtk_eth_path_name[path], __func__, updated);
+
+	return 0;
+}
+
+static int set_mux_gmac2_gmac0_to_gephy(struct mtk_eth *eth, int path)
+{
+	unsigned int val = 0;
+	bool updated = true;
+
+	switch (path) {
+	case MTK_ETH_PATH_GMAC2_GEPHY:
+		val = ~(u32)GEPHY_MAC_SEL;
+		break;
+	default:
+		updated = false;
+		break;
+	}
+
+	if (updated)
+		regmap_update_bits(eth->infra, INFRA_MISC2, GEPHY_MAC_SEL, val);
+
+	dev_dbg(eth->dev, "path %s in %s updated = %d\n",
+		mtk_eth_path_name[path], __func__, updated);
+
+	return 0;
+}
+
+static int set_mux_u3_gmac2_to_qphy(struct mtk_eth *eth, int path)
+{
+	unsigned int val = 0;
+	bool updated = true;
+
+	switch (path) {
+	case MTK_ETH_PATH_GMAC2_SGMII:
+		val = CO_QPHY_SEL;
+		break;
+	default:
+		updated = false;
+		break;
+	}
+
+	if (updated)
+		regmap_update_bits(eth->infra, INFRA_MISC2, CO_QPHY_SEL, val);
+
+	dev_dbg(eth->dev, "path %s in %s updated = %d\n",
+		mtk_eth_path_name[path], __func__, updated);
+
+	return 0;
+}
+
+static int set_mux_gmac1_gmac2_to_sgmii_rgmii(struct mtk_eth *eth, int path)
+{
+	unsigned int val = 0;
+	bool updated = true;
+
+	switch (path) {
+	case MTK_ETH_PATH_GMAC1_SGMII:
+		val = SYSCFG0_SGMII_GMAC1;
+		break;
+	case MTK_ETH_PATH_GMAC2_SGMII:
+		val = SYSCFG0_SGMII_GMAC2;
+		break;
+	case MTK_ETH_PATH_GMAC1_RGMII:
+	case MTK_ETH_PATH_GMAC2_RGMII:
+		regmap_read(eth->ethsys, ETHSYS_SYSCFG0, &val);
+		val &= SYSCFG0_SGMII_MASK;
+
+		if ((path == MTK_GMAC1_RGMII && val == SYSCFG0_SGMII_GMAC1) ||
+		    (path == MTK_GMAC2_RGMII && val == SYSCFG0_SGMII_GMAC2))
+			val = 0;
+		else
+			updated = false;
+		break;
+	default:
+		updated = false;
+		break;
+	};
+
+	if (updated)
+		regmap_update_bits(eth->ethsys, ETHSYS_SYSCFG0,
+				   SYSCFG0_SGMII_MASK, val);
+
+	dev_dbg(eth->dev, "path %s in %s updated = %d\n",
+		mtk_eth_path_name[path], __func__, updated);
+
+	return 0;
+}
+
+static int set_mux_gmac12_to_gephy_sgmii(struct mtk_eth *eth, int path)
+{
+	unsigned int val = 0;
+	bool updated = true;
+
+	regmap_read(eth->ethsys, ETHSYS_SYSCFG0, &val);
+
+	switch (path) {
+	case MTK_ETH_PATH_GMAC1_SGMII:
+		val |= SYSCFG0_SGMII_GMAC1_V2;
+		break;
+	case MTK_ETH_PATH_GMAC2_GEPHY:
+		val &= ~(u32)SYSCFG0_SGMII_GMAC2_V2;
+		break;
+	case MTK_ETH_PATH_GMAC2_SGMII:
+		val |= SYSCFG0_SGMII_GMAC2_V2;
+		break;
+	default:
+		updated = false;
+	};
+
+	if (updated)
+		regmap_update_bits(eth->ethsys, ETHSYS_SYSCFG0,
+				   SYSCFG0_SGMII_MASK, val);
+
+	dev_dbg(eth->dev, "path %s in %s updated = %d\n",
+		mtk_eth_path_name[path], __func__, updated);
+
+	return 0;
+}
+
+static const struct mtk_eth_muxc mtk_eth_muxc[] = {
+	{ .set_path = set_mux_gdm1_to_gmac1_esw, },
+	{ .set_path = set_mux_gmac2_gmac0_to_gephy, },
+	{ .set_path = set_mux_u3_gmac2_to_qphy, },
+	{ .set_path = set_mux_gmac1_gmac2_to_sgmii_rgmii, },
+	{ .set_path = set_mux_gmac12_to_gephy_sgmii, }
+};
+
+static int mtk_eth_mux_setup(struct mtk_eth *eth, int path)
+{
+	int i, err = 0;
+
+	if (!MTK_HAS_CAPS(eth->soc->caps, MTK_PATH_BIT(path))) {
+		dev_err(eth->dev, "path %s isn't support on the SoC\n",
+			mtk_eth_path_name[path]);
+		return -EINVAL;
+	}
+
+	if (!MTK_HAS_CAPS(eth->soc->caps, MTK_MUX))
+		return 0;
+
+	/* Setup MUX in path fabric */
+	for (i = 0; i < MTK_ETH_MUX_MAX; i++) {
+		if (MTK_HAS_CAPS(eth->soc->caps, MTK_MUX_BIT(i))) {
+			err = mtk_eth_muxc[i].set_path(eth, path);
+			if (err)
+				goto out;
+		} else {
+			dev_dbg(eth->dev, "mux %s isn't present on the SoC\n",
+				mtk_eth_mux_name[i]);
+		}
+	}
+
+out:
+	return err;
+}
+
+static int mtk_gmac_sgmii_path_setup(struct mtk_eth *eth, int mac_id)
+{
+	unsigned int val = 0;
+	int sid, err, path;
+
+	path = (mac_id == 0) ?  MTK_ETH_PATH_GMAC1_SGMII :
+				MTK_ETH_PATH_GMAC2_SGMII;
+
+	/* Setup proper MUXes along the path */
+	err = mtk_eth_mux_setup(eth, path);
+	if (err)
+		return err;
+
+	/* The path GMAC to SGMII will be enabled once the SGMIISYS is being
+	 * setup done.
+	 */
+	regmap_read(eth->ethsys, ETHSYS_SYSCFG0, &val);
+
+	regmap_update_bits(eth->ethsys, ETHSYS_SYSCFG0,
+			   SYSCFG0_SGMII_MASK, ~(u32)SYSCFG0_SGMII_MASK);
+
+	/* Decide how GMAC and SGMIISYS be mapped */
+	sid = (MTK_HAS_CAPS(eth->soc->caps, MTK_SHARED_SGMII)) ? 0 : mac_id;
+
+	/* Setup SGMIISYS with the determined property */
+	if (MTK_HAS_FLAGS(eth->sgmii->flags[sid], MTK_SGMII_PHYSPEED_AN))
+		err = mtk_sgmii_setup_mode_an(eth->sgmii, sid);
+	else
+		err = mtk_sgmii_setup_mode_force(eth->sgmii, sid);
+
+	if (err)
+		return err;
+
+	regmap_update_bits(eth->ethsys, ETHSYS_SYSCFG0,
+			   SYSCFG0_SGMII_MASK, val);
+
+	return 0;
+}
+
+static int mtk_gmac_gephy_path_setup(struct mtk_eth *eth, int mac_id)
+{
+	int err, path = 0;
+
+	if (mac_id == 1)
+		path = MTK_ETH_PATH_GMAC2_GEPHY;
+
+	if (!path)
+		return -EINVAL;
+
+	/* Setup proper MUXes along the path */
+	err = mtk_eth_mux_setup(eth, path);
+	if (err)
+		return err;
+
+	return 0;
+}
+
+static int mtk_gmac_rgmii_path_setup(struct mtk_eth *eth, int mac_id)
+{
+	int err, path;
+
+	path = (mac_id == 0) ?  MTK_ETH_PATH_GMAC1_RGMII :
+				MTK_ETH_PATH_GMAC2_RGMII;
+
+	/* Setup proper MUXes along the path */
+	err = mtk_eth_mux_setup(eth, path);
+	if (err)
+		return err;
+
+	return 0;
+}
+
+int mtk_setup_hw_path(struct mtk_eth *eth, int mac_id, int phymode)
+{
+	int err;
+
+	switch (phymode) {
+	case PHY_INTERFACE_MODE_TRGMII:
+	case PHY_INTERFACE_MODE_RGMII_TXID:
+	case PHY_INTERFACE_MODE_RGMII_RXID:
+	case PHY_INTERFACE_MODE_RGMII_ID:
+	case PHY_INTERFACE_MODE_RGMII:
+	case PHY_INTERFACE_MODE_MII:
+	case PHY_INTERFACE_MODE_REVMII:
+	case PHY_INTERFACE_MODE_RMII:
+		if (MTK_HAS_CAPS(eth->soc->caps, MTK_RGMII)) {
+			err = mtk_gmac_rgmii_path_setup(eth, mac_id);
+			if (err)
+				return err;
+		}
+		break;
+	case PHY_INTERFACE_MODE_SGMII:
+		if (MTK_HAS_CAPS(eth->soc->caps, MTK_SGMII)) {
+			err = mtk_gmac_sgmii_path_setup(eth, mac_id);
+			if (err)
+				return err;
+		}
+		break;
+	case PHY_INTERFACE_MODE_GMII:
+		if (MTK_HAS_CAPS(eth->soc->caps, MTK_GEPHY)) {
+			err = mtk_gmac_gephy_path_setup(eth, mac_id);
+			if (err)
+				return err;
+		}
+		break;
+	default:
+		break;
+	}
+
+	return 0;
+}
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index d0cff646d3de..382173fa4752 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -165,50 +165,6 @@ static void mtk_gmac0_rgmii_adjust(struct mtk_eth *eth, int speed)
 	mtk_w32(eth, val, TRGMII_TCK_CTRL);
 }
 
-static int mtk_gmac_sgmii_hw_setup(struct mtk_eth *eth, int mac_id)
-{
-	int sid, err;
-	u32 val;
-
-	/* Enable GMAC with SGMII once we finish the SGMII setup. */
-	regmap_read(eth->ethsys, ETHSYS_SYSCFG0, &val);
-	val &= ~SYSCFG0_SGMII_MASK;
-	regmap_write(eth->ethsys, ETHSYS_SYSCFG0, val);
-
-	if (MTK_HAS_CAPS(eth->soc->caps, MTK_GMAC_SHARED_SGMII))
-		sid = 0;
-	else
-		sid = mac_id;
-
-	if (MTK_HAS_FLAGS(eth->sgmii->flags[sid], MTK_SGMII_PHYSPEED_AN))
-		err = mtk_sgmii_setup_mode_an(eth->sgmii, sid);
-	else
-		err = mtk_sgmii_setup_mode_force(eth->sgmii, sid);
-
-	if (err)
-		return err;
-
-	/* Determine MUX for which GMAC uses the SGMII interface */
-	regmap_read(eth->ethsys, ETHSYS_SYSCFG0, &val);
-	if (!mac_id)
-		val |= SYSCFG0_SGMII_GMAC1;
-	else
-		val |= MTK_HAS_CAPS(eth->soc->caps, MTK_GMAC_SHARED_SGMII) ?
-		SYSCFG0_SGMII_GMAC2 : SYSCFG0_SGMII_GMAC2_V2;
-	regmap_write(eth->ethsys, ETHSYS_SYSCFG0, val);
-
-	/* Setup the GMAC1 going through SGMII path when SoC also support
-	 * ESW on GMAC1
-	 */
-	if (MTK_HAS_CAPS(eth->soc->caps, MTK_GMAC1_ESW | MTK_GMAC1_SGMII) &&
-	    !mac_id) {
-		mtk_w32(eth, 0, MTK_MAC_MISC);
-		dev_info(eth->dev, "setup gmac1 going through sgmii");
-	}
-
-	return 0;
-}
-
 static void mtk_phy_link_adjust(struct net_device *dev)
 {
 	struct mtk_mac *mac = netdev_priv(dev);
@@ -308,6 +264,10 @@ static int mtk_phy_connect(struct net_device *dev)
 	if (!np)
 		return -ENODEV;
 
+	err = mtk_setup_hw_path(eth, mac->id, of_get_phy_mode(np));
+	if (err)
+		goto err_phy;
+
 	mac->ge_mode = 0;
 	switch (of_get_phy_mode(np)) {
 	case PHY_INTERFACE_MODE_TRGMII:
@@ -316,15 +276,10 @@ static int mtk_phy_connect(struct net_device *dev)
 	case PHY_INTERFACE_MODE_RGMII_RXID:
 	case PHY_INTERFACE_MODE_RGMII_ID:
 	case PHY_INTERFACE_MODE_RGMII:
-		break;
 	case PHY_INTERFACE_MODE_SGMII:
-		if (MTK_HAS_CAPS(eth->soc->caps, MTK_SGMII)) {
-			err = mtk_gmac_sgmii_hw_setup(eth, mac->id);
-			if (err)
-				goto err_phy;
-		}
 		break;
 	case PHY_INTERFACE_MODE_MII:
+	case PHY_INTERFACE_MODE_GMII:
 		mac->ge_mode = 1;
 		break;
 	case PHY_INTERFACE_MODE_REVMII:
@@ -2490,6 +2445,15 @@ static int mtk_probe(struct platform_device *pdev)
 		return PTR_ERR(eth->ethsys);
 	}
 
+	if (MTK_HAS_CAPS(eth->soc->caps, MTK_INFRA)) {
+		eth->infra = syscon_regmap_lookup_by_phandle(pdev->dev.of_node,
+							     "mediatek,infracfg");
+		if (IS_ERR(eth->infra)) {
+			dev_err(&pdev->dev, "no infracfg regmap found\n");
+			return PTR_ERR(eth->infra);
+		}
+	}
+
 	if (MTK_HAS_CAPS(eth->soc->caps, MTK_SGMII)) {
 		eth->sgmii = devm_kzalloc(eth->dev, sizeof(*eth->sgmii),
 					  GFP_KERNEL);
@@ -2641,7 +2605,7 @@ static int mtk_remove(struct platform_device *pdev)
 }
 
 static const struct mtk_soc_data mt2701_data = {
-	.caps = MTK_GMAC1_TRGMII | MTK_HWLRO,
+	.caps = MT7623_CAPS | MTK_HWLRO,
 	.required_clks = MT7623_CLKS_BITMAP,
 	.required_pctl = true,
 };
@@ -2654,13 +2618,13 @@ static const struct mtk_soc_data mt7621_data = {
 
 static const struct mtk_soc_data mt7622_data = {
 	.ana_rgc3 = 0x2028,
-	.caps = MTK_GMAC_SHARED_SGMII | MTK_GMAC1_ESW | MTK_HWLRO,
+	.caps = MT7622_CAPS | MTK_HWLRO,
 	.required_clks = MT7622_CLKS_BITMAP,
 	.required_pctl = false,
 };
 
 static const struct mtk_soc_data mt7623_data = {
-	.caps = MTK_GMAC1_TRGMII | MTK_HWLRO,
+	.caps = MT7623_CAPS | MTK_HWLRO,
 	.required_clks = MT7623_CLKS_BITMAP,
 	.required_pctl = true,
 };
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
index 2e65115cf932..89d68dd60b3d 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
@@ -373,10 +373,12 @@
 #define ETHSYS_SYSCFG0		0x14
 #define SYSCFG0_GE_MASK		0x3
 #define SYSCFG0_GE_MODE(x, y)	(x << (12 + (y * 2)))
-#define SYSCFG0_SGMII_MASK	(3 << 8)
-#define SYSCFG0_SGMII_GMAC1	((2 << 8) & GENMASK(9, 8))
-#define SYSCFG0_SGMII_GMAC2	((3 << 8) & GENMASK(9, 8))
-#define SYSCFG0_SGMII_GMAC2_V2  ((1 << 8) & GENMASK(9, 8))
+#define SYSCFG0_SGMII_MASK     GENMASK(9, 8)
+#define SYSCFG0_SGMII_GMAC1    ((2 << 8) & SYSCFG0_SGMII_MASK)
+#define SYSCFG0_SGMII_GMAC2    ((3 << 8) & SYSCFG0_SGMII_MASK)
+#define SYSCFG0_SGMII_GMAC1_V2 BIT(9)
+#define SYSCFG0_SGMII_GMAC2_V2 BIT(8)
+
 
 /* ethernet subsystem clock register */
 #define ETHSYS_CLKCFG0		0x2c
@@ -404,6 +406,11 @@
 #define SGMSYS_QPHY_PWR_STATE_CTRL 0xe8
 #define	SGMII_PHYA_PWD		BIT(4)
 
+/* Infrasys subsystem config registers */
+#define INFRA_MISC2            0x70c
+#define CO_QPHY_SEL            BIT(0)
+#define GEPHY_MAC_SEL          BIT(1)
+
 struct mtk_rx_dma {
 	unsigned int rxd1;
 	unsigned int rxd2;
@@ -565,19 +572,101 @@ struct mtk_rx_ring {
 	u32 crx_idx_reg;
 };
 
-#define MTK_TRGMII			BIT(0)
-#define MTK_GMAC1_TRGMII		(BIT(1) | MTK_TRGMII)
-#define MTK_ESW				BIT(4)
-#define MTK_GMAC1_ESW			(BIT(5) | MTK_ESW)
-#define MTK_SGMII			BIT(8)
-#define MTK_GMAC1_SGMII			(BIT(9) | MTK_SGMII)
-#define MTK_GMAC2_SGMII			(BIT(10) | MTK_SGMII)
-#define MTK_GMAC_SHARED_SGMII		(BIT(11) | MTK_GMAC1_SGMII | \
-					 MTK_GMAC2_SGMII)
-#define MTK_HWLRO			BIT(12)
-#define MTK_SHARED_INT			BIT(13)
+enum mtk_eth_mux {
+	MTK_ETH_MUX_GDM1_TO_GMAC1_ESW,
+	MTK_ETH_MUX_GMAC2_GMAC0_TO_GEPHY,
+	MTK_ETH_MUX_U3_GMAC2_TO_QPHY,
+	MTK_ETH_MUX_GMAC1_GMAC2_TO_SGMII_RGMII,
+	MTK_ETH_MUX_GMAC12_TO_GEPHY_SGMII,
+	MTK_ETH_MUX_MAX,
+};
+
+enum mtk_eth_path {
+	MTK_ETH_PATH_GMAC1_RGMII,
+	MTK_ETH_PATH_GMAC1_TRGMII,
+	MTK_ETH_PATH_GMAC1_SGMII,
+	MTK_ETH_PATH_GMAC2_RGMII,
+	MTK_ETH_PATH_GMAC2_SGMII,
+	MTK_ETH_PATH_GMAC2_GEPHY,
+	MTK_ETH_PATH_GDM1_ESW,
+	MTK_ETH_PATH_MAX,
+};
+
+/* Supported hardware group on SoCs */
+#define MTK_RGMII			BIT(0)
+#define MTK_TRGMII			BIT(1)
+#define MTK_SGMII			BIT(2)
+#define MTK_ESW				BIT(3)
+#define MTK_GEPHY			BIT(4)
+#define MTK_MUX				BIT(5)
+#define MTK_INFRA			BIT(6)
+#define MTK_SHARED_SGMII		BIT(7)
+#define MTK_HWLRO			BIT(8)
+#define MTK_SHARED_INT			BIT(9)
+
+/* Supported path present on SoCs */
+#define MTK_PATH_BIT(x)         BIT((x) + 10)
+
+#define MTK_GMAC1_RGMII \
+	(MTK_PATH_BIT(MTK_ETH_PATH_GMAC1_RGMII) | MTK_RGMII)
+
+#define MTK_GMAC1_TRGMII \
+	(MTK_PATH_BIT(MTK_ETH_PATH_GMAC1_TRGMII) | MTK_TRGMII)
+
+#define MTK_GMAC1_SGMII \
+	(MTK_PATH_BIT(MTK_ETH_PATH_GMAC1_SGMII) | MTK_SGMII)
+
+#define MTK_GMAC2_RGMII \
+	(MTK_PATH_BIT(MTK_ETH_PATH_GMAC2_RGMII) | MTK_RGMII)
+
+#define MTK_GMAC2_SGMII \
+	(MTK_PATH_BIT(MTK_ETH_PATH_GMAC2_SGMII) | MTK_SGMII)
+
+#define MTK_GMAC2_GEPHY \
+	(MTK_PATH_BIT(MTK_ETH_PATH_GMAC2_GEPHY) | MTK_GEPHY)
+
+#define MTK_GDM1_ESW \
+	(MTK_PATH_BIT(MTK_ETH_PATH_GDM1_ESW) | MTK_ESW)
+
+#define MTK_MUX_BIT(x)          BIT((x) + 20)
+
+/* MUXes present on SoCs */
+/* 0: GDM1 -> GMAC1, 1: GDM1 -> ESW */
+#define MTK_MUX_GDM1_TO_GMAC1_ESW       \
+	(MTK_MUX_BIT(MTK_ETH_MUX_GDM1_TO_GMAC1_ESW) | MTK_MUX)
+
+/* 0: GMAC2 -> GEPHY, 1: GMAC0 -> GePHY */
+#define MTK_MUX_GMAC2_GMAC0_TO_GEPHY    \
+	(MTK_MUX_BIT(MTK_ETH_MUX_GMAC2_GMAC0_TO_GEPHY) | MTK_MUX | MTK_INFRA)
+
+/* 0: U3 -> QPHY, 1: GMAC2 -> QPHY */
+#define MTK_MUX_U3_GMAC2_TO_QPHY        \
+	(MTK_MUX_BIT(MTK_ETH_MUX_U3_GMAC2_TO_QPHY) | MTK_MUX | MTK_INFRA)
+
+/* 2: GMAC1 -> SGMII, 3: GMAC2 -> SGMII */
+#define MTK_MUX_GMAC1_GMAC2_TO_SGMII_RGMII      \
+	(MTK_MUX_BIT(MTK_ETH_MUX_GMAC1_GMAC2_TO_SGMII_RGMII) | MTK_MUX | \
+	MTK_SHARED_SGMII)
+
+/* 0: GMACx -> GEPHY, 1: GMACx -> SGMII where x is 1 or 2 */
+#define MTK_MUX_GMAC12_TO_GEPHY_SGMII   \
+	(MTK_MUX_BIT(MTK_ETH_MUX_GMAC12_TO_GEPHY_SGMII) | MTK_MUX)
+
 #define MTK_HAS_CAPS(caps, _x)		(((caps) & (_x)) == (_x))
 
+#define MT7622_CAPS  (MTK_GMAC1_RGMII | MTK_GMAC1_SGMII | MTK_GMAC2_RGMII | \
+		      MTK_GMAC2_SGMII | MTK_GDM1_ESW | \
+		      MTK_MUX_GDM1_TO_GMAC1_ESW | \
+		      MTK_MUX_GMAC1_GMAC2_TO_SGMII_RGMII)
+
+#define MT7623_CAPS  (MTK_GMAC1_RGMII | MTK_GMAC1_TRGMII | MTK_GMAC2_RGMII)
+
+#define MT7629_CAPS  (MTK_GMAC1_SGMII | MTK_GMAC2_SGMII | MTK_GMAC2_GEPHY | \
+		      MTK_GDM1_ESW | MTK_MUX_GDM1_TO_GMAC1_ESW | \
+		      MTK_MUX_GMAC2_GMAC0_TO_GEPHY | \
+		      MTK_MUX_U3_GMAC2_TO_QPHY | \
+		      MTK_MUX_GMAC12_TO_GEPHY_SGMII)
+
 /* struct mtk_eth_data -	This is the structure holding all differences
  *				among various plaforms
  * @ana_rgc3:                   The offset for register ANA_RGC3 related to
@@ -633,6 +722,8 @@ struct mtk_sgmii {
  * @msg_enable:		Ethtool msg level
  * @ethsys:		The register map pointing at the range used to setup
  *			MII modes
+ * @infra:              The register map pointing at the range used to setup
+ *                      SGMII and GePHY path
  * @pctl:		The register map pointing at the range used to setup
  *			GMAC port drive/slew values
  * @dma_refcnt:		track how many netdevs are using the DMA engine
@@ -664,6 +755,7 @@ struct mtk_eth {
 	u32				msg_enable;
 	unsigned long			sysclk;
 	struct regmap			*ethsys;
+	struct regmap                   *infra;
 	struct mtk_sgmii                *sgmii;
 	struct regmap			*pctl;
 	bool				hwlro;
@@ -719,5 +811,6 @@ int mtk_sgmii_init(struct mtk_sgmii *ss, struct device_node *np,
 		   u32 ana_rgc3);
 int mtk_sgmii_setup_mode_an(struct mtk_sgmii *ss, int id);
 int mtk_sgmii_setup_mode_force(struct mtk_sgmii *ss, int id);
+int mtk_setup_hw_path(struct mtk_eth *eth, int mac_id, int phymode);
 
 #endif /* MTK_ETH_H */
-- 
2.17.1

