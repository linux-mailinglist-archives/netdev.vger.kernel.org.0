Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7585C2D1137
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 13:57:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726346AbgLGM5d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 07:57:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726063AbgLGM5c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 07:57:32 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2C3AC061A51
        for <netdev@vger.kernel.org>; Mon,  7 Dec 2020 04:56:32 -0800 (PST)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mgr@pengutronix.de>)
        id 1kmG47-0002od-7F; Mon, 07 Dec 2020 13:56:31 +0100
Received: from mgr by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <mgr@pengutronix.de>)
        id 1kmG45-0008OA-2J; Mon, 07 Dec 2020 13:56:29 +0100
From:   Michael Grzeschik <m.grzeschik@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, davem@davemloft.net,
        kernel@pengutronix.de, matthias.schiffer@ew.tq-group.com,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com
Subject: [PATCH v5 4/6] net: dsa: microchip: ksz8795: add support for ksz88xx chips
Date:   Mon,  7 Dec 2020 13:56:25 +0100
Message-Id: <20201207125627.30843-5-m.grzeschik@pengutronix.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201207125627.30843-1-m.grzeschik@pengutronix.de>
References: <20201207125627.30843-1-m.grzeschik@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: mgr@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We add support for the ksz8863 and ksz8873 chips which are
using the same register patterns but other offsets as the
ksz8795.

Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>

---
v1 -> v4: - extracted this change from bigger previous patch
v4 -> v5: - added clear of reset bit for ksz8863 reset code
          - using extra device flag IS_KSZ88x3 instead of is_ksz8795 function
	  - using DSA_TAG_PROTO_KSZ9893 protocol for ksz88x3 instead
---
 drivers/net/dsa/microchip/ksz8795.c     | 345 +++++++++++++++++++-----
 drivers/net/dsa/microchip/ksz8795_reg.h |  40 ++-
 drivers/net/dsa/microchip/ksz_common.h  |   1 +
 3 files changed, 299 insertions(+), 87 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index 127498a9b8f72..9484667a29a35 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -22,6 +22,9 @@
 #include "ksz8795_reg.h"
 #include "ksz8.h"
 
+/* Used with variable features to indicate capabilities. */
+#define IS_88X3				BIT(0)
+
 static const u8 ksz8795_regs[] = {
 	[REG_IND_CTRL_0]		= 0x6E,
 	[REG_IND_DATA_8]		= 0x70,
@@ -72,9 +75,60 @@ static const u8 ksz8795_shifts[] = {
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
+	[VLAN_TABLE_MEMBERSHIP]		= 16,
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
@@ -113,6 +167,43 @@ static const struct {
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
 static void ksz_cfg(struct ksz_device *dev, u32 addr, u8 bits, bool set)
 {
 	regmap_update_bits(dev->regmap[0], addr, bits, set ? bits : 0);
@@ -127,10 +218,18 @@ static void ksz_port_cfg(struct ksz_device *dev, int port, int offset, u8 bits,
 
 static int ksz8_reset_switch(struct ksz_device *dev)
 {
-	/* reset switch */
-	ksz_write8(dev, REG_POWER_MANAGEMENT_1,
-		   SW_SOFTWARE_POWER_DOWN << SW_POWER_MANAGEMENT_MODE_S);
-	ksz_write8(dev, REG_POWER_MANAGEMENT_1, 0);
+	if (dev->features & IS_88X3) {
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
@@ -201,8 +300,8 @@ static void ksz8_r_mib_cnt(struct ksz_device *dev, int port, u16 addr, u64 *cnt)
 	mutex_unlock(&dev->alu_mutex);
 }
 
-static void ksz8_r_mib_pkt(struct ksz_device *dev, int port, u16 addr,
-			   u64 *dropped, u64 *cnt)
+static void ksz8795_r_mib_pkt(struct ksz_device *dev, int port, u16 addr,
+			      u64 *dropped, u64 *cnt)
 {
 	struct ksz8 *ksz8 = dev->priv;
 	const u8 *regs = ksz8->regs;
@@ -213,8 +312,8 @@ static void ksz8_r_mib_pkt(struct ksz_device *dev, int port, u16 addr,
 	int loop;
 
 	addr -= dev->reg_mib_cnt;
-	ctrl_addr = (KS_MIB_TOTAL_RX_1 - KS_MIB_TOTAL_RX_0) * port;
-	ctrl_addr += addr + KS_MIB_TOTAL_RX_0;
+	ctrl_addr = (KSZ8795_MIB_TOTAL_RX_1 - KSZ8795_MIB_TOTAL_RX_0) * port;
+	ctrl_addr += addr + KSZ8795_MIB_TOTAL_RX_0;
 	ctrl_addr |= IND_ACC_TABLE(TABLE_MIB | TABLE_READ);
 
 	mutex_lock(&dev->alu_mutex);
@@ -251,8 +350,53 @@ static void ksz8_r_mib_pkt(struct ksz_device *dev, int port, u16 addr,
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
+	if (dev->features & IS_88X3) {
+		ksz8863_r_mib_pkt(dev, port, addr, dropped, cnt);
+	} else {
+		ksz8795_r_mib_pkt(dev, port, addr, dropped, cnt);
+	}
+}
+
 static void ksz8_freeze_mib(struct ksz_device *dev, int port, bool freeze)
 {
+	if (dev->features & IS_88X3)
+		return;
+
 	/* enable the port for flush/freeze function */
 	if (freeze)
 		ksz_cfg(dev, REG_SW_CTRL_6, BIT(port), true);
@@ -267,10 +411,12 @@ static void ksz8_port_init_cnt(struct ksz_device *dev, int port)
 {
 	struct ksz_port_mib *mib = &dev->ports[port].mib;
 
-	/* flush all enabled port MIB counters */
-	ksz_cfg(dev, REG_SW_CTRL_6, BIT(port), true);
-	ksz_cfg(dev, REG_SW_CTRL_6, SW_MIB_COUNTER_FLUSH, true);
-	ksz_cfg(dev, REG_SW_CTRL_6, BIT(port), false);
+	if (!(dev->features & IS_88X3)) {
+		/* flush all enabled port MIB counters */
+		ksz_cfg(dev, REG_SW_CTRL_6, BIT(port), true);
+		ksz_cfg(dev, REG_SW_CTRL_6, SW_MIB_COUNTER_FLUSH, true);
+		ksz_cfg(dev, REG_SW_CTRL_6, BIT(port), false);
+	}
 
 	mib->cnt_ptr = 0;
 
@@ -508,37 +654,46 @@ static void ksz8_r_vlan_entries(struct ksz_device *dev, u16 addr)
 	ksz8_r_table(dev, TABLE_VLAN, addr, &data);
 	addr *= dev->phy_port_cnt;
 	for (i = 0; i < dev->phy_port_cnt; i++) {
-		dev->vlan_cache[addr + i].table[0] = (u16)data;
-		data >>= shifts[VLAN_TABLE];
+		if (dev->features & IS_88X3) {
+			dev->vlan_cache[addr + i].table[0] = (u32)data;
+		} else {
+			dev->vlan_cache[addr + i].table[0] = (u16)data;
+			data >>= shifts[VLAN_TABLE];
+		}
+
 	}
 }
 
 static void ksz8_r_vlan_table(struct ksz_device *dev, u16 vid, u32 *vlan)
 {
-	int index;
-	u16 *data;
-	u16 addr;
+	u16 addr = vid / dev->phy_port_cnt;
 	u64 buf;
 
-	data = (u16 *)&buf;
-	addr = vid / dev->phy_port_cnt;
-	index = vid & 3;
 	ksz8_r_table(dev, TABLE_VLAN, addr, &buf);
-	*vlan = data[index];
+	if (dev->features & IS_88X3) {
+		*vlan = (u32)buf;
+	} else {
+		u16 *data = (u16 *)&buf;
+
+		*vlan = data[vid & 3];
+	}
 }
 
 static void ksz8_w_vlan_table(struct ksz_device *dev, u16 vid, u32 vlan)
 {
-	int index;
-	u16 *data;
-	u16 addr;
+	u16 addr = vid / dev->phy_port_cnt;
 	u64 buf;
 
-	data = (u16 *)&buf;
-	addr = vid / dev->phy_port_cnt;
-	index = vid & 3;
 	ksz8_r_table(dev, TABLE_VLAN, addr, &buf);
-	data[index] = vlan;
+
+	if (dev->features & IS_88X3) {
+		buf = vlan;
+	} else {
+		u16 *data = (u16 *)&buf;
+
+		data[vid & 3] = vlan;
+	}
+
 	dev->vlan_cache[vid].table[0] = vlan;
 	ksz8_w_table(dev, TABLE_VLAN, addr, buf);
 }
@@ -561,8 +716,13 @@ static void ksz8_r_phy(struct ksz_device *dev, u16 phy, u16 reg, u16 *val)
 			data |= PHY_LOOPBACK;
 		if (ctrl & PORT_FORCE_100_MBIT)
 			data |= PHY_SPEED_100MBIT;
-		if (!(ctrl & PORT_AUTO_NEG_DISABLE))
-			data |= PHY_AUTO_NEG_ENABLE;
+		if (dev->features & IS_88X3) {
+			if ((ctrl & PORT_AUTO_NEG_ENABLE))
+				data |= PHY_AUTO_NEG_ENABLE;
+		} else {
+			if (!(ctrl & PORT_AUTO_NEG_DISABLE))
+				data |= PHY_AUTO_NEG_ENABLE;
+		}
 		if (restart & PORT_POWER_DOWN)
 			data |= PHY_POWER_DOWN;
 		if (restart & PORT_AUTO_NEG_RESTART)
@@ -596,7 +756,10 @@ static void ksz8_r_phy(struct ksz_device *dev, u16 phy, u16 reg, u16 *val)
 		data = KSZ8795_ID_HI;
 		break;
 	case PHY_REG_ID_2:
-		data = KSZ8795_ID_LO;
+		if (dev->features & IS_88X3)
+			data = KSZ8863_ID_LO;
+		else
+			data = KSZ8795_ID_LO;
 		break;
 	case PHY_REG_AUTO_NEGOTIATION:
 		ksz_pread8(dev, p, regs[P_LOCAL_CTRL], &ctrl);
@@ -659,14 +822,22 @@ static void ksz8_w_phy(struct ksz_device *dev, u16 phy, u16 reg, u16 val)
 			ksz_pwrite8(dev, p, regs[P_SPEED_STATUS], data);
 		ksz_pread8(dev, p, regs[P_FORCE_CTRL], &ctrl);
 		data = ctrl;
-		if (!(val & PHY_AUTO_NEG_ENABLE))
-			data |= PORT_AUTO_NEG_DISABLE;
-		else
-			data &= ~PORT_AUTO_NEG_DISABLE;
+		if (dev->features & IS_88X3) {
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
@@ -740,7 +911,11 @@ static enum dsa_tag_protocol ksz8_get_tag_protocol(struct dsa_switch *ds,
 						   int port,
 						   enum dsa_tag_protocol mp)
 {
-	return DSA_TAG_PROTO_KSZ8795;
+	struct ksz_device *dev = ds->priv;
+
+	/* ksz88x3 uses the same tag schema as KSZ9893 */
+	return (dev->features & IS_88X3)  ?
+		DSA_TAG_PROTO_KSZ9893 : DSA_TAG_PROTO_KSZ8795;
 }
 
 static void ksz8_get_strings(struct dsa_switch *ds, int port,
@@ -750,17 +925,21 @@ static void ksz8_get_strings(struct dsa_switch *ds, int port,
 	int i;
 
 	for (i = 0; i < dev->mib_cnt; i++) {
-		memcpy(buf + i * ETH_GSTRING_LEN, mib_names[i].string,
-		       ETH_GSTRING_LEN);
+		memcpy(buf + i * ETH_GSTRING_LEN,
+		       dev->mib_names[i].string, ETH_GSTRING_LEN);
 	}
 }
 
 static void ksz8_cfg_port_member(struct ksz_device *dev, int port, u8 member)
 {
+	int membership = PORT_VLAN_MEMBERSHIP;
 	u8 data;
 
+	if (dev->features & IS_88X3)
+		membership = (membership >> 2);
+
 	ksz_pread8(dev, port, P_MIRROR_CTRL, &data);
-	data &= ~PORT_VLAN_MEMBERSHIP;
+	data &= ~(membership);
 	data |= (member & dev->port_mask);
 	ksz_pwrite8(dev, port, P_MIRROR_CTRL, data);
 	dev->ports[port].member = member;
@@ -1065,7 +1244,8 @@ static void ksz8_port_setup(struct ksz_device *dev, int port, bool cpu_port)
 	/* enable broadcast storm limit */
 	ksz_port_cfg(dev, port, P_BCAST_STORM_CTRL, PORT_BROADCAST_STORM, true);
 
-	ksz8795_set_prio_queue(dev, port, 4);
+	if (!(dev->features & IS_88X3))
+		ksz8795_set_prio_queue(dev, port, 4);
 
 	/* disable DiffServ priority */
 	ksz_port_cfg(dev, port, P_PRIO_CTRL, PORT_DIFFSERV_ENABLE, false);
@@ -1078,7 +1258,8 @@ static void ksz8_port_setup(struct ksz_device *dev, int port, bool cpu_port)
 	ksz_port_cfg(dev, port, P_PRIO_CTRL, PORT_802_1P_ENABLE, true);
 
 	if (cpu_port) {
-		ksz8795_cpu_interface_select(dev, port);
+		if (!(dev->features & IS_88X3))
+			ksz8795_cpu_interface_select(dev, port);
 
 		member = dev->port_mask;
 	} else {
@@ -1128,9 +1309,11 @@ static void ksz8_config_cpu_port(struct dsa_switch *ds)
 		p = &dev->ports[i];
 		if (!p->on)
 			continue;
-		ksz_pread8(dev, i, regs[P_REMOTE_STATUS], &remote);
-		if (remote & PORT_FIBER_MODE)
-			p->fiber = 1;
+		if (!(dev->features & IS_88X3)) {
+			ksz_pread8(dev, i, regs[P_REMOTE_STATUS], &remote);
+			if (remote & PORT_FIBER_MODE)
+				p->fiber = 1;
+		}
 		if (p->fiber)
 			ksz_port_cfg(dev, i, P_STP_CTRL, PORT_FORCE_FLOW_CTRL,
 				     true);
@@ -1249,19 +1432,33 @@ static int ksz8_switch_detect(struct ksz_device *dev)
 
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
 
-		id2 = 0x95;
-		ksz_read8(dev, REG_PORT_1_STATUS_0, &val);
-		if (val & PORT_FIBER_MODE)
-			id2 = 0x65;
-	} else if (id2 == CHIP_ID_94) {
-		id2 = 0x94;
+		if (id2 == CHIP_ID_95) {
+			u8 val;
+
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
+
+		dev->features |= IS_88X3;
+
+		break;
+	default:
+		dev_err(dev->dev, "invalid family id: %d\n", id1);
+		return -ENODEV;
 	}
 	id16 &= ~0xff;
 	id16 |= id2;
@@ -1308,6 +1505,15 @@ static const struct ksz_chip_data ksz8_switch_chips[] = {
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
@@ -1336,15 +1542,24 @@ static int ksz8_switch_init(struct ksz_device *dev)
 	if (!dev->cpu_ports)
 		return -ENODEV;
 
-	ksz8->regs = ksz8795_regs;
-	ksz8->masks = ksz8795_masks;
-	ksz8->shifts = ksz8795_shifts;
+	if (dev->features & IS_88X3) {
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
 
 	dev->port_mask = BIT(dev->port_cnt) - 1;
 	dev->port_mask |= dev->host_mask;
 
-	dev->reg_mib_cnt = KSZ8795_COUNTER_NUM;
-	dev->mib_cnt = ARRAY_SIZE(mib_names);
+	dev->reg_mib_cnt = MIB_COUNTER_NUM;
 
 	dev->phy_port_cnt = dev->port_cnt - 1;
 
diff --git a/drivers/net/dsa/microchip/ksz8795_reg.h b/drivers/net/dsa/microchip/ksz8795_reg.h
index eea78c5636a0f..c2e52c40a54c5 100644
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
index 49f4b882bd708..af9e94049912d 100644
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

