Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 681C6129059
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 00:45:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726936AbfLVXpu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Dec 2019 18:45:50 -0500
Received: from mx2.suse.de ([195.135.220.15]:55314 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726903AbfLVXps (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 22 Dec 2019 18:45:48 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 8CFFBAFBA;
        Sun, 22 Dec 2019 23:45:44 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 32042E03A8; Mon, 23 Dec 2019 00:45:44 +0100 (CET)
Message-Id: <9f0cd4f631987f637812aa721e51a21e9e49eb46.1577052887.git.mkubecek@suse.cz>
In-Reply-To: <cover.1577052887.git.mkubecek@suse.cz>
References: <cover.1577052887.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH net-next v8 06/14] ethtool: provide string sets with
 STRSET_GET request
To:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jiri Pirko <jiri@resnulli.us>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Date:   Mon, 23 Dec 2019 00:45:44 +0100 (CET)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Requests a contents of one or more string sets, i.e. indexed arrays of
strings; this information is provided by ETHTOOL_GSSET_INFO and
ETHTOOL_GSTRINGS commands of ioctl interface. Unlike ioctl interface, all
information can be retrieved with one request and mulitple string sets can
be requested at once.

There are three types of requests:

  - no NLM_F_DUMP, no device: get "global" stringsets
  - no NLM_F_DUMP, with device: get string sets related to the device
  - NLM_F_DUMP, no device: get device related string sets for all devices

Client can request either all string sets of given type (global or device
related) or only specific sets. With ETHTOOL_A_STRSET_COUNTS flag set, only
set sizes (numbers of strings) are returned.

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 Documentation/networking/ethtool-netlink.rst |  75 +++-
 include/uapi/linux/ethtool.h                 |   3 +
 include/uapi/linux/ethtool_netlink.h         |  56 +++
 net/ethtool/Makefile                         |   2 +-
 net/ethtool/netlink.c                        |   8 +
 net/ethtool/netlink.h                        |   4 +
 net/ethtool/strset.c                         | 425 +++++++++++++++++++
 7 files changed, 570 insertions(+), 3 deletions(-)
 create mode 100644 net/ethtool/strset.c

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index f8066bec2903..afe0ee2ba138 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -166,6 +166,18 @@ according to message purpose:
   ``_NTF``          kernel notification
   ==============    ======================================
 
+Userspace to kernel:
+
+  ===================================== ================================
+  ``ETHTOOL_MSG_STRSET_GET``            get string set
+  ===================================== ================================
+
+Kernel to userspace:
+
+  ===================================== ================================
+  ``ETHTOOL_MSG_STRSET_GET_REPLY``      string set contents
+  ===================================== ================================
+
 ``GET`` requests are sent by userspace applications to retrieve device
 information. They usually do not contain any message specific attributes.
 Kernel replies with corresponding "GET_REPLY" message. For most types, ``GET``
@@ -197,6 +209,65 @@ an ``ACT_REPLY`` message. Performing an action also triggers a notification
 Later sections describe the format and semantics of these messages.
 
 
+STRSET_GET
+==========
+
+Requests contents of a string set as provided by ioctl commands
+``ETHTOOL_GSSET_INFO`` and ``ETHTOOL_GSTRINGS.`` String sets are not user
+writeable so that the corresponding ``STRSET_SET`` message is only used in
+kernel replies. There are two types of string sets: global (independent of
+a device, e.g. device feature names) and device specific (e.g. device private
+flags).
+
+Request contents:
+
+ +---------------------------------------+--------+------------------------+
+ | ``ETHTOOL_A_STRSET_HEADER``           | nested | request header         |
+ +---------------------------------------+--------+------------------------+
+ | ``ETHTOOL_A_STRSET_STRINGSETS``       | nested | string set to request  |
+ +-+-------------------------------------+--------+------------------------+
+ | | ``ETHTOOL_A_STRINGSETS_STRINGSET+`` | nested | one string set         |
+ +-+-+-----------------------------------+--------+------------------------+
+ | | | ``ETHTOOL_A_STRINGSET_ID``        | u32    | set id                 |
+ +-+-+-----------------------------------+--------+------------------------+
+
+Kernel response contents:
+
+ +---------------------------------------+--------+-----------------------+
+ | ``ETHTOOL_A_STRSET_HEADER``           | nested | reply header          |
+ +---------------------------------------+--------+-----------------------+
+ | ``ETHTOOL_A_STRSET_STRINGSETS``       | nested | array of string sets  |
+ +-+-------------------------------------+--------+-----------------------+
+ | | ``ETHTOOL_A_STRINGSETS_STRINGSET+`` | nested | one string set        |
+ +-+-+-----------------------------------+--------+-----------------------+
+ | | | ``ETHTOOL_A_STRINGSET_ID``        | u32    | set id                |
+ +-+-+-----------------------------------+--------+-----------------------+
+ | | | ``ETHTOOL_A_STRINGSET_COUNT``     | u32    | number of strings     |
+ +-+-+-----------------------------------+--------+-----------------------+
+ | | | ``ETHTOOL_A_STRINGSET_STRINGS``   | nested | array of strings      |
+ +-+-+-+---------------------------------+--------+-----------------------+
+ | | | | ``ETHTOOL_A_STRINGS_STRING+``   | nested | one string            |
+ +-+-+-+-+-------------------------------+--------+-----------------------+
+ | | | | | ``ETHTOOL_A_STRING_INDEX``    | u32    | string index          |
+ +-+-+-+-+-------------------------------+--------+-----------------------+
+ | | | | | ``ETHTOOL_A_STRING_VALUE``    | string | string value          |
+ +-+-+-+-+-------------------------------+--------+-----------------------+
+ | ``ETHTOOL_A_STRSET_COUNTS_ONLY``      | flag   | return only counts    |
+ +---------------------------------------+--------+-----------------------+
+
+Device identification in request header is optional. Depending on its presence
+a and ``NLM_F_DUMP`` flag, there are three type of ``STRSET_GET`` requests:
+
+ - no ``NLM_F_DUMP,`` no device: get "global" stringsets
+ - no ``NLM_F_DUMP``, with device: get string sets related to the device
+ - ``NLM_F_DUMP``, no device: get device related string sets for all devices
+
+If there is no ``ETHTOOL_A_STRSET_STRINGSETS`` array, all string sets of
+requested type are returned, otherwise only those specified in the request.
+Flag ``ETHTOOL_A_STRSET_COUNTS_ONLY`` tells kernel to only return string
+counts of the sets, not the actual strings.
+
+
 Request translation
 ===================
 
@@ -232,7 +303,7 @@ have their netlink replacement yet.
   ``ETHTOOL_GSG``                     n/a
   ``ETHTOOL_SSG``                     n/a
   ``ETHTOOL_TEST``                    n/a
-  ``ETHTOOL_GSTRINGS``                n/a
+  ``ETHTOOL_GSTRINGS``                ``ETHTOOL_MSG_STRSET_GET``
   ``ETHTOOL_PHYS_ID``                 n/a
   ``ETHTOOL_GSTATS``                  n/a
   ``ETHTOOL_GTSO``                    n/a
@@ -260,7 +331,7 @@ have their netlink replacement yet.
   ``ETHTOOL_RESET``                   n/a
   ``ETHTOOL_SRXNTUPLE``               n/a
   ``ETHTOOL_GRXNTUPLE``               n/a
-  ``ETHTOOL_GSSET_INFO``              n/a
+  ``ETHTOOL_GSSET_INFO``              ``ETHTOOL_MSG_STRSET_GET``
   ``ETHTOOL_GRXFHINDIR``              n/a
   ``ETHTOOL_SRXFHINDIR``              n/a
   ``ETHTOOL_GFEATURES``               n/a
diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
index f44155840b07..116bcbf09c74 100644
--- a/include/uapi/linux/ethtool.h
+++ b/include/uapi/linux/ethtool.h
@@ -606,6 +606,9 @@ enum ethtool_stringset {
 	ETH_SS_PHY_STATS,
 	ETH_SS_PHY_TUNABLES,
 	ETH_SS_LINK_MODES,
+
+	/* add new constants above here */
+	ETH_SS_COUNT
 };
 
 /**
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index d530ccb6f7e6..cabef1fec42a 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -14,6 +14,7 @@
 /* message types - userspace to kernel */
 enum {
 	ETHTOOL_MSG_USER_NONE,
+	ETHTOOL_MSG_STRSET_GET,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_USER_CNT,
@@ -23,6 +24,7 @@ enum {
 /* message types - kernel to userspace */
 enum {
 	ETHTOOL_MSG_KERNEL_NONE,
+	ETHTOOL_MSG_STRSET_GET_REPLY,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_KERNEL_CNT,
@@ -85,6 +87,60 @@ enum {
 	ETHTOOL_A_BITSET_MAX = __ETHTOOL_A_BITSET_CNT - 1
 };
 
+/* string sets */
+
+enum {
+	ETHTOOL_A_STRING_UNSPEC,
+	ETHTOOL_A_STRING_INDEX,			/* u32 */
+	ETHTOOL_A_STRING_VALUE,			/* string */
+
+	/* add new constants above here */
+	__ETHTOOL_A_STRING_CNT,
+	ETHTOOL_A_STRING_MAX = __ETHTOOL_A_STRING_CNT - 1
+};
+
+enum {
+	ETHTOOL_A_STRINGS_UNSPEC,
+	ETHTOOL_A_STRINGS_STRING,		/* nest - _A_STRINGS_* */
+
+	/* add new constants above here */
+	__ETHTOOL_A_STRINGS_CNT,
+	ETHTOOL_A_STRINGS_MAX = __ETHTOOL_A_STRINGS_CNT - 1
+};
+
+enum {
+	ETHTOOL_A_STRINGSET_UNSPEC,
+	ETHTOOL_A_STRINGSET_ID,			/* u32 */
+	ETHTOOL_A_STRINGSET_COUNT,		/* u32 */
+	ETHTOOL_A_STRINGSET_STRINGS,		/* nest - _A_STRINGS_* */
+
+	/* add new constants above here */
+	__ETHTOOL_A_STRINGSET_CNT,
+	ETHTOOL_A_STRINGSET_MAX = __ETHTOOL_A_STRINGSET_CNT - 1
+};
+
+enum {
+	ETHTOOL_A_STRINGSETS_UNSPEC,
+	ETHTOOL_A_STRINGSETS_STRINGSET,		/* nest - _A_STRINGSET_* */
+
+	/* add new constants above here */
+	__ETHTOOL_A_STRINGSETS_CNT,
+	ETHTOOL_A_STRINGSETS_MAX = __ETHTOOL_A_STRINGSETS_CNT - 1
+};
+
+/* STRSET */
+
+enum {
+	ETHTOOL_A_STRSET_UNSPEC,
+	ETHTOOL_A_STRSET_HEADER,		/* nest - _A_HEADER_* */
+	ETHTOOL_A_STRSET_STRINGSETS,		/* nest - _A_STRINGSETS_* */
+	ETHTOOL_A_STRSET_COUNTS_ONLY,		/* flag */
+
+	/* add new constants above here */
+	__ETHTOOL_A_STRSET_CNT,
+	ETHTOOL_A_STRSET_MAX = __ETHTOOL_A_STRSET_CNT - 1
+};
+
 /* generic netlink info */
 #define ETHTOOL_GENL_NAME "ethtool"
 #define ETHTOOL_GENL_VERSION 1
diff --git a/net/ethtool/Makefile b/net/ethtool/Makefile
index a7e6c2c85db9..efcc42c34d62 100644
--- a/net/ethtool/Makefile
+++ b/net/ethtool/Makefile
@@ -4,4 +4,4 @@ obj-y				+= ioctl.o common.o
 
 obj-$(CONFIG_ETHTOOL_NETLINK)	+= ethtool_nl.o
 
-ethtool_nl-y	:= netlink.o bitset.o
+ethtool_nl-y	:= netlink.o bitset.o strset.o
diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index ae63e8423072..7dc082bde670 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -194,6 +194,7 @@ struct ethnl_dump_ctx {
 
 static const struct ethnl_request_ops *
 ethnl_default_requests[__ETHTOOL_MSG_USER_CNT] = {
+	[ETHTOOL_MSG_STRSET_GET]	= &ethnl_strset_request_ops,
 };
 
 static struct ethnl_dump_ctx *ethnl_dump_context(struct netlink_callback *cb)
@@ -518,6 +519,13 @@ EXPORT_SYMBOL(ethtool_notify);
 /* genetlink setup */
 
 static const struct genl_ops ethtool_genl_ops[] = {
+	{
+		.cmd	= ETHTOOL_MSG_STRSET_GET,
+		.doit	= ethnl_default_doit,
+		.start	= ethnl_default_start,
+		.dumpit	= ethnl_default_dumpit,
+		.done	= ethnl_default_done,
+	},
 };
 
 static const struct genl_multicast_group ethtool_nl_mcgrps[] = {
diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
index 4c39c87ee1b9..c11b31dffd14 100644
--- a/net/ethtool/netlink.h
+++ b/net/ethtool/netlink.h
@@ -326,4 +326,8 @@ struct ethnl_request_ops {
 	void (*cleanup_data)(struct ethnl_reply_data *reply_data);
 };
 
+/* request handlers */
+
+extern const struct ethnl_request_ops ethnl_strset_request_ops;
+
 #endif /* _NET_ETHTOOL_NETLINK_H */
diff --git a/net/ethtool/strset.c b/net/ethtool/strset.c
new file mode 100644
index 000000000000..9f2243329015
--- /dev/null
+++ b/net/ethtool/strset.c
@@ -0,0 +1,425 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include <linux/ethtool.h>
+#include <linux/phy.h>
+#include "netlink.h"
+#include "common.h"
+
+struct strset_info {
+	bool per_dev;
+	bool free_strings;
+	unsigned int count;
+	const char (*strings)[ETH_GSTRING_LEN];
+};
+
+static const struct strset_info info_template[] = {
+	[ETH_SS_TEST] = {
+		.per_dev	= true,
+	},
+	[ETH_SS_STATS] = {
+		.per_dev	= true,
+	},
+	[ETH_SS_PRIV_FLAGS] = {
+		.per_dev	= true,
+	},
+	[ETH_SS_FEATURES] = {
+		.per_dev	= false,
+		.count		= ARRAY_SIZE(netdev_features_strings),
+		.strings	= netdev_features_strings,
+	},
+	[ETH_SS_RSS_HASH_FUNCS] = {
+		.per_dev	= false,
+		.count		= ARRAY_SIZE(rss_hash_func_strings),
+		.strings	= rss_hash_func_strings,
+	},
+	[ETH_SS_TUNABLES] = {
+		.per_dev	= false,
+		.count		= ARRAY_SIZE(tunable_strings),
+		.strings	= tunable_strings,
+	},
+	[ETH_SS_PHY_STATS] = {
+		.per_dev	= true,
+	},
+	[ETH_SS_PHY_TUNABLES] = {
+		.per_dev	= false,
+		.count		= ARRAY_SIZE(phy_tunable_strings),
+		.strings	= phy_tunable_strings,
+	},
+	[ETH_SS_LINK_MODES] = {
+		.per_dev	= false,
+		.count		= __ETHTOOL_LINK_MODE_MASK_NBITS,
+		.strings	= link_mode_names,
+	},
+};
+
+struct strset_req_info {
+	struct ethnl_req_info		base;
+	u32				req_ids;
+	bool				counts_only;
+};
+
+#define STRSET_REQINFO(__req_base) \
+	container_of(__req_base, struct strset_req_info, base)
+
+struct strset_reply_data {
+	struct ethnl_reply_data		base;
+	struct strset_info		sets[ETH_SS_COUNT];
+};
+
+#define STRSET_REPDATA(__reply_base) \
+	container_of(__reply_base, struct strset_reply_data, base)
+
+static const struct nla_policy strset_get_policy[ETHTOOL_A_STRSET_MAX + 1] = {
+	[ETHTOOL_A_STRSET_UNSPEC]	= { .type = NLA_REJECT },
+	[ETHTOOL_A_STRSET_HEADER]	= { .type = NLA_NESTED },
+	[ETHTOOL_A_STRSET_STRINGSETS]	= { .type = NLA_NESTED },
+};
+
+static const struct nla_policy
+get_stringset_policy[ETHTOOL_A_STRINGSET_MAX + 1] = {
+	[ETHTOOL_A_STRINGSET_UNSPEC]	= { .type = NLA_REJECT },
+	[ETHTOOL_A_STRINGSET_ID]	= { .type = NLA_U32 },
+	[ETHTOOL_A_STRINGSET_COUNT]	= { .type = NLA_REJECT },
+	[ETHTOOL_A_STRINGSET_STRINGS]	= { .type = NLA_REJECT },
+};
+
+/**
+ * strset_include() - test if a string set should be included in reply
+ * @data: pointer to request data structure
+ * @id:   id of string set to check (ETH_SS_* constants)
+ */
+static bool strset_include(const struct strset_req_info *info,
+			   const struct strset_reply_data *data, u32 id)
+{
+	bool per_dev;
+
+	BUILD_BUG_ON(ETH_SS_COUNT >= BITS_PER_BYTE * sizeof(info->req_ids));
+
+	if (info->req_ids)
+		return info->req_ids & (1U << id);
+	per_dev = data->sets[id].per_dev;
+	if (!per_dev && !data->sets[id].strings)
+		return false;
+
+	return data->base.dev ? per_dev : !per_dev;
+}
+
+static int strset_get_id(const struct nlattr *nest, u32 *val,
+			 struct netlink_ext_ack *extack)
+{
+	struct nlattr *tb[ETHTOOL_A_STRINGSET_MAX + 1];
+	int ret;
+
+	ret = nla_parse_nested(tb, ETHTOOL_A_STRINGSET_MAX, nest,
+			       get_stringset_policy, extack);
+	if (ret < 0)
+		return ret;
+	if (!tb[ETHTOOL_A_STRINGSET_ID])
+		return -EINVAL;
+
+	*val = nla_get_u32(tb[ETHTOOL_A_STRINGSET_ID]);
+	return 0;
+}
+
+static const struct nla_policy
+strset_stringsets_policy[ETHTOOL_A_STRINGSETS_MAX + 1] = {
+	[ETHTOOL_A_STRINGSETS_UNSPEC]		= { .type = NLA_REJECT },
+	[ETHTOOL_A_STRINGSETS_STRINGSET]	= { .type = NLA_NESTED },
+};
+
+static int strset_parse_request(struct ethnl_req_info *req_base,
+				struct nlattr **tb,
+				struct netlink_ext_ack *extack)
+{
+	struct strset_req_info *req_info = STRSET_REQINFO(req_base);
+	struct nlattr *nest = tb[ETHTOOL_A_STRSET_STRINGSETS];
+	struct nlattr *attr;
+	int rem, ret;
+
+	if (!nest)
+		return 0;
+	ret = nla_validate_nested(nest, ETHTOOL_A_STRINGSETS_MAX,
+				  strset_stringsets_policy, extack);
+	if (ret < 0)
+		return ret;
+
+	req_info->counts_only = tb[ETHTOOL_A_STRSET_COUNTS_ONLY];
+	nla_for_each_nested(attr, nest, rem) {
+		u32 id;
+
+		if (WARN_ONCE(nla_type(attr) != ETHTOOL_A_STRINGSETS_STRINGSET,
+			      "unexpected attrtype %u in ETHTOOL_A_STRSET_STRINGSETS\n",
+			      nla_type(attr)))
+			return -EINVAL;
+
+		ret = strset_get_id(attr, &id, extack);
+		if (ret < 0)
+			return ret;
+		if (ret >= ETH_SS_COUNT) {
+			NL_SET_ERR_MSG_ATTR(extack, attr,
+					    "unknown string set id");
+			return -EOPNOTSUPP;
+		}
+
+		req_info->req_ids |= (1U << id);
+	}
+
+	return 0;
+}
+
+static void strset_cleanup_data(struct ethnl_reply_data *reply_base)
+{
+	struct strset_reply_data *data = STRSET_REPDATA(reply_base);
+	unsigned int i;
+
+	for (i = 0; i < ETH_SS_COUNT; i++)
+		if (data->sets[i].free_strings) {
+			kfree(data->sets[i].strings);
+			data->sets[i].strings = NULL;
+			data->sets[i].free_strings = false;
+		}
+}
+
+static int strset_prepare_set(struct strset_info *info, struct net_device *dev,
+			      unsigned int id, bool counts_only)
+{
+	const struct ethtool_ops *ops = dev->ethtool_ops;
+	void *strings;
+	int count, ret;
+
+	if (id == ETH_SS_PHY_STATS && dev->phydev &&
+	    !ops->get_ethtool_phy_stats)
+		ret = phy_ethtool_get_sset_count(dev->phydev);
+	else if (ops->get_sset_count && ops->get_strings)
+		ret = ops->get_sset_count(dev, id);
+	else
+		ret = -EOPNOTSUPP;
+	if (ret <= 0) {
+		info->count = 0;
+		return 0;
+	}
+
+	count = ret;
+	if (!counts_only) {
+		strings = kcalloc(count, ETH_GSTRING_LEN, GFP_KERNEL);
+		if (!strings)
+			return -ENOMEM;
+		if (id == ETH_SS_PHY_STATS && dev->phydev &&
+		    !ops->get_ethtool_phy_stats)
+			phy_ethtool_get_strings(dev->phydev, strings);
+		else
+			ops->get_strings(dev, id, strings);
+		info->strings = strings;
+		info->free_strings = true;
+	}
+	info->count = count;
+
+	return 0;
+}
+
+static int strset_prepare_data(const struct ethnl_req_info *req_base,
+			       struct ethnl_reply_data *reply_base,
+			       struct genl_info *info)
+{
+	const struct strset_req_info *req_info = STRSET_REQINFO(req_base);
+	struct strset_reply_data *data = STRSET_REPDATA(reply_base);
+	struct net_device *dev = reply_base->dev;
+	unsigned int i;
+	int ret;
+
+	BUILD_BUG_ON(ARRAY_SIZE(info_template) != ETH_SS_COUNT);
+	memcpy(&data->sets, &info_template, sizeof(data->sets));
+
+	if (!dev) {
+		for (i = 0; i < ETH_SS_COUNT; i++) {
+			if ((req_info->req_ids & (1U << i)) &&
+			    data->sets[i].per_dev) {
+				if (info)
+					GENL_SET_ERR_MSG(info, "requested per device strings without dev");
+				return -EINVAL;
+			}
+		}
+	}
+
+	ret = ethnl_ops_begin(dev);
+	if (ret < 0)
+		goto err_strset;
+	for (i = 0; i < ETH_SS_COUNT; i++) {
+		if (!strset_include(req_info, data, i) ||
+		    !data->sets[i].per_dev)
+			continue;
+
+		ret = strset_prepare_set(&data->sets[i], dev, i,
+					 req_info->counts_only);
+		if (ret < 0)
+			goto err_ops;
+	}
+	ethnl_ops_complete(dev);
+
+	return 0;
+err_ops:
+	ethnl_ops_complete(dev);
+err_strset:
+	strset_cleanup_data(reply_base);
+	return ret;
+}
+
+/* calculate size of ETHTOOL_A_STRSET_STRINGSET nest for one string set */
+static int strset_set_size(const struct strset_info *info, bool counts_only)
+{
+	unsigned int len = 0;
+	unsigned int i;
+
+	if (info->count == 0)
+		return 0;
+	if (counts_only)
+		return nla_total_size(2 * nla_total_size(sizeof(u32)));
+
+	for (i = 0; i < info->count; i++) {
+		const char *str = info->strings[i];
+
+		/* ETHTOOL_A_STRING_INDEX, ETHTOOL_A_STRING_VALUE, nest */
+		len += nla_total_size(nla_total_size(sizeof(u32)) +
+				      ethnl_strz_size(str));
+	}
+	/* ETHTOOL_A_STRINGSET_ID, ETHTOOL_A_STRINGSET_COUNT */
+	len = 2 * nla_total_size(sizeof(u32)) + nla_total_size(len);
+
+	return nla_total_size(len);
+}
+
+static int strset_reply_size(const struct ethnl_req_info *req_base,
+			     const struct ethnl_reply_data *reply_base)
+{
+	const struct strset_req_info *req_info = STRSET_REQINFO(req_base);
+	const struct strset_reply_data *data = STRSET_REPDATA(reply_base);
+	unsigned int i;
+	int len = 0;
+	int ret;
+
+	len += ethnl_reply_header_size();
+	for (i = 0; i < ETH_SS_COUNT; i++) {
+		const struct strset_info *set_info = &data->sets[i];
+
+		if (!strset_include(req_info, data, i))
+			continue;
+
+		ret = strset_set_size(set_info, req_info->counts_only);
+		if (ret < 0)
+			return ret;
+		len += ret;
+	}
+
+	return len;
+}
+
+/* fill one string into reply */
+static int strset_fill_string(struct sk_buff *skb,
+			      const struct strset_info *set_info, u32 idx)
+{
+	struct nlattr *string_attr;
+	const char *value;
+
+	value = set_info->strings[idx];
+
+	string_attr = nla_nest_start(skb, ETHTOOL_A_STRINGS_STRING);
+	if (!string_attr)
+		return -EMSGSIZE;
+	if (nla_put_u32(skb, ETHTOOL_A_STRING_INDEX, idx) ||
+	    ethnl_put_strz(skb, ETHTOOL_A_STRING_VALUE, value))
+		goto nla_put_failure;
+	nla_nest_end(skb, string_attr);
+
+	return 0;
+nla_put_failure:
+	nla_nest_cancel(skb, string_attr);
+	return -EMSGSIZE;
+}
+
+/* fill one string set into reply */
+static int strset_fill_set(struct sk_buff *skb,
+			   const struct strset_info *set_info, u32 id,
+			   bool counts_only)
+{
+	struct nlattr *stringset_attr;
+	struct nlattr *strings_attr;
+	unsigned int i;
+
+	if (!set_info->per_dev && !set_info->strings)
+		return -EOPNOTSUPP;
+	if (set_info->count == 0)
+		return 0;
+	stringset_attr = nla_nest_start(skb, ETHTOOL_A_STRINGSETS_STRINGSET);
+	if (!stringset_attr)
+		return -EMSGSIZE;
+
+	if (nla_put_u32(skb, ETHTOOL_A_STRINGSET_ID, id) ||
+	    nla_put_u32(skb, ETHTOOL_A_STRINGSET_COUNT, set_info->count))
+		goto nla_put_failure;
+
+	if (!counts_only) {
+		strings_attr = nla_nest_start(skb, ETHTOOL_A_STRINGSET_STRINGS);
+		if (!strings_attr)
+			goto nla_put_failure;
+		for (i = 0; i < set_info->count; i++) {
+			if (strset_fill_string(skb, set_info, i) < 0)
+				goto nla_put_failure;
+		}
+		nla_nest_end(skb, strings_attr);
+	}
+
+	nla_nest_end(skb, stringset_attr);
+	return 0;
+
+nla_put_failure:
+	nla_nest_cancel(skb, stringset_attr);
+	return -EMSGSIZE;
+}
+
+static int strset_fill_reply(struct sk_buff *skb,
+			     const struct ethnl_req_info *req_base,
+			     const struct ethnl_reply_data *reply_base)
+{
+	const struct strset_req_info *req_info = STRSET_REQINFO(req_base);
+	const struct strset_reply_data *data = STRSET_REPDATA(reply_base);
+	struct nlattr *nest;
+	unsigned int i;
+	int ret;
+
+	nest = nla_nest_start(skb, ETHTOOL_A_STRSET_STRINGSETS);
+	if (!nest)
+		return -EMSGSIZE;
+
+	for (i = 0; i < ETH_SS_COUNT; i++) {
+		if (strset_include(req_info, data, i)) {
+			ret = strset_fill_set(skb, &data->sets[i], i,
+					      req_info->counts_only);
+			if (ret < 0)
+				goto nla_put_failure;
+		}
+	}
+
+	nla_nest_end(skb, nest);
+	return 0;
+
+nla_put_failure:
+	nla_nest_cancel(skb, nest);
+	return ret;
+}
+
+const struct ethnl_request_ops ethnl_strset_request_ops = {
+	.request_cmd		= ETHTOOL_MSG_STRSET_GET,
+	.reply_cmd		= ETHTOOL_MSG_STRSET_GET_REPLY,
+	.hdr_attr		= ETHTOOL_A_STRSET_HEADER,
+	.max_attr		= ETHTOOL_A_STRSET_MAX,
+	.req_info_size		= sizeof(struct strset_req_info),
+	.reply_data_size	= sizeof(struct strset_reply_data),
+	.request_policy		= strset_get_policy,
+	.allow_nodev_do		= true,
+
+	.parse_request		= strset_parse_request,
+	.prepare_data		= strset_prepare_data,
+	.reply_size		= strset_reply_size,
+	.fill_reply		= strset_fill_reply,
+	.cleanup_data		= strset_cleanup_data,
+};
-- 
2.24.1

