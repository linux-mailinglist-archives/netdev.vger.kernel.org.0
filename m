Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0275406F73
	for <lists+netdev@lfdr.de>; Fri, 10 Sep 2021 18:15:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233913AbhIJQRC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Sep 2021 12:17:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:41666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233912AbhIJQQk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Sep 2021 12:16:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ECFDE61261;
        Fri, 10 Sep 2021 16:15:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631290527;
        bh=jhSqe/sOaCW61JDOEpqbNO54L+MxBjp3TsiQMWPXM1Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k5zccX6ftqY8utknCbps7SIl0BRvwL2rFqZHXcQ1bN/IiGbfNFshHJavXKGkicDWY
         fI+aoUO6TpLxXbpaG4VxAGNeUWd7Q+KbrTgBgYcJwq3xmN8ZM+/cZDVPVyMNf0IZaJ
         sv9K+CvvEy8gptY3ClCkGhGj2sbvFprxf4WJJMnYj1if0fnCTAC9znz8aHkcGqEoBp
         Tggrlt6g2mNFaJvFPDUf8RfAl1LrESG74bhVYG+/Euf2z+mt9P6uZP2ZVbn5tJGLyP
         6ofbsFARoHj3AUphPRq5FXMtxwiUIUr0A4XEXAWBkpnH2SIznIFkHRrMvwHekZXbdD
         13sPariA61Vag==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: [PATCH v14 bpf-next 10/18] bpf: add multi-buff support to the bpf_xdp_adjust_tail() API
Date:   Fri, 10 Sep 2021 18:14:16 +0200
Message-Id: <e07aa987d148c168f1ac95a315d45e24e58c54f5.1631289870.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1631289870.git.lorenzo@kernel.org>
References: <cover.1631289870.git.lorenzo@kernel.org>
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
 include/net/xdp.h |  9 +++++++
 net/core/filter.c | 60 +++++++++++++++++++++++++++++++++++++++++++++++
 net/core/xdp.c    |  5 ++--
 3 files changed, 72 insertions(+), 2 deletions(-)

diff --git a/include/net/xdp.h b/include/net/xdp.h
index e44964329fd1..789251e464de 100644
--- a/include/net/xdp.h
+++ b/include/net/xdp.h
@@ -145,6 +145,13 @@ xdp_get_shared_info_from_buff(struct xdp_buff *xdp)
 	return (struct skb_shared_info *)xdp_data_hard_end(xdp);
 }
 
+static inline unsigned int xdp_get_frag_tailroom(const skb_frag_t *frag)
+{
+	struct page *page = skb_frag_page(frag);
+
+	return page_size(page) - skb_frag_size(frag) - skb_frag_off(frag);
+}
+
 struct xdp_frame {
 	void *data;
 	u16 len;
@@ -290,6 +297,8 @@ struct xdp_frame *xdp_convert_buff_to_frame(struct xdp_buff *xdp)
 	return xdp_frame;
 }
 
+void __xdp_return(void *data, struct xdp_mem_info *mem, bool napi_direct,
+		  struct xdp_buff *xdp);
 void xdp_return_frame(struct xdp_frame *xdpf);
 void xdp_return_frame_rx_napi(struct xdp_frame *xdpf);
 void xdp_return_buff(struct xdp_buff *xdp);
diff --git a/net/core/filter.c b/net/core/filter.c
index 2e32cee2c469..49feba8f8966 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3818,11 +3818,71 @@ static const struct bpf_func_proto bpf_xdp_adjust_head_proto = {
 	.arg2_type	= ARG_ANYTHING,
 };
 
+static int bpf_xdp_mb_adjust_tail(struct xdp_buff *xdp, int offset)
+{
+	struct skb_shared_info *sinfo;
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
+		sinfo->xdp_frags_size += offset;
+	} else {
+		int i, n_frags_free = 0, len_free = 0, tlen_free = 0;
+
+		offset = abs(offset);
+		if (unlikely(offset > ((int)(xdp->data_end - xdp->data) +
+				       sinfo->xdp_frags_size - ETH_HLEN)))
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
+				tlen_free += page_size(page);
+				n_frags_free++;
+			} else {
+				skb_frag_size_set(frag, size - shrink);
+				break;
+			}
+		}
+		sinfo->nr_frags -= n_frags_free;
+		sinfo->xdp_frags_size -= len_free;
+		sinfo->xdp_frags_truesize -= tlen_free;
+
+		if (unlikely(offset > 0)) {
+			xdp_buff_clear_mb(xdp);
+			xdp->data_end -= offset;
+		}
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
index ffdc776a9e95..c3a3f36416b8 100644
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

