Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACD3D687B5E
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 12:02:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232827AbjBBLCE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 06:02:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232273AbjBBLBb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 06:01:31 -0500
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE5988717A;
        Thu,  2 Feb 2023 03:01:28 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045170;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=21;SR=0;TI=SMTPD_---0VakkM6u_1675335682;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VakkM6u_1675335682)
          by smtp.aliyun-inc.com;
          Thu, 02 Feb 2023 19:01:23 +0800
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
Subject: [PATCH 21/33] virtio_net: xsk: introduce virtnet_xsk_pool_enable()
Date:   Thu,  2 Feb 2023 19:00:46 +0800
Message-Id: <20230202110058.130695-22-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.32.0.3.g01195cf9f
In-Reply-To: <20230202110058.130695-1-xuanzhuo@linux.alibaba.com>
References: <20230202110058.130695-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
X-Git-Hash: d7589ab6ea10
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

Introduce virtnet_xsk_pool_enable() for xsk setup.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 drivers/net/virtio/xsk.c | 59 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 59 insertions(+)

diff --git a/drivers/net/virtio/xsk.c b/drivers/net/virtio/xsk.c
index e01ff2abea11..a7e8005233d2 100644
--- a/drivers/net/virtio/xsk.c
+++ b/drivers/net/virtio/xsk.c
@@ -5,6 +5,8 @@
 
 #include "virtio_net.h"
 
+static struct virtio_net_hdr_mrg_rxbuf xsk_hdr;
+
 static int virtnet_rq_bind_xsk_pool(struct virtnet_info *vi, struct receive_queue *rq,
 				    struct xsk_buff_pool *pool, struct net_device *dev)
 {
@@ -54,3 +56,60 @@ static int virtnet_rq_bind_xsk_pool(struct virtnet_info *vi, struct receive_queu
 
 	return err;
 }
+
+static int virtnet_xsk_pool_enable(struct net_device *dev,
+				   struct xsk_buff_pool *pool,
+				   u16 qid)
+{
+	struct virtnet_info *vi = netdev_priv(dev);
+	struct receive_queue *rq;
+	struct send_queue *sq;
+	int err;
+
+	if (qid >= vi->curr_queue_pairs)
+		return -EINVAL;
+
+	sq = &vi->sq[qid];
+	rq = &vi->rq[qid];
+
+	/* xsk zerocopy depend on the tx napi.
+	 *
+	 * All xsk packets are actually consumed and sent out from the xsk tx
+	 * queue under the tx napi mechanism.
+	 */
+	if (!sq->napi.weight)
+		return -EPERM;
+
+	/* In big_packets mode, xdp cannot work, so there is no need to
+	 * initialize xsk of rq.
+	 */
+	if (vi->big_packets && !vi->mergeable_rx_bufs)
+		return -ENOENT;
+
+	sq->xsk.hdr_dma_address = virtio_dma_map(&vi->vdev->dev, &xsk_hdr,
+						 vi->hdr_len, DMA_TO_DEVICE);
+	if (virtio_dma_mapping_error(&vi->vdev->dev, sq->xsk.hdr_dma_address))
+		return -ENOMEM;
+
+	err = xsk_pool_dma_map(pool, &vi->vdev->dev, 0);
+	if (err)
+		goto err_xsk_map;
+
+	err = virtnet_rq_bind_xsk_pool(vi, rq, pool, dev);
+	if (err)
+		goto err_rxq;
+
+	/* Here is already protected by rtnl_lock, so rcu_assign_pointer
+	 * is safe.
+	 */
+	rcu_assign_pointer(sq->xsk.pool, pool);
+
+	return 0;
+
+err_rxq:
+	xsk_pool_dma_unmap(pool, 0);
+err_xsk_map:
+	virtio_dma_unmap(&vi->vdev->dev, sq->xsk.hdr_dma_address, vi->hdr_len,
+			 DMA_TO_DEVICE);
+	return err;
+}
-- 
2.32.0.3.g01195cf9f

