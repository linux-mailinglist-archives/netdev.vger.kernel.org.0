Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C21D23AA46
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 18:13:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728412AbgHCQMp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 12:12:45 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:49761 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725945AbgHCQMo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 12:12:44 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id B22075C018A;
        Mon,  3 Aug 2020 12:12:42 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 03 Aug 2020 12:12:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=0ot7Td8whppPgKJRJLQVFLuWstMjs2AlzTHUzaboad4=; b=BILTJ480
        zzPG1GnHhKB3ntEMv4SOMdATW0pRiRLLuyLCmr2V/6Lo4Py9HGPZOEejwyl4YjN4
        KFzYmmWYFvOdtwJrLhk3424krm7Cv4Er/EA4XF7Z1mPafSEQiLDcZvFSfSyamqsy
        RJvolHuFa+t6HS1szlrKZ2wcL/Q0FgPyZx4VggBQzaY5LSLf0RI7COHkVE8c/svw
        I3JdA38kYHU67YER68iZKWh40534J1vBEubrJjeCobsDT1XjhkUUD3eomXUrcimq
        Akb+QglzpQgujZ9gHVrZe0LrdTmB6+gJdSUo/MY2Smv3jIJBXAVv6dR4eEKxvdDu
        4rEMaVjAPBooGw==
X-ME-Sender: <xms:ejcoX-mfRYZTIaIqQuff5NTcUE2nsym-3hr71-yFKFStmfj_chVcGg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrjeeggdelkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucfkphepjeelrddukedurdeirddvudelnecu
    vehluhhsthgvrhfuihiivgepfeenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstg
    hhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:ejcoX12IEnrh9rca_ssObwyzO4oY3jjkTTbTNcTS308LPO5MJdE5Ow>
    <xmx:ejcoX8r1g_O5PZJobdNpNFIVQNqlVcDOs0PnPINdjI6celUm6ZS_9w>
    <xmx:ejcoXymPHkWcOf0bSydkAsbgy5e-e18K_HkmlhmBkNksYD6evDfYSg>
    <xmx:ejcoX5w1FI8EUHV759hkW9lbxb_5VaB4wK0B9GFVTMg6YCr9fmjdLA>
Received: from shredder.mtl.com (bzq-79-181-6-219.red.bezeqint.net [79.181.6.219])
        by mail.messagingengine.com (Postfix) with ESMTPA id 544C4306005F;
        Mon,  3 Aug 2020 12:12:40 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        petrm@mellanox.com, amitc@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 5/9] mlxsw: spectrum_trap: Allow for per-ASIC trap groups initialization
Date:   Mon,  3 Aug 2020 19:11:37 +0300
Message-Id: <20200803161141.2523857-6-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200803161141.2523857-1-idosch@idosch.org>
References: <20200803161141.2523857-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Subsequent patches will need to register different trap groups for
Spectrum-1 and Spectrum-2 onwards.

Enable that by invoking a per-ASIC operation during trap groups
initialization.

Reviewed-by: Petr Machata <petrm@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Petr Machata <petrm@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |  3 +
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |  1 +
 .../ethernet/mellanox/mlxsw/spectrum_trap.c   | 89 +++++++++++++++++--
 .../ethernet/mellanox/mlxsw/spectrum_trap.h   |  9 ++
 4 files changed, 93 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 519eb44e4097..fdf9aa8314b2 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -3055,6 +3055,7 @@ static int mlxsw_sp1_init(struct mlxsw_core *mlxsw_core,
 	mlxsw_sp->ptp_ops = &mlxsw_sp1_ptp_ops;
 	mlxsw_sp->span_ops = &mlxsw_sp1_span_ops;
 	mlxsw_sp->policer_core_ops = &mlxsw_sp1_policer_core_ops;
+	mlxsw_sp->trap_ops = &mlxsw_sp1_trap_ops;
 	mlxsw_sp->listeners = mlxsw_sp1_listener;
 	mlxsw_sp->listeners_count = ARRAY_SIZE(mlxsw_sp1_listener);
 	mlxsw_sp->lowest_shaper_bs = MLXSW_REG_QEEC_LOWEST_SHAPER_BS_SP1;
@@ -3084,6 +3085,7 @@ static int mlxsw_sp2_init(struct mlxsw_core *mlxsw_core,
 	mlxsw_sp->ptp_ops = &mlxsw_sp2_ptp_ops;
 	mlxsw_sp->span_ops = &mlxsw_sp2_span_ops;
 	mlxsw_sp->policer_core_ops = &mlxsw_sp2_policer_core_ops;
+	mlxsw_sp->trap_ops = &mlxsw_sp2_trap_ops;
 	mlxsw_sp->lowest_shaper_bs = MLXSW_REG_QEEC_LOWEST_SHAPER_BS_SP2;
 
 	return mlxsw_sp_init(mlxsw_core, mlxsw_bus_info, extack);
@@ -3111,6 +3113,7 @@ static int mlxsw_sp3_init(struct mlxsw_core *mlxsw_core,
 	mlxsw_sp->ptp_ops = &mlxsw_sp2_ptp_ops;
 	mlxsw_sp->span_ops = &mlxsw_sp3_span_ops;
 	mlxsw_sp->policer_core_ops = &mlxsw_sp2_policer_core_ops;
+	mlxsw_sp->trap_ops = &mlxsw_sp2_trap_ops;
 	mlxsw_sp->lowest_shaper_bs = MLXSW_REG_QEEC_LOWEST_SHAPER_BS_SP3;
 
 	return mlxsw_sp_init(mlxsw_core, mlxsw_bus_info, extack);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index 866a1193f12b..b808f6b4d670 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -177,6 +177,7 @@ struct mlxsw_sp {
 	const struct mlxsw_sp_ptp_ops *ptp_ops;
 	const struct mlxsw_sp_span_ops *span_ops;
 	const struct mlxsw_sp_policer_core_ops *policer_core_ops;
+	const struct mlxsw_sp_trap_ops *trap_ops;
 	const struct mlxsw_listener *listeners;
 	size_t listeners_count;
 	u32 lowest_shaper_bs;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
index 47bc11a861cc..3726be5c02b4 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
@@ -1159,6 +1159,43 @@ static void mlxsw_sp_trap_policers_fini(struct mlxsw_sp *mlxsw_sp)
 	mlxsw_sp_trap_policer_items_arr_fini(mlxsw_sp);
 }
 
+static int mlxsw_sp_trap_group_items_arr_init(struct mlxsw_sp *mlxsw_sp)
+{
+	size_t common_groups_count = ARRAY_SIZE(mlxsw_sp_trap_group_items_arr);
+	const struct mlxsw_sp_trap_group_item *spec_group_items_arr;
+	size_t elem_size = sizeof(struct mlxsw_sp_trap_group_item);
+	struct mlxsw_sp_trap *trap = mlxsw_sp->trap;
+	size_t groups_count, spec_groups_count;
+	int err;
+
+	err = mlxsw_sp->trap_ops->groups_init(mlxsw_sp, &spec_group_items_arr,
+					      &spec_groups_count);
+	if (err)
+		return err;
+
+	/* The group items array is created by concatenating the common trap
+	 * group items and the ASIC-specific trap group items.
+	 */
+	groups_count = common_groups_count + spec_groups_count;
+	trap->group_items_arr = kcalloc(groups_count, elem_size, GFP_KERNEL);
+	if (!trap->group_items_arr)
+		return -ENOMEM;
+
+	memcpy(trap->group_items_arr, mlxsw_sp_trap_group_items_arr,
+	       elem_size * common_groups_count);
+	memcpy(trap->group_items_arr + common_groups_count,
+	       spec_group_items_arr, elem_size * spec_groups_count);
+
+	trap->groups_count = groups_count;
+
+	return 0;
+}
+
+static void mlxsw_sp_trap_group_items_arr_fini(struct mlxsw_sp *mlxsw_sp)
+{
+	kfree(mlxsw_sp->trap->group_items_arr);
+}
+
 static int mlxsw_sp_trap_groups_init(struct mlxsw_sp *mlxsw_sp)
 {
 	struct devlink *devlink = priv_to_devlink(mlxsw_sp->core);
@@ -1166,13 +1203,9 @@ static int mlxsw_sp_trap_groups_init(struct mlxsw_sp *mlxsw_sp)
 	struct mlxsw_sp_trap *trap = mlxsw_sp->trap;
 	int err, i;
 
-	trap->group_items_arr = kmemdup(mlxsw_sp_trap_group_items_arr,
-					sizeof(mlxsw_sp_trap_group_items_arr),
-					GFP_KERNEL);
-	if (!trap->group_items_arr)
-		return -ENOMEM;
-
-	trap->groups_count = ARRAY_SIZE(mlxsw_sp_trap_group_items_arr);
+	err = mlxsw_sp_trap_group_items_arr_init(mlxsw_sp);
+	if (err)
+		return err;
 
 	for (i = 0; i < trap->groups_count; i++) {
 		group_item = &trap->group_items_arr[i];
@@ -1189,7 +1222,7 @@ static int mlxsw_sp_trap_groups_init(struct mlxsw_sp *mlxsw_sp)
 		group_item = &trap->group_items_arr[i];
 		devlink_trap_groups_unregister(devlink, &group_item->group, 1);
 	}
-	kfree(trap->group_items_arr);
+	mlxsw_sp_trap_group_items_arr_fini(mlxsw_sp);
 	return err;
 }
 
@@ -1205,7 +1238,7 @@ static void mlxsw_sp_trap_groups_fini(struct mlxsw_sp *mlxsw_sp)
 		group_item = &trap->group_items_arr[i];
 		devlink_trap_groups_unregister(devlink, &group_item->group, 1);
 	}
-	kfree(trap->group_items_arr);
+	mlxsw_sp_trap_group_items_arr_fini(mlxsw_sp);
 }
 
 static bool
@@ -1579,3 +1612,41 @@ mlxsw_sp_trap_policer_counter_get(struct mlxsw_core *mlxsw_core,
 
 	return 0;
 }
+
+static const struct mlxsw_sp_trap_group_item
+mlxsw_sp1_trap_group_items_arr[] = {
+};
+
+static int
+mlxsw_sp1_trap_groups_init(struct mlxsw_sp *mlxsw_sp,
+			   const struct mlxsw_sp_trap_group_item **arr,
+			   size_t *p_groups_count)
+{
+	*arr = mlxsw_sp1_trap_group_items_arr;
+	*p_groups_count = ARRAY_SIZE(mlxsw_sp1_trap_group_items_arr);
+
+	return 0;
+}
+
+const struct mlxsw_sp_trap_ops mlxsw_sp1_trap_ops = {
+	.groups_init = mlxsw_sp1_trap_groups_init,
+};
+
+static const struct mlxsw_sp_trap_group_item
+mlxsw_sp2_trap_group_items_arr[] = {
+};
+
+static int
+mlxsw_sp2_trap_groups_init(struct mlxsw_sp *mlxsw_sp,
+			   const struct mlxsw_sp_trap_group_item **arr,
+			   size_t *p_groups_count)
+{
+	*arr = mlxsw_sp2_trap_group_items_arr;
+	*p_groups_count = ARRAY_SIZE(mlxsw_sp2_trap_group_items_arr);
+
+	return 0;
+}
+
+const struct mlxsw_sp_trap_ops mlxsw_sp2_trap_ops = {
+	.groups_init = mlxsw_sp2_trap_groups_init,
+};
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.h
index a0560fb030ee..4ae5212b9a48 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.h
@@ -23,4 +23,13 @@ struct mlxsw_sp_trap {
 	unsigned long policers_usage[]; /* Usage bitmap */
 };
 
+struct mlxsw_sp_trap_ops {
+	int (*groups_init)(struct mlxsw_sp *mlxsw_sp,
+			   const struct mlxsw_sp_trap_group_item **arr,
+			   size_t *p_groups_count);
+};
+
+extern const struct mlxsw_sp_trap_ops mlxsw_sp1_trap_ops;
+extern const struct mlxsw_sp_trap_ops mlxsw_sp2_trap_ops;
+
 #endif
-- 
2.26.2

