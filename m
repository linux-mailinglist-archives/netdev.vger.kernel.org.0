Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B90786CBB1C
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 11:34:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230174AbjC1Jbp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 05:31:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232715AbjC1JbS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 05:31:18 -0400
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ACB37ABA;
        Tue, 28 Mar 2023 02:29:37 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046051;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0VeseIEo_1679995745;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VeseIEo_1679995745)
          by smtp.aliyun-inc.com;
          Tue, 28 Mar 2023 17:29:05 +0800
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
Subject: [PATCH 16/16] virtio_net: separating the virtio code
Date:   Tue, 28 Mar 2023 17:28:47 +0800
Message-Id: <20230328092847.91643-17-xuanzhuo@linux.alibaba.com>
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

Moving virtio-related functions such as virtio callbacks, virtio driver
register to a separate file.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 drivers/net/virtio/Makefile         |   3 +-
 drivers/net/virtio/virtnet.c        | 884 +---------------------------
 drivers/net/virtio/virtnet.h        |   2 +
 drivers/net/virtio/virtnet_virtio.c | 880 +++++++++++++++++++++++++++
 drivers/net/virtio/virtnet_virtio.h |   8 +
 5 files changed, 895 insertions(+), 882 deletions(-)
 create mode 100644 drivers/net/virtio/virtnet_virtio.c
 create mode 100644 drivers/net/virtio/virtnet_virtio.h

diff --git a/drivers/net/virtio/Makefile b/drivers/net/virtio/Makefile
index 9b35fb00d6c7..6bdc870fa1c8 100644
--- a/drivers/net/virtio/Makefile
+++ b/drivers/net/virtio/Makefile
@@ -6,4 +6,5 @@
 obj-$(CONFIG_VIRTIO_NET) += virtio_net.o
 
 virtio_net-y := virtnet.o virtnet_common.o virtnet_ctrl.o \
-	virtnet_ethtool.o
+	virtnet_ethtool.o \
+	virtnet_virtio.o
diff --git a/drivers/net/virtio/virtnet.c b/drivers/net/virtio/virtnet.c
index 02989cace0fb..ca9d3073ba93 100644
--- a/drivers/net/virtio/virtnet.c
+++ b/drivers/net/virtio/virtnet.c
@@ -4,48 +4,18 @@
  * Copyright 2007 Rusty Russell <rusty@rustcorp.com.au> IBM Corporation
  */
 //#define DEBUG
-#include <linux/netdevice.h>
-#include <linux/etherdevice.h>
-#include <linux/module.h>
-#include <linux/virtio.h>
 #include <linux/virtio_net.h>
-#include <linux/bpf.h>
 #include <linux/bpf_trace.h>
-#include <linux/scatterlist.h>
-#include <linux/if_vlan.h>
-#include <linux/slab.h>
-#include <linux/filter.h>
-#include <linux/kernel.h>
-#include <net/route.h>
 #include <net/xdp.h>
-#include <net/net_failover.h>
 
 #include "virtnet.h"
 #include "virtnet_common.h"
 #include "virtnet_ctrl.h"
 #include "virtnet_ethtool.h"
-
-static int napi_weight = NAPI_POLL_WEIGHT;
-module_param(napi_weight, int, 0444);
-
-static bool csum = true, gso = true, napi_tx = true;
-module_param(csum, bool, 0444);
-module_param(gso, bool, 0444);
-module_param(napi_tx, bool, 0644);
+#include "virtnet_virtio.h"
 
 #define GOOD_COPY_LEN	128
 
-static const unsigned long guest_offloads[] = {
-	VIRTIO_NET_F_GUEST_TSO4,
-	VIRTIO_NET_F_GUEST_TSO6,
-	VIRTIO_NET_F_GUEST_ECN,
-	VIRTIO_NET_F_GUEST_UFO,
-	VIRTIO_NET_F_GUEST_CSUM,
-	VIRTIO_NET_F_GUEST_USO4,
-	VIRTIO_NET_F_GUEST_USO6,
-	VIRTIO_NET_F_GUEST_HDRLEN
-};
-
 #define GUEST_OFFLOAD_GRO_HW_MASK ((1ULL << VIRTIO_NET_F_GUEST_TSO4) | \
 				(1ULL << VIRTIO_NET_F_GUEST_TSO6) | \
 				(1ULL << VIRTIO_NET_F_GUEST_ECN)  | \
@@ -89,21 +59,11 @@ static int vq2txq(struct virtqueue *vq)
 	return (vq->index - 1) / 2;
 }
 
-static int txq2vq(int txq)
-{
-	return txq * 2 + 1;
-}
-
 static int vq2rxq(struct virtqueue *vq)
 {
 	return vq->index / 2;
 }
 
-static int rxq2vq(int rxq)
-{
-	return rxq * 2;
-}
-
 static inline struct virtio_net_hdr_mrg_rxbuf *skb_vnet_hdr(struct sk_buff *skb)
 {
 	return (struct virtio_net_hdr_mrg_rxbuf *)skb->cb;
@@ -1570,7 +1530,7 @@ static void virtnet_poll_cleantx(struct virtnet_rq *rq)
 	}
 }
 
-static int virtnet_poll(struct napi_struct *napi, int budget)
+int virtnet_poll(struct napi_struct *napi, int budget)
 {
 	struct virtnet_rq *rq =
 		container_of(napi, struct virtnet_rq, napi);
@@ -1634,7 +1594,7 @@ static int virtnet_open(struct net_device *dev)
 	return 0;
 }
 
-static int virtnet_poll_tx(struct napi_struct *napi, int budget)
+int virtnet_poll_tx(struct napi_struct *napi, int budget)
 {
 	struct virtnet_sq *sq = container_of(napi, struct virtnet_sq, napi);
 	struct virtnet_info *vi = sq->vq->vdev->priv;
@@ -1949,16 +1909,6 @@ int _virtnet_set_queues(struct virtnet_info *vi, u16 queue_pairs)
 	return 0;
 }
 
-static int virtnet_set_queues(struct virtnet_info *vi, u16 queue_pairs)
-{
-	int err;
-
-	rtnl_lock();
-	err = _virtnet_set_queues(vi, queue_pairs);
-	rtnl_unlock();
-	return err;
-}
-
 static int virtnet_close(struct net_device *dev)
 {
 	struct virtnet_info *vi = netdev_priv(dev);
@@ -1978,96 +1928,6 @@ static int virtnet_close(struct net_device *dev)
 	return 0;
 }
 
-static void virtnet_init_default_rss(struct virtnet_info *vi)
-{
-	u32 indir_val = 0;
-	int i = 0;
-
-	vi->ctrl->rss.hash_types = vi->rss_hash_types_supported;
-	vi->rss_hash_types_saved = vi->rss_hash_types_supported;
-	vi->ctrl->rss.indirection_table_mask = vi->rss_indir_table_size
-						? vi->rss_indir_table_size - 1 : 0;
-	vi->ctrl->rss.unclassified_queue = 0;
-
-	for (; i < vi->rss_indir_table_size; ++i) {
-		indir_val = ethtool_rxfh_indir_default(i, vi->curr_queue_pairs);
-		vi->ctrl->rss.indirection_table[i] = indir_val;
-	}
-
-	vi->ctrl->rss.max_tx_vq = vi->curr_queue_pairs;
-	vi->ctrl->rss.hash_key_length = vi->rss_key_size;
-
-	netdev_rss_key_fill(vi->ctrl->rss.key, vi->rss_key_size);
-}
-
-static void virtnet_init_settings(struct net_device *dev)
-{
-	struct virtnet_info *vi = netdev_priv(dev);
-
-	vi->speed = SPEED_UNKNOWN;
-	vi->duplex = DUPLEX_UNKNOWN;
-}
-
-static void virtnet_update_settings(struct virtnet_info *vi)
-{
-	u32 speed;
-	u8 duplex;
-
-	if (!virtio_has_feature(vi->vdev, VIRTIO_NET_F_SPEED_DUPLEX))
-		return;
-
-	virtio_cread_le(vi->vdev, struct virtio_net_config, speed, &speed);
-
-	if (ethtool_validate_speed(speed))
-		vi->speed = speed;
-
-	virtio_cread_le(vi->vdev, struct virtio_net_config, duplex, &duplex);
-
-	if (ethtool_validate_duplex(duplex))
-		vi->duplex = duplex;
-}
-
-static void virtnet_freeze_down(struct virtio_device *vdev)
-{
-	struct virtnet_info *vi = vdev->priv;
-
-	/* Make sure no work handler is accessing the device */
-	flush_work(&vi->config_work);
-
-	netif_tx_lock_bh(vi->dev);
-	netif_device_detach(vi->dev);
-	netif_tx_unlock_bh(vi->dev);
-	if (netif_running(vi->dev))
-		virtnet_get_netdev()->ndo_stop(vi->dev);
-}
-
-static int init_vqs(struct virtnet_info *vi);
-
-static int virtnet_restore_up(struct virtio_device *vdev)
-{
-	struct virtnet_info *vi = vdev->priv;
-	int err;
-
-	err = init_vqs(vi);
-	if (err)
-		return err;
-
-	virtio_device_ready(vdev);
-
-	virtnet_enable_delayed_refill(vi);
-
-	if (netif_running(vi->dev)) {
-		err = virtnet_get_netdev()->ndo_open(vi->dev);
-		if (err)
-			return err;
-	}
-
-	netif_tx_lock_bh(vi->dev);
-	netif_device_attach(vi->dev);
-	netif_tx_unlock_bh(vi->dev);
-	return err;
-}
-
 static int virtnet_clear_guest_offloads(struct virtnet_info *vi)
 {
 	u64 offloads = 0;
@@ -2308,68 +2168,6 @@ const struct net_device_ops *virtnet_get_netdev(void)
 	return &virtnet_netdev;
 }
 
-static void virtnet_config_changed_work(struct work_struct *work)
-{
-	struct virtnet_info *vi =
-		container_of(work, struct virtnet_info, config_work);
-	u16 v;
-
-	if (virtio_cread_feature(vi->vdev, VIRTIO_NET_F_STATUS,
-				 struct virtio_net_config, status, &v) < 0)
-		return;
-
-	if (v & VIRTIO_NET_S_ANNOUNCE) {
-		netdev_notify_peers(vi->dev);
-
-		rtnl_lock();
-		virtnet_ack_link_announce(vi);
-		rtnl_unlock();
-	}
-
-	/* Ignore unknown (future) status bits */
-	v &= VIRTIO_NET_S_LINK_UP;
-
-	if (vi->status == v)
-		return;
-
-	vi->status = v;
-
-	if (vi->status & VIRTIO_NET_S_LINK_UP) {
-		virtnet_update_settings(vi);
-		netif_carrier_on(vi->dev);
-		netif_tx_wake_all_queues(vi->dev);
-	} else {
-		netif_carrier_off(vi->dev);
-		netif_tx_stop_all_queues(vi->dev);
-	}
-}
-
-static void virtnet_config_changed(struct virtio_device *vdev)
-{
-	struct virtnet_info *vi = vdev->priv;
-
-	schedule_work(&vi->config_work);
-}
-
-static void virtnet_free_queues(struct virtnet_info *vi)
-{
-	int i;
-
-	for (i = 0; i < vi->max_queue_pairs; i++) {
-		__netif_napi_del(&vi->rq[i].napi);
-		__netif_napi_del(&vi->sq[i].napi);
-	}
-
-	/* We called __netif_napi_del(),
-	 * we need to respect an RCU grace period before freeing vi->rq
-	 */
-	synchronize_net();
-
-	kfree(vi->rq);
-	kfree(vi->sq);
-	kfree(vi->ctrl);
-}
-
 static void _free_receive_bufs(struct virtnet_info *vi)
 {
 	struct bpf_prog *old_prog;
@@ -2393,14 +2191,6 @@ static void free_receive_bufs(struct virtnet_info *vi)
 	rtnl_unlock();
 }
 
-static void free_receive_page_frags(struct virtnet_info *vi)
-{
-	int i;
-	for (i = 0; i < vi->max_queue_pairs; i++)
-		if (vi->rq[i].alloc_frag.page)
-			put_page(vi->rq[i].alloc_frag.page);
-}
-
 static void virtnet_sq_free_unused_buf(struct virtqueue *vq, void *buf)
 {
 	if (!is_xdp_frame(buf))
@@ -2440,187 +2230,6 @@ static void free_unused_bufs(struct virtnet_info *vi)
 	}
 }
 
-static void virtnet_del_vqs(struct virtnet_info *vi)
-{
-	struct virtio_device *vdev = vi->vdev;
-
-	virtnet_clean_affinity(vi);
-
-	vdev->config->del_vqs(vdev);
-
-	virtnet_free_queues(vi);
-}
-
-/* How large should a single buffer be so a queue full of these can fit at
- * least one full packet?
- * Logic below assumes the mergeable buffer header is used.
- */
-static unsigned int mergeable_min_buf_len(struct virtnet_info *vi, struct virtqueue *vq)
-{
-	const unsigned int hdr_len = vi->hdr_len;
-	unsigned int rq_size = virtqueue_get_vring_size(vq);
-	unsigned int packet_len = vi->big_packets ? IP_MAX_MTU : vi->dev->max_mtu;
-	unsigned int buf_len = hdr_len + ETH_HLEN + VLAN_HLEN + packet_len;
-	unsigned int min_buf_len = DIV_ROUND_UP(buf_len, rq_size);
-
-	return max(max(min_buf_len, hdr_len) - hdr_len,
-		   (unsigned int)VIRTNET_GOOD_PACKET_LEN);
-}
-
-static int virtnet_find_vqs(struct virtnet_info *vi)
-{
-	vq_callback_t **callbacks;
-	struct virtqueue **vqs;
-	int ret = -ENOMEM;
-	int i, total_vqs;
-	const char **names;
-	bool *ctx;
-
-	/* We expect 1 RX virtqueue followed by 1 TX virtqueue, followed by
-	 * possible N-1 RX/TX queue pairs used in multiqueue mode, followed by
-	 * possible control vq.
-	 */
-	total_vqs = vi->max_queue_pairs * 2 +
-		    virtio_has_feature(vi->vdev, VIRTIO_NET_F_CTRL_VQ);
-
-	/* Allocate space for find_vqs parameters */
-	vqs = kcalloc(total_vqs, sizeof(*vqs), GFP_KERNEL);
-	if (!vqs)
-		goto err_vq;
-	callbacks = kmalloc_array(total_vqs, sizeof(*callbacks), GFP_KERNEL);
-	if (!callbacks)
-		goto err_callback;
-	names = kmalloc_array(total_vqs, sizeof(*names), GFP_KERNEL);
-	if (!names)
-		goto err_names;
-	if (!vi->big_packets || vi->mergeable_rx_bufs) {
-		ctx = kcalloc(total_vqs, sizeof(*ctx), GFP_KERNEL);
-		if (!ctx)
-			goto err_ctx;
-	} else {
-		ctx = NULL;
-	}
-
-	/* Parameters for control virtqueue, if any */
-	if (vi->has_cvq) {
-		callbacks[total_vqs - 1] = NULL;
-		names[total_vqs - 1] = "control";
-	}
-
-	/* Allocate/initialize parameters for send/receive virtqueues */
-	for (i = 0; i < vi->max_queue_pairs; i++) {
-		callbacks[rxq2vq(i)] = virtnet_skb_recv_done;
-		callbacks[txq2vq(i)] = virtnet_skb_xmit_done;
-		sprintf(vi->rq[i].name, "input.%d", i);
-		sprintf(vi->sq[i].name, "output.%d", i);
-		names[rxq2vq(i)] = vi->rq[i].name;
-		names[txq2vq(i)] = vi->sq[i].name;
-		if (ctx)
-			ctx[rxq2vq(i)] = true;
-	}
-
-	ret = virtio_find_vqs_ctx(vi->vdev, total_vqs, vqs, callbacks,
-				  names, ctx, NULL);
-	if (ret)
-		goto err_find;
-
-	if (vi->has_cvq) {
-		vi->cvq = vqs[total_vqs - 1];
-		if (virtio_has_feature(vi->vdev, VIRTIO_NET_F_CTRL_VLAN))
-			vi->dev->features |= NETIF_F_HW_VLAN_CTAG_FILTER;
-	}
-
-	for (i = 0; i < vi->max_queue_pairs; i++) {
-		vi->rq[i].vq = vqs[rxq2vq(i)];
-		vi->rq[i].min_buf_len = mergeable_min_buf_len(vi, vi->rq[i].vq);
-		vi->sq[i].vq = vqs[txq2vq(i)];
-	}
-
-	/* run here: ret == 0. */
-
-
-err_find:
-	kfree(ctx);
-err_ctx:
-	kfree(names);
-err_names:
-	kfree(callbacks);
-err_callback:
-	kfree(vqs);
-err_vq:
-	return ret;
-}
-
-static int virtnet_alloc_queues(struct virtnet_info *vi)
-{
-	int i;
-
-	if (vi->has_cvq) {
-		vi->ctrl = kzalloc(sizeof(*vi->ctrl), GFP_KERNEL);
-		if (!vi->ctrl)
-			goto err_ctrl;
-	} else {
-		vi->ctrl = NULL;
-	}
-	vi->sq = kcalloc(vi->max_queue_pairs, sizeof(*vi->sq), GFP_KERNEL);
-	if (!vi->sq)
-		goto err_sq;
-	vi->rq = kcalloc(vi->max_queue_pairs, sizeof(*vi->rq), GFP_KERNEL);
-	if (!vi->rq)
-		goto err_rq;
-
-	INIT_DELAYED_WORK(&vi->refill, virtnet_refill_work);
-	for (i = 0; i < vi->max_queue_pairs; i++) {
-		vi->rq[i].pages = NULL;
-		netif_napi_add_weight(vi->dev, &vi->rq[i].napi, virtnet_poll,
-				      napi_weight);
-		netif_napi_add_tx_weight(vi->dev, &vi->sq[i].napi,
-					 virtnet_poll_tx,
-					 napi_tx ? napi_weight : 0);
-
-		sg_init_table(vi->rq[i].sg, ARRAY_SIZE(vi->rq[i].sg));
-		ewma_pkt_len_init(&vi->rq[i].mrg_avg_pkt_len);
-		sg_init_table(vi->sq[i].sg, ARRAY_SIZE(vi->sq[i].sg));
-
-		u64_stats_init(&vi->rq[i].stats.syncp);
-		u64_stats_init(&vi->sq[i].stats.syncp);
-	}
-
-	return 0;
-
-err_rq:
-	kfree(vi->sq);
-err_sq:
-	kfree(vi->ctrl);
-err_ctrl:
-	return -ENOMEM;
-}
-
-static int init_vqs(struct virtnet_info *vi)
-{
-	int ret;
-
-	/* Allocate send & receive queues */
-	ret = virtnet_alloc_queues(vi);
-	if (ret)
-		goto err;
-
-	ret = virtnet_find_vqs(vi);
-	if (ret)
-		goto err_free;
-
-	cpus_read_lock();
-	virtnet_set_affinity(vi);
-	cpus_read_unlock();
-
-	return 0;
-
-err_free:
-	virtnet_free_queues(vi);
-err:
-	return ret;
-}
-
 #ifdef CONFIG_SYSFS
 static ssize_t mergeable_rx_buffer_size_show(struct netdev_rx_queue *queue,
 		char *buf)
@@ -2662,373 +2271,6 @@ void virtnet_dev_rx_queue_group(struct virtnet_info *vi, struct net_device *dev)
 }
 #endif
 
-static bool virtnet_fail_on_feature(struct virtio_device *vdev,
-				    unsigned int fbit,
-				    const char *fname, const char *dname)
-{
-	if (!virtio_has_feature(vdev, fbit))
-		return false;
-
-	dev_err(&vdev->dev, "device advertises feature %s but not %s",
-		fname, dname);
-
-	return true;
-}
-
-#define VIRTNET_FAIL_ON(vdev, fbit, dbit)			\
-	virtnet_fail_on_feature(vdev, fbit, #fbit, dbit)
-
-static bool virtnet_validate_features(struct virtio_device *vdev)
-{
-	if (!virtio_has_feature(vdev, VIRTIO_NET_F_CTRL_VQ) &&
-	    (VIRTNET_FAIL_ON(vdev, VIRTIO_NET_F_CTRL_RX,
-			     "VIRTIO_NET_F_CTRL_VQ") ||
-	     VIRTNET_FAIL_ON(vdev, VIRTIO_NET_F_CTRL_VLAN,
-			     "VIRTIO_NET_F_CTRL_VQ") ||
-	     VIRTNET_FAIL_ON(vdev, VIRTIO_NET_F_GUEST_ANNOUNCE,
-			     "VIRTIO_NET_F_CTRL_VQ") ||
-	     VIRTNET_FAIL_ON(vdev, VIRTIO_NET_F_MQ, "VIRTIO_NET_F_CTRL_VQ") ||
-	     VIRTNET_FAIL_ON(vdev, VIRTIO_NET_F_CTRL_MAC_ADDR,
-			     "VIRTIO_NET_F_CTRL_VQ") ||
-	     VIRTNET_FAIL_ON(vdev, VIRTIO_NET_F_RSS,
-			     "VIRTIO_NET_F_CTRL_VQ") ||
-	     VIRTNET_FAIL_ON(vdev, VIRTIO_NET_F_HASH_REPORT,
-			     "VIRTIO_NET_F_CTRL_VQ") ||
-	     VIRTNET_FAIL_ON(vdev, VIRTIO_NET_F_NOTF_COAL,
-			     "VIRTIO_NET_F_CTRL_VQ"))) {
-		return false;
-	}
-
-	return true;
-}
-
-#define MIN_MTU ETH_MIN_MTU
-#define MAX_MTU ETH_MAX_MTU
-
-static int virtnet_validate(struct virtio_device *vdev)
-{
-	if (!vdev->config->get) {
-		dev_err(&vdev->dev, "%s failure: config access disabled\n",
-			__func__);
-		return -EINVAL;
-	}
-
-	if (!virtnet_validate_features(vdev))
-		return -EINVAL;
-
-	if (virtio_has_feature(vdev, VIRTIO_NET_F_MTU)) {
-		int mtu = virtio_cread16(vdev,
-					 offsetof(struct virtio_net_config,
-						  mtu));
-		if (mtu < MIN_MTU)
-			__virtio_clear_bit(vdev, VIRTIO_NET_F_MTU);
-	}
-
-	if (virtio_has_feature(vdev, VIRTIO_NET_F_STANDBY) &&
-	    !virtio_has_feature(vdev, VIRTIO_NET_F_MAC)) {
-		dev_warn(&vdev->dev, "device advertises feature VIRTIO_NET_F_STANDBY but not VIRTIO_NET_F_MAC, disabling standby");
-		__virtio_clear_bit(vdev, VIRTIO_NET_F_STANDBY);
-	}
-
-	return 0;
-}
-
-static bool virtnet_check_guest_gso(const struct virtnet_info *vi)
-{
-	return virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_TSO4) ||
-		virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_TSO6) ||
-		virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_ECN) ||
-		virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_UFO) ||
-		(virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_USO4) &&
-		virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_USO6));
-}
-
-static void virtnet_set_big_packets(struct virtnet_info *vi, const int mtu)
-{
-	bool guest_gso = virtnet_check_guest_gso(vi);
-
-	/* If device can receive ANY guest GSO packets, regardless of mtu,
-	 * allocate packets of maximum size, otherwise limit it to only
-	 * mtu size worth only.
-	 */
-	if (mtu > ETH_DATA_LEN || guest_gso) {
-		vi->big_packets = true;
-		vi->big_packets_num_skbfrags = guest_gso ? MAX_SKB_FRAGS : DIV_ROUND_UP(mtu, PAGE_SIZE);
-	}
-}
-
-static int virtnet_probe(struct virtio_device *vdev)
-{
-	int i, err = -ENOMEM;
-	struct net_device *dev;
-	struct virtnet_info *vi;
-	u16 max_queue_pairs;
-	int mtu = 0;
-
-	/* Find if host supports multiqueue/rss virtio_net device */
-	max_queue_pairs = 1;
-	if (virtio_has_feature(vdev, VIRTIO_NET_F_MQ) || virtio_has_feature(vdev, VIRTIO_NET_F_RSS))
-		max_queue_pairs =
-		     virtio_cread16(vdev, offsetof(struct virtio_net_config, max_virtqueue_pairs));
-
-	/* We need at least 2 queue's */
-	if (max_queue_pairs < VIRTIO_NET_CTRL_MQ_VQ_PAIRS_MIN ||
-	    max_queue_pairs > VIRTIO_NET_CTRL_MQ_VQ_PAIRS_MAX ||
-	    !virtio_has_feature(vdev, VIRTIO_NET_F_CTRL_VQ))
-		max_queue_pairs = 1;
-
-	/* Allocate ourselves a network device with room for our info */
-	dev = alloc_etherdev_mq(sizeof(struct virtnet_info), max_queue_pairs);
-	if (!dev)
-		return -ENOMEM;
-
-	/* Set up network device as normal. */
-	dev->priv_flags |= IFF_UNICAST_FLT | IFF_LIVE_ADDR_CHANGE |
-			   IFF_TX_SKB_NO_LINEAR;
-	dev->netdev_ops = virtnet_get_netdev();
-	dev->features = NETIF_F_HIGHDMA;
-
-	dev->ethtool_ops = virtnet_get_ethtool_ops();
-	SET_NETDEV_DEV(dev, &vdev->dev);
-
-	/* Do we support "hardware" checksums? */
-	if (virtio_has_feature(vdev, VIRTIO_NET_F_CSUM)) {
-		/* This opens up the world of extra features. */
-		dev->hw_features |= NETIF_F_HW_CSUM | NETIF_F_SG;
-		if (csum)
-			dev->features |= NETIF_F_HW_CSUM | NETIF_F_SG;
-
-		if (virtio_has_feature(vdev, VIRTIO_NET_F_GSO)) {
-			dev->hw_features |= NETIF_F_TSO
-				| NETIF_F_TSO_ECN | NETIF_F_TSO6;
-		}
-		/* Individual feature bits: what can host handle? */
-		if (virtio_has_feature(vdev, VIRTIO_NET_F_HOST_TSO4))
-			dev->hw_features |= NETIF_F_TSO;
-		if (virtio_has_feature(vdev, VIRTIO_NET_F_HOST_TSO6))
-			dev->hw_features |= NETIF_F_TSO6;
-		if (virtio_has_feature(vdev, VIRTIO_NET_F_HOST_ECN))
-			dev->hw_features |= NETIF_F_TSO_ECN;
-		if (virtio_has_feature(vdev, VIRTIO_NET_F_HOST_USO))
-			dev->hw_features |= NETIF_F_GSO_UDP_L4;
-
-		dev->features |= NETIF_F_GSO_ROBUST;
-
-		if (gso)
-			dev->features |= dev->hw_features & NETIF_F_ALL_TSO;
-		/* (!csum && gso) case will be fixed by register_netdev() */
-	}
-	if (virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_CSUM))
-		dev->features |= NETIF_F_RXCSUM;
-	if (virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_TSO4) ||
-	    virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_TSO6))
-		dev->features |= NETIF_F_GRO_HW;
-	if (virtio_has_feature(vdev, VIRTIO_NET_F_CTRL_GUEST_OFFLOADS))
-		dev->hw_features |= NETIF_F_GRO_HW;
-
-	dev->vlan_features = dev->features;
-	dev->xdp_features = NETDEV_XDP_ACT_BASIC | NETDEV_XDP_ACT_REDIRECT;
-
-	/* MTU range: 68 - 65535 */
-	dev->min_mtu = MIN_MTU;
-	dev->max_mtu = MAX_MTU;
-
-	/* Configuration may specify what MAC to use.  Otherwise random. */
-	if (virtio_has_feature(vdev, VIRTIO_NET_F_MAC)) {
-		u8 addr[ETH_ALEN];
-
-		virtio_cread_bytes(vdev,
-				   offsetof(struct virtio_net_config, mac),
-				   addr, ETH_ALEN);
-		eth_hw_addr_set(dev, addr);
-	} else {
-		eth_hw_addr_random(dev);
-		dev_info(&vdev->dev, "Assigned random MAC address %pM\n",
-			 dev->dev_addr);
-	}
-
-	/* Set up our device-specific information */
-	vi = netdev_priv(dev);
-	vi->dev = dev;
-	vi->vdev = vdev;
-	vdev->priv = vi;
-
-	INIT_WORK(&vi->config_work, virtnet_config_changed_work);
-	spin_lock_init(&vi->refill_lock);
-
-	if (virtio_has_feature(vdev, VIRTIO_NET_F_MRG_RXBUF)) {
-		vi->mergeable_rx_bufs = true;
-		dev->xdp_features |= NETDEV_XDP_ACT_RX_SG;
-	}
-
-	if (virtio_has_feature(vi->vdev, VIRTIO_NET_F_NOTF_COAL)) {
-		vi->rx_usecs = 0;
-		vi->tx_usecs = 0;
-		vi->tx_max_packets = 0;
-		vi->rx_max_packets = 0;
-	}
-
-	if (virtio_has_feature(vdev, VIRTIO_NET_F_HASH_REPORT))
-		vi->has_rss_hash_report = true;
-
-	if (virtio_has_feature(vdev, VIRTIO_NET_F_RSS))
-		vi->has_rss = true;
-
-	if (vi->has_rss || vi->has_rss_hash_report) {
-		vi->rss_indir_table_size =
-			virtio_cread16(vdev, offsetof(struct virtio_net_config,
-				rss_max_indirection_table_length));
-		vi->rss_key_size =
-			virtio_cread8(vdev, offsetof(struct virtio_net_config, rss_max_key_size));
-
-		vi->rss_hash_types_supported =
-		    virtio_cread32(vdev, offsetof(struct virtio_net_config, supported_hash_types));
-		vi->rss_hash_types_supported &=
-				~(VIRTIO_NET_RSS_HASH_TYPE_IP_EX |
-				  VIRTIO_NET_RSS_HASH_TYPE_TCP_EX |
-				  VIRTIO_NET_RSS_HASH_TYPE_UDP_EX);
-
-		dev->hw_features |= NETIF_F_RXHASH;
-	}
-
-	if (vi->has_rss_hash_report)
-		vi->hdr_len = sizeof(struct virtio_net_hdr_v1_hash);
-	else if (virtio_has_feature(vdev, VIRTIO_NET_F_MRG_RXBUF) ||
-		 virtio_has_feature(vdev, VIRTIO_F_VERSION_1))
-		vi->hdr_len = sizeof(struct virtio_net_hdr_mrg_rxbuf);
-	else
-		vi->hdr_len = sizeof(struct virtio_net_hdr);
-
-	if (virtio_has_feature(vdev, VIRTIO_F_ANY_LAYOUT) ||
-	    virtio_has_feature(vdev, VIRTIO_F_VERSION_1))
-		vi->any_header_sg = true;
-
-	if (virtio_has_feature(vdev, VIRTIO_NET_F_CTRL_VQ))
-		vi->has_cvq = true;
-
-	if (virtio_has_feature(vdev, VIRTIO_NET_F_MTU)) {
-		mtu = virtio_cread16(vdev,
-				     offsetof(struct virtio_net_config,
-					      mtu));
-		if (mtu < dev->min_mtu) {
-			/* Should never trigger: MTU was previously validated
-			 * in virtnet_validate.
-			 */
-			dev_err(&vdev->dev,
-				"device MTU appears to have changed it is now %d < %d",
-				mtu, dev->min_mtu);
-			err = -EINVAL;
-			goto free;
-		}
-
-		dev->mtu = mtu;
-		dev->max_mtu = mtu;
-	}
-
-	virtnet_set_big_packets(vi, mtu);
-
-	if (vi->any_header_sg)
-		dev->needed_headroom = vi->hdr_len;
-
-	/* Enable multiqueue by default */
-	if (num_online_cpus() >= max_queue_pairs)
-		vi->curr_queue_pairs = max_queue_pairs;
-	else
-		vi->curr_queue_pairs = num_online_cpus();
-	vi->max_queue_pairs = max_queue_pairs;
-
-	/* Allocate/initialize the rx/tx queues, and invoke find_vqs */
-	err = init_vqs(vi);
-	if (err)
-		goto free;
-
-	virtnet_dev_rx_queue_group(vi, dev);
-	netif_set_real_num_tx_queues(dev, vi->curr_queue_pairs);
-	netif_set_real_num_rx_queues(dev, vi->curr_queue_pairs);
-
-	virtnet_init_settings(dev);
-
-	if (virtio_has_feature(vdev, VIRTIO_NET_F_STANDBY)) {
-		vi->failover = net_failover_create(vi->dev);
-		if (IS_ERR(vi->failover)) {
-			err = PTR_ERR(vi->failover);
-			goto free_vqs;
-		}
-	}
-
-	if (vi->has_rss || vi->has_rss_hash_report)
-		virtnet_init_default_rss(vi);
-
-	/* serialize netdev register + virtio_device_ready() with ndo_open() */
-	rtnl_lock();
-
-	err = register_netdevice(dev);
-	if (err) {
-		pr_debug("virtio_net: registering device failed\n");
-		rtnl_unlock();
-		goto free_failover;
-	}
-
-	virtio_device_ready(vdev);
-
-	/* a random MAC address has been assigned, notify the device.
-	 * We don't fail probe if VIRTIO_NET_F_CTRL_MAC_ADDR is not there
-	 * because many devices work fine without getting MAC explicitly
-	 */
-	if (!virtio_has_feature(vdev, VIRTIO_NET_F_MAC) &&
-	    virtio_has_feature(vi->vdev, VIRTIO_NET_F_CTRL_MAC_ADDR)) {
-		if (virtnet_ctrl_set_mac_address(vi, dev->dev_addr, dev->addr_len)) {
-			rtnl_unlock();
-			err = -EINVAL;
-			goto free_unregister_netdev;
-		}
-	}
-
-	rtnl_unlock();
-
-	err = virtnet_cpu_notif_add(vi);
-	if (err) {
-		pr_debug("virtio_net: registering cpu notifier failed\n");
-		goto free_unregister_netdev;
-	}
-
-	virtnet_set_queues(vi, vi->curr_queue_pairs);
-
-	/* Assume link up if device can't report link status,
-	   otherwise get link status from config. */
-	netif_carrier_off(dev);
-	if (virtio_has_feature(vi->vdev, VIRTIO_NET_F_STATUS)) {
-		schedule_work(&vi->config_work);
-	} else {
-		vi->status = VIRTIO_NET_S_LINK_UP;
-		virtnet_update_settings(vi);
-		netif_carrier_on(dev);
-	}
-
-	for (i = 0; i < ARRAY_SIZE(guest_offloads); i++)
-		if (virtio_has_feature(vi->vdev, guest_offloads[i]))
-			set_bit(guest_offloads[i], &vi->guest_offloads);
-	vi->guest_offloads_capable = vi->guest_offloads;
-
-	pr_debug("virtnet: registered device %s with %d RX and TX vq's\n",
-		 dev->name, max_queue_pairs);
-
-	return 0;
-
-free_unregister_netdev:
-	unregister_netdev(dev);
-free_failover:
-	net_failover_destroy(vi->failover);
-free_vqs:
-	virtio_reset_device(vdev);
-	cancel_delayed_work_sync(&vi->refill);
-	free_receive_page_frags(vi);
-	virtnet_del_vqs(vi);
-free:
-	free_netdev(dev);
-	return err;
-}
-
 void virtnet_free_bufs(struct virtnet_info *vi)
 {
 	/* Free unused buffers in both send and recv, if any. */
@@ -3037,125 +2279,6 @@ void virtnet_free_bufs(struct virtnet_info *vi)
 	free_receive_bufs(vi);
 }
 
-static void remove_vq_common(struct virtnet_info *vi)
-{
-	virtio_reset_device(vi->vdev);
-
-	virtnet_free_bufs(vi);
-
-	free_receive_page_frags(vi);
-
-	virtnet_del_vqs(vi);
-}
-
-static void virtnet_remove(struct virtio_device *vdev)
-{
-	struct virtnet_info *vi = vdev->priv;
-
-	virtnet_cpu_notif_remove(vi);
-
-	/* Make sure no work handler is accessing the device. */
-	flush_work(&vi->config_work);
-
-	unregister_netdev(vi->dev);
-
-	net_failover_destroy(vi->failover);
-
-	remove_vq_common(vi);
-
-	free_netdev(vi->dev);
-}
-
-static __maybe_unused int virtnet_freeze(struct virtio_device *vdev)
-{
-	struct virtnet_info *vi = vdev->priv;
-
-	virtnet_cpu_notif_remove(vi);
-	virtnet_freeze_down(vdev);
-	remove_vq_common(vi);
-
-	return 0;
-}
-
-static __maybe_unused int virtnet_restore(struct virtio_device *vdev)
-{
-	struct virtnet_info *vi = vdev->priv;
-	int err;
-
-	err = virtnet_restore_up(vdev);
-	if (err)
-		return err;
-	virtnet_set_queues(vi, vi->curr_queue_pairs);
-
-	err = virtnet_cpu_notif_add(vi);
-	if (err) {
-		virtnet_freeze_down(vdev);
-		remove_vq_common(vi);
-		return err;
-	}
-
-	return 0;
-}
-
-static struct virtio_device_id id_table[] = {
-	{ VIRTIO_ID_NET, VIRTIO_DEV_ANY_ID },
-	{ 0 },
-};
-
-#define VIRTNET_FEATURES \
-	VIRTIO_NET_F_CSUM, VIRTIO_NET_F_GUEST_CSUM, \
-	VIRTIO_NET_F_MAC, \
-	VIRTIO_NET_F_HOST_TSO4, VIRTIO_NET_F_HOST_UFO, VIRTIO_NET_F_HOST_TSO6, \
-	VIRTIO_NET_F_HOST_ECN, VIRTIO_NET_F_GUEST_TSO4, VIRTIO_NET_F_GUEST_TSO6, \
-	VIRTIO_NET_F_GUEST_ECN, VIRTIO_NET_F_GUEST_UFO, \
-	VIRTIO_NET_F_HOST_USO, VIRTIO_NET_F_GUEST_USO4, VIRTIO_NET_F_GUEST_USO6, \
-	VIRTIO_NET_F_MRG_RXBUF, VIRTIO_NET_F_STATUS, VIRTIO_NET_F_CTRL_VQ, \
-	VIRTIO_NET_F_CTRL_RX, VIRTIO_NET_F_CTRL_VLAN, \
-	VIRTIO_NET_F_GUEST_ANNOUNCE, VIRTIO_NET_F_MQ, \
-	VIRTIO_NET_F_CTRL_MAC_ADDR, \
-	VIRTIO_NET_F_MTU, VIRTIO_NET_F_CTRL_GUEST_OFFLOADS, \
-	VIRTIO_NET_F_SPEED_DUPLEX, VIRTIO_NET_F_STANDBY, \
-	VIRTIO_NET_F_RSS, VIRTIO_NET_F_HASH_REPORT, VIRTIO_NET_F_NOTF_COAL, \
-	VIRTIO_NET_F_GUEST_HDRLEN
-
-static unsigned int features[] = {
-	VIRTNET_FEATURES,
-};
-
-static unsigned int features_legacy[] = {
-	VIRTNET_FEATURES,
-	VIRTIO_NET_F_GSO,
-	VIRTIO_F_ANY_LAYOUT,
-};
-
-static struct virtio_driver virtio_net_driver = {
-	.feature_table = features,
-	.feature_table_size = ARRAY_SIZE(features),
-	.feature_table_legacy = features_legacy,
-	.feature_table_size_legacy = ARRAY_SIZE(features_legacy),
-	.driver.name =	KBUILD_MODNAME,
-	.driver.owner =	THIS_MODULE,
-	.id_table =	id_table,
-	.validate =	virtnet_validate,
-	.probe =	virtnet_probe,
-	.remove =	virtnet_remove,
-	.config_changed = virtnet_config_changed,
-#ifdef CONFIG_PM_SLEEP
-	.freeze =	virtnet_freeze,
-	.restore =	virtnet_restore,
-#endif
-};
-
-int virtnet_register_virtio_driver(void)
-{
-	return register_virtio_driver(&virtio_net_driver);
-}
-
-void virtnet_unregister_virtio_driver(void)
-{
-	unregister_virtio_driver(&virtio_net_driver);
-}
-
 static __init int virtio_net_driver_init(void)
 {
 	int ret;
@@ -3181,6 +2304,5 @@ static __exit void virtio_net_driver_exit(void)
 }
 module_exit(virtio_net_driver_exit);
 
-MODULE_DEVICE_TABLE(virtio, id_table);
 MODULE_DESCRIPTION("Virtio network driver");
 MODULE_LICENSE("GPL");
diff --git a/drivers/net/virtio/virtnet.h b/drivers/net/virtio/virtnet.h
index 5f20e9103a0e..782654d60357 100644
--- a/drivers/net/virtio/virtnet.h
+++ b/drivers/net/virtio/virtnet.h
@@ -193,6 +193,8 @@ void virtnet_skb_xmit_done(struct virtqueue *vq);
 void virtnet_skb_recv_done(struct virtqueue *rvq);
 void virtnet_refill_work(struct work_struct *work);
 void virtnet_free_bufs(struct virtnet_info *vi);
+int virtnet_poll(struct napi_struct *napi, int budget);
+int virtnet_poll_tx(struct napi_struct *napi, int budget);
 
 static inline void virtnet_enable_delayed_refill(struct virtnet_info *vi)
 {
diff --git a/drivers/net/virtio/virtnet_virtio.c b/drivers/net/virtio/virtnet_virtio.c
new file mode 100644
index 000000000000..31a19dacb3a7
--- /dev/null
+++ b/drivers/net/virtio/virtnet_virtio.c
@@ -0,0 +1,880 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+
+#include <linux/virtio_net.h>
+#include <linux/filter.h>
+#include <net/route.h>
+#include <net/net_failover.h>
+
+#include "virtnet.h"
+#include "virtnet_common.h"
+#include "virtnet_ctrl.h"
+#include "virtnet_ethtool.h"
+#include "virtnet_virtio.h"
+
+static int napi_weight = NAPI_POLL_WEIGHT;
+module_param(napi_weight, int, 0444);
+
+static bool csum = true, gso = true, napi_tx = true;
+module_param(csum, bool, 0444);
+module_param(gso, bool, 0444);
+module_param(napi_tx, bool, 0644);
+
+static const unsigned long guest_offloads[] = {
+	VIRTIO_NET_F_GUEST_TSO4,
+	VIRTIO_NET_F_GUEST_TSO6,
+	VIRTIO_NET_F_GUEST_ECN,
+	VIRTIO_NET_F_GUEST_UFO,
+	VIRTIO_NET_F_GUEST_CSUM,
+	VIRTIO_NET_F_GUEST_USO4,
+	VIRTIO_NET_F_GUEST_USO6,
+	VIRTIO_NET_F_GUEST_HDRLEN
+};
+
+static int txq2vq(int txq)
+{
+	return txq * 2 + 1;
+}
+
+static int rxq2vq(int rxq)
+{
+	return rxq * 2;
+}
+
+static void virtnet_init_default_rss(struct virtnet_info *vi)
+{
+	u32 indir_val = 0;
+	int i = 0;
+
+	vi->ctrl->rss.hash_types = vi->rss_hash_types_supported;
+	vi->rss_hash_types_saved = vi->rss_hash_types_supported;
+	vi->ctrl->rss.indirection_table_mask = vi->rss_indir_table_size
+						? vi->rss_indir_table_size - 1 : 0;
+	vi->ctrl->rss.unclassified_queue = 0;
+
+	for (; i < vi->rss_indir_table_size; ++i) {
+		indir_val = ethtool_rxfh_indir_default(i, vi->curr_queue_pairs);
+		vi->ctrl->rss.indirection_table[i] = indir_val;
+	}
+
+	vi->ctrl->rss.max_tx_vq = vi->curr_queue_pairs;
+	vi->ctrl->rss.hash_key_length = vi->rss_key_size;
+
+	netdev_rss_key_fill(vi->ctrl->rss.key, vi->rss_key_size);
+}
+
+static void virtnet_init_settings(struct net_device *dev)
+{
+	struct virtnet_info *vi = netdev_priv(dev);
+
+	vi->speed = SPEED_UNKNOWN;
+	vi->duplex = DUPLEX_UNKNOWN;
+}
+
+static void virtnet_update_settings(struct virtnet_info *vi)
+{
+	u32 speed;
+	u8 duplex;
+
+	if (!virtio_has_feature(vi->vdev, VIRTIO_NET_F_SPEED_DUPLEX))
+		return;
+
+	virtio_cread_le(vi->vdev, struct virtio_net_config, speed, &speed);
+
+	if (ethtool_validate_speed(speed))
+		vi->speed = speed;
+
+	virtio_cread_le(vi->vdev, struct virtio_net_config, duplex, &duplex);
+
+	if (ethtool_validate_duplex(duplex))
+		vi->duplex = duplex;
+}
+
+static void virtnet_freeze_down(struct virtio_device *vdev)
+{
+	struct virtnet_info *vi = vdev->priv;
+
+	/* Make sure no work handler is accessing the device */
+	flush_work(&vi->config_work);
+
+	netif_tx_lock_bh(vi->dev);
+	netif_device_detach(vi->dev);
+	netif_tx_unlock_bh(vi->dev);
+	if (netif_running(vi->dev))
+		virtnet_get_netdev()->ndo_stop(vi->dev);
+}
+
+static int init_vqs(struct virtnet_info *vi);
+
+static int virtnet_restore_up(struct virtio_device *vdev)
+{
+	struct virtnet_info *vi = vdev->priv;
+	int err;
+
+	err = init_vqs(vi);
+	if (err)
+		return err;
+
+	virtio_device_ready(vdev);
+
+	virtnet_enable_delayed_refill(vi);
+
+	if (netif_running(vi->dev)) {
+		err = virtnet_get_netdev()->ndo_open(vi->dev);
+		if (err)
+			return err;
+	}
+
+	netif_tx_lock_bh(vi->dev);
+	netif_device_attach(vi->dev);
+	netif_tx_unlock_bh(vi->dev);
+	return err;
+}
+
+static void virtnet_config_changed_work(struct work_struct *work)
+{
+	struct virtnet_info *vi =
+		container_of(work, struct virtnet_info, config_work);
+	u16 v;
+
+	if (virtio_cread_feature(vi->vdev, VIRTIO_NET_F_STATUS,
+				 struct virtio_net_config, status, &v) < 0)
+		return;
+
+	if (v & VIRTIO_NET_S_ANNOUNCE) {
+		netdev_notify_peers(vi->dev);
+
+		rtnl_lock();
+		virtnet_ack_link_announce(vi);
+		rtnl_unlock();
+	}
+
+	/* Ignore unknown (future) status bits */
+	v &= VIRTIO_NET_S_LINK_UP;
+
+	if (vi->status == v)
+		return;
+
+	vi->status = v;
+
+	if (vi->status & VIRTIO_NET_S_LINK_UP) {
+		virtnet_update_settings(vi);
+		netif_carrier_on(vi->dev);
+		netif_tx_wake_all_queues(vi->dev);
+	} else {
+		netif_carrier_off(vi->dev);
+		netif_tx_stop_all_queues(vi->dev);
+	}
+}
+
+static void virtnet_config_changed(struct virtio_device *vdev)
+{
+	struct virtnet_info *vi = vdev->priv;
+
+	schedule_work(&vi->config_work);
+}
+
+static void virtnet_free_queues(struct virtnet_info *vi)
+{
+	int i;
+
+	for (i = 0; i < vi->max_queue_pairs; i++) {
+		__netif_napi_del(&vi->rq[i].napi);
+		__netif_napi_del(&vi->sq[i].napi);
+	}
+
+	/* We called __netif_napi_del(),
+	 * we need to respect an RCU grace period before freeing vi->rq
+	 */
+	synchronize_net();
+
+	kfree(vi->rq);
+	kfree(vi->sq);
+	kfree(vi->ctrl);
+}
+
+static void free_receive_page_frags(struct virtnet_info *vi)
+{
+	int i;
+
+	for (i = 0; i < vi->max_queue_pairs; i++)
+		if (vi->rq[i].alloc_frag.page)
+			put_page(vi->rq[i].alloc_frag.page);
+}
+
+static void virtnet_del_vqs(struct virtnet_info *vi)
+{
+	struct virtio_device *vdev = vi->vdev;
+
+	virtnet_clean_affinity(vi);
+
+	vdev->config->del_vqs(vdev);
+
+	virtnet_free_queues(vi);
+}
+
+/* How large should a single buffer be so a queue full of these can fit at
+ * least one full packet?
+ * Logic below assumes the mergeable buffer header is used.
+ */
+static unsigned int mergeable_min_buf_len(struct virtnet_info *vi, struct virtqueue *vq)
+{
+	const unsigned int hdr_len = vi->hdr_len;
+	unsigned int rq_size = virtqueue_get_vring_size(vq);
+	unsigned int packet_len = vi->big_packets ? IP_MAX_MTU : vi->dev->max_mtu;
+	unsigned int buf_len = hdr_len + ETH_HLEN + VLAN_HLEN + packet_len;
+	unsigned int min_buf_len = DIV_ROUND_UP(buf_len, rq_size);
+
+	return max(max(min_buf_len, hdr_len) - hdr_len,
+		   (unsigned int)VIRTNET_GOOD_PACKET_LEN);
+}
+
+static int virtnet_find_vqs(struct virtnet_info *vi)
+{
+	vq_callback_t **callbacks;
+	struct virtqueue **vqs;
+	int ret = -ENOMEM;
+	int i, total_vqs;
+	const char **names;
+	bool *ctx;
+
+	/* We expect 1 RX virtqueue followed by 1 TX virtqueue, followed by
+	 * possible N-1 RX/TX queue pairs used in multiqueue mode, followed by
+	 * possible control vq.
+	 */
+	total_vqs = vi->max_queue_pairs * 2 +
+		    virtio_has_feature(vi->vdev, VIRTIO_NET_F_CTRL_VQ);
+
+	/* Allocate space for find_vqs parameters */
+	vqs = kcalloc(total_vqs, sizeof(*vqs), GFP_KERNEL);
+	if (!vqs)
+		goto err_vq;
+	callbacks = kmalloc_array(total_vqs, sizeof(*callbacks), GFP_KERNEL);
+	if (!callbacks)
+		goto err_callback;
+	names = kmalloc_array(total_vqs, sizeof(*names), GFP_KERNEL);
+	if (!names)
+		goto err_names;
+	if (!vi->big_packets || vi->mergeable_rx_bufs) {
+		ctx = kcalloc(total_vqs, sizeof(*ctx), GFP_KERNEL);
+		if (!ctx)
+			goto err_ctx;
+	} else {
+		ctx = NULL;
+	}
+
+	/* Parameters for control virtqueue, if any */
+	if (vi->has_cvq) {
+		callbacks[total_vqs - 1] = NULL;
+		names[total_vqs - 1] = "control";
+	}
+
+	/* Allocate/initialize parameters for send/receive virtqueues */
+	for (i = 0; i < vi->max_queue_pairs; i++) {
+		callbacks[rxq2vq(i)] = virtnet_skb_recv_done;
+		callbacks[txq2vq(i)] = virtnet_skb_xmit_done;
+		sprintf(vi->rq[i].name, "input.%d", i);
+		sprintf(vi->sq[i].name, "output.%d", i);
+		names[rxq2vq(i)] = vi->rq[i].name;
+		names[txq2vq(i)] = vi->sq[i].name;
+		if (ctx)
+			ctx[rxq2vq(i)] = true;
+	}
+
+	ret = virtio_find_vqs_ctx(vi->vdev, total_vqs, vqs, callbacks,
+				  names, ctx, NULL);
+	if (ret)
+		goto err_find;
+
+	if (vi->has_cvq) {
+		vi->cvq = vqs[total_vqs - 1];
+		if (virtio_has_feature(vi->vdev, VIRTIO_NET_F_CTRL_VLAN))
+			vi->dev->features |= NETIF_F_HW_VLAN_CTAG_FILTER;
+	}
+
+	for (i = 0; i < vi->max_queue_pairs; i++) {
+		vi->rq[i].vq = vqs[rxq2vq(i)];
+		vi->rq[i].min_buf_len = mergeable_min_buf_len(vi, vi->rq[i].vq);
+		vi->sq[i].vq = vqs[txq2vq(i)];
+	}
+
+	/* run here: ret == 0. */
+
+err_find:
+	kfree(ctx);
+err_ctx:
+	kfree(names);
+err_names:
+	kfree(callbacks);
+err_callback:
+	kfree(vqs);
+err_vq:
+	return ret;
+}
+
+static int virtnet_alloc_queues(struct virtnet_info *vi)
+{
+	int i;
+
+	if (vi->has_cvq) {
+		vi->ctrl = kzalloc(sizeof(*vi->ctrl), GFP_KERNEL);
+		if (!vi->ctrl)
+			goto err_ctrl;
+	} else {
+		vi->ctrl = NULL;
+	}
+	vi->sq = kcalloc(vi->max_queue_pairs, sizeof(*vi->sq), GFP_KERNEL);
+	if (!vi->sq)
+		goto err_sq;
+	vi->rq = kcalloc(vi->max_queue_pairs, sizeof(*vi->rq), GFP_KERNEL);
+	if (!vi->rq)
+		goto err_rq;
+
+	INIT_DELAYED_WORK(&vi->refill, virtnet_refill_work);
+	for (i = 0; i < vi->max_queue_pairs; i++) {
+		vi->rq[i].pages = NULL;
+		netif_napi_add_weight(vi->dev, &vi->rq[i].napi, virtnet_poll,
+				      napi_weight);
+		netif_napi_add_tx_weight(vi->dev, &vi->sq[i].napi,
+					 virtnet_poll_tx,
+					 napi_tx ? napi_weight : 0);
+
+		sg_init_table(vi->rq[i].sg, ARRAY_SIZE(vi->rq[i].sg));
+		ewma_pkt_len_init(&vi->rq[i].mrg_avg_pkt_len);
+		sg_init_table(vi->sq[i].sg, ARRAY_SIZE(vi->sq[i].sg));
+
+		u64_stats_init(&vi->rq[i].stats.syncp);
+		u64_stats_init(&vi->sq[i].stats.syncp);
+	}
+
+	return 0;
+
+err_rq:
+	kfree(vi->sq);
+err_sq:
+	kfree(vi->ctrl);
+err_ctrl:
+	return -ENOMEM;
+}
+
+static int init_vqs(struct virtnet_info *vi)
+{
+	int ret;
+
+	/* Allocate send & receive queues */
+	ret = virtnet_alloc_queues(vi);
+	if (ret)
+		goto err;
+
+	ret = virtnet_find_vqs(vi);
+	if (ret)
+		goto err_free;
+
+	cpus_read_lock();
+	virtnet_set_affinity(vi);
+	cpus_read_unlock();
+
+	return 0;
+
+err_free:
+	virtnet_free_queues(vi);
+err:
+	return ret;
+}
+
+static bool virtnet_fail_on_feature(struct virtio_device *vdev,
+				    unsigned int fbit,
+				    const char *fname, const char *dname)
+{
+	if (!virtio_has_feature(vdev, fbit))
+		return false;
+
+	dev_err(&vdev->dev, "device advertises feature %s but not %s",
+		fname, dname);
+
+	return true;
+}
+
+#define VIRTNET_FAIL_ON(vdev, fbit, dbit)			\
+	virtnet_fail_on_feature(vdev, fbit, #fbit, dbit)
+
+static bool virtnet_validate_features(struct virtio_device *vdev)
+{
+	if (!virtio_has_feature(vdev, VIRTIO_NET_F_CTRL_VQ) &&
+	    (VIRTNET_FAIL_ON(vdev, VIRTIO_NET_F_CTRL_RX,
+			     "VIRTIO_NET_F_CTRL_VQ") ||
+	     VIRTNET_FAIL_ON(vdev, VIRTIO_NET_F_CTRL_VLAN,
+			     "VIRTIO_NET_F_CTRL_VQ") ||
+	     VIRTNET_FAIL_ON(vdev, VIRTIO_NET_F_GUEST_ANNOUNCE,
+			     "VIRTIO_NET_F_CTRL_VQ") ||
+	     VIRTNET_FAIL_ON(vdev, VIRTIO_NET_F_MQ, "VIRTIO_NET_F_CTRL_VQ") ||
+	     VIRTNET_FAIL_ON(vdev, VIRTIO_NET_F_CTRL_MAC_ADDR,
+			     "VIRTIO_NET_F_CTRL_VQ") ||
+	     VIRTNET_FAIL_ON(vdev, VIRTIO_NET_F_RSS,
+			     "VIRTIO_NET_F_CTRL_VQ") ||
+	     VIRTNET_FAIL_ON(vdev, VIRTIO_NET_F_HASH_REPORT,
+			     "VIRTIO_NET_F_CTRL_VQ") ||
+	     VIRTNET_FAIL_ON(vdev, VIRTIO_NET_F_NOTF_COAL,
+			     "VIRTIO_NET_F_CTRL_VQ"))) {
+		return false;
+	}
+
+	return true;
+}
+
+#define MIN_MTU ETH_MIN_MTU
+#define MAX_MTU ETH_MAX_MTU
+
+static int virtnet_validate(struct virtio_device *vdev)
+{
+	if (!vdev->config->get) {
+		dev_err(&vdev->dev, "%s failure: config access disabled\n",
+			__func__);
+		return -EINVAL;
+	}
+
+	if (!virtnet_validate_features(vdev))
+		return -EINVAL;
+
+	if (virtio_has_feature(vdev, VIRTIO_NET_F_MTU)) {
+		int mtu = virtio_cread16(vdev,
+					 offsetof(struct virtio_net_config,
+						  mtu));
+		if (mtu < MIN_MTU)
+			__virtio_clear_bit(vdev, VIRTIO_NET_F_MTU);
+	}
+
+	if (virtio_has_feature(vdev, VIRTIO_NET_F_STANDBY) &&
+	    !virtio_has_feature(vdev, VIRTIO_NET_F_MAC)) {
+		dev_warn(&vdev->dev, "device advertises feature VIRTIO_NET_F_STANDBY but not VIRTIO_NET_F_MAC, disabling standby");
+		__virtio_clear_bit(vdev, VIRTIO_NET_F_STANDBY);
+	}
+
+	return 0;
+}
+
+static bool virtnet_check_guest_gso(const struct virtnet_info *vi)
+{
+	return virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_TSO4) ||
+		virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_TSO6) ||
+		virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_ECN) ||
+		virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_UFO) ||
+		(virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_USO4) &&
+		virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_USO6));
+}
+
+static void virtnet_set_big_packets(struct virtnet_info *vi, const int mtu)
+{
+	bool guest_gso = virtnet_check_guest_gso(vi);
+
+	/* If device can receive ANY guest GSO packets, regardless of mtu,
+	 * allocate packets of maximum size, otherwise limit it to only
+	 * mtu size worth only.
+	 */
+	if (mtu > ETH_DATA_LEN || guest_gso) {
+		vi->big_packets = true;
+		vi->big_packets_num_skbfrags = guest_gso ? MAX_SKB_FRAGS : DIV_ROUND_UP(mtu, PAGE_SIZE);
+	}
+}
+
+static int virtnet_set_queues(struct virtnet_info *vi, u16 queue_pairs)
+{
+	int err;
+
+	rtnl_lock();
+	err = _virtnet_set_queues(vi, queue_pairs);
+	rtnl_unlock();
+	return err;
+}
+
+static int virtnet_probe(struct virtio_device *vdev)
+{
+	int i, err = -ENOMEM;
+	struct net_device *dev;
+	struct virtnet_info *vi;
+	u16 max_queue_pairs;
+	int mtu = 0;
+
+	/* Find if host supports multiqueue/rss virtio_net device */
+	max_queue_pairs = 1;
+	if (virtio_has_feature(vdev, VIRTIO_NET_F_MQ) || virtio_has_feature(vdev, VIRTIO_NET_F_RSS))
+		max_queue_pairs =
+		     virtio_cread16(vdev, offsetof(struct virtio_net_config, max_virtqueue_pairs));
+
+	/* We need at least 2 queue's */
+	if (max_queue_pairs < VIRTIO_NET_CTRL_MQ_VQ_PAIRS_MIN ||
+	    max_queue_pairs > VIRTIO_NET_CTRL_MQ_VQ_PAIRS_MAX ||
+	    !virtio_has_feature(vdev, VIRTIO_NET_F_CTRL_VQ))
+		max_queue_pairs = 1;
+
+	/* Allocate ourselves a network device with room for our info */
+	dev = alloc_etherdev_mq(sizeof(struct virtnet_info), max_queue_pairs);
+	if (!dev)
+		return -ENOMEM;
+
+	/* Set up network device as normal. */
+	dev->priv_flags |= IFF_UNICAST_FLT | IFF_LIVE_ADDR_CHANGE |
+			   IFF_TX_SKB_NO_LINEAR;
+	dev->netdev_ops = virtnet_get_netdev();
+	dev->features = NETIF_F_HIGHDMA;
+
+	dev->ethtool_ops = virtnet_get_ethtool_ops();
+	SET_NETDEV_DEV(dev, &vdev->dev);
+
+	/* Do we support "hardware" checksums? */
+	if (virtio_has_feature(vdev, VIRTIO_NET_F_CSUM)) {
+		/* This opens up the world of extra features. */
+		dev->hw_features |= NETIF_F_HW_CSUM | NETIF_F_SG;
+		if (csum)
+			dev->features |= NETIF_F_HW_CSUM | NETIF_F_SG;
+
+		if (virtio_has_feature(vdev, VIRTIO_NET_F_GSO)) {
+			dev->hw_features |= NETIF_F_TSO
+				| NETIF_F_TSO_ECN | NETIF_F_TSO6;
+		}
+		/* Individual feature bits: what can host handle? */
+		if (virtio_has_feature(vdev, VIRTIO_NET_F_HOST_TSO4))
+			dev->hw_features |= NETIF_F_TSO;
+		if (virtio_has_feature(vdev, VIRTIO_NET_F_HOST_TSO6))
+			dev->hw_features |= NETIF_F_TSO6;
+		if (virtio_has_feature(vdev, VIRTIO_NET_F_HOST_ECN))
+			dev->hw_features |= NETIF_F_TSO_ECN;
+		if (virtio_has_feature(vdev, VIRTIO_NET_F_HOST_USO))
+			dev->hw_features |= NETIF_F_GSO_UDP_L4;
+
+		dev->features |= NETIF_F_GSO_ROBUST;
+
+		if (gso)
+			dev->features |= dev->hw_features & NETIF_F_ALL_TSO;
+		/* (!csum && gso) case will be fixed by register_netdev() */
+	}
+	if (virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_CSUM))
+		dev->features |= NETIF_F_RXCSUM;
+	if (virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_TSO4) ||
+	    virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_TSO6))
+		dev->features |= NETIF_F_GRO_HW;
+	if (virtio_has_feature(vdev, VIRTIO_NET_F_CTRL_GUEST_OFFLOADS))
+		dev->hw_features |= NETIF_F_GRO_HW;
+
+	dev->vlan_features = dev->features;
+	dev->xdp_features = NETDEV_XDP_ACT_BASIC | NETDEV_XDP_ACT_REDIRECT;
+
+	/* MTU range: 68 - 65535 */
+	dev->min_mtu = MIN_MTU;
+	dev->max_mtu = MAX_MTU;
+
+	/* Configuration may specify what MAC to use.  Otherwise random. */
+	if (virtio_has_feature(vdev, VIRTIO_NET_F_MAC)) {
+		u8 addr[ETH_ALEN];
+
+		virtio_cread_bytes(vdev,
+				   offsetof(struct virtio_net_config, mac),
+				   addr, ETH_ALEN);
+		eth_hw_addr_set(dev, addr);
+	} else {
+		eth_hw_addr_random(dev);
+		dev_info(&vdev->dev, "Assigned random MAC address %pM\n",
+			 dev->dev_addr);
+	}
+
+	/* Set up our device-specific information */
+	vi = netdev_priv(dev);
+	vi->dev = dev;
+	vi->vdev = vdev;
+	vdev->priv = vi;
+
+	INIT_WORK(&vi->config_work, virtnet_config_changed_work);
+	spin_lock_init(&vi->refill_lock);
+
+	if (virtio_has_feature(vdev, VIRTIO_NET_F_MRG_RXBUF)) {
+		vi->mergeable_rx_bufs = true;
+		dev->xdp_features |= NETDEV_XDP_ACT_RX_SG;
+	}
+
+	if (virtio_has_feature(vi->vdev, VIRTIO_NET_F_NOTF_COAL)) {
+		vi->rx_usecs = 0;
+		vi->tx_usecs = 0;
+		vi->tx_max_packets = 0;
+		vi->rx_max_packets = 0;
+	}
+
+	if (virtio_has_feature(vdev, VIRTIO_NET_F_HASH_REPORT))
+		vi->has_rss_hash_report = true;
+
+	if (virtio_has_feature(vdev, VIRTIO_NET_F_RSS))
+		vi->has_rss = true;
+
+	if (vi->has_rss || vi->has_rss_hash_report) {
+		vi->rss_indir_table_size =
+			virtio_cread16(vdev, offsetof(struct virtio_net_config,
+						      rss_max_indirection_table_length));
+		vi->rss_key_size =
+			virtio_cread8(vdev, offsetof(struct virtio_net_config, rss_max_key_size));
+
+		vi->rss_hash_types_supported =
+		    virtio_cread32(vdev, offsetof(struct virtio_net_config, supported_hash_types));
+		vi->rss_hash_types_supported &=
+				~(VIRTIO_NET_RSS_HASH_TYPE_IP_EX |
+				  VIRTIO_NET_RSS_HASH_TYPE_TCP_EX |
+				  VIRTIO_NET_RSS_HASH_TYPE_UDP_EX);
+
+		dev->hw_features |= NETIF_F_RXHASH;
+	}
+
+	if (vi->has_rss_hash_report)
+		vi->hdr_len = sizeof(struct virtio_net_hdr_v1_hash);
+	else if (virtio_has_feature(vdev, VIRTIO_NET_F_MRG_RXBUF) ||
+		 virtio_has_feature(vdev, VIRTIO_F_VERSION_1))
+		vi->hdr_len = sizeof(struct virtio_net_hdr_mrg_rxbuf);
+	else
+		vi->hdr_len = sizeof(struct virtio_net_hdr);
+
+	if (virtio_has_feature(vdev, VIRTIO_F_ANY_LAYOUT) ||
+	    virtio_has_feature(vdev, VIRTIO_F_VERSION_1))
+		vi->any_header_sg = true;
+
+	if (virtio_has_feature(vdev, VIRTIO_NET_F_CTRL_VQ))
+		vi->has_cvq = true;
+
+	if (virtio_has_feature(vdev, VIRTIO_NET_F_MTU)) {
+		mtu = virtio_cread16(vdev,
+				     offsetof(struct virtio_net_config,
+					      mtu));
+		if (mtu < dev->min_mtu) {
+			/* Should never trigger: MTU was previously validated
+			 * in virtnet_validate.
+			 */
+			dev_err(&vdev->dev,
+				"device MTU appears to have changed it is now %d < %d",
+				mtu, dev->min_mtu);
+			err = -EINVAL;
+			goto free;
+		}
+
+		dev->mtu = mtu;
+		dev->max_mtu = mtu;
+	}
+
+	virtnet_set_big_packets(vi, mtu);
+
+	if (vi->any_header_sg)
+		dev->needed_headroom = vi->hdr_len;
+
+	/* Enable multiqueue by default */
+	if (num_online_cpus() >= max_queue_pairs)
+		vi->curr_queue_pairs = max_queue_pairs;
+	else
+		vi->curr_queue_pairs = num_online_cpus();
+	vi->max_queue_pairs = max_queue_pairs;
+
+	/* Allocate/initialize the rx/tx queues, and invoke find_vqs */
+	err = init_vqs(vi);
+	if (err)
+		goto free;
+
+	virtnet_dev_rx_queue_group(vi, dev);
+	netif_set_real_num_tx_queues(dev, vi->curr_queue_pairs);
+	netif_set_real_num_rx_queues(dev, vi->curr_queue_pairs);
+
+	virtnet_init_settings(dev);
+
+	if (virtio_has_feature(vdev, VIRTIO_NET_F_STANDBY)) {
+		vi->failover = net_failover_create(vi->dev);
+		if (IS_ERR(vi->failover)) {
+			err = PTR_ERR(vi->failover);
+			goto free_vqs;
+		}
+	}
+
+	if (vi->has_rss || vi->has_rss_hash_report)
+		virtnet_init_default_rss(vi);
+
+	/* serialize netdev register + virtio_device_ready() with ndo_open() */
+	rtnl_lock();
+
+	err = register_netdevice(dev);
+	if (err) {
+		pr_debug("virtio_net: registering device failed\n");
+		rtnl_unlock();
+		goto free_failover;
+	}
+
+	virtio_device_ready(vdev);
+
+	/* a random MAC address has been assigned, notify the device.
+	 * We don't fail probe if VIRTIO_NET_F_CTRL_MAC_ADDR is not there
+	 * because many devices work fine without getting MAC explicitly
+	 */
+	if (!virtio_has_feature(vdev, VIRTIO_NET_F_MAC) &&
+	    virtio_has_feature(vi->vdev, VIRTIO_NET_F_CTRL_MAC_ADDR)) {
+		if (virtnet_ctrl_set_mac_address(vi, dev->dev_addr, dev->addr_len)) {
+			rtnl_unlock();
+			err = -EINVAL;
+			goto free_unregister_netdev;
+		}
+	}
+
+	rtnl_unlock();
+
+	err = virtnet_cpu_notif_add(vi);
+	if (err) {
+		pr_debug("virtio_net: registering cpu notifier failed\n");
+		goto free_unregister_netdev;
+	}
+
+	virtnet_set_queues(vi, vi->curr_queue_pairs);
+
+	/* Assume link up if device can't report link status,
+	   otherwise get link status from config. */
+	netif_carrier_off(dev);
+	if (virtio_has_feature(vi->vdev, VIRTIO_NET_F_STATUS)) {
+		schedule_work(&vi->config_work);
+	} else {
+		vi->status = VIRTIO_NET_S_LINK_UP;
+		virtnet_update_settings(vi);
+		netif_carrier_on(dev);
+	}
+
+	for (i = 0; i < ARRAY_SIZE(guest_offloads); i++)
+		if (virtio_has_feature(vi->vdev, guest_offloads[i]))
+			set_bit(guest_offloads[i], &vi->guest_offloads);
+	vi->guest_offloads_capable = vi->guest_offloads;
+
+	pr_debug("virtnet: registered device %s with %d RX and TX vq's\n",
+		 dev->name, max_queue_pairs);
+
+	return 0;
+
+free_unregister_netdev:
+	unregister_netdev(dev);
+free_failover:
+	net_failover_destroy(vi->failover);
+free_vqs:
+	virtio_reset_device(vdev);
+	cancel_delayed_work_sync(&vi->refill);
+	free_receive_page_frags(vi);
+	virtnet_del_vqs(vi);
+free:
+	free_netdev(dev);
+	return err;
+}
+
+static void remove_vq_common(struct virtnet_info *vi)
+{
+	virtio_reset_device(vi->vdev);
+
+	virtnet_free_bufs(vi);
+
+	free_receive_page_frags(vi);
+
+	virtnet_del_vqs(vi);
+}
+
+static void virtnet_remove(struct virtio_device *vdev)
+{
+	struct virtnet_info *vi = vdev->priv;
+
+	virtnet_cpu_notif_remove(vi);
+
+	/* Make sure no work handler is accessing the device. */
+	flush_work(&vi->config_work);
+
+	unregister_netdev(vi->dev);
+
+	net_failover_destroy(vi->failover);
+
+	remove_vq_common(vi);
+
+	free_netdev(vi->dev);
+}
+
+static __maybe_unused int virtnet_freeze(struct virtio_device *vdev)
+{
+	struct virtnet_info *vi = vdev->priv;
+
+	virtnet_cpu_notif_remove(vi);
+	virtnet_freeze_down(vdev);
+	remove_vq_common(vi);
+
+	return 0;
+}
+
+static __maybe_unused int virtnet_restore(struct virtio_device *vdev)
+{
+	struct virtnet_info *vi = vdev->priv;
+	int err;
+
+	err = virtnet_restore_up(vdev);
+	if (err)
+		return err;
+	virtnet_set_queues(vi, vi->curr_queue_pairs);
+
+	err = virtnet_cpu_notif_add(vi);
+	if (err) {
+		virtnet_freeze_down(vdev);
+		remove_vq_common(vi);
+		return err;
+	}
+
+	return 0;
+}
+
+static struct virtio_device_id id_table[] = {
+	{ VIRTIO_ID_NET, VIRTIO_DEV_ANY_ID },
+	{ 0 },
+};
+
+#define VIRTNET_FEATURES \
+	VIRTIO_NET_F_CSUM, VIRTIO_NET_F_GUEST_CSUM, \
+	VIRTIO_NET_F_MAC, \
+	VIRTIO_NET_F_HOST_TSO4, VIRTIO_NET_F_HOST_UFO, VIRTIO_NET_F_HOST_TSO6, \
+	VIRTIO_NET_F_HOST_ECN, VIRTIO_NET_F_GUEST_TSO4, VIRTIO_NET_F_GUEST_TSO6, \
+	VIRTIO_NET_F_GUEST_ECN, VIRTIO_NET_F_GUEST_UFO, \
+	VIRTIO_NET_F_HOST_USO, VIRTIO_NET_F_GUEST_USO4, VIRTIO_NET_F_GUEST_USO6, \
+	VIRTIO_NET_F_MRG_RXBUF, VIRTIO_NET_F_STATUS, VIRTIO_NET_F_CTRL_VQ, \
+	VIRTIO_NET_F_CTRL_RX, VIRTIO_NET_F_CTRL_VLAN, \
+	VIRTIO_NET_F_GUEST_ANNOUNCE, VIRTIO_NET_F_MQ, \
+	VIRTIO_NET_F_CTRL_MAC_ADDR, \
+	VIRTIO_NET_F_MTU, VIRTIO_NET_F_CTRL_GUEST_OFFLOADS, \
+	VIRTIO_NET_F_SPEED_DUPLEX, VIRTIO_NET_F_STANDBY, \
+	VIRTIO_NET_F_RSS, VIRTIO_NET_F_HASH_REPORT, VIRTIO_NET_F_NOTF_COAL, \
+	VIRTIO_NET_F_GUEST_HDRLEN
+
+static unsigned int features[] = {
+	VIRTNET_FEATURES,
+};
+
+static unsigned int features_legacy[] = {
+	VIRTNET_FEATURES,
+	VIRTIO_NET_F_GSO,
+	VIRTIO_F_ANY_LAYOUT,
+};
+
+static struct virtio_driver virtio_net_driver = {
+	.feature_table = features,
+	.feature_table_size = ARRAY_SIZE(features),
+	.feature_table_legacy = features_legacy,
+	.feature_table_size_legacy = ARRAY_SIZE(features_legacy),
+	.driver.name =	KBUILD_MODNAME,
+	.driver.owner =	THIS_MODULE,
+	.id_table =	id_table,
+	.validate =	virtnet_validate,
+	.probe =	virtnet_probe,
+	.remove =	virtnet_remove,
+	.config_changed = virtnet_config_changed,
+#ifdef CONFIG_PM_SLEEP
+	.freeze =	virtnet_freeze,
+	.restore =	virtnet_restore,
+#endif
+};
+
+int virtnet_register_virtio_driver(void)
+{
+	return register_virtio_driver(&virtio_net_driver);
+}
+
+void virtnet_unregister_virtio_driver(void)
+{
+	unregister_virtio_driver(&virtio_net_driver);
+}
+
+MODULE_DEVICE_TABLE(virtio, id_table);
diff --git a/drivers/net/virtio/virtnet_virtio.h b/drivers/net/virtio/virtnet_virtio.h
new file mode 100644
index 000000000000..15be2fdf2cd1
--- /dev/null
+++ b/drivers/net/virtio/virtnet_virtio.h
@@ -0,0 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef __VIRTNET_VIRTIO_H__
+#define __VIRTNET_VIRTIO_H__
+
+int virtnet_register_virtio_driver(void);
+void virtnet_unregister_virtio_driver(void);
+#endif
-- 
2.32.0.3.g01195cf9f

