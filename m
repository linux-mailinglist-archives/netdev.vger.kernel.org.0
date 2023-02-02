Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B97E687B6A
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 12:02:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231743AbjBBLCY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 06:02:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232607AbjBBLBn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 06:01:43 -0500
Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFCEC889A9;
        Thu,  2 Feb 2023 03:01:38 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R591e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046050;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=21;SR=0;TI=SMTPD_---0VaksacV_1675335693;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VaksacV_1675335693)
          by smtp.aliyun-inc.com;
          Thu, 02 Feb 2023 19:01:34 +0800
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
Subject: [PATCH 31/33] virtio_net: xsk: tx: auto wakeup when free old xmit
Date:   Thu,  2 Feb 2023 19:00:56 +0800
Message-Id: <20230202110058.130695-32-xuanzhuo@linux.alibaba.com>
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

If the XSK xmit stops because the TX queue is full, this time is
waiting for the TX interrupt to trigger the follow-up work again.

But for Virtio Net, the recycling old buf is not only completed in tx
napi, but also is called in start_xmit(), rx poll and other places.

So if xsk xmit stop by full tx queue, __free_old_xmit() will try to
wakeup tx napi.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 drivers/net/virtio/virtio_net.h |  5 +++--
 drivers/net/virtio/xsk.c        | 30 ++++++++++++++++++++++++++++++
 drivers/net/virtio/xsk.h        |  1 +
 3 files changed, 34 insertions(+), 2 deletions(-)

diff --git a/drivers/net/virtio/virtio_net.h b/drivers/net/virtio/virtio_net.h
index fc7c7a0f3c89..100ce48c6d55 100644
--- a/drivers/net/virtio/virtio_net.h
+++ b/drivers/net/virtio/virtio_net.h
@@ -176,6 +176,8 @@ struct send_queue {
 		dma_addr_t hdr_dma_address;
 
 		u32 last_cpu;
+
+		bool need_wakeup;
 	} xsk;
 };
 
@@ -296,8 +298,7 @@ static void __free_old_xmit(struct send_queue *sq, bool in_napi,
 		stats->packets++;
 	}
 
-	if (xsknum)
-		xsk_tx_completed(sq->xsk.pool, xsknum);
+	virtnet_xsk_complete(sq, xsknum, in_napi);
 }
 
 int virtnet_xdp_handler(struct bpf_prog *xdp_prog, struct xdp_buff *xdp,
diff --git a/drivers/net/virtio/xsk.c b/drivers/net/virtio/xsk.c
index 27b7f0bb2d34..043b0bf2a5d7 100644
--- a/drivers/net/virtio/xsk.c
+++ b/drivers/net/virtio/xsk.c
@@ -116,6 +116,7 @@ bool virtnet_xsk_xmit(struct send_queue *sq, struct xsk_buff_pool *pool,
 	bool busy;
 	int ret;
 
+	sq->xsk.need_wakeup = false;
 	__free_old_xmit(sq, true, &stats);
 
 	if (xsk_uses_need_wakeup(pool))
@@ -138,6 +139,13 @@ bool virtnet_xsk_xmit(struct send_queue *sq, struct xsk_buff_pool *pool,
 		 * triggered by interrupt.
 		 */
 		busy = false;
+
+		/* tx poll may not be triggered by tx interruption because of
+		 * that start_xmit() and rx poll will try free old xmit that
+		 * cause no tx interruption will be generated. So set
+		 * need_wakeup, then tx poll can be triggered by free_old_xmit.
+		 */
+		sq->xsk.need_wakeup = true;
 		break;
 	}
 
@@ -206,6 +214,26 @@ int virtnet_xsk_wakeup(struct net_device *dev, u32 qid, u32 flag)
 	return 0;
 }
 
+void virtnet_xsk_complete(struct send_queue *sq, u32 num, bool in_napi)
+{
+	struct xsk_buff_pool *pool;
+
+	rcu_read_lock();
+
+	pool = rcu_dereference(sq->xsk.pool);
+	if (pool) {
+		if (num)
+			xsk_tx_completed(pool, num);
+
+		if (sq->xsk.need_wakeup) {
+			sq->xsk.need_wakeup = false;
+			virtnet_xsk_wakeup_sq(sq, in_napi);
+		}
+	}
+
+	rcu_read_unlock();
+}
+
 static int virtnet_rq_bind_xsk_pool(struct virtnet_info *vi, struct receive_queue *rq,
 				    struct xsk_buff_pool *pool, struct net_device *dev)
 {
@@ -298,6 +326,8 @@ static int virtnet_xsk_pool_enable(struct net_device *dev,
 	if (err)
 		goto err_rxq;
 
+	sq->xsk.need_wakeup = false;
+
 	/* Here is already protected by rtnl_lock, so rcu_assign_pointer
 	 * is safe.
 	 */
diff --git a/drivers/net/virtio/xsk.h b/drivers/net/virtio/xsk.h
index 5eece0de3310..f90c28972d72 100644
--- a/drivers/net/virtio/xsk.h
+++ b/drivers/net/virtio/xsk.h
@@ -19,6 +19,7 @@ static inline u32 ptr_to_xsk(void *ptr)
 	return ((unsigned long)ptr) >> VIRTIO_XSK_FLAG_OFFSET;
 }
 
+void virtnet_xsk_complete(struct send_queue *sq, u32 num, bool in_napi);
 int virtnet_xsk_pool_setup(struct net_device *dev, struct netdev_bpf *xdp);
 bool virtnet_xsk_xmit(struct send_queue *sq, struct xsk_buff_pool *pool,
 		      int budget);
-- 
2.32.0.3.g01195cf9f

