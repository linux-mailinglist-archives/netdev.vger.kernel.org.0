Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08A053F2FE8
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 17:45:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241221AbhHTPqU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 11:46:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:34692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241313AbhHTPn7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Aug 2021 11:43:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B153B6103C;
        Fri, 20 Aug 2021 15:43:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629474201;
        bh=SOl1JWndideS/gN4a2B68GsUnG2rwxxMkyKwLgmvsF0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oMLQ8saLMF2gGUFkHCLKlePUwcLWgo8zR6RzO59UX9u4iyAMQEiScLIsuIoFcbEm0
         t5vuM5TyfGkhJZGetoog6chgVBJltThqnbjcISxCit9RbRg/eQrdTvZ7vw6YEJ9WOy
         zRPKi0b/6kDSBUD9IGlQxxXS1EaYQUhf+wBqhFx6IomKgvHcLJwu2eYtPVX5I8YelU
         fHp4h+Bgy++Dqbiaq4WWgMHtCtAulHedNYI7Xjs/jHzp6Pa3712anCjwDT+X3W4BsK
         UpNp5sOgV0EE/i4DUywQ8jIW+0ScwD352c1cUlD5ayujM/4bmMhZATelKRMgXhPwr/
         iY61mQvg8ReYg==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: [PATCH v12 bpf-next 10/18] bpf: add multi-buff support to the bpf_xdp_adjust_tail() API
Date:   Fri, 20 Aug 2021 17:40:23 +0200
Message-Id: <a86c03ed84a6ca275e65d44aef8abaff890f7e3f.1629473233.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1629473233.git.lorenzo@kernel.org>
References: <cover.1629473233.git.lorenzo@kernel.org>
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

Co-developed-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
---
 include/net/xdp.h |  9 +++++++
 net/core/filter.c | 60 +++++++++++++++++++++++++++++++++++++++++++++++
 net/core/xdp.c    |  5 ++--
 3 files changed, 72 insertions(+), 2 deletions(-)

diff --git a/include/net/xdp.h b/include/net/xdp.h
index d66e9877d773..cdaecf8d4d61 100644
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
index 59b8f5050180..e6a589705813 100644
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
+		sinfo->xdp_frags_tsize -= tlen_free;
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
index 1346fb8b3f50..a71cdea75306 100644
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

