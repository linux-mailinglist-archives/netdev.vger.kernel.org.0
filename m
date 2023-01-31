Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C26CD6837D1
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 21:47:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231639AbjAaUrB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 15:47:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231359AbjAaUq6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 15:46:58 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41FD959E65;
        Tue, 31 Jan 2023 12:46:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675197984; x=1706733984;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YusxaeGIup1x1x3XnIRRd+ftay0shWmRoVj6CODXy1o=;
  b=AUe8kMNya7oFacpddVQKusJ+6MvRDa+vEfmgt+kXBsm1LE5uh/P3wCwY
   A41mqIureKcL2ZCOiQkRTybk0yckiZwr56UI7kxBk+Ww91BGvr7EBQN0i
   VQt0PTiFx4RUFN3iEWg1BjhuhIAHVtJgtxRvuOTgIaMDhhsPpqEqUDiaX
   84hjYjNHx3aAq4tINpviqe3k1VXuBQgmgQGvgIrnUtlEYSodiuMKds0Dp
   sQhVDhNtpOderom2IXxHQzytiNY/0P8dsvE44g3WQaTszqpbVAHQiRfUc
   DtszSNI1vf1dbw4E+Ybpg6ppY54ulpA214yTaeMIxiL2CrsPwz/9/H5JS
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10607"; a="414167497"
X-IronPort-AV: E=Sophos;i="5.97,261,1669104000"; 
   d="scan'208";a="414167497"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2023 12:46:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10607"; a="788595466"
X-IronPort-AV: E=Sophos;i="5.97,261,1669104000"; 
   d="scan'208";a="788595466"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by orsmga004.jf.intel.com with ESMTP; 31 Jan 2023 12:45:35 -0800
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        anthony.l.nguyen@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, alexandr.lobakin@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH bpf-next 10/13] ice: add support for XDP multi-buffer on Rx side
Date:   Tue, 31 Jan 2023 21:45:03 +0100
Message-Id: <20230131204506.219292-11-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20230131204506.219292-1-maciej.fijalkowski@intel.com>
References: <20230131204506.219292-1-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ice driver needs to be a bit reworked on Rx data path in order to
support multi-buffer XDP. For skb path, it currently works in a way that
Rx ring carries pointer to skb so if driver didn't manage to combine
fragmented frame at current NAPI instance, it can restore the state on
next instance and keep looking for last fragment (so descriptor with EOP
bit set). What needs to be achieved is that xdp_buff needs to be
combined in such way (linear + frags part) in the first place. Then skb
will be ready to go in case of XDP_PASS or BPF program being not present
on interface. If BPF program is there, it would work on multi-buffer
XDP. At this point xdp_buff resides directly on Rx ring, so given the
fact that skb will be built straight from xdp_buff, there will be no
further need to carry skb on Rx ring.

Besides removing skb pointer from Rx ring, lots of members have been
moved around within ice_rx_ring. First and foremost reason was to place
rx_buf with xdp_buff on the same cacheline. This means that once we
touch rx_buf (which is a preceding step before touching xdp_buff),
xdp_buff will already be hot in cache. Second thing was that xdp_rxq is
used rather rarely and it occupies a separate cacheline, so maybe it is
better to have it at the end of ice_rx_ring.

Other change that affects ice_rx_ring is the introduction of
ice_rx_ring::first_desc. Its purpose is twofold - first is to propagate
rx_buf->act to all the parts of current xdp_buff after running XDP
program, so that ice_put_rx_buf() that got moved out of the main Rx
processing loop will be able to tak an appriopriate action on each
buffer. Second is for ice_construct_skb().

ice_construct_skb() has a copybreak mechanism which had an explicit
impact on xdp_buff->skb conversion in the new approach when legacy Rx
flag is toggled. It works in a way that linear part is 256 bytes long,
if frame is bigger than that, remaining bytes are going as a frag to
skb_shared_info.

This means while memcpying frags from xdp_buff to newly allocated skb,
care needs to be taken when picking the destination frag array entry.
Upon the time ice_construct_skb() is called, when dealing with
fragmented frame, current rx_buf points to the *last* fragment, but
copybreak needs to be done against the first one.  That's where
ice_rx_ring::first_desc helps.

When frame building spans across NAPI polls (DD bit is not set on
current descriptor and xdp->data is not NULL) with current Rx buffer
handling state there might be some problems.
Since calls to ice_put_rx_buf() were pulled out of the main Rx
processing loop and were scoped from cached_ntc to current ntc, remember
that now mentioned function relies on rx_buf->act, which is set within
ice_run_xdp(). ice_run_xdp() is called when EOP bit was found, so
currently we could put Rx buffer with rx_buf->act being *uninitialized*.
To address this, change scoping to rely on first_desc on both boundaries
instead.

This also implies that cleaned_count which is used as an input to
ice_alloc_rx_buffers() and tells how many new buffers should be refilled
has to be adjusted. If it stayed as is, what could happen is a case
where ntc would go over ntu.

Therefore, remove cleaned_count altogether and use against allocing
routine newly introduced ICE_RX_DESC_UNUSED() macro which is an
equivalent of ICE_DESC_UNUSED() dedicated for Rx side and based on
struct ice_rx_ring::first_desc instead of next_to_clean.

Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_base.c     |  17 +-
 drivers/net/ethernet/intel/ice/ice_ethtool.c  |   2 +-
 drivers/net/ethernet/intel/ice/ice_main.c     |  13 +-
 drivers/net/ethernet/intel/ice/ice_txrx.c     | 202 +++++++++++-------
 drivers/net/ethernet/intel/ice/ice_txrx.h     |  34 +--
 drivers/net/ethernet/intel/ice/ice_txrx_lib.h |  30 +++
 6 files changed, 200 insertions(+), 98 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_base.c b/drivers/net/ethernet/intel/ice/ice_base.c
index 5b66f6f7db78..1911d644dfa8 100644
--- a/drivers/net/ethernet/intel/ice/ice_base.c
+++ b/drivers/net/ethernet/intel/ice/ice_base.c
@@ -492,7 +492,7 @@ static int ice_setup_rx_ctx(struct ice_rx_ring *ring)
 int ice_vsi_cfg_rxq(struct ice_rx_ring *ring)
 {
 	struct device *dev = ice_pf_to_dev(ring->vsi->back);
-	u16 num_bufs = ICE_DESC_UNUSED(ring);
+	u32 num_bufs = ICE_RX_DESC_UNUSED(ring);
 	int err;
 
 	ring->rx_buf_len = ring->vsi->rx_buf_len;
@@ -500,8 +500,10 @@ int ice_vsi_cfg_rxq(struct ice_rx_ring *ring)
 	if (ring->vsi->type == ICE_VSI_PF) {
 		if (!xdp_rxq_info_is_reg(&ring->xdp_rxq))
 			/* coverity[check_return] */
-			xdp_rxq_info_reg(&ring->xdp_rxq, ring->netdev,
-					 ring->q_index, ring->q_vector->napi.napi_id);
+			__xdp_rxq_info_reg(&ring->xdp_rxq, ring->netdev,
+					   ring->q_index,
+					   ring->q_vector->napi.napi_id,
+					   ring->vsi->rx_buf_len);
 
 		ring->xsk_pool = ice_xsk_pool(ring);
 		if (ring->xsk_pool) {
@@ -521,9 +523,11 @@ int ice_vsi_cfg_rxq(struct ice_rx_ring *ring)
 		} else {
 			if (!xdp_rxq_info_is_reg(&ring->xdp_rxq))
 				/* coverity[check_return] */
-				xdp_rxq_info_reg(&ring->xdp_rxq,
-						 ring->netdev,
-						 ring->q_index, ring->q_vector->napi.napi_id);
+				__xdp_rxq_info_reg(&ring->xdp_rxq,
+						   ring->netdev,
+						   ring->q_index,
+						   ring->q_vector->napi.napi_id,
+						   ring->vsi->rx_buf_len);
 
 			err = xdp_rxq_info_reg_mem_model(&ring->xdp_rxq,
 							 MEM_TYPE_PAGE_SHARED,
@@ -534,6 +538,7 @@ int ice_vsi_cfg_rxq(struct ice_rx_ring *ring)
 	}
 
 	xdp_init_buff(&ring->xdp, ice_rx_pg_size(ring) / 2, &ring->xdp_rxq);
+	ring->xdp.data = NULL;
 	err = ice_setup_rx_ctx(ring);
 	if (err) {
 		dev_err(dev, "ice_setup_rx_ctx failed for RxQ %d, err %d\n",
diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index 4191994d8f3a..205d32e4c317 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -3073,7 +3073,7 @@ ice_set_ringparam(struct net_device *netdev, struct ethtool_ringparam *ring,
 
 		/* allocate Rx buffers */
 		err = ice_alloc_rx_bufs(&rx_rings[i],
-					ICE_DESC_UNUSED(&rx_rings[i]));
+					ICE_RX_DESC_UNUSED(&rx_rings[i]));
 rx_unwind:
 		if (err) {
 			while (i) {
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index a9d644276dfd..b04f7729d5ba 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -2888,9 +2888,12 @@ ice_xdp_setup_prog(struct ice_vsi *vsi, struct bpf_prog *prog,
 	bool if_running = netif_running(vsi->netdev);
 	int ret = 0, xdp_ring_err = 0;
 
-	if (frame_size > ice_max_xdp_frame_size(vsi)) {
-		NL_SET_ERR_MSG_MOD(extack, "MTU too large for loading XDP");
-		return -EOPNOTSUPP;
+	if (prog && !prog->aux->xdp_has_frags) {
+		if (frame_size > ice_max_xdp_frame_size(vsi)) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "MTU is too large for linear frames and XDP prog does not support frags");
+			return -EOPNOTSUPP;
+		}
 	}
 
 	/* need to stop netdev while setting up the program for Rx rings */
@@ -7345,6 +7348,7 @@ static int ice_change_mtu(struct net_device *netdev, int new_mtu)
 	struct ice_netdev_priv *np = netdev_priv(netdev);
 	struct ice_vsi *vsi = np->vsi;
 	struct ice_pf *pf = vsi->back;
+	struct bpf_prog *prog;
 	u8 count = 0;
 	int err = 0;
 
@@ -7353,7 +7357,8 @@ static int ice_change_mtu(struct net_device *netdev, int new_mtu)
 		return 0;
 	}
 
-	if (ice_is_xdp_ena_vsi(vsi)) {
+	prog = vsi->xdp_prog;
+	if (prog && !prog->aux->xdp_has_frags) {
 		int frame_size = ice_max_xdp_frame_size(vsi);
 
 		if (new_mtu + ICE_ETH_PKT_HDR_PAD > frame_size) {
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index dd4d7f5ba6bd..98f42b20636a 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -382,6 +382,7 @@ int ice_setup_tx_ring(struct ice_tx_ring *tx_ring)
  */
 void ice_clean_rx_ring(struct ice_rx_ring *rx_ring)
 {
+	struct xdp_buff *xdp = &rx_ring->xdp;
 	struct device *dev = rx_ring->dev;
 	u32 size;
 	u16 i;
@@ -390,16 +391,16 @@ void ice_clean_rx_ring(struct ice_rx_ring *rx_ring)
 	if (!rx_ring->rx_buf)
 		return;
 
-	if (rx_ring->skb) {
-		dev_kfree_skb(rx_ring->skb);
-		rx_ring->skb = NULL;
-	}
-
 	if (rx_ring->xsk_pool) {
 		ice_xsk_clean_rx_ring(rx_ring);
 		goto rx_skip_free;
 	}
 
+	if (xdp->data) {
+		xdp_return_buff(xdp);
+		xdp->data = NULL;
+	}
+
 	/* Free all the Rx ring sk_buffs */
 	for (i = 0; i < rx_ring->count; i++) {
 		struct ice_rx_buf *rx_buf = &rx_ring->rx_buf[i];
@@ -437,6 +438,7 @@ void ice_clean_rx_ring(struct ice_rx_ring *rx_ring)
 
 	rx_ring->next_to_alloc = 0;
 	rx_ring->next_to_clean = 0;
+	rx_ring->first_desc = 0;
 	rx_ring->next_to_use = 0;
 }
 
@@ -506,6 +508,7 @@ int ice_setup_rx_ring(struct ice_rx_ring *rx_ring)
 
 	rx_ring->next_to_use = 0;
 	rx_ring->next_to_clean = 0;
+	rx_ring->first_desc = 0;
 
 	if (ice_is_xdp_ena_vsi(rx_ring->vsi))
 		WRITE_ONCE(rx_ring->xdp_prog, rx_ring->vsi->xdp_prog);
@@ -598,6 +601,8 @@ ice_run_xdp(struct ice_rx_ring *rx_ring, struct xdp_buff *xdp,
 	}
 exit:
 	rx_buf->act = ret;
+	if (unlikely(xdp_buff_has_frags(xdp)))
+		ice_set_rx_bufs_act(xdp, rx_ring, ret);
 }
 
 /**
@@ -721,7 +726,7 @@ ice_alloc_mapped_page(struct ice_rx_ring *rx_ring, struct ice_rx_buf *bi)
  * buffers. Then bump tail at most one time. Grouping like this lets us avoid
  * multiple tail writes per call.
  */
-bool ice_alloc_rx_bufs(struct ice_rx_ring *rx_ring, u16 cleaned_count)
+bool ice_alloc_rx_bufs(struct ice_rx_ring *rx_ring, unsigned int cleaned_count)
 {
 	union ice_32b_rx_flex_desc *rx_desc;
 	u16 ntu = rx_ring->next_to_use;
@@ -838,26 +843,44 @@ ice_can_reuse_rx_page(struct ice_rx_buf *rx_buf)
 }
 
 /**
- * ice_add_rx_frag - Add contents of Rx buffer to sk_buff as a frag
+ * ice_add_xdp_frag - Add contents of Rx buffer to xdp buf as a frag
  * @rx_ring: Rx descriptor ring to transact packets on
- * @xdp: XDP buffer
+ * @xdp: xdp buff to place the data into
  * @rx_buf: buffer containing page to add
- * @skb: sk_buff to place the data into
  * @size: packet length from rx_desc
  *
- * This function will add the data contained in rx_buf->page to the skb.
- * It will just attach the page as a frag to the skb.
- * The function will then update the page offset.
+ * This function will add the data contained in rx_buf->page to the xdp buf.
+ * It will just attach the page as a frag.
  */
-static void
-ice_add_rx_frag(struct ice_rx_ring *rx_ring, struct xdp_buff *xdp,
-		struct ice_rx_buf *rx_buf, struct sk_buff *skb,
-		unsigned int size)
+static int
+ice_add_xdp_frag(struct ice_rx_ring *rx_ring, struct xdp_buff *xdp,
+		 struct ice_rx_buf *rx_buf, const unsigned int size)
 {
+	struct skb_shared_info *sinfo = xdp_get_shared_info_from_buff(xdp);
+
 	if (!size)
-		return;
-	skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags, rx_buf->page,
-			rx_buf->page_offset, size, xdp->frame_sz);
+		return 0;
+
+	if (!xdp_buff_has_frags(xdp)) {
+		sinfo->nr_frags = 0;
+		sinfo->xdp_frags_size = 0;
+		xdp_buff_set_frags_flag(xdp);
+	}
+
+	if (unlikely(sinfo->nr_frags == MAX_SKB_FRAGS)) {
+		if (unlikely(xdp_buff_has_frags(xdp)))
+			ice_set_rx_bufs_act(xdp, rx_ring, ICE_XDP_CONSUMED);
+		return -ENOMEM;
+	}
+
+	__skb_fill_page_desc_noacc(sinfo, sinfo->nr_frags++, rx_buf->page,
+				   rx_buf->page_offset, size);
+	sinfo->xdp_frags_size += size;
+
+	if (page_is_pfmemalloc(rx_buf->page))
+		xdp_buff_set_frag_pfmemalloc(xdp);
+
+	return 0;
 }
 
 /**
@@ -928,19 +951,25 @@ ice_get_rx_buf(struct ice_rx_ring *rx_ring, const unsigned int size,
 /**
  * ice_build_skb - Build skb around an existing buffer
  * @rx_ring: Rx descriptor ring to transact packets on
- * @rx_buf: Rx buffer to pull data from
  * @xdp: xdp_buff pointing to the data
  *
- * This function builds an skb around an existing Rx buffer, taking care
- * to set up the skb correctly and avoid any memcpy overhead.
+ * This function builds an skb around an existing XDP buffer, taking care
+ * to set up the skb correctly and avoid any memcpy overhead. Driver has
+ * already combined frags (if any) to skb_shared_info.
  */
 static struct sk_buff *
-ice_build_skb(struct ice_rx_ring *rx_ring, struct ice_rx_buf *rx_buf,
-	      struct xdp_buff *xdp)
+ice_build_skb(struct ice_rx_ring *rx_ring, struct xdp_buff *xdp)
 {
 	u8 metasize = xdp->data - xdp->data_meta;
+	struct skb_shared_info *sinfo = NULL;
+	unsigned int nr_frags;
 	struct sk_buff *skb;
 
+	if (unlikely(xdp_buff_has_frags(xdp))) {
+		sinfo = xdp_get_shared_info_from_buff(xdp);
+		nr_frags = sinfo->nr_frags;
+	}
+
 	/* Prefetch first cache line of first page. If xdp->data_meta
 	 * is unused, this points exactly as xdp->data, otherwise we
 	 * likely have a consumer accessing first few bytes of meta
@@ -963,6 +992,12 @@ ice_build_skb(struct ice_rx_ring *rx_ring, struct ice_rx_buf *rx_buf,
 	if (metasize)
 		skb_metadata_set(skb, metasize);
 
+	if (unlikely(xdp_buff_has_frags(xdp)))
+		xdp_update_skb_shared_info(skb, nr_frags,
+					   sinfo->xdp_frags_size,
+					   nr_frags * xdp->frame_sz,
+					   xdp_buff_is_frag_pfmemalloc(xdp));
+
 	return skb;
 }
 
@@ -977,22 +1012,30 @@ ice_build_skb(struct ice_rx_ring *rx_ring, struct ice_rx_buf *rx_buf,
  * skb correctly.
  */
 static struct sk_buff *
-ice_construct_skb(struct ice_rx_ring *rx_ring, struct ice_rx_buf *rx_buf,
-		  struct xdp_buff *xdp)
+ice_construct_skb(struct ice_rx_ring *rx_ring, struct xdp_buff *xdp)
 {
 	unsigned int size = xdp->data_end - xdp->data;
+	struct skb_shared_info *sinfo = NULL;
+	struct ice_rx_buf *rx_buf;
+	unsigned int nr_frags = 0;
 	unsigned int headlen;
 	struct sk_buff *skb;
 
 	/* prefetch first cache line of first page */
 	net_prefetch(xdp->data);
 
+	if (unlikely(xdp_buff_has_frags(xdp))) {
+		sinfo = xdp_get_shared_info_from_buff(xdp);
+		nr_frags = sinfo->nr_frags;
+	}
+
 	/* allocate a skb to store the frags */
 	skb = __napi_alloc_skb(&rx_ring->q_vector->napi, ICE_RX_HDR_SIZE,
 			       GFP_ATOMIC | __GFP_NOWARN);
 	if (unlikely(!skb))
 		return NULL;
 
+	rx_buf = &rx_ring->rx_buf[rx_ring->first_desc];
 	skb_record_rx_queue(skb, rx_ring->q_index);
 	/* Determine available headroom for copy */
 	headlen = size;
@@ -1006,6 +1049,14 @@ ice_construct_skb(struct ice_rx_ring *rx_ring, struct ice_rx_buf *rx_buf,
 	/* if we exhaust the linear part then add what is left as a frag */
 	size -= headlen;
 	if (size) {
+		/* besides adding here a partial frag, we are going to add
+		 * frags from xdp_buff, make sure there is enough space for
+		 * them
+		 */
+		if (unlikely(nr_frags >= MAX_SKB_FRAGS - 1)) {
+			dev_kfree_skb(skb);
+			return NULL;
+		}
 		skb_add_rx_frag(skb, 0, rx_buf->page,
 				rx_buf->page_offset + headlen, size,
 				xdp->frame_sz);
@@ -1015,7 +1066,19 @@ ice_construct_skb(struct ice_rx_ring *rx_ring, struct ice_rx_buf *rx_buf,
 		 * need for adjusting page offset and we can reuse this buffer
 		 * as-is
 		 */
-		rx_buf->act = ICE_XDP_CONSUMED;
+		rx_buf->act = ICE_SKB_CONSUMED;
+	}
+
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
 	}
 
 	return skb;
@@ -1065,17 +1128,16 @@ ice_put_rx_buf(struct ice_rx_ring *rx_ring, struct ice_rx_buf *rx_buf)
 int ice_clean_rx_irq(struct ice_rx_ring *rx_ring, int budget)
 {
 	unsigned int total_rx_bytes = 0, total_rx_pkts = 0;
-	u16 cleaned_count = ICE_DESC_UNUSED(rx_ring);
 	unsigned int offset = rx_ring->rx_offset;
 	struct xdp_buff *xdp = &rx_ring->xdp;
 	struct ice_tx_ring *xdp_ring = NULL;
-	struct sk_buff *skb = rx_ring->skb;
 	struct bpf_prog *xdp_prog = NULL;
 	u32 ntc = rx_ring->next_to_clean;
 	u32 cnt = rx_ring->count;
 	u32 cached_ntc = ntc;
 	u32 xdp_xmit = 0;
 	bool failure;
+	u32 first;
 
 	/* Frame size depend on rx_ring setup when PAGE_SIZE=4K */
 #if (PAGE_SIZE < 8192)
@@ -1090,7 +1152,7 @@ int ice_clean_rx_irq(struct ice_rx_ring *rx_ring, int budget)
 	while (likely(total_rx_pkts < (unsigned int)budget)) {
 		union ice_32b_rx_flex_desc *rx_desc;
 		struct ice_rx_buf *rx_buf;
-		unsigned char *hard_start;
+		struct sk_buff *skb;
 		unsigned int size;
 		u16 stat_err_bits;
 		u16 vlan_tag = 0;
@@ -1123,7 +1185,6 @@ int ice_clean_rx_irq(struct ice_rx_ring *rx_ring, int budget)
 				ice_vc_fdir_irq_handler(ctrl_vsi, rx_desc);
 			if (++ntc == cnt)
 				ntc = 0;
-			cleaned_count++;
 			continue;
 		}
 
@@ -1133,56 +1194,54 @@ int ice_clean_rx_irq(struct ice_rx_ring *rx_ring, int budget)
 		/* retrieve a buffer from the ring */
 		rx_buf = ice_get_rx_buf(rx_ring, size, ntc);
 
-		if (!size) {
-			xdp->data = NULL;
-			xdp->data_end = NULL;
-			xdp->data_hard_start = NULL;
-			xdp->data_meta = NULL;
-			goto construct_skb;
-		}
+		if (!xdp->data) {
+			void *hard_start;
 
-		hard_start = page_address(rx_buf->page) + rx_buf->page_offset -
-			     offset;
-		xdp_prepare_buff(xdp, hard_start, offset, size, !!offset);
+			hard_start = page_address(rx_buf->page) + rx_buf->page_offset -
+				     offset;
+			xdp_prepare_buff(xdp, hard_start, offset, size, !!offset);
 #if (PAGE_SIZE > 4096)
-		/* At larger PAGE_SIZE, frame_sz depend on len size */
-		xdp->frame_sz = ice_rx_frame_truesize(rx_ring, size);
+			/* At larger PAGE_SIZE, frame_sz depend on len size */
+			xdp->frame_sz = ice_rx_frame_truesize(rx_ring, size);
 #endif
+			xdp_buff_clear_frags_flag(xdp);
+		} else if (ice_add_xdp_frag(rx_ring, xdp, rx_buf, size)) {
+			break;
+		}
+		if (++ntc == cnt)
+			ntc = 0;
+
+		/* skip if it is NOP desc */
+		if (ice_is_non_eop(rx_ring, rx_desc))
+			continue;
 
 		ice_run_xdp(rx_ring, xdp, xdp_prog, xdp_ring, rx_buf);
 		if (rx_buf->act == ICE_XDP_PASS)
 			goto construct_skb;
-		total_rx_bytes += size;
+		total_rx_bytes += xdp_get_buff_len(xdp);
 		total_rx_pkts++;
 
-		cleaned_count++;
-		if (++ntc == cnt)
-			ntc = 0;
+		xdp->data = NULL;
+		rx_ring->first_desc = ntc;
 		continue;
 construct_skb:
-		if (skb) {
-			ice_add_rx_frag(rx_ring, xdp, rx_buf, skb, size);
-		} else if (likely(xdp->data)) {
-			if (ice_ring_uses_build_skb(rx_ring))
-				skb = ice_build_skb(rx_ring, rx_buf, xdp);
-			else
-				skb = ice_construct_skb(rx_ring, rx_buf, xdp);
-		}
+		if (likely(ice_ring_uses_build_skb(rx_ring)))
+			skb = ice_build_skb(rx_ring, xdp);
+		else
+			skb = ice_construct_skb(rx_ring, xdp);
 		/* exit if we failed to retrieve a buffer */
 		if (!skb) {
-			rx_ring->ring_stats->rx_stats.alloc_buf_failed++;
-			if (rx_buf)
-				rx_buf->pagecnt_bias++;
+			rx_ring->ring_stats->rx_stats.alloc_page_failed++;
+			rx_buf->act = ICE_XDP_CONSUMED;
+			if (unlikely(xdp_buff_has_frags(xdp)))
+				ice_set_rx_bufs_act(xdp, rx_ring,
+						    ICE_XDP_CONSUMED);
+			xdp->data = NULL;
+			rx_ring->first_desc = ntc;
 			break;
 		}
-
-		if (++ntc == cnt)
-			ntc = 0;
-		cleaned_count++;
-
-		/* skip if it is NOP desc */
-		if (ice_is_non_eop(rx_ring, rx_desc))
-			continue;
+		xdp->data = NULL;
+		rx_ring->first_desc = ntc;
 
 		stat_err_bits = BIT(ICE_RX_FLEX_DESC_STATUS0_RXE_S);
 		if (unlikely(ice_test_staterr(rx_desc->wb.status_error0,
@@ -1194,10 +1253,8 @@ int ice_clean_rx_irq(struct ice_rx_ring *rx_ring, int budget)
 		vlan_tag = ice_get_vlan_tag_from_rx_desc(rx_desc);
 
 		/* pad the skb if needed, to make a valid ethernet frame */
-		if (eth_skb_pad(skb)) {
-			skb = NULL;
+		if (eth_skb_pad(skb))
 			continue;
-		}
 
 		/* probably a little skewed due to removing CRC */
 		total_rx_bytes += skb->len;
@@ -1211,13 +1268,13 @@ int ice_clean_rx_irq(struct ice_rx_ring *rx_ring, int budget)
 		ice_trace(clean_rx_irq_indicate, rx_ring, rx_desc, skb);
 		/* send completed skb up the stack */
 		ice_receive_skb(rx_ring, skb, vlan_tag);
-		skb = NULL;
 
 		/* update budget accounting */
 		total_rx_pkts++;
 	}
 
-	while (cached_ntc != ntc) {
+	first = rx_ring->first_desc;
+	while (cached_ntc != first) {
 		struct ice_rx_buf *buf = &rx_ring->rx_buf[cached_ntc];
 
 		if (buf->act & (ICE_XDP_TX | ICE_XDP_REDIR)) {
@@ -1235,11 +1292,10 @@ int ice_clean_rx_irq(struct ice_rx_ring *rx_ring, int budget)
 	}
 	rx_ring->next_to_clean = ntc;
 	/* return up to cleaned_count buffers to hardware */
-	failure = ice_alloc_rx_bufs(rx_ring, cleaned_count);
+	failure = ice_alloc_rx_bufs(rx_ring, ICE_RX_DESC_UNUSED(rx_ring));
 
 	if (xdp_xmit)
 		ice_finalize_xdp_rx(xdp_ring, xdp_xmit);
-	rx_ring->skb = skb;
 
 	if (rx_ring->ring_stats)
 		ice_update_rx_ring_stats(rx_ring, total_rx_pkts,
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.h b/drivers/net/ethernet/intel/ice/ice_txrx.h
index 9d67d6f1b1f5..26624723352b 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.h
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.h
@@ -112,6 +112,10 @@ static inline int ice_skb_pad(void)
 	(u16)((((R)->next_to_clean > (R)->next_to_use) ? 0 : (R)->count) + \
 	      (R)->next_to_clean - (R)->next_to_use - 1)
 
+#define ICE_RX_DESC_UNUSED(R)	\
+	((((R)->first_desc > (R)->next_to_use) ? 0 : (R)->count) + \
+	      (R)->first_desc - (R)->next_to_use - 1)
+
 #define ICE_RING_QUARTER(R) ((R)->count >> 2)
 
 #define ICE_TX_FLAGS_TSO	BIT(0)
@@ -136,6 +140,7 @@ static inline int ice_skb_pad(void)
 #define ICE_XDP_TX		BIT(1)
 #define ICE_XDP_REDIR		BIT(2)
 #define ICE_XDP_EXIT		BIT(3)
+#define ICE_SKB_CONSUMED	ICE_XDP_CONSUMED
 
 #define ICE_RX_DMA_ATTR \
 	(DMA_ATTR_SKIP_CPU_SYNC | DMA_ATTR_WEAK_ORDERING)
@@ -277,43 +282,44 @@ struct ice_rx_ring {
 	struct ice_vsi *vsi;		/* Backreference to associated VSI */
 	struct ice_q_vector *q_vector;	/* Backreference to associated vector */
 	u8 __iomem *tail;
+	u16 q_index;			/* Queue number of ring */
+
+	u16 count;			/* Number of descriptors */
+	u16 reg_idx;			/* HW register index of the ring */
+	u16 next_to_alloc;
+	/* CL2 - 2nd cacheline starts here */
 	union {
 		struct ice_rx_buf *rx_buf;
 		struct xdp_buff **xdp_buf;
 	};
-	/* CL2 - 2nd cacheline starts here */
-	struct xdp_rxq_info xdp_rxq;
+	struct xdp_buff xdp;
 	/* CL3 - 3rd cacheline starts here */
-	u16 q_index;			/* Queue number of ring */
-
-	u16 count;			/* Number of descriptors */
-	u16 reg_idx;			/* HW register index of the ring */
+	struct bpf_prog *xdp_prog;
+	u16 rx_offset;
 
 	/* used in interrupt processing */
 	u16 next_to_use;
 	u16 next_to_clean;
-	u16 next_to_alloc;
-	u16 rx_offset;
-	u16 rx_buf_len;
+	u16 first_desc;
 
 	/* stats structs */
 	struct ice_ring_stats *ring_stats;
 
 	struct rcu_head rcu;		/* to avoid race on free */
-	/* CL4 - 3rd cacheline starts here */
+	/* CL4 - 4th cacheline starts here */
 	struct ice_channel *ch;
-	struct bpf_prog *xdp_prog;
 	struct ice_tx_ring *xdp_ring;
 	struct xsk_buff_pool *xsk_pool;
-	struct xdp_buff xdp;
-	struct sk_buff *skb;
 	dma_addr_t dma;			/* physical address of ring */
 	u64 cached_phctime;
+	u16 rx_buf_len;
 	u8 dcb_tc;			/* Traffic class of ring */
 	u8 ptp_rx;
 #define ICE_RX_FLAGS_RING_BUILD_SKB	BIT(1)
 #define ICE_RX_FLAGS_CRC_STRIP_DIS	BIT(2)
 	u8 flags;
+	/* CL5 - 5th cacheline starts here */
+	struct xdp_rxq_info xdp_rxq;
 } ____cacheline_internodealigned_in_smp;
 
 struct ice_tx_ring {
@@ -436,7 +442,7 @@ static inline unsigned int ice_rx_pg_order(struct ice_rx_ring *ring)
 
 union ice_32b_rx_flex_desc;
 
-bool ice_alloc_rx_bufs(struct ice_rx_ring *rxr, u16 cleaned_count);
+bool ice_alloc_rx_bufs(struct ice_rx_ring *rxr, unsigned int cleaned_count);
 netdev_tx_t ice_start_xmit(struct sk_buff *skb, struct net_device *netdev);
 u16
 ice_select_queue(struct net_device *dev, struct sk_buff *skb,
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx_lib.h b/drivers/net/ethernet/intel/ice/ice_txrx_lib.h
index 30e3cffdb2f1..1fdc37095767 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_txrx_lib.h
@@ -5,6 +5,36 @@
 #define _ICE_TXRX_LIB_H_
 #include "ice.h"
 
+/**
+ * ice_set_rx_bufs_act - propagate Rx buffer action to frags
+ * @xdp: XDP buffer representing frame (linear and frags part)
+ * @rx_ring: Rx ring struct
+ * act: action to store onto Rx buffers related to XDP buffer parts
+ *
+ * Set action that should be taken before putting Rx buffer from first frag
+ * to one before last. Last one is handled by caller of this function as it
+ * is the EOP frag that is currently being processed. This function is
+ * supposed to be called only when XDP buffer contains frags.
+ */
+static inline void
+ice_set_rx_bufs_act(struct xdp_buff *xdp, const struct ice_rx_ring *rx_ring,
+		    const unsigned int act)
+{
+	const struct skb_shared_info *sinfo = xdp_get_shared_info_from_buff(xdp);
+	u32 first = rx_ring->first_desc;
+	u32 nr_frags = sinfo->nr_frags;
+	u32 cnt = rx_ring->count;
+	struct ice_rx_buf *buf;
+
+	for (int i = 0; i < nr_frags; i++) {
+		buf = &rx_ring->rx_buf[first];
+		buf->act = act;
+
+		if (++first == cnt)
+			first = 0;
+	}
+}
+
 /**
  * ice_test_staterr - tests bits in Rx descriptor status and error fields
  * @status_err_n: Rx descriptor status_error0 or status_error1 bits
-- 
2.34.1

