Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B89815CEC8
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 13:50:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727113AbfGBLuR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 07:50:17 -0400
Received: from mx2.suse.de ([195.135.220.15]:38700 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727059AbfGBLuQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jul 2019 07:50:16 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 929D0B14A;
        Tue,  2 Jul 2019 11:50:14 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 413B1E0159; Tue,  2 Jul 2019 13:50:14 +0200 (CEST)
Message-Id: <4dcac81783de8686edefa262a1db75f9e961b123.1562067622.git.mkubecek@suse.cz>
In-Reply-To: <cover.1562067622.git.mkubecek@suse.cz>
References: <cover.1562067622.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH net-next v6 07/15] ethtool: support for netlink notifications
To:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jiri Pirko <jiri@resnulli.us>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Date:   Tue,  2 Jul 2019 13:50:14 +0200 (CEST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add infrastructure for ethtool netlink notifications. There is only one
multicast group "monitor" which is used to notify userspace about changes
and actions performed. Notification messages (types using suffix _NTF)
share the format with replies to GET requests.

Notifications are supposed to be broadcasted on every configuration change,
whether it is done using the netlink interface or ioctl one. Netlink SET
requests only trigger a notification if some data is actually changed.

To trigger an ethtool notification, both ethtool netlink and external code
use ethtool_notify() helper. This helper requires RTNL to be held and may
sleep. Handlers sending messages for specific notification message types
are registered in ethnl_notify_handlers array. As notifications can be
triggered from other code, ethnl_ok flag is used to prevent an attempt to
send notification before genetlink family is registered.

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 include/linux/ethtool_netlink.h      |  5 ++++
 include/linux/netdevice.h            | 12 ++++++++++
 include/uapi/linux/ethtool_netlink.h |  2 ++
 net/ethtool/netlink.c                | 35 ++++++++++++++++++++++++++++
 4 files changed, 54 insertions(+)

diff --git a/include/linux/ethtool_netlink.h b/include/linux/ethtool_netlink.h
index 0412adb4f42f..2a15e64a16f3 100644
--- a/include/linux/ethtool_netlink.h
+++ b/include/linux/ethtool_netlink.h
@@ -5,5 +5,10 @@
 
 #include <uapi/linux/ethtool_netlink.h>
 #include <linux/ethtool.h>
+#include <linux/netdevice.h>
+
+enum ethtool_multicast_groups {
+	ETHNL_MCGRP_MONITOR,
+};
 
 #endif /* _LINUX_ETHTOOL_NETLINK_H_ */
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 88292953aa6f..c57d9917fd50 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -4350,6 +4350,18 @@ struct netdev_notifier_bonding_info {
 void netdev_bonding_info_change(struct net_device *dev,
 				struct netdev_bonding_info *bonding_info);
 
+#if IS_ENABLED(CONFIG_ETHTOOL_NETLINK)
+void ethtool_notify(struct net_device *dev, struct netlink_ext_ack *extack,
+		    unsigned int cmd, u32 req_mask, const void *data);
+#else
+static inline void ethtool_notify(struct net_device *dev,
+				  struct netlink_ext_ack *extack,
+				  unsigned int cmd, u32 req_mask,
+				  const void *data)
+{
+}
+#endif
+
 static inline
 struct sk_buff *skb_gso_segment(struct sk_buff *skb, netdev_features_t features)
 {
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index 805f314f4454..8938a1f09057 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -91,4 +91,6 @@ enum {
 #define ETHTOOL_GENL_NAME "ethtool"
 #define ETHTOOL_GENL_VERSION 1
 
+#define ETHTOOL_MCGRP_MONITOR_NAME "monitor"
+
 #endif /* _UAPI_LINUX_ETHTOOL_NETLINK_H_ */
diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index e13f29bbd625..a7a0bfe1818c 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -6,6 +6,8 @@
 
 static struct genl_family ethtool_genl_family;
 
+static bool ethnl_ok __read_mostly;
+
 static const struct nla_policy dflt_header_policy[ETHTOOL_A_HEADER_MAX + 1] = {
 	[ETHTOOL_A_HEADER_UNSPEC]	= { .type = NLA_REJECT },
 	[ETHTOOL_A_HEADER_DEV_INDEX]	= { .type = NLA_U32 },
@@ -176,11 +178,41 @@ struct sk_buff *ethnl_reply_init(size_t payload, struct net_device *dev, u8 cmd,
 	return NULL;
 }
 
+/* notifications */
+
+typedef void (*ethnl_notify_handler_t)(struct net_device *dev,
+				       struct netlink_ext_ack *extack,
+				       unsigned int cmd, u32 req_mask,
+				       const void *data);
+
+static const ethnl_notify_handler_t ethnl_notify_handlers[] = {
+};
+
+void ethtool_notify(struct net_device *dev, struct netlink_ext_ack *extack,
+		    unsigned int cmd, u32 req_mask, const void *data)
+{
+	if (unlikely(!ethnl_ok))
+		return;
+	ASSERT_RTNL();
+
+	if (likely(cmd < ARRAY_SIZE(ethnl_notify_handlers) &&
+		   ethnl_notify_handlers[cmd]))
+		ethnl_notify_handlers[cmd](dev, extack, cmd, req_mask, data);
+	else
+		WARN_ONCE(1, "notification %u not implemented (dev=%s, req_mask=0x%x)\n",
+			  cmd, netdev_name(dev), req_mask);
+}
+EXPORT_SYMBOL(ethtool_notify);
+
 /* genetlink setup */
 
 static const struct genl_ops ethtool_genl_ops[] = {
 };
 
+static const struct genl_multicast_group ethtool_nl_mcgrps[] = {
+	[ETHNL_MCGRP_MONITOR] = { .name = ETHTOOL_MCGRP_MONITOR_NAME },
+};
+
 static struct genl_family ethtool_genl_family = {
 	.name		= ETHTOOL_GENL_NAME,
 	.version	= ETHTOOL_GENL_VERSION,
@@ -188,6 +220,8 @@ static struct genl_family ethtool_genl_family = {
 	.parallel_ops	= true,
 	.ops		= ethtool_genl_ops,
 	.n_ops		= ARRAY_SIZE(ethtool_genl_ops),
+	.mcgrps		= ethtool_nl_mcgrps,
+	.n_mcgrps	= ARRAY_SIZE(ethtool_nl_mcgrps),
 };
 
 /* module setup */
@@ -199,6 +233,7 @@ static int __init ethnl_init(void)
 	ret = genl_register_family(&ethtool_genl_family);
 	if (WARN(ret < 0, "ethtool: genetlink family registration failed"))
 		return ret;
+	ethnl_ok = true;
 
 	return 0;
 }
-- 
2.22.0

