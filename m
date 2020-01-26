Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2EE14149D3C
	for <lists+netdev@lfdr.de>; Sun, 26 Jan 2020 23:11:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729213AbgAZWLQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jan 2020 17:11:16 -0500
Received: from mx2.suse.de ([195.135.220.15]:43704 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729159AbgAZWLP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 Jan 2020 17:11:15 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id EC737ADEE;
        Sun, 26 Jan 2020 22:11:13 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 9A6FBE06B1; Sun, 26 Jan 2020 23:11:13 +0100 (CET)
Message-Id: <a52977208338f48ef1383a5cd7288dd916245669.1580075977.git.mkubecek@suse.cz>
In-Reply-To: <cover.1580075977.git.mkubecek@suse.cz>
References: <cover.1580075977.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH net-next 5/7] ethtool: provide WoL settings with WOL_GET
 request
To:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@resnulli.us>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Date:   Sun, 26 Jan 2020 23:11:13 +0100 (CET)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement WOL_GET request to get wake-on-lan settings for a device,
traditionally available via ETHTOOL_GWOL ioctl request.

As part of the implementation, provide symbolic names for wake-on-line
modes as ETH_SS_WOL_MODES string set.

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 Documentation/networking/ethtool-netlink.rst | 30 +++++-
 include/uapi/linux/ethtool.h                 |  4 +
 include/uapi/linux/ethtool_netlink.h         | 15 +++
 net/ethtool/Makefile                         |  2 +-
 net/ethtool/common.c                         | 12 +++
 net/ethtool/common.h                         |  1 +
 net/ethtool/netlink.c                        |  9 ++
 net/ethtool/netlink.h                        |  1 +
 net/ethtool/strset.c                         |  5 +
 net/ethtool/wol.c                            | 99 ++++++++++++++++++++
 10 files changed, 176 insertions(+), 2 deletions(-)
 create mode 100644 net/ethtool/wol.c

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index 2263f885d18f..5fd85e3ea96e 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -187,6 +187,7 @@ Userspace to kernel:
   ``ETHTOOL_MSG_LINKSTATE_GET``         get link state
   ``ETHTOOL_MSG_DEBUG_GET``             get debugging settings
   ``ETHTOOL_MSG_DEBUG_SET``             set debugging settings
+  ``ETHTOOL_MSG_WOL_GET``               get wake-on-lan settings
   ===================================== ================================
 
 Kernel to userspace:
@@ -200,6 +201,7 @@ Kernel to userspace:
   ``ETHTOOL_MSG_LINKSTATE_GET_REPLY``   link state info
   ``ETHTOOL_MSG_DEBUG_GET_REPLY``       debugging settings
   ``ETHTOOL_MSG_DEBUG_NTF``             debugging settings notification
+  ``ETHTOOL_MSG_WOL_GET_REPLY``         wake-on-lan settings
   ===================================== ================================
 
 ``GET`` requests are sent by userspace applications to retrieve device
@@ -474,6 +476,32 @@ Request contents:
 enabled debugging message types for the device.
 
 
+WOL_GET
+=======
+
+Query device wake-on-lan settings. Unlike most "GET" type requests,
+``ETHTOOL_MSG_WOL_GET`` requires (netns) ``CAP_NET_ADMIN`` privileges as it
+(potentially) provides SecureOn(tm) password which is confidential.
+
+Request contents:
+
+  ====================================  ======  ==========================
+  ``ETHTOOL_A_WOL_HEADER``              nested  request header
+  ====================================  ======  ==========================
+
+Kernel response contents:
+
+  ====================================  ======  ==========================
+  ``ETHTOOL_A_WOL_HEADER``              nested  reply header
+  ``ETHTOOL_A_WOL_MODES``               bitset  mask of enabled WoL modes
+  ``ETHTOOL_A_WOL_SOPASS``              binary  SecureOn(tm) password
+  ====================================  ======  ==========================
+
+In reply, ``ETHTOOL_A_WOL_MODES`` mask consists of modes supported by the
+device, value of modes which are enabled. ``ETHTOOL_A_WOL_SOPASS`` is only
+included in reply if ``WAKE_MAGICSECURE`` mode is supported.
+
+
 Request translation
 ===================
 
@@ -490,7 +518,7 @@ have their netlink replacement yet.
                                       ``ETHTOOL_MSG_LINKMODES_SET``
   ``ETHTOOL_GDRVINFO``                n/a
   ``ETHTOOL_GREGS``                   n/a
-  ``ETHTOOL_GWOL``                    n/a
+  ``ETHTOOL_GWOL``                    ``ETHTOOL_MSG_WOL_GET``
   ``ETHTOOL_SWOL``                    n/a
   ``ETHTOOL_GMSGLVL``                 ``ETHTOOL_MSG_DEBUG_GET``
   ``ETHTOOL_SMSGLVL``                 ``ETHTOOL_MSG_DEBUG_SET``
diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
index 456fb2aa0fad..4295ebfa2f91 100644
--- a/include/uapi/linux/ethtool.h
+++ b/include/uapi/linux/ethtool.h
@@ -595,6 +595,7 @@ struct ethtool_pauseparam {
  * @ETH_SS_PHY_TUNABLES: PHY tunable names
  * @ETH_SS_LINK_MODES: link mode names
  * @ETH_SS_MSG_CLASSES: debug message class names
+ * @ETH_SS_WOL_MODES: wake-on-lan modes
  */
 enum ethtool_stringset {
 	ETH_SS_TEST		= 0,
@@ -608,6 +609,7 @@ enum ethtool_stringset {
 	ETH_SS_PHY_TUNABLES,
 	ETH_SS_LINK_MODES,
 	ETH_SS_MSG_CLASSES,
+	ETH_SS_WOL_MODES,
 
 	/* add new constants above here */
 	ETH_SS_COUNT
@@ -1695,6 +1697,8 @@ static inline int ethtool_validate_duplex(__u8 duplex)
 #define WAKE_MAGICSECURE	(1 << 6) /* only meaningful if WAKE_MAGIC */
 #define WAKE_FILTER		(1 << 7)
 
+#define WOL_MODE_COUNT		8
+
 /* L2-L4 network traffic flow types */
 #define	TCP_V4_FLOW	0x01	/* hash or spec (tcp_ip4_spec) */
 #define	UDP_V4_FLOW	0x02	/* hash or spec (udp_ip4_spec) */
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index 67a06b94bf28..dcc5c32dc018 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -22,6 +22,7 @@ enum {
 	ETHTOOL_MSG_LINKSTATE_GET,
 	ETHTOOL_MSG_DEBUG_GET,
 	ETHTOOL_MSG_DEBUG_SET,
+	ETHTOOL_MSG_WOL_GET,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_USER_CNT,
@@ -39,6 +40,7 @@ enum {
 	ETHTOOL_MSG_LINKSTATE_GET_REPLY,
 	ETHTOOL_MSG_DEBUG_GET_REPLY,
 	ETHTOOL_MSG_DEBUG_NTF,
+	ETHTOOL_MSG_WOL_GET_REPLY,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_KERNEL_CNT,
@@ -211,6 +213,19 @@ enum {
 	ETHTOOL_A_DEBUG_MAX = __ETHTOOL_A_DEBUG_CNT - 1
 };
 
+/* WOL */
+
+enum {
+	ETHTOOL_A_WOL_UNSPEC,
+	ETHTOOL_A_WOL_HEADER,			/* nest - _A_HEADER_* */
+	ETHTOOL_A_WOL_MODES,			/* bitset */
+	ETHTOOL_A_WOL_SOPASS,			/* binary */
+
+	/* add new constants above here */
+	__ETHTOOL_A_WOL_CNT,
+	ETHTOOL_A_WOL_MAX = __ETHTOOL_A_WOL_CNT - 1
+};
+
 /* generic netlink info */
 #define ETHTOOL_GENL_NAME "ethtool"
 #define ETHTOOL_GENL_VERSION 1
diff --git a/net/ethtool/Makefile b/net/ethtool/Makefile
index c120c820a4f5..424545a4aaec 100644
--- a/net/ethtool/Makefile
+++ b/net/ethtool/Makefile
@@ -5,4 +5,4 @@ obj-y				+= ioctl.o common.o
 obj-$(CONFIG_ETHTOOL_NETLINK)	+= ethtool_nl.o
 
 ethtool_nl-y	:= netlink.o bitset.o strset.o linkinfo.o linkmodes.o \
-		   linkstate.o debug.o
+		   linkstate.o debug.o wol.o
diff --git a/net/ethtool/common.c b/net/ethtool/common.c
index 93a46c640181..fc26d912d670 100644
--- a/net/ethtool/common.c
+++ b/net/ethtool/common.c
@@ -189,6 +189,18 @@ const char netif_msg_class_names[][ETH_GSTRING_LEN] = {
 };
 static_assert(ARRAY_SIZE(netif_msg_class_names) == NETIF_MSG_CLASS_COUNT);
 
+const char wol_mode_names[][ETH_GSTRING_LEN] = {
+	[const_ilog2(WAKE_PHY)]		= "phy",
+	[const_ilog2(WAKE_UCAST)]	= "ucast",
+	[const_ilog2(WAKE_MCAST)]	= "mcast",
+	[const_ilog2(WAKE_BCAST)]	= "bcast",
+	[const_ilog2(WAKE_ARP)]		= "arp",
+	[const_ilog2(WAKE_MAGIC)]	= "magic",
+	[const_ilog2(WAKE_MAGICSECURE)]	= "magicsecure",
+	[const_ilog2(WAKE_FILTER)]	= "filter",
+};
+static_assert(ARRAY_SIZE(wol_mode_names) == WOL_MODE_COUNT);
+
 /* return false if legacy contained non-0 deprecated fields
  * maxtxpkt/maxrxpkt. rest of ksettings always updated
  */
diff --git a/net/ethtool/common.h b/net/ethtool/common.h
index 064c5c3aa990..40ba74e0b9bb 100644
--- a/net/ethtool/common.h
+++ b/net/ethtool/common.h
@@ -20,6 +20,7 @@ extern const char
 phy_tunable_strings[__ETHTOOL_PHY_TUNABLE_COUNT][ETH_GSTRING_LEN];
 extern const char link_mode_names[][ETH_GSTRING_LEN];
 extern const char netif_msg_class_names[][ETH_GSTRING_LEN];
+extern const char wol_mode_names[][ETH_GSTRING_LEN];
 
 int __ethtool_get_link(struct net_device *dev);
 
diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index 9a0a6c2f8dbb..eeb6d8594e1b 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -214,6 +214,7 @@ ethnl_default_requests[__ETHTOOL_MSG_USER_CNT] = {
 	[ETHTOOL_MSG_LINKMODES_GET]	= &ethnl_linkmodes_request_ops,
 	[ETHTOOL_MSG_LINKSTATE_GET]	= &ethnl_linkstate_request_ops,
 	[ETHTOOL_MSG_DEBUG_GET]		= &ethnl_debug_request_ops,
+	[ETHTOOL_MSG_WOL_GET]		= &ethnl_wol_request_ops,
 };
 
 static struct ethnl_dump_ctx *ethnl_dump_context(struct netlink_callback *cb)
@@ -679,6 +680,14 @@ static const struct genl_ops ethtool_genl_ops[] = {
 		.flags	= GENL_UNS_ADMIN_PERM,
 		.doit	= ethnl_set_debug,
 	},
+	{
+		.cmd	= ETHTOOL_MSG_WOL_GET,
+		.flags	= GENL_UNS_ADMIN_PERM,
+		.doit	= ethnl_default_doit,
+		.start	= ethnl_default_start,
+		.dumpit	= ethnl_default_dumpit,
+		.done	= ethnl_default_done,
+	},
 };
 
 static const struct genl_multicast_group ethtool_nl_mcgrps[] = {
diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
index 772723e536e8..9fcd6f87b396 100644
--- a/net/ethtool/netlink.h
+++ b/net/ethtool/netlink.h
@@ -335,6 +335,7 @@ extern const struct ethnl_request_ops ethnl_linkinfo_request_ops;
 extern const struct ethnl_request_ops ethnl_linkmodes_request_ops;
 extern const struct ethnl_request_ops ethnl_linkstate_request_ops;
 extern const struct ethnl_request_ops ethnl_debug_request_ops;
+extern const struct ethnl_request_ops ethnl_wol_request_ops;
 
 int ethnl_set_linkinfo(struct sk_buff *skb, struct genl_info *info);
 int ethnl_set_linkmodes(struct sk_buff *skb, struct genl_info *info);
diff --git a/net/ethtool/strset.c b/net/ethtool/strset.c
index 7a45c25355b8..8e5911887b4c 100644
--- a/net/ethtool/strset.c
+++ b/net/ethtool/strset.c
@@ -55,6 +55,11 @@ static const struct strset_info info_template[] = {
 		.count		= NETIF_MSG_CLASS_COUNT,
 		.strings	= netif_msg_class_names,
 	},
+	[ETH_SS_WOL_MODES] = {
+		.per_dev	= false,
+		.count		= WOL_MODE_COUNT,
+		.strings	= wol_mode_names,
+	},
 };
 
 struct strset_req_info {
diff --git a/net/ethtool/wol.c b/net/ethtool/wol.c
new file mode 100644
index 000000000000..7c9a1ef622ce
--- /dev/null
+++ b/net/ethtool/wol.c
@@ -0,0 +1,99 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include "netlink.h"
+#include "common.h"
+#include "bitset.h"
+
+struct wol_req_info {
+	struct ethnl_req_info		base;
+};
+
+struct wol_reply_data {
+	struct ethnl_reply_data		base;
+	struct ethtool_wolinfo		wol;
+	bool				show_sopass;
+};
+
+#define WOL_REPDATA(__reply_base) \
+	container_of(__reply_base, struct wol_reply_data, base)
+
+static const struct nla_policy
+wol_get_policy[ETHTOOL_A_WOL_MAX + 1] = {
+	[ETHTOOL_A_WOL_UNSPEC]		= { .type = NLA_REJECT },
+	[ETHTOOL_A_WOL_HEADER]		= { .type = NLA_NESTED },
+	[ETHTOOL_A_WOL_MODES]		= { .type = NLA_REJECT },
+	[ETHTOOL_A_WOL_SOPASS]		= { .type = NLA_REJECT },
+};
+
+static int wol_prepare_data(const struct ethnl_req_info *req_base,
+			    struct ethnl_reply_data *reply_base,
+			    struct genl_info *info)
+{
+	struct wol_reply_data *data = WOL_REPDATA(reply_base);
+	struct net_device *dev = reply_base->dev;
+	int ret;
+
+	if (!dev->ethtool_ops->get_wol)
+		return -EOPNOTSUPP;
+
+	ret = ethnl_ops_begin(dev);
+	if (ret < 0)
+		return ret;
+	dev->ethtool_ops->get_wol(dev, &data->wol);
+	ethnl_ops_complete(dev);
+	data->show_sopass = data->wol.supported & WAKE_MAGICSECURE;
+
+	return 0;
+}
+
+static int wol_reply_size(const struct ethnl_req_info *req_base,
+			  const struct ethnl_reply_data *reply_base)
+{
+	bool compact = req_base->flags & ETHTOOL_FLAG_COMPACT_BITSETS;
+	const struct wol_reply_data *data = WOL_REPDATA(reply_base);
+	int len;
+
+	len = ethnl_bitset32_size(&data->wol.wolopts, &data->wol.supported,
+				  WOL_MODE_COUNT, wol_mode_names, compact);
+	if (len < 0)
+		return len;
+	if (data->show_sopass)
+		len += nla_total_size(sizeof(data->wol.sopass));
+
+	return len;
+}
+
+static int wol_fill_reply(struct sk_buff *skb,
+			  const struct ethnl_req_info *req_base,
+			  const struct ethnl_reply_data *reply_base)
+{
+	bool compact = req_base->flags & ETHTOOL_FLAG_COMPACT_BITSETS;
+	const struct wol_reply_data *data = WOL_REPDATA(reply_base);
+	int ret;
+
+	ret = ethnl_put_bitset32(skb, ETHTOOL_A_WOL_MODES, &data->wol.wolopts,
+				 &data->wol.supported, WOL_MODE_COUNT,
+				 wol_mode_names, compact);
+	if (ret < 0)
+		return ret;
+	if (data->show_sopass &&
+	    nla_put(skb, ETHTOOL_A_WOL_SOPASS, sizeof(data->wol.sopass),
+		    data->wol.sopass))
+		return -EMSGSIZE;
+
+	return 0;
+}
+
+const struct ethnl_request_ops ethnl_wol_request_ops = {
+	.request_cmd		= ETHTOOL_MSG_WOL_GET,
+	.reply_cmd		= ETHTOOL_MSG_WOL_GET_REPLY,
+	.hdr_attr		= ETHTOOL_A_WOL_HEADER,
+	.max_attr		= ETHTOOL_A_WOL_MAX,
+	.req_info_size		= sizeof(struct wol_req_info),
+	.reply_data_size	= sizeof(struct wol_reply_data),
+	.request_policy		= wol_get_policy,
+
+	.prepare_data		= wol_prepare_data,
+	.reply_size		= wol_reply_size,
+	.fill_reply		= wol_fill_reply,
+};
-- 
2.25.0

