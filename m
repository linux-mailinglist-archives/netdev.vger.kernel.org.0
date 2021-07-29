Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF4C93D9F41
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 10:15:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235054AbhG2IPl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 04:15:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:57002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234917AbhG2IPi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Jul 2021 04:15:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C87D260EBB;
        Thu, 29 Jul 2021 08:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627546535;
        bh=KyjLRDfscOh8u1K820uzrlgW4POL7rThGF5tlhgKuH4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iwa2im8EISOGCfmNsdltwRUWe2+ACsNeKYK0HqjAj0Jdn+ur4uwBsVaAjnXDSnxAs
         AITRGDnQfIH3WHiA1vtge3fxTN6iR/rnvb5YoLMjrFwISWjkeu5RyY+DZXbEwe9jYg
         qra/Jgp6zFMhLHZUYV7u4wtx+hxyeLfO6/eUAk2mHE3fo0S0INZ+tBYdlfqoIIOuz5
         /nJMAI9ozZ2bn2qH/F75nLpbfktLtNIqkJy25L5dSoiO6PGMIat9gR0QlMk8uroape
         R/hMZk9xeAC2oRKeAI8LysW/YsT+bCtaVWoHcPNyRCAJF6MACmKjg5BGsg71SaCNlX
         SN6mdfTQwdfvw==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Parav Pandit <parav@nvidia.com>
Subject: [PATCH net-next 2/2] devlink: Allocate devlink directly in requested net namespace
Date:   Thu, 29 Jul 2021 11:15:26 +0300
Message-Id: <ca29973a59c9c128ab960e3cbff8dfa95280b6b0.1627545799.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1627545799.git.leonro@nvidia.com>
References: <cover.1627545799.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

There is no need in extra call indirection and check from impossible
flow where someone tries to set namespace without prior call
to devlink_alloc().

Instead of this extra logic and additional EXPORT_SYMBOL, use specialized
devlink allocation function that receives net namespace as an argument.

Such specialized API allows clear view when devlink initialized in wrong
net namespace and/or kernel users don't try to change devlink namespace
under the hood.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/net/netdevsim/dev.c |  4 ++--
 include/net/devlink.h       | 14 ++++++++++++--
 net/core/devlink.c          | 26 ++++++++------------------
 3 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index 6348307bfa84..d538a39d4225 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -1431,10 +1431,10 @@ int nsim_dev_probe(struct nsim_bus_dev *nsim_bus_dev)
 	struct devlink *devlink;
 	int err;
 
-	devlink = devlink_alloc(&nsim_dev_devlink_ops, sizeof(*nsim_dev));
+	devlink = devlink_alloc_ns(&nsim_dev_devlink_ops, sizeof(*nsim_dev),
+				   nsim_bus_dev->initial_net);
 	if (!devlink)
 		return -ENOMEM;
-	devlink_net_set(devlink, nsim_bus_dev->initial_net);
 	nsim_dev = devlink_priv(devlink);
 	nsim_dev->nsim_bus_dev = nsim_bus_dev;
 	nsim_dev->switch_id.id_len = sizeof(nsim_dev->switch_id.id);
diff --git a/include/net/devlink.h b/include/net/devlink.h
index e48a62320407..b4691c40320f 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1540,8 +1540,18 @@ static inline struct devlink *netdev_to_devlink(struct net_device *dev)
 struct ib_device;
 
 struct net *devlink_net(const struct devlink *devlink);
-void devlink_net_set(struct devlink *devlink, struct net *net);
-struct devlink *devlink_alloc(const struct devlink_ops *ops, size_t priv_size);
+/* This RAW call is intended for software devices that can
+ * create devlink instance in other namespaces than init_net.
+ *
+ * Drivers that operate on real HW must use devlink_alloc() instead.
+ */
+struct devlink *devlink_alloc_ns(const struct devlink_ops *ops,
+				 size_t priv_size, struct net *net);
+static inline struct devlink *devlink_alloc(const struct devlink_ops *ops,
+					    size_t priv_size)
+{
+	return devlink_alloc_ns(ops, priv_size, &init_net);
+}
 int devlink_register(struct devlink *devlink, struct device *dev);
 void devlink_unregister(struct devlink *devlink);
 void devlink_reload_enable(struct devlink *devlink);
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 54e2a0375539..b419b7a6ec40 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -108,19 +108,6 @@ struct net *devlink_net(const struct devlink *devlink)
 }
 EXPORT_SYMBOL_GPL(devlink_net);
 
-static void __devlink_net_set(struct devlink *devlink, struct net *net)
-{
-	write_pnet(&devlink->_net, net);
-}
-
-void devlink_net_set(struct devlink *devlink, struct net *net)
-{
-	if (WARN_ON(devlink->dev))
-		return;
-	__devlink_net_set(devlink, net);
-}
-EXPORT_SYMBOL_GPL(devlink_net_set);
-
 static struct devlink *devlink_get_from_attrs(struct net *net,
 					      struct nlattr **attrs)
 {
@@ -3920,7 +3907,7 @@ static int devlink_reload(struct devlink *devlink, struct net *dest_net,
 		return err;
 
 	if (dest_net && !net_eq(dest_net, curr_net))
-		__devlink_net_set(devlink, dest_net);
+		write_pnet(&devlink->_net, dest_net);
 
 	err = devlink->ops->reload_up(devlink, action, limit, actions_performed, extack);
 	devlink_reload_failed_set(devlink, !!err);
@@ -8776,15 +8763,18 @@ static bool devlink_reload_actions_valid(const struct devlink_ops *ops)
 }
 
 /**
- *	devlink_alloc - Allocate new devlink instance resources
+ *	devlink_alloc_ns - Allocate new devlink instance resources
+ *	in specific namespace
  *
  *	@ops: ops
  *	@priv_size: size of user private data
+ *	@net: net namespace
  *
  *	Allocate new devlink instance resources, including devlink index
  *	and name.
  */
-struct devlink *devlink_alloc(const struct devlink_ops *ops, size_t priv_size)
+struct devlink *devlink_alloc_ns(const struct devlink_ops *ops,
+				 size_t priv_size, struct net *net)
 {
 	struct devlink *devlink;
 
@@ -8799,7 +8789,7 @@ struct devlink *devlink_alloc(const struct devlink_ops *ops, size_t priv_size)
 		return NULL;
 	devlink->ops = ops;
 	xa_init_flags(&devlink->snapshot_ids, XA_FLAGS_ALLOC);
-	__devlink_net_set(devlink, &init_net);
+	write_pnet(&devlink->_net, net);
 	INIT_LIST_HEAD(&devlink->port_list);
 	INIT_LIST_HEAD(&devlink->rate_list);
 	INIT_LIST_HEAD(&devlink->sb_list);
@@ -8815,7 +8805,7 @@ struct devlink *devlink_alloc(const struct devlink_ops *ops, size_t priv_size)
 	mutex_init(&devlink->reporters_lock);
 	return devlink;
 }
-EXPORT_SYMBOL_GPL(devlink_alloc);
+EXPORT_SYMBOL_GPL(devlink_alloc_ns);
 
 /**
  *	devlink_register - Register devlink instance
-- 
2.31.1

