Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78B63692421
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 18:11:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233092AbjBJRLR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 12:11:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233060AbjBJRLI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 12:11:08 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BFF661D2B;
        Fri, 10 Feb 2023 09:11:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676049066; x=1707585066;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Bp5Dr9v35iDX7lQaMuuf1qxg5Bml9dHz10YpuReA7jE=;
  b=eeHjRAd3tdUWjUALGOAnRQBDen/5C2nm8cjpYFgqBpImiY2lYVXitpHx
   yYH904VmCR3Gg+BOaUbxAa2CEF/oO8uSKnfAuii0AOmZ+iEBZXofFO35d
   ACoPOHyCSTCxyldZqSNtUuVb5Ayj+QOeZLZdNdFqebs4iRajjbnrZB9ft
   slwWItjl0Pq49m0JwYzIkPgxVWO+pvDVMCnOVj53fHCWPvYpDE4UzSQ73
   pawaldRyOwMv2it4MKuqohWaCvDLTKR/jyotwYJRdkVyZJF2cWVjBqWMf
   dkFqctHGOigCJJO89OFvQERFyvwEDizLB257QNX5L1Ppd8BRIrkCHE4vu
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10617"; a="395076720"
X-IronPort-AV: E=Sophos;i="5.97,287,1669104000"; 
   d="scan'208";a="395076720"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2023 09:07:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10617"; a="668107550"
X-IronPort-AV: E=Sophos;i="5.97,287,1669104000"; 
   d="scan'208";a="668107550"
Received: from irvmail002.ir.intel.com ([10.43.11.120])
  by orsmga002.jf.intel.com with ESMTP; 10 Feb 2023 09:07:27 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail002.ir.intel.com (Postfix) with ESMTP id 82ACA3C629;
        Fri, 10 Feb 2023 17:07:25 +0000 (GMT)
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next 4/6] ice: robustify cleaning/completing XDP Tx buffers
Date:   Fri, 10 Feb 2023 18:06:16 +0100
Message-Id: <20230210170618.1973430-5-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230210170618.1973430-1-alexandr.lobakin@intel.com>
References: <20230210170618.1973430-1-alexandr.lobakin@intel.com>
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

When queueing frames from a Page Pool for redirecting to a device backed
by the ice driver, `perf top` shows heavy load on page_alloc() and
page_frag_free(), despite that on a properly working system it must be
fully or at least almost zero-alloc. The problem is in fact a bit deeper
and raises from how ice cleans up completed Tx buffers.

The story so far: when cleaning/freeing the resources related to
a particular completed Tx frame (skbs, DMA mappings etc.), ice uses some
heuristics only without setting any type explicitly (except for dummy
Flow Director packets, which are marked via ice_tx_buf::tx_flags).
This kinda works, but only up to some point. For example, currently ice
assumes that each frame coming to __ice_xmit_xdp_ring(), is backed by
either plain order-0 page or plain page frag, while it may also be
backed by Page Pool or any other possible memory models introduced in
future. This means any &xdp_frame must be freed properly via
xdp_return_frame() family with no assumptions.

In order to do that, the whole heuristics must be replaced with setting
the Tx buffer/frame type explicitly, just how it's always been done via
an enum. Let us reuse 16 bits from ::tx_flags -- 1 bit-and instr won't
hurt much -- especially given that sometimes there was a check for
%ICE_TX_FLAGS_DUMMY_PKT, which is now turned from a flag to an enum
member. The rest of the changes is straightforward and most of it is
just a conversion to rely now on the type set in &ice_tx_buf rather than
to some secondary properties.
For now, no functional changes intended, the change only prepares the
ground for starting freeing XDP frames properly next step. And it must
be done atomically/synchronously to not break stuff.

Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_txrx.c     | 38 +++++++++----------
 drivers/net/ethernet/intel/ice/ice_txrx.h     | 34 ++++++++++++-----
 drivers/net/ethernet/intel/ice/ice_txrx_lib.c | 15 ++++++--
 drivers/net/ethernet/intel/ice/ice_xsk.c      | 12 +++---
 4 files changed, 63 insertions(+), 36 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index 6b99adb695e7..d7e8a3f81e20 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -85,7 +85,7 @@ ice_prgm_fdir_fltr(struct ice_vsi *vsi, struct ice_fltr_desc *fdir_desc,
 	td_cmd = ICE_TXD_LAST_DESC_CMD | ICE_TX_DESC_CMD_DUMMY |
 		 ICE_TX_DESC_CMD_RE;
 
-	tx_buf->tx_flags = ICE_TX_FLAGS_DUMMY_PKT;
+	tx_buf->type = ICE_TX_BUF_DUMMY;
 	tx_buf->raw_buf = raw_packet;
 
 	tx_desc->cmd_type_offset_bsz =
@@ -112,28 +112,26 @@ ice_prgm_fdir_fltr(struct ice_vsi *vsi, struct ice_fltr_desc *fdir_desc,
 static void
 ice_unmap_and_free_tx_buf(struct ice_tx_ring *ring, struct ice_tx_buf *tx_buf)
 {
-	if (tx_buf->skb) {
-		if (tx_buf->tx_flags & ICE_TX_FLAGS_DUMMY_PKT) {
-			devm_kfree(ring->dev, tx_buf->raw_buf);
-		} else if (ice_ring_is_xdp(ring)) {
-			page_frag_free(tx_buf->raw_buf);
-		} else {
-			dev_kfree_skb_any(tx_buf->skb);
-		}
-		if (dma_unmap_len(tx_buf, len))
-			dma_unmap_single(ring->dev,
-					 dma_unmap_addr(tx_buf, dma),
-					 dma_unmap_len(tx_buf, len),
-					 DMA_TO_DEVICE);
-	} else if (dma_unmap_len(tx_buf, len)) {
+	if (dma_unmap_len(tx_buf, len))
 		dma_unmap_page(ring->dev,
 			       dma_unmap_addr(tx_buf, dma),
 			       dma_unmap_len(tx_buf, len),
 			       DMA_TO_DEVICE);
+
+	switch (tx_buf->type) {
+	case ICE_TX_BUF_DUMMY:
+		devm_kfree(ring->dev, tx_buf->raw_buf);
+		break;
+	case ICE_TX_BUF_SKB:
+		dev_kfree_skb_any(tx_buf->skb);
+		break;
+	case ICE_TX_BUF_XDP_TX:
+		page_frag_free(tx_buf->raw_buf);
+		break;
 	}
 
 	tx_buf->next_to_watch = NULL;
-	tx_buf->skb = NULL;
+	tx_buf->type = ICE_TX_BUF_EMPTY;
 	dma_unmap_len_set(tx_buf, len, 0);
 	/* tx_buf must be completely set up in the transmit path */
 }
@@ -266,7 +264,7 @@ static bool ice_clean_tx_irq(struct ice_tx_ring *tx_ring, int napi_budget)
 				 DMA_TO_DEVICE);
 
 		/* clear tx_buf data */
-		tx_buf->skb = NULL;
+		tx_buf->type = ICE_TX_BUF_EMPTY;
 		dma_unmap_len_set(tx_buf, len, 0);
 
 		/* unmap remaining buffers */
@@ -1709,6 +1707,7 @@ ice_tx_map(struct ice_tx_ring *tx_ring, struct ice_tx_buf *first,
 				       DMA_TO_DEVICE);
 
 		tx_buf = &tx_ring->tx_buf[i];
+		tx_buf->type = ICE_TX_BUF_FRAG;
 	}
 
 	/* record SW timestamp if HW timestamp is not available */
@@ -2352,6 +2351,7 @@ ice_xmit_frame_ring(struct sk_buff *skb, struct ice_tx_ring *tx_ring)
 	/* record the location of the first descriptor for this packet */
 	first = &tx_ring->tx_buf[tx_ring->next_to_use];
 	first->skb = skb;
+	first->type = ICE_TX_BUF_SKB;
 	first->bytecount = max_t(unsigned int, skb->len, ETH_ZLEN);
 	first->gso_segs = 1;
 	first->tx_flags = 0;
@@ -2524,11 +2524,11 @@ void ice_clean_ctrl_tx_irq(struct ice_tx_ring *tx_ring)
 					 dma_unmap_addr(tx_buf, dma),
 					 dma_unmap_len(tx_buf, len),
 					 DMA_TO_DEVICE);
-		if (tx_buf->tx_flags & ICE_TX_FLAGS_DUMMY_PKT)
+		if (tx_buf->type == ICE_TX_BUF_DUMMY)
 			devm_kfree(tx_ring->dev, tx_buf->raw_buf);
 
 		/* clear next_to_watch to prevent false hangs */
-		tx_buf->raw_buf = NULL;
+		tx_buf->type = ICE_TX_BUF_EMPTY;
 		tx_buf->tx_flags = 0;
 		tx_buf->next_to_watch = NULL;
 		dma_unmap_len_set(tx_buf, len, 0);
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.h b/drivers/net/ethernet/intel/ice/ice_txrx.h
index efa3d378f19e..18d8ba0396e8 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.h
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.h
@@ -121,10 +121,7 @@ static inline int ice_skb_pad(void)
 #define ICE_TX_FLAGS_TSO	BIT(0)
 #define ICE_TX_FLAGS_HW_VLAN	BIT(1)
 #define ICE_TX_FLAGS_SW_VLAN	BIT(2)
-/* ICE_TX_FLAGS_DUMMY_PKT is used to mark dummy packets that should be
- * freed instead of returned like skb packets.
- */
-#define ICE_TX_FLAGS_DUMMY_PKT	BIT(3)
+/* Free, was ICE_TX_FLAGS_DUMMY_PKT */
 #define ICE_TX_FLAGS_TSYN	BIT(4)
 #define ICE_TX_FLAGS_IPV4	BIT(5)
 #define ICE_TX_FLAGS_IPV6	BIT(6)
@@ -149,22 +146,41 @@ static inline int ice_skb_pad(void)
 
 #define ICE_TXD_LAST_DESC_CMD (ICE_TX_DESC_CMD_EOP | ICE_TX_DESC_CMD_RS)
 
+/**
+ * enum ice_tx_buf_type - type of &ice_tx_buf to act on Tx completion
+ * @ICE_TX_BUF_EMPTY: unused OR XSk frame, no action required
+ * @ICE_TX_BUF_DUMMY: dummy Flow Director packet, unmap and kfree()
+ * @ICE_TX_BUF_FRAG: mapped skb OR &xdp_buff frag, only unmap DMA
+ * @ICE_TX_BUF_SKB: &sk_buff, unmap and consume_skb(), update stats
+ * @ICE_TX_BUF_XDP_TX: &xdp_buff, unmap and page_frag_free(), stats
+ * @ICE_TX_BUF_XSK_TX: &xdp_buff on XSk queue, xsk_buff_free(), stats
+ */
+enum ice_tx_buf_type {
+	ICE_TX_BUF_EMPTY	= 0U,
+	ICE_TX_BUF_DUMMY,
+	ICE_TX_BUF_FRAG,
+	ICE_TX_BUF_SKB,
+	ICE_TX_BUF_XDP_TX,
+	ICE_TX_BUF_XSK_TX,
+};
+
 struct ice_tx_buf {
 	union {
 		struct ice_tx_desc *next_to_watch;
 		u32 rs_idx;
 	};
 	union {
-		struct sk_buff *skb;
-		void *raw_buf; /* used for XDP */
-		struct xdp_buff *xdp; /* used for XDP_TX ZC */
+		void *raw_buf;		/* used for XDP_TX and FDir rules */
+		struct sk_buff *skb;	/* used for .ndo_start_xmit() */
+		struct xdp_buff *xdp;	/* used for XDP_TX ZC */
 	};
 	unsigned int bytecount;
 	union {
 		unsigned int gso_segs;
-		unsigned int nr_frags; /* used for mbuf XDP */
+		unsigned int nr_frags;	/* used for mbuf XDP */
 	};
-	u32 tx_flags;
+	u32 type:16;			/* &ice_tx_buf_type */
+	u32 tx_flags:16;
 	DEFINE_DMA_UNMAP_LEN(len);
 	DEFINE_DMA_UNMAP_ADDR(dma);
 };
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx_lib.c b/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
index 6371acb0deb0..23ac4824e974 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
@@ -231,8 +231,14 @@ ice_clean_xdp_tx_buf(struct ice_tx_ring *xdp_ring, struct ice_tx_buf *tx_buf)
 	dma_unmap_single(xdp_ring->dev, dma_unmap_addr(tx_buf, dma),
 			 dma_unmap_len(tx_buf, len), DMA_TO_DEVICE);
 	dma_unmap_len_set(tx_buf, len, 0);
-	page_frag_free(tx_buf->raw_buf);
-	tx_buf->raw_buf = NULL;
+
+	switch (tx_buf->type) {
+	case ICE_TX_BUF_XDP_TX:
+		page_frag_free(tx_buf->raw_buf);
+		break;
+	}
+
+	tx_buf->type = ICE_TX_BUF_EMPTY;
 }
 
 /**
@@ -266,6 +272,7 @@ static u32 ice_clean_xdp_irq(struct ice_tx_ring *xdp_ring)
 
 	while (ready_frames) {
 		struct ice_tx_buf *tx_buf = &xdp_ring->tx_buf[ntc];
+		struct ice_tx_buf *head = tx_buf;
 
 		/* bytecount holds size of head + frags */
 		total_bytes += tx_buf->bytecount;
@@ -275,7 +282,6 @@ static u32 ice_clean_xdp_irq(struct ice_tx_ring *xdp_ring)
 		ready_frames -= frags + 1;
 		xdp_tx++;
 
-		ice_clean_xdp_tx_buf(xdp_ring, tx_buf);
 		ntc++;
 		if (ntc == cnt)
 			ntc = 0;
@@ -288,6 +294,8 @@ static u32 ice_clean_xdp_irq(struct ice_tx_ring *xdp_ring)
 			if (ntc == cnt)
 				ntc = 0;
 		}
+
+		ice_clean_xdp_tx_buf(xdp_ring, head);
 	}
 
 	tx_desc->cmd_type_offset_bsz = 0;
@@ -349,6 +357,7 @@ int __ice_xmit_xdp_ring(struct xdp_buff *xdp, struct ice_tx_ring *xdp_ring)
 
 		tx_desc->buf_addr = cpu_to_le64(dma);
 		tx_desc->cmd_type_offset_bsz = ice_build_ctob(0, 0, size, 0);
+		tx_buf->type = ICE_TX_BUF_XDP_TX;
 		tx_buf->raw_buf = data;
 
 		ntu++;
diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
index a25a68c69f22..917c75e530ca 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -631,7 +631,8 @@ static void ice_clean_xdp_irq_zc(struct ice_tx_ring *xdp_ring)
 	for (i = 0; i < xsk_frames; i++) {
 		tx_buf = &xdp_ring->tx_buf[ntc];
 
-		if (tx_buf->xdp) {
+		if (tx_buf->type == ICE_TX_BUF_XSK_TX) {
+			tx_buf->type = ICE_TX_BUF_EMPTY;
 			xsk_buff_free(tx_buf->xdp);
 			xdp_ring->xdp_tx_active--;
 		} else {
@@ -685,6 +686,7 @@ static int ice_xmit_xdp_tx_zc(struct xdp_buff *xdp,
 
 	tx_buf = &xdp_ring->tx_buf[ntu];
 	tx_buf->xdp = xdp;
+	tx_buf->type = ICE_TX_BUF_XSK_TX;
 	tx_desc = ICE_TX_DESC(xdp_ring, ntu);
 	tx_desc->buf_addr = cpu_to_le64(dma);
 	tx_desc->cmd_type_offset_bsz = ice_build_ctob(ICE_TX_DESC_CMD_EOP,
@@ -1083,12 +1085,12 @@ void ice_xsk_clean_xdp_ring(struct ice_tx_ring *xdp_ring)
 	while (ntc != ntu) {
 		struct ice_tx_buf *tx_buf = &xdp_ring->tx_buf[ntc];
 
-		if (tx_buf->xdp)
+		if (tx_buf->type == ICE_TX_BUF_XSK_TX) {
+			tx_buf->type = ICE_TX_BUF_EMPTY;
 			xsk_buff_free(tx_buf->xdp);
-		else
+		} else {
 			xsk_frames++;
-
-		tx_buf->raw_buf = NULL;
+		}
 
 		ntc++;
 		if (ntc >= xdp_ring->count)
-- 
2.39.1

