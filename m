Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E62A66CBB0C
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 11:31:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232806AbjC1JbN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 05:31:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232776AbjC1JaX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 05:30:23 -0400
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01817768F;
        Tue, 28 Mar 2023 02:29:17 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R921e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046049;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0VeseIE3_1679995743;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VeseIE3_1679995743)
          by smtp.aliyun-inc.com;
          Tue, 28 Mar 2023 17:29:03 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org
Subject: [PATCH 14/16] virtio_net: move virtnet_[en/dis]able_delayed_refill to header file
Date:   Tue, 28 Mar 2023 17:28:45 +0800
Message-Id: <20230328092847.91643-15-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.32.0.3.g01195cf9f
In-Reply-To: <20230328092847.91643-1-xuanzhuo@linux.alibaba.com>
References: <20230328092847.91643-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
X-Git-Hash: e880b402863c
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.0 required=5.0 tests=ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move virtnet_[en/dis]able_delayed_refill to header file.

This is prepare for separating virtio-related funcs.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 drivers/net/virtio/virtnet.c | 20 +++-----------------
 drivers/net/virtio/virtnet.h | 15 +++++++++++++++
 2 files changed, 18 insertions(+), 17 deletions(-)

diff --git a/drivers/net/virtio/virtnet.c b/drivers/net/virtio/virtnet.c
index 8f281a7f9d7a..75a74864c3fe 100644
--- a/drivers/net/virtio/virtnet.c
+++ b/drivers/net/virtio/virtnet.c
@@ -136,20 +136,6 @@ static struct page *get_a_page(struct virtnet_rq *rq, gfp_t gfp_mask)
 	return p;
 }
 
-static void enable_delayed_refill(struct virtnet_info *vi)
-{
-	spin_lock_bh(&vi->refill_lock);
-	vi->refill_enabled = true;
-	spin_unlock_bh(&vi->refill_lock);
-}
-
-static void disable_delayed_refill(struct virtnet_info *vi)
-{
-	spin_lock_bh(&vi->refill_lock);
-	vi->refill_enabled = false;
-	spin_unlock_bh(&vi->refill_lock);
-}
-
 static void virtqueue_napi_schedule(struct napi_struct *napi,
 				    struct virtqueue *vq)
 {
@@ -1622,7 +1608,7 @@ static int virtnet_open(struct net_device *dev)
 	struct virtnet_info *vi = netdev_priv(dev);
 	int i, err;
 
-	enable_delayed_refill(vi);
+	virtnet_enable_delayed_refill(vi);
 
 	for (i = 0; i < vi->max_queue_pairs; i++) {
 		if (i < vi->curr_queue_pairs)
@@ -1979,7 +1965,7 @@ static int virtnet_close(struct net_device *dev)
 	int i;
 
 	/* Make sure NAPI doesn't schedule refill work */
-	disable_delayed_refill(vi);
+	virtnet_disable_delayed_refill(vi);
 	/* Make sure virtnet_refill_work doesn't re-enable napi! */
 	cancel_delayed_work_sync(&vi->refill);
 
@@ -2068,7 +2054,7 @@ static int virtnet_restore_up(struct virtio_device *vdev)
 
 	virtio_device_ready(vdev);
 
-	enable_delayed_refill(vi);
+	virtnet_enable_delayed_refill(vi);
 
 	if (netif_running(vi->dev)) {
 		err = virtnet_get_netdev()->ndo_open(vi->dev);
diff --git a/drivers/net/virtio/virtnet.h b/drivers/net/virtio/virtnet.h
index 1315dcf52f1b..5f20e9103a0e 100644
--- a/drivers/net/virtio/virtnet.h
+++ b/drivers/net/virtio/virtnet.h
@@ -193,4 +193,19 @@ void virtnet_skb_xmit_done(struct virtqueue *vq);
 void virtnet_skb_recv_done(struct virtqueue *rvq);
 void virtnet_refill_work(struct work_struct *work);
 void virtnet_free_bufs(struct virtnet_info *vi);
+
+static inline void virtnet_enable_delayed_refill(struct virtnet_info *vi)
+{
+	spin_lock_bh(&vi->refill_lock);
+	vi->refill_enabled = true;
+	spin_unlock_bh(&vi->refill_lock);
+}
+
+static inline void virtnet_disable_delayed_refill(struct virtnet_info *vi)
+{
+	spin_lock_bh(&vi->refill_lock);
+	vi->refill_enabled = false;
+	spin_unlock_bh(&vi->refill_lock);
+}
+
 #endif
-- 
2.32.0.3.g01195cf9f

