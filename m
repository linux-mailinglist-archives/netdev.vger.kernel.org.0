Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 044A956D77F
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 10:14:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229785AbiGKIOU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 04:14:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229756AbiGKIOR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 04:14:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E8E513F47
        for <netdev@vger.kernel.org>; Mon, 11 Jul 2022 01:14:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 27AC260F70
        for <netdev@vger.kernel.org>; Mon, 11 Jul 2022 08:14:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 713ACC34115;
        Mon, 11 Jul 2022 08:14:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657527255;
        bh=mllzFysS/YIN/ou6nluhdNd6EcfbVvMW9WfnQ9cK17A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lkJ5yMwNQo1Cu1Lm48PUuqKzDId+Eqgb4SzayO6qZDmTU47Vl9ipTaJagOQNRHhqg
         BwUa0XMUtNPGu0CIC3FN5OpjRyUh19HGcbTT544aZ8IkBSw+VD1gxQeITA/4xLtzVs
         ug7JWUKQdk807Ls5U/bNfDPTRyxpwqLCefW3xnC+YJqx345fs9lTJyD7Teusj0KRhl
         yZawrDcadvDDk7T5KS1VWSbqKOCItgnwDvzJXYfaK2Xgov+xjlGpZzsrnVcMCHs6Ro
         Ugy+PB+sqQA4AcCBCIoUJuR9sqkWIQlD6ZZgiIXv6awKYZ3hXyd9VLCAlsQ/FkuuV7
         Mp5nGII6PT2wQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Moshe Shemesh <moshe@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>
Subject: [PATCH net-next 2/9] net/mlx5: Use devl_ API for rate nodes destroy
Date:   Mon, 11 Jul 2022 01:14:01 -0700
Message-Id: <20220711081408.69452-3-saeed@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220711081408.69452-1-saeed@kernel.org>
References: <20220711081408.69452-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Moshe Shemesh <moshe@nvidia.com>

Use devl_rate_nodes_destroy() instead of devlink_rate_nodes_destroy().
Add devlink instance lock in the driver paths to this function to have
it locked while calling devl_ API function.

This will be used by the downstream patch to invoke
mlx5_devlink_eswitch_mode_set() with devlink lock held.

Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  | 14 ++++++++++++--
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |  2 ++
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index b938632f89ff..571114e4878f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1330,9 +1330,13 @@ int mlx5_eswitch_enable(struct mlx5_eswitch *esw, int num_vfs)
 /* When disabling sriov, free driver level resources. */
 void mlx5_eswitch_disable_sriov(struct mlx5_eswitch *esw, bool clear_vf)
 {
+	struct devlink *devlink;
+
 	if (!mlx5_esw_allowed(esw))
 		return;
 
+	devlink = priv_to_devlink(esw->dev);
+	devl_lock(devlink);
 	down_write(&esw->mode_lock);
 	/* If driver is unloaded, this function is called twice by remove_one()
 	 * and mlx5_unload(). Prevent the second call.
@@ -1354,13 +1358,14 @@ void mlx5_eswitch_disable_sriov(struct mlx5_eswitch *esw, bool clear_vf)
 		struct devlink *devlink = priv_to_devlink(esw->dev);
 
 		esw_offloads_del_send_to_vport_meta_rules(esw);
-		devlink_rate_nodes_destroy(devlink);
+		devl_rate_nodes_destroy(devlink);
 	}
 
 	esw->esw_funcs.num_vfs = 0;
 
 unlock:
 	up_write(&esw->mode_lock);
+	devl_unlock(devlink);
 }
 
 /* Free resources for corresponding eswitch mode. It is called by devlink
@@ -1389,18 +1394,23 @@ void mlx5_eswitch_disable_locked(struct mlx5_eswitch *esw)
 	mlx5_esw_acls_ns_cleanup(esw);
 
 	if (esw->mode == MLX5_ESWITCH_OFFLOADS)
-		devlink_rate_nodes_destroy(devlink);
+		devl_rate_nodes_destroy(devlink);
 }
 
 void mlx5_eswitch_disable(struct mlx5_eswitch *esw)
 {
+	struct devlink *devlink;
+
 	if (!mlx5_esw_allowed(esw))
 		return;
 
 	mlx5_lag_disable_change(esw->dev);
+	devlink = priv_to_devlink(esw->dev);
+	devl_lock(devlink);
 	down_write(&esw->mode_lock);
 	mlx5_eswitch_disable_locked(esw);
 	up_write(&esw->mode_lock);
+	devl_unlock(devlink);
 	mlx5_lag_enable_change(esw->dev);
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 3bd843e6d66a..f1640e4cb719 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -3377,7 +3377,9 @@ int mlx5_devlink_eswitch_mode_set(struct devlink *devlink, u16 mode,
 	if (cur_mlx5_mode == mlx5_mode)
 		goto unlock;
 
+	devl_lock(devlink);
 	mlx5_eswitch_disable_locked(esw);
+	devl_unlock(devlink);
 	if (mode == DEVLINK_ESWITCH_MODE_SWITCHDEV) {
 		if (mlx5_devlink_trap_get_num_active(esw->dev)) {
 			NL_SET_ERR_MSG_MOD(extack,
-- 
2.36.1

