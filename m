Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96B44687B36
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 12:01:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231897AbjBBLBn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 06:01:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232607AbjBBLBX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 06:01:23 -0500
Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED43387D2A;
        Thu,  2 Feb 2023 03:01:16 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046059;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=21;SR=0;TI=SMTPD_---0VakpyCA_1675335671;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VakpyCA_1675335671)
          by smtp.aliyun-inc.com;
          Thu, 02 Feb 2023 19:01:12 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Menglong Dong <imagedong@tencent.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Petr Machata <petrm@nvidia.com>,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org
Subject: [PATCH 11/33] virtio_net: rename free_old_xmit_skbs to free_old_xmit
Date:   Thu,  2 Feb 2023 19:00:36 +0800
Message-Id: <20230202110058.130695-12-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.32.0.3.g01195cf9f
In-Reply-To: <20230202110058.130695-1-xuanzhuo@linux.alibaba.com>
References: <20230202110058.130695-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
X-Git-Hash: d7589ab6ea10
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since free_old_xmit_skbs not only deals with skb, but also xdp frame and
subsequent added xsk, so change the name of this function to
free_old_xmit.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 drivers/net/virtio_net.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 0f0036b1514d..bc7b9ccb325a 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -1714,7 +1714,7 @@ static int virtnet_receive(struct receive_queue *rq, int budget,
 	return stats.packets;
 }
 
-static void free_old_xmit_skbs(struct send_queue *sq, bool in_napi)
+static void free_old_xmit(struct send_queue *sq, bool in_napi)
 {
 	unsigned int len;
 	unsigned int packets = 0;
@@ -1778,7 +1778,7 @@ static void virtnet_poll_cleantx(struct receive_queue *rq)
 
 		do {
 			virtqueue_disable_cb(sq->vq);
-			free_old_xmit_skbs(sq, true);
+			free_old_xmit(sq, true);
 		} while (unlikely(!virtqueue_enable_cb_delayed(sq->vq)));
 
 		if (sq->vq->num_free >= 2 + MAX_SKB_FRAGS)
@@ -1870,7 +1870,7 @@ static int virtnet_poll_tx(struct napi_struct *napi, int budget)
 	txq = netdev_get_tx_queue(vi->dev, index);
 	__netif_tx_lock(txq, raw_smp_processor_id());
 	virtqueue_disable_cb(sq->vq);
-	free_old_xmit_skbs(sq, true);
+	free_old_xmit(sq, true);
 
 	if (sq->vq->num_free >= 2 + MAX_SKB_FRAGS)
 		netif_tx_wake_queue(txq);
@@ -1960,7 +1960,7 @@ static netdev_tx_t start_xmit(struct sk_buff *skb, struct net_device *dev)
 		if (use_napi)
 			virtqueue_disable_cb(sq->vq);
 
-		free_old_xmit_skbs(sq, false);
+		free_old_xmit(sq, false);
 
 	} while (use_napi && kick &&
 	       unlikely(!virtqueue_enable_cb_delayed(sq->vq)));
@@ -2006,7 +2006,7 @@ static netdev_tx_t start_xmit(struct sk_buff *skb, struct net_device *dev)
 				virtqueue_napi_schedule(&sq->napi, sq->vq);
 		} else if (unlikely(!virtqueue_enable_cb_delayed(sq->vq))) {
 			/* More just got used, free them then recheck. */
-			free_old_xmit_skbs(sq, false);
+			free_old_xmit(sq, false);
 			if (sq->vq->num_free >= 2+MAX_SKB_FRAGS) {
 				netif_start_subqueue(dev, qnum);
 				virtqueue_disable_cb(sq->vq);
-- 
2.32.0.3.g01195cf9f

