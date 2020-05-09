Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 926891CBF05
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 10:29:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727978AbgEII3o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 04:29:44 -0400
Received: from mail-eopbgr80054.outbound.protection.outlook.com ([40.107.8.54]:50670
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726214AbgEII3n (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 May 2020 04:29:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YxsTrAzzxrd8Dg4VUqCbx8lFnniTGWsXCu7wIIMzntr/1ImRBNVf+0GhLAOQQfGWGvkYQSQYrnxBdry5vFsKbqNxZhOUjvp3j5HXQ4cpWThr6NlzskorbCP5MaDynDJ3X3EAONV8h2PT0IBGi5q4rN1fBMwyVeNjWLh7kuU43EzDXjK4rToLfbwSBkIfz/Z1Co+HTrzEi960qCmkYDumEmQ96CIY9GF/mlxPUJ6nAQKZqvuj8Z4aoslqwnGTSL0ipphTY0MWwVc1VEA6yl5oiFd1v8sUr20m35Qq/gD8a4l8bk52cW2lmtb4+hgTZnjjc/Q67EaOjvQuAUmLE9PHHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o4KoJ608sbO1qeCJqHBHGOWj4Tk+EvcSKgJNuyAlKNM=;
 b=TUXA3DE50yjbvgiI2SNJs1CqN3y6nzNdDOtPLGSPU8N4wasg3rLVU2jCD+Bs9zSwslXWTswiB5zQeQSG9tr6LOJuNZe9PIhfdmBa9IS+0W2ZRARGyFOW3KEN+O6Wai6eIK+EjhFCFLabyh3pATfNxq1CgjW03moqZfp8B+hkhaXSKyfvtk34wMWnzsPFu+JqIkObiDX+ykMXTtsK9xU8STzymdSSq9ESGGrqpK2zpmBF+2UudNR87LQJbVV5AsZUvczkkj3V0p1vprlomawQtL2CHIrQk45TTjyilG+iMx5dRSg6SRdXf3hwzByhZ3ws5fETPK0hI/zLeFoonS1cMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o4KoJ608sbO1qeCJqHBHGOWj4Tk+EvcSKgJNuyAlKNM=;
 b=VNgDOVU9PahxXAz8JzC9MB/VbIPLY0bPbIMYT3ROvVNwcU5TrYcCDwyxKA/xNGY3KFhs+WX4AqQBt7b1BDW3ZAYliLateZtWqQp0ducT1NwbIxB3cycbpQbXSUFmRlZqDt1kDG2Vpsc7DT5KYljcwhOVmOinKFkyYu26NO7M/Ms=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB4813.eurprd05.prod.outlook.com (2603:10a6:803:52::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.29; Sat, 9 May
 2020 08:29:30 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2979.033; Sat, 9 May 2020
 08:29:30 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Maxim Mikityanskiy <maximmi@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 07/13] net/mlx5e: Split TX acceleration offloads into two phases
Date:   Sat,  9 May 2020 01:28:50 -0700
Message-Id: <20200509082856.97337-8-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200509082856.97337-1-saeedm@mellanox.com>
References: <20200509082856.97337-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR07CA0011.namprd07.prod.outlook.com
 (2603:10b6:a02:bc::24) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR07CA0011.namprd07.prod.outlook.com (2603:10b6:a02:bc::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.26 via Frontend Transport; Sat, 9 May 2020 08:29:28 +0000
X-Mailer: git-send-email 2.25.4
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f5b2f500-9c76-4fdb-9be8-08d7f3f31809
X-MS-TrafficTypeDiagnostic: VI1PR05MB4813:|VI1PR05MB4813:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB481376084D07C033265E871CBEA30@VI1PR05MB4813.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 03982FDC1D
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1UWf/h1qDgky+ldEjz6ANwtlsPZBBcTNeEteTY0D3UxMHMY/eY3Ln+ttfFR1sv34ncW8ayZ5RHzJ1hoSCy/5TZ9eP2+ppbwoCiwsyqI0f9RdoKkBIw/w64fQ8zGfK5beIgvaIsfjA/USHE5yQYVJgMO43YB0Rc7rzfN09IkTfNngf8VKCAMZO5r/nQ3eb0szy0TYzK+26I4gUYV7dkEVt98s5jlrRmQ1993HvJEdsnPtRGn8mbLdleWvNH2azccRzH85ACLCiXleA5EHDCqIxAle2b2D5rD8qXR8LPUt9DAFmCAvmI5iEreOqLx4Dm59ij2tKbAO1R8c36i4BaBilswJNJmOS3TFYm6sM0/I6KWAJdGL4fGqEdGdbuiCa4+q65MZa4wyR8Iw5oHanTcLlVlyxiwup7iasqdf3/wCa/3rTkaqymJje+YPJGek/ePblcG6miyfrY75DCG/di3HevUhlvmzY9kmwTrpzQ8QkTxeF5e9iboeiyOhEbQuo4HVkjbcnNBdXhpLAw6LrM3nSLn10O+CLF3rPPC1xO/JbaIJF1IG+3KYf0I3E+TbSnHc
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(136003)(346002)(39860400002)(396003)(366004)(33430700001)(107886003)(66946007)(316002)(2906002)(16526019)(8676002)(956004)(54906003)(66476007)(5660300002)(186003)(478600001)(52116002)(86362001)(4326008)(6512007)(6506007)(2616005)(6666004)(26005)(33440700001)(66556008)(36756003)(30864003)(1076003)(6486002)(8936002)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 7Mh+x+alUfyybw8WibrzV6OJBRn505aiIbRR/5oc+fql3LBCRL2UVUzaTE88FWL8356A3XT6aGYTfFgA8tKSaYamPujS8gbiyyJX1Gn3eDAtLtCt01SOqVHqF1vr3JBVLjDhkvW40cMlo15hNp+KpWIkyz8G3K12ECrogvLEExzdJcsNxDkjvQuA3Q5fP3zpHXCtsb7paxKEv8t4ZPtHTlyZBoPIrIv5MwBTgxfXAZmCCWpH+ty2vlKgMPtlEKTcPYXbMEn4Wjnw0EdaSqQikg4K+/Ub22e1oRO6JlZ7WMnBhM9MVWXhwIJOGeIioqh7vqYEaKU9UWH4/SkQEtmDjqJKT7SHTMz4Hq+YOHfExzE1TsHif2l74YKYgfE1lW7cGFT7cefcfPLups3Q8ypo9z9ElyosFZnqR+tZrmxG/gY/PhfiCQrV3TbxpipXRjraD5jB/DsKqmVmW1Qen0a79uRfPt1t5L97HNazoYwbzlo=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f5b2f500-9c76-4fdb-9be8-08d7f3f31809
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2020 08:29:30.3858
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GiPeYwaUf/nvSR634eQ7nH1zyWqATyx3vB7p5Lvy94d9wKnbx136dUj3hAGs/m/M0/6oOTERslbkbim1muISpw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4813
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>

After previous modifications, the offloads are no longer called one by
one, the pi is calculated and the wqe is cleared on between of TLS and
IPSEC offloads, which doesn't quite fit mlx5e_accel_handle_tx's purpose.

This patch splits mlx5e_accel_handle_tx into two functions that
correspond to two logical phases of running offloads:

1. Before fetching a WQE. Here runs the code that can post WQEs on its
own, before the main WQE is fetched. It's the main part of TLS offload.

2. After fetching a WQE. Here runs the code that updates the WQE's
fields, but can't post other WQEs any more. It's a minor part of TLS
offload that sets the tisn field in the cseg, and eseg-based offloads
(currently IPSEC, and later patches will move GENEVE and checksum
offloads there, too).

It allows to make mlx5e_xmit take care of all actions needed to transmit
a packet in the right order, improve the structure of the code and
reduce unnecessary operations. The structure will be further improved in
the following patches (all eseg-based offloads will be moved to a single
place, and reserving space for the main WQE will happen between phase 1
and phase 2 of offloads to eliminate unneeded data movements).

Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../mellanox/mlx5/core/en_accel/en_accel.h    | 33 ++++++++++++-------
 .../mellanox/mlx5/core/en_accel/ipsec_rxtx.c  |  3 +-
 .../mellanox/mlx5/core/en_accel/ipsec_rxtx.h  |  2 +-
 .../mellanox/mlx5/core/en_accel/ktls.h        |  4 ++-
 .../mellanox/mlx5/core/en_accel/ktls_tx.c     |  5 +--
 .../mellanox/mlx5/core/en_accel/tls_rxtx.c    | 10 ++++--
 .../mellanox/mlx5/core/en_accel/tls_rxtx.h    |  8 ++++-
 .../net/ethernet/mellanox/mlx5/core/en_tx.c   | 10 ++++--
 8 files changed, 52 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
index d286fb09955c..fac145dcf2ce 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
@@ -102,35 +102,44 @@ mlx5e_udp_gso_handle_tx_skb(struct sk_buff *skb)
 	udp_hdr(skb)->len = htons(payload_len);
 }
 
-static inline bool mlx5e_accel_handle_tx(struct sk_buff *skb,
-					 struct mlx5e_txqsq *sq,
-					 struct net_device *dev,
-					 struct mlx5e_tx_wqe **wqe,
-					 u16 *pi)
-{
+struct mlx5e_accel_tx_state {
 #ifdef CONFIG_MLX5_EN_TLS
-	u32 tls_tisn = 0;
+	struct mlx5e_accel_tx_tls_state tls;
 #endif
+};
 
+static inline bool mlx5e_accel_tx_begin(struct net_device *dev,
+					struct mlx5e_txqsq *sq,
+					struct sk_buff *skb,
+					struct mlx5e_accel_tx_state *state)
+{
 	if (skb_is_gso(skb) && skb_shinfo(skb)->gso_type & SKB_GSO_UDP_L4)
 		mlx5e_udp_gso_handle_tx_skb(skb);
 
 #ifdef CONFIG_MLX5_EN_TLS
 	if (test_bit(MLX5E_SQ_STATE_TLS, &sq->state)) {
 		/* May send SKBs and WQEs. */
-		if (unlikely(!mlx5e_tls_handle_tx_skb(dev, sq, skb, &tls_tisn)))
+		if (unlikely(!mlx5e_tls_handle_tx_skb(dev, sq, skb, &state->tls)))
 			return false;
 	}
+#endif
 
-	*pi = mlx5_wq_cyc_ctr2ix(&sq->wq, sq->pc);
-	*wqe = MLX5E_TX_FETCH_WQE(sq, *pi);
+	return true;
+}
 
-	(*wqe)->ctrl.tisn = cpu_to_be32(tls_tisn << 8);
+static inline bool mlx5e_accel_tx_finish(struct mlx5e_priv *priv,
+					 struct mlx5e_txqsq *sq,
+					 struct sk_buff *skb,
+					 struct mlx5e_tx_wqe *wqe,
+					 struct mlx5e_accel_tx_state *state)
+{
+#ifdef CONFIG_MLX5_EN_TLS
+	mlx5e_tls_handle_tx_wqe(sq, &wqe->ctrl, &state->tls);
 #endif
 
 #ifdef CONFIG_MLX5_EN_IPSEC
 	if (test_bit(MLX5E_SQ_STATE_IPSEC, &sq->state)) {
-		if (unlikely(!mlx5e_ipsec_handle_tx_skb(dev, &(*wqe)->eth, skb)))
+		if (unlikely(!mlx5e_ipsec_handle_tx_skb(priv, &wqe->eth, skb)))
 			return false;
 	}
 #endif
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.c
index 0e1ac3e68c72..824b87ac8f9e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.c
@@ -233,11 +233,10 @@ static void mlx5e_ipsec_set_metadata(struct sk_buff *skb,
 		   ntohs(mdata->content.tx.seq));
 }
 
-bool mlx5e_ipsec_handle_tx_skb(struct net_device *netdev,
+bool mlx5e_ipsec_handle_tx_skb(struct mlx5e_priv *priv,
 			       struct mlx5_wqe_eth_seg *eseg,
 			       struct sk_buff *skb)
 {
-	struct mlx5e_priv *priv = netdev_priv(netdev);
 	struct xfrm_offload *xo = xfrm_offload(skb);
 	struct mlx5e_ipsec_metadata *mdata;
 	struct mlx5e_ipsec_sa_entry *sa_entry;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h
index bd6f32aee8d6..ba02643586a5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h
@@ -52,7 +52,7 @@ void mlx5e_ipsec_set_iv_esn(struct sk_buff *skb, struct xfrm_state *x,
 			    struct xfrm_offload *xo);
 void mlx5e_ipsec_set_iv(struct sk_buff *skb, struct xfrm_state *x,
 			struct xfrm_offload *xo);
-bool mlx5e_ipsec_handle_tx_skb(struct net_device *netdev,
+bool mlx5e_ipsec_handle_tx_skb(struct mlx5e_priv *priv,
 			       struct mlx5_wqe_eth_seg *eseg,
 			       struct sk_buff *skb);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h
index 7d9d9420f19d..dabbc5f226ce 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h
@@ -9,6 +9,7 @@
 #ifdef CONFIG_MLX5_EN_TLS
 #include <net/tls.h>
 #include "accel/tls.h"
+#include "en_accel/tls_rxtx.h"
 
 #define MLX5E_KTLS_STATIC_UMR_WQE_SZ \
 	(offsetof(struct mlx5e_umr_wqe, tls_static_params_ctx) + \
@@ -96,7 +97,8 @@ void mlx5e_ktls_build_netdev(struct mlx5e_priv *priv);
 void mlx5e_ktls_tx_offload_set_pending(struct mlx5e_ktls_offload_context_tx *priv_tx);
 
 bool mlx5e_ktls_handle_tx_skb(struct tls_context *tls_ctx, struct mlx5e_txqsq *sq,
-			      struct sk_buff *skb, u32 *tisn, int datalen);
+			      struct sk_buff *skb, int datalen,
+			      struct mlx5e_accel_tx_tls_state *state);
 void mlx5e_ktls_tx_handle_resync_dump_comp(struct mlx5e_txqsq *sq,
 					   struct mlx5e_tx_wqe_info *wi,
 					   u32 *dma_fifo_cc);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
index b49d7c1e49dc..352b0a3ef0ad 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
@@ -414,7 +414,8 @@ mlx5e_ktls_tx_handle_ooo(struct mlx5e_ktls_offload_context_tx *priv_tx,
 }
 
 bool mlx5e_ktls_handle_tx_skb(struct tls_context *tls_ctx, struct mlx5e_txqsq *sq,
-			      struct sk_buff *skb, u32 *tisn, int datalen)
+			      struct sk_buff *skb, int datalen,
+			      struct mlx5e_accel_tx_tls_state *state)
 {
 	struct mlx5e_ktls_offload_context_tx *priv_tx;
 	struct mlx5e_sq_stats *stats = sq->stats;
@@ -447,7 +448,7 @@ bool mlx5e_ktls_handle_tx_skb(struct tls_context *tls_ctx, struct mlx5e_txqsq *s
 
 	priv_tx->expected_seq = seq + datalen;
 
-	*tisn = priv_tx->tisn;
+	state->tls_tisn = priv_tx->tisn;
 
 	stats->tls_encrypted_packets += skb_is_gso(skb) ? skb_shinfo(skb)->gso_segs : 1;
 	stats->tls_encrypted_bytes   += datalen;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c
index 8e6b0b0ce2e4..05454a843b28 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c
@@ -258,7 +258,7 @@ static bool mlx5e_tls_handle_ooo(struct mlx5e_tls_offload_context_tx *context,
 }
 
 bool mlx5e_tls_handle_tx_skb(struct net_device *netdev, struct mlx5e_txqsq *sq,
-			     struct sk_buff *skb, u32 *tisn)
+			     struct sk_buff *skb, struct mlx5e_accel_tx_tls_state *state)
 {
 	struct mlx5e_priv *priv = netdev_priv(netdev);
 	struct mlx5e_tls_offload_context_tx *context;
@@ -279,7 +279,7 @@ bool mlx5e_tls_handle_tx_skb(struct net_device *netdev, struct mlx5e_txqsq *sq,
 		goto err_out;
 
 	if (MLX5_CAP_GEN(sq->channel->mdev, tls_tx))
-		return mlx5e_ktls_handle_tx_skb(tls_ctx, sq, skb, tisn, datalen);
+		return mlx5e_ktls_handle_tx_skb(tls_ctx, sq, skb, datalen, state);
 
 	skb_seq = ntohl(tcp_hdr(skb)->seq);
 	context = mlx5e_get_tls_tx_context(tls_ctx);
@@ -302,6 +302,12 @@ bool mlx5e_tls_handle_tx_skb(struct net_device *netdev, struct mlx5e_txqsq *sq,
 	return false;
 }
 
+void mlx5e_tls_handle_tx_wqe(struct mlx5e_txqsq *sq, struct mlx5_wqe_ctrl_seg *cseg,
+			     struct mlx5e_accel_tx_tls_state *state)
+{
+	cseg->tisn = cpu_to_be32(state->tls_tisn << 8);
+}
+
 static int tls_update_resync_sn(struct net_device *netdev,
 				struct sk_buff *skb,
 				struct mlx5e_tls_metadata *mdata)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.h
index 3630ed8b1206..a50d0394df0a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.h
@@ -40,8 +40,14 @@
 #include "en.h"
 #include "en/txrx.h"
 
+struct mlx5e_accel_tx_tls_state {
+	u32 tls_tisn;
+};
+
 bool mlx5e_tls_handle_tx_skb(struct net_device *netdev, struct mlx5e_txqsq *sq,
-			     struct sk_buff *skb, u32 *tisn);
+			     struct sk_buff *skb, struct mlx5e_accel_tx_tls_state *state);
+void mlx5e_tls_handle_tx_wqe(struct mlx5e_txqsq *sq, struct mlx5_wqe_ctrl_seg *cseg,
+			     struct mlx5e_accel_tx_tls_state *state);
 
 void mlx5e_tls_handle_rx_skb(struct net_device *netdev, struct sk_buff *skb,
 			     u32 *cqe_bcnt);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
index bb6d3774eafb..f79454746d0d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -383,16 +383,22 @@ void mlx5e_sq_xmit(struct mlx5e_txqsq *sq, struct sk_buff *skb,
 netdev_tx_t mlx5e_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct mlx5e_priv *priv = netdev_priv(dev);
+	struct mlx5e_accel_tx_state accel = {};
 	struct mlx5e_tx_wqe *wqe;
 	struct mlx5e_txqsq *sq;
 	u16 pi;
 
 	sq = priv->txq2sq[skb_get_queue_mapping(skb)];
+
+	/* May send SKBs and WQEs. */
+	if (unlikely(!mlx5e_accel_tx_begin(dev, sq, skb, &accel)))
+		goto out;
+
 	pi = mlx5_wq_cyc_ctr2ix(&sq->wq, sq->pc);
 	wqe = MLX5E_TX_FETCH_WQE(sq, pi);
 
-	/* might send skbs and update wqe and pi */
-	if (unlikely(!mlx5e_accel_handle_tx(skb, sq, dev, &wqe, &pi)))
+	/* May update the WQE, but may not post other WQEs. */
+	if (unlikely(!mlx5e_accel_tx_finish(priv, sq, skb, wqe, &accel)))
 		goto out;
 
 	mlx5e_sq_xmit(sq, skb, wqe, pi, netdev_xmit_more());
-- 
2.25.4

