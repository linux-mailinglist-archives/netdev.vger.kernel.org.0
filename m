Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18B2D42F1D8
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 15:10:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239224AbhJONMU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 09:12:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:33880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239333AbhJONMS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Oct 2021 09:12:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 07754610E5;
        Fri, 15 Oct 2021 13:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634303412;
        bh=EjC8xfR6GEPCuT/2k+oCgddUD4PEHEnvMQJ4Fp6XCB0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s5mqkrs0lKINit+QEqPlIvQIgRewIQtfKJ5pwh3jaDoqIFlO6/RJM8wjJkW2LL6ax
         McTAx6ak+Ny0Kg0fYtV7EpL0e7WgHK2MbqYslQbPBWvb1VW3eEJCUcYOP0DCAcll5b
         baE0Br91++WsYkTKUCC+W0sthNUgvfKb0f1nKjMWICO2I9O/mIEH0FGYn78/WfkeYy
         qDFcdJ4GoiZmvSIRFDP/4W3XpRbkUcySswoYrzzRymfVyGF+cpZs7I2QQusaSx0i1K
         nZubnQpE0ZWpFCyH7EdmYwOFgI0OmQFIcD9Ahr4ZOV3rY7Kl2YuYAZmymUtgPlUnhZ
         NbLDggGO6mOWQ==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: [PATCH v16 bpf-next 11/20] bpf: add multi-buff support to the bpf_xdp_adjust_tail() API
Date:   Fri, 15 Oct 2021 15:08:48 +0200
Message-Id: <ee5747b13df645f3ea89d970103c67ce44e8a875.1634301224.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1634301224.git.lorenzo@kernel.org>
References: <cover.1634301224.git.lorenzo@kernel.org>
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

