Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 987D5361794
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 04:28:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238302AbhDPC22 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 22:28:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:53710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238255AbhDPC2V (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Apr 2021 22:28:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8B6BB61184;
        Fri, 16 Apr 2021 02:27:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618540077;
        bh=lfZPqetMlh4j0+0FYRlteQtHn+EuOoZ1Y5xNB1Oox3E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gHrQGEh3ypSydUL/8q4BhqX3/MerGwfVLR2VFtGojviFkHRsmkFB0hh5SxHMtuTff
         DcYNgIGA0+1QZnN0mf7ArCO+lByE5be7aEUEssRfYrc/ECgLCcISIaaD5PrXQu1ExO
         2Vwbxb50Mch/XTzkKaHBfx10WFHtge8Y3ncGSobLZklAwUDwayv2ZTzzvKfP/CMCOy
         fTaI09oYIgik5hNGKguPq56CgvsYeH2ZhKYqMYrXTOdgG6YJ1QcDMwpsbYGsURrP3o
         zdDm3/4U4m//Hxk9iMl7hwaYTlDji91xVY/jzLlBXGgWe+sxfGACLgtyJfWTxGg5wS
         l1nAKBlXv485Q==
From:   Jakub Kicinski <kuba@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, andrew@lunn.ch, mkubecek@suse.cz,
        idosch@nvidia.com, saeedm@nvidia.com, michael.chan@broadcom.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 6/9] ethtool: add interface to read RMON stats
Date:   Thu, 15 Apr 2021 19:27:49 -0700
Message-Id: <20210416022752.2814621-7-kuba@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210416022752.2814621-1-kuba@kernel.org>
References: <20210416022752.2814621-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Most devices maintain RMON (RFC 2819) stats - particularly
the "histogram" of packets received by size. Unlike other
RFCs which duplicate IEEE stats, the short/oversized frame
counters in RMON don't seem to match IEEE stats 1-to-1 either,
so expose those, too. Do not expose basic packet, CRC errors
etc - those are already otherwise covered.

Because standard defines packet ranges only up to 1518, and
everything above that should theoretically be "oversized"
- devices often create their own ranges.

Going beyond what the RFC defines - expose the "histogram"
in the Tx direction (assume for now that the ranges will
be the same).

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 include/linux/ethtool.h              | 43 ++++++++++++++
 include/uapi/linux/ethtool.h         |  2 +
 include/uapi/linux/ethtool_netlink.h | 23 ++++++++
 net/ethtool/netlink.h                |  1 +
 net/ethtool/stats.c                  | 87 ++++++++++++++++++++++++++++
 net/ethtool/strset.c                 |  5 ++
 6 files changed, 161 insertions(+)

diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index 22bab13c5729..64f3953ee555 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -346,6 +346,44 @@ struct ethtool_fec_stats {
 	} corrected_blocks, uncorrectable_blocks, corrected_bits;
 };
 
+/**
+ * struct ethtool_rmon_hist_range - byte range for histogram statistics
+ * @low: low bound of the bucket (inclusive)
+ * @high: high bound of the bucket (inclusive)
+ */
+struct ethtool_rmon_hist_range {
+	u16 low;
+	u16 high;
+};
+
+#define ETHTOOL_RMON_HIST_MAX	10
+
+/**
+ * struct ethtool_rmon_stats - selected RMON (RFC 2819) statistics
+ * @undersize_pkts: Equivalent to `etherStatsUndersizePkts` from the RFC.
+ * @oversize_pkts: Equivalent to `etherStatsOversizePkts` from the RFC.
+ * @fragments: Equivalent to `etherStatsFragments` from the RFC.
+ * @jabbers: Equivalent to `etherStatsJabbers` from the RFC.
+ * @hist: Packet counter for packet length buckets (e.g.
+ *	`etherStatsPkts128to255Octets` from the RFC).
+ * @hist_tx: Tx counters in similar form to @hist, not defined in the RFC.
+ *
+ * Selection of RMON (RFC 2819) statistics which are not exposed via different
+ * APIs, primarily the packet-length-based counters.
+ * Unfortunately different designs choose different buckets beyond
+ * the 1024B mark (jumbo frame teritory), so the definition of the bucket
+ * ranges is left to the driver.
+ */
+struct ethtool_rmon_stats {
+	u64 undersize_pkts;
+	u64 oversize_pkts;
+	u64 fragments;
+	u64 jabbers;
+
+	u64 hist[ETHTOOL_RMON_HIST_MAX];
+	u64 hist_tx[ETHTOOL_RMON_HIST_MAX];
+};
+
 #define ETH_MODULE_EEPROM_PAGE_LEN	128
 #define ETH_MODULE_MAX_I2C_ADDRESS	0x7f
 
@@ -533,6 +571,8 @@ struct ethtool_module_eeprom {
  *	read.
  * @get_eth_phy_stats: Query some of the IEEE 802.3 PHY statistics.
  * @get_eth_mac_stats: Query some of the IEEE 802.3 MAC statistics.
+ * @get_rmon_stats: Query some of the RMON (RFC 2819) statistics.
+ *	Set %ranges to a pointer to zero-terminated array of byte ranges.
  *
  * All operations are optional (i.e. the function pointer may be set
  * to %NULL) and callers must take this into account.  Callers must
@@ -649,6 +689,9 @@ struct ethtool_ops {
 				     struct ethtool_eth_mac_stats *mac_stats);
 	void	(*get_eth_ctrl_stats)(struct net_device *dev,
 				      struct ethtool_eth_ctrl_stats *ctrl_stats);
+	void	(*get_rmon_stats)(struct net_device *dev,
+				  struct ethtool_rmon_stats *rmon_stats,
+				  const struct ethtool_rmon_hist_range **ranges);
 };
 
 int ethtool_check_ops(const struct ethtool_ops *ops);
diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
index 9cb8df89d4f2..cfef6b08169a 100644
--- a/include/uapi/linux/ethtool.h
+++ b/include/uapi/linux/ethtool.h
@@ -673,6 +673,7 @@ enum ethtool_link_ext_substate_cable_issue {
  * @ETH_SS_STATS_ETH_PHY: names of IEEE 802.3 PHY statistics
  * @ETH_SS_STATS_ETH_MAC: names of IEEE 802.3 MAC statistics
  * @ETH_SS_STATS_ETH_CTRL: names of IEEE 802.3 MAC Control statistics
+ * @ETH_SS_STATS_RMON: names of RMON statistics
  *
  * @ETH_SS_COUNT: number of defined string sets
  */
@@ -697,6 +698,7 @@ enum ethtool_stringset {
 	ETH_SS_STATS_ETH_PHY,
 	ETH_SS_STATS_ETH_MAC,
 	ETH_SS_STATS_ETH_CTRL,
+	ETH_SS_STATS_RMON,
 
 	/* add new constants above here */
 	ETH_SS_COUNT
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index 2ea5f049df6a..825cfda1c5d5 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -700,6 +700,7 @@ enum {
 	ETHTOOL_STATS_ETH_PHY,
 	ETHTOOL_STATS_ETH_MAC,
 	ETHTOOL_STATS_ETH_CTRL,
+	ETHTOOL_STATS_RMON,
 
 	/* add new constants above here */
 	__ETHTOOL_STATS_CNT
@@ -714,6 +715,13 @@ enum {
 
 	ETHTOOL_A_STATS_GRP_STAT,		/* nest */
 
+	ETHTOOL_A_STATS_GRP_HIST_RX,		/* nest */
+	ETHTOOL_A_STATS_GRP_HIST_TX,		/* nest */
+
+	ETHTOOL_A_STATS_GRP_HIST_BKT_LOW,	/* u32 */
+	ETHTOOL_A_STATS_GRP_HIST_BKT_HI,	/* u32 */
+	ETHTOOL_A_STATS_GRP_HIST_VAL,		/* u64 */
+
 	/* add new constants above here */
 	__ETHTOOL_A_STATS_GRP_CNT,
 	ETHTOOL_A_STATS_GRP_MAX = (__ETHTOOL_A_STATS_CNT - 1)
@@ -793,6 +801,21 @@ enum {
 	ETHTOOL_A_STATS_ETH_CTRL_MAX = (__ETHTOOL_A_STATS_ETH_CTRL_CNT - 1)
 };
 
+enum {
+	/* etherStatsUndersizePkts */
+	ETHTOOL_A_STATS_RMON_UNDERSIZE,
+	/* etherStatsOversizePkts */
+	ETHTOOL_A_STATS_RMON_OVERSIZE,
+	/* etherStatsFragments */
+	ETHTOOL_A_STATS_RMON_FRAG,
+	/* etherStatsJabbers */
+	ETHTOOL_A_STATS_RMON_JABBER,
+
+	/* add new constants above here */
+	__ETHTOOL_A_STATS_RMON_CNT,
+	ETHTOOL_A_STATS_RMON_MAX = (__ETHTOOL_A_STATS_RMON_CNT - 1)
+};
+
 /* generic netlink info */
 #define ETHTOOL_GENL_NAME "ethtool"
 #define ETHTOOL_GENL_VERSION 1
diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
index bd96eb57c07c..8abcbc10796c 100644
--- a/net/ethtool/netlink.h
+++ b/net/ethtool/netlink.h
@@ -405,5 +405,6 @@ extern const char stats_std_names[__ETHTOOL_STATS_CNT][ETH_GSTRING_LEN];
 extern const char stats_eth_phy_names[__ETHTOOL_A_STATS_ETH_PHY_CNT][ETH_GSTRING_LEN];
 extern const char stats_eth_mac_names[__ETHTOOL_A_STATS_ETH_MAC_CNT][ETH_GSTRING_LEN];
 extern const char stats_eth_ctrl_names[__ETHTOOL_A_STATS_ETH_CTRL_CNT][ETH_GSTRING_LEN];
+extern const char stats_rmon_names[__ETHTOOL_A_STATS_RMON_CNT][ETH_GSTRING_LEN];
 
 #endif /* _NET_ETHTOOL_NETLINK_H */
diff --git a/net/ethtool/stats.c b/net/ethtool/stats.c
index f4fded66731c..acb2b080c358 100644
--- a/net/ethtool/stats.c
+++ b/net/ethtool/stats.c
@@ -17,6 +17,8 @@ struct stats_reply_data {
 	struct ethtool_eth_phy_stats	phy_stats;
 	struct ethtool_eth_mac_stats	mac_stats;
 	struct ethtool_eth_ctrl_stats	ctrl_stats;
+	struct ethtool_rmon_stats	rmon_stats;
+	const struct ethtool_rmon_hist_range	*rmon_ranges;
 };
 
 #define STATS_REPDATA(__reply_base) \
@@ -26,6 +28,7 @@ const char stats_std_names[__ETHTOOL_STATS_CNT][ETH_GSTRING_LEN] = {
 	[ETHTOOL_STATS_ETH_PHY]			= "eth-phy",
 	[ETHTOOL_STATS_ETH_MAC]			= "eth-mac",
 	[ETHTOOL_STATS_ETH_CTRL]		= "eth-ctrl",
+	[ETHTOOL_STATS_RMON]			= "rmon",
 };
 
 const char stats_eth_phy_names[__ETHTOOL_A_STATS_ETH_PHY_CNT][ETH_GSTRING_LEN] = {
@@ -63,6 +66,13 @@ const char stats_eth_ctrl_names[__ETHTOOL_A_STATS_ETH_CTRL_CNT][ETH_GSTRING_LEN]
 	[ETHTOOL_A_STATS_ETH_CTRL_5_RX_UNSUP]	= "UnsupportedOpcodesReceived",
 };
 
+const char stats_rmon_names[__ETHTOOL_A_STATS_RMON_CNT][ETH_GSTRING_LEN] = {
+	[ETHTOOL_A_STATS_RMON_UNDERSIZE]	= "etherStatsUndersizePkts",
+	[ETHTOOL_A_STATS_RMON_OVERSIZE]		= "etherStatsOversizePkts",
+	[ETHTOOL_A_STATS_RMON_FRAG]		= "etherStatsFragments",
+	[ETHTOOL_A_STATS_RMON_JABBER]		= "etherStatsJabbers",
+};
+
 const struct nla_policy ethnl_stats_get_policy[ETHTOOL_A_STATS_GROUPS + 1] = {
 	[ETHTOOL_A_STATS_HEADER]	=
 		NLA_POLICY_NESTED(ethnl_header_policy),
@@ -107,6 +117,7 @@ static int stats_prepare_data(const struct ethnl_req_info *req_base,
 	memset(&data->phy_stats, 0xff, sizeof(data->phy_stats));
 	memset(&data->mac_stats, 0xff, sizeof(data->mac_stats));
 	memset(&data->ctrl_stats, 0xff, sizeof(data->mac_stats));
+	memset(&data->rmon_stats, 0xff, sizeof(data->rmon_stats));
 
 	if (test_bit(ETHTOOL_STATS_ETH_PHY, req_info->stat_mask) &&
 	    dev->ethtool_ops->get_eth_phy_stats)
@@ -117,6 +128,10 @@ static int stats_prepare_data(const struct ethnl_req_info *req_base,
 	if (test_bit(ETHTOOL_STATS_ETH_CTRL, req_info->stat_mask) &&
 	    dev->ethtool_ops->get_eth_ctrl_stats)
 		dev->ethtool_ops->get_eth_ctrl_stats(dev, &data->ctrl_stats);
+	if (test_bit(ETHTOOL_STATS_RMON, req_info->stat_mask) &&
+	    dev->ethtool_ops->get_rmon_stats)
+		dev->ethtool_ops->get_rmon_stats(dev, &data->rmon_stats,
+						 &data->rmon_ranges);
 
 	ethnl_ops_complete(dev);
 	return 0;
@@ -141,6 +156,16 @@ static int stats_reply_size(const struct ethnl_req_info *req_base,
 		n_stats += sizeof(struct ethtool_eth_ctrl_stats) / sizeof(u64);
 		n_grps++;
 	}
+	if (test_bit(ETHTOOL_STATS_RMON, req_info->stat_mask)) {
+		n_stats += sizeof(struct ethtool_rmon_stats) / sizeof(u64);
+		n_grps++;
+		/* Above includes the space for _A_STATS_GRP_HIST_VALs */
+
+		len += (nla_total_size(0) +	/* _A_STATS_GRP_HIST */
+			nla_total_size(4) +	/* _A_STATS_GRP_HIST_BKT_LOW */
+			nla_total_size(4)) *	/* _A_STATS_GRP_HIST_BKT_HI */
+			ETHTOOL_RMON_HIST_MAX * 2;
+	}
 
 	len += n_grps * (nla_total_size(0) + /* _A_STATS_GRP */
 			 nla_total_size(4) + /* _A_STATS_GRP_ID */
@@ -258,6 +283,65 @@ static int stats_put_ctrl_stats(struct sk_buff *skb,
 	return 0;
 }
 
+static int stats_put_rmon_hist(struct sk_buff *skb, u32 attr, const u64 *hist,
+			       const struct ethtool_rmon_hist_range *ranges)
+{
+	struct nlattr *nest;
+	int i;
+
+	if (!ranges)
+		return 0;
+
+	for (i = 0; i <	ETHTOOL_RMON_HIST_MAX; i++) {
+		if (!ranges[i].low && !ranges[i].high)
+			break;
+		if (hist[i] == ETHTOOL_STAT_NOT_SET)
+			continue;
+
+		nest = nla_nest_start(skb, attr);
+		if (!nest)
+			return -EMSGSIZE;
+
+		if (nla_put_u32(skb, ETHTOOL_A_STATS_GRP_HIST_BKT_LOW,
+				ranges[i].low) ||
+		    nla_put_u32(skb, ETHTOOL_A_STATS_GRP_HIST_BKT_HI,
+				ranges[i].high) ||
+		    nla_put_u64_64bit(skb, ETHTOOL_A_STATS_GRP_HIST_VAL,
+				      hist[i], ETHTOOL_A_STATS_GRP_PAD))
+			goto err_cancel_hist;
+
+		nla_nest_end(skb, nest);
+	}
+
+	return 0;
+
+err_cancel_hist:
+	nla_nest_cancel(skb, nest);
+	return -EMSGSIZE;
+}
+
+static int stats_put_rmon_stats(struct sk_buff *skb,
+				const struct stats_reply_data *data)
+{
+	if (stats_put_rmon_hist(skb, ETHTOOL_A_STATS_GRP_HIST_RX,
+				data->rmon_stats.hist, data->rmon_ranges) ||
+	    stats_put_rmon_hist(skb, ETHTOOL_A_STATS_GRP_HIST_TX,
+				data->rmon_stats.hist_tx, data->rmon_ranges))
+		return -EMSGSIZE;
+
+	if (stat_put(skb, ETHTOOL_A_STATS_RMON_UNDERSIZE,
+		     data->rmon_stats.undersize_pkts) ||
+	    stat_put(skb, ETHTOOL_A_STATS_RMON_OVERSIZE,
+		     data->rmon_stats.oversize_pkts) ||
+	    stat_put(skb, ETHTOOL_A_STATS_RMON_FRAG,
+		     data->rmon_stats.fragments) ||
+	    stat_put(skb, ETHTOOL_A_STATS_RMON_JABBER,
+		     data->rmon_stats.jabbers))
+		return -EMSGSIZE;
+
+	return 0;
+}
+
 static int stats_put_stats(struct sk_buff *skb,
 			   const struct stats_reply_data *data,
 			   u32 id, u32 ss_id,
@@ -305,6 +389,9 @@ static int stats_fill_reply(struct sk_buff *skb,
 		ret = stats_put_stats(skb, data, ETHTOOL_STATS_ETH_CTRL,
 				      ETH_SS_STATS_ETH_CTRL,
 				      stats_put_ctrl_stats);
+	if (!ret && test_bit(ETHTOOL_STATS_RMON, req_info->stat_mask))
+		ret = stats_put_stats(skb, data, ETHTOOL_STATS_RMON,
+				      ETH_SS_STATS_RMON, stats_put_rmon_stats);
 
 	return ret;
 }
diff --git a/net/ethtool/strset.c b/net/ethtool/strset.c
index a33c603a7a02..b3029fff715d 100644
--- a/net/ethtool/strset.c
+++ b/net/ethtool/strset.c
@@ -100,6 +100,11 @@ static const struct strset_info info_template[] = {
 		.count		= __ETHTOOL_A_STATS_ETH_CTRL_CNT,
 		.strings	= stats_eth_ctrl_names,
 	},
+	[ETH_SS_STATS_RMON] = {
+		.per_dev	= false,
+		.count		= __ETHTOOL_A_STATS_RMON_CNT,
+		.strings	= stats_rmon_names,
+	},
 };
 
 struct strset_req_info {
-- 
2.30.2

