Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2ABE0192996
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 14:27:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727356AbgCYN1B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 09:27:01 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:38211 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727027AbgCYN1B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 09:27:01 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from eranbe@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 25 Mar 2020 15:26:58 +0200
Received: from dev-l-vrt-198.mtl.labs.mlnx (dev-l-vrt-198.mtl.labs.mlnx [10.134.198.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 02PDQwW5010156;
        Wed, 25 Mar 2020 15:26:58 +0200
From:   Eran Ben Elisha <eranbe@mellanox.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@mellanox.com>
Cc:     Eran Ben Elisha <eranbe@mellanox.com>
Subject: [PATCH net-next 2/2] devlink: Add auto dump flag to health reporter
Date:   Wed, 25 Mar 2020 15:26:24 +0200
Message-Id: <1585142784-10517-3-git-send-email-eranbe@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1585142784-10517-1-git-send-email-eranbe@mellanox.com>
References: <1585142784-10517-1-git-send-email-eranbe@mellanox.com>
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
index ad69379747ef..e14bf3052289 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -4837,6 +4837,7 @@ struct devlink_health_reporter {
 	struct mutex dump_lock; /* lock parallel read/write from dump buffers */
 	u64 graceful_period;
 	bool auto_recover;
+	bool auto_dump;
 	u8 health_state;
 	u64 dump_ts;
 	u64 dump_real_ts;
@@ -4903,6 +4904,7 @@ devlink_health_reporter_create(struct devlink *devlink,
 	reporter->devlink = devlink;
 	reporter->graceful_period = graceful_period;
 	reporter->auto_recover = !!ops->recover;
+	reporter->auto_dump = !!ops->dump;
 	mutex_init(&reporter->dump_lock);
 	refcount_set(&reporter->refcount, 1);
 	list_add_tail(&reporter->list, &devlink->reporter_list);
@@ -4983,6 +4985,10 @@ devlink_nl_health_reporter_fill(struct sk_buff *msg,
 	    nla_put_u64_64bit(msg, DEVLINK_ATTR_HEALTH_REPORTER_DUMP_TS_NS,
 			      reporter->dump_real_ts, DEVLINK_ATTR_PAD))
 		goto reporter_nest_cancel;
+	if (reporter->ops->dump &&
+	    nla_put_u8(msg, DEVLINK_ATTR_HEALTH_REPORTER_AUTO_DUMP,
+		       reporter->auto_dump))
+		goto reporter_nest_cancel;
 
 	nla_nest_end(msg, reporter_attr);
 	genlmsg_end(msg, hdr);
@@ -5129,10 +5135,12 @@ int devlink_health_report(struct devlink_health_reporter *reporter,
 
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
@@ -5306,6 +5314,11 @@ devlink_nl_cmd_health_reporter_set_doit(struct sk_buff *skb,
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
@@ -5315,6 +5328,10 @@ devlink_nl_cmd_health_reporter_set_doit(struct sk_buff *skb,
 		reporter->auto_recover =
 			nla_get_u8(info->attrs[DEVLINK_ATTR_HEALTH_REPORTER_AUTO_RECOVER]);
 
+	if (info->attrs[DEVLINK_ATTR_HEALTH_REPORTER_AUTO_DUMP])
+		reporter->auto_dump =
+		nla_get_u8(info->attrs[DEVLINK_ATTR_HEALTH_REPORTER_AUTO_DUMP]);
+
 	devlink_health_reporter_put(reporter);
 	return 0;
 out:
@@ -6053,6 +6070,7 @@ static const struct nla_policy devlink_nl_policy[DEVLINK_ATTR_MAX + 1] = {
 	[DEVLINK_ATTR_HEALTH_REPORTER_NAME] = { .type = NLA_NUL_STRING },
 	[DEVLINK_ATTR_HEALTH_REPORTER_GRACEFUL_PERIOD] = { .type = NLA_U64 },
 	[DEVLINK_ATTR_HEALTH_REPORTER_AUTO_RECOVER] = { .type = NLA_U8 },
+	[DEVLINK_ATTR_HEALTH_REPORTER_AUTO_DUMP] = { .type = NLA_U8 },
 	[DEVLINK_ATTR_FLASH_UPDATE_FILE_NAME] = { .type = NLA_NUL_STRING },
 	[DEVLINK_ATTR_FLASH_UPDATE_COMPONENT] = { .type = NLA_NUL_STRING },
 	[DEVLINK_ATTR_TRAP_NAME] = { .type = NLA_NUL_STRING },
-- 
2.17.1

