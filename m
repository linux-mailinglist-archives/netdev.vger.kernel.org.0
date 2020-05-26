Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C88D1E1F10
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 11:47:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731838AbgEZJrL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 05:47:11 -0400
Received: from relmlor1.renesas.com ([210.160.252.171]:4494 "EHLO
        relmlie5.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728782AbgEZJrL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 05:47:11 -0400
X-IronPort-AV: E=Sophos;i="5.73,436,1583161200"; 
   d="scan'208";a="48050338"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie5.idc.renesas.com with ESMTP; 26 May 2020 18:47:09 +0900
Received: from localhost.localdomain (unknown [10.166.252.89])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id 85C1D4205327;
        Tue, 26 May 2020 18:47:09 +0900 (JST)
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     sergei.shtylyov@cogentembedded.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     dirk.behme@de.bosch.com, Shashikant.Suguni@in.bosch.com,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Subject: [PATCH/RFC] net: ethernet: ravb: Try to wake subqueue instead of stop on timeout
Date:   Tue, 26 May 2020 18:46:59 +0900
Message-Id: <1590486419-9289-1-git-send-email-yoshihiro.shimoda.uh@renesas.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

According to the report of [1], this driver is possible to cause
the following error in ravb_tx_timeout_work().

ravb e6800000.ethernet ethernet: failed to switch device to config mode

This error means that the hardware could not change the state
from "Operation" to "Configuration" while some tx queue is operating.
After that, ravb_config() in ravb_dmac_init() will fail, and then
any descriptors will be not allocaled anymore so that NULL porinter
dereference happens after that on ravb_start_xmit().

Such a case is possible to be caused because this driver supports
two queues (NC and BE) and the ravb_stop_dma() is possible to return
without any stopping process if TCCR or CSR register indicates
the hardware is operating for TX.

To fix the issue, just try to wake the subqueue on
ravb_tx_timeout_work() if the descriptors are not full instead
of stop all transfers (all queues of TX and RX).

[1]
https://lore.kernel.org/linux-renesas-soc/20200518045452.2390-1-dirk.behme@de.bosch.com/

Reported-by: Dirk Behme <dirk.behme@de.bosch.com>
Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
---
 I'm guessing that this issue is possible to happen if:
 - ravb_start_xmit() calls netif_stop_subqueue(), and
 - ravb_poll() will not be called with some reason, and
 - netif_wake_subqueue() will be not called, and then
 - dev_watchdog() in net/sched/sch_generic.c calls ndo_tx_timeout().

 However, unfortunately, I didn't reproduce the issue yet.
 To be honest, I'm also guessing other queues (SR) of this hardware
 which out-of tree driver manages are possible to reproduce this issue,
 but I didn't try such environment for now...

 So, I marked RFC on this patch now.

 drivers/net/ethernet/renesas/ravb.h      |  1 -
 drivers/net/ethernet/renesas/ravb_main.c | 48 ++++++++++----------------------
 2 files changed, 14 insertions(+), 35 deletions(-)

diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
index 9f88b5d..42cf41a 100644
--- a/drivers/net/ethernet/renesas/ravb.h
+++ b/drivers/net/ethernet/renesas/ravb.h
@@ -1021,7 +1021,6 @@ struct ravb_private {
 	u32 cur_tx[NUM_TX_QUEUE];
 	u32 dirty_tx[NUM_TX_QUEUE];
 	struct napi_struct napi[NUM_RX_QUEUE];
-	struct work_struct work;
 	/* MII transceiver section. */
 	struct mii_bus *mii_bus;	/* MDIO bus control */
 	int link;
diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index 067ad25..45e1ecd 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -1428,44 +1428,25 @@ static int ravb_open(struct net_device *ndev)
 static void ravb_tx_timeout(struct net_device *ndev, unsigned int txqueue)
 {
 	struct ravb_private *priv = netdev_priv(ndev);
+	unsigned long flags;
+	bool wake = false;
+
+	spin_lock_irqsave(&priv->lock, flags);
+	if (priv->cur_tx[txqueue] - priv->dirty_tx[txqueue] <=
+	    (priv->num_tx_ring[txqueue] - 1) * priv->num_tx_desc)
+		wake = true;
 
 	netif_err(priv, tx_err, ndev,
-		  "transmit timed out, status %08x, resetting...\n",
-		  ravb_read(ndev, ISS));
+		  "transmit timed out (%d %d), status %08x %08x %08x\n",
+		  txqueue, wake, ravb_read(ndev, ISS), ravb_read(ndev, TCCR),
+		  ravb_read(ndev, CSR));
+
+	if (wake)
+		netif_wake_subqueue(ndev, txqueue);
 
 	/* tx_errors count up */
 	ndev->stats.tx_errors++;
-
-	schedule_work(&priv->work);
-}
-
-static void ravb_tx_timeout_work(struct work_struct *work)
-{
-	struct ravb_private *priv = container_of(work, struct ravb_private,
-						 work);
-	struct net_device *ndev = priv->ndev;
-
-	netif_tx_stop_all_queues(ndev);
-
-	/* Stop PTP Clock driver */
-	if (priv->chip_id == RCAR_GEN2)
-		ravb_ptp_stop(ndev);
-
-	/* Wait for DMA stopping */
-	ravb_stop_dma(ndev);
-
-	ravb_ring_free(ndev, RAVB_BE);
-	ravb_ring_free(ndev, RAVB_NC);
-
-	/* Device init */
-	ravb_dmac_init(ndev);
-	ravb_emac_init(ndev);
-
-	/* Initialise PTP Clock driver */
-	if (priv->chip_id == RCAR_GEN2)
-		ravb_ptp_init(ndev, priv->pdev);
-
-	netif_tx_start_all_queues(ndev);
+	spin_unlock_irqrestore(&priv->lock, flags);
 }
 
 /* Packet transmit function for Ethernet AVB */
@@ -2046,7 +2027,6 @@ static int ravb_probe(struct platform_device *pdev)
 	}
 
 	spin_lock_init(&priv->lock);
-	INIT_WORK(&priv->work, ravb_tx_timeout_work);
 
 	error = of_get_phy_mode(np, &priv->phy_interface);
 	if (error && error != -ENODEV)
-- 
2.7.4

