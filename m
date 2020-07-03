Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A861213B86
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 16:11:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726376AbgGCOLE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jul 2020 10:11:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726035AbgGCOLD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jul 2020 10:11:03 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 729DEC08C5C1
        for <netdev@vger.kernel.org>; Fri,  3 Jul 2020 07:11:03 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id q7so23902241ljm.1
        for <netdev@vger.kernel.org>; Fri, 03 Jul 2020 07:11:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:organization;
        bh=IYbfdjHjpIB0MZpMz9LAbI31Jl9BdKszNIeScgKue38=;
        b=pOyF66QFsLCeO4sK7nndPcYACcCXiukHiuHdImpsSKu+dLQHm9uOw7Vvz2wrKw1v7r
         ngX7vQe97IMqo3lu77LhGqDVS1cnPOQ0gnp6qsJ2K+QN5fJaSGPT0p7Njqwz9FDAXSpB
         LPWyW9tE/SwngeJyHCB9M/XnmYZVGWdZLVqdAGFcKSVyyjjDkFOP/hDQpSURh+Vg9oXJ
         ibtsFt6+Kvw9vFFtQZBVqFvmvc4w3eELfqH3tm0ekbnCgaLBQw9666B4HEK7BQwwPWNE
         zRBabD8s3mSxkbdN+XXHzsKxAQAJx3EvtedgPVHEXuQ5T0eKoAsPboyNnwLORB1BBcdn
         b1ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:organization;
        bh=IYbfdjHjpIB0MZpMz9LAbI31Jl9BdKszNIeScgKue38=;
        b=gbs0MyM2k1EdQ2gZHjSqjyA7P0+8l0BSgTIrzSZGZnYY1VPHkvqLWxbobH7/FqxLTN
         fuYb+RhssbSCpGSBEZ720rLKaZr+Xd9XilR/Uzb3dwKgPWkI/uX4Xv9rfe2/+jkl46SO
         m9R7p9YIx97gRvKlHrn+yCT8HeI2+aMaFvfiwss1bvbi+6MCqyhYPKaujlKP/3sIqKrS
         cdgkiUkRleV/FGXYY7nTIU/a0e+nNh23gUAWToHeuki9dxmgaTaq28wHrsvWG2JR9W/o
         BG9DLe3p0u4WPinQ+ZeHLBJr6cyYij1VJQ3eKshvCtTFWk4AQ3uuYh32YDXBz8VvXv2Q
         DEGg==
X-Gm-Message-State: AOAM5315RsSD1ICbuvk95F8jBpwJHfk7bpleTq11H4Y7L20ZA9zJE9bF
        cRaEwlz6/ghW2iFrNCHOPELKeA==
X-Google-Smtp-Source: ABdhPJxhD+ySJ87udsMvERRNuEp76TaCwO1RWBjbdn6mZ2WFBXIDAqOvgNhqlR/tEstaBRym48BzSA==
X-Received: by 2002:a2e:8216:: with SMTP id w22mr13510587ljg.2.1593785461882;
        Fri, 03 Jul 2020 07:11:01 -0700 (PDT)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id f22sm4134305ljn.66.2020.07.03.07.11.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jul 2020 07:11:01 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, fugang.duan@nxp.com
Subject: [PATCH v3 net] net: ethernet: fec: prevent tx starvation under high rx load
Date:   Fri,  3 Jul 2020 16:10:58 +0200
Message-Id: <20200703141058.11320-1-tobias@waldekranz.com>
X-Mailer: git-send-email 2.17.1
Organization: Westermo
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the ISR, we poll the event register for the queues in need of
service and then enter polled mode. After this point, the event
register will never be read again until we exit polled mode.

In a scenario where a UDP flow is routed back out through the same
interface, i.e. "router-on-a-stick" we'll typically only see an rx
queue event initially. Once we start to process the incoming flow
we'll be locked polled mode, but we'll never clean the tx rings since
that event is never caught.

Eventually the netdev watchdog will trip, causing all buffers to be
dropped and then the process starts over again.

Rework the NAPI poll to keep trying to consome the entire budget as
long as new events are coming in, making sure to service all rx/tx
queues, in priority order, on each pass.

Fixes: 4d494cdc92b3 ("net: fec: change data structure to support multiqueue")
Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
---

v2 -> v3:
* Actually iterate over number of tx queues in the tx path, not number
  of rx queues.

v1 -> v2:
* Always do a full pass over all rx/tx queues as soon as any event is
  received, as suggested by David.
* Keep dequeuing packets as long as events keep coming in and we're
  under budget.

 drivers/net/ethernet/freescale/fec.h      |  5 --
 drivers/net/ethernet/freescale/fec_main.c | 94 ++++++++---------------
 2 files changed, 31 insertions(+), 68 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec.h b/drivers/net/ethernet/freescale/fec.h
index a6cdd5b61921..d8d76da51c5e 100644
--- a/drivers/net/ethernet/freescale/fec.h
+++ b/drivers/net/ethernet/freescale/fec.h
@@ -525,11 +525,6 @@ struct fec_enet_private {
 	unsigned int total_tx_ring_size;
 	unsigned int total_rx_ring_size;
 
-	unsigned long work_tx;
-	unsigned long work_rx;
-	unsigned long work_ts;
-	unsigned long work_mdio;
-
 	struct	platform_device *pdev;
 
 	int	dev_id;
diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 2d0d313ee7c5..3982285ed020 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -75,8 +75,6 @@ static void fec_enet_itr_coal_init(struct net_device *ndev);
 
 #define DRIVER_NAME	"fec"
 
-#define FEC_ENET_GET_QUQUE(_x) ((_x == 0) ? 1 : ((_x == 1) ? 2 : 0))
-
 /* Pause frame feild and FIFO threshold */
 #define FEC_ENET_FCE	(1 << 5)
 #define FEC_ENET_RSEM_V	0x84
@@ -1248,8 +1246,6 @@ fec_enet_tx_queue(struct net_device *ndev, u16 queue_id)
 
 	fep = netdev_priv(ndev);
 
-	queue_id = FEC_ENET_GET_QUQUE(queue_id);
-
 	txq = fep->tx_queue[queue_id];
 	/* get next bdp of dirty_tx */
 	nq = netdev_get_tx_queue(ndev, queue_id);
@@ -1340,17 +1336,14 @@ fec_enet_tx_queue(struct net_device *ndev, u16 queue_id)
 		writel(0, txq->bd.reg_desc_active);
 }
 
-static void
-fec_enet_tx(struct net_device *ndev)
+static void fec_enet_tx(struct net_device *ndev)
 {
 	struct fec_enet_private *fep = netdev_priv(ndev);
-	u16 queue_id;
-	/* First process class A queue, then Class B and Best Effort queue */
-	for_each_set_bit(queue_id, &fep->work_tx, FEC_ENET_MAX_TX_QS) {
-		clear_bit(queue_id, &fep->work_tx);
-		fec_enet_tx_queue(ndev, queue_id);
-	}
-	return;
+	int i;
+
+	/* Make sure that AVB queues are processed first. */
+	for (i = fep->num_tx_queues - 1; i >= 0; i--)
+		fec_enet_tx_queue(ndev, i);
 }
 
 static int
@@ -1426,7 +1419,6 @@ fec_enet_rx_queue(struct net_device *ndev, int budget, u16 queue_id)
 #ifdef CONFIG_M532x
 	flush_cache_all();
 #endif
-	queue_id = FEC_ENET_GET_QUQUE(queue_id);
 	rxq = fep->rx_queue[queue_id];
 
 	/* First, grab all of the stats for the incoming packet.
@@ -1550,6 +1542,7 @@ fec_enet_rx_queue(struct net_device *ndev, int budget, u16 queue_id)
 					       htons(ETH_P_8021Q),
 					       vlan_tag);
 
+		skb_record_rx_queue(skb, queue_id);
 		napi_gro_receive(&fep->napi, skb);
 
 		if (is_copybreak) {
@@ -1595,48 +1588,30 @@ fec_enet_rx_queue(struct net_device *ndev, int budget, u16 queue_id)
 	return pkt_received;
 }
 
-static int
-fec_enet_rx(struct net_device *ndev, int budget)
+static int fec_enet_rx(struct net_device *ndev, int budget)
 {
-	int     pkt_received = 0;
-	u16	queue_id;
 	struct fec_enet_private *fep = netdev_priv(ndev);
+	int i, done = 0;
 
-	for_each_set_bit(queue_id, &fep->work_rx, FEC_ENET_MAX_RX_QS) {
-		int ret;
-
-		ret = fec_enet_rx_queue(ndev,
-					budget - pkt_received, queue_id);
+	/* Make sure that AVB queues are processed first. */
+	for (i = fep->num_rx_queues - 1; i >= 0; i--)
+		done += fec_enet_rx_queue(ndev, budget - done, i);
 
-		if (ret < budget - pkt_received)
-			clear_bit(queue_id, &fep->work_rx);
-
-		pkt_received += ret;
-	}
-	return pkt_received;
+	return done;
 }
 
-static bool
-fec_enet_collect_events(struct fec_enet_private *fep, uint int_events)
+static bool fec_enet_collect_events(struct fec_enet_private *fep)
 {
-	if (int_events == 0)
-		return false;
+	uint int_events;
+
+	int_events = readl(fep->hwp + FEC_IEVENT);
 
-	if (int_events & FEC_ENET_RXF_0)
-		fep->work_rx |= (1 << 2);
-	if (int_events & FEC_ENET_RXF_1)
-		fep->work_rx |= (1 << 0);
-	if (int_events & FEC_ENET_RXF_2)
-		fep->work_rx |= (1 << 1);
+	/* Don't clear MDIO events, we poll for those */
+	int_events &= ~FEC_ENET_MII;
 
-	if (int_events & FEC_ENET_TXF_0)
-		fep->work_tx |= (1 << 2);
-	if (int_events & FEC_ENET_TXF_1)
-		fep->work_tx |= (1 << 0);
-	if (int_events & FEC_ENET_TXF_2)
-		fep->work_tx |= (1 << 1);
+	writel(int_events, fep->hwp + FEC_IEVENT);
 
-	return true;
+	return int_events != 0;
 }
 
 static irqreturn_t
@@ -1644,18 +1619,9 @@ fec_enet_interrupt(int irq, void *dev_id)
 {
 	struct net_device *ndev = dev_id;
 	struct fec_enet_private *fep = netdev_priv(ndev);
-	uint int_events;
 	irqreturn_t ret = IRQ_NONE;
 
-	int_events = readl(fep->hwp + FEC_IEVENT);
-
-	/* Don't clear MDIO events, we poll for those */
-	int_events &= ~FEC_ENET_MII;
-
-	writel(int_events, fep->hwp + FEC_IEVENT);
-	fec_enet_collect_events(fep, int_events);
-
-	if ((fep->work_tx || fep->work_rx) && fep->link) {
+	if (fec_enet_collect_events(fep) && fep->link) {
 		ret = IRQ_HANDLED;
 
 		if (napi_schedule_prep(&fep->napi)) {
@@ -1672,17 +1638,19 @@ static int fec_enet_rx_napi(struct napi_struct *napi, int budget)
 {
 	struct net_device *ndev = napi->dev;
 	struct fec_enet_private *fep = netdev_priv(ndev);
-	int pkts;
+	int done = 0;
 
-	pkts = fec_enet_rx(ndev, budget);
-
-	fec_enet_tx(ndev);
+	do {
+		done += fec_enet_rx(ndev, budget - done);
+		fec_enet_tx(ndev);
+	} while ((done < budget) && fec_enet_collect_events(fep));
 
-	if (pkts < budget) {
-		napi_complete_done(napi, pkts);
+	if (done < budget) {
+		napi_complete_done(napi, done);
 		writel(FEC_DEFAULT_IMASK, fep->hwp + FEC_IMASK);
 	}
-	return pkts;
+
+	return done;
 }
 
 /* ------------------------------------------------------------------------- */
-- 
2.17.1

