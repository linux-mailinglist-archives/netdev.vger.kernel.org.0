Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01AEB2D1BA3
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 22:08:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727455AbgLGVHv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 16:07:51 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:45838 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727073AbgLGVHt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 16:07:49 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from borisp@mellanox.com)
        with SMTP; 7 Dec 2020 23:06:53 +0200
Received: from gen-l-vrt-133.mtl.labs.mlnx. (gen-l-vrt-133.mtl.labs.mlnx [10.237.11.160])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 0B7L6qIJ029788;
        Mon, 7 Dec 2020 23:06:53 +0200
From:   Boris Pismenny <borisp@mellanox.com>
To:     kuba@kernel.org, davem@davemloft.net, saeedm@nvidia.com,
        hch@lst.de, sagi@grimberg.me, axboe@fb.com, kbusch@kernel.org,
        viro@zeniv.linux.org.uk, edumazet@google.com
Cc:     boris.pismenny@gmail.com, linux-nvme@lists.infradead.org,
        netdev@vger.kernel.org, benishay@nvidia.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, Ben Ben-Ishay <benishay@mellanox.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Yoray Zack <yorayz@mellanox.com>
Subject: [PATCH v1 net-next 11/15] net/mlx5e: TCP flow steering for nvme-tcp
Date:   Mon,  7 Dec 2020 23:06:45 +0200
Message-Id: <20201207210649.19194-12-borisp@mellanox.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201207210649.19194-1-borisp@mellanox.com>
References: <20201207210649.19194-1-borisp@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Both nvme-tcp and tls require tcp flow steering. Compile it for both of
them. Additionally, use reference counting to allocate/free TCP flow
steering.

Signed-off-by: Boris Pismenny <borisp@mellanox.com>
Signed-off-by: Ben Ben-Ishay <benishay@mellanox.com>
Signed-off-by: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: Yoray Zack <yorayz@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/fs.h        |  4 ++--
 .../net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c  | 10 ++++++++++
 .../net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.h  |  2 +-
 3 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
index a16297e7e2ac..a7fe3a6358ea 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
@@ -137,7 +137,7 @@ enum {
 	MLX5E_L2_FT_LEVEL,
 	MLX5E_TTC_FT_LEVEL,
 	MLX5E_INNER_TTC_FT_LEVEL,
-#ifdef CONFIG_MLX5_EN_TLS
+#if defined(CONFIG_MLX5_EN_TLS) || defined(CONFIG_MLX5_EN_NVMEOTCP)
 	MLX5E_ACCEL_FS_TCP_FT_LEVEL,
 #endif
 #ifdef CONFIG_MLX5_EN_ARFS
@@ -256,7 +256,7 @@ struct mlx5e_flow_steering {
 #ifdef CONFIG_MLX5_EN_ARFS
 	struct mlx5e_arfs_tables        arfs;
 #endif
-#ifdef CONFIG_MLX5_EN_TLS
+#if defined(CONFIG_MLX5_EN_TLS) || defined(CONFIG_MLX5_EN_NVMEOTCP)
 	struct mlx5e_accel_fs_tcp      *accel_tcp;
 #endif
 };
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c
index 97f1594cee11..feded6c8cca1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c
@@ -14,6 +14,7 @@ enum accel_fs_tcp_type {
 struct mlx5e_accel_fs_tcp {
 	struct mlx5e_flow_table tables[ACCEL_FS_TCP_NUM_TYPES];
 	struct mlx5_flow_handle *default_rules[ACCEL_FS_TCP_NUM_TYPES];
+	refcount_t		ref_count;
 };
 
 static enum mlx5e_traffic_types fs_accel2tt(enum accel_fs_tcp_type i)
@@ -335,6 +336,7 @@ static int accel_fs_tcp_enable(struct mlx5e_priv *priv)
 			return err;
 		}
 	}
+	refcount_set(&priv->fs.accel_tcp->ref_count, 1);
 	return 0;
 }
 
@@ -358,6 +360,9 @@ void mlx5e_accel_fs_tcp_destroy(struct mlx5e_priv *priv)
 	if (!priv->fs.accel_tcp)
 		return;
 
+	if (!refcount_dec_and_test(&priv->fs.accel_tcp->ref_count))
+		return;
+
 	accel_fs_tcp_disable(priv);
 
 	for (i = 0; i < ACCEL_FS_TCP_NUM_TYPES; i++)
@@ -374,6 +379,11 @@ int mlx5e_accel_fs_tcp_create(struct mlx5e_priv *priv)
 	if (!MLX5_CAP_FLOWTABLE_NIC_RX(priv->mdev, ft_field_support.outer_ip_version))
 		return -EOPNOTSUPP;
 
+	if (priv->fs.accel_tcp) {
+		refcount_inc(&priv->fs.accel_tcp->ref_count);
+		return 0;
+	}
+
 	priv->fs.accel_tcp = kzalloc(sizeof(*priv->fs.accel_tcp), GFP_KERNEL);
 	if (!priv->fs.accel_tcp)
 		return -ENOMEM;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.h
index 589235824543..8aff9298183c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.h
@@ -6,7 +6,7 @@
 
 #include "en.h"
 
-#ifdef CONFIG_MLX5_EN_TLS
+#if defined(CONFIG_MLX5_EN_TLS) || defined(CONFIG_MLX5_EN_NVMEOTCP)
 int mlx5e_accel_fs_tcp_create(struct mlx5e_priv *priv);
 void mlx5e_accel_fs_tcp_destroy(struct mlx5e_priv *priv);
 struct mlx5_flow_handle *mlx5e_accel_fs_add_sk(struct mlx5e_priv *priv,
-- 
2.24.1

