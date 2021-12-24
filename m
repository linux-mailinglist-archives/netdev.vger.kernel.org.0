Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2F7147F0BE
	for <lists+netdev@lfdr.de>; Fri, 24 Dec 2021 20:28:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353497AbhLXT1O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Dec 2021 14:27:14 -0500
Received: from relmlor2.renesas.com ([210.160.252.172]:25711 "EHLO
        relmlie6.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1353467AbhLXT0z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Dec 2021 14:26:55 -0500
X-IronPort-AV: E=Sophos;i="5.88,233,1635174000"; 
   d="scan'208";a="105121735"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie6.idc.renesas.com with ESMTP; 25 Dec 2021 04:26:54 +0900
Received: from localhost.localdomain (unknown [10.226.36.204])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id 5655F40F520F;
        Sat, 25 Dec 2021 04:26:52 +0900 (JST)
From:   Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
To:     netdev@vger.kernel.org,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Rob Herring <robh+dt@kernel.org>, linux-kernel@vger.kernel.org,
        Prabhakar <prabhakar.csengg@gmail.com>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        linux-omap@vger.kernel.org
Subject: [PATCH 8/8] net: ethernet: ti: davinci_emac: Use platform_get_irq() to get the interrupt
Date:   Fri, 24 Dec 2021 19:26:26 +0000
Message-Id: <20211224192626.15843-9-prabhakar.mahadev-lad.rj@bp.renesas.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211224192626.15843-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
References: <20211224192626.15843-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

platform_get_resource(pdev, IORESOURCE_IRQ, ..) relies on static
allocation of IRQ resources in DT core code, this causes an issue
when using hierarchical interrupt domains using "interrupts" property
in the node as this bypasses the hierarchical setup and messes up the
irq chaining.

In preparation for removal of static setup of IRQ resource from DT core
code use platform_get_irq() for DT users only.

While at it propagate error code in case request_irq() fails instead of
returning -EBUSY.

Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
---
 drivers/net/ethernet/ti/davinci_emac.c | 69 ++++++++++++++++----------
 1 file changed, 42 insertions(+), 27 deletions(-)

diff --git a/drivers/net/ethernet/ti/davinci_emac.c b/drivers/net/ethernet/ti/davinci_emac.c
index d55f06120ce7..31df3267a01a 100644
--- a/drivers/net/ethernet/ti/davinci_emac.c
+++ b/drivers/net/ethernet/ti/davinci_emac.c
@@ -1454,23 +1454,33 @@ static int emac_dev_open(struct net_device *ndev)
 	}
 
 	/* Request IRQ */
-	while ((res = platform_get_resource(priv->pdev, IORESOURCE_IRQ,
-					    res_num))) {
-		for (irq_num = res->start; irq_num <= res->end; irq_num++) {
-			if (request_irq(irq_num, emac_irq, 0, ndev->name,
-					ndev)) {
-				dev_err(emac_dev,
-					"DaVinci EMAC: request_irq() failed\n");
-				ret = -EBUSY;
+	if (dev_of_node(&priv->pdev->dev)) {
+		while ((ret = platform_get_irq_optional(priv->pdev, res_num)) != -ENXIO) {
+			if (ret < 0)
+				goto rollback;
 
+			ret = request_irq(ret, emac_irq, 0, ndev->name, ndev);
+			if (ret) {
+				dev_err(emac_dev, "DaVinci EMAC: request_irq() failed\n");
 				goto rollback;
 			}
+			res_num++;
 		}
-		res_num++;
+	} else {
+		while ((res = platform_get_resource(priv->pdev, IORESOURCE_IRQ, res_num))) {
+			for (irq_num = res->start; irq_num <= res->end; irq_num++) {
+				ret = request_irq(irq_num, emac_irq, 0, ndev->name, ndev);
+				if (ret) {
+					dev_err(emac_dev, "DaVinci EMAC: request_irq() failed\n");
+					goto rollback;
+				}
+			}
+			res_num++;
+		}
+		/* prepare counters for rollback in case of an error */
+		res_num--;
+		irq_num--;
 	}
-	/* prepare counters for rollback in case of an error */
-	res_num--;
-	irq_num--;
 
 	/* Start/Enable EMAC hardware */
 	emac_hw_enable(priv);
@@ -1554,16 +1564,24 @@ static int emac_dev_open(struct net_device *ndev)
 	napi_disable(&priv->napi);
 
 rollback:
-	for (q = res_num; q >= 0; q--) {
-		res = platform_get_resource(priv->pdev, IORESOURCE_IRQ, q);
-		/* at the first iteration, irq_num is already set to the
-		 * right value
-		 */
-		if (q != res_num)
-			irq_num = res->end;
+	if (dev_of_node(&priv->pdev->dev)) {
+		for (q = res_num - 1; q >= 0; q--) {
+			irq_num = platform_get_irq(priv->pdev, q);
+			if (irq_num > 0)
+				free_irq(irq_num, ndev);
+		}
+	} else {
+		for (q = res_num; q >= 0; q--) {
+			res = platform_get_resource(priv->pdev, IORESOURCE_IRQ, q);
+			/* at the first iteration, irq_num is already set to the
+			 * right value
+			 */
+			if (q != res_num)
+				irq_num = res->end;
 
-		for (m = irq_num; m >= res->start; m--)
-			free_irq(m, ndev);
+			for (m = irq_num; m >= res->start; m--)
+				free_irq(m, ndev);
+		}
 	}
 	cpdma_ctlr_stop(priv->dma);
 	pm_runtime_put(&priv->pdev->dev);
@@ -1899,13 +1917,10 @@ static int davinci_emac_probe(struct platform_device *pdev)
 		goto err_free_txchan;
 	}
 
-	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
-	if (!res) {
-		dev_err(&pdev->dev, "error getting irq res\n");
-		rc = -ENOENT;
+	rc = platform_get_irq(pdev, 0);
+	if (rc < 0)
 		goto err_free_rxchan;
-	}
-	ndev->irq = res->start;
+	ndev->irq = rc;
 
 	rc = davinci_emac_try_get_mac(pdev, res_ctrl ? 0 : 1, priv->mac_addr);
 	if (!rc)
-- 
2.17.1

