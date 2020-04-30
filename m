Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE10E1C03D3
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 19:22:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727079AbgD3RWS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 13:22:18 -0400
Received: from mail-eopbgr70055.outbound.protection.outlook.com ([40.107.7.55]:6237
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727064AbgD3RWR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 13:22:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SRt+rIqKpSV/MpwJtrFF/ZrCc1DmXnGOCQ5/lCNKqDJ1edokX/UlQlS/nsGAJ3EnCTkcWFPZrpc8eEGEahKaFH8RJLHSQMAfagFrAFJUtI92u1oLh+UNq4fPlWRvmpvq6U1K0TSZARlFHrndG7fPztaQAL5D3/Ro2z14/pfJMSwUYEgJ6dANOibJ7lNkk8FfPInkcgPIdJDAvENDpp40O7E8UiOEneov0R+HEYmFgBqAR/BuVMyJQ97eLT3Pj3a+yrtZtLL5NEkeF0rr7/apNMaJ0SqFicvLPq9GZYQQjWo+6uXd2KkTJu0k0BXvTLkfkhz4myCkORnnYvZ/7gRxhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FF91mLH2rQAQqijbay2T/TtTqHC+FHjbLPHD13OCcj8=;
 b=iZWpaGxkRx5aUJHvOtAzPvbOLdxv8hmKPtoMFcGcS9sSLTAptkVnSKky4BpaqDY1VLCCkARplOZPFWwnYhpMe1EGWEjYD1e1NcY0IUgZftOwjuB6ywJY6g+H13CMPin9RT9LbIFY1aAxMjYKgBZEKjhfDQvamaP75jwMjFjCJddZfxq6GvNMgEyU01KrkAYtMi0JdJjRNdoLfkNyTNcfc97xNdWRycbq1OgWDNb6fotO0Ex5HDOG/Tsp2XbG/4N4lqSSU6VZ7HEKle0uikGsomp7A3tLV26lO8HJxlW7VgIuri1zXXfrQ67LqF4SIsIQs1euboTgRJbkEc0zEpw5Xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FF91mLH2rQAQqijbay2T/TtTqHC+FHjbLPHD13OCcj8=;
 b=fEQrOvBr28I0YvuU1s4r08kx38+3rvSqHAgm7tfBTUzMbVUKFWDbtzuGwSaCXVNQBhKmkUjSiq/tX0p8OpVEZBSgYxb9Zb3aKrpvZ8RHOQdH4ZSLUixwUBK1FA4qKOmp6bFeziTPgBMTzIVnn9Mm7gefnTrqmwHHvApSjFz8X6c=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB3296.eurprd05.prod.outlook.com (2603:10a6:802:1c::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20; Thu, 30 Apr
 2020 17:21:30 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2937.028; Thu, 30 Apr 2020
 17:21:30 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Maxim Mikityanskiy <maximmi@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 15/15] net/mlx5e: Unify reserving space for WQEs
Date:   Thu, 30 Apr 2020 10:18:35 -0700
Message-Id: <20200430171835.20812-16-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200430171835.20812-1-saeedm@mellanox.com>
References: <20200430171835.20812-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR17CA0030.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::43) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY5PR17CA0030.namprd17.prod.outlook.com (2603:10b6:a03:1b8::43) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20 via Frontend Transport; Thu, 30 Apr 2020 17:21:28 +0000
X-Mailer: git-send-email 2.25.4
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a9196076-35db-4a3e-ed1c-08d7ed2aec36
X-MS-TrafficTypeDiagnostic: VI1PR05MB3296:|VI1PR05MB3296:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB3296943BF8F638928538F133BEAA0@VI1PR05MB3296.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-Forefront-PRVS: 0389EDA07F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: prICEw7Cswqr0z4LO28tOMpz7ZfE7AlfprTXFPAajlA456y9FFti97hh2sNf+vKjPzy28rjdcReD1ascJ2Pa/Ub8ag+jdI4B3iCDjos/qlkvG2Gw0h+Z8wPa5lscFUWoE2vt38TReW2hjzwp4LMpTm3Rd5I7rharcjuKXaNXOLk3uSZqpGR3aSjlZ2+mIHQDDbeVJJF6uZ8YxNJeozFJxfqzhE82Vl7DWbmdaNmbuOOnuc4EuZvNwORZwcAD5ZFTq0Y5aRD5sjh+68sx/itic6TYHnjBRlTnrdl6TrJt+f0d+Zy+I0sPLpVN252PglCVzbmtVw0Yp8m0avL1XES9ZC2AmKWMoM96VCQoLnwQDISIDKUo2kL0SE9CTIaqUdopQsWfBymTDvNV2robl300cV8knNdeTIuSzBotOX239L9tzRmreHXyjuLBt/QBFvIxA3+qIuZF3BN2sZXK6K1bdtZq759+3yyfLBEIS9zxl6n5lF3HgRI9VdCQA/Dzwg7u
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(376002)(39860400002)(366004)(136003)(346002)(52116002)(6666004)(54906003)(2616005)(956004)(316002)(2906002)(478600001)(107886003)(4326008)(66946007)(86362001)(66476007)(66556008)(36756003)(6486002)(16526019)(186003)(26005)(8936002)(6512007)(8676002)(6506007)(1076003)(30864003)(5660300002)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 7gQzqVLZfHopUMFsw6eRlGBb9inKMP/WszmOKCE2f3FEScP7A8kxafZz/P4WfDXw0ZRiCE7eBNSIb9OQf+UqRByHgjAldBJs4ivDZ8xVqCp9u0FpklGcJonIc5TWAJRMHeYlE0MCTI7qyZf368MR8+DnEHk27iRDvARN3fwH3RYD/HPARJJMgbQ0dyepTNKZvdhHc5CAYvzYDMOhdGmMIVe16KF6TJ4XfNXS13KcUpUcaRchVCIFNNWlCPaP3a1VwG2kelEacgCNTIdlxe2ctr4saKSnKlPP4pVWy/9oBYCPLImshb+Bekk9A34Ig/zJTMOnPylIyfSHEnzVGtENTgoLZkcuGDPeVrhImP4A3Y36cA4QBimXhQDIbtgCTvk1Pik9S1HcaV/Gzyoa6M3PTD8th8jsq9ENltnITR8CNWZKV41L/mE+C0HV4oRqt6Fu8sKcJQpG3mf/U0YzvDVfNaqfv5jXe5J73xhywcGyYea0FvpAmVXXgBhFrZqkUBTeGp9XjmaUL9P3xu6FOM35MmjeQCdo8WxrRFChCd2YvqnZqvelsd+2571XdjLpQPC+F8qI4j9ZCLULAedaBxl9mLNpflRXGxJRZHPULi1qqOHIwuQ1VbWsrdhA9s+fKViHovFhDzQYF42LIEq85zdKtgYVvb6tNNp9J3fwz3GbBPX5Xrw800hx87GMeTqfw8dFL7KIudm0dHGr31zMIKd2SOo5+YyFE1V/uBcVhICKL5VBjNdJQuSFsWk7NfufX7ABvM+conkFwJSS0U34Tdl9UHZBUY4hqk0vRiQYHLy1z9I=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9196076-35db-4a3e-ed1c-08d7ed2aec36
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2020 17:21:30.7094
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RcBK1C/6wcDLsyeeA/S160RGpf+Q8vIBvXb99R+aYLrSypZ64Xuz3oUFtsSw/O/juH6XHCUh5woLdgbmi1SA2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3296
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>

In our fast-path design, a WQE (Work Queue Element) must not cross the
page boundary. To enforce that, for WQEs consisting of more than one BB
(Basic Block), the driver checks the available contiguous space in the
WQ in advance, and if it's not enough, it pads it with NOPs.

This patch modifies the code that calculates the position of next WQE,
considering the padding, and prepares the WQE. This code is common for
all SQ types. In this patch it's reorganized in a way that makes the
usage pattern unified for all SQ types, and makes the implementations
self-contained and look almost the same, preparing the repeating code to
further attempts to deduplicate it.

One place is left as is: mlx5e_sq_xmit and mlx5e_fill_sq_frag_edge call
inside, because it is special in a way that it may also copy WQE's cseg
and eseg when reserving space. This will be eliminated in one of the
following patches, and this place will be converted to the new approach,
too.

Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/txrx.h | 56 +++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/en/xdp.c  | 31 ++++++++--
 .../net/ethernet/mellanox/mlx5/core/en/xdp.h  | 17 ------
 .../mellanox/mlx5/core/en_accel/ktls_tx.c     | 16 +-----
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   | 26 +--------
 .../net/ethernet/mellanox/mlx5/core/en_tx.c   | 11 +---
 6 files changed, 88 insertions(+), 69 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
index 8682d9148ab9..89fe65593c16 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
@@ -81,6 +81,62 @@ mlx5e_post_nop_fence(struct mlx5_wq_cyc *wq, u32 sqn, u16 *pc)
 	return wqe;
 }
 
+static inline u16 mlx5e_txqsq_get_next_pi(struct mlx5e_txqsq *sq, u16 size)
+{
+	struct mlx5_wq_cyc *wq = &sq->wq;
+	u16 pi, contig_wqebbs;
+
+	pi = mlx5_wq_cyc_ctr2ix(wq, sq->pc);
+	contig_wqebbs = mlx5_wq_cyc_get_contig_wqebbs(wq, pi);
+	if (unlikely(contig_wqebbs < size)) {
+		struct mlx5e_tx_wqe_info *wi, *edge_wi;
+
+		wi = &sq->db.wqe_info[pi];
+		edge_wi = wi + contig_wqebbs;
+
+		/* Fill SQ frag edge with NOPs to avoid WQE wrapping two pages. */
+		for (; wi < edge_wi; wi++) {
+			*wi = (struct mlx5e_tx_wqe_info) {
+				.num_wqebbs = 1,
+			};
+			mlx5e_post_nop(wq, sq->sqn, &sq->pc);
+		}
+		sq->stats->nop += contig_wqebbs;
+
+		pi = mlx5_wq_cyc_ctr2ix(wq, sq->pc);
+	}
+
+	return pi;
+}
+
+static inline u16 mlx5e_icosq_get_next_pi(struct mlx5e_icosq *sq, u16 size)
+{
+	struct mlx5_wq_cyc *wq = &sq->wq;
+	u16 pi, contig_wqebbs;
+
+	pi = mlx5_wq_cyc_ctr2ix(wq, sq->pc);
+	contig_wqebbs = mlx5_wq_cyc_get_contig_wqebbs(wq, pi);
+	if (unlikely(contig_wqebbs < size)) {
+		struct mlx5e_icosq_wqe_info *wi, *edge_wi;
+
+		wi = &sq->db.wqe_info[pi];
+		edge_wi = wi + contig_wqebbs;
+
+		/* Fill SQ frag edge with NOPs to avoid WQE wrapping two pages. */
+		for (; wi < edge_wi; wi++) {
+			*wi = (struct mlx5e_icosq_wqe_info) {
+				.opcode = MLX5_OPCODE_NOP,
+				.num_wqebbs = 1,
+			};
+			mlx5e_post_nop(wq, sq->sqn, &sq->pc);
+		}
+
+		pi = mlx5_wq_cyc_ctr2ix(wq, sq->pc);
+	}
+
+	return pi;
+}
+
 static inline void
 mlx5e_fill_sq_frag_edge(struct mlx5e_txqsq *sq, struct mlx5_wq_cyc *wq,
 			u16 pi, u16 nnops)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
index cf089520c031..c4a7fb4ecd14 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
@@ -178,21 +178,42 @@ bool mlx5e_xdp_handle(struct mlx5e_rq *rq, struct mlx5e_dma_info *di,
 	}
 }
 
-static void mlx5e_xdp_mpwqe_session_start(struct mlx5e_xdpsq *sq)
+static u16 mlx5e_xdpsq_get_next_pi(struct mlx5e_xdpsq *sq, u16 size)
 {
-	struct mlx5e_xdp_mpwqe *session = &sq->mpwqe;
-	struct mlx5e_xdpsq_stats *stats = sq->stats;
 	struct mlx5_wq_cyc *wq = &sq->wq;
 	u16 pi, contig_wqebbs;
 
 	pi = mlx5_wq_cyc_ctr2ix(wq, sq->pc);
 	contig_wqebbs = mlx5_wq_cyc_get_contig_wqebbs(wq, pi);
+	if (unlikely(contig_wqebbs < size)) {
+		struct mlx5e_xdp_wqe_info *wi, *edge_wi;
+
+		wi = &sq->db.wqe_info[pi];
+		edge_wi = wi + contig_wqebbs;
+
+		/* Fill SQ frag edge with NOPs to avoid WQE wrapping two pages. */
+		for (; wi < edge_wi; wi++) {
+			*wi = (struct mlx5e_xdp_wqe_info) {
+				.num_wqebbs = 1,
+				.num_pkts = 0,
+			};
+			mlx5e_post_nop(wq, sq->sqn, &sq->pc);
+		}
+		sq->stats->nops += contig_wqebbs;
 
-	if (unlikely(contig_wqebbs < MLX5_SEND_WQE_MAX_WQEBBS)) {
-		mlx5e_fill_xdpsq_frag_edge(sq, wq, pi, contig_wqebbs);
 		pi = mlx5_wq_cyc_ctr2ix(wq, sq->pc);
 	}
 
+	return pi;
+}
+
+static void mlx5e_xdp_mpwqe_session_start(struct mlx5e_xdpsq *sq)
+{
+	struct mlx5e_xdp_mpwqe *session = &sq->mpwqe;
+	struct mlx5e_xdpsq_stats *stats = sq->stats;
+	u16 pi;
+
+	pi = mlx5e_xdpsq_get_next_pi(sq, MLX5_SEND_WQE_MAX_WQEBBS);
 	session->wqe = MLX5E_TX_FETCH_WQE(sq, pi);
 
 	prefetchw(session->wqe->data);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
index 4fd0ff47bdc3..ed6f045febeb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
@@ -137,23 +137,6 @@ mlx5e_xdp_no_room_for_inline_pkt(struct mlx5e_xdp_mpwqe *session)
 	       session->ds_count + MLX5E_XDP_INLINE_WQE_MAX_DS_CNT > MLX5E_XDP_MPW_MAX_NUM_DS;
 }
 
-static inline void
-mlx5e_fill_xdpsq_frag_edge(struct mlx5e_xdpsq *sq, struct mlx5_wq_cyc *wq,
-			   u16 pi, u16 nnops)
-{
-	struct mlx5e_xdp_wqe_info *edge_wi, *wi = &sq->db.wqe_info[pi];
-
-	edge_wi = wi + nnops;
-	/* fill sq frag edge with nops to avoid wqe wrapping two pages */
-	for (; wi < edge_wi; wi++) {
-		wi->num_wqebbs = 1;
-		wi->num_pkts   = 0;
-		mlx5e_post_nop(wq, sq->sqn, &sq->pc);
-	}
-
-	sq->stats->nops += nnops;
-}
-
 static inline void
 mlx5e_xdp_mpwqe_add_dseg(struct mlx5e_xdpsq *sq,
 			 struct mlx5e_xdp_xmit_data *xdptxd,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
index 717d36b45aa9..ba973937f0b5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
@@ -165,14 +165,8 @@ mlx5e_ktls_tx_post_param_wqes(struct mlx5e_txqsq *sq,
 			      bool skip_static_post, bool fence_first_post)
 {
 	bool progress_fence = skip_static_post || !fence_first_post;
-	struct mlx5_wq_cyc *wq = &sq->wq;
-	u16 contig_wqebbs_room, pi;
 
-	pi = mlx5_wq_cyc_ctr2ix(wq, sq->pc);
-	contig_wqebbs_room = mlx5_wq_cyc_get_contig_wqebbs(wq, pi);
-	if (unlikely(contig_wqebbs_room <
-		     MLX5E_KTLS_STATIC_WQEBBS + MLX5E_KTLS_PROGRESS_WQEBBS))
-		mlx5e_fill_sq_frag_edge(sq, wq, pi, contig_wqebbs_room);
+	mlx5e_txqsq_get_next_pi(sq, MLX5E_KTLS_STATIC_WQEBBS + MLX5E_KTLS_PROGRESS_WQEBBS);
 
 	if (!skip_static_post)
 		post_static_params(sq, priv_tx, fence_first_post);
@@ -346,10 +340,8 @@ mlx5e_ktls_tx_handle_ooo(struct mlx5e_ktls_offload_context_tx *priv_tx,
 			 u32 seq)
 {
 	struct mlx5e_sq_stats *stats = sq->stats;
-	struct mlx5_wq_cyc *wq = &sq->wq;
 	enum mlx5e_ktls_sync_retval ret;
 	struct tx_sync_info info = {};
-	u16 contig_wqebbs_room, pi;
 	u8 num_wqebbs;
 	int i = 0;
 
@@ -380,11 +372,7 @@ mlx5e_ktls_tx_handle_ooo(struct mlx5e_ktls_offload_context_tx *priv_tx,
 	}
 
 	num_wqebbs = mlx5e_ktls_dumps_num_wqebbs(sq, info.nr_frags, info.sync_len);
-	pi = mlx5_wq_cyc_ctr2ix(wq, sq->pc);
-	contig_wqebbs_room = mlx5_wq_cyc_get_contig_wqebbs(wq, pi);
-
-	if (unlikely(contig_wqebbs_room < num_wqebbs))
-		mlx5e_fill_sq_frag_edge(sq, wq, pi, contig_wqebbs_room);
+	mlx5e_txqsq_get_next_pi(sq, num_wqebbs);
 
 	for (; i < info.nr_frags; i++) {
 		unsigned int orig_fsz, frag_offset = 0, n = 0;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 9f33a0e7dd9a..d9a5a669b84d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -468,22 +468,6 @@ static void mlx5e_post_rx_mpwqe(struct mlx5e_rq *rq, u8 n)
 	mlx5_wq_ll_update_db_record(wq);
 }
 
-static inline void mlx5e_fill_icosq_frag_edge(struct mlx5e_icosq *sq,
-					      struct mlx5_wq_cyc *wq,
-					      u16 pi, u16 nnops)
-{
-	struct mlx5e_icosq_wqe_info *edge_wi, *wi = &sq->db.wqe_info[pi];
-
-	edge_wi = wi + nnops;
-
-	/* fill sq frag edge with nops to avoid wqe wrapping two pages */
-	for (; wi < edge_wi; wi++) {
-		wi->opcode = MLX5_OPCODE_NOP;
-		wi->num_wqebbs = 1;
-		mlx5e_post_nop(wq, sq->sqn, &sq->pc);
-	}
-}
-
 static int mlx5e_alloc_rx_mpwqe(struct mlx5e_rq *rq, u16 ix)
 {
 	struct mlx5e_mpw_info *wi = &rq->mpwqe.info[ix];
@@ -492,7 +476,7 @@ static int mlx5e_alloc_rx_mpwqe(struct mlx5e_rq *rq, u16 ix)
 	struct mlx5_wq_cyc *wq = &sq->wq;
 	struct mlx5e_umr_wqe *umr_wqe;
 	u16 xlt_offset = ix << (MLX5E_LOG_ALIGNED_MPWQE_PPW - 1);
-	u16 pi, contig_wqebbs_room;
+	u16 pi;
 	int err;
 	int i;
 
@@ -502,13 +486,7 @@ static int mlx5e_alloc_rx_mpwqe(struct mlx5e_rq *rq, u16 ix)
 		goto err;
 	}
 
-	pi = mlx5_wq_cyc_ctr2ix(wq, sq->pc);
-	contig_wqebbs_room = mlx5_wq_cyc_get_contig_wqebbs(wq, pi);
-	if (unlikely(contig_wqebbs_room < MLX5E_UMR_WQEBBS)) {
-		mlx5e_fill_icosq_frag_edge(sq, wq, pi, contig_wqebbs_room);
-		pi = mlx5_wq_cyc_ctr2ix(wq, sq->pc);
-	}
-
+	pi = mlx5e_icosq_get_next_pi(sq, MLX5E_UMR_WQEBBS);
 	umr_wqe = mlx5_wq_cyc_get_wqe(wq, pi);
 	memcpy(umr_wqe, &rq->mpwqe.umr_wqe, offsetof(struct mlx5e_umr_wqe, inline_mtts));
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
index ec1429596cb7..583e1b201b75 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -572,7 +572,6 @@ netdev_tx_t mlx5i_sq_xmit(struct mlx5e_txqsq *sq, struct sk_buff *skb,
 			  struct mlx5_av *av, u32 dqpn, u32 dqkey,
 			  bool xmit_more)
 {
-	struct mlx5_wq_cyc *wq = &sq->wq;
 	struct mlx5i_tx_wqe *wqe;
 
 	struct mlx5_wqe_datagram_seg *datagram;
@@ -582,9 +581,9 @@ netdev_tx_t mlx5i_sq_xmit(struct mlx5e_txqsq *sq, struct sk_buff *skb,
 	struct mlx5e_tx_wqe_info *wi;
 
 	struct mlx5e_sq_stats *stats = sq->stats;
-	u16 headlen, ihs, pi, contig_wqebbs_room;
 	u16 ds_cnt, ds_cnt_inl = 0;
 	u8 num_wqebbs, opcode;
+	u16 headlen, ihs, pi;
 	u32 num_bytes;
 	int num_dma;
 	__be16 mss;
@@ -620,13 +619,7 @@ netdev_tx_t mlx5i_sq_xmit(struct mlx5e_txqsq *sq, struct sk_buff *skb,
 	}
 
 	num_wqebbs = DIV_ROUND_UP(ds_cnt, MLX5_SEND_WQEBB_NUM_DS);
-	pi = mlx5_wq_cyc_ctr2ix(wq, sq->pc);
-	contig_wqebbs_room = mlx5_wq_cyc_get_contig_wqebbs(wq, pi);
-	if (unlikely(contig_wqebbs_room < num_wqebbs)) {
-		mlx5e_fill_sq_frag_edge(sq, wq, pi, contig_wqebbs_room);
-		pi = mlx5_wq_cyc_ctr2ix(&sq->wq, sq->pc);
-	}
-
+	pi = mlx5e_txqsq_get_next_pi(sq, num_wqebbs);
 	wqe = MLX5I_SQ_FETCH_WQE(sq, pi);
 
 	/* fill wqe */
-- 
2.25.4

