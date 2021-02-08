Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D81C31348C
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 15:10:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232160AbhBHOH0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 09:07:26 -0500
Received: from mail.baikalelectronics.com ([87.245.175.226]:57088 "EHLO
        mail.baikalelectronics.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231625AbhBHN6j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 08:58:39 -0500
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
Subject: [PATCH v2 20/24] net: stmmac: dwc-qos: Discard Tx/Rx clocks request
Date:   Mon, 8 Feb 2021 16:56:04 +0300
Message-ID: <20210208135609.7685-21-Sergey.Semin@baikalelectronics.ru>
In-Reply-To: <20210208135609.7685-1-Sergey.Semin@baikalelectronics.ru>
References: <20210208135609.7685-1-Sergey.Semin@baikalelectronics.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: MAIL.baikal.int (192.168.51.25) To mail (192.168.51.25)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since the Tx/Rx clocks with the same names are now requested and
enabled/disabled in the STMMAC DT-based platform config method, there is
no need in duplicating the same procedures in the DWC QoS Eth sub-driver.
Discard it then, but make sure the denoted clocks have been specified
for the platform.

Note also the deprecated clock "phy_ref_clk" have been defined as the Tx
clock in the DWC QoS Eth bindings. Let's use a pointer to the Tx clock
defined in the platform data then instead of the unrelated pclk pointer.

Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
---
 .../stmicro/stmmac/dwmac-dwc-qos-eth.c        | 44 +++++--------------
 1 file changed, 11 insertions(+), 33 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-dwc-qos-eth.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-dwc-qos-eth.c
index b71f0c3faebe..f315ca395e12 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-dwc-qos-eth.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-dwc-qos-eth.c
@@ -31,8 +31,6 @@ struct tegra_eqos {
 	struct reset_control *rst;
 	struct clk *clk_master;
 	struct clk *clk_slave;
-	struct clk *clk_tx;
-	struct clk *clk_rx;
 
 	struct gpio_desc *reset;
 };
@@ -155,7 +153,7 @@ static int dwc_qos_probe(struct platform_device *pdev,
 		goto disable;
 	}
 
-	plat_dat->pclk = clk;
+	plat_dat->tx_clk = clk;
 
 	return 0;
 
@@ -175,8 +173,8 @@ static int dwc_qos_remove(struct platform_device *pdev)
 	 * data so the stmmac_remove_config_dt() method wouldn't have disabled
 	 * the clocks too.
 	 */
-	clk_disable_unprepare(priv->plat->pclk);
-	priv->plat->pclk = NULL;
+	clk_disable_unprepare(priv->plat->tx_clk);
+	priv->plat->tx_clk = NULL;
 
 	clk_disable_unprepare(priv->plat->stmmac_clk);
 	priv->plat->stmmac_clk = NULL;
@@ -197,6 +195,7 @@ static int dwc_qos_remove(struct platform_device *pdev)
 static void tegra_eqos_fix_speed(void *priv, unsigned int speed)
 {
 	struct tegra_eqos *eqos = priv;
+	struct stmmac_priv *sp = netdev_priv(dev_get_drvdata(eqos->dev));
 	unsigned long rate = 125000000;
 	bool needs_calibration = false;
 	u32 value;
@@ -262,7 +261,7 @@ static void tegra_eqos_fix_speed(void *priv, unsigned int speed)
 		writel(value, eqos->regs + AUTO_CAL_CONFIG);
 	}
 
-	err = clk_set_rate(eqos->clk_tx, rate);
+	err = clk_set_rate(sp->plat->tx_clk, rate);
 	if (err < 0)
 		dev_err(eqos->dev, "failed to set TX rate: %d\n", err);
 }
@@ -299,6 +298,11 @@ static int tegra_eqos_probe(struct platform_device *pdev,
 	if (!is_of_node(dev->fwnode))
 		goto bypass_clk_reset_gpio;
 
+	if (!data->tx_clk || !data->rx_clk) {
+		err = -EINVAL;
+		goto error;
+	}
+
 	eqos->clk_master = devm_clk_get(&pdev->dev, "master_bus");
 	if (IS_ERR(eqos->clk_master)) {
 		err = PTR_ERR(eqos->clk_master);
@@ -321,30 +325,10 @@ static int tegra_eqos_probe(struct platform_device *pdev,
 
 	data->stmmac_clk = eqos->clk_slave;
 
-	eqos->clk_rx = devm_clk_get(&pdev->dev, "rx");
-	if (IS_ERR(eqos->clk_rx)) {
-		err = PTR_ERR(eqos->clk_rx);
-		goto disable_slave;
-	}
-
-	err = clk_prepare_enable(eqos->clk_rx);
-	if (err < 0)
-		goto disable_slave;
-
-	eqos->clk_tx = devm_clk_get(&pdev->dev, "tx");
-	if (IS_ERR(eqos->clk_tx)) {
-		err = PTR_ERR(eqos->clk_tx);
-		goto disable_rx;
-	}
-
-	err = clk_prepare_enable(eqos->clk_tx);
-	if (err < 0)
-		goto disable_rx;
-
 	eqos->reset = devm_gpiod_get(&pdev->dev, "phy-reset", GPIOD_OUT_HIGH);
 	if (IS_ERR(eqos->reset)) {
 		err = PTR_ERR(eqos->reset);
-		goto disable_tx;
+		goto disable_slave;
 	}
 
 	usleep_range(2000, 4000);
@@ -385,10 +369,6 @@ static int tegra_eqos_probe(struct platform_device *pdev,
 	reset_control_assert(eqos->rst);
 reset_phy:
 	gpiod_set_value(eqos->reset, 1);
-disable_tx:
-	clk_disable_unprepare(eqos->clk_tx);
-disable_rx:
-	clk_disable_unprepare(eqos->clk_rx);
 disable_slave:
 	clk_disable_unprepare(eqos->clk_slave);
 	data->stmmac_clk = NULL;
@@ -405,8 +385,6 @@ static int tegra_eqos_remove(struct platform_device *pdev)
 
 	reset_control_assert(eqos->rst);
 	gpiod_set_value(eqos->reset, 1);
-	clk_disable_unprepare(eqos->clk_tx);
-	clk_disable_unprepare(eqos->clk_rx);
 	clk_disable_unprepare(eqos->clk_slave);
 	clk_disable_unprepare(eqos->clk_master);
 
-- 
2.29.2

