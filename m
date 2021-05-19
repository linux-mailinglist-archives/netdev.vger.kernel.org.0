Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55072388BC7
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 12:42:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348831AbhESKnv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 06:43:51 -0400
Received: from foss.arm.com ([217.140.110.172]:58980 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348574AbhESKno (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 May 2021 06:43:44 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B80451424;
        Wed, 19 May 2021 03:42:24 -0700 (PDT)
Received: from localhost.localdomain (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 460703F719;
        Wed, 19 May 2021 03:42:22 -0700 (PDT)
From:   Andre Przywara <andre.przywara@arm.com>
To:     Maxime Ripard <mripard@kernel.org>, Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>
Cc:     Rob Herring <robh@kernel.org>, Icenowy Zheng <icenowy@aosc.io>,
        Samuel Holland <samuel@sholland.org>,
        Ondrej Jirman <megous@megous.com>,
        linux-arm-kernel@lists.infradead.org, linux-sunxi@googlegroups.com,
        linux-sunxi@lists.linux.dev, linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>
Subject: [PATCH v6 07/17] net: stmmac: dwmac-sun8i: Prepare for second EMAC clock register
Date:   Wed, 19 May 2021 11:41:42 +0100
Message-Id: <20210519104152.21119-8-andre.przywara@arm.com>
X-Mailer: git-send-email 2.14.1
In-Reply-To: <20210519104152.21119-1-andre.przywara@arm.com>
References: <20210519104152.21119-1-andre.przywara@arm.com>
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
index 4422baeed3d8..5f3fefd9a74e 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
@@ -1147,11 +1147,13 @@ static int sun8i_dwmac_probe(struct platform_device *pdev)
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
@@ -1209,8 +1211,12 @@ static int sun8i_dwmac_probe(struct platform_device *pdev)
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
@@ -1330,6 +1336,8 @@ static const struct of_device_id sun8i_dwmac_match[] = {
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

