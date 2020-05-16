Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE69B1D648F
	for <lists+netdev@lfdr.de>; Sun, 17 May 2020 00:43:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726831AbgEPWnk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 May 2020 18:43:40 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:38197 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726660AbgEPWnj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 May 2020 18:43:39 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id AE6C15C0095;
        Sat, 16 May 2020 18:43:37 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sat, 16 May 2020 18:43:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=T/f48AkDKzoRJSE52Zy6RvUhXZJ1Cxyv+IaZK9P7Rgs=; b=LEyeu/4d
        zHq7L5hvHG/doConLTaoKigxbfBKFppv9TDNbuNMBmp5N7ZyVcFE26CQC3gXT7BV
        gGcM+i65WqiyUvgDpGXUTrY6ny6uydVRGCe73tZ5egdNiT/lPEY6hIGRAW9X4Sr6
        /Y9XukoMdZN2beID6gXt/+u6Zl4wk5pEk6YWSBAielxsDH5oKd4IhYvNp5N5WhGi
        0bVln26+QhuxEM19GekrP6ZpoxcUI2pJLjwyrFSBk9X5WfQqw8slDnqOcxCxGGbx
        h0aqpa2AUbJfpLveZbj/PbgkrNdyUhRxHwbXhCwHhu9gdD1CRa5/8uWPwTB/p3du
        QvhY6qOKtICEjw==
X-ME-Sender: <xms:mWzAXhi1yz5kruUJNEXgP6QccHrvy0LpNiCfFZRk4VxrXJtumg_MuQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedruddtuddguddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeejledrudejiedrvdegrddutdej
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:mWzAXmDHhcvJJGX_PS0QmTc-gri9saGneM5F6MqH6UlMv-0Qq7gyaw>
    <xmx:mWzAXhF89tyQtvfoMLy3g5uTQ8j4kvjWdVeeFVcsu-scgcw8w5IoAg>
    <xmx:mWzAXmSF-eq80AW7ZlfgLrNxb11NYoostVAAWtCPZlV_FuZCNhCeNw>
    <xmx:mWzAXjpZzsKN-hhsS7SfswtQd5I_vh47Q51VDbZVUCMJbJR4XDkJAg>
Received: from splinter.mtl.com (bzq-79-176-24-107.red.bezeqint.net [79.176.24.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3EC1A306639E;
        Sat, 16 May 2020 18:43:36 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 2/6] mlxsw: spectrum_trap: Store all trap policer data in one array
Date:   Sun, 17 May 2020 01:43:06 +0300
Message-Id: <20200516224310.877237-3-idosch@idosch.org>
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

Instead of maintaining an array of policers and a linked list, only
maintain an array.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_trap.c   | 148 +++++++++++-------
 .../ethernet/mellanox/mlxsw/spectrum_trap.h   |   3 +-
 2 files changed, 89 insertions(+), 62 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
index 634e695b89fa..7b2ddc49a04d 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
@@ -13,9 +13,8 @@
 #include "spectrum_trap.h"
 
 struct mlxsw_sp_trap_policer_item {
+	struct devlink_trap_policer policer;
 	u16 hw_id;
-	u32 id;
-	struct list_head list; /* Member of policer_item_list */
 };
 
 /* All driver-specific traps must be documented in
@@ -182,8 +181,11 @@ static void mlxsw_sp_rx_exception_listener(struct sk_buff *skb, u8 local_port,
 			     1 << MLXSW_REG_QPCR_LOWEST_CBS)
 
 /* Ordered by policer identifier */
-static const struct devlink_trap_policer mlxsw_sp_trap_policers_arr[] = {
-	MLXSW_SP_TRAP_POLICER(1, 10 * 1024, 128),
+static const struct mlxsw_sp_trap_policer_item
+mlxsw_sp_trap_policer_items_arr[] = {
+	{
+		.policer = MLXSW_SP_TRAP_POLICER(1, 10 * 1024, 128),
+	},
 };
 
 static const struct devlink_trap_group mlxsw_sp_trap_groups_arr[] = {
@@ -319,12 +321,12 @@ static const u16 mlxsw_sp_listener_devlink_map[] = {
 static struct mlxsw_sp_trap_policer_item *
 mlxsw_sp_trap_policer_item_lookup(struct mlxsw_sp *mlxsw_sp, u32 id)
 {
-	struct mlxsw_sp_trap_policer_item *policer_item;
 	struct mlxsw_sp_trap *trap = mlxsw_sp->trap;
+	int i;
 
-	list_for_each_entry(policer_item, &trap->policer_item_list, list) {
-		if (policer_item->id == id)
-			return policer_item;
+	for (i = 0; i < trap->policers_count; i++) {
+		if (trap->policer_items_arr[i].policer.id == id)
+			return &trap->policer_items_arr[i];
 	}
 
 	return NULL;
@@ -352,72 +354,102 @@ static int mlxsw_sp_trap_dummy_group_init(struct mlxsw_sp *mlxsw_sp)
 	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(htgt), htgt_pl);
 }
 
-static int mlxsw_sp_trap_policers_init(struct mlxsw_sp *mlxsw_sp)
+static int mlxsw_sp_trap_policer_items_arr_init(struct mlxsw_sp *mlxsw_sp)
 {
-	struct devlink *devlink = priv_to_devlink(mlxsw_sp->core);
+	size_t elem_size = sizeof(struct mlxsw_sp_trap_policer_item);
+	u64 arr_size = ARRAY_SIZE(mlxsw_sp_trap_policer_items_arr);
 	struct mlxsw_sp_trap *trap = mlxsw_sp->trap;
 	u64 free_policers = 0;
-	u32 last_id = 0;
-	int err, i;
+	u32 last_id;
+	int i;
 
 	for_each_clear_bit(i, trap->policers_usage, trap->max_policers)
 		free_policers++;
 
-	if (ARRAY_SIZE(mlxsw_sp_trap_policers_arr) > free_policers) {
+	if (arr_size > free_policers) {
 		dev_err(mlxsw_sp->bus_info->dev, "Exceeded number of supported packet trap policers\n");
 		return -ENOBUFS;
 	}
 
-	trap->policers_arr = kcalloc(free_policers,
-				     sizeof(struct devlink_trap_policer),
-				     GFP_KERNEL);
-	if (!trap->policers_arr)
+	trap->policer_items_arr = kcalloc(free_policers, elem_size, GFP_KERNEL);
+	if (!trap->policer_items_arr)
 		return -ENOMEM;
 
 	trap->policers_count = free_policers;
 
-	for (i = 0; i < free_policers; i++) {
-		const struct devlink_trap_policer *policer;
-
-		if (i < ARRAY_SIZE(mlxsw_sp_trap_policers_arr)) {
-			policer = &mlxsw_sp_trap_policers_arr[i];
-			trap->policers_arr[i] = *policer;
-			last_id = policer->id;
-		} else {
-			/* Use parameters set for first policer and override
-			 * relevant ones.
-			 */
-			policer = &mlxsw_sp_trap_policers_arr[0];
-			trap->policers_arr[i] = *policer;
-			trap->policers_arr[i].id = ++last_id;
-			trap->policers_arr[i].init_rate = 1;
-			trap->policers_arr[i].init_burst = 16;
-		}
+	/* Initialize policer items array with pre-defined policers. */
+	memcpy(trap->policer_items_arr, mlxsw_sp_trap_policer_items_arr,
+	       elem_size * arr_size);
+
+	/* Initialize policer items array with the rest of the available
+	 * policers.
+	 */
+	last_id = mlxsw_sp_trap_policer_items_arr[arr_size - 1].policer.id;
+	for (i = arr_size; i < trap->policers_count; i++) {
+		const struct mlxsw_sp_trap_policer_item *policer_item;
+
+		/* Use parameters set for first policer and override
+		 * relevant ones.
+		 */
+		policer_item = &mlxsw_sp_trap_policer_items_arr[0];
+		trap->policer_items_arr[i] = *policer_item;
+		trap->policer_items_arr[i].policer.id = ++last_id;
+		trap->policer_items_arr[i].policer.init_rate = 1;
+		trap->policer_items_arr[i].policer.init_burst = 16;
 	}
 
-	INIT_LIST_HEAD(&trap->policer_item_list);
+	return 0;
+}
+
+static void mlxsw_sp_trap_policer_items_arr_fini(struct mlxsw_sp *mlxsw_sp)
+{
+	kfree(mlxsw_sp->trap->policer_items_arr);
+}
+
+static int mlxsw_sp_trap_policers_init(struct mlxsw_sp *mlxsw_sp)
+{
+	struct devlink *devlink = priv_to_devlink(mlxsw_sp->core);
+	const struct mlxsw_sp_trap_policer_item *policer_item;
+	struct mlxsw_sp_trap *trap = mlxsw_sp->trap;
+	int err, i;
 
-	err = devlink_trap_policers_register(devlink, trap->policers_arr,
-					     trap->policers_count);
+	err = mlxsw_sp_trap_policer_items_arr_init(mlxsw_sp);
 	if (err)
-		goto err_trap_policers_register;
+		return err;
+
+	for (i = 0; i < trap->policers_count; i++) {
+		policer_item = &trap->policer_items_arr[i];
+		err = devlink_trap_policers_register(devlink,
+						     &policer_item->policer, 1);
+		if (err)
+			goto err_trap_policer_register;
+	}
 
 	return 0;
 
-err_trap_policers_register:
-	kfree(trap->policers_arr);
+err_trap_policer_register:
+	for (i--; i >= 0; i--) {
+		policer_item = &trap->policer_items_arr[i];
+		devlink_trap_policers_unregister(devlink,
+						 &policer_item->policer, 1);
+	}
+	mlxsw_sp_trap_policer_items_arr_fini(mlxsw_sp);
 	return err;
 }
 
 static void mlxsw_sp_trap_policers_fini(struct mlxsw_sp *mlxsw_sp)
 {
 	struct devlink *devlink = priv_to_devlink(mlxsw_sp->core);
+	const struct mlxsw_sp_trap_policer_item *policer_item;
 	struct mlxsw_sp_trap *trap = mlxsw_sp->trap;
+	int i;
 
-	devlink_trap_policers_unregister(devlink, trap->policers_arr,
-					 trap->policers_count);
-	WARN_ON(!list_empty(&trap->policer_item_list));
-	kfree(trap->policers_arr);
+	for (i = trap->policers_count - 1; i >= 0; i--) {
+		policer_item = &trap->policer_items_arr[i];
+		devlink_trap_policers_unregister(devlink,
+						 &policer_item->policer, 1);
+	}
+	mlxsw_sp_trap_policer_items_arr_fini(mlxsw_sp);
 }
 
 int mlxsw_sp_devlink_traps_init(struct mlxsw_sp *mlxsw_sp)
@@ -608,10 +640,10 @@ int mlxsw_sp_trap_group_set(struct mlxsw_core *mlxsw_core,
 	return __mlxsw_sp_trap_group_init(mlxsw_core, group, policer_id);
 }
 
-static struct mlxsw_sp_trap_policer_item *
-mlxsw_sp_trap_policer_item_init(struct mlxsw_sp *mlxsw_sp, u32 id)
+static int
+mlxsw_sp_trap_policer_item_init(struct mlxsw_sp *mlxsw_sp,
+				struct mlxsw_sp_trap_policer_item *policer_item)
 {
-	struct mlxsw_sp_trap_policer_item *policer_item;
 	struct mlxsw_sp_trap *trap = mlxsw_sp->trap;
 	u16 hw_id;
 
@@ -621,27 +653,19 @@ mlxsw_sp_trap_policer_item_init(struct mlxsw_sp *mlxsw_sp, u32 id)
 	 */
 	hw_id = find_first_zero_bit(trap->policers_usage, trap->max_policers);
 	if (WARN_ON(hw_id == trap->max_policers))
-		return ERR_PTR(-ENOBUFS);
-
-	policer_item = kzalloc(sizeof(*policer_item), GFP_KERNEL);
-	if (!policer_item)
-		return ERR_PTR(-ENOMEM);
+		return -ENOBUFS;
 
 	__set_bit(hw_id, trap->policers_usage);
 	policer_item->hw_id = hw_id;
-	policer_item->id = id;
-	list_add_tail(&policer_item->list, &trap->policer_item_list);
 
-	return policer_item;
+	return 0;
 }
 
 static void
 mlxsw_sp_trap_policer_item_fini(struct mlxsw_sp *mlxsw_sp,
 				struct mlxsw_sp_trap_policer_item *policer_item)
 {
-	list_del(&policer_item->list);
 	__clear_bit(policer_item->hw_id, mlxsw_sp->trap->policers_usage);
-	kfree(policer_item);
 }
 
 static int mlxsw_sp_trap_policer_bs(u64 burst, u8 *p_burst_size,
@@ -684,9 +708,13 @@ int mlxsw_sp_trap_policer_init(struct mlxsw_core *mlxsw_core,
 	struct mlxsw_sp_trap_policer_item *policer_item;
 	int err;
 
-	policer_item = mlxsw_sp_trap_policer_item_init(mlxsw_sp, policer->id);
-	if (IS_ERR(policer_item))
-		return PTR_ERR(policer_item);
+	policer_item = mlxsw_sp_trap_policer_item_lookup(mlxsw_sp, policer->id);
+	if (WARN_ON(!policer_item))
+		return -EINVAL;
+
+	err = mlxsw_sp_trap_policer_item_init(mlxsw_sp, policer_item);
+	if (err)
+		return err;
 
 	err = __mlxsw_sp_trap_policer_set(mlxsw_sp, policer_item->hw_id,
 					  policer->init_rate,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.h
index 8a11a2b973f8..8be8482d82ac 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.h
@@ -8,9 +8,8 @@
 #include <net/devlink.h>
 
 struct mlxsw_sp_trap {
-	struct devlink_trap_policer *policers_arr; /* Registered policers */
+	struct mlxsw_sp_trap_policer_item *policer_items_arr;
 	u64 policers_count; /* Number of registered policers */
-	struct list_head policer_item_list;
 	u64 max_policers;
 	unsigned long policers_usage[]; /* Usage bitmap */
 };
-- 
2.26.2

