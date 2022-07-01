Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94523563B87
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 23:15:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231812AbiGAUt7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 16:49:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231829AbiGAUtw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 16:49:52 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD08961D62;
        Fri,  1 Jul 2022 13:49:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1656708591; x=1688244591;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=uLBjgbQwOwcGQ9N228n/YX+PJ1rvPTIAY79UfblshNM=;
  b=bOZD8VgsK4lK4SObR9nkMeLbEb0CvpcQKu+AIi3oh9WRQSesoHQ9x7Sm
   EOrghty1Nh9l/xKZHotxhHPFxLXM85iwFqsSwj97dSJD3ABaZlBm0RV2L
   Hv3ybdoRpj8MrW4pfzV+B0u/KV0IHGI5eVX4ajKfCX4KM41WmLr1VBT8E
   mAdOrBZe5N0RxUB9xSX5j0ul5wUzuxaUXyvoRpZVSbNlnDV/ggg/JrmJx
   k62fP0ZXXVKfl2ZSDYasy0TRaVCBRPxdPumLJI30A2ElIiDUYHV2JwjNf
   99xZOUoAyMTvaWcSmNRuUBsMJlyJYC9ZlhGdGlfrF3KQgxErVf+Gx/EX1
   w==;
X-IronPort-AV: E=Sophos;i="5.92,238,1650956400"; 
   d="scan'208";a="102710230"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 01 Jul 2022 13:49:51 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 1 Jul 2022 13:49:49 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Fri, 1 Jul 2022 13:49:47 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <vladimir.oltean@nxp.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v3 6/7] net: lan966x: Extend FDB to support also lag
Date:   Fri, 1 Jul 2022 22:52:26 +0200
Message-ID: <20220701205227.1337160-7-horatiu.vultur@microchip.com>
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

Offload FDB entries when the original device is a lag interface. Because
all the ports under the lag have the same chip id, which is the chip id
of first port, then add the entries only for the first port.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 .../ethernet/microchip/lan966x/lan966x_fdb.c  | 30 +++++++++++++++++++
 .../microchip/lan966x/lan966x_switchdev.c     |  4 ++-
 2 files changed, 33 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_fdb.c b/drivers/net/ethernet/microchip/lan966x/lan966x_fdb.c
index 5142e7c0de31..2ea263e893ee 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_fdb.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_fdb.c
@@ -199,6 +199,34 @@ static void lan966x_fdb_bridge_event_work(struct lan966x_fdb_event_work *fdb_wor
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
+		lan966x_mac_add_entry(lan966x, port, fdb_info->addr,
+				      fdb_info->vid);
+		break;
+	case SWITCHDEV_FDB_DEL_TO_DEVICE:
+		if (!fdb_info->added_by_user)
+			break;
+		lan966x_mac_del_entry(lan966x, fdb_info->addr, fdb_info->vid);
+		break;
+	}
+}
+
 static void lan966x_fdb_event_work(struct work_struct *work)
 {
 	struct lan966x_fdb_event_work *fdb_work =
@@ -208,6 +236,8 @@ static void lan966x_fdb_event_work(struct work_struct *work)
 		lan966x_fdb_port_event_work(fdb_work);
 	else if (netif_is_bridge_master(fdb_work->orig_dev))
 		lan966x_fdb_bridge_event_work(fdb_work);
+	else if (netif_is_lag_master(fdb_work->orig_dev))
+		lan966x_fdb_lag_event_work(fdb_work);
 
 	kfree(fdb_work->fdb_info.addr);
 	kfree(fdb_work);
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c b/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c
index 0cd53dca87ce..ced0194f6246 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c
@@ -345,8 +345,10 @@ int lan966x_port_prechangeupper(struct net_device *dev,
 	if (netif_is_lag_master(info->upper_dev) && info->linking)
 		err = lan966x_lag_port_prechangeupper(dev, info);
 
-	if (netif_is_lag_master(info->upper_dev) && !info->linking)
+	if (netif_is_lag_master(info->upper_dev) && !info->linking) {
 		switchdev_bridge_port_unoffload(brport_dev, port, NULL, NULL);
+		lan966x_fdb_flush_workqueue(port->lan966x);
+	}
 
 	return err;
 }
-- 
2.33.0

