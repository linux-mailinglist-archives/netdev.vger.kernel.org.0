Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8606F196F34
	for <lists+netdev@lfdr.de>; Sun, 29 Mar 2020 20:22:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728562AbgC2SWK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Mar 2020 14:22:10 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:43905 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727719AbgC2SWJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Mar 2020 14:22:09 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id CFDBE580907;
        Sun, 29 Mar 2020 14:22:08 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 29 Mar 2020 14:22:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=qNnzWYCGxzxzd6+cQGNqO3yFTDvOg3L6YBbuQB/Kgwg=; b=YFCT4HwR
        K1OuBfyeYgjQXK1QO6dPpyIh8lqdyOu5PgMCuoHKyoQz2LRL14GwsQKjPgxzMQUL
        IDiKJGgAeb4Xmn23Xsrnb8RY2sNhM2i+BSAwJ5xOBmX5k1lOPMgjU3DuG+p53X68
        cwK1oEu3s/uIGxQA4Pd7LT0Eqm1d3h5Y5hO1lU+oJSDkJJdBhL2NDUBHYQw6QaN2
        gqhPUIscOH4OJTBLUiWQnt/wTptmJ/Pf3jiLFA0rNVgKior0VpXYyUIcePI31iHB
        VALM8xSLe9laUOgVP1mSiR7M9EKHhp5eIvH4HR0AY6/4WUOwFVT+LQ1NlrMBG7ki
        hfaQfET4v6YkjQ==
X-ME-Sender: <xms:UOeAXva3IlrjPaTKL_x1L9h_eJXxq8QDnpALcF9t42VOAZl4ks_aMg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudeifedguddviecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucfkphepjeelrddukedurddufedvrdduledunecuvehluhhsth
    gvrhfuihiivgepvdenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiugho
    shgthhdrohhrgh
X-ME-Proxy: <xmx:UOeAXqGBAltfZwurEnnx4R7xptHxe3l9Eqq1vDgpss98QHfqJI95-A>
    <xmx:UOeAXhtuFt1WA6VRlrdN6tvvXADubFW4b5dIkW0ISFu7-_HHexPb6A>
    <xmx:UOeAXo0jA304pr26taCGpsj6dhSte28D9BFpVFPqeS5sOtxcOyNesA>
    <xmx:UOeAXsSGIQtGqpf89mIiugT_UP5ppuj9DVWBLD2OMaRYFLRf2UTpdg>
Received: from splinter.mtl.com (bzq-79-181-132-191.red.bezeqint.net [79.181.132.191])
        by mail.messagingengine.com (Postfix) with ESMTPA id 67FD23280059;
        Sun, 29 Mar 2020 14:22:06 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        roopa@cumulusnetworks.com, nikolay@cumulusnetworks.com,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 04/15] devlink: Add packet trap group parameters support
Date:   Sun, 29 Mar 2020 21:21:08 +0300
Message-Id: <20200329182119.2207630-5-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200329182119.2207630-1-idosch@idosch.org>
References: <20200329182119.2207630-1-idosch@idosch.org>
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
index 3b7ba16944bf..781ad5285dcf 100644
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
index c08be41a99aa..85a566d60d49 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -5725,6 +5725,7 @@ struct devlink_trap_policer_item {
 /**
  * struct devlink_trap_group_item - Packet trap group attributes.
  * @group: Immutable packet trap group attributes.
+ * @policer_item: Associated policer item. Can be NULL.
  * @list: trap_group_list member.
  * @stats: Trap group statistics.
  *
@@ -5733,6 +5734,7 @@ struct devlink_trap_policer_item {
  */
 struct devlink_trap_group_item {
 	const struct devlink_trap_group *group;
+	struct devlink_trap_policer_item *policer_item;
 	struct list_head list;
 	struct devlink_stats __percpu *stats;
 };
@@ -6147,6 +6149,11 @@ devlink_nl_trap_group_fill(struct sk_buff *msg, struct devlink *devlink,
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
@@ -8744,6 +8751,25 @@ void *devlink_trap_ctx_priv(void *trap_ctx)
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
@@ -8766,6 +8792,10 @@ devlink_trap_group_register(struct devlink *devlink,
 
 	group_item->group = group;
 
+	err = devlink_trap_group_item_policer_link(devlink, group_item);
+	if (err)
+		goto err_policer_link;
+
 	if (devlink->ops->trap_group_init) {
 		err = devlink->ops->trap_group_init(devlink, group);
 		if (err)
@@ -8779,6 +8809,7 @@ devlink_trap_group_register(struct devlink *devlink,
 	return 0;
 
 err_group_init:
+err_policer_link:
 	free_percpu(group_item->stats);
 err_stats_alloc:
 	kfree(group_item);
-- 
2.24.1

