Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7F3E3DF2AE
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 18:37:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234191AbhHCQh1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 12:37:27 -0400
Received: from mga17.intel.com ([192.55.52.151]:62813 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234078AbhHCQhX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 12:37:23 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10065"; a="194013591"
X-IronPort-AV: E=Sophos;i="5.84,292,1620716400"; 
   d="scan'208";a="194013591"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2021 09:37:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,292,1620716400"; 
   d="scan'208";a="500883498"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga001.jf.intel.com with ESMTP; 03 Aug 2021 09:37:00 -0700
Received: from alobakin-mobl.ger.corp.intel.com (eflejszm-mobl2.ger.corp.intel.com [10.213.26.164])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 173GahEr029968;
        Tue, 3 Aug 2021 17:36:56 +0100
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Lukasz Czapnik <lukasz.czapnik@intel.com>,
        Marcin Kubiak <marcin.kubiak@intel.com>,
        Michal Kubiak <michal.kubiak@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@intel.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Netanel Belgazal <netanel@amazon.com>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        Guy Tzalik <gtzalik@amazon.com>,
        Saeed Bishara <saeedb@amazon.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Russell King <linux@armlinux.org.uk>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Shay Agroskin <shayagr@amazon.com>,
        Sameeh Jubran <sameehj@amazon.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Danielle Ratson <danieller@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>, Andrew Lunn <andrew@lunn.ch>,
        Vladyslav Tarasiuk <vladyslavt@nvidia.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jian Shen <shenjian15@huawei.com>,
        Petr Vorel <petr.vorel@gmail.com>, Dan Murphy <dmurphy@ti.com>,
        Yangbo Lu <yangbo.lu@nxp.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Zheng Yongjun <zhengyongjun3@huawei.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org
Subject: [PATCH net-next 03/21] ethtool, stats: introduce standard XDP statistics
Date:   Tue,  3 Aug 2021 18:36:23 +0200
Message-Id: <20210803163641.3743-4-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210803163641.3743-1-alexandr.lobakin@intel.com>
References: <20210803163641.3743-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Most of the driver-side XDP enabled drivers provide some statistics
on XDP programs runs and different actions taken (number of passes,
drops, redirects etc.).
Regarding that it's almost pretty the same across all the drivers
(which is obvious), we can implement some sort of "standardized"
statistics using Ethtool standard stats infra to eliminate a lot
of code and stringsets duplication, different approaches to count
these stats and so on.
These new 12 fields provided by the standard XDP stats should cover
most, if not all, stats that might be interesting for collecting and
tracking.
Note that most NIC drivers keep XDP statistics on a per-channel
basis, so this also introduces a new callback for getting a number
of channels which a driver will provide stats for. If it's not
implemented or returns 0, it means stats are global/device-wide.

Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
---
 include/linux/ethtool.h              |  36 +++++++
 include/uapi/linux/ethtool.h         |   2 +
 include/uapi/linux/ethtool_netlink.h |  34 +++++++
 net/ethtool/netlink.h                |   1 +
 net/ethtool/stats.c                  | 134 ++++++++++++++++++++++++++-
 net/ethtool/strset.c                 |   5 +
 6 files changed, 211 insertions(+), 1 deletion(-)

diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index 4711b96dae0c..62d617ad9f50 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -380,6 +380,36 @@ struct ethtool_rmon_stats {
 	u64 hist_tx[ETHTOOL_RMON_HIST_MAX];
 };
 
+/**
+ * struct ethtool_xdp_stats - standard driver-side XDP statistics
+ * @packets: number of frames passed to bpf_prog_run_xdp().
+ * @errors: number of general XDP errors, if driver has one unified counter.
+ * @aborted: number of %XDP_ABORTED returns.
+ * @drop: number of %XDP_DROP returns.
+ * @invalid: number of returns of unallowed values (i.e. not XDP_*).
+ * @pass: number of %XDP_PASS returns.
+ * @redirect: number of successfully performed %XDP_REDIRECT requests.
+ * @redirect_errors: number of failed %XDP_REDIRECT requests.
+ * @tx: number of successfully performed %XDP_TX requests.
+ * @tx_errors: number of failed %XDP_TX requests.
+ * @xmit: number of xdp_frames successfully transmitted via .ndo_xdp_xmit().
+ * @xmit_drops: number of frames dropped from .ndo_xdp_xmit().
+ */
+struct ethtool_xdp_stats {
+	u64	packets;
+	u64	errors;
+	u64	aborted;
+	u64	drop;
+	u64	invalid;
+	u64	pass;
+	u64	redirect;
+	u64	redirect_errors;
+	u64	tx;
+	u64	tx_errors;
+	u64	xmit;
+	u64	xmit_drops;
+};
+
 #define ETH_MODULE_EEPROM_PAGE_LEN	128
 #define ETH_MODULE_MAX_I2C_ADDRESS	0x7f
 
@@ -570,6 +600,9 @@ struct ethtool_module_eeprom {
  * @get_eth_ctrl_stats: Query some of the IEEE 802.3 MAC Ctrl statistics.
  * @get_rmon_stats: Query some of the RMON (RFC 2819) statistics.
  *	Set %ranges to a pointer to zero-terminated array of byte ranges.
+ * @get_std_stats_channels: Get the number of channels which get_*_stats will
+ *	return statistics for.
+ * @get_xdp_stats: Query some XDP statistics.
  *
  * All operations are optional (i.e. the function pointer may be set
  * to %NULL) and callers must take this into account.  Callers must
@@ -689,6 +722,9 @@ struct ethtool_ops {
 	void	(*get_rmon_stats)(struct net_device *dev,
 				  struct ethtool_rmon_stats *rmon_stats,
 				  const struct ethtool_rmon_hist_range **ranges);
+	int	(*get_std_stats_channels)(struct net_device *dev, u32 sset);
+	void	(*get_xdp_stats)(struct net_device *dev,
+				 struct ethtool_xdp_stats *xdp_stats);
 };
 
 int ethtool_check_ops(const struct ethtool_ops *ops);
diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
index 67aa7134b301..c3f1f3cde739 100644
--- a/include/uapi/linux/ethtool.h
+++ b/include/uapi/linux/ethtool.h
@@ -674,6 +674,7 @@ enum ethtool_link_ext_substate_cable_issue {
  * @ETH_SS_STATS_ETH_MAC: names of IEEE 802.3 MAC statistics
  * @ETH_SS_STATS_ETH_CTRL: names of IEEE 802.3 MAC Control statistics
  * @ETH_SS_STATS_RMON: names of RMON statistics
+ * @ETH_SS_STATS_XDP: names of XDP statistics
  *
  * @ETH_SS_COUNT: number of defined string sets
  */
@@ -699,6 +700,7 @@ enum ethtool_stringset {
 	ETH_SS_STATS_ETH_MAC,
 	ETH_SS_STATS_ETH_CTRL,
 	ETH_SS_STATS_RMON,
+	ETH_SS_STATS_XDP,
 
 	/* add new constants above here */
 	ETH_SS_COUNT
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index b3b93710eff7..f9d19cfa9397 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -716,6 +716,7 @@ enum {
 	ETHTOOL_STATS_ETH_MAC,
 	ETHTOOL_STATS_ETH_CTRL,
 	ETHTOOL_STATS_RMON,
+	ETHTOOL_STATS_XDP,
 
 	/* add new constants above here */
 	__ETHTOOL_STATS_CNT
@@ -737,6 +738,8 @@ enum {
 	ETHTOOL_A_STATS_GRP_HIST_BKT_HI,	/* u32 */
 	ETHTOOL_A_STATS_GRP_HIST_VAL,		/* u64 */
 
+	ETHTOOL_A_STATS_GRP_STAT_BLOCK,		/* nest */
+
 	/* add new constants above here */
 	__ETHTOOL_A_STATS_GRP_CNT,
 	ETHTOOL_A_STATS_GRP_MAX = (__ETHTOOL_A_STATS_CNT - 1)
@@ -831,6 +834,37 @@ enum {
 	ETHTOOL_A_STATS_RMON_MAX = (__ETHTOOL_A_STATS_RMON_CNT - 1)
 };
 
+enum {
+	/* Number of frames passed to bpf_prog_run_xdp() */
+	ETHTOOL_A_STATS_XDP_PACKETS,
+	/* Number o general XDP errors if driver counts them together */
+	ETHTOOL_A_STATS_XDP_ERRORS,
+	/* Number of %XDP_ABORTED returns */
+	ETHTOOL_A_STATS_XDP_ABORTED,
+	/* Number of %XDP_DROP returns */
+	ETHTOOL_A_STATS_XDP_DROP,
+	/* Number of returns of unallowed values (i.e. not XDP_*) */
+	ETHTOOL_A_STATS_XDP_INVALID,
+	/* Number of %XDP_PASS returns */
+	ETHTOOL_A_STATS_XDP_PASS,
+	/* Number of successfully performed %XDP_REDIRECT requests */
+	ETHTOOL_A_STATS_XDP_REDIRECT,
+	/* Number of failed %XDP_REDIRECT requests */
+	ETHTOOL_A_STATS_XDP_REDIRECT_ERRORS,
+	/* Number of successfully performed %XDP_TX requests */
+	ETHTOOL_A_STATS_XDP_TX,
+	/* Number of failed %XDP_TX requests */
+	ETHTOOL_A_STATS_XDP_TX_ERRORS,
+	/* Number of xdp_frames successfully transmitted via .ndo_xdp_xmit() */
+	ETHTOOL_A_STATS_XDP_XMIT,
+	/* Number of frames dropped from .ndo_xdp_xmit() */
+	ETHTOOL_A_STATS_XDP_XMIT_DROPS,
+
+	/* Add new constants above here */
+	__ETHTOOL_A_STATS_XDP_CNT,
+	ETHTOOL_A_STATS_XDP_MAX = (__ETHTOOL_A_STATS_XDP_CNT - 1)
+};
+
 /* generic netlink info */
 #define ETHTOOL_GENL_NAME "ethtool"
 #define ETHTOOL_GENL_VERSION 1
diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
index 077aac3929a8..c7983bba0b43 100644
--- a/net/ethtool/netlink.h
+++ b/net/ethtool/netlink.h
@@ -397,5 +397,6 @@ extern const char stats_eth_phy_names[__ETHTOOL_A_STATS_ETH_PHY_CNT][ETH_GSTRING
 extern const char stats_eth_mac_names[__ETHTOOL_A_STATS_ETH_MAC_CNT][ETH_GSTRING_LEN];
 extern const char stats_eth_ctrl_names[__ETHTOOL_A_STATS_ETH_CTRL_CNT][ETH_GSTRING_LEN];
 extern const char stats_rmon_names[__ETHTOOL_A_STATS_RMON_CNT][ETH_GSTRING_LEN];
+extern const char stats_xdp_names[__ETHTOOL_A_STATS_XDP_CNT][ETH_GSTRING_LEN];
 
 #endif /* _NET_ETHTOOL_NETLINK_H */
diff --git a/net/ethtool/stats.c b/net/ethtool/stats.c
index 8b5c27e034f9..76f2a78e8d02 100644
--- a/net/ethtool/stats.c
+++ b/net/ethtool/stats.c
@@ -19,6 +19,8 @@ struct stats_reply_data {
 	struct ethtool_eth_ctrl_stats	ctrl_stats;
 	struct ethtool_rmon_stats	rmon_stats;
 	const struct ethtool_rmon_hist_range	*rmon_ranges;
+	u32				xdp_stats_channels;
+	struct ethtool_xdp_stats	*xdp_stats;
 };
 
 #define STATS_REPDATA(__reply_base) \
@@ -29,6 +31,7 @@ const char stats_std_names[__ETHTOOL_STATS_CNT][ETH_GSTRING_LEN] = {
 	[ETHTOOL_STATS_ETH_MAC]			= "eth-mac",
 	[ETHTOOL_STATS_ETH_CTRL]		= "eth-ctrl",
 	[ETHTOOL_STATS_RMON]			= "rmon",
+	[ETHTOOL_STATS_XDP]			= "xdp",
 };
 
 const char stats_eth_phy_names[__ETHTOOL_A_STATS_ETH_PHY_CNT][ETH_GSTRING_LEN] = {
@@ -73,6 +76,21 @@ const char stats_rmon_names[__ETHTOOL_A_STATS_RMON_CNT][ETH_GSTRING_LEN] = {
 	[ETHTOOL_A_STATS_RMON_JABBER]		= "etherStatsJabbers",
 };
 
+const char stats_xdp_names[__ETHTOOL_A_STATS_XDP_CNT][ETH_GSTRING_LEN] = {
+	[ETHTOOL_A_STATS_XDP_PACKETS]		= "packets",
+	[ETHTOOL_A_STATS_XDP_ERRORS]		= "errors",
+	[ETHTOOL_A_STATS_XDP_ABORTED]		= "aborted",
+	[ETHTOOL_A_STATS_XDP_DROP]		= "drop",
+	[ETHTOOL_A_STATS_XDP_INVALID]		= "invalid",
+	[ETHTOOL_A_STATS_XDP_PASS]		= "pass",
+	[ETHTOOL_A_STATS_XDP_REDIRECT]		= "redirect",
+	[ETHTOOL_A_STATS_XDP_REDIRECT_ERRORS]	= "redirect-errors",
+	[ETHTOOL_A_STATS_XDP_TX]		= "tx",
+	[ETHTOOL_A_STATS_XDP_TX_ERRORS]		= "tx-errors",
+	[ETHTOOL_A_STATS_XDP_XMIT]		= "xmit",
+	[ETHTOOL_A_STATS_XDP_XMIT_DROPS]	= "xmit-drops",
+};
+
 const struct nla_policy ethnl_stats_get_policy[ETHTOOL_A_STATS_GROUPS + 1] = {
 	[ETHTOOL_A_STATS_HEADER]	=
 		NLA_POLICY_NESTED(ethnl_header_policy),
@@ -101,6 +119,37 @@ static int stats_parse_request(struct ethnl_req_info *req_base,
 	return 0;
 }
 
+static int stats_prepare_data_xdp(struct net_device *dev,
+				  struct stats_reply_data *data)
+{
+	const struct ethtool_ops *ops = dev->ethtool_ops;
+	size_t size;
+	int ret;
+
+	/* Zero means stats are global/device-wide */
+	data->xdp_stats_channels = 0;
+
+	if (ops->get_std_stats_channels) {
+		ret = ops->get_std_stats_channels(dev, ETH_SS_STATS_XDP);
+		if (ret > 0)
+			data->xdp_stats_channels = ret;
+	}
+
+	size = array_size(min_not_zero(data->xdp_stats_channels, 1U),
+			  sizeof(*data->xdp_stats));
+	if (unlikely(size == SIZE_MAX))
+		return -EOVERFLOW;
+
+	data->xdp_stats = kvmalloc(size, GFP_KERNEL);
+	if (!data->xdp_stats)
+		return -ENOMEM;
+
+	memset(data->xdp_stats, 0xff, size);
+	ops->get_xdp_stats(dev, data->xdp_stats);
+
+	return 0;
+}
+
 static int stats_prepare_data(const struct ethnl_req_info *req_base,
 			      struct ethnl_reply_data *reply_base,
 			      struct genl_info *info)
@@ -125,6 +174,8 @@ static int stats_prepare_data(const struct ethnl_req_info *req_base,
 		     __ETHTOOL_A_STATS_ETH_CTRL_CNT);
 	BUILD_BUG_ON(offsetof(typeof(data->rmon_stats), hist) / sizeof(u64) !=
 		     __ETHTOOL_A_STATS_RMON_CNT);
+	BUILD_BUG_ON(sizeof(*data->xdp_stats) / sizeof(u64) !=
+		     __ETHTOOL_A_STATS_XDP_CNT);
 
 	/* Mark all stats as unset (see ETHTOOL_STAT_NOT_SET) to prevent them
 	 * from being reported to user space in case driver did not set them.
@@ -146,15 +197,19 @@ static int stats_prepare_data(const struct ethnl_req_info *req_base,
 	if (test_bit(ETHTOOL_STATS_RMON, req_info->stat_mask) &&
 	    ops->get_rmon_stats)
 		ops->get_rmon_stats(dev, &data->rmon_stats, &data->rmon_ranges);
+	if (test_bit(ETHTOOL_STATS_XDP, req_info->stat_mask) &&
+	    ops->get_xdp_stats)
+		ret = stats_prepare_data_xdp(dev, data);
 
 	ethnl_ops_complete(dev);
-	return 0;
+	return ret;
 }
 
 static int stats_reply_size(const struct ethnl_req_info *req_base,
 			    const struct ethnl_reply_data *reply_base)
 {
 	const struct stats_req_info *req_info = STATS_REQINFO(req_base);
+	const struct stats_reply_data *data = STATS_REPDATA(reply_base);
 	unsigned int n_grps = 0, n_stats = 0;
 	int len = 0;
 
@@ -180,6 +235,14 @@ static int stats_reply_size(const struct ethnl_req_info *req_base,
 			nla_total_size(4)) *	/* _A_STATS_GRP_HIST_BKT_HI */
 			ETHTOOL_RMON_HIST_MAX * 2;
 	}
+	if (test_bit(ETHTOOL_STATS_XDP, req_info->stat_mask)) {
+		n_stats += min_not_zero(data->xdp_stats_channels, 1U) *
+			   sizeof(*data->xdp_stats) / sizeof(u64);
+		n_grps++;
+
+		len += (nla_total_size(0) *	/* _A_STATS_GRP_STAT_BLOCK */
+			data->xdp_stats_channels);
+	}
 
 	len += n_grps * (nla_total_size(0) + /* _A_STATS_GRP */
 			 nla_total_size(4) + /* _A_STATS_GRP_ID */
@@ -356,6 +419,64 @@ static int stats_put_rmon_stats(struct sk_buff *skb,
 	return 0;
 }
 
+static int stats_put_xdp_stats_one(struct sk_buff *skb,
+				   const struct ethtool_xdp_stats *xdp_stats)
+{
+	if (stat_put(skb, ETHTOOL_A_STATS_XDP_PACKETS,
+		     xdp_stats->packets) ||
+	    stat_put(skb, ETHTOOL_A_STATS_XDP_ABORTED,
+		     xdp_stats->aborted) ||
+	    stat_put(skb, ETHTOOL_A_STATS_XDP_DROP,
+		     xdp_stats->drop) ||
+	    stat_put(skb, ETHTOOL_A_STATS_XDP_INVALID,
+		     xdp_stats->invalid) ||
+	    stat_put(skb, ETHTOOL_A_STATS_XDP_PASS,
+		     xdp_stats->pass) ||
+	    stat_put(skb, ETHTOOL_A_STATS_XDP_REDIRECT,
+		     xdp_stats->redirect) ||
+	    stat_put(skb, ETHTOOL_A_STATS_XDP_REDIRECT_ERRORS,
+		     xdp_stats->redirect_errors) ||
+	    stat_put(skb, ETHTOOL_A_STATS_XDP_TX,
+		     xdp_stats->tx) ||
+	    stat_put(skb, ETHTOOL_A_STATS_XDP_TX_ERRORS,
+		     xdp_stats->tx_errors) ||
+	    stat_put(skb, ETHTOOL_A_STATS_XDP_XMIT,
+		     xdp_stats->xmit) ||
+	    stat_put(skb, ETHTOOL_A_STATS_XDP_XMIT_DROPS,
+		     xdp_stats->xmit_drops))
+		return -EMSGSIZE;
+
+	return 0;
+}
+
+static int stats_put_xdp_stats(struct sk_buff *skb,
+			       const struct stats_reply_data *data)
+{
+	struct nlattr *nest;
+	int i;
+
+	if (!data->xdp_stats_channels)
+		return stats_put_xdp_stats_one(skb, data->xdp_stats);
+
+	for (i = 0; i < data->xdp_stats_channels; i++) {
+		nest = nla_nest_start(skb, ETHTOOL_A_STATS_GRP_STAT_BLOCK);
+		if (!nest)
+			return -EMSGSIZE;
+
+		if (stats_put_xdp_stats_one(skb, data->xdp_stats + i))
+			goto err_cancel_xdp;
+
+		nla_nest_end(skb, nest);
+	}
+
+	return 0;
+
+err_cancel_xdp:
+	nla_nest_cancel(skb, nest);
+
+	return -EMSGSIZE;
+}
+
 static int stats_put_stats(struct sk_buff *skb,
 			   const struct stats_reply_data *data,
 			   u32 id, u32 ss_id,
@@ -406,10 +527,20 @@ static int stats_fill_reply(struct sk_buff *skb,
 	if (!ret && test_bit(ETHTOOL_STATS_RMON, req_info->stat_mask))
 		ret = stats_put_stats(skb, data, ETHTOOL_STATS_RMON,
 				      ETH_SS_STATS_RMON, stats_put_rmon_stats);
+	if (!ret && test_bit(ETHTOOL_STATS_XDP, req_info->stat_mask))
+		ret = stats_put_stats(skb, data, ETHTOOL_STATS_XDP,
+				      ETH_SS_STATS_XDP, stats_put_xdp_stats);
 
 	return ret;
 }
 
+static void stats_cleanup_data(struct ethnl_reply_data *reply_data)
+{
+	struct stats_reply_data *data = STATS_REPDATA(reply_data);
+
+	kvfree(data->xdp_stats);
+}
+
 const struct ethnl_request_ops ethnl_stats_request_ops = {
 	.request_cmd		= ETHTOOL_MSG_STATS_GET,
 	.reply_cmd		= ETHTOOL_MSG_STATS_GET_REPLY,
@@ -421,4 +552,5 @@ const struct ethnl_request_ops ethnl_stats_request_ops = {
 	.prepare_data		= stats_prepare_data,
 	.reply_size		= stats_reply_size,
 	.fill_reply		= stats_fill_reply,
+	.cleanup_data		= stats_cleanup_data,
 };
diff --git a/net/ethtool/strset.c b/net/ethtool/strset.c
index 2d51b7ab4dc5..a149048f9c34 100644
--- a/net/ethtool/strset.c
+++ b/net/ethtool/strset.c
@@ -105,6 +105,11 @@ static const struct strset_info info_template[] = {
 		.count		= __ETHTOOL_A_STATS_RMON_CNT,
 		.strings	= stats_rmon_names,
 	},
+	[ETH_SS_STATS_XDP] = {
+		.per_dev	= false,
+		.count		= __ETHTOOL_A_STATS_XDP_CNT,
+		.strings	= stats_xdp_names,
+	},
 };
 
 struct strset_req_info {
-- 
2.31.1

