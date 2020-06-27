Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA79320C44E
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 23:22:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726057AbgF0VWz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jun 2020 17:22:55 -0400
Received: from mail-eopbgr60064.outbound.protection.outlook.com ([40.107.6.64]:8866
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726786AbgF0VWz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 27 Jun 2020 17:22:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AoIy3gJ8jbQhHW3LZ6R2UFBFx+KKra6N3WyJB672oxSs2UCPVfkttB0cywVcQlPMhGzpQpAf//6moroxCkURqqlKLFMRRLpjndGFeg5Mg5PCOx+5AiAuTG7tRw40vwPiQUpTWv01Ws5rphsNImcDRA8YIBXYqBIlrHedpyxRSXO0oXdh0lGbt+6hNY3dwWSkaHg0JFMRroBkjc0NLydkXEnMow33njA6GwChLq3oU3mTBGQBE6XfWkveD4euar70OSlP+z6p8pOobOv1yiMUayKL1q4ytgifgVDVpm+VJHL17sEp2BXLA/m/p6GJ2DiPYoet+zyks3EVkdAagcp6Mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x3Ixm4iw754vhQPrXkCgMDNwk6Ghve2LXeKzOafPGuY=;
 b=Xfsqa5jqQx/D6sr+4hCKP5VEjxU07pTS0Ekq6nm8CjrEWL0kBL3T8SlGZYE2bE2ga0ugLNpttJS9n0YxUdsry/b7UHWZYjdDq/coLiMM9DdxvXBPGHt0SiaEn7XGpiVxKbaD11pt8HUMVEzBkhdTWo96KwR8PZnMPTQH2zTT/Ml4KmKQNsSi8ZvtJ0DwkjKykKUS+sJ6G1jyNABhis8S6XkfReDB0+6u+Wudqp7lKbuscS/EWl5WdCCUXA75QklaeU/zEEI/68frwJwzKG1kxnRa1Uw8vbTZi7mJ2UbJC0RQs92biEO7IA9GIL6eO30b+h46/dE05L1A28RtF5SsOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x3Ixm4iw754vhQPrXkCgMDNwk6Ghve2LXeKzOafPGuY=;
 b=RQy6JmGq7e5PHXfUcVtEFIetiyA2evr47G4KHmgcxokmsI/2V1TCF5S3UyVoten/cxjtFtl+pVwhUK5PPQsiniKSnqrMASQQKdlT1tMpQJscHy47rq8Kcu4NtluwiviSr00UdSFdMZgeDvnsU5cStmD8tDOv+vQrnLvxDiy8h5w=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB5134.eurprd05.prod.outlook.com (2603:10a6:803:ad::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.21; Sat, 27 Jun
 2020 21:19:02 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3131.026; Sat, 27 Jun 2020
 21:19:02 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 12/15] net/mlx5e: kTLS, Add kTLS RX stats
Date:   Sat, 27 Jun 2020 14:17:24 -0700
Message-Id: <20200627211727.259569-13-saeedm@mellanox.com>
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
Received: from smtp.office365.com (73.15.39.150) by BY5PR03CA0017.namprd03.prod.outlook.com (2603:10b6:a03:1e0::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.21 via Frontend Transport; Sat, 27 Jun 2020 21:19:00 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: fe505e05-1ca4-403b-e713-08d81adfb6f9
X-MS-TrafficTypeDiagnostic: VI1PR05MB5134:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB5134E558B9C1A089D6EF2F4DBE900@VI1PR05MB5134.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:546;
X-Forefront-PRVS: 0447DB1C71
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: w6ucpyNbWObZtAqartbo5q9ZCijqCSkmrlei9QgUJY7Ju8TN6h9WJ1cTvZ59L0VDAVN1YpsWpxK6QJaDXc4G5qG5xKGFmAra70Lg58coD6y6G5m+ZMjpkvmjf8oD44fGl6OcaMB30eAnyPWFK+ZGqhSj/Pu4btgOfcu+NtfAs00T4WqM6HErX+/GfYzI3RrgTPcucY5wtB3kmZuZ8jbz2HEdoar/bi+R3TsKsnNpaHzx9NDGzyg85Vy2IDbF2tj9/w4q1ImQCf2PXXh/ntrG/fRxNKRKE7bqjPR4Skjt7D05MioQn8QzwTLQPVak3zzj8GeHTMJafAf4TYboroKhXlYTAYyxBj6z9URdJiemOz1avXWUQcNeXCzqT8vlCf9L
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(376002)(136003)(39850400004)(346002)(396003)(66476007)(107886003)(54906003)(478600001)(30864003)(4326008)(316002)(6512007)(16526019)(6506007)(2616005)(1076003)(6486002)(956004)(6666004)(66556008)(8936002)(52116002)(86362001)(36756003)(5660300002)(66946007)(26005)(8676002)(83380400001)(2906002)(186003)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: xR6WxehBmdiQ2X0t81YbQhdYYOATlo0CADRBtCbGh1RxjO79vLRI0u5GIkzOBFs833gEmRA3Gjq7pOB03TovAg0ISx2I2WW0jNSsDsMTD+q5jW6seEf6dRMFD7Dcs1+yEmlBZNrM2lll9PHGao0yvyklPJ3jczBoYIBefF0qBPT7edZe5JgJJSZ0bcy/hDs10EVdRdCqooaJNL5cpmPp+6QOnINRtlra1XKXzp/T359/MlSzfz4g26DfEMtpweKW5FBcAOTh1yqjjN4L/nG2lxCCRFOh+UfhYDP/R/aa4zIjAKaRhsU/zH0u5mZuxf3v19PEY/D473ap6CRMA0FW/iRxKVRazsqvopcjTeD2v5kU0iG6NvywJx/9vrIZlQS7U1stL1Qo5kwEGBXwM3xsKf4ZBtX0BkI6X1/atu4scYvNtgFEhMQ831Se13iG5OReun+aC8Yak5t8VjSDCm/LgYIOThr0xZbayFmJp/PC+e0=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe505e05-1ca4-403b-e713-08d81adfb6f9
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jun 2020 21:19:02.5004
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a/Ggn0SnkTnqagsGEMNjUGVn45uyJFBdcFHT98GhfkODJy12zqIullXhn/qBECaqKHv/T3aCKfRX01z/rtGlDA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5134
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
 Documentation/networking/tls-offload.rst      | 18 +++++++++
 .../mellanox/mlx5/core/en_accel/ktls_rx.c     | 27 +++++++++++--
 .../ethernet/mellanox/mlx5/core/en_stats.c    | 39 +++++++++++++++++++
 .../ethernet/mellanox/mlx5/core/en_stats.h    | 25 ++++++++++++
 4 files changed, 106 insertions(+), 3 deletions(-)

diff --git a/Documentation/networking/tls-offload.rst b/Documentation/networking/tls-offload.rst
index f914e81fd3a6..37773da2bee5 100644
--- a/Documentation/networking/tls-offload.rst
+++ b/Documentation/networking/tls-offload.rst
@@ -428,6 +428,24 @@ by the driver:
    which were part of a TLS stream.
  * ``rx_tls_decrypted_bytes`` - number of TLS payload bytes in RX packets
    which were successfully decrypted.
+ * ``rx_tls_ctx`` - number of TLS RX HW offload contexts added to device for
+   decryption.
+ * ``rx_tls_del`` - number of TLS RX HW offload contexts deleted from device
+   (connection has finished).
+ * ``rx_tls_resync_req_pkt`` - number of received TLS packets with a resync
+    request.
+ * ``rx_tls_resync_req_start`` - number of times the TLS async resync request
+    was started.
+ * ``rx_tls_resync_req_end`` - number of times the TLS async resync request
+    properly ended with providing the HW tracked tcp-seq.
+ * ``rx_tls_resync_req_skip`` - number of times the TLS async resync request
+    procedure was started by not properly ended.
+ * ``rx_tls_resync_res_ok`` - number of times the TLS resync response call to
+    the driver was successfully handled.
+ * ``rx_tls_resync_res_skip`` - number of times the TLS resync response call to
+    the driver was terminated unsuccessfully.
+ * ``rx_tls_err`` - number of RX packets which were part of a TLS stream
+   but were not decrypted due to unexpected error in the state machine.
  * ``tx_tls_encrypted_packets`` - number of TX packets passed to the device
    for encryption of their TLS payload.
  * ``tx_tls_encrypted_bytes`` - number of TLS payload bytes in TX packets
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
index b26dad909ef5..e0a8f9d63b30 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
@@ -46,6 +46,7 @@ struct mlx5e_ktls_offload_context_rx {
 	struct tls12_crypto_info_aes_gcm_128 crypto_info;
 	struct accel_rule rule;
 	struct sock *sk;
+	struct mlx5e_rq_stats *stats;
 	struct completion add_ctx;
 	u32 tirn;
 	u32 key_id;
@@ -203,6 +204,7 @@ static int post_rx_param_wqes(struct mlx5e_channel *c,
 	return err;
 
 err_out:
+	priv_rx->stats->tls_resync_req_skip++;
 	err = PTR_ERR(cseg);
 	complete(&priv_rx->add_ctx);
 	goto unlock;
@@ -296,6 +298,7 @@ resync_post_get_progress_params(struct mlx5e_icosq *sq,
 	return cseg;
 
 err_out:
+	priv_rx->stats->tls_resync_req_skip++;
 	return ERR_PTR(err);
 }
 
@@ -362,11 +365,13 @@ static int resync_handle_seq_match(struct mlx5e_ktls_offload_context_rx *priv_rx
 
 	cseg = post_static_params(sq, priv_rx);
 	if (IS_ERR(cseg)) {
+		priv_rx->stats->tls_resync_res_skip++;
 		err = PTR_ERR(cseg);
 		goto unlock;
 	}
 	/* Do not increment priv_rx refcnt, CQE handling is empty */
 	mlx5e_notify_hw(&sq->wq, sq->pc, sq->uar_map, cseg);
+	priv_rx->stats->tls_resync_res_ok++;
 unlock:
 	spin_unlock(&c->async_icosq_lock);
 
@@ -396,11 +401,14 @@ void mlx5e_ktls_handle_get_psv_completion(struct mlx5e_icosq_wqe_info *wi,
 	tracker_state = MLX5_GET(tls_progress_params, ctx, record_tracker_state);
 	auth_state = MLX5_GET(tls_progress_params, ctx, auth_state);
 	if (tracker_state != MLX5E_TLS_PROGRESS_PARAMS_RECORD_TRACKER_STATE_TRACKING ||
-	    auth_state != MLX5E_TLS_PROGRESS_PARAMS_AUTH_STATE_NO_OFFLOAD)
+	    auth_state != MLX5E_TLS_PROGRESS_PARAMS_AUTH_STATE_NO_OFFLOAD) {
+		priv_rx->stats->tls_resync_req_skip++;
 		goto out;
+	}
 
 	hw_seq = MLX5_GET(tls_progress_params, ctx, hw_resync_tcp_sn);
 	tls_offload_rx_resync_async_request_end(priv_rx->sk, cpu_to_be32(hw_seq));
+	priv_rx->stats->tls_resync_req_end++;
 out:
 	refcount_dec(&resync->refcnt);
 	kfree(buf);
@@ -479,6 +487,7 @@ static void resync_update_sn(struct mlx5e_rq *rq, struct sk_buff *skb)
 	seq = th->seq;
 	datalen = skb->len - depth;
 	tls_offload_rx_resync_async_request_start(sk, seq, datalen);
+	rq->stats->tls_resync_req_start++;
 }
 
 void mlx5e_ktls_rx_resync(struct net_device *netdev, struct sock *sk,
@@ -509,18 +518,25 @@ void mlx5e_ktls_handle_rx_skb(struct mlx5e_rq *rq, struct sk_buff *skb,
 			      struct mlx5_cqe64 *cqe, u32 *cqe_bcnt)
 {
 	u8 tls_offload = get_cqe_tls_offload(cqe);
+	struct mlx5e_rq_stats *stats;
 
 	if (likely(tls_offload == CQE_TLS_OFFLOAD_NOT_DECRYPTED))
 		return;
 
+	stats = rq->stats;
+
 	switch (tls_offload) {
 	case CQE_TLS_OFFLOAD_DECRYPTED:
 		skb->decrypted = 1;
+		stats->tls_decrypted_packets++;
+		stats->tls_decrypted_bytes += *cqe_bcnt;
 		break;
 	case CQE_TLS_OFFLOAD_RESYNC:
+		stats->tls_resync_req_pkt++;
 		resync_update_sn(rq, skb);
 		break;
 	default: /* CQE_TLS_OFFLOAD_ERROR: */
+		stats->tls_err++;
 		break;
 	}
 }
@@ -562,12 +578,14 @@ int mlx5e_ktls_add_rx(struct net_device *netdev, struct sock *sk,
 
 	priv_rx->crypto_info  =
 		*(struct tls12_crypto_info_aes_gcm_128 *)crypto_info;
+
+	rxq = mlx5e_accel_sk_get_rxq(sk);
+	priv_rx->rxq = rxq;
 	priv_rx->sk = sk;
-	priv_rx->rxq = mlx5e_accel_sk_get_rxq(sk);
 
+	priv_rx->stats = &priv->channel_stats[rxq].rq;
 	mlx5e_set_ktls_rx_priv_ctx(tls_ctx, priv_rx);
 
-	rxq = priv_rx->rxq;
 	rqtn = priv->direct_tir[rxq].rqt.rqtn;
 
 	err = mlx5e_ktls_create_tir(mdev, &priv_rx->tirn, rqtn);
@@ -586,6 +604,8 @@ int mlx5e_ktls_add_rx(struct net_device *netdev, struct sock *sk,
 	if (err)
 		goto err_post_wqes;
 
+	priv_rx->stats->tls_ctx++;
+
 	return 0;
 
 err_post_wqes:
@@ -646,6 +666,7 @@ void mlx5e_ktls_del_rx(struct net_device *netdev, struct tls_context *tls_ctx)
 		refcount_dec(&resync->refcnt);
 	wait_for_resync(netdev, resync);
 
+	priv_rx->stats->tls_del++;
 	if (priv_rx->rule.rule)
 		mlx5e_accel_fs_del_sk(priv_rx->rule.rule);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
index f009fe09e99b..e3b2f59408e6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
@@ -163,6 +163,19 @@ static const struct counter_desc sw_stats_desc[] = {
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_congst_umr) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_arfs_err) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_recover) },
+#ifdef CONFIG_MLX5_EN_TLS
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_tls_decrypted_packets) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_tls_decrypted_bytes) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_tls_ctx) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_tls_del) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_tls_resync_req_pkt) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_tls_resync_req_start) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_tls_resync_req_end) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_tls_resync_req_skip) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_tls_resync_res_ok) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_tls_resync_res_skip) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_tls_err) },
+#endif
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, ch_events) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, ch_poll) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, ch_arm) },
@@ -275,6 +288,19 @@ static MLX5E_DECLARE_STATS_GRP_OP_UPDATE_STATS(sw)
 		s->rx_congst_umr  += rq_stats->congst_umr;
 		s->rx_arfs_err    += rq_stats->arfs_err;
 		s->rx_recover     += rq_stats->recover;
+#ifdef CONFIG_MLX5_EN_TLS
+		s->rx_tls_decrypted_packets += rq_stats->tls_decrypted_packets;
+		s->rx_tls_decrypted_bytes   += rq_stats->tls_decrypted_bytes;
+		s->rx_tls_ctx               += rq_stats->tls_ctx;
+		s->rx_tls_del               += rq_stats->tls_del;
+		s->rx_tls_resync_req_pkt    += rq_stats->tls_resync_req_pkt;
+		s->rx_tls_resync_req_start  += rq_stats->tls_resync_req_start;
+		s->rx_tls_resync_req_end    += rq_stats->tls_resync_req_end;
+		s->rx_tls_resync_req_skip   += rq_stats->tls_resync_req_skip;
+		s->rx_tls_resync_res_ok     += rq_stats->tls_resync_res_ok;
+		s->rx_tls_resync_res_skip   += rq_stats->tls_resync_res_skip;
+		s->rx_tls_err               += rq_stats->tls_err;
+#endif
 		s->ch_events      += ch_stats->events;
 		s->ch_poll        += ch_stats->poll;
 		s->ch_arm         += ch_stats->arm;
@@ -1475,6 +1501,19 @@ static const struct counter_desc rq_stats_desc[] = {
 	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, congst_umr) },
 	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, arfs_err) },
 	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, recover) },
+#ifdef CONFIG_MLX5_EN_TLS
+	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, tls_decrypted_packets) },
+	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, tls_decrypted_bytes) },
+	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, tls_ctx) },
+	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, tls_del) },
+	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, tls_resync_req_pkt) },
+	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, tls_resync_req_start) },
+	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, tls_resync_req_end) },
+	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, tls_resync_req_skip) },
+	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, tls_resync_res_ok) },
+	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, tls_resync_res_skip) },
+	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, tls_err) },
+#endif
 };
 
 static const struct counter_desc sq_stats_desc[] = {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
index 2b83ba990714..2e1cca1923b9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
@@ -186,6 +186,18 @@ struct mlx5e_sw_stats {
 	u64 tx_tls_skip_no_sync_data;
 	u64 tx_tls_drop_no_sync_data;
 	u64 tx_tls_drop_bypass_req;
+
+	u64 rx_tls_decrypted_packets;
+	u64 rx_tls_decrypted_bytes;
+	u64 rx_tls_ctx;
+	u64 rx_tls_del;
+	u64 rx_tls_resync_req_pkt;
+	u64 rx_tls_resync_req_start;
+	u64 rx_tls_resync_req_end;
+	u64 rx_tls_resync_req_skip;
+	u64 rx_tls_resync_res_ok;
+	u64 rx_tls_resync_res_skip;
+	u64 rx_tls_err;
 #endif
 
 	u64 rx_xsk_packets;
@@ -305,6 +317,19 @@ struct mlx5e_rq_stats {
 	u64 congst_umr;
 	u64 arfs_err;
 	u64 recover;
+#ifdef CONFIG_MLX5_EN_TLS
+	u64 tls_decrypted_packets;
+	u64 tls_decrypted_bytes;
+	u64 tls_ctx;
+	u64 tls_del;
+	u64 tls_resync_req_pkt;
+	u64 tls_resync_req_start;
+	u64 tls_resync_req_end;
+	u64 tls_resync_req_skip;
+	u64 tls_resync_res_ok;
+	u64 tls_resync_res_skip;
+	u64 tls_err;
+#endif
 };
 
 struct mlx5e_sq_stats {
-- 
2.26.2

