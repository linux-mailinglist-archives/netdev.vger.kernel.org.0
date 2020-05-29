Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97CC91E8828
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 21:47:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728170AbgE2Trn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 15:47:43 -0400
Received: from mail-eopbgr20072.outbound.protection.outlook.com ([40.107.2.72]:57981
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726866AbgE2Trl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 15:47:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RZMdDXuNFsAgDuMBjGs5NhvWmj5oAx5QsiEH+Y4+s6wdfmrWUi6pL90hu7au1TfVXma+OP9V6I+pXCwfbBgho6TgV3P4sUJX/7ODIXVGUwJRxPmJdZQAh46wZx38fg7/ceT+XSV7kmlR9yq9GkNNqnSEFZuv0KjvqNC3MRtxuhAGt/7XpcLOtEw1+VeimzQxcFCoGg7k2H2QzfGJ7Hb4aPs9qQbjKLu/l8TjiNKi4RFh2PvjoTMd8zmpPmE1q9wOw5CTIZPe2zVuFde09CuRtyZC/yKDklTehRARS/+RYTMeQlCKg9kWtkLbyMCNrxNHFPZbbQ3+eMn9VREBKPx4Tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Or5ICvVMj6uv5SysZ24jjjdz2CWp0FFYuCgpOy/ca7I=;
 b=LD4Eqp/kPwR2ncN4bTJDTki/i5J71WaYwF3itJeX0McVH4dTZwhG6xeV0IgmZP3uYNwGOPBJovwBuqgO61p7FYOJuLW9FSI5A7Ix+YHkBeLs/N2vXmU72F9SVQRwCiG07nJ3ADbIwNu3Os63FDDyMQn9bVXB9JFmHY1o+u6X1FT2ykiMoPrigfGZVdkAekN+kNXatu8cKm4oQfzmrnQl5JYKl0VpygOC8BtNqR5ER4aueOVTciRh3UwlgipueHn55k3FNaBoe2WtkC2diTJRTuorVd5up9tMO97hpLs/MeQZWdw/Q82CtuPrnh/4GQMPW20JBu6TefUm8wWmbgqshw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Or5ICvVMj6uv5SysZ24jjjdz2CWp0FFYuCgpOy/ca7I=;
 b=qhLWAtXtmNiaWFvm94lwG2SSmfGsQi8NWRHjdIoW1V5Daw/8McYbNCBzXoIX04ZDQW2LSSzmp2SXpLRmKrt9jLxwRoGunCwD3c1gJsxTLjcKigJpSGUCgI03zV/gW/QteCvc5nKBSS0uqZO0X/vjCXsmEZaTRCChwheJ2dGfTm8=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB6589.eurprd05.prod.outlook.com (2603:10a6:803:f7::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.19; Fri, 29 May
 2020 19:47:23 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3045.018; Fri, 29 May 2020
 19:47:23 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 09/11] net/mlx5e: kTLS, Add kTLS RX stats
Date:   Fri, 29 May 2020 12:46:39 -0700
Message-Id: <20200529194641.243989-10-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200529194641.243989-1-saeedm@mellanox.com>
References: <20200529194641.243989-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR16CA0010.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::23) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY5PR16CA0010.namprd16.prod.outlook.com (2603:10b6:a03:1a0::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.17 via Frontend Transport; Fri, 29 May 2020 19:47:21 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b0c5dcc6-9964-40d6-0e2e-08d804091b36
X-MS-TrafficTypeDiagnostic: VI1PR05MB6589:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB65895E11DFCCC6C0430A5CD9BE8F0@VI1PR05MB6589.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1923;
X-Forefront-PRVS: 04180B6720
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: M1RzLIjw0Y8YfGiBgaPZ+ajFzXXTXsqZ8v6d9L3ryBj12TLa5ElH72F7T35NX7xiYFa959NCGE2+qtZCv1US+UAsGhxgzjHsYXDRINt8IYhO/kxDJ50sOwzl+nxNKa0OolCWt9gRfZ2+0kgXp1qVTXuQneOA58tnSHRspYOjhQUGPqut/jVpiUmV6emP93buHAShiPeAhVFxIFrZboQc8AgpHEIEimRomB7DwDHrePEcBoV1ur/yl4rBuR8nqJ0A8ykoU0Is03REkBQ0WdO6dQ9fU865tLjjtKz+RjE1q7Tzk0gkbajBgRy8Q1dWgjPJcw7FynMe615xH9VgvzRJMNgCEDxUaQkrH0PbcCroN/wwKXU7umBsgQBTByp8Yfag
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(396003)(376002)(39860400002)(136003)(366004)(6512007)(83380400001)(36756003)(186003)(4326008)(86362001)(8936002)(26005)(107886003)(16526019)(6506007)(316002)(52116002)(8676002)(2616005)(956004)(54906003)(6666004)(478600001)(66556008)(5660300002)(2906002)(6486002)(1076003)(66476007)(66946007)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: QgI2LK7lNvOWGZj3k4VWj+i0AgY5bgKiHebP3XR233DlJKz+eXdkYHdr2x6Bi/QgqDJB1aajEJT2ChqRSkIAOtx0C42U5h0UJS3zH5gT6s91U0oNN7sZNRdReSYiE556bzd5YJbOibUTpmWx6tn5PGFTFKD9i5DajDIDoESwb28B0VaTeDRoFdK60CMFV42aaB8pxMr6/Tsadxt5fPCDYyLKG5X7X4mRrdgIkPMKoU9MoXB3Kk5OjNkvlFX7FyBkpA0Ep4X6qYg/CUo1pJZoZFvj7iX+UGV3iUFcoNfsAZyo1w1DTNpm9yvZlceqEzpTYvDHBP9Q3KeFQlONhZjMvyt9Gd26rX0bbsphu1VjTnFsgtnGJxFGCp8QXXC1s8/JLIIMi6XM3FXGUi/8nmKQWN9zbF6x7zis2nkK+ytfCYXprNJkKGyl480lkbfYLK7lNWxW7uj7j8Md0e40Lnd7Hn1pcqSin5F/9DpuUpncvn8=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b0c5dcc6-9964-40d6-0e2e-08d804091b36
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 May 2020 19:47:23.3977
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Hi2/nVbOh3oGpjyQ5YhKMptch+cXtmESVmAQQdMtsR88bc6IYwlseGuYSVXG7e+svzlCL/9fy0naFs1crYDNhA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6589
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@mellanox.com>

Add global and per-channel ethtool SW stats for the device
offload.
Document the new counters in tls-offload.rst.

Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 Documentation/networking/tls-offload.rst      |  8 +++++++
 .../mellanox/mlx5/core/en_accel/ktls_rx.c     | 10 ++++++++
 .../ethernet/mellanox/mlx5/core/en_stats.c    | 24 +++++++++++++++++++
 .../ethernet/mellanox/mlx5/core/en_stats.h    | 15 ++++++++++++
 4 files changed, 57 insertions(+)

diff --git a/Documentation/networking/tls-offload.rst b/Documentation/networking/tls-offload.rst
index f914e81fd3a64..44c4b19647746 100644
--- a/Documentation/networking/tls-offload.rst
+++ b/Documentation/networking/tls-offload.rst
@@ -428,6 +428,14 @@ by the driver:
    which were part of a TLS stream.
  * ``rx_tls_decrypted_bytes`` - number of TLS payload bytes in RX packets
    which were successfully decrypted.
+ * ``rx_tls_ctx`` - number of TLS RX HW offload contexts added to device for
+   decryption.
+ * ``rx_tls_ooo`` - number of RX packets which were part of a TLS stream
+   but did not arrive in the expected order and triggered the resync procedure.
+ * ``rx_tls_del`` - number of TLS RX HW offload contexts deleted from device
+   (connection has finished).
+ * ``rx_tls_err`` - number of RX packets which were part of a TLS stream
+   but were not decrypted due to unexpected error in the state machine.
  * ``tx_tls_encrypted_packets`` - number of TX packets passed to the device
    for encryption of their TLS payload.
  * ``tx_tls_encrypted_bytes`` - number of TLS payload bytes in TX packets
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
index 83779cbc380a7..13e666403a5df 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
@@ -6,6 +6,9 @@
 #include "en_accel/ktls_utils.h"
 #include "en_accel/fs_tcp.h"
 
+#define KTLS_STATS_INC(priv, rxq, fld) \
+		((priv)->channels.c[rxq]->rq.stats->fld++)
+
 struct accel_rule {
 	struct work_struct work;
 	struct mlx5e_priv *priv;
@@ -218,10 +221,14 @@ void mlx5e_ktls_handle_rx_skb(struct mlx5e_rq *rq, struct sk_buff *skb,
 	switch (tls_offload) {
 	case CQE_TLS_OFFLOAD_DECRYPTED:
 		skb->decrypted = 1;
+		rq->stats->tls_decrypted_packets++;
+		rq->stats->tls_decrypted_bytes += *cqe_bcnt;
 		break;
 	case CQE_TLS_OFFLOAD_RESYNC:
+		rq->stats->tls_ooo++;
 		break;
 	default: /* CQE_TLS_OFFLOAD_ERROR: */
+		rq->stats->tls_err++;
 		break;
 	}
 }
@@ -280,6 +287,8 @@ int mlx5e_ktls_add_rx(struct net_device *netdev, struct sock *sk,
 	if (err)
 		goto err_post_wqes;
 
+	KTLS_STATS_INC(priv, rxq, tls_ctx);
+
 	return 0;
 
 err_post_wqes:
@@ -308,6 +317,7 @@ void mlx5e_ktls_del_rx(struct net_device *netdev, struct tls_context *tls_ctx)
 		 */
 		wait_for_completion(&priv_rx->add_ctx);
 
+	KTLS_STATS_INC(priv, priv_rx->rxq, tls_del);
 	if (priv_rx->rule.rule)
 		mlx5e_accel_fs_del_sk(priv_rx->rule.rule);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
index f009fe09e99b3..13d64e6142069 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
@@ -163,6 +163,14 @@ static const struct counter_desc sw_stats_desc[] = {
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_congst_umr) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_arfs_err) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_recover) },
+#ifdef CONFIG_MLX5_EN_TLS
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_tls_decrypted_packets) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_tls_decrypted_bytes) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_tls_ctx) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_tls_del) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_tls_ooo) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_tls_err) },
+#endif
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, ch_events) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, ch_poll) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, ch_arm) },
@@ -275,6 +283,14 @@ static MLX5E_DECLARE_STATS_GRP_OP_UPDATE_STATS(sw)
 		s->rx_congst_umr  += rq_stats->congst_umr;
 		s->rx_arfs_err    += rq_stats->arfs_err;
 		s->rx_recover     += rq_stats->recover;
+#ifdef CONFIG_MLX5_EN_TLS
+		s->rx_tls_decrypted_packets += rq_stats->tls_decrypted_packets;
+		s->rx_tls_decrypted_bytes   += rq_stats->tls_decrypted_bytes;
+		s->rx_tls_ctx               += rq_stats->tls_ctx;
+		s->rx_tls_del               += rq_stats->tls_del;
+		s->rx_tls_ooo               += rq_stats->tls_ooo;
+		s->rx_tls_err               += rq_stats->tls_err;
+#endif
 		s->ch_events      += ch_stats->events;
 		s->ch_poll        += ch_stats->poll;
 		s->ch_arm         += ch_stats->arm;
@@ -1475,6 +1491,14 @@ static const struct counter_desc rq_stats_desc[] = {
 	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, congst_umr) },
 	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, arfs_err) },
 	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, recover) },
+#ifdef CONFIG_MLX5_EN_TLS
+	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, tls_decrypted_packets) },
+	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, tls_decrypted_bytes) },
+	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, tls_ctx) },
+	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, tls_del) },
+	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, tls_ooo) },
+	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, tls_err) },
+#endif
 };
 
 static const struct counter_desc sq_stats_desc[] = {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
index 2b83ba9907140..b8d4488c9b328 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
@@ -186,6 +186,13 @@ struct mlx5e_sw_stats {
 	u64 tx_tls_skip_no_sync_data;
 	u64 tx_tls_drop_no_sync_data;
 	u64 tx_tls_drop_bypass_req;
+
+	u64 rx_tls_decrypted_packets;
+	u64 rx_tls_decrypted_bytes;
+	u64 rx_tls_ctx;
+	u64 rx_tls_del;
+	u64 rx_tls_ooo;
+	u64 rx_tls_err;
 #endif
 
 	u64 rx_xsk_packets;
@@ -305,6 +312,14 @@ struct mlx5e_rq_stats {
 	u64 congst_umr;
 	u64 arfs_err;
 	u64 recover;
+#ifdef CONFIG_MLX5_EN_TLS
+	u64 tls_decrypted_packets;
+	u64 tls_decrypted_bytes;
+	u64 tls_ctx;
+	u64 tls_del;
+	u64 tls_ooo;
+	u64 tls_err;
+#endif
 };
 
 struct mlx5e_sq_stats {
-- 
2.26.2

