Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5661E2EA70C
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 10:13:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727800AbhAEJMf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 04:12:35 -0500
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:42207 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727657AbhAEJMd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 04:12:33 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=22;SR=0;TI=SMTPD_---0UKoYpdO_1609837908;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0UKoYpdO_1609837908)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 05 Jan 2021 17:11:49 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     netdev@vger.kernel.org
Cc:     dust.li@linux.alibaba.com, tonylu@linux.alibaba.com,
        "Michael S. Tsirkin" <mst@redhat.com>,
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
        virtualization@lists.linux-foundation.org (open list:VIRTIO CORE AND
        NET DRIVERS), linux-kernel@vger.kernel.org (open list),
        bpf@vger.kernel.org (open list:XDP SOCKETS (AF_XDP))
Subject: [PATCH netdev 4/5] xsk, virtio-net: prepare for support xsk
Date:   Tue,  5 Jan 2021 17:11:42 +0800
Message-Id: <4c424e0980420dfff194a9d1c8e66609b2fa6cba.1609837120.git.xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <cover.1609837120.git.xuanzhuo@linux.alibaba.com>
References: <cover.1609837120.git.xuanzhuo@linux.alibaba.com>
In-Reply-To: <cover.1609837120.git.xuanzhuo@linux.alibaba.com>
References: <cover.1609837120.git.xuanzhuo@linux.alibaba.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Split function free_old_xmit_skbs, add sub-function __free_old_xmit_ptr,
which is convenient to call with other statistical information, and
supports the parameter 'xsk_wakeup' required for processing xsk.

Use netif stop check as a function virtnet_sq_stop_check, which will be
used when adding xsk support.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 drivers/net/virtio_net.c | 95 ++++++++++++++++++++++++++----------------------
 1 file changed, 52 insertions(+), 43 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index df38a9f..e744dce 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -263,6 +263,11 @@ struct padded_vnet_hdr {
 	char padding[4];
 };
 
+static void __free_old_xmit_ptr(struct send_queue *sq, bool in_napi,
+				bool xsk_wakeup,
+				unsigned int *_packets, unsigned int *_bytes);
+static void free_old_xmit_skbs(struct send_queue *sq, bool in_napi);
+
 static bool is_xdp_frame(void *ptr)
 {
 	return (unsigned long)ptr & VIRTIO_XDP_FLAG;
@@ -376,6 +381,37 @@ static void skb_xmit_done(struct virtqueue *vq)
 		netif_wake_subqueue(vi->dev, vq2txq(vq));
 }
 
+static void virtnet_sq_stop_check(struct send_queue *sq, bool in_napi)
+{
+	struct virtnet_info *vi = sq->vq->vdev->priv;
+	struct net_device *dev = vi->dev;
+	int qnum = sq - vi->sq;
+
+	/* If running out of space, stop queue to avoid getting packets that we
+	 * are then unable to transmit.
+	 * An alternative would be to force queuing layer to requeue the skb by
+	 * returning NETDEV_TX_BUSY. However, NETDEV_TX_BUSY should not be
+	 * returned in a normal path of operation: it means that driver is not
+	 * maintaining the TX queue stop/start state properly, and causes
+	 * the stack to do a non-trivial amount of useless work.
+	 * Since most packets only take 1 or 2 ring slots, stopping the queue
+	 * early means 16 slots are typically wasted.
+	 */
+
+	if (sq->vq->num_free < 2 + MAX_SKB_FRAGS) {
+		netif_stop_subqueue(dev, qnum);
+		if (!sq->napi.weight &&
+		    unlikely(!virtqueue_enable_cb_delayed(sq->vq))) {
+			/* More just got used, free them then recheck. */
+			free_old_xmit_skbs(sq, in_napi);
+			if (sq->vq->num_free >= 2 + MAX_SKB_FRAGS) {
+				netif_start_subqueue(dev, qnum);
+				virtqueue_disable_cb(sq->vq);
+			}
+		}
+	}
+}
+
 #define MRG_CTX_HEADER_SHIFT 22
 static void *mergeable_len_to_ctx(unsigned int truesize,
 				  unsigned int headroom)
@@ -543,13 +579,11 @@ static int virtnet_xdp_xmit(struct net_device *dev,
 	struct receive_queue *rq = vi->rq;
 	struct bpf_prog *xdp_prog;
 	struct send_queue *sq;
-	unsigned int len;
 	int packets = 0;
 	int bytes = 0;
 	int drops = 0;
 	int kicks = 0;
 	int ret, err;
-	void *ptr;
 	int i;
 
 	/* Only allow ndo_xdp_xmit if XDP is loaded on dev, as this
@@ -567,24 +601,7 @@ static int virtnet_xdp_xmit(struct net_device *dev,
 		goto out;
 	}
 
-	/* Free up any pending old buffers before queueing new ones. */
-	while ((ptr = virtqueue_get_buf(sq->vq, &len)) != NULL) {
-		if (likely(is_xdp_frame(ptr))) {
-			struct virtnet_xdp_type *xtype;
-			struct xdp_frame *frame;
-
-			xtype = ptr_to_xtype(ptr);
-			frame = xtype_got_ptr(xtype);
-			bytes += frame->len;
-			xdp_return_frame(frame);
-		} else {
-			struct sk_buff *skb = ptr;
-
-			bytes += skb->len;
-			napi_consume_skb(skb, false);
-		}
-		packets++;
-	}
+	__free_old_xmit_ptr(sq, false, true, &packets, &bytes);
 
 	for (i = 0; i < n; i++) {
 		struct xdp_frame *xdpf = frames[i];
@@ -1422,7 +1439,9 @@ static int virtnet_receive(struct receive_queue *rq, int budget,
 	return stats.packets;
 }
 
-static void free_old_xmit_skbs(struct send_queue *sq, bool in_napi)
+static void __free_old_xmit_ptr(struct send_queue *sq, bool in_napi,
+				bool xsk_wakeup,
+				unsigned int *_packets, unsigned int *_bytes)
 {
 	unsigned int packets = 0;
 	unsigned int bytes = 0;
@@ -1456,6 +1475,17 @@ static void free_old_xmit_skbs(struct send_queue *sq, bool in_napi)
 		packets++;
 	}
 
+	*_packets = packets;
+	*_bytes = bytes;
+}
+
+static void free_old_xmit_skbs(struct send_queue *sq, bool in_napi)
+{
+	unsigned int packets = 0;
+	unsigned int bytes = 0;
+
+	__free_old_xmit_ptr(sq, in_napi, true, &packets, &bytes);
+
 	/* Avoid overhead when no packets have been processed
 	 * happens when called speculatively from start_xmit.
 	 */
@@ -1672,28 +1702,7 @@ static netdev_tx_t start_xmit(struct sk_buff *skb, struct net_device *dev)
 		nf_reset_ct(skb);
 	}
 
-	/* If running out of space, stop queue to avoid getting packets that we
-	 * are then unable to transmit.
-	 * An alternative would be to force queuing layer to requeue the skb by
-	 * returning NETDEV_TX_BUSY. However, NETDEV_TX_BUSY should not be
-	 * returned in a normal path of operation: it means that driver is not
-	 * maintaining the TX queue stop/start state properly, and causes
-	 * the stack to do a non-trivial amount of useless work.
-	 * Since most packets only take 1 or 2 ring slots, stopping the queue
-	 * early means 16 slots are typically wasted.
-	 */
-	if (sq->vq->num_free < 2+MAX_SKB_FRAGS) {
-		netif_stop_subqueue(dev, qnum);
-		if (!use_napi &&
-		    unlikely(!virtqueue_enable_cb_delayed(sq->vq))) {
-			/* More just got used, free them then recheck. */
-			free_old_xmit_skbs(sq, false);
-			if (sq->vq->num_free >= 2+MAX_SKB_FRAGS) {
-				netif_start_subqueue(dev, qnum);
-				virtqueue_disable_cb(sq->vq);
-			}
-		}
-	}
+	virtnet_sq_stop_check(sq, false);
 
 	if (kick || netif_xmit_stopped(txq)) {
 		if (virtqueue_kick_prepare(sq->vq) && virtqueue_notify(sq->vq)) {
-- 
1.8.3.1

