Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F0692D43C8
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 15:05:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732709AbgLIOAg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 09:00:36 -0500
Received: from mta-02.yadro.com ([89.207.88.252]:54196 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728539AbgLIOAb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Dec 2020 09:00:31 -0500
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id C13D4412FD;
        Wed,  9 Dec 2020 13:59:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received; s=mta-01; t=
        1607522386; x=1609336787; bh=Y2xyk/w0d2sgxR9+vPtvXUDmTgLzwzS14XM
        CrKqQtrQ=; b=XTVlpAfe+OHrW9jLrwC5P06DKFZWD3lM0lgCqsKH9ak5y1S0rCq
        t64Oaho0utmwaBUrI+UVXCDX8oitDfsFbyOPNvPmFoA2NSpsf/NlVGjGCco1KRFL
        B1Ll7zpGvFePXacF74AhNHYgvAS4wW+KH5TsGTr8k+1yRzufuhiDjA3w=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id ZDQk9Osmjuq7; Wed,  9 Dec 2020 16:59:46 +0300 (MSK)
Received: from T-EXCH-03.corp.yadro.com (t-exch-03.corp.yadro.com [172.17.100.103])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 8AC0D41281;
        Wed,  9 Dec 2020 16:59:45 +0300 (MSK)
Received: from localhost.dev.yadro.com (10.199.0.125) by
 T-EXCH-03.corp.yadro.com (172.17.100.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Wed, 9 Dec 2020 16:59:43 +0300
From:   Ivan Mikhaylov <i.mikhaylov@yadro.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
CC:     Ivan Mikhaylov <i.mikhaylov@yadro.com>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] net: phy: micrel: add LED control on KSZ9131
Date:   Wed, 9 Dec 2020 17:05:00 +0300
Message-ID: <20201209140501.17415-2-i.mikhaylov@yadro.com>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20201209140501.17415-1-i.mikhaylov@yadro.com>
References: <20201209140501.17415-1-i.mikhaylov@yadro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.199.0.125]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-03.corp.yadro.com (172.17.100.103)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the possibility to read the LED configuration via DTS properties from
KSZ9131 PHY node. Add the new proprties and handle for them:
micrel,led-mode-behavior
micrel,led-mode-select

Signed-off-by: Ivan Mikhaylov <i.mikhaylov@yadro.com>
---
 drivers/net/phy/micrel.c | 69 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 68 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index 3fe552675dd2..117f3a3b9dd6 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -71,6 +71,11 @@
 #define MII_KSZPHY_RX_DATA_PAD_SKEW             0x105
 #define MII_KSZPHY_TX_DATA_PAD_SKEW             0x106
 
+/* KSZ9131 LED registers */
+#define MII_KSZPHY_LED_MODE_SELECT		0x16
+#define MII_KSZPHY_LED_BEHAVIOR			0x17
+#define MII_KSZPHY_LED_MODE			0x1a
+
 #define PS_TO_REG				200
 
 struct kszphy_hw_stat {
@@ -86,6 +91,8 @@ static struct kszphy_hw_stat kszphy_hw_stats[] = {
 
 struct kszphy_type {
 	u32 led_mode_reg;
+	u32 led_mode_behavior_reg;
+	u32 led_mode_select_reg;
 	u16 interrupt_level_mask;
 	bool has_broadcast_disable;
 	bool has_nand_tree_disable;
@@ -95,6 +102,8 @@ struct kszphy_type {
 struct kszphy_priv {
 	const struct kszphy_type *type;
 	int led_mode;
+	int led_mode_behavior;
+	int led_mode_select;
 	bool rmii_ref_clk_sel;
 	bool rmii_ref_clk_sel_val;
 	u64 stats[ARRAY_SIZE(kszphy_hw_stats)];
@@ -131,6 +140,13 @@ static const struct kszphy_type ksz9021_type = {
 	.interrupt_level_mask	= BIT(14),
 };
 
+static const struct kszphy_type ksz9131_type = {
+	.led_mode_reg		= MII_KSZPHY_LED_MODE,
+	.led_mode_behavior_reg	= MII_KSZPHY_LED_BEHAVIOR,
+	.led_mode_select_reg	= MII_KSZPHY_LED_MODE_SELECT,
+	.interrupt_level_mask	= BIT(14),
+};
+
 static int kszphy_extended_write(struct phy_device *phydev,
 				u32 regnum, u16 val)
 {
@@ -204,6 +220,7 @@ static int kszphy_setup_led(struct phy_device *phydev, u32 reg, int val)
 
 	switch (reg) {
 	case MII_KSZPHY_CTRL_1:
+	case MII_KSZPHY_LED_MODE:
 		shift = 14;
 		break;
 	case MII_KSZPHY_CTRL_2:
@@ -286,6 +303,26 @@ static int kszphy_config_reset(struct phy_device *phydev)
 	if (priv->led_mode >= 0)
 		kszphy_setup_led(phydev, priv->type->led_mode_reg, priv->led_mode);
 
+	if (priv->led_mode_behavior >= 0) {
+		ret = phy_write(phydev, priv->type->led_mode_behavior_reg,
+				priv->led_mode_behavior);
+		if (ret) {
+			phydev_err(phydev,
+				   "failed to set led mode behavior reg\n");
+			return ret;
+		}
+	}
+
+	if (priv->led_mode_select >= 0) {
+		ret = phy_write(phydev, priv->type->led_mode_select_reg,
+				priv->led_mode_select);
+		if (ret) {
+			phydev_err(phydev,
+				   "failed to set led mode select reg\n");
+			return ret;
+		}
+	}
+
 	return 0;
 }
 
@@ -1122,6 +1159,36 @@ static int kszphy_probe(struct phy_device *phydev)
 		priv->led_mode = -1;
 	}
 
+	if (type->led_mode_behavior_reg) {
+		ret = of_property_read_u32(np, "micrel,led-mode-behavior",
+					   &priv->led_mode_behavior);
+		if (!ret) {
+			ret = phy_write(phydev, type->led_mode_behavior_reg,
+					priv->led_mode_behavior);
+			if (ret)
+				phydev_err(phydev,
+					   "invalid led mode behavior: 0x%x\n",
+					   priv->led_mode_behavior);
+		}
+	} else {
+		priv->led_mode_behavior = -1;
+	}
+
+	if (type->led_mode_select_reg) {
+		ret = of_property_read_u32(np, "micrel,led-mode-select",
+					   &priv->led_mode_select);
+		if (!ret) {
+			ret = phy_write(phydev, type->led_mode_select_reg,
+					priv->led_mode_select);
+			if (ret)
+				phydev_err(phydev,
+					   "invalid led mode select: 0x%x\n",
+					   priv->led_mode_select);
+		}
+	} else {
+		priv->led_mode_select = -1;
+	}
+
 	clk = devm_clk_get(&phydev->mdio.dev, "rmii-ref");
 	/* NOTE: clk may be NULL if building without CONFIG_HAVE_CLK */
 	if (!IS_ERR_OR_NULL(clk)) {
@@ -1319,7 +1386,7 @@ static struct phy_driver ksphy_driver[] = {
 	.phy_id_mask	= MICREL_PHY_ID_MASK,
 	.name		= "Microchip KSZ9131 Gigabit PHY",
 	/* PHY_GBIT_FEATURES */
-	.driver_data	= &ksz9021_type,
+	.driver_data	= &ksz9131_type,
 	.probe		= kszphy_probe,
 	.config_init	= ksz9131_config_init,
 	.read_status	= genphy_read_status,
-- 
2.21.1

