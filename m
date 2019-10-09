Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E1B7D1A54
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 23:00:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732478AbfJIU74 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 16:59:56 -0400
Received: from mx2.suse.de ([195.135.220.15]:52194 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732426AbfJIU7z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Oct 2019 16:59:55 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 7A7FDB280;
        Wed,  9 Oct 2019 20:59:52 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 297A2E3785; Wed,  9 Oct 2019 22:59:52 +0200 (CEST)
Message-Id: <17840cb955f43d255e98616bca6517da5ceb1a9f.1570654310.git.mkubecek@suse.cz>
In-Reply-To: <cover.1570654310.git.mkubecek@suse.cz>
References: <cover.1570654310.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH net-next v7 17/17] ethtool: provide link state with
 LINKSTATE_GET request
To:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jiri Pirko <jiri@resnulli.us>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Date:   Wed,  9 Oct 2019 22:59:52 +0200 (CEST)
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
---
 Documentation/networking/ethtool-netlink.rst | 33 ++++++++-
 include/uapi/linux/ethtool_netlink.h         | 16 ++++
 net/ethtool/Makefile                         |  3 +-
 net/ethtool/common.c                         |  8 ++
 net/ethtool/common.h                         |  3 +
 net/ethtool/ioctl.c                          |  8 +-
 net/ethtool/linkstate.c                      | 77 ++++++++++++++++++++
 net/ethtool/netlink.c                        |  8 ++
 net/ethtool/netlink.h                        |  1 +
 9 files changed, 151 insertions(+), 6 deletions(-)
 create mode 100644 net/ethtool/linkstate.c

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index ff5a607ca182..48ace5e97bbe 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -171,6 +171,7 @@ Userspace to kernel:
   ``ETHTOOL_MSG_LINKINFO_SET``          set link settings
   ``ETHTOOL_MSG_LINKMODES_GET``         get link modes info
   ``ETHTOOL_MSG_LINKMODES_SET``         set link modes info
+  ``ETHTOOL_MSG_LINKSTATE_GET``         get link state
   ===================================== ================================
 
 Kernel to userspace:
@@ -181,6 +182,7 @@ Kernel to userspace:
   ``ETHTOOL_MSG_LINKINFO_NTF``          link settings notification
   ``ETHTOOL_MSG_LINKMODES_GET_REPLY``   link modes info
   ``ETHTOOL_MSG_LINKMODES_NTF``         link modes notification
+  ``ETHTOOL_MSG_LINKSTATE_GET_REPLY``   link state info
   ===================================== ================================
 
 ``GET`` requests are sent by userspace applications to retrieve device
@@ -382,6 +384,35 @@ is supposed to allow requesting changes without knowing what exactly kernel
 supports.
 
 
+LINKSTATE_GET
+=============
+
+Requests link state information. At the moment, only link up/down flag (as
+provided by ``ETHTOOL_GLINK`` ioctl command) is provided but some future
+extensions are planned (e.g. link down reason). This request does not have any
+attributes or request specific flags.
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
+  ``ETHTOOL_A_LINKSTATE_LINK``          u8      autonegotiation status
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
 
@@ -403,7 +434,7 @@ have their netlink replacement yet.
   ``ETHTOOL_GMSGLVL``                 n/a
   ``ETHTOOL_SMSGLVL``                 n/a
   ``ETHTOOL_NWAY_RST``                n/a
-  ``ETHTOOL_GLINK``                   n/a
+  ``ETHTOOL_GLINK``                   ``ETHTOOL_MSG_LINKSTATE_GET``
   ``ETHTOOL_GEEPROM``                 n/a
   ``ETHTOOL_SEEPROM``                 n/a
   ``ETHTOOL_GCOALESCE``               n/a
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index 19c7c55c6483..fdb87548c3cc 100644
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
@@ -190,6 +192,20 @@ enum {
 
 #define ETHTOOL_RFLAG_LINKMODES_ALL 0
 
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
+#define ETHTOOL_RFLAG_LINKSTATE_ALL 0
+
 /* generic netlink info */
 #define ETHTOOL_GENL_NAME "ethtool"
 #define ETHTOOL_GENL_VERSION 1
diff --git a/net/ethtool/Makefile b/net/ethtool/Makefile
index 9ae0786c343b..520a39c9875b 100644
--- a/net/ethtool/Makefile
+++ b/net/ethtool/Makefile
@@ -4,4 +4,5 @@ obj-y				+= ioctl.o common.o
 
 obj-$(CONFIG_ETHTOOL_NETLINK)	+= ethtool_nl.o
 
-ethtool_nl-y	:= netlink.o bitset.o strset.o linkinfo.o linkmodes.o
+ethtool_nl-y	:= netlink.o bitset.o strset.o linkinfo.o linkmodes.o \
+		   linkstate.o
diff --git a/net/ethtool/common.c b/net/ethtool/common.c
index 84fed2eecb55..d1fb035394f3 100644
--- a/net/ethtool/common.c
+++ b/net/ethtool/common.c
@@ -131,3 +131,11 @@ convert_legacy_settings_to_link_ksettings(
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
index 0381936d8e1e..a2c1504576c2 100644
--- a/net/ethtool/common.h
+++ b/net/ethtool/common.h
@@ -3,6 +3,7 @@
 #ifndef _ETHTOOL_COMMON_H
 #define _ETHTOOL_COMMON_H
 
+#include <linux/netdevice.h>
 #include <linux/ethtool.h>
 
 extern const char
@@ -14,6 +15,8 @@ tunable_strings[__ETHTOOL_TUNABLE_COUNT][ETH_GSTRING_LEN];
 extern const char
 phy_tunable_strings[__ETHTOOL_PHY_TUNABLE_COUNT][ETH_GSTRING_LEN];
 
+int __ethtool_get_link(struct net_device *dev);
+
 bool convert_legacy_settings_to_link_ksettings(
 	struct ethtool_link_ksettings *link_ksettings,
 	const struct ethtool_cmd *legacy_settings);
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 7768c2e99a29..da5ce57869f4 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -1357,12 +1357,12 @@ static int ethtool_nway_reset(struct net_device *dev)
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
index 000000000000..8459295abfdf
--- /dev/null
+++ b/net/ethtool/linkstate.c
@@ -0,0 +1,77 @@
+// SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note
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
+static const struct nla_policy
+linkstate_get_policy[ETHTOOL_A_LINKSTATE_MAX + 1] = {
+	[ETHTOOL_A_LINKSTATE_UNSPEC]		= { .type = NLA_REJECT },
+	[ETHTOOL_A_LINKSTATE_HEADER]		= { .type = NLA_NESTED },
+	[ETHTOOL_A_LINKSTATE_LINK]		= { .type = NLA_REJECT },
+};
+
+/* prepare_data() handler */
+static int linkstate_prepare(const struct ethnl_req_info *req_base,
+			     struct ethnl_reply_data *reply_base,
+			     struct genl_info *info)
+{
+	struct linkstate_reply_data *data =
+		container_of(reply_base, struct linkstate_reply_data, base);
+	struct net_device *dev = reply_base->dev;
+	int ret;
+
+	ret = ethnl_before_ops(dev);
+	if (ret < 0)
+		return ret;
+	data->link = __ethtool_get_link(dev);
+	ethnl_after_ops(dev);
+
+	return 0;
+}
+
+/* reply_size() handler */
+static int linkstate_size(const struct ethnl_req_info *req_base,
+			  const struct ethnl_reply_data *reply_base)
+{
+	return nla_total_size(sizeof(u8)) /* LINKSTATE_LINK */
+		+ 0;
+}
+
+/* fill_reply() handler */
+static int linkstate_fill(struct sk_buff *skb,
+			  const struct ethnl_req_info *req_base,
+			  const struct ethnl_reply_data *reply_base)
+{
+	struct linkstate_reply_data *data =
+		container_of(reply_base, struct linkstate_reply_data, base);
+
+	if (data->link >= 0 &&
+	    nla_put_u8(skb, ETHTOOL_A_LINKSTATE_LINK, !!data->link))
+		return -EMSGSIZE;
+
+	return 0;
+}
+
+const struct get_request_ops linkstate_request_ops = {
+	.request_cmd		= ETHTOOL_MSG_LINKSTATE_GET,
+	.reply_cmd		= ETHTOOL_MSG_LINKSTATE_GET_REPLY,
+	.hdr_attr		= ETHTOOL_A_LINKSTATE_HEADER,
+	.max_attr		= ETHTOOL_A_LINKSTATE_MAX,
+	.req_info_size		= sizeof(struct linkstate_req_info),
+	.reply_data_size	= sizeof(struct linkstate_reply_data),
+	.request_policy		= linkstate_get_policy,
+	.all_reqflags		= ETHTOOL_RFLAG_LINKSTATE_ALL,
+
+	.prepare_data		= linkstate_prepare,
+	.reply_size		= linkstate_size,
+	.fill_reply		= linkstate_fill,
+};
diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index 7976200e5e35..4ee8e066065c 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -295,6 +295,7 @@ static const struct get_request_ops *get_requests[__ETHTOOL_MSG_USER_CNT] = {
 	[ETHTOOL_MSG_STRSET_GET]	= &strset_request_ops,
 	[ETHTOOL_MSG_LINKINFO_GET]	= &linkinfo_request_ops,
 	[ETHTOOL_MSG_LINKMODES_GET]	= &linkmodes_request_ops,
+	[ETHTOOL_MSG_LINKSTATE_GET]	= &linkstate_request_ops,
 };
 
 static struct ethnl_dump_ctx *ethnl_dump_context(struct netlink_callback *cb)
@@ -744,6 +745,13 @@ static const struct genl_ops ethtool_genl_ops[] = {
 		.flags	= GENL_UNS_ADMIN_PERM,
 		.doit	= ethnl_set_linkmodes,
 	},
+	{
+		.cmd	= ETHTOOL_MSG_LINKSTATE_GET,
+		.doit	= ethnl_get_doit,
+		.start	= ethnl_get_start,
+		.dumpit	= ethnl_get_dumpit,
+		.done	= ethnl_get_done,
+	},
 };
 
 static const struct genl_multicast_group ethtool_nl_mcgrps[] = {
diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
index 88026572567c..3608c852fcb3 100644
--- a/net/ethtool/netlink.h
+++ b/net/ethtool/netlink.h
@@ -350,6 +350,7 @@ struct get_request_ops {
 extern const struct get_request_ops strset_request_ops;
 extern const struct get_request_ops linkinfo_request_ops;
 extern const struct get_request_ops linkmodes_request_ops;
+extern const struct get_request_ops linkstate_request_ops;
 
 int ethnl_set_linkinfo(struct sk_buff *skb, struct genl_info *info);
 int ethnl_set_linkmodes(struct sk_buff *skb, struct genl_info *info);
-- 
2.23.0

