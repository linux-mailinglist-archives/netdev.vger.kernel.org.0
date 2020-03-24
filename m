Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FE38191A03
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 20:35:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727209AbgCXTeX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 15:34:23 -0400
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:60999 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725877AbgCXTeX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 15:34:23 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 02BE5580061;
        Tue, 24 Mar 2020 15:34:22 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 24 Mar 2020 15:34:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=ZZb+y4FvIDOw4B0gXeubT1cI5CzUZPd4+3AgZrpXpgo=; b=LsI6cJ5p
        P2EO236ObTi/+nbITVnCpmWIUJPmHmxZKn6FEJXvsIx624subAauzbY7v1LK8H8E
        WL2gLTcoXI9vcfPzqT5QxhH+URA6mOD5lTLdw4nJvZlGEKSDBdrDZLNu7Bo8SI2+
        Gf9MSBAAA1Brrnu6noPBRfAfIuSK9klkErPk9wepQExDOq8l5Kui5zIVTccXmRQN
        H29X1PIi+xZZiiElrqy0XWpOsrICLoi/VvqYaeOJAmjp4dlBZe1CjLX6t/T8nFLr
        zgjLxpD3lKdHoHPm3uumthAkIZZEyGgbIdN+jp33VaTZqL1NHO9n5qP91YLGgEh8
        WM4Uvc7ra5cP8A==
X-ME-Sender: <xms:vWB6XvDQSNSzgJ-CSQiyzUtRmwh85BAGN4O72GgcWvgEJ02ARa1Vsw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudehuddgleehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeejledrudektddrleegrddvvdehnecuvehluhhsthgvrh
    fuihiivgepvdenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgt
    hhdrohhrgh
X-ME-Proxy: <xmx:vWB6Xr4UY95dQqiFe2nA6GresPdrqdESCOORWNlq31-qpXRq-ADpJw>
    <xmx:vWB6Xm2q6hSMlto34EhILYsCHxgggehftMRVjmtBGQylhmWTgQGUJA>
    <xmx:vWB6Xvkd8sREQbht0lBbGTsrB8gdyrh0JS-_3nLdpb1WTyak96FhYA>
    <xmx:vWB6XrDIM6PM9UIKsDmOwlB5B0jNq3UVuJ0nxB3Dlh9dSAi7akinbQ>
Received: from splinter.mtl.com (bzq-79-180-94-225.red.bezeqint.net [79.180.94.225])
        by mail.messagingengine.com (Postfix) with ESMTPA id 042BE3065930;
        Tue, 24 Mar 2020 15:34:17 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, kuba@kernel.org,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        roopa@cumulusnetworks.com, nikolay@cumulusnetworks.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 04/15] devlink: Add packet trap group parameters support
Date:   Tue, 24 Mar 2020 21:32:39 +0200
Message-Id: <20200324193250.1322038-5-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200324193250.1322038-1-idosch@idosch.org>
References: <20200324193250.1322038-1-idosch@idosch.org>
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
index ce74adbf0e8b..c344d0f727c7 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -408,10 +408,10 @@ static const struct devlink_trap_policer nsim_trap_policers_arr[] = {
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
index 66c52a2ef2cc..84c28e0f2d90 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -549,6 +549,7 @@ struct devlink_trap_policer {
  * @name: Trap group name.
  * @id: Trap group identifier.
  * @generic: Whether the trap group is generic or not.
+ * @init_policer_id: Initial policer identifier.
  *
  * Describes immutable attributes of packet trap groups that drivers register
  * with devlink.
@@ -557,6 +558,7 @@ struct devlink_trap_group {
 	const char *name;
 	u16 id;
 	bool generic;
+	u32 init_policer_id;
 };
 
 #define DEVLINK_TRAP_METADATA_TYPE_F_IN_PORT	BIT(0)
@@ -734,11 +736,12 @@ enum devlink_trap_group_generic_id {
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
 
 #define DEVLINK_TRAP_POLICER(_id, _rate, _burst)			      \
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 63008d3785dc..4ec7c7578709 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -5473,6 +5473,7 @@ struct devlink_trap_policer_item {
 /**
  * struct devlink_trap_group_item - Packet trap group attributes.
  * @group: Immutable packet trap group attributes.
+ * @policer_item: Associated policer item. Can be NULL.
  * @list: trap_group_list member.
  * @stats: Trap group statistics.
  *
@@ -5481,6 +5482,7 @@ struct devlink_trap_policer_item {
  */
 struct devlink_trap_group_item {
 	const struct devlink_trap_group *group;
+	struct devlink_trap_policer_item *policer_item;
 	struct list_head list;
 	struct devlink_stats __percpu *stats;
 };
@@ -5895,6 +5897,11 @@ devlink_nl_trap_group_fill(struct sk_buff *msg, struct devlink *devlink,
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
@@ -8464,6 +8471,25 @@ void *devlink_trap_ctx_priv(void *trap_ctx)
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
@@ -8486,6 +8512,10 @@ devlink_trap_group_register(struct devlink *devlink,
 
 	group_item->group = group;
 
+	err = devlink_trap_group_item_policer_link(devlink, group_item);
+	if (err)
+		goto err_policer_link;
+
 	if (devlink->ops->trap_group_init) {
 		err = devlink->ops->trap_group_init(devlink, group);
 		if (err)
@@ -8499,6 +8529,7 @@ devlink_trap_group_register(struct devlink *devlink,
 	return 0;
 
 err_group_init:
+err_policer_link:
 	free_percpu(group_item->stats);
 err_stats_alloc:
 	kfree(group_item);
-- 
2.24.1

