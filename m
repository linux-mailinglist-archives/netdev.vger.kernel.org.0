Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD869313472
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 15:06:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232051AbhBHOFw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 09:05:52 -0500
Received: from mail.baikalelectronics.com ([87.245.175.226]:57084 "EHLO
        mail.baikalelectronics.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231700AbhBHN6d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 08:58:33 -0500
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
Subject: [PATCH v2 17/24] net: stmmac: dwc-qos: Cleanup STMMAC platform data clock pointers
Date:   Mon, 8 Feb 2021 16:56:01 +0300
Message-ID: <20210208135609.7685-18-Sergey.Semin@baikalelectronics.ru>
In-Reply-To: <20210208135609.7685-1-Sergey.Semin@baikalelectronics.ru>
References: <20210208135609.7685-1-Sergey.Semin@baikalelectronics.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: MAIL.baikal.int (192.168.51.25) To mail (192.168.51.25)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pointers need to be nullified otherwise the stmmac_remove_config_dt()
method called after them being initialized will disable the clocks. That
then will cause a WARN() backtrace being printed since the clocks would be
also disabled in the locally defined remove method.

Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
---
 .../stmicro/stmmac/dwmac-dwc-qos-eth.c        | 42 ++++++++++++++-----
 1 file changed, 32 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-dwc-qos-eth.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-dwc-qos-eth.c
index 27254b27d7ed..20b3696fb776 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-dwc-qos-eth.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-dwc-qos-eth.c
@@ -123,39 +123,46 @@ static int dwc_qos_probe(struct platform_device *pdev,
 			 struct plat_stmmacenet_data *plat_dat,
 			 struct stmmac_resources *stmmac_res)
 {
+	struct clk *clk;
 	int err;
 
-	plat_dat->stmmac_clk = devm_clk_get(&pdev->dev, "apb_pclk");
-	if (IS_ERR(plat_dat->stmmac_clk)) {
+	clk = devm_clk_get(&pdev->dev, "apb_pclk");
+	if (IS_ERR(clk)) {
 		dev_err(&pdev->dev, "apb_pclk clock not found.\n");
-		return PTR_ERR(plat_dat->stmmac_clk);
+		return PTR_ERR(clk);
 	}
 
-	err = clk_prepare_enable(plat_dat->stmmac_clk);
+	err = clk_prepare_enable(clk);
 	if (err < 0) {
 		dev_err(&pdev->dev, "failed to enable apb_pclk clock: %d\n",
 			err);
 		return err;
 	}
 
-	plat_dat->pclk = devm_clk_get(&pdev->dev, "phy_ref_clk");
-	if (IS_ERR(plat_dat->pclk)) {
+	plat_dat->stmmac_clk = clk;
+
+	clk = devm_clk_get(&pdev->dev, "phy_ref_clk");
+	if (IS_ERR(clk)) {
 		dev_err(&pdev->dev, "phy_ref_clk clock not found.\n");
-		err = PTR_ERR(plat_dat->pclk);
+		err = PTR_ERR(clk);
 		goto disable;
 	}
 
-	err = clk_prepare_enable(plat_dat->pclk);
+	err = clk_prepare_enable(clk);
 	if (err < 0) {
 		dev_err(&pdev->dev, "failed to enable phy_ref clock: %d\n",
 			err);
 		goto disable;
 	}
 
+	plat_dat->pclk = clk;
+
 	return 0;
 
 disable:
 	clk_disable_unprepare(plat_dat->stmmac_clk);
+	plat_dat->stmmac_clk = NULL;
+
 	return err;
 }
 
@@ -164,8 +171,15 @@ static int dwc_qos_remove(struct platform_device *pdev)
 	struct net_device *ndev = platform_get_drvdata(pdev);
 	struct stmmac_priv *priv = netdev_priv(ndev);
 
+	/* Cleanup the pointers to the clock handlers hidden in the platform
+	 * data so the stmmac_remove_config_dt() method wouldn't have disabled
+	 * the clocks too.
+	 */
 	clk_disable_unprepare(priv->plat->pclk);
+	priv->plat->pclk = NULL;
+
 	clk_disable_unprepare(priv->plat->stmmac_clk);
+	priv->plat->stmmac_clk = NULL;
 
 	return 0;
 }
@@ -301,12 +315,12 @@ static int tegra_eqos_probe(struct platform_device *pdev,
 		goto disable_master;
 	}
 
-	data->stmmac_clk = eqos->clk_slave;
-
 	err = clk_prepare_enable(eqos->clk_slave);
 	if (err < 0)
 		goto disable_master;
 
+	data->stmmac_clk = eqos->clk_slave;
+
 	eqos->clk_rx = devm_clk_get(&pdev->dev, "rx");
 	if (IS_ERR(eqos->clk_rx)) {
 		err = PTR_ERR(eqos->clk_rx);
@@ -377,6 +391,7 @@ static int tegra_eqos_probe(struct platform_device *pdev,
 	clk_disable_unprepare(eqos->clk_rx);
 disable_slave:
 	clk_disable_unprepare(eqos->clk_slave);
+	data->stmmac_clk = NULL;
 disable_master:
 	clk_disable_unprepare(eqos->clk_master);
 error:
@@ -385,6 +400,7 @@ static int tegra_eqos_probe(struct platform_device *pdev,
 
 static int tegra_eqos_remove(struct platform_device *pdev)
 {
+	struct stmmac_priv *priv = netdev_priv(platform_get_drvdata(pdev));
 	struct tegra_eqos *eqos = get_stmmac_bsp_priv(&pdev->dev);
 
 	reset_control_assert(eqos->rst);
@@ -394,6 +410,12 @@ static int tegra_eqos_remove(struct platform_device *pdev)
 	clk_disable_unprepare(eqos->clk_slave);
 	clk_disable_unprepare(eqos->clk_master);
 
+	/* Cleanup the pointers to the clock handlers hidden in the platform
+	 * data so the stmmac_remove_config_dt() method wouldn't have disabled
+	 * the clocks too.
+	 */
+	priv->plat->stmmac_clk = NULL;
+
 	return 0;
 }
 
-- 
2.29.2

