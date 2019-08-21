Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A59F97D80
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 16:46:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729603AbfHUOqB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 10:46:01 -0400
Received: from mx.0dd.nl ([5.2.79.48]:54162 "EHLO mx.0dd.nl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729373AbfHUOp6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Aug 2019 10:45:58 -0400
Received: from mail.vdorst.com (mail.vdorst.com [IPv6:fd01::250])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.0dd.nl (Postfix) with ESMTPS id BC2825FD0B;
        Wed, 21 Aug 2019 16:45:55 +0200 (CEST)
Authentication-Results: mx.0dd.nl;
        dkim=pass (2048-bit key) header.d=vdorst.com header.i=@vdorst.com header.b="jbFZtfn6";
        dkim-atps=neutral
Received: from pc-rene.vdorst.com (pc-rene.vdorst.com [192.168.2.125])
        by mail.vdorst.com (Postfix) with ESMTPA id 7921B1D8290D;
        Wed, 21 Aug 2019 16:45:55 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.vdorst.com 7921B1D8290D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vdorst.com;
        s=default; t=1566398755;
        bh=WjUyhkkSc41bkCYdBLB91qBDwA9xAXIqXJgZXuc+Epw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jbFZtfn6t2ZyT5/2lEJHtblbfdsCfNPF0xcmvhRW+ozQk5e/ORSSKR0O6CQXq2Rvv
         DO9TDvJii9OHjkAOuSd19EDVkTjVX6MO24uiBbQrFeY+2tVmX/PsFQwmPqfw6HfNI8
         79TpYQphQg1GJmRGFUcxDuHuL7ewP8NLPlCofqMJRSIU3AXbL47a11vzehWEdcl+eS
         FGcVRiGqQoU88fN7fTUoLlRT39cIB8c71B1a45mUgiC/cmRVd8cL9ZmPt2I8iU1Q+Z
         eUwpshnQJMqBiKU0GR4I2pqvdNUmOL6CmZA1VNel2iH+P0dJXDJAi8z8EgYVfARrgE
         oh2bkl5tScZjA==
From:   =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>
To:     Sean Wang <sean.wang@mediatek.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>
Cc:     netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        John Crispin <john@phrozen.org>, linux-mips@vger.kernel.org,
        Frank Wunderlich <frank-w@public-files.de>,
        =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>
Subject: [PATCH net-next v2 1/3] net: dsa: mt7530: Convert to PHYLINK API
Date:   Wed, 21 Aug 2019 16:45:45 +0200
Message-Id: <20190821144547.15113-2-opensource@vdorst.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190821144547.15113-1-opensource@vdorst.com>
References: <20190821144547.15113-1-opensource@vdorst.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert mt7530 to PHYLINK API

Signed-off-by: René van Dorst <opensource@vdorst.com>

v1->v2:
* Refactor "unsupported" phy_interface part in
  mt7530_phylink_mac_validate() suggested by Russell King
* Report and return when phylink tries to use autoneg_inband in
  mt7530_phylink_mac_config() suggested by Russell King
* Refactor port 6 setup in mt7530_phylink_mac_config()
rfc->v1:
* Renamed P5_MODE_* to P5_INTF_SEL_*. fits the function more
* Convert if-statement for speed bits to a switch suggested by
  Daniel Santos
* Refactor flow_control pause bits and don't use state->link in
  mt7530_phylink_mac_config() suggested by Russell King
* Move MAC tx/rx en/disable to mt7530_phylink_mac_link_up/down()
  suggested by Russell King
* Always support PHY_INTERFACE_MODE_NA in mt7530_phylink_validate()
  suggested by Russell King
* Added phylink_set_port_modes() in mt7530_phylink_validate() suggested
  by Russell King
* Remove dev_err on the end of mt7530_phylink_mac_config() suggested by
  Russell King
---
 drivers/net/dsa/mt7530.c | 266 +++++++++++++++++++++++++++++----------
 drivers/net/dsa/mt7530.h |  32 +++--
 2 files changed, 211 insertions(+), 87 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index c48e29486b10..ecc13b57e619 100644
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
@@ -698,9 +641,6 @@ mt7530_cpu_port_enable(struct mt7530_priv *priv,
 	mt7530_write(priv, MT7530_PVC_P(port),
 		     PORT_SPEC_TAG);
 
-	/* Setup the MAC by default for the cpu port */
-	mt7530_write(priv, MT7530_PMCR_P(port), PMCR_CPUP_LINK);
-
 	/* Disable auto learning on the cpu port */
 	mt7530_set(priv, MT7530_PSC_P(port), SA_DIS);
 
@@ -731,9 +671,6 @@ mt7530_port_enable(struct dsa_switch *ds, int port,
 
 	mutex_lock(&priv->reg_mutex);
 
-	/* Setup the MAC for the user port */
-	mt7530_write(priv, MT7530_PMCR_P(port), PMCR_USERP_LINK);
-
 	/* Allow the user port gets connected to the cpu port and also
 	 * restore the port matrix if the port is the member of a certain
 	 * bridge.
@@ -742,7 +679,7 @@ mt7530_port_enable(struct dsa_switch *ds, int port,
 	priv->ports[port].enable = true;
 	mt7530_rmw(priv, MT7530_PCR_P(port), PCR_MATRIX_MASK,
 		   priv->ports[port].pm);
-	mt7530_port_set_status(priv, port, 1);
+	mt7530_port_set_status(priv, port, 0);
 
 	mutex_unlock(&priv->reg_mutex);
 
@@ -1232,10 +1169,10 @@ static int
 mt7530_setup(struct dsa_switch *ds)
 {
 	struct mt7530_priv *priv = ds->priv;
-	int ret, i;
-	u32 id, val;
-	struct device_node *dn;
 	struct mt7530_dummy_poll p;
+	struct device_node *dn;
+	u32 id, val;
+	int ret, i;
 
 	/* The parent node of master netdev which holds the common system
 	 * controller also is the container for two GMACs nodes representing
@@ -1305,6 +1242,8 @@ mt7530_setup(struct dsa_switch *ds)
 	val |= MHWTRAP_MANUAL;
 	mt7530_write(priv, MT7530_MHWTRAP, val);
 
+	priv->p6_interface = PHY_INTERFACE_MODE_NA;
+
 	/* Enable and reset MIB counters */
 	mt7530_mib_reset(ds);
 
@@ -1329,6 +1268,191 @@ mt7530_setup(struct dsa_switch *ds)
 	return 0;
 }
 
+static void mt7530_phylink_mac_config(struct dsa_switch *ds, int port,
+				      unsigned int mode,
+				      const struct phylink_link_state *state)
+{
+	struct mt7530_priv *priv = ds->priv;
+	u32 mcr_cur, mcr_new;
+
+	switch (port) {
+	case 0: /* Internal phy */
+	case 1:
+	case 2:
+	case 3:
+	case 4:
+		if (state->interface != PHY_INTERFACE_MODE_GMII)
+			return;
+		break;
+	/* case 5: Port 5 is not supported! */
+	case 6: /* 1st cpu port */
+		if (priv->p6_interface == state->interface)
+			break;
+
+		if (state->interface != PHY_INTERFACE_MODE_RGMII &&
+		    state->interface != PHY_INTERFACE_MODE_TRGMII)
+			return;
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
+
+		priv->p6_interface = state->interface;
+		break;
+	default:
+		dev_err(ds->dev, "%s: unsupported port: %i\n", __func__, port);
+		return;
+	}
+
+	if (phylink_autoneg_inband(mode)) {
+		dev_err(ds->dev, "%s: in-band negotiation unsupported\n",
+			__func__);
+		return;
+	}
+
+	mcr_cur = mt7530_read(priv, MT7530_PMCR_P(port));
+	mcr_new = mcr_cur;
+	mcr_new &= ~(PMCR_FORCE_SPEED_1000 | PMCR_FORCE_SPEED_100 |
+		     PMCR_FORCE_FDX | PMCR_TX_FC_EN | PMCR_RX_FC_EN);
+	mcr_new |= PMCR_IFG_XMIT(1) | PMCR_MAC_MODE | PMCR_BACKOFF_EN |
+		   PMCR_BACKPR_EN | PMCR_FORCE_MODE | PMCR_FORCE_LNK;
+
+	switch (state->speed) {
+	case SPEED_1000:
+		mcr_new |= PMCR_FORCE_SPEED_1000;
+		break;
+	case SPEED_100:
+		mcr_new |= PMCR_FORCE_SPEED_100;
+		break;
+	}
+	if (state->duplex == DUPLEX_FULL) {
+		mcr_new |= PMCR_FORCE_FDX;
+		if (state->pause & MLO_PAUSE_TX)
+			mcr_new |= PMCR_TX_FC_EN;
+		if (state->pause & MLO_PAUSE_RX)
+			mcr_new |= PMCR_RX_FC_EN;
+	}
+
+	if (mcr_new != mcr_cur)
+		mt7530_write(priv, MT7530_PMCR_P(port), mcr_new);
+}
+
+static void mt7530_phylink_mac_link_down(struct dsa_switch *ds, int port,
+					 unsigned int mode,
+					 phy_interface_t interface)
+{
+	struct mt7530_priv *priv = ds->priv;
+
+	mt7530_port_set_status(priv, port, 0);
+}
+
+static void mt7530_phylink_mac_link_up(struct dsa_switch *ds, int port,
+				       unsigned int mode,
+				       phy_interface_t interface,
+				       struct phy_device *phydev)
+{
+	struct mt7530_priv *priv = ds->priv;
+
+	mt7530_port_set_status(priv, port, 1);
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
+		if (state->interface != PHY_INTERFACE_MODE_NA &&
+		    state->interface != PHY_INTERFACE_MODE_RGMII &&
+		    state->interface != PHY_INTERFACE_MODE_TRGMII)
+			goto unsupported;
+		break;
+	default:
+		dev_err(ds->dev, "%s: unsupported port: %i\n", __func__, port);
+unsupported:
+		linkmode_zero(supported);
+		return;
+	}
+
+	phylink_set_port_modes(mask);
+	phylink_set(mask, Autoneg);
+
+	if (state->interface != PHY_INTERFACE_MODE_TRGMII) {
+		phylink_set(mask, 10baseT_Half);
+		phylink_set(mask, 10baseT_Full);
+		phylink_set(mask, 100baseT_Half);
+		phylink_set(mask, 100baseT_Full);
+		phylink_set(mask, 1000baseT_Half);
+	}
+
+	phylink_set(mask, 1000baseT_Full);
+
+	phylink_set(mask, Pause);
+	phylink_set(mask, Asym_Pause);
+
+	linkmode_and(supported, supported, mask);
+	linkmode_and(state->advertising, state->advertising, mask);
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
+	state->duplex = !!(pmsr & PMSR_DPX);
+
+	switch (pmsr & PMSR_SPEED_MASK) {
+	case PMSR_SPEED_10:
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
+	state->pause &= ~(MLO_PAUSE_RX | MLO_PAUSE_TX);
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
@@ -1337,7 +1461,6 @@ static const struct dsa_switch_ops mt7530_switch_ops = {
 	.phy_write		= mt7530_phy_write,
 	.get_ethtool_stats	= mt7530_get_ethtool_stats,
 	.get_sset_count		= mt7530_get_sset_count,
-	.adjust_link		= mt7530_adjust_link,
 	.port_enable		= mt7530_port_enable,
 	.port_disable		= mt7530_port_disable,
 	.port_stp_state_set	= mt7530_stp_state_set,
@@ -1350,6 +1473,11 @@ static const struct dsa_switch_ops mt7530_switch_ops = {
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
index bfac90f48102..107dd04acede 100644
--- a/drivers/net/dsa/mt7530.h
+++ b/drivers/net/dsa/mt7530.h
@@ -198,26 +198,20 @@ enum mt7530_vlan_port_attr {
 #define  PMCR_FORCE_SPEED_100		BIT(2)
 #define  PMCR_FORCE_FDX			BIT(1)
 #define  PMCR_FORCE_LNK			BIT(0)
-#define  PMCR_COMMON_LINK		(PMCR_IFG_XMIT(1) | PMCR_MAC_MODE | \
-					 PMCR_BACKOFF_EN | PMCR_BACKPR_EN | \
-					 PMCR_TX_EN | PMCR_RX_EN | \
-					 PMCR_TX_FC_EN | PMCR_RX_FC_EN)
-#define  PMCR_CPUP_LINK			(PMCR_COMMON_LINK | PMCR_FORCE_MODE | \
-					 PMCR_FORCE_SPEED_1000 | \
-					 PMCR_FORCE_FDX | \
-					 PMCR_FORCE_LNK)
-#define  PMCR_USERP_LINK		PMCR_COMMON_LINK
-#define  PMCR_FIXED_LINK		(PMCR_IFG_XMIT(1) | PMCR_MAC_MODE | \
-					 PMCR_FORCE_MODE | PMCR_TX_EN | \
-					 PMCR_RX_EN | PMCR_BACKPR_EN | \
-					 PMCR_BACKOFF_EN | \
-					 PMCR_FORCE_SPEED_1000 | \
-					 PMCR_FORCE_FDX | \
-					 PMCR_FORCE_LNK)
-#define PMCR_FIXED_LINK_FC		(PMCR_FIXED_LINK | \
-					 PMCR_TX_FC_EN | PMCR_RX_FC_EN)
+#define  PMCR_SPEED_MASK		(PMCR_FORCE_SPEED_100 | \
+					 PMCR_FORCE_SPEED_1000)
 
 #define MT7530_PMSR_P(x)		(0x3008 + (x) * 0x100)
+#define  PMSR_EEE1G			BIT(7)
+#define  PMSR_EEE100M			BIT(6)
+#define  PMSR_RX_FC			BIT(5)
+#define  PMSR_TX_FC			BIT(4)
+#define  PMSR_SPEED_1000		BIT(3)
+#define  PMSR_SPEED_100			BIT(2)
+#define  PMSR_SPEED_10			0x00
+#define  PMSR_SPEED_MASK		(PMSR_SPEED_100 | PMSR_SPEED_1000)
+#define  PMSR_DPX			BIT(1)
+#define  PMSR_LINK			BIT(0)
 
 /* Register for MIB */
 #define MT7530_PORT_MIB_COUNTER(x)	(0x4000 + (x) * 0x100)
@@ -423,6 +417,7 @@ struct mt7530_port {
  * @ports:		Holding the state among ports
  * @reg_mutex:		The lock for protecting among process accessing
  *			registers
+ * @p6_interface	Holding the current port 6 interface
  */
 struct mt7530_priv {
 	struct device		*dev;
@@ -435,6 +430,7 @@ struct mt7530_priv {
 	struct gpio_desc	*reset;
 	unsigned int		id;
 	bool			mcm;
+	phy_interface_t		p6_interface;
 
 	struct mt7530_port	ports[MT7530_NUM_PORTS];
 	/* protect among processes for registers access*/
-- 
2.20.1

