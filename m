Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 773454C6ED9
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 15:06:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236953AbiB1OGw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 09:06:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236956AbiB1OGv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 09:06:51 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACE7D7E0B3;
        Mon, 28 Feb 2022 06:06:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1646057167; x=1677593167;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1nIxbX6zAxJyLfepn3z5Rvq3UXuCXJZMdVIpT5E4fVc=;
  b=aLG1pKs6KAXkc1R3JKev9SGYGJm47Hlt88yOTE1QGkqxG5e49ihw2DYC
   jq5tdLFF8c6774JwNrl8yrV8nl8YCNCYkXekLilV+NBsBSphyDjUBULox
   iCniRc0kEtwbIXKX/zWb34B6Rvlg79CiC24v46c/tSz93PMfq7NhAJEkW
   jqqRfSJsTrikwWHUhIsFo771q5veNtmBWSu/tnNnD6XDgHtP96FpRK7Ng
   uM+XVC+a0nfxYfbiggGhkQqjRpAYtEojR75znC5gcrejeNyulHXVOY/kV
   V9pDM8iff1pPZ+GMiOdLhGdPJiw1SRuzcJ6cGllvjUO4R6wtHCw+rP9Ea
   A==;
X-IronPort-AV: E=Sophos;i="5.90,142,1643698800"; 
   d="scan'208";a="150237978"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Feb 2022 07:06:00 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Mon, 28 Feb 2022 07:05:59 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Mon, 28 Feb 2022 07:05:56 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Subject: [RFC PATCH net-next 3/4] net: phy: added the LAN937x phy support
Date:   Mon, 28 Feb 2022 19:35:09 +0530
Message-ID: <20220228140510.20883-4-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220228140510.20883-1-arun.ramadoss@microchip.com>
References: <20220228140510.20883-1-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,T_SCC_BODY_TEXT_LINE,
        T_SPF_PERMERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

LAN937x T1 Phy is based on LAN87xx Phy, so reusing the init script of
the Lan87xx. There is a workaround in accessing the DSP bank register
for Lan937x Phy. Whenever there is a bank switch to DSP registers, then
we need a dummy read access before proceeding to the actual register
access.

Signed-off-by: Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
 drivers/net/phy/microchip_t1.c | 47 +++++++++++++++++++++++++++++++---
 1 file changed, 44 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/microchip_t1.c b/drivers/net/phy/microchip_t1.c
index 33325e5bd884..634a1423182a 100644
--- a/drivers/net/phy/microchip_t1.c
+++ b/drivers/net/phy/microchip_t1.c
@@ -10,6 +10,7 @@
 #include <linux/ethtool_netlink.h>
 
 #define LAN87XX_PHY_ID			0x0007c150
+#define LAN937X_T1_PHY_ID		0x0007c181
 #define MICROCHIP_PHY_ID_MASK		0xfffffff0
 
 /* External Register Control Register */
@@ -76,8 +77,12 @@
 #define T1_EQ_WT_FD_LCK_FRZ_CFG		0x6D
 #define T1_PST_EQ_LCK_STG1_FRZ_CFG	0x6E
 
+#define T1_REG_BANK_SEL_MASK		0x7
+#define T1_REG_BANK_SEL			8
+#define T1_REG_ADDR_MASK		0xFF
+
 #define DRIVER_AUTHOR	"Nisar Sayed <nisar.sayed@microchip.com>"
-#define DRIVER_DESC	"Microchip LAN87XX T1 PHY driver"
+#define DRIVER_DESC	"Microchip LAN87XX/LAN937x T1 PHY driver"
 
 struct access_ereg_val {
 	u8  mode;
@@ -115,6 +120,32 @@ static int access_ereg(struct phy_device *phydev, u8 mode, u8 bank,
 
 	ereg |= (bank << 8) | offset;
 
+	/* DSP bank access workaround for lan937x */
+	if (phydev->phy_id == LAN937X_T1_PHY_ID) {
+		u8 prev_bank;
+		u16 val;
+
+		/* Read previous selected bank */
+		rc = phy_read(phydev, LAN87XX_EXT_REG_CTL);
+		if (rc < 0)
+			return rc;
+
+		/* store the prev_bank */
+		prev_bank = (rc >> T1_REG_BANK_SEL) & T1_REG_BANK_SEL_MASK;
+
+		if (bank != prev_bank && bank == PHYACC_ATTR_BANK_DSP) {
+			val = ereg & ~T1_REG_ADDR_MASK;
+
+			val &= ~LAN87XX_EXT_REG_CTL_WR_CTL;
+			val |= LAN87XX_EXT_REG_CTL_RD_CTL;
+
+			/* access twice for DSP bank change,dummy access */
+			rc = phy_write(phydev, LAN87XX_EXT_REG_CTL, val);
+			if (rc < 0)
+				return rc;
+		}
+	}
+
 	rc = phy_write(phydev, LAN87XX_EXT_REG_CTL, ereg);
 	if (rc < 0)
 		return rc;
@@ -397,7 +428,7 @@ static irqreturn_t lan87xx_handle_interrupt(struct phy_device *phydev)
 	return IRQ_HANDLED;
 }
 
-static int lan87xx_config_init(struct phy_device *phydev)
+static int lan_phy_config_init(struct phy_device *phydev)
 {
 	int rc = lan87xx_phy_init(phydev);
 
@@ -642,13 +673,22 @@ static struct phy_driver microchip_t1_phy_driver[] = {
 		.name           = "LAN87xx T1",
 		.flags          = PHY_POLL_CABLE_TEST,
 		.features       = PHY_BASIC_T1_FEATURES,
-		.config_init	= lan87xx_config_init,
+		.config_init	= lan_phy_config_init,
 		.config_intr    = lan87xx_phy_config_intr,
 		.handle_interrupt = lan87xx_handle_interrupt,
 		.suspend        = genphy_suspend,
 		.resume         = genphy_resume,
 		.cable_test_start = lan87xx_cable_test_start,
 		.cable_test_get_status = lan87xx_cable_test_get_status,
+	},
+	{
+		.phy_id		= LAN937X_T1_PHY_ID,
+		.phy_id_mask	= MICROCHIP_PHY_ID_MASK,
+		.name		= "LAN937x T1",
+		.features	= PHY_BASIC_T1_FEATURES,
+		.config_init	= lan_phy_config_init,
+		.suspend	= genphy_suspend,
+		.resume		= genphy_resume,
 	}
 };
 
@@ -656,6 +696,7 @@ module_phy_driver(microchip_t1_phy_driver);
 
 static struct mdio_device_id __maybe_unused microchip_t1_tbl[] = {
 	{ LAN87XX_PHY_ID, MICROCHIP_PHY_ID_MASK},
+	{ LAN937X_T1_PHY_ID, MICROCHIP_PHY_ID_MASK},
 	{ }
 };
 
-- 
2.33.0

