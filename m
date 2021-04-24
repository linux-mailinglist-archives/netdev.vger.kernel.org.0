Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F277536A005
	for <lists+netdev@lfdr.de>; Sat, 24 Apr 2021 10:02:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232588AbhDXICk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Apr 2021 04:02:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:47256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229850AbhDXIB7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 24 Apr 2021 04:01:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8FFB0611AE;
        Sat, 24 Apr 2021 08:01:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619251281;
        bh=WMO9rukmXytsB95118+FhiKVMMZHTD4DIps0VSNJodE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AbxJdVoao76D+uUQFfR7xaN/3qwuGRojWsWk4R3IbRkHEHrrfv0Nk1MqmR92Ue2uw
         aTsHEKZxmV/YzvfeJeFkzLyCsK7GPX2Ug0PMmt1uyKGCR3lfmCxc3q9JJTz/df4mBl
         nIO1kizsbBLEkFMm9itNsjSQUA7Tr2kWabQiL3riplEvH9uufGol1qw47qmCyTP06d
         EUkNdNbSrJ4LPozibi30L7CS61IUldiW7N/J08MbidbWpmikcwTagWFvT1JRfRSiz+
         9RsG+y6mb7AzGn9fZJYetts1y1h8H7p06KCcxgpjGrEql1qj1Au0dimk5g9ub7Au0A
         ROFuhyCGdqLQw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Parav Pandit <parav@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Vu Pham <vuhuong@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next V2 01/11] net/mlx5: E-Switch, Return eswitch max ports when eswitch is supported
Date:   Sat, 24 Apr 2021 01:01:05 -0700
Message-Id: <20210424080115.97273-2-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210424080115.97273-1-saeed@kernel.org>
References: <20210424080115.97273-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@nvidia.com>

mlx5_eswitch_get_total_vports() doesn't honor MLX5_ESWICH Kconfig flag.

When MLX5_ESWITCH is disabled, FS layer continues to initialize eswitch
specific ACL namespaces.
Instead, start honoring MLX5_ESWITCH flag and perform vport specific
initialization only when vport count is non zero.

Signed-off-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Vu Pham <vuhuong@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c | 13 +++++++++++++
 drivers/net/ethernet/mellanox/mlx5/core/vport.c   | 14 --------------
 include/linux/mlx5/eswitch.h                      | 11 +++++++++--
 3 files changed, 22 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 1bb229ecd43b..c3a58224ae12 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -2205,3 +2205,16 @@ void mlx5_esw_unlock(struct mlx5_eswitch *esw)
 {
 	up_write(&esw->mode_lock);
 }
+
+/**
+ * mlx5_eswitch_get_total_vports - Get total vports of the eswitch
+ *
+ * @dev: Pointer to core device
+ *
+ * mlx5_eswitch_get_total_vports returns total number of eswitch vports.
+ */
+u16 mlx5_eswitch_get_total_vports(const struct mlx5_core_dev *dev)
+{
+	return MLX5_SPECIAL_VPORTS(dev) + mlx5_core_max_vfs(dev) + mlx5_sf_max_functions(dev);
+}
+EXPORT_SYMBOL_GPL(mlx5_eswitch_get_total_vports);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/vport.c b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
index e05c5c0f3ae1..457ad42eaa2a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/vport.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
@@ -1151,20 +1151,6 @@ u64 mlx5_query_nic_system_image_guid(struct mlx5_core_dev *mdev)
 }
 EXPORT_SYMBOL_GPL(mlx5_query_nic_system_image_guid);
 
-/**
- * mlx5_eswitch_get_total_vports - Get total vports of the eswitch
- *
- * @dev:	Pointer to core device
- *
- * mlx5_eswitch_get_total_vports returns total number of vports for
- * the eswitch.
- */
-u16 mlx5_eswitch_get_total_vports(const struct mlx5_core_dev *dev)
-{
-	return MLX5_SPECIAL_VPORTS(dev) + mlx5_core_max_vfs(dev) + mlx5_sf_max_functions(dev);
-}
-EXPORT_SYMBOL_GPL(mlx5_eswitch_get_total_vports);
-
 int mlx5_vport_get_other_func_cap(struct mlx5_core_dev *dev, u16 function_id, void *out)
 {
 	u16 opmod = (MLX5_CAP_GENERAL << 1) | (HCA_CAP_OPMOD_GET_MAX & 0x01);
diff --git a/include/linux/mlx5/eswitch.h b/include/linux/mlx5/eswitch.h
index 9cf1da2883c6..17109b65c1ac 100644
--- a/include/linux/mlx5/eswitch.h
+++ b/include/linux/mlx5/eswitch.h
@@ -65,8 +65,6 @@ struct mlx5_flow_handle *
 mlx5_eswitch_add_send_to_vport_rule(struct mlx5_eswitch *on_esw,
 				    struct mlx5_eswitch_rep *rep, u32 sqn);
 
-u16 mlx5_eswitch_get_total_vports(const struct mlx5_core_dev *dev);
-
 #ifdef CONFIG_MLX5_ESWITCH
 enum devlink_eswitch_encap_mode
 mlx5_eswitch_get_encap_mode(const struct mlx5_core_dev *dev);
@@ -126,6 +124,8 @@ u32 mlx5_eswitch_get_vport_metadata_for_set(struct mlx5_eswitch *esw,
 #define ESW_TUN_SLOW_TABLE_GOTO_VPORT_MARK ESW_TUN_OPTS_MASK
 
 u8 mlx5_eswitch_mode(struct mlx5_core_dev *dev);
+u16 mlx5_eswitch_get_total_vports(const struct mlx5_core_dev *dev);
+
 #else  /* CONFIG_MLX5_ESWITCH */
 
 static inline u8 mlx5_eswitch_mode(struct mlx5_core_dev *dev)
@@ -162,10 +162,17 @@ mlx5_eswitch_get_vport_metadata_mask(void)
 {
 	return 0;
 }
+
+static inline u16 mlx5_eswitch_get_total_vports(const struct mlx5_core_dev *dev)
+{
+	return 0;
+}
+
 #endif /* CONFIG_MLX5_ESWITCH */
 
 static inline bool is_mdev_switchdev_mode(struct mlx5_core_dev *dev)
 {
 	return mlx5_eswitch_mode(dev) == MLX5_ESWITCH_OFFLOADS;
 }
+
 #endif
-- 
2.30.2

