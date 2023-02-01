Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B823F68060A
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 07:37:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235413AbjA3GhD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 01:37:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235265AbjA3Ggy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 01:36:54 -0500
Received: from out28-146.mail.aliyun.com (out28-146.mail.aliyun.com [115.124.28.146])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47C7226840;
        Sun, 29 Jan 2023 22:36:33 -0800 (PST)
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.07436454|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_system_inform|0.0712192-0.000815318-0.927965;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047193;MF=frank.sae@motor-comm.com;NM=1;PH=DS;RN=18;RT=18;SR=0;TI=SMTPD_---.R4fCYJ6_1675060554;
Received: from sun-VirtualBox..(mailfrom:Frank.Sae@motor-comm.com fp:SMTPD_---.R4fCYJ6_1675060554)
          by smtp.aliyun-inc.com;
          Mon, 30 Jan 2023 14:35:55 +0800
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
Subject: [PATCH net-next v3 3/5] net: phy: Add dts support for Motorcomm yt8521 gigabit ethernet phy
Date:   Mon, 30 Jan 2023 14:35:37 +0800
Message-Id: <20230130063539.3700-4-Frank.Sae@motor-comm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230130063539.3700-1-Frank.Sae@motor-comm.com>
References: <20230130063539.3700-1-Frank.Sae@motor-comm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

 Add dts support for Motorcomm yt8521 gigabit ethernet phy.
 Add ytphy_rgmii_clk_delay_config function to support dst config for
 the delay of rgmii clk. This funciont is common for yt8521, yt8531s
 and yt8531.
 This patch has been verified on AM335x platform.

Signed-off-by: Frank Sae <Frank.Sae@motor-comm.com>
---
 drivers/net/phy/motorcomm.c | 253 ++++++++++++++++++++++++++++--------
 1 file changed, 199 insertions(+), 54 deletions(-)

diff --git a/drivers/net/phy/motorcomm.c b/drivers/net/phy/motorcomm.c
index 5442eab54094..4a5ca846adeb 100644
--- a/drivers/net/phy/motorcomm.c
+++ b/drivers/net/phy/motorcomm.c
@@ -10,6 +10,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/phy.h>
+#include <linux/of.h>
 
 #define PHY_ID_YT8511		0x0000010a
 #define PHY_ID_YT8521		0x0000011A
@@ -187,21 +188,9 @@
  * 1b1 use inverted tx_clk_rgmii.
  */
 #define YT8521_RC1R_TX_CLK_SEL_INVERTED		BIT(14)
-/* TX Gig-E Delay is bits 3:0, default 0x1
- * TX Fast-E Delay is bits 7:4, default 0xf
- * RX Delay is bits 13:10, default 0x0
- * Delay = 150ps * N
- * On = 2250ps, off = 0ps
- */
 #define YT8521_RC1R_RX_DELAY_MASK		GENMASK(13, 10)
-#define YT8521_RC1R_RX_DELAY_EN			(0xF << 10)
-#define YT8521_RC1R_RX_DELAY_DIS		(0x0 << 10)
 #define YT8521_RC1R_FE_TX_DELAY_MASK		GENMASK(7, 4)
-#define YT8521_RC1R_FE_TX_DELAY_EN		(0xF << 4)
-#define YT8521_RC1R_FE_TX_DELAY_DIS		(0x0 << 4)
 #define YT8521_RC1R_GE_TX_DELAY_MASK		GENMASK(3, 0)
-#define YT8521_RC1R_GE_TX_DELAY_EN		(0xF << 0)
-#define YT8521_RC1R_GE_TX_DELAY_DIS		(0x0 << 0)
 #define YT8521_RC1R_RGMII_0_000_NS		0
 #define YT8521_RC1R_RGMII_0_150_NS		1
 #define	YT8521_RC1R_RGMII_0_300_NS		2
@@ -274,6 +263,10 @@
 
 /* Extended Register  end */
 
+#define YTPHY_DTS_OUTPUT_CLK_DIS		0
+#define YTPHY_DTS_OUTPUT_CLK_25M		25000000
+#define YTPHY_DTS_OUTPUT_CLK_125M		125000000
+
 struct yt8521_priv {
 	/* combo_advertising is used for case of YT8521 in combo mode,
 	 * this means that yt8521 may work in utp or fiber mode which depends
@@ -640,6 +633,142 @@ static int yt8521_write_page(struct phy_device *phydev, int page)
 	return ytphy_modify_ext(phydev, YT8521_REG_SPACE_SELECT_REG, mask, set);
 };
 
+/**
+ * struct ytphy_cfg_reg_map - map a config value to a register value
+ * @cfg:	value in device configuration
+ * @reg:	value in the register
+ */
+struct ytphy_cfg_reg_map {
+	u32 cfg;
+	u32 reg;
+};
+
+static const struct ytphy_cfg_reg_map ytphy_rgmii_delays[] = {
+	/* for tx delay / rx delay with YT8521_CCR_RXC_DLY_EN is not set. */
+	{ 0,	YT8521_RC1R_RGMII_0_000_NS },
+	{ 150,	YT8521_RC1R_RGMII_0_150_NS },	/* default tx delay */
+	{ 300,	YT8521_RC1R_RGMII_0_300_NS },
+	{ 450,	YT8521_RC1R_RGMII_0_450_NS },
+	{ 600,	YT8521_RC1R_RGMII_0_600_NS },
+	{ 750,	YT8521_RC1R_RGMII_0_750_NS },
+	{ 900,	YT8521_RC1R_RGMII_0_900_NS },
+	{ 1050,	YT8521_RC1R_RGMII_1_050_NS },
+	{ 1200,	YT8521_RC1R_RGMII_1_200_NS },
+	{ 1350,	YT8521_RC1R_RGMII_1_350_NS },
+	{ 1500,	YT8521_RC1R_RGMII_1_500_NS },
+	{ 1650,	YT8521_RC1R_RGMII_1_650_NS },
+	{ 1800,	YT8521_RC1R_RGMII_1_800_NS },
+	{ 1950,	YT8521_RC1R_RGMII_1_950_NS },	/* default rx delay */
+	{ 2100,	YT8521_RC1R_RGMII_2_100_NS },
+	{ 2250,	YT8521_RC1R_RGMII_2_250_NS },
+
+	/* only for rx delay with YT8521_CCR_RXC_DLY_EN is set. */
+	{ 0    + YT8521_CCR_RXC_DLY_1_900_NS,	YT8521_RC1R_RGMII_0_000_NS },
+	{ 150  + YT8521_CCR_RXC_DLY_1_900_NS,	YT8521_RC1R_RGMII_0_150_NS },
+	{ 300  + YT8521_CCR_RXC_DLY_1_900_NS,	YT8521_RC1R_RGMII_0_300_NS },
+	{ 450  + YT8521_CCR_RXC_DLY_1_900_NS,	YT8521_RC1R_RGMII_0_450_NS },
+	{ 600  + YT8521_CCR_RXC_DLY_1_900_NS,	YT8521_RC1R_RGMII_0_600_NS },
+	{ 750  + YT8521_CCR_RXC_DLY_1_900_NS,	YT8521_RC1R_RGMII_0_750_NS },
+	{ 900  + YT8521_CCR_RXC_DLY_1_900_NS,	YT8521_RC1R_RGMII_0_900_NS },
+	{ 1050 + YT8521_CCR_RXC_DLY_1_900_NS,	YT8521_RC1R_RGMII_1_050_NS },
+	{ 1200 + YT8521_CCR_RXC_DLY_1_900_NS,	YT8521_RC1R_RGMII_1_200_NS },
+	{ 1350 + YT8521_CCR_RXC_DLY_1_900_NS,	YT8521_RC1R_RGMII_1_350_NS },
+	{ 1500 + YT8521_CCR_RXC_DLY_1_900_NS,	YT8521_RC1R_RGMII_1_500_NS },
+	{ 1650 + YT8521_CCR_RXC_DLY_1_900_NS,	YT8521_RC1R_RGMII_1_650_NS },
+	{ 1800 + YT8521_CCR_RXC_DLY_1_900_NS,	YT8521_RC1R_RGMII_1_800_NS },
+	{ 1950 + YT8521_CCR_RXC_DLY_1_900_NS,	YT8521_RC1R_RGMII_1_950_NS },
+	{ 2100 + YT8521_CCR_RXC_DLY_1_900_NS,	YT8521_RC1R_RGMII_2_100_NS },
+	{ 2250 + YT8521_CCR_RXC_DLY_1_900_NS,	YT8521_RC1R_RGMII_2_250_NS }
+};
+
+static u32 ytphy_get_delay_reg_value(struct phy_device *phydev,
+				     const char *prop_name,
+				     const struct ytphy_cfg_reg_map *tbl,
+				     int tb_size,
+				     u16 *rxc_dly_en,
+				     u32 dflt)
+{
+	struct device_node *node = phydev->mdio.dev.of_node;
+	int tb_size_half = tb_size / 2;
+	u32 val;
+	int i;
+
+	if (of_property_read_u32(node, prop_name, &val))
+		goto err_dts_val;
+
+	/* when rxc_dly_en is NULL, it is get the delay for tx, only half of
+	 * tb_size is valid.
+	 */
+	if (!rxc_dly_en)
+		tb_size = tb_size_half;
+
+	for (i = 0; i < tb_size; i++) {
+		if (tbl[i].cfg == val) {
+			if (rxc_dly_en && i < tb_size_half)
+				*rxc_dly_en = 0;
+			return tbl[i].reg;
+		}
+	}
+
+	phydev_warn(phydev, "Unsupported value %d for %s using default (%u)\n",
+		    val, prop_name, dflt);
+
+err_dts_val:
+	/* when rxc_dly_en is not NULL, it is get the delay for rx.
+	 * The rx default in dts and ytphy_rgmii_clk_delay_config is 1950 ps,
+	 * so YT8521_CCR_RXC_DLY_EN should not be set.
+	 */
+	if (rxc_dly_en)
+		*rxc_dly_en = 0;
+
+	return dflt;
+}
+
+static int ytphy_rgmii_clk_delay_config(struct phy_device *phydev)
+{
+	int tb_size = ARRAY_SIZE(ytphy_rgmii_delays);
+	u16 rxc_dly_en = YT8521_CCR_RXC_DLY_EN;
+	u32 rx_reg, tx_reg;
+	u16 mask, val = 0;
+	int ret;
+
+	rx_reg = ytphy_get_delay_reg_value(phydev, "rx-internal-delay-ps",
+					   ytphy_rgmii_delays, tb_size,
+					   &rxc_dly_en,
+					   YT8521_RC1R_RGMII_1_950_NS);
+	tx_reg = ytphy_get_delay_reg_value(phydev, "tx-internal-delay-ps",
+					   ytphy_rgmii_delays, tb_size, NULL,
+					   YT8521_RC1R_RGMII_0_150_NS);
+
+	switch (phydev->interface) {
+	case PHY_INTERFACE_MODE_RGMII:
+		rxc_dly_en = 0;
+		break;
+	case PHY_INTERFACE_MODE_RGMII_RXID:
+		val |= FIELD_PREP(YT8521_RC1R_RX_DELAY_MASK, rx_reg);
+		break;
+	case PHY_INTERFACE_MODE_RGMII_TXID:
+		rxc_dly_en = 0;
+		val |= FIELD_PREP(YT8521_RC1R_GE_TX_DELAY_MASK, tx_reg);
+		break;
+	case PHY_INTERFACE_MODE_RGMII_ID:
+		val |= FIELD_PREP(YT8521_RC1R_RX_DELAY_MASK, rx_reg) |
+		       FIELD_PREP(YT8521_RC1R_GE_TX_DELAY_MASK, tx_reg);
+		break;
+	default: /* do not support other modes */
+		return -EOPNOTSUPP;
+	}
+
+	ret = ytphy_modify_ext(phydev, YT8521_CHIP_CONFIG_REG,
+			       YT8521_CCR_RXC_DLY_EN, rxc_dly_en);
+	if (ret < 0)
+		return ret;
+
+	/* Generally, it is not necessary to adjust YT8521_RC1R_FE_TX_DELAY */
+	mask = YT8521_RC1R_RX_DELAY_MASK | YT8521_RC1R_GE_TX_DELAY_MASK;
+	return ytphy_modify_ext(phydev, YT8521_RGMII_CONFIG1_REG, mask, val);
+}
+
 /**
  * yt8521_probe() - read chip config then set suitable polling_mode
  * @phydev: a pointer to a &struct phy_device
@@ -648,9 +777,12 @@ static int yt8521_write_page(struct phy_device *phydev, int page)
  */
 static int yt8521_probe(struct phy_device *phydev)
 {
+	struct device_node *node = phydev->mdio.dev.of_node;
 	struct device *dev = &phydev->mdio.dev;
 	struct yt8521_priv *priv;
 	int chip_config;
+	u16 mask, val;
+	u32 freq;
 	int ret;
 
 	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
@@ -695,7 +827,45 @@ static int yt8521_probe(struct phy_device *phydev)
 			return ret;
 	}
 
-	return 0;
+	if (of_property_read_u32(node, "motorcomm,clk-out-frequency-hz", &freq))
+		freq = YTPHY_DTS_OUTPUT_CLK_DIS;
+
+	if (phydev->drv->phy_id == PHY_ID_YT8521) {
+		switch (freq) {
+		case YTPHY_DTS_OUTPUT_CLK_DIS:
+			mask = YT8521_SCR_SYNCE_ENABLE;
+			val = 0;
+			break;
+		case YTPHY_DTS_OUTPUT_CLK_25M:
+			mask = YT8521_SCR_SYNCE_ENABLE |
+			       YT8521_SCR_CLK_SRC_MASK |
+			       YT8521_SCR_CLK_FRE_SEL_125M;
+			val = YT8521_SCR_SYNCE_ENABLE |
+			      FIELD_PREP(YT8521_SCR_CLK_SRC_MASK,
+					 YT8521_SCR_CLK_SRC_REF_25M);
+			break;
+		case YTPHY_DTS_OUTPUT_CLK_125M:
+			mask = YT8521_SCR_SYNCE_ENABLE |
+			       YT8521_SCR_CLK_SRC_MASK |
+			       YT8521_SCR_CLK_FRE_SEL_125M;
+			val = YT8521_SCR_SYNCE_ENABLE |
+			      YT8521_SCR_CLK_FRE_SEL_125M |
+			      FIELD_PREP(YT8521_SCR_CLK_SRC_MASK,
+					 YT8521_SCR_CLK_SRC_PLL_125M);
+			break;
+		default:
+			phydev_warn(phydev, "Freq err:%u\n", freq);
+			return -EINVAL;
+		}
+	} else if (phydev->drv->phy_id == PHY_ID_YT8531S) {
+		return 0;
+	} else {
+		phydev_warn(phydev, "PHY id err\n");
+		return -EINVAL;
+	}
+
+	return ytphy_modify_ext_with_lock(phydev, YTPHY_SYNCE_CFG_REG, mask,
+					  val);
 }
 
 /**
@@ -1180,61 +1350,36 @@ static int yt8521_resume(struct phy_device *phydev)
  */
 static int yt8521_config_init(struct phy_device *phydev)
 {
+	struct device_node *node = phydev->mdio.dev.of_node;
 	int old_page;
 	int ret = 0;
-	u16 val;
 
 	old_page = phy_select_page(phydev, YT8521_RSSR_UTP_SPACE);
 	if (old_page < 0)
 		goto err_restore_page;
 
-	switch (phydev->interface) {
-	case PHY_INTERFACE_MODE_RGMII:
-		val = YT8521_RC1R_GE_TX_DELAY_DIS | YT8521_RC1R_FE_TX_DELAY_DIS;
-		val |= YT8521_RC1R_RX_DELAY_DIS;
-		break;
-	case PHY_INTERFACE_MODE_RGMII_RXID:
-		val = YT8521_RC1R_GE_TX_DELAY_DIS | YT8521_RC1R_FE_TX_DELAY_DIS;
-		val |= YT8521_RC1R_RX_DELAY_EN;
-		break;
-	case PHY_INTERFACE_MODE_RGMII_TXID:
-		val = YT8521_RC1R_GE_TX_DELAY_EN | YT8521_RC1R_FE_TX_DELAY_EN;
-		val |= YT8521_RC1R_RX_DELAY_DIS;
-		break;
-	case PHY_INTERFACE_MODE_RGMII_ID:
-		val = YT8521_RC1R_GE_TX_DELAY_EN | YT8521_RC1R_FE_TX_DELAY_EN;
-		val |= YT8521_RC1R_RX_DELAY_EN;
-		break;
-	case PHY_INTERFACE_MODE_SGMII:
-		break;
-	default: /* do not support other modes */
-		ret = -EOPNOTSUPP;
-		goto err_restore_page;
-	}
-
 	/* set rgmii delay mode */
 	if (phydev->interface != PHY_INTERFACE_MODE_SGMII) {
-		ret = ytphy_modify_ext(phydev, YT8521_RGMII_CONFIG1_REG,
-				       (YT8521_RC1R_RX_DELAY_MASK |
-				       YT8521_RC1R_FE_TX_DELAY_MASK |
-				       YT8521_RC1R_GE_TX_DELAY_MASK),
-				       val);
+		ret = ytphy_rgmii_clk_delay_config(phydev);
 		if (ret < 0)
 			goto err_restore_page;
 	}
 
-	/* disable auto sleep */
-	ret = ytphy_modify_ext(phydev, YT8521_EXTREG_SLEEP_CONTROL1_REG,
-			       YT8521_ESC1R_SLEEP_SW, 0);
-	if (ret < 0)
-		goto err_restore_page;
-
-	/* enable RXC clock when no wire plug */
-	ret = ytphy_modify_ext(phydev, YT8521_CLOCK_GATING_REG,
-			       YT8521_CGR_RX_CLK_EN, 0);
-	if (ret < 0)
-		goto err_restore_page;
+	if (of_property_read_bool(node, "motorcomm,auto-sleep-disabled")) {
+		/* disable auto sleep */
+		ret = ytphy_modify_ext(phydev, YT8521_EXTREG_SLEEP_CONTROL1_REG,
+				       YT8521_ESC1R_SLEEP_SW, 0);
+		if (ret < 0)
+			goto err_restore_page;
+	}
 
+	if (of_property_read_bool(node, "motorcomm,keep-pll-enabled")) {
+		/* enable RXC clock when no wire plug */
+		ret = ytphy_modify_ext(phydev, YT8521_CLOCK_GATING_REG,
+				       YT8521_CGR_RX_CLK_EN, 0);
+		if (ret < 0)
+			goto err_restore_page;
+	}
 err_restore_page:
 	return phy_restore_page(phydev, old_page, ret);
 }
-- 
2.34.1

