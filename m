Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 707D136A008
	for <lists+netdev@lfdr.de>; Sat, 24 Apr 2021 10:02:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233252AbhDXIDQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Apr 2021 04:03:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:47286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231467AbhDXICK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 24 Apr 2021 04:02:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8A8DD61492;
        Sat, 24 Apr 2021 08:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619251282;
        bh=2v2srkqIqLNqtQ7NuTxvWZIrLBlLkdLxxMQlR5cfqY8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oZnAvjOSjX2qUUnuX510RV4hhvK6jN6Mc0gTTKDPaxmvggM6wh4VyaJTNGWuj7zA+
         /KqUMZol+R7myGbzndNTaqi75UdtAw9iaThpzDFMhD5WnBtc/JJ5/HwdHRJdnos4JV
         gTYGXATScfFkp7ZwMivnKknGimw4oguvf0Kim4+X4mvWR6LtGd4eY3e7GT0veeea1S
         gGvv07nUyTwVnIL5gxCv+FMikPmxcv8omSIIXsvX0RA88Rd58A8nilcoiDBV7f5MS9
         FzpM9IJhBzRVNnM7Q+IAmoXoWs++zwji3wpnl2lbRCbXQnags0jzw5yI4TENklRTwc
         Vpo4Tqyykipsg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Parav Pandit <parav@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Vu Pham <vuhuong@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next V2 03/11] net/mlx5: E-Switch, Use xarray for vport number to vport and rep mapping
Date:   Sat, 24 Apr 2021 01:01:07 -0700
Message-Id: <20210424080115.97273-4-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210424080115.97273-1-saeed@kernel.org>
References: <20210424080115.97273-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@nvidia.com>

Currently vport number to vport and its representor are mapped using an
array and an index.

Vport numbers of different types of functions are not contiguous. Adding
new such discontiguous range using index and number mapping is increasingly
complex and hard to maintain.

Hence, maintain an xarray of vport and rep whose lookup is done based on
the vport number.
Each VF and SF entry is marked with a xarray mark to identify the function
type. Additionally PF and VF needs special handling for legacy inline
mode. They are additionally marked as host function using additional
HOST_FN mark.

Signed-off-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Vu Pham <vuhuong@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/esw/acl/egress_lgcy.c  |   2 +-
 .../mellanox/mlx5/core/esw/acl/egress_ofld.c  |   4 +-
 .../mellanox/mlx5/core/esw/acl/helper.c       |   8 +-
 .../mellanox/mlx5/core/esw/acl/helper.h       |   2 +-
 .../mellanox/mlx5/core/esw/acl/ingress_lgcy.c |   2 +-
 .../mellanox/mlx5/core/esw/acl/ingress_ofld.c |   4 +-
 .../mellanox/mlx5/core/esw/devlink_port.c     |   3 +-
 .../ethernet/mellanox/mlx5/core/esw/legacy.c  |   3 +-
 .../net/ethernet/mellanox/mlx5/core/eswitch.c | 205 +++++++++----
 .../net/ethernet/mellanox/mlx5/core/eswitch.h | 194 ++----------
 .../mellanox/mlx5/core/eswitch_offloads.c     | 276 ++++++++++++------
 11 files changed, 380 insertions(+), 323 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/egress_lgcy.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/egress_lgcy.c
index 3e19b1721303..0399a396d166 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/egress_lgcy.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/egress_lgcy.c
@@ -96,7 +96,7 @@ int esw_acl_egress_lgcy_setup(struct mlx5_eswitch *esw,
 	}
 
 	if (!vport->egress.acl) {
-		vport->egress.acl = esw_acl_table_create(esw, vport->vport,
+		vport->egress.acl = esw_acl_table_create(esw, vport,
 							 MLX5_FLOW_NAMESPACE_ESW_EGRESS,
 							 table_size);
 		if (IS_ERR(vport->egress.acl)) {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/egress_ofld.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/egress_ofld.c
index 26b37a0f8762..505bf811984a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/egress_ofld.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/egress_ofld.c
@@ -148,7 +148,7 @@ static void esw_acl_egress_ofld_groups_destroy(struct mlx5_vport *vport)
 	esw_acl_egress_vlan_grp_destroy(vport);
 }
 
-static bool esw_acl_egress_needed(const struct mlx5_eswitch *esw, u16 vport_num)
+static bool esw_acl_egress_needed(struct mlx5_eswitch *esw, u16 vport_num)
 {
 	return mlx5_eswitch_is_vf_vport(esw, vport_num) || mlx5_esw_is_sf_vport(esw, vport_num);
 }
@@ -171,7 +171,7 @@ int esw_acl_egress_ofld_setup(struct mlx5_eswitch *esw, struct mlx5_vport *vport
 		table_size++;
 	if (MLX5_CAP_GEN(esw->dev, prio_tag_required))
 		table_size++;
-	vport->egress.acl = esw_acl_table_create(esw, vport->vport,
+	vport->egress.acl = esw_acl_table_create(esw, vport,
 						 MLX5_FLOW_NAMESPACE_ESW_EGRESS, table_size);
 	if (IS_ERR(vport->egress.acl)) {
 		err = PTR_ERR(vport->egress.acl);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/helper.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/helper.c
index 4a369669e51e..45b839116212 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/helper.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/helper.c
@@ -6,14 +6,14 @@
 #include "helper.h"
 
 struct mlx5_flow_table *
-esw_acl_table_create(struct mlx5_eswitch *esw, u16 vport_num, int ns, int size)
+esw_acl_table_create(struct mlx5_eswitch *esw, struct mlx5_vport *vport, int ns, int size)
 {
 	struct mlx5_flow_table_attr ft_attr = {};
 	struct mlx5_core_dev *dev = esw->dev;
 	struct mlx5_flow_namespace *root_ns;
 	struct mlx5_flow_table *acl;
 	int acl_supported;
-	int vport_index;
+	u16 vport_num;
 	int err;
 
 	acl_supported = (ns == MLX5_FLOW_NAMESPACE_ESW_INGRESS) ?
@@ -23,11 +23,11 @@ esw_acl_table_create(struct mlx5_eswitch *esw, u16 vport_num, int ns, int size)
 	if (!acl_supported)
 		return ERR_PTR(-EOPNOTSUPP);
 
+	vport_num = vport->vport;
 	esw_debug(dev, "Create vport[%d] %s ACL table\n", vport_num,
 		  ns == MLX5_FLOW_NAMESPACE_ESW_INGRESS ? "ingress" : "egress");
 
-	vport_index = mlx5_eswitch_vport_num_to_index(esw, vport_num);
-	root_ns = mlx5_get_flow_vport_acl_namespace(dev, ns, vport_index);
+	root_ns = mlx5_get_flow_vport_acl_namespace(dev, ns, vport->index);
 	if (!root_ns) {
 		esw_warn(dev, "Failed to get E-Switch root namespace for vport (%d)\n",
 			 vport_num);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/helper.h b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/helper.h
index 8dc4cab66a71..a47063fab57e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/helper.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/helper.h
@@ -8,7 +8,7 @@
 
 /* General acl helper functions */
 struct mlx5_flow_table *
-esw_acl_table_create(struct mlx5_eswitch *esw, u16 vport_num, int ns, int size);
+esw_acl_table_create(struct mlx5_eswitch *esw, struct mlx5_vport *vport, int ns, int size);
 
 /* Egress acl helper functions */
 void esw_acl_egress_table_destroy(struct mlx5_vport *vport);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_lgcy.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_lgcy.c
index d64fad2823e7..f75b86abaf1c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_lgcy.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_lgcy.c
@@ -177,7 +177,7 @@ int esw_acl_ingress_lgcy_setup(struct mlx5_eswitch *esw,
 	}
 
 	if (!vport->ingress.acl) {
-		vport->ingress.acl = esw_acl_table_create(esw, vport->vport,
+		vport->ingress.acl = esw_acl_table_create(esw, vport,
 							  MLX5_FLOW_NAMESPACE_ESW_INGRESS,
 							  table_size);
 		if (IS_ERR(vport->ingress.acl)) {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_ofld.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_ofld.c
index 548c005ea633..39e948bc1204 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_ofld.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_ofld.c
@@ -7,7 +7,7 @@
 #include "ofld.h"
 
 static bool
-esw_acl_ingress_prio_tag_enabled(const struct mlx5_eswitch *esw,
+esw_acl_ingress_prio_tag_enabled(struct mlx5_eswitch *esw,
 				 const struct mlx5_vport *vport)
 {
 	return (MLX5_CAP_GEN(esw->dev, prio_tag_required) &&
@@ -255,7 +255,7 @@ int esw_acl_ingress_ofld_setup(struct mlx5_eswitch *esw,
 	if (esw_acl_ingress_prio_tag_enabled(esw, vport))
 		num_ftes++;
 
-	vport->ingress.acl = esw_acl_table_create(esw, vport->vport,
+	vport->ingress.acl = esw_acl_table_create(esw, vport,
 						  MLX5_FLOW_NAMESPACE_ESW_INGRESS,
 						  num_ftes);
 	if (IS_ERR(vport->ingress.acl)) {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c
index 7bfc84238b3d..8e825ef35cb7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c
@@ -14,8 +14,7 @@ mlx5_esw_get_port_parent_id(struct mlx5_core_dev *dev, struct netdev_phys_item_i
 	memcpy(ppid->id, &parent_id, sizeof(parent_id));
 }
 
-static bool
-mlx5_esw_devlink_port_supported(const struct mlx5_eswitch *esw, u16 vport_num)
+static bool mlx5_esw_devlink_port_supported(struct mlx5_eswitch *esw, u16 vport_num)
 {
 	return vport_num == MLX5_VPORT_UPLINK ||
 	       (mlx5_core_is_ecpf(esw->dev) && vport_num == MLX5_VPORT_PF) ||
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/legacy.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/legacy.c
index 8ab1224653a4..d9041b16611d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/legacy.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/legacy.c
@@ -216,7 +216,8 @@ static void esw_destroy_legacy_table(struct mlx5_eswitch *esw)
 int esw_legacy_enable(struct mlx5_eswitch *esw)
 {
 	struct mlx5_vport *vport;
-	int ret, i;
+	unsigned long i;
+	int ret;
 
 	ret = esw_create_legacy_table(esw);
 	if (ret)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index f0974aa94574..90d8bda87579 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -88,20 +88,17 @@ struct mlx5_eswitch *mlx5_devlink_eswitch_get(struct devlink *devlink)
 struct mlx5_vport *__must_check
 mlx5_eswitch_get_vport(struct mlx5_eswitch *esw, u16 vport_num)
 {
-	u16 idx;
+	struct mlx5_vport *vport;
 
 	if (!esw || !MLX5_CAP_GEN(esw->dev, vport_group_manager))
 		return ERR_PTR(-EPERM);
 
-	idx = mlx5_eswitch_vport_num_to_index(esw, vport_num);
-
-	if (idx > esw->total_vports - 1) {
-		esw_debug(esw->dev, "vport out of range: num(0x%x), idx(0x%x)\n",
-			  vport_num, idx);
+	vport = xa_load(&esw->vports, vport_num);
+	if (!vport) {
+		esw_debug(esw->dev, "vport out of range: num(0x%x)\n", vport_num);
 		return ERR_PTR(-EINVAL);
 	}
-
-	return &esw->vports[idx];
+	return vport;
 }
 
 static int arm_vport_context_events_cmd(struct mlx5_core_dev *dev, u16 vport,
@@ -345,9 +342,10 @@ static void update_allmulti_vports(struct mlx5_eswitch *esw,
 {
 	u8 *mac = vaddr->node.addr;
 	struct mlx5_vport *vport;
-	u16 i, vport_num;
+	unsigned long i;
+	u16 vport_num;
 
-	mlx5_esw_for_all_vports(esw, i, vport) {
+	mlx5_esw_for_each_vport(esw, i, vport) {
 		struct hlist_head *vport_hash = vport->mc_list;
 		struct vport_addr *iter_vaddr =
 					l2addr_hash_find(vport_hash,
@@ -1175,7 +1173,7 @@ static void mlx5_eswitch_event_handlers_unregister(struct mlx5_eswitch *esw)
 static void mlx5_eswitch_clear_vf_vports_info(struct mlx5_eswitch *esw)
 {
 	struct mlx5_vport *vport;
-	int i;
+	unsigned long i;
 
 	mlx5_esw_for_each_vf_vport(esw, i, vport, esw->esw_funcs.num_vfs) {
 		memset(&vport->qos, 0, sizeof(vport->qos));
@@ -1213,20 +1211,25 @@ void mlx5_eswitch_unload_vport(struct mlx5_eswitch *esw, u16 vport_num)
 
 void mlx5_eswitch_unload_vf_vports(struct mlx5_eswitch *esw, u16 num_vfs)
 {
-	int i;
+	struct mlx5_vport *vport;
+	unsigned long i;
 
-	mlx5_esw_for_each_vf_vport_num_reverse(esw, i, num_vfs)
-		mlx5_eswitch_unload_vport(esw, i);
+	mlx5_esw_for_each_vf_vport(esw, i, vport, num_vfs) {
+		if (!vport->enabled)
+			continue;
+		mlx5_eswitch_unload_vport(esw, vport->vport);
+	}
 }
 
 int mlx5_eswitch_load_vf_vports(struct mlx5_eswitch *esw, u16 num_vfs,
 				enum mlx5_eswitch_vport_event enabled_events)
 {
+	struct mlx5_vport *vport;
+	unsigned long i;
 	int err;
-	int i;
 
-	mlx5_esw_for_each_vf_vport_num(esw, i, num_vfs) {
-		err = mlx5_eswitch_load_vport(esw, i, enabled_events);
+	mlx5_esw_for_each_vf_vport(esw, i, vport, num_vfs) {
+		err = mlx5_eswitch_load_vport(esw, vport->vport, enabled_events);
 		if (err)
 			goto vf_err;
 	}
@@ -1234,7 +1237,7 @@ int mlx5_eswitch_load_vf_vports(struct mlx5_eswitch *esw, u16 num_vfs,
 	return 0;
 
 vf_err:
-	mlx5_eswitch_unload_vf_vports(esw, i - 1);
+	mlx5_eswitch_unload_vf_vports(esw, num_vfs);
 	return err;
 }
 
@@ -1563,24 +1566,106 @@ void mlx5_eswitch_disable(struct mlx5_eswitch *esw, bool clear_vf)
 	up_write(&esw->mode_lock);
 }
 
+static int mlx5_esw_vport_alloc(struct mlx5_eswitch *esw, struct mlx5_core_dev *dev,
+				int index, u16 vport_num)
+{
+	struct mlx5_vport *vport;
+	int err;
+
+	vport = kzalloc(sizeof(*vport), GFP_KERNEL);
+	if (!vport)
+		return -ENOMEM;
+
+	vport->dev = esw->dev;
+	vport->vport = vport_num;
+	vport->index = index;
+	vport->info.link_state = MLX5_VPORT_ADMIN_STATE_AUTO;
+	INIT_WORK(&vport->vport_change_handler, esw_vport_change_handler);
+	err = xa_insert(&esw->vports, vport_num, vport, GFP_KERNEL);
+	if (err)
+		goto insert_err;
+
+	esw->total_vports++;
+	return 0;
+
+insert_err:
+	kfree(vport);
+	return err;
+}
+
+static void mlx5_esw_vport_free(struct mlx5_eswitch *esw, struct mlx5_vport *vport)
+{
+	xa_erase(&esw->vports, vport->vport);
+	kfree(vport);
+}
+
+static void mlx5_esw_vports_cleanup(struct mlx5_eswitch *esw)
+{
+	struct mlx5_vport *vport;
+	unsigned long i;
+
+	mlx5_esw_for_each_vport(esw, i, vport)
+		mlx5_esw_vport_free(esw, vport);
+	xa_destroy(&esw->vports);
+}
+
+static int mlx5_esw_vports_init(struct mlx5_eswitch *esw)
+{
+	struct mlx5_core_dev *dev = esw->dev;
+	u16 base_sf_num;
+	int idx = 0;
+	int err;
+	int i;
+
+	xa_init(&esw->vports);
+
+	err = mlx5_esw_vport_alloc(esw, dev, idx, MLX5_VPORT_PF);
+	if (err)
+		goto err;
+	if (esw->first_host_vport == MLX5_VPORT_PF)
+		xa_set_mark(&esw->vports, idx, MLX5_ESW_VPT_HOST_FN);
+	idx++;
+
+	for (i = 0; i < mlx5_core_max_vfs(dev); i++) {
+		err = mlx5_esw_vport_alloc(esw, dev, idx, idx);
+		if (err)
+			goto err;
+		xa_set_mark(&esw->vports, idx, MLX5_ESW_VPT_VF);
+		xa_set_mark(&esw->vports, idx, MLX5_ESW_VPT_HOST_FN);
+		idx++;
+	}
+	base_sf_num = mlx5_sf_start_function_id(dev);
+	for (i = 0; i < mlx5_sf_max_functions(dev); i++) {
+		err = mlx5_esw_vport_alloc(esw, dev, idx, base_sf_num + i);
+		if (err)
+			goto err;
+		xa_set_mark(&esw->vports, base_sf_num + i, MLX5_ESW_VPT_SF);
+		idx++;
+	}
+	if (mlx5_ecpf_vport_exists(dev)) {
+		err = mlx5_esw_vport_alloc(esw, dev, idx, MLX5_VPORT_ECPF);
+		if (err)
+			goto err;
+		idx++;
+	}
+	err = mlx5_esw_vport_alloc(esw, dev, idx, MLX5_VPORT_UPLINK);
+	if (err)
+		goto err;
+	return 0;
+
+err:
+	mlx5_esw_vports_cleanup(esw);
+	return err;
+}
+
 int mlx5_eswitch_init(struct mlx5_core_dev *dev)
 {
 	struct mlx5_eswitch *esw;
-	struct mlx5_vport *vport;
-	int total_vports;
-	int err, i;
+	int err;
 
 	if (!MLX5_VPORT_MANAGER(dev))
 		return 0;
 
-	total_vports = MLX5_SPECIAL_VPORTS(dev) + mlx5_core_max_vfs(dev) +
-			mlx5_sf_max_functions(dev);
-	esw_info(dev,
-		 "Total vports %d, per vport: max uc(%d) max mc(%d)\n",
-		 total_vports,
-		 MLX5_MAX_UC_PER_VPORT(dev),
-		 MLX5_MAX_MC_PER_VPORT(dev));
-
 	esw = kzalloc(sizeof(*esw), GFP_KERNEL);
 	if (!esw)
 		return -ENOMEM;
@@ -1595,18 +1680,13 @@ int mlx5_eswitch_init(struct mlx5_core_dev *dev)
 		goto abort;
 	}
 
-	esw->vports = kcalloc(total_vports, sizeof(struct mlx5_vport),
-			      GFP_KERNEL);
-	if (!esw->vports) {
-		err = -ENOMEM;
+	err = mlx5_esw_vports_init(esw);
+	if (err)
 		goto abort;
-	}
-
-	esw->total_vports = total_vports;
 
 	err = esw_offloads_init_reps(esw);
 	if (err)
-		goto abort;
+		goto reps_err;
 
 	mutex_init(&esw->offloads.encap_tbl_lock);
 	hash_init(esw->offloads.encap_tbl);
@@ -1619,25 +1699,25 @@ int mlx5_eswitch_init(struct mlx5_core_dev *dev)
 	mutex_init(&esw->state_lock);
 	init_rwsem(&esw->mode_lock);
 
-	mlx5_esw_for_all_vports(esw, i, vport) {
-		vport->vport = mlx5_eswitch_index_to_vport_num(esw, i);
-		vport->info.link_state = MLX5_VPORT_ADMIN_STATE_AUTO;
-		vport->dev = dev;
-		INIT_WORK(&vport->vport_change_handler,
-			  esw_vport_change_handler);
-	}
-
 	esw->enabled_vports = 0;
 	esw->mode = MLX5_ESWITCH_NONE;
 	esw->offloads.inline_mode = MLX5_INLINE_MODE_NONE;
 
 	dev->priv.eswitch = esw;
 	BLOCKING_INIT_NOTIFIER_HEAD(&esw->n_head);
+
+	esw_info(dev,
+		 "Total vports %d, per vport: max uc(%d) max mc(%d)\n",
+		 esw->total_vports,
+		 MLX5_MAX_UC_PER_VPORT(dev),
+		 MLX5_MAX_MC_PER_VPORT(dev));
 	return 0;
+
+reps_err:
+	mlx5_esw_vports_cleanup(esw);
 abort:
 	if (esw->work_queue)
 		destroy_workqueue(esw->work_queue);
-	kfree(esw->vports);
 	kfree(esw);
 	return err;
 }
@@ -1659,7 +1739,7 @@ void mlx5_eswitch_cleanup(struct mlx5_eswitch *esw)
 	mutex_destroy(&esw->offloads.encap_tbl_lock);
 	mutex_destroy(&esw->offloads.decap_tbl_lock);
 	esw_offloads_cleanup_reps(esw);
-	kfree(esw->vports);
+	mlx5_esw_vports_cleanup(esw);
 	kfree(esw);
 }
 
@@ -1718,8 +1798,29 @@ int mlx5_eswitch_set_vport_mac(struct mlx5_eswitch *esw,
 	return err;
 }
 
+static bool mlx5_esw_check_port_type(struct mlx5_eswitch *esw, u16 vport_num, xa_mark_t mark)
+{
+	struct mlx5_vport *vport;
+
+	vport = mlx5_eswitch_get_vport(esw, vport_num);
+	if (IS_ERR(vport))
+		return false;
+
+	return xa_get_mark(&esw->vports, vport_num, mark);
+}
+
+bool mlx5_eswitch_is_vf_vport(struct mlx5_eswitch *esw, u16 vport_num)
+{
+	return mlx5_esw_check_port_type(esw, vport_num, MLX5_ESW_VPT_VF);
+}
+
+bool mlx5_esw_is_sf_vport(struct mlx5_eswitch *esw, u16 vport_num)
+{
+	return mlx5_esw_check_port_type(esw, vport_num, MLX5_ESW_VPT_SF);
+}
+
 static bool
-is_port_function_supported(const struct mlx5_eswitch *esw, u16 vport_num)
+is_port_function_supported(struct mlx5_eswitch *esw, u16 vport_num)
 {
 	return vport_num == MLX5_VPORT_PF ||
 	       mlx5_eswitch_is_vf_vport(esw, vport_num) ||
@@ -1891,9 +1992,9 @@ static u32 calculate_vports_min_rate_divider(struct mlx5_eswitch *esw)
 	u32 fw_max_bw_share = MLX5_CAP_QOS(esw->dev, max_tsar_bw_share);
 	struct mlx5_vport *evport;
 	u32 max_guarantee = 0;
-	int i;
+	unsigned long i;
 
-	mlx5_esw_for_all_vports(esw, i, evport) {
+	mlx5_esw_for_each_vport(esw, i, evport) {
 		if (!evport->enabled || evport->qos.min_rate < max_guarantee)
 			continue;
 		max_guarantee = evport->qos.min_rate;
@@ -1911,11 +2012,11 @@ static int normalize_vports_min_rate(struct mlx5_eswitch *esw)
 	struct mlx5_vport *evport;
 	u32 vport_max_rate;
 	u32 vport_min_rate;
+	unsigned long i;
 	u32 bw_share;
 	int err;
-	int i;
 
-	mlx5_esw_for_all_vports(esw, i, evport) {
+	mlx5_esw_for_each_vport(esw, i, evport) {
 		if (!evport->enabled)
 			continue;
 		vport_min_rate = evport->qos.min_rate;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index 5ab480a5745d..7b5f9b8dc7df 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -176,6 +176,7 @@ struct mlx5_vport {
 	u16 vport;
 	bool                    enabled;
 	enum mlx5_eswitch_vport_event enabled_events;
+	int index;
 	struct devlink_port *dl_port;
 };
 
@@ -228,7 +229,7 @@ struct mlx5_esw_offload {
 
 	struct mlx5_flow_table *ft_offloads;
 	struct mlx5_flow_group *vport_rx_group;
-	struct mlx5_eswitch_rep *vport_reps;
+	struct xarray vport_reps;
 	struct list_head peer_flows;
 	struct mutex peer_mutex;
 	struct mutex encap_tbl_lock; /* protects encap_tbl */
@@ -278,7 +279,7 @@ struct mlx5_eswitch {
 	struct esw_mc_addr mc_promisc;
 	/* end of legacy */
 	struct workqueue_struct *work_queue;
-	struct mlx5_vport       *vports;
+	struct xarray vports;
 	u32 flags;
 	int                     total_vports;
 	int                     enabled_vports;
@@ -545,102 +546,11 @@ static inline u16 mlx5_eswitch_first_host_vport_num(struct mlx5_core_dev *dev)
 		MLX5_VPORT_PF : MLX5_VPORT_FIRST_VF;
 }
 
-#define MLX5_VPORT_PF_PLACEHOLDER		(1u)
-#define MLX5_VPORT_UPLINK_PLACEHOLDER		(1u)
-#define MLX5_VPORT_ECPF_PLACEHOLDER(mdev)	(mlx5_ecpf_vport_exists(mdev))
-
-#define MLX5_SPECIAL_VPORTS(mdev) (MLX5_VPORT_PF_PLACEHOLDER +		\
-				   MLX5_VPORT_UPLINK_PLACEHOLDER +	\
-				   MLX5_VPORT_ECPF_PLACEHOLDER(mdev))
-
-static inline int mlx5_esw_sf_start_idx(const struct mlx5_eswitch *esw)
-{
-	/* PF and VF vports indices start from 0 to max_vfs */
-	return MLX5_VPORT_PF_PLACEHOLDER + mlx5_core_max_vfs(esw->dev);
-}
-
-static inline int mlx5_esw_sf_end_idx(const struct mlx5_eswitch *esw)
-{
-	return mlx5_esw_sf_start_idx(esw) + mlx5_sf_max_functions(esw->dev);
-}
-
-static inline int
-mlx5_esw_sf_vport_num_to_index(const struct mlx5_eswitch *esw, u16 vport_num)
-{
-	return vport_num - mlx5_sf_start_function_id(esw->dev) +
-	       MLX5_VPORT_PF_PLACEHOLDER + mlx5_core_max_vfs(esw->dev);
-}
-
-static inline u16
-mlx5_esw_sf_vport_index_to_num(const struct mlx5_eswitch *esw, int idx)
-{
-	return mlx5_sf_start_function_id(esw->dev) + idx -
-	       (MLX5_VPORT_PF_PLACEHOLDER + mlx5_core_max_vfs(esw->dev));
-}
-
-static inline bool
-mlx5_esw_is_sf_vport(const struct mlx5_eswitch *esw, u16 vport_num)
-{
-	return mlx5_sf_supported(esw->dev) &&
-	       vport_num >= mlx5_sf_start_function_id(esw->dev) &&
-	       (vport_num < (mlx5_sf_start_function_id(esw->dev) +
-			     mlx5_sf_max_functions(esw->dev)));
-}
-
 static inline bool mlx5_eswitch_is_funcs_handler(const struct mlx5_core_dev *dev)
 {
 	return mlx5_core_is_ecpf_esw_manager(dev);
 }
 
-static inline int mlx5_eswitch_uplink_idx(struct mlx5_eswitch *esw)
-{
-	/* Uplink always locate at the last element of the array.*/
-	return esw->total_vports - 1;
-}
-
-static inline int mlx5_eswitch_ecpf_idx(struct mlx5_eswitch *esw)
-{
-	return esw->total_vports - 2;
-}
-
-static inline int mlx5_eswitch_vport_num_to_index(struct mlx5_eswitch *esw,
-						  u16 vport_num)
-{
-	if (vport_num == MLX5_VPORT_ECPF) {
-		if (!mlx5_ecpf_vport_exists(esw->dev))
-			esw_warn(esw->dev, "ECPF vport doesn't exist!\n");
-		return mlx5_eswitch_ecpf_idx(esw);
-	}
-
-	if (vport_num == MLX5_VPORT_UPLINK)
-		return mlx5_eswitch_uplink_idx(esw);
-
-	if (mlx5_esw_is_sf_vport(esw, vport_num))
-		return mlx5_esw_sf_vport_num_to_index(esw, vport_num);
-
-	/* PF and VF vports start from 0 to max_vfs */
-	return vport_num;
-}
-
-static inline u16 mlx5_eswitch_index_to_vport_num(struct mlx5_eswitch *esw,
-						  int index)
-{
-	if (index == mlx5_eswitch_ecpf_idx(esw) &&
-	    mlx5_ecpf_vport_exists(esw->dev))
-		return MLX5_VPORT_ECPF;
-
-	if (index == mlx5_eswitch_uplink_idx(esw))
-		return MLX5_VPORT_UPLINK;
-
-	/* SF vports indices are after VFs and before ECPF */
-	if (mlx5_sf_supported(esw->dev) &&
-	    index > mlx5_core_max_vfs(esw->dev))
-		return mlx5_esw_sf_vport_index_to_num(esw, index);
-
-	/* PF and VF vports start from 0 to max_vfs */
-	return index;
-}
-
 static inline unsigned int
 mlx5_esw_vport_to_devlink_port_index(const struct mlx5_core_dev *dev,
 				     u16 vport_num)
@@ -657,82 +567,42 @@ mlx5_esw_devlink_port_index_to_vport_num(unsigned int dl_port_index)
 /* TODO: This mlx5e_tc function shouldn't be called by eswitch */
 void mlx5e_tc_clean_fdb_peer_flows(struct mlx5_eswitch *esw);
 
-/* The vport getter/iterator are only valid after esw->total_vports
- * and vport->vport are initialized in mlx5_eswitch_init.
+/* Each mark identifies eswitch vport type.
+ * MLX5_ESW_VPT_HOST_FN is used to identify both PF and VF ports using
+ * a single mark.
+ * MLX5_ESW_VPT_VF identifies a SRIOV VF vport.
+ * MLX5_ESW_VPT_SF identifies SF vport.
  */
-#define mlx5_esw_for_all_vports(esw, i, vport)		\
-	for ((i) = MLX5_VPORT_PF;			\
-	     (vport) = &(esw)->vports[i],		\
-	     (i) < (esw)->total_vports; (i)++)
-
-#define mlx5_esw_for_all_vports_reverse(esw, i, vport)	\
-	for ((i) = (esw)->total_vports - 1;		\
-	     (vport) = &(esw)->vports[i],		\
-	     (i) >= MLX5_VPORT_PF; (i)--)
-
-#define mlx5_esw_for_each_vf_vport(esw, i, vport, nvfs)	\
-	for ((i) = MLX5_VPORT_FIRST_VF;			\
-	     (vport) = &(esw)->vports[(i)],		\
-	     (i) <= (nvfs); (i)++)
-
-#define mlx5_esw_for_each_vf_vport_reverse(esw, i, vport, nvfs)	\
-	for ((i) = (nvfs);					\
-	     (vport) = &(esw)->vports[(i)],			\
-	     (i) >= MLX5_VPORT_FIRST_VF; (i)--)
-
-/* The rep getter/iterator are only valid after esw->total_vports
- * and vport->vport are initialized in mlx5_eswitch_init.
+#define MLX5_ESW_VPT_HOST_FN XA_MARK_0
+#define MLX5_ESW_VPT_VF XA_MARK_1
+#define MLX5_ESW_VPT_SF XA_MARK_2
+
+/* The vport iterator is valid only after vport are initialized in mlx5_eswitch_init.
+ * Borrowed the idea from xa_for_each_marked() but with support for desired last element.
  */
-#define mlx5_esw_for_all_reps(esw, i, rep)			\
-	for ((i) = MLX5_VPORT_PF;				\
-	     (rep) = &(esw)->offloads.vport_reps[i],		\
-	     (i) < (esw)->total_vports; (i)++)
-
-#define mlx5_esw_for_each_vf_rep(esw, i, rep, nvfs)		\
-	for ((i) = MLX5_VPORT_FIRST_VF;				\
-	     (rep) = &(esw)->offloads.vport_reps[i],		\
-	     (i) <= (nvfs); (i)++)
-
-#define mlx5_esw_for_each_vf_rep_reverse(esw, i, rep, nvfs)	\
-	for ((i) = (nvfs);					\
-	     (rep) = &(esw)->offloads.vport_reps[i],		\
-	     (i) >= MLX5_VPORT_FIRST_VF; (i)--)
-
-#define mlx5_esw_for_each_vf_vport_num(esw, vport, nvfs)	\
-	for ((vport) = MLX5_VPORT_FIRST_VF; (vport) <= (nvfs); (vport)++)
-
-#define mlx5_esw_for_each_vf_vport_num_reverse(esw, vport, nvfs)	\
-	for ((vport) = (nvfs); (vport) >= MLX5_VPORT_FIRST_VF; (vport)--)
-
-/* Includes host PF (vport 0) if it's not esw manager. */
-#define mlx5_esw_for_each_host_func_rep(esw, i, rep, nvfs)	\
-	for ((i) = (esw)->first_host_vport;			\
-	     (rep) = &(esw)->offloads.vport_reps[i],		\
-	     (i) <= (nvfs); (i)++)
-
-#define mlx5_esw_for_each_host_func_rep_reverse(esw, i, rep, nvfs)	\
-	for ((i) = (nvfs);						\
-	     (rep) = &(esw)->offloads.vport_reps[i],			\
-	     (i) >= (esw)->first_host_vport; (i)--)
-
-#define mlx5_esw_for_each_host_func_vport(esw, vport, nvfs)	\
-	for ((vport) = (esw)->first_host_vport;			\
-	     (vport) <= (nvfs); (vport)++)
-
-#define mlx5_esw_for_each_host_func_vport_reverse(esw, vport, nvfs)	\
-	for ((vport) = (nvfs);						\
-	     (vport) >= (esw)->first_host_vport; (vport)--)
-
-#define mlx5_esw_for_each_sf_rep(esw, i, rep)		\
-	for ((i) = mlx5_esw_sf_start_idx(esw);		\
-	     (rep) = &(esw)->offloads.vport_reps[(i)],	\
-	     (i) < mlx5_esw_sf_end_idx(esw); (i++))
+
+#define mlx5_esw_for_each_vport(esw, index, vport) \
+	xa_for_each(&((esw)->vports), index, vport)
+
+#define mlx5_esw_for_each_entry_marked(xa, index, entry, last, filter)	\
+	for (index = 0, entry = xa_find(xa, &index, last, filter); \
+	     entry; entry = xa_find_after(xa, &index, last, filter))
+
+#define mlx5_esw_for_each_vport_marked(esw, index, vport, last, filter)	\
+	mlx5_esw_for_each_entry_marked(&((esw)->vports), index, vport, last, filter)
+
+#define mlx5_esw_for_each_vf_vport(esw, index, vport, last)	\
+	mlx5_esw_for_each_vport_marked(esw, index, vport, last, MLX5_ESW_VPT_VF)
+
+#define mlx5_esw_for_each_host_func_vport(esw, index, vport, last)	\
+	mlx5_esw_for_each_vport_marked(esw, index, vport, last, MLX5_ESW_VPT_HOST_FN)
 
 struct mlx5_eswitch *mlx5_devlink_eswitch_get(struct devlink *devlink);
 struct mlx5_vport *__must_check
 mlx5_eswitch_get_vport(struct mlx5_eswitch *esw, u16 vport_num);
 
-bool mlx5_eswitch_is_vf_vport(const struct mlx5_eswitch *esw, u16 vport_num);
+bool mlx5_eswitch_is_vf_vport(struct mlx5_eswitch *esw, u16 vport_num);
+bool mlx5_esw_is_sf_vport(struct mlx5_eswitch *esw, u16 vport_num);
 
 int mlx5_esw_funcs_changed_handler(struct notifier_block *nb, unsigned long type, void *data);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index bbb707117296..a1dd66540ba0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -49,6 +49,16 @@
 #include "en_tc.h"
 #include "en/mapping.h"
 
+#define mlx5_esw_for_each_rep(esw, i, rep) \
+	xa_for_each(&((esw)->offloads.vport_reps), i, rep)
+
+#define mlx5_esw_for_each_sf_rep(esw, i, rep) \
+	xa_for_each_marked(&((esw)->offloads.vport_reps), i, rep, MLX5_ESW_VPT_SF)
+
+#define mlx5_esw_for_each_vf_rep(esw, index, rep)	\
+	mlx5_esw_for_each_entry_marked(&((esw)->offloads.vport_reps), index, \
+				       rep, (esw)->esw_funcs.num_vfs, MLX5_ESW_VPT_VF)
+
 /* There are two match-all miss flows, one for unicast dst mac and
  * one for multicast.
  */
@@ -67,10 +77,7 @@ static const struct esw_vport_tbl_namespace mlx5_esw_vport_tbl_mirror_ns = {
 static struct mlx5_eswitch_rep *mlx5_eswitch_get_rep(struct mlx5_eswitch *esw,
 						     u16 vport_num)
 {
-	int idx = mlx5_eswitch_vport_num_to_index(esw, vport_num);
-
-	WARN_ON(idx > esw->total_vports - 1);
-	return &esw->offloads.vport_reps[idx];
+	return xa_load(&esw->offloads.vport_reps, vport_num);
 }
 
 static void
@@ -720,10 +727,11 @@ mlx5_eswitch_del_fwd_rule(struct mlx5_eswitch *esw,
 static int esw_set_global_vlan_pop(struct mlx5_eswitch *esw, u8 val)
 {
 	struct mlx5_eswitch_rep *rep;
-	int i, err = 0;
+	unsigned long i;
+	int err = 0;
 
 	esw_debug(esw->dev, "%s applying global %s policy\n", __func__, val ? "pop" : "none");
-	mlx5_esw_for_each_host_func_rep(esw, i, rep, esw->esw_funcs.num_vfs) {
+	mlx5_esw_for_each_host_func_vport(esw, i, rep, esw->esw_funcs.num_vfs) {
 		if (atomic_read(&rep->rep_data[REP_ETH].state) != REP_LOADED)
 			continue;
 
@@ -972,13 +980,13 @@ void mlx5_eswitch_del_send_to_vport_rule(struct mlx5_flow_handle *rule)
 static void mlx5_eswitch_del_send_to_vport_meta_rules(struct mlx5_eswitch *esw)
 {
 	struct mlx5_flow_handle **flows = esw->fdb_table.offloads.send_to_vport_meta_rules;
-	int i = 0, num_vfs = esw->esw_funcs.num_vfs, vport_num;
+	int i = 0, num_vfs = esw->esw_funcs.num_vfs;
 
 	if (!num_vfs || !flows)
 		return;
 
-	mlx5_esw_for_each_vf_vport_num(esw, vport_num, num_vfs)
-		mlx5_del_flow_rules(flows[i++]);
+	for (i = 0; i < num_vfs; i++)
+		mlx5_del_flow_rules(flows[i]);
 
 	kvfree(flows);
 }
@@ -992,6 +1000,8 @@ mlx5_eswitch_add_send_to_vport_meta_rules(struct mlx5_eswitch *esw)
 	struct mlx5_flow_handle *flow_rule;
 	struct mlx5_flow_handle **flows;
 	struct mlx5_flow_spec *spec;
+	struct mlx5_vport *vport;
+	unsigned long i;
 	u16 vport_num;
 
 	num_vfs = esw->esw_funcs.num_vfs;
@@ -1016,7 +1026,8 @@ mlx5_eswitch_add_send_to_vport_meta_rules(struct mlx5_eswitch *esw)
 	dest.type = MLX5_FLOW_DESTINATION_TYPE_VPORT;
 	flow_act.action = MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
 
-	mlx5_esw_for_each_vf_vport_num(esw, vport_num, num_vfs) {
+	mlx5_esw_for_each_vf_vport(esw, i, vport, num_vfs) {
+		vport_num = vport->vport;
 		MLX5_SET(fte_match_param, spec->match_value, misc_parameters_2.metadata_reg_c_0,
 			 mlx5_eswitch_get_vport_metadata_for_match(esw, vport_num));
 		dest.vport.num = vport_num;
@@ -1158,12 +1169,14 @@ static int esw_add_fdb_peer_miss_rules(struct mlx5_eswitch *esw,
 	struct mlx5_flow_destination dest = {};
 	struct mlx5_flow_act flow_act = {0};
 	struct mlx5_flow_handle **flows;
-	struct mlx5_flow_handle *flow;
-	struct mlx5_flow_spec *spec;
 	/* total vports is the same for both e-switches */
 	int nvports = esw->total_vports;
+	struct mlx5_flow_handle *flow;
+	struct mlx5_flow_spec *spec;
+	struct mlx5_vport *vport;
+	unsigned long i;
 	void *misc;
-	int err, i;
+	int err;
 
 	spec = kvzalloc(sizeof(*spec), GFP_KERNEL);
 	if (!spec)
@@ -1182,6 +1195,7 @@ static int esw_add_fdb_peer_miss_rules(struct mlx5_eswitch *esw,
 			    misc_parameters);
 
 	if (mlx5_core_is_ecpf_esw_manager(esw->dev)) {
+		vport = mlx5_eswitch_get_vport(esw, MLX5_VPORT_PF);
 		esw_set_peer_miss_rule_source_port(esw, peer_dev->priv.eswitch,
 						   spec, MLX5_VPORT_PF);
 
@@ -1191,10 +1205,11 @@ static int esw_add_fdb_peer_miss_rules(struct mlx5_eswitch *esw,
 			err = PTR_ERR(flow);
 			goto add_pf_flow_err;
 		}
-		flows[MLX5_VPORT_PF] = flow;
+		flows[vport->index] = flow;
 	}
 
 	if (mlx5_ecpf_vport_exists(esw->dev)) {
+		vport = mlx5_eswitch_get_vport(esw, MLX5_VPORT_ECPF);
 		MLX5_SET(fte_match_set_misc, misc, source_port, MLX5_VPORT_ECPF);
 		flow = mlx5_add_flow_rules(esw->fdb_table.offloads.slow_fdb,
 					   spec, &flow_act, &dest, 1);
@@ -1202,13 +1217,13 @@ static int esw_add_fdb_peer_miss_rules(struct mlx5_eswitch *esw,
 			err = PTR_ERR(flow);
 			goto add_ecpf_flow_err;
 		}
-		flows[mlx5_eswitch_ecpf_idx(esw)] = flow;
+		flows[vport->index] = flow;
 	}
 
-	mlx5_esw_for_each_vf_vport_num(esw, i, mlx5_core_max_vfs(esw->dev)) {
+	mlx5_esw_for_each_vf_vport(esw, i, vport, mlx5_core_max_vfs(esw->dev)) {
 		esw_set_peer_miss_rule_source_port(esw,
 						   peer_dev->priv.eswitch,
-						   spec, i);
+						   spec, vport->vport);
 
 		flow = mlx5_add_flow_rules(esw->fdb_table.offloads.slow_fdb,
 					   spec, &flow_act, &dest, 1);
@@ -1216,7 +1231,7 @@ static int esw_add_fdb_peer_miss_rules(struct mlx5_eswitch *esw,
 			err = PTR_ERR(flow);
 			goto add_vf_flow_err;
 		}
-		flows[i] = flow;
+		flows[vport->index] = flow;
 	}
 
 	esw->fdb_table.offloads.peer_miss_rules = flows;
@@ -1225,15 +1240,20 @@ static int esw_add_fdb_peer_miss_rules(struct mlx5_eswitch *esw,
 	return 0;
 
 add_vf_flow_err:
-	nvports = --i;
-	mlx5_esw_for_each_vf_vport_num_reverse(esw, i, nvports)
-		mlx5_del_flow_rules(flows[i]);
-
-	if (mlx5_ecpf_vport_exists(esw->dev))
-		mlx5_del_flow_rules(flows[mlx5_eswitch_ecpf_idx(esw)]);
+	mlx5_esw_for_each_vf_vport(esw, i, vport, mlx5_core_max_vfs(esw->dev)) {
+		if (!flows[vport->index])
+			continue;
+		mlx5_del_flow_rules(flows[vport->index]);
+	}
+	if (mlx5_ecpf_vport_exists(esw->dev)) {
+		vport = mlx5_eswitch_get_vport(esw, MLX5_VPORT_ECPF);
+		mlx5_del_flow_rules(flows[vport->index]);
+	}
 add_ecpf_flow_err:
-	if (mlx5_core_is_ecpf_esw_manager(esw->dev))
-		mlx5_del_flow_rules(flows[MLX5_VPORT_PF]);
+	if (mlx5_core_is_ecpf_esw_manager(esw->dev)) {
+		vport = mlx5_eswitch_get_vport(esw, MLX5_VPORT_PF);
+		mlx5_del_flow_rules(flows[vport->index]);
+	}
 add_pf_flow_err:
 	esw_warn(esw->dev, "FDB: Failed to add peer miss flow rule err %d\n", err);
 	kvfree(flows);
@@ -1245,20 +1265,23 @@ static int esw_add_fdb_peer_miss_rules(struct mlx5_eswitch *esw,
 static void esw_del_fdb_peer_miss_rules(struct mlx5_eswitch *esw)
 {
 	struct mlx5_flow_handle **flows;
-	int i;
+	struct mlx5_vport *vport;
+	unsigned long i;
 
 	flows = esw->fdb_table.offloads.peer_miss_rules;
 
-	mlx5_esw_for_each_vf_vport_num_reverse(esw, i,
-					       mlx5_core_max_vfs(esw->dev))
-		mlx5_del_flow_rules(flows[i]);
+	mlx5_esw_for_each_vf_vport(esw, i, vport, mlx5_core_max_vfs(esw->dev))
+		mlx5_del_flow_rules(flows[vport->index]);
 
-	if (mlx5_ecpf_vport_exists(esw->dev))
-		mlx5_del_flow_rules(flows[mlx5_eswitch_ecpf_idx(esw)]);
-
-	if (mlx5_core_is_ecpf_esw_manager(esw->dev))
-		mlx5_del_flow_rules(flows[MLX5_VPORT_PF]);
+	if (mlx5_ecpf_vport_exists(esw->dev)) {
+		vport = mlx5_eswitch_get_vport(esw, MLX5_VPORT_ECPF);
+		mlx5_del_flow_rules(flows[vport->index]);
+	}
 
+	if (mlx5_core_is_ecpf_esw_manager(esw->dev)) {
+		vport = mlx5_eswitch_get_vport(esw, MLX5_VPORT_PF);
+		mlx5_del_flow_rules(flows[vport->index]);
+	}
 	kvfree(flows);
 }
 
@@ -1402,11 +1425,11 @@ static void esw_vport_tbl_put(struct mlx5_eswitch *esw)
 {
 	struct mlx5_vport_tbl_attr attr;
 	struct mlx5_vport *vport;
-	int i;
+	unsigned long i;
 
 	attr.chain = 0;
 	attr.prio = 1;
-	mlx5_esw_for_all_vports(esw, i, vport) {
+	mlx5_esw_for_each_vport(esw, i, vport) {
 		attr.vport = vport->vport;
 		attr.vport_ns = &mlx5_esw_vport_tbl_mirror_ns;
 		mlx5_esw_vporttbl_put(esw, &attr);
@@ -1418,11 +1441,11 @@ static int esw_vport_tbl_get(struct mlx5_eswitch *esw)
 	struct mlx5_vport_tbl_attr attr;
 	struct mlx5_flow_table *fdb;
 	struct mlx5_vport *vport;
-	int i;
+	unsigned long i;
 
 	attr.chain = 0;
 	attr.prio = 1;
-	mlx5_esw_for_all_vports(esw, i, vport) {
+	mlx5_esw_for_each_vport(esw, i, vport) {
 		attr.vport = vport->vport;
 		attr.vport_ns = &mlx5_esw_vport_tbl_mirror_ns;
 		fdb = mlx5_esw_vporttbl_get(esw, &attr);
@@ -1910,12 +1933,12 @@ mlx5_eswitch_create_vport_rx_rule(struct mlx5_eswitch *esw, u16 vport,
 	return flow_rule;
 }
 
-
-static int mlx5_eswitch_inline_mode_get(const struct mlx5_eswitch *esw, u8 *mode)
+static int mlx5_eswitch_inline_mode_get(struct mlx5_eswitch *esw, u8 *mode)
 {
 	u8 prev_mlx5_mode, mlx5_mode = MLX5_INLINE_MODE_L2;
 	struct mlx5_core_dev *dev = esw->dev;
-	int vport;
+	struct mlx5_vport *vport;
+	unsigned long i;
 
 	if (!MLX5_CAP_GEN(dev, vport_group_manager))
 		return -EOPNOTSUPP;
@@ -1936,8 +1959,8 @@ static int mlx5_eswitch_inline_mode_get(const struct mlx5_eswitch *esw, u8 *mode
 
 query_vports:
 	mlx5_query_nic_vport_min_inline(dev, esw->first_host_vport, &prev_mlx5_mode);
-	mlx5_esw_for_each_host_func_vport(esw, vport, esw->esw_funcs.num_vfs) {
-		mlx5_query_nic_vport_min_inline(dev, vport, &mlx5_mode);
+	mlx5_esw_for_each_host_func_vport(esw, i, vport, esw->esw_funcs.num_vfs) {
+		mlx5_query_nic_vport_min_inline(dev, vport->vport, &mlx5_mode);
 		if (prev_mlx5_mode != mlx5_mode)
 			return -EINVAL;
 		prev_mlx5_mode = mlx5_mode;
@@ -2080,34 +2103,82 @@ static int esw_offloads_start(struct mlx5_eswitch *esw,
 	return err;
 }
 
-void esw_offloads_cleanup_reps(struct mlx5_eswitch *esw)
+static void mlx5_esw_offloads_rep_mark_set(struct mlx5_eswitch *esw,
+					   struct mlx5_eswitch_rep *rep,
+					   xa_mark_t mark)
 {
-	kfree(esw->offloads.vport_reps);
+	bool mark_set;
+
+	/* Copy the mark from vport to its rep */
+	mark_set = xa_get_mark(&esw->vports, rep->vport, mark);
+	if (mark_set)
+		xa_set_mark(&esw->offloads.vport_reps, rep->vport, mark);
 }
 
-int esw_offloads_init_reps(struct mlx5_eswitch *esw)
+static int mlx5_esw_offloads_rep_init(struct mlx5_eswitch *esw, const struct mlx5_vport *vport)
 {
-	int total_vports = esw->total_vports;
 	struct mlx5_eswitch_rep *rep;
-	int vport_index;
-	u8 rep_type;
+	int rep_type;
+	int err;
 
-	esw->offloads.vport_reps = kcalloc(total_vports,
-					   sizeof(struct mlx5_eswitch_rep),
-					   GFP_KERNEL);
-	if (!esw->offloads.vport_reps)
+	rep = kzalloc(sizeof(*rep), GFP_KERNEL);
+	if (!rep)
 		return -ENOMEM;
 
-	mlx5_esw_for_all_reps(esw, vport_index, rep) {
-		rep->vport = mlx5_eswitch_index_to_vport_num(esw, vport_index);
-		rep->vport_index = vport_index;
+	rep->vport = vport->vport;
+	rep->vport_index = vport->index;
+	for (rep_type = 0; rep_type < NUM_REP_TYPES; rep_type++)
+		atomic_set(&rep->rep_data[rep_type].state, REP_UNREGISTERED);
 
-		for (rep_type = 0; rep_type < NUM_REP_TYPES; rep_type++)
-			atomic_set(&rep->rep_data[rep_type].state,
-				   REP_UNREGISTERED);
-	}
+	err = xa_insert(&esw->offloads.vport_reps, rep->vport, rep, GFP_KERNEL);
+	if (err)
+		goto insert_err;
+
+	mlx5_esw_offloads_rep_mark_set(esw, rep, MLX5_ESW_VPT_HOST_FN);
+	mlx5_esw_offloads_rep_mark_set(esw, rep, MLX5_ESW_VPT_VF);
+	mlx5_esw_offloads_rep_mark_set(esw, rep, MLX5_ESW_VPT_SF);
+	return 0;
+
+insert_err:
+	kfree(rep);
+	return err;
+}
+
+static void mlx5_esw_offloads_rep_cleanup(struct mlx5_eswitch *esw,
+					  struct mlx5_eswitch_rep *rep)
+{
+	xa_erase(&esw->offloads.vport_reps, rep->vport);
+	kfree(rep);
+}
+
+void esw_offloads_cleanup_reps(struct mlx5_eswitch *esw)
+{
+	struct mlx5_eswitch_rep *rep;
+	unsigned long i;
 
+	mlx5_esw_for_each_rep(esw, i, rep)
+		mlx5_esw_offloads_rep_cleanup(esw, rep);
+	xa_destroy(&esw->offloads.vport_reps);
+}
+
+int esw_offloads_init_reps(struct mlx5_eswitch *esw)
+{
+	struct mlx5_vport *vport;
+	unsigned long i;
+	int err;
+
+	xa_init(&esw->offloads.vport_reps);
+
+	mlx5_esw_for_each_vport(esw, i, vport) {
+		err = mlx5_esw_offloads_rep_init(esw, vport);
+		if (err)
+			goto err;
+	}
 	return 0;
+
+err:
+	esw_offloads_cleanup_reps(esw);
+	return err;
 }
 
 static void __esw_offloads_unload_rep(struct mlx5_eswitch *esw,
@@ -2121,7 +2192,7 @@ static void __esw_offloads_unload_rep(struct mlx5_eswitch *esw,
 static void __unload_reps_sf_vport(struct mlx5_eswitch *esw, u8 rep_type)
 {
 	struct mlx5_eswitch_rep *rep;
-	int i;
+	unsigned long i;
 
 	mlx5_esw_for_each_sf_rep(esw, i, rep)
 		__esw_offloads_unload_rep(esw, rep, rep_type);
@@ -2130,11 +2201,11 @@ static void __unload_reps_sf_vport(struct mlx5_eswitch *esw, u8 rep_type)
 static void __unload_reps_all_vport(struct mlx5_eswitch *esw, u8 rep_type)
 {
 	struct mlx5_eswitch_rep *rep;
-	int i;
+	unsigned long i;
 
 	__unload_reps_sf_vport(esw, rep_type);
 
-	mlx5_esw_for_each_vf_rep_reverse(esw, i, rep, esw->esw_funcs.num_vfs)
+	mlx5_esw_for_each_vf_rep(esw, i, rep)
 		__esw_offloads_unload_rep(esw, rep, rep_type);
 
 	if (mlx5_ecpf_vport_exists(esw->dev)) {
@@ -2421,25 +2492,25 @@ static void esw_offloads_vport_metadata_cleanup(struct mlx5_eswitch *esw,
 static void esw_offloads_metadata_uninit(struct mlx5_eswitch *esw)
 {
 	struct mlx5_vport *vport;
-	int i;
+	unsigned long i;
 
 	if (!mlx5_eswitch_vport_match_metadata_enabled(esw))
 		return;
 
-	mlx5_esw_for_all_vports_reverse(esw, i, vport)
+	mlx5_esw_for_each_vport(esw, i, vport)
 		esw_offloads_vport_metadata_cleanup(esw, vport);
 }
 
 static int esw_offloads_metadata_init(struct mlx5_eswitch *esw)
 {
 	struct mlx5_vport *vport;
+	unsigned long i;
 	int err;
-	int i;
 
 	if (!mlx5_eswitch_vport_match_metadata_enabled(esw))
 		return 0;
 
-	mlx5_esw_for_all_vports(esw, i, vport) {
+	mlx5_esw_for_each_vport(esw, i, vport) {
 		err = esw_offloads_vport_metadata_setup(esw, vport);
 		if (err)
 			goto metadata_err;
@@ -2680,7 +2751,8 @@ int esw_offloads_enable(struct mlx5_eswitch *esw)
 {
 	struct mapping_ctx *reg_c0_obj_pool;
 	struct mlx5_vport *vport;
-	int err, i;
+	unsigned long i;
+	int err;
 
 	if (MLX5_CAP_ESW_FLOWTABLE_FDB(esw->dev, reformat) &&
 	    MLX5_CAP_ESW_FLOWTABLE_FDB(esw->dev, decap))
@@ -2926,13 +2998,44 @@ int mlx5_devlink_eswitch_mode_get(struct devlink *devlink, u16 *mode)
 	return err;
 }
 
+static int mlx5_esw_vports_inline_set(struct mlx5_eswitch *esw, u8 mlx5_mode,
+				      struct netlink_ext_ack *extack)
+{
+	struct mlx5_core_dev *dev = esw->dev;
+	struct mlx5_vport *vport;
+	u16 err_vport_num = 0;
+	unsigned long i;
+	int err = 0;
+
+	mlx5_esw_for_each_host_func_vport(esw, i, vport, esw->esw_funcs.num_vfs) {
+		err = mlx5_modify_nic_vport_min_inline(dev, vport->vport, mlx5_mode);
+		if (err) {
+			err_vport_num = vport->vport;
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Failed to set min inline on vport");
+			goto revert_inline_mode;
+		}
+	}
+	return 0;
+
+revert_inline_mode:
+	mlx5_esw_for_each_host_func_vport(esw, i, vport, esw->esw_funcs.num_vfs) {
+		if (vport->vport == err_vport_num)
+			break;
+		mlx5_modify_nic_vport_min_inline(dev,
+						 vport->vport,
+						 esw->offloads.inline_mode);
+	}
+	return err;
+}
+
 int mlx5_devlink_eswitch_inline_mode_set(struct devlink *devlink, u8 mode,
 					 struct netlink_ext_ack *extack)
 {
 	struct mlx5_core_dev *dev = devlink_priv(devlink);
-	int err, vport, num_vport;
 	struct mlx5_eswitch *esw;
 	u8 mlx5_mode;
+	int err;
 
 	esw = mlx5_devlink_eswitch_get(devlink);
 	if (IS_ERR(esw))
@@ -2967,25 +3070,14 @@ int mlx5_devlink_eswitch_inline_mode_set(struct devlink *devlink, u8 mode,
 	if (err)
 		goto out;
 
-	mlx5_esw_for_each_host_func_vport(esw, vport, esw->esw_funcs.num_vfs) {
-		err = mlx5_modify_nic_vport_min_inline(dev, vport, mlx5_mode);
-		if (err) {
-			NL_SET_ERR_MSG_MOD(extack,
-					   "Failed to set min inline on vport");
-			goto revert_inline_mode;
-		}
-	}
+	err = mlx5_esw_vports_inline_set(esw, mlx5_mode, extack);
+	if (err)
+		goto out;
 
 	esw->offloads.inline_mode = mlx5_mode;
 	up_write(&esw->mode_lock);
 	return 0;
 
-revert_inline_mode:
-	num_vport = --vport;
-	mlx5_esw_for_each_host_func_vport_reverse(esw, vport, num_vport)
-		mlx5_modify_nic_vport_min_inline(dev,
-						 vport,
-						 esw->offloads.inline_mode);
 out:
 	up_write(&esw->mode_lock);
 	return err;
@@ -3116,11 +3208,11 @@ void mlx5_eswitch_register_vport_reps(struct mlx5_eswitch *esw,
 {
 	struct mlx5_eswitch_rep_data *rep_data;
 	struct mlx5_eswitch_rep *rep;
-	int i;
+	unsigned long i;
 
 	esw->offloads.rep_ops[rep_type] = ops;
-	mlx5_esw_for_all_reps(esw, i, rep) {
-		if (likely(mlx5_eswitch_vport_has_rep(esw, i))) {
+	mlx5_esw_for_each_rep(esw, i, rep) {
+		if (likely(mlx5_eswitch_vport_has_rep(esw, rep->vport))) {
 			rep->esw = esw;
 			rep_data = &rep->rep_data[rep_type];
 			atomic_set(&rep_data->state, REP_REGISTERED);
@@ -3132,12 +3224,12 @@ EXPORT_SYMBOL(mlx5_eswitch_register_vport_reps);
 void mlx5_eswitch_unregister_vport_reps(struct mlx5_eswitch *esw, u8 rep_type)
 {
 	struct mlx5_eswitch_rep *rep;
-	int i;
+	unsigned long i;
 
 	if (esw->mode == MLX5_ESWITCH_OFFLOADS)
 		__unload_reps_all_vport(esw, rep_type);
 
-	mlx5_esw_for_all_reps(esw, i, rep)
+	mlx5_esw_for_each_rep(esw, i, rep)
 		atomic_set(&rep->rep_data[rep_type].state, REP_UNREGISTERED);
 }
 EXPORT_SYMBOL(mlx5_eswitch_unregister_vport_reps);
@@ -3178,12 +3270,6 @@ struct mlx5_eswitch_rep *mlx5_eswitch_vport_rep(struct mlx5_eswitch *esw,
 }
 EXPORT_SYMBOL(mlx5_eswitch_vport_rep);
 
-bool mlx5_eswitch_is_vf_vport(const struct mlx5_eswitch *esw, u16 vport_num)
-{
-	return vport_num >= MLX5_VPORT_FIRST_VF &&
-	       vport_num <= esw->dev->priv.sriov.max_vfs;
-}
-
 bool mlx5_eswitch_reg_c1_loopback_enabled(const struct mlx5_eswitch *esw)
 {
 	return !!(esw->flags & MLX5_ESWITCH_REG_C1_LOOPBACK_ENABLED);
-- 
2.30.2

