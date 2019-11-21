Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20A8F1047A8
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 01:37:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726739AbfKUAg6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 19:36:58 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:48262 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726705AbfKUAg6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 19:36:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=MqrgQd4gZiQA1QOypKq4fdlLToRQmCYhgKQfQwMt0Bo=; b=dBNkGK2u7drdKb8KPEBPJzSUzj
        xvfulMhw7oZDOiP9lsY1sPHFK8VJOWpHoudcu3Tt+XvzGvFY4JfeQHY8R9Arc8D/Ukfn5aSGf8o5g
        HcORfnH/s6nOsnJ6ndBi2p9TTKy2FqCwm7RSl96zvHUaiGaNLdOWcK/0r5qsHAy7Ca638sIrP40Ds
        0jRKRv6577XTjrQN+ijC5cr+Pbq4E7uhMOUl561QGt9fsCJwd7PcIqY14Ak4lb6IKRtFJ5ICpEd6C
        8qbgr/Wy59KG9j1D+6SM6/KJUvGFfexkzkhr0pnyJYv3n7PYldHs7hvo05JoIMbabEIKktb9+Tp8i
        cN5ILoVA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:51956 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1iXaSN-0003Aa-21; Thu, 21 Nov 2019 00:36:23 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1iXaSM-0004t1-9L; Thu, 21 Nov 2019 00:36:22 +0000
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Nicolas Ferre <nicolas.ferre@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Felix Fietkau <nbd@openwrt.org>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com
Subject: [CFT PATCH net-next v2] net: phylink: rename mac_link_state() op to
 mac_pcs_get_state()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1iXaSM-0004t1-9L@rmk-PC.armlinux.org.uk>
Date:   Thu, 21 Nov 2019 00:36:22 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rename the mac_link_state() method to mac_pcs_get_state() to make it
clear that it should be returning the MACs PCS current state, which
is used for inband negotiation rather than just reading back what the
MAC has been configured for. Update the documentation to explicitly
mention that this is for inband.

We drop the return value as well; most of phylink doesn't check the
return value and it is not clear what it should do on error - instead
arrange for state->link to be false.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
This is something I'd like to do to make it clearer what phylink
expects of this function, and that it shouldn't just read-back how
the MAC was configured.

This version drops the deeper changes, concentrating just on the
phylink API rather than delving deeper into drivers, as I haven't
received any feedback on that patch.

It would be nice to see all these drivers tested with this change.

 drivers/net/ethernet/cadence/macb_main.c      |  8 +++---
 drivers/net/ethernet/marvell/mvneta.c         |  8 +++---
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   | 21 ++++++++--------
 drivers/net/ethernet/mediatek/mtk_eth_soc.c   |  8 +++---
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |  8 +++---
 .../net/ethernet/xilinx/xilinx_axienet_main.c |  8 +++---
 drivers/net/phy/phylink.c                     | 15 +++++------
 include/linux/phylink.h                       | 25 ++++++++++---------
 net/dsa/dsa_priv.h                            |  4 +--
 net/dsa/port.c                                | 19 ++++++++------
 10 files changed, 59 insertions(+), 65 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 8fc2e21f0bb1..d5ae2e1e0b0e 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -505,10 +505,10 @@ static void macb_validate(struct phylink_config *config,
 		   __ETHTOOL_LINK_MODE_MASK_NBITS);
 }
 
-static int macb_mac_link_state(struct phylink_config *config,
-			       struct phylink_link_state *state)
+static void macb_mac_pcs_get_state(struct phylink_config *config,
+				   struct phylink_link_state *state)
 {
-	return -EOPNOTSUPP;
+	state->link = 0;
 }
 
 static void macb_mac_an_restart(struct phylink_config *config)
@@ -604,7 +604,7 @@ static void macb_mac_link_up(struct phylink_config *config, unsigned int mode,
 
 static const struct phylink_mac_ops macb_phylink_ops = {
 	.validate = macb_validate,
-	.mac_link_state = macb_mac_link_state,
+	.mac_pcs_get_state = macb_mac_pcs_get_state,
 	.mac_an_restart = macb_mac_an_restart,
 	.mac_config = macb_mac_config,
 	.mac_link_down = macb_mac_link_down,
diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 12e03b15f0ab..6ea65cd30da6 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -3688,8 +3688,8 @@ static void mvneta_validate(struct phylink_config *config,
 	phylink_helper_basex_speed(state);
 }
 
-static int mvneta_mac_link_state(struct phylink_config *config,
-				 struct phylink_link_state *state)
+static void mvneta_mac_pcs_get_state(struct phylink_config *config,
+				     struct phylink_link_state *state)
 {
 	struct net_device *ndev = to_net_dev(config->dev);
 	struct mvneta_port *pp = netdev_priv(ndev);
@@ -3715,8 +3715,6 @@ static int mvneta_mac_link_state(struct phylink_config *config,
 		state->pause |= MLO_PAUSE_RX;
 	if (gmac_stat & MVNETA_GMAC_TX_FLOW_CTRL_ENABLE)
 		state->pause |= MLO_PAUSE_TX;
-
-	return 1;
 }
 
 static void mvneta_mac_an_restart(struct phylink_config *config)
@@ -3909,7 +3907,7 @@ static void mvneta_mac_link_up(struct phylink_config *config, unsigned int mode,
 
 static const struct phylink_mac_ops mvneta_phylink_ops = {
 	.validate = mvneta_validate,
-	.mac_link_state = mvneta_mac_link_state,
+	.mac_pcs_get_state = mvneta_mac_pcs_get_state,
 	.mac_an_restart = mvneta_mac_an_restart,
 	.mac_config = mvneta_mac_config,
 	.mac_link_down = mvneta_mac_link_down,
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 17e24c1e1c2b..62dc2f362a16 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -4823,8 +4823,8 @@ static void mvpp2_phylink_validate(struct phylink_config *config,
 	bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
 }
 
-static void mvpp22_xlg_link_state(struct mvpp2_port *port,
-				  struct phylink_link_state *state)
+static void mvpp22_xlg_pcs_get_state(struct mvpp2_port *port,
+				     struct phylink_link_state *state)
 {
 	u32 val;
 
@@ -4843,8 +4843,8 @@ static void mvpp22_xlg_link_state(struct mvpp2_port *port,
 		state->pause |= MLO_PAUSE_RX;
 }
 
-static void mvpp2_gmac_link_state(struct mvpp2_port *port,
-				  struct phylink_link_state *state)
+static void mvpp2_gmac_pcs_get_state(struct mvpp2_port *port,
+				     struct phylink_link_state *state)
 {
 	u32 val;
 
@@ -4877,8 +4877,8 @@ static void mvpp2_gmac_link_state(struct mvpp2_port *port,
 		state->pause |= MLO_PAUSE_TX;
 }
 
-static int mvpp2_phylink_mac_link_state(struct phylink_config *config,
-					struct phylink_link_state *state)
+static void mvpp2_phylink_mac_pcs_get_state(struct phylink_config *config,
+					    struct phylink_link_state *state)
 {
 	struct mvpp2_port *port = container_of(config, struct mvpp2_port,
 					       phylink_config);
@@ -4888,13 +4888,12 @@ static int mvpp2_phylink_mac_link_state(struct phylink_config *config,
 		mode &= MVPP22_XLG_CTRL3_MACMODESELECT_MASK;
 
 		if (mode == MVPP22_XLG_CTRL3_MACMODESELECT_10G) {
-			mvpp22_xlg_link_state(port, state);
-			return 1;
+			mvpp22_xlg_pcs_get_state(port, state);
+			return;
 		}
 	}
 
-	mvpp2_gmac_link_state(port, state);
-	return 1;
+	mvpp2_gmac_pcs_get_state(port, state);
 }
 
 static void mvpp2_mac_an_restart(struct phylink_config *config)
@@ -5186,7 +5185,7 @@ static void mvpp2_mac_link_down(struct phylink_config *config,
 
 static const struct phylink_mac_ops mvpp2_phylink_ops = {
 	.validate = mvpp2_phylink_validate,
-	.mac_link_state = mvpp2_phylink_mac_link_state,
+	.mac_pcs_get_state = mvpp2_phylink_mac_pcs_get_state,
 	.mac_an_restart = mvpp2_mac_an_restart,
 	.mac_config = mvpp2_mac_config,
 	.mac_link_up = mvpp2_mac_link_up,
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 1923ba76a1ec..527ad2aadcca 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -361,8 +361,8 @@ static void mtk_mac_config(struct phylink_config *config, unsigned int mode,
 		mac->id, phy_modes(state->interface), err);
 }
 
-static int mtk_mac_link_state(struct phylink_config *config,
-			      struct phylink_link_state *state)
+static void mtk_mac_pcs_get_state(struct phylink_config *config,
+				  struct phylink_link_state *state)
 {
 	struct mtk_mac *mac = container_of(config, struct mtk_mac,
 					   phylink_config);
@@ -391,8 +391,6 @@ static int mtk_mac_link_state(struct phylink_config *config,
 		state->pause |= MLO_PAUSE_RX;
 	if (pmsr & MAC_MSR_TX_FC)
 		state->pause |= MLO_PAUSE_TX;
-
-	return 1;
 }
 
 static void mtk_mac_an_restart(struct phylink_config *config)
@@ -514,7 +512,7 @@ static void mtk_validate(struct phylink_config *config,
 
 static const struct phylink_mac_ops mtk_phylink_ops = {
 	.validate = mtk_validate,
-	.mac_link_state = mtk_mac_link_state,
+	.mac_pcs_get_state = mtk_mac_pcs_get_state,
 	.mac_an_restart = mtk_mac_an_restart,
 	.mac_config = mtk_mac_config,
 	.mac_link_down = mtk_mac_link_down,
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 8cc4cd0cc515..644cb5d1fd4f 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -868,10 +868,10 @@ static void stmmac_validate(struct phylink_config *config,
 		      __ETHTOOL_LINK_MODE_MASK_NBITS);
 }
 
-static int stmmac_mac_link_state(struct phylink_config *config,
-				 struct phylink_link_state *state)
+static void stmmac_mac_pcs_get_state(struct phylink_config *config,
+				     struct phylink_link_state *state)
 {
-	return -EOPNOTSUPP;
+	state->link = 0;
 }
 
 static void stmmac_mac_config(struct phylink_config *config, unsigned int mode,
@@ -965,7 +965,7 @@ static void stmmac_mac_link_up(struct phylink_config *config,
 
 static const struct phylink_mac_ops stmmac_phylink_mac_ops = {
 	.validate = stmmac_validate,
-	.mac_link_state = stmmac_mac_link_state,
+	.mac_pcs_get_state = stmmac_mac_pcs_get_state,
 	.mac_config = stmmac_mac_config,
 	.mac_an_restart = stmmac_mac_an_restart,
 	.mac_link_down = stmmac_mac_link_down,
diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 8f32db6d2c45..20746b801959 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -1405,8 +1405,8 @@ static void axienet_validate(struct phylink_config *config,
 		   __ETHTOOL_LINK_MODE_MASK_NBITS);
 }
 
-static int axienet_mac_link_state(struct phylink_config *config,
-				  struct phylink_link_state *state)
+static void axienet_mac_pcs_get_state(struct phylink_config *config,
+				      struct phylink_link_state *state)
 {
 	struct net_device *ndev = to_net_dev(config->dev);
 	struct axienet_local *lp = netdev_priv(ndev);
@@ -1431,8 +1431,6 @@ static int axienet_mac_link_state(struct phylink_config *config,
 
 	state->an_complete = 0;
 	state->duplex = 1;
-
-	return 1;
 }
 
 static void axienet_mac_an_restart(struct phylink_config *config)
@@ -1497,7 +1495,7 @@ static void axienet_mac_link_up(struct phylink_config *config,
 
 static const struct phylink_mac_ops axienet_phylink_ops = {
 	.validate = axienet_validate,
-	.mac_link_state = axienet_mac_link_state,
+	.mac_pcs_get_state = axienet_mac_pcs_get_state,
 	.mac_an_restart = axienet_mac_an_restart,
 	.mac_config = axienet_mac_config,
 	.mac_link_down = axienet_mac_link_down,
diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 6ce2e6c63e75..3a886d106069 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -357,9 +357,9 @@ static void phylink_mac_an_restart(struct phylink *pl)
 		pl->ops->mac_an_restart(pl->config);
 }
 
-static int phylink_get_mac_state(struct phylink *pl, struct phylink_link_state *state)
+static void phylink_mac_pcs_get_state(struct phylink *pl,
+				      struct phylink_link_state *state)
 {
-
 	linkmode_copy(state->advertising, pl->link_config.advertising);
 	linkmode_zero(state->lp_advertising);
 	state->interface = pl->link_config.interface;
@@ -370,7 +370,7 @@ static int phylink_get_mac_state(struct phylink *pl, struct phylink_link_state *
 	state->an_complete = 0;
 	state->link = 1;
 
-	return pl->ops->mac_link_state(pl->config, state);
+	pl->ops->mac_pcs_get_state(pl->config, state);
 }
 
 /* The fixed state is... fixed except for the link state,
@@ -493,7 +493,7 @@ static void phylink_resolve(struct work_struct *w)
 			break;
 
 		case MLO_AN_INBAND:
-			phylink_get_mac_state(pl, &link_state);
+			phylink_mac_pcs_get_state(pl, &link_state);
 
 			/* If we have a phy, the "up" state is the union of
 			 * both the PHY and the MAC */
@@ -1138,7 +1138,7 @@ int phylink_ethtool_ksettings_get(struct phylink *pl,
 		if (pl->phydev)
 			break;
 
-		phylink_get_mac_state(pl, &link_state);
+		phylink_mac_pcs_get_state(pl, &link_state);
 
 		/* The MAC is reporting the link results from its own PCS
 		 * layer via in-band status. Report these as the current
@@ -1550,10 +1550,7 @@ static int phylink_mii_read(struct phylink *pl, unsigned int phy_id,
 
 	case MLO_AN_INBAND:
 		if (phy_id == 0) {
-			val = phylink_get_mac_state(pl, &state);
-			if (val < 0)
-				return val;
-
+			phylink_mac_pcs_get_state(pl, &state);
 			val = phylink_mii_emul_read(reg, &state);
 		}
 		break;
diff --git a/include/linux/phylink.h b/include/linux/phylink.h
index 300ecdb6790a..fed5488e3c75 100644
--- a/include/linux/phylink.h
+++ b/include/linux/phylink.h
@@ -72,7 +72,7 @@ struct phylink_config {
 /**
  * struct phylink_mac_ops - MAC operations structure.
  * @validate: Validate and update the link configuration.
- * @mac_link_state: Read the current link state from the hardware.
+ * @mac_pcs_get_state: Read the current link state from the hardware.
  * @mac_config: configure the MAC for the selected mode and state.
  * @mac_an_restart: restart 802.3z BaseX autonegotiation.
  * @mac_link_down: take the link down.
@@ -84,8 +84,8 @@ struct phylink_mac_ops {
 	void (*validate)(struct phylink_config *config,
 			 unsigned long *supported,
 			 struct phylink_link_state *state);
-	int (*mac_link_state)(struct phylink_config *config,
-			      struct phylink_link_state *state);
+	void (*mac_pcs_get_state)(struct phylink_config *config,
+				  struct phylink_link_state *state);
 	void (*mac_config)(struct phylink_config *config, unsigned int mode,
 			   const struct phylink_link_state *state);
 	void (*mac_an_restart)(struct phylink_config *config);
@@ -127,18 +127,19 @@ void validate(struct phylink_config *config, unsigned long *supported,
 	      struct phylink_link_state *state);
 
 /**
- * mac_link_state() - Read the current link state from the hardware
+ * mac_pcs_get_state() - Read the current inband link state from the hardware
  * @config: a pointer to a &struct phylink_config.
  * @state: a pointer to a &struct phylink_link_state.
  *
- * Read the current link state from the MAC, reporting the current
- * speed in @state->speed, duplex mode in @state->duplex, pause mode
- * in @state->pause using the %MLO_PAUSE_RX and %MLO_PAUSE_TX bits,
- * negotiation completion state in @state->an_complete, and link
- * up state in @state->link.
+ * Read the current inband link state from the MAC PCS, reporting the
+ * current speed in @state->speed, duplex mode in @state->duplex, pause
+ * mode in @state->pause using the %MLO_PAUSE_RX and %MLO_PAUSE_TX bits,
+ * negotiation completion state in @state->an_complete, and link up state
+ * in @state->link. If possible, @state->lp_advertising should also be
+ * populated.
  */
-int mac_link_state(struct phylink_config *config,
-		   struct phylink_link_state *state);
+void mac_pcs_get_state(struct phylink_config *config,
+		       struct phylink_link_state *state);
 
 /**
  * mac_config() - configure the MAC for the selected mode and state
@@ -166,7 +167,7 @@ int mac_link_state(struct phylink_config *config,
  *   1000base-X or Cisco SGMII mode depending on the @state->interface
  *   mode). In both cases, link state management (whether the link
  *   is up or not) is performed by the MAC, and reported via the
- *   mac_link_state() callback. Changes in link state must be made
+ *   mac_pcs_get_state() callback. Changes in link state must be made
  *   by calling phylink_mac_change().
  *
  *   If in 802.3z mode, the link speed is fixed, dependent on the
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 53e7577896b6..2dd86d9bcda9 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -153,8 +153,8 @@ void dsa_port_link_unregister_of(struct dsa_port *dp);
 void dsa_port_phylink_validate(struct phylink_config *config,
 			       unsigned long *supported,
 			       struct phylink_link_state *state);
-int dsa_port_phylink_mac_link_state(struct phylink_config *config,
-				    struct phylink_link_state *state);
+void dsa_port_phylink_mac_pcs_get_state(struct phylink_config *config,
+					struct phylink_link_state *state);
 void dsa_port_phylink_mac_config(struct phylink_config *config,
 				 unsigned int mode,
 				 const struct phylink_link_state *state);
diff --git a/net/dsa/port.c b/net/dsa/port.c
index 6e93c36bf0c0..46ac9ba21987 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -429,19 +429,22 @@ void dsa_port_phylink_validate(struct phylink_config *config,
 }
 EXPORT_SYMBOL_GPL(dsa_port_phylink_validate);
 
-int dsa_port_phylink_mac_link_state(struct phylink_config *config,
-				    struct phylink_link_state *state)
+void dsa_port_phylink_mac_pcs_get_state(struct phylink_config *config,
+					struct phylink_link_state *state)
 {
 	struct dsa_port *dp = container_of(config, struct dsa_port, pl_config);
 	struct dsa_switch *ds = dp->ds;
 
-	/* Only called for SGMII and 802.3z */
-	if (!ds->ops->phylink_mac_link_state)
-		return -EOPNOTSUPP;
+	/* Only called for inband modes */
+	if (!ds->ops->phylink_mac_link_state) {
+		state->link = 0;
+		return;
+	}
 
-	return ds->ops->phylink_mac_link_state(ds, dp->index, state);
+	if (ds->ops->phylink_mac_link_state(ds, dp->index, state) < 0)
+		state->link = 0;
 }
-EXPORT_SYMBOL_GPL(dsa_port_phylink_mac_link_state);
+EXPORT_SYMBOL_GPL(dsa_port_phylink_mac_pcs_get_state);
 
 void dsa_port_phylink_mac_config(struct phylink_config *config,
 				 unsigned int mode,
@@ -510,7 +513,7 @@ EXPORT_SYMBOL_GPL(dsa_port_phylink_mac_link_up);
 
 const struct phylink_mac_ops dsa_port_phylink_mac_ops = {
 	.validate = dsa_port_phylink_validate,
-	.mac_link_state = dsa_port_phylink_mac_link_state,
+	.mac_pcs_get_state = dsa_port_phylink_mac_pcs_get_state,
 	.mac_config = dsa_port_phylink_mac_config,
 	.mac_an_restart = dsa_port_phylink_mac_an_restart,
 	.mac_link_down = dsa_port_phylink_mac_link_down,
-- 
2.20.1

