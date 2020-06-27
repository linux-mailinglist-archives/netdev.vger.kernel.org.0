Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F54720C44B
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 23:20:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726862AbgF0VUE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jun 2020 17:20:04 -0400
Received: from mail-eopbgr60076.outbound.protection.outlook.com ([40.107.6.76]:16519
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725823AbgF0VUE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 27 Jun 2020 17:20:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oWVEL+k4CIfwMangaK9kVp4HUa5TBWqb0gApl6ZtxuJ5wJin+Z2VCl1oH9jVgENd/TyjWneGIf2qrTk/YH30gFaFe62VHyXs1VmxWKtCA8MH137Gq0hZxHXPqUu2TaFBYuLfpjPp/gm+hqz11Z14Ir/Vc/smT6mo//zW7ZYAMUEX1UoUf1UQTr92jxbdUS926eUqh05ujOrOQ+AwmIKDqK/Vk3iUC3IOUnTBQvvI2DwrfhCr6h3XuY1DKsLpDRRSr6rhpPPfbySqvmHRaQouqg6CaU4xntsXx/lMgNcMcrCW+Li5DC5JVUGcW2fR41ScNb9qeRfl8bpZMenaxjY5sQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A69AU7lL/utccKpAaTl6jnDDLNvZniRkt7k73AuAhCo=;
 b=ofZ72yVn7hUesnb7LsgVDbSQ/wP0vEZS79Ookwng4aBQ/VuHXZH+SSgej9Mcbqp0qAHcdR5usfXyecDipY4J9kL3Rx+8iEN2TWwCGI6v4yH394NDwYfrXAiiWIVD8NEAjmDpkRr7XssluMGwHfcaxHbE6iGjIGhCaYHw41wNOcr/g7MyYYmimXnAW1djy6Rosx5zjO318shSI8Tuuijb9FW5QdLPQHzEttFqWmoOkyGQzA5SSRSPvOHJ/j8WoMm7Bg+l1xkLcOS8WplLY2DEPoeel9dh9qSSiNkfa+v8P3hfyWGr0chUboIswGD3iU70I/+VAPU60qM30Y6QJNyxhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A69AU7lL/utccKpAaTl6jnDDLNvZniRkt7k73AuAhCo=;
 b=UU4fQEChWaXfiW3WWIdNKqYyc3EnbsjGRQE/9kOJXZZuxGQ4du6qlKOdBEyIF0WxtryXNeT++SE6ZrPkYWC2N4IeI9PKJqfmYe+FUjBd1ji/1sJIS1ZhjiHAem+GIrrocRSz+m37DulhgadEPxerWIFVK1V+imDXkZ6GCMzaAOY=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB5134.eurprd05.prod.outlook.com (2603:10a6:803:ad::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.21; Sat, 27 Jun
 2020 21:19:09 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3131.026; Sat, 27 Jun 2020
 21:19:09 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 15/15] net/mlx5e: kTLS, Improve rx handler function call
Date:   Sat, 27 Jun 2020 14:17:27 -0700
Message-Id: <20200627211727.259569-16-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200627211727.259569-1-saeedm@mellanox.com>
References: <20200627211727.259569-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR03CA0017.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::27) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY5PR03CA0017.namprd03.prod.outlook.com (2603:10b6:a03:1e0::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.21 via Frontend Transport; Sat, 27 Jun 2020 21:19:07 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 81a43319-816a-48fb-1573-08d81adfbaec
X-MS-TrafficTypeDiagnostic: VI1PR05MB5134:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB5134B0E88A96C1DF6D015C9DBE900@VI1PR05MB5134.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:669;
X-Forefront-PRVS: 0447DB1C71
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BqBKjbb2eBImvaMXjtiVbziJueUuzYGdT3Zl2vZ2O2xB1Aso+dHluXyH4n3m+IDH4FVPnXagoXImhn/sv8foGugroZws6DutDF4SjfZdzEUYZ+d1/7joDDtncKD3BGTBD/0O0X4l0bzWVCl8NQputNfHnQYU8yjC9zS3YIaZdBRWO9w6IUoX+3eItKV2zQDnLHpDqnu3RSfqUfQ1Y0ZZX/J6yEdxPc/yfzSZiTmd7ZCbIt0R1x1ChKyg3bWSQbSVNGqxweDQl2StYk3KdI05QMusbKgSo5XzDxyqOgfF3mm/tBLeiZFuWOocRKK4jR02DW98TNqxbrmZhPxlwUZo6gyYHW2a5oVxB5aVmWLBSwrsohGZwq2rs4QV7rDNIxH8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(376002)(136003)(39850400004)(346002)(396003)(66476007)(107886003)(54906003)(478600001)(4326008)(316002)(6512007)(16526019)(6506007)(2616005)(1076003)(6486002)(956004)(6666004)(66556008)(8936002)(52116002)(86362001)(36756003)(5660300002)(66946007)(26005)(8676002)(83380400001)(2906002)(186003)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: UM/13nA04wwJRF9Oz/o/6TFI5H/bThxCGtnXVvGtPJ8HZEyrkvNHNYaXWFe5U311mB3XheF50p6PfwUJZwvU12RWXHpHiin7D6evY4q4qBsHoJCEBPZa2e5c8/0hjP9za/4O/szm94+vv0K2YRHb7MZY8np9RpkzKeG9mesVttzKr0jK8B6w0Gzv48Eq4EkflCtmyHBQRq7ddUZH1kpdWDT6Bx9M7moyTBzBkfinA3YSc2ij191J89WVGF3yJIFz8qFMN5Z7d68xSFCNYieAru1MjB6GLUnqLdpLGEKua4LH1qYrEjlYf3Ujrypl+j5xI3ZBFfpXTFxJ6ee5YkCRUaWT+Ws9oRLRH5CrQUC6lr8WSqJg7Yt6jscBaWSCuHRG83hM9xz71ZcPGTAVK+SF1foxTkGiazYGRpGFY/OGp9MRc61dNNogZ4ghvlFn7kNfjYopCAZ0OOBvrzOvYN/LZowI3sCA60EWVR7qxNzt4DY=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81a43319-816a-48fb-1573-08d81adfbaec
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jun 2020 21:19:09.1007
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0lVZiyApvuCgpwIgd3je5TBwIUcFaNTXAy+gV+zKd04J12YZwo5/lxG2y7O5l8SP1S2qtalDC4PSvG5N31RDWA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5134
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@mellanox.com>

Prior to this patch mlx5e tls rx handler was called unconditionally on
all rx frames and the decision whether a frame is a valid tls record
is done inside that function.  A function call can be expensive especially
for regular rx packet rate.  To avoid this, check the tls validity before
jumping into the tls rx handler.

While at it, split between kTLS device offload rx handler and FPGA tls rx
handler using a similar method.

Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  1 +
 .../mellanox/mlx5/core/en_accel/ktls_rx.c     | 10 ++-------
 .../mellanox/mlx5/core/en_accel/tls.h         |  6 ++++++
 .../mellanox/mlx5/core/en_accel/tls_rxtx.c    | 12 +++--------
 .../mellanox/mlx5/core/en_accel/tls_rxtx.h    | 21 +++++++++++++++++--
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  3 +++
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   |  2 --
 7 files changed, 34 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index ec5bf73f9b07..2957edb7e0b7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -263,6 +263,7 @@ enum {
 	MLX5E_RQ_STATE_AM,
 	MLX5E_RQ_STATE_NO_CSUM_COMPLETE,
 	MLX5E_RQ_STATE_CSUM_FULL, /* cqe_csum_full hw bit is set */
+	MLX5E_RQ_STATE_FPGA_TLS, /* FPGA TLS enabled */
 };
 
 struct mlx5e_cq {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
index e0a8f9d63b30..d7215defd403 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
@@ -517,15 +517,9 @@ void mlx5e_ktls_rx_resync(struct net_device *netdev, struct sock *sk,
 void mlx5e_ktls_handle_rx_skb(struct mlx5e_rq *rq, struct sk_buff *skb,
 			      struct mlx5_cqe64 *cqe, u32 *cqe_bcnt)
 {
-	u8 tls_offload = get_cqe_tls_offload(cqe);
-	struct mlx5e_rq_stats *stats;
-
-	if (likely(tls_offload == CQE_TLS_OFFLOAD_NOT_DECRYPTED))
-		return;
-
-	stats = rq->stats;
+	struct mlx5e_rq_stats *stats = rq->stats;
 
-	switch (tls_offload) {
+	switch (get_cqe_tls_offload(cqe)) {
 	case CQE_TLS_OFFLOAD_DECRYPTED:
 		skb->decrypted = 1;
 		stats->tls_decrypted_packets++;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.h
index ca0c2ebb41a1..bd270a85c804 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.h
@@ -87,6 +87,11 @@ mlx5e_get_tls_rx_context(struct tls_context *tls_ctx)
 			    base);
 }
 
+static inline bool mlx5e_is_tls_on(struct mlx5e_priv *priv)
+{
+	return priv->tls;
+}
+
 void mlx5e_tls_build_netdev(struct mlx5e_priv *priv);
 int mlx5e_tls_init(struct mlx5e_priv *priv);
 void mlx5e_tls_cleanup(struct mlx5e_priv *priv);
@@ -103,6 +108,7 @@ static inline void mlx5e_tls_build_netdev(struct mlx5e_priv *priv)
 		mlx5e_ktls_build_netdev(priv);
 }
 
+static inline bool mlx5e_is_tls_on(struct mlx5e_priv *priv) { return false; }
 static inline int mlx5e_tls_init(struct mlx5e_priv *priv) { return 0; }
 static inline void mlx5e_tls_cleanup(struct mlx5e_priv *priv) { }
 static inline int mlx5e_tls_get_count(struct mlx5e_priv *priv) { return 0; }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c
index 182841322ce4..b0c31d49ff8d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c
@@ -355,19 +355,13 @@ static int tls_update_resync_sn(struct net_device *netdev,
 	return 0;
 }
 
-void mlx5e_tls_handle_rx_skb(struct mlx5e_rq *rq, struct sk_buff *skb,
-			     struct mlx5_cqe64 *cqe, u32 *cqe_bcnt)
+/* FPGA tls rx handler */
+void mlx5e_tls_handle_rx_skb_metadata(struct mlx5e_rq *rq, struct sk_buff *skb,
+				      u32 *cqe_bcnt)
 {
 	struct mlx5e_tls_metadata *mdata;
 	struct mlx5e_priv *priv;
 
-	if (likely(mlx5_accel_is_ktls_rx(rq->mdev)))
-		return mlx5e_ktls_handle_rx_skb(rq, skb, cqe, cqe_bcnt);
-
-	/* FPGA */
-	if (!is_metadata_hdr_valid(skb))
-		return;
-
 	/* Use the metadata */
 	mdata = (struct mlx5e_tls_metadata *)(skb->data + ETH_HLEN);
 	switch (mdata->content.recv.syndrome) {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.h
index 8bb790674042..5f162ad2ee8f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.h
@@ -34,6 +34,7 @@
 #ifndef __MLX5E_TLS_RXTX_H__
 #define __MLX5E_TLS_RXTX_H__
 
+#include "accel/accel.h"
 #include "en_accel/ktls_txrx.h"
 
 #ifdef CONFIG_MLX5_EN_TLS
@@ -49,11 +50,27 @@ bool mlx5e_tls_handle_tx_skb(struct net_device *netdev, struct mlx5e_txqsq *sq,
 void mlx5e_tls_handle_tx_wqe(struct mlx5e_txqsq *sq, struct mlx5_wqe_ctrl_seg *cseg,
 			     struct mlx5e_accel_tx_tls_state *state);
 
-void mlx5e_tls_handle_rx_skb(struct mlx5e_rq *rq, struct sk_buff *skb,
-			     struct mlx5_cqe64 *cqe, u32 *cqe_bcnt);
+void mlx5e_tls_handle_rx_skb_metadata(struct mlx5e_rq *rq, struct sk_buff *skb,
+				      u32 *cqe_bcnt);
+
+static inline void
+mlx5e_tls_handle_rx_skb(struct mlx5e_rq *rq, struct sk_buff *skb,
+			struct mlx5_cqe64 *cqe, u32 *cqe_bcnt)
+{
+	if (unlikely(get_cqe_tls_offload(cqe))) /* cqe bit indicates a TLS device */
+		return mlx5e_ktls_handle_rx_skb(rq, skb, cqe, cqe_bcnt);
+
+	if (unlikely(test_bit(MLX5E_RQ_STATE_FPGA_TLS, &rq->state) && is_metadata_hdr_valid(skb)))
+		return mlx5e_tls_handle_rx_skb_metadata(rq, skb, cqe_bcnt);
+}
 
 #else
 
+static inline bool
+mlx5e_accel_is_tls(struct mlx5_cqe64 *cqe, struct sk_buff *skb) { return false; }
+static inline void
+mlx5e_tls_handle_rx_skb(struct mlx5e_rq *rq, struct sk_buff *skb,
+			struct mlx5_cqe64 *cqe, u32 *cqe_bcnt) {}
 static inline u16 mlx5e_tls_get_stop_room(struct mlx5e_txqsq *sq)
 {
 	return 0;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 3e6fcd545d2c..046cfb0ea180 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -873,6 +873,9 @@ int mlx5e_open_rq(struct mlx5e_channel *c, struct mlx5e_params *params,
 	if (err)
 		goto err_destroy_rq;
 
+	if (mlx5e_is_tls_on(c->priv) && !mlx5_accel_is_ktls_device(c->mdev))
+		__set_bit(MLX5E_RQ_STATE_FPGA_TLS, &c->rq.state); /* must be FPGA */
+
 	if (MLX5_CAP_ETH(c->mdev, cqe_checksum_full))
 		__set_bit(MLX5E_RQ_STATE_CSUM_FULL, &c->rq.state);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 4b7c119c8946..8b42f729a4f7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -1019,9 +1019,7 @@ static inline void mlx5e_build_rx_skb(struct mlx5_cqe64 *cqe,
 
 	skb->mac_len = ETH_HLEN;
 
-#ifdef CONFIG_MLX5_EN_TLS
 	mlx5e_tls_handle_rx_skb(rq, skb, cqe, &cqe_bcnt);
-#endif
 
 	if (lro_num_seg > 1) {
 		mlx5e_lro_update_hdr(skb, cqe, cqe_bcnt);
-- 
2.26.2

