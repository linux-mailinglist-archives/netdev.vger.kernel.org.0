Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6E1B361791
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 04:28:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238233AbhDPC2X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 22:28:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:53636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238234AbhDPC2U (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Apr 2021 22:28:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 321E46124B;
        Fri, 16 Apr 2021 02:27:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618540076;
        bh=84bf11D2tIuiPoxgWvMpfYEHCs+qqlVAcu21t3z4XHc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TuOgKicItYRT1maq1mWv3cTtE6eigesVHZfboEDcdY2HDOsctUcSO+pv4it2u+dsQ
         VNP6mxu5XPW1u84rLHDgTXGL3+o56dW8f87bymaGpuSfdpiW37TjObpK+UkiDAmdhe
         5R078RFvc/9Ga3BG15rqvLkB/AGDmT1ZIct5gVZfFuqdZn2LwSrORq/2SkkPOf19rI
         YailBVFxunyHb2oyacOblXWKcfvW8C+rqpi1i4iEECx1kde79ZL+jXo/MBh9GHWJfF
         nWuvRgBwEj6yxfN5fO76dnvYWVRywMg48qKh2M7JDLbGj0lUbgZXgXKZErHFHY63yp
         lC8O0GD/DGYMQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, andrew@lunn.ch, mkubecek@suse.cz,
        idosch@nvidia.com, saeedm@nvidia.com, michael.chan@broadcom.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 3/9] ethtool: add a new command for reading standard stats
Date:   Thu, 15 Apr 2021 19:27:46 -0700
Message-Id: <20210416022752.2814621-4-kuba@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210416022752.2814621-1-kuba@kernel.org>
References: <20210416022752.2814621-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add an interface for reading standard stats, including
stats which don't have a corresponding control interface.

Start with IEEE 802.3 PHY stats. There seems to be only
one stat to expose there.

Define API to not require user space changes when new
stats or groups are added. Groups are based on bitset,
stats have a string set associated.

v1: wrap stats in a nest

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 include/linux/ethtool.h              |  10 ++
 include/uapi/linux/ethtool.h         |   4 +
 include/uapi/linux/ethtool_netlink.h |  47 +++++++
 net/ethtool/Makefile                 |   2 +-
 net/ethtool/netlink.c                |  10 ++
 net/ethtool/netlink.h                |   5 +
 net/ethtool/stats.c                  | 200 +++++++++++++++++++++++++++
 net/ethtool/strset.c                 |  10 ++
 8 files changed, 287 insertions(+), 1 deletion(-)
 create mode 100644 net/ethtool/stats.c

diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index 112a85b57f1f..2d5455eedbf4 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -250,6 +250,13 @@ static inline void ethtool_stats_init(u64 *stats, unsigned int n)
 		stats[n] = ETHTOOL_STAT_NOT_SET;
 }
 
+/* Basic IEEE 802.3 PHY statistics (30.3.2.1.*), not otherwise exposed
+ * via a more targeted API.
+ */
+struct ethtool_eth_phy_stats {
+	u64 SymbolErrorDuringCarrier;
+};
+
 /**
  * struct ethtool_pause_stats - statistics for IEEE 802.3x pause frames
  * @tx_pause_frames: transmitted pause frame count. Reported to user space
@@ -487,6 +494,7 @@ struct ethtool_module_eeprom {
  * @get_module_eeprom_by_page: Get a region of plug-in module EEPROM data from
  *	specified page. Returns a negative error code or the amount of bytes
  *	read.
+ * @get_eth_phy_stats: Query some of the IEEE 802.3 PHY statistics.
  *
  * All operations are optional (i.e. the function pointer may be set
  * to %NULL) and callers must take this into account.  Callers must
@@ -597,6 +605,8 @@ struct ethtool_ops {
 	int	(*get_module_eeprom_by_page)(struct net_device *dev,
 					     const struct ethtool_module_eeprom *page,
 					     struct netlink_ext_ack *extack);
+	void	(*get_eth_phy_stats)(struct net_device *dev,
+				     struct ethtool_eth_phy_stats *phy_stats);
 };
 
 int ethtool_check_ops(const struct ethtool_ops *ops);
diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
index f91e079e3108..190ae6e03918 100644
--- a/include/uapi/linux/ethtool.h
+++ b/include/uapi/linux/ethtool.h
@@ -669,6 +669,8 @@ enum ethtool_link_ext_substate_cable_issue {
  * @ETH_SS_TS_TX_TYPES: timestamping Tx types
  * @ETH_SS_TS_RX_FILTERS: timestamping Rx filters
  * @ETH_SS_UDP_TUNNEL_TYPES: UDP tunnel types
+ * @ETH_SS_STATS_STD: standardized stats
+ * @ETH_SS_STATS_ETH_PHY: names of IEEE 802.3 PHY statistics
  *
  * @ETH_SS_COUNT: number of defined string sets
  */
@@ -689,6 +691,8 @@ enum ethtool_stringset {
 	ETH_SS_TS_TX_TYPES,
 	ETH_SS_TS_RX_FILTERS,
 	ETH_SS_UDP_TUNNEL_TYPES,
+	ETH_SS_STATS_STD,
+	ETH_SS_STATS_ETH_PHY,
 
 	/* add new constants above here */
 	ETH_SS_COUNT
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index 3a2b31ccbc5b..a54cfe625f34 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -45,6 +45,7 @@ enum {
 	ETHTOOL_MSG_FEC_GET,
 	ETHTOOL_MSG_FEC_SET,
 	ETHTOOL_MSG_MODULE_EEPROM_GET,
+	ETHTOOL_MSG_STATS_GET,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_USER_CNT,
@@ -86,6 +87,7 @@ enum {
 	ETHTOOL_MSG_FEC_GET_REPLY,
 	ETHTOOL_MSG_FEC_NTF,
 	ETHTOOL_MSG_MODULE_EEPROM_GET_REPLY,
+	ETHTOOL_MSG_STATS_GET_REPLY,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_KERNEL_CNT,
@@ -679,6 +681,51 @@ enum {
 	ETHTOOL_A_MODULE_EEPROM_MAX = (__ETHTOOL_A_MODULE_EEPROM_CNT - 1)
 };
 
+/* STATS */
+
+enum {
+	ETHTOOL_A_STATS_UNSPEC,
+	ETHTOOL_A_STATS_PAD,
+	ETHTOOL_A_STATS_HEADER,			/* nest - _A_HEADER_* */
+	ETHTOOL_A_STATS_GROUPS,			/* bitset */
+
+	ETHTOOL_A_STATS_GRP,			/* nest - _A_STATS_GRP_* */
+
+	/* add new constants above here */
+	__ETHTOOL_A_STATS_CNT,
+	ETHTOOL_A_STATS_MAX = (__ETHTOOL_A_STATS_CNT - 1)
+};
+
+enum {
+	ETHTOOL_STATS_ETH_PHY,
+
+	/* add new constants above here */
+	__ETHTOOL_STATS_CNT
+};
+
+enum {
+	ETHTOOL_A_STATS_GRP_UNSPEC,
+	ETHTOOL_A_STATS_GRP_PAD,
+
+	ETHTOOL_A_STATS_GRP_ID,			/* u32 */
+	ETHTOOL_A_STATS_GRP_SS_ID,		/* u32 */
+
+	ETHTOOL_A_STATS_GRP_STAT,		/* nest */
+
+	/* add new constants above here */
+	__ETHTOOL_A_STATS_GRP_CNT,
+	ETHTOOL_A_STATS_GRP_MAX = (__ETHTOOL_A_STATS_CNT - 1)
+};
+
+enum {
+	/* 30.3.2.1.5 aSymbolErrorDuringCarrier */
+	ETHTOOL_A_STATS_ETH_PHY_5_SYM_ERR,
+
+	/* add new constants above here */
+	__ETHTOOL_A_STATS_ETH_PHY_CNT,
+	ETHTOOL_A_STATS_ETH_PHY_MAX = (__ETHTOOL_A_STATS_ETH_PHY_CNT - 1)
+};
+
 /* generic netlink info */
 #define ETHTOOL_GENL_NAME "ethtool"
 #define ETHTOOL_GENL_VERSION 1
diff --git a/net/ethtool/Makefile b/net/ethtool/Makefile
index 83842685fd8c..723c9a8a8cdf 100644
--- a/net/ethtool/Makefile
+++ b/net/ethtool/Makefile
@@ -7,4 +7,4 @@ obj-$(CONFIG_ETHTOOL_NETLINK)	+= ethtool_nl.o
 ethtool_nl-y	:= netlink.o bitset.o strset.o linkinfo.o linkmodes.o \
 		   linkstate.o debug.o wol.o features.o privflags.o rings.o \
 		   channels.o coalesce.o pause.o eee.o tsinfo.o cabletest.o \
-		   tunnels.o fec.o eeprom.o
+		   tunnels.o fec.o eeprom.o stats.o
diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index 5f5d7c4b3d4a..290012d0d11d 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -247,6 +247,7 @@ ethnl_default_requests[__ETHTOOL_MSG_USER_CNT] = {
 	[ETHTOOL_MSG_FEC_GET]		= &ethnl_fec_request_ops,
 	[ETHTOOL_MSG_TSINFO_GET]	= &ethnl_tsinfo_request_ops,
 	[ETHTOOL_MSG_MODULE_EEPROM_GET]	= &ethnl_module_eeprom_request_ops,
+	[ETHTOOL_MSG_STATS_GET]		= &ethnl_stats_request_ops,
 };
 
 static struct ethnl_dump_ctx *ethnl_dump_context(struct netlink_callback *cb)
@@ -942,6 +943,15 @@ static const struct genl_ops ethtool_genl_ops[] = {
 		.policy = ethnl_module_eeprom_get_policy,
 		.maxattr = ARRAY_SIZE(ethnl_module_eeprom_get_policy) - 1,
 	},
+	{
+		.cmd	= ETHTOOL_MSG_STATS_GET,
+		.doit	= ethnl_default_doit,
+		.start	= ethnl_default_start,
+		.dumpit	= ethnl_default_dumpit,
+		.done	= ethnl_default_done,
+		.policy = ethnl_stats_get_policy,
+		.maxattr = ARRAY_SIZE(ethnl_stats_get_policy) - 1,
+	},
 };
 
 static const struct genl_multicast_group ethtool_nl_mcgrps[] = {
diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
index 3f93b3c41c31..79631792313e 100644
--- a/net/ethtool/netlink.h
+++ b/net/ethtool/netlink.h
@@ -346,6 +346,7 @@ extern const struct ethnl_request_ops ethnl_eee_request_ops;
 extern const struct ethnl_request_ops ethnl_tsinfo_request_ops;
 extern const struct ethnl_request_ops ethnl_fec_request_ops;
 extern const struct ethnl_request_ops ethnl_module_eeprom_request_ops;
+extern const struct ethnl_request_ops ethnl_stats_request_ops;
 
 extern const struct nla_policy ethnl_header_policy[ETHTOOL_A_HEADER_FLAGS + 1];
 extern const struct nla_policy ethnl_header_policy_stats[ETHTOOL_A_HEADER_FLAGS + 1];
@@ -380,6 +381,7 @@ extern const struct nla_policy ethnl_tunnel_info_get_policy[ETHTOOL_A_TUNNEL_INF
 extern const struct nla_policy ethnl_fec_get_policy[ETHTOOL_A_FEC_HEADER + 1];
 extern const struct nla_policy ethnl_fec_set_policy[ETHTOOL_A_FEC_AUTO + 1];
 extern const struct nla_policy ethnl_module_eeprom_get_policy[ETHTOOL_A_MODULE_EEPROM_DATA + 1];
+extern const struct nla_policy ethnl_stats_get_policy[ETHTOOL_A_STATS_GROUPS + 1];
 
 int ethnl_set_linkinfo(struct sk_buff *skb, struct genl_info *info);
 int ethnl_set_linkmodes(struct sk_buff *skb, struct genl_info *info);
@@ -399,4 +401,7 @@ int ethnl_tunnel_info_start(struct netlink_callback *cb);
 int ethnl_tunnel_info_dumpit(struct sk_buff *skb, struct netlink_callback *cb);
 int ethnl_set_fec(struct sk_buff *skb, struct genl_info *info);
 
+extern const char stats_std_names[__ETHTOOL_STATS_CNT][ETH_GSTRING_LEN];
+extern const char stats_eth_phy_names[__ETHTOOL_A_STATS_ETH_PHY_CNT][ETH_GSTRING_LEN];
+
 #endif /* _NET_ETHTOOL_NETLINK_H */
diff --git a/net/ethtool/stats.c b/net/ethtool/stats.c
new file mode 100644
index 000000000000..fd8f47178c06
--- /dev/null
+++ b/net/ethtool/stats.c
@@ -0,0 +1,200 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include "netlink.h"
+#include "common.h"
+#include "bitset.h"
+
+struct stats_req_info {
+	struct ethnl_req_info		base;
+	DECLARE_BITMAP(stat_mask, __ETHTOOL_STATS_CNT);
+};
+
+#define STATS_REQINFO(__req_base) \
+	container_of(__req_base, struct stats_req_info, base)
+
+struct stats_reply_data {
+	struct ethnl_reply_data		base;
+	struct ethtool_eth_phy_stats	phy_stats;
+};
+
+#define STATS_REPDATA(__reply_base) \
+	container_of(__reply_base, struct stats_reply_data, base)
+
+const char stats_std_names[__ETHTOOL_STATS_CNT][ETH_GSTRING_LEN] = {
+	[ETHTOOL_STATS_ETH_PHY]			= "eth-phy",
+};
+
+const char stats_eth_phy_names[__ETHTOOL_A_STATS_ETH_PHY_CNT][ETH_GSTRING_LEN] = {
+	[ETHTOOL_A_STATS_ETH_PHY_5_SYM_ERR]	= "SymbolErrorDuringCarrier",
+};
+
+const struct nla_policy ethnl_stats_get_policy[ETHTOOL_A_STATS_GROUPS + 1] = {
+	[ETHTOOL_A_STATS_HEADER]	=
+		NLA_POLICY_NESTED(ethnl_header_policy),
+	[ETHTOOL_A_STATS_GROUPS]	= { .type = NLA_NESTED },
+};
+
+static int stats_parse_request(struct ethnl_req_info *req_base,
+			       struct nlattr **tb,
+			       struct netlink_ext_ack *extack)
+{
+	struct stats_req_info *req_info = STATS_REQINFO(req_base);
+	bool mod = false;
+	int err;
+
+	err = ethnl_update_bitset(req_info->stat_mask, __ETHTOOL_STATS_CNT,
+				  tb[ETHTOOL_A_STATS_GROUPS], stats_std_names,
+				  extack, &mod);
+	if (err)
+		return err;
+
+	if (!mod) {
+		NL_SET_ERR_MSG(extack, "no stats requested");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int stats_prepare_data(const struct ethnl_req_info *req_base,
+			      struct ethnl_reply_data *reply_base,
+			      struct genl_info *info)
+{
+	const struct stats_req_info *req_info = STATS_REQINFO(req_base);
+	struct stats_reply_data *data = STATS_REPDATA(reply_base);
+	struct net_device *dev = reply_base->dev;
+	int ret;
+
+	ret = ethnl_ops_begin(dev);
+	if (ret < 0)
+		return ret;
+
+	memset(&data->phy_stats, 0xff, sizeof(data->phy_stats));
+
+	if (test_bit(ETHTOOL_STATS_ETH_PHY, req_info->stat_mask) &&
+	    dev->ethtool_ops->get_eth_phy_stats)
+		dev->ethtool_ops->get_eth_phy_stats(dev, &data->phy_stats);
+
+	ethnl_ops_complete(dev);
+	return 0;
+}
+
+static int stats_reply_size(const struct ethnl_req_info *req_base,
+			    const struct ethnl_reply_data *reply_base)
+{
+	const struct stats_req_info *req_info = STATS_REQINFO(req_base);
+	unsigned int n_grps = 0, n_stats = 0;
+	int len = 0;
+
+	if (test_bit(ETHTOOL_STATS_ETH_PHY, req_info->stat_mask)) {
+		n_stats += sizeof(struct ethtool_eth_phy_stats) / sizeof(u64);
+		n_grps++;
+	}
+
+	len += n_grps * (nla_total_size(0) + /* _A_STATS_GRP */
+			 nla_total_size(4) + /* _A_STATS_GRP_ID */
+			 nla_total_size(4)); /* _A_STATS_GRP_SS_ID */
+	len += n_stats * (nla_total_size(0) + /* _A_STATS_GRP_STAT */
+			  nla_total_size_64bit(sizeof(u64)));
+
+	return len;
+}
+
+static int stat_put(struct sk_buff *skb, u16 attrtype, u64 val)
+{
+	struct nlattr *nest;
+	int ret;
+
+	if (val == ETHTOOL_STAT_NOT_SET)
+		return 0;
+
+	/* We want to start stats attr types from 0, so we don't have a type
+	 * for pad inside ETHTOOL_A_STATS_GRP_STAT. Pad things on the outside
+	 * of ETHTOOL_A_STATS_GRP_STAT. Since we're one nest away from the
+	 * actual attr we're 4B off - nla_need_padding_for_64bit() & co.
+	 * can't be used.
+	 */
+#ifndef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
+	if (!IS_ALIGNED((unsigned long)skb_tail_pointer(skb), 8))
+		if (!nla_reserve(skb, ETHTOOL_A_STATS_GRP_PAD, 0))
+			return -EMSGSIZE;
+#endif
+
+	nest = nla_nest_start(skb, ETHTOOL_A_STATS_GRP_STAT);
+	if (!nest)
+		return -EMSGSIZE;
+
+	ret = nla_put_u64_64bit(skb, attrtype, val, -1 /* not used */);
+	if (ret) {
+		nla_nest_cancel(skb, nest);
+		return ret;
+	}
+
+	nla_nest_end(skb, nest);
+	return 0;
+}
+
+static int stats_put_phy_stats(struct sk_buff *skb,
+			       const struct stats_reply_data *data)
+{
+	if (stat_put(skb, ETHTOOL_A_STATS_ETH_PHY_5_SYM_ERR,
+		     data->phy_stats.SymbolErrorDuringCarrier))
+		return -EMSGSIZE;
+	return 0;
+}
+
+static int stats_put_stats(struct sk_buff *skb,
+			   const struct stats_reply_data *data,
+			   u32 id, u32 ss_id,
+			   int (*cb)(struct sk_buff *skb,
+				     const struct stats_reply_data *data))
+{
+	struct nlattr *nest;
+
+	nest = nla_nest_start(skb, ETHTOOL_A_STATS_GRP);
+	if (!nest)
+		return -EMSGSIZE;
+
+	if (nla_put_u32(skb, ETHTOOL_A_STATS_GRP_ID, id) ||
+	    nla_put_u32(skb, ETHTOOL_A_STATS_GRP_SS_ID, ss_id))
+		goto err_cancel;
+
+	if (cb(skb, data))
+		goto err_cancel;
+
+	nla_nest_end(skb, nest);
+	return 0;
+
+err_cancel:
+	nla_nest_cancel(skb, nest);
+	return -EMSGSIZE;
+}
+
+static int stats_fill_reply(struct sk_buff *skb,
+			    const struct ethnl_req_info *req_base,
+			    const struct ethnl_reply_data *reply_base)
+{
+	const struct stats_req_info *req_info = STATS_REQINFO(req_base);
+	const struct stats_reply_data *data = STATS_REPDATA(reply_base);
+	int ret = 0;
+
+	if (!ret && test_bit(ETHTOOL_STATS_ETH_PHY, req_info->stat_mask))
+		ret = stats_put_stats(skb, data, ETHTOOL_STATS_ETH_PHY,
+				      ETH_SS_STATS_ETH_PHY,
+				      stats_put_phy_stats);
+
+	return ret;
+}
+
+const struct ethnl_request_ops ethnl_stats_request_ops = {
+	.request_cmd		= ETHTOOL_MSG_STATS_GET,
+	.reply_cmd		= ETHTOOL_MSG_STATS_GET_REPLY,
+	.hdr_attr		= ETHTOOL_A_STATS_HEADER,
+	.req_info_size		= sizeof(struct stats_req_info),
+	.reply_data_size	= sizeof(struct stats_reply_data),
+
+	.parse_request		= stats_parse_request,
+	.prepare_data		= stats_prepare_data,
+	.reply_size		= stats_reply_size,
+	.fill_reply		= stats_fill_reply,
+};
diff --git a/net/ethtool/strset.c b/net/ethtool/strset.c
index c3a5489964cd..5f3c73587ff4 100644
--- a/net/ethtool/strset.c
+++ b/net/ethtool/strset.c
@@ -80,6 +80,16 @@ static const struct strset_info info_template[] = {
 		.count		= __ETHTOOL_UDP_TUNNEL_TYPE_CNT,
 		.strings	= udp_tunnel_type_names,
 	},
+	[ETH_SS_STATS_STD] = {
+		.per_dev	= false,
+		.count		= __ETHTOOL_STATS_CNT,
+		.strings	= stats_std_names,
+	},
+	[ETH_SS_STATS_ETH_PHY] = {
+		.per_dev	= false,
+		.count		= __ETHTOOL_A_STATS_ETH_PHY_CNT,
+		.strings	= stats_eth_phy_names,
+	},
 };
 
 struct strset_req_info {
-- 
2.30.2

