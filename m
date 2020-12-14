Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5154F2D94DD
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 10:18:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439790AbgLNJS1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 04:18:27 -0500
Received: from ns2.baikalchip.ru ([94.125.187.42]:46524 "EHLO
        mail.baikalelectronics.ru" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2439675AbgLNJSB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 04:18:01 -0500
From:   Serge Semin <Sergey.Semin@baikalelectronics.ru>
To:     Rob Herring <robh+dt@kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hovold <johan@kernel.org>,
        Maxime Ripard <mripard@kernel.org>,
        Joao Pinto <jpinto@synopsys.com>,
        Lars Persson <larper@axis.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
CC:     Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        Serge Semin <fancer.lancer@gmail.com>,
        Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>,
        Pavel Parkhomenko <Pavel.Parkhomenko@baikalelectronics.ru>,
        Vyacheslav Mitrofanov 
        <Vyacheslav.Mitrofanov@baikalelectronics.ru>,
        <netdev@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 12/25] net: stmmac: Directly call reverse methods in stmmac_probe_config_dt()
Date:   Mon, 14 Dec 2020 12:16:02 +0300
Message-ID: <20201214091616.13545-13-Sergey.Semin@baikalelectronics.ru>
In-Reply-To: <20201214091616.13545-1-Sergey.Semin@baikalelectronics.ru>
References: <20201214091616.13545-1-Sergey.Semin@baikalelectronics.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: MAIL.baikal.int (192.168.51.25) To mail (192.168.51.25)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Calling an antagonistic method from the corresponding protagonist isn't
good from maintainability point of view, since prevents us from directly
adding a functionality in the later, which needs to be reverted in the
former. Since that's what we are about to do in order to fix the commit
573c0b9c4e0 ("stmmac: move stmmac_clk, pclk, clk_ptp_ref and stmmac_rst to
platform structure"), let's replace the stmmac_remove_config_dt() method
invocation in stmmac_probe_config_dt() with direct reversal procedures.

Fixes: f573c0b9c4e0 ("stmmac: move stmmac_clk, pclk, clk_ptp_ref and stmmac_rst to platform structure")
Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
---
 .../ethernet/stmicro/stmmac/stmmac_platform.c | 26 ++++++++++++-------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
index b4720e477d90..5110545090d2 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
@@ -457,7 +457,7 @@ stmmac_probe_config_dt(struct platform_device *pdev, const char **mac)
 	/* To Configure PHY by using all device-tree supported properties */
 	rc = stmmac_dt_phy(plat, np, &pdev->dev);
 	if (rc)
-		return ERR_PTR(rc);
+		goto error_dt_phy_parse;
 
 	of_property_read_u32(np, "tx-fifo-depth", &plat->tx_fifo_size);
 
@@ -535,8 +535,8 @@ stmmac_probe_config_dt(struct platform_device *pdev, const char **mac)
 	dma_cfg = devm_kzalloc(&pdev->dev, sizeof(*dma_cfg),
 			       GFP_KERNEL);
 	if (!dma_cfg) {
-		stmmac_remove_config_dt(pdev, plat);
-		return ERR_PTR(-ENOMEM);
+		rc = -ENOMEM;
+		goto error_dma_cfg_alloc;
 	}
 	plat->dma_cfg = dma_cfg;
 
@@ -563,10 +563,8 @@ stmmac_probe_config_dt(struct platform_device *pdev, const char **mac)
 	plat->axi = stmmac_axi_setup(pdev);
 
 	rc = stmmac_mtl_setup(pdev, plat);
-	if (rc) {
-		stmmac_remove_config_dt(pdev, plat);
-		return ERR_PTR(rc);
-	}
+	if (rc)
+		goto error_dma_cfg_alloc;
 
 	/* clock setup */
 	if (!of_device_is_compatible(np, "snps,dwc-qos-ethernet-4.10")) {
@@ -581,8 +579,10 @@ stmmac_probe_config_dt(struct platform_device *pdev, const char **mac)
 
 	plat->pclk = devm_clk_get(&pdev->dev, "pclk");
 	if (IS_ERR(plat->pclk)) {
-		if (PTR_ERR(plat->pclk) == -EPROBE_DEFER)
+		if (PTR_ERR(plat->pclk) == -EPROBE_DEFER) {
+			rc = PTR_ERR(plat->pclk);
 			goto error_pclk_get;
+		}
 
 		plat->pclk = NULL;
 	}
@@ -602,8 +602,10 @@ stmmac_probe_config_dt(struct platform_device *pdev, const char **mac)
 	plat->stmmac_rst = devm_reset_control_get(&pdev->dev,
 						  STMMAC_RESOURCE_NAME);
 	if (IS_ERR(plat->stmmac_rst)) {
-		if (PTR_ERR(plat->stmmac_rst) == -EPROBE_DEFER)
+		if (PTR_ERR(plat->stmmac_rst) == -EPROBE_DEFER) {
+			rc = PTR_ERR(plat->stmmac_rst);
 			goto error_hw_init;
+		}
 
 		dev_info(&pdev->dev, "no reset control found\n");
 		plat->stmmac_rst = NULL;
@@ -615,8 +617,12 @@ stmmac_probe_config_dt(struct platform_device *pdev, const char **mac)
 	clk_disable_unprepare(plat->pclk);
 error_pclk_get:
 	clk_disable_unprepare(plat->stmmac_clk);
+error_dma_cfg_alloc:
+	of_node_put(plat->mdio_node);
+error_dt_phy_parse:
+	of_node_put(plat->phy_node);
 
-	return ERR_PTR(-EPROBE_DEFER);
+	return ERR_PTR(rc);
 }
 
 /**
-- 
2.29.2

