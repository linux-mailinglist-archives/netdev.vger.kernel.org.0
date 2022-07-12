Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B68A75717FE
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 13:05:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232911AbiGLLFg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 07:05:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232705AbiGLLFc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 07:05:32 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5E46B026C
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 04:05:26 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id r18so9623188edb.9
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 04:05:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WGCBfhN29dgbO0pfBhek6Uyh222X4gB24Xx94h1xeFY=;
        b=yj5RA3KdPFYv2LW/CNu3sJmaJf4OCGXaN247QT5KcoUum2DPJyJKqbLPbuGrzIE/OK
         ZE3ewIGI5WuZ/gFFvLlHW8iqZFVHEZKe6dHou1tNYPF1ca6vmw8HEBKNXLOuc2nZwTli
         0Gi9qpAkizHlQb2s6IW+sB/zF6lJzHKCCPDXEQxWxw4HOsHmrpjO0ZTwWAYpmnorb9o+
         vqnqkNdBSsEr5AfbphiBj4pWLA7GXd4G1/Z87G0gdF5h0aStd1P3dGd17LCnSCDsklts
         EO2umFRJx3TXPJWl2nJhjTYebMzobpv1As6jFCyMfhvMJLPqYt9C2S4+SJV0rV1k73zn
         F6+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WGCBfhN29dgbO0pfBhek6Uyh222X4gB24Xx94h1xeFY=;
        b=ggvQv/zkSMSaB32kv2Sm8QYv2TIhjYUpbnJyWFbOs8j20Cyl02YipPrUPR8EXO0o8Z
         AAh4wpcNl/8Mk0+8/1XMoTMVbJDF3Lc9GM9oI6OAUUonljo0sMRo8lQfDVeiJSZ1VzRj
         J0CU0sf354dVR6dni7wgOuUwxAbtjJ6OGMyyFKBZXpLSTf2F7xy+eVk0eQQlQoOHEJIO
         akghIPspAJVVVTj2vMwH4WXqt5x8a1lRbafvzUOqKnPosRMuyQEYulR3Yl/7+j5If8oj
         mwV54vTrXTmdNW4aFnnGut08uEpBn994QHMKt/zOHdJG76y7OXSOJ200JFgOXTw6adEJ
         dJLQ==
X-Gm-Message-State: AJIora/8JV7Dd8YJMeqEpKnM7wkddSYkPGBQepbrgjHwlX/b3pRqtjMz
        njDlmImUGKPZBZAI0Ev+PhW2fM07h5QiGK8FgoM=
X-Google-Smtp-Source: AGRyM1uU1GfcRhr2hhczlBsBu3U1NNw6Dvb8pNSWQq9Jc2win3yz/c5ExuwLFckbHPhW/dYFsCIv1Q==
X-Received: by 2002:a05:6402:2753:b0:43a:d6f2:9839 with SMTP id z19-20020a056402275300b0043ad6f29839mr11866281edd.73.1657623925230;
        Tue, 12 Jul 2022 04:05:25 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id ks6-20020a170906f84600b0072ae8fb13e6sm3647408ejb.126.2022.07.12.04.05.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 04:05:24 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, mlxsw@nvidia.com, idosch@nvidia.com,
        saeedm@nvidia.com, moshe@nvidia.com, tariqt@nvidia.com
Subject: [patch net-next RFC 08/10] net: devlink: add unlocked variants of devlink_region_create/destroy() functions
Date:   Tue, 12 Jul 2022 13:05:09 +0200
Message-Id: <20220712110511.2834647-9-jiri@resnulli.us>
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

From: Jiri Pirko <jiri@nvidia.com>

Add unlocked variants of devlink_region_create/destroy() functions
to be used in drivers called-in with devlink->lock held.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 include/net/devlink.h |  5 +++
 net/core/devlink.c    | 85 +++++++++++++++++++++++++++++--------------
 2 files changed, 62 insertions(+), 28 deletions(-)

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
index efd0772e8c42..04d04e01712b 100644
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
 
@@ -11292,16 +11307,16 @@ devlink_port_region_create(struct devlink_port *port,
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
@@ -11310,9 +11325,23 @@ void devlink_region_destroy(struct devlink_region *region)
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

