Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20AE722072E
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 10:28:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730074AbgGOI21 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 04:28:27 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:57971 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728282AbgGOI2S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 04:28:18 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id AD4B25C010B;
        Wed, 15 Jul 2020 04:28:16 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Wed, 15 Jul 2020 04:28:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=RbSZPab4z1R/aVIeYnjibcpuhypT9F/oEl0/1PlIDh8=; b=A7Q+vfSw
        x/5lZasc8X8qgAwZTUbwkcowKFaSFlD7pstBtnh8XtgFp4ltLSrckSSDsQhq+BNX
        jHt+mZIaDrCQAaqbgalVSJx4xMAB78Kf4CLB+qIZ8lGsw6D7WuXCpSGZNbhY9GvZ
        NNWYPGPjf6mEJQRQsTCU1zxXobpwuNSI8L9y9biWVk5fYkzUmQ4KOKs6Zz6pLXmP
        ocftGB3DoiAduEJdLEAxx4aRsTT5rsbjfuZeU0LCq+2ZHC4WvY5sm9zuLTyQhqiR
        J3xiJGg+aYts08/smo7L9RliQFI2ghCj4WuqMc9CoLnmhfCoErAEpXluEokKJ2Ko
        LQGyk2GAXw8uKA==
X-ME-Sender: <xms:IL4OX3BbHWDccaGlA0CrTlOQ57-0-de5Js6KXXwLB1VKJH-92xlA6Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrfedvgddtgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucfkphepuddtledrieehrddufeelrddukedt
    necuvehluhhsthgvrhfuihiivgepieenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:IL4OX9iq3P8e56syCcbwJI6Mqh2GMHhWQkxnu1pTzSyz-F6V1R-oTg>
    <xmx:IL4OXykm8_jPtNsYYcUrY6YV2eVBlh8Kg9BUdba4REZ4n8i5pG-XXA>
    <xmx:IL4OX5yBf3Spm7fR4D_akSr5AicxzTDhiV5gUZeaHcdb_DqdLMYVvg>
    <xmx:IL4OX3ddMQBHde0VBSb5GYZNcTSTZJ5UbRT_E_YLAE5CG_Uvfbdo5w>
Received: from shredder.mtl.com (bzq-109-65-139-180.red.bezeqint.net [109.65.139.180])
        by mail.messagingengine.com (Postfix) with ESMTPA id DAA473280063;
        Wed, 15 Jul 2020 04:28:14 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        petrm@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 07/11] mlxsw: spectrum_acl: Offload FLOW_ACTION_POLICE
Date:   Wed, 15 Jul 2020 11:27:29 +0300
Message-Id: <20200715082733.429610-8-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200715082733.429610-1-idosch@idosch.org>
References: <20200715082733.429610-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Offload action police when used with a flower classifier. The number of
dropped packets is read from the policer and reported to tc.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Reviewed-by: Petr Machata <petrm@mellanox.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.h    | 11 +++++--
 .../ethernet/mellanox/mlxsw/spectrum_acl.c    | 33 ++++++++++++++++++-
 .../mlxsw/spectrum_acl_flex_actions.c         | 27 +++++++++++++++
 .../ethernet/mellanox/mlxsw/spectrum_flower.c | 30 +++++++++++++++--
 4 files changed, 96 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index defe1d82d83e..6ab1b6d725af 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -689,8 +689,10 @@ struct mlxsw_sp_acl_rule_info {
 	u8 action_created:1,
 	   ingress_bind_blocker:1,
 	   egress_bind_blocker:1,
-	   counter_valid:1;
+	   counter_valid:1,
+	   policer_index_valid:1;
 	unsigned int counter_index;
+	u16 policer_index;
 };
 
 /* spectrum_flow.c */
@@ -851,6 +853,10 @@ int mlxsw_sp_acl_rulei_act_mangle(struct mlxsw_sp *mlxsw_sp,
 				  enum flow_action_mangle_base htype,
 				  u32 offset, u32 mask, u32 val,
 				  struct netlink_ext_ack *extack);
+int mlxsw_sp_acl_rulei_act_police(struct mlxsw_sp *mlxsw_sp,
+				  struct mlxsw_sp_acl_rule_info *rulei,
+				  u32 index, u64 rate_bytes_ps,
+				  u32 burst, struct netlink_ext_ack *extack);
 int mlxsw_sp_acl_rulei_act_count(struct mlxsw_sp *mlxsw_sp,
 				 struct mlxsw_sp_acl_rule_info *rulei,
 				 struct netlink_ext_ack *extack);
@@ -883,7 +889,8 @@ struct mlxsw_sp_acl_rule_info *
 mlxsw_sp_acl_rule_rulei(struct mlxsw_sp_acl_rule *rule);
 int mlxsw_sp_acl_rule_get_stats(struct mlxsw_sp *mlxsw_sp,
 				struct mlxsw_sp_acl_rule *rule,
-				u64 *packets, u64 *bytes, u64 *last_use,
+				u64 *packets, u64 *bytes, u64 *drops,
+				u64 *last_use,
 				enum flow_action_hw_stats *used_hw_stats);
 
 struct mlxsw_sp_fid *mlxsw_sp_acl_dummy_fid(struct mlxsw_sp *mlxsw_sp);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c
index a671156a1428..8cfa03a75374 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c
@@ -66,6 +66,7 @@ struct mlxsw_sp_acl_rule {
 	u64 last_used;
 	u64 last_packets;
 	u64 last_bytes;
+	u64 last_drops;
 	unsigned long priv[];
 	/* priv has to be always the last item */
 };
@@ -648,6 +649,24 @@ int mlxsw_sp_acl_rulei_act_mangle(struct mlxsw_sp *mlxsw_sp,
 	return -EINVAL;
 }
 
+int mlxsw_sp_acl_rulei_act_police(struct mlxsw_sp *mlxsw_sp,
+				  struct mlxsw_sp_acl_rule_info *rulei,
+				  u32 index, u64 rate_bytes_ps,
+				  u32 burst, struct netlink_ext_ack *extack)
+{
+	int err;
+
+	err = mlxsw_afa_block_append_police(rulei->act_block, index,
+					    rate_bytes_ps, burst,
+					    &rulei->policer_index, extack);
+	if (err)
+		return err;
+
+	rulei->policer_index_valid = true;
+
+	return 0;
+}
+
 int mlxsw_sp_acl_rulei_act_count(struct mlxsw_sp *mlxsw_sp,
 				 struct mlxsw_sp_acl_rule_info *rulei,
 				 struct netlink_ext_ack *extack)
@@ -868,13 +887,16 @@ static void mlxsw_sp_acl_rule_activity_update_work(struct work_struct *work)
 
 int mlxsw_sp_acl_rule_get_stats(struct mlxsw_sp *mlxsw_sp,
 				struct mlxsw_sp_acl_rule *rule,
-				u64 *packets, u64 *bytes, u64 *last_use,
+				u64 *packets, u64 *bytes, u64 *drops,
+				u64 *last_use,
 				enum flow_action_hw_stats *used_hw_stats)
 
 {
+	enum mlxsw_sp_policer_type type = MLXSW_SP_POLICER_TYPE_SINGLE_RATE;
 	struct mlxsw_sp_acl_rule_info *rulei;
 	u64 current_packets = 0;
 	u64 current_bytes = 0;
+	u64 current_drops = 0;
 	int err;
 
 	rulei = mlxsw_sp_acl_rule_rulei(rule);
@@ -886,12 +908,21 @@ int mlxsw_sp_acl_rule_get_stats(struct mlxsw_sp *mlxsw_sp,
 			return err;
 		*used_hw_stats = FLOW_ACTION_HW_STATS_IMMEDIATE;
 	}
+	if (rulei->policer_index_valid) {
+		err = mlxsw_sp_policer_drops_counter_get(mlxsw_sp, type,
+							 rulei->policer_index,
+							 &current_drops);
+		if (err)
+			return err;
+	}
 	*packets = current_packets - rule->last_packets;
 	*bytes = current_bytes - rule->last_bytes;
+	*drops = current_drops - rule->last_drops;
 	*last_use = rule->last_used;
 
 	rule->last_bytes = current_bytes;
 	rule->last_packets = current_packets;
+	rule->last_drops = current_drops;
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_flex_actions.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_flex_actions.c
index 18444f675100..90372d1c28d4 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_flex_actions.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_flex_actions.c
@@ -169,6 +169,29 @@ mlxsw_sp_act_mirror_del(void *priv, u8 local_in_port, int span_id, bool ingress)
 	mlxsw_sp_span_agent_put(mlxsw_sp, span_id);
 }
 
+static int mlxsw_sp_act_policer_add(void *priv, u64 rate_bytes_ps, u32 burst,
+				    u16 *p_policer_index,
+				    struct netlink_ext_ack *extack)
+{
+	struct mlxsw_sp_policer_params params;
+	struct mlxsw_sp *mlxsw_sp = priv;
+
+	params.rate = rate_bytes_ps;
+	params.burst = burst;
+	params.bytes = true;
+	return mlxsw_sp_policer_add(mlxsw_sp,
+				    MLXSW_SP_POLICER_TYPE_SINGLE_RATE,
+				    &params, extack, p_policer_index);
+}
+
+static void mlxsw_sp_act_policer_del(void *priv, u16 policer_index)
+{
+	struct mlxsw_sp *mlxsw_sp = priv;
+
+	mlxsw_sp_policer_del(mlxsw_sp, MLXSW_SP_POLICER_TYPE_SINGLE_RATE,
+			     policer_index);
+}
+
 const struct mlxsw_afa_ops mlxsw_sp1_act_afa_ops = {
 	.kvdl_set_add		= mlxsw_sp1_act_kvdl_set_add,
 	.kvdl_set_del		= mlxsw_sp_act_kvdl_set_del,
@@ -179,6 +202,8 @@ const struct mlxsw_afa_ops mlxsw_sp1_act_afa_ops = {
 	.counter_index_put	= mlxsw_sp_act_counter_index_put,
 	.mirror_add		= mlxsw_sp_act_mirror_add,
 	.mirror_del		= mlxsw_sp_act_mirror_del,
+	.policer_add		= mlxsw_sp_act_policer_add,
+	.policer_del		= mlxsw_sp_act_policer_del,
 };
 
 const struct mlxsw_afa_ops mlxsw_sp2_act_afa_ops = {
@@ -191,6 +216,8 @@ const struct mlxsw_afa_ops mlxsw_sp2_act_afa_ops = {
 	.counter_index_put	= mlxsw_sp_act_counter_index_put,
 	.mirror_add		= mlxsw_sp_act_mirror_add,
 	.mirror_del		= mlxsw_sp_act_mirror_del,
+	.policer_add		= mlxsw_sp_act_policer_add,
+	.policer_del		= mlxsw_sp_act_policer_del,
 	.dummy_first_set	= true,
 };
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
index 61d21043d83a..41855e58564b 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
@@ -4,6 +4,7 @@
 #include <linux/kernel.h>
 #include <linux/errno.h>
 #include <linux/netdevice.h>
+#include <linux/log2.h>
 #include <net/net_namespace.h>
 #include <net/flow_dissector.h>
 #include <net/pkt_cls.h>
@@ -22,6 +23,7 @@ static int mlxsw_sp_flower_parse_actions(struct mlxsw_sp *mlxsw_sp,
 {
 	const struct flow_action_entry *act;
 	int mirror_act_count = 0;
+	int police_act_count = 0;
 	int err, i;
 
 	if (!flow_action_has_entries(flow_action))
@@ -180,6 +182,28 @@ static int mlxsw_sp_flower_parse_actions(struct mlxsw_sp *mlxsw_sp,
 				return err;
 			break;
 			}
+		case FLOW_ACTION_POLICE: {
+			u32 burst;
+
+			if (police_act_count++) {
+				NL_SET_ERR_MSG_MOD(extack, "Multiple police actions per rule are not supported");
+				return -EOPNOTSUPP;
+			}
+
+			/* The kernel might adjust the requested burst size so
+			 * that it is not exactly a power of two. Re-adjust it
+			 * here since the hardware only supports burst sizes
+			 * that are a power of two.
+			 */
+			burst = roundup_pow_of_two(act->police.burst);
+			err = mlxsw_sp_acl_rulei_act_police(mlxsw_sp, rulei,
+							    act->police.index,
+							    act->police.rate_bytes_ps,
+							    burst, extack);
+			if (err)
+				return err;
+			break;
+			}
 		default:
 			NL_SET_ERR_MSG_MOD(extack, "Unsupported action");
 			dev_err(mlxsw_sp->bus_info->dev, "Unsupported action\n");
@@ -616,6 +640,7 @@ int mlxsw_sp_flower_stats(struct mlxsw_sp *mlxsw_sp,
 	u64 packets;
 	u64 lastuse;
 	u64 bytes;
+	u64 drops;
 	int err;
 
 	ruleset = mlxsw_sp_acl_ruleset_get(mlxsw_sp, block,
@@ -629,11 +654,12 @@ int mlxsw_sp_flower_stats(struct mlxsw_sp *mlxsw_sp,
 		return -EINVAL;
 
 	err = mlxsw_sp_acl_rule_get_stats(mlxsw_sp, rule, &packets, &bytes,
-					  &lastuse, &used_hw_stats);
+					  &drops, &lastuse, &used_hw_stats);
 	if (err)
 		goto err_rule_get_stats;
 
-	flow_stats_update(&f->stats, bytes, packets, 0, lastuse, used_hw_stats);
+	flow_stats_update(&f->stats, bytes, packets, drops, lastuse,
+			  used_hw_stats);
 
 	mlxsw_sp_acl_ruleset_put(mlxsw_sp, ruleset);
 	return 0;
-- 
2.26.2

