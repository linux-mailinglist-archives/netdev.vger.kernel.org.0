Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD4D344588D
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 18:36:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233902AbhKDRir (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 13:38:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:48004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231667AbhKDRiq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Nov 2021 13:38:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C0AEA61221;
        Thu,  4 Nov 2021 17:36:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636047367;
        bh=OOwrzjwg5MbC4uyTQbcFiNJwyodtWvmko5GIuXdVkcs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f2PFLzRVJyarjcTSASLtU16L3W321TQvVbJU8Au6sM0nhdFqvwG3AcqHfsvm/wrRL
         xsUAUZJ1oC1Pzvup5SdSYQp7qNx1RZ+pDx3nLcCR24DAzqiR4ZPWPt3VHaOdC5ZMSk
         J0dOVswi1qxLV7xXtF0TMS021N16Tv715q1p1OrqWkkwqe+rBzRM0n+Jhs0WBgCAH1
         YLA4lBOHbwu2meHjQMoWJtTa1b7WLoErm7OceoTtkpvx65gfgqf5KRi3ymO1F9NtqP
         7CFdKiSHxJ8d2rXAdDa+vbTokZMUUrSNIevZqP1xEzsFgmN10pQnSFKhxO3E0iJUkI
         kFK0gsh12+nig==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: [PATCH v17 bpf-next 02/23] xdp: introduce flags field in xdp_buff/xdp_frame
Date:   Thu,  4 Nov 2021 18:35:22 +0100
Message-Id: <1b1fa2fa5533e785a50678711a9a09bf707fe0ed.1636044387.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1636044387.git.lorenzo@kernel.org>
References: <cover.1636044387.git.lorenzo@kernel.org>
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
2.31.1

