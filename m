Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3A5D479D9E
	for <lists+netdev@lfdr.de>; Sat, 18 Dec 2021 22:48:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234647AbhLRVsr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Dec 2021 16:48:47 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:6589 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234570AbhLRVsk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Dec 2021 16:48:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1639864120; x=1671400120;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Dgx+uS3Tybb2On6wd0IhNQyjyQmYwXJP8vRLhUTGYKs=;
  b=OFjDepq+Rjm7EmMeVYwA63r8zrKTZPue+D46Q0i1QzEXaO1akbkgxqw7
   peTVH+xAoj79fx1FOdSFdl7ST7N7SE9m4C3A4SFFs/PDBNODDpO66Tr1j
   t559gtFhMEJmmGtahuYozywz72zXlkNameInDvVDXuhAWXRpgO12qAOy8
   VGv/l512mv9AYCxDxfIr9GwqDx2nlAfzXHFeZJLnpkqBTtu1d1MlGVvFg
   lFroSEDDnki+c5f0NHfOqYdO+iw7bqQsRhcQuzlaQdnvg/XTiQBiVIEPr
   wMd5xrCdZYnq/dUHhgf0taiza5oIyN83gd2YPeSCaiZLvSvTjUzktR79p
   w==;
IronPort-SDR: mZydpP56BIFe3yFirKHByVvo1QqUljxu0zGvAwmtk4xJ98DbGVDL3g9X5+m9JafZxR0pzOn2FR
 zmGa4wlG9CSngBCgm8W8QypHcryk9RwCb8+GxUp2nJ1rcBt/MwuZlXZzr2rWExDDaQf7MhU33V
 92wl6Z61datAt/iNUvHstTRa87IEgZ1eSzBrk1E84Zlb4d8ewukqRQ9430W+WIFTXJCpRaLURG
 pLx6Opom50svMWA9+odvy6ryt4dI1iCgtO3/VeRKGCVuWqF3PW638Foqzm6BKOGE3eI6MfcoIg
 BL0NQyBS7Zst8NuEid6816ke
X-IronPort-AV: E=Sophos;i="5.88,217,1635231600"; 
   d="scan'208";a="155989509"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 18 Dec 2021 14:48:38 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Sat, 18 Dec 2021 14:48:35 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Sat, 18 Dec 2021 14:48:32 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <UNGLinuxDriver@microchip.com>, <linux@armlinux.org.uk>,
        <f.fainelli@gmail.com>, <vivien.didelot@gmail.com>,
        <vladimir.oltean@nxp.com>, <andrew@lunn.ch>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v8 9/9] net: lan966x: Extend switchdev with fdb support
Date:   Sat, 18 Dec 2021 22:49:46 +0100
Message-ID: <20211218214946.531940-10-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211218214946.531940-1-horatiu.vultur@microchip.com>
References: <20211218214946.531940-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extend lan966x driver with fdb support by implementing the switchdev
calls SWITCHDEV_FDB_ADD_TO_DEVICE and SWITCHDEV_FDB_DEL_TO_DEVICE.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 .../net/ethernet/microchip/lan966x/Makefile   |   2 +-
 .../ethernet/microchip/lan966x/lan966x_fdb.c  | 244 ++++++++++++++++++
 .../ethernet/microchip/lan966x/lan966x_main.c |   5 +
 .../ethernet/microchip/lan966x/lan966x_main.h |  14 +
 .../microchip/lan966x/lan966x_switchdev.c     |  21 ++
 .../ethernet/microchip/lan966x/lan966x_vlan.c |  15 +-
 6 files changed, 298 insertions(+), 3 deletions(-)
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_fdb.c

diff --git a/drivers/net/ethernet/microchip/lan966x/Makefile b/drivers/net/ethernet/microchip/lan966x/Makefile
index d82e896c2e53..ec1a1fa8b0d5 100644
--- a/drivers/net/ethernet/microchip/lan966x/Makefile
+++ b/drivers/net/ethernet/microchip/lan966x/Makefile
@@ -7,4 +7,4 @@ obj-$(CONFIG_LAN966X_SWITCH) += lan966x-switch.o
 
 lan966x-switch-objs  := lan966x_main.o lan966x_phylink.o lan966x_port.o \
 			lan966x_mac.o lan966x_ethtool.o lan966x_switchdev.o \
-			lan966x_vlan.o
+			lan966x_vlan.o lan966x_fdb.o
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_fdb.c b/drivers/net/ethernet/microchip/lan966x/lan966x_fdb.c
new file mode 100644
index 000000000000..da5ca7188679
--- /dev/null
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_fdb.c
@@ -0,0 +1,244 @@
+// SPDX-License-Identifier: GPL-2.0+
+
+#include <net/switchdev.h>
+
+#include "lan966x_main.h"
+
+struct lan966x_fdb_event_work {
+	struct work_struct work;
+	struct switchdev_notifier_fdb_info fdb_info;
+	struct net_device *dev;
+	struct lan966x *lan966x;
+	unsigned long event;
+};
+
+struct lan966x_fdb_entry {
+	struct list_head list;
+	unsigned char mac[ETH_ALEN] __aligned(2);
+	u16 vid;
+	u32 references;
+};
+
+static struct lan966x_fdb_entry *
+lan966x_fdb_find_entry(struct lan966x *lan966x,
+		       struct switchdev_notifier_fdb_info *fdb_info)
+{
+	struct lan966x_fdb_entry *fdb_entry;
+
+	list_for_each_entry(fdb_entry, &lan966x->fdb_entries, list) {
+		if (fdb_entry->vid == fdb_info->vid &&
+		    ether_addr_equal(fdb_entry->mac, fdb_info->addr))
+			return fdb_entry;
+	}
+
+	return NULL;
+}
+
+static void lan966x_fdb_add_entry(struct lan966x *lan966x,
+				  struct switchdev_notifier_fdb_info *fdb_info)
+{
+	struct lan966x_fdb_entry *fdb_entry;
+
+	fdb_entry = lan966x_fdb_find_entry(lan966x, fdb_info);
+	if (fdb_entry) {
+		fdb_entry->references++;
+		return;
+	}
+
+	fdb_entry = kzalloc(sizeof(*fdb_entry), GFP_KERNEL);
+	if (!fdb_entry)
+		return;
+
+	ether_addr_copy(fdb_entry->mac, fdb_info->addr);
+	fdb_entry->vid = fdb_info->vid;
+	fdb_entry->references = 1;
+	list_add_tail(&fdb_entry->list, &lan966x->fdb_entries);
+}
+
+static bool lan966x_fdb_del_entry(struct lan966x *lan966x,
+				  struct switchdev_notifier_fdb_info *fdb_info)
+{
+	struct lan966x_fdb_entry *fdb_entry, *tmp;
+
+	list_for_each_entry_safe(fdb_entry, tmp, &lan966x->fdb_entries,
+				 list) {
+		if (fdb_entry->vid == fdb_info->vid &&
+		    ether_addr_equal(fdb_entry->mac, fdb_info->addr)) {
+			fdb_entry->references--;
+			if (!fdb_entry->references) {
+				list_del(&fdb_entry->list);
+				kfree(fdb_entry);
+				return true;
+			}
+			break;
+		}
+	}
+
+	return false;
+}
+
+void lan966x_fdb_write_entries(struct lan966x *lan966x, u16 vid)
+{
+	struct lan966x_fdb_entry *fdb_entry;
+
+	list_for_each_entry(fdb_entry, &lan966x->fdb_entries, list) {
+		if (fdb_entry->vid != vid)
+			continue;
+
+		lan966x_mac_cpu_learn(lan966x, fdb_entry->mac, fdb_entry->vid);
+	}
+}
+
+void lan966x_fdb_erase_entries(struct lan966x *lan966x, u16 vid)
+{
+	struct lan966x_fdb_entry *fdb_entry;
+
+	list_for_each_entry(fdb_entry, &lan966x->fdb_entries, list) {
+		if (fdb_entry->vid != vid)
+			continue;
+
+		lan966x_mac_cpu_forget(lan966x, fdb_entry->mac, fdb_entry->vid);
+	}
+}
+
+static void lan966x_fdb_purge_entries(struct lan966x *lan966x)
+{
+	struct lan966x_fdb_entry *fdb_entry, *tmp;
+
+	list_for_each_entry_safe(fdb_entry, tmp, &lan966x->fdb_entries, list) {
+		list_del(&fdb_entry->list);
+		kfree(fdb_entry);
+	}
+}
+
+int lan966x_fdb_init(struct lan966x *lan966x)
+{
+	INIT_LIST_HEAD(&lan966x->fdb_entries);
+	lan966x->fdb_work = alloc_ordered_workqueue("lan966x_order", 0);
+	if (!lan966x->fdb_work)
+		return -ENOMEM;
+
+	return 0;
+}
+
+void lan966x_fdb_deinit(struct lan966x *lan966x)
+{
+	destroy_workqueue(lan966x->fdb_work);
+	lan966x_fdb_purge_entries(lan966x);
+}
+
+static void lan966x_fdb_event_work(struct work_struct *work)
+{
+	struct lan966x_fdb_event_work *fdb_work =
+		container_of(work, struct lan966x_fdb_event_work, work);
+	struct switchdev_notifier_fdb_info *fdb_info;
+	struct net_device *dev = fdb_work->dev;
+	struct lan966x_port *port;
+	struct lan966x *lan966x;
+	int ret;
+
+	fdb_info = &fdb_work->fdb_info;
+	lan966x = fdb_work->lan966x;
+
+	if (lan966x_netdevice_check(dev)) {
+		port = netdev_priv(dev);
+
+		switch (fdb_work->event) {
+		case SWITCHDEV_FDB_ADD_TO_DEVICE:
+			if (!fdb_info->added_by_user)
+				break;
+			lan966x_mac_add_entry(lan966x, port, fdb_info->addr,
+					      fdb_info->vid);
+			break;
+		case SWITCHDEV_FDB_DEL_TO_DEVICE:
+			if (!fdb_info->added_by_user)
+				break;
+			lan966x_mac_del_entry(lan966x, fdb_info->addr,
+					      fdb_info->vid);
+			break;
+		}
+	} else {
+		if (!netif_is_bridge_master(dev))
+			goto out;
+
+		/* In case the bridge is called */
+		switch (fdb_work->event) {
+		case SWITCHDEV_FDB_ADD_TO_DEVICE:
+			/* If there is no front port in this vlan, there is no
+			 * point to copy the frame to CPU because it would be
+			 * just dropped at later point. So add it only if
+			 * there is a port but it is required to store the fdb
+			 * entry for later point when a port actually gets in
+			 * the vlan.
+			 */
+			lan966x_fdb_add_entry(lan966x, fdb_info);
+			if (!lan966x_vlan_cpu_member_cpu_vlan_mask(lan966x,
+								   fdb_info->vid))
+				break;
+
+			lan966x_mac_cpu_learn(lan966x, fdb_info->addr,
+					      fdb_info->vid);
+			break;
+		case SWITCHDEV_FDB_DEL_TO_DEVICE:
+			ret = lan966x_fdb_del_entry(lan966x, fdb_info);
+			if (!lan966x_vlan_cpu_member_cpu_vlan_mask(lan966x,
+								   fdb_info->vid))
+				break;
+
+			if (ret)
+				lan966x_mac_cpu_forget(lan966x, fdb_info->addr,
+						       fdb_info->vid);
+			break;
+		}
+	}
+
+out:
+	kfree(fdb_work->fdb_info.addr);
+	kfree(fdb_work);
+	dev_put(dev);
+}
+
+int lan966x_handle_fdb(struct net_device *dev,
+		       struct net_device *orig_dev,
+		       unsigned long event, const void *ctx,
+		       const struct switchdev_notifier_fdb_info *fdb_info)
+{
+	struct lan966x_port *port = netdev_priv(dev);
+	struct lan966x *lan966x = port->lan966x;
+	struct lan966x_fdb_event_work *fdb_work;
+
+	if (ctx && ctx != port)
+		return 0;
+
+	switch (event) {
+	case SWITCHDEV_FDB_ADD_TO_DEVICE:
+	case SWITCHDEV_FDB_DEL_TO_DEVICE:
+		if (lan966x_netdevice_check(orig_dev) &&
+		    !fdb_info->added_by_user)
+			break;
+
+		fdb_work = kzalloc(sizeof(*fdb_work), GFP_ATOMIC);
+		if (!fdb_work)
+			return -ENOMEM;
+
+		fdb_work->dev = orig_dev;
+		fdb_work->lan966x = lan966x;
+		fdb_work->event = event;
+		INIT_WORK(&fdb_work->work, lan966x_fdb_event_work);
+		memcpy(&fdb_work->fdb_info, fdb_info, sizeof(fdb_work->fdb_info));
+		fdb_work->fdb_info.addr = kzalloc(ETH_ALEN, GFP_ATOMIC);
+		if (!fdb_work->fdb_info.addr)
+			goto err_addr_alloc;
+
+		ether_addr_copy((u8 *)fdb_work->fdb_info.addr, fdb_info->addr);
+		dev_hold(orig_dev);
+
+		queue_work(lan966x->fdb_work, &fdb_work->work);
+		break;
+	}
+
+	return 0;
+err_addr_alloc:
+	kfree(fdb_work);
+	return -ENOMEM;
+}
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
index 1162f5540a65..5b9f004ad902 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
@@ -919,6 +919,10 @@ static int lan966x_probe(struct platform_device *pdev)
 		lan966x_port_init(lan966x->ports[p]);
 	}
 
+	err = lan966x_fdb_init(lan966x);
+	if (err)
+		goto cleanup_ports;
+
 	return 0;
 
 cleanup_ports:
@@ -944,6 +948,7 @@ static int lan966x_remove(struct platform_device *pdev)
 	mutex_destroy(&lan966x->stats_lock);
 
 	lan966x_mac_purge_entries(lan966x);
+	lan966x_fdb_deinit(lan966x);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
index 19635cea6634..051182890237 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
@@ -8,6 +8,7 @@
 #include <linux/jiffies.h>
 #include <linux/phy.h>
 #include <linux/phylink.h>
+#include <net/switchdev.h>
 
 #include "lan966x_regs.h"
 #include "lan966x_ifh.h"
@@ -100,6 +101,10 @@ struct lan966x {
 	/* interrupts */
 	int xtr_irq;
 	int ana_irq;
+
+	/* worqueue for fdb */
+	struct workqueue_struct *fdb_work;
+	struct list_head fdb_entries;
 };
 
 struct lan966x_port_config {
@@ -190,6 +195,15 @@ void lan966x_vlan_port_del_vlan(struct lan966x_port *port, u16 vid);
 void lan966x_vlan_cpu_add_vlan(struct lan966x *lan966x, u16 vid);
 void lan966x_vlan_cpu_del_vlan(struct lan966x *lan966x, u16 vid);
 
+void lan966x_fdb_write_entries(struct lan966x *lan966x, u16 vid);
+void lan966x_fdb_erase_entries(struct lan966x *lan966x, u16 vid);
+int lan966x_fdb_init(struct lan966x *lan966x);
+void lan966x_fdb_deinit(struct lan966x *lan966x);
+int lan966x_handle_fdb(struct net_device *dev,
+		       struct net_device *orig_dev,
+		       unsigned long event, const void *ctx,
+		       const struct switchdev_notifier_fdb_info *fdb_info);
+
 static inline void __iomem *lan_addr(void __iomem *base[],
 				     int id, int tinst, int tcnt,
 				     int gbase, int ginst,
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c b/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c
index af058700a95b..42c3170030d0 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c
@@ -293,6 +293,19 @@ static int lan966x_netdevice_event(struct notifier_block *nb,
 	return notifier_from_errno(ret);
 }
 
+static bool lan966x_foreign_dev_check(const struct net_device *dev,
+				      const struct net_device *foreign_dev)
+{
+	struct lan966x_port *port = netdev_priv(dev);
+	struct lan966x *lan966x = port->lan966x;
+
+	if (netif_is_bridge_master(foreign_dev))
+		if (lan966x->bridge != foreign_dev)
+			return true;
+
+	return false;
+}
+
 static int lan966x_switchdev_event(struct notifier_block *nb,
 				   unsigned long event, void *ptr)
 {
@@ -305,6 +318,14 @@ static int lan966x_switchdev_event(struct notifier_block *nb,
 						     lan966x_netdevice_check,
 						     lan966x_port_attr_set);
 		return notifier_from_errno(err);
+	case SWITCHDEV_FDB_ADD_TO_DEVICE:
+	case SWITCHDEV_FDB_DEL_TO_DEVICE:
+		err = switchdev_handle_fdb_event_to_device(dev, event, ptr,
+							   lan966x_netdevice_check,
+							   lan966x_foreign_dev_check,
+							   lan966x_handle_fdb,
+							   NULL);
+		return notifier_from_errno(err);
 	}
 
 	return NOTIFY_DONE;
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_vlan.c b/drivers/net/ethernet/microchip/lan966x/lan966x_vlan.c
index 64eb80626deb..057f48ddf22c 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_vlan.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_vlan.c
@@ -211,8 +211,15 @@ void lan966x_vlan_port_add_vlan(struct lan966x_port *port,
 {
 	struct lan966x *lan966x = port->lan966x;
 
-	if (lan966x_vlan_cpu_member_cpu_vlan_mask(lan966x, vid))
+	/* If the CPU(br) is already part of the vlan then add the fdb
+	 * entries in MAC table to copy the frames to the CPU(br).
+	 * If the CPU(br) is not part of the vlan then it would
+	 * just drop the frames.
+	 */
+	if (lan966x_vlan_cpu_member_cpu_vlan_mask(lan966x, vid)) {
 		lan966x_vlan_cpu_add_vlan_mask(lan966x, vid);
+		lan966x_fdb_write_entries(lan966x, vid);
+	}
 
 	lan966x_vlan_port_set_vid(port, vid, pvid, untagged);
 	lan966x_vlan_port_add_vlan_mask(port, vid);
@@ -231,8 +238,10 @@ void lan966x_vlan_port_del_vlan(struct lan966x_port *port, u16 vid)
 	 * that vlan but still keep it in the mask because it may be needed
 	 * again then another port gets added in that vlan
 	 */
-	if (!lan966x_vlan_port_any_vlan_mask(lan966x, vid))
+	if (!lan966x_vlan_port_any_vlan_mask(lan966x, vid)) {
 		lan966x_vlan_cpu_del_vlan_mask(lan966x, vid);
+		lan966x_fdb_erase_entries(lan966x, vid);
+	}
 }
 
 void lan966x_vlan_cpu_add_vlan(struct lan966x *lan966x, u16 vid)
@@ -249,6 +258,7 @@ void lan966x_vlan_cpu_add_vlan(struct lan966x *lan966x, u16 vid)
 		lan966x_vlan_cpu_add_vlan_mask(lan966x, vid);
 
 	lan966x_vlan_cpu_add_cpu_vlan_mask(lan966x, vid);
+	lan966x_fdb_write_entries(lan966x, vid);
 }
 
 void lan966x_vlan_cpu_del_vlan(struct lan966x *lan966x, u16 vid)
@@ -256,6 +266,7 @@ void lan966x_vlan_cpu_del_vlan(struct lan966x *lan966x, u16 vid)
 	/* Remove the CPU part of the vlan */
 	lan966x_vlan_cpu_del_cpu_vlan_mask(lan966x, vid);
 	lan966x_vlan_cpu_del_vlan_mask(lan966x, vid);
+	lan966x_fdb_erase_entries(lan966x, vid);
 }
 
 void lan966x_vlan_init(struct lan966x *lan966x)
-- 
2.33.0

