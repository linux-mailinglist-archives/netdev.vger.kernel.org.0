Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84D781540FB
	for <lists+netdev@lfdr.de>; Thu,  6 Feb 2020 10:15:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728288AbgBFJO6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Feb 2020 04:14:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:53916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726365AbgBFJO6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Feb 2020 04:14:58 -0500
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com [149.6.153.186])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD66120838;
        Thu,  6 Feb 2020 09:14:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580980497;
        bh=8r9PC89e7nm0OeIhqEAPgYEAC5NXOh15w8bZbVJPlQY=;
        h=From:To:Cc:Subject:Date:From;
        b=U2RmUFJZsji8k5gCPfwz7dl7d06xQpOIC5ake8j6f9QhG3LwUvt30XN/1ThoVR1y2
         vXW+1HLVMs2i3uYj2ArGSNRIAQLSkDKgV4mkx4aD/lumde32cooltfi5ADnnoHpA6W
         tTFK2ZO2MP3I0j3cWEogM+bG5VPnHTUHsNmcA9No=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net,
        ilias.apalodimas@linaro.org, brouer@redhat.com
Subject: [PATCH net] net: mvneta: move rx_dropped and rx_errors in per-cpu stats
Date:   Thu,  6 Feb 2020 10:14:39 +0100
Message-Id: <69df6b0f81a9078d240d2f94a97a77ca98876223.1580980267.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move rx_dropped and rx_errors counters in mvneta_pcpu_stats in order to
avoid possible races updating statistics

Fixes: 562e2f467e71 ("net: mvneta: Improve the buffer allocation method for SWBM")
Fixes: dc35a10f68d3 ("net: mvneta: bm: add support for hardware buffer management")
Fixes: c5aff18204da ("net: mvneta: driver for Marvell Armada 370/XP network unit")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/marvell/mvneta.c | 31 +++++++++++++++++++--------
 1 file changed, 22 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 037e054b01a2..98017e7d5dd0 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -401,6 +401,8 @@ struct mvneta_pcpu_stats {
 	struct	u64_stats_sync syncp;
 	u64	rx_packets;
 	u64	rx_bytes;
+	u64	rx_dropped;
+	u64	rx_errors;
 	u64	tx_packets;
 	u64	tx_bytes;
 };
@@ -738,6 +740,8 @@ mvneta_get_stats64(struct net_device *dev,
 		struct mvneta_pcpu_stats *cpu_stats;
 		u64 rx_packets;
 		u64 rx_bytes;
+		u64 rx_dropped;
+		u64 rx_errors;
 		u64 tx_packets;
 		u64 tx_bytes;
 
@@ -746,19 +750,20 @@ mvneta_get_stats64(struct net_device *dev,
 			start = u64_stats_fetch_begin_irq(&cpu_stats->syncp);
 			rx_packets = cpu_stats->rx_packets;
 			rx_bytes   = cpu_stats->rx_bytes;
+			rx_dropped = cpu_stats->rx_dropped;
+			rx_errors  = cpu_stats->rx_errors;
 			tx_packets = cpu_stats->tx_packets;
 			tx_bytes   = cpu_stats->tx_bytes;
 		} while (u64_stats_fetch_retry_irq(&cpu_stats->syncp, start));
 
 		stats->rx_packets += rx_packets;
 		stats->rx_bytes   += rx_bytes;
+		stats->rx_dropped += rx_dropped;
+		stats->rx_errors  += rx_errors;
 		stats->tx_packets += tx_packets;
 		stats->tx_bytes   += tx_bytes;
 	}
 
-	stats->rx_errors	= dev->stats.rx_errors;
-	stats->rx_dropped	= dev->stats.rx_dropped;
-
 	stats->tx_dropped	= dev->stats.tx_dropped;
 }
 
@@ -1736,8 +1741,14 @@ static u32 mvneta_txq_desc_csum(int l3_offs, int l3_proto,
 static void mvneta_rx_error(struct mvneta_port *pp,
 			    struct mvneta_rx_desc *rx_desc)
 {
+	struct mvneta_pcpu_stats *stats = this_cpu_ptr(pp->stats);
 	u32 status = rx_desc->status;
 
+	/* update per-cpu counter */
+	u64_stats_update_begin(&stats->syncp);
+	stats->rx_errors++;
+	u64_stats_update_end(&stats->syncp);
+
 	switch (status & MVNETA_RXD_ERR_CODE_MASK) {
 	case MVNETA_RXD_ERR_CRC:
 		netdev_err(pp->dev, "bad rx status %08x (crc error), size=%d\n",
@@ -2179,11 +2190,15 @@ mvneta_swbm_rx_frame(struct mvneta_port *pp,
 
 	rxq->skb = build_skb(xdp->data_hard_start, PAGE_SIZE);
 	if (unlikely(!rxq->skb)) {
-		netdev_err(dev,
-			   "Can't allocate skb on queue %d\n",
-			   rxq->id);
-		dev->stats.rx_dropped++;
+		struct mvneta_pcpu_stats *stats = this_cpu_ptr(pp->stats);
+
+		netdev_err(dev, "Can't allocate skb on queue %d\n", rxq->id);
 		rxq->skb_alloc_err++;
+
+		u64_stats_update_begin(&stats->syncp);
+		stats->rx_dropped++;
+		u64_stats_update_end(&stats->syncp);
+
 		return -ENOMEM;
 	}
 	page_pool_release_page(rxq->page_pool, page);
@@ -2270,7 +2285,6 @@ static int mvneta_rx_swbm(struct napi_struct *napi,
 			/* Check errors only for FIRST descriptor */
 			if (rx_status & MVNETA_RXD_ERR_SUMMARY) {
 				mvneta_rx_error(pp, rx_desc);
-				dev->stats.rx_errors++;
 				/* leave the descriptor untouched */
 				continue;
 			}
@@ -2372,7 +2386,6 @@ static int mvneta_rx_hwbm(struct napi_struct *napi,
 			mvneta_bm_pool_put_bp(pp->bm_priv, bm_pool,
 					      rx_desc->buf_phys_addr);
 err_drop_frame:
-			dev->stats.rx_errors++;
 			mvneta_rx_error(pp, rx_desc);
 			/* leave the descriptor untouched */
 			continue;
-- 
2.21.1

