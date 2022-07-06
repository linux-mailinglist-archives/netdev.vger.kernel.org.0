Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9845A5695AB
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 01:13:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234358AbiGFXNe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 19:13:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233962AbiGFXN1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 19:13:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E9B4D8B
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 16:13:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0A079B81F40
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 23:13:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 952DDC341C6;
        Wed,  6 Jul 2022 23:13:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657149203;
        bh=tXSa6vq8qsXNARMUdbac55bBT2gftgrziEOGPYJxhlE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c2L4oDiXAYrWm01kkg/et6oScCg3XpaOalAX76M7DuUTpEg+Ira1JD2qhyn+i9HN1
         ZGBglcjpW4wNo7FIaIqXSqS85e8RTNysQn2BOfFkrw3PyL6+n45eHlLne8zbf9rbkO
         AYn0Qer11jwBrBX7nlCwL0z3Uy+0aU2BYVBJOwmmkpYwGmt//QsN3yhTy6osNLC9MK
         v94OI0iz+BsgEXEH3yIlkr25+Eq5wdPq2BDR6QulVMgR5Jk585McSBwVOP04IWBIJW
         CDwkPz3PUYLzGaKtr64QAiGMZ8JywaCLg9LiSyPMXkn4rlyXQ4T3+X6uslxjoY3KaY
         OOa0kGLpMShOg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        "Liu, Changcheng" <jerrliu@nvidia.com>, Liu@vger.kernel.org,
        Eli Cohen <elic@nvidia.com>, Mark Bloch <mbloch@nvidia.com>
Subject: [net 6/9] net/mlx5: Lag, correct get the port select mode str
Date:   Wed,  6 Jul 2022 16:13:06 -0700
Message-Id: <20220706231309.38579-7-saeed@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220706231309.38579-1-saeed@kernel.org>
References: <20220706231309.38579-1-saeed@kernel.org>
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

From: "Liu, Changcheng" <jerrliu@nvidia.com>

mode & mode_flags is updated at the end of mlx5_activate_lag which
may not reflect the actual mode as shown in below logic:
    mlx5_activate_lag(struct mlx5_lag *ldev,
    |-- unsigned long flags = 0;
    |-- err = mlx5_lag_set_flags(ldev, mode, tracker, shared_fdb, &flags);
    |-- err = mlx5_create_lag(ldev, tracker, mode, flags);
              |-- mlx5_get_str_port_sel_mode(ldev);
    |-- ldev->mode = mode;
    |-- ldev->mode_flags = flags;
Use mode & flag as parameters to get port select mode info.

Fixes: 94db33177819 ("net/mlx5: Support multiport eswitch mode")
Signed-off-by: Liu, Changcheng <jerrliu@nvidia.com>
Reviewed-by: Eli Cohen <elic@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/lag/debugfs.c | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c     | 6 +++---
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h     | 2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/debugfs.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/debugfs.c
index f1ad233ec990..b8feaf0f5c4c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/debugfs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/debugfs.c
@@ -44,7 +44,7 @@ static int port_sel_mode_show(struct seq_file *file, void *priv)
 	ldev = dev->priv.lag;
 	mutex_lock(&ldev->lock);
 	if (__mlx5_lag_is_active(ldev))
-		mode = mlx5_get_str_port_sel_mode(ldev);
+		mode = mlx5_get_str_port_sel_mode(ldev->mode, ldev->mode_flags);
 	else
 		ret = -EINVAL;
 	mutex_unlock(&ldev->lock);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
index a9b65dc47a5b..5d41e19378e0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
@@ -487,9 +487,9 @@ static int mlx5_lag_set_flags(struct mlx5_lag *ldev, enum mlx5_lag_mode mode,
 	return 0;
 }
 
-char *mlx5_get_str_port_sel_mode(struct mlx5_lag *ldev)
+char *mlx5_get_str_port_sel_mode(enum mlx5_lag_mode mode, unsigned long flags)
 {
-	int port_sel_mode = get_port_sel_mode(ldev->mode, ldev->mode_flags);
+	int port_sel_mode = get_port_sel_mode(mode, flags);
 
 	switch (port_sel_mode) {
 	case MLX5_LAG_PORT_SELECT_MODE_QUEUE_AFFINITY: return "queue_affinity";
@@ -513,7 +513,7 @@ static int mlx5_create_lag(struct mlx5_lag *ldev,
 	if (tracker)
 		mlx5_lag_print_mapping(dev0, ldev, tracker, flags);
 	mlx5_core_info(dev0, "shared_fdb:%d mode:%s\n",
-		       shared_fdb, mlx5_get_str_port_sel_mode(ldev));
+		       shared_fdb, mlx5_get_str_port_sel_mode(mode, flags));
 
 	err = mlx5_cmd_create_lag(dev0, ldev->v2p_map, mode, flags);
 	if (err) {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h
index 71d2bb969544..ce2ce8ccbd70 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h
@@ -115,7 +115,7 @@ bool mlx5_shared_fdb_supported(struct mlx5_lag *ldev);
 void mlx5_lag_del_mpesw_rule(struct mlx5_core_dev *dev);
 int mlx5_lag_add_mpesw_rule(struct mlx5_core_dev *dev);
 
-char *mlx5_get_str_port_sel_mode(struct mlx5_lag *ldev);
+char *mlx5_get_str_port_sel_mode(enum mlx5_lag_mode mode, unsigned long flags);
 void mlx5_infer_tx_enabled(struct lag_tracker *tracker, u8 num_ports,
 			   u8 *ports, int *num_enabled);
 
-- 
2.36.1

