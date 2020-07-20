Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 930B0225A95
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 10:57:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728080AbgGTI5N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 04:57:13 -0400
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:63183 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726389AbgGTI5L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 04:57:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1595235430; x=1626771430;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/e1EQdE91DV49huEyVqQFdGvucwiFWDil1ct9uq7Ps4=;
  b=L/4zGwEGIdnj4UstIb1eGlYQ7tR0AgCxystfNIRirHX5z7/DHPr14J8m
   zV2RyAUba4Dq0XK4bLq48DVUM9kbuxrkLw5pKfwDvowSrzW9VODwirLN4
   kfsHoL/nVFrsvgehZ0UzOfSH4hVUnGMjz3mMYSGla2EpaHGD+22Wm+atC
   l1dRLFwT6MvXHAhwS0T+BkVANQ56r5Q/uLKGkoTi0JNL9E9vJUh+MRMa+
   a7hk4HvrZ0z5HstiDJPGPQBTw7QJXQu02enYZvLJ7NAJSYcC8CefD5GTS
   KF1dEjjnS/kjH5+Uilnp/mYXsJ2i582zOZ+QxeY0BucdU2DSeGrcvnuLy
   g==;
IronPort-SDR: OKEW+8XYfPKC2ailDd5Bv4B5de+SaHw/iQEHOQuNhYLzq+6tpBexBLuwolinUtUKTusInKAEue
 ZTsFHlty6vnpbkJKod23s9DFttc7y9gX20Ih0VDToSQcWqKRWDaWnF+BSpSYWAHYWohxLl/GaL
 DhpU+EMKRO8oxtsNh+dGyD8tZPt3zTTAw6HmZCGxqkjleGq4QgPi/P3OauHXAq9XyHjswGvz36
 s74UGJD21ku2JLcfLb9uqeTl8ylG19sqRTP8KrfAoP4hir7wiIDd5sP1AZNbRFj6tWyUlanydV
 pEI=
X-IronPort-AV: E=Sophos;i="5.75,374,1589266800"; 
   d="scan'208";a="19791041"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 20 Jul 2020 01:57:10 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 20 Jul 2020 01:57:10 -0700
Received: from ness.mchp-main.com (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Mon, 20 Jul 2020 01:57:07 -0700
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
Subject: [PATCH v7 1/2] net: macb: WoL support for GEM type of Ethernet controller
Date:   Mon, 20 Jul 2020 10:56:52 +0200
Message-ID: <b973e5a468542652cbefba7dfb37cb7451a8c60e.1595235208.git.nicolas.ferre@microchip.com>
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
Changes in v7:
- Release the spinlock before exiting macb_suspend/resume in case of error
  changing IRQ handler

 drivers/net/ethernet/cadence/macb.h      |   3 +
 drivers/net/ethernet/cadence/macb_main.c | 153 +++++++++++++++++++----
 2 files changed, 129 insertions(+), 27 deletions(-)

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
index e5e37aa81b02..0f2417f09514 100644
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
@@ -4567,33 +4598,68 @@ static int __maybe_unused macb_suspend(struct device *dev)
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
+				spin_unlock_irqrestore(&bp->lock, flags);
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
@@ -4608,7 +4674,9 @@ static int __maybe_unused macb_resume(struct device *dev)
 	struct net_device *netdev = dev_get_drvdata(dev);
 	struct macb *bp = netdev_priv(netdev);
 	struct macb_queue *queue = bp->queues;
+	unsigned long flags;
 	unsigned int q;
+	int err;
 
 	if (!netif_running(netdev))
 		return 0;
@@ -4617,29 +4685,60 @@ static int __maybe_unused macb_resume(struct device *dev)
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
+			spin_unlock_irqrestore(&bp->lock, flags);
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

