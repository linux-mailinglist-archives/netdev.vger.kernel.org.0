Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9F0020A3E2
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 19:19:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404559AbgFYRTe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 13:19:34 -0400
Received: from guitar.tcltek.co.il ([192.115.133.116]:56296 "EHLO
        mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404378AbgFYRTe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Jun 2020 13:19:34 -0400
Received: from tarshish.tkos.co.il (unknown [10.0.8.3])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx.tkos.co.il (Postfix) with ESMTPS id 22DEC4409BF;
        Thu, 25 Jun 2020 20:19:30 +0300 (IDT)
From:   Baruch Siach <baruch@tkos.co.il>
To:     Russell King <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Shmuel Hazan <sh@tkos.co.il>, Baruch Siach <baruch@tkos.co.il>
Subject: [PATCH] net: phy: marvell10g: support XFI rate matching mode
Date:   Thu, 25 Jun 2020 20:19:21 +0300
Message-Id: <79ca4ba3129a92e20943516b4af0dca510e938b3.1593105561.git.baruch@tkos.co.il>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the hardware MACTYPE hardware configuration pins are set to "XFI
with Rate Matching" the PHY interface operate at fixed 10Gbps speed. The
MAC buffer packets in both directions to match various wire speeds.

Read the MAC Type field in the Port Control register, and set the MAC
interface speed accordingly.

Signed-off-by: Baruch Siach <baruch@tkos.co.il>
---
 drivers/net/phy/marvell10g.c | 29 ++++++++++++++++++++++++++---
 1 file changed, 26 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/marvell10g.c b/drivers/net/phy/marvell10g.c
index d4c2e62b2439..0f157c338c55 100644
--- a/drivers/net/phy/marvell10g.c
+++ b/drivers/net/phy/marvell10g.c
@@ -80,6 +80,8 @@ enum {
 	MV_V2_PORT_CTRL		= 0xf001,
 	MV_V2_PORT_CTRL_SWRST	= BIT(15),
 	MV_V2_PORT_CTRL_PWRDOWN = BIT(11),
+	MV_V2_PORT_MAC_TYPE_MASK = 0x7,
+	MV_V2_PORT_MAC_TYPE_RATE_MATCH = 0x6,
 	/* Temperature control/read registers (88X3310 only) */
 	MV_V2_TEMP_CTRL		= 0xf08a,
 	MV_V2_TEMP_CTRL_MASK	= 0xc000,
@@ -579,8 +581,24 @@ static int mv3310_aneg_done(struct phy_device *phydev)
 	return genphy_c45_aneg_done(phydev);
 }
 
-static void mv3310_update_interface(struct phy_device *phydev)
+static int mv3310_update_interface(struct phy_device *phydev)
 {
+	int val;
+
+	val = phy_read_mmd(phydev, MDIO_MMD_VEND2, MV_V2_PORT_CTRL);
+	if (val < 0)
+		return val;
+
+	/* In "XFI with Rate Matching" mode the PHY interface is fixed at
+	 * 10Gb. The PHY adapts the rate to actual wire speed with help of
+	 * internal 16KB buffer.
+	 */
+	if ((val & MV_V2_PORT_MAC_TYPE_MASK) ==
+			MV_V2_PORT_MAC_TYPE_RATE_MATCH) {
+		phydev->interface = PHY_INTERFACE_MODE_10GBASER;
+		return 0;
+	}
+
 	if ((phydev->interface == PHY_INTERFACE_MODE_SGMII ||
 	     phydev->interface == PHY_INTERFACE_MODE_2500BASEX ||
 	     phydev->interface == PHY_INTERFACE_MODE_10GBASER) &&
@@ -607,6 +625,8 @@ static void mv3310_update_interface(struct phy_device *phydev)
 			break;
 		}
 	}
+
+	return 0;
 }
 
 /* 10GBASE-ER,LR,LRM,SR do not support autonegotiation. */
@@ -719,8 +739,11 @@ static int mv3310_read_status(struct phy_device *phydev)
 	if (err < 0)
 		return err;
 
-	if (phydev->link)
-		mv3310_update_interface(phydev);
+	if (phydev->link) {
+		err = mv3310_update_interface(phydev);
+		if (err < 0)
+			return err;
+	}
 
 	return 0;
 }
-- 
2.27.0

