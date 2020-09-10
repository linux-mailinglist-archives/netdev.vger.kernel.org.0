Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 373E0263A02
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 04:17:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730606AbgIJCRL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 22:17:11 -0400
Received: from mga14.intel.com ([192.55.52.115]:25870 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730722AbgIJCQ2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Sep 2020 22:16:28 -0400
IronPort-SDR: v7De5X1SQJiMfFDnITln+EecmAuYAlaevSOXk24iqdnM+CY3V6q//H+Ry/eKCWRi5Se81ChYkn
 sUggC2HMtgUg==
X-IronPort-AV: E=McAfee;i="6000,8403,9739"; a="157721720"
X-IronPort-AV: E=Sophos;i="5.76,411,1592895600"; 
   d="scan'208";a="157721720"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2020 17:04:23 -0700
IronPort-SDR: Vxoe4jMghD752a75ahUZfF8G6l3PmWXzQlO0qGjxXyu8mgWcANq+HggbOUlHIWpKJitbIlVdBA
 BQ7U3+KAnjZQ==
X-IronPort-AV: E=Sophos;i="5.76,411,1592895600"; 
   d="scan'208";a="341733842"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2020 17:04:23 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com, anthony.l.nguyen@intel.com,
        Aaron Brown <aaron.f.brown@intel.com>
Subject: [net 4/4] igc: Fix not considering the TX delay for timestamps
Date:   Wed,  9 Sep 2020 17:04:11 -0700
Message-Id: <20200910000411.2658780-5-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200910000411.2658780-1-anthony.l.nguyen@intel.com>
References: <20200910000411.2658780-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vinicius Costa Gomes <vinicius.gomes@intel.com>

When timestamping a packet there's a delay between the start of the
packet and the point where the hardware actually captures the
timestamp. This difference needs to be considered if we want accurate
timestamps.

This was done on the RX side, but not on the TX side.

Fixes: 2c344ae24501 ("igc: Add support for TX timestamping")
Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_ptp.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/net/ethernet/intel/igc/igc_ptp.c b/drivers/net/ethernet/intel/igc/igc_ptp.c
index 36c999250fcc..6a9b5102aa55 100644
--- a/drivers/net/ethernet/intel/igc/igc_ptp.c
+++ b/drivers/net/ethernet/intel/igc/igc_ptp.c
@@ -364,6 +364,7 @@ static void igc_ptp_tx_hwtstamp(struct igc_adapter *adapter)
 	struct sk_buff *skb = adapter->ptp_tx_skb;
 	struct skb_shared_hwtstamps shhwtstamps;
 	struct igc_hw *hw = &adapter->hw;
+	int adjust = 0;
 	u64 regval;
 
 	if (WARN_ON_ONCE(!skb))
@@ -373,6 +374,24 @@ static void igc_ptp_tx_hwtstamp(struct igc_adapter *adapter)
 	regval |= (u64)rd32(IGC_TXSTMPH) << 32;
 	igc_ptp_systim_to_hwtstamp(adapter, &shhwtstamps, regval);
 
+	switch (adapter->link_speed) {
+	case SPEED_10:
+		adjust = IGC_I225_TX_LATENCY_10;
+		break;
+	case SPEED_100:
+		adjust = IGC_I225_TX_LATENCY_100;
+		break;
+	case SPEED_1000:
+		adjust = IGC_I225_TX_LATENCY_1000;
+		break;
+	case SPEED_2500:
+		adjust = IGC_I225_TX_LATENCY_2500;
+		break;
+	}
+
+	shhwtstamps.hwtstamp =
+		ktime_add_ns(shhwtstamps.hwtstamp, adjust);
+
 	/* Clear the lock early before calling skb_tstamp_tx so that
 	 * applications are not woken up before the lock bit is clear. We use
 	 * a copy of the skb pointer to ensure other threads can't change it
-- 
2.26.2

