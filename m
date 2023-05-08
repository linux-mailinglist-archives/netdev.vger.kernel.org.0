Return-Path: <netdev+bounces-795-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E4CB76F9FA0
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 08:17:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A108E280ED0
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 06:17:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20B0D168BF;
	Mon,  8 May 2023 06:14:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 129EE15D1;
	Mon,  8 May 2023 06:14:33 +0000 (UTC)
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CB1BA262;
	Sun,  7 May 2023 23:14:30 -0700 (PDT)
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R291e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046049;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0Vi.E83-_1683526464;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0Vi.E83-_1683526464)
          by smtp.aliyun-inc.com;
          Mon, 08 May 2023 14:14:25 +0800
From: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To: netdev@vger.kernel.org
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>,
	virtualization@lists.linux-foundation.org,
	bpf@vger.kernel.org
Subject: [PATCH net-next v5 06/15] virtio_net: separate the logic of freeing the rest mergeable buf
Date: Mon,  8 May 2023 14:14:08 +0800
Message-Id: <20230508061417.65297-7-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.32.0.3.g01195cf9f
In-Reply-To: <20230508061417.65297-1-xuanzhuo@linux.alibaba.com>
References: <20230508061417.65297-1-xuanzhuo@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Git-Hash: 847ebbc5df1e
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,
	USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

This patch introduce a new function that frees the rest mergeable buf.
The subsequent patch will reuse this function.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Acked-by: Jason Wang <jasowang@redhat.com>
---
 drivers/net/virtio_net.c | 36 ++++++++++++++++++++++++------------
 1 file changed, 24 insertions(+), 12 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index c1538ab46795..b26e95c96141 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -1071,6 +1071,28 @@ static struct sk_buff *receive_big(struct net_device *dev,
 	return NULL;
 }
 
+static void mergeable_buf_free(struct receive_queue *rq, int num_buf,
+			       struct net_device *dev,
+			       struct virtnet_rq_stats *stats)
+{
+	struct page *page;
+	void *buf;
+	int len;
+
+	while (num_buf-- > 1) {
+		buf = virtqueue_get_buf(rq->vq, &len);
+		if (unlikely(!buf)) {
+			pr_debug("%s: rx error: %d buffers missing\n",
+				 dev->name, num_buf);
+			dev->stats.rx_length_errors++;
+			break;
+		}
+		stats->bytes += len;
+		page = virt_to_head_page(buf);
+		put_page(page);
+	}
+}
+
 /* Why not use xdp_build_skb_from_frame() ?
  * XDP core assumes that xdp frags are PAGE_SIZE in length, while in
  * virtio-net there are 2 points that do not match its requirements:
@@ -1431,18 +1453,8 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
 	stats->xdp_drops++;
 err_skb:
 	put_page(page);
-	while (num_buf-- > 1) {
-		buf = virtqueue_get_buf(rq->vq, &len);
-		if (unlikely(!buf)) {
-			pr_debug("%s: rx error: %d buffers missing\n",
-				 dev->name, num_buf);
-			dev->stats.rx_length_errors++;
-			break;
-		}
-		stats->bytes += len;
-		page = virt_to_head_page(buf);
-		put_page(page);
-	}
+	mergeable_buf_free(rq, num_buf, dev, stats);
+
 err_buf:
 	stats->drops++;
 	dev_kfree_skb(head_skb);
-- 
2.32.0.3.g01195cf9f


