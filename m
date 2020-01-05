Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54BDE13067A
	for <lists+netdev@lfdr.de>; Sun,  5 Jan 2020 08:14:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726735AbgAEHOw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jan 2020 02:14:52 -0500
Received: from mga05.intel.com ([192.55.52.43]:54704 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725785AbgAEHOW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 Jan 2020 02:14:22 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Jan 2020 23:14:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,397,1571727600"; 
   d="scan'208";a="302607344"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.74])
  by orsmga001.jf.intel.com with ESMTP; 04 Jan 2020 23:14:20 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 01/15] igc: Remove no need declaration of the igc_clean_tx_ring
Date:   Sat,  4 Jan 2020 23:14:06 -0800
Message-Id: <20200105071420.3778982-2-jeffrey.t.kirsher@intel.com>
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
Rearrange the igc_clean_tx_ring function implementation.

Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 75 +++++++++++------------
 1 file changed, 37 insertions(+), 38 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 25989c087aca..c156cd68532b 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -52,7 +52,6 @@ static const struct pci_device_id igc_pci_tbl[] = {
 MODULE_DEVICE_TABLE(pci, igc_pci_tbl);
 
 /* forward declaration */
-static void igc_clean_tx_ring(struct igc_ring *tx_ring);
 static int igc_sw_init(struct igc_adapter *);
 static void igc_configure(struct igc_adapter *adapter);
 static void igc_power_down_link(struct igc_adapter *adapter);
@@ -176,43 +175,6 @@ static void igc_get_hw_control(struct igc_adapter *adapter)
 	     ctrl_ext | IGC_CTRL_EXT_DRV_LOAD);
 }
 
-/**
- * igc_free_tx_resources - Free Tx Resources per Queue
- * @tx_ring: Tx descriptor ring for a specific queue
- *
- * Free all transmit software resources
- */
-void igc_free_tx_resources(struct igc_ring *tx_ring)
-{
-	igc_clean_tx_ring(tx_ring);
-
-	vfree(tx_ring->tx_buffer_info);
-	tx_ring->tx_buffer_info = NULL;
-
-	/* if not set, then don't free */
-	if (!tx_ring->desc)
-		return;
-
-	dma_free_coherent(tx_ring->dev, tx_ring->size,
-			  tx_ring->desc, tx_ring->dma);
-
-	tx_ring->desc = NULL;
-}
-
-/**
- * igc_free_all_tx_resources - Free Tx Resources for All Queues
- * @adapter: board private structure
- *
- * Free all transmit software resources
- */
-static void igc_free_all_tx_resources(struct igc_adapter *adapter)
-{
-	int i;
-
-	for (i = 0; i < adapter->num_tx_queues; i++)
-		igc_free_tx_resources(adapter->tx_ring[i]);
-}
-
 /**
  * igc_clean_tx_ring - Free Tx Buffers
  * @tx_ring: ring to be cleaned
@@ -274,6 +236,43 @@ static void igc_clean_tx_ring(struct igc_ring *tx_ring)
 	tx_ring->next_to_clean = 0;
 }
 
+/**
+ * igc_free_tx_resources - Free Tx Resources per Queue
+ * @tx_ring: Tx descriptor ring for a specific queue
+ *
+ * Free all transmit software resources
+ */
+void igc_free_tx_resources(struct igc_ring *tx_ring)
+{
+	igc_clean_tx_ring(tx_ring);
+
+	vfree(tx_ring->tx_buffer_info);
+	tx_ring->tx_buffer_info = NULL;
+
+	/* if not set, then don't free */
+	if (!tx_ring->desc)
+		return;
+
+	dma_free_coherent(tx_ring->dev, tx_ring->size,
+			  tx_ring->desc, tx_ring->dma);
+
+	tx_ring->desc = NULL;
+}
+
+/**
+ * igc_free_all_tx_resources - Free Tx Resources for All Queues
+ * @adapter: board private structure
+ *
+ * Free all transmit software resources
+ */
+static void igc_free_all_tx_resources(struct igc_adapter *adapter)
+{
+	int i;
+
+	for (i = 0; i < adapter->num_tx_queues; i++)
+		igc_free_tx_resources(adapter->tx_ring[i]);
+}
+
 /**
  * igc_clean_all_tx_rings - Free Tx Buffers for all queues
  * @adapter: board private structure
-- 
2.24.1

