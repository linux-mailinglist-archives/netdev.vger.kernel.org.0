Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C44B52D42C6
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 14:11:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732158AbgLINHq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 08:07:46 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:25093 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732118AbgLINGI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 08:06:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1607519167; x=1639055167;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=sg8hMoePzZkTWnlOxX0XW4Z/Hbg3HlWIuTqcx3KINpI=;
  b=L+SggUp3uSmfc+hWcUwM24EenOoqgFqqrGtz9AdvA4eZe5fDi0JtC6y2
   k1HwcCR2VGEJLL5ZLsHSeQr3gu23yCiYMRYjGY4081gswO3H0+8MuwUa1
   vNhPk1hLN2GzP5dlb1niM+rwh6TO/GR+TGF5raK77IE9oUO5nHuCgTMkf
   U49UiZKmvDNlfLTDdir7DvD7bg9RbXmpc/GAJSM2WvEsxegfc0j+4tWkx
   7A6CELYG8IGxtrhTzcl1AE+vl1SkyrS+1zMi2qihVxuq4tDYjw8Mxqugp
   SZ+KrsrF0FTQy1IKFncLWtkFGweo5NuPwniBUYZ35lM13XCxzJlpF+/FM
   g==;
IronPort-SDR: id3YMpwKvkEftidcEpCGiNrQnezuZwNDGcG/C76YQQXDlPzhGInltryPQ/gAj30ffNqImpqtR+
 3RyY2g78NiMjid3BmPMROrdxddgH7X9MrCNpJi6EZobSt17X/5DuRFYBpH2/XA7OxJJuRM4lHx
 Fay6Sb0nP8riyxrVMxkeGppRn94pNL5zesmXW0YhLRu17106BjjOPO8JyHDMK30I+lFGlfbr5B
 7kECiBklenDY5lcdp1UoznIKf9weso56orsW0UEAxqYXMAZ5rikIEWFasuuZFnf9yIFUjUDAv1
 vqY=
X-IronPort-AV: E=Sophos;i="5.78,405,1599548400"; 
   d="scan'208";a="96475122"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 Dec 2020 06:04:06 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 9 Dec 2020 06:04:04 -0700
Received: from m18063-ThinkPad-T460p.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Wed, 9 Dec 2020 06:03:59 -0700
From:   Claudiu Beznea <claudiu.beznea@microchip.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <nicolas.ferre@microchip.com>, <linux@armlinux.org.uk>,
        <paul.walmsley@sifive.com>, <palmer@dabbelt.com>,
        <natechancellor@gmail.com>, <ndesaulniers@google.com>
CC:     <yash.shah@sifive.com>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-riscv@lists.infradead.org>,
        <clang-built-linux@googlegroups.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>
Subject: [PATCH v3 3/8] net: macb: add function to disable all macb clocks
Date:   Wed, 9 Dec 2020 15:03:34 +0200
Message-ID: <1607519019-19103-4-git-send-email-claudiu.beznea@microchip.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1607519019-19103-1-git-send-email-claudiu.beznea@microchip.com>
References: <1607519019-19103-1-git-send-email-claudiu.beznea@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add function to disable all macb clocks.

Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Suggested-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/ethernet/cadence/macb_main.c | 38 ++++++++++++++++++--------------
 1 file changed, 21 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index b23e986ac6dc..81704985a79b 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -3694,6 +3694,20 @@ static void macb_probe_queues(void __iomem *mem,
 	*num_queues = hweight32(*queue_mask);
 }
 
+static void macb_clks_disable(struct clk *pclk, struct clk *hclk, struct clk *tx_clk,
+			      struct clk *rx_clk, struct clk *tsu_clk)
+{
+	struct clk_bulk_data clks[] = {
+		{ .clk = tsu_clk, },
+		{ .clk = rx_clk, },
+		{ .clk = pclk, },
+		{ .clk = hclk, },
+		{ .clk = tx_clk },
+	};
+
+	clk_bulk_disable_unprepare(ARRAY_SIZE(clks), clks);
+}
+
 static int macb_clk_init(struct platform_device *pdev, struct clk **pclk,
 			 struct clk **hclk, struct clk **tx_clk,
 			 struct clk **rx_clk, struct clk **tsu_clk)
@@ -4755,11 +4769,7 @@ static int macb_probe(struct platform_device *pdev)
 	free_netdev(dev);
 
 err_disable_clocks:
-	clk_disable_unprepare(tx_clk);
-	clk_disable_unprepare(hclk);
-	clk_disable_unprepare(pclk);
-	clk_disable_unprepare(rx_clk);
-	clk_disable_unprepare(tsu_clk);
+	macb_clks_disable(pclk, hclk, tx_clk, rx_clk, tsu_clk);
 	pm_runtime_disable(&pdev->dev);
 	pm_runtime_set_suspended(&pdev->dev);
 	pm_runtime_dont_use_autosuspend(&pdev->dev);
@@ -4784,11 +4794,8 @@ static int macb_remove(struct platform_device *pdev)
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
@@ -4967,13 +4974,10 @@ static int __maybe_unused macb_runtime_suspend(struct device *dev)
 	struct net_device *netdev = dev_get_drvdata(dev);
 	struct macb *bp = netdev_priv(netdev);
 
-	if (!(device_may_wakeup(dev))) {
-		clk_disable_unprepare(bp->tx_clk);
-		clk_disable_unprepare(bp->hclk);
-		clk_disable_unprepare(bp->pclk);
-		clk_disable_unprepare(bp->rx_clk);
-	}
-	clk_disable_unprepare(bp->tsu_clk);
+	if (!(device_may_wakeup(dev)))
+		macb_clks_disable(bp->pclk, bp->hclk, bp->tx_clk, bp->rx_clk, bp->tsu_clk);
+	else
+		macb_clks_disable(NULL, NULL, NULL, NULL, bp->tsu_clk);
 
 	return 0;
 }
-- 
2.7.4

