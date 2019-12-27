Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08C8312B56D
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 15:56:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727489AbfL0O42 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Dec 2019 09:56:28 -0500
Received: from mx2.suse.de ([195.135.220.15]:43122 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726920AbfL0O40 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Dec 2019 09:56:26 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id C2102B01D;
        Fri, 27 Dec 2019 14:56:23 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 6D7CEE008A; Fri, 27 Dec 2019 15:56:23 +0100 (CET)
Message-Id: <ec8173368e1c08d79599815b8cda319bfcf5b072.1577457846.git.mkubecek@suse.cz>
In-Reply-To: <cover.1577457846.git.mkubecek@suse.cz>
References: <cover.1577457846.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH net-next v9 14/14] ethtool: provide link state with
 LINKSTATE_GET request
To:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jiri Pirko <jiri@resnulli.us>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Date:   Fri, 27 Dec 2019 15:56:23 +0100 (CET)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement LINKSTATE_GET netlink request to get link state information.

At the moment, only link up flag as provided by ETHTOOL_GLINK ioctl command
is returned.

LINKSTATE_GET request can be used with NLM_F_DUMP (without device
identification) to request the information for all devices in current
network namespace providing the data.

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 Documentation/networking/ethtool-netlink.rst | 33 ++++++++-
 include/uapi/linux/ethtool_netlink.h         | 14 ++++
 net/ethtool/Makefile                         |  3 +-
 net/ethtool/common.c                         |  8 +++
 net/ethtool/common.h                         |  3 +
 net/ethtool/ioctl.c                          |  8 +--
 net/ethtool/linkstate.c                      | 74 ++++++++++++++++++++
 net/ethtool/netlink.c                        |  8 +++
 net/ethtool/netlink.h                        |  1 +
 9 files changed, 146 insertions(+), 6 deletions(-)
 create mode 100644 net/ethtool/linkstate.c

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index 9d96d51e9360..c60afba69e3c 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -184,6 +184,7 @@ Userspace to kernel:
   ``ETHTOOL_MSG_LINKINFO_SET``          set link settings
   ``ETHTOOL_MSG_LINKMODES_GET``         get link modes info
   ``ETHTOOL_MSG_LINKMODES_SET``         set link modes info
+  ``ETHTOOL_MSG_LINKSTATE_GET``         get link state
   ===================================== ================================
 
 Kernel to userspace:
@@ -194,6 +195,7 @@ Kernel to userspace:
   ``ETHTOOL_MSG_LINKINFO_NTF``          link settings notification
   ``ETHTOOL_MSG_LINKMODES_GET_REPLY``   link modes info
   ``ETHTOOL_MSG_LINKMODES_NTF``         link modes notification
+  ``ETHTOOL_MSG_LINKSTATE_GET_REPLY``   link state info
   ===================================== ================================
 
 ``GET`` requests are sent by userspace applications to retrieve device
@@ -392,6 +394,35 @@ is supposed to allow requesting changes without knowing what exactly kernel
 supports.
 
 
+LINKSTATE_GET
+=============
+
+Requests link state information. At the moment, only link up/down flag (as
+provided by ``ETHTOOL_GLINK`` ioctl command) is provided but some future
+extensions are planned (e.g. link down reason). This request does not have any
+attributes.
+
+Request contents:
+
+  ====================================  ======  ==========================
+  ``ETHTOOL_A_LINKSTATE_HEADER``        nested  request header
+  ====================================  ======  ==========================
+
+Kernel response contents:
+
+  ====================================  ======  ==========================
+  ``ETHTOOL_A_LINKSTATE_HEADER``        nested  reply header
+  ``ETHTOOL_A_LINKSTATE_LINK``          bool    link state (up/down)
+  ====================================  ======  ==========================
+
+For most NIC drivers, the value of ``ETHTOOL_A_LINKSTATE_LINK`` returns
+carrier flag provided by ``netif_carrier_ok()`` but there are drivers which
+define their own handler.
+
+``LINKSTATE_GET`` allows dump requests (kernel returns reply messages for all
+devices supporting the request).
+
+
 Request translation
 ===================
 
@@ -413,7 +444,7 @@ have their netlink replacement yet.
   ``ETHTOOL_GMSGLVL``                 n/a
   ``ETHTOOL_SMSGLVL``                 n/a
   ``ETHTOOL_NWAY_RST``                n/a
-  ``ETHTOOL_GLINK``                   n/a
+  ``ETHTOOL_GLINK``                   ``ETHTOOL_MSG_LINKSTATE_GET``
   ``ETHTOOL_GEEPROM``                 n/a
   ``ETHTOOL_SEEPROM``                 n/a
   ``ETHTOOL_GCOALESCE``               n/a
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index 35948df6d6e3..02f82f42a889 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -19,6 +19,7 @@ enum {
 	ETHTOOL_MSG_LINKINFO_SET,
 	ETHTOOL_MSG_LINKMODES_GET,
 	ETHTOOL_MSG_LINKMODES_SET,
+	ETHTOOL_MSG_LINKSTATE_GET,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_USER_CNT,
@@ -33,6 +34,7 @@ enum {
 	ETHTOOL_MSG_LINKINFO_NTF,
 	ETHTOOL_MSG_LINKMODES_GET_REPLY,
 	ETHTOOL_MSG_LINKMODES_NTF,
+	ETHTOOL_MSG_LINKSTATE_GET_REPLY,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_KERNEL_CNT,
@@ -181,6 +183,18 @@ enum {
 	ETHTOOL_A_LINKMODES_MAX = __ETHTOOL_A_LINKMODES_CNT - 1
 };
 
+/* LINKSTATE */
+
+enum {
+	ETHTOOL_A_LINKSTATE_UNSPEC,
+	ETHTOOL_A_LINKSTATE_HEADER,		/* nest - _A_HEADER_* */
+	ETHTOOL_A_LINKSTATE_LINK,		/* u8 */
+
+	/* add new constants above here */
+	__ETHTOOL_A_LINKSTATE_CNT,
+	ETHTOOL_A_LINKSTATE_MAX = __ETHTOOL_A_LINKSTATE_CNT - 1
+};
+
 /* generic netlink info */
 #define ETHTOOL_GENL_NAME "ethtool"
 #define ETHTOOL_GENL_VERSION 1
diff --git a/net/ethtool/Makefile b/net/ethtool/Makefile
index 8023da6672ce..9a1332fb0cc6 100644
--- a/net/ethtool/Makefile
+++ b/net/ethtool/Makefile
@@ -4,4 +4,5 @@ obj-y				+= ioctl.o common.o
 
 obj-$(CONFIG_ETHTOOL_NETLINK)	+= ethtool_nl.o
 
-ethtool_nl-y	:= netlink.o bitset.o strset.o linkinfo.o linkmodes.o
+ethtool_nl-y	:= netlink.o bitset.o strset.o linkinfo.o linkmodes.o \
+		   linkstate.o
diff --git a/net/ethtool/common.c b/net/ethtool/common.c
index 1d4a0aeff2cb..e621b1694d2f 100644
--- a/net/ethtool/common.c
+++ b/net/ethtool/common.c
@@ -217,3 +217,11 @@ convert_legacy_settings_to_link_ksettings(
 		= legacy_settings->eth_tp_mdix_ctrl;
 	return retval;
 }
+
+int __ethtool_get_link(struct net_device *dev)
+{
+	if (!dev->ethtool_ops->get_link)
+		return -EOPNOTSUPP;
+
+	return netif_running(dev) && dev->ethtool_ops->get_link(dev);
+}
diff --git a/net/ethtool/common.h b/net/ethtool/common.h
index c8a237402729..5c5f7dc90cd4 100644
--- a/net/ethtool/common.h
+++ b/net/ethtool/common.h
@@ -3,6 +3,7 @@
 #ifndef _ETHTOOL_COMMON_H
 #define _ETHTOOL_COMMON_H
 
+#include <linux/netdevice.h>
 #include <linux/ethtool.h>
 
 /* compose link mode index from speed, type and duplex */
@@ -19,6 +20,8 @@ extern const char
 phy_tunable_strings[__ETHTOOL_PHY_TUNABLE_COUNT][ETH_GSTRING_LEN];
 extern const char link_mode_names[][ETH_GSTRING_LEN];
 
+int __ethtool_get_link(struct net_device *dev);
+
 bool convert_legacy_settings_to_link_ksettings(
 	struct ethtool_link_ksettings *link_ksettings,
 	const struct ethtool_cmd *legacy_settings);
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 36e2ef2d900d..182bffbffa78 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -1365,12 +1365,12 @@ static int ethtool_nway_reset(struct net_device *dev)
 static int ethtool_get_link(struct net_device *dev, char __user *useraddr)
 {
 	struct ethtool_value edata = { .cmd = ETHTOOL_GLINK };
+	int link = __ethtool_get_link(dev);
 
-	if (!dev->ethtool_ops->get_link)
-		return -EOPNOTSUPP;
-
-	edata.data = netif_running(dev) && dev->ethtool_ops->get_link(dev);
+	if (link < 0)
+		return link;
 
+	edata.data = link;
 	if (copy_to_user(useraddr, &edata, sizeof(edata)))
 		return -EFAULT;
 	return 0;
diff --git a/net/ethtool/linkstate.c b/net/ethtool/linkstate.c
new file mode 100644
index 000000000000..2740cde0a182
--- /dev/null
+++ b/net/ethtool/linkstate.c
@@ -0,0 +1,74 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include "netlink.h"
+#include "common.h"
+
+struct linkstate_req_info {
+	struct ethnl_req_info		base;
+};
+
+struct linkstate_reply_data {
+	struct ethnl_reply_data		base;
+	int				link;
+};
+
+#define LINKSTATE_REPDATA(__reply_base) \
+	container_of(__reply_base, struct linkstate_reply_data, base)
+
+static const struct nla_policy
+linkstate_get_policy[ETHTOOL_A_LINKSTATE_MAX + 1] = {
+	[ETHTOOL_A_LINKSTATE_UNSPEC]		= { .type = NLA_REJECT },
+	[ETHTOOL_A_LINKSTATE_HEADER]		= { .type = NLA_NESTED },
+	[ETHTOOL_A_LINKSTATE_LINK]		= { .type = NLA_REJECT },
+};
+
+static int linkstate_prepare_data(const struct ethnl_req_info *req_base,
+				  struct ethnl_reply_data *reply_base,
+				  struct genl_info *info)
+{
+	struct linkstate_reply_data *data = LINKSTATE_REPDATA(reply_base);
+	struct net_device *dev = reply_base->dev;
+	int ret;
+
+	ret = ethnl_ops_begin(dev);
+	if (ret < 0)
+		return ret;
+	data->link = __ethtool_get_link(dev);
+	ethnl_ops_complete(dev);
+
+	return 0;
+}
+
+static int linkstate_reply_size(const struct ethnl_req_info *req_base,
+				const struct ethnl_reply_data *reply_base)
+{
+	return nla_total_size(sizeof(u8)) /* LINKSTATE_LINK */
+		+ 0;
+}
+
+static int linkstate_fill_reply(struct sk_buff *skb,
+				const struct ethnl_req_info *req_base,
+				const struct ethnl_reply_data *reply_base)
+{
+	struct linkstate_reply_data *data = LINKSTATE_REPDATA(reply_base);
+
+	if (data->link >= 0 &&
+	    nla_put_u8(skb, ETHTOOL_A_LINKSTATE_LINK, !!data->link))
+		return -EMSGSIZE;
+
+	return 0;
+}
+
+const struct ethnl_request_ops ethnl_linkstate_request_ops = {
+	.request_cmd		= ETHTOOL_MSG_LINKSTATE_GET,
+	.reply_cmd		= ETHTOOL_MSG_LINKSTATE_GET_REPLY,
+	.hdr_attr		= ETHTOOL_A_LINKSTATE_HEADER,
+	.max_attr		= ETHTOOL_A_LINKSTATE_MAX,
+	.req_info_size		= sizeof(struct linkstate_req_info),
+	.reply_data_size	= sizeof(struct linkstate_reply_data),
+	.request_policy		= linkstate_get_policy,
+
+	.prepare_data		= linkstate_prepare_data,
+	.reply_size		= linkstate_reply_size,
+	.fill_reply		= linkstate_fill_reply,
+};
diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index 1b5e1bd26504..4ca96c7b86b3 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -210,6 +210,7 @@ ethnl_default_requests[__ETHTOOL_MSG_USER_CNT] = {
 	[ETHTOOL_MSG_STRSET_GET]	= &ethnl_strset_request_ops,
 	[ETHTOOL_MSG_LINKINFO_GET]	= &ethnl_linkinfo_request_ops,
 	[ETHTOOL_MSG_LINKMODES_GET]	= &ethnl_linkmodes_request_ops,
+	[ETHTOOL_MSG_LINKSTATE_GET]	= &ethnl_linkstate_request_ops,
 };
 
 static struct ethnl_dump_ctx *ethnl_dump_context(struct netlink_callback *cb)
@@ -645,6 +646,13 @@ static const struct genl_ops ethtool_genl_ops[] = {
 		.flags	= GENL_UNS_ADMIN_PERM,
 		.doit	= ethnl_set_linkmodes,
 	},
+	{
+		.cmd	= ETHTOOL_MSG_LINKSTATE_GET,
+		.doit	= ethnl_default_doit,
+		.start	= ethnl_default_start,
+		.dumpit	= ethnl_default_dumpit,
+		.done	= ethnl_default_done,
+	},
 };
 
 static const struct genl_multicast_group ethtool_nl_mcgrps[] = {
diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
index 1269cca8a002..da9d6521a4eb 100644
--- a/net/ethtool/netlink.h
+++ b/net/ethtool/netlink.h
@@ -333,6 +333,7 @@ struct ethnl_request_ops {
 extern const struct ethnl_request_ops ethnl_strset_request_ops;
 extern const struct ethnl_request_ops ethnl_linkinfo_request_ops;
 extern const struct ethnl_request_ops ethnl_linkmodes_request_ops;
+extern const struct ethnl_request_ops ethnl_linkstate_request_ops;
 
 int ethnl_set_linkinfo(struct sk_buff *skb, struct genl_info *info);
 int ethnl_set_linkmodes(struct sk_buff *skb, struct genl_info *info);
-- 
2.24.1

