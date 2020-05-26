Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 424111D6493
	for <lists+netdev@lfdr.de>; Sun, 17 May 2020 00:43:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726939AbgEPWnq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 May 2020 18:43:46 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:45733 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726660AbgEPWnm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 May 2020 18:43:42 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 9A8E95C007B;
        Sat, 16 May 2020 18:43:40 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sat, 16 May 2020 18:43:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=1zGidTuV/4z5NGPInmUM3gZIWeXdOT0qS8mxE6KNzEA=; b=iYkFKw5I
        obO5Tiv4uOjTgKOUyk5BpP2rcHKi7bVtWvvwM1bpY5zUOgTaJ77tO0V64x/8qGq9
        XBXNLhSvyR3ENeqPNyvBcZoSuxKrZi22jwFCrUOfutHfjQye529ptuG5rcAvjVJ5
        EXIiUWtdCKYqu1EwZyyrK7Y4JKiFiGqw+v4ygBmxoWIke3LVxz6gzgz3TEb01PA0
        nG6bM/BvFU6YQ5r36T43s+csYgz6/E/HnkIeBpib0W2p+cuu63tSgnQbZSx6Dhxr
        sTLYKZyJfsuLEhjfOWwtePkQ9igOURaJEcLzResMZNEJez47RkFGIbVv9bUVhK/u
        /9WehIzd/Rx3Kg==
X-ME-Sender: <xms:nGzAXvJDLW52e5wlhjP7KHPkbNUW6KnsasZGZS--Yc6tNb_UXUXaWw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedruddtuddguddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeejledrudejiedrvdegrddutdej
    necuvehluhhsthgvrhfuihiivgepfeenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:nGzAXjJ2X1vgT20Ha6e8BqXh95wRN5Mv4QkOh0NvWE62nCTDGtJ9cg>
    <xmx:nGzAXnuXTvUbxidyjqwPdKz28WAKYbwkWqon3aC4wGA0M9Vu6H7aOg>
    <xmx:nGzAXoZt1qKDqBAVMKoM5-KdtkYUltn3Y-vrhK2huEktnQckLSMD1Q>
    <xmx:nGzAXpxjX1UmSOjPIobasyFAOc84bQFMhZUWD3QqsJMQKfdJkU8V_Q>
Received: from splinter.mtl.com (bzq-79-176-24-107.red.bezeqint.net [79.176.24.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2D02D306639E;
        Sat, 16 May 2020 18:43:39 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 4/6] mlxsw: spectrum_trap: Store all trap data in one array
Date:   Sun, 17 May 2020 01:43:08 +0300
Message-Id: <20200516224310.877237-5-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200516224310.877237-1-idosch@idosch.org>
References: <20200516224310.877237-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Each trap registered with devlink is mapped to one or more Rx listeners.
These listeners allow the switch driver (e.g., mlxsw_spectrum) to
register a function that is called when a packet is received (trapped)
for a specific reason.

Currently, three arrays are used to describe the mapping between the
logical devlink traps and the Rx listeners.

Instead, get rid of these arrays and store all the information in one
array that is easier to validate and extend with more per-trap
information.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_trap.c   | 466 ++++++++++++------
 .../ethernet/mellanox/mlxsw/spectrum_trap.h   |   3 +
 2 files changed, 326 insertions(+), 143 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
index f87135ee69ee..3a13b17cd1b8 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
@@ -24,6 +24,13 @@ struct mlxsw_sp_trap_group_item {
 	u8 tc;
 };
 
+#define MLXSW_SP_TRAP_LISTENERS_MAX 3
+
+struct mlxsw_sp_trap_item {
+	struct devlink_trap trap;
+	struct mlxsw_listener listeners_arr[MLXSW_SP_TRAP_LISTENERS_MAX];
+};
+
 /* All driver-specific traps must be documented in
  * Documentation/networking/devlink/mlxsw.rst
  */
@@ -222,125 +229,221 @@ static const struct mlxsw_sp_trap_group_item mlxsw_sp_trap_group_items_arr[] = {
 	},
 };
 
-static const struct devlink_trap mlxsw_sp_traps_arr[] = {
-	MLXSW_SP_TRAP_DROP(SMAC_MC, L2_DROPS),
-	MLXSW_SP_TRAP_DROP(VLAN_TAG_MISMATCH, L2_DROPS),
-	MLXSW_SP_TRAP_DROP(INGRESS_VLAN_FILTER, L2_DROPS),
-	MLXSW_SP_TRAP_DROP(INGRESS_STP_FILTER, L2_DROPS),
-	MLXSW_SP_TRAP_DROP(EMPTY_TX_LIST, L2_DROPS),
-	MLXSW_SP_TRAP_DROP(PORT_LOOPBACK_FILTER, L2_DROPS),
-	MLXSW_SP_TRAP_DROP(BLACKHOLE_ROUTE, L3_DROPS),
-	MLXSW_SP_TRAP_DROP(NON_IP_PACKET, L3_DROPS),
-	MLXSW_SP_TRAP_DROP(UC_DIP_MC_DMAC, L3_DROPS),
-	MLXSW_SP_TRAP_DROP(DIP_LB, L3_DROPS),
-	MLXSW_SP_TRAP_DROP(SIP_MC, L3_DROPS),
-	MLXSW_SP_TRAP_DROP(SIP_LB, L3_DROPS),
-	MLXSW_SP_TRAP_DROP(CORRUPTED_IP_HDR, L3_DROPS),
-	MLXSW_SP_TRAP_DROP(IPV4_SIP_BC, L3_DROPS),
-	MLXSW_SP_TRAP_DROP(IPV6_MC_DIP_RESERVED_SCOPE, L3_DROPS),
-	MLXSW_SP_TRAP_DROP(IPV6_MC_DIP_INTERFACE_LOCAL_SCOPE, L3_DROPS),
-	MLXSW_SP_TRAP_EXCEPTION(MTU_ERROR, L3_DROPS),
-	MLXSW_SP_TRAP_EXCEPTION(TTL_ERROR, L3_DROPS),
-	MLXSW_SP_TRAP_EXCEPTION(RPF, L3_DROPS),
-	MLXSW_SP_TRAP_EXCEPTION(REJECT_ROUTE, L3_DROPS),
-	MLXSW_SP_TRAP_EXCEPTION(UNRESOLVED_NEIGH, L3_DROPS),
-	MLXSW_SP_TRAP_EXCEPTION(IPV4_LPM_UNICAST_MISS, L3_DROPS),
-	MLXSW_SP_TRAP_EXCEPTION(IPV6_LPM_UNICAST_MISS, L3_DROPS),
-	MLXSW_SP_TRAP_DRIVER_DROP(IRIF_DISABLED, L3_DROPS),
-	MLXSW_SP_TRAP_DRIVER_DROP(ERIF_DISABLED, L3_DROPS),
-	MLXSW_SP_TRAP_DROP(NON_ROUTABLE, L3_DROPS),
-	MLXSW_SP_TRAP_EXCEPTION(DECAP_ERROR, TUNNEL_DROPS),
-	MLXSW_SP_TRAP_DROP(OVERLAY_SMAC_MC, TUNNEL_DROPS),
-	MLXSW_SP_TRAP_DROP_EXT(INGRESS_FLOW_ACTION_DROP, ACL_DROPS,
-			       DEVLINK_TRAP_METADATA_TYPE_F_FA_COOKIE),
-	MLXSW_SP_TRAP_DROP_EXT(EGRESS_FLOW_ACTION_DROP, ACL_DROPS,
-			       DEVLINK_TRAP_METADATA_TYPE_F_FA_COOKIE),
-};
-
-static const struct mlxsw_listener mlxsw_sp_listeners_arr[] = {
-	MLXSW_SP_RXL_DISCARD(ING_PACKET_SMAC_MC, L2_DISCARDS),
-	MLXSW_SP_RXL_DISCARD(ING_SWITCH_VTAG_ALLOW, L2_DISCARDS),
-	MLXSW_SP_RXL_DISCARD(ING_SWITCH_VLAN, L2_DISCARDS),
-	MLXSW_SP_RXL_DISCARD(ING_SWITCH_STP, L2_DISCARDS),
-	MLXSW_SP_RXL_DISCARD(LOOKUP_SWITCH_UC, L2_DISCARDS),
-	MLXSW_SP_RXL_DISCARD(LOOKUP_SWITCH_MC_NULL, L2_DISCARDS),
-	MLXSW_SP_RXL_DISCARD(LOOKUP_SWITCH_LB, L2_DISCARDS),
-	MLXSW_SP_RXL_DISCARD(ROUTER2, L3_DISCARDS),
-	MLXSW_SP_RXL_DISCARD(ING_ROUTER_NON_IP_PACKET, L3_DISCARDS),
-	MLXSW_SP_RXL_DISCARD(ING_ROUTER_UC_DIP_MC_DMAC, L3_DISCARDS),
-	MLXSW_SP_RXL_DISCARD(ING_ROUTER_DIP_LB, L3_DISCARDS),
-	MLXSW_SP_RXL_DISCARD(ING_ROUTER_SIP_MC, L3_DISCARDS),
-	MLXSW_SP_RXL_DISCARD(ING_ROUTER_SIP_LB, L3_DISCARDS),
-	MLXSW_SP_RXL_DISCARD(ING_ROUTER_CORRUPTED_IP_HDR, L3_DISCARDS),
-	MLXSW_SP_RXL_DISCARD(ING_ROUTER_IPV4_SIP_BC, L3_DISCARDS),
-	MLXSW_SP_RXL_DISCARD(IPV6_MC_DIP_RESERVED_SCOPE, L3_DISCARDS),
-	MLXSW_SP_RXL_DISCARD(IPV6_MC_DIP_INTERFACE_LOCAL_SCOPE, L3_DISCARDS),
-	MLXSW_SP_RXL_EXCEPTION(MTUERROR, L3_DISCARDS, TRAP_TO_CPU),
-	MLXSW_SP_RXL_EXCEPTION(TTLERROR, L3_DISCARDS, TRAP_TO_CPU),
-	MLXSW_SP_RXL_EXCEPTION(RPF, L3_DISCARDS, TRAP_TO_CPU),
-	MLXSW_SP_RXL_EXCEPTION(RTR_INGRESS1, L3_DISCARDS, TRAP_TO_CPU),
-	MLXSW_SP_RXL_EXCEPTION(HOST_MISS_IPV4, L3_DISCARDS, TRAP_TO_CPU),
-	MLXSW_SP_RXL_EXCEPTION(HOST_MISS_IPV6, L3_DISCARDS, TRAP_TO_CPU),
-	MLXSW_SP_RXL_EXCEPTION(DISCARD_ROUTER3, L3_DISCARDS,
-			       TRAP_EXCEPTION_TO_CPU),
-	MLXSW_SP_RXL_EXCEPTION(DISCARD_ROUTER_LPM4, L3_DISCARDS,
-			       TRAP_EXCEPTION_TO_CPU),
-	MLXSW_SP_RXL_EXCEPTION(DISCARD_ROUTER_LPM6, L3_DISCARDS,
-			       TRAP_EXCEPTION_TO_CPU),
-	MLXSW_SP_RXL_DISCARD(ROUTER_IRIF_EN, L3_DISCARDS),
-	MLXSW_SP_RXL_DISCARD(ROUTER_ERIF_EN, L3_DISCARDS),
-	MLXSW_SP_RXL_DISCARD(NON_ROUTABLE, L3_DISCARDS),
-	MLXSW_SP_RXL_EXCEPTION(DECAP_ECN0, TUNNEL_DISCARDS,
-			       TRAP_EXCEPTION_TO_CPU),
-	MLXSW_SP_RXL_EXCEPTION(IPIP_DECAP_ERROR, TUNNEL_DISCARDS,
-			       TRAP_EXCEPTION_TO_CPU),
-	MLXSW_SP_RXL_EXCEPTION(DISCARD_DEC_PKT, TUNNEL_DISCARDS,
-			       TRAP_EXCEPTION_TO_CPU),
-	MLXSW_SP_RXL_DISCARD(OVERLAY_SMAC_MC, TUNNEL_DISCARDS),
-	MLXSW_SP_RXL_ACL_DISCARD(INGRESS_ACL, ACL_DISCARDS, DUMMY),
-	MLXSW_SP_RXL_ACL_DISCARD(EGRESS_ACL, ACL_DISCARDS, DUMMY),
-};
-
-/* Mapping between hardware trap and devlink trap. Multiple hardware traps can
- * be mapped to the same devlink trap. Order is according to
- * 'mlxsw_sp_listeners_arr'.
- */
-static const u16 mlxsw_sp_listener_devlink_map[] = {
-	DEVLINK_TRAP_GENERIC_ID_SMAC_MC,
-	DEVLINK_TRAP_GENERIC_ID_VLAN_TAG_MISMATCH,
-	DEVLINK_TRAP_GENERIC_ID_INGRESS_VLAN_FILTER,
-	DEVLINK_TRAP_GENERIC_ID_INGRESS_STP_FILTER,
-	DEVLINK_TRAP_GENERIC_ID_EMPTY_TX_LIST,
-	DEVLINK_TRAP_GENERIC_ID_EMPTY_TX_LIST,
-	DEVLINK_TRAP_GENERIC_ID_PORT_LOOPBACK_FILTER,
-	DEVLINK_TRAP_GENERIC_ID_BLACKHOLE_ROUTE,
-	DEVLINK_TRAP_GENERIC_ID_NON_IP_PACKET,
-	DEVLINK_TRAP_GENERIC_ID_UC_DIP_MC_DMAC,
-	DEVLINK_TRAP_GENERIC_ID_DIP_LB,
-	DEVLINK_TRAP_GENERIC_ID_SIP_MC,
-	DEVLINK_TRAP_GENERIC_ID_SIP_LB,
-	DEVLINK_TRAP_GENERIC_ID_CORRUPTED_IP_HDR,
-	DEVLINK_TRAP_GENERIC_ID_IPV4_SIP_BC,
-	DEVLINK_TRAP_GENERIC_ID_IPV6_MC_DIP_RESERVED_SCOPE,
-	DEVLINK_TRAP_GENERIC_ID_IPV6_MC_DIP_INTERFACE_LOCAL_SCOPE,
-	DEVLINK_TRAP_GENERIC_ID_MTU_ERROR,
-	DEVLINK_TRAP_GENERIC_ID_TTL_ERROR,
-	DEVLINK_TRAP_GENERIC_ID_RPF,
-	DEVLINK_TRAP_GENERIC_ID_REJECT_ROUTE,
-	DEVLINK_TRAP_GENERIC_ID_UNRESOLVED_NEIGH,
-	DEVLINK_TRAP_GENERIC_ID_UNRESOLVED_NEIGH,
-	DEVLINK_TRAP_GENERIC_ID_UNRESOLVED_NEIGH,
-	DEVLINK_TRAP_GENERIC_ID_IPV4_LPM_UNICAST_MISS,
-	DEVLINK_TRAP_GENERIC_ID_IPV6_LPM_UNICAST_MISS,
-	DEVLINK_MLXSW_TRAP_ID_IRIF_DISABLED,
-	DEVLINK_MLXSW_TRAP_ID_ERIF_DISABLED,
-	DEVLINK_TRAP_GENERIC_ID_NON_ROUTABLE,
-	DEVLINK_TRAP_GENERIC_ID_DECAP_ERROR,
-	DEVLINK_TRAP_GENERIC_ID_DECAP_ERROR,
-	DEVLINK_TRAP_GENERIC_ID_DECAP_ERROR,
-	DEVLINK_TRAP_GENERIC_ID_OVERLAY_SMAC_MC,
-	DEVLINK_TRAP_GENERIC_ID_INGRESS_FLOW_ACTION_DROP,
-	DEVLINK_TRAP_GENERIC_ID_EGRESS_FLOW_ACTION_DROP,
+static const struct mlxsw_sp_trap_item mlxsw_sp_trap_items_arr[] = {
+	{
+		.trap = MLXSW_SP_TRAP_DROP(SMAC_MC, L2_DROPS),
+		.listeners_arr = {
+			MLXSW_SP_RXL_DISCARD(ING_PACKET_SMAC_MC, L2_DISCARDS),
+		},
+	},
+	{
+		.trap = MLXSW_SP_TRAP_DROP(VLAN_TAG_MISMATCH, L2_DROPS),
+		.listeners_arr = {
+			MLXSW_SP_RXL_DISCARD(ING_SWITCH_VTAG_ALLOW,
+					     L2_DISCARDS),
+		},
+	},
+	{
+		.trap = MLXSW_SP_TRAP_DROP(INGRESS_VLAN_FILTER, L2_DROPS),
+		.listeners_arr = {
+			MLXSW_SP_RXL_DISCARD(ING_SWITCH_VLAN, L2_DISCARDS),
+		},
+	},
+	{
+		.trap = MLXSW_SP_TRAP_DROP(INGRESS_STP_FILTER, L2_DROPS),
+		.listeners_arr = {
+			MLXSW_SP_RXL_DISCARD(ING_SWITCH_STP, L2_DISCARDS),
+		},
+	},
+	{
+		.trap = MLXSW_SP_TRAP_DROP(EMPTY_TX_LIST, L2_DROPS),
+		.listeners_arr = {
+			MLXSW_SP_RXL_DISCARD(LOOKUP_SWITCH_UC, L2_DISCARDS),
+			MLXSW_SP_RXL_DISCARD(LOOKUP_SWITCH_MC_NULL, L2_DISCARDS),
+		},
+	},
+	{
+		.trap = MLXSW_SP_TRAP_DROP(PORT_LOOPBACK_FILTER, L2_DROPS),
+		.listeners_arr = {
+			MLXSW_SP_RXL_DISCARD(LOOKUP_SWITCH_LB, L2_DISCARDS),
+		},
+	},
+	{
+		.trap = MLXSW_SP_TRAP_DROP(BLACKHOLE_ROUTE, L3_DROPS),
+		.listeners_arr = {
+			MLXSW_SP_RXL_DISCARD(ROUTER2, L3_DISCARDS),
+		},
+	},
+	{
+		.trap = MLXSW_SP_TRAP_DROP(NON_IP_PACKET, L3_DROPS),
+		.listeners_arr = {
+			MLXSW_SP_RXL_DISCARD(ING_ROUTER_NON_IP_PACKET,
+					     L3_DISCARDS),
+		},
+	},
+	{
+		.trap = MLXSW_SP_TRAP_DROP(UC_DIP_MC_DMAC, L3_DROPS),
+		.listeners_arr = {
+			MLXSW_SP_RXL_DISCARD(ING_ROUTER_UC_DIP_MC_DMAC,
+					     L3_DISCARDS),
+		},
+	},
+	{
+		.trap = MLXSW_SP_TRAP_DROP(DIP_LB, L3_DROPS),
+		.listeners_arr = {
+			MLXSW_SP_RXL_DISCARD(ING_ROUTER_DIP_LB, L3_DISCARDS),
+		},
+	},
+	{
+		.trap = MLXSW_SP_TRAP_DROP(SIP_MC, L3_DROPS),
+		.listeners_arr = {
+			MLXSW_SP_RXL_DISCARD(ING_ROUTER_SIP_MC, L3_DISCARDS),
+		},
+	},
+	{
+		.trap = MLXSW_SP_TRAP_DROP(SIP_LB, L3_DROPS),
+		.listeners_arr = {
+			MLXSW_SP_RXL_DISCARD(ING_ROUTER_SIP_LB, L3_DISCARDS),
+		},
+	},
+	{
+		.trap = MLXSW_SP_TRAP_DROP(CORRUPTED_IP_HDR, L3_DROPS),
+		.listeners_arr = {
+			MLXSW_SP_RXL_DISCARD(ING_ROUTER_CORRUPTED_IP_HDR,
+					     L3_DISCARDS),
+		},
+	},
+	{
+		.trap = MLXSW_SP_TRAP_DROP(IPV4_SIP_BC, L3_DROPS),
+		.listeners_arr = {
+			MLXSW_SP_RXL_DISCARD(ING_ROUTER_IPV4_SIP_BC,
+					     L3_DISCARDS),
+		},
+	},
+	{
+		.trap = MLXSW_SP_TRAP_DROP(IPV6_MC_DIP_RESERVED_SCOPE,
+					   L3_DROPS),
+		.listeners_arr = {
+			MLXSW_SP_RXL_DISCARD(IPV6_MC_DIP_RESERVED_SCOPE,
+					     L3_DISCARDS),
+		},
+	},
+	{
+		.trap = MLXSW_SP_TRAP_DROP(IPV6_MC_DIP_INTERFACE_LOCAL_SCOPE,
+					   L3_DROPS),
+		.listeners_arr = {
+			MLXSW_SP_RXL_DISCARD(IPV6_MC_DIP_INTERFACE_LOCAL_SCOPE,
+					     L3_DISCARDS),
+		},
+	},
+	{
+		.trap = MLXSW_SP_TRAP_EXCEPTION(MTU_ERROR, L3_DROPS),
+		.listeners_arr = {
+			MLXSW_SP_RXL_EXCEPTION(MTUERROR, L3_DISCARDS,
+					       TRAP_TO_CPU),
+		},
+	},
+	{
+		.trap = MLXSW_SP_TRAP_EXCEPTION(TTL_ERROR, L3_DROPS),
+		.listeners_arr = {
+			MLXSW_SP_RXL_EXCEPTION(TTLERROR, L3_DISCARDS,
+					       TRAP_TO_CPU),
+		},
+	},
+	{
+		.trap = MLXSW_SP_TRAP_EXCEPTION(RPF, L3_DROPS),
+		.listeners_arr = {
+			MLXSW_SP_RXL_EXCEPTION(RPF, L3_DISCARDS, TRAP_TO_CPU),
+		},
+	},
+	{
+		.trap = MLXSW_SP_TRAP_EXCEPTION(REJECT_ROUTE, L3_DROPS),
+		.listeners_arr = {
+			MLXSW_SP_RXL_EXCEPTION(RTR_INGRESS1, L3_DISCARDS,
+					       TRAP_TO_CPU),
+		},
+	},
+	{
+		.trap = MLXSW_SP_TRAP_EXCEPTION(UNRESOLVED_NEIGH, L3_DROPS),
+		.listeners_arr = {
+			MLXSW_SP_RXL_EXCEPTION(HOST_MISS_IPV4, L3_DISCARDS,
+					       TRAP_TO_CPU),
+			MLXSW_SP_RXL_EXCEPTION(HOST_MISS_IPV6, L3_DISCARDS,
+					       TRAP_TO_CPU),
+			MLXSW_SP_RXL_EXCEPTION(DISCARD_ROUTER3, L3_DISCARDS,
+					       TRAP_EXCEPTION_TO_CPU),
+		},
+	},
+	{
+		.trap = MLXSW_SP_TRAP_EXCEPTION(IPV4_LPM_UNICAST_MISS,
+						L3_DROPS),
+		.listeners_arr = {
+			MLXSW_SP_RXL_EXCEPTION(DISCARD_ROUTER_LPM4, L3_DISCARDS,
+					       TRAP_EXCEPTION_TO_CPU),
+		},
+	},
+	{
+		.trap = MLXSW_SP_TRAP_EXCEPTION(IPV6_LPM_UNICAST_MISS,
+						L3_DROPS),
+		.listeners_arr = {
+			MLXSW_SP_RXL_EXCEPTION(DISCARD_ROUTER_LPM6, L3_DISCARDS,
+					       TRAP_EXCEPTION_TO_CPU),
+		},
+	},
+	{
+		.trap = MLXSW_SP_TRAP_DRIVER_DROP(IRIF_DISABLED, L3_DROPS),
+		.listeners_arr = {
+			MLXSW_SP_RXL_DISCARD(ROUTER_IRIF_EN, L3_DISCARDS),
+		},
+	},
+	{
+		.trap = MLXSW_SP_TRAP_DRIVER_DROP(ERIF_DISABLED, L3_DROPS),
+		.listeners_arr = {
+			MLXSW_SP_RXL_DISCARD(ROUTER_ERIF_EN, L3_DISCARDS),
+		},
+	},
+	{
+		.trap = MLXSW_SP_TRAP_DROP(NON_ROUTABLE, L3_DROPS),
+		.listeners_arr = {
+			MLXSW_SP_RXL_DISCARD(NON_ROUTABLE, L3_DISCARDS),
+		},
+	},
+	{
+		.trap = MLXSW_SP_TRAP_EXCEPTION(DECAP_ERROR, TUNNEL_DROPS),
+		.listeners_arr = {
+			MLXSW_SP_RXL_EXCEPTION(DECAP_ECN0, TUNNEL_DISCARDS,
+					       TRAP_EXCEPTION_TO_CPU),
+			MLXSW_SP_RXL_EXCEPTION(IPIP_DECAP_ERROR,
+					       TUNNEL_DISCARDS,
+					       TRAP_EXCEPTION_TO_CPU),
+			MLXSW_SP_RXL_EXCEPTION(DISCARD_DEC_PKT, TUNNEL_DISCARDS,
+					       TRAP_EXCEPTION_TO_CPU),
+		},
+	},
+	{
+		.trap = MLXSW_SP_TRAP_DROP(OVERLAY_SMAC_MC, TUNNEL_DROPS),
+		.listeners_arr = {
+			MLXSW_SP_RXL_DISCARD(OVERLAY_SMAC_MC, TUNNEL_DISCARDS),
+		},
+	},
+	{
+		.trap = MLXSW_SP_TRAP_DROP_EXT(INGRESS_FLOW_ACTION_DROP,
+					       ACL_DROPS,
+					       DEVLINK_TRAP_METADATA_TYPE_F_FA_COOKIE),
+		.listeners_arr = {
+			MLXSW_SP_RXL_ACL_DISCARD(INGRESS_ACL, ACL_DISCARDS,
+						 DUMMY),
+		},
+	},
+	{
+		.trap = MLXSW_SP_TRAP_DROP_EXT(EGRESS_FLOW_ACTION_DROP,
+					       ACL_DROPS,
+					       DEVLINK_TRAP_METADATA_TYPE_F_FA_COOKIE),
+		.listeners_arr = {
+			MLXSW_SP_RXL_ACL_DISCARD(EGRESS_ACL, ACL_DISCARDS,
+						 DUMMY),
+		},
+	},
 };
 
 #define MLXSW_SP_THIN_POLICER_ID	(MLXSW_REG_HTGT_TRAP_GROUP_MAX + 1)
@@ -373,6 +476,20 @@ mlxsw_sp_trap_group_item_lookup(struct mlxsw_sp *mlxsw_sp, u16 id)
 	return NULL;
 }
 
+static struct mlxsw_sp_trap_item *
+mlxsw_sp_trap_item_lookup(struct mlxsw_sp *mlxsw_sp, u16 id)
+{
+	struct mlxsw_sp_trap *trap = mlxsw_sp->trap;
+	int i;
+
+	for (i = 0; i < trap->traps_count; i++) {
+		if (trap->trap_items_arr[i].trap.id == id)
+			return &trap->trap_items_arr[i];
+	}
+
+	return NULL;
+}
+
 static int mlxsw_sp_trap_cpu_policers_set(struct mlxsw_sp *mlxsw_sp)
 {
 	char qpcr_pl[MLXSW_REG_QPCR_LEN];
@@ -542,9 +659,63 @@ static void mlxsw_sp_trap_groups_fini(struct mlxsw_sp *mlxsw_sp)
 	kfree(trap->group_items_arr);
 }
 
-int mlxsw_sp_devlink_traps_init(struct mlxsw_sp *mlxsw_sp)
+static bool
+mlxsw_sp_trap_listener_is_valid(const struct mlxsw_listener *listener)
+{
+	return listener->trap_id != 0;
+}
+
+static int mlxsw_sp_traps_init(struct mlxsw_sp *mlxsw_sp)
 {
 	struct devlink *devlink = priv_to_devlink(mlxsw_sp->core);
+	struct mlxsw_sp_trap *trap = mlxsw_sp->trap;
+	const struct mlxsw_sp_trap_item *trap_item;
+	int err, i;
+
+	trap->trap_items_arr = kmemdup(mlxsw_sp_trap_items_arr,
+				       sizeof(mlxsw_sp_trap_items_arr),
+				       GFP_KERNEL);
+	if (!trap->trap_items_arr)
+		return -ENOMEM;
+
+	trap->traps_count = ARRAY_SIZE(mlxsw_sp_trap_items_arr);
+
+	for (i = 0; i < trap->traps_count; i++) {
+		trap_item = &trap->trap_items_arr[i];
+		err = devlink_traps_register(devlink, &trap_item->trap, 1,
+					     mlxsw_sp);
+		if (err)
+			goto err_trap_register;
+	}
+
+	return 0;
+
+err_trap_register:
+	for (i--; i >= 0; i--) {
+		trap_item = &trap->trap_items_arr[i];
+		devlink_traps_unregister(devlink, &trap_item->trap, 1);
+	}
+	kfree(trap->trap_items_arr);
+	return err;
+}
+
+static void mlxsw_sp_traps_fini(struct mlxsw_sp *mlxsw_sp)
+{
+	struct devlink *devlink = priv_to_devlink(mlxsw_sp->core);
+	struct mlxsw_sp_trap *trap = mlxsw_sp->trap;
+	int i;
+
+	for (i = trap->traps_count - 1; i >= 0; i--) {
+		const struct mlxsw_sp_trap_item *trap_item;
+
+		trap_item = &trap->trap_items_arr[i];
+		devlink_traps_unregister(devlink, &trap_item->trap, 1);
+	}
+	kfree(trap->trap_items_arr);
+}
+
+int mlxsw_sp_devlink_traps_init(struct mlxsw_sp *mlxsw_sp)
+{
 	int err;
 
 	err = mlxsw_sp_trap_cpu_policers_set(mlxsw_sp);
@@ -555,10 +726,6 @@ int mlxsw_sp_devlink_traps_init(struct mlxsw_sp *mlxsw_sp)
 	if (err)
 		return err;
 
-	if (WARN_ON(ARRAY_SIZE(mlxsw_sp_listener_devlink_map) !=
-		    ARRAY_SIZE(mlxsw_sp_listeners_arr)))
-		return -EINVAL;
-
 	err = mlxsw_sp_trap_policers_init(mlxsw_sp);
 	if (err)
 		return err;
@@ -567,14 +734,13 @@ int mlxsw_sp_devlink_traps_init(struct mlxsw_sp *mlxsw_sp)
 	if (err)
 		goto err_trap_groups_init;
 
-	err = devlink_traps_register(devlink, mlxsw_sp_traps_arr,
-				     ARRAY_SIZE(mlxsw_sp_traps_arr), mlxsw_sp);
+	err = mlxsw_sp_traps_init(mlxsw_sp);
 	if (err)
-		goto err_traps_register;
+		goto err_traps_init;
 
 	return 0;
 
-err_traps_register:
+err_traps_init:
 	mlxsw_sp_trap_groups_fini(mlxsw_sp);
 err_trap_groups_init:
 	mlxsw_sp_trap_policers_fini(mlxsw_sp);
@@ -583,10 +749,7 @@ int mlxsw_sp_devlink_traps_init(struct mlxsw_sp *mlxsw_sp)
 
 void mlxsw_sp_devlink_traps_fini(struct mlxsw_sp *mlxsw_sp)
 {
-	struct devlink *devlink = priv_to_devlink(mlxsw_sp->core);
-
-	devlink_traps_unregister(devlink, mlxsw_sp_traps_arr,
-				 ARRAY_SIZE(mlxsw_sp_traps_arr));
+	mlxsw_sp_traps_fini(mlxsw_sp);
 	mlxsw_sp_trap_groups_fini(mlxsw_sp);
 	mlxsw_sp_trap_policers_fini(mlxsw_sp);
 }
@@ -594,16 +757,21 @@ void mlxsw_sp_devlink_traps_fini(struct mlxsw_sp *mlxsw_sp)
 int mlxsw_sp_trap_init(struct mlxsw_core *mlxsw_core,
 		       const struct devlink_trap *trap, void *trap_ctx)
 {
+	struct mlxsw_sp *mlxsw_sp = mlxsw_core_driver_priv(mlxsw_core);
+	const struct mlxsw_sp_trap_item *trap_item;
 	int i;
 
-	for (i = 0; i < ARRAY_SIZE(mlxsw_sp_listener_devlink_map); i++) {
+	trap_item = mlxsw_sp_trap_item_lookup(mlxsw_sp, trap->id);
+	if (WARN_ON(!trap_item))
+		return -EINVAL;
+
+	for (i = 0; i < MLXSW_SP_TRAP_LISTENERS_MAX; i++) {
 		const struct mlxsw_listener *listener;
 		int err;
 
-		if (mlxsw_sp_listener_devlink_map[i] != trap->id)
+		listener = &trap_item->listeners_arr[i];
+		if (!mlxsw_sp_trap_listener_is_valid(listener))
 			continue;
-		listener = &mlxsw_sp_listeners_arr[i];
-
 		err = mlxsw_core_trap_register(mlxsw_core, listener, trap_ctx);
 		if (err)
 			return err;
@@ -615,15 +783,20 @@ int mlxsw_sp_trap_init(struct mlxsw_core *mlxsw_core,
 void mlxsw_sp_trap_fini(struct mlxsw_core *mlxsw_core,
 			const struct devlink_trap *trap, void *trap_ctx)
 {
+	struct mlxsw_sp *mlxsw_sp = mlxsw_core_driver_priv(mlxsw_core);
+	const struct mlxsw_sp_trap_item *trap_item;
 	int i;
 
-	for (i = 0; i < ARRAY_SIZE(mlxsw_sp_listener_devlink_map); i++) {
+	trap_item = mlxsw_sp_trap_item_lookup(mlxsw_sp, trap->id);
+	if (WARN_ON(!trap_item))
+		return;
+
+	for (i = MLXSW_SP_TRAP_LISTENERS_MAX - 1; i >= 0; i--) {
 		const struct mlxsw_listener *listener;
 
-		if (mlxsw_sp_listener_devlink_map[i] != trap->id)
+		listener = &trap_item->listeners_arr[i];
+		if (!mlxsw_sp_trap_listener_is_valid(listener))
 			continue;
-		listener = &mlxsw_sp_listeners_arr[i];
-
 		mlxsw_core_trap_unregister(mlxsw_core, listener, trap_ctx);
 	}
 }
@@ -632,16 +805,23 @@ int mlxsw_sp_trap_action_set(struct mlxsw_core *mlxsw_core,
 			     const struct devlink_trap *trap,
 			     enum devlink_trap_action action)
 {
+	struct mlxsw_sp *mlxsw_sp = mlxsw_core_driver_priv(mlxsw_core);
+	const struct mlxsw_sp_trap_item *trap_item;
 	int i;
 
-	for (i = 0; i < ARRAY_SIZE(mlxsw_sp_listener_devlink_map); i++) {
+	trap_item = mlxsw_sp_trap_item_lookup(mlxsw_sp, trap->id);
+	if (WARN_ON(!trap_item))
+		return -EINVAL;
+
+	for (i = 0; i < MLXSW_SP_TRAP_LISTENERS_MAX; i++) {
 		const struct mlxsw_listener *listener;
 		bool enabled;
 		int err;
 
-		if (mlxsw_sp_listener_devlink_map[i] != trap->id)
+		listener = &trap_item->listeners_arr[i];
+		if (!mlxsw_sp_trap_listener_is_valid(listener))
 			continue;
-		listener = &mlxsw_sp_listeners_arr[i];
+
 		switch (action) {
 		case DEVLINK_TRAP_ACTION_DROP:
 			enabled = false;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.h
index 1280f8bc617a..759146897b3a 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.h
@@ -14,6 +14,9 @@ struct mlxsw_sp_trap {
 	struct mlxsw_sp_trap_group_item *group_items_arr;
 	u64 groups_count; /* Number of registered groups */
 
+	struct mlxsw_sp_trap_item *trap_items_arr;
+	u64 traps_count; /* Number of registered traps */
+
 	u64 max_policers;
 	unsigned long policers_usage[]; /* Usage bitmap */
 };
-- 
2.26.2

