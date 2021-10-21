Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82B144363ED
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 16:16:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231638AbhJUOSy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 10:18:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:46436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231620AbhJUOSx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Oct 2021 10:18:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 932446120F;
        Thu, 21 Oct 2021 14:16:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634825797;
        bh=2kL3J1jzXKxZY8dZfX3pKzfX7spREyhhof9NQO1L6G4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MLoE5/ShBran6+jGdMUKBiTwJUporFfGO4SPd137RuxDfVZbkN+NfXRTpNYR6K4Nk
         bw9Cb6cFw7bRAzkhyT4v/v0fmuo7C1euqyGxqq08O1A9HUWjGDx6SGlAtEOMGkFvBS
         LNSvEc04egT7xGragQ50+V2FoPNnFov9nNh3SSPJiPPSPkRPys14HpMB8bcWb5OVp6
         Z9NTj4dCOjfQ19etDVFHhLweNq4KJO16z0TXb3AGnLxBEGKmAMKimpXlAE+HgDo3z/
         raETzXwTVO+GtyDyq36JJ0fBs5c7kxVGpVyRImxE6L5fKWWdHsvoZkRceiJbeVIZWt
         /MqV7FDUWRfMQ==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next 4/4] devlink: Clean not-executed param notifications
Date:   Thu, 21 Oct 2021 17:16:16 +0300
Message-Id: <69d246c5cd5367a2f48a77331a547630b4314dbe.1634825474.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1634825474.git.leonro@nvidia.com>
References: <cover.1634825474.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

The parameters are registered before devlink_register() and all the
notifications are delayed. This patch removes not-possible parameters
notifications along with addition of code annotation logic.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 net/core/devlink.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 10e953abad89..f38ef4b26f70 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -4675,6 +4675,7 @@ static void devlink_param_notify(struct devlink *devlink,
 	WARN_ON(cmd != DEVLINK_CMD_PARAM_NEW && cmd != DEVLINK_CMD_PARAM_DEL &&
 		cmd != DEVLINK_CMD_PORT_PARAM_NEW &&
 		cmd != DEVLINK_CMD_PORT_PARAM_DEL);
+	ASSERT_DEVLINK_REGISTERED(devlink);
 
 	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
 	if (!msg)
@@ -4946,7 +4947,6 @@ static int devlink_param_register_one(struct devlink *devlink,
 	param_item->param = param;
 
 	list_add_tail(&param_item->list, param_list);
-	devlink_param_notify(devlink, port_index, param_item, cmd);
 	return 0;
 }
 
@@ -4960,7 +4960,6 @@ static void devlink_param_unregister_one(struct devlink *devlink,
 
 	param_item = devlink_param_find_by_name(param_list, param->name);
 	WARN_ON(!param_item);
-	devlink_param_notify(devlink, port_index, param_item, cmd);
 	list_del(&param_item->list);
 	kfree(param_item);
 }
@@ -10173,6 +10172,8 @@ int devlink_params_register(struct devlink *devlink,
 			    const struct devlink_param *params,
 			    size_t params_count)
 {
+	ASSERT_DEVLINK_NOT_REGISTERED(devlink);
+
 	return __devlink_params_register(devlink, 0, &devlink->param_list,
 					 params, params_count,
 					 DEVLINK_CMD_PARAM_NEW,
@@ -10190,6 +10191,8 @@ void devlink_params_unregister(struct devlink *devlink,
 			       const struct devlink_param *params,
 			       size_t params_count)
 {
+	ASSERT_DEVLINK_NOT_REGISTERED(devlink);
+
 	return __devlink_params_unregister(devlink, 0, &devlink->param_list,
 					   params, params_count,
 					   DEVLINK_CMD_PARAM_DEL);
@@ -10210,6 +10213,8 @@ int devlink_param_register(struct devlink *devlink,
 {
 	int err;
 
+	ASSERT_DEVLINK_NOT_REGISTERED(devlink);
+
 	mutex_lock(&devlink->lock);
 	err = __devlink_param_register_one(devlink, 0, &devlink->param_list,
 					   param, DEVLINK_CMD_PARAM_NEW);
@@ -10226,6 +10231,8 @@ EXPORT_SYMBOL_GPL(devlink_param_register);
 void devlink_param_unregister(struct devlink *devlink,
 			      const struct devlink_param *param)
 {
+	ASSERT_DEVLINK_NOT_REGISTERED(devlink);
+
 	mutex_lock(&devlink->lock);
 	devlink_param_unregister_one(devlink, 0, &devlink->param_list, param,
 				     DEVLINK_CMD_PARAM_DEL);
@@ -10287,6 +10294,8 @@ int devlink_param_driverinit_value_set(struct devlink *devlink, u32 param_id,
 {
 	struct devlink_param_item *param_item;
 
+	ASSERT_DEVLINK_NOT_REGISTERED(devlink);
+
 	param_item = devlink_param_find_by_id(&devlink->param_list, param_id);
 	if (!param_item)
 		return -EINVAL;
@@ -10300,8 +10309,6 @@ int devlink_param_driverinit_value_set(struct devlink *devlink, u32 param_id,
 	else
 		param_item->driverinit_value = init_val;
 	param_item->driverinit_value_valid = true;
-
-	devlink_param_notify(devlink, 0, param_item, DEVLINK_CMD_PARAM_NEW);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(devlink_param_driverinit_value_set);
-- 
2.31.1

