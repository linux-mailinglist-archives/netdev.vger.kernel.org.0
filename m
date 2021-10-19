Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5701F432C2F
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 05:21:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232249AbhJSDXO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 23:23:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:48660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231479AbhJSDXE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 23:23:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0A9F961360;
        Tue, 19 Oct 2021 03:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634613652;
        bh=RzoIWGf4EWtjKboUlVD5IZb/UI2vRE7N30uCV0JEOjQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qJ/maXJXd8z/rBPvcFGpcRakL5cGIoQ/sczsW8MK2rrRJrKaJH596Rz4aM2PgaNWR
         2+m7wHHjpRAMfMXrcWo/bQkAZjgFJ+7fZsGysUSwx2kxjR6FlO6jPkD1UinCfG7ZUw
         qZjnkxiLRvGgJNe8egVRV6WSDWNfoYV3++xIrl2b+Fi5Jn/DRCLwszvvwsrHKCmR6L
         w6Jo00fWBnBHyi6q0DUHWvUgM7cvJ9aNU+xg5aXPekWQnoRKzLJ6emDQbG9+L2vhBP
         cRMiJ1ThkUn2tox6KIZLjs8BuYvCVKD5oDL+jIuLAgcEOaBXkuFUHjrv7eEYeH+CBb
         vhIU3hXAeo0fA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Maor Gottlieb <maorg@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 06/13] net/mlx5: Lag, set LAG traffic type mapping
Date:   Mon, 18 Oct 2021 20:20:40 -0700
Message-Id: <20211019032047.55660-7-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211019032047.55660-1-saeed@kernel.org>
References: <20211019032047.55660-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maor Gottlieb <maorg@nvidia.com>

Generate a traffic type bitmap that will define which
steering objects we need to create for the steering
based LAG.

Bits in this bitmap are set according to the LAG hash type.
In addition, have a field that indicate if the lag is in encap
mode or not.

Signed-off-by: Maor Gottlieb <maorg@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/lag/lag.h |  2 +
 .../mellanox/mlx5/core/lag/port_sel.c         | 37 +++++++++++++++++++
 .../mellanox/mlx5/core/lag/port_sel.h         | 14 +++++++
 3 files changed, 53 insertions(+)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/lag/port_sel.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/lag/port_sel.h

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h
index c268663c89b4..670061e60d89 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h
@@ -6,6 +6,7 @@
 
 #include "mlx5_core.h"
 #include "mp.h"
+#include "port_sel.h"
 
 enum {
 	MLX5_LAG_P1,
@@ -49,6 +50,7 @@ struct mlx5_lag {
 	struct delayed_work       bond_work;
 	struct notifier_block     nb;
 	struct lag_mp             lag_mp;
+	struct mlx5_lag_port_sel  port_sel;
 };
 
 static inline struct mlx5_lag *
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/port_sel.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/port_sel.c
new file mode 100644
index 000000000000..7b4ad49c8438
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/port_sel.c
@@ -0,0 +1,37 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/* Copyright (c) 2021, NVIDIA CORPORATION & AFFILIATES. */
+
+#include <linux/netdevice.h>
+#include "lag.h"
+
+static void set_tt_map(struct mlx5_lag_port_sel *port_sel,
+		       enum netdev_lag_hash hash)
+{
+	port_sel->tunnel = false;
+
+	switch (hash) {
+	case NETDEV_LAG_HASH_E34:
+		port_sel->tunnel = true;
+		fallthrough;
+	case NETDEV_LAG_HASH_L34:
+		set_bit(MLX5_TT_IPV4_TCP, port_sel->tt_map);
+		set_bit(MLX5_TT_IPV4_UDP, port_sel->tt_map);
+		set_bit(MLX5_TT_IPV6_TCP, port_sel->tt_map);
+		set_bit(MLX5_TT_IPV6_UDP, port_sel->tt_map);
+		set_bit(MLX5_TT_IPV4, port_sel->tt_map);
+		set_bit(MLX5_TT_IPV6, port_sel->tt_map);
+		set_bit(MLX5_TT_ANY, port_sel->tt_map);
+		break;
+	case NETDEV_LAG_HASH_E23:
+		port_sel->tunnel = true;
+		fallthrough;
+	case NETDEV_LAG_HASH_L23:
+		set_bit(MLX5_TT_IPV4, port_sel->tt_map);
+		set_bit(MLX5_TT_IPV6, port_sel->tt_map);
+		set_bit(MLX5_TT_ANY, port_sel->tt_map);
+		break;
+	default:
+		set_bit(MLX5_TT_ANY, port_sel->tt_map);
+		break;
+	}
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/port_sel.h b/drivers/net/ethernet/mellanox/mlx5/core/lag/port_sel.h
new file mode 100644
index 000000000000..c55736d2484d
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/port_sel.h
@@ -0,0 +1,14 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/* Copyright (c) 2021, NVIDIA CORPORATION & AFFILIATES. */
+
+#ifndef __MLX5_LAG_FS_H__
+#define __MLX5_LAG_FS_H__
+
+#include "lib/fs_ttc.h"
+
+struct mlx5_lag_port_sel {
+	DECLARE_BITMAP(tt_map, MLX5_NUM_TT);
+	bool   tunnel;
+};
+
+#endif /* __MLX5_LAG_FS_H__ */
-- 
2.31.1

