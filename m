Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82E8343E1F5
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 15:24:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230331AbhJ1NZx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 09:25:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:36042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230195AbhJ1NZx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Oct 2021 09:25:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6F8B860F92;
        Thu, 28 Oct 2021 13:23:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635427406;
        bh=MHd0VsFoJKZpEh0+cqexMABqtGf+jebYqYU99Q+jS/A=;
        h=From:To:Cc:Subject:Date:From;
        b=YylB4snR9WIoK41yPkY1g21AwWIc7X+sqocVoRkPCZRL5I9+Fn4L4zKKcQOleVNvm
         LvIv8NPzDMVcVZxWM8pY8jHtUkpxpPKEilrPqQfRnU5oJl1RJGai61w2S+MJmz5qT+
         bcJUEWFUb7XHUheHMOHv/XbrdrXDKv1LW3q+jA2Z8QybzfaonDp4tmEnxUYtO87sqj
         Y02ETedmW/16xz2bD8VqMFRg3CBmYYjLyNUD9xwnnBsM3Ql5K+20xW6Wd+ogbOA6gL
         9/7LpL8gKK7u/1Q/NdXS6P96G8/UIEvm2UdZvm8ji7KVRQjxkf0BHqRVfVu12Jqnnt
         QUb7U4WhFMaHA==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next] devlink: Simplify internal devlink params implementation
Date:   Thu, 28 Oct 2021 16:23:21 +0300
Message-Id: <efec83a9e9479018c324f12c1a99b2a9e3ee29f7.1635427378.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Reduce extra indirection from devlink_params_*() API. Such change
makes it clear that we can drop devlink->lock from these flows, because
everything is executed when the devlink is not registered yet.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 net/core/devlink.c | 169 ++++++++++++---------------------------------
 1 file changed, 46 insertions(+), 123 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 0de679c4313c..ff2bc6a8f95e 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -4925,45 +4925,6 @@ static int devlink_nl_cmd_param_set_doit(struct sk_buff *skb,
 					       info, DEVLINK_CMD_PARAM_NEW);
 }
 
-static int devlink_param_register_one(struct devlink *devlink,
-				      unsigned int port_index,
-				      struct list_head *param_list,
-				      const struct devlink_param *param,
-				      enum devlink_command cmd)
-{
-	struct devlink_param_item *param_item;
-
-	if (devlink_param_find_by_name(param_list, param->name))
-		return -EEXIST;
-
-	if (param->supported_cmodes == BIT(DEVLINK_PARAM_CMODE_DRIVERINIT))
-		WARN_ON(param->get || param->set);
-	else
-		WARN_ON(!param->get || !param->set);
-
-	param_item = kzalloc(sizeof(*param_item), GFP_KERNEL);
-	if (!param_item)
-		return -ENOMEM;
-	param_item->param = param;
-
-	list_add_tail(&param_item->list, param_list);
-	return 0;
-}
-
-static void devlink_param_unregister_one(struct devlink *devlink,
-					 unsigned int port_index,
-					 struct list_head *param_list,
-					 const struct devlink_param *param,
-					 enum devlink_command cmd)
-{
-	struct devlink_param_item *param_item;
-
-	param_item = devlink_param_find_by_name(param_list, param->name);
-	WARN_ON(!param_item);
-	list_del(&param_item->list);
-	kfree(param_item);
-}
-
 static int devlink_nl_cmd_port_param_get_dumpit(struct sk_buff *msg,
 						struct netlink_callback *cb)
 {
@@ -10092,73 +10053,6 @@ static int devlink_param_verify(const struct devlink_param *param)
 		return devlink_param_driver_verify(param);
 }
 
-static int __devlink_param_register_one(struct devlink *devlink,
-					unsigned int port_index,
-					struct list_head *param_list,
-					const struct devlink_param *param,
-					enum devlink_command reg_cmd)
-{
-	int err;
-
-	err = devlink_param_verify(param);
-	if (err)
-		return err;
-
-	return devlink_param_register_one(devlink, port_index,
-					  param_list, param, reg_cmd);
-}
-
-static int __devlink_params_register(struct devlink *devlink,
-				     unsigned int port_index,
-				     struct list_head *param_list,
-				     const struct devlink_param *params,
-				     size_t params_count,
-				     enum devlink_command reg_cmd,
-				     enum devlink_command unreg_cmd)
-{
-	const struct devlink_param *param = params;
-	int i;
-	int err;
-
-	mutex_lock(&devlink->lock);
-	for (i = 0; i < params_count; i++, param++) {
-		err = __devlink_param_register_one(devlink, port_index,
-						   param_list, param, reg_cmd);
-		if (err)
-			goto rollback;
-	}
-
-	mutex_unlock(&devlink->lock);
-	return 0;
-
-rollback:
-	if (!i)
-		goto unlock;
-	for (param--; i > 0; i--, param--)
-		devlink_param_unregister_one(devlink, port_index, param_list,
-					     param, unreg_cmd);
-unlock:
-	mutex_unlock(&devlink->lock);
-	return err;
-}
-
-static void __devlink_params_unregister(struct devlink *devlink,
-					unsigned int port_index,
-					struct list_head *param_list,
-					const struct devlink_param *params,
-					size_t params_count,
-					enum devlink_command cmd)
-{
-	const struct devlink_param *param = params;
-	int i;
-
-	mutex_lock(&devlink->lock);
-	for (i = 0; i < params_count; i++, param++)
-		devlink_param_unregister_one(devlink, 0, param_list, param,
-					     cmd);
-	mutex_unlock(&devlink->lock);
-}
-
 /**
  *	devlink_params_register - register configuration parameters
  *
@@ -10172,12 +10066,25 @@ int devlink_params_register(struct devlink *devlink,
 			    const struct devlink_param *params,
 			    size_t params_count)
 {
+	const struct devlink_param *param = params;
+	int i, err;
+
 	ASSERT_DEVLINK_NOT_REGISTERED(devlink);
 
-	return __devlink_params_register(devlink, 0, &devlink->param_list,
-					 params, params_count,
-					 DEVLINK_CMD_PARAM_NEW,
-					 DEVLINK_CMD_PARAM_DEL);
+	for (i = 0; i < params_count; i++, param++) {
+		err = devlink_param_register(devlink, param);
+		if (err)
+			goto rollback;
+	}
+	return 0;
+
+rollback:
+	if (!i)
+		return err;
+
+	for (param--; i > 0; i--, param--)
+		devlink_param_unregister(devlink, param);
+	return err;
 }
 EXPORT_SYMBOL_GPL(devlink_params_register);
 
@@ -10191,11 +10098,13 @@ void devlink_params_unregister(struct devlink *devlink,
 			       const struct devlink_param *params,
 			       size_t params_count)
 {
+	const struct devlink_param *param = params;
+	int i;
+
 	ASSERT_DEVLINK_NOT_REGISTERED(devlink);
 
-	return __devlink_params_unregister(devlink, 0, &devlink->param_list,
-					   params, params_count,
-					   DEVLINK_CMD_PARAM_DEL);
+	for (i = 0; i < params_count; i++, param++)
+		devlink_param_unregister(devlink, param);
 }
 EXPORT_SYMBOL_GPL(devlink_params_unregister);
 
@@ -10211,15 +10120,26 @@ EXPORT_SYMBOL_GPL(devlink_params_unregister);
 int devlink_param_register(struct devlink *devlink,
 			   const struct devlink_param *param)
 {
-	int err;
+	struct devlink_param_item *param_item;
 
 	ASSERT_DEVLINK_NOT_REGISTERED(devlink);
 
-	mutex_lock(&devlink->lock);
-	err = __devlink_param_register_one(devlink, 0, &devlink->param_list,
-					   param, DEVLINK_CMD_PARAM_NEW);
-	mutex_unlock(&devlink->lock);
-	return err;
+	WARN_ON(devlink_param_verify(param));
+	WARN_ON(devlink_param_find_by_name(&devlink->param_list, param->name));
+
+	if (param->supported_cmodes == BIT(DEVLINK_PARAM_CMODE_DRIVERINIT))
+		WARN_ON(param->get || param->set);
+	else
+		WARN_ON(!param->get || !param->set);
+
+	param_item = kzalloc(sizeof(*param_item), GFP_KERNEL);
+	if (!param_item)
+		return -ENOMEM;
+
+	param_item->param = param;
+
+	list_add_tail(&param_item->list, &devlink->param_list);
+	return 0;
 }
 EXPORT_SYMBOL_GPL(devlink_param_register);
 
@@ -10231,12 +10151,15 @@ EXPORT_SYMBOL_GPL(devlink_param_register);
 void devlink_param_unregister(struct devlink *devlink,
 			      const struct devlink_param *param)
 {
+	struct devlink_param_item *param_item;
+
 	ASSERT_DEVLINK_NOT_REGISTERED(devlink);
 
-	mutex_lock(&devlink->lock);
-	devlink_param_unregister_one(devlink, 0, &devlink->param_list, param,
-				     DEVLINK_CMD_PARAM_DEL);
-	mutex_unlock(&devlink->lock);
+	param_item =
+		devlink_param_find_by_name(&devlink->param_list, param->name);
+	WARN_ON(!param_item);
+	list_del(&param_item->list);
+	kfree(param_item);
 }
 EXPORT_SYMBOL_GPL(devlink_param_unregister);
 
-- 
2.31.1

