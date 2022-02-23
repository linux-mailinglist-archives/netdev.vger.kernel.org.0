Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AFD94C2016
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 00:41:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244971AbiBWXk1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 18:40:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244871AbiBWXkP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 18:40:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D28A95B3DE;
        Wed, 23 Feb 2022 15:39:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 87C19B8226A;
        Wed, 23 Feb 2022 23:39:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABC68C340F3;
        Wed, 23 Feb 2022 23:39:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645659583;
        bh=0sJdf1guIu5C6xHMv6OY6rPXkkGBe1Sm+NfTNhiJ62g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M67YOU0sVL0nsGaZt3FSepgW3rDKs/7Hb3z1KTdk5uNEpk9zBNsrmTICUGap+ptHU
         hRdq1XAA1WeG5TGUCGyj/IKwuvnz+COQZXSpV+vgv7/aCHnIfEyA1WJ0oIxcNHMLjI
         zG3WI27A8oboLidtSBrHSPJgxaCqKQnLIE7U6aoP5oHTKWpHLDEM+Nn0twQSaA6EDr
         WD+873a5MM0yV5yoRDPCjX/ahezsMgs1xRt9XMiPm8T9W/QN3I+HV7Xc8EEn/Ws++i
         2fCP2U6ce62F8I/NHvKTOitLd8Mgo4uItOlwT88mwJzvIbNbH1QOicWTe6sweKMN5j
         G97o7DRMUPbYQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [for-next v2 09/17] net/mlx5: Lag, offload active-backup drops to hardware
Date:   Wed, 23 Feb 2022 15:39:22 -0800
Message-Id: <20220223233930.319301-10-saeed@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220223233930.319301-1-saeed@kernel.org>
References: <20220223233930.319301-1-saeed@kernel.org>
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

