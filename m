Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7041833E265
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 00:53:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229865AbhCPXvh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 19:51:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:45650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229601AbhCPXvU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 19:51:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CF10764F9B;
        Tue, 16 Mar 2021 23:51:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615938680;
        bh=1JfTmMvW7iDfVkk79WTY5mLEnMsL2uled0U6gByny8U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lTcEAg+iIp8TR905sMyV8WHmnCMLh6DXLmg7l4lOBDCMQAh4LXyqq92DIo3qqLJJ8
         y8hxgwBEs6jC2k/0O3QZZDO8kmZvMcA/+JdrWa4SznyDnXmQtEZdW+EkE3Tvyv1vRu
         4UOVjtM1RDVOzD9uQyIaFzB/Cn0kF/gvFOaDJkNbnfOlCbwjR6Yqe5bpWIZEMEQDtS
         qD2DMILhGHKeC8rk/ENxi24pmVjkpJe/GgFzYL+DCVMMPTMrSkdtALfcgKARBgFvFk
         pYvrT5hJHIKFZVBLaTUUAQMTwx3EkbeRv48vJdhOSWFyIVmtn7fgY4zf8/pJDiB86J
         4Q8O+N3IHQkuw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Jiri Pirko <jiri@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 09/15] net/mlx5e: Register nic devlink port with switch id
Date:   Tue, 16 Mar 2021 16:51:06 -0700
Message-Id: <20210316235112.72626-10-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210316235112.72626-1-saeed@kernel.org>
References: <20210316235112.72626-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

We will re-use the native NIC port net device instance for the Uplink
representor. Since the netdev will be kept registered while we engage
switchdev mode also the devlink will be kept registered.
Register the nic devlink port with switch id so it will be available
when changing profiles.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en/devlink.c  | 23 ++++++++++++++++++-
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |  7 ++++++
 2 files changed, 29 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.c
index a69c62d72d16..054bc2fc0520 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.c
@@ -2,22 +2,43 @@
 /* Copyright (c) 2020, Mellanox Technologies inc.  All rights reserved. */
 
 #include "en/devlink.h"
+#include "eswitch.h"
+
+static void
+mlx5e_devlink_get_port_parent_id(struct mlx5_core_dev *dev, struct netdev_phys_item_id *ppid)
+{
+	u64 parent_id;
+
+	parent_id = mlx5_query_nic_system_image_guid(dev);
+	ppid->id_len = sizeof(parent_id);
+	memcpy(ppid->id, &parent_id, sizeof(parent_id));
+}
 
 int mlx5e_devlink_port_register(struct mlx5e_priv *priv)
 {
 	struct devlink *devlink = priv_to_devlink(priv->mdev);
 	struct devlink_port_attrs attrs = {};
+	struct netdev_phys_item_id ppid = {};
+	unsigned int dl_port_index;
 
 	if (mlx5_core_is_pf(priv->mdev)) {
 		attrs.flavour = DEVLINK_PORT_FLAVOUR_PHYSICAL;
 		attrs.phys.port_number = PCI_FUNC(priv->mdev->pdev->devfn);
+		if (MLX5_ESWITCH_MANAGER(priv->mdev)) {
+			mlx5e_devlink_get_port_parent_id(priv->mdev, &ppid);
+			memcpy(attrs.switch_id.id, ppid.id, ppid.id_len);
+			attrs.switch_id.id_len = ppid.id_len;
+		}
+		dl_port_index = mlx5_esw_vport_to_devlink_port_index(priv->mdev,
+								     MLX5_VPORT_UPLINK);
 	} else {
 		attrs.flavour = DEVLINK_PORT_FLAVOUR_VIRTUAL;
+		dl_port_index = mlx5_esw_vport_to_devlink_port_index(priv->mdev, 0);
 	}
 
 	devlink_port_attrs_set(&priv->dl_port, &attrs);
 
-	return devlink_port_register(devlink, &priv->dl_port, 1);
+	return devlink_port_register(devlink, &priv->dl_port, dl_port_index);
 }
 
 void mlx5e_devlink_port_type_eth_set(struct mlx5e_priv *priv)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index fdf5c8c05c1b..d0b907a9ef28 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -781,6 +781,13 @@ esw_add_restore_rule(struct mlx5_eswitch *esw, u32 tag)
 {
 	return ERR_PTR(-EOPNOTSUPP);
 }
+
+static inline unsigned int
+mlx5_esw_vport_to_devlink_port_index(const struct mlx5_core_dev *dev,
+				     u16 vport_num)
+{
+	return vport_num;
+}
 #endif /* CONFIG_MLX5_ESWITCH */
 
 #endif /* __MLX5_ESWITCH_H__ */
-- 
2.30.2

