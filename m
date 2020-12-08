Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9223E2D3383
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 21:27:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728758AbgLHUUO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 15:20:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:36118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727536AbgLHUUJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Dec 2020 15:20:09 -0500
From:   saeed@kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Eran Ben Elisha <eranbe@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next V3 06/15] net/mlx5e: Split SW group counters update function
Date:   Tue,  8 Dec 2020 11:35:46 -0800
Message-Id: <20201208193555.674504-7-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201208193555.674504-1-saeed@kernel.org>
References: <20201208193555.674504-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eran Ben Elisha <eranbe@nvidia.com>

SW group counter update function aggregates sw stats out of many
mlx5e_*_stats resides in a given mlx5e_channel_stats struct.
Split the function into a few helper functions.

This will be used later in the series to calculate specific
mlx5e_*_stats which are not defined inside mlx5e_channel_stats.

Signed-off-by: Eran Ben Elisha <eranbe@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en_stats.c    | 288 ++++++++++--------
 1 file changed, 161 insertions(+), 127 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
index 78f6a6f0a7e0..ebfb47a09128 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
@@ -248,6 +248,160 @@ static MLX5E_DECLARE_STATS_GRP_OP_FILL_STATS(sw)
 	return idx;
 }
 
+static void mlx5e_stats_grp_sw_update_stats_xdp_red(struct mlx5e_sw_stats *s,
+						    struct mlx5e_xdpsq_stats *xdpsq_red_stats)
+{
+	s->tx_xdp_xmit  += xdpsq_red_stats->xmit;
+	s->tx_xdp_mpwqe += xdpsq_red_stats->mpwqe;
+	s->tx_xdp_inlnw += xdpsq_red_stats->inlnw;
+	s->tx_xdp_nops  += xdpsq_red_stats->nops;
+	s->tx_xdp_full  += xdpsq_red_stats->full;
+	s->tx_xdp_err   += xdpsq_red_stats->err;
+	s->tx_xdp_cqes  += xdpsq_red_stats->cqes;
+}
+
+static void mlx5e_stats_grp_sw_update_stats_xdpsq(struct mlx5e_sw_stats *s,
+						  struct mlx5e_xdpsq_stats *xdpsq_stats)
+{
+	s->rx_xdp_tx_xmit  += xdpsq_stats->xmit;
+	s->rx_xdp_tx_mpwqe += xdpsq_stats->mpwqe;
+	s->rx_xdp_tx_inlnw += xdpsq_stats->inlnw;
+	s->rx_xdp_tx_nops  += xdpsq_stats->nops;
+	s->rx_xdp_tx_full  += xdpsq_stats->full;
+	s->rx_xdp_tx_err   += xdpsq_stats->err;
+	s->rx_xdp_tx_cqe   += xdpsq_stats->cqes;
+}
+
+static void mlx5e_stats_grp_sw_update_stats_xsksq(struct mlx5e_sw_stats *s,
+						  struct mlx5e_xdpsq_stats *xsksq_stats)
+{
+	s->tx_xsk_xmit  += xsksq_stats->xmit;
+	s->tx_xsk_mpwqe += xsksq_stats->mpwqe;
+	s->tx_xsk_inlnw += xsksq_stats->inlnw;
+	s->tx_xsk_full  += xsksq_stats->full;
+	s->tx_xsk_err   += xsksq_stats->err;
+	s->tx_xsk_cqes  += xsksq_stats->cqes;
+}
+
+static void mlx5e_stats_grp_sw_update_stats_xskrq(struct mlx5e_sw_stats *s,
+						  struct mlx5e_rq_stats *xskrq_stats)
+{
+	s->rx_xsk_packets                += xskrq_stats->packets;
+	s->rx_xsk_bytes                  += xskrq_stats->bytes;
+	s->rx_xsk_csum_complete          += xskrq_stats->csum_complete;
+	s->rx_xsk_csum_unnecessary       += xskrq_stats->csum_unnecessary;
+	s->rx_xsk_csum_unnecessary_inner += xskrq_stats->csum_unnecessary_inner;
+	s->rx_xsk_csum_none              += xskrq_stats->csum_none;
+	s->rx_xsk_ecn_mark               += xskrq_stats->ecn_mark;
+	s->rx_xsk_removed_vlan_packets   += xskrq_stats->removed_vlan_packets;
+	s->rx_xsk_xdp_drop               += xskrq_stats->xdp_drop;
+	s->rx_xsk_xdp_redirect           += xskrq_stats->xdp_redirect;
+	s->rx_xsk_wqe_err                += xskrq_stats->wqe_err;
+	s->rx_xsk_mpwqe_filler_cqes      += xskrq_stats->mpwqe_filler_cqes;
+	s->rx_xsk_mpwqe_filler_strides   += xskrq_stats->mpwqe_filler_strides;
+	s->rx_xsk_oversize_pkts_sw_drop  += xskrq_stats->oversize_pkts_sw_drop;
+	s->rx_xsk_buff_alloc_err         += xskrq_stats->buff_alloc_err;
+	s->rx_xsk_cqe_compress_blks      += xskrq_stats->cqe_compress_blks;
+	s->rx_xsk_cqe_compress_pkts      += xskrq_stats->cqe_compress_pkts;
+	s->rx_xsk_congst_umr             += xskrq_stats->congst_umr;
+	s->rx_xsk_arfs_err               += xskrq_stats->arfs_err;
+}
+
+static void mlx5e_stats_grp_sw_update_stats_rq_stats(struct mlx5e_sw_stats *s,
+						     struct mlx5e_rq_stats *rq_stats)
+{
+	s->rx_packets                 += rq_stats->packets;
+	s->rx_bytes                   += rq_stats->bytes;
+	s->rx_lro_packets             += rq_stats->lro_packets;
+	s->rx_lro_bytes               += rq_stats->lro_bytes;
+	s->rx_ecn_mark                += rq_stats->ecn_mark;
+	s->rx_removed_vlan_packets    += rq_stats->removed_vlan_packets;
+	s->rx_csum_none               += rq_stats->csum_none;
+	s->rx_csum_complete           += rq_stats->csum_complete;
+	s->rx_csum_complete_tail      += rq_stats->csum_complete_tail;
+	s->rx_csum_complete_tail_slow += rq_stats->csum_complete_tail_slow;
+	s->rx_csum_unnecessary        += rq_stats->csum_unnecessary;
+	s->rx_csum_unnecessary_inner  += rq_stats->csum_unnecessary_inner;
+	s->rx_xdp_drop                += rq_stats->xdp_drop;
+	s->rx_xdp_redirect            += rq_stats->xdp_redirect;
+	s->rx_wqe_err                 += rq_stats->wqe_err;
+	s->rx_mpwqe_filler_cqes       += rq_stats->mpwqe_filler_cqes;
+	s->rx_mpwqe_filler_strides    += rq_stats->mpwqe_filler_strides;
+	s->rx_oversize_pkts_sw_drop   += rq_stats->oversize_pkts_sw_drop;
+	s->rx_buff_alloc_err          += rq_stats->buff_alloc_err;
+	s->rx_cqe_compress_blks       += rq_stats->cqe_compress_blks;
+	s->rx_cqe_compress_pkts       += rq_stats->cqe_compress_pkts;
+	s->rx_cache_reuse             += rq_stats->cache_reuse;
+	s->rx_cache_full              += rq_stats->cache_full;
+	s->rx_cache_empty             += rq_stats->cache_empty;
+	s->rx_cache_busy              += rq_stats->cache_busy;
+	s->rx_cache_waive             += rq_stats->cache_waive;
+	s->rx_congst_umr              += rq_stats->congst_umr;
+	s->rx_arfs_err                += rq_stats->arfs_err;
+	s->rx_recover                 += rq_stats->recover;
+#ifdef CONFIG_MLX5_EN_TLS
+	s->rx_tls_decrypted_packets   += rq_stats->tls_decrypted_packets;
+	s->rx_tls_decrypted_bytes     += rq_stats->tls_decrypted_bytes;
+	s->rx_tls_ctx                 += rq_stats->tls_ctx;
+	s->rx_tls_del                 += rq_stats->tls_del;
+	s->rx_tls_resync_req_pkt      += rq_stats->tls_resync_req_pkt;
+	s->rx_tls_resync_req_start    += rq_stats->tls_resync_req_start;
+	s->rx_tls_resync_req_end      += rq_stats->tls_resync_req_end;
+	s->rx_tls_resync_req_skip     += rq_stats->tls_resync_req_skip;
+	s->rx_tls_resync_res_ok       += rq_stats->tls_resync_res_ok;
+	s->rx_tls_resync_res_skip     += rq_stats->tls_resync_res_skip;
+	s->rx_tls_err                 += rq_stats->tls_err;
+#endif
+}
+
+static void mlx5e_stats_grp_sw_update_stats_ch_stats(struct mlx5e_sw_stats *s,
+						     struct mlx5e_ch_stats *ch_stats)
+{
+	s->ch_events      += ch_stats->events;
+	s->ch_poll        += ch_stats->poll;
+	s->ch_arm         += ch_stats->arm;
+	s->ch_aff_change  += ch_stats->aff_change;
+	s->ch_force_irq   += ch_stats->force_irq;
+	s->ch_eq_rearm    += ch_stats->eq_rearm;
+}
+
+static void mlx5e_stats_grp_sw_update_stats_sq(struct mlx5e_sw_stats *s,
+					       struct mlx5e_sq_stats *sq_stats)
+{
+	s->tx_packets               += sq_stats->packets;
+	s->tx_bytes                 += sq_stats->bytes;
+	s->tx_tso_packets           += sq_stats->tso_packets;
+	s->tx_tso_bytes             += sq_stats->tso_bytes;
+	s->tx_tso_inner_packets     += sq_stats->tso_inner_packets;
+	s->tx_tso_inner_bytes       += sq_stats->tso_inner_bytes;
+	s->tx_added_vlan_packets    += sq_stats->added_vlan_packets;
+	s->tx_nop                   += sq_stats->nop;
+	s->tx_mpwqe_blks            += sq_stats->mpwqe_blks;
+	s->tx_mpwqe_pkts            += sq_stats->mpwqe_pkts;
+	s->tx_queue_stopped         += sq_stats->stopped;
+	s->tx_queue_wake            += sq_stats->wake;
+	s->tx_queue_dropped         += sq_stats->dropped;
+	s->tx_cqe_err               += sq_stats->cqe_err;
+	s->tx_recover               += sq_stats->recover;
+	s->tx_xmit_more             += sq_stats->xmit_more;
+	s->tx_csum_partial_inner    += sq_stats->csum_partial_inner;
+	s->tx_csum_none             += sq_stats->csum_none;
+	s->tx_csum_partial          += sq_stats->csum_partial;
+#ifdef CONFIG_MLX5_EN_TLS
+	s->tx_tls_encrypted_packets += sq_stats->tls_encrypted_packets;
+	s->tx_tls_encrypted_bytes   += sq_stats->tls_encrypted_bytes;
+	s->tx_tls_ctx               += sq_stats->tls_ctx;
+	s->tx_tls_ooo               += sq_stats->tls_ooo;
+	s->tx_tls_dump_bytes        += sq_stats->tls_dump_bytes;
+	s->tx_tls_dump_packets      += sq_stats->tls_dump_packets;
+	s->tx_tls_resync_bytes      += sq_stats->tls_resync_bytes;
+	s->tx_tls_skip_no_sync_data += sq_stats->tls_skip_no_sync_data;
+	s->tx_tls_drop_no_sync_data += sq_stats->tls_drop_no_sync_data;
+	s->tx_tls_drop_bypass_req   += sq_stats->tls_drop_bypass_req;
+#endif
+	s->tx_cqes                  += sq_stats->cqes;
+}
+
 static MLX5E_DECLARE_STATS_GRP_OP_UPDATE_STATS(sw)
 {
 	struct mlx5e_sw_stats *s = &priv->stats.sw;
@@ -258,139 +412,19 @@ static MLX5E_DECLARE_STATS_GRP_OP_UPDATE_STATS(sw)
 	for (i = 0; i < priv->max_nch; i++) {
 		struct mlx5e_channel_stats *channel_stats =
 			&priv->channel_stats[i];
-		struct mlx5e_xdpsq_stats *xdpsq_red_stats = &channel_stats->xdpsq;
-		struct mlx5e_xdpsq_stats *xdpsq_stats = &channel_stats->rq_xdpsq;
-		struct mlx5e_xdpsq_stats *xsksq_stats = &channel_stats->xsksq;
-		struct mlx5e_rq_stats *xskrq_stats = &channel_stats->xskrq;
-		struct mlx5e_rq_stats *rq_stats = &channel_stats->rq;
-		struct mlx5e_ch_stats *ch_stats = &channel_stats->ch;
 		int j;
 
-		s->rx_packets	+= rq_stats->packets;
-		s->rx_bytes	+= rq_stats->bytes;
-		s->rx_lro_packets += rq_stats->lro_packets;
-		s->rx_lro_bytes	+= rq_stats->lro_bytes;
-		s->rx_ecn_mark	+= rq_stats->ecn_mark;
-		s->rx_removed_vlan_packets += rq_stats->removed_vlan_packets;
-		s->rx_csum_none	+= rq_stats->csum_none;
-		s->rx_csum_complete += rq_stats->csum_complete;
-		s->rx_csum_complete_tail += rq_stats->csum_complete_tail;
-		s->rx_csum_complete_tail_slow += rq_stats->csum_complete_tail_slow;
-		s->rx_csum_unnecessary += rq_stats->csum_unnecessary;
-		s->rx_csum_unnecessary_inner += rq_stats->csum_unnecessary_inner;
-		s->rx_xdp_drop     += rq_stats->xdp_drop;
-		s->rx_xdp_redirect += rq_stats->xdp_redirect;
-		s->rx_xdp_tx_xmit  += xdpsq_stats->xmit;
-		s->rx_xdp_tx_mpwqe += xdpsq_stats->mpwqe;
-		s->rx_xdp_tx_inlnw += xdpsq_stats->inlnw;
-		s->rx_xdp_tx_nops  += xdpsq_stats->nops;
-		s->rx_xdp_tx_full  += xdpsq_stats->full;
-		s->rx_xdp_tx_err   += xdpsq_stats->err;
-		s->rx_xdp_tx_cqe   += xdpsq_stats->cqes;
-		s->rx_wqe_err   += rq_stats->wqe_err;
-		s->rx_mpwqe_filler_cqes    += rq_stats->mpwqe_filler_cqes;
-		s->rx_mpwqe_filler_strides += rq_stats->mpwqe_filler_strides;
-		s->rx_oversize_pkts_sw_drop += rq_stats->oversize_pkts_sw_drop;
-		s->rx_buff_alloc_err += rq_stats->buff_alloc_err;
-		s->rx_cqe_compress_blks += rq_stats->cqe_compress_blks;
-		s->rx_cqe_compress_pkts += rq_stats->cqe_compress_pkts;
-		s->rx_cache_reuse += rq_stats->cache_reuse;
-		s->rx_cache_full  += rq_stats->cache_full;
-		s->rx_cache_empty += rq_stats->cache_empty;
-		s->rx_cache_busy  += rq_stats->cache_busy;
-		s->rx_cache_waive += rq_stats->cache_waive;
-		s->rx_congst_umr  += rq_stats->congst_umr;
-		s->rx_arfs_err    += rq_stats->arfs_err;
-		s->rx_recover     += rq_stats->recover;
-#ifdef CONFIG_MLX5_EN_TLS
-		s->rx_tls_decrypted_packets += rq_stats->tls_decrypted_packets;
-		s->rx_tls_decrypted_bytes   += rq_stats->tls_decrypted_bytes;
-		s->rx_tls_ctx               += rq_stats->tls_ctx;
-		s->rx_tls_del               += rq_stats->tls_del;
-		s->rx_tls_resync_req_pkt    += rq_stats->tls_resync_req_pkt;
-		s->rx_tls_resync_req_start  += rq_stats->tls_resync_req_start;
-		s->rx_tls_resync_req_end    += rq_stats->tls_resync_req_end;
-		s->rx_tls_resync_req_skip   += rq_stats->tls_resync_req_skip;
-		s->rx_tls_resync_res_ok     += rq_stats->tls_resync_res_ok;
-		s->rx_tls_resync_res_skip   += rq_stats->tls_resync_res_skip;
-		s->rx_tls_err               += rq_stats->tls_err;
-#endif
-		s->ch_events      += ch_stats->events;
-		s->ch_poll        += ch_stats->poll;
-		s->ch_arm         += ch_stats->arm;
-		s->ch_aff_change  += ch_stats->aff_change;
-		s->ch_force_irq   += ch_stats->force_irq;
-		s->ch_eq_rearm    += ch_stats->eq_rearm;
+		mlx5e_stats_grp_sw_update_stats_rq_stats(s, &channel_stats->rq);
+		mlx5e_stats_grp_sw_update_stats_xdpsq(s, &channel_stats->rq_xdpsq);
+		mlx5e_stats_grp_sw_update_stats_ch_stats(s, &channel_stats->ch);
 		/* xdp redirect */
-		s->tx_xdp_xmit    += xdpsq_red_stats->xmit;
-		s->tx_xdp_mpwqe   += xdpsq_red_stats->mpwqe;
-		s->tx_xdp_inlnw   += xdpsq_red_stats->inlnw;
-		s->tx_xdp_nops	  += xdpsq_red_stats->nops;
-		s->tx_xdp_full    += xdpsq_red_stats->full;
-		s->tx_xdp_err     += xdpsq_red_stats->err;
-		s->tx_xdp_cqes    += xdpsq_red_stats->cqes;
+		mlx5e_stats_grp_sw_update_stats_xdp_red(s, &channel_stats->xdpsq);
 		/* AF_XDP zero-copy */
-		s->rx_xsk_packets                += xskrq_stats->packets;
-		s->rx_xsk_bytes                  += xskrq_stats->bytes;
-		s->rx_xsk_csum_complete          += xskrq_stats->csum_complete;
-		s->rx_xsk_csum_unnecessary       += xskrq_stats->csum_unnecessary;
-		s->rx_xsk_csum_unnecessary_inner += xskrq_stats->csum_unnecessary_inner;
-		s->rx_xsk_csum_none              += xskrq_stats->csum_none;
-		s->rx_xsk_ecn_mark               += xskrq_stats->ecn_mark;
-		s->rx_xsk_removed_vlan_packets   += xskrq_stats->removed_vlan_packets;
-		s->rx_xsk_xdp_drop               += xskrq_stats->xdp_drop;
-		s->rx_xsk_xdp_redirect           += xskrq_stats->xdp_redirect;
-		s->rx_xsk_wqe_err                += xskrq_stats->wqe_err;
-		s->rx_xsk_mpwqe_filler_cqes      += xskrq_stats->mpwqe_filler_cqes;
-		s->rx_xsk_mpwqe_filler_strides   += xskrq_stats->mpwqe_filler_strides;
-		s->rx_xsk_oversize_pkts_sw_drop  += xskrq_stats->oversize_pkts_sw_drop;
-		s->rx_xsk_buff_alloc_err         += xskrq_stats->buff_alloc_err;
-		s->rx_xsk_cqe_compress_blks      += xskrq_stats->cqe_compress_blks;
-		s->rx_xsk_cqe_compress_pkts      += xskrq_stats->cqe_compress_pkts;
-		s->rx_xsk_congst_umr             += xskrq_stats->congst_umr;
-		s->rx_xsk_arfs_err               += xskrq_stats->arfs_err;
-		s->tx_xsk_xmit                   += xsksq_stats->xmit;
-		s->tx_xsk_mpwqe                  += xsksq_stats->mpwqe;
-		s->tx_xsk_inlnw                  += xsksq_stats->inlnw;
-		s->tx_xsk_full                   += xsksq_stats->full;
-		s->tx_xsk_err                    += xsksq_stats->err;
-		s->tx_xsk_cqes                   += xsksq_stats->cqes;
+		mlx5e_stats_grp_sw_update_stats_xskrq(s, &channel_stats->xskrq);
+		mlx5e_stats_grp_sw_update_stats_xsksq(s, &channel_stats->xsksq);
 
 		for (j = 0; j < priv->max_opened_tc; j++) {
-			struct mlx5e_sq_stats *sq_stats = &channel_stats->sq[j];
-
-			s->tx_packets		+= sq_stats->packets;
-			s->tx_bytes		+= sq_stats->bytes;
-			s->tx_tso_packets	+= sq_stats->tso_packets;
-			s->tx_tso_bytes		+= sq_stats->tso_bytes;
-			s->tx_tso_inner_packets	+= sq_stats->tso_inner_packets;
-			s->tx_tso_inner_bytes	+= sq_stats->tso_inner_bytes;
-			s->tx_added_vlan_packets += sq_stats->added_vlan_packets;
-			s->tx_nop               += sq_stats->nop;
-			s->tx_mpwqe_blks        += sq_stats->mpwqe_blks;
-			s->tx_mpwqe_pkts        += sq_stats->mpwqe_pkts;
-			s->tx_queue_stopped	+= sq_stats->stopped;
-			s->tx_queue_wake	+= sq_stats->wake;
-			s->tx_queue_dropped	+= sq_stats->dropped;
-			s->tx_cqe_err		+= sq_stats->cqe_err;
-			s->tx_recover		+= sq_stats->recover;
-			s->tx_xmit_more		+= sq_stats->xmit_more;
-			s->tx_csum_partial_inner += sq_stats->csum_partial_inner;
-			s->tx_csum_none		+= sq_stats->csum_none;
-			s->tx_csum_partial	+= sq_stats->csum_partial;
-#ifdef CONFIG_MLX5_EN_TLS
-			s->tx_tls_encrypted_packets += sq_stats->tls_encrypted_packets;
-			s->tx_tls_encrypted_bytes   += sq_stats->tls_encrypted_bytes;
-			s->tx_tls_ctx               += sq_stats->tls_ctx;
-			s->tx_tls_ooo               += sq_stats->tls_ooo;
-			s->tx_tls_dump_bytes        += sq_stats->tls_dump_bytes;
-			s->tx_tls_dump_packets      += sq_stats->tls_dump_packets;
-			s->tx_tls_resync_bytes      += sq_stats->tls_resync_bytes;
-			s->tx_tls_skip_no_sync_data += sq_stats->tls_skip_no_sync_data;
-			s->tx_tls_drop_no_sync_data += sq_stats->tls_drop_no_sync_data;
-			s->tx_tls_drop_bypass_req   += sq_stats->tls_drop_bypass_req;
-#endif
-			s->tx_cqes		+= sq_stats->cqes;
+			mlx5e_stats_grp_sw_update_stats_sq(s, &channel_stats->sq[j]);
 
 			/* https://gcc.gnu.org/bugzilla/show_bug.cgi?id=92657 */
 			barrier();
-- 
2.26.2

