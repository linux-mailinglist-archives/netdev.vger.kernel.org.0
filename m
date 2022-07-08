Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1E7356B3E8
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 09:57:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237301AbiGHH4v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 03:56:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237351AbiGHH4p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 03:56:45 -0400
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D4157E00B;
        Fri,  8 Jul 2022 00:56:44 -0700 (PDT)
X-UUID: 9d0cc1b69b764816a7482ae4427ec87e-20220708
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.8,REQID:ad16ed64-be1a-4e93-9007-fd5a7875f4d1,OB:0,LO
        B:0,IP:0,URL:0,TC:0,Content:-5,EDM:0,RT:0,SF:100,FILE:0,RULE:Release_Ham,A
        CTION:release,TS:95
X-CID-INFO: VERSION:1.1.8,REQID:ad16ed64-be1a-4e93-9007-fd5a7875f4d1,OB:0,LOB:
        0,IP:0,URL:0,TC:0,Content:-5,EDM:0,RT:0,SF:100,FILE:0,RULE:Spam_GS981B3D,A
        CTION:quarantine,TS:95
X-CID-META: VersionHash:0f94e32,CLOUDID:f48ac263-0b3f-4b2c-b3a6-ed5c044366a0,C
        OID:548fac83f2ca,Recheck:0,SF:28|17|19|48,TC:nil,Content:0,EDM:-3,IP:nil,U
        RL:0,File:nil,QS:nil,BEC:nil,COL:0
X-UUID: 9d0cc1b69b764816a7482ae4427ec87e-20220708
Received: from mtkcas11.mediatek.inc [(172.21.101.40)] by mailgw01.mediatek.com
        (envelope-from <biao.huang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 807428127; Fri, 08 Jul 2022 15:56:38 +0800
Received: from mtkcas10.mediatek.inc (172.21.101.39) by
 mtkmbs11n1.mediatek.inc (172.21.101.185) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.792.3;
 Fri, 8 Jul 2022 15:56:36 +0800
Received: from localhost.localdomain (10.17.3.154) by mtkcas10.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 8 Jul 2022 15:56:35 +0800
From:   Biao Huang <biao.huang@mediatek.com>
To:     David Miller <davem@davemloft.net>
CC:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Biao Huang <biao.huang@mediatek.com>, <netdev@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>, <macpaul.lin@mediatek.com>
Subject: [PATCH net v2] stmmac: dwmac-mediatek: fix clock issue
Date:   Fri, 8 Jul 2022 15:56:22 +0800
Message-ID: <20220708075622.26342-2-biao.huang@mediatek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220708075622.26342-1-biao.huang@mediatek.com>
References: <20220708075622.26342-1-biao.huang@mediatek.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-MTK:  N
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since clocks are handled in mediatek_dwmac_clks_config(),
remove the clocks configuration in init()/exit(), and
invoke mediatek_dwmac_clks_config instead.

This issue is found in suspend/resume test.

Fixes: 3186bdad97d5 ("stmmac: dwmac-mediatek: add platform level clocks management")
Signed-off-by: Biao Huang <biao.huang@mediatek.com>
---
 .../ethernet/stmicro/stmmac/dwmac-mediatek.c  | 32 ++++++-------------
 1 file changed, 10 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c
index 6ff88df58767..6d82cf2658e0 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c
@@ -576,32 +576,12 @@ static int mediatek_dwmac_init(struct platform_device *pdev, void *priv)
 		}
 	}
 
-	ret = clk_bulk_prepare_enable(variant->num_clks, plat->clks);
-	if (ret) {
-		dev_err(plat->dev, "failed to enable clks, err = %d\n", ret);
-		return ret;
-	}
-
-	ret = clk_prepare_enable(plat->rmii_internal_clk);
-	if (ret) {
-		dev_err(plat->dev, "failed to enable rmii internal clk, err = %d\n", ret);
-		goto err_clk;
-	}
-
 	return 0;
-
-err_clk:
-	clk_bulk_disable_unprepare(variant->num_clks, plat->clks);
-	return ret;
 }
 
 static void mediatek_dwmac_exit(struct platform_device *pdev, void *priv)
 {
-	struct mediatek_dwmac_plat_data *plat = priv;
-	const struct mediatek_dwmac_variant *variant = plat->variant;
-
-	clk_disable_unprepare(plat->rmii_internal_clk);
-	clk_bulk_disable_unprepare(variant->num_clks, plat->clks);
+	/* nothing to do now */
 }
 
 static int mediatek_dwmac_clks_config(void *priv, bool enabled)
@@ -712,13 +692,21 @@ static int mediatek_dwmac_probe(struct platform_device *pdev)
 	mediatek_dwmac_common_data(pdev, plat_dat, priv_plat);
 	mediatek_dwmac_init(pdev, priv_plat);
 
+	ret = mediatek_dwmac_clks_config(priv_plat, true);
+	if (ret)
+		return ret;
+
 	ret = stmmac_dvr_probe(&pdev->dev, plat_dat, &stmmac_res);
 	if (ret) {
 		stmmac_remove_config_dt(pdev, plat_dat);
-		return ret;
+		goto err_drv_probe;
 	}
 
 	return 0;
+
+err_drv_probe:
+	mediatek_dwmac_clks_config(priv_plat, false);
+	return ret;
 }
 
 static const struct of_device_id mediatek_dwmac_match[] = {
-- 
2.25.1

