Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 917C46DAC0B
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 13:05:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240640AbjDGLE6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 07:04:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240588AbjDGLEc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 07:04:32 -0400
Received: from ex01.ufhost.com (ex01.ufhost.com [61.152.239.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CE6CAF28;
        Fri,  7 Apr 2023 04:04:11 -0700 (PDT)
Received: from EXMBX165.cuchost.com (unknown [175.102.18.54])
        (using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "EXMBX165", Issuer "EXMBX165" (not verified))
        by ex01.ufhost.com (Postfix) with ESMTP id 9BA1724E2AB;
        Fri,  7 Apr 2023 19:04:05 +0800 (CST)
Received: from EXMBX162.cuchost.com (172.16.6.72) by EXMBX165.cuchost.com
 (172.16.6.75) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Fri, 7 Apr
 2023 19:04:05 +0800
Received: from starfive-sdk.starfivetech.com (171.223.208.138) by
 EXMBX162.cuchost.com (172.16.6.72) with Microsoft SMTP Server (TLS) id
 15.0.1497.42; Fri, 7 Apr 2023 19:04:04 +0800
From:   Samin Guo <samin.guo@starfivetech.com>
To:     <linux-kernel@vger.kernel.org>, <linux-riscv@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Pedro Moreira <pmmoreir@synopsys.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Conor Dooley <conor@kernel.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Peter Geis <pgwipeout@gmail.com>,
        Yanhong Wang <yanhong.wang@starfivetech.com>,
        Samin Guo <samin.guo@starfivetech.com>,
        Tommaso Merciai <tomm.merciai@gmail.com>
Subject: [-net-next v11 6/6] net: stmmac: starfive-dmac: Add phy interface settings
Date:   Fri, 7 Apr 2023 19:03:56 +0800
Message-ID: <20230407110356.8449-7-samin.guo@starfivetech.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230407110356.8449-1-samin.guo@starfivetech.com>
References: <20230407110356.8449-1-samin.guo@starfivetech.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [171.223.208.138]
X-ClientProxiedBy: EXCAS066.cuchost.com (172.16.6.26) To EXMBX162.cuchost.com
 (172.16.6.72)
X-YovoleRuleAgent: yovoleflag
X-Spam-Status: No, score=0.0 required=5.0 tests=SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

dwmac supports multiple modess. When working under rmii and rgmii,
you need to set different phy interfaces.

According to the dwmac document, when working in rmii, it needs to be
set to 0x4, and rgmii needs to be set to 0x1.

The phy interface needs to be set in syscon, the format is as follows:
starfive,syscon: <&syscon, offset, shift>

Tested-by: Tommaso Merciai <tomm.merciai@gmail.com>
Signed-off-by: Samin Guo <samin.guo@starfivetech.com>
---
 .../ethernet/stmicro/stmmac/dwmac-starfive.c  | 48 +++++++++++++++++++
 1 file changed, 48 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-starfive.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-starfive.c
index 4963d4008485..d6a1eddb51e8 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-starfive.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-starfive.c
@@ -13,6 +13,10 @@
 
 #include "stmmac_platform.h"
 
+#define STARFIVE_DWMAC_PHY_INFT_RGMII	0x1
+#define STARFIVE_DWMAC_PHY_INFT_RMII	0x4
+#define STARFIVE_DWMAC_PHY_INFT_FIELD	0x7U
+
 struct starfive_dwmac {
 	struct device *dev;
 	struct clk *clk_tx;
@@ -46,6 +50,46 @@ static void starfive_dwmac_fix_mac_speed(void *priv, unsigned int speed)
 		dev_err(dwmac->dev, "failed to set tx rate %lu\n", rate);
 }
 
+static int starfive_dwmac_set_mode(struct plat_stmmacenet_data *plat_dat)
+{
+	struct starfive_dwmac *dwmac = plat_dat->bsp_priv;
+	struct regmap *regmap;
+	unsigned int args[2];
+	unsigned int mode;
+	int err;
+
+	switch (plat_dat->interface) {
+	case PHY_INTERFACE_MODE_RMII:
+		mode = STARFIVE_DWMAC_PHY_INFT_RMII;
+		break;
+
+	case PHY_INTERFACE_MODE_RGMII:
+	case PHY_INTERFACE_MODE_RGMII_ID:
+		mode = STARFIVE_DWMAC_PHY_INFT_RGMII;
+		break;
+
+	default:
+		dev_err(dwmac->dev, "unsupported interface %d\n",
+			plat_dat->interface);
+		return -EINVAL;
+	}
+
+	regmap = syscon_regmap_lookup_by_phandle_args(dwmac->dev->of_node,
+						      "starfive,syscon",
+						      2, args);
+	if (IS_ERR(regmap))
+		return dev_err_probe(dwmac->dev, PTR_ERR(regmap), "syscon regmap failed\n");
+
+	/* args[0]:offset  args[1]: shift */
+	err = regmap_update_bits(regmap, args[0],
+				 STARFIVE_DWMAC_PHY_INFT_FIELD << args[1],
+				 mode << args[1]);
+	if (err)
+		return dev_err_probe(dwmac->dev, err, "error setting phy mode\n");
+
+	return 0;
+}
+
 static int starfive_dwmac_probe(struct platform_device *pdev)
 {
 	struct plat_stmmacenet_data *plat_dat;
@@ -91,6 +135,10 @@ static int starfive_dwmac_probe(struct platform_device *pdev)
 	plat_dat->bsp_priv = dwmac;
 	plat_dat->dma_cfg->dche = true;
 
+	err = starfive_dwmac_set_mode(plat_dat);
+	if (err)
+		return err;
+
 	err = stmmac_dvr_probe(&pdev->dev, plat_dat, &stmmac_res);
 	if (err) {
 		stmmac_remove_config_dt(pdev, plat_dat);
-- 
2.17.1

