Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57F9AD1A50
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 23:00:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732433AbfJIU7r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 16:59:47 -0400
Received: from mx2.suse.de ([195.135.220.15]:51946 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732413AbfJIU7p (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Oct 2019 16:59:45 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 65365B275;
        Wed,  9 Oct 2019 20:59:43 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 1547FE3785; Wed,  9 Oct 2019 22:59:43 +0200 (CEST)
Message-Id: <aef31ba798d1cfa2ae92d333ad1547f4b528ffa8.1570654310.git.mkubecek@suse.cz>
In-Reply-To: <cover.1570654310.git.mkubecek@suse.cz>
References: <cover.1570654310.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH net-next v7 14/17] ethtool: set link settings with
 LINKINFO_SET request
To:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jiri Pirko <jiri@resnulli.us>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Date:   Wed,  9 Oct 2019 22:59:43 +0200 (CEST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement LINKINFO_SET netlink request to set link settings queried by
LINKINFO_GET message.

Only physical port, phy MDIO address and MDI(-X) control can be set,
attempt to modify MDI(-X) status and transceiver is rejected.

When any data is modified, ETHTOOL_MSG_LINKINFO_NTF message in the same
format as reply to LINKINFO_GET request is sent to notify userspace about
the changes. The same notification is also sent when these settings are
modified using the ioctl interface.

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 Documentation/networking/ethtool-netlink.rst | 25 +++++-
 include/uapi/linux/ethtool_netlink.h         |  2 +
 net/ethtool/ioctl.c                          | 12 ++-
 net/ethtool/linkinfo.c                       | 83 ++++++++++++++++++++
 net/ethtool/netlink.c                        | 11 +++
 net/ethtool/netlink.h                        |  2 +
 6 files changed, 131 insertions(+), 4 deletions(-)

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index 0d21469debec..48833b6092d9 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -168,6 +168,7 @@ Userspace to kernel:
   ===================================== ================================
   ``ETHTOOL_MSG_STRSET_GET``            get string set
   ``ETHTOOL_MSG_LINKINFO_GET``          get link settings
+  ``ETHTOOL_MSG_LINKINFO_SET``          set link settings
   ===================================== ================================
 
 Kernel to userspace:
@@ -175,6 +176,7 @@ Kernel to userspace:
   ===================================== ================================
   ``ETHTOOL_MSG_STRSET_GET_REPLY``      string set contents
   ``ETHTOOL_MSG_LINKINFO_GET_REPLY``    link settings
+  ``ETHTOOL_MSG_LINKINFO_NTF``          link settings notification
   ===================================== ================================
 
 ``GET`` requests are sent by userspace applications to retrieve device
@@ -300,6 +302,25 @@ corresponding ioctl structures.
 devices supporting the request).
 
 
+LINKINFO_SET
+============
+
+``LINKINFO_SET`` request allows setting some of the attributes reported by
+``LINKINFO_GET``. and The request has no request specific flags.
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
 
@@ -311,7 +332,7 @@ have their netlink replacement yet.
   ioctl command                       netlink command
   =================================== =====================================
   ``ETHTOOL_GSET``                    ``ETHTOOL_MSG_LINKINFO_GET``
-  ``ETHTOOL_SSET``                    n/a
+  ``ETHTOOL_SSET``                    ``ETHTOOL_MSG_LINKINFO_SET``
   ``ETHTOOL_GDRVINFO``                n/a
   ``ETHTOOL_GREGS``                   n/a
   ``ETHTOOL_GWOL``                    n/a
@@ -385,7 +406,7 @@ have their netlink replacement yet.
   ``ETHTOOL_GPHYSTATS``               n/a
   ``ETHTOOL_PERQUEUE``                n/a
   ``ETHTOOL_GLINKSETTINGS``           ``ETHTOOL_MSG_LINKINFO_GET``
-  ``ETHTOOL_SLINKSETTINGS``           n/a
+  ``ETHTOOL_SLINKSETTINGS``           ``ETHTOOL_MSG_LINKINFO_SET``
   ``ETHTOOL_PHY_GTUNABLE``            n/a
   ``ETHTOOL_PHY_STUNABLE``            n/a
   ``ETHTOOL_GFECPARAM``               n/a
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index 56ab2a530d22..78ee5584d5da 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -16,6 +16,7 @@ enum {
 	ETHTOOL_MSG_USER_NONE,
 	ETHTOOL_MSG_STRSET_GET,
 	ETHTOOL_MSG_LINKINFO_GET,
+	ETHTOOL_MSG_LINKINFO_SET,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_USER_CNT,
@@ -27,6 +28,7 @@ enum {
 	ETHTOOL_MSG_KERNEL_NONE,
 	ETHTOOL_MSG_STRSET_GET_REPLY,
 	ETHTOOL_MSG_LINKINFO_GET_REPLY,
+	ETHTOOL_MSG_LINKINFO_NTF,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_KERNEL_CNT,
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 2cd04cb6b4b9..0747fe6b5f4c 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -26,6 +26,7 @@
 #include <net/devlink.h>
 #include <net/xdp_sock.h>
 #include <net/flow_offload.h>
+#include <linux/ethtool_netlink.h>
 
 #include "common.h"
 
@@ -565,7 +566,10 @@ static int ethtool_set_link_ksettings(struct net_device *dev,
 	    != link_ksettings.base.link_mode_masks_nwords)
 		return -EINVAL;
 
-	return dev->ethtool_ops->set_link_ksettings(dev, &link_ksettings);
+	err = dev->ethtool_ops->set_link_ksettings(dev, &link_ksettings);
+	if (err >= 0)
+		ethtool_notify(dev, ETHTOOL_MSG_LINKINFO_NTF, NULL);
+	return err;
 }
 
 /* Query device for its ethtool_cmd settings.
@@ -614,6 +618,7 @@ static int ethtool_set_settings(struct net_device *dev, void __user *useraddr)
 {
 	struct ethtool_link_ksettings link_ksettings;
 	struct ethtool_cmd cmd;
+	int ret;
 
 	ASSERT_RTNL();
 
@@ -626,7 +631,10 @@ static int ethtool_set_settings(struct net_device *dev, void __user *useraddr)
 		return -EINVAL;
 	link_ksettings.base.link_mode_masks_nwords =
 		__ETHTOOL_LINK_MODE_MASK_NU32;
-	return dev->ethtool_ops->set_link_ksettings(dev, &link_ksettings);
+	ret = dev->ethtool_ops->set_link_ksettings(dev, &link_ksettings);
+	if (ret >= 0)
+		ethtool_notify(dev, ETHTOOL_MSG_LINKINFO_NTF, NULL);
+	return ret;
 }
 
 static noinline_for_stack int ethtool_get_drvinfo(struct net_device *dev,
diff --git a/net/ethtool/linkinfo.c b/net/ethtool/linkinfo.c
index c28ca4d9dd2a..ea1997b154f0 100644
--- a/net/ethtool/linkinfo.c
+++ b/net/ethtool/linkinfo.c
@@ -95,3 +95,86 @@ const struct get_request_ops linkinfo_request_ops = {
 	.reply_size		= linkinfo_size,
 	.fill_reply		= linkinfo_fill,
 };
+
+/* LINKINFO_SET */
+
+static const struct nla_policy linkinfo_hdr_policy[ETHTOOL_A_HEADER_MAX + 1] = {
+	[ETHTOOL_A_HEADER_UNSPEC]		= { .type = NLA_REJECT },
+	[ETHTOOL_A_HEADER_DEV_INDEX]		= { .type = NLA_U32 },
+	[ETHTOOL_A_HEADER_DEV_NAME]		= { .type = NLA_NUL_STRING,
+						    .len = IFNAMSIZ - 1 },
+	[ETHTOOL_A_HEADER_GFLAGS]		= { .type = NLA_U32 },
+	[ETHTOOL_A_HEADER_RFLAGS]		= { .type = NLA_REJECT },
+};
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
+				 genl_info_net(info), info->extack,
+				 linkinfo_hdr_policy, true);
+	if (ret < 0)
+		return ret;
+	dev = req_info.dev;
+	if (!dev->ethtool_ops->get_link_ksettings ||
+	    !dev->ethtool_ops->set_link_ksettings)
+		return -EOPNOTSUPP;
+
+	rtnl_lock();
+	ret = ethnl_before_ops(dev);
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
+
+	ret = 0;
+	if (mod) {
+		ret = dev->ethtool_ops->set_link_ksettings(dev, &ksettings);
+		if (ret < 0)
+			GENL_SET_ERR_MSG(info, "link settings update failed");
+		else
+			ethtool_notify(dev, ETHTOOL_MSG_LINKINFO_NTF, NULL);
+	}
+
+out_ops:
+	ethnl_after_ops(dev);
+out_rtnl:
+	rtnl_unlock();
+	dev_put(dev);
+	return ret;
+}
diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index dc52d912e0dd..5b9d12656e97 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -603,6 +603,11 @@ static int ethnl_get_done(struct netlink_callback *cb)
 
 static const struct get_request_ops *ethnl_std_notify_to_ops(unsigned int cmd)
 {
+	switch (cmd) {
+	case ETHTOOL_MSG_LINKINFO_NTF:
+		return &linkinfo_request_ops;
+	};
+
 	WARN_ONCE(1, "unexpected notification type %u\n", cmd);
 	return NULL;
 }
@@ -683,6 +688,7 @@ typedef void (*ethnl_notify_handler_t)(struct net_device *dev, unsigned int cmd,
 				       const void *data);
 
 static const ethnl_notify_handler_t ethnl_notify_handlers[] = {
+	[ETHTOOL_MSG_LINKINFO_NTF]	= ethnl_std_notify,
 };
 
 void ethtool_notify(struct net_device *dev, unsigned int cmd, const void *data)
@@ -717,6 +723,11 @@ static const struct genl_ops ethtool_genl_ops[] = {
 		.dumpit	= ethnl_get_dumpit,
 		.done	= ethnl_get_done,
 	},
+	{
+		.cmd	= ETHTOOL_MSG_LINKINFO_SET,
+		.flags	= GENL_UNS_ADMIN_PERM,
+		.doit	= ethnl_set_linkinfo,
+	},
 };
 
 static const struct genl_multicast_group ethtool_nl_mcgrps[] = {
diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
index 23e82a4dd265..ca136dd7ea02 100644
--- a/net/ethtool/netlink.h
+++ b/net/ethtool/netlink.h
@@ -350,4 +350,6 @@ struct get_request_ops {
 extern const struct get_request_ops strset_request_ops;
 extern const struct get_request_ops linkinfo_request_ops;
 
+int ethnl_set_linkinfo(struct sk_buff *skb, struct genl_info *info);
+
 #endif /* _NET_ETHTOOL_NETLINK_H */
-- 
2.23.0

