Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 027B3239F42
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 07:47:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728302AbgHCFpS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 01:45:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728183AbgHCFpC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 01:45:02 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F381C061757
        for <netdev@vger.kernel.org>; Sun,  2 Aug 2020 22:45:02 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mgr@pengutronix.de>)
        id 1k2THQ-0005JG-F9; Mon, 03 Aug 2020 07:45:00 +0200
Received: from mgr by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <mgr@pengutronix.de>)
        id 1k2THL-0005UH-0L; Mon, 03 Aug 2020 07:44:55 +0200
From:   Michael Grzeschik <m.grzeschik@pengutronix.de>
To:     andrew@lunn.ch
Cc:     netdev@vger.kernel.org, f.fainelli@gmail.com, davem@davemloft.net,
        kernel@pengutronix.de
Subject: [PATCH v4 08/11] net: dsa: microchip: ksz8795: add support for ksz88xx chips
Date:   Mon,  3 Aug 2020 07:44:39 +0200
Message-Id: <20200803054442.20089-9-m.grzeschik@pengutronix.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200803054442.20089-1-m.grzeschik@pengutronix.de>
References: <20200803054442.20089-1-m.grzeschik@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: mgr@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We add support for the ksz8863 and ksz8873 chips which are
using the same register patterns but other offsets as the
ksz8795.

Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>

---
v1 -> v4: - extracted this change from bigger previous patch

 drivers/net/dsa/microchip/ksz8795.c     | 541 +++++++++++++++++-------
 drivers/net/dsa/microchip/ksz8795_reg.h | 214 +++++-----
 drivers/net/dsa/microchip/ksz8863_reg.h | 124 ++++++
 3 files changed, 629 insertions(+), 250 deletions(-)
 create mode 100644 drivers/net/dsa/microchip/ksz8863_reg.h

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index 480143905d75579..4531bc413001c1e 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -20,50 +20,109 @@
 
 #include "ksz_common.h"
 #include "ksz8795_reg.h"
+#include "ksz8863_reg.h"
 #include "ksz8.h"
 
 static struct ksz_regs ksz8795_regs = {
-	.ind_ctrl_0			= REG_IND_CTRL_0,
-	.ind_data_8			= REG_IND_DATA_8,
-	.ind_data_check			= REG_IND_DATA_CHECK,
-	.ind_data_hi			= REG_IND_DATA_HI,
-	.ind_data_lo			= REG_IND_DATA_LO,
-	.ind_mib_check			= REG_IND_MIB_CHECK,
-	.p_force_ctrl			= P_FORCE_CTRL,
-	.p_link_status			= P_LINK_STATUS,
-	.p_local_ctrl			= P_LOCAL_CTRL,
-	.p_neg_restart_ctrl		= P_NEG_RESTART_CTRL,
-	.p_remote_status		= P_REMOTE_STATUS,
-	.p_speed_status			= P_SPEED_STATUS,
-	.s_tail_tag_ctrl		= S_TAIL_TAG_CTRL,
+	.ind_ctrl_0			= KSZ8795_REG_IND_CTRL_0,
+	.ind_data_8			= KSZ8795_REG_IND_DATA_8,
+	.ind_data_check			= KSZ8795_REG_IND_DATA_CHECK,
+	.ind_data_hi			= KSZ8795_REG_IND_DATA_HI,
+	.ind_data_lo			= KSZ8795_REG_IND_DATA_LO,
+	.ind_mib_check			= KSZ8795_REG_IND_MIB_CHECK,
+	.p_force_ctrl			= KSZ8795_P_FORCE_CTRL,
+	.p_link_status			= KSZ8795_P_LINK_STATUS,
+	.p_local_ctrl			= KSZ8795_P_LOCAL_CTRL,
+	.p_neg_restart_ctrl		= KSZ8795_P_NEG_RESTART_CTRL,
+	.p_remote_status		= KSZ8795_P_REMOTE_STATUS,
+	.p_speed_status			= KSZ8795_P_SPEED_STATUS,
+	.s_tail_tag_ctrl		= KSZ8795_S_TAIL_TAG_CTRL,
 };
 
 static struct ksz_masks ksz8795_masks = {
-	.port_802_1p_remapping		= PORT_802_1P_REMAPPING,
-	.sw_tail_tag_enable		= SW_TAIL_TAG_ENABLE,
-	.mib_counter_overflow		= MIB_COUNTER_OVERFLOW,
-	.mib_counter_valid		= MIB_COUNTER_VALID,
-	.vlan_table_fid			= VLAN_TABLE_FID,
-	.vlan_table_membership		= VLAN_TABLE_MEMBERSHIP,
-	.vlan_table_valid		= VLAN_TABLE_VALID,
-	.static_mac_table_valid		= STATIC_MAC_TABLE_VALID,
-	.static_mac_table_use_fid	= STATIC_MAC_TABLE_USE_FID,
-	.static_mac_table_fid		= STATIC_MAC_TABLE_FID,
-	.static_mac_table_override	= STATIC_MAC_TABLE_OVERRIDE,
-	.static_mac_table_fwd_ports	= STATIC_MAC_TABLE_FWD_PORTS,
-	.dynamic_mac_table_entries_h	= DYNAMIC_MAC_TABLE_ENTRIES_H,
-	.dynamic_mac_table_mac_empty	= DYNAMIC_MAC_TABLE_MAC_EMPTY,
-	.dynamic_mac_table_not_ready	= DYNAMIC_MAC_TABLE_NOT_READY,
-	.dynamic_mac_table_entries	= DYNAMIC_MAC_TABLE_ENTRIES,
-	.dynamic_mac_table_fid		= DYNAMIC_MAC_TABLE_FID,
-	.dynamic_mac_table_src_port	= DYNAMIC_MAC_TABLE_SRC_PORT,
-	.dynamic_mac_table_timestamp	= DYNAMIC_MAC_TABLE_TIMESTAMP,
+	.port_802_1p_remapping		= KSZ8795_PORT_802_1P_REMAPPING,
+	.sw_tail_tag_enable		= KSZ8795_SW_TAIL_TAG_ENABLE,
+	.mib_counter_overflow		= KSZ8795_MIB_COUNTER_OVERFLOW,
+	.mib_counter_valid		= KSZ8795_MIB_COUNTER_VALID,
+	.vlan_table_fid			= KSZ8795_VLAN_TABLE_FID,
+	.vlan_table_membership		= KSZ8795_VLAN_TABLE_MEMBERSHIP,
+	.vlan_table_valid		= KSZ8795_VLAN_TABLE_VALID,
+	.static_mac_table_valid		= KSZ8795_STATIC_MAC_TABLE_VALID,
+	.static_mac_table_use_fid	= KSZ8795_STATIC_MAC_TABLE_USE_FID,
+	.static_mac_table_fid		= KSZ8795_STATIC_MAC_TABLE_FID,
+	.static_mac_table_override	= KSZ8795_STATIC_MAC_TABLE_OVERRIDE,
+	.static_mac_table_fwd_ports	= KSZ8795_STATIC_MAC_TABLE_FWD_PORTS,
+	.dynamic_mac_table_entries_h	= KSZ8795_DYNAMIC_MAC_TABLE_ENTRIES_H,
+	.dynamic_mac_table_mac_empty	= KSZ8795_DYNAMIC_MAC_TABLE_MAC_EMPTY,
+	.dynamic_mac_table_not_ready	= KSZ8795_DYNAMIC_MAC_TABLE_NOT_READY,
+	.dynamic_mac_table_entries	= KSZ8795_DYNAMIC_MAC_TABLE_ENTRIES,
+	.dynamic_mac_table_fid		= KSZ8795_DYNAMIC_MAC_TABLE_FID,
+	.dynamic_mac_table_src_port	= KSZ8795_DYNAMIC_MAC_TABLE_SRC_PORT,
+	.dynamic_mac_table_timestamp	= KSZ8795_DYNAMIC_MAC_TABLE_TIMESTAMP,
 };
 
+static struct ksz_shifts ksz8795_shifts = {
+	.vlan_table_membership		= KSZ8795_VLAN_TABLE_MEMBERSHIP_S,
+	.vlan_table			= KSZ8795_VLAN_TABLE_S,
+	.static_mac_fwd_ports		= KSZ8795_STATIC_MAC_FWD_PORTS_S,
+	.static_mac_fid			= KSZ8795_STATIC_MAC_FID_S,
+	.dynamic_mac_entries		= KSZ8795_DYNAMIC_MAC_ENTRIES_S,
+	.dynamic_mac_fid		= KSZ8795_DYNAMIC_MAC_FID_S,
+	.dynamic_mac_timestamp		= KSZ8795_DYNAMIC_MAC_TIMESTAMP_S,
+	.dynamic_mac_src_port		= KSZ8795_DYNAMIC_MAC_SRC_PORT_S,
+};
+
+static struct ksz_regs ksz8863_regs = {
+	.ind_ctrl_0			= KSZ8863_REG_IND_CTRL_0,
+	.ind_data_8			= KSZ8863_REG_IND_DATA_8,
+	.ind_data_check			= KSZ8863_REG_IND_DATA_CHECK,
+	.ind_data_hi			= KSZ8863_REG_IND_DATA_HI,
+	.ind_data_lo			= KSZ8863_REG_IND_DATA_LO,
+	.ind_mib_check			= KSZ8863_REG_IND_MIB_CHECK,
+	.p_force_ctrl			= KSZ8863_P_FORCE_CTRL,
+	.p_link_status			= KSZ8863_P_LINK_STATUS,
+	.p_local_ctrl			= KSZ8863_P_LOCAL_CTRL,
+	.p_neg_restart_ctrl		= KSZ8863_P_NEG_RESTART_CTRL,
+	.p_remote_status		= KSZ8863_P_REMOTE_STATUS,
+	.p_speed_status			= KSZ8863_P_SPEED_STATUS,
+	.s_tail_tag_ctrl		= KSZ8863_S_TAIL_TAG_CTRL,
+};
+
+static struct ksz_masks ksz8863_masks = {
+	.port_802_1p_remapping		= KSZ8863_PORT_802_1P_REMAPPING,
+	.sw_tail_tag_enable		= KSZ8863_SW_TAIL_TAG_ENABLE,
+	.mib_counter_overflow		= KSZ8863_MIB_COUNTER_OVERFLOW,
+	.mib_counter_valid		= KSZ8863_MIB_COUNTER_VALID,
+	.vlan_table_fid			= KSZ8863_VLAN_TABLE_FID,
+	.vlan_table_membership		= KSZ8863_VLAN_TABLE_MEMBERSHIP,
+	.vlan_table_valid		= KSZ8863_VLAN_TABLE_VALID,
+	.static_mac_table_valid		= KSZ8863_STATIC_MAC_TABLE_VALID,
+	.static_mac_table_use_fid	= KSZ8863_STATIC_MAC_TABLE_USE_FID,
+	.static_mac_table_fid		= KSZ8863_STATIC_MAC_TABLE_FID,
+	.static_mac_table_override	= KSZ8863_STATIC_MAC_TABLE_OVERRIDE,
+	.static_mac_table_fwd_ports	= KSZ8863_STATIC_MAC_TABLE_FWD_PORTS,
+	.dynamic_mac_table_entries_h	= KSZ8863_DYNAMIC_MAC_TABLE_ENTRIES_H,
+	.dynamic_mac_table_mac_empty	= KSZ8863_DYNAMIC_MAC_TABLE_MAC_EMPTY,
+	.dynamic_mac_table_not_ready	= KSZ8863_DYNAMIC_MAC_TABLE_NOT_READY,
+	.dynamic_mac_table_entries	= KSZ8863_DYNAMIC_MAC_TABLE_ENTRIES,
+	.dynamic_mac_table_fid		= KSZ8863_DYNAMIC_MAC_TABLE_FID,
+	.dynamic_mac_table_src_port	= KSZ8863_DYNAMIC_MAC_TABLE_SRC_PORT,
+	.dynamic_mac_table_timestamp	= KSZ8863_DYNAMIC_MAC_TABLE_TIMESTAMP,
+};
+
+static struct ksz_shifts ksz8863_shifts = {
+	.vlan_table_membership		= KSZ8863_VLAN_TABLE_MEMBERSHIP_S,
+	.static_mac_fwd_ports		= KSZ8863_STATIC_MAC_FWD_PORTS_S,
+	.static_mac_fid			= KSZ8863_STATIC_MAC_FID_S,
+	.dynamic_mac_entries		= KSZ8863_DYNAMIC_MAC_ENTRIES_S,
+	.dynamic_mac_fid		= KSZ8863_DYNAMIC_MAC_FID_S,
+	.dynamic_mac_timestamp		= KSZ8863_DYNAMIC_MAC_TIMESTAMP_S,
+	.dynamic_mac_src_port		= KSZ8863_DYNAMIC_MAC_SRC_PORT_S,
+};
 
 static const struct {
 	char string[ETH_GSTRING_LEN];
-} mib_names[TOTAL_SWITCH_COUNTER_NUM] = {
+} ksz87xx_mib_names[TOTAL_KSZ8795_COUNTER_NUM] = {
 	{ "rx_hi" },
 	{ "rx_undersize" },
 	{ "rx_fragments" },
@@ -102,6 +161,45 @@ static const struct {
 	{ "tx_discards" },
 };
 
+static const struct {
+	char string[ETH_GSTRING_LEN];
+} ksz88xx_mib_names[TOTAL_KSZ8863_COUNTER_NUM] = {
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
@@ -114,12 +212,23 @@ static void ksz_port_cfg(struct ksz_device *dev, int port, int offset, u8 bits,
 			   bits, set ? bits : 0);
 }
 
+static int ksz_is_87(struct ksz_device *dev)
+{
+	return (((dev->chip_id) >> 8) == KSZ87_FAMILY_ID);
+}
+
 static int ksz8_reset_switch(struct ksz_device *dev)
 {
-	/* reset switch */
-	ksz_write8(dev, REG_POWER_MANAGEMENT_1,
-		   SW_SOFTWARE_POWER_DOWN << SW_POWER_MANAGEMENT_MODE_S);
-	ksz_write8(dev, REG_POWER_MANAGEMENT_1, 0);
+	if (ksz_is_87(dev)) {
+		/* reset switch */
+		ksz_write8(dev, REG_POWER_MANAGEMENT_1,
+			   SW_SOFTWARE_POWER_DOWN << SW_POWER_MANAGEMENT_MODE_S);
+		ksz_write8(dev, REG_POWER_MANAGEMENT_1, 0);
+	} else {
+		/* reset switch */
+		ksz_cfg(dev, KSZ8863_REG_SW_RESET,
+			KSZ8863_GLOBAL_SOFTWARE_RESET | KSZ8863_PCS_RESET, true);
+	}
 
 	return 0;
 }
@@ -190,8 +299,8 @@ static void ksz8_r_mib_cnt(struct ksz_device *dev, int port, u16 addr, u64 *cnt)
 	mutex_unlock(&dev->alu_mutex);
 }
 
-static void ksz8_r_mib_pkt(struct ksz_device *dev, int port, u16 addr,
-			   u64 *dropped, u64 *cnt)
+static void ksz8795_r_mib_pkt(struct ksz_device *dev, int port, u16 addr,
+			      u64 *dropped, u64 *cnt)
 {
 	struct ksz8 *ksz8 = dev->priv;
 	struct ksz_regs *regs = ksz8->regs;
@@ -200,9 +309,9 @@ static void ksz8_r_mib_pkt(struct ksz_device *dev, int port, u16 addr,
 	u8 check;
 	int loop;
 
-	addr -= SWITCH_COUNTER_NUM;
-	ctrl_addr = (KS_MIB_TOTAL_RX_1 - KS_MIB_TOTAL_RX_0) * port;
-	ctrl_addr += addr + KS_MIB_TOTAL_RX_0;
+	addr -= dev->reg_mib_cnt;
+	ctrl_addr = (KSZ8795_MIB_TOTAL_RX_1 - KSZ8795_MIB_TOTAL_RX_0) * port;
+	ctrl_addr += addr + KSZ8795_MIB_TOTAL_RX_0;
 	ctrl_addr |= IND_ACC_TABLE(TABLE_MIB | TABLE_READ);
 
 	mutex_lock(&dev->alu_mutex);
@@ -214,7 +323,7 @@ static void ksz8_r_mib_pkt(struct ksz_device *dev, int port, u16 addr,
 	for (loop = 2; loop > 0; loop--) {
 		ksz_read8(dev, regs->ind_mib_check, &check);
 
-		if (check & MIB_COUNTER_VALID) {
+		if (check & KSZ8795_MIB_COUNTER_VALID) {
 			ksz_read32(dev, regs->ind_data_lo, &data);
 			if (addr < 2) {
 				u64 total;
@@ -223,13 +332,13 @@ static void ksz8_r_mib_pkt(struct ksz_device *dev, int port, u16 addr,
 				total <<= 32;
 				*cnt += total;
 				*cnt += data;
-				if (check & MIB_COUNTER_OVERFLOW) {
+				if (check & KSZ8795_MIB_COUNTER_OVERFLOW) {
 					total = MIB_TOTAL_BYTES_H + 1;
 					total <<= 32;
 					*cnt += total;
 				}
 			} else {
-				if (check & MIB_COUNTER_OVERFLOW)
+				if (check & KSZ8795_MIB_COUNTER_OVERFLOW)
 					*cnt += MIB_PACKET_DROPPED + 1;
 				*cnt += data & MIB_PACKET_DROPPED;
 			}
@@ -239,8 +348,53 @@ static void ksz8_r_mib_pkt(struct ksz_device *dev, int port, u16 addr,
 	mutex_unlock(&dev->alu_mutex);
 }
 
+static void ksz8863_r_mib_pkt(struct ksz_device *dev, int port, u16 addr,
+			      u64 *dropped, u64 *cnt)
+{
+	struct ksz8 *ksz8 = dev->priv;
+	struct ksz_regs *regs = ksz8->regs;
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
+	ksz_write16(dev, regs->ind_ctrl_0, ctrl_addr);
+	ksz_read32(dev, regs->ind_data_lo, &data);
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
+	if (ksz_is_87(dev)) {
+		ksz8795_r_mib_pkt(dev, port, addr, dropped, cnt);
+	} else {
+		ksz8863_r_mib_pkt(dev, port, addr, dropped, cnt);
+	}
+}
+
 static void ksz8_freeze_mib(struct ksz_device *dev, int port, bool freeze)
 {
+	if (!ksz_is_87(dev))
+		return;
+
 	/* enable the port for flush/freeze function */
 	if (freeze)
 		ksz_cfg(dev, REG_SW_CTRL_6, BIT(port), true);
@@ -254,11 +408,14 @@ static void ksz8_freeze_mib(struct ksz_device *dev, int port, bool freeze)
 static void ksz8_port_init_cnt(struct ksz_device *dev, int port)
 {
 	struct ksz_port_mib *mib = &dev->ports[port].mib;
+	u64 *dropped;
 
-	/* flush all enabled port MIB counters */
-	ksz_cfg(dev, REG_SW_CTRL_6, BIT(port), true);
-	ksz_cfg(dev, REG_SW_CTRL_6, SW_MIB_COUNTER_FLUSH, true);
-	ksz_cfg(dev, REG_SW_CTRL_6, BIT(port), false);
+	if (ksz_is_87(dev)) {
+		/* flush all enabled port MIB counters */
+		ksz_cfg(dev, REG_SW_CTRL_6, BIT(port), true);
+		ksz_cfg(dev, REG_SW_CTRL_6, SW_MIB_COUNTER_FLUSH, true);
+		ksz_cfg(dev, REG_SW_CTRL_6, BIT(port), false);
+	}
 
 	mib->cnt_ptr = 0;
 
@@ -269,10 +426,13 @@ static void ksz8_port_init_cnt(struct ksz_device *dev, int port)
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
@@ -420,6 +580,7 @@ static int ksz8_r_sta_mac_table(struct ksz_device *dev, u16 addr,
 		alu->is_override =
 			(data_hi & masks->static_mac_table_override) ? 1 : 0;
 		data_hi >>= 1;
+		alu->is_static = true;
 		alu->is_use_fid =
 			(data_hi & masks->static_mac_table_use_fid) ? 1 : 0;
 		alu->fid = (data_hi & masks->static_mac_table_fid) >>
@@ -495,37 +656,45 @@ static void ksz8_r_vlan_entries(struct ksz_device *dev, u16 addr)
 	ksz8_r_table(dev, TABLE_VLAN, addr, &data);
 	addr *= dev->port_cnt;
 	for (i = 0; i < dev->port_cnt; i++) {
-		dev->vlan_cache[addr + i].table[0] = (u16)data;
-		data >>= shifts->vlan_table;
+		if (ksz_is_87(dev)) {
+			dev->vlan_cache[addr + i].table[0] = (u16)data;
+			data >>= shifts->vlan_table;
+		} else {
+			dev->vlan_cache[addr + i].table[0] = (u32)data;
+		}
 	}
 }
 
 static void ksz8_r_vlan_table(struct ksz_device *dev, u16 vid, u32 *vlan)
 {
-	int index;
-	u16 *data;
-	u16 addr;
+	u16 addr = vid / dev->port_cnt;
 	u64 buf;
 
-	data = (u16 *)&buf;
-	addr = vid / dev->port_cnt;
-	index = vid & 3;
 	ksz8_r_table(dev, TABLE_VLAN, addr, &buf);
-	*vlan = data[index];
+	if (ksz_is_87(dev)) {
+		u16 *data = (u16 *)&buf;
+
+		*vlan = data[vid & 3];
+	} else {
+		*vlan = (u32)buf;
+	}
 }
 
 static void ksz8_w_vlan_table(struct ksz_device *dev, u16 vid, u32 vlan)
 {
-	int index;
-	u16 *data;
-	u16 addr;
+	u16 addr = vid / dev->port_cnt;
 	u64 buf;
 
-	data = (u16 *)&buf;
-	addr = vid / dev->port_cnt;
-	index = vid & 3;
 	ksz8_r_table(dev, TABLE_VLAN, addr, &buf);
-	data[index] = vlan;
+
+	if (ksz_is_87(dev)) {
+		u16 *data = (u16 *)&buf;
+
+		data[vid & 3] = vlan;
+	} else {
+		buf = vlan;
+	}
+
 	dev->vlan_cache[vid].table[0] = vlan;
 	ksz8_w_table(dev, TABLE_VLAN, addr, buf);
 }
@@ -548,8 +717,13 @@ static void ksz8_r_phy(struct ksz_device *dev, u16 phy, u16 reg, u16 *val)
 			data |= PHY_LOOPBACK;
 		if (ctrl & PORT_FORCE_100_MBIT)
 			data |= PHY_SPEED_100MBIT;
-		if (!(ctrl & PORT_AUTO_NEG_DISABLE))
-			data |= PHY_AUTO_NEG_ENABLE;
+		if (ksz_is_87(dev)) {
+			if (!(ctrl & PORT_AUTO_NEG_DISABLE))
+				data |= PHY_AUTO_NEG_ENABLE;
+		} else {
+			if ((ctrl & PORT_AUTO_NEG_ENABLE))
+				data |= PHY_AUTO_NEG_ENABLE;
+		}
 		if (restart & PORT_POWER_DOWN)
 			data |= PHY_POWER_DOWN;
 		if (restart & PORT_AUTO_NEG_RESTART)
@@ -580,10 +754,16 @@ static void ksz8_r_phy(struct ksz_device *dev, u16 phy, u16 reg, u16 *val)
 			data |= PHY_LINK_STATUS;
 		break;
 	case PHY_REG_ID_1:
-		data = KSZ8795_ID_HI;
+		if (ksz_is_87(dev))
+			data = KSZ8795_ID_HI;
+		else
+			data = KSZ8863_ID_HI;
 		break;
 	case PHY_REG_ID_2:
-		data = KSZ8795_ID_LO;
+		if (ksz_is_87(dev))
+			data = KSZ8795_ID_LO;
+		else
+			data = KSZ8863_ID_LO;
 		break;
 	case PHY_REG_AUTO_NEGOTIATION:
 		ksz_pread8(dev, p, regs->p_local_ctrl, &ctrl);
@@ -646,14 +826,21 @@ static void ksz8_w_phy(struct ksz_device *dev, u16 phy, u16 reg, u16 val)
 			ksz_pwrite8(dev, p, regs->p_speed_status, data);
 		ksz_pread8(dev, p, regs->p_force_ctrl, &ctrl);
 		data = ctrl;
-		if (!(val & PHY_AUTO_NEG_ENABLE))
-			data |= PORT_AUTO_NEG_DISABLE;
-		else
-			data &= ~PORT_AUTO_NEG_DISABLE;
-
-		/* Fiber port does not support auto-negotiation. */
-		if (dev->ports[p].fiber)
-			data |= PORT_AUTO_NEG_DISABLE;
+		if (ksz_is_87(dev)) {
+			if (!(val & PHY_AUTO_NEG_ENABLE))
+				data |= PORT_AUTO_NEG_DISABLE;
+			else
+				data &= ~PORT_AUTO_NEG_DISABLE;
+
+			/* Fiber port does not support auto-negotiation. */
+			if (dev->ports[p].fiber)
+				data |= PORT_AUTO_NEG_DISABLE;
+		} else {
+			if ((val & PHY_AUTO_NEG_ENABLE))
+				data |= PORT_AUTO_NEG_ENABLE;
+			else
+				data &= ~PORT_AUTO_NEG_ENABLE;
+		}
 		if (val & PHY_SPEED_100MBIT)
 			data |= PORT_FORCE_100_MBIT;
 		else
@@ -727,26 +914,46 @@ static enum dsa_tag_protocol ksz8_get_tag_protocol(struct dsa_switch *ds,
 						   int port,
 						   enum dsa_tag_protocol mp)
 {
-	return DSA_TAG_PROTO_KSZ8795;
+	struct ksz_device *dev = ds->priv;
+
+	return ksz_is_87(dev) ?
+		DSA_TAG_PROTO_KSZ8795 : DSA_TAG_PROTO_KSZ8863;
 }
 
 static void ksz8_get_strings(struct dsa_switch *ds, int port,
 			     u32 stringset, uint8_t *buf)
 {
+	struct ksz_device *dev = ds->priv;
+	int switch_counter;
 	int i;
 
-	for (i = 0; i < TOTAL_SWITCH_COUNTER_NUM; i++) {
-		memcpy(buf + i * ETH_GSTRING_LEN, mib_names[i].string,
-		       ETH_GSTRING_LEN);
+	if (ksz_is_87(dev))
+		switch_counter = TOTAL_KSZ8795_COUNTER_NUM;
+	else
+		switch_counter = TOTAL_KSZ8863_COUNTER_NUM;
+
+	for (i = 0; i < switch_counter; i++) {
+		const char *s;
+
+		if (ksz_is_87(dev))
+			s = ksz87xx_mib_names[i].string;
+		else
+			s = ksz88xx_mib_names[i].string;
+
+		memcpy(buf + i * ETH_GSTRING_LEN, s, ETH_GSTRING_LEN);
 	}
 }
 
 static void ksz8_cfg_port_member(struct ksz_device *dev, int port, u8 member)
 {
+	int membership = PORT_VLAN_MEMBERSHIP;
 	u8 data;
 
+	if (!ksz_is_87(dev))
+		membership = (membership >> 2);
+
 	ksz_pread8(dev, port, P_MIRROR_CTRL, &data);
-	data &= ~PORT_VLAN_MEMBERSHIP;
+	data &= ~(membership);
 	data |= (member & dev->port_mask);
 	ksz_pwrite8(dev, port, P_MIRROR_CTRL, data);
 	dev->ports[port].member = member;
@@ -990,17 +1197,58 @@ static void ksz8_port_mirror_del(struct dsa_switch *ds, int port,
 			     PORT_MIRROR_SNIFFER, false);
 }
 
+static void ksz8795_cpu_interface_select(struct ksz_device *dev, int port)
+{
+	struct ksz_port *p = &dev->ports[port];
+	u8 data8;
+
+	/* Configure MII interface for proper network communication. */
+	ksz_read8(dev, REG_PORT_5_CTRL_6, &data8);
+	data8 &= ~PORT_INTERFACE_TYPE;
+	data8 &= ~PORT_GMII_1GPS_MODE;
+	switch (dev->interface) {
+	case PHY_INTERFACE_MODE_MII:
+		p->phydev.speed = SPEED_100;
+		break;
+	case PHY_INTERFACE_MODE_RMII:
+		data8 |= PORT_INTERFACE_RMII;
+		p->phydev.speed = SPEED_100;
+		break;
+	case PHY_INTERFACE_MODE_GMII:
+		data8 |= PORT_GMII_1GPS_MODE;
+		data8 |= PORT_INTERFACE_GMII;
+		p->phydev.speed = SPEED_1000;
+		break;
+	default:
+		data8 &= ~PORT_RGMII_ID_IN_ENABLE;
+		data8 &= ~PORT_RGMII_ID_OUT_ENABLE;
+		if (dev->interface == PHY_INTERFACE_MODE_RGMII_ID ||
+		    dev->interface == PHY_INTERFACE_MODE_RGMII_RXID)
+			data8 |= PORT_RGMII_ID_IN_ENABLE;
+		if (dev->interface == PHY_INTERFACE_MODE_RGMII_ID ||
+		    dev->interface == PHY_INTERFACE_MODE_RGMII_TXID)
+			data8 |= PORT_RGMII_ID_OUT_ENABLE;
+		data8 |= PORT_GMII_1GPS_MODE;
+		data8 |= PORT_INTERFACE_RGMII;
+		p->phydev.speed = SPEED_1000;
+		break;
+	}
+	ksz_write8(dev, REG_PORT_5_CTRL_6, data8);
+	p->phydev.duplex = 1;
+}
+
 static void ksz8_port_setup(struct ksz_device *dev, int port, bool cpu_port)
 {
 	struct ksz_port *p = &dev->ports[port];
-	u8 data8, member;
+	u8 member;
 	struct ksz8 *ksz8 = dev->priv;
 	struct ksz_masks *masks = ksz8->masks;
 
 	/* enable broadcast storm limit */
 	ksz_port_cfg(dev, port, P_BCAST_STORM_CTRL, PORT_BROADCAST_STORM, true);
 
-	ksz8795_set_prio_queue(dev, port, 4);
+	if (ksz_is_87(dev))
+		ksz8795_set_prio_queue(dev, port, 4);
 
 	/* disable DiffServ priority */
 	ksz_port_cfg(dev, port, P_PRIO_CTRL, PORT_DIFFSERV_ENABLE, false);
@@ -1013,39 +1261,8 @@ static void ksz8_port_setup(struct ksz_device *dev, int port, bool cpu_port)
 	ksz_port_cfg(dev, port, P_PRIO_CTRL, PORT_802_1P_ENABLE, true);
 
 	if (cpu_port) {
-		/* Configure MII interface for proper network communication. */
-		ksz_read8(dev, REG_PORT_5_CTRL_6, &data8);
-		data8 &= ~PORT_INTERFACE_TYPE;
-		data8 &= ~PORT_GMII_1GPS_MODE;
-		switch (dev->interface) {
-		case PHY_INTERFACE_MODE_MII:
-			p->phydev.speed = SPEED_100;
-			break;
-		case PHY_INTERFACE_MODE_RMII:
-			data8 |= PORT_INTERFACE_RMII;
-			p->phydev.speed = SPEED_100;
-			break;
-		case PHY_INTERFACE_MODE_GMII:
-			data8 |= PORT_GMII_1GPS_MODE;
-			data8 |= PORT_INTERFACE_GMII;
-			p->phydev.speed = SPEED_1000;
-			break;
-		default:
-			data8 &= ~PORT_RGMII_ID_IN_ENABLE;
-			data8 &= ~PORT_RGMII_ID_OUT_ENABLE;
-			if (dev->interface == PHY_INTERFACE_MODE_RGMII_ID ||
-			    dev->interface == PHY_INTERFACE_MODE_RGMII_RXID)
-				data8 |= PORT_RGMII_ID_IN_ENABLE;
-			if (dev->interface == PHY_INTERFACE_MODE_RGMII_ID ||
-			    dev->interface == PHY_INTERFACE_MODE_RGMII_TXID)
-				data8 |= PORT_RGMII_ID_OUT_ENABLE;
-			data8 |= PORT_GMII_1GPS_MODE;
-			data8 |= PORT_INTERFACE_RGMII;
-			p->phydev.speed = SPEED_1000;
-			break;
-		}
-		ksz_write8(dev, REG_PORT_5_CTRL_6, data8);
-		p->phydev.duplex = 1;
+		if (ksz_is_87(dev))
+			ksz8795_cpu_interface_select(dev, port);
 
 		member = dev->port_mask;
 	} else {
@@ -1097,9 +1314,11 @@ static void ksz8_config_cpu_port(struct dsa_switch *ds)
 		p = &dev->ports[i];
 		if (!p->on)
 			continue;
-		ksz_pread8(dev, i, regs->p_remote_status, &remote);
-		if (remote & PORT_FIBER_MODE)
-			p->fiber = 1;
+		if (ksz_is_87(dev)) {
+			ksz_pread8(dev, i, regs->p_remote_status, &remote);
+			if (remote & PORT_FIBER_MODE)
+				p->fiber = 1;
+		}
 		if (p->fiber)
 			ksz_port_cfg(dev, i, P_STP_CTRL, PORT_FORCE_FLOW_CTRL,
 				     true);
@@ -1120,7 +1339,7 @@ static int ksz8_setup(struct dsa_switch *ds)
 	if (!dev->vlan_cache)
 		return -ENOMEM;
 
-	ret = ksz8_reset_switch(dev);
+	ksz8_reset_switch(dev);
 	if (ret) {
 		dev_err(ds->dev, "failed to reset switch\n");
 		return ret;
@@ -1157,7 +1376,7 @@ static int ksz8_setup(struct dsa_switch *ds)
 			   (BROADCAST_STORM_VALUE *
 			   BROADCAST_STORM_PROT_RATE) / 100);
 
-	for (i = 0; i < VLAN_TABLE_ENTRIES; i++)
+	for (i = 0; i < (dev->num_vlans / 2); i++)
 		ksz8_r_vlan_entries(dev, i);
 
 	/* Setup STP address for STP operation. */
@@ -1218,25 +1437,39 @@ static int ksz8_switch_detect(struct ksz_device *dev)
 
 	id1 = id16 >> 8;
 	id2 = id16 & SW_CHIP_ID_M;
-	if (id1 != FAMILY_ID ||
-	    (id2 != CHIP_ID_94 && id2 != CHIP_ID_95))
-		return -ENODEV;
 
-	dev->mib_port_cnt = TOTAL_PORT_NUM;
-	dev->phy_port_cnt = SWITCH_PORT_NUM;
-	dev->port_cnt = SWITCH_PORT_NUM;
-
-	if (id2 == CHIP_ID_95) {
-		u8 val;
-
-		id2 = 0x95;
-		ksz_read8(dev, REG_PORT_1_STATUS_0, &val);
-		if (val & PORT_FIBER_MODE)
-			id2 = 0x65;
-	} else if (id2 == CHIP_ID_94) {
-		dev->port_cnt--;
-		dev->last_port = dev->port_cnt;
-		id2 = 0x94;
+	switch (id1) {
+	case KSZ87_FAMILY_ID:
+		if ((id2 != CHIP_ID_94 && id2 != CHIP_ID_95))
+			return -ENODEV;
+
+		dev->mib_port_cnt = KSZ8795_TOTAL_PORT_NUM;
+		dev->phy_port_cnt = KSZ8795_SWITCH_PORT_NUM;
+		dev->port_cnt = KSZ8795_SWITCH_PORT_NUM;
+		if (id2 == CHIP_ID_95) {
+			u8 val;
+
+			id2 = 0x95;
+			ksz_read8(dev, KSZ8795_REG_PORT_STATUS_0, &val);
+			if (val & PORT_FIBER_MODE)
+				id2 = 0x65;
+		} else if (id2 == CHIP_ID_94) {
+			dev->port_cnt--;
+			dev->last_port = dev->port_cnt;
+			id2 = 0x94;
+		}
+		break;
+	case KSZ88_FAMILY_ID:
+		if (id2 != CHIP_ID_63)
+			return -ENODEV;
+
+		dev->mib_port_cnt = KSZ8863_TOTAL_PORT_NUM;
+		dev->phy_port_cnt = KSZ8863_SWITCH_PORT_NUM;
+		dev->port_cnt = KSZ8863_SWITCH_PORT_NUM;
+		break;
+	default:
+		dev_err(dev->dev, "invalid family id: %d\n", id1);
+		return -ENODEV;
 	}
 	id16 &= ~0xff;
 	id16 |= id2;
@@ -1286,6 +1519,15 @@ static const struct ksz_chip_data ksz8_switch_chips[] = {
 		.cpu_ports = 0x10,	/* can be configured as cpu port */
 		.port_cnt = 4,		/* total physical port count */
 	},
+	{
+		.chip_id = 0x8830,
+		.dev_name = "KSZ8863/KSZ8873",
+		.num_vlans = 16,
+		.num_alus = 0,
+		.num_statics = 8,
+		.cpu_ports = 0x4,	/* can be configured as cpu port */
+		.port_cnt = 2,		/* total physical port count */
+	},
 };
 
 static int ksz8_switch_init(struct ksz_device *dev)
@@ -1314,15 +1556,22 @@ static int ksz8_switch_init(struct ksz_device *dev)
 	if (!dev->cpu_ports)
 		return -ENODEV;
 
-	ksz8->regs = &ksz8795_regs;
-	ksz8->masks = &ksz8795_masks;
-	ksz8->shifts = &ksz8795_shifts;
+	if (ksz_is_87(dev)) {
+		ksz8->regs = &ksz8795_regs;
+		ksz8->masks = &ksz8795_masks;
+		ksz8->shifts = &ksz8795_shifts;
+		dev->mib_cnt = TOTAL_KSZ8795_COUNTER_NUM;
+	} else {
+		ksz8->regs = &ksz8863_regs;
+		ksz8->masks = &ksz8863_masks;
+		ksz8->shifts = &ksz8863_shifts;
+		dev->mib_cnt = TOTAL_KSZ8863_COUNTER_NUM;
+	}
 
 	dev->port_mask = BIT(dev->port_cnt) - 1;
 	dev->port_mask |= dev->host_mask;
 
 	dev->reg_mib_cnt = SWITCH_COUNTER_NUM;
-	dev->mib_cnt = TOTAL_SWITCH_COUNTER_NUM;
 
 	i = dev->mib_port_cnt;
 	dev->ports = devm_kzalloc(dev->dev, sizeof(struct ksz_port) * i,
@@ -1334,7 +1583,7 @@ static int ksz8_switch_init(struct ksz_device *dev)
 		dev->ports[i].mib.counters =
 			devm_kzalloc(dev->dev,
 				     sizeof(u64) *
-				     (TOTAL_SWITCH_COUNTER_NUM + 1),
+				     (dev->mib_cnt + 1),
 				     GFP_KERNEL);
 		if (!dev->ports[i].mib.counters)
 			return -ENOMEM;
diff --git a/drivers/net/dsa/microchip/ksz8795_reg.h b/drivers/net/dsa/microchip/ksz8795_reg.h
index 3a50462df8fa9d2..ed543ceac6b7d7b 100644
--- a/drivers/net/dsa/microchip/ksz8795_reg.h
+++ b/drivers/net/dsa/microchip/ksz8795_reg.h
@@ -16,7 +16,7 @@
 
 #define REG_CHIP_ID0			0x00
 
-#define FAMILY_ID			0x87
+#define KSZ87_FAMILY_ID			0x87
 
 #define REG_CHIP_ID1			0x01
 
@@ -32,7 +32,7 @@
 #define REG_SW_CTRL_0			0x02
 
 #define SW_NEW_BACKOFF			BIT(7)
-#define SW_GLOBAL_RESET			BIT(6)
+#define KSZ8795_SW_GLOBAL_RESET			BIT(6)
 #define SW_FLUSH_DYN_MAC_TABLE		BIT(5)
 #define SW_FLUSH_STA_MAC_TABLE		BIT(4)
 #define SW_LINK_AUTO_AGING		BIT(0)
@@ -98,7 +98,7 @@
 
 #define REG_SW_CTRL_10			0x0C
 
-#define SW_TAIL_TAG_ENABLE		BIT(1)
+#define KSZ8795_SW_TAIL_TAG_ENABLE		BIT(1)
 #define SW_PASS_PAUSE			BIT(0)
 
 #define REG_SW_CTRL_11			0x0D
@@ -150,7 +150,7 @@
 #define REG_PORT_4_CTRL_2		0x42
 #define REG_PORT_5_CTRL_2		0x52
 
-#define PORT_802_1P_REMAPPING		BIT(7)
+#define KSZ8795_PORT_802_1P_REMAPPING		BIT(7)
 #define PORT_INGRESS_FILTER		BIT(6)
 #define PORT_DISCARD_NON_VID		BIT(5)
 #define PORT_FORCE_FLOW_CTRL		BIT(4)
@@ -269,6 +269,7 @@
 #define REG_PORT_3_CTRL_9		0x3C
 #define REG_PORT_4_CTRL_9		0x4C
 
+#define PORT_AUTO_NEG_ENABLE		BIT(7)
 #define PORT_AUTO_NEG_DISABLE		BIT(7)
 #define PORT_FORCE_100_MBIT		BIT(6)
 #define PORT_FORCE_FULL_DUPLEX		BIT(5)
@@ -320,30 +321,36 @@
 #define REG_PORT_CTRL_5			0x05
 
 #define REG_PORT_CTRL_7			0x07
-#define REG_PORT_STATUS_0		0x08
-#define REG_PORT_STATUS_1		0x09
+
+#define KSZ8795_REG_PORT_STATUS_0		0x08
+#define KSZ8795_REG_PORT_STATUS_1		0x09
+
 #define REG_PORT_LINK_MD_CTRL		0x0A
 #define REG_PORT_LINK_MD_RESULT		0x0B
-#define REG_PORT_CTRL_9			0x0C
-#define REG_PORT_CTRL_10		0x0D
-#define REG_PORT_STATUS_2		0x0E
-#define REG_PORT_STATUS_3		0x0F
-
-#define REG_PORT_CTRL_12		0xA0
-#define REG_PORT_CTRL_13		0xA1
-#define REG_PORT_RATE_CTRL_3		0xA2
-#define REG_PORT_RATE_CTRL_2		0xA3
-#define REG_PORT_RATE_CTRL_1		0xA4
-#define REG_PORT_RATE_CTRL_0		0xA5
-#define REG_PORT_RATE_LIMIT		0xA6
-#define REG_PORT_IN_RATE_0		0xA7
-#define REG_PORT_IN_RATE_1		0xA8
-#define REG_PORT_IN_RATE_2		0xA9
-#define REG_PORT_IN_RATE_3		0xAA
-#define REG_PORT_OUT_RATE_0		0xAB
-#define REG_PORT_OUT_RATE_1		0xAC
-#define REG_PORT_OUT_RATE_2		0xAD
-#define REG_PORT_OUT_RATE_3		0xAE
+
+#define KSZ8795_REG_PORT_CTRL_9			0x0C
+#define KSZ8795_REG_PORT_CTRL_10		0x0D
+#define KSZ8795_REG_PORT_STATUS_2		0x0E
+#define KSZ8795_REG_PORT_STATUS_3		0x0F
+
+#define REG_PORT_CTRL_12			0x0C
+#define REG_PORT_CTRL_13			0x0D
+
+#define KSZ8795_REG_PORT_CTRL_12		0xA0
+#define KSZ8795_REG_PORT_CTRL_13		0xA1
+#define KSZ8795_REG_PORT_RATE_CTRL_3		0xA2
+#define KSZ8795_REG_PORT_RATE_CTRL_2		0xA3
+#define KSZ8795_REG_PORT_RATE_CTRL_1		0xA4
+#define KSZ8795_REG_PORT_RATE_CTRL_0		0xA5
+#define KSZ8795_REG_PORT_RATE_LIMIT		0xA6
+#define KSZ8795_REG_PORT_IN_RATE_0		0xA7
+#define KSZ8795_REG_PORT_IN_RATE_1		0xA8
+#define KSZ8795_REG_PORT_IN_RATE_2		0xA9
+#define KSZ8795_REG_PORT_IN_RATE_3		0xAA
+#define KSZ8795_REG_PORT_OUT_RATE_0		0xAB
+#define KSZ8795_REG_PORT_OUT_RATE_1		0xAC
+#define KSZ8795_REG_PORT_OUT_RATE_2		0xAD
+#define KSZ8795_REG_PORT_OUT_RATE_3		0xAE
 
 #define PORT_CTRL_ADDR(port, addr)		\
 	((addr) + REG_PORT_1_CTRL_0 + (port) *	\
@@ -356,7 +363,7 @@
 #define REG_SW_MAC_ADDR_4		0x6C
 #define REG_SW_MAC_ADDR_5		0x6D
 
-#define REG_IND_CTRL_0			0x6E
+#define KSZ8795_REG_IND_CTRL_0			0x6E
 
 #define TABLE_EXT_SELECT_S		5
 #define TABLE_EEE_V			1
@@ -378,27 +385,27 @@
 #define TABLE_DYNAMIC_MAC		(TABLE_DYNAMIC_MAC_V << TABLE_SELECT_S)
 #define TABLE_MIB			(TABLE_MIB_V << TABLE_SELECT_S)
 
-#define REG_IND_CTRL_1			0x6F
+#define KSZ8795_REG_IND_CTRL_1			0x6F
 
 #define TABLE_ENTRY_MASK		0x03FF
 #define TABLE_EXT_ENTRY_MASK		0x0FFF
 
-#define REG_IND_DATA_8			0x70
-#define REG_IND_DATA_7			0x71
-#define REG_IND_DATA_6			0x72
-#define REG_IND_DATA_5			0x73
-#define REG_IND_DATA_4			0x74
-#define REG_IND_DATA_3			0x75
-#define REG_IND_DATA_2			0x76
-#define REG_IND_DATA_1			0x77
-#define REG_IND_DATA_0			0x78
+#define KSZ8795_REG_IND_DATA_8		0x70
+#define KSZ8795_REG_IND_DATA_7		0x71
+#define KSZ8795_REG_IND_DATA_6		0x72
+#define KSZ8795_REG_IND_DATA_5		0x73
+#define KSZ8795_REG_IND_DATA_4		0x74
+#define KSZ8795_REG_IND_DATA_3		0x75
+#define KSZ8795_REG_IND_DATA_2		0x76
+#define KSZ8795_REG_IND_DATA_1		0x77
+#define KSZ8795_REG_IND_DATA_0		0x78
 
-#define REG_IND_DATA_PME_EEE_ACL	0xA0
+#define KSZ8795_REG_IND_DATA_PME_EEE_ACL	0xA0
 
-#define REG_IND_DATA_CHECK		REG_IND_DATA_6
-#define REG_IND_MIB_CHECK		REG_IND_DATA_4
-#define REG_IND_DATA_HI			REG_IND_DATA_7
-#define REG_IND_DATA_LO			REG_IND_DATA_3
+#define KSZ8795_REG_IND_DATA_CHECK	KSZ8795_REG_IND_DATA_6
+#define KSZ8795_REG_IND_MIB_CHECK	KSZ8795_REG_IND_DATA_4
+#define KSZ8795_REG_IND_DATA_HI		KSZ8795_REG_IND_DATA_7
+#define KSZ8795_REG_IND_DATA_LO		KSZ8795_REG_IND_DATA_3
 
 #define REG_INT_STATUS			0x7C
 #define REG_INT_ENABLE			0x7D
@@ -846,16 +853,15 @@
 
 #define KS_PRIO_IN_REG			4
 
-#define TOTAL_PORT_NUM			5
+#define KSZ8795_TOTAL_PORT_NUM		5
 
 /* Host port can only be last of them. */
-#define SWITCH_PORT_NUM			(TOTAL_PORT_NUM - 1)
+#define KSZ8795_SWITCH_PORT_NUM		(KSZ8795_TOTAL_PORT_NUM - 1)
 
 #define KSZ8795_COUNTER_NUM		0x20
 #define TOTAL_KSZ8795_COUNTER_NUM	(KSZ8795_COUNTER_NUM + 4)
 
 #define SWITCH_COUNTER_NUM		KSZ8795_COUNTER_NUM
-#define TOTAL_SWITCH_COUNTER_NUM	TOTAL_KSZ8795_COUNTER_NUM
 
 /* Common names used by other drivers */
 
@@ -865,16 +871,16 @@
 #define P_MIRROR_CTRL			REG_PORT_CTRL_1
 #define P_802_1P_CTRL			REG_PORT_CTRL_2
 #define P_STP_CTRL			REG_PORT_CTRL_2
-#define P_LOCAL_CTRL			REG_PORT_CTRL_7
-#define P_REMOTE_STATUS			REG_PORT_STATUS_0
-#define P_FORCE_CTRL			REG_PORT_CTRL_9
-#define P_NEG_RESTART_CTRL		REG_PORT_CTRL_10
-#define P_SPEED_STATUS			REG_PORT_STATUS_1
-#define P_LINK_STATUS			REG_PORT_STATUS_2
-#define P_PASS_ALL_CTRL			REG_PORT_CTRL_12
-#define P_INS_SRC_PVID_CTRL		REG_PORT_CTRL_12
-#define P_DROP_TAG_CTRL			REG_PORT_CTRL_13
-#define P_RATE_LIMIT_CTRL		REG_PORT_RATE_LIMIT
+#define KSZ8795_P_LOCAL_CTRL			REG_PORT_CTRL_7
+#define KSZ8795_P_REMOTE_STATUS			KSZ8795_REG_PORT_STATUS_0
+#define KSZ8795_P_FORCE_CTRL			KSZ8795_REG_PORT_CTRL_9
+#define KSZ8795_P_NEG_RESTART_CTRL		KSZ8795_REG_PORT_CTRL_10
+#define KSZ8795_P_SPEED_STATUS			KSZ8795_REG_PORT_STATUS_1
+#define KSZ8795_P_LINK_STATUS			KSZ8795_REG_PORT_STATUS_2
+#define P_PASS_ALL_CTRL			KSZ8795_REG_PORT_CTRL_12
+#define P_INS_SRC_PVID_CTRL		KSZ8795_REG_PORT_CTRL_12
+#define P_DROP_TAG_CTRL			KSZ8795_REG_PORT_CTRL_13
+#define P_RATE_LIMIT_CTRL		KSZ8795_REG_PORT_RATE_LIMIT
 
 #define S_UNKNOWN_DA_CTRL		REG_SWITCH_CTRL_12
 #define S_FORWARD_INVALID_VID_CTRL	REG_FORWARD_INVALID_VID
@@ -885,7 +891,7 @@
 #define S_MIRROR_CTRL			REG_SW_CTRL_3
 #define S_REPLACE_VID_CTRL		REG_SW_CTRL_4
 #define S_PASS_PAUSE_CTRL		REG_SW_CTRL_10
-#define S_TAIL_TAG_CTRL			REG_SW_CTRL_10
+#define KSZ8795_S_TAIL_TAG_CTRL			REG_SW_CTRL_10
 #define S_802_1P_PRIO_CTRL		REG_SW_CTRL_12
 #define S_TOS_PRIO_CTRL			REG_TOS_PRIO_CTRL_0
 #define S_IPV6_MLD_CTRL			REG_SW_CTRL_21
@@ -907,15 +913,15 @@
  * STATIC_MAC_TABLE_FID			00-7F000000-00000000
  */
 
-#define STATIC_MAC_TABLE_ADDR		0x0000FFFF
-#define STATIC_MAC_TABLE_FWD_PORTS	0x001F0000
-#define STATIC_MAC_TABLE_VALID		0x00200000
-#define STATIC_MAC_TABLE_OVERRIDE	0x00400000
-#define STATIC_MAC_TABLE_USE_FID	0x00800000
-#define STATIC_MAC_TABLE_FID		0x7F000000
+#define KSZ8795_STATIC_MAC_TABLE_ADDR		0x0000FFFF
+#define KSZ8795_STATIC_MAC_TABLE_FWD_PORTS	0x001F0000
+#define KSZ8795_STATIC_MAC_TABLE_VALID		0x00200000
+#define KSZ8795_STATIC_MAC_TABLE_OVERRIDE	0x00400000
+#define KSZ8795_STATIC_MAC_TABLE_USE_FID	0x00800000
+#define KSZ8795_STATIC_MAC_TABLE_FID		0x7F000000
 
-#define STATIC_MAC_FWD_PORTS_S		16
-#define STATIC_MAC_FID_S		24
+#define KSZ8795_STATIC_MAC_FWD_PORTS_S		16
+#define KSZ8795_STATIC_MAC_FID_S		24
 
 /**
  * VLAN_TABLE_FID			00-007F007F-007F007F
@@ -923,12 +929,12 @@
  * VLAN_TABLE_VALID			00-10001000-10001000
  */
 
-#define VLAN_TABLE_FID			0x007F
-#define VLAN_TABLE_MEMBERSHIP		0x0F80
-#define VLAN_TABLE_VALID		0x1000
+#define KSZ8795_VLAN_TABLE_FID			0x007F
+#define KSZ8795_VLAN_TABLE_MEMBERSHIP		0x0F80
+#define KSZ8795_VLAN_TABLE_VALID		0x1000
 
-#define VLAN_TABLE_MEMBERSHIP_S		7
-#define VLAN_TABLE_S			16
+#define KSZ8795_VLAN_TABLE_MEMBERSHIP_S		7
+#define KSZ8795_VLAN_TABLE_S			16
 
 /**
  * DYNAMIC_MAC_TABLE_ADDR		00-0000FFFF-FFFFFFFF
@@ -940,22 +946,22 @@
  * DYNAMIC_MAC_TABLE_MAC_EMPTY		80-00000000-00000000
  */
 
-#define DYNAMIC_MAC_TABLE_ADDR		0x0000FFFF
-#define DYNAMIC_MAC_TABLE_FID		0x007F0000
-#define DYNAMIC_MAC_TABLE_SRC_PORT	0x07000000
-#define DYNAMIC_MAC_TABLE_TIMESTAMP	0x18000000
-#define DYNAMIC_MAC_TABLE_ENTRIES	0xE0000000
+#define KSZ8795_DYNAMIC_MAC_TABLE_ADDR		0x0000FFFF
+#define KSZ8795_DYNAMIC_MAC_TABLE_FID		0x007F0000
+#define KSZ8795_DYNAMIC_MAC_TABLE_SRC_PORT	0x07000000
+#define KSZ8795_DYNAMIC_MAC_TABLE_TIMESTAMP	0x18000000
+#define KSZ8795_DYNAMIC_MAC_TABLE_ENTRIES	0xE0000000
 
-#define DYNAMIC_MAC_TABLE_NOT_READY	0x80
+#define KSZ8795_DYNAMIC_MAC_TABLE_NOT_READY	0x80
 
-#define DYNAMIC_MAC_TABLE_ENTRIES_H	0x7F
-#define DYNAMIC_MAC_TABLE_MAC_EMPTY	0x80
+#define KSZ8795_DYNAMIC_MAC_TABLE_ENTRIES_H	0x7F
+#define KSZ8795_DYNAMIC_MAC_TABLE_MAC_EMPTY	0x80
 
-#define DYNAMIC_MAC_FID_S		16
-#define DYNAMIC_MAC_SRC_PORT_S		24
-#define DYNAMIC_MAC_TIMESTAMP_S		27
-#define DYNAMIC_MAC_ENTRIES_S		29
-#define DYNAMIC_MAC_ENTRIES_H_S		3
+#define KSZ8795_DYNAMIC_MAC_FID_S		16
+#define KSZ8795_DYNAMIC_MAC_SRC_PORT_S		24
+#define KSZ8795_DYNAMIC_MAC_TIMESTAMP_S		27
+#define KSZ8795_DYNAMIC_MAC_ENTRIES_S		29
+#define KSZ8795_DYNAMIC_MAC_ENTRIES_H_S		3
 
 /**
  * MIB_COUNTER_VALUE			00-00000000-3FFFFFFF
@@ -965,31 +971,31 @@
  * MIB_COUNTER_OVERFLOW			00-00000040-00000000
  */
 
-#define MIB_COUNTER_OVERFLOW		BIT(6)
-#define MIB_COUNTER_VALID		BIT(5)
+#define KSZ8795_MIB_COUNTER_OVERFLOW		BIT(6)
+#define KSZ8795_MIB_COUNTER_VALID		BIT(5)
 
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
+#define KSZ8795_MIB_PACKET_DROPPED_RX_0	0x102
+#define KSZ8795_MIB_PACKET_DROPPED_TX_0	0x103
+#define KSZ8795_MIB_TOTAL_RX_1		0x104
+#define KSZ8795_MIB_TOTAL_TX_1		0x105
+#define KSZ8795_MIB_PACKET_DROPPED_TX_1	0x106
+#define KSZ8795_MIB_PACKET_DROPPED_RX_1	0x107
+#define KSZ8795_MIB_TOTAL_RX_2		0x108
+#define KSZ8795_MIB_TOTAL_TX_2		0x109
+#define KSZ8795_MIB_PACKET_DROPPED_TX_2	0x10A
+#define KSZ8795_MIB_PACKET_DROPPED_RX_2	0x10B
+#define KSZ8795_MIB_TOTAL_RX_3		0x10C
+#define KSZ8795_MIB_TOTAL_TX_3		0x10D
+#define KSZ8795_MIB_PACKET_DROPPED_TX_3	0x10E
+#define KSZ8795_MIB_PACKET_DROPPED_RX_3	0x10F
+#define KSZ8795_MIB_TOTAL_RX_4		0x110
+#define KSZ8795_MIB_TOTAL_TX_4		0x111
+#define KSZ8795_MIB_PACKET_DROPPED_TX_4	0x112
+#define KSZ8795_MIB_PACKET_DROPPED_RX_4	0x113
 
 #define MIB_PACKET_DROPPED		0x0000FFFF
 
diff --git a/drivers/net/dsa/microchip/ksz8863_reg.h b/drivers/net/dsa/microchip/ksz8863_reg.h
new file mode 100644
index 000000000000000..6dbe7e1cf921fc4
--- /dev/null
+++ b/drivers/net/dsa/microchip/ksz8863_reg.h
@@ -0,0 +1,124 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Microchip KSZ8863 register definitions
+ *
+ * Copyright (C) 2019 Pengutronix, Michael Grzeschik <kernel@pengutronix.de>
+ */
+
+#ifndef __KSZ8863_REG_H
+#define __KSZ8863_REG_H
+
+#define KSZ88_FAMILY_ID				0x88
+
+#define CHIP_ID_63				0x30
+
+#define KSZ8863_REG_SW_RESET			0x43
+
+#define KSZ8863_GLOBAL_SOFTWARE_RESET		BIT(4)
+#define KSZ8863_PCS_RESET			BIT(0)
+
+#define KSZ8863_SW_TAIL_TAG_ENABLE		BIT(6)
+
+#define KSZ8863_REG_POWER_MANAGEMENT		0xC3
+
+#define KSZ8863_PORT_802_1P_REMAPPING		BIT(3)
+
+#define KSZ8863_REG_PORT_STATUS_0		0x0E
+#define KSZ8863_REG_PORT_STATUS_1		0x0F
+
+#define KSZ8863_REG_IND_CTRL_0			0x79
+
+#define KSZ8863_REG_IND_CTRL_1			0x7A
+
+#define KSZ8863_REG_IND_DATA_8			0x7B
+#define KSZ8863_REG_IND_DATA_7			0x7C
+#define KSZ8863_REG_IND_DATA_6			0x7D
+#define KSZ8863_REG_IND_DATA_5			0x7E
+#define KSZ8863_REG_IND_DATA_4			0x7F
+#define KSZ8863_REG_IND_DATA_3			0x80
+#define KSZ8863_REG_IND_DATA_2			0x81
+#define KSZ8863_REG_IND_DATA_1			0x82
+#define KSZ8863_REG_IND_DATA_0			0x83
+
+#define KSZ8863_REG_IND_DATA_CHECK		KSZ8863_REG_IND_DATA_8
+#define KSZ8863_REG_IND_MIB_CHECK		KSZ8863_REG_IND_DATA_3
+#define KSZ8863_REG_IND_DATA_HI			KSZ8863_REG_IND_DATA_7
+#define KSZ8863_REG_IND_DATA_LO			KSZ8863_REG_IND_DATA_3
+
+#define KSZ8863_ID_HI				0x0022
+#define KSZ8863_ID_LO				0x1430
+
+#define KSZ8863_TOTAL_PORT_NUM			3
+#define KSZ8863_SWITCH_PORT_NUM			(KSZ8863_TOTAL_PORT_NUM - 1)
+
+#define KSZ8863_COUNTER_NUM			0x20
+#define TOTAL_KSZ8863_COUNTER_NUM		(KSZ8863_COUNTER_NUM + 2)
+
+#define KSZ8863_P_LOCAL_CTRL			REG_PORT_CTRL_12
+#define KSZ8863_P_REMOTE_STATUS			KSZ8863_REG_PORT_STATUS_0
+#define KSZ8863_P_FORCE_CTRL			REG_PORT_CTRL_12
+#define KSZ8863_P_NEG_RESTART_CTRL		REG_PORT_CTRL_13
+#define KSZ8863_P_SPEED_STATUS			KSZ8863_REG_PORT_STATUS_1
+#define KSZ8863_P_LINK_STATUS			KSZ8863_REG_PORT_STATUS_0
+#define KSZ8863_S_TAIL_TAG_CTRL			REG_SW_CTRL_1
+
+/**
+ * STATIC_MAC_TABLE_ADDR		00-0000FFFF-FFFFFFFF
+ * STATIC_MAC_TABLE_FWD_PORTS		00-00070000-00000000
+ * STATIC_MAC_TABLE_VALID		00-00080000-00000000
+ * STATIC_MAC_TABLE_OVERRIDE		00-00100000-00000000
+ * STATIC_MAC_TABLE_USE_FID		00-00200000-00000000
+ * STATIC_MAC_TABLE_FID			00-3C000000-00000000
+ */
+
+#define KSZ8863_STATIC_MAC_TABLE_ADDR		0x0000FFFF
+#define KSZ8863_STATIC_MAC_TABLE_FWD_PORTS	0x00070000
+#define KSZ8863_STATIC_MAC_TABLE_VALID		0x00080000
+#define KSZ8863_STATIC_MAC_TABLE_OVERRIDE	0x00100000
+#define KSZ8863_STATIC_MAC_TABLE_USE_FID	0x00200000
+#define KSZ8863_STATIC_MAC_TABLE_FID		0x3C000000
+
+#define KSZ8863_STATIC_MAC_FWD_PORTS_S		16
+#define KSZ8863_STATIC_MAC_FID_S		22
+
+/**
+ * VLAN_TABLE_VID			00-00000000-00000FFF
+ * VLAN_TABLE_FID			00-00000000-0000F000
+ * VLAN_TABLE_MEMBERSHIP		00-00000000-00070000
+ * VLAN_TABLE_VALID			00-00000000-00080000
+ */
+
+#define KSZ8863_VLAN_TABLE_VID			0x00FFF
+#define KSZ8863_VLAN_TABLE_FID			0x0F000
+#define KSZ8863_VLAN_TABLE_MEMBERSHIP		0x70000
+#define KSZ8863_VLAN_TABLE_VALID		0x80000
+
+#define KSZ8863_VLAN_TABLE_MEMBERSHIP_S		16
+
+#define KSZ8863_DYNAMIC_MAC_TABLE_ADDR		0x0000FFFF
+#define KSZ8863_DYNAMIC_MAC_TABLE_FID		0x000F0000
+#define KSZ8863_DYNAMIC_MAC_TABLE_SRC_PORT	0x00300000
+#define KSZ8863_DYNAMIC_MAC_TABLE_TIMESTAMP	0x00C00000
+#define KSZ8863_DYNAMIC_MAC_TABLE_ENTRIES	0xF0000000
+
+#define KSZ8863_DYNAMIC_MAC_TABLE_NOT_READY	0x80
+
+#define KSZ8863_DYNAMIC_MAC_TABLE_ENTRIES_H	0x3F
+#define KSZ8863_DYNAMIC_MAC_TABLE_MAC_EMPTY	0x80
+
+#define KSZ8863_DYNAMIC_MAC_FID_S		16
+#define KSZ8863_DYNAMIC_MAC_SRC_PORT_S		20
+#define KSZ8863_DYNAMIC_MAC_TIMESTAMP_S		24
+#define KSZ8863_DYNAMIC_MAC_ENTRIES_S		24
+#define KSZ8863_DYNAMIC_MAC_ENTRIES_H_S		3
+
+#define KSZ8863_MIB_COUNTER_OVERFLOW		BIT(7)
+#define KSZ8863_MIB_COUNTER_VALID		BIT(6)
+
+#define KSZ8863_MIB_PACKET_DROPPED_TX_0		0x100
+#define KSZ8863_MIB_PACKET_DROPPED_RX_0		0x105
+
+#define KSZ8863_REG_INT_ENABLE			0xBB
+#define KSZ8863_REG_INT_STATUS			0xBC
+
+#endif
-- 
2.28.0

