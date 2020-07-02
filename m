Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E844212E4D
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 22:58:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726014AbgGBU6A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 16:58:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725937AbgGBU57 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 16:57:59 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F62CC08C5C1
        for <netdev@vger.kernel.org>; Thu,  2 Jul 2020 13:57:59 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id n23so34033592ljh.7
        for <netdev@vger.kernel.org>; Thu, 02 Jul 2020 13:57:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:organization;
        bh=Qk6tsTHFni9zhJbkbDJ3gamfz6kHeZ17Umf9MR5OAok=;
        b=x86yX1bZN+GQrfEvtssl26AsJoo3UoBamWZ5RBLoS5rHH67pY0673Ia/fdbI7UFB67
         ZhzQTiqk/UHZ7xGJqK3GEi9fq4AKczKjO2RMiG0T9o2jl3ridQzJOdTKzLURjXvJgMev
         1dKSlNuc86BnfC8OcBhqif0EvicVisS1FtGxoUW91X/mnJts3TR1T0mrSyfT3vsbvT0c
         xwNz3sFNrxUpj7PR2Tcum+WUGqradCb7ejMuuecqHuwK/JIpagcu5+0IOLkLXwaE88Rg
         q/APhNo7iGnq4z8qh+hoTPj7/cNMXCPNt/ktnJdRtyoFwsbmUq8KruO8M+MfjLzLQ9M5
         vShw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:organization;
        bh=Qk6tsTHFni9zhJbkbDJ3gamfz6kHeZ17Umf9MR5OAok=;
        b=sG5hZzCAcZaqWoGvirEmTtpdwvuOgP44YeWbrhmooSh/clLYsc87GYkvFGkJEhygz2
         fSpa/QCcGY/N4LAFimBNVzgG1T+2F2TmU9dnktzYtdH0cVao9nug7yMHk+Dwt5fd3eHr
         ei0kKzj9uBHgynGtXGaeBVVSbpNIkSUWeZIsFU4L4pXt+M3N3QkRwJtgx6eOExKdVfoA
         oxH0DnRWob7OuaWq6CWEE7k6Dl03Mz73T8c9aYbeI+1XjrzruoA6RyPM39dFWvFuU5E6
         rLuzNE7bFMi9/4IByQsgmoF4ijIsHi7dMDRnnjFjeo3eJ3jCwmtUolxBH/rRCyLWyG3k
         ghHg==
X-Gm-Message-State: AOAM5312kneNdaihgWkZGpbViCcMN5xBcssz8cRiwA7EJxNE5RsOCK0D
        i+jA6c0Y74BPSAN52DtpvH5rF/+pdh8=
X-Google-Smtp-Source: ABdhPJww6+YICAvUnvFlRqN0Xq6N21YzRV6qpVvkfhEtANyJKWUqv4AHGIuqeKwr++5j7e4liGwrBg==
X-Received: by 2002:a2e:b0e9:: with SMTP id h9mr6525183ljl.3.1593723477476;
        Thu, 02 Jul 2020 13:57:57 -0700 (PDT)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id 11sm3344802ljw.69.2020.07.02.13.57.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jul 2020 13:57:56 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, fugang.duan@nxp.com
Subject: [PATCH v2 net] net: ethernet: fec: prevent tx starvation under high rx load
Date:   Thu,  2 Jul 2020 22:57:37 +0200
Message-Id: <20200702205737.8283-1-tobias@waldekranz.com>
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
index 2d0d313ee7c5..84589d464850 100644
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
+	for (i = fep->num_rx_queues - 1; i >= 0; i--)
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

