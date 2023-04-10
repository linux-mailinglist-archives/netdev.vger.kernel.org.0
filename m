Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B9446DC382
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 08:20:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbjDJGUS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 02:20:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbjDJGUN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 02:20:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C04C46B1
        for <netdev@vger.kernel.org>; Sun,  9 Apr 2023 23:19:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2783E61172
        for <netdev@vger.kernel.org>; Mon, 10 Apr 2023 06:19:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C325C433D2;
        Mon, 10 Apr 2023 06:19:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681107598;
        bh=MkUUzOHHplHN6G6IHQQSQZhJJRawjZg0zPUp2EdIo8g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LGK1oPzeh+jN7kwD5VgWXSWcinRAiAPKycMNKl7eJGyJlYhu0YOkc0JZxzruQjXqZ
         V0rGPp5VwnHZbjf6HZazMFB/bOKOUe+o+zYGRprAohqRHtuaV+YzhVCNX3GUtGbgcy
         zDO5uh7r02s4FDSWRcv7PPHaJlZDHwdiW95LH1iJ/JmZvsekWdTRILdaq75fa7XvLg
         hxsNJrutQRIYPh/Y/EvF6OWQb2lumH2jr5ajFVaqKtXSZt93h/RSSXSAyK9Cwfmirj
         Vk4gxeAKebCUHWxaigNlxs1sH/2Lj3lScVE2BHEFKZhfbBy6Tozog/QBwcO+Fq2DVx
         n+lelaJpaPXww==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Raed Salem <raeds@nvidia.com>, Emeel Hakim <ehakim@nvidia.com>
Subject: [PATCH net-next 08/10] net/mlx5: Allow blocking encap changes in eswitch
Date:   Mon, 10 Apr 2023 09:19:10 +0300
Message-Id: <c6db71dc1d2a0578206ffd934084f338c3ceb14c.1681106636.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <cover.1681106636.git.leonro@nvidia.com>
References: <cover.1681106636.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Existing eswitch encap option enables header encapsulation. Unfortunately
currently available hardware isn't able to perform double encapsulation,
which can happen once IPsec packet offload tunnel mode is used together
with encap mode set to BASIC.

So as a solution for misconfiguration, provide an option to block encap
changes, which will be used for IPsec packet offload.

Reviewed-by: Emeel Hakim <ehakim@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/eswitch.h | 14 ++++++
 .../mellanox/mlx5/core/eswitch_offloads.c     | 48 +++++++++++++++++++
 2 files changed, 62 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index 19e9a77c4633..e9d68fdf68f5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -263,6 +263,7 @@ struct mlx5_esw_offload {
 	const struct mlx5_eswitch_rep_ops *rep_ops[NUM_REP_TYPES];
 	u8 inline_mode;
 	atomic64_t num_flows;
+	u64 num_block_encap;
 	enum devlink_eswitch_encap_mode encap;
 	struct ida vport_metadata_ida;
 	unsigned int host_number; /* ECPF supports one external host */
@@ -748,6 +749,9 @@ void mlx5_eswitch_offloads_destroy_single_fdb(struct mlx5_eswitch *master_esw,
 					      struct mlx5_eswitch *slave_esw);
 int mlx5_eswitch_reload_reps(struct mlx5_eswitch *esw);
 
+bool mlx5_eswitch_block_encap(struct mlx5_core_dev *dev);
+void mlx5_eswitch_unblock_encap(struct mlx5_core_dev *dev);
+
 static inline int mlx5_eswitch_num_vfs(struct mlx5_eswitch *esw)
 {
 	if (mlx5_esw_allowed(esw))
@@ -761,6 +765,7 @@ mlx5_eswitch_get_slow_fdb(struct mlx5_eswitch *esw)
 {
 	return esw->fdb_table.offloads.slow_fdb;
 }
+
 #else  /* CONFIG_MLX5_ESWITCH */
 /* eswitch API stubs */
 static inline int  mlx5_eswitch_init(struct mlx5_core_dev *dev) { return 0; }
@@ -805,6 +810,15 @@ mlx5_eswitch_reload_reps(struct mlx5_eswitch *esw)
 {
 	return 0;
 }
+
+static inline bool mlx5_eswitch_block_encap(struct mlx5_core_dev *dev)
+{
+	return true;
+}
+
+static inline void mlx5_eswitch_unblock_encap(struct mlx5_core_dev *dev)
+{
+}
 #endif /* CONFIG_MLX5_ESWITCH */
 
 #endif /* __MLX5_ESWITCH_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 48036dfddd5e..b6e2709c1371 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -3586,6 +3586,47 @@ int mlx5_devlink_eswitch_inline_mode_get(struct devlink *devlink, u8 *mode)
 	return err;
 }
 
+bool mlx5_eswitch_block_encap(struct mlx5_core_dev *dev)
+{
+	struct devlink *devlink = priv_to_devlink(dev);
+	struct mlx5_eswitch *esw;
+
+	devl_lock(devlink);
+	esw = mlx5_devlink_eswitch_get(devlink);
+	if (IS_ERR(esw)) {
+		devl_unlock(devlink);
+		/* Failure means no eswitch => not possible to change encap */
+		return true;
+	}
+
+	down_write(&esw->mode_lock);
+	if (esw->mode != MLX5_ESWITCH_LEGACY &&
+	    esw->offloads.encap != DEVLINK_ESWITCH_ENCAP_MODE_NONE) {
+		up_write(&esw->mode_lock);
+		devl_unlock(devlink);
+		return false;
+	}
+
+	esw->offloads.num_block_encap++;
+	up_write(&esw->mode_lock);
+	devl_unlock(devlink);
+	return true;
+}
+
+void mlx5_eswitch_unblock_encap(struct mlx5_core_dev *dev)
+{
+	struct devlink *devlink = priv_to_devlink(dev);
+	struct mlx5_eswitch *esw;
+
+	esw = mlx5_devlink_eswitch_get(devlink);
+	if (IS_ERR(esw))
+		return;
+
+	down_write(&esw->mode_lock);
+	esw->offloads.num_block_encap--;
+	up_write(&esw->mode_lock);
+}
+
 int mlx5_devlink_eswitch_encap_mode_set(struct devlink *devlink,
 					enum devlink_eswitch_encap_mode encap,
 					struct netlink_ext_ack *extack)
@@ -3627,6 +3668,13 @@ int mlx5_devlink_eswitch_encap_mode_set(struct devlink *devlink,
 		goto unlock;
 	}
 
+	if (esw->offloads.num_block_encap) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Can't set encapsulation when IPsec SA and/or policies are configured");
+		err = -EOPNOTSUPP;
+		goto unlock;
+	}
+
 	esw_destroy_offloads_fdb_tables(esw);
 
 	esw->offloads.encap = encap;
-- 
2.39.2

