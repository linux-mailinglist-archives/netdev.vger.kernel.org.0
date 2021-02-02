Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4402330B534
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 03:25:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229914AbhBBCYq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 21:24:46 -0500
Received: from mga09.intel.com ([134.134.136.24]:11645 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229596AbhBBCYo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Feb 2021 21:24:44 -0500
IronPort-SDR: PCldDL34U1I8qrfoKEY23NAiMwFK/vYyZqQ4h5c07IFG7ZCDuCFqymgAQ2YSOcl0FFjEnYbg7z
 IJZGuDnQuc+Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9882"; a="180929268"
X-IronPort-AV: E=Sophos;i="5.79,393,1602572400"; 
   d="scan'208";a="180929268"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2021 18:23:39 -0800
IronPort-SDR: NKIwpKD72+HDiW8rG+LO24ST7Cd78ckziyvbRCFRdcboS/ckAd8kRWSpPcNYYZTgBVMuNzMds3
 OOiLhM1ftKnA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,393,1602572400"; 
   d="scan'208";a="581782136"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga005.fm.intel.com with ESMTP; 01 Feb 2021 18:23:39 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Cristian Dumitrescu <cristian.dumitrescu@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        anthony.l.nguyen@intel.com, bjorn.topel@intel.com,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        Kiran Bhandare <kiranx.bhandare@intel.com>
Subject: [PATCH net-next 3/6] i40e: remove the redundant buffer info updates
Date:   Mon,  1 Feb 2021 18:24:17 -0800
Message-Id: <20210202022420.1328397-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210202022420.1328397-1-anthony.l.nguyen@intel.com>
References: <20210202022420.1328397-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cristian Dumitrescu <cristian.dumitrescu@intel.com>

For performance reasons, remove the redundant buffer info updates
(*bi = NULL). The buffers ready to be cleaned can easily be tracked
based on the ring next-to-clean variable, which is consistently
updated.

Signed-off-by: Cristian Dumitrescu <cristian.dumitrescu@intel.com>
Tested-by: Kiran Bhandare <kiranx.bhandare@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_xsk.c | 33 +++++++++-------------
 1 file changed, 14 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
index 99082abd3000..1167496a2e08 100644
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
 
@@ -335,13 +333,12 @@ int i40e_clean_rx_irq_zc(struct i40e_ring *rx_ring, int budget)
 		 * BIT(I40E_RXD_QW1_ERROR_SHIFT). This is due to that
 		 * SBP is *not* set in PRT_SBPVSI (default not set).
 		 */
-		skb = i40e_construct_skb_zc(rx_ring, *bi);
+		skb = i40e_construct_skb_zc(rx_ring, bi);
 		if (!skb) {
 			rx_ring->rx_stats.alloc_buff_failed++;
 			break;
 		}
 
-		*bi = NULL;
 		next_to_clean = (next_to_clean + 1) & count_mask;
 
 		if (eth_skb_pad(skb))
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
2.26.2

