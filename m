Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4152564F6BF
	for <lists+netdev@lfdr.de>; Sat, 17 Dec 2022 02:20:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229789AbiLQBUW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Dec 2022 20:20:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229911AbiLQBUN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Dec 2022 20:20:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B97706809D
        for <netdev@vger.kernel.org>; Fri, 16 Dec 2022 17:20:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 36BD562311
        for <netdev@vger.kernel.org>; Sat, 17 Dec 2022 01:20:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A58CC433F0;
        Sat, 17 Dec 2022 01:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671240010;
        bh=lJIs0dquZNePyjwkSSSeWW5cdzIk9eiz3510mgr9Rf0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cmk2WGuU6ui5flRweG1WNiCi+rwRCuckKdJ79zun/FyBnFWvT/k8WEV+4pSc6TcsJ
         rTR11X1ORO9UehGWgDHgsX6Jb/6td29Ri797JGwjQUr6wR9sUC2OL0QmPz1UrLmhHU
         7bPacK8OJCuHPjne6eX0EcAkrSrODNceuXbbbqIOVQkzvyUGvMd8WV3o/f1EKiZSJk
         VDPQhwMfagSOGMwKwu34fuYhhcXOitEDMFhNBQFlakhgymqEmgv1gI0hkmiIeKEN7y
         ukJCBlR2K5fpSgiYls2Ix8HZWYRDR6fU09a3fMK8ypoP8NokRLJn0KMG7UWq9jIBEV
         u6y1wEV9XJAvQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     jiri@resnulli.us, jacob.e.keller@intel.com, leon@kernel.org
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [RFC net-next 04/10] devlink: always check if the devlink instance is registered
Date:   Fri, 16 Dec 2022 17:19:47 -0800
Message-Id: <20221217011953.152487-5-kuba@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221217011953.152487-1-kuba@kernel.org>
References: <20221217011953.152487-1-kuba@kernel.org>
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
 include/net/devlink.h |  1 +
 net/devlink/basic.c   | 35 +++++++++++++++++++++++++++++------
 net/devlink/core.c    | 25 +++++++++++++++++++++----
 net/devlink/netlink.c | 10 ++++++++--
 4 files changed, 59 insertions(+), 12 deletions(-)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index 6a2e4f21779f..36e013d3aa52 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1626,6 +1626,7 @@ struct device *devlink_to_dev(const struct devlink *devlink);
 void devl_lock(struct devlink *devlink);
 int devl_trylock(struct devlink *devlink);
 void devl_unlock(struct devlink *devlink);
+bool devl_is_alive(struct devlink *devlink);
 void devl_assert_locked(struct devlink *devlink);
 bool devl_lock_is_held(struct devlink *devlink);
 
diff --git a/net/devlink/basic.c b/net/devlink/basic.c
index 5f33d74eef83..6b18e70a39fd 100644
--- a/net/devlink/basic.c
+++ b/net/devlink/basic.c
@@ -2130,6 +2130,9 @@ static int devlink_nl_cmd_linecard_get_dumpit(struct sk_buff *msg,
 		int idx = 0;
 
 		mutex_lock(&devlink->linecards_lock);
+		if (!devl_is_alive(devlink))
+			goto next_devlink;
+
 		list_for_each_entry(linecard, &devlink->linecard_list, list) {
 			if (idx < dump->idx) {
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
+		if (!devl_is_alive(devlink)) {
+			mutex_unlock(&devlink->reporters_lock);
+			devlink_put(devlink);
+			continue;
+		}
+
 		list_for_each_entry(reporter, &devlink->reporter_list,
 				    list) {
 			if (idx < dump->idx) {
@@ -7830,6 +7840,9 @@ devlink_nl_cmd_health_reporter_get_dumpit(struct sk_buff *msg,
 		mutex_unlock(&devlink->reporters_lock);
 
 		devl_lock(devlink);
+		if (!devl_is_alive(devlink))
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
+	if (devl_is_alive(devlink))
+		__devlink_compat_running_version(devlink, buf, len);
 	devl_unlock(devlink);
 }
 
@@ -12227,20 +12242,28 @@ int devlink_compat_flash_update(struct devlink *devlink, const char *file_name)
 	struct devlink_flash_update_params params = {};
 	int ret;
 
-	if (!devlink->ops->flash_update)
-		return -EOPNOTSUPP;
+	devl_lock(devlink);
+	if (!devl_is_alive(devlink)) {
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
diff --git a/net/devlink/core.c b/net/devlink/core.c
index d3b8336946fd..2abad8247597 100644
--- a/net/devlink/core.c
+++ b/net/devlink/core.c
@@ -67,6 +67,21 @@ void devl_unlock(struct devlink *devlink)
 }
 EXPORT_SYMBOL_GPL(devl_unlock);
 
+bool devl_is_alive(struct devlink *devlink)
+{
+	return xa_get_mark(&devlinks, devlink->index, DEVLINK_REGISTERED);
+}
+EXPORT_SYMBOL_GPL(devl_is_alive);
+
+/**
+ * devlink_try_get() - try to obtain a reference on a devlink instance
+ * @devlink: instance to reference
+ *
+ * Obtain a reference on a devlink instance. A reference on a devlink instance
+ * only implies that it's safe to take the instance lock. It does not imply
+ * that the instance is registered, use devl_is_alive() after taking
+ * the instance lock to check registration status.
+ */
 struct devlink *__must_check devlink_try_get(struct devlink *devlink)
 {
 	if (refcount_inc_not_zero(&devlink->refcount))
@@ -300,10 +315,12 @@ static void __net_exit devlink_pernet_pre_exit(struct net *net)
 	devlinks_xa_for_each_registered_get(net, index, devlink) {
 		WARN_ON(!(devlink->features & DEVLINK_F_RELOAD));
 		devl_lock(devlink);
-		err = devlink_reload(devlink, &init_net,
-				     DEVLINK_RELOAD_ACTION_DRIVER_REINIT,
-				     DEVLINK_RELOAD_LIMIT_UNSPEC,
-				     &actions_performed, NULL);
+		err = 0;
+		if (devl_is_alive(devlink))
+			err = devlink_reload(devlink, &init_net,
+					     DEVLINK_RELOAD_ACTION_DRIVER_REINIT,
+					     DEVLINK_RELOAD_LIMIT_UNSPEC,
+					     &actions_performed, NULL);
 		devl_unlock(devlink);
 		devlink_put(devlink);
 
diff --git a/net/devlink/netlink.c b/net/devlink/netlink.c
index b38df704be1c..773efaabb6ad 100644
--- a/net/devlink/netlink.c
+++ b/net/devlink/netlink.c
@@ -98,7 +98,8 @@ devlink_get_from_attrs_lock(struct net *net, struct nlattr **attrs)
 
 	devlinks_xa_for_each_registered_get(net, index, devlink) {
 		devl_lock(devlink);
-		if (strcmp(devlink->dev->bus->name, busname) == 0 &&
+		if (devl_is_alive(devlink) &&
+		    strcmp(devlink->dev->bus->name, busname) == 0 &&
 		    strcmp(dev_name(devlink->dev), devname) == 0)
 			return devlink;
 		devl_unlock(devlink);
@@ -210,7 +211,12 @@ int devlink_instance_iter_dump(struct sk_buff *msg, struct netlink_callback *cb)
 
 	devlink_dump_for_each_instance_get(msg, dump, devlink) {
 		devl_lock(devlink);
-		err = cmd->dump_one(msg, devlink, cb);
+
+		if (devl_is_alive(devlink))
+			err = cmd->dump_one(msg, devlink, cb);
+		else
+			err = 0;
+
 		devl_unlock(devlink);
 		devlink_put(devlink);
 
-- 
2.38.1

