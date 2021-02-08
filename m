Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B87C313476
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 15:07:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231857AbhBHOGc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 09:06:32 -0500
Received: from mail.baikalelectronics.com ([87.245.175.226]:57090 "EHLO
        mail.baikalelectronics.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231717AbhBHN6f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 08:58:35 -0500
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
Subject: [PATCH v2 22/24] net: stmmac: Call stmmaceth clock as system clock in warn-message
Date:   Mon, 8 Feb 2021 16:56:06 +0300
Message-ID: <20210208135609.7685-23-Sergey.Semin@baikalelectronics.ru>
In-Reply-To: <20210208135609.7685-1-Sergey.Semin@baikalelectronics.ru>
References: <20210208135609.7685-1-Sergey.Semin@baikalelectronics.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: MAIL.baikal.int (192.168.51.25) To mail (192.168.51.25)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

By all means of the stmmac_clk clock usage it isn't CSR clock, but the
system or application clock, which in particular cases can be used as a
clock source for the CSR interface. Make sure the warning message
correctly identify the clock. While at it add error message printout if
actual CSR clock failed to be requested.

Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
index a6e35c84e135..7cbde9d99133 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
@@ -573,7 +573,7 @@ stmmac_probe_config_dt(struct platform_device *pdev, const char **mac)
 						 STMMAC_RESOURCE_NAME);
 	if (IS_ERR(plat->stmmac_clk)) {
 		rc = PTR_ERR(plat->stmmac_clk);
-		dev_err_probe(&pdev->dev, rc, "Cannot get CSR clock\n");
+		dev_err_probe(&pdev->dev, rc, "Cannot get system clock\n");
 		goto error_dma_cfg_alloc;
 	}
 	clk_prepare_enable(plat->stmmac_clk);
@@ -581,6 +581,7 @@ stmmac_probe_config_dt(struct platform_device *pdev, const char **mac)
 	plat->pclk = devm_clk_get_optional(&pdev->dev, "pclk");
 	if (IS_ERR(plat->pclk)) {
 		rc = PTR_ERR(plat->pclk);
+		dev_err_probe(&pdev->dev, rc, "Cannot get CSR clock\n");
 		goto error_pclk_get;
 	}
 	clk_prepare_enable(plat->pclk);
-- 
2.29.2

