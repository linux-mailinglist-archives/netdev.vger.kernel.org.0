Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B18E96CBB12
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 11:31:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232948AbjC1JbV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 05:31:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232840AbjC1Jap (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 05:30:45 -0400
Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F26DA658C;
        Tue, 28 Mar 2023 02:29:25 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R621e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046051;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0Vesd9Jr_1679995741;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0Vesd9Jr_1679995741)
          by smtp.aliyun-inc.com;
          Tue, 28 Mar 2023 17:29:01 +0800
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
Subject: [PATCH 12/16] virtio_net: introduce virtnet_get_netdev()
Date:   Tue, 28 Mar 2023 17:28:43 +0800
Message-Id: <20230328092847.91643-13-xuanzhuo@linux.alibaba.com>
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

Adding an API to get netdev_ops. Avoid to use the netdev_ops directly.

This is prepare for separating the virtio-related funcs.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 drivers/net/virtio/virtnet.c | 11 ++++++++---
 drivers/net/virtio/virtnet.h |  1 +
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/net/virtio/virtnet.c b/drivers/net/virtio/virtnet.c
index 3f58af7d1550..5f508d9500f3 100644
--- a/drivers/net/virtio/virtnet.c
+++ b/drivers/net/virtio/virtnet.c
@@ -2054,7 +2054,7 @@ static void virtnet_freeze_down(struct virtio_device *vdev)
 	netif_device_detach(vi->dev);
 	netif_tx_unlock_bh(vi->dev);
 	if (netif_running(vi->dev))
-		virtnet_close(vi->dev);
+		virtnet_get_netdev()->ndo_stop(vi->dev);
 }
 
 static int init_vqs(struct virtnet_info *vi);
@@ -2073,7 +2073,7 @@ static int virtnet_restore_up(struct virtio_device *vdev)
 	enable_delayed_refill(vi);
 
 	if (netif_running(vi->dev)) {
-		err = virtnet_open(vi->dev);
+		err = virtnet_get_netdev()->ndo_open(vi->dev);
 		if (err)
 			return err;
 	}
@@ -2319,6 +2319,11 @@ static const struct net_device_ops virtnet_netdev = {
 	.ndo_tx_timeout		= virtnet_tx_timeout,
 };
 
+const struct net_device_ops *virtnet_get_netdev(void)
+{
+	return &virtnet_netdev;
+}
+
 static void virtnet_config_changed_work(struct work_struct *work)
 {
 	struct virtnet_info *vi =
@@ -2796,7 +2801,7 @@ static int virtnet_probe(struct virtio_device *vdev)
 	/* Set up network device as normal. */
 	dev->priv_flags |= IFF_UNICAST_FLT | IFF_LIVE_ADDR_CHANGE |
 			   IFF_TX_SKB_NO_LINEAR;
-	dev->netdev_ops = &virtnet_netdev;
+	dev->netdev_ops = virtnet_get_netdev();
 	dev->features = NETIF_F_HIGHDMA;
 
 	dev->ethtool_ops = virtnet_get_ethtool_ops();
diff --git a/drivers/net/virtio/virtnet.h b/drivers/net/virtio/virtnet.h
index 48e0c5ba346a..269ddc386418 100644
--- a/drivers/net/virtio/virtnet.h
+++ b/drivers/net/virtio/virtnet.h
@@ -185,4 +185,5 @@ int virtnet_rx_resize(struct virtnet_info *vi, struct virtnet_rq *rq, u32 ring_n
 int virtnet_tx_resize(struct virtnet_info *vi, struct virtnet_sq *sq, u32 ring_num);
 int _virtnet_set_queues(struct virtnet_info *vi, u16 queue_pairs);
 void virtnet_dev_rx_queue_group(struct virtnet_info *vi, struct net_device *dev);
+const struct net_device_ops *virtnet_get_netdev(void);
 #endif
-- 
2.32.0.3.g01195cf9f

