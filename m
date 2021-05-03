Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A22EA3711F5
	for <lists+netdev@lfdr.de>; Mon,  3 May 2021 09:28:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232918AbhECH3P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 May 2021 03:29:15 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:45504 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230137AbhECH3O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 May 2021 03:29:14 -0400
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1620026901;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=lnMA+OUmhXXkHcV6xf3HncT31uRT6aehtZ0J5kcXNQM=;
        b=bS90ZGhQIUrklvSXyJ6u/helnbvMKBJCTg/fprbeMoAWwVVlOjB4JskGb2Vm+UJFeIPPi6
        Ay6vDf7ZgG8jKlCo6o9LJFo9ONrmDPpjnExRps9lePDdIWy6MzVAoEdb8oE1ebAdSxKFp0
        NJFCv47ZWAmTCmyDy6Bqj45JkY8PoJfTGYTjRBWBW4+6Mlwh9XAjlYPBetkNg0Va7d8KmZ
        i/WdlJ/N6ZxAc2LxGzlKFHApSc24XXrzplHb+lMgLSakAXFQQ8tYijmyH6fJFAQStL8kIT
        fT4Q0sVxwVSh84938G75W9Euqo1xEIGlJqoJGETaXxwmGHCRXsv45p0xaDsqtA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1620026901;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=lnMA+OUmhXXkHcV6xf3HncT31uRT6aehtZ0J5kcXNQM=;
        b=OhOOP6la9yQ1YKHpRb41rAsqcuYwtaM9a5mLlJyQswVhTawlH+o/sEne4fEHTTnCfiCYHu
        M0gIYgjv02/NHGCA==
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Sven Auhagen <sven.auhagen@voleatech.de>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Tyler S <tylerjstachecki@gmail.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: [PATCH net v4] igb: Fix XDP with PTP enabled
Date:   Mon,  3 May 2021 09:28:00 +0200
Message-Id: <20210503072800.79936-1-kurt@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When using native XDP with the igb driver, the XDP frame data doesn't point to
the beginning of the packet. It's off by 16 bytes. Everything works as expected
with XDP skb mode.

Actually these 16 bytes are used to store the packet timestamps. Therefore, pull
the timestamp before executing any XDP operations and adjust all other code
accordingly. The igc driver does it like that as well.

Tested with Intel i210 card and AF_XDP sockets.

Fixes: 9cbc948b5a20 ("igb: add XDP support")
Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
---

Changes since v3:

 * Get rid of timestamp check in hot path (Maciej Fijalkowski)

Changes since v2:

 * Check timestamp for validity (Nguyen, Anthony L)

Changes since v1:

 * Use xdp_prepare_buff() (Lorenzo Bianconi)

Changes since RFC:

 * Removed unused return value definitions (Alexander Duyck)

Previous versions:

 * https://lkml.kernel.org/netdev/20210422052617.17267-1-kurt@linutronix.de/
 * https://lkml.kernel.org/netdev/20210419072332.7246-1-kurt@linutronix.de/
 * https://lkml.kernel.org/netdev/20210415092145.27322-1-kurt@linutronix.de/
 * https://lkml.kernel.org/netdev/20210412101713.15161-1-kurt@linutronix.de/

 drivers/net/ethernet/intel/igb/igb.h      |  2 +-
 drivers/net/ethernet/intel/igb/igb_main.c | 45 +++++++++++++----------
 drivers/net/ethernet/intel/igb/igb_ptp.c  | 23 +++++-------
 3 files changed, 37 insertions(+), 33 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/igb.h b/drivers/net/ethernet/intel/igb/igb.h
index 7bda8c5edea5..2d3daf022651 100644
--- a/drivers/net/ethernet/intel/igb/igb.h
+++ b/drivers/net/ethernet/intel/igb/igb.h
@@ -749,7 +749,7 @@ void igb_ptp_rx_hang(struct igb_adapter *adapter);
 void igb_ptp_tx_hang(struct igb_adapter *adapter);
 void igb_ptp_rx_rgtstamp(struct igb_q_vector *q_vector, struct sk_buff *skb);
 int igb_ptp_rx_pktstamp(struct igb_q_vector *q_vector, void *va,
-			struct sk_buff *skb);
+			ktime_t *timestamp);
 int igb_ptp_set_ts_config(struct net_device *netdev, struct ifreq *ifr);
 int igb_ptp_get_ts_config(struct net_device *netdev, struct ifreq *ifr);
 void igb_set_flag_queue_pairs(struct igb_adapter *, const u32);
diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 038a9fd1af44..0123285029fa 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -8280,7 +8280,7 @@ static void igb_add_rx_frag(struct igb_ring *rx_ring,
 static struct sk_buff *igb_construct_skb(struct igb_ring *rx_ring,
 					 struct igb_rx_buffer *rx_buffer,
 					 struct xdp_buff *xdp,
-					 union e1000_adv_rx_desc *rx_desc)
+					 ktime_t timestamp)
 {
 #if (PAGE_SIZE < 8192)
 	unsigned int truesize = igb_rx_pg_size(rx_ring) / 2;
@@ -8300,12 +8300,8 @@ static struct sk_buff *igb_construct_skb(struct igb_ring *rx_ring,
 	if (unlikely(!skb))
 		return NULL;
 
-	if (unlikely(igb_test_staterr(rx_desc, E1000_RXDADV_STAT_TSIP))) {
-		if (!igb_ptp_rx_pktstamp(rx_ring->q_vector, xdp->data, skb)) {
-			xdp->data += IGB_TS_HDR_LEN;
-			size -= IGB_TS_HDR_LEN;
-		}
-	}
+	if (timestamp)
+		skb_hwtstamps(skb)->hwtstamp = timestamp;
 
 	/* Determine available headroom for copy */
 	headlen = size;
@@ -8336,7 +8332,7 @@ static struct sk_buff *igb_construct_skb(struct igb_ring *rx_ring,
 static struct sk_buff *igb_build_skb(struct igb_ring *rx_ring,
 				     struct igb_rx_buffer *rx_buffer,
 				     struct xdp_buff *xdp,
-				     union e1000_adv_rx_desc *rx_desc)
+				     ktime_t timestamp)
 {
 #if (PAGE_SIZE < 8192)
 	unsigned int truesize = igb_rx_pg_size(rx_ring) / 2;
@@ -8363,11 +8359,8 @@ static struct sk_buff *igb_build_skb(struct igb_ring *rx_ring,
 	if (metasize)
 		skb_metadata_set(skb, metasize);
 
-	/* pull timestamp out of packet data */
-	if (igb_test_staterr(rx_desc, E1000_RXDADV_STAT_TSIP)) {
-		if (!igb_ptp_rx_pktstamp(rx_ring->q_vector, skb->data, skb))
-			__skb_pull(skb, IGB_TS_HDR_LEN);
-	}
+	if (timestamp)
+		skb_hwtstamps(skb)->hwtstamp = timestamp;
 
 	/* update buffer offset */
 #if (PAGE_SIZE < 8192)
@@ -8682,7 +8675,10 @@ static int igb_clean_rx_irq(struct igb_q_vector *q_vector, const int budget)
 	while (likely(total_packets < budget)) {
 		union e1000_adv_rx_desc *rx_desc;
 		struct igb_rx_buffer *rx_buffer;
+		ktime_t timestamp = 0;
+		int pkt_offset = 0;
 		unsigned int size;
+		void *pktbuf;
 
 		/* return some buffers to hardware, one at a time is too slow */
 		if (cleaned_count >= IGB_RX_BUFFER_WRITE) {
@@ -8702,14 +8698,24 @@ static int igb_clean_rx_irq(struct igb_q_vector *q_vector, const int budget)
 		dma_rmb();
 
 		rx_buffer = igb_get_rx_buffer(rx_ring, size, &rx_buf_pgcnt);
+		pktbuf = page_address(rx_buffer->page) + rx_buffer->page_offset;
+
+		/* pull rx packet timestamp if available and valid */
+		if (igb_test_staterr(rx_desc, E1000_RXDADV_STAT_TSIP)) {
+			int ts_hdr_len;
+
+			ts_hdr_len = igb_ptp_rx_pktstamp(rx_ring->q_vector,
+							 pktbuf, &timestamp);
+
+			pkt_offset += ts_hdr_len;
+			size -= ts_hdr_len;
+		}
 
 		/* retrieve a buffer from the ring */
 		if (!skb) {
-			unsigned int offset = igb_rx_offset(rx_ring);
-			unsigned char *hard_start;
+			unsigned char *hard_start = pktbuf - igb_rx_offset(rx_ring);
+			unsigned int offset = pkt_offset + igb_rx_offset(rx_ring);
 
-			hard_start = page_address(rx_buffer->page) +
-				     rx_buffer->page_offset - offset;
 			xdp_prepare_buff(&xdp, hard_start, offset, size, true);
 #if (PAGE_SIZE > 4096)
 			/* At larger PAGE_SIZE, frame_sz depend on len size */
@@ -8732,10 +8738,11 @@ static int igb_clean_rx_irq(struct igb_q_vector *q_vector, const int budget)
 		} else if (skb)
 			igb_add_rx_frag(rx_ring, rx_buffer, skb, size);
 		else if (ring_uses_build_skb(rx_ring))
-			skb = igb_build_skb(rx_ring, rx_buffer, &xdp, rx_desc);
+			skb = igb_build_skb(rx_ring, rx_buffer, &xdp,
+					    timestamp);
 		else
 			skb = igb_construct_skb(rx_ring, rx_buffer,
-						&xdp, rx_desc);
+						&xdp, timestamp);
 
 		/* exit if we failed to retrieve a buffer */
 		if (!skb) {
diff --git a/drivers/net/ethernet/intel/igb/igb_ptp.c b/drivers/net/ethernet/intel/igb/igb_ptp.c
index ba61fe9bfaf4..d68cd4466a54 100644
--- a/drivers/net/ethernet/intel/igb/igb_ptp.c
+++ b/drivers/net/ethernet/intel/igb/igb_ptp.c
@@ -856,30 +856,28 @@ static void igb_ptp_tx_hwtstamp(struct igb_adapter *adapter)
 	dev_kfree_skb_any(skb);
 }
 
-#define IGB_RET_PTP_DISABLED 1
-#define IGB_RET_PTP_INVALID 2
-
 /**
  * igb_ptp_rx_pktstamp - retrieve Rx per packet timestamp
  * @q_vector: Pointer to interrupt specific structure
  * @va: Pointer to address containing Rx buffer
- * @skb: Buffer containing timestamp and packet
+ * @timestamp: Pointer where timestamp will be stored
  *
  * This function is meant to retrieve a timestamp from the first buffer of an
  * incoming frame.  The value is stored in little endian format starting on
  * byte 8
  *
- * Returns: 0 if success, nonzero if failure
+ * Returns: The timestamp header length or 0 if not available
  **/
 int igb_ptp_rx_pktstamp(struct igb_q_vector *q_vector, void *va,
-			struct sk_buff *skb)
+			ktime_t *timestamp)
 {
 	struct igb_adapter *adapter = q_vector->adapter;
+	struct skb_shared_hwtstamps ts;
 	__le64 *regval = (__le64 *)va;
 	int adjust = 0;
 
 	if (!(adapter->ptp_flags & IGB_PTP_ENABLED))
-		return IGB_RET_PTP_DISABLED;
+		return 0;
 
 	/* The timestamp is recorded in little endian format.
 	 * DWORD: 0        1        2        3
@@ -888,10 +886,9 @@ int igb_ptp_rx_pktstamp(struct igb_q_vector *q_vector, void *va,
 
 	/* check reserved dwords are zero, be/le doesn't matter for zero */
 	if (regval[0])
-		return IGB_RET_PTP_INVALID;
+		return 0;
 
-	igb_ptp_systim_to_hwtstamp(adapter, skb_hwtstamps(skb),
-				   le64_to_cpu(regval[1]));
+	igb_ptp_systim_to_hwtstamp(adapter, &ts, le64_to_cpu(regval[1]));
 
 	/* adjust timestamp for the RX latency based on link speed */
 	if (adapter->hw.mac.type == e1000_i210) {
@@ -907,10 +904,10 @@ int igb_ptp_rx_pktstamp(struct igb_q_vector *q_vector, void *va,
 			break;
 		}
 	}
-	skb_hwtstamps(skb)->hwtstamp =
-		ktime_sub_ns(skb_hwtstamps(skb)->hwtstamp, adjust);
 
-	return 0;
+	*timestamp = ktime_sub_ns(ts.hwtstamp, adjust);
+
+	return IGB_TS_HDR_LEN;
 }
 
 /**
-- 
2.30.2

