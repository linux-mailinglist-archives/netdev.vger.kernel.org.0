Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C601A20BDA3
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 03:54:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726577AbgF0Byr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 21:54:47 -0400
Received: from mga03.intel.com ([134.134.136.65]:29243 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726485AbgF0Byo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Jun 2020 21:54:44 -0400
IronPort-SDR: e/9cvVqRmfMn90ETT7tbWHNem29GEa1srfUfz5AtuzCvF1HmacrTz4TkBFFJ67xHZitjjZJg3o
 +I0PvuVzeIqQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9664"; a="145588574"
X-IronPort-AV: E=Sophos;i="5.75,285,1589266800"; 
   d="scan'208";a="145588574"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2020 18:54:36 -0700
IronPort-SDR: r0kLGxMAEDl+34E+qfwa+H0sPAxd3BTbeA9TitMEXlZpYOAISGReyvNXfh1tRsalp5NlubEobU
 Ia8waVdIYE9g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,285,1589266800"; 
   d="scan'208";a="312495104"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga002.fm.intel.com with ESMTP; 26 Jun 2020 18:54:36 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Andre Guedes <andre.guedes@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 03/13] igc: Clean up Rx timestamping logic
Date:   Fri, 26 Jun 2020 18:54:21 -0700
Message-Id: <20200627015431.3579234-4-jeffrey.t.kirsher@intel.com>
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

Differently from I210, I225 doesn't report Rx timestamps via the TS bit
Rx descriptor + RXSTMPL/RXSTMPH registers mechanism. Rx timestamps are
reported in the packet buffer only, which is implemented by igc_ptp_rx_
pktstamp(). So this patch removes igc_ptp_rx_rgtstamp() and all code
related to it, copied from igb driver.

Signed-off-by: Andre Guedes <andre.guedes@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/igc/igc.h         |  3 --
 drivers/net/ethernet/intel/igc/igc_defines.h |  2 -
 drivers/net/ethernet/intel/igc/igc_main.c    | 12 ++----
 drivers/net/ethernet/intel/igc/igc_ptp.c     | 44 +-------------------
 drivers/net/ethernet/intel/igc/igc_regs.h    |  2 -
 5 files changed, 5 insertions(+), 58 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc.h b/drivers/net/ethernet/intel/igc/igc.h
index 9c57afad6afe..3070dfdb7eb4 100644
--- a/drivers/net/ethernet/intel/igc/igc.h
+++ b/drivers/net/ethernet/intel/igc/igc.h
@@ -210,8 +210,6 @@ struct igc_adapter {
 	struct sk_buff *ptp_tx_skb;
 	struct hwtstamp_config tstamp_config;
 	unsigned long ptp_tx_start;
-	unsigned long last_rx_ptp_check;
-	unsigned long last_rx_timestamp;
 	unsigned int ptp_flags;
 	/* System time value lock */
 	spinlock_t tmreg_lock;
@@ -549,7 +547,6 @@ void igc_ptp_init(struct igc_adapter *adapter);
 void igc_ptp_reset(struct igc_adapter *adapter);
 void igc_ptp_suspend(struct igc_adapter *adapter);
 void igc_ptp_stop(struct igc_adapter *adapter);
-void igc_ptp_rx_rgtstamp(struct igc_q_vector *q_vector, struct sk_buff *skb);
 void igc_ptp_rx_pktstamp(struct igc_q_vector *q_vector, void *va,
 			 struct sk_buff *skb);
 int igc_ptp_set_ts_config(struct net_device *netdev, struct ifreq *ifr);
diff --git a/drivers/net/ethernet/intel/igc/igc_defines.h b/drivers/net/ethernet/intel/igc/igc_defines.h
index ed0e560daaae..f1f464967f87 100644
--- a/drivers/net/ethernet/intel/igc/igc_defines.h
+++ b/drivers/net/ethernet/intel/igc/igc_defines.h
@@ -323,7 +323,6 @@
 
 /* Advanced Receive Descriptor bit definitions */
 #define IGC_RXDADV_STAT_TSIP	0x08000 /* timestamp in packet */
-#define IGC_RXDADV_STAT_TS	0x10000 /* Pkt was time stamped */
 
 #define IGC_RXDEXT_STATERR_CE		0x01000000
 #define IGC_RXDEXT_STATERR_SE		0x02000000
@@ -384,7 +383,6 @@
 #define IGC_FTQF_MASK_PROTO_BP	0x10000000
 
 /* Time Sync Receive Control bit definitions */
-#define IGC_TSYNCRXCTL_VALID		0x00000001  /* Rx timestamp valid */
 #define IGC_TSYNCRXCTL_TYPE_MASK	0x0000000E  /* Rx type mask */
 #define IGC_TSYNCRXCTL_TYPE_L2_V2	0x00
 #define IGC_TSYNCRXCTL_TYPE_L4_V1	0x02
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 7e4d56c7b4c4..1b71f63d0e86 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -1479,9 +1479,9 @@ static inline void igc_rx_hash(struct igc_ring *ring,
  * @rx_desc: pointer to the EOP Rx descriptor
  * @skb: pointer to current skb being populated
  *
- * This function checks the ring, descriptor, and packet information in
- * order to populate the hash, checksum, VLAN, timestamp, protocol, and
- * other fields within the skb.
+ * This function checks the ring, descriptor, and packet information in order
+ * to populate the hash, checksum, VLAN, protocol, and other fields within the
+ * skb.
  */
 static void igc_process_skb_fields(struct igc_ring *rx_ring,
 				   union igc_adv_rx_desc *rx_desc,
@@ -1491,10 +1491,6 @@ static void igc_process_skb_fields(struct igc_ring *rx_ring,
 
 	igc_rx_checksum(rx_ring, rx_desc, skb);
 
-	if (igc_test_staterr(rx_desc, IGC_RXDADV_STAT_TS) &&
-	    !igc_test_staterr(rx_desc, IGC_RXDADV_STAT_TSIP))
-		igc_ptp_rx_rgtstamp(rx_ring->q_vector, skb);
-
 	skb_record_rx_queue(skb, rx_ring->queue_index);
 
 	skb->protocol = eth_type_trans(skb, rx_ring->netdev);
@@ -1975,7 +1971,7 @@ static int igc_clean_rx_irq(struct igc_q_vector *q_vector, const int budget)
 		/* probably a little skewed due to removing CRC */
 		total_bytes += skb->len;
 
-		/* populate checksum, timestamp, VLAN, and protocol */
+		/* populate checksum, VLAN, and protocol */
 		igc_process_skb_fields(rx_ring, rx_desc, skb);
 
 		napi_gro_receive(&q_vector->napi, skb);
diff --git a/drivers/net/ethernet/intel/igc/igc_ptp.c b/drivers/net/ethernet/intel/igc/igc_ptp.c
index 0d746f8588c8..82e6c6c962d5 100644
--- a/drivers/net/ethernet/intel/igc/igc_ptp.c
+++ b/drivers/net/ethernet/intel/igc/igc_ptp.c
@@ -205,46 +205,6 @@ void igc_ptp_rx_pktstamp(struct igc_q_vector *q_vector, void *va,
 		ktime_sub_ns(skb_hwtstamps(skb)->hwtstamp, adjust);
 }
 
-/**
- * igc_ptp_rx_rgtstamp - retrieve Rx timestamp stored in register
- * @q_vector: Pointer to interrupt specific structure
- * @skb: Buffer containing timestamp and packet
- *
- * This function is meant to retrieve a timestamp from the internal registers
- * of the adapter and store it in the skb.
- */
-void igc_ptp_rx_rgtstamp(struct igc_q_vector *q_vector,
-			 struct sk_buff *skb)
-{
-	struct igc_adapter *adapter = q_vector->adapter;
-	struct igc_hw *hw = &adapter->hw;
-	u64 regval;
-
-	/* If this bit is set, then the RX registers contain the time
-	 * stamp. No other packet will be time stamped until we read
-	 * these registers, so read the registers to make them
-	 * available again. Because only one packet can be time
-	 * stamped at a time, we know that the register values must
-	 * belong to this one here and therefore we don't need to
-	 * compare any of the additional attributes stored for it.
-	 *
-	 * If nothing went wrong, then it should have a shared
-	 * tx_flags that we can turn into a skb_shared_hwtstamps.
-	 */
-	if (!(rd32(IGC_TSYNCRXCTL) & IGC_TSYNCRXCTL_VALID))
-		return;
-
-	regval = rd32(IGC_RXSTMPL);
-	regval |= (u64)rd32(IGC_RXSTMPH) << 32;
-
-	igc_ptp_systim_to_hwtstamp(adapter, skb_hwtstamps(skb), regval);
-
-	/* Update the last_rx_timestamp timer in order to enable watchdog check
-	 * for error case of latched timestamp on a dropped packet.
-	 */
-	adapter->last_rx_timestamp = jiffies;
-}
-
 /**
  * igc_ptp_enable_tstamp_rxqueue - Enable RX timestamp for a queue
  * @rx_ring: Pointer to RX queue
@@ -419,11 +379,9 @@ static int igc_ptp_set_timestamp_mode(struct igc_adapter *adapter,
 	}
 	wrfl();
 
-	/* clear TX/RX time stamp registers, just to be sure */
+	/* clear TX time stamp registers, just to be sure */
 	regval = rd32(IGC_TXSTMPL);
 	regval = rd32(IGC_TXSTMPH);
-	regval = rd32(IGC_RXSTMPL);
-	regval = rd32(IGC_RXSTMPH);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/intel/igc/igc_regs.h b/drivers/net/ethernet/intel/igc/igc_regs.h
index 97f9b928509f..d53f49833db5 100644
--- a/drivers/net/ethernet/intel/igc/igc_regs.h
+++ b/drivers/net/ethernet/intel/igc/igc_regs.h
@@ -228,8 +228,6 @@
 #define IGC_SYSTIMR	0x0B6F8  /* System time register Residue */
 #define IGC_TIMINCA	0x0B608  /* Increment attributes register - RW */
 
-#define IGC_RXSTMPL	0x0B624  /* Rx timestamp Low - RO */
-#define IGC_RXSTMPH	0x0B628  /* Rx timestamp High - RO */
 #define IGC_TXSTMPL	0x0B618  /* Tx timestamp value Low - RO */
 #define IGC_TXSTMPH	0x0B61C  /* Tx timestamp value High - RO */
 
-- 
2.26.2

