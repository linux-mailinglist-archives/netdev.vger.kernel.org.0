Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7337031345B
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 15:06:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231366AbhBHOCV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 09:02:21 -0500
Received: from mail.baikalelectronics.com ([87.245.175.226]:57080 "EHLO
        mail.baikalelectronics.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231882AbhBHN5r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 08:57:47 -0500
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
Subject: [PATCH v2 14/24] net: stmmac: Use optional clock request method to get stmmaceth
Date:   Mon, 8 Feb 2021 16:55:58 +0300
Message-ID: <20210208135609.7685-15-Sergey.Semin@baikalelectronics.ru>
In-Reply-To: <20210208135609.7685-1-Sergey.Semin@baikalelectronics.ru>
References: <20210208135609.7685-1-Sergey.Semin@baikalelectronics.ru>
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
 .../ethernet/stmicro/stmmac/stmmac_platform.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
index ff66c470f07f..a66467baf30a 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
@@ -566,16 +566,17 @@ stmmac_probe_config_dt(struct platform_device *pdev, const char **mac)
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
+	/* All clocks are optional since the sub-drivers may use the platform
+	 * clocks pointers to preserve their own clock-descriptors.
+	 */
+	plat->stmmac_clk = devm_clk_get_optional(&pdev->dev,
+						 STMMAC_RESOURCE_NAME);
+	if (IS_ERR(plat->stmmac_clk)) {
+		rc = PTR_ERR(plat->stmmac_clk);
+		dev_err_probe(&pdev->dev, rc, "Cannot get CSR clock\n");
+		goto error_dma_cfg_alloc;
 	}
+	clk_prepare_enable(plat->stmmac_clk);
 
 	plat->pclk = devm_clk_get_optional(&pdev->dev, "pclk");
 	if (IS_ERR(plat->pclk)) {
-- 
2.29.2

