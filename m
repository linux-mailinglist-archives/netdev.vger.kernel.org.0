Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1EAB34E022
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 06:28:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230411AbhC3E2F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 00:28:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:49684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230223AbhC3E1q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Mar 2021 00:27:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AFF8F6198F;
        Tue, 30 Mar 2021 04:27:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617078466;
        bh=0lBh5/1df5CvV1NdypHOaFeWId6AWf1kZdr89AnBTYE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FaXDsvCOMIUJAbM1EiYKB37tuCDdi8dL7Q42/mfGafTnR91f+3LBO/ubA3FjK1ji2
         05D8VylOZFf5xu9a8VxcpWX+STNl4cwbNP1G+lnGmTxe6E9soihl5R8BFQ5NMxAopf
         njmbIQXjdT1eDJeqUVTyP315Vkoa3aQ4U2bOcSVeamG2/rXOpJf1/WXalpKQCE7mYK
         /cNyUB0Q5+0isEjDBME02wawtr7hzvrTSE75TnOSAbt4uPdm1YRwTs24qh4W63Ns2/
         o1GTtE4O1sw+rJqOMP8QI5BFX6mGLQV0fjnde0MxIuc+ANpyS35t4iSRyH52r/ms2W
         XH4bSoUdN3ISQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Aya Levin <ayal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 03/12] net/mlx5e: Add PTP-RX statistics
Date:   Mon, 29 Mar 2021 21:27:32 -0700
Message-Id: <20210330042741.198601-4-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210330042741.198601-1-saeed@kernel.org>
References: <20210330042741.198601-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

Like PTP-TX, once the PTP-RX is opened, corresponding statistics appear.
Add indication that PTP-RX was ever opened: rx_ptp_opened. If any of the
PTP RX or TX were opened, display the PTP channel's statistics.

Signed-off-by: Aya Levin <ayal@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |   1 +
 .../net/ethernet/mellanox/mlx5/core/en/ptp.c  |   3 +
 .../net/ethernet/mellanox/mlx5/core/en_main.c |   7 ++
 .../ethernet/mellanox/mlx5/core/en_stats.c    | 114 ++++++++++++++----
 .../ethernet/mellanox/mlx5/core/en_stats.h    |   1 +
 5 files changed, 100 insertions(+), 26 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 33db35980970..8f6ccd54057a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -860,6 +860,7 @@ struct mlx5e_priv {
 	u16                        max_nch;
 	u8                         max_opened_tc;
 	bool                       tx_ptp_opened;
+	bool                       rx_ptp_opened;
 	struct hwtstamp_config     tstamp;
 	u16                        q_counter;
 	u16                        drop_rq_q_counter;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
index 7f7dfaed9fb4..4595d2388d83 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
@@ -610,6 +610,9 @@ int mlx5e_ptp_open(struct mlx5e_priv *priv, struct mlx5e_params *params,
 	if (unlikely(err))
 		goto err_napi_del;
 
+	if (test_bit(MLX5E_PTP_STATE_RX, c->state))
+		priv->rx_ptp_opened = true;
+
 	*cp = c;
 
 	kvfree(cparams);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 458dd079ca89..7ecde284c57c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3496,6 +3496,13 @@ void mlx5e_fold_sw_stats64(struct mlx5e_priv *priv, struct rtnl_link_stats64 *s)
 			s->tx_dropped    += sq_stats->dropped;
 		}
 	}
+	if (priv->rx_ptp_opened) {
+		struct mlx5e_rq_stats *rq_stats = &priv->ptp_stats.rq;
+
+		s->rx_packets   += rq_stats->packets;
+		s->rx_bytes     += rq_stats->bytes;
+		s->multicast    += rq_stats->mcast_packets;
+	}
 }
 
 void
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
index 32331ac9288c..f67e51d8291a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
@@ -407,13 +407,21 @@ static void mlx5e_stats_grp_sw_update_stats_ptp(struct mlx5e_priv *priv,
 {
 	int i;
 
-	if (!priv->tx_ptp_opened)
+	if (!priv->tx_ptp_opened && !priv->rx_ptp_opened)
 		return;
 
 	mlx5e_stats_grp_sw_update_stats_ch_stats(s, &priv->ptp_stats.ch);
 
-	for (i = 0; i < priv->max_opened_tc; i++) {
-		mlx5e_stats_grp_sw_update_stats_sq(s, &priv->ptp_stats.sq[i]);
+	if (priv->tx_ptp_opened) {
+		for (i = 0; i < priv->max_opened_tc; i++) {
+			mlx5e_stats_grp_sw_update_stats_sq(s, &priv->ptp_stats.sq[i]);
+
+			/* https://gcc.gnu.org/bugzilla/show_bug.cgi?id=92657 */
+			barrier();
+		}
+	}
+	if (priv->rx_ptp_opened) {
+		mlx5e_stats_grp_sw_update_stats_rq_stats(s, &priv->ptp_stats.rq);
 
 		/* https://gcc.gnu.org/bugzilla/show_bug.cgi?id=92657 */
 		barrier();
@@ -1760,6 +1768,38 @@ static const struct counter_desc ptp_cq_stats_desc[] = {
 	{ MLX5E_DECLARE_PTP_CQ_STAT(struct mlx5e_ptp_cq_stats, abort_abs_diff_ns) },
 };
 
+static const struct counter_desc ptp_rq_stats_desc[] = {
+	{ MLX5E_DECLARE_PTP_RQ_STAT(struct mlx5e_rq_stats, packets) },
+	{ MLX5E_DECLARE_PTP_RQ_STAT(struct mlx5e_rq_stats, bytes) },
+	{ MLX5E_DECLARE_PTP_RQ_STAT(struct mlx5e_rq_stats, csum_complete) },
+	{ MLX5E_DECLARE_PTP_RQ_STAT(struct mlx5e_rq_stats, csum_complete_tail) },
+	{ MLX5E_DECLARE_PTP_RQ_STAT(struct mlx5e_rq_stats, csum_complete_tail_slow) },
+	{ MLX5E_DECLARE_PTP_RQ_STAT(struct mlx5e_rq_stats, csum_unnecessary) },
+	{ MLX5E_DECLARE_PTP_RQ_STAT(struct mlx5e_rq_stats, csum_unnecessary_inner) },
+	{ MLX5E_DECLARE_PTP_RQ_STAT(struct mlx5e_rq_stats, csum_none) },
+	{ MLX5E_DECLARE_PTP_RQ_STAT(struct mlx5e_rq_stats, xdp_drop) },
+	{ MLX5E_DECLARE_PTP_RQ_STAT(struct mlx5e_rq_stats, xdp_redirect) },
+	{ MLX5E_DECLARE_PTP_RQ_STAT(struct mlx5e_rq_stats, lro_packets) },
+	{ MLX5E_DECLARE_PTP_RQ_STAT(struct mlx5e_rq_stats, lro_bytes) },
+	{ MLX5E_DECLARE_PTP_RQ_STAT(struct mlx5e_rq_stats, ecn_mark) },
+	{ MLX5E_DECLARE_PTP_RQ_STAT(struct mlx5e_rq_stats, removed_vlan_packets) },
+	{ MLX5E_DECLARE_PTP_RQ_STAT(struct mlx5e_rq_stats, wqe_err) },
+	{ MLX5E_DECLARE_PTP_RQ_STAT(struct mlx5e_rq_stats, mpwqe_filler_cqes) },
+	{ MLX5E_DECLARE_PTP_RQ_STAT(struct mlx5e_rq_stats, mpwqe_filler_strides) },
+	{ MLX5E_DECLARE_PTP_RQ_STAT(struct mlx5e_rq_stats, oversize_pkts_sw_drop) },
+	{ MLX5E_DECLARE_PTP_RQ_STAT(struct mlx5e_rq_stats, buff_alloc_err) },
+	{ MLX5E_DECLARE_PTP_RQ_STAT(struct mlx5e_rq_stats, cqe_compress_blks) },
+	{ MLX5E_DECLARE_PTP_RQ_STAT(struct mlx5e_rq_stats, cqe_compress_pkts) },
+	{ MLX5E_DECLARE_PTP_RQ_STAT(struct mlx5e_rq_stats, cache_reuse) },
+	{ MLX5E_DECLARE_PTP_RQ_STAT(struct mlx5e_rq_stats, cache_full) },
+	{ MLX5E_DECLARE_PTP_RQ_STAT(struct mlx5e_rq_stats, cache_empty) },
+	{ MLX5E_DECLARE_PTP_RQ_STAT(struct mlx5e_rq_stats, cache_busy) },
+	{ MLX5E_DECLARE_PTP_RQ_STAT(struct mlx5e_rq_stats, cache_waive) },
+	{ MLX5E_DECLARE_PTP_RQ_STAT(struct mlx5e_rq_stats, congst_umr) },
+	{ MLX5E_DECLARE_PTP_RQ_STAT(struct mlx5e_rq_stats, arfs_err) },
+	{ MLX5E_DECLARE_PTP_RQ_STAT(struct mlx5e_rq_stats, recover) },
+};
+
 static const struct counter_desc qos_sq_stats_desc[] = {
 	{ MLX5E_DECLARE_QOS_TX_STAT(struct mlx5e_sq_stats, packets) },
 	{ MLX5E_DECLARE_QOS_TX_STAT(struct mlx5e_sq_stats, bytes) },
@@ -1805,6 +1845,7 @@ static const struct counter_desc qos_sq_stats_desc[] = {
 #define NUM_PTP_SQ_STATS		ARRAY_SIZE(ptp_sq_stats_desc)
 #define NUM_PTP_CH_STATS		ARRAY_SIZE(ptp_ch_stats_desc)
 #define NUM_PTP_CQ_STATS		ARRAY_SIZE(ptp_cq_stats_desc)
+#define NUM_PTP_RQ_STATS                ARRAY_SIZE(ptp_rq_stats_desc)
 #define NUM_QOS_SQ_STATS		ARRAY_SIZE(qos_sq_stats_desc)
 
 static MLX5E_DECLARE_STATS_GRP_OP_NUM_STATS(qos)
@@ -1851,32 +1892,46 @@ static MLX5E_DECLARE_STATS_GRP_OP_UPDATE_STATS(qos) { return; }
 
 static MLX5E_DECLARE_STATS_GRP_OP_NUM_STATS(ptp)
 {
-	return priv->tx_ptp_opened ?
-	       NUM_PTP_CH_STATS +
-	       ((NUM_PTP_SQ_STATS + NUM_PTP_CQ_STATS) * priv->max_opened_tc) :
-	       0;
+	int num = NUM_PTP_CH_STATS;
+
+	if (!priv->tx_ptp_opened && !priv->rx_ptp_opened)
+		return 0;
+
+	if (priv->tx_ptp_opened)
+		num += (NUM_PTP_SQ_STATS + NUM_PTP_CQ_STATS) * priv->max_opened_tc;
+	if (priv->rx_ptp_opened)
+		num += NUM_PTP_RQ_STATS;
+
+	return num;
 }
 
 static MLX5E_DECLARE_STATS_GRP_OP_FILL_STRS(ptp)
 {
 	int i, tc;
 
-	if (!priv->tx_ptp_opened)
+	if (!priv->tx_ptp_opened && !priv->rx_ptp_opened)
 		return idx;
 
 	for (i = 0; i < NUM_PTP_CH_STATS; i++)
 		sprintf(data + (idx++) * ETH_GSTRING_LEN,
 			ptp_ch_stats_desc[i].format);
 
-	for (tc = 0; tc < priv->max_opened_tc; tc++)
-		for (i = 0; i < NUM_PTP_SQ_STATS; i++)
-			sprintf(data + (idx++) * ETH_GSTRING_LEN,
-				ptp_sq_stats_desc[i].format, tc);
+	if (priv->tx_ptp_opened) {
+		for (tc = 0; tc < priv->max_opened_tc; tc++)
+			for (i = 0; i < NUM_PTP_SQ_STATS; i++)
+				sprintf(data + (idx++) * ETH_GSTRING_LEN,
+					ptp_sq_stats_desc[i].format, tc);
 
-	for (tc = 0; tc < priv->max_opened_tc; tc++)
-		for (i = 0; i < NUM_PTP_CQ_STATS; i++)
+		for (tc = 0; tc < priv->max_opened_tc; tc++)
+			for (i = 0; i < NUM_PTP_CQ_STATS; i++)
+				sprintf(data + (idx++) * ETH_GSTRING_LEN,
+					ptp_cq_stats_desc[i].format, tc);
+	}
+	if (priv->rx_ptp_opened) {
+		for (i = 0; i < NUM_PTP_RQ_STATS; i++)
 			sprintf(data + (idx++) * ETH_GSTRING_LEN,
-				ptp_cq_stats_desc[i].format, tc);
+				ptp_rq_stats_desc[i].format);
+	}
 	return idx;
 }
 
@@ -1884,7 +1939,7 @@ static MLX5E_DECLARE_STATS_GRP_OP_FILL_STATS(ptp)
 {
 	int i, tc;
 
-	if (!priv->tx_ptp_opened)
+	if (!priv->tx_ptp_opened && !priv->rx_ptp_opened)
 		return idx;
 
 	for (i = 0; i < NUM_PTP_CH_STATS; i++)
@@ -1892,18 +1947,25 @@ static MLX5E_DECLARE_STATS_GRP_OP_FILL_STATS(ptp)
 			MLX5E_READ_CTR64_CPU(&priv->ptp_stats.ch,
 					     ptp_ch_stats_desc, i);
 
-	for (tc = 0; tc < priv->max_opened_tc; tc++)
-		for (i = 0; i < NUM_PTP_SQ_STATS; i++)
-			data[idx++] =
-				MLX5E_READ_CTR64_CPU(&priv->ptp_stats.sq[tc],
-						     ptp_sq_stats_desc, i);
+	if (priv->tx_ptp_opened) {
+		for (tc = 0; tc < priv->max_opened_tc; tc++)
+			for (i = 0; i < NUM_PTP_SQ_STATS; i++)
+				data[idx++] =
+					MLX5E_READ_CTR64_CPU(&priv->ptp_stats.sq[tc],
+							     ptp_sq_stats_desc, i);
 
-	for (tc = 0; tc < priv->max_opened_tc; tc++)
-		for (i = 0; i < NUM_PTP_CQ_STATS; i++)
+		for (tc = 0; tc < priv->max_opened_tc; tc++)
+			for (i = 0; i < NUM_PTP_CQ_STATS; i++)
+				data[idx++] =
+					MLX5E_READ_CTR64_CPU(&priv->ptp_stats.cq[tc],
+							     ptp_cq_stats_desc, i);
+	}
+	if (priv->rx_ptp_opened) {
+		for (i = 0; i < NUM_PTP_RQ_STATS; i++)
 			data[idx++] =
-				MLX5E_READ_CTR64_CPU(&priv->ptp_stats.cq[tc],
-						     ptp_cq_stats_desc, i);
-
+				MLX5E_READ_CTR64_CPU(&priv->ptp_stats.rq,
+						     ptp_rq_stats_desc, i);
+	}
 	return idx;
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
index 93c41312fb03..ca398eac09c1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
@@ -54,6 +54,7 @@
 #define MLX5E_DECLARE_PTP_TX_STAT(type, fld) "ptp_tx%d_"#fld, offsetof(type, fld)
 #define MLX5E_DECLARE_PTP_CH_STAT(type, fld) "ptp_ch_"#fld, offsetof(type, fld)
 #define MLX5E_DECLARE_PTP_CQ_STAT(type, fld) "ptp_cq%d_"#fld, offsetof(type, fld)
+#define MLX5E_DECLARE_PTP_RQ_STAT(type, fld) "ptp_rq%d_"#fld, offsetof(type, fld)
 
 #define MLX5E_DECLARE_QOS_TX_STAT(type, fld) "qos_tx%d_"#fld, offsetof(type, fld)
 
-- 
2.30.2

