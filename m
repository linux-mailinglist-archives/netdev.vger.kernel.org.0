Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0EF2440C44
	for <lists+netdev@lfdr.de>; Sun, 31 Oct 2021 01:13:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232041AbhJ3XPb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Oct 2021 19:15:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:36712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231958AbhJ3XP3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 30 Oct 2021 19:15:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 01F9960F4B;
        Sat, 30 Oct 2021 23:12:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635635579;
        bh=JXf3u9i9Y5JVds4HR2Anbw7HFpyl4t4I1IPXwbkJ4VM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jjWidydxrN4iU2XXm6zMsU23FWonFo9++ubB0dA+HqtWeRmtnipugtd5rA2yxFX2+
         sqWIrXdlVI2UZvUL3CDu3thltwthJX/QSYpX93mwJ1fH2QN8KH5EV0+ebAsldEL+/D
         iW8o/jcSBF5DnN6ukjSmoJ3qHHST2dutdc54AF679Y5sPagW2oSlpQuqUYVC4qN9Xd
         rT3dQb+0XYb+G7yO8pht8x0DiwtZDO3aeVw3G3miurmXU2skJS4u01HzPfwPJrFV2n
         6MAHh+CONSyAtySNqFHJS1XBaY4uElcGyfSkzWKlDawHn3GBxbjKo36167SI6JKZi+
         s01oEVX9sgxMg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     leon@kernel.org, idosch@idosch.org
Cc:     edwin.peer@broadcom.com, jiri@resnulli.us, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [RFC 2/5] devlink: add API for explicit locking
Date:   Sat, 30 Oct 2021 16:12:51 -0700
Message-Id: <20211030231254.2477599-3-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211030231254.2477599-1-kuba@kernel.org>
References: <20211030231254.2477599-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Expose devlink instance lock and create the registration
helpers as needed. The new unregistration helper does
not wait for all refs to be gone, and free just gives
up the reference instead of actually freeing the memory.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 include/net/devlink.h |  16 ++++++
 net/core/devlink.c    | 122 +++++++++++++++++++++++++++++++++++++++---
 2 files changed, 130 insertions(+), 8 deletions(-)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index d8e4274e2af4..66c1951a6f0e 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1191,6 +1191,7 @@ enum {
 };
 
 struct devlink_ops {
+	struct module *owner;
 	/**
 	 * @supported_flash_update_params:
 	 * mask of parameters supported by the driver's .flash_update
@@ -1490,6 +1491,8 @@ void *devlink_priv(struct devlink *devlink);
 struct devlink *priv_to_devlink(void *priv);
 struct device *devlink_to_dev(const struct devlink *devlink);
 
+int lockdep_devlink_is_held(struct devlink *devlink);
+
 struct ib_device;
 
 struct net *devlink_net(const struct devlink *devlink);
@@ -1507,10 +1510,23 @@ static inline struct devlink *devlink_alloc(const struct devlink_ops *ops,
 {
 	return devlink_alloc_ns(ops, priv_size, &init_net, dev);
 }
+
+void devlink_lock(struct devlink *devlink);
+void devlink_unlock(struct devlink *devlink);
+
+void devlink_lock_reg(struct devlink *devlink);
+void devlink_unlock_reg(struct devlink *devlink);
+
+void devlink_get(struct devlink *devlink);
+bool devlink_is_alive(const struct devlink *devlink);
+
 void devlink_set_features(struct devlink *devlink, u64 features);
 void devlink_register(struct devlink *devlink);
+void __devlink_register(struct devlink *devlink);
 void devlink_unregister(struct devlink *devlink);
+void __devlink_unregister(struct devlink *devlink);
 void devlink_free(struct devlink *devlink);
+void __devlink_free(struct devlink *devlink);
 int devlink_port_register(struct devlink *devlink,
 			  struct devlink_port *devlink_port,
 			  unsigned int port_index);
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 9ea0c0bbc796..6783b066f9a7 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -182,11 +182,24 @@ struct net *devlink_net(const struct devlink *devlink)
 }
 EXPORT_SYMBOL_GPL(devlink_net);
 
+void devlink_free(struct devlink *devlink);
+
 void devlink_put(struct devlink *devlink)
 {
-	if (refcount_dec_and_test(&devlink->refcount))
-		complete(&devlink->comp);
+	if (refcount_dec_and_test(&devlink->refcount)) {
+		if (devlink->ops->lock_flags & DEVLINK_LOCK_REF_MODE)
+			devlink_free(devlink);
+		else
+			complete(&devlink->comp);
+	}
 }
+EXPORT_SYMBOL_GPL(devlink_put);
+
+void devlink_get(struct devlink *devlink)
+{
+	refcount_inc(&devlink->refcount);
+}
+EXPORT_SYMBOL_GPL(devlink_get);
 
 struct devlink *__must_check devlink_try_get(struct devlink *devlink)
 {
@@ -195,6 +208,60 @@ struct devlink *__must_check devlink_try_get(struct devlink *devlink)
 	return NULL;
 }
 
+bool devlink_is_alive(const struct devlink *devlink)
+{
+	return xa_get_mark(&devlinks, devlink->index, DEVLINK_REGISTERED);
+}
+EXPORT_SYMBOL_GPL(devlink_is_alive);
+
+/**
+ * devlink_lock_reg() - take devlink registration lock as well as instance lock
+ * @devlink: instance to lock
+ */
+void devlink_lock_reg(struct devlink *devlink)
+{
+	mutex_lock(&devlink_mutex);
+	mutex_lock(&devlink->lock);
+}
+EXPORT_SYMBOL_GPL(devlink_lock_reg);
+
+/**
+ * devlink_unlock_reg()
+ * @devlink: instance to lock
+ */
+void devlink_unlock_reg(struct devlink *devlink)
+{
+	mutex_unlock(&devlink->lock);
+	mutex_unlock(&devlink_mutex);
+}
+EXPORT_SYMBOL_GPL(devlink_unlock_reg);
+
+/**
+ * devlink_lock() - lock devlink instance
+ * @devlink: instance to lock
+ */
+void devlink_lock(struct devlink *devlink)
+{
+	mutex_lock(&devlink->lock);
+}
+EXPORT_SYMBOL_GPL(devlink_lock);
+
+/**
+ * devlink_unlock() - release devlink instance lock
+ * @devlink: instance to unlock
+ */
+void devlink_unlock(struct devlink *devlink)
+{
+	mutex_unlock(&devlink->lock);
+}
+EXPORT_SYMBOL_GPL(devlink_unlock);
+
+int lockdep_devlink_is_held(struct devlink *devlink)
+{
+	return lockdep_is_held(&devlink->lock);
+}
+EXPORT_SYMBOL_GPL(lockdep_devlink_is_held);
+
 static struct devlink *devlink_get_from_attrs(struct net *net,
 					      struct nlattr **attrs)
 {
@@ -9016,6 +9083,7 @@ struct devlink *devlink_alloc_ns(const struct devlink_ops *ops,
 	mutex_init(&devlink->reporters_lock);
 	refcount_set(&devlink->refcount, 1);
 	init_completion(&devlink->comp);
+	__module_get(devlink->ops->owner);
 
 	return devlink;
 }
@@ -9105,6 +9173,18 @@ static void devlink_notify_unregister(struct devlink *devlink)
 	devlink_notify(devlink, DEVLINK_CMD_DEL);
 }
 
+void __devlink_register(struct devlink *devlink)
+{
+	ASSERT_DEVLINK_NOT_REGISTERED(devlink);
+	lockdep_assert_held(&devlink->lock);
+	lockdep_assert_held(&devlink_mutex);
+	/* Make sure that we are in .probe() routine */
+
+	xa_set_mark(&devlinks, devlink->index, DEVLINK_REGISTERED);
+	devlink_notify_register(devlink);
+}
+EXPORT_SYMBOL_GPL(__devlink_register);
+
 /**
  *	devlink_register - Register devlink instance
  *
@@ -9112,16 +9192,27 @@ static void devlink_notify_unregister(struct devlink *devlink)
  */
 void devlink_register(struct devlink *devlink)
 {
-	ASSERT_DEVLINK_NOT_REGISTERED(devlink);
-	/* Make sure that we are in .probe() routine */
-
 	mutex_lock(&devlink_mutex);
-	xa_set_mark(&devlinks, devlink->index, DEVLINK_REGISTERED);
-	devlink_notify_register(devlink);
+	__devlink_register(devlink);
 	mutex_unlock(&devlink_mutex);
 }
 EXPORT_SYMBOL_GPL(devlink_register);
 
+/* Note: this is NOT an equivalent to devlink_unregister() sans locking
+ * it also accounts for the ability to take references on the instance.
+ */
+void __devlink_unregister(struct devlink *devlink)
+{
+	ASSERT_DEVLINK_REGISTERED(devlink);
+	/* Make sure that we are in .remove() routine */
+	WARN_ON(!(devlink->ops->lock_flags & DEVLINK_LOCK_REF_MODE));
+	lockdep_assert_held(&devlink->lock);
+
+	devlink_notify_unregister(devlink);
+	xa_clear_mark(&devlinks, devlink->index, DEVLINK_REGISTERED);
+}
+EXPORT_SYMBOL_GPL(__devlink_unregister);
+
 /**
  *	devlink_unregister - Unregister devlink instance
  *
@@ -9131,6 +9222,7 @@ void devlink_unregister(struct devlink *devlink)
 {
 	ASSERT_DEVLINK_REGISTERED(devlink);
 	/* Make sure that we are in .remove() routine */
+	WARN_ON(devlink->ops->lock_flags & DEVLINK_LOCK_REF_MODE);
 
 	devlink_put(devlink);
 	wait_for_completion(&devlink->comp);
@@ -9142,6 +9234,12 @@ void devlink_unregister(struct devlink *devlink)
 }
 EXPORT_SYMBOL_GPL(devlink_unregister);
 
+void __devlink_free(struct devlink *devlink)
+{
+	devlink_put(devlink);
+}
+EXPORT_SYMBOL_GPL(__devlink_free);
+
 /**
  *	devlink_free - Free devlink instance resources
  *
@@ -9168,6 +9266,8 @@ void devlink_free(struct devlink *devlink)
 	xa_destroy(&devlink->snapshot_ids);
 	xa_erase(&devlinks, devlink->index);
 
+	module_put(devlink->ops->owner);
+
 	kfree(devlink);
 }
 EXPORT_SYMBOL_GPL(devlink_free);
@@ -11502,7 +11602,8 @@ void devlink_compat_running_version(struct devlink *devlink,
 		return;
 
 	mutex_lock(&devlink->lock);
-	__devlink_compat_running_version(devlink, buf, len);
+	if (devlink_is_alive(devlink))
+		__devlink_compat_running_version(devlink, buf, len);
 	mutex_unlock(&devlink->lock);
 }
 
@@ -11519,9 +11620,14 @@ int devlink_compat_flash_update(struct devlink *devlink, const char *file_name)
 		return ret;
 
 	mutex_lock(&devlink->lock);
+	if (!devlink_is_alive(devlink)) {
+		ret = -ENODEV;
+		goto exit_unlock;
+	}
 	devlink_flash_update_begin_notify(devlink);
 	ret = devlink->ops->flash_update(devlink, &params, NULL);
 	devlink_flash_update_end_notify(devlink);
+exit_unlock:
 	mutex_unlock(&devlink->lock);
 
 	release_firmware(params.fw);
-- 
2.31.1

