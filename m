Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B8596EFF9A
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 05:06:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242926AbjD0DGO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 23:06:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242898AbjD0DFv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 23:05:51 -0400
Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83C9640ED;
        Wed, 26 Apr 2023 20:05:44 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046050;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0Vh5fnxM_1682564741;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0Vh5fnxM_1682564741)
          by smtp.aliyun-inc.com;
          Thu, 27 Apr 2023 11:05:42 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     netdev@vger.kernel.org
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org
Subject: [PATCH net-next v4 06/15] virtio_net: separate the logic of freeing the rest mergeable buf
Date:   Thu, 27 Apr 2023 11:05:25 +0800
Message-Id: <20230427030534.115066-7-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.32.0.3.g01195cf9f
In-Reply-To: <20230427030534.115066-1-xuanzhuo@linux.alibaba.com>
References: <20230427030534.115066-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
X-Git-Hash: 69b1082fef22
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch introduce a new function that frees the rest mergeable buf.
The subsequent patch will reuse this function.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Acked-by: Jason Wang <jasowang@redhat.com>
---
 drivers/net/virtio_net.c | 36 ++++++++++++++++++++++++------------
 1 file changed, 24 insertions(+), 12 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index b4eb083ebf55..5f37a1cef61e 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -1067,6 +1067,28 @@ static struct sk_buff *receive_big(struct net_device *dev,
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
@@ -1427,18 +1449,8 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
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

