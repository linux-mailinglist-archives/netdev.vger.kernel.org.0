Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A3DE5EC3B7
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 15:08:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231855AbiI0NId (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 09:08:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232442AbiI0NIL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 09:08:11 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B1B1181CC6
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 06:08:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664284088; x=1695820088;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=Xg8TGzJPc/gD3Zjd5Ai+lcmvIcXQRlW43GVPymtwnPc=;
  b=DOkF6IGHGU8tv4PA+q8k+hgvq8c18dJr02f7MAmYNlfsP5D+iW1SZtAe
   v4loQAUS8ySGgi9gc2F4+vsvgISGTflN8i43MwYmD4aTecnLKwOUajqqS
   ij2XMVCKkKyjvWOnzXeZiWt2muYzB9lrM4MQwz9BD0NJ/DT0MjaXvkXt9
   MIa/OCZCAq3UpHbMXCy9hle5n5uxPn+2R3dioKY09Y+BSKMImLTJpXGTX
   ID+hSTNwJ6UDPHIq15VBce43KQ06X8xgpM2ZnKG40CFOH1A5Zk7Y6uhea
   IoFa4K+qkcmTzjqvnXawcgLtYIVVJa7hRDXUqUPbsDYCVnBYFOadsQnOK
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10483"; a="363148183"
X-IronPort-AV: E=Sophos;i="5.93,349,1654585200"; 
   d="scan'208";a="363148183"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Sep 2022 06:07:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10483"; a="689984904"
X-IronPort-AV: E=Sophos;i="5.93,349,1654585200"; 
   d="scan'208";a="689984904"
Received: from zulkifl3-ilbpg0.png.intel.com ([10.88.229.82])
  by fmsmga004.fm.intel.com with ESMTP; 27 Sep 2022 06:07:56 -0700
From:   Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
To:     intel-wired-lan@osuosl.org
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, muhammad.husaini.zulkifli@intel.com,
        vinicius.gomes@intel.com, aravindhan.gunasekaran@intel.com,
        noor.azura.ahmad.tarmizi@intel.com
Subject: [PATCH v1 1/4] ethtool: Add new hwtstamp flag
Date:   Tue, 27 Sep 2022 21:06:53 +0800
Message-Id: <20220927130656.32567-2-muhammad.husaini.zulkifli@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220927130656.32567-1-muhammad.husaini.zulkifli@intel.com>
References: <20220927130656.32567-1-muhammad.husaini.zulkifli@intel.com>
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This add patch add a new DMA Time Stamp flag. User can configure
hwtstamp_config with this flag if they want to use DMA time stamp.

Suggested-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Signed-off-by: Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
---
 include/uapi/linux/ethtool.h         |  3 +++
 include/uapi/linux/ethtool_netlink.h |  1 +
 include/uapi/linux/net_tstamp.h      |  5 ++++-
 net/ethtool/common.c                 |  6 ++++++
 net/ethtool/common.h                 |  2 ++
 net/ethtool/strset.c                 |  5 +++++
 net/ethtool/tsinfo.c                 | 17 +++++++++++++++++
 7 files changed, 38 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
index fe9893d1485d..07ca8d496e1a 100644
--- a/include/uapi/linux/ethtool.h
+++ b/include/uapi/linux/ethtool.h
@@ -675,6 +675,7 @@ enum ethtool_link_ext_substate_module {
  * @ETH_SS_MSG_CLASSES: debug message class names
  * @ETH_SS_WOL_MODES: wake-on-lan modes
  * @ETH_SS_SOF_TIMESTAMPING: SOF_TIMESTAMPING_* flags
+ * @ETH_SS_HWTSTAMP_FLAG: timestamping flags
  * @ETH_SS_TS_TX_TYPES: timestamping Tx types
  * @ETH_SS_TS_RX_FILTERS: timestamping Rx filters
  * @ETH_SS_UDP_TUNNEL_TYPES: UDP tunnel types
@@ -700,6 +701,7 @@ enum ethtool_stringset {
 	ETH_SS_MSG_CLASSES,
 	ETH_SS_WOL_MODES,
 	ETH_SS_SOF_TIMESTAMPING,
+	ETH_SS_HWTSTAMP_FLAG,
 	ETH_SS_TS_TX_TYPES,
 	ETH_SS_TS_RX_FILTERS,
 	ETH_SS_UDP_TUNNEL_TYPES,
@@ -1367,6 +1369,7 @@ struct ethtool_ts_info {
 	__u32	cmd;
 	__u32	so_timestamping;
 	__s32	phc_index;
+	__u32	flag;
 	__u32	tx_types;
 	__u32	tx_reserved[3];
 	__u32	rx_filters;
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index 408a664fad59..58d073b5a6d2 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -452,6 +452,7 @@ enum {
 	ETHTOOL_A_TSINFO_UNSPEC,
 	ETHTOOL_A_TSINFO_HEADER,			/* nest - _A_HEADER_* */
 	ETHTOOL_A_TSINFO_TIMESTAMPING,			/* bitset */
+	ETHTOOL_A_TSINFO_FLAG,				/* bitset */
 	ETHTOOL_A_TSINFO_TX_TYPES,			/* bitset */
 	ETHTOOL_A_TSINFO_RX_FILTERS,			/* bitset */
 	ETHTOOL_A_TSINFO_PHC_INDEX,			/* u32 */
diff --git a/include/uapi/linux/net_tstamp.h b/include/uapi/linux/net_tstamp.h
index 55501e5e7ac8..4966d5ca521f 100644
--- a/include/uapi/linux/net_tstamp.h
+++ b/include/uapi/linux/net_tstamp.h
@@ -89,7 +89,10 @@ enum hwtstamp_flags {
 	HWTSTAMP_FLAG_BONDED_PHC_INDEX = (1<<0),
 #define HWTSTAMP_FLAG_BONDED_PHC_INDEX	HWTSTAMP_FLAG_BONDED_PHC_INDEX
 
-	HWTSTAMP_FLAG_LAST = HWTSTAMP_FLAG_BONDED_PHC_INDEX,
+	HWTSTAMP_FLAG_DMA_TIMESTAMP = (1<<1),
+#define HWTSTAMP_FLAG_DMA_TIMESTAMP	HWTSTAMP_FLAG_DMA_TIMESTAMP
+
+	HWTSTAMP_FLAG_LAST = HWTSTAMP_FLAG_DMA_TIMESTAMP,
 	HWTSTAMP_FLAG_MASK = (HWTSTAMP_FLAG_LAST - 1) | HWTSTAMP_FLAG_LAST
 };
 
diff --git a/net/ethtool/common.c b/net/ethtool/common.c
index 566adf85e658..f2a178d162ef 100644
--- a/net/ethtool/common.c
+++ b/net/ethtool/common.c
@@ -406,6 +406,12 @@ const char sof_timestamping_names[][ETH_GSTRING_LEN] = {
 };
 static_assert(ARRAY_SIZE(sof_timestamping_names) == __SOF_TIMESTAMPING_CNT);
 
+const char ts_flag_names[][ETH_GSTRING_LEN] = {
+	[const_ilog2(HWTSTAMP_FLAG_BONDED_PHC_INDEX)]	= "bonded-phc-index",
+	[const_ilog2(HWTSTAMP_FLAG_DMA_TIMESTAMP)]	= "dma-time-stamp",
+};
+static_assert(ARRAY_SIZE(ts_flag_names) == __HWTSTAMP_FLAG_CNT);
+
 const char ts_tx_type_names[][ETH_GSTRING_LEN] = {
 	[HWTSTAMP_TX_OFF]		= "off",
 	[HWTSTAMP_TX_ON]		= "on",
diff --git a/net/ethtool/common.h b/net/ethtool/common.h
index 2dc2b80aea5f..39fedceb82ca 100644
--- a/net/ethtool/common.h
+++ b/net/ethtool/common.h
@@ -13,6 +13,7 @@
 	ETHTOOL_LINK_MODE_ ## speed ## base ## type ## _ ## duplex ## _BIT
 
 #define __SOF_TIMESTAMPING_CNT (const_ilog2(SOF_TIMESTAMPING_LAST) + 1)
+#define __HWTSTAMP_FLAG_CNT (const_ilog2(HWTSTAMP_FLAG_LAST) + 1)
 
 struct link_mode_info {
 	int				speed;
@@ -33,6 +34,7 @@ extern const struct link_mode_info link_mode_params[];
 extern const char netif_msg_class_names[][ETH_GSTRING_LEN];
 extern const char wol_mode_names[][ETH_GSTRING_LEN];
 extern const char sof_timestamping_names[][ETH_GSTRING_LEN];
+extern const char ts_flag_names[][ETH_GSTRING_LEN];
 extern const char ts_tx_type_names[][ETH_GSTRING_LEN];
 extern const char ts_rx_filter_names[][ETH_GSTRING_LEN];
 extern const char udp_tunnel_type_names[][ETH_GSTRING_LEN];
diff --git a/net/ethtool/strset.c b/net/ethtool/strset.c
index 3f7de54d85fb..2c26cfece494 100644
--- a/net/ethtool/strset.c
+++ b/net/ethtool/strset.c
@@ -65,6 +65,11 @@ static const struct strset_info info_template[] = {
 		.count		= __SOF_TIMESTAMPING_CNT,
 		.strings	= sof_timestamping_names,
 	},
+	[ETH_SS_HWTSTAMP_FLAG] = {
+		.per_dev	= false,
+		.count		= __HWTSTAMP_FLAG_CNT,
+		.strings	= ts_flag_names,
+	},
 	[ETH_SS_TS_TX_TYPES] = {
 		.per_dev	= false,
 		.count		= __HWTSTAMP_TX_CNT,
diff --git a/net/ethtool/tsinfo.c b/net/ethtool/tsinfo.c
index 63b5814bd460..84aa15445944 100644
--- a/net/ethtool/tsinfo.c
+++ b/net/ethtool/tsinfo.c
@@ -50,6 +50,7 @@ static int tsinfo_reply_size(const struct ethnl_req_info *req_base,
 	int ret;
 
 	BUILD_BUG_ON(__SOF_TIMESTAMPING_CNT > 32);
+	BUILD_BUG_ON(__HWTSTAMP_FLAG_CNT > 32);
 	BUILD_BUG_ON(__HWTSTAMP_TX_CNT > 32);
 	BUILD_BUG_ON(__HWTSTAMP_FILTER_CNT > 32);
 
@@ -61,6 +62,14 @@ static int tsinfo_reply_size(const struct ethnl_req_info *req_base,
 			return ret;
 		len += ret;	/* _TSINFO_TIMESTAMPING */
 	}
+	if (ts_info->flag) {
+		ret = ethnl_bitset32_size(&ts_info->flag, NULL,
+					  __HWTSTAMP_FLAG_CNT,
+					  ts_flag_names, compact);
+		if (ret < 0)
+			return ret;
+		len += ret;	/* _TSINFO_FLAG */
+	}
 	if (ts_info->tx_types) {
 		ret = ethnl_bitset32_size(&ts_info->tx_types, NULL,
 					  __HWTSTAMP_TX_CNT,
@@ -100,6 +109,14 @@ static int tsinfo_fill_reply(struct sk_buff *skb,
 		if (ret < 0)
 			return ret;
 	}
+	if (ts_info->flag) {
+		ret = ethnl_put_bitset32(skb, ETHTOOL_A_TSINFO_FLAG,
+					 &ts_info->flag, NULL,
+					 __HWTSTAMP_FLAG_CNT,
+					 ts_flag_names, compact);
+		if (ret < 0)
+			return ret;
+	}
 	if (ts_info->tx_types) {
 		ret = ethnl_put_bitset32(skb, ETHTOOL_A_TSINFO_TX_TYPES,
 					 &ts_info->tx_types, NULL,
-- 
2.17.1

