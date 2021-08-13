Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06A813EB4B7
	for <lists+netdev@lfdr.de>; Fri, 13 Aug 2021 13:49:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240163AbhHMLtv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 07:49:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:44596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238500AbhHMLtv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Aug 2021 07:49:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9563061038;
        Fri, 13 Aug 2021 11:49:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628855364;
        bh=7rec31JTsnV/0vJfrcV5ZsizOBgtcA3Ty6UT24MBJtg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WkoQLYUyjllaTO1QBdtInyS4jEdkrFLNrBMR9L/jiD29ZgGs4y+CrWE8TrpWLVCoB
         cjbY+EhV2x8qt9s3EY32i2a2idB3imGfmhxBOcDuH2Kky5jClVrBBIgltm3fzLCzhm
         BvkuPiztHqoMHlaWFfY/feTwNTZZuFRwiqWXPWV24GZ3dm6mHo+eQ3bzGfu/z8X3Ff
         LEf2oQoZ7Oa2e4NDfWZd/YZkT4wl/nJmxjXrlI6j2Vh3T36VVM6/Vr5FkemXIfoklb
         0EgqoqSQM3Lb6Y2e8QnePMukHttd4SEJWuc7DCAIkiZz1RCQ422wiXJHuoHFMAYy5X
         VceUrkem3lCgg==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: [PATCH v11 bpf-next 02/18] xdp: introduce flags field in xdp_buff/xdp_frame
Date:   Fri, 13 Aug 2021 13:47:43 +0200
Message-Id: <8d67d8e7971fcc1ef48a8d5951f666481ccaa9af.1628854454.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1628854454.git.lorenzo@kernel.org>
References: <cover.1628854454.git.lorenzo@kernel.org>
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

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 include/net/xdp.h | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/include/net/xdp.h b/include/net/xdp.h
index ad5b02dcb6f4..ed5ea784fd45 100644
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
+	u16 flags; /* supported values defined in xdp_flags */
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
+	u16 flags; /* supported values defined in xdp_flags */
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

