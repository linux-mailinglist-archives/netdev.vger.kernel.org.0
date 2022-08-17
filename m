Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E67B5597685
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 21:35:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241487AbiHQTbZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 15:31:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241317AbiHQTbI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 15:31:08 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A291DA3D7D;
        Wed, 17 Aug 2022 12:31:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1660764665; x=1692300665;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=L8oUuql8GbWWxgRE2Ot5x09CKvan9NZAwQO1YKyEOZQ=;
  b=K2YDOF2BD4/MJwrKnT+pLeTFIvcVefvDPaZaFosYbPjk9yMUC7ZfBEzW
   lww6GGez/0EzfON/IElSJXUxXbb2T0n+HpKXx2jxZnkNyNoyM6Oia3FUQ
   LTxYjRAQpxEFmmXHDSvjQgOG498V/4Q+egLs3G2zF7hXX0jICAKSVJI+9
   w8jxCcwjxFLiC9LoaMeK2ZMyw2GmGof63/eAIaDCwxqIK1smet/Cn17/F
   hBTuXvDCbCIkIELMyk5Z6dL7/Dm5PdJIbwEnK0QcsyCN5dG6fofOQGFnk
   AS6k3ZI4kdYJC9NB+JE1rnvDzhXW+PAsEpwWXsjYpwDrm7vbvGZj+/4jX
   w==;
X-IronPort-AV: E=Sophos;i="5.93,244,1654585200"; 
   d="scan'208";a="176816610"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Aug 2022 12:31:04 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Wed, 17 Aug 2022 12:30:52 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Wed, 17 Aug 2022 12:30:50 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux@armlinux.org.uk>, <vladimir.oltean@nxp.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v4 3/8] net: lan966x: Flush fdb workqueue when port is leaving a bridge.
Date:   Wed, 17 Aug 2022 21:34:44 +0200
Message-ID: <20220817193449.1673002-4-horatiu.vultur@microchip.com>
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

Whenever a port leaves a bridge, flush the workqueue of the FDB work.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 drivers/net/ethernet/microchip/lan966x/lan966x_fdb.c     | 9 +++++----
 drivers/net/ethernet/microchip/lan966x/lan966x_main.h    | 1 +
 .../net/ethernet/microchip/lan966x/lan966x_switchdev.c   | 7 ++++---
 3 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_fdb.c b/drivers/net/ethernet/microchip/lan966x/lan966x_fdb.c
index c760f73c0621..5142e7c0de31 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_fdb.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_fdb.c
@@ -128,6 +128,11 @@ void lan966x_fdb_deinit(struct lan966x *lan966x)
 	lan966x_fdb_purge_entries(lan966x);
 }
 
+void lan966x_fdb_flush_workqueue(struct lan966x *lan966x)
+{
+	flush_workqueue(lan966x->fdb_work);
+}
+
 static void lan966x_fdb_port_event_work(struct lan966x_fdb_event_work *fdb_work)
 {
 	struct switchdev_notifier_fdb_info *fdb_info;
@@ -205,8 +210,6 @@ static void lan966x_fdb_event_work(struct work_struct *work)
 		lan966x_fdb_bridge_event_work(fdb_work);
 
 	kfree(fdb_work->fdb_info.addr);
-	dev_put(fdb_work->dev);
-	dev_put(fdb_work->orig_dev);
 	kfree(fdb_work);
 }
 
@@ -244,8 +247,6 @@ int lan966x_handle_fdb(struct net_device *dev,
 			goto err_addr_alloc;
 
 		ether_addr_copy((u8 *)fdb_work->fdb_info.addr, fdb_info->addr);
-		dev_hold(dev);
-		dev_hold(orig_dev);
 
 		queue_work(lan966x->fdb_work, &fdb_work->work);
 		break;
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
index 2787055c1847..b02c1c803945 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
@@ -369,6 +369,7 @@ void lan966x_fdb_write_entries(struct lan966x *lan966x, u16 vid);
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

