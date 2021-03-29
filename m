Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61F2334D5BC
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 19:09:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231367AbhC2RIh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 13:08:37 -0400
Received: from mga02.intel.com ([134.134.136.20]:51878 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230323AbhC2RID (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Mar 2021 13:08:03 -0400
IronPort-SDR: WubWbGtK2RlGIEI0NUCn36KD16Q+eC9kj2FNqCTKQffa6kgLOOtAMxSp4n5zkjz4bnFE0wTLnS
 /zEFvhOw1jPA==
X-IronPort-AV: E=McAfee;i="6000,8403,9938"; a="178720133"
X-IronPort-AV: E=Sophos;i="5.81,288,1610438400"; 
   d="scan'208";a="178720133"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Mar 2021 10:08:00 -0700
IronPort-SDR: 0fWhAa3dy07eKhBp3MyJxrFP74h/N1J+FoUguGTSSDliCSq/tPYaI9wFDeX2bMF3AhB1VycHr1
 IU2z4xYoE+FQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,288,1610438400"; 
   d="scan'208";a="606447269"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga006.fm.intel.com with ESMTP; 29 Mar 2021 10:07:59 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Andre Guedes <andre.guedes@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        bjorn.topel@intel.com, magnus.karlsson@intel.com,
        maciej.fijalkowski@intel.com, sasha.neftin@intel.com,
        vitaly.lifshits@intel.com, Vedang Patel <vedang.patel@intel.com>,
        Jithu Joseph <jithu.joseph@intel.com>,
        Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Subject: [PATCH net-next 4/8] igc: Refactor Rx timestamp handling
Date:   Mon, 29 Mar 2021 10:09:27 -0700
Message-Id: <20210329170931.2356162-5-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210329170931.2356162-1-anthony.l.nguyen@intel.com>
References: <20210329170931.2356162-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andre Guedes <andre.guedes@intel.com>

Refactor the Rx timestamp handling in preparation to land
XDP support.

Rx timestamps are put in the Rx buffer by hardware, before the packet
data. When creating the xdp buffer, we will need to check the Rx
descriptor to determine if the buffer contains timestamp information
and consider the offset when setting xdp.data.

The Rx descriptor check is already done in igc_construct_skb(). To
avoid code duplication, this patch moves the timestamp handling to
igc_clean_rx_irq() so both skb and xdp paths can reuse it.

Signed-off-by: Andre Guedes <andre.guedes@intel.com>
Signed-off-by: Vedang Patel <vedang.patel@intel.com>
Signed-off-by: Jithu Joseph <jithu.joseph@intel.com>
Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Tested-by: Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igc/igc.h      |  3 +--
 drivers/net/ethernet/intel/igc/igc_main.c | 30 +++++++++++++++--------
 drivers/net/ethernet/intel/igc/igc_ptp.c  | 25 ++++++++++---------
 3 files changed, 34 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc.h b/drivers/net/ethernet/intel/igc/igc.h
index 1b08a7dc7bc4..c6d38c6a1a6a 100644
--- a/drivers/net/ethernet/intel/igc/igc.h
+++ b/drivers/net/ethernet/intel/igc/igc.h
@@ -547,8 +547,7 @@ void igc_ptp_init(struct igc_adapter *adapter);
 void igc_ptp_reset(struct igc_adapter *adapter);
 void igc_ptp_suspend(struct igc_adapter *adapter);
 void igc_ptp_stop(struct igc_adapter *adapter);
-void igc_ptp_rx_pktstamp(struct igc_q_vector *q_vector, __le32 *va,
-			 struct sk_buff *skb);
+ktime_t igc_ptp_rx_pktstamp(struct igc_adapter *adapter, __le32 *buf);
 int igc_ptp_set_ts_config(struct net_device *netdev, struct ifreq *ifr);
 int igc_ptp_get_ts_config(struct net_device *netdev, struct ifreq *ifr);
 void igc_ptp_tx_hang(struct igc_adapter *adapter);
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index d6947c1d6f49..1eacb4ebd9f6 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -1581,10 +1581,11 @@ static struct sk_buff *igc_build_skb(struct igc_ring *rx_ring,
 
 static struct sk_buff *igc_construct_skb(struct igc_ring *rx_ring,
 					 struct igc_rx_buffer *rx_buffer,
-					 union igc_adv_rx_desc *rx_desc,
-					 unsigned int size)
+					 unsigned int size, int pkt_offset,
+					 ktime_t timestamp)
 {
-	void *va = page_address(rx_buffer->page) + rx_buffer->page_offset;
+	void *va = page_address(rx_buffer->page) + rx_buffer->page_offset +
+		   pkt_offset;
 	unsigned int truesize = igc_get_rx_frame_truesize(rx_ring, size);
 	unsigned int headlen;
 	struct sk_buff *skb;
@@ -1597,11 +1598,8 @@ static struct sk_buff *igc_construct_skb(struct igc_ring *rx_ring,
 	if (unlikely(!skb))
 		return NULL;
 
-	if (unlikely(igc_test_staterr(rx_desc, IGC_RXDADV_STAT_TSIP))) {
-		igc_ptp_rx_pktstamp(rx_ring->q_vector, va, skb);
-		va += IGC_TS_HDR_LEN;
-		size -= IGC_TS_HDR_LEN;
-	}
+	if (timestamp)
+		skb_hwtstamps(skb)->hwtstamp = timestamp;
 
 	/* Determine available headroom for copy */
 	headlen = size;
@@ -1895,6 +1893,8 @@ static int igc_clean_rx_irq(struct igc_q_vector *q_vector, const int budget)
 	while (likely(total_packets < budget)) {
 		union igc_adv_rx_desc *rx_desc;
 		struct igc_rx_buffer *rx_buffer;
+		ktime_t timestamp = 0;
+		int pkt_offset = 0;
 		unsigned int size;
 
 		/* return some buffers to hardware, one at a time is too slow */
@@ -1916,14 +1916,24 @@ static int igc_clean_rx_irq(struct igc_q_vector *q_vector, const int budget)
 
 		rx_buffer = igc_get_rx_buffer(rx_ring, size);
 
+		if (igc_test_staterr(rx_desc, IGC_RXDADV_STAT_TSIP)) {
+			void *pktbuf = page_address(rx_buffer->page) +
+				       rx_buffer->page_offset;
+
+			timestamp = igc_ptp_rx_pktstamp(q_vector->adapter,
+							pktbuf);
+			pkt_offset = IGC_TS_HDR_LEN;
+			size -= IGC_TS_HDR_LEN;
+		}
+
 		/* retrieve a buffer from the ring */
 		if (skb)
 			igc_add_rx_frag(rx_ring, rx_buffer, skb, size);
 		else if (ring_uses_build_skb(rx_ring))
 			skb = igc_build_skb(rx_ring, rx_buffer, rx_desc, size);
 		else
-			skb = igc_construct_skb(rx_ring, rx_buffer,
-						rx_desc, size);
+			skb = igc_construct_skb(rx_ring, rx_buffer, size,
+						pkt_offset, timestamp);
 
 		/* exit if we failed to retrieve a buffer */
 		if (!skb) {
diff --git a/drivers/net/ethernet/intel/igc/igc_ptp.c b/drivers/net/ethernet/intel/igc/igc_ptp.c
index 545f4d0e67cf..dfa3b247fcd8 100644
--- a/drivers/net/ethernet/intel/igc/igc_ptp.c
+++ b/drivers/net/ethernet/intel/igc/igc_ptp.c
@@ -153,20 +153,20 @@ static void igc_ptp_systim_to_hwtstamp(struct igc_adapter *adapter,
 
 /**
  * igc_ptp_rx_pktstamp - Retrieve timestamp from Rx packet buffer
- * @q_vector: Pointer to interrupt specific structure
- * @va: Pointer to address containing Rx buffer
- * @skb: Buffer containing timestamp and packet
+ * @adapter: Pointer to adapter the packet buffer belongs to
+ * @buf: Pointer to packet buffer
  *
  * This function retrieves the timestamp saved in the beginning of packet
  * buffer. While two timestamps are available, one in timer0 reference and the
  * other in timer1 reference, this function considers only the timestamp in
  * timer0 reference.
+ *
+ * Returns timestamp value.
  */
-void igc_ptp_rx_pktstamp(struct igc_q_vector *q_vector, __le32 *va,
-			 struct sk_buff *skb)
+ktime_t igc_ptp_rx_pktstamp(struct igc_adapter *adapter, __le32 *buf)
 {
-	struct igc_adapter *adapter = q_vector->adapter;
-	u64 regval;
+	ktime_t timestamp;
+	u32 secs, nsecs;
 	int adjust;
 
 	/* Timestamps are saved in little endian at the beginning of the packet
@@ -178,9 +178,10 @@ void igc_ptp_rx_pktstamp(struct igc_q_vector *q_vector, __le32 *va,
 	 * SYSTIML holds the nanoseconds part while SYSTIMH holds the seconds
 	 * part of the timestamp.
 	 */
-	regval = le32_to_cpu(va[2]);
-	regval |= (u64)le32_to_cpu(va[3]) << 32;
-	igc_ptp_systim_to_hwtstamp(adapter, skb_hwtstamps(skb), regval);
+	nsecs = le32_to_cpu(buf[2]);
+	secs = le32_to_cpu(buf[3]);
+
+	timestamp = ktime_set(secs, nsecs);
 
 	/* Adjust timestamp for the RX latency based on link speed */
 	switch (adapter->link_speed) {
@@ -201,8 +202,8 @@ void igc_ptp_rx_pktstamp(struct igc_q_vector *q_vector, __le32 *va,
 		netdev_warn_once(adapter->netdev, "Imprecise timestamp\n");
 		break;
 	}
-	skb_hwtstamps(skb)->hwtstamp =
-		ktime_sub_ns(skb_hwtstamps(skb)->hwtstamp, adjust);
+
+	return ktime_sub_ns(timestamp, adjust);
 }
 
 static void igc_ptp_disable_rx_timestamp(struct igc_adapter *adapter)
-- 
2.26.2

