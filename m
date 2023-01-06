Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6071C65FB7E
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 07:34:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231971AbjAFGeW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 01:34:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231646AbjAFGeO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 01:34:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE3C76CFFA
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 22:34:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A85FEB81C6C
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 06:34:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18B0CC433D2;
        Fri,  6 Jan 2023 06:34:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672986850;
        bh=EOpJ0iWWzp2dgeV3YFHJxGliQhnwT2I6hw07fwug1i0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=clX81HSxjJb4OvAKumlUdMZAEFbYAvacWlBQfL1hQiXWUM4BgYs/KVhOcd1OsOW7p
         v5OJiSdFaOq4GzjdY5/NROpKI37ixUiemI62S08ht6rsn0GVU7fRwRM20QgnOL3lfu
         5ZgM18Zs0BbFfhtUvjh4Mp83XDKHstPVogdA8s92Wa7F6eYbOuIWJt14JfXY+qGjtZ
         ZvLoEgMU60yZ4katrXy6sLNLHyFmD19rPRn38lJatPJq5PCRlQYoiMI8iit3Wbo0ql
         Jtr+7yzrsikss9m8d8zeCu1CHci3qlWfE7CBYHlxsiBOTWzakRqYemEShNHgfdk0mS
         H/L+gixDVQvsA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        jacob.e.keller@intel.com, jiri@resnulli.us,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 7/9] devlink: allow registering parameters after the instance
Date:   Thu,  5 Jan 2023 22:34:00 -0800
Message-Id: <20230106063402.485336-8-kuba@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230106063402.485336-1-kuba@kernel.org>
References: <20230106063402.485336-1-kuba@kernel.org>
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
 net/devlink/leftover.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
index 491f821c8b77..1e23b2da78cc 100644
--- a/net/devlink/leftover.c
+++ b/net/devlink/leftover.c
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
+	if (!devl_is_registered(devlink))
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

