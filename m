Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBCFA4D3DF8
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 01:17:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238499AbiCJARq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 19:17:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233455AbiCJARp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 19:17:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2693995A1F
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 16:16:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B61EF60B32
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 00:16:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7938C340F4;
        Thu, 10 Mar 2022 00:16:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646871405;
        bh=5O/rkB729rmQzMZD04rkuIa6C9mXPEns/CgSGmswjUI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fvYL7UWCl+K8/uhkVLw8ha/3CGw6g/uAOHBUni3+VPJXh1baOR6cRevKith7zIgu5
         jaKCdZYwDLM2ld3gPAHEPGTcEqA2LWyHzgBi1e3EoMhG0w738I1VSJj+f6EOaEMOYZ
         BRLzZHt9yorDgdhVSohICb2rN4FTyzOhLxzG0zOiOS3xKi76gXRqUao4AKZuvlexM9
         e/zQxibIYQAdZ5XKs9kbDM8szxsNa7DjrkXbKv4JDOCR0u79fRi93ky08zkTIQw492
         LDg0Y8iYDhxzb1cYRYAWmtOsZdhZd8Ew2XtIdQhI7GBuwN9zWAoAYp7dj86ozZoIni
         PM0MqipGiD4pg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     idosch@nvidia.com, petrm@nvidia.com, simon.horman@corigine.com
Cc:     netdev@vger.kernel.org, leonro@nvidia.com, jiri@resnulli.us,
        Jakub Kicinski <kuba@kernel.org>
Subject: [RFT net-next 1/6] devlink: expose instance locking and add locked port registering
Date:   Wed,  9 Mar 2022 16:16:27 -0800
Message-Id: <20220310001632.470337-2-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220310001632.470337-1-kuba@kernel.org>
References: <20220310001632.470337-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 include/net/devlink.h | 11 +++++
 net/core/devlink.c    | 99 ++++++++++++++++++++++++++++++++-----------
 2 files changed, 86 insertions(+), 24 deletions(-)

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
index fcd9f6d85cf1..c30da1fc023d 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -225,6 +225,37 @@ struct devlink *__must_check devlink_try_get(struct devlink *devlink)
 	return NULL;
 }
 
+void devl_assert_locked(struct devlink *devlink)
+{
+	lockdep_assert_held(&devlink->lock);
+}
+EXPORT_SYMBOL_GPL(devl_assert_locked);
+
+bool devl_lock_is_held(struct devlink *devlink)
+{
+	/* We have to check this at runtime because struct devlink
+	 * is now private. Normally lock_is_held() should be eliminated
+	 * as dead code in the caller and we can depend on the linker error.
+	 */
+	if (!IS_ENABLED(CONFIG_LOCKDEP))
+		return WARN_ON_ONCE(true);
+
+	return lockdep_is_held(&devlink->lock);
+}
+EXPORT_SYMBOL_GPL(devl_lock_is_held);
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
@@ -9249,6 +9280,32 @@ static void devlink_port_type_warn_cancel(struct devlink_port *devlink_port)
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
@@ -9266,29 +9323,28 @@ int devlink_port_register(struct devlink *devlink,
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
@@ -9298,14 +9354,9 @@ void devlink_port_unregister(struct devlink_port *devlink_port)
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

