Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E46E3DF867
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 01:20:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233962AbhHCXUm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 19:20:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:38984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233548AbhHCXUd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 19:20:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A8CCF60FA0;
        Tue,  3 Aug 2021 23:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628032822;
        bh=Uja8RzoMCc9BpUyWv8o01AMrFBPiPQUqo8GWoNessjw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CtacHI6n42JUQrWq+Ln86y9afrcNi7wQxmAWtCBsoNL3rOkyGaU4eE6xvPIT1qFrt
         LPHtu9mFbOnpFRpoMfextBBoai1ZQWUZKiJn+V55MuF0yjxx3dvven72hP7SKepYSJ
         aVQGYdht3P+u9xSXfOz1xXix8NtxzD9yXQdgHSxsbspstXKlsXuVzBoJn2L763Mb7e
         AJswtI0U/GlxXm5LDWmdOjLBj6bUl1oeESm3573P7N9EsbHTqG3dszDJWwVMB1Ew0E
         MFcbGxDC0R6Pg2iQoh80Gc2y8rLIunm+3UzbRJwmRSovK6MYzTahupBBmayRzWEWgQ
         rBi92jN9uA58g==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        Mark Bloch <mbloch@nvidia.com>,
        Mark Zhang <markzhang@nvidia.com>
Subject: [PATCH mlx5-next 09/14] net/mlx5: E-Switch, Add event callback for representors
Date:   Tue,  3 Aug 2021 16:19:54 -0700
Message-Id: <20210803231959.26513-10-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210803231959.26513-1-saeed@kernel.org>
References: <20210803231959.26513-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Bloch <mbloch@nvidia.com>

This callback will allow to notify representors about relevant events
when in OFFLOADS mode. In downstream patches, this will be used to notify
about PAIR/UNPAIR devcom events.

Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Mark Zhang <markzhang@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/eswitch_offloads.c     | 50 +++++++++++++++++--
 include/linux/mlx5/eswitch.h                  |  9 ++++
 2 files changed, 56 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index dd5eadd6047b..b57a5c188832 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -2316,11 +2316,22 @@ void esw_offloads_unload_rep(struct mlx5_eswitch *esw, u16 vport_num)
 #define ESW_OFFLOADS_DEVCOM_PAIR	(0)
 #define ESW_OFFLOADS_DEVCOM_UNPAIR	(1)
 
-static int mlx5_esw_offloads_pair(struct mlx5_eswitch *esw,
-				  struct mlx5_eswitch *peer_esw)
+static void mlx5_esw_offloads_rep_event_unpair(struct mlx5_eswitch *esw)
 {
+	const struct mlx5_eswitch_rep_ops *ops;
+	struct mlx5_eswitch_rep *rep;
+	unsigned long i;
+	u8 rep_type;
 
-	return esw_add_fdb_peer_miss_rules(esw, peer_esw->dev);
+	mlx5_esw_for_each_rep(esw, i, rep) {
+		rep_type = NUM_REP_TYPES;
+		while (rep_type--) {
+			ops = esw->offloads.rep_ops[rep_type];
+			if (atomic_read(&rep->rep_data[rep_type].state) == REP_LOADED &&
+			    ops->event)
+				ops->event(esw, rep, MLX5_SWITCHDEV_EVENT_UNPAIR, NULL);
+		}
+	}
 }
 
 static void mlx5_esw_offloads_unpair(struct mlx5_eswitch *esw)
@@ -2328,9 +2339,42 @@ static void mlx5_esw_offloads_unpair(struct mlx5_eswitch *esw)
 #if IS_ENABLED(CONFIG_MLX5_CLS_ACT)
 	mlx5e_tc_clean_fdb_peer_flows(esw);
 #endif
+	mlx5_esw_offloads_rep_event_unpair(esw);
 	esw_del_fdb_peer_miss_rules(esw);
 }
 
+static int mlx5_esw_offloads_pair(struct mlx5_eswitch *esw,
+				  struct mlx5_eswitch *peer_esw)
+{
+	const struct mlx5_eswitch_rep_ops *ops;
+	struct mlx5_eswitch_rep *rep;
+	unsigned long i;
+	u8 rep_type;
+	int err;
+
+	err = esw_add_fdb_peer_miss_rules(esw, peer_esw->dev);
+	if (err)
+		return err;
+
+	mlx5_esw_for_each_rep(esw, i, rep) {
+		for (rep_type = 0; rep_type < NUM_REP_TYPES; rep_type++) {
+			ops = esw->offloads.rep_ops[rep_type];
+			if (atomic_read(&rep->rep_data[rep_type].state) == REP_LOADED &&
+			    ops->event) {
+				err = ops->event(esw, rep, MLX5_SWITCHDEV_EVENT_PAIR, peer_esw);
+				if (err)
+					goto err_out;
+			}
+		}
+	}
+
+	return 0;
+
+err_out:
+	mlx5_esw_offloads_unpair(esw);
+	return err;
+}
+
 static int mlx5_esw_offloads_set_ns_peer(struct mlx5_eswitch *esw,
 					 struct mlx5_eswitch *peer_esw,
 					 bool pair)
diff --git a/include/linux/mlx5/eswitch.h b/include/linux/mlx5/eswitch.h
index 0bfcf7b8ecf9..4ab5c1fc1270 100644
--- a/include/linux/mlx5/eswitch.h
+++ b/include/linux/mlx5/eswitch.h
@@ -29,11 +29,20 @@ enum {
 	REP_LOADED,
 };
 
+enum mlx5_switchdev_event {
+	MLX5_SWITCHDEV_EVENT_PAIR,
+	MLX5_SWITCHDEV_EVENT_UNPAIR,
+};
+
 struct mlx5_eswitch_rep;
 struct mlx5_eswitch_rep_ops {
 	int (*load)(struct mlx5_core_dev *dev, struct mlx5_eswitch_rep *rep);
 	void (*unload)(struct mlx5_eswitch_rep *rep);
 	void *(*get_proto_dev)(struct mlx5_eswitch_rep *rep);
+	int (*event)(struct mlx5_eswitch *esw,
+		     struct mlx5_eswitch_rep *rep,
+		     enum mlx5_switchdev_event event,
+		     void *data);
 };
 
 struct mlx5_eswitch_rep_data {
-- 
2.31.1

