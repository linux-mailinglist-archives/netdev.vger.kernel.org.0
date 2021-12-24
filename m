Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 066B047F0AC
	for <lists+netdev@lfdr.de>; Fri, 24 Dec 2021 20:26:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237355AbhLXT0j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Dec 2021 14:26:39 -0500
Received: from relmlor2.renesas.com ([210.160.252.172]:11195 "EHLO
        relmlie6.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S234457AbhLXT0h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Dec 2021 14:26:37 -0500
X-IronPort-AV: E=Sophos;i="5.88,233,1635174000"; 
   d="scan'208";a="105121724"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie6.idc.renesas.com with ESMTP; 25 Dec 2021 04:26:36 +0900
Received: from localhost.localdomain (unknown [10.226.36.204])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id 3449A40F5214;
        Sat, 25 Dec 2021 04:26:34 +0900 (JST)
From:   Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
To:     netdev@vger.kernel.org, Jassi Brar <jaswinder.singh@linaro.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Rob Herring <robh+dt@kernel.org>, linux-kernel@vger.kernel.org,
        Prabhakar <prabhakar.csengg@gmail.com>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Subject: [PATCH 1/8] ethernet: netsec: Use platform_get_irq() to get the interrupt
Date:   Fri, 24 Dec 2021 19:26:19 +0000
Message-Id: <20211224192626.15843-2-prabhakar.mahadev-lad.rj@bp.renesas.com>
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
 drivers/net/ethernet/socionext/netsec.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/socionext/netsec.c b/drivers/net/ethernet/socionext/netsec.c
index 25dcd8eda5fc..556bd353dd42 100644
--- a/drivers/net/ethernet/socionext/netsec.c
+++ b/drivers/net/ethernet/socionext/netsec.c
@@ -1977,11 +1977,12 @@ static int netsec_register_mdio(struct netsec_priv *priv, u32 phy_addr)
 
 static int netsec_probe(struct platform_device *pdev)
 {
-	struct resource *mmio_res, *eeprom_res, *irq_res;
+	struct resource *mmio_res, *eeprom_res;
 	struct netsec_priv *priv;
 	u32 hw_ver, phy_addr = 0;
 	struct net_device *ndev;
 	int ret;
+	int irq;
 
 	mmio_res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!mmio_res) {
@@ -1995,11 +1996,9 @@ static int netsec_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
-	irq_res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
-	if (!irq_res) {
-		dev_err(&pdev->dev, "No IRQ resource found.\n");
-		return -ENODEV;
-	}
+	irq = platform_get_irq(pdev, 0);
+	if (irq < 0)
+		return irq;
 
 	ndev = alloc_etherdev(sizeof(*priv));
 	if (!ndev)
@@ -2010,7 +2009,7 @@ static int netsec_probe(struct platform_device *pdev)
 	spin_lock_init(&priv->reglock);
 	SET_NETDEV_DEV(ndev, &pdev->dev);
 	platform_set_drvdata(pdev, priv);
-	ndev->irq = irq_res->start;
+	ndev->irq = irq;
 	priv->dev = &pdev->dev;
 	priv->ndev = ndev;
 
-- 
2.17.1

