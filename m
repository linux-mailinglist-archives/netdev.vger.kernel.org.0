Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7F61149D41
	for <lists+netdev@lfdr.de>; Sun, 26 Jan 2020 23:11:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729107AbgAZWLK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jan 2020 17:11:10 -0500
Received: from mx2.suse.de ([195.135.220.15]:43638 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727493AbgAZWLJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 Jan 2020 17:11:09 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 0DBD2ADC5;
        Sun, 26 Jan 2020 22:11:08 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 8D0DAE06B1; Sun, 26 Jan 2020 23:11:07 +0100 (CET)
Message-Id: <844bf6bf518640fbfc67b5dd7976d9e8683c2d2d.1580075977.git.mkubecek@suse.cz>
In-Reply-To: <cover.1580075977.git.mkubecek@suse.cz>
References: <cover.1580075977.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH net-next 3/7] ethtool: set message mask with DEBUG_SET request
To:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@resnulli.us>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Date:   Sun, 26 Jan 2020 23:11:07 +0100 (CET)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement DEBUG_SET netlink request to set debugging settings for a device.
At the moment, only message mask corresponding to message level as set by
ETHTOOL_SMSGLVL ioctl request can be set. (It is called message level in
ioctl interface but almost all drivers interpret it as a bit mask.)

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 Documentation/networking/ethtool-netlink.rst | 20 +++++++-
 include/uapi/linux/ethtool_netlink.h         |  1 +
 net/ethtool/debug.c                          | 53 ++++++++++++++++++++
 net/ethtool/netlink.c                        |  5 ++
 net/ethtool/netlink.h                        |  1 +
 5 files changed, 79 insertions(+), 1 deletion(-)

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index 76a411d3102d..58473c05319f 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -186,6 +186,7 @@ Userspace to kernel:
   ``ETHTOOL_MSG_LINKMODES_SET``         set link modes info
   ``ETHTOOL_MSG_LINKSTATE_GET``         get link state
   ``ETHTOOL_MSG_DEBUG_GET``             get debugging settings
+  ``ETHTOOL_MSG_DEBUG_SET``             set debugging settings
   ===================================== ================================
 
 Kernel to userspace:
@@ -455,6 +456,23 @@ interface follows its actual use in practice.
 devices supporting the request).
 
 
+DEBUG_SET
+=========
+
+Set or update debugging settings of a device. At the moment, only message mask
+is supported.
+
+Request contents:
+
+  ====================================  ======  ==========================
+  ``ETHTOOL_A_DEBUG_HEADER``            nested  request header
+  ``ETHTOOL_A_DEBUG_MSGMASK``           bitset  message mask
+  ====================================  ======  ==========================
+
+``ETHTOOL_A_DEBUG_MSGMASK`` bit set allows setting or modifying mask of
+enabled debugging message types for the device.
+
+
 Request translation
 ===================
 
@@ -474,7 +492,7 @@ have their netlink replacement yet.
   ``ETHTOOL_GWOL``                    n/a
   ``ETHTOOL_SWOL``                    n/a
   ``ETHTOOL_GMSGLVL``                 ``ETHTOOL_MSG_DEBUG_GET``
-  ``ETHTOOL_SMSGLVL``                 n/a
+  ``ETHTOOL_SMSGLVL``                 ``ETHTOOL_MSG_DEBUG_SET``
   ``ETHTOOL_NWAY_RST``                n/a
   ``ETHTOOL_GLINK``                   ``ETHTOOL_MSG_LINKSTATE_GET``
   ``ETHTOOL_GEEPROM``                 n/a
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index 0d39e04567cb..8f0b6fd277d5 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -21,6 +21,7 @@ enum {
 	ETHTOOL_MSG_LINKMODES_SET,
 	ETHTOOL_MSG_LINKSTATE_GET,
 	ETHTOOL_MSG_DEBUG_GET,
+	ETHTOOL_MSG_DEBUG_SET,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_USER_CNT,
diff --git a/net/ethtool/debug.c b/net/ethtool/debug.c
index cc121a23be5f..6fc3ef8113c0 100644
--- a/net/ethtool/debug.c
+++ b/net/ethtool/debug.c
@@ -78,3 +78,56 @@ const struct ethnl_request_ops ethnl_debug_request_ops = {
 	.reply_size		= debug_reply_size,
 	.fill_reply		= debug_fill_reply,
 };
+
+/* DEBUG_SET */
+
+static const struct nla_policy
+debug_set_policy[ETHTOOL_A_DEBUG_MAX + 1] = {
+	[ETHTOOL_A_DEBUG_UNSPEC]	= { .type = NLA_REJECT },
+	[ETHTOOL_A_DEBUG_HEADER]	= { .type = NLA_NESTED },
+	[ETHTOOL_A_DEBUG_MSGMASK]	= { .type = NLA_NESTED },
+};
+
+int ethnl_set_debug(struct sk_buff *skb, struct genl_info *info)
+{
+	struct nlattr *tb[ETHTOOL_A_DEBUG_MAX + 1];
+	struct ethnl_req_info req_info = {};
+	struct net_device *dev;
+	bool mod = false;
+	u32 msg_mask;
+	int ret;
+
+	ret = nlmsg_parse(info->nlhdr, GENL_HDRLEN, tb,
+			  ETHTOOL_A_DEBUG_MAX, debug_set_policy,
+			  info->extack);
+	if (ret < 0)
+		return ret;
+	ret = ethnl_parse_header(&req_info, tb[ETHTOOL_A_DEBUG_HEADER],
+				 genl_info_net(info), info->extack, true);
+	if (ret < 0)
+		return ret;
+	dev = req_info.dev;
+	if (!dev->ethtool_ops->get_msglevel || !dev->ethtool_ops->set_msglevel)
+		return -EOPNOTSUPP;
+
+	rtnl_lock();
+	ret = ethnl_ops_begin(dev);
+	if (ret < 0)
+		goto out_rtnl;
+
+	msg_mask = dev->ethtool_ops->get_msglevel(dev);
+	ret = ethnl_update_bitset32(&msg_mask, NETIF_MSG_CLASS_COUNT,
+				    tb[ETHTOOL_A_DEBUG_MSGMASK],
+				    netif_msg_class_names, info->extack, &mod);
+	if (ret < 0 || !mod)
+		goto out_ops;
+
+	dev->ethtool_ops->set_msglevel(dev, msg_mask);
+
+out_ops:
+	ethnl_ops_complete(dev);
+out_rtnl:
+	rtnl_unlock();
+	dev_put(dev);
+	return ret;
+}
diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index bdaf583e392b..bcdc42e0bd14 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -672,6 +672,11 @@ static const struct genl_ops ethtool_genl_ops[] = {
 		.dumpit	= ethnl_default_dumpit,
 		.done	= ethnl_default_done,
 	},
+	{
+		.cmd	= ETHTOOL_MSG_DEBUG_SET,
+		.flags	= GENL_UNS_ADMIN_PERM,
+		.doit	= ethnl_set_debug,
+	},
 };
 
 static const struct genl_multicast_group ethtool_nl_mcgrps[] = {
diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
index 9bd8ef671501..772723e536e8 100644
--- a/net/ethtool/netlink.h
+++ b/net/ethtool/netlink.h
@@ -338,5 +338,6 @@ extern const struct ethnl_request_ops ethnl_debug_request_ops;
 
 int ethnl_set_linkinfo(struct sk_buff *skb, struct genl_info *info);
 int ethnl_set_linkmodes(struct sk_buff *skb, struct genl_info *info);
+int ethnl_set_debug(struct sk_buff *skb, struct genl_info *info);
 
 #endif /* _NET_ETHTOOL_NETLINK_H */
-- 
2.25.0

