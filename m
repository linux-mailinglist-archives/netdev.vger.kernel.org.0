Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF13615AD9F
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 17:45:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727680AbgBLQpn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 11:45:43 -0500
Received: from relay12.mail.gandi.net ([217.70.178.232]:37299 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727264AbgBLQpm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Feb 2020 11:45:42 -0500
Received: from localhost (lfbn-lyo-1-1670-129.w90-65.abo.wanadoo.fr [90.65.102.129])
        (Authenticated sender: alexandre.belloni@bootlin.com)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id C3FD1200010;
        Wed, 12 Feb 2020 16:45:40 +0000 (UTC)
From:   Alexandre Belloni <alexandre.belloni@bootlin.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     Nicolas Ferre <nicolas.ferre@microchip.com>,
        Harini Katakam <harini.katakam@xilinx.com>,
        Shubhrajyoti Datta <shubhrajyoti.datta@xilinx.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH net] net: macb: ensure interface is not suspended on at91rm9200
Date:   Wed, 12 Feb 2020 17:45:38 +0100
Message-Id: <20200212164538.383741-1-alexandre.belloni@bootlin.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Because of autosuspend, at91ether_start is called with clocks disabled.
Ensure that pm_runtime doesn't suspend the interface as soon as it is
opened as there is no pm_runtime support is the other relevant parts of the
platform support for at91rm9200.

Fixes: d54f89af6cc4 ("net: macb: Add pm runtime support")
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
---
 drivers/net/ethernet/cadence/macb_main.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 4508f0d150da..def94e91883a 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -3790,6 +3790,10 @@ static int at91ether_open(struct net_device *dev)
 	u32 ctl;
 	int ret;
 
+	ret = pm_runtime_get_sync(&lp->pdev->dev);
+	if (ret < 0)
+		return ret;
+
 	/* Clear internal statistics */
 	ctl = macb_readl(lp, NCR);
 	macb_writel(lp, NCR, ctl | MACB_BIT(CLRSTAT));
@@ -3854,7 +3858,7 @@ static int at91ether_close(struct net_device *dev)
 			  q->rx_buffers, q->rx_buffers_dma);
 	q->rx_buffers = NULL;
 
-	return 0;
+	return pm_runtime_put(&lp->pdev->dev);
 }
 
 /* Transmit packet */
-- 
2.24.1

