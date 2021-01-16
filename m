Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B13752F8AE7
	for <lists+netdev@lfdr.de>; Sat, 16 Jan 2021 04:02:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729480AbhAPDBG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 22:01:06 -0500
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:44212 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729184AbhAPDBG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 22:01:06 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R601e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=19;SR=0;TI=SMTPD_---0ULr66-0_1610765969;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0ULr66-0_1610765969)
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
Subject: [PATCH net-next v2 4/7] virtio-net, xsk: support xsk enable/disable
Date:   Sat, 16 Jan 2021 10:59:25 +0800
Message-Id: <bf265fef497a84ea7411b51e761228ac912d78b9.1610765285.git.xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <cover.1610765285.git.xuanzhuo@linux.alibaba.com>
References: <cover.1609837120.git.xuanzhuo@linux.alibaba.com>
 <cover.1610765285.git.xuanzhuo@linux.alibaba.com>
In-Reply-To: <cover.1610765285.git.xuanzhuo@linux.alibaba.com>
References: <cover.1610765285.git.xuanzhuo@linux.alibaba.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When enable, a certain number of struct virtnet_xsk_hdr is allocated to
save the information of each packet and virtio hdr.This number is the
limit of the received module parameters.

When struct virtnet_xsk_hdr is used up, or the sq->vq->num_free of
virtio-net is too small, it will be considered that the device is busy.

* xsk_num_max: the xsk.hdr max num
* xsk_num_percent: the max hdr num be the percent of the virtio ring
  size. The real xsk hdr num will the min of xsk_num_max and the percent
  of the num of virtio ring
* xsk_budget: the budget for xsk run

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 drivers/net/virtio_net.c | 97 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 97 insertions(+)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 9013328..a62d456 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -22,10 +22,19 @@
 #include <net/route.h>
 #include <net/xdp.h>
 #include <net/net_failover.h>
+#include <net/xdp_sock_drv.h>
 
 static int napi_weight = NAPI_POLL_WEIGHT;
 module_param(napi_weight, int, 0444);
 
+static int xsk_num_max     = 1024;
+static int xsk_num_percent = 80;
+static int xsk_budget      = 128;
+
+module_param(xsk_num_max,     int, 0644);
+module_param(xsk_num_percent, int, 0644);
+module_param(xsk_budget,      int, 0644);
+
 static bool csum = true, gso = true, napi_tx = true;
 module_param(csum, bool, 0444);
 module_param(gso, bool, 0444);
@@ -149,6 +158,15 @@ struct send_queue {
 	struct virtnet_sq_stats stats;
 
 	struct napi_struct napi;
+
+	struct {
+		struct xsk_buff_pool   __rcu *pool;
+		struct virtnet_xsk_hdr __rcu *hdr;
+
+		u64                    hdr_con;
+		u64                    hdr_pro;
+		u64                    hdr_n;
+	} xsk;
 };
 
 /* Internal representation of a receive virtqueue */
@@ -2540,11 +2558,90 @@ static int virtnet_xdp_set(struct net_device *dev, struct bpf_prog *prog,
 	return err;
 }
 
+static int virtnet_xsk_pool_enable(struct net_device *dev,
+				   struct xsk_buff_pool *pool,
+				   u16 qid)
+{
+	struct virtnet_info *vi = netdev_priv(dev);
+	struct send_queue *sq = &vi->sq[qid];
+	struct virtnet_xsk_hdr *hdr;
+	int n, ret = 0;
+
+	if (qid >= dev->real_num_rx_queues || qid >= dev->real_num_tx_queues)
+		return -EINVAL;
+
+	if (qid >= vi->curr_queue_pairs)
+		return -EINVAL;
+
+	rcu_read_lock();
+
+	ret = -EBUSY;
+	if (rcu_dereference(sq->xsk.pool))
+		goto end;
+
+	/* check last xsk wait for hdr been free */
+	if (rcu_dereference(sq->xsk.hdr))
+		goto end;
+
+	n = virtqueue_get_vring_size(sq->vq);
+	n = min(xsk_num_max, n * (xsk_num_percent % 100) / 100);
+
+	ret = -ENOMEM;
+	hdr = kcalloc(n, sizeof(struct virtnet_xsk_hdr), GFP_ATOMIC);
+	if (!hdr)
+		goto end;
+
+	memset(&sq->xsk, 0, sizeof(sq->xsk));
+
+	sq->xsk.hdr_pro = n;
+	sq->xsk.hdr_n   = n;
+
+	rcu_assign_pointer(sq->xsk.pool, pool);
+	rcu_assign_pointer(sq->xsk.hdr, hdr);
+
+	ret = 0;
+end:
+	rcu_read_unlock();
+
+	return ret;
+}
+
+static int virtnet_xsk_pool_disable(struct net_device *dev, u16 qid)
+{
+	struct virtnet_info *vi = netdev_priv(dev);
+	struct send_queue *sq = &vi->sq[qid];
+	struct virtnet_xsk_hdr *hdr = NULL;
+
+	if (qid >= dev->real_num_rx_queues || qid >= dev->real_num_tx_queues)
+		return -EINVAL;
+
+	if (qid >= vi->curr_queue_pairs)
+		return -EINVAL;
+
+	rcu_assign_pointer(sq->xsk.pool, NULL);
+
+	if (sq->xsk.hdr_pro - sq->xsk.hdr_con == sq->xsk.hdr_n)
+		hdr = rcu_replace_pointer(sq->xsk.hdr, hdr, true);
+
+	synchronize_rcu(); /* Sync with the XSK wakeup and with NAPI. */
+
+	kfree(hdr);
+
+	return 0;
+}
+
 static int virtnet_xdp(struct net_device *dev, struct netdev_bpf *xdp)
 {
 	switch (xdp->command) {
 	case XDP_SETUP_PROG:
 		return virtnet_xdp_set(dev, xdp->prog, xdp->extack);
+	case XDP_SETUP_XSK_POOL:
+		xdp->xsk.need_dma = false;
+		if (xdp->xsk.pool)
+			return virtnet_xsk_pool_enable(dev, xdp->xsk.pool,
+						       xdp->xsk.queue_id);
+		else
+			return virtnet_xsk_pool_disable(dev, xdp->xsk.queue_id);
 	default:
 		return -EINVAL;
 	}
-- 
1.8.3.1

