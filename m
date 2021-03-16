Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F030B33D66D
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 16:05:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237745AbhCPPEx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 11:04:53 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:41383 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237699AbhCPPEU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 11:04:20 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 202135C00CB;
        Tue, 16 Mar 2021 11:04:19 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 16 Mar 2021 11:04:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=NEY6xQVNtpR0RSJX6EOckFqTasucY31doIcEVAl6K60=; b=jP/Sim+2
        l4SKaJ14vZAWPb4OuU26OUFwsildKBz3/8X8RTbA3UjHQJqd2o/yB/eHRh/oMaVN
        RRptG+29nQPVpLO4HDGxD8uscHrJeF3cbTLPXxh6CgaFhksIq1nIPDmmTkrppX5i
        Z9r/kx5YfAZ/bN317ZbiO74ipa6TNGS6Nx8weS8JPdce9GSwqUatXfQA/OLDHDoV
        yO/DViW5igIDlONLWqehDSUW4ZKdmqJBCDkBcRRr12WsTz/W8Z+QBLOjAyBGmhLH
        Y8CJnlK/AdSO4Yz9a0fEKqpgQ9B0EvEEbrOnzCyvL6i9+gzOonc/QhEX6UQKZ7IV
        2Y2OtIb0mZDwXg==
X-ME-Sender: <xms:8shQYA7rtSlLEPgPqaSLeF4yIBYQARjm8JDSvZL4Mcyh2mX7VHvJIg>
    <xme:8shQYB7FgVAp5tks9KlpcFnzcsCehvyYB-7iLhsJvkGOBnkP-6Nkcz8QCX_dqAXNS
    DyuJ6Yg5czCIZg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudefvddgjeefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehfedrgeeg
    necuvehluhhsthgvrhfuihiivgepvdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:88hQYPc5YpGcBkRVpuf0gU9bRiC3Zb0arByyTvuuStzAod4Auqj82Q>
    <xmx:88hQYFIEfg0NtuQxvfHzuwd_9quuUNQYlGU2H9uN4DIL_rdXwQktjA>
    <xmx:88hQYEJHZUoEz10uqOUKgXcpjWa2EU9lJ4biolaKx65wGnHrRVFtTg>
    <xmx:88hQYOjkKNQbf5Sp_yM40tZEjUnop8EKNStUyfY6oABb7lVkcVOKDA>
Received: from shredder.lan (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id C6B911080057;
        Tue, 16 Mar 2021 11:04:16 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        roopa@nvidia.com, peter.phaal@inmon.com, neil.mckee@inmon.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 08/10] mlxsw: spectrum_acl: Offload FLOW_ACTION_SAMPLE
Date:   Tue, 16 Mar 2021 17:03:01 +0200
Message-Id: <20210316150303.2868588-9-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210316150303.2868588-1-idosch@idosch.org>
References: <20210316150303.2868588-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Implement support for action sample when used with a flower classifier
by implementing the required sampler_add() / sampler_del() callbacks and
registering an Rx listener for the sampled packets.

The sampler_add() callback returns an error for Spectrum-1 as the
functionality is not supported. In Spectrum-{2,3} the callback creates a
mirroring agent towards the CPU. The agent's identifier is used by the
policy engine code to mirror towards the CPU with probability.

The Rx listener for the sampled packet is registered with the 'policy
engine' mirroring reason and passes trapped packets to the psample
module after looking up their parameters (e.g., sampling group).

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |  9 +-
 .../ethernet/mellanox/mlxsw/spectrum_acl.c    | 25 ++++++
 .../mlxsw/spectrum_acl_flex_actions.c         | 83 +++++++++++++++++++
 .../ethernet/mellanox/mlxsw/spectrum_flower.c | 18 ++++
 .../ethernet/mellanox/mlxsw/spectrum_trap.c   | 41 +++++++++
 5 files changed, 175 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index 4b4d643abceb..63cc8fa3fa62 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -239,11 +239,12 @@ struct mlxsw_sp_port_pcpu_stats {
 enum mlxsw_sp_sample_trigger_type {
 	MLXSW_SP_SAMPLE_TRIGGER_TYPE_INGRESS,
 	MLXSW_SP_SAMPLE_TRIGGER_TYPE_EGRESS,
+	MLXSW_SP_SAMPLE_TRIGGER_TYPE_POLICY_ENGINE,
 };
 
 struct mlxsw_sp_sample_trigger {
 	enum mlxsw_sp_sample_trigger_type type;
-	u8 local_port;
+	u8 local_port; /* Reserved when trigger type is not ingress / egress. */
 };
 
 struct mlxsw_sp_sample_params {
@@ -946,6 +947,12 @@ int mlxsw_sp_acl_rulei_act_count(struct mlxsw_sp *mlxsw_sp,
 int mlxsw_sp_acl_rulei_act_fid_set(struct mlxsw_sp *mlxsw_sp,
 				   struct mlxsw_sp_acl_rule_info *rulei,
 				   u16 fid, struct netlink_ext_ack *extack);
+int mlxsw_sp_acl_rulei_act_sample(struct mlxsw_sp *mlxsw_sp,
+				  struct mlxsw_sp_acl_rule_info *rulei,
+				  struct mlxsw_sp_flow_block *block,
+				  struct psample_group *psample_group, u32 rate,
+				  u32 trunc_size, bool truncate,
+				  struct netlink_ext_ack *extack);
 
 struct mlxsw_sp_acl_rule;
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c
index 8cfa03a75374..67cedfa76f78 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c
@@ -688,6 +688,31 @@ int mlxsw_sp_acl_rulei_act_fid_set(struct mlxsw_sp *mlxsw_sp,
 	return mlxsw_afa_block_append_fid_set(rulei->act_block, fid, extack);
 }
 
+int mlxsw_sp_acl_rulei_act_sample(struct mlxsw_sp *mlxsw_sp,
+				  struct mlxsw_sp_acl_rule_info *rulei,
+				  struct mlxsw_sp_flow_block *block,
+				  struct psample_group *psample_group, u32 rate,
+				  u32 trunc_size, bool truncate,
+				  struct netlink_ext_ack *extack)
+{
+	struct mlxsw_sp_flow_block_binding *binding;
+	struct mlxsw_sp_port *mlxsw_sp_port;
+
+	if (!list_is_singular(&block->binding_list)) {
+		NL_SET_ERR_MSG_MOD(extack, "Only a single sampling source is allowed");
+		return -EOPNOTSUPP;
+	}
+	binding = list_first_entry(&block->binding_list,
+				   struct mlxsw_sp_flow_block_binding, list);
+	mlxsw_sp_port = binding->mlxsw_sp_port;
+
+	return mlxsw_afa_block_append_sampler(rulei->act_block,
+					      mlxsw_sp_port->local_port,
+					      psample_group, rate, trunc_size,
+					      truncate, binding->ingress,
+					      extack);
+}
+
 struct mlxsw_sp_acl_rule *
 mlxsw_sp_acl_rule_create(struct mlxsw_sp *mlxsw_sp,
 			 struct mlxsw_sp_acl_ruleset *ruleset,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_flex_actions.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_flex_actions.c
index 90372d1c28d4..c72aa38424dc 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_flex_actions.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_flex_actions.c
@@ -192,6 +192,22 @@ static void mlxsw_sp_act_policer_del(void *priv, u16 policer_index)
 			     policer_index);
 }
 
+static int mlxsw_sp1_act_sampler_add(void *priv, u8 local_port,
+				     struct psample_group *psample_group,
+				     u32 rate, u32 trunc_size, bool truncate,
+				     bool ingress, int *p_span_id,
+				     struct netlink_ext_ack *extack)
+{
+	NL_SET_ERR_MSG_MOD(extack, "Sampling action is not supported on Spectrum-1");
+	return -EOPNOTSUPP;
+}
+
+static void mlxsw_sp1_act_sampler_del(void *priv, u8 local_port, int span_id,
+				      bool ingress)
+{
+	WARN_ON_ONCE(1);
+}
+
 const struct mlxsw_afa_ops mlxsw_sp1_act_afa_ops = {
 	.kvdl_set_add		= mlxsw_sp1_act_kvdl_set_add,
 	.kvdl_set_del		= mlxsw_sp_act_kvdl_set_del,
@@ -204,8 +220,73 @@ const struct mlxsw_afa_ops mlxsw_sp1_act_afa_ops = {
 	.mirror_del		= mlxsw_sp_act_mirror_del,
 	.policer_add		= mlxsw_sp_act_policer_add,
 	.policer_del		= mlxsw_sp_act_policer_del,
+	.sampler_add		= mlxsw_sp1_act_sampler_add,
+	.sampler_del		= mlxsw_sp1_act_sampler_del,
 };
 
+static int mlxsw_sp2_act_sampler_add(void *priv, u8 local_port,
+				     struct psample_group *psample_group,
+				     u32 rate, u32 trunc_size, bool truncate,
+				     bool ingress, int *p_span_id,
+				     struct netlink_ext_ack *extack)
+{
+	struct mlxsw_sp_span_agent_parms agent_parms = {
+		.session_id = MLXSW_SP_SPAN_SESSION_ID_SAMPLING,
+	};
+	struct mlxsw_sp_sample_trigger trigger = {
+		.type = MLXSW_SP_SAMPLE_TRIGGER_TYPE_POLICY_ENGINE,
+	};
+	struct mlxsw_sp_sample_params params;
+	struct mlxsw_sp_port *mlxsw_sp_port;
+	struct mlxsw_sp *mlxsw_sp = priv;
+	int err;
+
+	params.psample_group = psample_group;
+	params.trunc_size = trunc_size;
+	params.rate = rate;
+	params.truncate = truncate;
+	err = mlxsw_sp_sample_trigger_params_set(mlxsw_sp, &trigger, &params,
+						 extack);
+	if (err)
+		return err;
+
+	err = mlxsw_sp_span_agent_get(mlxsw_sp, p_span_id, &agent_parms);
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack, "Failed to get SPAN agent");
+		goto err_span_agent_get;
+	}
+
+	mlxsw_sp_port = mlxsw_sp->ports[local_port];
+	err = mlxsw_sp_span_analyzed_port_get(mlxsw_sp_port, ingress);
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack, "Failed to get analyzed port");
+		goto err_analyzed_port_get;
+	}
+
+	return 0;
+
+err_analyzed_port_get:
+	mlxsw_sp_span_agent_put(mlxsw_sp, *p_span_id);
+err_span_agent_get:
+	mlxsw_sp_sample_trigger_params_unset(mlxsw_sp, &trigger);
+	return err;
+}
+
+static void mlxsw_sp2_act_sampler_del(void *priv, u8 local_port, int span_id,
+				      bool ingress)
+{
+	struct mlxsw_sp_sample_trigger trigger = {
+		.type = MLXSW_SP_SAMPLE_TRIGGER_TYPE_POLICY_ENGINE,
+	};
+	struct mlxsw_sp_port *mlxsw_sp_port;
+	struct mlxsw_sp *mlxsw_sp = priv;
+
+	mlxsw_sp_port = mlxsw_sp->ports[local_port];
+	mlxsw_sp_span_analyzed_port_put(mlxsw_sp_port, ingress);
+	mlxsw_sp_span_agent_put(mlxsw_sp, span_id);
+	mlxsw_sp_sample_trigger_params_unset(mlxsw_sp, &trigger);
+}
+
 const struct mlxsw_afa_ops mlxsw_sp2_act_afa_ops = {
 	.kvdl_set_add		= mlxsw_sp2_act_kvdl_set_add,
 	.kvdl_set_del		= mlxsw_sp_act_kvdl_set_del,
@@ -218,6 +299,8 @@ const struct mlxsw_afa_ops mlxsw_sp2_act_afa_ops = {
 	.mirror_del		= mlxsw_sp_act_mirror_del,
 	.policer_add		= mlxsw_sp_act_policer_add,
 	.policer_del		= mlxsw_sp_act_policer_del,
+	.sampler_add		= mlxsw_sp2_act_sampler_add,
+	.sampler_del		= mlxsw_sp2_act_sampler_del,
 	.dummy_first_set	= true,
 };
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
index ea637fa552f5..be3791ca6069 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
@@ -24,6 +24,7 @@ static int mlxsw_sp_flower_parse_actions(struct mlxsw_sp *mlxsw_sp,
 	const struct flow_action_entry *act;
 	int mirror_act_count = 0;
 	int police_act_count = 0;
+	int sample_act_count = 0;
 	int err, i;
 
 	if (!flow_action_has_entries(flow_action))
@@ -209,6 +210,23 @@ static int mlxsw_sp_flower_parse_actions(struct mlxsw_sp *mlxsw_sp,
 				return err;
 			break;
 			}
+		case FLOW_ACTION_SAMPLE: {
+			if (sample_act_count++) {
+				NL_SET_ERR_MSG_MOD(extack, "Multiple sample actions per rule are not supported");
+				return -EOPNOTSUPP;
+			}
+
+			err = mlxsw_sp_acl_rulei_act_sample(mlxsw_sp, rulei,
+							    block,
+							    act->sample.psample_group,
+							    act->sample.rate,
+							    act->sample.trunc_size,
+							    act->sample.truncate,
+							    extack);
+			if (err)
+				return err;
+			break;
+			}
 		default:
 			NL_SET_ERR_MSG_MOD(extack, "Unsupported action");
 			dev_err(mlxsw_sp->bus_info->dev, "Unsupported action\n");
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
index 3dbf5e53e9ff..26d01adbedad 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
@@ -51,6 +51,8 @@ enum {
 enum {
 	/* Packet was mirrored from ingress. */
 	MLXSW_SP_MIRROR_REASON_INGRESS = 1,
+	/* Packet was mirrored from policy engine. */
+	MLXSW_SP_MIRROR_REASON_POLICY_ENGINE = 2,
 	/* Packet was early dropped. */
 	MLXSW_SP_MIRROR_REASON_INGRESS_WRED = 9,
 	/* Packet was mirrored from egress. */
@@ -341,6 +343,42 @@ static void mlxsw_sp_rx_sample_tx_listener(struct sk_buff *skb, u8 local_port,
 	consume_skb(skb);
 }
 
+static void mlxsw_sp_rx_sample_acl_listener(struct sk_buff *skb, u8 local_port,
+					    void *trap_ctx)
+{
+	struct mlxsw_sp *mlxsw_sp = devlink_trap_ctx_priv(trap_ctx);
+	struct mlxsw_sp_sample_trigger trigger = {
+		.type = MLXSW_SP_SAMPLE_TRIGGER_TYPE_POLICY_ENGINE,
+	};
+	struct mlxsw_sp_sample_params *params;
+	struct mlxsw_sp_port *mlxsw_sp_port;
+	struct psample_metadata md = {};
+	int err;
+
+	err = __mlxsw_sp_rx_no_mark_listener(skb, local_port, trap_ctx);
+	if (err)
+		return;
+
+	mlxsw_sp_port = mlxsw_sp->ports[local_port];
+	if (!mlxsw_sp_port)
+		goto out;
+
+	params = mlxsw_sp_sample_trigger_params_lookup(mlxsw_sp, &trigger);
+	if (!params)
+		goto out;
+
+	/* The psample module expects skb->data to point to the start of the
+	 * Ethernet header.
+	 */
+	skb_push(skb, ETH_HLEN);
+	mlxsw_sp_psample_md_init(mlxsw_sp, &md, skb,
+				 mlxsw_sp_port->dev->ifindex, params->truncate,
+				 params->trunc_size);
+	psample_sample_packet(params->psample_group, skb, params->rate, &md);
+out:
+	consume_skb(skb);
+}
+
 #define MLXSW_SP_TRAP_DROP(_id, _group_id)				      \
 	DEVLINK_TRAP_GENERIC(DROP, DROP, _id,				      \
 			     DEVLINK_TRAP_GROUP_GENERIC_ID_##_group_id,	      \
@@ -1898,6 +1936,9 @@ mlxsw_sp2_trap_items_arr[] = {
 			MLXSW_RXL_MIRROR(mlxsw_sp_rx_sample_tx_listener, 1,
 					 SP_PKT_SAMPLE,
 					 MLXSW_SP_MIRROR_REASON_EGRESS),
+			MLXSW_RXL_MIRROR(mlxsw_sp_rx_sample_acl_listener, 1,
+					 SP_PKT_SAMPLE,
+					 MLXSW_SP_MIRROR_REASON_POLICY_ENGINE),
 		},
 	},
 };
-- 
2.29.2

