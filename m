Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9766452BAB
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 08:38:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230414AbhKPHlm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 02:41:42 -0500
Received: from mga11.intel.com ([192.55.52.93]:42900 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230403AbhKPHlk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 02:41:40 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10169"; a="231099083"
X-IronPort-AV: E=Sophos;i="5.87,238,1631602800"; 
   d="scan'208";a="231099083"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2021 23:38:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,238,1631602800"; 
   d="scan'208";a="671857370"
Received: from silpixa00401086.ir.intel.com (HELO localhost.localdomain) ([10.55.129.110])
  by orsmga005.jf.intel.com with ESMTP; 15 Nov 2021 23:38:40 -0800
From:   Ciara Loftus <ciara.loftus@intel.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        kuba@kernel.org, hawk@kernel.org, john.fastabend@gmail.com,
        toke@redhat.com, bjorn@kernel.org, magnus.karlsson@intel.com,
        jonathan.lemon@gmail.com, maciej.fijalkowski@intel.com,
        Ciara Loftus <ciara.loftus@intel.com>,
        Cristian Dumitrescu <cristian.dumitrescu@intel.com>
Subject: [RFC PATCH bpf-next 6/8] i40e: isolate descriptor processing in separate function
Date:   Tue, 16 Nov 2021 07:37:40 +0000
Message-Id: <20211116073742.7941-7-ciara.loftus@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211116073742.7941-1-ciara.loftus@intel.com>
References: <20211116073742.7941-1-ciara.loftus@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To prepare for batched processing, first isolate descriptor processing
in a separate function to make it easier to introduce the batched
interfaces.

Signed-off-by: Cristian Dumitrescu <cristian.dumitrescu@intel.com>
Signed-off-by: Ciara Loftus <ciara.loftus@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_xsk.c | 51 +++++++++++++++-------
 1 file changed, 36 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
index 31b794672ea5..c994b4d9c38a 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
@@ -323,28 +323,23 @@ static void i40e_handle_xdp_result_zc(struct i40e_ring *rx_ring,
 	WARN_ON_ONCE(1);
 }
 
-/**
- * i40e_clean_rx_irq_zc - Consumes Rx packets from the hardware ring
- * @rx_ring: Rx ring
- * @budget: NAPI budget
- *
- * Returns amount of work completed
- **/
-int i40e_clean_rx_irq_zc(struct i40e_ring *rx_ring, int budget)
+static inline void i40e_clean_rx_desc_zc(struct i40e_ring *rx_ring,
+					 unsigned int *stat_rx_packets,
+					 unsigned int *stat_rx_bytes,
+					 unsigned int *xmit,
+					 int budget)
 {
-	unsigned int total_rx_bytes = 0, total_rx_packets = 0;
-	u16 cleaned_count = I40E_DESC_UNUSED(rx_ring);
+	unsigned int total_rx_packets = *stat_rx_packets, total_rx_bytes = *stat_rx_bytes;
 	u16 next_to_clean = rx_ring->next_to_clean;
 	u16 count_mask = rx_ring->count - 1;
-	unsigned int xdp_res, xdp_xmit = 0;
-	bool failure = false;
+	unsigned int xdp_xmit = *xmit;
 
 	while (likely(total_rx_packets < (unsigned int)budget)) {
 		union i40e_rx_desc *rx_desc;
+		unsigned int size, xdp_res;
 		unsigned int rx_packets;
 		unsigned int rx_bytes;
 		struct xdp_buff *bi;
-		unsigned int size;
 		u64 qword;
 
 		rx_desc = I40E_RX_DESC(rx_ring, next_to_clean);
@@ -385,7 +380,33 @@ int i40e_clean_rx_irq_zc(struct i40e_ring *rx_ring, int budget)
 	}
 
 	rx_ring->next_to_clean = next_to_clean;
-	cleaned_count = (next_to_clean - rx_ring->next_to_use - 1) & count_mask;
+	*stat_rx_packets = total_rx_packets;
+	*stat_rx_bytes = total_rx_bytes;
+	*xmit = xdp_xmit;
+}
+
+/**
+ * i40e_clean_rx_irq_zc - Consumes Rx packets from the hardware ring
+ * @rx_ring: Rx ring
+ * @budget: NAPI budget
+ *
+ * Returns amount of work completed
+ **/
+int i40e_clean_rx_irq_zc(struct i40e_ring *rx_ring, int budget)
+{
+	unsigned int total_rx_bytes = 0, total_rx_packets = 0;
+	u16 count_mask = rx_ring->count - 1;
+	unsigned int xdp_xmit = 0;
+	bool failure = false;
+	u16 cleaned_count;
+
+	i40e_clean_rx_desc_zc(rx_ring,
+			      &total_rx_packets,
+			      &total_rx_bytes,
+			      &xdp_xmit,
+			      budget);
+
+	cleaned_count = (rx_ring->next_to_clean - rx_ring->next_to_use - 1) & count_mask;
 
 	if (cleaned_count >= I40E_RX_BUFFER_WRITE)
 		failure = !i40e_alloc_rx_buffers_zc(rx_ring, cleaned_count);
@@ -394,7 +415,7 @@ int i40e_clean_rx_irq_zc(struct i40e_ring *rx_ring, int budget)
 	i40e_update_rx_stats(rx_ring, total_rx_bytes, total_rx_packets);
 
 	if (xsk_uses_need_wakeup(rx_ring->xsk_pool)) {
-		if (failure || next_to_clean == rx_ring->next_to_use)
+		if (failure ||  rx_ring->next_to_clean == rx_ring->next_to_use)
 			xsk_set_rx_need_wakeup(rx_ring->xsk_pool);
 		else
 			xsk_clear_rx_need_wakeup(rx_ring->xsk_pool);
-- 
2.17.1

