Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AC054363EC
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 16:16:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231596AbhJUOSx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 10:18:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:46394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231612AbhJUOSt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Oct 2021 10:18:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1880D61208;
        Thu, 21 Oct 2021 14:16:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634825793;
        bh=JJogNYPkC33y0PkGsbF6S/Nu01i3aXr5ClfzadWnjTk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TzoK4Er/nl+ntDOaKmj9iYdfJcbFvrCDVEZOUS/G24bV/eRRFP5xmJFnqinaxoB3l
         VXDrQh4XM1/AeiKbAtgPGqHmGuGGAbPBD+dKdkRIFcbdZ1CILxeplE/FRCU8FtCTTx
         E5IOJ3i7bCiQ9yiMjlGe7w2+NQtQiQW6EtNYm1K3wsj+N2Wm94z02QAjisWbbtEzH0
         QrVnQ9o/DiVfjT4cRj/GBaSu1HeQD05RBFYgA1SRnFr3cnbbaJFCIVW8SLWmdsomlX
         iICfzMtExHlVZ6NPV9Tpl80hwhSWVx+kvmjA1a6ZM5yGVpGoSsGYRE6Oho4pwHuJu/
         mxXcKbTK80yaQ==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next 1/4] devlink: Delete obsolete parameters publish API
Date:   Thu, 21 Oct 2021 17:16:13 +0300
Message-Id: <022270d87dd7089c68941875c0e2c02cac547c3e.1634825474.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1634825474.git.leonro@nvidia.com>
References: <cover.1634825474.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

The change of devlink_register() to be last devlink command together
with delayed notification logic made the publish API to be obsolete.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 include/net/devlink.h |  3 ---
 net/core/devlink.c    | 57 ++++++-------------------------------------
 2 files changed, 8 insertions(+), 52 deletions(-)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index da3ceeb8b87b..1b1317d378de 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -468,7 +468,6 @@ struct devlink_param_item {
 	const struct devlink_param *param;
 	union devlink_param_value driverinit_value;
 	bool driverinit_value_valid;
-	bool published;
 };
 
 enum devlink_param_generic_id {
@@ -1592,8 +1591,6 @@ int devlink_param_register(struct devlink *devlink,
 			   const struct devlink_param *param);
 void devlink_param_unregister(struct devlink *devlink,
 			      const struct devlink_param *param);
-void devlink_params_publish(struct devlink *devlink);
-void devlink_params_unpublish(struct devlink *devlink);
 int devlink_param_driverinit_value_get(struct devlink *devlink, u32 param_id,
 				       union devlink_param_value *init_val);
 int devlink_param_driverinit_value_set(struct devlink *devlink, u32 param_id,
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 3464854015a2..e9802421ed50 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -4600,8 +4600,6 @@ static int devlink_nl_param_fill(struct sk_buff *msg, struct devlink *devlink,
 				return -EOPNOTSUPP;
 			param_value[i] = param_item->driverinit_value;
 		} else {
-			if (!param_item->published)
-				continue;
 			ctx.cmode = i;
 			err = devlink_param_get(devlink, param, &ctx);
 			if (err)
@@ -9076,6 +9074,7 @@ static void devlink_notify_register(struct devlink *devlink)
 {
 	struct devlink_trap_policer_item *policer_item;
 	struct devlink_trap_group_item *group_item;
+	struct devlink_param_item *param_item;
 	struct devlink_trap_item *trap_item;
 	struct devlink_port *devlink_port;
 	struct devlink_rate *rate_node;
@@ -9102,19 +9101,24 @@ static void devlink_notify_register(struct devlink *devlink)
 	list_for_each_entry(region, &devlink->region_list, list)
 		devlink_nl_region_notify(region, NULL, DEVLINK_CMD_REGION_NEW);
 
-	devlink_params_publish(devlink);
+	list_for_each_entry(param_item, &devlink->param_list, list)
+		devlink_param_notify(devlink, 0, param_item,
+				     DEVLINK_CMD_PARAM_NEW);
 }
 
 static void devlink_notify_unregister(struct devlink *devlink)
 {
 	struct devlink_trap_policer_item *policer_item;
 	struct devlink_trap_group_item *group_item;
+	struct devlink_param_item *param_item;
 	struct devlink_trap_item *trap_item;
 	struct devlink_port *devlink_port;
 	struct devlink_rate *rate_node;
 	struct devlink_region *region;
 
-	devlink_params_unpublish(devlink);
+	list_for_each_entry_reverse(param_item, &devlink->param_list, list)
+		devlink_param_notify(devlink, 0, param_item,
+				     DEVLINK_CMD_PARAM_DEL);
 
 	list_for_each_entry_reverse(region, &devlink->region_list, list)
 		devlink_nl_region_notify(region, NULL, DEVLINK_CMD_REGION_DEL);
@@ -10229,51 +10233,6 @@ void devlink_param_unregister(struct devlink *devlink,
 }
 EXPORT_SYMBOL_GPL(devlink_param_unregister);
 
-/**
- *	devlink_params_publish - publish configuration parameters
- *
- *	@devlink: devlink
- *
- *	Publish previously registered configuration parameters.
- */
-void devlink_params_publish(struct devlink *devlink)
-{
-	struct devlink_param_item *param_item;
-
-	if (!xa_get_mark(&devlinks, devlink->index, DEVLINK_REGISTERED))
-		return;
-
-	list_for_each_entry(param_item, &devlink->param_list, list) {
-		if (param_item->published)
-			continue;
-		param_item->published = true;
-		devlink_param_notify(devlink, 0, param_item,
-				     DEVLINK_CMD_PARAM_NEW);
-	}
-}
-EXPORT_SYMBOL_GPL(devlink_params_publish);
-
-/**
- *	devlink_params_unpublish - unpublish configuration parameters
- *
- *	@devlink: devlink
- *
- *	Unpublish previously registered configuration parameters.
- */
-void devlink_params_unpublish(struct devlink *devlink)
-{
-	struct devlink_param_item *param_item;
-
-	list_for_each_entry(param_item, &devlink->param_list, list) {
-		if (!param_item->published)
-			continue;
-		param_item->published = false;
-		devlink_param_notify(devlink, 0, param_item,
-				     DEVLINK_CMD_PARAM_DEL);
-	}
-}
-EXPORT_SYMBOL_GPL(devlink_params_unpublish);
-
 /**
  *	devlink_param_driverinit_value_get - get configuration parameter
  *					     value for driver initializing
-- 
2.31.1

