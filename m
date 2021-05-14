Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24E7F3808FF
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 13:55:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232963AbhENL4T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 07:56:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232897AbhENL4Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 May 2021 07:56:16 -0400
X-Greylist: delayed 1089 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 14 May 2021 04:55:05 PDT
Received: from mail.manjaro.org (mail.manjaro.org [IPv6:2a01:4f8:150:448b::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA772C061574
        for <netdev@vger.kernel.org>; Fri, 14 May 2021 04:55:05 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.manjaro.org (Postfix) with ESMTP id 4C64D22118F;
        Fri, 14 May 2021 13:36:57 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at manjaro.org
Received: from mail.manjaro.org ([127.0.0.1])
        by localhost (manjaro.org [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id sDY3N2aaJo1G; Fri, 14 May 2021 13:36:53 +0200 (CEST)
From:   Tobias Schramm <t.schramm@manjaro.org>
To:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-rockchip@lists.infradead.org,
        Heiko Stuebner <heiko@sntech.de>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        David Wu <david.wu@rock-chips.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Tobias Schramm <t.schramm@manjaro.org>
Subject: [PATCH 2/3] net: stmmac: dwmac-rk: add support for rk3308 gmac
Date:   Fri, 14 May 2021 13:38:12 +0200
Message-Id: <20210514113813.2093534-3-t.schramm@manjaro.org>
In-Reply-To: <20210514113813.2093534-1-t.schramm@manjaro.org>
References: <20210514113813.2093534-1-t.schramm@manjaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Rockchip RK3308 SoC has a gmac with only the RMII interface signals
exposed.
This patch adds support for it.

Signed-off-by: Tobias Schramm <t.schramm@manjaro.org>
---
 .../net/ethernet/stmicro/stmmac/dwmac-rk.c    | 49 +++++++++++++++++++
 1 file changed, 49 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
index 8d28a536e1bb..584db4ce6e39 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
@@ -482,6 +482,54 @@ static const struct rk_gmac_ops rk3288_ops = {
 	.set_rmii_speed = rk3288_set_rmii_speed,
 };
 
+#define RK3308_GRF_MAC_CON0		0x04a0
+
+/* RK3308_GRF_MAC_CON0 */
+#define RK3308_GMAC_PHY_INTF_SEL_RMII	(GRF_CLR_BIT(2) | GRF_CLR_BIT(3) | \
+					GRF_BIT(4))
+#define RK3308_GMAC_FLOW_CTRL		GRF_BIT(3)
+#define RK3308_GMAC_FLOW_CTRL_CLR	GRF_CLR_BIT(3)
+#define RK3308_GMAC_SPEED_10M		GRF_CLR_BIT(0)
+#define RK3308_GMAC_SPEED_100M		GRF_BIT(0)
+
+static void rk3308_set_to_rmii(struct rk_priv_data *bsp_priv)
+{
+	struct device *dev = &bsp_priv->pdev->dev;
+
+	if (IS_ERR(bsp_priv->grf)) {
+		dev_err(dev, "Missing rockchip,grf property\n");
+		return;
+	}
+
+	regmap_write(bsp_priv->grf, RK3308_GRF_MAC_CON0,
+		     RK3308_GMAC_PHY_INTF_SEL_RMII);
+}
+
+static void rk3308_set_rmii_speed(struct rk_priv_data *bsp_priv, int speed)
+{
+	struct device *dev = &bsp_priv->pdev->dev;
+
+	if (IS_ERR(bsp_priv->grf)) {
+		dev_err(dev, "Missing rockchip,grf property\n");
+		return;
+	}
+
+	if (speed == 10) {
+		regmap_write(bsp_priv->grf, RK3308_GRF_MAC_CON0,
+			     RK3308_GMAC_SPEED_10M);
+	} else if (speed == 100) {
+		regmap_write(bsp_priv->grf, RK3308_GRF_MAC_CON0,
+			     RK3308_GMAC_SPEED_100M);
+	} else {
+		dev_err(dev, "unknown speed value for RMII! speed=%d", speed);
+	}
+}
+
+static const struct rk_gmac_ops rk3308_ops = {
+	.set_to_rmii = rk3308_set_to_rmii,
+	.set_rmii_speed = rk3308_set_rmii_speed,
+};
+
 #define RK3328_GRF_MAC_CON0	0x0900
 #define RK3328_GRF_MAC_CON1	0x0904
 #define RK3328_GRF_MAC_CON2	0x0908
@@ -1477,6 +1525,7 @@ static const struct of_device_id rk_gmac_dwmac_match[] = {
 	{ .compatible = "rockchip,rk3128-gmac", .data = &rk3128_ops },
 	{ .compatible = "rockchip,rk3228-gmac", .data = &rk3228_ops },
 	{ .compatible = "rockchip,rk3288-gmac", .data = &rk3288_ops },
+	{ .compatible = "rockchip,rk3308-gmac", .data = &rk3308_ops },
 	{ .compatible = "rockchip,rk3328-gmac", .data = &rk3328_ops },
 	{ .compatible = "rockchip,rk3366-gmac", .data = &rk3366_ops },
 	{ .compatible = "rockchip,rk3368-gmac", .data = &rk3368_ops },
-- 
2.31.1

