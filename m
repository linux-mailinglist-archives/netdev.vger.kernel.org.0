Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 860F32A0F32
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 21:08:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727843AbgJ3UHp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 16:07:45 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:37842 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727218AbgJ3UHm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 16:07:42 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 09UK7bel104296;
        Fri, 30 Oct 2020 15:07:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1604088457;
        bh=NmGweRIDX1yhKI72wcflgzMMwyqgecQXkJJNNwnR1iI=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=GndEjExQ+C9cnER0da4nyjxUa+0uAgFKwNEM7EPhncxs2VRAIWH5qG8g78Jy/nJb4
         lLzYrmn31azVTkEGq2J5tQ7aq3jDzBFCSR0gcKPIcXLmUE7wulAYQdSgb87dKWAglT
         6bmsxh0gkMk9lgKQLjes/G7Vd3UL0CHuh8iVOhFM=
Received: from DLEE109.ent.ti.com (dlee109.ent.ti.com [157.170.170.41])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 09UK7bgR055640
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 30 Oct 2020 15:07:37 -0500
Received: from DLEE105.ent.ti.com (157.170.170.35) by DLEE109.ent.ti.com
 (157.170.170.41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Fri, 30
 Oct 2020 15:07:37 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE105.ent.ti.com
 (157.170.170.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Fri, 30 Oct 2020 15:07:37 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 09UK7aSC009507;
        Fri, 30 Oct 2020 15:07:36 -0500
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Vignesh Raghavendra <vigneshr@ti.com>
CC:     Sekhar Nori <nsekhar@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>,
        "Reviewed-by : Jesse Brandeburg" <jesse.brandeburg@intel.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH net-next v3 10/10] net: ethernet: ti: am65-cpsw: handle deferred probe with dev_err_probe()
Date:   Fri, 30 Oct 2020 22:07:07 +0200
Message-ID: <20201030200707.24294-11-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201030200707.24294-1-grygorii.strashko@ti.com>
References: <20201030200707.24294-1-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use new dev_err_probe() API to handle deferred probe properly and simplify
the code.

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 28 +++++++++---------------
 1 file changed, 10 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index feb94b813ffc..766e8866bbef 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -1561,9 +1561,8 @@ static int am65_cpsw_nuss_init_tx_chns(struct am65_cpsw_common *common)
 						    tx_chn->tx_chn_name,
 						    &tx_cfg);
 		if (IS_ERR(tx_chn->tx_chn)) {
-			ret = PTR_ERR(tx_chn->tx_chn);
-			dev_err(dev, "Failed to request tx dma channel %d\n",
-				ret);
+			ret = dev_err_probe(dev, PTR_ERR(tx_chn->tx_chn),
+					    "Failed to request tx dma channel\n");
 			goto err;
 		}
 
@@ -1634,8 +1633,8 @@ static int am65_cpsw_nuss_init_rx_chns(struct am65_cpsw_common *common)
 
 	rx_chn->rx_chn = k3_udma_glue_request_rx_chn(dev, "rx", &rx_cfg);
 	if (IS_ERR(rx_chn->rx_chn)) {
-		ret = PTR_ERR(rx_chn->rx_chn);
-		dev_err(dev, "Failed to request rx dma channel %d\n", ret);
+		ret = dev_err_probe(dev, PTR_ERR(rx_chn->rx_chn),
+				    "Failed to request rx dma channel\n");
 		goto err;
 	}
 
@@ -1850,12 +1849,10 @@ static int am65_cpsw_nuss_init_slave_ports(struct am65_cpsw_common *common)
 		/* get phy/link info */
 		if (of_phy_is_fixed_link(port_np)) {
 			ret = of_phy_register_fixed_link(port_np);
-			if (ret) {
-				if (ret != -EPROBE_DEFER)
-					dev_err(dev, "%pOF failed to register fixed-link phy: %d\n",
-						port_np, ret);
-				return ret;
-			}
+			if (ret)
+				return dev_err_probe(dev, ret,
+						     "failed to register fixed-link phy %pOF\n",
+						     port_np);
 			port->slave.phy_node = of_node_get(port_np);
 		} else {
 			port->slave.phy_node =
@@ -2180,13 +2177,8 @@ static int am65_cpsw_nuss_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	clk = devm_clk_get(dev, "fck");
-	if (IS_ERR(clk)) {
-		ret = PTR_ERR(clk);
-
-		if (ret != -EPROBE_DEFER)
-			dev_err(dev, "error getting fck clock %d\n", ret);
-		return ret;
-	}
+	if (IS_ERR(clk))
+		return dev_err_probe(dev, PTR_ERR(clk), "getting fck clock\n");
 	common->bus_freq = clk_get_rate(clk);
 
 	pm_runtime_enable(dev);
-- 
2.17.1

