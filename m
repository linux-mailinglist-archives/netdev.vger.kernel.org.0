Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF1E6441E01
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 17:20:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232616AbhKAQXR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 12:23:17 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:5023 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231362AbhKAQXQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 12:23:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1635783643; x=1667319643;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=r4rxRk9qXy1ShU6MyicLxmnkvn1rIBwlKUTRpzK00Bc=;
  b=Yxe/QjR/LkpDi+mN1uFyJZ7WmXjYfOBsBk141kLUtQQSCKuqiNMjhEqG
   goEuoZsrNUkjrCQivUu3Hx41iifrhsiCxWXtsk+mfLQ5KKmKJXQmbTG1a
   a5GTgZvCgGuRy209suHlNlk9QNbo1j8JbKKAa5TGHfoz6W7yjbqMt6XfW
   5uz2kasfMseL3w/CZeW8uBbSxLXUGox3ohWyPevWdGWiyzC777oX5p77a
   Mkb8eStPAcD0rEZkVTo0fLQcFbiaboBCZzFYIxuIXBJ8M7Kw2o61z8crH
   TyOhldOncRmlc8vaXa5rfIizpLIOyPRH4lDGP80fzyRKXNbdhIODXoINE
   g==;
IronPort-SDR: /puSLzrfNu+OqT0GaWJJyRu//IfMADIM3gYp7VOiwHYgVplAZ++nUIZboVHn8lyRjAAS8mGOwt
 uuGW8WNaB5LHiQng21d8ax3kqcpX8Ve7ph2d44s9toxnK3DTaCc9jw9JRY7UmGQa7jSS1/tbgI
 Ltdy5eGWjovcvr5FPQ8WSDy0ac638vn11OV4wi/cGpsEakQNXhGSskOrgKXosylrDJY4JmWICP
 2j2cfsjpo6fJraQv3rIcXDwHdkkbu9brTj81XKBPQA+cdC4YkmZioiQ4niG3DuW0rTRLFTEhqn
 IARHudX3ZneXOkvjcpWu5fji
X-IronPort-AV: E=Sophos;i="5.87,200,1631602800"; 
   d="scan'208";a="135061421"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 01 Nov 2021 09:20:41 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Mon, 1 Nov 2021 09:20:42 -0700
Received: from validation1-XPS-8900.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Mon, 1 Nov 2021 09:20:41 -0700
From:   Yuiko Oshino <yuiko.oshino@microchip.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     <nisar.sayed@microchip.com>, <UNGLinuxDriver@microchip.com>,
        Yuiko Oshino <yuiko.oshino@microchip.com>
Subject: [net-next] net: phy: microchip_t1: add lan87xx_config_rgmii_delay for lan87xx phy
Date:   Mon, 1 Nov 2021 12:21:19 -0400
Message-ID: <20211101162119.29275-1-yuiko.oshino@microchip.com>
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

