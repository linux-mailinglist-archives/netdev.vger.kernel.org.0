Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E29EF342812
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 22:49:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231162AbhCSVst (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 17:48:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:45628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230433AbhCSVsa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Mar 2021 17:48:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C626A61958;
        Fri, 19 Mar 2021 21:48:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616190509;
        bh=UffDz3mjDvxHKJazLrKdQOkZimTnyea4SglojrrVotQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jLsIRTn7nwHSw2ps3BGw++6I2gLzgWnvQECQAQgShP1MqyWTgxXJ7V4d+lkTHxGt9
         8Y7Vo1ALIhI1Gl40yCg3iBTbzu4HV5XGi6aZJrr0vFFudRZC3d8s9J6PYs8TLKJOfk
         sGvcG+XanyPEy5NISN/j7rkBCjXpppkDkqK2Kuweqg+Et3Kh+kPVrmerjatt6PYdVy
         3EvRHATqHH201rehfwxQaCmY4SWOcc3utdMrTt48sbkltoc5sJhvYo3dO5As/cHc6h
         mPsb3X3vnq/cTbkwk7XNsradyO2iFqIpKgHKp3avz27NvYO8Tgk4exKA+P3yxcUn/c
         5MFiRlnrNqKaQ==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, sameehj@amazon.com
Subject: [PATCH v7 bpf-next 08/14] bpf: add multi-buff support to the bpf_xdp_adjust_tail() API
Date:   Fri, 19 Mar 2021 22:47:22 +0100
Message-Id: <6da4e8a314e7fbdeb0a6790a920a4ae554fb3742.1616179034.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <cover.1616179034.git.lorenzo@kernel.org>
References: <cover.1616179034.git.lorenzo@kernel.org>
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
index 8be1b5e5a08a..19cd6642e087 100644
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
index 10dac9dd5086..18b2c9bacba1 100644
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

