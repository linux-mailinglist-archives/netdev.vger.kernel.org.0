Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4174576D64
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 13:03:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230072AbiGPLDA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jul 2022 07:03:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230059AbiGPLC4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jul 2022 07:02:56 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E428227CD6
        for <netdev@vger.kernel.org>; Sat, 16 Jul 2022 04:02:53 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id ss3so12977411ejc.11
        for <netdev@vger.kernel.org>; Sat, 16 Jul 2022 04:02:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TMG4cSzrcInDG2y86AIHeziU41PF34b2/m+zjygpxDQ=;
        b=m5T/whncS3cbdvVbdfURRFSXSH9SKyhetDLVowBKFk3n5Yx7g8iqjaL1kS4RkCoC2W
         04Z68InJuou0S/JWBHcwhqHoZD8t6oWJfmZiFyIboQ9FH0Ga/fSJB0iqZYFX5G4oFAtW
         SCrjJoh3Ej0Xxg9dBfuKEu9V1GTeB9B5/EbQE+/m26sJiUCr9bu0fKsnqrfKpOp24obw
         NItJ/OkUWRmweANdmfFARH+m7vUtE68Yq9Qc7djECECYVp1Ym3lIQ7j38Age9hjg9VBs
         9tDlCnX5rX/CxcEYqWChRh5amE9dbmBZgCUKpIf9k/dEd7Ojq7cUKHAD8LKrMMKBCMgn
         2pcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TMG4cSzrcInDG2y86AIHeziU41PF34b2/m+zjygpxDQ=;
        b=xwqoQPd/P7Ea5MqudGfFchvga2Jcl3MsWDhphFyiyCSxK1U4Y1qRqFrSJNWbF1kQMT
         I39n/WRhZP0XPchRZKt8kB6gIV6V7Kd8aXhTnvcNEJPIAY/9J/UTZqBU9Nus+OO759iT
         00p9YeoWoTVvBbGYtWNT5xBo4Do7Pnb5Y6Hse5S9TrvRNI7CV7pvLGRqwoCVEOx6u2b5
         tLznsFlY7IExpPgqL6LZ3aZSZCXxaHa6tHA3lsOT/pmk4KHbVcTdG41E2MEFbpjacNDc
         wZXhzbaYcmpvE97hUJ5FFKCwFBs0Q4Vw4WjLZaNqWOtNtfWh6YQfsFpIQbXzEJTbpzu/
         xeYw==
X-Gm-Message-State: AJIora+t9joOvkW44udqheUH/aqOkuwhjZ9jmmxgJp2DYkv/CKu3ezH/
        WijOvpJEjfwuos3bi/opFawHGV7A+vfDp0BE
X-Google-Smtp-Source: AGRyM1sUJMC84KbXynWznbnV92oxmvq77A9Lh0dlAp65WBlOrbV/kz08QA9MVinlFvbZ8SQ7HeD13g==
X-Received: by 2002:a17:906:9bdd:b0:72b:3cab:eade with SMTP id de29-20020a1709069bdd00b0072b3cabeademr17849278ejc.58.1657969372346;
        Sat, 16 Jul 2022 04:02:52 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id k15-20020a17090632cf00b0072afb9fe3f3sm3046192ejk.110.2022.07.16.04.02.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Jul 2022 04:02:51 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, mlxsw@nvidia.com, idosch@nvidia.com,
        saeedm@nvidia.com, moshe@nvidia.com, tariqt@nvidia.com
Subject: [patch net-next 5/9] net: devlink: add unlocked variants of devlink_dpipe*() functions
Date:   Sat, 16 Jul 2022 13:02:37 +0200
Message-Id: <20220716110241.3390528-6-jiri@resnulli.us>
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

Add unlocked variants of devlink_dpipe*() functions to be used
in drivers called-in with devlink->lock held.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 include/net/devlink.h |  12 +++
 net/core/devlink.c    | 181 +++++++++++++++++++++++++++++++-----------
 2 files changed, 147 insertions(+), 46 deletions(-)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index 0057809a13b0..18ad88527847 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1589,14 +1589,23 @@ int devlink_sb_register(struct devlink *devlink, unsigned int sb_index,
 			u16 egress_tc_count);
 void devl_sb_unregister(struct devlink *devlink, unsigned int sb_index);
 void devlink_sb_unregister(struct devlink *devlink, unsigned int sb_index);
+int devl_dpipe_table_register(struct devlink *devlink,
+			      const char *table_name,
+			      struct devlink_dpipe_table_ops *table_ops,
+			      void *priv, bool counter_control_extern);
 int devlink_dpipe_table_register(struct devlink *devlink,
 				 const char *table_name,
 				 struct devlink_dpipe_table_ops *table_ops,
 				 void *priv, bool counter_control_extern);
+void devl_dpipe_table_unregister(struct devlink *devlink,
+				 const char *table_name);
 void devlink_dpipe_table_unregister(struct devlink *devlink,
 				    const char *table_name);
+void devl_dpipe_headers_register(struct devlink *devlink,
+				 struct devlink_dpipe_headers *dpipe_headers);
 void devlink_dpipe_headers_register(struct devlink *devlink,
 				   struct devlink_dpipe_headers *dpipe_headers);
+void devl_dpipe_headers_unregister(struct devlink *devlink);
 void devlink_dpipe_headers_unregister(struct devlink *devlink);
 bool devlink_dpipe_table_counter_enabled(struct devlink *devlink,
 					 const char *table_name);
@@ -1633,6 +1642,9 @@ int devl_resource_size_get(struct devlink *devlink,
 int devlink_resource_size_get(struct devlink *devlink,
 			      u64 resource_id,
 			      u64 *p_resource_size);
+int devl_dpipe_table_resource_set(struct devlink *devlink,
+				  const char *table_name, u64 resource_id,
+				  u64 resource_units);
 int devlink_dpipe_table_resource_set(struct devlink *devlink,
 				     const char *table_name, u64 resource_id,
 				     u64 resource_units);
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 64dab4024d11..b249c18a8bbc 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -10438,6 +10438,23 @@ void devlink_sb_unregister(struct devlink *devlink, unsigned int sb_index)
 }
 EXPORT_SYMBOL_GPL(devlink_sb_unregister);
 
+/**
+ * devl_dpipe_headers_register - register dpipe headers
+ *
+ * @devlink: devlink
+ * @dpipe_headers: dpipe header array
+ *
+ * Register the headers supported by hardware.
+ */
+void devl_dpipe_headers_register(struct devlink *devlink,
+				 struct devlink_dpipe_headers *dpipe_headers)
+{
+	lockdep_assert_held(&devlink->lock);
+
+	devlink->dpipe_headers = dpipe_headers;
+}
+EXPORT_SYMBOL_GPL(devl_dpipe_headers_register);
+
 /**
  *	devlink_dpipe_headers_register - register dpipe headers
  *
@@ -10445,27 +10462,46 @@ EXPORT_SYMBOL_GPL(devlink_sb_unregister);
  *	@dpipe_headers: dpipe header array
  *
  *	Register the headers supported by hardware.
+ *
+ *	Context: Takes and release devlink->lock <mutex>.
  */
 void devlink_dpipe_headers_register(struct devlink *devlink,
 				    struct devlink_dpipe_headers *dpipe_headers)
 {
 	devl_lock(devlink);
-	devlink->dpipe_headers = dpipe_headers;
+	devl_dpipe_headers_register(devlink, dpipe_headers);
 	devl_unlock(devlink);
 }
 EXPORT_SYMBOL_GPL(devlink_dpipe_headers_register);
 
+/**
+ * devl_dpipe_headers_unregister - unregister dpipe headers
+ *
+ * @devlink: devlink
+ *
+ * Unregister the headers supported by hardware.
+ */
+void devl_dpipe_headers_unregister(struct devlink *devlink)
+{
+	lockdep_assert_held(&devlink->lock);
+
+	devlink->dpipe_headers = NULL;
+}
+EXPORT_SYMBOL_GPL(devl_dpipe_headers_unregister);
+
 /**
  *	devlink_dpipe_headers_unregister - unregister dpipe headers
  *
  *	@devlink: devlink
  *
  *	Unregister the headers supported by hardware.
+ *
+ *	Context: Takes and release devlink->lock <mutex>.
  */
 void devlink_dpipe_headers_unregister(struct devlink *devlink)
 {
 	devl_lock(devlink);
-	devlink->dpipe_headers = NULL;
+	devl_dpipe_headers_unregister(devlink);
 	devl_unlock(devlink);
 }
 EXPORT_SYMBOL_GPL(devlink_dpipe_headers_unregister);
@@ -10502,38 +10538,33 @@ bool devlink_dpipe_table_counter_enabled(struct devlink *devlink,
 EXPORT_SYMBOL_GPL(devlink_dpipe_table_counter_enabled);
 
 /**
- *	devlink_dpipe_table_register - register dpipe table
+ * devl_dpipe_table_register - register dpipe table
  *
- *	@devlink: devlink
- *	@table_name: table name
- *	@table_ops: table ops
- *	@priv: priv
- *	@counter_control_extern: external control for counters
+ * @devlink: devlink
+ * @table_name: table name
+ * @table_ops: table ops
+ * @priv: priv
+ * @counter_control_extern: external control for counters
  */
-int devlink_dpipe_table_register(struct devlink *devlink,
-				 const char *table_name,
-				 struct devlink_dpipe_table_ops *table_ops,
-				 void *priv, bool counter_control_extern)
+int devl_dpipe_table_register(struct devlink *devlink,
+			      const char *table_name,
+			      struct devlink_dpipe_table_ops *table_ops,
+			      void *priv, bool counter_control_extern)
 {
 	struct devlink_dpipe_table *table;
-	int err = 0;
+
+	lockdep_assert_held(&devlink->lock);
 
 	if (WARN_ON(!table_ops->size_get))
 		return -EINVAL;
 
-	devl_lock(devlink);
-
 	if (devlink_dpipe_table_find(&devlink->dpipe_table_list, table_name,
-				     devlink)) {
-		err = -EEXIST;
-		goto unlock;
-	}
+				     devlink))
+		return -EEXIST;
 
 	table = kzalloc(sizeof(*table), GFP_KERNEL);
-	if (!table) {
-		err = -ENOMEM;
-		goto unlock;
-	}
+	if (!table)
+		return -ENOMEM;
 
 	table->name = table_name;
 	table->table_ops = table_ops;
@@ -10541,33 +10572,72 @@ int devlink_dpipe_table_register(struct devlink *devlink,
 	table->counter_control_extern = counter_control_extern;
 
 	list_add_tail_rcu(&table->list, &devlink->dpipe_table_list);
-unlock:
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(devl_dpipe_table_register);
+
+/**
+ *	devlink_dpipe_table_register - register dpipe table
+ *
+ *	@devlink: devlink
+ *	@table_name: table name
+ *	@table_ops: table ops
+ *	@priv: priv
+ *	@counter_control_extern: external control for counters
+ *
+ *	Context: Takes and release devlink->lock <mutex>.
+ */
+int devlink_dpipe_table_register(struct devlink *devlink,
+				 const char *table_name,
+				 struct devlink_dpipe_table_ops *table_ops,
+				 void *priv, bool counter_control_extern)
+{
+	int err;
+
+	devl_lock(devlink);
+	err = devl_dpipe_table_register(devlink, table_name, table_ops, priv,
+					counter_control_extern);
 	devl_unlock(devlink);
 	return err;
 }
 EXPORT_SYMBOL_GPL(devlink_dpipe_table_register);
 
 /**
- *	devlink_dpipe_table_unregister - unregister dpipe table
+ * devl_dpipe_table_unregister - unregister dpipe table
  *
- *	@devlink: devlink
- *	@table_name: table name
+ * @devlink: devlink
+ * @table_name: table name
  */
-void devlink_dpipe_table_unregister(struct devlink *devlink,
-				    const char *table_name)
+void devl_dpipe_table_unregister(struct devlink *devlink,
+				 const char *table_name)
 {
 	struct devlink_dpipe_table *table;
 
-	devl_lock(devlink);
+	lockdep_assert_held(&devlink->lock);
+
 	table = devlink_dpipe_table_find(&devlink->dpipe_table_list,
 					 table_name, devlink);
 	if (!table)
-		goto unlock;
+		return;
 	list_del_rcu(&table->list);
-	devl_unlock(devlink);
 	kfree_rcu(table, rcu);
-	return;
-unlock:
+}
+EXPORT_SYMBOL_GPL(devl_dpipe_table_unregister);
+
+/**
+ *	devlink_dpipe_table_unregister - unregister dpipe table
+ *
+ *	@devlink: devlink
+ *	@table_name: table name
+ *
+ *	Context: Takes and release devlink->lock <mutex>.
+ */
+void devlink_dpipe_table_unregister(struct devlink *devlink,
+				    const char *table_name)
+{
+	devl_lock(devlink);
+	devl_dpipe_table_unregister(devlink, table_name);
 	devl_unlock(devlink);
 }
 EXPORT_SYMBOL_GPL(devlink_dpipe_table_unregister);
@@ -10766,6 +10836,32 @@ int devlink_resource_size_get(struct devlink *devlink,
 }
 EXPORT_SYMBOL_GPL(devlink_resource_size_get);
 
+/**
+ * devl_dpipe_table_resource_set - set the resource id
+ *
+ * @devlink: devlink
+ * @table_name: table name
+ * @resource_id: resource id
+ * @resource_units: number of resource's units consumed per table's entry
+ */
+int devl_dpipe_table_resource_set(struct devlink *devlink,
+				  const char *table_name, u64 resource_id,
+				  u64 resource_units)
+{
+	struct devlink_dpipe_table *table;
+
+	table = devlink_dpipe_table_find(&devlink->dpipe_table_list,
+					 table_name, devlink);
+	if (!table)
+		return -EINVAL;
+
+	table->resource_id = resource_id;
+	table->resource_units = resource_units;
+	table->resource_valid = true;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(devl_dpipe_table_resource_set);
+
 /**
  *	devlink_dpipe_table_resource_set - set the resource id
  *
@@ -10773,25 +10869,18 @@ EXPORT_SYMBOL_GPL(devlink_resource_size_get);
  *	@table_name: table name
  *	@resource_id: resource id
  *	@resource_units: number of resource's units consumed per table's entry
+ *
+ *	Context: Takes and release devlink->lock <mutex>.
  */
 int devlink_dpipe_table_resource_set(struct devlink *devlink,
 				     const char *table_name, u64 resource_id,
 				     u64 resource_units)
 {
-	struct devlink_dpipe_table *table;
-	int err = 0;
+	int err;
 
 	devl_lock(devlink);
-	table = devlink_dpipe_table_find(&devlink->dpipe_table_list,
-					 table_name, devlink);
-	if (!table) {
-		err = -EINVAL;
-		goto out;
-	}
-	table->resource_id = resource_id;
-	table->resource_units = resource_units;
-	table->resource_valid = true;
-out:
+	err = devl_dpipe_table_resource_set(devlink, table_name,
+					    resource_id, resource_units);
 	devl_unlock(devlink);
 	return err;
 }
-- 
2.35.3

