Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 839083A26D1
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 10:23:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231209AbhFJIZF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 04:25:05 -0400
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:39431 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231166AbhFJIYs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 04:24:48 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R521e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=21;SR=0;TI=SMTPD_---0UbxH89Y_1623313332;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0UbxH89Y_1623313332)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 10 Jun 2021 16:22:12 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
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
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org,
        "dust . li" <dust.li@linux.alibaba.com>
Subject: [PATCH net-next v5 07/15] virtio-net: standalone virtnet_aloc_frag function
Date:   Thu, 10 Jun 2021 16:22:01 +0800
Message-Id: <20210610082209.91487-8-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210610082209.91487-1-xuanzhuo@linux.alibaba.com>
References: <20210610082209.91487-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This logic is used by small and merge when adding buf, and the
subsequent patch will also use this logic, so it is separated as an
independent function.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 drivers/net/virtio_net.c | 29 ++++++++++++++++++++---------
 1 file changed, 20 insertions(+), 9 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index d791543a8dd8..3fd87bf2b2ad 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -264,6 +264,22 @@ static struct xdp_frame *ptr_to_xdp(void *ptr)
 	return (struct xdp_frame *)((unsigned long)ptr & ~VIRTIO_XDP_FLAG);
 }
 
+static char *virtnet_alloc_frag(struct receive_queue *rq, unsigned int len,
+				int gfp)
+{
+	struct page_frag *alloc_frag = &rq->alloc_frag;
+	char *buf;
+
+	if (unlikely(!skb_page_frag_refill(len, alloc_frag, gfp)))
+		return NULL;
+
+	buf = (char *)page_address(alloc_frag->page) + alloc_frag->offset;
+	get_page(alloc_frag->page);
+	alloc_frag->offset += len;
+
+	return buf;
+}
+
 static void __free_old_xmit(struct send_queue *sq, bool in_napi,
 			    struct virtnet_sq_stats *stats)
 {
@@ -1190,7 +1206,6 @@ static void receive_buf(struct virtnet_info *vi, struct receive_queue *rq,
 static int add_recvbuf_small(struct virtnet_info *vi, struct receive_queue *rq,
 			     gfp_t gfp)
 {
-	struct page_frag *alloc_frag = &rq->alloc_frag;
 	char *buf;
 	unsigned int xdp_headroom = virtnet_get_headroom(vi);
 	void *ctx = (void *)(unsigned long)xdp_headroom;
@@ -1199,12 +1214,10 @@ static int add_recvbuf_small(struct virtnet_info *vi, struct receive_queue *rq,
 
 	len = SKB_DATA_ALIGN(len) +
 	      SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
-	if (unlikely(!skb_page_frag_refill(len, alloc_frag, gfp)))
+	buf = virtnet_alloc_frag(rq, len, gfp);
+	if (unlikely(!buf))
 		return -ENOMEM;
 
-	buf = (char *)page_address(alloc_frag->page) + alloc_frag->offset;
-	get_page(alloc_frag->page);
-	alloc_frag->offset += len;
 	sg_init_one(rq->sg, buf + VIRTNET_RX_PAD + xdp_headroom,
 		    vi->hdr_len + GOOD_PACKET_LEN);
 	err = virtqueue_add_inbuf_ctx(rq->vq, rq->sg, 1, buf, ctx, gfp);
@@ -1295,13 +1308,11 @@ static int add_recvbuf_mergeable(struct virtnet_info *vi,
 	 * disabled GSO for XDP, it won't be a big issue.
 	 */
 	len = get_mergeable_buf_len(rq, &rq->mrg_avg_pkt_len, room);
-	if (unlikely(!skb_page_frag_refill(len + room, alloc_frag, gfp)))
+	buf = virtnet_alloc_frag(rq, len + room, gfp);
+	if (unlikely(!buf))
 		return -ENOMEM;
 
-	buf = (char *)page_address(alloc_frag->page) + alloc_frag->offset;
 	buf += headroom; /* advance address leaving hole at front of pkt */
-	get_page(alloc_frag->page);
-	alloc_frag->offset += len + room;
 	hole = alloc_frag->size - alloc_frag->offset;
 	if (hole < len + room) {
 		/* To avoid internal fragmentation, if there is very likely not
-- 
2.31.0

