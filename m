Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FEC234F990
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 09:12:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234080AbhCaHM1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 03:12:27 -0400
Received: from out30-56.freemail.mail.aliyun.com ([115.124.30.56]:33645 "EHLO
        out30-56.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233989AbhCaHLt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Mar 2021 03:11:49 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=alimailimapcm10staff010182156082;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=20;SR=0;TI=SMTPD_---0UTwOniS_1617174702;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0UTwOniS_1617174702)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 31 Mar 2021 15:11:42 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     netdev@vger.kernel.org
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org,
        Dust Li <dust.li@linux.alibaba.com>
Subject: [PATCH net-next v3 7/8] virtio-net: poll tx call xsk zerocopy xmit
Date:   Wed, 31 Mar 2021 15:11:38 +0800
Message-Id: <20210331071139.15473-8-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210331071139.15473-1-xuanzhuo@linux.alibaba.com>
References: <20210331071139.15473-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

poll tx call virtnet_xsk_run, then the data in the xsk tx queue will be
continuously consumed by napi.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Reviewed-by: Dust Li <dust.li@linux.alibaba.com>
---
 drivers/net/virtio_net.c | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index d7e95f55478d..fac7d0020013 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -264,6 +264,9 @@ struct padded_vnet_hdr {
 	char padding[4];
 };
 
+static int virtnet_xsk_run(struct send_queue *sq, struct xsk_buff_pool *pool,
+			   int budget, bool in_napi);
+
 static bool is_xdp_frame(void *ptr)
 {
 	return (unsigned long)ptr & VIRTIO_XDP_FLAG;
@@ -1553,7 +1556,9 @@ static int virtnet_poll_tx(struct napi_struct *napi, int budget)
 	struct send_queue *sq = container_of(napi, struct send_queue, napi);
 	struct virtnet_info *vi = sq->vq->vdev->priv;
 	unsigned int index = vq2txq(sq->vq);
+	struct xsk_buff_pool *pool;
 	struct netdev_queue *txq;
+	int work = 0;
 
 	if (unlikely(is_xdp_raw_buffer_queue(vi, index))) {
 		/* We don't need to enable cb for XDP */
@@ -1563,15 +1568,24 @@ static int virtnet_poll_tx(struct napi_struct *napi, int budget)
 
 	txq = netdev_get_tx_queue(vi->dev, index);
 	__netif_tx_lock(txq, raw_smp_processor_id());
-	free_old_xmit_skbs(sq, true);
+	rcu_read_lock();
+	pool = rcu_dereference(sq->xsk.pool);
+	if (pool) {
+		work = virtnet_xsk_run(sq, pool, budget, true);
+		rcu_read_unlock();
+	} else {
+		rcu_read_unlock();
+		free_old_xmit_skbs(sq, true);
+	}
 	__netif_tx_unlock(txq);
 
-	virtqueue_napi_complete(napi, sq->vq, 0);
+	if (work < budget)
+		virtqueue_napi_complete(napi, sq->vq, 0);
 
 	if (sq->vq->num_free >= 2 + MAX_SKB_FRAGS)
 		netif_tx_wake_queue(txq);
 
-	return 0;
+	return work;
 }
 
 static int xmit_skb(struct send_queue *sq, struct sk_buff *skb)
-- 
2.31.0

