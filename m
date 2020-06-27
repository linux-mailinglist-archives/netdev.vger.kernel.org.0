Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6465A20BDA4
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 03:54:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726584AbgF0Byt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 21:54:49 -0400
Received: from mga03.intel.com ([134.134.136.65]:29248 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726557AbgF0Byp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Jun 2020 21:54:45 -0400
IronPort-SDR: hHyTA8k6RZquJxDDz/EnQn2c5m2OdpBm/qLSmCswemSOL+Fq65i3THosrd9NglUVjrKOCf0USO
 KHovTTl2fsMQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9664"; a="145588585"
X-IronPort-AV: E=Sophos;i="5.75,285,1589266800"; 
   d="scan'208";a="145588585"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2020 18:54:37 -0700
IronPort-SDR: w9EuZ4Mg4Jb8CLgi1Cu4GmC1HNCc7/6kvyHYNhQ5bMdcix3aVlLrvm7j19MWRK4OUSD8+bSZoE
 9+AZU+gUic8Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,285,1589266800"; 
   d="scan'208";a="312495120"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga002.fm.intel.com with ESMTP; 26 Jun 2020 18:54:37 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Andre Guedes <andre.guedes@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 08/13] igc: Fix Rx timestamp disabling
Date:   Fri, 26 Jun 2020 18:54:26 -0700
Message-Id: <20200627015431.3579234-9-jeffrey.t.kirsher@intel.com>
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

When Rx timestamping is enabled, we set the timestamp bit in SRRCTL
register for each queue, but we don't clear it when disabling. This
patch fixes igc_ptp_disable_rx_timestamp() accordingly.

Also, this patch gets rid of igc_ptp_enable_tstamp_rxqueue() and
igc_ptp_enable_tstamp_all_rxqueues() and move their logic into
igc_ptp_enable_rx_timestamp() to keep the enable and disable
helpers symmetric.

Signed-off-by: Andre Guedes <andre.guedes@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_ptp.c | 54 ++++++++----------------
 1 file changed, 17 insertions(+), 37 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_ptp.c b/drivers/net/ethernet/intel/igc/igc_ptp.c
index 0251e6bedac4..e67d4655b47e 100644
--- a/drivers/net/ethernet/intel/igc/igc_ptp.c
+++ b/drivers/net/ethernet/intel/igc/igc_ptp.c
@@ -205,47 +205,20 @@ void igc_ptp_rx_pktstamp(struct igc_q_vector *q_vector, void *va,
 		ktime_sub_ns(skb_hwtstamps(skb)->hwtstamp, adjust);
 }
 
-/**
- * igc_ptp_enable_tstamp_rxqueue - Enable RX timestamp for a queue
- * @rx_ring: Pointer to RX queue
- * @timer: Index for timer
- *
- * This function enables RX timestamping for a queue, and selects
- * which 1588 timer will provide the timestamp.
- */
-static void igc_ptp_enable_tstamp_rxqueue(struct igc_adapter *adapter,
-					  struct igc_ring *rx_ring, u8 timer)
-{
-	struct igc_hw *hw = &adapter->hw;
-	int reg_idx = rx_ring->reg_idx;
-	u32 srrctl = rd32(IGC_SRRCTL(reg_idx));
-
-	srrctl |= IGC_SRRCTL_TIMESTAMP;
-	srrctl |= IGC_SRRCTL_TIMER1SEL(timer);
-	srrctl |= IGC_SRRCTL_TIMER0SEL(timer);
-
-	wr32(IGC_SRRCTL(reg_idx), srrctl);
-}
-
-static void igc_ptp_enable_tstamp_all_rxqueues(struct igc_adapter *adapter,
-					       u8 timer)
-{
-	int i;
-
-	for (i = 0; i < adapter->num_rx_queues; i++) {
-		struct igc_ring *ring = adapter->rx_ring[i];
-
-		igc_ptp_enable_tstamp_rxqueue(adapter, ring, timer);
-	}
-}
-
 static void igc_ptp_disable_rx_timestamp(struct igc_adapter *adapter)
 {
 	struct igc_hw *hw = &adapter->hw;
 	u32 val;
+	int i;
 
 	wr32(IGC_TSYNCRXCTL, 0);
 
+	for (i = 0; i < adapter->num_rx_queues; i++) {
+		val = rd32(IGC_SRRCTL(i));
+		val &= ~IGC_SRRCTL_TIMESTAMP;
+		wr32(IGC_SRRCTL(i), val);
+	}
+
 	val = rd32(IGC_RXPBS);
 	val &= ~IGC_RXPBS_CFG_TS_EN;
 	wr32(IGC_RXPBS, val);
@@ -255,14 +228,21 @@ static void igc_ptp_enable_rx_timestamp(struct igc_adapter *adapter)
 {
 	struct igc_hw *hw = &adapter->hw;
 	u32 val;
+	int i;
 
 	val = rd32(IGC_RXPBS);
 	val |= IGC_RXPBS_CFG_TS_EN;
 	wr32(IGC_RXPBS, val);
 
-	/* FIXME: For now, only support retrieving RX timestamps from timer 0
-	 */
-	igc_ptp_enable_tstamp_all_rxqueues(adapter, 0);
+	for (i = 0; i < adapter->num_rx_queues; i++) {
+		val = rd32(IGC_SRRCTL(i));
+		/* FIXME: For now, only support retrieving RX timestamps from
+		 * timer 0.
+		 */
+		val |= IGC_SRRCTL_TIMER1SEL(0) | IGC_SRRCTL_TIMER0SEL(0) |
+		       IGC_SRRCTL_TIMESTAMP;
+		wr32(IGC_SRRCTL(i), val);
+	}
 
 	val = IGC_TSYNCRXCTL_ENABLED | IGC_TSYNCRXCTL_TYPE_ALL |
 	      IGC_TSYNCRXCTL_RXSYNSIG;
-- 
2.26.2

