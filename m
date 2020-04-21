Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 540FF1B2415
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 12:42:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728743AbgDUKmL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 06:42:11 -0400
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:49903 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728711AbgDUKmD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Apr 2020 06:42:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1587465724; x=1619001724;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=T+SHH7oxvWS5aNKMFbJfCt0u557PHi+U5oRX3v2DzvA=;
  b=Z9O2kjSablrS87X8e68dGdvDp6qERJ+5AQTHHoLJGgtQ9zy4LuiMZRCv
   QnZmcq6w1Y7tKPVTouiZeO06n3/iufajtvs/6IX/K/MzEHucEuu+GUZc0
   EKaWSC3TlgRmZyRZq5u6Tscd0uPPZD2QPiQMn1wPZzqSs5DR+I/gJ7+QM
   8UdTso3Z5NIOvL7CwCypJ9oe3IfdBVy52maJYqiF0b8gTjlW10NIbSuY+
   nNk66eO4/KCVu3RYNdzZJ9gp31E84JH8ep0ZghzTqZv2NUnLGvBdmoDs4
   aVfI+eVfL7w3wGkGZpkmWy9rd89wjBeRFLiy1IUEbTr9E8gfOzwvLuUyf
   A==;
IronPort-SDR: c1zZGebHpOG5PEqgnAxaF1BZUCGDMkmuc4r5A+tf/W190ebzTdttTkarIMJuR35W00Eh2Ir+Cd
 DH2xL4wUumpmsdKUN5I/Si+g28adu2E6Uzy8VEH9AUx5UOzYlIwlrt03rFDXPterGaBEwXLJMj
 OrdDKGVRfLW8TaTKeGK2L5rLl+l9DHFCz4B5H8/hlS06KWA2RtNLrjC0bnh+hPx+oZCdBcn5QB
 XD3Up1wD0SZQsFvxVFWn4K3GDeGdL3+xjN+1bsYyBO1iIYnCshGcwXilNR56BpUOoiWZCskXzi
 irA=
X-IronPort-AV: E=Sophos;i="5.72,410,1580799600"; 
   d="scan'208";a="73257541"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 21 Apr 2020 03:42:03 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 21 Apr 2020 03:42:05 -0700
Received: from ness.microchip.com (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Tue, 21 Apr 2020 03:42:00 -0700
From:   <nicolas.ferre@microchip.com>
To:     <linux-arm-kernel@lists.infradead.org>, <netdev@vger.kernel.org>,
        "Claudiu Beznea" <claudiu.beznea@microchip.com>,
        <harini.katakam@xilinx.com>
CC:     <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        <sergio.prado@e-labworks.com>, <antoine.tenart@bootlin.com>,
        <f.fainelli@gmail.com>, <linux@armlinux.org.uk>, <andrew@lunn.ch>,
        <michal.simek@xilinx.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>
Subject: [PATCH v2 7/7] net: macb: Add WoL interrupt support for MACB type of Ethernet controller
Date:   Tue, 21 Apr 2020 12:41:04 +0200
Message-ID: <bebb6e87da4be4b000c059351f3a4d82ecffa561.1587463802.git.nicolas.ferre@microchip.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1587463802.git.nicolas.ferre@microchip.com>
References: <cover.1587463802.git.nicolas.ferre@microchip.com>
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
index 56ce39dd1cc0..4249be829aaf 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -1513,6 +1513,35 @@ static void macb_tx_restart(struct macb_queue *queue)
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
@@ -4586,8 +4615,8 @@ static int __maybe_unused macb_suspend(struct device *dev)
 		/* Change interrupt handler and
 		 * Enable WoL IRQ on queue 0
 		 */
+		devm_free_irq(dev, bp->queues[0].irq, bp->queues);
 		if (macb_is_gem(bp)) {
-			devm_free_irq(dev, bp->queues[0].irq, bp->queues);
 			err = devm_request_irq(dev, bp->queues[0].irq, gem_wol_interrupt,
 					       IRQF_SHARED, netdev->name, bp->queues);
 			if (err) {
@@ -4599,6 +4628,14 @@ static int __maybe_unused macb_suspend(struct device *dev)
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
2.20.1

