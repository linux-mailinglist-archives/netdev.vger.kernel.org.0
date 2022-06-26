Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE61955B226
	for <lists+netdev@lfdr.de>; Sun, 26 Jun 2022 15:20:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234483AbiFZNBo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jun 2022 09:01:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234464AbiFZNBk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jun 2022 09:01:40 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07BC611806;
        Sun, 26 Jun 2022 06:01:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1656248499; x=1687784499;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=l8PLcpAW+05bj+/uxzU1/y+AeAamlgL6G1IVGHoCDKI=;
  b=c4Xz7tjC9Hc2kQBcB22+aYN2pP97Wm+lVOa0qs+Vd4G13BuGaaE5eWII
   Rn7ShGnLATPGpMiIA4wOp8fhxxMC+9K/Clh5KjxOd6j7o5w7ROZgvv8eI
   fef7fNa9Ruv8z6wX3LX02/orbDETWh1M+TL8yvHNRzr9b0UCzd/6Fsajm
   O99NIo3R/bYRvKk73anQXFzU5/LvzVwPz8FWx3ieOx0AzOaiJIN8yYYFu
   yZfVRFlOVL/tSNia3dvAsmRnuz+iksTsTGZA7k0vJaU8rfIA/m1iNIkye
   XYOwZdsBA7FNZ5Gr2JuBYhLOJrJyGDpBIrvyeHXjusLxUyKhT2txnU65t
   g==;
X-IronPort-AV: E=Sophos;i="5.92,224,1650956400"; 
   d="scan'208";a="169642207"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 26 Jun 2022 06:01:38 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Sun, 26 Jun 2022 06:01:38 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Sun, 26 Jun 2022 06:01:36 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux@armlinux.org.uk>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next 2/8] net: lan966x: Split lan966x_fdb_event_work
Date:   Sun, 26 Jun 2022 15:04:45 +0200
Message-ID: <20220626130451.1079933-3-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220626130451.1079933-1-horatiu.vultur@microchip.com>
References: <20220626130451.1079933-1-horatiu.vultur@microchip.com>
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
 .../ethernet/microchip/lan966x/lan966x_fdb.c  | 124 ++++++++++--------
 1 file changed, 69 insertions(+), 55 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_fdb.c b/drivers/net/ethernet/microchip/lan966x/lan966x_fdb.c
index da5ca7188679..2e186e9d9893 100644
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
+	dev_put(fdb_work->orig_dev);
+	dev_put(fdb_work->dev);
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
@@ -232,6 +245,7 @@ int lan966x_handle_fdb(struct net_device *dev,
 
 		ether_addr_copy((u8 *)fdb_work->fdb_info.addr, fdb_info->addr);
 		dev_hold(orig_dev);
+		dev_hold(dev);
 
 		queue_work(lan966x->fdb_work, &fdb_work->work);
 		break;
-- 
2.33.0

