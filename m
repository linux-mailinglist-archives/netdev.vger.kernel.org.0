Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A013B191A0F
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 20:35:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727956AbgCXTfB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 15:35:01 -0400
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:44507 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727088AbgCXTfB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 15:35:01 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id B2092580061;
        Tue, 24 Mar 2020 15:35:00 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 24 Mar 2020 15:35:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=5sHqle5rAeWwfr+g5tyK4qRzhpwu7AP0ZP+fNJVSaRs=; b=fSk7VaKj
        kdUPiDD3DfcPrOziLEaPD92pjb5Z4Azik3Ziyk8DRieEBwpYZswpP0BO7kE0UGm5
        3AxxiY+qXdtZo4X3I5bivbb10bX5I00NRTRIWO1SCBlT0ALZ32ICBTDiMQxMCVhP
        wvu55piRbEQkP0UBMjmDD8+zumz15HX++0YDl1imvlfg51ZP2XRGNg+K0UhOyBU8
        o3E8k+uBhNKnA94u/jg94V80756j/173nQ9+yqXpdxQ6oTx6Lis1kBOpUVusuqbG
        Iehxp+502jmsJfByr3chIYRbnR316SbxL5eV19nUVyMZYrmkeN5ai1QqlH/lvRtO
        HpSXzGFx3Xq+DQ==
X-ME-Sender: <xms:5GB6Xu8GfXzH2_z6XA8ac_UGAlO6DVd8RwAvgQy-O-kpjIqCF7vtVw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudehuddgleeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeejledrudektddrleegrddvvdehnecuvehluhhsthgvrh
    fuihiivgepgeenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgt
    hhdrohhrgh
X-ME-Proxy: <xmx:5GB6XtK-O05evr50vPBHpF39O2hD2VFBHc-Zxi_iCN2IgW7WAQ3RIw>
    <xmx:5GB6XrJy5QF_AiqYcQi8PBgQ5gEuvtj8wTej2Oq-yUubEN2SiUGL8A>
    <xmx:5GB6XqB2EL7NqJL0pftysjy7LX1S9p5vyhqk6Igv1smFZIZJHb0uKg>
    <xmx:5GB6Xgg1hPX7Tn2tPbxs_sdI7OYgt-1zVbqLMIjn_pZO-eONo8ajPA>
Received: from splinter.mtl.com (bzq-79-180-94-225.red.bezeqint.net [79.180.94.225])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2B92E3065B8B;
        Tue, 24 Mar 2020 15:34:56 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, kuba@kernel.org,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        roopa@cumulusnetworks.com, nikolay@cumulusnetworks.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 13/15] mlxsw: spectrum_trap: Switch to use correct packet trap group
Date:   Tue, 24 Mar 2020 21:32:48 +0200
Message-Id: <20200324193250.1322038-14-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200324193250.1322038-1-idosch@idosch.org>
References: <20200324193250.1322038-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Some packet traps are currently exposed to user space as being member of
"l3_drops" trap group, but internally they are member of a different
group.

Switch these traps to use the correct group so that they are all subject
to the same policer, as exposed to user space.

Set the trap priority of packets trapped due to loopback error during
routing to the lowest priority. Such packets are not routed again by the
kernel and therefore should not mask other traps (e.g., host miss) that
should be routed.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h     |  2 --
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |  9 ++++----
 .../ethernet/mellanox/mlxsw/spectrum_trap.c   | 23 ++++++++++---------
 3 files changed, 16 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index 192578632657..6af091840f3d 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -5537,12 +5537,10 @@ enum mlxsw_reg_htgt_trap_group {
 	MLXSW_REG_HTGT_TRAP_GROUP_SP_PIM,
 	MLXSW_REG_HTGT_TRAP_GROUP_SP_MULTICAST,
 	MLXSW_REG_HTGT_TRAP_GROUP_SP_ARP,
-	MLXSW_REG_HTGT_TRAP_GROUP_SP_HOST_MISS,
 	MLXSW_REG_HTGT_TRAP_GROUP_SP_ROUTER_EXP,
 	MLXSW_REG_HTGT_TRAP_GROUP_SP_REMOTE_ROUTE,
 	MLXSW_REG_HTGT_TRAP_GROUP_SP_IP2ME,
 	MLXSW_REG_HTGT_TRAP_GROUP_SP_DHCP,
-	MLXSW_REG_HTGT_TRAP_GROUP_SP_RPF,
 	MLXSW_REG_HTGT_TRAP_GROUP_SP_EVENT,
 	MLXSW_REG_HTGT_TRAP_GROUP_SP_IPV6_MLD,
 	MLXSW_REG_HTGT_TRAP_GROUP_SP_IPV6_ND,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index e8756c921b76..8e4f334695c0 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -4580,7 +4580,6 @@ static int mlxsw_sp_cpu_policers_set(struct mlxsw_core *mlxsw_core)
 		case MLXSW_REG_HTGT_TRAP_GROUP_SP_LLDP:
 		case MLXSW_REG_HTGT_TRAP_GROUP_SP_OSPF:
 		case MLXSW_REG_HTGT_TRAP_GROUP_SP_PIM:
-		case MLXSW_REG_HTGT_TRAP_GROUP_SP_RPF:
 		case MLXSW_REG_HTGT_TRAP_GROUP_SP_LBERROR:
 			rate = 128;
 			burst_size = 7;
@@ -4593,7 +4592,6 @@ static int mlxsw_sp_cpu_policers_set(struct mlxsw_core *mlxsw_core)
 		case MLXSW_REG_HTGT_TRAP_GROUP_SP_BGP:
 		case MLXSW_REG_HTGT_TRAP_GROUP_SP_ARP:
 		case MLXSW_REG_HTGT_TRAP_GROUP_SP_DHCP:
-		case MLXSW_REG_HTGT_TRAP_GROUP_SP_HOST_MISS:
 		case MLXSW_REG_HTGT_TRAP_GROUP_SP_ROUTER_EXP:
 		case MLXSW_REG_HTGT_TRAP_GROUP_SP_REMOTE_ROUTE:
 		case MLXSW_REG_HTGT_TRAP_GROUP_SP_IPV6_ND:
@@ -4674,19 +4672,20 @@ static int mlxsw_sp_trap_groups_set(struct mlxsw_core *mlxsw_core)
 			break;
 		case MLXSW_REG_HTGT_TRAP_GROUP_SP_ARP:
 		case MLXSW_REG_HTGT_TRAP_GROUP_SP_IPV6_ND:
-		case MLXSW_REG_HTGT_TRAP_GROUP_SP_RPF:
 		case MLXSW_REG_HTGT_TRAP_GROUP_SP_PTP1:
 			priority = 2;
 			tc = 2;
 			break;
-		case MLXSW_REG_HTGT_TRAP_GROUP_SP_HOST_MISS:
 		case MLXSW_REG_HTGT_TRAP_GROUP_SP_ROUTER_EXP:
 		case MLXSW_REG_HTGT_TRAP_GROUP_SP_REMOTE_ROUTE:
 		case MLXSW_REG_HTGT_TRAP_GROUP_SP_MULTICAST:
-		case MLXSW_REG_HTGT_TRAP_GROUP_SP_LBERROR:
 			priority = 1;
 			tc = 1;
 			break;
+		case MLXSW_REG_HTGT_TRAP_GROUP_SP_LBERROR:
+			priority = 0;
+			tc = 1;
+			break;
 		case MLXSW_REG_HTGT_TRAP_GROUP_SP_EVENT:
 			priority = MLXSW_REG_HTGT_DEFAULT_PRIORITY;
 			tc = MLXSW_REG_HTGT_DEFAULT_TC;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
index a603d11686f2..c1eac328607a 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
@@ -233,23 +233,24 @@ static const struct mlxsw_listener mlxsw_sp_listeners_arr[] = {
 	MLXSW_SP_RXL_DISCARD(ING_ROUTER_IPV4_SIP_BC, L3_DISCARDS),
 	MLXSW_SP_RXL_DISCARD(IPV6_MC_DIP_RESERVED_SCOPE, L3_DISCARDS),
 	MLXSW_SP_RXL_DISCARD(IPV6_MC_DIP_INTERFACE_LOCAL_SCOPE, L3_DISCARDS),
-	MLXSW_SP_RXL_EXCEPTION(MTUERROR, ROUTER_EXP, TRAP_TO_CPU),
-	MLXSW_SP_RXL_EXCEPTION(TTLERROR, ROUTER_EXP, TRAP_TO_CPU),
-	MLXSW_SP_RXL_EXCEPTION(RPF, RPF, TRAP_TO_CPU),
-	MLXSW_SP_RXL_EXCEPTION(RTR_INGRESS1, REMOTE_ROUTE, TRAP_TO_CPU),
-	MLXSW_SP_RXL_EXCEPTION(HOST_MISS_IPV4, HOST_MISS, TRAP_TO_CPU),
-	MLXSW_SP_RXL_EXCEPTION(HOST_MISS_IPV6, HOST_MISS, TRAP_TO_CPU),
-	MLXSW_SP_RXL_EXCEPTION(DISCARD_ROUTER3, REMOTE_ROUTE,
+	MLXSW_SP_RXL_EXCEPTION(MTUERROR, L3_DISCARDS, TRAP_TO_CPU),
+	MLXSW_SP_RXL_EXCEPTION(TTLERROR, L3_DISCARDS, TRAP_TO_CPU),
+	MLXSW_SP_RXL_EXCEPTION(RPF, L3_DISCARDS, TRAP_TO_CPU),
+	MLXSW_SP_RXL_EXCEPTION(RTR_INGRESS1, L3_DISCARDS, TRAP_TO_CPU),
+	MLXSW_SP_RXL_EXCEPTION(HOST_MISS_IPV4, L3_DISCARDS, TRAP_TO_CPU),
+	MLXSW_SP_RXL_EXCEPTION(HOST_MISS_IPV6, L3_DISCARDS, TRAP_TO_CPU),
+	MLXSW_SP_RXL_EXCEPTION(DISCARD_ROUTER3, L3_DISCARDS,
 			       TRAP_EXCEPTION_TO_CPU),
-	MLXSW_SP_RXL_EXCEPTION(DISCARD_ROUTER_LPM4, ROUTER_EXP,
+	MLXSW_SP_RXL_EXCEPTION(DISCARD_ROUTER_LPM4, L3_DISCARDS,
 			       TRAP_EXCEPTION_TO_CPU),
-	MLXSW_SP_RXL_EXCEPTION(DISCARD_ROUTER_LPM6, ROUTER_EXP,
+	MLXSW_SP_RXL_EXCEPTION(DISCARD_ROUTER_LPM6, L3_DISCARDS,
 			       TRAP_EXCEPTION_TO_CPU),
 	MLXSW_SP_RXL_DISCARD(ROUTER_IRIF_EN, L3_DISCARDS),
 	MLXSW_SP_RXL_DISCARD(ROUTER_ERIF_EN, L3_DISCARDS),
 	MLXSW_SP_RXL_DISCARD(NON_ROUTABLE, L3_DISCARDS),
-	MLXSW_SP_RXL_EXCEPTION(DECAP_ECN0, ROUTER_EXP, TRAP_EXCEPTION_TO_CPU),
-	MLXSW_SP_RXL_EXCEPTION(IPIP_DECAP_ERROR, ROUTER_EXP,
+	MLXSW_SP_RXL_EXCEPTION(DECAP_ECN0, TUNNEL_DISCARDS,
+			       TRAP_EXCEPTION_TO_CPU),
+	MLXSW_SP_RXL_EXCEPTION(IPIP_DECAP_ERROR, TUNNEL_DISCARDS,
 			       TRAP_EXCEPTION_TO_CPU),
 	MLXSW_SP_RXL_EXCEPTION(DISCARD_DEC_PKT, TUNNEL_DISCARDS,
 			       TRAP_EXCEPTION_TO_CPU),
-- 
2.24.1

