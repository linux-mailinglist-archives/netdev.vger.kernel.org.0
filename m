Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D6343189F
	for <lists+netdev@lfdr.de>; Sat,  1 Jun 2019 02:09:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726961AbfFAAIa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 20:08:30 -0400
Received: from mailgw01.mediatek.com ([216.200.240.184]:37342 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726922AbfFAAI3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 20:08:29 -0400
X-UUID: cd07e1831cd84b7188ad96728bfac9b3-20190531
X-UUID: cd07e1831cd84b7188ad96728bfac9b3-20190531
Received: from mtkcas68.mediatek.inc [(172.29.94.19)] by mailgw01.mediatek.com
        (envelope-from <sean.wang@mediatek.com>)
        (musrelay.mediatek.com ESMTP with TLS)
        with ESMTP id 561759759; Fri, 31 May 2019 16:03:25 -0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 MTKMBS62N2.mediatek.inc (172.29.193.42) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Fri, 31 May 2019 17:03:24 -0700
Received: from mtkswgap22.mediatek.inc (172.21.77.33) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Sat, 1 Jun 2019 08:03:23 +0800
From:   <sean.wang@mediatek.com>
To:     <john@phrozen.org>, <davem@davemloft.net>
CC:     <nbd@openwrt.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>,
        Sean Wang <sean.wang@mediatek.com>
Subject: [PATCH net-next v1 3/6] net: ethernet: mediatek: Extend SGMII related functions
Date:   Sat, 1 Jun 2019 08:03:12 +0800
Message-ID: <1559347395-14058-4-git-send-email-sean.wang@mediatek.com>
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

Add SGMII related logic into a separate file, and also provides options for
forcing 1G, 2.5, AN mode for the target PHY, that can be determined from
SGMII node in DTS.

Signed-off-by: Sean Wang <sean.wang@mediatek.com>
---
 drivers/net/ethernet/mediatek/Makefile      |   2 +-
 drivers/net/ethernet/mediatek/mtk_eth_soc.c |  75 ++++++++------
 drivers/net/ethernet/mediatek/mtk_eth_soc.h |  39 +++++++-
 drivers/net/ethernet/mediatek/mtk_sgmii.c   | 105 ++++++++++++++++++++
 4 files changed, 184 insertions(+), 37 deletions(-)
 create mode 100644 drivers/net/ethernet/mediatek/mtk_sgmii.c

diff --git a/drivers/net/ethernet/mediatek/Makefile b/drivers/net/ethernet/mediatek/Makefile
index d41a2414c575..b8206605154e 100644
--- a/drivers/net/ethernet/mediatek/Makefile
+++ b/drivers/net/ethernet/mediatek/Makefile
@@ -3,4 +3,4 @@
 # Makefile for the Mediatek SoCs built-in ethernet macs
 #
 
-obj-$(CONFIG_NET_MEDIATEK_SOC)			+= mtk_eth_soc.o
+obj-$(CONFIG_NET_MEDIATEK_SOC)			+= mtk_eth_soc.o mtk_sgmii.o
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 765cd56ebcd2..d0cff646d3de 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -165,36 +165,37 @@ static void mtk_gmac0_rgmii_adjust(struct mtk_eth *eth, int speed)
 	mtk_w32(eth, val, TRGMII_TCK_CTRL);
 }
 
-static void mtk_gmac_sgmii_hw_setup(struct mtk_eth *eth, int mac_id)
+static int mtk_gmac_sgmii_hw_setup(struct mtk_eth *eth, int mac_id)
 {
+	int sid, err;
 	u32 val;
 
-	/* Setup the link timer and QPHY power up inside SGMIISYS */
-	regmap_write(eth->sgmiisys, SGMSYS_PCS_LINK_TIMER,
-		     SGMII_LINK_TIMER_DEFAULT);
+	/* Enable GMAC with SGMII once we finish the SGMII setup. */
+	regmap_read(eth->ethsys, ETHSYS_SYSCFG0, &val);
+	val &= ~SYSCFG0_SGMII_MASK;
+	regmap_write(eth->ethsys, ETHSYS_SYSCFG0, val);
 
-	regmap_read(eth->sgmiisys, SGMSYS_SGMII_MODE, &val);
-	val |= SGMII_REMOTE_FAULT_DIS;
-	regmap_write(eth->sgmiisys, SGMSYS_SGMII_MODE, val);
+	if (MTK_HAS_CAPS(eth->soc->caps, MTK_GMAC_SHARED_SGMII))
+		sid = 0;
+	else
+		sid = mac_id;
 
-	regmap_read(eth->sgmiisys, SGMSYS_PCS_CONTROL_1, &val);
-	val |= SGMII_AN_RESTART;
-	regmap_write(eth->sgmiisys, SGMSYS_PCS_CONTROL_1, val);
+	if (MTK_HAS_FLAGS(eth->sgmii->flags[sid], MTK_SGMII_PHYSPEED_AN))
+		err = mtk_sgmii_setup_mode_an(eth->sgmii, sid);
+	else
+		err = mtk_sgmii_setup_mode_force(eth->sgmii, sid);
 
-	regmap_read(eth->sgmiisys, SGMSYS_QPHY_PWR_STATE_CTRL, &val);
-	val &= ~SGMII_PHYA_PWD;
-	regmap_write(eth->sgmiisys, SGMSYS_QPHY_PWR_STATE_CTRL, val);
+	if (err)
+		return err;
 
 	/* Determine MUX for which GMAC uses the SGMII interface */
-	if (MTK_HAS_CAPS(eth->soc->caps, MTK_DUAL_GMAC_SHARED_SGMII)) {
-		regmap_read(eth->ethsys, ETHSYS_SYSCFG0, &val);
-		val &= ~SYSCFG0_SGMII_MASK;
-		val |= !mac_id ? SYSCFG0_SGMII_GMAC1 : SYSCFG0_SGMII_GMAC2;
-		regmap_write(eth->ethsys, ETHSYS_SYSCFG0, val);
-
-		dev_info(eth->dev, "setup shared sgmii for gmac=%d\n",
-			 mac_id);
-	}
+	regmap_read(eth->ethsys, ETHSYS_SYSCFG0, &val);
+	if (!mac_id)
+		val |= SYSCFG0_SGMII_GMAC1;
+	else
+		val |= MTK_HAS_CAPS(eth->soc->caps, MTK_GMAC_SHARED_SGMII) ?
+		SYSCFG0_SGMII_GMAC2 : SYSCFG0_SGMII_GMAC2_V2;
+	regmap_write(eth->ethsys, ETHSYS_SYSCFG0, val);
 
 	/* Setup the GMAC1 going through SGMII path when SoC also support
 	 * ESW on GMAC1
@@ -204,6 +205,8 @@ static void mtk_gmac_sgmii_hw_setup(struct mtk_eth *eth, int mac_id)
 		mtk_w32(eth, 0, MTK_MAC_MISC);
 		dev_info(eth->dev, "setup gmac1 going through sgmii");
 	}
+
+	return 0;
 }
 
 static void mtk_phy_link_adjust(struct net_device *dev)
@@ -295,6 +298,7 @@ static int mtk_phy_connect(struct net_device *dev)
 	struct mtk_eth *eth;
 	struct device_node *np;
 	u32 val;
+	int err;
 
 	eth = mac->hw;
 	np = of_parse_phandle(mac->of_node, "phy-handle", 0);
@@ -314,8 +318,11 @@ static int mtk_phy_connect(struct net_device *dev)
 	case PHY_INTERFACE_MODE_RGMII:
 		break;
 	case PHY_INTERFACE_MODE_SGMII:
-		if (MTK_HAS_CAPS(eth->soc->caps, MTK_SGMII))
-			mtk_gmac_sgmii_hw_setup(eth, mac->id);
+		if (MTK_HAS_CAPS(eth->soc->caps, MTK_SGMII)) {
+			err = mtk_gmac_sgmii_hw_setup(eth, mac->id);
+			if (err)
+				goto err_phy;
+		}
 		break;
 	case PHY_INTERFACE_MODE_MII:
 		mac->ge_mode = 1;
@@ -2484,13 +2491,16 @@ static int mtk_probe(struct platform_device *pdev)
 	}
 
 	if (MTK_HAS_CAPS(eth->soc->caps, MTK_SGMII)) {
-		eth->sgmiisys =
-		syscon_regmap_lookup_by_phandle(pdev->dev.of_node,
-						"mediatek,sgmiisys");
-		if (IS_ERR(eth->sgmiisys)) {
-			dev_err(&pdev->dev, "no sgmiisys regmap found\n");
-			return PTR_ERR(eth->sgmiisys);
-		}
+		eth->sgmii = devm_kzalloc(eth->dev, sizeof(*eth->sgmii),
+					  GFP_KERNEL);
+		if (!eth->sgmii)
+			return -ENOMEM;
+
+		err = mtk_sgmii_init(eth->sgmii, pdev->dev.of_node,
+				     eth->soc->ana_rgc3);
+
+		if (err)
+			return err;
 	}
 
 	if (eth->soc->required_pctl) {
@@ -2643,7 +2653,8 @@ static const struct mtk_soc_data mt7621_data = {
 };
 
 static const struct mtk_soc_data mt7622_data = {
-	.caps = MTK_DUAL_GMAC_SHARED_SGMII | MTK_GMAC1_ESW | MTK_HWLRO,
+	.ana_rgc3 = 0x2028,
+	.caps = MTK_GMAC_SHARED_SGMII | MTK_GMAC1_ESW | MTK_HWLRO,
 	.required_clks = MT7622_CLKS_BITMAP,
 	.required_pctl = false,
 };
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
index f7501997cea0..2e65115cf932 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
@@ -15,6 +15,10 @@
 #ifndef MTK_ETH_H
 #define MTK_ETH_H
 
+#include <linux/dma-mapping.h>
+#include <linux/netdevice.h>
+#include <linux/of_net.h>
+#include <linux/u64_stats_sync.h>
 #include <linux/refcount.h>
 
 #define MTK_QDMA_PAGE_SIZE	2048
@@ -372,6 +376,7 @@
 #define SYSCFG0_SGMII_MASK	(3 << 8)
 #define SYSCFG0_SGMII_GMAC1	((2 << 8) & GENMASK(9, 8))
 #define SYSCFG0_SGMII_GMAC2	((3 << 8) & GENMASK(9, 8))
+#define SYSCFG0_SGMII_GMAC2_V2  ((1 << 8) & GENMASK(9, 8))
 
 /* ethernet subsystem clock register */
 #define ETHSYS_CLKCFG0		0x2c
@@ -567,7 +572,7 @@ struct mtk_rx_ring {
 #define MTK_SGMII			BIT(8)
 #define MTK_GMAC1_SGMII			(BIT(9) | MTK_SGMII)
 #define MTK_GMAC2_SGMII			(BIT(10) | MTK_SGMII)
-#define MTK_DUAL_GMAC_SHARED_SGMII	(BIT(11) | MTK_GMAC1_SGMII | \
+#define MTK_GMAC_SHARED_SGMII		(BIT(11) | MTK_GMAC1_SGMII | \
 					 MTK_GMAC2_SGMII)
 #define MTK_HWLRO			BIT(12)
 #define MTK_SHARED_INT			BIT(13)
@@ -575,6 +580,8 @@ struct mtk_rx_ring {
 
 /* struct mtk_eth_data -	This is the structure holding all differences
  *				among various plaforms
+ * @ana_rgc3:                   The offset for register ANA_RGC3 related to
+ *				sgmiisys syscon
  * @caps			Flags shown the extra capability for the SoC
  * @required_clks		Flags shown the bitmap for required clocks on
  *				the target SoC
@@ -582,6 +589,7 @@ struct mtk_rx_ring {
  *				the extra setup for those pins used by GMAC.
  */
 struct mtk_soc_data {
+	u32             ana_rgc3;
 	u32		caps;
 	u32		required_clks;
 	bool		required_pctl;
@@ -590,6 +598,26 @@ struct mtk_soc_data {
 /* currently no SoC has more than 2 macs */
 #define MTK_MAX_DEVS			2
 
+#define MTK_SGMII_PHYSPEED_AN          BIT(31)
+#define MTK_SGMII_PHYSPEED_MASK        GENMASK(0, 2)
+#define MTK_SGMII_PHYSPEED_1000        BIT(0)
+#define MTK_SGMII_PHYSPEED_2500        BIT(1)
+#define MTK_HAS_FLAGS(flags, _x)       (((flags) & (_x)) == (_x))
+
+/* struct mtk_sgmii -  This is the structure holding sgmii regmap and its
+ *                     characteristics
+ * @regmap:            The register map pointing at the range used to setup
+ *                     SGMII modes
+ * @flags:             The enum refers to which mode the sgmii wants to run on
+ * @ana_rgc3:          The offset refers to register ANA_RGC3 related to regmap
+ */
+
+struct mtk_sgmii {
+	struct regmap   *regmap[MTK_MAX_DEVS];
+	u32             flags[MTK_MAX_DEVS];
+	u32             ana_rgc3;
+};
+
 /* struct mtk_eth -	This is the main datasructure for holding the state
  *			of the driver
  * @dev:		The device pointer
@@ -605,8 +633,6 @@ struct mtk_soc_data {
  * @msg_enable:		Ethtool msg level
  * @ethsys:		The register map pointing at the range used to setup
  *			MII modes
- * @sgmiisys:		The register map pointing at the range used to setup
- *			SGMII modes
  * @pctl:		The register map pointing at the range used to setup
  *			GMAC port drive/slew values
  * @dma_refcnt:		track how many netdevs are using the DMA engine
@@ -638,7 +664,7 @@ struct mtk_eth {
 	u32				msg_enable;
 	unsigned long			sysclk;
 	struct regmap			*ethsys;
-	struct regmap			*sgmiisys;
+	struct mtk_sgmii                *sgmii;
 	struct regmap			*pctl;
 	bool				hwlro;
 	refcount_t			dma_refcnt;
@@ -689,4 +715,9 @@ void mtk_stats_update_mac(struct mtk_mac *mac);
 void mtk_w32(struct mtk_eth *eth, u32 val, unsigned reg);
 u32 mtk_r32(struct mtk_eth *eth, unsigned reg);
 
+int mtk_sgmii_init(struct mtk_sgmii *ss, struct device_node *np,
+		   u32 ana_rgc3);
+int mtk_sgmii_setup_mode_an(struct mtk_sgmii *ss, int id);
+int mtk_sgmii_setup_mode_force(struct mtk_sgmii *ss, int id);
+
 #endif /* MTK_ETH_H */
diff --git a/drivers/net/ethernet/mediatek/mtk_sgmii.c b/drivers/net/ethernet/mediatek/mtk_sgmii.c
new file mode 100644
index 000000000000..136f90ce5a65
--- /dev/null
+++ b/drivers/net/ethernet/mediatek/mtk_sgmii.c
@@ -0,0 +1,105 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (c) 2018-2019 MediaTek Inc.
+
+/* A library for MediaTek SGMII circuit
+ *
+ * Author: Sean Wang <sean.wang@mediatek.com>
+ *
+ */
+
+#include <linux/mfd/syscon.h>
+#include <linux/of.h>
+#include <linux/regmap.h>
+
+#include "mtk_eth_soc.h"
+
+int mtk_sgmii_init(struct mtk_sgmii *ss, struct device_node *r, u32 ana_rgc3)
+{
+	struct device_node *np;
+	const char *str;
+	int i, err;
+
+	ss->ana_rgc3 = ana_rgc3;
+
+	for (i = 0; i < MTK_MAX_DEVS; i++) {
+		np = of_parse_phandle(r, "mediatek,sgmiisys", i);
+		if (!np)
+			break;
+
+		ss->regmap[i] = syscon_node_to_regmap(np);
+		if (IS_ERR(ss->regmap[i]))
+			return PTR_ERR(ss->regmap[i]);
+
+		err = of_property_read_string(np, "mediatek,physpeed", &str);
+		if (err)
+			return err;
+
+		if (!strcmp(str, "2500"))
+			ss->flags[i] |= MTK_SGMII_PHYSPEED_2500;
+		else if (!strcmp(str, "1000"))
+			ss->flags[i] |= MTK_SGMII_PHYSPEED_1000;
+		else if (!strcmp(str, "auto"))
+			ss->flags[i] |= MTK_SGMII_PHYSPEED_AN;
+		else
+			return -EINVAL;
+	}
+
+	return 0;
+}
+
+int mtk_sgmii_setup_mode_an(struct mtk_sgmii *ss, int id)
+{
+	unsigned int val;
+
+	if (!ss->regmap[id])
+		return -EINVAL;
+
+	/* Setup the link timer and QPHY power up inside SGMIISYS */
+	regmap_write(ss->regmap[id], SGMSYS_PCS_LINK_TIMER,
+		     SGMII_LINK_TIMER_DEFAULT);
+
+	regmap_read(ss->regmap[id], SGMSYS_SGMII_MODE, &val);
+	val |= SGMII_REMOTE_FAULT_DIS;
+	regmap_write(ss->regmap[id], SGMSYS_SGMII_MODE, val);
+
+	regmap_read(ss->regmap[id], SGMSYS_PCS_CONTROL_1, &val);
+	val |= SGMII_AN_RESTART;
+	regmap_write(ss->regmap[id], SGMSYS_PCS_CONTROL_1, val);
+
+	regmap_read(ss->regmap[id], SGMSYS_QPHY_PWR_STATE_CTRL, &val);
+	val &= ~SGMII_PHYA_PWD;
+	regmap_write(ss->regmap[id], SGMSYS_QPHY_PWR_STATE_CTRL, val);
+
+	return 0;
+}
+
+int mtk_sgmii_setup_mode_force(struct mtk_sgmii *ss, int id)
+{
+	unsigned int val;
+	int mode;
+
+	if (!ss->regmap[id])
+		return -EINVAL;
+
+	regmap_read(ss->regmap[id], ss->ana_rgc3, &val);
+	val &= ~GENMASK(2, 3);
+	mode = ss->flags[id] & MTK_SGMII_PHYSPEED_MASK;
+	val |= (mode == MTK_SGMII_PHYSPEED_1000) ? 0 : BIT(2);
+	regmap_write(ss->regmap[id], ss->ana_rgc3, val);
+
+	/* Disable SGMII AN */
+	regmap_read(ss->regmap[id], SGMSYS_PCS_CONTROL_1, &val);
+	val &= ~BIT(12);
+	regmap_write(ss->regmap[id], SGMSYS_PCS_CONTROL_1, val);
+
+	/* SGMII force mode setting */
+	val = 0x31120019;
+	regmap_write(ss->regmap[id], SGMSYS_SGMII_MODE, val);
+
+	/* Release PHYA power down state */
+	regmap_read(ss->regmap[id], SGMSYS_QPHY_PWR_STATE_CTRL, &val);
+	val &= ~SGMII_PHYA_PWD;
+	regmap_write(ss->regmap[id], SGMSYS_QPHY_PWR_STATE_CTRL, val);
+
+	return 0;
+}
-- 
2.17.1

