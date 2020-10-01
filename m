Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 636D528023B
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 17:12:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732522AbgJAPMB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 11:12:01 -0400
Received: from inva020.nxp.com ([92.121.34.13]:36040 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732462AbgJAPL7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Oct 2020 11:11:59 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id A72861A0B02;
        Thu,  1 Oct 2020 17:11:57 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 99E211A092F;
        Thu,  1 Oct 2020 17:11:57 +0200 (CEST)
Received: from fsr-ub1864-126.ea.freescale.net (fsr-ub1864-126.ea.freescale.net [10.171.82.212])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 54E8A20308;
        Thu,  1 Oct 2020 17:11:57 +0200 (CEST)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     jiri@nvidia.com, idosch@nvidia.com,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next v3 2/4] devlink: add .trap_group_action_set() callback
Date:   Thu,  1 Oct 2020 18:11:46 +0300
Message-Id: <20201001151148.18720-3-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201001151148.18720-1-ioana.ciornei@nxp.com>
References: <20201001151148.18720-1-ioana.ciornei@nxp.com>
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
Changes in v2:
 - none
Changes in v3:
 - reworded the trap_group_action_set() description

 include/net/devlink.h | 10 ++++++++++
 net/core/devlink.c    | 18 ++++++++++++++++++
 2 files changed, 28 insertions(+)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index 20db4a070fc8..6b00a624f2dc 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1226,6 +1226,16 @@ struct devlink_ops {
 			      const struct devlink_trap_group *group,
 			      const struct devlink_trap_policer *policer,
 			      struct netlink_ext_ack *extack);
+	/**
+	 * @trap_group_action_set: Trap group action set function.
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

