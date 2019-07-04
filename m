Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D8AC5FED1
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 01:49:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727826AbfGDXts (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 19:49:48 -0400
Received: from mail.us.es ([193.147.175.20]:33814 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727790AbfGDXtq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Jul 2019 19:49:46 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 8CCC580D0F
        for <netdev@vger.kernel.org>; Fri,  5 Jul 2019 01:49:37 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6351D1021A6
        for <netdev@vger.kernel.org>; Fri,  5 Jul 2019 01:49:37 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 586FFA0AAC; Fri,  5 Jul 2019 01:49:37 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-106.5 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_SBL,URIBL_SBL_A,USER_IN_WHITELIST autolearn=disabled
        version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 254F0DA4D0;
        Fri,  5 Jul 2019 01:49:28 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 05 Jul 2019 01:49:28 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id E66354265A31;
        Fri,  5 Jul 2019 01:49:26 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netdev@vger.kernel.org
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        thomas.lendacky@amd.com, f.fainelli@gmail.com,
        ariel.elior@cavium.com, michael.chan@broadcom.com,
        madalin.bucur@nxp.com, yisen.zhuang@huawei.com,
        salil.mehta@huawei.com, jeffrey.t.kirsher@intel.com,
        tariqt@mellanox.com, saeedm@mellanox.com, jiri@mellanox.com,
        idosch@mellanox.com, jakub.kicinski@netronome.com,
        peppe.cavallaro@st.com, grygorii.strashko@ti.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, linux-net-drivers@solarflare.com,
        ogerlitz@mellanox.com, Manish.Chopra@cavium.com,
        marcelo.leitner@gmail.com, mkubecek@suse.cz,
        venkatkumar.duvvuru@broadcom.com, maxime.chevallier@bootlin.com,
        cphealy@gmail.com
Subject: [PATCH 12/15 net-next,v2] net: flow_offload: make flow block callback list per-driver
Date:   Fri,  5 Jul 2019 01:48:40 +0200
Message-Id: <20190704234843.6601-13-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190704234843.6601-1-pablo@netfilter.org>
References: <20190704234843.6601-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove the global flow_block_cb_list, replace it by per-driver list
of flow block objects. This will make it easier later on to support
for policy hardware offload of multiple subsystems.

Suggested-by: Jiri Pirko <jiri@resnulli.us>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: new patch, no previous v1.
    Introduce per-driver list of flow blocks as Jiri requested.

 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |  4 ++-
 drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c      |  3 ++
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c    |  4 ++-
 drivers/net/ethernet/intel/i40e/i40e_main.c        |  4 ++-
 drivers/net/ethernet/intel/iavf/iavf_main.c        |  4 ++-
 drivers/net/ethernet/intel/igb/igb_main.c          |  4 ++-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      |  4 ++-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  4 ++-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |  8 ++++--
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c     | 17 ++++++------
 drivers/net/ethernet/mscc/ocelot_flower.c          |  6 ++--
 drivers/net/ethernet/mscc/ocelot_tc.c              |  8 ++++--
 drivers/net/ethernet/netronome/nfp/abm/cls.c       |  5 +++-
 drivers/net/ethernet/netronome/nfp/bpf/main.c      |  3 ++
 .../net/ethernet/netronome/nfp/flower/offload.c    |  9 +++---
 drivers/net/ethernet/qlogic/qede/qede_main.c       |  4 ++-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |  3 ++
 drivers/net/netdevsim/netdev.c                     |  3 ++
 include/net/flow_offload.h                         | 14 ++++++----
 net/core/flow_offload.c                            | 32 ++++++++++++----------
 net/dsa/slave.c                                    |  8 ++++--
 21 files changed, 99 insertions(+), 52 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 7b8d71252093..4bf13776759e 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -9847,6 +9847,8 @@ static int bnxt_setup_tc_block_cb(enum tc_setup_type type, void *type_data,
 	}
 }
 
+static LIST_HEAD(bnxt_block_cb_list);
+
 static int bnxt_setup_tc(struct net_device *dev, enum tc_setup_type type,
 			 void *type_data)
 {
@@ -9854,7 +9856,7 @@ static int bnxt_setup_tc(struct net_device *dev, enum tc_setup_type type,
 
 	switch (type) {
 	case TC_SETUP_BLOCK:
-		return flow_block_setup_offload(type_data,
+		return flow_block_setup_offload(type_data, &bnxt_block_cb_list,
 						bnxt_setup_tc_block_cb, bp, bp,
 						true);
 	case TC_SETUP_QDISC_MQPRIO: {
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c
index 1b78615a1384..80b8d8e54f58 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c
@@ -161,6 +161,8 @@ static int bnxt_vf_rep_setup_tc_block_cb(enum tc_setup_type type,
 	}
 }
 
+static LIST_HEAD(bnxt_vf_block_cb_list);
+
 static int bnxt_vf_rep_setup_tc(struct net_device *dev, enum tc_setup_type type,
 				void *type_data)
 {
@@ -169,6 +171,7 @@ static int bnxt_vf_rep_setup_tc(struct net_device *dev, enum tc_setup_type type,
 	switch (type) {
 	case TC_SETUP_BLOCK:
 		return flow_block_setup_offload(type_data,
+						&bnxt_vf_block_cb_list,
 						bnxt_vf_rep_setup_tc_block_cb,
 						vf_rep, vf_rep, true);
 	default:
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index 3d8acabb8bfd..ee98304ea0cd 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -3190,6 +3190,8 @@ static int cxgb_setup_tc_block_cb(enum tc_setup_type type, void *type_data,
 	}
 }
 
+static LIST_HEAD(cxgb_block_cb_list);
+
 static int cxgb_setup_tc(struct net_device *dev, enum tc_setup_type type,
 			 void *type_data)
 {
@@ -3197,7 +3199,7 @@ static int cxgb_setup_tc(struct net_device *dev, enum tc_setup_type type,
 
 	switch (type) {
 	case TC_SETUP_BLOCK:
-		return flow_block_setup_offload(type_data,
+		return flow_block_setup_offload(type_data, &cxgb_block_cb_list,
 						cxgb_setup_tc_block_cb, pi, dev,
 						true);
 	default:
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index f7d2616854ec..2705e46fde59 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -8177,6 +8177,8 @@ static int i40e_setup_tc_block_cb(enum tc_setup_type type, void *type_data,
 	}
 }
 
+static LIST_HEAD(i40e_block_cb_list);
+
 static int __i40e_setup_tc(struct net_device *netdev, enum tc_setup_type type,
 			   void *type_data)
 {
@@ -8186,7 +8188,7 @@ static int __i40e_setup_tc(struct net_device *netdev, enum tc_setup_type type,
 	case TC_SETUP_QDISC_MQPRIO:
 		return i40e_setup_tc(netdev, type_data);
 	case TC_SETUP_BLOCK:
-		return flow_block_setup_offload(type_data,
+		return flow_block_setup_offload(type_data, &i40e_block_cb_list,
 						i40e_setup_tc_block_cb, np, np,
 						true);
 	default:
diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 8ef6aca34edd..410cbf02e6a8 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -3113,6 +3113,8 @@ static int iavf_setup_tc_block_cb(enum tc_setup_type type, void *type_data,
 	}
 }
 
+static LIST_HEAD(iavf_block_cb_list);
+
 /**
  * iavf_setup_tc - configure multiple traffic classes
  * @netdev: network interface device structure
@@ -3133,7 +3135,7 @@ static int iavf_setup_tc(struct net_device *netdev, enum tc_setup_type type,
 	case TC_SETUP_QDISC_MQPRIO:
 		return __iavf_setup_tc(netdev, type_data);
 	case TC_SETUP_BLOCK:
-		return flow_block_setup_offload(type_data,
+		return flow_block_setup_offload(type_data, &iavf_block_cb_list,
 						iavf_setup_tc_block_cb, adapter,
 						adapter, true);
 	default:
diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 830b950f423b..c66e66f04036 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -2806,6 +2806,8 @@ static int igb_offload_txtime(struct igb_adapter *adapter,
 	return 0;
 }
 
+static LIST_HEAD(igb_block_cb_list);
+
 static int igb_setup_tc(struct net_device *dev, enum tc_setup_type type,
 			void *type_data)
 {
@@ -2815,7 +2817,7 @@ static int igb_setup_tc(struct net_device *dev, enum tc_setup_type type,
 	case TC_SETUP_QDISC_CBS:
 		return igb_offload_cbs(adapter, type_data);
 	case TC_SETUP_BLOCK:
-		return flow_block_setup_offload(type_data,
+		return flow_block_setup_offload(type_data, &igb_block_cb_list,
 						igb_setup_tc_block_cb,
 						adapter, adapter, true);
 
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 144f2cca686a..b3d62d8e1bd0 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -9614,6 +9614,8 @@ static int ixgbe_setup_tc_mqprio(struct net_device *dev,
 	return ixgbe_setup_tc(dev, mqprio->num_tc);
 }
 
+static LIST_HEAD(ixgbe_block_cb_list);
+
 static int __ixgbe_setup_tc(struct net_device *dev, enum tc_setup_type type,
 			    void *type_data)
 {
@@ -9621,7 +9623,7 @@ static int __ixgbe_setup_tc(struct net_device *dev, enum tc_setup_type type,
 
 	switch (type) {
 	case TC_SETUP_BLOCK:
-		return flow_block_setup_offload(type_data,
+		return flow_block_setup_offload(type_data, &ixgbe_block_cb_list,
 						ixgbe_setup_tc_block_cb,
 						adapter, adapter, true);
 	case TC_SETUP_QDISC_MQPRIO:
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index fa9c04129eb6..6324215c7800 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3347,6 +3347,8 @@ static int mlx5e_setup_tc_block_cb(enum tc_setup_type type, void *type_data,
 }
 #endif
 
+static LIST_HEAD(mlx5e_block_cb_list);
+
 static int mlx5e_setup_tc(struct net_device *dev, enum tc_setup_type type,
 			  void *type_data)
 {
@@ -3355,7 +3357,7 @@ static int mlx5e_setup_tc(struct net_device *dev, enum tc_setup_type type,
 	switch (type) {
 #ifdef CONFIG_MLX5_ESWITCH
 	case TC_SETUP_BLOCK:
-		return flow_block_setup_offload(type_data,
+		return flow_block_setup_offload(type_data, &mlx5e_block_cb_list,
 						mlx5e_setup_tc_block_cb,
 						priv, priv, true);
 #endif
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 925aa589a818..2d26af759997 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -700,6 +700,8 @@ static void mlx5e_rep_indr_tc_block_unbind(void *cb_priv)
 	kfree(indr_priv);
 }
 
+static LIST_HEAD(mlx5e_rep_block_cb_list);
+
 static int
 mlx5e_rep_indr_setup_tc_block(struct net_device *netdev,
 			      struct mlx5e_rep_priv *rpriv,
@@ -726,8 +728,7 @@ mlx5e_rep_indr_setup_tc_block(struct net_device *netdev,
 		list_add(&indr_priv->list,
 			 &rpriv->uplink_priv.tc_indr_block_priv_list);
 
-		block_cb = flow_block_cb_alloc(f->net,
-					       mlx5e_rep_indr_setup_block_cb,
+		block_cb = flow_block_cb_alloc(f, mlx5e_rep_indr_setup_block_cb,
 					       indr_priv, indr_priv,
 					       mlx5e_rep_indr_tc_block_unbind);
 		if (IS_ERR(block_cb)) {
@@ -743,7 +744,7 @@ mlx5e_rep_indr_setup_tc_block(struct net_device *netdev,
 		if (!indr_priv)
 			return -ENOENT;
 
-		block_cb = flow_block_cb_lookup(f->net,
+		block_cb = flow_block_cb_lookup(f,
 						mlx5e_rep_indr_setup_block_cb,
 						indr_priv);
 		if (!block_cb)
@@ -1198,6 +1199,7 @@ static int mlx5e_rep_setup_tc(struct net_device *dev, enum tc_setup_type type,
 	switch (type) {
 	case TC_SETUP_BLOCK:
 		return flow_block_setup_offload(type_data,
+						&mlx5e_rep_block_cb_list,
 						mlx5e_rep_setup_tc_cb,
 						priv, priv, true);
 	default:
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 6970738c070b..3ecb51a05961 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -1601,15 +1601,13 @@ mlxsw_sp_setup_tc_block_flower_bind(struct mlxsw_sp_port *mlxsw_sp_port,
 	bool register_block = false;
 	int err;
 
-	block_cb = flow_block_cb_lookup(f->net,
-					mlxsw_sp_setup_tc_block_cb_flower,
+	block_cb = flow_block_cb_lookup(f, mlxsw_sp_setup_tc_block_cb_flower,
 					mlxsw_sp);
 	if (!block_cb) {
 		acl_block = mlxsw_sp_acl_block_create(mlxsw_sp, f->net);
 		if (!acl_block)
 			return -ENOMEM;
-
-		block_cb = flow_block_cb_alloc(f->net,
+		block_cb = flow_block_cb_alloc(f,
 					       mlxsw_sp_setup_tc_block_cb_flower,
 					       mlxsw_sp, acl_block,
 					       mlxsw_sp_tc_block_flower_release);
@@ -1655,8 +1653,7 @@ mlxsw_sp_setup_tc_block_flower_unbind(struct mlxsw_sp_port *mlxsw_sp_port,
 	struct flow_block_cb *block_cb;
 	int err;
 
-	block_cb = flow_block_cb_lookup(f->net,
-					mlxsw_sp_setup_tc_block_cb_flower,
+	block_cb = flow_block_cb_lookup(f, mlxsw_sp_setup_tc_block_cb_flower,
 					mlxsw_sp);
 	if (!block_cb)
 		return;
@@ -1673,6 +1670,8 @@ mlxsw_sp_setup_tc_block_flower_unbind(struct mlxsw_sp_port *mlxsw_sp_port,
 		flow_block_cb_remove(block_cb, f);
 }
 
+static LIST_HEAD(mlxsw_block_cb_list);
+
 static int mlxsw_sp_setup_tc_block(struct mlxsw_sp_port *mlxsw_sp_port,
 				   struct flow_block_offload *f)
 {
@@ -1681,6 +1680,8 @@ static int mlxsw_sp_setup_tc_block(struct mlxsw_sp_port *mlxsw_sp_port,
 	bool ingress;
 	int err;
 
+	f->block_cb_list = &mlxsw_block_cb_list;
+
 	if (f->binder_type == TCF_BLOCK_BINDER_TYPE_CLSACT_INGRESS) {
 		cb = mlxsw_sp_setup_tc_block_cb_matchall_ig;
 		ingress = true;
@@ -1693,7 +1694,7 @@ static int mlxsw_sp_setup_tc_block(struct mlxsw_sp_port *mlxsw_sp_port,
 
 	switch (f->command) {
 	case TC_BLOCK_BIND:
-		block_cb = flow_block_cb_alloc(f->net, cb, mlxsw_sp_port,
+		block_cb = flow_block_cb_alloc(f, cb, mlxsw_sp_port,
 					       mlxsw_sp_port, NULL);
 		if (IS_ERR(block_cb))
 			return PTR_ERR(block_cb);
@@ -1708,7 +1709,7 @@ static int mlxsw_sp_setup_tc_block(struct mlxsw_sp_port *mlxsw_sp_port,
 	case TC_BLOCK_UNBIND:
 		mlxsw_sp_setup_tc_block_flower_unbind(mlxsw_sp_port,
 						      f, ingress);
-		block_cb = flow_block_cb_lookup(f->net, cb, mlxsw_sp_port);
+		block_cb = flow_block_cb_lookup(f, cb, mlxsw_sp_port);
 		if (!block_cb)
 			return -ENOENT;
 
diff --git a/drivers/net/ethernet/mscc/ocelot_flower.c b/drivers/net/ethernet/mscc/ocelot_flower.c
index 3b9e4219ac7a..3dd8acc255ae 100644
--- a/drivers/net/ethernet/mscc/ocelot_flower.c
+++ b/drivers/net/ethernet/mscc/ocelot_flower.c
@@ -316,14 +316,14 @@ int ocelot_setup_tc_block_flower_bind(struct ocelot_port *port,
 	if (f->binder_type == TCF_BLOCK_BINDER_TYPE_CLSACT_EGRESS)
 		return -EOPNOTSUPP;
 
-	block_cb = flow_block_cb_lookup(f->net, ocelot_setup_tc_block_cb_flower,
+	block_cb = flow_block_cb_lookup(f, ocelot_setup_tc_block_cb_flower,
 					port);
 	if (!block_cb) {
 		port_block = ocelot_port_block_create(port);
 		if (!port_block)
 			return -ENOMEM;
 
-		block_cb = flow_block_cb_alloc(f->net,
+		block_cb = flow_block_cb_alloc(f,
 					       ocelot_setup_tc_block_cb_flower,
 					       port, port_block,
 					       ocelot_tc_block_unbind);
@@ -350,7 +350,7 @@ void ocelot_setup_tc_block_flower_unbind(struct ocelot_port *port,
 {
 	struct flow_block_cb *block_cb;
 
-	block_cb = flow_block_cb_lookup(f->net, ocelot_setup_tc_block_cb_flower,
+	block_cb = flow_block_cb_lookup(f, ocelot_setup_tc_block_cb_flower,
 					port);
 	if (!block_cb)
 		return;
diff --git a/drivers/net/ethernet/mscc/ocelot_tc.c b/drivers/net/ethernet/mscc/ocelot_tc.c
index 14a9e178c3b8..17fca31206c7 100644
--- a/drivers/net/ethernet/mscc/ocelot_tc.c
+++ b/drivers/net/ethernet/mscc/ocelot_tc.c
@@ -128,6 +128,8 @@ static int ocelot_setup_tc_block_cb_eg(enum tc_setup_type type,
 					cb_priv, false);
 }
 
+static LIST_HEAD(ocelot_block_cb_list);
+
 static int ocelot_setup_tc_block(struct ocelot_port *port,
 				 struct flow_block_offload *f)
 {
@@ -147,9 +149,11 @@ static int ocelot_setup_tc_block(struct ocelot_port *port,
 		return -EOPNOTSUPP;
 	}
 
+	f->block_cb_list = &ocelot_block_cb_list;
+
 	switch (f->command) {
 	case TC_BLOCK_BIND:
-		block_cb = flow_block_cb_alloc(f->net, cb, port, port, NULL);
+		block_cb = flow_block_cb_alloc(f, cb, port, port, NULL);
 		if (IS_ERR(block_cb))
 			return PTR_ERR(block_cb);
 
@@ -161,7 +165,7 @@ static int ocelot_setup_tc_block(struct ocelot_port *port,
 		flow_block_cb_add(block_cb, f);
 		return 0;
 	case TC_BLOCK_UNBIND:
-		block_cb = flow_block_cb_lookup(f->net, cb, port);
+		block_cb = flow_block_cb_lookup(f, cb, port);
 		if (!block_cb)
 			return -ENOENT;
 
diff --git a/drivers/net/ethernet/netronome/nfp/abm/cls.c b/drivers/net/ethernet/netronome/nfp/abm/cls.c
index 96b89a7c468b..a42f92318b7a 100644
--- a/drivers/net/ethernet/netronome/nfp/abm/cls.c
+++ b/drivers/net/ethernet/netronome/nfp/abm/cls.c
@@ -262,9 +262,12 @@ static int nfp_abm_setup_tc_block_cb(enum tc_setup_type type,
 	}
 }
 
+static LIST_HEAD(nfp_abm_vf_block_cb_list);
+
 int nfp_abm_setup_cls_block(struct net_device *netdev, struct nfp_repr *repr,
 			    struct flow_block_offload *f)
 {
-	return flow_block_setup_offload(f, nfp_abm_setup_tc_block_cb,
+	return flow_block_setup_offload(f, &nfp_abm_block_cb_list,
+					nfp_abm_setup_tc_block_cb,
 					repr, repr, true);
 }
diff --git a/drivers/net/ethernet/netronome/nfp/bpf/main.c b/drivers/net/ethernet/netronome/nfp/bpf/main.c
index 3897cc4f7a7e..5316d85261c0 100644
--- a/drivers/net/ethernet/netronome/nfp/bpf/main.c
+++ b/drivers/net/ethernet/netronome/nfp/bpf/main.c
@@ -160,6 +160,8 @@ static int nfp_bpf_setup_tc_block_cb(enum tc_setup_type type,
 	return 0;
 }
 
+static LIST_HEAD(nfp_bfp_block_cb_list);
+
 static int nfp_bpf_setup_tc(struct nfp_app *app, struct net_device *netdev,
 			    enum tc_setup_type type, void *type_data)
 {
@@ -168,6 +170,7 @@ static int nfp_bpf_setup_tc(struct nfp_app *app, struct net_device *netdev,
 	switch (type) {
 	case TC_SETUP_BLOCK:
 		return flow_block_setup_offload(type_data,
+						&nfp_bfp_block_cb_list,
 						nfp_bpf_setup_tc_block_cb,
 						nn, nn, true);
 	default:
diff --git a/drivers/net/ethernet/netronome/nfp/flower/offload.c b/drivers/net/ethernet/netronome/nfp/flower/offload.c
index 9b99f6936f90..6b2f31ed2315 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/offload.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/offload.c
@@ -1317,7 +1317,7 @@ static int nfp_flower_setup_tc_block(struct net_device *netdev,
 
 	switch (f->command) {
 	case TC_BLOCK_BIND:
-		block_cb = flow_block_cb_alloc(f->net,
+		block_cb = flow_block_cb_alloc(f,
 					       nfp_flower_setup_tc_block_cb,
 					       repr, repr, NULL);
 		if (IS_ERR(block_cb))
@@ -1326,7 +1326,7 @@ static int nfp_flower_setup_tc_block(struct net_device *netdev,
 		flow_block_cb_add(block_cb, f);
 		return 0;
 	case TC_BLOCK_UNBIND:
-		block_cb = flow_block_cb_lookup(f->net,
+		block_cb = flow_block_cb_lookup(f,
 						nfp_flower_setup_tc_block_cb,
 						repr);
 		if (!block_cb)
@@ -1405,7 +1405,6 @@ nfp_flower_setup_indr_tc_block(struct net_device *netdev, struct nfp_app *app,
 {
 	struct nfp_flower_indr_block_cb_priv *cb_priv;
 	struct nfp_flower_priv *priv = app->priv;
-	struct net *net = dev_net(netdev);
 	struct flow_block_cb *block_cb;
 
 	if (f->binder_type != TCF_BLOCK_BINDER_TYPE_CLSACT_INGRESS &&
@@ -1423,7 +1422,7 @@ nfp_flower_setup_indr_tc_block(struct net_device *netdev, struct nfp_app *app,
 		cb_priv->app = app;
 		list_add(&cb_priv->list, &priv->indr_block_cb_priv);
 
-		block_cb = flow_block_cb_alloc(net,
+		block_cb = flow_block_cb_alloc(f,
 					       nfp_flower_setup_indr_block_cb,
 					       cb_priv, cb_priv,
 					       nfp_flower_setup_indr_tc_release);
@@ -1440,7 +1439,7 @@ nfp_flower_setup_indr_tc_block(struct net_device *netdev, struct nfp_app *app,
 		if (!cb_priv)
 			return -ENOENT;
 
-		block_cb = flow_block_cb_lookup(net,
+		block_cb = flow_block_cb_lookup(f,
 						nfp_flower_setup_indr_block_cb,
 						cb_priv);
 		if (!block_cb)
diff --git a/drivers/net/ethernet/qlogic/qede/qede_main.c b/drivers/net/ethernet/qlogic/qede/qede_main.c
index 00db21d9407f..aab9c8c25d43 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_main.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_main.c
@@ -579,6 +579,8 @@ static int qede_setup_tc_block_cb(enum tc_setup_type type, void *type_data,
 	}
 }
 
+static LIST_HEAD(qede_block_cb_list);
+
 static int
 qede_setup_tc_offload(struct net_device *dev, enum tc_setup_type type,
 		      void *type_data)
@@ -588,7 +590,7 @@ qede_setup_tc_offload(struct net_device *dev, enum tc_setup_type type,
 
 	switch (type) {
 	case TC_SETUP_BLOCK:
-		return flow_block_setup_offload(type_data,
+		return flow_block_setup_offload(type_data, &qede_block_cb_list,
 						qede_setup_tc_block_cb,
 						edev, edev, true);
 	case TC_SETUP_QDISC_MQPRIO:
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 341db1eed108..86fef8ac2712 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -3853,6 +3853,8 @@ static int stmmac_setup_tc_block_cb(enum tc_setup_type type, void *type_data,
 	return ret;
 }
 
+static LIST_HEAD(stmmac_block_cb_list);
+
 static int stmmac_setup_tc(struct net_device *ndev, enum tc_setup_type type,
 			   void *type_data)
 {
@@ -3861,6 +3863,7 @@ static int stmmac_setup_tc(struct net_device *ndev, enum tc_setup_type type,
 	switch (type) {
 	case TC_SETUP_BLOCK:
 		return flow_block_setup_offload(type_data,
+						&stmmac_block_cb_list,
 						stmmac_setup_tc_block_cb,
 						priv, priv, true);
 	case TC_SETUP_QDISC_CBS:
diff --git a/drivers/net/netdevsim/netdev.c b/drivers/net/netdevsim/netdev.c
index 710b03fc8db1..0612b0628cf3 100644
--- a/drivers/net/netdevsim/netdev.c
+++ b/drivers/net/netdevsim/netdev.c
@@ -203,6 +203,8 @@ static int nsim_set_vf_link_state(struct net_device *dev, int vf, int state)
 	return 0;
 }
 
+static LIST_HEAD(nsim_block_cb_list);
+
 static int
 nsim_setup_tc(struct net_device *dev, enum tc_setup_type type, void *type_data)
 {
@@ -211,6 +213,7 @@ nsim_setup_tc(struct net_device *dev, enum tc_setup_type type, void *type_data)
 	switch (type) {
 	case TC_SETUP_BLOCK:
 		return flow_block_setup_offload(type_data,
+						&nsim_block_cb_list,
 						nsim_setup_tc_block_cb, ns, ns,
 						true);
 	default:
diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index 728ded7e4361..390e74ed42cb 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -249,6 +249,7 @@ struct flow_block_offload {
 	enum flow_block_command command;
 	enum flow_block_binder_type binder_type;
 	struct list_head cb_list;
+	struct list_head *block_cb_list;
 	struct net *net;
 	bool block_shared;
 	struct netlink_ext_ack *extack;
@@ -266,13 +267,14 @@ struct flow_block_cb {
 	unsigned int refcnt;
 };
 
-struct flow_block_cb *flow_block_cb_alloc(struct net *net, tc_setup_cb_t *cb,
+struct flow_block_cb *flow_block_cb_alloc(struct flow_block_offload *f,
+					  tc_setup_cb_t *cb,
 					  void *cb_ident, void *cb_priv,
 					  void (*release)(void *cb_priv));
 void flow_block_cb_free(struct flow_block_cb *block_cb);
 void *flow_block_cb_priv(struct flow_block_cb *block_cb);
-struct flow_block_cb *flow_block_cb_lookup(struct net *net, tc_setup_cb_t *cb,
-					   void *cb_ident);
+struct flow_block_cb *flow_block_cb_lookup(struct flow_block_offload *f,
+					   tc_setup_cb_t *cb, void *cb_ident);
 void flow_block_cb_incref(struct flow_block_cb *block_cb);
 unsigned int flow_block_cb_decref(struct flow_block_cb *block_cb);
 void flow_block_cb_add(struct flow_block_cb *block_cb,
@@ -281,7 +283,9 @@ void flow_block_cb_remove(struct flow_block_cb *block_cb,
 			  struct flow_block_offload *offload);
 void flow_block_cb_splice(struct flow_block_offload *offload);
 
-int flow_block_setup_offload(struct flow_block_offload *f, tc_setup_cb_t *cb,
-			     void *cb_ident, void *cb_priv, bool ingress_only);
+int flow_block_setup_offload(struct flow_block_offload *f,
+			     struct list_head *block_cb_list,
+			     tc_setup_cb_t *cb, void *cb_ident, void *cb_priv,
+			     bool ingress_only);
 
 #endif /* _NET_FLOW_OFFLOAD_H */
diff --git a/net/core/flow_offload.c b/net/core/flow_offload.c
index 8c20f4740800..8392cf2b5ea7 100644
--- a/net/core/flow_offload.c
+++ b/net/core/flow_offload.c
@@ -171,15 +171,13 @@ void *flow_block_cb_priv(struct flow_block_cb *block_cb)
 }
 EXPORT_SYMBOL(flow_block_cb_priv);
 
-static LIST_HEAD(flow_block_cb_list);
-
-struct flow_block_cb *flow_block_cb_lookup(struct net *net, tc_setup_cb_t *cb,
-					   void *cb_ident)
+struct flow_block_cb *flow_block_cb_lookup(struct flow_block_offload *f,
+					   tc_setup_cb_t *cb, void *cb_ident)
 {
 	struct flow_block_cb *block_cb;
 
-	list_for_each_entry(block_cb, &flow_block_cb_list, global_list) {
-		if (block_cb->net == net &&
+	list_for_each_entry(block_cb, f->block_cb_list, global_list) {
+		if (block_cb->net == f->net &&
 		    block_cb->cb == cb &&
 		    block_cb->cb_ident == cb_ident)
 			return block_cb;
@@ -200,13 +198,14 @@ unsigned int flow_block_cb_decref(struct flow_block_cb *block_cb)
 }
 EXPORT_SYMBOL(flow_block_cb_decref);
 
-struct flow_block_cb *flow_block_cb_alloc(struct net *net, tc_setup_cb_t *cb,
+struct flow_block_cb *flow_block_cb_alloc(struct flow_block_offload *f,
+					  tc_setup_cb_t *cb,
 					  void *cb_ident, void *cb_priv,
 					  void (*release)(void *cb_priv))
 {
 	struct flow_block_cb *block_cb;
 
-	list_for_each_entry(block_cb, &flow_block_cb_list, global_list) {
+	list_for_each_entry(block_cb, f->block_cb_list, global_list) {
 		if (block_cb->cb == cb &&
 		    block_cb->cb_ident == cb_ident)
 			return ERR_PTR(-EBUSY);
@@ -216,7 +215,7 @@ struct flow_block_cb *flow_block_cb_alloc(struct net *net, tc_setup_cb_t *cb,
 	if (IS_ERR(block_cb))
 		return block_cb;
 
-	block_cb->net = net;
+	block_cb->net = f->net;
 	block_cb->cb = cb;
 	block_cb->cb_ident = cb_ident;
 	block_cb->release = release;
@@ -251,30 +250,33 @@ EXPORT_SYMBOL(flow_block_cb_remove);
 
 void flow_block_cb_splice(struct flow_block_offload *offload)
 {
-	list_splice(&offload->cb_list, &flow_block_cb_list);
+	list_splice(&offload->cb_list, offload->block_cb_list);
 }
 EXPORT_SYMBOL(flow_block_cb_splice);
 
-int flow_block_setup_offload(struct flow_block_offload *f, tc_setup_cb_t *cb,
-			     void *cb_ident, void *cb_priv, bool ingress_only)
+int flow_block_setup_offload(struct flow_block_offload *f,
+			     struct list_head *block_cb_list,
+			     tc_setup_cb_t *cb,  void *cb_ident, void *cb_priv,
+			     bool ingress_only)
 {
 	struct flow_block_cb *block_cb;
 
+	f->block_cb_list = block_cb_list;
+
 	if (ingress_only &&
 	    f->binder_type != TCF_BLOCK_BINDER_TYPE_CLSACT_INGRESS)
 		return -EOPNOTSUPP;
 
 	switch (f->command) {
 	case TC_BLOCK_BIND:
-		block_cb = flow_block_cb_alloc(f->net, cb, cb_ident, cb_priv,
-					       NULL);
+		block_cb = flow_block_cb_alloc(f, cb, cb_ident, cb_priv, NULL);
 		if (IS_ERR(block_cb))
 			return PTR_ERR(block_cb);
 
 		flow_block_cb_add(block_cb, f);
 		return 0;
 	case TC_BLOCK_UNBIND:
-		block_cb = flow_block_cb_lookup(f->net, cb, cb_ident);
+		block_cb = flow_block_cb_lookup(f, cb, cb_ident);
 		if (!block_cb)
 			return -ENOENT;
 
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 0323091b5cef..504c4183af71 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -942,12 +942,16 @@ static int dsa_slave_setup_tc_block_cb_eg(enum tc_setup_type type,
 	return dsa_slave_setup_tc_block_cb(type, type_data, cb_priv, false);
 }
 
+static LIST_HEAD(dsa_slave_block_cb_list);
+
 static int dsa_slave_setup_tc_block(struct net_device *dev,
 				    struct flow_block_offload *f)
 {
 	struct flow_block_cb *block_cb;
 	tc_setup_cb_t *cb;
 
+	f->block_cb_list = &dsa_slave_block_cb_list;
+
 	if (f->binder_type == TCF_BLOCK_BINDER_TYPE_CLSACT_INGRESS)
 		cb = dsa_slave_setup_tc_block_cb_ig;
 	else if (f->binder_type == TCF_BLOCK_BINDER_TYPE_CLSACT_EGRESS)
@@ -957,14 +961,14 @@ static int dsa_slave_setup_tc_block(struct net_device *dev,
 
 	switch (f->command) {
 	case TC_BLOCK_BIND:
-		block_cb = flow_block_cb_alloc(f->net, cb, dev, dev, NULL);
+		block_cb = flow_block_cb_alloc(f, cb, dev, dev, NULL);
 		if (IS_ERR(block_cb))
 			return PTR_ERR(block_cb);
 
 		flow_block_cb_add(block_cb, f);
 		return 0;
 	case TC_BLOCK_UNBIND:
-		block_cb = flow_block_cb_lookup(f->net, cb, dev);
+		block_cb = flow_block_cb_lookup(f, cb, dev);
 		if (!block_cb)
 			return -ENOENT;
 
-- 
2.11.0

