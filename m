Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FE8A49C48A
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 08:36:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237924AbiAZHgC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 02:36:02 -0500
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:36020 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237959AbiAZHf5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 02:35:57 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0V2uPGPw_1643182551;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0V2uPGPw_1643182551)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 26 Jan 2022 15:35:51 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>, bpf@vger.kernel.org
Subject: [PATCH v3 16/17] virtio_net: split free_unused_bufs()
Date:   Wed, 26 Jan 2022 15:35:32 +0800
Message-Id: <20220126073533.44994-17-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20220126073533.44994-1-xuanzhuo@linux.alibaba.com>
References: <20220126073533.44994-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch separates two functions for freeing sq buf and rq buf from
free_unused_bufs().

When supporting the enable/disable tx/rq queue in the future, it is
necessary to support separate recovery of a sq buf or a rq buf.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 drivers/net/virtio_net.c | 46 ++++++++++++++++++++++++----------------
 1 file changed, 28 insertions(+), 18 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 2add7fe749b8..ea90a1a57c9e 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -2804,33 +2804,43 @@ static void free_receive_page_frags(struct virtnet_info *vi)
 			put_page(vi->rq[i].alloc_frag.page);
 }
 
+static void virtnet_sq_free_unused_buf(struct virtnet_info *vi,
+				       struct send_queue *sq, void *buf)
+{
+	if (!is_xdp_frame(buf))
+		dev_kfree_skb(buf);
+	else
+		xdp_return_frame(ptr_to_xdp(buf));
+}
+
+static void virtnet_rq_free_unused_buf(struct virtnet_info *vi,
+				       struct receive_queue *rq, void *buf)
+{
+	if (vi->mergeable_rx_bufs)
+		put_page(virt_to_head_page(buf));
+	else if (vi->big_packets)
+		give_pages(rq, buf);
+	else
+		put_page(virt_to_head_page(buf));
+}
+
 static void free_unused_bufs(struct virtnet_info *vi)
 {
+	struct receive_queue *rq;
+	struct send_queue *sq;
 	void *buf;
 	int i;
 
 	for (i = 0; i < vi->max_queue_pairs; i++) {
-		struct virtqueue *vq = vi->sq[i].vq;
-		while ((buf = virtqueue_detach_unused_buf(vq)) != NULL) {
-			if (!is_xdp_frame(buf))
-				dev_kfree_skb(buf);
-			else
-				xdp_return_frame(ptr_to_xdp(buf));
-		}
+		sq = &vi->sq[i];
+		while ((buf = virtqueue_detach_unused_buf(sq->vq)) != NULL)
+			virtnet_sq_free_unused_buf(vi, sq, buf);
 	}
 
 	for (i = 0; i < vi->max_queue_pairs; i++) {
-		struct virtqueue *vq = vi->rq[i].vq;
-
-		while ((buf = virtqueue_detach_unused_buf(vq)) != NULL) {
-			if (vi->mergeable_rx_bufs) {
-				put_page(virt_to_head_page(buf));
-			} else if (vi->big_packets) {
-				give_pages(&vi->rq[i], buf);
-			} else {
-				put_page(virt_to_head_page(buf));
-			}
-		}
+		rq = &vi->rq[i];
+		while ((buf = virtqueue_detach_unused_buf(rq->vq)) != NULL)
+			virtnet_rq_free_unused_buf(vi, rq, buf);
 	}
 }
 
-- 
2.31.0

