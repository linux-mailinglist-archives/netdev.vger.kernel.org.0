Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AAE947F0AE
	for <lists+netdev@lfdr.de>; Fri, 24 Dec 2021 20:26:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239337AbhLXT0k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Dec 2021 14:26:40 -0500
Received: from relmlor2.renesas.com ([210.160.252.172]:49526 "EHLO
        relmlie6.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S239632AbhLXT0j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Dec 2021 14:26:39 -0500
X-IronPort-AV: E=Sophos;i="5.88,233,1635174000"; 
   d="scan'208";a="105121727"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie6.idc.renesas.com with ESMTP; 25 Dec 2021 04:26:38 +0900
Received: from localhost.localdomain (unknown [10.226.36.204])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id DD7A140F5214;
        Sat, 25 Dec 2021 04:26:36 +0900 (JST)
From:   Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
To:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Rob Herring <robh+dt@kernel.org>, linux-kernel@vger.kernel.org,
        Prabhakar <prabhakar.csengg@gmail.com>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Subject: [PATCH 2/8] net: pxa168_eth: Use platform_get_irq() to get the interrupt
Date:   Fri, 24 Dec 2021 19:26:20 +0000
Message-Id: <20211224192626.15843-3-prabhakar.mahadev-lad.rj@bp.renesas.com>
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
code use platform_get_irq().

Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
---
 drivers/net/ethernet/marvell/pxa168_eth.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/marvell/pxa168_eth.c b/drivers/net/ethernet/marvell/pxa168_eth.c
index 1d607bc6b59e..52bef50f5a0d 100644
--- a/drivers/net/ethernet/marvell/pxa168_eth.c
+++ b/drivers/net/ethernet/marvell/pxa168_eth.c
@@ -1388,7 +1388,6 @@ static int pxa168_eth_probe(struct platform_device *pdev)
 {
 	struct pxa168_eth_private *pep = NULL;
 	struct net_device *dev = NULL;
-	struct resource *res;
 	struct clk *clk;
 	struct device_node *np;
 	int err;
@@ -1419,9 +1418,11 @@ static int pxa168_eth_probe(struct platform_device *pdev)
 		goto err_netdev;
 	}
 
-	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
-	BUG_ON(!res);
-	dev->irq = res->start;
+	err = platform_get_irq(pdev, 0);
+	if (err == -EPROBE_DEFER)
+		goto err_netdev;
+	BUG_ON(dev->irq < 0);
+	dev->irq = err;
 	dev->netdev_ops = &pxa168_eth_netdev_ops;
 	dev->watchdog_timeo = 2 * HZ;
 	dev->base_addr = 0;
-- 
2.17.1

