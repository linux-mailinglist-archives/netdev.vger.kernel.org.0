Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A7322D104D
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 13:18:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727559AbgLGMQu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 07:16:50 -0500
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:18847 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727531AbgLGMQt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 07:16:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1607343409; x=1638879409;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=Gy8Pc0VWAdq3BNbu92BtoqbTlIqU+jDmxbRUZaKX4PE=;
  b=JRa+4HrrM4mNjiXAnGoiUEq1sELMSWgqc80jEMa+dr817JSqTrwol7yU
   weDuNmeBUCWOf3DGEIsMGFqw7gadapvpL1LJQ5aQrAbgRVzc94aem/JqC
   3QG1qWIfj2Lv5/agmdnpye0dwpF8XI0r2Js/fzMsT1DGn3kVaTIjxlNOE
   GDFxhNaw34lQnD4epY/ES2tPiViuXFQCfqyrWaUAnrQM1GcJrPG50oY+0
   v2Ya5q+fDv5EiRPv1kI3KEgNMIOQf76RzbW4H6vlL9KVsPlQOk61/KLBO
   +Eh7HXGj0vACqs20UEd21+en6eKBoPSUlCJNxstP+CmPBrQozO8sAcKwx
   Q==;
IronPort-SDR: /V9twlE602QPNR69lBGkEvoPJAm3mqAHtSjQZCKSFv3Dc7wV8dY163yPia7wSSteLG8SRMAc33
 9aHDRS0p9zENhVOzcaBVIg1BorFFNaXuoIuUP31SJkG0ILM9POagYPY+mBcSARPbAftRHUsSMu
 iQVMz1PQ62qrychZaNaZ/x9Ofa7JX4tuGXWZ8LZ9q6QlFLi8a0+8AYdr1ioQJqatPtQJnFWouy
 gblveH1W6wbNFIzkgWm1L/Ah0paywYqrFiCUXec22uuKLg63r45jYDISyZPTTt20nZUcPY84K5
 K5w=
X-IronPort-AV: E=Sophos;i="5.78,399,1599548400"; 
   d="scan'208";a="98863491"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 07 Dec 2020 05:16:08 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 7 Dec 2020 05:16:08 -0700
Received: from m18063-ThinkPad-T460p.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Mon, 7 Dec 2020 05:16:00 -0700
From:   Claudiu Beznea <claudiu.beznea@microchip.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <nicolas.ferre@microchip.com>, <linux@armlinux.org.uk>,
        <paul.walmsley@sifive.com>, <palmer@dabbelt.com>
CC:     <yash.shah@sifive.com>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-riscv@lists.infradead.org>,
        Claudiu Beznea <claudiu.beznea@microchip.com>
Subject: [PATCH v2 3/8] net: macb: add function to disable all macb clocks
Date:   Mon, 7 Dec 2020 14:15:28 +0200
Message-ID: <1607343333-26552-4-git-send-email-claudiu.beznea@microchip.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1607343333-26552-1-git-send-email-claudiu.beznea@microchip.com>
References: <1607343333-26552-1-git-send-email-claudiu.beznea@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add function to disable all macb clocks.

Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Suggested-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/ethernet/cadence/macb_main.c | 62 ++++++++++++++++----------------
 1 file changed, 32 insertions(+), 30 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index b23e986ac6dc..6b8e1109dfd3 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -3694,6 +3694,16 @@ static void macb_probe_queues(void __iomem *mem,
 	*num_queues = hweight32(*queue_mask);
 }
 
+static void macb_clks_disable(struct clk *pclk, struct clk *hclk, struct clk *tx_clk,
+			      struct clk *rx_clk, struct clk *tsu_clk)
+{
+	clk_disable_unprepare(tx_clk);
+	clk_disable_unprepare(hclk);
+	clk_disable_unprepare(pclk);
+	clk_disable_unprepare(rx_clk);
+	clk_disable_unprepare(tsu_clk);
+}
+
 static int macb_clk_init(struct platform_device *pdev, struct clk **pclk,
 			 struct clk **hclk, struct clk **tx_clk,
 			 struct clk **rx_clk, struct clk **tsu_clk)
@@ -3743,40 +3753,37 @@ static int macb_clk_init(struct platform_device *pdev, struct clk **pclk,
 	err = clk_prepare_enable(*hclk);
 	if (err) {
 		dev_err(&pdev->dev, "failed to enable hclk (%d)\n", err);
-		goto err_disable_pclk;
+		hclk = NULL;
+		tx_clk = NULL;
+		rx_clk = NULL;
+		goto err_disable_clks;
 	}
 
 	err = clk_prepare_enable(*tx_clk);
 	if (err) {
 		dev_err(&pdev->dev, "failed to enable tx_clk (%d)\n", err);
-		goto err_disable_hclk;
+		tx_clk = NULL;
+		rx_clk = NULL;
+		goto err_disable_clks;
 	}
 
 	err = clk_prepare_enable(*rx_clk);
 	if (err) {
 		dev_err(&pdev->dev, "failed to enable rx_clk (%d)\n", err);
-		goto err_disable_txclk;
+		rx_clk = NULL;
+		goto err_disable_clks;
 	}
 
 	err = clk_prepare_enable(*tsu_clk);
 	if (err) {
 		dev_err(&pdev->dev, "failed to enable tsu_clk (%d)\n", err);
-		goto err_disable_rxclk;
+		goto err_disable_clks;
 	}
 
 	return 0;
 
-err_disable_rxclk:
-	clk_disable_unprepare(*rx_clk);
-
-err_disable_txclk:
-	clk_disable_unprepare(*tx_clk);
-
-err_disable_hclk:
-	clk_disable_unprepare(*hclk);
-
-err_disable_pclk:
-	clk_disable_unprepare(*pclk);
+err_disable_clks:
+	macb_clks_disable(*pclk, *hclk, *tx_clk, *rx_clk, NULL);
 
 	return err;
 }
@@ -4755,11 +4762,7 @@ static int macb_probe(struct platform_device *pdev)
 	free_netdev(dev);
 
 err_disable_clocks:
-	clk_disable_unprepare(tx_clk);
-	clk_disable_unprepare(hclk);
-	clk_disable_unprepare(pclk);
-	clk_disable_unprepare(rx_clk);
-	clk_disable_unprepare(tsu_clk);
+	macb_clks_disable(bp->pclk, bp->hclk, bp->tx_clk, bp->rx_clk, bp->tsu_clk);
 	pm_runtime_disable(&pdev->dev);
 	pm_runtime_set_suspended(&pdev->dev);
 	pm_runtime_dont_use_autosuspend(&pdev->dev);
@@ -4784,11 +4787,8 @@ static int macb_remove(struct platform_device *pdev)
 		pm_runtime_disable(&pdev->dev);
 		pm_runtime_dont_use_autosuspend(&pdev->dev);
 		if (!pm_runtime_suspended(&pdev->dev)) {
-			clk_disable_unprepare(bp->tx_clk);
-			clk_disable_unprepare(bp->hclk);
-			clk_disable_unprepare(bp->pclk);
-			clk_disable_unprepare(bp->rx_clk);
-			clk_disable_unprepare(bp->tsu_clk);
+			macb_clks_disable(bp->pclk, bp->hclk, bp->tx_clk,
+					  bp->rx_clk, bp->tsu_clk);
 			pm_runtime_set_suspended(&pdev->dev);
 		}
 		phylink_destroy(bp->phylink);
@@ -4966,14 +4966,16 @@ static int __maybe_unused macb_runtime_suspend(struct device *dev)
 {
 	struct net_device *netdev = dev_get_drvdata(dev);
 	struct macb *bp = netdev_priv(netdev);
+	struct clk *pclk = NULL, *hclk = NULL, *tx_clk = NULL, *rx_clk = NULL;
 
 	if (!(device_may_wakeup(dev))) {
-		clk_disable_unprepare(bp->tx_clk);
-		clk_disable_unprepare(bp->hclk);
-		clk_disable_unprepare(bp->pclk);
-		clk_disable_unprepare(bp->rx_clk);
+		pclk = bp->pclk;
+		hclk = bp->hclk;
+		tx_clk = bp->tx_clk;
+		rx_clk = bp->rx_clk;
 	}
-	clk_disable_unprepare(bp->tsu_clk);
+
+	macb_clks_disable(pclk, hclk, tx_clk, rx_clk, bp->tsu_clk);
 
 	return 0;
 }
-- 
2.7.4

