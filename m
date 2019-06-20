Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 684DB4DA9E
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 21:50:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726973AbfFTTtr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 15:49:47 -0400
Received: from mail.us.es ([193.147.175.20]:54020 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726956AbfFTTtp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Jun 2019 15:49:45 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9EF4FB60DA
        for <netdev@vger.kernel.org>; Thu, 20 Jun 2019 21:49:43 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 808D6DA705
        for <netdev@vger.kernel.org>; Thu, 20 Jun 2019 21:49:43 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 69B07DA701; Thu, 20 Jun 2019 21:49:43 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 426B6DA714;
        Thu, 20 Jun 2019 21:49:39 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 20 Jun 2019 21:49:39 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id F36D84265A2F;
        Thu, 20 Jun 2019 21:49:37 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netdev@vger.kernel.org
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
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
        cphealy@gmail.com
Subject: [PATCH net-next 07/12] net: use tcf_block_setup() infrastructure
Date:   Thu, 20 Jun 2019 21:49:12 +0200
Message-Id: <20190620194917.2298-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190620194917.2298-1-pablo@netfilter.org>
References: <20190620194917.2298-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This allows us to register / unregister tcf_block_cb objects from the
core. The idea is to allocate and to set up the tcf_block_cb objects
from the driver, attach them to the tc_block_offload->cb_list, then the
core iterates over this block list to registers them.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   | 34 ++++++----
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c     | 74 +++++++++++++---------
 drivers/net/ethernet/mscc/ocelot_flower.c          | 37 ++++++-----
 drivers/net/ethernet/mscc/ocelot_tc.c              | 24 +++++--
 .../net/ethernet/netronome/nfp/flower/offload.c    | 57 ++++++++++++-----
 include/net/pkt_cls.h                              | 13 ++--
 net/dsa/slave.c                                    | 14 +++-
 net/sched/cls_api.c                                | 42 ++++++++----
 8 files changed, 195 insertions(+), 100 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 17d67a956642..9507334b9d77 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -703,13 +703,21 @@ static int mlx5e_rep_indr_setup_block_cb(enum tc_setup_type type,
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
 static int
 mlx5e_rep_indr_setup_tc_block(struct net_device *netdev,
 			      struct mlx5e_rep_priv *rpriv,
 			      struct tc_block_offload *f)
 {
 	struct mlx5e_rep_indr_block_priv *indr_priv;
-	int err = 0;
+	struct tcf_block_cb *block_cb;
 
 	if (f->binder_type != TCF_BLOCK_BINDER_TYPE_CLSACT_INGRESS)
 		return -EOPNOTSUPP;
@@ -729,26 +737,30 @@ mlx5e_rep_indr_setup_tc_block(struct net_device *netdev,
 		list_add(&indr_priv->list,
 			 &rpriv->uplink_priv.tc_indr_block_priv_list);
 
-		err = tcf_block_cb_register(f->block,
-					    mlx5e_rep_indr_setup_block_cb,
-					    indr_priv, indr_priv, f->extack);
-		if (err) {
+		block_cb = tcf_block_cb_alloc(f->net,
+					      mlx5e_rep_indr_setup_block_cb,
+					      indr_priv, indr_priv,
+					      mlx5e_rep_indr_tc_block_unbind);
+		if (!block_cb) {
 			list_del(&indr_priv->list);
 			kfree(indr_priv);
+			return -ENOMEM;
 		}
+		tcf_block_cb_add(block_cb, f);
 
-		return err;
+		return 0;
 	case TC_BLOCK_UNBIND:
 		indr_priv = mlx5e_rep_indr_block_priv_lookup(rpriv, netdev);
 		if (!indr_priv)
 			return -ENOENT;
 
-		tcf_block_cb_unregister(f->block,
-					mlx5e_rep_indr_setup_block_cb,
-					indr_priv);
-		list_del(&indr_priv->list);
-		kfree(indr_priv);
+		block_cb = tcf_block_cb_lookup(f->net,
+					       mlx5e_rep_indr_setup_block_cb,
+					       indr_priv);
+		if (!block_cb)
+			return -ENOENT;
 
+		tcf_block_cb_remove(block_cb, f);
 		return 0;
 	default:
 		return -EOPNOTSUPP;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 3e8593824b33..dbd31f4acb70 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -1554,29 +1554,40 @@ static int mlxsw_sp_setup_tc_block_cb_flower(enum tc_setup_type type,
 	}
 }
 
+static void mlxsw_sp_tc_block_flower_release(void *cb_priv)
+{
+	struct mlxsw_sp_acl_block *acl_block = cb_priv;
+
+	mlxsw_sp_acl_block_destroy(acl_block);
+}
+
 static int
 mlxsw_sp_setup_tc_block_flower_bind(struct mlxsw_sp_port *mlxsw_sp_port,
-				    struct tcf_block *block, bool ingress,
-				    struct netlink_ext_ack *extack)
+			            struct tc_block_offload *f, bool ingress)
 {
 	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
 	struct mlxsw_sp_acl_block *acl_block;
 	struct tcf_block_cb *block_cb;
+	bool register_block = false;
 	int err;
 
-	block_cb = tcf_block_cb_lookup(block, mlxsw_sp_setup_tc_block_cb_flower,
+	block_cb = tcf_block_cb_lookup(f->net,
+				       mlxsw_sp_setup_tc_block_cb_flower,
 				       mlxsw_sp);
 	if (!block_cb) {
-		acl_block = mlxsw_sp_acl_block_create(mlxsw_sp, block->net);
+		acl_block = mlxsw_sp_acl_block_create(mlxsw_sp, f->net);
 		if (!acl_block)
 			return -ENOMEM;
-		block_cb = __tcf_block_cb_register(block,
-						   mlxsw_sp_setup_tc_block_cb_flower,
-						   mlxsw_sp, acl_block, extack);
-		if (IS_ERR(block_cb)) {
-			err = PTR_ERR(block_cb);
+		block_cb = tcf_block_cb_alloc(f->net,
+					      mlxsw_sp_setup_tc_block_cb_flower,
+					      mlxsw_sp, acl_block,
+					      mlxsw_sp_tc_block_flower_release);
+		if (!block_cb) {
+			mlxsw_sp_acl_block_destroy(acl_block);
+			err = -ENOMEM;
 			goto err_cb_register;
 		}
+		register_block = true;
 	} else {
 		acl_block = tcf_block_cb_priv(block_cb);
 	}
@@ -1591,27 +1602,29 @@ mlxsw_sp_setup_tc_block_flower_bind(struct mlxsw_sp_port *mlxsw_sp_port,
 	else
 		mlxsw_sp_port->eg_acl_block = acl_block;
 
+	if (register_block)
+		tcf_block_cb_add(block_cb, f);
+
 	return 0;
 
 err_block_bind:
-	if (!tcf_block_cb_decref(block_cb)) {
-		__tcf_block_cb_unregister(block, block_cb);
+	if (!tcf_block_cb_decref(block_cb))
+		tcf_block_cb_free(block_cb);
 err_cb_register:
-		mlxsw_sp_acl_block_destroy(acl_block);
-	}
 	return err;
 }
 
 static void
 mlxsw_sp_setup_tc_block_flower_unbind(struct mlxsw_sp_port *mlxsw_sp_port,
-				      struct tcf_block *block, bool ingress)
+				      struct tc_block_offload *f, bool ingress)
 {
 	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
 	struct mlxsw_sp_acl_block *acl_block;
 	struct tcf_block_cb *block_cb;
 	int err;
 
-	block_cb = tcf_block_cb_lookup(block, mlxsw_sp_setup_tc_block_cb_flower,
+	block_cb = tcf_block_cb_lookup(f->net,
+				       mlxsw_sp_setup_tc_block_cb_flower,
 				       mlxsw_sp);
 	if (!block_cb)
 		return;
@@ -1624,15 +1637,14 @@ mlxsw_sp_setup_tc_block_flower_unbind(struct mlxsw_sp_port *mlxsw_sp_port,
 	acl_block = tcf_block_cb_priv(block_cb);
 	err = mlxsw_sp_acl_block_unbind(mlxsw_sp, acl_block,
 					mlxsw_sp_port, ingress);
-	if (!err && !tcf_block_cb_decref(block_cb)) {
-		__tcf_block_cb_unregister(block, block_cb);
-		mlxsw_sp_acl_block_destroy(acl_block);
-	}
+	if (!err && !tcf_block_cb_decref(block_cb))
+		tcf_block_cb_remove(block_cb, f);
 }
 
 static int mlxsw_sp_setup_tc_block(struct mlxsw_sp_port *mlxsw_sp_port,
 				   struct tc_block_offload *f)
 {
+	struct tcf_block_cb *block_cb;
 	tc_setup_cb_t *cb;
 	bool ingress;
 	int err;
@@ -1649,22 +1661,26 @@ static int mlxsw_sp_setup_tc_block(struct mlxsw_sp_port *mlxsw_sp_port,
 
 	switch (f->command) {
 	case TC_BLOCK_BIND:
-		err = tcf_block_cb_register(f->block, cb, mlxsw_sp_port,
-					    mlxsw_sp_port, f->extack);
-		if (err)
-			return err;
-		err = mlxsw_sp_setup_tc_block_flower_bind(mlxsw_sp_port,
-							  f->block, ingress,
-							  f->extack);
+		block_cb = tcf_block_cb_alloc(f->net, cb, mlxsw_sp_port,
+					      mlxsw_sp_port, NULL);
+		if (!block_cb)
+			return -ENOMEM;
+		err = mlxsw_sp_setup_tc_block_flower_bind(mlxsw_sp_port, f,
+							  ingress);
 		if (err) {
-			tcf_block_cb_unregister(f->block, cb, mlxsw_sp_port);
+			tcf_block_cb_free(block_cb);
 			return err;
 		}
+		tcf_block_cb_add(block_cb, f);
 		return 0;
 	case TC_BLOCK_UNBIND:
 		mlxsw_sp_setup_tc_block_flower_unbind(mlxsw_sp_port,
-						      f->block, ingress);
-		tcf_block_cb_unregister(f->block, cb, mlxsw_sp_port);
+						      f, ingress);
+		block_cb = tcf_block_cb_lookup(f->net, cb, mlxsw_sp_port);
+		if (!block_cb)
+			return -ENOENT;
+
+		tcf_block_cb_remove(block_cb, f);
 		return 0;
 	default:
 		return -EOPNOTSUPP;
diff --git a/drivers/net/ethernet/mscc/ocelot_flower.c b/drivers/net/ethernet/mscc/ocelot_flower.c
index 8778dee5a471..ca6751d0b797 100644
--- a/drivers/net/ethernet/mscc/ocelot_flower.c
+++ b/drivers/net/ethernet/mscc/ocelot_flower.c
@@ -299,6 +299,13 @@ static void ocelot_port_block_destroy(struct ocelot_port_block *block)
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
 				      struct tc_block_offload *f)
 {
@@ -309,21 +316,22 @@ int ocelot_setup_tc_block_flower_bind(struct ocelot_port *port,
 	if (f->binder_type == TCF_BLOCK_BINDER_TYPE_CLSACT_EGRESS)
 		return -EOPNOTSUPP;
 
-	block_cb = tcf_block_cb_lookup(f->block,
-				       ocelot_setup_tc_block_cb_flower, port);
+	block_cb = tcf_block_cb_lookup(f->net, ocelot_setup_tc_block_cb_flower,
+				       port);
 	if (!block_cb) {
 		port_block = ocelot_port_block_create(port);
 		if (!port_block)
 			return -ENOMEM;
 
-		block_cb =
-			__tcf_block_cb_register(f->block,
-						ocelot_setup_tc_block_cb_flower,
-						port, port_block, f->extack);
-		if (IS_ERR(block_cb)) {
-			ret = PTR_ERR(block_cb);
+		block_cb = tcf_block_cb_alloc(f->net,
+					      ocelot_setup_tc_block_cb_flower,
+					      port, port_block,
+					      ocelot_tc_block_unbind);
+		if (!block_cb) {
+			ret = -ENOMEM;
 			goto err_cb_register;
 		}
+		tcf_block_cb_add(block_cb, f);
 	} else {
 		port_block = tcf_block_cb_priv(block_cb);
 	}
@@ -340,18 +348,13 @@ int ocelot_setup_tc_block_flower_bind(struct ocelot_port *port,
 void ocelot_setup_tc_block_flower_unbind(struct ocelot_port *port,
 					 struct tc_block_offload *f)
 {
-	struct ocelot_port_block *port_block;
 	struct tcf_block_cb *block_cb;
 
-	block_cb = tcf_block_cb_lookup(f->block,
-				       ocelot_setup_tc_block_cb_flower, port);
+	block_cb = tcf_block_cb_lookup(f->net, ocelot_setup_tc_block_cb_flower,
+				       port);
 	if (!block_cb)
 		return;
 
-	port_block = tcf_block_cb_priv(block_cb);
-	if (!tcf_block_cb_decref(block_cb)) {
-		tcf_block_cb_unregister(f->block,
-					ocelot_setup_tc_block_cb_flower, port);
-		ocelot_port_block_destroy(port_block);
-	}
+	if (!tcf_block_cb_decref(block_cb))
+		tcf_block_cb_remove(block_cb, f);
 }
diff --git a/drivers/net/ethernet/mscc/ocelot_tc.c b/drivers/net/ethernet/mscc/ocelot_tc.c
index 72084306240d..e99865b873df 100644
--- a/drivers/net/ethernet/mscc/ocelot_tc.c
+++ b/drivers/net/ethernet/mscc/ocelot_tc.c
@@ -131,8 +131,9 @@ static int ocelot_setup_tc_block_cb_eg(enum tc_setup_type type,
 static int ocelot_setup_tc_block(struct ocelot_port *port,
 				 struct tc_block_offload *f)
 {
+	struct tcf_block_cb *block_cb;
 	tc_setup_cb_t *cb;
-	int ret;
+	int err;
 
 	netdev_dbg(port->dev, "tc_block command %d, binder_type %d\n",
 		   f->command, f->binder_type);
@@ -148,15 +149,24 @@ static int ocelot_setup_tc_block(struct ocelot_port *port,
 
 	switch (f->command) {
 	case TC_BLOCK_BIND:
-		ret = tcf_block_cb_register(f->block, cb, port,
-					    port, f->extack);
-		if (ret)
-			return ret;
+		block_cb = tcf_block_cb_alloc(f->net, cb, port, port, NULL);
+		if (!block_cb)
+			return -ENOMEM;
 
-		return ocelot_setup_tc_block_flower_bind(port, f);
+		err = ocelot_setup_tc_block_flower_bind(port, f);
+		if (err < 0) {
+			tcf_block_cb_free(block_cb);
+			return err;
+		}
+		tcf_block_cb_add(block_cb, f);
+		return 0;
 	case TC_BLOCK_UNBIND:
+		block_cb = tcf_block_cb_lookup(f->net, cb, port);
+		if (!block_cb)
+			return -ENOENT;
+
 		ocelot_setup_tc_block_flower_unbind(port, f);
-		tcf_block_cb_unregister(f->block, cb, port);
+		tcf_block_cb_remove(block_cb, f);
 		return 0;
 	default:
 		return -EOPNOTSUPP;
diff --git a/drivers/net/ethernet/netronome/nfp/flower/offload.c b/drivers/net/ethernet/netronome/nfp/flower/offload.c
index 39e6599f2bd7..8197bf6358aa 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/offload.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/offload.c
@@ -1264,6 +1264,7 @@ static int nfp_flower_setup_tc_block(struct net_device *netdev,
 {
 	struct nfp_repr *repr = netdev_priv(netdev);
 	struct nfp_flower_repr_priv *repr_priv;
+	struct tcf_block_cb *block_cb;
 
 	if (f->binder_type != TCF_BLOCK_BINDER_TYPE_CLSACT_INGRESS)
 		return -EOPNOTSUPP;
@@ -1273,13 +1274,22 @@ static int nfp_flower_setup_tc_block(struct net_device *netdev,
 
 	switch (f->command) {
 	case TC_BLOCK_BIND:
-		return tcf_block_cb_register(f->block,
-					     nfp_flower_setup_tc_block_cb,
-					     repr, repr, f->extack);
+		block_cb = tcf_block_cb_alloc(f->net,
+					      nfp_flower_setup_tc_block_cb,
+					      repr, repr, NULL);
+		if (!block_cb)
+			return -ENOMEM;
+
+		tcf_block_cb_add(block_cb, f);
+		return 0;
 	case TC_BLOCK_UNBIND:
-		tcf_block_cb_unregister(f->block,
-					nfp_flower_setup_tc_block_cb,
-					repr);
+		block_cb = tcf_block_cb_lookup(f->net,
+					       nfp_flower_setup_tc_block_cb,
+					       repr);
+		if (!block_cb)
+			return -ENOENT;
+
+		tcf_block_cb_remove(block_cb, f);
 		return 0;
 	default:
 		return -EOPNOTSUPP;
@@ -1338,13 +1348,22 @@ static int nfp_flower_setup_indr_block_cb(enum tc_setup_type type,
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
 			       struct tc_block_offload *f)
 {
 	struct nfp_flower_indr_block_cb_priv *cb_priv;
 	struct nfp_flower_priv *priv = app->priv;
-	int err;
+	struct net *net = dev_net(netdev);
+	struct tcf_block_cb *block_cb;
 
 	if (f->binder_type != TCF_BLOCK_BINDER_TYPE_CLSACT_INGRESS &&
 	    !(f->binder_type == TCF_BLOCK_BINDER_TYPE_CLSACT_EGRESS &&
@@ -1361,26 +1380,30 @@ nfp_flower_setup_indr_tc_block(struct net_device *netdev, struct nfp_app *app,
 		cb_priv->app = app;
 		list_add(&cb_priv->list, &priv->indr_block_cb_priv);
 
-		err = tcf_block_cb_register(f->block,
-					    nfp_flower_setup_indr_block_cb,
-					    cb_priv, cb_priv, f->extack);
-		if (err) {
+		block_cb = tcf_block_cb_alloc(net,
+					      nfp_flower_setup_indr_block_cb,
+					      cb_priv, cb_priv,
+					      nfp_flower_setup_indr_tc_release);
+		if (!block_cb) {
 			list_del(&cb_priv->list);
 			kfree(cb_priv);
+			return -ENOMEM;
 		}
 
-		return err;
+		tcf_block_cb_add(block_cb, f);
+		return 0;
 	case TC_BLOCK_UNBIND:
 		cb_priv = nfp_flower_indr_block_cb_priv_lookup(app, netdev);
 		if (!cb_priv)
 			return -ENOENT;
 
-		tcf_block_cb_unregister(f->block,
-					nfp_flower_setup_indr_block_cb,
-					cb_priv);
-		list_del(&cb_priv->list);
-		kfree(cb_priv);
+		block_cb = tcf_block_cb_lookup(net,
+					       nfp_flower_setup_indr_block_cb,
+					       cb_priv);
+		if (!block_cb)
+			return -ENOENT;
 
+		tcf_block_cb_remove(block_cb, f);
 		return 0;
 	default:
 		return -EOPNOTSUPP;
diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index 872b75286431..2f3fac9ccf60 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -72,7 +72,7 @@ static inline struct Qdisc *tcf_block_q(struct tcf_block *block)
 	return block->q;
 }
 
-struct tcf_block_cb *tcf_block_cb_alloc(tc_setup_cb_t *cb,
+struct tcf_block_cb *tcf_block_cb_alloc(struct net *net, tc_setup_cb_t *cb,
 					void *cb_ident, void *cb_priv,
 					void (*release)(void *cb_priv));
 void tcf_block_cb_free(struct tcf_block_cb *block_cb);
@@ -84,8 +84,8 @@ void tcf_block_cb_remove(struct tcf_block_cb *block_cb,
 			 struct tc_block_offload *offload);
 
 void *tcf_block_cb_priv(struct tcf_block_cb *block_cb);
-struct tcf_block_cb *tcf_block_cb_lookup(struct tcf_block *block,
-					 tc_setup_cb_t *cb, void *cb_ident);
+struct tcf_block_cb *tcf_block_cb_lookup(struct net *net, tc_setup_cb_t *cb,
+					 void *cb_ident);
 void tcf_block_cb_incref(struct tcf_block_cb *block_cb);
 unsigned int tcf_block_cb_decref(struct tcf_block_cb *block_cb);
 struct tcf_block_cb *__tcf_block_cb_register(struct tcf_block *block,
@@ -172,8 +172,8 @@ static inline int tcf_setup_block_offload(struct tc_block_offload *f,
 }
 
 static inline struct tcf_block_cb *
-tcf_block_cb_alloc(tc_setup_cb_t *cb, void *cb_ident, void *cb_priv,
-		   void (*release)(void *cb_priv))
+tcf_block_cb_alloc(struct net *net, tc_setup_cb_t *cb, void *cb_ident,
+		   void *cb_priv, void (*release)(void *cb_priv))
 {
 	return NULL;
 }
@@ -200,7 +200,7 @@ void *tcf_block_cb_priv(struct tcf_block_cb *block_cb)
 }
 
 static inline
-struct tcf_block_cb *tcf_block_cb_lookup(struct tcf_block *block,
+struct tcf_block_cb *tcf_block_cb_lookup(struct net *net, struct tcf_block *block,
 					 tc_setup_cb_t *cb, void *cb_ident)
 {
 	return NULL;
@@ -662,6 +662,7 @@ struct tc_block_offload {
 	enum tc_block_command command;
 	enum tcf_block_binder_type binder_type;
 	struct list_head cb_list;
+	struct net *net;
 	struct tcf_block *block;
 	struct netlink_ext_ack *extack;
 };
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 99673f6b07f6..8f562f3cf81c 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -945,6 +945,7 @@ static int dsa_slave_setup_tc_block_cb_eg(enum tc_setup_type type,
 static int dsa_slave_setup_tc_block(struct net_device *dev,
 				    struct tc_block_offload *f)
 {
+	struct tcf_block_cb *block_cb;
 	tc_setup_cb_t *cb;
 
 	if (f->binder_type == TCF_BLOCK_BINDER_TYPE_CLSACT_INGRESS)
@@ -956,9 +957,18 @@ static int dsa_slave_setup_tc_block(struct net_device *dev,
 
 	switch (f->command) {
 	case TC_BLOCK_BIND:
-		return tcf_block_cb_register(f->block, cb, dev, dev, f->extack);
+		block_cb = tcf_block_cb_alloc(f->net, cb, dev, dev, NULL);
+		if (!block_cb)
+			return -ENOMEM;
+
+		tcf_block_cb_add(block_cb, f);
+		return 0;
 	case TC_BLOCK_UNBIND:
-		tcf_block_cb_unregister(f->block, cb, dev);
+		block_cb = tcf_block_cb_lookup(f->net, cb, dev);
+		if (!block_cb)
+			return -ENOENT;
+
+		tcf_block_cb_remove(block_cb, f);
 		return 0;
 	default:
 		return -EOPNOTSUPP;
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 6dc6935fe517..6b397784eee5 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -712,6 +712,7 @@ static bool tcf_block_offload_in_use(struct tcf_block *block)
 struct tcf_block_cb {
 	struct list_head global_list;
 	struct list_head list;
+	struct net *net;
 	tc_setup_cb_t *cb;
 	void (*release)(void *cb_priv);
 	void *cb_ident;
@@ -727,12 +728,15 @@ EXPORT_SYMBOL(tcf_block_cb_priv);
 
 static LIST_HEAD(tcf_block_cb_list);
 
-struct tcf_block_cb *tcf_block_cb_lookup(struct tcf_block *block,
-					 tc_setup_cb_t *cb, void *cb_ident)
-{	struct tcf_block_cb *block_cb;
+struct tcf_block_cb *tcf_block_cb_lookup(struct net *net, tc_setup_cb_t *cb,
+					 void *cb_ident)
+{
+	struct tcf_block_cb *block_cb;
 
-	list_for_each_entry(block_cb, &block->cb_list, list)
-		if (block_cb->cb == cb && block_cb->cb_ident == cb_ident)
+	list_for_each_entry(block_cb, &tcf_block_cb_list, global_list)
+		if (block_cb->net == net &&
+		    block_cb->cb == cb &&
+		    block_cb->cb_ident == cb_ident)
 			return block_cb;
 	return NULL;
 }
@@ -750,7 +754,7 @@ unsigned int tcf_block_cb_decref(struct tcf_block_cb *block_cb)
 }
 EXPORT_SYMBOL(tcf_block_cb_decref);
 
-struct tcf_block_cb *tcf_block_cb_alloc(tc_setup_cb_t *cb,
+struct tcf_block_cb *tcf_block_cb_alloc(struct net *net, tc_setup_cb_t *cb,
 					void *cb_ident, void *cb_priv,
 					void (*release)(void *cb_priv))
 {
@@ -760,6 +764,7 @@ struct tcf_block_cb *tcf_block_cb_alloc(tc_setup_cb_t *cb,
 	if (!block_cb)
 		return NULL;
 
+	block_cb->net = net;
 	block_cb->cb = cb;
 	block_cb->cb_ident = cb_ident;
 	block_cb->release = release;
@@ -807,7 +812,7 @@ struct tcf_block_cb *__tcf_block_cb_register(struct tcf_block *block,
 	if (err)
 		return ERR_PTR(err);
 
-	block_cb = tcf_block_cb_alloc(cb, cb_ident, cb_priv, NULL);
+	block_cb = tcf_block_cb_alloc(block->net, cb, cb_ident, cb_priv, NULL);
 	if (!block_cb)
 		return ERR_PTR(-ENOMEM);
 
@@ -844,7 +849,7 @@ void tcf_block_cb_unregister(struct tcf_block *block,
 {
 	struct tcf_block_cb *block_cb;
 
-	block_cb = tcf_block_cb_lookup(block, cb, cb_ident);
+	block_cb = tcf_block_cb_lookup(block->net, cb, cb_ident);
 	if (!block_cb)
 		return;
 	__tcf_block_cb_unregister(block, block_cb);
@@ -925,16 +930,27 @@ static int tcf_block_setup(struct tcf_block *block, struct tc_block_offload *bo)
 int tcf_setup_block_offload(struct tc_block_offload *f, tc_setup_cb_t *cb,
 			    void *cb_ident, void *cb_priv, bool ingress_only)
 {
+	struct tcf_block_cb *block_cb;
+
 	if (ingress_only &&
 	    f->binder_type != TCF_BLOCK_BINDER_TYPE_CLSACT_INGRESS)
 		return -EOPNOTSUPP;
 
 	switch (f->command) {
 	case TC_BLOCK_BIND:
-		return tcf_block_cb_register(f->block, cb, cb_ident, cb_priv,
-					     f->extack);
+		block_cb = tcf_block_cb_alloc(f->net, cb, cb_ident,
+					      cb_priv, NULL);
+		if (!block_cb)
+			return -ENOMEM;
+
+		tcf_block_cb_add(block_cb, f);
+		return 0;
 	case TC_BLOCK_UNBIND:
-		tcf_block_cb_unregister(f->block, cb, cb_ident);
+		block_cb = tcf_block_cb_lookup(f->net, cb, cb_ident);
+		if (!block_cb)
+			return -ENOENT;
+
+		tcf_block_cb_remove(block_cb, f);
 		return 0;
 	default:
 		return -EOPNOTSUPP;
@@ -1056,6 +1072,7 @@ static void tc_indr_block_ing_cmd(struct tc_indr_block_dev *indr_dev,
 	struct tc_block_offload bo = {
 		.command	= command,
 		.binder_type	= TCF_BLOCK_BINDER_TYPE_CLSACT_INGRESS,
+		.net		= dev_net(indr_dev->dev),
 		.block		= indr_dev->block,
 	};
 	INIT_LIST_HEAD(&bo.cb_list);
@@ -1146,6 +1163,7 @@ static void tc_indr_block_call(struct tcf_block *block, struct net_device *dev,
 	struct tc_block_offload bo = {
 		.command	= command,
 		.binder_type	= ei->binder_type,
+		.net		= dev_net(dev),
 		.block		= block,
 		.extack		= extack,
 	};
@@ -1173,8 +1191,10 @@ static int tcf_block_offload_cmd(struct tcf_block *block,
 	struct tc_block_offload bo = {};
 	int err;
 
+	bo.net = dev_net(dev);
 	bo.command = command;
 	bo.binder_type = ei->binder_type;
+	bo.net = dev_net(dev),
 	bo.block = block;
 	bo.extack = extack;
 	INIT_LIST_HEAD(&bo.cb_list);
-- 
2.11.0

