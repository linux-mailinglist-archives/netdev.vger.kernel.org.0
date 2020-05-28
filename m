Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5B7F1E588A
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 09:26:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726767AbgE1HZx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 03:25:53 -0400
Received: from mga02.intel.com ([134.134.136.20]:14688 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726729AbgE1HZs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 03:25:48 -0400
IronPort-SDR: ooFsk0R5C4nmq6iM8VwWQTmeUECQ0lmKSk0kX/G0Zj1j7DfPYYjlDUFk19SAnylqhd6W0wYmut
 I83nfXIkou8Q==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2020 00:25:45 -0700
IronPort-SDR: K9W9dXF8veERba4hHLl7etifKsHE7i5YhZKvL78JsXQxtcrElH/Dmyc64C8facco19Ec4nJQ4H
 7dtYGquhbYSg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,443,1583222400"; 
   d="scan'208";a="310831149"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by FMSMGA003.fm.intel.com with ESMTP; 28 May 2020 00:25:44 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Krzysztof Kazimierczak <krzysztof.kazimierczak@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 15/15] ice: Check UMEM FQ size when allocating bufs
Date:   Thu, 28 May 2020 00:25:38 -0700
Message-Id: <20200528072538.1621790-16-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200528072538.1621790-1-jeffrey.t.kirsher@intel.com>
References: <20200528072538.1621790-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Krzysztof Kazimierczak <krzysztof.kazimierczak@intel.com>

If a UMEM is present on a queue when an interface/queue pair is being
enabled, the driver will try to prepare the Rx buffers in advance to
improve performance. However, if fill queue is shorter than HW Rx ring,
the driver will report failure after getting the last address from the
fill queue.

This still lets the driver process the packets correctly during the NAPI
poll, but leads to a constant NAPI rescheduling. Not allocating the
buffers in advance would result in a potential performance decrease.

Commit d57d76428ae9 ("xsk: Add API to check for available entries in FQ")
provides an API that lets drivers check the number of addresses that the
fill queue holds.

Notify the user if fill queue is not long enough to prepare all buffers
before packet processing starts, and allocate the buffers during the
NAPI poll. If the fill queue size is sufficient, prepare Rx buffers in
advance.

Signed-off-by: Krzysztof Kazimierczak <krzysztof.kazimierczak@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_base.c | 30 ++++++++++++++++-------
 1 file changed, 21 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_base.c b/drivers/net/ethernet/intel/ice/ice_base.c
index 18076e0d12d0..a174911d8994 100644
--- a/drivers/net/ethernet/intel/ice/ice_base.c
+++ b/drivers/net/ethernet/intel/ice/ice_base.c
@@ -281,7 +281,9 @@ ice_setup_tx_ctx(struct ice_ring *ring, struct ice_tlan_ctx *tlan_ctx, u16 pf_q)
  */
 int ice_setup_rx_ctx(struct ice_ring *ring)
 {
+	struct device *dev = ice_pf_to_dev(ring->vsi->back);
 	int chain_len = ICE_MAX_CHAINED_RX_BUFS;
+	u16 num_bufs = ICE_DESC_UNUSED(ring);
 	struct ice_vsi *vsi = ring->vsi;
 	u32 rxdid = ICE_RXDID_FLEX_NIC;
 	struct ice_rlan_ctx rlan_ctx;
@@ -324,7 +326,7 @@ int ice_setup_rx_ctx(struct ice_ring *ring)
 				return err;
 			xsk_buff_set_rxq_info(ring->xsk_umem, &ring->xdp_rxq);
 
-			dev_info(ice_pf_to_dev(vsi->back), "Registered XDP mem model MEM_TYPE_XSK_BUFF_POOL on Rx ring %d\n",
+			dev_info(dev, "Registered XDP mem model MEM_TYPE_XSK_BUFF_POOL on Rx ring %d\n",
 				 ring->q_index);
 		} else {
 			if (!xdp_rxq_info_is_reg(&ring->xdp_rxq))
@@ -408,7 +410,7 @@ int ice_setup_rx_ctx(struct ice_ring *ring)
 	/* Absolute queue number out of 2K needs to be passed */
 	err = ice_write_rxq_ctx(hw, &rlan_ctx, pf_q);
 	if (err) {
-		dev_err(ice_pf_to_dev(vsi->back), "Failed to set LAN Rx queue context for absolute Rx queue %d error: %d\n",
+		dev_err(dev, "Failed to set LAN Rx queue context for absolute Rx queue %d error: %d\n",
 			pf_q, err);
 		return -EIO;
 	}
@@ -426,13 +428,23 @@ int ice_setup_rx_ctx(struct ice_ring *ring)
 	ring->tail = hw->hw_addr + QRX_TAIL(pf_q);
 	writel(0, ring->tail);
 
-	err = ring->xsk_umem ?
-	      ice_alloc_rx_bufs_zc(ring, ICE_DESC_UNUSED(ring)) :
-	      ice_alloc_rx_bufs(ring, ICE_DESC_UNUSED(ring));
-	if (err)
-		dev_info(ice_pf_to_dev(vsi->back), "Failed allocate some buffers on %sRx ring %d (pf_q %d)\n",
-			 ring->xsk_umem ? "UMEM enabled " : "",
-			 ring->q_index, pf_q);
+	if (ring->xsk_umem) {
+		if (!xsk_buff_can_alloc(ring->xsk_umem, num_bufs)) {
+			dev_warn(dev, "UMEM does not provide enough addresses to fill %d buffers on Rx ring %d\n",
+				 num_bufs, ring->q_index);
+			dev_warn(dev, "Change Rx ring/fill queue size to avoid performance issues\n");
+
+			return 0;
+		}
+
+		err = ice_alloc_rx_bufs_zc(ring, num_bufs);
+		if (err)
+			dev_info(dev, "Failed to allocate some buffers on UMEM enabled Rx ring %d (pf_q %d)\n",
+				 ring->q_index, pf_q);
+		return 0;
+	}
+
+	ice_alloc_rx_bufs(ring, num_bufs);
 
 	return 0;
 }
-- 
2.26.2

