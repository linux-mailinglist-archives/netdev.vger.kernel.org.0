Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A53152F7D56
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 14:57:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732914AbhAONzg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 08:55:36 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:16859 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731589AbhAONz3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 08:55:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1610718928; x=1642254928;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8v1fsTliltg3iJ2nCbVYzs/sJL7uSHVVMZtb6Y/hmKo=;
  b=SabXB72g5GBaeAf48xf3SIDzeVOZBxNsSURuINPpPIRK99mnuKCFEmOy
   aohTjISLrPWN+ZCZeoDgq8UP2NNAOmlCkXQVhwvKroNFkNdOtmkcGMwGk
   RRlRhgPxVMnogvwkLAy7G7UheMr4Hu5mDWlrQAFLDJHq6BpeMCIlgIluG
   XX9Sa73CP8aSheIHXQf8kq5p6T96BI2ST/HMk9vYalwLFvus+0nA1Xv/a
   89oHpwEXvP9YAK3VjDHGPyqJpNegyvsY+EPS9xRRdDnW0anr61SBPNgPu
   ylCpW6TbdyzJWse2oeQ5th8GHFlzj/0UxZxGei0qJDqghw9NJxUXVdCd4
   w==;
IronPort-SDR: tn9nZV5/l+q6tYPxgclwm7S8a0VntGQWXa4ZhFxgyG6fzcDKRFX0CZR8dgzYesBtessGEC8eu2
 Ag0q9kv0g5pbXUgN5+fyizeLUYgSngRqVLXJFP2PznfWSKepkmNhztW5NSOA63Wz+69tE41B9k
 dBoATld4EjiVsAJ5tgpoBxoh1RkQfTTJ4C7/fWkNHzSWUoe32+r5XlUevJFxwf06zqTrS/I0Bf
 OWFIS5VvPzAWxSIj/lP1bk9P+SbyvWRO55rnnyw1lBHLONA/V4cKo/2EfhSNP76aI5vAwrmjv2
 F7k=
X-IronPort-AV: E=Sophos;i="5.79,349,1602572400"; 
   d="scan'208";a="40538282"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 15 Jan 2021 06:54:12 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 15 Jan 2021 06:54:12 -0700
Received: from mchp-dev-shegelun.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Fri, 15 Jan 2021 06:54:09 -0700
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Steen Hegelund <steen.hegelund@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Mark Einon <mark.einon@gmail.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [RFC PATCH v3 5/8] net: sparx5: add switching, vlan and mactable support
Date:   Fri, 15 Jan 2021 14:53:36 +0100
Message-ID: <20210115135339.3127198-6-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210115135339.3127198-1-steen.hegelund@microchip.com>
References: <20210115135339.3127198-1-steen.hegelund@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds SwitchDev support by hardware offloading the
SW bridge and setting up the Sparx5 MAC/VLAN tables, and listening
for MAC table updates.

Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
Signed-off-by: Bjarni Jonasson <bjarni.jonasson@microchip.com>
Signed-off-by: Lars Povlsen <lars.povlsen@microchip.com>
---
 .../net/ethernet/microchip/sparx5/Makefile    |   3 +-
 .../microchip/sparx5/sparx5_mactable.c        | 500 +++++++++++++++++
 .../ethernet/microchip/sparx5/sparx5_main.c   |  40 +-
 .../ethernet/microchip/sparx5/sparx5_main.h   |  51 ++
 .../ethernet/microchip/sparx5/sparx5_netdev.c |  31 ++
 .../ethernet/microchip/sparx5/sparx5_packet.c |   6 +
 .../microchip/sparx5/sparx5_switchdev.c       | 517 ++++++++++++++++++
 .../ethernet/microchip/sparx5/sparx5_vlan.c   | 224 ++++++++
 8 files changed, 1366 insertions(+), 6 deletions(-)
 create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_mactable.c
 create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c
 create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_vlan.c

diff --git a/drivers/net/ethernet/microchip/sparx5/Makefile b/drivers/net/ethernet/microchip/sparx5/Makefile
index 9c14eec33fd7..32e0691e328a 100644
--- a/drivers/net/ethernet/microchip/sparx5/Makefile
+++ b/drivers/net/ethernet/microchip/sparx5/Makefile
@@ -5,5 +5,6 @@
 
 obj-$(CONFIG_SPARX5_SWITCH) += sparx5-switch.o
 
-sparx5-switch-objs  := sparx5_main.o sparx5_packet.o \
+sparx5-switch-objs  := sparx5_main.o sparx5_switchdev.o \
+ sparx5_vlan.o sparx5_mactable.o sparx5_packet.o \
  sparx5_netdev.o sparx5_port.o sparx5_phylink.o
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_mactable.c b/drivers/net/ethernet/microchip/sparx5/sparx5_mactable.c
new file mode 100644
index 000000000000..81f82e9ab60f
--- /dev/null
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_mactable.c
@@ -0,0 +1,500 @@
+// SPDX-License-Identifier: GPL-2.0+
+/* Microchip Sparx5 Switch driver
+ *
+ * Copyright (c) 2020 Microchip Technology Inc. and its subsidiaries.
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
+#define MAC_ENT_LOCK	BIT(1)
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
+	int ret;
+	u32 cfg2;
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
+		sparx5_fdb_call_notifiers(SWITCHDEV_FDB_OFFLOADED, addr, vid,
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
+	u16 port;
+	bool found = false;
+
+	if (LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_ADDR_TYPE_GET(cfg2) !=
+	    MAC_ENTRY_ADDR_TYPE_UPSID_PN)
+		return;
+
+	port = LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_ADDR_GET(cfg2);
+	if (port >= SPX5_PORTS)
+		return;
+
+	if (!test_bit(port, sparx5->bridge_mask))
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
+	u16 vid;
+	u32 cfg2;
+	int ret;
+
+	/* Reset MAC entyry flags */
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
index 4b43e3212658..6994bb7580cb 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
@@ -277,7 +277,8 @@ static int sparx5_create_port(struct sparx5 *sparx5,
 	}
 	spx5_port->conf = config->conf;
 
-	/* VLAN support to be added in later patches */
+	/* Setup VLAN */
+	sparx5_vlan_port_setup(sparx5, spx5_port->portno);
 
 	/* Create a phylink for PHY management.  Also handles SFPs */
 	spx5_port->phylink_config.dev = &spx5_port->ndev->dev;
@@ -556,6 +557,8 @@ static void sparx5_board_init(struct sparx5 *sparx5)
 
 static int sparx5_start(struct sparx5 *sparx5)
 {
+	u8 broadcast[ETH_ALEN] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
+	char queue_name[32];
 	u32 idx;
 	int err;
 
@@ -575,7 +578,9 @@ static int sparx5_start(struct sparx5 *sparx5)
 			 QFWD_SWITCH_PORT_MODE(idx));
 	}
 
-	/* Forwarding masks to be added in later patches */
+	/* Init masks */
+	sparx5_update_fwd(sparx5);
+
 	/* CPU copy CPU pgids */
 	spx5_wr(ANA_AC_PGID_MISC_CFG_PGID_CPU_COPY_ENA_SET(1),
 		sparx5, ANA_AC_PGID_MISC_CFG(PGID_CPU));
@@ -588,19 +593,38 @@ static int sparx5_start(struct sparx5 *sparx5)
 			 ANA_CL_FILTER_CTRL_FORCE_FCS_UPDATE_ENA,
 			 sparx5, ANA_CL_FILTER_CTRL(idx));
 
-	/* MAC/VLAN support to be added in later patches */
+	/* Init MAC table, ageing */
+	sparx5_mact_init(sparx5);
+
+	/* Setup VLANs */
+	sparx5_vlan_init(sparx5);
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
 
 	sparx5_board_init(sparx5);
+	err = sparx5_register_notifier_blocks(sparx5);
 
-	return 0;
+	return err;
 }
 
 static void sparx5_cleanup_ports(struct sparx5 *sparx5)
@@ -608,7 +632,10 @@ static void sparx5_cleanup_ports(struct sparx5 *sparx5)
 	int idx;
 
 	for (idx = 0; idx < SPX5_PORTS; ++idx) {
-		/* Port clean to be added in later patches */
+		struct sparx5_port *port = sparx5->ports[idx];
+
+		if (port && port->ndev)
+			sparx5_destroy_netdev(sparx5, port);
 	}
 }
 
@@ -785,6 +812,9 @@ static int mchp_sparx5_remove(struct platform_device *pdev)
 	struct sparx5 *sparx5 = platform_get_drvdata(pdev);
 
 	sparx5_cleanup_ports(sparx5);
+	/* Unregister netdevs */
+	sparx5_unregister_notifier_blocks(sparx5);
+
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_main.h b/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
index 2627af7e023b..d0a7f5902346 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
@@ -130,16 +130,67 @@ struct sparx5 {
 	/* port structures are in net device */
 	struct sparx5_port                    *ports[SPX5_PORTS];
 	enum sparx5_core_clockfreq            coreclock;
+	/* Notifiers */
+	struct notifier_block                 netdevice_nb;
+	struct notifier_block                 switchdev_nb;
+	struct notifier_block                 switchdev_blocking_nb;
+	/* Switch state */
 	u8                                    base_mac[ETH_ALEN];
+	/* Associated bridge device (when bridged) */
+	struct net_device                     *hw_bridge_dev;
+	/* Bridged interfaces */
+	DECLARE_BITMAP(bridge_mask,           SPX5_PORTS);
+	DECLARE_BITMAP(bridge_fwd_mask,       SPX5_PORTS);
+	DECLARE_BITMAP(bridge_lrn_mask,       SPX5_PORTS);
+	DECLARE_BITMAP(vlan_mask[VLAN_N_VID], SPX5_PORTS);
+	/* SW MAC table */
+	struct list_head                      mact_entries;
+	/* mac table list (mact_entries) mutex */
+	struct mutex                          mact_lock;
+	struct delayed_work                   mact_work;
+	struct workqueue_struct               *mact_queue;
 	/* Board specifics */
 	bool                                  sd_sgpio_remapping;
 };
 
+/* sparx5_switchdev.c */
+int sparx5_register_notifier_blocks(struct sparx5 *sparx5);
+void sparx5_unregister_notifier_blocks(struct sparx5 *sparx5);
+
 /* sparx5_packet.c */
 irqreturn_t sparx5_xtr_handler(int irq, void *_priv);
 int sparx5_port_xmit_impl(struct sk_buff *skb, struct net_device *dev);
 void sparx5_manual_injection_mode(struct sparx5 *sparx5);
 
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
+/* sparx5_vlan.c */
+void sparx5_pgid_update_mask(struct sparx5_port *port, int pgid, bool enable);
+void sparx5_update_fwd(struct sparx5 *sparx5);
+void sparx5_vlan_init(struct sparx5 *sparx5);
+void sparx5_vlan_port_setup(struct sparx5 *sparx5, int portno);
+int sparx5_vlan_vid_add(struct sparx5_port *port, u16 vid, bool pvid,
+			bool untagged);
+int sparx5_vlan_vid_del(struct sparx5_port *port, u16 vid);
+void sparx5_vlan_port_apply(struct sparx5 *sparx5, struct sparx5_port *port);
+
 /* sparx5_netdev.c */
 bool sparx5_netdevice_check(const struct net_device *dev);
 struct net_device *sparx5_create_netdev(struct sparx5 *sparx5, u32 portno);
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_netdev.c b/drivers/net/ethernet/microchip/sparx5/sparx5_netdev.c
index 879994668c23..cf9dc7a340cb 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_netdev.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_netdev.c
@@ -117,6 +117,15 @@ static int sparx5_port_stop(struct net_device *ndev)
 	return 0;
 }
 
+static void sparx5_set_rx_mode(struct net_device *dev)
+{
+	struct sparx5_port *port = netdev_priv(dev);
+	struct sparx5 *sparx5 = port->sparx5;
+
+	if (!test_bit(port->portno, sparx5->bridge_mask))
+		__dev_mc_sync(dev, sparx5_mc_sync, sparx5_mc_unsync);
+}
+
 static int sparx5_port_get_phys_port_name(struct net_device *dev,
 					  char *buf, size_t len)
 {
@@ -132,21 +141,43 @@ static int sparx5_port_get_phys_port_name(struct net_device *dev,
 
 static int sparx5_set_mac_address(struct net_device *dev, void *p)
 {
+	struct sparx5_port *port = netdev_priv(dev);
+	struct sparx5 *sparx5 = port->sparx5;
 	const struct sockaddr *addr = p;
 
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
 	.ndo_start_xmit         = sparx5_port_xmit_impl,
+	.ndo_set_rx_mode        = sparx5_set_rx_mode,
 	.ndo_get_phys_port_name = sparx5_port_get_phys_port_name,
 	.ndo_set_mac_address    = sparx5_set_mac_address,
 	.ndo_validate_addr      = eth_validate_addr,
+	.ndo_get_port_parent_id = sparx5_get_port_parent_id,
 };
 
 bool sparx5_netdevice_check(const struct net_device *dev)
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_packet.c b/drivers/net/ethernet/microchip/sparx5/sparx5_packet.c
index 22177134e1cc..8db9fa24beb2 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_packet.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_packet.c
@@ -146,6 +146,12 @@ static void sparx5_xtr_grp(struct sparx5 *sparx5, u8 grp, bool byte_swap)
 	}
 #endif
 
+	/* Everything we see on an interface that is in the HW bridge
+	 * has already been forwarded
+	 */
+	if (test_bit(port->portno, sparx5->bridge_mask))
+		skb->offload_fwd_mark = 1;
+
 	/* Finish up skb */
 	skb_put(skb, byte_cnt - ETH_FCS_LEN);
 	eth_skb_pad(skb);
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c b/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c
new file mode 100644
index 000000000000..1aa9955a2e16
--- /dev/null
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c
@@ -0,0 +1,517 @@
+// SPDX-License-Identifier: GPL-2.0+
+/* Microchip Sparx5 Switch driver
+ *
+ * Copyright (c) 2020 Microchip Technology Inc. and its subsidiaries.
+ */
+
+#include <linux/if_bridge.h>
+#include <net/switchdev.h>
+
+#include "sparx5_main_regs.h"
+#include "sparx5_main.h"
+
+static struct workqueue_struct *sparx5_owq;
+
+struct sparx5_switchdev_event_work {
+	struct work_struct work;
+	struct switchdev_notifier_fdb_info fdb_info;
+	struct net_device *dev;
+	unsigned long event;
+};
+
+static void sparx5_port_attr_bridge_flags(struct sparx5_port *port,
+					  unsigned long flags)
+{
+	sparx5_pgid_update_mask(port, PGID_MC_FLOOD, flags & BR_MCAST_FLOOD);
+}
+
+static void sparx5_attr_stp_state_set(struct sparx5_port *port,
+				      struct switchdev_trans *trans,
+				      u8 state)
+{
+	struct sparx5 *sparx5 = port->sparx5;
+
+	if (!test_bit(port->portno, sparx5->bridge_mask)) {
+		netdev_err(port->ndev,
+			   "Controlling non-bridged port %d?\n", port->portno);
+		return;
+	}
+
+	switch (state) {
+	case BR_STATE_FORWARDING:
+		set_bit(port->portno, sparx5->bridge_fwd_mask);
+		fallthrough;
+	case BR_STATE_LEARNING:
+		set_bit(port->portno, sparx5->bridge_lrn_mask);
+		break;
+
+	default:
+		/* All other states treated as blocking */
+		clear_bit(port->portno, sparx5->bridge_fwd_mask);
+		clear_bit(port->portno, sparx5->bridge_lrn_mask);
+		break;
+	}
+
+	/* apply the bridge_fwd_mask to all the ports */
+	sparx5_update_fwd(sparx5);
+}
+
+static void sparx5_port_attr_ageing_set(struct sparx5_port *port,
+					unsigned long ageing_clock_t)
+{
+	unsigned long ageing_jiffies = clock_t_to_jiffies(ageing_clock_t);
+	u32 ageing_time = jiffies_to_msecs(ageing_jiffies);
+
+	sparx5_set_ageing(port->sparx5, ageing_time);
+}
+
+static int sparx5_port_attr_set(struct net_device *dev,
+				const struct switchdev_attr *attr,
+				struct switchdev_trans *trans)
+{
+	struct sparx5_port *port = netdev_priv(dev);
+
+	if (switchdev_trans_ph_prepare(trans))
+		return 0;
+
+	switch (attr->id) {
+	case SWITCHDEV_ATTR_ID_PORT_BRIDGE_FLAGS:
+		sparx5_port_attr_bridge_flags(port, attr->u.brport_flags);
+		break;
+	case SWITCHDEV_ATTR_ID_PORT_STP_STATE:
+		sparx5_attr_stp_state_set(port, trans, attr->u.stp_state);
+		break;
+	case SWITCHDEV_ATTR_ID_BRIDGE_AGEING_TIME:
+		sparx5_port_attr_ageing_set(port, attr->u.ageing_time);
+		break;
+	case SWITCHDEV_ATTR_ID_BRIDGE_VLAN_FILTERING:
+		port->vlan_aware = attr->u.vlan_filtering;
+		sparx5_vlan_port_apply(port->sparx5, port);
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
+static int sparx5_port_bridge_join(struct sparx5_port *port,
+				   struct net_device *bridge)
+{
+	struct sparx5 *sparx5 = port->sparx5;
+
+	if (bitmap_empty(sparx5->bridge_mask, SPX5_PORTS))
+		/* First bridged port */
+		sparx5->hw_bridge_dev = bridge;
+	else
+		if (sparx5->hw_bridge_dev != bridge)
+			/* This is adding the port to a second bridge, this is
+			 * unsupported
+			 */
+			return -ENODEV;
+
+	set_bit(port->portno, sparx5->bridge_mask);
+
+	/* Port enters in bridge mode therefor don't need to copy to CPU
+	 * frames for multicast in case the bridge is not requesting them
+	 */
+	__dev_mc_unsync(port->ndev, sparx5_mc_unsync);
+
+	return 0;
+}
+
+static void sparx5_port_bridge_leave(struct sparx5_port *port,
+				     struct net_device *bridge)
+{
+	struct sparx5 *sparx5 = port->sparx5;
+
+	clear_bit(port->portno, sparx5->bridge_mask);
+	if (bitmap_empty(sparx5->bridge_mask, SPX5_PORTS))
+		sparx5->hw_bridge_dev = NULL;
+
+	/* Clear bridge vlan settings before updating the port settings */
+	port->vlan_aware = 0;
+	port->pvid = NULL_VID;
+	port->vid = NULL_VID;
+
+	/* Port enters in host more therefore restore mc list */
+	__dev_mc_sync(port->ndev, sparx5_mc_sync, sparx5_mc_unsync);
+}
+
+static int sparx5_port_changeupper(struct net_device *dev,
+				   struct netdev_notifier_changeupper_info *info)
+{
+	struct sparx5_port *port = netdev_priv(dev);
+	int err = 0;
+
+	if (netif_is_bridge_master(info->upper_dev)) {
+		if (info->linking)
+			err = sparx5_port_bridge_join(port, info->upper_dev);
+		else
+			sparx5_port_bridge_leave(port, info->upper_dev);
+
+		sparx5_vlan_port_apply(port->sparx5, port);
+	}
+
+	return err;
+}
+
+static int sparx5_port_add_addr(struct net_device *dev, bool up)
+{
+	struct sparx5_port *port = netdev_priv(dev);
+	struct sparx5 *sparx5 = port->sparx5;
+	u16 vid = port->pvid;
+
+	if (up)
+		sparx5_mact_learn(sparx5, PGID_CPU, port->ndev->dev_addr, vid);
+	else
+		sparx5_mact_forget(sparx5, port->ndev->dev_addr, vid);
+
+	return 0;
+}
+
+static int sparx5_netdevice_port_event(struct net_device *dev,
+				       struct notifier_block *nb,
+				       unsigned long event, void *ptr)
+{
+	int err = 0;
+
+	if (!sparx5_netdevice_check(dev))
+		return 0;
+
+	switch (event) {
+	case NETDEV_CHANGEUPPER:
+		err = sparx5_port_changeupper(dev, ptr);
+		break;
+	case NETDEV_PRE_UP:
+		err = sparx5_port_add_addr(dev, true);
+		break;
+	case NETDEV_DOWN:
+		err = sparx5_port_add_addr(dev, false);
+		break;
+	}
+
+	return err;
+}
+
+static int sparx5_netdevice_event(struct notifier_block *nb,
+				  unsigned long event, void *ptr)
+{
+	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
+	int ret = 0;
+
+	ret = sparx5_netdevice_port_event(dev, nb, event, ptr);
+
+	return notifier_from_errno(ret);
+}
+
+static void sparx5_switchdev_bridge_fdb_event_work(struct work_struct *work)
+{
+	struct sparx5_switchdev_event_work *switchdev_work =
+		container_of(work, struct sparx5_switchdev_event_work, work);
+	struct net_device *dev = switchdev_work->dev;
+	struct switchdev_notifier_fdb_info *fdb_info;
+	struct sparx5_port *port;
+	struct sparx5 *sparx5;
+
+	rtnl_lock();
+	if (!sparx5_netdevice_check(dev))
+		goto out;
+
+	port = netdev_priv(dev);
+	sparx5 = port->sparx5;
+
+	fdb_info = &switchdev_work->fdb_info;
+
+	switch (switchdev_work->event) {
+	case SWITCHDEV_FDB_ADD_TO_DEVICE:
+		sparx5_add_mact_entry(sparx5, port, fdb_info->addr,
+				      fdb_info->vid);
+		break;
+	case SWITCHDEV_FDB_DEL_TO_DEVICE:
+		sparx5_del_mact_entry(sparx5, fdb_info->addr, fdb_info->vid);
+		break;
+	}
+
+out:
+	rtnl_unlock();
+	kfree(switchdev_work->fdb_info.addr);
+	kfree(switchdev_work);
+	dev_put(dev);
+}
+
+static void sparx5_schedule_work(struct work_struct *work)
+{
+	queue_work(sparx5_owq, work);
+}
+
+static int sparx5_switchdev_event(struct notifier_block *unused,
+				  unsigned long event, void *ptr)
+{
+	struct net_device *dev = switchdev_notifier_info_to_dev(ptr);
+	struct sparx5_switchdev_event_work *switchdev_work;
+	struct switchdev_notifier_fdb_info *fdb_info;
+	struct switchdev_notifier_info *info = ptr;
+	int err;
+
+	switch (event) {
+	case SWITCHDEV_PORT_ATTR_SET:
+		err = switchdev_handle_port_attr_set(dev, ptr,
+						     sparx5_netdevice_check,
+						     sparx5_port_attr_set);
+		return notifier_from_errno(err);
+	case SWITCHDEV_FDB_ADD_TO_DEVICE:
+		fallthrough;
+	case SWITCHDEV_FDB_DEL_TO_DEVICE:
+		switchdev_work = kzalloc(sizeof(*switchdev_work), GFP_ATOMIC);
+		if (!switchdev_work)
+			return NOTIFY_BAD;
+
+		switchdev_work->dev = dev;
+		switchdev_work->event = event;
+
+		fdb_info = container_of(info,
+					struct switchdev_notifier_fdb_info,
+					info);
+		INIT_WORK(&switchdev_work->work,
+			  sparx5_switchdev_bridge_fdb_event_work);
+		memcpy(&switchdev_work->fdb_info, ptr,
+		       sizeof(switchdev_work->fdb_info));
+		switchdev_work->fdb_info.addr = kzalloc(ETH_ALEN, GFP_ATOMIC);
+		if (!switchdev_work->fdb_info.addr)
+			goto err_addr_alloc;
+
+		ether_addr_copy((u8 *)switchdev_work->fdb_info.addr,
+				fdb_info->addr);
+		dev_hold(dev);
+
+		sparx5_schedule_work(&switchdev_work->work);
+		break;
+	}
+
+	return NOTIFY_DONE;
+err_addr_alloc:
+	kfree(switchdev_work);
+	return NOTIFY_BAD;
+}
+
+static void sparx5_sync_port_dev_addr(struct sparx5 *sparx5,
+				      struct sparx5_port *port,
+				      u16 vid, bool add)
+{
+	if (!port ||
+	    !test_bit(port->portno, sparx5->bridge_mask))
+		return; /* Skip null/host interfaces */
+
+	/* Bridge connects to vid? */
+	if (add) {
+		/* Add port MAC address from the VLAN */
+		sparx5_mact_learn(sparx5, PGID_CPU,
+				  port->ndev->dev_addr, vid);
+	} else {
+		/* Control port addr visibility depending on
+		 * port VLAN connectivity.
+		 */
+		if (test_bit(port->portno, sparx5->vlan_mask[vid]))
+			sparx5_mact_learn(sparx5, PGID_CPU,
+					  port->ndev->dev_addr, vid);
+		else
+			sparx5_mact_forget(sparx5,
+					   port->ndev->dev_addr, vid);
+	}
+}
+
+static void sparx5_sync_bridge_dev_addr(struct net_device *dev,
+					struct sparx5 *sparx5,
+					u16 vid, bool add)
+{
+	int i;
+
+	/* First, handle bridge address'es */
+	if (add) {
+		sparx5_mact_learn(sparx5, PGID_CPU, dev->dev_addr,
+				  vid);
+		sparx5_mact_learn(sparx5, PGID_BCAST, dev->broadcast,
+				  vid);
+	} else {
+		sparx5_mact_forget(sparx5, dev->dev_addr, vid);
+		sparx5_mact_forget(sparx5, dev->broadcast, vid);
+	}
+
+	/* Now look at bridged ports */
+	for (i = 0; i < SPX5_PORTS; i++)
+		sparx5_sync_port_dev_addr(sparx5, sparx5->ports[i], vid, add);
+}
+
+static int sparx5_handle_port_vlan_add(struct net_device *dev,
+				       struct notifier_block *nb,
+				       const struct switchdev_obj_port_vlan *v,
+				       struct switchdev_trans *trans)
+{
+	struct sparx5_port *port = netdev_priv(dev);
+	int ret;
+	u16 vid;
+
+	if (switchdev_trans_ph_prepare(trans))
+		return 0;
+
+	if (netif_is_bridge_master(dev)) {
+		if (v->flags & BRIDGE_VLAN_INFO_BRENTRY) {
+			struct sparx5 *sparx5 =
+				container_of(nb, struct sparx5,
+					     switchdev_blocking_nb);
+
+			for (vid = v->vid_begin; vid <= v->vid_end; vid++)
+				sparx5_sync_bridge_dev_addr(dev, sparx5, vid, true);
+		}
+		return 0;
+	}
+
+	for (vid = v->vid_begin; vid <= v->vid_end; vid++) {
+		ret = sparx5_vlan_vid_add(port, vid,
+					  v->flags & BRIDGE_VLAN_INFO_PVID,
+					  v->flags & BRIDGE_VLAN_INFO_UNTAGGED);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+static int sparx5_handle_port_obj_add(struct net_device *dev,
+				      struct notifier_block *nb,
+				      struct switchdev_notifier_port_obj_info *info)
+{
+	const struct switchdev_obj *obj = info->obj;
+	int err;
+
+	switch (obj->id) {
+	case SWITCHDEV_OBJ_ID_PORT_VLAN:
+		err = sparx5_handle_port_vlan_add(dev, nb,
+						  SWITCHDEV_OBJ_PORT_VLAN(obj),
+						  info->trans);
+		break;
+	default:
+		err = -EOPNOTSUPP;
+		break;
+	}
+
+	info->handled = true;
+	return err;
+}
+
+static int sparx5_handle_port_vlan_del(struct net_device *dev,
+				       struct notifier_block *nb,
+				       const struct switchdev_obj_port_vlan *v,
+				       struct switchdev_trans *trans)
+{
+	struct sparx5_port *port = netdev_priv(dev);
+	int ret;
+	u16 vid;
+
+	/* Master bridge? */
+	if (netif_is_bridge_master(dev)) {
+		struct sparx5 *sparx5 = container_of(nb, struct sparx5,
+						     switchdev_blocking_nb);
+
+		for (vid = v->vid_begin; vid <= v->vid_end; vid++)
+			sparx5_sync_bridge_dev_addr(dev, sparx5, vid, false);
+		return 0;
+	}
+
+	for (vid = v->vid_begin; vid <= v->vid_end; vid++) {
+		ret = sparx5_vlan_vid_del(port, vid);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+static int sparx5_handle_port_obj_del(struct net_device *dev,
+				      struct notifier_block *nb,
+				      struct switchdev_notifier_port_obj_info *info)
+{
+	const struct switchdev_obj *obj = info->obj;
+	int err;
+
+	switch (obj->id) {
+	case SWITCHDEV_OBJ_ID_PORT_VLAN:
+		err = sparx5_handle_port_vlan_del(dev, nb,
+						  SWITCHDEV_OBJ_PORT_VLAN(obj),
+						  info->trans);
+		break;
+	default:
+		err = -EOPNOTSUPP;
+		break;
+	}
+
+	info->handled = true;
+	return err;
+}
+
+static int sparx5_switchdev_blocking_event(struct notifier_block *nb,
+					   unsigned long event,
+					   void *ptr)
+{
+	struct net_device *dev = switchdev_notifier_info_to_dev(ptr);
+	int err;
+
+	switch (event) {
+	case SWITCHDEV_PORT_OBJ_ADD:
+		err = sparx5_handle_port_obj_add(dev, nb, ptr);
+		return notifier_from_errno(err);
+	case SWITCHDEV_PORT_OBJ_DEL:
+		err = sparx5_handle_port_obj_del(dev, nb, ptr);
+		return notifier_from_errno(err);
+	case SWITCHDEV_PORT_ATTR_SET:
+		err = switchdev_handle_port_attr_set(dev, ptr,
+						     sparx5_netdevice_check,
+						     sparx5_port_attr_set);
+		return notifier_from_errno(err);
+	}
+
+	return NOTIFY_DONE;
+}
+
+int sparx5_register_notifier_blocks(struct sparx5 *s5)
+{
+	int err;
+
+	s5->netdevice_nb.notifier_call = sparx5_netdevice_event;
+	err = register_netdevice_notifier(&s5->netdevice_nb);
+	if (err)
+		return err;
+
+	s5->switchdev_nb.notifier_call = sparx5_switchdev_event;
+	err = register_switchdev_notifier(&s5->switchdev_nb);
+	if (err)
+		goto err_switchdev_nb;
+
+	s5->switchdev_blocking_nb.notifier_call = sparx5_switchdev_blocking_event;
+	err = register_switchdev_blocking_notifier(&s5->switchdev_blocking_nb);
+	if (err)
+		goto err_switchdev_blocking_nb;
+
+	sparx5_owq = alloc_ordered_workqueue("sparx5_order", 0);
+	if (!sparx5_owq)
+		goto err_switchdev_blocking_nb;
+
+	return 0;
+
+err_switchdev_blocking_nb:
+	unregister_switchdev_notifier(&s5->switchdev_nb);
+err_switchdev_nb:
+	unregister_netdevice_notifier(&s5->netdevice_nb);
+
+	return err;
+}
+
+void sparx5_unregister_notifier_blocks(struct sparx5 *s5)
+{
+	destroy_workqueue(sparx5_owq);
+
+	unregister_switchdev_blocking_notifier(&s5->switchdev_blocking_nb);
+	unregister_switchdev_notifier(&s5->switchdev_nb);
+	unregister_netdevice_notifier(&s5->netdevice_nb);
+}
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_vlan.c b/drivers/net/ethernet/microchip/sparx5/sparx5_vlan.c
new file mode 100644
index 000000000000..561987e6d8f3
--- /dev/null
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_vlan.c
@@ -0,0 +1,224 @@
+// SPDX-License-Identifier: GPL-2.0+
+/* Microchip Sparx5 Switch driver
+ *
+ * Copyright (c) 2020 Microchip Technology Inc. and its subsidiaries.
+ */
+
+#include "sparx5_main_regs.h"
+#include "sparx5_main.h"
+
+static int sparx5_vlant_set_mask(struct sparx5 *sparx5, u16 vid)
+{
+	u32 mask[3];
+
+	/* Divide up mask in 32 bit words */
+	bitmap_to_arr32(mask, sparx5->vlan_mask[vid], SPX5_PORTS);
+
+	/* Output mask to respective registers */
+	spx5_wr(mask[0], sparx5, ANA_L3_VLAN_MASK_CFG(vid));
+	spx5_wr(mask[1], sparx5, ANA_L3_VLAN_MASK_CFG1(vid));
+	spx5_wr(mask[2], sparx5, ANA_L3_VLAN_MASK_CFG2(vid));
+
+	return 0;
+}
+
+void sparx5_vlan_init(struct sparx5 *sparx5)
+{
+	u16 vid;
+
+	spx5_rmw(ANA_L3_VLAN_CTRL_VLAN_ENA_SET(1),
+		 ANA_L3_VLAN_CTRL_VLAN_ENA,
+		 sparx5,
+		 ANA_L3_VLAN_CTRL);
+
+	/* Map VLAN = FID */
+	for (vid = NULL_VID; vid < VLAN_N_VID; vid++)
+		spx5_rmw(ANA_L3_VLAN_CFG_VLAN_FID_SET(vid),
+			 ANA_L3_VLAN_CFG_VLAN_FID,
+			 sparx5,
+			 ANA_L3_VLAN_CFG(vid));
+}
+
+void sparx5_vlan_port_setup(struct sparx5 *sparx5, int portno)
+{
+	struct sparx5_port *port = sparx5->ports[portno];
+
+	/* Configure PVID */
+	spx5_rmw(ANA_CL_VLAN_CTRL_VLAN_AWARE_ENA_SET(0) |
+		 ANA_CL_VLAN_CTRL_PORT_VID_SET(port->pvid),
+		 ANA_CL_VLAN_CTRL_VLAN_AWARE_ENA |
+		 ANA_CL_VLAN_CTRL_PORT_VID,
+		 sparx5,
+		 ANA_CL_VLAN_CTRL(port->portno));
+}
+
+int sparx5_vlan_vid_add(struct sparx5_port *port, u16 vid, bool pvid,
+			bool untagged)
+{
+	struct sparx5 *sparx5 = port->sparx5;
+	int ret;
+
+	/* Make the port a member of the VLAN */
+	set_bit(port->portno, sparx5->vlan_mask[vid]);
+	ret = sparx5_vlant_set_mask(sparx5, vid);
+	if (ret)
+		return ret;
+
+	/* Default ingress vlan classification */
+	if (pvid)
+		port->pvid = vid;
+
+	/* Untagged egress vlan classification */
+	if (untagged && port->vid != vid) {
+		if (port->vid) {
+			netdev_err(port->ndev,
+				   "Port already has a native VLAN: %d\n",
+				   port->vid);
+			return -EBUSY;
+		}
+		port->vid = vid;
+	}
+
+	sparx5_vlan_port_apply(sparx5, port);
+
+	return 0;
+}
+
+int sparx5_vlan_vid_del(struct sparx5_port *port, u16 vid)
+{
+	struct sparx5 *sparx5 = port->sparx5;
+	int ret;
+
+	/* 8021q removes VID 0 on module unload for all interfaces
+	 * with VLAN filtering feature. We need to keep it to receive
+	 * untagged traffic.
+	 */
+	if (vid == 0)
+		return 0;
+
+	/* Stop the port from being a member of the vlan */
+	clear_bit(port->portno, sparx5->vlan_mask[vid]);
+	ret = sparx5_vlant_set_mask(sparx5, vid);
+	if (ret)
+		return ret;
+
+	/* Ingress */
+	if (port->pvid == vid)
+		port->pvid = 0;
+
+	/* Egress */
+	if (port->vid == vid)
+		port->vid = 0;
+
+	sparx5_vlan_port_apply(sparx5, port);
+
+	return 0;
+}
+
+void sparx5_pgid_update_mask(struct sparx5_port *port, int pgid, bool enable)
+{
+	struct sparx5 *sparx5 = port->sparx5;
+	u32 val, mask;
+
+	/* mask is spread across 3 registers x 32 bit */
+	if (port->portno < 32) {
+		mask = BIT(port->portno);
+		val = enable ? mask : 0;
+		spx5_rmw(val, mask, sparx5, ANA_AC_PGID_CFG(pgid));
+	} else if (port->portno < 64) {
+		mask = BIT(port->portno - 32);
+		val = enable ? mask : 0;
+		spx5_rmw(val, mask, sparx5, ANA_AC_PGID_CFG1(pgid));
+	} else if (port->portno < SPX5_PORTS) {
+		mask = BIT(port->portno - 64);
+		val = enable ? mask : 0;
+		spx5_rmw(val, mask, sparx5, ANA_AC_PGID_CFG2(pgid));
+	} else {
+		netdev_err(port->ndev, "Invalid port no: %d\n", port->portno);
+	}
+}
+
+void sparx5_update_fwd(struct sparx5 *sparx5)
+{
+	u32 mask[3];
+	DECLARE_BITMAP(workmask, SPX5_PORTS);
+	int port;
+
+	/* Divide up fwd mask in 32 bit words */
+	bitmap_to_arr32(mask, sparx5->bridge_fwd_mask, SPX5_PORTS);
+
+	/* Update flood masks */
+	for (port = PGID_UC_FLOOD; port <= PGID_BCAST; port++) {
+		spx5_wr(mask[0], sparx5, ANA_AC_PGID_CFG(port));
+		spx5_wr(mask[1], sparx5, ANA_AC_PGID_CFG1(port));
+		spx5_wr(mask[2], sparx5, ANA_AC_PGID_CFG2(port));
+	}
+
+	/* Update SRC masks */
+	for (port = 0; port < SPX5_PORTS; port++) {
+		if (test_bit(port, sparx5->bridge_fwd_mask)) {
+			/* Allow to send to all bridged but self */
+			bitmap_copy(workmask, sparx5->bridge_fwd_mask, SPX5_PORTS);
+			clear_bit(port, workmask);
+			bitmap_to_arr32(mask, workmask, SPX5_PORTS);
+			spx5_wr(mask[0], sparx5, ANA_AC_SRC_CFG(port));
+			spx5_wr(mask[1], sparx5, ANA_AC_SRC_CFG1(port));
+			spx5_wr(mask[2], sparx5, ANA_AC_SRC_CFG2(port));
+		} else {
+			spx5_wr(0, sparx5, ANA_AC_SRC_CFG(port));
+			spx5_wr(0, sparx5, ANA_AC_SRC_CFG1(port));
+			spx5_wr(0, sparx5, ANA_AC_SRC_CFG2(port));
+		}
+	}
+
+	/* Learning enabled only for bridged ports */
+	bitmap_and(workmask, sparx5->bridge_fwd_mask,
+		   sparx5->bridge_lrn_mask, SPX5_PORTS);
+	bitmap_to_arr32(mask, workmask, SPX5_PORTS);
+
+	/* Apply learning mask */
+	spx5_wr(mask[0], sparx5, ANA_L2_AUTO_LRN_CFG);
+	spx5_wr(mask[1], sparx5, ANA_L2_AUTO_LRN_CFG1);
+	spx5_wr(mask[2], sparx5, ANA_L2_AUTO_LRN_CFG2);
+}
+
+void sparx5_vlan_port_apply(struct sparx5 *sparx5,
+			    struct sparx5_port *port)
+
+{
+	u32 val;
+
+	/* Configure PVID, vlan aware */
+	val = ANA_CL_VLAN_CTRL_VLAN_AWARE_ENA_SET(port->vlan_aware) |
+		ANA_CL_VLAN_CTRL_VLAN_POP_CNT_SET(port->vlan_aware) |
+		ANA_CL_VLAN_CTRL_PORT_VID_SET(port->pvid);
+	spx5_wr(val, sparx5, ANA_CL_VLAN_CTRL(port->portno));
+
+	val = 0;
+	if (port->vlan_aware && !port->pvid)
+		/* If port is vlan-aware and tagged, drop untagged and
+		 * priority tagged frames.
+		 */
+		val = ANA_CL_VLAN_FILTER_CTRL_TAG_REQUIRED_ENA_SET(1) |
+			ANA_CL_VLAN_FILTER_CTRL_PRIO_CTAG_DIS_SET(1) |
+			ANA_CL_VLAN_FILTER_CTRL_PRIO_STAG_DIS_SET(1);
+	spx5_wr(val, sparx5,
+		ANA_CL_VLAN_FILTER_CTRL(port->portno, 0));
+
+	/* Egress configuration (REW_TAG_CFG): VLAN tag type to 8021Q */
+	val = REW_TAG_CTRL_TAG_TPID_CFG_SET(0);
+	if (port->vlan_aware) {
+		if (port->vid)
+			/* Tag all frames except when VID == DEFAULT_VLAN */
+			val |= REW_TAG_CTRL_TAG_CFG_SET(1);
+		else
+			val |= REW_TAG_CTRL_TAG_CFG_SET(3);
+	}
+	spx5_wr(val, sparx5, REW_TAG_CTRL(port->portno));
+
+	/* Egress VID */
+	spx5_rmw(REW_PORT_VLAN_CFG_PORT_VID_SET(port->vid),
+		 REW_PORT_VLAN_CFG_PORT_VID,
+		 sparx5,
+		 REW_PORT_VLAN_CFG(port->portno));
+}
-- 
2.29.2

