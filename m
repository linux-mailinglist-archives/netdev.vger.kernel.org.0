Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F49C33D66A
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 16:05:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237725AbhCPPEp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 11:04:45 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:37229 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237666AbhCPPEK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 11:04:10 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 7F03D5C012C;
        Tue, 16 Mar 2021 11:04:09 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 16 Mar 2021 11:04:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=jMzV8dXf9p/8bQ3+BGLza2jh8cJPog/iWH7wzQANO9w=; b=oV6OOdVd
        JERBSzO3UizWCxHduRTUVTDQwuLFXfkreBAQpWQafVBG+KoWeGnHp3yazJle3Ejn
        Nk+RB6CNiLRjI7JnwetyHjNBPUBvBiyKDfLlZQHdMyQuAGBRr/ZDE5raijv3HKZ+
        e2Xr/m5Qlzycjou3dJhYRIhrf3i33n3KpFFUjMR2OSlDBK0eUvJ7j3m271vscZBL
        PIOmwqSfK2PWZ76dF6Xs8/vJNFDBDa0SWCsvTewZ0yV6OWlBitF7l7DKH87M68aP
        Gwrua3VcOmIJ10NFbd3hlm3fuwIPXGlv9YkFkqMS+GI3RO/YTLTvQlyjZ3BTDdYh
        CFGAB/wDJtNNQA==
X-ME-Sender: <xms:6chQYO1yNCtRDmNbt73KskXcK4Vtb0SYI_-8pw41PhJsX03TrFGJ_w>
    <xme:6chQYBH5B0XBZXc9bc9qtBej0QBOdBFQq7UwWUcT7FW22KrFABhH_nUawULuKSFIy
    2mausKGe3WGcd0>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudefvddgjedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehfedrgeeg
    necuvehluhhsthgvrhfuihiivgepvdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:6chQYG6qNt-aS19LyhXZrElfdcOc3lqDBmLGBjb2PGK-YJ2Iisf26Q>
    <xmx:6chQYP3QsO3YdpN4ioURnw3A_nNy2hf9GQ3jJpfDDawCxXveYsuswQ>
    <xmx:6chQYBEOjFsstwIaPx0nxFxqjCBhndO5S8ogLm2oYq5OPppN4oS74g>
    <xmx:6chQYKMBlTEaCKElWiPF1usXX65h8MhaybYvS8oiojnQxp-Z6KKNAw>
Received: from shredder.lan (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 46FCA1080057;
        Tue, 16 Mar 2021 11:04:07 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        roopa@nvidia.com, peter.phaal@inmon.com, neil.mckee@inmon.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 04/10] mlxsw: spectrum: Track sampling triggers in a hash table
Date:   Tue, 16 Mar 2021 17:02:57 +0200
Message-Id: <20210316150303.2868588-5-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210316150303.2868588-1-idosch@idosch.org>
References: <20210316150303.2868588-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Currently, mlxsw supports a single sampling trigger type (i.e., received
packet). When sampling is configured on an ingress port, the sampling
parameters (e.g., pointer to the psample group) are stored as an
attribute of the port, so that they could be passed to
psample_sample_packet() when a sampled packet is trapped to the CPU.

Subsequent patches are going to add more types of sampling triggers,
making it difficult to maintain the current scheme.

Instead, store all the active sampling triggers with their associated
parameters in a hash table. That way, more trigger types can be easily
added.

The next patch will flip mlxsw to use the hash table instead of the
current scheme.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 148 ++++++++++++++++++
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |  30 ++++
 2 files changed, 178 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 6054147fd51c..7e40d45b55fe 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -23,6 +23,8 @@
 #include <linux/netlink.h>
 #include <linux/jhash.h>
 #include <linux/log2.h>
+#include <linux/refcount.h>
+#include <linux/rhashtable.h>
 #include <net/switchdev.h>
 #include <net/pkt_cls.h>
 #include <net/netevent.h>
@@ -2550,6 +2552,142 @@ static const struct mlxsw_sp_ptp_ops mlxsw_sp2_ptp_ops = {
 	.get_stats	= mlxsw_sp2_get_stats,
 };
 
+struct mlxsw_sp_sample_trigger_node {
+	struct mlxsw_sp_sample_trigger trigger;
+	struct mlxsw_sp_sample_params params;
+	struct rhash_head ht_node;
+	struct rcu_head rcu;
+	refcount_t refcount;
+};
+
+static const struct rhashtable_params mlxsw_sp_sample_trigger_ht_params = {
+	.key_offset = offsetof(struct mlxsw_sp_sample_trigger_node, trigger),
+	.head_offset = offsetof(struct mlxsw_sp_sample_trigger_node, ht_node),
+	.key_len = sizeof(struct mlxsw_sp_sample_trigger),
+	.automatic_shrinking = true,
+};
+
+static void
+mlxsw_sp_sample_trigger_key_init(struct mlxsw_sp_sample_trigger *key,
+				 const struct mlxsw_sp_sample_trigger *trigger)
+{
+	memset(key, 0, sizeof(*key));
+	key->type = trigger->type;
+	key->local_port = trigger->local_port;
+}
+
+/* RCU read lock must be held */
+struct mlxsw_sp_sample_params *
+mlxsw_sp_sample_trigger_params_lookup(struct mlxsw_sp *mlxsw_sp,
+				      const struct mlxsw_sp_sample_trigger *trigger)
+{
+	struct mlxsw_sp_sample_trigger_node *trigger_node;
+	struct mlxsw_sp_sample_trigger key;
+
+	mlxsw_sp_sample_trigger_key_init(&key, trigger);
+	trigger_node = rhashtable_lookup(&mlxsw_sp->sample_trigger_ht, &key,
+					 mlxsw_sp_sample_trigger_ht_params);
+	if (!trigger_node)
+		return NULL;
+
+	return &trigger_node->params;
+}
+
+static int
+mlxsw_sp_sample_trigger_node_init(struct mlxsw_sp *mlxsw_sp,
+				  const struct mlxsw_sp_sample_trigger *trigger,
+				  const struct mlxsw_sp_sample_params *params)
+{
+	struct mlxsw_sp_sample_trigger_node *trigger_node;
+	int err;
+
+	trigger_node = kzalloc(sizeof(*trigger_node), GFP_KERNEL);
+	if (!trigger_node)
+		return -ENOMEM;
+
+	trigger_node->trigger = *trigger;
+	trigger_node->params = *params;
+	refcount_set(&trigger_node->refcount, 1);
+
+	err = rhashtable_insert_fast(&mlxsw_sp->sample_trigger_ht,
+				     &trigger_node->ht_node,
+				     mlxsw_sp_sample_trigger_ht_params);
+	if (err)
+		goto err_rhashtable_insert;
+
+	return 0;
+
+err_rhashtable_insert:
+	kfree(trigger_node);
+	return err;
+}
+
+static void
+mlxsw_sp_sample_trigger_node_fini(struct mlxsw_sp *mlxsw_sp,
+				  struct mlxsw_sp_sample_trigger_node *trigger_node)
+{
+	rhashtable_remove_fast(&mlxsw_sp->sample_trigger_ht,
+			       &trigger_node->ht_node,
+			       mlxsw_sp_sample_trigger_ht_params);
+	kfree_rcu(trigger_node, rcu);
+}
+
+int
+mlxsw_sp_sample_trigger_params_set(struct mlxsw_sp *mlxsw_sp,
+				   const struct mlxsw_sp_sample_trigger *trigger,
+				   const struct mlxsw_sp_sample_params *params,
+				   struct netlink_ext_ack *extack)
+{
+	struct mlxsw_sp_sample_trigger_node *trigger_node;
+	struct mlxsw_sp_sample_trigger key;
+
+	ASSERT_RTNL();
+
+	mlxsw_sp_sample_trigger_key_init(&key, trigger);
+
+	trigger_node = rhashtable_lookup_fast(&mlxsw_sp->sample_trigger_ht,
+					      &key,
+					      mlxsw_sp_sample_trigger_ht_params);
+	if (!trigger_node)
+		return mlxsw_sp_sample_trigger_node_init(mlxsw_sp, &key,
+							 params);
+
+	if (trigger_node->params.psample_group != params->psample_group ||
+	    trigger_node->params.truncate != params->truncate ||
+	    trigger_node->params.rate != params->rate ||
+	    trigger_node->params.trunc_size != params->trunc_size) {
+		NL_SET_ERR_MSG_MOD(extack, "Sampling parameters do not match for an existing sampling trigger");
+		return -EINVAL;
+	}
+
+	refcount_inc(&trigger_node->refcount);
+
+	return 0;
+}
+
+void
+mlxsw_sp_sample_trigger_params_unset(struct mlxsw_sp *mlxsw_sp,
+				     const struct mlxsw_sp_sample_trigger *trigger)
+{
+	struct mlxsw_sp_sample_trigger_node *trigger_node;
+	struct mlxsw_sp_sample_trigger key;
+
+	ASSERT_RTNL();
+
+	mlxsw_sp_sample_trigger_key_init(&key, trigger);
+
+	trigger_node = rhashtable_lookup_fast(&mlxsw_sp->sample_trigger_ht,
+					      &key,
+					      mlxsw_sp_sample_trigger_ht_params);
+	if (!trigger_node)
+		return;
+
+	if (!refcount_dec_and_test(&trigger_node->refcount))
+		return;
+
+	mlxsw_sp_sample_trigger_node_fini(mlxsw_sp, trigger_node);
+}
+
 static int mlxsw_sp_netdevice_event(struct notifier_block *unused,
 				    unsigned long event, void *ptr);
 
@@ -2704,6 +2842,13 @@ static int mlxsw_sp_init(struct mlxsw_core *mlxsw_core,
 		goto err_port_module_info_init;
 	}
 
+	err = rhashtable_init(&mlxsw_sp->sample_trigger_ht,
+			      &mlxsw_sp_sample_trigger_ht_params);
+	if (err) {
+		dev_err(mlxsw_sp->bus_info->dev, "Failed to init sampling trigger hashtable\n");
+		goto err_sample_trigger_init;
+	}
+
 	err = mlxsw_sp_ports_create(mlxsw_sp);
 	if (err) {
 		dev_err(mlxsw_sp->bus_info->dev, "Failed to create ports\n");
@@ -2713,6 +2858,8 @@ static int mlxsw_sp_init(struct mlxsw_core *mlxsw_core,
 	return 0;
 
 err_ports_create:
+	rhashtable_destroy(&mlxsw_sp->sample_trigger_ht);
+err_sample_trigger_init:
 	mlxsw_sp_port_module_info_fini(mlxsw_sp);
 err_port_module_info_init:
 	mlxsw_sp_dpipe_fini(mlxsw_sp);
@@ -2847,6 +2994,7 @@ static void mlxsw_sp_fini(struct mlxsw_core *mlxsw_core)
 	struct mlxsw_sp *mlxsw_sp = mlxsw_core_driver_priv(mlxsw_core);
 
 	mlxsw_sp_ports_remove(mlxsw_sp);
+	rhashtable_destroy(&mlxsw_sp->sample_trigger_ht);
 	mlxsw_sp_port_module_info_fini(mlxsw_sp);
 	mlxsw_sp_dpipe_fini(mlxsw_sp);
 	unregister_netdevice_notifier_net(mlxsw_sp_net(mlxsw_sp),
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index 1d8afa6365d8..877d17f42e4a 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -16,6 +16,7 @@
 #include <linux/in6.h>
 #include <linux/notifier.h>
 #include <linux/net_namespace.h>
+#include <linux/spinlock.h>
 #include <net/psample.h>
 #include <net/pkt_cls.h>
 #include <net/red.h>
@@ -149,6 +150,7 @@ struct mlxsw_sp {
 	const unsigned char *mac_mask;
 	struct mlxsw_sp_upper *lags;
 	struct mlxsw_sp_port_mapping **port_mapping;
+	struct rhashtable sample_trigger_ht;
 	struct mlxsw_sp_sb *sb;
 	struct mlxsw_sp_bridge *bridge;
 	struct mlxsw_sp_router *router;
@@ -234,6 +236,23 @@ struct mlxsw_sp_port_pcpu_stats {
 	u32			tx_dropped;
 };
 
+enum mlxsw_sp_sample_trigger_type {
+	MLXSW_SP_SAMPLE_TRIGGER_TYPE_INGRESS,
+	MLXSW_SP_SAMPLE_TRIGGER_TYPE_EGRESS,
+};
+
+struct mlxsw_sp_sample_trigger {
+	enum mlxsw_sp_sample_trigger_type type;
+	u8 local_port;
+};
+
+struct mlxsw_sp_sample_params {
+	struct psample_group *psample_group;
+	u32 trunc_size;
+	u32 rate;
+	bool truncate;
+};
+
 struct mlxsw_sp_port_sample {
 	struct psample_group *psample_group;
 	u32 trunc_size;
@@ -534,6 +553,17 @@ void mlxsw_sp_hdroom_bufs_reset_sizes(struct mlxsw_sp_port *mlxsw_sp_port,
 				      struct mlxsw_sp_hdroom *hdroom);
 int mlxsw_sp_hdroom_configure(struct mlxsw_sp_port *mlxsw_sp_port,
 			      const struct mlxsw_sp_hdroom *hdroom);
+struct mlxsw_sp_sample_params *
+mlxsw_sp_sample_trigger_params_lookup(struct mlxsw_sp *mlxsw_sp,
+				      const struct mlxsw_sp_sample_trigger *trigger);
+int
+mlxsw_sp_sample_trigger_params_set(struct mlxsw_sp *mlxsw_sp,
+				   const struct mlxsw_sp_sample_trigger *trigger,
+				   const struct mlxsw_sp_sample_params *params,
+				   struct netlink_ext_ack *extack);
+void
+mlxsw_sp_sample_trigger_params_unset(struct mlxsw_sp *mlxsw_sp,
+				     const struct mlxsw_sp_sample_trigger *trigger);
 
 extern const struct mlxsw_sp_sb_vals mlxsw_sp1_sb_vals;
 extern const struct mlxsw_sp_sb_vals mlxsw_sp2_sb_vals;
-- 
2.29.2

