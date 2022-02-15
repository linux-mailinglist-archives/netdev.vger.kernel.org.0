Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBD164B638B
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 07:34:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234502AbiBOGdP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 01:33:15 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234481AbiBOGdF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 01:33:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8A06B16FB
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 22:32:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C8E0B61522
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 06:32:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AB89C340F0;
        Tue, 15 Feb 2022 06:32:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644906763;
        bh=RTDswTPBqcxc+7Ygh6YESof3KGDTmsAK2csEltzhDYM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jb8lOvD/YCbUATWzRhrUAuYvB5ByWzDdtXnkQQCPYoe+CMuj1bpMb9A6neuoiK/rE
         XBnr4J/sEoMC6RBYyBotD3zVPFaHVmLde8EkFqHx/OwO6V0kbIO3Or/FF9a41bCREZ
         qrX8ta4jX1IXpaYI88LPjznjAB7umg6RYbLD7L9mAp9cW2e9/QZjyLKLhsMtmxbh74
         6DOp/T4Ti/pCGdhhsieCVoqfvk7oi0In5Ix8Zgq19y630RGAgyZXywhl7BuAed7nU3
         GU6WH45KEVXpOc3IGOdSFpKv7VqnYWEQ+71ptXt04nk1SykxU6p+AZrrrfLTYzBAWu
         gaDxTnEJZ/qhg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 14/15] net/mlx5e: Optimize modulo in mlx5e_select_queue
Date:   Mon, 14 Feb 2022 22:32:28 -0800
Message-Id: <20220215063229.737960-15-saeed@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220215063229.737960-1-saeed@kernel.org>
References: <20220215063229.737960-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@nvidia.com>

To improve the performance of the modulo operation (%), it's replaced by
a subtracting the divisor in a loop. The modulo is used to fix up an
out-of-bounds value that might be returned by netdev_pick_tx or to
convert the queue number to the channel number when num_tcs > 1. Both
situations are unlikely, because XPS is configured not to pick higher
queues (qid >= num_channels) by default, so under normal circumstances
the flow won't go inside the loop, and it will be faster than %.

num_tcs == 8 adds at most 7 iterations to the loop. PTP adds at most 1
iteration to the loop. HTB would add at most 256 iterations (when
num_channels == 1), so there is an additional boundary check in the HTB
flow, which falls back to % if more than 7 iterations are expected.

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/selq.c |  7 ++++---
 .../net/ethernet/mellanox/mlx5/core/en/selq.h | 20 +++++++++++++++++++
 2 files changed, 24 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/selq.c b/drivers/net/ethernet/mellanox/mlx5/core/en/selq.c
index b3ed5262d2a1..667bc95a0d44 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/selq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/selq.c
@@ -178,7 +178,8 @@ u16 mlx5e_select_queue(struct net_device *dev, struct sk_buff *skb,
 		 * So we can return a txq_ix that matches the channel and
 		 * packet UP.
 		 */
-		return txq_ix % selq->num_channels + up * selq->num_channels;
+		return mlx5e_txq_to_ch_ix(txq_ix, selq->num_channels) +
+			up * selq->num_channels;
 	}
 
 	if (unlikely(selq->is_htb)) {
@@ -198,7 +199,7 @@ u16 mlx5e_select_queue(struct net_device *dev, struct sk_buff *skb,
 		 * Driver to select these queues only at mlx5e_select_ptpsq()
 		 * and mlx5e_select_htb_queue().
 		 */
-		return txq_ix % selq->num_channels;
+		return mlx5e_txq_to_ch_ix_htb(txq_ix, selq->num_channels);
 	}
 
 	/* PTP is enabled */
@@ -214,7 +215,7 @@ u16 mlx5e_select_queue(struct net_device *dev, struct sk_buff *skb,
 	 * If netdev_pick_tx() picks ptp_channel, switch to a regular queue,
 	 * because driver should select the PTP only at mlx5e_select_ptpsq().
 	 */
-	txq_ix %= selq->num_channels;
+	txq_ix = mlx5e_txq_to_ch_ix(txq_ix, selq->num_channels);
 
 	if (selq->num_tcs <= 1)
 		return txq_ix;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/selq.h b/drivers/net/ethernet/mellanox/mlx5/core/en/selq.h
index b1c73b509f6b..6c070141d8f1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/selq.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/selq.h
@@ -25,6 +25,26 @@ void mlx5e_selq_prepare(struct mlx5e_selq *selq, struct mlx5e_params *params, bo
 void mlx5e_selq_apply(struct mlx5e_selq *selq);
 void mlx5e_selq_cancel(struct mlx5e_selq *selq);
 
+static inline u16 mlx5e_txq_to_ch_ix(u16 txq, u16 num_channels)
+{
+	while (unlikely(txq >= num_channels))
+		txq -= num_channels;
+	return txq;
+}
+
+static inline u16 mlx5e_txq_to_ch_ix_htb(u16 txq, u16 num_channels)
+{
+	if (unlikely(txq >= num_channels)) {
+		if (unlikely(txq >= num_channels << 3))
+			txq %= num_channels;
+		else
+			do
+				txq -= num_channels;
+			while (txq >= num_channels);
+	}
+	return txq;
+}
+
 u16 mlx5e_select_queue(struct net_device *dev, struct sk_buff *skb,
 		       struct net_device *sb_dev);
 
-- 
2.34.1

