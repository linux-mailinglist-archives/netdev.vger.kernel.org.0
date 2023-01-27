Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36C1867DB71
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 02:48:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232545AbjA0BsV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 20:48:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232076AbjA0BsT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 20:48:19 -0500
Received: from relmlie6.idc.renesas.com (relmlor2.renesas.com [210.160.252.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 371EE22A0C;
        Thu, 26 Jan 2023 17:48:18 -0800 (PST)
X-IronPort-AV: E=Sophos;i="5.97,249,1669042800"; 
   d="scan'208";a="150707073"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie6.idc.renesas.com with ESMTP; 27 Jan 2023 10:48:16 +0900
Received: from localhost.localdomain (unknown [10.166.15.32])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id 81C3D415F68D;
        Fri, 27 Jan 2023 10:48:16 +0900 (JST)
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     linux@armlinux.org.uk, andrew@lunn.ch, hkallweit1@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Subject: [PATCH net-next v3 2/4] net: ethernet: renesas: rswitch: Simplify struct phy * handling
Date:   Fri, 27 Jan 2023 10:48:10 +0900
Message-Id: <20230127014812.1656340-3-yoshihiro.shimoda.uh@renesas.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230127014812.1656340-1-yoshihiro.shimoda.uh@renesas.com>
References: <20230127014812.1656340-1-yoshihiro.shimoda.uh@renesas.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simplify struct phy *serdes handling by keeping the valiable in
the struct rswitch_device.

Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
---
 drivers/net/ethernet/renesas/rswitch.c | 40 ++++++++++++--------------
 drivers/net/ethernet/renesas/rswitch.h |  1 +
 2 files changed, 19 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/renesas/rswitch.c b/drivers/net/ethernet/renesas/rswitch.c
index 14fc0af304ce..b0c1ea72772e 100644
--- a/drivers/net/ethernet/renesas/rswitch.c
+++ b/drivers/net/ethernet/renesas/rswitch.c
@@ -1222,49 +1222,40 @@ static void rswitch_phylink_deinit(struct rswitch_device *rdev)
 	phylink_destroy(rdev->phylink);
 }
 
-static int rswitch_serdes_set_params(struct rswitch_device *rdev)
+static int rswitch_serdes_phy_get(struct rswitch_device *rdev)
 {
 	struct device_node *port = rswitch_get_port_node(rdev);
 	struct phy *serdes;
-	int err;
 
 	serdes = devm_of_phy_get(&rdev->priv->pdev->dev, port, NULL);
 	of_node_put(port);
 	if (IS_ERR(serdes))
 		return PTR_ERR(serdes);
+	rdev->serdes = serdes;
+
+	return 0;
+}
+
+static int rswitch_serdes_set_params(struct rswitch_device *rdev)
+{
+	int err;
 
-	err = phy_set_mode_ext(serdes, PHY_MODE_ETHERNET,
+	err = phy_set_mode_ext(rdev->serdes, PHY_MODE_ETHERNET,
 			       rdev->etha->phy_interface);
 	if (err < 0)
 		return err;
 
-	return phy_set_speed(serdes, rdev->etha->speed);
+	return phy_set_speed(rdev->serdes, rdev->etha->speed);
 }
 
 static int rswitch_serdes_init(struct rswitch_device *rdev)
 {
-	struct device_node *port = rswitch_get_port_node(rdev);
-	struct phy *serdes;
-
-	serdes = devm_of_phy_get(&rdev->priv->pdev->dev, port, NULL);
-	of_node_put(port);
-	if (IS_ERR(serdes))
-		return PTR_ERR(serdes);
-
-	return phy_init(serdes);
+	return phy_init(rdev->serdes);
 }
 
 static int rswitch_serdes_deinit(struct rswitch_device *rdev)
 {
-	struct device_node *port = rswitch_get_port_node(rdev);
-	struct phy *serdes;
-
-	serdes = devm_of_phy_get(&rdev->priv->pdev->dev, port, NULL);
-	of_node_put(port);
-	if (IS_ERR(serdes))
-		return PTR_ERR(serdes);
-
-	return phy_exit(serdes);
+	return phy_exit(rdev->serdes);
 }
 
 static int rswitch_ether_port_init_one(struct rswitch_device *rdev)
@@ -1286,6 +1277,10 @@ static int rswitch_ether_port_init_one(struct rswitch_device *rdev)
 	if (err < 0)
 		goto err_phylink_init;
 
+	err = rswitch_serdes_phy_get(rdev);
+	if (err < 0)
+		goto err_serdes_phy_get;
+
 	err = rswitch_serdes_set_params(rdev);
 	if (err < 0)
 		goto err_serdes_set_params;
@@ -1293,6 +1288,7 @@ static int rswitch_ether_port_init_one(struct rswitch_device *rdev)
 	return 0;
 
 err_serdes_set_params:
+err_serdes_phy_get:
 	rswitch_phylink_deinit(rdev);
 
 err_phylink_init:
diff --git a/drivers/net/ethernet/renesas/rswitch.h b/drivers/net/ethernet/renesas/rswitch.h
index 49efb0f31c77..c79b1bdd8072 100644
--- a/drivers/net/ethernet/renesas/rswitch.h
+++ b/drivers/net/ethernet/renesas/rswitch.h
@@ -953,6 +953,7 @@ struct rswitch_device {
 
 	int port;
 	struct rswitch_etha *etha;
+	struct phy *serdes;
 };
 
 struct rswitch_mfwd_mac_table_entry {
-- 
2.25.1

