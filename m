Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDAE62F8AE5
	for <lists+netdev@lfdr.de>; Sat, 16 Jan 2021 04:02:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729456AbhAPDAo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 22:00:44 -0500
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:45633 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729094AbhAPDAn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 22:00:43 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=19;SR=0;TI=SMTPD_---0ULr8-ZI_1610765968;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0ULr8-ZI_1610765968)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sat, 16 Jan 2021 10:59:29 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     netdev@vger.kernel.org
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org
Subject: [PATCH net-next v2 2/7] virtio-net, xsk: distinguish XDP_TX and XSK XMIT ctx
Date:   Sat, 16 Jan 2021 10:59:23 +0800
Message-Id: <27006309ce40fe3f5375b44d4afaae39ed550855.1610765285.git.xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <cover.1610765285.git.xuanzhuo@linux.alibaba.com>
References: <cover.1609837120.git.xuanzhuo@linux.alibaba.com>
 <cover.1610765285.git.xuanzhuo@linux.alibaba.com>
In-Reply-To: <cover.1610765285.git.xuanzhuo@linux.alibaba.com>
References: <cover.1610765285.git.xuanzhuo@linux.alibaba.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If support xsk, a new ptr will be recovered during the
process of freeing the old ptr. In order to distinguish between ctx sent
by XDP_TX and ctx sent by xsk, a struct is added here to distinguish
between these two situations. virtnet_xdp_type.type It is used to
distinguish different ctx, and virtnet_xdp_type.offset is used to record
the offset between "true ctx" and virtnet_xdp_type.

The newly added virtnet_xsk_hdr will be used for xsk.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 drivers/net/virtio_net.c | 75 ++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 60 insertions(+), 15 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index ba8e637..e707c31 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -94,6 +94,22 @@ struct virtnet_rq_stats {
 	u64 kicks;
 };
 
+enum {
+	XDP_TYPE_XSK,
+	XDP_TYPE_TX,
+};
+
+struct virtnet_xdp_type {
+	int offset:24;
+	unsigned type:8;
+};
+
+struct virtnet_xsk_hdr {
+	struct virtnet_xdp_type type;
+	struct virtio_net_hdr_mrg_rxbuf hdr;
+	u32 len;
+};
+
 #define VIRTNET_SQ_STAT(m)	offsetof(struct virtnet_sq_stats, m)
 #define VIRTNET_RQ_STAT(m)	offsetof(struct virtnet_rq_stats, m)
 
@@ -251,14 +267,19 @@ static bool is_xdp_frame(void *ptr)
 	return (unsigned long)ptr & VIRTIO_XDP_FLAG;
 }
 
-static void *xdp_to_ptr(struct xdp_frame *ptr)
+static void *xdp_to_ptr(struct virtnet_xdp_type *ptr)
 {
 	return (void *)((unsigned long)ptr | VIRTIO_XDP_FLAG);
 }
 
-static struct xdp_frame *ptr_to_xdp(void *ptr)
+static struct virtnet_xdp_type *ptr_to_xtype(void *ptr)
+{
+	return (struct virtnet_xdp_type *)((unsigned long)ptr & ~VIRTIO_XDP_FLAG);
+}
+
+static void *xtype_get_ptr(struct virtnet_xdp_type *xdptype)
 {
-	return (struct xdp_frame *)((unsigned long)ptr & ~VIRTIO_XDP_FLAG);
+	return (char *)xdptype + xdptype->offset;
 }
 
 /* Converting between virtqueue no. and kernel tx/rx queue no.
@@ -459,11 +480,16 @@ static int __virtnet_xdp_xmit_one(struct virtnet_info *vi,
 				   struct xdp_frame *xdpf)
 {
 	struct virtio_net_hdr_mrg_rxbuf *hdr;
+	struct virtnet_xdp_type *xdptype;
 	int err;
 
-	if (unlikely(xdpf->headroom < vi->hdr_len))
+	if (unlikely(xdpf->headroom < vi->hdr_len + sizeof(*xdptype)))
 		return -EOVERFLOW;
 
+	xdptype = (struct virtnet_xdp_type *)(xdpf + 1);
+	xdptype->offset = (char *)xdpf - (char *)xdptype;
+	xdptype->type = XDP_TYPE_TX;
+
 	/* Make room for virtqueue hdr (also change xdpf->headroom?) */
 	xdpf->data -= vi->hdr_len;
 	/* Zero header and leave csum up to XDP layers */
@@ -473,7 +499,7 @@ static int __virtnet_xdp_xmit_one(struct virtnet_info *vi,
 
 	sg_init_one(sq->sg, xdpf->data, xdpf->len);
 
-	err = virtqueue_add_outbuf(sq->vq, sq->sg, 1, xdp_to_ptr(xdpf),
+	err = virtqueue_add_outbuf(sq->vq, sq->sg, 1, xdp_to_ptr(xdptype),
 				   GFP_ATOMIC);
 	if (unlikely(err))
 		return -ENOSPC; /* Caller handle free/refcnt */
@@ -523,8 +549,11 @@ static int virtnet_xdp_xmit(struct net_device *dev,
 	/* Free up any pending old buffers before queueing new ones. */
 	while ((ptr = virtqueue_get_buf(sq->vq, &len)) != NULL) {
 		if (likely(is_xdp_frame(ptr))) {
-			struct xdp_frame *frame = ptr_to_xdp(ptr);
+			struct virtnet_xdp_type *xtype;
+			struct xdp_frame *frame;
 
+			xtype = ptr_to_xtype(ptr);
+			frame = xtype_get_ptr(xtype);
 			bytes += frame->len;
 			xdp_return_frame(frame);
 		} else {
@@ -1373,24 +1402,34 @@ static int virtnet_receive(struct receive_queue *rq, int budget,
 
 static void free_old_xmit_skbs(struct send_queue *sq, bool in_napi)
 {
-	unsigned int len;
 	unsigned int packets = 0;
 	unsigned int bytes = 0;
-	void *ptr;
+	unsigned int len;
+	struct virtnet_xdp_type *xtype;
+	struct xdp_frame        *frame;
+	struct virtnet_xsk_hdr  *xskhdr;
+	struct sk_buff          *skb;
+	void                    *ptr;
 
 	while ((ptr = virtqueue_get_buf(sq->vq, &len)) != NULL) {
 		if (likely(!is_xdp_frame(ptr))) {
-			struct sk_buff *skb = ptr;
+			skb = ptr;
 
 			pr_debug("Sent skb %p\n", skb);
 
 			bytes += skb->len;
 			napi_consume_skb(skb, in_napi);
 		} else {
-			struct xdp_frame *frame = ptr_to_xdp(ptr);
+			xtype = ptr_to_xtype(ptr);
 
-			bytes += frame->len;
-			xdp_return_frame(frame);
+			if (xtype->type == XDP_TYPE_XSK) {
+				xskhdr = (struct virtnet_xsk_hdr *)xtype;
+				bytes += xskhdr->len;
+			} else {
+				frame = xtype_get_ptr(xtype);
+				xdp_return_frame(frame);
+				bytes += frame->len;
+			}
 		}
 		packets++;
 	}
@@ -2659,10 +2698,16 @@ static void free_unused_bufs(struct virtnet_info *vi)
 	for (i = 0; i < vi->max_queue_pairs; i++) {
 		struct virtqueue *vq = vi->sq[i].vq;
 		while ((buf = virtqueue_detach_unused_buf(vq)) != NULL) {
-			if (!is_xdp_frame(buf))
+			if (!is_xdp_frame(buf)) {
 				dev_kfree_skb(buf);
-			else
-				xdp_return_frame(ptr_to_xdp(buf));
+			} else {
+				struct virtnet_xdp_type *xtype;
+
+				xtype = ptr_to_xtype(buf);
+
+				if (xtype->type != XDP_TYPE_XSK)
+					xdp_return_frame(xtype_get_ptr(xtype));
+			}
 		}
 	}
 
-- 
1.8.3.1

