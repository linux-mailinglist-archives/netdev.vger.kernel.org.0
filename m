Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7C1521D368
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 12:06:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729634AbgGMKFz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 06:05:55 -0400
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:2223 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729620AbgGMKFx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 06:05:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1594634753; x=1626170753;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=j4fbE/Ra2zunqbefrRtifT/kkezAH7ZZwuMWC07541Y=;
  b=pdaD6yei1ZOhP5kLFrgIItTxdosJw8Wl1DriU5j9R6S1NKvqIsZFXQ1a
   hVCEcUeDR1eqncyYFrRpw35gJhyssd1GSSh2Yex0bk2wa2TQlilcN+dfI
   9es1bMGN+5gN5Wqu1reDKvr1/dXJYaYnP8VUTlh6I0QpMVDtG4KJOZDVt
   34+0R1jY5f1RuW0chPcK9//41ow+Dv1Xu9b3Sxvxog3Zu7CLPY0LGB3sq
   1s03s01E1oUFeI6qhV0L9kiUC/6LySuKbaNApfMOdcoW3nCQ3WTx8fqFX
   M5aQKYoFsgFOoIEhNZqpouwrXjoWy446S54xIenrJQ4jBFXTgYz15xuZY
   Q==;
IronPort-SDR: TfWC43o5Onk8BgX+tKI0ThUZCT8mtd/M6nsD1BxQBqG2ncByKDRTqeM38/X72u+2deAm54zDYE
 zQ/hr0qDoC67p85s3W1sNF13jgcpkNp3Hg9si4rHsb1m97r1R5Q1fgDAXT20qDI+3b2UMD9OQ8
 zs50t174y6wYlRcamsutyzCgGj1dYDWXCAzbz4HLFicB4KVub9mqf4vYZ1/NmJSa0GQ+aSW6QT
 Frc+VZLZdJiUU0TiPaFeK1WvRekrqgQCqMdKD6Eyr4BOb3aptTkGD8y60LlazkXekyWfC+/+I2
 eiI=
X-IronPort-AV: E=Sophos;i="5.75,347,1589266800"; 
   d="scan'208";a="18953335"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 13 Jul 2020 03:05:52 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 13 Jul 2020 03:05:50 -0700
Received: from ness.mchp-main.com (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Mon, 13 Jul 2020 03:05:16 -0700
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
Subject: [PATCH v6 1/2] net: macb: WoL support for GEM type of Ethernet controller
Date:   Mon, 13 Jul 2020 12:05:25 +0200
Message-ID: <1e40c4277d85b2ae23c8baca6f75ad25dbd35446.1594632220.git.nicolas.ferre@microchip.com>
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

Adapt the Wake-on-Lan feature to the Cadence GEM Ethernet controller.
This controller has different register layout and cannot be handled by
previous code.
We disable completely interrupts on all the queues but the queue 0.
Handling of WoL interrupt is done in another interrupt handler
positioned depending on the controller version used, just between
suspend() and resume() calls.
It allows to lower pressure on the generic interrupt hot path by
removing the need to handle 2 tests for each IRQ: the first figuring out
the controller revision, the second for actually knowing if the WoL bit
is set.

Queue management in suspend()/resume() functions inspired from RFC patch
by Harini Katakam <harinik@xilinx.com>, thanks!

Cc: Claudiu Beznea <claudiu.beznea@microchip.com>
Cc: Harini Katakam <harini.katakam@xilinx.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@microchip.com>
---
Changes in v6:
- Values of registers usrio and scrt2 properly read in any case (WoL or not)
  during macb_suspend() to be restored during macb_resume()

Changes in v3:
- In macb_resume(), move to a more in-depth re-configuration of the controller
  even on the non-WoL path in order to accept deeper sleep states.
- this ends up having a phylink_stop()/phylink_start() for each of the
  WoL/!WoL paths
- In macb_resume(), keep setting the MPE bit in NCR register which is needed in
  case of deep power saving mode used
- Tests done in "standby" as well as our deeper Power Management mode:
  Backup Self-Refresh (BSR)

Changes in v2:
- Addition of pm_wakeup_event() in WoL IRQ
- In macb_resume(), removal of setting the MPE bit in NCR register which is not
  needed in any case: IP is reset on the usual path and kept alive if WoL is used
- In macb_resume(), complete reset of the controller is kept only for non-WoL
  case. For the WoL case, we only replace the usual IRQ handler.

 drivers/net/ethernet/cadence/macb.h      |   3 +
 drivers/net/ethernet/cadence/macb_main.c | 151 +++++++++++++++++++----
 2 files changed, 127 insertions(+), 27 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb.h b/drivers/net/ethernet/cadence/macb.h
index ab827fb4b6b9..4f1b41569260 100644
--- a/drivers/net/ethernet/cadence/macb.h
+++ b/drivers/net/ethernet/cadence/macb.h
@@ -90,6 +90,7 @@
 #define GEM_SA3T		0x009C /* Specific3 Top */
 #define GEM_SA4B		0x00A0 /* Specific4 Bottom */
 #define GEM_SA4T		0x00A4 /* Specific4 Top */
+#define GEM_WOL			0x00b8 /* Wake on LAN */
 #define GEM_EFTSH		0x00e8 /* PTP Event Frame Transmitted Seconds Register 47:32 */
 #define GEM_EFRSH		0x00ec /* PTP Event Frame Received Seconds Register 47:32 */
 #define GEM_PEFTSH		0x00f0 /* PTP Peer Event Frame Transmitted Seconds Register 47:32 */
@@ -396,6 +397,8 @@
 #define MACB_PDRSFT_SIZE	1
 #define MACB_SRI_OFFSET		26 /* TSU Seconds Register Increment */
 #define MACB_SRI_SIZE		1
+#define GEM_WOL_OFFSET		28 /* Enable wake-on-lan interrupt */
+#define GEM_WOL_SIZE		1
 
 /* Timer increment fields */
 #define MACB_TI_CNS_OFFSET	0
diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index e5e37aa81b02..122c54e40f91 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -1517,6 +1517,35 @@ static void macb_tx_restart(struct macb_queue *queue)
 	macb_writel(bp, NCR, macb_readl(bp, NCR) | MACB_BIT(TSTART));
 }
 
+static irqreturn_t gem_wol_interrupt(int irq, void *dev_id)
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
+	if (status & GEM_BIT(WOL)) {
+		queue_writel(queue, IDR, GEM_BIT(WOL));
+		gem_writel(bp, WOL, 0);
+		netdev_vdbg(bp->dev, "GEM WoL: queue = %u, isr = 0x%08lx\n",
+			    (unsigned int)(queue - bp->queues),
+			    (unsigned long)status);
+		if (bp->caps & MACB_CAPS_ISR_CLEAR_ON_WRITE)
+			queue_writel(queue, ISR, GEM_BIT(WOL));
+		pm_wakeup_event(&bp->pdev->dev, 0);
+	}
+
+	spin_unlock(&bp->lock);
+
+	return IRQ_HANDLED;
+}
+
 static irqreturn_t macb_interrupt(int irq, void *dev_id)
 {
 	struct macb_queue *queue = dev_id;
@@ -3316,6 +3345,8 @@ static const struct ethtool_ops macb_ethtool_ops = {
 static const struct ethtool_ops gem_ethtool_ops = {
 	.get_regs_len		= macb_get_regs_len,
 	.get_regs		= macb_get_regs,
+	.get_wol		= macb_get_wol,
+	.set_wol		= macb_set_wol,
 	.get_link		= ethtool_op_get_link,
 	.get_ts_info		= macb_get_ts_info,
 	.get_ethtool_stats	= gem_get_ethtool_stats,
@@ -4567,33 +4598,67 @@ static int __maybe_unused macb_suspend(struct device *dev)
 	struct macb_queue *queue = bp->queues;
 	unsigned long flags;
 	unsigned int q;
+	int err;
 
 	if (!netif_running(netdev))
 		return 0;
 
 	if (bp->wol & MACB_WOL_ENABLED) {
-		macb_writel(bp, IER, MACB_BIT(WOL));
-		macb_writel(bp, WOL, MACB_BIT(MAG));
-		enable_irq_wake(bp->queues[0].irq);
-		netif_device_detach(netdev);
-	} else {
-		netif_device_detach(netdev);
+		spin_lock_irqsave(&bp->lock, flags);
+		/* Flush all status bits */
+		macb_writel(bp, TSR, -1);
+		macb_writel(bp, RSR, -1);
 		for (q = 0, queue = bp->queues; q < bp->num_queues;
-		     ++q, ++queue)
-			napi_disable(&queue->napi);
+		     ++q, ++queue) {
+			/* Disable all interrupts */
+			queue_writel(queue, IDR, -1);
+			queue_readl(queue, ISR);
+			if (bp->caps & MACB_CAPS_ISR_CLEAR_ON_WRITE)
+				queue_writel(queue, ISR, -1);
+		}
+		/* Change interrupt handler and
+		 * Enable WoL IRQ on queue 0
+		 */
+		if (macb_is_gem(bp)) {
+			devm_free_irq(dev, bp->queues[0].irq, bp->queues);
+			err = devm_request_irq(dev, bp->queues[0].irq, gem_wol_interrupt,
+					       IRQF_SHARED, netdev->name, bp->queues);
+			if (err) {
+				dev_err(dev,
+					"Unable to request IRQ %d (error %d)\n",
+					bp->queues[0].irq, err);
+				return err;
+			}
+			queue_writel(bp->queues, IER, GEM_BIT(WOL));
+			gem_writel(bp, WOL, MACB_BIT(MAG));
+		} else {
+			queue_writel(bp->queues, IER, MACB_BIT(WOL));
+			macb_writel(bp, WOL, MACB_BIT(MAG));
+		}
+		spin_unlock_irqrestore(&bp->lock, flags);
+
+		enable_irq_wake(bp->queues[0].irq);
+	}
+
+	netif_device_detach(netdev);
+	for (q = 0, queue = bp->queues; q < bp->num_queues;
+	     ++q, ++queue)
+		napi_disable(&queue->napi);
+
+	if (!(bp->wol & MACB_WOL_ENABLED)) {
 		rtnl_lock();
 		phylink_stop(bp->phylink);
 		rtnl_unlock();
 		spin_lock_irqsave(&bp->lock, flags);
 		macb_reset_hw(bp);
 		spin_unlock_irqrestore(&bp->lock, flags);
+	}
 
-		if (!(bp->caps & MACB_CAPS_USRIO_DISABLED))
-			bp->pm_data.usrio = macb_or_gem_readl(bp, USRIO);
+	if (!(bp->caps & MACB_CAPS_USRIO_DISABLED))
+		bp->pm_data.usrio = macb_or_gem_readl(bp, USRIO);
 
-		if (netdev->hw_features & NETIF_F_NTUPLE)
-			bp->pm_data.scrt2 = gem_readl_n(bp, ETHT, SCRT2_ETHT);
-	}
+	if (netdev->hw_features & NETIF_F_NTUPLE)
+		bp->pm_data.scrt2 = gem_readl_n(bp, ETHT, SCRT2_ETHT);
 
 	if (bp->ptp_info)
 		bp->ptp_info->ptp_remove(netdev);
@@ -4608,7 +4673,9 @@ static int __maybe_unused macb_resume(struct device *dev)
 	struct net_device *netdev = dev_get_drvdata(dev);
 	struct macb *bp = netdev_priv(netdev);
 	struct macb_queue *queue = bp->queues;
+	unsigned long flags;
 	unsigned int q;
+	int err;
 
 	if (!netif_running(netdev))
 		return 0;
@@ -4617,29 +4684,59 @@ static int __maybe_unused macb_resume(struct device *dev)
 		pm_runtime_force_resume(dev);
 
 	if (bp->wol & MACB_WOL_ENABLED) {
-		macb_writel(bp, IDR, MACB_BIT(WOL));
-		macb_writel(bp, WOL, 0);
-		disable_irq_wake(bp->queues[0].irq);
-	} else {
-		macb_writel(bp, NCR, MACB_BIT(MPE));
-
-		if (netdev->hw_features & NETIF_F_NTUPLE)
-			gem_writel_n(bp, ETHT, SCRT2_ETHT, bp->pm_data.scrt2);
+		spin_lock_irqsave(&bp->lock, flags);
+		/* Disable WoL */
+		if (macb_is_gem(bp)) {
+			queue_writel(bp->queues, IDR, GEM_BIT(WOL));
+			gem_writel(bp, WOL, 0);
+		} else {
+			queue_writel(bp->queues, IDR, MACB_BIT(WOL));
+			macb_writel(bp, WOL, 0);
+		}
+		/* Clear ISR on queue 0 */
+		queue_readl(bp->queues, ISR);
+		if (bp->caps & MACB_CAPS_ISR_CLEAR_ON_WRITE)
+			queue_writel(bp->queues, ISR, -1);
+		/* Replace interrupt handler on queue 0 */
+		devm_free_irq(dev, bp->queues[0].irq, bp->queues);
+		err = devm_request_irq(dev, bp->queues[0].irq, macb_interrupt,
+				       IRQF_SHARED, netdev->name, bp->queues);
+		if (err) {
+			dev_err(dev,
+				"Unable to request IRQ %d (error %d)\n",
+				bp->queues[0].irq, err);
+			return err;
+		}
+		spin_unlock_irqrestore(&bp->lock, flags);
 
-		if (!(bp->caps & MACB_CAPS_USRIO_DISABLED))
-			macb_or_gem_writel(bp, USRIO, bp->pm_data.usrio);
+		disable_irq_wake(bp->queues[0].irq);
 
-		for (q = 0, queue = bp->queues; q < bp->num_queues;
-		     ++q, ++queue)
-			napi_enable(&queue->napi);
+		/* Now make sure we disable phy before moving
+		 * to common restore path
+		 */
 		rtnl_lock();
-		phylink_start(bp->phylink);
+		phylink_stop(bp->phylink);
 		rtnl_unlock();
 	}
 
+	for (q = 0, queue = bp->queues; q < bp->num_queues;
+	     ++q, ++queue)
+		napi_enable(&queue->napi);
+
+	if (netdev->hw_features & NETIF_F_NTUPLE)
+		gem_writel_n(bp, ETHT, SCRT2_ETHT, bp->pm_data.scrt2);
+
+	if (!(bp->caps & MACB_CAPS_USRIO_DISABLED))
+		macb_or_gem_writel(bp, USRIO, bp->pm_data.usrio);
+
+	macb_writel(bp, NCR, MACB_BIT(MPE));
 	macb_init_hw(bp);
 	macb_set_rx_mode(netdev);
 	macb_restore_features(bp);
+	rtnl_lock();
+	phylink_start(bp->phylink);
+	rtnl_unlock();
+
 	netif_device_attach(netdev);
 	if (bp->ptp_info)
 		bp->ptp_info->ptp_init(netdev);
-- 
2.27.0

