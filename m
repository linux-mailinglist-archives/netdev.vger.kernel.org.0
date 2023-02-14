Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4693C697078
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 23:14:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233403AbjBNWOS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 17:14:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233357AbjBNWOO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 17:14:14 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 571A1305E9
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 14:14:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 7F776CE2246
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 22:14:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5BA2C433D2;
        Tue, 14 Feb 2023 22:14:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676412848;
        bh=KGfgOYqua+PlwhaOcrplds636uJqCrPFLP1Tw+6o0t8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rKzCweuI6MRAw4/td92M2WpdTGACyF5gtJnuc30KDHJ7t4yfKn/Jn7baQ4m2kvT1M
         NbaEVU7WObnh/xC6qmFMQ6PTpqaOeho69tFK9L+YPPSGxLRoxFGa1qLXplJOD3k5t7
         Rw7OgcX8o6qu1n/vVYR/5WihBjx+/JayyUncTVitS9wa1GXmLLo58KmeyqYUBYdcIP
         lDRwqTH6xKQkYoV/KcWPVeZd4ItexAczaopoD6xEuKxCZzd/tOiVDbUPugOA1h3Qut
         zKtlzLrQram5XRspkiN004ukd/kKKTSe5jxVOb64M7HdqX99GOxT6QQhJ8kqN1DW4z
         24ABkV6NymgzQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Maor Dickman <maord@nvidia.com>
Subject: [net-next V2 02/15] net/mlx5e: TC, Add peer flow in mpesw mode
Date:   Tue, 14 Feb 2023 14:12:26 -0800
Message-Id: <20230214221239.159033-3-saeed@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230214221239.159033-1-saeed@kernel.org>
References: <20230214221239.159033-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

While at it rename mlx5_lag_mpesw_is_activated() to mlx5_lag_is_mpesw() to
be consistent with checking if other lag modes are activated.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/devlink.c        | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c      | 3 ++-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c          | 9 +++++++--
 .../net/ethernet/mellanox/mlx5/core/eswitch_offloads.c   | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c      | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.h      | 2 +-
 6 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index 4c9dde377e7d..2d36123cc05e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -461,7 +461,7 @@ static int mlx5_devlink_esw_multiport_get(struct devlink *devlink, u32 id,
 	if (!MLX5_ESWITCH_MANAGER(dev))
 		return -EOPNOTSUPP;
 
-	ctx->val.vbool = mlx5_lag_mpesw_is_activated(dev);
+	ctx->val.vbool = mlx5_lag_is_mpesw(dev);
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
index 83bb0811e774..684c0293a4d6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
@@ -97,7 +97,8 @@ static int get_route_and_out_devs(struct mlx5e_priv *priv,
 	      mlx5e_is_uplink_rep(netdev_priv(*out_dev))))
 		return -EOPNOTSUPP;
 
-	if (mlx5e_eswitch_uplink_rep(priv->netdev) && *out_dev != priv->netdev)
+	if (mlx5e_eswitch_uplink_rep(priv->netdev) && *out_dev != priv->netdev &&
+	    !mlx5_lag_is_mpesw(priv->mdev))
 		return -EOPNOTSUPP;
 
 	return 0;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index dcfeb0077152..fd2a0b431f3d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -4311,7 +4311,7 @@ static bool is_lag_dev(struct mlx5e_priv *priv,
 
 static bool is_multiport_eligible(struct mlx5e_priv *priv, struct net_device *out_dev)
 {
-	return same_hw_reps(priv, out_dev) && mlx5_lag_mpesw_is_activated(priv->mdev);
+	return same_hw_reps(priv, out_dev) && mlx5_lag_is_mpesw(priv->mdev);
 }
 
 bool mlx5e_is_valid_eswitch_fwd_dev(struct mlx5e_priv *priv,
@@ -4482,6 +4482,9 @@ static bool is_peer_flow_needed(struct mlx5e_tc_flow *flow)
 	    (is_rep_ingress || act_is_encap))
 		return true;
 
+	if (mlx5_lag_is_mpesw(esw_attr->in_mdev))
+		return true;
+
 	return false;
 }
 
@@ -4687,8 +4690,10 @@ static int mlx5e_tc_add_fdb_peer_flow(struct flow_cls_offload *f,
 	 * So packets redirected to uplink use the same mdev of the
 	 * original flow and packets redirected from uplink use the
 	 * peer mdev.
+	 * In multiport eswitch it's a special case that we need to
+	 * keep the original mdev.
 	 */
-	if (attr->in_rep->vport == MLX5_VPORT_UPLINK)
+	if (attr->in_rep->vport == MLX5_VPORT_UPLINK && !mlx5_lag_is_mpesw(priv->mdev))
 		in_mdev = peer_priv->mdev;
 	else
 		in_mdev = priv->mdev;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 8fb09143e9e8..2a98375a0abf 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -443,7 +443,7 @@ esw_setup_vport_dest(struct mlx5_flow_destination *dest, struct mlx5_flow_act *f
 			MLX5_CAP_GEN(esw_attr->dests[attr_idx].mdev, vhca_id);
 		dest[dest_idx].vport.flags |= MLX5_FLOW_DEST_VPORT_VHCA_ID;
 		if (dest[dest_idx].vport.num == MLX5_VPORT_UPLINK &&
-		    mlx5_lag_mpesw_is_activated(esw->dev))
+		    mlx5_lag_is_mpesw(esw->dev))
 			dest[dest_idx].type = MLX5_FLOW_DESTINATION_TYPE_UPLINK;
 	}
 	if (esw_attr->dests[attr_idx].flags & MLX5_ESW_DEST_ENCAP_VALID) {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
index 3f8fc965cec6..dd3cb9aa06fd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
@@ -116,7 +116,7 @@ int mlx5_lag_mpesw_do_mirred(struct mlx5_core_dev *mdev,
 	return -EOPNOTSUPP;
 }
 
-bool mlx5_lag_mpesw_is_activated(struct mlx5_core_dev *dev)
+bool mlx5_lag_is_mpesw(struct mlx5_core_dev *dev)
 {
 	struct mlx5_lag *ldev = mlx5_lag_dev(dev);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.h b/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.h
index 571e4acf262e..d857ea988bf2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.h
@@ -27,7 +27,7 @@ struct mlx5_mpesw_work_st {
 int mlx5_lag_mpesw_do_mirred(struct mlx5_core_dev *mdev,
 			     struct net_device *out_dev,
 			     struct netlink_ext_ack *extack);
-bool mlx5_lag_mpesw_is_activated(struct mlx5_core_dev *dev);
+bool mlx5_lag_is_mpesw(struct mlx5_core_dev *dev);
 void mlx5_lag_mpesw_disable(struct mlx5_core_dev *dev);
 int mlx5_lag_mpesw_enable(struct mlx5_core_dev *dev);
 
-- 
2.39.1

