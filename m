Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41C3E1E86D0
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 20:38:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728025AbgE2Shn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 14:37:43 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:43233 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727911AbgE2Shj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 14:37:39 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id CDB025C008B;
        Fri, 29 May 2020 14:37:37 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Fri, 29 May 2020 14:37:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=Xwq1qeR2bn7nzy9tR5dyCtoD+F4ZSy6U82mCekYhang=; b=bMliRZXF
        i7ZkJPrKOeoAmLP72lK3hqcMTYlZyPemD3Lxy7nu0B+1KOhzjx7wCquFTPX+pcKK
        lJeXQO4UcfiIA/IUc82Lu8/3YUL6oi0qdjxGhUpXGFsf8x8gn+iHuHvD+maf4gFZ
        MRnqLd58G4dKxEi53vJ8o/bw75t0RW+fskkjNsVysemSuIH7RMh5GKOLkCwCohsf
        jNJzkG3U8BNX/ub9EtRTzSncl7yTBuL9yjA3KIrPDRa+axCcnqufqByUp/fl/ErP
        AiO8ENxNeoMV8q1cQTDYD1eQ6a6E1NVGlVR0jqhFSe7x+Ys+kHipk14F35i7L6mb
        r6GuyIoom+vsCg==
X-ME-Sender: <xms:cVbRXo6KGyUFrrYZyf4xx1w9bQAjuUiDz9zqwL_P9PEjHDl-GbDg1w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedruddvkedguddtfecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhf
    ekhefgtdfftefhledvjefggfehgfevjeekhfenucfkphepjeelrddujeeirddvgedruddt
    jeenucevlhhushhtvghrufhiiigvpeeknecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:cVbRXp6uE7JoDlihxgbbKimne8L04pxxIC1FwsfOs08-rTH4zCtb-w>
    <xmx:cVbRXnelS3al3ffK4f78FLQLs8NyMRoSnAFv3KDQocDLEqyeylHfgA>
    <xmx:cVbRXtLJdVWYYVGjIb9mmf4od7ykky4-2wL8JMFNg3eWsToHyO4eyw>
    <xmx:cVbRXmh9OeEfFNMd-Rh_KUifnLsnX7NSY0avpxobamMYSOvFeIv0XA>
Received: from splinter.mtl.com (bzq-79-176-24-107.red.bezeqint.net [79.176.24.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8ADFC3060F09;
        Fri, 29 May 2020 14:37:36 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 12/14] mlxsw: spectrum_trap: Register layer 3 control traps
Date:   Fri, 29 May 2020 21:36:47 +0300
Message-Id: <20200529183649.1602091-13-idosch@idosch.org>
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

In a similar fashion to layer 2 control traps, register layer 3 control
traps with devlink.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h     |   1 -
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |  93 -----
 .../ethernet/mellanox/mlxsw/spectrum_trap.c   | 318 ++++++++++++++++++
 3 files changed, 318 insertions(+), 94 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index 030d6f9766d2..fcb88d4271bf 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -5536,7 +5536,6 @@ enum mlxsw_reg_htgt_trap_group {
 	MLXSW_REG_HTGT_TRAP_GROUP_SP_MULTICAST,
 	MLXSW_REG_HTGT_TRAP_GROUP_SP_NEIGH_DISCOVERY,
 	MLXSW_REG_HTGT_TRAP_GROUP_SP_ROUTER_EXP,
-	MLXSW_REG_HTGT_TRAP_GROUP_SP_REMOTE_ROUTE,
 	MLXSW_REG_HTGT_TRAP_GROUP_SP_IP2ME,
 	MLXSW_REG_HTGT_TRAP_GROUP_SP_DHCP,
 	MLXSW_REG_HTGT_TRAP_GROUP_SP_EVENT,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 74925826a2cb..8daeae1384da 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -4014,14 +4014,6 @@ static void mlxsw_sp_rx_listener_sample_func(struct sk_buff *skb, u8 local_port,
 	consume_skb(skb);
 }
 
-static void mlxsw_sp_rx_listener_ptp(struct sk_buff *skb, u8 local_port,
-				     void *priv)
-{
-	struct mlxsw_sp *mlxsw_sp = priv;
-
-	mlxsw_sp->ptp_ops->receive(mlxsw_sp, skb, local_port);
-}
-
 void mlxsw_sp_ptp_receive(struct mlxsw_sp *mlxsw_sp, struct sk_buff *skb,
 			  u8 local_port)
 {
@@ -4047,43 +4039,13 @@ static const struct mlxsw_listener mlxsw_sp_listener[] = {
 	/* Events */
 	MLXSW_SP_EVENTL(mlxsw_sp_pude_event_func, PUDE),
 	/* L2 traps */
-	MLXSW_SP_RXL_MARK(ARPBC, MIRROR_TO_CPU, NEIGH_DISCOVERY, false),
-	MLXSW_SP_RXL_MARK(ARPUC, MIRROR_TO_CPU, NEIGH_DISCOVERY, false),
 	MLXSW_SP_RXL_NO_MARK(FID_MISS, TRAP_TO_CPU, FID_MISS, false),
 	/* L3 traps */
-	MLXSW_SP_RXL_L3_MARK(LBERROR, MIRROR_TO_CPU, LBERROR, false),
-	MLXSW_SP_RXL_MARK(IP2ME, TRAP_TO_CPU, IP2ME, false),
 	MLXSW_SP_RXL_MARK(IPV6_UNSPECIFIED_ADDRESS, TRAP_TO_CPU, ROUTER_EXP,
 			  false),
-	MLXSW_SP_RXL_MARK(IPV6_LINK_LOCAL_DEST, TRAP_TO_CPU, IP2ME, false),
 	MLXSW_SP_RXL_MARK(IPV6_LINK_LOCAL_SRC, TRAP_TO_CPU, ROUTER_EXP, false),
-	MLXSW_SP_RXL_MARK(IPV6_ALL_NODES_LINK, TRAP_TO_CPU, IPV6, false),
-	MLXSW_SP_RXL_MARK(IPV6_ALL_ROUTERS_LINK, TRAP_TO_CPU, IPV6,
-			  false),
-	MLXSW_SP_RXL_MARK(IPV4_OSPF, TRAP_TO_CPU, OSPF, false),
-	MLXSW_SP_RXL_MARK(IPV6_OSPF, TRAP_TO_CPU, OSPF, false),
-	MLXSW_SP_RXL_MARK(IPV4_DHCP, TRAP_TO_CPU, DHCP, false),
-	MLXSW_SP_RXL_MARK(IPV6_DHCP, TRAP_TO_CPU, DHCP, false),
-	MLXSW_SP_RXL_MARK(RTR_INGRESS0, TRAP_TO_CPU, REMOTE_ROUTE, false),
-	MLXSW_SP_RXL_MARK(IPV4_BGP, TRAP_TO_CPU, BGP, false),
-	MLXSW_SP_RXL_MARK(IPV6_BGP, TRAP_TO_CPU, BGP, false),
-	MLXSW_SP_RXL_MARK(L3_IPV6_ROUTER_SOLICITATION, TRAP_TO_CPU, IPV6,
-			  false),
-	MLXSW_SP_RXL_MARK(L3_IPV6_ROUTER_ADVERTISEMENT, TRAP_TO_CPU, IPV6,
-			  false),
-	MLXSW_SP_RXL_MARK(L3_IPV6_NEIGHBOR_SOLICITATION, TRAP_TO_CPU,
-			  NEIGH_DISCOVERY, false),
-	MLXSW_SP_RXL_MARK(L3_IPV6_NEIGHBOR_ADVERTISEMENT, TRAP_TO_CPU,
-			  NEIGH_DISCOVERY, false),
-	MLXSW_SP_RXL_MARK(L3_IPV6_REDIRECTION, TRAP_TO_CPU, IPV6, false),
 	MLXSW_SP_RXL_MARK(IPV6_MC_LINK_LOCAL_DEST, TRAP_TO_CPU, ROUTER_EXP,
 			  false),
-	MLXSW_SP_RXL_MARK(ROUTER_ALERT_IPV4, TRAP_TO_CPU, IP2ME, false),
-	MLXSW_SP_RXL_MARK(ROUTER_ALERT_IPV6, TRAP_TO_CPU, IP2ME, false),
-	MLXSW_SP_RXL_MARK(IPV4_VRRP, TRAP_TO_CPU, VRRP, false),
-	MLXSW_SP_RXL_MARK(IPV6_VRRP, TRAP_TO_CPU, VRRP, false),
-	MLXSW_SP_RXL_MARK(IPV4_BFD, TRAP_TO_CPU, BFD, false),
-	MLXSW_SP_RXL_MARK(IPV6_BFD, TRAP_TO_CPU, BFD, false),
 	MLXSW_SP_RXL_NO_MARK(DISCARD_ING_ROUTER_SIP_CLASS_E, FORWARD,
 			     ROUTER_EXP, false),
 	MLXSW_SP_RXL_NO_MARK(DISCARD_ING_ROUTER_MC_DMAC, FORWARD,
@@ -4098,18 +4060,10 @@ static const struct mlxsw_listener mlxsw_sp_listener[] = {
 	/* ACL trap */
 	MLXSW_SP_RXL_NO_MARK(ACL0, TRAP_TO_CPU, FLOW_LOGGING, false),
 	/* Multicast Router Traps */
-	MLXSW_SP_RXL_MARK(IPV4_PIM, TRAP_TO_CPU, PIM, false),
-	MLXSW_SP_RXL_MARK(IPV6_PIM, TRAP_TO_CPU, PIM, false),
 	MLXSW_SP_RXL_MARK(ACL1, TRAP_TO_CPU, MULTICAST, false),
 	MLXSW_SP_RXL_L3_MARK(ACL2, TRAP_TO_CPU, MULTICAST, false),
 	/* NVE traps */
 	MLXSW_SP_RXL_MARK(NVE_ENCAP_ARP, TRAP_TO_CPU, NEIGH_DISCOVERY, false),
-	MLXSW_SP_RXL_NO_MARK(NVE_DECAP_ARP, TRAP_TO_CPU, NEIGH_DISCOVERY,
-			     false),
-	/* PTP traps */
-	MLXSW_RXL(mlxsw_sp_rx_listener_ptp, PTP0, TRAP_TO_CPU,
-		  false, SP_PTP0, DISCARD),
-	MLXSW_SP_RXL_NO_MARK(PTP1, TRAP_TO_CPU, PTP1, false),
 };
 
 static const struct mlxsw_listener mlxsw_sp1_listener[] = {
@@ -4138,41 +4092,13 @@ static int mlxsw_sp_cpu_policers_set(struct mlxsw_core *mlxsw_core)
 	for (i = 0; i < max_cpu_policers; i++) {
 		is_bytes = false;
 		switch (i) {
-		case MLXSW_REG_HTGT_TRAP_GROUP_SP_OSPF:
-		case MLXSW_REG_HTGT_TRAP_GROUP_SP_PIM:
-		case MLXSW_REG_HTGT_TRAP_GROUP_SP_LBERROR:
-		case MLXSW_REG_HTGT_TRAP_GROUP_SP_DHCP:
-			rate = 128;
-			burst_size = 7;
-			break;
-		case MLXSW_REG_HTGT_TRAP_GROUP_SP_BGP:
-		case MLXSW_REG_HTGT_TRAP_GROUP_SP_NEIGH_DISCOVERY:
 		case MLXSW_REG_HTGT_TRAP_GROUP_SP_ROUTER_EXP:
-		case MLXSW_REG_HTGT_TRAP_GROUP_SP_REMOTE_ROUTE:
-		case MLXSW_REG_HTGT_TRAP_GROUP_SP_IPV6:
 		case MLXSW_REG_HTGT_TRAP_GROUP_SP_MULTICAST:
 		case MLXSW_REG_HTGT_TRAP_GROUP_SP_FLOW_LOGGING:
-		case MLXSW_REG_HTGT_TRAP_GROUP_SP_IP2ME:
 		case MLXSW_REG_HTGT_TRAP_GROUP_SP_FID_MISS:
 			rate = 1024;
 			burst_size = 7;
 			break;
-		case MLXSW_REG_HTGT_TRAP_GROUP_SP_PTP0:
-			rate = 24 * 1024;
-			burst_size = 12;
-			break;
-		case MLXSW_REG_HTGT_TRAP_GROUP_SP_PTP1:
-			rate = 19 * 1024;
-			burst_size = 12;
-			break;
-		case MLXSW_REG_HTGT_TRAP_GROUP_SP_VRRP:
-			rate = 360;
-			burst_size = 7;
-			break;
-		case MLXSW_REG_HTGT_TRAP_GROUP_SP_BFD:
-			rate = 20 * 1024;
-			burst_size = 10;
-			break;
 		default:
 			continue;
 		}
@@ -4207,36 +4133,17 @@ static int mlxsw_sp_trap_groups_set(struct mlxsw_core *mlxsw_core)
 	for (i = 0; i < max_trap_groups; i++) {
 		policer_id = i;
 		switch (i) {
-		case MLXSW_REG_HTGT_TRAP_GROUP_SP_OSPF:
-		case MLXSW_REG_HTGT_TRAP_GROUP_SP_PIM:
-		case MLXSW_REG_HTGT_TRAP_GROUP_SP_PTP0:
-		case MLXSW_REG_HTGT_TRAP_GROUP_SP_VRRP:
-		case MLXSW_REG_HTGT_TRAP_GROUP_SP_BFD:
-			priority = 5;
-			tc = 5;
-			break;
 		case MLXSW_REG_HTGT_TRAP_GROUP_SP_FLOW_LOGGING:
-		case MLXSW_REG_HTGT_TRAP_GROUP_SP_BGP:
 			priority = 4;
 			tc = 4;
 			break;
-		case MLXSW_REG_HTGT_TRAP_GROUP_SP_NEIGH_DISCOVERY:
-		case MLXSW_REG_HTGT_TRAP_GROUP_SP_IP2ME:
-		case MLXSW_REG_HTGT_TRAP_GROUP_SP_IPV6:
-		case MLXSW_REG_HTGT_TRAP_GROUP_SP_PTP1:
-		case MLXSW_REG_HTGT_TRAP_GROUP_SP_DHCP:
-			priority = 2;
-			tc = 2;
-			break;
 		case MLXSW_REG_HTGT_TRAP_GROUP_SP_ROUTER_EXP:
-		case MLXSW_REG_HTGT_TRAP_GROUP_SP_REMOTE_ROUTE:
 		case MLXSW_REG_HTGT_TRAP_GROUP_SP_MULTICAST:
 		case MLXSW_REG_HTGT_TRAP_GROUP_SP_FID_MISS:
 			priority = 1;
 			tc = 1;
 			break;
 		case MLXSW_REG_HTGT_TRAP_GROUP_SP_PKT_SAMPLE:
-		case MLXSW_REG_HTGT_TRAP_GROUP_SP_LBERROR:
 			priority = 0;
 			tc = 0;
 			break;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
index 32b77d5a917d..148a35b7f4f8 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
@@ -170,6 +170,14 @@ static void mlxsw_sp_rx_mark_listener(struct sk_buff *skb, u8 local_port,
 	mlxsw_sp_rx_no_mark_listener(skb, local_port, trap_ctx);
 }
 
+static void mlxsw_sp_rx_l3_mark_listener(struct sk_buff *skb, u8 local_port,
+					 void *trap_ctx)
+{
+	skb->offload_l3_fwd_mark = 1;
+	skb->offload_fwd_mark = 1;
+	mlxsw_sp_rx_no_mark_listener(skb, local_port, trap_ctx);
+}
+
 static void mlxsw_sp_rx_ptp_listener(struct sk_buff *skb, u8 local_port,
 				     void *trap_ctx)
 {
@@ -235,6 +243,10 @@ static void mlxsw_sp_rx_ptp_listener(struct sk_buff *skb, u8 local_port,
 	MLXSW_RXL(mlxsw_sp_rx_mark_listener, _id, _action, _is_ctrl,	      \
 		  SP_##_group_id, DISCARD)
 
+#define MLXSW_SP_RXL_L3_MARK(_id, _group_id, _action, _is_ctrl)		      \
+	MLXSW_RXL(mlxsw_sp_rx_l3_mark_listener, _id, _action, _is_ctrl,	      \
+		  SP_##_group_id, DISCARD)
+
 #define MLXSW_SP_TRAP_POLICER(_id, _rate, _burst)			      \
 	DEVLINK_TRAP_POLICER(_id, _rate, _burst,			      \
 			     MLXSW_REG_QPCR_HIGHEST_CIR,		      \
@@ -260,6 +272,42 @@ mlxsw_sp_trap_policer_items_arr[] = {
 	{
 		.policer = MLXSW_SP_TRAP_POLICER(5, 16 * 1024, 128),
 	},
+	{
+		.policer = MLXSW_SP_TRAP_POLICER(6, 128, 128),
+	},
+	{
+		.policer = MLXSW_SP_TRAP_POLICER(7, 1024, 128),
+	},
+	{
+		.policer = MLXSW_SP_TRAP_POLICER(8, 20 * 1024, 1024),
+	},
+	{
+		.policer = MLXSW_SP_TRAP_POLICER(9, 128, 128),
+	},
+	{
+		.policer = MLXSW_SP_TRAP_POLICER(10, 1024, 128),
+	},
+	{
+		.policer = MLXSW_SP_TRAP_POLICER(11, 360, 128),
+	},
+	{
+		.policer = MLXSW_SP_TRAP_POLICER(12, 128, 128),
+	},
+	{
+		.policer = MLXSW_SP_TRAP_POLICER(13, 128, 128),
+	},
+	{
+		.policer = MLXSW_SP_TRAP_POLICER(14, 1024, 128),
+	},
+	{
+		.policer = MLXSW_SP_TRAP_POLICER(15, 1024, 128),
+	},
+	{
+		.policer = MLXSW_SP_TRAP_POLICER(16, 24 * 1024, 4096),
+	},
+	{
+		.policer = MLXSW_SP_TRAP_POLICER(17, 19 * 1024, 4096),
+	},
 };
 
 static const struct mlxsw_sp_trap_group_item mlxsw_sp_trap_group_items_arr[] = {
@@ -308,6 +356,66 @@ static const struct mlxsw_sp_trap_group_item mlxsw_sp_trap_group_items_arr[] = {
 		.hw_group_id = MLXSW_REG_HTGT_TRAP_GROUP_SP_MC_SNOOPING,
 		.priority = 3,
 	},
+	{
+		.group = DEVLINK_TRAP_GROUP_GENERIC(DHCP, 6),
+		.hw_group_id = MLXSW_REG_HTGT_TRAP_GROUP_SP_DHCP,
+		.priority = 2,
+	},
+	{
+		.group = DEVLINK_TRAP_GROUP_GENERIC(NEIGH_DISCOVERY, 7),
+		.hw_group_id = MLXSW_REG_HTGT_TRAP_GROUP_SP_NEIGH_DISCOVERY,
+		.priority = 2,
+	},
+	{
+		.group = DEVLINK_TRAP_GROUP_GENERIC(BFD, 8),
+		.hw_group_id = MLXSW_REG_HTGT_TRAP_GROUP_SP_BFD,
+		.priority = 5,
+	},
+	{
+		.group = DEVLINK_TRAP_GROUP_GENERIC(OSPF, 9),
+		.hw_group_id = MLXSW_REG_HTGT_TRAP_GROUP_SP_OSPF,
+		.priority = 5,
+	},
+	{
+		.group = DEVLINK_TRAP_GROUP_GENERIC(BGP, 10),
+		.hw_group_id = MLXSW_REG_HTGT_TRAP_GROUP_SP_BGP,
+		.priority = 4,
+	},
+	{
+		.group = DEVLINK_TRAP_GROUP_GENERIC(VRRP, 11),
+		.hw_group_id = MLXSW_REG_HTGT_TRAP_GROUP_SP_VRRP,
+		.priority = 5,
+	},
+	{
+		.group = DEVLINK_TRAP_GROUP_GENERIC(PIM, 12),
+		.hw_group_id = MLXSW_REG_HTGT_TRAP_GROUP_SP_PIM,
+		.priority = 5,
+	},
+	{
+		.group = DEVLINK_TRAP_GROUP_GENERIC(UC_LB, 13),
+		.hw_group_id = MLXSW_REG_HTGT_TRAP_GROUP_SP_LBERROR,
+		.priority = 0,
+	},
+	{
+		.group = DEVLINK_TRAP_GROUP_GENERIC(LOCAL_DELIVERY, 14),
+		.hw_group_id = MLXSW_REG_HTGT_TRAP_GROUP_SP_IP2ME,
+		.priority = 2,
+	},
+	{
+		.group = DEVLINK_TRAP_GROUP_GENERIC(IPV6, 15),
+		.hw_group_id = MLXSW_REG_HTGT_TRAP_GROUP_SP_IPV6,
+		.priority = 2,
+	},
+	{
+		.group = DEVLINK_TRAP_GROUP_GENERIC(PTP_EVENT, 16),
+		.hw_group_id = MLXSW_REG_HTGT_TRAP_GROUP_SP_PTP0,
+		.priority = 5,
+	},
+	{
+		.group = DEVLINK_TRAP_GROUP_GENERIC(PTP_GENERAL, 17),
+		.hw_group_id = MLXSW_REG_HTGT_TRAP_GROUP_SP_PTP1,
+		.priority = 2,
+	},
 };
 
 static const struct mlxsw_sp_trap_item mlxsw_sp_trap_items_arr[] = {
@@ -617,6 +725,216 @@ static const struct mlxsw_sp_trap_item mlxsw_sp_trap_items_arr[] = {
 					     MC_SNOOPING, TRAP_TO_CPU, false),
 		},
 	},
+	{
+		.trap = MLXSW_SP_TRAP_CONTROL(IPV4_DHCP, DHCP, TRAP),
+		.listeners_arr = {
+			MLXSW_SP_RXL_MARK(IPV4_DHCP, DHCP, TRAP_TO_CPU, false),
+		},
+	},
+	{
+		.trap = MLXSW_SP_TRAP_CONTROL(IPV6_DHCP, DHCP, TRAP),
+		.listeners_arr = {
+			MLXSW_SP_RXL_MARK(IPV6_DHCP, DHCP, TRAP_TO_CPU, false),
+		},
+	},
+	{
+		.trap = MLXSW_SP_TRAP_CONTROL(ARP_REQUEST, NEIGH_DISCOVERY,
+					      MIRROR),
+		.listeners_arr = {
+			MLXSW_SP_RXL_MARK(ARPBC, NEIGH_DISCOVERY, MIRROR_TO_CPU,
+					  false),
+		},
+	},
+	{
+		.trap = MLXSW_SP_TRAP_CONTROL(ARP_RESPONSE, NEIGH_DISCOVERY,
+					      MIRROR),
+		.listeners_arr = {
+			MLXSW_SP_RXL_MARK(ARPUC, NEIGH_DISCOVERY, MIRROR_TO_CPU,
+					  false),
+		},
+	},
+	{
+		.trap = MLXSW_SP_TRAP_CONTROL(ARP_OVERLAY, NEIGH_DISCOVERY,
+					      TRAP),
+		.listeners_arr = {
+			MLXSW_SP_RXL_NO_MARK(NVE_DECAP_ARP, NEIGH_DISCOVERY,
+					     TRAP_TO_CPU, false),
+		},
+	},
+	{
+		.trap = MLXSW_SP_TRAP_CONTROL(IPV6_NEIGH_SOLICIT,
+					      NEIGH_DISCOVERY, TRAP),
+		.listeners_arr = {
+			MLXSW_SP_RXL_MARK(L3_IPV6_NEIGHBOR_SOLICITATION,
+					  NEIGH_DISCOVERY, TRAP_TO_CPU, false),
+		},
+	},
+	{
+		.trap = MLXSW_SP_TRAP_CONTROL(IPV6_NEIGH_ADVERT,
+					      NEIGH_DISCOVERY, TRAP),
+		.listeners_arr = {
+			MLXSW_SP_RXL_MARK(L3_IPV6_NEIGHBOR_ADVERTISEMENT,
+					  NEIGH_DISCOVERY, TRAP_TO_CPU, false),
+		},
+	},
+	{
+		.trap = MLXSW_SP_TRAP_CONTROL(IPV4_BFD, BFD, TRAP),
+		.listeners_arr = {
+			MLXSW_SP_RXL_MARK(IPV4_BFD, BFD, TRAP_TO_CPU, false),
+		},
+	},
+	{
+		.trap = MLXSW_SP_TRAP_CONTROL(IPV6_BFD, BFD, TRAP),
+		.listeners_arr = {
+			MLXSW_SP_RXL_MARK(IPV6_BFD, BFD, TRAP_TO_CPU, false),
+		},
+	},
+	{
+		.trap = MLXSW_SP_TRAP_CONTROL(IPV4_OSPF, OSPF, TRAP),
+		.listeners_arr = {
+			MLXSW_SP_RXL_MARK(IPV4_OSPF, OSPF, TRAP_TO_CPU, false),
+		},
+	},
+	{
+		.trap = MLXSW_SP_TRAP_CONTROL(IPV6_OSPF, OSPF, TRAP),
+		.listeners_arr = {
+			MLXSW_SP_RXL_MARK(IPV6_OSPF, OSPF, TRAP_TO_CPU, false),
+		},
+	},
+	{
+		.trap = MLXSW_SP_TRAP_CONTROL(IPV4_BGP, BGP, TRAP),
+		.listeners_arr = {
+			MLXSW_SP_RXL_MARK(IPV4_BGP, BGP, TRAP_TO_CPU, false),
+		},
+	},
+	{
+		.trap = MLXSW_SP_TRAP_CONTROL(IPV6_BGP, BGP, TRAP),
+		.listeners_arr = {
+			MLXSW_SP_RXL_MARK(IPV6_BGP, BGP, TRAP_TO_CPU, false),
+		},
+	},
+	{
+		.trap = MLXSW_SP_TRAP_CONTROL(IPV4_VRRP, VRRP, TRAP),
+		.listeners_arr = {
+			MLXSW_SP_RXL_MARK(IPV4_VRRP, VRRP, TRAP_TO_CPU, false),
+		},
+	},
+	{
+		.trap = MLXSW_SP_TRAP_CONTROL(IPV6_VRRP, VRRP, TRAP),
+		.listeners_arr = {
+			MLXSW_SP_RXL_MARK(IPV6_VRRP, VRRP, TRAP_TO_CPU, false),
+		},
+	},
+	{
+		.trap = MLXSW_SP_TRAP_CONTROL(IPV4_PIM, PIM, TRAP),
+		.listeners_arr = {
+			MLXSW_SP_RXL_MARK(IPV4_PIM, PIM, TRAP_TO_CPU, false),
+		},
+	},
+	{
+		.trap = MLXSW_SP_TRAP_CONTROL(IPV6_PIM, PIM, TRAP),
+		.listeners_arr = {
+			MLXSW_SP_RXL_MARK(IPV6_PIM, PIM, TRAP_TO_CPU, false),
+		},
+	},
+	{
+		.trap = MLXSW_SP_TRAP_CONTROL(UC_LB, UC_LB, MIRROR),
+		.listeners_arr = {
+			MLXSW_SP_RXL_L3_MARK(LBERROR, LBERROR, MIRROR_TO_CPU,
+					     false),
+		},
+	},
+	{
+		.trap = MLXSW_SP_TRAP_CONTROL(LOCAL_ROUTE, LOCAL_DELIVERY,
+					      TRAP),
+		.listeners_arr = {
+			MLXSW_SP_RXL_MARK(IP2ME, IP2ME, TRAP_TO_CPU, false),
+		},
+	},
+	{
+		.trap = MLXSW_SP_TRAP_CONTROL(EXTERNAL_ROUTE, LOCAL_DELIVERY,
+					      TRAP),
+		.listeners_arr = {
+			MLXSW_SP_RXL_MARK(RTR_INGRESS0, IP2ME, TRAP_TO_CPU,
+					  false),
+		},
+	},
+	{
+		.trap = MLXSW_SP_TRAP_CONTROL(IPV6_UC_DIP_LINK_LOCAL_SCOPE,
+					      LOCAL_DELIVERY, TRAP),
+		.listeners_arr = {
+			MLXSW_SP_RXL_MARK(IPV6_LINK_LOCAL_DEST, IP2ME,
+					  TRAP_TO_CPU, false),
+		},
+	},
+	{
+		.trap = MLXSW_SP_TRAP_CONTROL(IPV4_ROUTER_ALERT, LOCAL_DELIVERY,
+					      TRAP),
+		.listeners_arr = {
+			MLXSW_SP_RXL_MARK(ROUTER_ALERT_IPV4, IP2ME, TRAP_TO_CPU,
+					  false),
+		},
+	},
+	{
+		/* IPV6_ROUTER_ALERT is defined in uAPI as 22, but it is not
+		 * used in this file, so undefine it.
+		 */
+		#undef IPV6_ROUTER_ALERT
+		.trap = MLXSW_SP_TRAP_CONTROL(IPV6_ROUTER_ALERT, LOCAL_DELIVERY,
+					      TRAP),
+		.listeners_arr = {
+			MLXSW_SP_RXL_MARK(ROUTER_ALERT_IPV6, IP2ME, TRAP_TO_CPU,
+					  false),
+		},
+	},
+	{
+		.trap = MLXSW_SP_TRAP_CONTROL(IPV6_DIP_ALL_NODES, IPV6, TRAP),
+		.listeners_arr = {
+			MLXSW_SP_RXL_MARK(IPV6_ALL_NODES_LINK, IPV6,
+					  TRAP_TO_CPU, false),
+		},
+	},
+	{
+		.trap = MLXSW_SP_TRAP_CONTROL(IPV6_DIP_ALL_ROUTERS, IPV6, TRAP),
+		.listeners_arr = {
+			MLXSW_SP_RXL_MARK(IPV6_ALL_ROUTERS_LINK, IPV6,
+					  TRAP_TO_CPU, false),
+		},
+	},
+	{
+		.trap = MLXSW_SP_TRAP_CONTROL(IPV6_ROUTER_SOLICIT, IPV6, TRAP),
+		.listeners_arr = {
+			MLXSW_SP_RXL_MARK(L3_IPV6_ROUTER_SOLICITATION, IPV6,
+					  TRAP_TO_CPU, false),
+		},
+	},
+	{
+		.trap = MLXSW_SP_TRAP_CONTROL(IPV6_ROUTER_ADVERT, IPV6, TRAP),
+		.listeners_arr = {
+			MLXSW_SP_RXL_MARK(L3_IPV6_ROUTER_ADVERTISEMENT, IPV6,
+					  TRAP_TO_CPU, false),
+		},
+	},
+	{
+		.trap = MLXSW_SP_TRAP_CONTROL(IPV6_REDIRECT, IPV6, TRAP),
+		.listeners_arr = {
+			MLXSW_SP_RXL_MARK(L3_IPV6_REDIRECTION, IPV6,
+					  TRAP_TO_CPU, false),
+		},
+	},
+	{
+		.trap = MLXSW_SP_TRAP_CONTROL(PTP_EVENT, PTP_EVENT, TRAP),
+		.listeners_arr = {
+			MLXSW_RXL(mlxsw_sp_rx_ptp_listener, PTP0, TRAP_TO_CPU,
+				  false, SP_PTP0, DISCARD),
+		},
+	},
+	{
+		.trap = MLXSW_SP_TRAP_CONTROL(PTP_GENERAL, PTP_GENERAL, TRAP),
+		.listeners_arr = {
+			MLXSW_SP_RXL_NO_MARK(PTP1, PTP1, TRAP_TO_CPU, false),
+		},
+	},
 };
 
 static struct mlxsw_sp_trap_policer_item *
-- 
2.26.2

