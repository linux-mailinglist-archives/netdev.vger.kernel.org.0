Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B36E361793
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 04:28:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238291AbhDPC20 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 22:28:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:53690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238251AbhDPC2V (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Apr 2021 22:28:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1C45F613B0;
        Fri, 16 Apr 2021 02:27:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618540077;
        bh=nDfrpOXKAYYoS8hiLO3TmFrgvf1NTjcImWsdG/osDOw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UOeQlUh+D/prr1E8MbY1nR1OivIwhulsxZZwyBmWr+ekA3JuYv7xpuJ+cGJWNhPlW
         rw6i+2BqhAIYCMyL95PcX3lqRsR9Mnm8c9V2yUSI68Kp1UfZI/VN6fIhGz2l7I+ru5
         zJTUfqhV8lyrsqsUNywQzLw6hHbzWoW1ynnI/DHF+mc3XmwRZDlj8N+WzoppYFEUI7
         KA3tUrHW2wUJfZrilYLrJeFsWNxQ6kQB+QnaEy590xd4tFE49JhcBxmasul3njqQPf
         BSOCEexxAH3YTiIYKOBd4mPRgoG+3enfHVOUTBRIVxnWkBZ0Rv+4jF7tHqOuRsT+jb
         kBsclNRdcgydQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, andrew@lunn.ch, mkubecek@suse.cz,
        idosch@nvidia.com, saeedm@nvidia.com, michael.chan@broadcom.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 5/9] ethtool: add interface to read standard MAC Ctrl stats
Date:   Thu, 15 Apr 2021 19:27:48 -0700
Message-Id: <20210416022752.2814621-6-kuba@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210416022752.2814621-1-kuba@kernel.org>
References: <20210416022752.2814621-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Number of devices maintains the standard-based MAC control
counters for control frames. Add a API for those.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 include/linux/ethtool.h              | 11 ++++++++++
 include/uapi/linux/ethtool.h         |  2 ++
 include/uapi/linux/ethtool_netlink.h | 14 ++++++++++++
 net/ethtool/netlink.h                |  1 +
 net/ethtool/stats.c                  | 33 ++++++++++++++++++++++++++++
 net/ethtool/strset.c                 |  5 +++++
 6 files changed, 66 insertions(+)

diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index 3c689a13e679..22bab13c5729 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -285,6 +285,15 @@ struct ethtool_eth_phy_stats {
 	u64 SymbolErrorDuringCarrier;
 };
 
+/* Basic IEEE 802.3 MAC Ctrl statistics (30.3.3.*), not otherwise exposed
+ * via a more targeted API.
+ */
+struct ethtool_eth_ctrl_stats {
+	u64 MACControlFramesTransmitted;
+	u64 MACControlFramesReceived;
+	u64 UnsupportedOpcodesReceived;
+};
+
 /**
  * struct ethtool_pause_stats - statistics for IEEE 802.3x pause frames
  * @tx_pause_frames: transmitted pause frame count. Reported to user space
@@ -638,6 +647,8 @@ struct ethtool_ops {
 				     struct ethtool_eth_phy_stats *phy_stats);
 	void	(*get_eth_mac_stats)(struct net_device *dev,
 				     struct ethtool_eth_mac_stats *mac_stats);
+	void	(*get_eth_ctrl_stats)(struct net_device *dev,
+				      struct ethtool_eth_ctrl_stats *ctrl_stats);
 };
 
 int ethtool_check_ops(const struct ethtool_ops *ops);
diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
index c227376d811a..9cb8df89d4f2 100644
--- a/include/uapi/linux/ethtool.h
+++ b/include/uapi/linux/ethtool.h
@@ -672,6 +672,7 @@ enum ethtool_link_ext_substate_cable_issue {
  * @ETH_SS_STATS_STD: standardized stats
  * @ETH_SS_STATS_ETH_PHY: names of IEEE 802.3 PHY statistics
  * @ETH_SS_STATS_ETH_MAC: names of IEEE 802.3 MAC statistics
+ * @ETH_SS_STATS_ETH_CTRL: names of IEEE 802.3 MAC Control statistics
  *
  * @ETH_SS_COUNT: number of defined string sets
  */
@@ -695,6 +696,7 @@ enum ethtool_stringset {
 	ETH_SS_STATS_STD,
 	ETH_SS_STATS_ETH_PHY,
 	ETH_SS_STATS_ETH_MAC,
+	ETH_SS_STATS_ETH_CTRL,
 
 	/* add new constants above here */
 	ETH_SS_COUNT
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index f0fbe8f4eb1b..2ea5f049df6a 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -699,6 +699,7 @@ enum {
 enum {
 	ETHTOOL_STATS_ETH_PHY,
 	ETHTOOL_STATS_ETH_MAC,
+	ETHTOOL_STATS_ETH_CTRL,
 
 	/* add new constants above here */
 	__ETHTOOL_STATS_CNT
@@ -779,6 +780,19 @@ enum {
 	ETHTOOL_A_STATS_ETH_MAC_MAX = (__ETHTOOL_A_STATS_ETH_MAC_CNT - 1)
 };
 
+enum {
+	/* 30.3.3.3 aMACControlFramesTransmitted */
+	ETHTOOL_A_STATS_ETH_CTRL_3_TX,
+	/* 30.3.3.4 aMACControlFramesReceived */
+	ETHTOOL_A_STATS_ETH_CTRL_4_RX,
+	/* 30.3.3.5 aUnsupportedOpcodesReceived */
+	ETHTOOL_A_STATS_ETH_CTRL_5_RX_UNSUP,
+
+	/* add new constants above here */
+	__ETHTOOL_A_STATS_ETH_CTRL_CNT,
+	ETHTOOL_A_STATS_ETH_CTRL_MAX = (__ETHTOOL_A_STATS_ETH_CTRL_CNT - 1)
+};
+
 /* generic netlink info */
 #define ETHTOOL_GENL_NAME "ethtool"
 #define ETHTOOL_GENL_VERSION 1
diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
index 9c5f6ee71864..bd96eb57c07c 100644
--- a/net/ethtool/netlink.h
+++ b/net/ethtool/netlink.h
@@ -404,5 +404,6 @@ int ethnl_set_fec(struct sk_buff *skb, struct genl_info *info);
 extern const char stats_std_names[__ETHTOOL_STATS_CNT][ETH_GSTRING_LEN];
 extern const char stats_eth_phy_names[__ETHTOOL_A_STATS_ETH_PHY_CNT][ETH_GSTRING_LEN];
 extern const char stats_eth_mac_names[__ETHTOOL_A_STATS_ETH_MAC_CNT][ETH_GSTRING_LEN];
+extern const char stats_eth_ctrl_names[__ETHTOOL_A_STATS_ETH_CTRL_CNT][ETH_GSTRING_LEN];
 
 #endif /* _NET_ETHTOOL_NETLINK_H */
diff --git a/net/ethtool/stats.c b/net/ethtool/stats.c
index e80175872226..f4fded66731c 100644
--- a/net/ethtool/stats.c
+++ b/net/ethtool/stats.c
@@ -16,6 +16,7 @@ struct stats_reply_data {
 	struct ethnl_reply_data		base;
 	struct ethtool_eth_phy_stats	phy_stats;
 	struct ethtool_eth_mac_stats	mac_stats;
+	struct ethtool_eth_ctrl_stats	ctrl_stats;
 };
 
 #define STATS_REPDATA(__reply_base) \
@@ -24,6 +25,7 @@ struct stats_reply_data {
 const char stats_std_names[__ETHTOOL_STATS_CNT][ETH_GSTRING_LEN] = {
 	[ETHTOOL_STATS_ETH_PHY]			= "eth-phy",
 	[ETHTOOL_STATS_ETH_MAC]			= "eth-mac",
+	[ETHTOOL_STATS_ETH_CTRL]		= "eth-ctrl",
 };
 
 const char stats_eth_phy_names[__ETHTOOL_A_STATS_ETH_PHY_CNT][ETH_GSTRING_LEN] = {
@@ -55,6 +57,12 @@ const char stats_eth_mac_names[__ETHTOOL_A_STATS_ETH_MAC_CNT][ETH_GSTRING_LEN] =
 	[ETHTOOL_A_STATS_ETH_MAC_25_TOO_LONG_ERR]	= "FrameTooLongErrors",
 };
 
+const char stats_eth_ctrl_names[__ETHTOOL_A_STATS_ETH_CTRL_CNT][ETH_GSTRING_LEN] = {
+	[ETHTOOL_A_STATS_ETH_CTRL_3_TX]		= "MACControlFramesTransmitted",
+	[ETHTOOL_A_STATS_ETH_CTRL_4_RX]		= "MACControlFramesReceived",
+	[ETHTOOL_A_STATS_ETH_CTRL_5_RX_UNSUP]	= "UnsupportedOpcodesReceived",
+};
+
 const struct nla_policy ethnl_stats_get_policy[ETHTOOL_A_STATS_GROUPS + 1] = {
 	[ETHTOOL_A_STATS_HEADER]	=
 		NLA_POLICY_NESTED(ethnl_header_policy),
@@ -98,6 +106,7 @@ static int stats_prepare_data(const struct ethnl_req_info *req_base,
 
 	memset(&data->phy_stats, 0xff, sizeof(data->phy_stats));
 	memset(&data->mac_stats, 0xff, sizeof(data->mac_stats));
+	memset(&data->ctrl_stats, 0xff, sizeof(data->mac_stats));
 
 	if (test_bit(ETHTOOL_STATS_ETH_PHY, req_info->stat_mask) &&
 	    dev->ethtool_ops->get_eth_phy_stats)
@@ -105,6 +114,9 @@ static int stats_prepare_data(const struct ethnl_req_info *req_base,
 	if (test_bit(ETHTOOL_STATS_ETH_MAC, req_info->stat_mask) &&
 	    dev->ethtool_ops->get_eth_mac_stats)
 		dev->ethtool_ops->get_eth_mac_stats(dev, &data->mac_stats);
+	if (test_bit(ETHTOOL_STATS_ETH_CTRL, req_info->stat_mask) &&
+	    dev->ethtool_ops->get_eth_ctrl_stats)
+		dev->ethtool_ops->get_eth_ctrl_stats(dev, &data->ctrl_stats);
 
 	ethnl_ops_complete(dev);
 	return 0;
@@ -125,6 +137,10 @@ static int stats_reply_size(const struct ethnl_req_info *req_base,
 		n_stats += sizeof(struct ethtool_eth_mac_stats) / sizeof(u64);
 		n_grps++;
 	}
+	if (test_bit(ETHTOOL_STATS_ETH_CTRL, req_info->stat_mask)) {
+		n_stats += sizeof(struct ethtool_eth_ctrl_stats) / sizeof(u64);
+		n_grps++;
+	}
 
 	len += n_grps * (nla_total_size(0) + /* _A_STATS_GRP */
 			 nla_total_size(4) + /* _A_STATS_GRP_ID */
@@ -229,6 +245,19 @@ static int stats_put_mac_stats(struct sk_buff *skb,
 	return 0;
 }
 
+static int stats_put_ctrl_stats(struct sk_buff *skb,
+				const struct stats_reply_data *data)
+{
+	if (stat_put(skb, ETHTOOL_A_STATS_ETH_CTRL_3_TX,
+		     data->ctrl_stats.MACControlFramesTransmitted) ||
+	    stat_put(skb, ETHTOOL_A_STATS_ETH_CTRL_4_RX,
+		     data->ctrl_stats.MACControlFramesReceived) ||
+	    stat_put(skb, ETHTOOL_A_STATS_ETH_CTRL_5_RX_UNSUP,
+		     data->ctrl_stats.UnsupportedOpcodesReceived))
+		return -EMSGSIZE;
+	return 0;
+}
+
 static int stats_put_stats(struct sk_buff *skb,
 			   const struct stats_reply_data *data,
 			   u32 id, u32 ss_id,
@@ -272,6 +301,10 @@ static int stats_fill_reply(struct sk_buff *skb,
 		ret = stats_put_stats(skb, data, ETHTOOL_STATS_ETH_MAC,
 				      ETH_SS_STATS_ETH_MAC,
 				      stats_put_mac_stats);
+	if (!ret && test_bit(ETHTOOL_STATS_ETH_CTRL, req_info->stat_mask))
+		ret = stats_put_stats(skb, data, ETHTOOL_STATS_ETH_CTRL,
+				      ETH_SS_STATS_ETH_CTRL,
+				      stats_put_ctrl_stats);
 
 	return ret;
 }
diff --git a/net/ethtool/strset.c b/net/ethtool/strset.c
index a8aac7bcfcc9..a33c603a7a02 100644
--- a/net/ethtool/strset.c
+++ b/net/ethtool/strset.c
@@ -95,6 +95,11 @@ static const struct strset_info info_template[] = {
 		.count		= __ETHTOOL_A_STATS_ETH_MAC_CNT,
 		.strings	= stats_eth_mac_names,
 	},
+	[ETH_SS_STATS_ETH_CTRL] = {
+		.per_dev	= false,
+		.count		= __ETHTOOL_A_STATS_ETH_CTRL_CNT,
+		.strings	= stats_eth_ctrl_names,
+	},
 };
 
 struct strset_req_info {
-- 
2.30.2

