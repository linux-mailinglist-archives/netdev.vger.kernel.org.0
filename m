Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A597A225A97
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 10:57:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728117AbgGTI5Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 04:57:16 -0400
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:1758 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728100AbgGTI5O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 04:57:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1595235434; x=1626771434;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=cemYVO2NR8Vt9TJaqNzu0tWlo2LLnx/QbJ7ii6EaNI8=;
  b=JWxpGQOPQrCoc5TdDeoU88LiiY8tWYgXJXGT4cKmGVQx46qEdfGj9Uod
   U7RAqgFDapnOonrNlXUEywzaVrwPLsjZF5qjXwmDvk/SEdAuRykorNyR3
   1Cjrtr8xZpgQEt31N32S9McEzCZy8CzFEaYeNCInH8UbXvEkcYcteeDNV
   wEeNqQt6yfHFRW0/uITWKb8UVGrPTx7t9Vhx7fEIp26Glbil29UaSMRjH
   mJZKDjz090KUfZIMHbDxVs1HaB0C4/sdDGhskBzRPRYi19gvjpEwrqARQ
   WmjKZcr+ffeb8/TZqiu2M/fm+jeFWqTJWXZwROvG4cF//O6UnH4w5l0m8
   g==;
IronPort-SDR: 4FmccSBai2gQd+OiskIqZNqi3tjhgpzZ0X6D7XO72PWs2yV8aWaIiKi228QUIFM/GN9H3p/cAQ
 g5B2G58HtmPFQionnB1QXV3CQjAcHaMy8bjx6HP0oBZD9HvhXbf3HNgX1Kd5gThkClB3cxNJTF
 vNJ41anS2I+WBcypnasyh9CN7WOMuV+gboQOENS+895JUF09slXtbcX5leWv2hBhJRqyiW77II
 pgOdatYqhSqC6zVC5gvuKjZjNMvtU5oYlX9z1LDviBLWrKm38eX5oLyRM7z/2bl4/bxRi7eML5
 eiM=
X-IronPort-AV: E=Sophos;i="5.75,374,1589266800"; 
   d="scan'208";a="80555398"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 20 Jul 2020 01:57:13 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 20 Jul 2020 01:57:12 -0700
Received: from ness.mchp-main.com (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Mon, 20 Jul 2020 01:57:10 -0700
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
Subject: [PATCH v7 2/2] net: macb: Add WoL interrupt support for MACB type of Ethernet controller
Date:   Mon, 20 Jul 2020 10:56:53 +0200
Message-ID: <1fcecd897a9391897593c1d5025719c8254c30a5.1595235208.git.nicolas.ferre@microchip.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1595235208.git.nicolas.ferre@microchip.com>
References: <cover.1595235208.git.nicolas.ferre@microchip.com>
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
Changes in v7:
- Release the spinlock before exiting macb_suspend in case of error
  changing IRQ handler

 drivers/net/ethernet/cadence/macb_main.c | 40 +++++++++++++++++++++++-
 1 file changed, 39 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 0f2417f09514..a6a35e1b0115 100644
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
@@ -4633,6 +4662,15 @@ static int __maybe_unused macb_suspend(struct device *dev)
 			queue_writel(bp->queues, IER, GEM_BIT(WOL));
 			gem_writel(bp, WOL, MACB_BIT(MAG));
 		} else {
+			err = devm_request_irq(dev, bp->queues[0].irq, macb_wol_interrupt,
+					       IRQF_SHARED, netdev->name, bp->queues);
+			if (err) {
+				dev_err(dev,
+					"Unable to request IRQ %d (error %d)\n",
+					bp->queues[0].irq, err);
+				spin_unlock_irqrestore(&bp->lock, flags);
+				return err;
+			}
 			queue_writel(bp->queues, IER, MACB_BIT(WOL));
 			macb_writel(bp, WOL, MACB_BIT(MAG));
 		}
-- 
2.27.0

