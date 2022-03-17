Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A60534DBEBF
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 06:52:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229448AbiCQFx6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 01:53:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiCQFx4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 01:53:56 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7016290
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 22:24:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id F01F8CE2084
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 04:20:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0C75C340F4;
        Thu, 17 Mar 2022 04:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647490841;
        bh=88XmnzIfK6yZxMc7k/LvCgHcSr9uvRFkR+rLVI/gdOk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VVtGKd2JYLs7vbFuGlrgosbR6CKe/uFh5YpT7oC7bNl6erpwlLPBB4xHhqvSUSjfi
         kp96V8ndcgJh4FYzwitWBZH4TvZ0lz1f3bjrv2PdXdtaO2C8nluLDHk/kL0doxxWG0
         avTrAc+YMtst4o9D+ikvpXKk7FjNcH12iqx87Sm2P/HQxWLJ4D10wd/5cLzYe5vXwH
         qpc/11giiuzUgf/an+aJff67PVOU1PHVw9HyNmrw8mFHXH73a/NHdYnPzjJbw8S1bc
         fPiwP9BU0a6wQkzPbH3ot90yeLJozbLr50NMODMtddunOCoBY4C3Nz1X+e7rYoMVPj
         CdO/EdKJazQVg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, jiri@resnulli.us, leonro@nvidia.com,
        saeedm@nvidia.com, idosch@idosch.org, michael.chan@broadcom.com,
        simon.horman@corigine.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 2/5] devlink: add explicitly locked flavor of the rate node APIs
Date:   Wed, 16 Mar 2022 21:20:20 -0700
Message-Id: <20220317042023.1470039-3-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220317042023.1470039-1-kuba@kernel.org>
References: <20220317042023.1470039-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We'll need an explicitly locked rate node API for netdevsim
to switch eswitch mode setting to locked.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 include/net/devlink.h |  4 ++
 net/core/devlink.c    | 86 ++++++++++++++++++++++++++++++-------------
 2 files changed, 65 insertions(+), 25 deletions(-)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index fd89a17adea1..a30180c0988a 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1490,6 +1490,10 @@ int devl_port_register(struct devlink *devlink,
 		       unsigned int port_index);
 void devl_port_unregister(struct devlink_port *devlink_port);
 
+int devl_rate_leaf_create(struct devlink_port *port, void *priv);
+void devl_rate_leaf_destroy(struct devlink_port *devlink_port);
+void devl_rate_nodes_destroy(struct devlink *devlink);
+
 struct ib_device;
 
 struct net *devlink_net(const struct devlink *devlink);
diff --git a/net/core/devlink.c b/net/core/devlink.c
index f2a277053ec6..5aac5370c136 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -2868,7 +2868,7 @@ static int devlink_rate_nodes_check(struct devlink *devlink, u16 mode,
 {
 	struct devlink_rate *devlink_rate;
 
-	/* Take the lock to sync with devlink_rate_nodes_destroy() */
+	/* Take the lock to sync with destroy */
 	mutex_lock(&devlink->lock);
 	list_for_each_entry(devlink_rate, &devlink->rate_list, list)
 		if (devlink_rate_is_node(devlink_rate)) {
@@ -9548,30 +9548,26 @@ void devlink_port_attrs_pci_sf_set(struct devlink_port *devlink_port, u32 contro
 EXPORT_SYMBOL_GPL(devlink_port_attrs_pci_sf_set);
 
 /**
- * devlink_rate_leaf_create - create devlink rate leaf
- *
+ * devl_rate_leaf_create - create devlink rate leaf
  * @devlink_port: devlink port object to create rate object on
  * @priv: driver private data
  *
  * Create devlink rate object of type leaf on provided @devlink_port.
- * Throws call trace if @devlink_port already has a devlink rate object.
- *
- * Context: Takes and release devlink->lock <mutex>.
- *
- * Return: -ENOMEM if failed to allocate rate object, 0 otherwise.
  */
-int
-devlink_rate_leaf_create(struct devlink_port *devlink_port, void *priv)
+int devl_rate_leaf_create(struct devlink_port *devlink_port, void *priv)
 {
 	struct devlink *devlink = devlink_port->devlink;
 	struct devlink_rate *devlink_rate;
 
+	devl_assert_locked(devlink_port->devlink);
+
+	if (WARN_ON(devlink_port->devlink_rate))
+		return -EBUSY;
+
 	devlink_rate = kzalloc(sizeof(*devlink_rate), GFP_KERNEL);
 	if (!devlink_rate)
 		return -ENOMEM;
 
-	mutex_lock(&devlink->lock);
-	WARN_ON(devlink_port->devlink_rate);
 	devlink_rate->type = DEVLINK_RATE_TYPE_LEAF;
 	devlink_rate->devlink = devlink;
 	devlink_rate->devlink_port = devlink_port;
@@ -9579,12 +9575,42 @@ devlink_rate_leaf_create(struct devlink_port *devlink_port, void *priv)
 	list_add_tail(&devlink_rate->list, &devlink->rate_list);
 	devlink_port->devlink_rate = devlink_rate;
 	devlink_rate_notify(devlink_rate, DEVLINK_CMD_RATE_NEW);
-	mutex_unlock(&devlink->lock);
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(devl_rate_leaf_create);
+
+int
+devlink_rate_leaf_create(struct devlink_port *devlink_port, void *priv)
+{
+	struct devlink *devlink = devlink_port->devlink;
+	int ret;
+
+	mutex_lock(&devlink->lock);
+	ret = devl_rate_leaf_create(devlink_port, priv);
+	mutex_unlock(&devlink->lock);
+
+	return ret;
+}
 EXPORT_SYMBOL_GPL(devlink_rate_leaf_create);
 
+void devl_rate_leaf_destroy(struct devlink_port *devlink_port)
+{
+	struct devlink_rate *devlink_rate = devlink_port->devlink_rate;
+
+	devl_assert_locked(devlink_port->devlink);
+	if (!devlink_rate)
+		return;
+
+	devlink_rate_notify(devlink_rate, DEVLINK_CMD_RATE_DEL);
+	if (devlink_rate->parent)
+		refcount_dec(&devlink_rate->parent->refcnt);
+	list_del(&devlink_rate->list);
+	devlink_port->devlink_rate = NULL;
+	kfree(devlink_rate);
+}
+EXPORT_SYMBOL_GPL(devl_rate_leaf_destroy);
+
 /**
  * devlink_rate_leaf_destroy - destroy devlink rate leaf
  *
@@ -9601,32 +9627,25 @@ void devlink_rate_leaf_destroy(struct devlink_port *devlink_port)
 		return;
 
 	mutex_lock(&devlink->lock);
-	devlink_rate_notify(devlink_rate, DEVLINK_CMD_RATE_DEL);
-	if (devlink_rate->parent)
-		refcount_dec(&devlink_rate->parent->refcnt);
-	list_del(&devlink_rate->list);
-	devlink_port->devlink_rate = NULL;
+	devl_rate_leaf_destroy(devlink_port);
 	mutex_unlock(&devlink->lock);
-	kfree(devlink_rate);
 }
 EXPORT_SYMBOL_GPL(devlink_rate_leaf_destroy);
 
 /**
- * devlink_rate_nodes_destroy - destroy all devlink rate nodes on device
- *
+ * devl_rate_nodes_destroy - destroy all devlink rate nodes on device
  * @devlink: devlink instance
  *
  * Unset parent for all rate objects and destroy all rate nodes
  * on specified device.
- *
- * Context: Takes and release devlink->lock <mutex>.
  */
-void devlink_rate_nodes_destroy(struct devlink *devlink)
+void devl_rate_nodes_destroy(struct devlink *devlink)
 {
 	static struct devlink_rate *devlink_rate, *tmp;
 	const struct devlink_ops *ops = devlink->ops;
 
-	mutex_lock(&devlink->lock);
+	devl_assert_locked(devlink);
+
 	list_for_each_entry(devlink_rate, &devlink->rate_list, list) {
 		if (!devlink_rate->parent)
 			continue;
@@ -9647,6 +9666,23 @@ void devlink_rate_nodes_destroy(struct devlink *devlink)
 			kfree(devlink_rate);
 		}
 	}
+}
+EXPORT_SYMBOL_GPL(devl_rate_nodes_destroy);
+
+/**
+ * devlink_rate_nodes_destroy - destroy all devlink rate nodes on device
+ *
+ * @devlink: devlink instance
+ *
+ * Unset parent for all rate objects and destroy all rate nodes
+ * on specified device.
+ *
+ * Context: Takes and release devlink->lock <mutex>.
+ */
+void devlink_rate_nodes_destroy(struct devlink *devlink)
+{
+	mutex_lock(&devlink->lock);
+	devl_rate_nodes_destroy(devlink);
 	mutex_unlock(&devlink->lock);
 }
 EXPORT_SYMBOL_GPL(devlink_rate_nodes_destroy);
-- 
2.34.1

