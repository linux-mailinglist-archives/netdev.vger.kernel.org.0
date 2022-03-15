Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DFCF4D9444
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 07:00:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344998AbiCOGBa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 02:01:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239882AbiCOGB2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 02:01:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C6C849F2B
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 23:00:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ACAE0612CD
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 06:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF20EC36AE2;
        Tue, 15 Mar 2022 06:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647324016;
        bh=vKVpqVTfOwtqfdUhNvekRVFrFxkaxavNIoS6c+wFg1g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=suprdx5D6p4pz36eMya9Zq85oSjnGPLJzontynTpQ73tLWDHNVMjm7ht5j9SAO9G7
         XWiAGjMVltvx2ZYmUYW9bJnPndwIOQ42HVuQHq+G/qGLCNg5uPM+lEIjF17CB4Sjbo
         8aboLpAfikIRM6o2OJpORMMpDkm7dozyQ0IBbBkcho1+mRm06NkgXEx0wXQY6FDpSd
         Ht1u0I/eCnFP3Ht7JRygpezPV9b27aADXXKTFSgGHX+wCRNafUoWWKo8YeapKn+yuG
         J/RiTT2z523w6dUq4ZlAlLfOrIcaDqJuLg4ztQer8c/axi1FQDIf4LMm+L7ROQy1bI
         YWSKCG9QeLqDQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, jiri@nvidia.com, idosch@nvidia.com,
        petrm@nvidia.com, simon.horman@corigine.com,
        louis.peens@corigine.com, leon@kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 1/6] devlink: expose instance locking and add locked port registering
Date:   Mon, 14 Mar 2022 23:00:04 -0700
Message-Id: <20220315060009.1028519-2-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220315060009.1028519-1-kuba@kernel.org>
References: <20220315060009.1028519-1-kuba@kernel.org>
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

It should be familiar and beneficial to expose devlink instance
lock to the drivers. This way drivers can block devlink from
calling them during critical sections without breakneck locking.

Add port helpers, port splitting callbacks will be the first
target.

Use 'devl_' prefix for "explicitly locked" API. Initial RFC used
'__devlink' but that's too much typing.

devl_lock_is_held() is not defined without lockdep, which is
the same behavior as lockdep_is_held() itself.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
v1: - add a small section to the docs
    - redo the lockdep ifdef
---
 Documentation/networking/devlink/index.rst | 16 ++++
 include/net/devlink.h                      | 11 +++
 net/core/devlink.c                         | 95 ++++++++++++++++------
 3 files changed, 98 insertions(+), 24 deletions(-)

diff --git a/Documentation/networking/devlink/index.rst b/Documentation/networking/devlink/index.rst
index 443123772f44..c17cdb079611 100644
--- a/Documentation/networking/devlink/index.rst
+++ b/Documentation/networking/devlink/index.rst
@@ -4,6 +4,22 @@ Linux Devlink Documentation
 devlink is an API to expose device information and resources not directly
 related to any device class, such as chip-wide/switch-ASIC-wide configuration.
 
+Locking
+-------
+
+Driver facing APIs are currently transitioning to allow more explicit
+locking. Drivers can use the existing ``devlink_*`` set of APIs, or
+new APIs prefixed by ``devl_*``. The older APIs handle all the locking
+in devlink core, but don't allow registration of most sub-objects once
+the main devlink object is itself registered. The newer ``devl_*`` APIs assume
+the devlink instance lock is already held. Drivers can take the instance
+lock by calling ``devl_lock()``. It is also held in most of the callbacks.
+Eventually all callbacks will be invoked under the devlink instance lock,
+refer to the use of the ``DEVLINK_NL_FLAG_NO_LOCK`` flag in devlink core
+to find out which callbacks are not converted, yet.
+
+Drivers are encouraged to use the devlink instance lock for their own needs.
+
 Interface documentation
 -----------------------
 
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 8d5349d2fb68..9de0d091aee9 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1479,6 +1479,17 @@ void *devlink_priv(struct devlink *devlink);
 struct devlink *priv_to_devlink(void *priv);
 struct device *devlink_to_dev(const struct devlink *devlink);
 
+/* Devlink instance explicit locking */
+void devl_lock(struct devlink *devlink);
+void devl_unlock(struct devlink *devlink);
+void devl_assert_locked(struct devlink *devlink);
+bool devl_lock_is_held(struct devlink *devlink);
+
+int devl_port_register(struct devlink *devlink,
+		       struct devlink_port *devlink_port,
+		       unsigned int port_index);
+void devl_port_unregister(struct devlink_port *devlink_port);
+
 struct ib_device;
 
 struct net *devlink_net(const struct devlink *devlink);
diff --git a/net/core/devlink.c b/net/core/devlink.c
index fcd9f6d85cf1..769e5f7fa219 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -225,6 +225,33 @@ struct devlink *__must_check devlink_try_get(struct devlink *devlink)
 	return NULL;
 }
 
+void devl_assert_locked(struct devlink *devlink)
+{
+	lockdep_assert_held(&devlink->lock);
+}
+EXPORT_SYMBOL_GPL(devl_assert_locked);
+
+#ifdef CONFIG_LOCKDEP
+/* For use in conjunction with LOCKDEP only e.g. rcu_dereference_protected() */
+bool devl_lock_is_held(struct devlink *devlink)
+{
+	return lockdep_is_held(&devlink->lock);
+}
+EXPORT_SYMBOL_GPL(devl_lock_is_held);
+#endif
+
+void devl_lock(struct devlink *devlink)
+{
+	mutex_lock(&devlink->lock);
+}
+EXPORT_SYMBOL_GPL(devl_lock);
+
+void devl_unlock(struct devlink *devlink)
+{
+	mutex_unlock(&devlink->lock);
+}
+EXPORT_SYMBOL_GPL(devl_unlock);
+
 static struct devlink *devlink_get_from_attrs(struct net *net,
 					      struct nlattr **attrs)
 {
@@ -9249,6 +9276,32 @@ static void devlink_port_type_warn_cancel(struct devlink_port *devlink_port)
 	cancel_delayed_work_sync(&devlink_port->type_warn_dw);
 }
 
+int devl_port_register(struct devlink *devlink,
+		       struct devlink_port *devlink_port,
+		       unsigned int port_index)
+{
+	lockdep_assert_held(&devlink->lock);
+
+	if (devlink_port_index_exists(devlink, port_index))
+		return -EEXIST;
+
+	WARN_ON(devlink_port->devlink);
+	devlink_port->devlink = devlink;
+	devlink_port->index = port_index;
+	spin_lock_init(&devlink_port->type_lock);
+	INIT_LIST_HEAD(&devlink_port->reporter_list);
+	mutex_init(&devlink_port->reporters_lock);
+	list_add_tail(&devlink_port->list, &devlink->port_list);
+	INIT_LIST_HEAD(&devlink_port->param_list);
+	INIT_LIST_HEAD(&devlink_port->region_list);
+
+	INIT_DELAYED_WORK(&devlink_port->type_warn_dw, &devlink_port_type_warn);
+	devlink_port_type_warn_schedule(devlink_port);
+	devlink_port_notify(devlink_port, DEVLINK_CMD_PORT_NEW);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(devl_port_register);
+
 /**
  *	devlink_port_register - Register devlink port
  *
@@ -9266,29 +9319,28 @@ int devlink_port_register(struct devlink *devlink,
 			  struct devlink_port *devlink_port,
 			  unsigned int port_index)
 {
-	mutex_lock(&devlink->lock);
-	if (devlink_port_index_exists(devlink, port_index)) {
-		mutex_unlock(&devlink->lock);
-		return -EEXIST;
-	}
+	int err;
 
-	WARN_ON(devlink_port->devlink);
-	devlink_port->devlink = devlink;
-	devlink_port->index = port_index;
-	spin_lock_init(&devlink_port->type_lock);
-	INIT_LIST_HEAD(&devlink_port->reporter_list);
-	mutex_init(&devlink_port->reporters_lock);
-	list_add_tail(&devlink_port->list, &devlink->port_list);
-	INIT_LIST_HEAD(&devlink_port->param_list);
-	INIT_LIST_HEAD(&devlink_port->region_list);
+	mutex_lock(&devlink->lock);
+	err = devl_port_register(devlink, devlink_port, port_index);
 	mutex_unlock(&devlink->lock);
-	INIT_DELAYED_WORK(&devlink_port->type_warn_dw, &devlink_port_type_warn);
-	devlink_port_type_warn_schedule(devlink_port);
-	devlink_port_notify(devlink_port, DEVLINK_CMD_PORT_NEW);
-	return 0;
+	return err;
 }
 EXPORT_SYMBOL_GPL(devlink_port_register);
 
+void devl_port_unregister(struct devlink_port *devlink_port)
+{
+	lockdep_assert_held(&devlink_port->devlink->lock);
+
+	devlink_port_type_warn_cancel(devlink_port);
+	devlink_port_notify(devlink_port, DEVLINK_CMD_PORT_DEL);
+	list_del(&devlink_port->list);
+	WARN_ON(!list_empty(&devlink_port->reporter_list));
+	WARN_ON(!list_empty(&devlink_port->region_list));
+	mutex_destroy(&devlink_port->reporters_lock);
+}
+EXPORT_SYMBOL_GPL(devl_port_unregister);
+
 /**
  *	devlink_port_unregister - Unregister devlink port
  *
@@ -9298,14 +9350,9 @@ void devlink_port_unregister(struct devlink_port *devlink_port)
 {
 	struct devlink *devlink = devlink_port->devlink;
 
-	devlink_port_type_warn_cancel(devlink_port);
-	devlink_port_notify(devlink_port, DEVLINK_CMD_PORT_DEL);
 	mutex_lock(&devlink->lock);
-	list_del(&devlink_port->list);
+	devl_port_unregister(devlink_port);
 	mutex_unlock(&devlink->lock);
-	WARN_ON(!list_empty(&devlink_port->reporter_list));
-	WARN_ON(!list_empty(&devlink_port->region_list));
-	mutex_destroy(&devlink_port->reporters_lock);
 }
 EXPORT_SYMBOL_GPL(devlink_port_unregister);
 
-- 
2.34.1

