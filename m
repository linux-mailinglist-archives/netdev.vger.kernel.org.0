Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86EA63EC1D1
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 11:58:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237781AbhHNJ6S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Aug 2021 05:58:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:37526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237773AbhHNJ6N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 14 Aug 2021 05:58:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5946460F46;
        Sat, 14 Aug 2021 09:57:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628935065;
        bh=bxYbBOli6AiOLwUVvX+oRGtlBzd/WaLHLFsRaXmGCSg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qi6jsDNuon05U42FP8EA68zyptt3j40pasItjIDZBTUjYnSWr0n2JsT+CqXWw4Dug
         xCxvlLM98ZSLFGYnmCGsjgHRrDd8DDo8Jdg9+aBiIkoaM5BeWnwvPI2xOxgkeXTVap
         /1Fws87GETnQ+5HWqHN3dq68dlLVUNMSaz/NxYg+SVu1wdTzOlYi3H3xrMfJz2Mobc
         rl/r8grimOnq9cCgGjzKnYiJNobHG1ysixmhsQgwVD+6twX98Pj/bOj3ypuiBCySaI
         NdfCg3InPKkHrjKOY+0F7VWkFyJrO3u2B8EKvC+wvi/DrT8O0y8WK+cxyobVWqS7CL
         +U1thl0Y7zVVw==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Jiri Pirko <jiri@nvidia.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Salil Mehta <salil.mehta@huawei.com>,
        Shannon Nelson <snelson@pensando.io>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Yufeng Mo <moyufeng@huawei.com>
Subject: [PATCH net-next 2/6] devlink: Remove check of always valid devlink pointer
Date:   Sat, 14 Aug 2021 12:57:27 +0300
Message-Id: <434a32266cbd4855fdfb3ea12517523aa9042539.1628933864.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1628933864.git.leonro@nvidia.com>
References: <cover.1628933864.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Devlink objects are accessible only after they were registered and
have valid devlink_*->devlink pointers.

Remove that check and simplify respective fill functions as an outcome
of such change.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 net/core/devlink.c | 94 +++++++++++++++++++---------------------------
 1 file changed, 38 insertions(+), 56 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 9e74a95b3322..c8a8eecad1c5 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -832,12 +832,11 @@ static int devlink_port_fn_hw_addr_fill(const struct devlink_ops *ops,
 }
 
 static int devlink_nl_rate_fill(struct sk_buff *msg,
-				struct devlink *devlink,
 				struct devlink_rate *devlink_rate,
-				enum devlink_command cmd, u32 portid,
-				u32 seq, int flags,
-				struct netlink_ext_ack *extack)
+				enum devlink_command cmd, u32 portid, u32 seq,
+				int flags, struct netlink_ext_ack *extack)
 {
+	struct devlink *devlink = devlink_rate->devlink;
 	void *hdr;
 
 	hdr = genlmsg_put(msg, portid, seq, &devlink_nl_family, flags, cmd);
@@ -959,12 +958,12 @@ devlink_nl_port_function_attrs_put(struct sk_buff *msg, struct devlink_port *por
 	return err;
 }
 
-static int devlink_nl_port_fill(struct sk_buff *msg, struct devlink *devlink,
+static int devlink_nl_port_fill(struct sk_buff *msg,
 				struct devlink_port *devlink_port,
-				enum devlink_command cmd, u32 portid,
-				u32 seq, int flags,
-				struct netlink_ext_ack *extack)
+				enum devlink_command cmd, u32 portid, u32 seq,
+				int flags, struct netlink_ext_ack *extack)
 {
+	struct devlink *devlink = devlink_port->devlink;
 	void *hdr;
 
 	hdr = genlmsg_put(msg, portid, seq, &devlink_nl_family, flags, cmd);
@@ -1025,53 +1024,47 @@ static int devlink_nl_port_fill(struct sk_buff *msg, struct devlink *devlink,
 static void devlink_port_notify(struct devlink_port *devlink_port,
 				enum devlink_command cmd)
 {
-	struct devlink *devlink = devlink_port->devlink;
 	struct sk_buff *msg;
 	int err;
 
-	if (!devlink_port->devlink)
-		return;
-
 	WARN_ON(cmd != DEVLINK_CMD_PORT_NEW && cmd != DEVLINK_CMD_PORT_DEL);
 
 	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
 	if (!msg)
 		return;
 
-	err = devlink_nl_port_fill(msg, devlink, devlink_port, cmd, 0, 0, 0,
-				   NULL);
+	err = devlink_nl_port_fill(msg, devlink_port, cmd, 0, 0, 0, NULL);
 	if (err) {
 		nlmsg_free(msg);
 		return;
 	}
 
-	genlmsg_multicast_netns(&devlink_nl_family, devlink_net(devlink),
-				msg, 0, DEVLINK_MCGRP_CONFIG, GFP_KERNEL);
+	genlmsg_multicast_netns(&devlink_nl_family,
+				devlink_net(devlink_port->devlink), msg, 0,
+				DEVLINK_MCGRP_CONFIG, GFP_KERNEL);
 }
 
 static void devlink_rate_notify(struct devlink_rate *devlink_rate,
 				enum devlink_command cmd)
 {
-	struct devlink *devlink = devlink_rate->devlink;
 	struct sk_buff *msg;
 	int err;
 
-	WARN_ON(cmd != DEVLINK_CMD_RATE_NEW &&
-		cmd != DEVLINK_CMD_RATE_DEL);
+	WARN_ON(cmd != DEVLINK_CMD_RATE_NEW && cmd != DEVLINK_CMD_RATE_DEL);
 
 	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
 	if (!msg)
 		return;
 
-	err = devlink_nl_rate_fill(msg, devlink, devlink_rate,
-				   cmd, 0, 0, 0, NULL);
+	err = devlink_nl_rate_fill(msg, devlink_rate, cmd, 0, 0, 0, NULL);
 	if (err) {
 		nlmsg_free(msg);
 		return;
 	}
 
-	genlmsg_multicast_netns(&devlink_nl_family, devlink_net(devlink),
-				msg, 0, DEVLINK_MCGRP_CONFIG, GFP_KERNEL);
+	genlmsg_multicast_netns(&devlink_nl_family,
+				devlink_net(devlink_rate->devlink), msg, 0,
+				DEVLINK_MCGRP_CONFIG, GFP_KERNEL);
 }
 
 static int devlink_nl_cmd_rate_get_dumpit(struct sk_buff *msg,
@@ -1096,9 +1089,7 @@ static int devlink_nl_cmd_rate_get_dumpit(struct sk_buff *msg,
 				idx++;
 				continue;
 			}
-			err = devlink_nl_rate_fill(msg, devlink,
-						   devlink_rate,
-						   cmd, id,
+			err = devlink_nl_rate_fill(msg, devlink_rate, cmd, id,
 						   cb->nlh->nlmsg_seq,
 						   NLM_F_MULTI, NULL);
 			if (err) {
@@ -1122,7 +1113,6 @@ static int devlink_nl_cmd_rate_get_doit(struct sk_buff *skb,
 					struct genl_info *info)
 {
 	struct devlink_rate *devlink_rate = info->user_ptr[1];
-	struct devlink *devlink = devlink_rate->devlink;
 	struct sk_buff *msg;
 	int err;
 
@@ -1130,8 +1120,7 @@ static int devlink_nl_cmd_rate_get_doit(struct sk_buff *skb,
 	if (!msg)
 		return -ENOMEM;
 
-	err = devlink_nl_rate_fill(msg, devlink, devlink_rate,
-				   DEVLINK_CMD_RATE_NEW,
+	err = devlink_nl_rate_fill(msg, devlink_rate, DEVLINK_CMD_RATE_NEW,
 				   info->snd_portid, info->snd_seq, 0,
 				   info->extack);
 	if (err) {
@@ -1208,7 +1197,6 @@ static int devlink_nl_cmd_port_get_doit(struct sk_buff *skb,
 					struct genl_info *info)
 {
 	struct devlink_port *devlink_port = info->user_ptr[1];
-	struct devlink *devlink = devlink_port->devlink;
 	struct sk_buff *msg;
 	int err;
 
@@ -1216,8 +1204,7 @@ static int devlink_nl_cmd_port_get_doit(struct sk_buff *skb,
 	if (!msg)
 		return -ENOMEM;
 
-	err = devlink_nl_port_fill(msg, devlink, devlink_port,
-				   DEVLINK_CMD_PORT_NEW,
+	err = devlink_nl_port_fill(msg, devlink_port, DEVLINK_CMD_PORT_NEW,
 				   info->snd_portid, info->snd_seq, 0,
 				   info->extack);
 	if (err) {
@@ -1247,12 +1234,11 @@ static int devlink_nl_cmd_port_get_dumpit(struct sk_buff *msg,
 				idx++;
 				continue;
 			}
-			err = devlink_nl_port_fill(msg, devlink, devlink_port,
+			err = devlink_nl_port_fill(msg, devlink_port,
 						   DEVLINK_CMD_NEW,
 						   NETLINK_CB(cb->skb).portid,
 						   cb->nlh->nlmsg_seq,
-						   NLM_F_MULTI,
-						   cb->extack);
+						   NLM_F_MULTI, cb->extack);
 			if (err) {
 				mutex_unlock(&devlink->lock);
 				goto out;
@@ -1488,9 +1474,8 @@ static int devlink_port_new_notifiy(struct devlink *devlink,
 		goto out;
 	}
 
-	err = devlink_nl_port_fill(msg, devlink, devlink_port,
-				   DEVLINK_CMD_NEW, info->snd_portid,
-				   info->snd_seq, 0, NULL);
+	err = devlink_nl_port_fill(msg, devlink_port, DEVLINK_CMD_NEW,
+				   info->snd_portid, info->snd_seq, 0, NULL);
 	if (err)
 		goto out;
 
@@ -5071,7 +5056,6 @@ static void devlink_nl_region_notify(struct devlink_region *region,
 				     struct devlink_snapshot *snapshot,
 				     enum devlink_command cmd)
 {
-	struct devlink *devlink = region->devlink;
 	struct sk_buff *msg;
 
 	WARN_ON(cmd != DEVLINK_CMD_REGION_NEW && cmd != DEVLINK_CMD_REGION_DEL);
@@ -5080,8 +5064,9 @@ static void devlink_nl_region_notify(struct devlink_region *region,
 	if (IS_ERR(msg))
 		return;
 
-	genlmsg_multicast_netns(&devlink_nl_family, devlink_net(devlink),
-				msg, 0, DEVLINK_MCGRP_CONFIG, GFP_KERNEL);
+	genlmsg_multicast_netns(&devlink_nl_family,
+				devlink_net(region->devlink), msg, 0,
+				DEVLINK_MCGRP_CONFIG, GFP_KERNEL);
 }
 
 /**
@@ -6765,11 +6750,11 @@ EXPORT_SYMBOL_GPL(devlink_port_health_reporter_destroy);
 
 static int
 devlink_nl_health_reporter_fill(struct sk_buff *msg,
-				struct devlink *devlink,
 				struct devlink_health_reporter *reporter,
 				enum devlink_command cmd, u32 portid,
 				u32 seq, int flags)
 {
+	struct devlink *devlink = reporter->devlink;
 	struct nlattr *reporter_attr;
 	void *hdr;
 
@@ -6846,8 +6831,7 @@ static void devlink_recover_notify(struct devlink_health_reporter *reporter,
 	if (!msg)
 		return;
 
-	err = devlink_nl_health_reporter_fill(msg, reporter->devlink,
-					      reporter, cmd, 0, 0, 0);
+	err = devlink_nl_health_reporter_fill(msg, reporter, cmd, 0, 0, 0);
 	if (err) {
 		nlmsg_free(msg);
 		return;
@@ -7080,7 +7064,7 @@ static int devlink_nl_cmd_health_reporter_get_doit(struct sk_buff *skb,
 		goto out;
 	}
 
-	err = devlink_nl_health_reporter_fill(msg, devlink, reporter,
+	err = devlink_nl_health_reporter_fill(msg, reporter,
 					      DEVLINK_CMD_HEALTH_REPORTER_GET,
 					      info->snd_portid, info->snd_seq,
 					      0);
@@ -7117,12 +7101,10 @@ devlink_nl_cmd_health_reporter_get_dumpit(struct sk_buff *msg,
 				idx++;
 				continue;
 			}
-			err = devlink_nl_health_reporter_fill(msg, devlink,
-							      reporter,
-							      DEVLINK_CMD_HEALTH_REPORTER_GET,
-							      NETLINK_CB(cb->skb).portid,
-							      cb->nlh->nlmsg_seq,
-							      NLM_F_MULTI);
+			err = devlink_nl_health_reporter_fill(
+				msg, reporter, DEVLINK_CMD_HEALTH_REPORTER_GET,
+				NETLINK_CB(cb->skb).portid, cb->nlh->nlmsg_seq,
+				NLM_F_MULTI);
 			if (err) {
 				mutex_unlock(&devlink->reporters_lock);
 				goto out;
@@ -7143,11 +7125,11 @@ devlink_nl_cmd_health_reporter_get_dumpit(struct sk_buff *msg,
 					idx++;
 					continue;
 				}
-				err = devlink_nl_health_reporter_fill(msg, devlink, reporter,
-								      DEVLINK_CMD_HEALTH_REPORTER_GET,
-								      NETLINK_CB(cb->skb).portid,
-								      cb->nlh->nlmsg_seq,
-								      NLM_F_MULTI);
+				err = devlink_nl_health_reporter_fill(
+					msg, reporter,
+					DEVLINK_CMD_HEALTH_REPORTER_GET,
+					NETLINK_CB(cb->skb).portid,
+					cb->nlh->nlmsg_seq, NLM_F_MULTI);
 				if (err) {
 					mutex_unlock(&port->reporters_lock);
 					mutex_unlock(&devlink->lock);
-- 
2.31.1

