Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50533226E51
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 20:33:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730562AbgGTSdD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 14:33:03 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:57218 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730534AbgGTSdC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 14:33:02 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06KIG878015959;
        Mon, 20 Jul 2020 11:33:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0818;
 bh=grpz6OHnXbsmUqjYQJiDstXVx7fkMLojwLZgyfVJMAg=;
 b=Zn+sarObuCZ8fzUEI35P9oCIPBpSACcIJFHJK48zw+kkG9VmIl00M7PQLvUB9+RFiFNn
 XGbTWhccug42ulibWMW21Arh0CaX8RiSWub8N27s/7wOwswOE4FCBjoEf/58SLfyEFRx
 M+OzfGcAVPD721d35j3wy5XCMYPCrS1FmI8hbGQVvfm0wBz6xlfSr8xoJBNm1srnEvnA
 3j1ZiovbvNbaRI8+SfGJkhV7EZQQ8CCVGR/eqE0ZcaYk7/5UPU3PmnHroeROVJTo+7G3
 wBuaBvgWNKCUk3cFrIAFgN7TYjLnHLSpf6dz5pEBY/gs/A2aiLOg/cNN9L3IxyOBkkML Og== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 32bxeng0fx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 20 Jul 2020 11:33:00 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 20 Jul
 2020 11:32:59 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 20 Jul
 2020 11:32:58 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 20 Jul 2020 11:32:58 -0700
Received: from NN-LT0044.marvell.com (NN-LT0044.marvell.com [10.193.54.8])
        by maili.marvell.com (Postfix) with ESMTP id EB0B13F7041;
        Mon, 20 Jul 2020 11:32:56 -0700 (PDT)
From:   Mark Starovoytov <mstarovoitov@marvell.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Igor Russkikh <irusskikh@marvell.com>, <netdev@vger.kernel.org>,
        "Mark Starovoytov" <mstarovoitov@marvell.com>
Subject: [PATCH v3 net-next 04/13] net: atlantic: split rx and tx per-queue stats
Date:   Mon, 20 Jul 2020 21:32:35 +0300
Message-ID: <20200720183244.10029-5-mstarovoitov@marvell.com>
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

This patch splits rx and tx per-queue stats.
This change simplifies the follow-up introduction of PTP stats and
u64_stats_update_* usage.

Signed-off-by: Mark Starovoytov <mstarovoitov@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 .../ethernet/aquantia/atlantic/aq_ethtool.c   | 28 ++++++---
 .../net/ethernet/aquantia/atlantic/aq_ptp.c   |  6 +-
 .../net/ethernet/aquantia/atlantic/aq_ring.c  | 28 +++++++--
 .../net/ethernet/aquantia/atlantic/aq_ring.h  | 10 +++-
 .../net/ethernet/aquantia/atlantic/aq_vec.c   | 58 +++++--------------
 .../net/ethernet/aquantia/atlantic/aq_vec.h   |  1 +
 6 files changed, 68 insertions(+), 63 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c b/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
index a8f0fbbbd91a..98ba8355a0f0 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
@@ -89,15 +89,18 @@ static const char aq_ethtool_stat_names[][ETH_GSTRING_LEN] = {
 	"InDroppedDma",
 };
 
-static const char * const aq_ethtool_queue_stat_names[] = {
+static const char * const aq_ethtool_queue_rx_stat_names[] = {
 	"%sQueue[%d] InPackets",
-	"%sQueue[%d] OutPackets",
-	"%sQueue[%d] Restarts",
 	"%sQueue[%d] InJumboPackets",
 	"%sQueue[%d] InLroPackets",
 	"%sQueue[%d] InErrors",
 };
 
+static const char * const aq_ethtool_queue_tx_stat_names[] = {
+	"%sQueue[%d] OutPackets",
+	"%sQueue[%d] Restarts",
+};
+
 #if IS_ENABLED(CONFIG_MACSEC)
 static const char aq_macsec_stat_names[][ETH_GSTRING_LEN] = {
 	"MACSec InCtlPackets",
@@ -164,11 +167,12 @@ static const char aq_ethtool_priv_flag_names[][ETH_GSTRING_LEN] = {
 
 static u32 aq_ethtool_n_stats(struct net_device *ndev)
 {
+	const int rx_stat_cnt = ARRAY_SIZE(aq_ethtool_queue_rx_stat_names);
+	const int tx_stat_cnt = ARRAY_SIZE(aq_ethtool_queue_tx_stat_names);
 	struct aq_nic_s *nic = netdev_priv(ndev);
 	struct aq_nic_cfg_s *cfg = aq_nic_get_cfg(nic);
 	u32 n_stats = ARRAY_SIZE(aq_ethtool_stat_names) +
-		      ARRAY_SIZE(aq_ethtool_queue_stat_names) * cfg->vecs *
-			cfg->tcs;
+		      (rx_stat_cnt + tx_stat_cnt) * cfg->vecs * cfg->tcs;
 
 #if IS_ENABLED(CONFIG_MACSEC)
 	if (nic->macsec_cfg) {
@@ -237,7 +241,8 @@ static void aq_ethtool_get_strings(struct net_device *ndev,
 
 	switch (stringset) {
 	case ETH_SS_STATS: {
-		const int stat_cnt = ARRAY_SIZE(aq_ethtool_queue_stat_names);
+		const int rx_stat_cnt = ARRAY_SIZE(aq_ethtool_queue_rx_stat_names);
+		const int tx_stat_cnt = ARRAY_SIZE(aq_ethtool_queue_tx_stat_names);
 		char tc_string[8];
 		int tc;
 
@@ -251,9 +256,16 @@ static void aq_ethtool_get_strings(struct net_device *ndev,
 				snprintf(tc_string, 8, "TC%d ", tc);
 
 			for (i = 0; i < cfg->vecs; i++) {
-				for (si = 0; si < stat_cnt; si++) {
+				for (si = 0; si < rx_stat_cnt; si++) {
+					snprintf(p, ETH_GSTRING_LEN,
+					     aq_ethtool_queue_rx_stat_names[si],
+					     tc_string,
+					     AQ_NIC_CFG_TCVEC2RING(cfg, tc, i));
+					p += ETH_GSTRING_LEN;
+				}
+				for (si = 0; si < tx_stat_cnt; si++) {
 					snprintf(p, ETH_GSTRING_LEN,
-					     aq_ethtool_queue_stat_names[si],
+					     aq_ethtool_queue_tx_stat_names[si],
 					     tc_string,
 					     AQ_NIC_CFG_TCVEC2RING(cfg, tc, i));
 					p += ETH_GSTRING_LEN;
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ptp.c b/drivers/net/ethernet/aquantia/atlantic/aq_ptp.c
index cb9bf41470fd..116b8891c9c4 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ptp.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ptp.c
@@ -844,7 +844,7 @@ int aq_ptp_ring_init(struct aq_nic_s *aq_nic)
 	if (!aq_ptp)
 		return 0;
 
-	err = aq_ring_init(&aq_ptp->ptp_tx);
+	err = aq_ring_init(&aq_ptp->ptp_tx, ATL_RING_TX);
 	if (err < 0)
 		goto err_exit;
 	err = aq_nic->aq_hw_ops->hw_ring_tx_init(aq_nic->aq_hw,
@@ -853,7 +853,7 @@ int aq_ptp_ring_init(struct aq_nic_s *aq_nic)
 	if (err < 0)
 		goto err_exit;
 
-	err = aq_ring_init(&aq_ptp->ptp_rx);
+	err = aq_ring_init(&aq_ptp->ptp_rx, ATL_RING_RX);
 	if (err < 0)
 		goto err_exit;
 	err = aq_nic->aq_hw_ops->hw_ring_rx_init(aq_nic->aq_hw,
@@ -871,7 +871,7 @@ int aq_ptp_ring_init(struct aq_nic_s *aq_nic)
 	if (err < 0)
 		goto err_rx_free;
 
-	err = aq_ring_init(&aq_ptp->hwts_rx);
+	err = aq_ring_init(&aq_ptp->hwts_rx, ATL_RING_RX);
 	if (err < 0)
 		goto err_rx_free;
 	err = aq_nic->aq_hw_ops->hw_ring_rx_init(aq_nic->aq_hw,
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ring.c b/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
index 8dd59e9fc3aa..fc4e10b064fd 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
@@ -206,11 +206,12 @@ aq_ring_hwts_rx_alloc(struct aq_ring_s *self, struct aq_nic_s *aq_nic,
 	return self;
 }
 
-int aq_ring_init(struct aq_ring_s *self)
+int aq_ring_init(struct aq_ring_s *self, const enum atl_ring_type ring_type)
 {
 	self->hw_head = 0;
 	self->sw_head = 0;
 	self->sw_tail = 0;
+	self->ring_type = ring_type;
 
 	return 0;
 }
@@ -538,7 +539,7 @@ int aq_ring_rx_fill(struct aq_ring_s *self)
 void aq_ring_rx_deinit(struct aq_ring_s *self)
 {
 	if (!self)
-		goto err_exit;
+		return;
 
 	for (; self->sw_head != self->sw_tail;
 		self->sw_head = aq_ring_next_dx(self, self->sw_head)) {
@@ -546,14 +547,12 @@ void aq_ring_rx_deinit(struct aq_ring_s *self)
 
 		aq_free_rxpage(&buff->rxdata, aq_nic_get_dev(self->aq_nic));
 	}
-
-err_exit:;
 }
 
 void aq_ring_free(struct aq_ring_s *self)
 {
 	if (!self)
-		goto err_exit;
+		return;
 
 	kfree(self->buff_ring);
 
@@ -561,6 +560,23 @@ void aq_ring_free(struct aq_ring_s *self)
 		dma_free_coherent(aq_nic_get_dev(self->aq_nic),
 				  self->size * self->dx_size, self->dx_ring,
 				  self->dx_ring_pa);
+}
+
+unsigned int aq_ring_fill_stats_data(struct aq_ring_s *self, u64 *data)
+{
+	unsigned int count = 0U;
+
+	if (self->ring_type == ATL_RING_RX) {
+		/* This data should mimic aq_ethtool_queue_rx_stat_names structure */
+		data[count] = self->stats.rx.packets;
+		data[++count] = self->stats.rx.jumbo_packets;
+		data[++count] = self->stats.rx.lro_packets;
+		data[++count] = self->stats.rx.errors;
+	} else {
+		/* This data should mimic aq_ethtool_queue_tx_stat_names structure */
+		data[count] = self->stats.tx.packets;
+		data[++count] = self->stats.tx.queue_restarts;
+	}
 
-err_exit:;
+	return ++count;
 }
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ring.h b/drivers/net/ethernet/aquantia/atlantic/aq_ring.h
index 2c96f20f6289..0cd761ba47a3 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ring.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ring.h
@@ -110,6 +110,11 @@ union aq_ring_stats_s {
 	struct aq_ring_stats_tx_s tx;
 };
 
+enum atl_ring_type {
+	ATL_RING_TX,
+	ATL_RING_RX,
+};
+
 struct aq_ring_s {
 	struct aq_ring_buff_s *buff_ring;
 	u8 *dx_ring;		/* descriptors ring, dma shared mem */
@@ -124,6 +129,7 @@ struct aq_ring_s {
 	unsigned int page_order;
 	union aq_ring_stats_s stats;
 	dma_addr_t dx_ring_pa;
+	enum atl_ring_type ring_type;
 };
 
 struct aq_ring_param_s {
@@ -163,7 +169,7 @@ struct aq_ring_s *aq_ring_rx_alloc(struct aq_ring_s *self,
 				   struct aq_nic_s *aq_nic,
 				   unsigned int idx,
 				   struct aq_nic_cfg_s *aq_nic_cfg);
-int aq_ring_init(struct aq_ring_s *self);
+int aq_ring_init(struct aq_ring_s *self, const enum atl_ring_type ring_type);
 void aq_ring_rx_deinit(struct aq_ring_s *self);
 void aq_ring_free(struct aq_ring_s *self);
 void aq_ring_update_queue_state(struct aq_ring_s *ring);
@@ -181,4 +187,6 @@ struct aq_ring_s *aq_ring_hwts_rx_alloc(struct aq_ring_s *self,
 		unsigned int size, unsigned int dx_size);
 void aq_ring_hwts_rx_clean(struct aq_ring_s *self, struct aq_nic_s *aq_nic);
 
+unsigned int aq_ring_fill_stats_data(struct aq_ring_s *self, u64 *data);
+
 #endif /* AQ_RING_H */
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_vec.c b/drivers/net/ethernet/aquantia/atlantic/aq_vec.c
index 8f0a0d18e711..b008d12e923a 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_vec.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_vec.c
@@ -181,7 +181,7 @@ int aq_vec_init(struct aq_vec_s *self, const struct aq_hw_ops *aq_hw_ops,
 
 	for (i = 0U, ring = self->ring[0];
 		self->tx_rings > i; ++i, ring = self->ring[i]) {
-		err = aq_ring_init(&ring[AQ_VEC_TX_ID]);
+		err = aq_ring_init(&ring[AQ_VEC_TX_ID], ATL_RING_TX);
 		if (err < 0)
 			goto err_exit;
 
@@ -191,7 +191,7 @@ int aq_vec_init(struct aq_vec_s *self, const struct aq_hw_ops *aq_hw_ops,
 		if (err < 0)
 			goto err_exit;
 
-		err = aq_ring_init(&ring[AQ_VEC_RX_ID]);
+		err = aq_ring_init(&ring[AQ_VEC_RX_ID], ATL_RING_RX);
 		if (err < 0)
 			goto err_exit;
 
@@ -350,55 +350,23 @@ cpumask_t *aq_vec_get_affinity_mask(struct aq_vec_s *self)
 	return &self->aq_ring_param.affinity_mask;
 }
 
-static void aq_vec_get_stats(struct aq_vec_s *self,
-			     const unsigned int tc,
-			     struct aq_ring_stats_rx_s *stats_rx,
-			     struct aq_ring_stats_tx_s *stats_tx)
+bool aq_vec_is_valid_tc(struct aq_vec_s *self, const unsigned int tc)
 {
-	struct aq_ring_s *ring = self->ring[tc];
-
-	if (tc < self->rx_rings) {
-		struct aq_ring_stats_rx_s *rx = &ring[AQ_VEC_RX_ID].stats.rx;
-
-		stats_rx->packets = rx->packets;
-		stats_rx->bytes = rx->bytes;
-		stats_rx->errors = rx->errors;
-		stats_rx->jumbo_packets = rx->jumbo_packets;
-		stats_rx->lro_packets = rx->lro_packets;
-		stats_rx->pg_losts = rx->pg_losts;
-		stats_rx->pg_flips = rx->pg_flips;
-		stats_rx->pg_reuses = rx->pg_reuses;
-	}
-
-	if (tc < self->tx_rings) {
-		struct aq_ring_stats_tx_s *tx = &ring[AQ_VEC_TX_ID].stats.tx;
-
-		stats_tx->packets = tx->packets;
-		stats_tx->bytes = tx->bytes;
-		stats_tx->errors = tx->errors;
-		stats_tx->queue_restarts = tx->queue_restarts;
-	}
+	return tc < self->rx_rings && tc < self->tx_rings;
 }
 
 unsigned int aq_vec_get_sw_stats(struct aq_vec_s *self, const unsigned int tc, u64 *data)
 {
-	struct aq_ring_stats_rx_s stats_rx;
-	struct aq_ring_stats_tx_s stats_tx;
-	unsigned int count = 0U;
-
-	memset(&stats_rx, 0U, sizeof(struct aq_ring_stats_rx_s));
-	memset(&stats_tx, 0U, sizeof(struct aq_ring_stats_tx_s));
+	unsigned int count;
 
-	aq_vec_get_stats(self, tc, &stats_rx, &stats_tx);
+	WARN_ONCE(!aq_vec_is_valid_tc(self, tc),
+		  "Invalid tc %u (#rx=%u, #tx=%u)\n",
+		  tc, self->rx_rings, self->tx_rings);
+	if (!aq_vec_is_valid_tc(self, tc))
+		return 0;
 
-	/* This data should mimic aq_ethtool_queue_stat_names structure
-	 */
-	data[count] = stats_rx.packets;
-	data[++count] = stats_tx.packets;
-	data[++count] = stats_tx.queue_restarts;
-	data[++count] = stats_rx.jumbo_packets;
-	data[++count] = stats_rx.lro_packets;
-	data[++count] = stats_rx.errors;
+	count = aq_ring_fill_stats_data(&self->ring[tc][AQ_VEC_RX_ID], data);
+	count += aq_ring_fill_stats_data(&self->ring[tc][AQ_VEC_TX_ID], data + count);
 
-	return ++count;
+	return count;
 }
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_vec.h b/drivers/net/ethernet/aquantia/atlantic/aq_vec.h
index c079fef80da8..567f3d4b79a2 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_vec.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_vec.h
@@ -36,6 +36,7 @@ void aq_vec_ring_free(struct aq_vec_s *self);
 int aq_vec_start(struct aq_vec_s *self);
 void aq_vec_stop(struct aq_vec_s *self);
 cpumask_t *aq_vec_get_affinity_mask(struct aq_vec_s *self);
+bool aq_vec_is_valid_tc(struct aq_vec_s *self, const unsigned int tc);
 unsigned int aq_vec_get_sw_stats(struct aq_vec_s *self, const unsigned int tc, u64 *data);
 
 #endif /* AQ_VEC_H */
-- 
2.25.1

