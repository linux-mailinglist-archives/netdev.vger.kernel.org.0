Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1B64690D65
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 16:44:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231536AbjBIPoN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 10:44:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231512AbjBIPny (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 10:43:54 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10A6E65661
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 07:43:31 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id rp23so7557458ejb.7
        for <netdev@vger.kernel.org>; Thu, 09 Feb 2023 07:43:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I02J60Y4R+ohFSpmLQ7WdxxzP6KuaX6SRH/Y+gZeSYc=;
        b=cMmmJmqLCOzAF3n5n5xR7wSi8GSbs3kS4clZlhdSXNEdWzDPbvpLJzUI9Q2raIMUk8
         glzZCW79TvcM8AGCVeNbmCAOh/aeMMemRnFqz2QKi/3n8LALm+kAqvwfiaT7mYOs+tyv
         pD7p1ymoT6Z9upxtqXqHEWngWrVVfAWvpgsU+WjVqZZhuiW9KHnb/KR7H61yVBV4eY6u
         WSbHYvYjN38VQI6lVxFfttbe590wbBribDEpGMg9V0K2bwezXUBvew7rdoxB2Ja6lbOh
         6n8tgXq1oF8MjnNYFe1m6GAXnzcp9AfeucLf40acfs0Tl3fQs5RmRmHHlm+hFdm8fUVQ
         SuTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=I02J60Y4R+ohFSpmLQ7WdxxzP6KuaX6SRH/Y+gZeSYc=;
        b=wUMiKSi+mewD6E77V47WSIMeEaP+CecNFvkNqVS5IeYrOMvPZjNfiqcao+YH58Tui5
         k677WrHI+lFK8hQigQr64vuPxDb+AQvtaMv8uSdxDiBFGwAJ6VNUSxi1ntjBfiSmmIhi
         C7OJ70twybfGP2cihz3xIV05LRQcc1nabwVZBj4hVFYz9/OkD3R49aTaWmE0j50WxSEH
         FNnf8nb8f4kzaQArzpigS3JaI8l37uWUslb/CHS3iOTMvK+HI6ZmNLkB+xKITkpecydU
         0D+QEwWWsxIKhyCbG+75UPCzEHFeV5UobLwiTj8Q0GPLcKNc+qpUFOichEwDToRic13K
         f6iw==
X-Gm-Message-State: AO0yUKWaRAQKeKyzzPJRneqzG7Q0Q0j3jEYDqc+FIAoFyPj9JmAWSTgf
        MlSpZNCQVKYTZCLJCZYLZb86kLWTMz6e0CC+B1o=
X-Google-Smtp-Source: AK7set8ftczx8GqRUnkL01cnAKwaUGpq25BuVARC0atnPYfoKA3h/7/VHOwoHHAnMKhH8UNBBa97oA==
X-Received: by 2002:a17:906:6557:b0:885:d02f:d4ad with SMTP id u23-20020a170906655700b00885d02fd4admr13023631ejn.43.1675957395748;
        Thu, 09 Feb 2023 07:43:15 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id p5-20020a170906b20500b0087276f66c6asm1021748ejz.115.2023.02.09.07.43.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Feb 2023 07:43:14 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, tariqt@nvidia.com, saeedm@nvidia.com,
        jacob.e.keller@intel.com, gal@nvidia.com, kim.phillips@amd.com,
        moshe@nvidia.com
Subject: [patch net-next 2/7] devlink: make sure driver does not read updated driverinit param before reload
Date:   Thu,  9 Feb 2023 16:43:03 +0100
Message-Id: <20230209154308.2984602-3-jiri@resnulli.us>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230209154308.2984602-1-jiri@resnulli.us>
References: <20230209154308.2984602-1-jiri@resnulli.us>
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

The driverinit param purpose is to serve the driver during init/reload
time to provide a value, either default or set by user.

Make sure that driver does not read value updated by user before the
reload is performed. Hold the new value in a separate struct and switch
it during reload.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 include/net/devlink.h       |  4 ++++
 net/devlink/dev.c           |  2 ++
 net/devlink/devl_internal.h |  3 +++
 net/devlink/leftover.c      | 26 ++++++++++++++++++++++----
 4 files changed, 31 insertions(+), 4 deletions(-)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index 2e85a5970a32..8ed960345f37 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -489,6 +489,10 @@ struct devlink_param_item {
 	const struct devlink_param *param;
 	union devlink_param_value driverinit_value;
 	bool driverinit_value_valid;
+	union devlink_param_value driverinit_value_new; /* Not reachable
+							 * until reload.
+							 */
+	bool driverinit_value_new_valid;
 };
 
 enum devlink_param_generic_id {
diff --git a/net/devlink/dev.c b/net/devlink/dev.c
index 78d824eda5ec..32e5d1b28a47 100644
--- a/net/devlink/dev.c
+++ b/net/devlink/dev.c
@@ -369,6 +369,8 @@ int devlink_reload(struct devlink *devlink, struct net *dest_net,
 	if (dest_net && !net_eq(dest_net, curr_net))
 		devlink_reload_netns_change(devlink, curr_net, dest_net);
 
+	devlink_params_driverinit_load_new(devlink);
+
 	err = devlink->ops->reload_up(devlink, action, limit, actions_performed, extack);
 	devlink_reload_failed_set(devlink, !!err);
 	if (err)
diff --git a/net/devlink/devl_internal.h b/net/devlink/devl_internal.h
index 941174e157d4..5c117e8d4377 100644
--- a/net/devlink/devl_internal.h
+++ b/net/devlink/devl_internal.h
@@ -189,6 +189,9 @@ static inline bool devlink_reload_supported(const struct devlink_ops *ops)
 	return ops->reload_down && ops->reload_up;
 }
 
+/* Params */
+void devlink_params_driverinit_load_new(struct devlink *devlink);
+
 /* Resources */
 struct devlink_resource;
 int devlink_resources_validate(struct devlink *devlink,
diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
index 6225651e34b9..6c4c95c658c7 100644
--- a/net/devlink/leftover.c
+++ b/net/devlink/leftover.c
@@ -4098,9 +4098,12 @@ static int devlink_nl_param_fill(struct sk_buff *msg, struct devlink *devlink,
 		if (!devlink_param_cmode_is_supported(param, i))
 			continue;
 		if (i == DEVLINK_PARAM_CMODE_DRIVERINIT) {
-			if (!param_item->driverinit_value_valid)
+			if (param_item->driverinit_value_new_valid)
+				param_value[i] = param_item->driverinit_value_new;
+			else if (param_item->driverinit_value_valid)
+				param_value[i] = param_item->driverinit_value;
+			else
 				return -EOPNOTSUPP;
-			param_value[i] = param_item->driverinit_value;
 		} else {
 			ctx.cmode = i;
 			err = devlink_param_get(devlink, param, &ctx);
@@ -4388,8 +4391,8 @@ static int __devlink_nl_cmd_param_set_doit(struct devlink *devlink,
 		return -EOPNOTSUPP;
 
 	if (cmode == DEVLINK_PARAM_CMODE_DRIVERINIT) {
-		param_item->driverinit_value = value;
-		param_item->driverinit_value_valid = true;
+		param_item->driverinit_value_new = value;
+		param_item->driverinit_value_new_valid = true;
 	} else {
 		if (!param->set)
 			return -EOPNOTSUPP;
@@ -9687,6 +9690,21 @@ void devl_param_driverinit_value_set(struct devlink *devlink, u32 param_id,
 }
 EXPORT_SYMBOL_GPL(devl_param_driverinit_value_set);
 
+void devlink_params_driverinit_load_new(struct devlink *devlink)
+{
+	struct devlink_param_item *param_item;
+
+	list_for_each_entry(param_item, &devlink->param_list, list) {
+		if (!devlink_param_cmode_is_supported(param_item->param,
+						      DEVLINK_PARAM_CMODE_DRIVERINIT) ||
+		    !param_item->driverinit_value_new_valid)
+			continue;
+		param_item->driverinit_value = param_item->driverinit_value_new;
+		param_item->driverinit_value_valid = true;
+		param_item->driverinit_value_new_valid = false;
+	}
+}
+
 /**
  *	devl_param_value_changed - notify devlink on a parameter's value
  *				   change. Should be called by the driver
-- 
2.39.0

