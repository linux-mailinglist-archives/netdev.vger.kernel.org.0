Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D773559768B
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 21:35:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238084AbiHQTbH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 15:31:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240028AbiHQTbF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 15:31:05 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E7BBA3445;
        Wed, 17 Aug 2022 12:31:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1660764664; x=1692300664;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yGQVe97m3FL+2u+P9uvvqevYNKvYLpHo3J821zNyrms=;
  b=J+vmrWJRi1cRMPdq8ICiEugrvsK7zlHSUcCFxkLcfqTOp14p8d+P6uv9
   JIVkAtPeHm8//3xz5QTMgEDbbVUr87gCZNJvYuPPfS9GtXvlfwsdbF5Kt
   vJ9eSn6U4uSem7z73dpRzmsHtjVA0t9iu4av2yKkw8gD5aL7efrEOeGy1
   vvqEWuxj/GEq5O2A7gwRt59YMP4cu+NJCDp0l4iUiMbVT6RB0c3aEmDRj
   9NCuKXF/If06aHlVOUg63Y/EXSrU9EtBHnUjrlZB+KEiiFPqkZMC71UhB
   QQa0uKQpfvEl1HviO6pUNuogNbCdfmCVIUyx242ZPKycXStzT3TA6pnXH
   Q==;
X-IronPort-AV: E=Sophos;i="5.93,244,1654585200"; 
   d="scan'208";a="176816595"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Aug 2022 12:31:02 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Wed, 17 Aug 2022 12:30:50 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Wed, 17 Aug 2022 12:30:48 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux@armlinux.org.uk>, <vladimir.oltean@nxp.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v4 2/8] net: lan966x: Split lan966x_fdb_event_work
Date:   Wed, 17 Aug 2022 21:34:43 +0200
Message-ID: <20220817193449.1673002-3-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220817193449.1673002-1-horatiu.vultur@microchip.com>
References: <20220817193449.1673002-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
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
 .../ethernet/microchip/lan966x/lan966x_fdb.c  | 124 ++++++++++--------
 1 file changed, 69 insertions(+), 55 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_fdb.c b/drivers/net/ethernet/microchip/lan966x/lan966x_fdb.c
index da5ca7188679..c760f73c0621 100644
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
@@ -127,75 +128,86 @@ void lan966x_fdb_deinit(struct lan966x *lan966x)
 	lan966x_fdb_purge_entries(lan966x);
 }
 
-static void lan966x_fdb_event_work(struct work_struct *work)
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
+	dev_put(fdb_work->dev);
+	dev_put(fdb_work->orig_dev);
 	kfree(fdb_work);
-	dev_put(dev);
 }
 
 int lan966x_handle_fdb(struct net_device *dev,
@@ -221,7 +233,8 @@ int lan966x_handle_fdb(struct net_device *dev,
 		if (!fdb_work)
 			return -ENOMEM;
 
-		fdb_work->dev = orig_dev;
+		fdb_work->dev = dev;
+		fdb_work->orig_dev = orig_dev;
 		fdb_work->lan966x = lan966x;
 		fdb_work->event = event;
 		INIT_WORK(&fdb_work->work, lan966x_fdb_event_work);
@@ -231,6 +244,7 @@ int lan966x_handle_fdb(struct net_device *dev,
 			goto err_addr_alloc;
 
 		ether_addr_copy((u8 *)fdb_work->fdb_info.addr, fdb_info->addr);
+		dev_hold(dev);
 		dev_hold(orig_dev);
 
 		queue_work(lan966x->fdb_work, &fdb_work->work);
-- 
2.33.0

