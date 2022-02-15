Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD0064B6385
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 07:34:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234482AbiBOGdL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 01:33:11 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234474AbiBOGdE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 01:33:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E293CAB45C
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 22:32:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8344DB80764
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 06:32:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04102C340F4;
        Tue, 15 Feb 2022 06:32:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644906759;
        bh=V36DAGgGDu2ZZl2rbpPvwgz8CWVd7enL6itC8+sd3TA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PU5eMmVtB4dkP1N84wv2JOhawjUJoDRWDu/C8zuBLYjgkY2pY/WPltiz/jPMe+U1U
         UqttgHK+j/Wib36eURbf1u1JfLhrZsrPDYpMky+lH/3cVF/k9dPIR8BCg0ID+E9Hps
         65kjhGg9HxSWl+SVNZwwRlv3hqboa0kIMONHArLSQ3LE7QYIgqFl73qPPTSY17qFQV
         kKih5jYqsXtwvAoxhbXnxlwoQ4GqcNarK8n5B4g/UISRgNEV0Ow1K3CrccQx4DTC1U
         gSqqbCU+u4HO7ETr1yxRvAAzchPwDz2nHwneT/HJn/mnKBcZMGbyHe6NmNeu9tTq48
         mT1whoMMECRiQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 06/15] net/mlx5e: Use a barrier after updating txq2sq
Date:   Mon, 14 Feb 2022 22:32:20 -0800
Message-Id: <20220215063229.737960-7-saeed@kernel.org>
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

mlx5e_build_txq_maps updates txq2sq while TX queues are stopped. Add a
barrier to ensure that these changes are visible before the queues are
started and mlx5e_xmit reads from txq2sq.

This commit handles regular TX queues. Synchronization between HTB TX
queues and mlx5e_xmit is handled in the following commit.

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index d84d9cdbdbd4..e64c3cb15ef6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -2688,10 +2688,10 @@ static void mlx5e_build_txq_maps(struct mlx5e_priv *priv)
 	}
 
 	if (!priv->channels.ptp)
-		return;
+		goto out;
 
 	if (!test_bit(MLX5E_PTP_STATE_TX, priv->channels.ptp->state))
-		return;
+		goto out;
 
 	for (tc = 0; tc < num_tc; tc++) {
 		struct mlx5e_ptp *c = priv->channels.ptp;
@@ -2700,6 +2700,13 @@ static void mlx5e_build_txq_maps(struct mlx5e_priv *priv)
 		priv->txq2sq[sq->txq_ix] = sq;
 		priv->port_ptp_tc2realtxq[tc] = priv->num_tc_x_num_ch + tc;
 	}
+
+out:
+	/* Make the change to txq2sq visible before the queue is started.
+	 * As mlx5e_xmit runs under a spinlock, there is an implicit ACQUIRE,
+	 * which pairs with this barrier.
+	 */
+	smp_wmb();
 }
 
 static void mlx5e_update_num_tc_x_num_ch(struct mlx5e_priv *priv)
-- 
2.34.1

