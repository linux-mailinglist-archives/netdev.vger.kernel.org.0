Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D863663CFD
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 22:57:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729883AbfGIU4d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 16:56:33 -0400
Received: from mail.us.es ([193.147.175.20]:37124 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726318AbfGIU4c (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Jul 2019 16:56:32 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id AE8B22880491
        for <netdev@vger.kernel.org>; Tue,  9 Jul 2019 22:56:24 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9D1C21021A6
        for <netdev@vger.kernel.org>; Tue,  9 Jul 2019 22:56:24 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 9C0BADA732; Tue,  9 Jul 2019 22:56:24 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 06908A0AAC;
        Tue,  9 Jul 2019 22:56:20 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 09 Jul 2019 22:56:20 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [31.4.194.134])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id DCAD94265A31;
        Tue,  9 Jul 2019 22:56:17 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, thomas.lendacky@amd.com, f.fainelli@gmail.com,
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
        cphealy@gmail.com, phil@nwl.cc, netfilter-devel@vger.kernel.org
Subject: [PATCH net-next,v4 08/12] drivers: net: use flow block API
Date:   Tue,  9 Jul 2019 22:55:46 +0200
Message-Id: <20190709205550.3160-9-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190709205550.3160-1-pablo@netfilter.org>
References: <20190709205550.3160-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch updates flow_block_cb_setup_simple() to use the flow block API.
Several drivers are also adjusted to use it.

This patch introduces the per-driver list of flow blocks to account for
blocks that are already in use.

Remove tc_block_offload alias.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v4: fix typo in list in nfp driver - Jakub Kicinski.
    Move driver_list handling to the driver code, this list is transitional,
    until drivers are updated to support multiple subsystems. No more
    driver_list handling from core.

 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |  5 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c      |  5 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c    |  5 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c        |  5 +-
 drivers/net/ethernet/intel/iavf/iavf_main.c        |  5 +-
 drivers/net/ethernet/intel/igb/igb_main.c          |  5 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      |  5 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  5 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   | 42 +++++++---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c     | 92 ++++++++++++++--------
 drivers/net/ethernet/mscc/ocelot_ace.h             |  4 +-
 drivers/net/ethernet/mscc/ocelot_flower.c          | 46 ++++++-----
 drivers/net/ethernet/mscc/ocelot_tc.c              | 34 +++++---
 drivers/net/ethernet/netronome/nfp/abm/cls.c       |  7 +-
 drivers/net/ethernet/netronome/nfp/abm/main.h      |  2 +-
 drivers/net/ethernet/netronome/nfp/bpf/main.c      |  5 +-
 .../net/ethernet/netronome/nfp/flower/offload.c    | 68 +++++++++++-----
 drivers/net/ethernet/qlogic/qede/qede_main.c       |  5 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |  5 +-
 drivers/net/netdevsim/netdev.c                     |  5 +-
 include/net/flow_offload.h                         |  3 +-
 include/net/pkt_cls.h                              |  2 -
 net/core/flow_offload.c                            | 20 ++++-
 net/dsa/slave.c                                    | 22 +++++-
 net/sched/cls_api.c                                | 14 ++--
 25 files changed, 286 insertions(+), 130 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index d2f8c3ed6c73..e6447addf0d6 100644
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
@@ -9854,7 +9856,8 @@ static int bnxt_setup_tc(struct net_device *dev, enum tc_setup_type type,
 
 	switch (type) {
 	case TC_SETUP_BLOCK:
-		return flow_block_cb_setup_simple(type_data, NULL,
+		return flow_block_cb_setup_simple(type_data,
+						  &bnxt_block_cb_list,
 						  bnxt_setup_tc_block_cb,
 						  bp, bp, true);
 	case TC_SETUP_QDISC_MQPRIO: {
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c
index 89398ff011d4..f9bf7d7250ab 100644
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
@@ -168,7 +170,8 @@ static int bnxt_vf_rep_setup_tc(struct net_device *dev, enum tc_setup_type type,
 
 	switch (type) {
 	case TC_SETUP_BLOCK:
-		return flow_block_cb_setup_simple(type_data, NULL,
+		return flow_block_cb_setup_simple(type_data,
+						  &bnxt_vf_block_cb_list,
 						  bnxt_vf_rep_setup_tc_block_cb,
 						  vf_rep, vf_rep, true);
 	default:
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index 9a486282a32e..fdc8ca4f8891 100644
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
@@ -3197,7 +3199,8 @@ static int cxgb_setup_tc(struct net_device *dev, enum tc_setup_type type,
 
 	switch (type) {
 	case TC_SETUP_BLOCK:
-		return flow_block_cb_setup_simple(type_data, NULL,
+		return flow_block_cb_setup_simple(type_data,
+						  &cxgb_block_cb_list,
 						  cxgb_setup_tc_block_cb,
 						  pi, dev, true);
 	default:
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 52f0f14d4207..7be1080680f5 100644
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
@@ -8186,7 +8188,8 @@ static int __i40e_setup_tc(struct net_device *netdev, enum tc_setup_type type,
 	case TC_SETUP_QDISC_MQPRIO:
 		return i40e_setup_tc(netdev, type_data);
 	case TC_SETUP_BLOCK:
-		return flow_block_cb_setup_simple(type_data, NULL,
+		return flow_block_cb_setup_simple(type_data,
+						  &i40e_block_cb_list,
 						  i40e_setup_tc_block_cb,
 						  np, np, true);
 	default:
diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index fd0e2bcc75e5..05eca6f2e890 100644
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
@@ -3133,7 +3135,8 @@ static int iavf_setup_tc(struct net_device *netdev, enum tc_setup_type type,
 	case TC_SETUP_QDISC_MQPRIO:
 		return __iavf_setup_tc(netdev, type_data);
 	case TC_SETUP_BLOCK:
-		return flow_block_cb_setup_simple(type_data, NULL,
+		return flow_block_cb_setup_simple(type_data,
+						  &iavf_block_cb_list,
 						  iavf_setup_tc_block_cb,
 						  adapter, adapter, true);
 	default:
diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 836f9e1a136c..00e8186e2c59 100644
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
@@ -2815,7 +2817,8 @@ static int igb_setup_tc(struct net_device *dev, enum tc_setup_type type,
 	case TC_SETUP_QDISC_CBS:
 		return igb_offload_cbs(adapter, type_data);
 	case TC_SETUP_BLOCK:
-		return flow_block_cb_setup_simple(type_data, NULL,
+		return flow_block_cb_setup_simple(type_data,
+						  &igb_block_cb_list,
 						  igb_setup_tc_block_cb,
 						  adapter, adapter, true);
 
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index b098f5be9c0d..cbaf712d6529 100644
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
@@ -9621,7 +9623,8 @@ static int __ixgbe_setup_tc(struct net_device *dev, enum tc_setup_type type,
 
 	switch (type) {
 	case TC_SETUP_BLOCK:
-		return flow_block_cb_setup_simple(type_data, NULL,
+		return flow_block_cb_setup_simple(type_data,
+						  &ixgbe_block_cb_list,
 						  ixgbe_setup_tc_block_cb,
 						  adapter, adapter, true);
 	case TC_SETUP_QDISC_MQPRIO:
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 395890fea358..10ee7c96d542 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3459,6 +3459,8 @@ static int mlx5e_setup_tc_block_cb(enum tc_setup_type type, void *type_data,
 }
 #endif
 
+static LIST_HEAD(mlx5e_block_cb_list);
+
 static int mlx5e_setup_tc(struct net_device *dev, enum tc_setup_type type,
 			  void *type_data)
 {
@@ -3467,7 +3469,8 @@ static int mlx5e_setup_tc(struct net_device *dev, enum tc_setup_type type,
 	switch (type) {
 #ifdef CONFIG_MLX5_ESWITCH
 	case TC_SETUP_BLOCK:
-		return flow_block_cb_setup_simple(type_data, NULL,
+		return flow_block_cb_setup_simple(type_data,
+						  &mlx5e_block_cb_list,
 						  mlx5e_setup_tc_block_cb,
 						  priv, priv, true);
 #endif
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index f5c430973b35..897a9511227c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -692,17 +692,29 @@ static int mlx5e_rep_indr_setup_block_cb(enum tc_setup_type type,
 	}
 }
 
+static void mlx5e_rep_indr_tc_block_unbind(void *cb_priv)
+{
+	struct mlx5e_rep_indr_block_priv *indr_priv = cb_priv;
+
+	list_del(&indr_priv->list);
+	kfree(indr_priv);
+}
+
+static LIST_HEAD(mlx5e_block_cb_list);
+
 static int
 mlx5e_rep_indr_setup_tc_block(struct net_device *netdev,
 			      struct mlx5e_rep_priv *rpriv,
-			      struct tc_block_offload *f)
+			      struct flow_block_offload *f)
 {
 	struct mlx5e_rep_indr_block_priv *indr_priv;
-	int err = 0;
+	struct flow_block_cb *block_cb;
 
 	if (f->binder_type != FLOW_BLOCK_BINDER_TYPE_CLSACT_INGRESS)
 		return -EOPNOTSUPP;
 
+	f->driver_block_list = &mlx5e_block_cb_list;
+
 	switch (f->command) {
 	case FLOW_BLOCK_BIND:
 		indr_priv = mlx5e_rep_indr_block_priv_lookup(rpriv, netdev);
@@ -718,26 +730,32 @@ mlx5e_rep_indr_setup_tc_block(struct net_device *netdev,
 		list_add(&indr_priv->list,
 			 &rpriv->uplink_priv.tc_indr_block_priv_list);
 
-		err = tcf_block_cb_register(f->block,
-					    mlx5e_rep_indr_setup_block_cb,
-					    indr_priv, indr_priv, f->extack);
-		if (err) {
+		block_cb = flow_block_cb_alloc(f->net,
+					       mlx5e_rep_indr_setup_block_cb,
+					       indr_priv, indr_priv,
+					       mlx5e_rep_indr_tc_block_unbind);
+		if (IS_ERR(block_cb)) {
 			list_del(&indr_priv->list);
 			kfree(indr_priv);
+			return PTR_ERR(block_cb);
 		}
+		flow_block_cb_add(block_cb, f);
+		list_add_tail(&block_cb->driver_list, &mlx5e_block_cb_list);
 
-		return err;
+		return 0;
 	case FLOW_BLOCK_UNBIND:
 		indr_priv = mlx5e_rep_indr_block_priv_lookup(rpriv, netdev);
 		if (!indr_priv)
 			return -ENOENT;
 
-		tcf_block_cb_unregister(f->block,
-					mlx5e_rep_indr_setup_block_cb,
-					indr_priv);
-		list_del(&indr_priv->list);
-		kfree(indr_priv);
+		block_cb = flow_block_cb_lookup(f,
+						mlx5e_rep_indr_setup_block_cb,
+						indr_priv);
+		if (!block_cb)
+			return -ENOENT;
 
+		flow_block_cb_remove(block_cb, f);
+		list_del(&block_cb->driver_list);
 		return 0;
 	default:
 		return -EOPNOTSUPP;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index a178d082f061..65bea6be84d6 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -1585,33 +1585,45 @@ static int mlxsw_sp_setup_tc_block_cb_flower(enum tc_setup_type type,
 	}
 }
 
+static void mlxsw_sp_tc_block_flower_release(void *cb_priv)
+{
+	struct mlxsw_sp_acl_block *acl_block = cb_priv;
+
+	mlxsw_sp_acl_block_destroy(acl_block);
+}
+
+static LIST_HEAD(mlxsw_sp_block_cb_list);
+
 static int
 mlxsw_sp_setup_tc_block_flower_bind(struct mlxsw_sp_port *mlxsw_sp_port,
-				    struct tcf_block *block, bool ingress,
-				    struct netlink_ext_ack *extack)
+			            struct flow_block_offload *f, bool ingress)
 {
 	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
 	struct mlxsw_sp_acl_block *acl_block;
-	struct tcf_block_cb *block_cb;
+	struct flow_block_cb *block_cb;
+	bool register_block = false;
 	int err;
 
-	block_cb = tcf_block_cb_lookup(block, mlxsw_sp_setup_tc_block_cb_flower,
-				       mlxsw_sp);
+	block_cb = flow_block_cb_lookup(f, mlxsw_sp_setup_tc_block_cb_flower,
+					mlxsw_sp);
 	if (!block_cb) {
-		acl_block = mlxsw_sp_acl_block_create(mlxsw_sp, block->net);
+		acl_block = mlxsw_sp_acl_block_create(mlxsw_sp, f->net);
 		if (!acl_block)
 			return -ENOMEM;
-		block_cb = __tcf_block_cb_register(block,
-						   mlxsw_sp_setup_tc_block_cb_flower,
-						   mlxsw_sp, acl_block, extack);
+		block_cb = flow_block_cb_alloc(f->net,
+					       mlxsw_sp_setup_tc_block_cb_flower,
+					       mlxsw_sp, acl_block,
+					       mlxsw_sp_tc_block_flower_release);
 		if (IS_ERR(block_cb)) {
+			mlxsw_sp_acl_block_destroy(acl_block);
 			err = PTR_ERR(block_cb);
 			goto err_cb_register;
 		}
+		register_block = true;
 	} else {
-		acl_block = tcf_block_cb_priv(block_cb);
+		acl_block = flow_block_cb_priv(block_cb);
 	}
-	tcf_block_cb_incref(block_cb);
+	flow_block_cb_incref(block_cb);
 	err = mlxsw_sp_acl_block_bind(mlxsw_sp, acl_block,
 				      mlxsw_sp_port, ingress);
 	if (err)
@@ -1622,28 +1634,31 @@ mlxsw_sp_setup_tc_block_flower_bind(struct mlxsw_sp_port *mlxsw_sp_port,
 	else
 		mlxsw_sp_port->eg_acl_block = acl_block;
 
+	if (register_block) {
+		flow_block_cb_add(block_cb, f);
+		list_add_tail(&block_cb->driver_list, &mlxsw_sp_block_cb_list);
+	}
+
 	return 0;
 
 err_block_bind:
-	if (!tcf_block_cb_decref(block_cb)) {
-		__tcf_block_cb_unregister(block, block_cb);
+	if (!flow_block_cb_decref(block_cb))
+		flow_block_cb_free(block_cb);
 err_cb_register:
-		mlxsw_sp_acl_block_destroy(acl_block);
-	}
 	return err;
 }
 
 static void
 mlxsw_sp_setup_tc_block_flower_unbind(struct mlxsw_sp_port *mlxsw_sp_port,
-				      struct tcf_block *block, bool ingress)
+				      struct flow_block_offload *f, bool ingress)
 {
 	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
 	struct mlxsw_sp_acl_block *acl_block;
-	struct tcf_block_cb *block_cb;
+	struct flow_block_cb *block_cb;
 	int err;
 
-	block_cb = tcf_block_cb_lookup(block, mlxsw_sp_setup_tc_block_cb_flower,
-				       mlxsw_sp);
+	block_cb = flow_block_cb_lookup(f, mlxsw_sp_setup_tc_block_cb_flower,
+					mlxsw_sp);
 	if (!block_cb)
 		return;
 
@@ -1652,18 +1667,19 @@ mlxsw_sp_setup_tc_block_flower_unbind(struct mlxsw_sp_port *mlxsw_sp_port,
 	else
 		mlxsw_sp_port->eg_acl_block = NULL;
 
-	acl_block = tcf_block_cb_priv(block_cb);
+	acl_block = flow_block_cb_priv(block_cb);
 	err = mlxsw_sp_acl_block_unbind(mlxsw_sp, acl_block,
 					mlxsw_sp_port, ingress);
-	if (!err && !tcf_block_cb_decref(block_cb)) {
-		__tcf_block_cb_unregister(block, block_cb);
-		mlxsw_sp_acl_block_destroy(acl_block);
+	if (!err && !flow_block_cb_decref(block_cb)) {
+		flow_block_cb_remove(block_cb, f);
+		list_del(&block_cb->driver_list);
 	}
 }
 
 static int mlxsw_sp_setup_tc_block(struct mlxsw_sp_port *mlxsw_sp_port,
-				   struct tc_block_offload *f)
+				   struct flow_block_offload *f)
 {
+	struct flow_block_cb *block_cb;
 	tc_setup_cb_t *cb;
 	bool ingress;
 	int err;
@@ -1678,24 +1694,32 @@ static int mlxsw_sp_setup_tc_block(struct mlxsw_sp_port *mlxsw_sp_port,
 		return -EOPNOTSUPP;
 	}
 
+	f->driver_block_list = &mlxsw_sp_block_cb_list;
+
 	switch (f->command) {
 	case FLOW_BLOCK_BIND:
-		err = tcf_block_cb_register(f->block, cb, mlxsw_sp_port,
-					    mlxsw_sp_port, f->extack);
-		if (err)
-			return err;
-		err = mlxsw_sp_setup_tc_block_flower_bind(mlxsw_sp_port,
-							  f->block, ingress,
-							  f->extack);
+		block_cb = flow_block_cb_alloc(f->net, cb, mlxsw_sp_port,
+					       mlxsw_sp_port, NULL);
+		if (IS_ERR(block_cb))
+			return PTR_ERR(block_cb);
+		err = mlxsw_sp_setup_tc_block_flower_bind(mlxsw_sp_port, f,
+							  ingress);
 		if (err) {
-			tcf_block_cb_unregister(f->block, cb, mlxsw_sp_port);
+			flow_block_cb_free(block_cb);
 			return err;
 		}
+		flow_block_cb_add(block_cb, f);
+		list_add_tail(&block_cb->driver_list, &mlxsw_sp_block_cb_list);
 		return 0;
 	case FLOW_BLOCK_UNBIND:
 		mlxsw_sp_setup_tc_block_flower_unbind(mlxsw_sp_port,
-						      f->block, ingress);
-		tcf_block_cb_unregister(f->block, cb, mlxsw_sp_port);
+						      f, ingress);
+		block_cb = flow_block_cb_lookup(f, cb, mlxsw_sp_port);
+		if (!block_cb)
+			return -ENOENT;
+
+		flow_block_cb_remove(block_cb, f);
+		list_del(&block_cb->driver_list);
 		return 0;
 	default:
 		return -EOPNOTSUPP;
diff --git a/drivers/net/ethernet/mscc/ocelot_ace.h b/drivers/net/ethernet/mscc/ocelot_ace.h
index d621683643e1..e98944c87259 100644
--- a/drivers/net/ethernet/mscc/ocelot_ace.h
+++ b/drivers/net/ethernet/mscc/ocelot_ace.h
@@ -225,8 +225,8 @@ int ocelot_ace_init(struct ocelot *ocelot);
 void ocelot_ace_deinit(void);
 
 int ocelot_setup_tc_block_flower_bind(struct ocelot_port *port,
-				      struct tc_block_offload *f);
+				      struct flow_block_offload *f);
 void ocelot_setup_tc_block_flower_unbind(struct ocelot_port *port,
-					 struct tc_block_offload *f);
+					 struct flow_block_offload *f);
 
 #endif /* _MSCC_OCELOT_ACE_H_ */
diff --git a/drivers/net/ethernet/mscc/ocelot_flower.c b/drivers/net/ethernet/mscc/ocelot_flower.c
index b682f08a93b4..5b92c2a03f3d 100644
--- a/drivers/net/ethernet/mscc/ocelot_flower.c
+++ b/drivers/net/ethernet/mscc/ocelot_flower.c
@@ -299,36 +299,45 @@ static void ocelot_port_block_destroy(struct ocelot_port_block *block)
 	kfree(block);
 }
 
+static void ocelot_tc_block_unbind(void *cb_priv)
+{
+	struct ocelot_port_block *port_block = cb_priv;
+
+	ocelot_port_block_destroy(port_block);
+}
+
 int ocelot_setup_tc_block_flower_bind(struct ocelot_port *port,
-				      struct tc_block_offload *f)
+				      struct flow_block_offload *f)
 {
 	struct ocelot_port_block *port_block;
-	struct tcf_block_cb *block_cb;
+	struct flow_block_cb *block_cb;
 	int ret;
 
 	if (f->binder_type == FLOW_BLOCK_BINDER_TYPE_CLSACT_EGRESS)
 		return -EOPNOTSUPP;
 
-	block_cb = tcf_block_cb_lookup(f->block,
-				       ocelot_setup_tc_block_cb_flower, port);
+	block_cb = flow_block_cb_lookup(f, ocelot_setup_tc_block_cb_flower,
+					port);
 	if (!block_cb) {
 		port_block = ocelot_port_block_create(port);
 		if (!port_block)
 			return -ENOMEM;
 
-		block_cb =
-			__tcf_block_cb_register(f->block,
-						ocelot_setup_tc_block_cb_flower,
-						port, port_block, f->extack);
+		block_cb = flow_block_cb_alloc(f->net,
+					       ocelot_setup_tc_block_cb_flower,
+					       port, port_block,
+					       ocelot_tc_block_unbind);
 		if (IS_ERR(block_cb)) {
 			ret = PTR_ERR(block_cb);
 			goto err_cb_register;
 		}
+		flow_block_cb_add(block_cb, f);
+		list_add_tail(&block_cb->driver_list, f->driver_block_list);
 	} else {
-		port_block = tcf_block_cb_priv(block_cb);
+		port_block = flow_block_cb_priv(block_cb);
 	}
 
-	tcf_block_cb_incref(block_cb);
+	flow_block_cb_incref(block_cb);
 	return 0;
 
 err_cb_register:
@@ -338,20 +347,17 @@ int ocelot_setup_tc_block_flower_bind(struct ocelot_port *port,
 }
 
 void ocelot_setup_tc_block_flower_unbind(struct ocelot_port *port,
-					 struct tc_block_offload *f)
+					 struct flow_block_offload *f)
 {
-	struct ocelot_port_block *port_block;
-	struct tcf_block_cb *block_cb;
+	struct flow_block_cb *block_cb;
 
-	block_cb = tcf_block_cb_lookup(f->block,
-				       ocelot_setup_tc_block_cb_flower, port);
+	block_cb = flow_block_cb_lookup(f, ocelot_setup_tc_block_cb_flower,
+					port);
 	if (!block_cb)
 		return;
 
-	port_block = tcf_block_cb_priv(block_cb);
-	if (!tcf_block_cb_decref(block_cb)) {
-		tcf_block_cb_unregister(f->block,
-					ocelot_setup_tc_block_cb_flower, port);
-		ocelot_port_block_destroy(port_block);
+	if (!flow_block_cb_decref(block_cb)) {
+		flow_block_cb_remove(block_cb, f);
+		list_del(&block_cb->driver_list);
 	}
 }
diff --git a/drivers/net/ethernet/mscc/ocelot_tc.c b/drivers/net/ethernet/mscc/ocelot_tc.c
index 58a0b5f8850c..935a774cb291 100644
--- a/drivers/net/ethernet/mscc/ocelot_tc.c
+++ b/drivers/net/ethernet/mscc/ocelot_tc.c
@@ -128,35 +128,51 @@ static int ocelot_setup_tc_block_cb_eg(enum tc_setup_type type,
 					cb_priv, false);
 }
 
+static LIST_HEAD(ocelot_block_cb_list);
+
 static int ocelot_setup_tc_block(struct ocelot_port *port,
-				 struct tc_block_offload *f)
+				 struct flow_block_offload *f)
 {
+	struct flow_block_cb *block_cb;
 	tc_setup_cb_t *cb;
-	int ret;
+	int err;
 
 	netdev_dbg(port->dev, "tc_block command %d, binder_type %d\n",
 		   f->command, f->binder_type);
 
 	if (f->binder_type == FLOW_BLOCK_BINDER_TYPE_CLSACT_INGRESS) {
 		cb = ocelot_setup_tc_block_cb_ig;
-		port->tc.block_shared = tcf_block_shared(f->block);
+		port->tc.block_shared = f->block_shared;
 	} else if (f->binder_type == FLOW_BLOCK_BINDER_TYPE_CLSACT_EGRESS) {
 		cb = ocelot_setup_tc_block_cb_eg;
 	} else {
 		return -EOPNOTSUPP;
 	}
 
+	f->driver_block_list = &ocelot_block_cb_list;
+
 	switch (f->command) {
 	case FLOW_BLOCK_BIND:
-		ret = tcf_block_cb_register(f->block, cb, port,
-					    port, f->extack);
-		if (ret)
-			return ret;
+		block_cb = flow_block_cb_alloc(f->net, cb, port, port, NULL);
+		if (IS_ERR(block_cb))
+			return PTR_ERR(block_cb);
 
-		return ocelot_setup_tc_block_flower_bind(port, f);
+		err = ocelot_setup_tc_block_flower_bind(port, f);
+		if (err < 0) {
+			flow_block_cb_free(block_cb);
+			return err;
+		}
+		flow_block_cb_add(block_cb, f);
+		list_add_tail(&block_cb->driver_list, f->driver_block_list);
+		return 0;
 	case FLOW_BLOCK_UNBIND:
+		block_cb = flow_block_cb_lookup(f, cb, port);
+		if (!block_cb)
+			return -ENOENT;
+
 		ocelot_setup_tc_block_flower_unbind(port, f);
-		tcf_block_cb_unregister(f->block, cb, port);
+		flow_block_cb_remove(block_cb, f);
+		list_del(&block_cb->driver_list);
 		return 0;
 	default:
 		return -EOPNOTSUPP;
diff --git a/drivers/net/ethernet/netronome/nfp/abm/cls.c b/drivers/net/ethernet/netronome/nfp/abm/cls.c
index 29fb45734962..23ebddfb9532 100644
--- a/drivers/net/ethernet/netronome/nfp/abm/cls.c
+++ b/drivers/net/ethernet/netronome/nfp/abm/cls.c
@@ -262,9 +262,12 @@ static int nfp_abm_setup_tc_block_cb(enum tc_setup_type type,
 	}
 }
 
+static LIST_HEAD(nfp_abm_block_cb_list);
+
 int nfp_abm_setup_cls_block(struct net_device *netdev, struct nfp_repr *repr,
-			    struct tc_block_offload *f)
+			    struct flow_block_offload *f)
 {
-	return flow_block_cb_setup_simple(f, NULL, nfp_abm_setup_tc_block_cb,
+	return flow_block_cb_setup_simple(f, &nfp_abm_block_cb_list,
+					  nfp_abm_setup_tc_block_cb,
 					  repr, repr, true);
 }
diff --git a/drivers/net/ethernet/netronome/nfp/abm/main.h b/drivers/net/ethernet/netronome/nfp/abm/main.h
index 49749c60885e..48746c9c6224 100644
--- a/drivers/net/ethernet/netronome/nfp/abm/main.h
+++ b/drivers/net/ethernet/netronome/nfp/abm/main.h
@@ -247,7 +247,7 @@ int nfp_abm_setup_tc_mq(struct net_device *netdev, struct nfp_abm_link *alink,
 int nfp_abm_setup_tc_gred(struct net_device *netdev, struct nfp_abm_link *alink,
 			  struct tc_gred_qopt_offload *opt);
 int nfp_abm_setup_cls_block(struct net_device *netdev, struct nfp_repr *repr,
-			    struct tc_block_offload *opt);
+			    struct flow_block_offload *opt);
 
 int nfp_abm_ctrl_read_params(struct nfp_abm_link *alink);
 int nfp_abm_ctrl_find_addrs(struct nfp_abm *abm);
diff --git a/drivers/net/ethernet/netronome/nfp/bpf/main.c b/drivers/net/ethernet/netronome/nfp/bpf/main.c
index 0c93c84a188a..1c9fb11470df 100644
--- a/drivers/net/ethernet/netronome/nfp/bpf/main.c
+++ b/drivers/net/ethernet/netronome/nfp/bpf/main.c
@@ -160,6 +160,8 @@ static int nfp_bpf_setup_tc_block_cb(enum tc_setup_type type,
 	return 0;
 }
 
+static LIST_HEAD(nfp_bpf_block_cb_list);
+
 static int nfp_bpf_setup_tc(struct nfp_app *app, struct net_device *netdev,
 			    enum tc_setup_type type, void *type_data)
 {
@@ -167,7 +169,8 @@ static int nfp_bpf_setup_tc(struct nfp_app *app, struct net_device *netdev,
 
 	switch (type) {
 	case TC_SETUP_BLOCK:
-		return flow_block_cb_setup_simple(type_data, NULL,
+		return flow_block_cb_setup_simple(type_data,
+						  &nfp_bpf_block_cb_list,
 						  nfp_bpf_setup_tc_block_cb,
 						  nn, nn, true);
 	default:
diff --git a/drivers/net/ethernet/netronome/nfp/flower/offload.c b/drivers/net/ethernet/netronome/nfp/flower/offload.c
index 46041e509150..ddd6b509f27e 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/offload.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/offload.c
@@ -1302,27 +1302,41 @@ static int nfp_flower_setup_tc_block_cb(enum tc_setup_type type,
 	}
 }
 
+static LIST_HEAD(nfp_block_cb_list);
+
 static int nfp_flower_setup_tc_block(struct net_device *netdev,
-				     struct tc_block_offload *f)
+				     struct flow_block_offload *f)
 {
 	struct nfp_repr *repr = netdev_priv(netdev);
 	struct nfp_flower_repr_priv *repr_priv;
+	struct flow_block_cb *block_cb;
 
 	if (f->binder_type != FLOW_BLOCK_BINDER_TYPE_CLSACT_INGRESS)
 		return -EOPNOTSUPP;
 
 	repr_priv = repr->app_priv;
-	repr_priv->block_shared = tcf_block_shared(f->block);
+	repr_priv->block_shared = f->block_shared;
+	f->driver_block_list = &nfp_block_cb_list;
 
 	switch (f->command) {
 	case FLOW_BLOCK_BIND:
-		return tcf_block_cb_register(f->block,
-					     nfp_flower_setup_tc_block_cb,
-					     repr, repr, f->extack);
+		block_cb = flow_block_cb_alloc(f->net,
+					       nfp_flower_setup_tc_block_cb,
+					       repr, repr, NULL);
+		if (IS_ERR(block_cb))
+			return PTR_ERR(block_cb);
+
+		flow_block_cb_add(block_cb, f);
+		list_add_tail(&block_cb->driver_list, &nfp_block_cb_list);
+		return 0;
 	case FLOW_BLOCK_UNBIND:
-		tcf_block_cb_unregister(f->block,
-					nfp_flower_setup_tc_block_cb,
-					repr);
+		block_cb = flow_block_cb_lookup(f, nfp_flower_setup_tc_block_cb,
+						repr);
+		if (!block_cb)
+			return -ENOENT;
+
+		flow_block_cb_remove(block_cb, f);
+		list_del(&block_cb->driver_list);
 		return 0;
 	default:
 		return -EOPNOTSUPP;
@@ -1381,13 +1395,21 @@ static int nfp_flower_setup_indr_block_cb(enum tc_setup_type type,
 	}
 }
 
+static void nfp_flower_setup_indr_tc_release(void *cb_priv)
+{
+	struct nfp_flower_indr_block_cb_priv *priv = cb_priv;
+
+	list_del(&priv->list);
+	kfree(priv);
+}
+
 static int
 nfp_flower_setup_indr_tc_block(struct net_device *netdev, struct nfp_app *app,
-			       struct tc_block_offload *f)
+			       struct flow_block_offload *f)
 {
 	struct nfp_flower_indr_block_cb_priv *cb_priv;
 	struct nfp_flower_priv *priv = app->priv;
-	int err;
+	struct flow_block_cb *block_cb;
 
 	if (f->binder_type != FLOW_BLOCK_BINDER_TYPE_CLSACT_INGRESS &&
 	    !(f->binder_type == FLOW_BLOCK_BINDER_TYPE_CLSACT_EGRESS &&
@@ -1404,26 +1426,32 @@ nfp_flower_setup_indr_tc_block(struct net_device *netdev, struct nfp_app *app,
 		cb_priv->app = app;
 		list_add(&cb_priv->list, &priv->indr_block_cb_priv);
 
-		err = tcf_block_cb_register(f->block,
-					    nfp_flower_setup_indr_block_cb,
-					    cb_priv, cb_priv, f->extack);
-		if (err) {
+		block_cb = flow_block_cb_alloc(f->net,
+					       nfp_flower_setup_indr_block_cb,
+					       cb_priv, cb_priv,
+					       nfp_flower_setup_indr_tc_release);
+		if (IS_ERR(block_cb)) {
 			list_del(&cb_priv->list);
 			kfree(cb_priv);
+			return PTR_ERR(block_cb);
 		}
 
-		return err;
+		flow_block_cb_add(block_cb, f);
+		list_add_tail(&block_cb->driver_list, &nfp_block_cb_list);
+		return 0;
 	case FLOW_BLOCK_UNBIND:
 		cb_priv = nfp_flower_indr_block_cb_priv_lookup(app, netdev);
 		if (!cb_priv)
 			return -ENOENT;
 
-		tcf_block_cb_unregister(f->block,
-					nfp_flower_setup_indr_block_cb,
-					cb_priv);
-		list_del(&cb_priv->list);
-		kfree(cb_priv);
+		block_cb = flow_block_cb_lookup(f,
+						nfp_flower_setup_indr_block_cb,
+						cb_priv);
+		if (!block_cb)
+			return -ENOENT;
 
+		flow_block_cb_remove(block_cb, f);
+		list_del(&block_cb->driver_list);
 		return 0;
 	default:
 		return -EOPNOTSUPP;
diff --git a/drivers/net/ethernet/qlogic/qede/qede_main.c b/drivers/net/ethernet/qlogic/qede/qede_main.c
index cba97ed3dd56..1be593a6e20d 100644
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
@@ -588,7 +590,8 @@ qede_setup_tc_offload(struct net_device *dev, enum tc_setup_type type,
 
 	switch (type) {
 	case TC_SETUP_BLOCK:
-		return flow_block_cb_setup_simple(type_data, NULL,
+		return flow_block_cb_setup_simple(type_data,
+						  &qede_block_cb_list,
 						  qede_setup_tc_block_cb,
 						  edev, edev, true);
 	case TC_SETUP_QDISC_MQPRIO:
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 0040f10bbef9..cc3bfb59c8df 100644
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
@@ -3860,7 +3862,8 @@ static int stmmac_setup_tc(struct net_device *ndev, enum tc_setup_type type,
 
 	switch (type) {
 	case TC_SETUP_BLOCK:
-		return flow_block_cb_setup_simple(type_data, NULL,
+		return flow_block_cb_setup_simple(type_data,
+						  &stmmac_block_cb_list,
 						  stmmac_setup_tc_block_cb,
 						  priv, priv, true);
 	case TC_SETUP_QDISC_CBS:
diff --git a/drivers/net/netdevsim/netdev.c b/drivers/net/netdevsim/netdev.c
index 920dc79e9dc9..0740940f41b1 100644
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
@@ -210,7 +212,8 @@ nsim_setup_tc(struct net_device *dev, enum tc_setup_type type, void *type_data)
 
 	switch (type) {
 	case TC_SETUP_BLOCK:
-		return flow_block_cb_setup_simple(type_data, NULL,
+		return flow_block_cb_setup_simple(type_data,
+						  &nsim_block_cb_list,
 						  nsim_setup_tc_block_cb,
 						  ns, ns, true);
 	default:
diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index 79b88c42962d..e8ff62ba1d8f 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -244,13 +244,12 @@ enum flow_block_binder_type {
 	FLOW_BLOCK_BINDER_TYPE_CLSACT_EGRESS,
 };
 
-struct tcf_block;
 struct netlink_ext_ack;
 
 struct flow_block_offload {
 	enum flow_block_command command;
 	enum flow_block_binder_type binder_type;
-	struct tcf_block *block;
+	bool block_shared;
 	struct net *net;
 	struct list_head cb_list;
 	struct list_head *driver_block_list;
diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index e4499526fde8..9cf606b88526 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -26,8 +26,6 @@ struct tcf_walker {
 int register_tcf_proto_ops(struct tcf_proto_ops *ops);
 int unregister_tcf_proto_ops(struct tcf_proto_ops *ops);
 
-#define tc_block_offload flow_block_offload
-
 struct tcf_block_ext_info {
 	enum flow_block_binder_type binder_type;
 	tcf_chain_head_change_t *chain_head_change;
diff --git a/net/core/flow_offload.c b/net/core/flow_offload.c
index a36a9dc1c6df..a1b36b47dd89 100644
--- a/net/core/flow_offload.c
+++ b/net/core/flow_offload.c
@@ -2,7 +2,6 @@
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <net/flow_offload.h>
-#include <net/pkt_cls.h>
 
 struct flow_rule *flow_rule_alloc(unsigned int num_actions)
 {
@@ -234,6 +233,8 @@ int flow_block_cb_setup_simple(struct flow_block_offload *f,
 			       tc_setup_cb_t *cb, void *cb_ident, void *cb_priv,
 			       bool ingress_only)
 {
+	struct flow_block_cb *block_cb;
+
 	if (ingress_only &&
 	    f->binder_type != FLOW_BLOCK_BINDER_TYPE_CLSACT_INGRESS)
 		return -EOPNOTSUPP;
@@ -242,10 +243,21 @@ int flow_block_cb_setup_simple(struct flow_block_offload *f,
 
 	switch (f->command) {
 	case FLOW_BLOCK_BIND:
-		return tcf_block_cb_register(f->block, cb, cb_ident, cb_priv,
-					     f->extack);
+		block_cb = flow_block_cb_alloc(f->net, cb, cb_ident,
+					       cb_priv, NULL);
+		if (IS_ERR(block_cb))
+			return PTR_ERR(block_cb);
+
+		flow_block_cb_add(block_cb, f);
+		list_add_tail(&block_cb->driver_list, driver_block_list);
+		return 0;
 	case FLOW_BLOCK_UNBIND:
-		tcf_block_cb_unregister(f->block, cb, cb_ident);
+		block_cb = flow_block_cb_lookup(f, cb, cb_ident);
+		if (!block_cb)
+			return -ENOENT;
+
+		flow_block_cb_remove(block_cb, f);
+		list_del(&block_cb->driver_list);
 		return 0;
 	default:
 		return -EOPNOTSUPP;
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 9b5e202c255e..90c32fd680db 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -942,9 +942,12 @@ static int dsa_slave_setup_tc_block_cb_eg(enum tc_setup_type type,
 	return dsa_slave_setup_tc_block_cb(type, type_data, cb_priv, false);
 }
 
+static LIST_HEAD(dsa_slave_block_cb_list);
+
 static int dsa_slave_setup_tc_block(struct net_device *dev,
-				    struct tc_block_offload *f)
+				    struct flow_block_offload *f)
 {
+	struct flow_block_cb *block_cb;
 	tc_setup_cb_t *cb;
 
 	if (f->binder_type == FLOW_BLOCK_BINDER_TYPE_CLSACT_INGRESS)
@@ -954,11 +957,24 @@ static int dsa_slave_setup_tc_block(struct net_device *dev,
 	else
 		return -EOPNOTSUPP;
 
+	f->driver_block_list = &dsa_slave_block_cb_list;
+
 	switch (f->command) {
 	case FLOW_BLOCK_BIND:
-		return tcf_block_cb_register(f->block, cb, dev, dev, f->extack);
+		block_cb = flow_block_cb_alloc(f->net, cb, dev, dev, NULL);
+		if (IS_ERR(block_cb))
+			return PTR_ERR(block_cb);
+
+		flow_block_cb_add(block_cb, f);
+		list_add_tail(&block_cb->driver_list, &dsa_slave_block_cb_list);
+		return 0;
 	case FLOW_BLOCK_UNBIND:
-		tcf_block_cb_unregister(f->block, cb, dev);
+		block_cb = flow_block_cb_lookup(f, cb, dev);
+		if (!block_cb)
+			return -ENOENT;
+
+		flow_block_cb_remove(block_cb, f);
+		list_del(&block_cb->driver_list);
 		return 0;
 	default:
 		return -EOPNOTSUPP;
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index db13944cc823..2f78b80c8251 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -679,11 +679,11 @@ static void tc_indr_block_ing_cmd(struct tc_indr_block_dev *indr_dev,
 				  struct tc_indr_block_cb *indr_block_cb,
 				  enum flow_block_command command)
 {
-	struct tc_block_offload bo = {
+	struct flow_block_offload bo = {
 		.command	= command,
 		.binder_type	= FLOW_BLOCK_BINDER_TYPE_CLSACT_INGRESS,
 		.net		= dev_net(indr_dev->dev),
-		.block		= indr_dev->block,
+		.block_shared	= tcf_block_shared(indr_dev->block),
 	};
 	INIT_LIST_HEAD(&bo.cb_list);
 
@@ -770,11 +770,11 @@ static void tc_indr_block_call(struct tcf_block *block, struct net_device *dev,
 {
 	struct tc_indr_block_cb *indr_block_cb;
 	struct tc_indr_block_dev *indr_dev;
-	struct tc_block_offload bo = {
+	struct flow_block_offload bo = {
 		.command	= command,
 		.binder_type	= ei->binder_type,
 		.net		= dev_net(dev),
-		.block		= block,
+		.block_shared	= tcf_block_shared(block),
 		.extack		= extack,
 	};
 	INIT_LIST_HEAD(&bo.cb_list);
@@ -803,13 +803,13 @@ static int tcf_block_offload_cmd(struct tcf_block *block,
 				 enum flow_block_command command,
 				 struct netlink_ext_ack *extack)
 {
-	struct tc_block_offload bo = {};
+	struct flow_block_offload bo = {};
 	int err;
 
 	bo.net = dev_net(dev);
 	bo.command = command;
 	bo.binder_type = ei->binder_type;
-	bo.block = block;
+	bo.block_shared = tcf_block_shared(block);
 	bo.extack = extack;
 	INIT_LIST_HEAD(&bo.cb_list);
 
@@ -3244,7 +3244,7 @@ EXPORT_SYMBOL(tcf_exts_dump_stats);
 int tc_setup_cb_call(struct tcf_block *block, enum tc_setup_type type,
 		     void *type_data, bool err_stop)
 {
-	struct tcf_block_cb *block_cb;
+	struct flow_block_cb *block_cb;
 	int ok_count = 0;
 	int err;
 
-- 
2.11.0


