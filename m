Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07B20692427
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 18:11:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233098AbjBJRLS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 12:11:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233042AbjBJRLI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 12:11:08 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40B9D61D28;
        Fri, 10 Feb 2023 09:11:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676049066; x=1707585066;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wVmpu+m8LWp0apSGuOu9Lc5u49ixcZxtC3ObvxO58sw=;
  b=TBTamATxLCl3X+ttJN6zRNReEI7Cx7vvsmB8P8w1jtwIUaJL6cfLThP7
   ymOZiP4DMOwoQeZVKiQtk+Q5XELs1uljkFhSL8NVMlrANRBHNEOmz1hIi
   lp4NM916z762GR+O+mp9oALZoHx0HLkqh+F6qeUwqlzo5JiLSyH1g+C4t
   E5yF0Eh8jZcBQlMOHyGep0aTAdL+QLAI+xoFO+WXvRkicslLzrVeKRdcy
   QaU6ooSwUagI4JdYT8xhPx1HxdzSAPM1pgMeRt4hO9v5p29R63wU9MVGG
   HUxSlnxMCMOLw3YSDM35WESaqBBa8j6BMFWUr2QZjyYrGQQSfjflrSRNb
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10617"; a="395076732"
X-IronPort-AV: E=Sophos;i="5.97,287,1669104000"; 
   d="scan'208";a="395076732"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2023 09:07:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10617"; a="668107552"
X-IronPort-AV: E=Sophos;i="5.97,287,1669104000"; 
   d="scan'208";a="668107552"
Received: from irvmail002.ir.intel.com ([10.43.11.120])
  by orsmga002.jf.intel.com with ESMTP; 10 Feb 2023 09:07:27 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail002.ir.intel.com (Postfix) with ESMTP id 772383C62A;
        Fri, 10 Feb 2023 17:07:26 +0000 (GMT)
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
Subject: [PATCH bpf-next 5/6] ice: fix freeing XDP frames backed by Page Pool
Date:   Fri, 10 Feb 2023 18:06:17 +0100
Message-Id: <20230210170618.1973430-6-alexandr.lobakin@intel.com>
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

As already mentioned, freeing any &xdp_frame via page_frag_free() is
wrong, as it assumes the frame is backed by either an order-0 page or
a page with no "patrons" behind them, while in fact frames backed by
Page Pool can be redirected to a device, which's driver doesn't use it.
Keep storing a pointer to the raw buffer and then freeing it
unconditionally via page_frag_free() for %XDP_TX frames, but introduce
a separate type in the enum for frames coming through .ndo_xdp_xmit(),
and free them via xdp_return_frame_bulk(). Note that saving xdpf as
xdp_buff->data_hard_start is intentional and is always true when
everything is configured properly.
After this change, %XDP_REDIRECT from a Page Pool based driver to ice
becomes zero-alloc as it should be and horrendous 3.3 Mpps / queue
turn into 6.6, hehe.

Let it go with no "Fixes:" tag as it spans across good 5+ commits and
can't be trivially backported.

Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_txrx.c     |  5 ++-
 drivers/net/ethernet/intel/ice/ice_txrx.h     |  3 ++
 drivers/net/ethernet/intel/ice/ice_txrx_lib.c | 43 +++++++++++++++----
 drivers/net/ethernet/intel/ice/ice_txrx_lib.h |  3 +-
 4 files changed, 43 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index d7e8a3f81e20..e451276a37b6 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -128,6 +128,9 @@ ice_unmap_and_free_tx_buf(struct ice_tx_ring *ring, struct ice_tx_buf *tx_buf)
 	case ICE_TX_BUF_XDP_TX:
 		page_frag_free(tx_buf->raw_buf);
 		break;
+	case ICE_TX_BUF_XDP_XMIT:
+		xdp_return_frame(tx_buf->xdpf);
+		break;
 	}
 
 	tx_buf->next_to_watch = NULL;
@@ -575,7 +578,7 @@ ice_run_xdp(struct ice_rx_ring *rx_ring, struct xdp_buff *xdp,
 	case XDP_TX:
 		if (static_branch_unlikely(&ice_xdp_locking_key))
 			spin_lock(&xdp_ring->tx_lock);
-		ret = __ice_xmit_xdp_ring(xdp, xdp_ring);
+		ret = __ice_xmit_xdp_ring(xdp, xdp_ring, false);
 		if (static_branch_unlikely(&ice_xdp_locking_key))
 			spin_unlock(&xdp_ring->tx_lock);
 		if (ret == ICE_XDP_CONSUMED)
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.h b/drivers/net/ethernet/intel/ice/ice_txrx.h
index 18d8ba0396e8..fff0efe28373 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.h
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.h
@@ -153,6 +153,7 @@ static inline int ice_skb_pad(void)
  * @ICE_TX_BUF_FRAG: mapped skb OR &xdp_buff frag, only unmap DMA
  * @ICE_TX_BUF_SKB: &sk_buff, unmap and consume_skb(), update stats
  * @ICE_TX_BUF_XDP_TX: &xdp_buff, unmap and page_frag_free(), stats
+ * @ICE_TX_BUF_XDP_XMIT: &xdp_frame, unmap and xdp_return_frame(), stats
  * @ICE_TX_BUF_XSK_TX: &xdp_buff on XSk queue, xsk_buff_free(), stats
  */
 enum ice_tx_buf_type {
@@ -161,6 +162,7 @@ enum ice_tx_buf_type {
 	ICE_TX_BUF_FRAG,
 	ICE_TX_BUF_SKB,
 	ICE_TX_BUF_XDP_TX,
+	ICE_TX_BUF_XDP_XMIT,
 	ICE_TX_BUF_XSK_TX,
 };
 
@@ -172,6 +174,7 @@ struct ice_tx_buf {
 	union {
 		void *raw_buf;		/* used for XDP_TX and FDir rules */
 		struct sk_buff *skb;	/* used for .ndo_start_xmit() */
+		struct xdp_frame *xdpf;	/* used for .ndo_xdp_xmit() */
 		struct xdp_buff *xdp;	/* used for XDP_TX ZC */
 	};
 	unsigned int bytecount;
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx_lib.c b/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
index 23ac4824e974..6d98c34d99fc 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
@@ -222,13 +222,15 @@ ice_receive_skb(struct ice_rx_ring *rx_ring, struct sk_buff *skb, u16 vlan_tag)
 
 /**
  * ice_clean_xdp_tx_buf - Free and unmap XDP Tx buffer
- * @xdp_ring: XDP Tx ring
+ * @dev: device for DMA mapping
  * @tx_buf: Tx buffer to clean
+ * @bq: XDP bulk flush struct
  */
 static void
-ice_clean_xdp_tx_buf(struct ice_tx_ring *xdp_ring, struct ice_tx_buf *tx_buf)
+ice_clean_xdp_tx_buf(struct device *dev, struct ice_tx_buf *tx_buf,
+		     struct xdp_frame_bulk *bq)
 {
-	dma_unmap_single(xdp_ring->dev, dma_unmap_addr(tx_buf, dma),
+	dma_unmap_single(dev, dma_unmap_addr(tx_buf, dma),
 			 dma_unmap_len(tx_buf, len), DMA_TO_DEVICE);
 	dma_unmap_len_set(tx_buf, len, 0);
 
@@ -236,6 +238,9 @@ ice_clean_xdp_tx_buf(struct ice_tx_ring *xdp_ring, struct ice_tx_buf *tx_buf)
 	case ICE_TX_BUF_XDP_TX:
 		page_frag_free(tx_buf->raw_buf);
 		break;
+	case ICE_TX_BUF_XDP_XMIT:
+		xdp_return_frame_bulk(tx_buf->xdpf, bq);
+		break;
 	}
 
 	tx_buf->type = ICE_TX_BUF_EMPTY;
@@ -248,9 +253,11 @@ ice_clean_xdp_tx_buf(struct ice_tx_ring *xdp_ring, struct ice_tx_buf *tx_buf)
 static u32 ice_clean_xdp_irq(struct ice_tx_ring *xdp_ring)
 {
 	int total_bytes = 0, total_pkts = 0;
+	struct device *dev = xdp_ring->dev;
 	u32 ntc = xdp_ring->next_to_clean;
 	struct ice_tx_desc *tx_desc;
 	u32 cnt = xdp_ring->count;
+	struct xdp_frame_bulk bq;
 	u32 frags, xdp_tx = 0;
 	u32 ready_frames = 0;
 	u32 idx;
@@ -270,6 +277,9 @@ static u32 ice_clean_xdp_irq(struct ice_tx_ring *xdp_ring)
 		return 0;
 	ret = ready_frames;
 
+	xdp_frame_bulk_init(&bq);
+	rcu_read_lock(); /* xdp_return_frame_bulk() */
+
 	while (ready_frames) {
 		struct ice_tx_buf *tx_buf = &xdp_ring->tx_buf[ntc];
 		struct ice_tx_buf *head = tx_buf;
@@ -289,15 +299,18 @@ static u32 ice_clean_xdp_irq(struct ice_tx_ring *xdp_ring)
 		for (int i = 0; i < frags; i++) {
 			tx_buf = &xdp_ring->tx_buf[ntc];
 
-			ice_clean_xdp_tx_buf(xdp_ring, tx_buf);
+			ice_clean_xdp_tx_buf(dev, tx_buf, &bq);
 			ntc++;
 			if (ntc == cnt)
 				ntc = 0;
 		}
 
-		ice_clean_xdp_tx_buf(xdp_ring, head);
+		ice_clean_xdp_tx_buf(dev, head, &bq);
 	}
 
+	xdp_flush_frame_bulk(&bq);
+	rcu_read_unlock();
+
 	tx_desc->cmd_type_offset_bsz = 0;
 	xdp_ring->next_to_clean = ntc;
 	xdp_ring->xdp_tx_active -= xdp_tx;
@@ -310,8 +323,10 @@ static u32 ice_clean_xdp_irq(struct ice_tx_ring *xdp_ring)
  * __ice_xmit_xdp_ring - submit frame to XDP ring for transmission
  * @xdp: XDP buffer to be placed onto Tx descriptors
  * @xdp_ring: XDP ring for transmission
+ * @frame: whether this comes from .ndo_xdp_xmit()
  */
-int __ice_xmit_xdp_ring(struct xdp_buff *xdp, struct ice_tx_ring *xdp_ring)
+int __ice_xmit_xdp_ring(struct xdp_buff *xdp, struct ice_tx_ring *xdp_ring,
+			bool frame)
 {
 	struct skb_shared_info *sinfo = NULL;
 	u32 size = xdp->data_end - xdp->data;
@@ -355,10 +370,15 @@ int __ice_xmit_xdp_ring(struct xdp_buff *xdp, struct ice_tx_ring *xdp_ring)
 		dma_unmap_len_set(tx_buf, len, size);
 		dma_unmap_addr_set(tx_buf, dma, dma);
 
+		if (frame) {
+			tx_buf->type = ICE_TX_BUF_FRAG;
+		} else {
+			tx_buf->type = ICE_TX_BUF_XDP_TX;
+			tx_buf->raw_buf = data;
+		}
+
 		tx_desc->buf_addr = cpu_to_le64(dma);
 		tx_desc->cmd_type_offset_bsz = ice_build_ctob(0, 0, size, 0);
-		tx_buf->type = ICE_TX_BUF_XDP_TX;
-		tx_buf->raw_buf = data;
 
 		ntu++;
 		if (ntu == cnt)
@@ -379,6 +399,11 @@ int __ice_xmit_xdp_ring(struct xdp_buff *xdp, struct ice_tx_ring *xdp_ring)
 	tx_head->bytecount = xdp_get_buff_len(xdp);
 	tx_head->nr_frags = nr_frags;
 
+	if (frame) {
+		tx_head->type = ICE_TX_BUF_XDP_XMIT;
+		tx_head->xdpf = xdp->data_hard_start;
+	}
+
 	/* update last descriptor from a frame with EOP */
 	tx_desc->cmd_type_offset_bsz |=
 		cpu_to_le64(ICE_TX_DESC_CMD_EOP << ICE_TXD_QW1_CMD_S);
@@ -419,7 +444,7 @@ int ice_xmit_xdp_ring(struct xdp_frame *xdpf, struct ice_tx_ring *xdp_ring)
 	struct xdp_buff xdp;
 
 	xdp_convert_frame_to_buff(xdpf, &xdp);
-	return __ice_xmit_xdp_ring(&xdp, xdp_ring);
+	return __ice_xmit_xdp_ring(&xdp, xdp_ring, true);
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx_lib.h b/drivers/net/ethernet/intel/ice/ice_txrx_lib.h
index ea977f283c22..79efc20c46d9 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_txrx_lib.h
@@ -143,7 +143,8 @@ static inline u32 ice_set_rs_bit(const struct ice_tx_ring *xdp_ring)
 void ice_finalize_xdp_rx(struct ice_tx_ring *xdp_ring, unsigned int xdp_res, u32 first_idx);
 int ice_xmit_xdp_buff(struct xdp_buff *xdp, struct ice_tx_ring *xdp_ring);
 int ice_xmit_xdp_ring(struct xdp_frame *xdpf, struct ice_tx_ring *xdp_ring);
-int __ice_xmit_xdp_ring(struct xdp_buff *xdp, struct ice_tx_ring *xdp_ring);
+int __ice_xmit_xdp_ring(struct xdp_buff *xdp, struct ice_tx_ring *xdp_ring,
+			bool frame);
 void ice_release_rx_desc(struct ice_rx_ring *rx_ring, u16 val);
 void
 ice_process_skb_fields(struct ice_rx_ring *rx_ring,
-- 
2.39.1

