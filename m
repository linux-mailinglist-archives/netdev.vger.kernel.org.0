Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CB004E2CF5
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 16:54:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349069AbiCUP4D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 11:56:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349010AbiCUPzy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 11:55:54 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E5BE181160;
        Mon, 21 Mar 2022 08:54:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1647878068; x=1679414068;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YK/s9M5dM9W+oVehrs/ALR9xtLEfVnh8YMQ1VH2XiPU=;
  b=VY6DBu0RMLvNuqKRq2RZfQEDdtsnK4ULKnVSbvQt/FVN7AkmX182GhHS
   M9ZE4+VFyUMYqVec6Yc6PiPvFO3iPsgUq6RtyT1jA6Fha+MAzoSo2fF4S
   Ra7uNms+fno3JZQX/CJ/0H/Uo/JNN+lw1RBMhR1GjWGr0WfQcXJd6QTVS
   uCRHubIfuYUTGTd/J4gvjL5ZejtYANUXGj5RSpzfNox3k3Bl9hglgw1ON
   Jlngsv1y0KfbVqYHWaEIv/UAVxZR9Qrs+KwuES2JP7kaydVa/IFi5eoHJ
   Jdjq3U80xrA/frbPv9UB5trsMALlYJ8o3IQwdZsxI8PuwlYC2ohuSgtGe
   w==;
X-IronPort-AV: E=Sophos;i="5.90,199,1643698800"; 
   d="scan'208";a="152707589"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 21 Mar 2022 08:54:27 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Mon, 21 Mar 2022 08:54:27 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Mon, 21 Mar 2022 08:54:22 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, <UNGLinuxDriver@microchip.com>
Subject: [RFC Patch net-next 3/3] net: phy: lan87xx: added ethtool SQI support
Date:   Mon, 21 Mar 2022 21:23:37 +0530
Message-ID: <20220321155337.16260-4-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220321155337.16260-1-arun.ramadoss@microchip.com>
References: <20220321155337.16260-1-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch add the support for measuring Signal Quality Index for
LAN87xx and LAN937x T1 Phy. To get better accuracy of the SQI,
readings are measured and its average is calculated. If the link is
down, then routine return immediately.

Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
 drivers/net/phy/microchip_t1.c | 132 +++++++++++++++++++++++++++++++++
 1 file changed, 132 insertions(+)

diff --git a/drivers/net/phy/microchip_t1.c b/drivers/net/phy/microchip_t1.c
index 2742d71a469f..ebbf1e8067f6 100644
--- a/drivers/net/phy/microchip_t1.c
+++ b/drivers/net/phy/microchip_t1.c
@@ -9,6 +9,7 @@
 #include <linux/ethtool.h>
 #include <linux/ethtool_netlink.h>
 #include <linux/bitfield.h>
+#include <linux/sort.h>
 
 #define PHY_ID_LAN87XX				0x0007c150
 #define PHY_ID_LAN937X				0x0007c180
@@ -68,7 +69,14 @@
 #define T1_POST_LCK_MUFACT_CFG_REG	0x1C
 #define T1_TX_RX_FIFO_CFG_REG		0x02
 #define T1_TX_LPF_FIR_CFG_REG		0x55
+#define T1_COEF_CLK_PWR_DN_CFG		0x04
+#define T1_COEF_RW_CTL_CFG		0x0D
 #define T1_SQI_CONFIG_REG		0x2E
+#define T1_SQI_CONFIG2_REG		0x4A
+#define T1_DCQ_MSE_REG			0xC1
+#define T1_MSE_VLD_MSK			BIT(9)
+#define T1_DCQ_SQI_REG			0xC3
+#define T1_DCQ_SQI_MSK			GENMASK(3, 1)
 #define T1_MDIO_CONTROL2_REG		0x10
 #define T1_INTERRUPT_SOURCE_REG		0x18
 #define T1_INTERRUPT2_SOURCE_REG	0x08
@@ -82,6 +90,12 @@
 #define T1_MODE_STAT_REG		0x11
 #define T1_LINK_UP_MSK			BIT(0)
 
+/* SQI defines */
+#define LAN87XX_MAX_SQI			0x07
+#define LAN87XX_SQI_ENTRY		200
+#define SQI_AVG_MIN			40
+#define SQI_AVG_MAX			160
+
 #define DRIVER_AUTHOR	"Nisar Sayed <nisar.sayed@microchip.com>"
 #define DRIVER_DESC	"Microchip LAN87XX/LAN937x T1 PHY driver"
 
@@ -740,6 +754,120 @@ static int lan87xx_config_aneg(struct phy_device *phydev)
 	return rc;
 }
 
+static int lan87xx_sqi_cmp(const void *a, const void *b)
+{
+	return *(u16 *)a - *(u16 *)b;
+}
+
+static int lan87xx_get_sqi(struct phy_device *phydev)
+{
+	u16 sqi_value[LAN87XX_SQI_ENTRY];
+	u32 sqi_avg = 0;
+	int rc;
+	u8 i;
+
+	rc = lan87xx_update_link(phydev);
+	if (rc < 0)
+		return rc;
+
+	if (phydev->link == 0)
+		return sqi_avg;
+
+	rc = access_ereg(phydev, PHYACC_ATTR_MODE_WRITE,
+			 PHYACC_ATTR_BANK_DSP, T1_COEF_CLK_PWR_DN_CFG, 0x16d6);
+	if (rc < 0)
+		return rc;
+
+	/* Enable SQI measurement */
+	rc = access_ereg(phydev, PHYACC_ATTR_MODE_WRITE,
+			 PHYACC_ATTR_BANK_DSP, T1_SQI_CONFIG_REG, 0x9572);
+	if (rc < 0)
+		return rc;
+
+	/* Enable SQI Method 5 */
+	rc = access_ereg(phydev, PHYACC_ATTR_MODE_WRITE,
+			 PHYACC_ATTR_BANK_DSP, T1_SQI_CONFIG2_REG, 0x0001);
+	if (rc < 0)
+		return rc;
+
+	/* Below effectively throws away first reading
+	 * required delay before reading DSP.
+	 */
+	rc = access_ereg(phydev, PHYACC_ATTR_MODE_WRITE,
+			 PHYACC_ATTR_BANK_DSP, T1_COEF_RW_CTL_CFG, 0x0301);
+	if (rc < 0)
+		return rc;
+
+	usleep_range(40, 50);
+
+	for (i = 0; i < LAN87XX_SQI_ENTRY; i++) {
+		rc = lan87xx_update_link(phydev);
+		if (rc < 0)
+			return rc;
+
+		if (phydev->link == 0)
+			return sqi_avg;
+
+		rc = access_ereg(phydev, PHYACC_ATTR_MODE_WRITE,
+				 PHYACC_ATTR_BANK_DSP,
+				 T1_COEF_RW_CTL_CFG, 0x0301);
+		if (rc < 0)
+			return rc;
+
+		rc = access_ereg(phydev, PHYACC_ATTR_MODE_READ,
+				 PHYACC_ATTR_BANK_DSP, T1_DCQ_SQI_REG, 0x0);
+		if (rc < 0)
+			return rc;
+
+		sqi_value[i] = FIELD_GET(T1_DCQ_SQI_MSK, rc);
+
+		rc = access_ereg(phydev, PHYACC_ATTR_MODE_READ,
+				 PHYACC_ATTR_BANK_DSP, T1_DCQ_MSE_REG, 0x0);
+		if (rc < 0)
+			return rc;
+
+		/* Check valid value. 0 - valid, 1 - Invalid
+		 * if invalid, re-read the value after 250ms
+		 */
+		if (FIELD_GET(T1_MSE_VLD_MSK, rc) == 1) {
+			rc = access_ereg(phydev, PHYACC_ATTR_MODE_WRITE,
+					 PHYACC_ATTR_BANK_DSP,
+					 T1_COEF_RW_CTL_CFG, 0x0301);
+			if (rc < 0)
+				return rc;
+
+			msleep(250);
+
+			rc = access_ereg(phydev, PHYACC_ATTR_MODE_READ,
+					 PHYACC_ATTR_BANK_DSP,
+					 T1_DCQ_SQI_REG, 0x0);
+			if (rc < 0)
+				return rc;
+
+			sqi_value[i] = FIELD_GET(T1_DCQ_SQI_MSK, rc);
+		}
+	}
+
+	/* Sorting SQI values */
+	sort(sqi_value, LAN87XX_SQI_ENTRY, sizeof(u16), lan87xx_sqi_cmp, NULL);
+
+	/* Discarding outliers */
+	for (i = 0; i < LAN87XX_SQI_ENTRY; i++) {
+		if (i >= SQI_AVG_MIN && i <= SQI_AVG_MAX)
+			sqi_avg += sqi_value[i];
+	}
+
+	/* Calculating SQI number */
+	sqi_avg = DIV_ROUND_UP(sqi_avg, (SQI_AVG_MAX - SQI_AVG_MIN + 1));
+
+	return sqi_avg;
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
@@ -753,6 +881,8 @@ static struct phy_driver microchip_t1_phy_driver[] = {
 		.resume         = genphy_resume,
 		.config_aneg    = lan87xx_config_aneg,
 		.read_status	= lan87xx_read_status,
+		.get_sqi	= lan87xx_get_sqi,
+		.get_sqi_max	= lan87xx_get_sqi_max,
 		.cable_test_start = lan87xx_cable_test_start,
 		.cable_test_get_status = lan87xx_cable_test_get_status,
 	},
@@ -766,6 +896,8 @@ static struct phy_driver microchip_t1_phy_driver[] = {
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

