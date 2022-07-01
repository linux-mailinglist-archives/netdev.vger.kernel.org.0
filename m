Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19B95563B67
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 23:15:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231529AbiGAUtp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 16:49:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231237AbiGAUtl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 16:49:41 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9688760513;
        Fri,  1 Jul 2022 13:49:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1656708580; x=1688244580;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BhBEDyrcgXQPrpZ0wG5o7U3x9cyMKtuWv0qQdat7G4A=;
  b=zPBomzL3Xrlwzx3t6a3onCuw/7DwPgwjZY3hevJSE7jfVCmMxt7qmVqf
   i84Ku5Lqpw8X6HCM3hk880SNhUIHq+bn9w0psUuppczwIllyLwaE5kH4t
   A3d2zorV7HsECoJf30B3m2j6AK4bBrMPWsFBs+5Ar2Z52b+SMAd/C+LZn
   OLQpNeMC5+Roze4m9is20I9yRks6YMc8IUcpHosQznx3gwJnag0TX68e1
   4RJi0yKC1U1QsX45M7iqmW1L9ZimLj4IHXOPvZJdk1KrGDbc5rYwNGZh5
   OaraQ8u/t0POC46wAY5azDkyeChEkklVt9CNaFEysIf2KzUnlhS0Pqa0P
   g==;
X-IronPort-AV: E=Sophos;i="5.92,238,1650956400"; 
   d="scan'208";a="170467264"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 01 Jul 2022 13:49:40 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 1 Jul 2022 13:49:39 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Fri, 1 Jul 2022 13:49:37 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <vladimir.oltean@nxp.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v3 2/7] net: lan966x: Split lan966x_fdb_event_work
Date:   Fri, 1 Jul 2022 22:52:22 +0200
Message-ID: <20220701205227.1337160-3-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220701205227.1337160-1-horatiu.vultur@microchip.com>
References: <20220701205227.1337160-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Split the function lan966x_fdb_event_work. One case for when the
orig_dev is a bridge and one case when orig_dev is lan966x port.
This is preparation for lag support. There is no functional change.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 .../ethernet/microchip/lan966x/lan966x_fdb.c  | 127 ++++++++++--------
 .../ethernet/microchip/lan966x/lan966x_main.h |   1 +
 .../microchip/lan966x/lan966x_switchdev.c     |   7 +-
 3 files changed, 76 insertions(+), 59 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_fdb.c b/drivers/net/ethernet/microchip/lan966x/lan966x_fdb.c
index da5ca7188679..5142e7c0de31 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_fdb.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_fdb.c
@@ -8,6 +8,7 @@ struct lan966x_fdb_event_work {
 	struct work_struct work;
 	struct switchdev_notifier_fdb_info fdb_info;
 	struct net_device *dev;
+	struct net_device *orig_dev;
 	struct lan966x *lan966x;
 	unsigned long event;
 };
@@ -127,75 +128,89 @@ void lan966x_fdb_deinit(struct lan966x *lan966x)
 	lan966x_fdb_purge_entries(lan966x);
 }
 
-static void lan966x_fdb_event_work(struct work_struct *work)
+void lan966x_fdb_flush_workqueue(struct lan966x *lan966x)
+{
+	flush_workqueue(lan966x->fdb_work);
+}
+
+static void lan966x_fdb_port_event_work(struct lan966x_fdb_event_work *fdb_work)
 {
-	struct lan966x_fdb_event_work *fdb_work =
-		container_of(work, struct lan966x_fdb_event_work, work);
 	struct switchdev_notifier_fdb_info *fdb_info;
-	struct net_device *dev = fdb_work->dev;
 	struct lan966x_port *port;
 	struct lan966x *lan966x;
-	int ret;
 
-	fdb_info = &fdb_work->fdb_info;
 	lan966x = fdb_work->lan966x;
+	port = netdev_priv(fdb_work->orig_dev);
+	fdb_info = &fdb_work->fdb_info;
 
-	if (lan966x_netdevice_check(dev)) {
-		port = netdev_priv(dev);
-
-		switch (fdb_work->event) {
-		case SWITCHDEV_FDB_ADD_TO_DEVICE:
-			if (!fdb_info->added_by_user)
-				break;
-			lan966x_mac_add_entry(lan966x, port, fdb_info->addr,
-					      fdb_info->vid);
+	switch (fdb_work->event) {
+	case SWITCHDEV_FDB_ADD_TO_DEVICE:
+		if (!fdb_info->added_by_user)
 			break;
-		case SWITCHDEV_FDB_DEL_TO_DEVICE:
-			if (!fdb_info->added_by_user)
-				break;
-			lan966x_mac_del_entry(lan966x, fdb_info->addr,
-					      fdb_info->vid);
+		lan966x_mac_add_entry(lan966x, port, fdb_info->addr,
+				      fdb_info->vid);
+		break;
+	case SWITCHDEV_FDB_DEL_TO_DEVICE:
+		if (!fdb_info->added_by_user)
 			break;
-		}
-	} else {
-		if (!netif_is_bridge_master(dev))
-			goto out;
-
-		/* In case the bridge is called */
-		switch (fdb_work->event) {
-		case SWITCHDEV_FDB_ADD_TO_DEVICE:
-			/* If there is no front port in this vlan, there is no
-			 * point to copy the frame to CPU because it would be
-			 * just dropped at later point. So add it only if
-			 * there is a port but it is required to store the fdb
-			 * entry for later point when a port actually gets in
-			 * the vlan.
-			 */
-			lan966x_fdb_add_entry(lan966x, fdb_info);
-			if (!lan966x_vlan_cpu_member_cpu_vlan_mask(lan966x,
-								   fdb_info->vid))
-				break;
-
-			lan966x_mac_cpu_learn(lan966x, fdb_info->addr,
-					      fdb_info->vid);
+		lan966x_mac_del_entry(lan966x, fdb_info->addr,
+				      fdb_info->vid);
+		break;
+	}
+}
+
+static void lan966x_fdb_bridge_event_work(struct lan966x_fdb_event_work *fdb_work)
+{
+	struct switchdev_notifier_fdb_info *fdb_info;
+	struct lan966x *lan966x;
+	int ret;
+
+	lan966x = fdb_work->lan966x;
+	fdb_info = &fdb_work->fdb_info;
+
+	/* In case the bridge is called */
+	switch (fdb_work->event) {
+	case SWITCHDEV_FDB_ADD_TO_DEVICE:
+		/* If there is no front port in this vlan, there is no
+		 * point to copy the frame to CPU because it would be
+		 * just dropped at later point. So add it only if
+		 * there is a port but it is required to store the fdb
+		 * entry for later point when a port actually gets in
+		 * the vlan.
+		 */
+		lan966x_fdb_add_entry(lan966x, fdb_info);
+		if (!lan966x_vlan_cpu_member_cpu_vlan_mask(lan966x,
+							   fdb_info->vid))
 			break;
-		case SWITCHDEV_FDB_DEL_TO_DEVICE:
-			ret = lan966x_fdb_del_entry(lan966x, fdb_info);
-			if (!lan966x_vlan_cpu_member_cpu_vlan_mask(lan966x,
-								   fdb_info->vid))
-				break;
-
-			if (ret)
-				lan966x_mac_cpu_forget(lan966x, fdb_info->addr,
-						       fdb_info->vid);
+
+		lan966x_mac_cpu_learn(lan966x, fdb_info->addr,
+				      fdb_info->vid);
+		break;
+	case SWITCHDEV_FDB_DEL_TO_DEVICE:
+		ret = lan966x_fdb_del_entry(lan966x, fdb_info);
+		if (!lan966x_vlan_cpu_member_cpu_vlan_mask(lan966x,
+							   fdb_info->vid))
 			break;
-		}
+
+		if (ret)
+			lan966x_mac_cpu_forget(lan966x, fdb_info->addr,
+					       fdb_info->vid);
+		break;
 	}
+}
+
+static void lan966x_fdb_event_work(struct work_struct *work)
+{
+	struct lan966x_fdb_event_work *fdb_work =
+		container_of(work, struct lan966x_fdb_event_work, work);
+
+	if (lan966x_netdevice_check(fdb_work->orig_dev))
+		lan966x_fdb_port_event_work(fdb_work);
+	else if (netif_is_bridge_master(fdb_work->orig_dev))
+		lan966x_fdb_bridge_event_work(fdb_work);
 
-out:
 	kfree(fdb_work->fdb_info.addr);
 	kfree(fdb_work);
-	dev_put(dev);
 }
 
 int lan966x_handle_fdb(struct net_device *dev,
@@ -221,7 +236,8 @@ int lan966x_handle_fdb(struct net_device *dev,
 		if (!fdb_work)
 			return -ENOMEM;
 
-		fdb_work->dev = orig_dev;
+		fdb_work->dev = dev;
+		fdb_work->orig_dev = orig_dev;
 		fdb_work->lan966x = lan966x;
 		fdb_work->event = event;
 		INIT_WORK(&fdb_work->work, lan966x_fdb_event_work);
@@ -231,7 +247,6 @@ int lan966x_handle_fdb(struct net_device *dev,
 			goto err_addr_alloc;
 
 		ether_addr_copy((u8 *)fdb_work->fdb_info.addr, fdb_info->addr);
-		dev_hold(orig_dev);
 
 		queue_work(lan966x->fdb_work, &fdb_work->work);
 		break;
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
index 3b86ddddc756..0a4f4d27eaa7 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
@@ -368,6 +368,7 @@ void lan966x_fdb_write_entries(struct lan966x *lan966x, u16 vid);
 void lan966x_fdb_erase_entries(struct lan966x *lan966x, u16 vid);
 int lan966x_fdb_init(struct lan966x *lan966x);
 void lan966x_fdb_deinit(struct lan966x *lan966x);
+void lan966x_fdb_flush_workqueue(struct lan966x *lan966x);
 int lan966x_handle_fdb(struct net_device *dev,
 		       struct net_device *orig_dev,
 		       unsigned long event, const void *ctx,
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c b/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c
index df2bee678559..d9fc6a9a3da1 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c
@@ -320,9 +320,10 @@ static int lan966x_port_prechangeupper(struct net_device *dev,
 {
 	struct lan966x_port *port = netdev_priv(dev);
 
-	if (netif_is_bridge_master(info->upper_dev) && !info->linking)
-		switchdev_bridge_port_unoffload(port->dev, port,
-						NULL, NULL);
+	if (netif_is_bridge_master(info->upper_dev) && !info->linking) {
+		switchdev_bridge_port_unoffload(port->dev, port, NULL, NULL);
+		lan966x_fdb_flush_workqueue(port->lan966x);
+	}
 
 	return NOTIFY_DONE;
 }
-- 
2.33.0

