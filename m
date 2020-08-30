Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E191256F0E
	for <lists+netdev@lfdr.de>; Sun, 30 Aug 2020 17:29:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727008AbgH3P3C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Aug 2020 11:29:02 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:42716 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726508AbgH3P2E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Aug 2020 11:28:04 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from moshe@mellanox.com)
        with SMTP; 30 Aug 2020 18:27:54 +0300
Received: from dev-l-vrt-135.mtl.labs.mlnx (dev-l-vrt-135.mtl.labs.mlnx [10.234.135.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 07UFRsfk029625;
        Sun, 30 Aug 2020 18:27:54 +0300
Received: from dev-l-vrt-135.mtl.labs.mlnx (localhost [127.0.0.1])
        by dev-l-vrt-135.mtl.labs.mlnx (8.15.2/8.15.2/Debian-10) with ESMTP id 07UFRsiE027832;
        Sun, 30 Aug 2020 18:27:54 +0300
Received: (from moshe@localhost)
        by dev-l-vrt-135.mtl.labs.mlnx (8.15.2/8.15.2/Submit) id 07UFRsih027831;
        Sun, 30 Aug 2020 18:27:54 +0300
From:   Moshe Shemesh <moshe@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Moshe Shemesh <moshe@mellanox.com>
Subject: [PATCH net-next RFC v3 03/14] devlink: Add reload actions counters to dev get
Date:   Sun, 30 Aug 2020 18:27:23 +0300
Message-Id: <1598801254-27764-4-git-send-email-moshe@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1598801254-27764-1-git-send-email-moshe@mellanox.com>
References: <1598801254-27764-1-git-send-email-moshe@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Expose devlink reload actions counters to the user through devlink dev
get command.

Examples:
$ devlink dev show
pci/0000:82:00.0:
  reload_actions_stats:
    driver_reinit 2
    fw_activate 1
    fw_activate_no_reset 0
pci/0000:82:00.1:
  reload_actions_stats:
    driver_reinit 1
    fw_activate 1
    fw_activate_no_reset 0

$ devlink dev show -jp
{
    "dev": {
        "pci/0000:82:00.0": {
            "reload_actions_stats": [ {
                    "driver_reinit": 2
                },{
                    "fw_activate": 1
                },{
                    "fw_activate_no_reset": 0
                } ]
        },
        "pci/0000:82:00.1": {
            "reload_actions_stats": [ {
                    "driver_reinit": 1
                },{
                    "fw_activate": 1
                },{
                    "fw_activate_no_reset": 0
                } ]
        }
    }
}

Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
---
v2 -> v3:
- Add reload actions counters instead of supported reload actions
  (reload actions counters are only for supported action so no need for
   both)
v1 -> v2:
- Removed DEVLINK_ATTR_RELOAD_DEFAULT_LEVEL
- Removed DEVLINK_ATTR_RELOAD_LEVELS_INFO
- Have actions instead of levels
---
 include/uapi/linux/devlink.h |  3 +++
 net/core/devlink.c           | 37 +++++++++++++++++++++++++++++++-----
 2 files changed, 35 insertions(+), 5 deletions(-)

diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index 0a438135c3cf..fd7667c78417 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -478,6 +478,9 @@ enum devlink_attr {
 
 	DEVLINK_ATTR_RELOAD_ACTION,		/* u8 */
 	DEVLINK_ATTR_RELOAD_ACTIONS_DONE,	/* nested */
+	DEVLINK_ATTR_RELOAD_ACTION_CNT_VALUE,	/* u32 */
+	DEVLINK_ATTR_RELOAD_ACTION_CNT,		/* nested */
+	DEVLINK_ATTR_RELOAD_ACTIONS_CNTS,	/* nested */
 
 	/* add new attributes above here, update the policy in devlink.c */
 
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 20a29c34ff71..962b14295380 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -462,6 +462,11 @@ static int devlink_nl_put_handle(struct sk_buff *msg, struct devlink *devlink)
 	return 0;
 }
 
+static bool devlink_reload_supported(struct devlink *devlink)
+{
+	return devlink->ops->reload_down && devlink->ops->reload_up;
+}
+
 static bool
 devlink_reload_action_is_supported(struct devlink *devlink, enum devlink_reload_action action)
 {
@@ -472,7 +477,9 @@ static int devlink_nl_fill(struct sk_buff *msg, struct devlink *devlink,
 			   enum devlink_command cmd, u32 portid,
 			   u32 seq, int flags)
 {
+	struct nlattr *reload_actions_cnts, *reload_action_cnt;
 	void *hdr;
+	int i;
 
 	hdr = genlmsg_put(msg, portid, seq, &devlink_nl_family, flags, cmd);
 	if (!hdr)
@@ -483,9 +490,34 @@ static int devlink_nl_fill(struct sk_buff *msg, struct devlink *devlink,
 	if (nla_put_u8(msg, DEVLINK_ATTR_RELOAD_FAILED, devlink->reload_failed))
 		goto nla_put_failure;
 
+	if (devlink_reload_supported(devlink)) {
+		reload_actions_cnts = nla_nest_start(msg, DEVLINK_ATTR_RELOAD_ACTIONS_CNTS);
+		if (!reload_actions_cnts)
+			goto nla_put_failure;
+
+		for (i = 0; i <= DEVLINK_RELOAD_ACTION_MAX; i++) {
+			if (!devlink_reload_action_is_supported(devlink, i))
+				continue;
+			reload_action_cnt = nla_nest_start(msg, DEVLINK_ATTR_RELOAD_ACTION_CNT);
+			if (!reload_action_cnt)
+				goto reload_actions_cnts_nest_cancel;
+			if (nla_put_u8(msg, DEVLINK_ATTR_RELOAD_ACTION, i))
+				goto reload_action_cnt_nest_cancel;
+			if (nla_put_u8(msg, DEVLINK_ATTR_RELOAD_ACTION_CNT_VALUE,
+				       devlink->reload_actions_cnts[i]))
+				goto reload_action_cnt_nest_cancel;
+			nla_nest_end(msg, reload_action_cnt);
+		}
+		nla_nest_end(msg, reload_actions_cnts);
+	}
+
 	genlmsg_end(msg, hdr);
 	return 0;
 
+reload_action_cnt_nest_cancel:
+	nla_nest_cancel(msg, reload_action_cnt);
+reload_actions_cnts_nest_cancel:
+	nla_nest_cancel(msg, reload_actions_cnts);
 nla_put_failure:
 	genlmsg_cancel(msg, hdr);
 	return -EMSGSIZE;
@@ -2949,11 +2981,6 @@ static void devlink_reload_netns_change(struct devlink *devlink,
 				     DEVLINK_CMD_PARAM_NEW);
 }
 
-static bool devlink_reload_supported(const struct devlink *devlink)
-{
-	return devlink->ops->reload_down && devlink->ops->reload_up;
-}
-
 static void devlink_reload_failed_set(struct devlink *devlink,
 				      bool reload_failed)
 {
-- 
2.17.1

