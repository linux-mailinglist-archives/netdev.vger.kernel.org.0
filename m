Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2D2F183A55
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 21:09:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727297AbgCLUIU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 16:08:20 -0400
Received: from mx2.suse.de ([195.135.220.15]:45350 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727272AbgCLUIQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Mar 2020 16:08:16 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id EEE6DAE8A;
        Thu, 12 Mar 2020 20:08:13 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 9CE44E0C79; Thu, 12 Mar 2020 21:08:13 +0100 (CET)
Message-Id: <d8190437460d422e8156ead5510e4269804f6fb2.1584043144.git.mkubecek@suse.cz>
In-Reply-To: <cover.1584043144.git.mkubecek@suse.cz>
References: <cover.1584043144.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH net-next v2 08/15] ethtool: set device private flags with
 PRIVFLAGS_SET request
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Jiri Pirko <jiri@resnulli.us>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Date:   Thu, 12 Mar 2020 21:08:13 +0100 (CET)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement PRIVFLAGS_SET netlink request to set private flags of a network
device. These are traditionally set with ETHTOOL_SPFLAGS ioctl request.

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
Reviewed-by: Jakub Kicinski <kuba@kernel.org>
---
 Documentation/networking/ethtool-netlink.rst | 21 +++++-
 include/uapi/linux/ethtool_netlink.h         |  1 +
 net/ethtool/netlink.c                        |  5 ++
 net/ethtool/netlink.h                        |  1 +
 net/ethtool/privflags.c                      | 70 ++++++++++++++++++++
 5 files changed, 97 insertions(+), 1 deletion(-)

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index 7bba4c940ef7..e553112fa2d7 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -192,6 +192,7 @@ Userspace to kernel:
   ``ETHTOOL_MSG_FEATURES_GET``          get device features
   ``ETHTOOL_MSG_FEATURES_SET``          set device features
   ``ETHTOOL_MSG_PRIVFLAGS_GET``         get private flags
+  ``ETHTOOL_MSG_PRIVFLAGS_SET``         set private flags
   ===================================== ================================
 
 Kernel to userspace:
@@ -211,6 +212,7 @@ Kernel to userspace:
   ``ETHTOOL_MSG_FEATURES_SET_REPLY``    optional reply to FEATURES_SET
   ``ETHTOOL_MSG_FEATURES_NTF``          netdev features notification
   ``ETHTOOL_MSG_PRIVFLAGS_GET_REPLY``   private flags
+  ``ETHTOOL_MSG_PRIVFLAGS_NTF``         private flags
   ===================================== =================================
 
 ``GET`` requests are sent by userspace applications to retrieve device
@@ -626,6 +628,23 @@ response uses all private flags supported by the device as mask so that client
 gets the full information without having to fetch the string set with names.
 
 
+PRIVFLAGS_SET
+=============
+
+Sets or modifies values of device private flags like ``ETHTOOL_SPFLAGS``
+ioctl request.
+
+Request contents:
+
+  ====================================  ======  ==========================
+  ``ETHTOOL_A_PRIVFLAGS_HEADER``        nested  request header
+  ``ETHTOOL_A_PRIVFLAGS_FLAGS``         bitset  private flags
+  ====================================  ======  ==========================
+
+``ETHTOOL_A_PRIVFLAGS_FLAGS`` can either set the whole set of private flags or
+modify only values of some of them.
+
+
 Request translation
 ===================
 
@@ -676,7 +695,7 @@ have their netlink replacement yet.
   ``ETHTOOL_GFLAGS``                  ``ETHTOOL_MSG_FEATURES_GET``
   ``ETHTOOL_SFLAGS``                  ``ETHTOOL_MSG_FEATURES_SET``
   ``ETHTOOL_GPFLAGS``                 ``ETHTOOL_MSG_PRIVFLAGS_GET``
-  ``ETHTOOL_SPFLAGS``                 n/a
+  ``ETHTOOL_SPFLAGS``                 ``ETHTOOL_MSG_PRIVFLAGS_SET``
   ``ETHTOOL_GRXFH``                   n/a
   ``ETHTOOL_SRXFH``                   n/a
   ``ETHTOOL_GGRO``                    ``ETHTOOL_MSG_FEATURES_GET``
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index d94bbf5e4d1c..13e631c86825 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -27,6 +27,7 @@ enum {
 	ETHTOOL_MSG_FEATURES_GET,
 	ETHTOOL_MSG_FEATURES_SET,
 	ETHTOOL_MSG_PRIVFLAGS_GET,
+	ETHTOOL_MSG_PRIVFLAGS_SET,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_USER_CNT,
diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index 9cbb1d8b4d23..b6795aad7ccb 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -741,6 +741,11 @@ static const struct genl_ops ethtool_genl_ops[] = {
 		.dumpit	= ethnl_default_dumpit,
 		.done	= ethnl_default_done,
 	},
+	{
+		.cmd	= ETHTOOL_MSG_PRIVFLAGS_SET,
+		.flags	= GENL_UNS_ADMIN_PERM,
+		.doit	= ethnl_set_privflags,
+	},
 };
 
 static const struct genl_multicast_group ethtool_nl_mcgrps[] = {
diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
index 36cf077c3085..ca789f587ef3 100644
--- a/net/ethtool/netlink.h
+++ b/net/ethtool/netlink.h
@@ -345,5 +345,6 @@ int ethnl_set_linkmodes(struct sk_buff *skb, struct genl_info *info);
 int ethnl_set_debug(struct sk_buff *skb, struct genl_info *info);
 int ethnl_set_wol(struct sk_buff *skb, struct genl_info *info);
 int ethnl_set_features(struct sk_buff *skb, struct genl_info *info);
+int ethnl_set_privflags(struct sk_buff *skb, struct genl_info *info);
 
 #endif /* _NET_ETHTOOL_NETLINK_H */
diff --git a/net/ethtool/privflags.c b/net/ethtool/privflags.c
index 169dd4a832f6..dfa76d552277 100644
--- a/net/ethtool/privflags.c
+++ b/net/ethtool/privflags.c
@@ -134,3 +134,73 @@ const struct ethnl_request_ops ethnl_privflags_request_ops = {
 	.fill_reply		= privflags_fill_reply,
 	.cleanup_data		= privflags_cleanup_data,
 };
+
+/* PRIVFLAGS_SET */
+
+static const struct nla_policy
+privflags_set_policy[ETHTOOL_A_PRIVFLAGS_MAX + 1] = {
+	[ETHTOOL_A_PRIVFLAGS_UNSPEC]		= { .type = NLA_REJECT },
+	[ETHTOOL_A_PRIVFLAGS_HEADER]		= { .type = NLA_NESTED },
+	[ETHTOOL_A_PRIVFLAGS_FLAGS]		= { .type = NLA_NESTED },
+};
+
+int ethnl_set_privflags(struct sk_buff *skb, struct genl_info *info)
+{
+	struct nlattr *tb[ETHTOOL_A_PRIVFLAGS_MAX + 1];
+	const char (*names)[ETH_GSTRING_LEN] = NULL;
+	struct ethnl_req_info req_info = {};
+	const struct ethtool_ops *ops;
+	struct net_device *dev;
+	unsigned int nflags;
+	bool mod = false;
+	bool compact;
+	u32 flags;
+	int ret;
+
+	ret = nlmsg_parse(info->nlhdr, GENL_HDRLEN, tb,
+			  ETHTOOL_A_PRIVFLAGS_MAX, privflags_set_policy,
+			  info->extack);
+	if (ret < 0)
+		return ret;
+	if (!tb[ETHTOOL_A_PRIVFLAGS_FLAGS])
+		return -EINVAL;
+	ret = ethnl_bitset_is_compact(tb[ETHTOOL_A_PRIVFLAGS_FLAGS], &compact);
+	if (ret < 0)
+		return ret;
+	ret = ethnl_parse_header_dev_get(&req_info,
+					 tb[ETHTOOL_A_PRIVFLAGS_HEADER],
+					 genl_info_net(info), info->extack,
+					 true);
+	if (ret < 0)
+		return ret;
+	dev = req_info.dev;
+	ops = dev->ethtool_ops;
+	if (!ops->get_priv_flags || !ops->set_priv_flags ||
+	    !ops->get_sset_count || !ops->get_strings)
+		return -EOPNOTSUPP;
+
+	rtnl_lock();
+	ret = ethnl_ops_begin(dev);
+	if (ret < 0)
+		goto out_rtnl;
+	ret = ethnl_get_priv_flags_info(dev, &nflags, compact ? NULL : &names);
+	if (ret < 0)
+		goto out_ops;
+	flags = ops->get_priv_flags(dev);
+
+	ret = ethnl_update_bitset32(&flags, nflags,
+				    tb[ETHTOOL_A_PRIVFLAGS_FLAGS], names,
+				    info->extack, &mod);
+	if (ret < 0 || !mod)
+		goto out_free;
+	ret = ops->set_priv_flags(dev, flags);
+
+out_free:
+	kfree(names);
+out_ops:
+	ethnl_ops_complete(dev);
+out_rtnl:
+	rtnl_unlock();
+	dev_put(dev);
+	return ret;
+}
-- 
2.25.1

