Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83537557FCE
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 18:29:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232253AbiFWQ27 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 12:28:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232239AbiFWQ26 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 12:28:58 -0400
Received: from madras.collabora.co.uk (madras.collabora.co.uk [46.235.227.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 334633EA82;
        Thu, 23 Jun 2022 09:28:57 -0700 (PDT)
Received: from jupiter.universe (unknown [95.33.159.255])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: sre)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id AF34766017E6;
        Thu, 23 Jun 2022 17:28:55 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1656001735;
        bh=huCqIkSsRjfeW8U4OxONZgi/U/dFqSyDdQFMGO2QZ0s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fjjkYsmxkzT/39Nfyz5ZEWDXL+zMIluFzhEXlWUNuRGkw2viTql4irkwOGiAzvmY5
         9LtTqdPAez2tDRnNlZ+ysnq7E7X76QeW0MIxuzq7JpGuo1Akk0cWYPia+BKbIz59E5
         BNwcs8fgbuhDKMA79Tp7eChNwNUV4JmlYCxqjg+LbOZI2bAbMDAqezFuu6ZMzgZm0H
         acyIdrC2jfv2rxJQ2OWbnsIFiKkEFR9hY3aS6WXnYgo82XrGY9mvFhO1ZEt6DnCNON
         sViXIWR9/jPfAZcoUg/bwq73WxGClOPamJ5nwgOF2rAl91zn0qJCdXu1HZjHFg2K6k
         cXWnHUI3I5/Vw==
Received: by jupiter.universe (Postfix, from userid 1000)
        id 461FD480125; Thu, 23 Jun 2022 18:28:53 +0200 (CEST)
From:   Sebastian Reichel <sebastian.reichel@collabora.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        netdev@vger.kernel.org, linux-rockchip@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        David Wu <david.wu@rock-chips.com>, kernel@collabora.com,
        Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 1/3] net: ethernet: stmmac: dwmac-rk: Disable delayline if it is invalid
Date:   Thu, 23 Jun 2022 18:28:48 +0200
Message-Id: <20220623162850.245608-2-sebastian.reichel@collabora.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220623162850.245608-1-sebastian.reichel@collabora.com>
References: <20220623162850.245608-1-sebastian.reichel@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Wu <david.wu@rock-chips.com>

Explicitly disable delayline if it is no value is configured in DT.

Signed-off-by: David Wu <david.wu@rock-chips.com>
[rebase]
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
---
 .../net/ethernet/stmicro/stmmac/dwmac-rk.c    | 52 +++++++++----------
 1 file changed, 25 insertions(+), 27 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
index c469abc91fa1..56ccd4fbd6c0 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
@@ -75,8 +75,16 @@ struct rk_priv_data {
 #define GRF_CLR_BIT(nr)	(BIT(nr+16))
 
 #define DELAY_ENABLE(soc, tx, rx) \
-	(((tx) ? soc##_GMAC_TXCLK_DLY_ENABLE : soc##_GMAC_TXCLK_DLY_DISABLE) | \
-	 ((rx) ? soc##_GMAC_RXCLK_DLY_ENABLE : soc##_GMAC_RXCLK_DLY_DISABLE))
+	((((tx) >= 0) ? soc##_GMAC_TXCLK_DLY_ENABLE : soc##_GMAC_TXCLK_DLY_DISABLE) | \
+	 (((rx) >= 0) ? soc##_GMAC_RXCLK_DLY_ENABLE : soc##_GMAC_RXCLK_DLY_DISABLE))
+
+#define DELAY_ENABLE_BY_ID(soc, tx, rx, id) \
+	((((tx) >= 0) ? soc##_GMAC_TXCLK_DLY_ENABLE(id) : soc##_GMAC_TXCLK_DLY_DISABLE(id)) | \
+	 (((rx) >= 0) ? soc##_GMAC_RXCLK_DLY_ENABLE(id) : soc##_GMAC_RXCLK_DLY_DISABLE(id)))
+
+#define DELAY_VALUE(soc, tx, rx) \
+	((((tx) >= 0) ? soc##_GMAC_CLK_TX_DL_CFG(tx) : 0) | \
+	 (((rx) >= 0) ? soc##_GMAC_CLK_RX_DL_CFG(rx) : 0))
 
 #define PX30_GRF_GMAC_CON1		0x0904
 
@@ -179,8 +187,7 @@ static void rk3128_set_to_rgmii(struct rk_priv_data *bsp_priv,
 		     RK3128_GMAC_RMII_MODE_CLR);
 	regmap_write(bsp_priv->grf, RK3128_GRF_MAC_CON0,
 		     DELAY_ENABLE(RK3128, tx_delay, rx_delay) |
-		     RK3128_GMAC_CLK_RX_DL_CFG(rx_delay) |
-		     RK3128_GMAC_CLK_TX_DL_CFG(tx_delay));
+		     DELAY_VALUE(RK3128, tx_delay, rx_delay));
 }
 
 static void rk3128_set_to_rmii(struct rk_priv_data *bsp_priv)
@@ -296,8 +303,7 @@ static void rk3228_set_to_rgmii(struct rk_priv_data *bsp_priv,
 		     DELAY_ENABLE(RK3228, tx_delay, rx_delay));
 
 	regmap_write(bsp_priv->grf, RK3228_GRF_MAC_CON0,
-		     RK3228_GMAC_CLK_RX_DL_CFG(rx_delay) |
-		     RK3228_GMAC_CLK_TX_DL_CFG(tx_delay));
+		     DELAY_VALUE(RK3128, tx_delay, rx_delay));
 }
 
 static void rk3228_set_to_rmii(struct rk_priv_data *bsp_priv)
@@ -417,8 +423,7 @@ static void rk3288_set_to_rgmii(struct rk_priv_data *bsp_priv,
 		     RK3288_GMAC_RMII_MODE_CLR);
 	regmap_write(bsp_priv->grf, RK3288_GRF_SOC_CON3,
 		     DELAY_ENABLE(RK3288, tx_delay, rx_delay) |
-		     RK3288_GMAC_CLK_RX_DL_CFG(rx_delay) |
-		     RK3288_GMAC_CLK_TX_DL_CFG(tx_delay));
+		     DELAY_VALUE(RK3288, tx_delay, rx_delay));
 }
 
 static void rk3288_set_to_rmii(struct rk_priv_data *bsp_priv)
@@ -579,12 +584,10 @@ static void rk3328_set_to_rgmii(struct rk_priv_data *bsp_priv,
 	regmap_write(bsp_priv->grf, RK3328_GRF_MAC_CON1,
 		     RK3328_GMAC_PHY_INTF_SEL_RGMII |
 		     RK3328_GMAC_RMII_MODE_CLR |
-		     RK3328_GMAC_RXCLK_DLY_ENABLE |
-		     RK3328_GMAC_TXCLK_DLY_ENABLE);
+		     DELAY_ENABLE(RK3328, tx_delay, rx_delay));
 
 	regmap_write(bsp_priv->grf, RK3328_GRF_MAC_CON0,
-		     RK3328_GMAC_CLK_RX_DL_CFG(rx_delay) |
-		     RK3328_GMAC_CLK_TX_DL_CFG(tx_delay));
+		     DELAY_VALUE(RK3328, tx_delay, rx_delay));
 }
 
 static void rk3328_set_to_rmii(struct rk_priv_data *bsp_priv)
@@ -709,8 +712,7 @@ static void rk3366_set_to_rgmii(struct rk_priv_data *bsp_priv,
 		     RK3366_GMAC_RMII_MODE_CLR);
 	regmap_write(bsp_priv->grf, RK3366_GRF_SOC_CON7,
 		     DELAY_ENABLE(RK3366, tx_delay, rx_delay) |
-		     RK3366_GMAC_CLK_RX_DL_CFG(rx_delay) |
-		     RK3366_GMAC_CLK_TX_DL_CFG(tx_delay));
+		     DELAY_VALUE(RK3366, tx_delay, rx_delay));
 }
 
 static void rk3366_set_to_rmii(struct rk_priv_data *bsp_priv)
@@ -820,8 +822,7 @@ static void rk3368_set_to_rgmii(struct rk_priv_data *bsp_priv,
 		     RK3368_GMAC_RMII_MODE_CLR);
 	regmap_write(bsp_priv->grf, RK3368_GRF_SOC_CON16,
 		     DELAY_ENABLE(RK3368, tx_delay, rx_delay) |
-		     RK3368_GMAC_CLK_RX_DL_CFG(rx_delay) |
-		     RK3368_GMAC_CLK_TX_DL_CFG(tx_delay));
+		     DELAY_VALUE(RK3368, tx_delay, rx_delay));
 }
 
 static void rk3368_set_to_rmii(struct rk_priv_data *bsp_priv)
@@ -931,8 +932,7 @@ static void rk3399_set_to_rgmii(struct rk_priv_data *bsp_priv,
 		     RK3399_GMAC_RMII_MODE_CLR);
 	regmap_write(bsp_priv->grf, RK3399_GRF_SOC_CON6,
 		     DELAY_ENABLE(RK3399, tx_delay, rx_delay) |
-		     RK3399_GMAC_CLK_RX_DL_CFG(rx_delay) |
-		     RK3399_GMAC_CLK_TX_DL_CFG(tx_delay));
+		     DELAY_VALUE(RK3399, tx_delay, rx_delay));
 }
 
 static void rk3399_set_to_rmii(struct rk_priv_data *bsp_priv)
@@ -1037,13 +1037,11 @@ static void rk3568_set_to_rgmii(struct rk_priv_data *bsp_priv,
 				     RK3568_GRF_GMAC0_CON1;
 
 	regmap_write(bsp_priv->grf, con0,
-		     RK3568_GMAC_CLK_RX_DL_CFG(rx_delay) |
-		     RK3568_GMAC_CLK_TX_DL_CFG(tx_delay));
+		     DELAY_VALUE(RK3568, tx_delay, rx_delay));
 
 	regmap_write(bsp_priv->grf, con1,
 		     RK3568_GMAC_PHY_INTF_SEL_RGMII |
-		     RK3568_GMAC_RXCLK_DLY_ENABLE |
-		     RK3568_GMAC_TXCLK_DLY_ENABLE);
+		     DELAY_ENABLE(RK3568, tx_delay, rx_delay));
 }
 
 static void rk3568_set_to_rmii(struct rk_priv_data *bsp_priv)
@@ -1422,7 +1420,7 @@ static struct rk_priv_data *rk_gmac_setup(struct platform_device *pdev,
 
 	ret = of_property_read_u32(dev->of_node, "tx_delay", &value);
 	if (ret) {
-		bsp_priv->tx_delay = 0x30;
+		bsp_priv->tx_delay = -1;
 		dev_err(dev, "Can not read property: tx_delay.");
 		dev_err(dev, "set tx_delay to 0x%x\n",
 			bsp_priv->tx_delay);
@@ -1433,7 +1431,7 @@ static struct rk_priv_data *rk_gmac_setup(struct platform_device *pdev,
 
 	ret = of_property_read_u32(dev->of_node, "rx_delay", &value);
 	if (ret) {
-		bsp_priv->rx_delay = 0x10;
+		bsp_priv->rx_delay = -1;
 		dev_err(dev, "Can not read property: rx_delay.");
 		dev_err(dev, "set rx_delay to 0x%x\n",
 			bsp_priv->rx_delay);
@@ -1507,15 +1505,15 @@ static int rk_gmac_powerup(struct rk_priv_data *bsp_priv)
 		break;
 	case PHY_INTERFACE_MODE_RGMII_ID:
 		dev_info(dev, "init for RGMII_ID\n");
-		bsp_priv->ops->set_to_rgmii(bsp_priv, 0, 0);
+		bsp_priv->ops->set_to_rgmii(bsp_priv, -1, -1);
 		break;
 	case PHY_INTERFACE_MODE_RGMII_RXID:
 		dev_info(dev, "init for RGMII_RXID\n");
-		bsp_priv->ops->set_to_rgmii(bsp_priv, bsp_priv->tx_delay, 0);
+		bsp_priv->ops->set_to_rgmii(bsp_priv, bsp_priv->tx_delay, -1);
 		break;
 	case PHY_INTERFACE_MODE_RGMII_TXID:
 		dev_info(dev, "init for RGMII_TXID\n");
-		bsp_priv->ops->set_to_rgmii(bsp_priv, 0, bsp_priv->rx_delay);
+		bsp_priv->ops->set_to_rgmii(bsp_priv, -1, bsp_priv->rx_delay);
 		break;
 	case PHY_INTERFACE_MODE_RMII:
 		dev_info(dev, "init for RMII\n");
-- 
2.35.1

