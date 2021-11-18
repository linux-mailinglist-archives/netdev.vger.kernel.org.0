Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFC7F455901
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 11:25:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244746AbhKRK2m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 05:28:42 -0500
Received: from fllv0016.ext.ti.com ([198.47.19.142]:60860 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240986AbhKRK2g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 05:28:36 -0500
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 1AIAPWXt062722;
        Thu, 18 Nov 2021 04:25:32 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1637231132;
        bh=0LM4weWLnzJC61TIaCHmJlRmAxvkDBc9iqgjdF4zfWo=;
        h=From:To:CC:Subject:Date;
        b=qe7BJ0/FAna+tZ0uImuYZs2L5MGCO35hLN/OYVdbl8zRy+i+ctwGvvsPmhHcebdDk
         lz4v5dR6Z/Q1c8E9neu+hyl6etRAbJapODgUstmW7J08WE96u+Z9pdgV+YjHJN91PK
         XJ5HUkZkNcPJLowNPailNHfv+zczkyCSXIssYBh0=
Received: from DFLE100.ent.ti.com (dfle100.ent.ti.com [10.64.6.21])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 1AIAPWkr086513
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 18 Nov 2021 04:25:32 -0600
Received: from DFLE104.ent.ti.com (10.64.6.25) by DFLE100.ent.ti.com
 (10.64.6.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Thu, 18
 Nov 2021 04:25:32 -0600
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE104.ent.ti.com
 (10.64.6.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14 via
 Frontend Transport; Thu, 18 Nov 2021 04:25:32 -0600
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 1AIAPWdY075787;
        Thu, 18 Nov 2021 04:25:32 -0600
From:   <hnagalla@ti.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <geet.modi@ti.com>, <vikram.sharma@ti.com>, <hnagalla@ti.com>,
        <kishon@ti.com>, <grygorii.strashko@ti.com>
Subject: [PATCH net-next v2] net: phy: add support for TI DP83561-SP phy
Date:   Thu, 18 Nov 2021 04:25:32 -0600
Message-ID: <20211118102532.9835-1-hnagalla@ti.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hari Nagalla <hnagalla@ti.com>

Add support for the TI DP83561-SP Gigabit ethernet phy device.

The dp83561-sp is a radiation hardened space grade gigabit ethernet
PHY. It has been tested for single event latch upto 121 MeV, the
critical reliability parameter for space designs. It interfaces directly to
twisted pair media through an external transformer. And the device also
interfaces directly to the MAC layer through Reduced GMII (RGMII) and MII.

DP83867, DP83869 and DP83561-SP, all these parts support 1000Base-T/
100Base-TX/ and 10Base-Te standards and have similar register map for
the core functionality.

The data sheet for this part is at https://www.ti.com/product/DP83561-SP

Signed-off-by: Hari Nagalla <hnagalla@ti.com>
Signed-off-by: Geet Modi <geet.modi@ti.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/phy/dp83869.c | 42 ++++++++++++++++++++-------------------
 1 file changed, 22 insertions(+), 20 deletions(-)

diff --git a/drivers/net/phy/dp83869.c b/drivers/net/phy/dp83869.c
index 7113925606f7..b4ff9c5073a3 100644
--- a/drivers/net/phy/dp83869.c
+++ b/drivers/net/phy/dp83869.c
@@ -16,6 +16,7 @@
 #include <dt-bindings/net/ti-dp83869.h>
 
 #define DP83869_PHY_ID		0x2000a0f1
+#define DP83561_PHY_ID		0x2000a1a4
 #define DP83869_DEVADDR		0x1f
 
 #define MII_DP83869_PHYCTRL	0x10
@@ -878,34 +879,35 @@ static int dp83869_phy_reset(struct phy_device *phydev)
 	return dp83869_config_init(phydev);
 }
 
-static struct phy_driver dp83869_driver[] = {
-	{
-		PHY_ID_MATCH_MODEL(DP83869_PHY_ID),
-		.name		= "TI DP83869",
-
-		.probe          = dp83869_probe,
-		.config_init	= dp83869_config_init,
-		.soft_reset	= dp83869_phy_reset,
-
-		/* IRQ related */
-		.config_intr	= dp83869_config_intr,
-		.handle_interrupt = dp83869_handle_interrupt,
-		.read_status	= dp83869_read_status,
 
-		.get_tunable	= dp83869_get_tunable,
-		.set_tunable	= dp83869_set_tunable,
+#define DP83869_PHY_DRIVER(_id, _name)				\
+{								\
+	PHY_ID_MATCH_MODEL(_id),				\
+	.name		= (_name),				\
+	.probe          = dp83869_probe,			\
+	.config_init	= dp83869_config_init,			\
+	.soft_reset	= dp83869_phy_reset,			\
+	.config_intr	= dp83869_config_intr,			\
+	.handle_interrupt = dp83869_handle_interrupt,		\
+	.read_status	= dp83869_read_status,			\
+	.get_tunable	= dp83869_get_tunable,			\
+	.set_tunable	= dp83869_set_tunable,			\
+	.get_wol	= dp83869_get_wol,			\
+	.set_wol	= dp83869_set_wol,			\
+	.suspend	= genphy_suspend,			\
+	.resume		= genphy_resume,			\
+}
 
-		.get_wol	= dp83869_get_wol,
-		.set_wol	= dp83869_set_wol,
+static struct phy_driver dp83869_driver[] = {
+	DP83869_PHY_DRIVER(DP83869_PHY_ID, "TI DP83869"),
+	DP83869_PHY_DRIVER(DP83561_PHY_ID, "TI DP83561-SP"),
 
-		.suspend	= genphy_suspend,
-		.resume		= genphy_resume,
-	},
 };
 module_phy_driver(dp83869_driver);
 
 static struct mdio_device_id __maybe_unused dp83869_tbl[] = {
 	{ PHY_ID_MATCH_MODEL(DP83869_PHY_ID) },
+	{ PHY_ID_MATCH_MODEL(DP83561_PHY_ID) },
 	{ }
 };
 MODULE_DEVICE_TABLE(mdio, dp83869_tbl);
-- 
2.17.1

