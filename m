Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E4B5196CCC
	for <lists+netdev@lfdr.de>; Sun, 29 Mar 2020 13:06:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728108AbgC2LGE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Mar 2020 07:06:04 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:38084 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728075AbgC2LGC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Mar 2020 07:06:02 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from eranbe@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 29 Mar 2020 14:05:58 +0300
Received: from dev-l-vrt-198.mtl.labs.mlnx (dev-l-vrt-198.mtl.labs.mlnx [10.134.198.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 02TB5wVA006555;
        Sun, 29 Mar 2020 14:05:58 +0300
From:   Eran Ben Elisha <eranbe@mellanox.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@mellanox.com>
Cc:     Eran Ben Elisha <eranbe@mellanox.com>
Subject: [PATCH net-next v2 3/3] devlink: Add auto dump flag to health reporter
Date:   Sun, 29 Mar 2020 14:05:55 +0300
Message-Id: <1585479955-29828-4-git-send-email-eranbe@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1585479955-29828-1-git-send-email-eranbe@mellanox.com>
References: <1585479955-29828-1-git-send-email-eranbe@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On low memory system, run time dumps can consume too much memory. Add
administrator ability to disable auto dumps per reporter as part of the
error flow handle routine.

This attribute is not relevant while executing
DEVLINK_CMD_HEALTH_REPORTER_DUMP_GET.

By default, auto dump is activated for any reporter that has a dump method,
as part of the reporter registration to devlink.

Signed-off-by: Eran Ben Elisha <eranbe@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 include/uapi/linux/devlink.h |  2 ++
 net/core/devlink.c           | 26 ++++++++++++++++++++++----
 2 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index dfdffc42e87d..e7891d1d2ebd 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -429,6 +429,8 @@ enum devlink_attr {
 	DEVLINK_ATTR_NETNS_FD,			/* u32 */
 	DEVLINK_ATTR_NETNS_PID,			/* u32 */
 	DEVLINK_ATTR_NETNS_ID,			/* u32 */
+
+	DEVLINK_ATTR_HEALTH_REPORTER_AUTO_DUMP,	/* u8 */
 	/* add new attributes above here, update the policy in devlink.c */
 
 	__DEVLINK_ATTR_MAX,
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 0763b0494401..1caa43a7fba4 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -5089,6 +5089,7 @@ struct devlink_health_reporter {
 	struct mutex dump_lock; /* lock parallel read/write from dump buffers */
 	u64 graceful_period;
 	bool auto_recover;
+	bool auto_dump;
 	u8 health_state;
 	u64 dump_ts;
 	u64 dump_real_ts;
@@ -5155,6 +5156,7 @@ devlink_health_reporter_create(struct devlink *devlink,
 	reporter->devlink = devlink;
 	reporter->graceful_period = graceful_period;
 	reporter->auto_recover = !!ops->recover;
+	reporter->auto_dump = !!ops->dump;
 	mutex_init(&reporter->dump_lock);
 	refcount_set(&reporter->refcount, 1);
 	list_add_tail(&reporter->list, &devlink->reporter_list);
@@ -5235,6 +5237,10 @@ devlink_nl_health_reporter_fill(struct sk_buff *msg,
 	    nla_put_u64_64bit(msg, DEVLINK_ATTR_HEALTH_REPORTER_DUMP_TS_NS,
 			      reporter->dump_real_ts, DEVLINK_ATTR_PAD))
 		goto reporter_nest_cancel;
+	if (reporter->ops->dump &&
+	    nla_put_u8(msg, DEVLINK_ATTR_HEALTH_REPORTER_AUTO_DUMP,
+		       reporter->auto_dump))
+		goto reporter_nest_cancel;
 
 	nla_nest_end(msg, reporter_attr);
 	genlmsg_end(msg, hdr);
@@ -5381,10 +5387,12 @@ int devlink_health_report(struct devlink_health_reporter *reporter,
 
 	reporter->health_state = DEVLINK_HEALTH_REPORTER_STATE_ERROR;
 
-	mutex_lock(&reporter->dump_lock);
-	/* store current dump of current error, for later analysis */
-	devlink_health_do_dump(reporter, priv_ctx, NULL);
-	mutex_unlock(&reporter->dump_lock);
+	if (reporter->auto_dump) {
+		mutex_lock(&reporter->dump_lock);
+		/* store current dump of current error, for later analysis */
+		devlink_health_do_dump(reporter, priv_ctx, NULL);
+		mutex_unlock(&reporter->dump_lock);
+	}
 
 	if (reporter->auto_recover)
 		return devlink_health_reporter_recover(reporter,
@@ -5558,6 +5566,11 @@ devlink_nl_cmd_health_reporter_set_doit(struct sk_buff *skb,
 		err = -EOPNOTSUPP;
 		goto out;
 	}
+	if (!reporter->ops->dump &&
+	    info->attrs[DEVLINK_ATTR_HEALTH_REPORTER_AUTO_DUMP]) {
+		err = -EOPNOTSUPP;
+		goto out;
+	}
 
 	if (info->attrs[DEVLINK_ATTR_HEALTH_REPORTER_GRACEFUL_PERIOD])
 		reporter->graceful_period =
@@ -5567,6 +5580,10 @@ devlink_nl_cmd_health_reporter_set_doit(struct sk_buff *skb,
 		reporter->auto_recover =
 			nla_get_u8(info->attrs[DEVLINK_ATTR_HEALTH_REPORTER_AUTO_RECOVER]);
 
+	if (info->attrs[DEVLINK_ATTR_HEALTH_REPORTER_AUTO_DUMP])
+		reporter->auto_dump =
+		nla_get_u8(info->attrs[DEVLINK_ATTR_HEALTH_REPORTER_AUTO_DUMP]);
+
 	devlink_health_reporter_put(reporter);
 	return 0;
 out:
@@ -6313,6 +6330,7 @@ static const struct nla_policy devlink_nl_policy[DEVLINK_ATTR_MAX + 1] = {
 	[DEVLINK_ATTR_NETNS_PID] = { .type = NLA_U32 },
 	[DEVLINK_ATTR_NETNS_FD] = { .type = NLA_U32 },
 	[DEVLINK_ATTR_NETNS_ID] = { .type = NLA_U32 },
+	[DEVLINK_ATTR_HEALTH_REPORTER_AUTO_DUMP] = { .type = NLA_U8 },
 };
 
 static const struct genl_ops devlink_nl_ops[] = {
-- 
2.17.1

