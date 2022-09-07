Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FB045B1082
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 01:37:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230144AbiIGXh3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 19:37:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230118AbiIGXhU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 19:37:20 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49823C2FA9;
        Wed,  7 Sep 2022 16:37:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 13F49CE1E23;
        Wed,  7 Sep 2022 23:37:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CA39C433C1;
        Wed,  7 Sep 2022 23:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662593833;
        bh=GnttO8lDMtvds9kLkCUofgLdZbaSq8StvDSfb9gq7ko=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Iks8IuPLDS5pG+14fMZgbwEOEKPuJHR8rFZr44g0SXIlmAde9pGCHB8FuvRt41OmM
         OiU4yJE7cHAr3q9NGDxAiXfgoIFDIAJc4dKJ6YjsbP0i2SaBi1UvP8clhVKKud33Ln
         un8s3RRV3GszA1wOoa/xmUGnkZJOo8dcLzjwKTOC6WiNJ8Rwlm+aM/9kFmYB6SPZ8t
         bEOKBf4EkA1kzd0lSuxhDsOPmWiUupB9LiMVvHTQOJTfBIBHYkrZyuLAO36qJ6tluX
         yD6XsAJNssvooARtn0Q5mFv3HGKwVyZVT5J2iYTXtS8RqmRC867oGIAJ+fqK9ko4Nu
         ih2yyNNFBxnig==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>, linux-rdma@vger.kernel.org,
        "Liu, Changcheng" <jerrliu@nvidia.com>, Liu@vger.kernel.org,
        Mark Bloch <mbloch@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH mlx5-next 04/14] RDMA/mlx5: Don't set tx affinity when lag is in hash mode
Date:   Wed,  7 Sep 2022 16:36:26 -0700
Message-Id: <20220907233636.388475-5-saeed@kernel.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220907233636.388475-1-saeed@kernel.org>
References: <20220907233636.388475-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Liu, Changcheng" <jerrliu@nvidia.com>

In hash mode, without setting tx affinity explicitly, the port select
flow table decides which port is used for the traffic.
If port_select_flow_table_bypass capability is supported and tx affinity
is set explicitly for QP/TIS, they will be added into the explicit affinity
table in FW to check which port is used for the traffic.
1. The overloaded explicit affinity table may affect performance.
   To avoid this, do not set tx affinity explicitly by default.
2. The packets of the same flow need to be transmitted on the same port.
   Because the packets of the same flow use different QPs in slow & fast
   path, it shouldn't set tx affinity explicitly for these QPs.

Signed-off-by: Liu, Changcheng <jerrliu@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/infiniband/hw/mlx5/mlx5_ib.h             | 12 ++++++++++++
 .../net/ethernet/mellanox/mlx5/core/lag/lag.c    | 16 ++++++++++++++++
 include/linux/mlx5/driver.h                      |  1 +
 3 files changed, 29 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 2e2ad3918385..c3e014283c41 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -1540,6 +1540,18 @@ int mlx5_ib_test_wc(struct mlx5_ib_dev *dev);
 
 static inline bool mlx5_ib_lag_should_assign_affinity(struct mlx5_ib_dev *dev)
 {
+	/*
+	 * If the driver is in hash mode and the port_select_flow_table_bypass cap
+	 * is supported, it means that the driver no longer needs to assign the port
+	 * affinity by default. If a user wants to set the port affinity explicitly,
+	 * the user has a dedicated API to do that, so there is no need to assign
+	 * the port affinity by default.
+	 */
+	if (dev->lag_active &&
+	    mlx5_lag_mode_is_hash(dev->mdev) &&
+	    MLX5_CAP_PORT_SELECTION(dev->mdev, port_select_flow_table_bypass))
+		return 0;
+
 	return dev->lag_active ||
 		(MLX5_CAP_GEN(dev->mdev, num_lag_ports) > 1 &&
 		 MLX5_CAP_GEN(dev->mdev, lag_tx_port_affinity));
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
index 0f34e3c80d1f..26c7f72403eb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
@@ -1271,6 +1271,22 @@ bool mlx5_lag_is_active(struct mlx5_core_dev *dev)
 }
 EXPORT_SYMBOL(mlx5_lag_is_active);
 
+bool mlx5_lag_mode_is_hash(struct mlx5_core_dev *dev)
+{
+	struct mlx5_lag *ldev;
+	unsigned long flags;
+	bool res = 0;
+
+	spin_lock_irqsave(&lag_lock, flags);
+	ldev = mlx5_lag_dev(dev);
+	if (ldev)
+		res = test_bit(MLX5_LAG_MODE_FLAG_HASH_BASED, &ldev->mode_flags);
+	spin_unlock_irqrestore(&lag_lock, flags);
+
+	return res;
+}
+EXPORT_SYMBOL(mlx5_lag_mode_is_hash);
+
 bool mlx5_lag_is_master(struct mlx5_core_dev *dev)
 {
 	struct mlx5_lag *ldev;
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index a3f39f6e189e..829a2ceafdec 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -1154,6 +1154,7 @@ int mlx5_cmd_destroy_vport_lag(struct mlx5_core_dev *dev);
 bool mlx5_lag_is_roce(struct mlx5_core_dev *dev);
 bool mlx5_lag_is_sriov(struct mlx5_core_dev *dev);
 bool mlx5_lag_is_active(struct mlx5_core_dev *dev);
+bool mlx5_lag_mode_is_hash(struct mlx5_core_dev *dev);
 bool mlx5_lag_is_master(struct mlx5_core_dev *dev);
 bool mlx5_lag_is_shared_fdb(struct mlx5_core_dev *dev);
 struct net_device *mlx5_lag_get_roce_netdev(struct mlx5_core_dev *dev);
-- 
2.37.2

