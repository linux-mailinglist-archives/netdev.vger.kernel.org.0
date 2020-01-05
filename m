Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A761313066C
	for <lists+netdev@lfdr.de>; Sun,  5 Jan 2020 08:14:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726484AbgAEHOZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jan 2020 02:14:25 -0500
Received: from mga07.intel.com ([134.134.136.100]:54701 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726373AbgAEHOZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 Jan 2020 02:14:25 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Jan 2020 23:14:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,397,1571727600"; 
   d="scan'208";a="302607378"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.74])
  by orsmga001.jf.intel.com with ESMTP; 04 Jan 2020 23:14:21 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 12/15] igc: Remove no need declaration of the igc_free_q_vector
Date:   Sat,  4 Jan 2020 23:14:17 -0800
Message-Id: <20200105071420.3778982-13-jeffrey.t.kirsher@intel.com>
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
Rearrange the igc_free_q_vector function implementation.

Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 41 +++++++++++------------
 1 file changed, 20 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 58347135b0fc..368e537d1be2 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -55,7 +55,6 @@ MODULE_DEVICE_TABLE(pci, igc_pci_tbl);
 static int igc_sw_init(struct igc_adapter *);
 static void igc_write_itr(struct igc_q_vector *q_vector);
 static void igc_assign_vector(struct igc_q_vector *q_vector, int msix_vector);
-static void igc_free_q_vector(struct igc_adapter *adapter, int v_idx);
 
 enum latency_range {
 	lowest_latency = 0,
@@ -3117,6 +3116,26 @@ static void igc_set_interrupt_capability(struct igc_adapter *adapter,
 		adapter->flags |= IGC_FLAG_HAS_MSI;
 }
 
+/**
+ * igc_free_q_vector - Free memory allocated for specific interrupt vector
+ * @adapter: board private structure to initialize
+ * @v_idx: Index of vector to be freed
+ *
+ * This function frees the memory allocated to the q_vector.
+ */
+static void igc_free_q_vector(struct igc_adapter *adapter, int v_idx)
+{
+	struct igc_q_vector *q_vector = adapter->q_vector[v_idx];
+
+	adapter->q_vector[v_idx] = NULL;
+
+	/* igc_get_stats64() might access the rings on this vector,
+	 * we must wait a grace period before freeing it.
+	 */
+	if (q_vector)
+		kfree_rcu(q_vector, rcu);
+}
+
 /**
  * igc_free_q_vectors - Free memory allocated for interrupt vectors
  * @adapter: board private structure to initialize
@@ -3152,26 +3171,6 @@ static void igc_clear_interrupt_scheme(struct igc_adapter *adapter)
 	igc_reset_interrupt_capability(adapter);
 }
 
-/**
- * igc_free_q_vector - Free memory allocated for specific interrupt vector
- * @adapter: board private structure to initialize
- * @v_idx: Index of vector to be freed
- *
- * This function frees the memory allocated to the q_vector.
- */
-static void igc_free_q_vector(struct igc_adapter *adapter, int v_idx)
-{
-	struct igc_q_vector *q_vector = adapter->q_vector[v_idx];
-
-	adapter->q_vector[v_idx] = NULL;
-
-	/* igc_get_stats64() might access the rings on this vector,
-	 * we must wait a grace period before freeing it.
-	 */
-	if (q_vector)
-		kfree_rcu(q_vector, rcu);
-}
-
 /* Need to wait a few seconds after link up to get diagnostic information from
  * the phy
  */
-- 
2.24.1

