Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C063B3A26C7
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 10:22:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231250AbhFJIYk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 04:24:40 -0400
Received: from out30-56.freemail.mail.aliyun.com ([115.124.30.56]:55282 "EHLO
        out30-56.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230473AbhFJIYO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 04:24:14 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R561e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=21;SR=0;TI=SMTPD_---0Ubx5.Id_1623313335;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0Ubx5.Id_1623313335)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 10 Jun 2021 16:22:16 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
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
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org,
        "dust . li" <dust.li@linux.alibaba.com>
Subject: [PATCH net-next v5 14/15] virtio-net: xsk direct xmit inside xsk wakeup
Date:   Thu, 10 Jun 2021 16:22:08 +0800
Message-Id: <20210610082209.91487-15-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210610082209.91487-1-xuanzhuo@linux.alibaba.com>
References: <20210610082209.91487-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Calling virtqueue_napi_schedule() in wakeup results in napi running on
the current cpu. If the application is not busy, then there is no
problem. But if the application itself is busy, it will cause a lot of
scheduling.

If the application is continuously sending data packets, due to the
continuous scheduling between the application and napi, the data packet
transmission will not be smooth, and there will be an obvious delay in
the transmission (you can use tcpdump to see it). When pressing a
channel to 100% (vhost reaches 100%), the cpu where the application is
located reaches 100%.

This patch sends a small amount of data directly in wakeup. The purpose
of this is to trigger the tx interrupt. The tx interrupt will be
awakened on the cpu of its affinity, and then trigger the operation of
the napi mechanism, napi can continue to consume the xsk tx queue. Two
cpus are running, cpu0 is running applications, cpu1 executes
napi consumption data. The same is to press a channel to 100%, but the
utilization rate of cpu0 is 12.7% and the utilization rate of cpu1 is
2.9%.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 drivers/net/virtio/xsk.c | 28 +++++++++++++++++++++++-----
 1 file changed, 23 insertions(+), 5 deletions(-)

diff --git a/drivers/net/virtio/xsk.c b/drivers/net/virtio/xsk.c
index 36cda2dcf8e7..3973c82d1ad2 100644
--- a/drivers/net/virtio/xsk.c
+++ b/drivers/net/virtio/xsk.c
@@ -547,6 +547,7 @@ int virtnet_xsk_wakeup(struct net_device *dev, u32 qid, u32 flag)
 {
 	struct virtnet_info *vi = netdev_priv(dev);
 	struct xsk_buff_pool *pool;
+	struct netdev_queue *txq;
 	struct send_queue *sq;
 
 	if (!netif_running(dev))
@@ -559,11 +560,28 @@ int virtnet_xsk_wakeup(struct net_device *dev, u32 qid, u32 flag)
 
 	rcu_read_lock();
 	pool = rcu_dereference(sq->xsk.pool);
-	if (pool) {
-		local_bh_disable();
-		virtqueue_napi_schedule(&sq->napi, sq->vq);
-		local_bh_enable();
-	}
+	if (!pool)
+		goto end;
+
+	if (napi_if_scheduled_mark_missed(&sq->napi))
+		goto end;
+
+	txq = netdev_get_tx_queue(dev, qid);
+
+	__netif_tx_lock_bh(txq);
+
+	/* Send part of the packet directly to reduce the delay in sending the
+	 * packet, and this can actively trigger the tx interrupts.
+	 *
+	 * If no packet is sent out, the ring of the device is full. In this
+	 * case, we will still get a tx interrupt response. Then we will deal
+	 * with the subsequent packet sending work.
+	 */
+	virtnet_xsk_run(sq, pool, sq->napi.weight, false);
+
+	__netif_tx_unlock_bh(txq);
+
+end:
 	rcu_read_unlock();
 	return 0;
 }
-- 
2.31.0

