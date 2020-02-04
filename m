Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5008715204C
	for <lists+netdev@lfdr.de>; Tue,  4 Feb 2020 19:18:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727466AbgBDSSB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Feb 2020 13:18:01 -0500
Received: from lelv0142.ext.ti.com ([198.47.23.249]:58688 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727382AbgBDSSA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Feb 2020 13:18:00 -0500
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 014IHk3A128570;
        Tue, 4 Feb 2020 12:17:46 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1580840266;
        bh=lncBlGeTdqobitkZGOg+x6QMsqVd0LjGX8n1Fygx6xU=;
        h=From:To:CC:Subject:Date;
        b=Xy414p9SN4nH2VJrxYhIXDVfYoOBJ7HSfNPY6A22G8tbmRZccLlXNa090QCRN2yjn
         4yc4YVd42u8AmkrsOVrOjrIah9TXcnqJIkmUUbaLeCMnwyJpt604GjdKAxjXY3JB/P
         8ofQYRT+4mwnEqt0B6w60By3A5FkWqFads23tXzU=
Received: from DLEE108.ent.ti.com (dlee108.ent.ti.com [157.170.170.38])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 014IHk0t057653
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 4 Feb 2020 12:17:46 -0600
Received: from DLEE107.ent.ti.com (157.170.170.37) by DLEE108.ent.ti.com
 (157.170.170.38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Tue, 4 Feb
 2020 12:17:45 -0600
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE107.ent.ti.com
 (157.170.170.37) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Tue, 4 Feb 2020 12:17:45 -0600
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 014IHjGV052884;
        Tue, 4 Feb 2020 12:17:45 -0600
From:   Dan Murphy <dmurphy@ti.com>
To:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <hkallweit1@gmail.com>
CC:     <linux@armlinux.org.uk>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Dan Murphy <dmurphy@ti.com>
Subject: [PATCH net-next v2] net: phy: dp83867: Add speed optimization feature
Date:   Tue, 4 Feb 2020 12:13:19 -0600
Message-ID: <20200204181319.27381-1-dmurphy@ti.com>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Set the speed optimization bit on the DP83867 PHY.
This feature can also be strapped on the 64 pin PHY devices
but the 48 pin devices do not have the strap pin available to enable
this feature in the hardware.  PHY team suggests to have this bit set.

With this bit set the PHY will auto negotiate and report the link
parameters in the PHYSTS register.  This register provides a single
location within the register set for quick access to commonly accessed
information.

In this case when auto negotiation is on the PHY core reads the bits
that have been configured or if auto negotiation is off the PHY core
reads the BMCR register and sets the phydev parameters accordingly.

This Giga bit PHY can throttle the speed to 100Mbps or 10Mbps to accomodate a
4-wire cable.  If this should occur the PHYSTS register contains the
current negotiated speed and duplex mode.

In overriding the genphy_read_status the dp83867_read_status will do a
genphy_read_status to setup the LP and pause bits.  And then the PHYSTS
register is read and the phydev speed and duplex mode settings are
updated.

Signed-off-by: Dan Murphy <dmurphy@ti.com>
---
v2 - Updated read status to call genphy_read_status first, added link_change
callback to notify of speed change and use phy_set_bits - https://lore.kernel.org/patchwork/patch/1188348/ 

 drivers/net/phy/dp83867.c | 55 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 55 insertions(+)

diff --git a/drivers/net/phy/dp83867.c b/drivers/net/phy/dp83867.c
index 967f57ed0b65..6f86ca1ebb51 100644
--- a/drivers/net/phy/dp83867.c
+++ b/drivers/net/phy/dp83867.c
@@ -21,6 +21,7 @@
 #define DP83867_DEVADDR		0x1f
 
 #define MII_DP83867_PHYCTRL	0x10
+#define MII_DP83867_PHYSTS	0x11
 #define MII_DP83867_MICR	0x12
 #define MII_DP83867_ISR		0x13
 #define DP83867_CFG2		0x14
@@ -118,6 +119,15 @@
 #define DP83867_IO_MUX_CFG_CLK_O_SEL_MASK	(0x1f << 8)
 #define DP83867_IO_MUX_CFG_CLK_O_SEL_SHIFT	8
 
+/* PHY STS bits */
+#define DP83867_PHYSTS_1000			BIT(15)
+#define DP83867_PHYSTS_100			BIT(14)
+#define DP83867_PHYSTS_DUPLEX			BIT(13)
+#define DP83867_PHYSTS_LINK			BIT(10)
+
+/* CFG2 bits */
+#define DP83867_SPEED_OPTIMIZED_EN		(BIT(8) | BIT(9))
+
 /* CFG3 bits */
 #define DP83867_CFG3_INT_OE			BIT(7)
 #define DP83867_CFG3_ROBUST_AUTO_MDIX		BIT(9)
@@ -287,6 +297,43 @@ static int dp83867_config_intr(struct phy_device *phydev)
 	return phy_write(phydev, MII_DP83867_MICR, micr_status);
 }
 
+static void dp83867_link_change_notify(struct phy_device *phydev)
+{
+	if (phydev->state != PHY_RUNNING)
+		return;
+
+	if (phydev->speed == SPEED_100 || phydev->speed == SPEED_10)
+		phydev_warn(phydev, "Downshift detected connection is %iMbps\n",
+			    phydev->speed);
+}
+
+static int dp83867_read_status(struct phy_device *phydev)
+{
+	int status = phy_read(phydev, MII_DP83867_PHYSTS);
+	int ret;
+
+	ret = genphy_read_status(phydev);
+	if (ret)
+		return ret;
+
+	if (status < 0)
+		return status;
+
+	if (status & DP83867_PHYSTS_DUPLEX)
+		phydev->duplex = DUPLEX_FULL;
+	else
+		phydev->duplex = DUPLEX_HALF;
+
+	if (status & DP83867_PHYSTS_1000)
+		phydev->speed = SPEED_1000;
+	else if (status & DP83867_PHYSTS_100)
+		phydev->speed = SPEED_100;
+	else
+		phydev->speed = SPEED_10;
+
+	return 0;
+}
+
 static int dp83867_config_port_mirroring(struct phy_device *phydev)
 {
 	struct dp83867_private *dp83867 =
@@ -467,6 +514,11 @@ static int dp83867_config_init(struct phy_device *phydev)
 	int ret, val, bs;
 	u16 delay;
 
+	/* Force speed optimization for the PHY even if it strapped */
+	ret = phy_set_bits(phydev, DP83867_CFG2, DP83867_SPEED_OPTIMIZED_EN);
+	if (ret)
+		return ret;
+
 	ret = dp83867_verify_rgmii_cfg(phydev);
 	if (ret)
 		return ret;
@@ -655,6 +707,9 @@ static struct phy_driver dp83867_driver[] = {
 		.config_init	= dp83867_config_init,
 		.soft_reset	= dp83867_phy_reset,
 
+		.read_status	= dp83867_read_status,
+		.link_change_notify = dp83867_link_change_notify,
+
 		.get_wol	= dp83867_get_wol,
 		.set_wol	= dp83867_set_wol,
 
-- 
2.25.0

