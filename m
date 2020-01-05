Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 382FD13066B
	for <lists+netdev@lfdr.de>; Sun,  5 Jan 2020 08:14:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726446AbgAEHOY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jan 2020 02:14:24 -0500
Received: from mga07.intel.com ([134.134.136.100]:54701 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726373AbgAEHOX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 Jan 2020 02:14:23 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Jan 2020 23:14:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,397,1571727600"; 
   d="scan'208";a="302607381"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.74])
  by orsmga001.jf.intel.com with ESMTP; 04 Jan 2020 23:14:21 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 13/15] igc: Remove no need declaration of the igc_assign_vector
Date:   Sat,  4 Jan 2020 23:14:18 -0800
Message-Id: <20200105071420.3778982-14-jeffrey.t.kirsher@intel.com>
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
Rearrange the igc_assign_vector function implementation.

Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 123 +++++++++++-----------
 1 file changed, 61 insertions(+), 62 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 368e537d1be2..4fb40c6aa583 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -54,7 +54,6 @@ MODULE_DEVICE_TABLE(pci, igc_pci_tbl);
 /* forward declaration */
 static int igc_sw_init(struct igc_adapter *);
 static void igc_write_itr(struct igc_q_vector *q_vector);
-static void igc_assign_vector(struct igc_q_vector *q_vector, int msix_vector);
 
 enum latency_range {
 	lowest_latency = 0,
@@ -2195,6 +2194,67 @@ static void igc_configure(struct igc_adapter *adapter)
 	}
 }
 
+/**
+ * igc_write_ivar - configure ivar for given MSI-X vector
+ * @hw: pointer to the HW structure
+ * @msix_vector: vector number we are allocating to a given ring
+ * @index: row index of IVAR register to write within IVAR table
+ * @offset: column offset of in IVAR, should be multiple of 8
+ *
+ * The IVAR table consists of 2 columns,
+ * each containing an cause allocation for an Rx and Tx ring, and a
+ * variable number of rows depending on the number of queues supported.
+ */
+static void igc_write_ivar(struct igc_hw *hw, int msix_vector,
+			   int index, int offset)
+{
+	u32 ivar = array_rd32(IGC_IVAR0, index);
+
+	/* clear any bits that are currently set */
+	ivar &= ~((u32)0xFF << offset);
+
+	/* write vector and valid bit */
+	ivar |= (msix_vector | IGC_IVAR_VALID) << offset;
+
+	array_wr32(IGC_IVAR0, index, ivar);
+}
+
+static void igc_assign_vector(struct igc_q_vector *q_vector, int msix_vector)
+{
+	struct igc_adapter *adapter = q_vector->adapter;
+	struct igc_hw *hw = &adapter->hw;
+	int rx_queue = IGC_N0_QUEUE;
+	int tx_queue = IGC_N0_QUEUE;
+
+	if (q_vector->rx.ring)
+		rx_queue = q_vector->rx.ring->reg_idx;
+	if (q_vector->tx.ring)
+		tx_queue = q_vector->tx.ring->reg_idx;
+
+	switch (hw->mac.type) {
+	case igc_i225:
+		if (rx_queue > IGC_N0_QUEUE)
+			igc_write_ivar(hw, msix_vector,
+				       rx_queue >> 1,
+				       (rx_queue & 0x1) << 4);
+		if (tx_queue > IGC_N0_QUEUE)
+			igc_write_ivar(hw, msix_vector,
+				       tx_queue >> 1,
+				       ((tx_queue & 0x1) << 4) + 8);
+		q_vector->eims_value = BIT(msix_vector);
+		break;
+	default:
+		WARN_ONCE(hw->mac.type != igc_i225, "Wrong MAC type\n");
+		break;
+	}
+
+	/* add q_vector eims value to global eims_enable_mask */
+	adapter->eims_enable_mask |= q_vector->eims_value;
+
+	/* configure q_vector to set itr on first interrupt */
+	q_vector->set_itr = 1;
+}
+
 /**
  * igc_configure_msix - Configure MSI-X hardware
  * @adapter: Pointer to adapter structure
@@ -2871,67 +2931,6 @@ static irqreturn_t igc_msix_other(int irq, void *data)
 	return IRQ_HANDLED;
 }
 
-/**
- * igc_write_ivar - configure ivar for given MSI-X vector
- * @hw: pointer to the HW structure
- * @msix_vector: vector number we are allocating to a given ring
- * @index: row index of IVAR register to write within IVAR table
- * @offset: column offset of in IVAR, should be multiple of 8
- *
- * The IVAR table consists of 2 columns,
- * each containing an cause allocation for an Rx and Tx ring, and a
- * variable number of rows depending on the number of queues supported.
- */
-static void igc_write_ivar(struct igc_hw *hw, int msix_vector,
-			   int index, int offset)
-{
-	u32 ivar = array_rd32(IGC_IVAR0, index);
-
-	/* clear any bits that are currently set */
-	ivar &= ~((u32)0xFF << offset);
-
-	/* write vector and valid bit */
-	ivar |= (msix_vector | IGC_IVAR_VALID) << offset;
-
-	array_wr32(IGC_IVAR0, index, ivar);
-}
-
-static void igc_assign_vector(struct igc_q_vector *q_vector, int msix_vector)
-{
-	struct igc_adapter *adapter = q_vector->adapter;
-	struct igc_hw *hw = &adapter->hw;
-	int rx_queue = IGC_N0_QUEUE;
-	int tx_queue = IGC_N0_QUEUE;
-
-	if (q_vector->rx.ring)
-		rx_queue = q_vector->rx.ring->reg_idx;
-	if (q_vector->tx.ring)
-		tx_queue = q_vector->tx.ring->reg_idx;
-
-	switch (hw->mac.type) {
-	case igc_i225:
-		if (rx_queue > IGC_N0_QUEUE)
-			igc_write_ivar(hw, msix_vector,
-				       rx_queue >> 1,
-				       (rx_queue & 0x1) << 4);
-		if (tx_queue > IGC_N0_QUEUE)
-			igc_write_ivar(hw, msix_vector,
-				       tx_queue >> 1,
-				       ((tx_queue & 0x1) << 4) + 8);
-		q_vector->eims_value = BIT(msix_vector);
-		break;
-	default:
-		WARN_ONCE(hw->mac.type != igc_i225, "Wrong MAC type\n");
-		break;
-	}
-
-	/* add q_vector eims value to global eims_enable_mask */
-	adapter->eims_enable_mask |= q_vector->eims_value;
-
-	/* configure q_vector to set itr on first interrupt */
-	q_vector->set_itr = 1;
-}
-
 static irqreturn_t igc_msix_ring(int irq, void *data)
 {
 	struct igc_q_vector *q_vector = data;
-- 
2.24.1

