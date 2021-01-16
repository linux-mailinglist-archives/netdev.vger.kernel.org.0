Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 136152F8ADE
	for <lists+netdev@lfdr.de>; Sat, 16 Jan 2021 04:00:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729324AbhAPDAS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 22:00:18 -0500
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:50380 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729184AbhAPDAS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 22:00:18 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=19;SR=0;TI=SMTPD_---0ULr6UGu_1610765970;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0ULr6UGu_1610765970)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sat, 16 Jan 2021 10:59:30 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     netdev@vger.kernel.org
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
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
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org
Subject: [PATCH net-next v2 6/7] virtio-net, xsk: implement xsk wakeup callback
Date:   Sat, 16 Jan 2021 10:59:27 +0800
Message-Id: <2abdfb0b319d4075b68d50d2be9f441b75735e64.1610765285.git.xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <cover.1610765285.git.xuanzhuo@linux.alibaba.com>
References: <cover.1609837120.git.xuanzhuo@linux.alibaba.com>
 <cover.1610765285.git.xuanzhuo@linux.alibaba.com>
In-Reply-To: <cover.1610765285.git.xuanzhuo@linux.alibaba.com>
References: <cover.1610765285.git.xuanzhuo@linux.alibaba.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since I did not find an interface to directly notify virtio to generate
a tx interrupt, I sent some data to trigger a new tx interrupt.

Another advantage of this is that the transmission delay will be
relatively small, and there is no need to wait for the tx interrupt to
start softirq.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 drivers/net/virtio_net.c | 51 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 51 insertions(+)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 42aa9ad..e552c2d 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -2841,6 +2841,56 @@ static int virtnet_xsk_run(struct send_queue *sq,
 	return ret;
 }
 
+static int virtnet_xsk_wakeup(struct net_device *dev, u32 qid, u32 flag)
+{
+	struct virtnet_info *vi = netdev_priv(dev);
+	struct send_queue *sq;
+	struct xsk_buff_pool *pool;
+	struct netdev_queue *txq;
+
+	if (!netif_running(dev))
+		return -ENETDOWN;
+
+	if (qid >= vi->curr_queue_pairs)
+		return -EINVAL;
+
+	sq = &vi->sq[qid];
+
+	rcu_read_lock();
+
+	pool = rcu_dereference(sq->xsk.pool);
+	if (!pool)
+		goto end;
+
+	if (test_and_set_bit(VIRTNET_STATE_XSK_WAKEUP, &sq->xsk.state))
+		goto end;
+
+	txq = netdev_get_tx_queue(dev, qid);
+
+	local_bh_disable();
+	__netif_tx_lock(txq, raw_smp_processor_id());
+
+	/* Send part of the package directly to reduce the delay in sending the
+	 * package, and this can actively trigger the tx interrupts.
+	 *
+	 * If the package is not processed, then continue processing in the
+	 * subsequent tx interrupt(virtnet_poll_tx).
+	 *
+	 * If no packet is sent out, the ring of the device is full. In this
+	 * case, we will still get a tx interrupt response. Then we will deal
+	 * with the subsequent packet sending work.
+	 */
+
+	virtnet_xsk_run(sq, pool, xsk_budget);
+
+	__netif_tx_unlock(txq);
+	local_bh_enable();
+
+end:
+	rcu_read_unlock();
+	return 0;
+}
+
 static int virtnet_get_phys_port_name(struct net_device *dev, char *buf,
 				      size_t len)
 {
@@ -2895,6 +2945,7 @@ static int virtnet_set_features(struct net_device *dev,
 	.ndo_vlan_rx_kill_vid = virtnet_vlan_rx_kill_vid,
 	.ndo_bpf		= virtnet_xdp,
 	.ndo_xdp_xmit		= virtnet_xdp_xmit,
+	.ndo_xsk_wakeup		= virtnet_xsk_wakeup,
 	.ndo_features_check	= passthru_features_check,
 	.ndo_get_phys_port_name	= virtnet_get_phys_port_name,
 	.ndo_set_features	= virtnet_set_features,
-- 
1.8.3.1

