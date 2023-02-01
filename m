Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5266686685
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 14:15:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232157AbjBANPh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 08:15:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232141AbjBANPd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 08:15:33 -0500
Received: from relmlie6.idc.renesas.com (relmlor2.renesas.com [210.160.252.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D824E3400A;
        Wed,  1 Feb 2023 05:15:31 -0800 (PST)
X-IronPort-AV: E=Sophos;i="5.97,263,1669042800"; 
   d="scan'208";a="151302374"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie6.idc.renesas.com with ESMTP; 01 Feb 2023 22:15:29 +0900
Received: from localhost.localdomain (unknown [10.166.15.32])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id 0E7224005B57;
        Wed,  1 Feb 2023 22:15:29 +0900 (JST)
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Subject: [PATCH net-next v5 3/5] net: renesas: rswitch: Add host_interfaces setting
Date:   Wed,  1 Feb 2023 22:14:52 +0900
Message-Id: <20230201131454.1928136-4-yoshihiro.shimoda.uh@renesas.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230201131454.1928136-1-yoshihiro.shimoda.uh@renesas.com>
References: <20230201131454.1928136-1-yoshihiro.shimoda.uh@renesas.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Set phydev->host_interfaces before calling of_phy_connect() to
configure the PHY with the information of host_interfaces.

Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
---
 drivers/net/ethernet/renesas/rswitch.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/renesas/rswitch.c b/drivers/net/ethernet/renesas/rswitch.c
index 479499f9fcb5..f8b3a81c0447 100644
--- a/drivers/net/ethernet/renesas/rswitch.c
+++ b/drivers/net/ethernet/renesas/rswitch.c
@@ -1178,6 +1178,7 @@ static int rswitch_phy_device_init(struct rswitch_device *rdev)
 {
 	struct phy_device *phydev;
 	struct device_node *phy;
+	int err = -ENOENT;
 
 	if (!rdev->np_port)
 		return -ENODEV;
@@ -1186,11 +1187,18 @@ static int rswitch_phy_device_init(struct rswitch_device *rdev)
 	if (!phy)
 		return -ENODEV;
 
+	/* Set phydev->host_interfaces before calling of_phy_connect() to
+	 * configure the PHY with the information of host_interfaces.
+	 */
+	phydev = of_phy_find_device(phy);
+	if (!phydev)
+		goto out;
+	__set_bit(rdev->etha->phy_interface, phydev->host_interfaces);
+
 	phydev = of_phy_connect(rdev->ndev, phy, rswitch_adjust_link, 0,
 				rdev->etha->phy_interface);
-	of_node_put(phy);
 	if (!phydev)
-		return -ENOENT;
+		goto out;
 
 	phy_set_max_speed(phydev, SPEED_2500);
 	phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_10baseT_Half_BIT);
@@ -1201,7 +1209,11 @@ static int rswitch_phy_device_init(struct rswitch_device *rdev)
 
 	phy_attached_info(phydev);
 
-	return 0;
+	err = 0;
+out:
+	of_node_put(phy);
+
+	return err;
 }
 
 static void rswitch_phy_device_deinit(struct rswitch_device *rdev)
-- 
2.25.1

