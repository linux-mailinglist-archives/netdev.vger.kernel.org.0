Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16C2F2D952F
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 10:27:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439606AbgLNJXd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 04:23:33 -0500
Received: from ns2.baikalelectronics.com ([94.125.187.42]:46530 "EHLO
        mail.baikalelectronics.ru" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2439736AbgLNJSQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 04:18:16 -0500
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
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
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
Subject: [PATCH 22/25] net: stmmac: dwmac-imx: Discard Tx clock request
Date:   Mon, 14 Dec 2020 12:16:12 +0300
Message-ID: <20201214091616.13545-23-Sergey.Semin@baikalelectronics.ru>
In-Reply-To: <20201214091616.13545-1-Sergey.Semin@baikalelectronics.ru>
References: <20201214091616.13545-1-Sergey.Semin@baikalelectronics.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: MAIL.baikal.int (192.168.51.25) To mail (192.168.51.25)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since the Tx clock is now requested and enabled/disabled in the STMMAC
DT-based platform config method, there is no need in duplicating the same
procedures in the DW MAC iMX sub-driver.

Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
---
 .../net/ethernet/stmicro/stmmac/dwmac-imx.c   | 21 +++++--------------
 1 file changed, 5 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-imx.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-imx.c
index efef5476a577..7b4590670b4e 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-imx.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-imx.c
@@ -40,7 +40,6 @@ struct imx_dwmac_ops {
 
 struct imx_priv_data {
 	struct device *dev;
-	struct clk *clk_tx;
 	struct clk *clk_mem;
 	struct regmap *intf_regmap;
 	u32 intf_reg_off;
@@ -104,12 +103,6 @@ static int imx_dwmac_init(struct platform_device *pdev, void *priv)
 		return ret;
 	}
 
-	ret = clk_prepare_enable(dwmac->clk_tx);
-	if (ret) {
-		dev_err(&pdev->dev, "tx clock enable failed\n");
-		goto clk_tx_en_failed;
-	}
-
 	if (dwmac->ops->set_intf_mode) {
 		ret = dwmac->ops->set_intf_mode(plat_dat);
 		if (ret)
@@ -119,8 +112,6 @@ static int imx_dwmac_init(struct platform_device *pdev, void *priv)
 	return 0;
 
 intf_mode_failed:
-	clk_disable_unprepare(dwmac->clk_tx);
-clk_tx_en_failed:
 	clk_disable_unprepare(dwmac->clk_mem);
 	return ret;
 }
@@ -129,7 +120,6 @@ static void imx_dwmac_exit(struct platform_device *pdev, void *priv)
 {
 	struct imx_priv_data *dwmac = priv;
 
-	clk_disable_unprepare(dwmac->clk_tx);
 	clk_disable_unprepare(dwmac->clk_mem);
 }
 
@@ -162,7 +152,7 @@ static void imx_dwmac_fix_speed(void *priv, unsigned int speed)
 		return;
 	}
 
-	err = clk_set_rate(dwmac->clk_tx, rate);
+	err = clk_set_rate(plat_dat->tx_clk, rate);
 	if (err < 0)
 		dev_err(dwmac->dev, "failed to set tx rate %lu\n", rate);
 }
@@ -176,10 +166,9 @@ imx_dwmac_parse_dt(struct imx_priv_data *dwmac, struct device *dev)
 	if (of_get_property(np, "snps,rmii_refclk_ext", NULL))
 		dwmac->rmii_refclk_ext = true;
 
-	dwmac->clk_tx = devm_clk_get(dev, "tx");
-	if (IS_ERR(dwmac->clk_tx)) {
-		dev_err(dev, "failed to get tx clock\n");
-		return PTR_ERR(dwmac->clk_tx);
+	if (!dwmac->plat_dat->tx_clk) {
+		dev_err(dev, "no tx clock found\n");
+		return -EINVAL;
 	}
 
 	dwmac->clk_mem = NULL;
@@ -239,6 +228,7 @@ static int imx_dwmac_probe(struct platform_device *pdev)
 
 	dwmac->ops = data;
 	dwmac->dev = &pdev->dev;
+	dwmac->plat_dat = plat_dat;
 
 	ret = imx_dwmac_parse_dt(dwmac, &pdev->dev);
 	if (ret) {
@@ -257,7 +247,6 @@ static int imx_dwmac_probe(struct platform_device *pdev)
 	plat_dat->exit = imx_dwmac_exit;
 	plat_dat->fix_mac_speed = imx_dwmac_fix_speed;
 	plat_dat->bsp_priv = dwmac;
-	dwmac->plat_dat = plat_dat;
 
 	ret = imx_dwmac_init(pdev, dwmac);
 	if (ret)
-- 
2.29.2

