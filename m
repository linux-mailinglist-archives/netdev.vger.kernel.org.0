Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9B0318EBA6
	for <lists+netdev@lfdr.de>; Sun, 22 Mar 2020 19:50:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726895AbgCVSu2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Mar 2020 14:50:28 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:53351 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726816AbgCVSu1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Mar 2020 14:50:27 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 3682C5C0175;
        Sun, 22 Mar 2020 14:50:26 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 22 Mar 2020 14:50:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=aH7p6YryE2XatPwj9qwHPR90ngV7x7KlDKtMXFWBWHg=; b=PDp0jikg
        t/vWoksXGUDq8xIxK5tGP6YM7hspa40mie3JPPgKYq9nnxsU/CXjUXK8g4F2vV+Q
        fkWAiTkoTMxB55z1IqYW56FpCJsPZ85Nk8fO9RXeR6N18CGnXSy0HauZMkuQmh4C
        PhAwYTA3wYOswvBweHYo9RVEievTPKkunJvpz9PVBhVxcnIIe6Zm0Y++j0jvR40w
        WgPRoFvNzbGc7k4NEUWRxkK//q4cMN6uhhqHyDbT9mKlbMiFOpvty1lQLB7uBU8o
        y8jqu23UntwHLmd0PZyAvhDzqvQXPpi02NG+AFP8+Vp8lVmJodA/DQONSEdaFTxz
        b3jvRlrHg/Rx3Q==
X-ME-Sender: <xms:crN3Xk-7_S8uu5jiKR8wVmKTyMvu1-3XhujtIyPvSYLpc4tebnL80A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudegiedguddvtdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucfkphepjeelrddukedtrdelgedrvddvheenucevlhhushhtvg
    hrufhiiigvpeefnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhs
    tghhrdhorhhg
X-ME-Proxy: <xmx:crN3Xg-wSjXk5qqidxy9ElpuZPbzvlXce7TkjVuQV2IFUJ9HXT4sSg>
    <xmx:crN3XlBdedwVs6QE9LI0wb-V6GaeawWwBZznq7_IOBnxWjNYJS_LlA>
    <xmx:crN3XoykQV5Zw5K_AZtdtVv_1Uo65zi8_FirHGMOHdcg0M27oByqXA>
    <xmx:crN3XgskYgX9m8DHNNQW4hEk8xVf0mJ_d9VZ9b-3OAwDgn0xihOavw>
Received: from splinter.mtl.com (bzq-79-180-94-225.red.bezeqint.net [79.180.94.225])
        by mail.messagingengine.com (Postfix) with ESMTPA id D17DE328005A;
        Sun, 22 Mar 2020 14:50:24 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, kuba@kernel.org,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 5/5] devlink: Only pass packet trap group identifier in trap structure
Date:   Sun, 22 Mar 2020 20:48:30 +0200
Message-Id: <20200322184830.1254104-6-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200322184830.1254104-1-idosch@idosch.org>
References: <20200322184830.1254104-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Packet trap groups are now explicitly registered by drivers and not
implicitly registered when the packet traps are registered. Therefore,
there is no need to encode entire group structure the trap is associated
with inside the trap structure.

Instead, only pass the group identifier. Refer to it as initial group
identifier, as future patches will allow user space to move traps
between groups.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_trap.c   |  8 +++----
 drivers/net/netdevsim/dev.c                   |  8 +++----
 include/net/devlink.h                         | 13 ++++++------
 net/core/devlink.c                            | 21 +++++++++++++++----
 4 files changed, 32 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
index cf3891609d5c..727f6ef243df 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
@@ -132,23 +132,23 @@ static void mlxsw_sp_rx_exception_listener(struct sk_buff *skb, u8 local_port,
 
 #define MLXSW_SP_TRAP_DROP(_id, _group_id)				      \
 	DEVLINK_TRAP_GENERIC(DROP, DROP, _id,				      \
-			     DEVLINK_TRAP_GROUP_GENERIC(_group_id),	      \
+			     DEVLINK_TRAP_GROUP_GENERIC_ID_##_group_id,	      \
 			     MLXSW_SP_TRAP_METADATA)
 
 #define MLXSW_SP_TRAP_DROP_EXT(_id, _group_id, _metadata)		      \
 	DEVLINK_TRAP_GENERIC(DROP, DROP, _id,				      \
-			     DEVLINK_TRAP_GROUP_GENERIC(_group_id),	      \
+			     DEVLINK_TRAP_GROUP_GENERIC_ID_##_group_id,	      \
 			     MLXSW_SP_TRAP_METADATA | (_metadata))
 
 #define MLXSW_SP_TRAP_DRIVER_DROP(_id, _group_id)			      \
 	DEVLINK_TRAP_DRIVER(DROP, DROP, DEVLINK_MLXSW_TRAP_ID_##_id,	      \
 			    DEVLINK_MLXSW_TRAP_NAME_##_id,		      \
-			    DEVLINK_TRAP_GROUP_GENERIC(_group_id),	      \
+			    DEVLINK_TRAP_GROUP_GENERIC_ID_##_group_id,	      \
 			    MLXSW_SP_TRAP_METADATA)
 
 #define MLXSW_SP_TRAP_EXCEPTION(_id, _group_id)		      \
 	DEVLINK_TRAP_GENERIC(EXCEPTION, TRAP, _id,			      \
-			     DEVLINK_TRAP_GROUP_GENERIC(_group_id),	      \
+			     DEVLINK_TRAP_GROUP_GENERIC_ID_##_group_id,	      \
 			     MLXSW_SP_TRAP_METADATA)
 
 #define MLXSW_SP_RXL_DISCARD(_id, _group_id)				      \
diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index edeb61ddc8bc..7bfd0622cef1 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -381,20 +381,20 @@ enum {
 
 #define NSIM_TRAP_DROP(_id, _group_id)					      \
 	DEVLINK_TRAP_GENERIC(DROP, DROP, _id,				      \
-			     DEVLINK_TRAP_GROUP_GENERIC(_group_id),	      \
+			     DEVLINK_TRAP_GROUP_GENERIC_ID_##_group_id,	      \
 			     NSIM_TRAP_METADATA)
 #define NSIM_TRAP_DROP_EXT(_id, _group_id, _metadata)			      \
 	DEVLINK_TRAP_GENERIC(DROP, DROP, _id,				      \
-			     DEVLINK_TRAP_GROUP_GENERIC(_group_id),	      \
+			     DEVLINK_TRAP_GROUP_GENERIC_ID_##_group_id,	      \
 			     NSIM_TRAP_METADATA | (_metadata))
 #define NSIM_TRAP_EXCEPTION(_id, _group_id)				      \
 	DEVLINK_TRAP_GENERIC(EXCEPTION, TRAP, _id,			      \
-			     DEVLINK_TRAP_GROUP_GENERIC(_group_id),	      \
+			     DEVLINK_TRAP_GROUP_GENERIC_ID_##_group_id,	      \
 			     NSIM_TRAP_METADATA)
 #define NSIM_TRAP_DRIVER_EXCEPTION(_id, _group_id)			      \
 	DEVLINK_TRAP_DRIVER(EXCEPTION, TRAP, NSIM_TRAP_ID_##_id,	      \
 			    NSIM_TRAP_NAME_##_id,			      \
-			    DEVLINK_TRAP_GROUP_GENERIC(_group_id),	      \
+			    DEVLINK_TRAP_GROUP_GENERIC_ID_##_group_id,	      \
 			    NSIM_TRAP_METADATA)
 
 static const struct devlink_trap_group nsim_trap_groups_arr[] = {
diff --git a/include/net/devlink.h b/include/net/devlink.h
index de3289217b9a..f3eda246fe32 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -551,7 +551,7 @@ struct devlink_trap_group {
  * @generic: Whether the trap is generic or not.
  * @id: Trap identifier.
  * @name: Trap name.
- * @group: Immutable packet trap group attributes.
+ * @init_group_id: Initial group identifier.
  * @metadata_cap: Metadata types that can be provided by the trap.
  *
  * Describes immutable attributes of packet traps that drivers register with
@@ -563,7 +563,7 @@ struct devlink_trap {
 	bool generic;
 	u16 id;
 	const char *name;
-	struct devlink_trap_group group;
+	u16 init_group_id;
 	u32 metadata_cap;
 };
 
@@ -692,18 +692,19 @@ enum devlink_trap_group_generic_id {
 #define DEVLINK_TRAP_GROUP_GENERIC_NAME_ACL_DROPS \
 	"acl_drops"
 
-#define DEVLINK_TRAP_GENERIC(_type, _init_action, _id, _group, _metadata_cap) \
+#define DEVLINK_TRAP_GENERIC(_type, _init_action, _id, _group_id,	      \
+			     _metadata_cap)				      \
 	{								      \
 		.type = DEVLINK_TRAP_TYPE_##_type,			      \
 		.init_action = DEVLINK_TRAP_ACTION_##_init_action,	      \
 		.generic = true,					      \
 		.id = DEVLINK_TRAP_GENERIC_ID_##_id,			      \
 		.name = DEVLINK_TRAP_GENERIC_NAME_##_id,		      \
-		.group = _group,					      \
+		.init_group_id = _group_id,				      \
 		.metadata_cap = _metadata_cap,				      \
 	}
 
-#define DEVLINK_TRAP_DRIVER(_type, _init_action, _id, _name, _group,	      \
+#define DEVLINK_TRAP_DRIVER(_type, _init_action, _id, _name, _group_id,	      \
 			    _metadata_cap)				      \
 	{								      \
 		.type = DEVLINK_TRAP_TYPE_##_type,			      \
@@ -711,7 +712,7 @@ enum devlink_trap_group_generic_id {
 		.generic = false,					      \
 		.id = _id,						      \
 		.name = _name,						      \
-		.group = _group,					      \
+		.init_group_id = _group_id,				      \
 		.metadata_cap = _metadata_cap,				      \
 	}
 
diff --git a/net/core/devlink.c b/net/core/devlink.c
index a35285a48b02..73bb8fbe3393 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -5815,6 +5815,19 @@ devlink_trap_group_item_lookup(struct devlink *devlink, const char *name)
 	return NULL;
 }
 
+static struct devlink_trap_group_item *
+devlink_trap_group_item_lookup_by_id(struct devlink *devlink, u16 id)
+{
+	struct devlink_trap_group_item *group_item;
+
+	list_for_each_entry(group_item, &devlink->trap_group_list, list) {
+		if (group_item->group->id == id)
+			return group_item;
+	}
+
+	return NULL;
+}
+
 static struct devlink_trap_group_item *
 devlink_trap_group_item_get_from_info(struct devlink *devlink,
 				      struct genl_info *info)
@@ -5953,7 +5966,7 @@ __devlink_trap_group_action_set(struct devlink *devlink,
 	int err;
 
 	list_for_each_entry(trap_item, &devlink->trap_list, list) {
-		if (strcmp(trap_item->trap->group.name, group_name))
+		if (strcmp(trap_item->group_item->group->name, group_name))
 			continue;
 		err = __devlink_trap_action_set(devlink, trap_item,
 						trap_action, extack);
@@ -7864,7 +7877,7 @@ static int devlink_trap_driver_verify(const struct devlink_trap *trap)
 
 static int devlink_trap_verify(const struct devlink_trap *trap)
 {
-	if (!trap || !trap->name || !trap->group.name)
+	if (!trap || !trap->name)
 		return -EINVAL;
 
 	if (trap->generic)
@@ -7939,10 +7952,10 @@ static int
 devlink_trap_item_group_link(struct devlink *devlink,
 			     struct devlink_trap_item *trap_item)
 {
-	const struct devlink_trap *trap = trap_item->trap;
+	u16 group_id = trap_item->trap->init_group_id;
 	struct devlink_trap_group_item *group_item;
 
-	group_item = devlink_trap_group_item_lookup(devlink, trap->group.name);
+	group_item = devlink_trap_group_item_lookup_by_id(devlink, group_id);
 	if (WARN_ON_ONCE(!group_item))
 		return -EINVAL;
 
-- 
2.24.1

