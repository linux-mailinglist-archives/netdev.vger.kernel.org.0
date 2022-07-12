Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 976395717F9
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 13:05:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232888AbiGLLFY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 07:05:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232048AbiGLLFS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 07:05:18 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75E57AF75B
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 04:05:17 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id y8so9637310eda.3
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 04:05:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=epeUWUeWl1NLTmNhQ4hqA4v5dXhuyx8Hy/Lgq92veXY=;
        b=ypspCSnacRjtUCFMGfI8TzGDI6hSByvn9Yv6l0ssnSHhGwNgh4IAfWebWLAbW7Kdni
         pCTyOfWdL1m72Fq2l6YPovgNisYLqJFW18vhhbyk5OFUGE3szEkKMShxdIQTMbQcJYKa
         9YtbSyONs+Jvp++ggKy1oKKd8KvG5s/oyJCI2cdz6ipiN/kkMbfjQS17AujTSo4oFrAv
         d8i13YBaMoz5ANqTRCNng4Ft/vKBixQ77Re76TA49YtJDTPZ5nZtmxhBYQgWWOqH9jQP
         iMffFj4xc3was+C5pMbCzwsmhbG/MQCyF5Oc+4qOCDHhyiMzOWChohBocDankGvOQzV9
         ib8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=epeUWUeWl1NLTmNhQ4hqA4v5dXhuyx8Hy/Lgq92veXY=;
        b=WsGWvuYQ/6zmmhqHKhZrmJ9GWElayHUtd0wot59IAs6+BowZnQvHU3t+msEwa1jZ0G
         UUoIyTspETZnIwQ+7UA8kRakAjOp6jrP1dCBfEpINt7WyJuSVuN/7sQJDFa7dPTSS1Pq
         DJh2aGtqT8ybomtymMC07QCFx9TA8Tr0aidU+XpMoybqvbAvyIeRHB1MttL0Ah/Rleax
         HHkeDoQUuRrGLEl6bXW9P1PmV/MBwwUhBwt7Q3mzYvDo9wv8FsmvUhrD7ZLvYtvr3bUZ
         XE6UKnmCtUHQ61FA7QjGhgpn2I+jTZbHv0ohppMxVNbCfs4aR8nWr+DPE8Rt7ZMHHFW4
         Mo/w==
X-Gm-Message-State: AJIora+Nr0+yy+F//BceFHau9BAUWvJjUo9ANncENhxO4ZbsySI+OvG5
        NoLfs5eKZjLpwV/36XUfKpJCCXknc4lrQb4QMx0=
X-Google-Smtp-Source: AGRyM1uVDKxlxkO/969YEzgCkTa7bfx5tlA3oavp30ow77Wxid8mL3VNqiyk6UiFpocQtjKO3O+d/g==
X-Received: by 2002:a05:6402:520c:b0:43a:aba8:84ae with SMTP id s12-20020a056402520c00b0043aaba884aemr31271108edd.198.1657623915828;
        Tue, 12 Jul 2022 04:05:15 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id c17-20020a056402121100b00437e08d319csm5803285edw.61.2022.07.12.04.05.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 04:05:15 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, mlxsw@nvidia.com, idosch@nvidia.com,
        saeedm@nvidia.com, moshe@nvidia.com, tariqt@nvidia.com
Subject: [patch net-next RFC 02/10] net: devlink: add unlocked variants of devling_trap*() functions
Date:   Tue, 12 Jul 2022 13:05:03 +0200
Message-Id: <20220712110511.2834647-3-jiri@resnulli.us>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220712110511.2834647-1-jiri@resnulli.us>
References: <20220712110511.2834647-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Moshe Shemesh <moshe@nvidia.com>

Add unlocked variants of devl_trap*() functions to be used in drivers
called-in with devlink->lock held.

Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 include/net/devlink.h |  12 +++++
 net/core/devlink.c    | 122 ++++++++++++++++++++++++++++++++++--------
 2 files changed, 112 insertions(+), 22 deletions(-)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index 88c701b375a2..a3b4601412ca 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1745,9 +1745,15 @@ void devlink_flash_update_timeout_notify(struct devlink *devlink,
 					 const char *component,
 					 unsigned long timeout);
 
+int devl_traps_register(struct devlink *devlink,
+			const struct devlink_trap *traps,
+			size_t traps_count, void *priv);
 int devlink_traps_register(struct devlink *devlink,
 			   const struct devlink_trap *traps,
 			   size_t traps_count, void *priv);
+void devl_traps_unregister(struct devlink *devlink,
+			   const struct devlink_trap *traps,
+			   size_t traps_count);
 void devlink_traps_unregister(struct devlink *devlink,
 			      const struct devlink_trap *traps,
 			      size_t traps_count);
@@ -1755,9 +1761,15 @@ void devlink_trap_report(struct devlink *devlink, struct sk_buff *skb,
 			 void *trap_ctx, struct devlink_port *in_devlink_port,
 			 const struct flow_action_cookie *fa_cookie);
 void *devlink_trap_ctx_priv(void *trap_ctx);
+int devl_trap_groups_register(struct devlink *devlink,
+			      const struct devlink_trap_group *groups,
+			      size_t groups_count);
 int devlink_trap_groups_register(struct devlink *devlink,
 				 const struct devlink_trap_group *groups,
 				 size_t groups_count);
+void devl_trap_groups_unregister(struct devlink *devlink,
+				 const struct devlink_trap_group *groups,
+				 size_t groups_count);
 void devlink_trap_groups_unregister(struct devlink *devlink,
 				    const struct devlink_trap_group *groups,
 				    size_t groups_count);
diff --git a/net/core/devlink.c b/net/core/devlink.c
index d2a4e6ee1be6..bf27b95c32c8 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -11544,7 +11544,7 @@ static void devlink_trap_disable(struct devlink *devlink,
 }
 
 /**
- * devlink_traps_register - Register packet traps with devlink.
+ * devl_traps_register - Register packet traps with devlink.
  * @devlink: devlink.
  * @traps: Packet traps.
  * @traps_count: Count of provided packet traps.
@@ -11552,16 +11552,16 @@ static void devlink_trap_disable(struct devlink *devlink,
  *
  * Return: Non-zero value on failure.
  */
-int devlink_traps_register(struct devlink *devlink,
-			   const struct devlink_trap *traps,
-			   size_t traps_count, void *priv)
+int devl_traps_register(struct devlink *devlink,
+			const struct devlink_trap *traps,
+			size_t traps_count, void *priv)
 {
 	int i, err;
 
 	if (!devlink->ops->trap_init || !devlink->ops->trap_action_set)
 		return -EINVAL;
 
-	devl_lock(devlink);
+	devl_assert_locked(devlink);
 	for (i = 0; i < traps_count; i++) {
 		const struct devlink_trap *trap = &traps[i];
 
@@ -11573,7 +11573,6 @@ int devlink_traps_register(struct devlink *devlink,
 		if (err)
 			goto err_trap_register;
 	}
-	devl_unlock(devlink);
 
 	return 0;
 
@@ -11581,24 +11580,48 @@ int devlink_traps_register(struct devlink *devlink,
 err_trap_verify:
 	for (i--; i >= 0; i--)
 		devlink_trap_unregister(devlink, &traps[i]);
-	devl_unlock(devlink);
 	return err;
 }
+EXPORT_SYMBOL_GPL(devl_traps_register);
+
+/**
+ * devlink_traps_register - Register packet traps with devlink.
+ * @devlink: devlink.
+ * @traps: Packet traps.
+ * @traps_count: Count of provided packet traps.
+ * @priv: Driver private information.
+ *
+ * Context: Takes and release devlink->lock <mutex>.
+ *
+ * Return: Non-zero value on failure.
+ */
+int devlink_traps_register(struct devlink *devlink,
+			   const struct devlink_trap *traps,
+			   size_t traps_count, void *priv)
+{
+	int ret;
+
+	devl_lock(devlink);
+	ret = devl_traps_register(devlink, traps, traps_count, priv);
+	devl_unlock(devlink);
+
+	return ret;
+}
 EXPORT_SYMBOL_GPL(devlink_traps_register);
 
 /**
- * devlink_traps_unregister - Unregister packet traps from devlink.
+ * devl_traps_unregister - Unregister packet traps from devlink.
  * @devlink: devlink.
  * @traps: Packet traps.
  * @traps_count: Count of provided packet traps.
  */
-void devlink_traps_unregister(struct devlink *devlink,
-			      const struct devlink_trap *traps,
-			      size_t traps_count)
+void devl_traps_unregister(struct devlink *devlink,
+			   const struct devlink_trap *traps,
+			   size_t traps_count)
 {
 	int i;
 
-	devl_lock(devlink);
+	devl_assert_locked(devlink);
 	/* Make sure we do not have any packets in-flight while unregistering
 	 * traps by disabling all of them and waiting for a grace period.
 	 */
@@ -11607,6 +11630,23 @@ void devlink_traps_unregister(struct devlink *devlink,
 	synchronize_rcu();
 	for (i = traps_count - 1; i >= 0; i--)
 		devlink_trap_unregister(devlink, &traps[i]);
+}
+EXPORT_SYMBOL_GPL(devl_traps_unregister);
+
+/**
+ * devlink_traps_unregister - Unregister packet traps from devlink.
+ * @devlink: devlink.
+ * @traps: Packet traps.
+ * @traps_count: Count of provided packet traps.
+ *
+ * Context: Takes and release devlink->lock <mutex>.
+ */
+void devlink_traps_unregister(struct devlink *devlink,
+			      const struct devlink_trap *traps,
+			      size_t traps_count)
+{
+	devl_lock(devlink);
+	devl_traps_unregister(devlink, traps, traps_count);
 	devl_unlock(devlink);
 }
 EXPORT_SYMBOL_GPL(devlink_traps_unregister);
@@ -11766,20 +11806,20 @@ devlink_trap_group_unregister(struct devlink *devlink,
 }
 
 /**
- * devlink_trap_groups_register - Register packet trap groups with devlink.
+ * devl_trap_groups_register - Register packet trap groups with devlink.
  * @devlink: devlink.
  * @groups: Packet trap groups.
  * @groups_count: Count of provided packet trap groups.
  *
  * Return: Non-zero value on failure.
  */
-int devlink_trap_groups_register(struct devlink *devlink,
-				 const struct devlink_trap_group *groups,
-				 size_t groups_count)
+int devl_trap_groups_register(struct devlink *devlink,
+			      const struct devlink_trap_group *groups,
+			      size_t groups_count)
 {
 	int i, err;
 
-	devl_lock(devlink);
+	devl_assert_locked(devlink);
 	for (i = 0; i < groups_count; i++) {
 		const struct devlink_trap_group *group = &groups[i];
 
@@ -11791,7 +11831,6 @@ int devlink_trap_groups_register(struct devlink *devlink,
 		if (err)
 			goto err_trap_group_register;
 	}
-	devl_unlock(devlink);
 
 	return 0;
 
@@ -11799,26 +11838,65 @@ int devlink_trap_groups_register(struct devlink *devlink,
 err_trap_group_verify:
 	for (i--; i >= 0; i--)
 		devlink_trap_group_unregister(devlink, &groups[i]);
+	return err;
+}
+EXPORT_SYMBOL_GPL(devl_trap_groups_register);
+
+/**
+ * devlink_trap_groups_register - Register packet trap groups with devlink.
+ * @devlink: devlink.
+ * @groups: Packet trap groups.
+ * @groups_count: Count of provided packet trap groups.
+ *
+ * Context: Takes and release devlink->lock <mutex>.
+ *
+ * Return: Non-zero value on failure.
+ */
+int devlink_trap_groups_register(struct devlink *devlink,
+				 const struct devlink_trap_group *groups,
+				 size_t groups_count)
+{
+	int err;
+
+	devl_lock(devlink);
+	err = devl_trap_groups_register(devlink, groups, groups_count);
 	devl_unlock(devlink);
 	return err;
 }
 EXPORT_SYMBOL_GPL(devlink_trap_groups_register);
 
+/**
+ * devl_trap_groups_unregister - Unregister packet trap groups from devlink.
+ * @devlink: devlink.
+ * @groups: Packet trap groups.
+ * @groups_count: Count of provided packet trap groups.
+ */
+void devl_trap_groups_unregister(struct devlink *devlink,
+				 const struct devlink_trap_group *groups,
+				 size_t groups_count)
+{
+	int i;
+
+	devl_assert_locked(devlink);
+	for (i = groups_count - 1; i >= 0; i--)
+		devlink_trap_group_unregister(devlink, &groups[i]);
+}
+EXPORT_SYMBOL_GPL(devl_trap_groups_unregister);
+
 /**
  * devlink_trap_groups_unregister - Unregister packet trap groups from devlink.
  * @devlink: devlink.
  * @groups: Packet trap groups.
  * @groups_count: Count of provided packet trap groups.
+ *
+ * Context: Takes and release devlink->lock <mutex>.
  */
 void devlink_trap_groups_unregister(struct devlink *devlink,
 				    const struct devlink_trap_group *groups,
 				    size_t groups_count)
 {
-	int i;
-
 	devl_lock(devlink);
-	for (i = groups_count - 1; i >= 0; i--)
-		devlink_trap_group_unregister(devlink, &groups[i]);
+	devl_trap_groups_unregister(devlink, groups, groups_count);
 	devl_unlock(devlink);
 }
 EXPORT_SYMBOL_GPL(devlink_trap_groups_unregister);
-- 
2.35.3

