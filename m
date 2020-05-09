Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30C861CBEFF
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 10:29:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727930AbgEII3Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 04:29:24 -0400
Received: from mail-eopbgr80077.outbound.protection.outlook.com ([40.107.8.77]:60182
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727785AbgEII3X (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 May 2020 04:29:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jTDp4bh4wAdFaQ/anX+WzZ9BdlwHV34yib+JAYD7uZCN+z0kfOr5XwqF9taiUzrUTbg3tfRm1Kgcq6CszMe4Eifn28U873ii5U/AxPIrDUSI0bT97bFVtT0rXOG2AKnhKBFK4pp6MgFNjzU/ywl5a7oLLcRS158o/7zumMFG/9fwkHp7IrnK7kW/bXrryH5sV5dysCX7uGv9ch/oEJDTN9YVlf1ycw9vq1/8R4v6NQGJOQ7cApwXIgfV2KAi0k0a+Cry732kywFVZHRbnBcK1QLsPmlmfjHvTiUfxzBGUks1A04UUYIw/XzXV1on5YK9JYjJ+SluUMoHHfR8iUt/UQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h3JnDGZ35CBj9Dj/BZAiHQM0KRR1LPfKU1KZPAw0IMg=;
 b=Yuqc7drgGn/aZfNUuF5xRtKFswjcOCcx8n2AiN/h4Hp9uP5D+CtQLVx8e4JMAFuWyY0ms0Yp688SRyzt3mrqTRYyfydcKEQ3cUfGRfjQlQugL2oECv84SJeC5hqx3DDkY8df78OklOgkWjlp7hN7/Q6A9mY3/u9Qvrd4QwYBnPKYpnHY+8j/Rm/H7VYN5DfRKmCpoQBWWrQl3gXf3kJEWWrrh9pjlg368f11R/7bqPUIwSWZSJSWcoezMo0zrm0bbIPl5JkPHC9FcFEzigS/TUXxWIPgZFbg1yevtWemp6/HdaYsrwOhUpcyomLJ9TIC3AgwHV/gK36BX5wvFLQpgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h3JnDGZ35CBj9Dj/BZAiHQM0KRR1LPfKU1KZPAw0IMg=;
 b=XtjwHyjnwdGM+XfvcbHcPtnCVp0DaW0l38AmmH83Ax3tUWSfDo5ISK2/7nGuOH+UYwnH4fACaicZZ5UnJLAN8Fdr4tfVXEcGtD8WVfCxvM3Kh9xGoz7Nny2i9RNkBB4DO3/gRbIq9ViApy0DOUjOlNF3i8992ZMOVG32/iggMQQ=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB4813.eurprd05.prod.outlook.com (2603:10a6:803:52::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.29; Sat, 9 May
 2020 08:29:17 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2979.033; Sat, 9 May 2020
 08:29:17 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Maxim Mikityanskiy <maximmi@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 01/13] net/mlx5e: Return bool from TLS and IPSEC offloads
Date:   Sat,  9 May 2020 01:28:44 -0700
Message-Id: <20200509082856.97337-2-saeedm@mellanox.com>
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
Received: from smtp.office365.com (73.15.39.150) by BYAPR07CA0011.namprd07.prod.outlook.com (2603:10b6:a02:bc::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.26 via Frontend Transport; Sat, 9 May 2020 08:29:14 +0000
X-Mailer: git-send-email 2.25.4
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 6bb287a1-9ea6-440e-8c59-08d7f3f30fec
X-MS-TrafficTypeDiagnostic: VI1PR05MB4813:|VI1PR05MB4813:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB48135D4DFABC34B81558D4A6BEA30@VI1PR05MB4813.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 03982FDC1D
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rVurbufS922wFGVv9G33XlesrX1zFo/naKnbyHdCgFq+Zga1dthfZFJjzRVT9OON7uNFz1GfP5M7/VYMsmnlxRqJ/xGfJNFNl++8ppr5N2cF1ftybpSddGGuQxPuOVG8NRO0yzyZj8ubBngBaxrS5Ny8P9YNlD1xLfzixX8OpK9C+UgrJK60LPiIZfyQxsp7oMnGjleQIGG8KUvud8EsdzI3We4LRmjfj+2rqj1biPhTzvA36xHIijZN5+vQE5yLgDOPlhOItp8NF18CmAKoq516+2ryAZgX9k0CInyVQJr4zwNaZZ0yR/Tc3XIz06k9H6ggo+VuFumytRCKD/ZV2YSHezCexNOSofAzzvDRjJWNyaLOJjWcgGrUiiWqRP1SkKni1plRFmLCKqaYmATpjC0mm9SwPJgfSnX4v7zLvtMAxMVAoz+s1hfTXtHQHQ6ujpeebAb52LssDPNU92xYn6Yyyn+UdNNTnPhy52bA+iE82eDJe5OAw/Frk8py2w8jGINFaEZlO72+UhvJi+oU5+KeNM8BjlBpRiDSY1HtyvirytG0PMgo3ehvDWF2f8QM
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(396003)(346002)(136003)(39860400002)(376002)(33430700001)(26005)(6506007)(2616005)(6666004)(4326008)(6512007)(30864003)(1076003)(6486002)(36756003)(8936002)(33440700001)(66556008)(66476007)(5660300002)(54906003)(956004)(8676002)(316002)(107886003)(66946007)(2906002)(16526019)(52116002)(86362001)(186003)(478600001)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: ApOGrV9aZQNV5nvd9XFagqS0/MZbqly9P/87FrDCvOPPNfXh3D+rx73SE97wkofpQyVd7GI8AIUJmyCybqI9bbzlANajCB0iIkyZKwUuGcyHrzepQcLPhpLWyCAxb6v4vSeCRSckvXoh/7meMbEhE2JyhmSKCiD/LG7fO88d95bcNdmturQJ/lW479sgdvM0YQ88Q2fra6eLoUteNhMVoxJTyYACj/XJmZ2Idvqv0pGIXUUQ19JKMkpvf/UWZV3AXmg95q/sPufd+fG1g7VizmAhtYll/IAQ0i+RzIEdejDe/LHPWc0f9rGRduyYF6TkzTEJkJUfUzruwXpdTtOeTpDCXhN9uOPj6gMicGM3afYhJKUtFIbkZveNvgExPvbyPnn1PaKcbwoIgiZqjEVl2UzsJeDCN6iI4WFfiPpZZI9MxtskuVs9fHIAM2OD8fbF97WZOPjUquacgsYhRu0QG5i1T/vleiA0l8FFTkWvM+U=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6bb287a1-9ea6-440e-8c59-08d7f3f30fec
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2020 08:29:16.9635
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h5KZ0SRb67xgDNgEqMFp7KXRroTP75YBB74oVHAJmLsnutxl3v0m80USSnp/vRh3NLEFyKQBbBhiy7xaw1fsFA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4813
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>

TLS and IPSEC offloads currently return struct sk_buff *, but the value
is either NULL or the same skb that was passed as a parameter. Return
bool instead to provide stronger guarantees to the calling code (it
won't need to support handling a different SKB that could be potentially
returned before this change) and to simplify restructuring this code in
the following commits.

Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../mellanox/mlx5/core/en_accel/en_accel.h    | 23 ++++-----
 .../mellanox/mlx5/core/en_accel/ipsec_rxtx.c  | 12 ++---
 .../mellanox/mlx5/core/en_accel/ipsec_rxtx.h  |  6 +--
 .../mellanox/mlx5/core/en_accel/ktls.h        |  7 ++-
 .../mellanox/mlx5/core/en_accel/ktls_tx.c     | 11 ++---
 .../mellanox/mlx5/core/en_accel/tls_rxtx.c    | 48 ++++++++-----------
 .../mellanox/mlx5/core/en_accel/tls_rxtx.h    |  8 ++--
 .../net/ethernet/mellanox/mlx5/core/en_tx.c   |  3 +-
 8 files changed, 50 insertions(+), 68 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
index a6f65d4b2f36..6249998444c0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
@@ -102,33 +102,30 @@ mlx5e_udp_gso_handle_tx_skb(struct sk_buff *skb)
 	udp_hdr(skb)->len = htons(payload_len);
 }
 
-static inline struct sk_buff *
-mlx5e_accel_handle_tx(struct sk_buff *skb,
-		      struct mlx5e_txqsq *sq,
-		      struct net_device *dev,
-		      struct mlx5e_tx_wqe **wqe,
-		      u16 *pi)
+static inline bool mlx5e_accel_handle_tx(struct sk_buff *skb,
+					 struct mlx5e_txqsq *sq,
+					 struct net_device *dev,
+					 struct mlx5e_tx_wqe **wqe,
+					 u16 *pi)
 {
 #ifdef CONFIG_MLX5_EN_TLS
 	if (test_bit(MLX5E_SQ_STATE_TLS, &sq->state)) {
-		skb = mlx5e_tls_handle_tx_skb(dev, sq, skb, wqe, pi);
-		if (unlikely(!skb))
-			return NULL;
+		if (unlikely(!mlx5e_tls_handle_tx_skb(dev, sq, skb, wqe, pi)))
+			return false;
 	}
 #endif
 
 #ifdef CONFIG_MLX5_EN_IPSEC
 	if (test_bit(MLX5E_SQ_STATE_IPSEC, &sq->state)) {
-		skb = mlx5e_ipsec_handle_tx_skb(dev, *wqe, skb);
-		if (unlikely(!skb))
-			return NULL;
+		if (unlikely(!mlx5e_ipsec_handle_tx_skb(dev, *wqe, skb)))
+			return false;
 	}
 #endif
 
 	if (skb_is_gso(skb) && skb_shinfo(skb)->gso_type & SKB_GSO_UDP_L4)
 		mlx5e_udp_gso_handle_tx_skb(skb);
 
-	return skb;
+	return true;
 }
 
 #endif /* __MLX5E_EN_ACCEL_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.c
index 0dd17514caae..f60eb6a4b57c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.c
@@ -233,9 +233,9 @@ static void mlx5e_ipsec_set_metadata(struct sk_buff *skb,
 		   ntohs(mdata->content.tx.seq));
 }
 
-struct sk_buff *mlx5e_ipsec_handle_tx_skb(struct net_device *netdev,
-					  struct mlx5e_tx_wqe *wqe,
-					  struct sk_buff *skb)
+bool mlx5e_ipsec_handle_tx_skb(struct net_device *netdev,
+			       struct mlx5e_tx_wqe *wqe,
+			       struct sk_buff *skb)
 {
 	struct mlx5e_priv *priv = netdev_priv(netdev);
 	struct xfrm_offload *xo = xfrm_offload(skb);
@@ -245,7 +245,7 @@ struct sk_buff *mlx5e_ipsec_handle_tx_skb(struct net_device *netdev,
 	struct sec_path *sp;
 
 	if (!xo)
-		return skb;
+		return true;
 
 	sp = skb_sec_path(skb);
 	if (unlikely(sp->len != 1)) {
@@ -281,11 +281,11 @@ struct sk_buff *mlx5e_ipsec_handle_tx_skb(struct net_device *netdev,
 	sa_entry->set_iv_op(skb, x, xo);
 	mlx5e_ipsec_set_metadata(skb, mdata, xo);
 
-	return skb;
+	return true;
 
 drop:
 	kfree_skb(skb);
-	return NULL;
+	return false;
 }
 
 static inline struct xfrm_state *
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h
index db84500b024f..64e948cc3dc5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h
@@ -52,9 +52,9 @@ void mlx5e_ipsec_set_iv_esn(struct sk_buff *skb, struct xfrm_state *x,
 			    struct xfrm_offload *xo);
 void mlx5e_ipsec_set_iv(struct sk_buff *skb, struct xfrm_state *x,
 			struct xfrm_offload *xo);
-struct sk_buff *mlx5e_ipsec_handle_tx_skb(struct net_device *netdev,
-					  struct mlx5e_tx_wqe *wqe,
-					  struct sk_buff *skb);
+bool mlx5e_ipsec_handle_tx_skb(struct net_device *netdev,
+			       struct mlx5e_tx_wqe *wqe,
+			       struct sk_buff *skb);
 
 #endif /* CONFIG_MLX5_EN_IPSEC */
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h
index 9daaec244385..742aca8782d6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h
@@ -95,10 +95,9 @@ mlx5e_get_ktls_tx_priv_ctx(struct tls_context *tls_ctx)
 void mlx5e_ktls_build_netdev(struct mlx5e_priv *priv);
 void mlx5e_ktls_tx_offload_set_pending(struct mlx5e_ktls_offload_context_tx *priv_tx);
 
-struct sk_buff *mlx5e_ktls_handle_tx_skb(struct net_device *netdev,
-					 struct mlx5e_txqsq *sq,
-					 struct sk_buff *skb,
-					 struct mlx5e_tx_wqe **wqe, u16 *pi);
+bool mlx5e_ktls_handle_tx_skb(struct net_device *netdev, struct mlx5e_txqsq *sq,
+			      struct sk_buff *skb, struct mlx5e_tx_wqe **wqe,
+			      u16 *pi);
 void mlx5e_ktls_tx_handle_resync_dump_comp(struct mlx5e_txqsq *sq,
 					   struct mlx5e_tx_wqe_info *wi,
 					   u32 *dma_fifo_cc);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
index ba973937f0b5..8fcd14803558 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
@@ -413,10 +413,9 @@ mlx5e_ktls_tx_handle_ooo(struct mlx5e_ktls_offload_context_tx *priv_tx,
 	return MLX5E_KTLS_SYNC_FAIL;
 }
 
-struct sk_buff *mlx5e_ktls_handle_tx_skb(struct net_device *netdev,
-					 struct mlx5e_txqsq *sq,
-					 struct sk_buff *skb,
-					 struct mlx5e_tx_wqe **wqe, u16 *pi)
+bool mlx5e_ktls_handle_tx_skb(struct net_device *netdev, struct mlx5e_txqsq *sq,
+			      struct sk_buff *skb, struct mlx5e_tx_wqe **wqe,
+			      u16 *pi)
 {
 	struct mlx5e_ktls_offload_context_tx *priv_tx;
 	struct mlx5e_sq_stats *stats = sq->stats;
@@ -474,9 +473,9 @@ struct sk_buff *mlx5e_ktls_handle_tx_skb(struct net_device *netdev,
 	stats->tls_encrypted_bytes   += datalen;
 
 out:
-	return skb;
+	return true;
 
 err_out:
 	dev_kfree_skb_any(skb);
-	return NULL;
+	return false;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c
index 1d7ddeb7a46b..e8f2c214a8de 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c
@@ -184,12 +184,10 @@ static void mlx5e_tls_complete_sync_skb(struct sk_buff *skb,
 	nskb->queue_mapping = skb->queue_mapping;
 }
 
-static struct sk_buff *
-mlx5e_tls_handle_ooo(struct mlx5e_tls_offload_context_tx *context,
-		     struct mlx5e_txqsq *sq, struct sk_buff *skb,
-		     struct mlx5e_tx_wqe **wqe,
-		     u16 *pi,
-		     struct mlx5e_tls *tls)
+static bool mlx5e_tls_handle_ooo(struct mlx5e_tls_offload_context_tx *context,
+				 struct mlx5e_txqsq *sq, struct sk_buff *skb,
+				 struct mlx5e_tx_wqe **wqe, u16 *pi,
+				 struct mlx5e_tls *tls)
 {
 	u32 tcp_seq = ntohl(tcp_hdr(skb)->seq);
 	struct sync_info info;
@@ -217,7 +215,7 @@ mlx5e_tls_handle_ooo(struct mlx5e_tls_offload_context_tx *context,
 		if (likely(payload <= -info.sync_len))
 			/* SKB payload doesn't require offload
 			 */
-			return skb;
+			return true;
 
 		atomic64_inc(&tls->sw_stats.tx_tls_drop_bypass_required);
 		goto err_out;
@@ -250,18 +248,16 @@ mlx5e_tls_handle_ooo(struct mlx5e_tls_offload_context_tx *context,
 	mlx5e_sq_xmit(sq, nskb, *wqe, *pi, true);
 	*pi = mlx5_wq_cyc_ctr2ix(&sq->wq, sq->pc);
 	*wqe = MLX5E_TX_FETCH_WQE(sq, *pi);
-	return skb;
+	return true;
 
 err_out:
 	dev_kfree_skb_any(skb);
-	return NULL;
+	return false;
 }
 
-struct sk_buff *mlx5e_tls_handle_tx_skb(struct net_device *netdev,
-					struct mlx5e_txqsq *sq,
-					struct sk_buff *skb,
-					struct mlx5e_tx_wqe **wqe,
-					u16 *pi)
+bool mlx5e_tls_handle_tx_skb(struct net_device *netdev, struct mlx5e_txqsq *sq,
+			     struct sk_buff *skb, struct mlx5e_tx_wqe **wqe,
+			     u16 *pi)
 {
 	struct mlx5e_priv *priv = netdev_priv(netdev);
 	struct mlx5e_tls_offload_context_tx *context;
@@ -270,41 +266,35 @@ struct sk_buff *mlx5e_tls_handle_tx_skb(struct net_device *netdev,
 	int datalen;
 	u32 skb_seq;
 
-	if (MLX5_CAP_GEN(sq->channel->mdev, tls_tx)) {
-		skb = mlx5e_ktls_handle_tx_skb(netdev, sq, skb, wqe, pi);
-		goto out;
-	}
+	if (MLX5_CAP_GEN(sq->channel->mdev, tls_tx))
+		return mlx5e_ktls_handle_tx_skb(netdev, sq, skb, wqe, pi);
 
 	if (!skb->sk || !tls_is_sk_tx_device_offloaded(skb->sk))
-		goto out;
+		return true;
 
 	datalen = skb->len - (skb_transport_offset(skb) + tcp_hdrlen(skb));
 	if (!datalen)
-		goto out;
+		return true;
 
 	tls_ctx = tls_get_ctx(skb->sk);
 	if (unlikely(tls_ctx->netdev != netdev))
-		goto out;
+		return true;
 
 	skb_seq = ntohl(tcp_hdr(skb)->seq);
 	context = mlx5e_get_tls_tx_context(tls_ctx);
 	expected_seq = context->expected_seq;
 
-	if (unlikely(expected_seq != skb_seq)) {
-		skb = mlx5e_tls_handle_ooo(context, sq, skb, wqe, pi, priv->tls);
-		goto out;
-	}
+	if (unlikely(expected_seq != skb_seq))
+		return mlx5e_tls_handle_ooo(context, sq, skb, wqe, pi, priv->tls);
 
 	if (unlikely(mlx5e_tls_add_metadata(skb, context->swid))) {
 		atomic64_inc(&priv->tls->sw_stats.tx_tls_drop_metadata);
 		dev_kfree_skb_any(skb);
-		skb = NULL;
-		goto out;
+		return false;
 	}
 
 	context->expected_seq = skb_seq + datalen;
-out:
-	return skb;
+	return true;
 }
 
 static int tls_update_resync_sn(struct net_device *netdev,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.h
index 90bc1f2384c8..890d452bf1ae 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.h
@@ -40,11 +40,9 @@
 #include "en.h"
 #include "en/txrx.h"
 
-struct sk_buff *mlx5e_tls_handle_tx_skb(struct net_device *netdev,
-					struct mlx5e_txqsq *sq,
-					struct sk_buff *skb,
-					struct mlx5e_tx_wqe **wqe,
-					u16 *pi);
+bool mlx5e_tls_handle_tx_skb(struct net_device *netdev, struct mlx5e_txqsq *sq,
+			     struct sk_buff *skb, struct mlx5e_tx_wqe **wqe,
+			     u16 *pi);
 
 void mlx5e_tls_handle_rx_skb(struct net_device *netdev, struct sk_buff *skb,
 			     u32 *cqe_bcnt);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
index 583e1b201b75..7a6ed72ae00a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -394,8 +394,7 @@ netdev_tx_t mlx5e_xmit(struct sk_buff *skb, struct net_device *dev)
 	wqe = MLX5E_TX_FETCH_WQE(sq, pi);
 
 	/* might send skbs and update wqe and pi */
-	skb = mlx5e_accel_handle_tx(skb, sq, dev, &wqe, &pi);
-	if (unlikely(!skb))
+	if (unlikely(!mlx5e_accel_handle_tx(skb, sq, dev, &wqe, &pi)))
 		return NETDEV_TX_OK;
 
 	return mlx5e_sq_xmit(sq, skb, wqe, pi, netdev_xmit_more());
-- 
2.25.4

