Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8ACB7239F41
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 07:47:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728298AbgHCFpR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 01:45:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728186AbgHCFpC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 01:45:02 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3899DC06179F
        for <netdev@vger.kernel.org>; Sun,  2 Aug 2020 22:45:02 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mgr@pengutronix.de>)
        id 1k2THQ-0005JE-FE; Mon, 03 Aug 2020 07:45:00 +0200
Received: from mgr by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <mgr@pengutronix.de>)
        id 1k2THK-0005UE-W0; Mon, 03 Aug 2020 07:44:54 +0200
From:   Michael Grzeschik <m.grzeschik@pengutronix.de>
To:     andrew@lunn.ch
Cc:     netdev@vger.kernel.org, f.fainelli@gmail.com, davem@davemloft.net,
        kernel@pengutronix.de
Subject: [PATCH v4 07/11] net: dsa: microchip: ksz8795: move register offsets and shifts to separate struct
Date:   Mon,  3 Aug 2020 07:44:38 +0200
Message-Id: <20200803054442.20089-8-m.grzeschik@pengutronix.de>
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

In order to get this driver used with other switches the functions need
to use different offsets and register shifts. This patch changes the
direct use of the register defines to register description structures,
which can be set depending on the chips register layout.

Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>

---
v1 -> v4: - extracted this change from bigger previous patch

 drivers/net/dsa/microchip/ksz8.h    |  68 ++++++++
 drivers/net/dsa/microchip/ksz8795.c | 242 +++++++++++++++++++---------
 2 files changed, 235 insertions(+), 75 deletions(-)
 create mode 100644 drivers/net/dsa/microchip/ksz8.h

diff --git a/drivers/net/dsa/microchip/ksz8.h b/drivers/net/dsa/microchip/ksz8.h
new file mode 100644
index 000000000000000..a2fb6b9e2d1e5d5
--- /dev/null
+++ b/drivers/net/dsa/microchip/ksz8.h
@@ -0,0 +1,68 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Microchip KSZ8863 series register access through SMI
+ *
+ * Copyright (C) 2019 Pengutronix, Michael Grzeschik <kernel@pengutronix.de>
+ */
+
+#ifndef __KSZ8XXX_H
+#define __KSZ8XXX_H
+
+struct ksz_regs {
+	int ind_ctrl_0;
+	int ind_data_8;
+	int ind_data_check;
+	int ind_data_hi;
+	int ind_data_lo;
+	int ind_mib_check;
+	int p_force_ctrl;
+	int p_link_status;
+	int p_local_ctrl;
+	int p_neg_restart_ctrl;
+	int p_remote_status;
+	int p_speed_status;
+	int s_tail_tag_ctrl;
+};
+
+struct ksz_masks {
+	int port_802_1p_remapping;
+	int sw_tail_tag_enable;
+	int mib_counter_overflow;
+	int mib_counter_valid;
+	int vlan_table_fid;
+	int vlan_table_membership;
+	int vlan_table_valid;
+	int static_mac_table_valid;
+	int static_mac_table_use_fid;
+	int static_mac_table_fid;
+	int static_mac_table_override;
+	int static_mac_table_fwd_ports;
+	int dynamic_mac_table_entries_h;
+	int dynamic_mac_table_mac_empty;
+	int dynamic_mac_table_not_ready;
+	int dynamic_mac_table_entries;
+	int dynamic_mac_table_fid;
+	int dynamic_mac_table_src_port;
+	int dynamic_mac_table_timestamp;
+};
+
+struct ksz_shifts {
+	int vlan_table_membership;
+	int vlan_table;
+	int static_mac_fwd_ports;
+	int static_mac_fid;
+	int dynamic_mac_entries_h;
+	int dynamic_mac_entries;
+	int dynamic_mac_fid;
+	int dynamic_mac_timestamp;
+	int dynamic_mac_src_port;
+};
+
+struct ksz8 {
+	struct ksz_regs *regs;
+	struct ksz_masks *masks;
+	struct ksz_shifts *shifts;
+	void *priv;
+};
+
+#endif
diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index c21125a0b30e5c8..480143905d75579 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -20,6 +20,46 @@
 
 #include "ksz_common.h"
 #include "ksz8795_reg.h"
+#include "ksz8.h"
+
+static struct ksz_regs ksz8795_regs = {
+	.ind_ctrl_0			= REG_IND_CTRL_0,
+	.ind_data_8			= REG_IND_DATA_8,
+	.ind_data_check			= REG_IND_DATA_CHECK,
+	.ind_data_hi			= REG_IND_DATA_HI,
+	.ind_data_lo			= REG_IND_DATA_LO,
+	.ind_mib_check			= REG_IND_MIB_CHECK,
+	.p_force_ctrl			= P_FORCE_CTRL,
+	.p_link_status			= P_LINK_STATUS,
+	.p_local_ctrl			= P_LOCAL_CTRL,
+	.p_neg_restart_ctrl		= P_NEG_RESTART_CTRL,
+	.p_remote_status		= P_REMOTE_STATUS,
+	.p_speed_status			= P_SPEED_STATUS,
+	.s_tail_tag_ctrl		= S_TAIL_TAG_CTRL,
+};
+
+static struct ksz_masks ksz8795_masks = {
+	.port_802_1p_remapping		= PORT_802_1P_REMAPPING,
+	.sw_tail_tag_enable		= SW_TAIL_TAG_ENABLE,
+	.mib_counter_overflow		= MIB_COUNTER_OVERFLOW,
+	.mib_counter_valid		= MIB_COUNTER_VALID,
+	.vlan_table_fid			= VLAN_TABLE_FID,
+	.vlan_table_membership		= VLAN_TABLE_MEMBERSHIP,
+	.vlan_table_valid		= VLAN_TABLE_VALID,
+	.static_mac_table_valid		= STATIC_MAC_TABLE_VALID,
+	.static_mac_table_use_fid	= STATIC_MAC_TABLE_USE_FID,
+	.static_mac_table_fid		= STATIC_MAC_TABLE_FID,
+	.static_mac_table_override	= STATIC_MAC_TABLE_OVERRIDE,
+	.static_mac_table_fwd_ports	= STATIC_MAC_TABLE_FWD_PORTS,
+	.dynamic_mac_table_entries_h	= DYNAMIC_MAC_TABLE_ENTRIES_H,
+	.dynamic_mac_table_mac_empty	= DYNAMIC_MAC_TABLE_MAC_EMPTY,
+	.dynamic_mac_table_not_ready	= DYNAMIC_MAC_TABLE_NOT_READY,
+	.dynamic_mac_table_entries	= DYNAMIC_MAC_TABLE_ENTRIES,
+	.dynamic_mac_table_fid		= DYNAMIC_MAC_TABLE_FID,
+	.dynamic_mac_table_src_port	= DYNAMIC_MAC_TABLE_SRC_PORT,
+	.dynamic_mac_table_timestamp	= DYNAMIC_MAC_TABLE_TIMESTAMP,
+};
+
 
 static const struct {
 	char string[ETH_GSTRING_LEN];
@@ -119,26 +159,29 @@ static void ksz8795_set_prio_queue(struct ksz_device *dev, int port, int queue)
 
 static void ksz8_r_mib_cnt(struct ksz_device *dev, int port, u16 addr, u64 *cnt)
 {
+	struct ksz8 *ksz8 = dev->priv;
+	struct ksz_regs *regs = ksz8->regs;
+	struct ksz_masks *masks = ksz8->masks;
 	u16 ctrl_addr;
 	u32 data;
 	u8 check;
 	int loop;
 
-	ctrl_addr = addr + SWITCH_COUNTER_NUM * port;
+	ctrl_addr = addr + dev->reg_mib_cnt * port;
 	ctrl_addr |= IND_ACC_TABLE(TABLE_MIB | TABLE_READ);
 
 	mutex_lock(&dev->alu_mutex);
-	ksz_write16(dev, REG_IND_CTRL_0, ctrl_addr);
+	ksz_write16(dev, regs->ind_ctrl_0, ctrl_addr);
 
 	/* It is almost guaranteed to always read the valid bit because of
 	 * slow SPI speed.
 	 */
 	for (loop = 2; loop > 0; loop--) {
-		ksz_read8(dev, REG_IND_MIB_CHECK, &check);
+		ksz_read8(dev, regs->ind_mib_check, &check);
 
-		if (check & MIB_COUNTER_VALID) {
-			ksz_read32(dev, REG_IND_DATA_LO, &data);
-			if (check & MIB_COUNTER_OVERFLOW)
+		if (check & masks->mib_counter_valid) {
+			ksz_read32(dev, regs->ind_data_lo, &data);
+			if (check & masks->mib_counter_overflow)
 				*cnt += MIB_COUNTER_VALUE + 1;
 			*cnt += data & MIB_COUNTER_VALUE;
 			break;
@@ -150,6 +193,8 @@ static void ksz8_r_mib_cnt(struct ksz_device *dev, int port, u16 addr, u64 *cnt)
 static void ksz8_r_mib_pkt(struct ksz_device *dev, int port, u16 addr,
 			   u64 *dropped, u64 *cnt)
 {
+	struct ksz8 *ksz8 = dev->priv;
+	struct ksz_regs *regs = ksz8->regs;
 	u16 ctrl_addr;
 	u32 data;
 	u8 check;
@@ -161,16 +206,16 @@ static void ksz8_r_mib_pkt(struct ksz_device *dev, int port, u16 addr,
 	ctrl_addr |= IND_ACC_TABLE(TABLE_MIB | TABLE_READ);
 
 	mutex_lock(&dev->alu_mutex);
-	ksz_write16(dev, REG_IND_CTRL_0, ctrl_addr);
+	ksz_write16(dev, regs->ind_ctrl_0, ctrl_addr);
 
 	/* It is almost guaranteed to always read the valid bit because of
 	 * slow SPI speed.
 	 */
 	for (loop = 2; loop > 0; loop--) {
-		ksz_read8(dev, REG_IND_MIB_CHECK, &check);
+		ksz_read8(dev, regs->ind_mib_check, &check);
 
 		if (check & MIB_COUNTER_VALID) {
-			ksz_read32(dev, REG_IND_DATA_LO, &data);
+			ksz_read32(dev, regs->ind_data_lo, &data);
 			if (addr < 2) {
 				u64 total;
 
@@ -236,46 +281,53 @@ static void ksz8_port_init_cnt(struct ksz_device *dev, int port)
 
 static void ksz8_r_table(struct ksz_device *dev, int table, u16 addr, u64 *data)
 {
+	struct ksz8 *ksz8 = dev->priv;
+	struct ksz_regs *regs = ksz8->regs;
 	u16 ctrl_addr;
 
 	ctrl_addr = IND_ACC_TABLE(table | TABLE_READ) | addr;
 
 	mutex_lock(&dev->alu_mutex);
-	ksz_write16(dev, REG_IND_CTRL_0, ctrl_addr);
-	ksz_read64(dev, REG_IND_DATA_HI, data);
+	ksz_write16(dev, regs->ind_ctrl_0, ctrl_addr);
+	ksz_read64(dev, regs->ind_data_hi, data);
 	mutex_unlock(&dev->alu_mutex);
 }
 
 static void ksz8_w_table(struct ksz_device *dev, int table, u16 addr, u64 data)
 {
+	struct ksz8 *ksz8 = dev->priv;
+	struct ksz_regs *regs = ksz8->regs;
 	u16 ctrl_addr;
 
 	ctrl_addr = IND_ACC_TABLE(table) | addr;
 
 	mutex_lock(&dev->alu_mutex);
-	ksz_write64(dev, REG_IND_DATA_HI, data);
-	ksz_write16(dev, REG_IND_CTRL_0, ctrl_addr);
+	ksz_write64(dev, regs->ind_data_hi, data);
+	ksz_write16(dev, regs->ind_ctrl_0, ctrl_addr);
 	mutex_unlock(&dev->alu_mutex);
 }
 
 static int ksz8_valid_dyn_entry(struct ksz_device *dev, u8 *data)
 {
+	struct ksz8 *ksz8 = dev->priv;
+	struct ksz_regs *regs = ksz8->regs;
+	struct ksz_masks *masks = ksz8->masks;
 	int timeout = 100;
 
 	do {
-		ksz_read8(dev, REG_IND_DATA_CHECK, data);
+		ksz_read8(dev, regs->ind_data_check, data);
 		timeout--;
-	} while ((*data & DYNAMIC_MAC_TABLE_NOT_READY) && timeout);
+	} while ((*data & masks->dynamic_mac_table_not_ready) && timeout);
 
 	/* Entry is not ready for accessing. */
-	if (*data & DYNAMIC_MAC_TABLE_NOT_READY) {
+	if (*data & masks->dynamic_mac_table_not_ready) {
 		return -EAGAIN;
 	/* Entry is ready for accessing. */
 	} else {
-		ksz_read8(dev, REG_IND_DATA_8, data);
+		ksz_read8(dev, regs->ind_data_8, data);
 
 		/* There is no valid entry in the table. */
-		if (*data & DYNAMIC_MAC_TABLE_MAC_EMPTY)
+		if (*data & masks->dynamic_mac_table_mac_empty)
 			return -ENXIO;
 	}
 	return 0;
@@ -285,6 +337,10 @@ static int ksz8_r_dyn_mac_table(struct ksz_device *dev, u16 addr,
 				u8 *mac_addr, u8 *fid, u8 *src_port,
 				u8 *timestamp, u16 *entries)
 {
+	struct ksz8 *ksz8 = dev->priv;
+	struct ksz_regs *regs = ksz8->regs;
+	struct ksz_masks *masks = ksz8->masks;
+	struct ksz_shifts *shifts = ksz8->shifts;
 	u32 data_hi, data_lo;
 	u16 ctrl_addr;
 	u8 data;
@@ -293,7 +349,7 @@ static int ksz8_r_dyn_mac_table(struct ksz_device *dev, u16 addr,
 	ctrl_addr = IND_ACC_TABLE(TABLE_DYNAMIC_MAC | TABLE_READ) | addr;
 
 	mutex_lock(&dev->alu_mutex);
-	ksz_write16(dev, REG_IND_CTRL_0, ctrl_addr);
+	ksz_write16(dev, regs->ind_ctrl_0, ctrl_addr);
 
 	rc = ksz8_valid_dyn_entry(dev, &data);
 	if (rc == -EAGAIN) {
@@ -306,23 +362,23 @@ static int ksz8_r_dyn_mac_table(struct ksz_device *dev, u16 addr,
 		u64 buf = 0;
 		int cnt;
 
-		ksz_read64(dev, REG_IND_DATA_HI, &buf);
+		ksz_read64(dev, regs->ind_data_hi, &buf);
 		data_hi = (u32)(buf >> 32);
 		data_lo = (u32)buf;
 
 		/* Check out how many valid entry in the table. */
-		cnt = data & DYNAMIC_MAC_TABLE_ENTRIES_H;
-		cnt <<= DYNAMIC_MAC_ENTRIES_H_S;
-		cnt |= (data_hi & DYNAMIC_MAC_TABLE_ENTRIES) >>
-			DYNAMIC_MAC_ENTRIES_S;
+		cnt = data & masks->dynamic_mac_table_entries_h;
+		cnt <<= shifts->dynamic_mac_entries_h;
+		cnt |= (data_hi & masks->dynamic_mac_table_entries) >>
+			shifts->dynamic_mac_entries;
 		*entries = cnt + 1;
 
-		*fid = (data_hi & DYNAMIC_MAC_TABLE_FID) >>
-			DYNAMIC_MAC_FID_S;
-		*src_port = (data_hi & DYNAMIC_MAC_TABLE_SRC_PORT) >>
-			DYNAMIC_MAC_SRC_PORT_S;
-		*timestamp = (data_hi & DYNAMIC_MAC_TABLE_TIMESTAMP) >>
-			DYNAMIC_MAC_TIMESTAMP_S;
+		*fid = (data_hi & masks->dynamic_mac_table_fid) >>
+			shifts->dynamic_mac_fid;
+		*src_port = (data_hi & masks->dynamic_mac_table_src_port) >>
+			shifts->dynamic_mac_src_port;
+		*timestamp = (data_hi & masks->dynamic_mac_table_timestamp) >>
+			shifts->dynamic_mac_timestamp;
 
 		mac_addr[5] = (u8)data_lo;
 		mac_addr[4] = (u8)(data_lo >> 8);
@@ -341,27 +397,33 @@ static int ksz8_r_dyn_mac_table(struct ksz_device *dev, u16 addr,
 static int ksz8_r_sta_mac_table(struct ksz_device *dev, u16 addr,
 				struct alu_struct *alu)
 {
+	struct ksz8 *ksz8 = dev->priv;
+	struct ksz_masks *masks = ksz8->masks;
+	struct ksz_shifts *shifts = ksz8->shifts;
 	u32 data_hi, data_lo;
 	u64 data;
 
 	ksz8_r_table(dev, TABLE_STATIC_MAC, addr, &data);
 	data_hi = data >> 32;
 	data_lo = (u32)data;
-	if (data_hi & (STATIC_MAC_TABLE_VALID | STATIC_MAC_TABLE_OVERRIDE)) {
+	if (data_hi & (masks->static_mac_table_valid |
+			masks->static_mac_table_override)) {
 		alu->mac[5] = (u8)data_lo;
 		alu->mac[4] = (u8)(data_lo >> 8);
 		alu->mac[3] = (u8)(data_lo >> 16);
 		alu->mac[2] = (u8)(data_lo >> 24);
 		alu->mac[1] = (u8)data_hi;
 		alu->mac[0] = (u8)(data_hi >> 8);
-		alu->port_forward = (data_hi & STATIC_MAC_TABLE_FWD_PORTS) >>
-			STATIC_MAC_FWD_PORTS_S;
+		alu->port_forward =
+			(data_hi & masks->static_mac_table_fwd_ports) >>
+				shifts->static_mac_fwd_ports;
 		alu->is_override =
-			(data_hi & STATIC_MAC_TABLE_OVERRIDE) ? 1 : 0;
+			(data_hi & masks->static_mac_table_override) ? 1 : 0;
 		data_hi >>= 1;
-		alu->is_use_fid = (data_hi & STATIC_MAC_TABLE_USE_FID) ? 1 : 0;
-		alu->fid = (data_hi & STATIC_MAC_TABLE_FID) >>
-			STATIC_MAC_FID_S;
+		alu->is_use_fid =
+			(data_hi & masks->static_mac_table_use_fid) ? 1 : 0;
+		alu->fid = (data_hi & masks->static_mac_table_fid) >>
+				shifts->static_mac_fid;
 		return 0;
 	}
 	return -ENXIO;
@@ -370,6 +432,9 @@ static int ksz8_r_sta_mac_table(struct ksz_device *dev, u16 addr,
 static void ksz8_w_sta_mac_table(struct ksz_device *dev, u16 addr,
 				 struct alu_struct *alu)
 {
+	struct ksz8 *ksz8 = dev->priv;
+	struct ksz_masks *masks = ksz8->masks;
+	struct ksz_shifts *shifts = ksz8->shifts;
 	u32 data_hi, data_lo;
 	u64 data;
 
@@ -377,36 +442,47 @@ static void ksz8_w_sta_mac_table(struct ksz_device *dev, u16 addr,
 		((u32)alu->mac[3] << 16) |
 		((u32)alu->mac[4] << 8) | alu->mac[5];
 	data_hi = ((u32)alu->mac[0] << 8) | alu->mac[1];
-	data_hi |= (u32)alu->port_forward << STATIC_MAC_FWD_PORTS_S;
+	data_hi |= (u32)alu->port_forward << shifts->static_mac_fwd_ports;
 
 	if (alu->is_override)
-		data_hi |= STATIC_MAC_TABLE_OVERRIDE;
+		data_hi |= masks->static_mac_table_override;
 	if (alu->is_use_fid) {
-		data_hi |= STATIC_MAC_TABLE_USE_FID;
-		data_hi |= (u32)alu->fid << STATIC_MAC_FID_S;
+		data_hi |= masks->static_mac_table_use_fid;
+		data_hi |= (u32)alu->fid << shifts->static_mac_fid;
 	}
 	if (alu->is_static)
-		data_hi |= STATIC_MAC_TABLE_VALID;
+		data_hi |= masks->static_mac_table_valid;
 	else
-		data_hi &= ~STATIC_MAC_TABLE_OVERRIDE;
+		data_hi &= ~masks->static_mac_table_override;
 
 	data = (u64)data_hi << 32 | data_lo;
 	ksz8_w_table(dev, TABLE_STATIC_MAC, addr, data);
 }
 
-static void ksz8_from_vlan(u16 vlan, u8 *fid, u8 *member, u8 *valid)
+static void ksz8_from_vlan(struct ksz_device *dev, u32 vlan, u8 *fid,
+			   u8 *member, u8 *valid)
 {
-	*fid = vlan & VLAN_TABLE_FID;
-	*member = (vlan & VLAN_TABLE_MEMBERSHIP) >> VLAN_TABLE_MEMBERSHIP_S;
-	*valid = !!(vlan & VLAN_TABLE_VALID);
+	struct ksz8 *ksz8 = dev->priv;
+	struct ksz_masks *masks = ksz8->masks;
+	struct ksz_shifts *shifts = ksz8->shifts;
+
+	*fid = vlan & masks->vlan_table_fid;
+	*member = (vlan & masks->vlan_table_membership) >>
+			shifts->vlan_table_membership;
+	*valid = !!(vlan & masks->vlan_table_valid);
 }
 
-static void ksz8_to_vlan(u8 fid, u8 member, u8 valid, u16 *vlan)
+static void ksz8_to_vlan(struct ksz_device *dev, u8 fid, u8 member, u8 valid,
+			 u32 *vlan)
 {
+	struct ksz8 *ksz8 = dev->priv;
+	struct ksz_masks *masks = ksz8->masks;
+	struct ksz_shifts *shifts = ksz8->shifts;
+
 	*vlan = fid;
-	*vlan |= (u16)member << VLAN_TABLE_MEMBERSHIP_S;
+	*vlan |= (u16)member << shifts->vlan_table_membership;
 	if (valid)
-		*vlan |= VLAN_TABLE_VALID;
+		*vlan |= masks->vlan_table_valid;
 }
 
 static void ksz8_r_vlan_entries(struct ksz_device *dev, u16 addr)
@@ -420,7 +496,7 @@ static void ksz8_r_vlan_entries(struct ksz_device *dev, u16 addr)
 	addr *= dev->port_cnt;
 	for (i = 0; i < dev->port_cnt; i++) {
 		dev->vlan_cache[addr + i].table[0] = (u16)data;
-		data >>= VLAN_TABLE_S;
+		data >>= shifts->vlan_table;
 	}
 }
 
@@ -456,6 +532,8 @@ static void ksz8_w_vlan_table(struct ksz_device *dev, u16 vid, u32 vlan)
 
 static void ksz8_r_phy(struct ksz_device *dev, u16 phy, u16 reg, u16 *val)
 {
+	struct ksz8 *ksz8 = dev->priv;
+	struct ksz_regs *regs = ksz8->regs;
 	u8 restart, speed, ctrl, link;
 	int processed = true;
 	u16 data = 0;
@@ -463,9 +541,9 @@ static void ksz8_r_phy(struct ksz_device *dev, u16 phy, u16 reg, u16 *val)
 
 	switch (reg) {
 	case PHY_REG_CTRL:
-		ksz_pread8(dev, p, P_NEG_RESTART_CTRL, &restart);
-		ksz_pread8(dev, p, P_SPEED_STATUS, &speed);
-		ksz_pread8(dev, p, P_FORCE_CTRL, &ctrl);
+		ksz_pread8(dev, p, regs->p_neg_restart_ctrl, &restart);
+		ksz_pread8(dev, p, regs->p_speed_status, &speed);
+		ksz_pread8(dev, p, regs->p_force_ctrl, &ctrl);
 		if (restart & PORT_PHY_LOOPBACK)
 			data |= PHY_LOOPBACK;
 		if (ctrl & PORT_FORCE_100_MBIT)
@@ -490,7 +568,7 @@ static void ksz8_r_phy(struct ksz_device *dev, u16 phy, u16 reg, u16 *val)
 			data |= PHY_LED_DISABLE;
 		break;
 	case PHY_REG_STATUS:
-		ksz_pread8(dev, p, P_LINK_STATUS, &link);
+		ksz_pread8(dev, p, regs->p_link_status, &link);
 		data = PHY_100BTX_FD_CAPABLE |
 		       PHY_100BTX_CAPABLE |
 		       PHY_10BT_FD_CAPABLE |
@@ -508,7 +586,7 @@ static void ksz8_r_phy(struct ksz_device *dev, u16 phy, u16 reg, u16 *val)
 		data = KSZ8795_ID_LO;
 		break;
 	case PHY_REG_AUTO_NEGOTIATION:
-		ksz_pread8(dev, p, P_LOCAL_CTRL, &ctrl);
+		ksz_pread8(dev, p, regs->p_local_ctrl, &ctrl);
 		data = PHY_AUTO_NEG_802_3;
 		if (ctrl & PORT_AUTO_NEG_SYM_PAUSE)
 			data |= PHY_AUTO_NEG_SYM_PAUSE;
@@ -522,7 +600,7 @@ static void ksz8_r_phy(struct ksz_device *dev, u16 phy, u16 reg, u16 *val)
 			data |= PHY_AUTO_NEG_10BT;
 		break;
 	case PHY_REG_REMOTE_CAPABILITY:
-		ksz_pread8(dev, p, P_REMOTE_STATUS, &link);
+		ksz_pread8(dev, p, regs->p_remote_status, &link);
 		data = PHY_AUTO_NEG_802_3;
 		if (link & PORT_REMOTE_SYM_PAUSE)
 			data |= PHY_AUTO_NEG_SYM_PAUSE;
@@ -548,6 +626,8 @@ static void ksz8_r_phy(struct ksz_device *dev, u16 phy, u16 reg, u16 *val)
 static void ksz8_w_phy(struct ksz_device *dev, u16 phy, u16 reg, u16 val)
 {
 	u8 p = phy;
+	struct ksz8 *ksz8 = dev->priv;
+	struct ksz_regs *regs = ksz8->regs;
 	u8 restart, speed, ctrl, data;
 
 	switch (reg) {
@@ -556,15 +636,15 @@ static void ksz8_w_phy(struct ksz_device *dev, u16 phy, u16 reg, u16 val)
 		/* Do not support PHY reset function. */
 		if (val & PHY_RESET)
 			break;
-		ksz_pread8(dev, p, P_SPEED_STATUS, &speed);
+		ksz_pread8(dev, p, regs->p_speed_status, &speed);
 		data = speed;
 		if (val & PHY_HP_MDIX)
 			data |= PORT_HP_MDIX;
 		else
 			data &= ~PORT_HP_MDIX;
 		if (data != speed)
-			ksz_pwrite8(dev, p, P_SPEED_STATUS, data);
-		ksz_pread8(dev, p, P_FORCE_CTRL, &ctrl);
+			ksz_pwrite8(dev, p, regs->p_speed_status, data);
+		ksz_pread8(dev, p, regs->p_force_ctrl, &ctrl);
 		data = ctrl;
 		if (!(val & PHY_AUTO_NEG_ENABLE))
 			data |= PORT_AUTO_NEG_DISABLE;
@@ -583,8 +663,8 @@ static void ksz8_w_phy(struct ksz_device *dev, u16 phy, u16 reg, u16 val)
 		else
 			data &= ~PORT_FORCE_FULL_DUPLEX;
 		if (data != ctrl)
-			ksz_pwrite8(dev, p, P_FORCE_CTRL, data);
-		ksz_pread8(dev, p, P_NEG_RESTART_CTRL, &restart);
+			ksz_pwrite8(dev, p, regs->p_force_ctrl, data);
+		ksz_pread8(dev, p, regs->p_neg_restart_ctrl, &restart);
 		data = restart;
 		if (val & PHY_LED_DISABLE)
 			data |= PORT_LED_OFF;
@@ -615,10 +695,10 @@ static void ksz8_w_phy(struct ksz_device *dev, u16 phy, u16 reg, u16 val)
 		else
 			data &= ~PORT_PHY_LOOPBACK;
 		if (data != restart)
-			ksz_pwrite8(dev, p, P_NEG_RESTART_CTRL, data);
+			ksz_pwrite8(dev, p, regs->p_neg_restart_ctrl, data);
 		break;
 	case PHY_REG_AUTO_NEGOTIATION:
-		ksz_pread8(dev, p, P_LOCAL_CTRL, &ctrl);
+		ksz_pread8(dev, p, regs->p_local_ctrl, &ctrl);
 		data = ctrl;
 		data &= ~(PORT_AUTO_NEG_SYM_PAUSE |
 			  PORT_AUTO_NEG_100BTX_FD |
@@ -636,7 +716,7 @@ static void ksz8_w_phy(struct ksz_device *dev, u16 phy, u16 reg, u16 val)
 		if (val & PHY_AUTO_NEG_10BT)
 			data |= PORT_AUTO_NEG_10BT;
 		if (data != ctrl)
-			ksz_pwrite8(dev, p, P_LOCAL_CTRL, data);
+			ksz_pwrite8(dev, p, regs->p_local_ctrl, data);
 		break;
 	default:
 		break;
@@ -793,14 +873,15 @@ static void ksz8_port_vlan_add(struct dsa_switch *ds, int port,
 {
 	bool untagged = vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
 	struct ksz_device *dev = ds->priv;
-	u16 data, vid, new_pvid = 0;
+	u16 vid, new_pvid = 0;
+	u32 data = 0;
 	u8 fid, member, valid;
 
 	ksz_port_cfg(dev, port, P_TAG_CTRL, PORT_REMOVE_TAG, untagged);
 
 	for (vid = vlan->vid_begin; vid <= vlan->vid_end; vid++) {
 		ksz8_r_vlan_table(dev, vid, &data);
-		ksz8_from_vlan(data, &fid, &member, &valid);
+		ksz8_from_vlan(dev, data, &fid, &member, &valid);
 
 		/* First time to setup the VLAN entry. */
 		if (!valid) {
@@ -810,9 +891,8 @@ static void ksz8_port_vlan_add(struct dsa_switch *ds, int port,
 		}
 		member |= BIT(port);
 
-		ksz8_to_vlan(fid, member, valid, &data);
+		ksz8_to_vlan(dev, fid, member, valid, &data);
 		ksz8_w_vlan_table(dev, vid, data);
-
 		/* change PVID */
 		if (vlan->flags & BRIDGE_VLAN_INFO_PVID)
 			new_pvid = vid;
@@ -831,7 +911,8 @@ static int ksz8_port_vlan_del(struct dsa_switch *ds, int port,
 {
 	bool untagged = vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
 	struct ksz_device *dev = ds->priv;
-	u16 data, vid, pvid, new_pvid = 0;
+	u32 data = 0;
+	u16 vid, pvid, new_pvid = 0;
 	u8 fid, member, valid;
 
 	ksz_pread16(dev, port, REG_PORT_CTRL_VID, &pvid);
@@ -841,7 +922,7 @@ static int ksz8_port_vlan_del(struct dsa_switch *ds, int port,
 
 	for (vid = vlan->vid_begin; vid <= vlan->vid_end; vid++) {
 		ksz8_r_vlan_table(dev, vid, &data);
-		ksz8_from_vlan(data, &fid, &member, &valid);
+		ksz8_from_vlan(dev, data, &fid, &member, &valid);
 
 		member &= ~BIT(port);
 
@@ -854,7 +935,7 @@ static int ksz8_port_vlan_del(struct dsa_switch *ds, int port,
 		if (pvid == vid)
 			new_pvid = 1;
 
-		ksz8_to_vlan(fid, member, valid, &data);
+		ksz8_to_vlan(dev, fid, member, valid, &data);
 		ksz8_w_vlan_table(dev, vid, data);
 	}
 
@@ -913,6 +994,8 @@ static void ksz8_port_setup(struct ksz_device *dev, int port, bool cpu_port)
 {
 	struct ksz_port *p = &dev->ports[port];
 	u8 data8, member;
+	struct ksz8 *ksz8 = dev->priv;
+	struct ksz_masks *masks = ksz8->masks;
 
 	/* enable broadcast storm limit */
 	ksz_port_cfg(dev, port, P_BCAST_STORM_CTRL, PORT_BROADCAST_STORM, true);
@@ -923,7 +1006,8 @@ static void ksz8_port_setup(struct ksz_device *dev, int port, bool cpu_port)
 	ksz_port_cfg(dev, port, P_PRIO_CTRL, PORT_DIFFSERV_ENABLE, false);
 
 	/* replace priority */
-	ksz_port_cfg(dev, port, P_802_1P_CTRL, PORT_802_1P_REMAPPING, false);
+	ksz_port_cfg(dev, port, P_802_1P_CTRL,
+		     masks->port_802_1p_remapping, false);
 
 	/* enable 802.1p priority */
 	ksz_port_cfg(dev, port, P_PRIO_CTRL, PORT_802_1P_ENABLE, true);
@@ -973,6 +1057,9 @@ static void ksz8_port_setup(struct ksz_device *dev, int port, bool cpu_port)
 static void ksz8_config_cpu_port(struct dsa_switch *ds)
 {
 	struct ksz_device *dev = ds->priv;
+	struct ksz8 *ksz8 = dev->priv;
+	struct ksz_regs *regs = ksz8->regs;
+	struct ksz_masks *masks = ksz8->masks;
 	struct ksz_port *p;
 	u8 remote;
 	int i;
@@ -981,7 +1068,7 @@ static void ksz8_config_cpu_port(struct dsa_switch *ds)
 
 	/* Switch marks the maximum frame with extra byte as oversize. */
 	ksz_cfg(dev, REG_SW_CTRL_2, SW_LEGAL_PACKET_DISABLE, true);
-	ksz_cfg(dev, S_TAIL_TAG_CTRL, SW_TAIL_TAG_ENABLE, true);
+	ksz_cfg(dev, regs->s_tail_tag_ctrl, masks->sw_tail_tag_enable, true);
 
 	p = &dev->ports[dev->cpu_port];
 	p->vid_member = dev->port_mask;
@@ -1010,7 +1097,7 @@ static void ksz8_config_cpu_port(struct dsa_switch *ds)
 		p = &dev->ports[i];
 		if (!p->on)
 			continue;
-		ksz_pread8(dev, i, P_REMOTE_STATUS, &remote);
+		ksz_pread8(dev, i, regs->p_remote_status, &remote);
 		if (remote & PORT_FIBER_MODE)
 			p->fiber = 1;
 		if (p->fiber)
@@ -1204,6 +1291,7 @@ static const struct ksz_chip_data ksz8_switch_chips[] = {
 static int ksz8_switch_init(struct ksz_device *dev)
 {
 	int i;
+	struct ksz8 *ksz8 = dev->priv;
 
 	dev->ds->ops = &ksz8_switch_ops;
 
@@ -1226,6 +1314,10 @@ static int ksz8_switch_init(struct ksz_device *dev)
 	if (!dev->cpu_ports)
 		return -ENODEV;
 
+	ksz8->regs = &ksz8795_regs;
+	ksz8->masks = &ksz8795_masks;
+	ksz8->shifts = &ksz8795_shifts;
+
 	dev->port_mask = BIT(dev->port_cnt) - 1;
 	dev->port_mask |= dev->host_mask;
 
-- 
2.28.0

