Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED7BF18B857
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 14:48:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727533AbgCSNsU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 09:48:20 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:43131 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727488AbgCSNsT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 09:48:19 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 7B3805C0316;
        Thu, 19 Mar 2020 09:48:18 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Thu, 19 Mar 2020 09:48:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=zWO2vcqY1SRNCREyOrjX8CXwrMTgY94iTcX6HGQYNTk=; b=1fKUIFxR
        pzcXxb6JjU5KplpQOR0lcujdjXYKueOXwYWu19ZW8GONwDCP9JL3oOR8vxYickh9
        iuuQ/Bn695H+esbZF/n77kT3mwqMk+HLXFeSqdrbsB/QMZYEVNwIT26dQwKdA+hs
        t/WkOsPnB1HHeveAkbsHBdydlxFqb4lmAsUC3QI1KYVrHKKjdJAOSqtslFXE+iUa
        S2RCPymgP7h2H64KugoKCJKrnklTqm9QM+MIN7MxeNoIILKqWGPY5XXksME5HLuR
        4BVtKxii5eXx4N/g75AC8ayPaRAqBKDaMHiPBPIetqxRqjcU7WTgQn5UQcmsBfig
        /+NomJ7zyiod/Q==
X-ME-Sender: <xms:InhzXoZpqNAKVtgYjfAJjMePiSGl2_B8_O2PqWC-g54JbcyeLuGUDg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudefledgheeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppedutdelrdeiiedrudeftddrheenucevlhhushhtvghruf
    hiiigvpeefnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghh
    rdhorhhg
X-ME-Proxy: <xmx:InhzXv3SmoUpIXq5_ZPDwLr7UJTLV9sl1KJZcjWXYuGlkopbskOf4A>
    <xmx:InhzXqNule5-PxWvJXJS_YyBRFWbMRcejYuZu_Gu_Yo-N2IzBrquCQ>
    <xmx:InhzXpKpn-yZytNNLgFPotCGYw7GDybIEkHPqtzvvGcJezBoC60TqQ>
    <xmx:InhzXq7kEnKuSoR_LHm1AqsGVxCMYBVj1fokIDEVPNH_1TYNn8Hd6Q>
Received: from splinter.mtl.com (bzq-109-66-130-5.red.bezeqint.net [109.66.130.5])
        by mail.messagingengine.com (Postfix) with ESMTPA id 40D6C30614FA;
        Thu, 19 Mar 2020 09:48:15 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, petrm@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 4/5] mlxsw: spectrum_flower: Offload FLOW_ACTION_PRIORITY
Date:   Thu, 19 Mar 2020 15:47:23 +0200
Message-Id: <20200319134724.1036942-5-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200319134724.1036942-1-idosch@idosch.org>
References: <20200319134724.1036942-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@mellanox.com>

Offload action skbedit priority when keyed to a flower classifier. The
skb->priority field in Linux is very generic, so only allow setting the
bottom 8 priorities and bounce anything else.

Signed-off-by: Petr Machata <petrm@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../mellanox/mlxsw/core_acl_flex_actions.c     | 18 ++++++++++++++++++
 .../mellanox/mlxsw/core_acl_flex_actions.h     |  3 +++
 drivers/net/ethernet/mellanox/mlxsw/spectrum.h |  3 +++
 .../net/ethernet/mellanox/mlxsw/spectrum_acl.c | 17 +++++++++++++++++
 .../ethernet/mellanox/mlxsw/spectrum_flower.c  |  4 ++++
 5 files changed, 45 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.c b/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.c
index fbb76377adf8..c713bc22da7d 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.c
@@ -1273,6 +1273,24 @@ mlxsw_afa_qos_switch_prio_pack(char *payload,
 	mlxsw_afa_qos_switch_prio_set(payload, prio);
 }
 
+int mlxsw_afa_block_append_qos_switch_prio(struct mlxsw_afa_block *block,
+					   u8 prio,
+					   struct netlink_ext_ack *extack)
+{
+	char *act = mlxsw_afa_block_append_action(block,
+						  MLXSW_AFA_QOS_CODE,
+						  MLXSW_AFA_QOS_SIZE);
+
+	if (IS_ERR(act)) {
+		NL_SET_ERR_MSG_MOD(extack, "Cannot append QOS action");
+		return PTR_ERR(act);
+	}
+	mlxsw_afa_qos_switch_prio_pack(act, MLXSW_AFA_QOS_CMD_SET,
+				       prio);
+	return 0;
+}
+EXPORT_SYMBOL(mlxsw_afa_block_append_qos_switch_prio);
+
 /* Forwarding Action
  * -----------------
  * Forwarding Action can be used to implement Policy Based Switching (PBS)
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.h b/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.h
index 5f4c1e505136..2125d7d6bcb0 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.h
@@ -62,6 +62,9 @@ int mlxsw_afa_block_append_fwd(struct mlxsw_afa_block *block,
 int mlxsw_afa_block_append_vlan_modify(struct mlxsw_afa_block *block,
 				       u16 vid, u8 pcp, u8 et,
 				       struct netlink_ext_ack *extack);
+int mlxsw_afa_block_append_qos_switch_prio(struct mlxsw_afa_block *block,
+					   u8 prio,
+					   struct netlink_ext_ack *extack);
 int mlxsw_afa_block_append_allocated_counter(struct mlxsw_afa_block *block,
 					     u32 counter_index);
 int mlxsw_afa_block_append_counter(struct mlxsw_afa_block *block,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index 57d8c95e4f9f..bbd8bec8fee4 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -746,6 +746,9 @@ int mlxsw_sp_acl_rulei_act_vlan(struct mlxsw_sp *mlxsw_sp,
 				struct mlxsw_sp_acl_rule_info *rulei,
 				u32 action, u16 vid, u16 proto, u8 prio,
 				struct netlink_ext_ack *extack);
+int mlxsw_sp_acl_rulei_act_priority(struct mlxsw_sp *mlxsw_sp,
+				    struct mlxsw_sp_acl_rule_info *rulei,
+				    u32 prio, struct netlink_ext_ack *extack);
 int mlxsw_sp_acl_rulei_act_count(struct mlxsw_sp *mlxsw_sp,
 				 struct mlxsw_sp_acl_rule_info *rulei,
 				 struct netlink_ext_ack *extack);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c
index 6f8d5005ff36..01324d002680 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c
@@ -638,6 +638,23 @@ int mlxsw_sp_acl_rulei_act_vlan(struct mlxsw_sp *mlxsw_sp,
 	}
 }
 
+int mlxsw_sp_acl_rulei_act_priority(struct mlxsw_sp *mlxsw_sp,
+				    struct mlxsw_sp_acl_rule_info *rulei,
+				    u32 prio, struct netlink_ext_ack *extack)
+{
+	/* Even though both Linux and Spectrum switches support 16 priorities,
+	 * spectrum_qdisc only processes the first eight priomap elements, and
+	 * the DCB and PFC features are tied to 8 priorities as well. Therefore
+	 * bounce attempts to prioritize packets to higher priorities.
+	 */
+	if (prio >= IEEE_8021QAZ_MAX_TCS) {
+		NL_SET_ERR_MSG_MOD(extack, "Only priorities 0..7 are supported");
+		return -EINVAL;
+	}
+	return mlxsw_afa_block_append_qos_switch_prio(rulei->act_block, prio,
+						      extack);
+}
+
 int mlxsw_sp_acl_rulei_act_count(struct mlxsw_sp *mlxsw_sp,
 				 struct mlxsw_sp_acl_rule_info *rulei,
 				 struct netlink_ext_ack *extack)
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
index 21c4b10d106c..1cb023955d8f 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
@@ -154,6 +154,10 @@ static int mlxsw_sp_flower_parse_actions(struct mlxsw_sp *mlxsw_sp,
 							   act->id, vid,
 							   proto, prio, extack);
 			}
+		case FLOW_ACTION_PRIORITY:
+			return mlxsw_sp_acl_rulei_act_priority(mlxsw_sp, rulei,
+							       act->priority,
+							       extack);
 		default:
 			NL_SET_ERR_MSG_MOD(extack, "Unsupported action");
 			dev_err(mlxsw_sp->bus_info->dev, "Unsupported action\n");
-- 
2.24.1

