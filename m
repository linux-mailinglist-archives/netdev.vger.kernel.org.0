Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A7B233D66B
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 16:05:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237732AbhCPPEr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 11:04:47 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:43717 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237678AbhCPPEM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 11:04:12 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id AD0D05C00CB;
        Tue, 16 Mar 2021 11:04:11 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 16 Mar 2021 11:04:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=0wIWB+f7cmHTcyAfdZtEA5GCNY8r3d+2NJQI/2LOU8E=; b=RnJOpk65
        Hf4B3v0lYvXaH/cSNm2wenoxHi1mUOAEh+xUJkOO7KyWDsagV4n4w+vIxxxcQymJ
        WW3gRwkjNpfAv+eFJNA6bYHihapuRKVbSCRfd9G0yTgI7kz3Thuc3u7CU2aeLJdv
        t1PY4EtTqSumfxnuKMNx66EdTHg8P0IrxdgxAWweaRWVLiVmB2ChiWv6dqvw0/7j
        ETDXuezQJxsfnMvnq+m7eRXmTRHFG80USmOKHSmwlYqGIeDQQpm89qSzUFicnYTG
        4mXgLXa4lbIHHYvDZN2TTcjCR3Wkl4rKwYATg4SC+g2SBEs+yXy36TGRGgfnY0oK
        /0A338Dwm8p5XA==
X-ME-Sender: <xms:68hQYBPIyqZ9-LpIJTEnxQbbd0t583atN8dIB5Hg3VIDMSuVNXhu0Q>
    <xme:68hQYD9ekmf-7rSXrLSZRSnuVu1m8rOAu_UaOl43VkOXLBDGtZDTuMBv8fIoyvwJO
    dHwyZjyklIURts>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudefvddgjeefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehfedrgeeg
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:68hQYAQTcxWNGpApNuMLKbkj5950_uu7npuVHWyiGUmQavUCWjd1ww>
    <xmx:68hQYNscqMkOzZA37LrHMC9En_Q5teDjLbEw5KLV6WhGQohN5dntDg>
    <xmx:68hQYJfPqKYAN7CkTgy_QNV9-O57AxVz6Z1RpUZ8HedJNo400HveyA>
    <xmx:68hQYCHnHmLbdPREaBQulllRRItMLgW0KhOk0elsDq25PbkfzyJuZg>
Received: from shredder.lan (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id A9D6B1080057;
        Tue, 16 Mar 2021 11:04:09 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        roopa@nvidia.com, peter.phaal@inmon.com, neil.mckee@inmon.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 05/10] mlxsw: spectrum: Start using sampling triggers hash table
Date:   Tue, 16 Mar 2021 17:02:58 +0200
Message-Id: <20210316150303.2868588-6-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210316150303.2868588-1-idosch@idosch.org>
References: <20210316150303.2868588-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Start using the previously introduced sampling triggers hash table to
store sampling parameters instead of storing them as attributes of the
sampled port.

This makes it easier to introduce new sampling triggers.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.h    | 16 ++----
 .../mellanox/mlxsw/spectrum_matchall.c        | 57 ++++++++++---------
 .../ethernet/mellanox/mlxsw/spectrum_trap.c   | 15 +++--
 3 files changed, 46 insertions(+), 42 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index 877d17f42e4a..4b4d643abceb 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -253,14 +253,6 @@ struct mlxsw_sp_sample_params {
 	bool truncate;
 };
 
-struct mlxsw_sp_port_sample {
-	struct psample_group *psample_group;
-	u32 trunc_size;
-	u32 rate;
-	bool truncate;
-	int span_id;	/* Relevant for Spectrum-2 onwards. */
-};
-
 struct mlxsw_sp_bridge_port;
 struct mlxsw_sp_fid;
 
@@ -324,7 +316,6 @@ struct mlxsw_sp_port {
 		struct mlxsw_sp_port_xstats xstats;
 		struct delayed_work update_dw;
 	} periodic_hw_stats;
-	struct mlxsw_sp_port_sample __rcu *sample;
 	struct list_head vlans_list;
 	struct mlxsw_sp_port_vlan *default_vlan;
 	struct mlxsw_sp_qdisc_state *qdisc;
@@ -1092,6 +1083,11 @@ struct mlxsw_sp_mall_trap_entry {
 	int span_id;
 };
 
+struct mlxsw_sp_mall_sample_entry {
+	struct mlxsw_sp_sample_params params;
+	int span_id;	/* Relevant for Spectrum-2 onwards. */
+};
+
 struct mlxsw_sp_mall_entry {
 	struct list_head list;
 	unsigned long cookie;
@@ -1101,7 +1097,7 @@ struct mlxsw_sp_mall_entry {
 	union {
 		struct mlxsw_sp_mall_mirror_entry mirror;
 		struct mlxsw_sp_mall_trap_entry trap;
-		struct mlxsw_sp_port_sample sample;
+		struct mlxsw_sp_mall_sample_entry sample;
 	};
 	struct rcu_head rcu;
 };
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_matchall.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_matchall.c
index b189e84987db..459c452b60ba 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_matchall.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_matchall.c
@@ -105,13 +105,19 @@ mlxsw_sp_mall_port_sample_add(struct mlxsw_sp_port *mlxsw_sp_port,
 			      struct netlink_ext_ack *extack)
 {
 	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
+	struct mlxsw_sp_sample_trigger trigger;
 	int err;
 
-	if (rtnl_dereference(mlxsw_sp_port->sample)) {
-		NL_SET_ERR_MSG(extack, "Sampling already active on port");
-		return -EEXIST;
-	}
-	rcu_assign_pointer(mlxsw_sp_port->sample, &mall_entry->sample);
+	if (mall_entry->ingress)
+		trigger.type = MLXSW_SP_SAMPLE_TRIGGER_TYPE_INGRESS;
+	else
+		trigger.type = MLXSW_SP_SAMPLE_TRIGGER_TYPE_EGRESS;
+	trigger.local_port = mlxsw_sp_port->local_port;
+	err = mlxsw_sp_sample_trigger_params_set(mlxsw_sp, &trigger,
+						 &mall_entry->sample.params,
+						 extack);
+	if (err)
+		return err;
 
 	err = mlxsw_sp->mall_ops->sample_add(mlxsw_sp, mlxsw_sp_port,
 					     mall_entry, extack);
@@ -120,7 +126,7 @@ mlxsw_sp_mall_port_sample_add(struct mlxsw_sp_port *mlxsw_sp_port,
 	return 0;
 
 err_port_sample_set:
-	RCU_INIT_POINTER(mlxsw_sp_port->sample, NULL);
+	mlxsw_sp_sample_trigger_params_unset(mlxsw_sp, &trigger);
 	return err;
 }
 
@@ -129,12 +135,16 @@ mlxsw_sp_mall_port_sample_del(struct mlxsw_sp_port *mlxsw_sp_port,
 			      struct mlxsw_sp_mall_entry *mall_entry)
 {
 	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
+	struct mlxsw_sp_sample_trigger trigger;
 
-	if (!mlxsw_sp_port->sample)
-		return;
+	if (mall_entry->ingress)
+		trigger.type = MLXSW_SP_SAMPLE_TRIGGER_TYPE_INGRESS;
+	else
+		trigger.type = MLXSW_SP_SAMPLE_TRIGGER_TYPE_EGRESS;
+	trigger.local_port = mlxsw_sp_port->local_port;
 
 	mlxsw_sp->mall_ops->sample_del(mlxsw_sp, mlxsw_sp_port, mall_entry);
-	RCU_INIT_POINTER(mlxsw_sp_port->sample, NULL);
+	mlxsw_sp_sample_trigger_params_unset(mlxsw_sp, &trigger);
 }
 
 static int
@@ -261,10 +271,10 @@ int mlxsw_sp_mall_replace(struct mlxsw_sp *mlxsw_sp,
 			goto errout;
 		}
 		mall_entry->type = MLXSW_SP_MALL_ACTION_TYPE_SAMPLE;
-		mall_entry->sample.psample_group = act->sample.psample_group;
-		mall_entry->sample.truncate = act->sample.truncate;
-		mall_entry->sample.trunc_size = act->sample.trunc_size;
-		mall_entry->sample.rate = act->sample.rate;
+		mall_entry->sample.params.psample_group = act->sample.psample_group;
+		mall_entry->sample.params.truncate = act->sample.truncate;
+		mall_entry->sample.params.trunc_size = act->sample.trunc_size;
+		mall_entry->sample.params.rate = act->sample.rate;
 	} else {
 		err = -EOPNOTSUPP;
 		goto errout;
@@ -369,7 +379,7 @@ static int mlxsw_sp1_mall_sample_add(struct mlxsw_sp *mlxsw_sp,
 				     struct mlxsw_sp_mall_entry *mall_entry,
 				     struct netlink_ext_ack *extack)
 {
-	u32 rate = mall_entry->sample.rate;
+	u32 rate = mall_entry->sample.params.rate;
 
 	if (!mall_entry->ingress) {
 		NL_SET_ERR_MSG(extack, "Sampling is not supported on egress");
@@ -406,8 +416,7 @@ static int mlxsw_sp2_mall_sample_add(struct mlxsw_sp *mlxsw_sp,
 		.to_dev = NULL,	/* Mirror to CPU. */
 		.session_id = MLXSW_SP_SPAN_SESSION_ID_SAMPLING,
 	};
-	struct mlxsw_sp_port_sample *sample;
-	u32 rate = mall_entry->sample.rate;
+	u32 rate = mall_entry->sample.params.rate;
 	int err;
 
 	if (!mall_entry->ingress) {
@@ -415,9 +424,8 @@ static int mlxsw_sp2_mall_sample_add(struct mlxsw_sp *mlxsw_sp,
 		return -EOPNOTSUPP;
 	}
 
-	sample = rtnl_dereference(mlxsw_sp_port->sample);
-
-	err = mlxsw_sp_span_agent_get(mlxsw_sp, &sample->span_id, &agent_parms);
+	err = mlxsw_sp_span_agent_get(mlxsw_sp, &mall_entry->sample.span_id,
+				      &agent_parms);
 	if (err) {
 		NL_SET_ERR_MSG(extack, "Failed to get SPAN agent");
 		return err;
@@ -429,7 +437,7 @@ static int mlxsw_sp2_mall_sample_add(struct mlxsw_sp *mlxsw_sp,
 		goto err_analyzed_port_get;
 	}
 
-	trigger_parms.span_id = sample->span_id;
+	trigger_parms.span_id = mall_entry->sample.span_id;
 	trigger_parms.probability_rate = rate;
 	err = mlxsw_sp_span_agent_bind(mlxsw_sp, MLXSW_SP_SPAN_TRIGGER_INGRESS,
 				       mlxsw_sp_port, &trigger_parms);
@@ -443,7 +451,7 @@ static int mlxsw_sp2_mall_sample_add(struct mlxsw_sp *mlxsw_sp,
 err_agent_bind:
 	mlxsw_sp_span_analyzed_port_put(mlxsw_sp_port, true);
 err_analyzed_port_get:
-	mlxsw_sp_span_agent_put(mlxsw_sp, sample->span_id);
+	mlxsw_sp_span_agent_put(mlxsw_sp, mall_entry->sample.span_id);
 	return err;
 }
 
@@ -452,15 +460,12 @@ static void mlxsw_sp2_mall_sample_del(struct mlxsw_sp *mlxsw_sp,
 				      struct mlxsw_sp_mall_entry *mall_entry)
 {
 	struct mlxsw_sp_span_trigger_parms trigger_parms = {};
-	struct mlxsw_sp_port_sample *sample;
-
-	sample = rtnl_dereference(mlxsw_sp_port->sample);
 
-	trigger_parms.span_id = sample->span_id;
+	trigger_parms.span_id = mall_entry->sample.span_id;
 	mlxsw_sp_span_agent_unbind(mlxsw_sp, MLXSW_SP_SPAN_TRIGGER_INGRESS,
 				   mlxsw_sp_port, &trigger_parms);
 	mlxsw_sp_span_analyzed_port_put(mlxsw_sp_port, true);
-	mlxsw_sp_span_agent_put(mlxsw_sp, sample->span_id);
+	mlxsw_sp_span_agent_put(mlxsw_sp, mall_entry->sample.span_id);
 }
 
 const struct mlxsw_sp_mall_ops mlxsw_sp2_mall_ops = {
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
index 056201029ce5..db3c561ac3ea 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
@@ -257,8 +257,9 @@ static void mlxsw_sp_rx_sample_listener(struct sk_buff *skb, u8 local_port,
 					void *trap_ctx)
 {
 	struct mlxsw_sp *mlxsw_sp = devlink_trap_ctx_priv(trap_ctx);
+	struct mlxsw_sp_sample_trigger trigger;
+	struct mlxsw_sp_sample_params *params;
 	struct mlxsw_sp_port *mlxsw_sp_port;
-	struct mlxsw_sp_port_sample *sample;
 	struct psample_metadata md = {};
 	int err;
 
@@ -270,8 +271,10 @@ static void mlxsw_sp_rx_sample_listener(struct sk_buff *skb, u8 local_port,
 	if (!mlxsw_sp_port)
 		goto out;
 
-	sample = rcu_dereference(mlxsw_sp_port->sample);
-	if (!sample)
+	trigger.type = MLXSW_SP_SAMPLE_TRIGGER_TYPE_INGRESS;
+	trigger.local_port = local_port;
+	params = mlxsw_sp_sample_trigger_params_lookup(mlxsw_sp, &trigger);
+	if (!params)
 		goto out;
 
 	/* The psample module expects skb->data to point to the start of the
@@ -279,9 +282,9 @@ static void mlxsw_sp_rx_sample_listener(struct sk_buff *skb, u8 local_port,
 	 */
 	skb_push(skb, ETH_HLEN);
 	mlxsw_sp_psample_md_init(mlxsw_sp, &md, skb,
-				 mlxsw_sp_port->dev->ifindex, sample->truncate,
-				 sample->trunc_size);
-	psample_sample_packet(sample->psample_group, skb, sample->rate, &md);
+				 mlxsw_sp_port->dev->ifindex, params->truncate,
+				 params->trunc_size);
+	psample_sample_packet(params->psample_group, skb, params->rate, &md);
 out:
 	consume_skb(skb);
 }
-- 
2.29.2

