Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07DF242F1C6
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 15:09:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239296AbhJONLl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 09:11:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:33076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235689AbhJONLl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Oct 2021 09:11:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CE18561151;
        Fri, 15 Oct 2021 13:09:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634303375;
        bh=OOwrzjwg5MbC4uyTQbcFiNJwyodtWvmko5GIuXdVkcs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fCqgo44Rm6z91Eeq6EDctuZDTjpozpNzIVm3UyLsPMI1DIrF89nbwZuni+2b4w9i5
         htl7dl7t2mMcWYvcZIjwbvZVezHJmP6HsZj/sizKIlxSegdcSNouz1XGY302x3AAOd
         azuQ6h/RYLA+wFVBV7oHfiTlk7GAHBN57Buup3sks80Yh4zEQDDq+FLR7et+mDukLo
         MqsGo8MHNrvKM/i01LCDU0Vylxp+gawswJd1ynFIPKNeR8JzMaxMSzj8EZher+ZRPU
         QVREn5kjIxDm0QOGR1JCAw2aEnDDXGJe1hS4Wb2gel4zZIqZvftz5l5JP4wZZuWAhP
         Pc1MnrobvV6Ww==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: [PATCH v16 bpf-next 02/20] xdp: introduce flags field in xdp_buff/xdp_frame
Date:   Fri, 15 Oct 2021 15:08:39 +0200
Message-Id: <e673be2ef6b3c5afccc6ed46d5553e74cd540496.1634301224.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1634301224.git.lorenzo@kernel.org>
References: <cover.1634301224.git.lorenzo@kernel.org>
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

