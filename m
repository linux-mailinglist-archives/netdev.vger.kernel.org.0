Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE7E3470A07
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 20:15:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245439AbhLJTSu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 14:18:50 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:59410 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242586AbhLJTSt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 14:18:49 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6321FCE2D2C;
        Fri, 10 Dec 2021 19:15:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B55C6C341CD;
        Fri, 10 Dec 2021 19:15:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639163710;
        bh=QvnuVKxABbsfcsqq5gYkLenL+NtO0kaofu4dZ15jpC0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=edz3Tb50VbL9TlGkqvvzCErdZ0wXx4q5ROfHzOIKjSRcLh0HmtUg9xugk2S+VkQ7u
         bOv6w7AHrVPvXwQ3qq+dIdDXvkBigrLMYoodc0XMV9yRiWe0mIe7cnWnHomsSeUg5Z
         Ew39tfJJFR9LGOMknsXymNZkgh30d7de9oF0hoI3OaI6vHbrGym2WbW+yS4i6876pq
         MCMc6kxht0tuCqJDV91CV1HYDP1LDTrlMhaDzqrrw0wl2QRv1xs3SXyIZn+x2OcHWp
         8R3r3Ia0fOmXKZl0PeQ17RN6SPS0rfPsboD3PYjn4h3kEnPQFHNPa549Hgr0+ywivT
         P4LlGpQvjiZFA==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: [PATCH v20 bpf-next 02/23] xdp: introduce flags field in xdp_buff/xdp_frame
Date:   Fri, 10 Dec 2021 20:14:09 +0100
Message-Id: <a2d718fc78c9dab89a2150ec1075e537eadc2942.1639162845.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1639162845.git.lorenzo@kernel.org>
References: <cover.1639162845.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce flags field in xdp_frame and xdp_buffer data structures
to define additional buffer features. At the moment the only
supported buffer feature is multi-buffer bit (mb). Multi-buffer bit
is used to specify if this is a linear buffer (mb = 0) or a multi-buffer
frame (mb = 1). In the latter case the driver is expected to initialize
the skb_shared_info structure at the end of the first buffer to link
together subsequent buffers belonging to the same frame.

Acked-by: John Fastabend <john.fastabend@gmail.com>
Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 include/net/xdp.h | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/include/net/xdp.h b/include/net/xdp.h
index 447f9b1578f3..4ec7bdf0d937 100644
--- a/include/net/xdp.h
+++ b/include/net/xdp.h
@@ -66,6 +66,10 @@ struct xdp_txq_info {
 	struct net_device *dev;
 };
 
+enum xdp_buff_flags {
+	XDP_FLAGS_MULTI_BUFF	= BIT(0), /* non-linear xdp buff */
+};
+
 struct xdp_buff {
 	void *data;
 	void *data_end;
@@ -74,13 +78,30 @@ struct xdp_buff {
 	struct xdp_rxq_info *rxq;
 	struct xdp_txq_info *txq;
 	u32 frame_sz; /* frame size to deduce data_hard_end/reserved tailroom*/
+	u32 flags; /* supported values defined in xdp_buff_flags */
 };
 
+static __always_inline bool xdp_buff_is_mb(struct xdp_buff *xdp)
+{
+	return !!(xdp->flags & XDP_FLAGS_MULTI_BUFF);
+}
+
+static __always_inline void xdp_buff_set_mb(struct xdp_buff *xdp)
+{
+	xdp->flags |= XDP_FLAGS_MULTI_BUFF;
+}
+
+static __always_inline void xdp_buff_clear_mb(struct xdp_buff *xdp)
+{
+	xdp->flags &= ~XDP_FLAGS_MULTI_BUFF;
+}
+
 static __always_inline void
 xdp_init_buff(struct xdp_buff *xdp, u32 frame_sz, struct xdp_rxq_info *rxq)
 {
 	xdp->frame_sz = frame_sz;
 	xdp->rxq = rxq;
+	xdp->flags = 0;
 }
 
 static __always_inline void
@@ -122,8 +143,14 @@ struct xdp_frame {
 	 */
 	struct xdp_mem_info mem;
 	struct net_device *dev_rx; /* used by cpumap */
+	u32 flags; /* supported values defined in xdp_buff_flags */
 };
 
+static __always_inline bool xdp_frame_is_mb(struct xdp_frame *frame)
+{
+	return !!(frame->flags & XDP_FLAGS_MULTI_BUFF);
+}
+
 #define XDP_BULK_QUEUE_SIZE	16
 struct xdp_frame_bulk {
 	int count;
@@ -180,6 +207,7 @@ void xdp_convert_frame_to_buff(struct xdp_frame *frame, struct xdp_buff *xdp)
 	xdp->data_end = frame->data + frame->len;
 	xdp->data_meta = frame->data - frame->metasize;
 	xdp->frame_sz = frame->frame_sz;
+	xdp->flags = frame->flags;
 }
 
 static inline
@@ -206,6 +234,7 @@ int xdp_update_frame_from_buff(struct xdp_buff *xdp,
 	xdp_frame->headroom = headroom - sizeof(*xdp_frame);
 	xdp_frame->metasize = metasize;
 	xdp_frame->frame_sz = xdp->frame_sz;
+	xdp_frame->flags = xdp->flags;
 
 	return 0;
 }
-- 
2.33.1

