Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E12731DA60D
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 02:04:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728322AbgETAEt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 20:04:49 -0400
Received: from mga01.intel.com ([192.55.52.88]:15427 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728053AbgETAEc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 May 2020 20:04:32 -0400
IronPort-SDR: DiIHW2dBj6AA6GwZZbrN0xLMZMGtl4HZx259WxSu14Ci60X0faQ+5f9Oc4qkdiNmV+vg1XqQdM
 fYmMMKmDUkKQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2020 17:04:24 -0700
IronPort-SDR: Eefx+OVwM6VbKSNDYKyRcf7ftLigMPBXugEnfWPFwYNwXOpco/kRRHymgT5IKEhJ91k4Gd1jDj
 /E37id7QPV2A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,411,1583222400"; 
   d="scan'208";a="466324789"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga006.fm.intel.com with ESMTP; 19 May 2020 17:04:23 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Andre Guedes <andre.guedes@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 09/14] igc: Remove ethertype filter in PTP code
Date:   Tue, 19 May 2020 17:04:14 -0700
Message-Id: <20200520000419.1595788-10-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200520000419.1595788-1-jeffrey.t.kirsher@intel.com>
References: <20200520000419.1595788-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andre Guedes <andre.guedes@intel.com>

The driver only supports hardware timestamping for all incoming
traffic (HWTSTAMP_FILTER_ALL) which is enabled via Rx Time Sync
Control (TSYNCRXCTL) register already. Therefore, the ethertype
filter set in in igc_ptp_set_timestamp_mode() is useless so this
patch removes it.

Signed-off-by: Andre Guedes <andre.guedes@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/igc/igc.h         |  2 +-
 drivers/net/ethernet/intel/igc/igc_defines.h |  3 ---
 drivers/net/ethernet/intel/igc/igc_ptp.c     | 12 ------------
 3 files changed, 1 insertion(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc.h b/drivers/net/ethernet/intel/igc/igc.h
index 5f1e1d31e832..e4169fe955d8 100644
--- a/drivers/net/ethernet/intel/igc/igc.h
+++ b/drivers/net/ethernet/intel/igc/igc.h
@@ -26,7 +26,7 @@ void igc_set_ethtool_ops(struct net_device *);
 #define MAX_Q_VECTORS			8
 #define MAX_STD_JUMBO_FRAME_SIZE	9216
 
-#define MAX_ETYPE_FILTER		(4 - 1)
+#define MAX_ETYPE_FILTER		4
 #define IGC_RETA_SIZE			128
 
 struct igc_tx_queue_stats {
diff --git a/drivers/net/ethernet/intel/igc/igc_defines.h b/drivers/net/ethernet/intel/igc/igc_defines.h
index f1bb5414f99f..6909826bc747 100644
--- a/drivers/net/ethernet/intel/igc/igc_defines.h
+++ b/drivers/net/ethernet/intel/igc/igc_defines.h
@@ -384,9 +384,6 @@
 
 #define IGC_TSICR_INTERRUPTS	IGC_TSICR_TXTS
 
-/* PTP Queue Filter */
-#define IGC_ETQF_1588		BIT(30)
-
 #define IGC_FTQF_VF_BP		0x00008000
 #define IGC_FTQF_1588_TIME_STAMP	0x08000000
 #define IGC_FTQF_MASK			0xF0000000
diff --git a/drivers/net/ethernet/intel/igc/igc_ptp.c b/drivers/net/ethernet/intel/igc/igc_ptp.c
index 1bf016398b9d..0d746f8588c8 100644
--- a/drivers/net/ethernet/intel/igc/igc_ptp.c
+++ b/drivers/net/ethernet/intel/igc/igc_ptp.c
@@ -305,7 +305,6 @@ static int igc_ptp_set_timestamp_mode(struct igc_adapter *adapter,
 	struct igc_hw *hw = &adapter->hw;
 	u32 tsync_rx_cfg = 0;
 	bool is_l4 = false;
-	bool is_l2 = false;
 	u32 regval;
 
 	/* reserved for future extensions */
@@ -346,7 +345,6 @@ static int igc_ptp_set_timestamp_mode(struct igc_adapter *adapter,
 	case HWTSTAMP_FILTER_PTP_V2_L4_DELAY_REQ:
 		tsync_rx_ctl |= IGC_TSYNCRXCTL_TYPE_EVENT_V2;
 		config->rx_filter = HWTSTAMP_FILTER_PTP_V2_EVENT;
-		is_l2 = true;
 		is_l4 = true;
 		break;
 	case HWTSTAMP_FILTER_PTP_V1_L4_EVENT:
@@ -370,7 +368,6 @@ static int igc_ptp_set_timestamp_mode(struct igc_adapter *adapter,
 		tsync_rx_ctl |= IGC_TSYNCRXCTL_TYPE_ALL;
 		tsync_rx_ctl |= IGC_TSYNCRXCTL_RXSYNSIG;
 		config->rx_filter = HWTSTAMP_FILTER_ALL;
-		is_l2 = true;
 		is_l4 = true;
 
 		if (hw->mac.type == igc_i225) {
@@ -405,15 +402,6 @@ static int igc_ptp_set_timestamp_mode(struct igc_adapter *adapter,
 	/* define which PTP packets are time stamped */
 	wr32(IGC_TSYNCRXCFG, tsync_rx_cfg);
 
-	/* define ethertype filter for timestamped packets */
-	if (is_l2)
-		wr32(IGC_ETQF(3),
-		     (IGC_ETQF_FILTER_ENABLE | /* enable filter */
-		     IGC_ETQF_1588 | /* enable timestamping */
-		     ETH_P_1588)); /* 1588 eth protocol type */
-	else
-		wr32(IGC_ETQF(3), 0);
-
 	/* L4 Queue Filter[3]: filter by destination port and protocol */
 	if (is_l4) {
 		u32 ftqf = (IPPROTO_UDP /* UDP */
-- 
2.26.2

