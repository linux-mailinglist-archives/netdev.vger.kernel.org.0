Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5672A21D36E
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 12:07:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729649AbgGMKGB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 06:06:01 -0400
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:2177 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729556AbgGMKFz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 06:05:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1594634755; x=1626170755;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hLiX2KG4+VIakkYAPr8xr4TUGHwNKNbA6nO7XcPJS9U=;
  b=MKd2+ga0X4xkQeVaJis4T5ZrQA6yypVuYbpi5KJH/qeoWP8pg1rBpl3K
   tb4wR2x/OR9FniZ7XRC5OatfRplgGy7IJxKW0d7YCN7VRS21d7wv5xnXU
   7uFfYkn1CHEgFdUmGXsUBFwXX3e6cdjW0eSXJfDkKd570s+l8lXkx99dc
   7vyffe3BijVyu78tYBLCl2ZddzXxlMEpTuJHni4ZKOn3Gb9NG4TCWKVoR
   4aunOXmRsEdGC2FPDbkE0EV/pnpHMkA/RC+7kaAjTipVSAcimakTJYiuz
   /wk8kJSurefZaQNF1g+LdLBy7lIdsVDJ0xiziJwJnmnwlQLp0AgznSjF+
   A==;
IronPort-SDR: od+NZlvGvnFMjX6RAp905k+qDGMf8/EoN6TT6Ug4+PZIWHyiWn76rCCST3edWqOtQEGDRanGI5
 BVs46jt979G0FEj+Z5sIRth8ybil5AjHzR8t3695xaXDkjVgJ5cbss/LbHcnhxL2zzj1Uj0vQh
 wabW07+f7Hdbj8FL1oRavR4bw4ujZUCKkXOZ5T6h351VU/LDq3ipHeaQKBWX90TaocVBbaUtZg
 tgZwppTNSMD8gAG5t6Nhl+UY88W+wU1qWaOlo3tVroER4t6yXq+yLEAv4iVhpB1jsiwQaqajIu
 +GI=
X-IronPort-AV: E=Sophos;i="5.75,347,1589266800"; 
   d="scan'208";a="83591191"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 13 Jul 2020 03:05:54 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 13 Jul 2020 03:05:23 -0700
Received: from ness.mchp-main.com (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Mon, 13 Jul 2020 03:05:20 -0700
From:   <nicolas.ferre@microchip.com>
To:     <linux@armlinux.org.uk>, <linux-arm-kernel@lists.infradead.org>,
        <netdev@vger.kernel.org>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        <harini.katakam@xilinx.com>, <f.fainelli@gmail.com>
CC:     <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        <antoine.tenart@bootlin.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>
Subject: [PATCH v6 2/2] net: macb: Add WoL interrupt support for MACB type of Ethernet controller
Date:   Mon, 13 Jul 2020 12:05:26 +0200
Message-ID: <33ae0b5ae31ae9a97f6fbbebcab23f777937d89d.1594632220.git.nicolas.ferre@microchip.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1594632220.git.nicolas.ferre@microchip.com>
References: <cover.1594632220.git.nicolas.ferre@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nicolas Ferre <nicolas.ferre@microchip.com>

Handle the Wake-on-Lan interrupt for the Cadence MACB Ethernet
controller.
As we do for the GEM version, we handle of WoL interrupt in a
specialized interrupt handler for MACB version that is positionned
just between suspend() and resume() calls.

Cc: Claudiu Beznea <claudiu.beznea@microchip.com>
Cc: Harini Katakam <harini.katakam@xilinx.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@microchip.com>
---
Changes in v2:
- Addition of pm_wakeup_event() in WoL IRQ

 drivers/net/ethernet/cadence/macb_main.c | 39 +++++++++++++++++++++++-
 1 file changed, 38 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 122c54e40f91..fce5d545ebab 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -1517,6 +1517,35 @@ static void macb_tx_restart(struct macb_queue *queue)
 	macb_writel(bp, NCR, macb_readl(bp, NCR) | MACB_BIT(TSTART));
 }
 
+static irqreturn_t macb_wol_interrupt(int irq, void *dev_id)
+{
+	struct macb_queue *queue = dev_id;
+	struct macb *bp = queue->bp;
+	u32 status;
+
+	status = queue_readl(queue, ISR);
+
+	if (unlikely(!status))
+		return IRQ_NONE;
+
+	spin_lock(&bp->lock);
+
+	if (status & MACB_BIT(WOL)) {
+		queue_writel(queue, IDR, MACB_BIT(WOL));
+		macb_writel(bp, WOL, 0);
+		netdev_vdbg(bp->dev, "MACB WoL: queue = %u, isr = 0x%08lx\n",
+			    (unsigned int)(queue - bp->queues),
+			    (unsigned long)status);
+		if (bp->caps & MACB_CAPS_ISR_CLEAR_ON_WRITE)
+			queue_writel(queue, ISR, MACB_BIT(WOL));
+		pm_wakeup_event(&bp->pdev->dev, 0);
+	}
+
+	spin_unlock(&bp->lock);
+
+	return IRQ_HANDLED;
+}
+
 static irqreturn_t gem_wol_interrupt(int irq, void *dev_id)
 {
 	struct macb_queue *queue = dev_id;
@@ -4619,8 +4648,8 @@ static int __maybe_unused macb_suspend(struct device *dev)
 		/* Change interrupt handler and
 		 * Enable WoL IRQ on queue 0
 		 */
+		devm_free_irq(dev, bp->queues[0].irq, bp->queues);
 		if (macb_is_gem(bp)) {
-			devm_free_irq(dev, bp->queues[0].irq, bp->queues);
 			err = devm_request_irq(dev, bp->queues[0].irq, gem_wol_interrupt,
 					       IRQF_SHARED, netdev->name, bp->queues);
 			if (err) {
@@ -4632,6 +4661,14 @@ static int __maybe_unused macb_suspend(struct device *dev)
 			queue_writel(bp->queues, IER, GEM_BIT(WOL));
 			gem_writel(bp, WOL, MACB_BIT(MAG));
 		} else {
+			err = devm_request_irq(dev, bp->queues[0].irq, macb_wol_interrupt,
+					       IRQF_SHARED, netdev->name, bp->queues);
+			if (err) {
+				dev_err(dev,
+					"Unable to request IRQ %d (error %d)\n",
+					bp->queues[0].irq, err);
+				return err;
+			}
 			queue_writel(bp->queues, IER, MACB_BIT(WOL));
 			macb_writel(bp, WOL, MACB_BIT(MAG));
 		}
-- 
2.27.0

