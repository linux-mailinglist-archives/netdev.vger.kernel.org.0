Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79A441984B2
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 21:39:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728994AbgC3Tjj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 15:39:39 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:41033 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727406AbgC3Tjg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 15:39:36 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id C13B3580542;
        Mon, 30 Mar 2020 15:39:34 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 30 Mar 2020 15:39:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=vhWOO1u91gpQXJGLk8WCPBuscTxslg80c2dcLSCxKeg=; b=Y7u7Cg+p
        UGnRdhDpnQqB/tZxigT2n3PuZrBWr5/tt91mlbKhLJcLjUH7ab0gXvYXeCiuo9Jp
        uQEFsdyiYGDyvoectU+g4sOkcsuqMEx1nejvEyZYRZLS7r/6iic+qU9zRtSi0hIM
        9j5CZnMV5HNPIDhHsIh9QCyba2iDWWmFxEfjWWqOozhKMRdsnM1S5v2XXoNL4jMm
        OYh8VgD7PDsGjmARPKuhAtIP5pQnuXGNbMxb6JQ4ClE0JkAO1MtTfIhLt3msoKXN
        tV34vYvh0nyVUdzLt8AvkHD+N3QiyHdp9dy1HNyJIXcCuvgtAgoQvU/LRmo+sztV
        3a5qyMoTGMcAfg==
X-ME-Sender: <xms:9kqCXobW9QrU9jfpiaLUS4-VKuAN2tVX-dLoSV-ww4jjI6Q6-z5gdw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudeihedgudeflecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucfkphepjeelrddukedurddufedvrdduledunecuvehluhhsth
    gvrhfuihiivgepuddtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihgu
    ohhstghhrdhorhhg
X-ME-Proxy: <xmx:9kqCXvM5E5AmZR7xR6GwD2J-Ko_CqYmHV-WLk0cG04OSrFV5jVh6Cw>
    <xmx:9kqCXqQsIf_WOh3XNrvEs5-W50aUo_RSiDOx3VfOnd44flj7C5YjEw>
    <xmx:9kqCXl499stbBnGNYE7WDlj29AHaB-K3HuiS7eX_viYgSfS3lFoOkg>
    <xmx:9kqCXrtj2Ek632-ObgoJ5Sysr4RkFIK1t5nW_yDUY83-V5lyh-tvhg>
Received: from splinter.mtl.com (bzq-79-181-132-191.red.bezeqint.net [79.181.132.191])
        by mail.messagingengine.com (Postfix) with ESMTPA id A2E31306CA45;
        Mon, 30 Mar 2020 15:39:32 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        roopa@cumulusnetworks.com, nikolay@cumulusnetworks.com,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v3 13/15] mlxsw: spectrum_trap: Switch to use correct packet trap group
Date:   Mon, 30 Mar 2020 22:38:30 +0300
Message-Id: <20200330193832.2359876-14-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200330193832.2359876-1-idosch@idosch.org>
References: <20200330193832.2359876-1-idosch@idosch.org>
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

