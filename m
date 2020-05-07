Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 951FB1C8720
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 12:43:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727113AbgEGKny (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 06:43:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725900AbgEGKnx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 06:43:53 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09D2FC061A10;
        Thu,  7 May 2020 03:43:53 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id f15so1917919plr.3;
        Thu, 07 May 2020 03:43:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dnwdATUPH0GR0aINqPlYa8zdeBiowzEQLj2lJ3F+tA4=;
        b=IFpcErntmEHGejayUoVuDvMFnSAkgj0aRr8R6UGR4gEqoF9H7fugPWuX3Sin25cWwM
         nkvXVonL1nOdYuWge3oN0rkTKhOSYV6ICelo4vMmR0rJFHCzj+osF+SYUGHt0BXuSG94
         PJAlyWGWtovjapeoBkUiGn6Aa73oTGgMyVtf/OjL7+E3OYG8TJ3RIcjfrNeCShDJqSed
         KwgcQW1RJAo1gXA7oOy+rcbKKmjkGTFBOgYQbGMec16FTzQLQUoPxS+G5jitvnsQj9Ps
         f0pbOHFg9RYgT0FvjUjVHtDY21nCHTXjwjk/QmkJGpe02L+Egc9uYrYVi1V0De58H8jH
         XxDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dnwdATUPH0GR0aINqPlYa8zdeBiowzEQLj2lJ3F+tA4=;
        b=luGvlHJoBWhg5dBET4Y61KTPy7VdMnqnzaA7n4IOY4IFleovaI4DBJwsEXsc8eGVsG
         ooBNpmmbEzyJnE+s5s5YYIiRwr+p+xqHfwRPb/wo0PlRt6LM/ip68DZG8ULgE9EUYWBZ
         B3lGylcJvuOGudJLobiY2M04bz4tXW9HRivQPItiO3PKp1A23X5L3TlykogLyZwkcZJ7
         Y311zFUiTwBfzn23F8bxC94k9c2mB72MfbvUsff0gM/7oWO4bHfNUmO6XOBbJDhulGGb
         TM/ecrEePyJlo+lZvdVLAncorbvO+xsfBriZGtarYUJZmvFB0Ny1GEEcbw5mdMYNQBui
         pSAA==
X-Gm-Message-State: AGi0PuZoDSCqyYML2pdVurp9Y01IujNY3p+Yqb+fS0LHYD1Wb8JNvGkO
        yc5HgFnq1KM60ahUm0op1sc=
X-Google-Smtp-Source: APiQypIKlJB0ZEQcZJ7mZosZmlpkTNiyUhbS7Tt+vLtEX1XBSR4dx+czEHEfxWAeS0LN3Lc/XsDCkQ==
X-Received: by 2002:a17:902:103:: with SMTP id 3mr870855plb.325.1588848232158;
        Thu, 07 May 2020 03:43:52 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com ([192.55.55.43])
        by smtp.gmail.com with ESMTPSA id j14sm7450673pjm.27.2020.05.07.03.43.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2020 03:43:51 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        kuba@kernel.org, hawk@kernel.org, john.fastabend@gmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com,
        jeffrey.t.kirsher@intel.com
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        maximmi@mellanox.com, maciej.fijalkowski@intel.com,
        intel-wired-lan@lists.osuosl.org
Subject: [PATCH bpf-next 08/14] ice, xsk: migrate to new MEM_TYPE_XSK_BUFF_POOL
Date:   Thu,  7 May 2020 12:42:46 +0200
Message-Id: <20200507104252.544114-9-bjorn.topel@gmail.com>
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

Remove MEM_TYPE_ZERO_COPY in favor of the new MEM_TYPE_XSK_BUFF_POOL
APIs.

Cc: intel-wired-lan@lists.osuosl.org
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_base.c |  16 +-
 drivers/net/ethernet/intel/ice/ice_txrx.h |   8 +-
 drivers/net/ethernet/intel/ice/ice_xsk.c  | 372 +++-------------------
 drivers/net/ethernet/intel/ice/ice_xsk.h  |  13 +-
 4 files changed, 54 insertions(+), 355 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_base.c b/drivers/net/ethernet/intel/ice/ice_base.c
index a19cd6f5436b..433eb72b1c85 100644
--- a/drivers/net/ethernet/intel/ice/ice_base.c
+++ b/drivers/net/ethernet/intel/ice/ice_base.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright (c) 2019, Intel Corporation. */
 
+#include <net/xdp_sock_drv.h>
 #include "ice_base.h"
 #include "ice_dcb_lib.h"
 
@@ -308,24 +309,23 @@ int ice_setup_rx_ctx(struct ice_ring *ring)
 		if (ring->xsk_umem) {
 			xdp_rxq_info_unreg_mem_model(&ring->xdp_rxq);
 
-			ring->rx_buf_len = ring->xsk_umem->chunk_size_nohr -
-					   XDP_PACKET_HEADROOM;
+			ring->rx_buf_len =
+				xsk_umem_get_rx_frame_size(ring->xsk_umem);
 			/* For AF_XDP ZC, we disallow packets to span on
 			 * multiple buffers, thus letting us skip that
 			 * handling in the fast-path.
 			 */
 			chain_len = 1;
-			ring->zca.free = ice_zca_free;
 			err = xdp_rxq_info_reg_mem_model(&ring->xdp_rxq,
-							 MEM_TYPE_ZERO_COPY,
-							 &ring->zca);
+							 MEM_TYPE_XSK_BUFF_POOL,
+							 NULL);
 			if (err)
 				return err;
+			xsk_buff_set_rxq_info(ring->xsk_umem, &ring->xdp_rxq);
 
-			dev_info(ice_pf_to_dev(vsi->back), "Registered XDP mem model MEM_TYPE_ZERO_COPY on Rx ring %d\n",
+			dev_info(ice_pf_to_dev(vsi->back), "Registered XDP mem model MEM_TYPE_XSK_BUFF_POOL on Rx ring %d\n",
 				 ring->q_index);
 		} else {
-			ring->zca.free = NULL;
 			if (!xdp_rxq_info_is_reg(&ring->xdp_rxq))
 				/* coverity[check_return] */
 				xdp_rxq_info_reg(&ring->xdp_rxq,
@@ -426,7 +426,7 @@ int ice_setup_rx_ctx(struct ice_ring *ring)
 	writel(0, ring->tail);
 
 	err = ring->xsk_umem ?
-	      ice_alloc_rx_bufs_slow_zc(ring, ICE_DESC_UNUSED(ring)) :
+	      ice_alloc_rx_bufs_zc(ring, ICE_DESC_UNUSED(ring)) :
 	      ice_alloc_rx_bufs(ring, ICE_DESC_UNUSED(ring));
 	if (err)
 		dev_info(ice_pf_to_dev(vsi->back), "Failed allocate some buffers on %sRx ring %d (pf_q %d)\n",
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.h b/drivers/net/ethernet/intel/ice/ice_txrx.h
index 7ee00a128663..d0fd2173854f 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.h
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.h
@@ -155,17 +155,16 @@ struct ice_tx_offload_params {
 };
 
 struct ice_rx_buf {
-	struct sk_buff *skb;
-	dma_addr_t dma;
 	union {
 		struct {
+			struct sk_buff *skb;
+			dma_addr_t dma;
 			struct page *page;
 			unsigned int page_offset;
 			u16 pagecnt_bias;
 		};
 		struct {
-			void *addr;
-			u64 handle;
+			struct xdp_buff *xdp;
 		};
 	};
 };
@@ -289,7 +288,6 @@ struct ice_ring {
 	struct rcu_head rcu;		/* to avoid race on free */
 	struct bpf_prog *xdp_prog;
 	struct xdp_umem *xsk_umem;
-	struct zero_copy_allocator zca;
 	/* CL3 - 3rd cacheline starts here */
 	struct xdp_rxq_info xdp_rxq;
 	/* CLX - the below items are only accessed infrequently and should be
diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
index 955b0fbb7c9a..da89589c3137 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -279,28 +279,6 @@ static int ice_xsk_alloc_umems(struct ice_vsi *vsi)
 	return 0;
 }
 
-/**
- * ice_xsk_add_umem - add a UMEM region for XDP sockets
- * @vsi: VSI to which the UMEM will be added
- * @umem: pointer to a requested UMEM region
- * @qid: queue ID
- *
- * Returns 0 on success, negative on error
- */
-static int ice_xsk_add_umem(struct ice_vsi *vsi, struct xdp_umem *umem, u16 qid)
-{
-	int err;
-
-	err = ice_xsk_alloc_umems(vsi);
-	if (err)
-		return err;
-
-	vsi->xsk_umems[qid] = umem;
-	vsi->num_xsk_umems_used++;
-
-	return 0;
-}
-
 /**
  * ice_xsk_remove_umem - Remove an UMEM for a certain ring/qid
  * @vsi: VSI from which the VSI will be removed
@@ -318,65 +296,6 @@ static void ice_xsk_remove_umem(struct ice_vsi *vsi, u16 qid)
 	}
 }
 
-/**
- * ice_xsk_umem_dma_map - DMA map UMEM region for XDP sockets
- * @vsi: VSI to map the UMEM region
- * @umem: UMEM to map
- *
- * Returns 0 on success, negative on error
- */
-static int ice_xsk_umem_dma_map(struct ice_vsi *vsi, struct xdp_umem *umem)
-{
-	struct ice_pf *pf = vsi->back;
-	struct device *dev;
-	unsigned int i;
-
-	dev = ice_pf_to_dev(pf);
-	for (i = 0; i < umem->npgs; i++) {
-		dma_addr_t dma = dma_map_page_attrs(dev, umem->pgs[i], 0,
-						    PAGE_SIZE,
-						    DMA_BIDIRECTIONAL,
-						    ICE_RX_DMA_ATTR);
-		if (dma_mapping_error(dev, dma)) {
-			dev_dbg(dev, "XSK UMEM DMA mapping error on page num %d\n",
-				i);
-			goto out_unmap;
-		}
-
-		umem->pages[i].dma = dma;
-	}
-
-	return 0;
-
-out_unmap:
-	for (; i > 0; i--) {
-		dma_unmap_page_attrs(dev, umem->pages[i].dma, PAGE_SIZE,
-				     DMA_BIDIRECTIONAL, ICE_RX_DMA_ATTR);
-		umem->pages[i].dma = 0;
-	}
-
-	return -EFAULT;
-}
-
-/**
- * ice_xsk_umem_dma_unmap - DMA unmap UMEM region for XDP sockets
- * @vsi: VSI from which the UMEM will be unmapped
- * @umem: UMEM to unmap
- */
-static void ice_xsk_umem_dma_unmap(struct ice_vsi *vsi, struct xdp_umem *umem)
-{
-	struct ice_pf *pf = vsi->back;
-	struct device *dev;
-	unsigned int i;
-
-	dev = ice_pf_to_dev(pf);
-	for (i = 0; i < umem->npgs; i++) {
-		dma_unmap_page_attrs(dev, umem->pages[i].dma, PAGE_SIZE,
-				     DMA_BIDIRECTIONAL, ICE_RX_DMA_ATTR);
-
-		umem->pages[i].dma = 0;
-	}
-}
 
 /**
  * ice_xsk_umem_disable - disable a UMEM region
@@ -391,7 +310,7 @@ static int ice_xsk_umem_disable(struct ice_vsi *vsi, u16 qid)
 	    !vsi->xsk_umems[qid])
 		return -EINVAL;
 
-	ice_xsk_umem_dma_unmap(vsi, vsi->xsk_umems[qid]);
+	xsk_buff_dma_unmap(vsi->xsk_umems[qid], ICE_RX_DMA_ATTR);
 	ice_xsk_remove_umem(vsi, qid);
 
 	return 0;
@@ -408,7 +327,6 @@ static int ice_xsk_umem_disable(struct ice_vsi *vsi, u16 qid)
 static int
 ice_xsk_umem_enable(struct ice_vsi *vsi, struct xdp_umem *umem, u16 qid)
 {
-	struct xdp_umem_fq_reuse *reuseq;
 	int err;
 
 	if (vsi->type != ICE_VSI_PF)
@@ -419,20 +337,18 @@ ice_xsk_umem_enable(struct ice_vsi *vsi, struct xdp_umem *umem, u16 qid)
 	if (qid >= vsi->num_xsk_umems)
 		return -EINVAL;
 
+	err = ice_xsk_alloc_umems(vsi);
+	if (err)
+		return err;
+
 	if (vsi->xsk_umems && vsi->xsk_umems[qid])
 		return -EBUSY;
 
-	reuseq = xsk_reuseq_prepare(vsi->rx_rings[0]->count);
-	if (!reuseq)
-		return -ENOMEM;
-
-	xsk_reuseq_free(xsk_reuseq_swap(umem, reuseq));
-
-	err = ice_xsk_umem_dma_map(vsi, umem);
-	if (err)
-		return err;
+	vsi->xsk_umems[qid] = umem;
+	vsi->num_xsk_umems_used++;
 
-	err = ice_xsk_add_umem(vsi, umem, qid);
+	err = xsk_buff_dma_map(vsi->xsk_umems[qid], ice_pf_to_dev(vsi->back),
+			       ICE_RX_DMA_ATTR);
 	if (err)
 		return err;
 
@@ -483,119 +399,6 @@ int ice_xsk_umem_setup(struct ice_vsi *vsi, struct xdp_umem *umem, u16 qid)
 	return ret;
 }
 
-/**
- * ice_zca_free - Callback for MEM_TYPE_ZERO_COPY allocations
- * @zca: zero-cpoy allocator
- * @handle: Buffer handle
- */
-void ice_zca_free(struct zero_copy_allocator *zca, unsigned long handle)
-{
-	struct ice_rx_buf *rx_buf;
-	struct ice_ring *rx_ring;
-	struct xdp_umem *umem;
-	u64 hr, mask;
-	u16 nta;
-
-	rx_ring = container_of(zca, struct ice_ring, zca);
-	umem = rx_ring->xsk_umem;
-	hr = umem->headroom + XDP_PACKET_HEADROOM;
-
-	mask = umem->chunk_mask;
-
-	nta = rx_ring->next_to_alloc;
-	rx_buf = &rx_ring->rx_buf[nta];
-
-	nta++;
-	rx_ring->next_to_alloc = (nta < rx_ring->count) ? nta : 0;
-
-	handle &= mask;
-
-	rx_buf->dma = xdp_umem_get_dma(umem, handle);
-	rx_buf->dma += hr;
-
-	rx_buf->addr = xdp_umem_get_data(umem, handle);
-	rx_buf->addr += hr;
-
-	rx_buf->handle = (u64)handle + umem->headroom;
-}
-
-/**
- * ice_alloc_buf_fast_zc - Retrieve buffer address from XDP umem
- * @rx_ring: ring with an xdp_umem bound to it
- * @rx_buf: buffer to which xsk page address will be assigned
- *
- * This function allocates an Rx buffer in the hot path.
- * The buffer can come from fill queue or recycle queue.
- *
- * Returns true if an assignment was successful, false if not.
- */
-static __always_inline bool
-ice_alloc_buf_fast_zc(struct ice_ring *rx_ring, struct ice_rx_buf *rx_buf)
-{
-	struct xdp_umem *umem = rx_ring->xsk_umem;
-	void *addr = rx_buf->addr;
-	u64 handle, hr;
-
-	if (addr) {
-		rx_ring->rx_stats.page_reuse_count++;
-		return true;
-	}
-
-	if (!xsk_umem_peek_addr(umem, &handle)) {
-		rx_ring->rx_stats.alloc_page_failed++;
-		return false;
-	}
-
-	hr = umem->headroom + XDP_PACKET_HEADROOM;
-
-	rx_buf->dma = xdp_umem_get_dma(umem, handle);
-	rx_buf->dma += hr;
-
-	rx_buf->addr = xdp_umem_get_data(umem, handle);
-	rx_buf->addr += hr;
-
-	rx_buf->handle = handle + umem->headroom;
-
-	xsk_umem_release_addr(umem);
-	return true;
-}
-
-/**
- * ice_alloc_buf_slow_zc - Retrieve buffer address from XDP umem
- * @rx_ring: ring with an xdp_umem bound to it
- * @rx_buf: buffer to which xsk page address will be assigned
- *
- * This function allocates an Rx buffer in the slow path.
- * The buffer can come from fill queue or recycle queue.
- *
- * Returns true if an assignment was successful, false if not.
- */
-static __always_inline bool
-ice_alloc_buf_slow_zc(struct ice_ring *rx_ring, struct ice_rx_buf *rx_buf)
-{
-	struct xdp_umem *umem = rx_ring->xsk_umem;
-	u64 handle, headroom;
-
-	if (!xsk_umem_peek_addr_rq(umem, &handle)) {
-		rx_ring->rx_stats.alloc_page_failed++;
-		return false;
-	}
-
-	handle &= umem->chunk_mask;
-	headroom = umem->headroom + XDP_PACKET_HEADROOM;
-
-	rx_buf->dma = xdp_umem_get_dma(umem, handle);
-	rx_buf->dma += headroom;
-
-	rx_buf->addr = xdp_umem_get_data(umem, handle);
-	rx_buf->addr += headroom;
-
-	rx_buf->handle = handle + umem->headroom;
-
-	xsk_umem_release_addr_rq(umem);
-	return true;
-}
-
 /**
  * ice_alloc_rx_bufs_zc - allocate a number of Rx buffers
  * @rx_ring: Rx ring
@@ -607,14 +410,13 @@ ice_alloc_buf_slow_zc(struct ice_ring *rx_ring, struct ice_rx_buf *rx_buf)
  *
  * Returns false if all allocations were successful, true if any fail.
  */
-static bool
-ice_alloc_rx_bufs_zc(struct ice_ring *rx_ring, int count,
-		     bool (*alloc)(struct ice_ring *, struct ice_rx_buf *))
+bool ice_alloc_rx_bufs_zc(struct ice_ring *rx_ring, u16 count)
 {
 	union ice_32b_rx_flex_desc *rx_desc;
 	u16 ntu = rx_ring->next_to_use;
 	struct ice_rx_buf *rx_buf;
 	bool ret = false;
+	dma_addr_t dma;
 
 	if (!count)
 		return false;
@@ -623,16 +425,14 @@ ice_alloc_rx_bufs_zc(struct ice_ring *rx_ring, int count,
 	rx_buf = &rx_ring->rx_buf[ntu];
 
 	do {
-		if (!alloc(rx_ring, rx_buf)) {
+		rx_buf->xdp = xsk_buff_alloc(rx_ring->xsk_umem);
+		if (!rx_buf->xdp) {
 			ret = true;
 			break;
 		}
 
-		dma_sync_single_range_for_device(rx_ring->dev, rx_buf->dma, 0,
-						 rx_ring->rx_buf_len,
-						 DMA_BIDIRECTIONAL);
-
-		rx_desc->read.pkt_addr = cpu_to_le64(rx_buf->dma);
+		dma = xsk_buff_xdp_get_dma(rx_buf->xdp);
+		rx_desc->read.pkt_addr = cpu_to_le64(dma);
 		rx_desc->wb.status_error0 = 0;
 
 		rx_desc++;
@@ -652,32 +452,6 @@ ice_alloc_rx_bufs_zc(struct ice_ring *rx_ring, int count,
 	return ret;
 }
 
-/**
- * ice_alloc_rx_bufs_fast_zc - allocate zero copy bufs in the hot path
- * @rx_ring: Rx ring
- * @count: number of bufs to allocate
- *
- * Returns false on success, true on failure.
- */
-static bool ice_alloc_rx_bufs_fast_zc(struct ice_ring *rx_ring, u16 count)
-{
-	return ice_alloc_rx_bufs_zc(rx_ring, count,
-				    ice_alloc_buf_fast_zc);
-}
-
-/**
- * ice_alloc_rx_bufs_slow_zc - allocate zero copy bufs in the slow path
- * @rx_ring: Rx ring
- * @count: number of bufs to allocate
- *
- * Returns false on success, true on failure.
- */
-bool ice_alloc_rx_bufs_slow_zc(struct ice_ring *rx_ring, u16 count)
-{
-	return ice_alloc_rx_bufs_zc(rx_ring, count,
-				    ice_alloc_buf_slow_zc);
-}
-
 /**
  * ice_bump_ntc - Bump the next_to_clean counter of an Rx ring
  * @rx_ring: Rx ring
@@ -691,59 +465,6 @@ static void ice_bump_ntc(struct ice_ring *rx_ring)
 	prefetch(ICE_RX_DESC(rx_ring, ntc));
 }
 
-/**
- * ice_get_rx_buf_zc - Fetch the current Rx buffer
- * @rx_ring: Rx ring
- * @size: size of a buffer
- *
- * This function returns the current, received Rx buffer and does
- * DMA synchronization.
- *
- * Returns a pointer to the received Rx buffer.
- */
-static struct ice_rx_buf *ice_get_rx_buf_zc(struct ice_ring *rx_ring, int size)
-{
-	struct ice_rx_buf *rx_buf;
-
-	rx_buf = &rx_ring->rx_buf[rx_ring->next_to_clean];
-
-	dma_sync_single_range_for_cpu(rx_ring->dev, rx_buf->dma, 0,
-				      size, DMA_BIDIRECTIONAL);
-
-	return rx_buf;
-}
-
-/**
- * ice_reuse_rx_buf_zc - reuse an Rx buffer
- * @rx_ring: Rx ring
- * @old_buf: The buffer to recycle
- *
- * This function recycles a finished Rx buffer, and places it on the recycle
- * queue (next_to_alloc).
- */
-static void
-ice_reuse_rx_buf_zc(struct ice_ring *rx_ring, struct ice_rx_buf *old_buf)
-{
-	unsigned long mask = (unsigned long)rx_ring->xsk_umem->chunk_mask;
-	u64 hr = rx_ring->xsk_umem->headroom + XDP_PACKET_HEADROOM;
-	u16 nta = rx_ring->next_to_alloc;
-	struct ice_rx_buf *new_buf;
-
-	new_buf = &rx_ring->rx_buf[nta++];
-	rx_ring->next_to_alloc = (nta < rx_ring->count) ? nta : 0;
-
-	new_buf->dma = old_buf->dma & mask;
-	new_buf->dma += hr;
-
-	new_buf->addr = (void *)((unsigned long)old_buf->addr & mask);
-	new_buf->addr += hr;
-
-	new_buf->handle = old_buf->handle & mask;
-	new_buf->handle += rx_ring->xsk_umem->headroom;
-
-	old_buf->addr = NULL;
-}
-
 /**
  * ice_construct_skb_zc - Create an sk_buff from zero-copy buffer
  * @rx_ring: Rx ring
@@ -755,13 +476,12 @@ ice_reuse_rx_buf_zc(struct ice_ring *rx_ring, struct ice_rx_buf *old_buf)
  * Returns the skb on success, NULL on failure.
  */
 static struct sk_buff *
-ice_construct_skb_zc(struct ice_ring *rx_ring, struct ice_rx_buf *rx_buf,
-		     struct xdp_buff *xdp)
+ice_construct_skb_zc(struct ice_ring *rx_ring, struct ice_rx_buf *rx_buf)
 {
-	unsigned int metasize = xdp->data - xdp->data_meta;
-	unsigned int datasize = xdp->data_end - xdp->data;
-	unsigned int datasize_hard = xdp->data_end -
-				     xdp->data_hard_start;
+	unsigned int metasize = rx_buf->xdp->data - rx_buf->xdp->data_meta;
+	unsigned int datasize = rx_buf->xdp->data_end - rx_buf->xdp->data;
+	unsigned int datasize_hard = rx_buf->xdp->data_end -
+				     rx_buf->xdp->data_hard_start;
 	struct sk_buff *skb;
 
 	skb = __napi_alloc_skb(&rx_ring->q_vector->napi, datasize_hard,
@@ -769,13 +489,13 @@ ice_construct_skb_zc(struct ice_ring *rx_ring, struct ice_rx_buf *rx_buf,
 	if (unlikely(!skb))
 		return NULL;
 
-	skb_reserve(skb, xdp->data - xdp->data_hard_start);
-	memcpy(__skb_put(skb, datasize), xdp->data, datasize);
+	skb_reserve(skb, rx_buf->xdp->data - rx_buf->xdp->data_hard_start);
+	memcpy(__skb_put(skb, datasize), rx_buf->xdp->data, datasize);
 	if (metasize)
 		skb_metadata_set(skb, metasize);
 
-	ice_reuse_rx_buf_zc(rx_ring, rx_buf);
-
+	xsk_buff_free(rx_buf->xdp);
+	rx_buf->xdp = NULL;
 	return skb;
 }
 
@@ -802,7 +522,6 @@ ice_run_xdp_zc(struct ice_ring *rx_ring, struct xdp_buff *xdp)
 	}
 
 	act = bpf_prog_run_xdp(xdp_prog, xdp);
-	xdp->handle += xdp->data - xdp->data_hard_start;
 	switch (act) {
 	case XDP_PASS:
 		break;
@@ -842,9 +561,6 @@ int ice_clean_rx_irq_zc(struct ice_ring *rx_ring, int budget)
 	u16 cleaned_count = ICE_DESC_UNUSED(rx_ring);
 	unsigned int xdp_xmit = 0;
 	bool failure = false;
-	struct xdp_buff xdp;
-
-	xdp.rxq = &rx_ring->xdp_rxq;
 
 	while (likely(total_rx_packets < (unsigned int)budget)) {
 		union ice_32b_rx_flex_desc *rx_desc;
@@ -856,8 +572,8 @@ int ice_clean_rx_irq_zc(struct ice_ring *rx_ring, int budget)
 		u8 rx_ptype;
 
 		if (cleaned_count >= ICE_RX_BUF_WRITE) {
-			failure |= ice_alloc_rx_bufs_fast_zc(rx_ring,
-							     cleaned_count);
+			failure |= ice_alloc_rx_bufs_zc(rx_ring,
+							cleaned_count);
 			cleaned_count = 0;
 		}
 
@@ -878,25 +594,19 @@ int ice_clean_rx_irq_zc(struct ice_ring *rx_ring, int budget)
 		if (!size)
 			break;
 
-		rx_buf = ice_get_rx_buf_zc(rx_ring, size);
-		if (!rx_buf->addr)
-			break;
 
-		xdp.data = rx_buf->addr;
-		xdp.data_meta = xdp.data;
-		xdp.data_hard_start = xdp.data - XDP_PACKET_HEADROOM;
-		xdp.data_end = xdp.data + size;
-		xdp.handle = rx_buf->handle;
+		rx_buf = &rx_ring->rx_buf[rx_ring->next_to_clean];
+		rx_buf->xdp->data_end = rx_buf->xdp->data + size;
+		xsk_buff_dma_sync_for_cpu(rx_buf->xdp);
 
-		xdp_res = ice_run_xdp_zc(rx_ring, &xdp);
+		xdp_res = ice_run_xdp_zc(rx_ring, rx_buf->xdp);
 		if (xdp_res) {
-			if (xdp_res & (ICE_XDP_TX | ICE_XDP_REDIR)) {
+			if (xdp_res & (ICE_XDP_TX | ICE_XDP_REDIR))
 				xdp_xmit |= xdp_res;
-				rx_buf->addr = NULL;
-			} else {
-				ice_reuse_rx_buf_zc(rx_ring, rx_buf);
-			}
+			else
+				xsk_buff_free(rx_buf->xdp);
 
+			rx_buf->xdp = NULL;
 			total_rx_bytes += size;
 			total_rx_packets++;
 			cleaned_count++;
@@ -906,7 +616,7 @@ int ice_clean_rx_irq_zc(struct ice_ring *rx_ring, int budget)
 		}
 
 		/* XDP_PASS path */
-		skb = ice_construct_skb_zc(rx_ring, rx_buf, &xdp);
+		skb = ice_construct_skb_zc(rx_ring, rx_buf);
 		if (!skb) {
 			rx_ring->rx_stats.alloc_buf_failed++;
 			break;
@@ -977,10 +687,9 @@ static bool ice_xmit_zc(struct ice_ring *xdp_ring, int budget)
 		if (!xsk_umem_consume_tx(xdp_ring->xsk_umem, &desc))
 			break;
 
-		dma = xdp_umem_get_dma(xdp_ring->xsk_umem, desc.addr);
-
-		dma_sync_single_for_device(xdp_ring->dev, dma, desc.len,
-					   DMA_BIDIRECTIONAL);
+		dma = xsk_buff_raw_get_dma(xdp_ring->xsk_umem, desc.addr);
+		xsk_buff_raw_dma_sync_for_device(xdp_ring->xsk_umem, dma,
+						 desc.len);
 
 		tx_buf->bytecount = desc.len;
 
@@ -1163,11 +872,10 @@ void ice_xsk_clean_rx_ring(struct ice_ring *rx_ring)
 	for (i = 0; i < rx_ring->count; i++) {
 		struct ice_rx_buf *rx_buf = &rx_ring->rx_buf[i];
 
-		if (!rx_buf->addr)
+		if (!rx_buf->xdp)
 			continue;
 
-		xsk_umem_fq_reuse(rx_ring->xsk_umem, rx_buf->handle);
-		rx_buf->addr = NULL;
+		rx_buf->xdp = NULL;
 	}
 }
 
diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.h b/drivers/net/ethernet/intel/ice/ice_xsk.h
index 8a4ba7c6d549..fc1a06b4df36 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.h
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.h
@@ -10,11 +10,10 @@ struct ice_vsi;
 
 #ifdef CONFIG_XDP_SOCKETS
 int ice_xsk_umem_setup(struct ice_vsi *vsi, struct xdp_umem *umem, u16 qid);
-void ice_zca_free(struct zero_copy_allocator *zca, unsigned long handle);
 int ice_clean_rx_irq_zc(struct ice_ring *rx_ring, int budget);
 bool ice_clean_tx_irq_zc(struct ice_ring *xdp_ring, int budget);
 int ice_xsk_wakeup(struct net_device *netdev, u32 queue_id, u32 flags);
-bool ice_alloc_rx_bufs_slow_zc(struct ice_ring *rx_ring, u16 count);
+bool ice_alloc_rx_bufs_zc(struct ice_ring *rx_ring, u16 count);
 bool ice_xsk_any_rx_ring_ena(struct ice_vsi *vsi);
 void ice_xsk_clean_rx_ring(struct ice_ring *rx_ring);
 void ice_xsk_clean_xdp_ring(struct ice_ring *xdp_ring);
@@ -27,12 +26,6 @@ ice_xsk_umem_setup(struct ice_vsi __always_unused *vsi,
 	return -EOPNOTSUPP;
 }
 
-static inline void
-ice_zca_free(struct zero_copy_allocator __always_unused *zca,
-	     unsigned long __always_unused handle)
-{
-}
-
 static inline int
 ice_clean_rx_irq_zc(struct ice_ring __always_unused *rx_ring,
 		    int __always_unused budget)
@@ -48,8 +41,8 @@ ice_clean_tx_irq_zc(struct ice_ring __always_unused *xdp_ring,
 }
 
 static inline bool
-ice_alloc_rx_bufs_slow_zc(struct ice_ring __always_unused *rx_ring,
-			  u16 __always_unused count)
+ice_alloc_rx_bufs_zc(struct ice_ring __always_unused *rx_ring,
+		     u16 __always_unused count)
 {
 	return false;
 }
-- 
2.25.1

