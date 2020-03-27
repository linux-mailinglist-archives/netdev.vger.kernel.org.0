Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B63B1194DD1
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 01:12:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727869AbgC0AMU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 20:12:20 -0400
Received: from mx2.suse.de ([195.135.220.15]:42638 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727509AbgC0AMU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Mar 2020 20:12:20 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 49D16B1E3;
        Fri, 27 Mar 2020 00:12:18 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id E6C24E00A5; Fri, 27 Mar 2020 01:12:17 +0100 (CET)
Message-Id: <a85d82a963f8d6fe0a180bbfaa65f9bd431915ed.1585267388.git.mkubecek@suse.cz>
In-Reply-To: <cover.1585267388.git.mkubecek@suse.cz>
References: <cover.1585267388.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH net-next 06/12] ethtool: set pause parameters with PAUSE_SET
 request
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Jiri Pirko <jiri@resnulli.us>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Date:   Fri, 27 Mar 2020 01:12:17 +0100 (CET)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement PAUSE_SET netlink request to set pause parameters of a network
device. Thease are traditionally set with ETHTOOL_SPAUSEPARAM ioctl
request.

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 Documentation/networking/ethtool-netlink.rst |  3 +-
 include/uapi/linux/ethtool_netlink.h         |  1 +
 net/ethtool/netlink.c                        |  5 ++
 net/ethtool/netlink.h                        |  1 +
 net/ethtool/pause.c                          | 61 ++++++++++++++++++++
 5 files changed, 70 insertions(+), 1 deletion(-)

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index 43c7baf36b32..dc7b3fe47f37 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -200,6 +200,7 @@ Userspace to kernel:
   ``ETHTOOL_MSG_COALESCE_GET``          get coalescing parameters
   ``ETHTOOL_MSG_COALESCE_SET``          set coalescing parameters
   ``ETHTOOL_MSG_PAUSE_GET``             get pause parameters
+  ``ETHTOOL_MSG_PAUSE_SET``             set pause parameters
   ===================================== ================================
 
 Kernel to userspace:
@@ -899,7 +900,7 @@ have their netlink replacement yet.
   ``ETHTOOL_GRINGPARAM``              ``ETHTOOL_MSG_RINGS_GET``
   ``ETHTOOL_SRINGPARAM``              ``ETHTOOL_MSG_RINGS_SET``
   ``ETHTOOL_GPAUSEPARAM``             ``ETHTOOL_MSG_PAUSE_GET``
-  ``ETHTOOL_SPAUSEPARAM``             n/a
+  ``ETHTOOL_SPAUSEPARAM``             ``ETHTOOL_MSG_PAUSE_SET``
   ``ETHTOOL_GRXCSUM``                 ``ETHTOOL_MSG_FEATURES_GET``
   ``ETHTOOL_SRXCSUM``                 ``ETHTOOL_MSG_FEATURES_SET``
   ``ETHTOOL_GTXCSUM``                 ``ETHTOOL_MSG_FEATURES_GET``
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index 1c8d1228f63f..a9a35c7b81d4 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -35,6 +35,7 @@ enum {
 	ETHTOOL_MSG_COALESCE_GET,
 	ETHTOOL_MSG_COALESCE_SET,
 	ETHTOOL_MSG_PAUSE_GET,
+	ETHTOOL_MSG_PAUSE_SET,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_USER_CNT,
diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index ca1695de8c9d..1ca30578e642 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -809,6 +809,11 @@ static const struct genl_ops ethtool_genl_ops[] = {
 		.dumpit	= ethnl_default_dumpit,
 		.done	= ethnl_default_done,
 	},
+	{
+		.cmd	= ETHTOOL_MSG_PAUSE_SET,
+		.flags	= GENL_UNS_ADMIN_PERM,
+		.doit	= ethnl_set_pause,
+	},
 };
 
 static const struct genl_multicast_group ethtool_nl_mcgrps[] = {
diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
index e14ac089bfb1..49fee19bc6aa 100644
--- a/net/ethtool/netlink.h
+++ b/net/ethtool/netlink.h
@@ -353,5 +353,6 @@ int ethnl_set_privflags(struct sk_buff *skb, struct genl_info *info);
 int ethnl_set_rings(struct sk_buff *skb, struct genl_info *info);
 int ethnl_set_channels(struct sk_buff *skb, struct genl_info *info);
 int ethnl_set_coalesce(struct sk_buff *skb, struct genl_info *info);
+int ethnl_set_pause(struct sk_buff *skb, struct genl_info *info);
 
 #endif /* _NET_ETHTOOL_NETLINK_H */
diff --git a/net/ethtool/pause.c b/net/ethtool/pause.c
index 9feafeb7bb1c..c307b91fdfba 100644
--- a/net/ethtool/pause.c
+++ b/net/ethtool/pause.c
@@ -79,3 +79,64 @@ const struct ethnl_request_ops ethnl_pause_request_ops = {
 	.reply_size		= pause_reply_size,
 	.fill_reply		= pause_fill_reply,
 };
+
+/* PAUSE_SET */
+
+static const struct nla_policy
+pause_set_policy[ETHTOOL_A_PAUSE_MAX + 1] = {
+	[ETHTOOL_A_PAUSE_UNSPEC]		= { .type = NLA_REJECT },
+	[ETHTOOL_A_PAUSE_HEADER]		= { .type = NLA_NESTED },
+	[ETHTOOL_A_PAUSE_AUTONEG]		= { .type = NLA_U8 },
+	[ETHTOOL_A_PAUSE_RX]			= { .type = NLA_U8 },
+	[ETHTOOL_A_PAUSE_TX]			= { .type = NLA_U8 },
+};
+
+int ethnl_set_pause(struct sk_buff *skb, struct genl_info *info)
+{
+	struct nlattr *tb[ETHTOOL_A_PAUSE_MAX + 1];
+	struct ethtool_pauseparam params = {};
+	struct ethnl_req_info req_info = {};
+	const struct ethtool_ops *ops;
+	struct net_device *dev;
+	bool mod = false;
+	int ret;
+
+	ret = nlmsg_parse(info->nlhdr, GENL_HDRLEN, tb, ETHTOOL_A_PAUSE_MAX,
+			  pause_set_policy, info->extack);
+	if (ret < 0)
+		return ret;
+	ret = ethnl_parse_header_dev_get(&req_info,
+					 tb[ETHTOOL_A_PAUSE_HEADER],
+					 genl_info_net(info), info->extack,
+					 true);
+	if (ret < 0)
+		return ret;
+	dev = req_info.dev;
+	ops = dev->ethtool_ops;
+	ret = -EOPNOTSUPP;
+	if (!ops->get_pauseparam || !ops->set_pauseparam)
+		goto out_dev;
+
+	rtnl_lock();
+	ret = ethnl_ops_begin(dev);
+	if (ret < 0)
+		goto out_rtnl;
+	ops->get_pauseparam(dev, &params);
+
+	ethnl_update_bool32(&params.autoneg, tb[ETHTOOL_A_PAUSE_AUTONEG], &mod);
+	ethnl_update_bool32(&params.rx_pause, tb[ETHTOOL_A_PAUSE_RX], &mod);
+	ethnl_update_bool32(&params.tx_pause, tb[ETHTOOL_A_PAUSE_TX], &mod);
+	ret = 0;
+	if (!mod)
+		goto out_ops;
+
+	ret = dev->ethtool_ops->set_pauseparam(dev, &params);
+
+out_ops:
+	ethnl_ops_complete(dev);
+out_rtnl:
+	rtnl_unlock();
+out_dev:
+	dev_put(dev);
+	return ret;
+}
-- 
2.25.1

