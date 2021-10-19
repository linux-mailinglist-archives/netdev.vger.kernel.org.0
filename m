Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A785B4330C3
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 10:08:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234694AbhJSIK0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 04:10:26 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:50757 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234812AbhJSIKQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 04:10:16 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 397F35C00C3;
        Tue, 19 Oct 2021 04:08:04 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 19 Oct 2021 04:08:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=yWLHtCFuIC3vRTWudHa9ZuygnwYzXnow/FMRHbNqzO4=; b=n5LAmswv
        XieIPGbA3P7k4/4ISO3Gw7x/tADaXtUhOhpX3Z6q8dt2NYMgFDP6rDfDmGP9AkmJ
        5mmuwsrQN/7JTvVsY9vpxOVzpDtBi/Mpjz0T6Fch4AAxeF23FFtdRelCD5unYNMh
        7/KMawAQvQ2VnxenbY/E0wz+pm2t2tRL1pCcqGcVolUv5+k3pxYNHHwdsWvuBvAy
        Pf9yAbPseltmhYRvGL/7r5qHrB0B6DKCQ5JPf9CTDhofCkmLKUNQjOIiL4ElWnXh
        sj/Q5LyhUMpWDufAfKPxb6KOaxD/QUXn3LVybuXabvkPW0z/fC1kbenYcofPNfrs
        4fJGvGYXniiBnA==
X-ME-Sender: <xms:5HxuYX7SRgx_tIUMEsTX6pb02w4UPnHAOMALhGvWU6zQjTKX8UC2ew>
    <xme:5HxuYc7vYnN8kGBXSVnUq-9rNSigixIm_ksoMmoLysNRlhiModEbxnG1RUI7NaA6w
    Se8hGanC1Xx1yc>
X-ME-Received: <xmr:5HxuYeeG27H0FGyDeGAThzwzG_KFs-JapZ7GWbc3Zfe6Df1ac2hTsidcdIOUkxFvK_Oc0W0TPJfgozv_xhaqWgX3BaydiWY814t4sL42ZRA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvddvuddguddvhecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhf
    ekhefgtdfftefhledvjefggfehgfevjeekhfenucevlhhushhtvghrufhiiigvpedunecu
    rfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:5HxuYYJmg-mhmS6gNBGkzzRjvnEgH2-t27HEP_rlh4HSBNUxjWTrSw>
    <xmx:5HxuYbI1J_NG5n9fhdj7Tu_rGLh1zdnRY9jJc4LVvJU4c5DKPL6JOQ>
    <xmx:5HxuYRxl7h4K-NTExNo46C3GSbt3suCiGWGevQ5bfpRacFN6ebyLfQ>
    <xmx:5HxuYT_TJfh0tlAcUJN9vG_y-UTWAy96NGrhgRkcpdIJ4r2fP0aU6g>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 19 Oct 2021 04:08:01 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 2/9] mlxsw: spectrum_qdisc: Query tclass / priomap instead of caching it
Date:   Tue, 19 Oct 2021 11:07:05 +0300
Message-Id: <20211019080712.705464-3-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211019080712.705464-1-idosch@idosch.org>
References: <20211019080712.705464-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@nvidia.com>

Currently when keeping track of qdiscs, mlxsw notes the TC and priomap
corresponding to each qdisc. That is fine currently, as there only ever is
one level of qdiscs to update: the direct children of ETS / PRIO. However
as deeper structures are made offloadable, ETS would need to update these
values for the complete subtree, and interim qdiscs would need to remember
to propagate the value.

Instead, reverse the responsibility: child qdiscs can ask their parent what
their TC and priomap are. ETS / PRIO know the answer right away, or there
are defaults for when the root qdisc does not assign them (e.g. when RED is
used as root qdisc). When RED and TBF become classful, they will simply
forward the request up to their parent.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_qdisc.c  | 180 ++++++++++++++----
 1 file changed, 146 insertions(+), 34 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
index 6d1431fa31d7..5114d65ed33f 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
@@ -50,12 +50,24 @@ struct mlxsw_sp_qdisc_ops {
 	struct mlxsw_sp_qdisc *(*find_class)(struct mlxsw_sp_qdisc *mlxsw_sp_qdisc,
 					     u32 parent);
 	unsigned int num_classes;
+
+	u8 (*get_prio_bitmap)(struct mlxsw_sp_qdisc *mlxsw_sp_qdisc,
+			      struct mlxsw_sp_qdisc *child);
+	int (*get_tclass_num)(struct mlxsw_sp_qdisc *mlxsw_sp_qdisc,
+			      struct mlxsw_sp_qdisc *child);
+};
+
+struct mlxsw_sp_qdisc_ets_band {
+	u8 prio_bitmap;
+	int tclass_num;
+};
+
+struct mlxsw_sp_qdisc_ets_data {
+	struct mlxsw_sp_qdisc_ets_band bands[IEEE_8021QAZ_MAX_TCS];
 };
 
 struct mlxsw_sp_qdisc {
 	u32 handle;
-	int tclass_num;
-	u8 prio_bitmap;
 	union {
 		struct red_stats red;
 	} xstats_base;
@@ -67,6 +79,10 @@ struct mlxsw_sp_qdisc {
 		u64 backlog;
 	} stats_base;
 
+	union {
+		struct mlxsw_sp_qdisc_ets_data *ets_data;
+	};
+
 	struct mlxsw_sp_qdisc_ops *ops;
 	struct mlxsw_sp_qdisc *parent;
 	struct mlxsw_sp_qdisc *qdiscs;
@@ -187,6 +203,28 @@ mlxsw_sp_qdisc_reduce_parent_backlog(struct mlxsw_sp_qdisc *mlxsw_sp_qdisc)
 		tmp->stats_base.backlog -= mlxsw_sp_qdisc->stats_base.backlog;
 }
 
+static u8 mlxsw_sp_qdisc_get_prio_bitmap(struct mlxsw_sp_port *mlxsw_sp_port,
+					 struct mlxsw_sp_qdisc *mlxsw_sp_qdisc)
+{
+	struct mlxsw_sp_qdisc *parent = mlxsw_sp_qdisc->parent;
+
+	if (!parent)
+		return 0xff;
+	return parent->ops->get_prio_bitmap(parent, mlxsw_sp_qdisc);
+}
+
+#define MLXSW_SP_PORT_DEFAULT_TCLASS 0
+
+static int mlxsw_sp_qdisc_get_tclass_num(struct mlxsw_sp_port *mlxsw_sp_port,
+					 struct mlxsw_sp_qdisc *mlxsw_sp_qdisc)
+{
+	struct mlxsw_sp_qdisc *parent = mlxsw_sp_qdisc->parent;
+
+	if (!parent)
+		return MLXSW_SP_PORT_DEFAULT_TCLASS;
+	return parent->ops->get_tclass_num(parent, mlxsw_sp_qdisc);
+}
+
 static int
 mlxsw_sp_qdisc_destroy(struct mlxsw_sp_port *mlxsw_sp_port,
 		       struct mlxsw_sp_qdisc *mlxsw_sp_qdisc)
@@ -406,13 +444,17 @@ mlxsw_sp_qdisc_collect_tc_stats(struct mlxsw_sp_port *mlxsw_sp_port,
 				u64 *p_tx_bytes, u64 *p_tx_packets,
 				u64 *p_drops, u64 *p_backlog)
 {
-	int tclass_num = mlxsw_sp_qdisc->tclass_num;
 	struct mlxsw_sp_port_xstats *xstats;
 	u64 tx_bytes, tx_packets;
+	u8 prio_bitmap;
+	int tclass_num;
 
+	prio_bitmap = mlxsw_sp_qdisc_get_prio_bitmap(mlxsw_sp_port,
+						     mlxsw_sp_qdisc);
+	tclass_num = mlxsw_sp_qdisc_get_tclass_num(mlxsw_sp_port,
+						   mlxsw_sp_qdisc);
 	xstats = &mlxsw_sp_port->periodic_hw_stats.xstats;
-	mlxsw_sp_qdisc_bstats_per_priority_get(xstats,
-					       mlxsw_sp_qdisc->prio_bitmap,
+	mlxsw_sp_qdisc_bstats_per_priority_get(xstats, prio_bitmap,
 					       &tx_packets, &tx_bytes);
 
 	*p_tx_packets += tx_packets;
@@ -506,17 +548,21 @@ static void
 mlxsw_sp_setup_tc_qdisc_red_clean_stats(struct mlxsw_sp_port *mlxsw_sp_port,
 					struct mlxsw_sp_qdisc *mlxsw_sp_qdisc)
 {
-	int tclass_num = mlxsw_sp_qdisc->tclass_num;
 	struct mlxsw_sp_qdisc_stats *stats_base;
 	struct mlxsw_sp_port_xstats *xstats;
 	struct red_stats *red_base;
+	u8 prio_bitmap;
+	int tclass_num;
 
+	prio_bitmap = mlxsw_sp_qdisc_get_prio_bitmap(mlxsw_sp_port,
+						     mlxsw_sp_qdisc);
+	tclass_num = mlxsw_sp_qdisc_get_tclass_num(mlxsw_sp_port,
+						   mlxsw_sp_qdisc);
 	xstats = &mlxsw_sp_port->periodic_hw_stats.xstats;
 	stats_base = &mlxsw_sp_qdisc->stats_base;
 	red_base = &mlxsw_sp_qdisc->xstats_base.red;
 
-	mlxsw_sp_qdisc_bstats_per_priority_get(xstats,
-					       mlxsw_sp_qdisc->prio_bitmap,
+	mlxsw_sp_qdisc_bstats_per_priority_get(xstats, prio_bitmap,
 					       &stats_base->tx_packets,
 					       &stats_base->tx_bytes);
 	red_base->prob_mark = xstats->tc_ecn[tclass_num];
@@ -533,8 +579,10 @@ static int
 mlxsw_sp_qdisc_red_destroy(struct mlxsw_sp_port *mlxsw_sp_port,
 			   struct mlxsw_sp_qdisc *mlxsw_sp_qdisc)
 {
-	return mlxsw_sp_tclass_congestion_disable(mlxsw_sp_port,
-						  mlxsw_sp_qdisc->tclass_num);
+	int tclass_num = mlxsw_sp_qdisc_get_tclass_num(mlxsw_sp_port,
+						       mlxsw_sp_qdisc);
+
+	return mlxsw_sp_tclass_congestion_disable(mlxsw_sp_port, tclass_num);
 }
 
 static int
@@ -571,10 +619,13 @@ mlxsw_sp_qdisc_red_replace(struct mlxsw_sp_port *mlxsw_sp_port, u32 handle,
 {
 	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
 	struct tc_red_qopt_offload_params *p = params;
-	int tclass_num = mlxsw_sp_qdisc->tclass_num;
+	int tclass_num;
 	u32 min, max;
 	u64 prob;
 
+	tclass_num = mlxsw_sp_qdisc_get_tclass_num(mlxsw_sp_port,
+						   mlxsw_sp_qdisc);
+
 	/* calculate probability in percentage */
 	prob = p->probability;
 	prob *= 100;
@@ -616,11 +667,13 @@ mlxsw_sp_qdisc_get_red_xstats(struct mlxsw_sp_port *mlxsw_sp_port,
 			      void *xstats_ptr)
 {
 	struct red_stats *xstats_base = &mlxsw_sp_qdisc->xstats_base.red;
-	int tclass_num = mlxsw_sp_qdisc->tclass_num;
 	struct mlxsw_sp_port_xstats *xstats;
 	struct red_stats *res = xstats_ptr;
 	int early_drops, marks, pdrops;
+	int tclass_num;
 
+	tclass_num = mlxsw_sp_qdisc_get_tclass_num(mlxsw_sp_port,
+						   mlxsw_sp_qdisc);
 	xstats = &mlxsw_sp_port->periodic_hw_stats.xstats;
 
 	early_drops = xstats->wred_drop[tclass_num] - xstats_base->prob_drop;
@@ -643,11 +696,13 @@ mlxsw_sp_qdisc_get_red_stats(struct mlxsw_sp_port *mlxsw_sp_port,
 			     struct mlxsw_sp_qdisc *mlxsw_sp_qdisc,
 			     struct tc_qopt_offload_stats *stats_ptr)
 {
-	int tclass_num = mlxsw_sp_qdisc->tclass_num;
 	struct mlxsw_sp_qdisc_stats *stats_base;
 	struct mlxsw_sp_port_xstats *xstats;
 	u64 overlimits;
+	int tclass_num;
 
+	tclass_num = mlxsw_sp_qdisc_get_tclass_num(mlxsw_sp_port,
+						   mlxsw_sp_qdisc);
 	xstats = &mlxsw_sp_port->periodic_hw_stats.xstats;
 	stats_base = &mlxsw_sp_qdisc->stats_base;
 
@@ -668,8 +723,6 @@ mlxsw_sp_qdisc_leaf_find_class(struct mlxsw_sp_qdisc *mlxsw_sp_qdisc,
 	return NULL;
 }
 
-#define MLXSW_SP_PORT_DEFAULT_TCLASS 0
-
 static struct mlxsw_sp_qdisc_ops mlxsw_sp_qdisc_ops_red = {
 	.type = MLXSW_SP_QDISC_RED,
 	.check_params = mlxsw_sp_qdisc_red_check_params,
@@ -749,9 +802,12 @@ static int
 mlxsw_sp_qdisc_tbf_destroy(struct mlxsw_sp_port *mlxsw_sp_port,
 			   struct mlxsw_sp_qdisc *mlxsw_sp_qdisc)
 {
+	int tclass_num = mlxsw_sp_qdisc_get_tclass_num(mlxsw_sp_port,
+						       mlxsw_sp_qdisc);
+
 	return mlxsw_sp_port_ets_maxrate_set(mlxsw_sp_port,
 					     MLXSW_REG_QEEC_HR_SUBGROUP,
-					     mlxsw_sp_qdisc->tclass_num, 0,
+					     tclass_num, 0,
 					     MLXSW_REG_QEEC_MAS_DIS, 0);
 }
 
@@ -835,9 +891,13 @@ mlxsw_sp_qdisc_tbf_replace(struct mlxsw_sp_port *mlxsw_sp_port, u32 handle,
 {
 	struct tc_tbf_qopt_offload_replace_params *p = params;
 	u64 rate_kbps = mlxsw_sp_qdisc_tbf_rate_kbps(p);
+	int tclass_num;
 	u8 burst_size;
 	int err;
 
+	tclass_num = mlxsw_sp_qdisc_get_tclass_num(mlxsw_sp_port,
+						   mlxsw_sp_qdisc);
+
 	err = mlxsw_sp_qdisc_tbf_bs(mlxsw_sp_port, p->max_size, &burst_size);
 	if (WARN_ON_ONCE(err))
 		/* check_params above was supposed to reject this value. */
@@ -853,7 +913,7 @@ mlxsw_sp_qdisc_tbf_replace(struct mlxsw_sp_port *mlxsw_sp_port, u32 handle,
 	 */
 	return mlxsw_sp_port_ets_maxrate_set(mlxsw_sp_port,
 					     MLXSW_REG_QEEC_HR_SUBGROUP,
-					     mlxsw_sp_qdisc->tclass_num, 0,
+					     tclass_num, 0,
 					     rate_kbps, burst_size);
 }
 
@@ -1040,9 +1100,10 @@ static int __mlxsw_sp_qdisc_ets_destroy(struct mlxsw_sp_port *mlxsw_sp_port,
 				      i, 0, false, 0);
 		mlxsw_sp_qdisc_destroy(mlxsw_sp_port,
 				       &mlxsw_sp_qdisc->qdiscs[i]);
-		mlxsw_sp_qdisc->qdiscs[i].prio_bitmap = 0;
 	}
 
+	kfree(mlxsw_sp_qdisc->ets_data);
+	mlxsw_sp_qdisc->ets_data = NULL;
 	return 0;
 }
 
@@ -1079,40 +1140,60 @@ __mlxsw_sp_qdisc_ets_replace(struct mlxsw_sp_port *mlxsw_sp_port,
 			     const unsigned int *weights,
 			     const u8 *priomap)
 {
+	struct mlxsw_sp_qdisc_ets_data *ets_data = mlxsw_sp_qdisc->ets_data;
 	struct mlxsw_sp_qdisc_state *qdisc_state = mlxsw_sp_port->qdisc;
+	struct mlxsw_sp_qdisc_ets_band *ets_band;
 	struct mlxsw_sp_qdisc *child_qdisc;
-	int tclass, i, band, backlog;
-	u8 old_priomap;
+	u8 old_priomap, new_priomap;
+	int i, band, backlog;
 	int err;
 
+	if (!ets_data) {
+		ets_data = kzalloc(sizeof(*ets_data), GFP_KERNEL);
+		if (!ets_data)
+			return -ENOMEM;
+		mlxsw_sp_qdisc->ets_data = ets_data;
+
+		for (band = 0; band < mlxsw_sp_qdisc->num_classes; band++) {
+			int tclass_num = MLXSW_SP_PRIO_BAND_TO_TCLASS(band);
+
+			ets_band = &ets_data->bands[band];
+			ets_band->tclass_num = tclass_num;
+		}
+	}
+
 	for (band = 0; band < nbands; band++) {
-		tclass = MLXSW_SP_PRIO_BAND_TO_TCLASS(band);
+		int tclass_num;
+
 		child_qdisc = &mlxsw_sp_qdisc->qdiscs[band];
-		old_priomap = child_qdisc->prio_bitmap;
-		child_qdisc->prio_bitmap = 0;
+		ets_band = &ets_data->bands[band];
+
+		tclass_num = ets_band->tclass_num;
+		old_priomap = ets_band->prio_bitmap;
+		new_priomap = 0;
 
 		err = mlxsw_sp_port_ets_set(mlxsw_sp_port,
 					    MLXSW_REG_QEEC_HR_SUBGROUP,
-					    tclass, 0, !!quanta[band],
+					    tclass_num, 0, !!quanta[band],
 					    weights[band]);
 		if (err)
 			return err;
 
 		for (i = 0; i < IEEE_8021QAZ_MAX_TCS; i++) {
 			if (priomap[i] == band) {
-				child_qdisc->prio_bitmap |= BIT(i);
+				new_priomap |= BIT(i);
 				if (BIT(i) & old_priomap)
 					continue;
 				err = mlxsw_sp_port_prio_tc_set(mlxsw_sp_port,
-								i, tclass);
+								i, tclass_num);
 				if (err)
 					return err;
 			}
 		}
 
-		child_qdisc->tclass_num = tclass;
+		ets_band->prio_bitmap = new_priomap;
 
-		if (old_priomap != child_qdisc->prio_bitmap &&
+		if (old_priomap != new_priomap &&
 		    child_qdisc->ops && child_qdisc->ops->clean_stats) {
 			backlog = child_qdisc->stats_base.backlog;
 			child_qdisc->ops->clean_stats(mlxsw_sp_port,
@@ -1131,13 +1212,15 @@ __mlxsw_sp_qdisc_ets_replace(struct mlxsw_sp_port *mlxsw_sp_port,
 		}
 	}
 	for (; band < IEEE_8021QAZ_MAX_TCS; band++) {
-		tclass = MLXSW_SP_PRIO_BAND_TO_TCLASS(band);
+		ets_band = &ets_data->bands[band];
+		ets_band->prio_bitmap = 0;
+
 		child_qdisc = &mlxsw_sp_qdisc->qdiscs[band];
-		child_qdisc->prio_bitmap = 0;
 		mlxsw_sp_qdisc_destroy(mlxsw_sp_port, child_qdisc);
+
 		mlxsw_sp_port_ets_set(mlxsw_sp_port,
 				      MLXSW_REG_QEEC_HR_SUBGROUP,
-				      tclass, 0, false, 0);
+				      ets_band->tclass_num, 0, false, 0);
 	}
 
 	qdisc_state->future_handle = TC_H_UNSPEC;
@@ -1243,6 +1326,31 @@ mlxsw_sp_qdisc_prio_find_class(struct mlxsw_sp_qdisc *mlxsw_sp_qdisc,
 	return &mlxsw_sp_qdisc->qdiscs[band];
 }
 
+static struct mlxsw_sp_qdisc_ets_band *
+mlxsw_sp_qdisc_ets_get_band(struct mlxsw_sp_qdisc *mlxsw_sp_qdisc,
+			    struct mlxsw_sp_qdisc *child)
+{
+	unsigned int band = child - mlxsw_sp_qdisc->qdiscs;
+
+	if (WARN_ON(band >= IEEE_8021QAZ_MAX_TCS))
+		band = 0;
+	return &mlxsw_sp_qdisc->ets_data->bands[band];
+}
+
+static u8
+mlxsw_sp_qdisc_ets_get_prio_bitmap(struct mlxsw_sp_qdisc *mlxsw_sp_qdisc,
+				   struct mlxsw_sp_qdisc *child)
+{
+	return mlxsw_sp_qdisc_ets_get_band(mlxsw_sp_qdisc, child)->prio_bitmap;
+}
+
+static int
+mlxsw_sp_qdisc_ets_get_tclass_num(struct mlxsw_sp_qdisc *mlxsw_sp_qdisc,
+				  struct mlxsw_sp_qdisc *child)
+{
+	return mlxsw_sp_qdisc_ets_get_band(mlxsw_sp_qdisc, child)->tclass_num;
+}
+
 static struct mlxsw_sp_qdisc_ops mlxsw_sp_qdisc_ops_prio = {
 	.type = MLXSW_SP_QDISC_PRIO,
 	.check_params = mlxsw_sp_qdisc_prio_check_params,
@@ -1253,6 +1361,8 @@ static struct mlxsw_sp_qdisc_ops mlxsw_sp_qdisc_ops_prio = {
 	.clean_stats = mlxsw_sp_setup_tc_qdisc_prio_clean_stats,
 	.find_class = mlxsw_sp_qdisc_prio_find_class,
 	.num_classes = IEEE_8021QAZ_MAX_TCS,
+	.get_prio_bitmap = mlxsw_sp_qdisc_ets_get_prio_bitmap,
+	.get_tclass_num = mlxsw_sp_qdisc_ets_get_tclass_num,
 };
 
 static int
@@ -1304,6 +1414,8 @@ static struct mlxsw_sp_qdisc_ops mlxsw_sp_qdisc_ops_ets = {
 	.clean_stats = mlxsw_sp_setup_tc_qdisc_prio_clean_stats,
 	.find_class = mlxsw_sp_qdisc_prio_find_class,
 	.num_classes = IEEE_8021QAZ_MAX_TCS,
+	.get_prio_bitmap = mlxsw_sp_qdisc_ets_get_prio_bitmap,
+	.get_tclass_num = mlxsw_sp_qdisc_ets_get_tclass_num,
 };
 
 /* Linux allows linking of Qdiscs to arbitrary classes (so long as the resulting
@@ -1902,6 +2014,7 @@ mlxsw_sp_setup_tc_block_qevent_bind(struct mlxsw_sp_port *mlxsw_sp_port,
 	struct flow_block_cb *block_cb;
 	struct mlxsw_sp_qdisc *qdisc;
 	bool register_block = false;
+	int tclass_num;
 	int err;
 
 	block_cb = flow_block_cb_lookup(f->block, mlxsw_sp_qevent_block_cb, mlxsw_sp);
@@ -1934,9 +2047,10 @@ mlxsw_sp_setup_tc_block_qevent_bind(struct mlxsw_sp_port *mlxsw_sp_port,
 		goto err_binding_exists;
 	}
 
+	tclass_num = mlxsw_sp_qdisc_get_tclass_num(mlxsw_sp_port, qdisc);
 	qevent_binding = mlxsw_sp_qevent_binding_create(mlxsw_sp_port,
 							f->sch->handle,
-							qdisc->tclass_num,
+							tclass_num,
 							span_trigger,
 							action_mask);
 	if (IS_ERR(qevent_binding)) {
@@ -2048,8 +2162,6 @@ int mlxsw_sp_tc_qdisc_init(struct mlxsw_sp_port *mlxsw_sp_port)
 		return -ENOMEM;
 
 	mutex_init(&qdisc_state->lock);
-	qdisc_state->root_qdisc.prio_bitmap = 0xff;
-	qdisc_state->root_qdisc.tclass_num = MLXSW_SP_PORT_DEFAULT_TCLASS;
 	mlxsw_sp_port->qdisc = qdisc_state;
 	return 0;
 }
-- 
2.31.1

