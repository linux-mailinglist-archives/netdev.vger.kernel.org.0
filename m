Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 956CF5717FA
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 13:05:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232898AbiGLLF0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 07:05:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232454AbiGLLFU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 07:05:20 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C760DAF777
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 04:05:18 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id v12so9598902edc.10
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 04:05:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QKNjYK2e47t8eR9VFa+EBsqxMYUgmZu80vN1xHOyWp4=;
        b=NTNsEoVoP14MFHJYR7fuRgT5PRNnJMmvokN6lnkbvqI9AFxcqtLVIgF8zgcSwmP+bw
         mS5KKzZbhsO/DmpBikePF4J5xtJJQ2m/LdpKIMil7W7zOSjpIXU7a9qT63EhhUiV0aYm
         kA74hs5AP59ygZNd03e3nI5DrtnGVY6/l37NYJNwjxYw0gXjlqra0i9KnuJWjjPN4OIQ
         7/s3qZg0QLDa+KWgexnLJVHVECjp1c+x7AVquKcuMMM5Kxtg9fU/oE9gmxnArJqfAX7W
         wzYb5QXpjKHI25/b6SSULkKwAO7ie3GYa6BN5aOyCrSHoMx8Z7s1NYsBdyahUZy7/qvI
         jt/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QKNjYK2e47t8eR9VFa+EBsqxMYUgmZu80vN1xHOyWp4=;
        b=Yj6vyvpWNqaFPFWUOKeaD73UUNz4+wwwW5JeNl5YjudXkeGV9+Ih6nkMq0u7ITEinn
         svZuY34FEc8wyVcNORxoP2UW5XZVlVDCHQfVs6QLrf8bf7M6RZUBJSzTa2jMPQxqurZJ
         WUfRdt+K+jDAaJT3GIjE2H3w9iFx/g0YhL0RkTFmBWRVdG85X8UYZXvEPV4YOg2fSn+B
         QOUSjtPRV4dZ2ucEAjU83gQqTGCy0MQMTxyrgwj3XoYHIuIj97cbHOQN3QRpfkYtOZ1v
         fnXGT74hzR1tUBZ5a26xHnyxwMS/4qPpl63XxCJCaOkSulC+OcF2fVb/lFY1/VzuPGsZ
         t3cQ==
X-Gm-Message-State: AJIora/n8c0Omep9nlDrh2xF/ou2q4uFlNxKKn69/pmLNyJUsho3T/gw
        pV2HxqXqvPTQ6Qlmu3wT4LUYok+M5wJ5AHrxReA=
X-Google-Smtp-Source: AGRyM1tyfZSyjINuDSlWGpJwKyrPRVY7Kqw4Y6vN0HOVH7qEbwDHxrH+xq1wjW5FpYxooTAZczho9Q==
X-Received: by 2002:a05:6402:348e:b0:43a:953d:ade8 with SMTP id v14-20020a056402348e00b0043a953dade8mr31125463edc.135.1657623917326;
        Tue, 12 Jul 2022 04:05:17 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id r17-20020a1709061bb100b0072b616ade26sm1627445ejg.216.2022.07.12.04.05.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 04:05:16 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, mlxsw@nvidia.com, idosch@nvidia.com,
        saeedm@nvidia.com, moshe@nvidia.com, tariqt@nvidia.com
Subject: [patch net-next RFC 03/10] net: devlink: add unlocked variants of devlink_resource*() functions
Date:   Tue, 12 Jul 2022 13:05:04 +0200
Message-Id: <20220712110511.2834647-4-jiri@resnulli.us>
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

Add unlocked variants of devlink_resource*() functions to be used
in drivers called-in with devlink->lock held.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 include/net/devlink.h |  17 ++++
 net/core/devlink.c    | 217 ++++++++++++++++++++++++++++++------------
 2 files changed, 173 insertions(+), 61 deletions(-)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index a3b4601412ca..86b2b9f466f9 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1608,23 +1608,40 @@ extern struct devlink_dpipe_header devlink_dpipe_header_ethernet;
 extern struct devlink_dpipe_header devlink_dpipe_header_ipv4;
 extern struct devlink_dpipe_header devlink_dpipe_header_ipv6;
 
+int devl_resource_register(struct devlink *devlink,
+			   const char *resource_name,
+			   u64 resource_size,
+			   u64 resource_id,
+			   u64 parent_resource_id,
+			   const struct devlink_resource_size_params *size_params);
 int devlink_resource_register(struct devlink *devlink,
 			      const char *resource_name,
 			      u64 resource_size,
 			      u64 resource_id,
 			      u64 parent_resource_id,
 			      const struct devlink_resource_size_params *size_params);
+void devl_resources_unregister(struct devlink *devlink);
 void devlink_resources_unregister(struct devlink *devlink);
+int devl_resource_size_get(struct devlink *devlink,
+			   u64 resource_id,
+			   u64 *p_resource_size);
 int devlink_resource_size_get(struct devlink *devlink,
 			      u64 resource_id,
 			      u64 *p_resource_size);
 int devlink_dpipe_table_resource_set(struct devlink *devlink,
 				     const char *table_name, u64 resource_id,
 				     u64 resource_units);
+void devl_resource_occ_get_register(struct devlink *devlink,
+				    u64 resource_id,
+				    devlink_resource_occ_get_t *occ_get,
+				    void *occ_get_priv);
 void devlink_resource_occ_get_register(struct devlink *devlink,
 				       u64 resource_id,
 				       devlink_resource_occ_get_t *occ_get,
 				       void *occ_get_priv);
+void devl_resource_occ_get_unregister(struct devlink *devlink,
+				      u64 resource_id);
+
 void devlink_resource_occ_get_unregister(struct devlink *devlink,
 					 u64 resource_id);
 int devlink_params_register(struct devlink *devlink,
diff --git a/net/core/devlink.c b/net/core/devlink.c
index bf27b95c32c8..5b89fea9bc9b 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -10555,45 +10555,41 @@ void devlink_dpipe_table_unregister(struct devlink *devlink,
 EXPORT_SYMBOL_GPL(devlink_dpipe_table_unregister);
 
 /**
- *	devlink_resource_register - devlink resource register
+ * devl_resource_register - devlink resource register
  *
- *	@devlink: devlink
- *	@resource_name: resource's name
- *	@resource_size: resource's size
- *	@resource_id: resource's id
- *	@parent_resource_id: resource's parent id
- *	@size_params: size parameters
+ * @devlink: devlink
+ * @resource_name: resource's name
+ * @resource_size: resource's size
+ * @resource_id: resource's id
+ * @parent_resource_id: resource's parent id
+ * @size_params: size parameters
  *
- *	Generic resources should reuse the same names across drivers.
- *	Please see the generic resources list at:
- *	Documentation/networking/devlink/devlink-resource.rst
+ * Generic resources should reuse the same names across drivers.
+ * Please see the generic resources list at:
+ * Documentation/networking/devlink/devlink-resource.rst
  */
-int devlink_resource_register(struct devlink *devlink,
-			      const char *resource_name,
-			      u64 resource_size,
-			      u64 resource_id,
-			      u64 parent_resource_id,
-			      const struct devlink_resource_size_params *size_params)
+int devl_resource_register(struct devlink *devlink,
+			   const char *resource_name,
+			   u64 resource_size,
+			   u64 resource_id,
+			   u64 parent_resource_id,
+			   const struct devlink_resource_size_params *size_params)
 {
 	struct devlink_resource *resource;
 	struct list_head *resource_list;
 	bool top_hierarchy;
-	int err = 0;
+
+	lockdep_assert_held(&devlink->lock);
 
 	top_hierarchy = parent_resource_id == DEVLINK_RESOURCE_ID_PARENT_TOP;
 
-	devl_lock(devlink);
 	resource = devlink_resource_find(devlink, NULL, resource_id);
-	if (resource) {
-		err = -EINVAL;
-		goto out;
-	}
+	if (resource)
+		return -EINVAL;
 
 	resource = kzalloc(sizeof(*resource), GFP_KERNEL);
-	if (!resource) {
-		err = -ENOMEM;
-		goto out;
-	}
+	if (!resource)
+		return -ENOMEM;
 
 	if (top_hierarchy) {
 		resource_list = &devlink->resource_list;
@@ -10607,8 +10603,7 @@ int devlink_resource_register(struct devlink *devlink,
 			resource->parent = parent_resource;
 		} else {
 			kfree(resource);
-			err = -EINVAL;
-			goto out;
+			return -EINVAL;
 		}
 	}
 
@@ -10621,7 +10616,39 @@ int devlink_resource_register(struct devlink *devlink,
 	       sizeof(resource->size_params));
 	INIT_LIST_HEAD(&resource->resource_list);
 	list_add_tail(&resource->list, resource_list);
-out:
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(devl_resource_register);
+
+/**
+ *	devlink_resource_register - devlink resource register
+ *
+ *	@devlink: devlink
+ *	@resource_name: resource's name
+ *	@resource_size: resource's size
+ *	@resource_id: resource's id
+ *	@parent_resource_id: resource's parent id
+ *	@size_params: size parameters
+ *
+ *	Generic resources should reuse the same names across drivers.
+ *	Please see the generic resources list at:
+ *	Documentation/networking/devlink/devlink-resource.rst
+ *
+ *	Context: Takes and release devlink->lock <mutex>.
+ */
+int devlink_resource_register(struct devlink *devlink,
+			      const char *resource_name,
+			      u64 resource_size,
+			      u64 resource_id,
+			      u64 parent_resource_id,
+			      const struct devlink_resource_size_params *size_params)
+{
+	int err;
+
+	devl_lock(devlink);
+	err = devl_resource_register(devlink, resource_name, resource_size,
+				     resource_id, parent_resource_id, size_params);
 	devl_unlock(devlink);
 	return err;
 }
@@ -10641,15 +10668,15 @@ static void devlink_resource_unregister(struct devlink *devlink,
 }
 
 /**
- *	devlink_resources_unregister - free all resources
+ * devl_resources_unregister - free all resources
  *
- *	@devlink: devlink
+ * @devlink: devlink
  */
-void devlink_resources_unregister(struct devlink *devlink)
+void devl_resources_unregister(struct devlink *devlink)
 {
 	struct devlink_resource *tmp, *child_resource;
 
-	devl_lock(devlink);
+	lockdep_assert_held(&devlink->lock);
 
 	list_for_each_entry_safe(child_resource, tmp, &devlink->resource_list,
 				 list) {
@@ -10657,34 +10684,65 @@ void devlink_resources_unregister(struct devlink *devlink)
 		list_del(&child_resource->list);
 		kfree(child_resource);
 	}
+}
+EXPORT_SYMBOL_GPL(devl_resources_unregister);
 
+/**
+ *	devlink_resources_unregister - free all resources
+ *
+ *	@devlink: devlink
+ *
+ *	Context: Takes and release devlink->lock <mutex>.
+ */
+void devlink_resources_unregister(struct devlink *devlink)
+{
+	devl_lock(devlink);
+	devl_resources_unregister(devlink);
 	devl_unlock(devlink);
 }
 EXPORT_SYMBOL_GPL(devlink_resources_unregister);
 
+/**
+ * devl_resource_size_get - get and update size
+ *
+ * @devlink: devlink
+ * @resource_id: the requested resource id
+ * @p_resource_size: ptr to update
+ */
+int devl_resource_size_get(struct devlink *devlink,
+			   u64 resource_id,
+			   u64 *p_resource_size)
+{
+	struct devlink_resource *resource;
+
+	lockdep_assert_held(&devlink->lock);
+
+	resource = devlink_resource_find(devlink, NULL, resource_id);
+	if (!resource)
+		return -EINVAL;
+	*p_resource_size = resource->size_new;
+	resource->size = resource->size_new;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(devl_resource_size_get);
+
 /**
  *	devlink_resource_size_get - get and update size
  *
  *	@devlink: devlink
  *	@resource_id: the requested resource id
  *	@p_resource_size: ptr to update
+ *
+ *	Context: Takes and release devlink->lock <mutex>.
  */
 int devlink_resource_size_get(struct devlink *devlink,
 			      u64 resource_id,
 			      u64 *p_resource_size)
 {
-	struct devlink_resource *resource;
-	int err = 0;
+	int err;
 
 	devl_lock(devlink);
-	resource = devlink_resource_find(devlink, NULL, resource_id);
-	if (!resource) {
-		err = -EINVAL;
-		goto out;
-	}
-	*p_resource_size = resource->size_new;
-	resource->size = resource->size_new;
-out:
+	err = devl_resource_size_get(devlink, resource_id, p_resource_size);
 	devl_unlock(devlink);
 	return err;
 }
@@ -10721,6 +10779,33 @@ int devlink_dpipe_table_resource_set(struct devlink *devlink,
 }
 EXPORT_SYMBOL_GPL(devlink_dpipe_table_resource_set);
 
+/**
+ * devl_resource_occ_get_register - register occupancy getter
+ *
+ * @devlink: devlink
+ * @resource_id: resource id
+ * @occ_get: occupancy getter callback
+ * @occ_get_priv: occupancy getter callback priv
+ */
+void devl_resource_occ_get_register(struct devlink *devlink,
+				    u64 resource_id,
+				    devlink_resource_occ_get_t *occ_get,
+				    void *occ_get_priv)
+{
+	struct devlink_resource *resource;
+
+	lockdep_assert_held(&devlink->lock);
+
+	resource = devlink_resource_find(devlink, NULL, resource_id);
+	if (WARN_ON(!resource))
+		return;
+	WARN_ON(resource->occ_get);
+
+	resource->occ_get = occ_get;
+	resource->occ_get_priv = occ_get_priv;
+}
+EXPORT_SYMBOL_GPL(devl_resource_occ_get_register);
+
 /**
  *	devlink_resource_occ_get_register - register occupancy getter
  *
@@ -10728,47 +10813,57 @@ EXPORT_SYMBOL_GPL(devlink_dpipe_table_resource_set);
  *	@resource_id: resource id
  *	@occ_get: occupancy getter callback
  *	@occ_get_priv: occupancy getter callback priv
+ *
+ *	Context: Takes and release devlink->lock <mutex>.
  */
 void devlink_resource_occ_get_register(struct devlink *devlink,
 				       u64 resource_id,
 				       devlink_resource_occ_get_t *occ_get,
 				       void *occ_get_priv)
 {
-	struct devlink_resource *resource;
-
 	devl_lock(devlink);
-	resource = devlink_resource_find(devlink, NULL, resource_id);
-	if (WARN_ON(!resource))
-		goto out;
-	WARN_ON(resource->occ_get);
-
-	resource->occ_get = occ_get;
-	resource->occ_get_priv = occ_get_priv;
-out:
+	devl_resource_occ_get_register(devlink, resource_id,
+				       occ_get, occ_get_priv);
 	devl_unlock(devlink);
 }
 EXPORT_SYMBOL_GPL(devlink_resource_occ_get_register);
 
 /**
- *	devlink_resource_occ_get_unregister - unregister occupancy getter
+ * devl_resource_occ_get_unregister - unregister occupancy getter
  *
- *	@devlink: devlink
- *	@resource_id: resource id
+ * @devlink: devlink
+ * @resource_id: resource id
  */
-void devlink_resource_occ_get_unregister(struct devlink *devlink,
-					 u64 resource_id)
+void devl_resource_occ_get_unregister(struct devlink *devlink,
+				      u64 resource_id)
 {
 	struct devlink_resource *resource;
 
-	devl_lock(devlink);
+	lockdep_assert_held(&devlink->lock);
+
 	resource = devlink_resource_find(devlink, NULL, resource_id);
 	if (WARN_ON(!resource))
-		goto out;
+		return;
 	WARN_ON(!resource->occ_get);
 
 	resource->occ_get = NULL;
 	resource->occ_get_priv = NULL;
-out:
+}
+EXPORT_SYMBOL_GPL(devl_resource_occ_get_unregister);
+
+/**
+ *	devlink_resource_occ_get_unregister - unregister occupancy getter
+ *
+ *	@devlink: devlink
+ *	@resource_id: resource id
+ *
+ *	Context: Takes and release devlink->lock <mutex>.
+ */
+void devlink_resource_occ_get_unregister(struct devlink *devlink,
+					 u64 resource_id)
+{
+	devl_lock(devlink);
+	devl_resource_occ_get_unregister(devlink, resource_id);
 	devl_unlock(devlink);
 }
 EXPORT_SYMBOL_GPL(devlink_resource_occ_get_unregister);
-- 
2.35.3

