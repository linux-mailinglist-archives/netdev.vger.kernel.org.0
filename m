Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74055447E83
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 12:11:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238992AbhKHLNg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 06:13:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237732AbhKHLNb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Nov 2021 06:13:31 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB72DC061714
        for <netdev@vger.kernel.org>; Mon,  8 Nov 2021 03:10:46 -0800 (PST)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1mk2Xt-0003qv-08; Mon, 08 Nov 2021 12:10:37 +0100
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1mk2Xr-00BTbb-6G; Mon, 08 Nov 2021 12:10:35 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH net-next] net: dsa: microchip: implement multi-bridge support
Date:   Mon,  8 Nov 2021 12:10:34 +0100
Message-Id: <20211108111034.2735339-1-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Current driver version is able to handle only one bridge at time.
Configuring two bridges on two different ports would end up shorting this
bridges by HW. To reproduce it:

	ip l a name br0 type bridge
	ip l a name br1 type bridge
	ip l s dev br0 up
	ip l s dev br1 up
	ip l s lan1 master br0
	ip l s dev lan1 up
	ip l s lan2 master br1
	ip l s dev lan2 up

	Ping on lan1 and get response on lan2, which should not happen.

This happened, because current driver version is storing one global "Port VLAN
Membership" and applying it to all ports which are members of any
bridge.
To solve this issue, we need to handle each port separately.

This patch is dropping the global port member storage and calculating
membership dynamically depending on STP state and bridge participation.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/dsa/microchip/ksz8795.c    | 53 ++++-----------------
 drivers/net/dsa/microchip/ksz9477.c    | 64 ++++----------------------
 drivers/net/dsa/microchip/ksz_common.c | 56 +++++++++++++---------
 drivers/net/dsa/microchip/ksz_common.h |  1 -
 4 files changed, 51 insertions(+), 123 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index 43fc3087aeb3..b5f6dff70c89 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -1008,51 +1008,27 @@ static void ksz8_cfg_port_member(struct ksz_device *dev, int port, u8 member)
 static void ksz8_port_stp_state_set(struct dsa_switch *ds, int port, u8 state)
 {
 	struct ksz_device *dev = ds->priv;
-	int forward = dev->member;
 	struct ksz_port *p;
-	int member = -1;
 	u8 data;
 
-	p = &dev->ports[port];
-
 	ksz_pread8(dev, port, P_STP_CTRL, &data);
 	data &= ~(PORT_TX_ENABLE | PORT_RX_ENABLE | PORT_LEARN_DISABLE);
 
 	switch (state) {
 	case BR_STATE_DISABLED:
 		data |= PORT_LEARN_DISABLE;
-		if (port < dev->phy_port_cnt)
-			member = 0;
 		break;
 	case BR_STATE_LISTENING:
 		data |= (PORT_RX_ENABLE | PORT_LEARN_DISABLE);
-		if (port < dev->phy_port_cnt &&
-		    p->stp_state == BR_STATE_DISABLED)
-			member = dev->host_mask | p->vid_member;
 		break;
 	case BR_STATE_LEARNING:
 		data |= PORT_RX_ENABLE;
 		break;
 	case BR_STATE_FORWARDING:
 		data |= (PORT_TX_ENABLE | PORT_RX_ENABLE);
-
-		/* This function is also used internally. */
-		if (port == dev->cpu_port)
-			break;
-
-		/* Port is a member of a bridge. */
-		if (dev->br_member & BIT(port)) {
-			dev->member |= BIT(port);
-			member = dev->member;
-		} else {
-			member = dev->host_mask | p->vid_member;
-		}
 		break;
 	case BR_STATE_BLOCKING:
 		data |= PORT_LEARN_DISABLE;
-		if (port < dev->phy_port_cnt &&
-		    p->stp_state == BR_STATE_DISABLED)
-			member = dev->host_mask | p->vid_member;
 		break;
 	default:
 		dev_err(ds->dev, "invalid STP state: %d\n", state);
@@ -1060,22 +1036,11 @@ static void ksz8_port_stp_state_set(struct dsa_switch *ds, int port, u8 state)
 	}
 
 	ksz_pwrite8(dev, port, P_STP_CTRL, data);
+
+	p = &dev->ports[port];
 	p->stp_state = state;
-	/* Port membership may share register with STP state. */
-	if (member >= 0 && member != p->member)
-		ksz8_cfg_port_member(dev, port, (u8)member);
-
-	/* Check if forwarding needs to be updated. */
-	if (state != BR_STATE_FORWARDING) {
-		if (dev->br_member & BIT(port))
-			dev->member &= ~BIT(port);
-	}
 
-	/* When topology has changed the function ksz_update_port_member
-	 * should be called to modify port forwarding behavior.
-	 */
-	if (forward != dev->member)
-		ksz_update_port_member(dev, port);
+	ksz_update_port_member(dev, port);
 }
 
 static void ksz8_flush_dyn_mac_table(struct ksz_device *dev, int port)
@@ -1341,7 +1306,7 @@ static void ksz8795_cpu_interface_select(struct ksz_device *dev, int port)
 
 static void ksz8_port_setup(struct ksz_device *dev, int port, bool cpu_port)
 {
-	struct ksz_port *p = &dev->ports[port];
+	struct dsa_switch *ds = dev->ds;
 	struct ksz8 *ksz8 = dev->priv;
 	const u32 *masks;
 	u8 member;
@@ -1364,14 +1329,15 @@ static void ksz8_port_setup(struct ksz_device *dev, int port, bool cpu_port)
 	/* enable 802.1p priority */
 	ksz_port_cfg(dev, port, P_PRIO_CTRL, PORT_802_1P_ENABLE, true);
 
-	if (cpu_port) {
+	if (dsa_is_cpu_port(ds, port)) {
 		if (!ksz_is_ksz88x3(dev))
 			ksz8795_cpu_interface_select(dev, port);
 
-		member = dev->port_mask;
+		member = dsa_user_ports(ds);
 	} else {
-		member = dev->host_mask | p->vid_member;
+		member = BIT(dsa_upstream_port(ds, port));
 	}
+
 	ksz8_cfg_port_member(dev, port, member);
 }
 
@@ -1392,11 +1358,9 @@ static void ksz8_config_cpu_port(struct dsa_switch *ds)
 	ksz_cfg(dev, regs[S_TAIL_TAG_CTRL], masks[SW_TAIL_TAG_ENABLE], true);
 
 	p = &dev->ports[dev->cpu_port];
-	p->vid_member = dev->port_mask;
 	p->on = 1;
 
 	ksz8_port_setup(dev, dev->cpu_port, true);
-	dev->member = dev->host_mask;
 
 	for (i = 0; i < dev->phy_port_cnt; i++) {
 		p = &dev->ports[i];
@@ -1404,7 +1368,6 @@ static void ksz8_config_cpu_port(struct dsa_switch *ds)
 		/* Initialize to non-zero so that ksz_cfg_port_member() will
 		 * be called.
 		 */
-		p->vid_member = BIT(i);
 		p->member = dev->port_mask;
 		ksz8_port_stp_state_set(ds, i, BR_STATE_DISABLED);
 
diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index 854e25f43fa7..3e7df6c0dc72 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -400,8 +400,6 @@ static void ksz9477_port_stp_state_set(struct dsa_switch *ds, int port,
 	struct ksz_device *dev = ds->priv;
 	struct ksz_port *p = &dev->ports[port];
 	u8 data;
-	int member = -1;
-	int forward = dev->member;
 
 	ksz_pread8(dev, port, P_STP_CTRL, &data);
 	data &= ~(PORT_TX_ENABLE | PORT_RX_ENABLE | PORT_LEARN_DISABLE);
@@ -409,40 +407,18 @@ static void ksz9477_port_stp_state_set(struct dsa_switch *ds, int port,
 	switch (state) {
 	case BR_STATE_DISABLED:
 		data |= PORT_LEARN_DISABLE;
-		if (port != dev->cpu_port)
-			member = 0;
 		break;
 	case BR_STATE_LISTENING:
 		data |= (PORT_RX_ENABLE | PORT_LEARN_DISABLE);
-		if (port != dev->cpu_port &&
-		    p->stp_state == BR_STATE_DISABLED)
-			member = dev->host_mask | p->vid_member;
 		break;
 	case BR_STATE_LEARNING:
 		data |= PORT_RX_ENABLE;
 		break;
 	case BR_STATE_FORWARDING:
 		data |= (PORT_TX_ENABLE | PORT_RX_ENABLE);
-
-		/* This function is also used internally. */
-		if (port == dev->cpu_port)
-			break;
-
-		member = dev->host_mask | p->vid_member;
-		mutex_lock(&dev->dev_mutex);
-
-		/* Port is a member of a bridge. */
-		if (dev->br_member & (1 << port)) {
-			dev->member |= (1 << port);
-			member = dev->member;
-		}
-		mutex_unlock(&dev->dev_mutex);
 		break;
 	case BR_STATE_BLOCKING:
 		data |= PORT_LEARN_DISABLE;
-		if (port != dev->cpu_port &&
-		    p->stp_state == BR_STATE_DISABLED)
-			member = dev->host_mask | p->vid_member;
 		break;
 	default:
 		dev_err(ds->dev, "invalid STP state: %d\n", state);
@@ -451,23 +427,8 @@ static void ksz9477_port_stp_state_set(struct dsa_switch *ds, int port,
 
 	ksz_pwrite8(dev, port, P_STP_CTRL, data);
 	p->stp_state = state;
-	mutex_lock(&dev->dev_mutex);
-	/* Port membership may share register with STP state. */
-	if (member >= 0 && member != p->member)
-		ksz9477_cfg_port_member(dev, port, (u8)member);
-
-	/* Check if forwarding needs to be updated. */
-	if (state != BR_STATE_FORWARDING) {
-		if (dev->br_member & (1 << port))
-			dev->member &= ~(1 << port);
-	}
 
-	/* When topology has changed the function ksz_update_port_member
-	 * should be called to modify port forwarding behavior.
-	 */
-	if (forward != dev->member)
-		ksz_update_port_member(dev, port);
-	mutex_unlock(&dev->dev_mutex);
+	ksz_update_port_member(dev, port);
 }
 
 static void ksz9477_flush_dyn_mac_table(struct ksz_device *dev, int port)
@@ -1168,10 +1129,10 @@ static void ksz9477_phy_errata_setup(struct ksz_device *dev, int port)
 
 static void ksz9477_port_setup(struct ksz_device *dev, int port, bool cpu_port)
 {
-	u8 data8;
-	u8 member;
-	u16 data16;
 	struct ksz_port *p = &dev->ports[port];
+	struct dsa_switch *ds = dev->ds;
+	u8 data8, member;
+	u16 data16;
 
 	/* enable tag tail for host port */
 	if (cpu_port)
@@ -1250,12 +1211,12 @@ static void ksz9477_port_setup(struct ksz_device *dev, int port, bool cpu_port)
 		ksz_pwrite8(dev, port, REG_PORT_XMII_CTRL_1, data8);
 		p->phydev.duplex = 1;
 	}
-	mutex_lock(&dev->dev_mutex);
-	if (cpu_port)
-		member = dev->port_mask;
+
+	if (dsa_is_cpu_port(ds, port))
+		member = dsa_user_ports(ds);
 	else
-		member = dev->host_mask | p->vid_member;
-	mutex_unlock(&dev->dev_mutex);
+		member = BIT(dsa_upstream_port(ds, port));
+
 	ksz9477_cfg_port_member(dev, port, member);
 
 	/* clear pending interrupts */
@@ -1276,8 +1237,6 @@ static void ksz9477_config_cpu_port(struct dsa_switch *ds)
 			const char *prev_mode;
 
 			dev->cpu_port = i;
-			dev->host_mask = (1 << dev->cpu_port);
-			dev->port_mask |= dev->host_mask;
 			p = &dev->ports[i];
 
 			/* Read from XMII register to determine host port
@@ -1312,13 +1271,10 @@ static void ksz9477_config_cpu_port(struct dsa_switch *ds)
 
 			/* enable cpu port */
 			ksz9477_port_setup(dev, i, true);
-			p->vid_member = dev->port_mask;
 			p->on = 1;
 		}
 	}
 
-	dev->member = dev->host_mask;
-
 	for (i = 0; i < dev->port_cnt; i++) {
 		if (i == dev->cpu_port)
 			continue;
@@ -1327,8 +1283,6 @@ static void ksz9477_config_cpu_port(struct dsa_switch *ds)
 		/* Initialize to non-zero so that ksz_cfg_port_member() will
 		 * be called.
 		 */
-		p->vid_member = (1 << i);
-		p->member = dev->port_mask;
 		ksz9477_port_stp_state_set(ds, i, BR_STATE_DISABLED);
 		p->on = 1;
 		if (i < dev->phy_port_cnt)
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 7c2968a639eb..84b7ef511ff4 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -22,21 +22,46 @@
 
 void ksz_update_port_member(struct ksz_device *dev, int port)
 {
-	struct ksz_port *p;
+	struct ksz_port *p = &dev->ports[port];
+	struct dsa_switch *ds = dev->ds;
+	const struct dsa_port *dp;
+	u8 port_member = 0;
 	int i;
 
-	for (i = 0; i < dev->port_cnt; i++) {
-		if (i == port || i == dev->cpu_port)
+	if (!dsa_is_user_port(ds, port))
+		return;
+
+	dp = dsa_to_port(ds, port);
+
+	for (i = 0; i < ds->num_ports; i++) {
+		const struct dsa_port *dpi = dsa_to_port(ds, i);
+		struct ksz_port *pi = &dev->ports[i];
+		u8 val = 0;
+
+		if (!dsa_is_user_port(ds, i))
 			continue;
-		p = &dev->ports[i];
-		if (!(dev->member & (1 << i)))
+		if (port == i)
 			continue;
+		if (!dp->bridge_dev || dp->bridge_dev != dpi->bridge_dev)
+			continue;
+
+		pi = &dev->ports[i];
+		if (pi->stp_state != BR_STATE_DISABLED)
+			val |= BIT(dsa_upstream_port(ds, i));
 
-		/* Port is a member of the bridge and is forwarding. */
-		if (p->stp_state == BR_STATE_FORWARDING &&
-		    p->member != dev->member)
-			dev->dev_ops->cfg_port_member(dev, i, dev->member);
+		if (pi->stp_state == BR_STATE_FORWARDING &&
+		    p->stp_state == BR_STATE_FORWARDING) {
+			val |= BIT(port);
+			port_member |= BIT(i);
+		}
+
+		dev->dev_ops->cfg_port_member(dev, i, val);
 	}
+
+	if (p->stp_state != BR_STATE_DISABLED)
+		port_member |= BIT(dsa_upstream_port(ds, port));
+
+	dev->dev_ops->cfg_port_member(dev, port, port_member);
 }
 EXPORT_SYMBOL_GPL(ksz_update_port_member);
 
@@ -175,12 +200,6 @@ EXPORT_SYMBOL_GPL(ksz_get_ethtool_stats);
 int ksz_port_bridge_join(struct dsa_switch *ds, int port,
 			 struct net_device *br)
 {
-	struct ksz_device *dev = ds->priv;
-
-	mutex_lock(&dev->dev_mutex);
-	dev->br_member |= (1 << port);
-	mutex_unlock(&dev->dev_mutex);
-
 	/* port_stp_state_set() will be called after to put the port in
 	 * appropriate state so there is no need to do anything.
 	 */
@@ -192,13 +211,6 @@ EXPORT_SYMBOL_GPL(ksz_port_bridge_join);
 void ksz_port_bridge_leave(struct dsa_switch *ds, int port,
 			   struct net_device *br)
 {
-	struct ksz_device *dev = ds->priv;
-
-	mutex_lock(&dev->dev_mutex);
-	dev->br_member &= ~(1 << port);
-	dev->member &= ~(1 << port);
-	mutex_unlock(&dev->dev_mutex);
-
 	/* port_stp_state_set() will be called after to put the port in
 	 * forwarding state so there is no need to do anything.
 	 */
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index 1597c63988b4..18c9b2e34cd1 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -26,7 +26,6 @@ struct ksz_port_mib {
 
 struct ksz_port {
 	u16 member;
-	u16 vid_member;
 	bool remove_tag;		/* Remove Tag flag set, for ksz8795 only */
 	int stp_state;
 	struct phy_device phydev;
-- 
2.30.2

