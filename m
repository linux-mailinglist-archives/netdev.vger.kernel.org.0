Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F18A45EBD7
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 11:41:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376936AbhKZKou (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 05:44:50 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:11648 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236358AbhKZKmt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Nov 2021 05:42:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1637923177; x=1669459177;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=xpmhlSW7em7UtmFKOBx2CLVo53uxQhap/VGArGY8Pa4=;
  b=vTKRROhUVRlJRF258OLkWea3ARqOFeP2/ru6J/dIvPzfmZQTWCeoJw5b
   n92lbpHrd8tNjIi9/8UF5/eALX9UcZD/dvszGHccIPuVOAKlSidierXaY
   GZKxxL00aqHfIxrKvdLYD3S9fSGn+n3m3BFD30Uso4CpQHN5idiuveiSN
   +fgKbUn75jKCkxcNPt5c+4AUvOzpdMbkVXcoWc1P8O/QJArof7ZUZePt2
   vRp8xBrBEBRuyqGD2UspivWhbdDszLohRVafzRxvLqFRAY7JtwjHY7fIR
   qQ/b8uSlixG3xo8DVGzjPnaUXDETgMYCCK/97BT6Ywr8BfIgTvdjVud7A
   A==;
IronPort-SDR: bL+132sOLI9lgINdCORMFDLb6YAEVlBP+OMPuCHT7/JZMk4pG47jnl6W/hpbiK2qZglXWlTwzs
 r1vjJui+crD3+5a0mMU5ushlFCRPkitJXCq8kZbfkjMeABVBpJmyBwRRyIqTtVQTp4wUl3v3YN
 hmk4fPpgmYguJw06KxpGL+IgGF6r8E+jlJVIV8YZ/SLy3Ll7X2HyTjUyRQkuGcXD55X32+XS4U
 j4fsRQNbGLwveG90hd5HMSxh2iPFyFVSrL8LU6pyet82/3+BjecAwaC1qi0bSC+AVRkZauzHHJ
 0e2gt6xXzR5o1Jm/CaP9exEs
X-IronPort-AV: E=Sophos;i="5.87,265,1631602800"; 
   d="scan'208";a="77667991"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 26 Nov 2021 03:39:36 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Fri, 26 Nov 2021 03:39:36 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Fri, 26 Nov 2021 03:39:34 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next] net: phy: micrel: Add config_init for LAN8814
Date:   Fri, 26 Nov 2021 11:38:33 +0100
Message-ID: <20211126103833.3609945-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add config_init for LAN8814. This function is required for the following
reasons:
- we need to make sure that the PHY is reset,
- disable ANEG with QSGMII PCS Host side
- swap the MDI-X A,B transmit so that there will not be any link flip-flaps
  when the PHY gets a link.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 drivers/net/phy/micrel.c | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index 44a24b99c894..f080312032cf 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -1565,6 +1565,14 @@ static int ksz886x_cable_test_get_status(struct phy_device *phydev,
 #define LAN_EXT_PAGE_ACCESS_ADDRESS_DATA		0x17
 #define LAN_EXT_PAGE_ACCESS_CTRL_EP_FUNC		0x4000
 
+#define LAN8814_QSGMII_SOFT_RESET			0x43
+#define LAN8814_QSGMII_SOFT_RESET_BIT			BIT(0)
+#define LAN8814_QSGMII_PCS1G_ANEG_CONFIG		0x13
+#define LAN8814_QSGMII_PCS1G_ANEG_CONFIG_ANEG_ENA	BIT(3)
+#define LAN8814_ALIGN_SWAP				0x4a
+#define LAN8814_ALIGN_TX_A_B_SWAP			0x1
+#define LAN8814_ALIGN_TX_A_B_SWAP_MASK			GENMASK(2, 0)
+
 #define LAN8804_ALIGN_SWAP				0x4a
 #define LAN8804_ALIGN_TX_A_B_SWAP			0x1
 #define LAN8804_ALIGN_TX_A_B_SWAP_MASK			GENMASK(2, 0)
@@ -1601,6 +1609,29 @@ static int lanphy_write_page_reg(struct phy_device *phydev, int page, u16 addr,
 	return 0;
 }
 
+static int lan8814_config_init(struct phy_device *phydev)
+{
+	int val;
+
+	/* Reset the PHY */
+	val = lanphy_read_page_reg(phydev, 4, LAN8814_QSGMII_SOFT_RESET);
+	val |= LAN8814_QSGMII_SOFT_RESET_BIT;
+	lanphy_write_page_reg(phydev, 4, LAN8814_QSGMII_SOFT_RESET, val);
+
+	/* Disable ANEG with QSGMII PCS Host side */
+	val = lanphy_read_page_reg(phydev, 5, LAN8814_QSGMII_PCS1G_ANEG_CONFIG);
+	val &= ~LAN8814_QSGMII_PCS1G_ANEG_CONFIG_ANEG_ENA;
+	lanphy_write_page_reg(phydev, 5, LAN8814_QSGMII_PCS1G_ANEG_CONFIG, val);
+
+	/* MDI-X setting for swap A,B transmit */
+	val = lanphy_read_page_reg(phydev, 2, LAN8814_ALIGN_SWAP);
+	val &= ~LAN8814_ALIGN_TX_A_B_SWAP_MASK;
+	val |= LAN8814_ALIGN_TX_A_B_SWAP;
+	lanphy_write_page_reg(phydev, 2, LAN8814_ALIGN_SWAP, val);
+
+	return 0;
+}
+
 static int lan8804_config_init(struct phy_device *phydev)
 {
 	int val;
@@ -1793,6 +1824,7 @@ static struct phy_driver ksphy_driver[] = {
 	.phy_id		= PHY_ID_LAN8814,
 	.phy_id_mask	= MICREL_PHY_ID_MASK,
 	.name		= "Microchip INDY Gigabit Quad PHY",
+	.config_init	= lan8814_config_init,
 	.driver_data	= &ksz9021_type,
 	.probe		= kszphy_probe,
 	.soft_reset	= genphy_soft_reset,
-- 
2.33.0

