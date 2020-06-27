Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F30620BDA5
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 03:54:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726604AbgF0Byz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 21:54:55 -0400
Received: from mga03.intel.com ([134.134.136.65]:29242 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726486AbgF0Byp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Jun 2020 21:54:45 -0400
IronPort-SDR: SDjeZdEFhVfi77ANCTKa76ikEDKU9feUqHd36GW6VU7eDRnlJm0Mqbennrmg/F64e/sFdvgDrt
 L8DkaYxt2PrQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9664"; a="145588584"
X-IronPort-AV: E=Sophos;i="5.75,285,1589266800"; 
   d="scan'208";a="145588584"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2020 18:54:37 -0700
IronPort-SDR: Lhh4B+sCR+TyWF3bhv+8Uf1wl5Q76fkvCN+l1aiMVwWkVD2wHjx0Xs38J7fC5D9RN8G81R1o3/
 FDcM+AVGphIA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,285,1589266800"; 
   d="scan'208";a="312495117"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga002.fm.intel.com with ESMTP; 26 Jun 2020 18:54:37 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Andre Guedes <andre.guedes@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 07/13] igc: Refactor igc_ptp_set_timestamp_mode()
Date:   Fri, 26 Jun 2020 18:54:25 -0700
Message-Id: <20200627015431.3579234-8-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200627015431.3579234-1-jeffrey.t.kirsher@intel.com>
References: <20200627015431.3579234-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andre Guedes <andre.guedes@intel.com>

Current igc_ptp_set_timestamp_mode() logic is a bit tangled since it
handles many different hardware configurations in one single place,
making it harder to follow. This patch untangles that code by breaking
it into helper functions.

Quick note about the hw->mac.type check which was removed in this
refactoring: this check it not really needed since igc_i225 is the only
type supported by the IGC driver.

Signed-off-by: Andre Guedes <andre.guedes@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_ptp.c | 103 ++++++++++++-----------
 1 file changed, 53 insertions(+), 50 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_ptp.c b/drivers/net/ethernet/intel/igc/igc_ptp.c
index bdf934377abb..0251e6bedac4 100644
--- a/drivers/net/ethernet/intel/igc/igc_ptp.c
+++ b/drivers/net/ethernet/intel/igc/igc_ptp.c
@@ -239,6 +239,54 @@ static void igc_ptp_enable_tstamp_all_rxqueues(struct igc_adapter *adapter,
 	}
 }
 
+static void igc_ptp_disable_rx_timestamp(struct igc_adapter *adapter)
+{
+	struct igc_hw *hw = &adapter->hw;
+	u32 val;
+
+	wr32(IGC_TSYNCRXCTL, 0);
+
+	val = rd32(IGC_RXPBS);
+	val &= ~IGC_RXPBS_CFG_TS_EN;
+	wr32(IGC_RXPBS, val);
+}
+
+static void igc_ptp_enable_rx_timestamp(struct igc_adapter *adapter)
+{
+	struct igc_hw *hw = &adapter->hw;
+	u32 val;
+
+	val = rd32(IGC_RXPBS);
+	val |= IGC_RXPBS_CFG_TS_EN;
+	wr32(IGC_RXPBS, val);
+
+	/* FIXME: For now, only support retrieving RX timestamps from timer 0
+	 */
+	igc_ptp_enable_tstamp_all_rxqueues(adapter, 0);
+
+	val = IGC_TSYNCRXCTL_ENABLED | IGC_TSYNCRXCTL_TYPE_ALL |
+	      IGC_TSYNCRXCTL_RXSYNSIG;
+	wr32(IGC_TSYNCRXCTL, val);
+}
+
+static void igc_ptp_disable_tx_timestamp(struct igc_adapter *adapter)
+{
+	struct igc_hw *hw = &adapter->hw;
+
+	wr32(IGC_TSYNCTXCTL, 0);
+}
+
+static void igc_ptp_enable_tx_timestamp(struct igc_adapter *adapter)
+{
+	struct igc_hw *hw = &adapter->hw;
+
+	wr32(IGC_TSYNCTXCTL, IGC_TSYNCTXCTL_ENABLED | IGC_TSYNCTXCTL_TXSYNSIG);
+
+	/* Read TXSTMP registers to discard any timestamp previously stored. */
+	rd32(IGC_TXSTMPL);
+	rd32(IGC_TXSTMPH);
+}
+
 /**
  * igc_ptp_set_timestamp_mode - setup hardware for timestamping
  * @adapter: networking device structure
@@ -249,19 +297,16 @@ static void igc_ptp_enable_tstamp_all_rxqueues(struct igc_adapter *adapter,
 static int igc_ptp_set_timestamp_mode(struct igc_adapter *adapter,
 				      struct hwtstamp_config *config)
 {
-	u32 tsync_tx_ctl = IGC_TSYNCTXCTL_ENABLED;
-	u32 tsync_rx_ctl = IGC_TSYNCRXCTL_ENABLED;
-	struct igc_hw *hw = &adapter->hw;
-	u32 regval;
-
 	/* reserved for future extensions */
 	if (config->flags)
 		return -EINVAL;
 
 	switch (config->tx_type) {
 	case HWTSTAMP_TX_OFF:
-		tsync_tx_ctl = 0;
+		igc_ptp_disable_tx_timestamp(adapter);
+		break;
 	case HWTSTAMP_TX_ON:
+		igc_ptp_enable_tx_timestamp(adapter);
 		break;
 	default:
 		return -ERANGE;
@@ -269,7 +314,7 @@ static int igc_ptp_set_timestamp_mode(struct igc_adapter *adapter,
 
 	switch (config->rx_filter) {
 	case HWTSTAMP_FILTER_NONE:
-		tsync_rx_ctl = 0;
+		igc_ptp_disable_rx_timestamp(adapter);
 		break;
 	case HWTSTAMP_FILTER_PTP_V1_L4_SYNC:
 	case HWTSTAMP_FILTER_PTP_V1_L4_DELAY_REQ:
@@ -285,55 +330,13 @@ static int igc_ptp_set_timestamp_mode(struct igc_adapter *adapter,
 	case HWTSTAMP_FILTER_PTP_V1_L4_EVENT:
 	case HWTSTAMP_FILTER_NTP_ALL:
 	case HWTSTAMP_FILTER_ALL:
-		tsync_rx_ctl |= IGC_TSYNCRXCTL_TYPE_ALL;
+		igc_ptp_enable_rx_timestamp(adapter);
 		config->rx_filter = HWTSTAMP_FILTER_ALL;
 		break;
 	default:
-		config->rx_filter = HWTSTAMP_FILTER_NONE;
 		return -ERANGE;
 	}
 
-	if (tsync_rx_ctl) {
-		tsync_rx_ctl = IGC_TSYNCRXCTL_ENABLED;
-		tsync_rx_ctl |= IGC_TSYNCRXCTL_TYPE_ALL;
-		tsync_rx_ctl |= IGC_TSYNCRXCTL_RXSYNSIG;
-		config->rx_filter = HWTSTAMP_FILTER_ALL;
-
-		if (hw->mac.type == igc_i225) {
-			regval = rd32(IGC_RXPBS);
-			regval |= IGC_RXPBS_CFG_TS_EN;
-			wr32(IGC_RXPBS, regval);
-
-			/* FIXME: For now, only support retrieving RX
-			 * timestamps from timer 0
-			 */
-			igc_ptp_enable_tstamp_all_rxqueues(adapter, 0);
-		}
-	}
-
-	if (tsync_tx_ctl) {
-		tsync_tx_ctl = IGC_TSYNCTXCTL_ENABLED;
-		tsync_tx_ctl |= IGC_TSYNCTXCTL_TXSYNSIG;
-	}
-
-	/* enable/disable TX */
-	regval = rd32(IGC_TSYNCTXCTL);
-	regval &= ~IGC_TSYNCTXCTL_ENABLED;
-	regval |= tsync_tx_ctl;
-	wr32(IGC_TSYNCTXCTL, regval);
-
-	/* enable/disable RX */
-	regval = rd32(IGC_TSYNCRXCTL);
-	regval &= ~(IGC_TSYNCRXCTL_ENABLED | IGC_TSYNCRXCTL_TYPE_MASK);
-	regval |= tsync_rx_ctl;
-	wr32(IGC_TSYNCRXCTL, regval);
-
-	wrfl();
-
-	/* clear TX time stamp registers, just to be sure */
-	regval = rd32(IGC_TXSTMPL);
-	regval = rd32(IGC_TXSTMPH);
-
 	return 0;
 }
 
-- 
2.26.2

