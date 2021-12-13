Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0556F472945
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 11:20:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245135AbhLMKTW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 05:19:22 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:39276 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241040AbhLMKP3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 05:15:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1639390529; x=1670926529;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Yejz+/qMnRgODShJ7pv3TY59AOtWMNgqaF6rFnE30qA=;
  b=EvvBkm2OqHVaT2Zc9doIc8AwfwgRKlk6nm1YLESB32BVbyC8BhqV1aU7
   pQciTUoQieVYv+2LzNiSNGMMOw9n3HHJIssuV8pmqn5iSkgBqmjM2mwTN
   iBZz2xTOiWs2HRhu0q7OKOEIUBYXAiPIf5RjRnOyy+CwaML3CwMLeopcK
   rNfrjek+BedNxDdzdZmeqjs8OKGxarsv5hUtsSJi8+TekErPRgjrfKDJM
   sFOG9cz97D68TElKYuWWbzfGzvMqmdfLZjD3Qb+HZ3O6lOGBxNLCJGsZP
   heAQ3qjea9W05HtraWQLNsywi1WX/gU9V6sKdZYkPeDDYxoK+rieE8Vg1
   A==;
IronPort-SDR: Ha/r/XTXBV+PXVFljVtFaa4/Brh8hlkbIsOPBIDPwwV7MPXSN0f5cQDEBMIZXWfq4odY/4YjyE
 T56ze8Q03qLt9inTuA1TmUx/WAi4fFTWAEKTIIIfe/OaqxeSejQF70Vxn9IVhQvPzHFxSbWFuM
 akf0PXXXWsHtkr7VIL4/Wkhluir4HAj6ic8n685D5mHm/YUuoJwKlF4ax3E2OY/y45QstcXeNH
 1+LefZTN5vi3oQuVjn12V8dyhpzQQJDj9dY0xuuX1oLUZPl/ct71vyt6No2qyvstxW7srmxWvN
 dbfOu5w2e8FD4FVw2hqKSZir
X-IronPort-AV: E=Sophos;i="5.88,202,1635231600"; 
   d="scan'208";a="155251672"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 13 Dec 2021 03:15:28 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Mon, 13 Dec 2021 03:15:23 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Mon, 13 Dec 2021 03:15:20 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <UNGLinuxDriver@microchip.com>, <linux@armlinux.org.uk>,
        <f.fainelli@gmail.com>, <vivien.didelot@gmail.com>,
        <vladimir.oltean@nxp.com>, <andrew@lunn.ch>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v4 10/10] net: lan966x: Extend switchdev with fdb support
Date:   Mon, 13 Dec 2021 11:14:32 +0100
Message-ID: <20211213101432.2668820-11-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211213101432.2668820-1-horatiu.vultur@microchip.com>
References: <20211213101432.2668820-1-horatiu.vultur@microchip.com>
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
 .../ethernet/microchip/lan966x/lan966x_fdb.c  | 214 ++++++++++++++++++
 .../ethernet/microchip/lan966x/lan966x_main.c |   8 +
 .../ethernet/microchip/lan966x/lan966x_main.h |  10 +
 .../microchip/lan966x/lan966x_switchdev.c     |   5 +
 .../ethernet/microchip/lan966x/lan966x_vlan.c |   4 +
 6 files changed, 242 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_fdb.c

diff --git a/drivers/net/ethernet/microchip/lan966x/Makefile b/drivers/net/ethernet/microchip/lan966x/Makefile
index d489a34fc643..f531caf4a6b8 100644
--- a/drivers/net/ethernet/microchip/lan966x/Makefile
+++ b/drivers/net/ethernet/microchip/lan966x/Makefile
@@ -7,4 +7,4 @@ obj-$(CONFIG_LAN966X_SWITCH) += lan966x-switch.o
 
 lan966x-switch-objs  := lan966x_main.o lan966x_phylink.o lan966x_port.o \
 			lan966x_mac.o lan966x_ethtool.o lan966x_vlan.o \
-			lan966x_switchdev.o
+			lan966x_switchdev.o lan966x_fdb.o
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_fdb.c b/drivers/net/ethernet/microchip/lan966x/lan966x_fdb.c
new file mode 100644
index 000000000000..0647f922f116
--- /dev/null
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_fdb.c
@@ -0,0 +1,214 @@
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
+};
+
+static void lan966x_fdb_add_entry(struct lan966x *lan966x,
+				  struct switchdev_notifier_fdb_info *fdb_info)
+{
+	struct lan966x_fdb_entry *fdb_entry;
+
+	fdb_entry = kzalloc(sizeof(*fdb_entry), GFP_KERNEL);
+	if (!fdb_entry)
+		return;
+
+	memcpy(fdb_entry->mac, fdb_info->addr, ETH_ALEN);
+	fdb_entry->vid = fdb_info->vid;
+	list_add_tail(&fdb_entry->list, &lan966x->fdb_entries);
+}
+
+static void lan966x_fdb_del_entry(struct lan966x *lan966x,
+				  struct switchdev_notifier_fdb_info *fdb_info)
+{
+	struct lan966x_fdb_entry *fdb_entry, *tmp;
+
+	list_for_each_entry_safe(fdb_entry, tmp, &lan966x->fdb_entries,
+				 list) {
+		if (fdb_entry->vid == fdb_info->vid &&
+		    ether_addr_equal(fdb_entry->mac, fdb_info->addr)) {
+			list_del(&fdb_entry->list);
+			kfree(fdb_entry);
+
+			break;
+		}
+	}
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
+		/* If the CPU is not part of the vlan then there is no point
+		 * to copy the frames to the CPU because they will be dropped
+		 */
+		if (!lan966x_vlan_cpu_member_cpu_vlan_mask(lan966x,
+							   fdb_info->vid))
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
+			if (!lan966x_vlan_port_any_vlan_mask(lan966x, fdb_info->vid))
+				break;
+
+			lan966x_mac_cpu_learn(lan966x, fdb_info->addr, fdb_info->vid);
+			break;
+		case SWITCHDEV_FDB_DEL_TO_DEVICE:
+			/* It is OK to always forget the entry */
+			lan966x_fdb_del_entry(lan966x, fdb_info);
+			lan966x_mac_cpu_forget(lan966x, fdb_info->addr, fdb_info->vid);
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
+int lan966x_handle_fdb(struct lan966x *lan966x,
+		       unsigned long event, void *ptr)
+{
+	struct net_device *dev = switchdev_notifier_info_to_dev(ptr);
+	struct switchdev_notifier_fdb_info *fdb_info;
+	struct switchdev_notifier_info *info = ptr;
+	struct lan966x_fdb_event_work *fdb_work;
+
+	switch (event) {
+	case SWITCHDEV_FDB_ADD_TO_DEVICE:
+	case SWITCHDEV_FDB_DEL_TO_DEVICE:
+		fdb_info = container_of(info,
+					struct switchdev_notifier_fdb_info,
+					info);
+
+		if (lan966x_netdevice_check(dev) && !fdb_info->added_by_user)
+			break;
+
+		fdb_work = kzalloc(sizeof(*fdb_work), GFP_ATOMIC);
+		if (!fdb_work)
+			return -ENOMEM;
+
+		fdb_work->dev = dev;
+		fdb_work->lan966x = lan966x;
+		fdb_work->event = event;
+		INIT_WORK(&fdb_work->work, lan966x_fdb_event_work);
+		memcpy(&fdb_work->fdb_info, ptr, sizeof(fdb_work->fdb_info));
+		fdb_work->fdb_info.addr = kzalloc(ETH_ALEN, GFP_ATOMIC);
+		if (!fdb_work->fdb_info.addr)
+			goto err_addr_alloc;
+
+		ether_addr_copy((u8 *)fdb_work->fdb_info.addr, fdb_info->addr);
+		dev_hold(dev);
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
index 08d8b230548b..e97d47aecad9 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
@@ -940,8 +940,15 @@ static int lan966x_probe(struct platform_device *pdev)
 	if (err)
 		goto cleanup_ports;
 
+	err = lan966x_fdb_init(lan966x);
+	if (err)
+		goto unregister_notifier_blocks;
+
 	return 0;
 
+unregister_notifier_blocks:
+	lan966x_unregister_notifier_blocks(lan966x);
+
 cleanup_ports:
 	fwnode_handle_put(portnp);
 
@@ -968,6 +975,7 @@ static int lan966x_remove(struct platform_device *pdev)
 
 	lan966x_mac_purge_entries(lan966x);
 	lan966x_ext_purge_entries(lan966x);
+	lan966x_fdb_deinit(lan966x);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
index ac5ae30468ff..461b46eb2896 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
@@ -84,6 +84,7 @@ struct lan966x {
 	struct list_head mac_entries;
 	spinlock_t mac_lock; /* lock for mac_entries list */
 
+	struct list_head fdb_entries;
 	struct list_head ext_entries;
 
 	/* Notifiers */
@@ -107,6 +108,9 @@ struct lan966x {
 	/* interrupts */
 	int xtr_irq;
 	int ana_irq;
+
+	/* worqueue for fdb */
+	struct workqueue_struct *fdb_work;
 };
 
 struct lan966x_port_config {
@@ -210,6 +214,12 @@ int lan966x_vlan_cpu_del_vlan(struct lan966x *lan966x,
 			      struct net_device *dev,
 			      u16 vid);
 
+void lan966x_fdb_write_entries(struct lan966x *lan966x, u16 vid);
+void lan966x_fdb_erase_entries(struct lan966x *lan966x, u16 vid);
+int lan966x_fdb_init(struct lan966x *lan966x);
+void lan966x_fdb_deinit(struct lan966x *lan966x);
+int lan966x_handle_fdb(struct lan966x *lan966x, unsigned long event, void *ptr);
+
 void lan966x_ext_purge_entries(struct lan966x *lan966x);
 void lan966x_ext_init(struct lan966x *lan966x);
 
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c b/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c
index bda8fdf9514a..704613e038cb 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c
@@ -368,6 +368,7 @@ static int lan966x_netdevice_event(struct notifier_block *nb,
 static int lan966x_switchdev_event(struct notifier_block *nb,
 				   unsigned long event, void *ptr)
 {
+	struct lan966x *lan966x = container_of(nb, struct lan966x, switchdev_nb);
 	struct net_device *dev = switchdev_notifier_info_to_dev(ptr);
 	int err;
 
@@ -377,6 +378,10 @@ static int lan966x_switchdev_event(struct notifier_block *nb,
 						     lan966x_netdevice_check,
 						     lan966x_port_attr_set);
 		return notifier_from_errno(err);
+	case SWITCHDEV_FDB_ADD_TO_DEVICE:
+	case SWITCHDEV_FDB_DEL_TO_DEVICE:
+		err = lan966x_handle_fdb(lan966x, event, ptr);
+		return notifier_from_errno(err);
 	}
 
 	return NOTIFY_DONE;
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_vlan.c b/drivers/net/ethernet/microchip/lan966x/lan966x_vlan.c
index 268e93328a08..4d9edf70234e 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_vlan.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_vlan.c
@@ -299,6 +299,7 @@ int lan966x_vlan_port_add_vlan(struct lan966x_port *port,
 		lan966x_mac_cpu_learn(lan966x, port->dev->dev_addr, vid);
 		lan966x_mac_cpu_learn(lan966x, lan966x->bridge->dev_addr, vid);
 		lan966x_vlan_cpu_add_vlan_mask(lan966x, vid);
+		lan966x_fdb_write_entries(lan966x, vid);
 	}
 
 	lan966x_vlan_port_set_vid(port, vid, pvid, untagged);
@@ -330,6 +331,7 @@ int lan966x_vlan_port_del_vlan(struct lan966x_port *port,
 	if (!lan966x_vlan_port_any_vlan_mask(lan966x, vid)) {
 		lan966x_mac_cpu_forget(lan966x, lan966x->bridge->dev_addr, vid);
 		lan966x_vlan_cpu_del_vlan_mask(lan966x, vid);
+		lan966x_fdb_erase_entries(lan966x, vid);
 	}
 
 	return 0;
@@ -369,6 +371,7 @@ int lan966x_vlan_cpu_add_vlan(struct lan966x *lan966x,
 	}
 
 	lan966x_vlan_cpu_add_cpu_vlan_mask(lan966x, vid);
+	lan966x_fdb_write_entries(lan966x, vid);
 
 	return 0;
 }
@@ -399,6 +402,7 @@ int lan966x_vlan_cpu_del_vlan(struct lan966x *lan966x,
 	/* Remove the CPU part of the vlan */
 	lan966x_vlan_cpu_del_cpu_vlan_mask(lan966x, vid);
 	lan966x_vlan_cpu_del_vlan_mask(lan966x, vid);
+	lan966x_fdb_erase_entries(lan966x, vid);
 
 	return 0;
 }
-- 
2.33.0

