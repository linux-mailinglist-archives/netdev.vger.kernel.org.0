Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 225466A2157
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 19:19:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229838AbjBXSTf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 13:19:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229864AbjBXST3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 13:19:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20B6D6ADFD
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 10:19:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AAE47B81CF6
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 18:19:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E4FAC4339B;
        Fri, 24 Feb 2023 18:19:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677262755;
        bh=HohVasMH6lY+P6Tu+6sUPrVXy6MKxxwabOn+118eqlQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sa/iR3tNKH8eETFbDkS+I+HBvGhyTKeA1sN9gKDNIagGdNxSPEmYMn2MCdkwzmmDz
         dPnqyNB4n7lim71peZnFk5g+zw3aNkN2P2PvcHmUWiAJSC1X9t3yiwHemFyQQCIqUk
         n7U8YDvKgYtfYGQM5iyB8MwhnWPrVByHgzITx2sS3JwvOy+cXnd31X9tmq50HqMLnr
         3ZEWm0a53citW/2sNYWJdFEHwXAReq1pPONsH32fOCgL7F4ptzG5SjkcuWcClKvQ1h
         egLoA97zcVdWwOklJ3szt/EM/X7S3gXGxnufkjaSeojEY9CfUmXons2SfoUVXGQJF5
         kBKcUcEhaGACw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Vadim Fedorenko <vadfed@meta.com>
Subject: [net V2 4/7] mlx5: fix possible ptp queue fifo use-after-free
Date:   Fri, 24 Feb 2023 10:19:01 -0800
Message-Id: <20230224181904.671473-5-saeed@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230224181904.671473-1-saeed@kernel.org>
References: <20230224181904.671473-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vadim Fedorenko <vadfed@meta.com>

Fifo indexes are not checked during pop operations and it leads to
potential use-after-free when poping from empty queue. Such case was
possible during re-sync action. WARN_ON_ONCE covers future cases.

There were out-of-order cqe spotted which lead to drain of the queue and
use-after-free because of lack of fifo pointers check. Special check and
counter are added to avoid resync operation if SKB could not exist in the
fifo because of OOO cqe (skb_id must be between consumer and producer
index).

Fixes: 58a518948f60 ("net/mlx5e: Add resiliency for PTP TX port timestamp")
Signed-off-by: Vadim Fedorenko <vadfed@meta.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/ptp.c  | 19 ++++++++++++++++++-
 .../net/ethernet/mellanox/mlx5/core/en/txrx.h |  2 ++
 .../ethernet/mellanox/mlx5/core/en_stats.c    |  1 +
 .../ethernet/mellanox/mlx5/core/en_stats.h    |  1 +
 4 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
index 392db8d5e9c7..eb5aeba3addf 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
@@ -86,6 +86,17 @@ static bool mlx5e_ptp_ts_cqe_drop(struct mlx5e_ptpsq *ptpsq, u16 skb_cc, u16 skb
 	return (ptpsq->ts_cqe_ctr_mask && (skb_cc != skb_id));
 }
 
+static bool mlx5e_ptp_ts_cqe_ooo(struct mlx5e_ptpsq *ptpsq, u16 skb_id)
+{
+	u16 skb_cc = PTP_WQE_CTR2IDX(ptpsq->skb_fifo_cc);
+	u16 skb_pc = PTP_WQE_CTR2IDX(ptpsq->skb_fifo_pc);
+
+	if (PTP_WQE_CTR2IDX(skb_id - skb_cc) >= PTP_WQE_CTR2IDX(skb_pc - skb_cc))
+		return true;
+
+	return false;
+}
+
 static void mlx5e_ptp_skb_fifo_ts_cqe_resync(struct mlx5e_ptpsq *ptpsq, u16 skb_cc,
 					     u16 skb_id, int budget)
 {
@@ -120,8 +131,14 @@ static void mlx5e_ptp_handle_ts_cqe(struct mlx5e_ptpsq *ptpsq,
 		goto out;
 	}
 
-	if (mlx5e_ptp_ts_cqe_drop(ptpsq, skb_cc, skb_id))
+	if (mlx5e_ptp_ts_cqe_drop(ptpsq, skb_cc, skb_id)) {
+		if (mlx5e_ptp_ts_cqe_ooo(ptpsq, skb_id)) {
+			/* already handled by a previous resync */
+			ptpsq->cq_stats->ooo_cqe_drop++;
+			return;
+		}
 		mlx5e_ptp_skb_fifo_ts_cqe_resync(ptpsq, skb_cc, skb_id, budget);
+	}
 
 	skb = mlx5e_skb_fifo_pop(&ptpsq->skb_fifo);
 	hwtstamp = mlx5e_cqe_ts_to_ns(sq->ptp_cyc2time, sq->clock, get_cqe_ts(cqe));
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
index 2c10adbf1849..b9c2f67d3794 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
@@ -302,6 +302,8 @@ void mlx5e_skb_fifo_push(struct mlx5e_skb_fifo *fifo, struct sk_buff *skb)
 static inline
 struct sk_buff *mlx5e_skb_fifo_pop(struct mlx5e_skb_fifo *fifo)
 {
+	WARN_ON_ONCE(*fifo->pc == *fifo->cc);
+
 	return *mlx5e_skb_fifo_get(fifo, (*fifo->cc)++);
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
index 6687b8136e44..4478223c1720 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
@@ -2138,6 +2138,7 @@ static const struct counter_desc ptp_cq_stats_desc[] = {
 	{ MLX5E_DECLARE_PTP_CQ_STAT(struct mlx5e_ptp_cq_stats, abort_abs_diff_ns) },
 	{ MLX5E_DECLARE_PTP_CQ_STAT(struct mlx5e_ptp_cq_stats, resync_cqe) },
 	{ MLX5E_DECLARE_PTP_CQ_STAT(struct mlx5e_ptp_cq_stats, resync_event) },
+	{ MLX5E_DECLARE_PTP_CQ_STAT(struct mlx5e_ptp_cq_stats, ooo_cqe_drop) },
 };
 
 static const struct counter_desc ptp_rq_stats_desc[] = {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
index 375752d6546d..b77100b60b50 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
@@ -461,6 +461,7 @@ struct mlx5e_ptp_cq_stats {
 	u64 abort_abs_diff_ns;
 	u64 resync_cqe;
 	u64 resync_event;
+	u64 ooo_cqe_drop;
 };
 
 struct mlx5e_rep_stats {
-- 
2.39.1

