Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53E5364F6C4
	for <lists+netdev@lfdr.de>; Sat, 17 Dec 2022 02:20:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230033AbiLQBUb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Dec 2022 20:20:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbiLQBUP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Dec 2022 20:20:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C48B3680A5
        for <netdev@vger.kernel.org>; Fri, 16 Dec 2022 17:20:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 836CAB81E04
        for <netdev@vger.kernel.org>; Sat, 17 Dec 2022 01:20:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17360C433D2;
        Sat, 17 Dec 2022 01:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671240012;
        bh=hrOtzLohlRAKteFb+lHDAYXnw805sk+Q2zvcZMF6xTA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m5tVx4G7saANZpEdnihGFSfTNPNAg5lmhwXy3XG8BFRqfO0tAabllQv9VeLLbqsOF
         hoE61n8+lACchJcAwWFRb9bsvSawmbpS3Q9GX6UtCXJHkmqLdZnUpwLbqPazl79vnn
         njRB3nwgEqKzwAqyicpKbro22+HOJUb7fXH2oqj5YUbSPTtZTvesqA0MQiqDVmuAyS
         RB7YU9/+RazaqguLwMt6Hcc+oknUOHlM3XMWK0ly5c71Dv7c3x1TAc6fCxfuKJreo6
         8cgNhwhNZncRxMxVjFsgU6M8Kq8RD/OUPLx8otsJZjlecYPoBy10VGjX61e0JIjI+h
         t4G/nUQ4YBKGQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     jiri@resnulli.us, jacob.e.keller@intel.com, leon@kernel.org
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [RFC net-next 09/10] devlink: allow registering parameters after the instance
Date:   Fri, 16 Dec 2022 17:19:52 -0800
Message-Id: <20221217011953.152487-10-kuba@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221217011953.152487-1-kuba@kernel.org>
References: <20221217011953.152487-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It's most natural to register the instance first and then its
subobjects. Now that we can use the instance lock to protect
the atomicity of all init - it should also be safe.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/devlink/basic.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/net/devlink/basic.c b/net/devlink/basic.c
index 6b18e70a39fd..10b90a49aba0 100644
--- a/net/devlink/basic.c
+++ b/net/devlink/basic.c
@@ -5263,7 +5263,13 @@ static void devlink_param_notify(struct devlink *devlink,
 	WARN_ON(cmd != DEVLINK_CMD_PARAM_NEW && cmd != DEVLINK_CMD_PARAM_DEL &&
 		cmd != DEVLINK_CMD_PORT_PARAM_NEW &&
 		cmd != DEVLINK_CMD_PORT_PARAM_DEL);
-	ASSERT_DEVLINK_REGISTERED(devlink);
+
+	/* devlink_notify_register() / devlink_notify_unregister()
+	 * will replay the notifications if the params are added/removed
+	 * outside of the lifetime of the instance.
+	 */
+	if (!devl_is_alive(devlink))
+		return;
 
 	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
 	if (!msg)
@@ -10915,8 +10921,6 @@ int devlink_params_register(struct devlink *devlink,
 	const struct devlink_param *param = params;
 	int i, err;
 
-	ASSERT_DEVLINK_NOT_REGISTERED(devlink);
-
 	for (i = 0; i < params_count; i++, param++) {
 		err = devlink_param_register(devlink, param);
 		if (err)
@@ -10947,8 +10951,6 @@ void devlink_params_unregister(struct devlink *devlink,
 	const struct devlink_param *param = params;
 	int i;
 
-	ASSERT_DEVLINK_NOT_REGISTERED(devlink);
-
 	for (i = 0; i < params_count; i++, param++)
 		devlink_param_unregister(devlink, param);
 }
@@ -10968,8 +10970,6 @@ int devlink_param_register(struct devlink *devlink,
 {
 	struct devlink_param_item *param_item;
 
-	ASSERT_DEVLINK_NOT_REGISTERED(devlink);
-
 	WARN_ON(devlink_param_verify(param));
 	WARN_ON(devlink_param_find_by_name(&devlink->param_list, param->name));
 
@@ -10985,6 +10985,7 @@ int devlink_param_register(struct devlink *devlink,
 	param_item->param = param;
 
 	list_add_tail(&param_item->list, &devlink->param_list);
+	devlink_param_notify(devlink, 0, param_item, DEVLINK_CMD_PARAM_NEW);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(devlink_param_register);
@@ -10999,11 +11000,10 @@ void devlink_param_unregister(struct devlink *devlink,
 {
 	struct devlink_param_item *param_item;
 
-	ASSERT_DEVLINK_NOT_REGISTERED(devlink);
-
 	param_item =
 		devlink_param_find_by_name(&devlink->param_list, param->name);
 	WARN_ON(!param_item);
+	devlink_param_notify(devlink, 0, param_item, DEVLINK_CMD_PARAM_DEL);
 	list_del(&param_item->list);
 	kfree(param_item);
 }
@@ -11063,8 +11063,6 @@ int devlink_param_driverinit_value_set(struct devlink *devlink, u32 param_id,
 {
 	struct devlink_param_item *param_item;
 
-	ASSERT_DEVLINK_NOT_REGISTERED(devlink);
-
 	param_item = devlink_param_find_by_id(&devlink->param_list, param_id);
 	if (!param_item)
 		return -EINVAL;
@@ -11078,6 +11076,8 @@ int devlink_param_driverinit_value_set(struct devlink *devlink, u32 param_id,
 	else
 		param_item->driverinit_value = init_val;
 	param_item->driverinit_value_valid = true;
+
+	devlink_param_notify(devlink, 0, param_item, DEVLINK_CMD_PARAM_NEW);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(devlink_param_driverinit_value_set);
-- 
2.38.1

