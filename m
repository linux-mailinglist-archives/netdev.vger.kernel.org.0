Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 901C748449D
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 16:31:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234813AbiADPbl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 10:31:41 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:42916 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233405AbiADPbi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 10:31:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1641310298; x=1672846298;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wz87y+ztG2bWArS0xQoXTtT93cnb/jODDODPY2/bi7s=;
  b=RwQN5gWVyVZ3f110fFWEW5B35O9gQsyC0WfyqdEzC90r9EKsd8oDXv+o
   emncuqFbfrpBUAiYcv50kLLL32ReIlBJfr8Vg6kP4f8GTugBMcO4egj1R
   iAKZg1+BJx3oZk7EiqaDfLt5FadLqscfLk+h0AK4oVA5vAWAqfsLlXwB3
   uTmGsKFY5+q2MzDv/PTYIPPDBP0erWtyyQp0S8Lqgh7FqonzB0TsfXAJO
   u0Kj6O0S9S99ldJPBdZqA2PxaduoXneEafRmDg9M2f1GxOpbGdL+eKG4P
   i5g9WNEFPhDUkgNCTQfZ0E6KMM8NZ0G9W9PRULDMmhvAyPVgolGqYGgn9
   A==;
IronPort-SDR: dEDPE0kovWnaqSzHwpWfUFQ37AjT171edirFU5cfHyYCsiyzsdjW6JX+iNU7P6WMkqEtxNdNY8
 UgWXZkP+erU4ePKiUVejWEI0ygkD3k9hUUSR5/U9hdM/TqHVGk3ij0ELsJHGpFJ4BUADl8Hhj0
 t970e5DMQkdoeVwgvBX7mNrh1diTRJrSgkSk+7BsTPcgRNKuGNo0KXi35bSSGy0ADm0gfhras+
 nl6pkCTYNK7tNOFYWLShOkiPo7sXE/jCGLGhz23bpFeZCqwufNxgFlPaDTAVvWCxW0U9l3wuUp
 lj9KRF7Uu2ydZymTRpgcCvzz
X-IronPort-AV: E=Sophos;i="5.88,261,1635231600"; 
   d="scan'208";a="157467738"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 Jan 2022 08:31:36 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 4 Jan 2022 08:31:35 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Tue, 4 Jan 2022 08:31:33 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <f.fainelli@gmail.com>,
        <vivien.didelot@gmail.com>, <vladimir.oltean@nxp.com>,
        <andrew@lunn.ch>, Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v3 3/3] net: lan966x: Extend switchdev with mdb support
Date:   Tue, 4 Jan 2022 16:33:38 +0100
Message-ID: <20220104153338.425250-4-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220104153338.425250-1-horatiu.vultur@microchip.com>
References: <20220104153338.425250-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extend lan966x driver with mdb support by implementing the switchdev
calls: SWITCHDEV_OBJ_ID_PORT_MDB and SWITCHDEV_OBJ_ID_HOST_MDB.
It is allowed to add both ipv4/ipv6 entries and l2 entries. To add
ipv4/ipv6 entries is not required to use the PGID table while for l2
entries it is required. The PGID table is much smaller than MAC table
so only fewer l2 entries can be added.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 .../net/ethernet/microchip/lan966x/Makefile   |   2 +-
 .../ethernet/microchip/lan966x/lan966x_main.c |   2 +
 .../ethernet/microchip/lan966x/lan966x_main.h |  13 +
 .../ethernet/microchip/lan966x/lan966x_mdb.c  | 506 ++++++++++++++++++
 .../microchip/lan966x/lan966x_switchdev.c     |   8 +
 .../ethernet/microchip/lan966x/lan966x_vlan.c |   7 +-
 6 files changed, 536 insertions(+), 2 deletions(-)
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_mdb.c

diff --git a/drivers/net/ethernet/microchip/lan966x/Makefile b/drivers/net/ethernet/microchip/lan966x/Makefile
index ec1a1fa8b0d5..040cfff9f577 100644
--- a/drivers/net/ethernet/microchip/lan966x/Makefile
+++ b/drivers/net/ethernet/microchip/lan966x/Makefile
@@ -7,4 +7,4 @@ obj-$(CONFIG_LAN966X_SWITCH) += lan966x-switch.o
 
 lan966x-switch-objs  := lan966x_main.o lan966x_phylink.o lan966x_port.o \
 			lan966x_mac.o lan966x_ethtool.o lan966x_switchdev.o \
-			lan966x_vlan.o lan966x_fdb.o
+			lan966x_vlan.o lan966x_fdb.o lan966x_mdb.o
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
index 2c6bf7b0afdf..2cb70da63db3 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
@@ -926,6 +926,7 @@ static int lan966x_probe(struct platform_device *pdev)
 		lan966x_port_init(lan966x->ports[p]);
 	}
 
+	lan966x_mdb_init(lan966x);
 	err = lan966x_fdb_init(lan966x);
 	if (err)
 		goto cleanup_ports;
@@ -955,6 +956,7 @@ static int lan966x_remove(struct platform_device *pdev)
 	mutex_destroy(&lan966x->stats_lock);
 
 	lan966x_mac_purge_entries(lan966x);
+	lan966x_mdb_deinit(lan966x);
 	lan966x_fdb_deinit(lan966x);
 
 	return 0;
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
index 367c2afe84a6..99c6d0a9f946 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
@@ -109,6 +109,10 @@ struct lan966x {
 	/* worqueue for fdb */
 	struct workqueue_struct *fdb_work;
 	struct list_head fdb_entries;
+
+	/* mdb */
+	struct list_head mdb_entries;
+	struct list_head pgid_entries;
 };
 
 struct lan966x_port_config {
@@ -215,6 +219,15 @@ int lan966x_handle_fdb(struct net_device *dev,
 		       unsigned long event, const void *ctx,
 		       const struct switchdev_notifier_fdb_info *fdb_info);
 
+void lan966x_mdb_init(struct lan966x *lan966x);
+void lan966x_mdb_deinit(struct lan966x *lan966x);
+int lan966x_handle_port_mdb_add(struct lan966x_port *port,
+				const struct switchdev_obj *obj);
+int lan966x_handle_port_mdb_del(struct lan966x_port *port,
+				const struct switchdev_obj *obj);
+void lan966x_mdb_erase_entries(struct lan966x *lan966x, u16 vid);
+void lan966x_mdb_write_entries(struct lan966x *lan966x, u16 vid);
+
 static inline void __iomem *lan_addr(void __iomem *base[],
 				     int id, int tinst, int tcnt,
 				     int gbase, int ginst,
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_mdb.c b/drivers/net/ethernet/microchip/lan966x/lan966x_mdb.c
new file mode 100644
index 000000000000..c68d0a99d292
--- /dev/null
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_mdb.c
@@ -0,0 +1,506 @@
+// SPDX-License-Identifier: GPL-2.0+
+
+#include <net/switchdev.h>
+
+#include "lan966x_main.h"
+
+struct lan966x_pgid_entry {
+	struct list_head list;
+	int index;
+	refcount_t refcount;
+	u16 ports;
+};
+
+struct lan966x_mdb_entry {
+	struct list_head list;
+	unsigned char mac[ETH_ALEN];
+	u16 vid;
+	u16 ports;
+	struct lan966x_pgid_entry *pgid;
+	u8 cpu_copy;
+};
+
+void lan966x_mdb_init(struct lan966x *lan966x)
+{
+	INIT_LIST_HEAD(&lan966x->mdb_entries);
+	INIT_LIST_HEAD(&lan966x->pgid_entries);
+}
+
+static void lan966x_mdb_purge_mdb_entries(struct lan966x *lan966x)
+{
+	struct lan966x_mdb_entry *mdb_entry, *tmp;
+
+	list_for_each_entry_safe(mdb_entry, tmp, &lan966x->mdb_entries, list) {
+		list_del(&mdb_entry->list);
+		kfree(mdb_entry);
+	}
+}
+
+static void lan966x_mdb_purge_pgid_entries(struct lan966x *lan966x)
+{
+	struct lan966x_pgid_entry *pgid_entry, *tmp;
+
+	list_for_each_entry_safe(pgid_entry, tmp, &lan966x->pgid_entries, list) {
+		list_del(&pgid_entry->list);
+		kfree(pgid_entry);
+	}
+}
+
+void lan966x_mdb_deinit(struct lan966x *lan966x)
+{
+	lan966x_mdb_purge_mdb_entries(lan966x);
+	lan966x_mdb_purge_pgid_entries(lan966x);
+}
+
+static struct lan966x_mdb_entry *
+lan966x_mdb_entry_get(struct lan966x *lan966x,
+		      const unsigned char *mac,
+		      u16 vid)
+{
+	struct lan966x_mdb_entry *mdb_entry;
+
+	list_for_each_entry(mdb_entry, &lan966x->mdb_entries, list) {
+		if (ether_addr_equal(mdb_entry->mac, mac) &&
+		    mdb_entry->vid == vid)
+			return mdb_entry;
+	}
+
+	return NULL;
+}
+
+static struct lan966x_mdb_entry *
+lan966x_mdb_entry_add(struct lan966x *lan966x,
+		      const struct switchdev_obj_port_mdb *mdb)
+{
+	struct lan966x_mdb_entry *mdb_entry;
+
+	mdb_entry = kzalloc(sizeof(*mdb_entry), GFP_KERNEL);
+	if (!mdb_entry)
+		return ERR_PTR(-ENOMEM);
+
+	ether_addr_copy(mdb_entry->mac, mdb->addr);
+	mdb_entry->vid = mdb->vid;
+
+	list_add_tail(&mdb_entry->list, &lan966x->mdb_entries);
+
+	return mdb_entry;
+}
+
+static void lan966x_mdb_encode_mac(unsigned char *mac,
+				   struct lan966x_mdb_entry *mdb_entry,
+				   enum macaccess_entry_type type)
+{
+	ether_addr_copy(mac, mdb_entry->mac);
+
+	if (type == ENTRYTYPE_MACV4) {
+		mac[0] = 0;
+		mac[1] = mdb_entry->ports >> 8;
+		mac[2] = mdb_entry->ports & 0xff;
+	} else if (type == ENTRYTYPE_MACV6) {
+		mac[0] = mdb_entry->ports >> 8;
+		mac[1] = mdb_entry->ports & 0xff;
+	}
+}
+
+static int lan966x_mdb_ip_add(struct lan966x_port *port,
+			      const struct switchdev_obj_port_mdb *mdb,
+			      enum macaccess_entry_type type)
+{
+	bool cpu_port = netif_is_bridge_master(mdb->obj.orig_dev);
+	struct lan966x *lan966x = port->lan966x;
+	struct lan966x_mdb_entry *mdb_entry;
+	unsigned char mac[ETH_ALEN];
+	bool cpu_copy = false;
+
+	mdb_entry = lan966x_mdb_entry_get(lan966x, mdb->addr, mdb->vid);
+	if (!mdb_entry) {
+		mdb_entry = lan966x_mdb_entry_add(lan966x, mdb);
+		if (IS_ERR(mdb_entry))
+			return PTR_ERR(mdb_entry);
+	} else {
+		lan966x_mdb_encode_mac(mac, mdb_entry, type);
+		lan966x_mac_forget(lan966x, mac, mdb_entry->vid, type);
+	}
+
+	if (cpu_port)
+		mdb_entry->cpu_copy++;
+	else
+		mdb_entry->ports |= BIT(port->chip_port);
+
+	/* Copy the frame to CPU only if the CPU is in the VLAN */
+	if (lan966x_vlan_cpu_member_cpu_vlan_mask(lan966x, mdb_entry->vid) &&
+	    mdb_entry->cpu_copy)
+		cpu_copy = true;
+
+	lan966x_mdb_encode_mac(mac, mdb_entry, type);
+	return lan966x_mac_ip_learn(lan966x, cpu_copy,
+				    mac, mdb_entry->vid, type);
+}
+
+static int lan966x_mdb_ip_del(struct lan966x_port *port,
+			      const struct switchdev_obj_port_mdb *mdb,
+			      enum macaccess_entry_type type)
+{
+	bool cpu_port = netif_is_bridge_master(mdb->obj.orig_dev);
+	struct lan966x *lan966x = port->lan966x;
+	struct lan966x_mdb_entry *mdb_entry;
+	unsigned char mac[ETH_ALEN];
+	u16 ports;
+
+	mdb_entry = lan966x_mdb_entry_get(lan966x, mdb->addr, mdb->vid);
+	if (!mdb_entry)
+		return -ENOENT;
+
+	ports = mdb_entry->ports;
+	if (cpu_port) {
+		/* If there are still other references to the CPU port then
+		 * there is no point to delete and add again the same entry
+		 */
+		mdb_entry->cpu_copy--;
+		if (mdb_entry->cpu_copy)
+			return 0;
+	} else {
+		ports &= ~BIT(port->chip_port);
+	}
+
+	lan966x_mdb_encode_mac(mac, mdb_entry, type);
+	lan966x_mac_forget(lan966x, mac, mdb_entry->vid, type);
+
+	mdb_entry->ports = ports;
+
+	if (!mdb_entry->ports && !mdb_entry->cpu_copy) {
+		list_del(&mdb_entry->list);
+		kfree(mdb_entry);
+		return 0;
+	}
+
+	lan966x_mdb_encode_mac(mac, mdb_entry, type);
+	return lan966x_mac_ip_learn(lan966x, mdb_entry->cpu_copy,
+				    mac, mdb_entry->vid, type);
+}
+
+static struct lan966x_pgid_entry *
+lan966x_pgid_entry_add(struct lan966x *lan966x, int index, u16 ports)
+{
+	struct lan966x_pgid_entry *pgid_entry;
+
+	pgid_entry = kzalloc(sizeof(*pgid_entry), GFP_KERNEL);
+	if (!pgid_entry)
+		return ERR_PTR(-ENOMEM);
+
+	pgid_entry->ports = ports;
+	pgid_entry->index = index;
+	refcount_set(&pgid_entry->refcount, 1);
+
+	list_add_tail(&pgid_entry->list, &lan966x->pgid_entries);
+
+	return pgid_entry;
+}
+
+static struct lan966x_pgid_entry *
+lan966x_pgid_entry_get(struct lan966x *lan966x,
+		       struct lan966x_mdb_entry *mdb_entry)
+{
+	struct lan966x_pgid_entry *pgid_entry;
+	int index;
+
+	/* Try to find an existing pgid that uses the same ports as the
+	 * mdb_entry
+	 */
+	list_for_each_entry(pgid_entry, &lan966x->pgid_entries, list) {
+		if (pgid_entry->ports == mdb_entry->ports) {
+			refcount_inc(&pgid_entry->refcount);
+			return pgid_entry;
+		}
+	}
+
+	/* Try to find an empty pgid entry and allocate one in case it finds it,
+	 * otherwise it means that there are no more resources
+	 */
+	for (index = PGID_GP_START; index < PGID_GP_END; index++) {
+		bool used = false;
+
+		list_for_each_entry(pgid_entry, &lan966x->pgid_entries, list) {
+			if (pgid_entry->index == index) {
+				used = true;
+				break;
+			}
+		}
+
+		if (!used)
+			return lan966x_pgid_entry_add(lan966x, index,
+						      mdb_entry->ports);
+	}
+
+	return ERR_PTR(-ENOSPC);
+}
+
+static void lan966x_pgid_entry_del(struct lan966x *lan966x,
+				   struct lan966x_pgid_entry *pgid_entry)
+{
+	if (!refcount_dec_and_test(&pgid_entry->refcount))
+		return;
+
+	list_del(&pgid_entry->list);
+	kfree(pgid_entry);
+}
+
+static int lan966x_mdb_l2_add(struct lan966x_port *port,
+			      const struct switchdev_obj_port_mdb *mdb,
+			      enum macaccess_entry_type type)
+{
+	bool cpu_port = netif_is_bridge_master(mdb->obj.orig_dev);
+	struct lan966x *lan966x = port->lan966x;
+	struct lan966x_pgid_entry *pgid_entry;
+	struct lan966x_mdb_entry *mdb_entry;
+	unsigned char mac[ETH_ALEN];
+
+	mdb_entry = lan966x_mdb_entry_get(lan966x, mdb->addr, mdb->vid);
+	if (!mdb_entry) {
+		mdb_entry = lan966x_mdb_entry_add(lan966x, mdb);
+		if (IS_ERR(mdb_entry))
+			return PTR_ERR(mdb_entry);
+	} else {
+		lan966x_pgid_entry_del(lan966x, mdb_entry->pgid);
+		lan966x_mdb_encode_mac(mac, mdb_entry, type);
+		lan966x_mac_forget(lan966x, mac, mdb_entry->vid, type);
+	}
+
+	if (cpu_port) {
+		mdb_entry->ports |= BIT(CPU_PORT);
+		mdb_entry->cpu_copy++;
+	} else {
+		mdb_entry->ports |= BIT(port->chip_port);
+	}
+
+	pgid_entry = lan966x_pgid_entry_get(lan966x, mdb_entry);
+	if (IS_ERR(pgid_entry)) {
+		list_del(&mdb_entry->list);
+		kfree(mdb_entry);
+		return PTR_ERR(pgid_entry);
+	}
+	mdb_entry->pgid = pgid_entry;
+
+	/* Copy the frame to CPU only if the CPU is in the VLAN */
+	if (!lan966x_vlan_cpu_member_cpu_vlan_mask(lan966x, mdb_entry->vid) &&
+	    mdb_entry->cpu_copy)
+		mdb_entry->ports &= BIT(CPU_PORT);
+
+	lan_rmw(ANA_PGID_PGID_SET(mdb_entry->ports),
+		ANA_PGID_PGID,
+		lan966x, ANA_PGID(pgid_entry->index));
+
+	return lan966x_mac_learn(lan966x, pgid_entry->index, mdb_entry->mac,
+				 mdb_entry->vid, type);
+}
+
+static int lan966x_mdb_l2_del(struct lan966x_port *port,
+			      const struct switchdev_obj_port_mdb *mdb,
+			      enum macaccess_entry_type type)
+{
+	bool cpu_port = netif_is_bridge_master(mdb->obj.orig_dev);
+	struct lan966x *lan966x = port->lan966x;
+	struct lan966x_pgid_entry *pgid_entry;
+	struct lan966x_mdb_entry *mdb_entry;
+	unsigned char mac[ETH_ALEN];
+	u16 ports;
+
+	mdb_entry = lan966x_mdb_entry_get(lan966x, mdb->addr, mdb->vid);
+	if (!mdb_entry)
+		return -ENOENT;
+
+	ports = mdb_entry->ports;
+	if (cpu_port) {
+		/* If there are still other references to the CPU port then
+		 * there is no point to delete and add again the same entry
+		 */
+		mdb_entry->cpu_copy--;
+		if (mdb_entry->cpu_copy)
+			return 0;
+
+		ports &= ~BIT(CPU_PORT);
+	} else {
+		ports &= ~BIT(port->chip_port);
+	}
+
+	lan966x_mdb_encode_mac(mac, mdb_entry, type);
+	lan966x_mac_forget(lan966x, mac, mdb_entry->vid, type);
+	lan966x_pgid_entry_del(lan966x, mdb_entry->pgid);
+
+	mdb_entry->ports = ports;
+
+	if (!mdb_entry->ports) {
+		list_del(&mdb_entry->list);
+		kfree(mdb_entry);
+		return 0;
+	}
+
+	pgid_entry = lan966x_pgid_entry_get(lan966x, mdb_entry);
+	if (IS_ERR(pgid_entry)) {
+		list_del(&mdb_entry->list);
+		kfree(mdb_entry);
+		return PTR_ERR(pgid_entry);
+	}
+	mdb_entry->pgid = pgid_entry;
+
+	lan_rmw(ANA_PGID_PGID_SET(mdb_entry->ports),
+		ANA_PGID_PGID,
+		lan966x, ANA_PGID(pgid_entry->index));
+
+	return lan966x_mac_learn(lan966x, pgid_entry->index, mdb_entry->mac,
+				 mdb_entry->vid, type);
+}
+
+static enum macaccess_entry_type
+lan966x_mdb_classify(const unsigned char *mac)
+{
+	if (mac[0] == 0x01 && mac[1] == 0x00 && mac[2] == 0x5e)
+		return ENTRYTYPE_MACV4;
+	if (mac[0] == 0x33 && mac[1] == 0x33)
+		return ENTRYTYPE_MACV6;
+	return ENTRYTYPE_LOCKED;
+}
+
+int lan966x_handle_port_mdb_add(struct lan966x_port *port,
+				const struct switchdev_obj *obj)
+{
+	const struct switchdev_obj_port_mdb *mdb = SWITCHDEV_OBJ_PORT_MDB(obj);
+	enum macaccess_entry_type type;
+
+	/* Split the way the entries are added for ipv4/ipv6 and for l2. The
+	 * reason is that for ipv4/ipv6 it doesn't require to use any pgid
+	 * entry, while for l2 is required to use pgid entries
+	 */
+	type = lan966x_mdb_classify(mdb->addr);
+	if (type == ENTRYTYPE_MACV4 || type == ENTRYTYPE_MACV6)
+		return lan966x_mdb_ip_add(port, mdb, type);
+
+	return lan966x_mdb_l2_add(port, mdb, type);
+}
+
+int lan966x_handle_port_mdb_del(struct lan966x_port *port,
+				const struct switchdev_obj *obj)
+{
+	const struct switchdev_obj_port_mdb *mdb = SWITCHDEV_OBJ_PORT_MDB(obj);
+	enum macaccess_entry_type type;
+
+	/* Split the way the entries are removed for ipv4/ipv6 and for l2. The
+	 * reason is that for ipv4/ipv6 it doesn't require to use any pgid
+	 * entry, while for l2 is required to use pgid entries
+	 */
+	type = lan966x_mdb_classify(mdb->addr);
+	if (type == ENTRYTYPE_MACV4 || type == ENTRYTYPE_MACV6)
+		return lan966x_mdb_ip_del(port, mdb, type);
+
+	return lan966x_mdb_l2_del(port, mdb, type);
+}
+
+static void lan966x_mdb_ip_cpu_copy(struct lan966x *lan966x,
+				    struct lan966x_mdb_entry *mdb_entry,
+				    enum macaccess_entry_type type)
+{
+	unsigned char mac[ETH_ALEN];
+
+	lan966x_mdb_encode_mac(mac, mdb_entry, type);
+	lan966x_mac_forget(lan966x, mac, mdb_entry->vid, type);
+	lan966x_mac_ip_learn(lan966x, true, mac, mdb_entry->vid, type);
+}
+
+static void lan966x_mdb_l2_cpu_copy(struct lan966x *lan966x,
+				    struct lan966x_mdb_entry *mdb_entry,
+				    enum macaccess_entry_type type)
+{
+	struct lan966x_pgid_entry *pgid_entry;
+	unsigned char mac[ETH_ALEN];
+
+	lan966x_pgid_entry_del(lan966x, mdb_entry->pgid);
+	lan966x_mdb_encode_mac(mac, mdb_entry, type);
+	lan966x_mac_forget(lan966x, mac, mdb_entry->vid, type);
+
+	mdb_entry->ports |= BIT(CPU_PORT);
+
+	pgid_entry = lan966x_pgid_entry_get(lan966x, mdb_entry);
+	if (IS_ERR(pgid_entry))
+		return;
+
+	mdb_entry->pgid = pgid_entry;
+
+	lan_rmw(ANA_PGID_PGID_SET(mdb_entry->ports),
+		ANA_PGID_PGID,
+		lan966x, ANA_PGID(pgid_entry->index));
+
+	lan966x_mac_learn(lan966x, pgid_entry->index, mdb_entry->mac,
+			  mdb_entry->vid, type);
+}
+
+void lan966x_mdb_write_entries(struct lan966x *lan966x, u16 vid)
+{
+	struct lan966x_mdb_entry *mdb_entry;
+	enum macaccess_entry_type type;
+
+	list_for_each_entry(mdb_entry, &lan966x->mdb_entries, list) {
+		if (mdb_entry->vid != vid || !mdb_entry->cpu_copy)
+			continue;
+
+		type = lan966x_mdb_classify(mdb_entry->mac);
+		if (type == ENTRYTYPE_MACV4 || type == ENTRYTYPE_MACV6)
+			lan966x_mdb_ip_cpu_copy(lan966x, mdb_entry, type);
+		else
+			lan966x_mdb_l2_cpu_copy(lan966x, mdb_entry, type);
+	}
+}
+
+static void lan966x_mdb_ip_cpu_remove(struct lan966x *lan966x,
+				      struct lan966x_mdb_entry *mdb_entry,
+				      enum macaccess_entry_type type)
+{
+	unsigned char mac[ETH_ALEN];
+
+	lan966x_mdb_encode_mac(mac, mdb_entry, type);
+	lan966x_mac_forget(lan966x, mac, mdb_entry->vid, type);
+	lan966x_mac_ip_learn(lan966x, false, mac, mdb_entry->vid, type);
+}
+
+static void lan966x_mdb_l2_cpu_remove(struct lan966x *lan966x,
+				      struct lan966x_mdb_entry *mdb_entry,
+				      enum macaccess_entry_type type)
+{
+	struct lan966x_pgid_entry *pgid_entry;
+	unsigned char mac[ETH_ALEN];
+
+	lan966x_pgid_entry_del(lan966x, mdb_entry->pgid);
+	lan966x_mdb_encode_mac(mac, mdb_entry, type);
+	lan966x_mac_forget(lan966x, mac, mdb_entry->vid, type);
+
+	mdb_entry->ports &= ~BIT(CPU_PORT);
+
+	pgid_entry = lan966x_pgid_entry_get(lan966x, mdb_entry);
+	if (IS_ERR(pgid_entry))
+		return;
+
+	mdb_entry->pgid = pgid_entry;
+
+	lan_rmw(ANA_PGID_PGID_SET(mdb_entry->ports),
+		ANA_PGID_PGID,
+		lan966x, ANA_PGID(pgid_entry->index));
+
+	lan966x_mac_learn(lan966x, pgid_entry->index, mdb_entry->mac,
+			  mdb_entry->vid, type);
+}
+
+void lan966x_mdb_erase_entries(struct lan966x *lan966x, u16 vid)
+{
+	struct lan966x_mdb_entry *mdb_entry;
+	enum macaccess_entry_type type;
+
+	list_for_each_entry(mdb_entry, &lan966x->mdb_entries, list) {
+		if (mdb_entry->vid != vid || !mdb_entry->cpu_copy)
+			continue;
+
+		type = lan966x_mdb_classify(mdb_entry->mac);
+		if (type == ENTRYTYPE_MACV4 || type == ENTRYTYPE_MACV6)
+			lan966x_mdb_ip_cpu_remove(lan966x, mdb_entry, type);
+		else
+			lan966x_mdb_l2_cpu_remove(lan966x, mdb_entry, type);
+	}
+}
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c b/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c
index deb3dd5be67a..7de55f6a4da8 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c
@@ -438,6 +438,10 @@ static int lan966x_handle_port_obj_add(struct net_device *dev, const void *ctx,
 	case SWITCHDEV_OBJ_ID_PORT_VLAN:
 		err = lan966x_handle_port_vlan_add(port, obj);
 		break;
+	case SWITCHDEV_OBJ_ID_PORT_MDB:
+	case SWITCHDEV_OBJ_ID_HOST_MDB:
+		err = lan966x_handle_port_mdb_add(port, obj);
+		break;
 	default:
 		err = -EOPNOTSUPP;
 		break;
@@ -473,6 +477,10 @@ static int lan966x_handle_port_obj_del(struct net_device *dev, const void *ctx,
 	case SWITCHDEV_OBJ_ID_PORT_VLAN:
 		err = lan966x_handle_port_vlan_del(port, obj);
 		break;
+	case SWITCHDEV_OBJ_ID_PORT_MDB:
+	case SWITCHDEV_OBJ_ID_HOST_MDB:
+		err = lan966x_handle_port_mdb_del(port, obj);
+		break;
 	default:
 		err = -EOPNOTSUPP;
 		break;
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_vlan.c b/drivers/net/ethernet/microchip/lan966x/lan966x_vlan.c
index 057f48ddf22c..8d7260cd7da9 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_vlan.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_vlan.c
@@ -219,6 +219,7 @@ void lan966x_vlan_port_add_vlan(struct lan966x_port *port,
 	if (lan966x_vlan_cpu_member_cpu_vlan_mask(lan966x, vid)) {
 		lan966x_vlan_cpu_add_vlan_mask(lan966x, vid);
 		lan966x_fdb_write_entries(lan966x, vid);
+		lan966x_mdb_write_entries(lan966x, vid);
 	}
 
 	lan966x_vlan_port_set_vid(port, vid, pvid, untagged);
@@ -241,6 +242,7 @@ void lan966x_vlan_port_del_vlan(struct lan966x_port *port, u16 vid)
 	if (!lan966x_vlan_port_any_vlan_mask(lan966x, vid)) {
 		lan966x_vlan_cpu_del_vlan_mask(lan966x, vid);
 		lan966x_fdb_erase_entries(lan966x, vid);
+		lan966x_mdb_erase_entries(lan966x, vid);
 	}
 }
 
@@ -254,8 +256,10 @@ void lan966x_vlan_cpu_add_vlan(struct lan966x *lan966x, u16 vid)
 	 * information so when a front port is added then it would add also the
 	 * CPU port.
 	 */
-	if (lan966x_vlan_port_any_vlan_mask(lan966x, vid))
+	if (lan966x_vlan_port_any_vlan_mask(lan966x, vid)) {
 		lan966x_vlan_cpu_add_vlan_mask(lan966x, vid);
+		lan966x_mdb_write_entries(lan966x, vid);
+	}
 
 	lan966x_vlan_cpu_add_cpu_vlan_mask(lan966x, vid);
 	lan966x_fdb_write_entries(lan966x, vid);
@@ -267,6 +271,7 @@ void lan966x_vlan_cpu_del_vlan(struct lan966x *lan966x, u16 vid)
 	lan966x_vlan_cpu_del_cpu_vlan_mask(lan966x, vid);
 	lan966x_vlan_cpu_del_vlan_mask(lan966x, vid);
 	lan966x_fdb_erase_entries(lan966x, vid);
+	lan966x_mdb_erase_entries(lan966x, vid);
 }
 
 void lan966x_vlan_init(struct lan966x *lan966x)
-- 
2.33.0

