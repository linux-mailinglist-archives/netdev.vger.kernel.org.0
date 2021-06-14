Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB6AA3A6700
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 14:50:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233489AbhFNMwq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 08:52:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:43490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233450AbhFNMwp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Jun 2021 08:52:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 67A7761159;
        Mon, 14 Jun 2021 12:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623675042;
        bh=LdNTWLz70qNW6xggFZvWB1tvA8JIBpIoT454Talvfv0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bx2XsxMt0VTKYDjMFQr3xvKVNptG2ty4MQEf8MrBnn6O+jbihexYJWtZ6IBu/0enH
         PZFsbCXBYC/ytl6Pu+iwGB4MCXBfPwdaNVjAIMhKMLmfgVrT5pHJ5Cq0kZBxNX+MqN
         7pJbng0/xDkReey3JajvVuEUdyOdyQSIRQjVJ5ChvRcnfBscAXDADqkLbedFvPxkg9
         kLg1nMz9ASXmSDSOg3NHXCov39gUR0aoYKfYqP34tfNV6rhL7KKG71nJfjKznnhCdp
         7kobMn/FiIVwQn+DReGjd5vMj8C2CEGVcIly6NrlXR+qp2G602W5h37mdRfgV+dlB9
         c/AoltSUL+k6g==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        sameehj@amazon.com, john.fastabend@gmail.com, dsahern@kernel.org,
        brouer@redhat.com, echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com
Subject: [PATCH v9 bpf-next 02/14] xdp: introduce flags field in xdp_buff/xdp_frame
Date:   Mon, 14 Jun 2021 14:49:40 +0200
Message-Id: <1316f3ef2763ff4c02244fb726c61568c972514c.1623674025.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1623674025.git.lorenzo@kernel.org>
References: <cover.1623674025.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce flags field in xdp_frame/xdp_buffer data structure
to define additional buffer features. At the moment the only
supported buffer feature is multi-buffer bit (mb). Multi-buffer bit
is used to specify if this is a linear buffer (mb = 0) or a multi-buffer
frame (mb = 1). In the latter case the shared_info area at the end of
the first buffer will be properly initialized to link together
subsequent buffers.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 include/net/xdp.h | 31 ++++++++++++++++++++++++++++++-
 1 file changed, 30 insertions(+), 1 deletion(-)

diff --git a/include/net/xdp.h b/include/net/xdp.h
index 5533f0ab2afc..de11d981fa44 100644
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
@@ -117,13 +138,19 @@ struct xdp_frame {
 	u16 headroom;
 	u32 metasize:8;
 	u32 frame_sz:24;
+	struct net_device *dev_rx; /* used by cpumap */
 	/* Lifetime of xdp_rxq_info is limited to NAPI/enqueue time,
 	 * while mem info is valid on remote CPU.
 	 */
 	struct xdp_mem_info mem;
-	struct net_device *dev_rx; /* used by cpumap */
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

