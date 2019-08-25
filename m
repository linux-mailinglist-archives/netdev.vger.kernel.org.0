Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 429319C53F
	for <lists+netdev@lfdr.de>; Sun, 25 Aug 2019 19:44:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728787AbfHYRoC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Aug 2019 13:44:02 -0400
Received: from mx.0dd.nl ([5.2.79.48]:38706 "EHLO mx.0dd.nl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725971AbfHYRn6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 25 Aug 2019 13:43:58 -0400
Received: from mail.vdorst.com (mail.vdorst.com [IPv6:fd01::250])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.0dd.nl (Postfix) with ESMTPS id 2AD125FC96;
        Sun, 25 Aug 2019 19:43:55 +0200 (CEST)
Authentication-Results: mx.0dd.nl;
        dkim=pass (2048-bit key) header.d=vdorst.com header.i=@vdorst.com header.b="DOrS+L25";
        dkim-atps=neutral
Received: from pc-rene.vdorst.com (pc-rene.vdorst.com [192.168.2.125])
        by mail.vdorst.com (Postfix) with ESMTPA id DA3491D8E164;
        Sun, 25 Aug 2019 19:43:54 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.vdorst.com DA3491D8E164
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vdorst.com;
        s=default; t=1566755034;
        bh=Rt1Y5fT37HpNUGUqGr2s1G3C7KWN2yOcBRSfSurO1qQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DOrS+L25dulP0v9c5f6czcWXbjeMhoG2lsHhFxiLAOiZsX53u7rBHOzir341aHXO1
         8LTFWpm3fJQTXx+2Dix8CPGBJA4xghZo0COkrchdMVJ4fYcxn794+hOy/jnL/REkjA
         QGLMTchZ3lxew3VQsNUAkSqrR94Unmuk943fDec07BCXJ3IaXybECiSkOfeCA5xrVV
         NmRt6jBaYHer0kSLNnK91MlKiR4kQirG1PeSdsDghiZgYmFO3sQIQQ7dQodBF48y3F
         MnpdXOrI1C8qb8n2n9k1AQZhiALqPVw2/09VIJcyXp7qOlt5P3wxwQuwNC9T7Dxui+
         y5CuIDceGlfhg==
From:   =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>
To:     John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Nelson Chang <nelson.chang@mediatek.com>,
        "David S . Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>
Cc:     netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-mips@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Frank Wunderlich <frank-w@public-files.de>,
        Stefan Roese <sr@denx.de>,
        =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>
Subject: [PATCH net-next v4 1/3] net: ethernet: mediatek: Add basic PHYLINK support
Date:   Sun, 25 Aug 2019 19:43:39 +0200
Message-Id: <20190825174341.20750-2-opensource@vdorst.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190825174341.20750-1-opensource@vdorst.com>
References: <20190825174341.20750-1-opensource@vdorst.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This convert the basics to PHYLINK API.
SGMII support is not in this patch.

Signed-off-by: René van Dorst <opensource@vdorst.com>
--
v3->v4:
* In link_down() a ~ was missing before the (, RX and TX bits have to be
  cleared. Spotted by Russell King
v2->v3:
* Make link_down() similar as link_up() suggested by Russell King
v1->v2:
* Also report 1000Base-X support suggested by Russell King
* Reverse christmas on many places suggested by David Miller
* Rebase too pickup the mt76x8 changes.
---
 drivers/net/ethernet/mediatek/Kconfig       |   2 +-
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 424 +++++++++++---------
 drivers/net/ethernet/mediatek/mtk_eth_soc.h |  31 +-
 3 files changed, 265 insertions(+), 192 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/Kconfig b/drivers/net/ethernet/mediatek/Kconfig
index b76cf2e1c9dc..4968352ba188 100644
--- a/drivers/net/ethernet/mediatek/Kconfig
+++ b/drivers/net/ethernet/mediatek/Kconfig
@@ -9,7 +9,7 @@ if NET_VENDOR_MEDIATEK
 
 config NET_MEDIATEK_SOC
 	tristate "MediaTek SoC Gigabit Ethernet support"
-	select PHYLIB
+	select PHYLINK
 	---help---
 	  This driver supports the gigabit ethernet MACs in the
 	  MediaTek SoC family.
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 8ddbb8dcf032..7d2566dd4ce0 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -18,6 +18,7 @@
 #include <linux/tcp.h>
 #include <linux/interrupt.h>
 #include <linux/pinctrl/devinfo.h>
+#include <linux/phylink.h>
 
 #include "mtk_eth_soc.h"
 
@@ -186,168 +187,224 @@ static void mtk_gmac0_rgmii_adjust(struct mtk_eth *eth, int speed)
 	mtk_w32(eth, val, TRGMII_TCK_CTRL);
 }
 
-static void mtk_phy_link_adjust(struct net_device *dev)
+static void mtk_mac_config(struct phylink_config *config, unsigned int mode,
+			   const struct phylink_link_state *state)
 {
-	struct mtk_mac *mac = netdev_priv(dev);
-	u16 lcl_adv = 0, rmt_adv = 0;
-	u8 flowctrl;
-	u32 mcr = MAC_MCR_MAX_RX_1536 | MAC_MCR_IPG_CFG |
-		  MAC_MCR_FORCE_MODE | MAC_MCR_TX_EN |
-		  MAC_MCR_RX_EN | MAC_MCR_BACKOFF_EN |
-		  MAC_MCR_BACKPR_EN;
+	struct mtk_mac *mac = container_of(config, struct mtk_mac,
+					   phylink_config);
+	struct mtk_eth *eth = mac->hw;
+	u32 mcr_cur, mcr_new;
+	int val, ge_mode = 0;
+
+	/* MT76x8 has no hardware settings between for the MAC */
+	if (!MTK_HAS_CAPS(eth->soc->caps, MTK_SOC_MT7628) &&
+	    mac->interface != state->interface) {
+		/* Setup soc pin functions */
+		switch (state->interface) {
+		case PHY_INTERFACE_MODE_TRGMII:
+			if (mac->id)
+				goto err_phy;
+			if (!MTK_HAS_CAPS(mac->hw->soc->caps,
+					  MTK_GMAC1_TRGMII))
+				goto err_phy;
+			/* fall through */
+		case PHY_INTERFACE_MODE_GMII:
+		case PHY_INTERFACE_MODE_RGMII_TXID:
+		case PHY_INTERFACE_MODE_RGMII_RXID:
+		case PHY_INTERFACE_MODE_RGMII_ID:
+		case PHY_INTERFACE_MODE_RGMII:
+			break;
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
+			goto err_phy;
+		}
 
-	if (unlikely(test_bit(MTK_RESETTING, &mac->hw->state)))
-		return;
+		/* Setup clock for 1st gmac */
+		if (!mac->id &&
+		    MTK_HAS_CAPS(mac->hw->soc->caps, MTK_GMAC1_TRGMII)) {
+			if (MTK_HAS_CAPS(mac->hw->soc->caps,
+					 MTK_TRGMII_MT7621_CLK)) {
+				if (mt7621_gmac0_rgmii_adjust(mac->hw,
+							      state->interface))
+					goto err_phy;
+			} else {
+				if (state->interface !=
+				    PHY_INTERFACE_MODE_TRGMII)
+					mtk_gmac0_rgmii_adjust(mac->hw,
+							       state->speed);
+			}
+		}
 
-	switch (dev->phydev->speed) {
+		/* put the gmac into the right mode */
+		regmap_read(eth->ethsys, ETHSYS_SYSCFG0, &val);
+		val &= ~SYSCFG0_GE_MODE(SYSCFG0_GE_MASK, mac->id);
+		val |= SYSCFG0_GE_MODE(ge_mode, mac->id);
+		regmap_write(eth->ethsys, ETHSYS_SYSCFG0, val);
+
+		mac->interface = state->interface;
+	}
+
+	/* Setup gmac */
+	mcr_cur = mtk_r32(mac->hw, MTK_MAC_MCR(mac->id));
+	mcr_new = mcr_cur;
+	mcr_new &= ~(MAC_MCR_SPEED_100 | MAC_MCR_SPEED_1000 |
+		     MAC_MCR_FORCE_DPX | MAC_MCR_FORCE_TX_FC |
+		     MAC_MCR_FORCE_RX_FC);
+	mcr_new |= MAC_MCR_MAX_RX_1536 | MAC_MCR_IPG_CFG | MAC_MCR_FORCE_MODE |
+		   MAC_MCR_BACKOFF_EN | MAC_MCR_BACKPR_EN | MAC_MCR_FORCE_LINK;
+
+	switch (state->speed) {
 	case SPEED_1000:
-		mcr |= MAC_MCR_SPEED_1000;
+		mcr_new |= MAC_MCR_SPEED_1000;
 		break;
 	case SPEED_100:
-		mcr |= MAC_MCR_SPEED_100;
+		mcr_new |= MAC_MCR_SPEED_100;
 		break;
 	}
-
-	if (MTK_HAS_CAPS(mac->hw->soc->caps, MTK_GMAC1_TRGMII) && !mac->id) {
-		if (MTK_HAS_CAPS(mac->hw->soc->caps, MTK_TRGMII_MT7621_CLK)) {
-			if (mt7621_gmac0_rgmii_adjust(mac->hw,
-						      dev->phydev->interface))
-				return;
-		} else {
-			if (!mac->trgmii)
-				mtk_gmac0_rgmii_adjust(mac->hw,
-						       dev->phydev->speed);
-		}
+	if (state->duplex == DUPLEX_FULL) {
+		mcr_new |= MAC_MCR_FORCE_DPX;
+		if (state->pause & MLO_PAUSE_TX)
+			mcr_new |= MAC_MCR_FORCE_TX_FC;
+		if (state->pause & MLO_PAUSE_RX)
+			mcr_new |= MAC_MCR_FORCE_RX_FC;
 	}
 
-	if (dev->phydev->link)
-		mcr |= MAC_MCR_FORCE_LINK;
+	/* Only update control register when needed! */
+	if (mcr_new != mcr_cur)
+		mtk_w32(mac->hw, mcr_new, MTK_MAC_MCR(mac->id));
 
-	if (dev->phydev->duplex) {
-		mcr |= MAC_MCR_FORCE_DPX;
+	return;
 
-		if (dev->phydev->pause)
-			rmt_adv = LPA_PAUSE_CAP;
-		if (dev->phydev->asym_pause)
-			rmt_adv |= LPA_PAUSE_ASYM;
+err_phy:
+	dev_err(eth->dev, "%s: GMAC%d mode %s not supported!\n", __func__,
+		mac->id, phy_modes(state->interface));
+}
 
-		lcl_adv = linkmode_adv_to_lcl_adv_t(dev->phydev->advertising);
-		flowctrl = mii_resolve_flowctrl_fdx(lcl_adv, rmt_adv);
+static int mtk_mac_link_state(struct phylink_config *config,
+			      struct phylink_link_state *state)
+{
+	struct mtk_mac *mac = container_of(config, struct mtk_mac,
+					   phylink_config);
+	u32 pmsr = mtk_r32(mac->hw, MTK_MAC_MSR(mac->id));
 
-		if (flowctrl & FLOW_CTRL_TX)
-			mcr |= MAC_MCR_FORCE_TX_FC;
-		if (flowctrl & FLOW_CTRL_RX)
-			mcr |= MAC_MCR_FORCE_RX_FC;
+	state->link = (pmsr & MAC_MSR_LINK);
+	state->duplex = (pmsr & MAC_MSR_DPX) >> 1;
 
-		netif_dbg(mac->hw, link, dev, "rx pause %s, tx pause %s\n",
-			  flowctrl & FLOW_CTRL_RX ? "enabled" : "disabled",
-			  flowctrl & FLOW_CTRL_TX ? "enabled" : "disabled");
+	switch (pmsr & (MAC_MSR_SPEED_1000 | MAC_MSR_SPEED_100)) {
+	case 0:
+		state->speed = SPEED_10;
+		break;
+	case MAC_MSR_SPEED_100:
+		state->speed = SPEED_100;
+		break;
+	case MAC_MSR_SPEED_1000:
+		state->speed = SPEED_1000;
+		break;
+	default:
+		state->speed = SPEED_UNKNOWN;
+		break;
 	}
 
-	mtk_w32(mac->hw, mcr, MTK_MAC_MCR(mac->id));
+	state->pause &= (MLO_PAUSE_RX | MLO_PAUSE_TX);
+	if (pmsr & MAC_MSR_RX_FC)
+		state->pause |= MLO_PAUSE_RX;
+	if (pmsr & MAC_MSR_TX_FC)
+		state->pause |= MLO_PAUSE_TX;
 
-	if (!of_phy_is_fixed_link(mac->of_node))
-		phy_print_status(dev->phydev);
+	return 1;
 }
 
-static int mtk_phy_connect_node(struct mtk_eth *eth, struct mtk_mac *mac,
-				struct device_node *phy_node)
+static void mtk_mac_an_restart(struct phylink_config *config)
 {
-	struct phy_device *phydev;
-	int phy_mode;
-
-	phy_mode = of_get_phy_mode(phy_node);
-	if (phy_mode < 0) {
-		dev_err(eth->dev, "incorrect phy-mode %d\n", phy_mode);
-		return -EINVAL;
-	}
-
-	phydev = of_phy_connect(eth->netdev[mac->id], phy_node,
-				mtk_phy_link_adjust, 0, phy_mode);
-	if (!phydev) {
-		dev_err(eth->dev, "could not connect to PHY\n");
-		return -ENODEV;
-	}
+	/* Do nothing */
+}
 
-	dev_info(eth->dev,
-		 "connected mac %d to PHY at %s [uid=%08x, driver=%s]\n",
-		 mac->id, phydev_name(phydev), phydev->phy_id,
-		 phydev->drv->name);
+static void mtk_mac_link_down(struct phylink_config *config, unsigned int mode,
+			      phy_interface_t interface)
+{
+	struct mtk_mac *mac = container_of(config, struct mtk_mac,
+					   phylink_config);
+	u32 mcr = mtk_r32(mac->hw, MTK_MAC_MCR(mac->id));
 
-	return 0;
+	mcr &= ~(MAC_MCR_TX_EN | MAC_MCR_RX_EN);
+	mtk_w32(mac->hw, mcr, MTK_MAC_MCR(mac->id));
 }
 
-static int mtk_phy_connect(struct net_device *dev)
+static void mtk_mac_link_up(struct phylink_config *config, unsigned int mode,
+			    phy_interface_t interface,
+			    struct phy_device *phy)
 {
-	struct mtk_mac *mac = netdev_priv(dev);
-	struct mtk_eth *eth;
-	struct device_node *np;
-	u32 val;
-	int err;
+	struct mtk_mac *mac = container_of(config, struct mtk_mac,
+					   phylink_config);
+	u32 mcr = mtk_r32(mac->hw, MTK_MAC_MCR(mac->id));
 
-	eth = mac->hw;
-	np = of_parse_phandle(mac->of_node, "phy-handle", 0);
-	if (!np && of_phy_is_fixed_link(mac->of_node))
-		if (!of_phy_register_fixed_link(mac->of_node))
-			np = of_node_get(mac->of_node);
-	if (!np)
-		return -ENODEV;
+	mcr |= MAC_MCR_TX_EN | MAC_MCR_RX_EN;
+	mtk_w32(mac->hw, mcr, MTK_MAC_MCR(mac->id));
+}
 
-	err = mtk_setup_hw_path(eth, mac->id, of_get_phy_mode(np));
-	if (err)
-		goto err_phy;
-
-	mac->ge_mode = 0;
-	switch (of_get_phy_mode(np)) {
-	case PHY_INTERFACE_MODE_TRGMII:
-		mac->trgmii = true;
-	case PHY_INTERFACE_MODE_RGMII_TXID:
-	case PHY_INTERFACE_MODE_RGMII_RXID:
-	case PHY_INTERFACE_MODE_RGMII_ID:
-	case PHY_INTERFACE_MODE_RGMII:
-	case PHY_INTERFACE_MODE_SGMII:
-		break;
-	case PHY_INTERFACE_MODE_MII:
-	case PHY_INTERFACE_MODE_GMII:
-		mac->ge_mode = 1;
-		break;
-	case PHY_INTERFACE_MODE_REVMII:
-		mac->ge_mode = 2;
-		break;
-	case PHY_INTERFACE_MODE_RMII:
-		if (!mac->id)
-			goto err_phy;
-		mac->ge_mode = 3;
-		break;
-	default:
-		goto err_phy;
-	}
+static void mtk_validate(struct phylink_config *config,
+			 unsigned long *supported,
+			 struct phylink_link_state *state)
+{
+	struct mtk_mac *mac = container_of(config, struct mtk_mac,
+					   phylink_config);
+	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
 
-	/* No MT7628/88 support for now */
-	if (!MTK_HAS_CAPS(eth->soc->caps, MTK_SOC_MT7628)) {
-		/* put the gmac into the right mode */
-		regmap_read(eth->ethsys, ETHSYS_SYSCFG0, &val);
-		val &= ~SYSCFG0_GE_MODE(SYSCFG0_GE_MASK, mac->id);
-		val |= SYSCFG0_GE_MODE(mac->ge_mode, mac->id);
-		regmap_write(eth->ethsys, ETHSYS_SYSCFG0, val);
+	if (state->interface != PHY_INTERFACE_MODE_NA &&
+	    state->interface != PHY_INTERFACE_MODE_MII &&
+	    state->interface != PHY_INTERFACE_MODE_GMII &&
+	    !(MTK_HAS_CAPS(mac->hw->soc->caps, MTK_RGMII) &&
+	      phy_interface_mode_is_rgmii(state->interface)) &&
+	    !(MTK_HAS_CAPS(mac->hw->soc->caps, MTK_TRGMII) &&
+	      !mac->id && state->interface == PHY_INTERFACE_MODE_TRGMII)) {
+		linkmode_zero(supported);
+		return;
 	}
 
-	/* couple phydev to net_device */
-	if (mtk_phy_connect_node(eth, mac, np))
-		goto err_phy;
+	phylink_set_port_modes(mask);
+	phylink_set(mask, Autoneg);
 
-	of_node_put(np);
+	if (state->interface == PHY_INTERFACE_MODE_TRGMII) {
+		phylink_set(mask, 1000baseT_Full);
+	} else {
+		phylink_set(mask, 10baseT_Half);
+		phylink_set(mask, 10baseT_Full);
+		phylink_set(mask, 100baseT_Half);
+		phylink_set(mask, 100baseT_Full);
+
+		if (state->interface != PHY_INTERFACE_MODE_MII) {
+			phylink_set(mask, 1000baseT_Half);
+			phylink_set(mask, 1000baseT_Full);
+			phylink_set(mask, 1000baseX_Full);
+		}
+	}
 
-	return 0;
+	phylink_set(mask, Pause);
+	phylink_set(mask, Asym_Pause);
 
-err_phy:
-	if (of_phy_is_fixed_link(mac->of_node))
-		of_phy_deregister_fixed_link(mac->of_node);
-	of_node_put(np);
-	dev_err(eth->dev, "%s: invalid phy\n", __func__);
-	return -EINVAL;
+	linkmode_and(supported, supported, mask);
+	linkmode_and(state->advertising, state->advertising, mask);
 }
 
+static const struct phylink_mac_ops mtk_phylink_ops = {
+	.validate = mtk_validate,
+	.mac_link_state = mtk_mac_link_state,
+	.mac_an_restart = mtk_mac_an_restart,
+	.mac_config = mtk_mac_config,
+	.mac_link_down = mtk_mac_link_down,
+	.mac_link_up = mtk_mac_link_up,
+};
+
 static int mtk_mdio_init(struct mtk_eth *eth)
 {
 	struct device_node *mii_np;
@@ -2013,6 +2070,14 @@ static int mtk_open(struct net_device *dev)
 {
 	struct mtk_mac *mac = netdev_priv(dev);
 	struct mtk_eth *eth = mac->hw;
+	int err;
+
+	err = phylink_of_phy_connect(mac->phylink, mac->of_node, 0);
+	if (err) {
+		netdev_err(dev, "%s: could not attach PHY: %d\n", __func__,
+			   err);
+		return err;
+	}
 
 	/* we run 2 netdevs on the same dma ring so we only bring it up once */
 	if (!refcount_read(&eth->dma_refcnt)) {
@@ -2030,7 +2095,7 @@ static int mtk_open(struct net_device *dev)
 	else
 		refcount_inc(&eth->dma_refcnt);
 
-	phy_start(dev->phydev);
+	phylink_start(mac->phylink);
 	netif_start_queue(dev);
 	return 0;
 }
@@ -2063,8 +2128,11 @@ static int mtk_stop(struct net_device *dev)
 	struct mtk_mac *mac = netdev_priv(dev);
 	struct mtk_eth *eth = mac->hw;
 
+	phylink_stop(mac->phylink);
+
 	netif_tx_disable(dev);
-	phy_stop(dev->phydev);
+
+	phylink_disconnect_phy(mac->phylink);
 
 	/* only shutdown DMA if this is the last user */
 	if (!refcount_dec_and_test(&eth->dma_refcnt))
@@ -2159,15 +2227,6 @@ static int mtk_hw_init(struct mtk_eth *eth)
 	ethsys_reset(eth, RSTCTRL_FE);
 	ethsys_reset(eth, RSTCTRL_PPE);
 
-	regmap_read(eth->ethsys, ETHSYS_SYSCFG0, &val);
-	for (i = 0; i < MTK_MAC_COUNT; i++) {
-		if (!eth->mac[i])
-			continue;
-		val &= ~SYSCFG0_GE_MODE(SYSCFG0_GE_MASK, eth->mac[i]->id);
-		val |= SYSCFG0_GE_MODE(eth->mac[i]->ge_mode, eth->mac[i]->id);
-	}
-	regmap_write(eth->ethsys, ETHSYS_SYSCFG0, val);
-
 	if (eth->pctl) {
 		/* Set GE2 driving and slew rate */
 		regmap_write(eth->pctl, GPIO_DRV_SEL10, 0xa00);
@@ -2180,11 +2239,11 @@ static int mtk_hw_init(struct mtk_eth *eth)
 	}
 
 	/* Set linkdown as the default for each GMAC. Its own MCR would be set
-	 * up with the more appropriate value when mtk_phy_link_adjust call is
-	 * being invoked.
+	 * up with the more appropriate value when mtk_mac_config call is being
+	 * invoked.
 	 */
 	for (i = 0; i < MTK_MAC_COUNT; i++)
-		mtk_w32(eth, 0, MTK_MAC_MCR(i));
+		mtk_w32(eth, MAC_MCR_FORCE_LINK_DOWN, MTK_MAC_MCR(i));
 
 	/* Indicates CDM to parse the MTK special tag from CPU
 	 * which also is working out for untag packets.
@@ -2212,7 +2271,7 @@ static int mtk_hw_init(struct mtk_eth *eth)
 	mtk_w32(eth, MTK_RX_DONE_INT, MTK_QDMA_INT_GRP2);
 	mtk_w32(eth, 0x21021000, MTK_FE_INT_GRP);
 
-	for (i = 0; i < 2; i++) {
+	for (i = 0; i < MTK_MAC_COUNT; i++) {
 		u32 val = mtk_r32(eth, MTK_GDMA_FWD_CFG(i));
 
 		/* setup the forward port to send frame to PDMA */
@@ -2264,7 +2323,7 @@ static int __init mtk_init(struct net_device *dev)
 			dev->dev_addr);
 	}
 
-	return mtk_phy_connect(dev);
+	return 0;
 }
 
 static void mtk_uninit(struct net_device *dev)
@@ -2272,20 +2331,20 @@ static void mtk_uninit(struct net_device *dev)
 	struct mtk_mac *mac = netdev_priv(dev);
 	struct mtk_eth *eth = mac->hw;
 
-	phy_disconnect(dev->phydev);
-	if (of_phy_is_fixed_link(mac->of_node))
-		of_phy_deregister_fixed_link(mac->of_node);
+	phylink_disconnect_phy(mac->phylink);
 	mtk_tx_irq_disable(eth, ~0);
 	mtk_rx_irq_disable(eth, ~0);
 }
 
 static int mtk_do_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 {
+	struct mtk_mac *mac = netdev_priv(dev);
+
 	switch (cmd) {
 	case SIOCGMIIPHY:
 	case SIOCGMIIREG:
 	case SIOCSMIIREG:
-		return phy_mii_ioctl(dev->phydev, ifr, cmd);
+		return phylink_mii_ioctl(mac->phylink, ifr, cmd);
 	default:
 		break;
 	}
@@ -2326,16 +2385,6 @@ static void mtk_pending_work(struct work_struct *work)
 				     eth->dev->pins->default_state);
 	mtk_hw_init(eth);
 
-	for (i = 0; i < MTK_MAC_COUNT; i++) {
-		if (!eth->mac[i] ||
-		    of_phy_is_fixed_link(eth->mac[i]->of_node))
-			continue;
-		err = phy_init_hw(eth->netdev[i]->phydev);
-		if (err)
-			dev_err(eth->dev, "%s: PHY init failed.\n",
-				eth->netdev[i]->name);
-	}
-
 	/* restart DMA and enable IRQs */
 	for (i = 0; i < MTK_MAC_COUNT; i++) {
 		if (!test_bit(i, &restart))
@@ -2398,9 +2447,7 @@ static int mtk_get_link_ksettings(struct net_device *ndev,
 	if (unlikely(test_bit(MTK_RESETTING, &mac->hw->state)))
 		return -EBUSY;
 
-	phy_ethtool_ksettings_get(ndev->phydev, cmd);
-
-	return 0;
+	return phylink_ethtool_ksettings_get(mac->phylink, cmd);
 }
 
 static int mtk_set_link_ksettings(struct net_device *ndev,
@@ -2411,7 +2458,7 @@ static int mtk_set_link_ksettings(struct net_device *ndev,
 	if (unlikely(test_bit(MTK_RESETTING, &mac->hw->state)))
 		return -EBUSY;
 
-	return phy_ethtool_ksettings_set(ndev->phydev, cmd);
+	return phylink_ethtool_ksettings_set(mac->phylink, cmd);
 }
 
 static void mtk_get_drvinfo(struct net_device *dev,
@@ -2445,22 +2492,10 @@ static int mtk_nway_reset(struct net_device *dev)
 	if (unlikely(test_bit(MTK_RESETTING, &mac->hw->state)))
 		return -EBUSY;
 
-	return genphy_restart_aneg(dev->phydev);
-}
+	if (!mac->phylink)
+		return -ENOTSUPP;
 
-static u32 mtk_get_link(struct net_device *dev)
-{
-	struct mtk_mac *mac = netdev_priv(dev);
-	int err;
-
-	if (unlikely(test_bit(MTK_RESETTING, &mac->hw->state)))
-		return -EBUSY;
-
-	err = genphy_update_link(dev->phydev);
-	if (err)
-		return ethtool_op_get_link(dev);
-
-	return dev->phydev->link;
+	return phylink_ethtool_nway_reset(mac->phylink);
 }
 
 static void mtk_get_strings(struct net_device *dev, u32 stringset, u8 *data)
@@ -2580,7 +2615,7 @@ static const struct ethtool_ops mtk_ethtool_ops = {
 	.get_msglevel		= mtk_get_msglevel,
 	.set_msglevel		= mtk_set_msglevel,
 	.nway_reset		= mtk_nway_reset,
-	.get_link		= mtk_get_link,
+	.get_link		= ethtool_op_get_link,
 	.get_strings		= mtk_get_strings,
 	.get_sset_count		= mtk_get_sset_count,
 	.get_ethtool_stats	= mtk_get_ethtool_stats,
@@ -2608,9 +2643,10 @@ static const struct net_device_ops mtk_netdev_ops = {
 
 static int mtk_add_mac(struct mtk_eth *eth, struct device_node *np)
 {
-	struct mtk_mac *mac;
 	const __be32 *_id = of_get_property(np, "reg", NULL);
-	int id, err;
+	struct phylink *phylink;
+	int phy_mode, id, err;
+	struct mtk_mac *mac;
 
 	if (!_id) {
 		dev_err(eth->dev, "missing mac id\n");
@@ -2654,6 +2690,32 @@ static int mtk_add_mac(struct mtk_eth *eth, struct device_node *np)
 	u64_stats_init(&mac->hw_stats->syncp);
 	mac->hw_stats->reg_offset = id * MTK_STAT_OFFSET;
 
+	/* phylink create */
+	phy_mode = of_get_phy_mode(np);
+	if (phy_mode < 0) {
+		dev_err(eth->dev, "incorrect phy-mode\n");
+		err = -EINVAL;
+		goto free_netdev;
+	}
+
+	/* mac config is not set */
+	mac->interface = PHY_INTERFACE_MODE_NA;
+	mac->mode = MLO_AN_PHY;
+	mac->speed = SPEED_UNKNOWN;
+
+	mac->phylink_config.dev = &eth->netdev[id]->dev;
+	mac->phylink_config.type = PHYLINK_NETDEV;
+
+	phylink = phylink_create(&mac->phylink_config,
+				 of_fwnode_handle(mac->of_node),
+				 phy_mode, &mtk_phylink_ops);
+	if (IS_ERR(phylink)) {
+		err = PTR_ERR(phylink);
+		goto free_netdev;
+	}
+
+	mac->phylink = phylink;
+
 	SET_NETDEV_DEV(eth->netdev[id], eth->dev);
 	eth->netdev[id]->watchdog_timeo = 5 * HZ;
 	eth->netdev[id]->netdev_ops = &mtk_netdev_ops;
@@ -2682,8 +2744,7 @@ static int mtk_probe(struct platform_device *pdev)
 {
 	struct device_node *mac_np;
 	struct mtk_eth *eth;
-	int err;
-	int i;
+	int err, i;
 
 	eth = devm_kzalloc(&pdev->dev, sizeof(*eth), GFP_KERNEL);
 	if (!eth)
@@ -2869,6 +2930,7 @@ static int mtk_probe(struct platform_device *pdev)
 static int mtk_remove(struct platform_device *pdev)
 {
 	struct mtk_eth *eth = platform_get_drvdata(pdev);
+	struct mtk_mac *mac;
 	int i;
 
 	/* stop all devices to make sure that dma is properly shut down */
@@ -2876,6 +2938,8 @@ static int mtk_remove(struct platform_device *pdev)
 		if (!eth->netdev[i])
 			continue;
 		mtk_stop(eth->netdev[i]);
+		mac = netdev_priv(eth->netdev[i]);
+		phylink_disconnect_phy(mac->phylink);
 	}
 
 	mtk_hw_deinit(eth);
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
index cc1466ae0926..7f5f541daad7 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
@@ -14,6 +14,7 @@
 #include <linux/of_net.h>
 #include <linux/u64_stats_sync.h>
 #include <linux/refcount.h>
+#include <linux/phylink.h>
 
 #define MTK_QDMA_PAGE_SIZE	2048
 #define	MTK_MAX_RX_LENGTH	1536
@@ -330,12 +331,19 @@
 #define MAC_MCR_SPEED_100	BIT(2)
 #define MAC_MCR_FORCE_DPX	BIT(1)
 #define MAC_MCR_FORCE_LINK	BIT(0)
-#define MAC_MCR_FIXED_LINK	(MAC_MCR_MAX_RX_1536 | MAC_MCR_IPG_CFG | \
-				 MAC_MCR_FORCE_MODE | MAC_MCR_TX_EN | \
-				 MAC_MCR_RX_EN | MAC_MCR_BACKOFF_EN | \
-				 MAC_MCR_BACKPR_EN | MAC_MCR_FORCE_RX_FC | \
-				 MAC_MCR_FORCE_TX_FC | MAC_MCR_SPEED_1000 | \
-				 MAC_MCR_FORCE_DPX | MAC_MCR_FORCE_LINK)
+#define MAC_MCR_FORCE_LINK_DOWN	(MAC_MCR_FORCE_MODE)
+
+/* Mac status registers */
+#define MTK_MAC_MSR(x)		(0x10108 + (x * 0x100))
+#define MAC_MSR_EEE1G		BIT(7)
+#define MAC_MSR_EEE100M		BIT(6)
+#define MAC_MSR_RX_FC		BIT(5)
+#define MAC_MSR_TX_FC		BIT(4)
+#define MAC_MSR_SPEED_1000	BIT(3)
+#define MAC_MSR_SPEED_100	BIT(2)
+#define MAC_MSR_SPEED_MASK	(MAC_MSR_SPEED_1000 | MAC_MSR_SPEED_100)
+#define MAC_MSR_DPX		BIT(1)
+#define MAC_MSR_LINK		BIT(0)
 
 /* TRGMII RXC control register */
 #define TRGMII_RCK_CTRL		0x10300
@@ -858,22 +866,23 @@ struct mtk_eth {
 /* struct mtk_mac -	the structure that holds the info about the MACs of the
  *			SoC
  * @id:			The number of the MAC
- * @ge_mode:            Interface mode kept for setup restoring
+ * @interface:		Interface mode kept for detecting change in hw settings
  * @of_node:		Our devicetree node
  * @hw:			Backpointer to our main datastruture
  * @hw_stats:		Packet statistics counter
- * @trgmii		Indicate if the MAC uses TRGMII connected to internal
-			switch
  */
 struct mtk_mac {
 	int				id;
-	int				ge_mode;
+	phy_interface_t			interface;
+	unsigned int			mode;
+	int				speed;
 	struct device_node		*of_node;
+	struct phylink			*phylink;
+	struct phylink_config		phylink_config;
 	struct mtk_eth			*hw;
 	struct mtk_hw_stats		*hw_stats;
 	__be32				hwlro_ip[MTK_MAX_LRO_IP_CNT];
 	int				hwlro_ip_cnt;
-	bool				trgmii;
 };
 
 /* the struct describing the SoC. these are declared in the soc_xyz.c files */
-- 
2.20.1

