Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEBAB45A8D5
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 17:42:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238799AbhKWQpS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 11:45:18 -0500
Received: from mga07.intel.com ([134.134.136.100]:62027 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234887AbhKWQpD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Nov 2021 11:45:03 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10177"; a="298468511"
X-IronPort-AV: E=Sophos;i="5.87,258,1631602800"; 
   d="scan'208";a="298468511"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2021 08:41:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,258,1631602800"; 
   d="scan'208";a="474813343"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga002.jf.intel.com with ESMTP; 23 Nov 2021 08:41:29 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 1ANGf4Wl016784;
        Tue, 23 Nov 2021 16:41:26 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Shay Agroskin <shayagr@amazon.com>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        David Arinzon <darinzon@amazon.com>,
        Noam Dagan <ndagan@amazon.com>,
        Saeed Bishara <saeedb@amazon.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Russell King <linux@armlinux.org.uk>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Yajun Deng <yajun.deng@linux.dev>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Andrei Vagin <avagin@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Cong Wang <cong.wang@bytedance.com>, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, bpf@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: [PATCH v2 net-next 09/26] mlx5: don't mix XDP_DROP and Rx XDP error cases
Date:   Tue, 23 Nov 2021 17:39:38 +0100
Message-Id: <20211123163955.154512-10-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211123163955.154512-1-alexandr.lobakin@intel.com>
References: <20211123163955.154512-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Provide a separate counter [rx_]xdp_errors for drops related to
XDP_ABORTED and other errors/exceptions and leave [rx_]xdp_drop
only for XDP_DROP case.
This will align the driver better with generic XDP stats.

Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c   | 3 ++-
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.c | 7 +++++++
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.h | 3 +++
 3 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
index 2f0df5cc1a2d..a9a8535c828b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
@@ -156,7 +156,8 @@ bool mlx5e_xdp_handle(struct mlx5e_rq *rq, struct mlx5e_dma_info *di,
 	case XDP_ABORTED:
 xdp_abort:
 		trace_xdp_exception(rq->netdev, prog, act);
-		fallthrough;
+		rq->stats->xdp_errors++;
+		return true;
 	case XDP_DROP:
 		rq->stats->xdp_drop++;
 		return true;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
index 3c91a11e27ad..3631dafb4ea2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
@@ -141,6 +141,7 @@ static const struct counter_desc sw_stats_desc[] = {
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_csum_complete_tail) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_csum_complete_tail_slow) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_csum_unnecessary_inner) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_xdp_errors) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_xdp_drop) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_xdp_redirect) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_xdp_tx_xmit) },
@@ -208,6 +209,7 @@ static const struct counter_desc sw_stats_desc[] = {
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_xsk_csum_none) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_xsk_ecn_mark) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_xsk_removed_vlan_packets) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_xsk_xdp_errors) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_xsk_xdp_drop) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_xsk_xdp_redirect) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_xsk_wqe_err) },
@@ -298,6 +300,7 @@ static void mlx5e_stats_grp_sw_update_stats_xskrq(struct mlx5e_sw_stats *s,
 	s->rx_xsk_csum_none              += xskrq_stats->csum_none;
 	s->rx_xsk_ecn_mark               += xskrq_stats->ecn_mark;
 	s->rx_xsk_removed_vlan_packets   += xskrq_stats->removed_vlan_packets;
+	s->rx_xsk_xdp_errors             += xskrq_stats->xdp_errors;
 	s->rx_xsk_xdp_drop               += xskrq_stats->xdp_drop;
 	s->rx_xsk_xdp_redirect           += xskrq_stats->xdp_redirect;
 	s->rx_xsk_wqe_err                += xskrq_stats->wqe_err;
@@ -331,6 +334,7 @@ static void mlx5e_stats_grp_sw_update_stats_rq_stats(struct mlx5e_sw_stats *s,
 	s->rx_csum_complete_tail_slow += rq_stats->csum_complete_tail_slow;
 	s->rx_csum_unnecessary        += rq_stats->csum_unnecessary;
 	s->rx_csum_unnecessary_inner  += rq_stats->csum_unnecessary_inner;
+	s->rx_xdp_errors              += rq_stats->xdp_errors;
 	s->rx_xdp_drop                += rq_stats->xdp_drop;
 	s->rx_xdp_redirect            += rq_stats->xdp_redirect;
 	s->rx_wqe_err                 += rq_stats->wqe_err;
@@ -1766,6 +1770,7 @@ static const struct counter_desc rq_stats_desc[] = {
 	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, csum_unnecessary) },
 	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, csum_unnecessary_inner) },
 	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, csum_none) },
+	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, xdp_errors) },
 	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, xdp_drop) },
 	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, xdp_redirect) },
 	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, lro_packets) },
@@ -1869,6 +1874,7 @@ static const struct counter_desc xskrq_stats_desc[] = {
 	{ MLX5E_DECLARE_XSKRQ_STAT(struct mlx5e_rq_stats, csum_none) },
 	{ MLX5E_DECLARE_XSKRQ_STAT(struct mlx5e_rq_stats, ecn_mark) },
 	{ MLX5E_DECLARE_XSKRQ_STAT(struct mlx5e_rq_stats, removed_vlan_packets) },
+	{ MLX5E_DECLARE_XSKRQ_STAT(struct mlx5e_rq_stats, xdp_errors) },
 	{ MLX5E_DECLARE_XSKRQ_STAT(struct mlx5e_rq_stats, xdp_drop) },
 	{ MLX5E_DECLARE_XSKRQ_STAT(struct mlx5e_rq_stats, xdp_redirect) },
 	{ MLX5E_DECLARE_XSKRQ_STAT(struct mlx5e_rq_stats, wqe_err) },
@@ -1940,6 +1946,7 @@ static const struct counter_desc ptp_rq_stats_desc[] = {
 	{ MLX5E_DECLARE_PTP_RQ_STAT(struct mlx5e_rq_stats, csum_unnecessary) },
 	{ MLX5E_DECLARE_PTP_RQ_STAT(struct mlx5e_rq_stats, csum_unnecessary_inner) },
 	{ MLX5E_DECLARE_PTP_RQ_STAT(struct mlx5e_rq_stats, csum_none) },
+	{ MLX5E_DECLARE_PTP_RQ_STAT(struct mlx5e_rq_stats, xdp_errors) },
 	{ MLX5E_DECLARE_PTP_RQ_STAT(struct mlx5e_rq_stats, xdp_drop) },
 	{ MLX5E_DECLARE_PTP_RQ_STAT(struct mlx5e_rq_stats, xdp_redirect) },
 	{ MLX5E_DECLARE_PTP_RQ_STAT(struct mlx5e_rq_stats, lro_packets) },
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
index 2c1ed5b81be6..dd33465af0ff 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
@@ -158,6 +158,7 @@ struct mlx5e_sw_stats {
 	u64 rx_csum_complete_tail;
 	u64 rx_csum_complete_tail_slow;
 	u64 rx_csum_unnecessary_inner;
+	u64 rx_xdp_errors;
 	u64 rx_xdp_drop;
 	u64 rx_xdp_redirect;
 	u64 rx_xdp_tx_xmit;
@@ -237,6 +238,7 @@ struct mlx5e_sw_stats {
 	u64 rx_xsk_csum_none;
 	u64 rx_xsk_ecn_mark;
 	u64 rx_xsk_removed_vlan_packets;
+	u64 rx_xsk_xdp_errors;
 	u64 rx_xsk_xdp_drop;
 	u64 rx_xsk_xdp_redirect;
 	u64 rx_xsk_wqe_err;
@@ -335,6 +337,7 @@ struct mlx5e_rq_stats {
 	u64 mcast_packets;
 	u64 ecn_mark;
 	u64 removed_vlan_packets;
+	u64 xdp_errors;
 	u64 xdp_drop;
 	u64 xdp_redirect;
 	u64 wqe_err;
--
2.33.1

