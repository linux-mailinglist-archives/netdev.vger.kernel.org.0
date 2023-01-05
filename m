Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6847865E619
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 08:30:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231256AbjAEHaS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 02:30:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231244AbjAEHaK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 02:30:10 -0500
Received: from out29-174.mail.aliyun.com (out29-174.mail.aliyun.com [115.124.29.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC12053738;
        Wed,  4 Jan 2023 23:30:07 -0800 (PST)
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.07436261|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_system_inform|0.00718991-0.0975541-0.895256;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047199;MF=frank.sae@motor-comm.com;NM=1;PH=DS;RN=17;RT=17;SR=0;TI=SMTPD_---.QktmAuq_1672903803;
Received: from sun-VirtualBox..(mailfrom:Frank.Sae@motor-comm.com fp:SMTPD_---.QktmAuq_1672903803)
          by smtp.aliyun-inc.com;
          Thu, 05 Jan 2023 15:30:05 +0800
From:   Frank <Frank.Sae@motor-comm.com>
To:     Peter Geis <pgwipeout@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc:     xiaogang.fan@motor-comm.com, fei.zhang@motor-comm.com,
        hua.sun@motor-comm.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Frank <Frank.Sae@motor-comm.com>,
        devicetree@vger.kernel.org
Subject: [PATCH net-next v1 2/3] net: phy: Add dts support for Motorcomm yt8521/yt8531s gigabit ethernet phy
Date:   Thu,  5 Jan 2023 15:30:23 +0800
Message-Id: <20230105073024.8390-3-Frank.Sae@motor-comm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230105073024.8390-1-Frank.Sae@motor-comm.com>
References: <20230105073024.8390-1-Frank.Sae@motor-comm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add dts support for yt8521 and yt8531s. This patch has
been tested on AM335x platform which has one YT8531S interface
card and passed all test cases.

Signed-off-by: Frank <Frank.Sae@motor-comm.com>
---
 drivers/net/phy/motorcomm.c | 517 ++++++++++++++++++++++++++++++------
 1 file changed, 434 insertions(+), 83 deletions(-)

diff --git a/drivers/net/phy/motorcomm.c b/drivers/net/phy/motorcomm.c
index 685190db72de..7ebcca374a67 100644
--- a/drivers/net/phy/motorcomm.c
+++ b/drivers/net/phy/motorcomm.c
@@ -10,10 +10,11 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/phy.h>
+#include <linux/of.h>
 
 #define PHY_ID_YT8511		0x0000010a
-#define PHY_ID_YT8521		0x0000011A
-#define PHY_ID_YT8531S		0x4F51E91A
+#define PHY_ID_YT8521		0x0000011a
+#define PHY_ID_YT8531S		0x4f51e91a
 
 /* YT8521/YT8531S Register Overview
  *	UTP Register space	|	FIBER Register space
@@ -144,6 +145,16 @@
 #define YT8521_ESC1R_SLEEP_SW			BIT(15)
 #define YT8521_ESC1R_PLLON_SLP			BIT(14)
 
+/* Phy Serdes analog cfg2 Register */
+#define YTPHY_SERDES_ANALOG_CFG2_REG		0xA1
+#define YTPHY_SAC2R_TX_AMPLITUDE_MASK		((0x7 << 13) | (0x7 << 1))
+#define YT8521_SAC2R_TX_AMPLITUDE_LOW		((0x7 << 13) | (0x0 << 1))
+#define YT8521_SAC2R_TX_AMPLITUDE_MIDDLE	((0x5 << 13) | (0x5 << 1))
+#define YT8521_SAC2R_TX_AMPLITUDE_HIGH		((0x3 << 13) | (0x6 << 1))
+#define YT8531S_SAC2R_TX_AMPLITUDE_LOW		((0x0 << 13) | (0x0 << 1))
+#define YT8531S_SAC2R_TX_AMPLITUDE_MIDDLE	((0x0 << 13) | (0x1 << 1))
+#define YT8531S_SAC2R_TX_AMPLITUDE_HIGH		((0x0 << 13) | (0x2 << 1))
+
 /* Phy fiber Link timer cfg2 Register */
 #define YT8521_LINK_TIMER_CFG2_REG		0xA5
 #define YT8521_LTCR_EN_AUTOSEN			BIT(15)
@@ -161,6 +172,7 @@
 
 #define YT8521_CHIP_CONFIG_REG			0xA001
 #define YT8521_CCR_SW_RST			BIT(15)
+#define YT8521_CCR_RXC_DLY_EN			BIT(8)
 
 #define YT8521_CCR_MODE_SEL_MASK		(BIT(2) | BIT(1) | BIT(0))
 #define YT8521_CCR_MODE_UTP_TO_RGMII		0
@@ -178,22 +190,27 @@
 #define YT8521_MODE_POLL			0x3
 
 #define YT8521_RGMII_CONFIG1_REG		0xA003
-
+#define YT8521_RC1R_TX_CLK_SEL_MASK		BIT(14)
+#define YT8521_RC1R_TX_CLK_SEL_ORIGINAL		(0x0 << 14)
+#define YT8521_RC1R_TX_CLK_SEL_INVERTED		(0x1 << 14)
 /* TX Gig-E Delay is bits 3:0, default 0x1
  * TX Fast-E Delay is bits 7:4, default 0xf
  * RX Delay is bits 13:10, default 0x0
  * Delay = 150ps * N
  * On = 2250ps, off = 0ps
  */
-#define YT8521_RC1R_RX_DELAY_MASK		(0xF << 10)
-#define YT8521_RC1R_RX_DELAY_EN			(0xF << 10)
-#define YT8521_RC1R_RX_DELAY_DIS		(0x0 << 10)
-#define YT8521_RC1R_FE_TX_DELAY_MASK		(0xF << 4)
-#define YT8521_RC1R_FE_TX_DELAY_EN		(0xF << 4)
-#define YT8521_RC1R_FE_TX_DELAY_DIS		(0x0 << 4)
-#define YT8521_RC1R_GE_TX_DELAY_MASK		(0xF << 0)
-#define YT8521_RC1R_GE_TX_DELAY_EN		(0xF << 0)
-#define YT8521_RC1R_GE_TX_DELAY_DIS		(0x0 << 0)
+#define YT8521_RC1R_GE_TX_DELAY_BIT		(0)
+#define YT8521_RC1R_FE_TX_DELAY_BIT		(4)
+#define YT8521_RC1R_RX_DELAY_BIT		(10)
+#define YT8521_RC1R_RX_DELAY_MASK		(0xF << YT8521_RC1R_RX_DELAY_BIT)
+#define YT8521_RC1R_RX_DELAY_EN			(0xF << YT8521_RC1R_RX_DELAY_BIT)
+#define YT8521_RC1R_RX_DELAY_DIS		(0x0 << YT8521_RC1R_RX_DELAY_BIT)
+#define YT8521_RC1R_FE_TX_DELAY_MASK		(0xF << YT8521_RC1R_FE_TX_DELAY_BIT)
+#define YT8521_RC1R_FE_TX_DELAY_EN		(0xF << YT8521_RC1R_FE_TX_DELAY_BIT)
+#define YT8521_RC1R_FE_TX_DELAY_DIS		(0x0 << YT8521_RC1R_FE_TX_DELAY_BIT)
+#define YT8521_RC1R_GE_TX_DELAY_MASK		(0xF << YT8521_RC1R_GE_TX_DELAY_BIT)
+#define YT8521_RC1R_GE_TX_DELAY_EN		(0xF << YT8521_RC1R_GE_TX_DELAY_BIT)
+#define YT8521_RC1R_GE_TX_DELAY_DIS		(0x0 << YT8521_RC1R_GE_TX_DELAY_BIT)
 
 #define YTPHY_MISC_CONFIG_REG			0xA006
 #define YTPHY_MCR_FIBER_SPEED_MASK		BIT(0)
@@ -222,11 +239,33 @@
  */
 #define YTPHY_WCR_TYPE_PULSE			BIT(0)
 
-#define YT8531S_SYNCE_CFG_REG			0xA012
-#define YT8531S_SCR_SYNCE_ENABLE		BIT(6)
+#define YTPHY_SYNCE_CFG_REG			0xA012
+#define YT8521_SCR_CLK_SRC_MASK			(BIT(2) | BIT(1))
+#define YT8521_SCR_CLK_SRC_PLL_125M		(0x0 << 1)
+#define YT8521_SCR_CLK_SRC_REF_25M		(0x3 << 1)
+#define YT8521_SCR_SYNCE_ENABLE			BIT(5)
+#define YT8521_SCR_CLK_FRE_SEL_MASK		BIT(3)
+#define YT8521_SCR_CLK_FRE_SEL_125M		(0x1 << 3)
+#define YT8521_SCR_CLK_FRE_SEL_25M		(0x0 << 3)
+#define YT8531_SCR_CLK_SRC_MASK			(BIT(3) | BIT(2) | BIT(1))
+#define YT8531_SCR_CLK_SRC_PLL_125M		(0x0 << 1)
+#define YT8531_SCR_CLK_SRC_REF_25M		(0x4 << 1)
+#define YT8531_SCR_SYNCE_ENABLE			BIT(6)
+#define YT8531_SCR_CLK_FRE_SEL_MASK		BIT(4)
+#define YT8531_SCR_CLK_FRE_SEL_125M		(0x1 << 4)
+#define YT8531_SCR_CLK_FRE_SEL_25M		(0x0 << 4)
 
 /* Extended Register  end */
 
+#define YTPHY_DTS_MAX_TX_AMPLITUDE		0x2
+#define YTPHY_DTS_MAX_DELAY_VAL			2250
+#define YTPHY_DTS_STEP_DELAY_VAL		150
+#define YTPHY_DTS_INVAL_VAL			0xFF
+
+#define YTPHY_DTS_OUTPUT_CLK_DIS		0
+#define YTPHY_DTS_OUTPUT_CLK_25M		25000000
+#define YTPHY_DTS_OUTPUT_CLK_125M		125000000
+
 struct yt8521_priv {
 	/* combo_advertising is used for case of YT8521 in combo mode,
 	 * this means that yt8521 may work in utp or fiber mode which depends
@@ -243,6 +282,30 @@ struct yt8521_priv {
 	 * YT8521_RSSR_TO_BE_ARBITRATED
 	 */
 	u8 reg_page;
+
+	/* The following parameters are from dts */
+	/* rx delay = rx_delay_basic + rx_delay_additional
+	 * basic delay is ~2ns, 0 = off, 1 = on
+	 * rx_delay_additional,delay time = 150ps * val
+	 */
+	u8 rx_delay_basic;
+	u8 rx_delay_additional;
+
+	/* tx_delay_ge is tx_delay for 1000Mbps
+	 * tx_delay_fe is tx_delay for 100Mbps or 10Mbps
+	 * delay time = 150ps * val
+	 */
+	u8 tx_delay_ge;
+	u8 tx_delay_fe;
+	u8 sds_tx_amplitude;
+	bool keep_pll_enabled;
+	bool auto_sleep_disabled;
+	bool clock_ouput;	/* output clock ctl: 0=off, 1=on */
+	bool clock_freq_125M;	/* output clock freq selcect: 0=25M, 1=125M */
+	bool tx_clk_adj_enabled;/* tx clk adj ctl: 0=off, 1=on */
+	bool tx_clk_10_inverted;
+	bool tx_clk_100_inverted;
+	bool tx_clk_1000_inverted;
 };
 
 /**
@@ -593,6 +656,325 @@ static int yt8521_write_page(struct phy_device *phydev, int page)
 	return ytphy_modify_ext(phydev, YT8521_REG_SPACE_SELECT_REG, mask, set);
 };
 
+static int ytphy_parse_dt(struct phy_device *phydev)
+{
+	struct device_node *node = phydev->mdio.dev.of_node;
+	struct yt8521_priv *priv = phydev->priv;
+	u32 freq, val;
+	int ret;
+
+	priv->rx_delay_additional = YTPHY_DTS_INVAL_VAL;
+	priv->sds_tx_amplitude = YTPHY_DTS_INVAL_VAL;
+	priv->rx_delay_basic = YTPHY_DTS_INVAL_VAL;
+	priv->tx_delay_ge = YTPHY_DTS_INVAL_VAL;
+	priv->tx_delay_fe = YTPHY_DTS_INVAL_VAL;
+
+	if (!IS_ENABLED(CONFIG_OF_MDIO)) {
+		priv->auto_sleep_disabled = true;
+		priv->keep_pll_enabled = true;
+		return 0;
+	}
+
+	ret = of_property_read_u32(node, "motorcomm,clk-out-frequency", &freq);
+	if (ret < 0)
+		freq = YTPHY_DTS_OUTPUT_CLK_DIS;/* default value as dts*/
+
+	switch (freq) {
+	case YTPHY_DTS_OUTPUT_CLK_DIS:
+		priv->clock_ouput = false;
+		break;
+	case YTPHY_DTS_OUTPUT_CLK_25M:
+		priv->clock_freq_125M = false;
+		priv->clock_ouput = true;
+		break;
+	case YTPHY_DTS_OUTPUT_CLK_125M:
+		priv->clock_freq_125M = true;
+		priv->clock_ouput = true;
+		break;
+	default:
+		phydev_err(phydev, "invalid motorcomm,clk-out-frequency\n");
+		return -EINVAL;
+	}
+
+	if (!of_property_read_u32(node, "motorcomm,rx-delay-basic", &val)) {
+		if (val > 1) {
+			phydev_err(phydev,
+				   "invalid motorcomm,rx-delay-basic\n");
+			return -EINVAL;
+		}
+		priv->rx_delay_basic = val;
+	}
+
+	if (!of_property_read_u32(node, "motorcomm,rx-delay-additional-ps", &val)) {
+		if (val > YTPHY_DTS_MAX_DELAY_VAL) {
+			phydev_err(phydev, "invalid motorcomm,rx-delay-additional-ps\n");
+			return -EINVAL;
+		}
+		if (val)
+			val /= YTPHY_DTS_STEP_DELAY_VAL;
+		priv->rx_delay_additional = val;
+	}
+
+	if (!of_property_read_u32(node, "motorcomm,tx-delay-fe-ps", &val)) {
+		if (val > YTPHY_DTS_MAX_DELAY_VAL) {
+			phydev_err(phydev,
+				   "invalid motorcomm,tx-delay-fe-ps\n");
+			return -EINVAL;
+		}
+		if (val)
+			val /= YTPHY_DTS_STEP_DELAY_VAL;
+		priv->tx_delay_fe = val;
+	}
+
+	if (!of_property_read_u32(node, "motorcomm,tx-delay-ge-ps", &val)) {
+		if (val > YTPHY_DTS_MAX_DELAY_VAL) {
+			phydev_err(phydev,
+				   "invalid motorcomm,tx-delay-ge-ps\n");
+			return -EINVAL;
+		}
+		if (val)
+			val /= YTPHY_DTS_STEP_DELAY_VAL;
+		priv->tx_delay_ge = val;
+	}
+
+	if (of_property_read_bool(node, "motorcomm,keep-pll-enabled"))
+		priv->keep_pll_enabled = true;
+
+	if (of_property_read_bool(node, "motorcomm,auto-sleep-disabled"))
+		priv->auto_sleep_disabled = true;
+
+	if (of_property_read_bool(node, "motorcomm,tx-clk-adj-enabled"))
+		priv->tx_clk_adj_enabled = true;
+	if (priv->tx_clk_adj_enabled) {
+		if (of_property_read_bool(node, "motorcomm,tx-clk-10-inverted"))
+			priv->tx_clk_10_inverted = true;
+		if (of_property_read_bool(node, "motorcomm,tx-clk-100-inverted"))
+			priv->tx_clk_100_inverted = true;
+		if (of_property_read_bool(node, "motorcomm,tx-clk-1000-inverted"))
+			priv->tx_clk_1000_inverted = true;
+	}
+
+	if (!of_property_read_u32(node, "motorcomm,sds-tx-amplitude", &val)) {
+		if (val > YTPHY_DTS_MAX_TX_AMPLITUDE) {
+			phydev_err(phydev,
+				   "invalid motorcomm,sds-tx-amplitude\n");
+			return -EINVAL;
+		}
+		priv->sds_tx_amplitude = val;
+	}
+
+	return 0;
+}
+
+static int ytphy_clk_out_config(struct phy_device *phydev)
+{
+	struct yt8521_priv *priv = phydev->priv;
+	u16 set = 0;
+	u16 mask;
+
+	switch (phydev->drv->phy_id) {
+	case PHY_ID_YT8511:
+		/* YT8511 will be supported later */
+		return -EOPNOTSUPP;
+	case PHY_ID_YT8521:
+		mask = YT8521_SCR_SYNCE_ENABLE;
+		if (priv->clock_ouput) {
+			mask |= YT8521_SCR_CLK_SRC_MASK;
+			mask |= YT8521_SCR_CLK_FRE_SEL_MASK;
+			set |= YT8521_SCR_SYNCE_ENABLE;
+			if (priv->clock_freq_125M) {
+				set |= YT8521_SCR_CLK_FRE_SEL_125M;
+				set |= YT8521_SCR_CLK_SRC_PLL_125M;
+			} else {
+				set |= YT8521_SCR_CLK_FRE_SEL_25M;
+				set |= YT8521_SCR_CLK_SRC_REF_25M;
+			}
+		}
+		break;
+	case PHY_ID_YT8531:
+	case PHY_ID_YT8531S:
+		mask = YT8531_SCR_SYNCE_ENABLE;
+		if (priv->clock_ouput) {
+			mask |= YT8531_SCR_CLK_SRC_MASK;
+			mask |= YT8531_SCR_CLK_FRE_SEL_MASK;
+			set |= YT8531_SCR_SYNCE_ENABLE;
+			if (priv->clock_freq_125M) {
+				set |= YT8531_SCR_CLK_FRE_SEL_125M;
+				set |= YT8531_SCR_CLK_SRC_PLL_125M;
+			} else {
+				set |= YT8531_SCR_CLK_FRE_SEL_25M;
+				set |= YT8531_SCR_CLK_SRC_REF_25M;
+			}
+		}
+		break;
+	default:
+		phydev_err(phydev, "invalid phy id\n");
+		return -EINVAL;
+	}
+
+	return ytphy_modify_ext(phydev, YTPHY_SYNCE_CFG_REG, mask, set);
+}
+
+static int ytphy_serdes_tx_amplitude_config(struct phy_device *phydev)
+{
+	u16 yt8531s_tx_amplitude[] = { YT8531S_SAC2R_TX_AMPLITUDE_LOW,
+				       YT8531S_SAC2R_TX_AMPLITUDE_MIDDLE,
+				       YT8531S_SAC2R_TX_AMPLITUDE_HIGH };
+	u16 yt8521_tx_amplitude[] = { YT8521_SAC2R_TX_AMPLITUDE_LOW,
+				      YT8521_SAC2R_TX_AMPLITUDE_MIDDLE,
+				      YT8521_SAC2R_TX_AMPLITUDE_HIGH };
+	struct yt8521_priv *priv = phydev->priv;
+	u16 tx_amplitude;
+
+	if (priv->sds_tx_amplitude == YTPHY_DTS_INVAL_VAL)
+		/* don't config Serdes tx amplitude.*/
+		return 0;
+
+	switch (phydev->drv->phy_id) {
+	case PHY_ID_YT8511:
+	case PHY_ID_YT8531:
+		/* YT8511 and YT8531 not support this function.*/
+		return -EOPNOTSUPP;
+	case PHY_ID_YT8521:
+		tx_amplitude = yt8521_tx_amplitude[priv->sds_tx_amplitude];
+		break;
+	case PHY_ID_YT8531S:
+		tx_amplitude = yt8531s_tx_amplitude[priv->sds_tx_amplitude];
+		break;
+	default:
+		phydev_err(phydev, "invalid phy id\n");
+		return -EINVAL;
+	}
+
+	return ytphy_modify_ext(phydev, YTPHY_SERDES_ANALOG_CFG2_REG,
+				YTPHY_SAC2R_TX_AMPLITUDE_MASK, tx_amplitude);
+}
+
+static int ytphy_rgmii_clk_delay_config(struct phy_device *phydev)
+{
+	struct yt8521_priv *priv = phydev->priv;
+	u16 mask = 0;
+	u16 val = 0;
+	int ret;
+
+	/* rx delay basic controlled by dts.*/
+	if (priv->rx_delay_basic != YTPHY_DTS_INVAL_VAL) {
+		if (priv->rx_delay_basic)
+			val = YT8521_CCR_RXC_DLY_EN;
+		ret = ytphy_modify_ext(phydev, YT8521_CHIP_CONFIG_REG,
+				       YT8521_CCR_RXC_DLY_EN, val);
+		if (ret < 0)
+			return ret;
+	}
+
+	val = 0;
+	/* If rx_delay_additional and tx_delay_* are all not be seted in dts,
+	 * then used the fixed *_DELAY_DIS or *_DELAY_EN. Otherwise, use the
+	 * value set by rx_delay_additional, tx_delay_ge and tx_delay_fe.
+	 */
+	if ((priv->rx_delay_additional & priv->tx_delay_ge & priv->tx_delay_fe)
+	   == YTPHY_DTS_INVAL_VAL) {
+		switch (phydev->interface) {
+		case PHY_INTERFACE_MODE_RGMII:
+			val |= YT8521_RC1R_GE_TX_DELAY_DIS;
+			val |= YT8521_RC1R_FE_TX_DELAY_DIS;
+			val |= YT8521_RC1R_RX_DELAY_DIS;
+			break;
+		case PHY_INTERFACE_MODE_RGMII_RXID:
+			val |= YT8521_RC1R_GE_TX_DELAY_DIS;
+			val |= YT8521_RC1R_FE_TX_DELAY_DIS;
+			val |= YT8521_RC1R_RX_DELAY_EN;
+			break;
+		case PHY_INTERFACE_MODE_RGMII_TXID:
+			val |= YT8521_RC1R_GE_TX_DELAY_EN;
+			val |= YT8521_RC1R_FE_TX_DELAY_EN;
+			val |= YT8521_RC1R_RX_DELAY_DIS;
+			break;
+		case PHY_INTERFACE_MODE_RGMII_ID:
+			val |= YT8521_RC1R_GE_TX_DELAY_EN;
+			val |= YT8521_RC1R_FE_TX_DELAY_EN;
+			val |= YT8521_RC1R_RX_DELAY_EN;
+			break;
+		default: /* do not support other modes */
+			return -EOPNOTSUPP;
+		}
+		mask = YT8521_RC1R_RX_DELAY_MASK | YT8521_RC1R_FE_TX_DELAY_MASK
+		       | YT8521_RC1R_GE_TX_DELAY_MASK;
+	} else {
+		switch (phydev->interface) {
+		case PHY_INTERFACE_MODE_RGMII:
+		case PHY_INTERFACE_MODE_RGMII_RXID:
+		case PHY_INTERFACE_MODE_RGMII_TXID:
+		case PHY_INTERFACE_MODE_RGMII_ID:
+			if (priv->rx_delay_additional != YTPHY_DTS_INVAL_VAL) {
+				mask |= YT8521_RC1R_RX_DELAY_MASK;
+				val |= (priv->rx_delay_additional) << YT8521_RC1R_RX_DELAY_BIT;
+			}
+			if (priv->tx_delay_fe != YTPHY_DTS_INVAL_VAL) {
+				mask |= YT8521_RC1R_FE_TX_DELAY_MASK;
+				val |= (priv->tx_delay_fe) << YT8521_RC1R_FE_TX_DELAY_BIT;
+			}
+			if (priv->tx_delay_ge != YTPHY_DTS_INVAL_VAL) {
+				mask |= YT8521_RC1R_GE_TX_DELAY_MASK;
+				val |= (priv->tx_delay_ge) << YT8521_RC1R_GE_TX_DELAY_BIT;
+			}
+			break;
+		default: /* do not support other modes */
+			return -EOPNOTSUPP;
+		}
+	}
+
+	return ytphy_modify_ext(phydev, YT8521_RGMII_CONFIG1_REG, mask, val);
+}
+
+static int ytphy_clk_delay_config(struct phy_device *phydev)
+{
+	switch (phydev->drv->phy_id) {
+	case PHY_ID_YT8511:
+		/* YT8511 will be supported later */
+		return -EOPNOTSUPP;
+	case PHY_ID_YT8521:
+	case PHY_ID_YT8531S:
+		/* YT8521 and YT8531S support SGMII mode, but don't need
+		 * delay.
+		 */
+		if (phydev->interface == PHY_INTERFACE_MODE_SGMII)
+			return 0;
+
+		return ytphy_rgmii_clk_delay_config(phydev);
+	case PHY_ID_YT8531:
+		/* YT8531 don't support SGMII mode. */
+		return ytphy_rgmii_clk_delay_config(phydev);
+	default:
+		phydev_err(phydev, "invalid phy id\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int ytphy_probe_helper(struct phy_device *phydev)
+{
+	struct device *dev = &phydev->mdio.dev;
+	struct yt8521_priv *priv;
+	int ret;
+
+	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	phydev->priv = priv;
+
+	ret = ytphy_parse_dt(phydev);
+	if (ret < 0)
+		return ret;
+
+	phy_lock_mdio_bus(phydev);
+	ret = ytphy_clk_out_config(phydev);
+	phy_unlock_mdio_bus(phydev);
+	return ret;
+}
+
 /**
  * yt8521_probe() - read chip config then set suitable polling_mode
  * @phydev: a pointer to a &struct phy_device
@@ -601,16 +983,15 @@ static int yt8521_write_page(struct phy_device *phydev, int page)
  */
 static int yt8521_probe(struct phy_device *phydev)
 {
-	struct device *dev = &phydev->mdio.dev;
 	struct yt8521_priv *priv;
 	int chip_config;
 	int ret;
 
-	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
-	if (!priv)
-		return -ENOMEM;
+	ret = ytphy_probe_helper(phydev);
+	if (ret < 0)
+		return ret;
 
-	phydev->priv = priv;
+	priv = phydev->priv;
 
 	chip_config = ytphy_read_ext_with_lock(phydev, YT8521_CHIP_CONFIG_REG);
 	if (chip_config < 0)
@@ -651,26 +1032,6 @@ static int yt8521_probe(struct phy_device *phydev)
 	return 0;
 }
 
-/**
- * yt8531s_probe() - read chip config then set suitable polling_mode
- * @phydev: a pointer to a &struct phy_device
- *
- * returns 0 or negative errno code
- */
-static int yt8531s_probe(struct phy_device *phydev)
-{
-	int ret;
-
-	/* Disable SyncE clock output by default */
-	ret = ytphy_modify_ext_with_lock(phydev, YT8531S_SYNCE_CFG_REG,
-					 YT8531S_SCR_SYNCE_ENABLE, 0);
-	if (ret < 0)
-		return ret;
-
-	/* same as yt8521_probe */
-	return yt8521_probe(phydev);
-}
-
 /**
  * ytphy_utp_read_lpa() - read LPA then setup lp_advertising for utp
  * @phydev: a pointer to a &struct phy_device
@@ -1125,6 +1486,34 @@ static int yt8521_resume(struct phy_device *phydev)
 	return yt8521_modify_utp_fiber_bmcr(phydev, BMCR_PDOWN, 0);
 }
 
+static int ytphy_config_init_helper(struct phy_device *phydev)
+{
+	struct yt8521_priv *priv = phydev->priv;
+	int ret;
+
+	ret = ytphy_clk_delay_config(phydev);
+	if (ret < 0)
+		return ret;
+
+	/* disable auto sleep */
+	if (priv->auto_sleep_disabled) {
+		ret = ytphy_modify_ext(phydev, YT8521_EXTREG_SLEEP_CONTROL1_REG,
+				       YT8521_ESC1R_SLEEP_SW, 0);
+		if (ret < 0)
+			return ret;
+	}
+
+	/* enable RXC clock when no wire plug */
+	if (priv->keep_pll_enabled) {
+		ret = ytphy_modify_ext(phydev, YT8521_CLOCK_GATING_REG,
+				       YT8521_CGR_RX_CLK_EN, 0);
+		if (ret < 0)
+			return ret;
+	}
+
+	return 0;
+}
+
 /**
  * yt8521_config_init() - called to initialize the PHY
  * @phydev: a pointer to a &struct phy_device
@@ -1135,59 +1524,21 @@ static int yt8521_config_init(struct phy_device *phydev)
 {
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
-	/* set rgmii delay mode */
-	if (phydev->interface != PHY_INTERFACE_MODE_SGMII) {
-		ret = ytphy_modify_ext(phydev, YT8521_RGMII_CONFIG1_REG,
-				       (YT8521_RC1R_RX_DELAY_MASK |
-				       YT8521_RC1R_FE_TX_DELAY_MASK |
-				       YT8521_RC1R_GE_TX_DELAY_MASK),
-				       val);
-		if (ret < 0)
-			goto err_restore_page;
-	}
-
-	/* disable auto sleep */
-	ret = ytphy_modify_ext(phydev, YT8521_EXTREG_SLEEP_CONTROL1_REG,
-			       YT8521_ESC1R_SLEEP_SW, 0);
+	ret = ytphy_config_init_helper(phydev);
 	if (ret < 0)
 		goto err_restore_page;
 
-	/* enable RXC clock when no wire plug */
-	ret = ytphy_modify_ext(phydev, YT8521_CLOCK_GATING_REG,
-			       YT8521_CGR_RX_CLK_EN, 0);
+	ret = yt8521_write_page(phydev, YT8521_RSSR_FIBER_SPACE);
 	if (ret < 0)
 		goto err_restore_page;
 
+	ret =  ytphy_serdes_tx_amplitude_config(phydev);
+
 err_restore_page:
 	return phy_restore_page(phydev, old_page, ret);
 }
@@ -1778,7 +2129,7 @@ static struct phy_driver motorcomm_phy_drvs[] = {
 		PHY_ID_MATCH_EXACT(PHY_ID_YT8531S),
 		.name		= "YT8531S Gigabit Ethernet",
 		.get_features	= yt8521_get_features,
-		.probe		= yt8531s_probe,
+		.probe		= yt8521_probe,
 		.read_page	= yt8521_read_page,
 		.write_page	= yt8521_write_page,
 		.get_wol	= ytphy_get_wol,
@@ -1804,7 +2155,7 @@ static const struct mdio_device_id __maybe_unused motorcomm_tbl[] = {
 	{ PHY_ID_MATCH_EXACT(PHY_ID_YT8511) },
 	{ PHY_ID_MATCH_EXACT(PHY_ID_YT8521) },
 	{ PHY_ID_MATCH_EXACT(PHY_ID_YT8531S) },
-	{ /* sentinal */ }
+	{ /* sentinel */ }
 };
 
 MODULE_DEVICE_TABLE(mdio, motorcomm_tbl);
-- 
2.34.1

