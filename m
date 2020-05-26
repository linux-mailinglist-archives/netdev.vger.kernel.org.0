Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 954721C871C
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 12:43:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727092AbgEGKno (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 06:43:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725900AbgEGKno (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 06:43:44 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19B84C061A10;
        Thu,  7 May 2020 03:43:43 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id m7so1915745plt.5;
        Thu, 07 May 2020 03:43:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pWvsOuMLvH1eim1ftEnnjksk3Cs+CaSVyKpefRhNORY=;
        b=ImzulTWHVKki+QvKwQsvNW2IIFlYnQpIa7Zj8oCxdGRmV0chu05bt7wawDw2VJqAOh
         gh7AbDVjoGyHANYhiaUtTK3cmwJ9/lyqkfx1hOrk8Vs6h9dwFlldEjWK0L6Q2Pcl2YXw
         QAe16Nkcp9I7oQ4AgH+t9o/KWbK/EuHJKIr72dTOYBTsK5lRjCm6ibfhFjIZwVoXldEt
         MN7oVsq0p7zzYGNo5Ci3Ng0JUvHbS/eAhwc+2FDINFwsrPgvG20WF8p5UO3AZkEI2GVW
         HEUm3ybl4e6h9+mexMK78o1ZKcTIl8QIWNFscatqo3qrqvVonLxIdDmYdzz/WWErrVUn
         RvRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pWvsOuMLvH1eim1ftEnnjksk3Cs+CaSVyKpefRhNORY=;
        b=HE9UNn75BWbKdlQg/67uCvrxlOK+9EXHVoF2p+rN9Dcs/6GXzSLoEP/uscvNPQ17hS
         st3tstTi/hgz1q8iJDi4zShMAjpRm4Nsmpx5mhKywuNlx+sYvBvf3fGwxsrOF3ii+TxF
         RIYV8Qozi4Ue/99kX693j6SSFx7RdEx48vtQiJ/2NkjLkSQLxdMJdtoD2Dy78ryopKHV
         x1EIn/GvDkXQiK5dcdVVtZWhPC+8yfJ5Mj7q+5gCjnJQyFabeOhtYToOMM6IDPvdjJCr
         SXgvmA4VhrSs1hbNh+8CyUP2UdWWeQoCqtZ8G2dTks6sCM+t5/wNFOpF7AV68jEZakRn
         tSeg==
X-Gm-Message-State: AGi0PuaGMu5Bs+rlsNa2JwG3SO7YW/jpd+AVXEKTxmbBiUps+XSX2d+J
        3ltxPpwgv0/CGcllTvVD6c4=
X-Google-Smtp-Source: APiQypK+PEG7cY6Q+PbKAYteXSPOcNO05O55kl/hcI3Jrrej9utwMqTRMEg5wVqvvzSWfJvMfrToKA==
X-Received: by 2002:a17:90a:1998:: with SMTP id 24mr15215522pji.0.1588848222512;
        Thu, 07 May 2020 03:43:42 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com ([192.55.55.43])
        by smtp.gmail.com with ESMTPSA id j14sm7450673pjm.27.2020.05.07.03.43.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2020 03:43:41 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        kuba@kernel.org, hawk@kernel.org, john.fastabend@gmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com,
        jeffrey.t.kirsher@intel.com
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        maximmi@mellanox.com, maciej.fijalkowski@intel.com,
        intel-wired-lan@lists.osuosl.org
Subject: [PATCH bpf-next 06/14] i40e: separate kernel allocated rx_bi rings from AF_XDP rings
Date:   Thu,  7 May 2020 12:42:44 +0200
Message-Id: <20200507104252.544114-7-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200507104252.544114-1-bjorn.topel@gmail.com>
References: <20200507104252.544114-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

Continuing the path to support MEM_TYPE_XSK_BUFF_POOL, the AF_XDP
zero-copy/sk_buff rx_bi rings are now separate. Functions to properly
allocate the different rings are added as well.

Cc: intel-wired-lan@lists.osuosl.org
Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c   |   7 ++
 drivers/net/ethernet/intel/i40e/i40e_txrx.c   | 119 +++++++-----------
 drivers/net/ethernet/intel/i40e/i40e_txrx.h   |  22 ++--
 .../ethernet/intel/i40e/i40e_txrx_common.h    |  40 +++++-
 drivers/net/ethernet/intel/i40e/i40e_type.h   |   5 +-
 drivers/net/ethernet/intel/i40e/i40e_xsk.c    |  74 ++++++-----
 drivers/net/ethernet/intel/i40e/i40e_xsk.h    |   2 +
 7 files changed, 142 insertions(+), 127 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index d6b2db4f2c65..3e1695bb8262 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -3260,8 +3260,12 @@ static int i40e_configure_rx_ring(struct i40e_ring *ring)
 	if (ring->vsi->type == I40E_VSI_MAIN)
 		xdp_rxq_info_unreg_mem_model(&ring->xdp_rxq);
 
+	kfree(ring->rx_bi);
 	ring->xsk_umem = i40e_xsk_umem(ring);
 	if (ring->xsk_umem) {
+		ret = i40e_alloc_rx_bi_zc(ring);
+		if (ret)
+			return ret;
 		ring->rx_buf_len = ring->xsk_umem->chunk_size_nohr -
 				   XDP_PACKET_HEADROOM;
 		/* For AF_XDP ZC, we disallow packets to span on
@@ -3280,6 +3284,9 @@ static int i40e_configure_rx_ring(struct i40e_ring *ring)
 			 ring->queue_index);
 
 	} else {
+		ret = i40e_alloc_rx_bi(ring);
+		if (ret)
+			return ret;
 		ring->rx_buf_len = vsi->rx_buf_len;
 		if (ring->vsi->type == I40E_VSI_MAIN) {
 			ret = xdp_rxq_info_reg_mem_model(&ring->xdp_rxq,
diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
index 58daba8fabc8..f063df623443 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -521,28 +521,29 @@ int i40e_add_del_fdir(struct i40e_vsi *vsi,
 /**
  * i40e_fd_handle_status - check the Programming Status for FD
  * @rx_ring: the Rx ring for this descriptor
- * @rx_desc: the Rx descriptor for programming Status, not a packet descriptor.
+ * @qword0_raw: qword0
+ * @qword1: qword1 after le_to_cpu
  * @prog_id: the id originally used for programming
  *
  * This is used to verify if the FD programming or invalidation
  * requested by SW to the HW is successful or not and take actions accordingly.
  **/
-void i40e_fd_handle_status(struct i40e_ring *rx_ring,
-			   union i40e_rx_desc *rx_desc, u8 prog_id)
+void i40e_fd_handle_status(struct i40e_ring *rx_ring, u64 qword0_raw,
+			   u64 qword1, u8 prog_id)
 {
 	struct i40e_pf *pf = rx_ring->vsi->back;
 	struct pci_dev *pdev = pf->pdev;
+	struct i40e_32b_rx_wb_qw0 *qw0;
 	u32 fcnt_prog, fcnt_avail;
 	u32 error;
-	u64 qw;
 
-	qw = le64_to_cpu(rx_desc->wb.qword1.status_error_len);
-	error = (qw & I40E_RX_PROG_STATUS_DESC_QW1_ERROR_MASK) >>
+	qw0 = (struct i40e_32b_rx_wb_qw0 *)&qword0_raw;
+	error = (qword1 & I40E_RX_PROG_STATUS_DESC_QW1_ERROR_MASK) >>
 		I40E_RX_PROG_STATUS_DESC_QW1_ERROR_SHIFT;
 
 	if (error == BIT(I40E_RX_PROG_STATUS_DESC_FD_TBL_FULL_SHIFT)) {
-		pf->fd_inv = le32_to_cpu(rx_desc->wb.qword0.hi_dword.fd_id);
-		if ((rx_desc->wb.qword0.hi_dword.fd_id != 0) ||
+		pf->fd_inv = le32_to_cpu(qw0->hi_dword.fd_id);
+		if (qw0->hi_dword.fd_id != 0 ||
 		    (I40E_DEBUG_FD & pf->hw.debug_mask))
 			dev_warn(&pdev->dev, "ntuple filter loc = %d, could not be added\n",
 				 pf->fd_inv);
@@ -560,7 +561,7 @@ void i40e_fd_handle_status(struct i40e_ring *rx_ring,
 		/* store the current atr filter count */
 		pf->fd_atr_cnt = i40e_get_current_atr_cnt(pf);
 
-		if ((rx_desc->wb.qword0.hi_dword.fd_id == 0) &&
+		if (qw0->hi_dword.fd_id == 0 &&
 		    test_bit(__I40E_FD_SB_AUTO_DISABLED, pf->state)) {
 			/* These set_bit() calls aren't atomic with the
 			 * test_bit() here, but worse case we potentially
@@ -589,7 +590,7 @@ void i40e_fd_handle_status(struct i40e_ring *rx_ring,
 	} else if (error == BIT(I40E_RX_PROG_STATUS_DESC_NO_FD_ENTRY_SHIFT)) {
 		if (I40E_DEBUG_FD & pf->hw.debug_mask)
 			dev_info(&pdev->dev, "ntuple filter fd_id = %d, could not be removed\n",
-				 rx_desc->wb.qword0.hi_dword.fd_id);
+				 qw0->hi_dword.fd_id);
 	}
 }
 
@@ -1232,29 +1233,10 @@ static void i40e_reuse_rx_page(struct i40e_ring *rx_ring,
 }
 
 /**
- * i40e_rx_is_programming_status - check for programming status descriptor
- * @qw: qword representing status_error_len in CPU ordering
- *
- * The value of in the descriptor length field indicate if this
- * is a programming status descriptor for flow director or FCoE
- * by the value of I40E_RX_PROG_STATUS_DESC_LENGTH, otherwise
- * it is a packet descriptor.
- **/
-static inline bool i40e_rx_is_programming_status(u64 qw)
-{
-	/* The Rx filter programming status and SPH bit occupy the same
-	 * spot in the descriptor. Since we don't support packet split we
-	 * can just reuse the bit as an indication that this is a
-	 * programming status descriptor.
-	 */
-	return qw & I40E_RXD_QW1_LENGTH_SPH_MASK;
-}
-
-/**
- * i40e_clean_programming_status - try clean the programming status descriptor
+ * i40e_clean_programming_status - clean the programming status descriptor
  * @rx_ring: the rx ring that has this descriptor
- * @rx_desc: the rx descriptor written back by HW
- * @qw: qword representing status_error_len in CPU ordering
+ * @qword0: qword0
+ * @qword1: qword1 representing status_error_len in CPU ordering
  *
  * Flow director should handle FD_FILTER_STATUS to check its filter programming
  * status being successful or not and take actions accordingly. FCoE should
@@ -1262,34 +1244,16 @@ static inline bool i40e_rx_is_programming_status(u64 qw)
  *
  * Returns an i40e_rx_buffer to reuse if the cleanup occurred, otherwise NULL.
  **/
-struct i40e_rx_buffer *i40e_clean_programming_status(
-	struct i40e_ring *rx_ring,
-	union i40e_rx_desc *rx_desc,
-	u64 qw)
+void i40e_clean_programming_status(struct i40e_ring *rx_ring, u64 qword0_raw,
+				   u64 qword1)
 {
-	struct i40e_rx_buffer *rx_buffer;
-	u32 ntc;
 	u8 id;
 
-	if (!i40e_rx_is_programming_status(qw))
-		return NULL;
-
-	ntc = rx_ring->next_to_clean;
-
-	/* fetch, update, and store next to clean */
-	rx_buffer = i40e_rx_bi(rx_ring, ntc++);
-	ntc = (ntc < rx_ring->count) ? ntc : 0;
-	rx_ring->next_to_clean = ntc;
-
-	prefetch(I40E_RX_DESC(rx_ring, ntc));
-
-	id = (qw & I40E_RX_PROG_STATUS_DESC_QW1_PROGID_MASK) >>
+	id = (qword1 & I40E_RX_PROG_STATUS_DESC_QW1_PROGID_MASK) >>
 		  I40E_RX_PROG_STATUS_DESC_QW1_PROGID_SHIFT;
 
 	if (id == I40E_RX_PROG_STATUS_DESC_FD_FILTER_STATUS)
-		i40e_fd_handle_status(rx_ring, rx_desc, id);
-
-	return rx_buffer;
+		i40e_fd_handle_status(rx_ring, qword0_raw, qword1, id);
 }
 
 /**
@@ -1341,13 +1305,25 @@ int i40e_setup_tx_descriptors(struct i40e_ring *tx_ring)
 	return -ENOMEM;
 }
 
+int i40e_alloc_rx_bi(struct i40e_ring *rx_ring)
+{
+	unsigned long sz = sizeof(*rx_ring->rx_bi) * rx_ring->count;
+
+	rx_ring->rx_bi = kzalloc(sz, GFP_KERNEL);
+	return rx_ring->rx_bi ? 0 : -ENOMEM;
+}
+
+static void i40e_clear_rx_bi(struct i40e_ring *rx_ring)
+{
+	memset(rx_ring->rx_bi, 0, sizeof(*rx_ring->rx_bi) * rx_ring->count);
+}
+
 /**
  * i40e_clean_rx_ring - Free Rx buffers
  * @rx_ring: ring to be cleaned
  **/
 void i40e_clean_rx_ring(struct i40e_ring *rx_ring)
 {
-	unsigned long bi_size;
 	u16 i;
 
 	/* ring already cleared, nothing to do */
@@ -1393,8 +1369,10 @@ void i40e_clean_rx_ring(struct i40e_ring *rx_ring)
 	}
 
 skip_free:
-	bi_size = sizeof(struct i40e_rx_buffer) * rx_ring->count;
-	memset(rx_ring->rx_bi, 0, bi_size);
+	if (rx_ring->xsk_umem)
+		i40e_clear_rx_bi_zc(rx_ring);
+	else
+		i40e_clear_rx_bi(rx_ring);
 
 	/* Zero out the descriptor ring */
 	memset(rx_ring->desc, 0, rx_ring->size);
@@ -1435,15 +1413,7 @@ void i40e_free_rx_resources(struct i40e_ring *rx_ring)
 int i40e_setup_rx_descriptors(struct i40e_ring *rx_ring)
 {
 	struct device *dev = rx_ring->dev;
-	int err = -ENOMEM;
-	int bi_size;
-
-	/* warn if we are about to overwrite the pointer */
-	WARN_ON(rx_ring->rx_bi);
-	bi_size = sizeof(struct i40e_rx_buffer) * rx_ring->count;
-	rx_ring->rx_bi = kzalloc(bi_size, GFP_KERNEL);
-	if (!rx_ring->rx_bi)
-		goto err;
+	int err;
 
 	u64_stats_init(&rx_ring->syncp);
 
@@ -1456,7 +1426,7 @@ int i40e_setup_rx_descriptors(struct i40e_ring *rx_ring)
 	if (!rx_ring->desc) {
 		dev_info(dev, "Unable to allocate memory for the Rx descriptor ring, size=%d\n",
 			 rx_ring->size);
-		goto err;
+		return -ENOMEM;
 	}
 
 	rx_ring->next_to_alloc = 0;
@@ -1468,16 +1438,12 @@ int i40e_setup_rx_descriptors(struct i40e_ring *rx_ring)
 		err = xdp_rxq_info_reg(&rx_ring->xdp_rxq, rx_ring->netdev,
 				       rx_ring->queue_index);
 		if (err < 0)
-			goto err;
+			return err;
 	}
 
 	rx_ring->xdp_prog = rx_ring->vsi->xdp_prog;
 
 	return 0;
-err:
-	kfree(rx_ring->rx_bi);
-	rx_ring->rx_bi = NULL;
-	return err;
 }
 
 /**
@@ -2370,9 +2336,12 @@ static int i40e_clean_rx_irq(struct i40e_ring *rx_ring, int budget)
 		 */
 		dma_rmb();
 
-		rx_buffer = i40e_clean_programming_status(rx_ring, rx_desc,
-							  qword);
-		if (unlikely(rx_buffer)) {
+		if (i40e_rx_is_programming_status(qword)) {
+			i40e_clean_programming_status(rx_ring,
+						      rx_desc->raw.qword[0],
+						      qword);
+			rx_buffer = i40e_rx_bi(rx_ring, rx_ring->next_to_clean);
+			i40e_inc_ntc(rx_ring);
 			i40e_reuse_rx_page(rx_ring, rx_buffer);
 			cleaned_count++;
 			continue;
diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.h b/drivers/net/ethernet/intel/i40e/i40e_txrx.h
index 36d37f31a287..d343498e8de5 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.h
@@ -296,17 +296,15 @@ struct i40e_tx_buffer {
 
 struct i40e_rx_buffer {
 	dma_addr_t dma;
-	union {
-		struct {
-			struct page *page;
-			__u32 page_offset;
-			__u16 pagecnt_bias;
-		};
-		struct {
-			void *addr;
-			u64 handle;
-		};
-	};
+	struct page *page;
+	__u32 page_offset;
+	__u16 pagecnt_bias;
+};
+
+struct i40e_rx_buffer_zc {
+	dma_addr_t dma;
+	void *addr;
+	u64 handle;
 };
 
 struct i40e_queue_stats {
@@ -358,6 +356,7 @@ struct i40e_ring {
 	union {
 		struct i40e_tx_buffer *tx_bi;
 		struct i40e_rx_buffer *rx_bi;
+		struct i40e_rx_buffer_zc *rx_bi_zc;
 	};
 	DECLARE_BITMAP(state, __I40E_RING_STATE_NBITS);
 	u16 queue_index;		/* Queue number of ring */
@@ -495,6 +494,7 @@ int __i40e_maybe_stop_tx(struct i40e_ring *tx_ring, int size);
 bool __i40e_chk_linearize(struct sk_buff *skb);
 int i40e_xdp_xmit(struct net_device *dev, int n, struct xdp_frame **frames,
 		  u32 flags);
+int i40e_alloc_rx_bi(struct i40e_ring *rx_ring);
 
 /**
  * i40e_get_head - Retrieve head from head writeback
diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx_common.h b/drivers/net/ethernet/intel/i40e/i40e_txrx_common.h
index 8af0e99c6c0d..667c4dc4b39f 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx_common.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx_common.h
@@ -4,13 +4,9 @@
 #ifndef I40E_TXRX_COMMON_
 #define I40E_TXRX_COMMON_
 
-void i40e_fd_handle_status(struct i40e_ring *rx_ring,
-			   union i40e_rx_desc *rx_desc, u8 prog_id);
 int i40e_xmit_xdp_tx_ring(struct xdp_buff *xdp, struct i40e_ring *xdp_ring);
-struct i40e_rx_buffer *i40e_clean_programming_status(
-	struct i40e_ring *rx_ring,
-	union i40e_rx_desc *rx_desc,
-	u64 qw);
+void i40e_clean_programming_status(struct i40e_ring *rx_ring, u64 qword0_raw,
+				   u64 qword1);
 void i40e_process_skb_fields(struct i40e_ring *rx_ring,
 			     union i40e_rx_desc *rx_desc, struct sk_buff *skb);
 void i40e_xdp_ring_update_tail(struct i40e_ring *xdp_ring);
@@ -84,6 +80,38 @@ static inline void i40e_arm_wb(struct i40e_ring *tx_ring,
 	}
 }
 
+/**
+ * i40e_rx_is_programming_status - check for programming status descriptor
+ * @qword1: qword1 representing status_error_len in CPU ordering
+ *
+ * The value of in the descriptor length field indicate if this
+ * is a programming status descriptor for flow director or FCoE
+ * by the value of I40E_RX_PROG_STATUS_DESC_LENGTH, otherwise
+ * it is a packet descriptor.
+ **/
+static inline bool i40e_rx_is_programming_status(u64 qword1)
+{
+	/* The Rx filter programming status and SPH bit occupy the same
+	 * spot in the descriptor. Since we don't support packet split we
+	 * can just reuse the bit as an indication that this is a
+	 * programming status descriptor.
+	 */
+	return qword1 & I40E_RXD_QW1_LENGTH_SPH_MASK;
+}
+
+/**
+ * i40e_inc_ntc: Advance the next_to_clean index
+ * @rx_ring: Rx ring
+ **/
+static inline void i40e_inc_ntc(struct i40e_ring *rx_ring)
+{
+	u32 ntc = rx_ring->next_to_clean + 1;
+
+	ntc = (ntc < rx_ring->count) ? ntc : 0;
+	rx_ring->next_to_clean = ntc;
+	prefetch(I40E_RX_DESC(rx_ring, ntc));
+}
+
 void i40e_xsk_clean_rx_ring(struct i40e_ring *rx_ring);
 void i40e_xsk_clean_tx_ring(struct i40e_ring *tx_ring);
 bool i40e_xsk_any_rx_ring_enabled(struct i40e_vsi *vsi);
diff --git a/drivers/net/ethernet/intel/i40e/i40e_type.h b/drivers/net/ethernet/intel/i40e/i40e_type.h
index 6ea2867ff60f..63e098f7cb63 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_type.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_type.h
@@ -689,7 +689,7 @@ union i40e_32byte_rx_desc {
 		__le64  rsvd2;
 	} read;
 	struct {
-		struct {
+		struct i40e_32b_rx_wb_qw0 {
 			struct {
 				union {
 					__le16 mirroring_status;
@@ -727,6 +727,9 @@ union i40e_32byte_rx_desc {
 			} hi_dword;
 		} qword3;
 	} wb;  /* writeback */
+	struct {
+		u64 qword[4];
+	} raw;
 };
 
 enum i40e_rx_desc_status_bits {
diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
index 8d29477bb0b6..4fce057f1eec 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
@@ -9,9 +9,23 @@
 #include "i40e_txrx_common.h"
 #include "i40e_xsk.h"
 
-static struct i40e_rx_buffer *i40e_rx_bi(struct i40e_ring *rx_ring, u32 idx)
+int i40e_alloc_rx_bi_zc(struct i40e_ring *rx_ring)
 {
-	return &rx_ring->rx_bi[idx];
+	unsigned long sz = sizeof(*rx_ring->rx_bi_zc) * rx_ring->count;
+
+	rx_ring->rx_bi_zc = kzalloc(sz, GFP_KERNEL);
+	return rx_ring->rx_bi_zc ? 0 : -ENOMEM;
+}
+
+void i40e_clear_rx_bi_zc(struct i40e_ring *rx_ring)
+{
+	memset(rx_ring->rx_bi_zc, 0,
+	       sizeof(*rx_ring->rx_bi_zc) * rx_ring->count);
+}
+
+static struct i40e_rx_buffer_zc *i40e_rx_bi(struct i40e_ring *rx_ring, u32 idx)
+{
+	return &rx_ring->rx_bi_zc[idx];
 }
 
 /**
@@ -238,7 +252,7 @@ static int i40e_run_xdp_zc(struct i40e_ring *rx_ring, struct xdp_buff *xdp)
 }
 
 /**
- * i40e_alloc_buffer_zc - Allocates an i40e_rx_buffer
+ * i40e_alloc_buffer_zc - Allocates an i40e_rx_buffer_zc
  * @rx_ring: Rx ring
  * @bi: Rx buffer to populate
  *
@@ -248,7 +262,7 @@ static int i40e_run_xdp_zc(struct i40e_ring *rx_ring, struct xdp_buff *xdp)
  * Returns true for a successful allocation, false otherwise
  **/
 static bool i40e_alloc_buffer_zc(struct i40e_ring *rx_ring,
-				 struct i40e_rx_buffer *bi)
+				 struct i40e_rx_buffer_zc *bi)
 {
 	struct xdp_umem *umem = rx_ring->xsk_umem;
 	void *addr = bi->addr;
@@ -279,7 +293,7 @@ static bool i40e_alloc_buffer_zc(struct i40e_ring *rx_ring,
 }
 
 /**
- * i40e_alloc_buffer_slow_zc - Allocates an i40e_rx_buffer
+ * i40e_alloc_buffer_slow_zc - Allocates an i40e_rx_buffer_zc
  * @rx_ring: Rx ring
  * @bi: Rx buffer to populate
  *
@@ -289,7 +303,7 @@ static bool i40e_alloc_buffer_zc(struct i40e_ring *rx_ring,
  * Returns true for a successful allocation, false otherwise
  **/
 static bool i40e_alloc_buffer_slow_zc(struct i40e_ring *rx_ring,
-				      struct i40e_rx_buffer *bi)
+				      struct i40e_rx_buffer_zc *bi)
 {
 	struct xdp_umem *umem = rx_ring->xsk_umem;
 	u64 handle, hr;
@@ -318,11 +332,11 @@ static bool i40e_alloc_buffer_slow_zc(struct i40e_ring *rx_ring,
 static __always_inline bool
 __i40e_alloc_rx_buffers_zc(struct i40e_ring *rx_ring, u16 count,
 			   bool alloc(struct i40e_ring *rx_ring,
-				      struct i40e_rx_buffer *bi))
+				      struct i40e_rx_buffer_zc *bi))
 {
 	u16 ntu = rx_ring->next_to_use;
 	union i40e_rx_desc *rx_desc;
-	struct i40e_rx_buffer *bi;
+	struct i40e_rx_buffer_zc *bi;
 	bool ok = true;
 
 	rx_desc = I40E_RX_DESC(rx_ring, ntu);
@@ -402,10 +416,11 @@ static bool i40e_alloc_rx_buffers_fast_zc(struct i40e_ring *rx_ring, u16 count)
  *
  * Returns the received Rx buffer
  **/
-static struct i40e_rx_buffer *i40e_get_rx_buffer_zc(struct i40e_ring *rx_ring,
-						    const unsigned int size)
+static struct i40e_rx_buffer_zc *i40e_get_rx_buffer_zc(
+	struct i40e_ring *rx_ring,
+	const unsigned int size)
 {
-	struct i40e_rx_buffer *bi;
+	struct i40e_rx_buffer_zc *bi;
 
 	bi = i40e_rx_bi(rx_ring, rx_ring->next_to_clean);
 
@@ -427,10 +442,10 @@ static struct i40e_rx_buffer *i40e_get_rx_buffer_zc(struct i40e_ring *rx_ring,
  * recycle queue (next_to_alloc).
  **/
 static void i40e_reuse_rx_buffer_zc(struct i40e_ring *rx_ring,
-				    struct i40e_rx_buffer *old_bi)
+				    struct i40e_rx_buffer_zc *old_bi)
 {
-	struct i40e_rx_buffer *new_bi = i40e_rx_bi(rx_ring,
-						   rx_ring->next_to_alloc);
+	struct i40e_rx_buffer_zc *new_bi = i40e_rx_bi(rx_ring,
+						      rx_ring->next_to_alloc);
 	u16 nta = rx_ring->next_to_alloc;
 
 	/* update, and store next to alloc */
@@ -452,7 +467,7 @@ static void i40e_reuse_rx_buffer_zc(struct i40e_ring *rx_ring,
  **/
 void i40e_zca_free(struct zero_copy_allocator *alloc, unsigned long handle)
 {
-	struct i40e_rx_buffer *bi;
+	struct i40e_rx_buffer_zc *bi;
 	struct i40e_ring *rx_ring;
 	u64 hr, mask;
 	u16 nta;
@@ -490,7 +505,7 @@ void i40e_zca_free(struct zero_copy_allocator *alloc, unsigned long handle)
  * Returns the skb, or NULL on failure.
  **/
 static struct sk_buff *i40e_construct_skb_zc(struct i40e_ring *rx_ring,
-					     struct i40e_rx_buffer *bi,
+					     struct i40e_rx_buffer_zc *bi,
 					     struct xdp_buff *xdp)
 {
 	unsigned int metasize = xdp->data - xdp->data_meta;
@@ -513,19 +528,6 @@ static struct sk_buff *i40e_construct_skb_zc(struct i40e_ring *rx_ring,
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
-	prefetch(I40E_RX_DESC(rx_ring, ntc));
-}
-
 /**
  * i40e_clean_rx_irq_zc - Consumes Rx packets from the hardware ring
  * @rx_ring: Rx ring
@@ -545,7 +547,7 @@ int i40e_clean_rx_irq_zc(struct i40e_ring *rx_ring, int budget)
 	xdp.rxq = &rx_ring->xdp_rxq;
 
 	while (likely(total_rx_packets < (unsigned int)budget)) {
-		struct i40e_rx_buffer *bi;
+		struct i40e_rx_buffer_zc *bi;
 		union i40e_rx_desc *rx_desc;
 		unsigned int size;
 		u64 qword;
@@ -566,14 +568,18 @@ int i40e_clean_rx_irq_zc(struct i40e_ring *rx_ring, int budget)
 		 */
 		dma_rmb();
 
-		bi = i40e_clean_programming_status(rx_ring, rx_desc,
-						   qword);
-		if (unlikely(bi)) {
+		if (i40e_rx_is_programming_status(qword)) {
+			i40e_clean_programming_status(rx_ring,
+						      rx_desc->raw.qword[0],
+						      qword);
+			bi = i40e_rx_bi(rx_ring, rx_ring->next_to_clean);
+			i40e_inc_ntc(rx_ring);
 			i40e_reuse_rx_buffer_zc(rx_ring, bi);
 			cleaned_count++;
 			continue;
 		}
 
+		bi = i40e_rx_bi(rx_ring, rx_ring->next_to_clean);
 		size = (qword & I40E_RXD_QW1_LENGTH_PBUF_MASK) >>
 		       I40E_RXD_QW1_LENGTH_PBUF_SHIFT;
 		if (!size)
@@ -830,7 +836,7 @@ void i40e_xsk_clean_rx_ring(struct i40e_ring *rx_ring)
 	u16 i;
 
 	for (i = 0; i < rx_ring->count; i++) {
-		struct i40e_rx_buffer *rx_bi = i40e_rx_bi(rx_ring, i);
+		struct i40e_rx_buffer_zc *rx_bi = i40e_rx_bi(rx_ring, i);
 
 		if (!rx_bi->addr)
 			continue;
diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.h b/drivers/net/ethernet/intel/i40e/i40e_xsk.h
index 9ed59c14eb55..f5e292c218ee 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_xsk.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.h
@@ -19,5 +19,7 @@ int i40e_clean_rx_irq_zc(struct i40e_ring *rx_ring, int budget);
 bool i40e_clean_xdp_tx_irq(struct i40e_vsi *vsi,
 			   struct i40e_ring *tx_ring, int napi_budget);
 int i40e_xsk_wakeup(struct net_device *dev, u32 queue_id, u32 flags);
+int i40e_alloc_rx_bi_zc(struct i40e_ring *rx_ring);
+void i40e_clear_rx_bi_zc(struct i40e_ring *rx_ring);
 
 #endif /* _I40E_XSK_H_ */
-- 
2.25.1

