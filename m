Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92B09183A3E
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 21:08:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727104AbgCLUHx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 16:07:53 -0400
Received: from mx2.suse.de ([195.135.220.15]:45128 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727059AbgCLUHw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Mar 2020 16:07:52 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id CFE86AD31;
        Thu, 12 Mar 2020 20:07:48 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 7BF47E0C79; Thu, 12 Mar 2020 21:07:48 +0100 (CET)
Message-Id: <8a94a9c5fe0ef2e81d92f21d98d4f2faf2f7bfb5.1584043144.git.mkubecek@suse.cz>
In-Reply-To: <cover.1584043144.git.mkubecek@suse.cz>
References: <cover.1584043144.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH net-next v2 03/15] ethtool: provide netdev features with
 FEATURES_GET request
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Jiri Pirko <jiri@resnulli.us>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Date:   Thu, 12 Mar 2020 21:07:48 +0100 (CET)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement FEATURES_GET request to get network device features. These are
traditionally available via ETHTOOL_GFEATURES ioctl request.

v2:
  - style cleanup suggested by Jakub Kicinski

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
Reviewed-by: Jakub Kicinski <kuba@kernel.org>
---
 Documentation/networking/ethtool-netlink.rst |  51 ++++++--
 include/uapi/linux/ethtool_netlink.h         |  17 +++
 net/ethtool/Makefile                         |   2 +-
 net/ethtool/common.h                         |   2 +
 net/ethtool/features.c                       | 131 +++++++++++++++++++
 net/ethtool/ioctl.c                          |   2 -
 net/ethtool/netlink.c                        |   8 ++
 net/ethtool/netlink.h                        |   1 +
 8 files changed, 202 insertions(+), 12 deletions(-)
 create mode 100644 net/ethtool/features.c

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index f1f868479ceb..5713abf98534 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -189,6 +189,7 @@ Userspace to kernel:
   ``ETHTOOL_MSG_DEBUG_SET``             set debugging settings
   ``ETHTOOL_MSG_WOL_GET``               get wake-on-lan settings
   ``ETHTOOL_MSG_WOL_SET``               set wake-on-lan settings
+  ``ETHTOOL_MSG_FEATURES_GET``          get device features
   ===================================== ================================
 
 Kernel to userspace:
@@ -204,6 +205,7 @@ Kernel to userspace:
   ``ETHTOOL_MSG_DEBUG_NTF``             debugging settings notification
   ``ETHTOOL_MSG_WOL_GET_REPLY``         wake-on-lan settings
   ``ETHTOOL_MSG_WOL_NTF``               wake-on-lan settings notification
+  ``ETHTOOL_MSG_FEATURES_GET_REPLY``    device features
   ===================================== =================================
 
 ``GET`` requests are sent by userspace applications to retrieve device
@@ -521,6 +523,37 @@ Request contents:
 ``WAKE_MAGICSECURE`` mode.
 
 
+FEATURES_GET
+============
+
+Gets netdev features like ``ETHTOOL_GFEATURES`` ioctl request.
+
+Request contents:
+
+  ====================================  ======  ==========================
+  ``ETHTOOL_A_FEATURES_HEADER``         nested  request header
+  ====================================  ======  ==========================
+
+Kernel response contents:
+
+  ====================================  ======  ==========================
+  ``ETHTOOL_A_FEATURES_HEADER``         nested  reply header
+  ``ETHTOOL_A_FEATURES_HW``             bitset  dev->hw_features
+  ``ETHTOOL_A_FEATURES_WANTED``         bitset  dev->wanted_features
+  ``ETHTOOL_A_FEATURES_ACTIVE``         bitset  dev->features
+  ``ETHTOOL_A_FEATURES_NOCHANGE``       bitset  NETIF_F_NEVER_CHANGE
+  ====================================  ======  ==========================
+
+Bitmaps in kernel response have the same meaning as bitmaps used in ioctl
+interference but attribute names are different (they are based on
+corresponding members of struct net_device). Legacy "flags" are not provided,
+if userspace needs them (most likely only ethtool for backward compatibility),
+it can calculate their values from related feature bits itself.
+ETHA_FEATURES_HW uses mask consisting of all features recognized by kernel (to
+provide all names when using verbose bitmap format), the other three use no
+mask (simple bit lists).
+
+
 Request translation
 ===================
 
@@ -551,30 +584,30 @@ have their netlink replacement yet.
   ``ETHTOOL_SRINGPARAM``              n/a
   ``ETHTOOL_GPAUSEPARAM``             n/a
   ``ETHTOOL_SPAUSEPARAM``             n/a
-  ``ETHTOOL_GRXCSUM``                 n/a
+  ``ETHTOOL_GRXCSUM``                 ``ETHTOOL_MSG_FEATURES_GET``
   ``ETHTOOL_SRXCSUM``                 n/a
-  ``ETHTOOL_GTXCSUM``                 n/a
+  ``ETHTOOL_GTXCSUM``                 ``ETHTOOL_MSG_FEATURES_GET``
   ``ETHTOOL_STXCSUM``                 n/a
-  ``ETHTOOL_GSG``                     n/a
+  ``ETHTOOL_GSG``                     ``ETHTOOL_MSG_FEATURES_GET``
   ``ETHTOOL_SSG``                     n/a
   ``ETHTOOL_TEST``                    n/a
   ``ETHTOOL_GSTRINGS``                ``ETHTOOL_MSG_STRSET_GET``
   ``ETHTOOL_PHYS_ID``                 n/a
   ``ETHTOOL_GSTATS``                  n/a
-  ``ETHTOOL_GTSO``                    n/a
+  ``ETHTOOL_GTSO``                    ``ETHTOOL_MSG_FEATURES_GET``
   ``ETHTOOL_STSO``                    n/a
   ``ETHTOOL_GPERMADDR``               rtnetlink ``RTM_GETLINK``
-  ``ETHTOOL_GUFO``                    n/a
+  ``ETHTOOL_GUFO``                    ``ETHTOOL_MSG_FEATURES_GET``
   ``ETHTOOL_SUFO``                    n/a
-  ``ETHTOOL_GGSO``                    n/a
+  ``ETHTOOL_GGSO``                    ``ETHTOOL_MSG_FEATURES_GET``
   ``ETHTOOL_SGSO``                    n/a
-  ``ETHTOOL_GFLAGS``                  n/a
+  ``ETHTOOL_GFLAGS``                  ``ETHTOOL_MSG_FEATURES_GET``
   ``ETHTOOL_SFLAGS``                  n/a
   ``ETHTOOL_GPFLAGS``                 n/a
   ``ETHTOOL_SPFLAGS``                 n/a
   ``ETHTOOL_GRXFH``                   n/a
   ``ETHTOOL_SRXFH``                   n/a
-  ``ETHTOOL_GGRO``                    n/a
+  ``ETHTOOL_GGRO``                    ``ETHTOOL_MSG_FEATURES_GET``
   ``ETHTOOL_SGRO``                    n/a
   ``ETHTOOL_GRXRINGS``                n/a
   ``ETHTOOL_GRXCLSRLCNT``             n/a
@@ -589,7 +622,7 @@ have their netlink replacement yet.
   ``ETHTOOL_GSSET_INFO``              ``ETHTOOL_MSG_STRSET_GET``
   ``ETHTOOL_GRXFHINDIR``              n/a
   ``ETHTOOL_SRXFHINDIR``              n/a
-  ``ETHTOOL_GFEATURES``               n/a
+  ``ETHTOOL_GFEATURES``               ``ETHTOOL_MSG_FEATURES_GET``
   ``ETHTOOL_SFEATURES``               n/a
   ``ETHTOOL_GCHANNELS``               n/a
   ``ETHTOOL_SCHANNELS``               n/a
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index 7e0b460f872c..d0cc7a0334c8 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -24,6 +24,7 @@ enum {
 	ETHTOOL_MSG_DEBUG_SET,
 	ETHTOOL_MSG_WOL_GET,
 	ETHTOOL_MSG_WOL_SET,
+	ETHTOOL_MSG_FEATURES_GET,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_USER_CNT,
@@ -43,6 +44,7 @@ enum {
 	ETHTOOL_MSG_DEBUG_NTF,
 	ETHTOOL_MSG_WOL_GET_REPLY,
 	ETHTOOL_MSG_WOL_NTF,
+	ETHTOOL_MSG_FEATURES_GET_REPLY,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_KERNEL_CNT,
@@ -228,6 +230,21 @@ enum {
 	ETHTOOL_A_WOL_MAX = __ETHTOOL_A_WOL_CNT - 1
 };
 
+/* FEATURES */
+
+enum {
+	ETHTOOL_A_FEATURES_UNSPEC,
+	ETHTOOL_A_FEATURES_HEADER,			/* nest - _A_HEADER_* */
+	ETHTOOL_A_FEATURES_HW,				/* bitset */
+	ETHTOOL_A_FEATURES_WANTED,			/* bitset */
+	ETHTOOL_A_FEATURES_ACTIVE,			/* bitset */
+	ETHTOOL_A_FEATURES_NOCHANGE,			/* bitset */
+
+	/* add new constants above here */
+	__ETHTOOL_A_FEATURES_CNT,
+	ETHTOOL_A_FEATURES_MAX = __ETHTOOL_A_FEATURES_CNT - 1
+};
+
 /* generic netlink info */
 #define ETHTOOL_GENL_NAME "ethtool"
 #define ETHTOOL_GENL_VERSION 1
diff --git a/net/ethtool/Makefile b/net/ethtool/Makefile
index 424545a4aaec..5be8c9ab26d1 100644
--- a/net/ethtool/Makefile
+++ b/net/ethtool/Makefile
@@ -5,4 +5,4 @@ obj-y				+= ioctl.o common.o
 obj-$(CONFIG_ETHTOOL_NETLINK)	+= ethtool_nl.o
 
 ethtool_nl-y	:= netlink.o bitset.o strset.o linkinfo.o linkmodes.o \
-		   linkstate.o debug.o wol.o
+		   linkstate.o debug.o wol.o features.o
diff --git a/net/ethtool/common.h b/net/ethtool/common.h
index 40ba74e0b9bb..7dc1163800a7 100644
--- a/net/ethtool/common.h
+++ b/net/ethtool/common.h
@@ -6,6 +6,8 @@
 #include <linux/netdevice.h>
 #include <linux/ethtool.h>
 
+#define ETHTOOL_DEV_FEATURE_WORDS	DIV_ROUND_UP(NETDEV_FEATURE_COUNT, 32)
+
 /* compose link mode index from speed, type and duplex */
 #define ETHTOOL_LINK_MODE(speed, type, duplex) \
 	ETHTOOL_LINK_MODE_ ## speed ## base ## type ## _ ## duplex ## _BIT
diff --git a/net/ethtool/features.c b/net/ethtool/features.c
new file mode 100644
index 000000000000..a0cc2b969053
--- /dev/null
+++ b/net/ethtool/features.c
@@ -0,0 +1,131 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include "netlink.h"
+#include "common.h"
+#include "bitset.h"
+
+struct features_req_info {
+	struct ethnl_req_info	base;
+};
+
+struct features_reply_data {
+	struct ethnl_reply_data	base;
+	u32			hw[ETHTOOL_DEV_FEATURE_WORDS];
+	u32			wanted[ETHTOOL_DEV_FEATURE_WORDS];
+	u32			active[ETHTOOL_DEV_FEATURE_WORDS];
+	u32			nochange[ETHTOOL_DEV_FEATURE_WORDS];
+	u32			all[ETHTOOL_DEV_FEATURE_WORDS];
+};
+
+#define FEATURES_REPDATA(__reply_base) \
+	container_of(__reply_base, struct features_reply_data, base)
+
+static const struct nla_policy
+features_get_policy[ETHTOOL_A_FEATURES_MAX + 1] = {
+	[ETHTOOL_A_FEATURES_UNSPEC]	= { .type = NLA_REJECT },
+	[ETHTOOL_A_FEATURES_HEADER]	= { .type = NLA_NESTED },
+	[ETHTOOL_A_FEATURES_HW]		= { .type = NLA_REJECT },
+	[ETHTOOL_A_FEATURES_WANTED]	= { .type = NLA_REJECT },
+	[ETHTOOL_A_FEATURES_ACTIVE]	= { .type = NLA_REJECT },
+	[ETHTOOL_A_FEATURES_NOCHANGE]	= { .type = NLA_REJECT },
+};
+
+static void ethnl_features_to_bitmap32(u32 *dest, netdev_features_t src)
+{
+	unsigned int i;
+
+	for (i = 0; i < ETHTOOL_DEV_FEATURE_WORDS; i++)
+		dest[i] = src >> (32 * i);
+}
+
+static int features_prepare_data(const struct ethnl_req_info *req_base,
+				 struct ethnl_reply_data *reply_base,
+				 struct genl_info *info)
+{
+	struct features_reply_data *data = FEATURES_REPDATA(reply_base);
+	struct net_device *dev = reply_base->dev;
+	netdev_features_t all_features;
+
+	ethnl_features_to_bitmap32(data->hw, dev->hw_features);
+	ethnl_features_to_bitmap32(data->wanted, dev->wanted_features);
+	ethnl_features_to_bitmap32(data->active, dev->features);
+	ethnl_features_to_bitmap32(data->nochange, NETIF_F_NEVER_CHANGE);
+	all_features = GENMASK_ULL(NETDEV_FEATURE_COUNT - 1, 0);
+	ethnl_features_to_bitmap32(data->all, all_features);
+
+	return 0;
+}
+
+static int features_reply_size(const struct ethnl_req_info *req_base,
+			       const struct ethnl_reply_data *reply_base)
+{
+	const struct features_reply_data *data = FEATURES_REPDATA(reply_base);
+	bool compact = req_base->flags & ETHTOOL_FLAG_COMPACT_BITSETS;
+	unsigned int len = 0;
+	int ret;
+
+	ret = ethnl_bitset32_size(data->hw, data->all, NETDEV_FEATURE_COUNT,
+				  netdev_features_strings, compact);
+	if (ret < 0)
+		return ret;
+	len += ret;
+	ret = ethnl_bitset32_size(data->wanted, NULL, NETDEV_FEATURE_COUNT,
+				  netdev_features_strings, compact);
+	if (ret < 0)
+		return ret;
+	len += ret;
+	ret = ethnl_bitset32_size(data->active, NULL, NETDEV_FEATURE_COUNT,
+				  netdev_features_strings, compact);
+	if (ret < 0)
+		return ret;
+	len += ret;
+	ret = ethnl_bitset32_size(data->nochange, NULL, NETDEV_FEATURE_COUNT,
+				  netdev_features_strings, compact);
+	if (ret < 0)
+		return ret;
+	len += ret;
+
+	return len;
+}
+
+static int features_fill_reply(struct sk_buff *skb,
+			       const struct ethnl_req_info *req_base,
+			       const struct ethnl_reply_data *reply_base)
+{
+	const struct features_reply_data *data = FEATURES_REPDATA(reply_base);
+	bool compact = req_base->flags & ETHTOOL_FLAG_COMPACT_BITSETS;
+	int ret;
+
+	ret = ethnl_put_bitset32(skb, ETHTOOL_A_FEATURES_HW, data->hw,
+				 data->all, NETDEV_FEATURE_COUNT,
+				 netdev_features_strings, compact);
+	if (ret < 0)
+		return ret;
+	ret = ethnl_put_bitset32(skb, ETHTOOL_A_FEATURES_WANTED, data->wanted,
+				 NULL, NETDEV_FEATURE_COUNT,
+				 netdev_features_strings, compact);
+	if (ret < 0)
+		return ret;
+	ret = ethnl_put_bitset32(skb, ETHTOOL_A_FEATURES_ACTIVE, data->active,
+				 NULL, NETDEV_FEATURE_COUNT,
+				 netdev_features_strings, compact);
+	if (ret < 0)
+		return ret;
+	return ethnl_put_bitset32(skb, ETHTOOL_A_FEATURES_NOCHANGE,
+				  data->nochange, NULL, NETDEV_FEATURE_COUNT,
+				  netdev_features_strings, compact);
+}
+
+const struct ethnl_request_ops ethnl_features_request_ops = {
+	.request_cmd		= ETHTOOL_MSG_FEATURES_GET,
+	.reply_cmd		= ETHTOOL_MSG_FEATURES_GET_REPLY,
+	.hdr_attr		= ETHTOOL_A_FEATURES_HEADER,
+	.max_attr		= ETHTOOL_A_FEATURES_MAX,
+	.req_info_size		= sizeof(struct features_req_info),
+	.reply_data_size	= sizeof(struct features_reply_data),
+	.request_policy		= features_get_policy,
+
+	.prepare_data		= features_prepare_data,
+	.reply_size		= features_reply_size,
+	.fill_reply		= features_fill_reply,
+};
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index ae97c82c7052..45d1bf1764b7 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -56,8 +56,6 @@ EXPORT_SYMBOL(ethtool_op_get_ts_info);
 
 /* Handlers for each ethtool command */
 
-#define ETHTOOL_DEV_FEATURE_WORDS	((NETDEV_FEATURE_COUNT + 31) / 32)
-
 static int ethtool_get_features(struct net_device *dev, void __user *useraddr)
 {
 	struct ethtool_gfeatures cmd = {
diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index 8eca55122ef3..e451a75e9577 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -215,6 +215,7 @@ ethnl_default_requests[__ETHTOOL_MSG_USER_CNT] = {
 	[ETHTOOL_MSG_LINKSTATE_GET]	= &ethnl_linkstate_request_ops,
 	[ETHTOOL_MSG_DEBUG_GET]		= &ethnl_debug_request_ops,
 	[ETHTOOL_MSG_WOL_GET]		= &ethnl_wol_request_ops,
+	[ETHTOOL_MSG_FEATURES_GET]	= &ethnl_features_request_ops,
 };
 
 static struct ethnl_dump_ctx *ethnl_dump_context(struct netlink_callback *cb)
@@ -695,6 +696,13 @@ static const struct genl_ops ethtool_genl_ops[] = {
 		.flags	= GENL_UNS_ADMIN_PERM,
 		.doit	= ethnl_set_wol,
 	},
+	{
+		.cmd	= ETHTOOL_MSG_FEATURES_GET,
+		.doit	= ethnl_default_doit,
+		.start	= ethnl_default_start,
+		.dumpit	= ethnl_default_dumpit,
+		.done	= ethnl_default_done,
+	},
 };
 
 static const struct genl_multicast_group ethtool_nl_mcgrps[] = {
diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
index 961708290074..be2325ea8493 100644
--- a/net/ethtool/netlink.h
+++ b/net/ethtool/netlink.h
@@ -337,6 +337,7 @@ extern const struct ethnl_request_ops ethnl_linkmodes_request_ops;
 extern const struct ethnl_request_ops ethnl_linkstate_request_ops;
 extern const struct ethnl_request_ops ethnl_debug_request_ops;
 extern const struct ethnl_request_ops ethnl_wol_request_ops;
+extern const struct ethnl_request_ops ethnl_features_request_ops;
 
 int ethnl_set_linkinfo(struct sk_buff *skb, struct genl_info *info);
 int ethnl_set_linkmodes(struct sk_buff *skb, struct genl_info *info);
-- 
2.25.1

