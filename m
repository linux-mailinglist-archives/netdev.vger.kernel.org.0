Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 869A8196F3D
	for <lists+netdev@lfdr.de>; Sun, 29 Mar 2020 20:22:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728619AbgC2SWe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Mar 2020 14:22:34 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:48531 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728467AbgC2SWe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Mar 2020 14:22:34 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 6814F580907;
        Sun, 29 Mar 2020 14:22:33 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 29 Mar 2020 14:22:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=vhWOO1u91gpQXJGLk8WCPBuscTxslg80c2dcLSCxKeg=; b=ND/EMqt6
        DlpgG0I8ytu2HPlgZWMKbb4VbelHmXw/A9X8wAAAd4Yz785MXjQ0LubQlhGSPg5w
        JqfJFCx+G6y9229ELdtpabDyk25DVPQAcqtYT3rUHUJQ/EFNafPZEIM8csevsiMS
        ejcpsME8CVKqMQlJgFykmuREHRdRMwJz2BJCytkeYl4X6UR8W3wQecYKIskqA0AQ
        TTrZr9nDjGRoG3xj/dDug2PcnthB2IcgzEJv75LCeQtHPJSwo+POMq/5rLSP6gCj
        Iw3ZyUHpJAzuTTjlCXdVy4a53QXvFCoasv3jkMZUeIvN+JDZtw76TKFEVJq1W6sr
        7k1WLX0ObR9spw==
X-ME-Sender: <xms:aeeAXndTodLKEdR0mONn0vWH0BAJ3WNS2SRfBKDw7aJSBR-j5bFmqw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudeifedguddviecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucfkphepjeelrddukedurddufedvrdduledunecuvehluhhsth
    gvrhfuihiivgepuddunecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihgu
    ohhstghhrdhorhhg
X-ME-Proxy: <xmx:aeeAXtamike7eT86aEIzgXHHl1PhBCDAPSrWGmR9ThTqeZDAjM9sHg>
    <xmx:aeeAXu1bpAaL_kpLVBwpxb1QH8S3acWnv9W6fGOsTgjzcpLiGlFmEg>
    <xmx:aeeAXmth6OJVhCJJgZM-fbpv24dY3qHStJdCo8-72uZfZhphq3hl_w>
    <xmx:aeeAXmWnMTbGzn-dDjdIMSsdbAekZIWSA4VPJrzzCPhQOwXKMqn-yA>
Received: from splinter.mtl.com (bzq-79-181-132-191.red.bezeqint.net [79.181.132.191])
        by mail.messagingengine.com (Postfix) with ESMTPA id D46C43280059;
        Sun, 29 Mar 2020 14:22:30 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        roopa@cumulusnetworks.com, nikolay@cumulusnetworks.com,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 13/15] mlxsw: spectrum_trap: Switch to use correct packet trap group
Date:   Sun, 29 Mar 2020 21:21:17 +0300
Message-Id: <20200329182119.2207630-14-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200329182119.2207630-1-idosch@idosch.org>
References: <20200329182119.2207630-1-idosch@idosch.org>
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
index 2cfc268fb8bb..9b39b8e70519 100644
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
index 579f1164ad5d..4a919121191f 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
@@ -240,23 +240,24 @@ static const struct mlxsw_listener mlxsw_sp_listeners_arr[] = {
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

