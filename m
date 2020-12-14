Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFD822D9513
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 10:23:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407306AbgLNJU7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 04:20:59 -0500
Received: from ns2.baikalchip.com ([94.125.187.42]:46536 "EHLO
        mail.baikalelectronics.ru" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2439807AbgLNJSh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 04:18:37 -0500
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
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Anson Huang <Anson.Huang@nxp.com>
Subject: [PATCH 19/25] net: stmmac: dwc-qos: Use dev_err_probe() for probe errors handling
Date:   Mon, 14 Dec 2020 12:16:09 +0300
Message-ID: <20201214091616.13545-20-Sergey.Semin@baikalelectronics.ru>
In-Reply-To: <20201214091616.13545-1-Sergey.Semin@baikalelectronics.ru>
References: <20201214091616.13545-1-Sergey.Semin@baikalelectronics.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: MAIL.baikal.int (192.168.51.25) To mail (192.168.51.25)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a very handy dev_err_probe() method to handle the deferred probe
error number. It reduces the code size, uniforms error handling, records
the defer probe reason, etc. Use it to print the probe callback error
message.

Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
Cc: Anson Huang <Anson.Huang@nxp.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-dwc-qos-eth.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-dwc-qos-eth.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-dwc-qos-eth.c
index 31ca299a1cfd..57f957898b60 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-dwc-qos-eth.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-dwc-qos-eth.c
@@ -473,11 +473,8 @@ static int dwc_eth_dwmac_probe(struct platform_device *pdev)
 	priv = data->probe(pdev, plat_dat, &stmmac_res);
 	if (IS_ERR(priv)) {
 		ret = PTR_ERR(priv);
-
-		if (ret != -EPROBE_DEFER)
-			dev_err(&pdev->dev, "failed to probe subdriver: %d\n",
-				ret);
-
+		dev_err_probe(&pdev->dev, ret, "failed to probe subdriver: %d\n",
+			      ret);
 		goto remove_config;
 	}
 
-- 
2.29.2

