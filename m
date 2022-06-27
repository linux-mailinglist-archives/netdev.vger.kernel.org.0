Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DA5C55DC3F
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:25:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239453AbiF0UKM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 16:10:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241109AbiF0UKH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 16:10:07 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 488CC1F2D4;
        Mon, 27 Jun 2022 13:10:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1656360601; x=1687896601;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=U4To6aMOyvxjiN/z2Z1G/xUA+9utt8CgxLAwVqYIuS0=;
  b=lZuOfPFgSiYv7LbHuOk0zDEra3fSkXU1jQ+3kxq8kAyM9vLrKXopgrsR
   YnVelJkjuy4CM2+68evO7jHn4HO5/0QZVTIoeG2s5bwtelsG9qFPn24II
   Hjri4pYaVH7f6DBA6wDLBfdji8O6FyZ5fvnOSGxTRdst1uqbCPh07tgdM
   Dj6f7VWBAg+b3f6DBfypzHuShO0/AYn9bZnu6Lx3aitPV2KukMSI8R1XL
   J/zVQHf+nv2O5jTIPhb1xUomyU/OltMTCb5NN3Npp3C7AkHYlb930IMUD
   VBd881yHbcrmUCElhkrb1m3GrODWv7rW5//rR0JGQ3Qhs1ugGpyb3DUtK
   A==;
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="170092530"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 27 Jun 2022 13:10:00 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Mon, 27 Jun 2022 13:10:00 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Mon, 27 Jun 2022 13:09:58 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <vladimir.oltean@nxp.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v2 6/7] net: lan966x: Extend FDB to support also lag
Date:   Mon, 27 Jun 2022 22:13:29 +0200
Message-ID: <20220627201330.45219-7-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220627201330.45219-1-horatiu.vultur@microchip.com>
References: <20220627201330.45219-1-horatiu.vultur@microchip.com>
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
index 0da398e51aa3..dd372a6497bb 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_lag.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_lag.c
@@ -290,3 +290,19 @@ u32 lan966x_lag_get_mask(struct lan966x *lan966x, struct net_device *bond)
 
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
index 23ddabea8d70..1d7fe0e2a243 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
@@ -425,6 +425,13 @@ int lan966x_lag_netdev_changeupper(struct net_device *dev,
 				   struct netdev_notifier_changeupper_info *info);
 bool lan966x_lag_first_port(struct net_device *lag, struct net_device *dev);
 u32 lan966x_lag_get_mask(struct lan966x *lan966x, struct net_device *bond);
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

