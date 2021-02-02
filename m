Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C755130B533
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 03:25:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229677AbhBBCY3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 21:24:29 -0500
Received: from mga09.intel.com ([134.134.136.24]:11645 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229612AbhBBCY2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Feb 2021 21:24:28 -0500
IronPort-SDR: OcSl9U0MOMQMcvzhQcV0Oek1SHaeBzasTCYI8EkIew73SgOBJ6KIpopXerrZ8muXm+LRKY2SHZ
 jzH16ZrGA9Tg==
X-IronPort-AV: E=McAfee;i="6000,8403,9882"; a="180929263"
X-IronPort-AV: E=Sophos;i="5.79,393,1602572400"; 
   d="scan'208";a="180929263"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2021 18:23:38 -0800
IronPort-SDR: 8i0H+v6QgmsZN0gdJJOaSbpvXvM6rnf+X4cZ6DMimyHGOJu09nk0uUloQwnni2GBYzmaKyxWEa
 sKMlHSE3ry5w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,393,1602572400"; 
   d="scan'208";a="581782130"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga005.fm.intel.com with ESMTP; 01 Feb 2021 18:23:38 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Cristian Dumitrescu <cristian.dumitrescu@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        anthony.l.nguyen@intel.com, bjorn.topel@intel.com,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        Kiran Bhandare <kiranx.bhandare@intel.com>
Subject: [PATCH net-next 1/6] i40e: remove unnecessary memory writes of the next to clean pointer
Date:   Mon,  1 Feb 2021 18:24:15 -0800
Message-Id: <20210202022420.1328397-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210202022420.1328397-1-anthony.l.nguyen@intel.com>
References: <20210202022420.1328397-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cristian Dumitrescu <cristian.dumitrescu@intel.com>

For performance reasons, avoid writing the ring next-to-clean pointer
value back to memory on every update, as it is not really necessary.
Instead, simply read it at initialization into a local copy, update
the local copy as necessary and write the local copy back to memory
after the last update.

Signed-off-by: Cristian Dumitrescu <cristian.dumitrescu@intel.com>
Tested-by: Kiran Bhandare <kiranx.bhandare@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_xsk.c | 30 ++++++++--------------
 1 file changed, 11 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
index 492ce213208d..87d43407653c 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
@@ -261,18 +261,6 @@ static struct sk_buff *i40e_construct_skb_zc(struct i40e_ring *rx_ring,
 	return skb;
 }
 
-/**
- * i40e_inc_ntc: Advance the next_to_clean index
- * @rx_ring: Rx ring
- **/
-static void i40e_inc_ntc(struct i40e_ring *rx_ring)
-{
-	u32 ntc = rx_ring->next_to_clean + 1;
-
-	ntc = (ntc < rx_ring->count) ? ntc : 0;
-	rx_ring->next_to_clean = ntc;
-}
-
 /**
  * i40e_clean_rx_irq_zc - Consumes Rx packets from the hardware ring
  * @rx_ring: Rx ring
@@ -284,6 +272,8 @@ int i40e_clean_rx_irq_zc(struct i40e_ring *rx_ring, int budget)
 {
 	unsigned int total_rx_bytes = 0, total_rx_packets = 0;
 	u16 cleaned_count = I40E_DESC_UNUSED(rx_ring);
+	u16 next_to_clean = rx_ring->next_to_clean;
+	u16 count_mask = rx_ring->count - 1;
 	unsigned int xdp_res, xdp_xmit = 0;
 	bool failure = false;
 	struct sk_buff *skb;
@@ -294,7 +284,7 @@ int i40e_clean_rx_irq_zc(struct i40e_ring *rx_ring, int budget)
 		unsigned int size;
 		u64 qword;
 
-		rx_desc = I40E_RX_DESC(rx_ring, rx_ring->next_to_clean);
+		rx_desc = I40E_RX_DESC(rx_ring, next_to_clean);
 		qword = le64_to_cpu(rx_desc->wb.qword1.status_error_len);
 
 		/* This memory barrier is needed to keep us from reading
@@ -307,11 +297,11 @@ int i40e_clean_rx_irq_zc(struct i40e_ring *rx_ring, int budget)
 			i40e_clean_programming_status(rx_ring,
 						      rx_desc->raw.qword[0],
 						      qword);
-			bi = i40e_rx_bi(rx_ring, rx_ring->next_to_clean);
+			bi = i40e_rx_bi(rx_ring, next_to_clean);
 			xsk_buff_free(*bi);
 			*bi = NULL;
 			cleaned_count++;
-			i40e_inc_ntc(rx_ring);
+			next_to_clean = (next_to_clean + 1) & count_mask;
 			continue;
 		}
 
@@ -320,7 +310,7 @@ int i40e_clean_rx_irq_zc(struct i40e_ring *rx_ring, int budget)
 		if (!size)
 			break;
 
-		bi = i40e_rx_bi(rx_ring, rx_ring->next_to_clean);
+		bi = i40e_rx_bi(rx_ring, next_to_clean);
 		(*bi)->data_end = (*bi)->data + size;
 		xsk_buff_dma_sync_for_cpu(*bi, rx_ring->xsk_pool);
 
@@ -336,7 +326,7 @@ int i40e_clean_rx_irq_zc(struct i40e_ring *rx_ring, int budget)
 			total_rx_packets++;
 
 			cleaned_count++;
-			i40e_inc_ntc(rx_ring);
+			next_to_clean = (next_to_clean + 1) & count_mask;
 			continue;
 		}
 
@@ -355,7 +345,7 @@ int i40e_clean_rx_irq_zc(struct i40e_ring *rx_ring, int budget)
 
 		*bi = NULL;
 		cleaned_count++;
-		i40e_inc_ntc(rx_ring);
+		next_to_clean = (next_to_clean + 1) & count_mask;
 
 		if (eth_skb_pad(skb))
 			continue;
@@ -367,6 +357,8 @@ int i40e_clean_rx_irq_zc(struct i40e_ring *rx_ring, int budget)
 		napi_gro_receive(&rx_ring->q_vector->napi, skb);
 	}
 
+	rx_ring->next_to_clean = next_to_clean;
+
 	if (cleaned_count >= I40E_RX_BUFFER_WRITE)
 		failure = !i40e_alloc_rx_buffers_zc(rx_ring, cleaned_count);
 
@@ -374,7 +366,7 @@ int i40e_clean_rx_irq_zc(struct i40e_ring *rx_ring, int budget)
 	i40e_update_rx_stats(rx_ring, total_rx_bytes, total_rx_packets);
 
 	if (xsk_uses_need_wakeup(rx_ring->xsk_pool)) {
-		if (failure || rx_ring->next_to_clean == rx_ring->next_to_use)
+		if (failure || next_to_clean == rx_ring->next_to_use)
 			xsk_set_rx_need_wakeup(rx_ring->xsk_pool);
 		else
 			xsk_clear_rx_need_wakeup(rx_ring->xsk_pool);
-- 
2.26.2

