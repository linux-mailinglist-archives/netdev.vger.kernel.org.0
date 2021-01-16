Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DF582F8AE9
	for <lists+netdev@lfdr.de>; Sat, 16 Jan 2021 04:02:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729496AbhAPDBQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 22:01:16 -0500
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:50105 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728644AbhAPDBQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 22:01:16 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=19;SR=0;TI=SMTPD_---0ULrQCaD_1610765971;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0ULrQCaD_1610765971)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sat, 16 Jan 2021 10:59:31 +0800
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
Subject: [PATCH net-next v2 7/7] virtio-net, xsk: set xsk completed when packet sent done
Date:   Sat, 16 Jan 2021 10:59:28 +0800
Message-Id: <4949b7afe1420cfdedd890f77335fa9554f774cf.1610765285.git.xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <cover.1610765285.git.xuanzhuo@linux.alibaba.com>
References: <cover.1609837120.git.xuanzhuo@linux.alibaba.com>
 <cover.1610765285.git.xuanzhuo@linux.alibaba.com>
In-Reply-To: <cover.1610765285.git.xuanzhuo@linux.alibaba.com>
References: <cover.1610765285.git.xuanzhuo@linux.alibaba.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When recycling packets that have been sent, call xsk_tx_completed to
inform xsk which packets have been sent.

If necessary, start napi to process the packets in the xsk queue.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 drivers/net/virtio_net.c | 49 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 49 insertions(+)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index e552c2d..d0d620b 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -1442,6 +1442,42 @@ static int virtnet_receive(struct receive_queue *rq, int budget,
 	return stats.packets;
 }
 
+static void virt_xsk_complete(struct send_queue *sq, u32 num, bool xsk_wakeup)
+{
+	struct xsk_buff_pool *pool;
+	struct virtnet_xsk_hdr *hdr = NULL;
+	int n;
+
+	rcu_read_lock();
+
+	sq->xsk.hdr_pro += num;
+
+	pool = rcu_dereference(sq->xsk.pool);
+	if (!pool) {
+		if (sq->xsk.hdr_pro - sq->xsk.hdr_con == sq->xsk.hdr_n)
+			hdr = rcu_replace_pointer(sq->xsk.hdr, hdr, true);
+
+		rcu_read_unlock();
+
+		kfree(hdr);
+		return;
+	}
+
+	xsk_tx_completed(pool, num);
+
+	rcu_read_unlock();
+
+	if (!xsk_wakeup || !sq->xsk.wait_slot)
+		return;
+
+	n = sq->xsk.hdr_pro - sq->xsk.hdr_con;
+
+	if (n > sq->xsk.hdr_n / 2) {
+		sq->xsk.wait_slot = false;
+		virtqueue_napi_schedule(&sq->napi, sq->vq);
+	}
+}
+
 static void __free_old_xmit_ptr(struct send_queue *sq, bool in_napi,
 				bool xsk_wakeup,
 				unsigned int *_packets, unsigned int *_bytes)
@@ -1449,6 +1485,7 @@ static void __free_old_xmit_ptr(struct send_queue *sq, bool in_napi,
 	unsigned int packets = 0;
 	unsigned int bytes = 0;
 	unsigned int len;
+	u64 xsknum = 0;
 	struct virtnet_xdp_type *xtype;
 	struct xdp_frame        *frame;
 	struct virtnet_xsk_hdr  *xskhdr;
@@ -1469,6 +1506,7 @@ static void __free_old_xmit_ptr(struct send_queue *sq, bool in_napi,
 			if (xtype->type == XDP_TYPE_XSK) {
 				xskhdr = (struct virtnet_xsk_hdr *)xtype;
 				bytes += xskhdr->len;
+				xsknum += 1;
 			} else {
 				frame = xtype_get_ptr(xtype);
 				xdp_return_frame(frame);
@@ -1478,6 +1516,9 @@ static void __free_old_xmit_ptr(struct send_queue *sq, bool in_napi,
 		packets++;
 	}
 
+	if (xsknum)
+		virt_xsk_complete(sq, xsknum, xsk_wakeup);
+
 	*_packets = packets;
 	*_bytes = bytes;
 }
@@ -3044,10 +3085,13 @@ static void free_receive_page_frags(struct virtnet_info *vi)
 static void free_unused_bufs(struct virtnet_info *vi)
 {
 	void *buf;
+	u32 n;
 	int i;
+	struct send_queue *sq;
 
 	for (i = 0; i < vi->max_queue_pairs; i++) {
 		struct virtqueue *vq = vi->sq[i].vq;
+		sq = vi->sq + i;
 		while ((buf = virtqueue_detach_unused_buf(vq)) != NULL) {
 			if (!is_xdp_frame(buf)) {
 				dev_kfree_skb(buf);
@@ -3060,6 +3104,11 @@ static void free_unused_bufs(struct virtnet_info *vi)
 					xdp_return_frame(xtype_get_ptr(xtype));
 			}
 		}
+
+		n = sq->xsk.hdr_con + sq->xsk.hdr_n;
+		n -= sq->xsk.hdr_pro;
+		if (n)
+			virt_xsk_complete(sq, n, false);
 	}
 
 	for (i = 0; i < vi->max_queue_pairs; i++) {
-- 
1.8.3.1

