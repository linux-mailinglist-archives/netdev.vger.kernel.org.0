Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEFD92FC0E0
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 21:24:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729325AbhASUW6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 15:22:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:56208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729780AbhASUWQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Jan 2021 15:22:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E7DF323131;
        Tue, 19 Jan 2021 20:21:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611087665;
        bh=4SmFoxP+xrgfe2Ekh8Np/OrZmdH+BwGDbumAr1h2DCc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PN2+bmJSRPzUZjx2RG7W5pLkyXIZoIvaNqxaBkEE4QZOxiKj9yj/qy9SyblKf8wKf
         DKKdQewIzlvMMceJn2XibSWFIE0Y0bQ2wwv9ArK+khqKPeRkQUC6RKM4k86bKhL5Po
         Gt1xBIb+5Y/LTrdbttqU+XoSAOtxfskWH08NvZLiKxyDAOW30Zspqtf771zmUeSfha
         0I47/zaooKBRT+3qyyqJORrlrCuh8ZnPu/UJUFmevvkkmar580CcJCAfAijqMM2oXX
         hWc6C3jPi9/SvmGgQg8SzLzkhN+vDbVumn3VN+Ytn0iY4HNgTps3apgbmo/SLa46Ka
         Q+aQZC70/6XdA==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, sameehj@amazon.com
Subject: [PATCH v6 bpf-next 8/8] bpf: add multi-buff support to the bpf_xdp_adjust_tail() API
Date:   Tue, 19 Jan 2021 21:20:14 +0100
Message-Id: <9248f1347d67587010274cdd488fe5a0008e3f9c.1611086134.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <cover.1611086134.git.lorenzo@kernel.org>
References: <cover.1611086134.git.lorenzo@kernel.org>
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
index a2e09031b346..4bc86538e052 100644
--- a/include/net/xdp.h
+++ b/include/net/xdp.h
@@ -157,6 +157,11 @@ static inline void xdp_set_frag_size(skb_frag_t *frag, u32 size)
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
index 9ab94e90d660..86d0adc6cecd 100644
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
2.29.2

