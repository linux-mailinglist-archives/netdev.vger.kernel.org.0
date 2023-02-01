Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDCDE686686
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 14:15:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232158AbjBANPi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 08:15:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232146AbjBANPd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 08:15:33 -0500
Received: from relmlie6.idc.renesas.com (relmlor2.renesas.com [210.160.252.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 44FB722A0E;
        Wed,  1 Feb 2023 05:15:32 -0800 (PST)
X-IronPort-AV: E=Sophos;i="5.97,263,1669042800"; 
   d="scan'208";a="151302377"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie6.idc.renesas.com with ESMTP; 01 Feb 2023 22:15:29 +0900
Received: from localhost.localdomain (unknown [10.166.15.32])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id 3E60A4005B57;
        Wed,  1 Feb 2023 22:15:29 +0900 (JST)
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Subject: [PATCH net-next v5 5/5] net: renesas: rswitch: Add "max-speed" handling
Date:   Wed,  1 Feb 2023 22:14:54 +0900
Message-Id: <20230201131454.1928136-6-yoshihiro.shimoda.uh@renesas.com>
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

The previous code set the speed by the interface mode of PHY.
Also this hardware has a restriction which cannot change the speed
at runtime. To use other speed, add "max-speed" handling to set
each port's speed if needed.

Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
---
 drivers/net/ethernet/renesas/rswitch.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/renesas/rswitch.c b/drivers/net/ethernet/renesas/rswitch.c
index f1a0dd1098f9..50b61a0a7f53 100644
--- a/drivers/net/ethernet/renesas/rswitch.c
+++ b/drivers/net/ethernet/renesas/rswitch.c
@@ -1072,13 +1072,23 @@ static struct device_node *rswitch_get_port_node(struct rswitch_device *rdev)
 
 static int rswitch_etha_get_params(struct rswitch_device *rdev)
 {
+	u32 max_speed;
 	int err;
 
 	if (!rdev->np_port)
 		return 0;	/* ignored */
 
 	err = of_get_phy_mode(rdev->np_port, &rdev->etha->phy_interface);
+	if (err)
+		return err;
+
+	err = of_property_read_u32(rdev->np_port, "max-speed", &max_speed);
+	if (!err) {
+		rdev->etha->speed = max_speed;
+		return 0;
+	}
 
+	/* if no "max-speed" property, let's use default speed */
 	switch (rdev->etha->phy_interface) {
 	case PHY_INTERFACE_MODE_MII:
 		rdev->etha->speed = SPEED_100;
@@ -1090,11 +1100,10 @@ static int rswitch_etha_get_params(struct rswitch_device *rdev)
 		rdev->etha->speed = SPEED_2500;
 		break;
 	default:
-		err = -EINVAL;
-		break;
+		return -EINVAL;
 	}
 
-	return err;
+	return 0;
 }
 
 static int rswitch_mii_register(struct rswitch_device *rdev)
-- 
2.25.1

