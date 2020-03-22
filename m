Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8FEE18EBA2
	for <lists+netdev@lfdr.de>; Sun, 22 Mar 2020 19:50:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726786AbgCVSuW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Mar 2020 14:50:22 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:33385 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725881AbgCVSuV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Mar 2020 14:50:21 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 03C775C009A;
        Sun, 22 Mar 2020 14:50:20 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 22 Mar 2020 14:50:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=jcuN0mlUAdrlJ/Aod5fYZDKxoSzNRpElcZClV9qBvnQ=; b=2UXKGufq
        XTuoefvH0IJ/of140ReZbsbjo0mAPpfguka56Y+disqzHHChtbl3cFuu+s7Hiou/
        BGMyAvYRUnW8ULUxq79nlqoVFHU2KAN/5/elDbxuLWETVUdIDhMYz4IK4ZPwtWW+
        7Ld8Crh8C09bOc2/8UTK01mPBfHngJ+39/iseifszvlUwckvhYLGgpztrPxEU01P
        WtDDBT9THh8+QJ4eZ+luyD6pJvRHFBLnlD8PJDaCHl4FbmAQBcACmokgY41qb2ac
        TO9JVI1liklb3YudMoYnfh/k8e3hQwaWAVXBA4pRcC+7zLE678sydxIf786uy+SY
        cxgjycYpqksdRw==
X-ME-Sender: <xms:a7N3XgIB8qZXM5rYHHdLQFhgDMhVEtPWXUCl5R2WzOQbGrGY9F3G8w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudegiedguddvtdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucfkphepjeelrddukedtrdelgedrvddvheenucevlhhushhtvg
    hrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhs
    tghhrdhorhhg
X-ME-Proxy: <xmx:a7N3XkYv78yv61hFX_TfOpMxAj6dvQHsKDZCjTZrJTlF-BNOtz8KCQ>
    <xmx:a7N3XrvxgjCBLesYKGj2GjWFZwMSYRHXBhpHIuo5WgaeFPN2TICYmg>
    <xmx:a7N3Xhv4UV7uxzFt7csp2AlUCXPo0-0OwfcQXiCzJaZqpcJrXVw7Tw>
    <xmx:bLN3Xnq6DRCbdUtizm34Xi8enDqW9Fc22tT0IuMR3xRV1TT9u1idJw>
Received: from splinter.mtl.com (bzq-79-180-94-225.red.bezeqint.net [79.180.94.225])
        by mail.messagingengine.com (Postfix) with ESMTPA id DA9EE3280063;
        Sun, 22 Mar 2020 14:50:17 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, kuba@kernel.org,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 1/5] devlink: Add API to register packet trap groups
Date:   Sun, 22 Mar 2020 20:48:26 +0200
Message-Id: <20200322184830.1254104-2-idosch@idosch.org>
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

Currently, packet trap groups are implicitly registered by drivers upon
packet trap registration. When the traps are registered, each is
associated with a group and the group is created by devlink, if it does
not exist already.

This makes it difficult for drivers to pass additional attributes for
the groups.

Therefore, as a preparation for future patches that require passing
additional group attributes, add an API to explicitly register /
unregister these groups.

Next patches will convert existing drivers to use this API.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 include/net/devlink.h |   6 +++
 net/core/devlink.c    | 117 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 123 insertions(+)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index c9ca86b054bc..de3289217b9a 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1055,6 +1055,12 @@ void devlink_trap_report(struct devlink *devlink, struct sk_buff *skb,
 			 void *trap_ctx, struct devlink_port *in_devlink_port,
 			 const struct flow_action_cookie *fa_cookie);
 void *devlink_trap_ctx_priv(void *trap_ctx);
+int devlink_trap_groups_register(struct devlink *devlink,
+				 const struct devlink_trap_group *groups,
+				 size_t groups_count);
+void devlink_trap_groups_unregister(struct devlink *devlink,
+				    const struct devlink_trap_group *groups,
+				    size_t groups_count);
 
 #if IS_ENABLED(CONFIG_NET_DEVLINK)
 
diff --git a/net/core/devlink.c b/net/core/devlink.c
index f51bebc8c33f..089a220aabab 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -8278,6 +8278,123 @@ void *devlink_trap_ctx_priv(void *trap_ctx)
 }
 EXPORT_SYMBOL_GPL(devlink_trap_ctx_priv);
 
+static int
+devlink_trap_group_register(struct devlink *devlink,
+			    const struct devlink_trap_group *group)
+{
+	struct devlink_trap_group_item *group_item;
+	int err;
+
+	if (devlink_trap_group_item_lookup(devlink, group->name))
+		return -EEXIST;
+
+	group_item = kzalloc(sizeof(*group_item), GFP_KERNEL);
+	if (!group_item)
+		return -ENOMEM;
+
+	group_item->stats = netdev_alloc_pcpu_stats(struct devlink_stats);
+	if (!group_item->stats) {
+		err = -ENOMEM;
+		goto err_stats_alloc;
+	}
+
+	group_item->group = group;
+	refcount_set(&group_item->refcount, 1);
+
+	if (devlink->ops->trap_group_init) {
+		err = devlink->ops->trap_group_init(devlink, group);
+		if (err)
+			goto err_group_init;
+	}
+
+	list_add_tail(&group_item->list, &devlink->trap_group_list);
+	devlink_trap_group_notify(devlink, group_item,
+				  DEVLINK_CMD_TRAP_GROUP_NEW);
+
+	return 0;
+
+err_group_init:
+	free_percpu(group_item->stats);
+err_stats_alloc:
+	kfree(group_item);
+	return err;
+}
+
+static void
+devlink_trap_group_unregister(struct devlink *devlink,
+			      const struct devlink_trap_group *group)
+{
+	struct devlink_trap_group_item *group_item;
+
+	group_item = devlink_trap_group_item_lookup(devlink, group->name);
+	if (WARN_ON_ONCE(!group_item))
+		return;
+
+	devlink_trap_group_notify(devlink, group_item,
+				  DEVLINK_CMD_TRAP_GROUP_DEL);
+	list_del(&group_item->list);
+	free_percpu(group_item->stats);
+	kfree(group_item);
+}
+
+/**
+ * devlink_trap_groups_register - Register packet trap groups with devlink.
+ * @devlink: devlink.
+ * @groups: Packet trap groups.
+ * @groups_count: Count of provided packet trap groups.
+ *
+ * Return: Non-zero value on failure.
+ */
+int devlink_trap_groups_register(struct devlink *devlink,
+				 const struct devlink_trap_group *groups,
+				 size_t groups_count)
+{
+	int i, err;
+
+	mutex_lock(&devlink->lock);
+	for (i = 0; i < groups_count; i++) {
+		const struct devlink_trap_group *group = &groups[i];
+
+		err = devlink_trap_group_verify(group);
+		if (err)
+			goto err_trap_group_verify;
+
+		err = devlink_trap_group_register(devlink, group);
+		if (err)
+			goto err_trap_group_register;
+	}
+	mutex_unlock(&devlink->lock);
+
+	return 0;
+
+err_trap_group_register:
+err_trap_group_verify:
+	for (i--; i >= 0; i--)
+		devlink_trap_group_unregister(devlink, &groups[i]);
+	mutex_unlock(&devlink->lock);
+	return err;
+}
+EXPORT_SYMBOL_GPL(devlink_trap_groups_register);
+
+/**
+ * devlink_trap_groups_unregister - Unregister packet trap groups from devlink.
+ * @devlink: devlink.
+ * @groups: Packet trap groups.
+ * @groups_count: Count of provided packet trap groups.
+ */
+void devlink_trap_groups_unregister(struct devlink *devlink,
+				    const struct devlink_trap_group *groups,
+				    size_t groups_count)
+{
+	int i;
+
+	mutex_lock(&devlink->lock);
+	for (i = groups_count - 1; i >= 0; i--)
+		devlink_trap_group_unregister(devlink, &groups[i]);
+	mutex_unlock(&devlink->lock);
+}
+EXPORT_SYMBOL_GPL(devlink_trap_groups_unregister);
+
 static void __devlink_compat_running_version(struct devlink *devlink,
 					     char *buf, size_t len)
 {
-- 
2.24.1

