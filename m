Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C62B010248D
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 13:36:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727584AbfKSMgv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 07:36:51 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:51018 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725798AbfKSMgv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 07:36:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=M8gT6swEKZXYyMiBzRos3iiJeDwq06EDlB5Vn4maXf0=; b=c1tilOyx+Az6Tp5fixfmnXzWUT
        8JQxK55z60eX3xnSbbK6Pr7WCtSDewVZl/E4TYIL+j3yq+6VGyVLko2TOyxN3+5LhzxCJmf6ZU9us
        UNa2Kn0f+kIPcaN5Wvjv/1K2HQCb9CLwDlD18OF319cnpvRoIntAbbn/1lVmft3uNgdFxRznxLoHU
        2KXIBidEPzwll+2v5ZWaq4x8a7I4xQt3P46aZb76swYmIj6jM05BI2MZTZRL7r4PWcZoP9dqlXKwM
        imrXM+NrwTJg9bLuO58LvKAaIQ/s4oqEeTqaN7kI0fAsdJAFzMwWAZjJnFcf1Ol/EGWXPfaVcMyt8
        LSHBvGUw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([2002:4e20:1eda:1:222:68ff:fe15:37dd]:56898 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1iX2jh-0001Hd-Bu; Tue, 19 Nov 2019 12:36:01 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1iX2jg-0005Us-6U; Tue, 19 Nov 2019 12:36:00 +0000
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sean Wang <sean.wang@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Felix Fietkau <nbd@openwrt.org>,
        John Crispin <john@phrozen.org>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com
Subject: [RFC PATCH net-next] net: phylink: rename mac_link_state() op to
 mac_pcs_get_state()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1iX2jg-0005Us-6U@rmk-PC.armlinux.org.uk>
Date:   Tue, 19 Nov 2019 12:36:00 +0000
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
This is something I'd like to do to make it clearer what phylink expects
of this function, and that it shouldn't just read-back how the MAC was
configured.  However, it will require some testing and review as it
changes quite a lot, and there's some things, particularly in DSA, that
don't seem quite right from a phylink point of view, such as messing
with state->interface in this function.

 drivers/net/dsa/b53/b53_common.c              | 15 ++--
 drivers/net/dsa/b53/b53_priv.h                |  8 +-
 drivers/net/dsa/b53/b53_serdes.c              | 12 +--
 drivers/net/dsa/b53/b53_serdes.h              |  4 +-
 drivers/net/dsa/mt7530.c                      | 16 ++--
 drivers/net/dsa/mv88e6xxx/chip.c              | 75 +++++++++----------
 drivers/net/dsa/mv88e6xxx/chip.h              |  4 +-
 drivers/net/dsa/mv88e6xxx/port.c              | 44 +++++------
 drivers/net/dsa/mv88e6xxx/port.h              | 12 +--
 drivers/net/ethernet/cadence/macb_main.c      |  8 +-
 drivers/net/ethernet/marvell/mvneta.c         |  8 +-
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   | 21 +++---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c   |  8 +-
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |  8 +-
 .../net/ethernet/xilinx/xilinx_axienet_main.c |  8 +-
 drivers/net/phy/phylink.c                     | 15 ++--
 include/linux/phylink.h                       | 23 +++---
 include/net/dsa.h                             |  4 +-
 net/dsa/dsa_priv.h                            |  4 +-
 net/dsa/port.c                                | 18 +++--
 20 files changed, 152 insertions(+), 163 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 36828f210030..63f9abf9c024 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1203,20 +1203,19 @@ void b53_phylink_validate(struct dsa_switch *ds, int port,
 }
 EXPORT_SYMBOL(b53_phylink_validate);
 
-int b53_phylink_mac_link_state(struct dsa_switch *ds, int port,
-			       struct phylink_link_state *state)
+void b53_phylink_mac_pcs_get_state(struct dsa_switch *ds, int port,
+				   struct phylink_link_state *state)
 {
 	struct b53_device *dev = ds->priv;
-	int ret = -EOPNOTSUPP;
 
 	if ((phy_interface_mode_is_8023z(state->interface) ||
 	     state->interface == PHY_INTERFACE_MODE_SGMII) &&
 	     dev->ops->serdes_link_state)
-		ret = dev->ops->serdes_link_state(dev, port, state);
-
-	return ret;
+		dev->ops->serdes_link_state(dev, port, state);
+	else
+		state->link = 0;
 }
-EXPORT_SYMBOL(b53_phylink_mac_link_state);
+EXPORT_SYMBOL(b53_phylink_mac_pcs_get_state);
 
 void b53_phylink_mac_config(struct dsa_switch *ds, int port,
 			    unsigned int mode,
@@ -2026,7 +2025,7 @@ static const struct dsa_switch_ops b53_switch_ops = {
 	.phy_write		= b53_phy_write16,
 	.adjust_link		= b53_adjust_link,
 	.phylink_validate	= b53_phylink_validate,
-	.phylink_mac_link_state	= b53_phylink_mac_link_state,
+	.phylink_mac_pcs_get_state = b53_phylink_mac_pcs_get_state,
 	.phylink_mac_config	= b53_phylink_mac_config,
 	.phylink_mac_an_restart	= b53_phylink_mac_an_restart,
 	.phylink_mac_link_down	= b53_phylink_mac_link_down,
diff --git a/drivers/net/dsa/b53/b53_priv.h b/drivers/net/dsa/b53/b53_priv.h
index 1877acf05081..5c3655a67a87 100644
--- a/drivers/net/dsa/b53/b53_priv.h
+++ b/drivers/net/dsa/b53/b53_priv.h
@@ -47,8 +47,8 @@ struct b53_io_ops {
 	int (*irq_enable)(struct b53_device *dev, int port);
 	void (*irq_disable)(struct b53_device *dev, int port);
 	u8 (*serdes_map_lane)(struct b53_device *dev, int port);
-	int (*serdes_link_state)(struct b53_device *dev, int port,
-				 struct phylink_link_state *state);
+	void (*serdes_link_state)(struct b53_device *dev, int port,
+				  struct phylink_link_state *state);
 	void (*serdes_config)(struct b53_device *dev, int port,
 			      unsigned int mode,
 			      const struct phylink_link_state *state);
@@ -325,8 +325,8 @@ void b53_port_event(struct dsa_switch *ds, int port);
 void b53_phylink_validate(struct dsa_switch *ds, int port,
 			  unsigned long *supported,
 			  struct phylink_link_state *state);
-int b53_phylink_mac_link_state(struct dsa_switch *ds, int port,
-			       struct phylink_link_state *state);
+void b53_phylink_mac_pcs_get_state(struct dsa_switch *ds, int port,
+				   struct phylink_link_state *state);
 void b53_phylink_mac_config(struct dsa_switch *ds, int port,
 			    unsigned int mode,
 			    const struct phylink_link_state *state);
diff --git a/drivers/net/dsa/b53/b53_serdes.c b/drivers/net/dsa/b53/b53_serdes.c
index 629bf14128a2..0bd4b1a0fa19 100644
--- a/drivers/net/dsa/b53/b53_serdes.c
+++ b/drivers/net/dsa/b53/b53_serdes.c
@@ -96,14 +96,16 @@ void b53_serdes_an_restart(struct b53_device *dev, int port)
 }
 EXPORT_SYMBOL(b53_serdes_an_restart);
 
-int b53_serdes_link_state(struct b53_device *dev, int port,
-			  struct phylink_link_state *state)
+void b53_serdes_link_state(struct b53_device *dev, int port,
+			   struct phylink_link_state *state)
 {
 	u8 lane = b53_serdes_map_lane(dev, port);
 	u16 dig, bmsr;
 
-	if (lane == B53_INVALID_LANE)
-		return 1;
+	if (lane == B53_INVALID_LANE) {
+		state->link = 0;
+		return;
+	}
 
 	dig = b53_serdes_read(dev, lane, B53_SERDES_DIGITAL_STATUS,
 			      SERDES_DIGITAL_BLK);
@@ -133,8 +135,6 @@ int b53_serdes_link_state(struct b53_device *dev, int port,
 		state->pause |= MLO_PAUSE_RX;
 	if (dig & PAUSE_RESOLUTION_TX_SIDE)
 		state->pause |= MLO_PAUSE_TX;
-
-	return 0;
 }
 EXPORT_SYMBOL(b53_serdes_link_state);
 
diff --git a/drivers/net/dsa/b53/b53_serdes.h b/drivers/net/dsa/b53/b53_serdes.h
index 55d280fe38e4..f115a492f637 100644
--- a/drivers/net/dsa/b53/b53_serdes.h
+++ b/drivers/net/dsa/b53/b53_serdes.h
@@ -108,8 +108,8 @@ static inline u8 b53_serdes_map_lane(struct b53_device *dev, int port)
 }
 
 int b53_serdes_get_link(struct b53_device *dev, int port);
-int b53_serdes_link_state(struct b53_device *dev, int port,
-			  struct phylink_link_state *state);
+void b53_serdes_link_state(struct b53_device *dev, int port,
+			   struct phylink_link_state *state);
 void b53_serdes_config(struct b53_device *dev, int port, unsigned int mode,
 		       const struct phylink_link_state *state);
 void b53_serdes_an_restart(struct b53_device *dev, int port);
diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index ed1ec10ec62b..0422251ee0bc 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -1550,15 +1550,17 @@ static void mt7530_phylink_validate(struct dsa_switch *ds, int port,
 	linkmode_and(state->advertising, state->advertising, mask);
 }
 
-static int
-mt7530_phylink_mac_link_state(struct dsa_switch *ds, int port,
-			      struct phylink_link_state *state)
+static void
+mt7530_phylink_mac_pcs_get_state(struct dsa_switch *ds, int port,
+				 struct phylink_link_state *state)
 {
 	struct mt7530_priv *priv = ds->priv;
 	u32 pmsr;
 
-	if (port < 0 || port >= MT7530_NUM_PORTS)
-		return -EINVAL;
+	if (port < 0 || port >= MT7530_NUM_PORTS) {
+		state->link = 0;
+		return;
+	}
 
 	pmsr = mt7530_read(priv, MT7530_PMSR_P(port));
 
@@ -1586,8 +1588,6 @@ mt7530_phylink_mac_link_state(struct dsa_switch *ds, int port,
 		state->pause |= MLO_PAUSE_RX;
 	if (pmsr & PMSR_TX_FC)
 		state->pause |= MLO_PAUSE_TX;
-
-	return 1;
 }
 
 static const struct dsa_switch_ops mt7530_switch_ops = {
@@ -1611,7 +1611,7 @@ static const struct dsa_switch_ops mt7530_switch_ops = {
 	.port_vlan_add		= mt7530_port_vlan_add,
 	.port_vlan_del		= mt7530_port_vlan_del,
 	.phylink_validate	= mt7530_phylink_validate,
-	.phylink_mac_link_state = mt7530_phylink_mac_link_state,
+	.phylink_mac_pcs_get_state = mt7530_phylink_mac_pcs_get_state,
 	.phylink_mac_config	= mt7530_phylink_mac_config,
 	.phylink_mac_link_down	= mt7530_phylink_mac_link_down,
 	.phylink_mac_link_up	= mt7530_phylink_mac_link_up,
diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 3bd988529178..5506397053d8 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -404,12 +404,10 @@ int mv88e6xxx_port_setup_mac(struct mv88e6xxx_chip *chip, int port, int link,
 	if (!chip->info->ops->port_set_link)
 		return 0;
 
-	if (!chip->info->ops->port_link_state)
+	if (!chip->info->ops->port_pcs_get_state)
 		return 0;
 
-	err = chip->info->ops->port_link_state(chip, port, &state);
-	if (err)
-		return err;
+	chip->info->ops->port_pcs_get_state(chip, port, &state);
 
 	/* Has anything actually changed? We don't expect the
 	 * interface mode to change without one of the other
@@ -579,20 +577,17 @@ static void mv88e6xxx_validate(struct dsa_switch *ds, int port,
 	phylink_helper_basex_speed(state);
 }
 
-static int mv88e6xxx_link_state(struct dsa_switch *ds, int port,
-				struct phylink_link_state *state)
+static void mv88e6xxx_pcs_get_state(struct dsa_switch *ds, int port,
+				    struct phylink_link_state *state)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
-	int err;
 
 	mv88e6xxx_reg_lock(chip);
-	if (chip->info->ops->port_link_state)
-		err = chip->info->ops->port_link_state(chip, port, state);
+	if (chip->info->ops->port_pcs_get_state)
+		chip->info->ops->port_pcs_get_state(chip, port, state);
 	else
-		err = -EOPNOTSUPP;
+		state->link = 0;
 	mv88e6xxx_reg_unlock(chip);
-
-	return err;
 }
 
 static void mv88e6xxx_mac_config(struct dsa_switch *ds, int port,
@@ -3273,7 +3268,7 @@ static const struct mv88e6xxx_ops mv88e6085_ops = {
 	.port_pause_limit = mv88e6097_port_pause_limit,
 	.port_disable_learn_limit = mv88e6xxx_port_disable_learn_limit,
 	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
-	.port_link_state = mv88e6352_port_link_state,
+	.port_pcs_get_state = mv88e6352_port_pcs_get_state,
 	.port_get_cmode = mv88e6185_port_get_cmode,
 	.port_setup_message_port = mv88e6xxx_setup_message_port,
 	.stats_snapshot = mv88e6xxx_g1_stats_snapshot,
@@ -3308,7 +3303,7 @@ static const struct mv88e6xxx_ops mv88e6095_ops = {
 	.port_set_frame_mode = mv88e6085_port_set_frame_mode,
 	.port_set_egress_floods = mv88e6185_port_set_egress_floods,
 	.port_set_upstream_port = mv88e6095_port_set_upstream_port,
-	.port_link_state = mv88e6185_port_link_state,
+	.port_pcs_get_state = mv88e6185_port_pcs_get_state,
 	.port_get_cmode = mv88e6185_port_get_cmode,
 	.port_setup_message_port = mv88e6xxx_setup_message_port,
 	.stats_snapshot = mv88e6xxx_g1_stats_snapshot,
@@ -3345,7 +3340,7 @@ static const struct mv88e6xxx_ops mv88e6097_ops = {
 	.port_pause_limit = mv88e6097_port_pause_limit,
 	.port_disable_learn_limit = mv88e6xxx_port_disable_learn_limit,
 	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
-	.port_link_state = mv88e6352_port_link_state,
+	.port_pcs_get_state = mv88e6352_port_pcs_get_state,
 	.port_get_cmode = mv88e6185_port_get_cmode,
 	.port_setup_message_port = mv88e6xxx_setup_message_port,
 	.stats_snapshot = mv88e6xxx_g1_stats_snapshot,
@@ -3380,7 +3375,7 @@ static const struct mv88e6xxx_ops mv88e6123_ops = {
 	.port_set_egress_floods = mv88e6352_port_set_egress_floods,
 	.port_disable_learn_limit = mv88e6xxx_port_disable_learn_limit,
 	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
-	.port_link_state = mv88e6352_port_link_state,
+	.port_pcs_get_state = mv88e6352_port_pcs_get_state,
 	.port_get_cmode = mv88e6185_port_get_cmode,
 	.port_setup_message_port = mv88e6xxx_setup_message_port,
 	.stats_snapshot = mv88e6320_g1_stats_snapshot,
@@ -3420,7 +3415,7 @@ static const struct mv88e6xxx_ops mv88e6131_ops = {
 	.port_egress_rate_limiting = mv88e6097_port_egress_rate_limiting,
 	.port_pause_limit = mv88e6097_port_pause_limit,
 	.port_set_pause = mv88e6185_port_set_pause,
-	.port_link_state = mv88e6352_port_link_state,
+	.port_pcs_get_state = mv88e6352_port_pcs_get_state,
 	.port_get_cmode = mv88e6185_port_get_cmode,
 	.port_setup_message_port = mv88e6xxx_setup_message_port,
 	.stats_snapshot = mv88e6xxx_g1_stats_snapshot,
@@ -3465,7 +3460,7 @@ static const struct mv88e6xxx_ops mv88e6141_ops = {
 	.port_pause_limit = mv88e6097_port_pause_limit,
 	.port_disable_learn_limit = mv88e6xxx_port_disable_learn_limit,
 	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
-	.port_link_state = mv88e6352_port_link_state,
+	.port_pcs_get_state = mv88e6352_port_pcs_get_state,
 	.port_get_cmode = mv88e6352_port_get_cmode,
 	.port_set_cmode = mv88e6341_port_set_cmode,
 	.port_setup_message_port = mv88e6xxx_setup_message_port,
@@ -3511,7 +3506,7 @@ static const struct mv88e6xxx_ops mv88e6161_ops = {
 	.port_pause_limit = mv88e6097_port_pause_limit,
 	.port_disable_learn_limit = mv88e6xxx_port_disable_learn_limit,
 	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
-	.port_link_state = mv88e6352_port_link_state,
+	.port_pcs_get_state = mv88e6352_port_pcs_get_state,
 	.port_get_cmode = mv88e6185_port_get_cmode,
 	.port_setup_message_port = mv88e6xxx_setup_message_port,
 	.stats_snapshot = mv88e6xxx_g1_stats_snapshot,
@@ -3547,7 +3542,7 @@ static const struct mv88e6xxx_ops mv88e6165_ops = {
 	.port_set_speed = mv88e6185_port_set_speed,
 	.port_disable_learn_limit = mv88e6xxx_port_disable_learn_limit,
 	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
-	.port_link_state = mv88e6352_port_link_state,
+	.port_pcs_get_state = mv88e6352_port_pcs_get_state,
 	.port_get_cmode = mv88e6185_port_get_cmode,
 	.port_setup_message_port = mv88e6xxx_setup_message_port,
 	.stats_snapshot = mv88e6xxx_g1_stats_snapshot,
@@ -3591,7 +3586,7 @@ static const struct mv88e6xxx_ops mv88e6171_ops = {
 	.port_pause_limit = mv88e6097_port_pause_limit,
 	.port_disable_learn_limit = mv88e6xxx_port_disable_learn_limit,
 	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
-	.port_link_state = mv88e6352_port_link_state,
+	.port_pcs_get_state = mv88e6352_port_pcs_get_state,
 	.port_get_cmode = mv88e6352_port_get_cmode,
 	.port_setup_message_port = mv88e6xxx_setup_message_port,
 	.stats_snapshot = mv88e6320_g1_stats_snapshot,
@@ -3636,7 +3631,7 @@ static const struct mv88e6xxx_ops mv88e6172_ops = {
 	.port_pause_limit = mv88e6097_port_pause_limit,
 	.port_disable_learn_limit = mv88e6xxx_port_disable_learn_limit,
 	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
-	.port_link_state = mv88e6352_port_link_state,
+	.port_pcs_get_state = mv88e6352_port_pcs_get_state,
 	.port_get_cmode = mv88e6352_port_get_cmode,
 	.port_setup_message_port = mv88e6xxx_setup_message_port,
 	.stats_snapshot = mv88e6320_g1_stats_snapshot,
@@ -3682,7 +3677,7 @@ static const struct mv88e6xxx_ops mv88e6175_ops = {
 	.port_pause_limit = mv88e6097_port_pause_limit,
 	.port_disable_learn_limit = mv88e6xxx_port_disable_learn_limit,
 	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
-	.port_link_state = mv88e6352_port_link_state,
+	.port_pcs_get_state = mv88e6352_port_pcs_get_state,
 	.port_get_cmode = mv88e6352_port_get_cmode,
 	.port_setup_message_port = mv88e6xxx_setup_message_port,
 	.stats_snapshot = mv88e6320_g1_stats_snapshot,
@@ -3727,7 +3722,7 @@ static const struct mv88e6xxx_ops mv88e6176_ops = {
 	.port_pause_limit = mv88e6097_port_pause_limit,
 	.port_disable_learn_limit = mv88e6xxx_port_disable_learn_limit,
 	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
-	.port_link_state = mv88e6352_port_link_state,
+	.port_pcs_get_state = mv88e6352_port_pcs_get_state,
 	.port_get_cmode = mv88e6352_port_get_cmode,
 	.port_setup_message_port = mv88e6xxx_setup_message_port,
 	.stats_snapshot = mv88e6320_g1_stats_snapshot,
@@ -3770,7 +3765,7 @@ static const struct mv88e6xxx_ops mv88e6185_ops = {
 	.port_egress_rate_limiting = mv88e6095_port_egress_rate_limiting,
 	.port_set_upstream_port = mv88e6095_port_set_upstream_port,
 	.port_set_pause = mv88e6185_port_set_pause,
-	.port_link_state = mv88e6185_port_link_state,
+	.port_pcs_get_state = mv88e6185_port_pcs_get_state,
 	.port_get_cmode = mv88e6185_port_get_cmode,
 	.port_setup_message_port = mv88e6xxx_setup_message_port,
 	.stats_snapshot = mv88e6xxx_g1_stats_snapshot,
@@ -3813,7 +3808,7 @@ static const struct mv88e6xxx_ops mv88e6190_ops = {
 	.port_pause_limit = mv88e6390_port_pause_limit,
 	.port_disable_learn_limit = mv88e6xxx_port_disable_learn_limit,
 	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
-	.port_link_state = mv88e6352_port_link_state,
+	.port_pcs_get_state = mv88e6352_port_pcs_get_state,
 	.port_get_cmode = mv88e6352_port_get_cmode,
 	.port_set_cmode = mv88e6390_port_set_cmode,
 	.port_setup_message_port = mv88e6xxx_setup_message_port,
@@ -3864,7 +3859,7 @@ static const struct mv88e6xxx_ops mv88e6190x_ops = {
 	.port_pause_limit = mv88e6390_port_pause_limit,
 	.port_disable_learn_limit = mv88e6xxx_port_disable_learn_limit,
 	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
-	.port_link_state = mv88e6352_port_link_state,
+	.port_pcs_get_state = mv88e6352_port_pcs_get_state,
 	.port_get_cmode = mv88e6352_port_get_cmode,
 	.port_set_cmode = mv88e6390x_port_set_cmode,
 	.port_setup_message_port = mv88e6xxx_setup_message_port,
@@ -3914,7 +3909,7 @@ static const struct mv88e6xxx_ops mv88e6191_ops = {
 	.port_pause_limit = mv88e6390_port_pause_limit,
 	.port_disable_learn_limit = mv88e6xxx_port_disable_learn_limit,
 	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
-	.port_link_state = mv88e6352_port_link_state,
+	.port_pcs_get_state = mv88e6352_port_pcs_get_state,
 	.port_get_cmode = mv88e6352_port_get_cmode,
 	.port_set_cmode = mv88e6390_port_set_cmode,
 	.port_setup_message_port = mv88e6xxx_setup_message_port,
@@ -3968,7 +3963,7 @@ static const struct mv88e6xxx_ops mv88e6240_ops = {
 	.port_pause_limit = mv88e6097_port_pause_limit,
 	.port_disable_learn_limit = mv88e6xxx_port_disable_learn_limit,
 	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
-	.port_link_state = mv88e6352_port_link_state,
+	.port_pcs_get_state = mv88e6352_port_pcs_get_state,
 	.port_get_cmode = mv88e6352_port_get_cmode,
 	.port_setup_message_port = mv88e6xxx_setup_message_port,
 	.stats_snapshot = mv88e6320_g1_stats_snapshot,
@@ -4019,7 +4014,7 @@ static const struct mv88e6xxx_ops mv88e6250_ops = {
 	.port_egress_rate_limiting = mv88e6097_port_egress_rate_limiting,
 	.port_pause_limit = mv88e6097_port_pause_limit,
 	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
-	.port_link_state = mv88e6250_port_link_state,
+	.port_pcs_get_state = mv88e6250_port_pcs_get_state,
 	.stats_snapshot = mv88e6320_g1_stats_snapshot,
 	.stats_set_histogram = mv88e6095_g1_stats_set_histogram,
 	.stats_get_sset_count = mv88e6250_stats_get_sset_count,
@@ -4060,7 +4055,7 @@ static const struct mv88e6xxx_ops mv88e6290_ops = {
 	.port_pause_limit = mv88e6390_port_pause_limit,
 	.port_disable_learn_limit = mv88e6xxx_port_disable_learn_limit,
 	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
-	.port_link_state = mv88e6352_port_link_state,
+	.port_pcs_get_state = mv88e6352_port_pcs_get_state,
 	.port_get_cmode = mv88e6352_port_get_cmode,
 	.port_set_cmode = mv88e6390_port_set_cmode,
 	.port_setup_message_port = mv88e6xxx_setup_message_port,
@@ -4113,7 +4108,7 @@ static const struct mv88e6xxx_ops mv88e6320_ops = {
 	.port_pause_limit = mv88e6097_port_pause_limit,
 	.port_disable_learn_limit = mv88e6xxx_port_disable_learn_limit,
 	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
-	.port_link_state = mv88e6352_port_link_state,
+	.port_pcs_get_state = mv88e6352_port_pcs_get_state,
 	.port_get_cmode = mv88e6352_port_get_cmode,
 	.port_setup_message_port = mv88e6xxx_setup_message_port,
 	.stats_snapshot = mv88e6320_g1_stats_snapshot,
@@ -4157,7 +4152,7 @@ static const struct mv88e6xxx_ops mv88e6321_ops = {
 	.port_pause_limit = mv88e6097_port_pause_limit,
 	.port_disable_learn_limit = mv88e6xxx_port_disable_learn_limit,
 	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
-	.port_link_state = mv88e6352_port_link_state,
+	.port_pcs_get_state = mv88e6352_port_pcs_get_state,
 	.port_get_cmode = mv88e6352_port_get_cmode,
 	.port_setup_message_port = mv88e6xxx_setup_message_port,
 	.stats_snapshot = mv88e6320_g1_stats_snapshot,
@@ -4201,7 +4196,7 @@ static const struct mv88e6xxx_ops mv88e6341_ops = {
 	.port_pause_limit = mv88e6097_port_pause_limit,
 	.port_disable_learn_limit = mv88e6xxx_port_disable_learn_limit,
 	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
-	.port_link_state = mv88e6352_port_link_state,
+	.port_pcs_get_state = mv88e6352_port_pcs_get_state,
 	.port_get_cmode = mv88e6352_port_get_cmode,
 	.port_set_cmode = mv88e6341_port_set_cmode,
 	.port_setup_message_port = mv88e6xxx_setup_message_port,
@@ -4250,7 +4245,7 @@ static const struct mv88e6xxx_ops mv88e6350_ops = {
 	.port_pause_limit = mv88e6097_port_pause_limit,
 	.port_disable_learn_limit = mv88e6xxx_port_disable_learn_limit,
 	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
-	.port_link_state = mv88e6352_port_link_state,
+	.port_pcs_get_state = mv88e6352_port_pcs_get_state,
 	.port_get_cmode = mv88e6352_port_get_cmode,
 	.port_setup_message_port = mv88e6xxx_setup_message_port,
 	.stats_snapshot = mv88e6320_g1_stats_snapshot,
@@ -4292,7 +4287,7 @@ static const struct mv88e6xxx_ops mv88e6351_ops = {
 	.port_pause_limit = mv88e6097_port_pause_limit,
 	.port_disable_learn_limit = mv88e6xxx_port_disable_learn_limit,
 	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
-	.port_link_state = mv88e6352_port_link_state,
+	.port_pcs_get_state = mv88e6352_port_pcs_get_state,
 	.port_get_cmode = mv88e6352_port_get_cmode,
 	.port_setup_message_port = mv88e6xxx_setup_message_port,
 	.stats_snapshot = mv88e6320_g1_stats_snapshot,
@@ -4339,7 +4334,7 @@ static const struct mv88e6xxx_ops mv88e6352_ops = {
 	.port_pause_limit = mv88e6097_port_pause_limit,
 	.port_disable_learn_limit = mv88e6xxx_port_disable_learn_limit,
 	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
-	.port_link_state = mv88e6352_port_link_state,
+	.port_pcs_get_state = mv88e6352_port_pcs_get_state,
 	.port_get_cmode = mv88e6352_port_get_cmode,
 	.port_setup_message_port = mv88e6xxx_setup_message_port,
 	.stats_snapshot = mv88e6320_g1_stats_snapshot,
@@ -4396,7 +4391,7 @@ static const struct mv88e6xxx_ops mv88e6390_ops = {
 	.port_pause_limit = mv88e6390_port_pause_limit,
 	.port_disable_learn_limit = mv88e6xxx_port_disable_learn_limit,
 	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
-	.port_link_state = mv88e6352_port_link_state,
+	.port_pcs_get_state = mv88e6352_port_pcs_get_state,
 	.port_get_cmode = mv88e6352_port_get_cmode,
 	.port_set_cmode = mv88e6390_port_set_cmode,
 	.port_setup_message_port = mv88e6xxx_setup_message_port,
@@ -4451,7 +4446,7 @@ static const struct mv88e6xxx_ops mv88e6390x_ops = {
 	.port_pause_limit = mv88e6390_port_pause_limit,
 	.port_disable_learn_limit = mv88e6xxx_port_disable_learn_limit,
 	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
-	.port_link_state = mv88e6352_port_link_state,
+	.port_pcs_get_state = mv88e6352_port_pcs_get_state,
 	.port_get_cmode = mv88e6352_port_get_cmode,
 	.port_set_cmode = mv88e6390x_port_set_cmode,
 	.port_setup_message_port = mv88e6xxx_setup_message_port,
@@ -5345,7 +5340,7 @@ static const struct dsa_switch_ops mv88e6xxx_switch_ops = {
 	.setup			= mv88e6xxx_setup,
 	.teardown		= mv88e6xxx_teardown,
 	.phylink_validate	= mv88e6xxx_validate,
-	.phylink_mac_link_state	= mv88e6xxx_link_state,
+	.phylink_mac_pcs_get_state = mv88e6xxx_pcs_get_state,
 	.phylink_mac_config	= mv88e6xxx_mac_config,
 	.phylink_mac_link_down	= mv88e6xxx_mac_link_down,
 	.phylink_mac_link_up	= mv88e6xxx_mac_link_up,
diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index 8a8e38bfb161..09c0c89d1763 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -457,8 +457,8 @@ struct mv88e6xxx_ops {
 	int (*port_set_upstream_port)(struct mv88e6xxx_chip *chip, int port,
 				      int upstream_port);
 	/* Return the port link state, as required by phylink */
-	int (*port_link_state)(struct mv88e6xxx_chip *chip, int port,
-			       struct phylink_link_state *state);
+	void (*port_pcs_get_state)(struct mv88e6xxx_chip *chip, int port,
+				   struct phylink_link_state *state);
 
 	/* Snapshot the statistics for a port. The statistics can then
 	 * be read back a leisure but still with a consistent view.
diff --git a/drivers/net/dsa/mv88e6xxx/port.c b/drivers/net/dsa/mv88e6xxx/port.c
index 7fe256c5739d..eeb58bb38039 100644
--- a/drivers/net/dsa/mv88e6xxx/port.c
+++ b/drivers/net/dsa/mv88e6xxx/port.c
@@ -586,15 +586,17 @@ int mv88e6352_port_get_cmode(struct mv88e6xxx_chip *chip, int port, u8 *cmode)
 	return 0;
 }
 
-int mv88e6250_port_link_state(struct mv88e6xxx_chip *chip, int port,
-			      struct phylink_link_state *state)
+void mv88e6250_port_pcs_get_state(struct mv88e6xxx_chip *chip, int port,
+				  struct phylink_link_state *state)
 {
 	int err;
 	u16 reg;
 
 	err = mv88e6xxx_port_read(chip, port, MV88E6XXX_PORT_STS, &reg);
-	if (err)
-		return err;
+	if (err) {
+		state->link = 0;
+		return;
+	}
 
 	if (port < 5) {
 		switch (reg & MV88E6250_PORT_STS_PORTMODE_MASK) {
@@ -648,12 +650,10 @@ int mv88e6250_port_link_state(struct mv88e6xxx_chip *chip, int port,
 	state->an_enabled = 1;
 	state->an_complete = state->link;
 	state->interface = PHY_INTERFACE_MODE_NA;
-
-	return 0;
 }
 
-int mv88e6352_port_link_state(struct mv88e6xxx_chip *chip, int port,
-			      struct phylink_link_state *state)
+void mv88e6352_port_pcs_get_state(struct mv88e6xxx_chip *chip, int port,
+				  struct phylink_link_state *state)
 {
 	int err;
 	u16 reg;
@@ -662,8 +662,10 @@ int mv88e6352_port_link_state(struct mv88e6xxx_chip *chip, int port,
 	case MV88E6XXX_PORT_STS_CMODE_RGMII:
 		err = mv88e6xxx_port_read(chip, port, MV88E6XXX_PORT_MAC_CTL,
 					  &reg);
-		if (err)
-			return err;
+		if (err) {
+			state->link = 0;
+			return;
+		}
 
 		if ((reg & MV88E6XXX_PORT_MAC_CTL_RGMII_DELAY_RXCLK) &&
 		    (reg & MV88E6XXX_PORT_MAC_CTL_RGMII_DELAY_TXCLK))
@@ -696,8 +698,10 @@ int mv88e6352_port_link_state(struct mv88e6xxx_chip *chip, int port,
 	}
 
 	err = mv88e6xxx_port_read(chip, port, MV88E6XXX_PORT_STS, &reg);
-	if (err)
-		return err;
+	if (err) {
+		state->link = 0;
+		return;
+	}
 
 	switch (reg & MV88E6XXX_PORT_STS_SPEED_MASK) {
 	case MV88E6XXX_PORT_STS_SPEED_10:
@@ -723,12 +727,10 @@ int mv88e6352_port_link_state(struct mv88e6xxx_chip *chip, int port,
 	state->link = !!(reg & MV88E6XXX_PORT_STS_LINK);
 	state->an_enabled = 1;
 	state->an_complete = state->link;
-
-	return 0;
 }
 
-int mv88e6185_port_link_state(struct mv88e6xxx_chip *chip, int port,
-			      struct phylink_link_state *state)
+void mv88e6185_port_pcs_get_state(struct mv88e6xxx_chip *chip, int port,
+				  struct phylink_link_state *state)
 {
 	if (state->interface == PHY_INTERFACE_MODE_1000BASEX) {
 		u8 cmode = chip->ports[port].cmode;
@@ -744,8 +746,10 @@ int mv88e6185_port_link_state(struct mv88e6xxx_chip *chip, int port,
 
 			err = mv88e6xxx_port_read(chip, port,
 						  MV88E6XXX_PORT_MAC_CTL, &mac);
-			if (err)
-				return err;
+			if (err) {
+				state->link = 0;
+				return;
+			}
 
 			state->link = !!(mac & MV88E6185_PORT_MAC_CTL_SYNC_OK);
 			state->an_enabled = 1;
@@ -755,12 +759,10 @@ int mv88e6185_port_link_state(struct mv88e6xxx_chip *chip, int port,
 				state->link ? DUPLEX_FULL : DUPLEX_UNKNOWN;
 			state->speed =
 				state->link ? SPEED_1000 : SPEED_UNKNOWN;
-
-			return 0;
 		}
 	}
 
-	return mv88e6352_port_link_state(chip, port, state);
+	mv88e6352_port_pcs_get_state(chip, port, state);
 }
 
 /* Offset 0x02: Jamming Control
diff --git a/drivers/net/dsa/mv88e6xxx/port.h b/drivers/net/dsa/mv88e6xxx/port.h
index 0ec4327c2b42..18b5dba67343 100644
--- a/drivers/net/dsa/mv88e6xxx/port.h
+++ b/drivers/net/dsa/mv88e6xxx/port.h
@@ -359,12 +359,12 @@ int mv88e6390x_port_set_cmode(struct mv88e6xxx_chip *chip, int port,
 			      phy_interface_t mode);
 int mv88e6185_port_get_cmode(struct mv88e6xxx_chip *chip, int port, u8 *cmode);
 int mv88e6352_port_get_cmode(struct mv88e6xxx_chip *chip, int port, u8 *cmode);
-int mv88e6185_port_link_state(struct mv88e6xxx_chip *chip, int port,
-			      struct phylink_link_state *state);
-int mv88e6250_port_link_state(struct mv88e6xxx_chip *chip, int port,
-			      struct phylink_link_state *state);
-int mv88e6352_port_link_state(struct mv88e6xxx_chip *chip, int port,
-			      struct phylink_link_state *state);
+void mv88e6185_port_pcs_get_state(struct mv88e6xxx_chip *chip, int port,
+				  struct phylink_link_state *state);
+void mv88e6250_port_pcs_get_state(struct mv88e6xxx_chip *chip, int port,
+				  struct phylink_link_state *state);
+void mv88e6352_port_pcs_get_state(struct mv88e6xxx_chip *chip, int port,
+				  struct phylink_link_state *state);
 int mv88e6xxx_port_set_map_da(struct mv88e6xxx_chip *chip, int port);
 int mv88e6095_port_set_upstream_port(struct mv88e6xxx_chip *chip, int port,
 				     int upstream_port);
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
index 300ecdb6790a..efe129b695f1 100644
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
diff --git a/include/net/dsa.h b/include/net/dsa.h
index 6767dc3f66c0..3f2bb4ab1326 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -404,8 +404,8 @@ struct dsa_switch_ops {
 	void	(*phylink_validate)(struct dsa_switch *ds, int port,
 				    unsigned long *supported,
 				    struct phylink_link_state *state);
-	int	(*phylink_mac_link_state)(struct dsa_switch *ds, int port,
-					  struct phylink_link_state *state);
+	void	(*phylink_mac_pcs_get_state)(struct dsa_switch *ds, int port,
+					     struct phylink_link_state *state);
 	void	(*phylink_mac_config)(struct dsa_switch *ds, int port,
 				      unsigned int mode,
 				      const struct phylink_link_state *state);
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 53e7577896b6..0a7e943aee35 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -153,8 +153,8 @@ void dsa_port_link_unregister_of(struct dsa_port *dp);
 void dsa_port_phylink_validate(struct phylink_config *config,
 			       unsigned long *supported,
 			       struct phylink_link_state *state);
-int dsa_port_phylink_mac_link_state(struct phylink_config *config,
-				    struct phylink_link_state *state);
+void dsa_port_phylink_mac_pcs_get_state(struct phylink_config *config,
+				       struct phylink_link_state *state);
 void dsa_port_phylink_mac_config(struct phylink_config *config,
 				 unsigned int mode,
 				 const struct phylink_link_state *state);
diff --git a/net/dsa/port.c b/net/dsa/port.c
index 6e93c36bf0c0..081b141b5159 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -429,19 +429,21 @@ void dsa_port_phylink_validate(struct phylink_config *config,
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
+	if (!ds->ops->phylink_mac_pcs_get_state) {
+		state->link = 0;
+		return;
+	}
 
-	return ds->ops->phylink_mac_link_state(ds, dp->index, state);
+	ds->ops->phylink_mac_pcs_get_state(ds, dp->index, state);
 }
-EXPORT_SYMBOL_GPL(dsa_port_phylink_mac_link_state);
+EXPORT_SYMBOL_GPL(dsa_port_phylink_mac_pcs_get_state);
 
 void dsa_port_phylink_mac_config(struct phylink_config *config,
 				 unsigned int mode,
@@ -510,7 +512,7 @@ EXPORT_SYMBOL_GPL(dsa_port_phylink_mac_link_up);
 
 const struct phylink_mac_ops dsa_port_phylink_mac_ops = {
 	.validate = dsa_port_phylink_validate,
-	.mac_link_state = dsa_port_phylink_mac_link_state,
+	.mac_pcs_get_state = dsa_port_phylink_mac_pcs_get_state,
 	.mac_config = dsa_port_phylink_mac_config,
 	.mac_an_restart = dsa_port_phylink_mac_an_restart,
 	.mac_link_down = dsa_port_phylink_mac_link_down,
-- 
2.20.1

