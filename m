Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1213B1DB582
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 15:48:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726892AbgETNr7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 09:47:59 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:24260 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726851AbgETNrz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 09:47:55 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04KDfCT7015126;
        Wed, 20 May 2020 06:47:53 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=javRVFVL+o6Z7eNucgyFjglVihMaNq5fk1FP6hyXBKE=;
 b=rZ8SeltZhGI+xCngzP/9EZ8ppziQNzr0kkqS0UOO69BAqSqIGXq8ZZFP7eNgmg1viZQ4
 3HSZqcao5qvE05yDuhwRs//dv97vFL6mM0gPLtxGb/VfUriue7dRaRGrO1m/znL3JUmk
 scgPZTQz8arm2Gi3EEgPxpN7wnDbA23y/1lhPH6Zsi4yWdyOjoGt3eK8/7cxB/GsryaG
 LA5ALAP+1vbuJpvfvQi6F6qf68s0Vx4g7Op/WyZLhMXyMuStHmXEC3+GQR7Xb/74DfXr
 Nj7bevzVWif25C+vAC4FpMsyHlnBaU8KIxi8tAdBzpRxPElugITipqNA2Oxy6exp8+QG 1Q== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 312fpp8ks3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 20 May 2020 06:47:53 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 20 May
 2020 06:47:50 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 20 May 2020 06:47:51 -0700
Received: from NN-LT0019.marvell.com (unknown [10.193.39.5])
        by maili.marvell.com (Postfix) with ESMTP id 3793A3F7040;
        Wed, 20 May 2020 06:47:48 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: [PATCH net-next 05/12] net: atlantic: per-TC queue statistics
Date:   Wed, 20 May 2020 16:47:27 +0300
Message-ID: <20200520134734.2014-6-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200520134734.2014-1-irusskikh@marvell.com>
References: <20200520134734.2014-1-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-20_09:2020-05-20,2020-05-20 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Starovoytov <mstarovoitov@marvell.com>

This patch adds support for per-TC queue statistics.

By default (single TC), the output is the same as it used to be, e.g.:
     Queue[0] InPackets: 2
     Queue[0] OutPackets: 8
     Queue[0] Restarts: 0
     Queue[0] InJumboPackets: 0
     Queue[0] InLroPackets: 0
     Queue[0] InErrors: 0

If several TCs are enabled, then each queue statistics line is prefixed
with TC number, e.g.:
     TC0 Queue[0] InPackets: 6
     TC0 Queue[0] OutPackets: 11
Queue numbering is end-to-end, so:
     TC1 Queue[4] InPackets: 0
     TC1 Queue[4] OutPackets: 22

Signed-off-by: Mark Starovoytov <mstarovoitov@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 .../ethernet/aquantia/atlantic/aq_ethtool.c   | 59 +++++++++++--------
 .../net/ethernet/aquantia/atlantic/aq_nic.c   | 12 ++--
 .../net/ethernet/aquantia/atlantic/aq_vec.c   | 24 ++++----
 .../net/ethernet/aquantia/atlantic/aq_vec.h   |  5 +-
 4 files changed, 59 insertions(+), 41 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c b/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
index 86fc77d85fda..440a7d129848 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
@@ -88,13 +88,13 @@ static const char aq_ethtool_stat_names[][ETH_GSTRING_LEN] = {
 	"InDroppedDma",
 };
 
-static const char aq_ethtool_queue_stat_names[][ETH_GSTRING_LEN] = {
-	"Queue[%d] InPackets",
-	"Queue[%d] OutPackets",
-	"Queue[%d] Restarts",
-	"Queue[%d] InJumboPackets",
-	"Queue[%d] InLroPackets",
-	"Queue[%d] InErrors",
+static const char * const aq_ethtool_queue_stat_names[] = {
+	"%sQueue[%d] InPackets",
+	"%sQueue[%d] OutPackets",
+	"%sQueue[%d] Restarts",
+	"%sQueue[%d] InJumboPackets",
+	"%sQueue[%d] InLroPackets",
+	"%sQueue[%d] InErrors",
 };
 
 #if IS_ENABLED(CONFIG_MACSEC)
@@ -166,7 +166,8 @@ static u32 aq_ethtool_n_stats(struct net_device *ndev)
 	struct aq_nic_s *nic = netdev_priv(ndev);
 	struct aq_nic_cfg_s *cfg = aq_nic_get_cfg(nic);
 	u32 n_stats = ARRAY_SIZE(aq_ethtool_stat_names) +
-		      ARRAY_SIZE(aq_ethtool_queue_stat_names) * cfg->vecs;
+		      ARRAY_SIZE(aq_ethtool_queue_stat_names) * cfg->vecs *
+			cfg->tcs;
 
 #if IS_ENABLED(CONFIG_MACSEC)
 	if (nic->macsec_cfg) {
@@ -223,7 +224,7 @@ static void aq_ethtool_get_drvinfo(struct net_device *ndev,
 static void aq_ethtool_get_strings(struct net_device *ndev,
 				   u32 stringset, u8 *data)
 {
-	struct aq_nic_s *aq_nic = netdev_priv(ndev);
+	struct aq_nic_s *nic = netdev_priv(ndev);
 	struct aq_nic_cfg_s *cfg;
 	u8 *p = data;
 	int i, si;
@@ -231,24 +232,35 @@ static void aq_ethtool_get_strings(struct net_device *ndev,
 	int sa;
 #endif
 
-	cfg = aq_nic_get_cfg(aq_nic);
+	cfg = aq_nic_get_cfg(nic);
 
 	switch (stringset) {
-	case ETH_SS_STATS:
+	case ETH_SS_STATS: {
+		const int stat_cnt = ARRAY_SIZE(aq_ethtool_queue_stat_names);
+		char tc_string[8];
+		int tc;
+
+		memset(tc_string, 0, sizeof(tc_string));
 		memcpy(p, aq_ethtool_stat_names,
 		       sizeof(aq_ethtool_stat_names));
 		p = p + sizeof(aq_ethtool_stat_names);
-		for (i = 0; i < cfg->vecs; i++) {
-			for (si = 0;
-				si < ARRAY_SIZE(aq_ethtool_queue_stat_names);
-				si++) {
-				snprintf(p, ETH_GSTRING_LEN,
-					 aq_ethtool_queue_stat_names[si], i);
-				p += ETH_GSTRING_LEN;
+
+		for (tc = 0; tc < cfg->tcs; tc++) {
+			if (cfg->is_qos)
+				snprintf(tc_string, 8, "TC%d ", tc);
+
+			for (i = 0; i < cfg->vecs; i++) {
+				for (si = 0; si < stat_cnt; si++) {
+					snprintf(p, ETH_GSTRING_LEN,
+					     aq_ethtool_queue_stat_names[si],
+					     tc_string,
+					     AQ_NIC_TCVEC2RING(nic, tc, i));
+					p += ETH_GSTRING_LEN;
+				}
 			}
 		}
 #if IS_ENABLED(CONFIG_MACSEC)
-		if (!aq_nic->macsec_cfg)
+		if (!nic->macsec_cfg)
 			break;
 
 		memcpy(p, aq_macsec_stat_names, sizeof(aq_macsec_stat_names));
@@ -256,7 +268,7 @@ static void aq_ethtool_get_strings(struct net_device *ndev,
 		for (i = 0; i < AQ_MACSEC_MAX_SC; i++) {
 			struct aq_macsec_txsc *aq_txsc;
 
-			if (!(test_bit(i, &aq_nic->macsec_cfg->txsc_idx_busy)))
+			if (!(test_bit(i, &nic->macsec_cfg->txsc_idx_busy)))
 				continue;
 
 			for (si = 0;
@@ -266,7 +278,7 @@ static void aq_ethtool_get_strings(struct net_device *ndev,
 					 aq_macsec_txsc_stat_names[si], i);
 				p += ETH_GSTRING_LEN;
 			}
-			aq_txsc = &aq_nic->macsec_cfg->aq_txsc[i];
+			aq_txsc = &nic->macsec_cfg->aq_txsc[i];
 			for (sa = 0; sa < MACSEC_NUM_AN; sa++) {
 				if (!(test_bit(sa, &aq_txsc->tx_sa_idx_busy)))
 					continue;
@@ -283,10 +295,10 @@ static void aq_ethtool_get_strings(struct net_device *ndev,
 		for (i = 0; i < AQ_MACSEC_MAX_SC; i++) {
 			struct aq_macsec_rxsc *aq_rxsc;
 
-			if (!(test_bit(i, &aq_nic->macsec_cfg->rxsc_idx_busy)))
+			if (!(test_bit(i, &nic->macsec_cfg->rxsc_idx_busy)))
 				continue;
 
-			aq_rxsc = &aq_nic->macsec_cfg->aq_rxsc[i];
+			aq_rxsc = &nic->macsec_cfg->aq_rxsc[i];
 			for (sa = 0; sa < MACSEC_NUM_AN; sa++) {
 				if (!(test_bit(sa, &aq_rxsc->rx_sa_idx_busy)))
 					continue;
@@ -302,6 +314,7 @@ static void aq_ethtool_get_strings(struct net_device *ndev,
 		}
 #endif
 		break;
+	}
 	case ETH_SS_PRIV_FLAGS:
 		memcpy(p, aq_ethtool_priv_flag_names,
 		       sizeof(aq_ethtool_priv_flag_names));
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
index c7e3d39fad19..88021baf65fb 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
@@ -859,6 +859,7 @@ u64 *aq_nic_get_stats(struct aq_nic_s *self, u64 *data)
 	struct aq_stats_s *stats;
 	unsigned int count = 0U;
 	unsigned int i = 0U;
+	unsigned int tc;
 
 	if (self->aq_fw_ops->update_stats) {
 		mutex_lock(&self->fwreq_mutex);
@@ -897,10 +898,13 @@ u64 *aq_nic_get_stats(struct aq_nic_s *self, u64 *data)
 
 	data += i;
 
-	for (i = 0U, aq_vec = self->aq_vec[0];
-		aq_vec && self->aq_vecs > i; ++i, aq_vec = self->aq_vec[i]) {
-		data += count;
-		aq_vec_get_sw_stats(aq_vec, data, &count);
+	for (tc = 0U; tc < self->aq_nic_cfg.tcs; tc++) {
+		for (i = 0U, aq_vec = self->aq_vec[0];
+		     aq_vec && self->aq_vecs > i;
+		     ++i, aq_vec = self->aq_vec[i]) {
+			data += count;
+			aq_vec_get_sw_stats(aq_vec, tc, data, &count);
+		}
 	}
 
 	data += count;
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_vec.c b/drivers/net/ethernet/aquantia/atlantic/aq_vec.c
index d5650cd6e236..41826c10700f 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_vec.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_vec.c
@@ -348,16 +348,14 @@ cpumask_t *aq_vec_get_affinity_mask(struct aq_vec_s *self)
 	return &self->aq_ring_param.affinity_mask;
 }
 
-void aq_vec_add_stats(struct aq_vec_s *self,
-		      struct aq_ring_stats_rx_s *stats_rx,
-		      struct aq_ring_stats_tx_s *stats_tx)
+static void aq_vec_add_stats(struct aq_vec_s *self,
+			     const unsigned int tc,
+			     struct aq_ring_stats_rx_s *stats_rx,
+			     struct aq_ring_stats_tx_s *stats_tx)
 {
-	struct aq_ring_s *ring = NULL;
-	unsigned int r = 0U;
+	struct aq_ring_s *ring = self->ring[tc];
 
-	for (r = 0U, ring = self->ring[0];
-		self->tx_rings > r; ++r, ring = self->ring[r]) {
-		struct aq_ring_stats_tx_s *tx = &ring[AQ_VEC_TX_ID].stats.tx;
+	if (tc < self->rx_rings) {
 		struct aq_ring_stats_rx_s *rx = &ring[AQ_VEC_RX_ID].stats.rx;
 
 		stats_rx->packets += rx->packets;
@@ -368,6 +366,10 @@ void aq_vec_add_stats(struct aq_vec_s *self,
 		stats_rx->pg_losts += rx->pg_losts;
 		stats_rx->pg_flips += rx->pg_flips;
 		stats_rx->pg_reuses += rx->pg_reuses;
+	}
+
+	if (tc < self->tx_rings) {
+		struct aq_ring_stats_tx_s *tx = &ring[AQ_VEC_TX_ID].stats.tx;
 
 		stats_tx->packets += tx->packets;
 		stats_tx->bytes += tx->bytes;
@@ -376,7 +378,8 @@ void aq_vec_add_stats(struct aq_vec_s *self,
 	}
 }
 
-int aq_vec_get_sw_stats(struct aq_vec_s *self, u64 *data, unsigned int *p_count)
+int aq_vec_get_sw_stats(struct aq_vec_s *self, const unsigned int tc, u64 *data,
+			unsigned int *p_count)
 {
 	struct aq_ring_stats_rx_s stats_rx;
 	struct aq_ring_stats_tx_s stats_tx;
@@ -384,7 +387,8 @@ int aq_vec_get_sw_stats(struct aq_vec_s *self, u64 *data, unsigned int *p_count)
 
 	memset(&stats_rx, 0U, sizeof(struct aq_ring_stats_rx_s));
 	memset(&stats_tx, 0U, sizeof(struct aq_ring_stats_tx_s));
-	aq_vec_add_stats(self, &stats_rx, &stats_tx);
+
+	aq_vec_add_stats(self, tc, &stats_rx, &stats_tx);
 
 	/* This data should mimic aq_ethtool_queue_stat_names structure
 	 */
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_vec.h b/drivers/net/ethernet/aquantia/atlantic/aq_vec.h
index 0ee86b26df8a..541af85e6510 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_vec.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_vec.h
@@ -35,10 +35,7 @@ void aq_vec_ring_free(struct aq_vec_s *self);
 int aq_vec_start(struct aq_vec_s *self);
 void aq_vec_stop(struct aq_vec_s *self);
 cpumask_t *aq_vec_get_affinity_mask(struct aq_vec_s *self);
-int aq_vec_get_sw_stats(struct aq_vec_s *self, u64 *data,
+int aq_vec_get_sw_stats(struct aq_vec_s *self, const unsigned int tc, u64 *data,
 			unsigned int *p_count);
-void aq_vec_add_stats(struct aq_vec_s *self,
-		      struct aq_ring_stats_rx_s *stats_rx,
-		      struct aq_ring_stats_tx_s *stats_tx);
 
 #endif /* AQ_VEC_H */
-- 
2.25.1

