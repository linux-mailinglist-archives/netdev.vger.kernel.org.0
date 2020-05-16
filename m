Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 571991D6490
	for <lists+netdev@lfdr.de>; Sun, 17 May 2020 00:43:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726876AbgEPWnl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 May 2020 18:43:41 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:49123 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726803AbgEPWnk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 May 2020 18:43:40 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 1791C5C0079;
        Sat, 16 May 2020 18:43:39 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sat, 16 May 2020 18:43:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=qKO8cxPFnWXvwAlNUbzap9b1Mxi9ynbAEChZgWyNNJg=; b=IyzXtq/R
        JBXitQp5hqmJlH0G2QwKOju/iuK9WJPziU7xUb8Ts8BNbXpa5uLMbibdpWL7yq0L
        bdqSwvs4ne0RMq1/X1vygp2t3kPcIywPJuTvcNYG1piKqS1vCUBTRE8wcbFoEJPy
        Gq192YoeunPweoFVEwYqzj4CYQTUcqjsLp1W0RbSx707DHXBnQ5gOZSwGMnmoB+K
        bYDOS9t0d7D9nTAAjjVxQlAWZqO4ghx9vWIBITFfD9KW+Dmr47FciPDEiUm4ThFL
        y57Trmt1idyRzTgudPkII5y4JovGEpzYQHr1SNvnbKp6OxtqqRzB7m4rqJUPTfFF
        BQiyOIti56EPVg==
X-ME-Sender: <xms:mmzAXsul5HUda4CuWLNq3YKK83WBXgzJg7Tr8rV6DnpA0hjNMwqrTw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedruddtuddguddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeejledrudejiedrvdegrddutdej
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:mmzAXpcVachIosXmABNGdBr03q7G-V6_0d4rCQR7x_cazk0cFqYruw>
    <xmx:mmzAXnwzuI4PlONAOrTvs5GD6eHtTbtjlSVof5TxWharDp2vsBrjyQ>
    <xmx:mmzAXvO_4oXFlrqqRl2C13yM87UeeVLe7vd3hqdWPjHj4Z2baA5NFQ>
    <xmx:m2zAXqm26N2nzEfjQP-SrHIAs36ZORlL-Bi3Lr7fYCjSfjEc6hhSPg>
Received: from splinter.mtl.com (bzq-79-176-24-107.red.bezeqint.net [79.176.24.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id C2452306639E;
        Sat, 16 May 2020 18:43:37 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 3/6] mlxsw: spectrum_trap: Store all trap group data in one array
Date:   Sun, 17 May 2020 01:43:07 +0300
Message-Id: <20200516224310.877237-4-idosch@idosch.org>
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

Use one array to store all the information about all the trap groups
instead of hard coding it in code. This will be used in future patches
to disable certain functionality (e.g., policer binding) on a trap group
basis.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_trap.c   | 147 +++++++++++++-----
 .../ethernet/mellanox/mlxsw/spectrum_trap.h   |   4 +
 2 files changed, 110 insertions(+), 41 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
index 7b2ddc49a04d..f87135ee69ee 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
@@ -17,6 +17,13 @@ struct mlxsw_sp_trap_policer_item {
 	u16 hw_id;
 };
 
+struct mlxsw_sp_trap_group_item {
+	struct devlink_trap_group group;
+	u16 hw_group_id;
+	u8 priority;
+	u8 tc;
+};
+
 /* All driver-specific traps must be documented in
  * Documentation/networking/devlink/mlxsw.rst
  */
@@ -188,11 +195,31 @@ mlxsw_sp_trap_policer_items_arr[] = {
 	},
 };
 
-static const struct devlink_trap_group mlxsw_sp_trap_groups_arr[] = {
-	DEVLINK_TRAP_GROUP_GENERIC(L2_DROPS, 1),
-	DEVLINK_TRAP_GROUP_GENERIC(L3_DROPS, 1),
-	DEVLINK_TRAP_GROUP_GENERIC(TUNNEL_DROPS, 1),
-	DEVLINK_TRAP_GROUP_GENERIC(ACL_DROPS, 1),
+static const struct mlxsw_sp_trap_group_item mlxsw_sp_trap_group_items_arr[] = {
+	{
+		.group = DEVLINK_TRAP_GROUP_GENERIC(L2_DROPS, 1),
+		.hw_group_id = MLXSW_REG_HTGT_TRAP_GROUP_SP_L2_DISCARDS,
+		.priority = 0,
+		.tc = 1,
+	},
+	{
+		.group = DEVLINK_TRAP_GROUP_GENERIC(L3_DROPS, 1),
+		.hw_group_id = MLXSW_REG_HTGT_TRAP_GROUP_SP_L3_DISCARDS,
+		.priority = 0,
+		.tc = 1,
+	},
+	{
+		.group = DEVLINK_TRAP_GROUP_GENERIC(TUNNEL_DROPS, 1),
+		.hw_group_id = MLXSW_REG_HTGT_TRAP_GROUP_SP_TUNNEL_DISCARDS,
+		.priority = 0,
+		.tc = 1,
+	},
+	{
+		.group = DEVLINK_TRAP_GROUP_GENERIC(ACL_DROPS, 1),
+		.hw_group_id = MLXSW_REG_HTGT_TRAP_GROUP_SP_ACL_DISCARDS,
+		.priority = 0,
+		.tc = 1,
+	},
 };
 
 static const struct devlink_trap mlxsw_sp_traps_arr[] = {
@@ -332,6 +359,20 @@ mlxsw_sp_trap_policer_item_lookup(struct mlxsw_sp *mlxsw_sp, u32 id)
 	return NULL;
 }
 
+static struct mlxsw_sp_trap_group_item *
+mlxsw_sp_trap_group_item_lookup(struct mlxsw_sp *mlxsw_sp, u16 id)
+{
+	struct mlxsw_sp_trap *trap = mlxsw_sp->trap;
+	int i;
+
+	for (i = 0; i < trap->groups_count; i++) {
+		if (trap->group_items_arr[i].group.id == id)
+			return &trap->group_items_arr[i];
+	}
+
+	return NULL;
+}
+
 static int mlxsw_sp_trap_cpu_policers_set(struct mlxsw_sp *mlxsw_sp)
 {
 	char qpcr_pl[MLXSW_REG_QPCR_LEN];
@@ -452,9 +493,57 @@ static void mlxsw_sp_trap_policers_fini(struct mlxsw_sp *mlxsw_sp)
 	mlxsw_sp_trap_policer_items_arr_fini(mlxsw_sp);
 }
 
+static int mlxsw_sp_trap_groups_init(struct mlxsw_sp *mlxsw_sp)
+{
+	struct devlink *devlink = priv_to_devlink(mlxsw_sp->core);
+	const struct mlxsw_sp_trap_group_item *group_item;
+	struct mlxsw_sp_trap *trap = mlxsw_sp->trap;
+	int err, i;
+
+	trap->group_items_arr = kmemdup(mlxsw_sp_trap_group_items_arr,
+					sizeof(mlxsw_sp_trap_group_items_arr),
+					GFP_KERNEL);
+	if (!trap->group_items_arr)
+		return -ENOMEM;
+
+	trap->groups_count = ARRAY_SIZE(mlxsw_sp_trap_group_items_arr);
+
+	for (i = 0; i < trap->groups_count; i++) {
+		group_item = &trap->group_items_arr[i];
+		err = devlink_trap_groups_register(devlink, &group_item->group,
+						   1);
+		if (err)
+			goto err_trap_group_register;
+	}
+
+	return 0;
+
+err_trap_group_register:
+	for (i--; i >= 0; i--) {
+		group_item = &trap->group_items_arr[i];
+		devlink_trap_groups_unregister(devlink, &group_item->group, 1);
+	}
+	kfree(trap->group_items_arr);
+	return err;
+}
+
+static void mlxsw_sp_trap_groups_fini(struct mlxsw_sp *mlxsw_sp)
+{
+	struct devlink *devlink = priv_to_devlink(mlxsw_sp->core);
+	struct mlxsw_sp_trap *trap = mlxsw_sp->trap;
+	int i;
+
+	for (i = trap->groups_count - 1; i >= 0; i--) {
+		const struct mlxsw_sp_trap_group_item *group_item;
+
+		group_item = &trap->group_items_arr[i];
+		devlink_trap_groups_unregister(devlink, &group_item->group, 1);
+	}
+	kfree(trap->group_items_arr);
+}
+
 int mlxsw_sp_devlink_traps_init(struct mlxsw_sp *mlxsw_sp)
 {
-	size_t groups_count = ARRAY_SIZE(mlxsw_sp_trap_groups_arr);
 	struct devlink *devlink = priv_to_devlink(mlxsw_sp->core);
 	int err;
 
@@ -474,10 +563,9 @@ int mlxsw_sp_devlink_traps_init(struct mlxsw_sp *mlxsw_sp)
 	if (err)
 		return err;
 
-	err = devlink_trap_groups_register(devlink, mlxsw_sp_trap_groups_arr,
-					   groups_count);
+	err = mlxsw_sp_trap_groups_init(mlxsw_sp);
 	if (err)
-		goto err_trap_groups_register;
+		goto err_trap_groups_init;
 
 	err = devlink_traps_register(devlink, mlxsw_sp_traps_arr,
 				     ARRAY_SIZE(mlxsw_sp_traps_arr), mlxsw_sp);
@@ -487,22 +575,19 @@ int mlxsw_sp_devlink_traps_init(struct mlxsw_sp *mlxsw_sp)
 	return 0;
 
 err_traps_register:
-	devlink_trap_groups_unregister(devlink, mlxsw_sp_trap_groups_arr,
-				       groups_count);
-err_trap_groups_register:
+	mlxsw_sp_trap_groups_fini(mlxsw_sp);
+err_trap_groups_init:
 	mlxsw_sp_trap_policers_fini(mlxsw_sp);
 	return err;
 }
 
 void mlxsw_sp_devlink_traps_fini(struct mlxsw_sp *mlxsw_sp)
 {
-	size_t groups_count = ARRAY_SIZE(mlxsw_sp_trap_groups_arr);
 	struct devlink *devlink = priv_to_devlink(mlxsw_sp->core);
 
 	devlink_traps_unregister(devlink, mlxsw_sp_traps_arr,
 				 ARRAY_SIZE(mlxsw_sp_traps_arr));
-	devlink_trap_groups_unregister(devlink, mlxsw_sp_trap_groups_arr,
-				       groups_count);
+	mlxsw_sp_trap_groups_fini(mlxsw_sp);
 	mlxsw_sp_trap_policers_fini(mlxsw_sp);
 }
 
@@ -582,33 +667,12 @@ __mlxsw_sp_trap_group_init(struct mlxsw_core *mlxsw_core,
 {
 	struct mlxsw_sp *mlxsw_sp = mlxsw_core_driver_priv(mlxsw_core);
 	u16 hw_policer_id = MLXSW_REG_HTGT_INVALID_POLICER;
+	const struct mlxsw_sp_trap_group_item *group_item;
 	char htgt_pl[MLXSW_REG_HTGT_LEN];
-	u8 priority, tc, group_id;
-
-	switch (group->id) {
-	case DEVLINK_TRAP_GROUP_GENERIC_ID_L2_DROPS:
-		group_id = MLXSW_REG_HTGT_TRAP_GROUP_SP_L2_DISCARDS;
-		priority = 0;
-		tc = 1;
-		break;
-	case DEVLINK_TRAP_GROUP_GENERIC_ID_L3_DROPS:
-		group_id = MLXSW_REG_HTGT_TRAP_GROUP_SP_L3_DISCARDS;
-		priority = 0;
-		tc = 1;
-		break;
-	case DEVLINK_TRAP_GROUP_GENERIC_ID_TUNNEL_DROPS:
-		group_id = MLXSW_REG_HTGT_TRAP_GROUP_SP_TUNNEL_DISCARDS;
-		priority = 0;
-		tc = 1;
-		break;
-	case DEVLINK_TRAP_GROUP_GENERIC_ID_ACL_DROPS:
-		group_id = MLXSW_REG_HTGT_TRAP_GROUP_SP_ACL_DISCARDS;
-		priority = 0;
-		tc = 1;
-		break;
-	default:
+
+	group_item = mlxsw_sp_trap_group_item_lookup(mlxsw_sp, group->id);
+	if (WARN_ON(!group_item))
 		return -EINVAL;
-	}
 
 	if (policer_id) {
 		struct mlxsw_sp_trap_policer_item *policer_item;
@@ -620,7 +684,8 @@ __mlxsw_sp_trap_group_init(struct mlxsw_core *mlxsw_core,
 		hw_policer_id = policer_item->hw_id;
 	}
 
-	mlxsw_reg_htgt_pack(htgt_pl, group_id, hw_policer_id, priority, tc);
+	mlxsw_reg_htgt_pack(htgt_pl, group_item->hw_group_id, hw_policer_id,
+			    group_item->priority, group_item->tc);
 	return mlxsw_reg_write(mlxsw_core, MLXSW_REG(htgt), htgt_pl);
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.h
index 8be8482d82ac..1280f8bc617a 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.h
@@ -10,6 +10,10 @@
 struct mlxsw_sp_trap {
 	struct mlxsw_sp_trap_policer_item *policer_items_arr;
 	u64 policers_count; /* Number of registered policers */
+
+	struct mlxsw_sp_trap_group_item *group_items_arr;
+	u64 groups_count; /* Number of registered groups */
+
 	u64 max_policers;
 	unsigned long policers_usage[]; /* Usage bitmap */
 };
-- 
2.26.2

