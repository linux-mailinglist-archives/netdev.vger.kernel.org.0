Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1902C306215
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 18:33:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235776AbhA0Rci (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 12:32:38 -0500
Received: from foss.arm.com ([217.140.110.172]:56862 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235499AbhA0R3A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Jan 2021 12:29:00 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E93DA14F6;
        Wed, 27 Jan 2021 09:26:26 -0800 (PST)
Received: from localhost.localdomain (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 598BD3F66E;
        Wed, 27 Jan 2021 09:26:24 -0800 (PST)
From:   Andre Przywara <andre.przywara@arm.com>
To:     Maxime Ripard <mripard@kernel.org>, Chen-Yu Tsai <wens@csie.org>
Cc:     Jernej Skrabec <jernej.skrabec@siol.net>,
        Samuel Holland <samuel@sholland.org>,
        Icenowy Zheng <icenowy@aosc.io>, Rob Herring <robh@kernel.org>,
        =?UTF-8?q?Cl=C3=A9ment=20P=C3=A9ron?= <peron.clem@gmail.com>,
        Shuosheng Huang <huangshuosheng@allwinnertech.com>,
        Yangtao Li <tiny.windzz@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jose Abreu <joabreu@synopsys.com>, netdev@vger.kernel.org
Subject: [PATCH v5 16/20] net: stmmac: dwmac-sun8i: Prepare for second EMAC clock register
Date:   Wed, 27 Jan 2021 17:24:56 +0000
Message-Id: <20210127172500.13356-17-andre.przywara@arm.com>
X-Mailer: git-send-email 2.14.1
In-Reply-To: <20210127172500.13356-1-andre.przywara@arm.com>
References: <20210127172500.13356-1-andre.przywara@arm.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Allwinner H616 SoC has two EMAC controllers, with the second one
being tied to the internal PHY, but also using a separate EMAC clock
register.

To tell the driver about which clock register to use, we add a parameter
to our syscon phandle. The driver will use this value as an index into
the regmap, so that we can address more than the first register, if
needed.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
index 58e0511badba..c7951790ed98 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
@@ -1124,11 +1124,13 @@ static int sun8i_dwmac_probe(struct platform_device *pdev)
 	struct stmmac_resources stmmac_res;
 	struct sunxi_priv_data *gmac;
 	struct device *dev = &pdev->dev;
+	struct reg_field syscon_field;
 	phy_interface_t interface;
 	int ret;
 	struct stmmac_priv *priv;
 	struct net_device *ndev;
 	struct regmap *regmap;
+	u32 syscon_idx = 0;
 
 	ret = stmmac_get_platform_resources(pdev, &stmmac_res);
 	if (ret)
@@ -1190,8 +1192,12 @@ static int sun8i_dwmac_probe(struct platform_device *pdev)
 		return ret;
 	}
 
-	gmac->regmap_field = devm_regmap_field_alloc(dev, regmap,
-						     *gmac->variant->syscon_field);
+	syscon_field = *gmac->variant->syscon_field;
+	ret = of_property_read_u32_index(pdev->dev.of_node, "syscon", 1,
+					 &syscon_idx);
+	if (!ret)
+		syscon_field.reg += syscon_idx * sizeof(u32);
+	gmac->regmap_field = devm_regmap_field_alloc(dev, regmap, syscon_field);
 	if (IS_ERR(gmac->regmap_field)) {
 		ret = PTR_ERR(gmac->regmap_field);
 		dev_err(dev, "Unable to map syscon register: %d\n", ret);
@@ -1263,6 +1269,8 @@ static const struct of_device_id sun8i_dwmac_match[] = {
 		.data = &emac_variant_a64 },
 	{ .compatible = "allwinner,sun50i-h6-emac",
 		.data = &emac_variant_h6 },
+	{ .compatible = "allwinner,sun50i-h616-emac",
+		.data = &emac_variant_h6 },
 	{ }
 };
 MODULE_DEVICE_TABLE(of, sun8i_dwmac_match);
-- 
2.17.5

