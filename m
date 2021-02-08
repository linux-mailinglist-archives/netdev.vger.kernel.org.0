Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA29E31346D
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 15:06:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231567AbhBHOFF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 09:05:05 -0500
Received: from mail.baikalelectronics.com ([87.245.175.226]:57086 "EHLO
        mail.baikalelectronics.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231638AbhBHN6d (ORCPT
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
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Anson Huang <Anson.Huang@nxp.com>
Subject: [PATCH v2 18/24] net: stmmac: dwc-qos: Use dev_err_probe() for probe errors handling
Date:   Mon, 8 Feb 2021 16:56:02 +0300
Message-ID: <20210208135609.7685-19-Sergey.Semin@baikalelectronics.ru>
In-Reply-To: <20210208135609.7685-1-Sergey.Semin@baikalelectronics.ru>
References: <20210208135609.7685-1-Sergey.Semin@baikalelectronics.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: MAIL.baikal.int (192.168.51.25) To mail (192.168.51.25)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a very handy dev_err_probe() method to handle the deferred probe
error number. It reduces the code size and identations, uniforms error
handling, records the defer probe reason, etc. Use it to print the probe
callback error message.

Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
Cc: Anson Huang <Anson.Huang@nxp.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-dwc-qos-eth.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-dwc-qos-eth.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-dwc-qos-eth.c
index 20b3696fb776..b71f0c3faebe 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-dwc-qos-eth.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-dwc-qos-eth.c
@@ -466,10 +466,8 @@ static int dwc_eth_dwmac_probe(struct platform_device *pdev)
 
 	ret = data->probe(pdev, plat_dat, &stmmac_res);
 	if (ret < 0) {
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

