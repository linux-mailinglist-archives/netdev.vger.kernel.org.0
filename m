Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1F961984A8
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 21:39:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728709AbgC3TjR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 15:39:17 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:45707 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728604AbgC3TjP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 15:39:15 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id BA137580542;
        Mon, 30 Mar 2020 15:39:14 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 30 Mar 2020 15:39:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=RZeeunFlVQrZMLX4GREWC7F00M/995VojbONySU35R8=; b=WIRMT4iU
        1PiRDfeJlA4wb/cEf0pDcm9+m3wLwdN1MsFVJyFHu+6KG/MjWah4jRe6B1LGJH2g
        A3Bt2FUUC+rX5wubM58z5srnvjT9pqhpeE7Vg4AiKnvt2/kmsvJMuXhGis1rD0ZA
        OzzRAJNjrSNxiXzWita7EFiShr40Jcd+NZBxqEHfr3zzunD1WjD8IMOERevjvE+4
        8Gp/0W1TuLwce4KZfCnp34fxlNfWEigKuhT1UebXiwt7g+unRdipzslAMvUyfSQP
        kwoBK67u+hanra5ttxI1yyx7R8LjEvDk0ZN22cKH2mWyaWw5hYWHbyBtegOJjsYR
        +A/2zv3+FXrkYw==
X-ME-Sender: <xms:4kqCXsfpGu7XTYnCKK0XErTrQ7DW5edW-5n0a-Ima1q4mbiEUNboSQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudeihedgudeflecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucfkphepjeelrddukedurddufedvrdduledunecuvehluhhsth
    gvrhfuihiivgepvdenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiugho
    shgthhdrohhrgh
X-ME-Proxy: <xmx:4kqCXiEO8LCOXBSlkveVs0vcJI5LE6LwasTFVgxv8ua6-dhPXDvF6Q>
    <xmx:4kqCXrPEKPqAlA5V4xE6w2RYIK4frI41vlGcXjBwOuHwZlqjza_FoQ>
    <xmx:4kqCXq_8LYDCyiYgB3WHRYXKN0_vyMHIz7Oh8RDcJOdfFhcv6esR5A>
    <xmx:4kqCXmPwntLH5PR7C4eIdy5AO4Ud5RrmViGLEp_bMYj3slllcC1F4w>
Received: from splinter.mtl.com (bzq-79-181-132-191.red.bezeqint.net [79.181.132.191])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9CDE3306CA25;
        Mon, 30 Mar 2020 15:39:12 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        roopa@cumulusnetworks.com, nikolay@cumulusnetworks.com,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v3 04/15] devlink: Add packet trap group parameters support
Date:   Mon, 30 Mar 2020 22:38:21 +0300
Message-Id: <20200330193832.2359876-5-idosch@idosch.org>
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

Packet trap groups are used to aggregate logically related packet traps.
Currently, these groups allow user space to batch operations such as
setting the trap action of all member traps.

In order to prevent the CPU from being overwhelmed by too many trapped
packets, it is desirable to bind a packet trap policer to these groups.
For example, to limit all the packets that encountered an exception
during routing to 10Kpps.

Allow device drivers to bind default packet trap policers to packet trap
groups when the latter are registered with devlink.

The next patch will enable user space to change this default binding.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_trap.c   |  8 ++---
 drivers/net/netdevsim/dev.c                   |  8 ++---
 include/net/devlink.h                         |  5 ++-
 net/core/devlink.c                            | 31 +++++++++++++++++++
 4 files changed, 43 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
index 727f6ef243df..24f15345ba84 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
@@ -166,10 +166,10 @@ static void mlxsw_sp_rx_exception_listener(struct sk_buff *skb, u8 local_port,
 		   _action, false, SP_##_group_id, SET_FW_DEFAULT)
 
 static const struct devlink_trap_group mlxsw_sp_trap_groups_arr[] = {
-	DEVLINK_TRAP_GROUP_GENERIC(L2_DROPS),
-	DEVLINK_TRAP_GROUP_GENERIC(L3_DROPS),
-	DEVLINK_TRAP_GROUP_GENERIC(TUNNEL_DROPS),
-	DEVLINK_TRAP_GROUP_GENERIC(ACL_DROPS),
+	DEVLINK_TRAP_GROUP_GENERIC(L2_DROPS, 0),
+	DEVLINK_TRAP_GROUP_GENERIC(L3_DROPS, 0),
+	DEVLINK_TRAP_GROUP_GENERIC(TUNNEL_DROPS, 0),
+	DEVLINK_TRAP_GROUP_GENERIC(ACL_DROPS, 0),
 };
 
 static const struct devlink_trap mlxsw_sp_traps_arr[] = {
diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index 21341e592467..bda603cfe66a 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -452,10 +452,10 @@ static const struct devlink_trap_policer nsim_trap_policers_arr[] = {
 };
 
 static const struct devlink_trap_group nsim_trap_groups_arr[] = {
-	DEVLINK_TRAP_GROUP_GENERIC(L2_DROPS),
-	DEVLINK_TRAP_GROUP_GENERIC(L3_DROPS),
-	DEVLINK_TRAP_GROUP_GENERIC(BUFFER_DROPS),
-	DEVLINK_TRAP_GROUP_GENERIC(ACL_DROPS),
+	DEVLINK_TRAP_GROUP_GENERIC(L2_DROPS, 0),
+	DEVLINK_TRAP_GROUP_GENERIC(L3_DROPS, 1),
+	DEVLINK_TRAP_GROUP_GENERIC(BUFFER_DROPS, 2),
+	DEVLINK_TRAP_GROUP_GENERIC(ACL_DROPS, 3),
 };
 
 static const struct devlink_trap nsim_traps_arr[] = {
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 9cd08fcfaff7..63834686c8d3 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -574,6 +574,7 @@ struct devlink_trap_policer {
  * @name: Trap group name.
  * @id: Trap group identifier.
  * @generic: Whether the trap group is generic or not.
+ * @init_policer_id: Initial policer identifier.
  *
  * Describes immutable attributes of packet trap groups that drivers register
  * with devlink.
@@ -582,6 +583,7 @@ struct devlink_trap_group {
 	const char *name;
 	u16 id;
 	bool generic;
+	u32 init_policer_id;
 };
 
 #define DEVLINK_TRAP_METADATA_TYPE_F_IN_PORT	BIT(0)
@@ -759,11 +761,12 @@ enum devlink_trap_group_generic_id {
 		.metadata_cap = _metadata_cap,				      \
 	}
 
-#define DEVLINK_TRAP_GROUP_GENERIC(_id)					      \
+#define DEVLINK_TRAP_GROUP_GENERIC(_id, _policer_id)			      \
 	{								      \
 		.name = DEVLINK_TRAP_GROUP_GENERIC_NAME_##_id,		      \
 		.id = DEVLINK_TRAP_GROUP_GENERIC_ID_##_id,		      \
 		.generic = true,					      \
+		.init_policer_id = _policer_id,				      \
 	}
 
 #define DEVLINK_TRAP_POLICER(_id, _rate, _burst, _max_rate, _min_rate,	      \
diff --git a/net/core/devlink.c b/net/core/devlink.c
index e22b8ed67bf7..544543443e96 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -5739,6 +5739,7 @@ struct devlink_trap_policer_item {
 /**
  * struct devlink_trap_group_item - Packet trap group attributes.
  * @group: Immutable packet trap group attributes.
+ * @policer_item: Associated policer item. Can be NULL.
  * @list: trap_group_list member.
  * @stats: Trap group statistics.
  *
@@ -5747,6 +5748,7 @@ struct devlink_trap_policer_item {
  */
 struct devlink_trap_group_item {
 	const struct devlink_trap_group *group;
+	struct devlink_trap_policer_item *policer_item;
 	struct list_head list;
 	struct devlink_stats __percpu *stats;
 };
@@ -6161,6 +6163,11 @@ devlink_nl_trap_group_fill(struct sk_buff *msg, struct devlink *devlink,
 	    nla_put_flag(msg, DEVLINK_ATTR_TRAP_GENERIC))
 		goto nla_put_failure;
 
+	if (group_item->policer_item &&
+	    nla_put_u32(msg, DEVLINK_ATTR_TRAP_POLICER_ID,
+			group_item->policer_item->policer->id))
+		goto nla_put_failure;
+
 	err = devlink_trap_stats_put(msg, group_item->stats);
 	if (err)
 		goto nla_put_failure;
@@ -8759,6 +8766,25 @@ void *devlink_trap_ctx_priv(void *trap_ctx)
 }
 EXPORT_SYMBOL_GPL(devlink_trap_ctx_priv);
 
+static int
+devlink_trap_group_item_policer_link(struct devlink *devlink,
+				     struct devlink_trap_group_item *group_item)
+{
+	u32 policer_id = group_item->group->init_policer_id;
+	struct devlink_trap_policer_item *policer_item;
+
+	if (policer_id == 0)
+		return 0;
+
+	policer_item = devlink_trap_policer_item_lookup(devlink, policer_id);
+	if (WARN_ON_ONCE(!policer_item))
+		return -EINVAL;
+
+	group_item->policer_item = policer_item;
+
+	return 0;
+}
+
 static int
 devlink_trap_group_register(struct devlink *devlink,
 			    const struct devlink_trap_group *group)
@@ -8781,6 +8807,10 @@ devlink_trap_group_register(struct devlink *devlink,
 
 	group_item->group = group;
 
+	err = devlink_trap_group_item_policer_link(devlink, group_item);
+	if (err)
+		goto err_policer_link;
+
 	if (devlink->ops->trap_group_init) {
 		err = devlink->ops->trap_group_init(devlink, group);
 		if (err)
@@ -8794,6 +8824,7 @@ devlink_trap_group_register(struct devlink *devlink,
 	return 0;
 
 err_group_init:
+err_policer_link:
 	free_percpu(group_item->stats);
 err_stats_alloc:
 	kfree(group_item);
-- 
2.24.1

