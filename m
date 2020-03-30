Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CCB21984B0
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 21:39:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728979AbgC3Tjd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 15:39:33 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:39433 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728309AbgC3Tjc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 15:39:32 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 641C8580542;
        Mon, 30 Mar 2020 15:39:30 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 30 Mar 2020 15:39:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=M3N0YFupxebPe8F6w05OXL9WwSKTy5MNYK4MYyLTJG4=; b=OZOBeCT8
        O815vq/a52oXh2FWkJT20GBLVIKU0YO+VnUL+IH/6x5Cp04WjhW6F7BP5nlCx90D
        cCXgWPhvfMU8eYX7ZhNMWhIvWKtZujoj5u4kKiihGXinoZCV2GN64PAYqtHqgEON
        Z7uGzqHQFrXqqQ/Psc0mhdsZf9r9JxCYue7Ll1d8sIy5hfJazHo9V6XD4SCxz7ug
        5tdi3JlYVwV/HMxyNYxAfQ67vnPYFLpNGcMsBqv01A4E1U01k6GbBGJVwbWbiH+Y
        8u21AZ8fLG7TnNJlAnu8phBEZ3XrhsjJYWY3+6EAvgECWAtplhTus5CGHQVxmAZt
        0yxPm6sQCDGyYA==
X-ME-Sender: <xms:8kqCXhXvKZzQ8tJNDth8_hj0mhFGymHurGiWFqNqrRsZ2MQoP4VuMg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudeihedgudeflecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucfkphepjeelrddukedurddufedvrdduledunecuvehluhhsth
    gvrhfuihiivgepuddtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihgu
    ohhstghhrdhorhhg
X-ME-Proxy: <xmx:8kqCXl2fKGlK1JFE0yhcmNMQagKhKVm6IbzSRpTcnT4IvP-fc9d3EA>
    <xmx:8kqCXoZV4JaRj50cGe4v0oJXghrEptIRxkDK-KsqRt-b-U_CBKpWJA>
    <xmx:8kqCXorX4eQ4F9QTYwLs2c1jHgLM4lkbZkTk9LxaK9YIiUgMjzqHqw>
    <xmx:8kqCXsct_JG63YYUMDIT-u6MzNv2YxQAcO1i7EZA5-PUqz3oZ4OCwQ>
Received: from splinter.mtl.com (bzq-79-181-132-191.red.bezeqint.net [79.181.132.191])
        by mail.messagingengine.com (Postfix) with ESMTPA id 187A4306C9F4;
        Mon, 30 Mar 2020 15:39:27 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        roopa@cumulusnetworks.com, nikolay@cumulusnetworks.com,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v3 11/15] mlxsw: spectrum_trap: Add devlink-trap policer support
Date:   Mon, 30 Mar 2020 22:38:28 +0300
Message-Id: <20200330193832.2359876-12-idosch@idosch.org>
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

Register supported packet trap policers with devlink and implement
callbacks to change their parameters and read their counters.

Prevent user space from passing invalid policer parameters down to the
device by checking their validity and communicating the failure via an
appropriate extack message.

v2:
* Remove the max/min validity checks from __mlxsw_sp_trap_policer_set()

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core.c    |  57 +++++
 drivers/net/ethernet/mellanox/mlxsw/core.h    |  11 +
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |  12 +
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |  13 ++
 .../ethernet/mellanox/mlxsw/spectrum_trap.c   | 207 +++++++++++++++++-
 .../ethernet/mellanox/mlxsw/spectrum_trap.h   |   8 +
 6 files changed, 297 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index 1078f88cff18..6d0590375976 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -1198,6 +1198,59 @@ mlxsw_devlink_trap_group_init(struct devlink *devlink,
 	return mlxsw_driver->trap_group_init(mlxsw_core, group);
 }
 
+static int
+mlxsw_devlink_trap_policer_init(struct devlink *devlink,
+				const struct devlink_trap_policer *policer)
+{
+	struct mlxsw_core *mlxsw_core = devlink_priv(devlink);
+	struct mlxsw_driver *mlxsw_driver = mlxsw_core->driver;
+
+	if (!mlxsw_driver->trap_policer_init)
+		return -EOPNOTSUPP;
+	return mlxsw_driver->trap_policer_init(mlxsw_core, policer);
+}
+
+static void
+mlxsw_devlink_trap_policer_fini(struct devlink *devlink,
+				const struct devlink_trap_policer *policer)
+{
+	struct mlxsw_core *mlxsw_core = devlink_priv(devlink);
+	struct mlxsw_driver *mlxsw_driver = mlxsw_core->driver;
+
+	if (!mlxsw_driver->trap_policer_fini)
+		return;
+	mlxsw_driver->trap_policer_fini(mlxsw_core, policer);
+}
+
+static int
+mlxsw_devlink_trap_policer_set(struct devlink *devlink,
+			       const struct devlink_trap_policer *policer,
+			       u64 rate, u64 burst,
+			       struct netlink_ext_ack *extack)
+{
+	struct mlxsw_core *mlxsw_core = devlink_priv(devlink);
+	struct mlxsw_driver *mlxsw_driver = mlxsw_core->driver;
+
+	if (!mlxsw_driver->trap_policer_set)
+		return -EOPNOTSUPP;
+	return mlxsw_driver->trap_policer_set(mlxsw_core, policer, rate, burst,
+					      extack);
+}
+
+static int
+mlxsw_devlink_trap_policer_counter_get(struct devlink *devlink,
+				       const struct devlink_trap_policer *policer,
+				       u64 *p_drops)
+{
+	struct mlxsw_core *mlxsw_core = devlink_priv(devlink);
+	struct mlxsw_driver *mlxsw_driver = mlxsw_core->driver;
+
+	if (!mlxsw_driver->trap_policer_counter_get)
+		return -EOPNOTSUPP;
+	return mlxsw_driver->trap_policer_counter_get(mlxsw_core, policer,
+						      p_drops);
+}
+
 static const struct devlink_ops mlxsw_devlink_ops = {
 	.reload_down		= mlxsw_devlink_core_bus_device_reload_down,
 	.reload_up		= mlxsw_devlink_core_bus_device_reload_up,
@@ -1220,6 +1273,10 @@ static const struct devlink_ops mlxsw_devlink_ops = {
 	.trap_fini			= mlxsw_devlink_trap_fini,
 	.trap_action_set		= mlxsw_devlink_trap_action_set,
 	.trap_group_init		= mlxsw_devlink_trap_group_init,
+	.trap_policer_init		= mlxsw_devlink_trap_policer_init,
+	.trap_policer_fini		= mlxsw_devlink_trap_policer_fini,
+	.trap_policer_set		= mlxsw_devlink_trap_policer_set,
+	.trap_policer_counter_get	= mlxsw_devlink_trap_policer_counter_get,
 };
 
 static int
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.h b/drivers/net/ethernet/mellanox/mlxsw/core.h
index 46226823c7a6..035629bc035d 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.h
@@ -327,6 +327,17 @@ struct mlxsw_driver {
 			       enum devlink_trap_action action);
 	int (*trap_group_init)(struct mlxsw_core *mlxsw_core,
 			       const struct devlink_trap_group *group);
+	int (*trap_policer_init)(struct mlxsw_core *mlxsw_core,
+				 const struct devlink_trap_policer *policer);
+	void (*trap_policer_fini)(struct mlxsw_core *mlxsw_core,
+				  const struct devlink_trap_policer *policer);
+	int (*trap_policer_set)(struct mlxsw_core *mlxsw_core,
+				const struct devlink_trap_policer *policer,
+				u64 rate, u64 burst,
+				struct netlink_ext_ack *extack);
+	int (*trap_policer_counter_get)(struct mlxsw_core *mlxsw_core,
+					const struct devlink_trap_policer *policer,
+					u64 *p_drops);
 	void (*txhdr_construct)(struct sk_buff *skb,
 				const struct mlxsw_tx_info *tx_info);
 	int (*resources_register)(struct mlxsw_core *mlxsw_core);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index a109ecbb62b9..e8756c921b76 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -5675,6 +5675,10 @@ static struct mlxsw_driver mlxsw_sp1_driver = {
 	.trap_fini			= mlxsw_sp_trap_fini,
 	.trap_action_set		= mlxsw_sp_trap_action_set,
 	.trap_group_init		= mlxsw_sp_trap_group_init,
+	.trap_policer_init		= mlxsw_sp_trap_policer_init,
+	.trap_policer_fini		= mlxsw_sp_trap_policer_fini,
+	.trap_policer_set		= mlxsw_sp_trap_policer_set,
+	.trap_policer_counter_get	= mlxsw_sp_trap_policer_counter_get,
 	.txhdr_construct		= mlxsw_sp_txhdr_construct,
 	.resources_register		= mlxsw_sp1_resources_register,
 	.kvd_sizes_get			= mlxsw_sp_kvd_sizes_get,
@@ -5709,6 +5713,10 @@ static struct mlxsw_driver mlxsw_sp2_driver = {
 	.trap_fini			= mlxsw_sp_trap_fini,
 	.trap_action_set		= mlxsw_sp_trap_action_set,
 	.trap_group_init		= mlxsw_sp_trap_group_init,
+	.trap_policer_init		= mlxsw_sp_trap_policer_init,
+	.trap_policer_fini		= mlxsw_sp_trap_policer_fini,
+	.trap_policer_set		= mlxsw_sp_trap_policer_set,
+	.trap_policer_counter_get	= mlxsw_sp_trap_policer_counter_get,
 	.txhdr_construct		= mlxsw_sp_txhdr_construct,
 	.resources_register		= mlxsw_sp2_resources_register,
 	.params_register		= mlxsw_sp2_params_register,
@@ -5742,6 +5750,10 @@ static struct mlxsw_driver mlxsw_sp3_driver = {
 	.trap_fini			= mlxsw_sp_trap_fini,
 	.trap_action_set		= mlxsw_sp_trap_action_set,
 	.trap_group_init		= mlxsw_sp_trap_group_init,
+	.trap_policer_init		= mlxsw_sp_trap_policer_init,
+	.trap_policer_fini		= mlxsw_sp_trap_policer_fini,
+	.trap_policer_set		= mlxsw_sp_trap_policer_set,
+	.trap_policer_counter_get	= mlxsw_sp_trap_policer_counter_get,
 	.txhdr_construct		= mlxsw_sp_txhdr_construct,
 	.resources_register		= mlxsw_sp2_resources_register,
 	.params_register		= mlxsw_sp2_params_register,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index 928b56880fea..e8cbbadbcb06 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -1023,6 +1023,19 @@ int mlxsw_sp_trap_action_set(struct mlxsw_core *mlxsw_core,
 			     enum devlink_trap_action action);
 int mlxsw_sp_trap_group_init(struct mlxsw_core *mlxsw_core,
 			     const struct devlink_trap_group *group);
+int
+mlxsw_sp_trap_policer_init(struct mlxsw_core *mlxsw_core,
+			   const struct devlink_trap_policer *policer);
+void mlxsw_sp_trap_policer_fini(struct mlxsw_core *mlxsw_core,
+				const struct devlink_trap_policer *policer);
+int
+mlxsw_sp_trap_policer_set(struct mlxsw_core *mlxsw_core,
+			  const struct devlink_trap_policer *policer,
+			  u64 rate, u64 burst, struct netlink_ext_ack *extack);
+int
+mlxsw_sp_trap_policer_counter_get(struct mlxsw_core *mlxsw_core,
+				  const struct devlink_trap_policer *policer,
+				  u64 *p_drops);
 
 static inline struct net *mlxsw_sp_net(struct mlxsw_sp *mlxsw_sp)
 {
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
index 7f10e9cd7870..b2e41eb5ffdb 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
@@ -3,6 +3,7 @@
 
 #include <linux/bitops.h>
 #include <linux/kernel.h>
+#include <linux/netlink.h>
 #include <net/devlink.h>
 #include <uapi/linux/devlink.h>
 
@@ -180,10 +181,10 @@ static const struct devlink_trap_policer mlxsw_sp_trap_policers_arr[] = {
 };
 
 static const struct devlink_trap_group mlxsw_sp_trap_groups_arr[] = {
-	DEVLINK_TRAP_GROUP_GENERIC(L2_DROPS, 0),
-	DEVLINK_TRAP_GROUP_GENERIC(L3_DROPS, 0),
-	DEVLINK_TRAP_GROUP_GENERIC(TUNNEL_DROPS, 0),
-	DEVLINK_TRAP_GROUP_GENERIC(ACL_DROPS, 0),
+	DEVLINK_TRAP_GROUP_GENERIC(L2_DROPS, 1),
+	DEVLINK_TRAP_GROUP_GENERIC(L3_DROPS, 1),
+	DEVLINK_TRAP_GROUP_GENERIC(TUNNEL_DROPS, 1),
+	DEVLINK_TRAP_GROUP_GENERIC(ACL_DROPS, 1),
 };
 
 static const struct devlink_trap mlxsw_sp_traps_arr[] = {
@@ -309,6 +310,20 @@ static const u16 mlxsw_sp_listener_devlink_map[] = {
 #define MLXSW_SP_DISCARD_POLICER_ID	(MLXSW_REG_HTGT_TRAP_GROUP_MAX + 1)
 #define MLXSW_SP_THIN_POLICER_ID	(MLXSW_SP_DISCARD_POLICER_ID + 1)
 
+static struct mlxsw_sp_trap_policer_item *
+mlxsw_sp_trap_policer_item_lookup(struct mlxsw_sp *mlxsw_sp, u32 id)
+{
+	struct mlxsw_sp_trap_policer_item *policer_item;
+	struct mlxsw_sp_trap *trap = mlxsw_sp->trap;
+
+	list_for_each_entry(policer_item, &trap->policer_item_list, list) {
+		if (policer_item->id == id)
+			return policer_item;
+	}
+
+	return NULL;
+}
+
 static int mlxsw_sp_trap_cpu_policers_set(struct mlxsw_sp *mlxsw_sp)
 {
 	char qpcr_pl[MLXSW_REG_QPCR_LEN];
@@ -340,10 +355,11 @@ static int mlxsw_sp_trap_dummy_group_init(struct mlxsw_sp *mlxsw_sp)
 
 static int mlxsw_sp_trap_policers_init(struct mlxsw_sp *mlxsw_sp)
 {
+	struct devlink *devlink = priv_to_devlink(mlxsw_sp->core);
 	struct mlxsw_sp_trap *trap = mlxsw_sp->trap;
 	u64 free_policers = 0;
 	u32 last_id = 0;
-	int i;
+	int err, i;
 
 	for_each_clear_bit(i, trap->policers_usage, trap->max_policers)
 		free_policers++;
@@ -380,13 +396,28 @@ static int mlxsw_sp_trap_policers_init(struct mlxsw_sp *mlxsw_sp)
 		}
 	}
 
+	INIT_LIST_HEAD(&trap->policer_item_list);
+
+	err = devlink_trap_policers_register(devlink, trap->policers_arr,
+					     trap->policers_count);
+	if (err)
+		goto err_trap_policers_register;
+
 	return 0;
+
+err_trap_policers_register:
+	kfree(trap->policers_arr);
+	return err;
 }
 
 static void mlxsw_sp_trap_policers_fini(struct mlxsw_sp *mlxsw_sp)
 {
+	struct devlink *devlink = priv_to_devlink(mlxsw_sp->core);
 	struct mlxsw_sp_trap *trap = mlxsw_sp->trap;
 
+	devlink_trap_policers_unregister(devlink, trap->policers_arr,
+					 trap->policers_count);
+	WARN_ON(!list_empty(&trap->policer_item_list));
 	kfree(trap->policers_arr);
 }
 
@@ -516,32 +547,29 @@ int mlxsw_sp_trap_action_set(struct mlxsw_core *mlxsw_core,
 int mlxsw_sp_trap_group_init(struct mlxsw_core *mlxsw_core,
 			     const struct devlink_trap_group *group)
 {
+	struct mlxsw_sp *mlxsw_sp = mlxsw_core_driver_priv(mlxsw_core);
+	u16 hw_policer_id = MLXSW_REG_HTGT_INVALID_POLICER;
 	char htgt_pl[MLXSW_REG_HTGT_LEN];
 	u8 priority, tc, group_id;
-	u16 policer_id;
 
 	switch (group->id) {
 	case DEVLINK_TRAP_GROUP_GENERIC_ID_L2_DROPS:
 		group_id = MLXSW_REG_HTGT_TRAP_GROUP_SP_L2_DISCARDS;
-		policer_id = MLXSW_SP_DISCARD_POLICER_ID;
 		priority = 0;
 		tc = 1;
 		break;
 	case DEVLINK_TRAP_GROUP_GENERIC_ID_L3_DROPS:
 		group_id = MLXSW_REG_HTGT_TRAP_GROUP_SP_L3_DISCARDS;
-		policer_id = MLXSW_SP_DISCARD_POLICER_ID;
 		priority = 0;
 		tc = 1;
 		break;
 	case DEVLINK_TRAP_GROUP_GENERIC_ID_TUNNEL_DROPS:
 		group_id = MLXSW_REG_HTGT_TRAP_GROUP_SP_TUNNEL_DISCARDS;
-		policer_id = MLXSW_SP_DISCARD_POLICER_ID;
 		priority = 0;
 		tc = 1;
 		break;
 	case DEVLINK_TRAP_GROUP_GENERIC_ID_ACL_DROPS:
 		group_id = MLXSW_REG_HTGT_TRAP_GROUP_SP_ACL_DISCARDS;
-		policer_id = MLXSW_SP_DISCARD_POLICER_ID;
 		priority = 0;
 		tc = 1;
 		break;
@@ -549,6 +577,163 @@ int mlxsw_sp_trap_group_init(struct mlxsw_core *mlxsw_core,
 		return -EINVAL;
 	}
 
-	mlxsw_reg_htgt_pack(htgt_pl, group_id, policer_id, priority, tc);
+	if (group->init_policer_id) {
+		struct mlxsw_sp_trap_policer_item *policer_item;
+		u32 id = group->init_policer_id;
+
+		policer_item = mlxsw_sp_trap_policer_item_lookup(mlxsw_sp, id);
+		if (WARN_ON(!policer_item))
+			return -EINVAL;
+		hw_policer_id = policer_item->hw_id;
+	}
+
+	mlxsw_reg_htgt_pack(htgt_pl, group_id, hw_policer_id, priority, tc);
 	return mlxsw_reg_write(mlxsw_core, MLXSW_REG(htgt), htgt_pl);
 }
+
+static struct mlxsw_sp_trap_policer_item *
+mlxsw_sp_trap_policer_item_init(struct mlxsw_sp *mlxsw_sp, u32 id)
+{
+	struct mlxsw_sp_trap_policer_item *policer_item;
+	struct mlxsw_sp_trap *trap = mlxsw_sp->trap;
+	u16 hw_id;
+
+	/* We should be able to allocate a policer because the number of
+	 * policers we registered with devlink is in according with the number
+	 * of available policers.
+	 */
+	hw_id = find_first_zero_bit(trap->policers_usage, trap->max_policers);
+	if (WARN_ON(hw_id == trap->max_policers))
+		return ERR_PTR(-ENOBUFS);
+
+	policer_item = kzalloc(sizeof(*policer_item), GFP_KERNEL);
+	if (!policer_item)
+		return ERR_PTR(-ENOMEM);
+
+	__set_bit(hw_id, trap->policers_usage);
+	policer_item->hw_id = hw_id;
+	policer_item->id = id;
+	list_add_tail(&policer_item->list, &trap->policer_item_list);
+
+	return policer_item;
+}
+
+static void
+mlxsw_sp_trap_policer_item_fini(struct mlxsw_sp *mlxsw_sp,
+				struct mlxsw_sp_trap_policer_item *policer_item)
+{
+	list_del(&policer_item->list);
+	__clear_bit(policer_item->hw_id, mlxsw_sp->trap->policers_usage);
+	kfree(policer_item);
+}
+
+static int mlxsw_sp_trap_policer_bs(u64 burst, u8 *p_burst_size,
+				    struct netlink_ext_ack *extack)
+{
+	int bs = fls64(burst) - 1;
+
+	if (burst != (1 << bs)) {
+		NL_SET_ERR_MSG_MOD(extack, "Policer burst size is not power of two");
+		return -EINVAL;
+	}
+
+	*p_burst_size = bs;
+
+	return 0;
+}
+
+static int __mlxsw_sp_trap_policer_set(struct mlxsw_sp *mlxsw_sp, u16 hw_id,
+				       u64 rate, u64 burst, bool clear_counter,
+				       struct netlink_ext_ack *extack)
+{
+	char qpcr_pl[MLXSW_REG_QPCR_LEN];
+	u8 burst_size;
+	int err;
+
+	err = mlxsw_sp_trap_policer_bs(burst, &burst_size, extack);
+	if (err)
+		return err;
+
+	mlxsw_reg_qpcr_pack(qpcr_pl, hw_id, MLXSW_REG_QPCR_IR_UNITS_M, false,
+			    rate, burst_size);
+	mlxsw_reg_qpcr_clear_counter_set(qpcr_pl, clear_counter);
+	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(qpcr), qpcr_pl);
+}
+
+int mlxsw_sp_trap_policer_init(struct mlxsw_core *mlxsw_core,
+			       const struct devlink_trap_policer *policer)
+{
+	struct mlxsw_sp *mlxsw_sp = mlxsw_core_driver_priv(mlxsw_core);
+	struct mlxsw_sp_trap_policer_item *policer_item;
+	int err;
+
+	policer_item = mlxsw_sp_trap_policer_item_init(mlxsw_sp, policer->id);
+	if (IS_ERR(policer_item))
+		return PTR_ERR(policer_item);
+
+	err = __mlxsw_sp_trap_policer_set(mlxsw_sp, policer_item->hw_id,
+					  policer->init_rate,
+					  policer->init_burst, true, NULL);
+	if (err)
+		goto err_trap_policer_set;
+
+	return 0;
+
+err_trap_policer_set:
+	mlxsw_sp_trap_policer_item_fini(mlxsw_sp, policer_item);
+	return err;
+}
+
+void mlxsw_sp_trap_policer_fini(struct mlxsw_core *mlxsw_core,
+				const struct devlink_trap_policer *policer)
+{
+	struct mlxsw_sp *mlxsw_sp = mlxsw_core_driver_priv(mlxsw_core);
+	struct mlxsw_sp_trap_policer_item *policer_item;
+
+	policer_item = mlxsw_sp_trap_policer_item_lookup(mlxsw_sp, policer->id);
+	if (WARN_ON(!policer_item))
+		return;
+
+	mlxsw_sp_trap_policer_item_fini(mlxsw_sp, policer_item);
+}
+
+int mlxsw_sp_trap_policer_set(struct mlxsw_core *mlxsw_core,
+			      const struct devlink_trap_policer *policer,
+			      u64 rate, u64 burst,
+			      struct netlink_ext_ack *extack)
+{
+	struct mlxsw_sp *mlxsw_sp = mlxsw_core_driver_priv(mlxsw_core);
+	struct mlxsw_sp_trap_policer_item *policer_item;
+
+	policer_item = mlxsw_sp_trap_policer_item_lookup(mlxsw_sp, policer->id);
+	if (WARN_ON(!policer_item))
+		return -EINVAL;
+
+	return __mlxsw_sp_trap_policer_set(mlxsw_sp, policer_item->hw_id,
+					   rate, burst, false, extack);
+}
+
+int
+mlxsw_sp_trap_policer_counter_get(struct mlxsw_core *mlxsw_core,
+				  const struct devlink_trap_policer *policer,
+				  u64 *p_drops)
+{
+	struct mlxsw_sp *mlxsw_sp = mlxsw_core_driver_priv(mlxsw_core);
+	struct mlxsw_sp_trap_policer_item *policer_item;
+	char qpcr_pl[MLXSW_REG_QPCR_LEN];
+	int err;
+
+	policer_item = mlxsw_sp_trap_policer_item_lookup(mlxsw_sp, policer->id);
+	if (WARN_ON(!policer_item))
+		return -EINVAL;
+
+	mlxsw_reg_qpcr_pack(qpcr_pl, policer_item->hw_id,
+			    MLXSW_REG_QPCR_IR_UNITS_M, false, 0, 0);
+	err = mlxsw_reg_query(mlxsw_sp->core, MLXSW_REG(qpcr), qpcr_pl);
+	if (err)
+		return err;
+
+	*p_drops = mlxsw_reg_qpcr_violate_count_get(qpcr_pl);
+
+	return 0;
+}
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.h
index 05bb652b1a76..8c54897ba173 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.h
@@ -4,13 +4,21 @@
 #ifndef _MLXSW_SPECTRUM_TRAP_H
 #define _MLXSW_SPECTRUM_TRAP_H
 
+#include <linux/list.h>
 #include <net/devlink.h>
 
 struct mlxsw_sp_trap {
 	struct devlink_trap_policer *policers_arr; /* Registered policers */
 	u64 policers_count; /* Number of registered policers */
+	struct list_head policer_item_list;
 	u64 max_policers;
 	unsigned long policers_usage[]; /* Usage bitmap */
 };
 
+struct mlxsw_sp_trap_policer_item {
+	u16 hw_id;
+	u32 id;
+	struct list_head list; /* Member of policer_item_list */
+};
+
 #endif
-- 
2.24.1

