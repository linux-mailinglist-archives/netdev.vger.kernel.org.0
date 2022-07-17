Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 696B1577860
	for <lists+netdev@lfdr.de>; Sun, 17 Jul 2022 23:36:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232757AbiGQVgY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jul 2022 17:36:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232608AbiGQVgW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jul 2022 17:36:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D789511A15
        for <netdev@vger.kernel.org>; Sun, 17 Jul 2022 14:35:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5D944B80EBA
        for <netdev@vger.kernel.org>; Sun, 17 Jul 2022 21:35:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05340C3411E;
        Sun, 17 Jul 2022 21:35:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658093755;
        bh=DVxesPckPATl7vAXJ4YxeFv3v680FxDJ2zthKZN1Rwk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VRic+suq3zi51zjol8ULcD72YCuHJLqW9kwqzH0YHV9Tafvq/jZFPJSpo2hEb+jK7
         PZq7jUHLfFxXaKJlHs9Gi4A/H/SOI3zQyLXOvN4hfJHWVVI2mWWUEKw3ypnVUol6xy
         TECxH2gClanO4FGXuYp1Hq+UJM10gHfQMiw9/T+c02JMeU26O62jkGXhD/4eonZrf/
         8vpyvQiNlzCnS6SP20FMXrJy2dXl267ncHeLC4ZpEUJj/acWcuy6/LIodz/k0gCO5d
         ch+xjsQIuatspGPR1AEjvpMgA3DYRZ/mhi498nH8isa66q7pE65um+khy11esQqc9M
         7SbQsog+vq+3g==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Roi Dayan <roid@nvidia.com>
Subject: [net-next 14/14] net/mlx5: CT: Remove warning of ignore_flow_level support for non PF
Date:   Sun, 17 Jul 2022 14:33:52 -0700
Message-Id: <20220717213352.89838-15-saeed@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220717213352.89838-1-saeed@kernel.org>
References: <20220717213352.89838-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

ignore_flow_level isn't supported for SFs, and so it causes
post_act and ct to warn about it per SF.
Apply the warning only for PF.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_act.c | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c       | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_act.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_act.c
index 2093cc2b0d48..33c1411ed8db 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_act.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_act.c
@@ -36,7 +36,7 @@ mlx5e_tc_post_act_init(struct mlx5e_priv *priv, struct mlx5_fs_chains *chains,
 	int err;
 
 	if (!MLX5_CAP_FLOWTABLE_TYPE(priv->mdev, ignore_flow_level, table_type)) {
-		if (priv->mdev->coredev_type != MLX5_COREDEV_VF)
+		if (priv->mdev->coredev_type == MLX5_COREDEV_PF)
 			mlx5_core_warn(priv->mdev, "firmware level support is missing\n");
 		err = -EOPNOTSUPP;
 		goto err_check;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index a6d84ff3a0e7..864ce0c393e6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -2062,7 +2062,7 @@ mlx5_tc_ct_init_check_support(struct mlx5e_priv *priv,
 		/* Ignore_flow_level support isn't supported by default for VFs and so post_act
 		 * won't be supported. Skip showing error msg.
 		 */
-		if (priv->mdev->coredev_type != MLX5_COREDEV_VF)
+		if (priv->mdev->coredev_type == MLX5_COREDEV_PF)
 			err_msg = "post action is missing";
 		err = -EOPNOTSUPP;
 		goto out_err;
-- 
2.36.1

