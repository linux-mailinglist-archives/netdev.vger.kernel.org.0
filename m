Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F0FA1252BA
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 21:08:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727558AbfLRUIm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 15:08:42 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:45241 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726824AbfLRUIl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 15:08:41 -0500
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mgr@pengutronix.de>)
        id 1ihfcc-0004WT-M3; Wed, 18 Dec 2019 21:08:38 +0100
Received: from mgr by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <mgr@pengutronix.de>)
        id 1ihfcb-0004ba-85; Wed, 18 Dec 2019 21:08:37 +0100
From:   Michael Grzeschik <m.grzeschik@pengutronix.de>
To:     andrew@lunn.ch
Cc:     f.fainelli@gmail.com, netdev@vger.kernel.org, davem@davemloft.net,
        kernel@pengutronix.de
Subject: [PATCH v2 3/4] ksz: Add Microchip KSZ8863 SMI based driver support
Date:   Wed, 18 Dec 2019 21:08:30 +0100
Message-Id: <20191218200831.13796-4-m.grzeschik@pengutronix.de>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191218200831.13796-1-m.grzeschik@pengutronix.de>
References: <20191218200831.13796-1-m.grzeschik@pengutronix.de>
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

We add support for the KXZ88X3 three port switches using the Microchip
SMI Interface. They are currently only supported using the MDIO-Bitbang
Interface. Which is making use of the mdio_ll_read/write functions. The
patch uses the common functions from the ksz8795 driver.

Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
---
RFC -> v1: - added Microchip SMI to description
           - added select MDIO_BITBANG
           - added return error code handling in mdiobus_read/write
           - fixed the stp state handling
           - moved tag handling code to seperate patch

v1 -> v2:  - completely reworked the driver to use existing ksz8795 functions

 drivers/net/dsa/microchip/Kconfig       |   9 +
 drivers/net/dsa/microchip/Makefile      |   1 +
 drivers/net/dsa/microchip/ksz8.h        |  68 ++
 drivers/net/dsa/microchip/ksz8795.c     | 875 ++++++++++++++++--------
 drivers/net/dsa/microchip/ksz8795_reg.h | 213 +++---
 drivers/net/dsa/microchip/ksz8795_spi.c |   7 +-
 drivers/net/dsa/microchip/ksz8863_reg.h | 121 ++++
 drivers/net/dsa/microchip/ksz8863_smi.c | 183 +++++
 drivers/net/dsa/microchip/ksz_common.h  |   1 +
 9 files changed, 1101 insertions(+), 377 deletions(-)
 create mode 100644 drivers/net/dsa/microchip/ksz8.h
 create mode 100644 drivers/net/dsa/microchip/ksz8863_reg.h
 create mode 100644 drivers/net/dsa/microchip/ksz8863_smi.c

diff --git a/drivers/net/dsa/microchip/Kconfig b/drivers/net/dsa/microchip/Kconfig
index 1d7870c6df3ce..a94985f77a3ec 100644
--- a/drivers/net/dsa/microchip/Kconfig
+++ b/drivers/net/dsa/microchip/Kconfig
@@ -39,3 +39,12 @@ config NET_DSA_MICROCHIP_KSZ8795_SPI
 
 	  It is required to use the KSZ8795 switch driver as the only access
 	  is through SPI.
+
+config NET_DSA_MICROCHIP_KSZ8863_SMI
+	tristate "KSZ series SMI connected switch driver"
+	depends on NET_DSA_MICROCHIP_KSZ8795
+	select MDIO_BITBANG
+	default y
+	help
+	  Select to enable support for registering switches configured through
+	  Microchip SMI. It Supports the KSZ8863 and KSZ8873 Switch.
diff --git a/drivers/net/dsa/microchip/Makefile b/drivers/net/dsa/microchip/Makefile
index 929caa81e782e..2a03b21a3386f 100644
--- a/drivers/net/dsa/microchip/Makefile
+++ b/drivers/net/dsa/microchip/Makefile
@@ -5,3 +5,4 @@ obj-$(CONFIG_NET_DSA_MICROCHIP_KSZ9477_I2C)	+= ksz9477_i2c.o
 obj-$(CONFIG_NET_DSA_MICROCHIP_KSZ9477_SPI)	+= ksz9477_spi.o
 obj-$(CONFIG_NET_DSA_MICROCHIP_KSZ8795)		+= ksz8795.o
 obj-$(CONFIG_NET_DSA_MICROCHIP_KSZ8795_SPI)	+= ksz8795_spi.o
+obj-$(CONFIG_NET_DSA_MICROCHIP_KSZ8863_SMI)	+= ksz8863_smi.o
diff --git a/drivers/net/dsa/microchip/ksz8.h b/drivers/net/dsa/microchip/ksz8.h
new file mode 100644
index 0000000000000..a2fb6b9e2d1e5
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
index b8877770a8fc6..5468d75405f06 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -20,10 +20,109 @@
 
 #include "ksz_common.h"
 #include "ksz8795_reg.h"
+#include "ksz8863_reg.h"
+#include "ksz8.h"
+
+static struct ksz_regs ksz8795_regs = {
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
+};
+
+static struct ksz_masks ksz8795_masks = {
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
+};
+
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
@@ -62,6 +161,45 @@ static const struct {
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
@@ -74,6 +212,11 @@ static void ksz_port_cfg(struct ksz_device *dev, int port, int offset, u8 bits,
 			   bits, set ? bits : 0);
 }
 
+static int ksz_is_87(struct ksz_device *dev)
+{
+	return (((dev->chip_id) >> 8) == KSZ87_FAMILY_ID);
+}
+
 static int ksz8795_reset_switch(struct ksz_device *dev)
 {
 	/* reset switch */
@@ -84,6 +227,15 @@ static int ksz8795_reset_switch(struct ksz_device *dev)
 	return 0;
 }
 
+static int ksz8863_reset_switch(struct ksz_device *dev)
+{
+	/* reset switch */
+	ksz_cfg(dev, KSZ8863_REG_SW_RESET,
+		KSZ8863_GLOBAL_SOFTWARE_RESET | KSZ8863_PCS_RESET, true);
+
+	return 0;
+}
+
 static void ksz8795_set_prio_queue(struct ksz_device *dev, int port, int queue)
 {
 	u8 hi, lo;
@@ -117,29 +269,31 @@ static void ksz8795_set_prio_queue(struct ksz_device *dev, int port, int queue)
 			true);
 }
 
-static void ksz8795_r_mib_cnt(struct ksz_device *dev, int port, u16 addr,
-			      u64 *cnt)
+static void ksz8_r_mib_cnt(struct ksz_device *dev, int port, u16 addr, u64 *cnt)
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
@@ -148,30 +302,64 @@ static void ksz8795_r_mib_cnt(struct ksz_device *dev, int port, u16 addr,
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
 static void ksz8795_r_mib_pkt(struct ksz_device *dev, int port, u16 addr,
 			      u64 *dropped, u64 *cnt)
 {
+	struct ksz8 *ksz8 = dev->priv;
+	struct ksz_regs *regs = ksz8->regs;
 	u16 ctrl_addr;
 	u32 data;
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
+		if (check & KSZ8795_MIB_COUNTER_VALID) {
+			ksz_read32(dev, regs->ind_data_lo, &data);
 			if (addr < 2) {
 				u64 total;
 
@@ -179,13 +367,13 @@ static void ksz8795_r_mib_pkt(struct ksz_device *dev, int port, u16 addr,
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
@@ -207,14 +395,17 @@ static void ksz8795_freeze_mib(struct ksz_device *dev, int port, bool freeze)
 		ksz_cfg(dev, REG_SW_CTRL_6, BIT(port), false);
 }
 
-static void ksz8795_port_init_cnt(struct ksz_device *dev, int port)
+static void ksz8_port_init_cnt(struct ksz_device *dev, int port)
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
 
@@ -225,69 +416,81 @@ static void ksz8795_port_init_cnt(struct ksz_device *dev, int port)
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
 	memset(mib->counters, 0, dev->mib_cnt * sizeof(u64));
 }
 
-static void ksz8795_r_table(struct ksz_device *dev, int table, u16 addr,
-			    u64 *data)
+static void ksz8_r_table(struct ksz_device *dev, int table, u16 addr, u64 *data)
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
 
-static void ksz8795_w_table(struct ksz_device *dev, int table, u16 addr,
-			    u64 data)
+static void ksz8_w_table(struct ksz_device *dev, int table, u16 addr, u64 data)
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
 
-static int ksz8795_valid_dyn_entry(struct ksz_device *dev, u8 *data)
+static int ksz8_valid_dyn_entry(struct ksz_device *dev, u8 *data)
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
 }
 
-static int ksz8795_r_dyn_mac_table(struct ksz_device *dev, u16 addr,
-				   u8 *mac_addr, u8 *fid, u8 *src_port,
-				   u8 *timestamp, u16 *entries)
+static int ksz8_r_dyn_mac_table(struct ksz_device *dev, u16 addr,
+				u8 *mac_addr, u8 *fid, u8 *src_port,
+				u8 *timestamp, u16 *entries)
 {
+	struct ksz8 *ksz8 = dev->priv;
+	struct ksz_regs *regs = ksz8->regs;
+	struct ksz_masks *masks = ksz8->masks;
+	struct ksz_shifts *shifts = ksz8->shifts;
 	u32 data_hi, data_lo;
 	u16 ctrl_addr;
 	u8 data;
@@ -296,9 +499,9 @@ static int ksz8795_r_dyn_mac_table(struct ksz_device *dev, u16 addr,
 	ctrl_addr = IND_ACC_TABLE(TABLE_DYNAMIC_MAC | TABLE_READ) | addr;
 
 	mutex_lock(&dev->alu_mutex);
-	ksz_write16(dev, REG_IND_CTRL_0, ctrl_addr);
+	ksz_write16(dev, regs->ind_ctrl_0, ctrl_addr);
 
-	rc = ksz8795_valid_dyn_entry(dev, &data);
+	rc = ksz8_valid_dyn_entry(dev, &data);
 	if (rc == -EAGAIN) {
 		if (addr == 0)
 			*entries = 0;
@@ -309,23 +512,23 @@ static int ksz8795_r_dyn_mac_table(struct ksz_device *dev, u16 addr,
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
@@ -341,38 +544,48 @@ static int ksz8795_r_dyn_mac_table(struct ksz_device *dev, u16 addr,
 	return rc;
 }
 
-static int ksz8795_r_sta_mac_table(struct ksz_device *dev, u16 addr,
-				   struct alu_struct *alu)
+static int ksz8_r_sta_mac_table(struct ksz_device *dev, u16 addr,
+				struct alu_struct *alu)
 {
+	struct ksz8 *ksz8 = dev->priv;
+	struct ksz_masks *masks = ksz8->masks;
+	struct ksz_shifts *shifts = ksz8->shifts;
 	u32 data_hi, data_lo;
 	u64 data;
 
-	ksz8795_r_table(dev, TABLE_STATIC_MAC, addr, &data);
+	ksz8_r_table(dev, TABLE_STATIC_MAC, addr, &data);
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
+		alu->is_static = true;
+		alu->is_use_fid =
+			(data_hi & masks->static_mac_table_use_fid) ? 1 : 0;
+		alu->fid = (data_hi & masks->static_mac_table_fid) >>
+				shifts->static_mac_fid;
 		return 0;
 	}
 	return -ENXIO;
 }
 
-static void ksz8795_w_sta_mac_table(struct ksz_device *dev, u16 addr,
-				    struct alu_struct *alu)
+static void ksz8_w_sta_mac_table(struct ksz_device *dev, u16 addr,
+				 struct alu_struct *alu)
 {
+	struct ksz8 *ksz8 = dev->priv;
+	struct ksz_masks *masks = ksz8->masks;
+	struct ksz_shifts *shifts = ksz8->shifts;
 	u32 data_hi, data_lo;
 	u64 data;
 
@@ -380,83 +593,106 @@ static void ksz8795_w_sta_mac_table(struct ksz_device *dev, u16 addr,
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
-	ksz8795_w_table(dev, TABLE_STATIC_MAC, addr, data);
+	ksz8_w_table(dev, TABLE_STATIC_MAC, addr, data);
 }
 
-static void ksz8795_from_vlan(u16 vlan, u8 *fid, u8 *member, u8 *valid)
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
 
-static void ksz8795_to_vlan(u8 fid, u8 member, u8 valid, u16 *vlan)
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
 
-static void ksz8795_r_vlan_entries(struct ksz_device *dev, u16 addr)
+static void ksz8_r_vlan_entries(struct ksz_device *dev, u16 addr)
 {
+	struct ksz8 *ksz8 = dev->priv;
+	struct ksz_shifts *shifts = ksz8->shifts;
 	u64 data;
 	int i;
 
-	ksz8795_r_table(dev, TABLE_VLAN, addr, &data);
-	addr *= 4;
-	for (i = 0; i < 4; i++) {
-		dev->vlan_cache[addr + i].table[0] = (u16)data;
-		data >>= VLAN_TABLE_S;
+	ksz8_r_table(dev, TABLE_VLAN, addr, &data);
+	addr *= dev->port_cnt;
+	for (i = 0; i < dev->port_cnt; i++) {
+		if (ksz_is_87(dev)) {
+			dev->vlan_cache[addr + i].table[0] = (u16)data;
+			data >>= shifts->vlan_table;
+		} else {
+			dev->vlan_cache[addr + i].table[0] = (u32)data;
+		}
 	}
 }
 
-static void ksz8795_r_vlan_table(struct ksz_device *dev, u16 vid, u16 *vlan)
+static void ksz8_r_vlan_table(struct ksz_device *dev, u16 vid, u32 *vlan)
 {
-	int index;
-	u16 *data;
-	u16 addr;
+	u16 addr = vid / dev->port_cnt;
 	u64 buf;
 
-	data = (u16 *)&buf;
-	addr = vid / 4;
-	index = vid & 3;
-	ksz8795_r_table(dev, TABLE_VLAN, addr, &buf);
-	*vlan = data[index];
+	ksz8_r_table(dev, TABLE_VLAN, addr, &buf);
+	if (ksz_is_87(dev)) {
+		u16 *data = (u16 *)&buf;
+
+		*vlan = data[vid & 3];
+	} else {
+		*vlan = (u32)buf;
+	}
 }
 
-static void ksz8795_w_vlan_table(struct ksz_device *dev, u16 vid, u16 vlan)
+static void ksz8_w_vlan_table(struct ksz_device *dev, u16 vid, u32 vlan)
 {
-	int index;
-	u16 *data;
-	u16 addr;
+	u16 addr = vid / dev->port_cnt;
 	u64 buf;
 
-	data = (u16 *)&buf;
-	addr = vid / 4;
-	index = vid & 3;
-	ksz8795_r_table(dev, TABLE_VLAN, addr, &buf);
-	data[index] = vlan;
+	ksz8_r_table(dev, TABLE_VLAN, addr, &buf);
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
-	ksz8795_w_table(dev, TABLE_VLAN, addr, buf);
+	ksz8_w_table(dev, TABLE_VLAN, addr, buf);
 }
 
-static void ksz8795_r_phy(struct ksz_device *dev, u16 phy, u16 reg, u16 *val)
+static void ksz8_r_phy(struct ksz_device *dev, u16 phy, u16 reg, u16 *val)
 {
+	struct ksz8 *ksz8 = dev->priv;
+	struct ksz_regs *regs = ksz8->regs;
 	u8 restart, speed, ctrl, link;
 	int processed = true;
 	u16 data = 0;
@@ -464,9 +700,9 @@ static void ksz8795_r_phy(struct ksz_device *dev, u16 phy, u16 reg, u16 *val)
 
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
@@ -491,7 +727,7 @@ static void ksz8795_r_phy(struct ksz_device *dev, u16 phy, u16 reg, u16 *val)
 			data |= PHY_LED_DISABLE;
 		break;
 	case PHY_REG_STATUS:
-		ksz_pread8(dev, p, P_LINK_STATUS, &link);
+		ksz_pread8(dev, p, regs->p_link_status, &link);
 		data = PHY_100BTX_FD_CAPABLE |
 		       PHY_100BTX_CAPABLE |
 		       PHY_10BT_FD_CAPABLE |
@@ -503,13 +739,19 @@ static void ksz8795_r_phy(struct ksz_device *dev, u16 phy, u16 reg, u16 *val)
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
-		ksz_pread8(dev, p, P_LOCAL_CTRL, &ctrl);
+		ksz_pread8(dev, p, regs->p_local_ctrl, &ctrl);
 		data = PHY_AUTO_NEG_802_3;
 		if (ctrl & PORT_AUTO_NEG_SYM_PAUSE)
 			data |= PHY_AUTO_NEG_SYM_PAUSE;
@@ -523,7 +765,7 @@ static void ksz8795_r_phy(struct ksz_device *dev, u16 phy, u16 reg, u16 *val)
 			data |= PHY_AUTO_NEG_10BT;
 		break;
 	case PHY_REG_REMOTE_CAPABILITY:
-		ksz_pread8(dev, p, P_REMOTE_STATUS, &link);
+		ksz_pread8(dev, p, regs->p_remote_status, &link);
 		data = PHY_AUTO_NEG_802_3;
 		if (link & PORT_REMOTE_SYM_PAUSE)
 			data |= PHY_AUTO_NEG_SYM_PAUSE;
@@ -546,10 +788,12 @@ static void ksz8795_r_phy(struct ksz_device *dev, u16 phy, u16 reg, u16 *val)
 		*val = data;
 }
 
-static void ksz8795_w_phy(struct ksz_device *dev, u16 phy, u16 reg, u16 val)
+static void ksz8_w_phy(struct ksz_device *dev, u16 phy, u16 reg, u16 val)
 {
-	u8 p = phy;
+	struct ksz8 *ksz8 = dev->priv;
+	struct ksz_regs *regs = ksz8->regs;
 	u8 restart, speed, ctrl, data;
+	u8 p = phy;
 
 	switch (reg) {
 	case PHY_REG_CTRL:
@@ -557,15 +801,15 @@ static void ksz8795_w_phy(struct ksz_device *dev, u16 phy, u16 reg, u16 val)
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
@@ -584,8 +828,8 @@ static void ksz8795_w_phy(struct ksz_device *dev, u16 phy, u16 reg, u16 val)
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
@@ -616,10 +860,10 @@ static void ksz8795_w_phy(struct ksz_device *dev, u16 phy, u16 reg, u16 val)
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
@@ -637,44 +881,49 @@ static void ksz8795_w_phy(struct ksz_device *dev, u16 phy, u16 reg, u16 val)
 		if (val & PHY_AUTO_NEG_10BT)
 			data |= PORT_AUTO_NEG_10BT;
 		if (data != ctrl)
-			ksz_pwrite8(dev, p, P_LOCAL_CTRL, data);
+			ksz_pwrite8(dev, p, regs->p_local_ctrl, data);
 		break;
 	default:
 		break;
 	}
 }
 
-static enum dsa_tag_protocol ksz8795_get_tag_protocol(struct dsa_switch *ds,
-						      int port)
+static enum dsa_tag_protocol ksz8_get_tag_protocol(struct dsa_switch *ds,
+						   int port)
 {
-	return DSA_TAG_PROTO_KSZ8795;
+	struct ksz_device *dev = ds->priv;
+
+	return ksz_is_87(dev) ?
+		DSA_TAG_PROTO_KSZ8795 : DSA_TAG_PROTO_KSZ8863;
 }
 
-static void ksz8795_get_strings(struct dsa_switch *ds, int port,
-				u32 stringset, uint8_t *buf)
+static void ksz8_get_strings(struct dsa_switch *ds, int port,
+			     u32 stringset, uint8_t *buf)
 {
-	int i;
+	struct ksz_device *dev = ds->priv;
 
-	for (i = 0; i < TOTAL_SWITCH_COUNTER_NUM; i++) {
-		memcpy(buf + i * ETH_GSTRING_LEN, mib_names[i].string,
-		       ETH_GSTRING_LEN);
-	}
+	if (ksz_is_87(dev))
+		memcpy(buf, ksz87xx_mib_names, sizeof(ksz87xx_mib_names));
+	else
+		memcpy(buf, ksz88xx_mib_names, sizeof(ksz88xx_mib_names));
 }
 
-static void ksz8795_cfg_port_member(struct ksz_device *dev, int port,
-				    u8 member)
+static void ksz8_cfg_port_member(struct ksz_device *dev, int port, u8 member)
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
 }
 
-static void ksz8795_port_stp_state_set(struct dsa_switch *ds, int port,
-				       u8 state)
+static void ksz8_port_stp_state_set(struct dsa_switch *ds, int port, u8 state)
 {
 	struct ksz_device *dev = ds->priv;
 	int forward = dev->member;
@@ -690,12 +939,12 @@ static void ksz8795_port_stp_state_set(struct dsa_switch *ds, int port,
 	switch (state) {
 	case BR_STATE_DISABLED:
 		data |= PORT_LEARN_DISABLE;
-		if (port < SWITCH_PORT_NUM)
+		if (port < dev->port_cnt)
 			member = 0;
 		break;
 	case BR_STATE_LISTENING:
 		data |= (PORT_RX_ENABLE | PORT_LEARN_DISABLE);
-		if (port < SWITCH_PORT_NUM &&
+		if (port < dev->port_cnt &&
 		    p->stp_state == BR_STATE_DISABLED)
 			member = dev->host_mask | p->vid_member;
 		break;
@@ -719,7 +968,7 @@ static void ksz8795_port_stp_state_set(struct dsa_switch *ds, int port,
 		break;
 	case BR_STATE_BLOCKING:
 		data |= PORT_LEARN_DISABLE;
-		if (port < SWITCH_PORT_NUM &&
+		if (port < dev->port_cnt &&
 		    p->stp_state == BR_STATE_DISABLED)
 			member = dev->host_mask | p->vid_member;
 		break;
@@ -741,7 +990,7 @@ static void ksz8795_port_stp_state_set(struct dsa_switch *ds, int port,
 
 	/* Port membership may share register with STP state. */
 	if (member >= 0 && member != p->member)
-		ksz8795_cfg_port_member(dev, port, (u8)member);
+		ksz8_cfg_port_member(dev, port, (u8)member);
 
 	/* Check if forwarding needs to be updated. */
 	if (state != BR_STATE_FORWARDING) {
@@ -756,13 +1005,13 @@ static void ksz8795_port_stp_state_set(struct dsa_switch *ds, int port,
 		ksz_update_port_member(dev, port);
 }
 
-static void ksz8795_flush_dyn_mac_table(struct ksz_device *dev, int port)
+static void ksz8_flush_dyn_mac_table(struct ksz_device *dev, int port)
 {
-	u8 learn[TOTAL_PORT_NUM];
+	u8 *learn = kzalloc(dev->mib_port_cnt, GFP_KERNEL);
 	int first, index, cnt;
 	struct ksz_port *p;
 
-	if ((uint)port < TOTAL_PORT_NUM) {
+	if ((uint)port < dev->mib_port_cnt) {
 		first = port;
 		cnt = port + 1;
 	} else {
@@ -785,12 +1034,13 @@ static void ksz8795_flush_dyn_mac_table(struct ksz_device *dev, int port)
 		if (!p->on)
 			continue;
 		if (!(learn[index] & PORT_LEARN_DISABLE))
-			ksz_pwrite8(dev, index, P_STP_CTRL, learn[index]);
+			ksz_pwrite8(dev, index, P_STP_CTRL,
+				    learn[index]);
 	}
+	kfree(learn);
 }
 
-static int ksz8795_port_vlan_filtering(struct dsa_switch *ds, int port,
-				       bool flag)
+static int ksz8_port_vlan_filtering(struct dsa_switch *ds, int port, bool flag)
 {
 	struct ksz_device *dev = ds->priv;
 
@@ -799,12 +1049,13 @@ static int ksz8795_port_vlan_filtering(struct dsa_switch *ds, int port,
 	return 0;
 }
 
-static void ksz8795_port_vlan_add(struct dsa_switch *ds, int port,
-				  const struct switchdev_obj_port_vlan *vlan)
+static void ksz8_port_vlan_add(struct dsa_switch *ds, int port,
+			       const struct switchdev_obj_port_vlan *vlan)
 {
 	bool untagged = vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
 	struct ksz_device *dev = ds->priv;
-	u16 data, vid, new_pvid = 0;
+	u16 vid, new_pvid = 0;
+	u32 data = 0;
 	u8 fid, member, valid;
 
 	mutex_lock(&dev->vlan_mutex);
@@ -812,8 +1063,8 @@ static void ksz8795_port_vlan_add(struct dsa_switch *ds, int port,
 	ksz_port_cfg(dev, port, P_TAG_CTRL, PORT_REMOVE_TAG, untagged);
 
 	for (vid = vlan->vid_begin; vid <= vlan->vid_end; vid++) {
-		ksz8795_r_vlan_table(dev, vid, &data);
-		ksz8795_from_vlan(data, &fid, &member, &valid);
+		ksz8_r_vlan_table(dev, vid, &data);
+		ksz8_from_vlan(dev, data, &fid, &member, &valid);
 
 		/* First time to setup the VLAN entry. */
 		if (!valid) {
@@ -823,9 +1074,8 @@ static void ksz8795_port_vlan_add(struct dsa_switch *ds, int port,
 		}
 		member |= BIT(port);
 
-		ksz8795_to_vlan(fid, member, valid, &data);
-		ksz8795_w_vlan_table(dev, vid, data);
-
+		ksz8_to_vlan(dev, fid, member, valid, &data);
+		ksz8_w_vlan_table(dev, vid, data);
 		/* change PVID */
 		if (vlan->flags & BRIDGE_VLAN_INFO_PVID)
 			new_pvid = vid;
@@ -841,12 +1091,13 @@ static void ksz8795_port_vlan_add(struct dsa_switch *ds, int port,
 	mutex_unlock(&dev->vlan_mutex);
 }
 
-static int ksz8795_port_vlan_del(struct dsa_switch *ds, int port,
-				 const struct switchdev_obj_port_vlan *vlan)
+static int ksz8_port_vlan_del(struct dsa_switch *ds, int port,
+			      const struct switchdev_obj_port_vlan *vlan)
 {
 	bool untagged = vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
 	struct ksz_device *dev = ds->priv;
-	u16 data, vid, pvid, new_pvid = 0;
+	u32 data = 0;
+	u16 vid, pvid, new_pvid = 0;
 	u8 fid, member, valid;
 
 	mutex_lock(&dev->vlan_mutex);
@@ -857,8 +1108,8 @@ static int ksz8795_port_vlan_del(struct dsa_switch *ds, int port,
 	ksz_port_cfg(dev, port, P_TAG_CTRL, PORT_REMOVE_TAG, untagged);
 
 	for (vid = vlan->vid_begin; vid <= vlan->vid_end; vid++) {
-		ksz8795_r_vlan_table(dev, vid, &data);
-		ksz8795_from_vlan(data, &fid, &member, &valid);
+		ksz8_r_vlan_table(dev, vid, &data);
+		ksz8_from_vlan(dev, data, &fid, &member, &valid);
 
 		member &= ~BIT(port);
 
@@ -871,8 +1122,8 @@ static int ksz8795_port_vlan_del(struct dsa_switch *ds, int port,
 		if (pvid == vid)
 			new_pvid = 1;
 
-		ksz8795_to_vlan(fid, member, valid, &data);
-		ksz8795_w_vlan_table(dev, vid, data);
+		ksz8_to_vlan(dev, fid, member, valid, &data);
+		ksz8_w_vlan_table(dev, vid, data);
 	}
 
 	if (new_pvid != pvid)
@@ -883,9 +1134,9 @@ static int ksz8795_port_vlan_del(struct dsa_switch *ds, int port,
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
 
@@ -907,8 +1158,8 @@ static int ksz8795_port_mirror_add(struct dsa_switch *ds, int port,
 	return 0;
 }
 
-static void ksz8795_port_mirror_del(struct dsa_switch *ds, int port,
-				    struct dsa_mall_mirror_tc_entry *mirror)
+static void ksz8_port_mirror_del(struct dsa_switch *ds, int port,
+				 struct dsa_mall_mirror_tc_entry *mirror)
 {
 	struct ksz_device *dev = ds->priv;
 	u8 data;
@@ -928,59 +1179,71 @@ static void ksz8795_port_mirror_del(struct dsa_switch *ds, int port,
 			     PORT_MIRROR_SNIFFER, false);
 }
 
-static void ksz8795_port_setup(struct ksz_device *dev, int port, bool cpu_port)
+static void ksz8795_cpu_interface_select(struct ksz_device *dev, int port)
 {
 	struct ksz_port *p = &dev->ports[port];
-	u8 data8, member;
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
 
+static void ksz8_port_setup(struct ksz_device *dev, int port, bool cpu_port)
+{
+	struct ksz_port *p = &dev->ports[port];
+	struct ksz8 *ksz8 = dev->priv;
+	struct ksz_masks *masks = ksz8->masks;
+	u8 member;
 	/* enable broadcast storm limit */
 	ksz_port_cfg(dev, port, P_BCAST_STORM_CTRL, PORT_BROADCAST_STORM, true);
 
-	ksz8795_set_prio_queue(dev, port, 4);
+	if (ksz_is_87(dev))
+		ksz8795_set_prio_queue(dev, port, 4);
 
 	/* disable DiffServ priority */
 	ksz_port_cfg(dev, port, P_PRIO_CTRL, PORT_DIFFSERV_ENABLE, false);
 
 	/* replace priority */
-	ksz_port_cfg(dev, port, P_802_1P_CTRL, PORT_802_1P_REMAPPING, false);
+	ksz_port_cfg(dev, port, P_802_1P_CTRL,
+		     masks->port_802_1p_remapping, false);
 
 	/* enable 802.1p priority */
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
 		dev->on_ports = dev->host_mask;
@@ -993,12 +1256,15 @@ static void ksz8795_port_setup(struct ksz_device *dev, int port, bool cpu_port)
 		if (p->phydev.link)
 			dev->live_ports |= BIT(port);
 	}
-	ksz8795_cfg_port_member(dev, port, member);
+	ksz8_cfg_port_member(dev, port, member);
 }
 
-static void ksz8795_config_cpu_port(struct dsa_switch *ds)
+static void ksz8_config_cpu_port(struct dsa_switch *ds)
 {
 	struct ksz_device *dev = ds->priv;
+	struct ksz8 *ksz8 = dev->priv;
+	struct ksz_regs *regs = ksz8->regs;
+	struct ksz_masks *masks = ksz8->masks;
 	struct ksz_port *p;
 	u8 remote;
 	int i;
@@ -1007,16 +1273,16 @@ static void ksz8795_config_cpu_port(struct dsa_switch *ds)
 
 	/* Switch marks the maximum frame with extra byte as oversize. */
 	ksz_cfg(dev, REG_SW_CTRL_2, SW_LEGAL_PACKET_DISABLE, true);
-	ksz_cfg(dev, S_TAIL_TAG_CTRL, SW_TAIL_TAG_ENABLE, true);
+	ksz_cfg(dev, regs->s_tail_tag_ctrl, masks->sw_tail_tag_enable, true);
 
 	p = &dev->ports[dev->cpu_port];
 	p->vid_member = dev->port_mask;
 	p->on = 1;
 
-	ksz8795_port_setup(dev, dev->cpu_port, true);
+	ksz8_port_setup(dev, dev->cpu_port, true);
 	dev->member = dev->host_mask;
 
-	for (i = 0; i < SWITCH_PORT_NUM; i++) {
+	for (i = 0; i < dev->port_cnt; i++) {
 		p = &dev->ports[i];
 
 		/* Initialize to non-zero so that ksz_cfg_port_member() will
@@ -1024,7 +1290,7 @@ static void ksz8795_config_cpu_port(struct dsa_switch *ds)
 		 */
 		p->vid_member = BIT(i);
 		p->member = dev->port_mask;
-		ksz8795_port_stp_state_set(ds, i, BR_STATE_DISABLED);
+		ksz8_port_stp_state_set(ds, i, BR_STATE_DISABLED);
 
 		/* Last port may be disabled. */
 		if (i == dev->port_cnt)
@@ -1036,9 +1302,11 @@ static void ksz8795_config_cpu_port(struct dsa_switch *ds)
 		p = &dev->ports[i];
 		if (!p->on)
 			continue;
-		ksz_pread8(dev, i, P_REMOTE_STATUS, &remote);
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
@@ -1048,7 +1316,7 @@ static void ksz8795_config_cpu_port(struct dsa_switch *ds)
 	}
 }
 
-static int ksz8795_setup(struct dsa_switch *ds)
+static int ksz8_setup(struct dsa_switch *ds)
 {
 	struct ksz_device *dev = ds->priv;
 	struct alu_struct alu;
@@ -1059,7 +1327,7 @@ static int ksz8795_setup(struct dsa_switch *ds)
 	if (!dev->vlan_cache)
 		return -ENOMEM;
 
-	ret = ksz8795_reset_switch(dev);
+	dev->dev_ops->shutdown(dev);
 	if (ret) {
 		dev_err(ds->dev, "failed to reset switch\n");
 		return ret;
@@ -1082,7 +1350,7 @@ static int ksz8795_setup(struct dsa_switch *ds)
 			   UNICAST_VLAN_BOUNDARY | NO_EXC_COLLISION_DROP,
 			   UNICAST_VLAN_BOUNDARY | NO_EXC_COLLISION_DROP);
 
-	ksz8795_config_cpu_port(ds);
+	ksz8_config_cpu_port(ds);
 
 	ksz_cfg(dev, REG_SW_CTRL_2, MULTICAST_STORM_DISABLE, true);
 
@@ -1096,8 +1364,8 @@ static int ksz8795_setup(struct dsa_switch *ds)
 			   (BROADCAST_STORM_VALUE *
 			   BROADCAST_STORM_PROT_RATE) / 100);
 
-	for (i = 0; i < VLAN_TABLE_ENTRIES; i++)
-		ksz8795_r_vlan_entries(dev, i);
+	for (i = 0; i < (dev->num_vlans / 2); i++)
+		ksz8_r_vlan_entries(dev, i);
 
 	/* Setup STP address for STP operation. */
 	memset(&alu, 0, sizeof(alu));
@@ -1106,46 +1374,46 @@ static int ksz8795_setup(struct dsa_switch *ds)
 	alu.is_override = true;
 	alu.port_forward = dev->host_mask;
 
-	ksz8795_w_sta_mac_table(dev, 0, &alu);
+	ksz8_w_sta_mac_table(dev, 0, &alu);
 
 	ksz_init_mib_timer(dev);
 
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
 	.adjust_link		= ksz_adjust_link,
 	.port_enable		= ksz_enable_port,
 	.port_disable		= ksz_disable_port,
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
+	.port_vlan_filtering	= ksz8_port_vlan_filtering,
 	.port_vlan_prepare	= ksz_port_vlan_prepare,
-	.port_vlan_add		= ksz8795_port_vlan_add,
-	.port_vlan_del		= ksz8795_port_vlan_del,
+	.port_vlan_add		= ksz8_port_vlan_add,
+	.port_vlan_del		= ksz8_port_vlan_del,
 	.port_fdb_dump		= ksz_port_fdb_dump,
 	.port_mdb_prepare       = ksz_port_mdb_prepare,
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
@@ -1158,26 +1426,41 @@ static int ksz8795_switch_detect(struct ksz_device *dev)
 
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
+
 	id16 &= ~0xff;
 	id16 |= id2;
 	dev->chip_id = id16;
@@ -1196,6 +1479,7 @@ struct ksz_chip_data {
 	int num_statics;
 	int cpu_ports;
 	int port_cnt;
+	int mib_cnt;
 };
 
 static const struct ksz_chip_data ksz8795_switch_chips[] = {
@@ -1226,13 +1510,23 @@ static const struct ksz_chip_data ksz8795_switch_chips[] = {
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
 
-static int ksz8795_switch_init(struct ksz_device *dev)
+static int ksz8_switch_init(struct ksz_device *dev)
 {
 	int i;
+	struct ksz8 *ksz8 = dev->priv;
 
-	dev->ds->ops = &ksz8795_switch_ops;
+	dev->ds->ops = &ksz8_switch_ops;
 
 	for (i = 0; i < ARRAY_SIZE(ksz8795_switch_chips); i++) {
 		const struct ksz_chip_data *chip = &ksz8795_switch_chips[i];
@@ -1253,11 +1547,22 @@ static int ksz8795_switch_init(struct ksz_device *dev)
 	if (!dev->cpu_ports)
 		return -ENODEV;
 
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
+
 	dev->port_mask = BIT(dev->port_cnt) - 1;
 	dev->port_mask |= dev->host_mask;
 
 	dev->reg_mib_cnt = SWITCH_COUNTER_NUM;
-	dev->mib_cnt = TOTAL_SWITCH_COUNTER_NUM;
 
 	i = dev->mib_port_cnt;
 	dev->ports = devm_kzalloc(dev->dev, sizeof(struct ksz_port) * i,
@@ -1269,8 +1574,9 @@ static int ksz8795_switch_init(struct ksz_device *dev)
 		dev->ports[i].mib.counters =
 			devm_kzalloc(dev->dev,
 				     sizeof(u64) *
-				     (TOTAL_SWITCH_COUNTER_NUM + 1),
+				     (dev->mib_cnt + 1),
 				     GFP_KERNEL);
+
 		if (!dev->ports[i].mib.counters)
 			return -ENOMEM;
 	}
@@ -1278,29 +1584,48 @@ static int ksz8795_switch_init(struct ksz_device *dev)
 	return 0;
 }
 
-static void ksz8795_switch_exit(struct ksz_device *dev)
+static void ksz8_switch_exit(struct ksz_device *dev)
 {
-	ksz8795_reset_switch(dev);
-}
+	dev->dev_ops->shutdown(dev);
+};
 
 static const struct ksz_dev_ops ksz8795_dev_ops = {
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
 	.r_mib_pkt = ksz8795_r_mib_pkt,
 	.freeze_mib = ksz8795_freeze_mib,
-	.port_init_cnt = ksz8795_port_init_cnt,
+	.port_init_cnt = ksz8_port_init_cnt,
 	.shutdown = ksz8795_reset_switch,
-	.detect = ksz8795_switch_detect,
-	.init = ksz8795_switch_init,
-	.exit = ksz8795_switch_exit,
+	.detect = ksz8_switch_detect,
+	.init = ksz8_switch_init,
+	.exit = ksz8_switch_exit,
+};
+
+static const struct ksz_dev_ops ksz8863_dev_ops = {
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
+	.r_mib_pkt = ksz8863_r_mib_pkt,
+	.port_init_cnt = ksz8_port_init_cnt,
+	.shutdown = ksz8863_reset_switch,
+	.detect = ksz8_switch_detect,
+	.init = ksz8_switch_init,
+	.exit = ksz8_switch_exit,
 };
 
 int ksz8795_switch_register(struct ksz_device *dev)
@@ -1309,6 +1634,12 @@ int ksz8795_switch_register(struct ksz_device *dev)
 }
 EXPORT_SYMBOL(ksz8795_switch_register);
 
+int ksz8863_switch_register(struct ksz_device *dev)
+{
+	return ksz_switch_register(dev, &ksz8863_dev_ops);
+}
+EXPORT_SYMBOL(ksz8863_switch_register);
+
 MODULE_AUTHOR("Tristram Ha <Tristram.Ha@microchip.com>");
 MODULE_DESCRIPTION("Microchip KSZ8795 Series Switch DSA Driver");
 MODULE_LICENSE("GPL");
diff --git a/drivers/net/dsa/microchip/ksz8795_reg.h b/drivers/net/dsa/microchip/ksz8795_reg.h
index 3a50462df8fa9..3650b55cbe57b 100644
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
@@ -320,30 +320,36 @@
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
@@ -356,7 +362,7 @@
 #define REG_SW_MAC_ADDR_4		0x6C
 #define REG_SW_MAC_ADDR_5		0x6D
 
-#define REG_IND_CTRL_0			0x6E
+#define KSZ8795_REG_IND_CTRL_0			0x6E
 
 #define TABLE_EXT_SELECT_S		5
 #define TABLE_EEE_V			1
@@ -378,27 +384,27 @@
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
@@ -846,16 +852,15 @@
 
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
 
@@ -865,16 +870,16 @@
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
@@ -885,7 +890,7 @@
 #define S_MIRROR_CTRL			REG_SW_CTRL_3
 #define S_REPLACE_VID_CTRL		REG_SW_CTRL_4
 #define S_PASS_PAUSE_CTRL		REG_SW_CTRL_10
-#define S_TAIL_TAG_CTRL			REG_SW_CTRL_10
+#define KSZ8795_S_TAIL_TAG_CTRL			REG_SW_CTRL_10
 #define S_802_1P_PRIO_CTRL		REG_SW_CTRL_12
 #define S_TOS_PRIO_CTRL			REG_TOS_PRIO_CTRL_0
 #define S_IPV6_MLD_CTRL			REG_SW_CTRL_21
@@ -907,15 +912,15 @@
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
@@ -923,12 +928,12 @@
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
@@ -940,22 +945,22 @@
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
@@ -965,31 +970,31 @@
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
 
diff --git a/drivers/net/dsa/microchip/ksz8795_spi.c b/drivers/net/dsa/microchip/ksz8795_spi.c
index 8b00f8e6c02f4..4d0864507c3f4 100644
--- a/drivers/net/dsa/microchip/ksz8795_spi.c
+++ b/drivers/net/dsa/microchip/ksz8795_spi.c
@@ -14,6 +14,7 @@
 #include <linux/regmap.h>
 #include <linux/spi/spi.h>
 
+#include "ksz8.h"
 #include "ksz_common.h"
 
 #define SPI_ADDR_SHIFT			12
@@ -25,11 +26,15 @@ KSZ_REGMAP_TABLE(ksz8795, 16, SPI_ADDR_SHIFT,
 
 static int ksz8795_spi_probe(struct spi_device *spi)
 {
+	struct ksz8 *ksz8;
 	struct regmap_config rc;
 	struct ksz_device *dev;
 	int i, ret;
 
-	dev = ksz_switch_alloc(&spi->dev, spi);
+	ksz8 = devm_kzalloc(&spi->dev, sizeof(struct ksz8), GFP_KERNEL);
+	ksz8->priv = spi;
+
+	dev = ksz_switch_alloc(&spi->dev, ksz8);
 	if (!dev)
 		return -ENOMEM;
 
diff --git a/drivers/net/dsa/microchip/ksz8863_reg.h b/drivers/net/dsa/microchip/ksz8863_reg.h
new file mode 100644
index 0000000000000..d351e90504981
--- /dev/null
+++ b/drivers/net/dsa/microchip/ksz8863_reg.h
@@ -0,0 +1,121 @@
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
+#define KSZ8863_P_LOCAL_CTRL			REG_PORT_CTRL_5
+#define KSZ8863_P_REMOTE_STATUS			KSZ8863_REG_PORT_STATUS_1
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
+#endif
diff --git a/drivers/net/dsa/microchip/ksz8863_smi.c b/drivers/net/dsa/microchip/ksz8863_smi.c
new file mode 100644
index 0000000000000..1387797be85da
--- /dev/null
+++ b/drivers/net/dsa/microchip/ksz8863_smi.c
@@ -0,0 +1,183 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Microchip KSZ8863 series register access through SMI
+ *
+ * Copyright (C) 2019 Pengutronix, Michael Grzeschik <kernel@pengutronix.de>
+ */
+
+#include "ksz8.h"
+#include "ksz_common.h"
+
+#define SMI_KSZ8863_RW_OPCODE	0
+#define SMI_KSZ8863_WRITE_PHY	(0 << 4)
+#define SMI_KSZ8863_READ_PHY	(1 << 4)
+
+static int ksz8863_mdio_read(void *ctx, const void *reg_buf, size_t reg_len,
+			     void *val_buf, size_t val_len)
+{
+	struct ksz_device *dev = (struct ksz_device *)ctx;
+	struct ksz8 *ksz8 = dev->priv;
+	struct mdio_device *mdev = ksz8->priv;
+	u8 reg = *(u8 *)reg_buf;
+	u8 *val = val_buf;
+	int ret;
+	int i;
+
+	for (i = 0; i < val_len; i++) {
+		int tmp = reg + i;
+
+		ret = mdiobus_ll_read(mdev->bus, SMI_KSZ8863_RW_OPCODE,
+				      ((tmp & 0xE0) >> 5) |
+				      SMI_KSZ8863_READ_PHY, tmp);
+		if (ret < 0)
+			return ret;
+
+		val[i] = ret;
+	}
+
+	return 0;
+}
+
+static int ksz8863_mdio_write(void *ctx, const void *data, size_t count)
+{
+	struct ksz_device *dev = (struct ksz_device *)ctx;
+	struct ksz8 *ksz8 = dev->priv;
+	struct mdio_device *mdev = ksz8->priv;
+	u8 *val = (u8 *)(data + 4);
+	u32 reg = *(u32 *)data;
+	int ret;
+	int i;
+
+	for (i = 0; i < (count - 4); i++) {
+		int tmp = reg + i;
+
+		ret = mdiobus_ll_write(mdev->bus, SMI_KSZ8863_RW_OPCODE,
+				       ((tmp & 0xE0) >> 5) |
+				       SMI_KSZ8863_WRITE_PHY, tmp, val[i]);
+		if (ret < 0)
+			return ret;
+	}
+
+	return 0;
+}
+
+static const struct regmap_bus regmap_smi[] = {
+	{
+		.read = ksz8863_mdio_read,
+		.write = ksz8863_mdio_write,
+		.max_raw_read = 1,
+		.max_raw_write = 1,
+	},
+	{
+		.read = ksz8863_mdio_read,
+		.write = ksz8863_mdio_write,
+		.val_format_endian_default = REGMAP_ENDIAN_BIG,
+		.max_raw_read = 2,
+		.max_raw_write = 2,
+	},
+	{
+		.read = ksz8863_mdio_read,
+		.write = ksz8863_mdio_write,
+		.val_format_endian_default = REGMAP_ENDIAN_BIG,
+		.max_raw_read = 4,
+		.max_raw_write = 4,
+	}
+};
+
+static const struct regmap_config ksz8863_regmap_config[] = {
+	{
+		.name = "#8",
+		.reg_bits = 8,
+		.pad_bits = 24,
+		.val_bits = 8,
+		.cache_type = REGCACHE_NONE,
+		.use_single_read = 1,
+	},
+	{
+		.name = "#16",
+		.reg_bits = 8,
+		.pad_bits = 24,
+		.val_bits = 16,
+		.cache_type = REGCACHE_NONE,
+		.use_single_read = 1,
+	},
+	{
+		.name = "#32",
+		.reg_bits = 8,
+		.pad_bits = 24,
+		.val_bits = 32,
+		.cache_type = REGCACHE_NONE,
+		.use_single_read = 1,
+	}
+};
+
+static int ksz8863_smi_probe(struct mdio_device *mdiodev)
+{
+	struct ksz8 *ksz8;
+	struct ksz_device *dev;
+	int ret;
+	int i;
+
+	ksz8 = devm_kzalloc(&mdiodev->dev, sizeof(struct ksz8), GFP_KERNEL);
+	ksz8->priv = mdiodev;
+
+	dev = ksz_switch_alloc(&mdiodev->dev, ksz8);
+	if (!dev)
+		return -EINVAL;
+
+	for (i = 0; i < ARRAY_SIZE(ksz8863_regmap_config); i++) {
+		dev->regmap[i] = devm_regmap_init(&mdiodev->dev,
+						  &regmap_smi[i], dev,
+						  &ksz8863_regmap_config[i]);
+		if (IS_ERR(dev->regmap[i])) {
+			ret = PTR_ERR(dev->regmap[i]);
+			dev_err(&mdiodev->dev,
+				"Failed to initialize regmap%i: %d\n",
+				ksz8863_regmap_config[i].val_bits, ret);
+			return ret;
+		}
+	}
+
+	if (mdiodev->dev.platform_data)
+		dev->pdata = mdiodev->dev.platform_data;
+
+	ret = ksz8863_switch_register(dev);
+
+	/* Main DSA driver may not be started yet. */
+	if (ret)
+		return ret;
+
+	dev_set_drvdata(&mdiodev->dev, dev);
+
+	return 0;
+}
+
+static void ksz8863_smi_remove(struct mdio_device *mdiodev)
+{
+	struct ksz_device *dev = dev_get_drvdata(&mdiodev->dev);
+
+	if (dev)
+		ksz_switch_remove(dev);
+}
+
+static const struct of_device_id ksz8863_dt_ids[] = {
+	{ .compatible = "microchip,ksz8863" },
+	{ .compatible = "microchip,ksz8873" },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, ksz8863_dt_ids);
+
+static struct mdio_driver ksz8863_driver = {
+	.probe	= ksz8863_smi_probe,
+	.remove	= ksz8863_smi_remove,
+	.mdiodrv.driver = {
+		.name	= "ksz8863-switch",
+		.of_match_table = ksz8863_dt_ids,
+	},
+};
+
+mdio_module_driver(ksz8863_driver);
+
+MODULE_AUTHOR("Michael Grzeschik <m.grzeschik@pengutronix.de>");
+MODULE_DESCRIPTION("Microchip KSZ8863 SMI Switch driver");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index d8fef523f64b0..b6bc74539f81b 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -153,6 +153,7 @@ int ksz_switch_register(struct ksz_device *dev,
 void ksz_switch_remove(struct ksz_device *dev);
 
 int ksz8795_switch_register(struct ksz_device *dev);
+int ksz8863_switch_register(struct ksz_device *dev);
 int ksz9477_switch_register(struct ksz_device *dev);
 
 void ksz_update_port_member(struct ksz_device *dev, int port);
-- 
2.24.0

