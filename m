Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 603202D94F4
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 10:22:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729478AbgLNJSI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 04:18:08 -0500
Received: from ns2.baikalelectronics.com ([94.125.187.42]:46530 "EHLO
        mail.baikalelectronics.ru" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2439657AbgLNJR4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 04:17:56 -0500
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
Subject: [PATCH 14/25] net: stmmac: Use optional clock request method to get stmmaceth
Date:   Mon, 14 Dec 2020 12:16:04 +0300
Message-ID: <20201214091616.13545-15-Sergey.Semin@baikalelectronics.ru>
In-Reply-To: <20201214091616.13545-1-Sergey.Semin@baikalelectronics.ru>
References: <20201214091616.13545-1-Sergey.Semin@baikalelectronics.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: MAIL.baikal.int (192.168.51.25) To mail (192.168.51.25)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The "stmmaceth" clock is expected to be optional by the current driver
design, but there are several problems in the implementation. First if the
clock is specified, but failed to be requested due to an internal error or
due to not being ready yet for configuration, then the DT-probe procedure
will just proceed with further initializations. It is erroneous in both
cases. Secondly if we'd use the clock API, which expect the clock being
optional we wouldn't have needed to avoid the clock request procedure for
the "snps,dwc-qos-ethernet-4.10"-compatible devices to prevent the error
message from being printed. All of that can be fixed by using the
devm_clk_get_optional() method here provided by the common clock
framework.

Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
---
 .../ethernet/stmicro/stmmac/stmmac_platform.c | 20 ++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
index 56419f511a48..e79b3e3351a9 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
@@ -566,17 +566,19 @@ stmmac_probe_config_dt(struct platform_device *pdev, const char **mac)
 	if (rc)
 		goto error_dma_cfg_alloc;
 
-	/* clock setup */
-	if (!of_device_is_compatible(np, "snps,dwc-qos-ethernet-4.10")) {
-		plat->stmmac_clk = devm_clk_get(&pdev->dev,
-						STMMAC_RESOURCE_NAME);
-		if (IS_ERR(plat->stmmac_clk)) {
-			dev_warn(&pdev->dev, "Cannot get CSR clock\n");
-			plat->stmmac_clk = NULL;
-		}
-		clk_prepare_enable(plat->stmmac_clk);
+	/* All clocks are optional since the sub-drivers can have a specific
+	 * clocks set and their naming.
+	 */
+	plat->stmmac_clk = devm_clk_get_optional(&pdev->dev,
+						 STMMAC_RESOURCE_NAME);
+	if (IS_ERR(plat->stmmac_clk)) {
+		rc = PTR_ERR(plat->stmmac_clk);
+		dev_err_probe(&pdev->dev, rc, "Cannot get CSR clock\n");
+		goto error_dma_cfg_alloc;
 	}
 
+	clk_prepare_enable(plat->stmmac_clk);
+
 	plat->pclk = devm_clk_get(&pdev->dev, "pclk");
 	if (IS_ERR(plat->pclk)) {
 		if (PTR_ERR(plat->pclk) == -EPROBE_DEFER) {
-- 
2.29.2

