Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0CD319589C
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 15:08:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727905AbgC0OIQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 10:08:16 -0400
Received: from mx2.suse.de ([195.135.220.15]:41166 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726333AbgC0OIP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Mar 2020 10:08:15 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id EC0F5ACED;
        Fri, 27 Mar 2020 14:08:12 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 99184E009C; Fri, 27 Mar 2020 15:08:12 +0100 (CET)
Message-Id: <9115b20867b6914eec70a58f3ba3b9deef4eb2b0.1585316159.git.mkubecek@suse.cz>
In-Reply-To: <cover.1585316159.git.mkubecek@suse.cz>
References: <cover.1585316159.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH net-next v2 11/12] ethtool: add timestamping related string
 sets
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Jiri Pirko <jiri@resnulli.us>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Richard Cochran <richardcochran@gmail.com>,
        linux-kernel@vger.kernel.org
Date:   Fri, 27 Mar 2020 15:08:12 +0100 (CET)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add three string sets related to timestamping information:

  ETH_SS_SOF_TIMESTAMPING: SOF_TIMESTAMPING_* flags
  ETH_SS_TS_TX_TYPES:      timestamping Tx types
  ETH_SS_TS_RX_FILTERS:    timestamping Rx filters

These will be used for TIMESTAMP_GET request.

v2: avoid compiler warning ("enumeration value not handled in switch")
    in net_hwtstamp_validate()

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 include/uapi/linux/ethtool.h    |  6 ++++
 include/uapi/linux/net_tstamp.h |  6 ++++
 net/core/dev_ioctl.c            |  6 ++++
 net/ethtool/common.c            | 49 +++++++++++++++++++++++++++++++++
 net/ethtool/common.h            |  5 ++++
 net/ethtool/strset.c            | 15 ++++++++++
 6 files changed, 87 insertions(+)

diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
index d586ee5e10a1..92f737f10117 100644
--- a/include/uapi/linux/ethtool.h
+++ b/include/uapi/linux/ethtool.h
@@ -596,6 +596,9 @@ struct ethtool_pauseparam {
  * @ETH_SS_LINK_MODES: link mode names
  * @ETH_SS_MSG_CLASSES: debug message class names
  * @ETH_SS_WOL_MODES: wake-on-lan modes
+ * @ETH_SS_SOF_TIMESTAMPING: SOF_TIMESTAMPING_* flags
+ * @ETH_SS_TS_TX_TYPES: timestamping Tx types
+ * @ETH_SS_TS_RX_FILTERS: timestamping Rx filters
  */
 enum ethtool_stringset {
 	ETH_SS_TEST		= 0,
@@ -610,6 +613,9 @@ enum ethtool_stringset {
 	ETH_SS_LINK_MODES,
 	ETH_SS_MSG_CLASSES,
 	ETH_SS_WOL_MODES,
+	ETH_SS_SOF_TIMESTAMPING,
+	ETH_SS_TS_TX_TYPES,
+	ETH_SS_TS_RX_FILTERS,
 
 	/* add new constants above here */
 	ETH_SS_COUNT
diff --git a/include/uapi/linux/net_tstamp.h b/include/uapi/linux/net_tstamp.h
index f96e650d0af9..7ed0b3d1c00a 100644
--- a/include/uapi/linux/net_tstamp.h
+++ b/include/uapi/linux/net_tstamp.h
@@ -98,6 +98,9 @@ enum hwtstamp_tx_types {
 	 * receive a time stamp via the socket error queue.
 	 */
 	HWTSTAMP_TX_ONESTEP_P2P,
+
+	/* add new constants above here */
+	__HWTSTAMP_TX_CNT
 };
 
 /* possible values for hwtstamp_config->rx_filter */
@@ -140,6 +143,9 @@ enum hwtstamp_rx_filters {
 
 	/* NTP, UDP, all versions and packet modes */
 	HWTSTAMP_FILTER_NTP_ALL,
+
+	/* add new constants above here */
+	__HWTSTAMP_FILTER_CNT
 };
 
 /* SCM_TIMESTAMPING_PKTINFO control message */
diff --git a/net/core/dev_ioctl.c b/net/core/dev_ioctl.c
index dbaebbe573f0..547b587c1950 100644
--- a/net/core/dev_ioctl.c
+++ b/net/core/dev_ioctl.c
@@ -190,6 +190,9 @@ static int net_hwtstamp_validate(struct ifreq *ifr)
 	case HWTSTAMP_TX_ONESTEP_P2P:
 		tx_type_valid = 1;
 		break;
+	case __HWTSTAMP_TX_CNT:
+		/* not a real value */
+		break;
 	}
 
 	switch (rx_filter) {
@@ -211,6 +214,9 @@ static int net_hwtstamp_validate(struct ifreq *ifr)
 	case HWTSTAMP_FILTER_NTP_ALL:
 		rx_filter_valid = 1;
 		break;
+	case __HWTSTAMP_FILTER_CNT:
+		/* not a real value */
+		break;
 	}
 
 	if (!tx_type_valid || !rx_filter_valid)
diff --git a/net/ethtool/common.c b/net/ethtool/common.c
index dab047eec943..6faa1e0f99a4 100644
--- a/net/ethtool/common.c
+++ b/net/ethtool/common.c
@@ -1,5 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-only
 
+#include <linux/net_tstamp.h>
+
 #include "common.h"
 
 const char netdev_features_strings[NETDEV_FEATURE_COUNT][ETH_GSTRING_LEN] = {
@@ -203,6 +205,53 @@ const char wol_mode_names[][ETH_GSTRING_LEN] = {
 };
 static_assert(ARRAY_SIZE(wol_mode_names) == WOL_MODE_COUNT);
 
+const char sof_timestamping_names[][ETH_GSTRING_LEN] = {
+	[const_ilog2(SOF_TIMESTAMPING_TX_HARDWARE)]  = "hardware-transmit",
+	[const_ilog2(SOF_TIMESTAMPING_TX_SOFTWARE)]  = "software-transmit",
+	[const_ilog2(SOF_TIMESTAMPING_RX_HARDWARE)]  = "hardware-receive",
+	[const_ilog2(SOF_TIMESTAMPING_RX_SOFTWARE)]  = "software-receive",
+	[const_ilog2(SOF_TIMESTAMPING_SOFTWARE)]     = "software-system-clock",
+	[const_ilog2(SOF_TIMESTAMPING_SYS_HARDWARE)] = "hardware-legacy-clock",
+	[const_ilog2(SOF_TIMESTAMPING_RAW_HARDWARE)] = "hardware-raw-clock",
+	[const_ilog2(SOF_TIMESTAMPING_OPT_ID)]       = "option-id",
+	[const_ilog2(SOF_TIMESTAMPING_TX_SCHED)]     = "sched-transmit",
+	[const_ilog2(SOF_TIMESTAMPING_TX_ACK)]       = "ack-transmit",
+	[const_ilog2(SOF_TIMESTAMPING_OPT_CMSG)]     = "option-cmsg",
+	[const_ilog2(SOF_TIMESTAMPING_OPT_TSONLY)]   = "option-tsonly",
+	[const_ilog2(SOF_TIMESTAMPING_OPT_STATS)]    = "option-stats",
+	[const_ilog2(SOF_TIMESTAMPING_OPT_PKTINFO)]  = "option-pktinfo",
+	[const_ilog2(SOF_TIMESTAMPING_OPT_TX_SWHW)]  = "option-tx-swhw",
+};
+static_assert(ARRAY_SIZE(sof_timestamping_names) == __SOF_TIMESTAMPING_CNT);
+
+const char ts_tx_type_names[][ETH_GSTRING_LEN] = {
+	[HWTSTAMP_TX_OFF]		= "off",
+	[HWTSTAMP_TX_ON]		= "on",
+	[HWTSTAMP_TX_ONESTEP_SYNC]	= "one-step-sync",
+	[HWTSTAMP_TX_ONESTEP_P2P]	= "one-step-p2p",
+};
+static_assert(ARRAY_SIZE(ts_tx_type_names) == __HWTSTAMP_TX_CNT);
+
+const char ts_rx_filter_names[][ETH_GSTRING_LEN] = {
+	[HWTSTAMP_FILTER_NONE]			= "none",
+	[HWTSTAMP_FILTER_ALL]			= "all",
+	[HWTSTAMP_FILTER_SOME]			= "some",
+	[HWTSTAMP_FILTER_PTP_V1_L4_EVENT]	= "ptpv1-l4-event",
+	[HWTSTAMP_FILTER_PTP_V1_L4_SYNC]	= "ptpv1-l4-sync",
+	[HWTSTAMP_FILTER_PTP_V1_L4_DELAY_REQ]	= "ptpv1-l4-delay-req",
+	[HWTSTAMP_FILTER_PTP_V2_L4_EVENT]	= "ptpv2-l4-event",
+	[HWTSTAMP_FILTER_PTP_V2_L4_SYNC]	= "ptpv2-l4-sync",
+	[HWTSTAMP_FILTER_PTP_V2_L4_DELAY_REQ]	= "ptpv2-l4-delay-req",
+	[HWTSTAMP_FILTER_PTP_V2_L2_EVENT]	= "ptpv2-l2-event",
+	[HWTSTAMP_FILTER_PTP_V2_L2_SYNC]	= "ptpv2-l2-sync",
+	[HWTSTAMP_FILTER_PTP_V2_L2_DELAY_REQ]	= "ptpv2-l2-delay-req",
+	[HWTSTAMP_FILTER_PTP_V2_EVENT]		= "ptpv2-event",
+	[HWTSTAMP_FILTER_PTP_V2_SYNC]		= "ptpv2-sync",
+	[HWTSTAMP_FILTER_PTP_V2_DELAY_REQ]	= "ptpv2-delay-req",
+	[HWTSTAMP_FILTER_NTP_ALL]		= "ntp-all",
+};
+static_assert(ARRAY_SIZE(ts_rx_filter_names) == __HWTSTAMP_FILTER_CNT);
+
 /* return false if legacy contained non-0 deprecated fields
  * maxtxpkt/maxrxpkt. rest of ksettings always updated
  */
diff --git a/net/ethtool/common.h b/net/ethtool/common.h
index 03946e16e623..c54c8d57fd8f 100644
--- a/net/ethtool/common.h
+++ b/net/ethtool/common.h
@@ -12,6 +12,8 @@
 #define ETHTOOL_LINK_MODE(speed, type, duplex) \
 	ETHTOOL_LINK_MODE_ ## speed ## base ## type ## _ ## duplex ## _BIT
 
+#define __SOF_TIMESTAMPING_CNT (const_ilog2(SOF_TIMESTAMPING_LAST) + 1)
+
 extern const char
 netdev_features_strings[NETDEV_FEATURE_COUNT][ETH_GSTRING_LEN];
 extern const char
@@ -23,6 +25,9 @@ phy_tunable_strings[__ETHTOOL_PHY_TUNABLE_COUNT][ETH_GSTRING_LEN];
 extern const char link_mode_names[][ETH_GSTRING_LEN];
 extern const char netif_msg_class_names[][ETH_GSTRING_LEN];
 extern const char wol_mode_names[][ETH_GSTRING_LEN];
+extern const char sof_timestamping_names[][ETH_GSTRING_LEN];
+extern const char ts_tx_type_names[][ETH_GSTRING_LEN];
+extern const char ts_rx_filter_names[][ETH_GSTRING_LEN];
 
 int __ethtool_get_link(struct net_device *dev);
 
diff --git a/net/ethtool/strset.c b/net/ethtool/strset.c
index 8e5911887b4c..95eae5c68a52 100644
--- a/net/ethtool/strset.c
+++ b/net/ethtool/strset.c
@@ -60,6 +60,21 @@ static const struct strset_info info_template[] = {
 		.count		= WOL_MODE_COUNT,
 		.strings	= wol_mode_names,
 	},
+	[ETH_SS_SOF_TIMESTAMPING] = {
+		.per_dev	= false,
+		.count		= __SOF_TIMESTAMPING_CNT,
+		.strings	= sof_timestamping_names,
+	},
+	[ETH_SS_TS_TX_TYPES] = {
+		.per_dev	= false,
+		.count		= __HWTSTAMP_TX_CNT,
+		.strings	= ts_tx_type_names,
+	},
+	[ETH_SS_TS_RX_FILTERS] = {
+		.per_dev	= false,
+		.count		= __HWTSTAMP_FILTER_CNT,
+		.strings	= ts_rx_filter_names,
+	},
 };
 
 struct strset_req_info {
-- 
2.25.1

