Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7E881E86CF
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 20:38:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728014AbgE2Shm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 14:37:42 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:51109 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727915AbgE2Shh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 14:37:37 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 75CA55C00AF;
        Fri, 29 May 2020 14:37:36 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Fri, 29 May 2020 14:37:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=yXv9ch+a7I81SiYCumvqzFMChX/N3aulUDI4x278SYI=; b=4FYUrdW8
        reLdc9W36K90GNH9vZTSt+NJIP1nRrUTRRmEvFcm7omWkr8uEH3yBIU82lCGJE7y
        QuHFvNMs8CAikQCcOIUO8X6UvKQ3ysz1JjrD+YA5vr0wCxHPwKhr+8b67DtYxLZM
        +0uBFAPwUAWgH8GNjXmQEYHUk16BWn6KtRtkqm8pefHbWbsQaXtY2n9eYip5PAfp
        ztvry6qXTmKQPOpK8xafus/nTqpQxVFTZIAT3QdYQhLgCbmCuqZQVguJyYtFr+SJ
        luaMbpHxwm+OvU/HzqvTrTZz5NoJ2llpcEw18Nhzai3Pn5K4Zxurxjt1UvTvBG0A
        J2Hak7HwI7kvRw==
X-ME-Sender: <xms:cFbRXnG1MYV16ovSDC3D-cTmAdQcRha3jVQkpCHwQSFBATFWvSEDNQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedruddvkedguddtfecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhf
    ekhefgtdfftefhledvjefggfehgfevjeekhfenucfkphepjeelrddujeeirddvgedruddt
    jeenucevlhhushhtvghrufhiiigvpeeknecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:cFbRXkXjT-m_7UkCpxw-nZIMT73Tz9WoA7Y1mtCPNrAI8S3Dx9OW3w>
    <xmx:cFbRXpIaMG5nr3aQCOYl0o7K6DtgeHl4Qdh1FSgR70d8tru_57_1zQ>
    <xmx:cFbRXlHo1YGKV4O7fantPa7qqhcg2qNIiIhjHdIYW-hg9xrTFkTgqw>
    <xmx:cFbRXsdM6ZUDUvazmakDX17UMhjkJL6hkGW40chmiECL9zM-ffS5Cw>
Received: from splinter.mtl.com (bzq-79-176-24-107.red.bezeqint.net [79.176.24.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3816030614FA;
        Fri, 29 May 2020 14:37:35 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 11/14] mlxsw: spectrum_trap: Register layer 2 control traps
Date:   Fri, 29 May 2020 21:36:46 +0300
Message-Id: <20200529183649.1602091-12-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200529183649.1602091-1-idosch@idosch.org>
References: <20200529183649.1602091-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

In a similar fashion to other traps, register layer 2 control traps with
devlink.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |  37 +----
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |   2 +
 .../ethernet/mellanox/mlxsw/spectrum_trap.c   | 151 ++++++++++++++++++
 3 files changed, 159 insertions(+), 31 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index c598ae9ed106..74925826a2cb 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -4022,6 +4022,12 @@ static void mlxsw_sp_rx_listener_ptp(struct sk_buff *skb, u8 local_port,
 	mlxsw_sp->ptp_ops->receive(mlxsw_sp, skb, local_port);
 }
 
+void mlxsw_sp_ptp_receive(struct mlxsw_sp *mlxsw_sp, struct sk_buff *skb,
+			  u8 local_port)
+{
+	mlxsw_sp->ptp_ops->receive(mlxsw_sp, skb, local_port);
+}
+
 #define MLXSW_SP_RXL_NO_MARK(_trap_id, _action, _trap_group, _is_ctrl)	\
 	MLXSW_RXL(mlxsw_sp_rx_listener_no_mark_func, _trap_id, _action,	\
 		  _is_ctrl, SP_##_trap_group, DISCARD)
@@ -4041,26 +4047,9 @@ static const struct mlxsw_listener mlxsw_sp_listener[] = {
 	/* Events */
 	MLXSW_SP_EVENTL(mlxsw_sp_pude_event_func, PUDE),
 	/* L2 traps */
-	MLXSW_SP_RXL_NO_MARK(STP, TRAP_TO_CPU, STP, true),
-	MLXSW_SP_RXL_NO_MARK(LACP, TRAP_TO_CPU, LACP, true),
-	MLXSW_RXL(mlxsw_sp_rx_listener_ptp, LLDP, TRAP_TO_CPU,
-		  false, SP_LLDP, DISCARD),
-	MLXSW_SP_RXL_MARK(IGMP_QUERY, MIRROR_TO_CPU, MC_SNOOPING, false),
-	MLXSW_SP_RXL_NO_MARK(IGMP_V1_REPORT, TRAP_TO_CPU, MC_SNOOPING, false),
-	MLXSW_SP_RXL_NO_MARK(IGMP_V2_REPORT, TRAP_TO_CPU, MC_SNOOPING, false),
-	MLXSW_SP_RXL_NO_MARK(IGMP_V2_LEAVE, TRAP_TO_CPU, MC_SNOOPING, false),
-	MLXSW_SP_RXL_NO_MARK(IGMP_V3_REPORT, TRAP_TO_CPU, MC_SNOOPING, false),
 	MLXSW_SP_RXL_MARK(ARPBC, MIRROR_TO_CPU, NEIGH_DISCOVERY, false),
 	MLXSW_SP_RXL_MARK(ARPUC, MIRROR_TO_CPU, NEIGH_DISCOVERY, false),
 	MLXSW_SP_RXL_NO_MARK(FID_MISS, TRAP_TO_CPU, FID_MISS, false),
-	MLXSW_SP_RXL_MARK(IPV6_MLDV12_LISTENER_QUERY, MIRROR_TO_CPU,
-			  MC_SNOOPING, false),
-	MLXSW_SP_RXL_NO_MARK(IPV6_MLDV1_LISTENER_REPORT, TRAP_TO_CPU,
-			     MC_SNOOPING, false),
-	MLXSW_SP_RXL_NO_MARK(IPV6_MLDV1_LISTENER_DONE, TRAP_TO_CPU, MC_SNOOPING,
-			     false),
-	MLXSW_SP_RXL_NO_MARK(IPV6_MLDV2_LISTENER_REPORT, TRAP_TO_CPU,
-			     MC_SNOOPING, false),
 	/* L3 traps */
 	MLXSW_SP_RXL_L3_MARK(LBERROR, MIRROR_TO_CPU, LBERROR, false),
 	MLXSW_SP_RXL_MARK(IP2ME, TRAP_TO_CPU, IP2ME, false),
@@ -4149,9 +4138,6 @@ static int mlxsw_sp_cpu_policers_set(struct mlxsw_core *mlxsw_core)
 	for (i = 0; i < max_cpu_policers; i++) {
 		is_bytes = false;
 		switch (i) {
-		case MLXSW_REG_HTGT_TRAP_GROUP_SP_STP:
-		case MLXSW_REG_HTGT_TRAP_GROUP_SP_LACP:
-		case MLXSW_REG_HTGT_TRAP_GROUP_SP_LLDP:
 		case MLXSW_REG_HTGT_TRAP_GROUP_SP_OSPF:
 		case MLXSW_REG_HTGT_TRAP_GROUP_SP_PIM:
 		case MLXSW_REG_HTGT_TRAP_GROUP_SP_LBERROR:
@@ -4159,10 +4145,6 @@ static int mlxsw_sp_cpu_policers_set(struct mlxsw_core *mlxsw_core)
 			rate = 128;
 			burst_size = 7;
 			break;
-		case MLXSW_REG_HTGT_TRAP_GROUP_SP_MC_SNOOPING:
-			rate = 16 * 1024;
-			burst_size = 10;
-			break;
 		case MLXSW_REG_HTGT_TRAP_GROUP_SP_BGP:
 		case MLXSW_REG_HTGT_TRAP_GROUP_SP_NEIGH_DISCOVERY:
 		case MLXSW_REG_HTGT_TRAP_GROUP_SP_ROUTER_EXP:
@@ -4225,9 +4207,6 @@ static int mlxsw_sp_trap_groups_set(struct mlxsw_core *mlxsw_core)
 	for (i = 0; i < max_trap_groups; i++) {
 		policer_id = i;
 		switch (i) {
-		case MLXSW_REG_HTGT_TRAP_GROUP_SP_STP:
-		case MLXSW_REG_HTGT_TRAP_GROUP_SP_LACP:
-		case MLXSW_REG_HTGT_TRAP_GROUP_SP_LLDP:
 		case MLXSW_REG_HTGT_TRAP_GROUP_SP_OSPF:
 		case MLXSW_REG_HTGT_TRAP_GROUP_SP_PIM:
 		case MLXSW_REG_HTGT_TRAP_GROUP_SP_PTP0:
@@ -4241,10 +4220,6 @@ static int mlxsw_sp_trap_groups_set(struct mlxsw_core *mlxsw_core)
 			priority = 4;
 			tc = 4;
 			break;
-		case MLXSW_REG_HTGT_TRAP_GROUP_SP_MC_SNOOPING:
-			priority = 3;
-			tc = 3;
-			break;
 		case MLXSW_REG_HTGT_TRAP_GROUP_SP_NEIGH_DISCOVERY:
 		case MLXSW_REG_HTGT_TRAP_GROUP_SP_IP2ME:
 		case MLXSW_REG_HTGT_TRAP_GROUP_SP_IPV6:
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index 147a5634244b..9d4dfb22cb7a 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -451,6 +451,8 @@ extern struct notifier_block mlxsw_sp_switchdev_notifier;
 /* spectrum.c */
 void mlxsw_sp_rx_listener_no_mark_func(struct sk_buff *skb,
 				       u8 local_port, void *priv);
+void mlxsw_sp_ptp_receive(struct mlxsw_sp *mlxsw_sp, struct sk_buff *skb,
+			  u8 local_port);
 int mlxsw_sp_port_speed_get(struct mlxsw_sp_port *mlxsw_sp_port, u32 *speed);
 int mlxsw_sp_port_ets_set(struct mlxsw_sp_port *mlxsw_sp_port,
 			  enum mlxsw_reg_qeec_hr hr, u8 index, u8 next_index,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
index 206751963a4f..32b77d5a917d 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
@@ -170,6 +170,23 @@ static void mlxsw_sp_rx_mark_listener(struct sk_buff *skb, u8 local_port,
 	mlxsw_sp_rx_no_mark_listener(skb, local_port, trap_ctx);
 }
 
+static void mlxsw_sp_rx_ptp_listener(struct sk_buff *skb, u8 local_port,
+				     void *trap_ctx)
+{
+	struct mlxsw_sp *mlxsw_sp = devlink_trap_ctx_priv(trap_ctx);
+	int err;
+
+	err = __mlxsw_sp_rx_no_mark_listener(skb, local_port, trap_ctx);
+	if (err)
+		return;
+
+	/* The PTP handler expects skb->data to point to the start of the
+	 * Ethernet header.
+	 */
+	skb_push(skb, ETH_HLEN);
+	mlxsw_sp_ptp_receive(mlxsw_sp, skb, local_port);
+}
+
 #define MLXSW_SP_TRAP_DROP(_id, _group_id)				      \
 	DEVLINK_TRAP_GENERIC(DROP, DROP, _id,				      \
 			     DEVLINK_TRAP_GROUP_GENERIC_ID_##_group_id,	      \
@@ -191,6 +208,11 @@ static void mlxsw_sp_rx_mark_listener(struct sk_buff *skb, u8 local_port,
 			     DEVLINK_TRAP_GROUP_GENERIC_ID_##_group_id,	      \
 			     MLXSW_SP_TRAP_METADATA)
 
+#define MLXSW_SP_TRAP_CONTROL(_id, _group_id, _action)			      \
+	DEVLINK_TRAP_GENERIC(CONTROL, _action, _id,			      \
+			     DEVLINK_TRAP_GROUP_GENERIC_ID_##_group_id,	      \
+			     MLXSW_SP_TRAP_METADATA)
+
 #define MLXSW_SP_RXL_DISCARD(_id, _group_id)				      \
 	MLXSW_RXL_DIS(mlxsw_sp_rx_drop_listener, DISCARD_##_id,		      \
 		      TRAP_EXCEPTION_TO_CPU, false, SP_##_group_id,	      \
@@ -205,6 +227,14 @@ static void mlxsw_sp_rx_mark_listener(struct sk_buff *skb, u8 local_port,
 	MLXSW_RXL(mlxsw_sp_rx_mark_listener, _id,			      \
 		   _action, false, SP_##_group_id, SET_FW_DEFAULT)
 
+#define MLXSW_SP_RXL_NO_MARK(_id, _group_id, _action, _is_ctrl)		      \
+	MLXSW_RXL(mlxsw_sp_rx_no_mark_listener, _id, _action,		      \
+		  _is_ctrl, SP_##_group_id, DISCARD)
+
+#define MLXSW_SP_RXL_MARK(_id, _group_id, _action, _is_ctrl)		      \
+	MLXSW_RXL(mlxsw_sp_rx_mark_listener, _id, _action, _is_ctrl,	      \
+		  SP_##_group_id, DISCARD)
+
 #define MLXSW_SP_TRAP_POLICER(_id, _rate, _burst)			      \
 	DEVLINK_TRAP_POLICER(_id, _rate, _burst,			      \
 			     MLXSW_REG_QPCR_HIGHEST_CIR,		      \
@@ -218,6 +248,18 @@ mlxsw_sp_trap_policer_items_arr[] = {
 	{
 		.policer = MLXSW_SP_TRAP_POLICER(1, 10 * 1024, 128),
 	},
+	{
+		.policer = MLXSW_SP_TRAP_POLICER(2, 128, 128),
+	},
+	{
+		.policer = MLXSW_SP_TRAP_POLICER(3, 128, 128),
+	},
+	{
+		.policer = MLXSW_SP_TRAP_POLICER(4, 128, 128),
+	},
+	{
+		.policer = MLXSW_SP_TRAP_POLICER(5, 16 * 1024, 128),
+	},
 };
 
 static const struct mlxsw_sp_trap_group_item mlxsw_sp_trap_group_items_arr[] = {
@@ -246,6 +288,26 @@ static const struct mlxsw_sp_trap_group_item mlxsw_sp_trap_group_items_arr[] = {
 		.hw_group_id = MLXSW_REG_HTGT_TRAP_GROUP_SP_ACL_DISCARDS,
 		.priority = 0,
 	},
+	{
+		.group = DEVLINK_TRAP_GROUP_GENERIC(STP, 2),
+		.hw_group_id = MLXSW_REG_HTGT_TRAP_GROUP_SP_STP,
+		.priority = 5,
+	},
+	{
+		.group = DEVLINK_TRAP_GROUP_GENERIC(LACP, 3),
+		.hw_group_id = MLXSW_REG_HTGT_TRAP_GROUP_SP_LACP,
+		.priority = 5,
+	},
+	{
+		.group = DEVLINK_TRAP_GROUP_GENERIC(LLDP, 4),
+		.hw_group_id = MLXSW_REG_HTGT_TRAP_GROUP_SP_LLDP,
+		.priority = 5,
+	},
+	{
+		.group = DEVLINK_TRAP_GROUP_GENERIC(MC_SNOOPING, 5),
+		.hw_group_id = MLXSW_REG_HTGT_TRAP_GROUP_SP_MC_SNOOPING,
+		.priority = 3,
+	},
 };
 
 static const struct mlxsw_sp_trap_item mlxsw_sp_trap_items_arr[] = {
@@ -466,6 +528,95 @@ static const struct mlxsw_sp_trap_item mlxsw_sp_trap_items_arr[] = {
 						 DUMMY),
 		},
 	},
+	{
+		.trap = MLXSW_SP_TRAP_CONTROL(STP, STP, TRAP),
+		.listeners_arr = {
+			MLXSW_SP_RXL_NO_MARK(STP, STP, TRAP_TO_CPU, true),
+		},
+	},
+	{
+		.trap = MLXSW_SP_TRAP_CONTROL(LACP, LACP, TRAP),
+		.listeners_arr = {
+			MLXSW_SP_RXL_NO_MARK(LACP, LACP, TRAP_TO_CPU, true),
+		},
+	},
+	{
+		.trap = MLXSW_SP_TRAP_CONTROL(LLDP, LLDP, TRAP),
+		.listeners_arr = {
+			MLXSW_RXL(mlxsw_sp_rx_ptp_listener, LLDP, TRAP_TO_CPU,
+				  false, SP_LLDP, DISCARD),
+		},
+	},
+	{
+		.trap = MLXSW_SP_TRAP_CONTROL(IGMP_QUERY, MC_SNOOPING, MIRROR),
+		.listeners_arr = {
+			MLXSW_SP_RXL_MARK(IGMP_QUERY, MC_SNOOPING,
+					  MIRROR_TO_CPU, false),
+		},
+	},
+	{
+		.trap = MLXSW_SP_TRAP_CONTROL(IGMP_V1_REPORT, MC_SNOOPING,
+					      TRAP),
+		.listeners_arr = {
+			MLXSW_SP_RXL_NO_MARK(IGMP_V1_REPORT, MC_SNOOPING,
+					     TRAP_TO_CPU, false),
+		},
+	},
+	{
+		.trap = MLXSW_SP_TRAP_CONTROL(IGMP_V2_REPORT, MC_SNOOPING,
+					      TRAP),
+		.listeners_arr = {
+			MLXSW_SP_RXL_NO_MARK(IGMP_V2_REPORT, MC_SNOOPING,
+					     TRAP_TO_CPU, false),
+		},
+	},
+	{
+		.trap = MLXSW_SP_TRAP_CONTROL(IGMP_V3_REPORT, MC_SNOOPING,
+					      TRAP),
+		.listeners_arr = {
+			MLXSW_SP_RXL_NO_MARK(IGMP_V3_REPORT, MC_SNOOPING,
+					     TRAP_TO_CPU, false),
+		},
+	},
+	{
+		.trap = MLXSW_SP_TRAP_CONTROL(IGMP_V2_LEAVE, MC_SNOOPING,
+					      TRAP),
+		.listeners_arr = {
+			MLXSW_SP_RXL_NO_MARK(IGMP_V2_LEAVE, MC_SNOOPING,
+					     TRAP_TO_CPU, false),
+		},
+	},
+	{
+		.trap = MLXSW_SP_TRAP_CONTROL(MLD_QUERY, MC_SNOOPING, MIRROR),
+		.listeners_arr = {
+			MLXSW_SP_RXL_MARK(IPV6_MLDV12_LISTENER_QUERY,
+					  MC_SNOOPING, MIRROR_TO_CPU, false),
+		},
+	},
+	{
+		.trap = MLXSW_SP_TRAP_CONTROL(MLD_V1_REPORT, MC_SNOOPING,
+					      TRAP),
+		.listeners_arr = {
+			MLXSW_SP_RXL_NO_MARK(IPV6_MLDV1_LISTENER_REPORT,
+					     MC_SNOOPING, TRAP_TO_CPU, false),
+		},
+	},
+	{
+		.trap = MLXSW_SP_TRAP_CONTROL(MLD_V2_REPORT, MC_SNOOPING,
+					      TRAP),
+		.listeners_arr = {
+			MLXSW_SP_RXL_NO_MARK(IPV6_MLDV2_LISTENER_REPORT,
+					     MC_SNOOPING, TRAP_TO_CPU, false),
+		},
+	},
+	{
+		.trap = MLXSW_SP_TRAP_CONTROL(MLD_V1_DONE, MC_SNOOPING,
+					      TRAP),
+		.listeners_arr = {
+			MLXSW_SP_RXL_NO_MARK(IPV6_MLDV1_LISTENER_DONE,
+					     MC_SNOOPING, TRAP_TO_CPU, false),
+		},
+	},
 };
 
 static struct mlxsw_sp_trap_policer_item *
-- 
2.26.2

