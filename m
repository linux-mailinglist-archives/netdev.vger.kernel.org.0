Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0C81F34DC
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 17:43:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389639AbfKGQn1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 11:43:27 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:59151 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389585AbfKGQn0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 11:43:26 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id BF80621470;
        Thu,  7 Nov 2019 11:43:24 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 07 Nov 2019 11:43:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=fxMKuI7vSe/HPRrDqDJbDQVdZ7Tj4s4Bgj7dFsShGhA=; b=XGNVqSqu
        uI7rDPsu4BvkwV6Bbqdk1MWOgFTOxrz51iAJgsNbMyv2oF2SMNS0NsPUyjweFauz
        Z7afwo0OGA3Ylt14JkY6jkF6p8jhvHmrnywhPgvIEmatM7z1v721UVK2YPYliwNm
        Om9o09Xs0o1AfRM6unaKVPaWgrHjI+QtDYWUcTI+i1Xs+gqRaLkxPU+x3dXI+56e
        qE3hoWhlV/huvDj2EHBPjpbB0T7gpKWEnCkIUhCnUW98FL861l0xk1bdbG2bf0ai
        4NntAdkV4mR+Yiaig641lWfRIj5j/PnMBpPNGYlZlv5LOAksSNDlVnTc/tdVG+ot
        StQ8B3byiT7OEQ==
X-ME-Sender: <xms:rEnEXYQiQ0UMvDw2DGwtRXhA28Pj9a0li8Vv9h0tbg2kbZNw43Tobg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudduledgleduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpeei
X-ME-Proxy: <xmx:rEnEXW0B-f9AGiKbhl76i21xIqQKvPyW0lJodx_r-Z9cGOWTvmiArA>
    <xmx:rEnEXYxeUcFZME0ke6qcOZqdNZnz3AO53FSvO1pFVuY7HzrOHp24mw>
    <xmx:rEnEXZtPgU6p8K4drIcKMgxXOrPnm8iBAtHJB6Pcam9lDtb7zUBtww>
    <xmx:rEnEXUcvw8PIZ375hdoVS_zIdM2_8IUf026qXwa_uov15xCsYkHJYg>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 25A538005C;
        Thu,  7 Nov 2019 11:43:23 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, amitc@mellanox.com,
        dsahern@gmail.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 08/12] mlxsw: Add specific trap for packets routed via invalid nexthops
Date:   Thu,  7 Nov 2019 18:42:16 +0200
Message-Id: <20191107164220.20526-9-idosch@idosch.org>
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

Currently, mlxsw does not differentiate between these two cases of
routes with invalid nexthops:

1. Nexthops whose nexthop device is a mlxsw upper (has a RIF), but whose
neighbour could not be resolved

2. Nexthops whose nexthop device is not a mlxsw upper (e.g., management
interface)

Up until now this did not matter and mlxsw trapped packets for both
cases using the same trap ID. However, packets that should have been
routed in hardware (case 1), but incurred a problem are considered
exceptions and should be reported to the user. The two cases should
therefore be split between two different trap IDs.

Allocate a new adjacency entry during initialization and upon the
insertion of the first route with an invalid mlxsw nexthop, program this
entry to discard packets. Packets hitting this entry will be reported
using new trap ID - "DISCARD_ROUTER3".

In the future, the entry could be written during initialization, but
currently firmware requires a valid RIF, which is not available at this
stage.

Signed-off-by: Amit Cohen <amitc@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |  2 ++
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 36 +++++++++++++++++++
 drivers/net/ethernet/mellanox/mlxsw/trap.h    |  1 +
 3 files changed, 39 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index f41d712a3958..34c507f2e39c 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -4526,6 +4526,8 @@ static const struct mlxsw_listener mlxsw_sp_listener[] = {
 	MLXSW_SP_RXL_MARK(IPV6_OSPF, TRAP_TO_CPU, OSPF, false),
 	MLXSW_SP_RXL_MARK(IPV6_DHCP, TRAP_TO_CPU, DHCP, false),
 	MLXSW_SP_RXL_MARK(RTR_INGRESS0, TRAP_TO_CPU, REMOTE_ROUTE, false),
+	MLXSW_SP_RXL_MARK(DISCARD_ROUTER3, TRAP_EXCEPTION_TO_CPU, REMOTE_ROUTE,
+			  false),
 	MLXSW_SP_RXL_MARK(IPV4_BGP, TRAP_TO_CPU, BGP, false),
 	MLXSW_SP_RXL_MARK(IPV6_BGP, TRAP_TO_CPU, BGP, false),
 	MLXSW_SP_RXL_MARK(L3_IPV6_ROUTER_SOLICITATION, TRAP_TO_CPU, IPV6_ND,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 39c573b39faf..1aa436054490 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -77,6 +77,7 @@ struct mlxsw_sp_router {
 	struct notifier_block inet6addr_nb;
 	const struct mlxsw_sp_rif_ops **rif_ops_arr;
 	const struct mlxsw_sp_ipip_ops **ipip_ops_arr;
+	u32 adj_discard_index;
 };
 
 struct mlxsw_sp_rif {
@@ -4197,15 +4198,31 @@ mlxsw_sp_fib_entry_ralue_pack(char *ralue_pl,
 	}
 }
 
+static int mlxsw_sp_adj_discard_write(struct mlxsw_sp *mlxsw_sp, u16 rif_index)
+{
+	u32 adj_discard_index = mlxsw_sp->router->adj_discard_index;
+	enum mlxsw_reg_ratr_trap_action trap_action;
+	char ratr_pl[MLXSW_REG_RATR_LEN];
+
+	trap_action = MLXSW_REG_RATR_TRAP_ACTION_DISCARD_ERRORS;
+	mlxsw_reg_ratr_pack(ratr_pl, MLXSW_REG_RATR_OP_WRITE_WRITE_ENTRY, true,
+			    MLXSW_REG_RATR_TYPE_ETHERNET, adj_discard_index,
+			    rif_index);
+	mlxsw_reg_ratr_trap_action_set(ratr_pl, trap_action);
+	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(ratr), ratr_pl);
+}
+
 static int mlxsw_sp_fib_entry_op_remote(struct mlxsw_sp *mlxsw_sp,
 					struct mlxsw_sp_fib_entry *fib_entry,
 					enum mlxsw_reg_ralue_op op)
 {
+	struct mlxsw_sp_nexthop_group *nh_group = fib_entry->nh_group;
 	char ralue_pl[MLXSW_REG_RALUE_LEN];
 	enum mlxsw_reg_ralue_trap_action trap_action;
 	u16 trap_id = 0;
 	u32 adjacency_index = 0;
 	u16 ecmp_size = 0;
+	int err;
 
 	/* In case the nexthop group adjacency index is valid, use it
 	 * with provided ECMP size. Otherwise, setup trap and pass
@@ -4215,6 +4232,15 @@ static int mlxsw_sp_fib_entry_op_remote(struct mlxsw_sp *mlxsw_sp,
 		trap_action = MLXSW_REG_RALUE_TRAP_ACTION_NOP;
 		adjacency_index = fib_entry->nh_group->adj_index;
 		ecmp_size = fib_entry->nh_group->ecmp_size;
+	} else if (!nh_group->adj_index_valid && nh_group->count &&
+		   nh_group->nh_rif) {
+		err = mlxsw_sp_adj_discard_write(mlxsw_sp,
+						 nh_group->nh_rif->rif_index);
+		if (err)
+			return err;
+		trap_action = MLXSW_REG_RALUE_TRAP_ACTION_NOP;
+		adjacency_index = mlxsw_sp->router->adj_discard_index;
+		ecmp_size = 1;
 	} else {
 		trap_action = MLXSW_REG_RALUE_TRAP_ACTION_TRAP;
 		trap_id = MLXSW_TRAP_ID_RTR_INGRESS0;
@@ -8144,6 +8170,11 @@ int mlxsw_sp_router_init(struct mlxsw_sp *mlxsw_sp,
 	if (err)
 		goto err_neigh_init;
 
+	err = mlxsw_sp_kvdl_alloc(mlxsw_sp, MLXSW_SP_KVDL_ENTRY_TYPE_ADJ, 1,
+				  &router->adj_discard_index);
+	if (err)
+		goto err_adj_discard_index_alloc;
+
 	mlxsw_sp->router->netevent_nb.notifier_call =
 		mlxsw_sp_router_netevent_event;
 	err = register_netevent_notifier(&mlxsw_sp->router->netevent_nb);
@@ -8172,6 +8203,9 @@ int mlxsw_sp_router_init(struct mlxsw_sp *mlxsw_sp,
 err_mp_hash_init:
 	unregister_netevent_notifier(&mlxsw_sp->router->netevent_nb);
 err_register_netevent_notifier:
+	mlxsw_sp_kvdl_free(mlxsw_sp, MLXSW_SP_KVDL_ENTRY_TYPE_ADJ, 1,
+			   router->adj_discard_index);
+err_adj_discard_index_alloc:
 	mlxsw_sp_neigh_fini(mlxsw_sp);
 err_neigh_init:
 	mlxsw_sp_vrs_fini(mlxsw_sp);
@@ -8203,6 +8237,8 @@ void mlxsw_sp_router_fini(struct mlxsw_sp *mlxsw_sp)
 	unregister_fib_notifier(mlxsw_sp_net(mlxsw_sp),
 				&mlxsw_sp->router->fib_nb);
 	unregister_netevent_notifier(&mlxsw_sp->router->netevent_nb);
+	mlxsw_sp_kvdl_free(mlxsw_sp, MLXSW_SP_KVDL_ENTRY_TYPE_ADJ, 1,
+			   mlxsw_sp->router->adj_discard_index);
 	mlxsw_sp_neigh_fini(mlxsw_sp);
 	mlxsw_sp_vrs_fini(mlxsw_sp);
 	mlxsw_sp_mr_fini(mlxsw_sp);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/trap.h b/drivers/net/ethernet/mellanox/mlxsw/trap.h
index b7d83c67491f..b84b7f07dce2 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/trap.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/trap.h
@@ -68,6 +68,7 @@ enum {
 	MLXSW_TRAP_ID_ROUTER_ALERT_IPV4 = 0xD6,
 	MLXSW_TRAP_ID_ROUTER_ALERT_IPV6 = 0xD7,
 	MLXSW_TRAP_ID_DISCARD_ROUTER2 = 0x130,
+	MLXSW_TRAP_ID_DISCARD_ROUTER3 = 0x131,
 	MLXSW_TRAP_ID_DISCARD_ING_PACKET_SMAC_MC = 0x140,
 	MLXSW_TRAP_ID_DISCARD_ING_SWITCH_VTAG_ALLOW = 0x148,
 	MLXSW_TRAP_ID_DISCARD_ING_SWITCH_VLAN = 0x149,
-- 
2.21.0

