Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C10E5CED3
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 13:50:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727193AbfGBLud (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 07:50:33 -0400
Received: from mx2.suse.de ([195.135.220.15]:39028 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727059AbfGBLuc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jul 2019 07:50:32 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id AD4CAB01F;
        Tue,  2 Jul 2019 11:50:29 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 54A5CE0159; Tue,  2 Jul 2019 13:50:29 +0200 (CEST)
Message-Id: <3c30527bef64c030078a1e305613080bb372cbe6.1562067622.git.mkubecek@suse.cz>
In-Reply-To: <cover.1562067622.git.mkubecek@suse.cz>
References: <cover.1562067622.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH net-next v6 10/15] ethtool: provide string sets with
 STRSET_GET request
To:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jiri Pirko <jiri@resnulli.us>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Date:   Tue,  2 Jul 2019 13:50:29 +0200 (CEST)
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
 Documentation/networking/ethtool-netlink.txt |  57 ++-
 include/uapi/linux/ethtool.h                 |   2 +
 include/uapi/linux/ethtool_netlink.h         |  60 +++
 net/ethtool/Makefile                         |   2 +-
 net/ethtool/netlink.c                        |   8 +
 net/ethtool/netlink.h                        |   4 +
 net/ethtool/strset.c                         | 453 +++++++++++++++++++
 7 files changed, 583 insertions(+), 3 deletions(-)
 create mode 100644 net/ethtool/strset.c

diff --git a/Documentation/networking/ethtool-netlink.txt b/Documentation/networking/ethtool-netlink.txt
index 4636682c551f..21e5030734aa 100644
--- a/Documentation/networking/ethtool-netlink.txt
+++ b/Documentation/networking/ethtool-netlink.txt
@@ -148,6 +148,14 @@ according to message purpose:
     _ACT_REPLY  kernel reply to an ACT request
     _NTF	kernel notification
 
+Userspace to kernel:
+
+    ETHTOOL_MSG_STRSET_GET		get string set
+
+Kernel to userspace:
+
+    ETHTOOL_MSG_STRSET_GET_REPLY	string set contents
+
 "GET" requests are sent by userspace applications to retrieve device
 information. They usually do not contain any message specific attributes.
 Kernel replies with corresponding "GET_REPLY" message. For most types, "GET"
@@ -178,6 +186,51 @@ action also triggers a notification ("NTF" message).
 Later sections describe the format and semantics of these messages.
 
 
+STRSET_GET
+----------
+
+Requests contents of a string set as provided by ioctl commands
+ETHTOOL_GSSET_INFO and ETHTOOL_GSTRINGS. String sets are not user writeable so
+that the corresponding SET_STRSET message is only used in kernel replies.
+There are two types of string sets: global (independent of a device, e.g.
+device feature names) and device specific (e.g. device private flags).
+
+Request contents:
+
+    ETHTOOL_A_STRSET_HEADER		(nested)	request header
+    ETHTOOL_A_STRSET_STRINGSETS		(nested)	string set to request
+      ETHTOOL_A_STRINGSETS_STRINGSET+     (nested)	  one string set
+        ETHTOOL_A_STRINGSET_ID		    (u32)	    set id
+
+Request specific flag:
+
+    ETHTOOL_RF_STRSET_COUNTS		send only string counts in reply
+
+Kernel response contents:
+
+    ETHTOOL_A_STRSET_HEADER		(nested)	reply header
+    ETHTOOL_A_STRSET_STRINGSETS		(nested)	array of string sets
+      ETHTOOL_A_STRINGSETS_STRINGSET+     (nested)	  one string set
+        ETHTOOL_A_STRINGSET_ID		    (u32)	    set id
+        ETHTOOL_A_STRINGSET_COUNT	    (u32)	    number of strings
+        ETHTOOL_A_STRINGSET_STRINGS	    (nested)	    array of strings
+          ETHTOOL_A_STRINGS_STRING+           (nested)        one string
+            ETHTOOL_A_STRING_INDEX		(u32)		string index
+            ETHTOOL_A_STRING_VALUE		(string)	string value
+
+Device identification in request header is optional. Depending on its presence
+a and NLM_F_DUMP flag, there are three type of STRSET_GET requests:
+
+ - no NLM_F_DUMP, no device: get "global" stringsets
+ - no NLM_F_DUMP, with device: get string sets related to the device
+ - NLM_F_DUMP, no device: get device related string sets for all devices
+
+If there is no ETHTOOL_A_STRSET_STRINGSETS array, all string sets of requested
+type are returned, otherwise only those specified in the request.
+Flag ETHTOOL_A_STRSET_COUNTS tells kernel to only return string counts of the
+sets, not the actual strings.
+
+
 Request translation
 -------------------
 
@@ -212,7 +265,7 @@ ETHTOOL_STXCSUM			n/a
 ETHTOOL_GSG			n/a
 ETHTOOL_SSG			n/a
 ETHTOOL_TEST			n/a
-ETHTOOL_GSTRINGS		n/a
+ETHTOOL_GSTRINGS		ETHTOOL_MSG_STRSET_GET
 ETHTOOL_PHYS_ID			n/a
 ETHTOOL_GSTATS			n/a
 ETHTOOL_GTSO			n/a
@@ -240,7 +293,7 @@ ETHTOOL_FLASHDEV		n/a
 ETHTOOL_RESET			n/a
 ETHTOOL_SRXNTUPLE		n/a
 ETHTOOL_GRXNTUPLE		n/a
-ETHTOOL_GSSET_INFO		n/a
+ETHTOOL_GSSET_INFO		ETHTOOL_MSG_STRSET_GET
 ETHTOOL_GRXFHINDIR		n/a
 ETHTOOL_SRXFHINDIR		n/a
 ETHTOOL_GFEATURES		n/a
diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
index dd06302aa93e..4e4e28e77c7a 100644
--- a/include/uapi/linux/ethtool.h
+++ b/include/uapi/linux/ethtool.h
@@ -582,6 +582,8 @@ enum ethtool_stringset {
 	ETH_SS_TUNABLES,
 	ETH_SS_PHY_STATS,
 	ETH_SS_PHY_TUNABLES,
+
+	ETH_SS_COUNT
 };
 
 /**
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index 8938a1f09057..11b8519d2c1d 100644
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
@@ -87,6 +89,64 @@ enum {
 	ETHTOOL_A_BITSET_MAX = (__ETHTOOL_A_BITSET_CNT - 1)
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
+	ETHTOOL_A_STRING_MAX = (__ETHTOOL_A_STRING_CNT - 1)
+};
+
+enum {
+	ETHTOOL_A_STRINGS_UNSPEC,
+	ETHTOOL_A_STRINGS_STRING,		/* nest - _A_STRINGS_* */
+
+	/* add new constants above here */
+	__ETHTOOL_A_STRINGS_CNT,
+	ETHTOOL_A_STRINGS_MAX = (__ETHTOOL_A_STRINGS_CNT - 1)
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
+	ETHTOOL_A_STRINGSET_MAX = (__ETHTOOL_A_STRINGSET_CNT - 1)
+};
+
+/* STRSET */
+
+enum {
+	ETHTOOL_A_STRSET_UNSPEC,
+	ETHTOOL_A_STRSET_HEADER,		/* nest - _A_HEADER_* */
+	ETHTOOL_A_STRSET_STRINGSETS,		/* nest - _A_STRINGSETS_* */
+
+	/* add new constants above here */
+	__ETHTOOL_A_STRSET_CNT,
+	ETHTOOL_A_STRSET_MAX = (__ETHTOOL_A_STRSET_CNT - 1)
+};
+
+enum {
+	ETHTOOL_A_STRINGSETS_UNSPEC,
+	ETHTOOL_A_STRINGSETS_STRINGSET,		/* nest - _A_STRINGSET_* */
+
+	/* add new constants above here */
+	__ETHTOOL_A_STRINGSETS_CNT,
+	ETHTOOL_A_STRINGSETS_MAX = (__ETHTOOL_A_STRINGSETS_CNT - 1)
+};
+
+/* return only string counts, not the strings */
+#define ETHTOOL_RF_STRSET_COUNTS		(1 << 0)
+
+#define ETHTOOL_RF_STRSET_ALL (ETHTOOL_RF_STRSET_COUNTS)
+
 /* generic netlink info */
 #define ETHTOOL_GENL_NAME "ethtool"
 #define ETHTOOL_GENL_VERSION 1
diff --git a/net/ethtool/Makefile b/net/ethtool/Makefile
index 11782306593b..11ceb00821b3 100644
--- a/net/ethtool/Makefile
+++ b/net/ethtool/Makefile
@@ -4,4 +4,4 @@ obj-y				+= ioctl.o common.o
 
 obj-$(CONFIG_ETHTOOL_NETLINK)	+= ethtool_nl.o
 
-ethtool_nl-y	:= netlink.o bitset.o
+ethtool_nl-y	:= netlink.o bitset.o strset.o
diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index 6d326cc25aac..41d7fedd3dd6 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -199,6 +199,7 @@ struct ethnl_dump_ctx {
 };
 
 static const struct get_request_ops *get_requests[__ETHTOOL_MSG_USER_CNT] = {
+	[ETHTOOL_MSG_STRSET_GET]	= &strset_request_ops,
 };
 
 static struct ethnl_dump_ctx *ethnl_dump_context(struct netlink_callback *cb)
@@ -544,6 +545,13 @@ EXPORT_SYMBOL(ethtool_notify);
 /* genetlink setup */
 
 static const struct genl_ops ethtool_genl_ops[] = {
+	{
+		.cmd	= ETHTOOL_MSG_STRSET_GET,
+		.doit	= ethnl_get_doit,
+		.start	= ethnl_get_start,
+		.dumpit	= ethnl_get_dumpit,
+		.done	= ethnl_get_done,
+	},
 };
 
 static const struct genl_multicast_group ethtool_nl_mcgrps[] = {
diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
index 6a9695c3b0c6..2352fd9c17c3 100644
--- a/net/ethtool/netlink.h
+++ b/net/ethtool/netlink.h
@@ -289,4 +289,8 @@ struct get_request_ops {
 	void (*cleanup)(struct ethnl_req_info *req_info);
 };
 
+/* request handlers */
+
+extern const struct get_request_ops strset_request_ops;
+
 #endif /* _NET_ETHTOOL_NETLINK_H */
diff --git a/net/ethtool/strset.c b/net/ethtool/strset.c
new file mode 100644
index 000000000000..fd7229379158
--- /dev/null
+++ b/net/ethtool/strset.c
@@ -0,0 +1,453 @@
+// SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note
+
+#include <linux/ethtool.h>
+#include <linux/phy.h>
+#include "netlink.h"
+#include "common.h"
+
+enum strset_type {
+	ETH_SS_TYPE_NONE,
+	ETH_SS_TYPE_LEGACY,
+	ETH_SS_TYPE_SIMPLE,
+};
+
+struct strset_info {
+	enum strset_type type;
+	bool per_dev;
+	bool free_data;
+	unsigned int count;
+	union {
+		const char (*legacy)[ETH_GSTRING_LEN];
+		const char * const *simple;
+		void *ptr;
+	} data;
+};
+
+static const struct strset_info info_template[] = {
+	[ETH_SS_TEST] = {
+		.type		= ETH_SS_TYPE_LEGACY,
+		.per_dev	= true,
+	},
+	[ETH_SS_STATS] = {
+		.type		= ETH_SS_TYPE_LEGACY,
+		.per_dev	= true,
+	},
+	[ETH_SS_PRIV_FLAGS] = {
+		.type		= ETH_SS_TYPE_LEGACY,
+		.per_dev	= true,
+	},
+	[ETH_SS_NTUPLE_FILTERS] = {
+		.type		= ETH_SS_TYPE_NONE,
+	},
+	[ETH_SS_FEATURES] = {
+		.type		= ETH_SS_TYPE_LEGACY,
+		.per_dev	= false,
+		.count		= ARRAY_SIZE(netdev_features_strings),
+		.data		= { .legacy = netdev_features_strings },
+	},
+	[ETH_SS_RSS_HASH_FUNCS] = {
+		.type		= ETH_SS_TYPE_LEGACY,
+		.per_dev	= false,
+		.count		= ARRAY_SIZE(rss_hash_func_strings),
+		.data		= { .legacy = rss_hash_func_strings },
+	},
+	[ETH_SS_TUNABLES] = {
+		.type		= ETH_SS_TYPE_LEGACY,
+		.per_dev	= false,
+		.count		= ARRAY_SIZE(tunable_strings),
+		.data		= { .legacy = tunable_strings },
+	},
+	[ETH_SS_PHY_STATS] = {
+		.type		= ETH_SS_TYPE_LEGACY,
+		.per_dev	= true,
+	},
+	[ETH_SS_PHY_TUNABLES] = {
+		.type		= ETH_SS_TYPE_LEGACY,
+		.per_dev	= false,
+		.count		= ARRAY_SIZE(phy_tunable_strings),
+		.data		= { .legacy = phy_tunable_strings },
+	},
+};
+
+struct strset_data {
+	struct ethnl_req_info		reqinfo_base;
+	u32				req_ids;
+	bool				counts_only;
+
+	/* everything below here will be reset for each device in dumps */
+	struct ethnl_reply_data		repdata_base;
+	struct strset_info		info[ETH_SS_COUNT];
+};
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
+static bool strset_include(const struct strset_data *data, u32 id)
+{
+	bool per_dev;
+
+	BUILD_BUG_ON(ETH_SS_COUNT >= BITS_PER_BYTE * sizeof(data->req_ids));
+
+	if (data->req_ids)
+		return data->req_ids & (1U << id);
+	per_dev = data->info[id].per_dev;
+	if (data->info[id].type == ETH_SS_TYPE_NONE)
+		return false;
+
+	return data->repdata_base.dev ? per_dev : !per_dev;
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
+static const struct nla_policy strset_hdr_policy[ETHTOOL_A_HEADER_MAX + 1] = {
+	[ETHTOOL_A_HEADER_UNSPEC]	= { .type = NLA_REJECT },
+	[ETHTOOL_A_HEADER_DEV_INDEX]	= { .type = NLA_U32 },
+	[ETHTOOL_A_HEADER_DEV_NAME]	= { .type = NLA_NUL_STRING,
+					    .len = IFNAMSIZ - 1 },
+	[ETHTOOL_A_HEADER_INFOMASK]	= { .type = NLA_REJECT },
+	[ETHTOOL_A_HEADER_GFLAGS]	= { .type = NLA_REJECT },
+	[ETHTOOL_A_HEADER_RFLAGS]	= { .type = NLA_U32 },
+};
+
+static const struct nla_policy
+strset_stringsets_policy[ETHTOOL_A_STRINGSETS_MAX + 1] = {
+	[ETHTOOL_A_STRINGSETS_UNSPEC]		= { .type = NLA_REJECT },
+	[ETHTOOL_A_STRINGSETS_STRINGSET]	= { .type = NLA_NESTED },
+};
+
+/* parse_request() handler */
+static int strset_parse(struct ethnl_req_info *req_info,
+			struct nlattr **tb, struct netlink_ext_ack *extack)
+{
+	struct strset_data *data =
+		container_of(req_info, struct strset_data, reqinfo_base);
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
+		data->req_ids |= (1U << id);
+	}
+
+	return 0;
+}
+
+/* cleanup() handler - free allocated data (if any) */
+static void strset_cleanup(struct ethnl_req_info *req_info)
+{
+	struct strset_data *data =
+		container_of(req_info, struct strset_data, reqinfo_base);
+	unsigned int i;
+
+	for (i = 0; i < ETH_SS_COUNT; i++)
+		if (data->info[i].free_data) {
+			kfree(data->info[i].data.ptr);
+			data->info[i].data.ptr = NULL;
+			data->info[i].free_data = false;
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
+		info->data.legacy = strings;
+		info->free_data = true;
+	}
+	info->count = count;
+
+	return 0;
+}
+
+/* prepare_data() handler */
+static int strset_prepare(struct ethnl_req_info *req_info,
+			  struct genl_info *info)
+{
+	struct strset_data *data =
+		container_of(req_info, struct strset_data, reqinfo_base);
+	struct net_device *dev = data->repdata_base.dev;
+	unsigned int i;
+	int ret;
+
+	BUILD_BUG_ON(ARRAY_SIZE(info_template) != ETH_SS_COUNT);
+	memcpy(&data->info, &info_template, sizeof(data->info));
+
+	if (!dev) {
+		for (i = 0; i < ETH_SS_COUNT; i++) {
+			if ((data->req_ids & (1U << i)) &&
+			    data->info[i].per_dev) {
+				if (info)
+					GENL_SET_ERR_MSG(info, "requested per device strings without dev");
+				return -EINVAL;
+			}
+		}
+	}
+
+	ret = ethnl_before_ops(dev);
+	if (ret < 0)
+		goto err_strset;
+	for (i = 0; i < ETH_SS_COUNT; i++) {
+		if (!strset_include(data, i) || !data->info[i].per_dev)
+			continue;
+		if (WARN_ONCE(data->info[i].type != ETH_SS_TYPE_LEGACY,
+			      "unexpected string set type %u",
+			      data->info[i].type))
+			goto err_ops;
+
+		ret = strset_prepare_set(&data->info[i], dev, i,
+					 data->counts_only);
+		if (ret < 0)
+			goto err_ops;
+	}
+	ethnl_after_ops(dev);
+
+	return 0;
+err_ops:
+	ethnl_after_ops(dev);
+err_strset:
+	strset_cleanup(req_info);
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
+		const char *str;
+
+		if (info->type == ETH_SS_TYPE_LEGACY)
+			str = info->data.legacy[i];
+		else
+			str = info->data.simple[i];
+
+		/* ETHTOOL_A_STRING_INDEX, ETHTOOL_A_STRING_VALUE, nest */
+		len += nla_total_size(nla_total_size(sizeof(u32)) +
+				      ethnl_str_size(str));
+	}
+	/* ETHTOOL_A_STRINGSET_ID, ETHTOOL_A_STRINGSET_COUNT */
+	len = 2 * nla_total_size(sizeof(u32)) + nla_total_size(len);
+
+	return nla_total_size(len);
+}
+
+/* reply_size() handler */
+static int strset_size(const struct ethnl_req_info *req_info)
+{
+	const struct strset_data *data =
+		container_of(req_info, struct strset_data, reqinfo_base);
+	unsigned int i;
+	int len = 0;
+	int ret;
+
+	len += ethnl_reply_header_size();
+	for (i = 0; i < ETH_SS_COUNT; i++) {
+		const struct strset_info *info = &data->info[i];
+
+		if (!strset_include(data, i) || info->type == ETH_SS_TYPE_NONE)
+			continue;
+
+		ret = strset_set_size(info, data->counts_only);
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
+			      const struct strset_info *info, u32 idx)
+{
+	struct nlattr *string;
+	const char *value;
+
+	if (info->type == ETH_SS_TYPE_LEGACY)
+		value = info->data.legacy[idx];
+	else
+		value = info->data.simple[idx];
+
+	string = nla_nest_start(skb, ETHTOOL_A_STRINGS_STRING);
+	if (!string)
+		return -EMSGSIZE;
+	if (nla_put_u32(skb, ETHTOOL_A_STRING_INDEX, idx) ||
+	    nla_put_string(skb, ETHTOOL_A_STRING_VALUE, value))
+		return -EMSGSIZE;
+	nla_nest_end(skb, string);
+
+	return 0;
+}
+
+/* fill one string set into reply */
+static int strset_fill_set(struct sk_buff *skb, const struct strset_data *data,
+			   u32 id)
+{
+	const struct strset_info *info = &data->info[id];
+	struct nlattr *strings;
+	struct nlattr *nest;
+	unsigned int i = (unsigned int)(-1);
+
+	if (info->type == ETH_SS_TYPE_NONE)
+		return -EOPNOTSUPP;
+	if (info->count == 0)
+		return 0;
+	nest = nla_nest_start(skb, ETHTOOL_A_STRINGSETS_STRINGSET);
+	if (!nest)
+		return -EMSGSIZE;
+
+	if (nla_put_u32(skb, ETHTOOL_A_STRINGSET_ID, id) ||
+	    nla_put_u32(skb, ETHTOOL_A_STRINGSET_COUNT, info->count))
+		goto nla_put_failure;
+
+	if (!data->counts_only) {
+		strings = nla_nest_start(skb, ETHTOOL_A_STRINGSET_STRINGS);
+		if (!strings)
+			goto nla_put_failure;
+		for (i = 0; i < info->count; i++) {
+			if (strset_fill_string(skb, info, i) < 0)
+				goto nla_put_failure;
+		}
+		nla_nest_end(skb, strings);
+	}
+
+	nla_nest_end(skb, nest);
+	return 0;
+
+nla_put_failure:
+	nla_nest_cancel(skb, nest);
+	return -EMSGSIZE;
+}
+
+/* fill_reply() handler */
+static int strset_fill(struct sk_buff *skb,
+		       const struct ethnl_req_info *req_info)
+{
+	const struct strset_data *data =
+		container_of(req_info, struct strset_data, reqinfo_base);
+	struct nlattr *nest;
+	unsigned int i;
+	int ret;
+
+	nest = nla_nest_start(skb, ETHTOOL_A_STRSET_STRINGSETS);
+	if (!nest)
+		return -EMSGSIZE;
+
+	for (i = 0; i < ETH_SS_COUNT; i++) {
+		if (strset_include(data, i)) {
+			ret = strset_fill_set(skb, data, i);
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
+const struct get_request_ops strset_request_ops = {
+	.request_cmd		= ETHTOOL_MSG_STRSET_GET,
+	.reply_cmd		= ETHTOOL_MSG_STRSET_GET_REPLY,
+	.hdr_attr		= ETHTOOL_A_STRSET_HEADER,
+	.max_attr		= ETHTOOL_A_STRSET_MAX,
+	.data_size		= sizeof(struct strset_data),
+	.repdata_offset		= offsetof(struct strset_data, repdata_base),
+	.all_reqflags		= ETHTOOL_RF_STRSET_ALL,
+	.allow_nodev_do		= true,
+
+	.parse_request		= strset_parse,
+	.prepare_data		= strset_prepare,
+	.reply_size		= strset_size,
+	.fill_reply		= strset_fill,
+	.cleanup		= strset_cleanup,
+};
-- 
2.22.0

