Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 110FC188DD5
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 20:16:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726757AbgCQTQM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 15:16:12 -0400
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:49193 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726607AbgCQTQM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 15:16:12 -0400
Received-SPF: Pass (esa3.microchip.iphmx.com: domain of
  Yuiko.Oshino@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa3.microchip.iphmx.com;
  envelope-from="Yuiko.Oshino@microchip.com";
  x-sender="Yuiko.Oshino@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com -exists:%{i}.spf.microchip.iphmx.com
  include:servers.mcsv.net include:mktomail.com
  include:spf.protection.outlook.com ~all"
Received-SPF: None (esa3.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa3.microchip.iphmx.com;
  envelope-from="Yuiko.Oshino@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa3.microchip.iphmx.com; spf=Pass smtp.mailfrom=Yuiko.Oshino@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: TNDtjDdQ0QquSHBeqJSsAanV8K9tOPnqD0Fk3aLcHNNf0zMIbTTR81ax9ekju5MHpiGkd7tUcJ
 bsUgRLEDnWWxBmothvUJ2/4iarohqYmQ3g1sOjTOmY9YaANgtNXzGLaUg1xmxpmDUp/k89N+Rf
 Xz0Ej3FQE+E4kS1RbMWJSuuD2Ki0CBpGzsaem4fE1E0PI6YsLS2r0cJ0v4JuMiX2WSA4D4jnOq
 BboS6rRtTbeTeqOsxGtkjuQRxhyuCPQKOfJvFV3FA6mXkbNLNc02eNKG7imhL6JkDe4i51qZS2
 rBI=
X-IronPort-AV: E=Sophos;i="5.70,565,1574146800"; 
   d="scan'208";a="70269836"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Mar 2020 12:15:55 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 17 Mar 2020 12:15:55 -0700
Received: from validation1-hp-compaq-6000-pro-sff-pc.mchp-main.com
 (10.10.115.15) by chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft
 SMTP Server id 15.1.1713.5 via Frontend Transport; Tue, 17 Mar 2020 12:15:55
 -0700
From:   Yuiko Oshino <yuiko.oshino@microchip.com>
To:     <davem@devemloft.net>
CC:     <UNGLinuxDriver@microchip.com>, <netdev@vger.kernel.org>
Subject: [PATCH net] net: phy: microchip_t1: add lan87xx_phy_init to initialize the lan87xx phy.
Date:   Tue, 17 Mar 2020 15:08:38 -0400
Message-ID: <1584472118-7193-1-git-send-email-yuiko.oshino@microchip.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

lan87xx_phy_init() initializes the lan87xx phy.

fixes: 3e50d2da5850 ("Add driver for Microchip LAN87XX T1 PHYs")
Signed-off-by: Yuiko Oshino <yuiko.oshino@microchip.com>
---
 drivers/net/phy/microchip_t1.c | 119 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 119 insertions(+)

diff --git a/drivers/net/phy/microchip_t1.c b/drivers/net/phy/microchip_t1.c
index 001def4..4646b7be 100644
--- a/drivers/net/phy/microchip_t1.c
+++ b/drivers/net/phy/microchip_t1.c
@@ -3,9 +3,21 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/delay.h>
 #include <linux/mii.h>
 #include <linux/phy.h>
 
+/* External Register Control Register */
+#define LAN87XX_EXT_REG_CTL                     (0x14)
+#define LAN87XX_EXT_REG_CTL_RD_CTL              (0x1000)
+#define LAN87XX_EXT_REG_CTL_WR_CTL              (0x0800)
+
+/* External Register Read Data Register */
+#define LAN87XX_EXT_REG_RD_DATA                 (0x15)
+
+/* External Register Write Data Register */
+#define LAN87XX_EXT_REG_WR_DATA                 (0x16)
+
 /* Interrupt Source Register */
 #define LAN87XX_INTERRUPT_SOURCE                (0x18)
 
@@ -14,9 +26,108 @@
 #define LAN87XX_MASK_LINK_UP                    (0x0004)
 #define LAN87XX_MASK_LINK_DOWN                  (0x0002)
 
+/* phyaccess nested types */
+#define	PHYACC_ATTR_MODE_READ		0
+#define	PHYACC_ATTR_MODE_WRITE		1
+
+#define	PHYACC_ATTR_BANK_SMI		0
+#define	PHYACC_ATTR_BANK_MISC		1
+#define	PHYACC_ATTR_BANK_PCS		2
+#define	PHYACC_ATTR_BANK_AFE		3
+
 #define DRIVER_AUTHOR	"Nisar Sayed <nisar.sayed@microchip.com>"
 #define DRIVER_DESC	"Microchip LAN87XX T1 PHY driver"
 
+struct access_ereg_val {
+	u8  mode;
+	u8  bank;
+	u8  offset;
+	u16 val;
+};
+
+static int access_ereg(struct phy_device *phydev, u8 mode, u8 bank,
+		       u8 offset, u16 val)
+{
+	u16 ereg = 0;
+	int rc = 0;
+
+	if (mode > 1 || bank > 7)
+		return -EINVAL;
+
+	if (mode == PHYACC_ATTR_MODE_WRITE) {
+		ereg |= LAN87XX_EXT_REG_CTL_WR_CTL;
+		rc = phy_write(phydev, LAN87XX_EXT_REG_WR_DATA, val);
+		if (rc < 0)
+			return rc;
+	} else {
+		ereg |= LAN87XX_EXT_REG_CTL_RD_CTL;
+	}
+
+	ereg |= (bank << 8) | offset;
+
+	rc = phy_write(phydev, LAN87XX_EXT_REG_CTL, ereg);
+	if (rc < 0)
+		return rc;
+
+	if (mode == PHYACC_ATTR_MODE_READ)
+		rc = phy_read(phydev, LAN87XX_EXT_REG_RD_DATA);
+
+	return rc;
+}
+
+static int lan87xx_phy_init(struct phy_device *phydev)
+{
+	static const struct access_ereg_val init[] = {
+		{PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_AFE, 0x0B, 0x000A},
+		{PHYACC_ATTR_MODE_READ, PHYACC_ATTR_BANK_MISC, 0x8, 0},
+		{PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_MISC, 0x8, 0},
+		{PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_MISC, 0x10, 0x0009},
+		{PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_SMI, 0x17, 0},
+		/* TC10 Config */
+		{PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_MISC, 0x20, 0x0023},
+		{PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_PCS, 0x20, 0x3C3C},
+		{PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_MISC, 0x21, 0x274F},
+		{PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_MISC, 0x20, 0x80A7},
+		{PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_MISC, 0x24, 0x9110},
+		{PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_MISC, 0x20, 0x0087},
+		/* HW Init */
+		{PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_SMI, 0x1A, 0x0300},
+	};
+	int rc, i;
+
+	/* Enter Managed Mode */
+	rc = access_ereg(phydev, PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_SMI,
+			 0x1a, 0x0300);
+	if (rc < 0)
+		return rc;
+
+	/* Reset the SMI block */
+	rc = access_ereg(phydev, PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_SMI,
+			 0x00, 0xA100);
+	if (rc < 0)
+		return rc;
+
+	/* Wait for the self-clearing bit to be cleared */
+	usleep_range(1000, 2000);
+	rc = access_ereg(phydev, PHYACC_ATTR_MODE_READ,
+			 PHYACC_ATTR_BANK_SMI, 0x00, 0);
+	if (rc < 0)
+		return rc;
+	if ((rc & 0x8000) != 0)
+		return -ETIMEDOUT;
+
+	/* PHY Initialization */
+	for (i = 0; i < ARRAY_SIZE(init); i++) {
+		rc = access_ereg(phydev, init[i].mode, init[i].bank,
+				 init[i].offset, init[i].val);
+
+		if (rc < 0)
+			return rc;
+	}
+
+	return 0;
+}
+
 static int lan87xx_phy_config_intr(struct phy_device *phydev)
 {
 	int rc, val = 0;
@@ -40,6 +151,13 @@ static int lan87xx_phy_ack_interrupt(struct phy_device *phydev)
 	return rc < 0 ? rc : 0;
 }
 
+static int lan87xx_config_init(struct phy_device *phydev)
+{
+	int rc = lan87xx_phy_init(phydev);
+
+	return rc < 0 ? rc : 0;
+}
+
 static struct phy_driver microchip_t1_phy_driver[] = {
 	{
 		.phy_id         = 0x0007c150,
@@ -48,6 +166,7 @@ static struct phy_driver microchip_t1_phy_driver[] = {
 
 		.features       = PHY_BASIC_T1_FEATURES,
 
+		.config_init	= lan87xx_config_init,
 		.config_aneg    = genphy_config_aneg,
 
 		.ack_interrupt  = lan87xx_phy_ack_interrupt,
-- 
2.7.4

