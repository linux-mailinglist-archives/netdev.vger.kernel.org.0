Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC026452BAD
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 08:38:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230415AbhKPHls (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 02:41:48 -0500
Received: from mga11.intel.com ([192.55.52.93]:42900 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230403AbhKPHln (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 02:41:43 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10169"; a="231099102"
X-IronPort-AV: E=Sophos;i="5.87,238,1631602800"; 
   d="scan'208";a="231099102"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2021 23:38:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,238,1631602800"; 
   d="scan'208";a="671857381"
Received: from silpixa00401086.ir.intel.com (HELO localhost.localdomain) ([10.55.129.110])
  by orsmga005.jf.intel.com with ESMTP; 15 Nov 2021 23:38:43 -0800
From:   Ciara Loftus <ciara.loftus@intel.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        kuba@kernel.org, hawk@kernel.org, john.fastabend@gmail.com,
        toke@redhat.com, bjorn@kernel.org, magnus.karlsson@intel.com,
        jonathan.lemon@gmail.com, maciej.fijalkowski@intel.com,
        Ciara Loftus <ciara.loftus@intel.com>,
        Cristian Dumitrescu <cristian.dumitrescu@intel.com>
Subject: [RFC PATCH bpf-next 7/8] i40e: introduce batched XDP rx descriptor processing
Date:   Tue, 16 Nov 2021 07:37:41 +0000
Message-Id: <20211116073742.7941-8-ciara.loftus@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211116073742.7941-1-ciara.loftus@intel.com>
References: <20211116073742.7941-1-ciara.loftus@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce batched processing of XDP frames in the i40e driver. The batch
size is fixed at 64.

First, the driver performs a lookahead in the rx ring to determine if
there are 64 contiguous descriptors available to be processed. If so,
and if the action returned from the bpf program run for each of the 64
descriptors is XDP_REDIRECT_XSK, the new xsk_rcv_batch API is used to
push the batch to the XDP socket Rx ring.

Logic to fallback to scalar processing is included for situations where
batch processing is not possible eg. not enough descriptors, ring wrap,
different actions returned from bpf program, etc.

Signed-off-by: Ciara Loftus <ciara.loftus@intel.com>
Signed-off-by: Cristian Dumitrescu <cristian.dumitrescu@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_xsk.c | 219 +++++++++++++++++++--
 1 file changed, 200 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
index c994b4d9c38a..a578bb7b3b99 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
@@ -10,6 +10,9 @@
 #include "i40e_txrx_common.h"
 #include "i40e_xsk.h"
 
+#define I40E_DESCS_PER_BATCH 64
+#define I40E_XSK_BATCH_MASK ~(I40E_DESCS_PER_BATCH - 1)
+
 int i40e_alloc_rx_bi_zc(struct i40e_ring *rx_ring)
 {
 	unsigned long sz = sizeof(*rx_ring->rx_bi_zc) * rx_ring->count;
@@ -139,26 +142,12 @@ int i40e_xsk_pool_setup(struct i40e_vsi *vsi, struct xsk_buff_pool *pool,
 		i40e_xsk_pool_disable(vsi, qid);
 }
 
-/**
- * i40e_run_xdp_zc - Executes an XDP program on an xdp_buff
- * @rx_ring: Rx ring
- * @xdp: xdp_buff used as input to the XDP program
- *
- * Returns any of I40E_XDP_{PASS, CONSUMED, TX, REDIR, REDIR_XSK}
- **/
-static int i40e_run_xdp_zc(struct i40e_ring *rx_ring, struct xdp_buff *xdp)
+static int i40e_handle_xdp_action(struct i40e_ring *rx_ring, struct xdp_buff *xdp,
+				  struct bpf_prog *xdp_prog, u32 act)
 {
 	int err, result = I40E_XDP_PASS;
 	struct i40e_ring *xdp_ring;
-	struct bpf_prog *xdp_prog;
 	struct xdp_sock *xs;
-	u32 act;
-
-	/* NB! xdp_prog will always be !NULL, due to the fact that
-	 * this path is enabled by setting an XDP program.
-	 */
-	xdp_prog = READ_ONCE(rx_ring->xdp_prog);
-	act = bpf_prog_run_xdp(xdp_prog, xdp);
 
 	if (likely(act == XDP_REDIRECT_XSK)) {
 		xs = xsk_get_redirect_xsk(&rx_ring->netdev->_rx[xdp->rxq->queue_index]);
@@ -197,6 +186,21 @@ static int i40e_run_xdp_zc(struct i40e_ring *rx_ring, struct xdp_buff *xdp)
 	return result;
 }
 
+/**
+ * i40e_run_xdp_zc - Executes an XDP program on an xdp_buff
+ * @rx_ring: Rx ring
+ * @xdp: xdp_buff used as input to the XDP program
+ *
+ * Returns any of I40E_XDP_{PASS, CONSUMED, TX, REDIR, REDIR_XSK}
+ **/
+static int i40e_run_xdp_zc(struct i40e_ring *rx_ring, struct xdp_buff *xdp,
+			   struct bpf_prog *xdp_prog)
+{
+	u32 act = bpf_prog_run_xdp(xdp_prog, xdp);
+
+	return i40e_handle_xdp_action(rx_ring, xdp, xdp_prog, act);
+}
+
 bool i40e_alloc_rx_buffers_zc(struct i40e_ring *rx_ring, u16 count)
 {
 	u16 ntu = rx_ring->next_to_use;
@@ -218,6 +222,7 @@ bool i40e_alloc_rx_buffers_zc(struct i40e_ring *rx_ring, u16 count)
 		dma = xsk_buff_xdp_get_dma(*xdp);
 		rx_desc->read.pkt_addr = cpu_to_le64(dma);
 		rx_desc->read.hdr_addr = 0;
+		rx_desc->wb.qword1.status_error_len = 0;
 
 		rx_desc++;
 		xdp++;
@@ -324,6 +329,7 @@ static void i40e_handle_xdp_result_zc(struct i40e_ring *rx_ring,
 }
 
 static inline void i40e_clean_rx_desc_zc(struct i40e_ring *rx_ring,
+					 struct bpf_prog *xdp_prog,
 					 unsigned int *stat_rx_packets,
 					 unsigned int *stat_rx_bytes,
 					 unsigned int *xmit,
@@ -370,7 +376,7 @@ static inline void i40e_clean_rx_desc_zc(struct i40e_ring *rx_ring,
 		xsk_buff_set_size(bi, size);
 		xsk_buff_dma_sync_for_cpu(bi, rx_ring->xsk_pool);
 
-		xdp_res = i40e_run_xdp_zc(rx_ring, bi);
+		xdp_res = i40e_run_xdp_zc(rx_ring, bi, xdp_prog);
 		i40e_handle_xdp_result_zc(rx_ring, bi, rx_desc, &rx_packets,
 					  &rx_bytes, size, xdp_res);
 		total_rx_packets += rx_packets;
@@ -385,6 +391,172 @@ static inline void i40e_clean_rx_desc_zc(struct i40e_ring *rx_ring,
 	*xmit = xdp_xmit;
 }
 
+/**
+ * i40_rx_ring_lookahead - check for new descriptors in the rx ring
+ * @rx_ring: Rx ring
+ * @budget: NAPI budget
+ *
+ * Returns the number of available descriptors in contiguous memory ie.
+ * without a ring wrap.
+ *
+ **/
+static inline unsigned int i40_rx_ring_lookahead(struct i40e_ring *rx_ring,
+						 unsigned int budget)
+{
+	u32 used = (rx_ring->next_to_clean - rx_ring->next_to_use - 1) & (rx_ring->count - 1);
+	union i40e_rx_desc *rx_desc0 = (union i40e_rx_desc *)rx_ring->desc, *rx_desc;
+	u32 next_to_clean = rx_ring->next_to_clean;
+	u32 potential = rx_ring->count - used;
+	u16 count_mask = rx_ring->count - 1;
+	unsigned int size;
+	u64 qword;
+
+	budget &= I40E_XSK_BATCH_MASK;
+
+	while (budget) {
+		if (budget > potential)
+			goto next;
+		rx_desc = rx_desc0 + ((next_to_clean + budget - 1) & count_mask);
+		qword = le64_to_cpu(rx_desc->wb.qword1.status_error_len);
+		dma_rmb();
+
+		size = (qword & I40E_RXD_QW1_LENGTH_PBUF_MASK) >>
+			I40E_RXD_QW1_LENGTH_PBUF_SHIFT;
+		if (size && ((next_to_clean + budget) <= count_mask))
+			return budget;
+
+next:
+		budget >>= 1;
+		budget &= I40E_XSK_BATCH_MASK;
+	}
+
+	return 0;
+}
+
+/**
+ * i40e_run_xdp_zc_batch - Executes an XDP program on an array of xdp_buffs
+ * @rx_ring: Rx ring
+ * @bufs: array of xdp_buffs used as input to the XDP program
+ * @res: array of ints with result for each buf if an error occurs or slow path taken.
+ *
+ * Returns zero if all xdp_buffs successfully took the fast path (XDP_REDIRECT_XSK).
+ * Otherwise returns -1 and sets individual results for each buf in the array *res.
+ * Individual results are one of I40E_XDP_{PASS, CONSUMED, TX, REDIR, REDIR_XSK}
+ **/
+static int i40e_run_xdp_zc_batch(struct i40e_ring *rx_ring, struct xdp_buff **bufs,
+				 struct bpf_prog *xdp_prog, int *res)
+{
+	u32 last_act = XDP_REDIRECT_XSK;
+	int runs = 0, ret = 0, err, i;
+
+	while ((runs < I40E_DESCS_PER_BATCH) && (last_act == XDP_REDIRECT_XSK))
+		last_act = bpf_prog_run_xdp(xdp_prog, *(bufs + runs++));
+
+	if (likely(runs == I40E_DESCS_PER_BATCH)) {
+		struct xdp_sock *xs =
+			xsk_get_redirect_xsk(&rx_ring->netdev->_rx[(*bufs)->rxq->queue_index]);
+
+		err = xsk_rcv_batch(xs, bufs, I40E_DESCS_PER_BATCH);
+		if (unlikely(err)) {
+			ret = -1;
+			for (i = 0; i < I40E_DESCS_PER_BATCH; i++)
+				*(res + i) = I40E_XDP_PASS;
+		}
+	} else {
+		/* Handle the result of each program run individually */
+		u32 act;
+
+		ret = -1;
+		for (i = 0; i < I40E_DESCS_PER_BATCH; i++) {
+			struct xdp_buff *xdp = *(bufs + i);
+
+			/* The result of the first runs-2 programs was XDP_REDIRECT_XSK.
+			 * The result of the subsequent program run was last_act.
+			 * Any remaining bufs have not yet had the program executed, so
+			 * execute it now.
+			 */
+
+			if (i < runs - 2)
+				act = XDP_REDIRECT_XSK;
+			else if (i == runs - 1)
+				act = last_act;
+			else
+				act = bpf_prog_run_xdp(xdp_prog, xdp);
+
+			*(res + i) = i40e_handle_xdp_action(rx_ring, xdp, xdp_prog, act);
+		}
+	}
+
+	return ret;
+}
+
+static inline void i40e_clean_rx_desc_zc_batch(struct i40e_ring *rx_ring,
+					       struct bpf_prog *xdp_prog,
+					       unsigned int *total_rx_packets,
+					       unsigned int *total_rx_bytes,
+					       unsigned int *xdp_xmit)
+{
+	u16 next_to_clean = rx_ring->next_to_clean;
+	unsigned int xdp_res[I40E_DESCS_PER_BATCH];
+	unsigned int size[I40E_DESCS_PER_BATCH];
+	unsigned int rx_packets, rx_bytes = 0;
+	union i40e_rx_desc *rx_desc;
+	struct xdp_buff **bufs;
+	int j, ret;
+	u64 qword;
+
+	rx_desc = I40E_RX_DESC(rx_ring, next_to_clean);
+
+	prefetch(rx_desc + I40E_DESCS_PER_BATCH);
+
+	for (j = 0; j < I40E_DESCS_PER_BATCH; j++) {
+		qword = le64_to_cpu((rx_desc + j)->wb.qword1.status_error_len);
+		size[j] = (qword & I40E_RXD_QW1_LENGTH_PBUF_MASK) >>
+			I40E_RXD_QW1_LENGTH_PBUF_SHIFT;
+	}
+
+	/* This memory barrier is needed to keep us from reading
+	 * any other fields out of the rx_descs until we have
+	 * verified the descriptors have been written back.
+	 */
+	dma_rmb();
+
+	bufs = i40e_rx_bi(rx_ring, next_to_clean);
+
+	for (j = 0; j < I40E_DESCS_PER_BATCH; j++)
+		xsk_buff_set_size(*(bufs + j), size[j]);
+
+	xsk_buff_dma_sync_for_cpu_batch(bufs, rx_ring->xsk_pool, I40E_DESCS_PER_BATCH);
+
+	ret = i40e_run_xdp_zc_batch(rx_ring, bufs, xdp_prog, xdp_res);
+
+	if (unlikely(ret)) {
+		unsigned int err_rx_packets = 0, err_rx_bytes = 0;
+
+		rx_packets = 0;
+		rx_bytes = 0;
+
+		for (j = 0; j < I40E_DESCS_PER_BATCH; j++) {
+			i40e_handle_xdp_result_zc(rx_ring, *(bufs + j), rx_desc + j,
+						  &err_rx_packets, &err_rx_bytes, size[j],
+						  xdp_res[j]);
+			*xdp_xmit |= (xdp_res[j] & (I40E_XDP_TX | I40E_XDP_REDIR |
+						    I40E_XDP_REDIR_XSK));
+			rx_packets += err_rx_packets;
+			rx_bytes += err_rx_bytes;
+		}
+	} else {
+		rx_packets = I40E_DESCS_PER_BATCH;
+		for (j = 0; j < I40E_DESCS_PER_BATCH; j++)
+			rx_bytes += size[j];
+		*xdp_xmit |= I40E_XDP_REDIR_XSK;
+	}
+
+	rx_ring->next_to_clean += I40E_DESCS_PER_BATCH;
+	*total_rx_packets += rx_packets;
+	*total_rx_bytes += rx_bytes;
+}
+
 /**
  * i40e_clean_rx_irq_zc - Consumes Rx packets from the hardware ring
  * @rx_ring: Rx ring
@@ -394,17 +566,26 @@ static inline void i40e_clean_rx_desc_zc(struct i40e_ring *rx_ring,
  **/
 int i40e_clean_rx_irq_zc(struct i40e_ring *rx_ring, int budget)
 {
+	int batch_budget = i40_rx_ring_lookahead(rx_ring, (unsigned int)budget);
+	struct bpf_prog *xdp_prog = READ_ONCE(rx_ring->xdp_prog);
 	unsigned int total_rx_bytes = 0, total_rx_packets = 0;
 	u16 count_mask = rx_ring->count - 1;
 	unsigned int xdp_xmit = 0;
 	bool failure = false;
 	u16 cleaned_count;
+	int i;
+
+	for (i = 0; i < batch_budget; i += I40E_DESCS_PER_BATCH)
+		i40e_clean_rx_desc_zc_batch(rx_ring, xdp_prog,
+					    &total_rx_packets,
+					    &total_rx_bytes,
+					    &xdp_xmit);
 
-	i40e_clean_rx_desc_zc(rx_ring,
+	i40e_clean_rx_desc_zc(rx_ring, xdp_prog,
 			      &total_rx_packets,
 			      &total_rx_bytes,
 			      &xdp_xmit,
-			      budget);
+			      (unsigned int)budget - total_rx_packets);
 
 	cleaned_count = (rx_ring->next_to_clean - rx_ring->next_to_use - 1) & count_mask;
 
-- 
2.17.1

