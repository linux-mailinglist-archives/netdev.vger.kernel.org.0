Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C11947E063
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 09:26:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243140AbhLWI0j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 03:26:39 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:36433 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242789AbhLWI0i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Dec 2021 03:26:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1640247998; x=1671783998;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=tsbbwV3m9R3lXLMuTG4CLaGu1mXzu3V+ZwyYbTmrtew=;
  b=SndVs4A4mpYuk81xadHWF/EnxVMOSkduaFbfNrMR0avyR8IOHms4mEIP
   GOYU3NviWSw4PNnZjBKeVlqjC5yPkAjPknHpXBsul8KeN7zRj7+FKaBau
   QdqowJPu/gSogZrQ4GIpTp1jb4fMPeUkKKqVHkOrow2lna86eOMrX5DE2
   HilG2flOfjw0VkCLpb+GpP9UaHpo+aDVUH+UuPky5Eswq42OSKTdIDaQk
   RIk5UagqtlNHX8Z9Bc5REWa3vVFOelcbhsX3DVF6RiBuRgZtt3PTppzYm
   LJG6ObhWOZsGMMdDD6VCudpuxtS5Mg3zubgBZVuU6PId7+R5yYTaNHZAa
   Q==;
IronPort-SDR: iSpOM5cQaVrBBzSlEvVPMN5PajQ1mbfU7ZeAgZdFJhFyp3yFQRJ3A03h8kTOcVXwXMKqEwc6kx
 ZmH3eUBA6CZeJSnRjcZ6xCE3WP/1fQWh3ud+GNCXgIf/T0Wa6SM9GbNud7i5Po/N+UsKYSWdbd
 Dh1kPdM4dOZSpIWfKO8R9eso4l2zg3ouUXEfnHynvwiy0zt82wCvQT7NEjtN8T18w1918BWC3U
 fjQVBJa8QnNwbCiKNVsWhMi2tQWUGHUc4TddUEw/4ol9KDKqlQxgXYf2h/Iup/tBAtmkiIzK4M
 SVr7yfaasxbQmxNEQlqL6LvR
X-IronPort-AV: E=Sophos;i="5.88,228,1635231600"; 
   d="scan'208";a="148153563"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 23 Dec 2021 01:26:38 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Thu, 23 Dec 2021 01:26:37 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Thu, 23 Dec 2021 01:26:36 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH resend net-next] net: phy: micrel: Add config_init for LAN8814
Date:   Thu, 23 Dec 2021 09:28:26 +0100
Message-ID: <20211223082826.1726649-1-horatiu.vultur@microchip.com>
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
This patch is resent because the proposed change request for using
read/write_page will not work for this device. Because lan8814 has a
more complicated mechanism to access extended pages.
---
 drivers/net/phy/micrel.c | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index c6a97fcca0e6..4570cb9535b7 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -1578,6 +1578,14 @@ static int ksz886x_cable_test_get_status(struct phy_device *phydev,
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
@@ -1614,6 +1622,29 @@ static int lanphy_write_page_reg(struct phy_device *phydev, int page, u16 addr,
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
@@ -1858,6 +1889,7 @@ static struct phy_driver ksphy_driver[] = {
 	.phy_id		= PHY_ID_LAN8814,
 	.phy_id_mask	= MICREL_PHY_ID_MASK,
 	.name		= "Microchip INDY Gigabit Quad PHY",
+	.config_init	= lan8814_config_init,
 	.driver_data	= &ksz9021_type,
 	.probe		= kszphy_probe,
 	.soft_reset	= genphy_soft_reset,
-- 
2.33.0

