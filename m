Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5657555B20D
	for <lists+netdev@lfdr.de>; Sun, 26 Jun 2022 15:19:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234457AbiFZNB4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jun 2022 09:01:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234503AbiFZNBs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jun 2022 09:01:48 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD53311A1C;
        Sun, 26 Jun 2022 06:01:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1656248508; x=1687784508;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=v4ewXtQaGgwW5iys93gT3kqcBhf48xa7ZdxfpZsJxCA=;
  b=QJ0DKhhOyMfKRYFiSSvf6UUa3bSxsrVB9RQjRKOvs8hbxroLJpKHQNxh
   shA8B2CXQC1NLfYxDHfiYANyXbfLZE9xAKmw05IckwNpCkX0Ja+cU655e
   j0KkmIH1Rjy6bf3e2eUtQj61h+DMZJRHwymXh/V702nDYaXq9Lg/QsPcO
   N5AgZdY4ocVTJnw/cp+DcqY37i0K8BMRlzo1qh0mfBPHBgW6+27VStPx/
   L7IZ56bU5AWXaKqODYP2dCEGeycsUhaoTynbQ/WjH28IADmJspMPJ1iQU
   ZYcCHeiKq4u4c56FIZSWzuCCobEBdaWiwP+6jur2Vm4lTEgRAryWbXSvI
   w==;
X-IronPort-AV: E=Sophos;i="5.92,224,1650956400"; 
   d="scan'208";a="169642292"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 26 Jun 2022 06:01:47 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Sun, 26 Jun 2022 06:01:46 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Sun, 26 Jun 2022 06:01:45 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux@armlinux.org.uk>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next 6/8] net: lan966x: Extend FDB to support also lag
Date:   Sun, 26 Jun 2022 15:04:49 +0200
Message-ID: <20220626130451.1079933-7-horatiu.vultur@microchip.com>
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

Offload FDB entries when the original device is a lag interface. Because
all the ports under the lag have the same chip id, which is the chip id
of first port, then add the entries only for the first port.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 .../ethernet/microchip/lan966x/lan966x_fdb.c  | 31 +++++++++++++++++++
 .../ethernet/microchip/lan966x/lan966x_lag.c  | 16 ++++++++++
 .../ethernet/microchip/lan966x/lan966x_main.h |  7 +++++
 3 files changed, 54 insertions(+)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_fdb.c b/drivers/net/ethernet/microchip/lan966x/lan966x_fdb.c
index 2e186e9d9893..154efbd0c319 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_fdb.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_fdb.c
@@ -194,6 +194,35 @@ static void lan966x_fdb_bridge_event_work(struct lan966x_fdb_event_work *fdb_wor
 	}
 }
 
+static void lan966x_fdb_lag_event_work(struct lan966x_fdb_event_work *fdb_work)
+{
+	struct switchdev_notifier_fdb_info *fdb_info;
+	struct lan966x_port *port;
+	struct lan966x *lan966x;
+
+	if (!lan966x_lag_first_port(fdb_work->orig_dev, fdb_work->dev))
+		return;
+
+	lan966x = fdb_work->lan966x;
+	port = netdev_priv(fdb_work->dev);
+	fdb_info = &fdb_work->fdb_info;
+
+	switch (fdb_work->event) {
+	case SWITCHDEV_FDB_ADD_TO_DEVICE:
+		if (!fdb_info->added_by_user)
+			break;
+		lan966x_lag_mac_add_entry(lan966x, port, fdb_info->addr,
+					  fdb_info->vid);
+		break;
+	case SWITCHDEV_FDB_DEL_TO_DEVICE:
+		if (!fdb_info->added_by_user)
+			break;
+		lan966x_lag_mac_del_entry(lan966x, fdb_info->addr,
+					  fdb_info->vid);
+		break;
+	}
+}
+
 static void lan966x_fdb_event_work(struct work_struct *work)
 {
 	struct lan966x_fdb_event_work *fdb_work =
@@ -203,6 +232,8 @@ static void lan966x_fdb_event_work(struct work_struct *work)
 		lan966x_fdb_port_event_work(fdb_work);
 	else if (netif_is_bridge_master(fdb_work->orig_dev))
 		lan966x_fdb_bridge_event_work(fdb_work);
+	else if (netif_is_lag_master(fdb_work->orig_dev))
+		lan966x_fdb_lag_event_work(fdb_work);
 
 	kfree(fdb_work->fdb_info.addr);
 	dev_put(fdb_work->orig_dev);
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_lag.c b/drivers/net/ethernet/microchip/lan966x/lan966x_lag.c
index c721a05d44d2..db21bd358e4e 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_lag.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_lag.c
@@ -294,3 +294,19 @@ u32 lan966x_lag_get_mask(struct lan966x *lan966x, struct net_device *bond,
 
 	return mask;
 }
+
+void lan966x_lag_mac_del_entry(struct lan966x *lan966x,
+			       const unsigned char *addr,
+			       u16 vid)
+{
+	lan966x_mac_del_entry(lan966x, addr, vid);
+}
+
+int lan966x_lag_mac_add_entry(struct lan966x *lan966x,
+			      struct lan966x_port *port,
+			      const unsigned char *addr,
+			      u16 vid)
+{
+	lan966x_mac_del_entry(lan966x, addr, vid);
+	return lan966x_mac_add_entry(lan966x, port, addr, vid);
+}
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
index 2c382cf8fe3a..7b4805813549 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
@@ -426,6 +426,13 @@ int lan966x_lag_netdev_changeupper(struct net_device *dev,
 bool lan966x_lag_first_port(struct net_device *lag, struct net_device *dev);
 u32 lan966x_lag_get_mask(struct lan966x *lan966x, struct net_device *bond,
 			 bool only_active_ports);
+void lan966x_lag_mac_del_entry(struct lan966x *lan966x,
+			       const unsigned char *addr,
+			       u16 vid);
+int lan966x_lag_mac_add_entry(struct lan966x *lan966x,
+			      struct lan966x_port *port,
+			      const unsigned char *addr,
+			      u16 vid);
 
 int lan966x_port_changeupper(struct net_device *dev,
 			     struct net_device *brport_dev,
-- 
2.33.0

