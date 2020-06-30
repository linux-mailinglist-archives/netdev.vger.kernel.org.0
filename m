Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A29B20EAE7
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 03:29:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728701AbgF3B2F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 21:28:05 -0400
Received: from mga11.intel.com ([192.55.52.93]:52176 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728638AbgF3B2A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jun 2020 21:28:00 -0400
IronPort-SDR: knu8FvY7oaGFPcGCc62K+1jXQ5Z/eGK5HCB11D5wRceA3mun/LUD9vBwKvwY+n0yiZjYvSEgbA
 LJJV3MXdfIaQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9666"; a="144305926"
X-IronPort-AV: E=Sophos;i="5.75,296,1589266800"; 
   d="scan'208";a="144305926"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2020 18:27:50 -0700
IronPort-SDR: yh3tIPhOdpKCDtSjJQroj7KD4wGtqex6cy/FKdBk+wpCN8KpSqQmsJiMT8bmu3ZwKhHW0T04/A
 9JKX0sOTVBUQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,296,1589266800"; 
   d="scan'208";a="425017710"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga004.jf.intel.com with ESMTP; 29 Jun 2020 18:27:50 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Andre Guedes <andre.guedes@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next v2 06/13] igc: Remove UDP filter setup in PTP code
Date:   Mon, 29 Jun 2020 18:27:41 -0700
Message-Id: <20200630012748.518705-7-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200630012748.518705-1-jeffrey.t.kirsher@intel.com>
References: <20200630012748.518705-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andre Guedes <andre.guedes@intel.com>

As implemented in igc_ethtool_get_ts_info(), igc only supports HWTSTAMP_
FILTER_ALL so any HWTSTAMP_FILTER_* option the user may set falls back to
HWTSTAMP_FILTER_ALL.

HWTSTAMP_FILTER_ALL is implemented via Rx Time Sync Control (TSYNCRXCTL)
configuration which timestamps all incoming packets. Configuring a
UDP filter, in addition to TSYNCRXCTL, doesn't add much so this patch
removes that code. It also takes this opportunity to remove some
non-applicable comments.

Signed-off-by: Andre Guedes <andre.guedes@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_ptp.c | 51 +-----------------------
 1 file changed, 1 insertion(+), 50 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_ptp.c b/drivers/net/ethernet/intel/igc/igc_ptp.c
index e65fdcf966b2..bdf934377abb 100644
--- a/drivers/net/ethernet/intel/igc/igc_ptp.c
+++ b/drivers/net/ethernet/intel/igc/igc_ptp.c
@@ -244,18 +244,7 @@ static void igc_ptp_enable_tstamp_all_rxqueues(struct igc_adapter *adapter,
  * @adapter: networking device structure
  * @config: hwtstamp configuration
  *
- * Outgoing time stamping can be enabled and disabled. Play nice and
- * disable it when requested, although it shouldn't case any overhead
- * when no packet needs it. At most one packet in the queue may be
- * marked for time stamping, otherwise it would be impossible to tell
- * for sure to which packet the hardware time stamp belongs.
- *
- * Incoming time stamping has to be configured via the hardware
- * filters. Not all combinations are supported, in particular event
- * type has to be specified. Matching the kind of event packet is
- * not supported, with the exception of "all V2 events regardless of
- * level 2 or 4".
- *
+ * Return: 0 in case of success, negative errno code otherwise.
  */
 static int igc_ptp_set_timestamp_mode(struct igc_adapter *adapter,
 				      struct hwtstamp_config *config)
@@ -263,8 +252,6 @@ static int igc_ptp_set_timestamp_mode(struct igc_adapter *adapter,
 	u32 tsync_tx_ctl = IGC_TSYNCTXCTL_ENABLED;
 	u32 tsync_rx_ctl = IGC_TSYNCRXCTL_ENABLED;
 	struct igc_hw *hw = &adapter->hw;
-	u32 tsync_rx_cfg = 0;
-	bool is_l4 = false;
 	u32 regval;
 
 	/* reserved for future extensions */
@@ -285,15 +272,7 @@ static int igc_ptp_set_timestamp_mode(struct igc_adapter *adapter,
 		tsync_rx_ctl = 0;
 		break;
 	case HWTSTAMP_FILTER_PTP_V1_L4_SYNC:
-		tsync_rx_ctl |= IGC_TSYNCRXCTL_TYPE_L4_V1;
-		tsync_rx_cfg = IGC_TSYNCRXCFG_PTP_V1_SYNC_MESSAGE;
-		is_l4 = true;
-		break;
 	case HWTSTAMP_FILTER_PTP_V1_L4_DELAY_REQ:
-		tsync_rx_ctl |= IGC_TSYNCRXCTL_TYPE_L4_V1;
-		tsync_rx_cfg = IGC_TSYNCRXCFG_PTP_V1_DELAY_REQ_MESSAGE;
-		is_l4 = true;
-		break;
 	case HWTSTAMP_FILTER_PTP_V2_EVENT:
 	case HWTSTAMP_FILTER_PTP_V2_L2_EVENT:
 	case HWTSTAMP_FILTER_PTP_V2_L4_EVENT:
@@ -303,32 +282,22 @@ static int igc_ptp_set_timestamp_mode(struct igc_adapter *adapter,
 	case HWTSTAMP_FILTER_PTP_V2_DELAY_REQ:
 	case HWTSTAMP_FILTER_PTP_V2_L2_DELAY_REQ:
 	case HWTSTAMP_FILTER_PTP_V2_L4_DELAY_REQ:
-		tsync_rx_ctl |= IGC_TSYNCRXCTL_TYPE_EVENT_V2;
-		config->rx_filter = HWTSTAMP_FILTER_PTP_V2_EVENT;
-		is_l4 = true;
-		break;
 	case HWTSTAMP_FILTER_PTP_V1_L4_EVENT:
 	case HWTSTAMP_FILTER_NTP_ALL:
 	case HWTSTAMP_FILTER_ALL:
 		tsync_rx_ctl |= IGC_TSYNCRXCTL_TYPE_ALL;
 		config->rx_filter = HWTSTAMP_FILTER_ALL;
 		break;
-		/* fall through */
 	default:
 		config->rx_filter = HWTSTAMP_FILTER_NONE;
 		return -ERANGE;
 	}
 
-	/* Per-packet timestamping only works if all packets are
-	 * timestamped, so enable timestamping in all packets as long
-	 * as one Rx filter was configured.
-	 */
 	if (tsync_rx_ctl) {
 		tsync_rx_ctl = IGC_TSYNCRXCTL_ENABLED;
 		tsync_rx_ctl |= IGC_TSYNCRXCTL_TYPE_ALL;
 		tsync_rx_ctl |= IGC_TSYNCRXCTL_RXSYNSIG;
 		config->rx_filter = HWTSTAMP_FILTER_ALL;
-		is_l4 = true;
 
 		if (hw->mac.type == igc_i225) {
 			regval = rd32(IGC_RXPBS);
@@ -359,24 +328,6 @@ static int igc_ptp_set_timestamp_mode(struct igc_adapter *adapter,
 	regval |= tsync_rx_ctl;
 	wr32(IGC_TSYNCRXCTL, regval);
 
-	/* define which PTP packets are time stamped */
-	wr32(IGC_TSYNCRXCFG, tsync_rx_cfg);
-
-	/* L4 Queue Filter[3]: filter by destination port and protocol */
-	if (is_l4) {
-		u32 ftqf = (IPPROTO_UDP /* UDP */
-			    | IGC_FTQF_VF_BP /* VF not compared */
-			    | IGC_FTQF_1588_TIME_STAMP /* Enable Timestamp */
-			    | IGC_FTQF_MASK); /* mask all inputs */
-		ftqf &= ~IGC_FTQF_MASK_PROTO_BP; /* enable protocol check */
-
-		wr32(IGC_IMIR(3), htons(PTP_EV_PORT));
-		wr32(IGC_IMIREXT(3),
-		     (IGC_IMIREXT_SIZE_BP | IGC_IMIREXT_CTRL_BP));
-		wr32(IGC_FTQF(3), ftqf);
-	} else {
-		wr32(IGC_FTQF(3), IGC_FTQF_MASK);
-	}
 	wrfl();
 
 	/* clear TX time stamp registers, just to be sure */
-- 
2.26.2

