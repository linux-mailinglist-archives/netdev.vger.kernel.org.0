Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 854CA47F0B3
	for <lists+netdev@lfdr.de>; Fri, 24 Dec 2021 20:28:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353504AbhLXT0v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Dec 2021 14:26:51 -0500
Received: from relmlor1.renesas.com ([210.160.252.171]:13679 "EHLO
        relmlie5.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1344305AbhLXT0q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Dec 2021 14:26:46 -0500
X-IronPort-AV: E=Sophos;i="5.88,233,1635174000"; 
   d="scan'208";a="104635854"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie5.idc.renesas.com with ESMTP; 25 Dec 2021 04:26:45 +0900
Received: from localhost.localdomain (unknown [10.226.36.204])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id 00BC940F5214;
        Sat, 25 Dec 2021 04:26:43 +0900 (JST)
From:   Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
To:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michal Simek <michal.simek@xilinx.com>
Cc:     Rob Herring <robh+dt@kernel.org>, linux-kernel@vger.kernel.org,
        Prabhakar <prabhakar.csengg@gmail.com>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 5/8] net: xilinx: emaclite: Use platform_get_irq() to get the interrupt
Date:   Fri, 24 Dec 2021 19:26:23 +0000
Message-Id: <20211224192626.15843-6-prabhakar.mahadev-lad.rj@bp.renesas.com>
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
 drivers/net/ethernet/xilinx/xilinx_emaclite.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_emaclite.c b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
index 0815de581c7f..519599480b15 100644
--- a/drivers/net/ethernet/xilinx/xilinx_emaclite.c
+++ b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
@@ -1133,14 +1133,11 @@ static int xemaclite_of_probe(struct platform_device *ofdev)
 	lp->ndev = ndev;
 
 	/* Get IRQ for the device */
-	res = platform_get_resource(ofdev, IORESOURCE_IRQ, 0);
-	if (!res) {
-		dev_err(dev, "no IRQ found\n");
-		rc = -ENXIO;
+	rc = platform_get_irq(ofdev, 0);
+	if (rc < 0)
 		goto error;
-	}
 
-	ndev->irq = res->start;
+	ndev->irq = rc;
 
 	res = platform_get_resource(ofdev, IORESOURCE_MEM, 0);
 	lp->base_addr = devm_ioremap_resource(&ofdev->dev, res);
-- 
2.17.1

