Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 057A349B83A
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 17:09:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378612AbiAYQIH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 11:08:07 -0500
Received: from mga18.intel.com ([134.134.136.126]:4817 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1357666AbiAYQHL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Jan 2022 11:07:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643126830; x=1674662830;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/0dckENcpKnb+ll4ijSqMOyoHT0ZNbRhP1jkUiXAvbE=;
  b=PymNhrEIBd2rue8ULzltFXZIJw0yAoXRulKcZZn1aK2ZaBOIZtv7Xn6P
   iUgUW6BvaAyg02Lvb4mgb780if01wn5ue7gcSZjwh1gtnvjxORDYVkYrq
   mmoqKEWtsSy5MpTupwjaXWQgxpUwGpf6+fX3HZPGtdASbzNUWBkkL/C9/
   LEU7sNGMYFMhRGV2no60Pf3qRzHRZPF0cdH6kS3U0n8AY5q4DugEDNc1v
   460uKRsS497RtAnI7P7uoSuC/OPiTHpQOSVYwOBd5VN3vpPYVhq2hO54J
   BvbuZLWvjDEbii8WIioOngYK5ZYw0867vv6aq0d7tPONcNsnItFk8I5VI
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10237"; a="229911674"
X-IronPort-AV: E=Sophos;i="5.88,315,1635231600"; 
   d="scan'208";a="229911674"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2022 08:05:06 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,315,1635231600"; 
   d="scan'208";a="534789330"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by orsmga008.jf.intel.com with ESMTP; 25 Jan 2022 08:05:04 -0800
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, magnus.karlsson@intel.com,
        alexandr.lobakin@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH bpf-next v5 8/8] ice: xsk: borrow xdp_tx_active logic from i40e
Date:   Tue, 25 Jan 2022 17:04:46 +0100
Message-Id: <20220125160446.78976-9-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220125160446.78976-1-maciej.fijalkowski@intel.com>
References: <20220125160446.78976-1-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

One of the things that commit 5574ff7b7b3d ("i40e: optimize AF_XDP Tx
completion path") introduced was the @xdp_tx_active field. Its usage
from i40e can be adjusted to ice driver and give us positive performance
results.

If the descriptor that @next_dd points to has been sent by HW (its DD
bit is set), then we are sure that at least quarter of the ring is ready
to be cleaned. If @xdp_tx_active is 0 which means that related xdp_ring
is not used for XDP_{TX, REDIRECT} workloads, then we know how many XSK
entries should placed to completion queue, IOW walking through the ring
can be skipped.

Reviewed-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_txrx.h     |  1 +
 drivers/net/ethernet/intel/ice/ice_txrx_lib.c |  1 +
 drivers/net/ethernet/intel/ice/ice_xsk.c      | 15 ++++++++++++---
 3 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.h b/drivers/net/ethernet/intel/ice/ice_txrx.h
index 666db35a2919..466253ac2ee1 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.h
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.h
@@ -333,6 +333,7 @@ struct ice_tx_ring {
 	spinlock_t tx_lock;
 	u32 txq_teid;			/* Added Tx queue TEID */
 	/* CL4 - 4th cacheline starts here */
+	u16 xdp_tx_active;
 #define ICE_TX_FLAGS_RING_XDP		BIT(0)
 	u8 flags;
 	u8 dcb_tc;			/* Traffic class of ring */
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx_lib.c b/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
index 9677cf880a4b..eb21cec1d772 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
@@ -302,6 +302,7 @@ int ice_xmit_xdp_ring(void *data, u16 size, struct ice_tx_ring *xdp_ring)
 	tx_desc->cmd_type_offset_bsz = ice_build_ctob(ICE_TX_DESC_CMD_EOP, 0,
 						      size, 0);
 
+	xdp_ring->xdp_tx_active++;
 	i++;
 	if (i == xdp_ring->count) {
 		i = 0;
diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
index 8b6acb4afb7f..2976991c0ab2 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -687,6 +687,7 @@ static void
 ice_clean_xdp_tx_buf(struct ice_tx_ring *xdp_ring, struct ice_tx_buf *tx_buf)
 {
 	xdp_return_frame((struct xdp_frame *)tx_buf->raw_buf);
+	xdp_ring->xdp_tx_active--;
 	dma_unmap_single(xdp_ring->dev, dma_unmap_addr(tx_buf, dma),
 			 dma_unmap_len(tx_buf, len), DMA_TO_DEVICE);
 	dma_unmap_len_set(tx_buf, len, 0);
@@ -703,9 +704,8 @@ static u16 ice_clean_xdp_irq_zc(struct ice_tx_ring *xdp_ring, int napi_budget)
 {
 	u16 tx_thresh = ICE_RING_QUARTER(xdp_ring);
 	int budget = napi_budget / tx_thresh;
-	u16 ntc = xdp_ring->next_to_clean;
 	u16 next_dd = xdp_ring->next_dd;
-	u16 cleared_dds = 0;
+	u16 ntc, cleared_dds = 0;
 
 	do {
 		struct ice_tx_desc *next_dd_desc;
@@ -721,6 +721,12 @@ static u16 ice_clean_xdp_irq_zc(struct ice_tx_ring *xdp_ring, int napi_budget)
 
 		cleared_dds++;
 		xsk_frames = 0;
+		if (likely(!xdp_ring->xdp_tx_active)) {
+			xsk_frames = tx_thresh;
+			goto skip;
+		}
+
+		ntc = xdp_ring->next_to_clean;
 
 		for (i = 0; i < tx_thresh; i++) {
 			tx_buf = &xdp_ring->tx_buf[ntc];
@@ -736,6 +742,10 @@ static u16 ice_clean_xdp_irq_zc(struct ice_tx_ring *xdp_ring, int napi_budget)
 			if (ntc >= xdp_ring->count)
 				ntc = 0;
 		}
+skip:
+		xdp_ring->next_to_clean += tx_thresh;
+		if (xdp_ring->next_to_clean >= desc_cnt)
+			xdp_ring->next_to_clean -= desc_cnt;
 		if (xsk_frames)
 			xsk_tx_completed(xdp_ring->xsk_pool, xsk_frames);
 		next_dd_desc->cmd_type_offset_bsz = 0;
@@ -744,7 +754,6 @@ static u16 ice_clean_xdp_irq_zc(struct ice_tx_ring *xdp_ring, int napi_budget)
 			next_dd = tx_thresh - 1;
 	} while (budget--);
 
-	xdp_ring->next_to_clean = ntc;
 	xdp_ring->next_dd = next_dd;
 
 	return cleared_dds * tx_thresh;
-- 
2.33.1

