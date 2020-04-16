Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A34811ACF0B
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 19:47:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436700AbgDPRpg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 13:45:36 -0400
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:33935 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436526AbgDPRpf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Apr 2020 13:45:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1587059134; x=1618595134;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1gQFYv/wxSy8NSQledSt8Au4CSTxB96l8SvfBihusHg=;
  b=w0+l8zJUpnyIGoUuBfYAmrjeNwfoFoSAqKyKVXfc3oAf8BNav7JA4A4I
   nZKe7KzfYrelxXt3cA4oXucu+B7e8R+VFBVAN8fu14V3uWvmiJCbhjV4w
   5csoEHgKvNSP4jLsrXK3QynKO64qiizFifCMkkq/ilWQ9VJUFHRncUOtY
   9vL8NEcGDPUBXDn+Baj6rLEFEpRd1hans15R80E9Juy85pc0QmO3OY+Ol
   HYhMvoAW+0LqBXMvOent0PS4I0CXJ7ckDSrFWQeIuqFjH4Pv9KBkPJqBP
   l8wKYndPAlH7duvVx/obSul7WGq9545cBWnhOAFUqup/Llmsrk/bKThG4
   A==;
IronPort-SDR: RRv8XikDocCRNpPit1Rw49y7XIb4+YXQS9+HbZbRBEJhq96QoM2khX5iIy9p12gHeMfM79V9IC
 hl+rFpxmjIj9qTZN8ZKybNIdRrqQtwu5jeXr3W4uN2ViJZehgQOWXpOocckcnI02mB/FpLIVCh
 A97IOZcmGVuCOLh5As/jdxzJh3HHFRNSZrg1pKxe9NU7i4a8lOXaTJtyKBy/kHFQbtDJhG776h
 4Yx+XgOIcLpWx+CC6i3ZfjpRpsGKKBs/FBxCn+/3PnGhzSJbIqc9fHb7undzg7eh9LKEkJIW7u
 rKQ=
X-IronPort-AV: E=Sophos;i="5.72,391,1580799600"; 
   d="scan'208";a="76173957"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 16 Apr 2020 10:45:34 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 16 Apr 2020 10:45:38 -0700
Received: from ness.corp.atmel.com (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Thu, 16 Apr 2020 10:45:27 -0700
From:   <nicolas.ferre@microchip.com>
To:     <linux-arm-kernel@lists.infradead.org>, <netdev@vger.kernel.org>,
        "Claudiu Beznea" <claudiu.beznea@microchip.com>,
        <harini.katakam@xilinx.com>
CC:     <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        <pthombar@cadence.com>, <sergio.prado@e-labworks.com>,
        <antoine.tenart@bootlin.com>, <f.fainelli@gmail.com>,
        <linux@armlinux.org.uk>, <andrew@lunn.ch>,
        <michal.simek@xilinx.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>
Subject: [PATCH 5/5] net: macb: Add WoL interrupt support for MACB type of Ethernet controller
Date:   Thu, 16 Apr 2020 19:44:32 +0200
Message-ID: <3c9db82da283abd7faf248985d21155a48554bdf.1587058078.git.nicolas.ferre@microchip.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1587058078.git.nicolas.ferre@microchip.com>
References: <cover.1587058078.git.nicolas.ferre@microchip.com>
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

Signed-off-by: Nicolas Ferre <nicolas.ferre@microchip.com>
---
 drivers/net/ethernet/cadence/macb_main.c | 38 +++++++++++++++++++++++-
 1 file changed, 37 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 71e6afbdfb47..6d535e3e803c 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -1513,6 +1513,34 @@ static void macb_tx_restart(struct macb_queue *queue)
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
@@ -4585,8 +4613,8 @@ static int __maybe_unused macb_suspend(struct device *dev)
 		/* Change interrupt handler and
 		 * Enable WoL IRQ on queue 0
 		 */
+		devm_free_irq(dev, bp->queues[0].irq, bp->queues);
 		if (macb_is_gem(bp)) {
-			devm_free_irq(dev, bp->queues[0].irq, bp->queues);
 			err = devm_request_irq(dev, bp->queues[0].irq, gem_wol_interrupt,
 					       IRQF_SHARED, netdev->name, bp->queues);
 			if (err) {
@@ -4598,6 +4626,14 @@ static int __maybe_unused macb_suspend(struct device *dev)
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

