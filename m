Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5F3950F2E
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 16:53:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729027AbfFXOxQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 10:53:16 -0400
Received: from mx.0dd.nl ([5.2.79.48]:33466 "EHLO mx.0dd.nl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726414AbfFXOxQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Jun 2019 10:53:16 -0400
Received: from mail.vdorst.com (mail.vdorst.com [IPv6:fd01::250])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.0dd.nl (Postfix) with ESMTPS id 716AE5FAF1;
        Mon, 24 Jun 2019 16:53:13 +0200 (CEST)
Authentication-Results: mx.0dd.nl;
        dkim=pass (2048-bit key) header.d=vdorst.com header.i=@vdorst.com header.b="GJtV9xSq";
        dkim-atps=neutral
Received: from pc-rene.vdorst.com (pc-rene.vdorst.com [192.168.2.125])
        by mail.vdorst.com (Postfix) with ESMTPA id 39F131CC6F02;
        Mon, 24 Jun 2019 16:53:13 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.vdorst.com 39F131CC6F02
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vdorst.com;
        s=default; t=1561387993;
        bh=ntWgRRFlEq74/wAxR4H5vmKgfUgKV2R2TR8EFS2knZA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GJtV9xSq5TWbzBPby9kcGLiQan+Oux2wVD+O029i8Azb1b0jjj+qO+2H3LwBsdIBS
         +9nEV06p6Hvs5pbIxf0Jxxr6YZ/0swVAt/76lVqTBmN2vfTzsteHJV1usROUCDShIz
         BvJqQSmb0pjB+V2vjH8yh1qgT8JfMnj//hcRJD9fPfjhPFnAwH9m1WfPDaJzxRbp77
         zDmGWhq3joBb/yP+UjwIgClM/5MrxOJcL2bQYLsiVYpsgPTObN/CZPnMO/VbCZTTB6
         Ud2S4d9MfGFRYQCqpxOEP5evtZCURTgXSUMpEMgtwoqPBGSi0Sappe/WdC2pfcIpRn
         uMr1yUu5nQNmQ==
From:   =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>
To:     sean.wang@mediatek.com, f.fainelli@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, matthias.bgg@gmail.com,
        andrew@lunn.ch, vivien.didelot@gmail.com
Cc:     frank-w@public-files.de, netdev@vger.kernel.org,
        linux-mediatek@lists.infradead.org, linux-mips@vger.kernel.org,
        =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>
Subject: [PATCH RFC net-next 1/5] net: dsa: mt7530: Convert to PHYLINK API
Date:   Mon, 24 Jun 2019 16:52:47 +0200
Message-Id: <20190624145251.4849-2-opensource@vdorst.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190624145251.4849-1-opensource@vdorst.com>
References: <20190624145251.4849-1-opensource@vdorst.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert mt7530 to PHYLINK API

Signed-off-by: René van Dorst <opensource@vdorst.com>
---
 drivers/net/dsa/mt7530.c | 237 +++++++++++++++++++++++++++++----------
 drivers/net/dsa/mt7530.h |   9 ++
 2 files changed, 187 insertions(+), 59 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 3181e95586d6..9c5e4dd00826 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -13,7 +13,7 @@
 #include <linux/of_mdio.h>
 #include <linux/of_net.h>
 #include <linux/of_platform.h>
-#include <linux/phy.h>
+#include <linux/phylink.h>
 #include <linux/regmap.h>
 #include <linux/regulator/consumer.h>
 #include <linux/reset.h>
@@ -633,63 +633,6 @@ mt7530_get_sset_count(struct dsa_switch *ds, int port, int sset)
 	return ARRAY_SIZE(mt7530_mib);
 }
 
-static void mt7530_adjust_link(struct dsa_switch *ds, int port,
-			       struct phy_device *phydev)
-{
-	struct mt7530_priv *priv = ds->priv;
-
-	if (phy_is_pseudo_fixed_link(phydev)) {
-		dev_dbg(priv->dev, "phy-mode for master device = %x\n",
-			phydev->interface);
-
-		/* Setup TX circuit incluing relevant PAD and driving */
-		mt7530_pad_clk_setup(ds, phydev->interface);
-
-		if (priv->id == ID_MT7530) {
-			/* Setup RX circuit, relevant PAD and driving on the
-			 * host which must be placed after the setup on the
-			 * device side is all finished.
-			 */
-			mt7623_pad_clk_setup(ds);
-		}
-	} else {
-		u16 lcl_adv = 0, rmt_adv = 0;
-		u8 flowctrl;
-		u32 mcr = PMCR_USERP_LINK | PMCR_FORCE_MODE;
-
-		switch (phydev->speed) {
-		case SPEED_1000:
-			mcr |= PMCR_FORCE_SPEED_1000;
-			break;
-		case SPEED_100:
-			mcr |= PMCR_FORCE_SPEED_100;
-			break;
-		}
-
-		if (phydev->link)
-			mcr |= PMCR_FORCE_LNK;
-
-		if (phydev->duplex) {
-			mcr |= PMCR_FORCE_FDX;
-
-			if (phydev->pause)
-				rmt_adv = LPA_PAUSE_CAP;
-			if (phydev->asym_pause)
-				rmt_adv |= LPA_PAUSE_ASYM;
-
-			lcl_adv = linkmode_adv_to_lcl_adv_t(
-				phydev->advertising);
-			flowctrl = mii_resolve_flowctrl_fdx(lcl_adv, rmt_adv);
-
-			if (flowctrl & FLOW_CTRL_TX)
-				mcr |= PMCR_TX_FC_EN;
-			if (flowctrl & FLOW_CTRL_RX)
-				mcr |= PMCR_RX_FC_EN;
-		}
-		mt7530_write(priv, MT7530_PMCR_P(port), mcr);
-	}
-}
-
 static int
 mt7530_cpu_port_enable(struct mt7530_priv *priv,
 		       int port)
@@ -1323,6 +1266,178 @@ mt7530_setup(struct dsa_switch *ds)
 	return 0;
 }
 
+static void mt7530_phylink_mac_config(struct dsa_switch *ds, int port,
+				      unsigned int mode,
+				      const struct phylink_link_state *state)
+{
+	struct mt7530_priv *priv = ds->priv;
+	u32 mcr = PMCR_IFG_XMIT(1) | PMCR_MAC_MODE | PMCR_BACKOFF_EN |
+		  PMCR_BACKPR_EN | PMCR_TX_EN | PMCR_RX_EN;
+
+	switch (port) {
+	case 0: /* Internal phy */
+	case 1:
+	case 2:
+	case 3:
+	case 4:
+		if (state->interface != PHY_INTERFACE_MODE_GMII)
+			goto unsupported;
+		break;
+	/* case 5: Port 5 is not supported! */
+	case 6: /* 1st cpu port */
+		if (state->interface != PHY_INTERFACE_MODE_RGMII &&
+		    state->interface != PHY_INTERFACE_MODE_TRGMII)
+			goto unsupported;
+
+		/* Setup TX circuit incluing relevant PAD and driving */
+		mt7530_pad_clk_setup(ds, state->interface);
+
+		if (priv->id == ID_MT7530) {
+			/* Setup RX circuit, relevant PAD and driving on the
+			 * host which must be placed after the setup on the
+			 * device side is all finished.
+			 */
+			mt7623_pad_clk_setup(ds);
+		}
+		break;
+	default:
+		dev_err(ds->dev, "%s: unsupported port: %i\n", __func__, port);
+		return;
+	}
+
+	if (!state->an_enabled || mode == MLO_AN_FIXED) {
+		mcr |= PMCR_FORCE_MODE;
+
+		if (state->speed == SPEED_1000)
+			mcr |= PMCR_FORCE_SPEED_1000;
+		if (state->speed == SPEED_100)
+			mcr |= PMCR_FORCE_SPEED_100;
+		if (state->duplex == DUPLEX_FULL)
+			mcr |= PMCR_FORCE_FDX;
+		if (state->link || mode == MLO_AN_FIXED)
+			mcr |= PMCR_FORCE_LNK;
+		if (state->pause || phylink_test(state->advertising, Pause))
+			mcr |= PMCR_TX_FC_EN | PMCR_RX_FC_EN;
+		if (state->pause & MLO_PAUSE_TX)
+			mcr |= PMCR_TX_FC_EN;
+		if (state->pause & MLO_PAUSE_RX)
+			mcr |= PMCR_RX_FC_EN;
+	}
+
+	mt7530_write(priv, MT7530_PMCR_P(port), mcr);
+
+	return;
+
+unsupported:
+	dev_err(ds->dev, "%s: P%d: Unsupported phy_interface mode: %d (%s)\n",
+		__func__, port, state->interface, phy_modes(state->interface));
+}
+
+static void mt7530_phylink_mac_link_down(struct dsa_switch *ds, int port,
+					 unsigned int mode,
+					 phy_interface_t interface)
+{
+	/* Do nothing */
+}
+
+static void mt7530_phylink_mac_link_up(struct dsa_switch *ds, int port,
+				       unsigned int mode,
+				       phy_interface_t interface,
+				       struct phy_device *phydev)
+{
+	/* Do nothing */
+}
+
+static void mt7530_phylink_validate(struct dsa_switch *ds, int port,
+				    unsigned long *supported,
+				    struct phylink_link_state *state)
+{
+	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
+
+	switch (port) {
+	case 0: /* Internal phy */
+	case 1:
+	case 2:
+	case 3:
+	case 4:
+		if (state->interface != PHY_INTERFACE_MODE_NA &&
+		    state->interface != PHY_INTERFACE_MODE_GMII)
+			goto unsupported;
+		break;
+	/* case 5: Port 5 not supported! */
+	case 6: /* 1st cpu port */
+		if (state->interface != PHY_INTERFACE_MODE_RGMII &&
+		    state->interface != PHY_INTERFACE_MODE_TRGMII)
+			goto unsupported;
+		break;
+	default:
+		linkmode_zero(supported);
+		dev_err(ds->dev, "%s: unsupported port: %i\n", __func__, port);
+		return;
+	}
+
+	phylink_set(mask, Autoneg);
+	phylink_set(mask, Pause);
+	phylink_set(mask, Asym_Pause);
+	phylink_set(mask, MII);
+
+	phylink_set(mask, 10baseT_Half);
+	phylink_set(mask, 10baseT_Full);
+	phylink_set(mask, 100baseT_Half);
+	phylink_set(mask, 100baseT_Full);
+	phylink_set(mask, 1000baseT_Full);
+	phylink_set(mask, 1000baseT_Half);
+
+	linkmode_and(supported, supported, mask);
+	linkmode_and(state->advertising, state->advertising, mask);
+	return;
+
+unsupported:
+	linkmode_zero(supported);
+	dev_err(ds->dev, "%s: unsupported interface mode: [0x%x] %s\n",
+		__func__, state->interface, phy_modes(state->interface));
+}
+
+static int
+mt7530_phylink_mac_link_state(struct dsa_switch *ds, int port,
+			      struct phylink_link_state *state)
+{
+	struct mt7530_priv *priv = ds->priv;
+	u32 pmsr;
+
+	if (port < 0 || port >= MT7530_NUM_PORTS)
+		return -EINVAL;
+
+	pmsr = mt7530_read(priv, MT7530_PMSR_P(port));
+
+	state->link = (pmsr & PMSR_LINK);
+	state->an_complete = state->link;
+	state->duplex = (pmsr & PMSR_DPX) >> 1;
+
+	switch (pmsr & (PMSR_SPEED_1000 | PMSR_SPEED_100)) {
+	case 0:
+		state->speed = SPEED_10;
+		break;
+	case PMSR_SPEED_100:
+		state->speed = SPEED_100;
+		break;
+	case PMSR_SPEED_1000:
+		state->speed = SPEED_1000;
+		break;
+	default:
+		state->speed = SPEED_UNKNOWN;
+		break;
+	}
+
+	state->pause = 0;
+	if (pmsr & PMSR_RX_FC)
+		state->pause |= MLO_PAUSE_RX;
+	if (pmsr & PMSR_TX_FC)
+		state->pause |= MLO_PAUSE_TX;
+
+	return 1;
+}
+
 static const struct dsa_switch_ops mt7530_switch_ops = {
 	.get_tag_protocol	= mtk_get_tag_protocol,
 	.setup			= mt7530_setup,
@@ -1331,7 +1446,6 @@ static const struct dsa_switch_ops mt7530_switch_ops = {
 	.phy_write		= mt7530_phy_write,
 	.get_ethtool_stats	= mt7530_get_ethtool_stats,
 	.get_sset_count		= mt7530_get_sset_count,
-	.adjust_link		= mt7530_adjust_link,
 	.port_enable		= mt7530_port_enable,
 	.port_disable		= mt7530_port_disable,
 	.port_stp_state_set	= mt7530_stp_state_set,
@@ -1344,6 +1458,11 @@ static const struct dsa_switch_ops mt7530_switch_ops = {
 	.port_vlan_prepare	= mt7530_port_vlan_prepare,
 	.port_vlan_add		= mt7530_port_vlan_add,
 	.port_vlan_del		= mt7530_port_vlan_del,
+	.phylink_validate	= mt7530_phylink_validate,
+	.phylink_mac_link_state = mt7530_phylink_mac_link_state,
+	.phylink_mac_config	= mt7530_phylink_mac_config,
+	.phylink_mac_link_down	= mt7530_phylink_mac_link_down,
+	.phylink_mac_link_up	= mt7530_phylink_mac_link_up,
 };
 
 static const struct of_device_id mt7530_of_match[] = {
diff --git a/drivers/net/dsa/mt7530.h b/drivers/net/dsa/mt7530.h
index bfac90f48102..41d9a132ac70 100644
--- a/drivers/net/dsa/mt7530.h
+++ b/drivers/net/dsa/mt7530.h
@@ -198,6 +198,7 @@ enum mt7530_vlan_port_attr {
 #define  PMCR_FORCE_SPEED_100		BIT(2)
 #define  PMCR_FORCE_FDX			BIT(1)
 #define  PMCR_FORCE_LNK			BIT(0)
+#define  PMCR_FORCE_LNK_DOWN		PMCR_FORCE_MODE
 #define  PMCR_COMMON_LINK		(PMCR_IFG_XMIT(1) | PMCR_MAC_MODE | \
 					 PMCR_BACKOFF_EN | PMCR_BACKPR_EN | \
 					 PMCR_TX_EN | PMCR_RX_EN | \
@@ -218,6 +219,14 @@ enum mt7530_vlan_port_attr {
 					 PMCR_TX_FC_EN | PMCR_RX_FC_EN)
 
 #define MT7530_PMSR_P(x)		(0x3008 + (x) * 0x100)
+#define  PMSR_EEE1G			BIT(7)
+#define  PMSR_EEE100M			BIT(6)
+#define  PMSR_RX_FC			BIT(5)
+#define  PMSR_TX_FC			BIT(4)
+#define  PMSR_SPEED_1000		BIT(3)
+#define  PMSR_SPEED_100			BIT(2)
+#define  PMSR_DPX			BIT(1)
+#define  PMSR_LINK			BIT(0)
 
 /* Register for MIB */
 #define MT7530_PORT_MIB_COUNTER(x)	(0x4000 + (x) * 0x100)
-- 
2.20.1

