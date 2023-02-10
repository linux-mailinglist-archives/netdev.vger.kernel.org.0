Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90F4A692A01
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 23:19:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233983AbjBJWTP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 17:19:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233923AbjBJWTA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 17:19:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C11C67E8F8
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 14:18:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4FA84B825FF
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 22:18:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D45FBC4339C;
        Fri, 10 Feb 2023 22:18:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676067518;
        bh=VnhD5dUTF2aZEq+TdavivKRJ8hgmf7MKB7nVdDkeDNg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LwniZvNXdeoX48OIPQSv2wA7RYj+PllZGxEp9Y8mcdHxjm5hzcpZCErZpxb1dW5Lo
         BqsDLvcppXq3vEcsn43SDfUvzq6DlIqpf9KaJDePaD/V/BKAYkAuvniwQCovdwi4Fi
         GchQDx0rIbNL0+ToyF9jmJ+j8ayqhfFGxKSkrDYz+wU7iszIW/3ub0P5MTC9Twrj2k
         rFcSo+/HqeVB4ocUP2TUKW07OppV0KT48y5uMC3JlhKnynIeixPDhnYCkyVsstCSe1
         z+5igaPoQL5C1/yb87ndZ9Hj9w/KwBfUGLG8aELixYt8bMezJbvRmFJ7vbix1RB9y3
         Np2CbJv5RLV6A==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Jiri Pirko <jiri@nvidia.com>
Subject: [net-next 12/15] net/mlx5e: Move devlink port registration to be done before netdev alloc
Date:   Fri, 10 Feb 2023 14:18:18 -0800
Message-Id: <20230210221821.271571-13-saeed@kernel.org>
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

Move the devlink port registration to be done right after devlink
instance registration.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 24 +++++++++----------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 432d32f5dc65..9657c66c8f69 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -5892,12 +5892,19 @@ static int mlx5e_probe(struct auxiliary_device *adev,
 		return PTR_ERR(mlx5e_dev);
 	auxiliary_set_drvdata(adev, mlx5e_dev);
 
+	err = mlx5e_devlink_port_register(mlx5e_dev, mdev);
+	if (err) {
+		mlx5_core_err(mdev, "mlx5e_devlink_port_register failed, %d\n", err);
+		goto err_devlink_unregister;
+	}
+
 	netdev = mlx5e_create_netdev(mdev, profile);
 	if (!netdev) {
 		mlx5_core_err(mdev, "mlx5e_create_netdev failed\n");
 		err = -ENOMEM;
-		goto err_devlink_unregister;
+		goto err_devlink_port_unregister;
 	}
+	SET_NETDEV_DEVLINK_PORT(netdev, &mlx5e_dev->dl_port);
 
 	mlx5e_build_nic_netdev(netdev);
 
@@ -5910,17 +5917,10 @@ static int mlx5e_probe(struct auxiliary_device *adev,
 	priv->dfs_root = debugfs_create_dir("nic",
 					    mlx5_debugfs_get_dev_root(priv->mdev));
 
-	err = mlx5e_devlink_port_register(mlx5e_dev, mdev);
-	if (err) {
-		mlx5_core_err(mdev, "mlx5e_devlink_port_register failed, %d\n", err);
-		goto err_destroy_netdev;
-	}
-	SET_NETDEV_DEVLINK_PORT(netdev, &mlx5e_dev->dl_port);
-
 	err = profile->init(mdev, netdev);
 	if (err) {
 		mlx5_core_err(mdev, "mlx5e_nic_profile init failed, %d\n", err);
-		goto err_devlink_cleanup;
+		goto err_destroy_netdev;
 	}
 
 	err = mlx5e_resume(adev);
@@ -5944,11 +5944,11 @@ static int mlx5e_probe(struct auxiliary_device *adev,
 	mlx5e_suspend(adev, state);
 err_profile_cleanup:
 	profile->cleanup(priv);
-err_devlink_cleanup:
-	mlx5e_devlink_port_unregister(mlx5e_dev);
 err_destroy_netdev:
 	debugfs_remove_recursive(priv->dfs_root);
 	mlx5e_destroy_netdev(priv);
+err_devlink_port_unregister:
+	mlx5e_devlink_port_unregister(mlx5e_dev);
 err_devlink_unregister:
 	mlx5e_destroy_devlink(mlx5e_dev);
 	return err;
@@ -5965,9 +5965,9 @@ static void mlx5e_remove(struct auxiliary_device *adev)
 	unregister_netdev(priv->netdev);
 	mlx5e_suspend(adev, state);
 	priv->profile->cleanup(priv);
-	mlx5e_devlink_port_unregister(mlx5e_dev);
 	debugfs_remove_recursive(priv->dfs_root);
 	mlx5e_destroy_netdev(priv);
+	mlx5e_devlink_port_unregister(mlx5e_dev);
 	mlx5e_destroy_devlink(mlx5e_dev);
 }
 
-- 
2.39.1

