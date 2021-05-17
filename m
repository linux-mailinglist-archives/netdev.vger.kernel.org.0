Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52494383A20
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 18:38:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242254AbhEQQiy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 12:38:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244973AbhEQQie (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 12:38:34 -0400
Received: from bhuna.collabora.co.uk (bhuna.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e3e3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 915FFC003665;
        Mon, 17 May 2021 08:41:09 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: ezequiel)
        with ESMTPSA id 60F471F423BD
From:   Ezequiel Garcia <ezequiel@collabora.com>
To:     netdev@vger.kernel.org, linux-rockchip@lists.infradead.org,
        devicetree@vger.kernel.org
Cc:     Jose Abreu <joabreu@synopsys.com>,
        Heiko Stuebner <heiko@sntech.de>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Peter Geis <pgwipeout@gmail.com>,
        Kever Yang <kever.yang@rock-chips.com>,
        David Wu <david.wu@rock-chips.com>,
        Rob Herring <robh+dt@kernel.org>,
        Johan Jonker <jbx6244@gmail.com>,
        Chen-Yu Tsai <wens213@gmail.com>,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH v3 net-next 4/4] net: stmmac: Add RK3566/RK3568 SoC support
Date:   Mon, 17 May 2021 12:40:37 -0300
Message-Id: <20210517154037.37946-5-ezequiel@collabora.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210517154037.37946-1-ezequiel@collabora.com>
References: <20210517154037.37946-1-ezequiel@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Wu <david.wu@rock-chips.com>

Add constants and callback functions for the dwmac present
on RK3566/RK3568 SoCs.

RK3568 has two MACs, and RK3566 just one, but it's otherwise
the same IP core.

Signed-off-by: David Wu <david.wu@rock-chips.com>
[Ezequiel: Separate rk3566-gmac support]
Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
---
 .../net/ethernet/stmicro/stmmac/dwmac-rk.c    | 121 ++++++++++++++++++
 1 file changed, 121 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
index 791c13d47a35..280ac0129572 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
@@ -33,11 +33,13 @@ struct rk_gmac_ops {
 	void (*set_rgmii_speed)(struct rk_priv_data *bsp_priv, int speed);
 	void (*set_rmii_speed)(struct rk_priv_data *bsp_priv, int speed);
 	void (*integrated_phy_powerup)(struct rk_priv_data *bsp_priv);
+	u32 regs[];
 };
 
 struct rk_priv_data {
 	struct platform_device *pdev;
 	phy_interface_t phy_iface;
+	int id;
 	struct regulator *regulator;
 	bool suspended;
 	const struct rk_gmac_ops *ops;
@@ -996,6 +998,107 @@ static const struct rk_gmac_ops rk3399_ops = {
 	.set_rmii_speed = rk3399_set_rmii_speed,
 };
 
+#define RK3568_GRF_GMAC0_CON0		0x0380
+#define RK3568_GRF_GMAC0_CON1		0x0384
+#define RK3568_GRF_GMAC1_CON0		0x0388
+#define RK3568_GRF_GMAC1_CON1		0x038c
+
+/* RK3568_GRF_GMAC0_CON1 && RK3568_GRF_GMAC1_CON1 */
+#define RK3568_GMAC_PHY_INTF_SEL_RGMII	\
+		(GRF_BIT(4) | GRF_CLR_BIT(5) | GRF_CLR_BIT(6))
+#define RK3568_GMAC_PHY_INTF_SEL_RMII	\
+		(GRF_CLR_BIT(4) | GRF_CLR_BIT(5) | GRF_BIT(6))
+#define RK3568_GMAC_FLOW_CTRL			GRF_BIT(3)
+#define RK3568_GMAC_FLOW_CTRL_CLR		GRF_CLR_BIT(3)
+#define RK3568_GMAC_RXCLK_DLY_ENABLE		GRF_BIT(1)
+#define RK3568_GMAC_RXCLK_DLY_DISABLE		GRF_CLR_BIT(1)
+#define RK3568_GMAC_TXCLK_DLY_ENABLE		GRF_BIT(0)
+#define RK3568_GMAC_TXCLK_DLY_DISABLE		GRF_CLR_BIT(0)
+
+/* RK3568_GRF_GMAC0_CON0 && RK3568_GRF_GMAC1_CON0 */
+#define RK3568_GMAC_CLK_RX_DL_CFG(val)	HIWORD_UPDATE(val, 0x7F, 8)
+#define RK3568_GMAC_CLK_TX_DL_CFG(val)	HIWORD_UPDATE(val, 0x7F, 0)
+
+static void rk3568_set_to_rgmii(struct rk_priv_data *bsp_priv,
+				int tx_delay, int rx_delay)
+{
+	struct device *dev = &bsp_priv->pdev->dev;
+	u32 con0, con1;
+
+	if (IS_ERR(bsp_priv->grf)) {
+		dev_err(dev, "Missing rockchip,grf property\n");
+		return;
+	}
+
+	con0 = (bsp_priv->id == 1) ? RK3568_GRF_GMAC1_CON0 :
+				     RK3568_GRF_GMAC0_CON0;
+	con1 = (bsp_priv->id == 1) ? RK3568_GRF_GMAC1_CON1 :
+				     RK3568_GRF_GMAC0_CON1;
+
+	regmap_write(bsp_priv->grf, con0,
+		     RK3568_GMAC_CLK_RX_DL_CFG(rx_delay) |
+		     RK3568_GMAC_CLK_TX_DL_CFG(tx_delay));
+
+	regmap_write(bsp_priv->grf, con1,
+		     RK3568_GMAC_PHY_INTF_SEL_RGMII |
+		     RK3568_GMAC_RXCLK_DLY_ENABLE |
+		     RK3568_GMAC_TXCLK_DLY_ENABLE);
+}
+
+static void rk3568_set_to_rmii(struct rk_priv_data *bsp_priv)
+{
+	struct device *dev = &bsp_priv->pdev->dev;
+	u32 con1;
+
+	if (IS_ERR(bsp_priv->grf)) {
+		dev_err(dev, "%s: Missing rockchip,grf property\n", __func__);
+		return;
+	}
+
+	con1 = (bsp_priv->id == 1) ? RK3568_GRF_GMAC1_CON1 :
+				     RK3568_GRF_GMAC0_CON1;
+	regmap_write(bsp_priv->grf, con1, RK3568_GMAC_PHY_INTF_SEL_RMII);
+}
+
+static void rk3568_set_gmac_speed(struct rk_priv_data *bsp_priv, int speed)
+{
+	struct device *dev = &bsp_priv->pdev->dev;
+	unsigned long rate;
+	int ret;
+
+	switch (speed) {
+	case 10:
+		rate = 2500000;
+		break;
+	case 100:
+		rate = 25000000;
+		break;
+	case 1000:
+		rate = 125000000;
+		break;
+	default:
+		dev_err(dev, "unknown speed value for GMAC speed=%d", speed);
+		return;
+	}
+
+	ret = clk_set_rate(bsp_priv->clk_mac_speed, rate);
+	if (ret)
+		dev_err(dev, "%s: set clk_mac_speed rate %ld failed %d\n",
+			__func__, rate, ret);
+}
+
+static const struct rk_gmac_ops rk3568_ops = {
+	.set_to_rgmii = rk3568_set_to_rgmii,
+	.set_to_rmii = rk3568_set_to_rmii,
+	.set_rgmii_speed = rk3568_set_gmac_speed,
+	.set_rmii_speed = rk3568_set_gmac_speed,
+	.regs = {
+		0xfe2a0000, /* gmac0 */
+		0xfe010000, /* gmac1 */
+		0x0, /* sentinel */
+	},
+};
+
 #define RV1108_GRF_GMAC_CON0		0X0900
 
 /* RV1108_GRF_GMAC_CON0 */
@@ -1264,6 +1367,7 @@ static struct rk_priv_data *rk_gmac_setup(struct platform_device *pdev,
 {
 	struct rk_priv_data *bsp_priv;
 	struct device *dev = &pdev->dev;
+	struct resource *res;
 	int ret;
 	const char *strings = NULL;
 	int value;
@@ -1275,6 +1379,22 @@ static struct rk_priv_data *rk_gmac_setup(struct platform_device *pdev,
 	of_get_phy_mode(dev->of_node, &bsp_priv->phy_iface);
 	bsp_priv->ops = ops;
 
+	/* Some SoCs have multiple MAC controllers, which need
+	 * to be distinguished.
+	 */
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (res) {
+		int i = 0;
+
+		while (ops->regs[i]) {
+			if (ops->regs[i] == res->start) {
+				bsp_priv->id = i;
+				break;
+			}
+			i++;
+		}
+	}
+
 	bsp_priv->regulator = devm_regulator_get_optional(dev, "phy");
 	if (IS_ERR(bsp_priv->regulator)) {
 		if (PTR_ERR(bsp_priv->regulator) == -EPROBE_DEFER) {
@@ -1561,6 +1681,7 @@ static const struct of_device_id rk_gmac_dwmac_match[] = {
 	{ .compatible = "rockchip,rk3366-gmac", .data = &rk3366_ops },
 	{ .compatible = "rockchip,rk3368-gmac", .data = &rk3368_ops },
 	{ .compatible = "rockchip,rk3399-gmac", .data = &rk3399_ops },
+	{ .compatible = "rockchip,rk3568-gmac", .data = &rk3568_ops },
 	{ .compatible = "rockchip,rv1108-gmac", .data = &rv1108_ops },
 	{ }
 };
-- 
2.30.0

