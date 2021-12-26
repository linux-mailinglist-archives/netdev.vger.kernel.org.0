Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F226E47F86D
	for <lists+netdev@lfdr.de>; Sun, 26 Dec 2021 18:51:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233862AbhLZRvt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Dec 2021 12:51:49 -0500
Received: from smtp10.smtpout.orange.fr ([80.12.242.132]:52582 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233721AbhLZRvt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Dec 2021 12:51:49 -0500
Received: from pop-os.home ([86.243.171.122])
        by smtp.orange.fr with ESMTPA
        id 1XgPnz7tj3ptZ1XgQnZJF6; Sun, 26 Dec 2021 18:51:47 +0100
X-ME-Helo: pop-os.home
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Sun, 26 Dec 2021 18:51:47 +0100
X-ME-IP: 86.243.171.122
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     chris.snook@gmail.com, davem@davemloft.net, kuba@kernel.org,
        andrew@lunn.ch, linux@rempel-privat.de
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] net: ag71xx: Fix a potential double free in error handling paths
Date:   Sun, 26 Dec 2021 18:51:44 +0100
Message-Id: <b2da37192380cdb9e81cad6484754b3159d12400.1640541019.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

'ndev' is a managed resource allocated with devm_alloc_etherdev(), so there
is no need to call free_netdev() explicitly or there will be a double
free().

Simplify all error handling paths accordingly.

Fixes: d51b6ce441d3 ("net: ethernet: add ag71xx driver")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
This is only compile tested.

I don't have the needed toolchain and when I modify KConfig to try to
compile, I get some errors that look unrelated to this patch:

error: passing argument 2 of ‘ag71xx_hw_set_macaddr’ discards ‘const’ qualifier from pointer target type [-Werror=discarded-qualifiers]

Changing the prototype of ag71xx_hw_set_macaddr() to:
static void ag71xx_hw_set_macaddr(struct ag71xx *ag, const unsigned char *mac)
                                                     ^^^^^
makes it work for me, but I don't know if it is the right way to fix this
build issue.
---
 drivers/net/ethernet/atheros/ag71xx.c | 23 ++++++++---------------
 1 file changed, 8 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/atheros/ag71xx.c b/drivers/net/ethernet/atheros/ag71xx.c
index 270c2935591b..ec167af0e3b2 100644
--- a/drivers/net/ethernet/atheros/ag71xx.c
+++ b/drivers/net/ethernet/atheros/ag71xx.c
@@ -1862,15 +1862,12 @@ static int ag71xx_probe(struct platform_device *pdev)
 	ag->mac_reset = devm_reset_control_get(&pdev->dev, "mac");
 	if (IS_ERR(ag->mac_reset)) {
 		netif_err(ag, probe, ndev, "missing mac reset\n");
-		err = PTR_ERR(ag->mac_reset);
-		goto err_free;
+		return PTR_ERR(ag->mac_reset);
 	}
 
 	ag->mac_base = devm_ioremap(&pdev->dev, res->start, resource_size(res));
-	if (!ag->mac_base) {
-		err = -ENOMEM;
-		goto err_free;
-	}
+	if (!ag->mac_base)
+		return -ENOMEM;
 
 	ndev->irq = platform_get_irq(pdev, 0);
 	err = devm_request_irq(&pdev->dev, ndev->irq, ag71xx_interrupt,
@@ -1878,7 +1875,7 @@ static int ag71xx_probe(struct platform_device *pdev)
 	if (err) {
 		netif_err(ag, probe, ndev, "unable to request IRQ %d\n",
 			  ndev->irq);
-		goto err_free;
+		return err;
 	}
 
 	ndev->netdev_ops = &ag71xx_netdev_ops;
@@ -1906,10 +1903,8 @@ static int ag71xx_probe(struct platform_device *pdev)
 	ag->stop_desc = dmam_alloc_coherent(&pdev->dev,
 					    sizeof(struct ag71xx_desc),
 					    &ag->stop_desc_dma, GFP_KERNEL);
-	if (!ag->stop_desc) {
-		err = -ENOMEM;
-		goto err_free;
-	}
+	if (!ag->stop_desc)
+		return -ENOMEM;
 
 	ag->stop_desc->data = 0;
 	ag->stop_desc->ctrl = 0;
@@ -1924,7 +1919,7 @@ static int ag71xx_probe(struct platform_device *pdev)
 	err = of_get_phy_mode(np, &ag->phy_if_mode);
 	if (err) {
 		netif_err(ag, probe, ndev, "missing phy-mode property in DT\n");
-		goto err_free;
+		return err;
 	}
 
 	netif_napi_add(ndev, &ag->napi, ag71xx_poll, AG71XX_NAPI_WEIGHT);
@@ -1932,7 +1927,7 @@ static int ag71xx_probe(struct platform_device *pdev)
 	err = clk_prepare_enable(ag->clk_eth);
 	if (err) {
 		netif_err(ag, probe, ndev, "Failed to enable eth clk.\n");
-		goto err_free;
+		return err;
 	}
 
 	ag71xx_wr(ag, AG71XX_REG_MAC_CFG1, 0);
@@ -1968,8 +1963,6 @@ static int ag71xx_probe(struct platform_device *pdev)
 	ag71xx_mdio_remove(ag);
 err_put_clk:
 	clk_disable_unprepare(ag->clk_eth);
-err_free:
-	free_netdev(ndev);
 	return err;
 }
 
-- 
2.32.0

