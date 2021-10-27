Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2232B43BFFE
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 04:35:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238438AbhJ0ChR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 22:37:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:58410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238053AbhJ0ChM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 22:37:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 80B4161100;
        Wed, 27 Oct 2021 02:34:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635302086;
        bh=5l4b+x46CtMxwV4Ke2PrmQ7at9JLSeFBBuYyunjgD9Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rCth1jamUsC7QpJxIWmr5z8QNcW19KDiWWA8jA/SufUFhKRF8byyivWLRaLzK08Kc
         cIioFjIJw/9Lblj4hMFPrjEJIMuU2FFQR58iIJgjYhDTnA1HuPUjuQ7DRaK2TZTpUr
         xnJBTQZP5ARQl/amy8/p+RCt0+lMAR5oWl62+IenFb1XxynlR1ggeZO72szvZwmsiy
         5NND8kdzqpDowz/7OCK8OpCuofH2k473rDrVIR12ILAa2mxM0EvQwACu2aE1Pn8+Q8
         1UfoMGj5aCnWqNJFtNwyFqtaeVGfAmIV2ejis50DwlbBaMvBAz3kPlvkGPBblIPRQf
         KSeebDN+s10qA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Khalid Manaa <khalidm@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 11/14] net/mlx5e: Add HW_GRO statistics
Date:   Tue, 26 Oct 2021 19:33:44 -0700
Message-Id: <20211027023347.699076-12-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211027023347.699076-1-saeed@kernel.org>
References: <20211027023347.699076-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Khalid Manaa <khalidm@nvidia.com>

This patch adds HW_GRO counters to RX packets statistics:
 - gro_match_packets: counter of received packets with set match flag.

 - gro_packets: counter of received packets over the HW_GRO feature,
                this counter is increased by one for every received
                HW_GRO cqe.

 - gro_bytes: counter of received bytes over the HW_GRO feature,
              this counter is increased by the received bytes for every
              received HW_GRO cqe.

 - gro_skbs: counter of built HW_GRO skbs,
             increased by one when we flush HW_GRO skb
             (when we call a napi_gro_receive with hw_gro skb).

 - gro_large_hds: counter of received packets with large headers size,
                  in case the packet needs new SKB, the driver will allocate
                  new one and will not use the headers entry to build it.

Signed-off-by: Khalid Manaa <khalidm@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c   | 12 +++++++++---
 .../net/ethernet/mellanox/mlx5/core/en_stats.c    | 15 +++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/en_stats.h    | 10 ++++++++++
 3 files changed, 34 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 089bd484290e..fe979edd96dc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -1461,7 +1461,9 @@ static void mlx5e_shampo_complete_rx_cqe(struct mlx5e_rq *rq,
 	struct mlx5e_rq_stats *stats = rq->stats;
 
 	stats->packets++;
+	stats->gro_packets++;
 	stats->bytes += cqe_bcnt;
+	stats->gro_bytes += cqe_bcnt;
 	if (NAPI_GRO_CB(skb)->count != 1)
 		return;
 	mlx5e_build_rx_skb(cqe, cqe_bcnt, rq, skb);
@@ -1914,6 +1916,7 @@ mlx5e_skb_from_cqe_shampo(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi,
 
 	} else {
 		/* allocate SKB and copy header for large header */
+		rq->stats->gro_large_hds++;
 		skb = napi_alloc_skb(rq->cq.napi,
 				     ALIGN(head_size, sizeof(long)));
 		if (unlikely(!skb)) {
@@ -1949,7 +1952,9 @@ static void
 mlx5e_shampo_flush_skb(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe, bool match)
 {
 	struct sk_buff *skb = rq->hw_gro_data->skb;
+	struct mlx5e_rq_stats *stats = rq->stats;
 
+	stats->gro_skbs++;
 	if (likely(skb_shinfo(skb)->nr_frags))
 		mlx5e_shampo_align_fragment(skb, rq->mpwqe.log_stride_sz);
 	if (NAPI_GRO_CB(skb)->count > 1)
@@ -1992,6 +1997,7 @@ static void mlx5e_handle_rx_cqe_mpwrq_shampo(struct mlx5e_rq *rq, struct mlx5_cq
 	struct sk_buff **skb	= &rq->hw_gro_data->skb;
 	bool flush		= cqe->shampo.flush;
 	bool match		= cqe->shampo.match;
+	struct mlx5e_rq_stats *stats = rq->stats;
 	struct mlx5e_rx_wqe_ll *wqe;
 	struct mlx5e_dma_info *di;
 	struct mlx5e_mpw_info *wi;
@@ -2002,18 +2008,18 @@ static void mlx5e_handle_rx_cqe_mpwrq_shampo(struct mlx5e_rq *rq, struct mlx5_cq
 
 	if (unlikely(MLX5E_RX_ERR_CQE(cqe))) {
 		trigger_report(rq, cqe);
-		rq->stats->wqe_err++;
+		stats->wqe_err++;
 		goto mpwrq_cqe_out;
 	}
 
 	if (unlikely(mpwrq_is_filler_cqe(cqe))) {
-		struct mlx5e_rq_stats *stats = rq->stats;
-
 		stats->mpwqe_filler_cqes++;
 		stats->mpwqe_filler_strides += cstrides;
 		goto mpwrq_cqe_out;
 	}
 
+	stats->gro_match_packets += match;
+
 	if (*skb && (!match || !(mlx5e_hw_gro_skb_has_enough_space(*skb, data_bcnt)))) {
 		match = false;
 		mlx5e_shampo_flush_skb(rq, cqe, match);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
index e1dd17019030..2a9bfc3ffa2e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
@@ -128,6 +128,11 @@ static const struct counter_desc sw_stats_desc[] = {
 
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_lro_packets) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_lro_bytes) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_gro_packets) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_gro_bytes) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_gro_skbs) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_gro_match_packets) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_gro_large_hds) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_ecn_mark) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_removed_vlan_packets) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_csum_unnecessary) },
@@ -313,6 +318,11 @@ static void mlx5e_stats_grp_sw_update_stats_rq_stats(struct mlx5e_sw_stats *s,
 	s->rx_bytes                   += rq_stats->bytes;
 	s->rx_lro_packets             += rq_stats->lro_packets;
 	s->rx_lro_bytes               += rq_stats->lro_bytes;
+	s->rx_gro_packets             += rq_stats->gro_packets;
+	s->rx_gro_bytes               += rq_stats->gro_bytes;
+	s->rx_gro_skbs                += rq_stats->gro_skbs;
+	s->rx_gro_match_packets       += rq_stats->gro_match_packets;
+	s->rx_gro_large_hds           += rq_stats->gro_large_hds;
 	s->rx_ecn_mark                += rq_stats->ecn_mark;
 	s->rx_removed_vlan_packets    += rq_stats->removed_vlan_packets;
 	s->rx_csum_none               += rq_stats->csum_none;
@@ -1760,6 +1770,11 @@ static const struct counter_desc rq_stats_desc[] = {
 	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, xdp_redirect) },
 	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, lro_packets) },
 	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, lro_bytes) },
+	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, gro_packets) },
+	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, gro_bytes) },
+	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, gro_skbs) },
+	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, gro_match_packets) },
+	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, gro_large_hds) },
 	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, ecn_mark) },
 	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, removed_vlan_packets) },
 	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, wqe_err) },
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
index 139e59f30db0..2c1ed5b81be6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
@@ -144,6 +144,11 @@ struct mlx5e_sw_stats {
 	u64 tx_mpwqe_pkts;
 	u64 rx_lro_packets;
 	u64 rx_lro_bytes;
+	u64 rx_gro_packets;
+	u64 rx_gro_bytes;
+	u64 rx_gro_skbs;
+	u64 rx_gro_match_packets;
+	u64 rx_gro_large_hds;
 	u64 rx_mcast_packets;
 	u64 rx_ecn_mark;
 	u64 rx_removed_vlan_packets;
@@ -322,6 +327,11 @@ struct mlx5e_rq_stats {
 	u64 csum_none;
 	u64 lro_packets;
 	u64 lro_bytes;
+	u64 gro_packets;
+	u64 gro_bytes;
+	u64 gro_skbs;
+	u64 gro_match_packets;
+	u64 gro_large_hds;
 	u64 mcast_packets;
 	u64 ecn_mark;
 	u64 removed_vlan_packets;
-- 
2.31.1

