Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D2D252B30C
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 09:10:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231669AbiERGup (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 02:50:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231594AbiERGuO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 02:50:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D054C23179
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 23:49:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4BB0E60BD6
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 06:49:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87B83C385A5;
        Wed, 18 May 2022 06:49:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652856597;
        bh=fPTy/opQtABoH/pbgnuBNDkRkWTPzt6XdIJtY+Z0Nl0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EhANoMU5hYZIU4oYqYtC/N7O3JHDjHlp4VbTXjkSANkUe9Qf2gBjHRZMOCioEbi7l
         dLb1GdT99Wq8YTijGcZlComSO3g2wlGpG5kBRGjHbWcxwN6vVjDhjENo/4Enz00XCZ
         7H9qthX+6gHgVvrSnvs/BxEvtrrKqDOvB2UvbaWHysFfD7KDV6S38EanIiWJR7VgjS
         xQjedYM07atj+9vcGUIyCxPpuAlfaJb0QWtjP+Z+ZIp0IKQacsS3gB4i1a+GFei14A
         JwZgcRtU9ggBQihh0b0V21nyHPukjAzJYLM4pKpci0qumLGCHMrcy7qDsGxMo0uSo1
         723aeM4hLOUtg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Eli Cohen <elic@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 16/16] net/mlx5: Support multiport eswitch mode
Date:   Tue, 17 May 2022 23:49:38 -0700
Message-Id: <20220518064938.128220-17-saeed@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220518064938.128220-1-saeed@kernel.org>
References: <20220518064938.128220-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eli Cohen <elic@nvidia.com>

Multiport eswitch mode is a LAG mode that allows to add rules that
forward traffic to a specific physical port without being affected by LAG
affinity configuration.

This mode of operation is mutual exclusive with the other LAG modes used
by multipath and bonding.

To make the transition between the modes, we maintain a counter on the
number of rules specifying one of the uplink representors as the target
of mirred egress redirect action.

An example of such rule would be:

$ tc filter add dev enp8s0f0_0 prot all root flower dst_mac \
  00:11:22:33:44:55 action mirred egress redirect dev enp8s0f0

If the reference count just grows to one and LAG is not in use, we
create the LAG in multiport eswitch mode. Other mode changes are not
allowed while in this mode. When the reference count reaches zero, we
destroy the LAG and let other modes be used if needed.

logic also changed such that if forwarding to some uplink destination
cannot be guaranteed, we fail the operation so the rule will eventually
be in software and not in hardware.

Signed-off-by: Eli Cohen <elic@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/Makefile  |   2 +-
 .../mellanox/mlx5/core/en/tc/act/mirred.c     |  14 +++
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   |  28 ++++-
 .../net/ethernet/mellanox/mlx5/core/en_tc.h   |   7 ++
 .../mellanox/mlx5/core/eswitch_offloads.c     |   3 +
 .../ethernet/mellanox/mlx5/core/lag/debugfs.c |  17 +--
 .../net/ethernet/mellanox/mlx5/core/lag/lag.c |  86 ++++++++++-----
 .../net/ethernet/mellanox/mlx5/core/lag/lag.h |  10 +-
 .../ethernet/mellanox/mlx5/core/lag/mpesw.c   | 101 ++++++++++++++++++
 .../ethernet/mellanox/mlx5/core/lag/mpesw.h   |  26 +++++
 include/linux/mlx5/mlx5_ifc.h                 |   5 +-
 11 files changed, 259 insertions(+), 40 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.h

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
index 7895ed7cc285..9ea867a45764 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -39,7 +39,7 @@ mlx5_core-$(CONFIG_MLX5_CORE_EN_DCB) += en_dcbnl.o en/port_buffer.o
 mlx5_core-$(CONFIG_PCI_HYPERV_INTERFACE) += en/hv_vhca_stats.o
 mlx5_core-$(CONFIG_MLX5_ESWITCH)     += lag/mp.o lag/port_sel.o lib/geneve.o lib/port_tun.o \
 					en_rep.o en/rep/bond.o en/mod_hdr.o \
-					en/mapping.o
+					en/mapping.o lag/mpesw.o
 mlx5_core-$(CONFIG_MLX5_CLS_ACT)     += en_tc.o en/rep/tc.o en/rep/neigh.o \
 					lib/fs_chains.o en/tc_tun.o \
 					esw/indir_table.o en/tc_tun_encap.o \
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/mirred.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/mirred.c
index 2b002c6a2e73..4ac7de3f6afa 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/mirred.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/mirred.c
@@ -10,6 +10,7 @@
 #include "en/tc_tun_encap.h"
 #include "en/tc_priv.h"
 #include "en_rep.h"
+#include "lag/lag.h"
 
 static bool
 same_vf_reps(struct mlx5e_priv *priv, struct net_device *out_dev)
@@ -215,6 +216,7 @@ parse_mirred(struct mlx5e_tc_act_parse_state *parse_state,
 	struct net_device *uplink_dev;
 	struct mlx5e_priv *out_priv;
 	struct mlx5_eswitch *esw;
+	bool is_uplink_rep;
 	int *ifindexes;
 	int if_count;
 	int err;
@@ -229,6 +231,10 @@ parse_mirred(struct mlx5e_tc_act_parse_state *parse_state,
 
 	parse_state->ifindexes[if_count] = out_dev->ifindex;
 	parse_state->if_count++;
+	is_uplink_rep = mlx5e_eswitch_uplink_rep(out_dev);
+	err = mlx5_lag_do_mirred(priv->mdev, out_dev);
+	if (err)
+		return err;
 
 	out_dev = get_fdb_out_dev(uplink_dev, out_dev);
 	if (!out_dev)
@@ -268,6 +274,14 @@ parse_mirred(struct mlx5e_tc_act_parse_state *parse_state,
 	rpriv = out_priv->ppriv;
 	esw_attr->dests[esw_attr->out_count].rep = rpriv->rep;
 	esw_attr->dests[esw_attr->out_count].mdev = out_priv->mdev;
+
+	/* If output device is bond master then rules are not explicit
+	 * so we don't attempt to count them.
+	 */
+	if (is_uplink_rep && MLX5_CAP_PORT_SELECTION(priv->mdev, port_select_flow_table) &&
+	    MLX5_CAP_GEN(priv->mdev, create_lag_when_not_master_up))
+		attr->lag.count = true;
+
 	esw_attr->out_count++;
 
 	return 0;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index ac0f73074f7a..49dea02a12d2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1740,6 +1740,9 @@ static void mlx5e_tc_del_fdb_flow(struct mlx5e_priv *priv,
 
 	free_flow_post_acts(flow);
 
+	if (flow->attr->lag.count)
+		mlx5_lag_del_mpesw_rule(esw->dev);
+
 	kvfree(attr->esw_attr->rx_tun_attr);
 	kvfree(attr->parse_attr);
 	kfree(flow->attr);
@@ -3788,12 +3791,25 @@ static bool is_lag_dev(struct mlx5e_priv *priv,
 		 same_hw_reps(priv, peer_netdev));
 }
 
+static bool is_multiport_eligible(struct mlx5e_priv *priv, struct net_device *out_dev)
+{
+	if (mlx5e_eswitch_uplink_rep(out_dev) &&
+	    MLX5_CAP_PORT_SELECTION(priv->mdev, port_select_flow_table) &&
+	    MLX5_CAP_GEN(priv->mdev, create_lag_when_not_master_up))
+		return true;
+
+	return false;
+}
+
 bool mlx5e_is_valid_eswitch_fwd_dev(struct mlx5e_priv *priv,
 				    struct net_device *out_dev)
 {
 	if (is_merged_eswitch_vfs(priv, out_dev))
 		return true;
 
+	if (is_multiport_eligible(priv, out_dev))
+		return true;
+
 	if (is_lag_dev(priv, out_dev))
 		return true;
 
@@ -4050,6 +4066,7 @@ __mlx5e_add_fdb_flow(struct mlx5e_priv *priv,
 		     struct mlx5_core_dev *in_mdev)
 {
 	struct flow_rule *rule = flow_cls_offload_flow_rule(f);
+	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
 	struct netlink_ext_ack *extack = f->common.extack;
 	struct mlx5e_tc_flow_parse_attr *parse_attr;
 	struct mlx5e_tc_flow *flow;
@@ -4085,17 +4102,26 @@ __mlx5e_add_fdb_flow(struct mlx5e_priv *priv,
 	if (err)
 		goto err_free;
 
+	if (flow->attr->lag.count) {
+		err = mlx5_lag_add_mpesw_rule(esw->dev);
+		if (err)
+			goto err_free;
+	}
+
 	err = mlx5e_tc_add_fdb_flow(priv, flow, extack);
 	complete_all(&flow->init_done);
 	if (err) {
 		if (!(err == -ENETUNREACH && mlx5_lag_is_multipath(in_mdev)))
-			goto err_free;
+			goto err_lag;
 
 		add_unready_flow(flow);
 	}
 
 	return flow;
 
+err_lag:
+	if (flow->attr->lag.count)
+		mlx5_lag_del_mpesw_rule(esw->dev);
 err_free:
 	mlx5e_flow_put(priv, flow);
 out:
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
index a80b00946f1b..e2a1250aeca1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
@@ -85,6 +85,13 @@ struct mlx5_flow_attr {
 	u32 flags;
 	struct list_head list;
 	struct mlx5e_post_act_handle *post_act_handle;
+	struct {
+		/* Indicate whether the parsed flow should be counted for lag mode decision
+		 * making
+		 */
+		bool count;
+	} lag;
+	/* keep this union last */
 	union {
 		struct mlx5_esw_flow_attr esw_attr[0];
 		struct mlx5_nic_flow_attr nic_attr[0];
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 3b151332e2f8..217cac29057f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -49,6 +49,7 @@
 #include "en_tc.h"
 #include "en/mapping.h"
 #include "devlink.h"
+#include "lag/lag.h"
 
 #define mlx5_esw_for_each_rep(esw, i, rep) \
 	xa_for_each(&((esw)->offloads.vport_reps), i, rep)
@@ -418,6 +419,8 @@ esw_setup_vport_dest(struct mlx5_flow_destination *dest, struct mlx5_flow_act *f
 		dest[dest_idx].vport.vhca_id =
 			MLX5_CAP_GEN(esw_attr->dests[attr_idx].mdev, vhca_id);
 		dest[dest_idx].vport.flags |= MLX5_FLOW_DEST_VPORT_VHCA_ID;
+		if (mlx5_lag_mpesw_is_activated(esw->dev))
+			dest[dest_idx].type = MLX5_FLOW_DESTINATION_TYPE_UPLINK;
 	}
 	if (esw_attr->dests[attr_idx].flags & MLX5_ESW_DEST_ENCAP) {
 		if (pkt_reformat) {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/debugfs.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/debugfs.c
index 6e7001c0cfd4..15e41dc84d53 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/debugfs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/debugfs.c
@@ -5,12 +5,13 @@
 
 static char *get_str_mode_type(struct mlx5_lag *ldev)
 {
-	if (ldev->mode == MLX5_LAG_MODE_ROCE)
-		return "roce";
-	if (ldev->mode == MLX5_LAG_MODE_SRIOV)
-		return "switchdev";
-	if (ldev->mode == MLX5_LAG_MODE_MULTIPATH)
-		return "multipath";
+	switch (ldev->mode) {
+	case MLX5_LAG_MODE_ROCE: return "roce";
+	case MLX5_LAG_MODE_SRIOV: return "switchdev";
+	case MLX5_LAG_MODE_MULTIPATH: return "multipath";
+	case MLX5_LAG_MODE_MPESW: return "multiport_eswitch";
+	default: return "invalid";
+	}
 
 	return NULL;
 }
@@ -43,11 +44,11 @@ static int port_sel_mode_show(struct seq_file *file, void *priv)
 	ldev = dev->priv.lag;
 	mutex_lock(&ldev->lock);
 	if (__mlx5_lag_is_active(ldev))
-		mode = get_str_port_sel_mode(ldev->mode_flags);
+		mode = mlx5_get_str_port_sel_mode(ldev);
 	else
 		ret = -EINVAL;
 	mutex_unlock(&ldev->lock);
-	if (ret || !mode)
+	if (ret)
 		return ret;
 
 	seq_printf(file, "%s\n", mode);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
index 5c3900586d23..552b6e26e701 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
@@ -41,6 +41,7 @@
 #include "esw/acl/ofld.h"
 #include "lag.h"
 #include "mp.h"
+#include "mpesw.h"
 
 enum {
 	MLX5_LAG_EGRESS_PORT_1 = 1,
@@ -58,6 +59,9 @@ static int get_port_sel_mode(enum mlx5_lag_mode mode, unsigned long flags)
 	if (test_bit(MLX5_LAG_MODE_FLAG_HASH_BASED, &flags))
 		return MLX5_LAG_PORT_SELECT_MODE_PORT_SELECT_FT;
 
+	if (mode == MLX5_LAG_MODE_MPESW)
+		return MLX5_LAG_PORT_SELECT_MODE_PORT_SELECT_MPESW;
+
 	return MLX5_LAG_PORT_SELECT_MODE_QUEUE_AFFINITY;
 }
 
@@ -196,7 +200,8 @@ static void mlx5_ldev_free(struct kref *ref)
 	if (ldev->nb.notifier_call)
 		unregister_netdevice_notifier_net(&init_net, &ldev->nb);
 	mlx5_lag_mp_cleanup(ldev);
-	cancel_delayed_work_sync(&ldev->bond_work);
+	mlx5_lag_mpesw_cleanup(ldev);
+	cancel_work_sync(&ldev->mpesw_work);
 	destroy_workqueue(ldev->wq);
 	mutex_destroy(&ldev->lock);
 	kfree(ldev);
@@ -242,6 +247,8 @@ static struct mlx5_lag *mlx5_lag_dev_alloc(struct mlx5_core_dev *dev)
 	if (err)
 		mlx5_core_err(dev, "Failed to init multipath lag err=%d\n",
 			      err);
+
+	mlx5_lag_mpesw_init(ldev);
 	ldev->ports = MLX5_CAP_GEN(dev, num_lag_ports);
 	ldev->buckets = 1;
 
@@ -442,16 +449,19 @@ static int mlx5_lag_set_port_sel_mode_roce(struct mlx5_lag *ldev,
 	return 0;
 }
 
-static int mlx5_lag_set_port_sel_mode_offloads(struct mlx5_lag *ldev,
-					       struct lag_tracker *tracker, unsigned long *flags)
+static void mlx5_lag_set_port_sel_mode_offloads(struct mlx5_lag *ldev,
+						struct lag_tracker *tracker,
+						enum mlx5_lag_mode mode,
+						unsigned long *flags)
 {
 	struct lag_func *dev0 = &ldev->pf[MLX5_LAG_P1];
 
+	if (mode == MLX5_LAG_MODE_MPESW)
+		return;
+
 	if (MLX5_CAP_PORT_SELECTION(dev0->dev, port_select_flow_table) &&
 	    tracker->tx_type == NETDEV_LAG_TX_TYPE_HASH)
 		set_bit(MLX5_LAG_MODE_FLAG_HASH_BASED, flags);
-
-	return 0;
 }
 
 static int mlx5_lag_set_flags(struct mlx5_lag *ldev, enum mlx5_lag_mode mode,
@@ -467,14 +477,20 @@ static int mlx5_lag_set_flags(struct mlx5_lag *ldev, enum mlx5_lag_mode mode,
 	if (roce_lag)
 		return mlx5_lag_set_port_sel_mode_roce(ldev, flags);
 
-	return mlx5_lag_set_port_sel_mode_offloads(ldev, tracker, flags);
+	mlx5_lag_set_port_sel_mode_offloads(ldev, tracker, mode, flags);
+	return 0;
 }
 
-char *get_str_port_sel_mode(unsigned long flags)
+char *mlx5_get_str_port_sel_mode(struct mlx5_lag *ldev)
 {
-	if (test_bit(MLX5_LAG_MODE_FLAG_HASH_BASED, &flags))
-		return "hash";
-	return "queue_affinity";
+	int port_sel_mode = get_port_sel_mode(ldev->mode, ldev->mode_flags);
+
+	switch (port_sel_mode) {
+	case MLX5_LAG_PORT_SELECT_MODE_QUEUE_AFFINITY: return "queue_affinity";
+	case MLX5_LAG_PORT_SELECT_MODE_PORT_SELECT_FT: return "hash";
+	case MLX5_LAG_PORT_SELECT_MODE_PORT_SELECT_MPESW: return "mpesw";
+	default: return "invalid";
+	}
 }
 
 static int mlx5_create_lag(struct mlx5_lag *ldev,
@@ -488,9 +504,10 @@ static int mlx5_create_lag(struct mlx5_lag *ldev,
 	u32 in[MLX5_ST_SZ_DW(destroy_lag_in)] = {};
 	int err;
 
-	mlx5_lag_print_mapping(dev0, ldev, tracker, flags);
+	if (tracker)
+		mlx5_lag_print_mapping(dev0, ldev, tracker, flags);
 	mlx5_core_info(dev0, "shared_fdb:%d mode:%s\n",
-		       shared_fdb, get_str_port_sel_mode(flags));
+		       shared_fdb, mlx5_get_str_port_sel_mode(ldev));
 
 	err = mlx5_cmd_create_lag(dev0, ldev->v2p_map, mode, flags);
 	if (err) {
@@ -526,22 +543,24 @@ int mlx5_activate_lag(struct mlx5_lag *ldev,
 {
 	bool roce_lag = mode == MLX5_LAG_MODE_ROCE;
 	struct mlx5_core_dev *dev0 = ldev->pf[MLX5_LAG_P1].dev;
-	unsigned long flags;
+	unsigned long flags = 0;
 	int err;
 
 	err = mlx5_lag_set_flags(ldev, mode, tracker, shared_fdb, &flags);
 	if (err)
 		return err;
 
-	mlx5_infer_tx_affinity_mapping(tracker, ldev->ports, ldev->buckets, ldev->v2p_map);
-	if (test_bit(MLX5_LAG_MODE_FLAG_HASH_BASED, &flags)) {
-		err = mlx5_lag_port_sel_create(ldev, tracker->hash_type,
-					       ldev->v2p_map);
-		if (err) {
-			mlx5_core_err(dev0,
-				      "Failed to create LAG port selection(%d)\n",
-				      err);
-			return err;
+	if (mode != MLX5_LAG_MODE_MPESW) {
+		mlx5_infer_tx_affinity_mapping(tracker, ldev->ports, ldev->buckets, ldev->v2p_map);
+		if (test_bit(MLX5_LAG_MODE_FLAG_HASH_BASED, &flags)) {
+			err = mlx5_lag_port_sel_create(ldev, tracker->hash_type,
+						       ldev->v2p_map);
+			if (err) {
+				mlx5_core_err(dev0,
+					      "Failed to create LAG port selection(%d)\n",
+					      err);
+				return err;
+			}
 		}
 	}
 
@@ -559,7 +578,7 @@ int mlx5_activate_lag(struct mlx5_lag *ldev,
 		return err;
 	}
 
-	if (tracker->tx_type == NETDEV_LAG_TX_TYPE_ACTIVEBACKUP &&
+	if (tracker && tracker->tx_type == NETDEV_LAG_TX_TYPE_ACTIVEBACKUP &&
 	    !roce_lag)
 		mlx5_lag_drop_rule_setup(ldev, tracker);
 
@@ -675,7 +694,7 @@ static void mlx5_lag_remove_devices(struct mlx5_lag *ldev)
 	}
 }
 
-static void mlx5_disable_lag(struct mlx5_lag *ldev)
+void mlx5_disable_lag(struct mlx5_lag *ldev)
 {
 	bool shared_fdb = test_bit(MLX5_LAG_MODE_FLAG_SHARED_FDB, &ldev->mode_flags);
 	struct mlx5_core_dev *dev0 = ldev->pf[MLX5_LAG_P1].dev;
@@ -712,7 +731,7 @@ static void mlx5_disable_lag(struct mlx5_lag *ldev)
 	}
 }
 
-static bool mlx5_shared_fdb_supported(struct mlx5_lag *ldev)
+bool mlx5_shared_fdb_supported(struct mlx5_lag *ldev)
 {
 	struct mlx5_core_dev *dev0 = ldev->pf[MLX5_LAG_P1].dev;
 	struct mlx5_core_dev *dev1 = ldev->pf[MLX5_LAG_P2].dev;
@@ -748,6 +767,18 @@ static bool mlx5_lag_is_roce_lag(struct mlx5_lag *ldev)
 	return roce_lag;
 }
 
+static bool mlx5_lag_should_modify_lag(struct mlx5_lag *ldev, bool do_bond)
+{
+	return do_bond && __mlx5_lag_is_active(ldev) &&
+	       ldev->mode != MLX5_LAG_MODE_MPESW;
+}
+
+static bool mlx5_lag_should_disable_lag(struct mlx5_lag *ldev, bool do_bond)
+{
+	return !do_bond && __mlx5_lag_is_active(ldev) &&
+	       ldev->mode != MLX5_LAG_MODE_MPESW;
+}
+
 static void mlx5_do_bond(struct mlx5_lag *ldev)
 {
 	struct mlx5_core_dev *dev0 = ldev->pf[MLX5_LAG_P1].dev;
@@ -810,9 +841,9 @@ static void mlx5_do_bond(struct mlx5_lag *ldev)
 				return;
 			}
 		}
-	} else if (do_bond && __mlx5_lag_is_active(ldev)) {
+	} else if (mlx5_lag_should_modify_lag(ldev, do_bond)) {
 		mlx5_modify_lag(ldev, &tracker);
-	} else if (!do_bond && __mlx5_lag_is_active(ldev)) {
+	} else if (mlx5_lag_should_disable_lag(ldev, do_bond)) {
 		mlx5_disable_lag(ldev);
 	}
 }
@@ -986,6 +1017,7 @@ static int mlx5_handle_changeinfodata_event(struct mlx5_lag *ldev,
 	return 1;
 }
 
+/* this handler is always registered to netdev events */
 static int mlx5_lag_netdev_event(struct notifier_block *this,
 				 unsigned long event, void *ptr)
 {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h
index 244b548e1420..72f70fad4641 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h
@@ -10,6 +10,7 @@
 #include "mlx5_core.h"
 #include "mp.h"
 #include "port_sel.h"
+#include "mpesw.h"
 
 enum {
 	MLX5_LAG_P1,
@@ -30,6 +31,7 @@ enum mlx5_lag_mode {
 	MLX5_LAG_MODE_ROCE,
 	MLX5_LAG_MODE_SRIOV,
 	MLX5_LAG_MODE_MULTIPATH,
+	MLX5_LAG_MODE_MPESW,
 };
 
 struct lag_func {
@@ -63,11 +65,13 @@ struct mlx5_lag {
 	struct lag_tracker        tracker;
 	struct workqueue_struct   *wq;
 	struct delayed_work       bond_work;
+	struct work_struct	  mpesw_work;
 	struct notifier_block     nb;
 	struct lag_mp             lag_mp;
 	struct mlx5_lag_port_sel  port_sel;
 	/* Protect lag fields/state changes */
 	struct mutex		  lock;
+	struct lag_mpesw	  lag_mpesw;
 };
 
 static inline struct mlx5_lag *
@@ -96,12 +100,16 @@ int mlx5_activate_lag(struct mlx5_lag *ldev,
 		      bool shared_fdb);
 int mlx5_lag_dev_get_netdev_idx(struct mlx5_lag *ldev,
 				struct net_device *ndev);
+bool mlx5_shared_fdb_supported(struct mlx5_lag *ldev);
+void mlx5_lag_del_mpesw_rule(struct mlx5_core_dev *dev);
+int mlx5_lag_add_mpesw_rule(struct mlx5_core_dev *dev);
 
-char *get_str_port_sel_mode(unsigned long flags);
+char *mlx5_get_str_port_sel_mode(struct mlx5_lag *ldev);
 void mlx5_infer_tx_enabled(struct lag_tracker *tracker, u8 num_ports,
 			   u8 *ports, int *num_enabled);
 
 void mlx5_ldev_add_debugfs(struct mlx5_core_dev *dev);
 void mlx5_ldev_remove_debugfs(struct dentry *dbg);
+void mlx5_disable_lag(struct mlx5_lag *ldev);
 
 #endif /* __MLX5_LAG_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
new file mode 100644
index 000000000000..ee4b25a50315
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
@@ -0,0 +1,101 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/* Copyright (c) 2022, NVIDIA CORPORATION & AFFILIATES. All rights reserved. */
+
+#include <linux/netdevice.h>
+#include <net/nexthop.h>
+#include "lag/lag.h"
+#include "eswitch.h"
+#include "lib/mlx5.h"
+
+void mlx5_mpesw_work(struct work_struct *work)
+{
+	struct mlx5_lag *ldev = container_of(work, struct mlx5_lag, mpesw_work);
+
+	mutex_lock(&ldev->lock);
+	mlx5_disable_lag(ldev);
+	mutex_unlock(&ldev->lock);
+}
+
+static void mlx5_lag_disable_mpesw(struct mlx5_core_dev *dev)
+{
+	struct mlx5_lag *ldev = dev->priv.lag;
+
+	if (!queue_work(ldev->wq, &ldev->mpesw_work))
+		mlx5_core_warn(dev, "failed to queue work\n");
+}
+
+void mlx5_lag_del_mpesw_rule(struct mlx5_core_dev *dev)
+{
+	struct mlx5_lag *ldev = dev->priv.lag;
+
+	if (!ldev)
+		return;
+
+	mutex_lock(&ldev->lock);
+	if (!atomic_dec_return(&ldev->lag_mpesw.mpesw_rule_count) &&
+	    ldev->mode == MLX5_LAG_MODE_MPESW)
+		mlx5_lag_disable_mpesw(dev);
+	mutex_unlock(&ldev->lock);
+}
+
+int mlx5_lag_add_mpesw_rule(struct mlx5_core_dev *dev)
+{
+	struct mlx5_lag *ldev = dev->priv.lag;
+	bool shared_fdb;
+	int err = 0;
+
+	if (!ldev)
+		return 0;
+
+	mutex_lock(&ldev->lock);
+	if (atomic_add_return(1, &ldev->lag_mpesw.mpesw_rule_count) != 1)
+		goto out;
+
+	if (ldev->mode != MLX5_LAG_MODE_NONE) {
+		err = -EINVAL;
+		goto out;
+	}
+	shared_fdb = mlx5_shared_fdb_supported(ldev);
+	err = mlx5_activate_lag(ldev, NULL, MLX5_LAG_MODE_MPESW, shared_fdb);
+	if (err)
+		mlx5_core_warn(dev, "Failed to create LAG in MPESW mode (%d)\n", err);
+
+out:
+	mutex_unlock(&ldev->lock);
+	return err;
+}
+
+int mlx5_lag_do_mirred(struct mlx5_core_dev *mdev, struct net_device *out_dev)
+{
+	struct mlx5_lag *ldev = mdev->priv.lag;
+
+	if (!netif_is_bond_master(out_dev) || !ldev)
+		return 0;
+
+	mutex_lock(&ldev->lock);
+	if (ldev->mode == MLX5_LAG_MODE_MPESW) {
+		mutex_unlock(&ldev->lock);
+		return -EOPNOTSUPP;
+	}
+	mutex_unlock(&ldev->lock);
+	return 0;
+}
+
+bool mlx5_lag_mpesw_is_activated(struct mlx5_core_dev *dev)
+{
+	bool ret;
+
+	ret = dev->priv.lag && dev->priv.lag->mode == MLX5_LAG_MODE_MPESW;
+	return ret;
+}
+
+void mlx5_lag_mpesw_init(struct mlx5_lag *ldev)
+{
+	INIT_WORK(&ldev->mpesw_work, mlx5_mpesw_work);
+	atomic_set(&ldev->lag_mpesw.mpesw_rule_count, 0);
+}
+
+void mlx5_lag_mpesw_cleanup(struct mlx5_lag *ldev)
+{
+	cancel_delayed_work_sync(&ldev->bond_work);
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.h b/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.h
new file mode 100644
index 000000000000..d39a02280e29
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.h
@@ -0,0 +1,26 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/* Copyright (c) 2022, NVIDIA CORPORATION & AFFILIATES. All rights reserved. */
+
+#ifndef __MLX5_LAG_MPESW_H__
+#define __MLX5_LAG_MPESW_H__
+
+#include "lag.h"
+#include "mlx5_core.h"
+
+struct lag_mpesw {
+	struct work_struct mpesw_work;
+	atomic_t mpesw_rule_count;
+};
+
+void mlx5_mpesw_work(struct work_struct *work);
+int mlx5_lag_do_mirred(struct mlx5_core_dev *mdev, struct net_device *out_dev);
+bool mlx5_lag_mpesw_is_activated(struct mlx5_core_dev *dev);
+#if IS_ENABLED(CONFIG_MLX5_ESWITCH)
+void mlx5_lag_mpesw_init(struct mlx5_lag *ldev);
+void mlx5_lag_mpesw_cleanup(struct mlx5_lag *ldev);
+#else
+void mlx5_lag_mpesw_init(struct mlx5_lag *ldev) {}
+void mlx5_lag_mpesw_cleanup(struct mlx5_lag *ldev) {}
+#endif
+
+#endif /* __MLX5_LAG_MPESW_H__ */
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 7bab3e51c61e..78b3d3465dd7 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -1359,7 +1359,7 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 	u8         vhca_resource_manager[0x1];
 
 	u8         hca_cap_2[0x1];
-	u8         reserved_at_21[0x1];
+	u8         create_lag_when_not_master_up[0x1];
 	u8         dtor[0x1];
 	u8         event_on_vhca_state_teardown_request[0x1];
 	u8         event_on_vhca_state_in_use[0x1];
@@ -10816,7 +10816,8 @@ struct mlx5_ifc_dcbx_param_bits {
 
 enum {
 	MLX5_LAG_PORT_SELECT_MODE_QUEUE_AFFINITY = 0,
-	MLX5_LAG_PORT_SELECT_MODE_PORT_SELECT_FT,
+	MLX5_LAG_PORT_SELECT_MODE_PORT_SELECT_FT = 1,
+	MLX5_LAG_PORT_SELECT_MODE_PORT_SELECT_MPESW = 2,
 };
 
 struct mlx5_ifc_lagc_bits {
-- 
2.36.1

