Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3A6563CEB
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 22:57:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729826AbfGIU4L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 16:56:11 -0400
Received: from mail.us.es ([193.147.175.20]:36648 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729812AbfGIU4L (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Jul 2019 16:56:11 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 67D9D285E3AB
        for <netdev@vger.kernel.org>; Tue,  9 Jul 2019 22:56:06 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 55A091150CB
        for <netdev@vger.kernel.org>; Tue,  9 Jul 2019 22:56:06 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 4E975A0AAC; Tue,  9 Jul 2019 22:56:06 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A4931114D70;
        Tue,  9 Jul 2019 22:56:01 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 09 Jul 2019 22:56:01 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [31.4.194.134])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 87BE24265A31;
        Tue,  9 Jul 2019 22:55:59 +0200 (CEST)
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
Subject: [PATCH net-next,v4 01/12] net: flow_offload: add flow_block_cb_setup_simple()
Date:   Tue,  9 Jul 2019 22:55:39 +0200
Message-Id: <20190709205550.3160-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190709205550.3160-1-pablo@netfilter.org>
References: <20190709205550.3160-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Most drivers do the same thing to set up the flow block callbacks, this
patch adds a helper function to do this.

This preparation patch reduces the number of changes to adapt the
existing drivers to use the flow block callback API.

This new helper function takes a flow block list per-driver, which is
set to NULL until this driver list is used.

This patch also introduces the flow_block_command and
flow_block_binder_type enumerations, which are renamed to use
FLOW_BLOCK_* in follow up patches.

There are three definitions (aliases) in order to reduce the number of
updates in this patch, which go away once drivers are fully adapted to
use this flow block API.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
v4: no changes.

 drivers/net/ethernet/broadcom/bnxt/bnxt.c         | 26 ++++-------------
 drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c     | 28 ++++--------------
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c   | 26 ++++-------------
 drivers/net/ethernet/intel/i40e/i40e_main.c       | 26 ++++-------------
 drivers/net/ethernet/intel/iavf/iavf_main.c       | 35 ++++-------------------
 drivers/net/ethernet/intel/igb/igb_main.c         | 24 +++-------------
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c     | 27 ++++-------------
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 27 ++++-------------
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c  | 26 ++++-------------
 drivers/net/ethernet/netronome/nfp/abm/cls.c      | 17 ++---------
 drivers/net/ethernet/netronome/nfp/bpf/main.c     | 29 ++++---------------
 drivers/net/ethernet/qlogic/qede/qede_main.c      | 23 ++-------------
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 22 ++------------
 drivers/net/netdevsim/netdev.c                    | 26 ++++-------------
 include/net/flow_offload.h                        | 27 +++++++++++++++++
 include/net/pkt_cls.h                             | 20 ++-----------
 net/core/flow_offload.c                           | 25 ++++++++++++++++
 17 files changed, 117 insertions(+), 317 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index b7b62273c955..d2f8c3ed6c73 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -9847,32 +9847,16 @@ static int bnxt_setup_tc_block_cb(enum tc_setup_type type, void *type_data,
 	}
 }
 
-static int bnxt_setup_tc_block(struct net_device *dev,
-			       struct tc_block_offload *f)
-{
-	struct bnxt *bp = netdev_priv(dev);
-
-	if (f->binder_type != TCF_BLOCK_BINDER_TYPE_CLSACT_INGRESS)
-		return -EOPNOTSUPP;
-
-	switch (f->command) {
-	case TC_BLOCK_BIND:
-		return tcf_block_cb_register(f->block, bnxt_setup_tc_block_cb,
-					     bp, bp, f->extack);
-	case TC_BLOCK_UNBIND:
-		tcf_block_cb_unregister(f->block, bnxt_setup_tc_block_cb, bp);
-		return 0;
-	default:
-		return -EOPNOTSUPP;
-	}
-}
-
 static int bnxt_setup_tc(struct net_device *dev, enum tc_setup_type type,
 			 void *type_data)
 {
+	struct bnxt *bp = netdev_priv(dev);
+
 	switch (type) {
 	case TC_SETUP_BLOCK:
-		return bnxt_setup_tc_block(dev, type_data);
+		return flow_block_cb_setup_simple(type_data, NULL,
+						  bnxt_setup_tc_block_cb,
+						  bp, bp, true);
 	case TC_SETUP_QDISC_MQPRIO: {
 		struct tc_mqprio_qopt *mqprio = type_data;
 
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c
index f760921389a3..89398ff011d4 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c
@@ -161,34 +161,16 @@ static int bnxt_vf_rep_setup_tc_block_cb(enum tc_setup_type type,
 	}
 }
 
-static int bnxt_vf_rep_setup_tc_block(struct net_device *dev,
-				      struct tc_block_offload *f)
-{
-	struct bnxt_vf_rep *vf_rep = netdev_priv(dev);
-
-	if (f->binder_type != TCF_BLOCK_BINDER_TYPE_CLSACT_INGRESS)
-		return -EOPNOTSUPP;
-
-	switch (f->command) {
-	case TC_BLOCK_BIND:
-		return tcf_block_cb_register(f->block,
-					     bnxt_vf_rep_setup_tc_block_cb,
-					     vf_rep, vf_rep, f->extack);
-	case TC_BLOCK_UNBIND:
-		tcf_block_cb_unregister(f->block,
-					bnxt_vf_rep_setup_tc_block_cb, vf_rep);
-		return 0;
-	default:
-		return -EOPNOTSUPP;
-	}
-}
-
 static int bnxt_vf_rep_setup_tc(struct net_device *dev, enum tc_setup_type type,
 				void *type_data)
 {
+	struct bnxt_vf_rep *vf_rep = netdev_priv(dev);
+
 	switch (type) {
 	case TC_SETUP_BLOCK:
-		return bnxt_vf_rep_setup_tc_block(dev, type_data);
+		return flow_block_cb_setup_simple(type_data, NULL,
+						  bnxt_vf_rep_setup_tc_block_cb,
+						  vf_rep, vf_rep, true);
 	default:
 		return -EOPNOTSUPP;
 	}
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index b08efc48d42f..9a486282a32e 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -3190,32 +3190,16 @@ static int cxgb_setup_tc_block_cb(enum tc_setup_type type, void *type_data,
 	}
 }
 
-static int cxgb_setup_tc_block(struct net_device *dev,
-			       struct tc_block_offload *f)
-{
-	struct port_info *pi = netdev2pinfo(dev);
-
-	if (f->binder_type != TCF_BLOCK_BINDER_TYPE_CLSACT_INGRESS)
-		return -EOPNOTSUPP;
-
-	switch (f->command) {
-	case TC_BLOCK_BIND:
-		return tcf_block_cb_register(f->block, cxgb_setup_tc_block_cb,
-					     pi, dev, f->extack);
-	case TC_BLOCK_UNBIND:
-		tcf_block_cb_unregister(f->block, cxgb_setup_tc_block_cb, pi);
-		return 0;
-	default:
-		return -EOPNOTSUPP;
-	}
-}
-
 static int cxgb_setup_tc(struct net_device *dev, enum tc_setup_type type,
 			 void *type_data)
 {
+	struct port_info *pi = netdev2pinfo(dev);
+
 	switch (type) {
 	case TC_SETUP_BLOCK:
-		return cxgb_setup_tc_block(dev, type_data);
+		return flow_block_cb_setup_simple(type_data, NULL,
+						  cxgb_setup_tc_block_cb,
+						  pi, dev, true);
 	default:
 		return -EOPNOTSUPP;
 	}
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 5361c08328f7..52f0f14d4207 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -8177,34 +8177,18 @@ static int i40e_setup_tc_block_cb(enum tc_setup_type type, void *type_data,
 	}
 }
 
-static int i40e_setup_tc_block(struct net_device *dev,
-			       struct tc_block_offload *f)
-{
-	struct i40e_netdev_priv *np = netdev_priv(dev);
-
-	if (f->binder_type != TCF_BLOCK_BINDER_TYPE_CLSACT_INGRESS)
-		return -EOPNOTSUPP;
-
-	switch (f->command) {
-	case TC_BLOCK_BIND:
-		return tcf_block_cb_register(f->block, i40e_setup_tc_block_cb,
-					     np, np, f->extack);
-	case TC_BLOCK_UNBIND:
-		tcf_block_cb_unregister(f->block, i40e_setup_tc_block_cb, np);
-		return 0;
-	default:
-		return -EOPNOTSUPP;
-	}
-}
-
 static int __i40e_setup_tc(struct net_device *netdev, enum tc_setup_type type,
 			   void *type_data)
 {
+	struct i40e_netdev_priv *np = netdev_priv(netdev);
+
 	switch (type) {
 	case TC_SETUP_QDISC_MQPRIO:
 		return i40e_setup_tc(netdev, type_data);
 	case TC_SETUP_BLOCK:
-		return i40e_setup_tc_block(netdev, type_data);
+		return flow_block_cb_setup_simple(type_data, NULL,
+						  i40e_setup_tc_block_cb,
+						  np, np, true);
 	default:
 		return -EOPNOTSUPP;
 	}
diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 881561b36083..fd0e2bcc75e5 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -3114,35 +3114,6 @@ static int iavf_setup_tc_block_cb(enum tc_setup_type type, void *type_data,
 }
 
 /**
- * iavf_setup_tc_block - register callbacks for tc
- * @netdev: network interface device structure
- * @f: tc offload data
- *
- * This function registers block callbacks for tc
- * offloads
- **/
-static int iavf_setup_tc_block(struct net_device *dev,
-			       struct tc_block_offload *f)
-{
-	struct iavf_adapter *adapter = netdev_priv(dev);
-
-	if (f->binder_type != TCF_BLOCK_BINDER_TYPE_CLSACT_INGRESS)
-		return -EOPNOTSUPP;
-
-	switch (f->command) {
-	case TC_BLOCK_BIND:
-		return tcf_block_cb_register(f->block, iavf_setup_tc_block_cb,
-					     adapter, adapter, f->extack);
-	case TC_BLOCK_UNBIND:
-		tcf_block_cb_unregister(f->block, iavf_setup_tc_block_cb,
-					adapter);
-		return 0;
-	default:
-		return -EOPNOTSUPP;
-	}
-}
-
-/**
  * iavf_setup_tc - configure multiple traffic classes
  * @netdev: network interface device structure
  * @type: type of offload
@@ -3156,11 +3127,15 @@ static int iavf_setup_tc_block(struct net_device *dev,
 static int iavf_setup_tc(struct net_device *netdev, enum tc_setup_type type,
 			 void *type_data)
 {
+	struct iavf_adapter *adapter = netdev_priv(netdev);
+
 	switch (type) {
 	case TC_SETUP_QDISC_MQPRIO:
 		return __iavf_setup_tc(netdev, type_data);
 	case TC_SETUP_BLOCK:
-		return iavf_setup_tc_block(netdev, type_data);
+		return flow_block_cb_setup_simple(type_data, NULL,
+						  iavf_setup_tc_block_cb,
+						  adapter, adapter, true);
 	default:
 		return -EOPNOTSUPP;
 	}
diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index f66dae72fe37..836f9e1a136c 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -2783,25 +2783,6 @@ static int igb_setup_tc_block_cb(enum tc_setup_type type, void *type_data,
 	}
 }
 
-static int igb_setup_tc_block(struct igb_adapter *adapter,
-			      struct tc_block_offload *f)
-{
-	if (f->binder_type != TCF_BLOCK_BINDER_TYPE_CLSACT_INGRESS)
-		return -EOPNOTSUPP;
-
-	switch (f->command) {
-	case TC_BLOCK_BIND:
-		return tcf_block_cb_register(f->block, igb_setup_tc_block_cb,
-					     adapter, adapter, f->extack);
-	case TC_BLOCK_UNBIND:
-		tcf_block_cb_unregister(f->block, igb_setup_tc_block_cb,
-					adapter);
-		return 0;
-	default:
-		return -EOPNOTSUPP;
-	}
-}
-
 static int igb_offload_txtime(struct igb_adapter *adapter,
 			      struct tc_etf_qopt_offload *qopt)
 {
@@ -2834,7 +2815,10 @@ static int igb_setup_tc(struct net_device *dev, enum tc_setup_type type,
 	case TC_SETUP_QDISC_CBS:
 		return igb_offload_cbs(adapter, type_data);
 	case TC_SETUP_BLOCK:
-		return igb_setup_tc_block(adapter, type_data);
+		return flow_block_cb_setup_simple(type_data, NULL,
+						  igb_setup_tc_block_cb,
+						  adapter, adapter, true);
+
 	case TC_SETUP_QDISC_ETF:
 		return igb_offload_txtime(adapter, type_data);
 
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index b613e72c8ee4..b098f5be9c0d 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -9607,27 +9607,6 @@ static int ixgbe_setup_tc_block_cb(enum tc_setup_type type, void *type_data,
 	}
 }
 
-static int ixgbe_setup_tc_block(struct net_device *dev,
-				struct tc_block_offload *f)
-{
-	struct ixgbe_adapter *adapter = netdev_priv(dev);
-
-	if (f->binder_type != TCF_BLOCK_BINDER_TYPE_CLSACT_INGRESS)
-		return -EOPNOTSUPP;
-
-	switch (f->command) {
-	case TC_BLOCK_BIND:
-		return tcf_block_cb_register(f->block, ixgbe_setup_tc_block_cb,
-					     adapter, adapter, f->extack);
-	case TC_BLOCK_UNBIND:
-		tcf_block_cb_unregister(f->block, ixgbe_setup_tc_block_cb,
-					adapter);
-		return 0;
-	default:
-		return -EOPNOTSUPP;
-	}
-}
-
 static int ixgbe_setup_tc_mqprio(struct net_device *dev,
 				 struct tc_mqprio_qopt *mqprio)
 {
@@ -9638,9 +9617,13 @@ static int ixgbe_setup_tc_mqprio(struct net_device *dev,
 static int __ixgbe_setup_tc(struct net_device *dev, enum tc_setup_type type,
 			    void *type_data)
 {
+	struct ixgbe_adapter *adapter = netdev_priv(dev);
+
 	switch (type) {
 	case TC_SETUP_BLOCK:
-		return ixgbe_setup_tc_block(dev, type_data);
+		return flow_block_cb_setup_simple(type_data, NULL,
+						  ixgbe_setup_tc_block_cb,
+						  adapter, adapter, true);
 	case TC_SETUP_QDISC_MQPRIO:
 		return ixgbe_setup_tc_mqprio(dev, type_data);
 	default:
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 83194d56434d..395890fea358 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3457,36 +3457,19 @@ static int mlx5e_setup_tc_block_cb(enum tc_setup_type type, void *type_data,
 		return -EOPNOTSUPP;
 	}
 }
-
-static int mlx5e_setup_tc_block(struct net_device *dev,
-				struct tc_block_offload *f)
-{
-	struct mlx5e_priv *priv = netdev_priv(dev);
-
-	if (f->binder_type != TCF_BLOCK_BINDER_TYPE_CLSACT_INGRESS)
-		return -EOPNOTSUPP;
-
-	switch (f->command) {
-	case TC_BLOCK_BIND:
-		return tcf_block_cb_register(f->block, mlx5e_setup_tc_block_cb,
-					     priv, priv, f->extack);
-	case TC_BLOCK_UNBIND:
-		tcf_block_cb_unregister(f->block, mlx5e_setup_tc_block_cb,
-					priv);
-		return 0;
-	default:
-		return -EOPNOTSUPP;
-	}
-}
 #endif
 
 static int mlx5e_setup_tc(struct net_device *dev, enum tc_setup_type type,
 			  void *type_data)
 {
+	struct mlx5e_priv *priv = netdev_priv(dev);
+
 	switch (type) {
 #ifdef CONFIG_MLX5_ESWITCH
 	case TC_SETUP_BLOCK:
-		return mlx5e_setup_tc_block(dev, type_data);
+		return flow_block_cb_setup_simple(type_data, NULL,
+						  mlx5e_setup_tc_block_cb,
+						  priv, priv, true);
 #endif
 	case TC_SETUP_QDISC_MQPRIO:
 		return mlx5e_setup_tc_mqprio(dev, type_data);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 529f8e4b32c6..5b5c4ecf4214 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -1178,32 +1178,16 @@ static int mlx5e_rep_setup_tc_cb(enum tc_setup_type type, void *type_data,
 	}
 }
 
-static int mlx5e_rep_setup_tc_block(struct net_device *dev,
-				    struct tc_block_offload *f)
-{
-	struct mlx5e_priv *priv = netdev_priv(dev);
-
-	if (f->binder_type != TCF_BLOCK_BINDER_TYPE_CLSACT_INGRESS)
-		return -EOPNOTSUPP;
-
-	switch (f->command) {
-	case TC_BLOCK_BIND:
-		return tcf_block_cb_register(f->block, mlx5e_rep_setup_tc_cb,
-					     priv, priv, f->extack);
-	case TC_BLOCK_UNBIND:
-		tcf_block_cb_unregister(f->block, mlx5e_rep_setup_tc_cb, priv);
-		return 0;
-	default:
-		return -EOPNOTSUPP;
-	}
-}
-
 static int mlx5e_rep_setup_tc(struct net_device *dev, enum tc_setup_type type,
 			      void *type_data)
 {
+	struct mlx5e_priv *priv = netdev_priv(dev);
+
 	switch (type) {
 	case TC_SETUP_BLOCK:
-		return mlx5e_rep_setup_tc_block(dev, type_data);
+		return flow_block_cb_setup_simple(type_data, NULL,
+						  mlx5e_rep_setup_tc_cb,
+						  priv, priv, true);
 	default:
 		return -EOPNOTSUPP;
 	}
diff --git a/drivers/net/ethernet/netronome/nfp/abm/cls.c b/drivers/net/ethernet/netronome/nfp/abm/cls.c
index ff3913085665..29fb45734962 100644
--- a/drivers/net/ethernet/netronome/nfp/abm/cls.c
+++ b/drivers/net/ethernet/netronome/nfp/abm/cls.c
@@ -265,19 +265,6 @@ static int nfp_abm_setup_tc_block_cb(enum tc_setup_type type,
 int nfp_abm_setup_cls_block(struct net_device *netdev, struct nfp_repr *repr,
 			    struct tc_block_offload *f)
 {
-	if (f->binder_type != TCF_BLOCK_BINDER_TYPE_CLSACT_EGRESS)
-		return -EOPNOTSUPP;
-
-	switch (f->command) {
-	case TC_BLOCK_BIND:
-		return tcf_block_cb_register(f->block,
-					     nfp_abm_setup_tc_block_cb,
-					     repr, repr, f->extack);
-	case TC_BLOCK_UNBIND:
-		tcf_block_cb_unregister(f->block, nfp_abm_setup_tc_block_cb,
-					repr);
-		return 0;
-	default:
-		return -EOPNOTSUPP;
-	}
+	return flow_block_cb_setup_simple(f, NULL, nfp_abm_setup_tc_block_cb,
+					  repr, repr, true);
 }
diff --git a/drivers/net/ethernet/netronome/nfp/bpf/main.c b/drivers/net/ethernet/netronome/nfp/bpf/main.c
index 9c136da25221..0c93c84a188a 100644
--- a/drivers/net/ethernet/netronome/nfp/bpf/main.c
+++ b/drivers/net/ethernet/netronome/nfp/bpf/main.c
@@ -160,35 +160,16 @@ static int nfp_bpf_setup_tc_block_cb(enum tc_setup_type type,
 	return 0;
 }
 
-static int nfp_bpf_setup_tc_block(struct net_device *netdev,
-				  struct tc_block_offload *f)
-{
-	struct nfp_net *nn = netdev_priv(netdev);
-
-	if (f->binder_type != TCF_BLOCK_BINDER_TYPE_CLSACT_INGRESS)
-		return -EOPNOTSUPP;
-
-	switch (f->command) {
-	case TC_BLOCK_BIND:
-		return tcf_block_cb_register(f->block,
-					     nfp_bpf_setup_tc_block_cb,
-					     nn, nn, f->extack);
-	case TC_BLOCK_UNBIND:
-		tcf_block_cb_unregister(f->block,
-					nfp_bpf_setup_tc_block_cb,
-					nn);
-		return 0;
-	default:
-		return -EOPNOTSUPP;
-	}
-}
-
 static int nfp_bpf_setup_tc(struct nfp_app *app, struct net_device *netdev,
 			    enum tc_setup_type type, void *type_data)
 {
+	struct nfp_net *nn = netdev_priv(netdev);
+
 	switch (type) {
 	case TC_SETUP_BLOCK:
-		return nfp_bpf_setup_tc_block(netdev, type_data);
+		return flow_block_cb_setup_simple(type_data, NULL,
+						  nfp_bpf_setup_tc_block_cb,
+						  nn, nn, true);
 	default:
 		return -EOPNOTSUPP;
 	}
diff --git a/drivers/net/ethernet/qlogic/qede/qede_main.c b/drivers/net/ethernet/qlogic/qede/qede_main.c
index d4a29660751d..cba97ed3dd56 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_main.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_main.c
@@ -579,25 +579,6 @@ static int qede_setup_tc_block_cb(enum tc_setup_type type, void *type_data,
 	}
 }
 
-static int qede_setup_tc_block(struct qede_dev *edev,
-			       struct tc_block_offload *f)
-{
-	if (f->binder_type != TCF_BLOCK_BINDER_TYPE_CLSACT_INGRESS)
-		return -EOPNOTSUPP;
-
-	switch (f->command) {
-	case TC_BLOCK_BIND:
-		return tcf_block_cb_register(f->block,
-					     qede_setup_tc_block_cb,
-					     edev, edev, f->extack);
-	case TC_BLOCK_UNBIND:
-		tcf_block_cb_unregister(f->block, qede_setup_tc_block_cb, edev);
-		return 0;
-	default:
-		return -EOPNOTSUPP;
-	}
-}
-
 static int
 qede_setup_tc_offload(struct net_device *dev, enum tc_setup_type type,
 		      void *type_data)
@@ -607,7 +588,9 @@ qede_setup_tc_offload(struct net_device *dev, enum tc_setup_type type,
 
 	switch (type) {
 	case TC_SETUP_BLOCK:
-		return qede_setup_tc_block(edev, type_data);
+		return flow_block_cb_setup_simple(type_data, NULL,
+						  qede_setup_tc_block_cb,
+						  edev, edev, true);
 	case TC_SETUP_QDISC_MQPRIO:
 		mqprio = type_data;
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 3425d4dda03d..0040f10bbef9 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -3853,24 +3853,6 @@ static int stmmac_setup_tc_block_cb(enum tc_setup_type type, void *type_data,
 	return ret;
 }
 
-static int stmmac_setup_tc_block(struct stmmac_priv *priv,
-				 struct tc_block_offload *f)
-{
-	if (f->binder_type != TCF_BLOCK_BINDER_TYPE_CLSACT_INGRESS)
-		return -EOPNOTSUPP;
-
-	switch (f->command) {
-	case TC_BLOCK_BIND:
-		return tcf_block_cb_register(f->block, stmmac_setup_tc_block_cb,
-				priv, priv, f->extack);
-	case TC_BLOCK_UNBIND:
-		tcf_block_cb_unregister(f->block, stmmac_setup_tc_block_cb, priv);
-		return 0;
-	default:
-		return -EOPNOTSUPP;
-	}
-}
-
 static int stmmac_setup_tc(struct net_device *ndev, enum tc_setup_type type,
 			   void *type_data)
 {
@@ -3878,7 +3860,9 @@ static int stmmac_setup_tc(struct net_device *ndev, enum tc_setup_type type,
 
 	switch (type) {
 	case TC_SETUP_BLOCK:
-		return stmmac_setup_tc_block(priv, type_data);
+		return flow_block_cb_setup_simple(type_data, NULL,
+						  stmmac_setup_tc_block_cb,
+						  priv, priv, true);
 	case TC_SETUP_QDISC_CBS:
 		return stmmac_tc_setup_cbs(priv, priv, type_data);
 	default:
diff --git a/drivers/net/netdevsim/netdev.c b/drivers/net/netdevsim/netdev.c
index e5c8aa08e1cd..920dc79e9dc9 100644
--- a/drivers/net/netdevsim/netdev.c
+++ b/drivers/net/netdevsim/netdev.c
@@ -78,26 +78,6 @@ nsim_setup_tc_block_cb(enum tc_setup_type type, void *type_data, void *cb_priv)
 	return nsim_bpf_setup_tc_block_cb(type, type_data, cb_priv);
 }
 
-static int
-nsim_setup_tc_block(struct net_device *dev, struct tc_block_offload *f)
-{
-	struct netdevsim *ns = netdev_priv(dev);
-
-	if (f->binder_type != TCF_BLOCK_BINDER_TYPE_CLSACT_INGRESS)
-		return -EOPNOTSUPP;
-
-	switch (f->command) {
-	case TC_BLOCK_BIND:
-		return tcf_block_cb_register(f->block, nsim_setup_tc_block_cb,
-					     ns, ns, f->extack);
-	case TC_BLOCK_UNBIND:
-		tcf_block_cb_unregister(f->block, nsim_setup_tc_block_cb, ns);
-		return 0;
-	default:
-		return -EOPNOTSUPP;
-	}
-}
-
 static int nsim_set_vf_mac(struct net_device *dev, int vf, u8 *mac)
 {
 	struct netdevsim *ns = netdev_priv(dev);
@@ -226,9 +206,13 @@ static int nsim_set_vf_link_state(struct net_device *dev, int vf, int state)
 static int
 nsim_setup_tc(struct net_device *dev, enum tc_setup_type type, void *type_data)
 {
+	struct netdevsim *ns = netdev_priv(dev);
+
 	switch (type) {
 	case TC_SETUP_BLOCK:
-		return nsim_setup_tc_block(dev, type_data);
+		return flow_block_cb_setup_simple(type_data, NULL,
+						  nsim_setup_tc_block_cb,
+						  ns, ns, true);
 	default:
 		return -EOPNOTSUPP;
 	}
diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index 36127c1858a4..6afc6009c6ab 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -3,6 +3,7 @@
 
 #include <linux/kernel.h>
 #include <net/flow_dissector.h>
+#include <net/sch_generic.h>
 
 struct flow_match {
 	struct flow_dissector	*dissector;
@@ -232,4 +233,30 @@ static inline void flow_stats_update(struct flow_stats *flow_stats,
 	flow_stats->lastused	= max_t(u64, flow_stats->lastused, lastused);
 }
 
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
+struct tcf_block;
+struct netlink_ext_ack;
+
+struct flow_block_offload {
+	enum flow_block_command command;
+	enum flow_block_binder_type binder_type;
+	struct tcf_block *block;
+	struct list_head *driver_block_list;
+	struct netlink_ext_ack *extack;
+};
+
+int flow_block_cb_setup_simple(struct flow_block_offload *f,
+			       struct list_head *driver_list, tc_setup_cb_t *cb,
+			       void *cb_ident, void *cb_priv, bool ingress_only);
+
 #endif /* _NET_FLOW_OFFLOAD_H */
diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index 1a7596ba0dbe..b6c306fa9541 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -26,11 +26,9 @@ struct tcf_walker {
 int register_tcf_proto_ops(struct tcf_proto_ops *ops);
 int unregister_tcf_proto_ops(struct tcf_proto_ops *ops);
 
-enum tcf_block_binder_type {
-	TCF_BLOCK_BINDER_TYPE_UNSPEC,
-	TCF_BLOCK_BINDER_TYPE_CLSACT_INGRESS,
-	TCF_BLOCK_BINDER_TYPE_CLSACT_EGRESS,
-};
+#define tc_block_offload flow_block_offload
+#define tc_block_command flow_block_command
+#define tcf_block_binder_type flow_block_binder_type
 
 struct tcf_block_ext_info {
 	enum tcf_block_binder_type binder_type;
@@ -610,18 +608,6 @@ int tc_setup_cb_call(struct tcf_block *block, enum tc_setup_type type,
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
-	struct tcf_block *block;
-	struct netlink_ext_ack *extack;
-};
-
 struct tc_cls_common_offload {
 	u32 chain_index;
 	__be16 protocol;
diff --git a/net/core/flow_offload.c b/net/core/flow_offload.c
index f52fe0bc4017..e31c0fdb6b01 100644
--- a/net/core/flow_offload.c
+++ b/net/core/flow_offload.c
@@ -2,6 +2,7 @@
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <net/flow_offload.h>
+#include <net/pkt_cls.h>
 
 struct flow_rule *flow_rule_alloc(unsigned int num_actions)
 {
@@ -164,3 +165,27 @@ void flow_rule_match_enc_opts(const struct flow_rule *rule,
 	FLOW_DISSECTOR_MATCH(rule, FLOW_DISSECTOR_KEY_ENC_OPTS, out);
 }
 EXPORT_SYMBOL(flow_rule_match_enc_opts);
+
+int flow_block_cb_setup_simple(struct flow_block_offload *f,
+			       struct list_head *driver_block_list,
+			       tc_setup_cb_t *cb, void *cb_ident, void *cb_priv,
+			       bool ingress_only)
+{
+	if (ingress_only &&
+	    f->binder_type != TCF_BLOCK_BINDER_TYPE_CLSACT_INGRESS)
+		return -EOPNOTSUPP;
+
+	f->driver_block_list = driver_block_list;
+
+	switch (f->command) {
+	case TC_BLOCK_BIND:
+		return tcf_block_cb_register(f->block, cb, cb_ident, cb_priv,
+					     f->extack);
+	case TC_BLOCK_UNBIND:
+		tcf_block_cb_unregister(f->block, cb, cb_ident);
+		return 0;
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+EXPORT_SYMBOL(flow_block_cb_setup_simple);
-- 
2.11.0


