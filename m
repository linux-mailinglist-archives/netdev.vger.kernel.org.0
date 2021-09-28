Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75AE141B678
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 20:44:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242143AbhI1SqT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 14:46:19 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:35632 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230139AbhI1SqS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Sep 2021 14:46:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1632854678; x=1664390678;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=sj6nrYhkolrOGjdmUUjNtxWcbOgvb6ELz5PzwIFm0ZA=;
  b=IXi0LSF8zIH14xb+CE7lNi8U03BdQQ1BobTk+4YsQcA/Nazuv6haKgV6
   2GR31SGhw+WJw2Eur0Huwhi79ILoP7v3xQLF5h/IvOI3EybS3xAhOvCMe
   PCSMNEagHfW8MHGLF+X1WkidgY997rea5LCO/Z5S9itJwZyU6taoV4fAE
   WE3yCL8rxA6A+Nx0pfbWP178ZmGs4/tzzMa6axe65f/+ycfb8XYPU+TCp
   ZFw11z63Wn8Vw/tfqwZx8YPFi1Ti7qgpbar4wNcvrKDMzi6FOxC/d+4kW
   VMpg9ZX5e5mshHbUl6ZR0UCgilmcJ9rcalQuuChYTjR5ff1SR7h8MUYur
   g==;
IronPort-SDR: DeKi8P4k3oAWAz8m7Rgwbs5ktWJ0CdafMo/4GnQaZ1MmLdAmr/2XXAM1TC5XFaUdWUdzHuuhbN
 ++M6oIPumzI3CAXF4K0U280Rql3uA5MB16Oqu6IHePujvZQhn8UqH1NchJRaoaaSv/VP5qyMli
 qwhl/D7qBunNwJ5YiCDpthCBe4zFshHzniqC3YwxSskJZfTpTTYOxcYu2oJdR8mwhD0gY1WdjL
 R9V/6RhqQOXGFwkkave4TkTi4c70K9k64s0JF/0+cBeoG4ax0aqNGfEEwNDuJIfu4Fvh0DPDXr
 rT8R1XFV4GVZD9QqJS577qQc
X-IronPort-AV: E=Sophos;i="5.85,330,1624345200"; 
   d="scan'208";a="137712447"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Sep 2021 11:44:38 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Tue, 28 Sep 2021 11:44:15 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Tue, 28 Sep 2021 11:44:14 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v2] net: phy: micrel: Add support for LAN8804 PHY
Date:   Tue, 28 Sep 2021 20:45:19 +0200
Message-ID: <20210928184519.2315931-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The LAN8804 PHY has same features as that of LAN8814 PHY except that it
doesn't support 1588, SyncE or Q-USGMII.

This PHY is found inside the LAN966X switches.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>

---
v1 -> v2:
 - replace mchp with micrel in the title
 - add Reviewed-by tag
---
 drivers/net/phy/micrel.c   | 74 ++++++++++++++++++++++++++++++++++++++
 include/linux/micrel_phy.h |  1 +
 2 files changed, 75 insertions(+)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index 5c928f827173..c330a5a9f665 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -1537,6 +1537,65 @@ static int ksz886x_cable_test_get_status(struct phy_device *phydev,
 	return ret;
 }
 
+#define LAN_EXT_PAGE_ACCESS_CONTROL			0x16
+#define LAN_EXT_PAGE_ACCESS_ADDRESS_DATA		0x17
+#define LAN_EXT_PAGE_ACCESS_CTRL_EP_FUNC		0x4000
+
+#define LAN8804_ALIGN_SWAP				0x4a
+#define LAN8804_ALIGN_TX_A_B_SWAP			0x1
+#define LAN8804_ALIGN_TX_A_B_SWAP_MASK			GENMASK(2, 0)
+#define LAN8814_CLOCK_MANAGEMENT			0xd
+#define LAN8814_LINK_QUALITY				0x8e
+
+static int lanphy_read_page_reg(struct phy_device *phydev, int page, u32 addr)
+{
+	u32 data;
+
+	phy_write(phydev, LAN_EXT_PAGE_ACCESS_CONTROL, page);
+	phy_write(phydev, LAN_EXT_PAGE_ACCESS_ADDRESS_DATA, addr);
+	phy_write(phydev, LAN_EXT_PAGE_ACCESS_CONTROL,
+		  (page | LAN_EXT_PAGE_ACCESS_CTRL_EP_FUNC));
+	data = phy_read(phydev, LAN_EXT_PAGE_ACCESS_ADDRESS_DATA);
+
+	return data;
+}
+
+static int lanphy_write_page_reg(struct phy_device *phydev, int page, u16 addr,
+				 u16 val)
+{
+	phy_write(phydev, LAN_EXT_PAGE_ACCESS_CONTROL, page);
+	phy_write(phydev, LAN_EXT_PAGE_ACCESS_ADDRESS_DATA, addr);
+	phy_write(phydev, LAN_EXT_PAGE_ACCESS_CONTROL,
+		  (page | LAN_EXT_PAGE_ACCESS_CTRL_EP_FUNC));
+
+	val = phy_write(phydev, LAN_EXT_PAGE_ACCESS_ADDRESS_DATA, val);
+	if (val) {
+		phydev_err(phydev, "Error: phy_write has returned error %d\n",
+			   val);
+		return val;
+	}
+	return 0;
+}
+
+static int lan8804_config_init(struct phy_device *phydev)
+{
+	int val;
+
+	/* MDI-X setting for swap A,B transmit */
+	val = lanphy_read_page_reg(phydev, 2, LAN8804_ALIGN_SWAP);
+	val &= ~LAN8804_ALIGN_TX_A_B_SWAP_MASK;
+	val |= LAN8804_ALIGN_TX_A_B_SWAP;
+	lanphy_write_page_reg(phydev, 2, LAN8804_ALIGN_SWAP, val);
+
+	/* Make sure that the PHY will not stop generating the clock when the
+	 * link partner goes down
+	 */
+	lanphy_write_page_reg(phydev, 31, LAN8814_CLOCK_MANAGEMENT, 0x27e);
+	lanphy_read_page_reg(phydev, 1, LAN8814_LINK_QUALITY);
+
+	return 0;
+}
+
 static struct phy_driver ksphy_driver[] = {
 {
 	.phy_id		= PHY_ID_KS8737,
@@ -1718,6 +1777,20 @@ static struct phy_driver ksphy_driver[] = {
 	.get_stats	= kszphy_get_stats,
 	.suspend	= genphy_suspend,
 	.resume		= kszphy_resume,
+}, {
+	.phy_id		= PHY_ID_LAN8804,
+	.phy_id_mask	= MICREL_PHY_ID_MASK,
+	.name		= "Microchip LAN966X Gigabit PHY",
+	.config_init	= lan8804_config_init,
+	.driver_data	= &ksz9021_type,
+	.probe		= kszphy_probe,
+	.soft_reset	= genphy_soft_reset,
+	.read_status	= ksz9031_read_status,
+	.get_sset_count	= kszphy_get_sset_count,
+	.get_strings	= kszphy_get_strings,
+	.get_stats	= kszphy_get_stats,
+	.suspend	= genphy_suspend,
+	.resume		= kszphy_resume,
 }, {
 	.phy_id		= PHY_ID_KSZ9131,
 	.phy_id_mask	= MICREL_PHY_ID_MASK,
@@ -1794,6 +1867,7 @@ static struct mdio_device_id __maybe_unused micrel_tbl[] = {
 	{ PHY_ID_KSZ8873MLL, MICREL_PHY_ID_MASK },
 	{ PHY_ID_KSZ886X, MICREL_PHY_ID_MASK },
 	{ PHY_ID_LAN8814, MICREL_PHY_ID_MASK },
+	{ PHY_ID_LAN8804, MICREL_PHY_ID_MASK },
 	{ }
 };
 
diff --git a/include/linux/micrel_phy.h b/include/linux/micrel_phy.h
index 3d43c60b49fa..1f7c33b2f5a3 100644
--- a/include/linux/micrel_phy.h
+++ b/include/linux/micrel_phy.h
@@ -28,6 +28,7 @@
 #define PHY_ID_KSZ9031		0x00221620
 #define PHY_ID_KSZ9131		0x00221640
 #define PHY_ID_LAN8814		0x00221660
+#define PHY_ID_LAN8804		0x00221670
 
 #define PHY_ID_KSZ886X		0x00221430
 #define PHY_ID_KSZ8863		0x00221435
-- 
2.33.0

