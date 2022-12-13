Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06AAA64B3C2
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 12:04:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235292AbiLMLEv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Dec 2022 06:04:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235217AbiLMLE2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Dec 2022 06:04:28 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74D811145A;
        Tue, 13 Dec 2022 03:04:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670929466; x=1702465466;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9yCv6ss1LwH9V9xKbSgY5EMB0H3h7wriR3Bd6v2rbwI=;
  b=nPeAQtwLuP6qA1hHJ8id4yusnMmBcdtgWx+I0AVTQFhciJD1zaWwGKR5
   rxosrLRU7MKNKxPEhc4VGN58+3r1syrw21jhK0ThlKqGFVELRZcPtJWen
   LGStHVua36z4/PiDHzVn9QCorbvybpiaiATvmvvQg7M2RSkA2elMr/8Eu
   XgCazcIDeWDAs8b3Zg5TQqxjG1dpjp6RDt0518VIxBUK2c/IFKvzc8UKC
   nb7fpndY0FKtcw5iUfns8gvM4EJdEljprGY1n0z+yAI6/ixVD/aw3z33L
   ONLR/hqNm42BnCartwFOjdSJLSOgaX7pmqWzZK31tK4ci5hrX+5NMCfvT
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10559"; a="305744419"
X-IronPort-AV: E=Sophos;i="5.96,241,1665471600"; 
   d="scan'208";a="305744419"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2022 03:04:26 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10559"; a="679263056"
X-IronPort-AV: E=Sophos;i="5.96,241,1665471600"; 
   d="scan'208";a="679263056"
Received: from unknown (HELO paamrpdk12-S2600BPB.aw.intel.com) ([10.228.151.145])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2022 03:04:23 -0800
From:   Tirthendu Sarkar <tirthendu.sarkar@intel.com>
To:     tirtha@gmail.com, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, magnus.karlsson@intel.com,
        maciej.fijalkowski@intel.com
Subject: [PATCH intel-next 5/5] i40e: add support for XDP multi-buffer Rx
Date:   Tue, 13 Dec 2022 16:20:23 +0530
Message-Id: <20221213105023.196409-6-tirthendu.sarkar@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221213105023.196409-1-tirthendu.sarkar@intel.com>
References: <20221213105023.196409-1-tirthendu.sarkar@intel.com>
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

This patch adds multi-buffer support for the i40e_driver.

i40e_clean_rx_irq() is modified to collate all the buffers of a packet
before calling the XDP program. EOP check is done before getting rx_buffer
and 'next_to_process' is incremented for all non-EOP frags while
'next_to_clean' stays at the first descriptor of the packet. Once EOP is
encountered, xdp_buff is built for the packet along with all the frags.

New functions are added for building multi-buffer xdp and for post
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

With this patchset the performance improves it by 1% to 3 % for 64B sized
packets depending on the type of action for xdp_rxq_info program from
samples/bpf/.

Signed-off-by: Tirthendu Sarkar <tirthendu.sarkar@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c |  18 +-
 drivers/net/ethernet/intel/i40e/i40e_txrx.c | 331 +++++++++++++++-----
 drivers/net/ethernet/intel/i40e/i40e_txrx.h |   8 -
 3 files changed, 260 insertions(+), 97 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 95485b56d6c3..ce2bcc22f6cc 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -2922,8 +2922,10 @@ static int i40e_change_mtu(struct net_device *netdev, int new_mtu)
 
 	if (i40e_enabled_xdp_vsi(vsi)) {
 		int frame_size = new_mtu + ETH_HLEN + ETH_FCS_LEN + VLAN_HLEN;
+		struct bpf_prog *prog = READ_ONCE(vsi->xdp_prog);
 
-		if (frame_size > i40e_max_xdp_frame_size(vsi))
+		if (!prog->aux->xdp_has_frags &&
+		    frame_size > i40e_max_xdp_frame_size(vsi))
 			return -EINVAL;
 	}
 
@@ -13276,16 +13278,20 @@ static netdev_features_t i40e_features_check(struct sk_buff *skb,
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
+	if (prog && !prog->aux->xdp_has_frags) {
+		int fsz = vsi->netdev->mtu + ETH_HLEN + ETH_FCS_LEN + VLAN_HLEN;
+		/* Don't allow frames that span over multiple buffers if
+		 * underlying XDP program does not support frags
+		 */
+		if (fsz > vsi->rx_buf_len) {
+			NL_SET_ERR_MSG_MOD(extack, "MTU is too large for linear frames and XDP prog does not support frags");
+			return -EINVAL;
+		}
 	}
 
 	/* When turning XDP on->off/off->on we reset and rebuild the rings. */
diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
index dc9dc0acdd37..c67e71ff9b7c 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -14,6 +14,8 @@
 #define I40E_TXD_CMD (I40E_TX_DESC_CMD_EOP | I40E_TX_DESC_CMD_RS)
 #define I40E_IDX_NEXT(n, max) { if (++(n) > (max)) n = 0; }
 #define I40E_INC_NEXT(p, c, max) do { I40E_IDX_NEXT(p, max); c = p; } while (0)
+#define I40E_IS_FDIR(b) (!(b)->page)
+
 /**
  * i40e_fdir - Generate a Flow Director descriptor based on fdata
  * @tx_ring: Tx ring to send buffer on
@@ -1479,9 +1481,6 @@ void i40e_clean_rx_ring(struct i40e_ring *rx_ring)
 	if (!rx_ring->rx_bi)
 		return;
 
-	dev_kfree_skb(rx_ring->skb);
-	rx_ring->skb = NULL;
-
 	if (rx_ring->xsk_pool) {
 		i40e_xsk_clean_rx_ring(rx_ring);
 		goto skip_free;
@@ -2022,40 +2021,6 @@ static bool i40e_can_reuse_rx_page(struct i40e_rx_buffer *rx_buffer,
 	return true;
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
-#if (PAGE_SIZE < 8192)
-	rx_buffer->page_offset ^= truesize;
-#else
-	rx_buffer->page_offset += truesize;
-#endif
-}
-
 /**
  * i40e_get_rx_buffer - Fetch Rx buffer and synchronize data for use
  * @rx_ring: rx descriptor ring to transact packets on
@@ -2113,12 +2078,18 @@ static struct sk_buff *i40e_construct_skb(struct i40e_ring *rx_ring,
 #else
 	unsigned int truesize = SKB_DATA_ALIGN(size);
 #endif
+	struct skb_shared_info *sinfo;
 	unsigned int headlen;
 	struct sk_buff *skb;
+	u32 nr_frags = 0;
 
 	/* prefetch first cache line of first page */
 	net_prefetch(xdp->data);
 
+	if (unlikely(xdp_buff_has_frags(xdp))) {
+		sinfo = xdp_get_shared_info_from_buff(xdp);
+		nr_frags = sinfo->nr_frags;
+	}
 	/* Note, we get here by enabling legacy-rx via:
 	 *
 	 *    ethtool --set-priv-flags <dev> legacy-rx on
@@ -2155,6 +2126,10 @@ static struct sk_buff *i40e_construct_skb(struct i40e_ring *rx_ring,
 	/* update all of the pointers */
 	size -= headlen;
 	if (size) {
+		if (unlikely(nr_frags >= MAX_SKB_FRAGS - 1)) {
+			dev_kfree_skb(skb);
+			return NULL;
+		}
 		skb_add_rx_frag(skb, 0, rx_buffer->page,
 				rx_buffer->page_offset + headlen,
 				size, truesize);
@@ -2170,6 +2145,17 @@ static struct sk_buff *i40e_construct_skb(struct i40e_ring *rx_ring,
 		rx_buffer->pagecnt_bias++;
 	}
 
+	if (unlikely(xdp_buff_has_frags(xdp))) {
+		struct skb_shared_info *skinfo = skb_shinfo(skb);
+
+		memcpy(&skinfo->frags[skinfo->nr_frags], &sinfo->frags[0],
+		       sizeof(skb_frag_t) * nr_frags);
+
+		xdp_update_skb_shared_info(skb, skinfo->nr_frags + nr_frags,
+					   sinfo->xdp_frags_size,
+					   nr_frags * xdp->frame_sz,
+					   xdp_buff_is_frag_pfmemalloc(xdp));
+	}
 	return skb;
 }
 
@@ -2194,8 +2180,14 @@ static struct sk_buff *i40e_build_skb(struct i40e_ring *rx_ring,
 				SKB_DATA_ALIGN(xdp->data_end -
 					       xdp->data_hard_start);
 #endif
+	struct skb_shared_info *sinfo;
 	struct sk_buff *skb;
+	u32 nr_frags;
 
+	if (unlikely(xdp_buff_has_frags(xdp))) {
+		sinfo = xdp_get_shared_info_from_buff(xdp);
+		nr_frags = sinfo->nr_frags;
+	}
 	/* Prefetch first cache line of first page. If xdp->data_meta
 	 * is unused, this points exactly as xdp->data, otherwise we
 	 * likely have a consumer accessing first few bytes of meta
@@ -2220,6 +2212,11 @@ static struct sk_buff *i40e_build_skb(struct i40e_ring *rx_ring,
 #else
 	rx_buffer->page_offset += truesize;
 #endif
+	if (unlikely(xdp_buff_has_frags(xdp)))
+		xdp_update_skb_shared_info(skb, nr_frags,
+					   sinfo->xdp_frags_size,
+					   nr_frags * xdp->frame_sz,
+					   xdp_buff_is_frag_pfmemalloc(xdp));
 
 	return skb;
 }
@@ -2408,6 +2405,163 @@ void i40e_finalize_xdp_rx(struct i40e_ring *rx_ring, unsigned int xdp_res)
 	}
 }
 
+/**
+ * i40e_process_rx_buffers- Post XDP processing of buffers
+ * @rx_ring: Rx descriptor ring to transact packets on
+ * @ntc: first desc index of the packet
+ * @ntp: last desc index of the packet
+ * @xdp_res: Result of the XDP program
+ * @xdp: xdp_buff pointing to the data
+ * @esize: EOP data size
+ * @total_rx_bytes: Received bytes counter
+ **/
+static void i40e_process_rx_buffers(struct i40e_ring *rx_ring, u32 ntc,
+				    u32 ntp, int xdp_res, struct xdp_buff *xdp,
+				    u32 esize, u32 *total_rx_bytes)
+
+{
+	struct i40e_rx_buffer *rx_buffer = i40e_rx_bi(rx_ring, ntc);
+	bool buf_flip = (xdp_res & (I40E_XDP_TX | I40E_XDP_REDIR));
+	bool buf_put = (xdp_res != I40E_XDP_EXIT);
+	u32 size = rx_ring->rx_buf_len;
+	u16 rmax = rx_ring->count - 1;
+	u32 nr_frags = 0;
+
+	xdp_buff_clear_frags_flag(xdp);
+
+	if (xdp_res == I40E_XDP_PASS) {
+		buf_flip = true;
+		/* First buffer has already been flipped during skb build, now
+		 * put it back on ring.
+		 */
+		i40e_put_rx_buffer(rx_ring, rx_buffer);
+		/* Flip the EOP buffer. It will be put back on ring after
+		 * returning from i40e_process_rx_buffers().
+		 */
+		i40e_rx_buffer_flip(rx_ring, i40e_rx_bi(rx_ring, ntp), esize);
+		nr_frags++;
+		goto next_buf;
+	}
+
+	while (1) {
+		if (nr_frags++ < MAX_SKB_FRAGS) {
+			if (buf_flip)
+				i40e_rx_buffer_flip(rx_ring, rx_buffer, size);
+			else
+				rx_buffer->pagecnt_bias++;
+			if (buf_put)
+				i40e_put_rx_buffer(rx_ring, rx_buffer);
+		} else {
+			xdp->data = NULL;
+			i40e_reuse_rx_page(rx_ring, rx_buffer);
+		}
+next_buf:
+		I40E_IDX_NEXT(ntc, rmax);
+		if (ntc == ntp) {
+			if (buf_put && xdp->data)
+				*total_rx_bytes += nr_frags * size;
+			return;
+		}
+		rx_buffer = i40e_rx_bi(rx_ring, ntc);
+		if (I40E_IS_FDIR(rx_buffer))
+			goto next_buf;
+	}
+}
+
+/**
+ * i40e_build_xdp - Build XDP buffer from a Rx buffer
+ * @rx_ring: rx descriptor ring to transact packets on
+ * @offset: rx_ring offset
+ * @rxb: Rx buffer to pull data from
+ * @size: size of data
+ * @xdp: xdp_buff pointing to the data
+ **/
+static void i40e_build_xdp(struct i40e_ring *rx_ring, u32 offset,
+			   struct i40e_rx_buffer *rxb, u32 size,
+			   struct xdp_buff *xdp)
+{
+	unsigned char *hard_start;
+
+	hard_start = page_address(rxb->page) + rxb->page_offset - offset;
+	xdp_prepare_buff(xdp, hard_start, offset, size, true);
+#if (PAGE_SIZE > 4096)
+	/* At larger PAGE_SIZE, frame_sz depend on len size */
+	xdp->frame_sz = i40e_rx_frame_truesize(rx_ring, size);
+#endif
+}
+
+/**
+ * i40e_set_skb_frag - set page, offset and size of a frag
+ * @frag: skb frag being set
+ * @rx_buffer: rx buffer to pull data from
+ * @size: size of the frag
+ * @xdp: xdp_buff pointing to the data
+ */
+static void i40e_set_skb_frag(skb_frag_t *frag,
+			      struct i40e_rx_buffer *rx_buffer,
+			      u32 size, struct xdp_buff *xdp)
+{
+	__skb_frag_set_page(frag, rx_buffer->page);
+	skb_frag_off_set(frag, rx_buffer->page_offset);
+	skb_frag_size_set(frag, size);
+
+	if (page_is_pfmemalloc(rx_buffer->page))
+		xdp_buff_set_frag_pfmemalloc(xdp);
+}
+
+/**
+ * i40e_build_xdp_mb - Build XDP buffer from multiple Rx buffers
+ * @rx_ring: rx descriptor ring to transact packets on
+ * @offset: rx_ring offset
+ * @rx_buffer: EOP rx buffer to pull data from
+ * @eop_size: size of data for the last fragment. All preceding
+ *            fragments will be of max rx_buffer size
+ * @ntc: first desc index of the packet
+ * @ntp: last desc index of the packet
+ * @xdp: xdp_buff pointing to the data
+ **/
+static int i40e_build_xdp_mb(struct i40e_ring *rx_ring, u32 offset,
+			     struct i40e_rx_buffer *rx_buffer, u32 eop_size,
+			     u32 ntc, u32 ntp, struct xdp_buff *xdp)
+{
+	u32 neop_size = rx_ring->rx_buf_len; /* size of non-EOP buffers */
+	u16 rmax = rx_ring->count - 1;
+	struct skb_shared_info *sinfo;
+	struct  i40e_rx_buffer *rxb;
+	skb_frag_t *frag;
+	u32 num = 0;
+
+	rxb = i40e_get_rx_buffer(rx_ring, neop_size, ntc);
+	i40e_build_xdp(rx_ring, offset, rxb, neop_size, xdp);
+	sinfo = xdp_get_shared_info_from_buff(xdp);
+	frag = &sinfo->frags[0];
+	xdp_buff_set_frags_flag(xdp);
+
+	do {
+		I40E_IDX_NEXT(ntc, rmax);
+		if (ntc == ntp) {
+			i40e_set_skb_frag(frag, rx_buffer, eop_size, xdp);
+			sinfo->xdp_frags_size = num * neop_size + eop_size;
+			sinfo->nr_frags = num + 1;
+			return 0;
+		}
+		if (I40E_IS_FDIR(i40e_rx_bi(rx_ring, ntc)))
+			continue;
+		rxb = i40e_get_rx_buffer(rx_ring, neop_size, ntc);
+		i40e_set_skb_frag(frag, rxb, neop_size, xdp);
+		frag++;
+		num++;
+	} while (likely(num < MAX_SKB_FRAGS));
+
+	/* Unlikely error case: increase pagecnt_bias of the EOP buffer before
+	 * putting it back on ring. For rest of the buffers this will be done
+	 * in i40e_process_rx_buffers().
+	 */
+	rx_buffer->pagecnt_bias++;
+
+	return -EOPNOTSUPP;
+}
+
 /**
  * i40e_clean_rx_irq - Clean completed descriptors from Rx ring - bounce buf
  * @rx_ring: rx descriptor ring to transact packets on
@@ -2426,7 +2580,6 @@ static int i40e_clean_rx_irq(struct i40e_ring *rx_ring, int budget,
 {
 	unsigned int total_rx_bytes = 0, total_rx_packets = 0, frame_sz = 0;
 	unsigned int offset = rx_ring->rx_offset;
-	struct sk_buff *skb = rx_ring->skb;
 	u16 ntp = rx_ring->next_to_process;
 	u16 ntc = rx_ring->next_to_clean;
 	u16 rmax = rx_ring->count - 1;
@@ -2446,6 +2599,7 @@ static int i40e_clean_rx_irq(struct i40e_ring *rx_ring, int budget,
 	while (likely(total_rx_packets < (unsigned int)budget)) {
 		struct i40e_rx_buffer *rx_buffer;
 		union i40e_rx_desc *rx_desc;
+		struct sk_buff *skb;
 		unsigned int size;
 		u64 qword;
 
@@ -2469,7 +2623,10 @@ static int i40e_clean_rx_irq(struct i40e_ring *rx_ring, int budget,
 						      rx_desc->raw.qword[0],
 						      qword);
 			rx_buffer = i40e_rx_bi(rx_ring, ntp);
-			I40E_INC_NEXT(ntp, ntc, rmax);
+			if (ntc == ntp)
+				I40E_INC_NEXT(ntp, ntc, rmax);
+			else
+				I40E_IDX_NEXT(ntp, rmax);
 			i40e_reuse_rx_page(rx_ring, rx_buffer);
 			continue;
 		}
@@ -2480,23 +2637,25 @@ static int i40e_clean_rx_irq(struct i40e_ring *rx_ring, int budget,
 			break;
 
 		i40e_trace(clean_rx_irq, rx_ring, rx_desc, skb);
-		rx_buffer = i40e_get_rx_buffer(rx_ring, size, ntp);
 
-		/* retrieve a buffer from the ring */
-		if (!skb) {
-			unsigned char *hard_start;
-
-			hard_start = page_address(rx_buffer->page) +
-				     rx_buffer->page_offset - offset;
-			xdp_prepare_buff(&xdp, hard_start, offset, size, true);
-			xdp_buff_clear_frags_flag(&xdp);
-#if (PAGE_SIZE > 4096)
-			/* At larger PAGE_SIZE, frame_sz depend on len size */
-			xdp.frame_sz = i40e_rx_frame_truesize(rx_ring, size);
-#endif
-			xdp_res = i40e_run_xdp(rx_ring, &xdp, xdp_prog);
+		if (i40e_is_non_eop(rx_ring, rx_desc)) {
+			I40E_IDX_NEXT(ntp, rmax);
+			continue;
 		}
 
+		/* retrieve EOP buffer from the ring */
+		rx_buffer = i40e_get_rx_buffer(rx_ring, size, ntp);
+
+		if (likely(ntc == ntp))
+			i40e_build_xdp(rx_ring, offset, rx_buffer, size, &xdp);
+		else
+			if (i40e_build_xdp_mb(rx_ring, offset, rx_buffer,
+					      size, ntc, ntp, &xdp)) {
+				xdp_res = I40E_XDP_CONSUMED;
+				goto process_frags;
+			}
+		xdp_res = i40e_run_xdp(rx_ring, &xdp, xdp_prog);
+
 		if (xdp_res) {
 			if (xdp_res & (I40E_XDP_TX | I40E_XDP_REDIR)) {
 				xdp_xmit |= xdp_res;
@@ -2504,46 +2663,53 @@ static int i40e_clean_rx_irq(struct i40e_ring *rx_ring, int budget,
 			} else {
 				rx_buffer->pagecnt_bias++;
 			}
-			total_rx_bytes += size;
-			total_rx_packets++;
-		} else if (skb) {
-			i40e_add_rx_frag(rx_ring, rx_buffer, skb, size);
-		} else if (ring_uses_build_skb(rx_ring)) {
-			skb = i40e_build_skb(rx_ring, rx_buffer, &xdp);
 		} else {
-			skb = i40e_construct_skb(rx_ring, rx_buffer, &xdp);
-		}
+			struct i40e_rx_buffer *rxb = i40e_rx_bi(rx_ring, ntc);
 
-		/* exit if we failed to retrieve a buffer */
-		if (!xdp_res && !skb) {
-			rx_ring->rx_stats.alloc_buff_failed++;
-			rx_buffer->pagecnt_bias++;
-			break;
-		}
+			if (ring_uses_build_skb(rx_ring))
+				skb = i40e_build_skb(rx_ring, rxb, &xdp);
+			else
+				skb = i40e_construct_skb(rx_ring, rxb, &xdp);
 
-		i40e_put_rx_buffer(rx_ring, rx_buffer);
+			/* exit if we failed to retrieve a buffer */
+			if (!skb) {
+				rx_ring->rx_stats.alloc_buff_failed++;
+				rx_buffer->pagecnt_bias++;
+				if (ntc == ntp)
+					break;
+				xdp_res = I40E_XDP_EXIT;
+				goto process_frags;
+			}
 
-		I40E_INC_NEXT(ntp, ntc, rmax);
-		if (i40e_is_non_eop(rx_ring, rx_desc))
-			continue;
+			if (i40e_cleanup_headers(rx_ring, skb, rx_desc)) {
+				xdp.data = NULL;
+				goto process_frags;
+			}
+			/* populate checksum, VLAN, and protocol */
+			i40e_process_skb_fields(rx_ring, rx_desc, skb);
 
-		if (xdp_res || i40e_cleanup_headers(rx_ring, skb, rx_desc)) {
-			skb = NULL;
-			continue;
+			i40e_trace(clean_rx_irq_rx, rx_ring, rx_desc, skb);
+			napi_gro_receive(&rx_ring->q_vector->napi, skb);
 		}
 
 		/* probably a little skewed due to removing CRC */
-		total_rx_bytes += skb->len;
-
-		/* populate checksum, VLAN, and protocol */
-		i40e_process_skb_fields(rx_ring, rx_desc, skb);
-
-		i40e_trace(clean_rx_irq_rx, rx_ring, rx_desc, skb);
-		napi_gro_receive(&rx_ring->q_vector->napi, skb);
-		skb = NULL;
+		total_rx_bytes += size;
 
 		/* update budget accounting */
 		total_rx_packets++;
+
+process_frags:
+		if (unlikely(xdp_buff_has_frags(&xdp))) {
+			i40e_process_rx_buffers(rx_ring, ntc, ntp, xdp_res,
+						&xdp, size, &total_rx_bytes);
+			if (xdp_res == I40E_XDP_EXIT) {
+				/* Roll back ntp to first desc on the packet */
+				ntp = ntc;
+				break;
+			}
+		}
+		i40e_put_rx_buffer(rx_ring, rx_buffer);
+		I40E_INC_NEXT(ntp, ntc, rmax);
 	}
 	rx_ring->next_to_process = ntp;
 	rx_ring->next_to_clean = ntc;
@@ -2551,7 +2717,6 @@ static int i40e_clean_rx_irq(struct i40e_ring *rx_ring, int budget,
 	failure = i40e_alloc_rx_buffers(rx_ring, I40E_DESC_UNUSED(rx_ring));
 
 	i40e_finalize_xdp_rx(rx_ring, xdp_xmit);
-	rx_ring->skb = skb;
 
 	i40e_update_rx_stats(rx_ring, total_rx_bytes, total_rx_packets);
 
diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.h b/drivers/net/ethernet/intel/i40e/i40e_txrx.h
index c1b5013f5c9c..2809be8f23d2 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.h
@@ -385,14 +385,6 @@ struct i40e_ring {
 
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
2.34.1

