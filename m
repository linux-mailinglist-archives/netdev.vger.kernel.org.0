Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DECAC6AFD05
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 03:49:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229772AbjCHCto (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 21:49:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbjCHCtm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 21:49:42 -0500
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E49F99273A;
        Tue,  7 Mar 2023 18:49:40 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045192;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=15;SR=0;TI=SMTPD_---0VdNJYTP_1678243776;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VdNJYTP_1678243776)
          by smtp.aliyun-inc.com;
          Wed, 08 Mar 2023 10:49:36 +0800
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
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org,
        Yichun Zhang <yichun@openresty.com>,
        Alexander Duyck <alexanderduyck@fb.com>
Subject: [PATCH net, stable v1 1/3] virtio_net: reorder some funcs
Date:   Wed,  8 Mar 2023 10:49:33 +0800
Message-Id: <20230308024935.91686-2-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.32.0.3.g01195cf9f
In-Reply-To: <20230308024935.91686-1-xuanzhuo@linux.alibaba.com>
References: <20230308024935.91686-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
X-Git-Hash: 8a00faae1554
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The purpose of this is to facilitate the subsequent addition of new
functions without introducing a separate declaration.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 drivers/net/virtio_net.c | 92 ++++++++++++++++++++--------------------
 1 file changed, 46 insertions(+), 46 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index fb5e68ed3ec2..8b31a04052f2 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -545,6 +545,52 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
 	return skb;
 }
 
+static void free_old_xmit_skbs(struct send_queue *sq, bool in_napi)
+{
+	unsigned int len;
+	unsigned int packets = 0;
+	unsigned int bytes = 0;
+	void *ptr;
+
+	while ((ptr = virtqueue_get_buf(sq->vq, &len)) != NULL) {
+		if (likely(!is_xdp_frame(ptr))) {
+			struct sk_buff *skb = ptr;
+
+			pr_debug("Sent skb %p\n", skb);
+
+			bytes += skb->len;
+			napi_consume_skb(skb, in_napi);
+		} else {
+			struct xdp_frame *frame = ptr_to_xdp(ptr);
+
+			bytes += xdp_get_frame_len(frame);
+			xdp_return_frame(frame);
+		}
+		packets++;
+	}
+
+	/* Avoid overhead when no packets have been processed
+	 * happens when called speculatively from start_xmit.
+	 */
+	if (!packets)
+		return;
+
+	u64_stats_update_begin(&sq->stats.syncp);
+	sq->stats.bytes += bytes;
+	sq->stats.packets += packets;
+	u64_stats_update_end(&sq->stats.syncp);
+}
+
+static bool is_xdp_raw_buffer_queue(struct virtnet_info *vi, int q)
+{
+	if (q < (vi->curr_queue_pairs - vi->xdp_queue_pairs))
+		return false;
+	else if (q < vi->curr_queue_pairs)
+		return true;
+	else
+		return false;
+}
+
 static int __virtnet_xdp_xmit_one(struct virtnet_info *vi,
 				   struct send_queue *sq,
 				   struct xdp_frame *xdpf)
@@ -1714,52 +1760,6 @@ static int virtnet_receive(struct receive_queue *rq, int budget,
 	return stats.packets;
 }
 
-static void free_old_xmit_skbs(struct send_queue *sq, bool in_napi)
-{
-	unsigned int len;
-	unsigned int packets = 0;
-	unsigned int bytes = 0;
-	void *ptr;
-
-	while ((ptr = virtqueue_get_buf(sq->vq, &len)) != NULL) {
-		if (likely(!is_xdp_frame(ptr))) {
-			struct sk_buff *skb = ptr;
-
-			pr_debug("Sent skb %p\n", skb);
-
-			bytes += skb->len;
-			napi_consume_skb(skb, in_napi);
-		} else {
-			struct xdp_frame *frame = ptr_to_xdp(ptr);
-
-			bytes += xdp_get_frame_len(frame);
-			xdp_return_frame(frame);
-		}
-		packets++;
-	}
-
-	/* Avoid overhead when no packets have been processed
-	 * happens when called speculatively from start_xmit.
-	 */
-	if (!packets)
-		return;
-
-	u64_stats_update_begin(&sq->stats.syncp);
-	sq->stats.bytes += bytes;
-	sq->stats.packets += packets;
-	u64_stats_update_end(&sq->stats.syncp);
-}
-
-static bool is_xdp_raw_buffer_queue(struct virtnet_info *vi, int q)
-{
-	if (q < (vi->curr_queue_pairs - vi->xdp_queue_pairs))
-		return false;
-	else if (q < vi->curr_queue_pairs)
-		return true;
-	else
-		return false;
-}
-
 static void virtnet_poll_cleantx(struct receive_queue *rq)
 {
 	struct virtnet_info *vi = rq->vq->vdev->priv;
-- 
2.32.0.3.g01195cf9f

