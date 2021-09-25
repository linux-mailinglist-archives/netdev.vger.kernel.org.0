Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB2EE41813D
	for <lists+netdev@lfdr.de>; Sat, 25 Sep 2021 13:23:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244620AbhIYLYr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Sep 2021 07:24:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:55318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244572AbhIYLYo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Sep 2021 07:24:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4721B61283;
        Sat, 25 Sep 2021 11:23:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632568990;
        bh=3uCY0iZrxWFrDSXP86vU6Gnic5vFXMQM0QlKZCzTd6I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YNYk0Mv63XX5PqerdlMIOLxUIzh5mfJBU1cn1qTr9FvUEQmPZw4WFkZf3JsdOAIvg
         Ps//rK0fsA3n/Q9f7CJTLCp4yRG28ssNng+d0anCpUptlMKSTkl52iFnzRCJL3vWIV
         DY0xxS4mTDNDx6elazDRWDcQ2byO7wJoGxZwleamszH0C7+Aq/3PQfUNjjdDt9jWQi
         6NlJjTK/y4kVrXiZa8QQBshnRcI94odNI1xzPzB/qharb+WdgDGHeC1YxccquPBvwR
         61o8XtdDanfVfUsNxAPMpX7UZVtoJV3g6hHhfN/Z8n4x1KxlDuCXjiZowCwtKkJsjU
         PUfn4nZNdtUiA==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>, Ariel Elior <aelior@marvell.com>,
        Bin Luo <luobin9@huawei.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Coiby Xu <coiby.xu@gmail.com>,
        Derek Chickles <dchickles@marvell.com>, drivers@pensando.io,
        Felix Manlunas <fmanlunas@marvell.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        GR-everest-linux-l2@marvell.com, GR-Linux-NIC-Dev@marvell.com,
        hariprasad <hkelam@marvell.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Intel Corporation <linuxwwan@intel.com>,
        intel-wired-lan@lists.osuosl.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Jerin Jacob <jerinj@marvell.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jiri Pirko <jiri@nvidia.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Linu Cherian <lcherian@marvell.com>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-staging@lists.linux.dev,
        Loic Poulain <loic.poulain@linaro.org>,
        Manish Chopra <manishc@marvell.com>,
        M Chetan Kumar <m.chetan.kumar@intel.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Michael Guralnik <michaelgur@mellanox.com>,
        netdev@vger.kernel.org, oss-drivers@corigine.com,
        Richard Cochran <richardcochran@gmail.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Satanand Burla <sburla@marvell.com>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Shannon Nelson <snelson@pensando.io>,
        Simon Horman <simon.horman@corigine.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        UNGLinuxDriver@microchip.com, Vadym Kochan <vkochan@marvell.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next v1 01/21] devlink: Notify users when objects are accessible
Date:   Sat, 25 Sep 2021 14:22:41 +0300
Message-Id: <0f7f201a059b24c96eac837e1f424e2483254e1c.1632565508.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1632565508.git.leonro@nvidia.com>
References: <cover.1632565508.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

The devlink core code notified users about add/remove objects without
relation if this object can be accessible or not. In this patch we unify
such user visible notifications in one place.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 net/core/devlink.c | 107 +++++++++++++++++++++++++++++++++++++++------
 1 file changed, 93 insertions(+), 14 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 3ea33c689790..06edb2f1d21e 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -742,6 +742,7 @@ static void devlink_notify(struct devlink *devlink, enum devlink_command cmd)
 	int err;
 
 	WARN_ON(cmd != DEVLINK_CMD_NEW && cmd != DEVLINK_CMD_DEL);
+	WARN_ON(!xa_get_mark(&devlinks, devlink->index, DEVLINK_REGISTERED));
 
 	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
 	if (!msg)
@@ -1040,11 +1041,15 @@ static int devlink_nl_port_fill(struct sk_buff *msg,
 static void devlink_port_notify(struct devlink_port *devlink_port,
 				enum devlink_command cmd)
 {
+	struct devlink *devlink = devlink_port->devlink;
 	struct sk_buff *msg;
 	int err;
 
 	WARN_ON(cmd != DEVLINK_CMD_PORT_NEW && cmd != DEVLINK_CMD_PORT_DEL);
 
+	if (!xa_get_mark(&devlinks, devlink->index, DEVLINK_REGISTERED))
+		return;
+
 	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
 	if (!msg)
 		return;
@@ -1055,18 +1060,19 @@ static void devlink_port_notify(struct devlink_port *devlink_port,
 		return;
 	}
 
-	genlmsg_multicast_netns(&devlink_nl_family,
-				devlink_net(devlink_port->devlink), msg, 0,
-				DEVLINK_MCGRP_CONFIG, GFP_KERNEL);
+	genlmsg_multicast_netns(&devlink_nl_family, devlink_net(devlink), msg,
+				0, DEVLINK_MCGRP_CONFIG, GFP_KERNEL);
 }
 
 static void devlink_rate_notify(struct devlink_rate *devlink_rate,
 				enum devlink_command cmd)
 {
+	struct devlink *devlink = devlink_rate->devlink;
 	struct sk_buff *msg;
 	int err;
 
 	WARN_ON(cmd != DEVLINK_CMD_RATE_NEW && cmd != DEVLINK_CMD_RATE_DEL);
+	WARN_ON(!xa_get_mark(&devlinks, devlink->index, DEVLINK_REGISTERED));
 
 	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
 	if (!msg)
@@ -1078,9 +1084,8 @@ static void devlink_rate_notify(struct devlink_rate *devlink_rate,
 		return;
 	}
 
-	genlmsg_multicast_netns(&devlink_nl_family,
-				devlink_net(devlink_rate->devlink), msg, 0,
-				DEVLINK_MCGRP_CONFIG, GFP_KERNEL);
+	genlmsg_multicast_netns(&devlink_nl_family, devlink_net(devlink), msg,
+				0, DEVLINK_MCGRP_CONFIG, GFP_KERNEL);
 }
 
 static int devlink_nl_cmd_rate_get_dumpit(struct sk_buff *msg,
@@ -4150,6 +4155,7 @@ static void __devlink_flash_update_notify(struct devlink *devlink,
 	WARN_ON(cmd != DEVLINK_CMD_FLASH_UPDATE &&
 		cmd != DEVLINK_CMD_FLASH_UPDATE_END &&
 		cmd != DEVLINK_CMD_FLASH_UPDATE_STATUS);
+	WARN_ON(!xa_get_mark(&devlinks, devlink->index, DEVLINK_REGISTERED));
 
 	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
 	if (!msg)
@@ -5145,17 +5151,18 @@ static void devlink_nl_region_notify(struct devlink_region *region,
 				     struct devlink_snapshot *snapshot,
 				     enum devlink_command cmd)
 {
+	struct devlink *devlink = region->devlink;
 	struct sk_buff *msg;
 
 	WARN_ON(cmd != DEVLINK_CMD_REGION_NEW && cmd != DEVLINK_CMD_REGION_DEL);
+	WARN_ON(!xa_get_mark(&devlinks, devlink->index, DEVLINK_REGISTERED));
 
 	msg = devlink_nl_region_notify_build(region, snapshot, cmd, 0, 0);
 	if (IS_ERR(msg))
 		return;
 
-	genlmsg_multicast_netns(&devlink_nl_family,
-				devlink_net(region->devlink), msg, 0,
-				DEVLINK_MCGRP_CONFIG, GFP_KERNEL);
+	genlmsg_multicast_netns(&devlink_nl_family, devlink_net(devlink), msg,
+				0, DEVLINK_MCGRP_CONFIG, GFP_KERNEL);
 }
 
 /**
@@ -6920,10 +6927,12 @@ devlink_nl_health_reporter_fill(struct sk_buff *msg,
 static void devlink_recover_notify(struct devlink_health_reporter *reporter,
 				   enum devlink_command cmd)
 {
+	struct devlink *devlink = reporter->devlink;
 	struct sk_buff *msg;
 	int err;
 
 	WARN_ON(cmd != DEVLINK_CMD_HEALTH_REPORTER_RECOVER);
+	WARN_ON(!xa_get_mark(&devlinks, devlink->index, DEVLINK_REGISTERED));
 
 	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
 	if (!msg)
@@ -6935,9 +6944,8 @@ static void devlink_recover_notify(struct devlink_health_reporter *reporter,
 		return;
 	}
 
-	genlmsg_multicast_netns(&devlink_nl_family,
-				devlink_net(reporter->devlink),
-				msg, 0, DEVLINK_MCGRP_CONFIG, GFP_KERNEL);
+	genlmsg_multicast_netns(&devlink_nl_family, devlink_net(devlink), msg,
+				0, DEVLINK_MCGRP_CONFIG, GFP_KERNEL);
 }
 
 void
@@ -8955,6 +8963,68 @@ struct devlink *devlink_alloc_ns(const struct devlink_ops *ops,
 }
 EXPORT_SYMBOL_GPL(devlink_alloc_ns);
 
+static void
+devlink_trap_policer_notify(struct devlink *devlink,
+			    const struct devlink_trap_policer_item *policer_item,
+			    enum devlink_command cmd);
+static void
+devlink_trap_group_notify(struct devlink *devlink,
+			  const struct devlink_trap_group_item *group_item,
+			  enum devlink_command cmd);
+static void devlink_trap_notify(struct devlink *devlink,
+				const struct devlink_trap_item *trap_item,
+				enum devlink_command cmd);
+
+static void devlink_notify_register(struct devlink *devlink)
+{
+	struct devlink_trap_policer_item *policer_item;
+	struct devlink_trap_group_item *group_item;
+	struct devlink_trap_item *trap_item;
+	struct devlink_port *devlink_port;
+
+	devlink_notify(devlink, DEVLINK_CMD_NEW);
+	list_for_each_entry(devlink_port, &devlink->port_list, list)
+		devlink_port_notify(devlink_port, DEVLINK_CMD_PORT_NEW);
+
+	list_for_each_entry(policer_item, &devlink->trap_policer_list, list)
+		devlink_trap_policer_notify(devlink, policer_item,
+					    DEVLINK_CMD_TRAP_POLICER_NEW);
+
+	list_for_each_entry(group_item, &devlink->trap_group_list, list)
+		devlink_trap_group_notify(devlink, group_item,
+					  DEVLINK_CMD_TRAP_GROUP_NEW);
+
+	list_for_each_entry(trap_item, &devlink->trap_list, list)
+		devlink_trap_notify(devlink, trap_item, DEVLINK_CMD_TRAP_NEW);
+
+	devlink_params_publish(devlink);
+}
+
+static void devlink_notify_unregister(struct devlink *devlink)
+{
+	struct devlink_trap_policer_item *policer_item;
+	struct devlink_trap_group_item *group_item;
+	struct devlink_trap_item *trap_item;
+	struct devlink_port *devlink_port;
+
+	devlink_params_unpublish(devlink);
+
+	list_for_each_entry_reverse(trap_item, &devlink->trap_list, list)
+		devlink_trap_notify(devlink, trap_item, DEVLINK_CMD_TRAP_DEL);
+
+	list_for_each_entry_reverse(group_item, &devlink->trap_group_list, list)
+		devlink_trap_group_notify(devlink, group_item,
+					  DEVLINK_CMD_TRAP_GROUP_DEL);
+	list_for_each_entry_reverse(policer_item, &devlink->trap_policer_list,
+				    list)
+		devlink_trap_policer_notify(devlink, policer_item,
+					    DEVLINK_CMD_TRAP_POLICER_DEL);
+
+	list_for_each_entry_reverse(devlink_port, &devlink->port_list, list)
+		devlink_port_notify(devlink_port, DEVLINK_CMD_PORT_DEL);
+	devlink_notify(devlink, DEVLINK_CMD_DEL);
+}
+
 /**
  *	devlink_register - Register devlink instance
  *
@@ -8964,7 +9034,7 @@ void devlink_register(struct devlink *devlink)
 {
 	mutex_lock(&devlink_mutex);
 	xa_set_mark(&devlinks, devlink->index, DEVLINK_REGISTERED);
-	devlink_notify(devlink, DEVLINK_CMD_NEW);
+	devlink_notify_register(devlink);
 	mutex_unlock(&devlink_mutex);
 }
 EXPORT_SYMBOL_GPL(devlink_register);
@@ -8982,7 +9052,7 @@ void devlink_unregister(struct devlink *devlink)
 	mutex_lock(&devlink_mutex);
 	WARN_ON(devlink_reload_supported(devlink->ops) &&
 		devlink->reload_enabled);
-	devlink_notify(devlink, DEVLINK_CMD_DEL);
+	devlink_notify_unregister(devlink);
 	xa_clear_mark(&devlinks, devlink->index, DEVLINK_REGISTERED);
 	mutex_unlock(&devlink_mutex);
 }
@@ -10086,6 +10156,9 @@ void devlink_params_publish(struct devlink *devlink)
 {
 	struct devlink_param_item *param_item;
 
+	if (!xa_get_mark(&devlinks, devlink->index, DEVLINK_REGISTERED))
+		return;
+
 	list_for_each_entry(param_item, &devlink->param_list, list) {
 		if (param_item->published)
 			continue;
@@ -10631,6 +10704,8 @@ devlink_trap_group_notify(struct devlink *devlink,
 
 	WARN_ON_ONCE(cmd != DEVLINK_CMD_TRAP_GROUP_NEW &&
 		     cmd != DEVLINK_CMD_TRAP_GROUP_DEL);
+	if (!xa_get_mark(&devlinks, devlink->index, DEVLINK_REGISTERED))
+		return;
 
 	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
 	if (!msg)
@@ -10672,6 +10747,8 @@ static void devlink_trap_notify(struct devlink *devlink,
 
 	WARN_ON_ONCE(cmd != DEVLINK_CMD_TRAP_NEW &&
 		     cmd != DEVLINK_CMD_TRAP_DEL);
+	if (!xa_get_mark(&devlinks, devlink->index, DEVLINK_REGISTERED))
+		return;
 
 	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
 	if (!msg)
@@ -11053,6 +11130,8 @@ devlink_trap_policer_notify(struct devlink *devlink,
 
 	WARN_ON_ONCE(cmd != DEVLINK_CMD_TRAP_POLICER_NEW &&
 		     cmd != DEVLINK_CMD_TRAP_POLICER_DEL);
+	if (!xa_get_mark(&devlinks, devlink->index, DEVLINK_REGISTERED))
+		return;
 
 	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
 	if (!msg)
-- 
2.31.1

