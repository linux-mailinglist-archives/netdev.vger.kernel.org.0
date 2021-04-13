Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD4A035E7FD
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 23:03:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346546AbhDMVD0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 17:03:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345585AbhDMVDV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 17:03:21 -0400
Received: from bhuna.collabora.co.uk (bhuna.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e3e3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DFBCC06138C
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 14:03:00 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: ezequiel)
        with ESMTPSA id 531631F42508
From:   Ezequiel Garcia <ezequiel@collabora.com>
To:     netdev@vger.kernel.org, linux-rockchip@lists.infradead.org
Cc:     Jose Abreu <joabreu@synopsys.com>,
        Heiko Stuebner <heiko@sntech.de>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Peter Geis <pgwipeout@gmail.com>,
        David Wu <david.wu@rock-chips.com>, kernel@collabora.com,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH net-next 3/3] net: stmmac: Add RK3566/RK3568 SoC support
Date:   Tue, 13 Apr 2021 18:02:35 -0300
Message-Id: <20210413210235.489467-4-ezequiel@collabora.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210413210235.489467-1-ezequiel@collabora.com>
References: <20210413210235.489467-1-ezequiel@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Wu <david.wu@rock-chips.com>

Add constants and callback functions for the dwmac present
on RK3566 and RK3568 SoCs. As can be seen, the base structure
is the same, only registers and the bits in them moved slightly.

RK3568 supports two MACs, and RK3566 support just one.

Signed-off-by: David Wu <david.wu@rock-chips.com>
[Ezequiel: Add rockchip,rk3566-gmac compatible string]
Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
---
 .../bindings/net/rockchip-dwmac.txt           |   2 +
 .../net/ethernet/stmicro/stmmac/dwmac-rk.c    | 142 ++++++++++++++++++
 2 files changed, 144 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/rockchip-dwmac.txt b/Documentation/devicetree/bindings/net/rockchip-dwmac.txt
index 3b71da7e8742..80203b16b652 100644
--- a/Documentation/devicetree/bindings/net/rockchip-dwmac.txt
+++ b/Documentation/devicetree/bindings/net/rockchip-dwmac.txt
@@ -12,6 +12,8 @@ Required properties:
    "rockchip,rk3366-gmac": found on RK3366 SoCs
    "rockchip,rk3368-gmac": found on RK3368 SoCs
    "rockchip,rk3399-gmac": found on RK3399 SoCs
+   "rockchip,rk3566-gmac": found on RK3566 SoCs
+   "rockchip,rk3568-gmac": found on RK3568 SoCs
    "rockchip,rv1108-gmac": found on RV1108 SoCs
  - reg: addresses and length of the register sets for the device.
  - interrupts: Should contain the GMAC interrupts.
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
index d2637d83899e..096965b0fec9 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
@@ -948,6 +948,146 @@ static const struct rk_gmac_ops rk3399_ops = {
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
+static void rk3566_set_to_rgmii(struct rk_priv_data *bsp_priv,
+				int tx_delay, int rx_delay)
+{
+	struct device *dev = &bsp_priv->pdev->dev;
+
+	if (IS_ERR(bsp_priv->grf)) {
+		dev_err(dev, "Missing rockchip,grf property\n");
+		return;
+	}
+
+	regmap_write(bsp_priv->grf, RK3568_GRF_GMAC1_CON1,
+		     RK3568_GMAC_PHY_INTF_SEL_RGMII |
+		     RK3568_GMAC_RXCLK_DLY_ENABLE |
+		     RK3568_GMAC_TXCLK_DLY_ENABLE);
+
+	regmap_write(bsp_priv->grf, RK3568_GRF_GMAC1_CON0,
+		     RK3568_GMAC_CLK_RX_DL_CFG(rx_delay) |
+		     RK3568_GMAC_CLK_TX_DL_CFG(tx_delay));
+}
+
+static void rk3566_set_to_rmii(struct rk_priv_data *bsp_priv)
+{
+	struct device *dev = &bsp_priv->pdev->dev;
+
+	if (IS_ERR(bsp_priv->grf)) {
+		dev_err(dev, "%s: Missing rockchip,grf property\n", __func__);
+		return;
+	}
+
+	regmap_write(bsp_priv->grf, RK3568_GRF_GMAC1_CON1,
+		     RK3568_GMAC_PHY_INTF_SEL_RMII);
+}
+
+static void rk3568_set_to_rgmii(struct rk_priv_data *bsp_priv,
+				int tx_delay, int rx_delay)
+{
+	struct device *dev = &bsp_priv->pdev->dev;
+
+	if (IS_ERR(bsp_priv->grf)) {
+		dev_err(dev, "Missing rockchip,grf property\n");
+		return;
+	}
+
+	regmap_write(bsp_priv->grf, RK3568_GRF_GMAC0_CON1,
+		     RK3568_GMAC_PHY_INTF_SEL_RGMII |
+		     RK3568_GMAC_RXCLK_DLY_ENABLE |
+		     RK3568_GMAC_TXCLK_DLY_ENABLE);
+
+	regmap_write(bsp_priv->grf, RK3568_GRF_GMAC0_CON0,
+		     RK3568_GMAC_CLK_RX_DL_CFG(rx_delay) |
+		     RK3568_GMAC_CLK_TX_DL_CFG(tx_delay));
+
+	regmap_write(bsp_priv->grf, RK3568_GRF_GMAC1_CON1,
+		     RK3568_GMAC_PHY_INTF_SEL_RGMII |
+		     RK3568_GMAC_RXCLK_DLY_ENABLE |
+		     RK3568_GMAC_TXCLK_DLY_ENABLE);
+
+	regmap_write(bsp_priv->grf, RK3568_GRF_GMAC1_CON0,
+		     RK3568_GMAC_CLK_RX_DL_CFG(rx_delay) |
+		     RK3568_GMAC_CLK_TX_DL_CFG(tx_delay));
+}
+
+static void rk3568_set_to_rmii(struct rk_priv_data *bsp_priv)
+{
+	struct device *dev = &bsp_priv->pdev->dev;
+
+	if (IS_ERR(bsp_priv->grf)) {
+		dev_err(dev, "%s: Missing rockchip,grf property\n", __func__);
+		return;
+	}
+
+	regmap_write(bsp_priv->grf, RK3568_GRF_GMAC0_CON1,
+		     RK3568_GMAC_PHY_INTF_SEL_RMII);
+
+	regmap_write(bsp_priv->grf, RK3568_GRF_GMAC1_CON1,
+		     RK3568_GMAC_PHY_INTF_SEL_RMII);
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
+};
+
+static const struct rk_gmac_ops rk3566_ops = {
+	.set_to_rgmii = rk3566_set_to_rgmii,
+	.set_to_rmii = rk3566_set_to_rmii,
+	.set_rgmii_speed = rk3568_set_gmac_speed,
+	.set_rmii_speed = rk3568_set_gmac_speed,
+};
+
 #define RV1108_GRF_GMAC_CON0		0X0900
 
 /* RV1108_GRF_GMAC_CON0 */
@@ -1512,6 +1652,8 @@ static const struct of_device_id rk_gmac_dwmac_match[] = {
 	{ .compatible = "rockchip,rk3366-gmac", .data = &rk3366_ops },
 	{ .compatible = "rockchip,rk3368-gmac", .data = &rk3368_ops },
 	{ .compatible = "rockchip,rk3399-gmac", .data = &rk3399_ops },
+	{ .compatible = "rockchip,rk3568-gmac", .data = &rk3568_ops },
+	{ .compatible = "rockchip,rk3566-gmac", .data = &rk3566_ops },
 	{ .compatible = "rockchip,rv1108-gmac", .data = &rv1108_ops },
 	{ }
 };
-- 
2.30.0

