Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34C57130672
	for <lists+netdev@lfdr.de>; Sun,  5 Jan 2020 08:14:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726561AbgAEHOj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jan 2020 02:14:39 -0500
Received: from mga05.intel.com ([192.55.52.43]:54704 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726092AbgAEHOX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 Jan 2020 02:14:23 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Jan 2020 23:14:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,397,1571727600"; 
   d="scan'208";a="302607360"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.74])
  by orsmga001.jf.intel.com with ESMTP; 04 Jan 2020 23:14:21 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 06/15] igc: Remove no need declaration of the igc_set_interrupt_capability
Date:   Sat,  4 Jan 2020 23:14:11 -0800
Message-Id: <20200105071420.3778982-7-jeffrey.t.kirsher@intel.com>
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
Rearrange the igc_set_interrupt_capability function implementation.

Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 142 +++++++++++-----------
 1 file changed, 70 insertions(+), 72 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 4ad06952056b..452e26202c9e 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -57,8 +57,6 @@ static void igc_set_rx_mode(struct net_device *netdev);
 static void igc_write_itr(struct igc_q_vector *q_vector);
 static void igc_assign_vector(struct igc_q_vector *q_vector, int msix_vector);
 static void igc_free_q_vector(struct igc_adapter *adapter, int v_idx);
-static void igc_set_interrupt_capability(struct igc_adapter *adapter,
-					 bool msix);
 static void igc_free_q_vectors(struct igc_adapter *adapter);
 static void igc_irq_disable(struct igc_adapter *adapter);
 static void igc_irq_enable(struct igc_adapter *adapter);
@@ -2998,6 +2996,76 @@ static void igc_reset_interrupt_capability(struct igc_adapter *adapter)
 		igc_reset_q_vector(adapter, v_idx);
 }
 
+/**
+ * igc_set_interrupt_capability - set MSI or MSI-X if supported
+ * @adapter: Pointer to adapter structure
+ * @msix: boolean value for MSI-X capability
+ *
+ * Attempt to configure interrupts using the best available
+ * capabilities of the hardware and kernel.
+ */
+static void igc_set_interrupt_capability(struct igc_adapter *adapter,
+					 bool msix)
+{
+	int numvecs, i;
+	int err;
+
+	if (!msix)
+		goto msi_only;
+	adapter->flags |= IGC_FLAG_HAS_MSIX;
+
+	/* Number of supported queues. */
+	adapter->num_rx_queues = adapter->rss_queues;
+
+	adapter->num_tx_queues = adapter->rss_queues;
+
+	/* start with one vector for every Rx queue */
+	numvecs = adapter->num_rx_queues;
+
+	/* if Tx handler is separate add 1 for every Tx queue */
+	if (!(adapter->flags & IGC_FLAG_QUEUE_PAIRS))
+		numvecs += adapter->num_tx_queues;
+
+	/* store the number of vectors reserved for queues */
+	adapter->num_q_vectors = numvecs;
+
+	/* add 1 vector for link status interrupts */
+	numvecs++;
+
+	adapter->msix_entries = kcalloc(numvecs, sizeof(struct msix_entry),
+					GFP_KERNEL);
+
+	if (!adapter->msix_entries)
+		return;
+
+	/* populate entry values */
+	for (i = 0; i < numvecs; i++)
+		adapter->msix_entries[i].entry = i;
+
+	err = pci_enable_msix_range(adapter->pdev,
+				    adapter->msix_entries,
+				    numvecs,
+				    numvecs);
+	if (err > 0)
+		return;
+
+	kfree(adapter->msix_entries);
+	adapter->msix_entries = NULL;
+
+	igc_reset_interrupt_capability(adapter);
+
+msi_only:
+	adapter->flags &= ~IGC_FLAG_HAS_MSIX;
+
+	adapter->rss_queues = 1;
+	adapter->flags |= IGC_FLAG_QUEUE_PAIRS;
+	adapter->num_rx_queues = 1;
+	adapter->num_tx_queues = 1;
+	adapter->num_q_vectors = 1;
+	if (!pci_enable_msi(adapter->pdev))
+		adapter->flags |= IGC_FLAG_HAS_MSI;
+}
+
 /**
  * igc_clear_interrupt_scheme - reset the device to a state of no interrupts
  * @adapter: Pointer to adapter structure
@@ -3630,76 +3698,6 @@ static int igc_poll(struct napi_struct *napi, int budget)
 	return min(work_done, budget - 1);
 }
 
-/**
- * igc_set_interrupt_capability - set MSI or MSI-X if supported
- * @adapter: Pointer to adapter structure
- * @msix: boolean value for MSI-X capability
- *
- * Attempt to configure interrupts using the best available
- * capabilities of the hardware and kernel.
- */
-static void igc_set_interrupt_capability(struct igc_adapter *adapter,
-					 bool msix)
-{
-	int numvecs, i;
-	int err;
-
-	if (!msix)
-		goto msi_only;
-	adapter->flags |= IGC_FLAG_HAS_MSIX;
-
-	/* Number of supported queues. */
-	adapter->num_rx_queues = adapter->rss_queues;
-
-	adapter->num_tx_queues = adapter->rss_queues;
-
-	/* start with one vector for every Rx queue */
-	numvecs = adapter->num_rx_queues;
-
-	/* if Tx handler is separate add 1 for every Tx queue */
-	if (!(adapter->flags & IGC_FLAG_QUEUE_PAIRS))
-		numvecs += adapter->num_tx_queues;
-
-	/* store the number of vectors reserved for queues */
-	adapter->num_q_vectors = numvecs;
-
-	/* add 1 vector for link status interrupts */
-	numvecs++;
-
-	adapter->msix_entries = kcalloc(numvecs, sizeof(struct msix_entry),
-					GFP_KERNEL);
-
-	if (!adapter->msix_entries)
-		return;
-
-	/* populate entry values */
-	for (i = 0; i < numvecs; i++)
-		adapter->msix_entries[i].entry = i;
-
-	err = pci_enable_msix_range(adapter->pdev,
-				    adapter->msix_entries,
-				    numvecs,
-				    numvecs);
-	if (err > 0)
-		return;
-
-	kfree(adapter->msix_entries);
-	adapter->msix_entries = NULL;
-
-	igc_reset_interrupt_capability(adapter);
-
-msi_only:
-	adapter->flags &= ~IGC_FLAG_HAS_MSIX;
-
-	adapter->rss_queues = 1;
-	adapter->flags |= IGC_FLAG_QUEUE_PAIRS;
-	adapter->num_rx_queues = 1;
-	adapter->num_tx_queues = 1;
-	adapter->num_q_vectors = 1;
-	if (!pci_enable_msi(adapter->pdev))
-		adapter->flags |= IGC_FLAG_HAS_MSI;
-}
-
 static void igc_add_ring(struct igc_ring *ring,
 			 struct igc_ring_container *head)
 {
-- 
2.24.1

