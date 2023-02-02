Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57220687B6B
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 12:02:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231893AbjBBLCZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 06:02:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232646AbjBBLBr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 06:01:47 -0500
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF42C889B4;
        Thu,  2 Feb 2023 03:01:40 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R411e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046056;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=21;SR=0;TI=SMTPD_---0Vako6QU_1675335695;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0Vako6QU_1675335695)
          by smtp.aliyun-inc.com;
          Thu, 02 Feb 2023 19:01:35 +0800
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
Subject: [PATCH 32/33] virtio_net: xsk: rx: introduce add_recvbuf_xsk()
Date:   Thu,  2 Feb 2023 19:00:57 +0800
Message-Id: <20230202110058.130695-33-xuanzhuo@linux.alibaba.com>
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

Implement the logic of filling vq with XSK buffer.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 drivers/net/virtio/main.c | 11 +++++++++++
 drivers/net/virtio/xsk.c  | 26 ++++++++++++++++++++++++++
 drivers/net/virtio/xsk.h  |  2 ++
 3 files changed, 39 insertions(+)

diff --git a/drivers/net/virtio/main.c b/drivers/net/virtio/main.c
index 7259b27f5cba..2aff0eee35d3 100644
--- a/drivers/net/virtio/main.c
+++ b/drivers/net/virtio/main.c
@@ -1352,10 +1352,20 @@ static int add_recvbuf_mergeable(struct virtnet_info *vi,
  */
 bool try_fill_recv(struct virtnet_info *vi, struct receive_queue *rq, gfp_t gfp)
 {
+	struct xsk_buff_pool *pool;
 	int err;
 	bool oom;
 
 	do {
+		rcu_read_lock();
+		pool = rcu_dereference(rq->xsk.pool);
+		if (pool) {
+			err = add_recvbuf_xsk(vi, rq, pool, gfp);
+			rcu_read_unlock();
+			goto check;
+		}
+		rcu_read_unlock();
+
 		if (vi->mergeable_rx_bufs)
 			err = add_recvbuf_mergeable(vi, rq, gfp);
 		else if (vi->big_packets)
@@ -1363,6 +1373,7 @@ bool try_fill_recv(struct virtnet_info *vi, struct receive_queue *rq, gfp_t gfp)
 		else
 			err = add_recvbuf_small(vi, rq, gfp);
 
+check:
 		oom = err == -ENOMEM;
 		if (err)
 			break;
diff --git a/drivers/net/virtio/xsk.c b/drivers/net/virtio/xsk.c
index 043b0bf2a5d7..a5e88f919c46 100644
--- a/drivers/net/virtio/xsk.c
+++ b/drivers/net/virtio/xsk.c
@@ -37,6 +37,32 @@ static void virtnet_xsk_check_queue(struct send_queue *sq)
 		netif_stop_subqueue(dev, qnum);
 }
 
+int add_recvbuf_xsk(struct virtnet_info *vi, struct receive_queue *rq,
+		    struct xsk_buff_pool *pool, gfp_t gfp)
+{
+	struct xdp_buff *xdp;
+	dma_addr_t addr;
+	u32 len;
+	int err;
+
+	xdp = xsk_buff_alloc(pool);
+	if (!xdp)
+		return -ENOMEM;
+
+	/* use the part of XDP_PACKET_HEADROOM as the virtnet hdr space */
+	addr = xsk_buff_xdp_get_dma(xdp) - vi->hdr_len;
+	len = xsk_pool_get_rx_frame_size(pool) + vi->hdr_len;
+
+	sg_init_table(rq->sg, 1);
+	sg_fill_dma(rq->sg, addr, len);
+
+	err = virtqueue_add_inbuf_premapped(rq->vq, rq->sg, 1, xdp, gfp);
+	if (err)
+		xsk_buff_free(xdp);
+
+	return err;
+}
+
 static int virtnet_xsk_xmit_one(struct send_queue *sq,
 				struct xsk_buff_pool *pool,
 				struct xdp_desc *desc)
diff --git a/drivers/net/virtio/xsk.h b/drivers/net/virtio/xsk.h
index f90c28972d72..5549143ef118 100644
--- a/drivers/net/virtio/xsk.h
+++ b/drivers/net/virtio/xsk.h
@@ -24,4 +24,6 @@ int virtnet_xsk_pool_setup(struct net_device *dev, struct netdev_bpf *xdp);
 bool virtnet_xsk_xmit(struct send_queue *sq, struct xsk_buff_pool *pool,
 		      int budget);
 int virtnet_xsk_wakeup(struct net_device *dev, u32 qid, u32 flag);
+int add_recvbuf_xsk(struct virtnet_info *vi, struct receive_queue *rq,
+		    struct xsk_buff_pool *pool, gfp_t gfp);
 #endif
-- 
2.32.0.3.g01195cf9f

