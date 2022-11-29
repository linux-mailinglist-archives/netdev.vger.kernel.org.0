Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E5B263BAC4
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 08:33:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229612AbiK2Hdd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 02:33:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiK2Hdc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 02:33:32 -0500
X-Greylist: delayed 345 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 28 Nov 2022 23:33:30 PST
Received: from mail-m121145.qiye.163.com (mail-m121145.qiye.163.com [115.236.121.145])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AA08429BB
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 23:33:30 -0800 (PST)
Received: from amadeus-VLT-WX0.lan (unknown [112.48.80.27])
        by mail-m121145.qiye.163.com (Hmail) with ESMTPA id 69CF9800292;
        Tue, 29 Nov 2022 15:27:39 +0800 (CST)
From:   Chukun Pan <amadeus@jmu.edu.cn>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Wu <david.wu@rock-chips.com>,
        Rob Herring <robh+dt@kernel.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Chukun Pan <amadeus@jmu.edu.cn>
Subject: [PATCH 2/2] ethernet: stmicro: stmmac: Add SGMII/QSGMII support for RK3568
Date:   Tue, 29 Nov 2022 15:27:14 +0800
Message-Id: <20221129072714.22880-2-amadeus@jmu.edu.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221129072714.22880-1-amadeus@jmu.edu.cn>
References: <20221129072714.22880-1-amadeus@jmu.edu.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
        tZV1koWUFITzdXWS1ZQUlXWQ8JGhUIEh9ZQVlCQhlNVhhJS01ISEIYH0tNSFUTARMWGhIXJBQOD1
        lXWRgSC1lBWUpKSVVPQ1VDS1VJTFlXWRYaDxIVHRRZQVlPS0hVSklLQ05NVUpLS1VLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6PEk6LSo6Kj0eChw8DjofCzdJ
        LwIaCQ5VSlVKTU1CTEtNQ01LQ0pPVTMWGhIXVRoWGh8eDgg7ERYOVR4fDlUYFUVZV1kSC1lBWUpK
        SVVPQ1VDS1VJTFlXWQgBWUFKSEpMTTcG
X-HM-Tid: 0a84c248c6b5b03akuuu69cf9800292
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Wu <david.wu@rock-chips.com>

The gmac of RK3568 supports RGMII/SGMII/QSGMII interface.
This patch adds the remaining SGMII/QSGMII support.

Run-tested-on: Ariaboard Photonicat (GMAC0 SGMII)

Signed-off-by: David Wu <david.wu@rock-chips.com>
[rebase, rewrite commit message]
Signed-off-by: Chukun Pan <amadeus@jmu.edu.cn>
---
 .../net/ethernet/stmicro/stmmac/dwmac-rk.c    | 210 +++++++++++++++++-
 1 file changed, 207 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
index 6656d76b6766..c65cb92bb630 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
@@ -11,6 +11,7 @@
 #include <linux/bitops.h>
 #include <linux/clk.h>
 #include <linux/phy.h>
+#include <linux/phy/phy.h>
 #include <linux/of_net.h>
 #include <linux/gpio.h>
 #include <linux/module.h>
@@ -30,6 +31,8 @@ struct rk_gmac_ops {
 	void (*set_to_rgmii)(struct rk_priv_data *bsp_priv,
 			     int tx_delay, int rx_delay);
 	void (*set_to_rmii)(struct rk_priv_data *bsp_priv);
+	void (*set_to_sgmii)(struct rk_priv_data *bsp_priv);
+	void (*set_to_qsgmii)(struct rk_priv_data *bsp_priv);
 	void (*set_rgmii_speed)(struct rk_priv_data *bsp_priv, int speed);
 	void (*set_rmii_speed)(struct rk_priv_data *bsp_priv, int speed);
 	void (*set_clock_selection)(struct rk_priv_data *bsp_priv, bool input,
@@ -60,6 +63,7 @@ struct rk_priv_data {
 	struct clk *clk_mac_speed;
 	struct clk *aclk_mac;
 	struct clk *pclk_mac;
+	struct clk *pclk_xpcs;
 	struct clk *clk_phy;
 
 	struct reset_control *phy_reset;
@@ -69,6 +73,7 @@ struct rk_priv_data {
 
 	struct regmap *grf;
 	struct regmap *php_grf;
+	struct regmap *xpcs;
 };
 
 #define HIWORD_UPDATE(val, mask, shift) \
@@ -81,6 +86,128 @@ struct rk_priv_data {
 	(((tx) ? soc##_GMAC_TXCLK_DLY_ENABLE : soc##_GMAC_TXCLK_DLY_DISABLE) | \
 	 ((rx) ? soc##_GMAC_RXCLK_DLY_ENABLE : soc##_GMAC_RXCLK_DLY_DISABLE))
 
+/* XPCS */
+#define XPCS_APB_INCREMENT		(0x4)
+#define XPCS_APB_MASK			GENMASK_ULL(20, 0)
+
+#define SR_MII_BASE			(0x1F0000)
+#define SR_MII1_BASE			(0x1A0000)
+
+#define VR_MII_DIG_CTRL1		(0x8000)
+#define VR_MII_AN_CTRL			(0x8001)
+#define VR_MII_AN_INTR_STS		(0x8002)
+#define VR_MII_LINK_TIMER_CTRL		(0x800A)
+
+#define SR_MII_CTRL_AN_ENABLE		\
+	(BMCR_ANENABLE | BMCR_ANRESTART | BMCR_FULLDPLX | BMCR_SPEED1000)
+#define MII_MAC_AUTO_SW			(0x0200)
+#define PCS_MODE_OFFSET			(0x1)
+#define MII_AN_INTR_EN			(0x1)
+#define PCS_SGMII_MODE			(0x2 << PCS_MODE_OFFSET)
+#define PCS_QSGMII_MODE			(0X3 << PCS_MODE_OFFSET)
+#define VR_MII_CTRL_SGMII_AN_EN		(PCS_SGMII_MODE | MII_AN_INTR_EN)
+#define VR_MII_CTRL_QSGMII_AN_EN	(PCS_QSGMII_MODE | MII_AN_INTR_EN)
+
+#define SR_MII_OFFSET(_x) ({		\
+	typeof(_x) (x) = (_x); \
+	(((x) == 0) ? SR_MII_BASE : (SR_MII1_BASE + ((x) - 1) * 0x10000)); \
+}) \
+
+static int xpcs_read(void *priv, int reg)
+{
+	struct rk_priv_data *bsp_priv = (struct rk_priv_data *)priv;
+	int ret, val;
+
+	ret = regmap_read(bsp_priv->xpcs,
+			  (u32)(reg * XPCS_APB_INCREMENT) & XPCS_APB_MASK,
+			  &val);
+	if (ret)
+		return ret;
+
+	return val;
+}
+
+static int xpcs_write(void *priv, int reg, u16 value)
+{
+	struct rk_priv_data *bsp_priv = (struct rk_priv_data *)priv;
+
+	return regmap_write(bsp_priv->xpcs,
+			    (reg * XPCS_APB_INCREMENT) & XPCS_APB_MASK, value);
+}
+
+static int xpcs_poll_reset(struct rk_priv_data *bsp_priv, int dev)
+{
+	/* Poll until the reset bit clears (50ms per retry == 0.6 sec) */
+	unsigned int retries = 12;
+	int ret;
+
+	do {
+		msleep(50);
+		ret = xpcs_read(bsp_priv, SR_MII_OFFSET(dev) + MDIO_CTRL1);
+		if (ret < 0)
+			return ret;
+	} while (ret & MDIO_CTRL1_RESET && --retries);
+
+	return (ret & MDIO_CTRL1_RESET) ? -ETIMEDOUT : 0;
+}
+
+static int xpcs_soft_reset(struct rk_priv_data *bsp_priv, int dev)
+{
+	int ret;
+
+	ret = xpcs_write(bsp_priv, SR_MII_OFFSET(dev) + MDIO_CTRL1,
+			 MDIO_CTRL1_RESET);
+	if (ret < 0)
+		return ret;
+
+	return xpcs_poll_reset(bsp_priv, dev);
+}
+
+static int xpcs_setup(struct rk_priv_data *bsp_priv, int mode)
+{
+	int ret, i, idx = bsp_priv->id;
+	u32 val;
+
+	if (mode == PHY_INTERFACE_MODE_QSGMII && idx > 0)
+		return 0;
+
+	ret = xpcs_soft_reset(bsp_priv, idx);
+	if (ret) {
+		dev_err(&bsp_priv->pdev->dev, "xpcs_soft_reset fail %d\n", ret);
+		return ret;
+	}
+
+	xpcs_write(bsp_priv, SR_MII_OFFSET(0) + VR_MII_AN_INTR_STS, 0x0);
+	xpcs_write(bsp_priv, SR_MII_OFFSET(0) + VR_MII_LINK_TIMER_CTRL, 0x1);
+
+	if (mode == PHY_INTERFACE_MODE_SGMII)
+		xpcs_write(bsp_priv, SR_MII_OFFSET(0) + VR_MII_AN_CTRL,
+			   VR_MII_CTRL_SGMII_AN_EN);
+	else
+		xpcs_write(bsp_priv, SR_MII_OFFSET(0) + VR_MII_AN_CTRL,
+			   VR_MII_CTRL_QSGMII_AN_EN);
+
+	if (mode == PHY_INTERFACE_MODE_QSGMII) {
+		for (i = 0; i < 4; i++) {
+			val = xpcs_read(bsp_priv,
+					SR_MII_OFFSET(i) + VR_MII_DIG_CTRL1);
+			xpcs_write(bsp_priv,
+				   SR_MII_OFFSET(i) + VR_MII_DIG_CTRL1,
+				   val | MII_MAC_AUTO_SW);
+			xpcs_write(bsp_priv, SR_MII_OFFSET(i) + MII_BMCR,
+				   SR_MII_CTRL_AN_ENABLE);
+		}
+	} else {
+		val = xpcs_read(bsp_priv, SR_MII_OFFSET(idx) + VR_MII_DIG_CTRL1);
+		xpcs_write(bsp_priv, SR_MII_OFFSET(idx) + VR_MII_DIG_CTRL1,
+			   val | MII_MAC_AUTO_SW);
+		xpcs_write(bsp_priv, SR_MII_OFFSET(idx) + MII_BMCR,
+			   SR_MII_CTRL_AN_ENABLE);
+	}
+
+	return ret;
+}
+
 #define PX30_GRF_GMAC_CON1		0x0904
 
 /* PX30_GRF_GMAC_CON1 */
@@ -1008,6 +1135,7 @@ static const struct rk_gmac_ops rk3399_ops = {
 #define RK3568_GRF_GMAC1_CON1		0x038c
 
 /* RK3568_GRF_GMAC0_CON1 && RK3568_GRF_GMAC1_CON1 */
+#define RK3568_GMAC_GMII_MODE			GRF_BIT(7)
 #define RK3568_GMAC_PHY_INTF_SEL_RGMII	\
 		(GRF_BIT(4) | GRF_CLR_BIT(5) | GRF_CLR_BIT(6))
 #define RK3568_GMAC_PHY_INTF_SEL_RMII	\
@@ -1023,6 +1151,46 @@ static const struct rk_gmac_ops rk3399_ops = {
 #define RK3568_GMAC_CLK_RX_DL_CFG(val)	HIWORD_UPDATE(val, 0x7F, 8)
 #define RK3568_GMAC_CLK_TX_DL_CFG(val)	HIWORD_UPDATE(val, 0x7F, 0)
 
+#define RK3568_PIPE_GRF_XPCS_CON0	0X0040
+
+#define RK3568_PIPE_GRF_XPCS_QGMII_MAC_SEL	GRF_BIT(0)
+#define RK3568_PIPE_GRF_XPCS_SGMII_MAC_SEL	GRF_BIT(1)
+#define RK3568_PIPE_GRF_XPCS_PHY_READY		GRF_BIT(2)
+
+static void rk3568_set_to_sgmii(struct rk_priv_data *bsp_priv)
+{
+	struct device *dev = &bsp_priv->pdev->dev;
+	u32 con1;
+
+	if (IS_ERR(bsp_priv->grf)) {
+		dev_err(dev, "Missing rockchip,grf property\n");
+		return;
+	}
+
+	con1 = (bsp_priv->id == 1) ? RK3568_GRF_GMAC1_CON1 :
+				     RK3568_GRF_GMAC0_CON1;
+	regmap_write(bsp_priv->grf, con1, RK3568_GMAC_GMII_MODE);
+
+	xpcs_setup(bsp_priv, PHY_INTERFACE_MODE_SGMII);
+}
+
+static void rk3568_set_to_qsgmii(struct rk_priv_data *bsp_priv)
+{
+	struct device *dev = &bsp_priv->pdev->dev;
+	u32 con1;
+
+	if (IS_ERR(bsp_priv->grf)) {
+		dev_err(dev, "Missing rockchip,grf property\n");
+		return;
+	}
+
+	con1 = (bsp_priv->id == 1) ? RK3568_GRF_GMAC1_CON1 :
+				     RK3568_GRF_GMAC0_CON1;
+	regmap_write(bsp_priv->grf, con1, RK3568_GMAC_GMII_MODE);
+
+	xpcs_setup(bsp_priv, PHY_INTERFACE_MODE_QSGMII);
+}
+
 static void rk3568_set_to_rgmii(struct rk_priv_data *bsp_priv,
 				int tx_delay, int rx_delay)
 {
@@ -1094,6 +1262,8 @@ static void rk3568_set_gmac_speed(struct rk_priv_data *bsp_priv, int speed)
 static const struct rk_gmac_ops rk3568_ops = {
 	.set_to_rgmii = rk3568_set_to_rgmii,
 	.set_to_rmii = rk3568_set_to_rmii,
+	.set_to_sgmii = rk3568_set_to_sgmii,
+	.set_to_qsgmii = rk3568_set_to_qsgmii,
 	.set_rgmii_speed = rk3568_set_gmac_speed,
 	.set_rmii_speed = rk3568_set_gmac_speed,
 	.regs_valid = true,
@@ -1517,6 +1687,12 @@ static int rk_gmac_clk_init(struct plat_stmmacenet_data *plat)
 				dev_err(dev, "cannot get clock %s\n",
 					"clk_mac_refout");
 		}
+	} else if (bsp_priv->phy_iface == PHY_INTERFACE_MODE_SGMII ||
+		   bsp_priv->phy_iface == PHY_INTERFACE_MODE_QSGMII) {
+		bsp_priv->pclk_xpcs = devm_clk_get(dev, "pclk_xpcs");
+		if (IS_ERR(bsp_priv->pclk_xpcs))
+			dev_err(dev, "cannot get clock %s\n",
+				"pclk_xpcs");
 	}
 
 	bsp_priv->clk_mac_speed = devm_clk_get(dev, "clk_mac_speed");
@@ -1572,6 +1748,9 @@ static int gmac_clk_enable(struct rk_priv_data *bsp_priv, bool enable)
 			if (!IS_ERR(bsp_priv->pclk_mac))
 				clk_prepare_enable(bsp_priv->pclk_mac);
 
+			if (!IS_ERR(bsp_priv->pclk_xpcs))
+				clk_prepare_enable(bsp_priv->pclk_xpcs);
+
 			if (!IS_ERR(bsp_priv->mac_clk_tx))
 				clk_prepare_enable(bsp_priv->mac_clk_tx);
 
@@ -1605,6 +1784,8 @@ static int gmac_clk_enable(struct rk_priv_data *bsp_priv, bool enable)
 
 			clk_disable_unprepare(bsp_priv->pclk_mac);
 
+			clk_disable_unprepare(bsp_priv->pclk_xpcs);
+
 			clk_disable_unprepare(bsp_priv->mac_clk_tx);
 
 			clk_disable_unprepare(bsp_priv->clk_mac_speed);
@@ -1623,7 +1804,7 @@ static int gmac_clk_enable(struct rk_priv_data *bsp_priv, bool enable)
 	return 0;
 }
 
-static int phy_power_on(struct rk_priv_data *bsp_priv, bool enable)
+static int rk_gmac_phy_power_on(struct rk_priv_data *bsp_priv, bool enable)
 {
 	struct regulator *ldo = bsp_priv->regulator;
 	int ret;
@@ -1728,6 +1909,18 @@ static struct rk_priv_data *rk_gmac_setup(struct platform_device *pdev,
 							"rockchip,grf");
 	bsp_priv->php_grf = syscon_regmap_lookup_by_phandle(dev->of_node,
 							    "rockchip,php-grf");
+	bsp_priv->xpcs = syscon_regmap_lookup_by_phandle(dev->of_node,
+							 "rockchip,xpcs");
+	if (!IS_ERR(bsp_priv->xpcs)) {
+		struct phy *comphy;
+
+		comphy = devm_of_phy_get(&pdev->dev, dev->of_node, NULL);
+		if (IS_ERR(comphy))
+			dev_err(dev, "devm_of_phy_get error\n");
+		ret = phy_init(comphy);
+		if (ret)
+			dev_err(dev, "phy_init error\n");
+	}
 
 	if (plat->phy_node) {
 		bsp_priv->integrated_phy = of_property_read_bool(plat->phy_node,
@@ -1805,11 +1998,19 @@ static int rk_gmac_powerup(struct rk_priv_data *bsp_priv)
 		dev_info(dev, "init for RMII\n");
 		bsp_priv->ops->set_to_rmii(bsp_priv);
 		break;
+	case PHY_INTERFACE_MODE_SGMII:
+		dev_info(dev, "init for SGMII\n");
+		bsp_priv->ops->set_to_sgmii(bsp_priv);
+		break;
+	case PHY_INTERFACE_MODE_QSGMII:
+		dev_info(dev, "init for QSGMII\n");
+		bsp_priv->ops->set_to_qsgmii(bsp_priv);
+		break;
 	default:
 		dev_err(dev, "NO interface defined!\n");
 	}
 
-	ret = phy_power_on(bsp_priv, true);
+	ret = rk_gmac_phy_power_on(bsp_priv, true);
 	if (ret) {
 		gmac_clk_enable(bsp_priv, false);
 		return ret;
@@ -1830,7 +2031,7 @@ static void rk_gmac_powerdown(struct rk_priv_data *gmac)
 
 	pm_runtime_put_sync(&gmac->pdev->dev);
 
-	phy_power_on(gmac, false);
+	rk_gmac_phy_power_on(gmac, false);
 	gmac_clk_enable(gmac, false);
 }
 
@@ -1851,6 +2052,9 @@ static void rk_fix_speed(void *priv, unsigned int speed)
 		if (bsp_priv->ops->set_rmii_speed)
 			bsp_priv->ops->set_rmii_speed(bsp_priv, speed);
 		break;
+	case PHY_INTERFACE_MODE_SGMII:
+	case PHY_INTERFACE_MODE_QSGMII:
+		break;
 	default:
 		dev_err(dev, "unsupported interface %d", bsp_priv->phy_iface);
 	}
-- 
2.25.1

