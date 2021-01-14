Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33D622F6336
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 15:34:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726730AbhANOeR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 09:34:17 -0500
Received: from mga11.intel.com ([192.55.52.93]:24511 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725884AbhANOeR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Jan 2021 09:34:17 -0500
IronPort-SDR: RHlqJ8XWaUDxqeBdPzqhxZXXBh9HVWR6r0olFW7OMQigfKUdrDCknafZss8pT4ax88xrGKyk9i
 ZCW8I6Jcu+cQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9863"; a="174868378"
X-IronPort-AV: E=Sophos;i="5.79,347,1602572400"; 
   d="scan'208";a="174868378"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2021 06:33:27 -0800
IronPort-SDR: wE1Wh5hZ/nm6pY7VqkSKAYzNHOGATguNzRtMnJ9pQwY/aYpKNndhc4DB6LfQ39QZAwVx0Nn8nq
 cvI6xzN3KzHw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,347,1602572400"; 
   d="scan'208";a="353919568"
Received: from silpixa00400572.ir.intel.com ([10.237.213.34])
  by fmsmga008.fm.intel.com with ESMTP; 14 Jan 2021 06:33:25 -0800
From:   Cristian Dumitrescu <cristian.dumitrescu@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        magnus.karlsson@intel.com, bjorn.topel@intel.com,
        maciej.fijalkowski@intel.com, edwin.verplanke@intel.com,
        cristian.dumitrescu@intel.com
Subject: [PATCH net-next 3/4] i40e: remove the redundant buffer info updates
Date:   Thu, 14 Jan 2021 14:33:17 +0000
Message-Id: <20210114143318.2171-4-cristian.dumitrescu@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210114143318.2171-1-cristian.dumitrescu@intel.com>
References: <20210114143318.2171-1-cristian.dumitrescu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For performace reasons, remove the redundant buffer info updates
(*bi = NULL). The buffers ready to be cleaned can easily be tracked
based on the ring next-to-clean variable, which is consistently
updated.

Signed-off-by: Cristian Dumitrescu <cristian.dumitrescu@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_xsk.c | 33 +++++++++-------------
 1 file changed, 14 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
index 453ef30d9498..1167496a2e08 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
@@ -280,7 +280,7 @@ int i40e_clean_rx_irq_zc(struct i40e_ring *rx_ring, int budget)
 
 	while (likely(total_rx_packets < (unsigned int)budget)) {
 		union i40e_rx_desc *rx_desc;
-		struct xdp_buff **bi;
+		struct xdp_buff *bi;
 		unsigned int size;
 		u64 qword;
 
@@ -297,9 +297,8 @@ int i40e_clean_rx_irq_zc(struct i40e_ring *rx_ring, int budget)
 			i40e_clean_programming_status(rx_ring,
 						      rx_desc->raw.qword[0],
 						      qword);
-			bi = i40e_rx_bi(rx_ring, next_to_clean);
-			xsk_buff_free(*bi);
-			*bi = NULL;
+			bi = *i40e_rx_bi(rx_ring, next_to_clean);
+			xsk_buff_free(bi);
 			next_to_clean = (next_to_clean + 1) & count_mask;
 			continue;
 		}
@@ -309,18 +308,17 @@ int i40e_clean_rx_irq_zc(struct i40e_ring *rx_ring, int budget)
 		if (!size)
 			break;
 
-		bi = i40e_rx_bi(rx_ring, next_to_clean);
-		(*bi)->data_end = (*bi)->data + size;
-		xsk_buff_dma_sync_for_cpu(*bi, rx_ring->xsk_pool);
+		bi = *i40e_rx_bi(rx_ring, next_to_clean);
+		bi->data_end = bi->data + size;
+		xsk_buff_dma_sync_for_cpu(bi, rx_ring->xsk_pool);
 
-		xdp_res = i40e_run_xdp_zc(rx_ring, *bi);
+		xdp_res = i40e_run_xdp_zc(rx_ring, bi);
 		if (xdp_res) {
 			if (xdp_res & (I40E_XDP_TX | I40E_XDP_REDIR))
 				xdp_xmit |= xdp_res;
 			else
-				xsk_buff_free(*bi);
+				xsk_buff_free(bi);
 
-			*bi = NULL;
 			total_rx_bytes += size;
 			total_rx_packets++;
 
@@ -335,8 +333,7 @@ int i40e_clean_rx_irq_zc(struct i40e_ring *rx_ring, int budget)
 		 * BIT(I40E_RXD_QW1_ERROR_SHIFT). This is due to that
 		 * SBP is *not* set in PRT_SBPVSI (default not set).
 		 */
-		skb = i40e_construct_skb_zc(rx_ring, *bi);
-		*bi = NULL;
+		skb = i40e_construct_skb_zc(rx_ring, bi);
 		if (!skb) {
 			rx_ring->rx_stats.alloc_buff_failed++;
 			break;
@@ -594,16 +591,14 @@ int i40e_xsk_wakeup(struct net_device *dev, u32 queue_id, u32 flags)
 
 void i40e_xsk_clean_rx_ring(struct i40e_ring *rx_ring)
 {
-	u16 i;
-
-	for (i = 0; i < rx_ring->count; i++) {
-		struct xdp_buff *rx_bi = *i40e_rx_bi(rx_ring, i);
+	u16 count_mask = rx_ring->count - 1;
+	u16 ntc = rx_ring->next_to_clean;
+	u16 ntu = rx_ring->next_to_use;
 
-		if (!rx_bi)
-			continue;
+	for ( ; ntc != ntu; ntc = (ntc + 1)  & count_mask) {
+		struct xdp_buff *rx_bi = *i40e_rx_bi(rx_ring, ntc);
 
 		xsk_buff_free(rx_bi);
-		rx_bi = NULL;
 	}
 }
 
-- 
2.25.1

