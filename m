Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A79A556B29F
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 08:19:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237276AbiGHGRr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 02:17:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237234AbiGHGRq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 02:17:46 -0400
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B9D8286C1;
        Thu,  7 Jul 2022 23:17:45 -0700 (PDT)
X-UUID: 0daa25fbe8784c6386033eda5b0a8f1d-20220708
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.8,REQID:af16601a-ab07-4aab-8f8e-5eb3de155d31,OB:0,LO
        B:0,IP:0,URL:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,RULE:Release_Ham,ACT
        ION:release,TS:-5
X-CID-META: VersionHash:0f94e32,CLOUDID:55f7f1d6-5d6d-4eaf-a635-828a3ee48b7c,C
        OID:IGNORED,Recheck:0,SF:nil,TC:nil,Content:0,EDM:-3,IP:nil,URL:0,File:nil
        ,QS:nil,BEC:nil,COL:0
X-UUID: 0daa25fbe8784c6386033eda5b0a8f1d-20220708
Received: from mtkmbs11n1.mediatek.inc [(172.21.101.185)] by mailgw01.mediatek.com
        (envelope-from <biao.huang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 664087621; Fri, 08 Jul 2022 14:17:41 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
 mtkmbs11n1.mediatek.inc (172.21.101.185) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.792.3;
 Fri, 8 Jul 2022 14:17:39 +0800
Received: from localhost.localdomain (10.17.3.154) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 8 Jul 2022 14:17:38 +0800
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
Subject: [PATCH net] stmmac: dwmac-mediatek: fix clock issue
Date:   Fri, 8 Jul 2022 14:17:33 +0800
Message-ID: <20220708061733.24916-1-biao.huang@mediatek.com>
X-Mailer: git-send-email 2.25.1
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
remove the duplicated clocks configuration in init()/exit().

This issue is found in suspend/resume test.

Fixes: 3186bdad97d5 ("stmmac: dwmac-mediatek: add platform level clocks management")
Signed-off-by: Biao Huang <biao.huang@mediatek.com>
---
 .../ethernet/stmicro/stmmac/dwmac-mediatek.c  | 22 +------------------
 1 file changed, 1 insertion(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c
index 6ff88df58767..8eaaf14047b4 100644
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
-- 
2.25.1

