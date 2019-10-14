Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C9FED608E
	for <lists+netdev@lfdr.de>; Mon, 14 Oct 2019 12:50:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731645AbfJNKuc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 06:50:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:58062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731305AbfJNKuc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Oct 2019 06:50:32 -0400
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com [149.6.153.186])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4A3BC20854;
        Mon, 14 Oct 2019 10:50:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571050232;
        bh=5t5NbLHYbgt7ocud47HlHf34FyBScgxcF8+l5cpMctk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WboVxizx4Ne07WWh091JDkJvZnBTJ1sXb29HIIY5w2WRytbaJ5rFqR+7yYYJWxCY3
         taIIZAOqo/mcaI7Ha+54JYq5SIuYx2gXIMDMl7V/DNiozpjBMaNTpIWrFg5tNUdQ9l
         18MI1WVa4HZY7oLXq6sG0uvizXOuAjakTP2CbcPs=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net,
        thomas.petazzoni@bootlin.com, brouer@redhat.com,
        ilias.apalodimas@linaro.org, matteo.croce@redhat.com,
        mw@semihalf.com
Subject: [PATCH v3 net-next 1/8] net: mvneta: introduce mvneta_update_stats routine
Date:   Mon, 14 Oct 2019 12:49:48 +0200
Message-Id: <59c7c29df4dcb6df74ad3147b9651a397eacfbe7.1571049326.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1571049326.git.lorenzo@kernel.org>
References: <cover.1571049326.git.lorenzo@kernel.org>
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

