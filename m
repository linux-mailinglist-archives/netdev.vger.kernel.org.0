Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8521D69C549
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 07:17:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230173AbjBTGRt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 01:17:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230163AbjBTGRa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 01:17:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82C4210263
        for <netdev@vger.kernel.org>; Sun, 19 Feb 2023 22:17:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B558B60CBB
        for <netdev@vger.kernel.org>; Mon, 20 Feb 2023 06:17:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DBA9C433D2;
        Mon, 20 Feb 2023 06:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676873826;
        bh=9XbVX9QwLk0w890UhXCSps/QSiKS++jTh0aOMFO7mqw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MV+/WBXcDY9ZuxPA9Q72ogldCm6hZcVJQXIi3Kvju+si3933PVSvYjX7CKrYPyga1
         pe80HKJ2dEtcVcRcUx1DqrKBBtwoxnCdtFcNpJMEb8Lvgina048aeiQmZrGAdiXjoe
         2IR9lgUgU8hJzuvlgiVVgN61Z+PRZ+uv+DdNVaC5kddaUH7oeSjznu4RMwfyX9hJgS
         5nsvPpF65ZTe1TAEuehzP7Vl3oBP7xC1unM3vVrDzInriqWg4yJwwIx9FdDXiXqgcp
         bKmMxnOHVbukSMHTOaKO0XY+etQrmDPtVUckDIJzdqo8Wo40zb+/5IDmL1mJ9gZJNU
         S1qlg0xqnhcIg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Eli Cohen <elic@nvidia.com>,
        Shay Drory <shayd@nvidia.com>
Subject: [PATCH net-next 13/14] net/mlx5: Use one completion vector if eth is disabled
Date:   Sun, 19 Feb 2023 22:14:41 -0800
Message-Id: <20230220061442.403092-14-saeed@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230220061442.403092-1-saeed@kernel.org>
References: <20230220061442.403092-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eli Cohen <elic@nvidia.com>

If eth is disabled by devlink, use only a single completion vector to
have minimum performance of all users of completion vectors. This also
affects Infiniband performance.

The rest of the vectors can be used by other consumers on a first come
first served basis.

mlx5_vdpa will make use of this to allocate dedicated vectors for its
own use.

Signed-off-by: Eli Cohen <elic@nvidia.com>
Reviewed-by: Shay Drory <shayd@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/dev.c     | 14 ++------------
 drivers/net/ethernet/mellanox/mlx5/core/devlink.h | 11 +++++++++++
 drivers/net/ethernet/mellanox/mlx5/core/eq.c      |  7 +++++++
 3 files changed, 20 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/dev.c b/drivers/net/ethernet/mellanox/mlx5/core/dev.c
index 445fe30c3d0b..e7739acc926e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/dev.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/dev.c
@@ -35,6 +35,7 @@
 #include <linux/mlx5/mlx5_ifc_vdpa.h>
 #include <linux/mlx5/vport.h>
 #include "mlx5_core.h"
+#include "devlink.h"
 
 /* intf dev list mutex */
 static DEFINE_MUTEX(mlx5_intf_mutex);
@@ -109,17 +110,6 @@ bool mlx5_eth_supported(struct mlx5_core_dev *dev)
 	return true;
 }
 
-static bool is_eth_enabled(struct mlx5_core_dev *dev)
-{
-	union devlink_param_value val;
-	int err;
-
-	err = devl_param_driverinit_value_get(priv_to_devlink(dev),
-					      DEVLINK_PARAM_GENERIC_ID_ENABLE_ETH,
-					      &val);
-	return err ? false : val.vbool;
-}
-
 bool mlx5_vnet_supported(struct mlx5_core_dev *dev)
 {
 	if (!IS_ENABLED(CONFIG_MLX5_VDPA_NET))
@@ -251,7 +241,7 @@ static const struct mlx5_adev_device {
 					 .is_enabled = &is_ib_enabled },
 	[MLX5_INTERFACE_PROTOCOL_ETH] = { .suffix = "eth",
 					  .is_supported = &mlx5_eth_supported,
-					  .is_enabled = &is_eth_enabled },
+					  .is_enabled = &mlx5_core_is_eth_enabled },
 	[MLX5_INTERFACE_PROTOCOL_ETH_REP] = { .suffix = "eth-rep",
 					   .is_supported = &is_eth_rep_supported },
 	[MLX5_INTERFACE_PROTOCOL_IB_REP] = { .suffix = "rdma-rep",
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.h b/drivers/net/ethernet/mellanox/mlx5/core/devlink.h
index 212b12424146..f2601f9eef78 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.h
@@ -44,4 +44,15 @@ void mlx5_devlink_free(struct devlink *devlink);
 int mlx5_devlink_params_register(struct devlink *devlink);
 void mlx5_devlink_params_unregister(struct devlink *devlink);
 
+static inline bool mlx5_core_is_eth_enabled(struct mlx5_core_dev *dev)
+{
+	union devlink_param_value val;
+	int err;
+
+	err = devl_param_driverinit_value_get(priv_to_devlink(dev),
+					      DEVLINK_PARAM_GENERIC_ID_ENABLE_ETH,
+					      &val);
+	return err ? false : val.vbool;
+}
+
 #endif /* __MLX5_DEVLINK_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
index cfbdb822cd73..8021977813c5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
@@ -1120,6 +1120,13 @@ static int get_num_eqs(struct mlx5_core_dev *dev)
 	int max_eqs_sf;
 	int num_eqs;
 
+	/* If ethernet is disabled we use just a single completion vector to
+	 * have the other vectors available for other drivers using mlx5_core. For
+	 * example, mlx5_vdpa
+	 */
+	if (!mlx5_core_is_eth_enabled(dev) && mlx5_eth_supported(dev))
+		return 1;
+
 	max_dev_eqs = MLX5_CAP_GEN(dev, max_num_eqs) ?
 		      MLX5_CAP_GEN(dev, max_num_eqs) :
 		      1 << MLX5_CAP_GEN(dev, log_max_eq);
-- 
2.39.1

