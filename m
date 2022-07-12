Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 789D9571CFC
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 16:41:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233601AbiGLOli (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 10:41:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233594AbiGLOl2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 10:41:28 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D86D0BB7F2
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 07:41:25 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id h17so11531184wrx.0
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 07:41:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HZ/hEZMj6s3wSQIshMF2AJAGR1KJ6frTbOjpBJsoTxY=;
        b=TM7vXzzkbla6QZm4C13OPHDe5C4LR0H2JDiehB+v4Dkqy7vqjGsaTc2VVetYHHdYDO
         OvTI0ZRjitzxilzm0kO9wPyuY6AQp5e1QaDjdmpm+KDibOUKfhd870REPR0DIox4KpEN
         /1E3y6qfotzYBJsJSfuo12GdTipDcNsM7muufx4vNIU1pS6uxZVowoQRYNKji1lt0Vn1
         F3MJ5w/VK68I3SvlxjPoQ84nJKas3nEJMAJJ2w67qIshWDVtpa3P9jvk+8zTeeWlMKuH
         CNjiMfWshjO0zzwVwvzxHztq3xn27vWHVIVMayr98yMS8RUbUhfJqPaUCjZSAoXGgmgc
         l3BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HZ/hEZMj6s3wSQIshMF2AJAGR1KJ6frTbOjpBJsoTxY=;
        b=5ivFn/C8vrFc3ExQgLe3/lwP8vjFY6H71pJ5UGYOZ6Pysew0506PDKP8pQnhwxE8bK
         QXEj/oLv89jEt6JQ35jh6oe+6LmG4ohpX6cSexpQgfwgOQxRI02Xz0uujVSGYizv5mgN
         Bb0bA+L+Ht5zSvUjz31S4GQz2Ux47Wi6ik5I4IkkXI/fQ9CDh/m++7L9m7/g2kO/FMRk
         T6VVnFprOxWANb5rNNxtE9lr3YdaKldS8pU02p4X3it4JJ8irnQ0kFugIKJ5No5K2AAJ
         dsxSZQLgt2QmGNl5ewlEOWQZKpCuYj1sgzLrGB+e3ctnKiHmCz1b3Iz1RHjmCW8MCfhA
         mNeQ==
X-Gm-Message-State: AJIora+6OGK7GpH17ZD1mjQ2tm+tSWWJaQH6ifA1JY+pimGxPy3113X3
        OAX0wqxADm6vy04SnoneKNwRq8HRm4JjkK1wN2I=
X-Google-Smtp-Source: AGRyM1tiCy//Mu4FN/WneUCq5NvcET8DAW30+03EYcxCaOWDl7uzUM0hG5p+7gPyv8nT6NyRtHEWtA==
X-Received: by 2002:adf:e952:0:b0:21d:6d98:1b5b with SMTP id m18-20020adfe952000000b0021d6d981b5bmr22450808wrn.174.1657636884257;
        Tue, 12 Jul 2022 07:41:24 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id y5-20020adff6c5000000b0021d83071683sm8507572wrp.64.2022.07.12.07.41.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 07:41:23 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, mlxsw@nvidia.com, idosch@nvidia.com,
        saeedm@nvidia.com, moshe@nvidia.com, tariqt@nvidia.com
Subject: [patch net-next RFCv2 7/9] net: devlink: add unlocked variants of devlink_region_create/destroy() functions
Date:   Tue, 12 Jul 2022 16:41:10 +0200
Message-Id: <20220712144112.2905407-8-jiri@resnulli.us>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220712144112.2905407-1-jiri@resnulli.us>
References: <20220712144112.2905407-1-jiri@resnulli.us>
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

