Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C227C36BFD1
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 09:10:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235111AbhD0HKm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Apr 2021 03:10:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234886AbhD0HKe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Apr 2021 03:10:34 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE68FC06138A
        for <netdev@vger.kernel.org>; Tue, 27 Apr 2021 00:09:22 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lbHqK-00011t-9L; Tue, 27 Apr 2021 09:09:12 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lbHqI-0003ly-Bc; Tue, 27 Apr 2021 09:09:10 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        kernel@pengutronix.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Russell King <linux@armlinux.org.uk>
Subject: [PATCH net-next v8 1/9] net: dsa: microchip: ksz8795: change drivers prefix to be generic
Date:   Tue, 27 Apr 2021 09:09:01 +0200
Message-Id: <20210427070909.14434-2-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210427070909.14434-1-o.rempel@pengutronix.de>
References: <20210427070909.14434-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Grzeschik <m.grzeschik@pengutronix.de>

The driver can be used on other chips of this type. To reflect
this we rename the drivers prefix from ksz8795 to ksz8.

Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

---
v1 -> v4: - extracted this change from bigger previous patch
v4 -> v5: - removed extra unavailable variables in ksz8_r_vlan_entries
v5 -> v6: - move vlan variable size changes to other patch
---
 drivers/net/dsa/microchip/ksz8795.c     | 224 ++++++++++++------------
 drivers/net/dsa/microchip/ksz8795_spi.c |   2 +-
 drivers/net/dsa/microchip/ksz_common.h  |   2 +-
 3 files changed, 111 insertions(+), 117 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index b4b7de63ca79..91297df4371c 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -74,7 +74,7 @@ static void ksz_port_cfg(struct ksz_device *dev, int port, int offset, u8 bits,
 			   bits, set ? bits : 0);
 }
 
-static int ksz8795_reset_switch(struct ksz_device *dev)
+static int ksz8_reset_switch(struct ksz_device *dev)
 {
 	/* reset switch */
 	ksz_write8(dev, REG_POWER_MANAGEMENT_1,
@@ -117,8 +117,7 @@ static void ksz8795_set_prio_queue(struct ksz_device *dev, int port, int queue)
 			true);
 }
 
-static void ksz8795_r_mib_cnt(struct ksz_device *dev, int port, u16 addr,
-			      u64 *cnt)
+static void ksz8_r_mib_cnt(struct ksz_device *dev, int port, u16 addr, u64 *cnt)
 {
 	u16 ctrl_addr;
 	u32 data;
@@ -148,8 +147,8 @@ static void ksz8795_r_mib_cnt(struct ksz_device *dev, int port, u16 addr,
 	mutex_unlock(&dev->alu_mutex);
 }
 
-static void ksz8795_r_mib_pkt(struct ksz_device *dev, int port, u16 addr,
-			      u64 *dropped, u64 *cnt)
+static void ksz8_r_mib_pkt(struct ksz_device *dev, int port, u16 addr,
+			   u64 *dropped, u64 *cnt)
 {
 	u16 ctrl_addr;
 	u32 data;
@@ -195,7 +194,7 @@ static void ksz8795_r_mib_pkt(struct ksz_device *dev, int port, u16 addr,
 	mutex_unlock(&dev->alu_mutex);
 }
 
-static void ksz8795_freeze_mib(struct ksz_device *dev, int port, bool freeze)
+static void ksz8_freeze_mib(struct ksz_device *dev, int port, bool freeze)
 {
 	/* enable the port for flush/freeze function */
 	if (freeze)
@@ -207,7 +206,7 @@ static void ksz8795_freeze_mib(struct ksz_device *dev, int port, bool freeze)
 		ksz_cfg(dev, REG_SW_CTRL_6, BIT(port), false);
 }
 
-static void ksz8795_port_init_cnt(struct ksz_device *dev, int port)
+static void ksz8_port_init_cnt(struct ksz_device *dev, int port)
 {
 	struct ksz_port_mib *mib = &dev->ports[port].mib;
 
@@ -235,8 +234,7 @@ static void ksz8795_port_init_cnt(struct ksz_device *dev, int port)
 	memset(mib->counters, 0, dev->mib_cnt * sizeof(u64));
 }
 
-static void ksz8795_r_table(struct ksz_device *dev, int table, u16 addr,
-			    u64 *data)
+static void ksz8_r_table(struct ksz_device *dev, int table, u16 addr, u64 *data)
 {
 	u16 ctrl_addr;
 
@@ -248,8 +246,7 @@ static void ksz8795_r_table(struct ksz_device *dev, int table, u16 addr,
 	mutex_unlock(&dev->alu_mutex);
 }
 
-static void ksz8795_w_table(struct ksz_device *dev, int table, u16 addr,
-			    u64 data)
+static void ksz8_w_table(struct ksz_device *dev, int table, u16 addr, u64 data)
 {
 	u16 ctrl_addr;
 
@@ -261,7 +258,7 @@ static void ksz8795_w_table(struct ksz_device *dev, int table, u16 addr,
 	mutex_unlock(&dev->alu_mutex);
 }
 
-static int ksz8795_valid_dyn_entry(struct ksz_device *dev, u8 *data)
+static int ksz8_valid_dyn_entry(struct ksz_device *dev, u8 *data)
 {
 	int timeout = 100;
 
@@ -284,9 +281,9 @@ static int ksz8795_valid_dyn_entry(struct ksz_device *dev, u8 *data)
 	return 0;
 }
 
-static int ksz8795_r_dyn_mac_table(struct ksz_device *dev, u16 addr,
-				   u8 *mac_addr, u8 *fid, u8 *src_port,
-				   u8 *timestamp, u16 *entries)
+static int ksz8_r_dyn_mac_table(struct ksz_device *dev, u16 addr,
+				u8 *mac_addr, u8 *fid, u8 *src_port,
+				u8 *timestamp, u16 *entries)
 {
 	u32 data_hi, data_lo;
 	u16 ctrl_addr;
@@ -298,7 +295,7 @@ static int ksz8795_r_dyn_mac_table(struct ksz_device *dev, u16 addr,
 	mutex_lock(&dev->alu_mutex);
 	ksz_write16(dev, REG_IND_CTRL_0, ctrl_addr);
 
-	rc = ksz8795_valid_dyn_entry(dev, &data);
+	rc = ksz8_valid_dyn_entry(dev, &data);
 	if (rc == -EAGAIN) {
 		if (addr == 0)
 			*entries = 0;
@@ -341,13 +338,13 @@ static int ksz8795_r_dyn_mac_table(struct ksz_device *dev, u16 addr,
 	return rc;
 }
 
-static int ksz8795_r_sta_mac_table(struct ksz_device *dev, u16 addr,
-				   struct alu_struct *alu)
+static int ksz8_r_sta_mac_table(struct ksz_device *dev, u16 addr,
+				struct alu_struct *alu)
 {
 	u32 data_hi, data_lo;
 	u64 data;
 
-	ksz8795_r_table(dev, TABLE_STATIC_MAC, addr, &data);
+	ksz8_r_table(dev, TABLE_STATIC_MAC, addr, &data);
 	data_hi = data >> 32;
 	data_lo = (u32)data;
 	if (data_hi & (STATIC_MAC_TABLE_VALID | STATIC_MAC_TABLE_OVERRIDE)) {
@@ -370,8 +367,8 @@ static int ksz8795_r_sta_mac_table(struct ksz_device *dev, u16 addr,
 	return -ENXIO;
 }
 
-static void ksz8795_w_sta_mac_table(struct ksz_device *dev, u16 addr,
-				    struct alu_struct *alu)
+static void ksz8_w_sta_mac_table(struct ksz_device *dev, u16 addr,
+				 struct alu_struct *alu)
 {
 	u32 data_hi, data_lo;
 	u64 data;
@@ -394,17 +391,17 @@ static void ksz8795_w_sta_mac_table(struct ksz_device *dev, u16 addr,
 		data_hi &= ~STATIC_MAC_TABLE_OVERRIDE;
 
 	data = (u64)data_hi << 32 | data_lo;
-	ksz8795_w_table(dev, TABLE_STATIC_MAC, addr, data);
+	ksz8_w_table(dev, TABLE_STATIC_MAC, addr, data);
 }
 
-static void ksz8795_from_vlan(u16 vlan, u8 *fid, u8 *member, u8 *valid)
+static void ksz8_from_vlan(u16 vlan, u8 *fid, u8 *member, u8 *valid)
 {
 	*fid = vlan & VLAN_TABLE_FID;
 	*member = (vlan & VLAN_TABLE_MEMBERSHIP) >> VLAN_TABLE_MEMBERSHIP_S;
 	*valid = !!(vlan & VLAN_TABLE_VALID);
 }
 
-static void ksz8795_to_vlan(u8 fid, u8 member, u8 valid, u16 *vlan)
+static void ksz8_to_vlan(u8 fid, u8 member, u8 valid, u16 *vlan)
 {
 	*vlan = fid;
 	*vlan |= (u16)member << VLAN_TABLE_MEMBERSHIP_S;
@@ -412,12 +409,12 @@ static void ksz8795_to_vlan(u8 fid, u8 member, u8 valid, u16 *vlan)
 		*vlan |= VLAN_TABLE_VALID;
 }
 
-static void ksz8795_r_vlan_entries(struct ksz_device *dev, u16 addr)
+static void ksz8_r_vlan_entries(struct ksz_device *dev, u16 addr)
 {
 	u64 data;
 	int i;
 
-	ksz8795_r_table(dev, TABLE_VLAN, addr, &data);
+	ksz8_r_table(dev, TABLE_VLAN, addr, &data);
 	addr *= dev->phy_port_cnt;
 	for (i = 0; i < dev->phy_port_cnt; i++) {
 		dev->vlan_cache[addr + i].table[0] = (u16)data;
@@ -425,7 +422,7 @@ static void ksz8795_r_vlan_entries(struct ksz_device *dev, u16 addr)
 	}
 }
 
-static void ksz8795_r_vlan_table(struct ksz_device *dev, u16 vid, u16 *vlan)
+static void ksz8_r_vlan_table(struct ksz_device *dev, u16 vid, u16 *vlan)
 {
 	int index;
 	u16 *data;
@@ -435,11 +432,11 @@ static void ksz8795_r_vlan_table(struct ksz_device *dev, u16 vid, u16 *vlan)
 	data = (u16 *)&buf;
 	addr = vid / dev->phy_port_cnt;
 	index = vid & 3;
-	ksz8795_r_table(dev, TABLE_VLAN, addr, &buf);
+	ksz8_r_table(dev, TABLE_VLAN, addr, &buf);
 	*vlan = data[index];
 }
 
-static void ksz8795_w_vlan_table(struct ksz_device *dev, u16 vid, u16 vlan)
+static void ksz8_w_vlan_table(struct ksz_device *dev, u16 vid, u16 vlan)
 {
 	int index;
 	u16 *data;
@@ -449,13 +446,13 @@ static void ksz8795_w_vlan_table(struct ksz_device *dev, u16 vid, u16 vlan)
 	data = (u16 *)&buf;
 	addr = vid / dev->phy_port_cnt;
 	index = vid & 3;
-	ksz8795_r_table(dev, TABLE_VLAN, addr, &buf);
+	ksz8_r_table(dev, TABLE_VLAN, addr, &buf);
 	data[index] = vlan;
 	dev->vlan_cache[vid].table[0] = vlan;
-	ksz8795_w_table(dev, TABLE_VLAN, addr, buf);
+	ksz8_w_table(dev, TABLE_VLAN, addr, buf);
 }
 
-static void ksz8795_r_phy(struct ksz_device *dev, u16 phy, u16 reg, u16 *val)
+static void ksz8_r_phy(struct ksz_device *dev, u16 phy, u16 reg, u16 *val)
 {
 	u8 restart, speed, ctrl, link;
 	int processed = true;
@@ -546,7 +543,7 @@ static void ksz8795_r_phy(struct ksz_device *dev, u16 phy, u16 reg, u16 *val)
 		*val = data;
 }
 
-static void ksz8795_w_phy(struct ksz_device *dev, u16 phy, u16 reg, u16 val)
+static void ksz8_w_phy(struct ksz_device *dev, u16 phy, u16 reg, u16 val)
 {
 	u8 p = phy;
 	u8 restart, speed, ctrl, data;
@@ -644,15 +641,15 @@ static void ksz8795_w_phy(struct ksz_device *dev, u16 phy, u16 reg, u16 val)
 	}
 }
 
-static enum dsa_tag_protocol ksz8795_get_tag_protocol(struct dsa_switch *ds,
-						      int port,
-						      enum dsa_tag_protocol mp)
+static enum dsa_tag_protocol ksz8_get_tag_protocol(struct dsa_switch *ds,
+						   int port,
+						   enum dsa_tag_protocol mp)
 {
 	return DSA_TAG_PROTO_KSZ8795;
 }
 
-static void ksz8795_get_strings(struct dsa_switch *ds, int port,
-				u32 stringset, uint8_t *buf)
+static void ksz8_get_strings(struct dsa_switch *ds, int port,
+			     u32 stringset, uint8_t *buf)
 {
 	struct ksz_device *dev = ds->priv;
 	int i;
@@ -663,8 +660,7 @@ static void ksz8795_get_strings(struct dsa_switch *ds, int port,
 	}
 }
 
-static void ksz8795_cfg_port_member(struct ksz_device *dev, int port,
-				    u8 member)
+static void ksz8_cfg_port_member(struct ksz_device *dev, int port, u8 member)
 {
 	u8 data;
 
@@ -675,8 +671,7 @@ static void ksz8795_cfg_port_member(struct ksz_device *dev, int port,
 	dev->ports[port].member = member;
 }
 
-static void ksz8795_port_stp_state_set(struct dsa_switch *ds, int port,
-				       u8 state)
+static void ksz8_port_stp_state_set(struct dsa_switch *ds, int port, u8 state)
 {
 	struct ksz_device *dev = ds->priv;
 	int forward = dev->member;
@@ -734,7 +729,7 @@ static void ksz8795_port_stp_state_set(struct dsa_switch *ds, int port,
 	p->stp_state = state;
 	/* Port membership may share register with STP state. */
 	if (member >= 0 && member != p->member)
-		ksz8795_cfg_port_member(dev, port, (u8)member);
+		ksz8_cfg_port_member(dev, port, (u8)member);
 
 	/* Check if forwarding needs to be updated. */
 	if (state != BR_STATE_FORWARDING) {
@@ -749,7 +744,7 @@ static void ksz8795_port_stp_state_set(struct dsa_switch *ds, int port,
 		ksz_update_port_member(dev, port);
 }
 
-static void ksz8795_flush_dyn_mac_table(struct ksz_device *dev, int port)
+static void ksz8_flush_dyn_mac_table(struct ksz_device *dev, int port)
 {
 	u8 learn[DSA_MAX_PORTS];
 	int first, index, cnt;
@@ -782,9 +777,8 @@ static void ksz8795_flush_dyn_mac_table(struct ksz_device *dev, int port)
 	}
 }
 
-static int ksz8795_port_vlan_filtering(struct dsa_switch *ds, int port,
-				       bool flag,
-				       struct netlink_ext_ack *extack)
+static int ksz8_port_vlan_filtering(struct dsa_switch *ds, int port, bool flag,
+				    struct netlink_ext_ack *extack)
 {
 	struct ksz_device *dev = ds->priv;
 
@@ -793,9 +787,9 @@ static int ksz8795_port_vlan_filtering(struct dsa_switch *ds, int port,
 	return 0;
 }
 
-static int ksz8795_port_vlan_add(struct dsa_switch *ds, int port,
-				 const struct switchdev_obj_port_vlan *vlan,
-				 struct netlink_ext_ack *extack)
+static int ksz8_port_vlan_add(struct dsa_switch *ds, int port,
+			      const struct switchdev_obj_port_vlan *vlan,
+			      struct netlink_ext_ack *extack)
 {
 	bool untagged = vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
 	struct ksz_device *dev = ds->priv;
@@ -804,8 +798,8 @@ static int ksz8795_port_vlan_add(struct dsa_switch *ds, int port,
 
 	ksz_port_cfg(dev, port, P_TAG_CTRL, PORT_REMOVE_TAG, untagged);
 
-	ksz8795_r_vlan_table(dev, vlan->vid, &data);
-	ksz8795_from_vlan(data, &fid, &member, &valid);
+	ksz8_r_vlan_table(dev, vlan->vid, &data);
+	ksz8_from_vlan(data, &fid, &member, &valid);
 
 	/* First time to setup the VLAN entry. */
 	if (!valid) {
@@ -815,8 +809,8 @@ static int ksz8795_port_vlan_add(struct dsa_switch *ds, int port,
 	}
 	member |= BIT(port);
 
-	ksz8795_to_vlan(fid, member, valid, &data);
-	ksz8795_w_vlan_table(dev, vlan->vid, data);
+	ksz8_to_vlan(fid, member, valid, &data);
+	ksz8_w_vlan_table(dev, vlan->vid, data);
 
 	/* change PVID */
 	if (vlan->flags & BRIDGE_VLAN_INFO_PVID)
@@ -834,8 +828,8 @@ static int ksz8795_port_vlan_add(struct dsa_switch *ds, int port,
 	return 0;
 }
 
-static int ksz8795_port_vlan_del(struct dsa_switch *ds, int port,
-				 const struct switchdev_obj_port_vlan *vlan)
+static int ksz8_port_vlan_del(struct dsa_switch *ds, int port,
+			      const struct switchdev_obj_port_vlan *vlan)
 {
 	bool untagged = vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
 	struct ksz_device *dev = ds->priv;
@@ -847,8 +841,8 @@ static int ksz8795_port_vlan_del(struct dsa_switch *ds, int port,
 
 	ksz_port_cfg(dev, port, P_TAG_CTRL, PORT_REMOVE_TAG, untagged);
 
-	ksz8795_r_vlan_table(dev, vlan->vid, &data);
-	ksz8795_from_vlan(data, &fid, &member, &valid);
+	ksz8_r_vlan_table(dev, vlan->vid, &data);
+	ksz8_from_vlan(data, &fid, &member, &valid);
 
 	member &= ~BIT(port);
 
@@ -861,8 +855,8 @@ static int ksz8795_port_vlan_del(struct dsa_switch *ds, int port,
 	if (pvid == vlan->vid)
 		new_pvid = 1;
 
-	ksz8795_to_vlan(fid, member, valid, &data);
-	ksz8795_w_vlan_table(dev, vlan->vid, data);
+	ksz8_to_vlan(fid, member, valid, &data);
+	ksz8_w_vlan_table(dev, vlan->vid, data);
 
 	if (new_pvid != pvid)
 		ksz_pwrite16(dev, port, REG_PORT_CTRL_VID, pvid);
@@ -870,9 +864,9 @@ static int ksz8795_port_vlan_del(struct dsa_switch *ds, int port,
 	return 0;
 }
 
-static int ksz8795_port_mirror_add(struct dsa_switch *ds, int port,
-				   struct dsa_mall_mirror_tc_entry *mirror,
-				   bool ingress)
+static int ksz8_port_mirror_add(struct dsa_switch *ds, int port,
+				struct dsa_mall_mirror_tc_entry *mirror,
+				bool ingress)
 {
 	struct ksz_device *dev = ds->priv;
 
@@ -894,8 +888,8 @@ static int ksz8795_port_mirror_add(struct dsa_switch *ds, int port,
 	return 0;
 }
 
-static void ksz8795_port_mirror_del(struct dsa_switch *ds, int port,
-				    struct dsa_mall_mirror_tc_entry *mirror)
+static void ksz8_port_mirror_del(struct dsa_switch *ds, int port,
+				 struct dsa_mall_mirror_tc_entry *mirror)
 {
 	struct ksz_device *dev = ds->priv;
 	u8 data;
@@ -915,7 +909,7 @@ static void ksz8795_port_mirror_del(struct dsa_switch *ds, int port,
 			     PORT_MIRROR_SNIFFER, false);
 }
 
-static void ksz8795_port_setup(struct ksz_device *dev, int port, bool cpu_port)
+static void ksz8_port_setup(struct ksz_device *dev, int port, bool cpu_port)
 {
 	struct ksz_port *p = &dev->ports[port];
 	u8 data8, member;
@@ -981,10 +975,10 @@ static void ksz8795_port_setup(struct ksz_device *dev, int port, bool cpu_port)
 	} else {
 		member = dev->host_mask | p->vid_member;
 	}
-	ksz8795_cfg_port_member(dev, port, member);
+	ksz8_cfg_port_member(dev, port, member);
 }
 
-static void ksz8795_config_cpu_port(struct dsa_switch *ds)
+static void ksz8_config_cpu_port(struct dsa_switch *ds)
 {
 	struct ksz_device *dev = ds->priv;
 	struct ksz_port *p;
@@ -999,7 +993,7 @@ static void ksz8795_config_cpu_port(struct dsa_switch *ds)
 	p->vid_member = dev->port_mask;
 	p->on = 1;
 
-	ksz8795_port_setup(dev, dev->cpu_port, true);
+	ksz8_port_setup(dev, dev->cpu_port, true);
 	dev->member = dev->host_mask;
 
 	for (i = 0; i < dev->phy_port_cnt; i++) {
@@ -1010,7 +1004,7 @@ static void ksz8795_config_cpu_port(struct dsa_switch *ds)
 		 */
 		p->vid_member = BIT(i);
 		p->member = dev->port_mask;
-		ksz8795_port_stp_state_set(ds, i, BR_STATE_DISABLED);
+		ksz8_port_stp_state_set(ds, i, BR_STATE_DISABLED);
 
 		/* Last port may be disabled. */
 		if (i == dev->phy_port_cnt)
@@ -1034,7 +1028,7 @@ static void ksz8795_config_cpu_port(struct dsa_switch *ds)
 	}
 }
 
-static int ksz8795_setup(struct dsa_switch *ds)
+static int ksz8_setup(struct dsa_switch *ds)
 {
 	struct ksz_device *dev = ds->priv;
 	struct alu_struct alu;
@@ -1045,7 +1039,7 @@ static int ksz8795_setup(struct dsa_switch *ds)
 	if (!dev->vlan_cache)
 		return -ENOMEM;
 
-	ret = ksz8795_reset_switch(dev);
+	ret = ksz8_reset_switch(dev);
 	if (ret) {
 		dev_err(ds->dev, "failed to reset switch\n");
 		return ret;
@@ -1068,7 +1062,7 @@ static int ksz8795_setup(struct dsa_switch *ds)
 			   UNICAST_VLAN_BOUNDARY | NO_EXC_COLLISION_DROP,
 			   UNICAST_VLAN_BOUNDARY | NO_EXC_COLLISION_DROP);
 
-	ksz8795_config_cpu_port(ds);
+	ksz8_config_cpu_port(ds);
 
 	ksz_cfg(dev, REG_SW_CTRL_2, MULTICAST_STORM_DISABLE, true);
 
@@ -1083,7 +1077,7 @@ static int ksz8795_setup(struct dsa_switch *ds)
 			   BROADCAST_STORM_PROT_RATE) / 100);
 
 	for (i = 0; i < (dev->num_vlans / 4); i++)
-		ksz8795_r_vlan_entries(dev, i);
+		ksz8_r_vlan_entries(dev, i);
 
 	/* Setup STP address for STP operation. */
 	memset(&alu, 0, sizeof(alu));
@@ -1092,7 +1086,7 @@ static int ksz8795_setup(struct dsa_switch *ds)
 	alu.is_override = true;
 	alu.port_forward = dev->host_mask;
 
-	ksz8795_w_sta_mac_table(dev, 0, &alu);
+	ksz8_w_sta_mac_table(dev, 0, &alu);
 
 	ksz_init_mib_timer(dev);
 
@@ -1101,36 +1095,36 @@ static int ksz8795_setup(struct dsa_switch *ds)
 	return 0;
 }
 
-static const struct dsa_switch_ops ksz8795_switch_ops = {
-	.get_tag_protocol	= ksz8795_get_tag_protocol,
-	.setup			= ksz8795_setup,
+static const struct dsa_switch_ops ksz8_switch_ops = {
+	.get_tag_protocol	= ksz8_get_tag_protocol,
+	.setup			= ksz8_setup,
 	.phy_read		= ksz_phy_read16,
 	.phy_write		= ksz_phy_write16,
 	.phylink_mac_link_down	= ksz_mac_link_down,
 	.port_enable		= ksz_enable_port,
-	.get_strings		= ksz8795_get_strings,
+	.get_strings		= ksz8_get_strings,
 	.get_ethtool_stats	= ksz_get_ethtool_stats,
 	.get_sset_count		= ksz_sset_count,
 	.port_bridge_join	= ksz_port_bridge_join,
 	.port_bridge_leave	= ksz_port_bridge_leave,
-	.port_stp_state_set	= ksz8795_port_stp_state_set,
+	.port_stp_state_set	= ksz8_port_stp_state_set,
 	.port_fast_age		= ksz_port_fast_age,
-	.port_vlan_filtering	= ksz8795_port_vlan_filtering,
-	.port_vlan_add		= ksz8795_port_vlan_add,
-	.port_vlan_del		= ksz8795_port_vlan_del,
+	.port_vlan_filtering	= ksz8_port_vlan_filtering,
+	.port_vlan_add		= ksz8_port_vlan_add,
+	.port_vlan_del		= ksz8_port_vlan_del,
 	.port_fdb_dump		= ksz_port_fdb_dump,
 	.port_mdb_add           = ksz_port_mdb_add,
 	.port_mdb_del           = ksz_port_mdb_del,
-	.port_mirror_add	= ksz8795_port_mirror_add,
-	.port_mirror_del	= ksz8795_port_mirror_del,
+	.port_mirror_add	= ksz8_port_mirror_add,
+	.port_mirror_del	= ksz8_port_mirror_del,
 };
 
-static u32 ksz8795_get_port_addr(int port, int offset)
+static u32 ksz8_get_port_addr(int port, int offset)
 {
 	return PORT_CTRL_ADDR(port, offset);
 }
 
-static int ksz8795_switch_detect(struct ksz_device *dev)
+static int ksz8_switch_detect(struct ksz_device *dev)
 {
 	u8 id1, id2;
 	u16 id16;
@@ -1174,7 +1168,7 @@ struct ksz_chip_data {
 	int port_cnt;
 };
 
-static const struct ksz_chip_data ksz8795_switch_chips[] = {
+static const struct ksz_chip_data ksz8_switch_chips[] = {
 	{
 		.chip_id = 0x8795,
 		.dev_name = "KSZ8795",
@@ -1218,14 +1212,14 @@ static const struct ksz_chip_data ksz8795_switch_chips[] = {
 	},
 };
 
-static int ksz8795_switch_init(struct ksz_device *dev)
+static int ksz8_switch_init(struct ksz_device *dev)
 {
 	int i;
 
-	dev->ds->ops = &ksz8795_switch_ops;
+	dev->ds->ops = &ksz8_switch_ops;
 
-	for (i = 0; i < ARRAY_SIZE(ksz8795_switch_chips); i++) {
-		const struct ksz_chip_data *chip = &ksz8795_switch_chips[i];
+	for (i = 0; i < ARRAY_SIZE(ksz8_switch_chips); i++) {
+		const struct ksz_chip_data *chip = &ksz8_switch_chips[i];
 
 		if (dev->chip_id == chip->chip_id) {
 			dev->name = chip->dev_name;
@@ -1272,36 +1266,36 @@ static int ksz8795_switch_init(struct ksz_device *dev)
 	return 0;
 }
 
-static void ksz8795_switch_exit(struct ksz_device *dev)
+static void ksz8_switch_exit(struct ksz_device *dev)
 {
-	ksz8795_reset_switch(dev);
+	ksz8_reset_switch(dev);
 }
 
-static const struct ksz_dev_ops ksz8795_dev_ops = {
-	.get_port_addr = ksz8795_get_port_addr,
-	.cfg_port_member = ksz8795_cfg_port_member,
-	.flush_dyn_mac_table = ksz8795_flush_dyn_mac_table,
-	.port_setup = ksz8795_port_setup,
-	.r_phy = ksz8795_r_phy,
-	.w_phy = ksz8795_w_phy,
-	.r_dyn_mac_table = ksz8795_r_dyn_mac_table,
-	.r_sta_mac_table = ksz8795_r_sta_mac_table,
-	.w_sta_mac_table = ksz8795_w_sta_mac_table,
-	.r_mib_cnt = ksz8795_r_mib_cnt,
-	.r_mib_pkt = ksz8795_r_mib_pkt,
-	.freeze_mib = ksz8795_freeze_mib,
-	.port_init_cnt = ksz8795_port_init_cnt,
-	.shutdown = ksz8795_reset_switch,
-	.detect = ksz8795_switch_detect,
-	.init = ksz8795_switch_init,
-	.exit = ksz8795_switch_exit,
+static const struct ksz_dev_ops ksz8_dev_ops = {
+	.get_port_addr = ksz8_get_port_addr,
+	.cfg_port_member = ksz8_cfg_port_member,
+	.flush_dyn_mac_table = ksz8_flush_dyn_mac_table,
+	.port_setup = ksz8_port_setup,
+	.r_phy = ksz8_r_phy,
+	.w_phy = ksz8_w_phy,
+	.r_dyn_mac_table = ksz8_r_dyn_mac_table,
+	.r_sta_mac_table = ksz8_r_sta_mac_table,
+	.w_sta_mac_table = ksz8_w_sta_mac_table,
+	.r_mib_cnt = ksz8_r_mib_cnt,
+	.r_mib_pkt = ksz8_r_mib_pkt,
+	.freeze_mib = ksz8_freeze_mib,
+	.port_init_cnt = ksz8_port_init_cnt,
+	.shutdown = ksz8_reset_switch,
+	.detect = ksz8_switch_detect,
+	.init = ksz8_switch_init,
+	.exit = ksz8_switch_exit,
 };
 
-int ksz8795_switch_register(struct ksz_device *dev)
+int ksz8_switch_register(struct ksz_device *dev)
 {
-	return ksz_switch_register(dev, &ksz8795_dev_ops);
+	return ksz_switch_register(dev, &ksz8_dev_ops);
 }
-EXPORT_SYMBOL(ksz8795_switch_register);
+EXPORT_SYMBOL(ksz8_switch_register);
 
 MODULE_AUTHOR("Tristram Ha <Tristram.Ha@microchip.com>");
 MODULE_DESCRIPTION("Microchip KSZ8795 Series Switch DSA Driver");
diff --git a/drivers/net/dsa/microchip/ksz8795_spi.c b/drivers/net/dsa/microchip/ksz8795_spi.c
index f98432a3e2b5..45420c07c99f 100644
--- a/drivers/net/dsa/microchip/ksz8795_spi.c
+++ b/drivers/net/dsa/microchip/ksz8795_spi.c
@@ -55,7 +55,7 @@ static int ksz8795_spi_probe(struct spi_device *spi)
 	if (ret)
 		return ret;
 
-	ret = ksz8795_switch_register(dev);
+	ret = ksz8_switch_register(dev);
 
 	/* Main DSA driver may not be started yet. */
 	if (ret)
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index f212775372ce..f0681a891cca 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -142,7 +142,7 @@ int ksz_switch_register(struct ksz_device *dev,
 			const struct ksz_dev_ops *ops);
 void ksz_switch_remove(struct ksz_device *dev);
 
-int ksz8795_switch_register(struct ksz_device *dev);
+int ksz8_switch_register(struct ksz_device *dev);
 int ksz9477_switch_register(struct ksz_device *dev);
 
 void ksz_update_port_member(struct ksz_device *dev, int port);
-- 
2.29.2

