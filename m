Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C40F6CCCB9
	for <lists+netdev@lfdr.de>; Sat,  5 Oct 2019 22:45:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725853AbfJEUp2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Oct 2019 16:45:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:34078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725789AbfJEUp1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Oct 2019 16:45:27 -0400
Received: from lore-desk.lan (unknown [151.66.37.67])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7D26F222C5;
        Sat,  5 Oct 2019 20:45:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570308327;
        bh=5t5NbLHYbgt7ocud47HlHf34FyBScgxcF8+l5cpMctk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IDT2+j8r8w4O8nDams1BI7Bw35HCOkiX7XazP92PoGswioLB5ygYDzpbN+Nz9ASIu
         uwWh9AIMLRHbt3btNNgiA3iL+rMhGFUzZyj01VRW2PP/rNdXI2f3szzCMLRwED5jM8
         pLgy0s6NofHu1BT9VaKZ5zM+I4QdGHWGV0vrQugw=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, thomas.petazzoni@bootlin.com,
        ilias.apalodimas@linaro.org, brouer@redhat.com,
        lorenzo.bianconi@redhat.com, matteo.croce@redhat.com
Subject: [PATCH 1/7] net: mvneta: introduce mvneta_update_stats routine
Date:   Sat,  5 Oct 2019 22:44:34 +0200
Message-Id: <b04f301d715c4ae9a883deaa1fcc2a58d85c0fee.1570307172.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1570307172.git.lorenzo@kernel.org>
References: <cover.1570307172.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce mvneta_update_stats routine to collect {rx/tx} statistics
(packets and bytes). This is a preliminary patch to add XDP support to
mvneta driver

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/marvell/mvneta.c | 41 +++++++++++++--------------
 1 file changed, 20 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index e49820675c8c..128b9fded959 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -1900,6 +1900,23 @@ static void mvneta_rxq_drop_pkts(struct mvneta_port *pp,
 	}
 }
 
+static void
+mvneta_update_stats(struct mvneta_port *pp, u32 pkts,
+		    u32 len, bool tx)
+{
+	struct mvneta_pcpu_stats *stats = this_cpu_ptr(pp->stats);
+
+	u64_stats_update_begin(&stats->syncp);
+	if (tx) {
+		stats->tx_packets += pkts;
+		stats->tx_bytes += len;
+	} else {
+		stats->rx_packets += pkts;
+		stats->rx_bytes += len;
+	}
+	u64_stats_update_end(&stats->syncp);
+}
+
 static inline
 int mvneta_rx_refill_queue(struct mvneta_port *pp, struct mvneta_rx_queue *rxq)
 {
@@ -2075,14 +2092,7 @@ static int mvneta_rx_swbm(struct napi_struct *napi,
 		rxq->left_size = 0;
 	}
 
-	if (rcvd_pkts) {
-		struct mvneta_pcpu_stats *stats = this_cpu_ptr(pp->stats);
-
-		u64_stats_update_begin(&stats->syncp);
-		stats->rx_packets += rcvd_pkts;
-		stats->rx_bytes   += rcvd_bytes;
-		u64_stats_update_end(&stats->syncp);
-	}
+	mvneta_update_stats(pp, rcvd_pkts, rcvd_bytes, false);
 
 	/* return some buffers to hardware queue, one at a time is too slow */
 	refill = mvneta_rx_refill_queue(pp, rxq);
@@ -2206,14 +2216,7 @@ static int mvneta_rx_hwbm(struct napi_struct *napi,
 		napi_gro_receive(napi, skb);
 	}
 
-	if (rcvd_pkts) {
-		struct mvneta_pcpu_stats *stats = this_cpu_ptr(pp->stats);
-
-		u64_stats_update_begin(&stats->syncp);
-		stats->rx_packets += rcvd_pkts;
-		stats->rx_bytes   += rcvd_bytes;
-		u64_stats_update_end(&stats->syncp);
-	}
+	mvneta_update_stats(pp, rcvd_pkts, rcvd_bytes, false);
 
 	/* Update rxq management counters */
 	mvneta_rxq_desc_num_update(pp, rxq, rx_done, rx_done);
@@ -2459,7 +2462,6 @@ static netdev_tx_t mvneta_tx(struct sk_buff *skb, struct net_device *dev)
 
 out:
 	if (frags > 0) {
-		struct mvneta_pcpu_stats *stats = this_cpu_ptr(pp->stats);
 		struct netdev_queue *nq = netdev_get_tx_queue(dev, txq_id);
 
 		netdev_tx_sent_queue(nq, len);
@@ -2474,10 +2476,7 @@ static netdev_tx_t mvneta_tx(struct sk_buff *skb, struct net_device *dev)
 		else
 			txq->pending += frags;
 
-		u64_stats_update_begin(&stats->syncp);
-		stats->tx_packets++;
-		stats->tx_bytes  += len;
-		u64_stats_update_end(&stats->syncp);
+		mvneta_update_stats(pp, 1, len, true);
 	} else {
 		dev->stats.tx_dropped++;
 		dev_kfree_skb_any(skb);
-- 
2.21.0

