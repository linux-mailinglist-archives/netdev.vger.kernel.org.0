Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C4EBF2CEE
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 12:00:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388129AbfKGLA4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 06:00:56 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:59951 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387629AbfKGLAx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 06:00:53 -0500
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mgr@pengutronix.de>)
        id 1iSfX1-0004bV-25; Thu, 07 Nov 2019 12:00:51 +0100
Received: from mgr by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <mgr@pengutronix.de>)
        id 1iSfX0-0003fC-50; Thu, 07 Nov 2019 12:00:50 +0100
From:   Michael Grzeschik <m.grzeschik@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     Tristram.Ha@microchip.com, UNGLinuxDriver@microchip.com,
        kernel@pengutronix.de
Subject: [PATCH v1 3/4] ksz: Add Microchip KSZ8863 SMI-DSA driver
Date:   Thu,  7 Nov 2019 12:00:29 +0100
Message-Id: <20191107110030.25199-4-m.grzeschik@pengutronix.de>
X-Mailer: git-send-email 2.24.0.rc1
In-Reply-To: <20191107110030.25199-1-m.grzeschik@pengutronix.de>
References: <20191107110030.25199-1-m.grzeschik@pengutronix.de>
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

Add KSZ88X3 driver support. The code ksz8863.c and ksz8863_smi.c add
support for the three port switches ksz8863 and ksz8873 using the
Microchip SMI Interface. They are currently only supported using the
MDIO-Bitbang Interface.

Cc: Tristram.Ha@microchip.com
Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
---
RFC -> v1: - added Microchip SMI to description
	   - added select MDIO_BITBANG
	   - added return error code handling in mdiobus_read/write
	   - fixed the stp state handling
	   - moved tag handling code to seperate patch

 drivers/net/dsa/microchip/Kconfig       |   16 +
 drivers/net/dsa/microchip/Makefile      |    2 +
 drivers/net/dsa/microchip/ksz8863.c     | 1038 +++++++++++++++++++++++
 drivers/net/dsa/microchip/ksz8863_reg.h |  605 +++++++++++++
 drivers/net/dsa/microchip/ksz8863_smi.c |  166 ++++
 drivers/net/dsa/microchip/ksz_common.h  |    1 +
 6 files changed, 1828 insertions(+)
 create mode 100644 drivers/net/dsa/microchip/ksz8863.c
 create mode 100644 drivers/net/dsa/microchip/ksz8863_reg.h
 create mode 100644 drivers/net/dsa/microchip/ksz8863_smi.c

diff --git a/drivers/net/dsa/microchip/Kconfig b/drivers/net/dsa/microchip/Kconfig
index 1d7870c6df3ce..5bd5d4a8d875e 100644
--- a/drivers/net/dsa/microchip/Kconfig
+++ b/drivers/net/dsa/microchip/Kconfig
@@ -39,3 +39,19 @@ config NET_DSA_MICROCHIP_KSZ8795_SPI
 
 	  It is required to use the KSZ8795 switch driver as the only access
 	  is through SPI.
+
+menuconfig NET_DSA_MICROCHIP_KSZ8863
+	tristate "Microchip KSZ8863 series switch support"
+	depends on NET_DSA
+	select NET_DSA_MICROCHIP_KSZ_COMMON
+	help
+	  This driver adds support for Microchip KSZ8863 switch chips.
+
+config NET_DSA_MICROCHIP_KSZ8863_SMI
+	tristate "KSZ series SMI connected switch driver"
+	depends on NET_DSA_MICROCHIP_KSZ8863
+	select MDIO_BITBANG
+	default y
+	help
+	  Select to enable support for registering switches configured through
+	  Microchip SMI. It Supports the KSZ8863 and KSZ8873 Switch.
diff --git a/drivers/net/dsa/microchip/Makefile b/drivers/net/dsa/microchip/Makefile
index 929caa81e782e..694c2e2eea228 100644
--- a/drivers/net/dsa/microchip/Makefile
+++ b/drivers/net/dsa/microchip/Makefile
@@ -5,3 +5,5 @@ obj-$(CONFIG_NET_DSA_MICROCHIP_KSZ9477_I2C)	+= ksz9477_i2c.o
 obj-$(CONFIG_NET_DSA_MICROCHIP_KSZ9477_SPI)	+= ksz9477_spi.o
 obj-$(CONFIG_NET_DSA_MICROCHIP_KSZ8795)		+= ksz8795.o
 obj-$(CONFIG_NET_DSA_MICROCHIP_KSZ8795_SPI)	+= ksz8795_spi.o
+obj-$(CONFIG_NET_DSA_MICROCHIP_KSZ8863)	        += ksz8863.o
+obj-$(CONFIG_NET_DSA_MICROCHIP_KSZ8863_SMI)	+= ksz8863_smi.o
diff --git a/drivers/net/dsa/microchip/ksz8863.c b/drivers/net/dsa/microchip/ksz8863.c
new file mode 100644
index 0000000000000..c299a3f41eef7
--- /dev/null
+++ b/drivers/net/dsa/microchip/ksz8863.c
@@ -0,0 +1,1038 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Microchip KSZ8863 switch driver main logic
+ *
+ * Copyright (C) 2017-2019 Microchip Technology Inc.
+ * Copyright (C) 2019 Pengutronix, Michael Grzeschik <kernel@pengutronix.de>
+ */
+
+#include <linux/delay.h>
+#include <linux/export.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/platform_data/microchip-ksz.h>
+#include <linux/phy.h>
+#include <linux/etherdevice.h>
+#include <linux/if_bridge.h>
+#include <net/dsa.h>
+#include <net/switchdev.h>
+
+#include "ksz_common.h"
+#include "ksz8863_reg.h"
+
+static const struct {
+	char string[ETH_GSTRING_LEN];
+} mib_names[TOTAL_SWITCH_COUNTER_NUM] = {
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
+static void ksz_cfg(struct ksz_device *dev, u32 addr, u8 bits, bool set)
+{
+	regmap_update_bits(dev->regmap[0], addr, bits, set ? bits : 0);
+}
+
+static void ksz_port_cfg(struct ksz_device *dev, int port, int offset, u8 bits,
+			 bool set)
+{
+	regmap_update_bits(dev->regmap[0], PORT_CTRL_ADDR(port, offset),
+			   bits, set ? bits : 0);
+}
+
+static int ksz8863_reset_switch(struct ksz_device *dev)
+{
+	/* reset switch */
+	ksz_cfg(dev, REG_SWITCH_RESET, GLOBAL_SOFTWARE_RESET | PCS_RESET, true);
+
+	ksz_cfg(dev, REG_POWER_MANAGEMENT, SWITCH_SOFTWARE_POWER_DOWN, true);
+	ksz_cfg(dev, REG_POWER_MANAGEMENT, SWITCH_SOFTWARE_POWER_DOWN, false);
+
+	return 0;
+}
+
+static void ksz8863_r_mib_cnt(struct ksz_device *dev, int port, u16 addr,
+			      u64 *cnt)
+{
+	u32 data;
+	u16 ctrl_addr;
+	u8 check;
+	int loop;
+
+	ctrl_addr = addr + SWITCH_COUNTER_NUM * port;
+	ctrl_addr |= IND_ACC_TABLE(TABLE_MIB | TABLE_READ);
+
+	mutex_lock(&dev->alu_mutex);
+	ksz_write16(dev, REG_IND_CTRL_0, ctrl_addr);
+
+	/* It is almost guaranteed to always read the valid bit because of
+	 * slow SPI speed.
+	 */
+	for (loop = 2; loop > 0; loop--) {
+		ksz_read8(dev, REG_IND_MIB_CHECK, &check);
+
+		if (check & MIB_COUNTER_VALID) {
+			ksz_read32(dev, REG_IND_DATA_LO, &data);
+			if (check & MIB_COUNTER_OVERFLOW)
+				*cnt += MIB_COUNTER_VALUE + 1;
+			*cnt += data & MIB_COUNTER_VALUE;
+			break;
+		}
+	}
+	mutex_unlock(&dev->alu_mutex);
+}
+
+static void ksz8863_r_mib_pkt(struct ksz_device *dev, int port, u16 addr,
+			      u64 *dropped, u64 *cnt)
+{
+	u32 cur;
+	u32 data;
+	u16 ctrl_addr;
+	u32 *last = (u32 *)dropped;
+
+	addr -= SWITCH_COUNTER_NUM;
+	ctrl_addr = addr ? KS_MIB_PACKET_DROPPED_TX_0 :
+			   KS_MIB_PACKET_DROPPED_RX_0;
+	ctrl_addr += port;
+	ctrl_addr |= IND_ACC_TABLE(TABLE_MIB | TABLE_READ);
+
+	mutex_lock(&dev->alu_mutex);
+	ksz_write16(dev, REG_IND_CTRL_0, ctrl_addr);
+	ksz_read32(dev, REG_IND_DATA_LO, &data);
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
+static void ksz8863_port_init_cnt(struct ksz_device *dev, int port)
+{
+	struct ksz_port_mib *mib = &dev->ports[port].mib;
+	u64 *dropped;
+
+	mib->cnt_ptr = 0;
+
+	/* Some ports may not have MIB counters before SWITCH_COUNTER_NUM. */
+	while (mib->cnt_ptr < dev->reg_mib_cnt) {
+		dev->dev_ops->r_mib_cnt(dev, port, mib->cnt_ptr,
+					&mib->counters[mib->cnt_ptr]);
+		++mib->cnt_ptr;
+	}
+
+	/* last one in storage */
+	dropped = &mib->counters[dev->mib_cnt];
+
+	/* Some ports may not have MIB counters after SWITCH_COUNTER_NUM. */
+	while (mib->cnt_ptr < dev->mib_cnt) {
+		dev->dev_ops->r_mib_pkt(dev, port, mib->cnt_ptr,
+					dropped, &mib->counters[mib->cnt_ptr]);
+		++mib->cnt_ptr;
+	}
+	mib->cnt_ptr = 0;
+	memset(mib->counters, 0, dev->mib_cnt * sizeof(u64));
+}
+
+static void ksz8863_r_table(struct ksz_device *dev, int table, u16 addr,
+			    u64 *data)
+{
+	u16 ctrl_addr;
+
+	ctrl_addr = IND_ACC_TABLE(table | TABLE_READ) | addr;
+
+	mutex_lock(&dev->alu_mutex);
+	ksz_write16(dev, REG_IND_CTRL_0, ctrl_addr);
+	ksz_read64(dev, REG_IND_DATA_HI, data);
+	mutex_unlock(&dev->alu_mutex);
+	*data = be64_to_cpu(*data);
+}
+
+static void ksz8863_w_table(struct ksz_device *dev, int table, u16 addr,
+			    u64 data)
+{
+	u16 ctrl_addr;
+
+	ctrl_addr = IND_ACC_TABLE(table) | addr;
+	data = cpu_to_be64(data);
+
+	mutex_lock(&dev->alu_mutex);
+	ksz_write64(dev, REG_IND_DATA_HI, data);
+	ksz_write16(dev, REG_IND_CTRL_0, ctrl_addr);
+	mutex_unlock(&dev->alu_mutex);
+}
+
+static int ksz8863_valid_dyn_entry(struct ksz_device *dev, u8 *data)
+{
+	int timeout = 100;
+
+	do {
+		ksz_read8(dev, REG_IND_DATA_CHECK, data);
+		timeout--;
+	} while ((*data & DYNAMIC_MAC_TABLE_NOT_READY) && timeout);
+
+	/* Entry is not ready for accessing. */
+	if (*data & DYNAMIC_MAC_TABLE_NOT_READY) {
+		return -EAGAIN;
+	/* Entry is ready for accessing. */
+	} else {
+		ksz_read8(dev, REG_IND_DATA_8, data);
+
+		/* There is no valid entry in the table. */
+		if (*data & DYNAMIC_MAC_TABLE_MAC_EMPTY)
+			return -ENXIO;
+	}
+	return 0;
+}
+
+static int ksz8863_r_dyn_mac_table(struct ksz_device *dev, u16 addr,
+				   u8 *mac_addr, u8 *fid, u8 *src_port,
+				   u8 *timestamp, u16 *entries)
+{
+	u32 data_hi;
+	u32 data_lo;
+	u16 ctrl_addr;
+	int rc;
+	u8 data;
+
+	ctrl_addr = IND_ACC_TABLE(TABLE_DYNAMIC_MAC | TABLE_READ) | addr;
+
+	mutex_lock(&dev->alu_mutex);
+	ksz_write16(dev, REG_IND_CTRL_0, ctrl_addr);
+
+	rc = ksz8863_valid_dyn_entry(dev, &data);
+	if (rc == -EAGAIN) {
+		if (addr == 0)
+			*entries = 0;
+	} else if (rc == -ENXIO) {
+		*entries = 0;
+	/* At least one valid entry in the table. */
+	} else {
+		u64 buf;
+		int cnt;
+
+		regmap_bulk_read(dev->regmap[0], REG_IND_DATA_HI,
+				 &buf, sizeof(buf));
+		buf = be64_to_cpu(buf);
+		data_hi = (u32)(buf >> 32);
+		data_lo = (u32)buf;
+
+		/* Check out how many valid entry in the table. */
+		cnt = data & DYNAMIC_MAC_TABLE_ENTRIES_H;
+		cnt <<= DYNAMIC_MAC_ENTRIES_H_S;
+		cnt |= (data_hi & DYNAMIC_MAC_TABLE_ENTRIES) >>
+			DYNAMIC_MAC_ENTRIES_S;
+		*entries = cnt + 1;
+
+		*fid = (data_hi & DYNAMIC_MAC_TABLE_FID) >>
+			DYNAMIC_MAC_FID_S;
+		*src_port = (data_hi & DYNAMIC_MAC_TABLE_SRC_PORT) >>
+			DYNAMIC_MAC_SRC_PORT_S;
+		*timestamp = (data_hi & DYNAMIC_MAC_TABLE_TIMESTAMP) >>
+			DYNAMIC_MAC_TIMESTAMP_S;
+
+		mac_addr[5] = (u8)data_lo;
+		mac_addr[4] = (u8)(data_lo >> 8);
+		mac_addr[3] = (u8)(data_lo >> 16);
+		mac_addr[2] = (u8)(data_lo >> 24);
+
+		mac_addr[1] = (u8)data_hi;
+		mac_addr[0] = (u8)(data_hi >> 8);
+		rc = 0;
+	}
+	mutex_unlock(&dev->alu_mutex);
+
+	return rc;
+}
+
+static int ksz8863_r_sta_mac_table(struct ksz_device *dev, u16 addr,
+				   struct alu_struct *alu)
+{
+	u64 data;
+	u32 data_hi;
+	u32 data_lo;
+
+	ksz8863_r_table(dev, TABLE_STATIC_MAC, addr, &data);
+
+	data_hi = data >> 32;
+	data_lo = (u32)data;
+
+	if (data_hi & (STATIC_MAC_TABLE_VALID | STATIC_MAC_TABLE_OVERRIDE)) {
+		alu->mac[5] = (u8)data_lo;
+		alu->mac[4] = (u8)(data_lo >> 8);
+		alu->mac[3] = (u8)(data_lo >> 16);
+		alu->mac[2] = (u8)(data_lo >> 24);
+		alu->mac[1] = (u8)data_hi;
+		alu->mac[0] = (u8)(data_hi >> 8);
+		alu->port_forward = (data_hi & STATIC_MAC_TABLE_FWD_PORTS) >>
+			STATIC_MAC_FWD_PORTS_S;
+		alu->is_override =
+			(data_hi & STATIC_MAC_TABLE_OVERRIDE) ? 1 : 0;
+		data_hi >>= 1;
+		alu->is_static = true;
+		alu->is_use_fid = (data_hi & STATIC_MAC_TABLE_USE_FID) ? 1 : 0;
+		alu->fid = (data_hi & STATIC_MAC_TABLE_FID) >>
+			STATIC_MAC_FID_S;
+
+		return 0;
+	}
+
+	return -ENXIO;
+}
+
+static void ksz8863_w_sta_mac_table(struct ksz_device *dev, u16 addr,
+				    struct alu_struct *alu)
+{
+	u64 data;
+	u32 data_hi;
+	u32 data_lo;
+
+	data_lo = ((u32)alu->mac[2] << 24) |
+		((u32)alu->mac[3] << 16) |
+		((u32)alu->mac[4] << 8) | alu->mac[5];
+	data_hi = ((u32)alu->mac[0] << 8) | alu->mac[1];
+	data_hi |= (u32)alu->port_forward << STATIC_MAC_FWD_PORTS_S;
+
+	if (alu->is_override)
+		data_hi |= STATIC_MAC_TABLE_OVERRIDE;
+
+	if (alu->is_use_fid) {
+		data_hi |= STATIC_MAC_TABLE_USE_FID;
+		data_hi |= (u32)alu->fid << STATIC_MAC_FID_S;
+	}
+
+	if (alu->is_static)
+		data_hi |= STATIC_MAC_TABLE_VALID;
+	else
+		data_hi &= ~STATIC_MAC_TABLE_OVERRIDE;
+
+	data = (u64)data_hi << 32 | data_lo;
+	ksz8863_w_table(dev, TABLE_STATIC_MAC, addr, data);
+}
+
+static inline void ksz8863_from_vlan(u16 vlan, u8 *fid, u8 *member, u8 *valid)
+{
+	*fid = vlan & VLAN_TABLE_FID;
+	*member = (vlan & VLAN_TABLE_MEMBERSHIP) >> VLAN_TABLE_MEMBERSHIP_S;
+	*valid = !!(vlan & VLAN_TABLE_VALID);
+}
+
+static inline void ksz8863_to_vlan(u8 fid, u8 member, u8 valid, u16 *vlan)
+{
+	*vlan = fid;
+	*vlan |= (u16)member << VLAN_TABLE_MEMBERSHIP_S;
+	if (valid)
+		*vlan |= VLAN_TABLE_VALID;
+}
+
+static void ksz8863_r_vlan_entries(struct ksz_device *dev, u16 addr)
+{
+	u64 data;
+	int i;
+
+	ksz8863_r_table(dev, TABLE_VLAN, addr, &data);
+	addr *= 2;
+	for (i = 0; i < 2; i++) {
+		dev->vlan_cache[addr + i].table[0] = data & VLAN_TABLE_M;
+		data >>= VLAN_TABLE_S;
+	}
+}
+
+static void ksz8863_r_vlan_table(struct ksz_device *dev, u16 vid, u16 *vlan)
+{
+	u64 buf;
+	u16 addr;
+	int index;
+
+	addr = vid / 2;
+	index = vid & 3;
+	ksz8863_r_table(dev, TABLE_VLAN, addr, &buf);
+	buf >>= VLAN_TABLE_S * index;
+	*vlan = buf & VLAN_TABLE_M;
+}
+
+static void ksz8863_w_vlan_table(struct ksz_device *dev, u16 vid, u16 vlan)
+{
+	u64 buf;
+	u16 addr;
+	int index;
+
+	addr = vid / 2;
+	index = vid & 3;
+	ksz8863_r_table(dev, TABLE_VLAN, addr, &buf);
+	index *= VLAN_TABLE_S;
+	buf &= ~(VLAN_TABLE_M << index);
+	buf |= (u64)vlan << index;
+	dev->vlan_cache[vid].table[0] = vlan;
+	ksz8863_w_table(dev, TABLE_VLAN, addr, buf);
+}
+
+static enum dsa_tag_protocol ksz8863_get_tag_protocol(struct dsa_switch *ds,
+						      int port)
+{
+	/* Use KSZ8795 tail tagging code. */
+	return DSA_TAG_PROTO_KSZ8863;
+}
+
+static void ksz8863_get_strings(struct dsa_switch *ds, int port,
+				u32 stringset, uint8_t *buf)
+{
+	int i;
+
+	switch (stringset) {
+	case ETH_SS_STATS:
+		for (i = 0; i < TOTAL_SWITCH_COUNTER_NUM; i++) {
+			memcpy(buf + i * ETH_GSTRING_LEN, mib_names[i].string,
+			       ETH_GSTRING_LEN);
+		}
+		break;
+	}
+}
+
+static const u8 stp_multicast_addr[] = {
+	0x01, 0x80, 0xC2, 0x00, 0x00, 0x00
+};
+
+static void ksz8863_cfg_port_member(struct ksz_device *dev, int port,
+				    u8 member)
+{
+	u8 data;
+
+	ksz_pread8(dev, port, P_MIRROR_CTRL, &data);
+	data &= ~PORT_VLAN_MEMBERSHIP;
+	data |= (member & dev->port_mask);
+	ksz_pwrite8(dev, port, P_MIRROR_CTRL, data);
+	dev->ports[port].member = member;
+}
+
+static void ksz8863_port_stp_state_set(struct dsa_switch *ds, int port,
+				       u8 state)
+{
+	struct ksz_device *dev = ds->priv;
+	struct ksz_port *p = &dev->ports[port];
+	u8 data;
+	int member = -1;
+
+	ksz_pread8(dev, port, P_STP_CTRL, &data);
+	data &= ~(PORT_TX_ENABLE | PORT_RX_ENABLE | PORT_LEARN_DISABLE);
+
+	switch (state) {
+	case BR_STATE_DISABLED:
+		data |= PORT_LEARN_DISABLE;
+		if (port < SWITCH_PORT_NUM)
+			member = 0;
+		break;
+	case BR_STATE_LISTENING:
+		data |= (PORT_RX_ENABLE | PORT_LEARN_DISABLE);
+		if (port < SWITCH_PORT_NUM &&
+		    p->stp_state == BR_STATE_DISABLED)
+			member = dev->host_mask | p->vid_member;
+		break;
+	case BR_STATE_LEARNING:
+		data |= PORT_RX_ENABLE;
+		break;
+	case BR_STATE_FORWARDING:
+		data |= (PORT_TX_ENABLE | PORT_RX_ENABLE);
+
+		/* This function is also used internally. */
+		if (port == dev->cpu_port)
+			break;
+
+		/* Port is a member of a bridge. */
+		if (dev->br_member & (1 << port)) {
+			dev->member |= (1 << port);
+			member = dev->member;
+		} else {
+			member = dev->host_mask | p->vid_member;
+		}
+		break;
+	case BR_STATE_BLOCKING:
+		data |= PORT_LEARN_DISABLE;
+		if (port < SWITCH_PORT_NUM &&
+		    p->stp_state == BR_STATE_DISABLED)
+			member = dev->host_mask | p->vid_member;
+		break;
+	default:
+		dev_err(ds->dev, "invalid STP state: %d\n", state);
+		return;
+	}
+
+	ksz_pwrite8(dev, port, P_STP_CTRL, data);
+	p->stp_state = state;
+	if (data & PORT_RX_ENABLE)
+		dev->rx_ports |= (1 << port);
+	else
+		dev->rx_ports &= ~(1 << port);
+	if (data & PORT_TX_ENABLE)
+		dev->tx_ports |= (1 << port);
+	else
+		dev->tx_ports &= ~(1 << port);
+
+	/* Port membership may share register with STP state. */
+	if (member >= 0 && member != p->member)
+		ksz8863_cfg_port_member(dev, port, (u8)member);
+
+	/* Check if forwarding needs to be updated. */
+	if (state != BR_STATE_FORWARDING) {
+		if (dev->br_member & (1 << port))
+			dev->member &= ~(1 << port);
+	}
+
+	/* When topology has changed the function ksz_update_port_member
+	 * should be called to modify port forwarding behavior.  However
+	 * as the offload_fwd_mark indication cannot be reported here
+	 * the switch forwarding function is not enabled.
+	 */
+}
+
+static void ksz8863_flush_dyn_mac_table(struct ksz_device *dev, int port)
+{
+	int cnt;
+	int first;
+	int index;
+	u8 learn[TOTAL_PORT_NUM];
+
+	if ((uint)port < TOTAL_PORT_NUM) {
+		first = port;
+		cnt = port + 1;
+	} else {
+		/* Flush all ports. */
+		first = 0;
+		cnt = dev->mib_port_cnt;
+	}
+	for (index = first; index < cnt; index++) {
+		ksz_pread8(dev, index, P_STP_CTRL, &learn[index]);
+		if (!(learn[index] & PORT_LEARN_DISABLE))
+			ksz_pwrite8(dev, index, P_STP_CTRL,
+				    learn[index] | PORT_LEARN_DISABLE);
+	}
+	ksz_cfg(dev, S_FLUSH_TABLE_CTRL, SWITCH_FLUSH_DYN_MAC_TABLE, true);
+	for (index = first; index < cnt; index++) {
+		if (!(learn[index] & PORT_LEARN_DISABLE))
+			ksz_pwrite8(dev, index, P_STP_CTRL, learn[index]);
+	}
+}
+
+static int ksz8863_port_vlan_filtering(struct dsa_switch *ds, int port,
+				       bool flag)
+{
+	struct ksz_device *dev = ds->priv;
+
+	ksz_cfg(dev, S_MIRROR_CTRL, SWITCH_VLAN_ENABLE, flag);
+
+	return 0;
+}
+
+static void ksz8863_port_vlan_add(struct dsa_switch *ds, int port,
+				  const struct switchdev_obj_port_vlan *vlan)
+{
+	struct ksz_device *dev = ds->priv;
+	bool untagged = vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
+	u16 data;
+	u16 vid;
+	u8 fid;
+	u8 member;
+	u8 valid;
+	u16 new_pvid = 0;
+
+	mutex_lock(&dev->vlan_mutex);
+
+	ksz_port_cfg(dev, port, P_TAG_CTRL, PORT_REMOVE_TAG, untagged);
+
+	for (vid = vlan->vid_begin; vid <= vlan->vid_end; vid++) {
+		ksz8863_r_vlan_table(dev, vid, &data);
+		ksz8863_from_vlan(data, &fid, &member, &valid);
+
+		/* First time to setup the VLAN entry. */
+		if (!valid) {
+			/* Need to find a way to map VID to FID. */
+			fid = 1;
+			valid = 1;
+		}
+		member |= BIT(port);
+
+		ksz8863_to_vlan(fid, member, valid, &data);
+		ksz8863_w_vlan_table(dev, vid, data);
+
+		/* change PVID */
+		if (vlan->flags & BRIDGE_VLAN_INFO_PVID)
+			new_pvid = vid;
+	}
+
+	if (new_pvid) {
+		ksz_pread16(dev, port, REG_PORT_CTRL_VID, &vid);
+		vid &= 0xfff;
+		vid |= new_pvid;
+		ksz_pwrite16(dev, port, REG_PORT_CTRL_VID, vid);
+	}
+
+	mutex_unlock(&dev->vlan_mutex);
+}
+
+static int ksz8863_port_vlan_del(struct dsa_switch *ds, int port,
+				 const struct switchdev_obj_port_vlan *vlan)
+{
+	struct ksz_device *dev = ds->priv;
+	bool untagged = vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
+	u16 data;
+	u16 vid;
+	u16 pvid;
+	u8 fid;
+	u8 member;
+	u8 valid;
+	u16 new_pvid = 0;
+
+	mutex_lock(&dev->vlan_mutex);
+
+	ksz_pread16(dev, port, REG_PORT_CTRL_VID, &pvid);
+	pvid = pvid & 0xFFF;
+
+	ksz_port_cfg(dev, port, P_TAG_CTRL, PORT_REMOVE_TAG, untagged);
+
+	for (vid = vlan->vid_begin; vid <= vlan->vid_end; vid++) {
+		ksz8863_r_vlan_table(dev, vid, &data);
+		ksz8863_from_vlan(data, &fid, &member, &valid);
+
+		member &= ~BIT(port);
+
+		/* Invalidate the entry if no more member. */
+		if (!member) {
+			fid = 0;
+			valid = 0;
+		}
+
+		if (pvid == vid)
+			new_pvid = 1;
+
+		ksz8863_to_vlan(fid, member, valid, &data);
+		ksz8863_w_vlan_table(dev, vid, data);
+	}
+
+	if (new_pvid != pvid)
+		ksz_pwrite16(dev, port, REG_PORT_CTRL_VID, pvid);
+
+	mutex_unlock(&dev->vlan_mutex);
+
+	return 0;
+}
+
+static int ksz8863_port_mirror_add(struct dsa_switch *ds, int port,
+				   struct dsa_mall_mirror_tc_entry *mirror,
+				   bool ingress)
+{
+	struct ksz_device *dev = ds->priv;
+
+	if (ingress) {
+		ksz_port_cfg(dev, port, P_MIRROR_CTRL, PORT_MIRROR_RX, true);
+		dev->mirror_rx |= (1 << port);
+	} else {
+		ksz_port_cfg(dev, port, P_MIRROR_CTRL, PORT_MIRROR_TX, true);
+		dev->mirror_tx |= (1 << port);
+	}
+
+	ksz_port_cfg(dev, port, P_MIRROR_CTRL, PORT_MIRROR_SNIFFER, false);
+
+	/* configure mirror port */
+	if (dev->mirror_rx || dev->mirror_tx)
+		ksz_port_cfg(dev, mirror->to_local_port, P_MIRROR_CTRL,
+			     PORT_MIRROR_SNIFFER, true);
+
+	return 0;
+}
+
+static void ksz8863_port_mirror_del(struct dsa_switch *ds, int port,
+				    struct dsa_mall_mirror_tc_entry *mirror)
+{
+	struct ksz_device *dev = ds->priv;
+	u8 data;
+
+	if (mirror->ingress) {
+		ksz_port_cfg(dev, port, P_MIRROR_CTRL, PORT_MIRROR_RX, false);
+		dev->mirror_rx &= ~(1 << port);
+	} else {
+		ksz_port_cfg(dev, port, P_MIRROR_CTRL, PORT_MIRROR_TX, false);
+		dev->mirror_tx &= ~(1 << port);
+	}
+
+	ksz_pread8(dev, port, P_MIRROR_CTRL, &data);
+
+	if (!dev->mirror_rx && !dev->mirror_tx)
+		ksz_port_cfg(dev, mirror->to_local_port, P_MIRROR_CTRL,
+			     PORT_MIRROR_SNIFFER, false);
+}
+
+static void ksz8863_phy_setup(struct ksz_device *dev, int port,
+			      struct phy_device *phy)
+{
+	/* SUPPORTED_Pause can be removed to disable flow control when
+	 * rate limiting is used.
+	 */
+	linkmode_clear_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT, phy->supported);
+	linkmode_copy(phy->advertising, phy->supported);
+}
+
+static void ksz8863_port_setup(struct ksz_device *dev, int port, bool cpu_port)
+{
+	u8 member;
+	struct ksz_port *p = &dev->ports[port];
+
+	/* enable broadcast storm limit */
+	ksz_port_cfg(dev, port, P_BCAST_STORM_CTRL, PORT_BROADCAST_STORM, true);
+
+	/* disable DiffServ priority */
+	ksz_port_cfg(dev, port, P_PRIO_CTRL, PORT_DIFFSERV_ENABLE, false);
+
+	/* replace priority */
+	ksz_port_cfg(dev, port, P_802_1P_CTRL, PORT_802_1P_REMAPPING, false);
+
+	/* enable 802.1p priority */
+	ksz_port_cfg(dev, port, P_PRIO_CTRL, PORT_802_1P_ENABLE, true);
+
+	if (cpu_port) {
+		member = dev->port_mask;
+		dev->on_ports = dev->host_mask;
+		dev->live_ports = dev->host_mask;
+	} else {
+		member = dev->host_mask | p->vid_member;
+		dev->on_ports |= (1 << port);
+
+		/* Link was detected before port is enabled. */
+		if (p->phydev.link)
+			dev->live_ports |= (1 << port);
+	}
+	ksz8863_cfg_port_member(dev, port, member);
+}
+
+static void ksz8863_config_cpu_port(struct dsa_switch *ds)
+{
+	struct ksz_device *dev = ds->priv;
+	struct ksz_port *p;
+	int i;
+
+	ds->num_ports = dev->port_cnt + 1;
+
+	ksz_cfg(dev, S_TAIL_TAG_CTRL, SWITCH_TAIL_TAG_ENABLE, true);
+
+	p = &dev->ports[dev->cpu_port];
+	p->vid_member = dev->port_mask;
+	p->on = 1;
+
+	ksz8863_port_setup(dev, dev->cpu_port, true);
+	dev->member = dev->host_mask;
+
+	for (i = 0; i < SWITCH_PORT_NUM; i++) {
+		p = &dev->ports[i];
+
+		/* Initialize to non-zero so that ksz_cfg_port_member() will
+		 * be called.
+		 */
+		p->vid_member = (1 << i);
+		p->member = dev->port_mask;
+		ksz8863_port_stp_state_set(ds, i, BR_STATE_DISABLED);
+
+		p->on = 1;
+		p->phy = 1;
+	}
+
+	for (i = 0; i < dev->phy_port_cnt; i++) {
+		p = &dev->ports[i];
+		if (!p->on)
+			continue;
+		ksz_port_cfg(dev, i, P_STP_CTRL, PORT_FORCE_FLOW_CTRL,
+			     false);
+	}
+}
+
+static int ksz8863_setup(struct dsa_switch *ds)
+{
+	u8 data8;
+	u16 data16;
+	u32 value;
+	int i;
+	struct alu_struct alu;
+	struct ksz_device *dev = ds->priv;
+	int ret = 0;
+
+	dev->vlan_cache = devm_kcalloc(dev->dev, sizeof(struct vlan_table),
+				       dev->num_vlans, GFP_KERNEL);
+	if (!dev->vlan_cache)
+		return -ENOMEM;
+
+	ret = ksz8863_reset_switch(dev);
+	if (ret) {
+		dev_err(ds->dev, "failed to reset switch\n");
+		return ret;
+	}
+
+	ksz_cfg(dev, S_REPLACE_VID_CTRL, SWITCH_FLOW_CTRL, true);
+
+	/* Enable automatic fast aging when link changed detected. */
+	ksz_cfg(dev, S_LINK_AGING_CTRL, SWITCH_LINK_AUTO_AGING, true);
+
+	ksz_read8(dev, REG_SWITCH_CTRL_1, &data8);
+
+	/* Enable aggressive back off algorithm in half duplex mode. */
+	data8 |= SWITCH_AGGR_BACKOFF;
+	ksz_write8(dev, REG_SWITCH_CTRL_1, data8);
+
+	ksz_read8(dev, REG_SWITCH_CTRL_2, &data8);
+
+	/* Make sure unicast VLAN boundary is set as default. */
+	data8 |= UNICAST_VLAN_BOUNDARY;
+
+	/* Enable no excessive collision drop. */
+	data8 |= NO_EXC_COLLISION_DROP;
+	ksz_write8(dev, REG_SWITCH_CTRL_2, data8);
+
+	ksz8863_config_cpu_port(ds);
+
+	ksz_cfg(dev, REG_SWITCH_CTRL_2, MULTICAST_STORM_DISABLE, true);
+
+	ksz_cfg(dev, S_REPLACE_VID_CTRL, SWITCH_REPLACE_VID, false);
+
+	ksz_cfg(dev, S_MIRROR_CTRL, SWITCH_MIRROR_RX_TX, false);
+
+	/* set broadcast storm protection 10% rate */
+	data8 = BROADCAST_STORM_PROT_RATE;
+	value = ((u32)BROADCAST_STORM_VALUE * data8) / 100;
+	if (value > BROADCAST_STORM_RATE)
+		value = BROADCAST_STORM_RATE;
+	ksz_read16(dev, S_REPLACE_VID_CTRL, &data16);
+	data16 &= ~BROADCAST_STORM_RATE;
+	data16 |= value;
+	ksz_write16(dev, S_REPLACE_VID_CTRL, data16);
+
+	for (i = 0; i < VLAN_TABLE_ENTRIES; i++)
+		ksz8863_r_vlan_entries(dev, i);
+
+	/* Setup STP address for STP operation. */
+	memset(&alu, 0, sizeof(alu));
+	memcpy(alu.mac, stp_multicast_addr, ETH_ALEN);
+	alu.is_static = true;
+	alu.is_override = true;
+	alu.port_forward = dev->host_mask;
+
+	ksz8863_w_sta_mac_table(dev, 0, &alu);
+
+	ksz_write8(dev, REG_CHIP_ID1, SWITCH_START);
+
+	ksz_init_mib_timer(dev);
+
+	return 0;
+}
+
+static const struct dsa_switch_ops ksz8863_switch_ops = {
+	.get_tag_protocol	= ksz8863_get_tag_protocol,
+	.setup			= ksz8863_setup,
+	.adjust_link		= ksz_adjust_link,
+	.port_enable		= ksz_enable_port,
+	.port_disable		= ksz_disable_port,
+	.get_strings		= ksz8863_get_strings,
+	.get_ethtool_stats	= ksz_get_ethtool_stats,
+	.get_sset_count		= ksz_sset_count,
+	.port_bridge_join	= ksz_port_bridge_join,
+	.port_bridge_leave	= ksz_port_bridge_leave,
+	.port_stp_state_set	= ksz8863_port_stp_state_set,
+	.port_fast_age		= ksz_port_fast_age,
+	.port_vlan_filtering	= ksz8863_port_vlan_filtering,
+	.port_vlan_prepare	= ksz_port_vlan_prepare,
+	.port_vlan_add		= ksz8863_port_vlan_add,
+	.port_vlan_del		= ksz8863_port_vlan_del,
+	.port_fdb_dump		= ksz_port_fdb_dump,
+	.port_mdb_prepare       = ksz_port_mdb_prepare,
+	.port_mdb_add           = ksz_port_mdb_add,
+	.port_mdb_del           = ksz_port_mdb_del,
+	.port_mirror_add	= ksz8863_port_mirror_add,
+	.port_mirror_del	= ksz8863_port_mirror_del,
+};
+
+static u32 ksz8863_get_port_addr(int port, int reg)
+{
+	int offset;
+
+	PORT_CTRL_ADDR(port, offset);
+
+	return reg + offset;
+}
+
+static int ksz8863_switch_detect(struct ksz_device *dev)
+{
+	u16 id16;
+	u8 id1;
+	u8 id2;
+	int ret;
+
+	/* read chip id */
+	ret = ksz_read16(dev, REG_CHIP_ID0, &id16);
+	if (ret)
+		return ret;
+
+	id1 = id16 >> 8;
+	id2 = id16 & SW_CHIP_ID_M;
+	if (id1 != FAMILY_ID ||
+	    id2 != CHIP_ID_63)
+		return -ENODEV;
+
+	dev->mib_port_cnt = TOTAL_PORT_NUM;
+	dev->phy_port_cnt = SWITCH_PORT_NUM;
+
+	id16 = 0x8800;
+	id16 |= 0x73;
+	dev->chip_id = id16;
+
+	dev->cpu_port = dev->mib_port_cnt - 1;
+	dev->host_mask = (1 << dev->cpu_port);
+
+	return 0;
+}
+
+struct ksz_chip_data {
+	u16 chip_id;
+	const char *dev_name;
+	int num_vlans;
+	int num_alus;
+	int num_statics;
+	int cpu_ports;
+	int port_cnt;
+};
+
+static const struct ksz_chip_data ksz8863_switch_chips[] = {
+	{
+		.chip_id = 0x8863,
+		.dev_name = "KSZ8863",
+		.num_vlans = 16,
+		.num_alus = 0,
+		.num_statics = 8,
+		.cpu_ports = 0x4,	/* can be configured as cpu port */
+		.port_cnt = 2,		/* total physical port count */
+	},
+	{
+		.chip_id = 0x8873,
+		.dev_name = "KSZ8873",
+		.num_vlans = 16,
+		.num_alus = 0,
+		.num_statics = 8,
+		.cpu_ports = 0x4,	/* can be configured as cpu port */
+		.port_cnt = 2,		/* total physical port count */
+	},
+};
+
+static int ksz8863_switch_init(struct ksz_device *dev)
+{
+	int i;
+
+	dev->ds->ops = &ksz8863_switch_ops;
+
+	for (i = 0; i < ARRAY_SIZE(ksz8863_switch_chips); i++) {
+		const struct ksz_chip_data *chip = &ksz8863_switch_chips[i];
+
+		if (dev->chip_id == chip->chip_id) {
+			dev->name = chip->dev_name;
+			dev->num_vlans = chip->num_vlans;
+			dev->num_alus = chip->num_alus;
+			dev->num_statics = chip->num_statics;
+			dev->port_cnt = chip->port_cnt;
+			dev->cpu_ports = chip->cpu_ports;
+
+			break;
+		}
+	}
+
+	/* no switch found */
+	if (!dev->cpu_ports)
+		return -ENODEV;
+
+	dev->port_mask = (1 << dev->port_cnt) - 1;
+	dev->port_mask |= dev->host_mask;
+
+	dev->reg_mib_cnt = SWITCH_COUNTER_NUM;
+	dev->mib_cnt = TOTAL_SWITCH_COUNTER_NUM;
+
+	i = dev->mib_port_cnt;
+	dev->ports = devm_kzalloc(dev->dev, sizeof(struct ksz_port) * i,
+				  GFP_KERNEL);
+	if (!dev->ports)
+		return -ENOMEM;
+	for (i = 0; i < dev->mib_port_cnt; i++) {
+		mutex_init(&dev->ports[i].mib.cnt_mutex);
+		dev->ports[i].mib.counters =
+			devm_kzalloc(dev->dev,
+				     sizeof(u64) *
+				     (TOTAL_SWITCH_COUNTER_NUM + 1),
+				     GFP_KERNEL);
+		if (!dev->ports[i].mib.counters)
+			return -ENOMEM;
+	}
+
+	return 0;
+}
+
+static void ksz8863_switch_exit(struct ksz_device *dev)
+{
+	ksz8863_reset_switch(dev);
+	ksz_write8(dev, REG_CHIP_ID1, SWITCH_START);
+}
+
+static const struct ksz_dev_ops ksz8863_dev_ops = {
+	.get_port_addr = ksz8863_get_port_addr,
+	.cfg_port_member = ksz8863_cfg_port_member,
+	.flush_dyn_mac_table = ksz8863_flush_dyn_mac_table,
+	.phy_setup = ksz8863_phy_setup,
+	.port_setup = ksz8863_port_setup,
+	.r_dyn_mac_table = ksz8863_r_dyn_mac_table,
+	.r_sta_mac_table = ksz8863_r_sta_mac_table,
+	.w_sta_mac_table = ksz8863_w_sta_mac_table,
+	.r_mib_cnt = ksz8863_r_mib_cnt,
+	.r_mib_pkt = ksz8863_r_mib_pkt,
+	.port_init_cnt = ksz8863_port_init_cnt,
+	.shutdown = ksz8863_reset_switch,
+	.detect = ksz8863_switch_detect,
+	.init = ksz8863_switch_init,
+	.exit = ksz8863_switch_exit,
+};
+
+int ksz8863_switch_register(struct ksz_device *dev)
+{
+	return ksz_switch_register(dev, &ksz8863_dev_ops);
+}
+EXPORT_SYMBOL(ksz8863_switch_register);
+
+MODULE_AUTHOR("Michael Grzeschik <m.grzeschik@pengutronix.de>");
+MODULE_DESCRIPTION("Micrel KSZ8863 SMI Switch driver");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/net/dsa/microchip/ksz8863_reg.h b/drivers/net/dsa/microchip/ksz8863_reg.h
new file mode 100644
index 0000000000000..6921890ae5509
--- /dev/null
+++ b/drivers/net/dsa/microchip/ksz8863_reg.h
@@ -0,0 +1,605 @@
+/* SPDX-License-Identifier: GPL-2.0
+ *
+ * Microchip KSZ8863 definition file
+ *
+ * Copyright (c) 2015-2016 Microchip Technology Inc.
+ */
+
+#ifndef __KSZ8863_REGS_H
+#define __KSZ8863_REGS_H
+
+#define REG_CHIP_ID0			0x00
+
+#define FAMILY_ID			0x88
+
+#define REG_CHIP_ID1			0x01
+#define SW_CHIP_ID_M			0xF0
+
+#define SWITCH_CHIP_ID_MASK		0xF0
+#define SWITCH_CHIP_ID_SHIFT		4
+#define SWITCH_REVISION_MASK		0x0E
+#define SWITCH_REVISION_SHIFT		1
+#define SWITCH_START			0x01
+
+#define CHIP_ID_63			0x30
+
+#define REG_SWITCH_CTRL_0		0x02
+
+#define SWITCH_NEW_BACKOFF		BIT(7)
+#define SWITCH_FLUSH_DYN_MAC_TABLE	BIT(5)
+#define SWITCH_FLUSH_STA_MAC_TABLE	BIT(4)
+#define SWITCH_PASS_PAUSE		BIT(3)
+#define SWITCH_LINK_AUTO_AGING		BIT(0)
+
+#define REG_SWITCH_CTRL_1		0x03
+
+#define SWITCH_PASS_ALL			BIT(7)
+#define SWITCH_TAIL_TAG_ENABLE		BIT(6)
+#define SWITCH_TX_FLOW_CTRL		BIT(5)
+#define SWITCH_RX_FLOW_CTRL		BIT(4)
+#define SWITCH_CHECK_LENGTH		BIT(3)
+#define SWITCH_AGING_ENABLE		BIT(2)
+#define SWITCH_FAST_AGING		BIT(1)
+#define SWITCH_AGGR_BACKOFF		BIT(0)
+
+#define REG_SWITCH_CTRL_2		0x04
+
+#define UNICAST_VLAN_BOUNDARY		BIT(7)
+#define MULTICAST_STORM_DISABLE		BIT(6)
+#define SWITCH_BACK_PRESSURE		BIT(5)
+#define FAIR_FLOW_CTRL			BIT(4)
+#define NO_EXC_COLLISION_DROP		BIT(3)
+#define SWITCH_HUGE_PACKET		BIT(2)
+#define SWITCH_LEGAL_PACKET		BIT(1)
+
+#define REG_SWITCH_CTRL_3		0x05
+
+#define SWITCH_VLAN_ENABLE		BIT(7)
+#define SWITCH_IGMP_SNOOP		BIT(6)
+#define WEIGHTED_FAIR_QUEUE_ENABLE	BIT(3)
+#define SWITCH_MIRROR_RX_TX		BIT(0)
+
+#define REG_SWITCH_CTRL_4		0x06
+
+#define SWITCH_HALF_DUPLEX		BIT(6)
+#define SWITCH_FLOW_CTRL		BIT(5)
+#define SWITCH_10_MBIT			BIT(4)
+#define SWITCH_REPLACE_VID		BIT(3)
+#define BROADCAST_STORM_RATE_HI		0x07
+
+#define REG_SWITCH_CTRL_5		0x07
+
+#define BROADCAST_STORM_RATE_LO		0xFF
+#define BROADCAST_STORM_RATE		0x07FF
+
+#define REG_SWITCH_CTRL_9		0x0B
+
+#define SPI_CLK_125_MHZ			0x80
+#define SPI_CLK_62_5_MHZ		0x40
+#define SPI_CLK_31_25_MHZ		0x00
+
+#define REG_SWITCH_CTRL_10		0x0C
+#define REG_SWITCH_CTRL_11		0x0D
+
+#define SWITCH_802_1P_MASK		3
+#define SWITCH_802_1P_BASE		3
+#define SWITCH_802_1P_SHIFT		2
+
+#define SWITCH_802_1P_MAP_MASK		3
+#define SWITCH_802_1P_MAP_SHIFT		2
+
+#define REG_SWITCH_CTRL_12		0x0E
+
+#define SWITCH_UNKNOWN_DA_ENABLE	BIT(7)
+#define SWITCH_DRIVER_16MA		BIT(6)
+#define SWITCH_UNKNOWN_DA_2_PORT3	BIT(2)
+#define SWITCH_UNKNOWN_DA_2_PORT2	BIT(1)
+#define SWITCH_UNKNOWN_DA_2_PORT1	BIT(0)
+
+#define REG_SWITCH_CTRL_13		0x0F
+
+#define SWITCH_PORT_PHY_ADDR_MASK	0x1F
+#define SWITCH_PORT_PHY_ADDR_SHIFT	3
+
+#define REG_PORT_1_CTRL_0		0x10
+#define REG_PORT_2_CTRL_0		0x20
+#define REG_PORT_3_CTRL_0		0x30
+
+#define PORT_BROADCAST_STORM		BIT(7)
+#define PORT_DIFFSERV_ENABLE		BIT(6)
+#define PORT_802_1P_ENABLE		BIT(5)
+#define PORT_BASED_PRIORITY_MASK	0x18
+#define PORT_BASED_PRIORITY_BASE	0x03
+#define PORT_BASED_PRIORITY_SHIFT	3
+#define PORT_PORT_PRIO_0		0x00
+#define PORT_PORT_PRIO_1		0x08
+#define PORT_PORT_PRIO_2		0x10
+#define PORT_PORT_PRIO_3		0x18
+#define PORT_INSERT_TAG			BIT(2)
+#define PORT_REMOVE_TAG			BIT(1)
+#define PORT_4_QUEUES_ENABLE		BIT(0)
+
+#define REG_PORT_1_CTRL_1		0x11
+#define REG_PORT_2_CTRL_1		0x21
+#define REG_PORT_3_CTRL_1		0x31
+
+#define PORT_MIRROR_SNIFFER		BIT(7)
+#define PORT_MIRROR_RX			BIT(6)
+#define PORT_MIRROR_TX			BIT(5)
+#define PORT_DOUBLE_TAG			BIT(4)
+#define PORT_802_1P_REMAPPING		BIT(3)
+#define PORT_VLAN_MEMBERSHIP		0x07
+
+#define REG_PORT_1_CTRL_2		0x12
+#define REG_PORT_2_CTRL_2		0x22
+#define REG_PORT_3_CTRL_2		0x32
+
+#define PORT_2_QUEUES_ENABLE		BIT(7)
+#define PORT_INGRESS_FILTER		BIT(6)
+#define PORT_DISCARD_NON_VID		BIT(5)
+#define PORT_FORCE_FLOW_CTRL		BIT(4)
+#define PORT_BACK_PRESSURE		BIT(3)
+#define PORT_TX_ENABLE			BIT(2)
+#define PORT_RX_ENABLE			BIT(1)
+#define PORT_LEARN_DISABLE		BIT(0)
+
+#define REG_PORT_1_CTRL_3		0x13
+#define REG_PORT_2_CTRL_3		0x23
+#define REG_PORT_3_CTRL_3		0x33
+#define REG_PORT_1_CTRL_4		0x14
+#define REG_PORT_2_CTRL_4		0x24
+#define REG_PORT_3_CTRL_4		0x34
+
+#define PORT_DEFAULT_VID		0x0001
+
+#define REG_PORT_1_CTRL_5		0x15
+#define REG_PORT_2_CTRL_5		0x25
+#define REG_PORT_3_CTRL_5		0x35
+
+#define PORT_3_MII_MAC_MODE		BIT(7)
+#define PORT_SA_MAC2			BIT(6)
+#define PORT_SA_MAC1			BIT(5)
+#define PORT_DROP_TAG			BIT(4)
+#define PORT_INGRESS_LIMIT_MODE		0x0C
+#define PORT_INGRESS_ALL		0x00
+#define PORT_INGRESS_UNICAST		0x04
+#define PORT_INGRESS_MULTICAST		0x08
+#define PORT_INGRESS_BROADCAST		0x0C
+#define PORT_COUNT_IFG			BIT(1)
+#define PORT_COUNT_PREAMBLE		BIT(0)
+
+#define REG_PORT_1_IN_RATE_0		0x16
+#define REG_PORT_2_IN_RATE_0		0x26
+#define REG_PORT_3_IN_RATE_0		0x36
+
+#define PORT_3_INVERTED_REFCLK		BIT(7)
+
+#define REG_PORT_1_IN_RATE_1		0x17
+#define REG_PORT_2_IN_RATE_1		0x27
+#define REG_PORT_3_IN_RATE_1		0x37
+#define REG_PORT_1_IN_RATE_2		0x18
+#define REG_PORT_2_IN_RATE_2		0x28
+#define REG_PORT_3_IN_RATE_2		0x38
+#define REG_PORT_1_IN_RATE_3		0x19
+#define REG_PORT_2_IN_RATE_3		0x29
+#define REG_PORT_3_IN_RATE_3		0x39
+
+#define PORT_PRIO_RATE			0x0F
+#define PORT_PRIO_RATE_SHIFT		4
+
+#define REG_PORT_1_LINK_MD_CTRL		0x1A
+#define REG_PORT_2_LINK_MD_CTRL		0x2A
+
+#define PORT_CABLE_10M_SHORT		BIT(7)
+#define PORT_CABLE_DIAG_RESULT		0x60
+#define PORT_CABLE_STAT_NORMAL		0x00
+#define PORT_CABLE_STAT_OPEN		0x20
+#define PORT_CABLE_STAT_SHORT		0x40
+#define PORT_CABLE_STAT_FAILED		0x60
+#define PORT_START_CABLE_DIAG		BIT(4)
+#define PORT_FORCE_LINK			BIT(3)
+#define PORT_POWER_SAVING		0x04
+#define PORT_PHY_REMOTE_LOOPBACK	BIT(1)
+#define PORT_CABLE_FAULT_COUNTER_H	0x01
+
+#define REG_PORT_1_LINK_MD_RESULT	0x1B
+#define REG_PORT_2_LINK_MD_RESULT	0x2B
+
+#define PORT_CABLE_FAULT_COUNTER_L	0xFF
+#define PORT_CABLE_FAULT_COUNTER	0x1FF
+
+#define REG_PORT_1_CTRL_12		0x1C
+#define REG_PORT_2_CTRL_12		0x2C
+
+#define PORT_AUTO_NEG_ENABLE		BIT(7)
+#define PORT_FORCE_100_MBIT		BIT(6)
+#define PORT_FORCE_FULL_DUPLEX		BIT(5)
+#define PORT_AUTO_NEG_SYM_PAUSE		BIT(4)
+#define PORT_AUTO_NEG_100BTX_FD		BIT(3)
+#define PORT_AUTO_NEG_100BTX		BIT(2)
+#define PORT_AUTO_NEG_10BT_FD		BIT(1)
+#define PORT_AUTO_NEG_10BT		BIT(0)
+
+#define REG_PORT_1_CTRL_13		0x1D
+#define REG_PORT_2_CTRL_13		0x2D
+
+#define PORT_LED_OFF			BIT(7)
+#define PORT_TX_DISABLE			BIT(6)
+#define PORT_AUTO_NEG_RESTART		BIT(5)
+#define PORT_REMOTE_FAULT_DISABLE	BIT(4)
+#define PORT_POWER_DOWN			BIT(3)
+#define PORT_AUTO_MDIX_DISABLE		BIT(2)
+#define PORT_FORCE_MDIX			BIT(1)
+#define PORT_LOOPBACK			BIT(0)
+
+#define REG_PORT_1_STATUS_0		0x1E
+#define REG_PORT_2_STATUS_0		0x2E
+
+#define PORT_MDIX_STATUS		BIT(7)
+#define PORT_AUTO_NEG_COMPLETE		BIT(6)
+#define PORT_STATUS_LINK_GOOD		BIT(5)
+#define PORT_REMOTE_SYM_PAUSE		BIT(4)
+#define PORT_REMOTE_100BTX_FD		BIT(3)
+#define PORT_REMOTE_100BTX		BIT(2)
+#define PORT_REMOTE_10BT_FD		BIT(1)
+#define PORT_REMOTE_10BT		BIT(0)
+
+#define REG_PORT_1_STATUS_1		0x1F
+#define REG_PORT_2_STATUS_1		0x2F
+#define REG_PORT_3_STATUS_1		0x3F
+
+#define PORT_HP_MDIX			BIT(7)
+#define PORT_REVERSED_POLARITY		BIT(5)
+#define PORT_TX_FLOW_CTRL		BIT(4)
+#define PORT_RX_FLOW_CTRL		BIT(3)
+#define PORT_STAT_SPEED_100MBIT		BIT(2)
+#define PORT_STAT_FULL_DUPLEX		BIT(1)
+#define PORT_REMOTE_FAULT		BIT(0)
+
+#define REG_PORT_CTRL_0			0x00
+#define REG_PORT_CTRL_1			0x01
+#define REG_PORT_CTRL_2			0x02
+#define REG_PORT_CTRL_VID		0x03
+#define REG_PORT_CTRL_5			0x05
+#define REG_PORT_IN_RATE_0		0x06
+#define REG_PORT_IN_RATE_1		0x07
+#define REG_PORT_IN_RATE_2		0x08
+#define REG_PORT_IN_RATE_3		0x09
+#define REG_PORT_LINK_MD_CTRL		0x0A
+#define REG_PORT_LINK_MD_RESULT		0x0B
+#define REG_PORT_CTRL_12		0x0C
+#define REG_PORT_CTRL_13		0x0D
+#define REG_PORT_STATUS_0		0x0E
+#define REG_PORT_STATUS_1		0x0F
+
+#define PORT_CTRL_ADDR(port, addr)		\
+	(addr = REG_PORT_1_CTRL_0 + (port) *	\
+		(REG_PORT_2_CTRL_0 - REG_PORT_1_CTRL_0))
+
+#define REG_SWITCH_RESET		0x43
+
+#define GLOBAL_SOFTWARE_RESET		BIT(4)
+#define PCS_RESET			BIT(0)
+
+#define REG_TOS_PRIO_CTRL_0		0x60
+#define REG_TOS_PRIO_CTRL_1		0x61
+#define REG_TOS_PRIO_CTRL_2		0x62
+#define REG_TOS_PRIO_CTRL_3		0x63
+#define REG_TOS_PRIO_CTRL_4		0x64
+#define REG_TOS_PRIO_CTRL_5		0x65
+#define REG_TOS_PRIO_CTRL_6		0x66
+#define REG_TOS_PRIO_CTRL_7		0x67
+#define REG_TOS_PRIO_CTRL_8		0x68
+#define REG_TOS_PRIO_CTRL_9		0x69
+#define REG_TOS_PRIO_CTRL_10		0x6A
+#define REG_TOS_PRIO_CTRL_11		0x6B
+#define REG_TOS_PRIO_CTRL_12		0x6C
+#define REG_TOS_PRIO_CTRL_13		0x6D
+#define REG_TOS_PRIO_CTRL_14		0x6E
+#define REG_TOS_PRIO_CTRL_15		0x6F
+
+#define TOS_PRIO_M			3
+#define TOS_PRIO_S			2
+
+#define REG_SWITCH_MAC_ADDR_0		0x70
+#define REG_SWITCH_MAC_ADDR_1		0x71
+#define REG_SWITCH_MAC_ADDR_2		0x72
+#define REG_SWITCH_MAC_ADDR_3		0x73
+#define REG_SWITCH_MAC_ADDR_4		0x74
+#define REG_SWITCH_MAC_ADDR_5		0x75
+
+#define REG_USER_DEFINED_1		0x76
+#define REG_USER_DEFINED_2		0x77
+#define REG_USER_DEFINED_3		0x78
+
+#define REG_IND_CTRL_0			0x79
+
+#define TABLE_READ			BIT(4)
+#define TABLE_STATIC_MAC		BIT(2)
+#define TABLE_VLAN			BIT(2)
+#define TABLE_DYNAMIC_MAC		BIT(2)
+#define TABLE_MIB			BIT(2)
+
+#define REG_IND_CTRL_1			0x7A
+
+#define TABLE_ENTRY_MASK		0x03FF
+
+#define REG_IND_DATA_8			0x7B
+#define REG_IND_DATA_7			0x7C
+#define REG_IND_DATA_6			0x7D
+#define REG_IND_DATA_5			0x7E
+#define REG_IND_DATA_4			0x7F
+#define REG_IND_DATA_3			0x80
+#define REG_IND_DATA_2			0x81
+#define REG_IND_DATA_1			0x82
+#define REG_IND_DATA_0			0x83
+
+#define REG_IND_DATA_CHECK		REG_IND_DATA_8
+#define REG_IND_MIB_CHECK		REG_IND_DATA_3
+#define REG_IND_DATA_HI			REG_IND_DATA_7
+#define REG_IND_DATA_LO			REG_IND_DATA_3
+
+#define REG_PORT_0_MAC_ADDR_0		0x8E
+#define REG_PORT_0_MAC_ADDR_1		0x8F
+#define REG_PORT_0_MAC_ADDR_2		0x90
+#define REG_PORT_0_MAC_ADDR_3		0x91
+#define REG_PORT_0_MAC_ADDR_4		0x92
+#define REG_PORT_0_MAC_ADDR_5		0x93
+#define REG_PORT_1_MAC_ADDR_0		0x94
+#define REG_PORT_1_MAC_ADDR_1		0x95
+#define REG_PORT_1_MAC_ADDR_2		0x96
+#define REG_PORT_1_MAC_ADDR_3		0x97
+#define REG_PORT_1_MAC_ADDR_4		0x98
+#define REG_PORT_1_MAC_ADDR_5		0x99
+
+#define REG_PORT_1_OUT_RATE_0		0x9A
+#define REG_PORT_2_OUT_RATE_0		0x9E
+#define REG_PORT_3_OUT_RATE_0		0xA2
+
+#define SWITCH_OUT_RATE_ENABLE		BIT(7)
+
+#define REG_PORT_1_OUT_RATE_1		0x9B
+#define REG_PORT_2_OUT_RATE_1		0x9F
+#define REG_PORT_3_OUT_RATE_1		0xA3
+#define REG_PORT_1_OUT_RATE_2		0x9C
+#define REG_PORT_2_OUT_RATE_2		0xA0
+#define REG_PORT_3_OUT_RATE_2		0xA4
+#define REG_PORT_1_OUT_RATE_3		0x9D
+#define REG_PORT_2_OUT_RATE_3		0xA1
+#define REG_PORT_3_OUT_RATE_3		0xA5
+
+#define REG_PORT_OUT_RATE_0		0x00
+#define REG_PORT_OUT_RATE_1		0x01
+#define REG_PORT_OUT_RATE_2		0x02
+#define REG_PORT_OUT_RATE_3		0x03
+
+#define REG_MODE_INDICATOR		0xA6
+
+#define MODE_2_MII			BIT(7)
+#define MODE_2_PHY			BIT(6)
+#define PORT_1_RMII			BIT(5)
+#define PORT_3_RMII			BIT(4)
+#define PORT_1_MAC_MII			BIT(3)
+#define PORT_3_MAC_MII			BIT(2)
+#define PORT_1_FIBER			BIT(1)
+#define PORT_2_FIBER			BIT(0)
+
+#define MODE_MLL			0x03
+#define MODE_RLL			0x13
+#define MODE_FLL			0x01
+
+#define REG_BUF_RESERVED_Q3		0xA7
+#define REG_BUF_RESERVED_Q2		0xA8
+#define REG_BUF_RESERVED_Q1		0xA9
+#define REG_BUF_RESERVED_Q0		0xAA
+#define REG_PM_FLOW_CTRL_SELECT_1	0xAB
+#define REG_PM_FLOW_CTRL_SELECT_2	0xAC
+#define REG_PM_FLOW_CTRL_SELECT_3	0xAD
+#define REG_PM_FLOW_CTRL_SELECT_4	0xAE
+
+#define REG_PORT1_TXQ3_RATE_CTRL	0xAF
+#define REG_PORT1_TXQ2_RATE_CTRL	0xB0
+#define REG_PORT1_TXQ1_RATE_CTRL	0xB1
+#define REG_PORT1_TXQ0_RATE_CTRL	0xB2
+#define REG_PORT2_TXQ3_RATE_CTRL	0xB3
+#define REG_PORT2_TXQ2_RATE_CTRL	0xB4
+#define REG_PORT2_TXQ1_RATE_CTRL	0xB5
+#define REG_PORT2_TXQ0_RATE_CTRL	0xB6
+#define REG_PORT3_TXQ3_RATE_CTRL	0xB7
+#define REG_PORT3_TXQ2_RATE_CTRL	0xB8
+#define REG_PORT3_TXQ1_RATE_CTRL	0xB9
+#define REG_PORT3_TXQ0_RATE_CTRL	0xBA
+
+#define RATE_CTRL_ENABLE		BIT(7)
+
+#define REG_INT_ENABLE			0xBB
+
+#define REG_INT_STATUS			0xBC
+
+#define INT_PORT_1_2_LINK_CHANGE	BIT(7)
+#define INT_PORT_3_LINK_CHANGE		BIT(2)
+#define INT_PORT_2_LINK_CHANGE		BIT(1)
+#define INT_PORT_1_LINK_CHANGE		BIT(0)
+
+#define REG_PAUSE_ITERATION_LIMIT	0xBD
+
+#define REG_INSERT_SRC_PVID		0xC2
+
+#define SWITCH_INS_TAG_1_PORT_2		BIT(5)
+#define SWITCH_INS_TAG_1_PORT_3		BIT(4)
+#define SWITCH_INS_TAG_2_PORT_1		BIT(3)
+#define SWITCH_INS_TAG_2_PORT_3		BIT(2)
+#define SWITCH_INS_TAG_3_PORT_1		BIT(1)
+#define SWITCH_INS_TAG_3_PORT_2		BIT(0)
+
+#define REG_POWER_MANAGEMENT		0xC3
+
+#define SWITCH_CPU_CLK_POWER_DOWN	BIT(7)
+#define SWITCH_CLK_POWER_DOWN		BIT(6)
+#define SWITCH_LED_SELECTION		0x30
+#define SWITCH_LED_LINK_ACT_SPEED	0x00
+#define SWITCH_LED_LINK_ACT		0x20
+#define SWITCH_LED_LINK_ACT_DUPLEX	0x10
+#define SWITCH_LED_LINK_DUPLEX		0x30
+#define SWITCH_LED_OUTPUT_MODE		BIT(3)
+#define SWITCH_PLL_POWER_DOWN		BIT(2)
+#define SWITCH_POWER_MANAGEMENT_MODE	0x03
+#define SWITCH_NORMAL			0x00
+#define SWITCH_ENERGY_DETECTION		0x01
+#define SWITCH_SOFTWARE_POWER_DOWN	0x02
+#define SWITCH_POWER_SAVING		0x03
+
+#define REG_FORWARD_INVALID_VID		0xC6
+
+#define SWITCH_FORWARD_INVALID_PORTS	0x70
+#define FORWARD_INVALID_PORT_SHIFT	4
+#define PORT_3_RMII_CLOCK_SELECTION	BIT(3)
+#define PORT_1_RMII_CLOCK_SELECTION	BIT(2)
+#define SWITCH_HOST_INTERFACE_MODE	0x03
+#define SWITCH_I2C_MASTER		0x00
+#define SWITCH_I2C_SLAVE		0x01
+#define SWITCH_SPI_SLAVE		0x02
+#define SWITCH_SMII			0x03
+
+#define KSZ8863_ID_HI			0x0022
+#define KSZ8863_ID_LO			0x1430
+
+#define PHY_REG_LINK_MD			29
+
+#define PHY_START_CABLE_DIAG		BIT(15)
+#define PHY_CABLE_DIAG_RESULT		0x6000
+#define PHY_CABLE_STAT_NORMAL		0x0000
+#define PHY_CABLE_STAT_OPEN		0x2000
+#define PHY_CABLE_STAT_SHORT		0x4000
+#define PHY_CABLE_STAT_FAILED		0x6000
+#define PHY_CABLE_10M_SHORT		BIT(12)
+#define PHY_CABLE_FAULT_COUNTER		0x01FF
+
+#define PHY_REG_PHY_CTRL		30
+
+#define PHY_STAT_REVERSED_POLARITY	BIT(5)
+#define PHY_STAT_MDIX			BIT(4)
+#define PHY_FORCE_LINK			BIT(3)
+#define PHY_POWER_SAVING_DISABLE	BIT(2)
+#define PHY_REMOTE_LOOPBACK		BIT(1)
+
+/* Default values are used in ksz_sw.h if these are not defined. */
+#define PRIO_QUEUES			4
+
+#define KS_PRIO_IN_REG			4
+
+#define TOTAL_PORT_NUM			3
+
+/* Host port can only be last of them. */
+#define SWITCH_PORT_NUM			(TOTAL_PORT_NUM - 1)
+
+#define KSZ8863_COUNTER_NUM		0x20
+#define TOTAL_KSZ8863_COUNTER_NUM	(KSZ8863_COUNTER_NUM + 2)
+
+#define SWITCH_COUNTER_NUM		KSZ8863_COUNTER_NUM
+#define TOTAL_SWITCH_COUNTER_NUM	TOTAL_KSZ8863_COUNTER_NUM
+
+#define P_802_1P_CTRL			REG_PORT_CTRL_2
+#define P_LOCAL_CTRL			REG_PORT_CTRL_5
+#define P_REMOTE_STATUS			REG_PORT_STATUS_1
+#define P_INS_SRC_PVID_CTRL		REG_PORT_CTRL_8
+#define P_DROP_TAG_CTRL			REG_PORT_CTRL_9
+
+#define S_HUGE_PACKET_CTRL		REG_SW_CTRL_2
+#define S_PASS_PAUSE_CTRL		REG_SW_CTRL_10
+#define S_IPV6_MLD_CTRL			REG_SW_CTRL_21
+
+#define P_BCAST_STORM_CTRL		REG_PORT_CTRL_0
+#define P_PRIO_CTRL			REG_PORT_CTRL_0
+#define P_TAG_CTRL			REG_PORT_CTRL_0
+#define P_MIRROR_CTRL			REG_PORT_CTRL_1
+#define P_STP_CTRL			REG_PORT_CTRL_2
+#define P_PHY_CTRL			REG_PORT_CTRL_12
+#define P_FORCE_CTRL			REG_PORT_CTRL_12
+#define P_NEG_RESTART_CTRL		REG_PORT_CTRL_13
+#define P_LINK_STATUS			REG_PORT_STATUS_0
+#define P_SPEED_STATUS			REG_PORT_STATUS_1
+#define P_RATE_LIMIT_CTRL		REG_PORT_CTRL_5
+#define P_SA_MAC_CTRL			REG_PORT_CTRL_5
+#define P_4_QUEUE_CTRL			REG_PORT_CTRL_0
+#define P_2_QUEUE_CTRL			REG_PORT_CTRL_2
+
+#define S_LINK_AGING_CTRL		REG_SWITCH_CTRL_0
+#define S_MIRROR_CTRL			REG_SWITCH_CTRL_3
+#define S_REPLACE_VID_CTRL		REG_SWITCH_CTRL_4
+#define S_802_1P_PRIO_CTRL		REG_SWITCH_CTRL_10
+#define S_UNKNOWN_DA_CTRL		REG_SWITCH_CTRL_12
+#define S_TOS_PRIO_CTRL			REG_TOS_PRIO_CTRL_0
+#define S_FLUSH_TABLE_CTRL		REG_SWITCH_CTRL_0
+#define S_TAIL_TAG_CTRL			REG_SWITCH_CTRL_1
+#define S_FORWARD_INVALID_VID_CTRL	REG_FORWARD_INVALID_VID
+#define S_INS_SRC_PVID_CTRL		REG_INSERT_SRC_PVID
+
+#define IND_ACC_TABLE(table)		((table) << 8)
+
+/* Driver set switch broadcast storm protection at 10% rate. */
+#define BROADCAST_STORM_PROT_RATE	10
+
+/* 148,800 frames * 67 ms / 100 */
+#define BROADCAST_STORM_VALUE		9969
+
+#define STATIC_MAC_TABLE_ADDR		0x0000FFFF
+#define STATIC_MAC_TABLE_FWD_PORTS	0x001F0000
+#define STATIC_MAC_TABLE_VALID		0x00200000
+#define STATIC_MAC_TABLE_OVERRIDE	0x00400000
+#define STATIC_MAC_TABLE_USE_FID	0x00800000
+#define STATIC_MAC_TABLE_FID		0x7F000000
+
+#define STATIC_MAC_FWD_PORTS_S		16
+#define STATIC_MAC_FID_S		24
+
+#define VLAN_TABLE_FID			0x007F
+#define VLAN_TABLE_MEMBERSHIP		0x0F80
+#define VLAN_TABLE_VALID		0x1000
+
+#define VLAN_TABLE_MEMBERSHIP_S		7
+#define VLAN_TABLE_S			13
+#define VLAN_TABLE_M			(BIT(VLAN_TABLE_S) - 1)
+
+#define DYNAMIC_MAC_TABLE_ADDR		0x0000FFFF
+#define DYNAMIC_MAC_TABLE_FID		0x007F0000
+#define DYNAMIC_MAC_TABLE_SRC_PORT	0x07000000
+#define DYNAMIC_MAC_TABLE_TIMESTAMP	0x18000000
+#define DYNAMIC_MAC_TABLE_ENTRIES	0xE0000000
+
+#define DYNAMIC_MAC_TABLE_NOT_READY	0x80
+
+#define DYNAMIC_MAC_TABLE_ENTRIES_H	0x7F
+#define DYNAMIC_MAC_TABLE_MAC_EMPTY	0x80
+
+#define DYNAMIC_MAC_FID_S		16
+#define DYNAMIC_MAC_SRC_PORT_S		24
+#define DYNAMIC_MAC_TIMESTAMP_S		27
+#define DYNAMIC_MAC_ENTRIES_S		29
+#define DYNAMIC_MAC_ENTRIES_H_S		3
+
+#define MIB_COUNTER_OVERFLOW		BIT(7)
+#define MIB_COUNTER_VALID		BIT(6)
+
+#define MIB_COUNTER_VALUE		0x3FFFFFFF
+
+#define KS_MIB_PACKET_DROPPED_TX_0	0x100
+#define KS_MIB_PACKET_DROPPED_TX_1	0x101
+#define KS_MIB_PACKET_DROPPED_TX_2	0x102
+#define KS_MIB_PACKET_DROPPED_TX_3	0x103
+#define KS_MIB_PACKET_DROPPED_TX_4	0x104
+#define KS_MIB_PACKET_DROPPED_RX_0	0x105
+#define KS_MIB_PACKET_DROPPED_RX_1	0x106
+#define KS_MIB_PACKET_DROPPED_RX_2	0x107
+#define KS_MIB_PACKET_DROPPED_RX_3	0x108
+#define KS_MIB_PACKET_DROPPED_RX_4	0x109
+
+#define MIB_PACKET_DROPPED		0x0000FFFF
+
+#define TAIL_TAG_OVERRIDE		BIT(6)
+#define TAIL_TAG_LOOKUP			BIT(7)
+
+#define VLAN_TABLE_ENTRIES		(16 / 2)
+#define FID_ENTRIES			16
+
+#endif
diff --git a/drivers/net/dsa/microchip/ksz8863_smi.c b/drivers/net/dsa/microchip/ksz8863_smi.c
new file mode 100644
index 0000000000000..742955c85d859
--- /dev/null
+++ b/drivers/net/dsa/microchip/ksz8863_smi.c
@@ -0,0 +1,166 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Microchip KSZ8863 series register access through SMI
+ *
+ * Copyright (C) 2019 Pengutronix, Michael Grzeschik <kernel@pengutronix.de>
+ */
+
+#include "ksz_common.h"
+
+static int ksz8863_mdio_read(void *ctx, const void *reg_buf, size_t reg_len,
+			     void *val_buf, size_t val_len)
+{
+	struct ksz_device *dev = (struct ksz_device *)ctx;
+	struct mdio_device *mdev = (struct mdio_device *)dev->priv;
+	u8 reg = *(u8 *)reg_buf;
+	u8 *val = val_buf;
+	int ret;
+	int i;
+
+	for (i = 0; i < val_len; i++) {
+		ret = mdiobus_read(mdev->bus, 0, (reg + i) |
+				   MII_ADDR_SMI_KSZ88X3);
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
+	struct mdio_device *mdev = (struct mdio_device *)dev->priv;
+	u32 reg = *(u32 *)data;
+	u8 *val = (u8 *)(data + 4);
+	int ret;
+	int i;
+
+	for (i = 0; i < (count - 4); i++) {
+		ret = mdiobus_write(mdev->bus, 0, (reg + i) |
+				    MII_ADDR_SMI_KSZ88X3, val[i]);
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
+	struct ksz_device *dev;
+	int ret;
+	int i;
+
+	dev = ksz_switch_alloc(&mdiodev->dev, mdiodev);
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
index a20ebb749377c..dd2bd645a3125 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -151,6 +151,7 @@ int ksz_switch_register(struct ksz_device *dev,
 void ksz_switch_remove(struct ksz_device *dev);
 
 int ksz8795_switch_register(struct ksz_device *dev);
+int ksz8863_switch_register(struct ksz_device *dev);
 int ksz9477_switch_register(struct ksz_device *dev);
 
 void ksz_update_port_member(struct ksz_device *dev, int port);
-- 
2.24.0.rc1

