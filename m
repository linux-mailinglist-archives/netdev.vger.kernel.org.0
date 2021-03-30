Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9903534F1D9
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 21:53:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233310AbhC3Two (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 15:52:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233285AbhC3Twa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 15:52:30 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B281DC061574
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 12:52:30 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id t18so8307241pjs.3
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 12:52:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=igb8AFJOz2HY+uDgvmiXGk65QJUZspiuoDl3hWYoChk=;
        b=LM4Hq/lhNsc7MSnviK1MpvEvEaq7pufgwVUvk6zqy+YYnmFsmuwViBajON2FzFF0pB
         PMjZuYSXLDVuKJ1UyNsb3t/uUbppg4pDEHMvVX6dkOhVYE3tXFZDNv9LsOGWp/1+4EAk
         x+LPnSzVKApFCB+14j9Ydq8WYwhc8lhBeT6WB83YzawzyarAK55L6nZo2qmmoiYvBTsV
         cyRvWRzKxipAX+L+e6ybd0muy3nG9bzkELZ7C3w2I+mFXVfIYLN/ujf5cvaVExZSfeck
         sjS5aHr0eyCzJAfF8sWB7Q6TEGjZs2GRaD8Iv9KnATP+7jMgRkfeUx37CeSc7zzMQySq
         XgFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=igb8AFJOz2HY+uDgvmiXGk65QJUZspiuoDl3hWYoChk=;
        b=jXRMy5MxykhStqnE9VtoDcl/N8VBGVXw69jJl2/GdihlOCws4PFL+bLgNcuq7Z6+AC
         b+TfWeoE8YTMnOIbO+QVtK1RyurQncLPZJZQ4wPHqZEto/iyHWZU7T/3UyiQl4qWgCKK
         FrbaF3RTMIKhCE3zuTlp1zVIJcQ7cZr/Q0HhY/HP/AjARofAFGZeuQPChyCMmar6Y8CN
         jClJGqQP+OG55GgzrM+dtNAMece2haAslJgveeCexpsn0KKrgPNcrgTNN8hZDJ44ve/a
         X3HAfoXWbK6Bf1xJzKNPjb1L0wkrG+gxoLfH2931L3Mt1gnnIE7E/rz8Bl4vekJQPQYM
         oRZw==
X-Gm-Message-State: AOAM533gYUEm2diGctwf3ov7sBYT9bt1jqVXI2kCh9wsOXBtAhHRFxbF
        jXW9N4QAsJVFdhmrA3GFLbj3FxIBM66VEA==
X-Google-Smtp-Source: ABdhPJyPVMVVFRzu7d/uPJu35xQKfsjkY5rc2JnfoOd/3P1YHGULXZKPh4r0DAOJfe5eSbUGZm2cKA==
X-Received: by 2002:a17:90a:bb95:: with SMTP id v21mr6472pjr.30.1617133949890;
        Tue, 30 Mar 2021 12:52:29 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id y8sm20433pge.56.2021.03.30.12.52.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Mar 2021 12:52:29 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     drivers@pensando.io, Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 4/4] ionic: pull per-q stats work out of queue loops
Date:   Tue, 30 Mar 2021 12:52:10 -0700
Message-Id: <20210330195210.49069-5-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210330195210.49069-1-snelson@pensando.io>
References: <20210330195210.49069-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Abstract out the per-queue data collection work into separate
functions from the per-queue loops in the stats reporting,
similar to what Alex did for the data label strings in
commit acebe5b6107c ("ionic: Update driver to use ethtool_sprintf")

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../net/ethernet/pensando/ionic/ionic_stats.c | 219 ++++++++++--------
 1 file changed, 125 insertions(+), 94 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_stats.c b/drivers/net/ethernet/pensando/ionic/ionic_stats.c
index 308b4ac6c57b..ed9cf93d9acd 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_stats.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_stats.c
@@ -177,31 +177,42 @@ static const struct ionic_stat_desc ionic_dbg_napi_stats_desc[] = {
 
 #define MAX_Q(lif)   ((lif)->netdev->real_num_tx_queues)
 
+static void ionic_add_lif_txq_stats(struct ionic_lif *lif, int q_num,
+				    struct ionic_lif_sw_stats *stats)
+{
+	struct ionic_tx_stats *txstats = &lif->txqstats[q_num];
+
+	stats->tx_packets += txstats->pkts;
+	stats->tx_bytes += txstats->bytes;
+	stats->tx_tso += txstats->tso;
+	stats->tx_tso_bytes += txstats->tso_bytes;
+	stats->tx_csum_none += txstats->csum_none;
+	stats->tx_csum += txstats->csum;
+}
+
+static void ionic_add_lif_rxq_stats(struct ionic_lif *lif, int q_num,
+				    struct ionic_lif_sw_stats *stats)
+{
+	struct ionic_rx_stats *rxstats = &lif->rxqstats[q_num];
+
+	stats->rx_packets += rxstats->pkts;
+	stats->rx_bytes += rxstats->bytes;
+	stats->rx_csum_none += rxstats->csum_none;
+	stats->rx_csum_complete += rxstats->csum_complete;
+	stats->rx_csum_error += rxstats->csum_error;
+}
+
 static void ionic_get_lif_stats(struct ionic_lif *lif,
 				struct ionic_lif_sw_stats *stats)
 {
-	struct ionic_tx_stats *txstats;
-	struct ionic_rx_stats *rxstats;
 	struct rtnl_link_stats64 ns;
 	int q_num;
 
 	memset(stats, 0, sizeof(*stats));
 
 	for (q_num = 0; q_num < MAX_Q(lif); q_num++) {
-		txstats = &lif->txqstats[q_num];
-		stats->tx_packets += txstats->pkts;
-		stats->tx_bytes += txstats->bytes;
-		stats->tx_tso += txstats->tso;
-		stats->tx_tso_bytes += txstats->tso_bytes;
-		stats->tx_csum_none += txstats->csum_none;
-		stats->tx_csum += txstats->csum;
-
-		rxstats = &lif->rxqstats[q_num];
-		stats->rx_packets += rxstats->pkts;
-		stats->rx_bytes += rxstats->bytes;
-		stats->rx_csum_none += rxstats->csum_none;
-		stats->rx_csum_complete += rxstats->csum_complete;
-		stats->rx_csum_error += rxstats->csum_error;
+		ionic_add_lif_txq_stats(lif, q_num, stats);
+		ionic_add_lif_rxq_stats(lif, q_num, stats);
 	}
 
 	ionic_get_stats64(lif->netdev, &ns);
@@ -214,16 +225,12 @@ static void ionic_get_lif_stats(struct ionic_lif *lif,
 
 static u64 ionic_sw_stats_get_count(struct ionic_lif *lif)
 {
-	u64 total = 0;
+	u64 total = 0, tx_queues = MAX_Q(lif), rx_queues = MAX_Q(lif);
 
 	/* lif stats */
 	total += IONIC_NUM_LIF_STATS;
-
-	/* tx stats */
-	total += MAX_Q(lif) * IONIC_NUM_TX_STATS;
-
-	/* rx stats */
-	total += MAX_Q(lif) * IONIC_NUM_RX_STATS;
+	total += tx_queues * IONIC_NUM_TX_STATS;
+	total += rx_queues * IONIC_NUM_RX_STATS;
 
 	/* port stats */
 	total += IONIC_NUM_PORT_STATS;
@@ -231,13 +238,13 @@ static u64 ionic_sw_stats_get_count(struct ionic_lif *lif)
 	if (test_bit(IONIC_LIF_F_UP, lif->state) &&
 	    test_bit(IONIC_LIF_F_SW_DEBUG_STATS, lif->state)) {
 		/* tx debug stats */
-		total += MAX_Q(lif) * (IONIC_NUM_DBG_CQ_STATS +
+		total += tx_queues * (IONIC_NUM_DBG_CQ_STATS +
 				      IONIC_NUM_TX_Q_STATS +
 				      IONIC_NUM_DBG_INTR_STATS +
 				      IONIC_MAX_NUM_SG_CNTR);
 
 		/* rx debug stats */
-		total += MAX_Q(lif) * (IONIC_NUM_DBG_CQ_STATS +
+		total += rx_queues * (IONIC_NUM_DBG_CQ_STATS +
 				      IONIC_NUM_DBG_INTR_STATS +
 				      IONIC_NUM_DBG_NAPI_STATS +
 				      IONIC_MAX_NUM_NAPI_CNTR);
@@ -315,13 +322,99 @@ static void ionic_sw_stats_get_strings(struct ionic_lif *lif, u8 **buf)
 		ionic_sw_stats_get_rx_strings(lif, buf, q_num);
 }
 
+static void ionic_sw_stats_get_txq_values(struct ionic_lif *lif, u64 **buf,
+					  int q_num)
+{
+	struct ionic_tx_stats *txstats;
+	struct ionic_qcq *txqcq;
+	int i;
+
+	txstats = &lif->txqstats[q_num];
+
+	for (i = 0; i < IONIC_NUM_TX_STATS; i++) {
+		**buf = IONIC_READ_STAT64(txstats, &ionic_tx_stats_desc[i]);
+		(*buf)++;
+	}
+
+	if (!test_bit(IONIC_LIF_F_UP, lif->state) ||
+	    !test_bit(IONIC_LIF_F_SW_DEBUG_STATS, lif->state))
+		return;
+
+	txqcq = lif->txqcqs[q_num];
+	for (i = 0; i < IONIC_NUM_TX_Q_STATS; i++) {
+		**buf = IONIC_READ_STAT64(&txqcq->q,
+					  &ionic_txq_stats_desc[i]);
+		(*buf)++;
+	}
+	for (i = 0; i < IONIC_NUM_DBG_CQ_STATS; i++) {
+		**buf = IONIC_READ_STAT64(&txqcq->cq,
+					  &ionic_dbg_cq_stats_desc[i]);
+		(*buf)++;
+	}
+	for (i = 0; i < IONIC_NUM_DBG_INTR_STATS; i++) {
+		**buf = IONIC_READ_STAT64(&txqcq->intr,
+					  &ionic_dbg_intr_stats_desc[i]);
+		(*buf)++;
+	}
+	for (i = 0; i < IONIC_NUM_DBG_NAPI_STATS; i++) {
+		**buf = IONIC_READ_STAT64(&txqcq->napi_stats,
+					  &ionic_dbg_napi_stats_desc[i]);
+		(*buf)++;
+	}
+	for (i = 0; i < IONIC_MAX_NUM_NAPI_CNTR; i++) {
+		**buf = txqcq->napi_stats.work_done_cntr[i];
+		(*buf)++;
+	}
+	for (i = 0; i < IONIC_MAX_NUM_SG_CNTR; i++) {
+		**buf = txstats->sg_cntr[i];
+		(*buf)++;
+	}
+}
+
+static void ionic_sw_stats_get_rxq_values(struct ionic_lif *lif, u64 **buf,
+					  int q_num)
+{
+	struct ionic_rx_stats *rxstats;
+	struct ionic_qcq *rxqcq;
+	int i;
+
+	rxstats = &lif->rxqstats[q_num];
+
+	for (i = 0; i < IONIC_NUM_RX_STATS; i++) {
+		**buf = IONIC_READ_STAT64(rxstats, &ionic_rx_stats_desc[i]);
+		(*buf)++;
+	}
+
+	if (!test_bit(IONIC_LIF_F_UP, lif->state) ||
+	    !test_bit(IONIC_LIF_F_SW_DEBUG_STATS, lif->state))
+		return;
+
+	rxqcq = lif->rxqcqs[q_num];
+	for (i = 0; i < IONIC_NUM_DBG_CQ_STATS; i++) {
+		**buf = IONIC_READ_STAT64(&rxqcq->cq,
+					  &ionic_dbg_cq_stats_desc[i]);
+		(*buf)++;
+	}
+	for (i = 0; i < IONIC_NUM_DBG_INTR_STATS; i++) {
+		**buf = IONIC_READ_STAT64(&rxqcq->intr,
+					  &ionic_dbg_intr_stats_desc[i]);
+		(*buf)++;
+	}
+	for (i = 0; i < IONIC_NUM_DBG_NAPI_STATS; i++) {
+		**buf = IONIC_READ_STAT64(&rxqcq->napi_stats,
+					  &ionic_dbg_napi_stats_desc[i]);
+		(*buf)++;
+	}
+	for (i = 0; i < IONIC_MAX_NUM_NAPI_CNTR; i++) {
+		**buf = rxqcq->napi_stats.work_done_cntr[i];
+		(*buf)++;
+	}
+}
+
 static void ionic_sw_stats_get_values(struct ionic_lif *lif, u64 **buf)
 {
 	struct ionic_port_stats *port_stats;
 	struct ionic_lif_sw_stats lif_stats;
-	struct ionic_qcq *txqcq, *rxqcq;
-	struct ionic_tx_stats *txstats;
-	struct ionic_rx_stats *rxstats;
 	int i, q_num;
 
 	ionic_get_lif_stats(lif, &lif_stats);
@@ -338,73 +431,11 @@ static void ionic_sw_stats_get_values(struct ionic_lif *lif, u64 **buf)
 		(*buf)++;
 	}
 
-	for (q_num = 0; q_num < MAX_Q(lif); q_num++) {
-		txstats = &lif->txqstats[q_num];
-
-		for (i = 0; i < IONIC_NUM_TX_STATS; i++) {
-			**buf = IONIC_READ_STAT64(txstats,
-						  &ionic_tx_stats_desc[i]);
-			(*buf)++;
-		}
-
-		if (test_bit(IONIC_LIF_F_UP, lif->state) &&
-		    test_bit(IONIC_LIF_F_SW_DEBUG_STATS, lif->state)) {
-			txqcq = lif->txqcqs[q_num];
-			for (i = 0; i < IONIC_NUM_TX_Q_STATS; i++) {
-				**buf = IONIC_READ_STAT64(&txqcq->q,
-						      &ionic_txq_stats_desc[i]);
-				(*buf)++;
-			}
-			for (i = 0; i < IONIC_NUM_DBG_CQ_STATS; i++) {
-				**buf = IONIC_READ_STAT64(&txqcq->cq,
-						   &ionic_dbg_cq_stats_desc[i]);
-				(*buf)++;
-			}
-			for (i = 0; i < IONIC_NUM_DBG_INTR_STATS; i++) {
-				**buf = IONIC_READ_STAT64(&txqcq->intr,
-						 &ionic_dbg_intr_stats_desc[i]);
-				(*buf)++;
-			}
-			for (i = 0; i < IONIC_MAX_NUM_SG_CNTR; i++) {
-				**buf = txstats->sg_cntr[i];
-				(*buf)++;
-			}
-		}
-	}
+	for (q_num = 0; q_num < MAX_Q(lif); q_num++)
+		ionic_sw_stats_get_txq_values(lif, buf, q_num);
 
-	for (q_num = 0; q_num < MAX_Q(lif); q_num++) {
-		rxstats = &lif->rxqstats[q_num];
-
-		for (i = 0; i < IONIC_NUM_RX_STATS; i++) {
-			**buf = IONIC_READ_STAT64(rxstats,
-						  &ionic_rx_stats_desc[i]);
-			(*buf)++;
-		}
-
-		if (test_bit(IONIC_LIF_F_UP, lif->state) &&
-		    test_bit(IONIC_LIF_F_SW_DEBUG_STATS, lif->state)) {
-			rxqcq = lif->rxqcqs[q_num];
-			for (i = 0; i < IONIC_NUM_DBG_CQ_STATS; i++) {
-				**buf = IONIC_READ_STAT64(&rxqcq->cq,
-						   &ionic_dbg_cq_stats_desc[i]);
-				(*buf)++;
-			}
-			for (i = 0; i < IONIC_NUM_DBG_INTR_STATS; i++) {
-				**buf = IONIC_READ_STAT64(&rxqcq->intr,
-						 &ionic_dbg_intr_stats_desc[i]);
-				(*buf)++;
-			}
-			for (i = 0; i < IONIC_NUM_DBG_NAPI_STATS; i++) {
-				**buf = IONIC_READ_STAT64(&rxqcq->napi_stats,
-						 &ionic_dbg_napi_stats_desc[i]);
-				(*buf)++;
-			}
-			for (i = 0; i < IONIC_MAX_NUM_NAPI_CNTR; i++) {
-				**buf = rxqcq->napi_stats.work_done_cntr[i];
-				(*buf)++;
-			}
-		}
-	}
+	for (q_num = 0; q_num < MAX_Q(lif); q_num++)
+		ionic_sw_stats_get_rxq_values(lif, buf, q_num);
 }
 
 const struct ionic_stats_group_intf ionic_stats_groups[] = {
-- 
2.17.1

