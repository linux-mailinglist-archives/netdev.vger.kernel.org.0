Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A5F035D5C3
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 05:15:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344369AbhDMDP6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 23:15:58 -0400
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:4136 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344300AbhDMDPr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 23:15:47 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=15;SR=0;TI=SMTPD_---0UVPZqgq_1618283726;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0UVPZqgq_1618283726)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 13 Apr 2021 11:15:26 +0800
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
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org,
        "dust . li" <dust.li@linux.alibaba.com>
Subject: [PATCH net-next v4 07/10] virtio-net: virtnet_poll_tx support budget check
Date:   Tue, 13 Apr 2021 11:15:20 +0800
Message-Id: <20210413031523.73507-8-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210413031523.73507-1-xuanzhuo@linux.alibaba.com>
References: <20210413031523.73507-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

virtnet_poll_tx() check the work done like other network card drivers.

When work < budget, napi_poll() in dev.c will exit directly. And
virtqueue_napi_complete() will be called to close napi. If closing napi
fails or there is still data to be processed, virtqueue_napi_complete()
will make napi schedule again, and no conflicts with the logic of
napi_poll().

When work == budget, virtnet_poll_tx() will return the var 'work', and
the napi_poll() in dev.c will re-add napi to the queue.

The purpose of this patch is to support xsk xmit in virtio_poll_tx for
subsequent patch.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 drivers/net/virtio_net.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index f3752b254965..f52a25091322 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -1529,6 +1529,7 @@ static int virtnet_poll_tx(struct napi_struct *napi, int budget)
 	struct virtnet_info *vi = sq->vq->vdev->priv;
 	unsigned int index = vq2txq(sq->vq);
 	struct netdev_queue *txq;
+	int work_done = 0;
 
 	if (unlikely(is_xdp_raw_buffer_queue(vi, index))) {
 		/* We don't need to enable cb for XDP */
@@ -1541,12 +1542,13 @@ static int virtnet_poll_tx(struct napi_struct *napi, int budget)
 	free_old_xmit(sq, true);
 	__netif_tx_unlock(txq);
 
-	virtqueue_napi_complete(napi, sq->vq, 0);
+	if (work_done < budget)
+		virtqueue_napi_complete(napi, sq->vq, 0);
 
 	if (sq->vq->num_free >= 2 + MAX_SKB_FRAGS)
 		netif_tx_wake_queue(txq);
 
-	return 0;
+	return work_done;
 }
 
 static int xmit_skb(struct send_queue *sq, struct sk_buff *skb)
-- 
2.31.0

