Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7203E221196
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 17:50:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727831AbgGOPtK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 11:49:10 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:45508 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726929AbgGOPtI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 11:49:08 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06FFf2DR032718;
        Wed, 15 Jul 2020 08:49:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=3hJp31Ls7U691tWmm9UMuHh0W+Hpjs8C4PDlLlj4p+M=;
 b=rVhz2T6/XlWspPl7VlBCQOXAJYpjtmaYNEMlOCPvwxwPUOlwNPzE8Tu8cQBP37oJ37Sr
 zASYWlYWPJrHw0TxxWJFF68aeu324ZAa7bkaJ0r0P1okeT/AkH8Fy36ODqDLGV0Rl3RG
 k+RXLX/AOWydEfIKYj3xEMeT5KLjpDSh049ORBSIpISP/JR9f6m8eFld3bDPdqxbqmYU
 oV89VNW6v4+kGTfVUAQXxFXmsOb7KXyh6RqSvsaHlCOHGLsIM5uWUy2H0JZl57E5HsUu
 ViFD/1wAfbqeRlKv6aAng6m/lsXFAfLvCN12sHZOXu3l37taraC+ultHd6PaYOZZsYI5 Yg== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0a-0016f401.pphosted.com with ESMTP id 327asnja5r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 15 Jul 2020 08:49:06 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 15 Jul
 2020 08:49:05 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 15 Jul
 2020 08:49:04 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 15 Jul 2020 08:49:04 -0700
Received: from NN-LT0019.marvell.com (NN-LT0019.marvell.com [10.193.54.28])
        by maili.marvell.com (Postfix) with ESMTP id 0A36A3F703F;
        Wed, 15 Jul 2020 08:49:02 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: [PATCH v2 net-next 03/10] net: atlantic: use u64_stats_update_* to protect access to 64-bit stats
Date:   Wed, 15 Jul 2020 18:48:35 +0300
Message-ID: <20200715154842.305-4-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200715154842.305-1-irusskikh@marvell.com>
References: <20200715154842.305-1-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-15_12:2020-07-15,2020-07-15 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Starovoytov <mstarovoitov@marvell.com>

This patch adds u64_stats_update_* usage to protect access to 64-bit stats.

Signed-off-by: Mark Starovoytov <mstarovoitov@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 .../net/ethernet/aquantia/atlantic/aq_ring.c  | 28 +++++++-
 .../net/ethernet/aquantia/atlantic/aq_ring.h  |  1 +
 .../net/ethernet/aquantia/atlantic/aq_vec.c   | 68 +++++++++++++------
 3 files changed, 77 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ring.c b/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
index 20b606aa7974..b073c340c005 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
@@ -70,26 +70,35 @@ static int aq_get_rxpages(struct aq_ring_s *self, struct aq_ring_buff_s *rxbuf,
 			rxbuf->rxdata.pg_off += AQ_CFG_RX_FRAME_MAX;
 			if (rxbuf->rxdata.pg_off + AQ_CFG_RX_FRAME_MAX <=
 				(PAGE_SIZE << order)) {
+				u64_stats_update_begin(&self->stats.syncp);
 				self->stats.rx.pg_flips++;
+				u64_stats_update_end(&self->stats.syncp);
 			} else {
 				/* Buffer exhausted. We have other users and
 				 * should release this page and realloc
 				 */
 				aq_free_rxpage(&rxbuf->rxdata,
 					       aq_nic_get_dev(self->aq_nic));
+				u64_stats_update_begin(&self->stats.syncp);
 				self->stats.rx.pg_losts++;
+				u64_stats_update_end(&self->stats.syncp);
 			}
 		} else {
 			rxbuf->rxdata.pg_off = 0;
+			u64_stats_update_begin(&self->stats.syncp);
 			self->stats.rx.pg_reuses++;
+			u64_stats_update_end(&self->stats.syncp);
 		}
 	}
 
 	if (!rxbuf->rxdata.page) {
 		ret = aq_get_rxpage(&rxbuf->rxdata, order,
 				    aq_nic_get_dev(self->aq_nic));
-		if (ret)
+		if (ret) {
+			u64_stats_update_begin(&self->stats.syncp);
 			self->stats.rx.alloc_fails++;
+			u64_stats_update_end(&self->stats.syncp);
+		}
 		return ret;
 	}
 
@@ -213,6 +222,7 @@ int aq_ring_init(struct aq_ring_s *self)
 	self->hw_head = 0;
 	self->sw_head = 0;
 	self->sw_tail = 0;
+	u64_stats_init(&self->stats.syncp);
 
 	return 0;
 }
@@ -240,7 +250,9 @@ void aq_ring_queue_wake(struct aq_ring_s *ring)
 						      ring->idx))) {
 		netif_wake_subqueue(ndev,
 				    AQ_NIC_RING2QMAP(ring->aq_nic, ring->idx));
+		u64_stats_update_begin(&ring->stats.syncp);
 		ring->stats.tx.queue_restarts++;
+		u64_stats_update_end(&ring->stats.syncp);
 	}
 }
 
@@ -282,8 +294,10 @@ bool aq_ring_tx_clean(struct aq_ring_s *self)
 		}
 
 		if (unlikely(buff->is_eop)) {
+			u64_stats_update_begin(&self->stats.syncp);
 			++self->stats.tx.packets;
 			self->stats.tx.bytes += buff->skb->len;
+			u64_stats_update_end(&self->stats.syncp);
 
 			dev_kfree_skb_any(buff->skb);
 		}
@@ -303,7 +317,9 @@ static void aq_rx_checksum(struct aq_ring_s *self,
 		return;
 
 	if (unlikely(buff->is_cso_err)) {
+		u64_stats_update_begin(&self->stats.syncp);
 		++self->stats.rx.errors;
+		u64_stats_update_end(&self->stats.syncp);
 		skb->ip_summed = CHECKSUM_NONE;
 		return;
 	}
@@ -373,13 +389,17 @@ int aq_ring_rx_clean(struct aq_ring_s *self,
 					buff_->is_cleaned = true;
 				} while (!buff_->is_eop);
 
+				u64_stats_update_begin(&self->stats.syncp);
 				++self->stats.rx.errors;
+				u64_stats_update_end(&self->stats.syncp);
 				continue;
 			}
 		}
 
 		if (buff->is_error) {
+			u64_stats_update_begin(&self->stats.syncp);
 			++self->stats.rx.errors;
+			u64_stats_update_end(&self->stats.syncp);
 			continue;
 		}
 
@@ -394,7 +414,9 @@ int aq_ring_rx_clean(struct aq_ring_s *self,
 			skb = build_skb(aq_buf_vaddr(&buff->rxdata),
 					AQ_CFG_RX_FRAME_MAX);
 			if (unlikely(!skb)) {
+				u64_stats_update_begin(&self->stats.syncp);
 				self->stats.rx.skb_alloc_fails++;
+				u64_stats_update_end(&self->stats.syncp);
 				err = -ENOMEM;
 				goto err_exit;
 			}
@@ -408,7 +430,9 @@ int aq_ring_rx_clean(struct aq_ring_s *self,
 		} else {
 			skb = napi_alloc_skb(napi, AQ_CFG_RX_HDR_SIZE);
 			if (unlikely(!skb)) {
+				u64_stats_update_begin(&self->stats.syncp);
 				self->stats.rx.skb_alloc_fails++;
+				u64_stats_update_end(&self->stats.syncp);
 				err = -ENOMEM;
 				goto err_exit;
 			}
@@ -482,8 +506,10 @@ int aq_ring_rx_clean(struct aq_ring_s *self,
 						: AQ_NIC_RING2QMAP(self->aq_nic,
 								   self->idx));
 
+		u64_stats_update_begin(&self->stats.syncp);
 		++self->stats.rx.packets;
 		self->stats.rx.bytes += skb->len;
+		u64_stats_update_end(&self->stats.syncp);
 
 		napi_gro_receive(napi, skb);
 	}
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ring.h b/drivers/net/ethernet/aquantia/atlantic/aq_ring.h
index 0e40ccbaf19a..7ccdaeb957f7 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ring.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ring.h
@@ -110,6 +110,7 @@ struct aq_ring_stats_tx_s {
 };
 
 union aq_ring_stats_s {
+	struct u64_stats_sync syncp;
 	struct aq_ring_stats_rx_s rx;
 	struct aq_ring_stats_tx_s tx;
 };
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_vec.c b/drivers/net/ethernet/aquantia/atlantic/aq_vec.c
index eafcb98c274f..6539d2cc5459 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_vec.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_vec.c
@@ -45,7 +45,9 @@ static int aq_vec_poll(struct napi_struct *napi, int budget)
 	} else {
 		for (i = 0U, ring = self->ring[0];
 			self->tx_rings > i; ++i, ring = self->ring[i]) {
+			u64_stats_update_begin(&ring[AQ_VEC_RX_ID].stats.syncp);
 			ring[AQ_VEC_RX_ID].stats.rx.polls++;
+			u64_stats_update_end(&ring[AQ_VEC_RX_ID].stats.syncp);
 			if (self->aq_hw_ops->hw_ring_tx_head_update) {
 				err = self->aq_hw_ops->hw_ring_tx_head_update(
 							self->aq_hw,
@@ -357,29 +359,57 @@ void aq_vec_add_stats(struct aq_vec_s *self,
 		      struct aq_ring_stats_tx_s *stats_tx)
 {
 	struct aq_ring_s *ring = self->ring[tc];
+	u64 packets, bytes, errors;
+	unsigned int start;
 
 	if (tc < self->rx_rings) {
-		struct aq_ring_stats_rx_s *rx = &ring[AQ_VEC_RX_ID].stats.rx;
-
-		stats_rx->packets += rx->packets;
-		stats_rx->bytes += rx->bytes;
-		stats_rx->errors += rx->errors;
-		stats_rx->jumbo_packets += rx->jumbo_packets;
-		stats_rx->lro_packets += rx->lro_packets;
-		stats_rx->alloc_fails += rx->alloc_fails;
-		stats_rx->skb_alloc_fails += rx->skb_alloc_fails;
-		stats_rx->polls += rx->polls;
-		stats_rx->pg_losts += rx->pg_losts;
-		stats_rx->pg_flips += rx->pg_flips;
-		stats_rx->pg_reuses += rx->pg_reuses;
+		u64 jumbo_packets, lro_packets, alloc_fails, skb_alloc_fails;
+		union aq_ring_stats_s *stats = &ring[AQ_VEC_RX_ID].stats;
+		u64 polls, pg_losts, pg_flips, pg_reuses;
+
+		do {
+			start = u64_stats_fetch_begin_irq(&stats->syncp);
+			packets = stats->rx.packets;
+			bytes = stats->rx.bytes;
+			errors = stats->rx.errors;
+			jumbo_packets = stats->rx.jumbo_packets;
+			lro_packets = stats->rx.lro_packets;
+			alloc_fails = stats->rx.alloc_fails;
+			skb_alloc_fails = stats->rx.skb_alloc_fails;
+			polls = stats->rx.polls;
+			pg_losts = stats->rx.pg_losts;
+			pg_flips = stats->rx.pg_flips;
+			pg_reuses = stats->rx.pg_reuses;
+		} while (u64_stats_fetch_retry_irq(&stats->syncp, start));
+
+		stats_rx->packets += packets;
+		stats_rx->bytes += bytes;
+		stats_rx->errors += errors;
+		stats_rx->jumbo_packets += jumbo_packets;
+		stats_rx->lro_packets += lro_packets;
+		stats_rx->alloc_fails += alloc_fails;
+		stats_rx->skb_alloc_fails += skb_alloc_fails;
+		stats_rx->polls += polls;
+		stats_rx->pg_losts += pg_losts;
+		stats_rx->pg_flips += pg_flips;
+		stats_rx->pg_reuses += pg_reuses;
 	}
 
 	if (tc < self->tx_rings) {
-		struct aq_ring_stats_tx_s *tx = &ring[AQ_VEC_TX_ID].stats.tx;
-
-		stats_tx->packets += tx->packets;
-		stats_tx->bytes += tx->bytes;
-		stats_tx->errors += tx->errors;
-		stats_tx->queue_restarts += tx->queue_restarts;
+		union aq_ring_stats_s *stats = &ring[AQ_VEC_TX_ID].stats;
+		u64 queue_restarts;
+
+		do {
+			start = u64_stats_fetch_begin_irq(&stats->syncp);
+			packets = stats->tx.packets;
+			bytes = stats->tx.bytes;
+			errors = stats->tx.errors;
+			queue_restarts = stats->tx.queue_restarts;
+		} while (u64_stats_fetch_retry_irq(&stats->syncp, start));
+
+		stats_tx->packets += packets;
+		stats_tx->bytes += bytes;
+		stats_tx->errors += errors;
+		stats_tx->queue_restarts += queue_restarts;
 	}
 }
-- 
2.25.1

