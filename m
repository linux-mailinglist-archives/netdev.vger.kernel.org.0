Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FCB96EEE69
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 08:36:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239620AbjDZGf4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 02:35:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239611AbjDZGfx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 02:35:53 -0400
Received: from fd01.gateway.ufhost.com (fd01.gateway.ufhost.com [61.152.239.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AB0B211D;
        Tue, 25 Apr 2023 23:35:52 -0700 (PDT)
Received: from EXMBX165.cuchost.com (unknown [175.102.18.54])
        (using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "EXMBX165", Issuer "EXMBX165" (not verified))
        by fd01.gateway.ufhost.com (Postfix) with ESMTP id AA2B37FD6;
        Wed, 26 Apr 2023 14:35:44 +0800 (CST)
Received: from EXMBX162.cuchost.com (172.16.6.72) by EXMBX165.cuchost.com
 (172.16.6.75) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Wed, 26 Apr
 2023 14:35:44 +0800
Received: from starfive-sdk.starfivetech.com (171.223.208.138) by
 EXMBX162.cuchost.com (172.16.6.72) with Microsoft SMTP Server (TLS) id
 15.0.1497.42; Wed, 26 Apr 2023 14:35:43 +0800
From:   Samin Guo <samin.guo@starfivetech.com>
To:     <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <netdev@vger.kernel.org>, Peter Geis <pgwipeout@gmail.com>,
        Frank <Frank.Sae@motor-comm.com>
CC:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        "Heiner Kallweit" <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "Samin Guo" <samin.guo@starfivetech.com>,
        Yanhong Wang <yanhong.wang@starfivetech.com>
Subject: [PATCH v1 2/2] net: phy: motorcomm: Add pad drive strength cfg support
Date:   Wed, 26 Apr 2023 14:35:41 +0800
Message-ID: <20230426063541.15378-3-samin.guo@starfivetech.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230426063541.15378-1-samin.guo@starfivetech.com>
References: <20230426063541.15378-1-samin.guo@starfivetech.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [171.223.208.138]
X-ClientProxiedBy: EXCAS064.cuchost.com (172.16.6.24) To EXMBX162.cuchost.com
 (172.16.6.72)
X-YovoleRuleAgent: yovoleflag
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The motorcomm phy (YT8531) supports the ability to adjust the drive
strength of the rx_clk/rx_data, and the default strength may not be
suitable for all boards. So add configurable options to better match
the boards.(e.g. StarFive VisionFive 2)

Signed-off-by: Samin Guo <samin.guo@starfivetech.com>
---
 drivers/net/phy/motorcomm.c | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/drivers/net/phy/motorcomm.c b/drivers/net/phy/motorcomm.c
index 2fa5a90e073b..08f28ed83e60 100644
--- a/drivers/net/phy/motorcomm.c
+++ b/drivers/net/phy/motorcomm.c
@@ -236,6 +236,11 @@
  */
 #define YTPHY_WCR_TYPE_PULSE			BIT(0)
 
+#define YTPHY_PAD_DRIVE_STRENGTH_REG		0xA010
+#define YTPHY_RGMII_RXC_DS			GENMASK(15, 13)
+#define YTPHY_RGMII_RXD_DS			GENMASK(5, 4)	/* Bit 1 and 0 of rgmii_rxd_ds */
+#define YTPHY_RGMII_RXD_DS2			BIT(12) 	/* Bit 2 of rgmii_rxd_ds */
+
 #define YTPHY_SYNCE_CFG_REG			0xA012
 #define YT8521_SCR_SYNCE_ENABLE			BIT(5)
 /* 1b0 output 25m clock
@@ -1495,6 +1500,7 @@ static int yt8531_config_init(struct phy_device *phydev)
 {
 	struct device_node *node = phydev->mdio.dev.of_node;
 	int ret;
+	u32 val;
 
 	ret = ytphy_rgmii_clk_delay_config_with_lock(phydev);
 	if (ret < 0)
@@ -1518,6 +1524,32 @@ static int yt8531_config_init(struct phy_device *phydev)
 			return ret;
 	}
 
+	if (!of_property_read_u32(node, "rx-clk-driver-strength", &val)) {
+		ret = ytphy_modify_ext_with_lock(phydev,
+						 YTPHY_PAD_DRIVE_STRENGTH_REG,
+						 YTPHY_RGMII_RXC_DS,
+						 FIELD_PREP(YTPHY_RGMII_RXC_DS, val));
+		if (ret < 0)
+			return ret;
+	}
+
+	if (!of_property_read_u32(node, "rx-data-driver-strength", &val)) {
+		if (val > FIELD_MAX(YTPHY_RGMII_RXD_DS)) {
+			val &= FIELD_MAX(YTPHY_RGMII_RXD_DS);
+			val = FIELD_PREP(YTPHY_RGMII_RXD_DS, val);
+			val |= YTPHY_RGMII_RXD_DS2;
+		} else {
+			val = FIELD_PREP(YTPHY_RGMII_RXD_DS, val);
+		}
+
+		ret = ytphy_modify_ext_with_lock(phydev,
+						 YTPHY_PAD_DRIVE_STRENGTH_REG,
+						 YTPHY_RGMII_RXD_DS | YTPHY_RGMII_RXD_DS2,
+						 val);
+		if (ret < 0)
+			return ret;
+	}
+
 	return 0;
 }
 
-- 
2.17.1

