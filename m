Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B259836D362
	for <lists+netdev@lfdr.de>; Wed, 28 Apr 2021 09:45:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236807AbhD1Hpy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Apr 2021 03:45:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbhD1Hpv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Apr 2021 03:45:51 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D162AC061574;
        Wed, 28 Apr 2021 00:45:05 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id z6so643230wrm.4;
        Wed, 28 Apr 2021 00:45:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GRaCvvrnVc2oP4saq5ksgMK5RQ4I93mgeOS6vubk1lE=;
        b=Lh9cEFmYQxTrdYg8zm8d0e0i+963rDHTtw3i2uhlVM6uZguZHrkjr2gaLIkIvF/zDZ
         LI9tV8xn8FyghOKfVyCXs8Vj+49dfg+VbQVzI/FDZiMNczoLNtApmHBES+kFfeMFU7iH
         Jy1HzvCipxrx6TtyoA4Zc3JHcyKfwOkRdeg0ul6A9TtqthVv8k1l07cxx4sHFwjiUa9T
         A+j55K6+yYhar9VlSU0r6w/psd1fkMaZ3qfUwVcDilggtUBPqiQ5g5jOVo/ivJRAYzSe
         Ss49ku59g3CQkg02kdAnkyNb0GYaa3FzeU2Ww2eaPV06L4p8CPiZWrkfTlOZB4wV/mzq
         ZbLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GRaCvvrnVc2oP4saq5ksgMK5RQ4I93mgeOS6vubk1lE=;
        b=JiMs97eMHw+jJlrSnI6Wofw3C/yPRYhn/QcCcH3tjUen6+pCjbiniZBAEZmPnwEggI
         mKS+0pgoS5tdSe1frCs9byoUU4TwMV+XFXmfT3M5z6r499nCAEMHEVXT1lXUN23chtDI
         1Ahxu500ZB7eGQ9kV2BZxQd+ULfxn8ThK//xjJJz1wqYvidXxpL53Fzy2UahLOZq4A6b
         9JF6eQ0y6ipiim5s7JoigW1tVAylTj5exVFViZ+cFUkxjmM4YZRQcTOqoYs2AqS/3sgP
         Vfjm+iEQXSufqidQAfgrEjHn5KYEooe9fBCEq//KQnuKI4JSyu/qUEQ7ukqD0HtcYC4K
         mA7g==
X-Gm-Message-State: AOAM530DquzVrVuzcZ2/APWcmmKikha+zM1jkBNZylAaqn+qRMeFx87y
        m5LACR5VvG65/oDjsRHauwI=
X-Google-Smtp-Source: ABdhPJx0Wj/tSgTBOgwtYSNLq6j80D7qvs+LMA7F1xkfbyUoO0eo7RwGzrw0VVzZF2j9ERf0gn7hNA==
X-Received: by 2002:adf:ec42:: with SMTP id w2mr34288014wrn.373.1619595904379;
        Wed, 28 Apr 2021 00:45:04 -0700 (PDT)
Received: from localhost.localdomain (h-47-246.A165.priv.bahnhof.se. [46.59.47.246])
        by smtp.gmail.com with ESMTPSA id u2sm3261653wmm.5.2021.04.28.00.45.02
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 28 Apr 2021 00:45:03 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org, lorenzo@kernel.org,
        brouer@redhat.com, echaudro@redhat.com
Cc:     Tirthendu Sarkar <tirthendu.sarkar@intel.com>, bpf@vger.kernel.org,
        jonathan.lemon@gmail.com, maciej.fijalkowski@intel.com
Subject: [RFC PATCH bpf-next] i40e: support XDP multi-buffer
Date:   Wed, 28 Apr 2021 09:44:56 +0200
Message-Id: <20210428074456.22009-1-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.29.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tirthendu Sarkar <tirthendu.sarkar@intel.com>

Add support for XDP multi-buffers to the i40e driver. All buffers of a
multi-buffer packet are collected into a single XDP buffer before sending
it to the XDP program. Similarly, in the Tx path when transmitting a
packet, all its buffers are transmitted. The only difference in approach
compared to mvneta, is that we assemble the XDP multi-buffer when we get
the last buffer in the packet from the NIC.

This patch needs to applied on top of
RFC [PATCH v8 bpf-next 00/14] mvneta: introduce XDP multi-buffer support

Signed-off-by: Tirthendu Sarkar <tirthendu.sarkar@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e.h      |   1 +
 drivers/net/ethernet/intel/i40e/i40e_main.c |  12 -
 drivers/net/ethernet/intel/i40e/i40e_txrx.c | 402 +++++++++++++-------
 drivers/net/ethernet/intel/i40e/i40e_txrx.h |   4 +-
 4 files changed, 276 insertions(+), 143 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e.h b/drivers/net/ethernet/intel/i40e/i40e.h
index cd53981fa5e0..b723357aef41 100644
--- a/drivers/net/ethernet/intel/i40e/i40e.h
+++ b/drivers/net/ethernet/intel/i40e/i40e.h
@@ -318,6 +318,7 @@ struct i40e_udp_port_config {
 	u8 filter_index;
 };
 
+#define I40E_RXD_EOF BIT(I40E_RX_DESC_STATUS_EOF_SHIFT)
 #define I40_DDP_FLASH_REGION 100
 #define I40E_PROFILE_INFO_SIZE 48
 #define I40E_MAX_PROFILE_NUM 16
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 1555d6009bf5..c7e473b06a8f 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -3302,11 +3302,6 @@ static int i40e_configure_rx_ring(struct i40e_ring *ring)
 			return ret;
 		ring->rx_buf_len =
 		  xsk_pool_get_rx_frame_size(ring->xsk_pool);
-		/* For AF_XDP ZC, we disallow packets to span on
-		 * multiple buffers, thus letting us skip that
-		 * handling in the fast-path.
-		 */
-		chain_len = 1;
 		ret = xdp_rxq_info_reg_mem_model(&ring->xdp_rxq,
 						 MEM_TYPE_XSK_BUFF_POOL,
 						 NULL);
@@ -12945,18 +12940,11 @@ static netdev_features_t i40e_features_check(struct sk_buff *skb,
 static int i40e_xdp_setup(struct i40e_vsi *vsi, struct bpf_prog *prog,
 			  struct netlink_ext_ack *extack)
 {
-	int frame_size = vsi->netdev->mtu + ETH_HLEN + ETH_FCS_LEN + VLAN_HLEN;
 	struct i40e_pf *pf = vsi->back;
 	struct bpf_prog *old_prog;
 	bool need_reset;
 	int i;
 
-	/* Don't allow frames that span over multiple buffers */
-	if (frame_size > vsi->rx_buf_len) {
-		NL_SET_ERR_MSG_MOD(extack, "MTU too large to enable XDP");
-		return -EINVAL;
-	}
-
 	/* When turning XDP on->off/off->on we reset and rebuild the rings. */
 	need_reset = (i40e_enabled_xdp_vsi(vsi) != !!prog);
 
diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
index fc20afc23bfa..9eea909375e0 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -11,6 +11,10 @@
 #include "i40e_xsk.h"
 
 #define I40E_TXD_CMD (I40E_TX_DESC_CMD_EOP | I40E_TX_DESC_CMD_RS)
+#define I40E_RX_NTC(r) r->next_desc ? \
+	((union i40e_rx_desc *)r->next_desc - I40E_RX_DESC(r, 0)) : r->next_to_clean
+#define I40E_SET_SKIP(b) b->dma |= 0x1
+#define I40E_IS_SKIP_SET(b) (b->dma & 0x1)
 /**
  * i40e_fdir - Generate a Flow Director descriptor based on fdata
  * @tx_ring: Tx ring to send buffer on
@@ -1495,10 +1499,7 @@ void i40e_clean_rx_ring(struct i40e_ring *rx_ring)
 	if (!rx_ring->rx_bi)
 		return;
 
-	if (rx_ring->skb) {
-		dev_kfree_skb(rx_ring->skb);
-		rx_ring->skb = NULL;
-	}
+	rx_ring->next_desc = NULL;
 
 	if (rx_ring->xsk_pool) {
 		i40e_xsk_clean_rx_ring(rx_ring);
@@ -1961,9 +1962,6 @@ static bool i40e_cleanup_headers(struct i40e_ring *rx_ring, struct sk_buff *skb,
 				 union i40e_rx_desc *rx_desc)
 
 {
-	/* XDP packets use error pointer so abort at this point */
-	if (IS_ERR(skb))
-		return true;
 
 	/* ERR_MASK will only have valid bits if EOP set, and
 	 * what we are doing here is actually checking
@@ -2071,11 +2069,12 @@ static void i40e_add_rx_frag(struct i40e_ring *rx_ring,
  */
 static struct i40e_rx_buffer *i40e_get_rx_buffer(struct i40e_ring *rx_ring,
 						 const unsigned int size,
-						 int *rx_buffer_pgcnt)
+						 int *rx_buffer_pgcnt,
+						 u32 ntc)
 {
 	struct i40e_rx_buffer *rx_buffer;
 
-	rx_buffer = i40e_rx_bi(rx_ring, rx_ring->next_to_clean);
+	rx_buffer = i40e_rx_bi(rx_ring, ntc);
 	*rx_buffer_pgcnt =
 #if (PAGE_SIZE < 8192)
 		page_count(rx_buffer->page);
@@ -2097,10 +2096,52 @@ static struct i40e_rx_buffer *i40e_get_rx_buffer(struct i40e_ring *rx_ring,
 	return rx_buffer;
 }
 
+/**
+ * i40e_put_rx_buffer - Clean up used buffer and either recycle or free
+ * @rx_ring: rx descriptor ring to transact packets on
+ * @rx_buffer: rx buffer to pull data from
+ * @rx_buffer_pgcnt: rx buffer page refcount pre xdp_do_redirect() call
+ *
+ * This function will clean up the contents of the rx_buffer.  It will
+ * either recycle the buffer or unmap it and free the associated resources.
+ */
+static void i40e_put_rx_buffer(struct i40e_ring *rx_ring,
+			       struct i40e_rx_buffer *rx_buffer,
+			       int rx_buffer_pgcnt)
+{
+	if (i40e_can_reuse_rx_page(rx_buffer, rx_buffer_pgcnt)) {
+		/* hand second half of page back to the ring */
+		i40e_reuse_rx_page(rx_ring, rx_buffer);
+	} else {
+		/* we are not reusing the buffer so unmap it */
+		dma_unmap_page_attrs(rx_ring->dev, rx_buffer->dma,
+				     i40e_rx_pg_size(rx_ring),
+				     DMA_FROM_DEVICE, I40E_RX_DMA_ATTR);
+		__page_frag_cache_drain(rx_buffer->page,
+					rx_buffer->pagecnt_bias);
+		/* clear contents of buffer_info */
+		rx_buffer->page = NULL;
+	}
+}
+
+/**
+ * i40e_inc_ntc: Advance the next_to_clean index
+ * @rx_ring: Rx ring
+ * @cnt: Count to advance
+ **/
+static void i40e_inc_ntc(struct i40e_ring *rx_ring, u32 cnt)
+{
+	u32 ntc = (rx_ring->next_to_clean + cnt) % rx_ring->count;
+
+	rx_ring->next_to_clean = ntc;
+	prefetch(I40E_RX_DESC(rx_ring, ntc));
+}
+
 /**
  * i40e_construct_skb - Allocate skb and populate it
  * @rx_ring: rx descriptor ring to transact packets on
  * @rx_buffer: rx buffer to pull data from
+ * @rx_buffer_pgcnt: rx buffer page refcount pre xdp_do_redirect() call
  * @xdp: xdp_buff pointing to the data
  *
  * This function allocates an skb.  It then populates it with the page
@@ -2108,7 +2149,8 @@ static struct i40e_rx_buffer *i40e_get_rx_buffer(struct i40e_ring *rx_ring,
  * skb correctly.
  */
 static struct sk_buff *i40e_construct_skb(struct i40e_ring *rx_ring,
-					  struct i40e_rx_buffer *rx_buffer,
+					  struct i40e_rx_buffer **rx_buffer,
+					  u32 *rx_buffer_pgcnt,
 					  struct xdp_buff *xdp)
 {
 	unsigned int size = xdp->data_end - xdp->data;
@@ -2119,6 +2161,7 @@ static struct sk_buff *i40e_construct_skb(struct i40e_ring *rx_ring,
 #endif
 	unsigned int headlen;
 	struct sk_buff *skb;
+	u32 cnt = 1;
 
 	/* prefetch first cache line of first page */
 	net_prefetch(xdp->data);
@@ -2159,20 +2202,36 @@ static struct sk_buff *i40e_construct_skb(struct i40e_ring *rx_ring,
 	/* update all of the pointers */
 	size -= headlen;
 	if (size) {
-		skb_add_rx_frag(skb, 0, rx_buffer->page,
-				rx_buffer->page_offset + headlen,
+		skb_add_rx_frag(skb, 0, rx_buffer[0]->page,
+				rx_buffer[0]->page_offset + headlen,
 				size, truesize);
 
 		/* buffer is used by skb, update page_offset */
 #if (PAGE_SIZE < 8192)
-		rx_buffer->page_offset ^= truesize;
+		rx_buffer[0]->page_offset ^= truesize;
 #else
-		rx_buffer->page_offset += truesize;
+		rx_buffer[0]->page_offset += truesize;
 #endif
+		i40e_put_rx_buffer(rx_ring, rx_buffer[0], rx_buffer_pgcnt[0]);
 	} else {
 		/* buffer is unused, reset bias back to rx_buffer */
-		rx_buffer->pagecnt_bias++;
+		rx_buffer[0]->pagecnt_bias++;
+	}
+
+	if (unlikely(xdp->mb)) {
+		struct xdp_shared_info *sinfo = xdp_get_shared_info_from_buff(xdp);
+		u32 frag_num = 0;
+		u32 size;
+
+		do {
+			size = skb_frag_size(&sinfo->frags[frag_num++]);
+			i40e_add_rx_frag(rx_ring, rx_buffer[frag_num], skb, size);
+			i40e_put_rx_buffer(rx_ring, rx_buffer[frag_num], rx_buffer_pgcnt[frag_num]);
+		} while (frag_num < sinfo->nr_frags);
+		xdp->mb = 0;
+		cnt += sinfo->nr_frags;
 	}
+    i40e_inc_ntc(rx_ring, cnt);
 
 	return skb;
 }
@@ -2181,23 +2240,26 @@ static struct sk_buff *i40e_construct_skb(struct i40e_ring *rx_ring,
  * i40e_build_skb - Build skb around an existing buffer
  * @rx_ring: Rx descriptor ring to transact packets on
  * @rx_buffer: Rx buffer to pull data from
+ * @rx_buffer_pgcnt: rx buffer page refcount pre xdp_do_redirect() call
  * @xdp: xdp_buff pointing to the data
  *
  * This function builds an skb around an existing Rx buffer, taking care
  * to set up the skb correctly and avoid any memcpy overhead.
  */
 static struct sk_buff *i40e_build_skb(struct i40e_ring *rx_ring,
-				      struct i40e_rx_buffer *rx_buffer,
+				      struct i40e_rx_buffer **rx_buffer,
+				      u32 *rx_buffer_pgcnt,
 				      struct xdp_buff *xdp)
 {
 	unsigned int metasize = xdp->data - xdp->data_meta;
 #if (PAGE_SIZE < 8192)
 	unsigned int truesize = i40e_rx_pg_size(rx_ring) / 2;
 #else
-	unsigned int truesize = SKB_DATA_ALIGN(sizeof(struct skb_shared_info)) +
+	unsigned int truesize = SKB_DATA_ALIGN(sizeof(struct xdp_shared_info)) +
 				SKB_DATA_ALIGN(xdp->data_end -
 					       xdp->data_hard_start);
 #endif
+	u32 cnt = 1;
 	struct sk_buff *skb;
 
 	/* Prefetch first cache line of first page. If xdp->data_meta
@@ -2220,56 +2282,50 @@ static struct sk_buff *i40e_build_skb(struct i40e_ring *rx_ring,
 
 	/* buffer is used by skb, update page_offset */
 #if (PAGE_SIZE < 8192)
-	rx_buffer->page_offset ^= truesize;
+	rx_buffer[0]->page_offset ^= truesize;
 #else
-	rx_buffer->page_offset += truesize;
+	rx_buffer[0]->page_offset += truesize;
 #endif
+	i40e_put_rx_buffer(rx_ring, rx_buffer[0], rx_buffer_pgcnt[0]);
 
-	return skb;
-}
+	if (unlikely(xdp->mb)) {
+		struct xdp_shared_info *sinfo = xdp_get_shared_info_from_buff(xdp);
+		u32 frag_num = 0;
+		u32 size;
 
-/**
- * i40e_put_rx_buffer - Clean up used buffer and either recycle or free
- * @rx_ring: rx descriptor ring to transact packets on
- * @rx_buffer: rx buffer to pull data from
- * @rx_buffer_pgcnt: rx buffer page refcount pre xdp_do_redirect() call
- *
- * This function will clean up the contents of the rx_buffer.  It will
- * either recycle the buffer or unmap it and free the associated resources.
- */
-static void i40e_put_rx_buffer(struct i40e_ring *rx_ring,
-			       struct i40e_rx_buffer *rx_buffer,
-			       int rx_buffer_pgcnt)
-{
-	if (i40e_can_reuse_rx_page(rx_buffer, rx_buffer_pgcnt)) {
-		/* hand second half of page back to the ring */
-		i40e_reuse_rx_page(rx_ring, rx_buffer);
-	} else {
-		/* we are not reusing the buffer so unmap it */
-		dma_unmap_page_attrs(rx_ring->dev, rx_buffer->dma,
-				     i40e_rx_pg_size(rx_ring),
-				     DMA_FROM_DEVICE, I40E_RX_DMA_ATTR);
-		__page_frag_cache_drain(rx_buffer->page,
-					rx_buffer->pagecnt_bias);
-		/* clear contents of buffer_info */
-		rx_buffer->page = NULL;
+		do {
+			size = skb_frag_size(&sinfo->frags[frag_num++]);
+			i40e_add_rx_frag(rx_ring, rx_buffer[frag_num], skb, size);
+			i40e_put_rx_buffer(rx_ring, rx_buffer[frag_num], rx_buffer_pgcnt[frag_num]);
+		} while (frag_num < sinfo->nr_frags);
+		xdp->mb = 0;
+		cnt += sinfo->nr_frags;
 	}
+    i40e_inc_ntc(rx_ring, cnt);
+
+	return skb;
 }
 
 /**
  * i40e_is_non_eop - process handling of non-EOP buffers
  * @rx_ring: Rx ring being processed
- * @rx_desc: Rx descriptor for current buffer
+ * @qword
+ * @next_to_clean: Index of the current Rx buffer in the ring
  *
- * If the buffer is an EOP buffer, this function exits returning false,
- * otherwise return true indicating that this is in fact a non-EOP buffer.
- */
-static bool i40e_is_non_eop(struct i40e_ring *rx_ring,
-			    union i40e_rx_desc *rx_desc)
+ * This function updates next to clean.  If the buffer is an EOP buffer
+ * this function exits returning false, otherwise it will return true
+ * indicating that this is in fact a non-EOP buffer.
+ **/
+static bool i40e_is_non_eop(struct i40e_ring *rx_ring, u64 qword, u32 *next_to_clean)
 {
+	u32 ntc = *next_to_clean + 1;
+
+	/* fetch, update, and store next to clean */
+	ntc = (ntc < rx_ring->count) ? ntc : 0;
+	*next_to_clean = ntc;
+
 	/* if we are the last buffer then there is nothing else to do */
-#define I40E_RXD_EOF BIT(I40E_RX_DESC_STATUS_EOF_SHIFT)
-	if (likely(i40e_test_staterr(rx_desc, I40E_RXD_EOF)))
+	if (likely(qword & I40E_RXD_EOF))
 		return false;
 
 	rx_ring->rx_stats.non_eop_descs++;
@@ -2415,16 +2471,63 @@ void i40e_finalize_xdp_rx(struct i40e_ring *rx_ring, unsigned int xdp_res)
 }
 
 /**
- * i40e_inc_ntc: Advance the next_to_clean index
- * @rx_ring: Rx ring
+ * i40e_build_xdp - Build XDP buffer from a Rx buffer
+ * @rx_ring: rx descriptor ring to transact packets on
+ * @last_rx_buffer: Rx buffer to pull data from
+ * @size: Size of data in Rx buffer
+ * @xdp: xdp_buff pointing to the data
  **/
-static void i40e_inc_ntc(struct i40e_ring *rx_ring)
+static int i40e_build_xdp(struct i40e_ring *rx_ring,
+			   union i40e_rx_desc *rx_desc,
+			   struct i40e_rx_buffer **rx_buffer,
+			   int *rb_pgcnt,
+			   unsigned int size,
+			   struct xdp_buff *xdp)
 {
-	u32 ntc = rx_ring->next_to_clean + 1;
+	u32 ntc = rx_ring->next_to_clean;
+	u32 curr = rx_desc - I40E_RX_DESC(rx_ring, 0);
+	u32 cnt = 1;
 
-	ntc = (ntc < rx_ring->count) ? ntc : 0;
-	rx_ring->next_to_clean = ntc;
-	prefetch(I40E_RX_DESC(rx_ring, ntc));
+	if (unlikely(ntc != curr)) {
+		struct xdp_shared_info *sinfo = xdp_get_shared_info_from_buff(xdp);
+		skb_frag_t *frag;
+
+		xdp->mb = 1;
+		while (1) {
+			struct i40e_rx_buffer *rxb = i40e_rx_bi(rx_ring, ntc);
+
+			if (++ntc == rx_ring->count)
+				ntc = 0;
+
+			if (I40E_IS_SKIP_SET(rxb))
+				continue;
+			rx_buffer[cnt] = i40e_get_rx_buffer(rx_ring, size, &rb_pgcnt[cnt], ntc);
+			frag = &sinfo->frags[cnt - 1];
+			__skb_frag_set_page(frag, rx_buffer[cnt]->page);
+			skb_frag_off_set(frag, rx_buffer[cnt]->page_offset);
+
+			if (ntc == curr) {
+				skb_frag_size_set(frag, size);
+				break;
+			}
+			skb_frag_size_set(frag, rx_ring->rx_buf_len);
+			cnt++;
+		}
+		size = rx_ring->rx_buf_len;
+		sinfo->nr_frags = cnt;
+	}
+
+	rx_buffer[0] = i40e_get_rx_buffer(rx_ring, size, &rb_pgcnt[0], rx_ring->next_to_clean);
+	xdp->data = page_address(rx_buffer[0]->page) + rx_buffer[0]->page_offset;
+	xdp->data_meta = xdp->data;
+	xdp->data_hard_start = xdp->data - rx_ring->rx_offset;
+	xdp->data_end = xdp->data + size;
+#if (PAGE_SIZE > 4096)
+	/* At larger PAGE_SIZE, frame_sz depend on len size */
+	xdp->frame_sz = i40e_rx_frame_truesize(rx_ring, size);
+#endif
+
+	return cnt;
 }
 
 /**
@@ -2443,8 +2546,8 @@ static int i40e_clean_rx_irq(struct i40e_ring *rx_ring, int budget)
 {
 	unsigned int total_rx_bytes = 0, total_rx_packets = 0, frame_sz = 0;
 	u16 cleaned_count = I40E_DESC_UNUSED(rx_ring);
-	unsigned int offset = rx_ring->rx_offset;
-	struct sk_buff *skb = rx_ring->skb;
+	u32 ntc = I40E_RX_NTC(rx_ring);
+	union i40e_rx_desc *rx_desc;
 	unsigned int xdp_xmit = 0;
 	bool failure = false;
 	struct xdp_buff xdp;
@@ -2455,9 +2558,10 @@ static int i40e_clean_rx_irq(struct i40e_ring *rx_ring, int budget)
 	xdp_init_buff(&xdp, frame_sz, &rx_ring->xdp_rxq);
 
 	while (likely(total_rx_packets < (unsigned int)budget)) {
-		struct i40e_rx_buffer *rx_buffer;
-		union i40e_rx_desc *rx_desc;
-		int rx_buffer_pgcnt;
+		struct i40e_rx_buffer *rx_buffer[MAX_SKB_FRAGS];
+		u32 rx_buffer_pgcnt[MAX_SKB_FRAGS];
+		u32 rb_cnt;
+		struct sk_buff *skb;
 		unsigned int size;
 		u64 qword;
 
@@ -2468,8 +2572,7 @@ static int i40e_clean_rx_irq(struct i40e_ring *rx_ring, int budget)
 			cleaned_count = 0;
 		}
 
-		rx_desc = I40E_RX_DESC(rx_ring, rx_ring->next_to_clean);
-
+		rx_desc = I40E_RX_DESC(rx_ring, ntc);
 		/* status_error_len will always be zero for unused descriptors
 		 * because it's cleared in cleanup, and overlaps with hdr_addr
 		 * which is always zero because packet split isn't used, if the
@@ -2487,9 +2590,14 @@ static int i40e_clean_rx_irq(struct i40e_ring *rx_ring, int budget)
 			i40e_clean_programming_status(rx_ring,
 						      rx_desc->raw.qword[0],
 						      qword);
-			rx_buffer = i40e_rx_bi(rx_ring, rx_ring->next_to_clean);
-			i40e_inc_ntc(rx_ring);
-			i40e_reuse_rx_page(rx_ring, rx_buffer);
+			rx_buffer[0] = i40e_rx_bi(rx_ring, ntc);
+			i40e_reuse_rx_page(rx_ring, rx_buffer[0]);
+			if (likely(ntc == rx_ring->next_to_clean)) {
+				i40e_inc_ntc(rx_ring, 1);
+			} else {
+				ntc = (++ntc < rx_ring->count) ? ntc : 0;
+				I40E_SET_SKIP(rx_buffer[0]);
+			}
 			cleaned_count++;
 			continue;
 		}
@@ -2500,59 +2608,55 @@ static int i40e_clean_rx_irq(struct i40e_ring *rx_ring, int budget)
 			break;
 
 		i40e_trace(clean_rx_irq, rx_ring, rx_desc, skb);
-		rx_buffer = i40e_get_rx_buffer(rx_ring, size, &rx_buffer_pgcnt);
 
-		/* retrieve a buffer from the ring */
-		if (!skb) {
-			unsigned char *hard_start;
+		if (i40e_is_non_eop(rx_ring, qword, &ntc))
+			continue;
 
-			hard_start = page_address(rx_buffer->page) +
-				     rx_buffer->page_offset - offset;
-			xdp_prepare_buff(&xdp, hard_start, offset, size, true);
-#if (PAGE_SIZE > 4096)
-			/* At larger PAGE_SIZE, frame_sz depend on len size */
-			xdp.frame_sz = i40e_rx_frame_truesize(rx_ring, size);
-#endif
-			skb = i40e_run_xdp(rx_ring, &xdp);
-		}
+		rb_cnt = i40e_build_xdp(rx_ring, rx_desc, rx_buffer, rx_buffer_pgcnt, size, &xdp);
+
+		skb = i40e_run_xdp(rx_ring, &xdp);
 
 		if (IS_ERR(skb)) {
 			unsigned int xdp_res = -PTR_ERR(skb);
 
-			if (xdp_res & (I40E_XDP_TX | I40E_XDP_REDIR)) {
+			if (xdp_res & (I40E_XDP_TX | I40E_XDP_REDIR))
 				xdp_xmit |= xdp_res;
-				i40e_rx_buffer_flip(rx_ring, rx_buffer, size);
-			} else {
-				rx_buffer->pagecnt_bias++;
-			}
-			total_rx_bytes += size;
+
+			do {
+				rb_cnt--;
+				if (xdp_xmit)
+					i40e_rx_buffer_flip(rx_ring, rx_buffer[rb_cnt], size);
+				else
+					rx_buffer[rb_cnt]->pagecnt_bias++;
+				i40e_put_rx_buffer(rx_ring, rx_buffer[rb_cnt], rx_buffer_pgcnt[rb_cnt]);
+				total_rx_bytes += size;
+				cleaned_count++;
+				if (likely(rb_cnt == 0))
+					break;
+				size = rx_ring->rx_buf_len;
+			} while (1);
+
 			total_rx_packets++;
-		} else if (skb) {
-			i40e_add_rx_frag(rx_ring, rx_buffer, skb, size);
-		} else if (ring_uses_build_skb(rx_ring)) {
-			skb = i40e_build_skb(rx_ring, rx_buffer, &xdp);
-		} else {
-			skb = i40e_construct_skb(rx_ring, rx_buffer, &xdp);
+            rx_ring->next_to_clean = ntc;
+			rx_desc = NULL;
+			continue;
 		}
 
+		if (ring_uses_build_skb(rx_ring))
+			skb = i40e_build_skb(rx_ring, rx_buffer, rx_buffer_pgcnt, &xdp);
+		else
+			skb = i40e_construct_skb(rx_ring, rx_buffer, rx_buffer_pgcnt, &xdp);
 		/* exit if we failed to retrieve a buffer */
 		if (!skb) {
 			rx_ring->rx_stats.alloc_buff_failed++;
-			rx_buffer->pagecnt_bias++;
+			do {
+				rx_buffer[--rb_cnt]->pagecnt_bias++;
+			} while (rb_cnt);
 			break;
 		}
+		cleaned_count += skb_shinfo(skb)->nr_frags + 1;
 
-		i40e_put_rx_buffer(rx_ring, rx_buffer, rx_buffer_pgcnt);
-		cleaned_count++;
-
-		i40e_inc_ntc(rx_ring);
-		if (i40e_is_non_eop(rx_ring, rx_desc))
-			continue;
-
-		if (i40e_cleanup_headers(rx_ring, skb, rx_desc)) {
-			skb = NULL;
-			continue;
-		}
+		i40e_cleanup_headers(rx_ring, skb, rx_desc);
 
 		/* probably a little skewed due to removing CRC */
 		total_rx_bytes += skb->len;
@@ -2562,14 +2666,14 @@ static int i40e_clean_rx_irq(struct i40e_ring *rx_ring, int budget)
 
 		i40e_trace(clean_rx_irq_rx, rx_ring, rx_desc, skb);
 		napi_gro_receive(&rx_ring->q_vector->napi, skb);
-		skb = NULL;
+		rx_desc = NULL;
 
 		/* update budget accounting */
 		total_rx_packets++;
 	}
 
 	i40e_finalize_xdp_rx(rx_ring, xdp_xmit);
-	rx_ring->skb = skb;
+	rx_ring->next_desc = rx_desc;
 
 	i40e_update_rx_stats(rx_ring, total_rx_bytes, total_rx_packets);
 
@@ -3643,31 +3747,63 @@ static int i40e_xmit_xdp_ring(struct xdp_frame *xdpf,
 			      struct i40e_ring *xdp_ring)
 {
 	u16 i = xdp_ring->next_to_use;
-	struct i40e_tx_buffer *tx_bi;
+	struct i40e_tx_buffer *tx_bi, *first;
 	struct i40e_tx_desc *tx_desc;
 	void *data = xdpf->data;
 	u32 size = xdpf->len;
 	dma_addr_t dma;
+	struct xdp_shared_info *sinfo;
+	int cnt = 0, num_frags = 0;
 
-	if (!unlikely(I40E_DESC_UNUSED(xdp_ring))) {
+	if (unlikely(xdpf->mb)) {
+		sinfo = xdp_get_shared_info_from_frame(xdpf);
+		num_frags = sinfo->nr_frags;
+	}
+	if (unlikely(I40E_DESC_UNUSED(xdp_ring) < num_frags + 1)) {
 		xdp_ring->tx_stats.tx_busy++;
 		return I40E_XDP_CONSUMED;
 	}
-	dma = dma_map_single(xdp_ring->dev, data, size, DMA_TO_DEVICE);
-	if (dma_mapping_error(xdp_ring->dev, dma))
-		return I40E_XDP_CONSUMED;
 
-	tx_bi = &xdp_ring->tx_bi[i];
-	tx_bi->bytecount = size;
-	tx_bi->gso_segs = 1;
-	tx_bi->xdpf = xdpf;
+	do {
+		skb_frag_t *frag;
+
+		dma = dma_map_single(xdp_ring->dev, data, size, DMA_TO_DEVICE);
+		if (dma_mapping_error(xdp_ring->dev, dma))
+			goto dma_error;
 
-	/* record length, and DMA address */
-	dma_unmap_len_set(tx_bi, len, size);
-	dma_unmap_addr_set(tx_bi, dma, dma);
+		tx_bi = &xdp_ring->tx_bi[i];
+		tx_bi->xdpf = xdpf;
+
+		/* record length, and DMA address */
+		dma_unmap_len_set(tx_bi, len, size);
+		dma_unmap_addr_set(tx_bi, dma, dma);
+
+		tx_desc = I40E_TX_DESC(xdp_ring, i);
+		tx_desc->buffer_addr = cpu_to_le64(dma);
+
+		if (!cnt) {
+			first = tx_bi;
+			first->bytecount = size;
+			first->gso_segs = 1;
+		} else {
+			tx_bi->next_to_watch = NULL;
+			first->bytecount += size;
+		}
+		i++;
+		if (i == xdp_ring->count)
+			i = 0;
+
+		if (num_frags == cnt)
+			break;
+
+		tx_desc->cmd_type_offset_bsz =
+			build_ctob(I40E_TX_DESC_CMD_ICRC, 0, size, 0);
+		frag = &sinfo->frags[cnt++];
+		data = page_address(skb_frag_page(frag)) + skb_frag_off(frag);;
+		size = skb_frag_size(frag);
+		xdpf = NULL;
+	} while (1);
 
-	tx_desc = I40E_TX_DESC(xdp_ring, i);
-	tx_desc->buffer_addr = cpu_to_le64(dma);
 	tx_desc->cmd_type_offset_bsz = build_ctob(I40E_TX_DESC_CMD_ICRC
 						  | I40E_TXD_CMD,
 						  0, size, 0);
@@ -3678,14 +3814,22 @@ static int i40e_xmit_xdp_ring(struct xdp_frame *xdpf,
 	smp_wmb();
 
 	xdp_ring->xdp_tx_active++;
-	i++;
-	if (i == xdp_ring->count)
-		i = 0;
-
-	tx_bi->next_to_watch = tx_desc;
+	first->next_to_watch = tx_desc;
 	xdp_ring->next_to_use = i;
 
 	return I40E_XDP_TX;
+dma_error:
+	dev_info(xdp_ring->dev, "TX DMA map failed\n");
+
+	/* clear dma mappings for failed tx_bi map */
+	while (cnt--)  {
+		i40e_unmap_and_free_tx_resource(xdp_ring, tx_bi);
+		if (i == 0)
+			i = xdp_ring->count;
+		i--;
+		tx_bi = &xdp_ring->tx_bi[i];
+	}
+	return I40E_XDP_CONSUMED;
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.h b/drivers/net/ethernet/intel/i40e/i40e_txrx.h
index 86fed05b4f19..5fba530ee96d 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.h
@@ -377,9 +377,9 @@ struct i40e_ring {
 
 	struct rcu_head rcu;		/* to avoid race on free */
 	u16 next_to_alloc;
-	struct sk_buff *skb;		/* When i40e_clean_rx_ring_irq() must
+	union i40e_rx_desc  *next_desc;		/* When i40e_clean_rx_ring_irq() must
 					 * return before it sees the EOP for
-					 * the current packet, we save that skb
+					 * the current packet, we save that desc
 					 * here and resume receiving this
 					 * packet the next time
 					 * i40e_clean_rx_ring_irq() is called

base-commit: 5c507329000e282dce91e6c98ee6ffa61a8a5e49
prerequisite-patch-id: e01e6cfdb418d4f25dbb5c4ee397ae1756033ba3
prerequisite-patch-id: 99f9cb2dc24ca89f93859658c3d6018fd5f34958
prerequisite-patch-id: c7401969d05643b368d98787c7d50e69f090444a
prerequisite-patch-id: bf672930c629f5c784155ecafa5a79a5abd84413
prerequisite-patch-id: 5c8796dfd6ed8d023b0dc1c61aedd326e3e8491d
prerequisite-patch-id: ec35a3acaf95001085882008692cfaff3b5c2106
prerequisite-patch-id: a089372dd435ff9cc8d80693d402ea9a5f88cb5b
prerequisite-patch-id: dd4bf226d63399e47d9bb55215151ad1671c316b
prerequisite-patch-id: 5c799d0d26fb7959ed6856aa973d3224fb50a7f7
prerequisite-patch-id: 19727b269d40be5f43f97f6f52ebfd471a7f505b
prerequisite-patch-id: 75354f4f04c77bb733e2aa065ab3372aec28a64b
prerequisite-patch-id: 41ba3c89eb88efcf2c550d5b7021267c4e6470d8
prerequisite-patch-id: c4b1ae885589080809c1079dd715c012434327b7
prerequisite-patch-id: b3dc9785bb930d0443c43aa87ffcdd26e2b7f197
-- 
2.29.0

