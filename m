Return-Path: <netdev+bounces-12221-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CB64E736C69
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 14:55:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 08FFD1C20B45
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 12:55:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1888154A3;
	Tue, 20 Jun 2023 12:55:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5B4614AB0
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 12:55:28 +0000 (UTC)
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B1B610FF
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 05:55:27 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
	by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <ore@pengutronix.de>)
	id 1qBat4-0005HR-Bi; Tue, 20 Jun 2023 14:55:10 +0200
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
	by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
	(envelope-from <ore@pengutronix.de>)
	id 1qBat2-008nEH-SB; Tue, 20 Jun 2023 14:55:08 +0200
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
	(envelope-from <ore@pengutronix.de>)
	id 1qBat2-00A50M-7A; Tue, 20 Jun 2023 14:55:08 +0200
From: Oleksij Rempel <o.rempel@pengutronix.de>
To: Andrew Lunn <andrew@lunn.ch>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Cc: Oleksij Rempel <o.rempel@pengutronix.de>,
	kernel@pengutronix.de,
	linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [PATCH v1 1/1] net: phy: dp83td510: fix kernel stall during netboot in DP83TD510E PHY driver
Date: Tue, 20 Jun 2023 14:55:05 +0200
Message-Id: <20230620125505.2402497-1-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Fix an issue where the kernel would stall during netboot, showing the
"sched: RT throttling activated" message. This stall was triggered by
the behavior of the mii_interrupt bit (Bit 7 - DP83TD510E_STS_MII_INT)
in the DP83TD510E's PHY_STS Register (Address = 0x10). The DP83TD510E
datasheet (2020) states that the bit clears on write, however, in
practice, the bit clears on read.

This discrepancy had significant implications on the driver's interrupt
handling. The PHY_STS Register was used by handle_interrupt() to check
for pending interrupts and by read_status() to get the current link
status. The call to read_status() was unintentionally clearing the
mii_interrupt status bit without deasserting the IRQ pin, causing
handle_interrupt() to miss other pending interrupts. This issue was most
apparent during netboot.

The fix refrains from using the PHY_STS Register for interrupt handling.
Instead, we now solely rely on the INTERRUPT_REG_1 Register (Address =
0x12) and INTERRUPT_REG_2 Register (Address = 0x13) for this purpose.
These registers directly influence the IRQ pin state and are latched
high until read.

Note: The INTERRUPT_REG_2 Register (Address = 0x13) exists and can also
be used for interrupt handling, specifically for "Aneg page received
interrupt" and "Polarity change interrupt". However, these features are
currently not supported by this driver.

Fixes: 165cd04fe253 ("net: phy: dp83td510: Add support for the DP83TD510 Ethernet PHY")
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/phy/dp83td510.c | 23 +++++------------------
 1 file changed, 5 insertions(+), 18 deletions(-)

diff --git a/drivers/net/phy/dp83td510.c b/drivers/net/phy/dp83td510.c
index 3cd9a77f9532..d7616b13c594 100644
--- a/drivers/net/phy/dp83td510.c
+++ b/drivers/net/phy/dp83td510.c
@@ -12,6 +12,11 @@
 
 /* MDIO_MMD_VEND2 registers */
 #define DP83TD510E_PHY_STS			0x10
+/* Bit 7 - mii_interrupt, active high. Clears on read.
+ * Note: Clearing does not necessarily deactivate IRQ pin if interrupts pending.
+ * This differs from the DP83TD510E datasheet (2020) which states this bit
+ * clears on write 0.
+ */
 #define DP83TD510E_STS_MII_INT			BIT(7)
 #define DP83TD510E_LINK_STATUS			BIT(0)
 
@@ -53,12 +58,6 @@ static int dp83td510_config_intr(struct phy_device *phydev)
 	int ret;
 
 	if (phydev->interrupts == PHY_INTERRUPT_ENABLED) {
-		/* Clear any pending interrupts */
-		ret = phy_write_mmd(phydev, MDIO_MMD_VEND2, DP83TD510E_PHY_STS,
-				    0x0);
-		if (ret)
-			return ret;
-
 		ret = phy_write_mmd(phydev, MDIO_MMD_VEND2,
 				    DP83TD510E_INTERRUPT_REG_1,
 				    DP83TD510E_INT1_LINK_EN);
@@ -81,10 +80,6 @@ static int dp83td510_config_intr(struct phy_device *phydev)
 					 DP83TD510E_GENCFG_INT_EN);
 		if (ret)
 			return ret;
-
-		/* Clear any pending interrupts */
-		ret = phy_write_mmd(phydev, MDIO_MMD_VEND2, DP83TD510E_PHY_STS,
-				    0x0);
 	}
 
 	return ret;
@@ -94,14 +89,6 @@ static irqreturn_t dp83td510_handle_interrupt(struct phy_device *phydev)
 {
 	int  ret;
 
-	ret = phy_read_mmd(phydev, MDIO_MMD_VEND2, DP83TD510E_PHY_STS);
-	if (ret < 0) {
-		phy_error(phydev);
-		return IRQ_NONE;
-	} else if (!(ret & DP83TD510E_STS_MII_INT)) {
-		return IRQ_NONE;
-	}
-
 	/* Read the current enabled interrupts */
 	ret = phy_read_mmd(phydev, MDIO_MMD_VEND2, DP83TD510E_INTERRUPT_REG_1);
 	if (ret < 0) {
-- 
2.39.2


