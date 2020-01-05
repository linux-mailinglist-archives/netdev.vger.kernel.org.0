Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06A9713066F
	for <lists+netdev@lfdr.de>; Sun,  5 Jan 2020 08:14:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726496AbgAEHO1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jan 2020 02:14:27 -0500
Received: from mga07.intel.com ([134.134.136.100]:54701 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726454AbgAEHOZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 Jan 2020 02:14:25 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Jan 2020 23:14:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,397,1571727600"; 
   d="scan'208";a="302607369"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.74])
  by orsmga001.jf.intel.com with ESMTP; 04 Jan 2020 23:14:21 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 09/15] igc: Remove no need declaration of the igc_irq_enable
Date:   Sat,  4 Jan 2020 23:14:14 -0800
Message-Id: <20200105071420.3778982-10-jeffrey.t.kirsher@intel.com>
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
Rearrange the igc_irq_enable function implementation.

Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 47 +++++++++++------------
 1 file changed, 23 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 6e35ac5bd2fc..9597c5753d6b 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -58,7 +58,6 @@ static void igc_assign_vector(struct igc_q_vector *q_vector, int msix_vector);
 static void igc_free_q_vector(struct igc_adapter *adapter, int v_idx);
 static void igc_free_q_vectors(struct igc_adapter *adapter);
 static void igc_irq_disable(struct igc_adapter *adapter);
-static void igc_irq_enable(struct igc_adapter *adapter);
 
 enum latency_range {
 	lowest_latency = 0,
@@ -2243,6 +2242,29 @@ static void igc_configure_msix(struct igc_adapter *adapter)
 	wrfl();
 }
 
+/**
+ * igc_irq_enable - Enable default interrupt generation settings
+ * @adapter: board private structure
+ */
+static void igc_irq_enable(struct igc_adapter *adapter)
+{
+	struct igc_hw *hw = &adapter->hw;
+
+	if (adapter->msix_entries) {
+		u32 ims = IGC_IMS_LSC | IGC_IMS_DOUTSYNC | IGC_IMS_DRSTA;
+		u32 regval = rd32(IGC_EIAC);
+
+		wr32(IGC_EIAC, regval | adapter->eims_enable_mask);
+		regval = rd32(IGC_EIAM);
+		wr32(IGC_EIAM, regval | adapter->eims_enable_mask);
+		wr32(IGC_EIMS, adapter->eims_enable_mask);
+		wr32(IGC_IMS, ims);
+	} else {
+		wr32(IGC_IMS, IMS_ENABLE_MASK | IGC_IMS_DRSTA);
+		wr32(IGC_IAM, IMS_ENABLE_MASK | IGC_IMS_DRSTA);
+	}
+}
+
 /**
  * igc_up - Open the interface and prepare it to handle traffic
  * @adapter: board private structure
@@ -3972,29 +3994,6 @@ static void igc_irq_disable(struct igc_adapter *adapter)
 	}
 }
 
-/**
- * igc_irq_enable - Enable default interrupt generation settings
- * @adapter: board private structure
- */
-static void igc_irq_enable(struct igc_adapter *adapter)
-{
-	struct igc_hw *hw = &adapter->hw;
-
-	if (adapter->msix_entries) {
-		u32 ims = IGC_IMS_LSC | IGC_IMS_DOUTSYNC | IGC_IMS_DRSTA;
-		u32 regval = rd32(IGC_EIAC);
-
-		wr32(IGC_EIAC, regval | adapter->eims_enable_mask);
-		regval = rd32(IGC_EIAM);
-		wr32(IGC_EIAM, regval | adapter->eims_enable_mask);
-		wr32(IGC_EIMS, adapter->eims_enable_mask);
-		wr32(IGC_IMS, ims);
-	} else {
-		wr32(IGC_IMS, IMS_ENABLE_MASK | IGC_IMS_DRSTA);
-		wr32(IGC_IAM, IMS_ENABLE_MASK | IGC_IMS_DRSTA);
-	}
-}
-
 /**
  * igc_request_irq - initialize interrupts
  * @adapter: Pointer to adapter structure
-- 
2.24.1

