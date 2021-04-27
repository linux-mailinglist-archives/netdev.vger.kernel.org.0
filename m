Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D82936BFD5
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 09:10:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236339AbhD0HKv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Apr 2021 03:10:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234893AbhD0HKe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Apr 2021 03:10:34 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01A02C06138B
        for <netdev@vger.kernel.org>; Tue, 27 Apr 2021 00:09:22 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lbHqK-00011w-9L; Tue, 27 Apr 2021 09:09:12 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lbHqI-0003mU-F3; Tue, 27 Apr 2021 09:09:10 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        kernel@pengutronix.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Russell King <linux@armlinux.org.uk>
Subject: [PATCH net-next v8 4/9] net: dsa: microchip: ksz8795: add support for ksz88xx chips
Date:   Tue, 27 Apr 2021 09:09:04 +0200
Message-Id: <20210427070909.14434-5-o.rempel@pengutronix.de>
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

We add support for the ksz8863 and ksz8873 chips which are
using the same register patterns but other offsets as the
ksz8795.

Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>

---
v1 -> v4: - extracted this change from bigger previous patch
v4 -> v5: - added clear of reset bit for ksz8863 reset code
          - using extra device flag IS_KSZ88x3 instead of is_ksz8795 function
          - using DSA_TAG_PROTO_KSZ9893 protocol for ksz88x3 instead
v5 -> v6: - changed variable order to revers christmas tree
	  - added back missed dropped handling in init_cnt for ksz8863
          - disable VLAN support for ksz8863. Currently it need more
            work.
---
 drivers/net/dsa/microchip/ksz8795.c     | 311 ++++++++++++++++++++----
 drivers/net/dsa/microchip/ksz8795_reg.h |  40 ++-
 drivers/net/dsa/microchip/ksz_common.h  |   1 +
 3 files changed, 281 insertions(+), 71 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index 75518b4a253d..ad509a57a945 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -72,9 +72,60 @@ static const u8 ksz8795_shifts[] = {
 	[DYNAMIC_MAC_SRC_PORT]		= 24,
 };
 
-static const struct {
+static const u8 ksz8863_regs[] = {
+	[REG_IND_CTRL_0]		= 0x79,
+	[REG_IND_DATA_8]		= 0x7B,
+	[REG_IND_DATA_CHECK]		= 0x7B,
+	[REG_IND_DATA_HI]		= 0x7C,
+	[REG_IND_DATA_LO]		= 0x80,
+	[REG_IND_MIB_CHECK]		= 0x80,
+	[P_FORCE_CTRL]			= 0x0C,
+	[P_LINK_STATUS]			= 0x0E,
+	[P_LOCAL_CTRL]			= 0x0C,
+	[P_NEG_RESTART_CTRL]		= 0x0D,
+	[P_REMOTE_STATUS]		= 0x0E,
+	[P_SPEED_STATUS]		= 0x0F,
+	[S_TAIL_TAG_CTRL]		= 0x03,
+};
+
+static const u32 ksz8863_masks[] = {
+	[PORT_802_1P_REMAPPING]		= BIT(3),
+	[SW_TAIL_TAG_ENABLE]		= BIT(6),
+	[MIB_COUNTER_OVERFLOW]		= BIT(7),
+	[MIB_COUNTER_VALID]		= BIT(6),
+	[VLAN_TABLE_FID]		= GENMASK(15, 12),
+	[VLAN_TABLE_MEMBERSHIP]		= GENMASK(18, 16),
+	[VLAN_TABLE_VALID]		= BIT(19),
+	[STATIC_MAC_TABLE_VALID]	= BIT(19),
+	[STATIC_MAC_TABLE_USE_FID]	= BIT(21),
+	[STATIC_MAC_TABLE_FID]		= GENMASK(29, 26),
+	[STATIC_MAC_TABLE_OVERRIDE]	= BIT(20),
+	[STATIC_MAC_TABLE_FWD_PORTS]	= GENMASK(18, 16),
+	[DYNAMIC_MAC_TABLE_ENTRIES_H]	= GENMASK(5, 0),
+	[DYNAMIC_MAC_TABLE_MAC_EMPTY]	= BIT(7),
+	[DYNAMIC_MAC_TABLE_NOT_READY]	= BIT(7),
+	[DYNAMIC_MAC_TABLE_ENTRIES]	= GENMASK(31, 28),
+	[DYNAMIC_MAC_TABLE_FID]		= GENMASK(19, 16),
+	[DYNAMIC_MAC_TABLE_SRC_PORT]	= GENMASK(21, 20),
+	[DYNAMIC_MAC_TABLE_TIMESTAMP]	= GENMASK(23, 22),
+};
+
+static u8 ksz8863_shifts[] = {
+	[VLAN_TABLE_MEMBERSHIP_S]	= 16,
+	[STATIC_MAC_FWD_PORTS]		= 16,
+	[STATIC_MAC_FID]		= 22,
+	[DYNAMIC_MAC_ENTRIES_H]		= 3,
+	[DYNAMIC_MAC_ENTRIES]		= 24,
+	[DYNAMIC_MAC_FID]		= 16,
+	[DYNAMIC_MAC_TIMESTAMP]		= 24,
+	[DYNAMIC_MAC_SRC_PORT]		= 20,
+};
+
+struct mib_names {
 	char string[ETH_GSTRING_LEN];
-} mib_names[] = {
+};
+
+static const struct mib_names ksz87xx_mib_names[] = {
 	{ "rx_hi" },
 	{ "rx_undersize" },
 	{ "rx_fragments" },
@@ -113,6 +164,48 @@ static const struct {
 	{ "tx_discards" },
 };
 
+static const struct mib_names ksz88xx_mib_names[] = {
+	{ "rx" },
+	{ "rx_hi" },
+	{ "rx_undersize" },
+	{ "rx_fragments" },
+	{ "rx_oversize" },
+	{ "rx_jabbers" },
+	{ "rx_symbol_err" },
+	{ "rx_crc_err" },
+	{ "rx_align_err" },
+	{ "rx_mac_ctrl" },
+	{ "rx_pause" },
+	{ "rx_bcast" },
+	{ "rx_mcast" },
+	{ "rx_ucast" },
+	{ "rx_64_or_less" },
+	{ "rx_65_127" },
+	{ "rx_128_255" },
+	{ "rx_256_511" },
+	{ "rx_512_1023" },
+	{ "rx_1024_1522" },
+	{ "tx" },
+	{ "tx_hi" },
+	{ "tx_late_col" },
+	{ "tx_pause" },
+	{ "tx_bcast" },
+	{ "tx_mcast" },
+	{ "tx_ucast" },
+	{ "tx_deferred" },
+	{ "tx_total_col" },
+	{ "tx_exc_col" },
+	{ "tx_single_col" },
+	{ "tx_mult_col" },
+	{ "rx_discards" },
+	{ "tx_discards" },
+};
+
+static bool ksz_is_ksz88x3(struct ksz_device *dev)
+{
+	return dev->chip_id == 0x8830;
+}
+
 static void ksz_cfg(struct ksz_device *dev, u32 addr, u8 bits, bool set)
 {
 	regmap_update_bits(dev->regmap[0], addr, bits, set ? bits : 0);
@@ -127,10 +220,18 @@ static void ksz_port_cfg(struct ksz_device *dev, int port, int offset, u8 bits,
 
 static int ksz8_reset_switch(struct ksz_device *dev)
 {
-	/* reset switch */
-	ksz_write8(dev, REG_POWER_MANAGEMENT_1,
-		   SW_SOFTWARE_POWER_DOWN << SW_POWER_MANAGEMENT_MODE_S);
-	ksz_write8(dev, REG_POWER_MANAGEMENT_1, 0);
+	if (ksz_is_ksz88x3(dev)) {
+		/* reset switch */
+		ksz_cfg(dev, KSZ8863_REG_SW_RESET,
+			KSZ8863_GLOBAL_SOFTWARE_RESET | KSZ8863_PCS_RESET, true);
+		ksz_cfg(dev, KSZ8863_REG_SW_RESET,
+			KSZ8863_GLOBAL_SOFTWARE_RESET | KSZ8863_PCS_RESET, false);
+	} else {
+		/* reset switch */
+		ksz_write8(dev, REG_POWER_MANAGEMENT_1,
+			   SW_SOFTWARE_POWER_DOWN << SW_POWER_MANAGEMENT_MODE_S);
+		ksz_write8(dev, REG_POWER_MANAGEMENT_1, 0);
+	}
 
 	return 0;
 }
@@ -204,8 +305,8 @@ static void ksz8_r_mib_cnt(struct ksz_device *dev, int port, u16 addr, u64 *cnt)
 	mutex_unlock(&dev->alu_mutex);
 }
 
-static void ksz8_r_mib_pkt(struct ksz_device *dev, int port, u16 addr,
-			   u64 *dropped, u64 *cnt)
+static void ksz8795_r_mib_pkt(struct ksz_device *dev, int port, u16 addr,
+			      u64 *dropped, u64 *cnt)
 {
 	struct ksz8 *ksz8 = dev->priv;
 	const u32 *masks;
@@ -219,8 +320,8 @@ static void ksz8_r_mib_pkt(struct ksz_device *dev, int port, u16 addr,
 	regs = ksz8->regs;
 
 	addr -= dev->reg_mib_cnt;
-	ctrl_addr = (KS_MIB_TOTAL_RX_1 - KS_MIB_TOTAL_RX_0) * port;
-	ctrl_addr += addr + KS_MIB_TOTAL_RX_0;
+	ctrl_addr = (KSZ8795_MIB_TOTAL_RX_1 - KSZ8795_MIB_TOTAL_RX_0) * port;
+	ctrl_addr += addr + KSZ8795_MIB_TOTAL_RX_0;
 	ctrl_addr |= IND_ACC_TABLE(TABLE_MIB | TABLE_READ);
 
 	mutex_lock(&dev->alu_mutex);
@@ -257,8 +358,52 @@ static void ksz8_r_mib_pkt(struct ksz_device *dev, int port, u16 addr,
 	mutex_unlock(&dev->alu_mutex);
 }
 
+static void ksz8863_r_mib_pkt(struct ksz_device *dev, int port, u16 addr,
+			      u64 *dropped, u64 *cnt)
+{
+	struct ksz8 *ksz8 = dev->priv;
+	const u8 *regs = ksz8->regs;
+	u32 *last = (u32 *)dropped;
+	u16 ctrl_addr;
+	u32 data;
+	u32 cur;
+
+	addr -= dev->reg_mib_cnt;
+	ctrl_addr = addr ? KSZ8863_MIB_PACKET_DROPPED_TX_0 :
+			   KSZ8863_MIB_PACKET_DROPPED_RX_0;
+	ctrl_addr += port;
+	ctrl_addr |= IND_ACC_TABLE(TABLE_MIB | TABLE_READ);
+
+	mutex_lock(&dev->alu_mutex);
+	ksz_write16(dev, regs[REG_IND_CTRL_0], ctrl_addr);
+	ksz_read32(dev, regs[REG_IND_DATA_LO], &data);
+	mutex_unlock(&dev->alu_mutex);
+
+	data &= MIB_PACKET_DROPPED;
+	cur = last[addr];
+	if (data != cur) {
+		last[addr] = data;
+		if (data < cur)
+			data += MIB_PACKET_DROPPED + 1;
+		data -= cur;
+		*cnt += data;
+	}
+}
+
+static void ksz8_r_mib_pkt(struct ksz_device *dev, int port, u16 addr,
+			   u64 *dropped, u64 *cnt)
+{
+	if (ksz_is_ksz88x3(dev))
+		ksz8863_r_mib_pkt(dev, port, addr, dropped, cnt);
+	else
+		ksz8795_r_mib_pkt(dev, port, addr, dropped, cnt);
+}
+
 static void ksz8_freeze_mib(struct ksz_device *dev, int port, bool freeze)
 {
+	if (ksz_is_ksz88x3(dev))
+		return;
+
 	/* enable the port for flush/freeze function */
 	if (freeze)
 		ksz_cfg(dev, REG_SW_CTRL_6, BIT(port), true);
@@ -272,11 +417,14 @@ static void ksz8_freeze_mib(struct ksz_device *dev, int port, bool freeze)
 static void ksz8_port_init_cnt(struct ksz_device *dev, int port)
 {
 	struct ksz_port_mib *mib = &dev->ports[port].mib;
+	u64 *dropped;
 
-	/* flush all enabled port MIB counters */
-	ksz_cfg(dev, REG_SW_CTRL_6, BIT(port), true);
-	ksz_cfg(dev, REG_SW_CTRL_6, SW_MIB_COUNTER_FLUSH, true);
-	ksz_cfg(dev, REG_SW_CTRL_6, BIT(port), false);
+	if (!ksz_is_ksz88x3(dev)) {
+		/* flush all enabled port MIB counters */
+		ksz_cfg(dev, REG_SW_CTRL_6, BIT(port), true);
+		ksz_cfg(dev, REG_SW_CTRL_6, SW_MIB_COUNTER_FLUSH, true);
+		ksz_cfg(dev, REG_SW_CTRL_6, BIT(port), false);
+	}
 
 	mib->cnt_ptr = 0;
 
@@ -287,10 +435,13 @@ static void ksz8_port_init_cnt(struct ksz_device *dev, int port)
 		++mib->cnt_ptr;
 	}
 
+	/* last one in storage */
+	dropped = &mib->counters[dev->mib_cnt];
+
 	/* Some ports may not have MIB counters after SWITCH_COUNTER_NUM. */
 	while (mib->cnt_ptr < dev->mib_cnt) {
 		dev->dev_ops->r_mib_pkt(dev, port, mib->cnt_ptr,
-					NULL, &mib->counters[mib->cnt_ptr]);
+					dropped, &mib->counters[mib->cnt_ptr]);
 		++mib->cnt_ptr;
 	}
 	mib->cnt_ptr = 0;
@@ -588,8 +739,13 @@ static void ksz8_r_phy(struct ksz_device *dev, u16 phy, u16 reg, u16 *val)
 			data |= PHY_LOOPBACK;
 		if (ctrl & PORT_FORCE_100_MBIT)
 			data |= PHY_SPEED_100MBIT;
-		if (!(ctrl & PORT_AUTO_NEG_DISABLE))
-			data |= PHY_AUTO_NEG_ENABLE;
+		if (ksz_is_ksz88x3(dev)) {
+			if ((ctrl & PORT_AUTO_NEG_ENABLE))
+				data |= PHY_AUTO_NEG_ENABLE;
+		} else {
+			if (!(ctrl & PORT_AUTO_NEG_DISABLE))
+				data |= PHY_AUTO_NEG_ENABLE;
+		}
 		if (restart & PORT_POWER_DOWN)
 			data |= PHY_POWER_DOWN;
 		if (restart & PORT_AUTO_NEG_RESTART)
@@ -623,7 +779,10 @@ static void ksz8_r_phy(struct ksz_device *dev, u16 phy, u16 reg, u16 *val)
 		data = KSZ8795_ID_HI;
 		break;
 	case PHY_REG_ID_2:
-		data = KSZ8795_ID_LO;
+		if (ksz_is_ksz88x3(dev))
+			data = KSZ8863_ID_LO;
+		else
+			data = KSZ8795_ID_LO;
 		break;
 	case PHY_REG_AUTO_NEGOTIATION:
 		ksz_pread8(dev, p, regs[P_LOCAL_CTRL], &ctrl);
@@ -686,14 +845,22 @@ static void ksz8_w_phy(struct ksz_device *dev, u16 phy, u16 reg, u16 val)
 			ksz_pwrite8(dev, p, regs[P_SPEED_STATUS], data);
 		ksz_pread8(dev, p, regs[P_FORCE_CTRL], &ctrl);
 		data = ctrl;
-		if (!(val & PHY_AUTO_NEG_ENABLE))
-			data |= PORT_AUTO_NEG_DISABLE;
-		else
-			data &= ~PORT_AUTO_NEG_DISABLE;
+		if (ksz_is_ksz88x3(dev)) {
+			if ((val & PHY_AUTO_NEG_ENABLE))
+				data |= PORT_AUTO_NEG_ENABLE;
+			else
+				data &= ~PORT_AUTO_NEG_ENABLE;
+		} else {
+			if (!(val & PHY_AUTO_NEG_ENABLE))
+				data |= PORT_AUTO_NEG_DISABLE;
+			else
+				data &= ~PORT_AUTO_NEG_DISABLE;
+
+			/* Fiber port does not support auto-negotiation. */
+			if (dev->ports[p].fiber)
+				data |= PORT_AUTO_NEG_DISABLE;
+		}
 
-		/* Fiber port does not support auto-negotiation. */
-		if (dev->ports[p].fiber)
-			data |= PORT_AUTO_NEG_DISABLE;
 		if (val & PHY_SPEED_100MBIT)
 			data |= PORT_FORCE_100_MBIT;
 		else
@@ -767,7 +934,11 @@ static enum dsa_tag_protocol ksz8_get_tag_protocol(struct dsa_switch *ds,
 						   int port,
 						   enum dsa_tag_protocol mp)
 {
-	return DSA_TAG_PROTO_KSZ8795;
+	struct ksz_device *dev = ds->priv;
+
+	/* ksz88x3 uses the same tag schema as KSZ9893 */
+	return ksz_is_ksz88x3(dev) ?
+		DSA_TAG_PROTO_KSZ9893 : DSA_TAG_PROTO_KSZ8795;
 }
 
 static void ksz8_get_strings(struct dsa_switch *ds, int port,
@@ -777,8 +948,8 @@ static void ksz8_get_strings(struct dsa_switch *ds, int port,
 	int i;
 
 	for (i = 0; i < dev->mib_cnt; i++) {
-		memcpy(buf + i * ETH_GSTRING_LEN, mib_names[i].string,
-		       ETH_GSTRING_LEN);
+		memcpy(buf + i * ETH_GSTRING_LEN,
+		       dev->mib_names[i].string, ETH_GSTRING_LEN);
 	}
 }
 
@@ -904,6 +1075,9 @@ static int ksz8_port_vlan_filtering(struct dsa_switch *ds, int port, bool flag,
 {
 	struct ksz_device *dev = ds->priv;
 
+	if (ksz_is_ksz88x3(dev))
+		return -ENOTSUPP;
+
 	ksz_cfg(dev, S_MIRROR_CTRL, SW_VLAN_ENABLE, flag);
 
 	return 0;
@@ -918,6 +1092,9 @@ static int ksz8_port_vlan_add(struct dsa_switch *ds, int port,
 	u16 data, new_pvid = 0;
 	u8 fid, member, valid;
 
+	if (ksz_is_ksz88x3(dev))
+		return -ENOTSUPP;
+
 	ksz_port_cfg(dev, port, P_TAG_CTRL, PORT_REMOVE_TAG, untagged);
 
 	ksz8_r_vlan_table(dev, vlan->vid, &data);
@@ -958,6 +1135,9 @@ static int ksz8_port_vlan_del(struct dsa_switch *ds, int port,
 	u16 data, pvid, new_pvid = 0;
 	u8 fid, member, valid;
 
+	if (ksz_is_ksz88x3(dev))
+		return -ENOTSUPP;
+
 	ksz_pread16(dev, port, REG_PORT_CTRL_VID, &pvid);
 	pvid = pvid & 0xFFF;
 
@@ -1091,7 +1271,8 @@ static void ksz8_port_setup(struct ksz_device *dev, int port, bool cpu_port)
 	/* enable broadcast storm limit */
 	ksz_port_cfg(dev, port, P_BCAST_STORM_CTRL, PORT_BROADCAST_STORM, true);
 
-	ksz8795_set_prio_queue(dev, port, 4);
+	if (!ksz_is_ksz88x3(dev))
+		ksz8795_set_prio_queue(dev, port, 4);
 
 	/* disable DiffServ priority */
 	ksz_port_cfg(dev, port, P_PRIO_CTRL, PORT_DIFFSERV_ENABLE, false);
@@ -1104,7 +1285,8 @@ static void ksz8_port_setup(struct ksz_device *dev, int port, bool cpu_port)
 	ksz_port_cfg(dev, port, P_PRIO_CTRL, PORT_802_1P_ENABLE, true);
 
 	if (cpu_port) {
-		ksz8795_cpu_interface_select(dev, port);
+		if (!ksz_is_ksz88x3(dev))
+			ksz8795_cpu_interface_select(dev, port);
 
 		member = dev->port_mask;
 	} else {
@@ -1156,9 +1338,11 @@ static void ksz8_config_cpu_port(struct dsa_switch *ds)
 		p = &dev->ports[i];
 		if (!p->on)
 			continue;
-		ksz_pread8(dev, i, regs[P_REMOTE_STATUS], &remote);
-		if (remote & PORT_FIBER_MODE)
-			p->fiber = 1;
+		if (!ksz_is_ksz88x3(dev)) {
+			ksz_pread8(dev, i, regs[P_REMOTE_STATUS], &remote);
+			if (remote & PORT_FIBER_MODE)
+				p->fiber = 1;
+		}
 		if (p->fiber)
 			ksz_port_cfg(dev, i, P_STP_CTRL, PORT_FORCE_FLOW_CTRL,
 				     true);
@@ -1277,19 +1461,30 @@ static int ksz8_switch_detect(struct ksz_device *dev)
 
 	id1 = id16 >> 8;
 	id2 = id16 & SW_CHIP_ID_M;
-	if (id1 != FAMILY_ID ||
-	    (id2 != CHIP_ID_94 && id2 != CHIP_ID_95))
-		return -ENODEV;
 
-	if (id2 == CHIP_ID_95) {
-		u8 val;
+	switch (id1) {
+	case KSZ87_FAMILY_ID:
+		if ((id2 != CHIP_ID_94 && id2 != CHIP_ID_95))
+			return -ENODEV;
+
+		if (id2 == CHIP_ID_95) {
+			u8 val;
 
-		id2 = 0x95;
-		ksz_read8(dev, REG_PORT_1_STATUS_0, &val);
-		if (val & PORT_FIBER_MODE)
-			id2 = 0x65;
-	} else if (id2 == CHIP_ID_94) {
-		id2 = 0x94;
+			id2 = 0x95;
+			ksz_read8(dev, REG_PORT_STATUS_0, &val);
+			if (val & PORT_FIBER_MODE)
+				id2 = 0x65;
+		} else if (id2 == CHIP_ID_94) {
+			id2 = 0x94;
+		}
+		break;
+	case KSZ88_FAMILY_ID:
+		if (id2 != CHIP_ID_63)
+			return -ENODEV;
+		break;
+	default:
+		dev_err(dev->dev, "invalid family id: %d\n", id1);
+		return -ENODEV;
 	}
 	id16 &= ~0xff;
 	id16 |= id2;
@@ -1350,6 +1545,15 @@ static const struct ksz_chip_data ksz8_switch_chips[] = {
 		.cpu_ports = 0x10,	/* can be configured as cpu port */
 		.port_cnt = 5,		/* total cpu and user ports */
 	},
+	{
+		.chip_id = 0x8830,
+		.dev_name = "KSZ8863/KSZ8873",
+		.num_vlans = 16,
+		.num_alus = 0,
+		.num_statics = 8,
+		.cpu_ports = 0x4,	/* can be configured as cpu port */
+		.port_cnt = 3,
+	},
 };
 
 static int ksz8_switch_init(struct ksz_device *dev)
@@ -1382,12 +1586,21 @@ static int ksz8_switch_init(struct ksz_device *dev)
 	if (!dev->cpu_ports)
 		return -ENODEV;
 
-	ksz8->regs = ksz8795_regs;
-	ksz8->masks = ksz8795_masks;
-	ksz8->shifts = ksz8795_shifts;
+	if (ksz_is_ksz88x3(dev)) {
+		ksz8->regs = ksz8863_regs;
+		ksz8->masks = ksz8863_masks;
+		ksz8->shifts = ksz8863_shifts;
+		dev->mib_cnt = ARRAY_SIZE(ksz88xx_mib_names);
+		dev->mib_names = ksz88xx_mib_names;
+	} else {
+		ksz8->regs = ksz8795_regs;
+		ksz8->masks = ksz8795_masks;
+		ksz8->shifts = ksz8795_shifts;
+		dev->mib_cnt = ARRAY_SIZE(ksz87xx_mib_names);
+		dev->mib_names = ksz87xx_mib_names;
+	}
 
-	dev->reg_mib_cnt = KSZ8795_COUNTER_NUM;
-	dev->mib_cnt = ARRAY_SIZE(mib_names);
+	dev->reg_mib_cnt = MIB_COUNTER_NUM;
 
 	dev->ports = devm_kzalloc(dev->dev,
 				  dev->port_cnt * sizeof(struct ksz_port),
diff --git a/drivers/net/dsa/microchip/ksz8795_reg.h b/drivers/net/dsa/microchip/ksz8795_reg.h
index eea78c5636a0..c2e52c40a54c 100644
--- a/drivers/net/dsa/microchip/ksz8795_reg.h
+++ b/drivers/net/dsa/microchip/ksz8795_reg.h
@@ -16,7 +16,8 @@
 
 #define REG_CHIP_ID0			0x00
 
-#define FAMILY_ID			0x87
+#define KSZ87_FAMILY_ID			0x87
+#define KSZ88_FAMILY_ID			0x88
 
 #define REG_CHIP_ID1			0x01
 
@@ -28,6 +29,12 @@
 
 #define CHIP_ID_94			0x60
 #define CHIP_ID_95			0x90
+#define CHIP_ID_63			0x30
+
+#define KSZ8863_REG_SW_RESET		0x43
+
+#define KSZ8863_GLOBAL_SOFTWARE_RESET	BIT(4)
+#define KSZ8863_PCS_RESET		BIT(0)
 
 #define REG_SW_CTRL_0			0x02
 
@@ -267,6 +274,7 @@
 #define REG_PORT_3_CTRL_9		0x3C
 #define REG_PORT_4_CTRL_9		0x4C
 
+#define PORT_AUTO_NEG_ENABLE		BIT(7)
 #define PORT_AUTO_NEG_DISABLE		BIT(7)
 #define PORT_FORCE_100_MBIT		BIT(6)
 #define PORT_FORCE_FULL_DUPLEX		BIT(5)
@@ -800,6 +808,7 @@
 
 #define KSZ8795_ID_HI			0x0022
 #define KSZ8795_ID_LO			0x1550
+#define KSZ8863_ID_LO			0x1430
 
 #define KSZ8795_SW_ID			0x8795
 
@@ -830,7 +839,7 @@
 
 #define KS_PRIO_IN_REG			4
 
-#define KSZ8795_COUNTER_NUM		0x20
+#define MIB_COUNTER_NUM		0x20
 
 /* Common names used by other drivers */
 
@@ -876,26 +885,13 @@
 
 #define MIB_COUNTER_VALUE		0x3FFFFFFF
 
-#define KS_MIB_TOTAL_RX_0		0x100
-#define KS_MIB_TOTAL_TX_0		0x101
-#define KS_MIB_PACKET_DROPPED_RX_0	0x102
-#define KS_MIB_PACKET_DROPPED_TX_0	0x103
-#define KS_MIB_TOTAL_RX_1		0x104
-#define KS_MIB_TOTAL_TX_1		0x105
-#define KS_MIB_PACKET_DROPPED_TX_1	0x106
-#define KS_MIB_PACKET_DROPPED_RX_1	0x107
-#define KS_MIB_TOTAL_RX_2		0x108
-#define KS_MIB_TOTAL_TX_2		0x109
-#define KS_MIB_PACKET_DROPPED_TX_2	0x10A
-#define KS_MIB_PACKET_DROPPED_RX_2	0x10B
-#define KS_MIB_TOTAL_RX_3		0x10C
-#define KS_MIB_TOTAL_TX_3		0x10D
-#define KS_MIB_PACKET_DROPPED_TX_3	0x10E
-#define KS_MIB_PACKET_DROPPED_RX_3	0x10F
-#define KS_MIB_TOTAL_RX_4		0x110
-#define KS_MIB_TOTAL_TX_4		0x111
-#define KS_MIB_PACKET_DROPPED_TX_4	0x112
-#define KS_MIB_PACKET_DROPPED_RX_4	0x113
+#define KSZ8795_MIB_TOTAL_RX_0		0x100
+#define KSZ8795_MIB_TOTAL_TX_0		0x101
+#define KSZ8795_MIB_TOTAL_RX_1		0x104
+#define KSZ8795_MIB_TOTAL_TX_1		0x105
+
+#define KSZ8863_MIB_PACKET_DROPPED_TX_0 0x100
+#define KSZ8863_MIB_PACKET_DROPPED_RX_0 0x105
 
 #define MIB_PACKET_DROPPED		0x0000FFFF
 
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index f0681a891cca..e0bbdca64375 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -71,6 +71,7 @@ struct ksz_device {
 	int port_cnt;
 	int reg_mib_cnt;
 	int mib_cnt;
+	const struct mib_names *mib_names;
 	phy_interface_t compat_interface;
 	u32 regs_size;
 	bool phy_errata_9477;
-- 
2.29.2

