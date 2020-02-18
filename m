Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A4A11627E6
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 15:16:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726719AbgBROQW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 09:16:22 -0500
Received: from fllv0016.ext.ti.com ([198.47.19.142]:48456 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726422AbgBROQW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 09:16:22 -0500
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 01IEGEsE074273;
        Tue, 18 Feb 2020 08:16:14 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1582035374;
        bh=n2KrMiBAVRvNdjvVSSSf2VgxPh00qjT1MxIsx1Js1bc=;
        h=From:To:CC:Subject:Date;
        b=C2X155UeR3DePPy2KyaY05jG+tv6Is1x6lU0t+7bN0kz5Jv8h+7L728qp3zd7co2Q
         bX6tCUoDYqCoZnQ6rXRAO8e1YdeVS72qbsMl1f1myn9PsYpvdMDkwDW9wRVRcxOxES
         34jks0T40/qeLocpvAIzkTalfZegurFcSbSTjI/4=
Received: from DFLE113.ent.ti.com (dfle113.ent.ti.com [10.64.6.34])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 01IEGEgY020868
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 18 Feb 2020 08:16:14 -0600
Received: from DFLE110.ent.ti.com (10.64.6.31) by DFLE113.ent.ti.com
 (10.64.6.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Tue, 18
 Feb 2020 08:16:13 -0600
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE110.ent.ti.com
 (10.64.6.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Tue, 18 Feb 2020 08:16:13 -0600
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 01IEGDMk085215;
        Tue, 18 Feb 2020 08:16:13 -0600
From:   Dan Murphy <dmurphy@ti.com>
To:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <hkallweit1@gmail.com>
CC:     <linux@armlinux.org.uk>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Dan Murphy <dmurphy@ti.com>
Subject: [PATCH net-next v3] net: phy: dp83867: Add speed optimization feature
Date:   Tue, 18 Feb 2020 08:11:30 -0600
Message-ID: <20200218141130.28825-1-dmurphy@ti.com>
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

v3 - Add the tunable feature into the driver for downshift.  Change speed optimization
nomenclature to dwonshift

 drivers/net/phy/dp83867.c | 150 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 150 insertions(+)

diff --git a/drivers/net/phy/dp83867.c b/drivers/net/phy/dp83867.c
index 967f57ed0b65..13f7f2d5a2ea 100644
--- a/drivers/net/phy/dp83867.c
+++ b/drivers/net/phy/dp83867.c
@@ -14,6 +14,7 @@
 #include <linux/delay.h>
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
+#include <linux/bitfield.h>
 
 #include <dt-bindings/net/ti-dp83867.h>
 
@@ -21,6 +22,7 @@
 #define DP83867_DEVADDR		0x1f
 
 #define MII_DP83867_PHYCTRL	0x10
+#define MII_DP83867_PHYSTS	0x11
 #define MII_DP83867_MICR	0x12
 #define MII_DP83867_ISR		0x13
 #define DP83867_CFG2		0x14
@@ -118,6 +120,24 @@
 #define DP83867_IO_MUX_CFG_CLK_O_SEL_MASK	(0x1f << 8)
 #define DP83867_IO_MUX_CFG_CLK_O_SEL_SHIFT	8
 
+/* PHY STS bits */
+#define DP83867_PHYSTS_1000			BIT(15)
+#define DP83867_PHYSTS_100			BIT(14)
+#define DP83867_PHYSTS_DUPLEX			BIT(13)
+#define DP83867_PHYSTS_LINK			BIT(10)
+
+/* CFG2 bits */
+#define DP83867_DOWNSHIFT_EN		(BIT(8) | BIT(9))
+#define DP83867_DOWNSHIFT_ATTEMPT_MASK	(BIT(10) | BIT(11))
+#define DP83867_DOWNSHIFT_1_COUNT_VAL	0
+#define DP83867_DOWNSHIFT_2_COUNT_VAL	1
+#define DP83867_DOWNSHIFT_4_COUNT_VAL	2
+#define DP83867_DOWNSHIFT_8_COUNT_VAL	3
+#define DP83867_DOWNSHIFT_1_COUNT	1
+#define DP83867_DOWNSHIFT_2_COUNT	2
+#define DP83867_DOWNSHIFT_4_COUNT	4
+#define DP83867_DOWNSHIFT_8_COUNT	8
+
 /* CFG3 bits */
 #define DP83867_CFG3_INT_OE			BIT(7)
 #define DP83867_CFG3_ROBUST_AUTO_MDIX		BIT(9)
@@ -287,6 +307,126 @@ static int dp83867_config_intr(struct phy_device *phydev)
 	return phy_write(phydev, MII_DP83867_MICR, micr_status);
 }
 
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
+static int dp83867_get_downshift(struct phy_device *phydev, u8 *data)
+{
+	int val, cnt, enable, count;
+
+	val = phy_read(phydev, DP83867_CFG2);
+	if (val < 0)
+		return val;
+
+	enable = FIELD_GET(DP83867_DOWNSHIFT_EN, val);
+	cnt = FIELD_GET(DP83867_DOWNSHIFT_ATTEMPT_MASK, val);
+
+	switch (cnt) {
+	case DP83867_DOWNSHIFT_1_COUNT_VAL:
+		count = DP83867_DOWNSHIFT_1_COUNT;
+		break;
+	case DP83867_DOWNSHIFT_2_COUNT_VAL:
+		count = DP83867_DOWNSHIFT_2_COUNT;
+		break;
+	case DP83867_DOWNSHIFT_4_COUNT_VAL:
+		count = DP83867_DOWNSHIFT_4_COUNT;
+		break;
+	case DP83867_DOWNSHIFT_8_COUNT_VAL:
+		count = DP83867_DOWNSHIFT_8_COUNT;
+		break;
+	default:
+		return -EINVAL;
+	};
+
+	*data = enable ? count : DOWNSHIFT_DEV_DISABLE;
+
+	return 0;
+}
+
+static int dp83867_set_downshift(struct phy_device *phydev, u8 cnt)
+{
+	int val, count;
+
+	if (cnt > DP83867_DOWNSHIFT_8_COUNT)
+		return -E2BIG;
+
+	if (!cnt)
+		return phy_clear_bits(phydev, DP83867_CFG2,
+				      DP83867_DOWNSHIFT_EN);
+
+	switch (cnt) {
+		case DP83867_DOWNSHIFT_1_COUNT:
+			count = DP83867_DOWNSHIFT_1_COUNT_VAL;
+			break;
+		case DP83867_DOWNSHIFT_2_COUNT:
+			count = DP83867_DOWNSHIFT_2_COUNT_VAL;
+			break;
+		case DP83867_DOWNSHIFT_4_COUNT:
+			count = DP83867_DOWNSHIFT_4_COUNT_VAL;
+			break;
+		case DP83867_DOWNSHIFT_8_COUNT:
+			count = DP83867_DOWNSHIFT_8_COUNT_VAL;
+			break;
+		default:
+			phydev_err(phydev,
+				   "Downshift count must be 1, 2, 4 or 8\n");
+			return -EINVAL;
+	};
+
+	val = DP83867_DOWNSHIFT_EN;
+	val |= FIELD_PREP(DP83867_DOWNSHIFT_ATTEMPT_MASK, count);
+
+	return phy_modify(phydev, DP83867_CFG2,
+			  DP83867_DOWNSHIFT_EN | DP83867_DOWNSHIFT_ATTEMPT_MASK,
+			  val);
+}
+
+static int dp83867_get_tunable(struct phy_device *phydev,
+				struct ethtool_tunable *tuna, void *data)
+{
+	switch (tuna->id) {
+	case ETHTOOL_PHY_DOWNSHIFT:
+		return dp83867_get_downshift(phydev, data);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+static int dp83867_set_tunable(struct phy_device *phydev,
+				struct ethtool_tunable *tuna, const void *data)
+{
+	switch (tuna->id) {
+	case ETHTOOL_PHY_DOWNSHIFT:
+		return dp83867_set_downshift(phydev, *(const u8 *)data);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
 static int dp83867_config_port_mirroring(struct phy_device *phydev)
 {
 	struct dp83867_private *dp83867 =
@@ -467,6 +607,12 @@ static int dp83867_config_init(struct phy_device *phydev)
 	int ret, val, bs;
 	u16 delay;
 
+	/* Force speed optimization for the PHY even if it strapped */
+	ret = phy_modify(phydev, DP83867_CFG2, DP83867_DOWNSHIFT_EN,
+			 DP83867_DOWNSHIFT_EN);
+	if (ret)
+		return ret;
+
 	ret = dp83867_verify_rgmii_cfg(phydev);
 	if (ret)
 		return ret;
@@ -655,6 +801,10 @@ static struct phy_driver dp83867_driver[] = {
 		.config_init	= dp83867_config_init,
 		.soft_reset	= dp83867_phy_reset,
 
+		.read_status	= dp83867_read_status,
+		.get_tunable	= dp83867_get_tunable,
+		.set_tunable	= dp83867_set_tunable,
+
 		.get_wol	= dp83867_get_wol,
 		.set_wol	= dp83867_set_wol,
 
-- 
2.25.0

