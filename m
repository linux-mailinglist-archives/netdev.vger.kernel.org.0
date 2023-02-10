Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90833691C2E
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 11:02:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231910AbjBJKCT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 05:02:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231924AbjBJKCD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 05:02:03 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DD3D7B171
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 02:01:42 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id l37-20020a05600c1d2500b003dfe46a9801so3679197wms.0
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 02:01:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4iPhHLVHFiLK/CcXApMjBBlb2ZIKZw0M3IzMHppkPVE=;
        b=i2vd8SeiuvpnbCusC+fgh0ujgrjbQdOttYP17CbsoVvIQt9qwA8tCA+o4TnMRHMONK
         5dLj5AzwbSPKiF7izckJ1c2w+p90wzD3HyK28yxiC6lxyWfz089kbzTVk6VRfEfZn4AE
         MF9vd5bsIeUEeuBqHQ7RJEULL1miX2cm2P6MRh6ANOs3qzdAeeMWRQAL9fPejDNWAWbb
         FPAVxfufm3mqsGLxQrxOINmIeNacalKsaB1pfxYo7u+Lk2u3KOruxzZ63gmV4Jg+sxyu
         OuRPX06qF4BPY2bEy6Tz+LY3tlS/RGeh5VwyveOXbnb8cxCcjMTaQZJkpHNo+ycEoFe9
         YOjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4iPhHLVHFiLK/CcXApMjBBlb2ZIKZw0M3IzMHppkPVE=;
        b=yjgZ0P2oCY/TjyKufQcjpuxf+RJL79JGvfoowLoaceZnE9cTZCSse78/lq3SzA5WUW
         3DDFGFIGF3oarEu9n+Ln8NHyRrtketPlsxReKPWcs/K4BReryICezMFMQsRqSVeo5ep2
         8tgyj8NSrCcPSfF8B9vqUE+PqBkyvLxpA4IMv7VPksrWTEh3ix/rapKLsKWjgIu5rfiB
         iwnjO+TUG97AMm1Xf7LdPCNMj0zklygkJxHWzvG9FauwJXvVnaGZXQQfc0gZN/5Hw8Bf
         3ynutilbH15ptHzVCpHBsZ+A0MOSPm8MF1dipmAW1MLB4MiJjsucPXoSzPa/FxgNHMKv
         8ASA==
X-Gm-Message-State: AO0yUKULjhr8mYHGC8qc/vyQ8kOv0XfnccFhUVOxBDbfIDpv0tIto5vL
        kezwKEs3c5Y7x4KW5/AXf9eBhMcn1lbkOkREK98=
X-Google-Smtp-Source: AK7set92vduOKOqNk33ICmT/Q2WW0NIWeL3rXXR1vhKKyokXJUf0E8d1fkLs7PPuH/U7L1Ujr1tRsw==
X-Received: by 2002:a05:600c:16d4:b0:3e0:fad:675a with SMTP id l20-20020a05600c16d400b003e00fad675amr11787921wmn.38.1676023300948;
        Fri, 10 Feb 2023 02:01:40 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id q11-20020a7bce8b000000b003dd9232f036sm7476002wmj.23.2023.02.10.02.01.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Feb 2023 02:01:40 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, tariqt@nvidia.com, saeedm@nvidia.com,
        jacob.e.keller@intel.com, gal@nvidia.com, kim.phillips@amd.com,
        moshe@nvidia.com, simon.horman@corigine.com, idosch@nvidia.com
Subject: [patch net-next v2 5/7] devlink: convert param list to xarray
Date:   Fri, 10 Feb 2023 11:01:29 +0100
Message-Id: <20230210100131.3088240-6-jiri@resnulli.us>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230210100131.3088240-1-jiri@resnulli.us>
References: <20230210100131.3088240-1-jiri@resnulli.us>
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

Loose the linked list for params and use xarray instead.

Note that this is required to be eventually possible to call
devl_param_driverinit_value_get() without holding instance lock.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Acked-by: Jakub Kicinski <kuba@kernel.org>
---
v1->v2:
- extended patch description with a note
---
 net/devlink/core.c          |  4 +--
 net/devlink/devl_internal.h |  2 +-
 net/devlink/leftover.c      | 72 ++++++++++++++++++-------------------
 3 files changed, 39 insertions(+), 39 deletions(-)

diff --git a/net/devlink/core.c b/net/devlink/core.c
index a4f47dafb864..777b091ef74d 100644
--- a/net/devlink/core.c
+++ b/net/devlink/core.c
@@ -212,6 +212,7 @@ struct devlink *devlink_alloc_ns(const struct devlink_ops *ops,
 	devlink->dev = dev;
 	devlink->ops = ops;
 	xa_init_flags(&devlink->ports, XA_FLAGS_ALLOC);
+	xa_init_flags(&devlink->params, XA_FLAGS_ALLOC);
 	xa_init_flags(&devlink->snapshot_ids, XA_FLAGS_ALLOC);
 	write_pnet(&devlink->_net, net);
 	INIT_LIST_HEAD(&devlink->rate_list);
@@ -219,7 +220,6 @@ struct devlink *devlink_alloc_ns(const struct devlink_ops *ops,
 	INIT_LIST_HEAD(&devlink->sb_list);
 	INIT_LIST_HEAD_RCU(&devlink->dpipe_table_list);
 	INIT_LIST_HEAD(&devlink->resource_list);
-	INIT_LIST_HEAD(&devlink->param_list);
 	INIT_LIST_HEAD(&devlink->region_list);
 	INIT_LIST_HEAD(&devlink->reporter_list);
 	INIT_LIST_HEAD(&devlink->trap_list);
@@ -255,7 +255,6 @@ void devlink_free(struct devlink *devlink)
 	WARN_ON(!list_empty(&devlink->trap_list));
 	WARN_ON(!list_empty(&devlink->reporter_list));
 	WARN_ON(!list_empty(&devlink->region_list));
-	WARN_ON(!list_empty(&devlink->param_list));
 	WARN_ON(!list_empty(&devlink->resource_list));
 	WARN_ON(!list_empty(&devlink->dpipe_table_list));
 	WARN_ON(!list_empty(&devlink->sb_list));
@@ -264,6 +263,7 @@ void devlink_free(struct devlink *devlink)
 	WARN_ON(!xa_empty(&devlink->ports));
 
 	xa_destroy(&devlink->snapshot_ids);
+	xa_destroy(&devlink->params);
 	xa_destroy(&devlink->ports);
 
 	WARN_ON_ONCE(unregister_netdevice_notifier(&devlink->netdevice_nb));
diff --git a/net/devlink/devl_internal.h b/net/devlink/devl_internal.h
index 5c117e8d4377..2f4820e40d27 100644
--- a/net/devlink/devl_internal.h
+++ b/net/devlink/devl_internal.h
@@ -29,7 +29,7 @@ struct devlink {
 	struct list_head sb_list;
 	struct list_head dpipe_table_list;
 	struct list_head resource_list;
-	struct list_head param_list;
+	struct xarray params;
 	struct list_head region_list;
 	struct list_head reporter_list;
 	struct devlink_dpipe_headers *dpipe_headers;
diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
index c7d9ef832c8c..6d3988f4e843 100644
--- a/net/devlink/leftover.c
+++ b/net/devlink/leftover.c
@@ -3954,26 +3954,22 @@ static int devlink_param_driver_verify(const struct devlink_param *param)
 }
 
 static struct devlink_param_item *
-devlink_param_find_by_name(struct list_head *param_list,
-			   const char *param_name)
+devlink_param_find_by_name(struct xarray *params, const char *param_name)
 {
 	struct devlink_param_item *param_item;
+	unsigned long param_id;
 
-	list_for_each_entry(param_item, param_list, list)
+	xa_for_each(params, param_id, param_item) {
 		if (!strcmp(param_item->param->name, param_name))
 			return param_item;
+	}
 	return NULL;
 }
 
 static struct devlink_param_item *
-devlink_param_find_by_id(struct list_head *param_list, u32 param_id)
+devlink_param_find_by_id(struct xarray *params, u32 param_id)
 {
-	struct devlink_param_item *param_item;
-
-	list_for_each_entry(param_item, param_list, list)
-		if (param_item->param->id == param_id)
-			return param_item;
-	return NULL;
+	return xa_load(params, param_id);
 }
 
 static bool
@@ -4202,14 +4198,10 @@ devlink_nl_cmd_param_get_dump_one(struct sk_buff *msg, struct devlink *devlink,
 {
 	struct devlink_nl_dump_state *state = devlink_dump_state(cb);
 	struct devlink_param_item *param_item;
-	int idx = 0;
+	unsigned long param_id;
 	int err = 0;
 
-	list_for_each_entry(param_item, &devlink->param_list, list) {
-		if (idx < state->idx) {
-			idx++;
-			continue;
-		}
+	xa_for_each_start(&devlink->params, param_id, param_item, state->idx) {
 		err = devlink_nl_param_fill(msg, devlink, 0, param_item,
 					    DEVLINK_CMD_PARAM_GET,
 					    NETLINK_CB(cb->skb).portid,
@@ -4218,10 +4210,9 @@ devlink_nl_cmd_param_get_dump_one(struct sk_buff *msg, struct devlink *devlink,
 		if (err == -EOPNOTSUPP) {
 			err = 0;
 		} else if (err) {
-			state->idx = idx;
+			state->idx = param_id;
 			break;
 		}
-		idx++;
 	}
 
 	return err;
@@ -4307,8 +4298,7 @@ devlink_param_value_get_from_info(const struct devlink_param *param,
 }
 
 static struct devlink_param_item *
-devlink_param_get_from_info(struct list_head *param_list,
-			    struct genl_info *info)
+devlink_param_get_from_info(struct xarray *params, struct genl_info *info)
 {
 	char *param_name;
 
@@ -4316,7 +4306,7 @@ devlink_param_get_from_info(struct list_head *param_list,
 		return NULL;
 
 	param_name = nla_data(info->attrs[DEVLINK_ATTR_PARAM_NAME]);
-	return devlink_param_find_by_name(param_list, param_name);
+	return devlink_param_find_by_name(params, param_name);
 }
 
 static int devlink_nl_cmd_param_get_doit(struct sk_buff *skb,
@@ -4327,7 +4317,7 @@ static int devlink_nl_cmd_param_get_doit(struct sk_buff *skb,
 	struct sk_buff *msg;
 	int err;
 
-	param_item = devlink_param_get_from_info(&devlink->param_list, info);
+	param_item = devlink_param_get_from_info(&devlink->params, info);
 	if (!param_item)
 		return -EINVAL;
 
@@ -4348,7 +4338,7 @@ static int devlink_nl_cmd_param_get_doit(struct sk_buff *skb,
 
 static int __devlink_nl_cmd_param_set_doit(struct devlink *devlink,
 					   unsigned int port_index,
-					   struct list_head *param_list,
+					   struct xarray *params,
 					   struct genl_info *info,
 					   enum devlink_command cmd)
 {
@@ -4360,7 +4350,7 @@ static int __devlink_nl_cmd_param_set_doit(struct devlink *devlink,
 	union devlink_param_value value;
 	int err = 0;
 
-	param_item = devlink_param_get_from_info(param_list, info);
+	param_item = devlink_param_get_from_info(params, info);
 	if (!param_item)
 		return -EINVAL;
 	param = param_item->param;
@@ -4406,7 +4396,7 @@ static int devlink_nl_cmd_param_set_doit(struct sk_buff *skb,
 {
 	struct devlink *devlink = info->user_ptr[0];
 
-	return __devlink_nl_cmd_param_set_doit(devlink, 0, &devlink->param_list,
+	return __devlink_nl_cmd_param_set_doit(devlink, 0, &devlink->params,
 					       info, DEVLINK_CMD_PARAM_NEW);
 }
 
@@ -8038,6 +8028,7 @@ void devlink_notify_register(struct devlink *devlink)
 	struct devlink_rate *rate_node;
 	struct devlink_region *region;
 	unsigned long port_index;
+	unsigned long param_id;
 
 	devlink_notify(devlink, DEVLINK_CMD_NEW);
 	list_for_each_entry(linecard, &devlink->linecard_list, list)
@@ -8063,7 +8054,7 @@ void devlink_notify_register(struct devlink *devlink)
 	list_for_each_entry(region, &devlink->region_list, list)
 		devlink_nl_region_notify(region, NULL, DEVLINK_CMD_REGION_NEW);
 
-	list_for_each_entry(param_item, &devlink->param_list, list)
+	xa_for_each(&devlink->params, param_id, param_item)
 		devlink_param_notify(devlink, 0, param_item,
 				     DEVLINK_CMD_PARAM_NEW);
 }
@@ -8078,8 +8069,9 @@ void devlink_notify_unregister(struct devlink *devlink)
 	struct devlink_rate *rate_node;
 	struct devlink_region *region;
 	unsigned long port_index;
+	unsigned long param_id;
 
-	list_for_each_entry_reverse(param_item, &devlink->param_list, list)
+	xa_for_each(&devlink->params, param_id, param_item)
 		devlink_param_notify(devlink, 0, param_item,
 				     DEVLINK_CMD_PARAM_DEL);
 
@@ -9506,9 +9498,10 @@ static int devlink_param_register(struct devlink *devlink,
 				  const struct devlink_param *param)
 {
 	struct devlink_param_item *param_item;
+	int err;
 
 	WARN_ON(devlink_param_verify(param));
-	WARN_ON(devlink_param_find_by_name(&devlink->param_list, param->name));
+	WARN_ON(devlink_param_find_by_name(&devlink->params, param->name));
 
 	if (param->supported_cmodes == BIT(DEVLINK_PARAM_CMODE_DRIVERINIT))
 		WARN_ON(param->get || param->set);
@@ -9521,9 +9514,16 @@ static int devlink_param_register(struct devlink *devlink,
 
 	param_item->param = param;
 
-	list_add_tail(&param_item->list, &devlink->param_list);
+	err = xa_insert(&devlink->params, param->id, param_item, GFP_KERNEL);
+	if (err)
+		goto err_xa_insert;
+
 	devlink_param_notify(devlink, 0, param_item, DEVLINK_CMD_PARAM_NEW);
 	return 0;
+
+err_xa_insert:
+	kfree(param_item);
+	return err;
 }
 
 static void devlink_param_unregister(struct devlink *devlink,
@@ -9531,12 +9531,11 @@ static void devlink_param_unregister(struct devlink *devlink,
 {
 	struct devlink_param_item *param_item;
 
-	param_item =
-		devlink_param_find_by_name(&devlink->param_list, param->name);
+	param_item = devlink_param_find_by_id(&devlink->params, param->id);
 	if (WARN_ON(!param_item))
 		return;
 	devlink_param_notify(devlink, 0, param_item, DEVLINK_CMD_PARAM_DEL);
-	list_del(&param_item->list);
+	xa_erase(&devlink->params, param->id);
 	kfree(param_item);
 }
 
@@ -9640,7 +9639,7 @@ int devl_param_driverinit_value_get(struct devlink *devlink, u32 param_id,
 	if (WARN_ON(!devlink_reload_supported(devlink->ops)))
 		return -EOPNOTSUPP;
 
-	param_item = devlink_param_find_by_id(&devlink->param_list, param_id);
+	param_item = devlink_param_find_by_id(&devlink->params, param_id);
 	if (!param_item)
 		return -EINVAL;
 
@@ -9674,7 +9673,7 @@ void devl_param_driverinit_value_set(struct devlink *devlink, u32 param_id,
 {
 	struct devlink_param_item *param_item;
 
-	param_item = devlink_param_find_by_id(&devlink->param_list, param_id);
+	param_item = devlink_param_find_by_id(&devlink->params, param_id);
 	if (WARN_ON(!param_item))
 		return;
 
@@ -9692,8 +9691,9 @@ EXPORT_SYMBOL_GPL(devl_param_driverinit_value_set);
 void devlink_params_driverinit_load_new(struct devlink *devlink)
 {
 	struct devlink_param_item *param_item;
+	unsigned long param_id;
 
-	list_for_each_entry(param_item, &devlink->param_list, list) {
+	xa_for_each(&devlink->params, param_id, param_item) {
 		if (!devlink_param_cmode_is_supported(param_item->param,
 						      DEVLINK_PARAM_CMODE_DRIVERINIT) ||
 		    !param_item->driverinit_value_new_valid)
@@ -9720,7 +9720,7 @@ void devl_param_value_changed(struct devlink *devlink, u32 param_id)
 {
 	struct devlink_param_item *param_item;
 
-	param_item = devlink_param_find_by_id(&devlink->param_list, param_id);
+	param_item = devlink_param_find_by_id(&devlink->params, param_id);
 	WARN_ON(!param_item);
 
 	devlink_param_notify(devlink, 0, param_item, DEVLINK_CMD_PARAM_NEW);
-- 
2.39.0

