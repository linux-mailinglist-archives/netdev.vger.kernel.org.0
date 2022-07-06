Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8032D5695D5
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 01:25:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234472AbiGFXYl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 19:24:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234149AbiGFXYa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 19:24:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 302D72B615
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 16:24:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D63A2B81F46
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 23:24:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75D6DC3411C;
        Wed,  6 Jul 2022 23:24:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657149866;
        bh=mllzFysS/YIN/ou6nluhdNd6EcfbVvMW9WfnQ9cK17A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pduCsTDv9MY3jO1p0nWMSMAVk9BKExP+0kMDHryraZhF6MfC2VzB/b76rPQiT2Fax
         4ke0Apm3iKRDzJMMKxJVJ4/BYA46Kp64sbCZ3PC/xrg32OSK2bXmlSqUbBjnHUFbMC
         U8di9RklHiS6oZl0TBe0gkkG5Oq57Gf0XAbw7ylW5btqTticMjDo10GwoWhihD+8mK
         1WOtThszdUveXWC5RAQgwXilbkU5zW+KA9BkoluxkwEEZeHEr0cb8aERHYKnTu7hfG
         BkP8sbpbnccpvoktSCIItI2/28Y19JxjG8tu3282b2717Zbc1x7FMvOvs3mcrg3uyJ
         OT29g65Q07aVA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Moshe Shemesh <moshe@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>
Subject: [net-next 02/15] net/mlx5: Use devl_ API for rate nodes destroy
Date:   Wed,  6 Jul 2022 16:24:08 -0700
Message-Id: <20220706232421.41269-3-saeed@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220706232421.41269-1-saeed@kernel.org>
References: <20220706232421.41269-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

