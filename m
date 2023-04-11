Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A497E6DE274
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 19:25:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230115AbjDKRZS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 13:25:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230107AbjDKRZQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 13:25:16 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F106912A
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 10:25:12 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pmHjp-0001yn-9U; Tue, 11 Apr 2023 19:25:01 +0200
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1pmHjn-00AYPy-DC; Tue, 11 Apr 2023 19:24:59 +0200
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1pmHjm-00CbEH-9N; Tue, 11 Apr 2023 19:24:58 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com
Subject: [PATCH net-next v1 2/2] net: dsa: microchip: Add partial ACL support for ksz9477 switches
Date:   Tue, 11 Apr 2023 19:24:55 +0200
Message-Id: <20230411172456.3003003-3-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230411172456.3003003-1-o.rempel@pengutronix.de>
References: <20230411172456.3003003-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-2.3 required=5.0 tests=RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds partial Access Control List (ACL) support for the
ksz9477 family of switches. ACLs enable filtering of incoming layer 2
MAC, layer 3 IP, and layer 4 TCP/UDP packets on each port. They provide
additional capabilities for filtering routed network protocols and can
take precedence over other forwarding functions.

ACLs can filter ingress traffic based on header fields such as
source/destination MAC address, EtherType, IPv4 address, IPv4 protocol,
UDP/TCP ports, and TCP flags. The ACL is an ordered list of up to 16
access control rules programmed into the ACL Table. Each entry specifies
a set of matching conditions and action rules for controlling packet
forwarding and priority.

The ACL also implements a count function, generating an interrupt
instead of a forwarding action. It can be used as a watchdog timer or an
event counter. The ACL consists of three parts: matching rules, action
rules, and processing entries. Multiple match conditions can be either
AND'ed or OR'ed together.

This patch introduces support for a subset of the available ACL
functionality, specifically layer 2 matching and prioritization of
matched packets. For example:

tc qdisc add dev lan2 clsact
tc filter add dev lan2 ingress protocol 0x88f7 flower skip_sw hw_tc 7

tc qdisc add dev lan1 clsact
tc filter add dev lan1 ingress protocol 0x88f7 flower skip_sw hw_tc 7

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/dsa/microchip/Makefile      |   2 +-
 drivers/net/dsa/microchip/ksz9477.c     |   7 +
 drivers/net/dsa/microchip/ksz9477.h     |   7 +
 drivers/net/dsa/microchip/ksz9477_acl.c | 950 ++++++++++++++++++++++++
 drivers/net/dsa/microchip/ksz_common.c  |  40 +
 drivers/net/dsa/microchip/ksz_common.h  |   1 +
 6 files changed, 1006 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/dsa/microchip/ksz9477_acl.c

diff --git a/drivers/net/dsa/microchip/Makefile b/drivers/net/dsa/microchip/Makefile
index 48360cc9fc68..50851519c9a1 100644
--- a/drivers/net/dsa/microchip/Makefile
+++ b/drivers/net/dsa/microchip/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
 obj-$(CONFIG_NET_DSA_MICROCHIP_KSZ_COMMON)	+= ksz_switch.o
 ksz_switch-objs := ksz_common.o
-ksz_switch-objs += ksz9477.o
+ksz_switch-objs += ksz9477.o ksz9477_acl.o
 ksz_switch-objs += ksz8795.o
 ksz_switch-objs += lan937x_main.o
 
diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index bf13d47c26cf..f2c34ab3d3eb 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -1151,6 +1151,7 @@ int ksz9477_setup(struct dsa_switch *ds)
 {
 	struct ksz_device *dev = ds->priv;
 	int ret = 0;
+	int i;
 
 	ds->mtu_enforcement_ingress = true;
 
@@ -1176,6 +1177,12 @@ int ksz9477_setup(struct dsa_switch *ds)
 	/* enable global MIB counter freeze function */
 	ksz_cfg(dev, REG_SW_MAC_CTRL_6, SW_MIB_COUNTER_FREEZE, true);
 
+	for (i = 0; i < dev->info->port_cnt; i++) {
+		if (i == dev->cpu_port)
+			continue;
+		ksz9477_port_acl_init(dev, i);
+	}
+
 	return 0;
 }
 
diff --git a/drivers/net/dsa/microchip/ksz9477.h b/drivers/net/dsa/microchip/ksz9477.h
index b6f7e3c46e3f..5201bccda0ed 100644
--- a/drivers/net/dsa/microchip/ksz9477.h
+++ b/drivers/net/dsa/microchip/ksz9477.h
@@ -59,4 +59,11 @@ int ksz9477_switch_init(struct ksz_device *dev);
 void ksz9477_switch_exit(struct ksz_device *dev);
 void ksz9477_port_queue_split(struct ksz_device *dev, int port);
 
+
+int ksz9477_port_acl_init(struct ksz_device *dev, int port);
+int ksz9477_cls_flower_add(struct dsa_switch *ds, int port,
+			   struct flow_cls_offload *cls, bool ingress);
+int ksz9477_cls_flower_del(struct dsa_switch *ds, int port,
+			   struct flow_cls_offload *cls, bool ingress);
+
 #endif
diff --git a/drivers/net/dsa/microchip/ksz9477_acl.c b/drivers/net/dsa/microchip/ksz9477_acl.c
new file mode 100644
index 000000000000..319158ebbdd9
--- /dev/null
+++ b/drivers/net/dsa/microchip/ksz9477_acl.c
@@ -0,0 +1,950 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (c) 2023 Pengutronix, Oleksij Rempel <kernel@pengutronix.de>
+
+/* Access Control List (ACL) structure:
+ *
+ * There are multiple groups of registers involved in ACL configuration:
+ *
+ * - Matching Rules: These registers define the criteria for matching incoming
+ *   packets based on their header information (Layer 2 MAC, Layer 3 IP, or
+ *   Layer 4 TCP/UDP). Different register settings are used depending on the
+ *   matching rule mode (MD) and the Enable (ENB) settings.
+ *
+ * - Action Rules: These registers define how the ACL should modify the packet's
+ *   priority, VLAN tag priority, and forwarding map once a matching rule has
+ *   been triggered. The settings vary depending on whether the matching rule is
+ *   in Count Mode (MD = 01 and ENB = 00) or not.
+ *
+ * - Processing Rules: These registers control the overall behavior of the ACL,
+ *   such as selecting which matching rule to apply first, enabling/disabling
+ *   specific rules, or specifying actions for matched packets.
+ *
+ * ACL Structure:
+ *                             +----------------------+
+ * +----------------------+    |    (optional)        |
+ * |    Matching Rules    |    |    Matching Rules    |
+ * |    (Layer 2, 3, 4)   |    |    (Layer 2, 3, 4)   |
+ * +----------------------+    +----------------------+
+ *             |			   |
+ *             \___________________________/
+ *                          v
+ *               +----------------------+
+ *               |   Processing Rules   |
+ *               | (action idx,	        |
+ *               | matching rule set)   |
+ *               +----------------------+
+ *                          |
+ *                          v
+ *               +----------------------+
+ *               |    Action Rules      |
+ *               | (Modify Priority,    |
+ *               |  Forwarding Map,     |
+ *               |  VLAN tag, etc)      |
+ *               +----------------------+
+ */
+
+#include "ksz9477.h"
+#include "ksz9477_reg.h"
+#include "ksz_common.h"
+
+#define KSZ9477_ACL_ENTRY_SIZE		18
+#define KSZ9477_ACL_MAX_ENTRIES		16
+#define KSZ9477_MAC_TC			7
+
+#define ETHER_TYPE_FULL_MASK		cpu_to_be16(~0)
+
+struct ksz9477_acl_entry {
+	u8 entry[KSZ9477_ACL_ENTRY_SIZE];
+	unsigned long cookie;
+};
+
+struct ksz9477_acl_entries {
+	struct ksz9477_acl_entry entries[KSZ9477_ACL_MAX_ENTRIES];
+	int entries_count;
+	bool entries_unprocessed;
+};
+
+struct ksz9477_acl_priv {
+	struct ksz9477_acl_entries acles;
+	unsigned long current_cookie;
+};
+
+#define KSZ9477_PORT_ACL_0		0x600
+
+enum ksz9477_acl_port_access {
+	KSZ9477_ACL_PORT_ACCESS_0  = 0x00,
+	KSZ9477_ACL_PORT_ACCESS_1  = 0x01,
+	KSZ9477_ACL_PORT_ACCESS_2  = 0x02,
+	KSZ9477_ACL_PORT_ACCESS_3  = 0x03,
+	KSZ9477_ACL_PORT_ACCESS_4  = 0x04,
+	KSZ9477_ACL_PORT_ACCESS_5  = 0x05,
+	KSZ9477_ACL_PORT_ACCESS_6  = 0x06,
+	KSZ9477_ACL_PORT_ACCESS_7  = 0x07,
+	KSZ9477_ACL_PORT_ACCESS_8  = 0x08,
+	KSZ9477_ACL_PORT_ACCESS_9  = 0x09,
+	KSZ9477_ACL_PORT_ACCESS_A  = 0x0A,
+	KSZ9477_ACL_PORT_ACCESS_B  = 0x0B,
+	KSZ9477_ACL_PORT_ACCESS_C  = 0x0C,
+	KSZ9477_ACL_PORT_ACCESS_D  = 0x0D,
+	KSZ9477_ACL_PORT_ACCESS_E  = 0x0E,
+	KSZ9477_ACL_PORT_ACCESS_F  = 0x0F,
+	KSZ9477_ACL_PORT_ACCESS_10 = 0x10,
+	KSZ9477_ACL_PORT_ACCESS_11 = 0x11
+};
+
+#define KSZ9477_ACL_MD_MASK			GENMASK(5, 4)
+#define KSZ9477_ACL_MD_DISABLE			0
+#define KSZ9477_ACL_MD_L2_MAC			1
+#define KSZ9477_ACL_MD_L3_IP			2
+#define KSZ9477_ACL_MD_L4_TCP_UDP		3
+
+#define KSZ9477_ACL_ENB_MASK			GENMASK(3, 2)
+#define KSZ9477_ACL_ENB_L2_TYPE			1
+#define KSZ9477_ACL_ENB_L2_MAC			2
+#define KSZ9477_ACL_ENB_L2_MAC_TYPE		3
+
+/* only IPv$ src or dst can be used with mask */
+#define KSZ9477_ACL_ENB_L3_IPV4_ADDR_MASK	1
+/* only IPv$ src and dst can be used without mask */
+#define KSZ9477_ACL_ENB_L3_IPV4_ADDR_SRC_DST	2
+
+#define KSZ9477_ACL_ENB_L4_IP_PROTO	        0
+#define KSZ9477_ACL_ENB_L4_TCP_SRC_DST_PORT	1
+#define KSZ9477_ACL_ENB_L4_UDP_SRC_DST_PORT	2
+#define KSZ9477_ACL_ENB_L4_TCP_SEQ_NUMBER	3
+
+#define KSZ9477_ACL_SD_SRC			BIT(1)
+#define KSZ9477_ACL_SD_DST			0
+#define KSZ9477_ACL_EQ_EQUAL			BIT(0)
+#define KSZ9477_ACL_EQ_NOT_EQUAL		0
+
+#define KSZ9477_PORT_ACL_CTRL_0			0x0612
+
+#define KSZ9477_ACL_WRITE_DONE			BIT(6)
+#define KSZ9477_ACL_READ_DONE			BIT(5)
+#define KSZ9477_ACL_WRITE			BIT(4)
+#define KSZ9477_ACL_INDEX_M			GENMASK(3, 0)
+
+/**
+ * ksz9477_acl_wait_ready - Waits for the ACL operation to complete on a given
+ *			    port.
+ * @dev: The ksz_device instance.
+ * @port: The port number to wait for.
+ *
+ * This function checks if the ACL write or read operation is completed by
+ * polling the specified register. It returns 0 if the operation is successful,
+ * or a negative error code if an error occurs.
+ */
+static int ksz9477_acl_wait_ready(struct ksz_device *dev, int port)
+{
+	unsigned int wr_mask = KSZ9477_ACL_WRITE_DONE | KSZ9477_ACL_READ_DONE;
+	unsigned int val, reg;
+	int ret;
+
+	reg = dev->dev_ops->get_port_addr(port, KSZ9477_PORT_ACL_CTRL_0);
+
+	ret = regmap_read_poll_timeout(dev->regmap[0], reg, val,
+				       (val & wr_mask) == wr_mask, 1000, 10000);
+	if (ret)
+		dev_err(dev->dev, "Failed to read/write ACL table\n");
+
+	return ret;
+}
+
+/**
+ * ksz9477_acl_entry_write - Writes an ACL entry to a given port at the
+ *			     specified index.
+ * @dev: The ksz_device instance.
+ * @port: The port number to write the ACL entry to.
+ * @entry: A pointer to the ACL entry data.
+ * @idx: The index at which to write the ACL entry.
+ *
+ * This function writes the provided ACL entry to the specified port at the
+ * given index. It returns 0 if the operation is successful, or a negative error
+ * code if an error occurs.
+ */
+static int ksz9477_acl_entry_write(struct ksz_device *dev, int port, u8 *entry,
+				   int idx)
+{
+	int ret, i;
+	u8 val;
+
+	for (i = 0; i < KSZ9477_ACL_ENTRY_SIZE; i++) {
+		ret = ksz_pwrite8(dev, port, KSZ9477_PORT_ACL_0 + i, entry[i]);
+		if (ret) {
+			dev_err(dev->dev, "Failed to write ACL entry %d\n", i);
+			return ret;
+		}
+	}
+
+	/* write everything down */
+	val = FIELD_PREP(KSZ9477_ACL_INDEX_M, idx) | KSZ9477_ACL_WRITE;
+	ret = ksz_pwrite8(dev, port, KSZ9477_PORT_ACL_CTRL_0, val);
+	if (ret)
+		return ret;
+
+	/* wait until everything is written  */
+	return ksz9477_acl_wait_ready(dev, port);
+}
+
+/**
+ * ksz9477_acl_port_enable - Enables ACL functionality on a given port.
+ * @dev: The ksz_device instance.
+ * @port: The port number on which to enable ACL functionality.
+ *
+ * This function enables ACL functionality on the specified port by configuring
+ * the appropriate control registers. It returns 0 if the operation is
+ * successful, or a negative error code if an error occurs.
+ */
+static int ksz9477_acl_port_enable(struct ksz_device *dev, int port)
+{
+	int ret;
+
+	ret = ksz_prmw8(dev, port, P_PRIO_CTRL, 0, PORT_ACL_PRIO_ENABLE |
+			PORT_OR_PRIO);
+	if (ret)
+		return ret;
+
+	return ksz_pwrite8(dev, port, REG_PORT_MRI_AUTHEN_CTRL,
+			   PORT_ACL_ENABLE |
+			   FIELD_PREP(PORT_AUTHEN_MODE, PORT_AUTHEN_PASS));
+}
+
+/**
+ * ksz9477_acl_port_disable - Disables ACL functionality on a given port.
+ * @dev: The ksz_device instance.
+ * @port: The port number on which to disable ACL functionality.
+ *
+ * This function disables ACL functionality on the specified port by writing a
+ * value of 0 to the REG_PORT_MRI_AUTHEN_CTRL control register and remove
+ * PORT_ACL_PRIO_ENABLE bit from P_PRIO_CTRL register.
+ * It returns 0 if the operation is successful, or a negative error code if an
+ * error occurs.
+ */
+static int ksz9477_acl_port_disable(struct ksz_device *dev, int port)
+{
+	int ret;
+
+	ret = ksz_prmw8(dev, port, P_PRIO_CTRL, PORT_ACL_PRIO_ENABLE, 0);
+	if (ret)
+		return ret;
+
+	return ksz_pwrite8(dev, port, REG_PORT_MRI_AUTHEN_CTRL, 0);
+}
+
+/**
+ * ksz9477_acl_write_list - Write a list of ACL entries to a given port.
+ * @dev: The ksz_device instance.
+ * @port: The port number on which to write ACL entries.
+ *
+ * This function enables ACL functionality on the specified port, writes a list
+ * of ACL entries to the port, and disables ACL functionality if there are no
+ * entries. It returns 0 if the operation is successful, or a negative error
+ * code if an error occurs.
+ */
+static int ksz9477_acl_write_list(struct ksz_device *dev, int port)
+{
+	struct ksz9477_acl_priv *acl = dev->ports[port].acl_priv;
+	struct ksz9477_acl_entries *acles = &acl->acles;
+	int ret, i;
+
+	/* ACL should be enabled before writing entries */
+	ret = ksz9477_acl_port_enable(dev, port);
+	if (ret)
+		return ret;
+
+	/* write all entries */
+	for (i = 0; i < ARRAY_SIZE(acles->entries); i++) {
+		u8 *entry = acles->entries[i].entry;
+
+		/* check if entry was removed and should be zeroed */
+		if (i >= acles->entries_count &&
+		    entry[KSZ9477_ACL_PORT_ACCESS_10] == 0 &&
+		    entry[KSZ9477_ACL_PORT_ACCESS_11] == 0)
+			continue;
+
+		ret = ksz9477_acl_entry_write(dev, port, entry, i);
+		if (ret)
+			return ret;
+
+		/* now removed entry is clean on HW side, so it can
+		 * in the cache too
+		 */
+		if (i >= acles->entries_count &&
+		    entry[KSZ9477_ACL_PORT_ACCESS_10] != 0 &&
+		    entry[KSZ9477_ACL_PORT_ACCESS_11] != 0) {
+			entry[KSZ9477_ACL_PORT_ACCESS_10] = 0;
+			entry[KSZ9477_ACL_PORT_ACCESS_11] = 0;
+		}
+	}
+
+	if (!acles->entries_count)
+		return ksz9477_acl_port_disable(dev, port);
+
+	return 0;
+}
+
+/**
+ * ksz9477_acl_remove_entries - Remove ACL entries with a given cookie from a
+ *                              specified ksz9477_acl_entries structure.
+ * @acles: The ksz9477_acl_entries instance.
+ * @cookie: The cookie value to match for entry removal.
+ *
+ * This function iterates through the entries array, removing any entries with
+ * a matching cookie value. The remaining entries are then shifted down to fill
+ * the gap.
+ */
+static void ksz9477_acl_remove_entries(struct ksz9477_acl_entries *acles,
+				       unsigned long cookie)
+{
+	int i, j;
+
+	if (!acles->entries_count)
+		return;
+
+	/* Iterate through the entries array */
+	for (i = 0; i < acles->entries_count;) {
+		/* Check if the cookie matches */
+		if (acles->entries[i].cookie == cookie) {
+			struct ksz9477_acl_entry *last_entry;
+
+			/* Shift remaining entries down */
+			for (j = i; j < acles->entries_count - 1; ++j)
+				acles->entries[j] = acles->entries[j + 1];
+
+			last_entry = &acles->entries[acles->entries_count - 1];
+
+			memset(last_entry, 0, sizeof(*last_entry));
+
+			/* Set all access bits to be able to write zeroed
+			 * entry
+			 */
+			last_entry->entry[KSZ9477_ACL_PORT_ACCESS_10] = 0xff;
+			last_entry->entry[KSZ9477_ACL_PORT_ACCESS_11] = 0xff;
+
+			/* Decrease the entries_count */
+			acles->entries_count--;
+		} else {
+			/* Move to the next entry if the cookie doesn't match */
+			i++;
+		}
+	}
+}
+
+/**
+ * ksz9477_port_acl_init - Initialize the ACL for a specified port on a ksz
+ *			   device.
+ * @dev: The ksz_device instance.
+ * @port: The port number to initialize the ACL for.
+ *
+ * This function allocates memory for an acl structure, associates it with the
+ * specified port, and initializes the ACL entries to a default state. The
+ * entries are then written using the ksz9477_acl_write_list function, ensuring
+ * the ACL has a predictable initial hardware state.
+ *
+ * Returns: 0 on success, or an error code on failure.
+ */
+int ksz9477_port_acl_init(struct ksz_device *dev, int port)
+{
+	struct ksz9477_acl_entries *acles;
+	struct ksz9477_acl_priv *acl;
+	int i;
+
+	acl = kzalloc(sizeof(*acl), GFP_KERNEL);
+	if (!acl)
+		return -ENOMEM;
+
+	dev->ports[port].acl_priv = acl;
+
+	acles = &acl->acles;
+	/* write all entries */
+	for (i = 0; i < ARRAY_SIZE(acles->entries); i++) {
+		u8 *entry = acles->entries[i].entry;
+
+		/* Set all access bits to be able to write zeroed
+		 * entry
+		 */
+		entry[KSZ9477_ACL_PORT_ACCESS_10] = 0xff;
+		entry[KSZ9477_ACL_PORT_ACCESS_11] = 0xff;
+	}
+
+	return ksz9477_acl_write_list(dev, port);
+}
+
+/**
+ * ksz9477_acl_set_reg - Set entry[16] and entry[17] depending on the updated
+ *			   entry[]
+ * @entry: An array containing the entries
+ * @reg: The register of the entry that needs to be updated
+ * @value: The value to be assigned to the updated entry
+ *
+ * This function updates the entry[] array based on the provided register and
+ * value. It also sets entry[0x10] and entry[0x11] according to the ACL byte
+ * enable rules.
+ *
+ * 0x10 - Byte Enable [15:8]
+ *
+ * Each bit enables accessing one of the ACL bytes when a read or write is
+ * initiated by writing to the Port ACL Byte Enable LSB Register.
+ * Bit 0 applies to the Port ACL Access 7 Register
+ * Bit 1 applies to the Port ACL Access 6 Register, etc.
+ * Bit 7 applies to the Port ACL Access 0 Register
+ * 1 = Byte is selected for read/write
+ * 0 = Byte is not selected
+ *
+ * 0x11 - Byte Enable [7:0]
+ *
+ * Each bit enables accessing one of the ACL bytes when a read or write is
+ * initiated by writing to the Port ACL Byte Enable LSB Register.
+ * Bit 0 applies to the Port ACL Access F Register
+ * Bit 1 applies to the Port ACL Access E Register, etc.
+ * Bit 7 applies to the Port ACL Access 8 Register
+ * 1 = Byte is selected for read/write
+ * 0 = Byte is not selected
+ */
+
+static void ksz9477_acl_set_reg(u8 *entry, enum ksz9477_acl_port_access reg,
+				u8 value)
+{
+	if (reg >= KSZ9477_ACL_PORT_ACCESS_0 &&
+	    reg <= KSZ9477_ACL_PORT_ACCESS_7) {
+		entry[KSZ9477_ACL_PORT_ACCESS_10] |=
+				BIT(KSZ9477_ACL_PORT_ACCESS_7 - reg);
+	} else if (reg >= KSZ9477_ACL_PORT_ACCESS_8 &&
+		   reg <= KSZ9477_ACL_PORT_ACCESS_F) {
+		entry[KSZ9477_ACL_PORT_ACCESS_11] |=
+			BIT(KSZ9477_ACL_PORT_ACCESS_F - reg);
+	} else {
+		WARN_ON(1);
+		return;
+	}
+
+	entry[reg] = value;
+}
+
+/**
+ * ksz9477_acl_matching_rule_cfg_l2 - Configure an ACL filtering entry to match
+ *				      L2 types of Ethernet frames
+ * @entry: Pointer to ACL entry buffer
+ * @ethertype: Ethertype value
+ * @eth_addr: Pointer to Ethernet address
+ * @is_src: If true, match the source MAC address; if false, match the
+ *	    destination MAC address
+ *
+ * This function configures an Access Control List (ACL) filtering
+ * entry to match Layer 2 types of Ethernet frames based on the provided
+ * ethertype and Ethernet address. Additionally, it can match either the source
+ * or destination MAC address depending on the value of the is_src parameter.
+ *
+ * Register Descriptions for MD = 01 and ENB != 00 (Layer 2 MAC header
+ * filtering)
+ *
+ * 0x01 - Mode and Enable
+ *        Bits 5:4 - MD (Mode)
+ *                01 = Layer 2 MAC header or counter filtering
+ *        Bits 3:2 - ENB (Enable)
+ *                01 = Comparison is performed only on the TYPE value
+ *                10 = Comparison is performed only on the MAC Address value
+ *                11 = Both the MAC Address and TYPE are tested
+ *        Bit  1   - S/D (Source / Destination)
+ *                0 = Destination address
+ *                1 = Source address
+ *        Bit  0   - EQ (Equal / Not Equal)
+ *                0 = Not Equal produces true result
+ *                1 = Equal produces true result
+ *
+ * 0x02-0x07 - MAC Address
+ *        0x02 - MAC Address [47:40]
+ *        0x03 - MAC Address [39:32]
+ *        0x04 - MAC Address [31:24]
+ *        0x05 - MAC Address [23:16]
+ *        0x06 - MAC Address [15:8]
+ *        0x07 - MAC Address [7:0]
+ *
+ * 0x08-0x09 - EtherType
+ *        0x08 - EtherType [15:8]
+ *        0x09 - EtherType [7:0]
+ */
+static void ksz9477_acl_matching_rule_cfg_l2(u8 *entry, __be16 ethertype,
+					     u8 *eth_addr, bool is_src)
+{
+	u8 enb = 0;
+	u8 val;
+
+	if (ethertype)
+		enb |= KSZ9477_ACL_ENB_L2_TYPE;
+	if (eth_addr)
+		enb |= KSZ9477_ACL_ENB_L2_MAC;
+
+	val = FIELD_PREP(KSZ9477_ACL_MD_MASK, KSZ9477_ACL_MD_L2_MAC) |
+	      FIELD_PREP(KSZ9477_ACL_ENB_MASK, enb) |
+	      FIELD_PREP(KSZ9477_ACL_SD_SRC, is_src) | KSZ9477_ACL_EQ_EQUAL;
+	ksz9477_acl_set_reg(entry, KSZ9477_ACL_PORT_ACCESS_1, val);
+
+	if (eth_addr) {
+		int i;
+
+		for (i = 0; i < ETH_ALEN; i++) {
+			ksz9477_acl_set_reg(entry,
+					    KSZ9477_ACL_PORT_ACCESS_2 + i,
+					    eth_addr[i]);
+		}
+	}
+
+	ksz9477_acl_set_reg(entry, KSZ9477_ACL_PORT_ACCESS_8, ethertype & 0xff);
+	ksz9477_acl_set_reg(entry, KSZ9477_ACL_PORT_ACCESS_9, ethertype >> 8);
+}
+
+/**
+ * ksz9477_acl_action_rule_cfg - Set action for an ACL entry
+ * @entry: Pointer to the ACL entry
+ * @hw_tc: Hardware traffic class value
+ *
+ * This function sets the action for the specified ACL entry. It prepares
+ * the priority mode and traffic class values and updates the entry's
+ * action registers accordingly. Currently, there is no port or VLAN PCP
+ * remapping.
+ *
+ * ACL Action Rule Parameters for Non-Count Modes (MD ≠ 01 or ENB ≠ 00)
+ *
+ * 0x0A - PM, P, RPE, RP[2:1]
+ *        Bits 7:6 - PM[1:0] - Priority Mode
+ *		00 = ACL does not specify the packet priority. Priority is
+ *		     determined by standard QoS functions.
+ *		01 = Change packet priority to P[2:0] if it is greater than QoS
+ *		     result.
+ *		10 = Change packet priority to P[2:0] if it is smaller than the
+ *		     QoS result.
+ *		11 = Always change packet priority to P[2:0].
+ *        Bits 5:3 - P[2:0] - Priority value
+ *        Bit  2   - RPE - Remark Priority Enable
+ *        Bits 1:0 - RP[2:1] - Remarked Priority value (bits 2:1)
+ *		0 = Disable priority remarking
+ *		1 = Enable priority remarking. VLAN tag priority (PCP) bits are
+ *		    replaced by RP[2:0].
+ *
+ * 0x0B - RP[0], MM
+ *        Bit  7   - RP[0] - Remarked Priority value (bit 0)
+ *        Bits 6:5 - MM[1:0] - Map Mode
+ *		00 = No forwarding remapping
+ *		01 = The forwarding map in FORWARD is OR'ed with the forwarding
+ *		     map from the Address Lookup Table.
+ *		10 = The forwarding map in FORWARD is AND'ed with the forwarding
+ *		     map from the Address Lookup Table.
+ *		11 = The forwarding map in FORWARD replaces the forwarding map
+ *		     from the Address Lookup Table.
+ * 0x0D - FORWARD[n:0]
+ *       Bits 7:0 - FORWARD[n:0] - Forwarding map. Bit 0 = port 1,
+ *		    bit 1 = port 2, etc.
+ *		1 = enable forwarding to this port
+ *		0 = do not forward to this port
+ */
+static void ksz9477_acl_action_rule_cfg(u8 *entry, u8 hw_tc)
+{
+	u8 val;
+
+	val = FIELD_PREP(ACL_PRIO_MODE_M, ACL_PRIO_MODE_REPLACE) |
+	      FIELD_PREP(ACL_PRIO_M, hw_tc);
+	ksz9477_acl_set_reg(entry, KSZ9477_ACL_PORT_ACCESS_A, val);
+
+	/* no port or VLAN PCP remapping for now */
+	ksz9477_acl_set_reg(entry, KSZ9477_ACL_PORT_ACCESS_B, 0);
+	ksz9477_acl_set_reg(entry, KSZ9477_ACL_PORT_ACCESS_D, 0);
+}
+
+/**
+ * ksz9477_acl_processing_rule_set_action - Set the action for the processing
+ *					    rule set.
+ * @entry: Pointer to the ACL entry
+ * @action_idx: Index of the action to be applied
+ *
+ * This function sets the action for the processing rule set by updating the
+ * appropriate register in the entry. There can be only one action per
+ * processing rule.
+ *
+ * Access Control List (ACL) Processing Rule Registers:
+ *
+ * 0x00 - First Rule Number (FRN)
+ *        Bits 3:0 - First Rule Number. Pointer to an Action rule entry.
+ */
+static void ksz9477_acl_processing_rule_set_action(u8 *entry, u8 action_idx)
+{
+	ksz9477_acl_set_reg(entry, KSZ9477_ACL_PORT_ACCESS_0, action_idx);
+}
+
+/**
+ * ksz9477_acl_processing_rule_add_match - Add a matching rule to the rule set
+ * @entry: Pointer to the ACL entry
+ * @match_idx: Index of the matching rule to be added
+ *
+ * This function adds a matching rule to the rule set by updating the
+ * appropriate bits in the entry's rule set registers.
+ *
+ * Access Control List (ACL) Processing Rule Registers:
+ *
+ * 0x0E - RuleSet [15:8]
+ *        Bits 7:0 - RuleSet [15:8] Specifies a set of one or more Matching rule
+ *        entries. RuleSet has one bit for each of the 16 Matching rule entries.
+ *        If multiple Matching rules are selected, then all conditions will be
+ *	  AND'ed to produce a final match result.
+ *		0 = Matching rule not selected
+ *		1 = Matching rule selected
+ *
+ * 0x0F - RuleSet [7:0]
+ *        Bits 7:0 - RuleSet [7:0]
+ */
+static void ksz9477_acl_processing_rule_add_match(u8 *entry, u8 match_idx)
+{
+	u8 vale = entry[KSZ9477_ACL_PORT_ACCESS_E];
+	u8 valf = entry[KSZ9477_ACL_PORT_ACCESS_F];
+
+	if (match_idx < 8)
+		valf |= BIT(match_idx);
+	else
+		vale |= BIT(match_idx - 8);
+
+	ksz9477_acl_set_reg(entry, KSZ9477_ACL_PORT_ACCESS_E, vale);
+	ksz9477_acl_set_reg(entry, KSZ9477_ACL_PORT_ACCESS_F, valf);
+}
+
+/**
+ * ksz9477_acl_get_init_entry - Get a new uninitialized entry for a specified
+ *				port on a ksz_device.
+ * @dev: The ksz_device instance.
+ * @port: The port number to get the uninitialized entry for.
+ *
+ * This function retrieves the next available ACL entry for the specified port,
+ * clears all access flags, and associates it with the current cookie.
+ *
+ * Returns: A pointer to the new uninitialized ACL entry.
+ */
+
+struct ksz9477_acl_entry *ksz9477_acl_get_init_entry(struct ksz_device *dev,
+						     int port)
+{
+	struct ksz9477_acl_priv *acl = dev->ports[port].acl_priv;
+	struct ksz9477_acl_entries *acles = &acl->acles;
+	struct ksz9477_acl_entry *entry;
+
+	entry = &acles->entries[acles->entries_count];
+	entry->cookie = acl->current_cookie;
+
+	/* clear all access flags */
+	entry->entry[KSZ9477_ACL_PORT_ACCESS_10] = 0;
+	entry->entry[KSZ9477_ACL_PORT_ACCESS_11] = 0;
+
+	return entry;
+}
+
+/**
+ * ksz9477_acl_match_process_l2 - Configure Layer 2 ACL matching rules and
+ *                                processing rules.
+ * @dev: Pointer to the ksz_device.
+ * @port: Port number.
+ * @ethtype: Ethernet type.
+ * @src_mac: Source MAC address.
+ * @dst_mac: Destination MAC address.
+ *
+ * This function sets up matching and processing rules for Layer 2 ACLs.
+ * It takes into account that only one MAC per entry is supported.
+ */
+static void ksz9477_acl_match_process_l2(struct ksz_device *dev, int port,
+					 __be16 ethtype, u8 *src_mac,
+					 u8 *dst_mac)
+{
+	struct ksz9477_acl_priv *acl = dev->ports[port].acl_priv;
+	struct ksz9477_acl_entries *acles = &acl->acles;
+	struct ksz9477_acl_entry *entry;
+
+	entry = ksz9477_acl_get_init_entry(dev, port);
+
+	/* ACL supports only one MAC per entry */
+	if (src_mac && dst_mac) {
+		ksz9477_acl_matching_rule_cfg_l2(entry->entry, ethtype, src_mac,
+						 true);
+
+		/* Add both match entries to first processing rule */
+		ksz9477_acl_processing_rule_add_match(entry->entry,
+						      acles->entries_count);
+		acles->entries_count++;
+		ksz9477_acl_processing_rule_add_match(entry->entry,
+						      acles->entries_count);
+
+		entry = ksz9477_acl_get_init_entry(dev, port);
+		ksz9477_acl_matching_rule_cfg_l2(entry->entry, 0, dst_mac,
+						 false);
+		acles->entries_count++;
+	} else {
+		u8 *mac = src_mac ? src_mac : dst_mac;
+		bool is_src = src_mac ? true : false;
+
+		ksz9477_acl_matching_rule_cfg_l2(entry->entry, ethtype, mac,
+						 is_src);
+		ksz9477_acl_processing_rule_add_match(entry->entry,
+						      acles->entries_count);
+		acles->entries_count++;
+	}
+}
+
+/**
+ * ksz9477_flower_parse_key_l2 - Parse Layer 2 key from flow rule and configure
+ *                               ACL entries accordingly.
+ * @dev: Pointer to the ksz_device.
+ * @port: Port number.
+ * @extack: Pointer to the netlink_ext_ack.
+ * @rule: Pointer to the flow_rule.
+ *
+ * This function parses the Layer 2 key from the flow rule and configures
+ * the corresponding ACL entries. It checks for unsupported offloads and
+ * available entries before proceeding with the configuration.
+ *
+ * Returns 0 on success or a negative error code on failure.
+ */
+static int ksz9477_flower_parse_key_l2(struct ksz_device *dev, int port,
+				       struct netlink_ext_ack *extack,
+				       struct flow_rule *rule)
+{
+	struct ksz9477_acl_priv *acl = dev->ports[port].acl_priv;
+	struct flow_match_eth_addrs ematch;
+	struct ksz9477_acl_entries *acles;
+	int required_entries;
+	__be16 ethtype = 0;
+	u8 *src_mac = NULL;
+	u8 *dst_mac = NULL;
+
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_BASIC)) {
+		struct flow_match_basic match;
+
+		flow_rule_match_basic(rule, &match);
+
+		if (match.key->n_proto) {
+			if (match.mask->n_proto != ETHER_TYPE_FULL_MASK) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "ethernet type mask must be a full mask");
+				return -EINVAL;
+			}
+
+			ethtype = match.key->n_proto;
+		}
+	}
+
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ETH_ADDRS)) {
+		u8 bcast[] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
+
+		flow_rule_match_eth_addrs(rule, &ematch);
+
+		if (!is_zero_ether_addr(ematch.key->src)) {
+			if (!ether_addr_equal(ematch.mask->src, bcast))
+				goto not_full_mask_err;
+
+			src_mac = ematch.key->src;
+		}
+
+		if (!is_zero_ether_addr(ematch.key->dst)) {
+			if (!ether_addr_equal(ematch.mask->dst, bcast))
+				goto not_full_mask_err;
+
+			dst_mac = ematch.key->dst;
+		}
+	}
+
+	acles = &acl->acles;
+	/* ACL supports only one MAC per entry */
+	required_entries = src_mac && dst_mac ? 2 : 1;
+
+	/* Check if there are enough available entries */
+	if (acles->entries_count + required_entries > KSZ9477_ACL_MAX_ENTRIES) {
+		NL_SET_ERR_MSG_MOD(extack, "ACL entry limit reached");
+		return -EOPNOTSUPP;
+	}
+
+	ksz9477_acl_match_process_l2(dev, port, ethtype, src_mac, dst_mac);
+
+	return 0;
+
+not_full_mask_err:
+	NL_SET_ERR_MSG_MOD(extack, "MAC address mask must be a full mask");
+	return -EOPNOTSUPP;
+}
+
+/**
+ * ksz9477_flower_parse_key - Parse flow rule keys for a specified port on a
+ *			      ksz_device.
+ * @dev: The ksz_device instance.
+ * @port: The port number to parse the flow rule keys for.
+ * @extack: The netlink extended ACK for reporting errors.
+ * @rule: The flow_rule to parse.
+ *
+ * This function checks if the used keys in the flow rule are supported by
+ * the device and parses the L2 keys if they match. If unsupported keys are
+ * used, an error message is set in the extended ACK.
+ *
+ * Returns 0 on success or a negative error code on failure.
+ */
+static int ksz9477_flower_parse_key(struct ksz_device *dev, int port,
+				    struct netlink_ext_ack *extack,
+				    struct flow_rule *rule)
+{
+	struct flow_dissector *dissector = rule->match.dissector;
+	struct ksz9477_acl_priv *acl = dev->ports[port].acl_priv;
+	int ret;
+
+	if (dissector->used_keys &
+	    ~(BIT(FLOW_DISSECTOR_KEY_BASIC) |
+	      BIT(FLOW_DISSECTOR_KEY_ETH_ADDRS) |
+	      BIT(FLOW_DISSECTOR_KEY_CONTROL))) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Unsupported keys used");
+		return -EOPNOTSUPP;
+	}
+
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_BASIC) ||
+	    flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ETH_ADDRS)) {
+		ret = ksz9477_flower_parse_key_l2(dev, port, extack, rule);
+		if (ret)
+			return ret;
+		acl->acles.entries_unprocessed = true;
+	}
+
+	return 0;
+}
+
+/**
+ * ksz9477_flower_parse_action - Parse flow rule actions for a specified port
+ *				 on a ksz_device.
+ * @dev: The ksz_device instance.
+ * @port: The port number to parse the flow rule actions for.
+ * @extack: The netlink extended ACK for reporting errors.
+ * @cls: The flow_cls_offload instance containing the flow rule.
+ * @entry_idx: The index of the ACL entry to store the action.
+ *
+ * This function checks if the actions in the flow rule are supported by
+ * the device. Currently, only actions that change priorities are supported.
+ * If unsupported actions are encountered, an error message is set in the
+ * extended ACK.
+ *
+ * Returns 0 on success or a negative error code on failure.
+ */
+static int ksz9477_flower_parse_action(struct ksz_device *dev, int port,
+				       struct netlink_ext_ack *extack,
+				       struct flow_cls_offload *cls,
+				       int entry_idx)
+{
+	struct flow_rule *rule = flow_cls_offload_flow_rule(cls);
+	struct ksz9477_acl_priv *acl = dev->ports[port].acl_priv;
+	const struct flow_action_entry *act;
+	struct ksz9477_acl_entry *entry;
+	u32 hwtc;
+	int i;
+
+	/* currently no actions except of changing priorities are not
+	 * supported
+	 */
+	flow_action_for_each(i, act, &rule->action) {
+		switch (act->id) {
+		default:
+			NL_SET_ERR_MSG_MOD(extack, "action not supported");
+			return -EOPNOTSUPP;
+		}
+	}
+
+	/* pick entry to store action */
+	entry = &acl->acles.entries[entry_idx];
+
+	hwtc = TC_H_MIN(cls->classid) - TC_H_MIN_PRIORITY;
+	if (hwtc > KSZ9477_MAC_TC) {
+		NL_SET_ERR_MSG_MOD(extack, "traffic class not supported - value too high");
+		return -EINVAL;
+	}
+
+	ksz9477_acl_action_rule_cfg(entry->entry, hwtc);
+	ksz9477_acl_processing_rule_set_action(entry->entry, entry_idx);
+
+	return 0;
+}
+
+/**
+ * ksz9477_cls_flower_add - Add a flow classification rule for a specified port
+ *			    on a ksz_device.
+ * @ds: The DSA switch instance.
+ * @port: The port number to add the flow classification rule to.
+ * @cls: The flow_cls_offload instance containing the flow rule.
+ * @ingress: A flag indicating if the rule is applied on the ingress path.
+ *
+ * This function adds a flow classification rule for a specified port on a
+ * ksz_device. It checks if the ACL offloading is supported and parses the flow
+ * keys and actions. If the ACL is not supported, it returns an error. If there
+ * are unprocessed entries, it parses the action for the rule.
+ *
+ * Returns 0 on success or a negative error code on failure.
+ */
+int ksz9477_cls_flower_add(struct dsa_switch *ds, int port,
+			   struct flow_cls_offload *cls, bool ingress)
+{
+	struct flow_rule *rule = flow_cls_offload_flow_rule(cls);
+	struct netlink_ext_ack *extack = cls->common.extack;
+	struct ksz_device *dev = ds->priv;
+	struct ksz9477_acl_entry *entry;
+	struct ksz9477_acl_priv *acl;
+	int action_entry_idx;
+	int ret;
+
+	acl = dev->ports[port].acl_priv;
+
+	if (!acl) {
+		NL_SET_ERR_MSG_MOD(extack, "ACL offloading is not supported");
+		return -EOPNOTSUPP;
+	}
+
+	/* A complex rule set can take multiple entries. Use first entry
+	 * to store the action.
+	 */
+	entry = &acl->acles.entries[acl->acles.entries_count];
+	action_entry_idx = acl->acles.entries_count;
+	acl->current_cookie = cls->cookie;
+
+	ret = ksz9477_flower_parse_key(dev, port, extack, rule);
+	if (ret)
+		return ret;
+
+	if (acl->acles.entries_unprocessed) {
+		ret = ksz9477_flower_parse_action(dev, port, extack, cls,
+						  action_entry_idx);
+		if (ret)
+			return ret;
+	}
+
+	return ksz9477_acl_write_list(dev, port);
+}
+
+/**
+ * ksz9477_cls_flower_del - Remove a flow classification rule for a specified
+ *			    port on a ksz_device.
+ * @ds: The DSA switch instance.
+ * @port: The port number to remove the flow classification rule from.
+ * @cls: The flow_cls_offload instance containing the flow rule.
+ * @ingress: A flag indicating if the rule is applied on the ingress path.
+ *
+ * This function removes a flow classification rule for a specified port on a
+ * ksz_device. It checks if the ACL is initialized, and if not, returns an
+ * error. If the ACL is initialized, it removes entries with the specified
+ * cookie and rewrites the ACL list.
+ *
+ * Returns 0 on success or a negative error code on failure.
+ */
+int ksz9477_cls_flower_del(struct dsa_switch *ds, int port,
+			   struct flow_cls_offload *cls, bool ingress)
+{
+	unsigned long cookie = cls->cookie;
+	struct ksz_device *dev = ds->priv;
+	struct ksz9477_acl_priv *acl;
+
+	acl = dev->ports[port].acl_priv;
+
+	if (!acl)
+		return -EOPNOTSUPP;
+
+	ksz9477_acl_remove_entries(&acl->acles, cookie);
+
+	return ksz9477_acl_write_list(dev, port);
+}
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index a4428be5f483..d7d644597a24 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -2744,6 +2744,44 @@ static int ksz_set_mac_eee(struct dsa_switch *ds, int port,
 	return 0;
 }
 
+static int ksz_cls_flower_add(struct dsa_switch *ds, int port,
+			      struct flow_cls_offload *cls, bool ingress)
+{
+	struct ksz_device *dev = ds->priv;
+
+	switch (dev->chip_id) {
+	case KSZ8563_CHIP_ID:
+	case KSZ9477_CHIP_ID:
+	case KSZ9563_CHIP_ID:
+	case KSZ9567_CHIP_ID:
+	case KSZ9893_CHIP_ID:
+	case KSZ9896_CHIP_ID:
+	case KSZ9897_CHIP_ID:
+		return ksz9477_cls_flower_add(ds, port, cls, ingress);
+	}
+
+	return -EOPNOTSUPP;
+}
+
+static int ksz_cls_flower_del(struct dsa_switch *ds, int port,
+			      struct flow_cls_offload *cls, bool ingress)
+{
+	struct ksz_device *dev = ds->priv;
+
+	switch (dev->chip_id) {
+	case KSZ8563_CHIP_ID:
+	case KSZ9477_CHIP_ID:
+	case KSZ9563_CHIP_ID:
+	case KSZ9567_CHIP_ID:
+	case KSZ9893_CHIP_ID:
+	case KSZ9896_CHIP_ID:
+	case KSZ9897_CHIP_ID:
+		return ksz9477_cls_flower_del(ds, port, cls, ingress);
+	}
+
+	return -EOPNOTSUPP;
+}
+
 static void ksz_set_xmii(struct ksz_device *dev, int port,
 			 phy_interface_t interface)
 {
@@ -3420,6 +3458,8 @@ static const struct dsa_switch_ops ksz_switch_ops = {
 	.port_setup_tc		= ksz_setup_tc,
 	.get_mac_eee		= ksz_get_mac_eee,
 	.set_mac_eee		= ksz_set_mac_eee,
+	.cls_flower_add		= ksz_cls_flower_add,
+	.cls_flower_del		= ksz_cls_flower_del,
 };
 
 struct ksz_device *ksz_switch_alloc(struct device *base, void *priv)
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index 69c9a19aa4c3..d37ba702e93a 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -123,6 +123,7 @@ struct ksz_port {
 	ktime_t tstamp_msg;
 	struct completion tstamp_msg_comp;
 #endif
+	void *acl_priv;
 };
 
 struct ksz_device {
-- 
2.39.2

