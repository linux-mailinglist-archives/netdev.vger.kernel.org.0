Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DE6B2D1627
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 17:36:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727647AbgLGQe3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 11:34:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:33136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727017AbgLGQe1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Dec 2020 11:34:27 -0500
From:   Lorenzo Bianconi <lorenzo@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, shayagr@amazon.com, sameehj@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, lorenzo.bianconi@redhat.com,
        jasowang@redhat.com
Subject: [PATCH v5 bpf-next 12/14] bpf: add multi-buff support to the bpf_xdp_adjust_tail() API
Date:   Mon,  7 Dec 2020 17:32:41 +0100
Message-Id: <45d9ac7cd5895fa7af1ff54472257662ba25b877.1607349924.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1607349924.git.lorenzo@kernel.org>
References: <cover.1607349924.git.lorenzo@kernel.org>
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
index 76cfee6a40f7..09078ab6644c 100644
--- a/include/net/xdp.h
+++ b/include/net/xdp.h
@@ -137,6 +137,11 @@ static inline void xdp_set_frag_size(skb_frag_t *frag, u32 size)
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
index 77001a35768f..4c4882d4d92c 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3860,11 +3860,74 @@ static const struct bpf_func_proto bpf_xdp_adjust_head_proto = {
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
2.28.0

