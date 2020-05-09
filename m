Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6292F1CBF03
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 10:29:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727960AbgEII3h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 04:29:37 -0400
Received: from mail-eopbgr80077.outbound.protection.outlook.com ([40.107.8.77]:60182
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727785AbgEII3g (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 May 2020 04:29:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jNOdDdjr0VJeSkZffoLizaoxx8OdUuFdQPP8XlZRHPBAEGqZBIcWHJRFt14VIWRXjMVqx/1FcU0KoNgrkjOIzMQ58r+SJNTtNHbCkvOAhwarrn1o4LZmdQxn4FhKQ8QaZ0PeI1FVTLgOhd/5pCJxB40u8Ny3RWzEHKenG/TQDVx9H3zCV/RW+0X+2tQI1VIWPXGg4b8+WEUlWDgwuvTErE0ErCsc4iEEZCroWEeGnywhwW2WDxhXiJ5WGfpXF+NIssI2yZ2ZmoTuvoZQT0kCQSP1MTKpVRBeqanvf0T3g6CQNqLREjqqUZsz4hGOYKMLUklrfXkHp1fkWLEs4aHDpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cv8pltUq0M88SDmgDAlvHr01X6NqLInMu6fxXfBiPss=;
 b=Qk+pf+doaKjTJ/b7JwiniAqbAe2HTAZo5XEPek0E3f02KWftBYnSKd2UVYx6bkoUJK2eAjbfartLdSKHzhLlU1xXbOUXADkhePa85XgbcjZNrz45FNWQLC2HllMXp0G3Xu/qiYeO7KLJI7s0tJH/uElehB3QlQGsQ+ff8WEPRRqRotNe+WSNyf9oC7u51f5fPDr6OnXiuZphSTt6CvMVGLAup4+9jFzYoDO2g/gCRka1Sb3X2B2NGUGpq5k4tZ8SxchtoHbjzEI/8GZA/+BIBDtToKos0cKvL5VLJHHFh8oFQI4iCBdUEr+S+tHKZeLiEGk7vreRsKDH/wjlTaohEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cv8pltUq0M88SDmgDAlvHr01X6NqLInMu6fxXfBiPss=;
 b=sqEwfRY0BbPd6C7nMQ0NQbZfYHMcKNyP3ZkQdwlK3sqmJVIFtYcJtjt/b8ZRiD2yAY+c3CckYlB3FQElEHZPIHwIL4GSLgGYNqPaQjuhhyg+6YZLg9aequJZAVUWQKgoRaLs6Nxc7UYNThCFgHvvTjZ6iKd8pzOuuUjMaUBQjt8=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB4813.eurprd05.prod.outlook.com (2603:10a6:803:52::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.29; Sat, 9 May
 2020 08:29:26 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2979.033; Sat, 9 May 2020
 08:29:26 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Maxim Mikityanskiy <maximmi@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 05/13] net/mlx5e: Make TLS offload independent of wqe and pi
Date:   Sat,  9 May 2020 01:28:48 -0700
Message-Id: <20200509082856.97337-6-saeedm@mellanox.com>
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
Received: from smtp.office365.com (73.15.39.150) by BYAPR07CA0011.namprd07.prod.outlook.com (2603:10b6:a02:bc::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.26 via Frontend Transport; Sat, 9 May 2020 08:29:24 +0000
X-Mailer: git-send-email 2.25.4
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 8e58734d-f189-458d-cb01-08d7f3f31566
X-MS-TrafficTypeDiagnostic: VI1PR05MB4813:|VI1PR05MB4813:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB4813FD648E4C92E7F04FA130BEA30@VI1PR05MB4813.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:854;
X-Forefront-PRVS: 03982FDC1D
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FmZ2rcK/8E7LP7cwEwC8KE/QiMqfGjJlXSQTRgJcTt6NnZjbUaGrgXa+YZK5VcFU9GojA6QVuDC23uYITn4hqgH/RmLlq79VOWSTp+Yio0WsWOJwUKDeO6Kuf/OS69MXZFwfovJpfJ9WygICN0bj+l76Q2quOcjfzaScxCEAc/lqFsZ7Y+9eU24SkS2sLq1wuBNpuEmgnW1uLShlojnTzP31ed8cHTqNqQj2p3Fa+acj+VH00JIxqFQr5uy+xPzDnjJBxzg91u9zOjJoZYMqUM6ZVn7zwSaDyFpsz5+gUfIBiq1BeyQmjgmGA7HZJ1f92qSFTDkYXVJ4N+ujJSUSzJ9tr5uj5gmAQFpACaFHGceRBWUd9u+T3Jdd4QRhxfQo28XKoexWMn/a400zS1kR5W3kWco8QooDBq+02/RMmXyECHhRul9VWdWuaXChOX0NHtNF0M9TJPH4DTQ9ZCnsTb97SD530trB51BFFACx6tzri+/G29kuM9kdO9xzDRfF8koOWs+9HhSKJr+8wWeogbtRO1xZpK3+DSaEuiR0ZBeqe2Nq1ngX/RbJd1OlXM3e
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(396003)(346002)(136003)(39860400002)(376002)(33430700001)(26005)(6506007)(2616005)(6666004)(4326008)(6512007)(1076003)(6486002)(36756003)(8936002)(33440700001)(66556008)(66476007)(5660300002)(54906003)(956004)(8676002)(316002)(107886003)(66946007)(2906002)(16526019)(52116002)(86362001)(186003)(478600001)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: QU2MgGISS28f6NQZG52JQa1OAaVC1i/eJ5SMz0qkPYP7iIcPao1Tw6phnAMBpUGJD3q68pst7FK3udfW1ollAoKW8UQtuCqvdL1AFYl81eEOb24m0/LoHTeYp+Hjr+tJb2lnfECYVW3fwe6fnxDTI/OT8/YC4Zu1RucUc3BND4tSshUu6dG40BKwEBM76wK3/uIQww2jzWMU1JS+goQQtLd8n+L2iDmnIrWXYvMOS4N3prQ3LfCIOGge5QhS/CUNvIIW9judrJ2hyyUUcSPbropMxmGSeNO9Jx6/iz4phgT1sTUKI1MZA6oScIfeiGykYjeKBn+KNMRqnMfVZJ9MbJHesquJ9iX9LQv0abns/vGZJBI+DiZY5zc4Qj4cCzBpKtyg72vQfXqaxtn/RaCxjWMtFE5erl2alACngzLDAqNF7BVbkYfwxzxCIuAwSxUakQHP2Kt3CySF8qQcIbBLkumSX3in1Qi4tdlkFIGkHBk=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e58734d-f189-458d-cb01-08d7f3f31566
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2020 08:29:25.9564
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Yh2EzJyO4ApjRLoXyU6iJsSq4oUiH91ifSzHYTY4hmkO0b2vXTXSi4rapdc8NZPoiMxEZUpeMmmPmfkcsitaHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4813
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>

TLS offload may write a 32-bit field (tisn) to the cseg of the WQE. To
do that, it receives pi and wqe pointers. As TLS offload may also send
additional WQEs, it has to update pi and wqe, and in many cases it even
doesn't use pi calculated before and wqe zeroed before and does it
itself. Also, mlx5e_sq_xmit has to copy the whole cseg if it goes to the
mlx5e_fill_sq_frag_edge flow. This all is not efficient.

It's more efficient to do the following:

1. Just return tisn from TLS offload and make the caller fill it in a
more appropriate place.

2. Calculate pi and clear wqe after calling TLS offload.

3. If TLS offload has to send WQEs, calculate pi and clear wqe just
before that. It's already done in all places anyway, so this commit
allows to remove some redundant memsets and calls.

Copying of cseg will be eliminated in one of the following commits, and
all other stuff is done here.

Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../mellanox/mlx5/core/en_accel/en_accel.h      | 10 +++++++++-
 .../ethernet/mellanox/mlx5/core/en_accel/ktls.h |  3 +--
 .../mellanox/mlx5/core/en_accel/ktls_tx.c       | 13 +++----------
 .../mellanox/mlx5/core/en_accel/tls_rxtx.c      | 17 +++++++++--------
 .../mellanox/mlx5/core/en_accel/tls_rxtx.h      |  3 +--
 5 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
index c658c8556863..66bfab021d6b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
@@ -109,10 +109,18 @@ static inline bool mlx5e_accel_handle_tx(struct sk_buff *skb,
 					 u16 *pi)
 {
 #ifdef CONFIG_MLX5_EN_TLS
+	u32 tls_tisn = 0;
+
 	if (test_bit(MLX5E_SQ_STATE_TLS, &sq->state)) {
-		if (unlikely(!mlx5e_tls_handle_tx_skb(dev, sq, skb, wqe, pi)))
+		/* May send SKBs and WQEs. */
+		if (unlikely(!mlx5e_tls_handle_tx_skb(dev, sq, skb, &tls_tisn)))
 			return false;
 	}
+
+	*pi = mlx5_wq_cyc_ctr2ix(&sq->wq, sq->pc);
+	*wqe = MLX5E_TX_FETCH_WQE(sq, *pi);
+
+	(*wqe)->ctrl.tisn = cpu_to_be32(tls_tisn << 8);
 #endif
 
 #ifdef CONFIG_MLX5_EN_IPSEC
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h
index 81f8b7467569..7d9d9420f19d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h
@@ -96,8 +96,7 @@ void mlx5e_ktls_build_netdev(struct mlx5e_priv *priv);
 void mlx5e_ktls_tx_offload_set_pending(struct mlx5e_ktls_offload_context_tx *priv_tx);
 
 bool mlx5e_ktls_handle_tx_skb(struct tls_context *tls_ctx, struct mlx5e_txqsq *sq,
-			      struct sk_buff *skb, struct mlx5e_tx_wqe **wqe,
-			      u16 *pi, int datalen);
+			      struct sk_buff *skb, u32 *tisn, int datalen);
 void mlx5e_ktls_tx_handle_resync_dump_comp(struct mlx5e_txqsq *sq,
 					   struct mlx5e_tx_wqe_info *wi,
 					   u32 *dma_fifo_cc);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
index c61604f3722c..b49d7c1e49dc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
@@ -414,20 +414,16 @@ mlx5e_ktls_tx_handle_ooo(struct mlx5e_ktls_offload_context_tx *priv_tx,
 }
 
 bool mlx5e_ktls_handle_tx_skb(struct tls_context *tls_ctx, struct mlx5e_txqsq *sq,
-			      struct sk_buff *skb, struct mlx5e_tx_wqe **wqe,
-			      u16 *pi, int datalen)
+			      struct sk_buff *skb, u32 *tisn, int datalen)
 {
 	struct mlx5e_ktls_offload_context_tx *priv_tx;
 	struct mlx5e_sq_stats *stats = sq->stats;
-	struct mlx5_wqe_ctrl_seg *cseg;
 	u32 seq;
 
 	priv_tx = mlx5e_get_ktls_tx_priv_ctx(tls_ctx);
 
 	if (unlikely(mlx5e_ktls_tx_offload_test_and_clear_pending(priv_tx))) {
 		mlx5e_ktls_tx_post_param_wqes(sq, priv_tx, false, false);
-		*pi = mlx5_wq_cyc_ctr2ix(&sq->wq, sq->pc);
-		*wqe = MLX5E_TX_FETCH_WQE(sq, *pi);
 		stats->tls_ctx++;
 	}
 
@@ -438,23 +434,20 @@ bool mlx5e_ktls_handle_tx_skb(struct tls_context *tls_ctx, struct mlx5e_txqsq *s
 
 		switch (ret) {
 		case MLX5E_KTLS_SYNC_DONE:
-			*pi = mlx5_wq_cyc_ctr2ix(&sq->wq, sq->pc);
-			*wqe = MLX5E_TX_FETCH_WQE(sq, *pi);
 			break;
 		case MLX5E_KTLS_SYNC_SKIP_NO_DATA:
 			if (likely(!skb->decrypted))
 				goto out;
 			WARN_ON_ONCE(1);
 			/* fall-through */
-		default: /* MLX5E_KTLS_SYNC_FAIL */
+		case MLX5E_KTLS_SYNC_FAIL:
 			goto err_out;
 		}
 	}
 
 	priv_tx->expected_seq = seq + datalen;
 
-	cseg = &(*wqe)->ctrl;
-	cseg->tisn = cpu_to_be32(priv_tx->tisn << 8);
+	*tisn = priv_tx->tisn;
 
 	stats->tls_encrypted_packets += skb_is_gso(skb) ? skb_shinfo(skb)->gso_segs : 1;
 	stats->tls_encrypted_bytes   += datalen;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c
index 26c59cfbec9b..8e6b0b0ce2e4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c
@@ -186,14 +186,15 @@ static void mlx5e_tls_complete_sync_skb(struct sk_buff *skb,
 
 static bool mlx5e_tls_handle_ooo(struct mlx5e_tls_offload_context_tx *context,
 				 struct mlx5e_txqsq *sq, struct sk_buff *skb,
-				 struct mlx5e_tx_wqe **wqe, u16 *pi,
 				 struct mlx5e_tls *tls)
 {
 	u32 tcp_seq = ntohl(tcp_hdr(skb)->seq);
+	struct mlx5e_tx_wqe *wqe;
 	struct sync_info info;
 	struct sk_buff *nskb;
 	int linear_len = 0;
 	int headln;
+	u16 pi;
 	int i;
 
 	sq->stats->tls_ooo++;
@@ -245,9 +246,10 @@ static bool mlx5e_tls_handle_ooo(struct mlx5e_tls_offload_context_tx *context,
 	sq->stats->tls_resync_bytes += nskb->len;
 	mlx5e_tls_complete_sync_skb(skb, nskb, tcp_seq, headln,
 				    cpu_to_be64(info.rcd_sn));
-	mlx5e_sq_xmit(sq, nskb, *wqe, *pi, true);
-	*pi = mlx5_wq_cyc_ctr2ix(&sq->wq, sq->pc);
-	*wqe = MLX5E_TX_FETCH_WQE(sq, *pi);
+	pi = mlx5_wq_cyc_ctr2ix(&sq->wq, sq->pc);
+	wqe = MLX5E_TX_FETCH_WQE(sq, pi);
+	mlx5e_sq_xmit(sq, nskb, wqe, pi, true);
+
 	return true;
 
 err_out:
@@ -256,8 +258,7 @@ static bool mlx5e_tls_handle_ooo(struct mlx5e_tls_offload_context_tx *context,
 }
 
 bool mlx5e_tls_handle_tx_skb(struct net_device *netdev, struct mlx5e_txqsq *sq,
-			     struct sk_buff *skb, struct mlx5e_tx_wqe **wqe,
-			     u16 *pi)
+			     struct sk_buff *skb, u32 *tisn)
 {
 	struct mlx5e_priv *priv = netdev_priv(netdev);
 	struct mlx5e_tls_offload_context_tx *context;
@@ -278,14 +279,14 @@ bool mlx5e_tls_handle_tx_skb(struct net_device *netdev, struct mlx5e_txqsq *sq,
 		goto err_out;
 
 	if (MLX5_CAP_GEN(sq->channel->mdev, tls_tx))
-		return mlx5e_ktls_handle_tx_skb(tls_ctx, sq, skb, wqe, pi, datalen);
+		return mlx5e_ktls_handle_tx_skb(tls_ctx, sq, skb, tisn, datalen);
 
 	skb_seq = ntohl(tcp_hdr(skb)->seq);
 	context = mlx5e_get_tls_tx_context(tls_ctx);
 	expected_seq = context->expected_seq;
 
 	if (unlikely(expected_seq != skb_seq))
-		return mlx5e_tls_handle_ooo(context, sq, skb, wqe, pi, priv->tls);
+		return mlx5e_tls_handle_ooo(context, sq, skb, priv->tls);
 
 	if (unlikely(mlx5e_tls_add_metadata(skb, context->swid))) {
 		atomic64_inc(&priv->tls->sw_stats.tx_tls_drop_metadata);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.h
index 890d452bf1ae..3630ed8b1206 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.h
@@ -41,8 +41,7 @@
 #include "en/txrx.h"
 
 bool mlx5e_tls_handle_tx_skb(struct net_device *netdev, struct mlx5e_txqsq *sq,
-			     struct sk_buff *skb, struct mlx5e_tx_wqe **wqe,
-			     u16 *pi);
+			     struct sk_buff *skb, u32 *tisn);
 
 void mlx5e_tls_handle_rx_skb(struct net_device *netdev, struct sk_buff *skb,
 			     u32 *cqe_bcnt);
-- 
2.25.4

