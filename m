Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A40C8337BBE
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 19:08:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbhCKSIU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 13:08:20 -0500
Received: from mga09.intel.com ([134.134.136.24]:47785 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229520AbhCKSH7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 13:07:59 -0500
IronPort-SDR: SqHnUn1xoNPlyHlRmifjoM3VhdxV8jSHwJ4ufp5/HiAq7OSxwMCUjox47AiAAputG2cFrwOiwr
 kWpE9JTdJvLQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9920"; a="188809483"
X-IronPort-AV: E=Sophos;i="5.81,241,1610438400"; 
   d="scan'208";a="188809483"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2021 10:07:58 -0800
IronPort-SDR: jLmxyGWlcNs//lntWRav1yY++9DMhUa1taLHVme2qQtKCJjjgp9dCK9y9fgvtIGT8WAhUY+idt
 JAK4Busp3ztQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,241,1610438400"; 
   d="scan'208";a="409570561"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga007.jf.intel.com with ESMTP; 11 Mar 2021 10:07:58 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Andre Guedes <andre.guedes@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        sasha.neftin@intel.com, vitaly.lifshits@intel.com,
        jithu.joseph@intel.com, richardcochran@gmail.com,
        Vedang Patel <vedang.patel@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Subject: [PATCH net 4/6] igc: Fix igc_ptp_rx_pktstamp()
Date:   Thu, 11 Mar 2021 10:09:13 -0800
Message-Id: <20210311180915.1489936-5-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210311180915.1489936-1-anthony.l.nguyen@intel.com>
References: <20210311180915.1489936-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andre Guedes <andre.guedes@intel.com>

The comment describing the timestamps layout in the packet buffer is
wrong and the code is actually retrieving the timestamp in Timer 1
reference instead of Timer 0. This hasn't been a big issue so far
because hardware is configured to report both timestamps using Timer 0
(see IGC_SRRCTL register configuration in igc_ptp_enable_rx_timestamp()
helper). This patch fixes the comment and the code so we retrieve the
timestamp in Timer 0 reference as expected.

This patch also takes the opportunity to get rid of the hw.mac.type check
since it is not required.

Fixes: 81b055205e8ba ("igc: Add support for RX timestamping")
Signed-off-by: Andre Guedes <andre.guedes@intel.com>
Signed-off-by: Vedang Patel <vedang.patel@intel.com>
Signed-off-by: Jithu Joseph <jithu.joseph@intel.com>
Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Tested-by: Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igc/igc.h     |  2 +-
 drivers/net/ethernet/intel/igc/igc_ptp.c | 72 +++++++++++++-----------
 2 files changed, 41 insertions(+), 33 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc.h b/drivers/net/ethernet/intel/igc/igc.h
index 5d2809dfd06a..1b08a7dc7bc4 100644
--- a/drivers/net/ethernet/intel/igc/igc.h
+++ b/drivers/net/ethernet/intel/igc/igc.h
@@ -547,7 +547,7 @@ void igc_ptp_init(struct igc_adapter *adapter);
 void igc_ptp_reset(struct igc_adapter *adapter);
 void igc_ptp_suspend(struct igc_adapter *adapter);
 void igc_ptp_stop(struct igc_adapter *adapter);
-void igc_ptp_rx_pktstamp(struct igc_q_vector *q_vector, void *va,
+void igc_ptp_rx_pktstamp(struct igc_q_vector *q_vector, __le32 *va,
 			 struct sk_buff *skb);
 int igc_ptp_set_ts_config(struct net_device *netdev, struct ifreq *ifr);
 int igc_ptp_get_ts_config(struct net_device *netdev, struct ifreq *ifr);
diff --git a/drivers/net/ethernet/intel/igc/igc_ptp.c b/drivers/net/ethernet/intel/igc/igc_ptp.c
index ac0b9c85da7c..545f4d0e67cf 100644
--- a/drivers/net/ethernet/intel/igc/igc_ptp.c
+++ b/drivers/net/ethernet/intel/igc/igc_ptp.c
@@ -152,46 +152,54 @@ static void igc_ptp_systim_to_hwtstamp(struct igc_adapter *adapter,
 }
 
 /**
- * igc_ptp_rx_pktstamp - retrieve Rx per packet timestamp
+ * igc_ptp_rx_pktstamp - Retrieve timestamp from Rx packet buffer
  * @q_vector: Pointer to interrupt specific structure
  * @va: Pointer to address containing Rx buffer
  * @skb: Buffer containing timestamp and packet
  *
- * This function is meant to retrieve the first timestamp from the
- * first buffer of an incoming frame. The value is stored in little
- * endian format starting on byte 0. There's a second timestamp
- * starting on byte 8.
- **/
-void igc_ptp_rx_pktstamp(struct igc_q_vector *q_vector, void *va,
+ * This function retrieves the timestamp saved in the beginning of packet
+ * buffer. While two timestamps are available, one in timer0 reference and the
+ * other in timer1 reference, this function considers only the timestamp in
+ * timer0 reference.
+ */
+void igc_ptp_rx_pktstamp(struct igc_q_vector *q_vector, __le32 *va,
 			 struct sk_buff *skb)
 {
 	struct igc_adapter *adapter = q_vector->adapter;
-	__le64 *regval = (__le64 *)va;
-	int adjust = 0;
-
-	/* The timestamp is recorded in little endian format.
-	 * DWORD: | 0          | 1           | 2          | 3
-	 * Field: | Timer0 Low | Timer0 High | Timer1 Low | Timer1 High
+	u64 regval;
+	int adjust;
+
+	/* Timestamps are saved in little endian at the beginning of the packet
+	 * buffer following the layout:
+	 *
+	 * DWORD: | 0              | 1              | 2              | 3              |
+	 * Field: | Timer1 SYSTIML | Timer1 SYSTIMH | Timer0 SYSTIML | Timer0 SYSTIMH |
+	 *
+	 * SYSTIML holds the nanoseconds part while SYSTIMH holds the seconds
+	 * part of the timestamp.
 	 */
-	igc_ptp_systim_to_hwtstamp(adapter, skb_hwtstamps(skb),
-				   le64_to_cpu(regval[0]));
-
-	/* adjust timestamp for the RX latency based on link speed */
-	if (adapter->hw.mac.type == igc_i225) {
-		switch (adapter->link_speed) {
-		case SPEED_10:
-			adjust = IGC_I225_RX_LATENCY_10;
-			break;
-		case SPEED_100:
-			adjust = IGC_I225_RX_LATENCY_100;
-			break;
-		case SPEED_1000:
-			adjust = IGC_I225_RX_LATENCY_1000;
-			break;
-		case SPEED_2500:
-			adjust = IGC_I225_RX_LATENCY_2500;
-			break;
-		}
+	regval = le32_to_cpu(va[2]);
+	regval |= (u64)le32_to_cpu(va[3]) << 32;
+	igc_ptp_systim_to_hwtstamp(adapter, skb_hwtstamps(skb), regval);
+
+	/* Adjust timestamp for the RX latency based on link speed */
+	switch (adapter->link_speed) {
+	case SPEED_10:
+		adjust = IGC_I225_RX_LATENCY_10;
+		break;
+	case SPEED_100:
+		adjust = IGC_I225_RX_LATENCY_100;
+		break;
+	case SPEED_1000:
+		adjust = IGC_I225_RX_LATENCY_1000;
+		break;
+	case SPEED_2500:
+		adjust = IGC_I225_RX_LATENCY_2500;
+		break;
+	default:
+		adjust = 0;
+		netdev_warn_once(adapter->netdev, "Imprecise timestamp\n");
+		break;
 	}
 	skb_hwtstamps(skb)->hwtstamp =
 		ktime_sub_ns(skb_hwtstamps(skb)->hwtstamp, adjust);
-- 
2.26.2

