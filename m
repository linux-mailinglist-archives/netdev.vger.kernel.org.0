Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8F4239429E
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 14:36:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236850AbhE1MhZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 08:37:25 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:15485 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235654AbhE1Mga (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 08:36:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1622205296; x=1653741296;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7dSqQpuo6VCEZvOpILUNhFvrUuJ2/AZ9CUOjlqXBrAg=;
  b=QnaFbR0wB6Fvg0796tm49gKsMb95fUjsA0f8pHA65ElJJoEx71A18hs+
   i/dmmslLdkKs8Bwg/wuZZAzPHx0VAwpm5ivXKVhE7uS+JvvnPS02dZVDr
   Q+zAGMi8UfuPX+NXotDeECNbRARZYnuyzvcihuk7d7Phas4Wlms5KOmfT
   WKS7sPqM+mZ7UJcu/Y7qwN+JfTvJ8yYCFTzKwxahNxEypEKXQv1gx8E/A
   0HSixim9Y6U+3KR4QlbEzEOkMQ8q1IkaId4ORDz3h+4Py4ARuJN7cZIuI
   EWnn2HIYUB/6X1A8qlhsQNTc4B2sqMI4KO7dcXP59RZFLNxS0w+KJMiGE
   w==;
IronPort-SDR: f3LyZHMtlP3ELR6MTvxMin5Y6Vwv2scUubUAUyPUArlHo/ili7ufRvHeUNPLJKstLvteLJIj5i
 1KqjRDPYAyzWAPCl5XEjxETCr4EzEWcdkfHhrLxnce1iNd/iv1MKaYbrXt1aelp3dD+kwLwxUL
 uaZu6qUIGvHWGHsOl/CUchRAUQygLsxkRLUi+xa/QMGXshJAKnEaNIss7TsymBibxIvjzfYH5q
 RvdYyKxBqVLhEz3Ta7autl4Gq4Ny0FpOZAdlG7ki+WwQTJs44S0h5DtZabrP0oy0KPQXqX149q
 GBM=
X-IronPort-AV: E=Sophos;i="5.83,229,1616482800"; 
   d="scan'208";a="122757496"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 May 2021 05:34:55 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 28 May 2021 05:34:46 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2176.2 via Frontend Transport; Fri, 28 May 2021 05:34:43 -0700
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Steen Hegelund <steen.hegelund@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>,
        "Microchip Linux Driver Support" <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Mark Einon <mark.einon@gmail.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        "Simon Horman" <simon.horman@netronome.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>
Subject: [PATCH net-next v2 05/10] net: sparx5: add mactable support
Date:   Fri, 28 May 2021 14:34:14 +0200
Message-ID: <20210528123419.1142290-6-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210528123419.1142290-1-steen.hegelund@microchip.com>
References: <20210528123419.1142290-1-steen.hegelund@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds the Sparx5 MAC tables: listening for MAC table updates and
updating on request.

Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
Signed-off-by: Bjarni Jonasson <bjarni.jonasson@microchip.com>
Signed-off-by: Lars Povlsen <lars.povlsen@microchip.com>
---
 .../net/ethernet/microchip/sparx5/Makefile    |   2 +-
 .../microchip/sparx5/sparx5_mactable.c        | 497 ++++++++++++++++++
 .../ethernet/microchip/sparx5/sparx5_main.c   |  21 +-
 .../ethernet/microchip/sparx5/sparx5_main.h   |  26 +
 .../ethernet/microchip/sparx5/sparx5_netdev.c |  21 +
 5 files changed, 565 insertions(+), 2 deletions(-)
 create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_mactable.c

diff --git a/drivers/net/ethernet/microchip/sparx5/Makefile b/drivers/net/ethernet/microchip/sparx5/Makefile
index 9c14eec33fd7..4ccb09d275bc 100644
--- a/drivers/net/ethernet/microchip/sparx5/Makefile
+++ b/drivers/net/ethernet/microchip/sparx5/Makefile
@@ -6,4 +6,4 @@
 obj-$(CONFIG_SPARX5_SWITCH) += sparx5-switch.o
 
 sparx5-switch-objs  := sparx5_main.o sparx5_packet.o \
- sparx5_netdev.o sparx5_port.o sparx5_phylink.o
+ sparx5_netdev.o sparx5_port.o sparx5_phylink.o sparx5_mactable.o
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_mactable.c b/drivers/net/ethernet/microchip/sparx5/sparx5_mactable.c
new file mode 100644
index 000000000000..6c5e04eccaa3
--- /dev/null
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_mactable.c
@@ -0,0 +1,497 @@
+// SPDX-License-Identifier: GPL-2.0+
+/* Microchip Sparx5 Switch driver
+ *
+ * Copyright (c) 2021 Microchip Technology Inc. and its subsidiaries.
+ */
+
+#include <net/switchdev.h>
+#include <linux/if_bridge.h>
+#include <linux/iopoll.h>
+
+#include "sparx5_main_regs.h"
+#include "sparx5_main.h"
+
+/* Commands for Mac Table Command register */
+#define MAC_CMD_LEARN         0 /* Insert (Learn) 1 entry */
+#define MAC_CMD_UNLEARN       1 /* Unlearn (Forget) 1 entry */
+#define MAC_CMD_LOOKUP        2 /* Look up 1 entry */
+#define MAC_CMD_READ          3 /* Read entry at Mac Table Index */
+#define MAC_CMD_WRITE         4 /* Write entry at Mac Table Index */
+#define MAC_CMD_SCAN          5 /* Scan (Age or find next) */
+#define MAC_CMD_FIND_SMALLEST 6 /* Get next entry */
+#define MAC_CMD_CLEAR_ALL     7 /* Delete all entries in table */
+
+/* Commands for MAC_ENTRY_ADDR_TYPE */
+#define  MAC_ENTRY_ADDR_TYPE_UPSID_PN         0
+#define  MAC_ENTRY_ADDR_TYPE_UPSID_CPU_OR_INT 1
+#define  MAC_ENTRY_ADDR_TYPE_GLAG             2
+#define  MAC_ENTRY_ADDR_TYPE_MC_IDX           3
+
+#define TABLE_UPDATE_SLEEP_US 10
+#define TABLE_UPDATE_TIMEOUT_US 100000
+
+struct sparx5_mact_entry {
+	struct list_head list;
+	unsigned char mac[ETH_ALEN];
+	u32 flags;
+#define MAC_ENT_ALIVE	BIT(0)
+#define MAC_ENT_MOVED	BIT(1)
+#define MAC_ENT_LOCK	BIT(2)
+	u16 vid;
+	u16 port;
+};
+
+static int sparx5_mact_get_status(struct sparx5 *sparx5)
+{
+	return spx5_rd(sparx5, LRN_COMMON_ACCESS_CTRL);
+}
+
+static int sparx5_mact_wait_for_completion(struct sparx5 *sparx5)
+{
+	u32 val;
+
+	return readx_poll_timeout(sparx5_mact_get_status,
+		sparx5, val,
+		LRN_COMMON_ACCESS_CTRL_MAC_TABLE_ACCESS_SHOT_GET(val) == 0,
+		TABLE_UPDATE_SLEEP_US, TABLE_UPDATE_TIMEOUT_US);
+}
+
+static void sparx5_mact_select(struct sparx5 *sparx5,
+			       const unsigned char mac[ETH_ALEN],
+			       u16 vid)
+{
+	u32 macl = 0, mach = 0;
+
+	/* Set the MAC address to handle and the vlan associated in a format
+	 * understood by the hardware.
+	 */
+	mach |= vid    << 16;
+	mach |= mac[0] << 8;
+	mach |= mac[1] << 0;
+	macl |= mac[2] << 24;
+	macl |= mac[3] << 16;
+	macl |= mac[4] << 8;
+	macl |= mac[5] << 0;
+
+	spx5_wr(mach, sparx5, LRN_MAC_ACCESS_CFG_0);
+	spx5_wr(macl, sparx5, LRN_MAC_ACCESS_CFG_1);
+}
+
+int sparx5_mact_learn(struct sparx5 *sparx5, int pgid,
+		      const unsigned char mac[ETH_ALEN], u16 vid)
+{
+	int addr, type, ret;
+
+	if (pgid < SPX5_PORTS) {
+		type = MAC_ENTRY_ADDR_TYPE_UPSID_PN;
+		addr = pgid % 32;
+		addr += (pgid / 32) << 5; /* Add upsid */
+	} else {
+		type = MAC_ENTRY_ADDR_TYPE_MC_IDX;
+		addr = pgid - SPX5_PORTS;
+	}
+
+	mutex_lock(&sparx5->lock);
+
+	sparx5_mact_select(sparx5, mac, vid);
+
+	/* MAC entry properties */
+	spx5_wr(LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_ADDR_SET(addr) |
+		LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_ADDR_TYPE_SET(type) |
+		LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_VLD_SET(1) |
+		LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_LOCKED_SET(1),
+		sparx5, LRN_MAC_ACCESS_CFG_2);
+	spx5_wr(0, sparx5, LRN_MAC_ACCESS_CFG_3);
+
+	/*  Insert/learn new entry */
+	spx5_wr(LRN_COMMON_ACCESS_CTRL_CPU_ACCESS_CMD_SET(MAC_CMD_LEARN) |
+		LRN_COMMON_ACCESS_CTRL_MAC_TABLE_ACCESS_SHOT_SET(1),
+		sparx5, LRN_COMMON_ACCESS_CTRL);
+
+	ret = sparx5_mact_wait_for_completion(sparx5);
+
+	mutex_unlock(&sparx5->lock);
+
+	return ret;
+}
+
+int sparx5_mc_unsync(struct net_device *dev, const unsigned char *addr)
+{
+	struct sparx5_port *port = netdev_priv(dev);
+	struct sparx5 *sparx5 = port->sparx5;
+
+	return sparx5_mact_forget(sparx5, addr, port->pvid);
+}
+
+int sparx5_mc_sync(struct net_device *dev, const unsigned char *addr)
+{
+	struct sparx5_port *port = netdev_priv(dev);
+	struct sparx5 *sparx5 = port->sparx5;
+
+	return sparx5_mact_learn(sparx5, PGID_CPU, addr, port->pvid);
+}
+
+static int sparx5_mact_get(struct sparx5 *sparx5,
+			   unsigned char mac[ETH_ALEN],
+			   u16 *vid, u32 *pcfg2)
+{
+	u32 mach, macl, cfg2;
+	int ret = -ENOENT;
+
+	cfg2 = spx5_rd(sparx5, LRN_MAC_ACCESS_CFG_2);
+	if (LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_VLD_GET(cfg2)) {
+		mach = spx5_rd(sparx5, LRN_MAC_ACCESS_CFG_0);
+		macl = spx5_rd(sparx5, LRN_MAC_ACCESS_CFG_1);
+		mac[0] = ((mach >> 8)  & 0xff);
+		mac[1] = ((mach >> 0)  & 0xff);
+		mac[2] = ((macl >> 24) & 0xff);
+		mac[3] = ((macl >> 16) & 0xff);
+		mac[4] = ((macl >> 8)  & 0xff);
+		mac[5] = ((macl >> 0)  & 0xff);
+		*vid = mach >> 16;
+		*pcfg2 = cfg2;
+		ret = 0;
+	}
+
+	return ret;
+}
+
+bool sparx5_mact_getnext(struct sparx5 *sparx5,
+			 unsigned char mac[ETH_ALEN], u16 *vid, u32 *pcfg2)
+{
+	u32 cfg2;
+	int ret;
+
+	mutex_lock(&sparx5->lock);
+
+	sparx5_mact_select(sparx5, mac, *vid);
+
+	spx5_wr(LRN_SCAN_NEXT_CFG_SCAN_NEXT_IGNORE_LOCKED_ENA_SET(1) |
+		LRN_SCAN_NEXT_CFG_SCAN_NEXT_UNTIL_FOUND_ENA_SET(1),
+		sparx5, LRN_SCAN_NEXT_CFG);
+	spx5_wr(LRN_COMMON_ACCESS_CTRL_CPU_ACCESS_CMD_SET
+		(MAC_CMD_FIND_SMALLEST) |
+		LRN_COMMON_ACCESS_CTRL_MAC_TABLE_ACCESS_SHOT_SET(1),
+		sparx5, LRN_COMMON_ACCESS_CTRL);
+
+	ret = sparx5_mact_wait_for_completion(sparx5);
+	if (ret == 0) {
+		ret = sparx5_mact_get(sparx5, mac, vid, &cfg2);
+		if (ret == 0)
+			*pcfg2 = cfg2;
+	}
+
+	mutex_unlock(&sparx5->lock);
+
+	return ret == 0;
+}
+
+static int sparx5_mact_lookup(struct sparx5 *sparx5,
+			      const unsigned char mac[ETH_ALEN],
+			      u16 vid)
+{
+	int ret;
+
+	mutex_lock(&sparx5->lock);
+
+	sparx5_mact_select(sparx5, mac, vid);
+
+	/* Issue a lookup command */
+	spx5_wr(LRN_COMMON_ACCESS_CTRL_CPU_ACCESS_CMD_SET(MAC_CMD_LOOKUP) |
+		LRN_COMMON_ACCESS_CTRL_MAC_TABLE_ACCESS_SHOT_SET(1),
+		sparx5, LRN_COMMON_ACCESS_CTRL);
+
+	ret = sparx5_mact_wait_for_completion(sparx5);
+	if (ret)
+		goto out;
+
+	ret = LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_VLD_GET
+		(spx5_rd(sparx5, LRN_MAC_ACCESS_CFG_2));
+
+out:
+	mutex_unlock(&sparx5->lock);
+
+	return ret;
+}
+
+int sparx5_mact_forget(struct sparx5 *sparx5,
+		       const unsigned char mac[ETH_ALEN], u16 vid)
+{
+	int ret;
+
+	mutex_lock(&sparx5->lock);
+
+	sparx5_mact_select(sparx5, mac, vid);
+
+	/* Issue an unlearn command */
+	spx5_wr(LRN_COMMON_ACCESS_CTRL_CPU_ACCESS_CMD_SET(MAC_CMD_UNLEARN) |
+		LRN_COMMON_ACCESS_CTRL_MAC_TABLE_ACCESS_SHOT_SET(1),
+		sparx5, LRN_COMMON_ACCESS_CTRL);
+
+	ret = sparx5_mact_wait_for_completion(sparx5);
+
+	mutex_unlock(&sparx5->lock);
+
+	return ret;
+}
+
+static struct sparx5_mact_entry *alloc_mact_entry(struct sparx5 *sparx5,
+						  const unsigned char *mac,
+						  u16 vid, u16 port_index)
+{
+	struct sparx5_mact_entry *mact_entry;
+
+	mact_entry = devm_kzalloc(sparx5->dev,
+				  sizeof(*mact_entry), GFP_ATOMIC);
+	if (!mact_entry)
+		return NULL;
+
+	memcpy(mact_entry->mac, mac, ETH_ALEN);
+	mact_entry->vid = vid;
+	mact_entry->port = port_index;
+	return mact_entry;
+}
+
+static struct sparx5_mact_entry *find_mact_entry(struct sparx5 *sparx5,
+						 const unsigned char *mac,
+						 u16 vid, u16 port_index)
+{
+	struct sparx5_mact_entry *mact_entry;
+	struct sparx5_mact_entry *res = NULL;
+
+	mutex_lock(&sparx5->mact_lock);
+	list_for_each_entry(mact_entry, &sparx5->mact_entries, list) {
+		if (mact_entry->vid == vid &&
+		    ether_addr_equal(mac, mact_entry->mac) &&
+		    mact_entry->port == port_index) {
+			res = mact_entry;
+			break;
+		}
+	}
+	mutex_unlock(&sparx5->mact_lock);
+
+	return res;
+}
+
+static void sparx5_fdb_call_notifiers(enum switchdev_notifier_type type,
+				      const char *mac, u16 vid,
+				      struct net_device *dev, bool offloaded)
+{
+	struct switchdev_notifier_fdb_info info;
+
+	info.addr = mac;
+	info.vid = vid;
+	info.offloaded = offloaded;
+	call_switchdev_notifiers(type, dev, &info.info, NULL);
+}
+
+int sparx5_add_mact_entry(struct sparx5 *sparx5,
+			  struct sparx5_port *port,
+			  const unsigned char *addr, u16 vid)
+{
+	struct sparx5_mact_entry *mact_entry;
+	int ret;
+
+	ret = sparx5_mact_lookup(sparx5, addr, vid);
+	if (ret)
+		return 0;
+
+	/* In case the entry already exists, don't add it again to SW,
+	 * just update HW, but we need to look in the actual HW because
+	 * it is possible for an entry to be learn by HW and before the
+	 * mact thread to start the frame will reach CPU and the CPU will
+	 * add the entry but without the extern_learn flag.
+	 */
+	mact_entry = find_mact_entry(sparx5, addr, vid, port->portno);
+	if (mact_entry)
+		goto update_hw;
+
+	/* Add the entry in SW MAC table not to get the notification when
+	 * SW is pulling again
+	 */
+	mact_entry = alloc_mact_entry(sparx5, addr, vid, port->portno);
+	if (!mact_entry)
+		return -ENOMEM;
+
+	mutex_lock(&sparx5->mact_lock);
+	list_add_tail(&mact_entry->list, &sparx5->mact_entries);
+	mutex_unlock(&sparx5->mact_lock);
+
+update_hw:
+	ret = sparx5_mact_learn(sparx5, port->portno, addr, vid);
+
+	/* New entry? */
+	if (mact_entry->flags == 0) {
+		mact_entry->flags |= MAC_ENT_LOCK; /* Don't age this */
+		sparx5_fdb_call_notifiers(SWITCHDEV_FDB_ADD_TO_BRIDGE, addr, vid,
+					  port->ndev, true);
+	}
+
+	return ret;
+}
+
+int sparx5_del_mact_entry(struct sparx5 *sparx5,
+			  const unsigned char *addr,
+			  u16 vid)
+{
+	struct sparx5_mact_entry *mact_entry, *tmp;
+
+	/* Delete the entry in SW MAC table not to get the notification when
+	 * SW is pulling again
+	 */
+	mutex_lock(&sparx5->mact_lock);
+	list_for_each_entry_safe(mact_entry, tmp, &sparx5->mact_entries,
+				 list) {
+		if ((vid == 0 || mact_entry->vid == vid) &&
+		    ether_addr_equal(addr, mact_entry->mac)) {
+			list_del(&mact_entry->list);
+			devm_kfree(sparx5->dev, mact_entry);
+
+			sparx5_mact_forget(sparx5, addr, mact_entry->vid);
+		}
+	}
+	mutex_unlock(&sparx5->mact_lock);
+
+	return 0;
+}
+
+static void sparx5_mact_handle_entry(struct sparx5 *sparx5,
+				     unsigned char mac[ETH_ALEN],
+				     u16 vid, u32 cfg2)
+{
+	struct sparx5_mact_entry *mact_entry;
+	bool found = false;
+	u16 port;
+
+	if (LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_ADDR_TYPE_GET(cfg2) !=
+	    MAC_ENTRY_ADDR_TYPE_UPSID_PN)
+		return;
+
+	port = LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_ADDR_GET(cfg2);
+	if (port >= SPX5_PORTS)
+		return;
+
+	mutex_lock(&sparx5->mact_lock);
+	list_for_each_entry(mact_entry, &sparx5->mact_entries, list) {
+		if (mact_entry->vid == vid &&
+		    ether_addr_equal(mac, mact_entry->mac)) {
+			found = true;
+			mact_entry->flags |= MAC_ENT_ALIVE;
+			if (mact_entry->port != port) {
+				dev_warn(sparx5->dev, "Entry move: %d -> %d\n",
+					 mact_entry->port, port);
+				mact_entry->port = port;
+				mact_entry->flags |= MAC_ENT_MOVED;
+			}
+			/* Entry handled */
+			break;
+		}
+	}
+	mutex_unlock(&sparx5->mact_lock);
+
+	if (found && !(mact_entry->flags & MAC_ENT_MOVED))
+		/* Present, not moved */
+		return;
+
+	if (!found) {
+		/* Entry not found - now add */
+		mact_entry = alloc_mact_entry(sparx5, mac, vid, port);
+		if (!mact_entry)
+			return;
+
+		mact_entry->flags |= MAC_ENT_ALIVE;
+		mutex_lock(&sparx5->mact_lock);
+		list_add_tail(&mact_entry->list, &sparx5->mact_entries);
+		mutex_unlock(&sparx5->mact_lock);
+	}
+
+	/* New or moved entry - notify bridge */
+	sparx5_fdb_call_notifiers(SWITCHDEV_FDB_ADD_TO_BRIDGE,
+				  mac, vid, sparx5->ports[port]->ndev,
+				  true);
+}
+
+void sparx5_mact_pull_work(struct work_struct *work)
+{
+	struct delayed_work *del_work = to_delayed_work(work);
+	struct sparx5 *sparx5 = container_of(del_work, struct sparx5,
+					     mact_work);
+	struct sparx5_mact_entry *mact_entry, *tmp;
+	unsigned char mac[ETH_ALEN];
+	u32 cfg2;
+	u16 vid;
+	int ret;
+
+	/* Reset MAC entry flags */
+	mutex_lock(&sparx5->mact_lock);
+	list_for_each_entry(mact_entry, &sparx5->mact_entries, list)
+		mact_entry->flags &= MAC_ENT_LOCK;
+	mutex_unlock(&sparx5->mact_lock);
+
+	/* MAIN mac address processing loop */
+	vid = 0;
+	memset(mac, 0, sizeof(mac));
+	do {
+		mutex_lock(&sparx5->lock);
+		sparx5_mact_select(sparx5, mac, vid);
+		spx5_wr(LRN_SCAN_NEXT_CFG_SCAN_NEXT_UNTIL_FOUND_ENA_SET(1),
+			sparx5, LRN_SCAN_NEXT_CFG);
+		spx5_wr(LRN_COMMON_ACCESS_CTRL_CPU_ACCESS_CMD_SET
+			(MAC_CMD_FIND_SMALLEST) |
+			LRN_COMMON_ACCESS_CTRL_MAC_TABLE_ACCESS_SHOT_SET(1),
+			sparx5, LRN_COMMON_ACCESS_CTRL);
+		ret = sparx5_mact_wait_for_completion(sparx5);
+		if (ret == 0)
+			ret = sparx5_mact_get(sparx5, mac, &vid, &cfg2);
+		mutex_unlock(&sparx5->lock);
+		if (ret == 0)
+			sparx5_mact_handle_entry(sparx5, mac, vid, cfg2);
+	} while (ret == 0);
+
+	mutex_lock(&sparx5->mact_lock);
+	list_for_each_entry_safe(mact_entry, tmp, &sparx5->mact_entries,
+				 list) {
+		/* If the entry is in HW or permanent, then skip */
+		if (mact_entry->flags & (MAC_ENT_ALIVE | MAC_ENT_LOCK))
+			continue;
+
+		sparx5_fdb_call_notifiers(SWITCHDEV_FDB_DEL_TO_BRIDGE,
+					  mact_entry->mac, mact_entry->vid,
+					  sparx5->ports[mact_entry->port]->ndev,
+					  true);
+
+		list_del(&mact_entry->list);
+		devm_kfree(sparx5->dev, mact_entry);
+	}
+	mutex_unlock(&sparx5->mact_lock);
+
+	queue_delayed_work(sparx5->mact_queue, &sparx5->mact_work,
+			   SPX5_MACT_PULL_DELAY);
+}
+
+void sparx5_set_ageing(struct sparx5 *sparx5, int msecs)
+{
+	int value = max(1, msecs / 10); /* unit 10 ms */
+
+	spx5_rmw(LRN_AUTOAGE_CFG_UNIT_SIZE_SET(2) | /* 10 ms */
+		 LRN_AUTOAGE_CFG_PERIOD_VAL_SET(value / 2), /* one bit ageing */
+		 LRN_AUTOAGE_CFG_UNIT_SIZE |
+		 LRN_AUTOAGE_CFG_PERIOD_VAL,
+		 sparx5,
+		 LRN_AUTOAGE_CFG(0));
+}
+
+void sparx5_mact_init(struct sparx5 *sparx5)
+{
+	mutex_init(&sparx5->lock);
+
+	/*  Flush MAC table */
+	spx5_wr(LRN_COMMON_ACCESS_CTRL_CPU_ACCESS_CMD_SET(MAC_CMD_CLEAR_ALL) |
+		LRN_COMMON_ACCESS_CTRL_MAC_TABLE_ACCESS_SHOT_SET(1),
+		sparx5, LRN_COMMON_ACCESS_CTRL);
+
+	if (sparx5_mact_wait_for_completion(sparx5) != 0)
+		dev_warn(sparx5->dev, "MAC flush error\n");
+
+	sparx5_set_ageing(sparx5, BR_DEFAULT_AGEING_TIME / HZ * 1000);
+}
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_main.c b/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
index 0ae8320a5bbb..33568ad0bd2f 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
@@ -567,6 +567,8 @@ static void sparx5_board_init(struct sparx5 *sparx5)
 
 static int sparx5_start(struct sparx5 *sparx5)
 {
+	u8 broadcast[ETH_ALEN] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
+	char queue_name[32];
 	u32 idx;
 	int err;
 
@@ -599,12 +601,29 @@ static int sparx5_start(struct sparx5 *sparx5)
 			 ANA_CL_FILTER_CTRL_FORCE_FCS_UPDATE_ENA,
 			 sparx5, ANA_CL_FILTER_CTRL(idx));
 
-	/* MAC/VLAN support to be added in later patches */
+	/* Init MAC table, ageing */
+	sparx5_mact_init(sparx5);
+
+	/* VLAN support to be added in later patches */
+
+	/* Add host mode BC address (points only to CPU) */
+	sparx5_mact_learn(sparx5, PGID_CPU, broadcast, NULL_VID);
+
 	/* Enable queue limitation watermarks */
 	sparx5_qlim_set(sparx5);
 
 	/* Resource calendar support to be added in later patches */
 
+	/* Init mact_sw struct */
+	mutex_init(&sparx5->mact_lock);
+	INIT_LIST_HEAD(&sparx5->mact_entries);
+	snprintf(queue_name, sizeof(queue_name), "%s-mact",
+		 dev_name(sparx5->dev));
+	sparx5->mact_queue = create_singlethread_workqueue(queue_name);
+	INIT_DELAYED_WORK(&sparx5->mact_work, sparx5_mact_pull_work);
+	queue_delayed_work(sparx5->mact_queue, &sparx5->mact_work,
+			   SPX5_MACT_PULL_DELAY);
+
 	err = sparx5_register_netdevs(sparx5);
 	if (err)
 		return err;
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_main.h b/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
index 3c2334359998..5185104a7a0f 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
@@ -133,7 +133,14 @@ struct sparx5 {
 	/* port structures are in net device */
 	struct sparx5_port *ports[SPX5_PORTS];
 	enum sparx5_core_clockfreq coreclock;
+	/* Switch state */
 	u8 base_mac[ETH_ALEN];
+	/* SW MAC table */
+	struct list_head mact_entries;
+	/* mac table list (mact_entries) mutex */
+	struct mutex mact_lock;
+	struct delayed_work mact_work;
+	struct workqueue_struct *mact_queue;
 	/* Board specifics */
 	bool sd_sgpio_remapping;
 	/* Register based inj/xtr */
@@ -145,6 +152,25 @@ irqreturn_t sparx5_xtr_handler(int irq, void *_priv);
 int sparx5_port_xmit_impl(struct sk_buff *skb, struct net_device *dev);
 int sparx5_manual_injection_mode(struct sparx5 *sparx5);
 
+/* sparx5_mactable.c */
+void sparx5_mact_pull_work(struct work_struct *work);
+int sparx5_mact_learn(struct sparx5 *sparx5, int port,
+		      const unsigned char mac[ETH_ALEN], u16 vid);
+bool sparx5_mact_getnext(struct sparx5 *sparx5,
+			 unsigned char mac[ETH_ALEN], u16 *vid, u32 *pcfg2);
+int sparx5_mact_forget(struct sparx5 *sparx5,
+		       const unsigned char mac[ETH_ALEN], u16 vid);
+int sparx5_add_mact_entry(struct sparx5 *sparx5,
+			  struct sparx5_port *port,
+			  const unsigned char *addr, u16 vid);
+int sparx5_del_mact_entry(struct sparx5 *sparx5,
+			  const unsigned char *addr,
+			  u16 vid);
+int sparx5_mc_sync(struct net_device *dev, const unsigned char *addr);
+int sparx5_mc_unsync(struct net_device *dev, const unsigned char *addr);
+void sparx5_set_ageing(struct sparx5 *sparx5, int msecs);
+void sparx5_mact_init(struct sparx5 *sparx5);
+
 /* sparx5_netdev.c */
 bool sparx5_netdevice_check(const struct net_device *dev);
 struct net_device *sparx5_create_netdev(struct sparx5 *sparx5, u32 portno);
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_netdev.c b/drivers/net/ethernet/microchip/sparx5/sparx5_netdev.c
index 38cca57bdd1e..73fb9efb5284 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_netdev.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_netdev.c
@@ -132,17 +132,37 @@ static int sparx5_port_get_phys_port_name(struct net_device *dev,
 
 static int sparx5_set_mac_address(struct net_device *dev, void *p)
 {
+	struct sparx5_port *port = netdev_priv(dev);
+	struct sparx5 *sparx5 = port->sparx5;
 	const struct sockaddr *addr = p;
 
 	if (!is_valid_ether_addr(addr->sa_data))
 		return -EADDRNOTAVAIL;
 
+	/* Remove current */
+	sparx5_mact_forget(sparx5, dev->dev_addr,  port->pvid);
+
+	/* Add new */
+	sparx5_mact_learn(sparx5, PGID_CPU, addr->sa_data, port->pvid);
+
 	/* Record the address */
 	ether_addr_copy(dev->dev_addr, addr->sa_data);
 
 	return 0;
 }
 
+static int sparx5_get_port_parent_id(struct net_device *dev,
+				     struct netdev_phys_item_id *ppid)
+{
+	struct sparx5_port *sparx5_port = netdev_priv(dev);
+	struct sparx5 *sparx5 = sparx5_port->sparx5;
+
+	ppid->id_len = sizeof(sparx5->base_mac);
+	memcpy(&ppid->id, &sparx5->base_mac, ppid->id_len);
+
+	return 0;
+}
+
 static const struct net_device_ops sparx5_port_netdev_ops = {
 	.ndo_open               = sparx5_port_open,
 	.ndo_stop               = sparx5_port_stop,
@@ -150,6 +170,7 @@ static const struct net_device_ops sparx5_port_netdev_ops = {
 	.ndo_get_phys_port_name = sparx5_port_get_phys_port_name,
 	.ndo_set_mac_address    = sparx5_set_mac_address,
 	.ndo_validate_addr      = eth_validate_addr,
+	.ndo_get_port_parent_id = sparx5_get_port_parent_id,
 };
 
 bool sparx5_netdevice_check(const struct net_device *dev)
-- 
2.31.1

