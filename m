Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F69A3A6712
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 14:52:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233879AbhFNMxY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 08:53:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:44032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233744AbhFNMxK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Jun 2021 08:53:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9853B61360;
        Mon, 14 Jun 2021 12:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623675067;
        bh=cQz7Na97KwSh/um9HIF4VqPaAAMWO3DjgmpQWQnAxlw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lOi4/vPs9OeY/00Leblr8PxpRlZLb0+YX34OVL3ssUnqCjyrLL4w5pwjIIyNF5vSL
         Xc/DLZaI/towEEz0WmC2N3CBK/edEFzcp4R5eVQv3aXpKQqOEXs/qsDgxCB3hlrxg8
         obYxcj25DarmxMTV9Z9hVsJDcejWb5M7+at1dm1XSrqQm3QBw1k0haQcGCIDP0Glsq
         P2zZYQieXxfn9KzkHAlQnGQwYUYOvUpMhYjFLd1xXltpVo8sE1/4hy32mwzLj5qb7v
         NNbTGV04GCm55Ya2Yr6XergyZxk/+fnhgikIDAKMXr1NHt2eK2WQKwOLcZj/dJugue
         6O2T5+dJk3GWw==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        sameehj@amazon.com, john.fastabend@gmail.com, dsahern@kernel.org,
        brouer@redhat.com, echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com
Subject: [PATCH v9 bpf-next 08/14] bpf: add multi-buff support to the bpf_xdp_adjust_tail() API
Date:   Mon, 14 Jun 2021 14:49:46 +0200
Message-Id: <863f4934d251f44ad85a6be08b3737fac74f9b5a.1623674025.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1623674025.git.lorenzo@kernel.org>
References: <cover.1623674025.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eelco Chaudron <echaudro@redhat.com>

This change adds support for tail growing and shrinking for XDP multi-buff.

Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 include/net/xdp.h |  7 ++++++
 net/core/filter.c | 62 +++++++++++++++++++++++++++++++++++++++++++++++
 net/core/xdp.c    |  5 ++--
 3 files changed, 72 insertions(+), 2 deletions(-)

diff --git a/include/net/xdp.h b/include/net/xdp.h
index 935a6f83115f..3525801c6ed5 100644
--- a/include/net/xdp.h
+++ b/include/net/xdp.h
@@ -132,6 +132,11 @@ xdp_get_shared_info_from_buff(struct xdp_buff *xdp)
 	return (struct skb_shared_info *)xdp_data_hard_end(xdp);
 }
 
+static inline unsigned int xdp_get_frag_tailroom(const skb_frag_t *frag)
+{
+	return PAGE_SIZE - skb_frag_size(frag) - skb_frag_off(frag);
+}
+
 struct xdp_frame {
 	void *data;
 	u16 len;
@@ -259,6 +264,8 @@ struct xdp_frame *xdp_convert_buff_to_frame(struct xdp_buff *xdp)
 	return xdp_frame;
 }
 
+void __xdp_return(void *data, struct xdp_mem_info *mem, bool napi_direct,
+		  struct xdp_buff *xdp);
 void xdp_return_frame(struct xdp_frame *xdpf);
 void xdp_return_frame_rx_napi(struct xdp_frame *xdpf);
 void xdp_return_buff(struct xdp_buff *xdp);
diff --git a/net/core/filter.c b/net/core/filter.c
index caa88955562e..05f574a3d690 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3859,11 +3859,73 @@ static const struct bpf_func_proto bpf_xdp_adjust_head_proto = {
 	.arg2_type	= ARG_ANYTHING,
 };
 
+static int bpf_xdp_mb_adjust_tail(struct xdp_buff *xdp, int offset)
+{
+	struct skb_shared_info *sinfo;
+
+	if (unlikely(!xdp_buff_is_mb(xdp)))
+		return -EINVAL;
+
+	sinfo = xdp_get_shared_info_from_buff(xdp);
+	if (offset >= 0) {
+		skb_frag_t *frag = &sinfo->frags[sinfo->nr_frags - 1];
+		int size;
+
+		if (unlikely(offset > xdp_get_frag_tailroom(frag)))
+			return -EINVAL;
+
+		size = skb_frag_size(frag);
+		memset(skb_frag_address(frag) + size, 0, offset);
+		skb_frag_size_set(frag, size + offset);
+		sinfo->data_len += offset;
+	} else {
+		int i, n_frags_free = 0, len_free = 0;
+
+		offset = abs(offset);
+		if (unlikely(offset > ((int)(xdp->data_end - xdp->data) +
+				       sinfo->data_len - ETH_HLEN)))
+			return -EINVAL;
+
+		for (i = sinfo->nr_frags - 1; i >= 0 && offset > 0; i--) {
+			skb_frag_t *frag = &sinfo->frags[i];
+			int size = skb_frag_size(frag);
+			int shrink = min_t(int, offset, size);
+
+			len_free += shrink;
+			offset -= shrink;
+
+			if (unlikely(size == shrink)) {
+				struct page *page = skb_frag_page(frag);
+
+				__xdp_return(page_address(page), &xdp->rxq->mem,
+					     false, NULL);
+				n_frags_free++;
+			} else {
+				skb_frag_size_set(frag, size - shrink);
+				break;
+			}
+		}
+		sinfo->nr_frags -= n_frags_free;
+		sinfo->data_len -= len_free;
+
+		if (unlikely(!sinfo->nr_frags))
+			xdp_buff_clear_mb(xdp);
+
+		if (unlikely(offset > 0))
+			xdp->data_end -= offset;
+	}
+
+	return 0;
+}
+
 BPF_CALL_2(bpf_xdp_adjust_tail, struct xdp_buff *, xdp, int, offset)
 {
 	void *data_hard_end = xdp_data_hard_end(xdp); /* use xdp->frame_sz */
 	void *data_end = xdp->data_end + offset;
 
+	if (unlikely(xdp_buff_is_mb(xdp)))
+		return bpf_xdp_mb_adjust_tail(xdp, offset);
+
 	/* Notice that xdp_data_hard_end have reserved some tailroom */
 	if (unlikely(data_end > data_hard_end))
 		return -EINVAL;
diff --git a/net/core/xdp.c b/net/core/xdp.c
index 71bedf6049a1..ffd70d3e9e5d 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -338,8 +338,8 @@ EXPORT_SYMBOL_GPL(xdp_rxq_info_reg_mem_model);
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
@@ -372,6 +372,7 @@ static void __xdp_return(void *data, struct xdp_mem_info *mem, bool napi_direct,
 		break;
 	}
 }
+EXPORT_SYMBOL_GPL(__xdp_return);
 
 void xdp_return_frame(struct xdp_frame *xdpf)
 {
-- 
2.31.1

