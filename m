Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43FBA18EBA5
	for <lists+netdev@lfdr.de>; Sun, 22 Mar 2020 19:50:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726871AbgCVSu2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Mar 2020 14:50:28 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:53599 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726664AbgCVSuZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Mar 2020 14:50:25 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id B53015C0110;
        Sun, 22 Mar 2020 14:50:24 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 22 Mar 2020 14:50:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=mnMChupMWtSkpLptPWs+qoW2GddEzcqLz25AnLkutmw=; b=HkI2fiwC
        dEmzyLWJNinzyt2C4Ra9YBN7P6pxMgI3bexNXRUqnUb8YEnVja1PHNn2R6YEQ4ue
        XtttMehDvitZVWfUQFQSrynwpjyhDFas/uIDpoY8Fy6KQx755eRExn9LEbgGtaqF
        Sf8fj5MMrdrAqirhEMfDM+yoCNCkzmDRIeZ/uBOn5rpeFLTE9/HFdqwNf7x2T6un
        ldj3b/w2nS5udQr1gjh+YgB9QOfkmp3ThvjDKR73K0ewbknTdk4+RqxFGzsr8t0/
        WgIW3XL1GWDNfUQPd96r1/twBvF39QEfxg+hWXCwvYKjDZ6BHQr9/3v6G5meQsin
        LKikY5j9cWQ9Dg==
X-ME-Sender: <xms:cLN3XvP1xgmlR_W7zukQZaSrDr4k7o_wkjrEI0yydjAUWmAxHen_qg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudegiedguddvtdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucfkphepjeelrddukedtrdelgedrvddvheenucevlhhushhtvg
    hrufhiiigvpeefnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhs
    tghhrdhorhhg
X-ME-Proxy: <xmx:cLN3XuP_1wEcoZznHEoPoaU9oodFYRFhEgcXk_kJW22obXMikf_ybg>
    <xmx:cLN3XpTSzFnyAIBOKR65bJxOzyPmZ8Eo_9_P4Gv-i5H_677LSudgyA>
    <xmx:cLN3XoCq1chAWwtmECIEOrara9j9Dr4zV19l8oTzxTqZXTzLEcycTA>
    <xmx:cLN3Xn90bRrhTERS4ku62lt4a0ApXQOO5_1uiGJHak41CMHrqWwYiw>
Received: from splinter.mtl.com (bzq-79-180-94-225.red.bezeqint.net [79.180.94.225])
        by mail.messagingengine.com (Postfix) with ESMTPA id 36827328005A;
        Sun, 22 Mar 2020 14:50:23 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, kuba@kernel.org,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 4/5] devlink: Stop reference counting packet trap groups
Date:   Sun, 22 Mar 2020 20:48:29 +0200
Message-Id: <20200322184830.1254104-5-idosch@idosch.org>
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

Now that drivers explicitly register their supported packet trap groups
there is no for devlink to create them on-demand and destroy them when
their reference count reaches zero.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 net/core/devlink.c | 101 +++------------------------------------------
 1 file changed, 5 insertions(+), 96 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 089a220aabab..a35285a48b02 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -5456,16 +5456,14 @@ struct devlink_stats {
 /**
  * struct devlink_trap_group_item - Packet trap group attributes.
  * @group: Immutable packet trap group attributes.
- * @refcount: Number of trap items using the group.
  * @list: trap_group_list member.
  * @stats: Trap group statistics.
  *
  * Describes packet trap group attributes. Created by devlink during trap
- * registration.
+ * group registration.
  */
 struct devlink_trap_group_item {
 	const struct devlink_trap_group *group;
-	refcount_t refcount;
 	struct list_head list;
 	struct devlink_stats __percpu *stats;
 };
@@ -7937,108 +7935,22 @@ devlink_trap_group_notify(struct devlink *devlink,
 				msg, 0, DEVLINK_MCGRP_CONFIG, GFP_KERNEL);
 }
 
-static struct devlink_trap_group_item *
-devlink_trap_group_item_create(struct devlink *devlink,
-			       const struct devlink_trap_group *group)
-{
-	struct devlink_trap_group_item *group_item;
-	int err;
-
-	err = devlink_trap_group_verify(group);
-	if (err)
-		return ERR_PTR(err);
-
-	group_item = kzalloc(sizeof(*group_item), GFP_KERNEL);
-	if (!group_item)
-		return ERR_PTR(-ENOMEM);
-
-	group_item->stats = netdev_alloc_pcpu_stats(struct devlink_stats);
-	if (!group_item->stats) {
-		err = -ENOMEM;
-		goto err_stats_alloc;
-	}
-
-	group_item->group = group;
-	refcount_set(&group_item->refcount, 1);
-
-	if (devlink->ops->trap_group_init) {
-		err = devlink->ops->trap_group_init(devlink, group);
-		if (err)
-			goto err_group_init;
-	}
-
-	list_add_tail(&group_item->list, &devlink->trap_group_list);
-	devlink_trap_group_notify(devlink, group_item,
-				  DEVLINK_CMD_TRAP_GROUP_NEW);
-
-	return group_item;
-
-err_group_init:
-	free_percpu(group_item->stats);
-err_stats_alloc:
-	kfree(group_item);
-	return ERR_PTR(err);
-}
-
-static void
-devlink_trap_group_item_destroy(struct devlink *devlink,
-				struct devlink_trap_group_item *group_item)
-{
-	devlink_trap_group_notify(devlink, group_item,
-				  DEVLINK_CMD_TRAP_GROUP_DEL);
-	list_del(&group_item->list);
-	free_percpu(group_item->stats);
-	kfree(group_item);
-}
-
-static struct devlink_trap_group_item *
-devlink_trap_group_item_get(struct devlink *devlink,
-			    const struct devlink_trap_group *group)
-{
-	struct devlink_trap_group_item *group_item;
-
-	group_item = devlink_trap_group_item_lookup(devlink, group->name);
-	if (group_item) {
-		refcount_inc(&group_item->refcount);
-		return group_item;
-	}
-
-	return devlink_trap_group_item_create(devlink, group);
-}
-
-static void
-devlink_trap_group_item_put(struct devlink *devlink,
-			    struct devlink_trap_group_item *group_item)
-{
-	if (!refcount_dec_and_test(&group_item->refcount))
-		return;
-
-	devlink_trap_group_item_destroy(devlink, group_item);
-}
-
 static int
 devlink_trap_item_group_link(struct devlink *devlink,
 			     struct devlink_trap_item *trap_item)
 {
+	const struct devlink_trap *trap = trap_item->trap;
 	struct devlink_trap_group_item *group_item;
 
-	group_item = devlink_trap_group_item_get(devlink,
-						 &trap_item->trap->group);
-	if (IS_ERR(group_item))
-		return PTR_ERR(group_item);
+	group_item = devlink_trap_group_item_lookup(devlink, trap->group.name);
+	if (WARN_ON_ONCE(!group_item))
+		return -EINVAL;
 
 	trap_item->group_item = group_item;
 
 	return 0;
 }
 
-static void
-devlink_trap_item_group_unlink(struct devlink *devlink,
-			       struct devlink_trap_item *trap_item)
-{
-	devlink_trap_group_item_put(devlink, trap_item->group_item);
-}
-
 static void devlink_trap_notify(struct devlink *devlink,
 				const struct devlink_trap_item *trap_item,
 				enum devlink_command cmd)
@@ -8101,7 +8013,6 @@ devlink_trap_register(struct devlink *devlink,
 	return 0;
 
 err_trap_init:
-	devlink_trap_item_group_unlink(devlink, trap_item);
 err_group_link:
 	free_percpu(trap_item->stats);
 err_stats_alloc:
@@ -8122,7 +8033,6 @@ static void devlink_trap_unregister(struct devlink *devlink,
 	list_del(&trap_item->list);
 	if (devlink->ops->trap_fini)
 		devlink->ops->trap_fini(devlink, trap, trap_item);
-	devlink_trap_item_group_unlink(devlink, trap_item);
 	free_percpu(trap_item->stats);
 	kfree(trap_item);
 }
@@ -8299,7 +8209,6 @@ devlink_trap_group_register(struct devlink *devlink,
 	}
 
 	group_item->group = group;
-	refcount_set(&group_item->refcount, 1);
 
 	if (devlink->ops->trap_group_init) {
 		err = devlink->ops->trap_group_init(devlink, group);
-- 
2.24.1

