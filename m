Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44AC312B561
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 15:56:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727370AbfL0Oz5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Dec 2019 09:55:57 -0500
Received: from mx2.suse.de ([195.135.220.15]:42828 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727274AbfL0Oz4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Dec 2019 09:55:56 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 97935AF3E;
        Fri, 27 Dec 2019 14:55:53 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 48843E008A; Fri, 27 Dec 2019 15:55:53 +0100 (CET)
Message-Id: <a4b7ccf9c4742ffb8a3b97b5ca7b39c72ad03dc5.1577457846.git.mkubecek@suse.cz>
In-Reply-To: <cover.1577457846.git.mkubecek@suse.cz>
References: <cover.1577457846.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH net-next v9 08/14] ethtool: set link settings with
 LINKINFO_SET request
To:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jiri Pirko <jiri@resnulli.us>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Date:   Fri, 27 Dec 2019 15:55:53 +0100 (CET)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement LINKINFO_SET netlink request to set link settings queried by
LINKINFO_GET message.

Only physical port, phy MDIO address and MDI(-X) control can be set,
attempt to modify MDI(-X) status and transceiver is rejected.

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 Documentation/networking/ethtool-netlink.rst | 24 ++++++-
 include/uapi/linux/ethtool_netlink.h         |  1 +
 net/ethtool/linkinfo.c                       | 71 ++++++++++++++++++++
 net/ethtool/netlink.c                        |  5 ++
 net/ethtool/netlink.h                        |  2 +
 5 files changed, 101 insertions(+), 2 deletions(-)

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index 60684786a92c..39c4aba324c3 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -181,6 +181,7 @@ Userspace to kernel:
   ===================================== ================================
   ``ETHTOOL_MSG_STRSET_GET``            get string set
   ``ETHTOOL_MSG_LINKINFO_GET``          get link settings
+  ``ETHTOOL_MSG_LINKINFO_SET``          set link settings
   ===================================== ================================
 
 Kernel to userspace:
@@ -311,6 +312,25 @@ corresponding ioctl structures.
 devices supporting the request).
 
 
+LINKINFO_SET
+============
+
+``LINKINFO_SET`` request allows setting some of the attributes reported by
+``LINKINFO_GET``.
+
+Request contents:
+
+  ====================================  ======  ==========================
+  ``ETHTOOL_A_LINKINFO_HEADER``         nested  request header
+  ``ETHTOOL_A_LINKINFO_PORT``           u8      physical port
+  ``ETHTOOL_A_LINKINFO_PHYADDR``        u8      phy MDIO address
+  ``ETHTOOL_A_LINKINFO_TP_MDIX_CTRL``   u8      MDI(-X) control
+  ====================================  ======  ==========================
+
+MDI(-X) status and transceiver cannot be set, request with the corresponding
+attributes is rejected.
+
+
 Request translation
 ===================
 
@@ -322,7 +342,7 @@ have their netlink replacement yet.
   ioctl command                       netlink command
   =================================== =====================================
   ``ETHTOOL_GSET``                    ``ETHTOOL_MSG_LINKINFO_GET``
-  ``ETHTOOL_SSET``                    n/a
+  ``ETHTOOL_SSET``                    ``ETHTOOL_MSG_LINKINFO_SET``
   ``ETHTOOL_GDRVINFO``                n/a
   ``ETHTOOL_GREGS``                   n/a
   ``ETHTOOL_GWOL``                    n/a
@@ -396,7 +416,7 @@ have their netlink replacement yet.
   ``ETHTOOL_GPHYSTATS``               n/a
   ``ETHTOOL_PERQUEUE``                n/a
   ``ETHTOOL_GLINKSETTINGS``           ``ETHTOOL_MSG_LINKINFO_GET``
-  ``ETHTOOL_SLINKSETTINGS``           n/a
+  ``ETHTOOL_SLINKSETTINGS``           ``ETHTOOL_MSG_LINKINFO_SET``
   ``ETHTOOL_PHY_GTUNABLE``            n/a
   ``ETHTOOL_PHY_STUNABLE``            n/a
   ``ETHTOOL_GFECPARAM``               n/a
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index 1966532993e5..5b7806a5bef8 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -16,6 +16,7 @@ enum {
 	ETHTOOL_MSG_USER_NONE,
 	ETHTOOL_MSG_STRSET_GET,
 	ETHTOOL_MSG_LINKINFO_GET,
+	ETHTOOL_MSG_LINKINFO_SET,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_USER_CNT,
diff --git a/net/ethtool/linkinfo.c b/net/ethtool/linkinfo.c
index f52a31af6fff..8a5f68f92425 100644
--- a/net/ethtool/linkinfo.c
+++ b/net/ethtool/linkinfo.c
@@ -92,3 +92,74 @@ const struct ethnl_request_ops ethnl_linkinfo_request_ops = {
 	.reply_size		= linkinfo_reply_size,
 	.fill_reply		= linkinfo_fill_reply,
 };
+
+/* LINKINFO_SET */
+
+static const struct nla_policy
+linkinfo_set_policy[ETHTOOL_A_LINKINFO_MAX + 1] = {
+	[ETHTOOL_A_LINKINFO_UNSPEC]		= { .type = NLA_REJECT },
+	[ETHTOOL_A_LINKINFO_HEADER]		= { .type = NLA_NESTED },
+	[ETHTOOL_A_LINKINFO_PORT]		= { .type = NLA_U8 },
+	[ETHTOOL_A_LINKINFO_PHYADDR]		= { .type = NLA_U8 },
+	[ETHTOOL_A_LINKINFO_TP_MDIX]		= { .type = NLA_REJECT },
+	[ETHTOOL_A_LINKINFO_TP_MDIX_CTRL]	= { .type = NLA_U8 },
+	[ETHTOOL_A_LINKINFO_TRANSCEIVER]	= { .type = NLA_REJECT },
+};
+
+int ethnl_set_linkinfo(struct sk_buff *skb, struct genl_info *info)
+{
+	struct nlattr *tb[ETHTOOL_A_LINKINFO_MAX + 1];
+	struct ethtool_link_ksettings ksettings = {};
+	struct ethtool_link_settings *lsettings;
+	struct ethnl_req_info req_info = {};
+	struct net_device *dev;
+	bool mod = false;
+	int ret;
+
+	ret = nlmsg_parse(info->nlhdr, GENL_HDRLEN, tb,
+			  ETHTOOL_A_LINKINFO_MAX, linkinfo_set_policy,
+			  info->extack);
+	if (ret < 0)
+		return ret;
+	ret = ethnl_parse_header(&req_info, tb[ETHTOOL_A_LINKINFO_HEADER],
+				 genl_info_net(info), info->extack, true);
+	if (ret < 0)
+		return ret;
+	dev = req_info.dev;
+	if (!dev->ethtool_ops->get_link_ksettings ||
+	    !dev->ethtool_ops->set_link_ksettings)
+		return -EOPNOTSUPP;
+
+	rtnl_lock();
+	ret = ethnl_ops_begin(dev);
+	if (ret < 0)
+		goto out_rtnl;
+
+	ret = __ethtool_get_link_ksettings(dev, &ksettings);
+	if (ret < 0) {
+		if (info)
+			GENL_SET_ERR_MSG(info, "failed to retrieve link settings");
+		goto out_ops;
+	}
+	lsettings = &ksettings.base;
+
+	ethnl_update_u8(&lsettings->port, tb[ETHTOOL_A_LINKINFO_PORT], &mod);
+	ethnl_update_u8(&lsettings->phy_address, tb[ETHTOOL_A_LINKINFO_PHYADDR],
+			&mod);
+	ethnl_update_u8(&lsettings->eth_tp_mdix_ctrl,
+			tb[ETHTOOL_A_LINKINFO_TP_MDIX_CTRL], &mod);
+	ret = 0;
+	if (!mod)
+		goto out_ops;
+
+	ret = dev->ethtool_ops->set_link_ksettings(dev, &ksettings);
+	if (ret < 0)
+		GENL_SET_ERR_MSG(info, "link settings update failed");
+
+out_ops:
+	ethnl_ops_complete(dev);
+out_rtnl:
+	rtnl_unlock();
+	dev_put(dev);
+	return ret;
+}
diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index ce86d97c922e..7867425956f6 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -534,6 +534,11 @@ static const struct genl_ops ethtool_genl_ops[] = {
 		.dumpit	= ethnl_default_dumpit,
 		.done	= ethnl_default_done,
 	},
+	{
+		.cmd	= ETHTOOL_MSG_LINKINFO_SET,
+		.flags	= GENL_UNS_ADMIN_PERM,
+		.doit	= ethnl_set_linkinfo,
+	},
 };
 
 static const struct genl_multicast_group ethtool_nl_mcgrps[] = {
diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
index 9fc8f94d8dce..bbe5fe60a023 100644
--- a/net/ethtool/netlink.h
+++ b/net/ethtool/netlink.h
@@ -331,4 +331,6 @@ struct ethnl_request_ops {
 extern const struct ethnl_request_ops ethnl_strset_request_ops;
 extern const struct ethnl_request_ops ethnl_linkinfo_request_ops;
 
+int ethnl_set_linkinfo(struct sk_buff *skb, struct genl_info *info);
+
 #endif /* _NET_ETHTOOL_NETLINK_H */
-- 
2.24.1

