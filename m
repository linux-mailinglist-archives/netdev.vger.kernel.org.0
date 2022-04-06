Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 050EE4F6598
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 18:43:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237638AbiDFQjX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 12:39:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237768AbiDFQhS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 12:37:18 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C3B029D5D3
        for <netdev@vger.kernel.org>; Wed,  6 Apr 2022 08:06:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=5KEm/YgzdAl4uM2Jxgx7t2r/IkdPshlk/rRSY/mNI5A=; b=Xe3Ngj++DDnSKr99tAVY7pPsfa
        BWPIYf78pFe7jBH2PGgDa8FlX6fGgDavdEgtynne6dxFsFlW6WFHhiTNbwIRG+HBdodUUocwTPyzT
        PzJvEqcI4KuEqN1VDJXX/6hvAFROrzD6R2Ah53mUJkFfsACHzBUSpljDSEtvFO6fjvr9+7cxSMjYb
        w0tuEEjDJI4FDTdu/dcZLbkqgJiidj/p4K6NP5VxWby1bFUEy0JuoVo8y0w0Mb4wxpVyg9jtii4eN
        Hh264IuFlBWcQxEbvynuQxdxYLiWFvQoyWGdwVX71tOUlDtiUZgdsi5pmCrMrqyTJXiqM+hJ2xKFb
        oIGV0cAQ==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:60784 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1nc7F7-00030N-85; Wed, 06 Apr 2022 16:06:44 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1nc7F6-004lEo-Be; Wed, 06 Apr 2022 16:06:44 +0100
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: [PATCH RFC net-next] net: dsa: b53: convert to phylink_pcs
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1nc7F6-004lEo-Be@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Wed, 06 Apr 2022 16:06:44 +0100
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
Hi Florian,

Please can you test this patch? Thanks.

 drivers/net/dsa/b53/b53_common.c | 38 ++++++-----------------
 drivers/net/dsa/b53/b53_priv.h   | 24 ++++++++-------
 drivers/net/dsa/b53/b53_serdes.c | 52 +++++++++++++++++++++-----------
 drivers/net/dsa/b53/b53_serdes.h |  6 ----
 drivers/net/dsa/b53/b53_srab.c   |  3 --
 5 files changed, 57 insertions(+), 66 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 77501f9c5915..9c7abe4ee51a 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1354,46 +1354,27 @@ static void b53_phylink_get_caps(struct dsa_switch *ds, int port,
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
+	if (dev->ports[port].pcs.pcs.ops &&
+	    (phy_interface_mode_is_8023z(interface) ||
+	     interface == PHY_INTERFACE_MODE_SGMII))
+		return &dev->ports[port].pcs.pcs;
 
-	return ret;
+	return NULL;
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
@@ -2269,9 +2250,8 @@ static const struct dsa_switch_ops b53_switch_ops = {
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
index 3085b6cc7d40..83cdca443567 100644
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
@@ -49,12 +48,6 @@ struct b53_io_ops {
 	void (*phylink_get_caps)(struct b53_device *dev, int port,
 				 struct phylink_config *config);
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
@@ -85,10 +78,22 @@ enum {
 	BCM7278_DEVICE_ID = 0x7278,
 };
 
+struct b53_pcs {
+	struct phylink_pcs pcs;
+	struct b53_device *dev;
+	int port;
+};
+
+static inline struct b53_pcs *pcs_to_b53_pcs(struct phylink_pcs *pcs)
+{
+	return container_of(pcs, struct b53_pcs, pcs);
+}
+
 #define B53_N_PORTS	9
 #define B53_N_PORTS_25	6
 
 struct b53_port {
+	struct b53_pcs	pcs;
 	u16		vlan_ctl_mask;
 	struct ethtool_eee eee;
 };
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
index 555e5b372321..32af78f1438b 100644
--- a/drivers/net/dsa/b53/b53_serdes.c
+++ b/drivers/net/dsa/b53/b53_serdes.c
@@ -60,31 +60,40 @@ static u16 b53_serdes_read(struct b53_device *dev, u8 lane,
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
+	int port = pcs_to_b53_pcs(pcs)->port;
 	u16 reg;
+	u8 lane;
 
+	lane = b53_serdes_map_lane(dev, port);
 	if (lane == B53_INVALID_LANE)
-		return;
+		return 0;
 
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
+	int port = pcs_to_b53_pcs(pcs)->port;
 	u16 reg;
+	u8 lane;
 
+	lane = b53_serdes_map_lane(dev, port);
 	if (lane == B53_INVALID_LANE)
 		return;
 
@@ -94,16 +103,20 @@ void b53_serdes_an_restart(struct b53_device *dev, int port)
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
+	int port = pcs_to_b53_pcs(pcs)->port;
 	u16 dig, bmsr;
+	u8 lane;
 
-	if (lane == B53_INVALID_LANE)
-		return 1;
+	lane = b53_serdes_map_lane(dev, port);
+	if (lane == B53_INVALID_LANE) {
+		state->link = false;
+		return;
+	}
 
 	dig = b53_serdes_read(dev, lane, B53_SERDES_DIGITAL_STATUS,
 			      SERDES_DIGITAL_BLK);
@@ -133,10 +146,7 @@ int b53_serdes_link_state(struct b53_device *dev, int port,
 		state->pause |= MLO_PAUSE_RX;
 	if (dig & PAUSE_RESOLUTION_TX_SIDE)
 		state->pause |= MLO_PAUSE_TX;
-
-	return 0;
 }
-EXPORT_SYMBOL(b53_serdes_link_state);
 
 void b53_serdes_link_set(struct b53_device *dev, int port, unsigned int mode,
 			 phy_interface_t interface, bool link_up)
@@ -158,6 +168,12 @@ void b53_serdes_link_set(struct b53_device *dev, int port, unsigned int mode,
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
@@ -212,6 +228,8 @@ int b53_serdes_init(struct b53_device *dev, int port)
 		 (id0 >> SERDES_ID0_REV_NUM_SHIFT) & SERDES_ID0_REV_NUM_MASK,
 		 (u32)msb << 16 | lsb);
 
+	dev->ports[port].pcs.pcs.ops = &b53_pcs_ops;
+
 	return 0;
 }
 EXPORT_SYMBOL(b53_serdes_init);
diff --git a/drivers/net/dsa/b53/b53_serdes.h b/drivers/net/dsa/b53/b53_serdes.h
index f47d5caa7557..c372ba588994 100644
--- a/drivers/net/dsa/b53/b53_serdes.h
+++ b/drivers/net/dsa/b53/b53_serdes.h
@@ -107,12 +107,6 @@ static inline u8 b53_serdes_map_lane(struct b53_device *dev, int port)
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
 void b53_serdes_phylink_get_caps(struct b53_device *dev, int port,
diff --git a/drivers/net/dsa/b53/b53_srab.c b/drivers/net/dsa/b53/b53_srab.c
index c51b716657db..af5172c4660f 100644
--- a/drivers/net/dsa/b53/b53_srab.c
+++ b/drivers/net/dsa/b53/b53_srab.c
@@ -492,9 +492,6 @@ static const struct b53_io_ops b53_srab_ops = {
 	.phylink_get_caps = b53_srab_phylink_get_caps,
 #if IS_ENABLED(CONFIG_B53_SERDES)
 	.serdes_map_lane = b53_srab_serdes_map_lane,
-	.serdes_link_state = b53_serdes_link_state,
-	.serdes_config = b53_serdes_config,
-	.serdes_an_restart = b53_serdes_an_restart,
 	.serdes_link_set = b53_serdes_link_set,
 #endif
 };
-- 
2.30.2

