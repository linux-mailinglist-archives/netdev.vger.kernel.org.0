Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3723361792
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 04:28:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238277AbhDPC2Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 22:28:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:53670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238194AbhDPC2U (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Apr 2021 22:28:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A32A1611BF;
        Fri, 16 Apr 2021 02:27:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618540076;
        bh=Ddt50ubhJaNRp+1RdmmW/deqoRbW/iVtb9N023kRbNo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GOomKX1VSffhgt4EBnpCrQwWLXHtjBE4v65TtJj5sv+GdiGTkSGOzXzqnnfsN8cxv
         L0aAWw/KUf17OV7F5EAPUOz8lE9WcKiZq+4X/Nh123e60mI5X0HJpnoFwVtaHQeihO
         605dPTY0hOm8sHPB9zaESfOIJnzusoeu7H18heRRwMuLDBZctDlB83lMM3K9+9mPbf
         Ekd2z8IFjuptgnMTfLXMpYhSCCUrG+WunPa3xFH7TmtQvBz4/7KnJlNdt624XbR+0n
         OOIIn8qYCOj01lGT1zD79iKOH3ffnAC+Uwkh8TBt2JPYySolO0zCNz3qnrrxK8e99r
         JMsGfSFq7lhQg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, andrew@lunn.ch, mkubecek@suse.cz,
        idosch@nvidia.com, saeedm@nvidia.com, michael.chan@broadcom.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 4/9] ethtool: add interface to read standard MAC stats
Date:   Thu, 15 Apr 2021 19:27:47 -0700
Message-Id: <20210416022752.2814621-5-kuba@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210416022752.2814621-1-kuba@kernel.org>
References: <20210416022752.2814621-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Most of the MAC statistics are included in
struct rtnl_link_stats64, but some fields
are aggregated. Besides it's good to expose
these clearly hardware stats separately.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 include/linux/ethtool.h              | 31 ++++++++++
 include/uapi/linux/ethtool.h         |  2 +
 include/uapi/linux/ethtool_netlink.h | 53 ++++++++++++++++
 net/ethtool/netlink.h                |  1 +
 net/ethtool/stats.c                  | 90 ++++++++++++++++++++++++++++
 net/ethtool/strset.c                 |  5 ++
 6 files changed, 182 insertions(+)

diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index 2d5455eedbf4..3c689a13e679 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -250,6 +250,34 @@ static inline void ethtool_stats_init(u64 *stats, unsigned int n)
 		stats[n] = ETHTOOL_STAT_NOT_SET;
 }
 
+/* Basic IEEE 802.3 MAC statistics (30.3.1.1.*), not otherwise exposed
+ * via a more targeted API.
+ */
+struct ethtool_eth_mac_stats {
+	u64 FramesTransmittedOK;
+	u64 SingleCollisionFrames;
+	u64 MultipleCollisionFrames;
+	u64 FramesReceivedOK;
+	u64 FrameCheckSequenceErrors;
+	u64 AlignmentErrors;
+	u64 OctetsTransmittedOK;
+	u64 FramesWithDeferredXmissions;
+	u64 LateCollisions;
+	u64 FramesAbortedDueToXSColls;
+	u64 FramesLostDueToIntMACXmitError;
+	u64 CarrierSenseErrors;
+	u64 OctetsReceivedOK;
+	u64 FramesLostDueToIntMACRcvError;
+	u64 MulticastFramesXmittedOK;
+	u64 BroadcastFramesXmittedOK;
+	u64 FramesWithExcessiveDeferral;
+	u64 MulticastFramesReceivedOK;
+	u64 BroadcastFramesReceivedOK;
+	u64 InRangeLengthErrors;
+	u64 OutOfRangeLengthField;
+	u64 FrameTooLongErrors;
+};
+
 /* Basic IEEE 802.3 PHY statistics (30.3.2.1.*), not otherwise exposed
  * via a more targeted API.
  */
@@ -495,6 +523,7 @@ struct ethtool_module_eeprom {
  *	specified page. Returns a negative error code or the amount of bytes
  *	read.
  * @get_eth_phy_stats: Query some of the IEEE 802.3 PHY statistics.
+ * @get_eth_mac_stats: Query some of the IEEE 802.3 MAC statistics.
  *
  * All operations are optional (i.e. the function pointer may be set
  * to %NULL) and callers must take this into account.  Callers must
@@ -607,6 +636,8 @@ struct ethtool_ops {
 					     struct netlink_ext_ack *extack);
 	void	(*get_eth_phy_stats)(struct net_device *dev,
 				     struct ethtool_eth_phy_stats *phy_stats);
+	void	(*get_eth_mac_stats)(struct net_device *dev,
+				     struct ethtool_eth_mac_stats *mac_stats);
 };
 
 int ethtool_check_ops(const struct ethtool_ops *ops);
diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
index 190ae6e03918..c227376d811a 100644
--- a/include/uapi/linux/ethtool.h
+++ b/include/uapi/linux/ethtool.h
@@ -671,6 +671,7 @@ enum ethtool_link_ext_substate_cable_issue {
  * @ETH_SS_UDP_TUNNEL_TYPES: UDP tunnel types
  * @ETH_SS_STATS_STD: standardized stats
  * @ETH_SS_STATS_ETH_PHY: names of IEEE 802.3 PHY statistics
+ * @ETH_SS_STATS_ETH_MAC: names of IEEE 802.3 MAC statistics
  *
  * @ETH_SS_COUNT: number of defined string sets
  */
@@ -693,6 +694,7 @@ enum ethtool_stringset {
 	ETH_SS_UDP_TUNNEL_TYPES,
 	ETH_SS_STATS_STD,
 	ETH_SS_STATS_ETH_PHY,
+	ETH_SS_STATS_ETH_MAC,
 
 	/* add new constants above here */
 	ETH_SS_COUNT
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index a54cfe625f34..f0fbe8f4eb1b 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -698,6 +698,7 @@ enum {
 
 enum {
 	ETHTOOL_STATS_ETH_PHY,
+	ETHTOOL_STATS_ETH_MAC,
 
 	/* add new constants above here */
 	__ETHTOOL_STATS_CNT
@@ -726,6 +727,58 @@ enum {
 	ETHTOOL_A_STATS_ETH_PHY_MAX = (__ETHTOOL_A_STATS_ETH_PHY_CNT - 1)
 };
 
+enum {
+	/* 30.3.1.1.2 aFramesTransmittedOK */
+	ETHTOOL_A_STATS_ETH_MAC_2_TX_PKT,
+	/* 30.3.1.1.3 aSingleCollisionFrames */
+	ETHTOOL_A_STATS_ETH_MAC_3_SINGLE_COL,
+	/* 30.3.1.1.4 aMultipleCollisionFrames */
+	ETHTOOL_A_STATS_ETH_MAC_4_MULTI_COL,
+	/* 30.3.1.1.5 aFramesReceivedOK */
+	ETHTOOL_A_STATS_ETH_MAC_5_RX_PKT,
+	/* 30.3.1.1.6 aFrameCheckSequenceErrors */
+	ETHTOOL_A_STATS_ETH_MAC_6_FCS_ERR,
+	/* 30.3.1.1.7 aAlignmentErrors */
+	ETHTOOL_A_STATS_ETH_MAC_7_ALIGN_ERR,
+	/* 30.3.1.1.8 aOctetsTransmittedOK */
+	ETHTOOL_A_STATS_ETH_MAC_8_TX_BYTES,
+	/* 30.3.1.1.9 aFramesWithDeferredXmissions */
+	ETHTOOL_A_STATS_ETH_MAC_9_TX_DEFER,
+	/* 30.3.1.1.10 aLateCollisions */
+	ETHTOOL_A_STATS_ETH_MAC_10_LATE_COL,
+	/* 30.3.1.1.11 aFramesAbortedDueToXSColls */
+	ETHTOOL_A_STATS_ETH_MAC_11_XS_COL,
+	/* 30.3.1.1.12 aFramesLostDueToIntMACXmitError */
+	ETHTOOL_A_STATS_ETH_MAC_12_TX_INT_ERR,
+	/* 30.3.1.1.13 aCarrierSenseErrors */
+	ETHTOOL_A_STATS_ETH_MAC_13_CS_ERR,
+	/* 30.3.1.1.14 aOctetsReceivedOK */
+	ETHTOOL_A_STATS_ETH_MAC_14_RX_BYTES,
+	/* 30.3.1.1.15 aFramesLostDueToIntMACRcvError */
+	ETHTOOL_A_STATS_ETH_MAC_15_RX_INT_ERR,
+
+	/* 30.3.1.1.18 aMulticastFramesXmittedOK */
+	ETHTOOL_A_STATS_ETH_MAC_18_TX_MCAST,
+	/* 30.3.1.1.19 aBroadcastFramesXmittedOK */
+	ETHTOOL_A_STATS_ETH_MAC_19_TX_BCAST,
+	/* 30.3.1.1.20 aFramesWithExcessiveDeferral */
+	ETHTOOL_A_STATS_ETH_MAC_20_XS_DEFER,
+	/* 30.3.1.1.21 aMulticastFramesReceivedOK */
+	ETHTOOL_A_STATS_ETH_MAC_21_RX_MCAST,
+	/* 30.3.1.1.22 aBroadcastFramesReceivedOK */
+	ETHTOOL_A_STATS_ETH_MAC_22_RX_BCAST,
+	/* 30.3.1.1.23 aInRangeLengthErrors */
+	ETHTOOL_A_STATS_ETH_MAC_23_IR_LEN_ERR,
+	/* 30.3.1.1.24 aOutOfRangeLengthField */
+	ETHTOOL_A_STATS_ETH_MAC_24_OOR_LEN,
+	/* 30.3.1.1.25 aFrameTooLongErrors */
+	ETHTOOL_A_STATS_ETH_MAC_25_TOO_LONG_ERR,
+
+	/* add new constants above here */
+	__ETHTOOL_A_STATS_ETH_MAC_CNT,
+	ETHTOOL_A_STATS_ETH_MAC_MAX = (__ETHTOOL_A_STATS_ETH_MAC_CNT - 1)
+};
+
 /* generic netlink info */
 #define ETHTOOL_GENL_NAME "ethtool"
 #define ETHTOOL_GENL_VERSION 1
diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
index 79631792313e..9c5f6ee71864 100644
--- a/net/ethtool/netlink.h
+++ b/net/ethtool/netlink.h
@@ -403,5 +403,6 @@ int ethnl_set_fec(struct sk_buff *skb, struct genl_info *info);
 
 extern const char stats_std_names[__ETHTOOL_STATS_CNT][ETH_GSTRING_LEN];
 extern const char stats_eth_phy_names[__ETHTOOL_A_STATS_ETH_PHY_CNT][ETH_GSTRING_LEN];
+extern const char stats_eth_mac_names[__ETHTOOL_A_STATS_ETH_MAC_CNT][ETH_GSTRING_LEN];
 
 #endif /* _NET_ETHTOOL_NETLINK_H */
diff --git a/net/ethtool/stats.c b/net/ethtool/stats.c
index fd8f47178c06..e80175872226 100644
--- a/net/ethtool/stats.c
+++ b/net/ethtool/stats.c
@@ -15,6 +15,7 @@ struct stats_req_info {
 struct stats_reply_data {
 	struct ethnl_reply_data		base;
 	struct ethtool_eth_phy_stats	phy_stats;
+	struct ethtool_eth_mac_stats	mac_stats;
 };
 
 #define STATS_REPDATA(__reply_base) \
@@ -22,12 +23,38 @@ struct stats_reply_data {
 
 const char stats_std_names[__ETHTOOL_STATS_CNT][ETH_GSTRING_LEN] = {
 	[ETHTOOL_STATS_ETH_PHY]			= "eth-phy",
+	[ETHTOOL_STATS_ETH_MAC]			= "eth-mac",
 };
 
 const char stats_eth_phy_names[__ETHTOOL_A_STATS_ETH_PHY_CNT][ETH_GSTRING_LEN] = {
 	[ETHTOOL_A_STATS_ETH_PHY_5_SYM_ERR]	= "SymbolErrorDuringCarrier",
 };
 
+const char stats_eth_mac_names[__ETHTOOL_A_STATS_ETH_MAC_CNT][ETH_GSTRING_LEN] = {
+	[ETHTOOL_A_STATS_ETH_MAC_2_TX_PKT]	= "FramesTransmittedOK",
+	[ETHTOOL_A_STATS_ETH_MAC_3_SINGLE_COL]	= "SingleCollisionFrames",
+	[ETHTOOL_A_STATS_ETH_MAC_4_MULTI_COL]	= "MultipleCollisionFrames",
+	[ETHTOOL_A_STATS_ETH_MAC_5_RX_PKT]	= "FramesReceivedOK",
+	[ETHTOOL_A_STATS_ETH_MAC_6_FCS_ERR]	= "FrameCheckSequenceErrors",
+	[ETHTOOL_A_STATS_ETH_MAC_7_ALIGN_ERR]	= "AlignmentErrors",
+	[ETHTOOL_A_STATS_ETH_MAC_8_TX_BYTES]	= "OctetsTransmittedOK",
+	[ETHTOOL_A_STATS_ETH_MAC_9_TX_DEFER]	= "FramesWithDeferredXmissions",
+	[ETHTOOL_A_STATS_ETH_MAC_10_LATE_COL]	= "LateCollisions",
+	[ETHTOOL_A_STATS_ETH_MAC_11_XS_COL]	= "FramesAbortedDueToXSColls",
+	[ETHTOOL_A_STATS_ETH_MAC_12_TX_INT_ERR]	= "FramesLostDueToIntMACXmitError",
+	[ETHTOOL_A_STATS_ETH_MAC_13_CS_ERR]	= "CarrierSenseErrors",
+	[ETHTOOL_A_STATS_ETH_MAC_14_RX_BYTES]	= "OctetsReceivedOK",
+	[ETHTOOL_A_STATS_ETH_MAC_15_RX_INT_ERR]	= "FramesLostDueToIntMACRcvError",
+	[ETHTOOL_A_STATS_ETH_MAC_18_TX_MCAST]	= "MulticastFramesXmittedOK",
+	[ETHTOOL_A_STATS_ETH_MAC_19_TX_BCAST]	= "BroadcastFramesXmittedOK",
+	[ETHTOOL_A_STATS_ETH_MAC_20_XS_DEFER]	= "FramesWithExcessiveDeferral",
+	[ETHTOOL_A_STATS_ETH_MAC_21_RX_MCAST]	= "MulticastFramesReceivedOK",
+	[ETHTOOL_A_STATS_ETH_MAC_22_RX_BCAST]	= "BroadcastFramesReceivedOK",
+	[ETHTOOL_A_STATS_ETH_MAC_23_IR_LEN_ERR]	= "InRangeLengthErrors",
+	[ETHTOOL_A_STATS_ETH_MAC_24_OOR_LEN]	= "OutOfRangeLengthField",
+	[ETHTOOL_A_STATS_ETH_MAC_25_TOO_LONG_ERR]	= "FrameTooLongErrors",
+};
+
 const struct nla_policy ethnl_stats_get_policy[ETHTOOL_A_STATS_GROUPS + 1] = {
 	[ETHTOOL_A_STATS_HEADER]	=
 		NLA_POLICY_NESTED(ethnl_header_policy),
@@ -70,10 +97,14 @@ static int stats_prepare_data(const struct ethnl_req_info *req_base,
 		return ret;
 
 	memset(&data->phy_stats, 0xff, sizeof(data->phy_stats));
+	memset(&data->mac_stats, 0xff, sizeof(data->mac_stats));
 
 	if (test_bit(ETHTOOL_STATS_ETH_PHY, req_info->stat_mask) &&
 	    dev->ethtool_ops->get_eth_phy_stats)
 		dev->ethtool_ops->get_eth_phy_stats(dev, &data->phy_stats);
+	if (test_bit(ETHTOOL_STATS_ETH_MAC, req_info->stat_mask) &&
+	    dev->ethtool_ops->get_eth_mac_stats)
+		dev->ethtool_ops->get_eth_mac_stats(dev, &data->mac_stats);
 
 	ethnl_ops_complete(dev);
 	return 0;
@@ -90,6 +121,10 @@ static int stats_reply_size(const struct ethnl_req_info *req_base,
 		n_stats += sizeof(struct ethtool_eth_phy_stats) / sizeof(u64);
 		n_grps++;
 	}
+	if (test_bit(ETHTOOL_STATS_ETH_MAC, req_info->stat_mask)) {
+		n_stats += sizeof(struct ethtool_eth_mac_stats) / sizeof(u64);
+		n_grps++;
+	}
 
 	len += n_grps * (nla_total_size(0) + /* _A_STATS_GRP */
 			 nla_total_size(4) + /* _A_STATS_GRP_ID */
@@ -143,6 +178,57 @@ static int stats_put_phy_stats(struct sk_buff *skb,
 	return 0;
 }
 
+static int stats_put_mac_stats(struct sk_buff *skb,
+			       const struct stats_reply_data *data)
+{
+	if (stat_put(skb, ETHTOOL_A_STATS_ETH_MAC_2_TX_PKT,
+		     data->mac_stats.FramesTransmittedOK) ||
+	    stat_put(skb, ETHTOOL_A_STATS_ETH_MAC_3_SINGLE_COL,
+		     data->mac_stats.SingleCollisionFrames) ||
+	    stat_put(skb, ETHTOOL_A_STATS_ETH_MAC_4_MULTI_COL,
+		     data->mac_stats.MultipleCollisionFrames) ||
+	    stat_put(skb, ETHTOOL_A_STATS_ETH_MAC_5_RX_PKT,
+		     data->mac_stats.FramesReceivedOK) ||
+	    stat_put(skb, ETHTOOL_A_STATS_ETH_MAC_6_FCS_ERR,
+		     data->mac_stats.FrameCheckSequenceErrors) ||
+	    stat_put(skb, ETHTOOL_A_STATS_ETH_MAC_7_ALIGN_ERR,
+		     data->mac_stats.AlignmentErrors) ||
+	    stat_put(skb, ETHTOOL_A_STATS_ETH_MAC_8_TX_BYTES,
+		     data->mac_stats.OctetsTransmittedOK) ||
+	    stat_put(skb, ETHTOOL_A_STATS_ETH_MAC_9_TX_DEFER,
+		     data->mac_stats.FramesWithDeferredXmissions) ||
+	    stat_put(skb, ETHTOOL_A_STATS_ETH_MAC_10_LATE_COL,
+		     data->mac_stats.LateCollisions) ||
+	    stat_put(skb, ETHTOOL_A_STATS_ETH_MAC_11_XS_COL,
+		     data->mac_stats.FramesAbortedDueToXSColls) ||
+	    stat_put(skb, ETHTOOL_A_STATS_ETH_MAC_12_TX_INT_ERR,
+		     data->mac_stats.FramesLostDueToIntMACXmitError) ||
+	    stat_put(skb, ETHTOOL_A_STATS_ETH_MAC_13_CS_ERR,
+		     data->mac_stats.CarrierSenseErrors) ||
+	    stat_put(skb, ETHTOOL_A_STATS_ETH_MAC_14_RX_BYTES,
+		     data->mac_stats.OctetsReceivedOK) ||
+	    stat_put(skb, ETHTOOL_A_STATS_ETH_MAC_15_RX_INT_ERR,
+		     data->mac_stats.FramesLostDueToIntMACRcvError) ||
+	    stat_put(skb, ETHTOOL_A_STATS_ETH_MAC_18_TX_MCAST,
+		     data->mac_stats.MulticastFramesXmittedOK) ||
+	    stat_put(skb, ETHTOOL_A_STATS_ETH_MAC_19_TX_BCAST,
+		     data->mac_stats.BroadcastFramesXmittedOK) ||
+	    stat_put(skb, ETHTOOL_A_STATS_ETH_MAC_20_XS_DEFER,
+		     data->mac_stats.FramesWithExcessiveDeferral) ||
+	    stat_put(skb, ETHTOOL_A_STATS_ETH_MAC_21_RX_MCAST,
+		     data->mac_stats.MulticastFramesReceivedOK) ||
+	    stat_put(skb, ETHTOOL_A_STATS_ETH_MAC_22_RX_BCAST,
+		     data->mac_stats.BroadcastFramesReceivedOK) ||
+	    stat_put(skb, ETHTOOL_A_STATS_ETH_MAC_23_IR_LEN_ERR,
+		     data->mac_stats.InRangeLengthErrors) ||
+	    stat_put(skb, ETHTOOL_A_STATS_ETH_MAC_24_OOR_LEN,
+		     data->mac_stats.OutOfRangeLengthField) ||
+	    stat_put(skb, ETHTOOL_A_STATS_ETH_MAC_25_TOO_LONG_ERR,
+		     data->mac_stats.FrameTooLongErrors))
+		return -EMSGSIZE;
+	return 0;
+}
+
 static int stats_put_stats(struct sk_buff *skb,
 			   const struct stats_reply_data *data,
 			   u32 id, u32 ss_id,
@@ -182,6 +268,10 @@ static int stats_fill_reply(struct sk_buff *skb,
 		ret = stats_put_stats(skb, data, ETHTOOL_STATS_ETH_PHY,
 				      ETH_SS_STATS_ETH_PHY,
 				      stats_put_phy_stats);
+	if (!ret && test_bit(ETHTOOL_STATS_ETH_MAC, req_info->stat_mask))
+		ret = stats_put_stats(skb, data, ETHTOOL_STATS_ETH_MAC,
+				      ETH_SS_STATS_ETH_MAC,
+				      stats_put_mac_stats);
 
 	return ret;
 }
diff --git a/net/ethtool/strset.c b/net/ethtool/strset.c
index 5f3c73587ff4..a8aac7bcfcc9 100644
--- a/net/ethtool/strset.c
+++ b/net/ethtool/strset.c
@@ -90,6 +90,11 @@ static const struct strset_info info_template[] = {
 		.count		= __ETHTOOL_A_STATS_ETH_PHY_CNT,
 		.strings	= stats_eth_phy_names,
 	},
+	[ETH_SS_STATS_ETH_MAC] = {
+		.per_dev	= false,
+		.count		= __ETHTOOL_A_STATS_ETH_MAC_CNT,
+		.strings	= stats_eth_mac_names,
+	},
 };
 
 struct strset_req_info {
-- 
2.30.2

