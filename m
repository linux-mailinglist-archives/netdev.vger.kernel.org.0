Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D45016ADD27
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 12:21:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230166AbjCGLVY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 06:21:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbjCGLVU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 06:21:20 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95F4F30B11;
        Tue,  7 Mar 2023 03:21:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1678188073; x=1709724073;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=eCfUgtTxJ2t2NJLQ6fRvVzcuPMgRk/uF6FvhuOQIZow=;
  b=fGk3d1X47cO0LJuHD/Ysknf/qoI/G3WING6BYp7y9lHHYQMkr7wGZrHa
   K7n1jriMC082Bvtw6UUrc+OtLfHa2qkm83hWVOSQwynUi0USpNZCithAe
   wFzmTs9EYGMOYPJ0LwjTuqx4lM+4nlRQd1gpAZt7vXzwWZ/5aRK23Teua
   4Okp5Do0ExJFCm0qTcKohwLN2ejK1MC+uv7rdo8iAaDu4TWTgQosntIf5
   i6ByyHCJXq08ID99VVw4oxprVtNjEkye98aOVH5TeeFHn8JyhjYMZtTJr
   o/4kn1Rtbj9dm1O8nOObxB6vGufecn2D2d56/9hytXZWNvJoFzLZWSUgW
   g==;
X-IronPort-AV: E=Sophos;i="5.98,240,1673938800"; 
   d="scan'208";a="200344170"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 07 Mar 2023 04:21:12 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 7 Mar 2023 04:21:11 -0700
Received: from DEN-LT-70577.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Tue, 7 Mar 2023 04:21:09 -0700
From:   Daniel Machon <daniel.machon@microchip.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <lars.povlsen@microchip.com>,
        <Steen.Hegelund@microchip.com>, <daniel.machon@microchip.com>,
        <UNGLinuxDriver@microchip.com>, <joe@perches.com>,
        <error27@gmail.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net] net: microchip: sparx5: fix deletion of existing DSCP mappings
Date:   Tue, 7 Mar 2023 12:21:03 +0100
Message-ID: <20230307112103.2733285-1-daniel.machon@microchip.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix deletion of existing DSCP mappings in the APP table.

Adding and deleting DSCP entries are replicated per-port, since the
mapping table is global for all ports in the chip. Whenever a mapping
for a DSCP value already exists, the old mapping is deleted first.
However, it is only deleted for the specified port. Fix this by calling
sparx5_dcb_ieee_delapp() instead of dcb_ieee_delapp() as it ought to be.

Reproduce:

// Map and remap DSCP value 63
$ dcb app add dev eth0 dscp-prio 63:1
$ dcb app add dev eth0 dscp-prio 63:2

$ dcb app show dev eth0 dscp-prio
dscp-prio 63:2

$ dcb app show dev eth1 dscp-prio
dscp-prio 63:1 63:2 <-- 63:1 should not be there

Fixes: 8dcf69a64118 ("net: microchip: sparx5: add support for offloading dscp table")
Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
---
 .../ethernet/microchip/sparx5/sparx5_dcb.c    | 32 +++++++++----------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_dcb.c b/drivers/net/ethernet/microchip/sparx5/sparx5_dcb.c
index 871a3e62f852..2d763664dcda 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_dcb.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_dcb.c
@@ -249,6 +249,21 @@ static int sparx5_dcb_ieee_dscp_setdel(struct net_device *dev,
 	return 0;
 }
 
+static int sparx5_dcb_ieee_delapp(struct net_device *dev, struct dcb_app *app)
+{
+	int err;
+
+	if (app->selector == IEEE_8021QAZ_APP_SEL_DSCP)
+		err = sparx5_dcb_ieee_dscp_setdel(dev, app, dcb_ieee_delapp);
+	else
+		err = dcb_ieee_delapp(dev, app);
+
+	if (err < 0)
+		return err;
+
+	return sparx5_dcb_app_update(dev);
+}
+
 static int sparx5_dcb_ieee_setapp(struct net_device *dev, struct dcb_app *app)
 {
 	struct dcb_app app_itr;
@@ -264,7 +279,7 @@ static int sparx5_dcb_ieee_setapp(struct net_device *dev, struct dcb_app *app)
 	if (prio) {
 		app_itr = *app;
 		app_itr.priority = prio;
-		dcb_ieee_delapp(dev, &app_itr);
+		sparx5_dcb_ieee_delapp(dev, &app_itr);
 	}
 
 	if (app->selector == IEEE_8021QAZ_APP_SEL_DSCP)
@@ -281,21 +296,6 @@ static int sparx5_dcb_ieee_setapp(struct net_device *dev, struct dcb_app *app)
 	return err;
 }
 
-static int sparx5_dcb_ieee_delapp(struct net_device *dev, struct dcb_app *app)
-{
-	int err;
-
-	if (app->selector == IEEE_8021QAZ_APP_SEL_DSCP)
-		err = sparx5_dcb_ieee_dscp_setdel(dev, app, dcb_ieee_delapp);
-	else
-		err = dcb_ieee_delapp(dev, app);
-
-	if (err < 0)
-		return err;
-
-	return sparx5_dcb_app_update(dev);
-}
-
 static int sparx5_dcb_setapptrust(struct net_device *dev, u8 *selectors,
 				  int nselectors)
 {
-- 
2.34.1

