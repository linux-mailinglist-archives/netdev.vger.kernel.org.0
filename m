Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B45ED671696
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 09:52:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229590AbjARIwv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 03:52:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229899AbjARIwX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 03:52:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4372A9CBAE
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 00:04:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B1B0E616F8
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 08:04:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09FC0C433D2;
        Wed, 18 Jan 2023 08:04:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674029074;
        bh=NjmWGKWg1Hyyj1+8FaES53h+gTZH8tqxERHBrtTRspw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BUpTpTv6clvkHm8oue5ATtASsT9xuY+MQX+pFhDCz0UJP2qNc/WLiN7S1V1xzHBWE
         hk831NmkI4qTe5XgH45xd5M26/+HgIZ4v2vt+Gycocouh7LvWLer5aQO5xwl+OS20X
         PBKMU7keA7V+wPZvYoEf0bYXQ0uLlyRGJ4Pt2o+RTNmvLPkDzhOAHj40VEf18Wj0bU
         hrCL1N3eI6sg31hy2oWnq9cv/bWF65mw9+WD37Hb/ysShnyNmOKfplAa+pnF/5Kb6g
         7EDsKLU4Q7/iu5gXsKKVLFw81wq6tQWBbSCa4uFuiC3dYNrR6zBMbeyw+pTiJw0HtJ
         rAvO8RvBjeHNQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Maor Dickman <maord@nvidia.com>, Eli Cohen <elic@nvidia.com>
Subject: [net 05/10] net/mlx5e: QoS, Fix wrongfully setting parent_element_id on MODIFY_SCHEDULING_ELEMENT
Date:   Wed, 18 Jan 2023 00:04:09 -0800
Message-Id: <20230118080414.77902-6-saeed@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230118080414.77902-1-saeed@kernel.org>
References: <20230118080414.77902-1-saeed@kernel.org>
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

From: Maor Dickman <maord@nvidia.com>

According to HW spec parent_element_id field should be reserved (0x0) when calling
MODIFY_SCHEDULING_ELEMENT command.

This patch remove the wrong initialization of reserved field, parent_element_id, on
mlx5_qos_update_node.

Fixes: 214baf22870c ("net/mlx5e: Support HTB offload")
Signed-off-by: Maor Dickman <maord@nvidia.com>
Reviewed-by: Eli Cohen <elic@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/htb.c | 4 ++--
 drivers/net/ethernet/mellanox/mlx5/core/qos.c    | 3 +--
 drivers/net/ethernet/mellanox/mlx5/core/qos.h    | 2 +-
 3 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/htb.c b/drivers/net/ethernet/mellanox/mlx5/core/en/htb.c
index 6dac76fa58a3..09d441ecb9f6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/htb.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/htb.c
@@ -637,7 +637,7 @@ mlx5e_htb_update_children(struct mlx5e_htb *htb, struct mlx5e_qos_node *node,
 		if (child->bw_share == old_bw_share)
 			continue;
 
-		err_one = mlx5_qos_update_node(htb->mdev, child->hw_id, child->bw_share,
+		err_one = mlx5_qos_update_node(htb->mdev, child->bw_share,
 					       child->max_average_bw, child->hw_id);
 		if (!err && err_one) {
 			err = err_one;
@@ -671,7 +671,7 @@ mlx5e_htb_node_modify(struct mlx5e_htb *htb, u16 classid, u64 rate, u64 ceil,
 	mlx5e_htb_convert_rate(htb, rate, node->parent, &bw_share);
 	mlx5e_htb_convert_ceil(htb, ceil, &max_average_bw);
 
-	err = mlx5_qos_update_node(htb->mdev, node->parent->hw_id, bw_share,
+	err = mlx5_qos_update_node(htb->mdev, bw_share,
 				   max_average_bw, node->hw_id);
 	if (err) {
 		NL_SET_ERR_MSG_MOD(extack, "Firmware error when modifying a node.");
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/qos.c b/drivers/net/ethernet/mellanox/mlx5/core/qos.c
index 0777be24a307..8bce730b5c5b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/qos.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/qos.c
@@ -62,13 +62,12 @@ int mlx5_qos_create_root_node(struct mlx5_core_dev *mdev, u32 *id)
 	return mlx5_qos_create_inner_node(mdev, MLX5_QOS_DEFAULT_DWRR_UID, 0, 0, id);
 }
 
-int mlx5_qos_update_node(struct mlx5_core_dev *mdev, u32 parent_id,
+int mlx5_qos_update_node(struct mlx5_core_dev *mdev,
 			 u32 bw_share, u32 max_avg_bw, u32 id)
 {
 	u32 sched_ctx[MLX5_ST_SZ_DW(scheduling_context)] = {0};
 	u32 bitmask = 0;
 
-	MLX5_SET(scheduling_context, sched_ctx, parent_element_id, parent_id);
 	MLX5_SET(scheduling_context, sched_ctx, bw_share, bw_share);
 	MLX5_SET(scheduling_context, sched_ctx, max_average_bw, max_avg_bw);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/qos.h b/drivers/net/ethernet/mellanox/mlx5/core/qos.h
index 125e4e47e6f7..624ce822b7f5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/qos.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/qos.h
@@ -23,7 +23,7 @@ int mlx5_qos_create_leaf_node(struct mlx5_core_dev *mdev, u32 parent_id,
 int mlx5_qos_create_inner_node(struct mlx5_core_dev *mdev, u32 parent_id,
 			       u32 bw_share, u32 max_avg_bw, u32 *id);
 int mlx5_qos_create_root_node(struct mlx5_core_dev *mdev, u32 *id);
-int mlx5_qos_update_node(struct mlx5_core_dev *mdev, u32 parent_id, u32 bw_share,
+int mlx5_qos_update_node(struct mlx5_core_dev *mdev, u32 bw_share,
 			 u32 max_avg_bw, u32 id);
 int mlx5_qos_destroy_node(struct mlx5_core_dev *mdev, u32 id);
 
-- 
2.39.0

