Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 701EE4B638A
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 07:34:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234479AbiBOGdQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 01:33:16 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234488AbiBOGdF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 01:33:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A3F7B2E13
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 22:32:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E1109B80764
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 06:32:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D2D8C340F5;
        Tue, 15 Feb 2022 06:32:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644906762;
        bh=yo8cJ7rWSHVXDEfwXcR6cRFMQH7pcgki4ehryanbJyQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pe4QoK9HHcmlXELIaq5mn9cNO/gOcG/9uuhQ8RMUQEoSvQbPXCWj1RCG8qHW2mEgM
         eSKS8wPo3/MDgy+qIgPGAWg7LSMQcUozbtRjxRH0BX8xFUjzTsDfwYoAMAXNjfoTMI
         kNo4RWqqCnGZ2/cMeGapDwvdj+FPuQEmvZUIR1AOoKY5N9lzS/teZr2gvT2A1UeS1S
         KGWdF6v/5XIFgaz+rmnXFsTfTeyvMziGNZ/zznBWQjq43q6wCYiIB1kbfYYMpencph
         uOF42zU8H6YUbrnsjzbgcbu0kPw1vpLjXBAuD3gZLnbhhrHo700OhbbAsHThHn1hfc
         ku9NpmKMmyBvQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 12/15] net/mlx5e: Use READ_ONCE/WRITE_ONCE for DCBX trust state
Date:   Mon, 14 Feb 2022 22:32:26 -0800
Message-Id: <20220215063229.737960-13-saeed@kernel.org>
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

trust_state can be written while mlx5e_select_queue() is reading it. To
avoid inconsistencies, use READ_ONCE and WRITE_ONCE for access and
updates, and touch the variable only once per operation.

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/selq.c  |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c | 12 +++++++-----
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/selq.c b/drivers/net/ethernet/mellanox/mlx5/core/en/selq.c
index aab2046da45b..b8f1a955944d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/selq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/selq.c
@@ -113,7 +113,7 @@ static int mlx5e_get_dscp_up(struct mlx5e_priv *priv, struct sk_buff *skb)
 static int mlx5e_get_up(struct mlx5e_priv *priv, struct sk_buff *skb)
 {
 #ifdef CONFIG_MLX5_CORE_EN_DCB
-	if (priv->dcbx_dp.trust_state == MLX5_QPTS_TRUST_DSCP)
+	if (READ_ONCE(priv->dcbx_dp.trust_state) == MLX5_QPTS_TRUST_DSCP)
 		return mlx5e_get_dscp_up(priv, skb);
 #endif
 	if (skb_vlan_tag_present(skb))
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c b/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
index a4c8d8d00d5a..d659fe07d464 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
@@ -1142,7 +1142,7 @@ static int mlx5e_update_trust_state_hw(struct mlx5e_priv *priv, void *context)
 	err = mlx5_set_trust_state(priv->mdev, *trust_state);
 	if (err)
 		return err;
-	priv->dcbx_dp.trust_state = *trust_state;
+	WRITE_ONCE(priv->dcbx_dp.trust_state, *trust_state);
 
 	return 0;
 }
@@ -1187,16 +1187,18 @@ static int mlx5e_set_dscp2prio(struct mlx5e_priv *priv, u8 dscp, u8 prio)
 static int mlx5e_trust_initialize(struct mlx5e_priv *priv)
 {
 	struct mlx5_core_dev *mdev = priv->mdev;
+	u8 trust_state;
 	int err;
 
-	priv->dcbx_dp.trust_state = MLX5_QPTS_TRUST_PCP;
-
-	if (!MLX5_DSCP_SUPPORTED(mdev))
+	if (!MLX5_DSCP_SUPPORTED(mdev)) {
+		WRITE_ONCE(priv->dcbx_dp.trust_state, MLX5_QPTS_TRUST_PCP);
 		return 0;
+	}
 
-	err = mlx5_query_trust_state(priv->mdev, &priv->dcbx_dp.trust_state);
+	err = mlx5_query_trust_state(priv->mdev, &trust_state);
 	if (err)
 		return err;
+	WRITE_ONCE(priv->dcbx_dp.trust_state, trust_state);
 
 	mlx5e_params_calc_trust_tx_min_inline_mode(priv->mdev, &priv->channels.params,
 						   priv->dcbx_dp.trust_state);
-- 
2.34.1

