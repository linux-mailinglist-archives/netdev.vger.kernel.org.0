Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15DE433955B
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 18:47:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232602AbhCLRrK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 12:47:10 -0500
Received: from mga06.intel.com ([134.134.136.31]:9116 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231392AbhCLRqi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Mar 2021 12:46:38 -0500
IronPort-SDR: AoTZ9Nbpjgjtd8SpgfE5kZnfk4lGPipyVarhrunm1eB3IY7ICl1icAmsunY3alvzXLt+ON4hGg
 vzCRewQgUgNg==
X-IronPort-AV: E=McAfee;i="6000,8403,9921"; a="250232654"
X-IronPort-AV: E=Sophos;i="5.81,244,1610438400"; 
   d="scan'208";a="250232654"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2021 09:46:38 -0800
IronPort-SDR: yHdnIH1PsYKnXfVx8L9Tz5NF0/sHC6/MC+6+g4dBAp9sfHrDF6YHDQ351Cu6ygDuJt6rdfzxfK
 KbYSwY9C5kXA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,244,1610438400"; 
   d="scan'208";a="589615846"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga005.jf.intel.com with ESMTP; 12 Mar 2021 09:46:37 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Magnus Karlsson <magnus.karlsson@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        anthony.l.nguyen@intel.com, bjorn.topel@intel.com,
        maciej.fijalkowski@intel.com,
        Kiran Bhandare <kiranx.bhandare@intel.com>
Subject: [PATCH net 1/5] ice: fix napi work done reporting in xsk path
Date:   Fri, 12 Mar 2021 09:47:51 -0800
Message-Id: <20210312174755.2103336-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210312174755.2103336-1-anthony.l.nguyen@intel.com>
References: <20210312174755.2103336-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Fix the wrong napi work done reporting in the xsk path of the ice
driver. The code in the main Rx processing loop was written to assume
that the buffer allocation code returns true if all allocations where
successful and false if not. In contrast with all other Intel NIC xsk
drivers, the ice_alloc_rx_bufs_zc() has the inverted logic messing up
the work done reporting in the napi loop.

This can be fixed either by inverting the return value from
ice_alloc_rx_bufs_zc() in the function that uses this in an incorrect
way, or by changing the return value of ice_alloc_rx_bufs_zc(). We
chose the latter as it makes all the xsk allocation functions for
Intel NICs behave in the same way. My guess is that it was this
unexpected discrepancy that gave rise to this bug in the first place.

Fixes: 5bb0c4b5eb61 ("ice, xsk: Move Rx allocation out of while-loop")
Reported-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
Tested-by: Kiran Bhandare <kiranx.bhandare@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_base.c |  6 ++++--
 drivers/net/ethernet/intel/ice/ice_xsk.c  | 10 +++++-----
 2 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_base.c b/drivers/net/ethernet/intel/ice/ice_base.c
index 3124a3bf519a..952e41a1e001 100644
--- a/drivers/net/ethernet/intel/ice/ice_base.c
+++ b/drivers/net/ethernet/intel/ice/ice_base.c
@@ -418,6 +418,8 @@ int ice_setup_rx_ctx(struct ice_ring *ring)
 	writel(0, ring->tail);
 
 	if (ring->xsk_pool) {
+		bool ok;
+
 		if (!xsk_buff_can_alloc(ring->xsk_pool, num_bufs)) {
 			dev_warn(dev, "XSK buffer pool does not provide enough addresses to fill %d buffers on Rx ring %d\n",
 				 num_bufs, ring->q_index);
@@ -426,8 +428,8 @@ int ice_setup_rx_ctx(struct ice_ring *ring)
 			return 0;
 		}
 
-		err = ice_alloc_rx_bufs_zc(ring, num_bufs);
-		if (err)
+		ok = ice_alloc_rx_bufs_zc(ring, num_bufs);
+		if (!ok)
 			dev_info(dev, "Failed to allocate some buffers on XSK buffer pool enabled Rx ring %d (pf_q %d)\n",
 				 ring->q_index, pf_q);
 		return 0;
diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
index 83f3c9574ed1..9f94d9159acd 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -358,18 +358,18 @@ int ice_xsk_pool_setup(struct ice_vsi *vsi, struct xsk_buff_pool *pool, u16 qid)
  * This function allocates a number of Rx buffers from the fill ring
  * or the internal recycle mechanism and places them on the Rx ring.
  *
- * Returns false if all allocations were successful, true if any fail.
+ * Returns true if all allocations were successful, false if any fail.
  */
 bool ice_alloc_rx_bufs_zc(struct ice_ring *rx_ring, u16 count)
 {
 	union ice_32b_rx_flex_desc *rx_desc;
 	u16 ntu = rx_ring->next_to_use;
 	struct ice_rx_buf *rx_buf;
-	bool ret = false;
+	bool ok = true;
 	dma_addr_t dma;
 
 	if (!count)
-		return false;
+		return true;
 
 	rx_desc = ICE_RX_DESC(rx_ring, ntu);
 	rx_buf = &rx_ring->rx_buf[ntu];
@@ -377,7 +377,7 @@ bool ice_alloc_rx_bufs_zc(struct ice_ring *rx_ring, u16 count)
 	do {
 		rx_buf->xdp = xsk_buff_alloc(rx_ring->xsk_pool);
 		if (!rx_buf->xdp) {
-			ret = true;
+			ok = false;
 			break;
 		}
 
@@ -402,7 +402,7 @@ bool ice_alloc_rx_bufs_zc(struct ice_ring *rx_ring, u16 count)
 		ice_release_rx_desc(rx_ring, ntu);
 	}
 
-	return ret;
+	return ok;
 }
 
 /**
-- 
2.26.2

