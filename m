Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92F5222119D
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 17:50:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727901AbgGOPtZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 11:49:25 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:1832 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727787AbgGOPtJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 11:49:09 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06FFei8C017354;
        Wed, 15 Jul 2020 08:49:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=QFODZ5yH4TDKQZLgrMhKbBljSrjYax24NAnSWAkCcKA=;
 b=vjf86wgY+hWyLm8+KPQ+6s19sgWq39SFjEOBzpbipHtOWay9lCIPFBxlmNCVsCwnfMA0
 L1IT9QF2empgs2XgFqRUmfaLsZQY8ns12UVB6GuXpT9yWR/ehvgZiXjbPRcMUsZawyS9
 KhIzXxy+w2MkTi5jO4v7uXvPq2UR+CFupGZFxwDDsXwBOrlMgffTmSI54SUR/wWqyHTB
 1UlEhh4HNm/YxOoc0yK02ONS080Y8wsqPYUGw12JvP7M/O40GCc72ODj4gfXYtX8iiPh
 S6sLwvTs/l9lIRKZsy+RnTptbwKR3yRNos1GgXMChgKY2lSfkgne3553C6I7BAO9ODGT VQ== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 328mmhudnf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 15 Jul 2020 08:49:04 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 15 Jul
 2020 08:49:02 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 15 Jul 2020 08:49:02 -0700
Received: from NN-LT0019.marvell.com (NN-LT0019.marvell.com [10.193.54.28])
        by maili.marvell.com (Postfix) with ESMTP id 96D8D3F704B;
        Wed, 15 Jul 2020 08:49:00 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Dmitry Bogdanov <dbogdanov@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: [PATCH v2 net-next 02/10] net: atlantic: additional per-queue stats
Date:   Wed, 15 Jul 2020 18:48:34 +0300
Message-ID: <20200715154842.305-3-irusskikh@marvell.com>
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

From: Dmitry Bogdanov <dbogdanov@marvell.com>

This patch adds additional per-queue stats, these could
be useful for debugging and diagnostics.

Signed-off-by: Dmitry Bogdanov <dbogdanov@marvell.com>
Signed-off-by: Mark Starovoytov <mstarovoitov@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 .../ethernet/aquantia/atlantic/aq_ethtool.c   |  3 ++
 .../net/ethernet/aquantia/atlantic/aq_nic.c   | 42 ++++++++++++++++-
 .../net/ethernet/aquantia/atlantic/aq_nic.h   |  6 +++
 .../net/ethernet/aquantia/atlantic/aq_ring.c  |  4 ++
 .../net/ethernet/aquantia/atlantic/aq_ring.h  | 10 ++--
 .../net/ethernet/aquantia/atlantic/aq_vec.c   | 46 +++++--------------
 .../net/ethernet/aquantia/atlantic/aq_vec.h   | 14 ++++--
 7 files changed, 81 insertions(+), 44 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c b/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
index a8f0fbbbd91a..420fa5b791f9 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
@@ -96,6 +96,9 @@ static const char * const aq_ethtool_queue_stat_names[] = {
 	"%sQueue[%d] InJumboPackets",
 	"%sQueue[%d] InLroPackets",
 	"%sQueue[%d] InErrors",
+	"%sQueue[%d] AllocFails",
+	"%sQueue[%d] SkbAllocFails",
+	"%sQueue[%d] Polls",
 };
 
 #if IS_ENABLED(CONFIG_MACSEC)
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
index 43b8914c3ef5..45d99c1a9635 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
@@ -857,6 +857,20 @@ int aq_nic_get_regs_count(struct aq_nic_s *self)
 	return self->aq_nic_cfg.aq_hw_caps->mac_regs_count;
 }
 
+static int aq_nic_get_tc_stats(struct aq_vec_s *vec, const unsigned int tc,
+			       u64 *data, unsigned int *p_count)
+{
+	struct aq_ring_stats_rx_s stats_rx;
+	struct aq_ring_stats_tx_s stats_tx;
+
+	memset(&stats_rx, 0U, sizeof(struct aq_ring_stats_rx_s));
+	memset(&stats_tx, 0U, sizeof(struct aq_ring_stats_tx_s));
+
+	aq_vec_add_stats(vec, tc, &stats_rx, &stats_tx);
+
+	return aq_nic_fill_stats_data(&stats_rx, &stats_tx, data, p_count);
+}
+
 u64 *aq_nic_get_stats(struct aq_nic_s *self, u64 *data)
 {
 	struct aq_vec_s *aq_vec = NULL;
@@ -907,13 +921,13 @@ u64 *aq_nic_get_stats(struct aq_nic_s *self, u64 *data)
 		     aq_vec && self->aq_vecs > i;
 		     ++i, aq_vec = self->aq_vec[i]) {
 			data += count;
-			aq_vec_get_sw_stats(aq_vec, tc, data, &count);
+			aq_nic_get_tc_stats(aq_vec, tc, data, &count);
 		}
 	}
 
 	data += count;
 
-err_exit:;
+err_exit:
 	return data;
 }
 
@@ -932,6 +946,30 @@ static void aq_nic_update_ndev_stats(struct aq_nic_s *self)
 	ndev->stats.multicast = stats->mprc;
 }
 
+int aq_nic_fill_stats_data(struct aq_ring_stats_rx_s *stats_rx,
+			   struct aq_ring_stats_tx_s *stats_tx,
+			   u64 *data,
+			   unsigned int *p_count)
+{
+	unsigned int count = 0U;
+	/* This data should mimic aq_ethtool_queue_stat_names structure
+	 */
+	data[count] += stats_rx->packets;
+	data[++count] += stats_tx->packets;
+	data[++count] += stats_tx->queue_restarts;
+	data[++count] += stats_rx->jumbo_packets;
+	data[++count] += stats_rx->lro_packets;
+	data[++count] += stats_rx->errors;
+	data[++count] += stats_rx->alloc_fails;
+	data[++count] += stats_rx->skb_alloc_fails;
+	data[++count] += stats_rx->polls;
+
+	if (p_count)
+		*p_count = ++count;
+
+	return 0;
+}
+
 void aq_nic_get_link_ksettings(struct aq_nic_s *self,
 			       struct ethtool_link_ksettings *cmd)
 {
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.h b/drivers/net/ethernet/aquantia/atlantic/aq_nic.h
index 317bfc646f0a..0c7233d8ecd6 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.h
@@ -15,6 +15,8 @@
 #include "aq_hw.h"
 
 struct aq_ring_s;
+struct aq_ring_stats_rx_s;
+struct aq_ring_stats_tx_s;
 struct aq_hw_ops;
 struct aq_fw_s;
 struct aq_vec_s;
@@ -175,6 +177,10 @@ int aq_nic_xmit(struct aq_nic_s *self, struct sk_buff *skb);
 int aq_nic_get_regs(struct aq_nic_s *self, struct ethtool_regs *regs, void *p);
 int aq_nic_get_regs_count(struct aq_nic_s *self);
 u64 *aq_nic_get_stats(struct aq_nic_s *self, u64 *data);
+int aq_nic_fill_stats_data(struct aq_ring_stats_rx_s *stats_rx,
+			   struct aq_ring_stats_tx_s *stats_tx,
+			   u64 *data,
+			   unsigned int *p_count);
 int aq_nic_stop(struct aq_nic_s *self);
 void aq_nic_deinit(struct aq_nic_s *self, bool link_down);
 void aq_nic_set_power(struct aq_nic_s *self);
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ring.c b/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
index 8dd59e9fc3aa..20b606aa7974 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
@@ -88,6 +88,8 @@ static int aq_get_rxpages(struct aq_ring_s *self, struct aq_ring_buff_s *rxbuf,
 	if (!rxbuf->rxdata.page) {
 		ret = aq_get_rxpage(&rxbuf->rxdata, order,
 				    aq_nic_get_dev(self->aq_nic));
+		if (ret)
+			self->stats.rx.alloc_fails++;
 		return ret;
 	}
 
@@ -392,6 +394,7 @@ int aq_ring_rx_clean(struct aq_ring_s *self,
 			skb = build_skb(aq_buf_vaddr(&buff->rxdata),
 					AQ_CFG_RX_FRAME_MAX);
 			if (unlikely(!skb)) {
+				self->stats.rx.skb_alloc_fails++;
 				err = -ENOMEM;
 				goto err_exit;
 			}
@@ -405,6 +408,7 @@ int aq_ring_rx_clean(struct aq_ring_s *self,
 		} else {
 			skb = napi_alloc_skb(napi, AQ_CFG_RX_HDR_SIZE);
 			if (unlikely(!skb)) {
+				self->stats.rx.skb_alloc_fails++;
 				err = -ENOMEM;
 				goto err_exit;
 			}
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ring.h b/drivers/net/ethernet/aquantia/atlantic/aq_ring.h
index 2c96f20f6289..0e40ccbaf19a 100644
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
@@ -93,6 +94,9 @@ struct aq_ring_stats_rx_s {
 	u64 bytes;
 	u64 lro_packets;
 	u64 jumbo_packets;
+	u64 alloc_fails;
+	u64 skb_alloc_fails;
+	u64 polls;
 	u64 pg_losts;
 	u64 pg_flips;
 	u64 pg_reuses;
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_vec.c b/drivers/net/ethernet/aquantia/atlantic/aq_vec.c
index d1d43c8ce400..eafcb98c274f 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_vec.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_vec.c
@@ -1,7 +1,8 @@
 // SPDX-License-Identifier: GPL-2.0-only
-/*
- * aQuantia Corporation Network Driver
- * Copyright (C) 2014-2017 aQuantia Corporation. All rights reserved
+/* Atlantic Network Driver
+ *
+ * Copyright (C) 2014-2019 aQuantia Corporation
+ * Copyright (C) 2019-2020 Marvell International Ltd.
  */
 
 /* File aq_vec.c: Definition of common structure for vector of Rx and Tx rings.
@@ -44,6 +45,7 @@ static int aq_vec_poll(struct napi_struct *napi, int budget)
 	} else {
 		for (i = 0U, ring = self->ring[0];
 			self->tx_rings > i; ++i, ring = self->ring[i]) {
+			ring[AQ_VEC_RX_ID].stats.rx.polls++;
 			if (self->aq_hw_ops->hw_ring_tx_head_update) {
 				err = self->aq_hw_ops->hw_ring_tx_head_update(
 							self->aq_hw,
@@ -349,10 +351,10 @@ cpumask_t *aq_vec_get_affinity_mask(struct aq_vec_s *self)
 	return &self->aq_ring_param.affinity_mask;
 }
 
-static void aq_vec_add_stats(struct aq_vec_s *self,
-			     const unsigned int tc,
-			     struct aq_ring_stats_rx_s *stats_rx,
-			     struct aq_ring_stats_tx_s *stats_tx)
+void aq_vec_add_stats(struct aq_vec_s *self,
+		      const unsigned int tc,
+		      struct aq_ring_stats_rx_s *stats_rx,
+		      struct aq_ring_stats_tx_s *stats_tx)
 {
 	struct aq_ring_s *ring = self->ring[tc];
 
@@ -364,6 +366,9 @@ static void aq_vec_add_stats(struct aq_vec_s *self,
 		stats_rx->errors += rx->errors;
 		stats_rx->jumbo_packets += rx->jumbo_packets;
 		stats_rx->lro_packets += rx->lro_packets;
+		stats_rx->alloc_fails += rx->alloc_fails;
+		stats_rx->skb_alloc_fails += rx->skb_alloc_fails;
+		stats_rx->polls += rx->polls;
 		stats_rx->pg_losts += rx->pg_losts;
 		stats_rx->pg_flips += rx->pg_flips;
 		stats_rx->pg_reuses += rx->pg_reuses;
@@ -378,30 +383,3 @@ static void aq_vec_add_stats(struct aq_vec_s *self,
 		stats_tx->queue_restarts += tx->queue_restarts;
 	}
 }
-
-int aq_vec_get_sw_stats(struct aq_vec_s *self, const unsigned int tc, u64 *data,
-			unsigned int *p_count)
-{
-	struct aq_ring_stats_rx_s stats_rx;
-	struct aq_ring_stats_tx_s stats_tx;
-	unsigned int count = 0U;
-
-	memset(&stats_rx, 0U, sizeof(struct aq_ring_stats_rx_s));
-	memset(&stats_tx, 0U, sizeof(struct aq_ring_stats_tx_s));
-
-	aq_vec_add_stats(self, tc, &stats_rx, &stats_tx);
-
-	/* This data should mimic aq_ethtool_queue_stat_names structure
-	 */
-	data[count] += stats_rx.packets;
-	data[++count] += stats_tx.packets;
-	data[++count] += stats_tx.queue_restarts;
-	data[++count] += stats_rx.jumbo_packets;
-	data[++count] += stats_rx.lro_packets;
-	data[++count] += stats_rx.errors;
-
-	if (p_count)
-		*p_count = ++count;
-
-	return 0;
-}
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_vec.h b/drivers/net/ethernet/aquantia/atlantic/aq_vec.h
index 541af85e6510..876781a1e2b3 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_vec.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_vec.h
@@ -1,7 +1,8 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
-/*
- * aQuantia Corporation Network Driver
- * Copyright (C) 2014-2017 aQuantia Corporation. All rights reserved
+/* Atlantic Network Driver
+ *
+ * Copyright (C) 2014-2019 aQuantia Corporation
+ * Copyright (C) 2019-2020 Marvell International Ltd.
  */
 
 /* File aq_vec.h: Definition of common structures for vector of Rx and Tx rings.
@@ -35,7 +36,10 @@ void aq_vec_ring_free(struct aq_vec_s *self);
 int aq_vec_start(struct aq_vec_s *self);
 void aq_vec_stop(struct aq_vec_s *self);
 cpumask_t *aq_vec_get_affinity_mask(struct aq_vec_s *self);
-int aq_vec_get_sw_stats(struct aq_vec_s *self, const unsigned int tc, u64 *data,
-			unsigned int *p_count);
+
+void aq_vec_add_stats(struct aq_vec_s *self,
+		      const unsigned int tc,
+		      struct aq_ring_stats_rx_s *stats_rx,
+		      struct aq_ring_stats_tx_s *stats_tx);
 
 #endif /* AQ_VEC_H */
-- 
2.25.1

