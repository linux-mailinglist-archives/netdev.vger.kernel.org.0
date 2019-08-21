Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB18997D6B
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 16:46:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729437AbfHUOoi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 10:44:38 -0400
Received: from mx.0dd.nl ([5.2.79.48]:54060 "EHLO mx.0dd.nl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728608AbfHUOoi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Aug 2019 10:44:38 -0400
Received: from mail.vdorst.com (mail.vdorst.com [IPv6:fd01::250])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.0dd.nl (Postfix) with ESMTPS id 4429C5FB50;
        Wed, 21 Aug 2019 16:44:36 +0200 (CEST)
Authentication-Results: mx.0dd.nl;
        dkim=pass (2048-bit key) header.d=vdorst.com header.i=@vdorst.com header.b="IrzxrtmR";
        dkim-atps=neutral
Received: from pc-rene.vdorst.com (pc-rene.vdorst.com [192.168.2.125])
        by mail.vdorst.com (Postfix) with ESMTPA id 0BC0D1D828DC;
        Wed, 21 Aug 2019 16:44:36 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.vdorst.com 0BC0D1D828DC
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vdorst.com;
        s=default; t=1566398676;
        bh=C4WrFrMeWH3E9lF0sucJzBgp+1mmt4kH80GdXn+hvuM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IrzxrtmRupzs5kB+kw7E+7dI7NcXUalBsgd9ab/FtN8WzjOhnDR183wGn4hC3083L
         orU1vnwmLbAUDYbltIJVIJoWNW0neD8PFFMojMXlrsS18eAVVsc9EAshpQ6TFr+G8H
         fyz8TV5AVeY/eeer1P3E4Am5CyF2ydNilrJQYbtlJV2zIXkL0ZbPy6jXd8YeB4PK4X
         JPhCK1iAQ9ONtZPq9Pqp2cvUR8VSA5YQTeaRW9VwbKjkS4EvgtkQ6qZG6VgIxOcgB7
         eN0BJlwuUjugKKisQX98XwS5GTtmCpsMagpGmUZycMAvZ+HmcZ0YPh4O8ffV+HNFKJ
         DWZQgGO0p/uMw==
From:   =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>
To:     John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Nelson Chang <nelson.chang@mediatek.com>,
        "David S . Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>
Cc:     netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-mips@vger.kernel.org,
        Frank Wunderlich <frank-w@public-files.de>,
        Stefan Roese <sr@denx.de>,
        =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>
Subject: [PATCH net-next v2 2/3] net: ethernet: mediatek: Re-add support SGMII
Date:   Wed, 21 Aug 2019 16:43:35 +0200
Message-Id: <20190821144336.9259-3-opensource@vdorst.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190821144336.9259-1-opensource@vdorst.com>
References: <20190821144336.9259-1-opensource@vdorst.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

* Re-add SGMII support but now with PHYLINK API support
  So the SGMII changes are more clear
* Move SGMII block setup from mtk_gmac_sgmii_path_setup() to
  mtk_mac_config()
* Merge mtk_setup_hw_path() into mtk_mac_config()
* Remove mediatek,physpeed property, fixed-link supports now any speed so
  speed = <2500>; is now valid with PHYLINK.
* Demagic SGMII register values
* Use phylink state to setup fixed-link mode

Signed-off-by: René van Dorst <opensource@vdorst.com>
--
v1->v2:
* SGMII port only support SGMII at 1Gbit, 1000BASE-X and 2500BASE-X.
  Also SGMII mode only does auto-negotiation.
* Change validate() to support mt76x8 changes.
---
 drivers/net/ethernet/mediatek/mtk_eth_path.c |  75 +---------
 drivers/net/ethernet/mediatek/mtk_eth_soc.c  | 139 +++++++++++++++----
 drivers/net/ethernet/mediatek/mtk_eth_soc.h  |  37 ++++-
 drivers/net/ethernet/mediatek/mtk_sgmii.c    |  65 ++++++---
 4 files changed, 195 insertions(+), 121 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_path.c b/drivers/net/ethernet/mediatek/mtk_eth_path.c
index 28960e4c4e43..ef11cf3d1ccc 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_path.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_path.c
@@ -239,10 +239,9 @@ static int mtk_eth_mux_setup(struct mtk_eth *eth, int path)
 	return err;
 }
 
-static int mtk_gmac_sgmii_path_setup(struct mtk_eth *eth, int mac_id)
+int mtk_gmac_sgmii_path_setup(struct mtk_eth *eth, int mac_id)
 {
-	unsigned int val = 0;
-	int sid, err, path;
+	int err, path;
 
 	path = (mac_id == 0) ?  MTK_ETH_PATH_GMAC1_SGMII :
 				MTK_ETH_PATH_GMAC2_SGMII;
@@ -252,33 +251,10 @@ static int mtk_gmac_sgmii_path_setup(struct mtk_eth *eth, int mac_id)
 	if (err)
 		return err;
 
-	/* The path GMAC to SGMII will be enabled once the SGMIISYS is being
-	 * setup done.
-	 */
-	regmap_read(eth->ethsys, ETHSYS_SYSCFG0, &val);
-
-	regmap_update_bits(eth->ethsys, ETHSYS_SYSCFG0,
-			   SYSCFG0_SGMII_MASK, ~(u32)SYSCFG0_SGMII_MASK);
-
-	/* Decide how GMAC and SGMIISYS be mapped */
-	sid = (MTK_HAS_CAPS(eth->soc->caps, MTK_SHARED_SGMII)) ? 0 : mac_id;
-
-	/* Setup SGMIISYS with the determined property */
-	if (MTK_HAS_FLAGS(eth->sgmii->flags[sid], MTK_SGMII_PHYSPEED_AN))
-		err = mtk_sgmii_setup_mode_an(eth->sgmii, sid);
-	else
-		err = mtk_sgmii_setup_mode_force(eth->sgmii, sid);
-
-	if (err)
-		return err;
-
-	regmap_update_bits(eth->ethsys, ETHSYS_SYSCFG0,
-			   SYSCFG0_SGMII_MASK, val);
-
 	return 0;
 }
 
-static int mtk_gmac_gephy_path_setup(struct mtk_eth *eth, int mac_id)
+int mtk_gmac_gephy_path_setup(struct mtk_eth *eth, int mac_id)
 {
 	int err, path = 0;
 
@@ -296,7 +272,7 @@ static int mtk_gmac_gephy_path_setup(struct mtk_eth *eth, int mac_id)
 	return 0;
 }
 
-static int mtk_gmac_rgmii_path_setup(struct mtk_eth *eth, int mac_id)
+int mtk_gmac_rgmii_path_setup(struct mtk_eth *eth, int mac_id)
 {
 	int err, path;
 
@@ -311,46 +287,3 @@ static int mtk_gmac_rgmii_path_setup(struct mtk_eth *eth, int mac_id)
 	return 0;
 }
 
-int mtk_setup_hw_path(struct mtk_eth *eth, int mac_id, int phymode)
-{
-	int err;
-
-	/* No mux'ing for MT7628/88 */
-	if (MTK_HAS_CAPS(eth->soc->caps, MTK_SOC_MT7628))
-		return 0;
-
-	switch (phymode) {
-	case PHY_INTERFACE_MODE_TRGMII:
-	case PHY_INTERFACE_MODE_RGMII_TXID:
-	case PHY_INTERFACE_MODE_RGMII_RXID:
-	case PHY_INTERFACE_MODE_RGMII_ID:
-	case PHY_INTERFACE_MODE_RGMII:
-	case PHY_INTERFACE_MODE_MII:
-	case PHY_INTERFACE_MODE_REVMII:
-	case PHY_INTERFACE_MODE_RMII:
-		if (MTK_HAS_CAPS(eth->soc->caps, MTK_RGMII)) {
-			err = mtk_gmac_rgmii_path_setup(eth, mac_id);
-			if (err)
-				return err;
-		}
-		break;
-	case PHY_INTERFACE_MODE_SGMII:
-		if (MTK_HAS_CAPS(eth->soc->caps, MTK_SGMII)) {
-			err = mtk_gmac_sgmii_path_setup(eth, mac_id);
-			if (err)
-				return err;
-		}
-		break;
-	case PHY_INTERFACE_MODE_GMII:
-		if (MTK_HAS_CAPS(eth->soc->caps, MTK_GEPHY)) {
-			err = mtk_gmac_gephy_path_setup(eth, mac_id);
-			if (err)
-				return err;
-		}
-		break;
-	default:
-		break;
-	}
-
-	return 0;
-}
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index e467172f2c26..f076c6b1b372 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -193,8 +193,8 @@ static void mtk_mac_config(struct phylink_config *config, unsigned int mode,
 	struct mtk_mac *mac = container_of(config, struct mtk_mac,
 					   phylink_config);
 	struct mtk_eth *eth = mac->hw;
-	u32 mcr_cur, mcr_new;
-	int val, ge_mode = 0;
+	u32 mcr_cur, mcr_new, sid;
+	int val, ge_mode, err;
 
 	/* MT76x8 has no hardware settings between for the MAC */
 	if (!MTK_HAS_CAPS(eth->soc->caps, MTK_SOC_MT7628) &&
@@ -208,29 +208,42 @@ static void mtk_mac_config(struct phylink_config *config, unsigned int mode,
 					  MTK_GMAC1_TRGMII))
 				goto err_phy;
 			/* fall through */
-		case PHY_INTERFACE_MODE_GMII:
 		case PHY_INTERFACE_MODE_RGMII_TXID:
 		case PHY_INTERFACE_MODE_RGMII_RXID:
 		case PHY_INTERFACE_MODE_RGMII_ID:
 		case PHY_INTERFACE_MODE_RGMII:
-			break;
 		case PHY_INTERFACE_MODE_MII:
-			ge_mode = 1;
-			break;
 		case PHY_INTERFACE_MODE_REVMII:
-			ge_mode = 2;
-			break;
 		case PHY_INTERFACE_MODE_RMII:
-			if (mac->id)
-				goto err_phy;
-			ge_mode = 3;
+			if (MTK_HAS_CAPS(eth->soc->caps, MTK_RGMII)) {
+				err = mtk_gmac_rgmii_path_setup(eth, mac->id);
+				if (err)
+					goto init_err;
+			}
+			break;
+		case PHY_INTERFACE_MODE_1000BASEX:
+		case PHY_INTERFACE_MODE_2500BASEX:
+		case PHY_INTERFACE_MODE_SGMII:
+			if (MTK_HAS_CAPS(eth->soc->caps, MTK_SGMII)) {
+				err = mtk_gmac_sgmii_path_setup(eth, mac->id);
+				if (err)
+					goto init_err;
+			}
+			break;
+		case PHY_INTERFACE_MODE_GMII:
+			if (MTK_HAS_CAPS(eth->soc->caps, MTK_GEPHY)) {
+				err = mtk_gmac_gephy_path_setup(eth, mac->id);
+				if (err)
+					goto init_err;
+			}
 			break;
 		default:
 			goto err_phy;
 		}
 
 		/* Setup clock for 1st gmac */
-		if (!mac->id &&
+		if (!mac->id && state->interface != PHY_INTERFACE_MODE_SGMII &&
+		    !phy_interface_mode_is_8023z(state->interface) &&
 		    MTK_HAS_CAPS(mac->hw->soc->caps, MTK_GMAC1_TRGMII)) {
 			if (MTK_HAS_CAPS(mac->hw->soc->caps,
 					 MTK_TRGMII_MT7621_CLK)) {
@@ -245,6 +258,23 @@ static void mtk_mac_config(struct phylink_config *config, unsigned int mode,
 			}
 		}
 
+		ge_mode = 0;
+		switch (state->interface) {
+		case PHY_INTERFACE_MODE_MII:
+			ge_mode = 1;
+			break;
+		case PHY_INTERFACE_MODE_REVMII:
+			ge_mode = 2;
+			break;
+		case PHY_INTERFACE_MODE_RMII:
+			if (mac->id)
+				goto err_phy;
+			ge_mode = 3;
+			break;
+		default:
+			break;
+		}
+
 		/* put the gmac into the right mode */
 		regmap_read(eth->ethsys, ETHSYS_SYSCFG0, &val);
 		val &= ~SYSCFG0_GE_MODE(SYSCFG0_GE_MASK, mac->id);
@@ -254,6 +284,40 @@ static void mtk_mac_config(struct phylink_config *config, unsigned int mode,
 		mac->interface = state->interface;
 	}
 
+	/* SGMII */
+	if (state->interface == PHY_INTERFACE_MODE_SGMII ||
+	    phy_interface_mode_is_8023z(state->interface)) {
+		/* The path GMAC to SGMII will be enabled once the SGMIISYS is
+		 * being setup done.
+		 */
+		regmap_read(eth->ethsys, ETHSYS_SYSCFG0, &val);
+
+		regmap_update_bits(eth->ethsys, ETHSYS_SYSCFG0,
+				   SYSCFG0_SGMII_MASK,
+				   ~(u32)SYSCFG0_SGMII_MASK);
+
+		/* Decide how GMAC and SGMIISYS be mapped */
+		sid = (MTK_HAS_CAPS(eth->soc->caps, MTK_SHARED_SGMII)) ?
+		       0 : mac->id;
+
+		/* Setup SGMIISYS with the determined property */
+		if (state->interface != PHY_INTERFACE_MODE_SGMII)
+			err = mtk_sgmii_setup_mode_force(eth->sgmii, sid,
+							 state);
+		else if (phylink_autoneg_inband(mode))
+			err = mtk_sgmii_setup_mode_an(eth->sgmii, sid);
+
+		if (err)
+			goto init_err;
+
+		regmap_update_bits(eth->ethsys, ETHSYS_SYSCFG0,
+				   SYSCFG0_SGMII_MASK, val);
+	} else if (phylink_autoneg_inband(mode)) {
+		dev_err(eth->dev,
+			"In-band mode not supported in non SGMII mode!\n");
+		return;
+	}
+
 	/* Setup gmac */
 	mcr_cur = mtk_r32(mac->hw, MTK_MAC_MCR(mac->id));
 	mcr_new = mcr_cur;
@@ -264,6 +328,7 @@ static void mtk_mac_config(struct phylink_config *config, unsigned int mode,
 		   MAC_MCR_BACKOFF_EN | MAC_MCR_BACKPR_EN | MAC_MCR_FORCE_LINK;
 
 	switch (state->speed) {
+	case SPEED_2500:
 	case SPEED_1000:
 		mcr_new |= MAC_MCR_SPEED_1000;
 		break;
@@ -288,6 +353,11 @@ static void mtk_mac_config(struct phylink_config *config, unsigned int mode,
 err_phy:
 	dev_err(eth->dev, "%s: GMAC%d mode %s not supported!\n", __func__,
 		mac->id, phy_modes(state->interface));
+	return;
+
+init_err:
+	dev_err(eth->dev, "%s: GMAC%d mode %s err: %d!\n", __func__,
+		mac->id, phy_modes(state->interface), err);
 }
 
 static int mtk_mac_link_state(struct phylink_config *config,
@@ -326,7 +396,10 @@ static int mtk_mac_link_state(struct phylink_config *config,
 
 static void mtk_mac_an_restart(struct phylink_config *config)
 {
-	/* Do nothing */
+	struct mtk_mac *mac = container_of(config, struct mtk_mac,
+					   phylink_config);
+
+	mtk_sgmii_restart_an(mac->hw, mac->id);
 }
 
 static void mtk_mac_link_down(struct phylink_config *config, unsigned int mode,
@@ -364,7 +437,10 @@ static void mtk_validate(struct phylink_config *config,
 	    !(MTK_HAS_CAPS(mac->hw->soc->caps, MTK_RGMII) &&
 	      phy_interface_mode_is_rgmii(state->interface)) &&
 	    !(MTK_HAS_CAPS(mac->hw->soc->caps, MTK_TRGMII) &&
-	      !mac->id && state->interface == PHY_INTERFACE_MODE_TRGMII)) {
+	      !mac->id && state->interface == PHY_INTERFACE_MODE_TRGMII) &&
+	    !(MTK_HAS_CAPS(mac->hw->soc->caps, MTK_SGMII) &&
+	      (state->interface == PHY_INTERFACE_MODE_SGMII ||
+	       phy_interface_mode_is_8023z(state->interface)))) {
 		linkmode_zero(supported);
 		return;
 	}
@@ -372,18 +448,28 @@ static void mtk_validate(struct phylink_config *config,
 	phylink_set_port_modes(mask);
 	phylink_set(mask, Autoneg);
 
-	if (state->interface == PHY_INTERFACE_MODE_TRGMII) {
-		phylink_set(mask, 1000baseT_Full);
-	} else {
-		phylink_set(mask, 10baseT_Half);
-		phylink_set(mask, 10baseT_Full);
-		phylink_set(mask, 100baseT_Half);
-		phylink_set(mask, 100baseT_Full);
-
-		if (state->interface != PHY_INTERFACE_MODE_MII) {
-			phylink_set(mask, 1000baseT_Half);
+	if (MTK_HAS_CAPS(mac->hw->soc->caps, MTK_SGMII)) {
+		if (state->interface != PHY_INTERFACE_MODE_2500BASEX) {
 			phylink_set(mask, 1000baseT_Full);
 			phylink_set(mask, 1000baseX_Full);
+		} else {
+			phylink_set(mask, 2500baseT_Full);
+			phylink_set(mask, 2500baseX_Full);
+		}
+	} else {
+		if (state->interface == PHY_INTERFACE_MODE_TRGMII) {
+			phylink_set(mask, 1000baseT_Full);
+		} else {
+			phylink_set(mask, 10baseT_Half);
+			phylink_set(mask, 10baseT_Full);
+			phylink_set(mask, 100baseT_Half);
+			phylink_set(mask, 100baseT_Full);
+
+			if (state->interface != PHY_INTERFACE_MODE_MII) {
+				phylink_set(mask, 1000baseT_Half);
+				phylink_set(mask, 1000baseT_Full);
+				phylink_set(mask, 1000baseX_Full);
+			}
 		}
 	}
 
@@ -392,6 +478,11 @@ static void mtk_validate(struct phylink_config *config,
 
 	linkmode_and(supported, supported, mask);
 	linkmode_and(state->advertising, state->advertising, mask);
+
+	/* We can only operate at 2500BaseX or 1000BaseX. If requested
+	 * to advertise both, only report advertising at 2500BaseX.
+	 */
+	phylink_helper_basex_speed(state);
 }
 
 static const struct phylink_mac_ops mtk_phylink_ops = {
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
index 7f5f541daad7..76bd12cb8150 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
@@ -412,14 +412,38 @@
 /* Register to auto-negotiation restart */
 #define SGMSYS_PCS_CONTROL_1	0x0
 #define SGMII_AN_RESTART	BIT(9)
+#define SGMII_ISOLATE		BIT(10)
+#define SGMII_AN_ENABLE		BIT(12)
+#define SGMII_LINK_STATYS	BIT(18)
+#define SGMII_AN_ABILITY	BIT(19)
+#define SGMII_AN_COMPLETE	BIT(21)
+#define SGMII_PCS_FAULT		BIT(23)
+#define SGMII_AN_EXPANSION_CLR	BIT(30)
 
 /* Register to programmable link timer, the unit in 2 * 8ns */
 #define SGMSYS_PCS_LINK_TIMER	0x18
 #define SGMII_LINK_TIMER_DEFAULT	(0x186a0 & GENMASK(19, 0))
 
 /* Register to control remote fault */
-#define SGMSYS_SGMII_MODE	0x20
-#define SGMII_REMOTE_FAULT_DIS	BIT(8)
+#define SGMSYS_SGMII_MODE		0x20
+#define SGMII_IF_MODE_BIT0		BIT(0)
+#define SGMII_SPEED_DUPLEX_AN		BIT(1)
+#define SGMII_SPEED_10			0x0
+#define SGMII_SPEED_100			BIT(2)
+#define SGMII_SPEED_1000		BIT(3)
+#define SGMII_DUPLEX_FULL		BIT(4)
+#define SGMII_IF_MODE_BIT5		BIT(5)
+#define SGMII_REMOTE_FAULT_DIS		BIT(8)
+#define SGMII_CODE_SYNC_SET_VAL		BIT(9)
+#define SGMII_CODE_SYNC_SET_EN		BIT(10)
+#define SGMII_SEND_AN_ERROR_EN		BIT(11)
+#define SGMII_IF_MODE_MASK		GENMASK(5, 1)
+
+/* Register to set SGMII speed, ANA RG_ Control Signals III*/
+#define SGMSYS_ANA_RG_CS3	0x2028
+#define RG_PHY_SPEED_MASK	(BIT(2) | BIT(3))
+#define RG_PHY_SPEED_1_25G	0x0
+#define RG_PHY_SPEED_3_125G	BIT(2)
 
 /* Register to power up QPHY */
 #define SGMSYS_QPHY_PWR_STATE_CTRL 0xe8
@@ -897,7 +921,12 @@ u32 mtk_r32(struct mtk_eth *eth, unsigned reg);
 int mtk_sgmii_init(struct mtk_sgmii *ss, struct device_node *np,
 		   u32 ana_rgc3);
 int mtk_sgmii_setup_mode_an(struct mtk_sgmii *ss, int id);
-int mtk_sgmii_setup_mode_force(struct mtk_sgmii *ss, int id);
-int mtk_setup_hw_path(struct mtk_eth *eth, int mac_id, int phymode);
+int mtk_sgmii_setup_mode_force(struct mtk_sgmii *ss, int id,
+			       const struct phylink_link_state *state);
+void mtk_sgmii_restart_an(struct mtk_eth *eth, int mac_id);
+
+int mtk_gmac_sgmii_path_setup(struct mtk_eth *eth, int mac_id);
+int mtk_gmac_gephy_path_setup(struct mtk_eth *eth, int mac_id);
+int mtk_gmac_rgmii_path_setup(struct mtk_eth *eth, int mac_id);
 
 #endif /* MTK_ETH_H */
diff --git a/drivers/net/ethernet/mediatek/mtk_sgmii.c b/drivers/net/ethernet/mediatek/mtk_sgmii.c
index ff509d42d818..4db27dfc7ec1 100644
--- a/drivers/net/ethernet/mediatek/mtk_sgmii.c
+++ b/drivers/net/ethernet/mediatek/mtk_sgmii.c
@@ -16,8 +16,7 @@
 int mtk_sgmii_init(struct mtk_sgmii *ss, struct device_node *r, u32 ana_rgc3)
 {
 	struct device_node *np;
-	const char *str;
-	int i, err;
+	int i;
 
 	ss->ana_rgc3 = ana_rgc3;
 
@@ -29,19 +28,6 @@ int mtk_sgmii_init(struct mtk_sgmii *ss, struct device_node *r, u32 ana_rgc3)
 		ss->regmap[i] = syscon_node_to_regmap(np);
 		if (IS_ERR(ss->regmap[i]))
 			return PTR_ERR(ss->regmap[i]);
-
-		err = of_property_read_string(np, "mediatek,physpeed", &str);
-		if (err)
-			return err;
-
-		if (!strcmp(str, "2500"))
-			ss->flags[i] |= MTK_SGMII_PHYSPEED_2500;
-		else if (!strcmp(str, "1000"))
-			ss->flags[i] |= MTK_SGMII_PHYSPEED_1000;
-		else if (!strcmp(str, "auto"))
-			ss->flags[i] |= MTK_SGMII_PHYSPEED_AN;
-		else
-			return -EINVAL;
 	}
 
 	return 0;
@@ -73,27 +59,45 @@ int mtk_sgmii_setup_mode_an(struct mtk_sgmii *ss, int id)
 	return 0;
 }
 
-int mtk_sgmii_setup_mode_force(struct mtk_sgmii *ss, int id)
+int mtk_sgmii_setup_mode_force(struct mtk_sgmii *ss, int id,
+			       const struct phylink_link_state *state)
 {
 	unsigned int val;
-	int mode;
 
 	if (!ss->regmap[id])
 		return -EINVAL;
 
 	regmap_read(ss->regmap[id], ss->ana_rgc3, &val);
-	val &= ~GENMASK(3, 2);
-	mode = ss->flags[id] & MTK_SGMII_PHYSPEED_MASK;
-	val |= (mode == MTK_SGMII_PHYSPEED_1000) ? 0 : BIT(2);
+	val &= ~RG_PHY_SPEED_MASK;
+	if (state->interface == PHY_INTERFACE_MODE_2500BASEX)
+		val |= RG_PHY_SPEED_3_125G;
 	regmap_write(ss->regmap[id], ss->ana_rgc3, val);
 
 	/* Disable SGMII AN */
 	regmap_read(ss->regmap[id], SGMSYS_PCS_CONTROL_1, &val);
-	val &= ~BIT(12);
+	val &= ~SGMII_AN_ENABLE;
 	regmap_write(ss->regmap[id], SGMSYS_PCS_CONTROL_1, val);
 
 	/* SGMII force mode setting */
-	val = 0x31120019;
+	regmap_read(ss->regmap[id], SGMSYS_SGMII_MODE, &val);
+	val &= ~SGMII_IF_MODE_MASK;
+
+	switch (state->speed) {
+	case SPEED_10:
+		val |= SGMII_SPEED_10;
+		break;
+	case SPEED_100:
+		val |= SGMII_SPEED_100;
+		break;
+	case SPEED_2500:
+	case SPEED_1000:
+		val |= SGMII_SPEED_1000;
+		break;
+	};
+
+	if (state->duplex == DUPLEX_FULL)
+		val |= SGMII_DUPLEX_FULL;
+
 	regmap_write(ss->regmap[id], SGMSYS_SGMII_MODE, val);
 
 	/* Release PHYA power down state */
@@ -103,3 +107,20 @@ int mtk_sgmii_setup_mode_force(struct mtk_sgmii *ss, int id)
 
 	return 0;
 }
+
+void mtk_sgmii_restart_an(struct mtk_eth *eth, int mac_id)
+{
+	struct mtk_sgmii *ss = eth->sgmii;
+	unsigned int val, sid;
+
+	/* Decide how GMAC and SGMIISYS be mapped */
+	sid = (MTK_HAS_CAPS(eth->soc->caps, MTK_SHARED_SGMII)) ?
+	       0 : mac_id;
+
+	if (!ss->regmap[sid])
+		return;
+
+	regmap_read(ss->regmap[sid], SGMSYS_PCS_CONTROL_1, &val);
+	val |= SGMII_AN_RESTART;
+	regmap_write(ss->regmap[sid], SGMSYS_PCS_CONTROL_1, val);
+}
-- 
2.20.1

