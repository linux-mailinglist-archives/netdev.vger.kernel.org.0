Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88E44576D63
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 13:03:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230164AbiGPLDO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jul 2022 07:03:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230083AbiGPLDB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jul 2022 07:03:01 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C53F26132
        for <netdev@vger.kernel.org>; Sat, 16 Jul 2022 04:02:57 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id j22so13035899ejs.2
        for <netdev@vger.kernel.org>; Sat, 16 Jul 2022 04:02:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HZ/hEZMj6s3wSQIshMF2AJAGR1KJ6frTbOjpBJsoTxY=;
        b=fKuMlY6TmTuEJNygn6Sc+8NWbp3H9e2DcniKKrPhnO0GJPKUGuTudXa1TbxsIqlQay
         mN9rry418Fxb11BivX7IPjK6GRhKzlaZsRFhRoNTb/UzKREtrWYDL+fpY8CiUNF5sILp
         Jds45OBdqlzOPVisvB/9uzqHUKVm50jDMiPKxuPNLoQ+WNgny+5+wLWUSOgMp69vpwpm
         zeHWItuLPVGy0vIh4faR7oU1hcRO35fTj9RbRXkEPfo/GZpL2E/7wWRbI+8ZVVSgDROI
         3w6qNzfh1iy9woiUn0ysirFkmHQn4YLyn58lsKndFY7ydfQ7WPkEf5KHMAaibJEJgJLU
         AlYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HZ/hEZMj6s3wSQIshMF2AJAGR1KJ6frTbOjpBJsoTxY=;
        b=vpbTk/QXT2sD71S9irD8vOFQK5MjWkYIKHtFFOZaC5BB0n/gSPPmkz9exY+FUYGKNL
         j3q1NY2r4pRzUuOLZUZB6WAiU9FUwP2jgwjNvTRFY7giiruPmvQ4J1nqUmc8PL6oq2yX
         GwgHub9N4E0koqk2yfnVb4At36V0+AOP20G2Iv+02TfxRvLUqDs5yKnRtamsDNCsVM33
         V4iJM8EBOytppl5FMD14vlKrHMFayjBlFBHVeCyMmBzxeXw1Fdz9UQNvTbBU+bPZW0R0
         1uHwzDuudNNWf27BwFn8fFMRhm6PaisMTQVDE1cNE9+iRb6mFidQ6G3Iw6ePM31awRzX
         5bQQ==
X-Gm-Message-State: AJIora8oxlmiPS3bCi8lrI381eg/bSReP8FqU/bbWVk/1Px/7OghJJqv
        aWjxuVl02/btdhxJOt03h48LAmyBHftggZDo
X-Google-Smtp-Source: AGRyM1v76jE1Z/g4G9PreuXAsjG4UAIjHV1lcXjt2dMvRrtSCO2nxbPTsJUsZChz2By0grzMVz07sQ==
X-Received: by 2002:a17:907:b590:b0:72e:d8ca:5b8d with SMTP id qx16-20020a170907b59000b0072ed8ca5b8dmr13259891ejc.629.1657969376026;
        Sat, 16 Jul 2022 04:02:56 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id o18-20020a170906769200b00726abf9a32bsm3099568ejm.138.2022.07.16.04.02.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Jul 2022 04:02:55 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, mlxsw@nvidia.com, idosch@nvidia.com,
        saeedm@nvidia.com, moshe@nvidia.com, tariqt@nvidia.com
Subject: [patch net-next 7/9] net: devlink: add unlocked variants of devlink_region_create/destroy() functions
Date:   Sat, 16 Jul 2022 13:02:39 +0200
Message-Id: <20220716110241.3390528-8-jiri@resnulli.us>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220716110241.3390528-1-jiri@resnulli.us>
References: <20220716110241.3390528-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

Add unlocked variants of devlink_region_create/destroy() functions
to be used in drivers called-in with devlink->lock held.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
---
 include/net/devlink.h |  5 +++
 net/core/devlink.c    | 89 +++++++++++++++++++++++++++++--------------
 2 files changed, 66 insertions(+), 28 deletions(-)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index 18ad88527847..391d401ddb55 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1676,6 +1676,10 @@ int devlink_param_driverinit_value_get(struct devlink *devlink, u32 param_id,
 int devlink_param_driverinit_value_set(struct devlink *devlink, u32 param_id,
 				       union devlink_param_value init_val);
 void devlink_param_value_changed(struct devlink *devlink, u32 param_id);
+struct devlink_region *devl_region_create(struct devlink *devlink,
+					  const struct devlink_region_ops *ops,
+					  u32 region_max_snapshots,
+					  u64 region_size);
 struct devlink_region *
 devlink_region_create(struct devlink *devlink,
 		      const struct devlink_region_ops *ops,
@@ -1684,6 +1688,7 @@ struct devlink_region *
 devlink_port_region_create(struct devlink_port *port,
 			   const struct devlink_port_region_ops *ops,
 			   u32 region_max_snapshots, u64 region_size);
+void devl_region_destroy(struct devlink_region *region);
 void devlink_region_destroy(struct devlink_region *region);
 void devlink_port_region_destroy(struct devlink_region *region);
 
diff --git a/net/core/devlink.c b/net/core/devlink.c
index b249c18a8bbc..fe9657d6162f 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -11192,36 +11192,31 @@ void devlink_param_value_changed(struct devlink *devlink, u32 param_id)
 EXPORT_SYMBOL_GPL(devlink_param_value_changed);
 
 /**
- *	devlink_region_create - create a new address region
+ * devl_region_create - create a new address region
  *
- *	@devlink: devlink
- *	@ops: region operations and name
- *	@region_max_snapshots: Maximum supported number of snapshots for region
- *	@region_size: size of region
+ * @devlink: devlink
+ * @ops: region operations and name
+ * @region_max_snapshots: Maximum supported number of snapshots for region
+ * @region_size: size of region
  */
-struct devlink_region *
-devlink_region_create(struct devlink *devlink,
-		      const struct devlink_region_ops *ops,
-		      u32 region_max_snapshots, u64 region_size)
+struct devlink_region *devl_region_create(struct devlink *devlink,
+					  const struct devlink_region_ops *ops,
+					  u32 region_max_snapshots,
+					  u64 region_size)
 {
 	struct devlink_region *region;
-	int err = 0;
+
+	devl_assert_locked(devlink);
 
 	if (WARN_ON(!ops) || WARN_ON(!ops->destructor))
 		return ERR_PTR(-EINVAL);
 
-	devl_lock(devlink);
-
-	if (devlink_region_get_by_name(devlink, ops->name)) {
-		err = -EEXIST;
-		goto unlock;
-	}
+	if (devlink_region_get_by_name(devlink, ops->name))
+		return ERR_PTR(-EEXIST);
 
 	region = kzalloc(sizeof(*region), GFP_KERNEL);
-	if (!region) {
-		err = -ENOMEM;
-		goto unlock;
-	}
+	if (!region)
+		return ERR_PTR(-ENOMEM);
 
 	region->devlink = devlink;
 	region->max_snapshots = region_max_snapshots;
@@ -11231,12 +11226,32 @@ devlink_region_create(struct devlink *devlink,
 	list_add_tail(&region->list, &devlink->region_list);
 	devlink_nl_region_notify(region, NULL, DEVLINK_CMD_REGION_NEW);
 
-	devl_unlock(devlink);
 	return region;
+}
+EXPORT_SYMBOL_GPL(devl_region_create);
 
-unlock:
+/**
+ *	devlink_region_create - create a new address region
+ *
+ *	@devlink: devlink
+ *	@ops: region operations and name
+ *	@region_max_snapshots: Maximum supported number of snapshots for region
+ *	@region_size: size of region
+ *
+ *	Context: Takes and release devlink->lock <mutex>.
+ */
+struct devlink_region *
+devlink_region_create(struct devlink *devlink,
+		      const struct devlink_region_ops *ops,
+		      u32 region_max_snapshots, u64 region_size)
+{
+	struct devlink_region *region;
+
+	devl_lock(devlink);
+	region = devl_region_create(devlink, ops, region_max_snapshots,
+				    region_size);
 	devl_unlock(devlink);
-	return ERR_PTR(err);
+	return region;
 }
 EXPORT_SYMBOL_GPL(devlink_region_create);
 
@@ -11247,6 +11262,8 @@ EXPORT_SYMBOL_GPL(devlink_region_create);
  *	@ops: region operations and name
  *	@region_max_snapshots: Maximum supported number of snapshots for region
  *	@region_size: size of region
+ *
+ *	Context: Takes and release devlink->lock <mutex>.
  */
 struct devlink_region *
 devlink_port_region_create(struct devlink_port *port,
@@ -11292,16 +11309,16 @@ devlink_port_region_create(struct devlink_port *port,
 EXPORT_SYMBOL_GPL(devlink_port_region_create);
 
 /**
- *	devlink_region_destroy - destroy address region
+ * devl_region_destroy - destroy address region
  *
- *	@region: devlink region to destroy
+ * @region: devlink region to destroy
  */
-void devlink_region_destroy(struct devlink_region *region)
+void devl_region_destroy(struct devlink_region *region)
 {
 	struct devlink *devlink = region->devlink;
 	struct devlink_snapshot *snapshot, *ts;
 
-	devl_lock(devlink);
+	devl_assert_locked(devlink);
 
 	/* Free all snapshots of region */
 	list_for_each_entry_safe(snapshot, ts, &region->snapshot_list, list)
@@ -11310,9 +11327,25 @@ void devlink_region_destroy(struct devlink_region *region)
 	list_del(&region->list);
 
 	devlink_nl_region_notify(region, NULL, DEVLINK_CMD_REGION_DEL);
-	devl_unlock(devlink);
 	kfree(region);
 }
+EXPORT_SYMBOL_GPL(devl_region_destroy);
+
+/**
+ *	devlink_region_destroy - destroy address region
+ *
+ *	@region: devlink region to destroy
+ *
+ *	Context: Takes and release devlink->lock <mutex>.
+ */
+void devlink_region_destroy(struct devlink_region *region)
+{
+	struct devlink *devlink = region->devlink;
+
+	devl_lock(devlink);
+	devl_region_destroy(region);
+	devl_unlock(devlink);
+}
 EXPORT_SYMBOL_GPL(devlink_region_destroy);
 
 /**
-- 
2.35.3

