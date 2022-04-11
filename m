Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4A484FBA84
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 13:08:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345886AbiDKLK4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 07:10:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345907AbiDKLIu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 07:08:50 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA79F45509
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 04:05:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=4IqIm5BLiOfTKn0c0tan0Ky/e3XtjCJznMB9h2Lcnm0=; b=qPhrAcIFWwNS3UKE6O9kT9EcaC
        HiPVkcDWdeb5ljYOImSWc4FfTQAIcElYzyzMdSgVAnidydb1ivH5jFGslz29GFGb3T7RPhfZ2e1Oc
        BOqx0GxnHBughAn0KWkU/5gJD3VnrmREobFIk4gnoPUURAGc3JXIxtirPYVwuGzux1eCGSgt8B6K6
        bBEHeDsR8XGsUkhSUzSNlKkmEy8rWNkjBjCOttqmVpr/P0Ki6HZUMOfX6S9JQwH0o5QS0XzQpK6pb
        MJlLs0ZKdkh1JPCIagsI3lBrxDMsYQgQHG5nNCIcJU/B7FaRDqzKeb7TKlZvO0xxTO9IxFLkyKX/K
        FD6WV0Ig==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:53092 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1ndrr9-0000QC-Cb; Mon, 11 Apr 2022 12:05:15 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1ndrr8-005FbQ-F7; Mon, 11 Apr 2022 12:05:14 +0100
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH RFC net-next v2] net: dsa: b53: convert to phylink_pcs
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1ndrr8-005FbQ-F7@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Mon, 11 Apr 2022 12:05:14 +0100
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert B53 to use phylink_pcs for the serdes rather than hooking it
into the MAC-layer callbacks.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
v2: fix oops by restructing how we store and retrieve the PCS structure.

 drivers/net/dsa/b53/b53_common.c | 36 +++-------------
 drivers/net/dsa/b53/b53_priv.h   | 24 ++++++-----
 drivers/net/dsa/b53/b53_serdes.c | 74 ++++++++++++++++++++++----------
 drivers/net/dsa/b53/b53_serdes.h |  9 ++--
 drivers/net/dsa/b53/b53_srab.c   |  4 +-
 5 files changed, 75 insertions(+), 72 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 77501f9c5915..fbb32aa49b24 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1354,46 +1354,25 @@ static void b53_phylink_get_caps(struct dsa_switch *ds, int port,
 	config->legacy_pre_march2020 = false;
 }
 
-int b53_phylink_mac_link_state(struct dsa_switch *ds, int port,
-			       struct phylink_link_state *state)
+static struct phylink_pcs *b53_phylink_mac_select_pcs(struct dsa_switch *ds,
+						      int port,
+						      phy_interface_t interface)
 {
 	struct b53_device *dev = ds->priv;
-	int ret = -EOPNOTSUPP;
 
-	if ((phy_interface_mode_is_8023z(state->interface) ||
-	     state->interface == PHY_INTERFACE_MODE_SGMII) &&
-	     dev->ops->serdes_link_state)
-		ret = dev->ops->serdes_link_state(dev, port, state);
+	if (!dev->ops->phylink_mac_select_pcs)
+		return NULL;
 
-	return ret;
+	return dev->ops->phylink_mac_select_pcs(dev, port, interface);
 }
-EXPORT_SYMBOL(b53_phylink_mac_link_state);
 
 void b53_phylink_mac_config(struct dsa_switch *ds, int port,
 			    unsigned int mode,
 			    const struct phylink_link_state *state)
 {
-	struct b53_device *dev = ds->priv;
-
-	if (mode == MLO_AN_PHY || mode == MLO_AN_FIXED)
-		return;
-
-	if ((phy_interface_mode_is_8023z(state->interface) ||
-	     state->interface == PHY_INTERFACE_MODE_SGMII) &&
-	     dev->ops->serdes_config)
-		dev->ops->serdes_config(dev, port, mode, state);
 }
 EXPORT_SYMBOL(b53_phylink_mac_config);
 
-void b53_phylink_mac_an_restart(struct dsa_switch *ds, int port)
-{
-	struct b53_device *dev = ds->priv;
-
-	if (dev->ops->serdes_an_restart)
-		dev->ops->serdes_an_restart(dev, port);
-}
-EXPORT_SYMBOL(b53_phylink_mac_an_restart);
-
 void b53_phylink_mac_link_down(struct dsa_switch *ds, int port,
 			       unsigned int mode,
 			       phy_interface_t interface)
@@ -2269,9 +2248,8 @@ static const struct dsa_switch_ops b53_switch_ops = {
 	.phy_write		= b53_phy_write16,
 	.adjust_link		= b53_adjust_link,
 	.phylink_get_caps	= b53_phylink_get_caps,
-	.phylink_mac_link_state	= b53_phylink_mac_link_state,
+	.phylink_mac_select_pcs	= b53_phylink_mac_select_pcs,
 	.phylink_mac_config	= b53_phylink_mac_config,
-	.phylink_mac_an_restart	= b53_phylink_mac_an_restart,
 	.phylink_mac_link_down	= b53_phylink_mac_link_down,
 	.phylink_mac_link_up	= b53_phylink_mac_link_up,
 	.port_enable		= b53_enable_port,
diff --git a/drivers/net/dsa/b53/b53_priv.h b/drivers/net/dsa/b53/b53_priv.h
index 3085b6cc7d40..795cbffd5c2b 100644
--- a/drivers/net/dsa/b53/b53_priv.h
+++ b/drivers/net/dsa/b53/b53_priv.h
@@ -21,7 +21,7 @@
 
 #include <linux/kernel.h>
 #include <linux/mutex.h>
-#include <linux/phy.h>
+#include <linux/phylink.h>
 #include <linux/etherdevice.h>
 #include <net/dsa.h>
 
@@ -29,7 +29,6 @@
 
 struct b53_device;
 struct net_device;
-struct phylink_link_state;
 
 struct b53_io_ops {
 	int (*read8)(struct b53_device *dev, u8 page, u8 reg, u8 *value);
@@ -48,13 +47,10 @@ struct b53_io_ops {
 	void (*irq_disable)(struct b53_device *dev, int port);
 	void (*phylink_get_caps)(struct b53_device *dev, int port,
 				 struct phylink_config *config);
+	struct phylink_pcs *(*phylink_mac_select_pcs)(struct b53_device *dev,
+						      int port,
+						      phy_interface_t interface);
 	u8 (*serdes_map_lane)(struct b53_device *dev, int port);
-	int (*serdes_link_state)(struct b53_device *dev, int port,
-				 struct phylink_link_state *state);
-	void (*serdes_config)(struct b53_device *dev, int port,
-			      unsigned int mode,
-			      const struct phylink_link_state *state);
-	void (*serdes_an_restart)(struct b53_device *dev, int port);
 	void (*serdes_link_set)(struct b53_device *dev, int port,
 				unsigned int mode, phy_interface_t interface,
 				bool link_up);
@@ -85,8 +81,15 @@ enum {
 	BCM7278_DEVICE_ID = 0x7278,
 };
 
+struct b53_pcs {
+	struct phylink_pcs pcs;
+	struct b53_device *dev;
+	u8 lane;
+};
+
 #define B53_N_PORTS	9
 #define B53_N_PORTS_25	6
+#define B53_N_PCS	2
 
 struct b53_port {
 	u16		vlan_ctl_mask;
@@ -143,6 +146,8 @@ struct b53_device {
 	bool vlan_enabled;
 	unsigned int num_ports;
 	struct b53_port *ports;
+
+	struct b53_pcs pcs[B53_N_PCS];
 };
 
 #define b53_for_each_port(dev, i) \
@@ -336,12 +341,9 @@ int b53_br_flags(struct dsa_switch *ds, int port,
 		 struct netlink_ext_ack *extack);
 int b53_setup_devlink_resources(struct dsa_switch *ds);
 void b53_port_event(struct dsa_switch *ds, int port);
-int b53_phylink_mac_link_state(struct dsa_switch *ds, int port,
-			       struct phylink_link_state *state);
 void b53_phylink_mac_config(struct dsa_switch *ds, int port,
 			    unsigned int mode,
 			    const struct phylink_link_state *state);
-void b53_phylink_mac_an_restart(struct dsa_switch *ds, int port);
 void b53_phylink_mac_link_down(struct dsa_switch *ds, int port,
 			       unsigned int mode,
 			       phy_interface_t interface);
diff --git a/drivers/net/dsa/b53/b53_serdes.c b/drivers/net/dsa/b53/b53_serdes.c
index 555e5b372321..0690210770ff 100644
--- a/drivers/net/dsa/b53/b53_serdes.c
+++ b/drivers/net/dsa/b53/b53_serdes.c
@@ -17,6 +17,11 @@
 #include "b53_serdes.h"
 #include "b53_regs.h"
 
+static inline struct b53_pcs *pcs_to_b53_pcs(struct phylink_pcs *pcs)
+{
+	return container_of(pcs, struct b53_pcs, pcs);
+}
+
 static void b53_serdes_write_blk(struct b53_device *dev, u8 offset, u16 block,
 				 u16 value)
 {
@@ -60,51 +65,47 @@ static u16 b53_serdes_read(struct b53_device *dev, u8 lane,
 	return b53_serdes_read_blk(dev, offset, block);
 }
 
-void b53_serdes_config(struct b53_device *dev, int port, unsigned int mode,
-		       const struct phylink_link_state *state)
+static int b53_serdes_config(struct phylink_pcs *pcs, unsigned int mode,
+			     phy_interface_t interface,
+			     const unsigned long *advertising,
+			     bool permit_pause_to_mac)
 {
-	u8 lane = b53_serdes_map_lane(dev, port);
+	struct b53_device *dev = pcs_to_b53_pcs(pcs)->dev;
+	u8 lane = pcs_to_b53_pcs(pcs)->lane;
 	u16 reg;
 
-	if (lane == B53_INVALID_LANE)
-		return;
-
 	reg = b53_serdes_read(dev, lane, B53_SERDES_DIGITAL_CONTROL(1),
 			      SERDES_DIGITAL_BLK);
-	if (state->interface == PHY_INTERFACE_MODE_1000BASEX)
+	if (interface == PHY_INTERFACE_MODE_1000BASEX)
 		reg |= FIBER_MODE_1000X;
 	else
 		reg &= ~FIBER_MODE_1000X;
 	b53_serdes_write(dev, lane, B53_SERDES_DIGITAL_CONTROL(1),
 			 SERDES_DIGITAL_BLK, reg);
+
+	return 0;
 }
-EXPORT_SYMBOL(b53_serdes_config);
 
-void b53_serdes_an_restart(struct b53_device *dev, int port)
+static void b53_serdes_an_restart(struct phylink_pcs *pcs)
 {
-	u8 lane = b53_serdes_map_lane(dev, port);
+	struct b53_device *dev = pcs_to_b53_pcs(pcs)->dev;
+	u8 lane = pcs_to_b53_pcs(pcs)->lane;
 	u16 reg;
 
-	if (lane == B53_INVALID_LANE)
-		return;
-
 	reg = b53_serdes_read(dev, lane, B53_SERDES_MII_REG(MII_BMCR),
 			      SERDES_MII_BLK);
 	reg |= BMCR_ANRESTART;
 	b53_serdes_write(dev, lane, B53_SERDES_MII_REG(MII_BMCR),
 			 SERDES_MII_BLK, reg);
 }
-EXPORT_SYMBOL(b53_serdes_an_restart);
 
-int b53_serdes_link_state(struct b53_device *dev, int port,
-			  struct phylink_link_state *state)
+static void b53_serdes_get_state(struct phylink_pcs *pcs,
+				  struct phylink_link_state *state)
 {
-	u8 lane = b53_serdes_map_lane(dev, port);
+	struct b53_device *dev = pcs_to_b53_pcs(pcs)->dev;
+	u8 lane = pcs_to_b53_pcs(pcs)->lane;
 	u16 dig, bmsr;
 
-	if (lane == B53_INVALID_LANE)
-		return 1;
-
 	dig = b53_serdes_read(dev, lane, B53_SERDES_DIGITAL_STATUS,
 			      SERDES_DIGITAL_BLK);
 	bmsr = b53_serdes_read(dev, lane, B53_SERDES_MII_REG(MII_BMSR),
@@ -133,10 +134,7 @@ int b53_serdes_link_state(struct b53_device *dev, int port,
 		state->pause |= MLO_PAUSE_RX;
 	if (dig & PAUSE_RESOLUTION_TX_SIDE)
 		state->pause |= MLO_PAUSE_TX;
-
-	return 0;
 }
-EXPORT_SYMBOL(b53_serdes_link_state);
 
 void b53_serdes_link_set(struct b53_device *dev, int port, unsigned int mode,
 			 phy_interface_t interface, bool link_up)
@@ -158,6 +156,12 @@ void b53_serdes_link_set(struct b53_device *dev, int port, unsigned int mode,
 }
 EXPORT_SYMBOL(b53_serdes_link_set);
 
+static const struct phylink_pcs_ops b53_pcs_ops = {
+	.pcs_get_state = b53_serdes_get_state,
+	.pcs_config = b53_serdes_config,
+	.pcs_an_restart = b53_serdes_an_restart,
+};
+
 void b53_serdes_phylink_get_caps(struct b53_device *dev, int port,
 				 struct phylink_config *config)
 {
@@ -187,9 +191,28 @@ void b53_serdes_phylink_get_caps(struct b53_device *dev, int port,
 }
 EXPORT_SYMBOL(b53_serdes_phylink_get_caps);
 
+struct phylink_pcs *b53_serdes_phylink_mac_select_pcs(struct b53_device *dev,
+						      int port,
+						      phy_interface_t interface)
+{
+	u8 lane = b53_serdes_map_lane(dev, port);
+
+	if (lane == B53_INVALID_LANE || lane >= B53_N_PCS ||
+	    !dev->pcs[lane].dev)
+		return NULL;
+
+	if (!phy_interface_mode_is_8023z(interface) &&
+	    interface != PHY_INTERFACE_MODE_SGMII)
+		return NULL;
+
+	return &dev->pcs[lane].pcs;
+}
+EXPORT_SYMBOL(b53_serdes_phylink_mac_select_pcs);
+
 int b53_serdes_init(struct b53_device *dev, int port)
 {
 	u8 lane = b53_serdes_map_lane(dev, port);
+	struct b53_pcs *pcs;
 	u16 id0, msb, lsb;
 
 	if (lane == B53_INVALID_LANE)
@@ -212,6 +235,11 @@ int b53_serdes_init(struct b53_device *dev, int port)
 		 (id0 >> SERDES_ID0_REV_NUM_SHIFT) & SERDES_ID0_REV_NUM_MASK,
 		 (u32)msb << 16 | lsb);
 
+	pcs = &dev->pcs[lane];
+	pcs->dev = dev;
+	pcs->lane = lane;
+	pcs->pcs.ops = &b53_pcs_ops;
+
 	return 0;
 }
 EXPORT_SYMBOL(b53_serdes_init);
diff --git a/drivers/net/dsa/b53/b53_serdes.h b/drivers/net/dsa/b53/b53_serdes.h
index f47d5caa7557..ef81f5da5f81 100644
--- a/drivers/net/dsa/b53/b53_serdes.h
+++ b/drivers/net/dsa/b53/b53_serdes.h
@@ -107,14 +107,11 @@ static inline u8 b53_serdes_map_lane(struct b53_device *dev, int port)
 	return dev->ops->serdes_map_lane(dev, port);
 }
 
-int b53_serdes_get_link(struct b53_device *dev, int port);
-int b53_serdes_link_state(struct b53_device *dev, int port,
-			  struct phylink_link_state *state);
-void b53_serdes_config(struct b53_device *dev, int port, unsigned int mode,
-		       const struct phylink_link_state *state);
-void b53_serdes_an_restart(struct b53_device *dev, int port);
 void b53_serdes_link_set(struct b53_device *dev, int port, unsigned int mode,
 			 phy_interface_t interface, bool link_up);
+struct phylink_pcs *b53_serdes_phylink_mac_select_pcs(struct b53_device *dev,
+						      int port,
+						      phy_interface_t interface);
 void b53_serdes_phylink_get_caps(struct b53_device *dev, int port,
 				 struct phylink_config *config);
 #if IS_ENABLED(CONFIG_B53_SERDES)
diff --git a/drivers/net/dsa/b53/b53_srab.c b/drivers/net/dsa/b53/b53_srab.c
index c51b716657db..da0b889880f6 100644
--- a/drivers/net/dsa/b53/b53_srab.c
+++ b/drivers/net/dsa/b53/b53_srab.c
@@ -491,10 +491,8 @@ static const struct b53_io_ops b53_srab_ops = {
 	.irq_disable = b53_srab_irq_disable,
 	.phylink_get_caps = b53_srab_phylink_get_caps,
 #if IS_ENABLED(CONFIG_B53_SERDES)
+	.phylink_mac_select_pcs = b53_serdes_phylink_mac_select_pcs,
 	.serdes_map_lane = b53_srab_serdes_map_lane,
-	.serdes_link_state = b53_serdes_link_state,
-	.serdes_config = b53_serdes_config,
-	.serdes_an_restart = b53_serdes_an_restart,
 	.serdes_link_set = b53_serdes_link_set,
 #endif
 };
-- 
2.30.2

