Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6278E1961B3
	for <lists+netdev@lfdr.de>; Sat, 28 Mar 2020 00:02:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727989AbgC0XCC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 19:02:02 -0400
Received: from mx2.suse.de ([195.135.220.15]:44888 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727708AbgC0XCB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Mar 2020 19:02:01 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 11E7AAE06;
        Fri, 27 Mar 2020 23:01:59 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id AE022E0FC6; Sat, 28 Mar 2020 00:01:58 +0100 (CET)
Message-Id: <826559372a5f5e23ebd446bcea417be33d11d057.1585349448.git.mkubecek@suse.cz>
In-Reply-To: <cover.1585349448.git.mkubecek@suse.cz>
References: <cover.1585349448.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH net-next v3 12/12] ethtool: provide timestamping information
 with TSINFO_GET request
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Jiri Pirko <jiri@resnulli.us>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Richard Cochran <richardcochran@gmail.com>,
        linux-kernel@vger.kernel.org
Date:   Sat, 28 Mar 2020 00:01:58 +0100 (CET)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement TSINFO_GET request to get timestamping information for a network
device. This is traditionally available via ETHTOOL_GET_TS_INFO ioctl
request.

Move part of ethtool_get_ts_info() into common.c so that ioctl and netlink
code use the same logic to get timestamping information from the device.

v3: use "TSINFO" rather than "TIMESTAMP", suggested by Richard Cochran

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
Acked-by: Richard Cochran <richardcochran@gmail.com>
---
 Documentation/networking/ethtool-netlink.rst |  30 +++-
 include/uapi/linux/ethtool_netlink.h         |  17 +++
 net/ethtool/Makefile                         |   2 +-
 net/ethtool/common.c                         |  21 +++
 net/ethtool/common.h                         |   1 +
 net/ethtool/ioctl.c                          |  23 +--
 net/ethtool/netlink.c                        |   8 ++
 net/ethtool/netlink.h                        |   1 +
 net/ethtool/tsinfo.c                         | 143 +++++++++++++++++++
 9 files changed, 225 insertions(+), 21 deletions(-)
 create mode 100644 net/ethtool/tsinfo.c

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index f1950a0a6c93..567326491f80 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -203,6 +203,7 @@ Userspace to kernel:
   ``ETHTOOL_MSG_PAUSE_SET``             set pause parameters
   ``ETHTOOL_MSG_EEE_GET``               get EEE settings
   ``ETHTOOL_MSG_EEE_SET``               set EEE settings
+  ``ETHTOOL_MSG_TSINFO_GET``		get timestamping info
   ===================================== ================================
 
 Kernel to userspace:
@@ -233,6 +234,7 @@ Kernel to userspace:
   ``ETHTOOL_MSG_PAUSE_NTF``             pause parameters
   ``ETHTOOL_MSG_EEE_GET_REPLY``         EEE settings
   ``ETHTOOL_MSG_EEE_NTF``               EEE settings
+  ``ETHTOOL_MSG_TSINFO_GET_REPLY``	timestamping info
   ===================================== =================================
 
 ``GET`` requests are sent by userspace applications to retrieve device
@@ -928,6 +930,32 @@ but only first 32 can be set at the moment as that is what the ``ethtool_ops``
 callback supports.
 
 
+TSINFO_GET
+==========
+
+Gets timestamping information like ``ETHTOOL_GET_TS_INFO`` ioctl request.
+
+Request contents:
+
+  =====================================  ======  ==========================
+  ``ETHTOOL_A_TSINFO_HEADER``            nested  request header
+  =====================================  ======  ==========================
+
+Kernel response contents:
+
+  =====================================  ======  ==========================
+  ``ETHTOOL_A_TSINFO_HEADER``            nested  request header
+  ``ETHTOOL_A_TSINFO_TIMESTAMPING``      bitset  SO_TIMESTAMPING flags
+  ``ETHTOOL_A_TSINFO_TX_TYPES``          bitset  supported Tx types
+  ``ETHTOOL_A_TSINFO_RX_FILTERS``        bitset  supported Rx filters
+  ``ETHTOOL_A_TSINFO_PHC_INDEX``         u32     PTP hw clock index
+  =====================================  ======  ==========================
+
+``ETHTOOL_A_TSINFO_PHC_INDEX`` is absent if there is no associated PHC (there
+is no special value for this case). The bitset attributes are omitted if they
+would be empty (no bit set).
+
+
 Request translation
 ===================
 
@@ -1003,7 +1031,7 @@ have their netlink replacement yet.
   ``ETHTOOL_SET_DUMP``                n/a
   ``ETHTOOL_GET_DUMP_FLAG``           n/a
   ``ETHTOOL_GET_DUMP_DATA``           n/a
-  ``ETHTOOL_GET_TS_INFO``             n/a
+  ``ETHTOOL_GET_TS_INFO``             ``ETHTOOL_MSG_TSINFO_GET``
   ``ETHTOOL_GMODULEINFO``             n/a
   ``ETHTOOL_GMODULEEEPROM``           n/a
   ``ETHTOOL_GEEE``                    ``ETHTOOL_MSG_EEE_GET``
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index bacdd5363510..7fde76366ba4 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -38,6 +38,7 @@ enum {
 	ETHTOOL_MSG_PAUSE_SET,
 	ETHTOOL_MSG_EEE_GET,
 	ETHTOOL_MSG_EEE_SET,
+	ETHTOOL_MSG_TSINFO_GET,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_USER_CNT,
@@ -72,6 +73,7 @@ enum {
 	ETHTOOL_MSG_PAUSE_NTF,
 	ETHTOOL_MSG_EEE_GET_REPLY,
 	ETHTOOL_MSG_EEE_NTF,
+	ETHTOOL_MSG_TSINFO_GET_REPLY,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_KERNEL_CNT,
@@ -386,6 +388,21 @@ enum {
 	ETHTOOL_A_EEE_MAX = (__ETHTOOL_A_EEE_CNT - 1)
 };
 
+/* TSINFO */
+
+enum {
+	ETHTOOL_A_TSINFO_UNSPEC,
+	ETHTOOL_A_TSINFO_HEADER,			/* nest - _A_HEADER_* */
+	ETHTOOL_A_TSINFO_TIMESTAMPING,			/* bitset */
+	ETHTOOL_A_TSINFO_TX_TYPES,			/* bitset */
+	ETHTOOL_A_TSINFO_RX_FILTERS,			/* bitset */
+	ETHTOOL_A_TSINFO_PHC_INDEX,			/* u32 */
+
+	/* add new constants above here */
+	__ETHTOOL_A_TSINFO_CNT,
+	ETHTOOL_A_TSINFO_MAX = (__ETHTOOL_A_TSINFO_CNT - 1)
+};
+
 /* generic netlink info */
 #define ETHTOOL_GENL_NAME "ethtool"
 #define ETHTOOL_GENL_VERSION 1
diff --git a/net/ethtool/Makefile b/net/ethtool/Makefile
index a790f408aa5d..6c360c9c9370 100644
--- a/net/ethtool/Makefile
+++ b/net/ethtool/Makefile
@@ -6,4 +6,4 @@ obj-$(CONFIG_ETHTOOL_NETLINK)	+= ethtool_nl.o
 
 ethtool_nl-y	:= netlink.o bitset.o strset.o linkinfo.o linkmodes.o \
 		   linkstate.o debug.o wol.o features.o privflags.o rings.o \
-		   channels.o coalesce.o pause.o eee.o
+		   channels.o coalesce.o pause.o eee.o tsinfo.o
diff --git a/net/ethtool/common.c b/net/ethtool/common.c
index 150ff405cca4..423e640e3876 100644
--- a/net/ethtool/common.c
+++ b/net/ethtool/common.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-only
 
 #include <linux/net_tstamp.h>
+#include <linux/phy.h>
 
 #include "common.h"
 
@@ -350,3 +351,23 @@ int ethtool_check_ops(const struct ethtool_ops *ops)
 	 */
 	return 0;
 }
+
+int __ethtool_get_ts_info(struct net_device *dev, struct ethtool_ts_info *info)
+{
+	const struct ethtool_ops *ops = dev->ethtool_ops;
+	struct phy_device *phydev = dev->phydev;
+
+	memset(info, 0, sizeof(*info));
+	info->cmd = ETHTOOL_GET_TS_INFO;
+
+	if (phy_has_tsinfo(phydev))
+		return phy_ts_info(phydev, info);
+	if (ops->get_ts_info)
+		return ops->get_ts_info(dev, info);
+
+	info->so_timestamping = SOF_TIMESTAMPING_RX_SOFTWARE |
+				SOF_TIMESTAMPING_SOFTWARE;
+	info->phc_index = -1;
+
+	return 0;
+}
diff --git a/net/ethtool/common.h b/net/ethtool/common.h
index c54c8d57fd8f..a62f68ccc43a 100644
--- a/net/ethtool/common.h
+++ b/net/ethtool/common.h
@@ -35,5 +35,6 @@ bool convert_legacy_settings_to_link_ksettings(
 	struct ethtool_link_ksettings *link_ksettings,
 	const struct ethtool_cmd *legacy_settings);
 int ethtool_get_max_rxfh_channel(struct net_device *dev, u32 *max);
+int __ethtool_get_ts_info(struct net_device *dev, struct ethtool_ts_info *info);
 
 #endif /* _ETHTOOL_COMMON_H */
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 05a2bf64a96b..89d0b1827aaf 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -2140,32 +2140,17 @@ static int ethtool_get_dump_data(struct net_device *dev,
 
 static int ethtool_get_ts_info(struct net_device *dev, void __user *useraddr)
 {
-	int err = 0;
 	struct ethtool_ts_info info;
-	const struct ethtool_ops *ops = dev->ethtool_ops;
-	struct phy_device *phydev = dev->phydev;
-
-	memset(&info, 0, sizeof(info));
-	info.cmd = ETHTOOL_GET_TS_INFO;
-
-	if (phy_has_tsinfo(phydev)) {
-		err = phy_ts_info(phydev, &info);
-	} else if (ops->get_ts_info) {
-		err = ops->get_ts_info(dev, &info);
-	} else {
-		info.so_timestamping =
-			SOF_TIMESTAMPING_RX_SOFTWARE |
-			SOF_TIMESTAMPING_SOFTWARE;
-		info.phc_index = -1;
-	}
+	int err;
 
+	err = __ethtool_get_ts_info(dev, &info);
 	if (err)
 		return err;
 
 	if (copy_to_user(useraddr, &info, sizeof(info)))
-		err = -EFAULT;
+		return -EFAULT;
 
-	return err;
+	return 0;
 }
 
 static int __ethtool_get_module_info(struct net_device *dev,
diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index e525c7b8ba4d..0c772318c023 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -230,6 +230,7 @@ ethnl_default_requests[__ETHTOOL_MSG_USER_CNT] = {
 	[ETHTOOL_MSG_COALESCE_GET]	= &ethnl_coalesce_request_ops,
 	[ETHTOOL_MSG_PAUSE_GET]		= &ethnl_pause_request_ops,
 	[ETHTOOL_MSG_EEE_GET]		= &ethnl_eee_request_ops,
+	[ETHTOOL_MSG_TSINFO_GET]	= &ethnl_tsinfo_request_ops,
 };
 
 static struct ethnl_dump_ctx *ethnl_dump_context(struct netlink_callback *cb)
@@ -831,6 +832,13 @@ static const struct genl_ops ethtool_genl_ops[] = {
 		.flags	= GENL_UNS_ADMIN_PERM,
 		.doit	= ethnl_set_eee,
 	},
+	{
+		.cmd	= ETHTOOL_MSG_TSINFO_GET,
+		.doit	= ethnl_default_doit,
+		.start	= ethnl_default_start,
+		.dumpit	= ethnl_default_dumpit,
+		.done	= ethnl_default_done,
+	},
 };
 
 static const struct genl_multicast_group ethtool_nl_mcgrps[] = {
diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
index a251957d535e..81b8fa020bcb 100644
--- a/net/ethtool/netlink.h
+++ b/net/ethtool/netlink.h
@@ -344,6 +344,7 @@ extern const struct ethnl_request_ops ethnl_channels_request_ops;
 extern const struct ethnl_request_ops ethnl_coalesce_request_ops;
 extern const struct ethnl_request_ops ethnl_pause_request_ops;
 extern const struct ethnl_request_ops ethnl_eee_request_ops;
+extern const struct ethnl_request_ops ethnl_tsinfo_request_ops;
 
 int ethnl_set_linkinfo(struct sk_buff *skb, struct genl_info *info);
 int ethnl_set_linkmodes(struct sk_buff *skb, struct genl_info *info);
diff --git a/net/ethtool/tsinfo.c b/net/ethtool/tsinfo.c
new file mode 100644
index 000000000000..7cb5b512b77c
--- /dev/null
+++ b/net/ethtool/tsinfo.c
@@ -0,0 +1,143 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include <linux/net_tstamp.h>
+
+#include "netlink.h"
+#include "common.h"
+#include "bitset.h"
+
+struct tsinfo_req_info {
+	struct ethnl_req_info		base;
+};
+
+struct tsinfo_reply_data {
+	struct ethnl_reply_data		base;
+	struct ethtool_ts_info		ts_info;
+};
+
+#define TSINFO_REPDATA(__reply_base) \
+	container_of(__reply_base, struct tsinfo_reply_data, base)
+
+static const struct nla_policy
+tsinfo_get_policy[ETHTOOL_A_TSINFO_MAX + 1] = {
+	[ETHTOOL_A_TSINFO_UNSPEC]		= { .type = NLA_REJECT },
+	[ETHTOOL_A_TSINFO_HEADER]		= { .type = NLA_NESTED },
+	[ETHTOOL_A_TSINFO_TIMESTAMPING]		= { .type = NLA_REJECT },
+	[ETHTOOL_A_TSINFO_TX_TYPES]		= { .type = NLA_REJECT },
+	[ETHTOOL_A_TSINFO_RX_FILTERS]		= { .type = NLA_REJECT },
+	[ETHTOOL_A_TSINFO_PHC_INDEX]		= { .type = NLA_REJECT },
+};
+
+static int tsinfo_prepare_data(const struct ethnl_req_info *req_base,
+			       struct ethnl_reply_data *reply_base,
+			       struct genl_info *info)
+{
+	struct tsinfo_reply_data *data = TSINFO_REPDATA(reply_base);
+	struct net_device *dev = reply_base->dev;
+	int ret;
+
+	ret = ethnl_ops_begin(dev);
+	if (ret < 0)
+		return ret;
+	ret = __ethtool_get_ts_info(dev, &data->ts_info);
+	ethnl_ops_complete(dev);
+
+	return ret;
+}
+
+static int tsinfo_reply_size(const struct ethnl_req_info *req_base,
+			     const struct ethnl_reply_data *reply_base)
+{
+	const struct tsinfo_reply_data *data = TSINFO_REPDATA(reply_base);
+	bool compact = req_base->flags & ETHTOOL_FLAG_COMPACT_BITSETS;
+	const struct ethtool_ts_info *ts_info = &data->ts_info;
+	int len = 0;
+	int ret;
+
+	BUILD_BUG_ON(__SOF_TIMESTAMPING_CNT > 32);
+	BUILD_BUG_ON(__HWTSTAMP_TX_CNT > 32);
+	BUILD_BUG_ON(__HWTSTAMP_FILTER_CNT > 32);
+
+	if (ts_info->so_timestamping) {
+		ret = ethnl_bitset32_size(&ts_info->so_timestamping, NULL,
+					  __SOF_TIMESTAMPING_CNT,
+					  sof_timestamping_names, compact);
+		if (ret < 0)
+			return ret;
+		len += ret;	/* _TSINFO_TIMESTAMPING */
+	}
+	if (ts_info->tx_types) {
+		ret = ethnl_bitset32_size(&ts_info->tx_types, NULL,
+					  __HWTSTAMP_TX_CNT,
+					  ts_tx_type_names, compact);
+		if (ret < 0)
+			return ret;
+		len += ret;	/* _TSINFO_TX_TYPES */
+	}
+	if (ts_info->rx_filters) {
+		ret = ethnl_bitset32_size(&ts_info->rx_filters, NULL,
+					  __HWTSTAMP_FILTER_CNT,
+					  ts_rx_filter_names, compact);
+		if (ret < 0)
+			return ret;
+		len += ret;	/* _TSINFO_RX_FILTERS */
+	}
+	if (ts_info->phc_index >= 0)
+		len += nla_total_size(sizeof(u32));	/* _TSINFO_PHC_INDEX */
+
+	return len;
+}
+
+static int tsinfo_fill_reply(struct sk_buff *skb,
+			     const struct ethnl_req_info *req_base,
+			     const struct ethnl_reply_data *reply_base)
+{
+	const struct tsinfo_reply_data *data = TSINFO_REPDATA(reply_base);
+	bool compact = req_base->flags & ETHTOOL_FLAG_COMPACT_BITSETS;
+	const struct ethtool_ts_info *ts_info = &data->ts_info;
+	int ret;
+
+	if (ts_info->so_timestamping) {
+		ret = ethnl_put_bitset32(skb, ETHTOOL_A_TSINFO_TIMESTAMPING,
+					 &ts_info->so_timestamping, NULL,
+					 __SOF_TIMESTAMPING_CNT,
+					 sof_timestamping_names, compact);
+		if (ret < 0)
+			return ret;
+	}
+	if (ts_info->tx_types) {
+		ret = ethnl_put_bitset32(skb, ETHTOOL_A_TSINFO_TX_TYPES,
+					 &ts_info->tx_types, NULL,
+					 __HWTSTAMP_TX_CNT,
+					 ts_tx_type_names, compact);
+		if (ret < 0)
+			return ret;
+	}
+	if (ts_info->rx_filters) {
+		ret = ethnl_put_bitset32(skb, ETHTOOL_A_TSINFO_RX_FILTERS,
+					 &ts_info->rx_filters, NULL,
+					 __HWTSTAMP_FILTER_CNT,
+					 ts_rx_filter_names, compact);
+		if (ret < 0)
+			return ret;
+	}
+	if (ts_info->phc_index >= 0 &&
+	    nla_put_u32(skb, ETHTOOL_A_TSINFO_PHC_INDEX, ts_info->phc_index))
+		return -EMSGSIZE;
+
+	return 0;
+}
+
+const struct ethnl_request_ops ethnl_tsinfo_request_ops = {
+	.request_cmd		= ETHTOOL_MSG_TSINFO_GET,
+	.reply_cmd		= ETHTOOL_MSG_TSINFO_GET_REPLY,
+	.hdr_attr		= ETHTOOL_A_TSINFO_HEADER,
+	.max_attr		= ETHTOOL_A_TSINFO_MAX,
+	.req_info_size		= sizeof(struct tsinfo_req_info),
+	.reply_data_size	= sizeof(struct tsinfo_reply_data),
+	.request_policy		= tsinfo_get_policy,
+
+	.prepare_data		= tsinfo_prepare_data,
+	.reply_size		= tsinfo_reply_size,
+	.fill_reply		= tsinfo_fill_reply,
+};
-- 
2.25.1

