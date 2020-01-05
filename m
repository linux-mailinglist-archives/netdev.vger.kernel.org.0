Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDF9D13066A
	for <lists+netdev@lfdr.de>; Sun,  5 Jan 2020 08:14:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726383AbgAEHOX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jan 2020 02:14:23 -0500
Received: from mga05.intel.com ([192.55.52.43]:54704 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725955AbgAEHOW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 Jan 2020 02:14:22 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Jan 2020 23:14:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,397,1571727600"; 
   d="scan'208";a="302607354"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.74])
  by orsmga001.jf.intel.com with ESMTP; 04 Jan 2020 23:14:21 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 04/15] igc: Remove no need declaration of the igc_configure
Date:   Sat,  4 Jan 2020 23:14:09 -0800
Message-Id: <20200105071420.3778982-5-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200105071420.3778982-1-jeffrey.t.kirsher@intel.com>
References: <20200105071420.3778982-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sasha Neftin <sasha.neftin@intel.com>

We want to avoid forward-declarations of function if possible.
Rearrange the igc_configure function implementation.

Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 91 +++++++++++------------
 1 file changed, 45 insertions(+), 46 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 95a62f838668..1023c9226a8e 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -53,7 +53,6 @@ MODULE_DEVICE_TABLE(pci, igc_pci_tbl);
 
 /* forward declaration */
 static int igc_sw_init(struct igc_adapter *);
-static void igc_configure(struct igc_adapter *adapter);
 static void igc_set_rx_mode(struct net_device *netdev);
 static void igc_write_itr(struct igc_q_vector *q_vector);
 static void igc_assign_vector(struct igc_q_vector *q_vector, int msix_vector);
@@ -1985,6 +1984,51 @@ static bool igc_clean_tx_irq(struct igc_q_vector *q_vector, int napi_budget)
 	return !!budget;
 }
 
+static void igc_nfc_filter_restore(struct igc_adapter *adapter)
+{
+	struct igc_nfc_filter *rule;
+
+	spin_lock(&adapter->nfc_lock);
+
+	hlist_for_each_entry(rule, &adapter->nfc_filter_list, nfc_node)
+		igc_add_filter(adapter, rule);
+
+	spin_unlock(&adapter->nfc_lock);
+}
+
+/**
+ * igc_configure - configure the hardware for RX and TX
+ * @adapter: private board structure
+ */
+static void igc_configure(struct igc_adapter *adapter)
+{
+	struct net_device *netdev = adapter->netdev;
+	int i = 0;
+
+	igc_get_hw_control(adapter);
+	igc_set_rx_mode(netdev);
+
+	igc_setup_tctl(adapter);
+	igc_setup_mrqc(adapter);
+	igc_setup_rctl(adapter);
+
+	igc_nfc_filter_restore(adapter);
+	igc_configure_tx(adapter);
+	igc_configure_rx(adapter);
+
+	igc_rx_fifo_flush_base(&adapter->hw);
+
+	/* call igc_desc_unused which always leaves
+	 * at least 1 descriptor unused to make sure
+	 * next_to_use != next_to_clean
+	 */
+	for (i = 0; i < adapter->num_rx_queues; i++) {
+		struct igc_ring *ring = adapter->rx_ring[i];
+
+		igc_alloc_rx_buffers(ring, igc_desc_unused(ring));
+	}
+}
+
 /**
  * igc_up - Open the interface and prepare it to handle traffic
  * @adapter: board private structure
@@ -2206,18 +2250,6 @@ static void igc_nfc_filter_exit(struct igc_adapter *adapter)
 	spin_unlock(&adapter->nfc_lock);
 }
 
-static void igc_nfc_filter_restore(struct igc_adapter *adapter)
-{
-	struct igc_nfc_filter *rule;
-
-	spin_lock(&adapter->nfc_lock);
-
-	hlist_for_each_entry(rule, &adapter->nfc_filter_list, nfc_node)
-		igc_add_filter(adapter, rule);
-
-	spin_unlock(&adapter->nfc_lock);
-}
-
 /**
  * igc_down - Close the interface
  * @adapter: board private structure
@@ -2441,39 +2473,6 @@ igc_features_check(struct sk_buff *skb, struct net_device *dev,
 	return features;
 }
 
-/**
- * igc_configure - configure the hardware for RX and TX
- * @adapter: private board structure
- */
-static void igc_configure(struct igc_adapter *adapter)
-{
-	struct net_device *netdev = adapter->netdev;
-	int i = 0;
-
-	igc_get_hw_control(adapter);
-	igc_set_rx_mode(netdev);
-
-	igc_setup_tctl(adapter);
-	igc_setup_mrqc(adapter);
-	igc_setup_rctl(adapter);
-
-	igc_nfc_filter_restore(adapter);
-	igc_configure_tx(adapter);
-	igc_configure_rx(adapter);
-
-	igc_rx_fifo_flush_base(&adapter->hw);
-
-	/* call igc_desc_unused which always leaves
-	 * at least 1 descriptor unused to make sure
-	 * next_to_use != next_to_clean
-	 */
-	for (i = 0; i < adapter->num_rx_queues; i++) {
-		struct igc_ring *ring = adapter->rx_ring[i];
-
-		igc_alloc_rx_buffers(ring, igc_desc_unused(ring));
-	}
-}
-
 /* If the filter to be added and an already existing filter express
  * the same address and address type, it should be possible to only
  * override the other configurations, for example the queue to steer
-- 
2.24.1

