Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A4C249029A
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 08:08:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237324AbiAQHHS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 02:07:18 -0500
Received: from mailgw01.mediatek.com ([60.244.123.138]:34772 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S237337AbiAQHHR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 02:07:17 -0500
X-UUID: 83277a851b4247c9bbe8fef816612d07-20220117
X-UUID: 83277a851b4247c9bbe8fef816612d07-20220117
Received: from mtkcas11.mediatek.inc [(172.21.101.40)] by mailgw01.mediatek.com
        (envelope-from <biao.huang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1366020677; Mon, 17 Jan 2022 15:07:13 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.792.3;
 Mon, 17 Jan 2022 15:07:12 +0800
Received: from localhost.localdomain (10.17.3.154) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 17 Jan 2022 15:07:11 +0800
From:   Biao Huang <biao.huang@mediatek.com>
To:     <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        <angelogioacchino.delregno@collabora.com>
CC:     Matthias Brugger <matthias.bgg@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Biao Huang <biao.huang@mediatek.com>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <srv_heupstream@mediatek.com>, <macpaul.lin@mediatek.com>,
        <dkirjanov@suse.de>
Subject: [PATCH net-next v12 2/7] stmmac: dwmac-mediatek: Reuse more common features
Date:   Mon, 17 Jan 2022 15:07:01 +0800
Message-ID: <20220117070706.17853-3-biao.huang@mediatek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220117070706.17853-1-biao.huang@mediatek.com>
References: <20220117070706.17853-1-biao.huang@mediatek.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-MTK:  N
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch makes dwmac-mediatek reuse more features
supported by stmmac_platform.c.

Signed-off-by: Biao Huang <biao.huang@mediatek.com>
Acked-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
---
 .../ethernet/stmicro/stmmac/dwmac-mediatek.c  | 32 +++++++++----------
 1 file changed, 15 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c
index 0ff57c268dca..8747aa4403e8 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c
@@ -334,22 +334,20 @@ static int mediatek_dwmac_init(struct platform_device *pdev, void *priv)
 	const struct mediatek_dwmac_variant *variant = plat->variant;
 	int ret;
 
-	ret = dma_set_mask_and_coherent(plat->dev, DMA_BIT_MASK(variant->dma_bit_mask));
-	if (ret) {
-		dev_err(plat->dev, "No suitable DMA available, err = %d\n", ret);
-		return ret;
-	}
-
-	ret = variant->dwmac_set_phy_interface(plat);
-	if (ret) {
-		dev_err(plat->dev, "failed to set phy interface, err = %d\n", ret);
-		return ret;
+	if (variant->dwmac_set_phy_interface) {
+		ret = variant->dwmac_set_phy_interface(plat);
+		if (ret) {
+			dev_err(plat->dev, "failed to set phy interface, err = %d\n", ret);
+			return ret;
+		}
 	}
 
-	ret = variant->dwmac_set_delay(plat);
-	if (ret) {
-		dev_err(plat->dev, "failed to set delay value, err = %d\n", ret);
-		return ret;
+	if (variant->dwmac_set_delay) {
+		ret = variant->dwmac_set_delay(plat);
+		if (ret) {
+			dev_err(plat->dev, "failed to set delay value, err = %d\n", ret);
+			return ret;
+		}
 	}
 
 	ret = clk_bulk_prepare_enable(plat->num_clks_to_config, plat->clks);
@@ -422,15 +420,15 @@ static int mediatek_dwmac_probe(struct platform_device *pdev)
 		return PTR_ERR(plat_dat);
 
 	plat_dat->interface = priv_plat->phy_mode;
-	plat_dat->has_gmac4 = 1;
-	plat_dat->has_gmac = 0;
-	plat_dat->pmt = 0;
+	plat_dat->use_phy_wol = 1;
 	plat_dat->riwt_off = 1;
 	plat_dat->maxmtu = ETH_DATA_LEN;
+	plat_dat->addr64 = priv_plat->variant->dma_bit_mask;
 	plat_dat->bsp_priv = priv_plat;
 	plat_dat->init = mediatek_dwmac_init;
 	plat_dat->exit = mediatek_dwmac_exit;
 	plat_dat->clks_config = mediatek_dwmac_clks_config;
+
 	mediatek_dwmac_init(pdev, priv_plat);
 
 	ret = stmmac_dvr_probe(&pdev->dev, plat_dat, &stmmac_res);
-- 
2.25.1

