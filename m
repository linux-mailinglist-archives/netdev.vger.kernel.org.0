Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2EEC4C0B86
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 06:10:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238132AbiBWFK5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 00:10:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238053AbiBWFKt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 00:10:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 739B86662B;
        Tue, 22 Feb 2022 21:10:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F1740B81E81;
        Wed, 23 Feb 2022 05:10:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29A0CC340F1;
        Wed, 23 Feb 2022 05:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645593015;
        bh=0sJdf1guIu5C6xHMv6OY6rPXkkGBe1Sm+NfTNhiJ62g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RiWasSZt0fzGZYmhAAWxFWlAboBHKWuxnfiL0h+iYWMcP08uKijHG98PcYtE+5LNW
         PCNj2U1jdkJ/ug+2jnDC9Bt3+Jbb1w1cEyXF3gNmlboK1/OkseYyrt4xzezy+yyPFL
         YPlIaaXwdpbJ6tjHJhqhXWNv1yr0xdOvWG1VGc+Ia5LUas14DI5BB3SXbzj1zIwKQT
         T/v3rAskFX67b4BfRtnF+u9/KwsDuqccP7BKvnVHsqrIcvHPioEM5faxB2ig4va+Wu
         JVMrKZVHdavyCLTiitN3dbyJLrMu7f1wdHCBj3EMlC3nPVqFQ6zjbdxa2nSaDlZznJ
         FySIQRqLICBPQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [mlx5-next 09/17] net/mlx5: Lag, offload active-backup drops to hardware
Date:   Tue, 22 Feb 2022 21:09:24 -0800
Message-Id: <20220223050932.244668-10-saeed@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220223050932.244668-1-saeed@kernel.org>
References: <20220223050932.244668-1-saeed@kernel.org>
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

From: Mark Bloch <mbloch@nvidia.com>

In active-backup mode the backup interface's packets are dropped by the
bond device. In switchdev where TC rules are offloaded to the FDB
this can lead to packets being hit in the FDB where without offload
they would have been dropped before reaching TC rules in the kernel.

Create a drop rule to make sure packets on inactive ports are dropped
before reaching the FDB.

Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Maor Gottlieb <maorg@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/lag/lag.c | 75 ++++++++++++++++++-
 .../net/ethernet/mellanox/mlx5/core/lag/lag.h |  1 +
 2 files changed, 73 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
index 125ac4befd74..6cad3b72c133 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
@@ -38,6 +38,7 @@
 #include "lib/devcom.h"
 #include "mlx5_core.h"
 #include "eswitch.h"
+#include "esw/acl/ofld.h"
 #include "lag.h"
 #include "mp.h"
 
@@ -210,6 +211,62 @@ static void mlx5_infer_tx_affinity_mapping(struct lag_tracker *tracker,
 		*port1 = MLX5_LAG_EGRESS_PORT_2;
 }
 
+static bool mlx5_lag_has_drop_rule(struct mlx5_lag *ldev)
+{
+	return ldev->pf[MLX5_LAG_P1].has_drop || ldev->pf[MLX5_LAG_P2].has_drop;
+}
+
+static void mlx5_lag_drop_rule_cleanup(struct mlx5_lag *ldev)
+{
+	int i;
+
+	for (i = 0; i < MLX5_MAX_PORTS; i++) {
+		if (!ldev->pf[i].has_drop)
+			continue;
+
+		mlx5_esw_acl_ingress_vport_drop_rule_destroy(ldev->pf[i].dev->priv.eswitch,
+							     MLX5_VPORT_UPLINK);
+		ldev->pf[i].has_drop = false;
+	}
+}
+
+static void mlx5_lag_drop_rule_setup(struct mlx5_lag *ldev,
+				     struct lag_tracker *tracker)
+{
+	struct mlx5_core_dev *dev0 = ldev->pf[MLX5_LAG_P1].dev;
+	struct mlx5_core_dev *dev1 = ldev->pf[MLX5_LAG_P2].dev;
+	struct mlx5_core_dev *inactive;
+	u8 v2p_port1, v2p_port2;
+	int inactive_idx;
+	int err;
+
+	/* First delete the current drop rule so there won't be any dropped
+	 * packets
+	 */
+	mlx5_lag_drop_rule_cleanup(ldev);
+
+	if (!ldev->tracker.has_inactive)
+		return;
+
+	mlx5_infer_tx_affinity_mapping(tracker, &v2p_port1, &v2p_port2);
+
+	if (v2p_port1 == MLX5_LAG_EGRESS_PORT_1) {
+		inactive = dev1;
+		inactive_idx = MLX5_LAG_P2;
+	} else {
+		inactive = dev0;
+		inactive_idx = MLX5_LAG_P1;
+	}
+
+	err = mlx5_esw_acl_ingress_vport_drop_rule_create(inactive->priv.eswitch,
+							  MLX5_VPORT_UPLINK);
+	if (!err)
+		ldev->pf[inactive_idx].has_drop = true;
+	else
+		mlx5_core_err(inactive,
+			      "Failed to create lag drop rule, error: %d", err);
+}
+
 static int _mlx5_modify_lag(struct mlx5_lag *ldev, u8 v2p_port1, u8 v2p_port2)
 {
 	struct mlx5_core_dev *dev0 = ldev->pf[MLX5_LAG_P1].dev;
@@ -244,6 +301,10 @@ void mlx5_modify_lag(struct mlx5_lag *ldev,
 			       ldev->v2p_map[MLX5_LAG_P1],
 			       ldev->v2p_map[MLX5_LAG_P2]);
 	}
+
+	if (tracker->tx_type == NETDEV_LAG_TX_TYPE_ACTIVEBACKUP &&
+	    !(ldev->flags & MLX5_LAG_FLAG_ROCE))
+		mlx5_lag_drop_rule_setup(ldev, tracker);
 }
 
 static void mlx5_lag_set_port_sel_mode(struct mlx5_lag *ldev,
@@ -345,6 +406,10 @@ int mlx5_activate_lag(struct mlx5_lag *ldev,
 		return err;
 	}
 
+	if (tracker->tx_type == NETDEV_LAG_TX_TYPE_ACTIVEBACKUP &&
+	    !roce_lag)
+		mlx5_lag_drop_rule_setup(ldev, tracker);
+
 	ldev->flags |= flags;
 	ldev->shared_fdb = shared_fdb;
 	return 0;
@@ -379,11 +444,15 @@ static int mlx5_deactivate_lag(struct mlx5_lag *ldev)
 				      "Failed to deactivate VF LAG; driver restart required\n"
 				      "Make sure all VFs are unbound prior to VF LAG activation or deactivation\n");
 		}
-	} else if (flags & MLX5_LAG_FLAG_HASH_BASED) {
-		mlx5_lag_port_sel_destroy(ldev);
+		return err;
 	}
 
-	return err;
+	if (flags & MLX5_LAG_FLAG_HASH_BASED)
+		mlx5_lag_port_sel_destroy(ldev);
+	if (mlx5_lag_has_drop_rule(ldev))
+		mlx5_lag_drop_rule_cleanup(ldev);
+
+	return 0;
 }
 
 static bool mlx5_lag_check_prereq(struct mlx5_lag *ldev)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h
index 305d9adbe325..cbf9a9003e55 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h
@@ -28,6 +28,7 @@ enum {
 struct lag_func {
 	struct mlx5_core_dev *dev;
 	struct net_device    *netdev;
+	bool has_drop;
 };
 
 /* Used for collection of netdev event info. */
-- 
2.35.1

