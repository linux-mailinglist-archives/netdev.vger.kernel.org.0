Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7969968902C
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 08:10:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231598AbjBCHIV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 02:08:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229837AbjBCHIV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 02:08:21 -0500
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 682134B77B;
        Thu,  2 Feb 2023 23:07:53 -0800 (PST)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.96)
        (envelope-from <daniel@makrotopia.org>)
        id 1pNqAp-0000uJ-0c;
        Fri, 03 Feb 2023 08:07:51 +0100
Date:   Fri, 3 Feb 2023 07:06:10 +0000
From:   Daniel Golle <daniel@makrotopia.org>
To:     netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        John Crispin <john@phrozen.org>, Felix Fietkau <nbd@nbd.name>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     Jianhui Zhao <zhaojh329@gmail.com>,
        =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Subject: [PATCH 8/9] net: ethernet: mtk_eth_soc: switch to external PCS driver
Message-ID: <3bac780184867e111c3a1567d8b55658abd931da.1675407169.git.daniel@makrotopia.org>
References: <cover.1675407169.git.daniel@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1675407169.git.daniel@makrotopia.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that we got a PCS driver, use it and remove the now redundant
PCS code and its header macros from the Ethernet driver.

Signed-off-by: Daniel Golle <daniel@makrotopia.org>
---
 drivers/net/ethernet/mediatek/Kconfig       |   2 +
 drivers/net/ethernet/mediatek/mtk_eth_soc.c |  13 +-
 drivers/net/ethernet/mediatek/mtk_eth_soc.h |  80 +-------
 drivers/net/ethernet/mediatek/mtk_sgmii.c   | 200 +++-----------------
 4 files changed, 37 insertions(+), 258 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/Kconfig b/drivers/net/ethernet/mediatek/Kconfig
index 97374fb3ee79..8f9d2f663885 100644
--- a/drivers/net/ethernet/mediatek/Kconfig
+++ b/drivers/net/ethernet/mediatek/Kconfig
@@ -19,6 +19,8 @@ config NET_MEDIATEK_SOC
 	select DIMLIB
 	select PAGE_POOL
 	select PAGE_POOL_STATS
+	select PCS_MTK
+	select REGMAP_MMIO
 	help
 	  This driver supports the gigabit ethernet MACs in the
 	  MediaTek SoC family.
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index d50dea1f20f3..5c833b82c93e 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -4081,6 +4081,7 @@ static int mtk_unreg_dev(struct mtk_eth *eth)
 
 static int mtk_cleanup(struct mtk_eth *eth)
 {
+	mtk_sgmii_destroy(eth->sgmii);
 	mtk_unreg_dev(eth);
 	mtk_free_dev(eth);
 	cancel_work_sync(&eth->pending_work);
@@ -4578,6 +4579,7 @@ static int mtk_probe(struct platform_device *pdev)
 		if (!eth->sgmii)
 			return -ENOMEM;
 
+		eth->sgmii->dev = eth->dev;
 		err = mtk_sgmii_init(eth->sgmii, pdev->dev.of_node,
 				     eth->soc->ana_rgc3);
 
@@ -4590,14 +4592,17 @@ static int mtk_probe(struct platform_device *pdev)
 							    "mediatek,pctl");
 		if (IS_ERR(eth->pctl)) {
 			dev_err(&pdev->dev, "no pctl regmap found\n");
-			return PTR_ERR(eth->pctl);
+			err = PTR_ERR(eth->pctl);
+			goto err_destroy_sgmii;
 		}
 	}
 
 	if (MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V2)) {
 		res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-		if (!res)
-			return -EINVAL;
+		if (!res) {
+			err = -EINVAL;
+			goto err_destroy_sgmii;
+		}
 	}
 
 	if (eth->soc->offload_version) {
@@ -4749,6 +4754,8 @@ static int mtk_probe(struct platform_device *pdev)
 
 	return 0;
 
+err_destroy_sgmii:
+	mtk_sgmii_destroy(eth->sgmii);
 err_deinit_ppe:
 	mtk_ppe_deinit(eth);
 	mtk_mdio_cleanup(eth);
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
index 982482712e0a..46d76ca4ad2d 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
@@ -508,65 +508,6 @@
 #define ETHSYS_DMA_AG_MAP_QDMA	BIT(1)
 #define ETHSYS_DMA_AG_MAP_PPE	BIT(2)
 
-/* SGMII subsystem config registers */
-/* BMCR (low 16) BMSR (high 16) */
-#define SGMSYS_PCS_CONTROL_1	0x0
-#define SGMII_BMCR		GENMASK(15, 0)
-#define SGMII_BMSR		GENMASK(31, 16)
-#define SGMII_AN_RESTART	BIT(9)
-#define SGMII_ISOLATE		BIT(10)
-#define SGMII_AN_ENABLE		BIT(12)
-#define SGMII_LINK_STATYS	BIT(18)
-#define SGMII_AN_ABILITY	BIT(19)
-#define SGMII_AN_COMPLETE	BIT(21)
-#define SGMII_PCS_FAULT		BIT(23)
-#define SGMII_AN_EXPANSION_CLR	BIT(30)
-
-#define SGMSYS_PCS_ADVERTISE	0x8
-#define SGMII_ADVERTISE		GENMASK(15, 0)
-#define SGMII_LPA		GENMASK(31, 16)
-
-/* Register to programmable link timer, the unit in 2 * 8ns */
-#define SGMSYS_PCS_LINK_TIMER	0x18
-#define SGMII_LINK_TIMER_MASK	GENMASK(19, 0)
-#define SGMII_LINK_TIMER_DEFAULT	(0x186a0 & SGMII_LINK_TIMER_MASK)
-
-/* Register to control remote fault */
-#define SGMSYS_SGMII_MODE		0x20
-#define SGMII_IF_MODE_SGMII		BIT(0)
-#define SGMII_SPEED_DUPLEX_AN		BIT(1)
-#define SGMII_SPEED_MASK		GENMASK(3, 2)
-#define SGMII_SPEED_10			FIELD_PREP(SGMII_SPEED_MASK, 0)
-#define SGMII_SPEED_100			FIELD_PREP(SGMII_SPEED_MASK, 1)
-#define SGMII_SPEED_1000		FIELD_PREP(SGMII_SPEED_MASK, 2)
-#define SGMII_DUPLEX_HALF		BIT(4)
-#define SGMII_IF_MODE_BIT5		BIT(5)
-#define SGMII_REMOTE_FAULT_DIS		BIT(8)
-#define SGMII_CODE_SYNC_SET_VAL		BIT(9)
-#define SGMII_CODE_SYNC_SET_EN		BIT(10)
-#define SGMII_SEND_AN_ERROR_EN		BIT(11)
-#define SGMII_IF_MODE_MASK		GENMASK(5, 1)
-
-/* Register to reset SGMII design */
-#define SGMII_RESERVED_0	0x34
-#define SGMII_SW_RESET		BIT(0)
-
-/* Register to set SGMII speed, ANA RG_ Control Signals III*/
-#define SGMSYS_ANA_RG_CS3	0x2028
-#define RG_PHY_SPEED_MASK	(BIT(2) | BIT(3))
-#define RG_PHY_SPEED_1_25G	0x0
-#define RG_PHY_SPEED_3_125G	BIT(2)
-
-/* Register to power up QPHY */
-#define SGMSYS_QPHY_PWR_STATE_CTRL 0xe8
-#define	SGMII_PHYA_PWD		BIT(4)
-
-/* Register to QPHY wrapper control */
-#define SGMSYS_QPHY_WRAP_CTRL	0xec
-#define SGMII_PN_SWAP_MASK	GENMASK(1, 0)
-#define SGMII_PN_SWAP_TX_RX	(BIT(0) | BIT(1))
-#define MTK_SGMII_FLAG_PN_SWAP	BIT(0)
-
 /* Infrasys subsystem config registers */
 #define INFRA_MISC2            0x70c
 #define CO_QPHY_SEL            BIT(0)
@@ -1101,29 +1042,13 @@ struct mtk_soc_data {
 /* currently no SoC has more than 2 macs */
 #define MTK_MAX_DEVS			2
 
-/* struct mtk_pcs -    This structure holds each sgmii regmap and associated
- *                     data
- * @regmap:            The register map pointing at the range used to setup
- *                     SGMII modes
- * @ana_rgc3:          The offset refers to register ANA_RGC3 related to regmap
- * @interface:         Currently configured interface mode
- * @pcs:               Phylink PCS structure
- * @flags:             Flags indicating hardware properties
- */
-struct mtk_pcs {
-	struct regmap	*regmap;
-	u32             ana_rgc3;
-	phy_interface_t	interface;
-	struct phylink_pcs pcs;
-	u32		flags;
-};
-
 /* struct mtk_sgmii -  This is the structure holding sgmii regmap and its
  *                     characteristics
  * @pcs                Array of individual PCS structures
  */
 struct mtk_sgmii {
-	struct mtk_pcs	pcs[MTK_MAX_DEVS];
+	struct phylink_pcs *pcs[MTK_MAX_DEVS];
+	struct device *dev;
 };
 
 /* struct mtk_eth -	This is the main datasructure for holding the state
@@ -1351,6 +1276,7 @@ u32 mtk_r32(struct mtk_eth *eth, unsigned reg);
 struct phylink_pcs *mtk_sgmii_select_pcs(struct mtk_sgmii *ss, int id);
 int mtk_sgmii_init(struct mtk_sgmii *ss, struct device_node *np,
 		   u32 ana_rgc3);
+void mtk_sgmii_destroy(struct mtk_sgmii *ss);
 
 int mtk_gmac_sgmii_path_setup(struct mtk_eth *eth, int mac_id);
 int mtk_gmac_gephy_path_setup(struct mtk_eth *eth, int mac_id);
diff --git a/drivers/net/ethernet/mediatek/mtk_sgmii.c b/drivers/net/ethernet/mediatek/mtk_sgmii.c
index 58b5f2f70a66..d2c320c9746b 100644
--- a/drivers/net/ethernet/mediatek/mtk_sgmii.c
+++ b/drivers/net/ethernet/mediatek/mtk_sgmii.c
@@ -10,199 +10,34 @@
 #include <linux/mfd/syscon.h>
 #include <linux/of.h>
 #include <linux/phylink.h>
+#include <linux/pcs/pcs-mtk.h>
 #include <linux/regmap.h>
 
 #include "mtk_eth_soc.h"
 
-static struct mtk_pcs *pcs_to_mtk_pcs(struct phylink_pcs *pcs)
-{
-	return container_of(pcs, struct mtk_pcs, pcs);
-}
-
-static void mtk_pcs_get_state(struct phylink_pcs *pcs,
-			      struct phylink_link_state *state)
-{
-	struct mtk_pcs *mpcs = pcs_to_mtk_pcs(pcs);
-	unsigned int bm, adv;
-
-	/* Read the BMSR and LPA */
-	regmap_read(mpcs->regmap, SGMSYS_PCS_CONTROL_1, &bm);
-	regmap_read(mpcs->regmap, SGMSYS_PCS_ADVERTISE, &adv);
-
-	phylink_mii_c22_pcs_decode_state(state, FIELD_GET(SGMII_BMSR, bm),
-					 FIELD_GET(SGMII_LPA, adv));
-}
-
-static int mtk_pcs_config(struct phylink_pcs *pcs, unsigned int mode,
-			  phy_interface_t interface,
-			  const unsigned long *advertising,
-			  bool permit_pause_to_mac)
-{
-	struct mtk_pcs *mpcs = pcs_to_mtk_pcs(pcs);
-	unsigned int rgc3, sgm_mode, bmcr;
-	int advertise, link_timer;
-	bool mode_changed = false, changed, use_an;
-
-	advertise = phylink_mii_c22_pcs_encode_advertisement(interface,
-							     advertising);
-	if (advertise < 0)
-		return advertise;
-
-	/* Clearing IF_MODE_BIT0 switches the PCS to BASE-X mode, and
-	 * we assume that fixes it's speed at bitrate = line rate (in
-	 * other words, 1000Mbps or 2500Mbps).
-	 */
-	if (interface == PHY_INTERFACE_MODE_SGMII) {
-		sgm_mode = SGMII_IF_MODE_SGMII;
-		if (phylink_autoneg_inband(mode)) {
-			sgm_mode |= SGMII_REMOTE_FAULT_DIS |
-				    SGMII_SPEED_DUPLEX_AN;
-			use_an = true;
-		} else {
-			use_an = false;
-		}
-	} else if (phylink_autoneg_inband(mode)) {
-		/* 1000base-X or 2500base-X autoneg */
-		sgm_mode = SGMII_REMOTE_FAULT_DIS;
-		use_an = linkmode_test_bit(ETHTOOL_LINK_MODE_Autoneg_BIT,
-					   advertising);
-	} else {
-		/* 1000base-X or 2500base-X without autoneg */
-		sgm_mode = 0;
-		use_an = false;
-	}
-
-	if (use_an) {
-		bmcr = SGMII_AN_ENABLE;
-	} else {
-		bmcr = 0;
-	}
-
-	if (mpcs->interface != interface) {
-		/* PHYA power down */
-		regmap_update_bits(mpcs->regmap, SGMSYS_QPHY_PWR_STATE_CTRL,
-				   SGMII_PHYA_PWD, SGMII_PHYA_PWD);
-
-		/* Reset SGMII PCS state */
-		regmap_update_bits(mpcs->regmap, SGMII_RESERVED_0,
-				   SGMII_SW_RESET, SGMII_SW_RESET);
-
-		if (mpcs->flags & MTK_SGMII_FLAG_PN_SWAP)
-			regmap_update_bits(mpcs->regmap, SGMSYS_QPHY_WRAP_CTRL,
-					   SGMII_PN_SWAP_MASK,
-					   SGMII_PN_SWAP_TX_RX);
-
-		if (interface == PHY_INTERFACE_MODE_2500BASEX)
-			rgc3 = RG_PHY_SPEED_3_125G;
-		else
-			rgc3 = 0;
-
-		/* Configure the underlying interface speed */
-		regmap_update_bits(mpcs->regmap, mpcs->ana_rgc3,
-				   RG_PHY_SPEED_3_125G, rgc3);
-
-		/* Setup the link timer and QPHY power up inside SGMIISYS */
-		link_timer = phylink_get_link_timer_ns(interface);
-		if (link_timer < 0)
-			return link_timer;
-
-		regmap_write(mpcs->regmap, SGMSYS_PCS_LINK_TIMER, link_timer / 2 / 8);
-
-		mpcs->interface = interface;
-		mode_changed = true;
-	}
-
-	/* Update the advertisement, noting whether it has changed */
-	regmap_update_bits_check(mpcs->regmap, SGMSYS_PCS_ADVERTISE,
-				 SGMII_ADVERTISE, advertise, &changed);
-
-	/* Update the sgmsys mode register */
-	regmap_update_bits(mpcs->regmap, SGMSYS_SGMII_MODE,
-			   SGMII_REMOTE_FAULT_DIS | SGMII_SPEED_DUPLEX_AN |
-			   SGMII_IF_MODE_SGMII, sgm_mode);
-
-	/* Update the BMCR */
-	regmap_update_bits(mpcs->regmap, SGMSYS_PCS_CONTROL_1,
-			   SGMII_AN_ENABLE, bmcr);
-
-	/* Release PHYA power down state
-	 * Only removing bit SGMII_PHYA_PWD isn't enough.
-	 * There are cases when the SGMII_PHYA_PWD register contains 0x9 which
-	 * prevents SGMII from working. The SGMII still shows link but no traffic
-	 * can flow. Writing 0x0 to the PHYA_PWD register fix the issue. 0x0 was
-	 * taken from a good working state of the SGMII interface.
-	 * Unknown how much the QPHY needs but it is racy without a sleep.
-	 * Tested on mt7622 & mt7986.
-	 */
-	usleep_range(50, 100);
-	regmap_write(mpcs->regmap, SGMSYS_QPHY_PWR_STATE_CTRL, 0);
-
-	return changed || mode_changed;
-}
-
-static void mtk_pcs_restart_an(struct phylink_pcs *pcs)
-{
-	struct mtk_pcs *mpcs = pcs_to_mtk_pcs(pcs);
-
-	regmap_update_bits(mpcs->regmap, SGMSYS_PCS_CONTROL_1,
-			   SGMII_AN_RESTART, SGMII_AN_RESTART);
-}
-
-static void mtk_pcs_link_up(struct phylink_pcs *pcs, unsigned int mode,
-			    phy_interface_t interface, int speed, int duplex)
-{
-	struct mtk_pcs *mpcs = pcs_to_mtk_pcs(pcs);
-	unsigned int sgm_mode;
-
-	if (!phylink_autoneg_inband(mode)) {
-		/* Force the speed and duplex setting */
-		if (speed == SPEED_10)
-			sgm_mode = SGMII_SPEED_10;
-		else if (speed == SPEED_100)
-			sgm_mode = SGMII_SPEED_100;
-		else
-			sgm_mode = SGMII_SPEED_1000;
-
-		if (duplex != DUPLEX_FULL)
-			sgm_mode |= SGMII_DUPLEX_HALF;
-
-		regmap_update_bits(mpcs->regmap, SGMSYS_SGMII_MODE,
-				   SGMII_DUPLEX_HALF | SGMII_SPEED_MASK,
-				   sgm_mode);
-	}
-}
-
-static const struct phylink_pcs_ops mtk_pcs_ops = {
-	.pcs_get_state = mtk_pcs_get_state,
-	.pcs_config = mtk_pcs_config,
-	.pcs_an_restart = mtk_pcs_restart_an,
-	.pcs_link_up = mtk_pcs_link_up,
-};
-
 int mtk_sgmii_init(struct mtk_sgmii *ss, struct device_node *r, u32 ana_rgc3)
 {
 	struct device_node *np;
 	int i;
+	u32 flags;
+	struct regmap *regmap;
 
 	for (i = 0; i < MTK_MAX_DEVS; i++) {
 		np = of_parse_phandle(r, "mediatek,sgmiisys", i);
 		if (!np)
 			break;
 
-		ss->pcs[i].ana_rgc3 = ana_rgc3;
-		ss->pcs[i].regmap = syscon_node_to_regmap(np);
-
-		ss->pcs[i].flags = 0;
+		flags = 0;
 		if (of_property_read_bool(np, "pn_swap"))
-			ss->pcs[i].flags |= MTK_SGMII_FLAG_PN_SWAP;
+			flags |= MTK_SGMII_FLAG_PN_SWAP;
 
 		of_node_put(np);
-		if (IS_ERR(ss->pcs[i].regmap))
-			return PTR_ERR(ss->pcs[i].regmap);
 
-		ss->pcs[i].pcs.ops = &mtk_pcs_ops;
-		ss->pcs[i].pcs.poll = true;
-		ss->pcs[i].interface = PHY_INTERFACE_MODE_NA;
+		regmap = syscon_node_to_regmap(np);
+		if (IS_ERR(regmap))
+			return PTR_ERR(regmap);
+
+		ss->pcs[i] = mtk_pcs_create(ss->dev, regmap, ana_rgc3, flags);
 	}
 
 	return 0;
@@ -210,8 +45,17 @@ int mtk_sgmii_init(struct mtk_sgmii *ss, struct device_node *r, u32 ana_rgc3)
 
 struct phylink_pcs *mtk_sgmii_select_pcs(struct mtk_sgmii *ss, int id)
 {
-	if (!ss->pcs[id].regmap)
-		return NULL;
+	return ss->pcs[id];
+}
+
+void mtk_sgmii_destroy(struct mtk_sgmii *ss)
+{
+	int i;
+
+	if (!ss)
+		return;
 
-	return &ss->pcs[id].pcs;
+	for (i = 0; i < MTK_MAX_DEVS; i++)
+		if (ss->pcs[i])
+			mtk_pcs_destroy(ss->pcs[i]);
 }
-- 
2.39.1

