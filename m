Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CFCC6CBAD4
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 11:31:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232796AbjC1Jaf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 05:30:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232795AbjC1J3k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 05:29:40 -0400
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FA18729F;
        Tue, 28 Mar 2023 02:29:05 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045192;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0VesYnWM_1679995739;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VesYnWM_1679995739)
          by smtp.aliyun-inc.com;
          Tue, 28 Mar 2023 17:29:00 +0800
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
Subject: [PATCH 11/16] virtio_net: introduce virtnet_dev_rx_queue_group()
Date:   Tue, 28 Mar 2023 17:28:42 +0800
Message-Id: <20230328092847.91643-12-xuanzhuo@linux.alibaba.com>
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

Adding an API to set sysfs_rx_queue_group.

This is prepare for separating the virtio-related funcs.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 drivers/net/virtio/virtnet.c | 15 +++++++++++----
 drivers/net/virtio/virtnet.h |  1 +
 2 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/net/virtio/virtnet.c b/drivers/net/virtio/virtnet.c
index 1323c6733f56..3f58af7d1550 100644
--- a/drivers/net/virtio/virtnet.c
+++ b/drivers/net/virtio/virtnet.c
@@ -2661,6 +2661,16 @@ static const struct attribute_group virtio_net_mrg_rx_group = {
 	.name = "virtio_net",
 	.attrs = virtio_net_mrg_rx_attrs
 };
+
+void virtnet_dev_rx_queue_group(struct virtnet_info *vi, struct net_device *dev)
+{
+	if (vi->mergeable_rx_bufs)
+		dev->sysfs_rx_queue_group = &virtio_net_mrg_rx_group;
+}
+#else
+void virtnet_dev_rx_queue_group(struct virtnet_info *vi, struct net_device *dev)
+{
+}
 #endif
 
 static bool virtnet_fail_on_feature(struct virtio_device *vdev,
@@ -2943,10 +2953,7 @@ static int virtnet_probe(struct virtio_device *vdev)
 	if (err)
 		goto free;
 
-#ifdef CONFIG_SYSFS
-	if (vi->mergeable_rx_bufs)
-		dev->sysfs_rx_queue_group = &virtio_net_mrg_rx_group;
-#endif
+	virtnet_dev_rx_queue_group(vi, dev);
 	netif_set_real_num_tx_queues(dev, vi->curr_queue_pairs);
 	netif_set_real_num_rx_queues(dev, vi->curr_queue_pairs);
 
diff --git a/drivers/net/virtio/virtnet.h b/drivers/net/virtio/virtnet.h
index b889825c54d0..48e0c5ba346a 100644
--- a/drivers/net/virtio/virtnet.h
+++ b/drivers/net/virtio/virtnet.h
@@ -184,4 +184,5 @@ struct virtnet_info {
 int virtnet_rx_resize(struct virtnet_info *vi, struct virtnet_rq *rq, u32 ring_num);
 int virtnet_tx_resize(struct virtnet_info *vi, struct virtnet_sq *sq, u32 ring_num);
 int _virtnet_set_queues(struct virtnet_info *vi, u16 queue_pairs);
+void virtnet_dev_rx_queue_group(struct virtnet_info *vi, struct net_device *dev);
 #endif
-- 
2.32.0.3.g01195cf9f

