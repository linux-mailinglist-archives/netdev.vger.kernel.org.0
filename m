Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1ABD25B55F
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 22:35:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727030AbgIBUfX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 16:35:23 -0400
Received: from lelv0143.ext.ti.com ([198.47.23.248]:45580 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726247AbgIBUfU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 16:35:20 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 082KZ0Vh108364;
        Wed, 2 Sep 2020 15:35:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1599078900;
        bh=pQ193KVAaE0ZacOrnJLgxUbHpFmanxf9WxzyXcsxib0=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=dXcBaLK0MKkU1w6hS8svE0+vSx7UGf3+Shoefa6FA8r8RMdk4MFGblAeltc3ehPeV
         eDPuoj7tdg3zJsaQ+KpzRpgx5Mw1VgDV0aibWEOUIh1dZt+z1OuDiytF3X+onCtBPk
         Lv2rvl/fK7QDEN5AGtVBWu7d9NSNx+NFee9MgFY0=
Received: from DFLE109.ent.ti.com (dfle109.ent.ti.com [10.64.6.30])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id 082KZ0Op112982;
        Wed, 2 Sep 2020 15:35:00 -0500
Received: from DFLE113.ent.ti.com (10.64.6.34) by DFLE109.ent.ti.com
 (10.64.6.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Wed, 2 Sep
 2020 15:35:00 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE113.ent.ti.com
 (10.64.6.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Wed, 2 Sep 2020 15:35:00 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 082KZ0tv092311;
        Wed, 2 Sep 2020 15:35:00 -0500
From:   Dan Murphy <dmurphy@ti.com>
To:     <davem@davemloft.net>, <andrew@lunn.ch>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Dan Murphy <dmurphy@ti.com>
Subject: [PATCH net-next v2 2/3] net: phy: dp83869: support Wake on LAN
Date:   Wed, 2 Sep 2020 15:34:43 -0500
Message-ID: <20200902203444.29167-3-dmurphy@ti.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200902203444.29167-1-dmurphy@ti.com>
References: <20200902203444.29167-1-dmurphy@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds WoL support on TI DP83869 for magic, magic secure, unicast and
broadcast.

Signed-off-by: Dan Murphy <dmurphy@ti.com>
---
 drivers/net/phy/dp83869.c | 128 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 128 insertions(+)

diff --git a/drivers/net/phy/dp83869.c b/drivers/net/phy/dp83869.c
index 48a68474f89c..5045df9515a5 100644
--- a/drivers/net/phy/dp83869.c
+++ b/drivers/net/phy/dp83869.c
@@ -4,6 +4,7 @@
  */
 
 #include <linux/ethtool.h>
+#include <linux/etherdevice.h>
 #include <linux/kernel.h>
 #include <linux/mii.h>
 #include <linux/module.h>
@@ -27,6 +28,13 @@
 #define DP83869_RGMIICTL	0x0032
 #define DP83869_STRAP_STS1	0x006e
 #define DP83869_RGMIIDCTL	0x0086
+#define DP83869_RXFCFG		0x0134
+#define DP83869_RXFPMD1		0x0136
+#define DP83869_RXFPMD2		0x0137
+#define DP83869_RXFPMD3		0x0138
+#define DP83869_RXFSOP1		0x0139
+#define DP83869_RXFSOP2		0x013A
+#define DP83869_RXFSOP3		0x013B
 #define DP83869_IO_MUX_CFG	0x0170
 #define DP83869_OP_MODE		0x01df
 #define DP83869_FX_CTRL		0x0c00
@@ -105,6 +113,14 @@
 #define DP83869_OP_MODE_MII			BIT(5)
 #define DP83869_SGMII_RGMII_BRIDGE		BIT(6)
 
+/* RXFCFG bits*/
+#define DP83869_WOL_MAGIC_EN		BIT(0)
+#define DP83869_WOL_PATTERN_EN		BIT(1)
+#define DP83869_WOL_BCAST_EN		BIT(2)
+#define DP83869_WOL_UCAST_EN		BIT(4)
+#define DP83869_WOL_SEC_EN		BIT(5)
+#define DP83869_WOL_ENH_MAC		BIT(7)
+
 enum {
 	DP83869_PORT_MIRRORING_KEEP,
 	DP83869_PORT_MIRRORING_EN,
@@ -156,6 +172,115 @@ static int dp83869_config_intr(struct phy_device *phydev)
 	return phy_write(phydev, MII_DP83869_MICR, micr_status);
 }
 
+static int dp83869_set_wol(struct phy_device *phydev,
+			   struct ethtool_wolinfo *wol)
+{
+	struct net_device *ndev = phydev->attached_dev;
+	u16 val_rxcfg, val_micr;
+	u8 *mac;
+
+	val_rxcfg = phy_read_mmd(phydev, DP83869_DEVADDR, DP83869_RXFCFG);
+	val_micr = phy_read(phydev, MII_DP83869_MICR);
+
+	if (wol->wolopts & (WAKE_MAGIC | WAKE_MAGICSECURE | WAKE_UCAST |
+			    WAKE_BCAST)) {
+		val_rxcfg |= DP83869_WOL_ENH_MAC;
+		val_micr |= MII_DP83869_MICR_WOL_INT_EN;
+
+		if (wol->wolopts & WAKE_MAGIC) {
+			mac = (u8 *)ndev->dev_addr;
+
+			if (!is_valid_ether_addr(mac))
+				return -EINVAL;
+
+			phy_write_mmd(phydev, DP83869_DEVADDR, DP83869_RXFPMD1,
+				      (mac[1] << 8 | mac[0]));
+			phy_write_mmd(phydev, DP83869_DEVADDR, DP83869_RXFPMD2,
+				      (mac[3] << 8 | mac[2]));
+			phy_write_mmd(phydev, DP83869_DEVADDR, DP83869_RXFPMD3,
+				      (mac[5] << 8 | mac[4]));
+
+			val_rxcfg |= DP83869_WOL_MAGIC_EN;
+		} else {
+			val_rxcfg &= ~DP83869_WOL_MAGIC_EN;
+		}
+
+		if (wol->wolopts & WAKE_MAGICSECURE) {
+			phy_write_mmd(phydev, DP83869_DEVADDR, DP83869_RXFSOP1,
+				      (wol->sopass[1] << 8) | wol->sopass[0]);
+			phy_write_mmd(phydev, DP83869_DEVADDR, DP83869_RXFSOP2,
+				      (wol->sopass[3] << 8) | wol->sopass[2]);
+			phy_write_mmd(phydev, DP83869_DEVADDR, DP83869_RXFSOP3,
+				      (wol->sopass[5] << 8) | wol->sopass[4]);
+
+			val_rxcfg |= DP83869_WOL_SEC_EN;
+		} else {
+			val_rxcfg &= ~DP83869_WOL_SEC_EN;
+		}
+
+		if (wol->wolopts & WAKE_UCAST)
+			val_rxcfg |= DP83869_WOL_UCAST_EN;
+		else
+			val_rxcfg &= ~DP83869_WOL_UCAST_EN;
+
+		if (wol->wolopts & WAKE_BCAST)
+			val_rxcfg |= DP83869_WOL_BCAST_EN;
+		else
+			val_rxcfg &= ~DP83869_WOL_BCAST_EN;
+	} else {
+		val_rxcfg &= ~DP83869_WOL_ENH_MAC;
+		val_micr &= ~MII_DP83869_MICR_WOL_INT_EN;
+	}
+
+	phy_write_mmd(phydev, DP83869_DEVADDR, DP83869_RXFCFG, val_rxcfg);
+	phy_write(phydev, MII_DP83869_MICR, val_micr);
+
+	return 0;
+}
+
+static void dp83869_get_wol(struct phy_device *phydev,
+			    struct ethtool_wolinfo *wol)
+{
+	u16 value, sopass_val;
+
+	wol->supported = (WAKE_UCAST | WAKE_BCAST | WAKE_MAGIC |
+			WAKE_MAGICSECURE);
+	wol->wolopts = 0;
+
+	value = phy_read_mmd(phydev, DP83869_DEVADDR, DP83869_RXFCFG);
+
+	if (value & DP83869_WOL_UCAST_EN)
+		wol->wolopts |= WAKE_UCAST;
+
+	if (value & DP83869_WOL_BCAST_EN)
+		wol->wolopts |= WAKE_BCAST;
+
+	if (value & DP83869_WOL_MAGIC_EN)
+		wol->wolopts |= WAKE_MAGIC;
+
+	if (value & DP83869_WOL_SEC_EN) {
+		sopass_val = phy_read_mmd(phydev, DP83869_DEVADDR,
+					  DP83869_RXFSOP1);
+		wol->sopass[0] = (sopass_val & 0xff);
+		wol->sopass[1] = (sopass_val >> 8);
+
+		sopass_val = phy_read_mmd(phydev, DP83869_DEVADDR,
+					  DP83869_RXFSOP2);
+		wol->sopass[2] = (sopass_val & 0xff);
+		wol->sopass[3] = (sopass_val >> 8);
+
+		sopass_val = phy_read_mmd(phydev, DP83869_DEVADDR,
+					  DP83869_RXFSOP3);
+		wol->sopass[4] = (sopass_val & 0xff);
+		wol->sopass[5] = (sopass_val >> 8);
+
+		wol->wolopts |= WAKE_MAGICSECURE;
+	}
+
+	if (!(value & DP83869_WOL_ENH_MAC))
+		wol->wolopts = 0;
+}
+
 static int dp83869_config_port_mirroring(struct phy_device *phydev)
 {
 	struct dp83869_private *dp83869 = phydev->priv;
@@ -531,6 +656,9 @@ static struct phy_driver dp83869_driver[] = {
 		.ack_interrupt	= dp83869_ack_interrupt,
 		.config_intr	= dp83869_config_intr,
 
+		.get_wol	= dp83869_get_wol,
+		.set_wol	= dp83869_set_wol,
+
 		.suspend	= genphy_suspend,
 		.resume		= genphy_resume,
 	},
-- 
2.28.0

