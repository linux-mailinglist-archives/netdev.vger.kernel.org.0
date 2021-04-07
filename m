Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29CFF3562B8
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 06:54:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348534AbhDGEyr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 00:54:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:60506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232880AbhDGEyo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 00:54:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 86A9D613CE;
        Wed,  7 Apr 2021 04:54:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617771275;
        bh=odu8GklPzNMJCwRWLiExZv+QiEksNn8bcseYk+dP1dM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oS7sq0eRzsdMmyiOS3xDaZpzvAMB8r+YesnfoTeb8NSlqReMhOHDHvRTNLYEefBIP
         dT8XTQK+Ya3LS/d6iXJO7aLyI5Cm9qyKhkM/aiPhSmzWdoIZGrVBOLMIjDwu/jtSJp
         yT++UCoLSbrbpYsJ5bSfZCC/f0GMm47Adc2oHQpeAaiZJO3o++on1tqEzUrpkKmG40
         0Y6ZpwA65JA3dEmh9s0RVXY1cQx28SR4Z7O5HrR/jxmkHOGHFaz9gNhp+b8AfCzttg
         nBbpgO1Ezbn4X/woyk9Py0OIFQQTsyaqsYgHCUifgt3O0r5N3UUPBmm5jCXfBPpqLT
         Z6SE5u4TFDJuw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Chris Mi <cmi@nvidia.com>,
        Oz Shlomo <ozsh@nvidia.com>, Mark Bloch <mbloch@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 01/13] net/mlx5: E-switch, Move vport table functions to a new file
Date:   Tue,  6 Apr 2021 21:54:09 -0700
Message-Id: <20210407045421.148987-2-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210407045421.148987-1-saeed@kernel.org>
References: <20210407045421.148987-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chris Mi <cmi@nvidia.com>

Currently, the vport table functions are in common eswitch offload
file. This file is too big. Move the vport table create, delete and
lookup functions to a separate file. Put the file in esw directory.

Pre-step for generalizing its functionality for serving both the
mirroring and the sample features.

Signed-off-by: Chris Mi <cmi@nvidia.com>
Reviewed-by: Oz Shlomo <ozsh@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/Makefile  |   2 +-
 .../mellanox/mlx5/core/esw/vporttbl.c         | 136 +++++++++++
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |  12 +-
 .../mellanox/mlx5/core/eswitch_offloads.c     | 215 +++---------------
 4 files changed, 183 insertions(+), 182 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/esw/vporttbl.c

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
index 9cf7de72df52..4c86b68ad26c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -53,7 +53,7 @@ mlx5_core-$(CONFIG_MLX5_ESWITCH)   += eswitch.o eswitch_offloads.o eswitch_offlo
 mlx5_core-$(CONFIG_MLX5_ESWITCH)   += esw/acl/helper.o \
 				      esw/acl/egress_lgcy.o esw/acl/egress_ofld.o \
 				      esw/acl/ingress_lgcy.o esw/acl/ingress_ofld.o \
-				      esw/devlink_port.o
+				      esw/devlink_port.o esw/vporttbl.o
 
 mlx5_core-$(CONFIG_MLX5_MPFS)      += lib/mpfs.o
 mlx5_core-$(CONFIG_VXLAN)          += lib/vxlan.o
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/vporttbl.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/vporttbl.c
new file mode 100644
index 000000000000..8219c5d50db0
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/vporttbl.c
@@ -0,0 +1,136 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+// Copyright (c) 2021 Mellanox Technologies.
+
+#include "eswitch.h"
+
+#define MLX5_ESW_VPORT_TABLE_SIZE 128
+#define MLX5_ESW_VPORT_TBL_NUM_GROUPS  4
+
+/* This struct is used as a key to the hash table and we need it to be packed
+ * so hash result is consistent
+ */
+struct mlx5_vport_key {
+	u32 chain;
+	u16 prio;
+	u16 vport;
+	u16 vhca_id;
+} __packed;
+
+struct mlx5_vport_table {
+	struct hlist_node hlist;
+	struct mlx5_flow_table *fdb;
+	u32 num_rules;
+	struct mlx5_vport_key key;
+};
+
+static struct mlx5_flow_table *
+esw_vport_tbl_create(struct mlx5_eswitch *esw, struct mlx5_flow_namespace *ns)
+{
+	struct mlx5_flow_table_attr ft_attr = {};
+	struct mlx5_flow_table *fdb;
+
+	ft_attr.autogroup.max_num_groups = MLX5_ESW_VPORT_TBL_NUM_GROUPS;
+	ft_attr.max_fte = MLX5_ESW_VPORT_TABLE_SIZE;
+	ft_attr.prio = FDB_PER_VPORT;
+	fdb = mlx5_create_auto_grouped_flow_table(ns, &ft_attr);
+	if (IS_ERR(fdb)) {
+		esw_warn(esw->dev, "Failed to create per vport FDB Table err %ld\n",
+			 PTR_ERR(fdb));
+	}
+
+	return fdb;
+}
+
+static u32 flow_attr_to_vport_key(struct mlx5_eswitch *esw,
+				  struct mlx5_vport_tbl_attr *attr,
+				  struct mlx5_vport_key *key)
+{
+	key->vport = attr->vport;
+	key->chain = attr->chain;
+	key->prio = attr->prio;
+	key->vhca_id = MLX5_CAP_GEN(esw->dev, vhca_id);
+	return jhash(key, sizeof(*key), 0);
+}
+
+/* caller must hold vports.lock */
+static struct mlx5_vport_table *
+esw_vport_tbl_lookup(struct mlx5_eswitch *esw, struct mlx5_vport_key *skey, u32 key)
+{
+	struct mlx5_vport_table *e;
+
+	hash_for_each_possible(esw->fdb_table.offloads.vports.table, e, hlist, key)
+		if (!memcmp(&e->key, skey, sizeof(*skey)))
+			return e;
+
+	return NULL;
+}
+
+struct mlx5_flow_table *
+esw_vport_tbl_get(struct mlx5_eswitch *esw, struct mlx5_vport_tbl_attr *attr)
+{
+	struct mlx5_core_dev *dev = esw->dev;
+	struct mlx5_flow_namespace *ns;
+	struct mlx5_flow_table *fdb;
+	struct mlx5_vport_table *e;
+	struct mlx5_vport_key skey;
+	u32 hkey;
+
+	mutex_lock(&esw->fdb_table.offloads.vports.lock);
+	hkey = flow_attr_to_vport_key(esw, attr, &skey);
+	e = esw_vport_tbl_lookup(esw, &skey, hkey);
+	if (e) {
+		e->num_rules++;
+		goto out;
+	}
+
+	e = kzalloc(sizeof(*e), GFP_KERNEL);
+	if (!e) {
+		fdb = ERR_PTR(-ENOMEM);
+		goto err_alloc;
+	}
+
+	ns = mlx5_get_flow_namespace(dev, MLX5_FLOW_NAMESPACE_FDB);
+	if (!ns) {
+		esw_warn(dev, "Failed to get FDB namespace\n");
+		fdb = ERR_PTR(-ENOENT);
+		goto err_ns;
+	}
+
+	fdb = esw_vport_tbl_create(esw, ns);
+	if (IS_ERR(fdb))
+		goto err_ns;
+
+	e->fdb = fdb;
+	e->num_rules = 1;
+	e->key = skey;
+	hash_add(esw->fdb_table.offloads.vports.table, &e->hlist, hkey);
+out:
+	mutex_unlock(&esw->fdb_table.offloads.vports.lock);
+	return e->fdb;
+
+err_ns:
+	kfree(e);
+err_alloc:
+	mutex_unlock(&esw->fdb_table.offloads.vports.lock);
+	return fdb;
+}
+
+void
+esw_vport_tbl_put(struct mlx5_eswitch *esw, struct mlx5_vport_tbl_attr *attr)
+{
+	struct mlx5_vport_table *e;
+	struct mlx5_vport_key key;
+	u32 hkey;
+
+	mutex_lock(&esw->fdb_table.offloads.vports.lock);
+	hkey = flow_attr_to_vport_key(esw, attr, &key);
+	e = esw_vport_tbl_lookup(esw, &key, hkey);
+	if (!e || --e->num_rules)
+		goto out;
+
+	hash_del(&e->hlist);
+	mlx5_destroy_flow_table(e->fdb);
+	kfree(e);
+out:
+	mutex_unlock(&esw->fdb_table.offloads.vports.lock);
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index 64db903068c1..70eeb8d1ae03 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -713,8 +713,16 @@ void
 esw_vport_destroy_offloads_acl_tables(struct mlx5_eswitch *esw,
 				      struct mlx5_vport *vport);
 
-int mlx5_esw_vport_tbl_get(struct mlx5_eswitch *esw);
-void mlx5_esw_vport_tbl_put(struct mlx5_eswitch *esw);
+struct mlx5_vport_tbl_attr {
+	u16 chain;
+	u16 prio;
+	u16 vport;
+};
+
+struct mlx5_flow_table *
+esw_vport_tbl_get(struct mlx5_eswitch *esw, struct mlx5_vport_tbl_attr *attr);
+void
+esw_vport_tbl_put(struct mlx5_eswitch *esw, struct mlx5_vport_tbl_attr *attr);
 
 struct mlx5_flow_handle *
 esw_add_restore_rule(struct mlx5_eswitch *esw, u32 tag);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index d5de6bf622ce..3caf6c0b3296 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -54,185 +54,6 @@
 #define MLX5_ESW_MISS_FLOWS (2)
 #define UPLINK_REP_INDEX 0
 
-/* Per vport tables */
-
-#define MLX5_ESW_VPORT_TABLE_SIZE 128
-
-/* This struct is used as a key to the hash table and we need it to be packed
- * so hash result is consistent
- */
-struct mlx5_vport_key {
-	u32 chain;
-	u16 prio;
-	u16 vport;
-	u16 vhca_id;
-} __packed;
-
-struct mlx5_vport_tbl_attr {
-	u16 chain;
-	u16 prio;
-	u16 vport;
-};
-
-struct mlx5_vport_table {
-	struct hlist_node hlist;
-	struct mlx5_flow_table *fdb;
-	u32 num_rules;
-	struct mlx5_vport_key key;
-};
-
-#define MLX5_ESW_VPORT_TBL_NUM_GROUPS  4
-
-static struct mlx5_flow_table *
-esw_vport_tbl_create(struct mlx5_eswitch *esw, struct mlx5_flow_namespace *ns)
-{
-	struct mlx5_flow_table_attr ft_attr = {};
-	struct mlx5_flow_table *fdb;
-
-	ft_attr.autogroup.max_num_groups = MLX5_ESW_VPORT_TBL_NUM_GROUPS;
-	ft_attr.max_fte = MLX5_ESW_VPORT_TABLE_SIZE;
-	ft_attr.prio = FDB_PER_VPORT;
-	fdb = mlx5_create_auto_grouped_flow_table(ns, &ft_attr);
-	if (IS_ERR(fdb)) {
-		esw_warn(esw->dev, "Failed to create per vport FDB Table err %ld\n",
-			 PTR_ERR(fdb));
-	}
-
-	return fdb;
-}
-
-static u32 flow_attr_to_vport_key(struct mlx5_eswitch *esw,
-				  struct mlx5_vport_tbl_attr *attr,
-				  struct mlx5_vport_key *key)
-{
-	key->vport = attr->vport;
-	key->chain = attr->chain;
-	key->prio = attr->prio;
-	key->vhca_id = MLX5_CAP_GEN(esw->dev, vhca_id);
-	return jhash(key, sizeof(*key), 0);
-}
-
-/* caller must hold vports.lock */
-static struct mlx5_vport_table *
-esw_vport_tbl_lookup(struct mlx5_eswitch *esw, struct mlx5_vport_key *skey, u32 key)
-{
-	struct mlx5_vport_table *e;
-
-	hash_for_each_possible(esw->fdb_table.offloads.vports.table, e, hlist, key)
-		if (!memcmp(&e->key, skey, sizeof(*skey)))
-			return e;
-
-	return NULL;
-}
-
-static void
-esw_vport_tbl_put(struct mlx5_eswitch *esw, struct mlx5_vport_tbl_attr *attr)
-{
-	struct mlx5_vport_table *e;
-	struct mlx5_vport_key key;
-	u32 hkey;
-
-	mutex_lock(&esw->fdb_table.offloads.vports.lock);
-	hkey = flow_attr_to_vport_key(esw, attr, &key);
-	e = esw_vport_tbl_lookup(esw, &key, hkey);
-	if (!e || --e->num_rules)
-		goto out;
-
-	hash_del(&e->hlist);
-	mlx5_destroy_flow_table(e->fdb);
-	kfree(e);
-out:
-	mutex_unlock(&esw->fdb_table.offloads.vports.lock);
-}
-
-static struct mlx5_flow_table *
-esw_vport_tbl_get(struct mlx5_eswitch *esw, struct mlx5_vport_tbl_attr *attr)
-{
-	struct mlx5_core_dev *dev = esw->dev;
-	struct mlx5_flow_namespace *ns;
-	struct mlx5_flow_table *fdb;
-	struct mlx5_vport_table *e;
-	struct mlx5_vport_key skey;
-	u32 hkey;
-
-	mutex_lock(&esw->fdb_table.offloads.vports.lock);
-	hkey = flow_attr_to_vport_key(esw, attr, &skey);
-	e = esw_vport_tbl_lookup(esw, &skey, hkey);
-	if (e) {
-		e->num_rules++;
-		goto out;
-	}
-
-	e = kzalloc(sizeof(*e), GFP_KERNEL);
-	if (!e) {
-		fdb = ERR_PTR(-ENOMEM);
-		goto err_alloc;
-	}
-
-	ns = mlx5_get_flow_namespace(dev, MLX5_FLOW_NAMESPACE_FDB);
-	if (!ns) {
-		esw_warn(dev, "Failed to get FDB namespace\n");
-		fdb = ERR_PTR(-ENOENT);
-		goto err_ns;
-	}
-
-	fdb = esw_vport_tbl_create(esw, ns);
-	if (IS_ERR(fdb))
-		goto err_ns;
-
-	e->fdb = fdb;
-	e->num_rules = 1;
-	e->key = skey;
-	hash_add(esw->fdb_table.offloads.vports.table, &e->hlist, hkey);
-out:
-	mutex_unlock(&esw->fdb_table.offloads.vports.lock);
-	return e->fdb;
-
-err_ns:
-	kfree(e);
-err_alloc:
-	mutex_unlock(&esw->fdb_table.offloads.vports.lock);
-	return fdb;
-}
-
-int mlx5_esw_vport_tbl_get(struct mlx5_eswitch *esw)
-{
-	struct mlx5_vport_tbl_attr attr;
-	struct mlx5_flow_table *fdb;
-	struct mlx5_vport *vport;
-	int i;
-
-	attr.chain = 0;
-	attr.prio = 1;
-	mlx5_esw_for_all_vports(esw, i, vport) {
-		attr.vport = vport->vport;
-		fdb = esw_vport_tbl_get(esw, &attr);
-		if (IS_ERR(fdb))
-			goto out;
-	}
-	return 0;
-
-out:
-	mlx5_esw_vport_tbl_put(esw);
-	return PTR_ERR(fdb);
-}
-
-void mlx5_esw_vport_tbl_put(struct mlx5_eswitch *esw)
-{
-	struct mlx5_vport_tbl_attr attr;
-	struct mlx5_vport *vport;
-	int i;
-
-	attr.chain = 0;
-	attr.prio = 1;
-	mlx5_esw_for_all_vports(esw, i, vport) {
-		attr.vport = vport->vport;
-		esw_vport_tbl_put(esw, &attr);
-	}
-}
-
-/* End: Per vport tables */
-
 static struct mlx5_eswitch_rep *mlx5_eswitch_get_rep(struct mlx5_eswitch *esw,
 						     u16 vport_num)
 {
@@ -1514,6 +1335,42 @@ static void esw_set_flow_group_source_port(struct mlx5_eswitch *esw,
 }
 
 #if IS_ENABLED(CONFIG_MLX5_CLS_ACT)
+static void mlx5_esw_vport_tbl_put(struct mlx5_eswitch *esw)
+{
+	struct mlx5_vport_tbl_attr attr;
+	struct mlx5_vport *vport;
+	int i;
+
+	attr.chain = 0;
+	attr.prio = 1;
+	mlx5_esw_for_all_vports(esw, i, vport) {
+		attr.vport = vport->vport;
+		esw_vport_tbl_put(esw, &attr);
+	}
+}
+
+static int mlx5_esw_vport_tbl_get(struct mlx5_eswitch *esw)
+{
+	struct mlx5_vport_tbl_attr attr;
+	struct mlx5_flow_table *fdb;
+	struct mlx5_vport *vport;
+	int i;
+
+	attr.chain = 0;
+	attr.prio = 1;
+	mlx5_esw_for_all_vports(esw, i, vport) {
+		attr.vport = vport->vport;
+		fdb = esw_vport_tbl_get(esw, &attr);
+		if (IS_ERR(fdb))
+			goto out;
+	}
+	return 0;
+
+out:
+	mlx5_esw_vport_tbl_put(esw);
+	return PTR_ERR(fdb);
+}
+
 #define fdb_modify_header_fwd_to_table_supported(esw) \
 	(MLX5_CAP_ESW_FLOWTABLE((esw)->dev, fdb_modify_header_fwd_to_table))
 static void esw_init_chains_offload_flags(struct mlx5_eswitch *esw, u32 *flags)
-- 
2.30.2

