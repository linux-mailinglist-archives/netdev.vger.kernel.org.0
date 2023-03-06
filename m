Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EE546AB592
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 05:16:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229729AbjCFEQk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Mar 2023 23:16:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229665AbjCFEQe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Mar 2023 23:16:34 -0500
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 173FF1ABC2;
        Sun,  5 Mar 2023 20:16:06 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046056;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0Vd8Os24_1678076137;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0Vd8Os24_1678076137)
          by smtp.aliyun-inc.com;
          Mon, 06 Mar 2023 12:15:37 +0800
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
Subject: [PATCH net 1/2] virtio_net: separate the logic of checking whether sq is full
Date:   Mon,  6 Mar 2023 12:15:34 +0800
Message-Id: <20230306041535.73319-2-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.32.0.3.g01195cf9f
In-Reply-To: <20230306041535.73319-1-xuanzhuo@linux.alibaba.com>
References: <20230306041535.73319-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
X-Git-Hash: 340c28a36929
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

Separate the logic of checking whether sq is full. The subsequent patch
will reuse this func.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 drivers/net/virtio_net.c | 59 ++++++++++++++++++++++++----------------
 1 file changed, 35 insertions(+), 24 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index fb5e68ed3ec2..777de0ec0b1b 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -1750,6 +1750,40 @@ static void free_old_xmit_skbs(struct send_queue *sq, bool in_napi)
 	u64_stats_update_end(&sq->stats.syncp);
 }
 
+static void check_sq_full(struct virtnet_info *vi, struct net_device *dev,
+			  struct send_queue *sq)
+{
+	bool use_napi = sq->napi.weight;
+	int qnum;
+
+	qnum = sq - vi->sq;
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
+	if (sq->vq->num_free < 2+MAX_SKB_FRAGS) {
+		netif_stop_subqueue(dev, qnum);
+		if (use_napi) {
+			if (unlikely(!virtqueue_enable_cb_delayed(sq->vq)))
+				virtqueue_napi_schedule(&sq->napi, sq->vq);
+		} else if (unlikely(!virtqueue_enable_cb_delayed(sq->vq))) {
+			/* More just got used, free them then recheck. */
+			free_old_xmit_skbs(sq, false);
+			if (sq->vq->num_free >= 2+MAX_SKB_FRAGS) {
+				netif_start_subqueue(dev, qnum);
+				virtqueue_disable_cb(sq->vq);
+			}
+		}
+	}
+}
+
 static bool is_xdp_raw_buffer_queue(struct virtnet_info *vi, int q)
 {
 	if (q < (vi->curr_queue_pairs - vi->xdp_queue_pairs))
@@ -1989,30 +2023,7 @@ static netdev_tx_t start_xmit(struct sk_buff *skb, struct net_device *dev)
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
-		if (use_napi) {
-			if (unlikely(!virtqueue_enable_cb_delayed(sq->vq)))
-				virtqueue_napi_schedule(&sq->napi, sq->vq);
-		} else if (unlikely(!virtqueue_enable_cb_delayed(sq->vq))) {
-			/* More just got used, free them then recheck. */
-			free_old_xmit_skbs(sq, false);
-			if (sq->vq->num_free >= 2+MAX_SKB_FRAGS) {
-				netif_start_subqueue(dev, qnum);
-				virtqueue_disable_cb(sq->vq);
-			}
-		}
-	}
+	check_sq_full(vi, dev, sq);
 
 	if (kick || netif_xmit_stopped(txq)) {
 		if (virtqueue_kick_prepare(sq->vq) && virtqueue_notify(sq->vq)) {
-- 
2.32.0.3.g01195cf9f

