Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEFA1426B42
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 14:51:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242270AbhJHMxu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 08:53:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:50294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242151AbhJHMxh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Oct 2021 08:53:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0979160E95;
        Fri,  8 Oct 2021 12:51:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633697501;
        bh=EjC8xfR6GEPCuT/2k+oCgddUD4PEHEnvMQJ4Fp6XCB0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oB5WlqLegsUuitP/X+JJeEOQ4K68NF2BeAA/I4V42qb2M5yQsGpifEBgb3Lw+VxMt
         kbDpsehjyfUE2B1DpV8dzvJQOgGlQ27qyr4U3WMLtmzgaAt9+3YDkGGC3viHt+LJVn
         KoBjp0n89/i1DBKZcoo9AuccY5N0B4C8r8j9GWn+VfysmVx0qzlPjzaGeQPEiEgf5o
         f6UjKjQonQsSlRi56W0bIrKDwgO2b2Xf3y+TfHDpbUFKPvd/ncD/n7bCXayiHb39Nk
         khelkaOucszBlvSISYtBidW8V6j8C4Kt7sXmY/INyGNJlg458WVa4qECLQdAS5ZLWK
         0wQhJEP8Exrfw==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: [PATCH v15 bpf-next 10/18] bpf: add multi-buff support to the bpf_xdp_adjust_tail() API
Date:   Fri,  8 Oct 2021 14:49:48 +0200
Message-Id: <77dc6bffbf516c136b2e896d3f0251c36ca39241.1633697183.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1633697183.git.lorenzo@kernel.org>
References: <cover.1633697183.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eelco Chaudron <echaudro@redhat.com>

This change adds support for tail growing and shrinking for XDP multi-buff.

When called on a multi-buffer packet with a grow request, it will always
work on the last fragment of the packet. So the maximum grow size is the
last fragments tailroom, i.e. no new buffer will be allocated.

When shrinking, it will work from the last fragment, all the way down to
the base buffer depending on the shrinking size. It's important to mention
that once you shrink down the fragment(s) are freed, so you can not grow
again to the original size.

Acked-by: John Fastabend <john.fastabend@gmail.com>
Co-developed-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
---
 include/net/xdp.h |  2 ++
 net/core/filter.c | 65 +++++++++++++++++++++++++++++++++++++++++++++++
 net/core/xdp.c    |  5 ++--
 3 files changed, 70 insertions(+), 2 deletions(-)

diff --git a/include/net/xdp.h b/include/net/xdp.h
index 798b84d86d97..eccac03f2411 100644
--- a/include/net/xdp.h
+++ b/include/net/xdp.h
@@ -290,6 +290,8 @@ struct xdp_frame *xdp_convert_buff_to_frame(struct xdp_buff *xdp)
 	return xdp_frame;
 }
 
+void __xdp_return(void *data, struct xdp_mem_info *mem, bool napi_direct,
+		  struct xdp_buff *xdp);
 void xdp_return_frame(struct xdp_frame *xdpf);
 void xdp_return_frame_rx_napi(struct xdp_frame *xdpf);
 void xdp_return_buff(struct xdp_buff *xdp);
diff --git a/net/core/filter.c b/net/core/filter.c
index 4bace37a6a44..02fc6aa8a7b6 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3818,11 +3818,76 @@ static const struct bpf_func_proto bpf_xdp_adjust_head_proto = {
 	.arg2_type	= ARG_ANYTHING,
 };
 
+static int bpf_xdp_mb_increase_tail(struct xdp_buff *xdp, int offset)
+{
+	struct skb_shared_info *sinfo = xdp_get_shared_info_from_buff(xdp);
+	skb_frag_t *frag = &sinfo->frags[sinfo->nr_frags - 1];
+	int size, tailroom;
+
+	tailroom = xdp->frame_sz - skb_frag_size(frag) - skb_frag_off(frag);
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
+	int i, n_frags_free = 0, len_free = 0, tlen_free = 0;
+
+	if (unlikely(offset > ((int)(xdp->data_end - xdp->data) +
+			       sinfo->xdp_frags_size - ETH_HLEN)))
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
+			tlen_free += page_size(page);
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
index 6cdb7d50ef90..e11af2cead8a 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -339,8 +339,8 @@ EXPORT_SYMBOL_GPL(xdp_rxq_info_reg_mem_model);
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
@@ -373,6 +373,7 @@ static void __xdp_return(void *data, struct xdp_mem_info *mem, bool napi_direct,
 		break;
 	}
 }
+EXPORT_SYMBOL_GPL(__xdp_return);
 
 void xdp_return_frame(struct xdp_frame *xdpf)
 {
-- 
2.31.1

