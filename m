Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41BB13946A1
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 19:44:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229543AbhE1Rpo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 13:45:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:46386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229488AbhE1Rpn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 May 2021 13:45:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E6B7B61175;
        Fri, 28 May 2021 17:44:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622223848;
        bh=X+iwczk3Ns0D1hfvBYSxHmdVFdtGvagusy5ToYnndXE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fOYhQ11gfcT6BONtbowIRR9ebwGuVIoX1XMAas/2ci3lDtdmd+siBeBfj7Lm3hgDg
         aIyjtYvRUImt0lGZvHwl25GwkFL3pZBsRplzD+zDhoVAh/jM3YvRj6KBFVlqVjDlwH
         Gq0DOGuN2yuAOC2DKbPRJ8W++ZXkXXcR+gAZS4isAsqgKlCHYcOUxEXvOw9Qk4rG2P
         +xU8KSd23rRBtrzD1UNIXYs4Drt42eNbMbf3cM4DGyFtDva1k1fdLWRLBP/vtYSXMV
         KjWTYoCupqCEEPDEQjy67MYUm/c059Kel6kopA7KfRUXo9eSm/7ihqY9euj3sP/UdO
         Hj51VTue0HQjA==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        daniel@iogearbox.net, ast@kernel.org, echaudro@redhat.com,
        dsahern@gmail.com, magnus.karlsson@intel.com, toke@redhat.com,
        brouer@redhat.com, bjorn@kernel.org, maciej.fijalkowski@intel.com,
        john.fastabend@gmail.com
Subject: [RFC bpf-next 1/4] net: xdp: introduce flags field in xdp_buff and xdp_frame
Date:   Fri, 28 May 2021 19:43:41 +0200
Message-Id: <b5b2f560006cf5f56d67d61d5837569a0949d0aa.1622222367.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1622222367.git.lorenzo@kernel.org>
References: <cover.1622222367.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce flag field in xdp_buff and xdp_frame data structure in order
to report xdp_buffer metadata. For the moment just hw checksum hints
are defined but flags field will be reused for xdp multi-buffer
For the moment just CHECKSUM_UNNECESSARY is supported.
CHECKSUM_COMPLETE will need to set csum value in metada space.

Co-developed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: David Ahern <dsahern@kernel.org>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 include/net/xdp.h | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/include/net/xdp.h b/include/net/xdp.h
index 5533f0ab2afc..e81ac505752b 100644
--- a/include/net/xdp.h
+++ b/include/net/xdp.h
@@ -66,6 +66,13 @@ struct xdp_txq_info {
 	struct net_device *dev;
 };
 
+/* xdp metadata bitmask */
+#define XDP_CSUM_MASK		GENMASK(1, 0)
+enum xdp_flags {
+	XDP_CSUM_UNNECESSARY	= BIT(0),
+	XDP_CSUM_COMPLETE	= BIT(1),
+};
+
 struct xdp_buff {
 	void *data;
 	void *data_end;
@@ -74,6 +81,7 @@ struct xdp_buff {
 	struct xdp_rxq_info *rxq;
 	struct xdp_txq_info *txq;
 	u32 frame_sz; /* frame size to deduce data_hard_end/reserved tailroom*/
+	u16 flags; /* xdp_flags */
 };
 
 static __always_inline void
@@ -81,6 +89,7 @@ xdp_init_buff(struct xdp_buff *xdp, u32 frame_sz, struct xdp_rxq_info *rxq)
 {
 	xdp->frame_sz = frame_sz;
 	xdp->rxq = rxq;
+	xdp->flags = 0;
 }
 
 static __always_inline void
@@ -95,6 +104,18 @@ xdp_prepare_buff(struct xdp_buff *xdp, unsigned char *hard_start,
 	xdp->data_meta = meta_valid ? data : data + 1;
 }
 
+static __always_inline void
+xdp_buff_get_csum(struct xdp_buff *xdp, struct sk_buff *skb)
+{
+	switch (xdp->flags & XDP_CSUM_MASK) {
+	case XDP_CSUM_UNNECESSARY:
+		skb->ip_summed = CHECKSUM_UNNECESSARY;
+		break;
+	default:
+		break;
+	}
+}
+
 /* Reserve memory area at end-of data area.
  *
  * This macro reserves tailroom in the XDP buffer by limiting the
@@ -122,8 +143,21 @@ struct xdp_frame {
 	 */
 	struct xdp_mem_info mem;
 	struct net_device *dev_rx; /* used by cpumap */
+	u16 flags; /* xdp_flags */
 };
 
+static __always_inline void
+xdp_frame_get_csum(struct xdp_frame *xdpf, struct sk_buff *skb)
+{
+	switch (xdpf->flags & XDP_CSUM_MASK) {
+	case XDP_CSUM_UNNECESSARY:
+		skb->ip_summed = CHECKSUM_UNNECESSARY;
+		break;
+	default:
+		break;
+	}
+}
+
 #define XDP_BULK_QUEUE_SIZE	16
 struct xdp_frame_bulk {
 	int count;
@@ -180,6 +214,7 @@ void xdp_convert_frame_to_buff(struct xdp_frame *frame, struct xdp_buff *xdp)
 	xdp->data_end = frame->data + frame->len;
 	xdp->data_meta = frame->data - frame->metasize;
 	xdp->frame_sz = frame->frame_sz;
+	xdp->flags = frame->flags;
 }
 
 static inline
@@ -206,6 +241,7 @@ int xdp_update_frame_from_buff(struct xdp_buff *xdp,
 	xdp_frame->headroom = headroom - sizeof(*xdp_frame);
 	xdp_frame->metasize = metasize;
 	xdp_frame->frame_sz = xdp->frame_sz;
+	xdp_frame->flags = xdp->flags;
 
 	return 0;
 }
-- 
2.31.1

