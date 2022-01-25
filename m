Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54AE249B835
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 17:09:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377316AbiAYQHh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 11:07:37 -0500
Received: from mga18.intel.com ([134.134.136.126]:4809 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1356796AbiAYQGv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Jan 2022 11:06:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643126808; x=1674662808;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=S4+TzgBkHzmnR2/AVwhZSFy4P/u0+V9PB4Ci+BUskzs=;
  b=ApjoNvmgznn5aIjyD6TqRRXgBvyL5jo4klZALkb2I/pofoezMlo8811K
   sKR5Py9T0z1BJlA+IxcB12TjYYpY1Acts8KCVKWBfgZZGTQtCC1UWFaBn
   tEs3ABrM3LQadOJMwgE0eJ4MIVATmeCzJ/r/4mjgR0GSkX2fywKzl2yEg
   MfZwM66Oj2OalOuevDQyiBODiWia+627BBcrrP6wkILot8JCZ4dzNhxqM
   oePq9rrRdeYJKUCVZIJrDJNyme8w7w2U3m5Z9wF7DQl4dJS5OkFNnkdUv
   14Yd00eAEUVWk1alUa9BvtnfnqFBOAgwe78wPsWrfN1s5hXUgUxrbqHcg
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10237"; a="229911624"
X-IronPort-AV: E=Sophos;i="5.88,315,1635231600"; 
   d="scan'208";a="229911624"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2022 08:04:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,315,1635231600"; 
   d="scan'208";a="534789245"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by orsmga008.jf.intel.com with ESMTP; 25 Jan 2022 08:04:56 -0800
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, magnus.karlsson@intel.com,
        alexandr.lobakin@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH bpf-next v5 4/8] ice: make Tx threshold dependent on ring length
Date:   Tue, 25 Jan 2022 17:04:42 +0100
Message-Id: <20220125160446.78976-5-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220125160446.78976-1-maciej.fijalkowski@intel.com>
References: <20220125160446.78976-1-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

XDP_TX workloads use a concept of Tx threshold that indicates the
interval of setting RS bit on descriptors which in turn tells the HW to
generate an interrupt to signal the completion of Tx on HW side. It is
currently based on a constant value of 32 which might not work out well
for various sizes of ring combined with for example batch size that can
be set via SO_BUSY_POLL_BUDGET.

Internal tests based on AF_XDP showed that most convenient setup of
mentioned threshold is when it is equal to quarter of a ring length.

Make use of recently introduced ICE_RING_QUARTER macro and use this
value as a substitute for ICE_TX_THRESH.

Align also ethtool -G callback so that next_dd/next_rs fields are up to
date in terms of the ring size.

Reviewed-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_ethtool.c  |  2 ++
 drivers/net/ethernet/intel/ice/ice_main.c     |  4 ++--
 drivers/net/ethernet/intel/ice/ice_txrx.h     |  1 -
 drivers/net/ethernet/intel/ice/ice_txrx_lib.c | 14 ++++++++------
 4 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index e2e3ef7fba7f..e3df0134dc77 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -2803,6 +2803,8 @@ ice_set_ringparam(struct net_device *netdev, struct ethtool_ringparam *ring,
 		/* clone ring and setup updated count */
 		xdp_rings[i] = *vsi->xdp_rings[i];
 		xdp_rings[i].count = new_tx_cnt;
+		xdp_rings[i].next_dd = ICE_RING_QUARTER(&xdp_rings[i]) - 1;
+		xdp_rings[i].next_rs = ICE_RING_QUARTER(&xdp_rings[i]) - 1;
 		xdp_rings[i].desc = NULL;
 		xdp_rings[i].tx_buf = NULL;
 		err = ice_setup_tx_ring(&xdp_rings[i]);
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 30814435f779..1980eff8f0e7 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -2495,10 +2495,10 @@ static int ice_xdp_alloc_setup_rings(struct ice_vsi *vsi)
 		xdp_ring->reg_idx = vsi->txq_map[xdp_q_idx];
 		xdp_ring->vsi = vsi;
 		xdp_ring->netdev = NULL;
-		xdp_ring->next_dd = ICE_TX_THRESH - 1;
-		xdp_ring->next_rs = ICE_TX_THRESH - 1;
 		xdp_ring->dev = dev;
 		xdp_ring->count = vsi->num_tx_desc;
+		xdp_ring->next_dd = ICE_RING_QUARTER(xdp_ring) - 1;
+		xdp_ring->next_rs = ICE_RING_QUARTER(xdp_ring) - 1;
 		WRITE_ONCE(vsi->xdp_rings[i], xdp_ring);
 		if (ice_setup_tx_ring(xdp_ring))
 			goto free_xdp_rings;
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.h b/drivers/net/ethernet/intel/ice/ice_txrx.h
index f70a5eb74839..611dd7c4a631 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.h
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.h
@@ -13,7 +13,6 @@
 #define ICE_MAX_CHAINED_RX_BUFS	5
 #define ICE_MAX_BUF_TXD		8
 #define ICE_MIN_TX_LEN		17
-#define ICE_TX_THRESH		32
 
 /* The size limit for a transmit buffer in a descriptor is (16K - 1).
  * In order to align with the read requests we will align the value to
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx_lib.c b/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
index 0e87b98e0966..9677cf880a4b 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
@@ -222,6 +222,7 @@ ice_receive_skb(struct ice_rx_ring *rx_ring, struct sk_buff *skb, u16 vlan_tag)
 static void ice_clean_xdp_irq(struct ice_tx_ring *xdp_ring)
 {
 	unsigned int total_bytes = 0, total_pkts = 0;
+	u16 tx_thresh = ICE_RING_QUARTER(xdp_ring);
 	u16 ntc = xdp_ring->next_to_clean;
 	struct ice_tx_desc *next_dd_desc;
 	u16 next_dd = xdp_ring->next_dd;
@@ -233,7 +234,7 @@ static void ice_clean_xdp_irq(struct ice_tx_ring *xdp_ring)
 	    cpu_to_le64(ICE_TX_DESC_DTYPE_DESC_DONE)))
 		return;
 
-	for (i = 0; i < ICE_TX_THRESH; i++) {
+	for (i = 0; i < tx_thresh; i++) {
 		tx_buf = &xdp_ring->tx_buf[ntc];
 
 		total_bytes += tx_buf->bytecount;
@@ -254,9 +255,9 @@ static void ice_clean_xdp_irq(struct ice_tx_ring *xdp_ring)
 	}
 
 	next_dd_desc->cmd_type_offset_bsz = 0;
-	xdp_ring->next_dd = xdp_ring->next_dd + ICE_TX_THRESH;
+	xdp_ring->next_dd = xdp_ring->next_dd + tx_thresh;
 	if (xdp_ring->next_dd > xdp_ring->count)
-		xdp_ring->next_dd = ICE_TX_THRESH - 1;
+		xdp_ring->next_dd = tx_thresh - 1;
 	xdp_ring->next_to_clean = ntc;
 	ice_update_tx_ring_stats(xdp_ring, total_pkts, total_bytes);
 }
@@ -269,12 +270,13 @@ static void ice_clean_xdp_irq(struct ice_tx_ring *xdp_ring)
  */
 int ice_xmit_xdp_ring(void *data, u16 size, struct ice_tx_ring *xdp_ring)
 {
+	u16 tx_thresh = ICE_RING_QUARTER(xdp_ring);
 	u16 i = xdp_ring->next_to_use;
 	struct ice_tx_desc *tx_desc;
 	struct ice_tx_buf *tx_buf;
 	dma_addr_t dma;
 
-	if (ICE_DESC_UNUSED(xdp_ring) < ICE_TX_THRESH)
+	if (ICE_DESC_UNUSED(xdp_ring) < tx_thresh)
 		ice_clean_xdp_irq(xdp_ring);
 
 	if (!unlikely(ICE_DESC_UNUSED(xdp_ring))) {
@@ -306,7 +308,7 @@ int ice_xmit_xdp_ring(void *data, u16 size, struct ice_tx_ring *xdp_ring)
 		tx_desc = ICE_TX_DESC(xdp_ring, xdp_ring->next_rs);
 		tx_desc->cmd_type_offset_bsz |=
 			cpu_to_le64(ICE_TX_DESC_CMD_RS << ICE_TXD_QW1_CMD_S);
-		xdp_ring->next_rs = ICE_TX_THRESH - 1;
+		xdp_ring->next_rs = tx_thresh - 1;
 	}
 	xdp_ring->next_to_use = i;
 
@@ -314,7 +316,7 @@ int ice_xmit_xdp_ring(void *data, u16 size, struct ice_tx_ring *xdp_ring)
 		tx_desc = ICE_TX_DESC(xdp_ring, xdp_ring->next_rs);
 		tx_desc->cmd_type_offset_bsz |=
 			cpu_to_le64(ICE_TX_DESC_CMD_RS << ICE_TXD_QW1_CMD_S);
-		xdp_ring->next_rs += ICE_TX_THRESH;
+		xdp_ring->next_rs += tx_thresh;
 	}
 
 	return ICE_XDP_TX;
-- 
2.33.1

