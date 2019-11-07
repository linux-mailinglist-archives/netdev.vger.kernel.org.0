Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1B86F34DE
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 17:43:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389701AbfKGQnd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 11:43:33 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:57441 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389626AbfKGQn2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 11:43:28 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 23A2221C82;
        Thu,  7 Nov 2019 11:43:26 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 07 Nov 2019 11:43:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=EHCfoI6iXnpvIEnHOD2aJnsTtbdP7Tb/w9qhFIL7fDg=; b=O+0eBpfM
        qD0U7UzbJipEH+IYmBCqGWFHu8QSvw1BjOFRKHiQWHT8/tSXH0mVL+EFE6SIgvHN
        J9vExE1+IQodU90iP6wVVcuSMOanXylZR7oN+3QZeyYES51ohfbf8L5JuUmBlnCT
        1CrerZc0iBDbrui1k3lNFkhIi5wk4Fk7yhv2XjaSCtEBEz/x+8fzwB9wJsotKFm5
        OjMm5rlFqPljE76WtH3g1G3gnWkIMJWe8Qe6GViSNAACcAbaCJq8/7UeuS14zm4L
        bfcDy/gTFD8nu8yev2fwbGDjgDfluLJtXypzlDtH4LUGsnzWsmq+VscpsZwjBSo4
        ioxd5FohLFoZfQ==
X-ME-Sender: <xms:rUnEXWc1JIaXvWf0Vq4DVkctksiGL6BQHVz_V_s4rF5kW6lVXTqv_A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudduledgleduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpeei
X-ME-Proxy: <xmx:rUnEXa2f1oJWlJuwe9ffxvOhpJBtIiSBt03B6d5_C7XHZntv4aO5hA>
    <xmx:rUnEXblVuIuubJTLCVxgEp5ZLJFU2LwRK_V5iUId_Aj0R8iZrdtiQQ>
    <xmx:rUnEXZM6g4O7ige5tNWf4kY8W2P22S1kMlhX0fJVUCWYtnVTaaYhow>
    <xmx:rknEXWc4ugI2DK2nu9UFyjjS8myTNv_8wxnp-eXEBx1Qnxc5tch14w>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9A8648005B;
        Thu,  7 Nov 2019 11:43:24 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, amitc@mellanox.com,
        dsahern@gmail.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 09/12] mlxsw: Add layer 3 devlink-trap exceptions support
Date:   Thu,  7 Nov 2019 18:42:17 +0200
Message-Id: <20191107164220.20526-10-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191107164220.20526-1-idosch@idosch.org>
References: <20191107164220.20526-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amitc@mellanox.com>

Add the trap IDs used to report layer 3 exceptions.

Trapped packets are first reported to devlink and then injected to the
kernel's receive path. All the packets have 'offload_fwd_mark' set in
order to prevent them from potentially being forwarded by the bridge
again.

Signed-off-by: Amit Cohen <amitc@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |  8 ---
 .../ethernet/mellanox/mlxsw/spectrum_trap.c   | 63 +++++++++++++++++++
 drivers/net/ethernet/mellanox/mlxsw/trap.h    |  2 +
 3 files changed, 65 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 34c507f2e39c..db1daa6dee9d 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -4510,10 +4510,7 @@ static const struct mlxsw_listener mlxsw_sp_listener[] = {
 	MLXSW_SP_RXL_NO_MARK(IPV6_MLDV2_LISTENER_REPORT, TRAP_TO_CPU, IPV6_MLD,
 			     false),
 	/* L3 traps */
-	MLXSW_SP_RXL_MARK(MTUERROR, TRAP_TO_CPU, ROUTER_EXP, false),
-	MLXSW_SP_RXL_MARK(TTLERROR, TRAP_TO_CPU, ROUTER_EXP, false),
 	MLXSW_SP_RXL_L3_MARK(LBERROR, MIRROR_TO_CPU, LBERROR, false),
-	MLXSW_SP_RXL_MARK(RTR_INGRESS1, TRAP_TO_CPU, REMOTE_ROUTE, false),
 	MLXSW_SP_RXL_MARK(IP2ME, TRAP_TO_CPU, IP2ME, false),
 	MLXSW_SP_RXL_MARK(IPV6_UNSPECIFIED_ADDRESS, TRAP_TO_CPU, ROUTER_EXP,
 			  false),
@@ -4526,8 +4523,6 @@ static const struct mlxsw_listener mlxsw_sp_listener[] = {
 	MLXSW_SP_RXL_MARK(IPV6_OSPF, TRAP_TO_CPU, OSPF, false),
 	MLXSW_SP_RXL_MARK(IPV6_DHCP, TRAP_TO_CPU, DHCP, false),
 	MLXSW_SP_RXL_MARK(RTR_INGRESS0, TRAP_TO_CPU, REMOTE_ROUTE, false),
-	MLXSW_SP_RXL_MARK(DISCARD_ROUTER3, TRAP_EXCEPTION_TO_CPU, REMOTE_ROUTE,
-			  false),
 	MLXSW_SP_RXL_MARK(IPV4_BGP, TRAP_TO_CPU, BGP, false),
 	MLXSW_SP_RXL_MARK(IPV6_BGP, TRAP_TO_CPU, BGP, false),
 	MLXSW_SP_RXL_MARK(L3_IPV6_ROUTER_SOLICITATION, TRAP_TO_CPU, IPV6_ND,
@@ -4541,8 +4536,6 @@ static const struct mlxsw_listener mlxsw_sp_listener[] = {
 	MLXSW_SP_RXL_MARK(L3_IPV6_REDIRECTION, TRAP_TO_CPU, IPV6_ND, false),
 	MLXSW_SP_RXL_MARK(IPV6_MC_LINK_LOCAL_DEST, TRAP_TO_CPU, ROUTER_EXP,
 			  false),
-	MLXSW_SP_RXL_MARK(HOST_MISS_IPV4, TRAP_TO_CPU, HOST_MISS, false),
-	MLXSW_SP_RXL_MARK(HOST_MISS_IPV6, TRAP_TO_CPU, HOST_MISS, false),
 	MLXSW_SP_RXL_MARK(ROUTER_ALERT_IPV4, TRAP_TO_CPU, ROUTER_EXP, false),
 	MLXSW_SP_RXL_MARK(ROUTER_ALERT_IPV6, TRAP_TO_CPU, ROUTER_EXP, false),
 	MLXSW_SP_RXL_MARK(IPIP_DECAP_ERROR, TRAP_TO_CPU, ROUTER_EXP, false),
@@ -4557,7 +4550,6 @@ static const struct mlxsw_listener mlxsw_sp_listener[] = {
 	/* Multicast Router Traps */
 	MLXSW_SP_RXL_MARK(IPV4_PIM, TRAP_TO_CPU, PIM, false),
 	MLXSW_SP_RXL_MARK(IPV6_PIM, TRAP_TO_CPU, PIM, false),
-	MLXSW_SP_RXL_MARK(RPF, TRAP_TO_CPU, RPF, false),
 	MLXSW_SP_RXL_MARK(ACL1, TRAP_TO_CPU, MULTICAST, false),
 	MLXSW_SP_RXL_L3_MARK(ACL2, TRAP_TO_CPU, MULTICAST, false),
 	/* NVE traps */
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
index f0e6811baa1c..e0d7c49ffae0 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
@@ -13,16 +13,27 @@
 
 static void mlxsw_sp_rx_drop_listener(struct sk_buff *skb, u8 local_port,
 				      void *priv);
+static void mlxsw_sp_rx_exception_listener(struct sk_buff *skb, u8 local_port,
+					   void *trap_ctx);
 
 #define MLXSW_SP_TRAP_DROP(_id, _group_id)				      \
 	DEVLINK_TRAP_GENERIC(DROP, DROP, _id,				      \
 			     DEVLINK_TRAP_GROUP_GENERIC(_group_id),	      \
 			     MLXSW_SP_TRAP_METADATA)
 
+#define MLXSW_SP_TRAP_EXCEPTION(_id, _group_id)		      \
+	DEVLINK_TRAP_GENERIC(EXCEPTION, TRAP, _id,			      \
+			     DEVLINK_TRAP_GROUP_GENERIC(_group_id),	      \
+			     MLXSW_SP_TRAP_METADATA)
+
 #define MLXSW_SP_RXL_DISCARD(_id, _group_id)				      \
 	MLXSW_RXL(mlxsw_sp_rx_drop_listener, DISCARD_##_id, SET_FW_DEFAULT,   \
 		  false, SP_##_group_id, DISCARD)
 
+#define MLXSW_SP_RXL_EXCEPTION(_id, _group_id, _action)			      \
+	MLXSW_RXL(mlxsw_sp_rx_exception_listener, _id,			      \
+		   _action, false, SP_##_group_id, DISCARD)
+
 static struct devlink_trap mlxsw_sp_traps_arr[] = {
 	MLXSW_SP_TRAP_DROP(SMAC_MC, L2_DROPS),
 	MLXSW_SP_TRAP_DROP(VLAN_TAG_MISMATCH, L2_DROPS),
@@ -40,6 +51,13 @@ static struct devlink_trap mlxsw_sp_traps_arr[] = {
 	MLXSW_SP_TRAP_DROP(IPV4_SIP_BC, L3_DROPS),
 	MLXSW_SP_TRAP_DROP(IPV6_MC_DIP_RESERVED_SCOPE, L3_DROPS),
 	MLXSW_SP_TRAP_DROP(IPV6_MC_DIP_INTERFACE_LOCAL_SCOPE, L3_DROPS),
+	MLXSW_SP_TRAP_EXCEPTION(MTU_ERROR, L3_DROPS),
+	MLXSW_SP_TRAP_EXCEPTION(TTL_ERROR, L3_DROPS),
+	MLXSW_SP_TRAP_EXCEPTION(RPF, L3_DROPS),
+	MLXSW_SP_TRAP_EXCEPTION(REJECT_ROUTE, L3_DROPS),
+	MLXSW_SP_TRAP_EXCEPTION(UNRESOLVED_NEIGH, L3_DROPS),
+	MLXSW_SP_TRAP_EXCEPTION(IPV4_LPM_UNICAST_MISS, L3_DROPS),
+	MLXSW_SP_TRAP_EXCEPTION(IPV6_LPM_UNICAST_MISS, L3_DROPS),
 };
 
 static struct mlxsw_listener mlxsw_sp_listeners_arr[] = {
@@ -60,6 +78,18 @@ static struct mlxsw_listener mlxsw_sp_listeners_arr[] = {
 	MLXSW_SP_RXL_DISCARD(ING_ROUTER_IPV4_SIP_BC, L3_DISCARDS),
 	MLXSW_SP_RXL_DISCARD(IPV6_MC_DIP_RESERVED_SCOPE, L3_DISCARDS),
 	MLXSW_SP_RXL_DISCARD(IPV6_MC_DIP_INTERFACE_LOCAL_SCOPE, L3_DISCARDS),
+	MLXSW_SP_RXL_EXCEPTION(MTUERROR, ROUTER_EXP, TRAP_TO_CPU),
+	MLXSW_SP_RXL_EXCEPTION(TTLERROR, ROUTER_EXP, TRAP_TO_CPU),
+	MLXSW_SP_RXL_EXCEPTION(RPF, RPF, TRAP_TO_CPU),
+	MLXSW_SP_RXL_EXCEPTION(RTR_INGRESS1, REMOTE_ROUTE, TRAP_TO_CPU),
+	MLXSW_SP_RXL_EXCEPTION(HOST_MISS_IPV4, HOST_MISS, TRAP_TO_CPU),
+	MLXSW_SP_RXL_EXCEPTION(HOST_MISS_IPV6, HOST_MISS, TRAP_TO_CPU),
+	MLXSW_SP_RXL_EXCEPTION(DISCARD_ROUTER3, REMOTE_ROUTE,
+			       TRAP_EXCEPTION_TO_CPU),
+	MLXSW_SP_RXL_EXCEPTION(DISCARD_ROUTER_LPM4, ROUTER_EXP,
+			       TRAP_EXCEPTION_TO_CPU),
+	MLXSW_SP_RXL_EXCEPTION(DISCARD_ROUTER_LPM6, ROUTER_EXP,
+			       TRAP_EXCEPTION_TO_CPU),
 };
 
 /* Mapping between hardware trap and devlink trap. Multiple hardware traps can
@@ -84,6 +114,15 @@ static u16 mlxsw_sp_listener_devlink_map[] = {
 	DEVLINK_TRAP_GENERIC_ID_IPV4_SIP_BC,
 	DEVLINK_TRAP_GENERIC_ID_IPV6_MC_DIP_RESERVED_SCOPE,
 	DEVLINK_TRAP_GENERIC_ID_IPV6_MC_DIP_INTERFACE_LOCAL_SCOPE,
+	DEVLINK_TRAP_GENERIC_ID_MTU_ERROR,
+	DEVLINK_TRAP_GENERIC_ID_TTL_ERROR,
+	DEVLINK_TRAP_GENERIC_ID_RPF,
+	DEVLINK_TRAP_GENERIC_ID_REJECT_ROUTE,
+	DEVLINK_TRAP_GENERIC_ID_UNRESOLVED_NEIGH,
+	DEVLINK_TRAP_GENERIC_ID_UNRESOLVED_NEIGH,
+	DEVLINK_TRAP_GENERIC_ID_UNRESOLVED_NEIGH,
+	DEVLINK_TRAP_GENERIC_ID_IPV4_LPM_UNICAST_MISS,
+	DEVLINK_TRAP_GENERIC_ID_IPV6_LPM_UNICAST_MISS,
 };
 
 static int mlxsw_sp_rx_listener(struct mlxsw_sp *mlxsw_sp, struct sk_buff *skb,
@@ -134,6 +173,30 @@ static void mlxsw_sp_rx_drop_listener(struct sk_buff *skb, u8 local_port,
 	consume_skb(skb);
 }
 
+static void mlxsw_sp_rx_exception_listener(struct sk_buff *skb, u8 local_port,
+					   void *trap_ctx)
+{
+	struct devlink_port *in_devlink_port;
+	struct mlxsw_sp_port *mlxsw_sp_port;
+	struct mlxsw_sp *mlxsw_sp;
+	struct devlink *devlink;
+
+	mlxsw_sp = devlink_trap_ctx_priv(trap_ctx);
+	mlxsw_sp_port = mlxsw_sp->ports[local_port];
+
+	if (mlxsw_sp_rx_listener(mlxsw_sp, skb, local_port, mlxsw_sp_port))
+		return;
+
+	devlink = priv_to_devlink(mlxsw_sp->core);
+	in_devlink_port = mlxsw_core_port_devlink_port_get(mlxsw_sp->core,
+							   local_port);
+	skb_push(skb, ETH_HLEN);
+	devlink_trap_report(devlink, skb, trap_ctx, in_devlink_port);
+	skb_pull(skb, ETH_HLEN);
+	skb->offload_fwd_mark = 1;
+	netif_receive_skb(skb);
+}
+
 int mlxsw_sp_devlink_traps_init(struct mlxsw_sp *mlxsw_sp)
 {
 	struct devlink *devlink = priv_to_devlink(mlxsw_sp->core);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/trap.h b/drivers/net/ethernet/mellanox/mlxsw/trap.h
index b84b7f07dce2..0c1c142bb6b0 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/trap.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/trap.h
@@ -84,6 +84,8 @@ enum {
 	MLXSW_TRAP_ID_DISCARD_ING_ROUTER_CORRUPTED_IP_HDR = 0x167,
 	MLXSW_TRAP_ID_DISCARD_ING_ROUTER_IPV4_SIP_BC = 0x16A,
 	MLXSW_TRAP_ID_DISCARD_ING_ROUTER_IPV4_DIP_LOCAL_NET = 0x16B,
+	MLXSW_TRAP_ID_DISCARD_ROUTER_LPM4 = 0x17B,
+	MLXSW_TRAP_ID_DISCARD_ROUTER_LPM6 = 0x17C,
 	MLXSW_TRAP_ID_DISCARD_IPV6_MC_DIP_RESERVED_SCOPE = 0x1B0,
 	MLXSW_TRAP_ID_DISCARD_IPV6_MC_DIP_INTERFACE_LOCAL_SCOPE = 0x1B1,
 	MLXSW_TRAP_ID_ACL0 = 0x1C0,
-- 
2.21.0

