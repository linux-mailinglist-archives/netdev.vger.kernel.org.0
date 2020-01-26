Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B31EA149D40
	for <lists+netdev@lfdr.de>; Sun, 26 Jan 2020 23:11:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729252AbgAZWLV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jan 2020 17:11:21 -0500
Received: from mx2.suse.de ([195.135.220.15]:43726 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729222AbgAZWLT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 Jan 2020 17:11:19 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id F13EEAE44;
        Sun, 26 Jan 2020 22:11:16 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id A0CFCE06B1; Sun, 26 Jan 2020 23:11:16 +0100 (CET)
Message-Id: <321016bdee1b2e5c4268808952f2ec2b8433ee67.1580075977.git.mkubecek@suse.cz>
In-Reply-To: <cover.1580075977.git.mkubecek@suse.cz>
References: <cover.1580075977.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH net-next 6/7] ethtool: set wake-on-lan settings with WOL_SET
 request
To:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@resnulli.us>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Date:   Sun, 26 Jan 2020 23:11:16 +0100 (CET)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement WOL_SET netlink request to set wake-on-lan settings. This is
equivalent to ETHTOOL_SWOL ioctl request.

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 Documentation/networking/ethtool-netlink.rst | 20 +++++-
 include/uapi/linux/ethtool_netlink.h         |  1 +
 net/ethtool/netlink.c                        |  5 ++
 net/ethtool/netlink.h                        |  1 +
 net/ethtool/wol.c                            | 76 ++++++++++++++++++++
 5 files changed, 102 insertions(+), 1 deletion(-)

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index 5fd85e3ea96e..f16f74bbb546 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -188,6 +188,7 @@ Userspace to kernel:
   ``ETHTOOL_MSG_DEBUG_GET``             get debugging settings
   ``ETHTOOL_MSG_DEBUG_SET``             set debugging settings
   ``ETHTOOL_MSG_WOL_GET``               get wake-on-lan settings
+  ``ETHTOOL_MSG_WOL_SET``               set wake-on-lan settings
   ===================================== ================================
 
 Kernel to userspace:
@@ -502,6 +503,23 @@ device, value of modes which are enabled. ``ETHTOOL_A_WOL_SOPASS`` is only
 included in reply if ``WAKE_MAGICSECURE`` mode is supported.
 
 
+WOL_SET
+=======
+
+Set or update wake-on-lan settings.
+
+Request contents:
+
+  ====================================  ======  ==========================
+  ``ETHTOOL_A_WOL_HEADER``              nested  request header
+  ``ETHTOOL_A_WOL_MODES``               bitset  enabled WoL modes
+  ``ETHTOOL_A_WOL_SOPASS``              binary  SecureOn(tm) password
+  ====================================  ======  ==========================
+
+``ETHTOOL_A_WOL_SOPASS`` is only allowed for devices supporting
+``WAKE_MAGICSECURE`` mode.
+
+
 Request translation
 ===================
 
@@ -519,7 +537,7 @@ have their netlink replacement yet.
   ``ETHTOOL_GDRVINFO``                n/a
   ``ETHTOOL_GREGS``                   n/a
   ``ETHTOOL_GWOL``                    ``ETHTOOL_MSG_WOL_GET``
-  ``ETHTOOL_SWOL``                    n/a
+  ``ETHTOOL_SWOL``                    ``ETHTOOL_MSG_WOL_SET``
   ``ETHTOOL_GMSGLVL``                 ``ETHTOOL_MSG_DEBUG_GET``
   ``ETHTOOL_SMSGLVL``                 ``ETHTOOL_MSG_DEBUG_SET``
   ``ETHTOOL_NWAY_RST``                n/a
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index dcc5c32dc018..59de35695521 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -23,6 +23,7 @@ enum {
 	ETHTOOL_MSG_DEBUG_GET,
 	ETHTOOL_MSG_DEBUG_SET,
 	ETHTOOL_MSG_WOL_GET,
+	ETHTOOL_MSG_WOL_SET,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_USER_CNT,
diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index eeb6d8594e1b..2c375f9095fe 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -688,6 +688,11 @@ static const struct genl_ops ethtool_genl_ops[] = {
 		.dumpit	= ethnl_default_dumpit,
 		.done	= ethnl_default_done,
 	},
+	{
+		.cmd	= ETHTOOL_MSG_WOL_SET,
+		.flags	= GENL_UNS_ADMIN_PERM,
+		.doit	= ethnl_set_wol,
+	},
 };
 
 static const struct genl_multicast_group ethtool_nl_mcgrps[] = {
diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
index 9fcd6f87b396..60efd87686ad 100644
--- a/net/ethtool/netlink.h
+++ b/net/ethtool/netlink.h
@@ -340,5 +340,6 @@ extern const struct ethnl_request_ops ethnl_wol_request_ops;
 int ethnl_set_linkinfo(struct sk_buff *skb, struct genl_info *info);
 int ethnl_set_linkmodes(struct sk_buff *skb, struct genl_info *info);
 int ethnl_set_debug(struct sk_buff *skb, struct genl_info *info);
+int ethnl_set_wol(struct sk_buff *skb, struct genl_info *info);
 
 #endif /* _NET_ETHTOOL_NETLINK_H */
diff --git a/net/ethtool/wol.c b/net/ethtool/wol.c
index 7c9a1ef622ce..a2724378fac4 100644
--- a/net/ethtool/wol.c
+++ b/net/ethtool/wol.c
@@ -97,3 +97,79 @@ const struct ethnl_request_ops ethnl_wol_request_ops = {
 	.reply_size		= wol_reply_size,
 	.fill_reply		= wol_fill_reply,
 };
+
+/* WOL_SET */
+
+static const struct nla_policy
+wol_set_policy[ETHTOOL_A_WOL_MAX + 1] = {
+	[ETHTOOL_A_WOL_UNSPEC]		= { .type = NLA_REJECT },
+	[ETHTOOL_A_WOL_HEADER]		= { .type = NLA_NESTED },
+	[ETHTOOL_A_WOL_MODES]		= { .type = NLA_NESTED },
+	[ETHTOOL_A_WOL_SOPASS]		= { .type = NLA_BINARY,
+					    .len = SOPASS_MAX },
+};
+
+int ethnl_set_wol(struct sk_buff *skb, struct genl_info *info)
+{
+	struct ethtool_wolinfo wol = { .cmd = ETHTOOL_GWOL };
+	struct nlattr *tb[ETHTOOL_A_WOL_MAX + 1];
+	struct ethnl_req_info req_info = {};
+	struct net_device *dev;
+	bool mod = false;
+	int ret;
+
+	ret = nlmsg_parse(info->nlhdr, GENL_HDRLEN, tb, ETHTOOL_A_WOL_MAX,
+			  wol_set_policy, info->extack);
+	if (ret < 0)
+		return ret;
+	ret = ethnl_parse_header(&req_info, tb[ETHTOOL_A_WOL_HEADER],
+				 genl_info_net(info), info->extack, true);
+	if (ret < 0)
+		return ret;
+	dev = req_info.dev;
+	if (!dev->ethtool_ops->get_wol || !dev->ethtool_ops->set_wol)
+		return -EOPNOTSUPP;
+
+	rtnl_lock();
+	ret = ethnl_ops_begin(dev);
+	if (ret < 0)
+		goto out_rtnl;
+
+	dev->ethtool_ops->get_wol(dev, &wol);
+	ret = ethnl_update_bitset32(&wol.wolopts, WOL_MODE_COUNT,
+				    tb[ETHTOOL_A_WOL_MODES], wol_mode_names,
+				    info->extack, &mod);
+	if (ret < 0)
+		goto out_ops;
+	if (wol.wolopts & ~wol.supported) {
+		NL_SET_ERR_MSG_ATTR(info->extack, tb[ETHTOOL_A_WOL_MODES],
+				    "cannot enable unsupported WoL mode");
+		ret = -EINVAL;
+		goto out_ops;
+	}
+	if (tb[ETHTOOL_A_WOL_SOPASS]) {
+		if (!(wol.supported & WAKE_MAGICSECURE)) {
+			NL_SET_ERR_MSG_ATTR(info->extack,
+					    tb[ETHTOOL_A_WOL_SOPASS],
+					    "magicsecure not supported, cannot set password");
+			ret = -EINVAL;
+			goto out_ops;
+		}
+		ethnl_update_binary(wol.sopass, sizeof(wol.sopass),
+				    tb[ETHTOOL_A_WOL_SOPASS], &mod);
+	}
+
+	if (!mod)
+		goto out_ops;
+	ret = dev->ethtool_ops->set_wol(dev, &wol);
+	if (ret)
+		goto out_ops;
+	dev->wol_enabled = !!wol.wolopts;
+
+out_ops:
+	ethnl_ops_complete(dev);
+out_rtnl:
+	rtnl_unlock();
+	dev_put(dev);
+	return ret;
+}
-- 
2.25.0

