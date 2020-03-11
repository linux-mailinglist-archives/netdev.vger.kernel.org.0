Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D3AE18240D
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 22:41:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729717AbgCKVlC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 17:41:02 -0400
Received: from mx2.suse.de ([195.135.220.15]:46854 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729656AbgCKVlB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Mar 2020 17:41:01 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id C8013AE52;
        Wed, 11 Mar 2020 21:40:58 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 77344E0C0A; Wed, 11 Mar 2020 22:40:58 +0100 (CET)
Message-Id: <ec91e4c53d75ec8e499ecaec36948674b2ef07cc.1583962006.git.mkubecek@suse.cz>
In-Reply-To: <cover.1583962006.git.mkubecek@suse.cz>
References: <cover.1583962006.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH net-next 11/15] ethtool: set device ring sizes with RINGS_SET
 request
To:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@resnulli.us>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Date:   Wed, 11 Mar 2020 22:40:58 +0100 (CET)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement RINGS_SET netlink request to set ring sizes of a network device.
These are traditionally set with ETHTOOL_SRINGPARAM ioctl request.

Like the ioctl implementation, the generic ethtool code checks if supplied
values do not exceed driver defined limits; if they do, first offending
attribute is reported using extack.

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 Documentation/networking/ethtool-netlink.rst | 23 +++++-
 include/uapi/linux/ethtool_netlink.h         |  1 +
 net/ethtool/netlink.c                        |  5 ++
 net/ethtool/netlink.h                        |  1 +
 net/ethtool/rings.c                          | 87 ++++++++++++++++++++
 5 files changed, 116 insertions(+), 1 deletion(-)

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index 798c2f97d89b..ba31ae8f1feb 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -194,6 +194,7 @@ Userspace to kernel:
   ``ETHTOOL_MSG_PRIVFLAGS_GET``         get private flags
   ``ETHTOOL_MSG_PRIVFLAGS_SET``         set private flags
   ``ETHTOOL_MSG_RINGS_GET``             get ring sizes
+  ``ETHTOOL_MSG_RINGS_SET``             set ring sizes
   ===================================== ================================
 
 Kernel to userspace:
@@ -673,6 +674,26 @@ Kernel response contents:
   ====================================  ======  ==========================
 
 
+RINGS_SET
+=========
+
+Sets ring sizes like ``ETHTOOL_SRINGPARAM`` ioctl request.
+
+Request contents:
+
+  ====================================  ======  ==========================
+  ``ETHTOOL_A_RINGS_HEADER``            nested  reply header
+  ``ETHTOOL_A_RINGS_RX``                u32     size of RX ring
+  ``ETHTOOL_A_RINGS_RX_MINI``           u32     size of RX mini ring
+  ``ETHTOOL_A_RINGS_RX_JUMBO``          u32     size of RX jumbo ring
+  ``ETHTOOL_A_RINGS_TX``                u32     size of TX ring
+  ====================================  ======  ==========================
+
+Kernel checks that requested ring sizes do not exceed limits reported by
+driver. Driver may impose additional constraints and may not suspport all
+attributes.
+
+
 Request translation
 ===================
 
@@ -700,7 +721,7 @@ have their netlink replacement yet.
   ``ETHTOOL_GCOALESCE``               n/a
   ``ETHTOOL_SCOALESCE``               n/a
   ``ETHTOOL_GRINGPARAM``              ``ETHTOOL_MSG_RINGS_GET``
-  ``ETHTOOL_SRINGPARAM``              n/a
+  ``ETHTOOL_SRINGPARAM``              ``ETHTOOL_MSG_RINGS_SET``
   ``ETHTOOL_GPAUSEPARAM``             n/a
   ``ETHTOOL_SPAUSEPARAM``             n/a
   ``ETHTOOL_GRXCSUM``                 ``ETHTOOL_MSG_FEATURES_GET``
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index 7cd220f8cf73..ae71801b7aac 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -29,6 +29,7 @@ enum {
 	ETHTOOL_MSG_PRIVFLAGS_GET,
 	ETHTOOL_MSG_PRIVFLAGS_SET,
 	ETHTOOL_MSG_RINGS_GET,
+	ETHTOOL_MSG_RINGS_SET,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_USER_CNT,
diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index 0dc25a490450..6a1ac8897a7e 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -756,6 +756,11 @@ static const struct genl_ops ethtool_genl_ops[] = {
 		.dumpit	= ethnl_default_dumpit,
 		.done	= ethnl_default_done,
 	},
+	{
+		.cmd	= ETHTOOL_MSG_RINGS_SET,
+		.flags	= GENL_UNS_ADMIN_PERM,
+		.doit	= ethnl_set_rings,
+	},
 };
 
 static const struct genl_multicast_group ethtool_nl_mcgrps[] = {
diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
index 01761932ed15..b30426d01890 100644
--- a/net/ethtool/netlink.h
+++ b/net/ethtool/netlink.h
@@ -347,5 +347,6 @@ int ethnl_set_debug(struct sk_buff *skb, struct genl_info *info);
 int ethnl_set_wol(struct sk_buff *skb, struct genl_info *info);
 int ethnl_set_features(struct sk_buff *skb, struct genl_info *info);
 int ethnl_set_privflags(struct sk_buff *skb, struct genl_info *info);
+int ethnl_set_rings(struct sk_buff *skb, struct genl_info *info);
 
 #endif /* _NET_ETHTOOL_NETLINK_H */
diff --git a/net/ethtool/rings.c b/net/ethtool/rings.c
index 945b2323daff..56e628456619 100644
--- a/net/ethtool/rings.c
+++ b/net/ethtool/rings.c
@@ -97,3 +97,90 @@ const struct ethnl_request_ops ethnl_rings_request_ops = {
 	.reply_size		= rings_reply_size,
 	.fill_reply		= rings_fill_reply,
 };
+
+/* RINGS_SET */
+
+static const struct nla_policy
+rings_set_policy[ETHTOOL_A_RINGS_MAX + 1] = {
+	[ETHTOOL_A_RINGS_UNSPEC]		= { .type = NLA_REJECT },
+	[ETHTOOL_A_RINGS_HEADER]		= { .type = NLA_NESTED },
+	[ETHTOOL_A_RINGS_RX_MAX]		= { .type = NLA_REJECT },
+	[ETHTOOL_A_RINGS_RX_MINI_MAX]		= { .type = NLA_REJECT },
+	[ETHTOOL_A_RINGS_RX_JUMBO_MAX]		= { .type = NLA_REJECT },
+	[ETHTOOL_A_RINGS_TX_MAX]		= { .type = NLA_REJECT },
+	[ETHTOOL_A_RINGS_RX]			= { .type = NLA_U32 },
+	[ETHTOOL_A_RINGS_RX_MINI]		= { .type = NLA_U32 },
+	[ETHTOOL_A_RINGS_RX_JUMBO]		= { .type = NLA_U32 },
+	[ETHTOOL_A_RINGS_TX]			= { .type = NLA_U32 },
+};
+
+int ethnl_set_rings(struct sk_buff *skb, struct genl_info *info)
+{
+	struct nlattr *tb[ETHTOOL_A_RINGS_MAX + 1];
+	struct ethtool_ringparam ringparam = {};
+	struct ethnl_req_info req_info = {};
+	const struct nlattr *err_attr;
+	const struct ethtool_ops *ops;
+	struct net_device *dev;
+	bool mod = false;
+	int ret;
+
+	ret = nlmsg_parse(info->nlhdr, GENL_HDRLEN, tb,
+			  ETHTOOL_A_RINGS_MAX, rings_set_policy,
+			  info->extack);
+	if (ret < 0)
+		return ret;
+	ret = ethnl_parse_header_dev_get(&req_info,
+					 tb[ETHTOOL_A_RINGS_HEADER],
+					 genl_info_net(info), info->extack,
+					 true);
+	if (ret < 0)
+		return ret;
+	dev = req_info.dev;
+	ops = dev->ethtool_ops;
+	if (!ops->get_ringparam || !ops->set_ringparam)
+		return -EOPNOTSUPP;
+
+	rtnl_lock();
+	ret = ethnl_ops_begin(dev);
+	if (ret < 0)
+		goto out_rtnl;
+	ops->get_ringparam(dev, &ringparam);
+
+	ethnl_update_u32(&ringparam.rx_pending, tb[ETHTOOL_A_RINGS_RX], &mod);
+	ethnl_update_u32(&ringparam.rx_mini_pending,
+			 tb[ETHTOOL_A_RINGS_RX_MINI], &mod);
+	ethnl_update_u32(&ringparam.rx_jumbo_pending,
+			 tb[ETHTOOL_A_RINGS_RX_JUMBO], &mod);
+	ethnl_update_u32(&ringparam.tx_pending, tb[ETHTOOL_A_RINGS_TX], &mod);
+	ret = 0;
+	if (!mod)
+		goto out_ops;
+
+	/* ensure new ring parameters are within limits */
+	if (ringparam.rx_pending > ringparam.rx_max_pending)
+		err_attr = tb[ETHTOOL_A_RINGS_RX];
+	else if (ringparam.rx_mini_pending > ringparam.rx_mini_max_pending)
+		err_attr = tb[ETHTOOL_A_RINGS_RX_MINI];
+	else if (ringparam.rx_jumbo_pending > ringparam.rx_jumbo_max_pending)
+		err_attr = tb[ETHTOOL_A_RINGS_RX_JUMBO];
+	else if (ringparam.tx_pending > ringparam.tx_max_pending)
+		err_attr = tb[ETHTOOL_A_RINGS_TX];
+	else
+		err_attr = NULL;
+	if (err_attr) {
+		ret = -EINVAL;
+		NL_SET_ERR_MSG_ATTR(info->extack, err_attr,
+				    "requested ring size exceeeds maximum");
+		goto out_ops;
+	}
+
+	ret = dev->ethtool_ops->set_ringparam(dev, &ringparam);
+
+out_ops:
+	ethnl_ops_complete(dev);
+out_rtnl:
+	rtnl_unlock();
+	dev_put(dev);
+	return ret;
+}
-- 
2.25.1

