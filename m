Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D50D1226E53
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 20:33:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730609AbgGTSdI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 14:33:08 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:34550 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730534AbgGTSdF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 14:33:05 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06KIGEX8021988;
        Mon, 20 Jul 2020 11:33:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0818;
 bh=7B9Ekt5Dirp9yN6+skXMl7i92e4ZXB9Ux+X5bwvpTEE=;
 b=jm5Qllv7goyz9I2qZ5LQG4WtQfc7oebixd+IlK0+lISJXP19CZO/pk28jT94vJ8N7N4I
 vkFaLK8WkmuCsGJu1gc9IEK3YEvuxXAl54jUxvWsnqaCi8VYUTuPAK1mNHVk1lggdlY/
 Od8ZtDxgo8+h3Jnq2S4a9NtEx5Y+lO53M0HVEn/7l8Oi8q4a5hJmwOd7yhVHgVT6zwD0
 3/6mVf7LrZFymE+3JEbQ3gJZ1nZlopOthFZg5/Hd4Z4Hs4I3pvhOaljDYGMQQ1lqwTRM
 ojRYjboehnzqQ1HKsOnTbTTcFYA/tAMIHQX3AnK45C8SMENErLLkAaShspsyssP7n2QX Ag== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 32c0kkfb8u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 20 Jul 2020 11:33:02 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 20 Jul
 2020 11:33:00 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 20 Jul 2020 11:33:01 -0700
Received: from NN-LT0044.marvell.com (NN-LT0044.marvell.com [10.193.54.8])
        by maili.marvell.com (Postfix) with ESMTP id 2D4D93F703F;
        Mon, 20 Jul 2020 11:32:58 -0700 (PDT)
From:   Mark Starovoytov <mstarovoitov@marvell.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Igor Russkikh <irusskikh@marvell.com>, <netdev@vger.kernel.org>,
        "Mark Starovoytov" <mstarovoitov@marvell.com>
Subject: [PATCH v3 net-next 05/13] net: atlantic: use u64_stats_update_* to protect access to 64-bit stats
Date:   Mon, 20 Jul 2020 21:32:36 +0300
Message-ID: <20200720183244.10029-6-mstarovoitov@marvell.com>
X-Mailer: git-send-email 2.26.2.windows.1
In-Reply-To: <20200720183244.10029-1-mstarovoitov@marvell.com>
References: <20200720183244.10029-1-mstarovoitov@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-20_09:2020-07-20,2020-07-20 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds u64_stats_update_* usage to protect access to 64-bit stats,
where necessary.

This is necessary for per-ring stats, because they are updated by the
driver directly, so there is a possibility for a partial read.

Other stats require no additional protection, e.g.:
 * all MACSec stats are fetched directly from HW (under semaphore);
 * nic/ndev stats (aq_stats_s) are fetched directly from FW (under mutex).

Signed-off-by: Mark Starovoytov <mstarovoitov@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 .../net/ethernet/aquantia/atlantic/aq_ptp.c   |  2 +
 .../net/ethernet/aquantia/atlantic/aq_ring.c  | 46 ++++++++++++++++---
 .../net/ethernet/aquantia/atlantic/aq_ring.h  |  9 ++--
 3 files changed, 47 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ptp.c b/drivers/net/ethernet/aquantia/atlantic/aq_ptp.c
index 116b8891c9c4..ec6aa9bb7dfc 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ptp.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ptp.c
@@ -782,8 +782,10 @@ int aq_ptp_xmit(struct aq_nic_s *aq_nic, struct sk_buff *skb)
 		err = aq_nic->aq_hw_ops->hw_ring_tx_xmit(aq_nic->aq_hw,
 						       ring, frags);
 		if (err >= 0) {
+			u64_stats_update_begin(&ring->stats.tx.syncp);
 			++ring->stats.tx.packets;
 			ring->stats.tx.bytes += skb->len;
+			u64_stats_update_end(&ring->stats.tx.syncp);
 		}
 	} else {
 		err = NETDEV_TX_BUSY;
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ring.c b/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
index fc4e10b064fd..b51ab2dbf6fe 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
@@ -70,18 +70,24 @@ static int aq_get_rxpages(struct aq_ring_s *self, struct aq_ring_buff_s *rxbuf,
 			rxbuf->rxdata.pg_off += AQ_CFG_RX_FRAME_MAX;
 			if (rxbuf->rxdata.pg_off + AQ_CFG_RX_FRAME_MAX <=
 				(PAGE_SIZE << order)) {
+				u64_stats_update_begin(&self->stats.rx.syncp);
 				self->stats.rx.pg_flips++;
+				u64_stats_update_end(&self->stats.rx.syncp);
 			} else {
 				/* Buffer exhausted. We have other users and
 				 * should release this page and realloc
 				 */
 				aq_free_rxpage(&rxbuf->rxdata,
 					       aq_nic_get_dev(self->aq_nic));
+				u64_stats_update_begin(&self->stats.rx.syncp);
 				self->stats.rx.pg_losts++;
+				u64_stats_update_end(&self->stats.rx.syncp);
 			}
 		} else {
 			rxbuf->rxdata.pg_off = 0;
+			u64_stats_update_begin(&self->stats.rx.syncp);
 			self->stats.rx.pg_reuses++;
+			u64_stats_update_end(&self->stats.rx.syncp);
 		}
 	}
 
@@ -213,6 +219,11 @@ int aq_ring_init(struct aq_ring_s *self, const enum atl_ring_type ring_type)
 	self->sw_tail = 0;
 	self->ring_type = ring_type;
 
+	if (self->ring_type == ATL_RING_RX)
+		u64_stats_init(&self->stats.rx.syncp);
+	else
+		u64_stats_init(&self->stats.tx.syncp);
+
 	return 0;
 }
 
@@ -239,7 +250,9 @@ void aq_ring_queue_wake(struct aq_ring_s *ring)
 						      ring->idx))) {
 		netif_wake_subqueue(ndev,
 				    AQ_NIC_RING2QMAP(ring->aq_nic, ring->idx));
+		u64_stats_update_begin(&ring->stats.tx.syncp);
 		ring->stats.tx.queue_restarts++;
+		u64_stats_update_end(&ring->stats.tx.syncp);
 	}
 }
 
@@ -281,8 +294,10 @@ bool aq_ring_tx_clean(struct aq_ring_s *self)
 		}
 
 		if (unlikely(buff->is_eop)) {
+			u64_stats_update_begin(&self->stats.tx.syncp);
 			++self->stats.tx.packets;
 			self->stats.tx.bytes += buff->skb->len;
+			u64_stats_update_end(&self->stats.tx.syncp);
 
 			dev_kfree_skb_any(buff->skb);
 		}
@@ -302,7 +317,9 @@ static void aq_rx_checksum(struct aq_ring_s *self,
 		return;
 
 	if (unlikely(buff->is_cso_err)) {
+		u64_stats_update_begin(&self->stats.rx.syncp);
 		++self->stats.rx.errors;
+		u64_stats_update_end(&self->stats.rx.syncp);
 		skb->ip_summed = CHECKSUM_NONE;
 		return;
 	}
@@ -372,13 +389,17 @@ int aq_ring_rx_clean(struct aq_ring_s *self,
 					buff_->is_cleaned = true;
 				} while (!buff_->is_eop);
 
+				u64_stats_update_begin(&self->stats.rx.syncp);
 				++self->stats.rx.errors;
+				u64_stats_update_end(&self->stats.rx.syncp);
 				continue;
 			}
 		}
 
 		if (buff->is_error) {
+			u64_stats_update_begin(&self->stats.rx.syncp);
 			++self->stats.rx.errors;
+			u64_stats_update_end(&self->stats.rx.syncp);
 			continue;
 		}
 
@@ -479,8 +500,10 @@ int aq_ring_rx_clean(struct aq_ring_s *self,
 						: AQ_NIC_RING2QMAP(self->aq_nic,
 								   self->idx));
 
+		u64_stats_update_begin(&self->stats.rx.syncp);
 		++self->stats.rx.packets;
 		self->stats.rx.bytes += skb->len;
+		u64_stats_update_end(&self->stats.rx.syncp);
 
 		napi_gro_receive(napi, skb);
 	}
@@ -564,18 +587,27 @@ void aq_ring_free(struct aq_ring_s *self)
 
 unsigned int aq_ring_fill_stats_data(struct aq_ring_s *self, u64 *data)
 {
-	unsigned int count = 0U;
+	unsigned int count;
+	unsigned int start;
 
 	if (self->ring_type == ATL_RING_RX) {
 		/* This data should mimic aq_ethtool_queue_rx_stat_names structure */
-		data[count] = self->stats.rx.packets;
-		data[++count] = self->stats.rx.jumbo_packets;
-		data[++count] = self->stats.rx.lro_packets;
-		data[++count] = self->stats.rx.errors;
+		do {
+			count = 0;
+			start = u64_stats_fetch_begin_irq(&self->stats.rx.syncp);
+			data[count] = self->stats.rx.packets;
+			data[++count] = self->stats.rx.jumbo_packets;
+			data[++count] = self->stats.rx.lro_packets;
+			data[++count] = self->stats.rx.errors;
+		} while (u64_stats_fetch_retry_irq(&self->stats.rx.syncp, start));
 	} else {
 		/* This data should mimic aq_ethtool_queue_tx_stat_names structure */
-		data[count] = self->stats.tx.packets;
-		data[++count] = self->stats.tx.queue_restarts;
+		do {
+			count = 0;
+			start = u64_stats_fetch_begin_irq(&self->stats.tx.syncp);
+			data[count] = self->stats.tx.packets;
+			data[++count] = self->stats.tx.queue_restarts;
+		} while (u64_stats_fetch_retry_irq(&self->stats.tx.syncp, start));
 	}
 
 	return ++count;
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ring.h b/drivers/net/ethernet/aquantia/atlantic/aq_ring.h
index 0cd761ba47a3..c92c3a0651a9 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ring.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ring.h
@@ -1,7 +1,8 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
-/*
- * aQuantia Corporation Network Driver
- * Copyright (C) 2014-2019 aQuantia Corporation. All rights reserved
+/* Atlantic Network Driver
+ *
+ * Copyright (C) 2014-2019 aQuantia Corporation
+ * Copyright (C) 2019-2020 Marvell International Ltd.
  */
 
 /* File aq_ring.h: Declaration of functions for Rx/Tx rings. */
@@ -88,6 +89,7 @@ struct __packed aq_ring_buff_s {
 };
 
 struct aq_ring_stats_rx_s {
+	struct u64_stats_sync syncp;	/* must be first */
 	u64 errors;
 	u64 packets;
 	u64 bytes;
@@ -99,6 +101,7 @@ struct aq_ring_stats_rx_s {
 };
 
 struct aq_ring_stats_tx_s {
+	struct u64_stats_sync syncp;	/* must be first */
 	u64 errors;
 	u64 packets;
 	u64 bytes;
-- 
2.25.1

