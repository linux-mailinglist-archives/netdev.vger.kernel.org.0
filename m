Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFF3959F9B4
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 14:20:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237247AbiHXMUY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 08:20:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237265AbiHXMUU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 08:20:20 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6A4420192
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 05:20:18 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id z2so21816642edc.1
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 05:20:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=pgAeCgBhf5FJxHVnUiKHAxpN4juqeLh6EFvDB0D0zkQ=;
        b=w9lTw14pXJw3XdnDhjQr/xY06UhqDLug8upRpgyE588Svwgnv4Q7nhi1W7Xtv9dSxa
         EVwUW6sLXUyOAfNcsFDdbFrR6lzzyzHUgdeF0t0GY/2hmmcII9emDcVuBnfQuOMiIA23
         r4mK+cXMana7t6B4dOrQFhNpn2izfAkbFjHVR+bJ4vnFT2+I54okhr+7OLuHbcEFVxx7
         iAg2aTrcoYLAO3V+2DReDnrhf7uQKz1eSe3+fJv1ktOf8cPeIAeFNezwiJsxyKXKW8lx
         gbnZ6fDLd+pDnn9AwtqcCIfXSF2pGhHJhlnuV64L8lFkB1aE1YA5VxM0G3DW0+dWhCJ5
         SPhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=pgAeCgBhf5FJxHVnUiKHAxpN4juqeLh6EFvDB0D0zkQ=;
        b=AkDztFNf2oQPcJo/YjR6vjP/SzuHUKVOh7eS+1do+QMMubE0d8sJ8051YlmG2V4yA6
         b7aKjHXFSUWvQrLVLPYwrXWRkLkrSOPlA6qrkxmgENtnj6YAlAarDjfqWw8VhCjSVT4b
         gW8fj2QIMObNJPGXU4JRZWV/RgWK3xxkE2kubkEdKV/Bow72fzl8THNa5PM7z+hNpbhh
         kqY6ez67M2cyc6N2msTjDRIAmS7rmMcIawgwnduDJIsiJiNaL4fWm8hx92nLp3qBTmhK
         8eoopbwjWKb7E5uZB6bYNDK5N+cwD8kyhCYawlwYNGI3WcaF6Ie4DiOYr3Jfy821AFx/
         2kew==
X-Gm-Message-State: ACgBeo0K//kqsXWjmgIvo1+531sgGNHEF6YxP0jtcBU6d2z2tKwodEtZ
        s4JEKhhD+RerD0WRL5rplYbm1jpv9ASooxPo
X-Google-Smtp-Source: AA6agR47n3tfqeUx2LroyS6vdP9O+M0nlR7xx4zDRuJj7fF9JfIgD0UqZNx0owN9NDqDPvw9K/1LBg==
X-Received: by 2002:a05:6402:2b8d:b0:43a:5410:a9fc with SMTP id fj13-20020a0564022b8d00b0043a5410a9fcmr7513070edb.99.1661343617260;
        Wed, 24 Aug 2022 05:20:17 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id g18-20020a50d5d2000000b0044602e3dcd7sm2995702edj.95.2022.08.24.05.20.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Aug 2022 05:20:16 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@nvidia.com,
        pabeni@redhat.com, edumazet@google.com, saeedm@nvidia.com,
        jacob.e.keller@intel.com, vikas.gupta@broadcom.com,
        gospo@broadcom.com
Subject: [patch net-next v3 3/3] net: devlink: limit flash component name to match version returned by info_get()
Date:   Wed, 24 Aug 2022 14:20:11 +0200
Message-Id: <20220824122011.1204330-4-jiri@resnulli.us>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220824122011.1204330-1-jiri@resnulli.us>
References: <20220824122011.1204330-1-jiri@resnulli.us>
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

Limit the acceptance of component name passed to cmd_flash_update() to
match one of the versions returned by info_get(), marked by version type.
This makes things clearer and enforces 1:1 mapping between exposed
version and accepted flash component.

Check VERSION_TYPE_COMPONENT version type during cmd_flash_update()
execution by calling info_get() with different "req" context.
That causes info_get() to lookup the component name instead of
filling-up the netlink message.

Remove "UPDATE_COMPONENT" flag which becomes used.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
v1->v2:
- split from v1 patch "net: devlink: extend info_get() version put to
  indicate a flash component", no code changes
---
 drivers/net/netdevsim/dev.c |   3 +-
 include/net/devlink.h       |   3 +-
 net/core/devlink.c          | 105 ++++++++++++++++++++++++++++++------
 3 files changed, 90 insertions(+), 21 deletions(-)

diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index d6938faf6c8b..efea94c27880 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -1322,8 +1322,7 @@ nsim_dev_devlink_trap_drop_counter_get(struct devlink *devlink,
 static const struct devlink_ops nsim_dev_devlink_ops = {
 	.eswitch_mode_set = nsim_devlink_eswitch_mode_set,
 	.eswitch_mode_get = nsim_devlink_eswitch_mode_get,
-	.supported_flash_update_params = DEVLINK_SUPPORT_FLASH_UPDATE_COMPONENT |
-					 DEVLINK_SUPPORT_FLASH_UPDATE_OVERWRITE_MASK,
+	.supported_flash_update_params = DEVLINK_SUPPORT_FLASH_UPDATE_OVERWRITE_MASK,
 	.reload_actions = BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT),
 	.reload_down = nsim_dev_reload_down,
 	.reload_up = nsim_dev_reload_up,
diff --git a/include/net/devlink.h b/include/net/devlink.h
index f50a002e5023..1f7026011856 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -624,8 +624,7 @@ struct devlink_flash_update_params {
 	u32 overwrite_mask;
 };
 
-#define DEVLINK_SUPPORT_FLASH_UPDATE_COMPONENT		BIT(0)
-#define DEVLINK_SUPPORT_FLASH_UPDATE_OVERWRITE_MASK	BIT(1)
+#define DEVLINK_SUPPORT_FLASH_UPDATE_OVERWRITE_MASK	BIT(0)
 
 struct devlink_region;
 struct devlink_info_req;
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 43c75b5ac039..0f7078db1280 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -4742,10 +4742,76 @@ void devlink_flash_update_timeout_notify(struct devlink *devlink,
 }
 EXPORT_SYMBOL_GPL(devlink_flash_update_timeout_notify);
 
+struct devlink_info_req {
+	struct sk_buff *msg;
+	void (*version_cb)(const char *version_name,
+			   enum devlink_info_version_type version_type,
+			   void *version_cb_priv);
+	void *version_cb_priv;
+};
+
+struct devlink_flash_component_lookup_ctx {
+	const char *lookup_name;
+	bool lookup_name_found;
+};
+
+static void
+devlink_flash_component_lookup_cb(const char *version_name,
+				  enum devlink_info_version_type version_type,
+				  void *version_cb_priv)
+{
+	struct devlink_flash_component_lookup_ctx *lookup_ctx = version_cb_priv;
+
+	if (version_type != DEVLINK_INFO_VERSION_TYPE_COMPONENT ||
+	    lookup_ctx->lookup_name_found)
+		return;
+
+	lookup_ctx->lookup_name_found =
+		!strcmp(lookup_ctx->lookup_name, version_name);
+}
+
+static int devlink_flash_component_get(struct devlink *devlink,
+				       struct nlattr *nla_component,
+				       const char **p_component,
+				       struct netlink_ext_ack *extack)
+{
+	struct devlink_flash_component_lookup_ctx lookup_ctx = {};
+	struct devlink_info_req req = {};
+	const char *component;
+	int ret;
+
+	if (!nla_component)
+		return 0;
+
+	component = nla_data(nla_component);
+
+	if (!devlink->ops->info_get) {
+		NL_SET_ERR_MSG_ATTR(extack, nla_component,
+				    "component update is not supported by this device");
+		return -EOPNOTSUPP;
+	}
+
+	lookup_ctx.lookup_name = component;
+	req.version_cb = devlink_flash_component_lookup_cb;
+	req.version_cb_priv = &lookup_ctx;
+
+	ret = devlink->ops->info_get(devlink, &req, NULL);
+	if (ret)
+		return ret;
+
+	if (!lookup_ctx.lookup_name_found) {
+		NL_SET_ERR_MSG_ATTR(extack, nla_component,
+				    "selected component is not supported by this device");
+		return -EINVAL;
+	}
+	*p_component = component;
+	return 0;
+}
+
 static int devlink_nl_cmd_flash_update(struct sk_buff *skb,
 				       struct genl_info *info)
 {
-	struct nlattr *nla_component, *nla_overwrite_mask, *nla_file_name;
+	struct nlattr *nla_overwrite_mask, *nla_file_name;
 	struct devlink_flash_update_params params = {};
 	struct devlink *devlink = info->user_ptr[0];
 	const char *file_name;
@@ -4758,17 +4824,13 @@ static int devlink_nl_cmd_flash_update(struct sk_buff *skb,
 	if (!info->attrs[DEVLINK_ATTR_FLASH_UPDATE_FILE_NAME])
 		return -EINVAL;
 
-	supported_params = devlink->ops->supported_flash_update_params;
+	ret = devlink_flash_component_get(devlink,
+					  info->attrs[DEVLINK_ATTR_FLASH_UPDATE_COMPONENT],
+					  &params.component, info->extack);
+	if (ret)
+		return ret;
 
-	nla_component = info->attrs[DEVLINK_ATTR_FLASH_UPDATE_COMPONENT];
-	if (nla_component) {
-		if (!(supported_params & DEVLINK_SUPPORT_FLASH_UPDATE_COMPONENT)) {
-			NL_SET_ERR_MSG_ATTR(info->extack, nla_component,
-					    "component update is not supported by this device");
-			return -EOPNOTSUPP;
-		}
-		params.component = nla_data(nla_component);
-	}
+	supported_params = devlink->ops->supported_flash_update_params;
 
 	nla_overwrite_mask = info->attrs[DEVLINK_ATTR_FLASH_UPDATE_OVERWRITE_MASK];
 	if (nla_overwrite_mask) {
@@ -6553,18 +6615,18 @@ static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
 	return err;
 }
 
-struct devlink_info_req {
-	struct sk_buff *msg;
-};
-
 int devlink_info_driver_name_put(struct devlink_info_req *req, const char *name)
 {
+	if (!req->msg)
+		return 0;
 	return nla_put_string(req->msg, DEVLINK_ATTR_INFO_DRIVER_NAME, name);
 }
 EXPORT_SYMBOL_GPL(devlink_info_driver_name_put);
 
 int devlink_info_serial_number_put(struct devlink_info_req *req, const char *sn)
 {
+	if (!req->msg)
+		return 0;
 	return nla_put_string(req->msg, DEVLINK_ATTR_INFO_SERIAL_NUMBER, sn);
 }
 EXPORT_SYMBOL_GPL(devlink_info_serial_number_put);
@@ -6572,6 +6634,8 @@ EXPORT_SYMBOL_GPL(devlink_info_serial_number_put);
 int devlink_info_board_serial_number_put(struct devlink_info_req *req,
 					 const char *bsn)
 {
+	if (!req->msg)
+		return 0;
 	return nla_put_string(req->msg, DEVLINK_ATTR_INFO_BOARD_SERIAL_NUMBER,
 			      bsn);
 }
@@ -6585,6 +6649,13 @@ static int devlink_info_version_put(struct devlink_info_req *req, int attr,
 	struct nlattr *nest;
 	int err;
 
+	if (req->version_cb)
+		req->version_cb(version_name, version_type,
+				req->version_cb_priv);
+
+	if (!req->msg)
+		return 0;
+
 	nest = nla_nest_start_noflag(req->msg, attr);
 	if (!nest)
 		return -EMSGSIZE;
@@ -6665,7 +6736,7 @@ devlink_nl_info_fill(struct sk_buff *msg, struct devlink *devlink,
 		     enum devlink_command cmd, u32 portid,
 		     u32 seq, int flags, struct netlink_ext_ack *extack)
 {
-	struct devlink_info_req req;
+	struct devlink_info_req req = {};
 	void *hdr;
 	int err;
 
@@ -12332,8 +12403,8 @@ EXPORT_SYMBOL_GPL(devl_trap_policers_unregister);
 static void __devlink_compat_running_version(struct devlink *devlink,
 					     char *buf, size_t len)
 {
+	struct devlink_info_req req = {};
 	const struct nlattr *nlattr;
-	struct devlink_info_req req;
 	struct sk_buff *msg;
 	int rem, err;
 
-- 
2.37.1

