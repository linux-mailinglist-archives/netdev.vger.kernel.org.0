Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 486801940B1
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 15:02:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727915AbgCZOB7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 10:01:59 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:43411 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727774AbgCZOB6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 10:01:58 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id D2B885C011B;
        Thu, 26 Mar 2020 10:01:56 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Thu, 26 Mar 2020 10:01:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=vs9nxfntrYoGFuudi/nVoIeYAfA+P1snQz7aB0+aNcI=; b=oADUP1FU
        uZCV5ybNHl3gRd/tGQrrspG5Tmp3pkyGX8/ZfEAw3hBTpFXxBfLGaWCIEa/26K6O
        lRwEzhHvUHx0meqdvEa8Y5bkT1x5HZkWd+cNWAU3iaTXHCJk1b9wADnc8B9ColSw
        73WpLx3YrbszsSTMFtUJjdz7qaVffFsoKHoLMiEWEpzsuGEmx9JcD4jHOmjt6jb4
        PVSkrar8BmkElW7wVBUr5la08paGtTU85qz8vRLCd9uY3D/bum7RseeVD6lSbFfz
        yvcZPVjzObK08nCk3BHWf9fZnP0pWOiElS4jqB5RosKU1VGFiK21wXTLbf0pbyaP
        vEFNK9CuQszqyQ==
X-ME-Sender: <xms:1LV8XgFfaEyzHEAclRI9G0c8kzzmpIamPr6_vOF_irF3TPjUe9FaPQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudehiedgheelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeejledrudekuddrudefvddrudeludenucevlhhushhtvg
    hrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhs
    tghhrdhorhhg
X-ME-Proxy: <xmx:1LV8Xi5RhR0Y5Mg5salPgF2rlQdf65kOi93vxChKYrqdBKA6oAHOZA>
    <xmx:1LV8XlnHp_C_B_fQ6lc-cssNGczJJK28i6t6sKQRmcg5erkFLdjp8Q>
    <xmx:1LV8XgwY9ycZdxYAovDlqqzGsKcLrFVJ_wTdKXhsQ7X_0qHgHcnp4A>
    <xmx:1LV8Xg4-9dm5a-73w4x0FuMJgJFsttUFwmIFr3IPP1egFzHcQzNCkQ>
Received: from splinter.mtl.com (bzq-79-181-132-191.red.bezeqint.net [79.181.132.191])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4B6C9306993E;
        Thu, 26 Mar 2020 10:01:55 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        petrm@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 4/6] mlxsw: spectrum_flower: Offload FLOW_ACTION_MANGLE
Date:   Thu, 26 Mar 2020 16:01:12 +0200
Message-Id: <20200326140114.1393972-5-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200326140114.1393972-1-idosch@idosch.org>
References: <20200326140114.1393972-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@mellanox.com>

Offload action pedit ex munge when used with a flower classifier. Only
allow setting of DSCP, ECN, or the whole DSField in IPv4 and IPv6 packets.

Signed-off-by: Petr Machata <petrm@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../mellanox/mlxsw/core_acl_flex_actions.c    | 56 ++++++++++++
 .../mellanox/mlxsw/core_acl_flex_actions.h    |  7 ++
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |  5 +
 .../ethernet/mellanox/mlxsw/spectrum_acl.c    | 91 +++++++++++++++++++
 .../ethernet/mellanox/mlxsw/spectrum_flower.c | 15 +++
 5 files changed, 174 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.c b/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.c
index 3ae0a91875ef..70a104e728f6 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.c
@@ -1337,6 +1337,62 @@ mlxsw_afa_qos_switch_prio_pack(char *payload,
 	mlxsw_afa_qos_switch_prio_set(payload, prio);
 }
 
+static int __mlxsw_afa_block_append_qos_dsfield(struct mlxsw_afa_block *block,
+						bool set_dscp, u8 dscp,
+						bool set_ecn, u8 ecn,
+						struct netlink_ext_ack *extack)
+{
+	char *act = mlxsw_afa_block_append_action(block,
+						  MLXSW_AFA_QOS_CODE,
+						  MLXSW_AFA_QOS_SIZE);
+
+	if (IS_ERR(act)) {
+		NL_SET_ERR_MSG_MOD(extack, "Cannot append QOS action");
+		return PTR_ERR(act);
+	}
+
+	if (set_ecn)
+		mlxsw_afa_qos_ecn_pack(act, MLXSW_AFA_QOS_ECN_CMD_SET, ecn);
+	if (set_dscp) {
+		mlxsw_afa_qos_dscp_pack(act, MLXSW_AFA_QOS_DSCP_CMD_SET_ALL,
+					dscp);
+		mlxsw_afa_qos_dscp_rw_set(act, MLXSW_AFA_QOS_DSCP_RW_CLEAR);
+	}
+
+	return 0;
+}
+
+int mlxsw_afa_block_append_qos_dsfield(struct mlxsw_afa_block *block,
+				       u8 dsfield,
+				       struct netlink_ext_ack *extack)
+{
+	return __mlxsw_afa_block_append_qos_dsfield(block,
+						    true, dsfield >> 2,
+						    true, dsfield & 0x03,
+						    extack);
+}
+EXPORT_SYMBOL(mlxsw_afa_block_append_qos_dsfield);
+
+int mlxsw_afa_block_append_qos_dscp(struct mlxsw_afa_block *block,
+				    u8 dscp, struct netlink_ext_ack *extack)
+{
+	return __mlxsw_afa_block_append_qos_dsfield(block,
+						    true, dscp,
+						    false, 0,
+						    extack);
+}
+EXPORT_SYMBOL(mlxsw_afa_block_append_qos_dscp);
+
+int mlxsw_afa_block_append_qos_ecn(struct mlxsw_afa_block *block,
+				   u8 ecn, struct netlink_ext_ack *extack)
+{
+	return __mlxsw_afa_block_append_qos_dsfield(block,
+						    false, 0,
+						    true, ecn,
+						    extack);
+}
+EXPORT_SYMBOL(mlxsw_afa_block_append_qos_ecn);
+
 int mlxsw_afa_block_append_qos_switch_prio(struct mlxsw_afa_block *block,
 					   u8 prio,
 					   struct netlink_ext_ack *extack)
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.h b/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.h
index 2125d7d6bcb0..8c2705e16ef7 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.h
@@ -65,6 +65,13 @@ int mlxsw_afa_block_append_vlan_modify(struct mlxsw_afa_block *block,
 int mlxsw_afa_block_append_qos_switch_prio(struct mlxsw_afa_block *block,
 					   u8 prio,
 					   struct netlink_ext_ack *extack);
+int mlxsw_afa_block_append_qos_dsfield(struct mlxsw_afa_block *block,
+				       u8 dsfield,
+				       struct netlink_ext_ack *extack);
+int mlxsw_afa_block_append_qos_dscp(struct mlxsw_afa_block *block,
+				    u8 dscp, struct netlink_ext_ack *extack);
+int mlxsw_afa_block_append_qos_ecn(struct mlxsw_afa_block *block,
+				   u8 ecn, struct netlink_ext_ack *extack);
 int mlxsw_afa_block_append_allocated_counter(struct mlxsw_afa_block *block,
 					     u32 counter_index);
 int mlxsw_afa_block_append_counter(struct mlxsw_afa_block *block,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index bbd8bec8fee4..273e373a37b6 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -749,6 +749,11 @@ int mlxsw_sp_acl_rulei_act_vlan(struct mlxsw_sp *mlxsw_sp,
 int mlxsw_sp_acl_rulei_act_priority(struct mlxsw_sp *mlxsw_sp,
 				    struct mlxsw_sp_acl_rule_info *rulei,
 				    u32 prio, struct netlink_ext_ack *extack);
+int mlxsw_sp_acl_rulei_act_mangle(struct mlxsw_sp *mlxsw_sp,
+				  struct mlxsw_sp_acl_rule_info *rulei,
+				  enum flow_action_mangle_base htype,
+				  u32 offset, u32 mask, u32 val,
+				  struct netlink_ext_ack *extack);
 int mlxsw_sp_acl_rulei_act_count(struct mlxsw_sp *mlxsw_sp,
 				 struct mlxsw_sp_acl_rule_info *rulei,
 				 struct netlink_ext_ack *extack);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c
index 01324d002680..6fc1496b9514 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c
@@ -655,6 +655,97 @@ int mlxsw_sp_acl_rulei_act_priority(struct mlxsw_sp *mlxsw_sp,
 						      extack);
 }
 
+enum mlxsw_sp_acl_mangle_field {
+	MLXSW_SP_ACL_MANGLE_FIELD_IP_DSFIELD,
+	MLXSW_SP_ACL_MANGLE_FIELD_IP_DSCP,
+	MLXSW_SP_ACL_MANGLE_FIELD_IP_ECN,
+};
+
+struct mlxsw_sp_acl_mangle_action {
+	enum flow_action_mangle_base htype;
+	/* Offset is u32-aligned. */
+	u32 offset;
+	/* Mask bits are unset for the modified field. */
+	u32 mask;
+	/* Shift required to extract the set value. */
+	u32 shift;
+	enum mlxsw_sp_acl_mangle_field field;
+};
+
+#define MLXSW_SP_ACL_MANGLE_ACTION(_htype, _offset, _mask, _shift, _field) \
+	{								\
+		.htype = _htype,					\
+		.offset = _offset,					\
+		.mask = _mask,						\
+		.shift = _shift,					\
+		.field = MLXSW_SP_ACL_MANGLE_FIELD_##_field,		\
+	}
+
+#define MLXSW_SP_ACL_MANGLE_ACTION_IP4(_offset, _mask, _shift, _field) \
+	MLXSW_SP_ACL_MANGLE_ACTION(FLOW_ACT_MANGLE_HDR_TYPE_IP4,       \
+				   _offset, _mask, _shift, _field)
+
+#define MLXSW_SP_ACL_MANGLE_ACTION_IP6(_offset, _mask, _shift, _field) \
+	MLXSW_SP_ACL_MANGLE_ACTION(FLOW_ACT_MANGLE_HDR_TYPE_IP6,       \
+				   _offset, _mask, _shift, _field)
+
+static struct mlxsw_sp_acl_mangle_action mlxsw_sp_acl_mangle_actions[] = {
+	MLXSW_SP_ACL_MANGLE_ACTION_IP4(0, 0xff00ffff, 16, IP_DSFIELD),
+	MLXSW_SP_ACL_MANGLE_ACTION_IP4(0, 0xff03ffff, 18, IP_DSCP),
+	MLXSW_SP_ACL_MANGLE_ACTION_IP4(0, 0xfffcffff, 16, IP_ECN),
+	MLXSW_SP_ACL_MANGLE_ACTION_IP6(0, 0xf00fffff, 20, IP_DSFIELD),
+	MLXSW_SP_ACL_MANGLE_ACTION_IP6(0, 0xf03fffff, 22, IP_DSCP),
+	MLXSW_SP_ACL_MANGLE_ACTION_IP6(0, 0xffcfffff, 20, IP_ECN),
+};
+
+static int
+mlxsw_sp_acl_rulei_act_mangle_field(struct mlxsw_sp *mlxsw_sp,
+				    struct mlxsw_sp_acl_rule_info *rulei,
+				    struct mlxsw_sp_acl_mangle_action *mact,
+				    u32 val, struct netlink_ext_ack *extack)
+{
+	switch (mact->field) {
+	case MLXSW_SP_ACL_MANGLE_FIELD_IP_DSFIELD:
+		return mlxsw_afa_block_append_qos_dsfield(rulei->act_block,
+							  val, extack);
+	case MLXSW_SP_ACL_MANGLE_FIELD_IP_DSCP:
+		return mlxsw_afa_block_append_qos_dscp(rulei->act_block,
+						       val, extack);
+	case MLXSW_SP_ACL_MANGLE_FIELD_IP_ECN:
+		return mlxsw_afa_block_append_qos_ecn(rulei->act_block,
+						      val, extack);
+	}
+
+	/* We shouldn't have gotten a match in the first place! */
+	WARN_ONCE(1, "Unhandled mangle field");
+	return -EINVAL;
+}
+
+int mlxsw_sp_acl_rulei_act_mangle(struct mlxsw_sp *mlxsw_sp,
+				  struct mlxsw_sp_acl_rule_info *rulei,
+				  enum flow_action_mangle_base htype,
+				  u32 offset, u32 mask, u32 val,
+				  struct netlink_ext_ack *extack)
+{
+	struct mlxsw_sp_acl_mangle_action *mact;
+	size_t i;
+
+	for (i = 0; i < ARRAY_SIZE(mlxsw_sp_acl_mangle_actions); ++i) {
+		mact = &mlxsw_sp_acl_mangle_actions[i];
+		if (mact->htype == htype &&
+		    mact->offset == offset &&
+		    mact->mask == mask) {
+			val >>= mact->shift;
+			return mlxsw_sp_acl_rulei_act_mangle_field(mlxsw_sp,
+								   rulei, mact,
+								   val, extack);
+		}
+	}
+
+	NL_SET_ERR_MSG_MOD(extack, "Unsupported mangle field");
+	return -EINVAL;
+}
+
 int mlxsw_sp_acl_rulei_act_count(struct mlxsw_sp *mlxsw_sp,
 				 struct mlxsw_sp_acl_rule_info *rulei,
 				 struct netlink_ext_ack *extack)
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
index 3d3cad3784e5..33a5e2a0a1ad 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
@@ -158,6 +158,21 @@ static int mlxsw_sp_flower_parse_actions(struct mlxsw_sp *mlxsw_sp,
 			return mlxsw_sp_acl_rulei_act_priority(mlxsw_sp, rulei,
 							       act->priority,
 							       extack);
+		case FLOW_ACTION_MANGLE: {
+			enum flow_action_mangle_base htype = act->mangle.htype;
+			__be32 be_mask = (__force __be32) act->mangle.mask;
+			__be32 be_val = (__force __be32) act->mangle.val;
+			u32 offset = act->mangle.offset;
+			u32 mask = be32_to_cpu(be_mask);
+			u32 val = be32_to_cpu(be_val);
+
+			err = mlxsw_sp_acl_rulei_act_mangle(mlxsw_sp, rulei,
+							    htype, offset,
+							    mask, val, extack);
+			if (err)
+				return err;
+			break;
+			}
 		default:
 			NL_SET_ERR_MSG_MOD(extack, "Unsupported action");
 			dev_err(mlxsw_sp->bus_info->dev, "Unsupported action\n");
-- 
2.24.1

