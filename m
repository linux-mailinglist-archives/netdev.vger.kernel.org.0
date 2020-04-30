Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 139D31C03D7
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 19:23:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726645AbgD3RWp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 13:22:45 -0400
Received: from mail-eopbgr00053.outbound.protection.outlook.com ([40.107.0.53]:60730
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726478AbgD3RWp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 13:22:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cMPqom6uJOqkg1bIb3YKZjlYTeXnp2y2mRgRBFRf0N2KdUhP2XN/8RaHLkhIlmErxJJMbbilXVVRSUqKMBDCTYMYJVJ1AKXj5vrj6ZNU/9kwpIdp2XSD+7xEIOw54c7xu8A3CozAOQGVAa4YhPW/+PWLNncuRwqbK032OxJ3UYv+bw7jnCJ2wnNr6VATYAcw3eFzYYlvncVUtxqGK9EElZ9F137Vs+iJy1d+Uydlk22E2q7K1SQX262c6nHOBOPR6x9m8WlJOsUYx9iWwh7TwzJwSkoQhjmnFihakChmnYiX26CWoKzx5JaUNQD1VR+8Lo3MREexVqH4et0tbsUlxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z3KChmF/NukwusIE31dAmpF2cuV3uN7Ezw0J7TBvTlY=;
 b=KgopS0PAAeF9U03T30xvU/yKwhdWQlU5jURALsK2Gt+GHRpNS0MqwSMfJ+e8wi90aIIMxyuxESh5SfxK6gndk6mp8HmsYa2ckyh0+B2Shtd5zXcz85/lo2WXLNpl3YSfwnhcUOhmT01cAvlrsA+m9z5OODMyTB84ddzpXGZO5rpGV745AlfClo0jEFXfKUrOQzq0A4uqN+90nYdjxOminHsU5EpqFcDF8v7sRwmtAZaBemF8Q0seUce1pRDBlVIVLqO3tJOs6Yg8NB9ZY7ECCurs1m2j5UJ+mtHjMaLaZVXodwHTalvTfpmv8hLVNtpMGdWxPGtDLeqhjhDvc03vJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z3KChmF/NukwusIE31dAmpF2cuV3uN7Ezw0J7TBvTlY=;
 b=VzTt+FHZFC4riaTEi7tamF182/WJ0QtWg/qXNUnjJbDPaTa5hHbonfG0WBTv3fmMhob0HJ3SKVz+bsQ4G1MNfvFCO1yEaEYYDhwgybZSwpJ/tgSqfEFa5I7Jg9MNviqDhmNf+IsdnQmGHWFzhee2NWvJEZP01cOGdZtLN7650Ag=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB3296.eurprd05.prod.outlook.com (2603:10a6:802:1c::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20; Thu, 30 Apr
 2020 17:21:26 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2937.028; Thu, 30 Apr 2020
 17:21:26 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Maxim Mikityanskiy <maximmi@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 13/15] net/mlx5e: Fetch WQE: reuse code and enforce typing
Date:   Thu, 30 Apr 2020 10:18:33 -0700
Message-Id: <20200430171835.20812-14-saeedm@mellanox.com>
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
Received: from smtp.office365.com (73.15.39.150) by BY5PR17CA0030.namprd17.prod.outlook.com (2603:10b6:a03:1b8::43) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20 via Frontend Transport; Thu, 30 Apr 2020 17:21:24 +0000
X-Mailer: git-send-email 2.25.4
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e3ad754c-b4ca-4c22-7117-08d7ed2ae9b4
X-MS-TrafficTypeDiagnostic: VI1PR05MB3296:|VI1PR05MB3296:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB329662F8DFA0EEE3BD93C325BEAA0@VI1PR05MB3296.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:459;
X-Forefront-PRVS: 0389EDA07F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KmVVdXhdHC3EbkJr74UnEH6K8Ck4v1tPNOZPyaZuBcaxWZ4kF4R3O3wzmB6wMdi+a3/XGUSnZg7iZwcnhMnh+96OzfjzE9k0aTpmynQIrLdQHqXGqsbo694eOFGr3TPzx+nQWoft9wmdEK5LS9BQE+v3gnd6FEegrs0H04bJx1JcBBwz+Rk4itH3CV4XM6P+6zCms0rBzYuhzOnG4NdvRUChIdG2/snFBSiWaJZ/Wuy11i7SXKarAzpMrVzX4boqeM6VtuA/I1R+Z9BLiFUZDCzyhE+C5Y1TXRezdMyKaCT0Jf/L1nMzRF/e4uo+YfKljspxLPiYgFJasvjK5P9LhZs57vKXwlrSL3A8LUse/C4tIHcR8FJCY5AWqy9AdL7H3k6SrqcdBMiufPNgIaM9C42/f0L9Alp9hC4x8dBPIaalqTM6dEBc7mqhcXgQA31/Czjn+rOMo46b+JT5gTZCz9NdmY8ueOJhKlv5oCtm50Iyd4p2115iu08+eU12CRIM
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(376002)(39860400002)(366004)(136003)(346002)(52116002)(6666004)(54906003)(2616005)(956004)(316002)(2906002)(478600001)(107886003)(4326008)(66946007)(86362001)(66476007)(66556008)(36756003)(6486002)(16526019)(186003)(26005)(8936002)(6512007)(8676002)(6506007)(1076003)(30864003)(5660300002)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: BIZONLINjMMuB55nbtP8ZqQ6DdyAd3TNrEmdqceCq5ntIJqpffT57OfLRUtYSoG11iMuvb97XWxX9j5SFYb+tQGj/7UzcKXDCXYzymLyhf03c1eyNjqFioh3iPcrPebnnWTMECj7jh7cUPS9smIbi7XljYkAjxHNJ1/JCCQQwhyNz891J3if0+Kvbr/2MP9dFtuFPnGZMm/JarpyRmBUFM+wrer7r2G5KWtGXl43UEvCwLBMu5Gs1gFl7jzarKbeCOCcyECNptk5Rsdz41B5jiO60w/z9VODoooeEK3yAcI7yutTYp1nHSMUCNcWCmBlhADvpec0ppyvhdEXgw4FR1usR1RaRD0jZTIM8pldkNhPKoGCCMfaUZQJWreycva71otAuO8dCEUpzj+aNB4FM3UqQwwZK1yJSSswZBm+cQz9rVLcVKf/TR/9/tZEz1tn4Iwk5As8tz2QLQePbFbONKIbl8AK5bAvmWCxzKtYTXVSkEMttMK23D1ekCaJEpDwrRBcKMdzib4RcywxxWck4qLd4VZwuXa5FaLx4nKCC7Cbli1TJ7cEZH+KFb/F1IPv9Jd5ArOlo1+q8P4xniuvNE/0P6xAPB6iAzdRs8kEyrIh8pcM6pX0WEJLbXScvTmYtm9x+G6YyyoBolOIaCuMDt+jG8/LKN6mdIHGwSIlTXTLqQmNry0Cb6fKor5/aHQrpgRp5F6VtQdNXHfjDtEMby8jb1PYmxf32Wqm12I9kUFeZk7aoJf85cbr/8Pddm49O1yyXcl5vE7iSk9J6qtzr8+4FSIE0l+cmySUarnwvWI=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e3ad754c-b4ca-4c22-7117-08d7ed2ae9b4
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2020 17:21:26.3679
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a/Soyha8D5HXS84sSNGFDOSflmuLnduLR0jaMmoAGiiSZKTHeSDnf4N+1ctLzOLPUTa41bMOX89LbRuxYticsg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3296
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>

There are multiple functions mlx5{e,i}_*_fetch_wqe that contain the same
code, that is repeated, because they operate on different SQ struct
types. mlx5e_sq_fetch_wqe also returns void *, instead of the concrete
WQE type.

This commit generalizes the fetch WQE operation by putting this code
into a single function. To simplify calls of the generic function in
concrete use cases, macros are provided that substitute the right WQE
size and cast the return type.

Before this patch, fetch_wqe used to calculate pi itself, but the value
was often known to the caller. This calculation is moved outside to
eliminate this unnecessary step and prepare for the fill_frag_edge
refactoring in the next patch.

Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h | 12 ++++++------
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c  |  6 ++++--
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h  | 13 -------------
 .../ethernet/mellanox/mlx5/core/en_accel/ktls.h   |  8 ++++++++
 .../mellanox/mlx5/core/en_accel/ktls_tx.c         | 15 ++++++++++-----
 .../mellanox/mlx5/core/en_accel/tls_rxtx.c        |  3 ++-
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c   | 10 ++++++----
 .../net/ethernet/mellanox/mlx5/core/ipoib/ipoib.h | 11 ++---------
 8 files changed, 38 insertions(+), 40 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
index c0249fc77eaa..8682d9148ab9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
@@ -33,19 +33,19 @@ mlx5e_wqc_has_room_for(struct mlx5_wq_cyc *wq, u16 cc, u16 pc, u16 n)
 	return (mlx5_wq_cyc_ctr2ix(wq, cc - pc) >= n) || (cc == pc);
 }
 
-static inline void *
-mlx5e_sq_fetch_wqe(struct mlx5e_txqsq *sq, size_t size, u16 *pi)
+static inline void *mlx5e_fetch_wqe(struct mlx5_wq_cyc *wq, u16 pi, size_t wqe_size)
 {
-	struct mlx5_wq_cyc *wq = &sq->wq;
 	void *wqe;
 
-	*pi  = mlx5_wq_cyc_ctr2ix(wq, sq->pc);
-	wqe = mlx5_wq_cyc_get_wqe(wq, *pi);
-	memset(wqe, 0, size);
+	wqe = mlx5_wq_cyc_get_wqe(wq, pi);
+	memset(wqe, 0, wqe_size);
 
 	return wqe;
 }
 
+#define MLX5E_TX_FETCH_WQE(sq, pi) \
+	((struct mlx5e_tx_wqe *)mlx5e_fetch_wqe(&(sq)->wq, pi, sizeof(struct mlx5e_tx_wqe)))
+
 static inline struct mlx5e_tx_wqe *
 mlx5e_post_nop(struct mlx5_wq_cyc *wq, u32 sqn, u16 *pc)
 {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
index 6f32a697a4bf..cf089520c031 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
@@ -188,10 +188,12 @@ static void mlx5e_xdp_mpwqe_session_start(struct mlx5e_xdpsq *sq)
 	pi = mlx5_wq_cyc_ctr2ix(wq, sq->pc);
 	contig_wqebbs = mlx5_wq_cyc_get_contig_wqebbs(wq, pi);
 
-	if (unlikely(contig_wqebbs < MLX5_SEND_WQE_MAX_WQEBBS))
+	if (unlikely(contig_wqebbs < MLX5_SEND_WQE_MAX_WQEBBS)) {
 		mlx5e_fill_xdpsq_frag_edge(sq, wq, pi, contig_wqebbs);
+		pi = mlx5_wq_cyc_ctr2ix(wq, sq->pc);
+	}
 
-	session->wqe = mlx5e_xdpsq_fetch_wqe(sq, &pi);
+	session->wqe = MLX5E_TX_FETCH_WQE(sq, pi);
 
 	prefetchw(session->wqe->data);
 	session->ds_count  = MLX5E_XDP_TX_EMPTY_DS_COUNT;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
index d7587f40ecae..4fd0ff47bdc3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
@@ -186,19 +186,6 @@ mlx5e_xdp_mpwqe_add_dseg(struct mlx5e_xdpsq *sq,
 	session->ds_count++;
 }
 
-static inline struct mlx5e_tx_wqe *
-mlx5e_xdpsq_fetch_wqe(struct mlx5e_xdpsq *sq, u16 *pi)
-{
-	struct mlx5_wq_cyc *wq = &sq->wq;
-	struct mlx5e_tx_wqe *wqe;
-
-	*pi = mlx5_wq_cyc_ctr2ix(wq, sq->pc);
-	wqe = mlx5_wq_cyc_get_wqe(wq, *pi);
-	memset(wqe, 0, sizeof(*wqe));
-
-	return wqe;
-}
-
 static inline void
 mlx5e_xdpi_fifo_push(struct mlx5e_xdp_info_fifo *fifo,
 		     struct mlx5e_xdp_info *xi)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h
index 63116be6b1d6..9daaec244385 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h
@@ -27,6 +27,14 @@ struct mlx5e_dump_wqe {
 	struct mlx5_wqe_data_seg data;
 };
 
+#define MLX5E_TLS_FETCH_UMR_WQE(sq, pi) \
+	((struct mlx5e_umr_wqe *)mlx5e_fetch_wqe(&(sq)->wq, pi, MLX5E_KTLS_STATIC_UMR_WQE_SZ))
+#define MLX5E_TLS_FETCH_PROGRESS_WQE(sq, pi) \
+	((struct mlx5e_tx_wqe *)mlx5e_fetch_wqe(&(sq)->wq, pi, MLX5E_KTLS_PROGRESS_WQE_SZ))
+#define MLX5E_TLS_FETCH_DUMP_WQE(sq, pi) \
+	((struct mlx5e_dump_wqe *)mlx5e_fetch_wqe(&(sq)->wq, pi, \
+						  sizeof(struct mlx5e_dump_wqe)))
+
 #define MLX5E_KTLS_DUMP_WQEBBS \
 	(DIV_ROUND_UP(sizeof(struct mlx5e_dump_wqe), MLX5_SEND_WQE_BB))
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
index 52a56622034a..717d36b45aa9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
@@ -137,7 +137,8 @@ post_static_params(struct mlx5e_txqsq *sq,
 	struct mlx5e_umr_wqe *umr_wqe;
 	u16 pi;
 
-	umr_wqe = mlx5e_sq_fetch_wqe(sq, MLX5E_KTLS_STATIC_UMR_WQE_SZ, &pi);
+	pi = mlx5_wq_cyc_ctr2ix(&sq->wq, sq->pc);
+	umr_wqe = MLX5E_TLS_FETCH_UMR_WQE(sq, pi);
 	build_static_params(umr_wqe, sq->pc, sq->sqn, priv_tx, fence);
 	tx_fill_wi(sq, pi, MLX5E_KTLS_STATIC_WQEBBS, 0, NULL);
 	sq->pc += MLX5E_KTLS_STATIC_WQEBBS;
@@ -151,7 +152,8 @@ post_progress_params(struct mlx5e_txqsq *sq,
 	struct mlx5e_tx_wqe *wqe;
 	u16 pi;
 
-	wqe = mlx5e_sq_fetch_wqe(sq, MLX5E_KTLS_PROGRESS_WQE_SZ, &pi);
+	pi = mlx5_wq_cyc_ctr2ix(&sq->wq, sq->pc);
+	wqe = MLX5E_TLS_FETCH_PROGRESS_WQE(sq, pi);
 	build_progress_params(wqe, sq->pc, sq->sqn, priv_tx, fence);
 	tx_fill_wi(sq, pi, MLX5E_KTLS_PROGRESS_WQEBBS, 0, NULL);
 	sq->pc += MLX5E_KTLS_PROGRESS_WQEBBS;
@@ -278,7 +280,8 @@ tx_post_resync_dump(struct mlx5e_txqsq *sq, skb_frag_t *frag, u32 tisn, bool fir
 	int fsz;
 	u16 pi;
 
-	wqe = mlx5e_sq_fetch_wqe(sq, sizeof(*wqe), &pi);
+	pi = mlx5_wq_cyc_ctr2ix(&sq->wq, sq->pc);
+	wqe = MLX5E_TLS_FETCH_DUMP_WQE(sq, pi);
 
 	ds_cnt = sizeof(*wqe) / MLX5_SEND_WQE_DS;
 
@@ -449,7 +452,8 @@ struct sk_buff *mlx5e_ktls_handle_tx_skb(struct net_device *netdev,
 
 	if (unlikely(mlx5e_ktls_tx_offload_test_and_clear_pending(priv_tx))) {
 		mlx5e_ktls_tx_post_param_wqes(sq, priv_tx, false, false);
-		*wqe = mlx5e_sq_fetch_wqe(sq, sizeof(**wqe), pi);
+		*pi = mlx5_wq_cyc_ctr2ix(&sq->wq, sq->pc);
+		*wqe = MLX5E_TX_FETCH_WQE(sq, *pi);
 		stats->tls_ctx++;
 	}
 
@@ -460,7 +464,8 @@ struct sk_buff *mlx5e_ktls_handle_tx_skb(struct net_device *netdev,
 
 		switch (ret) {
 		case MLX5E_KTLS_SYNC_DONE:
-			*wqe = mlx5e_sq_fetch_wqe(sq, sizeof(**wqe), pi);
+			*pi = mlx5_wq_cyc_ctr2ix(&sq->wq, sq->pc);
+			*wqe = MLX5E_TX_FETCH_WQE(sq, *pi);
 			break;
 		case MLX5E_KTLS_SYNC_SKIP_NO_DATA:
 			if (likely(!skb->decrypted))
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c
index ef1ed15a53b4..1d7ddeb7a46b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c
@@ -248,7 +248,8 @@ mlx5e_tls_handle_ooo(struct mlx5e_tls_offload_context_tx *context,
 	mlx5e_tls_complete_sync_skb(skb, nskb, tcp_seq, headln,
 				    cpu_to_be64(info.rcd_sn));
 	mlx5e_sq_xmit(sq, nskb, *wqe, *pi, true);
-	*wqe = mlx5e_sq_fetch_wqe(sq, sizeof(**wqe), pi);
+	*pi = mlx5_wq_cyc_ctr2ix(&sq->wq, sq->pc);
+	*wqe = MLX5E_TX_FETCH_WQE(sq, *pi);
 	return skb;
 
 err_out:
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
index 1679557f34c0..ec1429596cb7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -324,7 +324,8 @@ netdev_tx_t mlx5e_sq_xmit(struct mlx5e_txqsq *sq, struct sk_buff *skb,
 		struct mlx5_wqe_ctrl_seg cur_ctrl = wqe->ctrl;
 #endif
 		mlx5e_fill_sq_frag_edge(sq, wq, pi, contig_wqebbs_room);
-		wqe = mlx5e_sq_fetch_wqe(sq, sizeof(*wqe), &pi);
+		pi = mlx5_wq_cyc_ctr2ix(wq, sq->pc);
+		wqe = MLX5E_TX_FETCH_WQE(sq, pi);
 #ifdef CONFIG_MLX5_EN_IPSEC
 		wqe->eth = cur_eth;
 #endif
@@ -389,7 +390,8 @@ netdev_tx_t mlx5e_xmit(struct sk_buff *skb, struct net_device *dev)
 	u16 pi;
 
 	sq = priv->txq2sq[skb_get_queue_mapping(skb)];
-	wqe = mlx5e_sq_fetch_wqe(sq, sizeof(*wqe), &pi);
+	pi = mlx5_wq_cyc_ctr2ix(&sq->wq, sq->pc);
+	wqe = MLX5E_TX_FETCH_WQE(sq, pi);
 
 	/* might send skbs and update wqe and pi */
 	skb = mlx5e_accel_handle_tx(skb, sq, dev, &wqe, &pi);
@@ -622,10 +624,10 @@ netdev_tx_t mlx5i_sq_xmit(struct mlx5e_txqsq *sq, struct sk_buff *skb,
 	contig_wqebbs_room = mlx5_wq_cyc_get_contig_wqebbs(wq, pi);
 	if (unlikely(contig_wqebbs_room < num_wqebbs)) {
 		mlx5e_fill_sq_frag_edge(sq, wq, pi, contig_wqebbs_room);
-		pi = mlx5_wq_cyc_ctr2ix(wq, sq->pc);
+		pi = mlx5_wq_cyc_ctr2ix(&sq->wq, sq->pc);
 	}
 
-	mlx5i_sq_fetch_wqe(sq, &wqe, pi);
+	wqe = MLX5I_SQ_FETCH_WQE(sq, pi);
 
 	/* fill wqe */
 	wi       = &sq->db.wqe_info[pi];
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.h b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.h
index 3483ba642cfe..7844ab5d0ce7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.h
@@ -110,15 +110,8 @@ struct mlx5i_tx_wqe {
 	struct mlx5_wqe_data_seg     data[];
 };
 
-static inline void mlx5i_sq_fetch_wqe(struct mlx5e_txqsq *sq,
-				      struct mlx5i_tx_wqe **wqe,
-				      u16 pi)
-{
-	struct mlx5_wq_cyc *wq = &sq->wq;
-
-	*wqe = mlx5_wq_cyc_get_wqe(wq, pi);
-	memset(*wqe, 0, sizeof(**wqe));
-}
+#define MLX5I_SQ_FETCH_WQE(sq, pi) \
+	((struct mlx5i_tx_wqe *)mlx5e_fetch_wqe(&(sq)->wq, pi, sizeof(struct mlx5i_tx_wqe)))
 
 netdev_tx_t mlx5i_sq_xmit(struct mlx5e_txqsq *sq, struct sk_buff *skb,
 			  struct mlx5_av *av, u32 dqpn, u32 dqkey,
-- 
2.25.4

