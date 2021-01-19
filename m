Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93C9B2FC14E
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 21:41:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391589AbhASUjk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 15:39:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:55858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729133AbhASUVO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Jan 2021 15:21:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6A16C2310B;
        Tue, 19 Jan 2021 20:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611087633;
        bh=zRvnC+rMpVuGdnEf78Q53RzlvyZSgmNFdlCLTFG2m8c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qdOM4oU8k+LMMJRotRJ4X+pHTmLhkfTL2iHyvV5JI8/Hp2i2G+GgBciWY4ae4XKog
         cbYCVZbX7H4oZXD5/niOFF8beLgbCyMtOhvicTQ8MNi7BGpOylGi5sGzqiajKWZfLW
         UuSAlQRpG7kU84j2hRdI83WXjbECUn8XjKd4JyluRuFA9I0kbvhxO+FTaQG68Gmtb5
         PwAtcYVssNHtwb3eJB8pbEiV+ToXFvUX96i2OkzcZjJ0SBB+f9wXOySFHnzW8D5VU2
         2A+66gVYn5eYwI5my0NoOfEle9Xp2dpgXSkW9EvLZ/z41N9p3AME0WB5UGdcWg9ZLm
         GhkLlC5WYs//A==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, sameehj@amazon.com
Subject: [PATCH v6 bpf-next 1/8] xdp: introduce mb in xdp_buff/xdp_frame
Date:   Tue, 19 Jan 2021 21:20:07 +0100
Message-Id: <6e92b9194558d7251bba5405b3138daaa8a1a950.1611086134.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <cover.1611086134.git.lorenzo@kernel.org>
References: <cover.1611086134.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce multi-buffer bit (mb) in xdp_frame/xdp_buffer data structure
in order to specify if this is a linear buffer (mb = 0) or a multi-buffer
frame (mb = 1). In the latter case the shared_info area at the end of the
first buffer will be properly initialized to link together subsequent
buffers.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 include/net/xdp.h | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/include/net/xdp.h b/include/net/xdp.h
index c4bfdc9a8b79..945767813fdd 100644
--- a/include/net/xdp.h
+++ b/include/net/xdp.h
@@ -73,7 +73,8 @@ struct xdp_buff {
 	void *data_hard_start;
 	struct xdp_rxq_info *rxq;
 	struct xdp_txq_info *txq;
-	u32 frame_sz; /* frame size to deduce data_hard_end/reserved tailroom*/
+	u32 frame_sz:31; /* frame size to deduce data_hard_end/reserved tailroom*/
+	u32 mb:1; /* xdp non-linear buffer */
 };
 
 static __always_inline void
@@ -81,6 +82,7 @@ xdp_init_buff(struct xdp_buff *xdp, u32 frame_sz, struct xdp_rxq_info *rxq)
 {
 	xdp->frame_sz = frame_sz;
 	xdp->rxq = rxq;
+	xdp->mb = 0;
 }
 
 static __always_inline void
@@ -116,7 +118,8 @@ struct xdp_frame {
 	u16 len;
 	u16 headroom;
 	u32 metasize:8;
-	u32 frame_sz:24;
+	u32 frame_sz:23;
+	u32 mb:1; /* xdp non-linear frame */
 	/* Lifetime of xdp_rxq_info is limited to NAPI/enqueue time,
 	 * while mem info is valid on remote CPU.
 	 */
@@ -178,6 +181,7 @@ void xdp_convert_frame_to_buff(struct xdp_frame *frame, struct xdp_buff *xdp)
 	xdp->data_end = frame->data + frame->len;
 	xdp->data_meta = frame->data - frame->metasize;
 	xdp->frame_sz = frame->frame_sz;
+	xdp->mb = frame->mb;
 }
 
 static inline
@@ -204,6 +208,7 @@ int xdp_update_frame_from_buff(struct xdp_buff *xdp,
 	xdp_frame->headroom = headroom - sizeof(*xdp_frame);
 	xdp_frame->metasize = metasize;
 	xdp_frame->frame_sz = xdp->frame_sz;
+	xdp_frame->mb = xdp->mb;
 
 	return 0;
 }
-- 
2.29.2

