Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20C6647C7B9
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 20:45:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237584AbhLUTpV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 14:45:21 -0500
Received: from relmlor1.renesas.com ([210.160.252.171]:24865 "EHLO
        relmlie5.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S234735AbhLUTpU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 14:45:20 -0500
X-IronPort-AV: E=Sophos;i="5.88,224,1635174000"; 
   d="scan'208";a="104261436"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie5.idc.renesas.com with ESMTP; 22 Dec 2021 04:45:19 +0900
Received: from localhost.localdomain (unknown [10.226.36.204])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id 090FA40065DC;
        Wed, 22 Dec 2021 04:45:16 +0900 (JST)
From:   Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
To:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Rob Herring <robh+dt@kernel.org>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Prabhakar <prabhakar.csengg@gmail.com>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Subject: [PATCH] can: ti_hecc: Use platform_get_irq() to get the interrupt
Date:   Tue, 21 Dec 2021 19:45:08 +0000
Message-Id: <20211221194508.11737-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

platform_get_resource(pdev, IORESOURCE_IRQ, ..) relies on static
allocation of IRQ resources in DT core code, this causes an issue
when using hierarchical interrupt domains using "interrupts" property
in the node as this bypasses the hierarchical setup and messes up the
irq chaining.

In preparation for removal of static setup of IRQ resource from DT core
code use platform_get_irq().

Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
---
Hi,

Usage of platform_get_irq() was agreed based on
the discussion [0].

[0] https://patchwork.kernel.org/project/linux-renesas-soc/
patch/20211209001056.29774-1-prabhakar.mahadev-lad.rj@bp.renesas.com/

Cheers,
Prabhakar
---
 drivers/net/can/ti_hecc.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/can/ti_hecc.c b/drivers/net/can/ti_hecc.c
index 353062ead98f..ff31b993ab17 100644
--- a/drivers/net/can/ti_hecc.c
+++ b/drivers/net/can/ti_hecc.c
@@ -859,7 +859,6 @@ static int ti_hecc_probe(struct platform_device *pdev)
 	struct net_device *ndev = (struct net_device *)0;
 	struct ti_hecc_priv *priv;
 	struct device_node *np = pdev->dev.of_node;
-	struct resource *irq;
 	struct regulator *reg_xceiver;
 	int err = -ENODEV;
 
@@ -904,9 +903,9 @@ static int ti_hecc_probe(struct platform_device *pdev)
 		goto probe_exit_candev;
 	}
 
-	irq = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
-	if (!irq) {
-		dev_err(&pdev->dev, "No irq resource\n");
+	ndev->irq = platform_get_irq(pdev, 0);
+	if (ndev->irq < 0) {
+		err = ndev->irq;
 		goto probe_exit_candev;
 	}
 
@@ -920,7 +919,6 @@ static int ti_hecc_probe(struct platform_device *pdev)
 	priv->can.ctrlmode_supported = CAN_CTRLMODE_3_SAMPLES;
 
 	spin_lock_init(&priv->mbx_lock);
-	ndev->irq = irq->start;
 	ndev->flags |= IFF_ECHO;
 	platform_set_drvdata(pdev, ndev);
 	SET_NETDEV_DEV(ndev, &pdev->dev);
-- 
2.17.1

