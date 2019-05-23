Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0C2028D33
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 00:34:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388655AbfEWWdm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 18:33:42 -0400
Received: from mga12.intel.com ([192.55.52.136]:19075 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388584AbfEWWdj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 May 2019 18:33:39 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 May 2019 15:33:37 -0700
X-ExtLoop1: 1
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga003.jf.intel.com with ESMTP; 23 May 2019 15:33:35 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 11/15] ice: Reorganize tx_buf and ring structs
Date:   Thu, 23 May 2019 15:33:36 -0700
Message-Id: <20190523223340.13449-12-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523223340.13449-1-jeffrey.t.kirsher@intel.com>
References: <20190523223340.13449-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesse Brandeburg <jesse.brandeburg@intel.com>

Use more efficient structure ordering by using the pahole tool
and a lot of code inspection to get hot cache lines to have
packed data (no holes if possible) and adjacent warm data.

ice_ring prior to this change:
  /* size: 192, cachelines: 3, members: 23 */
  /* sum members: 158, holes: 4, sum holes: 12 */
  /* padding: 22 */

ice_ring after this change:
  /* size: 192, cachelines: 3, members: 25 */
  /* sum members: 162, holes: 1, sum holes: 1 */
  /* padding: 29 */

ice_tx_buf prior to this change:
  /* size: 48, cachelines: 1, members: 7 */
  /* sum members: 38, holes: 2, sum holes: 6 */
  /* padding: 4 */
  /* last cacheline: 48 bytes */

ice_tx_buf after this change:
  /* size: 40, cachelines: 1, members: 7 */
  /* sum members: 38, holes: 1, sum holes: 2 */
  /* last cacheline: 40 bytes */

Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_txrx.h | 35 ++++++++++++++---------
 1 file changed, 21 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.h b/drivers/net/ethernet/intel/ice/ice_txrx.h
index 66e05032ee56..4cff52ffefe0 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.h
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.h
@@ -58,19 +58,19 @@ struct ice_tx_buf {
 	unsigned int bytecount;
 	unsigned short gso_segs;
 	u32 tx_flags;
-	DEFINE_DMA_UNMAP_ADDR(dma);
 	DEFINE_DMA_UNMAP_LEN(len);
+	DEFINE_DMA_UNMAP_ADDR(dma);
 };
 
 struct ice_tx_offload_params {
-	u8 header_len;
+	u64 cd_qw1;
+	struct ice_ring *tx_ring;
 	u32 td_cmd;
 	u32 td_offset;
 	u32 td_l2tag1;
-	u16 cd_l2tag2;
 	u32 cd_tunnel_params;
-	u64 cd_qw1;
-	struct ice_ring *tx_ring;
+	u16 cd_l2tag2;
+	u8 header_len;
 };
 
 struct ice_rx_buf {
@@ -150,6 +150,7 @@ enum ice_rx_dtype {
 
 /* descriptor ring, associated with a VSI */
 struct ice_ring {
+	/* CL1 - 1st cacheline starts here */
 	struct ice_ring *next;		/* pointer to next ring in q_vector */
 	void *desc;			/* Descriptor ring memory */
 	struct device *dev;		/* Used for DMA mapping */
@@ -161,11 +162,11 @@ struct ice_ring {
 		struct ice_tx_buf *tx_buf;
 		struct ice_rx_buf *rx_buf;
 	};
+	/* CL2 - 2nd cacheline starts here */
 	u16 q_index;			/* Queue number of ring */
-	u32 txq_teid;			/* Added Tx queue TEID */
-#ifdef CONFIG_DCB
-	u8 dcb_tc;		/* Traffic class of ring */
-#endif /* CONFIG_DCB */
+	u16 q_handle;			/* Queue handle per TC */
+
+	u8 ring_active;			/* is ring online or not */
 
 	u16 count;			/* Number of descriptors */
 	u16 reg_idx;			/* HW register index of the ring */
@@ -173,8 +174,7 @@ struct ice_ring {
 	/* used in interrupt processing */
 	u16 next_to_use;
 	u16 next_to_clean;
-
-	u8 ring_active;			/* is ring online or not */
+	u16 next_to_alloc;
 
 	/* stats structs */
 	struct ice_q_stats	stats;
@@ -184,10 +184,17 @@ struct ice_ring {
 		struct ice_rxq_stats rx_stats;
 	};
 
-	unsigned int size;		/* length of descriptor ring in bytes */
-	dma_addr_t dma;			/* physical address of ring */
 	struct rcu_head rcu;		/* to avoid race on free */
-	u16 next_to_alloc;
+	/* CLX - the below items are only accessed infrequently and should be
+	 * in their own cache line if possible
+	 */
+	dma_addr_t dma;			/* physical address of ring */
+	unsigned int size;		/* length of descriptor ring in bytes */
+	u32 txq_teid;			/* Added Tx queue TEID */
+	u16 rx_buf_len;
+#ifdef CONFIG_DCB
+	u8 dcb_tc;			/* Traffic class of ring */
+#endif /* CONFIG_DCB */
 } ____cacheline_internodealigned_in_smp;
 
 struct ice_ring_container {
-- 
2.21.0

