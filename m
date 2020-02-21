Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 158D81685A6
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 18:54:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729258AbgBURyv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 12:54:51 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:52623 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726955AbgBURyt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Feb 2020 12:54:49 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 7756721E50;
        Fri, 21 Feb 2020 12:54:48 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Fri, 21 Feb 2020 12:54:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=InkvFz7I6BqERTGjHbOoFHRB73kffaixxM51lCmVIiA=; b=kdSTmpIH
        3ZZPjuCx4CAVP3dcb4BTvyVRmsiAKUdBriTu1awljf+QbN4+X4C+GN1i9DGjjyoK
        0iUYgG5wGBLFB9w4/42qvJlaFOhMIGUDnRUzoarioj/dzlaa79PPCW15Ciu2wEtS
        H8qkwWvinLri62XjkHflofEGRR2PAQv2zqa0wP31fBPFF+g1IyezP4zdGAYM6I/w
        z3xllBix4Y7PRjuSMiiugGzT98kssv2mDprmFqNwkEUIb1C5hklc5jZ2pigHmML+
        Ty3Q+7AeuHgvP3jCZUh2bdoCBU4Jb2LQZPmj9HPGvQG3qEd/uqSX0cfEdoSoHkrG
        pARoc6WWwV8bUg==
X-ME-Sender: <xms:aBlQXpoFWr51SEiX2rcD6qqVpqysJnPNwQIys9_VqD2cjjrx2VRd8Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrkeeggddutdeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppedutdelrdeiiedruddvrdehvdenucevlhhushhtvghruf
    hiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghh
    rdhorhhg
X-ME-Proxy: <xmx:aBlQXuu_ydNat8uhyQWcs9DrZDtNKlhj4de-i1oBrDwe8CnnWRsang>
    <xmx:aBlQXg2xFYKVc7OThRbm945lr53XbqFX5jiWOkYcr2YyUJDZinVKnQ>
    <xmx:aBlQXhGITDfTLdyAIhkeWtoR-qsUIq-FdzRCoI2JFy8Sqg5V3nmMig>
    <xmx:aBlQXvy3n5oh4QN091F54p0RjTf8pbfKAS3OWkrlTeH35w8G8AdaVw>
Received: from localhost.localdomain (bzq-109-66-12-52.red.bezeqint.net [109.66.12.52])
        by mail.messagingengine.com (Postfix) with ESMTPA id EC91A3060BD1;
        Fri, 21 Feb 2020 12:54:46 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 04/12] mlxsw: spectrum_router: Expose router struct to internal users
Date:   Fri, 21 Feb 2020 19:54:07 +0200
Message-Id: <20200221175415.390884-5-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200221175415.390884-1-idosch@idosch.org>
References: <20200221175415.390884-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

The dpipe code accesses internal router data structures and acquires
RTNL to protect against their changes. Subsequent patches will remove
reliance on RTNL and introduce a dedicated lock to protect router data
structures.

Publish the router struct to internal users such as the dpipe, so that
they could acquire it instead of RTNL.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 33 -------------------
 .../ethernet/mellanox/mlxsw/spectrum_router.h | 33 +++++++++++++++++++
 2 files changed, 33 insertions(+), 33 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 634a9a949777..991095f66fc2 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -48,39 +48,6 @@ struct mlxsw_sp_vr;
 struct mlxsw_sp_lpm_tree;
 struct mlxsw_sp_rif_ops;
 
-struct mlxsw_sp_router {
-	struct mlxsw_sp *mlxsw_sp;
-	struct mlxsw_sp_rif **rifs;
-	struct mlxsw_sp_vr *vrs;
-	struct rhashtable neigh_ht;
-	struct rhashtable nexthop_group_ht;
-	struct rhashtable nexthop_ht;
-	struct list_head nexthop_list;
-	struct {
-		/* One tree for each protocol: IPv4 and IPv6 */
-		struct mlxsw_sp_lpm_tree *proto_trees[2];
-		struct mlxsw_sp_lpm_tree *trees;
-		unsigned int tree_count;
-	} lpm;
-	struct {
-		struct delayed_work dw;
-		unsigned long interval;	/* ms */
-	} neighs_update;
-	struct delayed_work nexthop_probe_dw;
-#define MLXSW_SP_UNRESOLVED_NH_PROBE_INTERVAL 5000 /* ms */
-	struct list_head nexthop_neighs_list;
-	struct list_head ipip_list;
-	bool aborted;
-	struct notifier_block fib_nb;
-	struct notifier_block netevent_nb;
-	struct notifier_block inetaddr_nb;
-	struct notifier_block inet6addr_nb;
-	const struct mlxsw_sp_rif_ops **rif_ops_arr;
-	const struct mlxsw_sp_ipip_ops **ipip_ops_arr;
-	u32 adj_discard_index;
-	bool adj_discard_index_valid;
-};
-
 struct mlxsw_sp_rif {
 	struct list_head nexthop_list;
 	struct list_head neigh_list;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
index c9b94f435cdd..b2554727d8ee 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
@@ -7,6 +7,39 @@
 #include "spectrum.h"
 #include "reg.h"
 
+struct mlxsw_sp_router {
+	struct mlxsw_sp *mlxsw_sp;
+	struct mlxsw_sp_rif **rifs;
+	struct mlxsw_sp_vr *vrs;
+	struct rhashtable neigh_ht;
+	struct rhashtable nexthop_group_ht;
+	struct rhashtable nexthop_ht;
+	struct list_head nexthop_list;
+	struct {
+		/* One tree for each protocol: IPv4 and IPv6 */
+		struct mlxsw_sp_lpm_tree *proto_trees[2];
+		struct mlxsw_sp_lpm_tree *trees;
+		unsigned int tree_count;
+	} lpm;
+	struct {
+		struct delayed_work dw;
+		unsigned long interval;	/* ms */
+	} neighs_update;
+	struct delayed_work nexthop_probe_dw;
+#define MLXSW_SP_UNRESOLVED_NH_PROBE_INTERVAL 5000 /* ms */
+	struct list_head nexthop_neighs_list;
+	struct list_head ipip_list;
+	bool aborted;
+	struct notifier_block fib_nb;
+	struct notifier_block netevent_nb;
+	struct notifier_block inetaddr_nb;
+	struct notifier_block inet6addr_nb;
+	const struct mlxsw_sp_rif_ops **rif_ops_arr;
+	const struct mlxsw_sp_ipip_ops **ipip_ops_arr;
+	u32 adj_discard_index;
+	bool adj_discard_index_valid;
+};
+
 struct mlxsw_sp_rif_ipip_lb;
 struct mlxsw_sp_rif_ipip_lb_config {
 	enum mlxsw_reg_ritr_loopback_ipip_type lb_ipipt;
-- 
2.24.1

