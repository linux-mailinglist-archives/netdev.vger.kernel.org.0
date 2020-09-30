Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 470DE27F010
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 19:16:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731447AbgI3RQb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 13:16:31 -0400
Received: from inva021.nxp.com ([92.121.34.21]:56922 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727426AbgI3RQa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Sep 2020 13:16:30 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id CB126200062;
        Wed, 30 Sep 2020 19:16:29 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id BE9182007BE;
        Wed, 30 Sep 2020 19:16:29 +0200 (CEST)
Received: from fsr-ub1864-126.ea.freescale.net (fsr-ub1864-126.ea.freescale.net [10.171.82.212])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 732F520307;
        Wed, 30 Sep 2020 19:16:29 +0200 (CEST)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     jiri@nvidia.com, idosch@nvidia.com,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 2/4] devlink: add .trap_group_action_set() callback
Date:   Wed, 30 Sep 2020 20:16:09 +0300
Message-Id: <20200930171611.27121-3-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200930171611.27121-1-ioana.ciornei@nxp.com>
References: <20200930171611.27121-1-ioana.ciornei@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new devlink callback, .trap_group_action_set(), which can be used
by device drivers which do not support controlling the action (drop,
trap) on each trap but rather on the entire group trap.
If this new callback is populated, it will take precedence over the
.trap_action_set() callback when the user requests a change of all the
traps in a group.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 include/net/devlink.h | 10 ++++++++++
 net/core/devlink.c    | 18 ++++++++++++++++++
 2 files changed, 28 insertions(+)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index 20db4a070fc8..307937efa83a 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1226,6 +1226,16 @@ struct devlink_ops {
 			      const struct devlink_trap_group *group,
 			      const struct devlink_trap_policer *policer,
 			      struct netlink_ext_ack *extack);
+	/**
+	 * @trap_group_action_set: Group action set function.
+	 *
+	 * If this callback is populated, it will take precedence over looping
+	 * over all traps in a group and calling .trap_action_set().
+	 */
+	int (*trap_group_action_set)(struct devlink *devlink,
+				     const struct devlink_trap_group *group,
+				     enum devlink_trap_action action,
+				     struct netlink_ext_ack *extack);
 	/**
 	 * @trap_policer_init: Trap policer initialization function.
 	 *
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 10fea5854bc2..18136ad413e6 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -6720,6 +6720,24 @@ __devlink_trap_group_action_set(struct devlink *devlink,
 	struct devlink_trap_item *trap_item;
 	int err;
 
+	if (devlink->ops->trap_group_action_set) {
+		err = devlink->ops->trap_group_action_set(devlink, group_item->group,
+							  trap_action, extack);
+		if (err)
+			return err;
+
+		list_for_each_entry(trap_item, &devlink->trap_list, list) {
+			if (strcmp(trap_item->group_item->group->name, group_name))
+				continue;
+			if (trap_item->action != trap_action &&
+			    trap_item->trap->type != DEVLINK_TRAP_TYPE_DROP)
+				continue;
+			trap_item->action = trap_action;
+		}
+
+		return 0;
+	}
+
 	list_for_each_entry(trap_item, &devlink->trap_list, list) {
 		if (strcmp(trap_item->group_item->group->name, group_name))
 			continue;
-- 
2.28.0

