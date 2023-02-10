Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 192E5692A00
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 23:19:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233940AbjBJWTN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 17:19:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233914AbjBJWS7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 17:18:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43603812BA
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 14:18:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D6FE3B825FE
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 22:18:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E242C433D2;
        Fri, 10 Feb 2023 22:18:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676067519;
        bh=As/AJTIB+tlUmn/1fWYJ0NEnsml7+kyoo0bZS6o25Mw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iDhwgyHc1QSrh+QX9mw9o2akvzyCwlXzQ/BgyIJQPzAXPtBE8R52mNsrlBKBHgOIV
         o7gQNDPBt/fqyF7Ld61QZpqoCFkcEquARKiwQYg2J/bn9TzUqBc5vDLYG/dow7nkLt
         O8iC1/h683txnHoPiM21MleloVy51bQ2fMtG09qzqAwv6JLGK8F/Mpyeh7cJI/SGis
         8DeWqA9M3oFJcfpuSN5iBBD+0R0KRQ577QzjD33344BrDkJS+L9zcWHMGZb9fghDu3
         tPMh8pH+nBBQjG8+GDZwSo9VYfyp0XF9tBsOBomLWX6CFtzEwV8R2ytaaQDUONTx0S
         mA9F+jCHtqanQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>
Subject: [net-next 13/15] net/mlx5e: Create auxdev devlink instance in the same ns as parent devlink
Date:   Fri, 10 Feb 2023 14:18:19 -0800
Message-Id: <20230210221821.271571-14-saeed@kernel.org>
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

From: Jiri Pirko <jiri@nvidia.com>

Commit cited in "fixes" tag moved the devlink port under separate
devlink entity created for auxiliary device. Respect the network
namespace of parent devlink entity and allocate the devlink there.

Fixes: ee75f1fc44dd ("net/mlx5e: Create separate devlink instance for ethernet auxiliary device")
Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/devlink.c | 6 ++++--
 drivers/net/ethernet/mellanox/mlx5/core/en/devlink.h | 3 ++-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c    | 2 +-
 3 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.c
index 724de9e06c54..c6b6e290fd79 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.c
@@ -7,12 +7,14 @@
 static const struct devlink_ops mlx5e_devlink_ops = {
 };
 
-struct mlx5e_dev *mlx5e_create_devlink(struct device *dev)
+struct mlx5e_dev *mlx5e_create_devlink(struct device *dev,
+				       struct mlx5_core_dev *mdev)
 {
 	struct mlx5e_dev *mlx5e_dev;
 	struct devlink *devlink;
 
-	devlink = devlink_alloc(&mlx5e_devlink_ops, sizeof(*mlx5e_dev), dev);
+	devlink = devlink_alloc_ns(&mlx5e_devlink_ops, sizeof(*mlx5e_dev),
+				   devlink_net(priv_to_devlink(mdev)), dev);
 	if (!devlink)
 		return ERR_PTR(-ENOMEM);
 	devlink_register(devlink);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.h b/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.h
index c31d1d97b8c7..d5ec4461f300 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.h
@@ -7,7 +7,8 @@
 #include <net/devlink.h>
 #include "en.h"
 
-struct mlx5e_dev *mlx5e_create_devlink(struct device *dev);
+struct mlx5e_dev *mlx5e_create_devlink(struct device *dev,
+				       struct mlx5_core_dev *mdev);
 void mlx5e_destroy_devlink(struct mlx5e_dev *mlx5e_dev);
 int mlx5e_devlink_port_register(struct mlx5e_dev *mlx5e_dev,
 				struct mlx5_core_dev *mdev);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 9657c66c8f69..28120c4a9746 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -5887,7 +5887,7 @@ static int mlx5e_probe(struct auxiliary_device *adev,
 	struct mlx5e_priv *priv;
 	int err;
 
-	mlx5e_dev = mlx5e_create_devlink(&adev->dev);
+	mlx5e_dev = mlx5e_create_devlink(&adev->dev, mdev);
 	if (IS_ERR(mlx5e_dev))
 		return PTR_ERR(mlx5e_dev);
 	auxiliary_set_drvdata(adev, mlx5e_dev);
-- 
2.39.1

