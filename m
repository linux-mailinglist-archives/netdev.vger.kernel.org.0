Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 381AE2CB05F
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 23:44:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726452AbgLAWnI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 17:43:08 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:5348 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726330AbgLAWnH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 17:43:07 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fc6c6d10000>; Tue, 01 Dec 2020 14:42:25 -0800
Received: from sx1.mtl.com (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 1 Dec
 2020 22:42:24 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        "Eran Ben Elisha" <eranbe@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        "Saeed Mahameed" <saeedm@nvidia.com>
Subject: [net-next 06/15] net/mlx5e: Split SW group counters update function
Date:   Tue, 1 Dec 2020 14:41:59 -0800
Message-ID: <20201201224208.73295-7-saeedm@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201201224208.73295-1-saeedm@nvidia.com>
References: <20201201224208.73295-1-saeedm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1606862545; bh=15O3KnG/MApHQSMQ1YGh0TtCiKK3Jbqi2kSPm61FVys=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=rOhmM2WBtAn3TUX6GQXarLcYL/e8zZTP884lE6DqZ78fjTxT3/goTVnzg7DFpUDrP
         ssXJbbWONZoL8pJF5bu3jcUTau+14pD6EP43qdjY6xv4ILZ3ZRhZQtvT9TTHzQdgyG
         fo+mO3mooopZOuz136M3cpnMz1ba4lZSL3qdJayR4ElqqwMVQ1uT0LzhI1Jt6oG1/x
         MZKlop8BjkXf9qatfPI/lyMFx80DgV3+X/rAnnDC1F5PotAA+Ccv2W0Z7GtOS0RjJp
         Ul+ByKYlZYgdjRvX62DeeAWQHnfWrgPIJypReVqV+m+ITyPBe/q4ecDdR+1rWWA1C7
         vCTS6yPqV7IhQ==
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

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c b/drivers/n=
et/ethernet/mellanox/mlx5/core/en_stats.c
index 78f6a6f0a7e0..ebfb47a09128 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
@@ -248,6 +248,160 @@ static MLX5E_DECLARE_STATS_GRP_OP_FILL_STATS(sw)
 	return idx;
 }
=20
+static void mlx5e_stats_grp_sw_update_stats_xdp_red(struct mlx5e_sw_stats =
*s,
+						    struct mlx5e_xdpsq_stats *xdpsq_red_stats)
+{
+	s->tx_xdp_xmit  +=3D xdpsq_red_stats->xmit;
+	s->tx_xdp_mpwqe +=3D xdpsq_red_stats->mpwqe;
+	s->tx_xdp_inlnw +=3D xdpsq_red_stats->inlnw;
+	s->tx_xdp_nops  +=3D xdpsq_red_stats->nops;
+	s->tx_xdp_full  +=3D xdpsq_red_stats->full;
+	s->tx_xdp_err   +=3D xdpsq_red_stats->err;
+	s->tx_xdp_cqes  +=3D xdpsq_red_stats->cqes;
+}
+
+static void mlx5e_stats_grp_sw_update_stats_xdpsq(struct mlx5e_sw_stats *s=
,
+						  struct mlx5e_xdpsq_stats *xdpsq_stats)
+{
+	s->rx_xdp_tx_xmit  +=3D xdpsq_stats->xmit;
+	s->rx_xdp_tx_mpwqe +=3D xdpsq_stats->mpwqe;
+	s->rx_xdp_tx_inlnw +=3D xdpsq_stats->inlnw;
+	s->rx_xdp_tx_nops  +=3D xdpsq_stats->nops;
+	s->rx_xdp_tx_full  +=3D xdpsq_stats->full;
+	s->rx_xdp_tx_err   +=3D xdpsq_stats->err;
+	s->rx_xdp_tx_cqe   +=3D xdpsq_stats->cqes;
+}
+
+static void mlx5e_stats_grp_sw_update_stats_xsksq(struct mlx5e_sw_stats *s=
,
+						  struct mlx5e_xdpsq_stats *xsksq_stats)
+{
+	s->tx_xsk_xmit  +=3D xsksq_stats->xmit;
+	s->tx_xsk_mpwqe +=3D xsksq_stats->mpwqe;
+	s->tx_xsk_inlnw +=3D xsksq_stats->inlnw;
+	s->tx_xsk_full  +=3D xsksq_stats->full;
+	s->tx_xsk_err   +=3D xsksq_stats->err;
+	s->tx_xsk_cqes  +=3D xsksq_stats->cqes;
+}
+
+static void mlx5e_stats_grp_sw_update_stats_xskrq(struct mlx5e_sw_stats *s=
,
+						  struct mlx5e_rq_stats *xskrq_stats)
+{
+	s->rx_xsk_packets                +=3D xskrq_stats->packets;
+	s->rx_xsk_bytes                  +=3D xskrq_stats->bytes;
+	s->rx_xsk_csum_complete          +=3D xskrq_stats->csum_complete;
+	s->rx_xsk_csum_unnecessary       +=3D xskrq_stats->csum_unnecessary;
+	s->rx_xsk_csum_unnecessary_inner +=3D xskrq_stats->csum_unnecessary_inner=
;
+	s->rx_xsk_csum_none              +=3D xskrq_stats->csum_none;
+	s->rx_xsk_ecn_mark               +=3D xskrq_stats->ecn_mark;
+	s->rx_xsk_removed_vlan_packets   +=3D xskrq_stats->removed_vlan_packets;
+	s->rx_xsk_xdp_drop               +=3D xskrq_stats->xdp_drop;
+	s->rx_xsk_xdp_redirect           +=3D xskrq_stats->xdp_redirect;
+	s->rx_xsk_wqe_err                +=3D xskrq_stats->wqe_err;
+	s->rx_xsk_mpwqe_filler_cqes      +=3D xskrq_stats->mpwqe_filler_cqes;
+	s->rx_xsk_mpwqe_filler_strides   +=3D xskrq_stats->mpwqe_filler_strides;
+	s->rx_xsk_oversize_pkts_sw_drop  +=3D xskrq_stats->oversize_pkts_sw_drop;
+	s->rx_xsk_buff_alloc_err         +=3D xskrq_stats->buff_alloc_err;
+	s->rx_xsk_cqe_compress_blks      +=3D xskrq_stats->cqe_compress_blks;
+	s->rx_xsk_cqe_compress_pkts      +=3D xskrq_stats->cqe_compress_pkts;
+	s->rx_xsk_congst_umr             +=3D xskrq_stats->congst_umr;
+	s->rx_xsk_arfs_err               +=3D xskrq_stats->arfs_err;
+}
+
+static void mlx5e_stats_grp_sw_update_stats_rq_stats(struct mlx5e_sw_stats=
 *s,
+						     struct mlx5e_rq_stats *rq_stats)
+{
+	s->rx_packets                 +=3D rq_stats->packets;
+	s->rx_bytes                   +=3D rq_stats->bytes;
+	s->rx_lro_packets             +=3D rq_stats->lro_packets;
+	s->rx_lro_bytes               +=3D rq_stats->lro_bytes;
+	s->rx_ecn_mark                +=3D rq_stats->ecn_mark;
+	s->rx_removed_vlan_packets    +=3D rq_stats->removed_vlan_packets;
+	s->rx_csum_none               +=3D rq_stats->csum_none;
+	s->rx_csum_complete           +=3D rq_stats->csum_complete;
+	s->rx_csum_complete_tail      +=3D rq_stats->csum_complete_tail;
+	s->rx_csum_complete_tail_slow +=3D rq_stats->csum_complete_tail_slow;
+	s->rx_csum_unnecessary        +=3D rq_stats->csum_unnecessary;
+	s->rx_csum_unnecessary_inner  +=3D rq_stats->csum_unnecessary_inner;
+	s->rx_xdp_drop                +=3D rq_stats->xdp_drop;
+	s->rx_xdp_redirect            +=3D rq_stats->xdp_redirect;
+	s->rx_wqe_err                 +=3D rq_stats->wqe_err;
+	s->rx_mpwqe_filler_cqes       +=3D rq_stats->mpwqe_filler_cqes;
+	s->rx_mpwqe_filler_strides    +=3D rq_stats->mpwqe_filler_strides;
+	s->rx_oversize_pkts_sw_drop   +=3D rq_stats->oversize_pkts_sw_drop;
+	s->rx_buff_alloc_err          +=3D rq_stats->buff_alloc_err;
+	s->rx_cqe_compress_blks       +=3D rq_stats->cqe_compress_blks;
+	s->rx_cqe_compress_pkts       +=3D rq_stats->cqe_compress_pkts;
+	s->rx_cache_reuse             +=3D rq_stats->cache_reuse;
+	s->rx_cache_full              +=3D rq_stats->cache_full;
+	s->rx_cache_empty             +=3D rq_stats->cache_empty;
+	s->rx_cache_busy              +=3D rq_stats->cache_busy;
+	s->rx_cache_waive             +=3D rq_stats->cache_waive;
+	s->rx_congst_umr              +=3D rq_stats->congst_umr;
+	s->rx_arfs_err                +=3D rq_stats->arfs_err;
+	s->rx_recover                 +=3D rq_stats->recover;
+#ifdef CONFIG_MLX5_EN_TLS
+	s->rx_tls_decrypted_packets   +=3D rq_stats->tls_decrypted_packets;
+	s->rx_tls_decrypted_bytes     +=3D rq_stats->tls_decrypted_bytes;
+	s->rx_tls_ctx                 +=3D rq_stats->tls_ctx;
+	s->rx_tls_del                 +=3D rq_stats->tls_del;
+	s->rx_tls_resync_req_pkt      +=3D rq_stats->tls_resync_req_pkt;
+	s->rx_tls_resync_req_start    +=3D rq_stats->tls_resync_req_start;
+	s->rx_tls_resync_req_end      +=3D rq_stats->tls_resync_req_end;
+	s->rx_tls_resync_req_skip     +=3D rq_stats->tls_resync_req_skip;
+	s->rx_tls_resync_res_ok       +=3D rq_stats->tls_resync_res_ok;
+	s->rx_tls_resync_res_skip     +=3D rq_stats->tls_resync_res_skip;
+	s->rx_tls_err                 +=3D rq_stats->tls_err;
+#endif
+}
+
+static void mlx5e_stats_grp_sw_update_stats_ch_stats(struct mlx5e_sw_stats=
 *s,
+						     struct mlx5e_ch_stats *ch_stats)
+{
+	s->ch_events      +=3D ch_stats->events;
+	s->ch_poll        +=3D ch_stats->poll;
+	s->ch_arm         +=3D ch_stats->arm;
+	s->ch_aff_change  +=3D ch_stats->aff_change;
+	s->ch_force_irq   +=3D ch_stats->force_irq;
+	s->ch_eq_rearm    +=3D ch_stats->eq_rearm;
+}
+
+static void mlx5e_stats_grp_sw_update_stats_sq(struct mlx5e_sw_stats *s,
+					       struct mlx5e_sq_stats *sq_stats)
+{
+	s->tx_packets               +=3D sq_stats->packets;
+	s->tx_bytes                 +=3D sq_stats->bytes;
+	s->tx_tso_packets           +=3D sq_stats->tso_packets;
+	s->tx_tso_bytes             +=3D sq_stats->tso_bytes;
+	s->tx_tso_inner_packets     +=3D sq_stats->tso_inner_packets;
+	s->tx_tso_inner_bytes       +=3D sq_stats->tso_inner_bytes;
+	s->tx_added_vlan_packets    +=3D sq_stats->added_vlan_packets;
+	s->tx_nop                   +=3D sq_stats->nop;
+	s->tx_mpwqe_blks            +=3D sq_stats->mpwqe_blks;
+	s->tx_mpwqe_pkts            +=3D sq_stats->mpwqe_pkts;
+	s->tx_queue_stopped         +=3D sq_stats->stopped;
+	s->tx_queue_wake            +=3D sq_stats->wake;
+	s->tx_queue_dropped         +=3D sq_stats->dropped;
+	s->tx_cqe_err               +=3D sq_stats->cqe_err;
+	s->tx_recover               +=3D sq_stats->recover;
+	s->tx_xmit_more             +=3D sq_stats->xmit_more;
+	s->tx_csum_partial_inner    +=3D sq_stats->csum_partial_inner;
+	s->tx_csum_none             +=3D sq_stats->csum_none;
+	s->tx_csum_partial          +=3D sq_stats->csum_partial;
+#ifdef CONFIG_MLX5_EN_TLS
+	s->tx_tls_encrypted_packets +=3D sq_stats->tls_encrypted_packets;
+	s->tx_tls_encrypted_bytes   +=3D sq_stats->tls_encrypted_bytes;
+	s->tx_tls_ctx               +=3D sq_stats->tls_ctx;
+	s->tx_tls_ooo               +=3D sq_stats->tls_ooo;
+	s->tx_tls_dump_bytes        +=3D sq_stats->tls_dump_bytes;
+	s->tx_tls_dump_packets      +=3D sq_stats->tls_dump_packets;
+	s->tx_tls_resync_bytes      +=3D sq_stats->tls_resync_bytes;
+	s->tx_tls_skip_no_sync_data +=3D sq_stats->tls_skip_no_sync_data;
+	s->tx_tls_drop_no_sync_data +=3D sq_stats->tls_drop_no_sync_data;
+	s->tx_tls_drop_bypass_req   +=3D sq_stats->tls_drop_bypass_req;
+#endif
+	s->tx_cqes                  +=3D sq_stats->cqes;
+}
+
 static MLX5E_DECLARE_STATS_GRP_OP_UPDATE_STATS(sw)
 {
 	struct mlx5e_sw_stats *s =3D &priv->stats.sw;
@@ -258,139 +412,19 @@ static MLX5E_DECLARE_STATS_GRP_OP_UPDATE_STATS(sw)
 	for (i =3D 0; i < priv->max_nch; i++) {
 		struct mlx5e_channel_stats *channel_stats =3D
 			&priv->channel_stats[i];
-		struct mlx5e_xdpsq_stats *xdpsq_red_stats =3D &channel_stats->xdpsq;
-		struct mlx5e_xdpsq_stats *xdpsq_stats =3D &channel_stats->rq_xdpsq;
-		struct mlx5e_xdpsq_stats *xsksq_stats =3D &channel_stats->xsksq;
-		struct mlx5e_rq_stats *xskrq_stats =3D &channel_stats->xskrq;
-		struct mlx5e_rq_stats *rq_stats =3D &channel_stats->rq;
-		struct mlx5e_ch_stats *ch_stats =3D &channel_stats->ch;
 		int j;
=20
-		s->rx_packets	+=3D rq_stats->packets;
-		s->rx_bytes	+=3D rq_stats->bytes;
-		s->rx_lro_packets +=3D rq_stats->lro_packets;
-		s->rx_lro_bytes	+=3D rq_stats->lro_bytes;
-		s->rx_ecn_mark	+=3D rq_stats->ecn_mark;
-		s->rx_removed_vlan_packets +=3D rq_stats->removed_vlan_packets;
-		s->rx_csum_none	+=3D rq_stats->csum_none;
-		s->rx_csum_complete +=3D rq_stats->csum_complete;
-		s->rx_csum_complete_tail +=3D rq_stats->csum_complete_tail;
-		s->rx_csum_complete_tail_slow +=3D rq_stats->csum_complete_tail_slow;
-		s->rx_csum_unnecessary +=3D rq_stats->csum_unnecessary;
-		s->rx_csum_unnecessary_inner +=3D rq_stats->csum_unnecessary_inner;
-		s->rx_xdp_drop     +=3D rq_stats->xdp_drop;
-		s->rx_xdp_redirect +=3D rq_stats->xdp_redirect;
-		s->rx_xdp_tx_xmit  +=3D xdpsq_stats->xmit;
-		s->rx_xdp_tx_mpwqe +=3D xdpsq_stats->mpwqe;
-		s->rx_xdp_tx_inlnw +=3D xdpsq_stats->inlnw;
-		s->rx_xdp_tx_nops  +=3D xdpsq_stats->nops;
-		s->rx_xdp_tx_full  +=3D xdpsq_stats->full;
-		s->rx_xdp_tx_err   +=3D xdpsq_stats->err;
-		s->rx_xdp_tx_cqe   +=3D xdpsq_stats->cqes;
-		s->rx_wqe_err   +=3D rq_stats->wqe_err;
-		s->rx_mpwqe_filler_cqes    +=3D rq_stats->mpwqe_filler_cqes;
-		s->rx_mpwqe_filler_strides +=3D rq_stats->mpwqe_filler_strides;
-		s->rx_oversize_pkts_sw_drop +=3D rq_stats->oversize_pkts_sw_drop;
-		s->rx_buff_alloc_err +=3D rq_stats->buff_alloc_err;
-		s->rx_cqe_compress_blks +=3D rq_stats->cqe_compress_blks;
-		s->rx_cqe_compress_pkts +=3D rq_stats->cqe_compress_pkts;
-		s->rx_cache_reuse +=3D rq_stats->cache_reuse;
-		s->rx_cache_full  +=3D rq_stats->cache_full;
-		s->rx_cache_empty +=3D rq_stats->cache_empty;
-		s->rx_cache_busy  +=3D rq_stats->cache_busy;
-		s->rx_cache_waive +=3D rq_stats->cache_waive;
-		s->rx_congst_umr  +=3D rq_stats->congst_umr;
-		s->rx_arfs_err    +=3D rq_stats->arfs_err;
-		s->rx_recover     +=3D rq_stats->recover;
-#ifdef CONFIG_MLX5_EN_TLS
-		s->rx_tls_decrypted_packets +=3D rq_stats->tls_decrypted_packets;
-		s->rx_tls_decrypted_bytes   +=3D rq_stats->tls_decrypted_bytes;
-		s->rx_tls_ctx               +=3D rq_stats->tls_ctx;
-		s->rx_tls_del               +=3D rq_stats->tls_del;
-		s->rx_tls_resync_req_pkt    +=3D rq_stats->tls_resync_req_pkt;
-		s->rx_tls_resync_req_start  +=3D rq_stats->tls_resync_req_start;
-		s->rx_tls_resync_req_end    +=3D rq_stats->tls_resync_req_end;
-		s->rx_tls_resync_req_skip   +=3D rq_stats->tls_resync_req_skip;
-		s->rx_tls_resync_res_ok     +=3D rq_stats->tls_resync_res_ok;
-		s->rx_tls_resync_res_skip   +=3D rq_stats->tls_resync_res_skip;
-		s->rx_tls_err               +=3D rq_stats->tls_err;
-#endif
-		s->ch_events      +=3D ch_stats->events;
-		s->ch_poll        +=3D ch_stats->poll;
-		s->ch_arm         +=3D ch_stats->arm;
-		s->ch_aff_change  +=3D ch_stats->aff_change;
-		s->ch_force_irq   +=3D ch_stats->force_irq;
-		s->ch_eq_rearm    +=3D ch_stats->eq_rearm;
+		mlx5e_stats_grp_sw_update_stats_rq_stats(s, &channel_stats->rq);
+		mlx5e_stats_grp_sw_update_stats_xdpsq(s, &channel_stats->rq_xdpsq);
+		mlx5e_stats_grp_sw_update_stats_ch_stats(s, &channel_stats->ch);
 		/* xdp redirect */
-		s->tx_xdp_xmit    +=3D xdpsq_red_stats->xmit;
-		s->tx_xdp_mpwqe   +=3D xdpsq_red_stats->mpwqe;
-		s->tx_xdp_inlnw   +=3D xdpsq_red_stats->inlnw;
-		s->tx_xdp_nops	  +=3D xdpsq_red_stats->nops;
-		s->tx_xdp_full    +=3D xdpsq_red_stats->full;
-		s->tx_xdp_err     +=3D xdpsq_red_stats->err;
-		s->tx_xdp_cqes    +=3D xdpsq_red_stats->cqes;
+		mlx5e_stats_grp_sw_update_stats_xdp_red(s, &channel_stats->xdpsq);
 		/* AF_XDP zero-copy */
-		s->rx_xsk_packets                +=3D xskrq_stats->packets;
-		s->rx_xsk_bytes                  +=3D xskrq_stats->bytes;
-		s->rx_xsk_csum_complete          +=3D xskrq_stats->csum_complete;
-		s->rx_xsk_csum_unnecessary       +=3D xskrq_stats->csum_unnecessary;
-		s->rx_xsk_csum_unnecessary_inner +=3D xskrq_stats->csum_unnecessary_inne=
r;
-		s->rx_xsk_csum_none              +=3D xskrq_stats->csum_none;
-		s->rx_xsk_ecn_mark               +=3D xskrq_stats->ecn_mark;
-		s->rx_xsk_removed_vlan_packets   +=3D xskrq_stats->removed_vlan_packets;
-		s->rx_xsk_xdp_drop               +=3D xskrq_stats->xdp_drop;
-		s->rx_xsk_xdp_redirect           +=3D xskrq_stats->xdp_redirect;
-		s->rx_xsk_wqe_err                +=3D xskrq_stats->wqe_err;
-		s->rx_xsk_mpwqe_filler_cqes      +=3D xskrq_stats->mpwqe_filler_cqes;
-		s->rx_xsk_mpwqe_filler_strides   +=3D xskrq_stats->mpwqe_filler_strides;
-		s->rx_xsk_oversize_pkts_sw_drop  +=3D xskrq_stats->oversize_pkts_sw_drop=
;
-		s->rx_xsk_buff_alloc_err         +=3D xskrq_stats->buff_alloc_err;
-		s->rx_xsk_cqe_compress_blks      +=3D xskrq_stats->cqe_compress_blks;
-		s->rx_xsk_cqe_compress_pkts      +=3D xskrq_stats->cqe_compress_pkts;
-		s->rx_xsk_congst_umr             +=3D xskrq_stats->congst_umr;
-		s->rx_xsk_arfs_err               +=3D xskrq_stats->arfs_err;
-		s->tx_xsk_xmit                   +=3D xsksq_stats->xmit;
-		s->tx_xsk_mpwqe                  +=3D xsksq_stats->mpwqe;
-		s->tx_xsk_inlnw                  +=3D xsksq_stats->inlnw;
-		s->tx_xsk_full                   +=3D xsksq_stats->full;
-		s->tx_xsk_err                    +=3D xsksq_stats->err;
-		s->tx_xsk_cqes                   +=3D xsksq_stats->cqes;
+		mlx5e_stats_grp_sw_update_stats_xskrq(s, &channel_stats->xskrq);
+		mlx5e_stats_grp_sw_update_stats_xsksq(s, &channel_stats->xsksq);
=20
 		for (j =3D 0; j < priv->max_opened_tc; j++) {
-			struct mlx5e_sq_stats *sq_stats =3D &channel_stats->sq[j];
-
-			s->tx_packets		+=3D sq_stats->packets;
-			s->tx_bytes		+=3D sq_stats->bytes;
-			s->tx_tso_packets	+=3D sq_stats->tso_packets;
-			s->tx_tso_bytes		+=3D sq_stats->tso_bytes;
-			s->tx_tso_inner_packets	+=3D sq_stats->tso_inner_packets;
-			s->tx_tso_inner_bytes	+=3D sq_stats->tso_inner_bytes;
-			s->tx_added_vlan_packets +=3D sq_stats->added_vlan_packets;
-			s->tx_nop               +=3D sq_stats->nop;
-			s->tx_mpwqe_blks        +=3D sq_stats->mpwqe_blks;
-			s->tx_mpwqe_pkts        +=3D sq_stats->mpwqe_pkts;
-			s->tx_queue_stopped	+=3D sq_stats->stopped;
-			s->tx_queue_wake	+=3D sq_stats->wake;
-			s->tx_queue_dropped	+=3D sq_stats->dropped;
-			s->tx_cqe_err		+=3D sq_stats->cqe_err;
-			s->tx_recover		+=3D sq_stats->recover;
-			s->tx_xmit_more		+=3D sq_stats->xmit_more;
-			s->tx_csum_partial_inner +=3D sq_stats->csum_partial_inner;
-			s->tx_csum_none		+=3D sq_stats->csum_none;
-			s->tx_csum_partial	+=3D sq_stats->csum_partial;
-#ifdef CONFIG_MLX5_EN_TLS
-			s->tx_tls_encrypted_packets +=3D sq_stats->tls_encrypted_packets;
-			s->tx_tls_encrypted_bytes   +=3D sq_stats->tls_encrypted_bytes;
-			s->tx_tls_ctx               +=3D sq_stats->tls_ctx;
-			s->tx_tls_ooo               +=3D sq_stats->tls_ooo;
-			s->tx_tls_dump_bytes        +=3D sq_stats->tls_dump_bytes;
-			s->tx_tls_dump_packets      +=3D sq_stats->tls_dump_packets;
-			s->tx_tls_resync_bytes      +=3D sq_stats->tls_resync_bytes;
-			s->tx_tls_skip_no_sync_data +=3D sq_stats->tls_skip_no_sync_data;
-			s->tx_tls_drop_no_sync_data +=3D sq_stats->tls_drop_no_sync_data;
-			s->tx_tls_drop_bypass_req   +=3D sq_stats->tls_drop_bypass_req;
-#endif
-			s->tx_cqes		+=3D sq_stats->cqes;
+			mlx5e_stats_grp_sw_update_stats_sq(s, &channel_stats->sq[j]);
=20
 			/* https://gcc.gnu.org/bugzilla/show_bug.cgi?id=3D92657 */
 			barrier();
--=20
2.26.2

