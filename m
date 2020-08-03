Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FB2D23AA49
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 18:13:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728439AbgHCQMv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 12:12:51 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:50765 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728360AbgHCQMu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 12:12:50 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 4420D5C013B;
        Mon,  3 Aug 2020 12:12:49 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 03 Aug 2020 12:12:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=AWqAeFACTLWKz6qUabKDHXroy8JejuuJcP2ufK8OKPI=; b=S0FHMQ46
        od3FQoLI8qFvdm+4NrjdzFrqw2rmpFqoSP22h9hPncmRTI6ZPO4nHNaaCJIXuxvi
        DxU45IwoexWhU8OrP+SAiihNN+OXBs30vZHvSnj6k0ujMq5WmH4airrHxyh4Vn+Y
        nK3Q0a4u3+qP+ggkeATRFETR0L4cROAH7AvYHvCa7/TvVGHXyf5vlE766QAzEoKm
        +42/WgObGftoceXHrWxI8DCXODmFSu9PpQ5IrSbXGuQvSZWNQ8MiqkSCLyEaRQwe
        K5DoGtAk/CyWbmNl8SsI/sPUpRn5r1UUufB7KElvp9cGbKO8SKVxr46v3f0G8aGZ
        1fXex+yYQ7kwiQ==
X-ME-Sender: <xms:gTcoX_byW1uF8cuRnAIlF0J9dFQ6wpTV8y7CQUpStwkynnaH6BNOrA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrjeeggdelkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucfkphepjeelrddukedurdeirddvudelnecu
    vehluhhsthgvrhfuihiivgepheenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstg
    hhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:gTcoX-aSLRmDKqNY3OD-5FewEhuKw9Pmou28XarV5x9NdyWtleYicg>
    <xmx:gTcoXx-IyoEQL2hLgXR0QZSTsxAb4aIJ_knKsAf8in2_OfFev9r4sQ>
    <xmx:gTcoX1o7_9xJYvqHEXUejAsMaz29dzq4jkjA4YuRyELQmAA_oltpRQ>
    <xmx:gTcoX9WJyEEsJT3QfP9wMV7NsREh1INkTNw9FcQunlVVLJOqrIs_lg>
Received: from shredder.mtl.com (bzq-79-181-6-219.red.bezeqint.net [79.181.6.219])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2F3B1306005F;
        Mon,  3 Aug 2020 12:12:46 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        petrm@mellanox.com, amitc@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 8/9] mlxsw: spectrum_qdisc: Offload action trap for qevents
Date:   Mon,  3 Aug 2020 19:11:40 +0300
Message-Id: <20200803161141.2523857-9-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200803161141.2523857-1-idosch@idosch.org>
References: <20200803161141.2523857-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@mellanox.com>

When offloading action trap on a qevent, pass to_dev of NULL to the SPAN
module to trigger the mirror to the CPU port. Query the buffer drops
policer and use it for policing of the trapped traffic.

Signed-off-by: Petr Machata <petrm@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |  7 ++
 .../ethernet/mellanox/mlxsw/spectrum_qdisc.c  | 75 +++++++++++++++----
 .../ethernet/mellanox/mlxsw/spectrum_trap.c   | 26 +++++++
 3 files changed, 95 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index b808f6b4d670..f9ba59641b4d 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -984,6 +984,10 @@ struct mlxsw_sp_mall_mirror_entry {
 	int span_id;
 };
 
+struct mlxsw_sp_mall_trap_entry {
+	int span_id;
+};
+
 struct mlxsw_sp_mall_entry {
 	struct list_head list;
 	unsigned long cookie;
@@ -992,6 +996,7 @@ struct mlxsw_sp_mall_entry {
 	bool ingress;
 	union {
 		struct mlxsw_sp_mall_mirror_entry mirror;
+		struct mlxsw_sp_mall_trap_entry trap;
 		struct mlxsw_sp_port_sample sample;
 	};
 	struct rcu_head rcu;
@@ -1199,6 +1204,8 @@ int
 mlxsw_sp_trap_policer_counter_get(struct mlxsw_core *mlxsw_core,
 				  const struct devlink_trap_policer *policer,
 				  u64 *p_drops);
+int mlxsw_sp_trap_group_policer_hw_id_get(struct mlxsw_sp *mlxsw_sp, u16 id,
+					  bool *p_enabled, u16 *p_hw_id);
 
 static inline struct net *mlxsw_sp_net(struct mlxsw_sp *mlxsw_sp)
 {
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
index a5ce1eec5418..964fd444bb10 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
@@ -1289,19 +1289,18 @@ struct mlxsw_sp_qevent_binding {
 
 static LIST_HEAD(mlxsw_sp_qevent_block_cb_list);
 
-static int mlxsw_sp_qevent_mirror_configure(struct mlxsw_sp *mlxsw_sp,
-					    struct mlxsw_sp_mall_entry *mall_entry,
-					    struct mlxsw_sp_qevent_binding *qevent_binding)
+static int mlxsw_sp_qevent_span_configure(struct mlxsw_sp *mlxsw_sp,
+					  struct mlxsw_sp_mall_entry *mall_entry,
+					  struct mlxsw_sp_qevent_binding *qevent_binding,
+					  const struct mlxsw_sp_span_agent_parms *agent_parms,
+					  int *p_span_id)
 {
 	struct mlxsw_sp_port *mlxsw_sp_port = qevent_binding->mlxsw_sp_port;
 	struct mlxsw_sp_span_trigger_parms trigger_parms = {};
-	struct mlxsw_sp_span_agent_parms agent_parms = {
-		.to_dev = mall_entry->mirror.to_dev,
-	};
 	int span_id;
 	int err;
 
-	err = mlxsw_sp_span_agent_get(mlxsw_sp, &span_id, &agent_parms);
+	err = mlxsw_sp_span_agent_get(mlxsw_sp, &span_id, agent_parms);
 	if (err)
 		return err;
 
@@ -1320,7 +1319,7 @@ static int mlxsw_sp_qevent_mirror_configure(struct mlxsw_sp *mlxsw_sp,
 	if (err)
 		goto err_trigger_enable;
 
-	mall_entry->mirror.span_id = span_id;
+	*p_span_id = span_id;
 	return 0;
 
 err_trigger_enable:
@@ -1333,13 +1332,13 @@ static int mlxsw_sp_qevent_mirror_configure(struct mlxsw_sp *mlxsw_sp,
 	return err;
 }
 
-static void mlxsw_sp_qevent_mirror_deconfigure(struct mlxsw_sp *mlxsw_sp,
-					       struct mlxsw_sp_mall_entry *mall_entry,
-					       struct mlxsw_sp_qevent_binding *qevent_binding)
+static void mlxsw_sp_qevent_span_deconfigure(struct mlxsw_sp *mlxsw_sp,
+					     struct mlxsw_sp_qevent_binding *qevent_binding,
+					     int span_id)
 {
 	struct mlxsw_sp_port *mlxsw_sp_port = qevent_binding->mlxsw_sp_port;
 	struct mlxsw_sp_span_trigger_parms trigger_parms = {
-		.span_id = mall_entry->mirror.span_id,
+		.span_id = span_id,
 	};
 
 	mlxsw_sp_span_trigger_disable(mlxsw_sp_port, qevent_binding->span_trigger,
@@ -1347,7 +1346,51 @@ static void mlxsw_sp_qevent_mirror_deconfigure(struct mlxsw_sp *mlxsw_sp,
 	mlxsw_sp_span_agent_unbind(mlxsw_sp, qevent_binding->span_trigger, mlxsw_sp_port,
 				   &trigger_parms);
 	mlxsw_sp_span_analyzed_port_put(mlxsw_sp_port, true);
-	mlxsw_sp_span_agent_put(mlxsw_sp, mall_entry->mirror.span_id);
+	mlxsw_sp_span_agent_put(mlxsw_sp, span_id);
+}
+
+static int mlxsw_sp_qevent_mirror_configure(struct mlxsw_sp *mlxsw_sp,
+					    struct mlxsw_sp_mall_entry *mall_entry,
+					    struct mlxsw_sp_qevent_binding *qevent_binding)
+{
+	struct mlxsw_sp_span_agent_parms agent_parms = {
+		.to_dev = mall_entry->mirror.to_dev,
+	};
+
+	return mlxsw_sp_qevent_span_configure(mlxsw_sp, mall_entry, qevent_binding,
+					      &agent_parms, &mall_entry->mirror.span_id);
+}
+
+static void mlxsw_sp_qevent_mirror_deconfigure(struct mlxsw_sp *mlxsw_sp,
+					       struct mlxsw_sp_mall_entry *mall_entry,
+					       struct mlxsw_sp_qevent_binding *qevent_binding)
+{
+	mlxsw_sp_qevent_span_deconfigure(mlxsw_sp, qevent_binding, mall_entry->mirror.span_id);
+}
+
+static int mlxsw_sp_qevent_trap_configure(struct mlxsw_sp *mlxsw_sp,
+					  struct mlxsw_sp_mall_entry *mall_entry,
+					  struct mlxsw_sp_qevent_binding *qevent_binding)
+{
+	struct mlxsw_sp_span_agent_parms agent_parms = {};
+	int err;
+
+	err = mlxsw_sp_trap_group_policer_hw_id_get(mlxsw_sp,
+						    DEVLINK_TRAP_GROUP_GENERIC_ID_BUFFER_DROPS,
+						    &agent_parms.policer_enable,
+						    &agent_parms.policer_id);
+	if (err)
+		return err;
+
+	return mlxsw_sp_qevent_span_configure(mlxsw_sp, mall_entry, qevent_binding,
+					      &agent_parms, &mall_entry->trap.span_id);
+}
+
+static void mlxsw_sp_qevent_trap_deconfigure(struct mlxsw_sp *mlxsw_sp,
+					     struct mlxsw_sp_mall_entry *mall_entry,
+					     struct mlxsw_sp_qevent_binding *qevent_binding)
+{
+	mlxsw_sp_qevent_span_deconfigure(mlxsw_sp, qevent_binding, mall_entry->trap.span_id);
 }
 
 static int mlxsw_sp_qevent_entry_configure(struct mlxsw_sp *mlxsw_sp,
@@ -1357,6 +1400,8 @@ static int mlxsw_sp_qevent_entry_configure(struct mlxsw_sp *mlxsw_sp,
 	switch (mall_entry->type) {
 	case MLXSW_SP_MALL_ACTION_TYPE_MIRROR:
 		return mlxsw_sp_qevent_mirror_configure(mlxsw_sp, mall_entry, qevent_binding);
+	case MLXSW_SP_MALL_ACTION_TYPE_TRAP:
+		return mlxsw_sp_qevent_trap_configure(mlxsw_sp, mall_entry, qevent_binding);
 	default:
 		/* This should have been validated away. */
 		WARN_ON(1);
@@ -1371,6 +1416,8 @@ static void mlxsw_sp_qevent_entry_deconfigure(struct mlxsw_sp *mlxsw_sp,
 	switch (mall_entry->type) {
 	case MLXSW_SP_MALL_ACTION_TYPE_MIRROR:
 		return mlxsw_sp_qevent_mirror_deconfigure(mlxsw_sp, mall_entry, qevent_binding);
+	case MLXSW_SP_MALL_ACTION_TYPE_TRAP:
+		return mlxsw_sp_qevent_trap_deconfigure(mlxsw_sp, mall_entry, qevent_binding);
 	default:
 		WARN_ON(1);
 		return;
@@ -1490,6 +1537,8 @@ static int mlxsw_sp_qevent_mall_replace(struct mlxsw_sp *mlxsw_sp,
 	if (act->id == FLOW_ACTION_MIRRED) {
 		mall_entry->type = MLXSW_SP_MALL_ACTION_TYPE_MIRROR;
 		mall_entry->mirror.to_dev = act->dev;
+	} else if (act->id == FLOW_ACTION_TRAP) {
+		mall_entry->type = MLXSW_SP_MALL_ACTION_TYPE_TRAP;
 	} else {
 		NL_SET_ERR_MSG(f->common.extack, "Unsupported action");
 		err = -EOPNOTSUPP;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
index 16bf154076b3..2e41c5519c1b 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
@@ -1675,6 +1675,32 @@ mlxsw_sp_trap_policer_counter_get(struct mlxsw_core *mlxsw_core,
 	return 0;
 }
 
+int mlxsw_sp_trap_group_policer_hw_id_get(struct mlxsw_sp *mlxsw_sp, u16 id,
+					  bool *p_enabled, u16 *p_hw_id)
+{
+	struct mlxsw_sp_trap_policer_item *pol_item;
+	struct mlxsw_sp_trap_group_item *gr_item;
+	u32 pol_id;
+
+	gr_item = mlxsw_sp_trap_group_item_lookup(mlxsw_sp, id);
+	if (!gr_item)
+		return -ENOENT;
+
+	pol_id = gr_item->group.init_policer_id;
+	if (!pol_id) {
+		*p_enabled = false;
+		return 0;
+	}
+
+	pol_item = mlxsw_sp_trap_policer_item_lookup(mlxsw_sp, pol_id);
+	if (WARN_ON(!pol_item))
+		return -ENOENT;
+
+	*p_enabled = true;
+	*p_hw_id = pol_item->hw_id;
+	return 0;
+}
+
 static const struct mlxsw_sp_trap_group_item
 mlxsw_sp1_trap_group_items_arr[] = {
 };
-- 
2.26.2

