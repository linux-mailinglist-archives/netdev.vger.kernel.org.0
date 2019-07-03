Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E42C35EBD6
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 20:44:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727032AbfGCSov (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 14:44:51 -0400
Received: from mx.0dd.nl ([5.2.79.48]:33268 "EHLO mx.0dd.nl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726430AbfGCSov (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Jul 2019 14:44:51 -0400
Received: from mail.vdorst.com (mail.vdorst.com [IPv6:fd01::250])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.0dd.nl (Postfix) with ESMTPS id 80B105FFEB;
        Wed,  3 Jul 2019 20:44:46 +0200 (CEST)
Authentication-Results: mx.0dd.nl;
        dkim=pass (2048-bit key; secure) header.d=vdorst.com header.i=@vdorst.com header.b="RVNsqyJj";
        dkim-atps=neutral
Received: from pc-rene.vdorst.com (pc-rene.vdorst.com [192.168.2.125])
        by mail.vdorst.com (Postfix) with ESMTPA id 366EA1CF14F6;
        Wed,  3 Jul 2019 20:44:46 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.vdorst.com 366EA1CF14F6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vdorst.com;
        s=default; t=1562179486;
        bh=hxJWsmSkxYpQJrqKnqk3u8T+dtiNZjot3SQsJMrlmjQ=;
        h=From:To:Cc:Subject:Date:From;
        b=RVNsqyJjB6oHbWrBm+q0X0ViI2UNm6oo/cQHAYS13Fgg6nc4srYMBlwfnm4alNKWb
         une7RVaOZaXuJmmtbaiR2NEzFMYWQBHRhQQpGaFYbfSVQ+Vl2nnzztJvCi3B2uWDWU
         Z8qbtUJ228xF/pKDVU29M7QShTedfFwJKtFjvUI3Cxq7ANVsxjQeIjFdbaAppr3KSI
         hcMh2xtn+GcN05wWDBoyNKRP0X+slW1T0H4xR146K62weYoca6nmQNVj4BlO6wlEV0
         Wgm9yTJFHXdDN8387HnauO9+1HenNQghlrUlyvLsU8LcYyZzheDaDiyGCBxAnaW/J6
         90th4YMf2YZwg==
From:   =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>
To:     sean.wang@mediatek.com, f.fainelli@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, matthias.bgg@gmail.com,
        andrew@lunn.ch, vivien.didelot@gmail.com
Cc:     frank-w@public-files.de, netdev@vger.kernel.org,
        linux-mediatek@lists.infradead.org, linux-mips@vger.kernel.org,
        =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>
Subject: [PATCH net-next v2] net: ethernet: mediatek: Fix overlapping capability bits.
Date:   Wed,  3 Jul 2019 20:42:04 +0200
Message-Id: <20190703184203.20137-1-opensource@vdorst.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Both MTK_TRGMII_MT7621_CLK and MTK_PATH_BIT are defined as bit 10.

This can causes issues on non-MT7621 devices which has the
MTK_PATH_BIT(MTK_ETH_PATH_GMAC1_RGMII) and MTK_TRGMII capability set.
The wrong TRGMII setup code can be executed. The current wrongly executed
code doesn’t do any harm on MT7623 and the TRGMII setup for the MT7623
SOC side is done in MT7530 driver So it wasn’t noticed in the test.

Move all capability bits in one enum so that they are all unique and easy
to expand in the future.

Because mtk_eth_path enum is merged in to mkt_eth_capabilities, the
variable path value is no longer between 0 to number of paths,
mtk_eth_path_name can’t be used anymore in this form. Convert the
mtk_eth_path_name array to a function to lookup the pathname.

The old code walked thru the mtk_eth_path enum, which is also merged
with mkt_eth_capabilities. Expand array mtk_eth_muxc so it can store the
name and capability bit of the mux. Convert the code so it can walk thru
the mtk_eth_muxc array.

Fixes: 8efaa653a8a5 ("net: ethernet: mediatek: Add MT7621 TRGMII mode
support")
Signed-off-by: René van Dorst <opensource@vdorst.com>

v1->v2:
- Move all capability bits in one enum, suggested by Willem de Bruijn
- Convert the mtk_eth_path_name array to a function to lookup the pathname
- Expand array mtk_eth_muxc so it can also store the name and capability
  bit of the mux
- Updated commit message
---
 drivers/net/ethernet/mediatek/mtk_eth_path.c |  81 ++++++++----
 drivers/net/ethernet/mediatek/mtk_eth_soc.h  | 129 ++++++++++---------
 2 files changed, 125 insertions(+), 85 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_path.c b/drivers/net/ethernet/mediatek/mtk_eth_path.c
index 61f705d945e5..7f05880cf9ef 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_path.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_path.c
@@ -13,19 +13,32 @@
 #include "mtk_eth_soc.h"
 
 struct mtk_eth_muxc {
-	int (*set_path)(struct mtk_eth *eth, int path);
+	const char	*name;
+	int		cap_bit;
+	int		(*set_path)(struct mtk_eth *eth, int path);
 };
 
-static const char * const mtk_eth_mux_name[] = {
-	"mux_gdm1_to_gmac1_esw", "mux_gmac2_gmac0_to_gephy",
-	"mux_u3_gmac2_to_qphy", "mux_gmac1_gmac2_to_sgmii_rgmii",
-	"mux_gmac12_to_gephy_sgmii",
-};
-
-static const char * const mtk_eth_path_name[] = {
-	"gmac1_rgmii", "gmac1_trgmii", "gmac1_sgmii", "gmac2_rgmii",
-	"gmac2_sgmii", "gmac2_gephy", "gdm1_esw",
-};
+static const char *mtk_eth_path_name(int path)
+{
+	switch (path) {
+	case MTK_ETH_PATH_GMAC1_RGMII:
+		return "gmac1_rgmii";
+	case MTK_ETH_PATH_GMAC1_TRGMII:
+		return "gmac1_trgmii";
+	case MTK_ETH_PATH_GMAC1_SGMII:
+		return "gmac1_sgmii";
+	case MTK_ETH_PATH_GMAC2_RGMII:
+		return "gmac2_rgmii";
+	case MTK_ETH_PATH_GMAC2_SGMII:
+		return "gmac2_sgmii";
+	case MTK_ETH_PATH_GMAC2_GEPHY:
+		return "gmac2_gephy";
+	case MTK_ETH_PATH_GDM1_ESW:
+		return "gdm1_esw";
+	default:
+		return "unknown path";
+	}
+}
 
 static int set_mux_gdm1_to_gmac1_esw(struct mtk_eth *eth, int path)
 {
@@ -53,7 +66,7 @@ static int set_mux_gdm1_to_gmac1_esw(struct mtk_eth *eth, int path)
 	}
 
 	dev_dbg(eth->dev, "path %s in %s updated = %d\n",
-		mtk_eth_path_name[path], __func__, updated);
+		mtk_eth_path_name(path), __func__, updated);
 
 	return 0;
 }
@@ -76,7 +89,7 @@ static int set_mux_gmac2_gmac0_to_gephy(struct mtk_eth *eth, int path)
 		regmap_update_bits(eth->infra, INFRA_MISC2, GEPHY_MAC_SEL, val);
 
 	dev_dbg(eth->dev, "path %s in %s updated = %d\n",
-		mtk_eth_path_name[path], __func__, updated);
+		mtk_eth_path_name(path), __func__, updated);
 
 	return 0;
 }
@@ -99,7 +112,7 @@ static int set_mux_u3_gmac2_to_qphy(struct mtk_eth *eth, int path)
 		regmap_update_bits(eth->infra, INFRA_MISC2, CO_QPHY_SEL, val);
 
 	dev_dbg(eth->dev, "path %s in %s updated = %d\n",
-		mtk_eth_path_name[path], __func__, updated);
+		mtk_eth_path_name(path), __func__, updated);
 
 	return 0;
 }
@@ -137,7 +150,7 @@ static int set_mux_gmac1_gmac2_to_sgmii_rgmii(struct mtk_eth *eth, int path)
 				   SYSCFG0_SGMII_MASK, val);
 
 	dev_dbg(eth->dev, "path %s in %s updated = %d\n",
-		mtk_eth_path_name[path], __func__, updated);
+		mtk_eth_path_name(path), __func__, updated);
 
 	return 0;
 }
@@ -168,26 +181,42 @@ static int set_mux_gmac12_to_gephy_sgmii(struct mtk_eth *eth, int path)
 				   SYSCFG0_SGMII_MASK, val);
 
 	dev_dbg(eth->dev, "path %s in %s updated = %d\n",
-		mtk_eth_path_name[path], __func__, updated);
+		mtk_eth_path_name(path), __func__, updated);
 
 	return 0;
 }
 
 static const struct mtk_eth_muxc mtk_eth_muxc[] = {
-	{ .set_path = set_mux_gdm1_to_gmac1_esw, },
-	{ .set_path = set_mux_gmac2_gmac0_to_gephy, },
-	{ .set_path = set_mux_u3_gmac2_to_qphy, },
-	{ .set_path = set_mux_gmac1_gmac2_to_sgmii_rgmii, },
-	{ .set_path = set_mux_gmac12_to_gephy_sgmii, }
+	{
+		.name = "mux_gdm1_to_gmac1_esw",
+		.cap_bit = MTK_ETH_MUX_GDM1_TO_GMAC1_ESW,
+		.set_path = set_mux_gdm1_to_gmac1_esw,
+	}, {
+		.name = "mux_gmac2_gmac0_to_gephy",
+		.cap_bit = MTK_ETH_MUX_GMAC2_GMAC0_TO_GEPHY,
+		.set_path = set_mux_gmac2_gmac0_to_gephy,
+	}, {
+		.name = "mux_u3_gmac2_to_qphy",
+		.cap_bit = MTK_ETH_MUX_U3_GMAC2_TO_QPHY,
+		.set_path = set_mux_u3_gmac2_to_qphy,
+	}, {
+		.name = "mux_gmac1_gmac2_to_sgmii_rgmii",
+		.cap_bit = MTK_ETH_MUX_GMAC1_GMAC2_TO_SGMII_RGMII,
+		.set_path = set_mux_gmac1_gmac2_to_sgmii_rgmii,
+	}, {
+		.name = "mux_gmac12_to_gephy_sgmii",
+		.cap_bit = MTK_ETH_MUX_GMAC12_TO_GEPHY_SGMII,
+		.set_path = set_mux_gmac12_to_gephy_sgmii,
+	},
 };
 
 static int mtk_eth_mux_setup(struct mtk_eth *eth, int path)
 {
 	int i, err = 0;
 
-	if (!MTK_HAS_CAPS(eth->soc->caps, MTK_PATH_BIT(path))) {
+	if (!MTK_HAS_CAPS(eth->soc->caps, path)) {
 		dev_err(eth->dev, "path %s isn't support on the SoC\n",
-			mtk_eth_path_name[path]);
+			mtk_eth_path_name(path));
 		return -EINVAL;
 	}
 
@@ -195,14 +224,14 @@ static int mtk_eth_mux_setup(struct mtk_eth *eth, int path)
 		return 0;
 
 	/* Setup MUX in path fabric */
-	for (i = 0; i < MTK_ETH_MUX_MAX; i++) {
-		if (MTK_HAS_CAPS(eth->soc->caps, MTK_MUX_BIT(i))) {
+	for (i = 0; i < ARRAY_SIZE(mtk_eth_muxc); i++) {
+		if (MTK_HAS_CAPS(eth->soc->caps, mtk_eth_muxc[i].cap_bit)) {
 			err = mtk_eth_muxc[i].set_path(eth, path);
 			if (err)
 				goto out;
 		} else {
 			dev_dbg(eth->dev, "mux %s isn't present on the SoC\n",
-				mtk_eth_mux_name[i]);
+				mtk_eth_muxc[i].name);
 		}
 	}
 
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
index 876ce6798709..c6be599ed94d 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
@@ -592,86 +592,97 @@ struct mtk_rx_ring {
 	u32 crx_idx_reg;
 };
 
-enum mtk_eth_mux {
-	MTK_ETH_MUX_GDM1_TO_GMAC1_ESW,
-	MTK_ETH_MUX_GMAC2_GMAC0_TO_GEPHY,
-	MTK_ETH_MUX_U3_GMAC2_TO_QPHY,
-	MTK_ETH_MUX_GMAC1_GMAC2_TO_SGMII_RGMII,
-	MTK_ETH_MUX_GMAC12_TO_GEPHY_SGMII,
-	MTK_ETH_MUX_MAX,
-};
-
-enum mtk_eth_path {
-	MTK_ETH_PATH_GMAC1_RGMII,
-	MTK_ETH_PATH_GMAC1_TRGMII,
-	MTK_ETH_PATH_GMAC1_SGMII,
-	MTK_ETH_PATH_GMAC2_RGMII,
-	MTK_ETH_PATH_GMAC2_SGMII,
-	MTK_ETH_PATH_GMAC2_GEPHY,
-	MTK_ETH_PATH_GDM1_ESW,
-	MTK_ETH_PATH_MAX,
+enum mkt_eth_capabilities {
+	MTK_RGMII_BIT = 0,
+	MTK_TRGMII_BIT,
+	MTK_SGMII_BIT,
+	MTK_ESW_BIT,
+	MTK_GEPHY_BIT,
+	MTK_MUX_BIT,
+	MTK_INFRA_BIT,
+	MTK_SHARED_SGMII_BIT,
+	MTK_HWLRO_BIT,
+	MTK_SHARED_INT_BIT,
+	MTK_TRGMII_MT7621_CLK_BIT,
+
+	/* MUX BITS*/
+	MTK_ETH_MUX_GDM1_TO_GMAC1_ESW_BIT,
+	MTK_ETH_MUX_GMAC2_GMAC0_TO_GEPHY_BIT,
+	MTK_ETH_MUX_U3_GMAC2_TO_QPHY_BIT,
+	MTK_ETH_MUX_GMAC1_GMAC2_TO_SGMII_RGMII_BIT,
+	MTK_ETH_MUX_GMAC12_TO_GEPHY_SGMII_BIT,
+
+	/* PATH BITS */
+	MTK_ETH_PATH_GMAC1_RGMII_BIT,
+	MTK_ETH_PATH_GMAC1_TRGMII_BIT,
+	MTK_ETH_PATH_GMAC1_SGMII_BIT,
+	MTK_ETH_PATH_GMAC2_RGMII_BIT,
+	MTK_ETH_PATH_GMAC2_SGMII_BIT,
+	MTK_ETH_PATH_GMAC2_GEPHY_BIT,
+	MTK_ETH_PATH_GDM1_ESW_BIT,
 };
 
 /* Supported hardware group on SoCs */
-#define MTK_RGMII			BIT(0)
-#define MTK_TRGMII			BIT(1)
-#define MTK_SGMII			BIT(2)
-#define MTK_ESW				BIT(3)
-#define MTK_GEPHY			BIT(4)
-#define MTK_MUX				BIT(5)
-#define MTK_INFRA			BIT(6)
-#define MTK_SHARED_SGMII		BIT(7)
-#define MTK_HWLRO			BIT(8)
-#define MTK_SHARED_INT			BIT(9)
-#define MTK_TRGMII_MT7621_CLK		BIT(10)
+#define MTK_RGMII		BIT(MTK_RGMII_BIT)
+#define MTK_TRGMII		BIT(MTK_TRGMII_BIT)
+#define MTK_SGMII		BIT(MTK_SGMII_BIT)
+#define MTK_ESW			BIT(MTK_ESW_BIT)
+#define MTK_GEPHY		BIT(MTK_GEPHY_BIT)
+#define MTK_MUX			BIT(MTK_MUX_BIT)
+#define MTK_INFRA		BIT(MTK_INFRA_BIT)
+#define MTK_SHARED_SGMII	BIT(MTK_SHARED_SGMII_BIT)
+#define MTK_HWLRO		BIT(MTK_HWLRO_BIT)
+#define MTK_SHARED_INT		BIT(MTK_SHARED_INT_BIT)
+#define MTK_TRGMII_MT7621_CLK	BIT(MTK_TRGMII_MT7621_CLK_BIT)
+
+#define MTK_ETH_MUX_GDM1_TO_GMAC1_ESW		\
+	BIT(MTK_ETH_MUX_GDM1_TO_GMAC1_ESW_BIT)
+#define MTK_ETH_MUX_GMAC2_GMAC0_TO_GEPHY	\
+	BIT(MTK_ETH_MUX_GMAC2_GMAC0_TO_GEPHY_BIT)
+#define MTK_ETH_MUX_U3_GMAC2_TO_QPHY		\
+	BIT(MTK_ETH_MUX_U3_GMAC2_TO_QPHY_BIT)
+#define MTK_ETH_MUX_GMAC1_GMAC2_TO_SGMII_RGMII	\
+	BIT(MTK_ETH_MUX_GMAC1_GMAC2_TO_SGMII_RGMII_BIT)
+#define MTK_ETH_MUX_GMAC12_TO_GEPHY_SGMII	\
+	BIT(MTK_ETH_MUX_GMAC12_TO_GEPHY_SGMII_BIT)
 
 /* Supported path present on SoCs */
-#define MTK_PATH_BIT(x)         BIT((x) + 10)
-
-#define MTK_GMAC1_RGMII \
-	(MTK_PATH_BIT(MTK_ETH_PATH_GMAC1_RGMII) | MTK_RGMII)
-
-#define MTK_GMAC1_TRGMII \
-	(MTK_PATH_BIT(MTK_ETH_PATH_GMAC1_TRGMII) | MTK_TRGMII)
-
-#define MTK_GMAC1_SGMII \
-	(MTK_PATH_BIT(MTK_ETH_PATH_GMAC1_SGMII) | MTK_SGMII)
-
-#define MTK_GMAC2_RGMII \
-	(MTK_PATH_BIT(MTK_ETH_PATH_GMAC2_RGMII) | MTK_RGMII)
-
-#define MTK_GMAC2_SGMII \
-	(MTK_PATH_BIT(MTK_ETH_PATH_GMAC2_SGMII) | MTK_SGMII)
-
-#define MTK_GMAC2_GEPHY \
-	(MTK_PATH_BIT(MTK_ETH_PATH_GMAC2_GEPHY) | MTK_GEPHY)
-
-#define MTK_GDM1_ESW \
-	(MTK_PATH_BIT(MTK_ETH_PATH_GDM1_ESW) | MTK_ESW)
-
-#define MTK_MUX_BIT(x)          BIT((x) + 20)
+#define MTK_ETH_PATH_GMAC1_RGMII	BIT(MTK_ETH_PATH_GMAC1_RGMII_BIT)
+#define MTK_ETH_PATH_GMAC1_TRGMII	BIT(MTK_ETH_PATH_GMAC1_TRGMII_BIT)
+#define MTK_ETH_PATH_GMAC1_SGMII	BIT(MTK_ETH_PATH_GMAC1_SGMII_BIT)
+#define MTK_ETH_PATH_GMAC2_RGMII	BIT(MTK_ETH_PATH_GMAC2_RGMII_BIT)
+#define MTK_ETH_PATH_GMAC2_SGMII	BIT(MTK_ETH_PATH_GMAC2_SGMII_BIT)
+#define MTK_ETH_PATH_GMAC2_GEPHY	BIT(MTK_ETH_PATH_GMAC2_GEPHY_BIT)
+#define MTK_ETH_PATH_GDM1_ESW		BIT(MTK_ETH_PATH_GDM1_ESW_BIT)
+
+#define MTK_GMAC1_RGMII		(MTK_ETH_PATH_GMAC1_RGMII | MTK_RGMII)
+#define MTK_GMAC1_TRGMII	(MTK_ETH_PATH_GMAC1_TRGMII | MTK_TRGMII)
+#define MTK_GMAC1_SGMII		(MTK_ETH_PATH_GMAC1_SGMII | MTK_SGMII)
+#define MTK_GMAC2_RGMII		(MTK_ETH_PATH_GMAC2_RGMII | MTK_RGMII)
+#define MTK_GMAC2_SGMII		(MTK_ETH_PATH_GMAC2_SGMII | MTK_SGMII)
+#define MTK_GMAC2_GEPHY		(MTK_ETH_PATH_GMAC2_GEPHY | MTK_GEPHY)
+#define MTK_GDM1_ESW		(MTK_ETH_PATH_GDM1_ESW | MTK_ESW)
 
 /* MUXes present on SoCs */
 /* 0: GDM1 -> GMAC1, 1: GDM1 -> ESW */
-#define MTK_MUX_GDM1_TO_GMAC1_ESW       \
-	(MTK_MUX_BIT(MTK_ETH_MUX_GDM1_TO_GMAC1_ESW) | MTK_MUX)
+#define MTK_MUX_GDM1_TO_GMAC1_ESW (MTK_ETH_MUX_GDM1_TO_GMAC1_ESW | MTK_MUX)
 
 /* 0: GMAC2 -> GEPHY, 1: GMAC0 -> GePHY */
 #define MTK_MUX_GMAC2_GMAC0_TO_GEPHY    \
-	(MTK_MUX_BIT(MTK_ETH_MUX_GMAC2_GMAC0_TO_GEPHY) | MTK_MUX | MTK_INFRA)
+	(MTK_ETH_MUX_GMAC2_GMAC0_TO_GEPHY | MTK_MUX | MTK_INFRA)
 
 /* 0: U3 -> QPHY, 1: GMAC2 -> QPHY */
 #define MTK_MUX_U3_GMAC2_TO_QPHY        \
-	(MTK_MUX_BIT(MTK_ETH_MUX_U3_GMAC2_TO_QPHY) | MTK_MUX | MTK_INFRA)
+	(MTK_ETH_MUX_U3_GMAC2_TO_QPHY | MTK_MUX | MTK_INFRA)
 
 /* 2: GMAC1 -> SGMII, 3: GMAC2 -> SGMII */
 #define MTK_MUX_GMAC1_GMAC2_TO_SGMII_RGMII      \
-	(MTK_MUX_BIT(MTK_ETH_MUX_GMAC1_GMAC2_TO_SGMII_RGMII) | MTK_MUX | \
+	(MTK_ETH_MUX_GMAC1_GMAC2_TO_SGMII_RGMII | MTK_MUX | \
 	MTK_SHARED_SGMII)
 
 /* 0: GMACx -> GEPHY, 1: GMACx -> SGMII where x is 1 or 2 */
 #define MTK_MUX_GMAC12_TO_GEPHY_SGMII   \
-	(MTK_MUX_BIT(MTK_ETH_MUX_GMAC12_TO_GEPHY_SGMII) | MTK_MUX)
+	(MTK_ETH_MUX_GMAC12_TO_GEPHY_SGMII | MTK_MUX)
 
 #define MTK_HAS_CAPS(caps, _x)		(((caps) & (_x)) == (_x))
 
-- 
2.20.1

