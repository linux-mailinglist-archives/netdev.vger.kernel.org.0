Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CD833421A1
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 17:19:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230158AbhCSQSi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 12:18:38 -0400
Received: from mga09.intel.com ([134.134.136.24]:48297 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230039AbhCSQSf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Mar 2021 12:18:35 -0400
IronPort-SDR: neQ3cHh/4DHpPbjtYAKWeLN0+gZ34H0E7qU/yTuECYATs8l3nF0GbSPH0XlBUKCtowbVADg10H
 0XRR/Is4fFXQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9928"; a="190014469"
X-IronPort-AV: E=Sophos;i="5.81,262,1610438400"; 
   d="scan'208";a="190014469"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2021 09:18:34 -0700
IronPort-SDR: eraE6rxweHkVj8Jo+j2qTgRwYFcbLlgd6AV6b07IAM/UJ+cPVgedmhOkoXKl4RR8k7cIBtfOV8
 LPYthLNLO7Qw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,262,1610438400"; 
   d="scan'208";a="450915177"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga001.jf.intel.com with ESMTP; 19 Mar 2021 09:18:34 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        anthony.l.nguyen@intel.com, Dave Switzer <david.switzer@intel.com>
Subject: [PATCH net 3/3] igb: check timestamp validity
Date:   Fri, 19 Mar 2021 09:19:57 -0700
Message-Id: <20210319161957.784610-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210319161957.784610-1-anthony.l.nguyen@intel.com>
References: <20210319161957.784610-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesse Brandeburg <jesse.brandeburg@intel.com>

Add a couple of checks to make sure timestamping is on and that the
timestamp value from DMA is valid. This avoids any functional issues
that could come from a misinterpreted time stamp.

One of the functions changed doesn't need a return value added because
there was no value in checking from the calling locations.

While here, fix a couple of reverse christmas tree issues next to
the code being changed.

Fixes: f56e7bba22fa ("igb: Pull timestamp from fragment before adding it to skb")
Fixes: 9cbc948b5a20 ("igb: add XDP support")
Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Tested-by: Dave Switzer <david.switzer@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igb/igb.h      |  4 +--
 drivers/net/ethernet/intel/igb/igb_main.c | 11 ++++----
 drivers/net/ethernet/intel/igb/igb_ptp.c  | 31 ++++++++++++++++++-----
 3 files changed, 32 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/igb.h b/drivers/net/ethernet/intel/igb/igb.h
index aaa954aae574..7bda8c5edea5 100644
--- a/drivers/net/ethernet/intel/igb/igb.h
+++ b/drivers/net/ethernet/intel/igb/igb.h
@@ -748,8 +748,8 @@ void igb_ptp_suspend(struct igb_adapter *adapter);
 void igb_ptp_rx_hang(struct igb_adapter *adapter);
 void igb_ptp_tx_hang(struct igb_adapter *adapter);
 void igb_ptp_rx_rgtstamp(struct igb_q_vector *q_vector, struct sk_buff *skb);
-void igb_ptp_rx_pktstamp(struct igb_q_vector *q_vector, void *va,
-			 struct sk_buff *skb);
+int igb_ptp_rx_pktstamp(struct igb_q_vector *q_vector, void *va,
+			struct sk_buff *skb);
 int igb_ptp_set_ts_config(struct net_device *netdev, struct ifreq *ifr);
 int igb_ptp_get_ts_config(struct net_device *netdev, struct ifreq *ifr);
 void igb_set_flag_queue_pairs(struct igb_adapter *, const u32);
diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index d3b37761f637..a45cd2b416c8 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -8302,9 +8302,10 @@ static struct sk_buff *igb_construct_skb(struct igb_ring *rx_ring,
 		return NULL;
 
 	if (unlikely(igb_test_staterr(rx_desc, E1000_RXDADV_STAT_TSIP))) {
-		igb_ptp_rx_pktstamp(rx_ring->q_vector, xdp->data, skb);
-		xdp->data += IGB_TS_HDR_LEN;
-		size -= IGB_TS_HDR_LEN;
+		if (!igb_ptp_rx_pktstamp(rx_ring->q_vector, xdp->data, skb)) {
+			xdp->data += IGB_TS_HDR_LEN;
+			size -= IGB_TS_HDR_LEN;
+		}
 	}
 
 	/* Determine available headroom for copy */
@@ -8365,8 +8366,8 @@ static struct sk_buff *igb_build_skb(struct igb_ring *rx_ring,
 
 	/* pull timestamp out of packet data */
 	if (igb_test_staterr(rx_desc, E1000_RXDADV_STAT_TSIP)) {
-		igb_ptp_rx_pktstamp(rx_ring->q_vector, skb->data, skb);
-		__skb_pull(skb, IGB_TS_HDR_LEN);
+		if (!igb_ptp_rx_pktstamp(rx_ring->q_vector, skb->data, skb))
+			__skb_pull(skb, IGB_TS_HDR_LEN);
 	}
 
 	/* update buffer offset */
diff --git a/drivers/net/ethernet/intel/igb/igb_ptp.c b/drivers/net/ethernet/intel/igb/igb_ptp.c
index 7cc5428c3b3d..86a576201f5f 100644
--- a/drivers/net/ethernet/intel/igb/igb_ptp.c
+++ b/drivers/net/ethernet/intel/igb/igb_ptp.c
@@ -856,6 +856,9 @@ static void igb_ptp_tx_hwtstamp(struct igb_adapter *adapter)
 	dev_kfree_skb_any(skb);
 }
 
+#define IGB_RET_PTP_DISABLED 1
+#define IGB_RET_PTP_INVALID 2
+
 /**
  * igb_ptp_rx_pktstamp - retrieve Rx per packet timestamp
  * @q_vector: Pointer to interrupt specific structure
@@ -864,19 +867,29 @@ static void igb_ptp_tx_hwtstamp(struct igb_adapter *adapter)
  *
  * This function is meant to retrieve a timestamp from the first buffer of an
  * incoming frame.  The value is stored in little endian format starting on
- * byte 8.
+ * byte 8
+ *
+ * Returns: 0 if success, nonzero if failure
  **/
-void igb_ptp_rx_pktstamp(struct igb_q_vector *q_vector, void *va,
-			 struct sk_buff *skb)
+int igb_ptp_rx_pktstamp(struct igb_q_vector *q_vector, void *va,
+			struct sk_buff *skb)
 {
-	__le64 *regval = (__le64 *)va;
 	struct igb_adapter *adapter = q_vector->adapter;
+	__le64 *regval = (__le64 *)va;
 	int adjust = 0;
 
+	if (!(adapter->ptp_flags & IGB_PTP_ENABLED))
+		return IGB_RET_PTP_DISABLED;
+
 	/* The timestamp is recorded in little endian format.
 	 * DWORD: 0        1        2        3
 	 * Field: Reserved Reserved SYSTIML  SYSTIMH
 	 */
+
+	/* check reserved dwords are zero, be/le doesn't matter for zero */
+	if (regval[0])
+		return IGB_RET_PTP_INVALID;
+
 	igb_ptp_systim_to_hwtstamp(adapter, skb_hwtstamps(skb),
 				   le64_to_cpu(regval[1]));
 
@@ -896,6 +909,8 @@ void igb_ptp_rx_pktstamp(struct igb_q_vector *q_vector, void *va,
 	}
 	skb_hwtstamps(skb)->hwtstamp =
 		ktime_sub_ns(skb_hwtstamps(skb)->hwtstamp, adjust);
+
+	return 0;
 }
 
 /**
@@ -906,13 +921,15 @@ void igb_ptp_rx_pktstamp(struct igb_q_vector *q_vector, void *va,
  * This function is meant to retrieve a timestamp from the internal registers
  * of the adapter and store it in the skb.
  **/
-void igb_ptp_rx_rgtstamp(struct igb_q_vector *q_vector,
-			 struct sk_buff *skb)
+void igb_ptp_rx_rgtstamp(struct igb_q_vector *q_vector, struct sk_buff *skb)
 {
 	struct igb_adapter *adapter = q_vector->adapter;
 	struct e1000_hw *hw = &adapter->hw;
-	u64 regval;
 	int adjust = 0;
+	u64 regval;
+
+	if (!(adapter->ptp_flags & IGB_PTP_ENABLED))
+		return;
 
 	/* If this bit is set, then the RX registers contain the time stamp. No
 	 * other packet will be time stamped until we read these registers, so
-- 
2.26.2

