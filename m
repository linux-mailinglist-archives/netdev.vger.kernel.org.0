Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A2A02D9520
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 10:27:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391198AbgLNJXP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 04:23:15 -0500
Received: from mx.baikalelectronics.com ([94.125.187.42]:46522 "EHLO
        mail.baikalelectronics.ru" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2439741AbgLNJSO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 04:18:14 -0500
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
Subject: [PATCH 25/25] net: stmmac: dwc-qos: Save master/slave clocks in the plat-data
Date:   Mon, 14 Dec 2020 12:16:15 +0300
Message-ID: <20201214091616.13545-26-Sergey.Semin@baikalelectronics.ru>
In-Reply-To: <20201214091616.13545-1-Sergey.Semin@baikalelectronics.ru>
References: <20201214091616.13545-1-Sergey.Semin@baikalelectronics.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: MAIL.baikal.int (192.168.51.25) To mail (192.168.51.25)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently the "master_bus" clock of the DW QoS Eth controller isn't
preserved in the STMMAC platform data, while the "slave_bus" clock is
assigned to the stmmaceth clock pointer. It isn't correct from the
platform clock bindings point of view. The "stmmaceth" clock is supposed
to be the system clock, which is responsible for clocking the DMA
transfers from/to the controller FIFOs to/from the system memory and the
CSR interface if the later isn't separately clocked. If it's clocked
separately then the STMMAC platform code expects to also have "pclk"
specified. So in order to have the STMMAC platform data properly
initialized we need to set the "master_bus" clock handler to the
"stmmaceth" clock pointer, and the "slave_bus" clock handler to the "pclk"
clock pointer.

Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-dwc-qos-eth.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-dwc-qos-eth.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-dwc-qos-eth.c
index f53a78448988..b90d7e4c3d4a 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-dwc-qos-eth.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-dwc-qos-eth.c
@@ -315,6 +315,8 @@ static void *tegra_eqos_probe(struct platform_device *pdev,
 	if (err < 0)
 		goto error;
 
+	data->stmmac_clk = eqos->clk_master;
+
 	eqos->clk_slave = devm_clk_get(&pdev->dev, "slave_bus");
 	if (IS_ERR(eqos->clk_slave)) {
 		err = PTR_ERR(eqos->clk_slave);
@@ -325,7 +327,7 @@ static void *tegra_eqos_probe(struct platform_device *pdev,
 	if (err < 0)
 		goto disable_master;
 
-	data->stmmac_clk = eqos->clk_slave;
+	data->pclk = eqos->clk_slave;
 
 	eqos->reset = devm_gpiod_get(&pdev->dev, "phy-reset", GPIOD_OUT_HIGH);
 	if (IS_ERR(eqos->reset)) {
@@ -375,9 +377,10 @@ static void *tegra_eqos_probe(struct platform_device *pdev,
 	gpiod_set_value(eqos->reset, 1);
 disable_slave:
 	clk_disable_unprepare(eqos->clk_slave);
-	data->stmmac_clk = NULL;
+	data->pclk = NULL;
 disable_master:
 	clk_disable_unprepare(eqos->clk_master);
+	data->stmmac_clk = NULL;
 error:
 	eqos = ERR_PTR(err);
 	goto out;
@@ -397,6 +400,7 @@ static int tegra_eqos_remove(struct platform_device *pdev)
 	 * data so the stmmac_remove_config_dt() method wouldn't have disabled
 	 * the clocks too.
 	 */
+	priv->plat->pclk = NULL;
 	priv->plat->stmmac_clk = NULL;
 
 	return 0;
-- 
2.29.2

