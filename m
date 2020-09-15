Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E77B226ABAA
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 20:20:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727984AbgIOSUF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 14:20:05 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:43636 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727558AbgIOSRf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 14:17:35 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 08FIHPV5131045;
        Tue, 15 Sep 2020 13:17:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1600193845;
        bh=D7jGtexsmzXKUa9zd704sXBnYelR67+PhvttOHOuyjY=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=XwWgeeerhf/h/qLXsra21WQJ2g7A6nI3mkxMUIjhmEbccWYXDQ7fZRFU5eXKUFkCY
         eMfAb/crExUG8VaeDJQ5xAdKS4/eF83ZgCWlwySbF2PEAKaiJA/EEj5CK2UEzm93Fj
         v5bEaV2oQrTZzbLkz5zVaWBH+xGG4j1il6GUg54c=
Received: from DFLE115.ent.ti.com (dfle115.ent.ti.com [10.64.6.36])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id 08FIHPDR099973;
        Tue, 15 Sep 2020 13:17:25 -0500
Received: from DFLE110.ent.ti.com (10.64.6.31) by DFLE115.ent.ti.com
 (10.64.6.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Tue, 15
 Sep 2020 13:17:25 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE110.ent.ti.com
 (10.64.6.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Tue, 15 Sep 2020 13:17:25 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 08FIHOhN112715;
        Tue, 15 Sep 2020 13:17:25 -0500
From:   Dan Murphy <dmurphy@ti.com>
To:     <davem@davemloft.net>, <andrew@lunn.ch>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>
CC:     <mkubecek@suse.cz>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Dan Murphy <dmurphy@ti.com>
Subject: [PATCH net-next 2/3] net: dp83869: Add ability to advertise Fiber connection
Date:   Tue, 15 Sep 2020 13:17:07 -0500
Message-ID: <20200915181708.25842-3-dmurphy@ti.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200915181708.25842-1-dmurphy@ti.com>
References: <20200915181708.25842-1-dmurphy@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the ability to advertise the Fiber connection if the strap or the
op-mode is configured for 100Base-FX.

Auto negotiation is not supported on this PHY when in fiber mode.

Signed-off-by: Dan Murphy <dmurphy@ti.com>
---
 drivers/net/phy/dp83869.c | 73 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 73 insertions(+)

diff --git a/drivers/net/phy/dp83869.c b/drivers/net/phy/dp83869.c
index 6b98d74b5102..81899bc99add 100644
--- a/drivers/net/phy/dp83869.c
+++ b/drivers/net/phy/dp83869.c
@@ -52,6 +52,10 @@
 					 BMCR_FULLDPLX | \
 					 BMCR_SPEED1000)
 
+#define MII_DP83869_FIBER_ADVERTISE    (ADVERTISED_FIBRE | \
+					ADVERTISED_Pause | \
+					ADVERTISED_Asym_Pause)
+
 /* This is the same bit mask as the BMCR so re-use the BMCR default */
 #define DP83869_FX_CTRL_DEFAULT	MII_DP83869_BMCR_DEFAULT
 
@@ -118,6 +122,28 @@ struct dp83869_private {
 	int mode;
 };
 
+static int dp83869_read_status(struct phy_device *phydev)
+{
+	struct dp83869_private *dp83869 = phydev->priv;
+	int ret;
+
+	ret = genphy_read_status(phydev);
+	if (ret)
+		return ret;
+
+	if (linkmode_test_bit(ETHTOOL_LINK_MODE_FIBRE_BIT, phydev->supported)) {
+		if (phydev->link) {
+			if (dp83869->mode == DP83869_RGMII_100_BASE)
+				phydev->speed = SPEED_100;
+		} else {
+			phydev->speed = SPEED_UNKNOWN;
+			phydev->duplex = DUPLEX_UNKNOWN;
+		}
+	}
+
+	return 0;
+}
+
 static int dp83869_ack_interrupt(struct phy_device *phydev)
 {
 	int err = phy_read(phydev, MII_DP83869_ISR);
@@ -295,6 +321,51 @@ static int dp83869_configure_rgmii(struct phy_device *phydev,
 	return ret;
 }
 
+static int dp83869_configure_fiber(struct phy_device *phydev,
+				   struct dp83869_private *dp83869)
+{
+	int bmcr;
+	int ret;
+
+	/* Only allow advertising what this PHY supports */
+	linkmode_and(phydev->advertising, phydev->advertising,
+		     phydev->supported);
+
+	linkmode_set_bit(ETHTOOL_LINK_MODE_FIBRE_BIT, phydev->supported);
+	linkmode_set_bit(ADVERTISED_FIBRE, phydev->advertising);
+
+	if (dp83869->mode == DP83869_RGMII_1000_BASE) {
+		linkmode_set_bit(ETHTOOL_LINK_MODE_1000baseX_Full_BIT,
+				 phydev->supported);
+	} else {
+		linkmode_set_bit(ETHTOOL_LINK_MODE_100baseFX_Full_BIT,
+				 phydev->supported);
+		linkmode_set_bit(ETHTOOL_LINK_MODE_100baseFX_Half_BIT,
+				 phydev->supported);
+
+		/* Auto neg is not supported in 100base FX mode */
+		bmcr = phy_read(phydev, MII_BMCR);
+		if (bmcr < 0)
+			return bmcr;
+
+		phydev->autoneg = AUTONEG_DISABLE;
+		linkmode_clear_bit(ETHTOOL_LINK_MODE_Autoneg_BIT, phydev->supported);
+		linkmode_clear_bit(ETHTOOL_LINK_MODE_Autoneg_BIT, phydev->advertising);
+
+		if (bmcr & BMCR_ANENABLE) {
+			ret =  phy_modify(phydev, MII_BMCR, BMCR_ANENABLE, 0);
+			if (ret < 0)
+				return ret;
+		}
+	}
+
+	/* Update advertising from supported */
+	linkmode_or(phydev->advertising, phydev->advertising,
+		    phydev->supported);
+
+	return 0;
+}
+
 static int dp83869_configure_mode(struct phy_device *phydev,
 				  struct dp83869_private *dp83869)
 {
@@ -384,6 +455,7 @@ static int dp83869_configure_mode(struct phy_device *phydev,
 		break;
 	case DP83869_RGMII_1000_BASE:
 	case DP83869_RGMII_100_BASE:
+		ret = dp83869_configure_fiber(phydev, dp83869);
 		break;
 	default:
 		return -EINVAL;
@@ -494,6 +566,7 @@ static struct phy_driver dp83869_driver[] = {
 		/* IRQ related */
 		.ack_interrupt	= dp83869_ack_interrupt,
 		.config_intr	= dp83869_config_intr,
+		.read_status	= dp83869_read_status,
 
 		.suspend	= genphy_suspend,
 		.resume		= genphy_resume,
-- 
2.28.0

