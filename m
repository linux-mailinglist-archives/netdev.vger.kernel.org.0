Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACD5F130677
	for <lists+netdev@lfdr.de>; Sun,  5 Jan 2020 08:14:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726385AbgAEHOp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jan 2020 02:14:45 -0500
Received: from mga07.intel.com ([134.134.136.100]:54701 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725948AbgAEHOX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 Jan 2020 02:14:23 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Jan 2020 23:14:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,397,1571727600"; 
   d="scan'208";a="302607366"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.74])
  by orsmga001.jf.intel.com with ESMTP; 04 Jan 2020 23:14:21 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 08/15] igc: Remove no need declaration of the igc_configure_msix
Date:   Sat,  4 Jan 2020 23:14:13 -0800
Message-Id: <20200105071420.3778982-9-jeffrey.t.kirsher@intel.com>
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
Rearrange the igc_configure_msix function implementation.

Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 89 +++++++++++------------
 1 file changed, 44 insertions(+), 45 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 13491ad7d251..6e35ac5bd2fc 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -59,7 +59,6 @@ static void igc_free_q_vector(struct igc_adapter *adapter, int v_idx);
 static void igc_free_q_vectors(struct igc_adapter *adapter);
 static void igc_irq_disable(struct igc_adapter *adapter);
 static void igc_irq_enable(struct igc_adapter *adapter);
-static void igc_configure_msix(struct igc_adapter *adapter);
 
 enum latency_range {
 	lowest_latency = 0,
@@ -2200,6 +2199,50 @@ static void igc_configure(struct igc_adapter *adapter)
 	}
 }
 
+/**
+ * igc_configure_msix - Configure MSI-X hardware
+ * @adapter: Pointer to adapter structure
+ *
+ * igc_configure_msix sets up the hardware to properly
+ * generate MSI-X interrupts.
+ */
+static void igc_configure_msix(struct igc_adapter *adapter)
+{
+	struct igc_hw *hw = &adapter->hw;
+	int i, vector = 0;
+	u32 tmp;
+
+	adapter->eims_enable_mask = 0;
+
+	/* set vector for other causes, i.e. link changes */
+	switch (hw->mac.type) {
+	case igc_i225:
+		/* Turn on MSI-X capability first, or our settings
+		 * won't stick.  And it will take days to debug.
+		 */
+		wr32(IGC_GPIE, IGC_GPIE_MSIX_MODE |
+		     IGC_GPIE_PBA | IGC_GPIE_EIAME |
+		     IGC_GPIE_NSICR);
+
+		/* enable msix_other interrupt */
+		adapter->eims_other = BIT(vector);
+		tmp = (vector++ | IGC_IVAR_VALID) << 8;
+
+		wr32(IGC_IVAR_MISC, tmp);
+		break;
+	default:
+		/* do nothing, since nothing else supports MSI-X */
+		break;
+	} /* switch (hw->mac.type) */
+
+	adapter->eims_enable_mask |= adapter->eims_other;
+
+	for (i = 0; i < adapter->num_q_vectors; i++)
+		igc_assign_vector(adapter->q_vector[i], vector++);
+
+	wrfl();
+}
+
 /**
  * igc_up - Open the interface and prepare it to handle traffic
  * @adapter: board private structure
@@ -2837,50 +2880,6 @@ static void igc_assign_vector(struct igc_q_vector *q_vector, int msix_vector)
 	q_vector->set_itr = 1;
 }
 
-/**
- * igc_configure_msix - Configure MSI-X hardware
- * @adapter: Pointer to adapter structure
- *
- * igc_configure_msix sets up the hardware to properly
- * generate MSI-X interrupts.
- */
-static void igc_configure_msix(struct igc_adapter *adapter)
-{
-	struct igc_hw *hw = &adapter->hw;
-	int i, vector = 0;
-	u32 tmp;
-
-	adapter->eims_enable_mask = 0;
-
-	/* set vector for other causes, i.e. link changes */
-	switch (hw->mac.type) {
-	case igc_i225:
-		/* Turn on MSI-X capability first, or our settings
-		 * won't stick.  And it will take days to debug.
-		 */
-		wr32(IGC_GPIE, IGC_GPIE_MSIX_MODE |
-		     IGC_GPIE_PBA | IGC_GPIE_EIAME |
-		     IGC_GPIE_NSICR);
-
-		/* enable msix_other interrupt */
-		adapter->eims_other = BIT(vector);
-		tmp = (vector++ | IGC_IVAR_VALID) << 8;
-
-		wr32(IGC_IVAR_MISC, tmp);
-		break;
-	default:
-		/* do nothing, since nothing else supports MSI-X */
-		break;
-	} /* switch (hw->mac.type) */
-
-	adapter->eims_enable_mask |= adapter->eims_other;
-
-	for (i = 0; i < adapter->num_q_vectors; i++)
-		igc_assign_vector(adapter->q_vector[i], vector++);
-
-	wrfl();
-}
-
 static irqreturn_t igc_msix_ring(int irq, void *data)
 {
 	struct igc_q_vector *q_vector = data;
-- 
2.24.1

