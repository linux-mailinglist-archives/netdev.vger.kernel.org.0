Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2ABC718E44
	for <lists+netdev@lfdr.de>; Thu,  9 May 2019 18:40:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726784AbfEIQk3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 May 2019 12:40:29 -0400
Received: from mail.us.es ([193.147.175.20]:35442 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726187AbfEIQk3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 May 2019 12:40:29 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E7B571D94A1
        for <netdev@vger.kernel.org>; Thu,  9 May 2019 18:40:20 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CACEFDA715
        for <netdev@vger.kernel.org>; Thu,  9 May 2019 18:40:20 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id ADEFADA71A; Thu,  9 May 2019 18:40:20 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A5835DA707;
        Thu,  9 May 2019 18:40:15 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 09 May 2019 18:40:15 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [31.4.199.18])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id A60784265A32;
        Thu,  9 May 2019 18:40:13 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        thomas.lendacky@amd.com, f.fainelli@gmail.com,
        ariel.elior@cavium.com, michael.chan@broadcom.com,
        santosh@chelsio.com, madalin.bucur@nxp.com,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jeffrey.t.kirsher@intel.com, tariqt@mellanox.com,
        saeedm@mellanox.com, jiri@mellanox.com, idosch@mellanox.com,
        jakub.kicinski@netronome.com, peppe.cavallaro@st.com,
        grygorii.strashko@ti.com, andrew@lunn.ch,
        vivien.didelot@savoirfairelinux.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, linux-net-drivers@solarflare.com,
        ganeshgr@chelsio.com, ogerlitz@mellanox.com,
        Manish.Chopra@cavium.com, marcelo.leitner@gmail.com,
        mkubecek@suse.cz, venkatkumar.duvvuru@broadcom.com,
        julia.lawall@lip6.fr, john.fastabend@gmail.com
Subject: [PATCH net-next,RFC 1/2] net: flow_offload: add flow_block_cb API
Date:   Thu,  9 May 2019 18:39:50 +0200
Message-Id: <20190509163954.13703-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190509163954.13703-1-pablo@netfilter.org>
References: <20190509163954.13703-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch renames:

* struct tcf_block_cb to flow_block_cb.
* struct tc_block_offload to flow_block_offload.

And it exposes the flow_block_cb API through net/flow_offload.h. This
renames the existing codebase to adapt it to this name.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |  22 ++--
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c     |  54 ++++----
 drivers/net/ethernet/netronome/nfp/abm/cls.c       |   2 +-
 drivers/net/ethernet/netronome/nfp/abm/main.h      |   2 +-
 .../net/ethernet/netronome/nfp/flower/offload.c    |  18 +--
 include/net/flow_offload.h                         |  48 +++++++
 include/net/pkt_cls.h                              |  40 +-----
 net/core/flow_offload.c                            |  77 ++++++++++++
 net/dsa/slave.c                                    |   2 +-
 net/sched/cls_api.c                                | 140 +++++----------------
 10 files changed, 207 insertions(+), 198 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 897ca33496ad..e84d17fa5dce 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -708,10 +708,10 @@ static void mlx5e_rep_indr_tc_block_unbind(void *cb_priv)
 static int
 mlx5e_rep_indr_setup_tc_block(struct net_device *netdev,
 			      struct mlx5e_rep_priv *rpriv,
-			      struct tc_block_offload *f)
+			      struct flow_block_offload *f)
 {
 	struct mlx5e_rep_indr_block_priv *indr_priv;
-	struct tcf_block_cb *block_cb;
+	struct flow_block_cb *block_cb;
 
 	if (f->binder_type != TCF_BLOCK_BINDER_TYPE_CLSACT_INGRESS)
 		return -EOPNOTSUPP;
@@ -731,15 +731,15 @@ mlx5e_rep_indr_setup_tc_block(struct net_device *netdev,
 		list_add(&indr_priv->list,
 			 &rpriv->uplink_priv.tc_indr_block_priv_list);
 
-		block_cb = tcf_block_cb_alloc(f->block_index,
-					      mlx5e_rep_indr_setup_block_cb,
-					      indr_priv, indr_priv,
-					      mlx5e_rep_indr_tc_block_unbind);
+		block_cb = flow_block_cb_alloc(f->block_index,
+					       mlx5e_rep_indr_setup_block_cb,
+					       indr_priv, indr_priv,
+					       mlx5e_rep_indr_tc_block_unbind);
 		if (!block_cb) {
 			list_del(&indr_priv->list);
 			kfree(indr_priv);
 		}
-		tcf_block_cb_add(block_cb, f);
+		flow_block_cb_add(block_cb, f);
 
 		return 0;
 	case TC_BLOCK_UNBIND:
@@ -747,13 +747,13 @@ mlx5e_rep_indr_setup_tc_block(struct net_device *netdev,
 		if (!indr_priv)
 			return -ENOENT;
 
-		block_cb = tcf_block_cb_lookup(f->block_index,
-					       mlx5e_rep_indr_setup_block_cb,
-					       indr_priv);
+		block_cb = flow_block_cb_lookup(f->block_index,
+						mlx5e_rep_indr_setup_block_cb,
+						indr_priv);
 		if (!block_cb)
 			return -ENOENT;
 
-		tcf_block_cb_remove(block_cb, f);
+		flow_block_cb_remove(block_cb, f);
 		return 0;
 	default:
 		return -EOPNOTSUPP;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index c5d483b01261..735d6cc56fb3 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -1523,22 +1523,22 @@ static void mlxsw_sp_tc_block_flower_release(void *cb_priv)
 
 static int
 mlxsw_sp_setup_tc_block_flower_bind(struct mlxsw_sp_port *mlxsw_sp_port,
-			            struct tc_block_offload *f, bool ingress)
+			            struct flow_block_offload *f, bool ingress)
 {
 	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
 	struct net *net = dev_net(mlxsw_sp_port->dev);
 	struct mlxsw_sp_acl_block *acl_block;
-	struct tcf_block_cb *block_cb;
+	struct flow_block_cb *block_cb;
 	int err;
 
-	block_cb = tcf_block_cb_lookup(f->block_index,
-				       mlxsw_sp_setup_tc_block_cb_flower,
-				       mlxsw_sp);
+	block_cb = flow_block_cb_lookup(f->block_index,
+					mlxsw_sp_setup_tc_block_cb_flower,
+					mlxsw_sp);
 	if (!block_cb) {
 		acl_block = mlxsw_sp_acl_block_create(mlxsw_sp, net);
 		if (!acl_block)
 			return -ENOMEM;
-		block_cb = tcf_block_cb_alloc(f->block_index,
+		block_cb = flow_block_cb_alloc(f->block_index,
 					      mlxsw_sp_setup_tc_block_cb_flower,
 					      mlxsw_sp, acl_block,
 					      mlxsw_sp_tc_block_flower_release);
@@ -1548,9 +1548,9 @@ mlxsw_sp_setup_tc_block_flower_bind(struct mlxsw_sp_port *mlxsw_sp_port,
 			goto err_cb_register;
 		}
 	} else {
-		acl_block = tcf_block_cb_priv(block_cb);
+		acl_block = flow_block_cb_priv(block_cb);
 	}
-	tcf_block_cb_incref(block_cb);
+	flow_block_cb_incref(block_cb);
 	err = mlxsw_sp_acl_block_bind(mlxsw_sp, acl_block,
 				      mlxsw_sp_port, ingress);
 	if (err)
@@ -1561,26 +1561,27 @@ mlxsw_sp_setup_tc_block_flower_bind(struct mlxsw_sp_port *mlxsw_sp_port,
 	else
 		mlxsw_sp_port->eg_acl_block = acl_block;
 
-	tcf_block_cb_add(block_cb, f);
+	flow_block_cb_add(block_cb, f);
 	return 0;
 
 err_block_bind:
-	if (!tcf_block_cb_decref(block_cb))
-		tcf_block_cb_free(block_cb);
+	if (!flow_block_cb_decref(block_cb))
+		flow_block_cb_free(block_cb);
 err_cb_register:
 	return err;
 }
 
 static void
 mlxsw_sp_setup_tc_block_flower_unbind(struct mlxsw_sp_port *mlxsw_sp_port,
-				      struct tc_block_offload *f, bool ingress)
+				      struct flow_block_offload *f,
+				      bool ingress)
 {
 	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
 	struct mlxsw_sp_acl_block *acl_block;
-	struct tcf_block_cb *block_cb;
+	struct flow_block_cb *block_cb;
 	int err;
 
-	block_cb = tcf_block_cb_lookup(f->block_index,
+	block_cb = flow_block_cb_lookup(f->block_index,
 				       mlxsw_sp_setup_tc_block_cb_flower,
 				       mlxsw_sp);
 	if (!block_cb)
@@ -1591,17 +1592,17 @@ mlxsw_sp_setup_tc_block_flower_unbind(struct mlxsw_sp_port *mlxsw_sp_port,
 	else
 		mlxsw_sp_port->eg_acl_block = NULL;
 
-	acl_block = tcf_block_cb_priv(block_cb);
+	acl_block = flow_block_cb_priv(block_cb);
 	err = mlxsw_sp_acl_block_unbind(mlxsw_sp, acl_block,
 					mlxsw_sp_port, ingress);
-	if (!err && !tcf_block_cb_decref(block_cb))
-		tcf_block_cb_remove(block_cb, f);
+	if (!err && !flow_block_cb_decref(block_cb))
+		flow_block_cb_remove(block_cb, f);
 }
 
 static int mlxsw_sp_setup_tc_block(struct mlxsw_sp_port *mlxsw_sp_port,
-				   struct tc_block_offload *f)
+				   struct flow_block_offload *f)
 {
-	struct tcf_block_cb *block_cb;
+	struct flow_block_cb *block_cb;
 	tc_setup_cb_t *cb;
 	bool ingress;
 	int err;
@@ -1618,27 +1619,28 @@ static int mlxsw_sp_setup_tc_block(struct mlxsw_sp_port *mlxsw_sp_port,
 
 	switch (f->command) {
 	case TC_BLOCK_BIND:
-		block_cb = tcf_block_cb_alloc(f->block_index, cb, mlxsw_sp_port,
-					 mlxsw_sp_port, NULL);
+		block_cb = flow_block_cb_alloc(f->block_index, cb,
+					       mlxsw_sp_port, mlxsw_sp_port,
+					       NULL);
 		if (!block_cb)
 			return -ENOMEM;
 		err = mlxsw_sp_setup_tc_block_flower_bind(mlxsw_sp_port, f,
 							  ingress);
 		if (err) {
-			tcf_block_cb_free(block_cb);
+			flow_block_cb_free(block_cb);
 			return err;
 		}
-		tcf_block_cb_add(block_cb, f);
+		flow_block_cb_add(block_cb, f);
 		return 0;
 	case TC_BLOCK_UNBIND:
 		mlxsw_sp_setup_tc_block_flower_unbind(mlxsw_sp_port,
 						      f, ingress);
-		block_cb = tcf_block_cb_lookup(f->block_index, cb,
-					       mlxsw_sp_port);
+		block_cb = flow_block_cb_lookup(f->block_index, cb,
+						mlxsw_sp_port);
 		if (!block_cb)
 			return -ENOENT;
 
-		tcf_block_cb_remove(block_cb, f);
+		flow_block_cb_remove(block_cb, f);
 		return 0;
 	default:
 		return -EOPNOTSUPP;
diff --git a/drivers/net/ethernet/netronome/nfp/abm/cls.c b/drivers/net/ethernet/netronome/nfp/abm/cls.c
index 371b800df878..66d46bc616b3 100644
--- a/drivers/net/ethernet/netronome/nfp/abm/cls.c
+++ b/drivers/net/ethernet/netronome/nfp/abm/cls.c
@@ -263,7 +263,7 @@ static int nfp_abm_setup_tc_block_cb(enum tc_setup_type type,
 }
 
 int nfp_abm_setup_cls_block(struct net_device *netdev, struct nfp_repr *repr,
-			    struct tc_block_offload *f)
+			    struct flow_block_offload *f)
 {
 	return tcf_setup_block_offload(f, nfp_abm_setup_tc_block_cb, repr, repr,
 				       true);
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
diff --git a/drivers/net/ethernet/netronome/nfp/flower/offload.c b/drivers/net/ethernet/netronome/nfp/flower/offload.c
index 4bdfb48c4a3a..a91138ec7175 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/offload.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/offload.c
@@ -1256,11 +1256,11 @@ static void nfp_flower_setup_indr_tc_release(void *cb_priv)
 
 static int
 nfp_flower_setup_indr_tc_block(struct net_device *netdev, struct nfp_app *app,
-			       struct tc_block_offload *f)
+			       struct flow_block_offload *f)
 {
 	struct nfp_flower_indr_block_cb_priv *cb_priv;
 	struct nfp_flower_priv *priv = app->priv;
-	struct tcf_block_cb *block_cb;
+	struct flow_block_cb *block_cb;
 
 	if (f->binder_type != TCF_BLOCK_BINDER_TYPE_CLSACT_INGRESS &&
 	    !(f->binder_type == TCF_BLOCK_BINDER_TYPE_CLSACT_EGRESS &&
@@ -1277,29 +1277,29 @@ nfp_flower_setup_indr_tc_block(struct net_device *netdev, struct nfp_app *app,
 		cb_priv->app = app;
 		list_add(&cb_priv->list, &priv->indr_block_cb_priv);
 
-		block_cb = tcf_block_cb_alloc(f->block_index,
-					      nfp_flower_setup_indr_block_cb,
-					      cb_priv, cb_priv,
-					      nfp_flower_setup_indr_tc_release);
+		block_cb = flow_block_cb_alloc(f->block_index,
+					       nfp_flower_setup_indr_block_cb,
+					       cb_priv, cb_priv,
+					       nfp_flower_setup_indr_tc_release);
 		if (!block_cb) {
 			list_del(&cb_priv->list);
 			kfree(cb_priv);
 		}
 
-		tcf_block_cb_add(block_cb, f);
+		flow_block_cb_add(block_cb, f);
 		return 0;
 	case TC_BLOCK_UNBIND:
 		cb_priv = nfp_flower_indr_block_cb_priv_lookup(app, netdev);
 		if (!cb_priv)
 			return -ENOENT;
 
-		block_cb = tcf_block_cb_lookup(f->block_index,
+		block_cb = flow_block_cb_lookup(f->block_index,
 					       nfp_flower_setup_indr_block_cb,
 					       cb_priv);
 		if (!block_cb)
 			return -ENOENT;
 
-		tcf_block_cb_remove(block_cb, f);
+		flow_block_cb_remove(block_cb, f);
 		return 0;
 	default:
 		return -EOPNOTSUPP;
diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index d035183c8d03..3136992b11fe 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -200,4 +200,52 @@ static inline void flow_stats_update(struct flow_stats *flow_stats,
 	flow_stats->lastused	= max_t(u64, flow_stats->lastused, lastused);
 }
 
+#include <net/sch_generic.h> /* for tc_setup_cb_t. */
+
+enum flow_block_command {
+	TC_BLOCK_BIND,
+	TC_BLOCK_UNBIND,
+};
+
+enum flow_block_binder_type {
+	TCF_BLOCK_BINDER_TYPE_UNSPEC,
+	TCF_BLOCK_BINDER_TYPE_CLSACT_INGRESS,
+	TCF_BLOCK_BINDER_TYPE_CLSACT_EGRESS,
+};
+
+struct flow_block_offload {
+	enum flow_block_command command;
+	enum flow_block_binder_type binder_type;
+	struct list_head cb_list;
+	u32 block_index;
+	struct netlink_ext_ack *extack;
+};
+
+struct flow_block_cb {
+	struct list_head global_list;
+	struct list_head list;
+	tc_setup_cb_t *cb;
+	void (*release)(void *cb_priv);
+	void *cb_ident;
+	void *cb_priv;
+	u32 block_index;
+	unsigned int refcnt;
+};
+
+struct flow_block_cb *flow_block_cb_alloc(u32 block_index, tc_setup_cb_t *cb,
+					  void *cb_ident, void *cb_priv,
+					  void (*release)(void *cb_priv));
+void flow_block_cb_free(struct flow_block_cb *block_cb);
+void *flow_block_cb_priv(struct flow_block_cb *block_cb);
+struct flow_block_cb *flow_block_cb_lookup(u32 block_index, tc_setup_cb_t *cb,
+					   void *cb_ident);
+void flow_block_cb_incref(struct flow_block_cb *block_cb);
+unsigned int flow_block_cb_decref(struct flow_block_cb *block_cb);
+void flow_block_cb_add(struct flow_block_cb *block_cb,
+		       struct flow_block_offload *offload);
+void flow_block_cb_remove(struct flow_block_cb *block_cb,
+			  struct flow_block_offload *offload);
+
+extern struct list_head flow_block_cb_list;
+
 #endif /* _NET_FLOW_OFFLOAD_H */
diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index 097659b61a93..1d952bd30c38 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -25,14 +25,8 @@ struct tcf_walker {
 int register_tcf_proto_ops(struct tcf_proto_ops *ops);
 int unregister_tcf_proto_ops(struct tcf_proto_ops *ops);
 
-enum tcf_block_binder_type {
-	TCF_BLOCK_BINDER_TYPE_UNSPEC,
-	TCF_BLOCK_BINDER_TYPE_CLSACT_INGRESS,
-	TCF_BLOCK_BINDER_TYPE_CLSACT_EGRESS,
-};
-
 struct tcf_block_ext_info {
-	enum tcf_block_binder_type binder_type;
+	enum flow_block_binder_type binder_type;
 	tcf_chain_head_change_t *chain_head_change;
 	void *chain_head_change_priv;
 	u32 block_index;
@@ -71,23 +65,6 @@ static inline struct Qdisc *tcf_block_q(struct tcf_block *block)
 	return block->q;
 }
 
-struct tcf_block_cb *tcf_block_cb_alloc(u32 block_index, tc_setup_cb_t *cb,
-					void *cb_ident, void *cb_priv,
-					void (*release)(void *cb_priv));
-void tcf_block_cb_free(struct tcf_block_cb *block_cb);
-
-struct tc_block_offload;
-void tcf_block_cb_add(struct tcf_block_cb *block_cb,
-		      struct tc_block_offload *offload);
-void tcf_block_cb_remove(struct tcf_block_cb *block_cb,
-			 struct tc_block_offload *offload);
-
-void *tcf_block_cb_priv(struct tcf_block_cb *block_cb);
-struct tcf_block_cb *tcf_block_cb_lookup(u32 block_index, tc_setup_cb_t *cb,
-					 void *cb_ident);
-void tcf_block_cb_incref(struct tcf_block_cb *block_cb);
-unsigned int tcf_block_cb_decref(struct tcf_block_cb *block_cb);
-
 int __tc_indr_block_cb_register(struct net_device *dev, void *cb_priv,
 				tc_indr_block_bind_cb_t *cb, void *cb_ident);
 int tc_indr_block_cb_register(struct net_device *dev, void *cb_priv,
@@ -633,20 +610,9 @@ int tc_setup_cb_call(struct tcf_block *block, enum tc_setup_type type,
 		     void *type_data, bool err_stop);
 unsigned int tcf_exts_num_actions(struct tcf_exts *exts);
 
-enum tc_block_command {
-	TC_BLOCK_BIND,
-	TC_BLOCK_UNBIND,
-};
-
-struct tc_block_offload {
-	enum tc_block_command command;
-	enum tcf_block_binder_type binder_type;
-	struct list_head cb_list;
-	u32 block_index;
-	struct netlink_ext_ack *extack;
-};
+struct flow_block_offload;
 
-int tcf_setup_block_offload(struct tc_block_offload *f, tc_setup_cb_t *cb,
+int tcf_setup_block_offload(struct flow_block_offload *f, tc_setup_cb_t *cb,
 			    void *cb_ident, void *cb_priv, bool ingress_only);
 
 struct tc_cls_common_offload {
diff --git a/net/core/flow_offload.c b/net/core/flow_offload.c
index c3a00eac4804..63fa0b470227 100644
--- a/net/core/flow_offload.c
+++ b/net/core/flow_offload.c
@@ -151,3 +151,80 @@ void flow_rule_match_enc_opts(const struct flow_rule *rule,
 	FLOW_DISSECTOR_MATCH(rule, FLOW_DISSECTOR_KEY_ENC_OPTS, out);
 }
 EXPORT_SYMBOL(flow_rule_match_enc_opts);
+
+void *flow_block_cb_priv(struct flow_block_cb *block_cb)
+{
+	return block_cb->cb_priv;
+}
+EXPORT_SYMBOL(flow_block_cb_priv);
+
+LIST_HEAD(flow_block_cb_list);
+EXPORT_SYMBOL(flow_block_cb_list);
+
+struct flow_block_cb *flow_block_cb_lookup(u32 block_index, tc_setup_cb_t *cb,
+					   void *cb_ident)
+{	struct flow_block_cb *block_cb;
+
+	list_for_each_entry(block_cb, &flow_block_cb_list, list)
+		if (block_cb->block_index == block_index &&
+		    block_cb->cb == cb &&
+		    block_cb->cb_ident == cb_ident)
+			return block_cb;
+	return NULL;
+}
+EXPORT_SYMBOL(flow_block_cb_lookup);
+
+void flow_block_cb_incref(struct flow_block_cb *block_cb)
+{
+	block_cb->refcnt++;
+}
+EXPORT_SYMBOL(flow_block_cb_incref);
+
+unsigned int flow_block_cb_decref(struct flow_block_cb *block_cb)
+{
+	return --block_cb->refcnt;
+}
+EXPORT_SYMBOL(flow_block_cb_decref);
+
+struct flow_block_cb *flow_block_cb_alloc(u32 block_index, tc_setup_cb_t *cb,
+					  void *cb_ident, void *cb_priv,
+					  void (*release)(void *cb_priv))
+{
+	struct flow_block_cb *block_cb;
+
+	block_cb = kzalloc(sizeof(*block_cb), GFP_KERNEL);
+	if (!block_cb)
+		return NULL;
+
+	block_cb->cb = cb;
+	block_cb->cb_ident = cb_ident;
+	block_cb->release = release;
+	block_cb->cb_priv = cb_priv;
+	block_cb->block_index = block_index;
+
+	return block_cb;
+}
+EXPORT_SYMBOL(flow_block_cb_alloc);
+
+void flow_block_cb_free(struct flow_block_cb *block_cb)
+{
+	if (block_cb->release)
+		block_cb->release(block_cb->cb_priv);
+
+	kfree(block_cb);
+}
+EXPORT_SYMBOL(flow_block_cb_free);
+
+void flow_block_cb_add(struct flow_block_cb *block_cb,
+		       struct flow_block_offload *offload)
+{
+	list_add(&block_cb->global_list, &offload->cb_list);
+}
+EXPORT_SYMBOL(flow_block_cb_add);
+
+void flow_block_cb_remove(struct flow_block_cb *block_cb,
+			  struct flow_block_offload *offload)
+{
+	list_move(&block_cb->global_list, &offload->cb_list);
+}
+EXPORT_SYMBOL(flow_block_cb_remove);
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 9df447c68493..68a548744399 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -900,7 +900,7 @@ static int dsa_slave_setup_tc_block_cb_eg(enum tc_setup_type type,
 }
 
 static int dsa_slave_setup_tc_block(struct net_device *dev,
-				    struct tc_block_offload *f)
+				    struct flow_block_offload *f)
 {
 	struct tcf_block_cb *block_cb;
 	tc_setup_cb_t *cb;
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index a54c8aa608d8..391a977f0332 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -31,6 +31,7 @@
 #include <net/netlink.h>
 #include <net/pkt_sched.h>
 #include <net/pkt_cls.h>
+#include <net/flow_offload.h>
 #include <net/tc_act/tc_pedit.h>
 #include <net/tc_act/tc_mirred.h>
 #include <net/tc_act/tc_vlan.h>
@@ -712,96 +713,10 @@ static bool tcf_block_offload_in_use(struct tcf_block *block)
 	return block->offloadcnt;
 }
 
-struct tcf_block_cb {
-	struct list_head global_list;
-	struct list_head list;
-	tc_setup_cb_t *cb;
-	void (*release)(void *cb_priv);
-	void *cb_ident;
-	void *cb_priv;
-	u32 block_index;
-	unsigned int refcnt;
-};
-
-void *tcf_block_cb_priv(struct tcf_block_cb *block_cb)
-{
-	return block_cb->cb_priv;
-}
-EXPORT_SYMBOL(tcf_block_cb_priv);
-
-static LIST_HEAD(tcf_block_cb_list);
-
-struct tcf_block_cb *tcf_block_cb_lookup(u32 block_index, tc_setup_cb_t *cb,
-					 void *cb_ident)
-{	struct tcf_block_cb *block_cb;
-
-	list_for_each_entry(block_cb, &tcf_block_cb_list, list)
-		if (block_cb->block_index == block_index &&
-		    block_cb->cb == cb &&
-		    block_cb->cb_ident == cb_ident)
-			return block_cb;
-	return NULL;
-}
-EXPORT_SYMBOL(tcf_block_cb_lookup);
-
-void tcf_block_cb_incref(struct tcf_block_cb *block_cb)
-{
-	block_cb->refcnt++;
-}
-EXPORT_SYMBOL(tcf_block_cb_incref);
-
-unsigned int tcf_block_cb_decref(struct tcf_block_cb *block_cb)
-{
-	return --block_cb->refcnt;
-}
-EXPORT_SYMBOL(tcf_block_cb_decref);
-
-struct tcf_block_cb *tcf_block_cb_alloc(u32 block_index, tc_setup_cb_t *cb,
-					void *cb_ident, void *cb_priv,
-					void (*release)(void *cb_priv))
-{
-	struct tcf_block_cb *block_cb;
-
-	block_cb = kzalloc(sizeof(*block_cb), GFP_KERNEL);
-	if (!block_cb)
-		return NULL;
-
-	block_cb->cb = cb;
-	block_cb->cb_ident = cb_ident;
-	block_cb->release = release;
-	block_cb->cb_priv = cb_priv;
-	block_cb->block_index = block_index;
-
-	return block_cb;
-}
-EXPORT_SYMBOL(tcf_block_cb_alloc);
-
-void tcf_block_cb_free(struct tcf_block_cb *block_cb)
-{
-	if (block_cb->release)
-		block_cb->release(block_cb->cb_priv);
-
-	kfree(block_cb);
-}
-EXPORT_SYMBOL(tcf_block_cb_free);
-
-void tcf_block_cb_add(struct tcf_block_cb *block_cb,
-		      struct tc_block_offload *offload)
-{
-	list_add(&block_cb->global_list, &offload->cb_list);
-}
-EXPORT_SYMBOL(tcf_block_cb_add);
-
-void tcf_block_cb_remove(struct tcf_block_cb *block_cb,
-			 struct tc_block_offload *offload)
-{
-	list_move(&block_cb->global_list, &offload->cb_list);
-}
-EXPORT_SYMBOL(tcf_block_cb_remove);
-
-static int tcf_block_bind(struct tcf_block *block, struct tc_block_offload *bo)
+static int tcf_block_bind(struct tcf_block *block,
+			  struct flow_block_offload *bo)
 {
-	struct tcf_block_cb *block_cb, *failed_cb;
+	struct flow_block_cb *block_cb, *failed_cb;
 	int err, i = 0;
 
 	list_for_each_entry(block_cb, &bo->cb_list, global_list) {
@@ -816,7 +731,7 @@ static int tcf_block_bind(struct tcf_block *block, struct tc_block_offload *bo)
 		list_add(&block_cb->list, &block->cb_list);
 		i++;
 	}
-	list_splice(&bo->cb_list, &tcf_block_cb_list);
+	list_splice(&bo->cb_list, &flow_block_cb_list);
 
 	return 0;
 
@@ -836,9 +751,9 @@ static int tcf_block_bind(struct tcf_block *block, struct tc_block_offload *bo)
 }
 
 static void tcf_block_unbind(struct tcf_block *block,
-			     struct tc_block_offload *bo)
+			     struct flow_block_offload *bo)
 {
-	struct tcf_block_cb *block_cb, *next;
+	struct flow_block_cb *block_cb, *next;
 
 	list_for_each_entry_safe(block_cb, next, &bo->cb_list, global_list) {
 		list_del(&block_cb->global_list);
@@ -847,11 +762,12 @@ static void tcf_block_unbind(struct tcf_block *block,
 					    tcf_block_offload_in_use(block),
 					    NULL);
 		list_del(&block_cb->list);
-		tcf_block_cb_free(block_cb);
+		flow_block_cb_free(block_cb);
 	}
 }
 
-static int tcf_block_setup(struct tcf_block *block, struct tc_block_offload *bo)
+static int tcf_block_setup(struct tcf_block *block,
+			   struct flow_block_offload *bo)
 {
 	int err;
 
@@ -871,10 +787,10 @@ static int tcf_block_setup(struct tcf_block *block, struct tc_block_offload *bo)
 	return err;
 }
 
-int tcf_setup_block_offload(struct tc_block_offload *f, tc_setup_cb_t *cb,
+int tcf_setup_block_offload(struct flow_block_offload *f, tc_setup_cb_t *cb,
 			    void *cb_ident, void *cb_priv, bool ingress_only)
 {
-	struct tcf_block_cb *block_cb;
+	struct flow_block_cb *block_cb;
 
 	if (ingress_only &&
 	    f->binder_type != TCF_BLOCK_BINDER_TYPE_CLSACT_INGRESS)
@@ -882,19 +798,19 @@ int tcf_setup_block_offload(struct tc_block_offload *f, tc_setup_cb_t *cb,
 
 	switch (f->command) {
 	case TC_BLOCK_BIND:
-		block_cb = tcf_block_cb_alloc(f->block_index, cb, cb_ident,
-					      cb_priv, NULL);
+		block_cb = flow_block_cb_alloc(f->block_index, cb, cb_ident,
+					       cb_priv, NULL);
 		if (!block_cb)
 			return -ENOMEM;
 
-		tcf_block_cb_add(block_cb, f);
+		flow_block_cb_add(block_cb, f);
 		return 0;
 	case TC_BLOCK_UNBIND:
-		block_cb = tcf_block_cb_lookup(f->block_index, cb, cb_ident);
+		block_cb = flow_block_cb_lookup(f->block_index, cb, cb_ident);
 		if (!block_cb)
 			return -ENOENT;
 
-		tcf_block_cb_remove(block_cb, f);
+		flow_block_cb_remove(block_cb, f);
 		return 0;
 	default:
 		return -EOPNOTSUPP;
@@ -1011,9 +927,9 @@ static void tc_indr_block_cb_del(struct tc_indr_block_cb *indr_block_cb)
 
 static void tc_indr_block_ing_cmd(struct tc_indr_block_dev *indr_dev,
 				  struct tc_indr_block_cb *indr_block_cb,
-				  enum tc_block_command command)
+				  enum flow_block_command command)
 {
-	struct tc_block_offload bo = {
+	struct flow_block_offload bo = {
 		.command	= command,
 		.binder_type	= TCF_BLOCK_BINDER_TYPE_CLSACT_INGRESS,
 		.block_index	= indr_dev->block->index,
@@ -1098,12 +1014,12 @@ EXPORT_SYMBOL_GPL(tc_indr_block_cb_unregister);
 
 static void tc_indr_block_call(struct tcf_block *block, struct net_device *dev,
 			       struct tcf_block_ext_info *ei,
-			       enum tc_block_command command,
+			       enum flow_block_command command,
 			       struct netlink_ext_ack *extack)
 {
 	struct tc_indr_block_cb *indr_block_cb;
 	struct tc_indr_block_dev *indr_dev;
-	struct tc_block_offload bo = {
+	struct flow_block_offload bo = {
 		.command	= command,
 		.binder_type	= ei->binder_type,
 		.block_index	= block->index,
@@ -1127,10 +1043,10 @@ static void tc_indr_block_call(struct tcf_block *block, struct net_device *dev,
 static int tcf_block_offload_cmd(struct tcf_block *block,
 				 struct net_device *dev,
 				 struct tcf_block_ext_info *ei,
-				 enum tc_block_command command,
+				 enum flow_block_command command,
 				 struct netlink_ext_ack *extack)
 {
-	struct tc_block_offload bo = {};
+	struct flow_block_offload bo = {};
 	int err;
 
 	bo.command = command;
@@ -1586,13 +1502,13 @@ static void tcf_block_release(struct Qdisc *q, struct tcf_block *block,
 struct tcf_block_owner_item {
 	struct list_head list;
 	struct Qdisc *q;
-	enum tcf_block_binder_type binder_type;
+	enum flow_block_binder_type binder_type;
 };
 
 static void
 tcf_block_owner_netif_keep_dst(struct tcf_block *block,
 			       struct Qdisc *q,
-			       enum tcf_block_binder_type binder_type)
+			       enum flow_block_binder_type binder_type)
 {
 	if (block->keep_dst &&
 	    binder_type != TCF_BLOCK_BINDER_TYPE_CLSACT_INGRESS &&
@@ -1613,7 +1529,7 @@ EXPORT_SYMBOL(tcf_block_netif_keep_dst);
 
 static int tcf_block_owner_add(struct tcf_block *block,
 			       struct Qdisc *q,
-			       enum tcf_block_binder_type binder_type)
+			       enum flow_block_binder_type binder_type)
 {
 	struct tcf_block_owner_item *item;
 
@@ -1628,7 +1544,7 @@ static int tcf_block_owner_add(struct tcf_block *block,
 
 static void tcf_block_owner_del(struct tcf_block *block,
 				struct Qdisc *q,
-				enum tcf_block_binder_type binder_type)
+				enum flow_block_binder_type binder_type)
 {
 	struct tcf_block_owner_item *item;
 
@@ -3258,7 +3174,7 @@ EXPORT_SYMBOL(tcf_exts_dump_stats);
 int tc_setup_cb_call(struct tcf_block *block, enum tc_setup_type type,
 		     void *type_data, bool err_stop)
 {
-	struct tcf_block_cb *block_cb;
+	struct flow_block_cb *block_cb;
 	int ok_count = 0;
 	int err;
 
-- 
2.11.0


