Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F178647C7E9
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 21:00:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231327AbhLUUA0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 15:00:26 -0500
Received: from relmlor1.renesas.com ([210.160.252.171]:37799 "EHLO
        relmlie5.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230350AbhLUUAZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 15:00:25 -0500
X-IronPort-AV: E=Sophos;i="5.88,224,1635174000"; 
   d="scan'208";a="104261932"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie5.idc.renesas.com with ESMTP; 22 Dec 2021 05:00:24 +0900
Received: from localhost.localdomain (unknown [10.226.36.204])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id 6736640EF4C5;
        Wed, 22 Dec 2021 05:00:22 +0900 (JST)
From:   Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
To:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Prabhakar <prabhakar.csengg@gmail.com>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Subject: [PATCH] can: sja1000: Use platform_get_irq()
Date:   Tue, 21 Dec 2021 20:00:16 +0000
Message-Id: <20211221200016.13459-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is preferred that drivers use platform_get_irq()
instead of irq_of_parse_and_map(), so replace.

Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
---
 drivers/net/can/sja1000/sja1000_platform.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/net/can/sja1000/sja1000_platform.c b/drivers/net/can/sja1000/sja1000_platform.c
index d7c2ec529b8f..f9ec7bd8dfac 100644
--- a/drivers/net/can/sja1000/sja1000_platform.c
+++ b/drivers/net/can/sja1000/sja1000_platform.c
@@ -17,7 +17,6 @@
 #include <linux/io.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
-#include <linux/of_irq.h>
 
 #include "sja1000.h"
 
@@ -234,13 +233,15 @@ static int sp_probe(struct platform_device *pdev)
 	if (!addr)
 		return -ENOMEM;
 
-	if (of)
-		irq = irq_of_parse_and_map(of, 0);
-	else
+	if (of) {
+		irq = platform_get_irq(pdev, 0);
+		if (irq < 0)
+			return irq;
+	} else {
 		res_irq = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
-
-	if (!irq && !res_irq)
-		return -ENODEV;
+		if (!res_irq)
+			return -ENODEV;
+	}
 
 	of_id = of_match_device(sp_of_table, &pdev->dev);
 	if (of_id && of_id->data) {
-- 
2.17.1

