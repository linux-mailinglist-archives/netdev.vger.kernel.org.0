Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A82B23AA3F
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 18:13:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728310AbgHCQMh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 12:12:37 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:43119 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725945AbgHCQMg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 12:12:36 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 6252F5C00D2;
        Mon,  3 Aug 2020 12:12:35 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 03 Aug 2020 12:12:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=J1+TjakhgA96OhohyJWjp3m6egvk+jtyZ+VL/6azGh0=; b=dIGRIFGr
        JXwmnRc6Inti933RlbiV2cMUoW5+BhpK7gflD5p2E2gIziwTCAm+HTW2MNBG6Xs8
        EO+IdtmvqbXQFWYMyYqvnKLx2ue24b9/hZ4ZpbaFQR0UZQ7G7OW4DQmYR3BOthgJ
        6nlrQUpJ7R6cegmRALecrfQM9wtW6dbe8j05P6dpLC0suLBhxkdotp96G97/5+L9
        hjLFK8gCcnA+P6dvzMkvq/tvXzk1/J0Ic/h0zfyGlhRoqvmcBPpigWPIHiCJmrf5
        sk0SeMSlQaZQUKDYXr9Qt6oKlx1l5SJAUn3xASdpTN719UeS7JZW40Ppanctgtgx
        VQEv+5YnvOdraA==
X-ME-Sender: <xms:czcoX8Bb3uy_yXW6fqNBg3RNKQSfcFV2DOnDmyx1_YbhnGg8_u44Fg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrjeeggdelkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucfkphepjeelrddukedurdeirddvudelnecu
    vehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstg
    hhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:czcoX-isEf5lKRrN13ZKIAzN6f8rGKf-xgCUbO7ZIygtwv1X5VhchA>
    <xmx:czcoX_lmH5wkCznghgx0sR-nSnRcOYjSssLXPfyWmivKk_FT9c2GAA>
    <xmx:czcoXyz6UdAfIPErVW7TTYvw95gf7Y32OQe9cTsdn_pjzDWYJGr65g>
    <xmx:czcoXzckA4fda_fhbrT1KfcjrvViAdhKcTKt8EVr8qux3s_YBHPwHg>
Received: from shredder.mtl.com (bzq-79-181-6-219.red.bezeqint.net [79.181.6.219])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0F1563060067;
        Mon,  3 Aug 2020 12:12:32 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        petrm@mellanox.com, amitc@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 2/9] devlink: Pass extack when setting trap's action and group's parameters
Date:   Mon,  3 Aug 2020 19:11:34 +0300
Message-Id: <20200803161141.2523857-3-idosch@idosch.org>
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

A later patch will refuse to set the action of certain traps in mlxsw
and also to change the policer binding of certain groups. Pass extack so
that failure could be communicated clearly to user space.

Reviewed-by: Petr Machata <petrm@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Petr Machata <petrm@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core.c          | 10 ++++++----
 drivers/net/ethernet/mellanox/mlxsw/core.h          |  6 ++++--
 drivers/net/ethernet/mellanox/mlxsw/spectrum.h      |  6 ++++--
 drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c | 13 ++++++++-----
 drivers/net/netdevsim/dev.c                         |  6 ++++--
 include/net/devlink.h                               |  6 ++++--
 net/core/devlink.c                                  |  8 +++++---
 7 files changed, 35 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index 866381e72960..08d101138fbe 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -1177,14 +1177,15 @@ static void mlxsw_devlink_trap_fini(struct devlink *devlink,
 
 static int mlxsw_devlink_trap_action_set(struct devlink *devlink,
 					 const struct devlink_trap *trap,
-					 enum devlink_trap_action action)
+					 enum devlink_trap_action action,
+					 struct netlink_ext_ack *extack)
 {
 	struct mlxsw_core *mlxsw_core = devlink_priv(devlink);
 	struct mlxsw_driver *mlxsw_driver = mlxsw_core->driver;
 
 	if (!mlxsw_driver->trap_action_set)
 		return -EOPNOTSUPP;
-	return mlxsw_driver->trap_action_set(mlxsw_core, trap, action);
+	return mlxsw_driver->trap_action_set(mlxsw_core, trap, action, extack);
 }
 
 static int
@@ -1202,14 +1203,15 @@ mlxsw_devlink_trap_group_init(struct devlink *devlink,
 static int
 mlxsw_devlink_trap_group_set(struct devlink *devlink,
 			     const struct devlink_trap_group *group,
-			     const struct devlink_trap_policer *policer)
+			     const struct devlink_trap_policer *policer,
+			     struct netlink_ext_ack *extack)
 {
 	struct mlxsw_core *mlxsw_core = devlink_priv(devlink);
 	struct mlxsw_driver *mlxsw_driver = mlxsw_core->driver;
 
 	if (!mlxsw_driver->trap_group_set)
 		return -EOPNOTSUPP;
-	return mlxsw_driver->trap_group_set(mlxsw_core, group, policer);
+	return mlxsw_driver->trap_group_set(mlxsw_core, group, policer, extack);
 }
 
 static int
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.h b/drivers/net/ethernet/mellanox/mlxsw/core.h
index c1c1e039323a..219ce89e629a 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.h
@@ -326,12 +326,14 @@ struct mlxsw_driver {
 			  const struct devlink_trap *trap, void *trap_ctx);
 	int (*trap_action_set)(struct mlxsw_core *mlxsw_core,
 			       const struct devlink_trap *trap,
-			       enum devlink_trap_action action);
+			       enum devlink_trap_action action,
+			       struct netlink_ext_ack *extack);
 	int (*trap_group_init)(struct mlxsw_core *mlxsw_core,
 			       const struct devlink_trap_group *group);
 	int (*trap_group_set)(struct mlxsw_core *mlxsw_core,
 			      const struct devlink_trap_group *group,
-			      const struct devlink_trap_policer *policer);
+			      const struct devlink_trap_policer *policer,
+			      struct netlink_ext_ack *extack);
 	int (*trap_policer_init)(struct mlxsw_core *mlxsw_core,
 				 const struct devlink_trap_policer *policer);
 	void (*trap_policer_fini)(struct mlxsw_core *mlxsw_core,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index 6ab1b6d725af..866a1193f12b 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -1177,12 +1177,14 @@ void mlxsw_sp_trap_fini(struct mlxsw_core *mlxsw_core,
 			const struct devlink_trap *trap, void *trap_ctx);
 int mlxsw_sp_trap_action_set(struct mlxsw_core *mlxsw_core,
 			     const struct devlink_trap *trap,
-			     enum devlink_trap_action action);
+			     enum devlink_trap_action action,
+			     struct netlink_ext_ack *extack);
 int mlxsw_sp_trap_group_init(struct mlxsw_core *mlxsw_core,
 			     const struct devlink_trap_group *group);
 int mlxsw_sp_trap_group_set(struct mlxsw_core *mlxsw_core,
 			    const struct devlink_trap_group *group,
-			    const struct devlink_trap_policer *policer);
+			    const struct devlink_trap_policer *policer,
+			    struct netlink_ext_ack *extack);
 int
 mlxsw_sp_trap_policer_init(struct mlxsw_core *mlxsw_core,
 			   const struct devlink_trap_policer *policer);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
index 1e38dfe7cf64..00b6cb9d2306 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
@@ -1352,7 +1352,8 @@ void mlxsw_sp_trap_fini(struct mlxsw_core *mlxsw_core,
 
 int mlxsw_sp_trap_action_set(struct mlxsw_core *mlxsw_core,
 			     const struct devlink_trap *trap,
-			     enum devlink_trap_action action)
+			     enum devlink_trap_action action,
+			     struct netlink_ext_ack *extack)
 {
 	struct mlxsw_sp *mlxsw_sp = mlxsw_core_driver_priv(mlxsw_core);
 	const struct mlxsw_sp_trap_item *trap_item;
@@ -1392,7 +1393,7 @@ int mlxsw_sp_trap_action_set(struct mlxsw_core *mlxsw_core,
 static int
 __mlxsw_sp_trap_group_init(struct mlxsw_core *mlxsw_core,
 			   const struct devlink_trap_group *group,
-			   u32 policer_id)
+			   u32 policer_id, struct netlink_ext_ack *extack)
 {
 	struct mlxsw_sp *mlxsw_sp = mlxsw_core_driver_priv(mlxsw_core);
 	u16 hw_policer_id = MLXSW_REG_HTGT_INVALID_POLICER;
@@ -1422,16 +1423,18 @@ int mlxsw_sp_trap_group_init(struct mlxsw_core *mlxsw_core,
 			     const struct devlink_trap_group *group)
 {
 	return __mlxsw_sp_trap_group_init(mlxsw_core, group,
-					  group->init_policer_id);
+					  group->init_policer_id, NULL);
 }
 
 int mlxsw_sp_trap_group_set(struct mlxsw_core *mlxsw_core,
 			    const struct devlink_trap_group *group,
-			    const struct devlink_trap_policer *policer)
+			    const struct devlink_trap_policer *policer,
+			    struct netlink_ext_ack *extack)
 {
 	u32 policer_id = policer ? policer->id : 0;
 
-	return __mlxsw_sp_trap_group_init(mlxsw_core, group, policer_id);
+	return __mlxsw_sp_trap_group_init(mlxsw_core, group, policer_id,
+					  extack);
 }
 
 static int
diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index ce719c830a77..32f339fedb21 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -810,7 +810,8 @@ static int nsim_dev_devlink_trap_init(struct devlink *devlink,
 static int
 nsim_dev_devlink_trap_action_set(struct devlink *devlink,
 				 const struct devlink_trap *trap,
-				 enum devlink_trap_action action)
+				 enum devlink_trap_action action,
+				 struct netlink_ext_ack *extack)
 {
 	struct nsim_dev *nsim_dev = devlink_priv(devlink);
 	struct nsim_trap_item *nsim_trap_item;
@@ -829,7 +830,8 @@ nsim_dev_devlink_trap_action_set(struct devlink *devlink,
 static int
 nsim_dev_devlink_trap_group_set(struct devlink *devlink,
 				const struct devlink_trap_group *group,
-				const struct devlink_trap_policer *policer)
+				const struct devlink_trap_policer *policer,
+				struct netlink_ext_ack *extack)
 {
 	struct nsim_dev *nsim_dev = devlink_priv(devlink);
 
diff --git a/include/net/devlink.h b/include/net/devlink.h
index fd3ae0760492..8f3c8a443238 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1077,7 +1077,8 @@ struct devlink_ops {
 	 */
 	int (*trap_action_set)(struct devlink *devlink,
 			       const struct devlink_trap *trap,
-			       enum devlink_trap_action action);
+			       enum devlink_trap_action action,
+			       struct netlink_ext_ack *extack);
 	/**
 	 * @trap_group_init: Trap group initialization function.
 	 *
@@ -1094,7 +1095,8 @@ struct devlink_ops {
 	 */
 	int (*trap_group_set)(struct devlink *devlink,
 			      const struct devlink_trap_group *group,
-			      const struct devlink_trap_policer *policer);
+			      const struct devlink_trap_policer *policer,
+			      struct netlink_ext_ack *extack);
 	/**
 	 * @trap_policer_init: Trap policer initialization function.
 	 *
diff --git a/net/core/devlink.c b/net/core/devlink.c
index bde4c29a30bc..e674f0f46dc2 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -6423,7 +6423,7 @@ static int __devlink_trap_action_set(struct devlink *devlink,
 	}
 
 	err = devlink->ops->trap_action_set(devlink, trap_item->trap,
-					    trap_action);
+					    trap_action, extack);
 	if (err)
 		return err;
 
@@ -6713,7 +6713,8 @@ static int devlink_trap_group_set(struct devlink *devlink,
 	}
 	policer = policer_item ? policer_item->policer : NULL;
 
-	err = devlink->ops->trap_group_set(devlink, group_item->group, policer);
+	err = devlink->ops->trap_group_set(devlink, group_item->group, policer,
+					   extack);
 	if (err)
 		return err;
 
@@ -9051,7 +9052,8 @@ static void devlink_trap_disable(struct devlink *devlink,
 	if (WARN_ON_ONCE(!trap_item))
 		return;
 
-	devlink->ops->trap_action_set(devlink, trap, DEVLINK_TRAP_ACTION_DROP);
+	devlink->ops->trap_action_set(devlink, trap, DEVLINK_TRAP_ACTION_DROP,
+				      NULL);
 	trap_item->action = DEVLINK_TRAP_ACTION_DROP;
 }
 
-- 
2.26.2

