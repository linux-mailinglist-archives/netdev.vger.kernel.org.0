Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28C09441EDD
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 17:55:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232422AbhKAQ6I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 12:58:08 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:4583 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229811AbhKAQ6H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 12:58:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1635785734; x=1667321734;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=r4rxRk9qXy1ShU6MyicLxmnkvn1rIBwlKUTRpzK00Bc=;
  b=faenUZRD38OKDYO4/TIsWOjFsCaGSy9WjvvOxKWSPFtlycUYK5qU5J0J
   8tyisRSLqaIHAMVEKbeeXxNFmzZt5Bi56wRyxcY80vCp5nGwFQrmVxcPI
   cfrsElI+FFxU/3D6R6l7pGTRVACbCDTCYMEl9UE9x9JAfRCPD7RSm0TRm
   C8oA7yBLyvWuydaE1F/Eio2sGkWekJx6wEy3l8YgrePT0qVVN6NhvE1zT
   QghRZOQT7pDfiSp3QDa8zOr9SS2aU/rsjkIYLa4ld2JlRPyKfR1H4YVYF
   hhh/3Iw1iD7G47nqSKr1jY/agSD995HvfvQYN5swnvDvzKYk0fZWj77am
   g==;
IronPort-SDR: VXUtn255H252f3JQrMJt7pEvODmVb2siINsJ18E+YWuwg3vUtYk2re/vBlHMblHuhqPMRkMCcR
 NPwSt8vRy1ffSdWSdz8Z6H09+Q1+tgC0VxUWEwutBk4dE7CkXCvy1JNfz0zeXOjN3zrL0SfD7z
 /r7kknMdodnkF2rBuIEV12f0sZLY8EAIP+yKnzxqQma34s0NOCJDOCeIaaT2I6IPYaPtcadB9t
 bEleQP98cT6fh0GxXjODUz8essOn6k5srg+qKL0vtiMKWHTglUhNFKITnyX2WvArzPQm/ml8sk
 1i0Q7PLZh3NMSetTjKSU+mmf
X-IronPort-AV: E=Sophos;i="5.87,200,1631602800"; 
   d="scan'208";a="142407989"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 01 Nov 2021 09:55:34 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Mon, 1 Nov 2021 09:55:33 -0700
Received: from validation1-XPS-8900.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Mon, 1 Nov 2021 09:55:33 -0700
From:   Yuiko Oshino <yuiko.oshino@microchip.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     <nisar.sayed@microchip.com>, <UNGLinuxDriver@microchip.com>,
        Yuiko Oshino <yuiko.oshino@microchip.com>
Subject: [PATCH net-next] net: phy: microchip_t1: add lan87xx_config_rgmii_delay for lan87xx phy
Date:   Mon, 1 Nov 2021 12:56:10 -0400
Message-ID: <20211101165610.29755-1-yuiko.oshino@microchip.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a function to initialize phy rgmii delay according to phydev->interface.

Signed-off-by: Yuiko Oshino <yuiko.oshino@microchip.com>
---
 drivers/net/phy/microchip_t1.c | 44 +++++++++++++++++++++++++++++++++-
 1 file changed, 43 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/microchip_t1.c b/drivers/net/phy/microchip_t1.c
index a4de3d2081c5..bc50224d43dd 100644
--- a/drivers/net/phy/microchip_t1.c
+++ b/drivers/net/phy/microchip_t1.c
@@ -28,6 +28,11 @@
 #define LAN87XX_MASK_LINK_UP                    (0x0004)
 #define LAN87XX_MASK_LINK_DOWN                  (0x0002)
 
+/* MISC Control 1 Register */
+#define LAN87XX_CTRL_1                          (0x11)
+#define LAN87XX_MASK_RGMII_TXC_DLY_EN           (0x4000)
+#define LAN87XX_MASK_RGMII_RXC_DLY_EN           (0x2000)
+
 /* phyaccess nested types */
 #define	PHYACC_ATTR_MODE_READ		0
 #define	PHYACC_ATTR_MODE_WRITE		1
@@ -112,6 +117,43 @@ static int access_ereg_modify_changed(struct phy_device *phydev,
 	return rc;
 }
 
+static int lan87xx_config_rgmii_delay(struct phy_device *phydev)
+{
+	int rc;
+
+	if (!phy_interface_is_rgmii(phydev))
+		return 0;
+
+	rc = access_ereg(phydev, PHYACC_ATTR_MODE_READ,
+			 PHYACC_ATTR_BANK_MISC, LAN87XX_CTRL_1, 0);
+	if (rc < 0)
+		return rc;
+
+	switch (phydev->interface) {
+	case PHY_INTERFACE_MODE_RGMII:
+		rc &= ~LAN87XX_MASK_RGMII_TXC_DLY_EN;
+		rc &= ~LAN87XX_MASK_RGMII_RXC_DLY_EN;
+		break;
+	case PHY_INTERFACE_MODE_RGMII_ID:
+		rc |= LAN87XX_MASK_RGMII_TXC_DLY_EN;
+		rc |= LAN87XX_MASK_RGMII_RXC_DLY_EN;
+		break;
+	case PHY_INTERFACE_MODE_RGMII_RXID:
+		rc &= ~LAN87XX_MASK_RGMII_TXC_DLY_EN;
+		rc |= LAN87XX_MASK_RGMII_RXC_DLY_EN;
+		break;
+	case PHY_INTERFACE_MODE_RGMII_TXID:
+		rc |= LAN87XX_MASK_RGMII_TXC_DLY_EN;
+		rc &= ~LAN87XX_MASK_RGMII_RXC_DLY_EN;
+		break;
+	default:
+		return 0;
+	}
+
+	return access_ereg(phydev, PHYACC_ATTR_MODE_WRITE,
+			   PHYACC_ATTR_BANK_MISC, LAN87XX_CTRL_1, rc);
+}
+
 static int lan87xx_phy_init(struct phy_device *phydev)
 {
 	static const struct access_ereg_val init[] = {
@@ -185,7 +227,7 @@ static int lan87xx_phy_init(struct phy_device *phydev)
 			return rc;
 	}
 
-	return 0;
+	return lan87xx_config_rgmii_delay(phydev);
 }
 
 static int lan87xx_phy_config_intr(struct phy_device *phydev)
-- 
2.25.1

