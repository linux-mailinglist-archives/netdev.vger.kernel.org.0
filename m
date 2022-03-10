Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDF4C4D3EB4
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 02:26:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234662AbiCJB1N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 20:27:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230496AbiCJB1M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 20:27:12 -0500
Received: from relmlie6.idc.renesas.com (relmlor2.renesas.com [210.160.252.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 27B8DE02C1;
        Wed,  9 Mar 2022 17:26:12 -0800 (PST)
X-IronPort-AV: E=Sophos;i="5.90,169,1643641200"; 
   d="scan'208";a="113893486"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie6.idc.renesas.com with ESMTP; 10 Mar 2022 10:26:11 +0900
Received: from localhost.localdomain (unknown [10.226.36.204])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id 80410413CE90;
        Thu, 10 Mar 2022 10:26:09 +0900 (JST)
From:   Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
To:     Grygorii Strashko <grygorii.strashko@ti.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-omap@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Andy Shevchenko <andy.shevchenko@gmail.com>,
        linux-kernel@vger.kernel.org,
        Prabhakar <prabhakar.csengg@gmail.com>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Subject: [PATCH] net: ethernet: ti: davinci_emac: Use platform_get_irq() to get the interrupt
Date:   Thu, 10 Mar 2022 01:26:06 +0000
Message-Id: <20220310012606.20217-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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

While at it propagate error code in emac_dev_stop() in case
platform_get_irq_optional() fails.

Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
---
 drivers/net/ethernet/ti/davinci_emac.c | 25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/ti/davinci_emac.c b/drivers/net/ethernet/ti/davinci_emac.c
index 31df3267a01a..4b6aed78d392 100644
--- a/drivers/net/ethernet/ti/davinci_emac.c
+++ b/drivers/net/ethernet/ti/davinci_emac.c
@@ -1604,6 +1604,7 @@ static int emac_dev_stop(struct net_device *ndev)
 	int irq_num;
 	struct emac_priv *priv = netdev_priv(ndev);
 	struct device *emac_dev = &ndev->dev;
+	int ret = 0;
 
 	/* inform the upper layers. */
 	netif_stop_queue(ndev);
@@ -1618,17 +1619,31 @@ static int emac_dev_stop(struct net_device *ndev)
 		phy_disconnect(ndev->phydev);
 
 	/* Free IRQ */
-	while ((res = platform_get_resource(priv->pdev, IORESOURCE_IRQ, i))) {
-		for (irq_num = res->start; irq_num <= res->end; irq_num++)
-			free_irq(irq_num, priv->ndev);
-		i++;
+	if (dev_of_node(&priv->pdev->dev)) {
+		do {
+			ret = platform_get_irq_optional(priv->pdev, i);
+			if (ret < 0 && ret != -ENXIO)
+				break;
+			if (ret > 0) {
+				free_irq(ret, priv->ndev);
+			} else {
+				ret = 0;
+				break;
+			}
+		} while (++i);
+	} else {
+		while ((res = platform_get_resource(priv->pdev, IORESOURCE_IRQ, i))) {
+			for (irq_num = res->start; irq_num <= res->end; irq_num++)
+				free_irq(irq_num, priv->ndev);
+			i++;
+		}
 	}
 
 	if (netif_msg_drv(priv))
 		dev_notice(emac_dev, "DaVinci EMAC: %s stopped\n", ndev->name);
 
 	pm_runtime_put(&priv->pdev->dev);
-	return 0;
+	return ret;
 }
 
 /**
-- 
2.17.1

