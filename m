Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B834A6C891E
	for <lists+netdev@lfdr.de>; Sat, 25 Mar 2023 00:14:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231384AbjCXXOb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 19:14:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232191AbjCXXOK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 19:14:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E82B81E1D6
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 16:14:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 58D81B82666
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 23:14:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 128E5C433D2;
        Fri, 24 Mar 2023 23:14:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679699640;
        bh=JWb5GQZsOCRN1HktGF1owvEf3pzBAba/VBDnahGvzwg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jH6J2hkddlcIJOrF9Ont5/BaIYPD50vfr+c/F2AaJRTuJOQkqK5XMF7pGxq/ZtZ3/
         K74Vy72y691n0SWCJ0jyNYOIYfa+gZXJKAwTqEECJIeLeS5AmJxqG9Def/mQPAGIwv
         U3lRo0U2iIMhEXy5aPcfsCydEv9W+Uqi3VG5PBC4sBZUMffyrX1hQBRlfmmPnUYzKl
         80M0t2me+O41kVD4Ogge78QCpsX9eutaPGS7zYowjyicJ9Wxu+wrh7E8NUOUcapL05
         LbqL8yvWKxXYep4eQojPtsQZiZLDgb/gvhjKn6cBXNaPRRLYNmqyhWBRVFa5nsMVQF
         CIVd4E4wttjpQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Eli Cohen <elic@nvidia.com>, Shay Drory <shayd@nvidia.com>,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: [net-next V2 11/15] net/mlx5: Move devlink registration before mlx5_load
Date:   Fri, 24 Mar 2023 16:13:37 -0700
Message-Id: <20230324231341.29808-12-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230324231341.29808-1-saeed@kernel.org>
References: <20230324231341.29808-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eli Cohen <elic@nvidia.com>

In order to allow reference to devlink parameters during driver load,
move the devlink registration before mlx5_load. Subsequent patch will
use it to control the number of completion vectors required based on
whether eth is enabled or not.

Signed-off-by: Eli Cohen <elic@nvidia.com>
Reviewed-by: Shay Drory <shayd@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/main.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index bbc9b4188212..fb9ac7da6e4c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1399,16 +1399,16 @@ int mlx5_init_one(struct mlx5_core_dev *dev)
 		goto function_teardown;
 	}
 
+	err = mlx5_devlink_params_register(priv_to_devlink(dev));
+	if (err)
+		goto err_devlink_params_reg;
+
 	err = mlx5_load(dev);
 	if (err)
 		goto err_load;
 
 	set_bit(MLX5_INTERFACE_STATE_UP, &dev->intf_state);
 
-	err = mlx5_devlink_params_register(priv_to_devlink(dev));
-	if (err)
-		goto err_devlink_params_reg;
-
 	err = mlx5_register_device(dev);
 	if (err)
 		goto err_register;
@@ -1418,11 +1418,11 @@ int mlx5_init_one(struct mlx5_core_dev *dev)
 	return 0;
 
 err_register:
-	mlx5_devlink_params_unregister(priv_to_devlink(dev));
-err_devlink_params_reg:
 	clear_bit(MLX5_INTERFACE_STATE_UP, &dev->intf_state);
 	mlx5_unload(dev);
 err_load:
+	mlx5_devlink_params_unregister(priv_to_devlink(dev));
+err_devlink_params_reg:
 	mlx5_cleanup_once(dev);
 function_teardown:
 	mlx5_function_teardown(dev, true);
@@ -1441,7 +1441,6 @@ void mlx5_uninit_one(struct mlx5_core_dev *dev)
 	mutex_lock(&dev->intf_state_mutex);
 
 	mlx5_unregister_device(dev);
-	mlx5_devlink_params_unregister(priv_to_devlink(dev));
 
 	if (!test_bit(MLX5_INTERFACE_STATE_UP, &dev->intf_state)) {
 		mlx5_core_warn(dev, "%s: interface is down, NOP\n",
@@ -1452,6 +1451,7 @@ void mlx5_uninit_one(struct mlx5_core_dev *dev)
 
 	clear_bit(MLX5_INTERFACE_STATE_UP, &dev->intf_state);
 	mlx5_unload(dev);
+	mlx5_devlink_params_unregister(priv_to_devlink(dev));
 	mlx5_cleanup_once(dev);
 	mlx5_function_teardown(dev, true);
 out:
-- 
2.39.2

