Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7A20680600
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 07:36:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235762AbjA3GgD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 01:36:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235533AbjA3GgA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 01:36:00 -0500
Received: from out28-196.mail.aliyun.com (out28-196.mail.aliyun.com [115.124.28.196])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E90D01ABD7;
        Sun, 29 Jan 2023 22:35:58 -0800 (PST)
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.3420512|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_system_inform|0.15356-0.00644005-0.84;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047205;MF=frank.sae@motor-comm.com;NM=1;PH=DS;RN=18;RT=18;SR=0;TI=SMTPD_---.R4fCYFY_1675060552;
Received: from sun-VirtualBox..(mailfrom:Frank.Sae@motor-comm.com fp:SMTPD_---.R4fCYFY_1675060552)
          by smtp.aliyun-inc.com;
          Mon, 30 Jan 2023 14:35:53 +0800
From:   Frank Sae <Frank.Sae@motor-comm.com>
To:     Peter Geis <pgwipeout@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        yanhong.wang@starfivetech.com
Cc:     xiaogang.fan@motor-comm.com, fei.zhang@motor-comm.com,
        hua.sun@motor-comm.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Frank <Frank.Sae@motor-comm.com>,
        devicetree@vger.kernel.org
Subject: [PATCH net-next v3 2/5] net: phy: Add BIT macro for Motorcomm yt8521/yt8531 gigabit ethernet phy
Date:   Mon, 30 Jan 2023 14:35:36 +0800
Message-Id: <20230130063539.3700-3-Frank.Sae@motor-comm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230130063539.3700-1-Frank.Sae@motor-comm.com>
References: <20230130063539.3700-1-Frank.Sae@motor-comm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

 Add BIT macro for Motorcomm yt8521/yt8531 gigabit ethernet phy.
 This is a preparatory patch. Add BIT macro for 0xA012 reg, and
 supplement for 0xA001 and 0xA003 reg. These will be used to support dts.

Signed-off-by: Frank Sae <Frank.Sae@motor-comm.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/phy/motorcomm.c | 55 ++++++++++++++++++++++++++++++++++---
 1 file changed, 51 insertions(+), 4 deletions(-)

diff --git a/drivers/net/phy/motorcomm.c b/drivers/net/phy/motorcomm.c
index 685190db72de..5442eab54094 100644
--- a/drivers/net/phy/motorcomm.c
+++ b/drivers/net/phy/motorcomm.c
@@ -161,6 +161,11 @@
 
 #define YT8521_CHIP_CONFIG_REG			0xA001
 #define YT8521_CCR_SW_RST			BIT(15)
+/* 1b0 disable 1.9ns rxc clock delay  *default*
+ * 1b1 enable 1.9ns rxc clock delay
+ */
+#define YT8521_CCR_RXC_DLY_EN			BIT(8)
+#define YT8521_CCR_RXC_DLY_1_900_NS		1900
 
 #define YT8521_CCR_MODE_SEL_MASK		(BIT(2) | BIT(1) | BIT(0))
 #define YT8521_CCR_MODE_UTP_TO_RGMII		0
@@ -178,22 +183,41 @@
 #define YT8521_MODE_POLL			0x3
 
 #define YT8521_RGMII_CONFIG1_REG		0xA003
-
+/* 1b0 use original tx_clk_rgmii  *default*
+ * 1b1 use inverted tx_clk_rgmii.
+ */
+#define YT8521_RC1R_TX_CLK_SEL_INVERTED		BIT(14)
 /* TX Gig-E Delay is bits 3:0, default 0x1
  * TX Fast-E Delay is bits 7:4, default 0xf
  * RX Delay is bits 13:10, default 0x0
  * Delay = 150ps * N
  * On = 2250ps, off = 0ps
  */
-#define YT8521_RC1R_RX_DELAY_MASK		(0xF << 10)
+#define YT8521_RC1R_RX_DELAY_MASK		GENMASK(13, 10)
 #define YT8521_RC1R_RX_DELAY_EN			(0xF << 10)
 #define YT8521_RC1R_RX_DELAY_DIS		(0x0 << 10)
-#define YT8521_RC1R_FE_TX_DELAY_MASK		(0xF << 4)
+#define YT8521_RC1R_FE_TX_DELAY_MASK		GENMASK(7, 4)
 #define YT8521_RC1R_FE_TX_DELAY_EN		(0xF << 4)
 #define YT8521_RC1R_FE_TX_DELAY_DIS		(0x0 << 4)
-#define YT8521_RC1R_GE_TX_DELAY_MASK		(0xF << 0)
+#define YT8521_RC1R_GE_TX_DELAY_MASK		GENMASK(3, 0)
 #define YT8521_RC1R_GE_TX_DELAY_EN		(0xF << 0)
 #define YT8521_RC1R_GE_TX_DELAY_DIS		(0x0 << 0)
+#define YT8521_RC1R_RGMII_0_000_NS		0
+#define YT8521_RC1R_RGMII_0_150_NS		1
+#define	YT8521_RC1R_RGMII_0_300_NS		2
+#define	YT8521_RC1R_RGMII_0_450_NS		3
+#define	YT8521_RC1R_RGMII_0_600_NS		4
+#define YT8521_RC1R_RGMII_0_750_NS		5
+#define	YT8521_RC1R_RGMII_0_900_NS		6
+#define	YT8521_RC1R_RGMII_1_050_NS		7
+#define	YT8521_RC1R_RGMII_1_200_NS		8
+#define YT8521_RC1R_RGMII_1_350_NS		9
+#define	YT8521_RC1R_RGMII_1_500_NS		10
+#define	YT8521_RC1R_RGMII_1_650_NS		11
+#define	YT8521_RC1R_RGMII_1_800_NS		12
+#define	YT8521_RC1R_RGMII_1_950_NS		13
+#define	YT8521_RC1R_RGMII_2_100_NS		14
+#define	YT8521_RC1R_RGMII_2_250_NS		15
 
 #define YTPHY_MISC_CONFIG_REG			0xA006
 #define YTPHY_MCR_FIBER_SPEED_MASK		BIT(0)
@@ -222,6 +246,29 @@
  */
 #define YTPHY_WCR_TYPE_PULSE			BIT(0)
 
+#define YTPHY_SYNCE_CFG_REG			0xA012
+#define YT8521_SCR_SYNCE_ENABLE			BIT(5)
+/* 1b0 output 25m clock
+ * 1b1 output 125m clock  *default*
+ */
+#define YT8521_SCR_CLK_FRE_SEL_125M		BIT(3)
+#define YT8521_SCR_CLK_SRC_MASK			GENMASK(2, 1)
+#define YT8521_SCR_CLK_SRC_PLL_125M		0
+#define YT8521_SCR_CLK_SRC_UTP_RX		1
+#define YT8521_SCR_CLK_SRC_SDS_RX		2
+#define YT8521_SCR_CLK_SRC_REF_25M		3
+#define YT8531_SCR_SYNCE_ENABLE			BIT(6)
+/* 1b0 output 25m clock   *default*
+ * 1b1 output 125m clock
+ */
+#define YT8531_SCR_CLK_FRE_SEL_125M		BIT(4)
+#define YT8531_SCR_CLK_SRC_MASK			GENMASK(3, 1)
+#define YT8531_SCR_CLK_SRC_PLL_125M		0
+#define YT8531_SCR_CLK_SRC_UTP_RX		1
+#define YT8531_SCR_CLK_SRC_SDS_RX		2
+#define YT8531_SCR_CLK_SRC_CLOCK_FROM_DIGITAL	3
+#define YT8531_SCR_CLK_SRC_REF_25M		4
+#define YT8531_SCR_CLK_SRC_SSC_25M		5
 #define YT8531S_SYNCE_CFG_REG			0xA012
 #define YT8531S_SCR_SYNCE_ENABLE		BIT(6)
 
-- 
2.34.1

