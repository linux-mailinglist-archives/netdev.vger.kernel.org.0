Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F9E9B0201
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 18:50:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729315AbfIKQt7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 12:49:59 -0400
Received: from mga14.intel.com ([192.55.52.115]:31944 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728825AbfIKQt6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Sep 2019 12:49:58 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Sep 2019 09:49:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,492,1559545200"; 
   d="scan'208";a="179078817"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga008.jf.intel.com with ESMTP; 11 Sep 2019 09:49:57 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Ilya Maximets <i.maximets@samsung.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com, stable@vger.kernel.org,
        William Tu <u9012063@gmail.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net 2/2] ixgbe: fix double clean of Tx descriptors with xdp
Date:   Wed, 11 Sep 2019 09:49:55 -0700
Message-Id: <20190911164955.10644-3-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190911164955.10644-1-jeffrey.t.kirsher@intel.com>
References: <20190911164955.10644-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ilya Maximets <i.maximets@samsung.com>

Tx code doesn't clear the descriptors' status after cleaning.
So, if the budget is larger than number of used elems in a ring, some
descriptors will be accounted twice and xsk_umem_complete_tx will move
prod_tail far beyond the prod_head breaking the completion queue ring.

Fix that by limiting the number of descriptors to clean by the number
of used descriptors in the Tx ring.

'ixgbe_clean_xdp_tx_irq()' function refactored to look more like
'ixgbe_xsk_clean_tx_ring()' since we're allowed to directly use
'next_to_clean' and 'next_to_use' indexes.

CC: stable@vger.kernel.org
Fixes: 8221c5eba8c1 ("ixgbe: add AF_XDP zero-copy Tx support")
Signed-off-by: Ilya Maximets <i.maximets@samsung.com>
Tested-by: William Tu <u9012063@gmail.com>
Tested-by: Eelco Chaudron <echaudro@redhat.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c | 29 ++++++++------------
 1 file changed, 11 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
index 6b609553329f..a3b6d8c89127 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
@@ -633,19 +633,17 @@ static void ixgbe_clean_xdp_tx_buffer(struct ixgbe_ring *tx_ring,
 bool ixgbe_clean_xdp_tx_irq(struct ixgbe_q_vector *q_vector,
 			    struct ixgbe_ring *tx_ring, int napi_budget)
 {
+	u16 ntc = tx_ring->next_to_clean, ntu = tx_ring->next_to_use;
 	unsigned int total_packets = 0, total_bytes = 0;
-	u32 i = tx_ring->next_to_clean, xsk_frames = 0;
-	unsigned int budget = q_vector->tx.work_limit;
 	struct xdp_umem *umem = tx_ring->xsk_umem;
 	union ixgbe_adv_tx_desc *tx_desc;
 	struct ixgbe_tx_buffer *tx_bi;
-	bool xmit_done;
+	u32 xsk_frames = 0;
 
-	tx_bi = &tx_ring->tx_buffer_info[i];
-	tx_desc = IXGBE_TX_DESC(tx_ring, i);
-	i -= tx_ring->count;
+	tx_bi = &tx_ring->tx_buffer_info[ntc];
+	tx_desc = IXGBE_TX_DESC(tx_ring, ntc);
 
-	do {
+	while (ntc != ntu) {
 		if (!(tx_desc->wb.status & cpu_to_le32(IXGBE_TXD_STAT_DD)))
 			break;
 
@@ -661,22 +659,18 @@ bool ixgbe_clean_xdp_tx_irq(struct ixgbe_q_vector *q_vector,
 
 		tx_bi++;
 		tx_desc++;
-		i++;
-		if (unlikely(!i)) {
-			i -= tx_ring->count;
+		ntc++;
+		if (unlikely(ntc == tx_ring->count)) {
+			ntc = 0;
 			tx_bi = tx_ring->tx_buffer_info;
 			tx_desc = IXGBE_TX_DESC(tx_ring, 0);
 		}
 
 		/* issue prefetch for next Tx descriptor */
 		prefetch(tx_desc);
+	}
 
-		/* update budget accounting */
-		budget--;
-	} while (likely(budget));
-
-	i += tx_ring->count;
-	tx_ring->next_to_clean = i;
+	tx_ring->next_to_clean = ntc;
 
 	u64_stats_update_begin(&tx_ring->syncp);
 	tx_ring->stats.bytes += total_bytes;
@@ -688,8 +682,7 @@ bool ixgbe_clean_xdp_tx_irq(struct ixgbe_q_vector *q_vector,
 	if (xsk_frames)
 		xsk_umem_complete_tx(umem, xsk_frames);
 
-	xmit_done = ixgbe_xmit_zc(tx_ring, q_vector->tx.work_limit);
-	return budget > 0 && xmit_done;
+	return ixgbe_xmit_zc(tx_ring, q_vector->tx.work_limit);
 }
 
 int ixgbe_xsk_async_xmit(struct net_device *dev, u32 qid)
-- 
2.21.0

