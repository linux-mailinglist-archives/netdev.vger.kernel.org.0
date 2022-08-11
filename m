Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0DF158F8B9
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 10:03:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229924AbiHKIDF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 04:03:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234221AbiHKIDF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 04:03:05 -0400
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7803527CC8
        for <netdev@vger.kernel.org>; Thu, 11 Aug 2022 01:03:03 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046056;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0VLyLAwX_1660204979;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VLyLAwX_1660204979)
          by smtp.aliyun-inc.com;
          Thu, 11 Aug 2022 16:02:59 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     virtualization@lists.linux-foundation.org
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Kangjie Xu <kangjie.xu@linux.alibaba.com>
Subject: [PATCH 1/2] virtio_net: fix for stuck when change rx ring size with dev down
Date:   Thu, 11 Aug 2022 16:02:57 +0800
Message-Id: <20220811080258.79398-2-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20220811080258.79398-1-xuanzhuo@linux.alibaba.com>
References: <20220811080258.79398-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
X-Git-Hash: 4d0f44f05adf
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

When dev is set to DOWN state, napi has been disabled, if we modify the
ring size at this time, we should not call napi_disable() again, which
will cause stuck.

And all operations are under the protection of rtnl_lock, so there is no
need to consider concurrency issues.

Reported-by: Kangjie Xu <kangjie.xu@linux.alibaba.com>
Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 drivers/net/virtio_net.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 816c613c22f7..17687eb3f0bd 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -1892,11 +1892,13 @@ static netdev_tx_t start_xmit(struct sk_buff *skb, struct net_device *dev)
 static int virtnet_rx_resize(struct virtnet_info *vi,
 			     struct receive_queue *rq, u32 ring_num)
 {
+	bool running = netif_running(vi->dev);
 	int err, qindex;
 
 	qindex = rq - vi->rq;
 
-	napi_disable(&rq->napi);
+	if (running)
+		napi_disable(&rq->napi);
 
 	err = virtqueue_resize(rq->vq, ring_num, virtnet_rq_free_unused_buf);
 	if (err)
@@ -1905,7 +1907,8 @@ static int virtnet_rx_resize(struct virtnet_info *vi,
 	if (!try_fill_recv(vi, rq, GFP_KERNEL))
 		schedule_delayed_work(&vi->refill, 0);
 
-	virtnet_napi_enable(rq->vq, &rq->napi);
+	if (running)
+		virtnet_napi_enable(rq->vq, &rq->napi);
 	return err;
 }
 
-- 
2.31.0

