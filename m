Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A3BB3583C6
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 14:52:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231724AbhDHMwN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 08:52:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:57772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231700AbhDHMwJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Apr 2021 08:52:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CB03461159;
        Thu,  8 Apr 2021 12:51:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617886318;
        bh=I6iHHaFwpIYFd/YaMiULJLSAXqjyBOLD91wu/IgsYcw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BuwLC4O4JPEil+rCw23kdV0HiNJLHzQqEK38P3zfxfSWuLPDwBE/ccdy3LGdfp8Bg
         HTotGxFO5pMT6PEnhPq2/Gu5GSVyyXb0dmFLiB3O6wBKxzMu1Xa4Fa8hhZq+R9uak6
         R/UbecE3/aB4n0uJFRs3ZllX7Bln4kU2NoWFGj4jB1e5TgwgC3LPmRTOIOc97mPgK7
         U2GNiuGcHr6PuewB/qE/4UXcglFoL2dHo9dgpXNY0rszgNTDN1k+FwFqpwtaxBKevR
         1OEOzX70Li7BTVk+Z34sZL3xOMtOgBZ2q0AteIMZBzYD636itzzfgohJOKJFStLiSF
         6WcFgzXbPjRwA==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        sameehj@amazon.com, john.fastabend@gmail.com, dsahern@kernel.org,
        brouer@redhat.com, echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com
Subject: [PATCH v8 bpf-next 08/14] bpf: add multi-buff support to the bpf_xdp_adjust_tail() API
Date:   Thu,  8 Apr 2021 14:51:00 +0200
Message-Id: <427bd05d147a247fc30fd438be94b5d51845b05f.1617885385.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <cover.1617885385.git.lorenzo@kernel.org>
References: <cover.1617885385.git.lorenzo@kernel.org>
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
 include/net/xdp.h |  5 ++++
 net/core/filter.c | 63 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 68 insertions(+)

diff --git a/include/net/xdp.h b/include/net/xdp.h
index c8eb7cf4ebed..55751cf2badf 100644
--- a/include/net/xdp.h
+++ b/include/net/xdp.h
@@ -159,6 +159,11 @@ static inline void xdp_set_frag_size(skb_frag_t *frag, u32 size)
 	frag->bv_len = size;
 }
 
+static inline unsigned int xdp_get_frag_tailroom(const skb_frag_t *frag)
+{
+	return PAGE_SIZE - xdp_get_frag_size(frag) - xdp_get_frag_offset(frag);
+}
+
 struct xdp_frame {
 	void *data;
 	u16 len;
diff --git a/net/core/filter.c b/net/core/filter.c
index cae56d08a670..c4eb1392f88e 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3855,11 +3855,74 @@ static const struct bpf_func_proto bpf_xdp_adjust_head_proto = {
 	.arg2_type	= ARG_ANYTHING,
 };
 
+static int bpf_xdp_mb_adjust_tail(struct xdp_buff *xdp, int offset)
+{
+	struct xdp_shared_info *xdp_sinfo = xdp_get_shared_info_from_buff(xdp);
+
+	if (unlikely(xdp_sinfo->nr_frags == 0))
+		return -EINVAL;
+
+	if (offset >= 0) {
+		skb_frag_t *frag = &xdp_sinfo->frags[xdp_sinfo->nr_frags - 1];
+		int size;
+
+		if (unlikely(offset > xdp_get_frag_tailroom(frag)))
+			return -EINVAL;
+
+		size = xdp_get_frag_size(frag);
+		memset(xdp_get_frag_address(frag) + size, 0, offset);
+		xdp_set_frag_size(frag, size + offset);
+		xdp_sinfo->data_length += offset;
+	} else {
+		int i, frags_to_free = 0;
+
+		offset = abs(offset);
+
+		if (unlikely(offset > ((int)(xdp->data_end - xdp->data) +
+				       xdp_sinfo->data_length -
+				       ETH_HLEN)))
+			return -EINVAL;
+
+		for (i = xdp_sinfo->nr_frags - 1; i >= 0 && offset > 0; i--) {
+			skb_frag_t *frag = &xdp_sinfo->frags[i];
+			int size = xdp_get_frag_size(frag);
+			int shrink = min_t(int, offset, size);
+
+			offset -= shrink;
+			if (likely(size - shrink > 0)) {
+				/* When updating the final fragment we have
+				 * to adjust the data_length in line.
+				 */
+				xdp_sinfo->data_length -= shrink;
+				xdp_set_frag_size(frag, size - shrink);
+				break;
+			}
+
+			/* When we free the fragments,
+			 * xdp_return_frags_from_buff() will take care
+			 * of updating the xdp share info data_length.
+			 */
+			frags_to_free++;
+		}
+
+		if (unlikely(frags_to_free))
+			xdp_return_num_frags_from_buff(xdp, frags_to_free);
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
 
+	if (unlikely(xdp->mb))
+		return bpf_xdp_mb_adjust_tail(xdp, offset);
+
 	/* Notice that xdp_data_hard_end have reserved some tailroom */
 	if (unlikely(data_end > data_hard_end))
 		return -EINVAL;
-- 
2.30.2

