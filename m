Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D12DB6929F4
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 23:18:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233460AbjBJWSf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 17:18:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233395AbjBJWSd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 17:18:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F7BC7E8F8
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 14:18:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3A61E61EBC
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 22:18:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90957C433A0;
        Fri, 10 Feb 2023 22:18:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676067511;
        bh=7yS1E0Wn4MM9lLdScSA3qVflIi/dFkzdvZxLzTtlDiY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=okWHQFl5r+TJlwQ+W6luG5y38SCYUTG/po5ZyZwxfyyC/XUOnWfMScV/lfYmDqvUL
         KyjkQ/oB45xaTNB/TPWVAAJueF0QNJSHZ6rDARUZ7wiEZPxzr4AH4PMd/zdRRX5JgS
         xurQrFyZlDs28fp3t9xyiDRJ6mx7X7b/T0psYH6xKhigKvXmPu2NWTYc9OcrZekOcs
         IEpmhkR1bK2hCO6mqmvRLOi4rXi346JvG2eb4UOkneoydnBYQ3KcQ0zsQspxw5vW7I
         IKywqRbYPBUMTzUy2dxCP79+v66Ayglyo5vKPkmksEBIWRmyXHutwDcJK/D+TS8b81
         Yfp0goHx1s4eQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Maor Dickman <maord@nvidia.com>
Subject: [net-next 02/15] net/mlx5e: TC, Add peer flow in mpesw mode
Date:   Fri, 10 Feb 2023 14:18:08 -0800
Message-Id: <20230210221821.271571-3-saeed@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230210221821.271571-1-saeed@kernel.org>
References: <20230210221821.271571-1-saeed@kernel.org>
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
index 49392870f695..1bccc6c31460 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -463,7 +463,7 @@ static int mlx5_devlink_esw_multiport_get(struct devlink *devlink, u32 id,
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
index 00d5b0aa295b..780b2aa2ace1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -4274,7 +4274,7 @@ static bool is_lag_dev(struct mlx5e_priv *priv,
 
 static bool is_multiport_eligible(struct mlx5e_priv *priv, struct net_device *out_dev)
 {
-	return same_hw_reps(priv, out_dev) && mlx5_lag_mpesw_is_activated(priv->mdev);
+	return same_hw_reps(priv, out_dev) && mlx5_lag_is_mpesw(priv->mdev);
 }
 
 bool mlx5e_is_valid_eswitch_fwd_dev(struct mlx5e_priv *priv,
@@ -4445,6 +4445,9 @@ static bool is_peer_flow_needed(struct mlx5e_tc_flow *flow)
 	    (is_rep_ingress || act_is_encap))
 		return true;
 
+	if (mlx5_lag_is_mpesw(esw_attr->in_mdev))
+		return true;
+
 	return false;
 }
 
@@ -4650,8 +4653,10 @@ static int mlx5e_tc_add_fdb_peer_flow(struct flow_cls_offload *f,
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

