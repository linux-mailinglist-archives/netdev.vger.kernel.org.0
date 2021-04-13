Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C6DB35D5C4
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 05:15:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344377AbhDMDP7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 23:15:59 -0400
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:38989 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344316AbhDMDPs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 23:15:48 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=15;SR=0;TI=SMTPD_---0UVPZqh-_1618283726;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0UVPZqh-_1618283726)
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
Subject: [PATCH net-next v4 08/10] virtio-net: xsk zero copy xmit setup
Date:   Tue, 13 Apr 2021 11:15:21 +0800
Message-Id: <20210413031523.73507-9-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210413031523.73507-1-xuanzhuo@linux.alibaba.com>
References: <20210413031523.73507-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

xsk is a high-performance packet receiving and sending technology.

This patch implements the binding and unbinding operations of xsk and
the virtio-net queue for xsk zero copy xmit.

The xsk zero copy xmit depends on tx napi. So if tx napi is not true,
an error will be reported. And the entire operation is under the
protection of rtnl_lock.

If xsk is active, it will prevent ethtool from modifying tx napi.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Reviewed-by: Dust Li <dust.li@linux.alibaba.com>
---
 drivers/net/virtio_net.c | 78 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 77 insertions(+), 1 deletion(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index f52a25091322..8242a9e9f17d 100644
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
@@ -2249,8 +2255,19 @@ static int virtnet_set_coalesce(struct net_device *dev,
 	if (napi_weight ^ vi->sq[0].napi.weight) {
 		if (dev->flags & IFF_UP)
 			return -EBUSY;
-		for (i = 0; i < vi->max_queue_pairs; i++)
+		for (i = 0; i < vi->max_queue_pairs; i++) {
+			/* xsk xmit depend on the tx napi. So if xsk is active,
+			 * prevent modifications to tx napi.
+			 */
+			rcu_read_lock();
+			if (rcu_dereference(vi->sq[i].xsk.pool)) {
+				rcu_read_unlock();
+				continue;
+			}
+			rcu_read_unlock();
+
 			vi->sq[i].napi.weight = napi_weight;
+		}
 	}
 
 	return 0;
@@ -2518,11 +2535,70 @@ static int virtnet_xdp_set(struct net_device *dev, struct bpf_prog *prog,
 	return err;
 }
 
+static int virtnet_xsk_pool_enable(struct net_device *dev,
+				   struct xsk_buff_pool *pool,
+				   u16 qid)
+{
+	struct virtnet_info *vi = netdev_priv(dev);
+	struct send_queue *sq;
+
+	if (qid >= vi->curr_queue_pairs)
+		return -EINVAL;
+
+	sq = &vi->sq[qid];
+
+	/* xsk zerocopy depend on the tx napi.
+	 *
+	 * xsk zerocopy xmit is driven by the tx interrupt. When the device is
+	 * not busy, napi will be called continuously to send data. When the
+	 * device is busy, wait for the notification interrupt after the
+	 * hardware has finished processing the data, and continue to send data
+	 * in napi.
+	 */
+	if (!sq->napi.weight)
+		return -EPERM;
+
+	rcu_read_lock();
+	/* Here is already protected by rtnl_lock, so rcu_assign_pointer is
+	 * safe.
+	 */
+	rcu_assign_pointer(sq->xsk.pool, pool);
+	rcu_read_unlock();
+
+	return 0;
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
+	synchronize_net(); /* Sync with the XSK wakeup and with NAPI. */
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

