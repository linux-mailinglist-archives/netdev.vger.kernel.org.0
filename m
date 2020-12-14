Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39F252D94DF
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 10:18:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439806AbgLNJSd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 04:18:33 -0500
Received: from mx.baikalchip.com ([94.125.187.42]:46514 "EHLO
        mail.baikalelectronics.ru" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729467AbgLNJSM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 04:18:12 -0500
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
Subject: [PATCH 20/25] net: stmmac: Add Tx/Rx platform clocks support
Date:   Mon, 14 Dec 2020 12:16:10 +0300
Message-ID: <20201214091616.13545-21-Sergey.Semin@baikalelectronics.ru>
In-Reply-To: <20201214091616.13545-1-Sergey.Semin@baikalelectronics.ru>
References: <20201214091616.13545-1-Sergey.Semin@baikalelectronics.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: MAIL.baikal.int (192.168.51.25) To mail (192.168.51.25)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Depending on the DW *MAC configuration it can be at least connected to an
external Transmit clock, but in some cases to an external Receive clock
generator. In order to simplify/unify the sub-drivers code and to prevent
having the same clocks named differently add the Tx/Rx clocks support to
the generic STMMAC DT-based platform data initialization method under the
names "tx" and "rx" respectively. The bindings schema has already been
altered in accordance with that.

Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
---
 .../ethernet/stmicro/stmmac/stmmac_platform.c | 24 +++++++++++++++++++
 include/linux/stmmac.h                        |  2 ++
 2 files changed, 26 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
index 38e8836861c4..943498d57e3a 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
@@ -588,6 +588,24 @@ stmmac_probe_config_dt(struct platform_device *pdev, const char **mac)
 
 	clk_prepare_enable(plat->pclk);
 
+	plat->tx_clk = devm_clk_get_optional(&pdev->dev, "tx");
+	if (IS_ERR(plat->tx_clk)) {
+		rc = PTR_ERR(plat->tx_clk);
+		dev_err_probe(&pdev->dev, rc, "Cannot get Tx clock\n");
+		goto error_tx_clk_get;
+	}
+
+	clk_prepare_enable(plat->tx_clk);
+
+	plat->rx_clk = devm_clk_get_optional(&pdev->dev, "rx");
+	if (IS_ERR(plat->rx_clk)) {
+		rc = PTR_ERR(plat->rx_clk);
+		dev_err_probe(&pdev->dev, rc, "Cannot get Rx clock\n");
+		goto error_rx_clk_get;
+	}
+
+	clk_prepare_enable(plat->rx_clk);
+
 	/* Fall-back to main clock in case of no PTP ref is passed */
 	plat->clk_ptp_ref = devm_clk_get_optional(&pdev->dev, "ptp_ref");
 	if (IS_ERR(plat->clk_ptp_ref)) {
@@ -613,6 +631,10 @@ stmmac_probe_config_dt(struct platform_device *pdev, const char **mac)
 	return plat;
 
 error_hw_init:
+	clk_disable_unprepare(plat->rx_clk);
+error_rx_clk_get:
+	clk_disable_unprepare(plat->tx_clk);
+error_tx_clk_get:
 	clk_disable_unprepare(plat->pclk);
 error_pclk_get:
 	clk_disable_unprepare(plat->stmmac_clk);
@@ -634,6 +656,8 @@ stmmac_probe_config_dt(struct platform_device *pdev, const char **mac)
 void stmmac_remove_config_dt(struct platform_device *pdev,
 			     struct plat_stmmacenet_data *plat)
 {
+	clk_disable_unprepare(plat->rx_clk);
+	clk_disable_unprepare(plat->tx_clk);
 	clk_disable_unprepare(plat->pclk);
 	clk_disable_unprepare(plat->stmmac_clk);
 	of_node_put(plat->phy_node);
diff --git a/include/linux/stmmac.h b/include/linux/stmmac.h
index 628e28903b8b..b75cf13d088c 100644
--- a/include/linux/stmmac.h
+++ b/include/linux/stmmac.h
@@ -185,6 +185,8 @@ struct plat_stmmacenet_data {
 	void *bsp_priv;
 	struct clk *stmmac_clk;
 	struct clk *pclk;
+	struct clk *tx_clk;
+	struct clk *rx_clk;
 	struct clk *clk_ptp_ref;
 	unsigned int clk_ptp_rate;
 	unsigned int clk_ref_rate;
-- 
2.29.2

