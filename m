Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA0116A1313
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 23:53:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229641AbjBWWxE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 17:53:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229569AbjBWWxC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 17:53:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59F7A126CD
        for <netdev@vger.kernel.org>; Thu, 23 Feb 2023 14:53:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5F846617C3
        for <netdev@vger.kernel.org>; Thu, 23 Feb 2023 22:53:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42C87C433EF;
        Thu, 23 Feb 2023 22:53:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677192780;
        bh=vOscn5yB0NBC/cQp9EjJoR6OL5sjluDhWmCxkjGTLxE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kJauO6CggH/oO9JgHBb2iKNw3ZmmfHQHsdo/5SWUTXsRKc0h9qfRqqHHMipd9O7H4
         ByyKLNWQxaQ/KqfLND4Un8N8zirgJFJMa/gW1xwMXfbrl+v4j1u5qKb+Fhe4krHqx8
         OdpUl9KVjxnadppue/u/7AUQ510q2Zig3TYqYDMv2rMDdNW2TPDUBAzJVoUKu1Nq3t
         mUBDQdyac2+tRYcw1bTypt+eCeLRPwDII8RWu27fHjnL1+/kfM4+HppuBGCSvluQZv
         WoBHGaAA/v/Ho/obsnbNT+yOp2++Ls6zKAlnaDu97oJDhnGe33ojUwLBndSrbz9cpL
         bPYtTsqxF5VFA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Vadim Fedorenko <vadfed@meta.com>,
        Gal Pressman <gal@nvidia.com>
Subject: [net 05/10] mlx5: fix skb leak while fifo resync and push
Date:   Thu, 23 Feb 2023 14:52:42 -0800
Message-Id: <20230223225247.586552-6-saeed@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230223225247.586552-1-saeed@kernel.org>
References: <20230223225247.586552-1-saeed@kernel.org>
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

During ptp resync operation SKBs were poped from the fifo but were never
freed neither by napi_consume nor by dev_kfree_skb_any. Add call to
napi_consume_skb to properly free SKBs.

Another leak was happening because mlx5e_skb_fifo_has_room() had an error
in the check. Comparing free running counters works well unless C promotes
the types to something wider than the counter. In this case counters are
u16 but the result of the substraction is promouted to int and it causes
wrong result (negative value) of the check when producer have already
overlapped but consumer haven't yet. Explicit cast to u16 fixes the issue.

Fixes: 58a518948f60 ("net/mlx5e: Add resiliency for PTP TX port timestamp")
Reviewed-by: Gal Pressman <gal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Vadim Fedorenko <vadfed@meta.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c  | 6 ++++--
 drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h | 2 +-
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
index 9a1bc93b7dc6..392db8d5e9c7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
@@ -86,7 +86,8 @@ static bool mlx5e_ptp_ts_cqe_drop(struct mlx5e_ptpsq *ptpsq, u16 skb_cc, u16 skb
 	return (ptpsq->ts_cqe_ctr_mask && (skb_cc != skb_id));
 }
 
-static void mlx5e_ptp_skb_fifo_ts_cqe_resync(struct mlx5e_ptpsq *ptpsq, u16 skb_cc, u16 skb_id)
+static void mlx5e_ptp_skb_fifo_ts_cqe_resync(struct mlx5e_ptpsq *ptpsq, u16 skb_cc,
+					     u16 skb_id, int budget)
 {
 	struct skb_shared_hwtstamps hwts = {};
 	struct sk_buff *skb;
@@ -98,6 +99,7 @@ static void mlx5e_ptp_skb_fifo_ts_cqe_resync(struct mlx5e_ptpsq *ptpsq, u16 skb_
 		hwts.hwtstamp = mlx5e_skb_cb_get_hwts(skb)->cqe_hwtstamp;
 		skb_tstamp_tx(skb, &hwts);
 		ptpsq->cq_stats->resync_cqe++;
+		napi_consume_skb(skb, budget);
 		skb_cc = PTP_WQE_CTR2IDX(ptpsq->skb_fifo_cc);
 	}
 }
@@ -119,7 +121,7 @@ static void mlx5e_ptp_handle_ts_cqe(struct mlx5e_ptpsq *ptpsq,
 	}
 
 	if (mlx5e_ptp_ts_cqe_drop(ptpsq, skb_cc, skb_id))
-		mlx5e_ptp_skb_fifo_ts_cqe_resync(ptpsq, skb_cc, skb_id);
+		mlx5e_ptp_skb_fifo_ts_cqe_resync(ptpsq, skb_cc, skb_id, budget);
 
 	skb = mlx5e_skb_fifo_pop(&ptpsq->skb_fifo);
 	hwtstamp = mlx5e_cqe_ts_to_ns(sq->ptp_cyc2time, sq->clock, get_cqe_ts(cqe));
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
index c067d2efab51..2c10adbf1849 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
@@ -86,7 +86,7 @@ void mlx5e_free_txqsq_descs(struct mlx5e_txqsq *sq);
 static inline bool
 mlx5e_skb_fifo_has_room(struct mlx5e_skb_fifo *fifo)
 {
-	return (*fifo->pc - *fifo->cc) < fifo->mask;
+	return (u16)(*fifo->pc - *fifo->cc) < fifo->mask;
 }
 
 static inline bool
-- 
2.39.1

