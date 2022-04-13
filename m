Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32E5B4FF03D
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 08:56:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233192AbiDMG7D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 02:59:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231911AbiDMG7B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 02:59:01 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18BBF2FFEA;
        Tue, 12 Apr 2022 23:56:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1649833002; x=1681369002;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HUdNaiyiMZU9iHdc2QWuMo3AkKZpVtohKA6j+Oda/l8=;
  b=ahK2A7Y9c+0Lz9XUEeCN7FQ1Q7r+aK38jA+atbdZSC2UA95KRI6S/7Jo
   bFn10EeJiUZOfLlP/hGO8hK2yURMBBd8tOiJO0nZo2cWomGAue/0BaTYW
   6awUpIEa/8L/CrSTw17PPty053oHkWTRRCVtJcUy4BdaOYT6GYXlgqS1t
   S3DYNiNXwgk/FSFAAOiCiDomjtRG9TajR/H2aWqOGXe1Mnfu8KSa67UYL
   CvZBEG970CVaR03ax5zjJ9UNRtURSJTPc3uIBEOUvh1Q+Hoi4PzErOU/i
   BdwiYBnjdlfHfZU7vJyyeDlEj56RSnyjvsVpIZkbFYI+Aq76LUA7WcPZx
   w==;
X-IronPort-AV: E=Sophos;i="5.90,256,1643698800"; 
   d="scan'208";a="155400219"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 12 Apr 2022 23:56:41 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 12 Apr 2022 23:56:40 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Tue, 12 Apr 2022 23:56:36 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, <UNGLinuxDriver@microchip.com>,
        Arun Ramadoss <arun.ramadoss@microchip.com>
Subject: [Patch net-next v2 1/2] net: phy: LAN87xx: add ethtool SQI support
Date:   Wed, 13 Apr 2022 12:25:56 +0530
Message-ID: <20220413065557.12914-2-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220413065557.12914-1-arun.ramadoss@microchip.com>
References: <20220413065557.12914-1-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch add the support for measuring Signal Quality Index for
LAN87xx and LAN937x T1 Phy. It uses the SQI Method 5 for obtaining the
values.

Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/phy/microchip_t1.c | 48 ++++++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

diff --git a/drivers/net/phy/microchip_t1.c b/drivers/net/phy/microchip_t1.c
index 389df3f4293c..6c594d9f3606 100644
--- a/drivers/net/phy/microchip_t1.c
+++ b/drivers/net/phy/microchip_t1.c
@@ -68,7 +68,12 @@
 #define T1_POST_LCK_MUFACT_CFG_REG	0x1C
 #define T1_TX_RX_FIFO_CFG_REG		0x02
 #define T1_TX_LPF_FIR_CFG_REG		0x55
+#define T1_COEF_CLK_PWR_DN_CFG		0x04
+#define T1_COEF_RW_CTL_CFG		0x0D
 #define T1_SQI_CONFIG_REG		0x2E
+#define T1_SQI_CONFIG2_REG		0x4A
+#define T1_DCQ_SQI_REG			0xC3
+#define T1_DCQ_SQI_MSK			GENMASK(3, 1)
 #define T1_MDIO_CONTROL2_REG		0x10
 #define T1_INTERRUPT_SOURCE_REG		0x18
 #define T1_INTERRUPT2_SOURCE_REG	0x08
@@ -82,6 +87,9 @@
 #define T1_MODE_STAT_REG		0x11
 #define T1_LINK_UP_MSK			BIT(0)
 
+/* SQI defines */
+#define LAN87XX_MAX_SQI			0x07
+
 #define DRIVER_AUTHOR	"Nisar Sayed <nisar.sayed@microchip.com>"
 #define DRIVER_DESC	"Microchip LAN87XX/LAN937x T1 PHY driver"
 
@@ -346,9 +354,20 @@ static int lan87xx_phy_init(struct phy_device *phydev)
 		  T1_TX_LPF_FIR_CFG_REG, 0x1011, 0 },
 		{ PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_DSP,
 		  T1_TX_LPF_FIR_CFG_REG, 0x1000, 0 },
+		/* Setup SQI measurement */
+		{ PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_DSP,
+		  T1_COEF_CLK_PWR_DN_CFG,	0x16d6, 0 },
 		/* SQI enable */
 		{ PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_DSP,
 		  T1_SQI_CONFIG_REG,		0x9572, 0 },
+		/* SQI select mode 5 */
+		{ PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_DSP,
+		  T1_SQI_CONFIG2_REG,		0x0001, 0 },
+		/* Throws the first SQI reading */
+		{ PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_DSP,
+		  T1_COEF_RW_CTL_CFG,		0x0301,	0 },
+		{ PHYACC_ATTR_MODE_READ, PHYACC_ATTR_BANK_DSP,
+		  T1_DCQ_SQI_REG,		0,	0 },
 		/* Flag LPS and WUR as idle errors */
 		{ PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_SMI,
 		  T1_MDIO_CONTROL2_REG,		0x0014, 0 },
@@ -729,6 +748,31 @@ static int lan87xx_config_aneg(struct phy_device *phydev)
 	return rc;
 }
 
+static int lan87xx_get_sqi(struct phy_device *phydev)
+{
+	u8 sqi_value = 0;
+	int rc;
+
+	rc = access_ereg(phydev, PHYACC_ATTR_MODE_WRITE,
+			 PHYACC_ATTR_BANK_DSP, T1_COEF_RW_CTL_CFG, 0x0301);
+	if (rc < 0)
+		return rc;
+
+	rc = access_ereg(phydev, PHYACC_ATTR_MODE_READ,
+			 PHYACC_ATTR_BANK_DSP, T1_DCQ_SQI_REG, 0x0);
+	if (rc < 0)
+		return rc;
+
+	sqi_value = FIELD_GET(T1_DCQ_SQI_MSK, rc);
+
+	return sqi_value;
+}
+
+static int lan87xx_get_sqi_max(struct phy_device *phydev)
+{
+	return LAN87XX_MAX_SQI;
+}
+
 static struct phy_driver microchip_t1_phy_driver[] = {
 	{
 		PHY_ID_MATCH_MODEL(PHY_ID_LAN87XX),
@@ -742,6 +786,8 @@ static struct phy_driver microchip_t1_phy_driver[] = {
 		.resume         = genphy_resume,
 		.config_aneg    = lan87xx_config_aneg,
 		.read_status	= lan87xx_read_status,
+		.get_sqi	= lan87xx_get_sqi,
+		.get_sqi_max	= lan87xx_get_sqi_max,
 		.cable_test_start = lan87xx_cable_test_start,
 		.cable_test_get_status = lan87xx_cable_test_get_status,
 	},
@@ -754,6 +800,8 @@ static struct phy_driver microchip_t1_phy_driver[] = {
 		.resume		= genphy_resume,
 		.config_aneg    = lan87xx_config_aneg,
 		.read_status	= lan87xx_read_status,
+		.get_sqi	= lan87xx_get_sqi,
+		.get_sqi_max	= lan87xx_get_sqi_max,
 		.cable_test_start = lan87xx_cable_test_start,
 		.cable_test_get_status = lan87xx_cable_test_get_status,
 	}
-- 
2.33.0

