Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 607D934F985
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 09:12:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233994AbhCaHLs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 03:11:48 -0400
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:60186 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233892AbhCaHLn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Mar 2021 03:11:43 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=20;SR=0;TI=SMTPD_---0UTvslTi_1617174700;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0UTvslTi_1617174700)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 31 Mar 2021 15:11:41 +0800
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
Subject: [PATCH net-next v3 3/8] virtio-net: xsk zero copy xmit setup
Date:   Wed, 31 Mar 2021 15:11:34 +0800
Message-Id: <20210331071139.15473-4-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210331071139.15473-1-xuanzhuo@linux.alibaba.com>
References: <20210331071139.15473-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

xsk is a high-performance packet receiving and sending technology.

This patch implements the binding and unbinding operations of xsk and
the virtio-net queue for xsk zero copy xmit.

The xsk zero copy xmit depends on tx napi. So if tx napi is not opened,
an error will be reported. And the entire operation is under the
protection of rtnl_lock

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Reviewed-by: Dust Li <dust.li@linux.alibaba.com>
---
 drivers/net/virtio_net.c | 66 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 66 insertions(+)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index bb4ea9dbc16b..4e25408a2b37 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -22,6 +22,7 @@
 #include <net/route.h>
 #include <net/xdp.h>
 #include <net/net_failover.h>
+#include <net/xdp_sock_drv.h>
 
 static int napi_weight = NAPI_POLL_WEIGHT;
 module_param(napi_weight, int, 0444);
@@ -133,6 +134,11 @@ struct send_queue {
 	struct virtnet_sq_stats stats;
 
 	struct napi_struct napi;
+
+	struct {
+		/* xsk pool */
+		struct xsk_buff_pool __rcu *pool;
+	} xsk;
 };
 
 /* Internal representation of a receive virtqueue */
@@ -2526,11 +2532,71 @@ static int virtnet_xdp_set(struct net_device *dev, struct bpf_prog *prog,
 	return err;
 }
 
+static int virtnet_xsk_pool_enable(struct net_device *dev,
+				   struct xsk_buff_pool *pool,
+				   u16 qid)
+{
+	struct virtnet_info *vi = netdev_priv(dev);
+	struct send_queue *sq;
+	int ret = -EBUSY;
+
+	if (qid >= vi->curr_queue_pairs)
+		return -EINVAL;
+
+	sq = &vi->sq[qid];
+
+	/* xsk zerocopy depend on the tx napi */
+	if (!sq->napi.weight)
+		return -EPERM;
+
+	rcu_read_lock();
+	if (rcu_dereference(sq->xsk.pool))
+		goto end;
+
+	/* Here is already protected by rtnl_lock, so rcu_assign_pointer is
+	 * safe.
+	 */
+	rcu_assign_pointer(sq->xsk.pool, pool);
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
+	struct send_queue *sq;
+
+	if (qid >= vi->curr_queue_pairs)
+		return -EINVAL;
+
+	sq = &vi->sq[qid];
+
+	/* Here is already protected by rtnl_lock, so rcu_assign_pointer is
+	 * safe.
+	 */
+	rcu_assign_pointer(sq->xsk.pool, NULL);
+
+	synchronize_rcu(); /* Sync with the XSK wakeup and with NAPI. */
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
+		/* virtio net not use dma before call vring api */
+		xdp->xsk.check_dma = false;
+		if (xdp->xsk.pool)
+			return virtnet_xsk_pool_enable(dev, xdp->xsk.pool,
+						       xdp->xsk.queue_id);
+		else
+			return virtnet_xsk_pool_disable(dev, xdp->xsk.queue_id);
 	default:
 		return -EINVAL;
 	}
-- 
2.31.0

