Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DF3339FB9B
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 18:02:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232583AbhFHQD7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 12:03:59 -0400
Received: from smtp-fw-80007.amazon.com ([99.78.197.218]:33295 "EHLO
        smtp-fw-80007.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231243AbhFHQD6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 12:03:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1623168127; x=1654704127;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=eyOYJTyHJEJ2g/36bhQnszyLY2yAjadg60+Hx7DvfCo=;
  b=hliziEmYnK/jB0lWK3G0oV5aIvKuRF3MMrERq85kCpOW7rqTFSyuE8HP
   TBtIOOgvJOGMpVHIrDQBRXBxwB/fbz4ISEAD4/q5hIC1seLJ8n1y3f/d8
   wfFHpuG3rGZYbWjV0xMGJdBx2nvb06mLK57qyNrEJS3FuBLyRns2FXxSj
   c=;
X-IronPort-AV: E=Sophos;i="5.83,258,1616457600"; 
   d="scan'208";a="5541877"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-2a-119b4f96.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP; 08 Jun 2021 16:02:00 +0000
Received: from EX13D28EUC001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2a-119b4f96.us-west-2.amazon.com (Postfix) with ESMTPS id B25F41A200A;
        Tue,  8 Jun 2021 16:01:58 +0000 (UTC)
Received: from u570694869fb251.ant.amazon.com (10.43.162.147) by
 EX13D28EUC001.ant.amazon.com (10.43.164.4) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Tue, 8 Jun 2021 16:01:50 +0000
From:   Shay Agroskin <shayagr@amazon.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     Shay Agroskin <shayagr@amazon.com>,
        "Woodhouse, David" <dwmw@amazon.com>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        Saeed Bshara <saeedb@amazon.com>,
        "Wilson, Matt" <msw@amazon.com>,
        "Liguori, Anthony" <aliguori@amazon.com>,
        "Bshara, Nafea" <nafea@amazon.com>,
        "Belgazal, Netanel" <netanel@amazon.com>,
        "Saidi, Ali" <alisaidi@amazon.com>,
        "Herrenschmidt, Benjamin" <benh@amazon.com>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>,
        "Dagan, Noam" <ndagan@amazon.com>,
        Sameeh Jubran <sameehj@amazon.com>
Subject: [Patch v1 net-next 01/10] net: ena: optimize data access in fast-path code
Date:   Tue, 8 Jun 2021 19:01:09 +0300
Message-ID: <20210608160118.3767932-2-shayagr@amazon.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210608160118.3767932-1-shayagr@amazon.com>
References: <20210608160118.3767932-1-shayagr@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.147]
X-ClientProxiedBy: EX13D24UWA004.ant.amazon.com (10.43.160.233) To
 EX13D28EUC001.ant.amazon.com (10.43.164.4)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This tweaks several small places to improve the data access in fast
path:

* Remove duplicates of first_interrupt flag and surround it with
  WRITE/READ_ONCE macros:

  The flag is used to detect HW disorders in its
  interrupt communication with the driver. The flag is set when an
  interrupt is received and used in the health check function
  (ena_timer_service()) to help it find irregularities.

* Reorder some fields in ena_napi struct to take better advantage of
  cache access pattern.

* Move XDP TX queue number to a variable to save its calculation for
  every packet.

* Use likely in a condition to improve branch prediction

The 'first_interrupt' and 'interrupt_masked' flags were moved to reside
in the same cache line as the first fields of 'napi' struct. This
placement ensures that all memory accessed during upper-half handler
reside in the same cacheline (napi_schedule_irqoff() only accesses
'state' and 'poll_list' fields which are at the beginning of napi
struct).

Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
Signed-off-by: Shay Agroskin <shayagr@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_eth_com.c |  2 +-
 drivers/net/ethernet/amazon/ena/ena_netdev.c  | 23 +++++++++----------
 drivers/net/ethernet/amazon/ena/ena_netdev.h  | 11 +++++----
 3 files changed, 19 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_eth_com.c b/drivers/net/ethernet/amazon/ena/ena_eth_com.c
index c3be751e7379..2aecd4c3de59 100644
--- a/drivers/net/ethernet/amazon/ena/ena_eth_com.c
+++ b/drivers/net/ethernet/amazon/ena/ena_eth_com.c
@@ -151,7 +151,7 @@ static int ena_com_close_bounce_buffer(struct ena_com_io_sq *io_sq)
 		return 0;
 
 	/* bounce buffer was used, so write it and get a new one */
-	if (pkt_ctrl->idx) {
+	if (likely(pkt_ctrl->idx)) {
 		rc = ena_com_write_bounce_buffer_to_dev(io_sq,
 							pkt_ctrl->curr_bounce_buf);
 		if (unlikely(rc))
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 881f88754bf6..b613067a06d8 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -197,7 +197,6 @@ static int ena_xdp_io_poll(struct napi_struct *napi, int budget)
 	int ret;
 
 	xdp_ring = ena_napi->xdp_ring;
-	xdp_ring->first_interrupt = ena_napi->first_interrupt;
 
 	xdp_budget = budget;
 
@@ -383,7 +382,6 @@ static int ena_xdp_execute(struct ena_ring *rx_ring, struct xdp_buff *xdp)
 	u32 verdict = XDP_PASS;
 	struct xdp_frame *xdpf;
 	u64 *xdp_stat;
-	int qid;
 
 	rcu_read_lock();
 	xdp_prog = READ_ONCE(rx_ring->xdp_bpf_prog);
@@ -404,8 +402,7 @@ static int ena_xdp_execute(struct ena_ring *rx_ring, struct xdp_buff *xdp)
 		}
 
 		/* Find xmit queue */
-		qid = rx_ring->qid + rx_ring->adapter->num_io_queues;
-		xdp_ring = &rx_ring->adapter->tx_ring[qid];
+		xdp_ring = rx_ring->xdp_ring;
 
 		/* The XDP queues are shared between XDP_TX and XDP_REDIRECT */
 		spin_lock(&xdp_ring->xdp_tx_lock);
@@ -681,7 +678,6 @@ static void ena_init_io_rings_common(struct ena_adapter *adapter,
 	ring->ena_dev = adapter->ena_dev;
 	ring->per_napi_packets = 0;
 	ring->cpu = 0;
-	ring->first_interrupt = false;
 	ring->no_interrupt_event_cnt = 0;
 	u64_stats_init(&ring->syncp);
 }
@@ -725,6 +721,7 @@ static void ena_init_io_rings(struct ena_adapter *adapter,
 				ena_com_get_nonadaptive_moderation_interval_rx(ena_dev);
 			rxr->empty_rx_queue = 0;
 			adapter->ena_napi[i].dim.mode = DIM_CQ_PERIOD_MODE_START_FROM_EQE;
+			rxr->xdp_ring = &adapter->tx_ring[i + adapter->num_io_queues];
 		}
 	}
 }
@@ -1922,9 +1919,6 @@ static int ena_io_poll(struct napi_struct *napi, int budget)
 	tx_ring = ena_napi->tx_ring;
 	rx_ring = ena_napi->rx_ring;
 
-	tx_ring->first_interrupt = ena_napi->first_interrupt;
-	rx_ring->first_interrupt = ena_napi->first_interrupt;
-
 	tx_budget = tx_ring->ring_size / ENA_TX_POLL_BUDGET_DIVIDER;
 
 	if (!test_bit(ENA_FLAG_DEV_UP, &tx_ring->adapter->flags) ||
@@ -2003,7 +1997,8 @@ static irqreturn_t ena_intr_msix_io(int irq, void *data)
 {
 	struct ena_napi *ena_napi = data;
 
-	ena_napi->first_interrupt = true;
+	/* Used to check HW health */
+	WRITE_ONCE(ena_napi->first_interrupt, true);
 
 	WRITE_ONCE(ena_napi->interrupts_masked, true);
 	smp_wmb(); /* write interrupts_masked before calling napi */
@@ -3657,7 +3652,9 @@ static void ena_fw_reset_device(struct work_struct *work)
 static int check_for_rx_interrupt_queue(struct ena_adapter *adapter,
 					struct ena_ring *rx_ring)
 {
-	if (likely(rx_ring->first_interrupt))
+	struct ena_napi *ena_napi = container_of(rx_ring->napi, struct ena_napi, napi);
+
+	if (likely(READ_ONCE(ena_napi->first_interrupt)))
 		return 0;
 
 	if (ena_com_cq_empty(rx_ring->ena_com_io_cq))
@@ -3681,6 +3678,7 @@ static int check_for_rx_interrupt_queue(struct ena_adapter *adapter,
 static int check_missing_comp_in_tx_queue(struct ena_adapter *adapter,
 					  struct ena_ring *tx_ring)
 {
+	struct ena_napi *ena_napi = container_of(tx_ring->napi, struct ena_napi, napi);
 	struct ena_tx_buffer *tx_buf;
 	unsigned long last_jiffies;
 	u32 missed_tx = 0;
@@ -3694,8 +3692,9 @@ static int check_missing_comp_in_tx_queue(struct ena_adapter *adapter,
 			/* no pending Tx at this location */
 			continue;
 
-		if (unlikely(!tx_ring->first_interrupt && time_is_before_jiffies(last_jiffies +
-			     2 * adapter->missing_tx_completion_to))) {
+		if (unlikely(!READ_ONCE(ena_napi->first_interrupt) &&
+			time_is_before_jiffies(last_jiffies + 2 *
+				adapter->missing_tx_completion_to))) {
 			/* If after graceful period interrupt is still not
 			 * received, we schedule a reset
 			 */
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.h b/drivers/net/ethernet/amazon/ena/ena_netdev.h
index 74af15d62ee1..21758707a929 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.h
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.h
@@ -135,12 +135,12 @@ struct ena_irq {
 };
 
 struct ena_napi {
-	struct napi_struct napi ____cacheline_aligned;
+	u8 first_interrupt ____cacheline_aligned;
+	u8 interrupts_masked;
+	struct napi_struct napi;
 	struct ena_ring *tx_ring;
 	struct ena_ring *rx_ring;
 	struct ena_ring *xdp_ring;
-	bool first_interrupt;
-	bool interrupts_masked;
 	u32 qid;
 	struct dim dim;
 };
@@ -259,6 +259,10 @@ struct ena_ring {
 	struct bpf_prog *xdp_bpf_prog;
 	struct xdp_rxq_info xdp_rxq;
 	spinlock_t xdp_tx_lock;	/* synchronize XDP TX/Redirect traffic */
+	/* Used for rx queues only to point to the xdp tx ring, to
+	 * which traffic should be redirected from this rx ring.
+	 */
+	struct ena_ring *xdp_ring;
 
 	u16 next_to_use;
 	u16 next_to_clean;
@@ -271,7 +275,6 @@ struct ena_ring {
 	/* The maximum header length the device can handle */
 	u8 tx_max_header_size;
 
-	bool first_interrupt;
 	bool disable_meta_caching;
 	u16 no_interrupt_event_cnt;
 
-- 
2.25.1

