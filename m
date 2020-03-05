Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 393B317A070
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 08:17:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726524AbgCEHRk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 02:17:40 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:37075 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726209AbgCEHRj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Mar 2020 02:17:39 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id A124D220BD;
        Thu,  5 Mar 2020 02:17:38 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Thu, 05 Mar 2020 02:17:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=R+860K7udUT45RB7+4hBrEhC+t2bJ5v/CDma3/c9Prg=; b=mv0OT4Mz
        Aj3BkLNl20UIAtjKtmmo44SKiRobi3LPG0Taez24zNbwPu6vVTOXUPRvyOJtOpJ9
        gCUQbT8aOzwI6yaYEX1qhSDT+WR8zOwxooKmJux/+V+7w+RCLxPIZKBPLrxmNVVq
        0cfyVMTcXdKzWfMOZVhW26CmwH5tf6kU+F4Q3ALN+3rL2TVXeBwqTG/L1zIeflUV
        aGgfYPxsVrEzc2ujiBvpS4UVjzblg1Z++QVKzACvJne70Cwy1OQ/fQ4udHrtju+Y
        iwAPh69tpYtJ1KFqm8pnaQrRV55pbYbft9U7OYpJQdVH8YhRXvoHcUMJZedujowv
        pY0QWzm0GEej4g==
X-ME-Sender: <xms:kqdgXl5t32aSGONyxoFmFQAJ4oGpfD-FHBH1squL8_MAHaU5gCgtfw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedruddtledguddtiecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecuvehluhhsth
    gvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiugho
    shgthhdrohhrgh
X-ME-Proxy: <xmx:kqdgXgdRTmVH6D0Z2v2vK54V1Gq65EcYaK0fXTIpOTVEDkmpbFvOzA>
    <xmx:kqdgXl_bLdvEjpvMEuhfCQfovuDzg0tZPZKMZxZ-YFsiqoUpsL3mhQ>
    <xmx:kqdgXnHNAMon_vgALHPPLhe7hZEqXXuVNolVl-Aefp2xdTBL03NplQ>
    <xmx:kqdgXjQglzsDLHIH9bwa6RxtjcnvjXWVZuHa7yCQFnHDNOJ4FgAXLA>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 083EB3280060;
        Thu,  5 Mar 2020 02:17:36 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        petrm@mellanox.com, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 2/5] mlxsw: spectrum_qdisc: Introduce struct mlxsw_sp_qdisc_state
Date:   Thu,  5 Mar 2020 09:16:41 +0200
Message-Id: <20200305071644.117264-3-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200305071644.117264-1-idosch@idosch.org>
References: <20200305071644.117264-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@mellanox.com>

In order to have a tidy structure where to put information related to Qdisc
offloads, introduce a new structure. Move there the two existing pieces of
data: root_qdisc and tclass_qdiscs. Embed them directly, because there's no
reason to go through pointer anymore. Convert users, update init/fini
functions.

Signed-off-by: Petr Machata <petrm@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |  4 +-
 .../ethernet/mellanox/mlxsw/spectrum_qdisc.c  | 85 ++++++++++---------
 2 files changed, 45 insertions(+), 44 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index 9708156e7871..f952fbf96b41 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -139,6 +139,7 @@ struct mlxsw_sp_port_type_speed_ops;
 struct mlxsw_sp_ptp_state;
 struct mlxsw_sp_ptp_ops;
 struct mlxsw_sp_span_ops;
+struct mlxsw_sp_qdisc_state;
 
 struct mlxsw_sp_port_mapping {
 	u8 module;
@@ -276,8 +277,7 @@ struct mlxsw_sp_port {
 	struct mlxsw_sp_port_sample *sample;
 	struct list_head vlans_list;
 	struct mlxsw_sp_port_vlan *default_vlan;
-	struct mlxsw_sp_qdisc *root_qdisc;
-	struct mlxsw_sp_qdisc *tclass_qdiscs;
+	struct mlxsw_sp_qdisc_state *qdisc;
 	unsigned acl_rule_count;
 	struct mlxsw_sp_acl_block *ing_acl_block;
 	struct mlxsw_sp_acl_block *eg_acl_block;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
index 13a054c0ce0f..250b0069d1c1 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
@@ -22,6 +22,8 @@ enum mlxsw_sp_qdisc_type {
 	MLXSW_SP_QDISC_TBF,
 };
 
+struct mlxsw_sp_qdisc;
+
 struct mlxsw_sp_qdisc_ops {
 	enum mlxsw_sp_qdisc_type type;
 	int (*check_params)(struct mlxsw_sp_port *mlxsw_sp_port,
@@ -64,6 +66,11 @@ struct mlxsw_sp_qdisc {
 	struct mlxsw_sp_qdisc_ops *ops;
 };
 
+struct mlxsw_sp_qdisc_state {
+	struct mlxsw_sp_qdisc root_qdisc;
+	struct mlxsw_sp_qdisc tclass_qdiscs[IEEE_8021QAZ_MAX_TCS];
+};
+
 static bool
 mlxsw_sp_qdisc_compare(struct mlxsw_sp_qdisc *mlxsw_sp_qdisc, u32 handle,
 		       enum mlxsw_sp_qdisc_type type)
@@ -77,36 +84,38 @@ static struct mlxsw_sp_qdisc *
 mlxsw_sp_qdisc_find(struct mlxsw_sp_port *mlxsw_sp_port, u32 parent,
 		    bool root_only)
 {
+	struct mlxsw_sp_qdisc_state *qdisc_state = mlxsw_sp_port->qdisc;
 	int tclass, child_index;
 
 	if (parent == TC_H_ROOT)
-		return mlxsw_sp_port->root_qdisc;
+		return &qdisc_state->root_qdisc;
 
-	if (root_only || !mlxsw_sp_port->root_qdisc ||
-	    !mlxsw_sp_port->root_qdisc->ops ||
-	    TC_H_MAJ(parent) != mlxsw_sp_port->root_qdisc->handle ||
+	if (root_only || !qdisc_state ||
+	    !qdisc_state->root_qdisc.ops ||
+	    TC_H_MAJ(parent) != qdisc_state->root_qdisc.handle ||
 	    TC_H_MIN(parent) > IEEE_8021QAZ_MAX_TCS)
 		return NULL;
 
 	child_index = TC_H_MIN(parent);
 	tclass = MLXSW_SP_PRIO_CHILD_TO_TCLASS(child_index);
-	return &mlxsw_sp_port->tclass_qdiscs[tclass];
+	return &qdisc_state->tclass_qdiscs[tclass];
 }
 
 static struct mlxsw_sp_qdisc *
 mlxsw_sp_qdisc_find_by_handle(struct mlxsw_sp_port *mlxsw_sp_port, u32 handle)
 {
+	struct mlxsw_sp_qdisc_state *qdisc_state = mlxsw_sp_port->qdisc;
 	int i;
 
-	if (mlxsw_sp_port->root_qdisc->handle == handle)
-		return mlxsw_sp_port->root_qdisc;
+	if (qdisc_state->root_qdisc.handle == handle)
+		return &qdisc_state->root_qdisc;
 
-	if (mlxsw_sp_port->root_qdisc->handle == TC_H_UNSPEC)
+	if (qdisc_state->root_qdisc.handle == TC_H_UNSPEC)
 		return NULL;
 
 	for (i = 0; i < IEEE_8021QAZ_MAX_TCS; i++)
-		if (mlxsw_sp_port->tclass_qdiscs[i].handle == handle)
-			return &mlxsw_sp_port->tclass_qdiscs[i];
+		if (qdisc_state->tclass_qdiscs[i].handle == handle)
+			return &qdisc_state->tclass_qdiscs[i];
 
 	return NULL;
 }
@@ -360,7 +369,8 @@ static int
 mlxsw_sp_qdisc_red_destroy(struct mlxsw_sp_port *mlxsw_sp_port,
 			   struct mlxsw_sp_qdisc *mlxsw_sp_qdisc)
 {
-	struct mlxsw_sp_qdisc *root_qdisc = mlxsw_sp_port->root_qdisc;
+	struct mlxsw_sp_qdisc_state *qdisc_state = mlxsw_sp_port->qdisc;
+	struct mlxsw_sp_qdisc *root_qdisc = &qdisc_state->root_qdisc;
 
 	if (root_qdisc != mlxsw_sp_qdisc)
 		root_qdisc->stats_base.backlog -=
@@ -559,7 +569,8 @@ static int
 mlxsw_sp_qdisc_tbf_destroy(struct mlxsw_sp_port *mlxsw_sp_port,
 			   struct mlxsw_sp_qdisc *mlxsw_sp_qdisc)
 {
-	struct mlxsw_sp_qdisc *root_qdisc = mlxsw_sp_port->root_qdisc;
+	struct mlxsw_sp_qdisc_state *qdisc_state = mlxsw_sp_port->qdisc;
+	struct mlxsw_sp_qdisc *root_qdisc = &qdisc_state->root_qdisc;
 
 	if (root_qdisc != mlxsw_sp_qdisc)
 		root_qdisc->stats_base.backlog -=
@@ -737,6 +748,7 @@ int mlxsw_sp_setup_tc_tbf(struct mlxsw_sp_port *mlxsw_sp_port,
 static int
 __mlxsw_sp_qdisc_ets_destroy(struct mlxsw_sp_port *mlxsw_sp_port)
 {
+	struct mlxsw_sp_qdisc_state *qdisc_state = mlxsw_sp_port->qdisc;
 	int i;
 
 	for (i = 0; i < IEEE_8021QAZ_MAX_TCS; i++) {
@@ -746,8 +758,8 @@ __mlxsw_sp_qdisc_ets_destroy(struct mlxsw_sp_port *mlxsw_sp_port)
 				      MLXSW_REG_QEEC_HR_SUBGROUP,
 				      i, 0, false, 0);
 		mlxsw_sp_qdisc_destroy(mlxsw_sp_port,
-				       &mlxsw_sp_port->tclass_qdiscs[i]);
-		mlxsw_sp_port->tclass_qdiscs[i].prio_bitmap = 0;
+				       &qdisc_state->tclass_qdiscs[i]);
+		qdisc_state->tclass_qdiscs[i].prio_bitmap = 0;
 	}
 
 	return 0;
@@ -786,6 +798,7 @@ __mlxsw_sp_qdisc_ets_replace(struct mlxsw_sp_port *mlxsw_sp_port,
 			     const unsigned int *weights,
 			     const u8 *priomap)
 {
+	struct mlxsw_sp_qdisc_state *qdisc_state = mlxsw_sp_port->qdisc;
 	struct mlxsw_sp_qdisc *child_qdisc;
 	int tclass, i, band, backlog;
 	u8 old_priomap;
@@ -793,7 +806,7 @@ __mlxsw_sp_qdisc_ets_replace(struct mlxsw_sp_port *mlxsw_sp_port,
 
 	for (band = 0; band < nbands; band++) {
 		tclass = MLXSW_SP_PRIO_BAND_TO_TCLASS(band);
-		child_qdisc = &mlxsw_sp_port->tclass_qdiscs[tclass];
+		child_qdisc = &qdisc_state->tclass_qdiscs[tclass];
 		old_priomap = child_qdisc->prio_bitmap;
 		child_qdisc->prio_bitmap = 0;
 
@@ -825,7 +838,7 @@ __mlxsw_sp_qdisc_ets_replace(struct mlxsw_sp_port *mlxsw_sp_port,
 	}
 	for (; band < IEEE_8021QAZ_MAX_TCS; band++) {
 		tclass = MLXSW_SP_PRIO_BAND_TO_TCLASS(band);
-		child_qdisc = &mlxsw_sp_port->tclass_qdiscs[tclass];
+		child_qdisc = &qdisc_state->tclass_qdiscs[tclass];
 		child_qdisc->prio_bitmap = 0;
 		mlxsw_sp_qdisc_destroy(mlxsw_sp_port, child_qdisc);
 		mlxsw_sp_port_ets_set(mlxsw_sp_port,
@@ -875,6 +888,7 @@ mlxsw_sp_qdisc_get_prio_stats(struct mlxsw_sp_port *mlxsw_sp_port,
 			      struct mlxsw_sp_qdisc *mlxsw_sp_qdisc,
 			      struct tc_qopt_offload_stats *stats_ptr)
 {
+	struct mlxsw_sp_qdisc_state *qdisc_state = mlxsw_sp_port->qdisc;
 	struct mlxsw_sp_qdisc *tc_qdisc;
 	u64 tx_packets = 0;
 	u64 tx_bytes = 0;
@@ -883,7 +897,7 @@ mlxsw_sp_qdisc_get_prio_stats(struct mlxsw_sp_port *mlxsw_sp_port,
 	int i;
 
 	for (i = 0; i < IEEE_8021QAZ_MAX_TCS; i++) {
-		tc_qdisc = &mlxsw_sp_port->tclass_qdiscs[i];
+		tc_qdisc = &qdisc_state->tclass_qdiscs[i];
 		mlxsw_sp_qdisc_collect_tc_stats(mlxsw_sp_port, tc_qdisc,
 						&tx_bytes, &tx_packets,
 						&drops, &backlog);
@@ -1009,11 +1023,12 @@ __mlxsw_sp_qdisc_ets_graft(struct mlxsw_sp_port *mlxsw_sp_port,
 			   struct mlxsw_sp_qdisc *mlxsw_sp_qdisc,
 			   u8 band, u32 child_handle)
 {
+	struct mlxsw_sp_qdisc_state *qdisc_state = mlxsw_sp_port->qdisc;
 	int tclass_num = MLXSW_SP_PRIO_BAND_TO_TCLASS(band);
 	struct mlxsw_sp_qdisc *old_qdisc;
 
 	if (band < IEEE_8021QAZ_MAX_TCS &&
-	    mlxsw_sp_port->tclass_qdiscs[tclass_num].handle == child_handle)
+	    qdisc_state->tclass_qdiscs[tclass_num].handle == child_handle)
 		return 0;
 
 	if (!child_handle) {
@@ -1032,7 +1047,7 @@ __mlxsw_sp_qdisc_ets_graft(struct mlxsw_sp_port *mlxsw_sp_port,
 		mlxsw_sp_qdisc_destroy(mlxsw_sp_port, old_qdisc);
 
 	mlxsw_sp_qdisc_destroy(mlxsw_sp_port,
-			       &mlxsw_sp_port->tclass_qdiscs[tclass_num]);
+			       &qdisc_state->tclass_qdiscs[tclass_num]);
 	return -EOPNOTSUPP;
 }
 
@@ -1114,37 +1129,23 @@ int mlxsw_sp_setup_tc_ets(struct mlxsw_sp_port *mlxsw_sp_port,
 
 int mlxsw_sp_tc_qdisc_init(struct mlxsw_sp_port *mlxsw_sp_port)
 {
-	struct mlxsw_sp_qdisc *mlxsw_sp_qdisc;
+	struct mlxsw_sp_qdisc_state *qdisc_state;
 	int i;
 
-	mlxsw_sp_qdisc = kzalloc(sizeof(*mlxsw_sp_qdisc), GFP_KERNEL);
-	if (!mlxsw_sp_qdisc)
-		goto err_root_qdisc_init;
+	qdisc_state = kzalloc(sizeof(*qdisc_state), GFP_KERNEL);
+	if (!qdisc_state)
+		return -ENOMEM;
 
-	mlxsw_sp_port->root_qdisc = mlxsw_sp_qdisc;
-	mlxsw_sp_port->root_qdisc->prio_bitmap = 0xff;
-	mlxsw_sp_port->root_qdisc->tclass_num = MLXSW_SP_PORT_DEFAULT_TCLASS;
-
-	mlxsw_sp_qdisc = kcalloc(IEEE_8021QAZ_MAX_TCS,
-				 sizeof(*mlxsw_sp_qdisc),
-				 GFP_KERNEL);
-	if (!mlxsw_sp_qdisc)
-		goto err_tclass_qdiscs_init;
-
-	mlxsw_sp_port->tclass_qdiscs = mlxsw_sp_qdisc;
+	qdisc_state->root_qdisc.prio_bitmap = 0xff;
+	qdisc_state->root_qdisc.tclass_num = MLXSW_SP_PORT_DEFAULT_TCLASS;
 	for (i = 0; i < IEEE_8021QAZ_MAX_TCS; i++)
-		mlxsw_sp_port->tclass_qdiscs[i].tclass_num = i;
+		qdisc_state->tclass_qdiscs[i].tclass_num = i;
 
+	mlxsw_sp_port->qdisc = qdisc_state;
 	return 0;
-
-err_tclass_qdiscs_init:
-	kfree(mlxsw_sp_port->root_qdisc);
-err_root_qdisc_init:
-	return -ENOMEM;
 }
 
 void mlxsw_sp_tc_qdisc_fini(struct mlxsw_sp_port *mlxsw_sp_port)
 {
-	kfree(mlxsw_sp_port->tclass_qdiscs);
-	kfree(mlxsw_sp_port->root_qdisc);
+	kfree(mlxsw_sp_port->qdisc);
 }
-- 
2.24.1

