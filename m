Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04C82313463
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 15:06:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232488AbhBHODc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 09:03:32 -0500
Received: from mail.baikalelectronics.com ([87.245.175.226]:57072 "EHLO
        mail.baikalelectronics.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231974AbhBHN6J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 08:58:09 -0500
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
Subject: [PATCH v2 15/24] net: stmmac: Use optional clock request method to get ptp_clk
Date:   Mon, 8 Feb 2021 16:55:59 +0300
Message-ID: <20210208135609.7685-16-Sergey.Semin@baikalelectronics.ru>
In-Reply-To: <20210208135609.7685-1-Sergey.Semin@baikalelectronics.ru>
References: <20210208135609.7685-1-Sergey.Semin@baikalelectronics.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: MAIL.baikal.int (192.168.51.25) To mail (192.168.51.25)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Let's replace the manual implementation of the optional ptp_clk
functionality with method devm_clk_get_optional() provided by the common
clock kernel framework. First of all it will be better from
maintainability point of view. Secondly by doing so we'll also fix a
potential problem, which will come out if the PTP clock has been actually
specified, but the clock framework failed to request it.

Note since we are switching the code to using the optional common clock
API, then there is no need in checking the clk_ptp_ref pointer for being
not NULL before calling the clk_prepare_enable() method. The later will
correctly handle it. So just discard the conditional statement of
priv->plat->clk_ptp_ref pointer value testing in the stmmac_resume()
method.

Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c     | 3 +--
 drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c | 7 +++++--
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index b371842d9337..4f1bf8f6538b 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -5289,8 +5289,7 @@ int stmmac_resume(struct device *dev)
 		/* enable the clk previously disabled */
 		clk_prepare_enable(priv->plat->stmmac_clk);
 		clk_prepare_enable(priv->plat->pclk);
-		if (priv->plat->clk_ptp_ref)
-			clk_prepare_enable(priv->plat->clk_ptp_ref);
+		clk_prepare_enable(priv->plat->clk_ptp_ref);
 		/* reset the phy so that it's ready */
 		if (priv->mii)
 			stmmac_mdio_reset(priv->mii);
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
index a66467baf30a..9a7c94622c36 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
@@ -586,10 +586,13 @@ stmmac_probe_config_dt(struct platform_device *pdev, const char **mac)
 	clk_prepare_enable(plat->pclk);
 
 	/* Fall-back to main clock in case of no PTP ref is passed */
-	plat->clk_ptp_ref = devm_clk_get(&pdev->dev, "ptp_ref");
+	plat->clk_ptp_ref = devm_clk_get_optional(&pdev->dev, "ptp_ref");
 	if (IS_ERR(plat->clk_ptp_ref)) {
+		rc = PTR_ERR(plat->clk_ptp_ref);
+		dev_err_probe(&pdev->dev, rc, "Cannot get PTP clock\n");
+		goto error_hw_init;
+	} else if (!plat->clk_ptp_ref) {
 		plat->clk_ptp_rate = clk_get_rate(plat->stmmac_clk);
-		plat->clk_ptp_ref = NULL;
 		dev_info(&pdev->dev, "PTP uses main clock\n");
 	} else {
 		plat->clk_ptp_rate = clk_get_rate(plat->clk_ptp_ref);
-- 
2.29.2

