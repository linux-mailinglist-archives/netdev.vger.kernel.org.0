Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9967A23AA47
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 18:13:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728416AbgHCQMq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 12:12:46 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:34759 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728360AbgHCQMp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 12:12:45 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id B12E75C00D2;
        Mon,  3 Aug 2020 12:12:44 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 03 Aug 2020 12:12:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=Z8YKAGWj36OwkqezEy0+06+y+wNKXyWqOJcpE6ihysY=; b=cfnbRYyK
        QHu9H5nL+ZbbfGtqXfTHXJmHR+zmEfCtppcaMW0xL6CbvwhTztgVcqb5XqE8l9B2
        ljdBaQSTPIjn2zoyMxhgu2OsfHGYPKIBaSGFklZEOzEEf7yBsQdFuIpQtptdGX4Q
        WtkOU6dv8uKHBasauvuFGqUttu/ow70qn2s/NsATxgMyoE5WdhK/9QCnMrs8ATWU
        ICwyuWbk/BoVOa1FY9cqKjdCICnblf08V1VTfOynKl0nOr39O+SVclzSmsDAuTw7
        QcMvSyskj6n5t7VDwnMNtYMS3RGPEaNkmbQe95SqTA3T9h9s3OBybZBBwiU8o6Aj
        sT4EVJNO4pzhVQ==
X-ME-Sender: <xms:fDcoXz95bx3DJAiZLcVesb6K1yQGTOsOCSNFIXJKNksKbd7aOnXBRw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrjeeggdelkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucfkphepjeelrddukedurdeirddvudelnecu
    vehluhhsthgvrhfuihiivgepheenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstg
    hhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:fDcoX_tVb19dEgAkGJMYuvPAD1sjW9N_shLlHy9NkRxjCihPacwlFg>
    <xmx:fDcoXxB2a44CuGLMojEjYxkOBWNYu_tlQTLFRhmETu8qPhwYPeZKqA>
    <xmx:fDcoX_cQdys_7h4f5yAz7tCc0AGqEaCvk8I3GKcP29QplKo543LGOg>
    <xmx:fDcoX9rwd2c8krAfVskC9Vt67Itt0MsNAOnklijm51kstuoMRYw2sw>
Received: from shredder.mtl.com (bzq-79-181-6-219.red.bezeqint.net [79.181.6.219])
        by mail.messagingengine.com (Postfix) with ESMTPA id D2483306005F;
        Mon,  3 Aug 2020 12:12:42 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        petrm@mellanox.com, amitc@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 6/9] mlxsw: spectrum_trap: Allow for per-ASIC traps initialization
Date:   Mon,  3 Aug 2020 19:11:38 +0300
Message-Id: <20200803161141.2523857-7-idosch@idosch.org>
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

Subsequent patches will need to register different traps for Spectrum-1
and Spectrum-2 onwards.

Enable that by invoking a per-ASIC operation during traps
initialization.

Reviewed-by: Petr Machata <petrm@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Petr Machata <petrm@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_trap.c   | 81 ++++++++++++++++---
 .../ethernet/mellanox/mlxsw/spectrum_trap.h   |  3 +
 2 files changed, 75 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
index 3726be5c02b4..93dd88abbe23 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
@@ -1247,6 +1247,43 @@ mlxsw_sp_trap_listener_is_valid(const struct mlxsw_listener *listener)
 	return listener->trap_id != 0;
 }
 
+static int mlxsw_sp_trap_items_arr_init(struct mlxsw_sp *mlxsw_sp)
+{
+	size_t common_traps_count = ARRAY_SIZE(mlxsw_sp_trap_items_arr);
+	const struct mlxsw_sp_trap_item *spec_trap_items_arr;
+	size_t elem_size = sizeof(struct mlxsw_sp_trap_item);
+	struct mlxsw_sp_trap *trap = mlxsw_sp->trap;
+	size_t traps_count, spec_traps_count;
+	int err;
+
+	err = mlxsw_sp->trap_ops->traps_init(mlxsw_sp, &spec_trap_items_arr,
+					     &spec_traps_count);
+	if (err)
+		return err;
+
+	/* The trap items array is created by concatenating the common trap
+	 * items and the ASIC-specific trap items.
+	 */
+	traps_count = common_traps_count + spec_traps_count;
+	trap->trap_items_arr = kcalloc(traps_count, elem_size, GFP_KERNEL);
+	if (!trap->trap_items_arr)
+		return -ENOMEM;
+
+	memcpy(trap->trap_items_arr, mlxsw_sp_trap_items_arr,
+	       elem_size * common_traps_count);
+	memcpy(trap->trap_items_arr + common_traps_count,
+	       spec_trap_items_arr, elem_size * spec_traps_count);
+
+	trap->traps_count = traps_count;
+
+	return 0;
+}
+
+static void mlxsw_sp_trap_items_arr_fini(struct mlxsw_sp *mlxsw_sp)
+{
+	kfree(mlxsw_sp->trap->trap_items_arr);
+}
+
 static int mlxsw_sp_traps_init(struct mlxsw_sp *mlxsw_sp)
 {
 	struct devlink *devlink = priv_to_devlink(mlxsw_sp->core);
@@ -1254,13 +1291,9 @@ static int mlxsw_sp_traps_init(struct mlxsw_sp *mlxsw_sp)
 	const struct mlxsw_sp_trap_item *trap_item;
 	int err, i;
 
-	trap->trap_items_arr = kmemdup(mlxsw_sp_trap_items_arr,
-				       sizeof(mlxsw_sp_trap_items_arr),
-				       GFP_KERNEL);
-	if (!trap->trap_items_arr)
-		return -ENOMEM;
-
-	trap->traps_count = ARRAY_SIZE(mlxsw_sp_trap_items_arr);
+	err = mlxsw_sp_trap_items_arr_init(mlxsw_sp);
+	if (err)
+		return err;
 
 	for (i = 0; i < trap->traps_count; i++) {
 		trap_item = &trap->trap_items_arr[i];
@@ -1277,7 +1310,7 @@ static int mlxsw_sp_traps_init(struct mlxsw_sp *mlxsw_sp)
 		trap_item = &trap->trap_items_arr[i];
 		devlink_traps_unregister(devlink, &trap_item->trap, 1);
 	}
-	kfree(trap->trap_items_arr);
+	mlxsw_sp_trap_items_arr_fini(mlxsw_sp);
 	return err;
 }
 
@@ -1293,7 +1326,7 @@ static void mlxsw_sp_traps_fini(struct mlxsw_sp *mlxsw_sp)
 		trap_item = &trap->trap_items_arr[i];
 		devlink_traps_unregister(devlink, &trap_item->trap, 1);
 	}
-	kfree(trap->trap_items_arr);
+	mlxsw_sp_trap_items_arr_fini(mlxsw_sp);
 }
 
 int mlxsw_sp_devlink_traps_init(struct mlxsw_sp *mlxsw_sp)
@@ -1617,6 +1650,10 @@ static const struct mlxsw_sp_trap_group_item
 mlxsw_sp1_trap_group_items_arr[] = {
 };
 
+static const struct mlxsw_sp_trap_item
+mlxsw_sp1_trap_items_arr[] = {
+};
+
 static int
 mlxsw_sp1_trap_groups_init(struct mlxsw_sp *mlxsw_sp,
 			   const struct mlxsw_sp_trap_group_item **arr,
@@ -1628,14 +1665,29 @@ mlxsw_sp1_trap_groups_init(struct mlxsw_sp *mlxsw_sp,
 	return 0;
 }
 
+static int mlxsw_sp1_traps_init(struct mlxsw_sp *mlxsw_sp,
+				const struct mlxsw_sp_trap_item **arr,
+				size_t *p_traps_count)
+{
+	*arr = mlxsw_sp1_trap_items_arr;
+	*p_traps_count = ARRAY_SIZE(mlxsw_sp1_trap_items_arr);
+
+	return 0;
+}
+
 const struct mlxsw_sp_trap_ops mlxsw_sp1_trap_ops = {
 	.groups_init = mlxsw_sp1_trap_groups_init,
+	.traps_init = mlxsw_sp1_traps_init,
 };
 
 static const struct mlxsw_sp_trap_group_item
 mlxsw_sp2_trap_group_items_arr[] = {
 };
 
+static const struct mlxsw_sp_trap_item
+mlxsw_sp2_trap_items_arr[] = {
+};
+
 static int
 mlxsw_sp2_trap_groups_init(struct mlxsw_sp *mlxsw_sp,
 			   const struct mlxsw_sp_trap_group_item **arr,
@@ -1647,6 +1699,17 @@ mlxsw_sp2_trap_groups_init(struct mlxsw_sp *mlxsw_sp,
 	return 0;
 }
 
+static int mlxsw_sp2_traps_init(struct mlxsw_sp *mlxsw_sp,
+				const struct mlxsw_sp_trap_item **arr,
+				size_t *p_traps_count)
+{
+	*arr = mlxsw_sp2_trap_items_arr;
+	*p_traps_count = ARRAY_SIZE(mlxsw_sp2_trap_items_arr);
+
+	return 0;
+}
+
 const struct mlxsw_sp_trap_ops mlxsw_sp2_trap_ops = {
 	.groups_init = mlxsw_sp2_trap_groups_init,
+	.traps_init = mlxsw_sp2_traps_init,
 };
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.h
index 4ae5212b9a48..b8df684bedef 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.h
@@ -27,6 +27,9 @@ struct mlxsw_sp_trap_ops {
 	int (*groups_init)(struct mlxsw_sp *mlxsw_sp,
 			   const struct mlxsw_sp_trap_group_item **arr,
 			   size_t *p_groups_count);
+	int (*traps_init)(struct mlxsw_sp *mlxsw_sp,
+			  const struct mlxsw_sp_trap_item **arr,
+			  size_t *p_traps_count);
 };
 
 extern const struct mlxsw_sp_trap_ops mlxsw_sp1_trap_ops;
-- 
2.26.2

