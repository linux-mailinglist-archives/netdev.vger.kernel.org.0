Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7AAB3149D37
	for <lists+netdev@lfdr.de>; Sun, 26 Jan 2020 23:11:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729066AbgAZWLJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jan 2020 17:11:09 -0500
Received: from mx2.suse.de ([195.135.220.15]:43606 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728884AbgAZWLI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 Jan 2020 17:11:08 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id D86FCAD03;
        Sun, 26 Jan 2020 22:11:04 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 865FBE06B1; Sun, 26 Jan 2020 23:11:04 +0100 (CET)
Message-Id: <9f81d98d866d538642696339d9ee5c08a399a384.1580075977.git.mkubecek@suse.cz>
In-Reply-To: <cover.1580075977.git.mkubecek@suse.cz>
References: <cover.1580075977.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH net-next 2/7] ethtool: provide message mask with DEBUG_GET
 request
To:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@resnulli.us>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Date:   Sun, 26 Jan 2020 23:11:04 +0100 (CET)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement DEBUG_GET request to get debugging settings for a device. At the
moment, only message mask corresponding to message level as reported by
ETHTOOL_GMSGLVL ioctl request is provided. (It is called message level in
ioctl interface but almost all drivers interpret it as a bit mask.)

As part of the implementation, provide symbolic names for message mask bits
as ETH_SS_MSG_CLASSES string set.

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 Documentation/networking/ethtool-netlink.rst | 34 ++++++++-
 include/linux/netdevice.h                    | 56 ++++++++++----
 include/uapi/linux/ethtool.h                 |  2 +
 include/uapi/linux/ethtool_netlink.h         | 14 ++++
 net/ethtool/Makefile                         |  2 +-
 net/ethtool/common.c                         | 19 +++++
 net/ethtool/common.h                         |  1 +
 net/ethtool/debug.c                          | 80 ++++++++++++++++++++
 net/ethtool/netlink.c                        |  8 ++
 net/ethtool/netlink.h                        |  1 +
 net/ethtool/strset.c                         |  5 ++
 11 files changed, 205 insertions(+), 17 deletions(-)
 create mode 100644 net/ethtool/debug.c

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index c60afba69e3c..76a411d3102d 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -185,6 +185,7 @@ Userspace to kernel:
   ``ETHTOOL_MSG_LINKMODES_GET``         get link modes info
   ``ETHTOOL_MSG_LINKMODES_SET``         set link modes info
   ``ETHTOOL_MSG_LINKSTATE_GET``         get link state
+  ``ETHTOOL_MSG_DEBUG_GET``             get debugging settings
   ===================================== ================================
 
 Kernel to userspace:
@@ -196,6 +197,7 @@ Kernel to userspace:
   ``ETHTOOL_MSG_LINKMODES_GET_REPLY``   link modes info
   ``ETHTOOL_MSG_LINKMODES_NTF``         link modes notification
   ``ETHTOOL_MSG_LINKSTATE_GET_REPLY``   link state info
+  ``ETHTOOL_MSG_DEBUG_GET_REPLY``       debugging settings
   ===================================== ================================
 
 ``GET`` requests are sent by userspace applications to retrieve device
@@ -423,6 +425,36 @@ define their own handler.
 devices supporting the request).
 
 
+DEBUG_GET
+=========
+
+Requests debugging settings of a device. At the moment, only message mask is
+provided.
+
+Request contents:
+
+  ====================================  ======  ==========================
+  ``ETHTOOL_A_DEBUG_HEADER``            nested  request header
+  ====================================  ======  ==========================
+
+Kernel response contents:
+
+  ====================================  ======  ==========================
+  ``ETHTOOL_A_DEBUG_HEADER``            nested  reply header
+  ``ETHTOOL_A_DEBUG_MSGMASK``           bitset  message mask
+  ====================================  ======  ==========================
+
+The message mask (``ETHTOOL_A_DEBUG_MSGMASK``) is equal to message level as
+provided by ``ETHTOOL_GMSGLVL`` and set by ``ETHTOOL_SMSGLVL`` in ioctl
+interface. While it is called message level there for historical reasons, most
+drivers and almost all newer drivers use it as a mask of enabled message
+classes (represented by ``NETIF_MSG_*`` constants); therefore netlink
+interface follows its actual use in practice.
+
+``DEBUG_GET`` allows dump requests (kernel returns reply messages for all
+devices supporting the request).
+
+
 Request translation
 ===================
 
@@ -441,7 +473,7 @@ have their netlink replacement yet.
   ``ETHTOOL_GREGS``                   n/a
   ``ETHTOOL_GWOL``                    n/a
   ``ETHTOOL_SWOL``                    n/a
-  ``ETHTOOL_GMSGLVL``                 n/a
+  ``ETHTOOL_GMSGLVL``                 ``ETHTOOL_MSG_DEBUG_GET``
   ``ETHTOOL_SMSGLVL``                 n/a
   ``ETHTOOL_NWAY_RST``                n/a
   ``ETHTOOL_GLINK``                   ``ETHTOOL_MSG_LINKSTATE_GET``
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 78e9c6c1b131..bdec77b7bec3 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3894,22 +3894,48 @@ void netif_device_attach(struct net_device *dev);
  */
 
 enum {
-	NETIF_MSG_DRV		= 0x0001,
-	NETIF_MSG_PROBE		= 0x0002,
-	NETIF_MSG_LINK		= 0x0004,
-	NETIF_MSG_TIMER		= 0x0008,
-	NETIF_MSG_IFDOWN	= 0x0010,
-	NETIF_MSG_IFUP		= 0x0020,
-	NETIF_MSG_RX_ERR	= 0x0040,
-	NETIF_MSG_TX_ERR	= 0x0080,
-	NETIF_MSG_TX_QUEUED	= 0x0100,
-	NETIF_MSG_INTR		= 0x0200,
-	NETIF_MSG_TX_DONE	= 0x0400,
-	NETIF_MSG_RX_STATUS	= 0x0800,
-	NETIF_MSG_PKTDATA	= 0x1000,
-	NETIF_MSG_HW		= 0x2000,
-	NETIF_MSG_WOL		= 0x4000,
+	NETIF_MSG_DRV_BIT,
+	NETIF_MSG_PROBE_BIT,
+	NETIF_MSG_LINK_BIT,
+	NETIF_MSG_TIMER_BIT,
+	NETIF_MSG_IFDOWN_BIT,
+	NETIF_MSG_IFUP_BIT,
+	NETIF_MSG_RX_ERR_BIT,
+	NETIF_MSG_TX_ERR_BIT,
+	NETIF_MSG_TX_QUEUED_BIT,
+	NETIF_MSG_INTR_BIT,
+	NETIF_MSG_TX_DONE_BIT,
+	NETIF_MSG_RX_STATUS_BIT,
+	NETIF_MSG_PKTDATA_BIT,
+	NETIF_MSG_HW_BIT,
+	NETIF_MSG_WOL_BIT,
+
+	/* When you add a new bit above, update netif_msg_class_names array
+	 * in net/ethtool/common.c
+	 */
+	NETIF_MSG_CLASS_COUNT,
 };
+/* Both ethtool_ops interface and internal driver implementation use u32 */
+static_assert(NETIF_MSG_CLASS_COUNT <= 32);
+
+#define __NETIF_MSG_BIT(bit)	((u32)1 << (bit))
+#define __NETIF_MSG(name)	__NETIF_MSG_BIT(NETIF_MSG_ ## name ## _BIT)
+
+#define NETIF_MSG_DRV		__NETIF_MSG(DRV)
+#define NETIF_MSG_PROBE		__NETIF_MSG(PROBE)
+#define NETIF_MSG_LINK		__NETIF_MSG(LINK)
+#define NETIF_MSG_TIMER		__NETIF_MSG(TIMER)
+#define NETIF_MSG_IFDOWN	__NETIF_MSG(IFDOWN)
+#define NETIF_MSG_IFUP		__NETIF_MSG(IFUP)
+#define NETIF_MSG_RX_ERR	__NETIF_MSG(RX_ERR)
+#define NETIF_MSG_TX_ERR	__NETIF_MSG(TX_ERR)
+#define NETIF_MSG_TX_QUEUED	__NETIF_MSG(TX_QUEUED)
+#define NETIF_MSG_INTR		__NETIF_MSG(INTR)
+#define NETIF_MSG_TX_DONE	__NETIF_MSG(TX_DONE)
+#define NETIF_MSG_RX_STATUS	__NETIF_MSG(RX_STATUS)
+#define NETIF_MSG_PKTDATA	__NETIF_MSG(PKTDATA)
+#define NETIF_MSG_HW		__NETIF_MSG(HW)
+#define NETIF_MSG_WOL		__NETIF_MSG(WOL)
 
 #define netif_msg_drv(p)	((p)->msg_enable & NETIF_MSG_DRV)
 #define netif_msg_probe(p)	((p)->msg_enable & NETIF_MSG_PROBE)
diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
index 116bcbf09c74..456fb2aa0fad 100644
--- a/include/uapi/linux/ethtool.h
+++ b/include/uapi/linux/ethtool.h
@@ -594,6 +594,7 @@ struct ethtool_pauseparam {
  * @ETH_SS_PHY_STATS: Statistic names, for use with %ETHTOOL_GPHYSTATS
  * @ETH_SS_PHY_TUNABLES: PHY tunable names
  * @ETH_SS_LINK_MODES: link mode names
+ * @ETH_SS_MSG_CLASSES: debug message class names
  */
 enum ethtool_stringset {
 	ETH_SS_TEST		= 0,
@@ -606,6 +607,7 @@ enum ethtool_stringset {
 	ETH_SS_PHY_STATS,
 	ETH_SS_PHY_TUNABLES,
 	ETH_SS_LINK_MODES,
+	ETH_SS_MSG_CLASSES,
 
 	/* add new constants above here */
 	ETH_SS_COUNT
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index 02f82f42a889..0d39e04567cb 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -20,6 +20,7 @@ enum {
 	ETHTOOL_MSG_LINKMODES_GET,
 	ETHTOOL_MSG_LINKMODES_SET,
 	ETHTOOL_MSG_LINKSTATE_GET,
+	ETHTOOL_MSG_DEBUG_GET,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_USER_CNT,
@@ -35,6 +36,7 @@ enum {
 	ETHTOOL_MSG_LINKMODES_GET_REPLY,
 	ETHTOOL_MSG_LINKMODES_NTF,
 	ETHTOOL_MSG_LINKSTATE_GET_REPLY,
+	ETHTOOL_MSG_DEBUG_GET_REPLY,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_KERNEL_CNT,
@@ -195,6 +197,18 @@ enum {
 	ETHTOOL_A_LINKSTATE_MAX = __ETHTOOL_A_LINKSTATE_CNT - 1
 };
 
+/* DEBUG */
+
+enum {
+	ETHTOOL_A_DEBUG_UNSPEC,
+	ETHTOOL_A_DEBUG_HEADER,			/* nest - _A_HEADER_* */
+	ETHTOOL_A_DEBUG_MSGMASK,		/* bitset */
+
+	/* add new constants above here */
+	__ETHTOOL_A_DEBUG_CNT,
+	ETHTOOL_A_DEBUG_MAX = __ETHTOOL_A_DEBUG_CNT - 1
+};
+
 /* generic netlink info */
 #define ETHTOOL_GENL_NAME "ethtool"
 #define ETHTOOL_GENL_VERSION 1
diff --git a/net/ethtool/Makefile b/net/ethtool/Makefile
index 9a1332fb0cc6..c120c820a4f5 100644
--- a/net/ethtool/Makefile
+++ b/net/ethtool/Makefile
@@ -5,4 +5,4 @@ obj-y				+= ioctl.o common.o
 obj-$(CONFIG_ETHTOOL_NETLINK)	+= ethtool_nl.o
 
 ethtool_nl-y	:= netlink.o bitset.o strset.o linkinfo.o linkmodes.o \
-		   linkstate.o
+		   linkstate.o debug.o
diff --git a/net/ethtool/common.c b/net/ethtool/common.c
index e621b1694d2f..93a46c640181 100644
--- a/net/ethtool/common.c
+++ b/net/ethtool/common.c
@@ -170,6 +170,25 @@ const char link_mode_names[][ETH_GSTRING_LEN] = {
 };
 static_assert(ARRAY_SIZE(link_mode_names) == __ETHTOOL_LINK_MODE_MASK_NBITS);
 
+const char netif_msg_class_names[][ETH_GSTRING_LEN] = {
+	[NETIF_MSG_DRV_BIT]		= "drv",
+	[NETIF_MSG_PROBE_BIT]		= "probe",
+	[NETIF_MSG_LINK_BIT]		= "link",
+	[NETIF_MSG_TIMER_BIT]		= "timer",
+	[NETIF_MSG_IFDOWN_BIT]		= "ifdown",
+	[NETIF_MSG_IFUP_BIT]		= "ifup",
+	[NETIF_MSG_RX_ERR_BIT]		= "rx_err",
+	[NETIF_MSG_TX_ERR_BIT]		= "tx_err",
+	[NETIF_MSG_TX_QUEUED_BIT]	= "tx_queued",
+	[NETIF_MSG_INTR_BIT]		= "intr",
+	[NETIF_MSG_TX_DONE_BIT]		= "tx_done",
+	[NETIF_MSG_RX_STATUS_BIT]	= "rx_status",
+	[NETIF_MSG_PKTDATA_BIT]		= "pktdata",
+	[NETIF_MSG_HW_BIT]		= "hw",
+	[NETIF_MSG_WOL_BIT]		= "wol",
+};
+static_assert(ARRAY_SIZE(netif_msg_class_names) == NETIF_MSG_CLASS_COUNT);
+
 /* return false if legacy contained non-0 deprecated fields
  * maxtxpkt/maxrxpkt. rest of ksettings always updated
  */
diff --git a/net/ethtool/common.h b/net/ethtool/common.h
index 5c5f7dc90cd4..064c5c3aa990 100644
--- a/net/ethtool/common.h
+++ b/net/ethtool/common.h
@@ -19,6 +19,7 @@ tunable_strings[__ETHTOOL_TUNABLE_COUNT][ETH_GSTRING_LEN];
 extern const char
 phy_tunable_strings[__ETHTOOL_PHY_TUNABLE_COUNT][ETH_GSTRING_LEN];
 extern const char link_mode_names[][ETH_GSTRING_LEN];
+extern const char netif_msg_class_names[][ETH_GSTRING_LEN];
 
 int __ethtool_get_link(struct net_device *dev);
 
diff --git a/net/ethtool/debug.c b/net/ethtool/debug.c
new file mode 100644
index 000000000000..cc121a23be5f
--- /dev/null
+++ b/net/ethtool/debug.c
@@ -0,0 +1,80 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include "netlink.h"
+#include "common.h"
+#include "bitset.h"
+
+struct debug_req_info {
+	struct ethnl_req_info		base;
+};
+
+struct debug_reply_data {
+	struct ethnl_reply_data		base;
+	u32				msg_mask;
+};
+
+#define DEBUG_REPDATA(__reply_base) \
+	container_of(__reply_base, struct debug_reply_data, base)
+
+static const struct nla_policy
+debug_get_policy[ETHTOOL_A_DEBUG_MAX + 1] = {
+	[ETHTOOL_A_DEBUG_UNSPEC]	= { .type = NLA_REJECT },
+	[ETHTOOL_A_DEBUG_HEADER]	= { .type = NLA_NESTED },
+	[ETHTOOL_A_DEBUG_MSGMASK]	= { .type = NLA_REJECT },
+};
+
+static int debug_prepare_data(const struct ethnl_req_info *req_base,
+			      struct ethnl_reply_data *reply_base,
+			      struct genl_info *info)
+{
+	struct debug_reply_data *data = DEBUG_REPDATA(reply_base);
+	struct net_device *dev = reply_base->dev;
+	int ret;
+
+	if (!dev->ethtool_ops->get_msglevel)
+		return -EOPNOTSUPP;
+
+	ret = ethnl_ops_begin(dev);
+	if (ret < 0)
+		return ret;
+	data->msg_mask = dev->ethtool_ops->get_msglevel(dev);
+	ethnl_ops_complete(dev);
+
+	return 0;
+}
+
+static int debug_reply_size(const struct ethnl_req_info *req_base,
+			    const struct ethnl_reply_data *reply_base)
+{
+	const struct debug_reply_data *data = DEBUG_REPDATA(reply_base);
+	bool compact = req_base->flags & ETHTOOL_FLAG_COMPACT_BITSETS;
+
+	return ethnl_bitset32_size(&data->msg_mask, NULL, NETIF_MSG_CLASS_COUNT,
+				   netif_msg_class_names, compact);
+}
+
+static int debug_fill_reply(struct sk_buff *skb,
+			    const struct ethnl_req_info *req_base,
+			    const struct ethnl_reply_data *reply_base)
+{
+	const struct debug_reply_data *data = DEBUG_REPDATA(reply_base);
+	bool compact = req_base->flags & ETHTOOL_FLAG_COMPACT_BITSETS;
+
+	return ethnl_put_bitset32(skb, ETHTOOL_A_DEBUG_MSGMASK, &data->msg_mask,
+				  NULL, NETIF_MSG_CLASS_COUNT,
+				  netif_msg_class_names, compact);
+}
+
+const struct ethnl_request_ops ethnl_debug_request_ops = {
+	.request_cmd		= ETHTOOL_MSG_DEBUG_GET,
+	.reply_cmd		= ETHTOOL_MSG_DEBUG_GET_REPLY,
+	.hdr_attr		= ETHTOOL_A_DEBUG_HEADER,
+	.max_attr		= ETHTOOL_A_DEBUG_MAX,
+	.req_info_size		= sizeof(struct debug_req_info),
+	.reply_data_size	= sizeof(struct debug_reply_data),
+	.request_policy		= debug_get_policy,
+
+	.prepare_data		= debug_prepare_data,
+	.reply_size		= debug_reply_size,
+	.fill_reply		= debug_fill_reply,
+};
diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index 0af43bbdb9b2..bdaf583e392b 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -213,6 +213,7 @@ ethnl_default_requests[__ETHTOOL_MSG_USER_CNT] = {
 	[ETHTOOL_MSG_LINKINFO_GET]	= &ethnl_linkinfo_request_ops,
 	[ETHTOOL_MSG_LINKMODES_GET]	= &ethnl_linkmodes_request_ops,
 	[ETHTOOL_MSG_LINKSTATE_GET]	= &ethnl_linkstate_request_ops,
+	[ETHTOOL_MSG_DEBUG_GET]		= &ethnl_debug_request_ops,
 };
 
 static struct ethnl_dump_ctx *ethnl_dump_context(struct netlink_callback *cb)
@@ -664,6 +665,13 @@ static const struct genl_ops ethtool_genl_ops[] = {
 		.dumpit	= ethnl_default_dumpit,
 		.done	= ethnl_default_done,
 	},
+	{
+		.cmd	= ETHTOOL_MSG_DEBUG_GET,
+		.doit	= ethnl_default_doit,
+		.start	= ethnl_default_start,
+		.dumpit	= ethnl_default_dumpit,
+		.done	= ethnl_default_done,
+	},
 };
 
 static const struct genl_multicast_group ethtool_nl_mcgrps[] = {
diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
index da9d6521a4eb..9bd8ef671501 100644
--- a/net/ethtool/netlink.h
+++ b/net/ethtool/netlink.h
@@ -334,6 +334,7 @@ extern const struct ethnl_request_ops ethnl_strset_request_ops;
 extern const struct ethnl_request_ops ethnl_linkinfo_request_ops;
 extern const struct ethnl_request_ops ethnl_linkmodes_request_ops;
 extern const struct ethnl_request_ops ethnl_linkstate_request_ops;
+extern const struct ethnl_request_ops ethnl_debug_request_ops;
 
 int ethnl_set_linkinfo(struct sk_buff *skb, struct genl_info *info);
 int ethnl_set_linkmodes(struct sk_buff *skb, struct genl_info *info);
diff --git a/net/ethtool/strset.c b/net/ethtool/strset.c
index 948d967f1eca..7a45c25355b8 100644
--- a/net/ethtool/strset.c
+++ b/net/ethtool/strset.c
@@ -50,6 +50,11 @@ static const struct strset_info info_template[] = {
 		.count		= __ETHTOOL_LINK_MODE_MASK_NBITS,
 		.strings	= link_mode_names,
 	},
+	[ETH_SS_MSG_CLASSES] = {
+		.per_dev	= false,
+		.count		= NETIF_MSG_CLASS_COUNT,
+		.strings	= netif_msg_class_names,
+	},
 };
 
 struct strset_req_info {
-- 
2.25.0

