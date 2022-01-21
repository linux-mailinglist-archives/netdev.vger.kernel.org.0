Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 302EE495D55
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 11:11:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379886AbiAUKLH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 05:11:07 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:57208 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379869AbiAUKKv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 05:10:51 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 48E49B81ED6;
        Fri, 21 Jan 2022 10:10:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0046DC340E2;
        Fri, 21 Jan 2022 10:10:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642759849;
        bh=Ka6iJ6LcVD7/GxQy5xz8JGjcmEVTuC0VyuGMWy2m6Vw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ewLSuGnS+TBnPmYULMOFbhSCdastunrphvr2zNkl1Ai3plb+R+/Rg8fSZkbx80dPk
         +9gVdLRRUvNLWRAWEyMCJPPTontCFna6+9vpbt/e001qEzGakglJ6uFRKMuktFj5nu
         JmC2nhv/CJduHBwhxfqBXIofc8qkp2L26rcld6AanUXdciqvlSoqEKi3x33Pq+mZLe
         K6DQGS5RR+JQpIJaItSQR1hhTN1hqANaTKfJSJOp48YsUKn+SgCdwumJWZglr/mrCU
         iUEEPiPKRT+8rjWn35TztHBiha9IorkOrZrNrDQbj7hrVgotbeiU0O5QdggbhH7uFp
         ncShRoSAVKmHA==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com,
        andrii.nakryiko@gmail.com
Subject: [PATCH v23 bpf-next 02/23] xdp: introduce flags field in xdp_buff/xdp_frame
Date:   Fri, 21 Jan 2022 11:09:45 +0100
Message-Id: <e389f14f3a162c0a5bc6a2e1aa8dd01a90be117d.1642758637.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1642758637.git.lorenzo@kernel.org>
References: <cover.1642758637.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce flags field in xdp_frame and xdp_buffer data structures
to define additional buffer features. At the moment the only
supported buffer feature is frags bit (XDP_FLAGS_HAS_FRAGS).
frags bit is used to specify if this is a linear buffer
(XDP_FLAGS_HAS_FRAGS not set) or a frags frame (XDP_FLAGS_HAS_FRAGS
set). In the latter case the driver is expected to initialize the
skb_shared_info structure at the end of the first buffer to link together
subsequent buffers belonging to the same frame.

Acked-by: Toke Hoiland-Jorgensen <toke@redhat.com>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 include/net/xdp.h | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/include/net/xdp.h b/include/net/xdp.h
index 8f0812e4996d..485e9495a690 100644
--- a/include/net/xdp.h
+++ b/include/net/xdp.h
@@ -66,6 +66,10 @@ struct xdp_txq_info {
 	struct net_device *dev;
 };
 
+enum xdp_buff_flags {
+	XDP_FLAGS_HAS_FRAGS	= BIT(0), /* non-linear xdp buff */
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
 
+static __always_inline bool xdp_buff_has_frags(struct xdp_buff *xdp)
+{
+	return !!(xdp->flags & XDP_FLAGS_HAS_FRAGS);
+}
+
+static __always_inline void xdp_buff_set_frags_flag(struct xdp_buff *xdp)
+{
+	xdp->flags |= XDP_FLAGS_HAS_FRAGS;
+}
+
+static __always_inline void xdp_buff_clear_frags_flag(struct xdp_buff *xdp)
+{
+	xdp->flags &= ~XDP_FLAGS_HAS_FRAGS;
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
 
+static __always_inline bool xdp_frame_has_frags(struct xdp_frame *frame)
+{
+	return !!(frame->flags & XDP_FLAGS_HAS_FRAGS);
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
2.34.1

