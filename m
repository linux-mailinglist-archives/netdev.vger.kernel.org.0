Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 017B34217D6
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 21:43:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233393AbhJDTpP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 15:45:15 -0400
Received: from perseus.uberspace.de ([95.143.172.134]:50694 "EHLO
        perseus.uberspace.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230507AbhJDTpO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Oct 2021 15:45:14 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Mon, 04 Oct 2021 15:45:14 EDT
Received: (qmail 8572 invoked from network); 4 Oct 2021 19:36:43 -0000
Received: from localhost (HELO localhost) (127.0.0.1)
  by perseus.uberspace.de with SMTP; 4 Oct 2021 19:36:43 -0000
From:   David Bauer <mail@david-bauer.net>
To:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Subject: [PATCH] net: phy: at803x: add QCA9561 support
Date:   Mon,  4 Oct 2021 21:36:33 +0200
Message-Id: <20211004193633.730203-1-mail@david-bauer.net>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for the embedded fast-ethernet PHY found on the QCA9561
WiSoC platform. It supports the usual Atheros PHY featureset including
the cable tester.

Tested on a Xiaomi MiRouter 4Q (QCA9561)

Signed-off-by: David Bauer <mail@david-bauer.net>
---
 drivers/net/phy/at803x.c | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
index bdac087058b2..e2ad0fcb901f 100644
--- a/drivers/net/phy/at803x.c
+++ b/drivers/net/phy/at803x.c
@@ -152,6 +152,7 @@
 
 #define QCA8327_PHY_ID				0x004dd034
 #define QCA8337_PHY_ID				0x004dd036
+#define QCA9561_PHY_ID				0x004dd042
 #define QCA8K_PHY_ID_MASK			0xffffffff
 
 #define QCA8K_DEVFLAGS_REVISION_MASK		GENMASK(2, 0)
@@ -1236,7 +1237,8 @@ static int at803x_cable_test_get_status(struct phy_device *phydev,
 	int pair, ret;
 
 	if (phydev->phy_id == ATH9331_PHY_ID ||
-	    phydev->phy_id == ATH8032_PHY_ID)
+	    phydev->phy_id == ATH8032_PHY_ID ||
+	    phydev->phy_id == QCA9561_PHY_ID)
 		pair_mask = 0x3;
 	else
 		pair_mask = 0xf;
@@ -1276,7 +1278,8 @@ static int at803x_cable_test_start(struct phy_device *phydev)
 	phy_write(phydev, MII_BMCR, BMCR_ANENABLE);
 	phy_write(phydev, MII_ADVERTISE, ADVERTISE_CSMA);
 	if (phydev->phy_id != ATH9331_PHY_ID &&
-	    phydev->phy_id != ATH8032_PHY_ID)
+	    phydev->phy_id != ATH8032_PHY_ID &&
+	    phydev->phy_id != QCA9561_PHY_ID)
 		phy_write(phydev, MII_CTRL1000, 0);
 
 	/* we do all the (time consuming) work later */
@@ -1407,6 +1410,21 @@ static struct phy_driver at803x_driver[] = {
 	.read_status		= at803x_read_status,
 	.soft_reset		= genphy_soft_reset,
 	.config_aneg		= at803x_config_aneg,
+}, {
+	/* Qualcomm Atheros QCA9561 */
+	PHY_ID_MATCH_EXACT(QCA9561_PHY_ID),
+	.name			= "Qualcomm Atheros QCA9561 built-in PHY",
+	.suspend		= at803x_suspend,
+	.resume			= at803x_resume,
+	.flags			= PHY_POLL_CABLE_TEST,
+	/* PHY_BASIC_FEATURES */
+	.config_intr		= &at803x_config_intr,
+	.handle_interrupt	= at803x_handle_interrupt,
+	.cable_test_start	= at803x_cable_test_start,
+	.cable_test_get_status	= at803x_cable_test_get_status,
+	.read_status		= at803x_read_status,
+	.soft_reset		= genphy_soft_reset,
+	.config_aneg		= at803x_config_aneg,
 }, {
 	/* QCA8337 */
 	.phy_id = QCA8337_PHY_ID,
@@ -1430,6 +1448,7 @@ static struct mdio_device_id __maybe_unused atheros_tbl[] = {
 	{ PHY_ID_MATCH_EXACT(ATH8032_PHY_ID) },
 	{ PHY_ID_MATCH_EXACT(ATH8035_PHY_ID) },
 	{ PHY_ID_MATCH_EXACT(ATH9331_PHY_ID) },
+	{ PHY_ID_MATCH_EXACT(QCA9561_PHY_ID) },
 	{ }
 };
 
-- 
2.33.0

