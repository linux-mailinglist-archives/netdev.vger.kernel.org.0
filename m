Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74235368E4D
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 10:02:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241480AbhDWIDT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 04:03:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241300AbhDWIDG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 04:03:06 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F87CC06138E
        for <netdev@vger.kernel.org>; Fri, 23 Apr 2021 01:02:30 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lZqlZ-0007an-C9; Fri, 23 Apr 2021 10:02:21 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lZqlX-0006vL-RF; Fri, 23 Apr 2021 10:02:19 +0200
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
Subject: [PATCH net-next v6 03/10] net: dsa: microchip: ksz8795: move register offsets and shifts to separate struct
Date:   Fri, 23 Apr 2021 10:02:11 +0200
Message-Id: <20210423080218.26526-4-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210423080218.26526-1-o.rempel@pengutronix.de>
References: <20210423080218.26526-1-o.rempel@pengutronix.de>
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

In order to get this driver used with other switches the functions need
to use different offsets and register shifts. This patch changes the
direct use of the register defines to register description structures,
which can be set depending on the chips register layout.

Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>

---
v1 -> v4: - extracted this change from bigger previous patch
v4 -> v5: - added missing variables in ksz8_r_vlan_entries
          - moved shifts, masks and registers to arrays indexed by enums
	  - using unsigned types where possible
v5 -> v6: - changed variable order to revers christmas tree
          - fixed shift entry VLAN_TABLE_MEMBERSHIP to VLAN_TABLE_MEMBERSHIP_S
---
 drivers/net/dsa/microchip/ksz8.h        |  69 +++++++
 drivers/net/dsa/microchip/ksz8795.c     | 260 +++++++++++++++++-------
 drivers/net/dsa/microchip/ksz8795_reg.h |  85 --------
 3 files changed, 253 insertions(+), 161 deletions(-)
 create mode 100644 drivers/net/dsa/microchip/ksz8.h

diff --git a/drivers/net/dsa/microchip/ksz8.h b/drivers/net/dsa/microchip/ksz8.h
new file mode 100644
index 000000000000..9d611895d3cf
--- /dev/null
+++ b/drivers/net/dsa/microchip/ksz8.h
@@ -0,0 +1,69 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Microchip KSZ8XXX series register access
+ *
+ * Copyright (C) 2020 Pengutronix, Michael Grzeschik <kernel@pengutronix.de>
+ */
+
+#ifndef __KSZ8XXX_H
+#define __KSZ8XXX_H
+#include <linux/kernel.h>
+
+enum ksz_regs {
+	REG_IND_CTRL_0,
+	REG_IND_DATA_8,
+	REG_IND_DATA_CHECK,
+	REG_IND_DATA_HI,
+	REG_IND_DATA_LO,
+	REG_IND_MIB_CHECK,
+	P_FORCE_CTRL,
+	P_LINK_STATUS,
+	P_LOCAL_CTRL,
+	P_NEG_RESTART_CTRL,
+	P_REMOTE_STATUS,
+	P_SPEED_STATUS,
+	S_TAIL_TAG_CTRL,
+};
+
+enum ksz_masks {
+	PORT_802_1P_REMAPPING,
+	SW_TAIL_TAG_ENABLE,
+	MIB_COUNTER_OVERFLOW,
+	MIB_COUNTER_VALID,
+	VLAN_TABLE_FID,
+	VLAN_TABLE_MEMBERSHIP,
+	VLAN_TABLE_VALID,
+	STATIC_MAC_TABLE_VALID,
+	STATIC_MAC_TABLE_USE_FID,
+	STATIC_MAC_TABLE_FID,
+	STATIC_MAC_TABLE_OVERRIDE,
+	STATIC_MAC_TABLE_FWD_PORTS,
+	DYNAMIC_MAC_TABLE_ENTRIES_H,
+	DYNAMIC_MAC_TABLE_MAC_EMPTY,
+	DYNAMIC_MAC_TABLE_NOT_READY,
+	DYNAMIC_MAC_TABLE_ENTRIES,
+	DYNAMIC_MAC_TABLE_FID,
+	DYNAMIC_MAC_TABLE_SRC_PORT,
+	DYNAMIC_MAC_TABLE_TIMESTAMP,
+};
+
+enum ksz_shifts {
+	VLAN_TABLE_MEMBERSHIP_S,
+	VLAN_TABLE,
+	STATIC_MAC_FWD_PORTS,
+	STATIC_MAC_FID,
+	DYNAMIC_MAC_ENTRIES_H,
+	DYNAMIC_MAC_ENTRIES,
+	DYNAMIC_MAC_FID,
+	DYNAMIC_MAC_TIMESTAMP,
+	DYNAMIC_MAC_SRC_PORT,
+};
+
+struct ksz8 {
+	const u8 *regs;
+	const u32 *masks;
+	const u8 *shifts;
+	void *priv;
+};
+
+#endif
diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index 85fb727c13eb..8835217e2804 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -20,6 +20,57 @@
 
 #include "ksz_common.h"
 #include "ksz8795_reg.h"
+#include "ksz8.h"
+
+static const u8 ksz8795_regs[] = {
+	[REG_IND_CTRL_0]		= 0x6E,
+	[REG_IND_DATA_8]		= 0x70,
+	[REG_IND_DATA_CHECK]		= 0x72,
+	[REG_IND_DATA_HI]		= 0x71,
+	[REG_IND_DATA_LO]		= 0x75,
+	[REG_IND_MIB_CHECK]		= 0x74,
+	[P_FORCE_CTRL]			= 0x0C,
+	[P_LINK_STATUS]			= 0x0E,
+	[P_LOCAL_CTRL]			= 0x07,
+	[P_NEG_RESTART_CTRL]		= 0x0D,
+	[P_REMOTE_STATUS]		= 0x08,
+	[P_SPEED_STATUS]		= 0x09,
+	[S_TAIL_TAG_CTRL]		= 0x0C,
+};
+
+static const u32 ksz8795_masks[] = {
+	[PORT_802_1P_REMAPPING]		= BIT(7),
+	[SW_TAIL_TAG_ENABLE]		= BIT(1),
+	[MIB_COUNTER_OVERFLOW]		= BIT(6),
+	[MIB_COUNTER_VALID]		= BIT(5),
+	[VLAN_TABLE_FID]		= GENMASK(6, 0),
+	[VLAN_TABLE_MEMBERSHIP]		= GENMASK(11, 7),
+	[VLAN_TABLE_VALID]		= BIT(12),
+	[STATIC_MAC_TABLE_VALID]	= BIT(21),
+	[STATIC_MAC_TABLE_USE_FID]	= BIT(23),
+	[STATIC_MAC_TABLE_FID]		= GENMASK(30, 24),
+	[STATIC_MAC_TABLE_OVERRIDE]	= BIT(26),
+	[STATIC_MAC_TABLE_FWD_PORTS]	= GENMASK(24, 20),
+	[DYNAMIC_MAC_TABLE_ENTRIES_H]	= GENMASK(6, 0),
+	[DYNAMIC_MAC_TABLE_MAC_EMPTY]	= BIT(8),
+	[DYNAMIC_MAC_TABLE_NOT_READY]	= BIT(7),
+	[DYNAMIC_MAC_TABLE_ENTRIES]	= GENMASK(31, 29),
+	[DYNAMIC_MAC_TABLE_FID]		= GENMASK(26, 20),
+	[DYNAMIC_MAC_TABLE_SRC_PORT]	= GENMASK(26, 24),
+	[DYNAMIC_MAC_TABLE_TIMESTAMP]	= GENMASK(28, 27),
+};
+
+static const u8 ksz8795_shifts[] = {
+	[VLAN_TABLE_MEMBERSHIP_S]	= 7,
+	[VLAN_TABLE]			= 16,
+	[STATIC_MAC_FWD_PORTS]		= 16,
+	[STATIC_MAC_FID]		= 24,
+	[DYNAMIC_MAC_ENTRIES_H]		= 3,
+	[DYNAMIC_MAC_ENTRIES]		= 29,
+	[DYNAMIC_MAC_FID]		= 16,
+	[DYNAMIC_MAC_TIMESTAMP]		= 27,
+	[DYNAMIC_MAC_SRC_PORT]		= 24,
+};
 
 static const struct {
 	char string[ETH_GSTRING_LEN];
@@ -119,6 +170,9 @@ static void ksz8795_set_prio_queue(struct ksz_device *dev, int port, int queue)
 
 static void ksz8_r_mib_cnt(struct ksz_device *dev, int port, u16 addr, u64 *cnt)
 {
+	struct ksz8 *ksz8 = dev->priv;
+	const u32 *masks = ksz8->masks;
+	const u8 *regs = ksz8->regs;
 	u16 ctrl_addr;
 	u32 data;
 	u8 check;
@@ -128,17 +182,17 @@ static void ksz8_r_mib_cnt(struct ksz_device *dev, int port, u16 addr, u64 *cnt)
 	ctrl_addr |= IND_ACC_TABLE(TABLE_MIB | TABLE_READ);
 
 	mutex_lock(&dev->alu_mutex);
-	ksz_write16(dev, REG_IND_CTRL_0, ctrl_addr);
+	ksz_write16(dev, regs[REG_IND_CTRL_0], ctrl_addr);
 
 	/* It is almost guaranteed to always read the valid bit because of
 	 * slow SPI speed.
 	 */
 	for (loop = 2; loop > 0; loop--) {
-		ksz_read8(dev, REG_IND_MIB_CHECK, &check);
+		ksz_read8(dev, regs[REG_IND_MIB_CHECK], &check);
 
-		if (check & MIB_COUNTER_VALID) {
-			ksz_read32(dev, REG_IND_DATA_LO, &data);
-			if (check & MIB_COUNTER_OVERFLOW)
+		if (check & masks[MIB_COUNTER_VALID]) {
+			ksz_read32(dev, regs[REG_IND_DATA_LO], &data);
+			if (check & masks[MIB_COUNTER_OVERFLOW])
 				*cnt += MIB_COUNTER_VALUE + 1;
 			*cnt += data & MIB_COUNTER_VALUE;
 			break;
@@ -150,6 +204,9 @@ static void ksz8_r_mib_cnt(struct ksz_device *dev, int port, u16 addr, u64 *cnt)
 static void ksz8_r_mib_pkt(struct ksz_device *dev, int port, u16 addr,
 			   u64 *dropped, u64 *cnt)
 {
+	struct ksz8 *ksz8 = dev->priv;
+	const u32 *masks = ksz8->masks;
+	const u8 *regs = ksz8->regs;
 	u16 ctrl_addr;
 	u32 data;
 	u8 check;
@@ -161,16 +218,16 @@ static void ksz8_r_mib_pkt(struct ksz_device *dev, int port, u16 addr,
 	ctrl_addr |= IND_ACC_TABLE(TABLE_MIB | TABLE_READ);
 
 	mutex_lock(&dev->alu_mutex);
-	ksz_write16(dev, REG_IND_CTRL_0, ctrl_addr);
+	ksz_write16(dev, regs[REG_IND_CTRL_0], ctrl_addr);
 
 	/* It is almost guaranteed to always read the valid bit because of
 	 * slow SPI speed.
 	 */
 	for (loop = 2; loop > 0; loop--) {
-		ksz_read8(dev, REG_IND_MIB_CHECK, &check);
+		ksz_read8(dev, regs[REG_IND_MIB_CHECK], &check);
 
-		if (check & MIB_COUNTER_VALID) {
-			ksz_read32(dev, REG_IND_DATA_LO, &data);
+		if (check & masks[MIB_COUNTER_VALID]) {
+			ksz_read32(dev, regs[REG_IND_DATA_LO], &data);
 			if (addr < 2) {
 				u64 total;
 
@@ -178,13 +235,13 @@ static void ksz8_r_mib_pkt(struct ksz_device *dev, int port, u16 addr,
 				total <<= 32;
 				*cnt += total;
 				*cnt += data;
-				if (check & MIB_COUNTER_OVERFLOW) {
+				if (check & masks[MIB_COUNTER_OVERFLOW]) {
 					total = MIB_TOTAL_BYTES_H + 1;
 					total <<= 32;
 					*cnt += total;
 				}
 			} else {
-				if (check & MIB_COUNTER_OVERFLOW)
+				if (check & masks[MIB_COUNTER_OVERFLOW])
 					*cnt += MIB_PACKET_DROPPED + 1;
 				*cnt += data & MIB_PACKET_DROPPED;
 			}
@@ -236,46 +293,53 @@ static void ksz8_port_init_cnt(struct ksz_device *dev, int port)
 
 static void ksz8_r_table(struct ksz_device *dev, int table, u16 addr, u64 *data)
 {
+	struct ksz8 *ksz8 = dev->priv;
+	const u8 *regs = ksz8->regs;
 	u16 ctrl_addr;
 
 	ctrl_addr = IND_ACC_TABLE(table | TABLE_READ) | addr;
 
 	mutex_lock(&dev->alu_mutex);
-	ksz_write16(dev, REG_IND_CTRL_0, ctrl_addr);
-	ksz_read64(dev, REG_IND_DATA_HI, data);
+	ksz_write16(dev, regs[REG_IND_CTRL_0], ctrl_addr);
+	ksz_read64(dev, regs[REG_IND_DATA_HI], data);
 	mutex_unlock(&dev->alu_mutex);
 }
 
 static void ksz8_w_table(struct ksz_device *dev, int table, u16 addr, u64 data)
 {
+	struct ksz8 *ksz8 = dev->priv;
+	const u8 *regs = ksz8->regs;
 	u16 ctrl_addr;
 
 	ctrl_addr = IND_ACC_TABLE(table) | addr;
 
 	mutex_lock(&dev->alu_mutex);
-	ksz_write64(dev, REG_IND_DATA_HI, data);
-	ksz_write16(dev, REG_IND_CTRL_0, ctrl_addr);
+	ksz_write64(dev, regs[REG_IND_DATA_HI], data);
+	ksz_write16(dev, regs[REG_IND_CTRL_0], ctrl_addr);
 	mutex_unlock(&dev->alu_mutex);
 }
 
 static int ksz8_valid_dyn_entry(struct ksz_device *dev, u8 *data)
 {
+	struct ksz8 *ksz8 = dev->priv;
+	const u32 *masks = ksz8->masks;
+	const u8 *regs = ksz8->regs;
 	int timeout = 100;
 
 	do {
-		ksz_read8(dev, REG_IND_DATA_CHECK, data);
+		ksz_read8(dev, regs[REG_IND_DATA_CHECK], data);
 		timeout--;
-	} while ((*data & DYNAMIC_MAC_TABLE_NOT_READY) && timeout);
+	} while ((*data & masks[DYNAMIC_MAC_TABLE_NOT_READY]) && timeout);
 
 	/* Entry is not ready for accessing. */
-	if (*data & DYNAMIC_MAC_TABLE_NOT_READY) {
+	if (*data & masks[DYNAMIC_MAC_TABLE_NOT_READY]) {
 		return -EAGAIN;
 	/* Entry is ready for accessing. */
 	} else {
-		ksz_read8(dev, REG_IND_DATA_8, data);
+		ksz_read8(dev, regs[REG_IND_DATA_8], data);
 
 		/* There is no valid entry in the table. */
-		if (*data & DYNAMIC_MAC_TABLE_MAC_EMPTY)
+		if (*data & masks[DYNAMIC_MAC_TABLE_MAC_EMPTY])
 			return -ENXIO;
 	}
 	return 0;
@@ -285,6 +349,10 @@ static int ksz8_r_dyn_mac_table(struct ksz_device *dev, u16 addr,
 				u8 *mac_addr, u8 *fid, u8 *src_port,
 				u8 *timestamp, u16 *entries)
 {
+	struct ksz8 *ksz8 = dev->priv;
+	const u8 *shifts = ksz8->shifts;
+	const u32 *masks = ksz8->masks;
+	const u8 *regs = ksz8->regs;
 	u32 data_hi, data_lo;
 	u16 ctrl_addr;
 	u8 data;
@@ -293,7 +361,7 @@ static int ksz8_r_dyn_mac_table(struct ksz_device *dev, u16 addr,
 	ctrl_addr = IND_ACC_TABLE(TABLE_DYNAMIC_MAC | TABLE_READ) | addr;
 
 	mutex_lock(&dev->alu_mutex);
-	ksz_write16(dev, REG_IND_CTRL_0, ctrl_addr);
+	ksz_write16(dev, regs[REG_IND_CTRL_0], ctrl_addr);
 
 	rc = ksz8_valid_dyn_entry(dev, &data);
 	if (rc == -EAGAIN) {
@@ -306,23 +374,23 @@ static int ksz8_r_dyn_mac_table(struct ksz_device *dev, u16 addr,
 		u64 buf = 0;
 		int cnt;
 
-		ksz_read64(dev, REG_IND_DATA_HI, &buf);
+		ksz_read64(dev, regs[REG_IND_DATA_HI], &buf);
 		data_hi = (u32)(buf >> 32);
 		data_lo = (u32)buf;
 
 		/* Check out how many valid entry in the table. */
-		cnt = data & DYNAMIC_MAC_TABLE_ENTRIES_H;
-		cnt <<= DYNAMIC_MAC_ENTRIES_H_S;
-		cnt |= (data_hi & DYNAMIC_MAC_TABLE_ENTRIES) >>
-			DYNAMIC_MAC_ENTRIES_S;
+		cnt = data & masks[DYNAMIC_MAC_TABLE_ENTRIES_H];
+		cnt <<= shifts[DYNAMIC_MAC_ENTRIES_H];
+		cnt |= (data_hi & masks[DYNAMIC_MAC_TABLE_ENTRIES]) >>
+			shifts[DYNAMIC_MAC_ENTRIES];
 		*entries = cnt + 1;
 
-		*fid = (data_hi & DYNAMIC_MAC_TABLE_FID) >>
-			DYNAMIC_MAC_FID_S;
-		*src_port = (data_hi & DYNAMIC_MAC_TABLE_SRC_PORT) >>
-			DYNAMIC_MAC_SRC_PORT_S;
-		*timestamp = (data_hi & DYNAMIC_MAC_TABLE_TIMESTAMP) >>
-			DYNAMIC_MAC_TIMESTAMP_S;
+		*fid = (data_hi & masks[DYNAMIC_MAC_TABLE_FID]) >>
+			shifts[DYNAMIC_MAC_FID];
+		*src_port = (data_hi & masks[DYNAMIC_MAC_TABLE_SRC_PORT]) >>
+			shifts[DYNAMIC_MAC_SRC_PORT];
+		*timestamp = (data_hi & masks[DYNAMIC_MAC_TABLE_TIMESTAMP]) >>
+			shifts[DYNAMIC_MAC_TIMESTAMP];
 
 		mac_addr[5] = (u8)data_lo;
 		mac_addr[4] = (u8)(data_lo >> 8);
@@ -341,27 +409,34 @@ static int ksz8_r_dyn_mac_table(struct ksz_device *dev, u16 addr,
 static int ksz8_r_sta_mac_table(struct ksz_device *dev, u16 addr,
 				struct alu_struct *alu)
 {
+	struct ksz8 *ksz8 = dev->priv;
+	const u8 *shifts = ksz8->shifts;
+	const u32 *masks = ksz8->masks;
 	u32 data_hi, data_lo;
 	u64 data;
 
 	ksz8_r_table(dev, TABLE_STATIC_MAC, addr, &data);
 	data_hi = data >> 32;
 	data_lo = (u32)data;
-	if (data_hi & (STATIC_MAC_TABLE_VALID | STATIC_MAC_TABLE_OVERRIDE)) {
+	if (data_hi & (masks[STATIC_MAC_TABLE_VALID] |
+			masks[STATIC_MAC_TABLE_OVERRIDE])) {
 		alu->mac[5] = (u8)data_lo;
 		alu->mac[4] = (u8)(data_lo >> 8);
 		alu->mac[3] = (u8)(data_lo >> 16);
 		alu->mac[2] = (u8)(data_lo >> 24);
 		alu->mac[1] = (u8)data_hi;
 		alu->mac[0] = (u8)(data_hi >> 8);
-		alu->port_forward = (data_hi & STATIC_MAC_TABLE_FWD_PORTS) >>
-			STATIC_MAC_FWD_PORTS_S;
+		alu->port_forward =
+			(data_hi & masks[STATIC_MAC_TABLE_FWD_PORTS]) >>
+				shifts[STATIC_MAC_FWD_PORTS];
 		alu->is_override =
-			(data_hi & STATIC_MAC_TABLE_OVERRIDE) ? 1 : 0;
+			(data_hi & masks[STATIC_MAC_TABLE_OVERRIDE]) ? 1 : 0;
 		data_hi >>= 1;
-		alu->is_use_fid = (data_hi & STATIC_MAC_TABLE_USE_FID) ? 1 : 0;
-		alu->fid = (data_hi & STATIC_MAC_TABLE_FID) >>
-			STATIC_MAC_FID_S;
+		alu->is_static = true;
+		alu->is_use_fid =
+			(data_hi & masks[STATIC_MAC_TABLE_USE_FID]) ? 1 : 0;
+		alu->fid = (data_hi & masks[STATIC_MAC_TABLE_FID]) >>
+				shifts[STATIC_MAC_FID];
 		return 0;
 	}
 	return -ENXIO;
@@ -370,6 +445,9 @@ static int ksz8_r_sta_mac_table(struct ksz_device *dev, u16 addr,
 static void ksz8_w_sta_mac_table(struct ksz_device *dev, u16 addr,
 				 struct alu_struct *alu)
 {
+	struct ksz8 *ksz8 = dev->priv;
+	const u8 *shifts = ksz8->shifts;
+	const u32 *masks = ksz8->masks;
 	u32 data_hi, data_lo;
 	u64 data;
 
@@ -377,40 +455,53 @@ static void ksz8_w_sta_mac_table(struct ksz_device *dev, u16 addr,
 		((u32)alu->mac[3] << 16) |
 		((u32)alu->mac[4] << 8) | alu->mac[5];
 	data_hi = ((u32)alu->mac[0] << 8) | alu->mac[1];
-	data_hi |= (u32)alu->port_forward << STATIC_MAC_FWD_PORTS_S;
+	data_hi |= (u32)alu->port_forward << shifts[STATIC_MAC_FWD_PORTS];
 
 	if (alu->is_override)
-		data_hi |= STATIC_MAC_TABLE_OVERRIDE;
+		data_hi |= masks[STATIC_MAC_TABLE_OVERRIDE];
 	if (alu->is_use_fid) {
-		data_hi |= STATIC_MAC_TABLE_USE_FID;
-		data_hi |= (u32)alu->fid << STATIC_MAC_FID_S;
+		data_hi |= masks[STATIC_MAC_TABLE_USE_FID];
+		data_hi |= (u32)alu->fid << shifts[STATIC_MAC_FID];
 	}
 	if (alu->is_static)
-		data_hi |= STATIC_MAC_TABLE_VALID;
+		data_hi |= masks[STATIC_MAC_TABLE_VALID];
 	else
-		data_hi &= ~STATIC_MAC_TABLE_OVERRIDE;
+		data_hi &= ~masks[STATIC_MAC_TABLE_OVERRIDE];
 
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
+	const u8 *shifts = ksz8->shifts;
+	const u32 *masks = ksz8->masks;
+
+	*fid = vlan & masks[VLAN_TABLE_FID];
+	*member = (vlan & masks[VLAN_TABLE_MEMBERSHIP]) >>
+			shifts[VLAN_TABLE_MEMBERSHIP_S];
+	*valid = !!(vlan & masks[VLAN_TABLE_VALID]);
 }
 
-static void ksz8_to_vlan(u8 fid, u8 member, u8 valid, u16 *vlan)
+static void ksz8_to_vlan(struct ksz_device *dev, u8 fid, u8 member, u8 valid,
+			 u32 *vlan)
 {
+	struct ksz8 *ksz8 = dev->priv;
+	const u8 *shifts = ksz8->shifts;
+	const u32 *masks = ksz8->masks;
+
 	*vlan = fid;
-	*vlan |= (u16)member << VLAN_TABLE_MEMBERSHIP_S;
+	*vlan |= (u16)member << shifts[VLAN_TABLE_MEMBERSHIP_S];
 	if (valid)
-		*vlan |= VLAN_TABLE_VALID;
+		*vlan |= masks[VLAN_TABLE_VALID];
 }
 
 static void ksz8_r_vlan_entries(struct ksz_device *dev, u16 addr)
 {
+	struct ksz8 *ksz8 = dev->priv;
+	const u8 *shifts = ksz8->shifts;
 	u64 data;
 	int i;
 
@@ -418,7 +509,7 @@ static void ksz8_r_vlan_entries(struct ksz_device *dev, u16 addr)
 	addr *= dev->phy_port_cnt;
 	for (i = 0; i < dev->phy_port_cnt; i++) {
 		dev->vlan_cache[addr + i].table[0] = (u16)data;
-		data >>= VLAN_TABLE_S;
+		data >>= shifts[VLAN_TABLE];
 	}
 }
 
@@ -454,16 +545,18 @@ static void ksz8_w_vlan_table(struct ksz_device *dev, u16 vid, u16 vlan)
 
 static void ksz8_r_phy(struct ksz_device *dev, u16 phy, u16 reg, u16 *val)
 {
+	struct ksz8 *ksz8 = dev->priv;
 	u8 restart, speed, ctrl, link;
+	const u8 *regs = ksz8->regs;
 	int processed = true;
 	u16 data = 0;
 	u8 p = phy;
 
 	switch (reg) {
 	case PHY_REG_CTRL:
-		ksz_pread8(dev, p, P_NEG_RESTART_CTRL, &restart);
-		ksz_pread8(dev, p, P_SPEED_STATUS, &speed);
-		ksz_pread8(dev, p, P_FORCE_CTRL, &ctrl);
+		ksz_pread8(dev, p, regs[P_NEG_RESTART_CTRL], &restart);
+		ksz_pread8(dev, p, regs[P_SPEED_STATUS], &speed);
+		ksz_pread8(dev, p, regs[P_FORCE_CTRL], &ctrl);
 		if (restart & PORT_PHY_LOOPBACK)
 			data |= PHY_LOOPBACK;
 		if (ctrl & PORT_FORCE_100_MBIT)
@@ -488,7 +581,7 @@ static void ksz8_r_phy(struct ksz_device *dev, u16 phy, u16 reg, u16 *val)
 			data |= PHY_LED_DISABLE;
 		break;
 	case PHY_REG_STATUS:
-		ksz_pread8(dev, p, P_LINK_STATUS, &link);
+		ksz_pread8(dev, p, regs[P_LINK_STATUS], &link);
 		data = PHY_100BTX_FD_CAPABLE |
 		       PHY_100BTX_CAPABLE |
 		       PHY_10BT_FD_CAPABLE |
@@ -506,7 +599,7 @@ static void ksz8_r_phy(struct ksz_device *dev, u16 phy, u16 reg, u16 *val)
 		data = KSZ8795_ID_LO;
 		break;
 	case PHY_REG_AUTO_NEGOTIATION:
-		ksz_pread8(dev, p, P_LOCAL_CTRL, &ctrl);
+		ksz_pread8(dev, p, regs[P_LOCAL_CTRL], &ctrl);
 		data = PHY_AUTO_NEG_802_3;
 		if (ctrl & PORT_AUTO_NEG_SYM_PAUSE)
 			data |= PHY_AUTO_NEG_SYM_PAUSE;
@@ -520,7 +613,7 @@ static void ksz8_r_phy(struct ksz_device *dev, u16 phy, u16 reg, u16 *val)
 			data |= PHY_AUTO_NEG_10BT;
 		break;
 	case PHY_REG_REMOTE_CAPABILITY:
-		ksz_pread8(dev, p, P_REMOTE_STATUS, &link);
+		ksz_pread8(dev, p, regs[P_REMOTE_STATUS], &link);
 		data = PHY_AUTO_NEG_802_3;
 		if (link & PORT_REMOTE_SYM_PAUSE)
 			data |= PHY_AUTO_NEG_SYM_PAUSE;
@@ -546,7 +639,9 @@ static void ksz8_r_phy(struct ksz_device *dev, u16 phy, u16 reg, u16 *val)
 static void ksz8_w_phy(struct ksz_device *dev, u16 phy, u16 reg, u16 val)
 {
 	u8 p = phy;
+	struct ksz8 *ksz8 = dev->priv;
 	u8 restart, speed, ctrl, data;
+	const u8 *regs = ksz8->regs;
 
 	switch (reg) {
 	case PHY_REG_CTRL:
@@ -554,15 +649,15 @@ static void ksz8_w_phy(struct ksz_device *dev, u16 phy, u16 reg, u16 val)
 		/* Do not support PHY reset function. */
 		if (val & PHY_RESET)
 			break;
-		ksz_pread8(dev, p, P_SPEED_STATUS, &speed);
+		ksz_pread8(dev, p, regs[P_SPEED_STATUS], &speed);
 		data = speed;
 		if (val & PHY_HP_MDIX)
 			data |= PORT_HP_MDIX;
 		else
 			data &= ~PORT_HP_MDIX;
 		if (data != speed)
-			ksz_pwrite8(dev, p, P_SPEED_STATUS, data);
-		ksz_pread8(dev, p, P_FORCE_CTRL, &ctrl);
+			ksz_pwrite8(dev, p, regs[P_SPEED_STATUS], data);
+		ksz_pread8(dev, p, regs[P_FORCE_CTRL], &ctrl);
 		data = ctrl;
 		if (!(val & PHY_AUTO_NEG_ENABLE))
 			data |= PORT_AUTO_NEG_DISABLE;
@@ -581,8 +676,8 @@ static void ksz8_w_phy(struct ksz_device *dev, u16 phy, u16 reg, u16 val)
 		else
 			data &= ~PORT_FORCE_FULL_DUPLEX;
 		if (data != ctrl)
-			ksz_pwrite8(dev, p, P_FORCE_CTRL, data);
-		ksz_pread8(dev, p, P_NEG_RESTART_CTRL, &restart);
+			ksz_pwrite8(dev, p, regs[P_FORCE_CTRL], data);
+		ksz_pread8(dev, p, regs[P_NEG_RESTART_CTRL], &restart);
 		data = restart;
 		if (val & PHY_LED_DISABLE)
 			data |= PORT_LED_OFF;
@@ -613,10 +708,10 @@ static void ksz8_w_phy(struct ksz_device *dev, u16 phy, u16 reg, u16 val)
 		else
 			data &= ~PORT_PHY_LOOPBACK;
 		if (data != restart)
-			ksz_pwrite8(dev, p, P_NEG_RESTART_CTRL, data);
+			ksz_pwrite8(dev, p, regs[P_NEG_RESTART_CTRL], data);
 		break;
 	case PHY_REG_AUTO_NEGOTIATION:
-		ksz_pread8(dev, p, P_LOCAL_CTRL, &ctrl);
+		ksz_pread8(dev, p, regs[P_LOCAL_CTRL], &ctrl);
 		data = ctrl;
 		data &= ~(PORT_AUTO_NEG_SYM_PAUSE |
 			  PORT_AUTO_NEG_100BTX_FD |
@@ -634,7 +729,7 @@ static void ksz8_w_phy(struct ksz_device *dev, u16 phy, u16 reg, u16 val)
 		if (val & PHY_AUTO_NEG_10BT)
 			data |= PORT_AUTO_NEG_10BT;
 		if (data != ctrl)
-			ksz_pwrite8(dev, p, P_LOCAL_CTRL, data);
+			ksz_pwrite8(dev, p, regs[P_LOCAL_CTRL], data);
 		break;
 	default:
 		break;
@@ -793,13 +888,14 @@ static int ksz8_port_vlan_add(struct dsa_switch *ds, int port,
 {
 	bool untagged = vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
 	struct ksz_device *dev = ds->priv;
-	u16 data, new_pvid = 0;
+	u16 new_pvid = 0;
+	u32 data = 0;
 	u8 fid, member, valid;
 
 	ksz_port_cfg(dev, port, P_TAG_CTRL, PORT_REMOVE_TAG, untagged);
 
 	ksz8_r_vlan_table(dev, vlan->vid, &data);
-	ksz8_from_vlan(data, &fid, &member, &valid);
+	ksz8_from_vlan(dev, data, &fid, &member, &valid);
 
 	/* First time to setup the VLAN entry. */
 	if (!valid) {
@@ -809,7 +905,7 @@ static int ksz8_port_vlan_add(struct dsa_switch *ds, int port,
 	}
 	member |= BIT(port);
 
-	ksz8_to_vlan(fid, member, valid, &data);
+	ksz8_to_vlan(dev, fid, member, valid, &data);
 	ksz8_w_vlan_table(dev, vlan->vid, data);
 
 	/* change PVID */
@@ -833,7 +929,8 @@ static int ksz8_port_vlan_del(struct dsa_switch *ds, int port,
 {
 	bool untagged = vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
 	struct ksz_device *dev = ds->priv;
-	u16 data, pvid, new_pvid = 0;
+	u16 pvid, new_pvid = 0;
+	u32 data = 0;
 	u8 fid, member, valid;
 
 	ksz_pread16(dev, port, REG_PORT_CTRL_VID, &pvid);
@@ -842,7 +939,7 @@ static int ksz8_port_vlan_del(struct dsa_switch *ds, int port,
 	ksz_port_cfg(dev, port, P_TAG_CTRL, PORT_REMOVE_TAG, untagged);
 
 	ksz8_r_vlan_table(dev, vlan->vid, &data);
-	ksz8_from_vlan(data, &fid, &member, &valid);
+	ksz8_from_vlan(dev, data, &fid, &member, &valid);
 
 	member &= ~BIT(port);
 
@@ -855,7 +952,7 @@ static int ksz8_port_vlan_del(struct dsa_switch *ds, int port,
 	if (pvid == vlan->vid)
 		new_pvid = 1;
 
-	ksz8_to_vlan(fid, member, valid, &data);
+	ksz8_to_vlan(dev, fid, member, valid, &data);
 	ksz8_w_vlan_table(dev, vlan->vid, data);
 
 	if (new_pvid != pvid)
@@ -960,6 +1057,8 @@ static void ksz8795_cpu_interface_select(struct ksz_device *dev, int port)
 static void ksz8_port_setup(struct ksz_device *dev, int port, bool cpu_port)
 {
 	struct ksz_port *p = &dev->ports[port];
+	struct ksz8 *ksz8 = dev->priv;
+	const u32 *masks = ksz8->masks;
 	u8 member;
 
 	/* enable broadcast storm limit */
@@ -971,7 +1070,8 @@ static void ksz8_port_setup(struct ksz_device *dev, int port, bool cpu_port)
 	ksz_port_cfg(dev, port, P_PRIO_CTRL, PORT_DIFFSERV_ENABLE, false);
 
 	/* replace priority */
-	ksz_port_cfg(dev, port, P_802_1P_CTRL, PORT_802_1P_REMAPPING, false);
+	ksz_port_cfg(dev, port, P_802_1P_CTRL,
+		     masks[PORT_802_1P_REMAPPING], false);
 
 	/* enable 802.1p priority */
 	ksz_port_cfg(dev, port, P_PRIO_CTRL, PORT_802_1P_ENABLE, true);
@@ -989,13 +1089,16 @@ static void ksz8_port_setup(struct ksz_device *dev, int port, bool cpu_port)
 static void ksz8_config_cpu_port(struct dsa_switch *ds)
 {
 	struct ksz_device *dev = ds->priv;
+	struct ksz8 *ksz8 = dev->priv;
+	const u32 *masks = ksz8->masks;
+	const u8 *regs = ksz8->regs;
 	struct ksz_port *p;
 	u8 remote;
 	int i;
 
 	/* Switch marks the maximum frame with extra byte as oversize. */
 	ksz_cfg(dev, REG_SW_CTRL_2, SW_LEGAL_PACKET_DISABLE, true);
-	ksz_cfg(dev, S_TAIL_TAG_CTRL, SW_TAIL_TAG_ENABLE, true);
+	ksz_cfg(dev, regs[S_TAIL_TAG_CTRL], masks[SW_TAIL_TAG_ENABLE], true);
 
 	p = &dev->ports[dev->cpu_port];
 	p->vid_member = dev->port_mask;
@@ -1024,7 +1127,7 @@ static void ksz8_config_cpu_port(struct dsa_switch *ds)
 		p = &dev->ports[i];
 		if (!p->on)
 			continue;
-		ksz_pread8(dev, i, P_REMOTE_STATUS, &remote);
+		ksz_pread8(dev, i, regs[P_REMOTE_STATUS], &remote);
 		if (remote & PORT_FIBER_MODE)
 			p->fiber = 1;
 		if (p->fiber)
@@ -1223,6 +1326,7 @@ static const struct ksz_chip_data ksz8_switch_chips[] = {
 static int ksz8_switch_init(struct ksz_device *dev)
 {
 	int i;
+	struct ksz8 *ksz8 = dev->priv;
 
 	dev->ds->ops = &ksz8_switch_ops;
 
@@ -1249,6 +1353,10 @@ static int ksz8_switch_init(struct ksz_device *dev)
 	if (!dev->cpu_ports)
 		return -ENODEV;
 
+	ksz8->regs = ksz8795_regs;
+	ksz8->masks = ksz8795_masks;
+	ksz8->shifts = ksz8795_shifts;
+
 	dev->reg_mib_cnt = KSZ8795_COUNTER_NUM;
 	dev->mib_cnt = ARRAY_SIZE(mib_names);
 
diff --git a/drivers/net/dsa/microchip/ksz8795_reg.h b/drivers/net/dsa/microchip/ksz8795_reg.h
index 40372047d40d..eea78c5636a0 100644
--- a/drivers/net/dsa/microchip/ksz8795_reg.h
+++ b/drivers/net/dsa/microchip/ksz8795_reg.h
@@ -98,7 +98,6 @@
 
 #define REG_SW_CTRL_10			0x0C
 
-#define SW_TAIL_TAG_ENABLE		BIT(1)
 #define SW_PASS_PAUSE			BIT(0)
 
 #define REG_SW_CTRL_11			0x0D
@@ -150,7 +149,6 @@
 #define REG_PORT_4_CTRL_2		0x42
 #define REG_PORT_5_CTRL_2		0x52
 
-#define PORT_802_1P_REMAPPING		BIT(7)
 #define PORT_INGRESS_FILTER		BIT(6)
 #define PORT_DISCARD_NON_VID		BIT(5)
 #define PORT_FORCE_FLOW_CTRL		BIT(4)
@@ -319,14 +317,12 @@
 
 #define REG_PORT_CTRL_5			0x05
 
-#define REG_PORT_CTRL_7			0x07
 #define REG_PORT_STATUS_0		0x08
 #define REG_PORT_STATUS_1		0x09
 #define REG_PORT_LINK_MD_CTRL		0x0A
 #define REG_PORT_LINK_MD_RESULT		0x0B
 #define REG_PORT_CTRL_9			0x0C
 #define REG_PORT_CTRL_10		0x0D
-#define REG_PORT_STATUS_2		0x0E
 #define REG_PORT_STATUS_3		0x0F
 
 #define REG_PORT_CTRL_12		0xA0
@@ -356,8 +352,6 @@
 #define REG_SW_MAC_ADDR_4		0x6C
 #define REG_SW_MAC_ADDR_5		0x6D
 
-#define REG_IND_CTRL_0			0x6E
-
 #define TABLE_EXT_SELECT_S		5
 #define TABLE_EEE_V			1
 #define TABLE_ACL_V			2
@@ -383,23 +377,13 @@
 #define TABLE_ENTRY_MASK		0x03FF
 #define TABLE_EXT_ENTRY_MASK		0x0FFF
 
-#define REG_IND_DATA_8			0x70
-#define REG_IND_DATA_7			0x71
-#define REG_IND_DATA_6			0x72
 #define REG_IND_DATA_5			0x73
-#define REG_IND_DATA_4			0x74
-#define REG_IND_DATA_3			0x75
 #define REG_IND_DATA_2			0x76
 #define REG_IND_DATA_1			0x77
 #define REG_IND_DATA_0			0x78
 
 #define REG_IND_DATA_PME_EEE_ACL	0xA0
 
-#define REG_IND_DATA_CHECK		REG_IND_DATA_6
-#define REG_IND_MIB_CHECK		REG_IND_DATA_4
-#define REG_IND_DATA_HI			REG_IND_DATA_7
-#define REG_IND_DATA_LO			REG_IND_DATA_3
-
 #define REG_INT_STATUS			0x7C
 #define REG_INT_ENABLE			0x7D
 
@@ -856,12 +840,6 @@
 #define P_MIRROR_CTRL			REG_PORT_CTRL_1
 #define P_802_1P_CTRL			REG_PORT_CTRL_2
 #define P_STP_CTRL			REG_PORT_CTRL_2
-#define P_LOCAL_CTRL			REG_PORT_CTRL_7
-#define P_REMOTE_STATUS			REG_PORT_STATUS_0
-#define P_FORCE_CTRL			REG_PORT_CTRL_9
-#define P_NEG_RESTART_CTRL		REG_PORT_CTRL_10
-#define P_SPEED_STATUS			REG_PORT_STATUS_1
-#define P_LINK_STATUS			REG_PORT_STATUS_2
 #define P_PASS_ALL_CTRL			REG_PORT_CTRL_12
 #define P_INS_SRC_PVID_CTRL		REG_PORT_CTRL_12
 #define P_DROP_TAG_CTRL			REG_PORT_CTRL_13
@@ -876,7 +854,6 @@
 #define S_MIRROR_CTRL			REG_SW_CTRL_3
 #define S_REPLACE_VID_CTRL		REG_SW_CTRL_4
 #define S_PASS_PAUSE_CTRL		REG_SW_CTRL_10
-#define S_TAIL_TAG_CTRL			REG_SW_CTRL_10
 #define S_802_1P_PRIO_CTRL		REG_SW_CTRL_12
 #define S_TOS_PRIO_CTRL			REG_TOS_PRIO_CTRL_0
 #define S_IPV6_MLD_CTRL			REG_SW_CTRL_21
@@ -889,65 +866,6 @@
 /* 148,800 frames * 67 ms / 100 */
 #define BROADCAST_STORM_VALUE		9969
 
-/**
- * STATIC_MAC_TABLE_ADDR		00-0000FFFF-FFFFFFFF
- * STATIC_MAC_TABLE_FWD_PORTS		00-001F0000-00000000
- * STATIC_MAC_TABLE_VALID		00-00200000-00000000
- * STATIC_MAC_TABLE_OVERRIDE		00-00400000-00000000
- * STATIC_MAC_TABLE_USE_FID		00-00800000-00000000
- * STATIC_MAC_TABLE_FID			00-7F000000-00000000
- */
-
-#define STATIC_MAC_TABLE_ADDR		0x0000FFFF
-#define STATIC_MAC_TABLE_FWD_PORTS	0x001F0000
-#define STATIC_MAC_TABLE_VALID		0x00200000
-#define STATIC_MAC_TABLE_OVERRIDE	0x00400000
-#define STATIC_MAC_TABLE_USE_FID	0x00800000
-#define STATIC_MAC_TABLE_FID		0x7F000000
-
-#define STATIC_MAC_FWD_PORTS_S		16
-#define STATIC_MAC_FID_S		24
-
-/**
- * VLAN_TABLE_FID			00-007F007F-007F007F
- * VLAN_TABLE_MEMBERSHIP		00-0F800F80-0F800F80
- * VLAN_TABLE_VALID			00-10001000-10001000
- */
-
-#define VLAN_TABLE_FID			0x007F
-#define VLAN_TABLE_MEMBERSHIP		0x0F80
-#define VLAN_TABLE_VALID		0x1000
-
-#define VLAN_TABLE_MEMBERSHIP_S		7
-#define VLAN_TABLE_S			16
-
-/**
- * DYNAMIC_MAC_TABLE_ADDR		00-0000FFFF-FFFFFFFF
- * DYNAMIC_MAC_TABLE_FID		00-007F0000-00000000
- * DYNAMIC_MAC_TABLE_NOT_READY		00-00800000-00000000
- * DYNAMIC_MAC_TABLE_SRC_PORT		00-07000000-00000000
- * DYNAMIC_MAC_TABLE_TIMESTAMP		00-18000000-00000000
- * DYNAMIC_MAC_TABLE_ENTRIES		7F-E0000000-00000000
- * DYNAMIC_MAC_TABLE_MAC_EMPTY		80-00000000-00000000
- */
-
-#define DYNAMIC_MAC_TABLE_ADDR		0x0000FFFF
-#define DYNAMIC_MAC_TABLE_FID		0x007F0000
-#define DYNAMIC_MAC_TABLE_SRC_PORT	0x07000000
-#define DYNAMIC_MAC_TABLE_TIMESTAMP	0x18000000
-#define DYNAMIC_MAC_TABLE_ENTRIES	0xE0000000
-
-#define DYNAMIC_MAC_TABLE_NOT_READY	0x80
-
-#define DYNAMIC_MAC_TABLE_ENTRIES_H	0x7F
-#define DYNAMIC_MAC_TABLE_MAC_EMPTY	0x80
-
-#define DYNAMIC_MAC_FID_S		16
-#define DYNAMIC_MAC_SRC_PORT_S		24
-#define DYNAMIC_MAC_TIMESTAMP_S		27
-#define DYNAMIC_MAC_ENTRIES_S		29
-#define DYNAMIC_MAC_ENTRIES_H_S		3
-
 /**
  * MIB_COUNTER_VALUE			00-00000000-3FFFFFFF
  * MIB_TOTAL_BYTES			00-0000000F-FFFFFFFF
@@ -956,9 +874,6 @@
  * MIB_COUNTER_OVERFLOW			00-00000040-00000000
  */
 
-#define MIB_COUNTER_OVERFLOW		BIT(6)
-#define MIB_COUNTER_VALID		BIT(5)
-
 #define MIB_COUNTER_VALUE		0x3FFFFFFF
 
 #define KS_MIB_TOTAL_RX_0		0x100
-- 
2.29.2

