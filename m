Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15E22598399
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 15:04:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244856AbiHRNAx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 09:00:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244858AbiHRNAs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 09:00:48 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4FAE61DA7
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 06:00:46 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id o22so1769033edc.10
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 06:00:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=JuNykuC5qgbCOArm6ZMuGXDf4Qj1U786SQLmL0SdI8I=;
        b=PhaMQA8y/zl6lpzsAmwhvQNGTgMgNJ4WTzmB7PYx7VR/O24Rq2pJsSXJE1zVKz4DTO
         MiFWBbicpW5g4XlF9YrjZl+31qLdb7L/m3aOxwv0dOTeTmCelK73Pke3rXNFDispbk14
         7Jle/BAdL+Mv4Jpg+zJ+0unM8izbAhxX0y9pcq4AZPPhz92GfTmTB7loJSapD/kxpRaC
         8sH3aFz9jxREujXj8T4/qsv9PtUS3o4K7NjIO8XknkzuHrGzyYRHsokCVi0BLqZM8Nqb
         ebPRkFrVadoEqdQ6DWf+6J4lxKcD0VmpyRsb6qYgNFCF9SGLGHY7/O1HYlWrzgk8ZxOc
         Vg8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=JuNykuC5qgbCOArm6ZMuGXDf4Qj1U786SQLmL0SdI8I=;
        b=YDGmxEMEnNImXSfxpcTaMgIu83+ucpzuHdnFiEmh0GClsOvWtBW48/9O+AnORQfvmC
         uUeoJ+bc+bAu/8OOOae37stMEgD2rcw3ln0u/BTiUII2DEP89074CQv75BwVtL3DySbV
         0K7ptrkhD7iIfxyBmlcG9YNXgGpLWD4OxofyNnMi2x5fIqfBc5YawfsT2vXiaQD1vf5H
         +QQR9wxEFY6pdCbJrRsGO3uUb26ISWXKunP90nGSMNeRDD69OgoozOjEHfNz/ZZbevqs
         d5CoB8kRQpn+u4d+1bRKCo+VWMfdL89TWlNsKVenLBJKIVwcSG8ZeK3fS2ARub/D74WA
         MZBQ==
X-Gm-Message-State: ACgBeo0BBu6C8oQejwXPfohaxq3gR8zkJBAkahiXC5EiuhIvAxLHpsoE
        IX2/smWf5ucepHOVc0K82EmPZK6h49qBTsHz
X-Google-Smtp-Source: AA6agR6Uyc6GcUn1S/w9tFuVIhDWkmEyz6qtCnqGXXgfi/RNCob4UOGQHmWSYpikPiv4ir8MHKrnWQ==
X-Received: by 2002:a05:6402:94f:b0:445:e951:be6e with SMTP id h15-20020a056402094f00b00445e951be6emr2109043edz.112.1660827645060;
        Thu, 18 Aug 2022 06:00:45 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id h10-20020aa7c60a000000b0043cc2c9f5adsm1128265edq.40.2022.08.18.06.00.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 06:00:44 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@nvidia.com,
        pabeni@redhat.com, edumazet@google.com, saeedm@nvidia.com,
        jacob.e.keller@intel.com, vikas.gupta@broadcom.com,
        gospo@broadcom.com
Subject: [patch net-next 1/4] net: devlink: extend info_get() version put to indicate a flash component
Date:   Thu, 18 Aug 2022 15:00:39 +0200
Message-Id: <20220818130042.535762-2-jiri@resnulli.us>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220818130042.535762-1-jiri@resnulli.us>
References: <20220818130042.535762-1-jiri@resnulli.us>
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

Whenever the driver is called by his info_get() op, it may put multiple
version names and values to the netlink message. Extend by additional
helper devlink_info_version_running_put_ext() that allows to specify a
version type that indicates when particular version name represents
a flash component.

Use this indication during cmd_flash_update() execution by calling
info_get() with different "req" context. That causes info_get() to
lookup the component name instead of filling-up the netlink message.

Fix the only component user which is netdevsim. It uses component named
"fw.mgmt" in selftests.

Remove now outdated "UPDATE_COMPONENT" flag.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 drivers/net/netdevsim/dev.c |  12 +++-
 include/net/devlink.h       |  15 ++++-
 net/core/devlink.c          | 128 ++++++++++++++++++++++++++++++------
 3 files changed, 129 insertions(+), 26 deletions(-)

diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index e88f783c297e..cea130490dea 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -984,7 +984,14 @@ static int nsim_dev_info_get(struct devlink *devlink,
 			     struct devlink_info_req *req,
 			     struct netlink_ext_ack *extack)
 {
-	return devlink_info_driver_name_put(req, DRV_NAME);
+	int err;
+
+	err = devlink_info_driver_name_put(req, DRV_NAME);
+	if (err)
+		return err;
+
+	return devlink_info_version_running_put_ext(req, "fw.mgmt", "10.20.30",
+						    DEVLINK_INFO_VERSION_TYPE_COMPONENT);
 }
 
 #define NSIM_DEV_FLASH_SIZE 500000
@@ -1312,8 +1319,7 @@ nsim_dev_devlink_trap_drop_counter_get(struct devlink *devlink,
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
index 119ed1ffb988..9bf4f03feca6 100644
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
@@ -1714,6 +1713,14 @@ int devlink_info_driver_name_put(struct devlink_info_req *req,
 				 const char *name);
 int devlink_info_board_serial_number_put(struct devlink_info_req *req,
 					 const char *bsn);
+
+enum devlink_info_version_type {
+	DEVLINK_INFO_VERSION_TYPE_NONE,
+	DEVLINK_INFO_VERSION_TYPE_COMPONENT, /* May be used as flash update
+					      * component by name.
+					      */
+};
+
 int devlink_info_version_fixed_put(struct devlink_info_req *req,
 				   const char *version_name,
 				   const char *version_value);
@@ -1723,6 +1730,10 @@ int devlink_info_version_stored_put(struct devlink_info_req *req,
 int devlink_info_version_running_put(struct devlink_info_req *req,
 				     const char *version_name,
 				     const char *version_value);
+int devlink_info_version_running_put_ext(struct devlink_info_req *req,
+					 const char *version_name,
+					 const char *version_value,
+					 enum devlink_info_version_type version_type);
 
 int devlink_fmsg_obj_nest_start(struct devlink_fmsg *fmsg);
 int devlink_fmsg_obj_nest_end(struct devlink_fmsg *fmsg);
diff --git a/net/core/devlink.c b/net/core/devlink.c
index b50bcc18b8d9..17b78123ad9d 100644
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
@@ -6579,11 +6643,19 @@ EXPORT_SYMBOL_GPL(devlink_info_board_serial_number_put);
 
 static int devlink_info_version_put(struct devlink_info_req *req, int attr,
 				    const char *version_name,
-				    const char *version_value)
+				    const char *version_value,
+				    enum devlink_info_version_type version_type)
 {
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
@@ -6612,7 +6684,8 @@ int devlink_info_version_fixed_put(struct devlink_info_req *req,
 				   const char *version_value)
 {
 	return devlink_info_version_put(req, DEVLINK_ATTR_INFO_VERSION_FIXED,
-					version_name, version_value);
+					version_name, version_value,
+					DEVLINK_INFO_VERSION_TYPE_NONE);
 }
 EXPORT_SYMBOL_GPL(devlink_info_version_fixed_put);
 
@@ -6621,7 +6694,8 @@ int devlink_info_version_stored_put(struct devlink_info_req *req,
 				    const char *version_value)
 {
 	return devlink_info_version_put(req, DEVLINK_ATTR_INFO_VERSION_STORED,
-					version_name, version_value);
+					version_name, version_value,
+					DEVLINK_INFO_VERSION_TYPE_NONE);
 }
 EXPORT_SYMBOL_GPL(devlink_info_version_stored_put);
 
@@ -6630,16 +6704,28 @@ int devlink_info_version_running_put(struct devlink_info_req *req,
 				     const char *version_value)
 {
 	return devlink_info_version_put(req, DEVLINK_ATTR_INFO_VERSION_RUNNING,
-					version_name, version_value);
+					version_name, version_value,
+					DEVLINK_INFO_VERSION_TYPE_NONE);
 }
 EXPORT_SYMBOL_GPL(devlink_info_version_running_put);
 
+int devlink_info_version_running_put_ext(struct devlink_info_req *req,
+					 const char *version_name,
+					 const char *version_value,
+					 enum devlink_info_version_type version_type)
+{
+	return devlink_info_version_put(req, DEVLINK_ATTR_INFO_VERSION_RUNNING,
+					version_name, version_value,
+					version_type);
+}
+EXPORT_SYMBOL_GPL(devlink_info_version_running_put_ext);
+
 static int
 devlink_nl_info_fill(struct sk_buff *msg, struct devlink *devlink,
 		     enum devlink_command cmd, u32 portid,
 		     u32 seq, int flags, struct netlink_ext_ack *extack)
 {
-	struct devlink_info_req req;
+	struct devlink_info_req req = {};
 	void *hdr;
 	int err;
 
@@ -12306,8 +12392,8 @@ EXPORT_SYMBOL_GPL(devl_trap_policers_unregister);
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

