Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E45C463386
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 12:55:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230236AbhK3L6P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 06:58:15 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:58886 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232764AbhK3L6N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 06:58:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 8330CCE16DE;
        Tue, 30 Nov 2021 11:54:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA823C53FD1;
        Tue, 30 Nov 2021 11:54:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638273287;
        bh=v0+zIM8l289L2YfRHM73gIL9XTxvbVfHZ9vw96qWmKU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q0I73sDxokh6FtPDST1T1op5UKK39iVoBoJeNIdxbYSz+dmGv0jI+DPkhQpF17MdE
         /kiFwoOO56K8g1MSZPb27s8YMr++Ld30j2Js8ZM+lGhnqt6S6ptQuLte9l5ftxHQcR
         MMRlTjM30eL95JxT4wBEvcqEDgMaCIQqRTlYnS3I2I4G8jYi8PMxht5M30Rd4EDNwv
         HCC2BJUBPZtugOOsoK5SQBjPjhVG3dkBS5Yu8oIGy1aLrUvqtoPO7zGTuiosCbE6SP
         CYCjDPsRI1YhTqK8B1Q/i0K9XNNkY0HI43Daue6ob2zXYfjXXNoJdMyvEacwABWk0Q
         H5VsWH2Yy7Uzg==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: [PATCH v19 bpf-next 12/23] bpf: add multi-buff support to the bpf_xdp_adjust_tail() API
Date:   Tue, 30 Nov 2021 12:52:56 +0100
Message-Id: <81319e52462c07361dbf99b9ec1748b41cdcf9fa.1638272238.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1638272238.git.lorenzo@kernel.org>
References: <cover.1638272238.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eelco Chaudron <echaudro@redhat.com>

This change adds support for tail growing and shrinking for XDP multi-buff.

When called on a multi-buffer packet with a grow request, it will work
on the last fragment of the packet. So the maximum grow size is the
last fragments tailroom, i.e. no new buffer will be allocated.
A XDP mb capable driver is expected to set frag_size in xdp_rxq_info data
structure to notify the XDP core the fragment size. frag_size set to 0 is
interpreted by the XDP core as tail growing is not allowed.
Introduce __xdp_rxq_info_reg utility routine to initialize frag_size field.

When shrinking, it will work from the last fragment, all the way down to
the base buffer depending on the shrinking size. It's important to mention
that once you shrink down the fragment(s) are freed, so you can not grow
again to the original size.

Acked-by: Jakub Kicinski <kuba@kernel.org>
Co-developed-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
---
 drivers/net/ethernet/marvell/mvneta.c |  3 +-
 include/net/xdp.h                     | 16 ++++++-
 net/core/filter.c                     | 67 +++++++++++++++++++++++++++
 net/core/xdp.c                        | 12 +++--
 4 files changed, 90 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 98db3d03116a..5296a17236ad 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -3270,7 +3270,8 @@ static int mvneta_create_page_pool(struct mvneta_port *pp,
 		return err;
 	}
 
-	err = xdp_rxq_info_reg(&rxq->xdp_rxq, pp->dev, rxq->id, 0);
+	err = __xdp_rxq_info_reg(&rxq->xdp_rxq, pp->dev, rxq->id, 0,
+				 PAGE_SIZE);
 	if (err < 0)
 		goto err_free_pp;
 
diff --git a/include/net/xdp.h b/include/net/xdp.h
index 067716d38ebc..c45eaf58b3d4 100644
--- a/include/net/xdp.h
+++ b/include/net/xdp.h
@@ -60,6 +60,7 @@ struct xdp_rxq_info {
 	u32 reg_state;
 	struct xdp_mem_info mem;
 	unsigned int napi_id;
+	u32 frag_size;
 } ____cacheline_aligned; /* perf critical, avoid false-sharing */
 
 struct xdp_txq_info {
@@ -304,6 +305,8 @@ struct xdp_frame *xdp_convert_buff_to_frame(struct xdp_buff *xdp)
 	return xdp_frame;
 }
 
+void __xdp_return(void *data, struct xdp_mem_info *mem, bool napi_direct,
+		  struct xdp_buff *xdp);
 void xdp_return_frame(struct xdp_frame *xdpf);
 void xdp_return_frame_rx_napi(struct xdp_frame *xdpf);
 void xdp_return_buff(struct xdp_buff *xdp);
@@ -340,8 +343,17 @@ static inline void xdp_release_frame(struct xdp_frame *xdpf)
 	__xdp_release_frame(xdpf->data, mem);
 }
 
-int xdp_rxq_info_reg(struct xdp_rxq_info *xdp_rxq,
-		     struct net_device *dev, u32 queue_index, unsigned int napi_id);
+int __xdp_rxq_info_reg(struct xdp_rxq_info *xdp_rxq,
+		       struct net_device *dev, u32 queue_index,
+		       unsigned int napi_id, u32 frag_size);
+static inline int
+xdp_rxq_info_reg(struct xdp_rxq_info *xdp_rxq,
+		 struct net_device *dev, u32 queue_index,
+		 unsigned int napi_id)
+{
+	return __xdp_rxq_info_reg(xdp_rxq, dev, queue_index, napi_id, 0);
+}
+
 void xdp_rxq_info_unreg(struct xdp_rxq_info *xdp_rxq);
 void xdp_rxq_info_unused(struct xdp_rxq_info *xdp_rxq);
 bool xdp_rxq_info_is_reg(struct xdp_rxq_info *xdp_rxq);
diff --git a/net/core/filter.c b/net/core/filter.c
index b9bfe6fac6df..ace67957e685 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3831,11 +3831,78 @@ static const struct bpf_func_proto bpf_xdp_adjust_head_proto = {
 	.arg2_type	= ARG_ANYTHING,
 };
 
+static int bpf_xdp_mb_increase_tail(struct xdp_buff *xdp, int offset)
+{
+	struct skb_shared_info *sinfo = xdp_get_shared_info_from_buff(xdp);
+	skb_frag_t *frag = &sinfo->frags[sinfo->nr_frags - 1];
+	struct xdp_rxq_info *rxq = xdp->rxq;
+	int size, tailroom;
+
+	if (!rxq->frag_size || rxq->frag_size > xdp->frame_sz)
+		return -EOPNOTSUPP;
+
+	tailroom = rxq->frag_size - skb_frag_size(frag) - skb_frag_off(frag);
+	if (unlikely(offset > tailroom))
+		return -EINVAL;
+
+	size = skb_frag_size(frag);
+	memset(skb_frag_address(frag) + size, 0, offset);
+	skb_frag_size_set(frag, size + offset);
+	sinfo->xdp_frags_size += offset;
+
+	return 0;
+}
+
+static int bpf_xdp_mb_shrink_tail(struct xdp_buff *xdp, int offset)
+{
+	struct skb_shared_info *sinfo = xdp_get_shared_info_from_buff(xdp);
+	int i, n_frags_free = 0, len_free = 0;
+
+	if (unlikely(offset > (int)xdp_get_buff_len(xdp) - ETH_HLEN))
+		return -EINVAL;
+
+	for (i = sinfo->nr_frags - 1; i >= 0 && offset > 0; i--) {
+		skb_frag_t *frag = &sinfo->frags[i];
+		int size = skb_frag_size(frag);
+		int shrink = min_t(int, offset, size);
+
+		len_free += shrink;
+		offset -= shrink;
+
+		if (unlikely(size == shrink)) {
+			struct page *page = skb_frag_page(frag);
+
+			__xdp_return(page_address(page), &xdp->rxq->mem,
+				     false, NULL);
+			n_frags_free++;
+		} else {
+			skb_frag_size_set(frag, size - shrink);
+			break;
+		}
+	}
+	sinfo->nr_frags -= n_frags_free;
+	sinfo->xdp_frags_size -= len_free;
+
+	if (unlikely(offset > 0)) {
+		xdp_buff_clear_mb(xdp);
+		xdp->data_end -= offset;
+	}
+
+	return 0;
+}
+
 BPF_CALL_2(bpf_xdp_adjust_tail, struct xdp_buff *, xdp, int, offset)
 {
 	void *data_hard_end = xdp_data_hard_end(xdp); /* use xdp->frame_sz */
 	void *data_end = xdp->data_end + offset;
 
+	if (unlikely(xdp_buff_is_mb(xdp))) { /* xdp multi-buffer */
+		if (offset < 0)
+			return bpf_xdp_mb_shrink_tail(xdp, -offset);
+
+		return bpf_xdp_mb_increase_tail(xdp, offset);
+	}
+
 	/* Notice that xdp_data_hard_end have reserved some tailroom */
 	if (unlikely(data_end > data_hard_end))
 		return -EINVAL;
diff --git a/net/core/xdp.c b/net/core/xdp.c
index 7cfcc93116d7..bf3b3884efb3 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -156,8 +156,9 @@ static void xdp_rxq_info_init(struct xdp_rxq_info *xdp_rxq)
 }
 
 /* Returns 0 on success, negative on failure */
-int xdp_rxq_info_reg(struct xdp_rxq_info *xdp_rxq,
-		     struct net_device *dev, u32 queue_index, unsigned int napi_id)
+int __xdp_rxq_info_reg(struct xdp_rxq_info *xdp_rxq,
+		       struct net_device *dev, u32 queue_index,
+		       unsigned int napi_id, u32 frag_size)
 {
 	if (xdp_rxq->reg_state == REG_STATE_UNUSED) {
 		WARN(1, "Driver promised not to register this");
@@ -179,11 +180,12 @@ int xdp_rxq_info_reg(struct xdp_rxq_info *xdp_rxq,
 	xdp_rxq->dev = dev;
 	xdp_rxq->queue_index = queue_index;
 	xdp_rxq->napi_id = napi_id;
+	xdp_rxq->frag_size = frag_size;
 
 	xdp_rxq->reg_state = REG_STATE_REGISTERED;
 	return 0;
 }
-EXPORT_SYMBOL_GPL(xdp_rxq_info_reg);
+EXPORT_SYMBOL_GPL(__xdp_rxq_info_reg);
 
 void xdp_rxq_info_unused(struct xdp_rxq_info *xdp_rxq)
 {
@@ -337,8 +339,8 @@ EXPORT_SYMBOL_GPL(xdp_rxq_info_reg_mem_model);
  * is used for those calls sites.  Thus, allowing for faster recycling
  * of xdp_frames/pages in those cases.
  */
-static void __xdp_return(void *data, struct xdp_mem_info *mem, bool napi_direct,
-			 struct xdp_buff *xdp)
+void __xdp_return(void *data, struct xdp_mem_info *mem, bool napi_direct,
+		  struct xdp_buff *xdp)
 {
 	struct xdp_mem_allocator *xa;
 	struct page *page;
-- 
2.31.1

