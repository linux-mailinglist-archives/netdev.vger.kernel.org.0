Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 465094B6393
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 07:34:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234465AbiBOGdL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 01:33:11 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234482AbiBOGdF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 01:33:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 649B2B16DC
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 22:32:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 45EB261510
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 06:32:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD50CC340F3;
        Tue, 15 Feb 2022 06:32:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644906763;
        bh=vq1OMSN4ckjnKYuTU3o8OX3jb7mcHpCb+VFbE7UyrUY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h15ppQGRigI1PA3Quesr9jTwPLIOs4NyFpUqMQXzhBjUJIB7iJVechvi2VFQ3z9ke
         pySdFVJjNCewvSXvpGpwSw9IRnAjQVb8SU9/UeaA6iKl1LozUElCjH7e1i2Ye84l9+
         S/wsFwW6+TlMgU0Ldqk0XqKnfIhiaIv1LTrqiS3iL9qjUuCRgX0JiZ+UuJtO6P0tx0
         BoLI2xHmOirxY81NDb+RJR46NieVj0LrDK7tOeYHT7VXgBy6FQb5CrDitnAhvBKxUm
         XcjATsQVoL2316hv7Lkm8WBb3o/NVtZWhkG9MNPo++CWiOQVhOpxo84pNR4i1Bf6Ig
         inE9pb3SwpldA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 13/15] net/mlx5e: Optimize mlx5e_select_queue
Date:   Mon, 14 Feb 2022 22:32:27 -0800
Message-Id: <20220215063229.737960-14-saeed@kernel.org>
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

This commit optimizes mlx5e_select_queue for HTB and PTP cases by
short-cutting some checks, without sacrificing performance of the common
non-HTB non-PTP flow.

1. The HTB flow uses the fact that num_tcs == 1 to drop these checks
(it's not possible to attach both mqprio and htb as the root qdisc).
It's also enough to calculate `txq_ix % num_channels` only once, instead
of twice.

2. The PTP flow drops the check for HTB and the second calculation of
`txq_ix % num_channels`.

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/selq.c | 58 ++++++++++++++-----
 1 file changed, 42 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/selq.c b/drivers/net/ethernet/mellanox/mlx5/core/en/selq.c
index b8f1a955944d..b3ed5262d2a1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/selq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/selq.c
@@ -164,36 +164,62 @@ u16 mlx5e_select_queue(struct net_device *dev, struct sk_buff *skb,
 	if (unlikely(!selq))
 		return 0;
 
-	if (unlikely(selq->is_ptp || selq->is_htb)) {
-		if (unlikely(selq->is_htb)) {
-			txq_ix = mlx5e_select_htb_queue(priv, skb);
-			if (txq_ix > 0)
-				return txq_ix;
-		}
+	if (likely(!selq->is_ptp && !selq->is_htb)) {
+		/* No special queues, netdev_pick_tx returns one of the regular ones. */
+
+		txq_ix = netdev_pick_tx(dev, skb, NULL);
+
+		if (selq->num_tcs <= 1)
+			return txq_ix;
+
+		up = mlx5e_get_up(priv, skb);
+
+		/* Normalize any picked txq_ix to [0, num_channels),
+		 * So we can return a txq_ix that matches the channel and
+		 * packet UP.
+		 */
+		return txq_ix % selq->num_channels + up * selq->num_channels;
+	}
+
+	if (unlikely(selq->is_htb)) {
+		/* num_tcs == 1, shortcut for PTP */
+
+		txq_ix = mlx5e_select_htb_queue(priv, skb);
+		if (txq_ix > 0)
+			return txq_ix;
 
 		if (unlikely(selq->is_ptp && mlx5e_use_ptpsq(skb)))
-			return mlx5e_select_ptpsq(dev, skb, selq);
+			return selq->num_channels;
 
 		txq_ix = netdev_pick_tx(dev, skb, NULL);
+
 		/* Fix netdev_pick_tx() not to choose ptp_channel and HTB txqs.
 		 * If they are selected, switch to regular queues.
 		 * Driver to select these queues only at mlx5e_select_ptpsq()
 		 * and mlx5e_select_htb_queue().
 		 */
-		if (unlikely(txq_ix >= selq->num_regular_queues))
-			txq_ix %= selq->num_regular_queues;
-	} else {
-		txq_ix = netdev_pick_tx(dev, skb, NULL);
+		return txq_ix % selq->num_channels;
 	}
 
+	/* PTP is enabled */
+
+	if (mlx5e_use_ptpsq(skb))
+		return mlx5e_select_ptpsq(dev, skb, selq);
+
+	txq_ix = netdev_pick_tx(dev, skb, NULL);
+
+	/* Normalize any picked txq_ix to [0, num_channels). Queues in range
+	 * [0, num_regular_queues) will be mapped to the corresponding channel
+	 * index, so that we can apply the packet's UP (if num_tcs > 1).
+	 * If netdev_pick_tx() picks ptp_channel, switch to a regular queue,
+	 * because driver should select the PTP only at mlx5e_select_ptpsq().
+	 */
+	txq_ix %= selq->num_channels;
+
 	if (selq->num_tcs <= 1)
 		return txq_ix;
 
 	up = mlx5e_get_up(priv, skb);
 
-	/* Normalize any picked txq_ix to [0, num_channels),
-	 * So we can return a txq_ix that matches the channel and
-	 * packet UP.
-	 */
-	return txq_ix % selq->num_channels + up * selq->num_channels;
+	return txq_ix + up * selq->num_channels;
 }
-- 
2.34.1

