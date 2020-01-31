Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D32B814EF4A
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 16:14:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729136AbgAaPOi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 10:14:38 -0500
Received: from lelv0142.ext.ti.com ([198.47.23.249]:40128 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728941AbgAaPOg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jan 2020 10:14:36 -0500
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 00VFEUgT050952;
        Fri, 31 Jan 2020 09:14:30 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1580483670;
        bh=yg2sSIG6On/6b8axJNdbwxWrQCuSRBjvO2ZcRGpU8qE=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=AHTCOOW9iHtgukmcZRvod3d/5YMDZNwTV6As+1HO8qDXf93lr8CzO3Sc9ZowLQNSf
         4K195sFjwQP3Cep1FnZ7zqnBBHgCnIHcrKAl0JUJ/BEfyhPbKlOpQiH5v6mX9lKPTF
         JIbEDOQqkKE3DAQIwxeq1fzhSIKSuPFIxYnRsIrc=
Received: from DFLE115.ent.ti.com (dfle115.ent.ti.com [10.64.6.36])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 00VFEUlC086558
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 31 Jan 2020 09:14:30 -0600
Received: from DFLE113.ent.ti.com (10.64.6.34) by DFLE115.ent.ti.com
 (10.64.6.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Fri, 31
 Jan 2020 09:14:30 -0600
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE113.ent.ti.com
 (10.64.6.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Fri, 31 Jan 2020 09:14:30 -0600
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 00VFET0W031051;
        Fri, 31 Jan 2020 09:14:30 -0600
From:   Dan Murphy <dmurphy@ti.com>
To:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <hkallweit1@gmail.com>,
        <bunk@kernel.org>
CC:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <grygorii.strashko@ti.com>,
        Dan Murphy <dmurphy@ti.com>
Subject: [PATCH net-master 1/1] net: phy: dp83867: Add speed optimization feature
Date:   Fri, 31 Jan 2020 09:11:10 -0600
Message-ID: <20200131151110.31642-2-dmurphy@ti.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200131151110.31642-1-dmurphy@ti.com>
References: <20200131151110.31642-1-dmurphy@ti.com>
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
parameters in the PHYSTS register and not in the BMCR.  So we need to
over ride the genphy_read_status with a DP83867 specific read status.

Signed-off-by: Dan Murphy <dmurphy@ti.com>
---
 drivers/net/phy/dp83867.c | 48 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

diff --git a/drivers/net/phy/dp83867.c b/drivers/net/phy/dp83867.c
index 967f57ed0b65..695aaf4f942f 100644
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
@@ -287,6 +297,36 @@ static int dp83867_config_intr(struct phy_device *phydev)
 	return phy_write(phydev, MII_DP83867_MICR, micr_status);
 }
 
+static int dp83867_read_status(struct phy_device *phydev)
+{
+	int status = phy_read(phydev, MII_DP83867_PHYSTS);
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
+	if (status & DP83867_PHYSTS_LINK)
+		phydev->link = 1;
+	else
+		phydev->link = 0;
+
+	phydev->pause = 0;
+	phydev->asym_pause = 0;
+
+	return 0;
+}
+
 static int dp83867_config_port_mirroring(struct phy_device *phydev)
 {
 	struct dp83867_private *dp83867 =
@@ -467,6 +507,12 @@ static int dp83867_config_init(struct phy_device *phydev)
 	int ret, val, bs;
 	u16 delay;
 
+	/* Force speed optimization for the PHY even if it strapped */
+	ret = phy_modify(phydev, DP83867_CFG2, DP83867_SPEED_OPTIMIZED_EN,
+			 DP83867_SPEED_OPTIMIZED_EN);
+	if (ret)
+		return ret;
+
 	ret = dp83867_verify_rgmii_cfg(phydev);
 	if (ret)
 		return ret;
@@ -655,6 +701,8 @@ static struct phy_driver dp83867_driver[] = {
 		.config_init	= dp83867_config_init,
 		.soft_reset	= dp83867_phy_reset,
 
+		.read_status	= dp83867_read_status,
+
 		.get_wol	= dp83867_get_wol,
 		.set_wol	= dp83867_set_wol,
 
-- 
2.25.0

