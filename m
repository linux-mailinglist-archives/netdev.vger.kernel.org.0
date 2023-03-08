Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4594C6AFD07
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 03:49:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229480AbjCHCtq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 21:49:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbjCHCtn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 21:49:43 -0500
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCA5D9273F;
        Tue,  7 Mar 2023 18:49:41 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R811e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045168;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=15;SR=0;TI=SMTPD_---0VdNGxDg_1678243777;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VdNGxDg_1678243777)
          by smtp.aliyun-inc.com;
          Wed, 08 Mar 2023 10:49:37 +0800
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
Subject: [PATCH net, stable v1 2/3] virtio_net: separate the logic of checking whether sq is full
Date:   Wed,  8 Mar 2023 10:49:34 +0800
Message-Id: <20230308024935.91686-3-xuanzhuo@linux.alibaba.com>
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

Separate the logic of checking whether sq is full. The subsequent patch
will reuse this func.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/net/virtio_net.c | 60 ++++++++++++++++++++++++----------------
 1 file changed, 36 insertions(+), 24 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 8b31a04052f2..46bbddaadb0d 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -591,6 +591,41 @@ static bool is_xdp_raw_buffer_queue(struct virtnet_info *vi, int q)
 		return false;
 }
 
+static void check_sq_full_and_disable(struct virtnet_info *vi,
+				      struct net_device *dev,
+				      struct send_queue *sq)
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
 static int __virtnet_xdp_xmit_one(struct virtnet_info *vi,
 				   struct send_queue *sq,
 				   struct xdp_frame *xdpf)
@@ -1989,30 +2024,7 @@ static netdev_tx_t start_xmit(struct sk_buff *skb, struct net_device *dev)
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
+	check_sq_full_and_disable(vi, dev, sq);
 
 	if (kick || netif_xmit_stopped(txq)) {
 		if (virtqueue_kick_prepare(sq->vq) && virtqueue_notify(sq->vq)) {
-- 
2.32.0.3.g01195cf9f

