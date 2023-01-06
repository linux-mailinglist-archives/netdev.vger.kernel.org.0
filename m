Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEA4365FB7A
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 07:34:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231754AbjAFGeQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 01:34:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbjAFGeK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 01:34:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2E546E0F8
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 22:34:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3110F61D2E
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 06:34:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7273C433F0;
        Fri,  6 Jan 2023 06:34:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672986849;
        bh=NJgfx2Az1H2RjyMBh6cjN0iiPzKdywpyAxV/rK2WX7Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tvdYaYvWoEDZuBmiIhPZ7tvY5XHZ61koVzRWvCaW1zCJvmyDqMZAwVCsk6sYp9W/a
         /jXT87CNAS1jg/ysuZF1N0D3MV3smoFFA0OWNalfkPQYhXWom8+SJizClhxko/NuO2
         7tdZUzIrL6N9U3Y0sHGLWMT2g8KzIvNaP1uoOv68o/fA1aWLboabpO0e3f2HRobtmb
         h8LEABSeQ4x9HqPKILaXuhZ6/VRspfO9hzdv92is2X5mb8d4RSv8QLGUJt5uPdefAi
         /7HZE6tVVUK245ZHEo/LhplWVbn72UGKoYnPkyhEKFCKrrYDbAyPzHElNWUmQlQyrm
         RZTV2UGN+UK6Q==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        jacob.e.keller@intel.com, jiri@resnulli.us,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 4/9] devlink: always check if the devlink instance is registered
Date:   Thu,  5 Jan 2023 22:33:57 -0800
Message-Id: <20230106063402.485336-5-kuba@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230106063402.485336-1-kuba@kernel.org>
References: <20230106063402.485336-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Always check under the instance lock whether the devlink instance
is still / already registered.

This is a no-op for the most part, as the unregistration path currently
waits for all references. On the init path, however, we may temporarily
open up a race with netdev code, if netdevs are registered before the
devlink instance. This is temporary, the next change fixes it, and this
commit has been split out for the ease of review.

Note that in case of iterating over sub-objects which have their
own lock (regions and line cards) we assume an implicit dependency
between those objects existing and devlink unregistration.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/devlink/core.c          | 19 +++++++++++++++----
 net/devlink/devl_internal.h |  8 ++++++++
 net/devlink/leftover.c      | 35 +++++++++++++++++++++++++++++------
 net/devlink/netlink.c       | 10 ++++++++--
 4 files changed, 60 insertions(+), 12 deletions(-)

diff --git a/net/devlink/core.c b/net/devlink/core.c
index d3b8336946fd..c53c996edf1d 100644
--- a/net/devlink/core.c
+++ b/net/devlink/core.c
@@ -67,6 +67,15 @@ void devl_unlock(struct devlink *devlink)
 }
 EXPORT_SYMBOL_GPL(devl_unlock);
 
+/**
+ * devlink_try_get() - try to obtain a reference on a devlink instance
+ * @devlink: instance to reference
+ *
+ * Obtain a reference on a devlink instance. A reference on a devlink instance
+ * only implies that it's safe to take the instance lock. It does not imply
+ * that the instance is registered, use devl_is_registered() after taking
+ * the instance lock to check registration status.
+ */
 struct devlink *__must_check devlink_try_get(struct devlink *devlink)
 {
 	if (refcount_inc_not_zero(&devlink->refcount))
@@ -300,10 +309,12 @@ static void __net_exit devlink_pernet_pre_exit(struct net *net)
 	devlinks_xa_for_each_registered_get(net, index, devlink) {
 		WARN_ON(!(devlink->features & DEVLINK_F_RELOAD));
 		devl_lock(devlink);
-		err = devlink_reload(devlink, &init_net,
-				     DEVLINK_RELOAD_ACTION_DRIVER_REINIT,
-				     DEVLINK_RELOAD_LIMIT_UNSPEC,
-				     &actions_performed, NULL);
+		err = 0;
+		if (devl_is_registered(devlink))
+			err = devlink_reload(devlink, &init_net,
+					     DEVLINK_RELOAD_ACTION_DRIVER_REINIT,
+					     DEVLINK_RELOAD_LIMIT_UNSPEC,
+					     &actions_performed, NULL);
 		devl_unlock(devlink);
 		devlink_put(devlink);
 
diff --git a/net/devlink/devl_internal.h b/net/devlink/devl_internal.h
index 6342552e5f99..01a00df81d0e 100644
--- a/net/devlink/devl_internal.h
+++ b/net/devlink/devl_internal.h
@@ -86,6 +86,14 @@ extern struct genl_family devlink_nl_family;
 
 struct devlink *devlinks_xa_find_get(struct net *net, unsigned long *indexp);
 
+static inline bool devl_is_registered(struct devlink *devlink)
+{
+	/* To prevent races the caller must hold the instance lock
+	 * or another lock taken during unregistration.
+	 */
+	return xa_get_mark(&devlinks, devlink->index, DEVLINK_REGISTERED);
+}
+
 /* Netlink */
 #define DEVLINK_NL_FLAG_NEED_PORT		BIT(0)
 #define DEVLINK_NL_FLAG_NEED_DEVLINK_OR_PORT	BIT(1)
diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
index bec408da4dbe..491f821c8b77 100644
--- a/net/devlink/leftover.c
+++ b/net/devlink/leftover.c
@@ -2130,6 +2130,9 @@ static int devlink_nl_cmd_linecard_get_dumpit(struct sk_buff *msg,
 		int idx = 0;
 
 		mutex_lock(&devlink->linecards_lock);
+		if (!devl_is_registered(devlink))
+			goto next_devlink;
+
 		list_for_each_entry(linecard, &devlink->linecard_list, list) {
 			if (idx < state->idx) {
 				idx++;
@@ -2151,6 +2154,7 @@ static int devlink_nl_cmd_linecard_get_dumpit(struct sk_buff *msg,
 			}
 			idx++;
 		}
+next_devlink:
 		mutex_unlock(&devlink->linecards_lock);
 		devlink_put(devlink);
 	}
@@ -7809,6 +7813,12 @@ devlink_nl_cmd_health_reporter_get_dumpit(struct sk_buff *msg,
 		int idx = 0;
 
 		mutex_lock(&devlink->reporters_lock);
+		if (!devl_is_registered(devlink)) {
+			mutex_unlock(&devlink->reporters_lock);
+			devlink_put(devlink);
+			continue;
+		}
+
 		list_for_each_entry(reporter, &devlink->reporter_list,
 				    list) {
 			if (idx < state->idx) {
@@ -7830,6 +7840,9 @@ devlink_nl_cmd_health_reporter_get_dumpit(struct sk_buff *msg,
 		mutex_unlock(&devlink->reporters_lock);
 
 		devl_lock(devlink);
+		if (!devl_is_registered(devlink))
+			goto next_devlink;
+
 		xa_for_each(&devlink->ports, port_index, port) {
 			mutex_lock(&port->reporters_lock);
 			list_for_each_entry(reporter, &port->reporter_list, list) {
@@ -7853,6 +7866,7 @@ devlink_nl_cmd_health_reporter_get_dumpit(struct sk_buff *msg,
 			}
 			mutex_unlock(&port->reporters_lock);
 		}
+next_devlink:
 		devl_unlock(devlink);
 		devlink_put(devlink);
 	}
@@ -12218,7 +12232,8 @@ void devlink_compat_running_version(struct devlink *devlink,
 		return;
 
 	devl_lock(devlink);
-	__devlink_compat_running_version(devlink, buf, len);
+	if (devl_is_registered(devlink))
+		__devlink_compat_running_version(devlink, buf, len);
 	devl_unlock(devlink);
 }
 
@@ -12227,20 +12242,28 @@ int devlink_compat_flash_update(struct devlink *devlink, const char *file_name)
 	struct devlink_flash_update_params params = {};
 	int ret;
 
-	if (!devlink->ops->flash_update)
-		return -EOPNOTSUPP;
+	devl_lock(devlink);
+	if (!devl_is_registered(devlink)) {
+		ret = -ENODEV;
+		goto out_unlock;
+	}
+
+	if (!devlink->ops->flash_update) {
+		ret = -EOPNOTSUPP;
+		goto out_unlock;
+	}
 
 	ret = request_firmware(&params.fw, file_name, devlink->dev);
 	if (ret)
-		return ret;
+		goto out_unlock;
 
-	devl_lock(devlink);
 	devlink_flash_update_begin_notify(devlink);
 	ret = devlink->ops->flash_update(devlink, &params, NULL);
 	devlink_flash_update_end_notify(devlink);
-	devl_unlock(devlink);
 
 	release_firmware(params.fw);
+out_unlock:
+	devl_unlock(devlink);
 
 	return ret;
 }
diff --git a/net/devlink/netlink.c b/net/devlink/netlink.c
index 69111746f5d9..b5b8ac6db2d1 100644
--- a/net/devlink/netlink.c
+++ b/net/devlink/netlink.c
@@ -98,7 +98,8 @@ devlink_get_from_attrs_lock(struct net *net, struct nlattr **attrs)
 
 	devlinks_xa_for_each_registered_get(net, index, devlink) {
 		devl_lock(devlink);
-		if (strcmp(devlink->dev->bus->name, busname) == 0 &&
+		if (devl_is_registered(devlink) &&
+		    strcmp(devlink->dev->bus->name, busname) == 0 &&
 		    strcmp(dev_name(devlink->dev), devname) == 0)
 			return devlink;
 		devl_unlock(devlink);
@@ -211,7 +212,12 @@ int devlink_nl_instance_iter_dump(struct sk_buff *msg,
 
 	devlink_dump_for_each_instance_get(msg, state, devlink) {
 		devl_lock(devlink);
-		err = cmd->dump_one(msg, devlink, cb);
+
+		if (devl_is_registered(devlink))
+			err = cmd->dump_one(msg, devlink, cb);
+		else
+			err = 0;
+
 		devl_unlock(devlink);
 		devlink_put(devlink);
 
-- 
2.38.1

