Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92CE1183A45
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 21:08:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727224AbgCLUII (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 16:08:08 -0400
Received: from mx2.suse.de ([195.135.220.15]:45260 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727133AbgCLUIF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Mar 2020 16:08:05 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id E1166AE44;
        Thu, 12 Mar 2020 20:08:03 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 8FC58E0C79; Thu, 12 Mar 2020 21:08:03 +0100 (CET)
Message-Id: <62c68681c338ae22b0d2924e9b8728f7858023d2.1584043144.git.mkubecek@suse.cz>
In-Reply-To: <cover.1584043144.git.mkubecek@suse.cz>
References: <cover.1584043144.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH net-next v2 06/15] ethtool: add FEATURES_NTF notification
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Jiri Pirko <jiri@resnulli.us>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Date:   Thu, 12 Mar 2020 21:08:03 +0100 (CET)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Send ETHTOOL_MSG_FEATURES_NTF notification whenever network device features
are modified using ETHTOOL_MSG_FEATURES_SET netlink message, ethtool ioctl
request or any other way resulting in call to netdev_update_features() or
netdev_change_features()

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 Documentation/networking/ethtool-netlink.rst |  6 ++++
 include/uapi/linux/ethtool_netlink.h         |  1 +
 net/ethtool/features.c                       |  4 +++
 net/ethtool/netlink.c                        | 29 +++++++++++++++++++-
 4 files changed, 39 insertions(+), 1 deletion(-)

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index d6706c4aa972..47542f042e9d 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -208,6 +208,7 @@ Kernel to userspace:
   ``ETHTOOL_MSG_WOL_NTF``               wake-on-lan settings notification
   ``ETHTOOL_MSG_FEATURES_GET_REPLY``    device features
   ``ETHTOOL_MSG_FEATURES_SET_REPLY``    optional reply to FEATURES_SET
+  ``ETHTOOL_MSG_FEATURES_NTF``          netdev features notification
   ===================================== =================================
 
 ``GET`` requests are sent by userspace applications to retrieve device
@@ -591,6 +592,11 @@ reports the difference between old and new dev->features: mask consists of
 bits which have changed, values are their values in new dev->features (after
 the operation).
 
+``ETHTOOL_MSG_FEATURES_NTF`` notification is sent not only if device features
+are modified using ``ETHTOOL_MSG_FEATURES_SET`` request or on of ethtool ioctl
+request but also each time features are modified with netdev_update_features()
+or netdev_change_features().
+
 
 Request translation
 ===================
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index 6f7aaa6b7f42..3d0204cf96a6 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -47,6 +47,7 @@ enum {
 	ETHTOOL_MSG_WOL_NTF,
 	ETHTOOL_MSG_FEATURES_GET_REPLY,
 	ETHTOOL_MSG_FEATURES_SET_REPLY,
+	ETHTOOL_MSG_FEATURES_NTF,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_KERNEL_CNT,
diff --git a/net/ethtool/features.c b/net/ethtool/features.c
index 4ac1e05684ce..4e632dc987d8 100644
--- a/net/ethtool/features.c
+++ b/net/ethtool/features.c
@@ -230,6 +230,7 @@ int ethnl_set_features(struct sk_buff *skb, struct genl_info *info)
 	struct nlattr *tb[ETHTOOL_A_FEATURES_MAX + 1];
 	struct ethnl_req_info req_info = {};
 	struct net_device *dev;
+	bool mod;
 	int ret;
 
 	ret = nlmsg_parse(info->nlhdr, GENL_HDRLEN, tb,
@@ -272,6 +273,7 @@ int ethnl_set_features(struct sk_buff *skb, struct genl_info *info)
 	dev->wanted_features = ethnl_bitmap_to_features(req_wanted);
 	__netdev_update_features(dev);
 	ethnl_features_to_bitmap(new_active, dev->features);
+	mod = !bitmap_equal(old_active, new_active, NETDEV_FEATURE_COUNT);
 
 	ret = 0;
 	if (!(req_info.flags & ETHTOOL_FLAG_OMIT_REPLY)) {
@@ -292,6 +294,8 @@ int ethnl_set_features(struct sk_buff *skb, struct genl_info *info)
 					  wanted_diff_mask, new_active,
 					  active_diff_mask, compact);
 	}
+	if (mod)
+		ethtool_notify(dev, ETHTOOL_MSG_FEATURES_NTF, NULL);
 
 out_rtnl:
 	rtnl_unlock();
diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index 757ea3fc98a0..5c0e361bfd66 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -528,6 +528,7 @@ ethnl_default_notify_ops[ETHTOOL_MSG_KERNEL_MAX + 1] = {
 	[ETHTOOL_MSG_LINKMODES_NTF]	= &ethnl_linkmodes_request_ops,
 	[ETHTOOL_MSG_DEBUG_NTF]		= &ethnl_debug_request_ops,
 	[ETHTOOL_MSG_WOL_NTF]		= &ethnl_wol_request_ops,
+	[ETHTOOL_MSG_FEATURES_NTF]	= &ethnl_features_request_ops,
 };
 
 /* default notification handler */
@@ -613,6 +614,7 @@ static const ethnl_notify_handler_t ethnl_notify_handlers[] = {
 	[ETHTOOL_MSG_LINKMODES_NTF]	= ethnl_default_notify,
 	[ETHTOOL_MSG_DEBUG_NTF]		= ethnl_default_notify,
 	[ETHTOOL_MSG_WOL_NTF]		= ethnl_default_notify,
+	[ETHTOOL_MSG_FEATURES_NTF]	= ethnl_default_notify,
 };
 
 void ethtool_notify(struct net_device *dev, unsigned int cmd, const void *data)
@@ -630,6 +632,29 @@ void ethtool_notify(struct net_device *dev, unsigned int cmd, const void *data)
 }
 EXPORT_SYMBOL(ethtool_notify);
 
+static void ethnl_notify_features(struct netdev_notifier_info *info)
+{
+	struct net_device *dev = netdev_notifier_info_to_dev(info);
+
+	ethtool_notify(dev, ETHTOOL_MSG_FEATURES_NTF, NULL);
+}
+
+static int ethnl_netdev_event(struct notifier_block *this, unsigned long event,
+			      void *ptr)
+{
+	switch (event) {
+	case NETDEV_FEAT_CHANGE:
+		ethnl_notify_features(ptr);
+		break;
+	}
+
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block ethnl_netdev_notifier = {
+	.notifier_call = ethnl_netdev_event,
+};
+
 /* genetlink setup */
 
 static const struct genl_ops ethtool_genl_ops[] = {
@@ -736,7 +761,9 @@ static int __init ethnl_init(void)
 		return ret;
 	ethnl_ok = true;
 
-	return 0;
+	ret = register_netdevice_notifier(&ethnl_netdev_notifier);
+	WARN(ret < 0, "ethtool: net device notifier registration failed");
+	return ret;
 }
 
 subsys_initcall(ethnl_init);
-- 
2.25.1

