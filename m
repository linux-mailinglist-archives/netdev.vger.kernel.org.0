Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00E741FEB91
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 08:40:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727956AbgFRGkx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 02:40:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727945AbgFRGkv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 02:40:51 -0400
Received: from Galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BFAEC06174E;
        Wed, 17 Jun 2020 23:40:50 -0700 (PDT)
Received: from p5b06d650.dip0.t-ipconnect.de ([91.6.214.80] helo=localhost.localdomain)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA1:256)
        (Exim 4.80)
        (envelope-from <kurt@linutronix.de>)
        id 1jloE1-0000xD-TM; Thu, 18 Jun 2020 08:40:38 +0200
From:   Kurt Kanzenbach <kurt@linutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        ilias.apalodimas@linaro.org, Kurt Kanzenbach <kurt@linutronix.de>
Subject: [RFC PATCH 2/9] net: dsa: Add DSA driver for Hirschmann Hellcreek switches
Date:   Thu, 18 Jun 2020 08:40:22 +0200
Message-Id: <20200618064029.32168-3-kurt@linutronix.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200618064029.32168-1-kurt@linutronix.de>
References: <20200618064029.32168-1-kurt@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a basic DSA driver for Hirschmann Hellcreek switches. Those switches are
implementing features needed for Time Sensitive Networking (TSN) such as support
for the Time Precision Protocol and various shapers like the Time Aware Shaper.

This driver includes basic support for networking:

 * VLAN handling
 * FDB handling
 * Port statistics
 * STP

Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
---
 drivers/net/dsa/Kconfig                |    2 +
 drivers/net/dsa/Makefile               |    1 +
 drivers/net/dsa/hirschmann/Kconfig     |    7 +
 drivers/net/dsa/hirschmann/Makefile    |    2 +
 drivers/net/dsa/hirschmann/hellcreek.c | 1173 ++++++++++++++++++++++++
 drivers/net/dsa/hirschmann/hellcreek.h |  244 +++++
 6 files changed, 1429 insertions(+)
 create mode 100644 drivers/net/dsa/hirschmann/Kconfig
 create mode 100644 drivers/net/dsa/hirschmann/Makefile
 create mode 100644 drivers/net/dsa/hirschmann/hellcreek.c
 create mode 100644 drivers/net/dsa/hirschmann/hellcreek.h

diff --git a/drivers/net/dsa/Kconfig b/drivers/net/dsa/Kconfig
index d0024cb30a7b..d52195e7115b 100644
--- a/drivers/net/dsa/Kconfig
+++ b/drivers/net/dsa/Kconfig
@@ -58,6 +58,8 @@ source "drivers/net/dsa/qca/Kconfig"
 
 source "drivers/net/dsa/sja1105/Kconfig"
 
+source "drivers/net/dsa/hirschmann/Kconfig"
+
 config NET_DSA_QCA8K
 	tristate "Qualcomm Atheros QCA8K Ethernet switch family support"
 	depends on NET_DSA
diff --git a/drivers/net/dsa/Makefile b/drivers/net/dsa/Makefile
index 4a943ccc2ca4..a707ccc3a940 100644
--- a/drivers/net/dsa/Makefile
+++ b/drivers/net/dsa/Makefile
@@ -23,3 +23,4 @@ obj-y				+= mv88e6xxx/
 obj-y				+= ocelot/
 obj-y				+= qca/
 obj-y				+= sja1105/
+obj-y				+= hirschmann/
diff --git a/drivers/net/dsa/hirschmann/Kconfig b/drivers/net/dsa/hirschmann/Kconfig
new file mode 100644
index 000000000000..714414d8f50f
--- /dev/null
+++ b/drivers/net/dsa/hirschmann/Kconfig
@@ -0,0 +1,7 @@
+# SPDX-License-Identifier: GPL-2.0
+config NET_DSA_HIRSCHMANN_HELLCREEK
+	tristate "Hirschmann Hellcreek TSN Switch support"
+	depends on NET_DSA
+	select NET_DSA_TAG_HELLCREEK
+	help
+	  This driver adds support for Hirschmann Hellcreek TSN switches.
diff --git a/drivers/net/dsa/hirschmann/Makefile b/drivers/net/dsa/hirschmann/Makefile
new file mode 100644
index 000000000000..0e12e149e40f
--- /dev/null
+++ b/drivers/net/dsa/hirschmann/Makefile
@@ -0,0 +1,2 @@
+# SPDX-License-Identifier: GPL-2.0
+obj-$(CONFIG_NET_DSA_HIRSCHMANN_HELLCREEK)	+= hellcreek.o
diff --git a/drivers/net/dsa/hirschmann/hellcreek.c b/drivers/net/dsa/hirschmann/hellcreek.c
new file mode 100644
index 000000000000..c5ba52f1ebc8
--- /dev/null
+++ b/drivers/net/dsa/hirschmann/hellcreek.c
@@ -0,0 +1,1173 @@
+// SPDX-License-Identifier: (GPL-2.0 or MIT)
+/*
+ * DSA driver for:
+ * Hirschmann Hellcreek TSN switch.
+ *
+ * Copyright (C) 2019,2020 Linutronix GmbH
+ * Author Kurt Kanzenbach <kurt@linutronix.de>
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/device.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
+#include <linux/of_mdio.h>
+#include <linux/platform_device.h>
+#include <linux/bitops.h>
+#include <linux/if_bridge.h>
+#include <linux/etherdevice.h>
+#include <linux/random.h>
+#include <linux/iopoll.h>
+#include <linux/spinlock.h>
+#include <linux/delay.h>
+#include <linux/ktime.h>
+#include <net/dsa.h>
+
+#include "hellcreek.h"
+
+static const struct hellcreek_counter hellcreek_counter[] = {
+	{ 0x00, "RxFiltered", },
+	{ 0x01, "RxOctets1k", },
+	{ 0x02, "RxVTAG", },
+	{ 0x03, "RxL2BAD", },
+	{ 0x04, "RxOverloadDrop", },
+	{ 0x05, "RxUC", },
+	{ 0x06, "RxMC", },
+	{ 0x07, "RxBC", },
+	{ 0x08, "RxRS<64", },
+	{ 0x09, "RxRS64", },
+	{ 0x0a, "RxRS65_127", },
+	{ 0x0b, "RxRS128_255", },
+	{ 0x0c, "RxRS256_511", },
+	{ 0x0d, "RxRS512_1023", },
+	{ 0x0e, "RxRS1024_1518", },
+	{ 0x0f, "RxRS>1518", },
+	{ 0x10, "TxTailDropQueue0", },
+	{ 0x11, "TxTailDropQueue1", },
+	{ 0x12, "TxTailDropQueue2", },
+	{ 0x13, "TxTailDropQueue3", },
+	{ 0x14, "TxTailDropQueue4", },
+	{ 0x15, "TxTailDropQueue5", },
+	{ 0x16, "TxTailDropQueue6", },
+	{ 0x17, "TxTailDropQueue7", },
+	{ 0x18, "RxTrafficClass0", },
+	{ 0x19, "RxTrafficClass1", },
+	{ 0x1a, "RxTrafficClass2", },
+	{ 0x1b, "RxTrafficClass3", },
+	{ 0x1c, "RxTrafficClass4", },
+	{ 0x1d, "RxTrafficClass5", },
+	{ 0x1e, "RxTrafficClass6", },
+	{ 0x1f, "RxTrafficClass7", },
+	{ 0x21, "TxOctets1k", },
+	{ 0x22, "TxVTAG", },
+	{ 0x23, "TxL2BAD", },
+	{ 0x25, "TxUC", },
+	{ 0x26, "TxMC", },
+	{ 0x27, "TxBC", },
+	{ 0x28, "TxTS<64", },
+	{ 0x29, "TxTS64", },
+	{ 0x2a, "TxTS65_127", },
+	{ 0x2b, "TxTS128_255", },
+	{ 0x2c, "TxTS256_511", },
+	{ 0x2d, "TxTS512_1023", },
+	{ 0x2e, "TxTS1024_1518", },
+	{ 0x2f, "TxTS>1518", },
+	{ 0x30, "TxTrafficClassOverrun0", },
+	{ 0x31, "TxTrafficClassOverrun1", },
+	{ 0x32, "TxTrafficClassOverrun2", },
+	{ 0x33, "TxTrafficClassOverrun3", },
+	{ 0x34, "TxTrafficClassOverrun4", },
+	{ 0x35, "TxTrafficClassOverrun5", },
+	{ 0x36, "TxTrafficClassOverrun6", },
+	{ 0x37, "TxTrafficClassOverrun7", },
+	{ 0x38, "TxTrafficClass0", },
+	{ 0x39, "TxTrafficClass1", },
+	{ 0x3a, "TxTrafficClass2", },
+	{ 0x3b, "TxTrafficClass3", },
+	{ 0x3c, "TxTrafficClass4", },
+	{ 0x3d, "TxTrafficClass5", },
+	{ 0x3e, "TxTrafficClass6", },
+	{ 0x3f, "TxTrafficClass7", },
+};
+
+static u16 hellcreek_read(struct hellcreek *hellcreek, unsigned int offset)
+{
+	return readw(hellcreek->base + offset);
+}
+
+static u16 hellcreek_read_ctrl(struct hellcreek *hellcreek)
+{
+	return readw(hellcreek->base + HR_CTRL_C);
+}
+
+static u16 hellcreek_read_stat(struct hellcreek *hellcreek)
+{
+	return readw(hellcreek->base + HR_SWSTAT);
+}
+
+static void hellcreek_write(struct hellcreek *hellcreek, u16 data,
+			    unsigned int offset)
+{
+	writew(data, hellcreek->base + offset);
+}
+
+static void __hellcreek_select_port(struct hellcreek *hellcreek, int port)
+{
+	u16 val = 0;
+
+	val |= port << HR_PSEL_PTWSEL_SHIFT;
+
+	hellcreek_write(hellcreek, val, HR_PSEL);
+}
+
+static void __hellcreek_select_prio(struct hellcreek *hellcreek, int prio)
+{
+	u16 val = 0;
+
+	val |= prio << HR_PSEL_PRTCWSEL_SHIFT;
+
+	hellcreek_write(hellcreek, val, HR_PSEL);
+}
+
+static void __hellcreek_select_counter(struct hellcreek *hellcreek, int counter)
+{
+	u16 val = 0;
+
+	val |= counter << HR_CSEL_SHIFT;
+
+	hellcreek_write(hellcreek, val, HR_CSEL);
+
+	/* Data sheet states to wait at least 20 internal clock cycles */
+	ndelay(200);
+}
+
+static void __hellcreek_select_vlan(struct hellcreek *hellcreek, int vid,
+				    bool pvid)
+{
+	u16 val = 0;
+
+	/* Set pvid bit first */
+	if (pvid)
+		val |= HR_VIDCFG_PVID;
+	hellcreek_write(hellcreek, val, HR_VIDCFG);
+
+	/* Set vlan */
+	val |= vid << HR_VIDCFG_VID_SHIFT;
+	hellcreek_write(hellcreek, val, HR_VIDCFG);
+}
+
+static int hellcreek_wait_until_ready(struct hellcreek *hellcreek)
+{
+	u16 val;
+
+	/* Wait up to 1ms, although 3 us should be enough */
+	return readx_poll_timeout(hellcreek_read_ctrl, hellcreek,
+				  val, val & HR_CTRL_C_READY,
+				  3, 1000);
+}
+
+static int hellcreek_wait_until_transitioned(struct hellcreek *hellcreek)
+{
+	u16 val;
+
+	return readx_poll_timeout_atomic(hellcreek_read_ctrl, hellcreek,
+					 val, !(val & HR_CTRL_C_TRANSITION),
+					 1, 1000);
+}
+
+static int hellcreek_wait_fdb_ready(struct hellcreek *hellcreek)
+{
+	u16 val;
+
+	return readx_poll_timeout_atomic(hellcreek_read_stat, hellcreek,
+					 val, !(val & HR_SWSTAT_BUSY),
+					 1, 1000);
+}
+
+static int hellcreek_detect(struct hellcreek *hellcreek)
+{
+	u8 tgd_maj, tgd_min;
+	u16 id, rel_low, rel_high, date_low, date_high, tgd_ver;
+	u32 rel, date;
+
+	id	  = hellcreek_read(hellcreek, HR_MODID_C);
+	rel_low	  = hellcreek_read(hellcreek, HR_REL_L_C);
+	rel_high  = hellcreek_read(hellcreek, HR_REL_H_C);
+	date_low  = hellcreek_read(hellcreek, HR_BLD_L_C);
+	date_high = hellcreek_read(hellcreek, HR_BLD_H_C);
+	tgd_ver   = hellcreek_read(hellcreek, TR_TGDVER);
+
+	if (id != HELLCREEK_MODULE_ID)
+		return -ENODEV;
+
+	rel	= rel_low | (rel_high << 16);
+	date	= date_low | (date_high << 16);
+	tgd_maj = (tgd_ver & TR_TGDVER_REV_MAJ_MASK) >> TR_TGDVER_REV_MAJ_SHIFT;
+	tgd_min = (tgd_ver & TR_TGDVER_REV_MIN_MASK) >> TR_TGDVER_REV_MIN_SHIFT;
+
+	dev_info(hellcreek->dev, "Module ID=%02x Release=%04x Date=%04x TGD Version=%02x.%02x\n",
+		 id, rel, date, tgd_maj, tgd_min);
+
+	return 0;
+}
+
+static void hellcreek_feature_detect(struct hellcreek *hellcreek)
+{
+	u16 features;
+
+	features = hellcreek_read(hellcreek, HR_FEABITS0);
+
+	/* Currently we only detect the size of the FDB table */
+	hellcreek->fdb_entries = ((features & HR_FEABITS0_FDBBINS_MASK) >>
+			       HR_FEABITS0_FDBBINS_SHIFT) * 32;
+
+	dev_info(hellcreek->dev, "Feature detect: FDB entries=%zu\n",
+		 hellcreek->fdb_entries);
+}
+
+static enum dsa_tag_protocol hellcreek_get_tag_protocol(struct dsa_switch *ds,
+							int port,
+							enum dsa_tag_protocol mp)
+{
+	return DSA_TAG_PROTO_HELLCREEK;
+}
+
+static int hellcreek_port_enable(struct dsa_switch *ds, int port,
+				 struct phy_device *phy)
+{
+	struct hellcreek *hellcreek = ds->priv;
+	struct hellcreek_port *hellcreek_port = &hellcreek->ports[port];
+	unsigned long flags;
+	u16 val;
+
+	if (port >= NUM_PORTS)
+		return -EINVAL;
+
+	dev_info(hellcreek->dev, "Enable port %d\n", port);
+
+	spin_lock_irqsave(&hellcreek->reg_lock, flags);
+
+	__hellcreek_select_port(hellcreek, port);
+	val = hellcreek_port->ptcfg;
+	val |= HR_PTCFG_ADMIN_EN;
+	hellcreek_write(hellcreek, val, HR_PTCFG);
+	hellcreek_port->ptcfg = val;
+
+	spin_unlock_irqrestore(&hellcreek->reg_lock, flags);
+
+	return 0;
+}
+
+static void hellcreek_port_disable(struct dsa_switch *ds, int port)
+{
+	struct hellcreek *hellcreek = ds->priv;
+	struct hellcreek_port *hellcreek_port = &hellcreek->ports[port];
+	unsigned long flags;
+	u16 val;
+
+	if (port >= NUM_PORTS)
+		return;
+
+	dev_info(hellcreek->dev, "Disable port %d\n", port);
+
+	spin_lock_irqsave(&hellcreek->reg_lock, flags);
+
+	__hellcreek_select_port(hellcreek, port);
+	val = hellcreek_port->ptcfg;
+	val &= ~HR_PTCFG_ADMIN_EN;
+	hellcreek_write(hellcreek, val, HR_PTCFG);
+	hellcreek_port->ptcfg = val;
+
+	spin_unlock_irqrestore(&hellcreek->reg_lock, flags);
+}
+
+static void hellcreek_get_strings(struct dsa_switch *ds, int port,
+				  u32 stringset, uint8_t *data)
+{
+	int i;
+
+	if (port >= NUM_PORTS)
+		return;
+
+	for (i = 0; i < ARRAY_SIZE(hellcreek_counter); ++i) {
+		const struct hellcreek_counter *counter = &hellcreek_counter[i];
+
+		strlcpy(data + i * ETH_GSTRING_LEN,
+			counter->name, ETH_GSTRING_LEN);
+	}
+}
+
+static int hellcreek_get_sset_count(struct dsa_switch *ds, int port, int sset)
+{
+	if (sset != ETH_SS_STATS)
+		return 0;
+
+	if (port >= NUM_PORTS)
+		return -EINVAL;
+
+	return ARRAY_SIZE(hellcreek_counter);
+}
+
+static void hellcreek_get_ethtool_stats(struct dsa_switch *ds, int port,
+					uint64_t *data)
+{
+	struct hellcreek *hellcreek = ds->priv;
+	struct hellcreek_port *hellcreek_port = &hellcreek->ports[port];
+	unsigned long flags;
+	int i;
+
+	if (port >= NUM_PORTS)
+		return;
+
+	spin_lock_irqsave(&hellcreek->reg_lock, flags);
+	for (i = 0; i < ARRAY_SIZE(hellcreek_counter); ++i) {
+		const struct hellcreek_counter *counter = &hellcreek_counter[i];
+		u8 offset = counter->offset + port * 64;
+		u16 high, low;
+		u64 value = 0;
+
+		__hellcreek_select_counter(hellcreek, offset);
+
+		high  = hellcreek_read(hellcreek, HR_CRDH);
+		low   = hellcreek_read(hellcreek, HR_CRDL);
+		value = (high << 16) | low;
+
+		hellcreek_port->counter_values[i] += value;
+		data[i] = hellcreek_port->counter_values[i];
+	}
+	spin_unlock_irqrestore(&hellcreek->reg_lock, flags);
+}
+
+static int hellcreek_vlan_prepare(struct dsa_switch *ds, int port,
+				  const struct switchdev_obj_port_vlan *vlan)
+{
+	struct hellcreek *hellcreek = ds->priv;
+
+	/* Nothing todo */
+	dev_info(hellcreek->dev, "VLAN prepare for port %d\n", port);
+
+	return 0;
+}
+
+static void hellcreek_select_vlan_params(struct hellcreek *hellcreek, int port,
+					 int *shift, int *mask)
+{
+	switch (port) {
+	case 0:
+		*shift = HR_VIDMBRCFG_P0MBR_SHIFT;
+		*mask  = HR_VIDMBRCFG_P0MBR_MASK;
+		break;
+	case 1:
+		*shift = HR_VIDMBRCFG_P1MBR_SHIFT;
+		*mask  = HR_VIDMBRCFG_P1MBR_MASK;
+		break;
+	case 2:
+		*shift = HR_VIDMBRCFG_P2MBR_SHIFT;
+		*mask  = HR_VIDMBRCFG_P2MBR_MASK;
+		break;
+	case 3:
+		*shift = HR_VIDMBRCFG_P3MBR_SHIFT;
+		*mask  = HR_VIDMBRCFG_P3MBR_MASK;
+		break;
+	default:
+		*shift = *mask = 0;
+		dev_err(hellcreek->dev, "Unknown port %d selected!\n", port);
+	}
+}
+
+static void hellcreek_vlan_add(struct dsa_switch *ds, int port,
+			       const struct switchdev_obj_port_vlan *vlan)
+{
+	struct hellcreek *hellcreek = ds->priv;
+	bool untagged = vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
+	bool pvid = vlan->flags & BRIDGE_VLAN_INFO_PVID;
+	unsigned long flags;
+	u16 vid;
+
+	if (port >= NUM_PORTS || vlan->vid_end >= 4096)
+		return;
+
+	dev_info(hellcreek->dev, "Add VLANs (%d -- %d) on port %d, %s, %s\n",
+		 vlan->vid_begin, vlan->vid_end, port,
+		 untagged ? "untagged" : "tagged",
+		 pvid ? "PVID" : "no PVID");
+
+	spin_lock_irqsave(&hellcreek->reg_lock, flags);
+	for (vid = vlan->vid_begin; vid <= vlan->vid_end; ++vid) {
+		u16 val;
+		int shift, mask;
+
+		__hellcreek_select_port(hellcreek, port);
+		__hellcreek_select_vlan(hellcreek, vid, pvid);
+
+		/* Setup port vlan membership */
+		hellcreek_select_vlan_params(hellcreek, port, &shift, &mask);
+		val = hellcreek->vidmbrcfg[vid];
+		val &= ~mask;
+		if (untagged)
+			val |= HELLCREEK_VLAN_UNTAGGED_MEMBER << shift;
+		else
+			val |= HELLCREEK_VLAN_TAGGED_MEMBER << shift;
+
+		hellcreek_write(hellcreek, val, HR_VIDMBRCFG);
+		hellcreek->vidmbrcfg[vid] = val;
+	}
+	spin_unlock_irqrestore(&hellcreek->reg_lock, flags);
+}
+
+static int hellcreek_vlan_del(struct dsa_switch *ds, int port,
+			      const struct switchdev_obj_port_vlan *vlan)
+{
+	struct hellcreek *hellcreek = ds->priv;
+	unsigned long flags;
+	u16 vid;
+
+	if (port >= NUM_PORTS || vlan->vid_end >= 4096)
+		return -EINVAL;
+
+	dev_info(hellcreek->dev, "Remove VLANs (%d -- %d) on port %d\n",
+		 vlan->vid_begin, vlan->vid_end, port);
+
+	spin_lock_irqsave(&hellcreek->reg_lock, flags);
+	for (vid = vlan->vid_begin; vid <= vlan->vid_end; ++vid) {
+		u16 val;
+		int shift, mask;
+
+		__hellcreek_select_vlan(hellcreek, vid, 0);
+
+		/* Setup port vlan membership */
+		hellcreek_select_vlan_params(hellcreek, port, &shift, &mask);
+		val = hellcreek->vidmbrcfg[vid];
+		val &= ~mask;
+		val |= HELLCREEK_VLAN_NO_MEMBER << shift;
+
+		hellcreek_write(hellcreek, val, HR_VIDMBRCFG);
+		hellcreek->vidmbrcfg[vid] = val;
+	}
+	spin_unlock_irqrestore(&hellcreek->reg_lock, flags);
+
+	return 0;
+}
+
+static void hellcreek_port_stp_state_set(struct dsa_switch *ds, int port,
+					 u8 state)
+{
+	struct hellcreek *hellcreek = ds->priv;
+	struct hellcreek_port *hellcreek_port = &hellcreek->ports[port];
+	const char *new_state;
+	unsigned long flags;
+	u16 val;
+
+	if (port >= NUM_PORTS)
+		return;
+
+	spin_lock_irqsave(&hellcreek->reg_lock, flags);
+
+	val = hellcreek_port->ptcfg;
+
+	switch (state) {
+	case BR_STATE_DISABLED:
+		new_state = "DISABLED";
+		val |= HR_PTCFG_BLOCKED;
+		val &= ~HR_PTCFG_LEARNING_EN;
+		break;
+	case BR_STATE_BLOCKING:
+		new_state = "BLOCKING";
+		val |= HR_PTCFG_BLOCKED;
+		val &= ~HR_PTCFG_LEARNING_EN;
+		break;
+	case BR_STATE_LISTENING:
+		new_state = "LISTENING";
+		val |= HR_PTCFG_BLOCKED;
+		val &= ~HR_PTCFG_LEARNING_EN;
+		break;
+	case BR_STATE_LEARNING:
+		new_state = "LEARNING";
+		val |= HR_PTCFG_BLOCKED;
+		val |= HR_PTCFG_LEARNING_EN;
+		break;
+	case BR_STATE_FORWARDING:
+		new_state = "FORWARDING";
+		val &= ~HR_PTCFG_BLOCKED;
+		val |= HR_PTCFG_LEARNING_EN;
+		break;
+	default:
+		new_state = "UNKNOWN";
+	}
+
+	__hellcreek_select_port(hellcreek, port);
+	hellcreek_write(hellcreek, val, HR_PTCFG);
+	hellcreek_port->ptcfg = val;
+
+	spin_unlock_irqrestore(&hellcreek->reg_lock, flags);
+
+	dev_info(hellcreek->dev, "Configured STP state for port %d: %s\n",
+		 port, new_state);
+}
+
+static int hellcreek_port_bridge_join(struct dsa_switch *ds, int port,
+				      struct net_device *br)
+{
+	struct hellcreek *hellcreek = ds->priv;
+	u16 rx_vid = port;
+	int i;
+
+	if (port >= NUM_PORTS)
+		return -EINVAL;
+
+	dev_info(hellcreek->dev, "Port %d joins a bridge\n", port);
+
+	/* Configure port's vid to all other ports as egress untagged */
+	for (i = 2; i < NUM_PORTS; ++i) {
+		const struct switchdev_obj_port_vlan vlan = {
+			.vid_begin = rx_vid,
+			.vid_end = rx_vid,
+			.flags = BRIDGE_VLAN_INFO_UNTAGGED,
+		};
+
+		if (i == port)
+			continue;
+
+		hellcreek_vlan_add(ds, i, &vlan);
+	}
+
+	return 0;
+}
+
+static void hellcreek_port_bridge_leave(struct dsa_switch *ds, int port,
+					struct net_device *br)
+{
+	struct hellcreek *hellcreek = ds->priv;
+	u16 rx_vid = port;
+	int i, err;
+
+	if (port >= NUM_PORTS)
+		return;
+
+	dev_info(hellcreek->dev, "Port %d leaves a bridge\n", port);
+
+	/* Remove port's vid from all other ports */
+	for (i = 2; i < NUM_PORTS; ++i) {
+		const struct switchdev_obj_port_vlan vlan = {
+			.vid_begin = rx_vid,
+			.vid_end = rx_vid,
+		};
+
+		if (i == port)
+			continue;
+
+		err = hellcreek_vlan_del(ds, i, &vlan);
+		if (err) {
+			dev_err(hellcreek->dev, "Failed add vid %d to port %d\n",
+				rx_vid, i);
+			return;
+		}
+	}
+}
+
+static int __hellcreek_fdb_add(struct hellcreek *hellcreek,
+			       const struct hellcreek_fdb_entry *entry)
+{
+	int ret;
+	u16 meta = 0;
+
+	dev_info(hellcreek->dev, "Add static FDB entry: MAC=%pM, MASK=0x%02x, "
+		 "OBT=%d, REPRIO_EN=%d, PRIO=%d\n", entry->mac, entry->portmask,
+		 entry->is_obt, entry->reprio_en, entry->reprio_tc);
+
+	/* Add mac address */
+	hellcreek_write(hellcreek, entry->mac[1] | (entry->mac[0] << 8), HR_FDBWDH);
+	hellcreek_write(hellcreek, entry->mac[3] | (entry->mac[2] << 8), HR_FDBWDM);
+	hellcreek_write(hellcreek, entry->mac[5] | (entry->mac[4] << 8), HR_FDBWDL);
+
+	/* Meta data */
+	meta |= entry->portmask << HR_FDBWRM0_PORTMASK_SHIFT;
+	if (entry->is_obt)
+		meta |= HR_FDBWRM0_OBT;
+	if (entry->reprio_en) {
+		meta |= HR_FDBWRM0_REPRIO_EN;
+		meta |= entry->reprio_tc << HR_FDBWRM0_REPRIO_TC_SHIFT;
+	}
+	hellcreek_write(hellcreek, meta, HR_FDBWRM0);
+
+	/* Commit */
+	hellcreek_write(hellcreek, 0x00, HR_FDBWRCMD);
+
+	/* Wait until done */
+	ret = hellcreek_wait_fdb_ready(hellcreek);
+
+	return ret;
+}
+
+static int __hellcreek_fdb_del(struct hellcreek *hellcreek,
+			       const struct hellcreek_fdb_entry *entry)
+{
+	int ret;
+
+	dev_info(hellcreek->dev, "Delete FDB entry: MAC=%pM!\n", entry->mac);
+
+	/* Delete by matching idx */
+	hellcreek_write(hellcreek, entry->idx | HR_FDBWRCMD_FDBDEL, HR_FDBWRCMD);
+
+	/* Wait until done */
+	ret = hellcreek_wait_fdb_ready(hellcreek);
+
+	return ret;
+}
+
+/* Retrieve the index of a FDB entry by mac address. Currently we search through
+ * the complete table in hardware. If that's too slow, we might have to cache
+ * the complete FDB table in software.
+ */
+static int __hellcreek_fdb_get(struct hellcreek *hellcreek,
+			       const unsigned char *dest,
+			       struct hellcreek_fdb_entry *entry)
+{
+	size_t i;
+
+	/* Set read pointer to zero: The read of HR_FDBMAX (read-only register)
+	 * should reset the internal pointer. But, that doesn't work. The vendor
+	 * suggested a subsequent write as workaround. Same for HR_FDBRDH below.
+	 */
+	hellcreek_read(hellcreek, HR_FDBMAX);
+	hellcreek_write(hellcreek, 0x00, HR_FDBMAX);
+
+	/* We have to read the complete table, because the switch/driver might
+	 * enter new entries anywhere.
+	 */
+	for (i = 0; i < hellcreek->fdb_entries; ++i) {
+		unsigned char addr[ETH_ALEN];
+		u16 meta, mac;
+
+		meta	= hellcreek_read(hellcreek, HR_FDBMDRD);
+		mac	= hellcreek_read(hellcreek, HR_FDBRDL);
+		addr[5] = mac & 0xff;
+		addr[4] = (mac & 0xff00) >> 8;
+		mac	= hellcreek_read(hellcreek, HR_FDBRDM);
+		addr[3] = mac & 0xff;
+		addr[2] = (mac & 0xff00) >> 8;
+		mac	= hellcreek_read(hellcreek, HR_FDBRDH);
+		addr[1] = mac & 0xff;
+		addr[0] = (mac & 0xff00) >> 8;
+
+		/* Force next entry */
+		hellcreek_write(hellcreek, 0x00, HR_FDBRDH);
+
+		if (memcmp(addr, dest, 6))
+			continue;
+
+		/* Match found */
+		entry->idx	    = i;
+		entry->portmask	    = (meta & HR_FDBMDRD_PORTMASK_MASK) >>
+			HR_FDBMDRD_PORTMASK_SHIFT;
+		entry->age	    = (meta & HR_FDBMDRD_AGE_MASK) >>
+			HR_FDBMDRD_AGE_SHIFT;
+		entry->is_obt	    = !!(meta & HR_FDBMDRD_OBT);
+		entry->pass_blocked = !!(meta & HR_FDBMDRD_PASS_BLOCKED);
+		entry->is_static    = !!(meta & HR_FDBMDRD_STATIC);
+		entry->reprio_tc    = (meta & HR_FDBMDRD_REPRIO_TC_MASK) >>
+			HR_FDBMDRD_REPRIO_TC_SHIFT;
+		entry->reprio_en    = !!(meta & HR_FDBMDRD_REPRIO_EN);
+		memcpy(entry->mac, addr, sizeof(addr));
+
+		return 0;
+	}
+
+	return -ENOENT;
+}
+
+static int hellcreek_fdb_add(struct dsa_switch *ds, int port,
+			     const unsigned char *addr, u16 vid)
+{
+	struct hellcreek *hellcreek = ds->priv;
+	struct hellcreek_fdb_entry entry = { 0 };
+	unsigned long flags;
+	int ret;
+
+	dev_info(hellcreek->dev, "Add FDB entry for MAC=%pM\n", addr);
+
+	spin_lock_irqsave(&hellcreek->reg_lock, flags);
+
+	ret = __hellcreek_fdb_get(hellcreek, addr, &entry);
+	if (ret) {
+		/* Not found */
+		memcpy(entry.mac, addr, sizeof(entry.mac));
+		entry.portmask = BIT(port);
+
+		ret = __hellcreek_fdb_add(hellcreek, &entry);
+		if (ret) {
+			dev_err(hellcreek->dev, "Failed to add FDB entry!\n");
+			goto out;
+		}
+	} else {
+		/* Found */
+		ret = __hellcreek_fdb_del(hellcreek, &entry);
+		if (ret) {
+			dev_err(hellcreek->dev, "Failed to delete FDB entry!\n");
+			goto out;
+		}
+
+		entry.portmask |= BIT(port);
+
+		ret = __hellcreek_fdb_add(hellcreek, &entry);
+		if (ret) {
+			dev_err(hellcreek->dev, "Failed to add FDB entry!\n");
+			goto out;
+		}
+	}
+
+out:
+	spin_unlock_irqrestore(&hellcreek->reg_lock, flags);
+
+	return ret;
+}
+
+static int hellcreek_fdb_del(struct dsa_switch *ds, int port,
+			     const unsigned char *addr, u16 vid)
+{
+	struct hellcreek *hellcreek = ds->priv;
+	struct hellcreek_fdb_entry entry = { 0 };
+	unsigned long flags;
+	int ret;
+
+	dev_info(hellcreek->dev, "Delete FDB entry for MAC=%pM\n", addr);
+
+	spin_lock_irqsave(&hellcreek->reg_lock, flags);
+
+	ret = __hellcreek_fdb_get(hellcreek, addr, &entry);
+	if (ret) {
+		/* Not found */
+		dev_err(hellcreek->dev, "FDB entry for deletion not found!\n");
+	} else {
+		/* Found */
+		ret = __hellcreek_fdb_del(hellcreek, &entry);
+		if (ret) {
+			dev_err(hellcreek->dev, "Failed to delete FDB entry!\n");
+			goto out;
+		}
+
+		entry.portmask &= ~BIT(port);
+
+		if (entry.portmask != 0x00) {
+			ret = __hellcreek_fdb_add(hellcreek, &entry);
+			if (ret) {
+				dev_err(hellcreek->dev, "Failed to add FDB entry!\n");
+				goto out;
+			}
+		}
+	}
+
+out:
+	spin_unlock_irqrestore(&hellcreek->reg_lock, flags);
+
+	return ret;
+}
+
+static int hellcreek_fdb_dump(struct dsa_switch *ds, int port,
+			      dsa_fdb_dump_cb_t *cb, void *data)
+{
+	struct hellcreek *hellcreek = ds->priv;
+	unsigned long flags;
+	u16 entries;
+	size_t i;
+
+	spin_lock_irqsave(&hellcreek->reg_lock, flags);
+
+	/* Set read pointer to zero: The read of HR_FDBMAX (read-only register)
+	 * should reset the internal pointer. But, that doesn't work. The vendor
+	 * suggested a subsequent write as workaround. Same for HR_FDBRDH below.
+	 */
+	entries = hellcreek_read(hellcreek, HR_FDBMAX);
+	hellcreek_write(hellcreek, 0x00, HR_FDBMAX);
+
+	dev_info(hellcreek->dev, "FDB dump for port %d, entries=%d!\n", port, entries);
+
+	/* Read table */
+	for (i = 0; i < hellcreek->fdb_entries; ++i) {
+		struct hellcreek_fdb_entry entry = { 0 };
+		unsigned char null_addr[ETH_ALEN] = { 0 };
+		u16 meta, mac;
+
+		meta	= hellcreek_read(hellcreek, HR_FDBMDRD);
+		mac	= hellcreek_read(hellcreek, HR_FDBRDL);
+		entry.mac[5] = mac & 0xff;
+		entry.mac[4] = (mac & 0xff00) >> 8;
+		mac	= hellcreek_read(hellcreek, HR_FDBRDM);
+		entry.mac[3] = mac & 0xff;
+		entry.mac[2] = (mac & 0xff00) >> 8;
+		mac	= hellcreek_read(hellcreek, HR_FDBRDH);
+		entry.mac[1] = mac & 0xff;
+		entry.mac[0] = (mac & 0xff00) >> 8;
+
+		/* Force next entry */
+		hellcreek_write(hellcreek, 0x00, HR_FDBRDH);
+
+		/* Check valid */
+		if (!memcmp(entry.mac, null_addr, 6))
+			continue;
+
+		entry.portmask	   = (meta & HR_FDBMDRD_PORTMASK_MASK) >>
+			HR_FDBMDRD_PORTMASK_SHIFT;
+		entry.is_static    = !!(meta & HR_FDBMDRD_STATIC);
+
+		/* Check port mask */
+		if (!(entry.portmask & BIT(port)))
+			continue;
+
+		cb(entry.mac, 0, entry.is_static, data);
+	}
+
+	spin_unlock_irqrestore(&hellcreek->reg_lock, flags);
+
+	return 0;
+}
+
+/* Default setup for DSA:
+ *  VLAN 1: CPU and Port 1 egress untagged.
+ *  VLAN 2: CPU and Port 2 egress untagged.
+ */
+static int hellcreek_setup_vlan_membership(struct dsa_switch *ds, int port,
+					   bool enabled)
+{
+	int upstream = dsa_upstream_port(ds, port);
+	u16 vid = port;
+	struct switchdev_obj_port_vlan vlan = {
+		.vid_begin = vid,
+		.vid_end = vid,
+	};
+	int err = 0;
+
+	/* The CPU port is implicitly configured by
+	 * configuring the front-panel ports
+	 */
+	if (!dsa_is_user_port(ds, port))
+		return 0;
+
+	/* Apply vid to port as egress untagged and port vlan id */
+	vlan.flags = BRIDGE_VLAN_INFO_UNTAGGED | BRIDGE_VLAN_INFO_PVID;
+	if (enabled)
+		hellcreek_vlan_add(ds, port, &vlan);
+	else
+		err = hellcreek_vlan_del(ds, port, &vlan);
+	if (err) {
+		dev_err(ds->dev, "Failed to apply VID %d to port %d: %d\n",
+			vid, port, err);
+		return err;
+	}
+
+	/* Apply vid to cpu port as well */
+	vlan.flags = BRIDGE_VLAN_INFO_UNTAGGED;
+	if (enabled)
+		hellcreek_vlan_add(ds, upstream, &vlan);
+	else
+		err = hellcreek_vlan_del(ds, upstream, &vlan);
+	if (err) {
+		dev_err(ds->dev, "Failed to apply VID %d to port %d: %d\n",
+			vid, port, err);
+		return err;
+	}
+
+	return 0;
+}
+
+static void hellcreek_setup_ingressflt(struct hellcreek *hellcreek, int port,
+				       bool enable)
+{
+	struct hellcreek_port *hellcreek_port = &hellcreek->ports[port];
+	unsigned long flags;
+	u16 ptcfg;
+
+	spin_lock_irqsave(&hellcreek->reg_lock, flags);
+
+	ptcfg = hellcreek_port->ptcfg;
+
+	if (enable)
+		ptcfg |= HR_PTCFG_INGRESSFLT;
+	else
+		ptcfg &= ~HR_PTCFG_INGRESSFLT;
+
+	__hellcreek_select_port(hellcreek, port);
+	hellcreek_write(hellcreek, ptcfg, HR_PTCFG);
+	hellcreek_port->ptcfg = ptcfg;
+
+	spin_unlock_irqrestore(&hellcreek->reg_lock, flags);
+}
+
+static int hellcreek_vlan_filtering(struct dsa_switch *ds, int port,
+				    bool vlan_filtering)
+{
+	struct hellcreek *hellcreek = ds->priv;
+
+	if (port >= NUM_PORTS)
+		return -EINVAL;
+
+	dev_info(hellcreek->dev, "%s VLAN filtering on port %d\n",
+		 vlan_filtering ? "Enable" : "Disable", port);
+
+	/* Configure port to drop packages with not known vids */
+	hellcreek_setup_ingressflt(hellcreek, port, vlan_filtering);
+
+	/* Drop DSA vlan membership config. The user can now do it. */
+	hellcreek_setup_vlan_membership(ds, port, !vlan_filtering);
+
+	return 0;
+}
+
+static int hellcreek_enable_ip_core(struct hellcreek *hellcreek)
+{
+	unsigned long flags;
+	int ret;
+	u16 val;
+
+	spin_lock_irqsave(&hellcreek->reg_lock, flags);
+
+	val = hellcreek_read(hellcreek, HR_CTRL_C);
+	val |= HR_CTRL_C_ENABLE;
+	hellcreek_write(hellcreek, val, HR_CTRL_C);
+	ret = hellcreek_wait_until_transitioned(hellcreek);
+
+	spin_unlock_irqrestore(&hellcreek->reg_lock, flags);
+
+	return ret;
+}
+
+static void hellcreek_setup_cpu_and_tunnel_port(struct hellcreek *hellcreek)
+{
+	struct hellcreek_port *cpu_port = &hellcreek->ports[CPU_PORT];
+	struct hellcreek_port *tunnel_port = &hellcreek->ports[TUNNEL_PORT];
+	unsigned long flags;
+	u16 ptcfg = 0;
+
+	ptcfg |= HR_PTCFG_LEARNING_EN | HR_PTCFG_ADMIN_EN;
+
+	spin_lock_irqsave(&hellcreek->reg_lock, flags);
+
+	__hellcreek_select_port(hellcreek, CPU_PORT);
+	hellcreek_write(hellcreek, ptcfg, HR_PTCFG);
+
+	__hellcreek_select_port(hellcreek, TUNNEL_PORT);
+	hellcreek_write(hellcreek, ptcfg, HR_PTCFG);
+
+	cpu_port->ptcfg	   = ptcfg;
+	tunnel_port->ptcfg = ptcfg;
+
+	spin_unlock_irqrestore(&hellcreek->reg_lock, flags);
+}
+
+static void __hellcreek_setup_tc_identity_mapping(struct hellcreek *hellcreek)
+{
+	int i;
+
+	/* The switch has multiple egress queues per port. The queue is selected
+	 * via the PCP field in the VLAN header. The switch internally deals
+	 * with traffic classes instead of PCP values and this mapping is
+	 * configurable.
+	 *
+	 * The default mapping is (PCP - TC):
+	 *  7 - 7
+	 *  6 - 6
+	 *  5 - 5
+	 *  4 - 4
+	 *  3 - 3
+	 *  2 - 1
+	 *  1 - 0
+	 *  0 - 2
+	 *
+	 * The default should be an identity mapping. A new mapping can be
+	 * configured by the user using tc.
+	 */
+
+	for (i = 0; i < 8; ++i) {
+		__hellcreek_select_prio(hellcreek, i);
+		hellcreek_write(hellcreek,
+				i << HR_PRTCCFG_PCP_TC_MAP_SHIFT,
+				HR_PRTCCFG);
+	}
+}
+
+static void hellcreek_setup_tc_identity_mapping(struct hellcreek *hellcreek)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&hellcreek->reg_lock, flags);
+	__hellcreek_setup_tc_identity_mapping(hellcreek);
+	spin_unlock_irqrestore(&hellcreek->reg_lock, flags);
+}
+
+static int hellcreek_setup(struct dsa_switch *ds)
+{
+	struct hellcreek *hellcreek = ds->priv;
+	int ret, i;
+
+	dev_info(hellcreek->dev, "Set up the switch\n");
+
+	/* Let's go */
+	ret = hellcreek_enable_ip_core(hellcreek);
+	if (ret) {
+		dev_err(hellcreek->dev, "Failed to enable IP core!\n");
+		return ret;
+	}
+
+	/* Enable CPU/Tunnel ports */
+	hellcreek_setup_cpu_and_tunnel_port(hellcreek);
+
+	/* Switch config: Keep defaults, enable FDB aging and learning, and tag
+	 * each frame from/to cpu port for DSA tagging.  Also enable the length
+	 * aware shaping mode. This eliminates the need for Qbv guard bands.
+	 */
+	hellcreek_write(hellcreek, HR_SWCFG_FDBAGE_EN | HR_SWCFG_FDBLRN_EN |
+			HR_SWCFG_ALWAYS_OBT |
+			(HR_SWCFG_LAS_ON << HR_SWCFG_LAS_MODE_SHIFT),
+			HR_SWCFG);
+
+	/* Initial vlan membership to reflect port separation */
+	for (i = 2; i < NUM_PORTS; ++i) {
+		ret = hellcreek_setup_vlan_membership(ds, i, true);
+		if (ret) {
+			dev_err(hellcreek->dev,
+				"Failed to setup VLAN membership config!\n");
+			return ret;
+		}
+	}
+
+	/* Configure PCP <-> TC mapping */
+	hellcreek_setup_tc_identity_mapping(hellcreek);
+
+	return 0;
+}
+
+static const struct dsa_switch_ops hellcreek_ds_ops = {
+	.get_tag_protocol    = hellcreek_get_tag_protocol,
+	.setup		     = hellcreek_setup,
+	.get_strings	     = hellcreek_get_strings,
+	.get_ethtool_stats   = hellcreek_get_ethtool_stats,
+	.get_sset_count	     = hellcreek_get_sset_count,
+	.port_enable	     = hellcreek_port_enable,
+	.port_disable	     = hellcreek_port_disable,
+	.port_vlan_filtering = hellcreek_vlan_filtering,
+	.port_vlan_prepare   = hellcreek_vlan_prepare,
+	.port_vlan_add	     = hellcreek_vlan_add,
+	.port_vlan_del	     = hellcreek_vlan_del,
+	.port_fdb_dump	     = hellcreek_fdb_dump,
+	.port_fdb_add	     = hellcreek_fdb_add,
+	.port_fdb_del	     = hellcreek_fdb_del,
+	.port_bridge_join    = hellcreek_port_bridge_join,
+	.port_bridge_leave   = hellcreek_port_bridge_leave,
+	.port_stp_state_set  = hellcreek_port_stp_state_set,
+};
+
+static int hellcreek_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct hellcreek *hellcreek;
+	struct resource *res;
+	int ret, i;
+
+	hellcreek = devm_kzalloc(dev, sizeof(*hellcreek), GFP_KERNEL);
+	if (!hellcreek)
+		return -ENOMEM;
+
+	hellcreek->vidmbrcfg = devm_kcalloc(dev, 4096,
+					    sizeof(*hellcreek->vidmbrcfg),
+					    GFP_KERNEL);
+	if (!hellcreek->vidmbrcfg)
+		return -ENOMEM;
+
+	for (i = 0; i < NUM_PORTS; ++i) {
+		struct hellcreek_port *port = &hellcreek->ports[i];
+
+		port->counter_values =
+			devm_kcalloc(dev,
+				     ARRAY_SIZE(hellcreek_counter),
+				     sizeof(*port->counter_values),
+				     GFP_KERNEL);
+		if (!port->counter_values)
+			return -ENOMEM;
+
+		port->hellcreek = hellcreek;
+		port->port	= i;
+	}
+
+	spin_lock_init(&hellcreek->reg_lock);
+
+	hellcreek->dev = dev;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		dev_err(dev, "No memory region provided!\n");
+		return -ENODEV;
+	}
+
+	hellcreek->base = devm_ioremap_resource(dev, res);
+	if (IS_ERR(hellcreek->base)) {
+		dev_err(dev, "No memory available!\n");
+		return PTR_ERR(hellcreek->base);
+	}
+
+	ret = hellcreek_detect(hellcreek);
+	if (ret) {
+		dev_err(dev, "No (known) chip found!\n");
+		return ret;
+	}
+
+	ret = hellcreek_wait_until_ready(hellcreek);
+	if (ret) {
+		dev_err(dev, "Switch didn't become ready!\n");
+		return ret;
+	}
+
+	hellcreek_feature_detect(hellcreek);
+
+	hellcreek->ds = devm_kzalloc(dev, sizeof(*hellcreek->ds), GFP_KERNEL);
+	if (!hellcreek->ds)
+		return -ENOMEM;
+
+	hellcreek->ds->dev	     = dev;
+	hellcreek->ds->priv	     = hellcreek;
+	hellcreek->ds->ops	     = &hellcreek_ds_ops;
+	hellcreek->ds->num_ports     = NUM_PORTS;
+	hellcreek->ds->num_tx_queues = HELLCREEK_NUM_EGRESS_QUEUES;
+
+	ret = dsa_register_switch(hellcreek->ds);
+	if (ret) {
+		dev_err(dev, "Unable to register switch\n");
+		return ret;
+	}
+
+	platform_set_drvdata(pdev, hellcreek);
+
+	return 0;
+}
+
+static int hellcreek_remove(struct platform_device *pdev)
+{
+	struct hellcreek *hellcreek = platform_get_drvdata(pdev);
+
+	dsa_unregister_switch(hellcreek->ds);
+	platform_set_drvdata(pdev, NULL);
+
+	return 0;
+}
+
+static const struct of_device_id hellcreek_of_match[] = {
+	{
+		.compatible = "hirschmann,hellcreek",
+	},
+	{ },
+};
+MODULE_DEVICE_TABLE(of, hellcreek_of_match);
+
+static struct platform_driver hellcreek_driver = {
+	.probe	= hellcreek_probe,
+	.remove = hellcreek_remove,
+	.driver = {
+		.name = "hellcreek",
+		.of_match_table = hellcreek_of_match,
+	},
+};
+module_platform_driver(hellcreek_driver);
+
+MODULE_AUTHOR("Kurt Kanzenbach <kurt@linutronix.de>");
+MODULE_DESCRIPTION("Hirschmann Hellcreek driver");
+MODULE_LICENSE("Dual MIT/GPL");
diff --git a/drivers/net/dsa/hirschmann/hellcreek.h b/drivers/net/dsa/hirschmann/hellcreek.h
new file mode 100644
index 000000000000..a08a10cb5ab7
--- /dev/null
+++ b/drivers/net/dsa/hirschmann/hellcreek.h
@@ -0,0 +1,244 @@
+/* SPDX-License-Identifier: (GPL-2.0 or MIT) */
+/*
+ * DSA driver for:
+ * Hirschmann Hellcreek TSN switch.
+ *
+ * Copyright (C) 2019,2020 Linutronix GmbH
+ * Author Kurt Kanzenbach <kurt@linutronix.de>
+ */
+
+#ifndef _HELLCREEK_H_
+#define _HELLCREEK_H_
+
+#include <linux/bitops.h>
+#include <linux/kernel.h>
+#include <linux/device.h>
+#include <linux/ptp_clock_kernel.h>
+#include <linux/timecounter.h>
+#include <linux/spinlock.h>
+#include <net/dsa.h>
+
+/* Ports:
+ *  - 0: CPU
+ *  - 1: Tunnel
+ *  - 2: TSN front port 1
+ *  - 3: TSN front port 2
+ */
+#define CPU_PORT			0
+#define TUNNEL_PORT			1
+#define NUM_PORTS			4
+
+#define HELLCREEK_MODULE_ID		0x4c30
+#define HELLCREEK_VLAN_NO_MEMBER	0x0
+#define HELLCREEK_VLAN_UNTAGGED_MEMBER	0x1
+#define HELLCREEK_VLAN_TAGGED_MEMBER	0x3
+#define HELLCREEK_NUM_EGRESS_QUEUES	8
+
+/* Register definitions */
+#define HR_MODID_C			(0 * 2)
+#define HR_REL_L_C			(1 * 2)
+#define HR_REL_H_C			(2 * 2)
+#define HR_BLD_L_C			(3 * 2)
+#define HR_BLD_H_C			(4 * 2)
+#define HR_CTRL_C			(5 * 2)
+#define HR_CTRL_C_READY			BIT(14)
+#define HR_CTRL_C_TRANSITION		BIT(13)
+#define HR_CTRL_C_ENABLE		BIT(0)
+
+#define HR_PSEL				(0xa6 * 2)
+#define HR_PSEL_PTWSEL_SHIFT		4
+#define HR_PSEL_PTWSEL_MASK		GENMASK(5, 4)
+#define HR_PSEL_PRTCWSEL_SHIFT		0
+#define HR_PSEL_PRTCWSEL_MASK		GENMASK(2, 0)
+
+#define HR_PTCFG			(0xa7 * 2)
+#define HR_PTCFG_MLIMIT_EN		BIT(13)
+#define HR_PTCFG_UMC_FLT		BIT(10)
+#define HR_PTCFG_UUC_FLT		BIT(9)
+#define HR_PTCFG_UNTRUST		BIT(8)
+#define HR_PTCFG_TAG_REQUIRED		BIT(7)
+#define HR_PTCFG_PPRIO_SHIFT		4
+#define HR_PTCFG_PPRIO_MASK		GENMASK(6, 4)
+#define HR_PTCFG_INGRESSFLT		BIT(3)
+#define HR_PTCFG_BLOCKED		BIT(2)
+#define HR_PTCFG_LEARNING_EN		BIT(1)
+#define HR_PTCFG_ADMIN_EN		BIT(0)
+
+#define HR_PRTCCFG			(0xa8 * 2)
+#define HR_PRTCCFG_PCP_TC_MAP_SHIFT	0
+#define HR_PRTCCFG_PCP_TC_MAP_MASK	GENMASK(2, 0)
+
+#define HR_CSEL				(0x8d * 2)
+#define HR_CSEL_SHIFT			0
+#define HR_CSEL_MASK			GENMASK(7, 0)
+#define HR_CRDL				(0x8e * 2)
+#define HR_CRDH				(0x8f * 2)
+
+#define HR_SWTRC_CFG			(0x90 * 2)
+#define HR_SWTRC0			(0x91 * 2)
+#define HR_SWTRC1			(0x92 * 2)
+#define HR_PFREE			(0x93 * 2)
+#define HR_MFREE			(0x94 * 2)
+
+#define HR_FDBAGE			(0x97 * 2)
+#define HR_FDBMAX			(0x98 * 2)
+#define HR_FDBRDL			(0x99 * 2)
+#define HR_FDBRDM			(0x9a * 2)
+#define HR_FDBRDH			(0x9b * 2)
+
+#define HR_FDBMDRD			(0x9c * 2)
+#define HR_FDBMDRD_PORTMASK_SHIFT	0
+#define HR_FDBMDRD_PORTMASK_MASK	GENMASK(3, 0)
+#define HR_FDBMDRD_AGE_SHIFT		4
+#define HR_FDBMDRD_AGE_MASK		GENMASK(7, 4)
+#define HR_FDBMDRD_OBT			BIT(8)
+#define HR_FDBMDRD_PASS_BLOCKED		BIT(9)
+#define HR_FDBMDRD_STATIC		BIT(11)
+#define HR_FDBMDRD_REPRIO_TC_SHIFT	12
+#define HR_FDBMDRD_REPRIO_TC_MASK	GENMASK(14, 12)
+#define HR_FDBMDRD_REPRIO_EN		BIT(15)
+
+#define HR_FDBWDL			(0x9d * 2)
+#define HR_FDBWDM			(0x9e * 2)
+#define HR_FDBWDH			(0x9f * 2)
+#define HR_FDBWRM0			(0xa0 * 2)
+#define HR_FDBWRM0_PORTMASK_SHIFT	0
+#define HR_FDBWRM0_PORTMASK_MASK	GENMASK(3, 0)
+#define HR_FDBWRM0_OBT			BIT(8)
+#define HR_FDBWRM0_PASS_BLOCKED		BIT(9)
+#define HR_FDBWRM0_REPRIO_TC_SHIFT	12
+#define HR_FDBWRM0_REPRIO_TC_MASK	GENMASK(14, 12)
+#define HR_FDBWRM0_REPRIO_EN		BIT(15)
+#define HR_FDBWRM1			(0xa1 * 2)
+
+#define HR_FDBWRCMD			(0xa2 * 2)
+#define HR_FDBWRCMD_FDBDEL		BIT(9)
+
+#define HR_SWCFG			(0xa3 * 2)
+#define HR_SWCFG_GM_STATEMD		BIT(15)
+#define HR_SWCFG_LAS_MODE_SHIFT		12
+#define HR_SWCFG_LAS_MODE_MASK		GENMASK(13, 12)
+#define HR_SWCFG_LAS_OFF		(0x00)
+#define HR_SWCFG_LAS_ON			(0x01)
+#define HR_SWCFG_LAS_STATIC		(0x10)
+#define HR_SWCFG_CT_EN			BIT(11)
+#define HR_SWCFG_LAN_UNAWARE		BIT(10)
+#define HR_SWCFG_ALWAYS_OBT		BIT(9)
+#define HR_SWCFG_FDBAGE_EN		BIT(5)
+#define HR_SWCFG_FDBLRN_EN		BIT(4)
+
+#define HR_SWSTAT			(0xa4 * 2)
+#define HR_SWSTAT_FAIL			BIT(4)
+#define HR_SWSTAT_BUSY			BIT(0)
+
+#define HR_SWCMD			(0xa5 * 2)
+#define HW_SWCMD_FLUSH			BIT(0)
+
+#define HR_VIDCFG			(0xaa * 2)
+#define HR_VIDCFG_VID_SHIFT		0
+#define HR_VIDCFG_VID_MASK		GENMASK(11, 0)
+#define HR_VIDCFG_PVID			BIT(12)
+
+#define HR_VIDMBRCFG			(0xab * 2)
+#define HR_VIDMBRCFG_P0MBR_SHIFT	0
+#define HR_VIDMBRCFG_P0MBR_MASK		GENMASK(1, 0)
+#define HR_VIDMBRCFG_P1MBR_SHIFT	2
+#define HR_VIDMBRCFG_P1MBR_MASK		GENMASK(3, 2)
+#define HR_VIDMBRCFG_P2MBR_SHIFT	4
+#define HR_VIDMBRCFG_P2MBR_MASK		GENMASK(5, 4)
+#define HR_VIDMBRCFG_P3MBR_SHIFT	6
+#define HR_VIDMBRCFG_P3MBR_MASK		GENMASK(7, 6)
+
+#define HR_FEABITS0			(0xac * 2)
+#define HR_FEABITS0_FDBBINS_SHIFT	4
+#define HR_FEABITS0_FDBBINS_MASK	GENMASK(7, 4)
+#define HR_FEABITS0_PCNT_SHIFT		8
+#define HR_FEABITS0_PCNT_MASK		GENMASK(11, 8)
+#define HR_FEABITS0_MCNT_SHIFT		12
+#define HR_FEABITS0_MCNT_MASK		GENMASK(15, 12)
+
+#define TR_QTRACK			(0xb1 * 2)
+#define TR_TGDVER			(0xb3 * 2)
+#define TR_TGDVER_REV_MIN_MASK		GENMASK(7, 0)
+#define TR_TGDVER_REV_MIN_SHIFT		0
+#define TR_TGDVER_REV_MAJ_MASK		GENMASK(15, 8)
+#define TR_TGDVER_REV_MAJ_SHIFT		8
+#define TR_TGDSEL			(0xb4 * 2)
+#define TR_TGDSEL_TDGSEL_MASK		GENMASK(1, 0)
+#define TR_TGDSEL_TDGSEL_SHIFT		0
+#define TR_TGDCTRL			(0xb5 * 2)
+#define TR_TGDCTRL_GATE_EN		BIT(0)
+#define TR_TGDCTRL_CYC_SNAP		BIT(4)
+#define TR_TGDCTRL_SNAP_EST		BIT(5)
+#define TR_TGDCTRL_ADMINGATESTATES_MASK	GENMASK(15, 8)
+#define TR_TGDCTRL_ADMINGATESTATES_SHIFT	8
+#define TR_TGDSTAT0			(0xb6 * 2)
+#define TR_TGDSTAT1			(0xb7 * 2)
+#define TR_ESTWRL			(0xb8 * 2)
+#define TR_ESTWRH			(0xb9 * 2)
+#define TR_ESTCMD			(0xba * 2)
+#define TR_ESTCMD_ESTSEC_MASK		GENMASK(2, 0)
+#define TR_ESTCMD_ESTSEC_SHIFT		0
+#define TR_ESTCMD_ESTARM		BIT(4)
+#define TR_ESTCMD_ESTSWCFG		BIT(5)
+#define TR_EETWRL			(0xbb * 2)
+#define TR_EETWRH			(0xbc * 2)
+#define TR_EETCMD			(0xbd * 2)
+#define TR_EETCMD_EETSEC_MASK		GEMASK(2, 0)
+#define TR_EETCMD_EETSEC_SHIFT		0
+#define TR_EETCMD_EETARM		BIT(4)
+#define TR_CTWRL			(0xbe * 2)
+#define TR_CTWRH			(0xbf * 2)
+#define TR_LCNSL			(0xc1 * 2)
+#define TR_LCNSH			(0xc2 * 2)
+#define TR_LCS				(0xc3 * 2)
+#define TR_GCLDAT			(0xc4 * 2)
+#define TR_GCLDAT_GCLWRGATES_MASK	GENMASK(7, 0)
+#define TR_GCLDAT_GCLWRGATES_SHIFT	0
+#define TR_GCLDAT_GCLWRLAST		BIT(8)
+#define TR_GCLDAT_GCLOVRI		BIT(9)
+#define TR_GCLTIL			(0xc5 * 2)
+#define TR_GCLTIH			(0xc6 * 2)
+#define TR_GCLCMD			(0xc7 * 2)
+#define TR_GCLCMD_GCLWRADR_MASK		GENMASK(7, 0)
+#define TR_GCLCMD_GCLWRADR_SHIFT	0
+#define TR_GCLCMD_INIT_GATE_STATES_MASK	GENMASK(15, 8)
+#define TR_GCLCMD_INIT_GATE_STATES_SHIFT	8
+
+struct hellcreek_counter {
+	u8 offset;
+	const char *name;
+};
+
+struct hellcreek;
+
+struct hellcreek_port {
+	struct hellcreek *hellcreek;
+	int port;
+	u16 ptcfg;		/* ptcfg shadow */
+	u64 *counter_values;
+};
+
+struct hellcreek_fdb_entry {
+	size_t idx;
+	unsigned char mac[6];
+	u8 portmask;
+	u8 age;
+	u8 is_obt;
+	u8 pass_blocked;
+	u8 is_static;
+	u8 reprio_tc;
+	u8 reprio_en;
+};
+
+struct hellcreek {
+	struct device *dev;
+	struct dsa_switch *ds;
+	struct hellcreek_port ports[4];
+	spinlock_t reg_lock;	/* Switch IP register lock */
+	void __iomem *base;
+	u8 *vidmbrcfg;		/* vidmbrcfg shadow */
+	size_t fdb_entries;
+};
+
+#endif /* _HELLCREEK_H_ */
-- 
2.20.1

