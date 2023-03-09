Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00C7A6B2F91
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 22:30:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231392AbjCIVaQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 16:30:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231318AbjCIV35 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 16:29:57 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83BF3E1CB1;
        Thu,  9 Mar 2023 13:29:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678397394; x=1709933394;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PrCOCKlNJ7Xjcrg+0O0fazSl8EnVxcgyrPlVRQtTuNE=;
  b=ICYCnAEyhvMSRNNy/b8qcJq8qWxMp/JSLtQ/kQFTZuQxhVBLruw1ZulU
   miiKEmiW1gSDpBSejhNEpK6Y8WCjw2r/sgFH/+BFMHvtWoYMjrX4HNF7r
   nUfes7ql7oQ5m+S2N2CSE+MDiHdYMxCCSOAHF8E1WbN+zLDg7rHBZSgSy
   vStf2w5wka2IoJCCNAAeUmhHWPlYTCz3S/Jcpu+GQSl0NyuGISu45rfBW
   Viwkd+Uzq5UzXNhEPwYWXo/N3HpDTtvZNuOPzmULz7lKUQk3QUb7XI24w
   o8HDLQOnwBX8Oa8FDTT5pMOA6NCLbnPuqP7v6NV10mY0+DH6sK+53SJFE
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10644"; a="338126191"
X-IronPort-AV: E=Sophos;i="5.98,247,1673942400"; 
   d="scan'208";a="338126191"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2023 13:29:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10644"; a="710011496"
X-IronPort-AV: E=Sophos;i="5.98,247,1673942400"; 
   d="scan'208";a="710011496"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by orsmga001.jf.intel.com with ESMTP; 09 Mar 2023 13:29:53 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
Cc:     Tirthendu Sarkar <tirthendu.sarkar@intel.com>,
        anthony.l.nguyen@intel.com, maciej.fijalkowski@intel.com,
        magnus.karlsson@intel.com, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com, bpf@vger.kernel.org,
        Chandan Kumar Rout <chandanx.rout@intel.com>
Subject: [PATCH net-next v2 8/8] i40e: add support for XDP multi-buffer Rx
Date:   Thu,  9 Mar 2023 13:28:19 -0800
Message-Id: <20230309212819.1198218-9-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230309212819.1198218-1-anthony.l.nguyen@intel.com>
References: <20230309212819.1198218-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tirthendu Sarkar <tirthendu.sarkar@intel.com>

This patch adds multi-buffer support for the i40e_driver.

i40e_clean_rx_irq() is modified to collate all the buffers of a packet
before calling the XDP program. xdp_buff is built for the first frag of
the packet and subsequent frags are added to it. 'next_to_process' is
incremented for all non-EOP frags while 'next_to_clean' stays at the
first descriptor of the packet. XDP program is called only on receiving
EOP frag.

New functions are added for adding frags to xdp_buff and for post
processing of the buffers once the xdp prog has run. For XDP_PASS this
results in a skb with multiple fragments.

i40e_build_skb() builds the skb around xdp buffer that already contains
frags data. So i40e_add_rx_frag() helper function is now removed. Since
fields before 'dataref' in skb_shared_info are cleared during
napi_skb_build(), xdp_update_skb_shared_info() is called to set those.

For i40e_construct_skb(), all the frags data needs to be copied from
xdp_buffer's shared_skb_info to newly constructed skb's shared_skb_info.

This also means 'skb' does not need to be preserved across i40e_napi_poll()
calls and hence is removed from i40e_ring structure.

Previously i40e_alloc_rx_buffers() was called for every 32 cleaned
buffers. For multi-buffers this may not be optimal as there may be more
cleaned buffers in each i40e_clean_rx_irq() call. So this is now called
when at least half of the ring size has been cleaned.

Signed-off-by: Tirthendu Sarkar <tirthendu.sarkar@intel.com>
Tested-by: Chandan Kumar Rout <chandanx.rout@intel.com> (A Contingent Worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c |   7 +-
 drivers/net/ethernet/intel/i40e/i40e_txrx.c | 314 +++++++++++++-------
 drivers/net/ethernet/intel/i40e/i40e_txrx.h |   8 -
 3 files changed, 211 insertions(+), 118 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index f2c151a01e77..053be338e4ba 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -2919,7 +2919,7 @@ static int i40e_max_vsi_frame_size(struct i40e_vsi *vsi,
 	u16 rx_buf_len = i40e_calculate_vsi_rx_buf_len(vsi);
 	u16 chain_len;
 
-	if (xdp_prog)
+	if (xdp_prog && !xdp_prog->aux->xdp_has_frags)
 		chain_len = 1;
 	else
 		chain_len = I40E_MAX_CHAINED_RX_BUFFERS;
@@ -13337,7 +13337,7 @@ static int i40e_xdp_setup(struct i40e_vsi *vsi, struct bpf_prog *prog,
 
 	/* Don't allow frames that span over multiple buffers */
 	if (vsi->netdev->mtu > frame_size - I40E_PACKET_HDR_PAD) {
-		NL_SET_ERR_MSG_MOD(extack, "MTU too large to enable XDP");
+		NL_SET_ERR_MSG_MOD(extack, "MTU too large for linear frames and XDP prog does not support frags");
 		return -EINVAL;
 	}
 
@@ -13823,7 +13823,8 @@ static int i40e_config_netdev(struct i40e_vsi *vsi)
 
 		netdev->xdp_features = NETDEV_XDP_ACT_BASIC |
 				       NETDEV_XDP_ACT_REDIRECT |
-				       NETDEV_XDP_ACT_XSK_ZEROCOPY;
+				       NETDEV_XDP_ACT_XSK_ZEROCOPY |
+				       NETDEV_XDP_ACT_RX_SG;
 	} else {
 		/* Relate the VSI_VMDQ name to the VSI_MAIN name. Note that we
 		 * are still limited by IFNAMSIZ, but we're adding 'v%d\0' to
diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
index 5544c2d43a92..32cce90abbb4 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -1477,9 +1477,6 @@ void i40e_clean_rx_ring(struct i40e_ring *rx_ring)
 	if (!rx_ring->rx_bi)
 		return;
 
-	dev_kfree_skb(rx_ring->skb);
-	rx_ring->skb = NULL;
-
 	if (rx_ring->xsk_pool) {
 		i40e_xsk_clean_rx_ring(rx_ring);
 		goto skip_free;
@@ -2033,36 +2030,6 @@ static void i40e_rx_buffer_flip(struct i40e_rx_buffer *rx_buffer,
 #endif
 }
 
-/**
- * i40e_add_rx_frag - Add contents of Rx buffer to sk_buff
- * @rx_ring: rx descriptor ring to transact packets on
- * @rx_buffer: buffer containing page to add
- * @skb: sk_buff to place the data into
- * @size: packet length from rx_desc
- *
- * This function will add the data contained in rx_buffer->page to the skb.
- * It will just attach the page as a frag to the skb.
- *
- * The function will then update the page offset.
- **/
-static void i40e_add_rx_frag(struct i40e_ring *rx_ring,
-			     struct i40e_rx_buffer *rx_buffer,
-			     struct sk_buff *skb,
-			     unsigned int size)
-{
-#if (PAGE_SIZE < 8192)
-	unsigned int truesize = i40e_rx_pg_size(rx_ring) / 2;
-#else
-	unsigned int truesize = SKB_DATA_ALIGN(size + rx_ring->rx_offset);
-#endif
-
-	skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags, rx_buffer->page,
-			rx_buffer->page_offset, size, truesize);
-
-	/* page is being used so we must update the page offset */
-	i40e_rx_buffer_flip(rx_buffer, truesize);
-}
-
 /**
  * i40e_get_rx_buffer - Fetch Rx buffer and synchronize data for use
  * @rx_ring: rx descriptor ring to transact packets on
@@ -2099,20 +2066,82 @@ static struct i40e_rx_buffer *i40e_get_rx_buffer(struct i40e_ring *rx_ring,
 }
 
 /**
- * i40e_construct_skb - Allocate skb and populate it
+ * i40e_put_rx_buffer - Clean up used buffer and either recycle or free
  * @rx_ring: rx descriptor ring to transact packets on
  * @rx_buffer: rx buffer to pull data from
+ *
+ * This function will clean up the contents of the rx_buffer.  It will
+ * either recycle the buffer or unmap it and free the associated resources.
+ */
+static void i40e_put_rx_buffer(struct i40e_ring *rx_ring,
+			       struct i40e_rx_buffer *rx_buffer)
+{
+	if (i40e_can_reuse_rx_page(rx_buffer, &rx_ring->rx_stats)) {
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
+ * i40e_process_rx_buffs- Processing of buffers post XDP prog or on error
+ * @rx_ring: Rx descriptor ring to transact packets on
+ * @xdp_res: Result of the XDP program
+ * @xdp: xdp_buff pointing to the data
+ **/
+static void i40e_process_rx_buffs(struct i40e_ring *rx_ring, int xdp_res,
+				  struct xdp_buff *xdp)
+{
+	u32 next = rx_ring->next_to_clean;
+	struct i40e_rx_buffer *rx_buffer;
+
+	xdp->flags = 0;
+
+	while (1) {
+		rx_buffer = i40e_rx_bi(rx_ring, next);
+		if (++next == rx_ring->count)
+			next = 0;
+
+		if (!rx_buffer->page)
+			continue;
+
+		if (xdp_res == I40E_XDP_CONSUMED)
+			rx_buffer->pagecnt_bias++;
+		else
+			i40e_rx_buffer_flip(rx_buffer, xdp->frame_sz);
+
+		/* EOP buffer will be put in i40e_clean_rx_irq() */
+		if (next == rx_ring->next_to_process)
+			return;
+
+		i40e_put_rx_buffer(rx_ring, rx_buffer);
+	}
+}
+
+/**
+ * i40e_construct_skb - Allocate skb and populate it
+ * @rx_ring: rx descriptor ring to transact packets on
  * @xdp: xdp_buff pointing to the data
+ * @nr_frags: number of buffers for the packet
  *
  * This function allocates an skb.  It then populates it with the page
  * data from the current receive descriptor, taking care to set up the
  * skb correctly.
  */
 static struct sk_buff *i40e_construct_skb(struct i40e_ring *rx_ring,
-					  struct i40e_rx_buffer *rx_buffer,
-					  struct xdp_buff *xdp)
+					  struct xdp_buff *xdp,
+					  u32 nr_frags)
 {
 	unsigned int size = xdp->data_end - xdp->data;
+	struct i40e_rx_buffer *rx_buffer;
 	unsigned int headlen;
 	struct sk_buff *skb;
 
@@ -2152,13 +2181,17 @@ static struct sk_buff *i40e_construct_skb(struct i40e_ring *rx_ring,
 	memcpy(__skb_put(skb, headlen), xdp->data,
 	       ALIGN(headlen, sizeof(long)));
 
+	rx_buffer = i40e_rx_bi(rx_ring, rx_ring->next_to_clean);
 	/* update all of the pointers */
 	size -= headlen;
 	if (size) {
+		if (unlikely(nr_frags >= MAX_SKB_FRAGS)) {
+			dev_kfree_skb(skb);
+			return NULL;
+		}
 		skb_add_rx_frag(skb, 0, rx_buffer->page,
 				rx_buffer->page_offset + headlen,
 				size, xdp->frame_sz);
-
 		/* buffer is used by skb, update page_offset */
 		i40e_rx_buffer_flip(rx_buffer, xdp->frame_sz);
 	} else {
@@ -2166,21 +2199,40 @@ static struct sk_buff *i40e_construct_skb(struct i40e_ring *rx_ring,
 		rx_buffer->pagecnt_bias++;
 	}
 
+	if (unlikely(xdp_buff_has_frags(xdp))) {
+		struct skb_shared_info *sinfo, *skinfo = skb_shinfo(skb);
+
+		sinfo = xdp_get_shared_info_from_buff(xdp);
+		memcpy(&skinfo->frags[skinfo->nr_frags], &sinfo->frags[0],
+		       sizeof(skb_frag_t) * nr_frags);
+
+		xdp_update_skb_shared_info(skb, skinfo->nr_frags + nr_frags,
+					   sinfo->xdp_frags_size,
+					   nr_frags * xdp->frame_sz,
+					   xdp_buff_is_frag_pfmemalloc(xdp));
+
+		/* First buffer has already been processed, so bump ntc */
+		if (++rx_ring->next_to_clean == rx_ring->count)
+			rx_ring->next_to_clean = 0;
+
+		i40e_process_rx_buffs(rx_ring, I40E_XDP_PASS, xdp);
+	}
+
 	return skb;
 }
 
 /**
  * i40e_build_skb - Build skb around an existing buffer
  * @rx_ring: Rx descriptor ring to transact packets on
- * @rx_buffer: Rx buffer to pull data from
  * @xdp: xdp_buff pointing to the data
+ * @nr_frags: number of buffers for the packet
  *
  * This function builds an skb around an existing Rx buffer, taking care
  * to set up the skb correctly and avoid any memcpy overhead.
  */
 static struct sk_buff *i40e_build_skb(struct i40e_ring *rx_ring,
-				      struct i40e_rx_buffer *rx_buffer,
-				      struct xdp_buff *xdp)
+				      struct xdp_buff *xdp,
+				      u32 nr_frags)
 {
 	unsigned int metasize = xdp->data - xdp->data_meta;
 	struct sk_buff *skb;
@@ -2203,36 +2255,25 @@ static struct sk_buff *i40e_build_skb(struct i40e_ring *rx_ring,
 	if (metasize)
 		skb_metadata_set(skb, metasize);
 
-	/* buffer is used by skb, update page_offset */
-	i40e_rx_buffer_flip(rx_buffer, xdp->frame_sz);
+	if (unlikely(xdp_buff_has_frags(xdp))) {
+		struct skb_shared_info *sinfo;
 
-	return skb;
-}
+		sinfo = xdp_get_shared_info_from_buff(xdp);
+		xdp_update_skb_shared_info(skb, nr_frags,
+					   sinfo->xdp_frags_size,
+					   nr_frags * xdp->frame_sz,
+					   xdp_buff_is_frag_pfmemalloc(xdp));
 
-/**
- * i40e_put_rx_buffer - Clean up used buffer and either recycle or free
- * @rx_ring: rx descriptor ring to transact packets on
- * @rx_buffer: rx buffer to pull data from
- *
- * This function will clean up the contents of the rx_buffer.  It will
- * either recycle the buffer or unmap it and free the associated resources.
- */
-static void i40e_put_rx_buffer(struct i40e_ring *rx_ring,
-			       struct i40e_rx_buffer *rx_buffer)
-{
-	if (i40e_can_reuse_rx_page(rx_buffer, &rx_ring->rx_stats)) {
-		/* hand second half of page back to the ring */
-		i40e_reuse_rx_page(rx_ring, rx_buffer);
+		i40e_process_rx_buffs(rx_ring, I40E_XDP_PASS, xdp);
 	} else {
-		/* we are not reusing the buffer so unmap it */
-		dma_unmap_page_attrs(rx_ring->dev, rx_buffer->dma,
-				     i40e_rx_pg_size(rx_ring),
-				     DMA_FROM_DEVICE, I40E_RX_DMA_ATTR);
-		__page_frag_cache_drain(rx_buffer->page,
-					rx_buffer->pagecnt_bias);
-		/* clear contents of buffer_info */
-		rx_buffer->page = NULL;
+		struct i40e_rx_buffer *rx_buffer;
+
+		rx_buffer = i40e_rx_bi(rx_ring, rx_ring->next_to_clean);
+		/* buffer is used by skb, update page_offset */
+		i40e_rx_buffer_flip(rx_buffer, xdp->frame_sz);
 	}
+
+	return skb;
 }
 
 /**
@@ -2387,6 +2428,55 @@ static void i40e_inc_ntp(struct i40e_ring *rx_ring)
 	prefetch(I40E_RX_DESC(rx_ring, ntp));
 }
 
+/**
+ * i40e_add_xdp_frag: Add a frag to xdp_buff
+ * @xdp: xdp_buff pointing to the data
+ * @nr_frags: return number of buffers for the packet
+ * @rx_buffer: rx_buffer holding data of the current frag
+ * @size: size of data of current frag
+ */
+static int i40e_add_xdp_frag(struct xdp_buff *xdp, u32 *nr_frags,
+			     struct i40e_rx_buffer *rx_buffer, u32 size)
+{
+	struct skb_shared_info *sinfo = xdp_get_shared_info_from_buff(xdp);
+
+	if (!xdp_buff_has_frags(xdp)) {
+		sinfo->nr_frags = 0;
+		sinfo->xdp_frags_size = 0;
+		xdp_buff_set_frags_flag(xdp);
+	} else if (unlikely(sinfo->nr_frags >= MAX_SKB_FRAGS)) {
+		/* Overflowing packet: All frags need to be dropped */
+		return -ENOMEM;
+	}
+
+	__skb_fill_page_desc_noacc(sinfo, sinfo->nr_frags++, rx_buffer->page,
+				   rx_buffer->page_offset, size);
+
+	sinfo->xdp_frags_size += size;
+
+	if (page_is_pfmemalloc(rx_buffer->page))
+		xdp_buff_set_frag_pfmemalloc(xdp);
+	*nr_frags = sinfo->nr_frags;
+
+	return 0;
+}
+
+/**
+ * i40e_consume_xdp_buff - Consume all the buffers of the packet and update ntc
+ * @rx_ring: rx descriptor ring to transact packets on
+ * @xdp: xdp_buff pointing to the data
+ * @rx_buffer: rx_buffer of eop desc
+ */
+static void i40e_consume_xdp_buff(struct i40e_ring *rx_ring,
+				  struct xdp_buff *xdp,
+				  struct i40e_rx_buffer *rx_buffer)
+{
+	i40e_process_rx_buffs(rx_ring, I40E_XDP_CONSUMED, xdp);
+	i40e_put_rx_buffer(rx_ring, rx_buffer);
+	rx_ring->next_to_clean = rx_ring->next_to_process;
+	xdp->data = NULL;
+}
+
 /**
  * i40e_clean_rx_irq - Clean completed descriptors from Rx ring - bounce buf
  * @rx_ring: rx descriptor ring to transact packets on
@@ -2405,9 +2495,9 @@ static int i40e_clean_rx_irq(struct i40e_ring *rx_ring, int budget,
 {
 	unsigned int total_rx_bytes = 0, total_rx_packets = 0;
 	u16 cleaned_count = I40E_DESC_UNUSED(rx_ring);
+	u16 clean_threshold = rx_ring->count / 2;
 	unsigned int offset = rx_ring->rx_offset;
 	struct xdp_buff *xdp = &rx_ring->xdp;
-	struct sk_buff *skb = rx_ring->skb;
 	unsigned int xdp_xmit = 0;
 	struct bpf_prog *xdp_prog;
 	bool failure = false;
@@ -2419,11 +2509,14 @@ static int i40e_clean_rx_irq(struct i40e_ring *rx_ring, int budget,
 		u16 ntp = rx_ring->next_to_process;
 		struct i40e_rx_buffer *rx_buffer;
 		union i40e_rx_desc *rx_desc;
+		struct sk_buff *skb;
 		unsigned int size;
+		u32 nfrags = 0;
+		bool neop;
 		u64 qword;
 
 		/* return some buffers to hardware, one at a time is too slow */
-		if (cleaned_count >= I40E_RX_BUFFER_WRITE) {
+		if (cleaned_count >= clean_threshold) {
 			failure = failure ||
 				  i40e_alloc_rx_buffers(rx_ring, cleaned_count);
 			cleaned_count = 0;
@@ -2461,76 +2554,83 @@ static int i40e_clean_rx_irq(struct i40e_ring *rx_ring, int budget,
 			break;
 
 		i40e_trace(clean_rx_irq, rx_ring, rx_desc, xdp);
+		/* retrieve a buffer from the ring */
 		rx_buffer = i40e_get_rx_buffer(rx_ring, size);
 
-		/* retrieve a buffer from the ring */
-		if (!skb) {
+		neop = i40e_is_non_eop(rx_ring, rx_desc);
+		i40e_inc_ntp(rx_ring);
+
+		if (!xdp->data) {
 			unsigned char *hard_start;
 
 			hard_start = page_address(rx_buffer->page) +
 				     rx_buffer->page_offset - offset;
 			xdp_prepare_buff(xdp, hard_start, offset, size, true);
-			xdp_buff_clear_frags_flag(xdp);
 #if (PAGE_SIZE > 4096)
 			/* At larger PAGE_SIZE, frame_sz depend on len size */
 			xdp->frame_sz = i40e_rx_frame_truesize(rx_ring, size);
 #endif
-			xdp_res = i40e_run_xdp(rx_ring, xdp, xdp_prog);
+		} else if (i40e_add_xdp_frag(xdp, &nfrags, rx_buffer, size) &&
+			   !neop) {
+			/* Overflowing packet: Drop all frags on EOP */
+			i40e_consume_xdp_buff(rx_ring, xdp, rx_buffer);
+			break;
 		}
 
+		if (neop)
+			continue;
+
+		xdp_res = i40e_run_xdp(rx_ring, xdp, xdp_prog);
+
 		if (xdp_res) {
-			if (xdp_res & (I40E_XDP_TX | I40E_XDP_REDIR)) {
-				xdp_xmit |= xdp_res;
+			xdp_xmit |= xdp_res & (I40E_XDP_TX | I40E_XDP_REDIR);
+
+			if (unlikely(xdp_buff_has_frags(xdp))) {
+				i40e_process_rx_buffs(rx_ring, xdp_res, xdp);
+				size = xdp_get_buff_len(xdp);
+			} else if (xdp_res & (I40E_XDP_TX | I40E_XDP_REDIR)) {
 				i40e_rx_buffer_flip(rx_buffer, xdp->frame_sz);
 			} else {
 				rx_buffer->pagecnt_bias++;
 			}
 			total_rx_bytes += size;
-			total_rx_packets++;
-		} else if (skb) {
-			i40e_add_rx_frag(rx_ring, rx_buffer, skb, size);
-		} else if (ring_uses_build_skb(rx_ring)) {
-			skb = i40e_build_skb(rx_ring, rx_buffer, xdp);
 		} else {
-			skb = i40e_construct_skb(rx_ring, rx_buffer, xdp);
-		}
+			if (ring_uses_build_skb(rx_ring))
+				skb = i40e_build_skb(rx_ring, xdp, nfrags);
+			else
+				skb = i40e_construct_skb(rx_ring, xdp, nfrags);
+
+			/* drop if we failed to retrieve a buffer */
+			if (!skb) {
+				rx_ring->rx_stats.alloc_buff_failed++;
+				i40e_consume_xdp_buff(rx_ring, xdp, rx_buffer);
+				break;
+			}
 
-		/* exit if we failed to retrieve a buffer */
-		if (!xdp_res && !skb) {
-			rx_ring->rx_stats.alloc_buff_failed++;
-			rx_buffer->pagecnt_bias++;
-			break;
-		}
+			if (i40e_cleanup_headers(rx_ring, skb, rx_desc))
+				goto process_next;
 
-		i40e_put_rx_buffer(rx_ring, rx_buffer);
-		cleaned_count++;
+			/* probably a little skewed due to removing CRC */
+			total_rx_bytes += skb->len;
 
-		i40e_inc_ntp(rx_ring);
-		rx_ring->next_to_clean = rx_ring->next_to_process;
-		if (i40e_is_non_eop(rx_ring, rx_desc))
-			continue;
+			/* populate checksum, VLAN, and protocol */
+			i40e_process_skb_fields(rx_ring, rx_desc, skb);
 
-		if (xdp_res || i40e_cleanup_headers(rx_ring, skb, rx_desc)) {
-			skb = NULL;
-			continue;
+			i40e_trace(clean_rx_irq_rx, rx_ring, rx_desc, xdp);
+			napi_gro_receive(&rx_ring->q_vector->napi, skb);
 		}
 
-		/* probably a little skewed due to removing CRC */
-		total_rx_bytes += skb->len;
-
-		/* populate checksum, VLAN, and protocol */
-		i40e_process_skb_fields(rx_ring, rx_desc, skb);
-
-		i40e_trace(clean_rx_irq_rx, rx_ring, rx_desc, xdp);
-		napi_gro_receive(&rx_ring->q_vector->napi, skb);
-		skb = NULL;
-
 		/* update budget accounting */
 		total_rx_packets++;
+process_next:
+		cleaned_count += nfrags + 1;
+		i40e_put_rx_buffer(rx_ring, rx_buffer);
+		rx_ring->next_to_clean = rx_ring->next_to_process;
+
+		xdp->data = NULL;
 	}
 
 	i40e_finalize_xdp_rx(rx_ring, xdp_xmit);
-	rx_ring->skb = skb;
 
 	i40e_update_rx_stats(rx_ring, total_rx_bytes, total_rx_packets);
 
diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.h b/drivers/net/ethernet/intel/i40e/i40e_txrx.h
index 55da9fde9d17..8c3d24012c54 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.h
@@ -392,14 +392,6 @@ struct i40e_ring {
 
 	struct rcu_head rcu;		/* to avoid race on free */
 	u16 next_to_alloc;
-	struct sk_buff *skb;		/* When i40e_clean_rx_ring_irq() must
-					 * return before it sees the EOP for
-					 * the current packet, we save that skb
-					 * here and resume receiving this
-					 * packet the next time
-					 * i40e_clean_rx_ring_irq() is called
-					 * for this ring.
-					 */
 
 	struct i40e_channel *ch;
 	u16 rx_offset;
-- 
2.38.1

