Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 774616CBAFD
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 11:31:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232716AbjC1Jag (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 05:30:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232711AbjC1J3l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 05:29:41 -0400
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ABFB6E8D;
        Tue, 28 Mar 2023 02:29:04 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045168;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0VesZtZ6_1679995738;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VesZtZ6_1679995738)
          by smtp.aliyun-inc.com;
          Tue, 28 Mar 2023 17:28:59 +0800
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
Subject: [PATCH 10/16] virtio_net: separating the funcs of ethtool
Date:   Tue, 28 Mar 2023 17:28:41 +0800
Message-Id: <20230328092847.91643-11-xuanzhuo@linux.alibaba.com>
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

Put the functions of ethtool in an independent file.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 drivers/net/virtio/Makefile          |   3 +-
 drivers/net/virtio/virtnet.c         | 573 +-------------------------
 drivers/net/virtio/virtnet.h         |   3 +
 drivers/net/virtio/virtnet_ethtool.c | 578 +++++++++++++++++++++++++++
 drivers/net/virtio/virtnet_ethtool.h |   8 +
 5 files changed, 596 insertions(+), 569 deletions(-)
 create mode 100644 drivers/net/virtio/virtnet_ethtool.c
 create mode 100644 drivers/net/virtio/virtnet_ethtool.h

diff --git a/drivers/net/virtio/Makefile b/drivers/net/virtio/Makefile
index a2d80f95c921..9b35fb00d6c7 100644
--- a/drivers/net/virtio/Makefile
+++ b/drivers/net/virtio/Makefile
@@ -5,4 +5,5 @@
 
 obj-$(CONFIG_VIRTIO_NET) += virtio_net.o
 
-virtio_net-y := virtnet.o virtnet_common.o virtnet_ctrl.o
+virtio_net-y := virtnet.o virtnet_common.o virtnet_ctrl.o \
+	virtnet_ethtool.o
diff --git a/drivers/net/virtio/virtnet.c b/drivers/net/virtio/virtnet.c
index 36c747e43b3f..1323c6733f56 100644
--- a/drivers/net/virtio/virtnet.c
+++ b/drivers/net/virtio/virtnet.c
@@ -23,6 +23,7 @@
 #include "virtnet.h"
 #include "virtnet_common.h"
 #include "virtnet_ctrl.h"
+#include "virtnet_ethtool.h"
 
 static int napi_weight = NAPI_POLL_WEIGHT;
 module_param(napi_weight, int, 0444);
@@ -54,37 +55,6 @@ static const unsigned long guest_offloads[] = {
 				(1ULL << VIRTIO_NET_F_GUEST_USO4) | \
 				(1ULL << VIRTIO_NET_F_GUEST_USO6))
 
-struct virtnet_stat_desc {
-	char desc[ETH_GSTRING_LEN];
-	size_t offset;
-};
-
-#define VIRTNET_SQ_STAT(m)	offsetof(struct virtnet_sq_stats, m)
-#define VIRTNET_RQ_STAT(m)	offsetof(struct virtnet_rq_stats, m)
-
-static const struct virtnet_stat_desc virtnet_sq_stats_desc[] = {
-	{ "packets",		VIRTNET_SQ_STAT(packets) },
-	{ "bytes",		VIRTNET_SQ_STAT(bytes) },
-	{ "xdp_tx",		VIRTNET_SQ_STAT(xdp_tx) },
-	{ "xdp_tx_drops",	VIRTNET_SQ_STAT(xdp_tx_drops) },
-	{ "kicks",		VIRTNET_SQ_STAT(kicks) },
-	{ "tx_timeouts",	VIRTNET_SQ_STAT(tx_timeouts) },
-};
-
-static const struct virtnet_stat_desc virtnet_rq_stats_desc[] = {
-	{ "packets",		VIRTNET_RQ_STAT(packets) },
-	{ "bytes",		VIRTNET_RQ_STAT(bytes) },
-	{ "drops",		VIRTNET_RQ_STAT(drops) },
-	{ "xdp_packets",	VIRTNET_RQ_STAT(xdp_packets) },
-	{ "xdp_tx",		VIRTNET_RQ_STAT(xdp_tx) },
-	{ "xdp_redirects",	VIRTNET_RQ_STAT(xdp_redirects) },
-	{ "xdp_drops",		VIRTNET_RQ_STAT(xdp_drops) },
-	{ "kicks",		VIRTNET_RQ_STAT(kicks) },
-};
-
-#define VIRTNET_SQ_STATS_LEN	ARRAY_SIZE(virtnet_sq_stats_desc)
-#define VIRTNET_RQ_STATS_LEN	ARRAY_SIZE(virtnet_rq_stats_desc)
-
 struct padded_vnet_hdr {
 	struct virtio_net_hdr_v1_hash hdr;
 	/*
@@ -1550,21 +1520,6 @@ static void refill_work(struct work_struct *work)
 	}
 }
 
-static void virtnet_rq_update_stats(struct virtnet_rq *rq, struct virtnet_rq_stats *stats)
-{
-	int i;
-
-	u64_stats_update_begin(&rq->stats.syncp);
-	for (i = 0; i < VIRTNET_RQ_STATS_LEN; i++) {
-		size_t offset = virtnet_rq_stats_desc[i].offset;
-		u64 *item;
-
-		item = (u64 *)((u8 *)&rq->stats + offset);
-		*item += *(u64 *)((u8 *)stats + offset);
-	}
-	u64_stats_update_end(&rq->stats.syncp);
-}
-
 static int virtnet_receive(struct virtnet_rq *rq, int budget,
 			   unsigned int *xdp_xmit)
 {
@@ -1845,8 +1800,7 @@ static netdev_tx_t start_xmit(struct sk_buff *skb, struct net_device *dev)
 	return NETDEV_TX_OK;
 }
 
-static int virtnet_rx_resize(struct virtnet_info *vi,
-			     struct virtnet_rq *rq, u32 ring_num)
+int virtnet_rx_resize(struct virtnet_info *vi, struct virtnet_rq *rq, u32 ring_num)
 {
 	bool running = netif_running(vi->dev);
 	int err, qindex;
@@ -1868,8 +1822,7 @@ static int virtnet_rx_resize(struct virtnet_info *vi,
 	return err;
 }
 
-static int virtnet_tx_resize(struct virtnet_info *vi,
-			     struct virtnet_sq *sq, u32 ring_num)
+int virtnet_tx_resize(struct virtnet_info *vi, struct virtnet_sq *sq, u32 ring_num)
 {
 	bool running = netif_running(vi->dev);
 	struct netdev_queue *txq;
@@ -1991,7 +1944,7 @@ static void virtnet_stats(struct net_device *dev,
 	tot->rx_frame_errors = dev->stats.rx_frame_errors;
 }
 
-static int _virtnet_set_queues(struct virtnet_info *vi, u16 queue_pairs)
+int _virtnet_set_queues(struct virtnet_info *vi, u16 queue_pairs)
 {
 	struct net_device *dev = vi->dev;
 
@@ -2041,66 +1994,6 @@ static int virtnet_close(struct net_device *dev)
 	return 0;
 }
 
-static void virtnet_get_ringparam(struct net_device *dev,
-				  struct ethtool_ringparam *ring,
-				  struct kernel_ethtool_ringparam *kernel_ring,
-				  struct netlink_ext_ack *extack)
-{
-	struct virtnet_info *vi = netdev_priv(dev);
-
-	ring->rx_max_pending = vi->rq[0].vq->num_max;
-	ring->tx_max_pending = vi->sq[0].vq->num_max;
-	ring->rx_pending = virtqueue_get_vring_size(vi->rq[0].vq);
-	ring->tx_pending = virtqueue_get_vring_size(vi->sq[0].vq);
-}
-
-static int virtnet_set_ringparam(struct net_device *dev,
-				 struct ethtool_ringparam *ring,
-				 struct kernel_ethtool_ringparam *kernel_ring,
-				 struct netlink_ext_ack *extack)
-{
-	struct virtnet_info *vi = netdev_priv(dev);
-	u32 rx_pending, tx_pending;
-	struct virtnet_rq *rq;
-	struct virtnet_sq *sq;
-	int i, err;
-
-	if (ring->rx_mini_pending || ring->rx_jumbo_pending)
-		return -EINVAL;
-
-	rx_pending = virtqueue_get_vring_size(vi->rq[0].vq);
-	tx_pending = virtqueue_get_vring_size(vi->sq[0].vq);
-
-	if (ring->rx_pending == rx_pending &&
-	    ring->tx_pending == tx_pending)
-		return 0;
-
-	if (ring->rx_pending > vi->rq[0].vq->num_max)
-		return -EINVAL;
-
-	if (ring->tx_pending > vi->sq[0].vq->num_max)
-		return -EINVAL;
-
-	for (i = 0; i < vi->max_queue_pairs; i++) {
-		rq = vi->rq + i;
-		sq = vi->sq + i;
-
-		if (ring->tx_pending != tx_pending) {
-			err = virtnet_tx_resize(vi, sq, ring->tx_pending);
-			if (err)
-				return err;
-		}
-
-		if (ring->rx_pending != rx_pending) {
-			err = virtnet_rx_resize(vi, rq, ring->rx_pending);
-			if (err)
-				return err;
-		}
-	}
-
-	return 0;
-}
-
 static void virtnet_init_default_rss(struct virtnet_info *vi)
 {
 	u32 indir_val = 0;
@@ -2123,351 +2016,6 @@ static void virtnet_init_default_rss(struct virtnet_info *vi)
 	netdev_rss_key_fill(vi->ctrl->rss.key, vi->rss_key_size);
 }
 
-static void virtnet_get_hashflow(const struct virtnet_info *vi, struct ethtool_rxnfc *info)
-{
-	info->data = 0;
-	switch (info->flow_type) {
-	case TCP_V4_FLOW:
-		if (vi->rss_hash_types_saved & VIRTIO_NET_RSS_HASH_TYPE_TCPv4) {
-			info->data = RXH_IP_SRC | RXH_IP_DST |
-						 RXH_L4_B_0_1 | RXH_L4_B_2_3;
-		} else if (vi->rss_hash_types_saved & VIRTIO_NET_RSS_HASH_TYPE_IPv4) {
-			info->data = RXH_IP_SRC | RXH_IP_DST;
-		}
-		break;
-	case TCP_V6_FLOW:
-		if (vi->rss_hash_types_saved & VIRTIO_NET_RSS_HASH_TYPE_TCPv6) {
-			info->data = RXH_IP_SRC | RXH_IP_DST |
-						 RXH_L4_B_0_1 | RXH_L4_B_2_3;
-		} else if (vi->rss_hash_types_saved & VIRTIO_NET_RSS_HASH_TYPE_IPv6) {
-			info->data = RXH_IP_SRC | RXH_IP_DST;
-		}
-		break;
-	case UDP_V4_FLOW:
-		if (vi->rss_hash_types_saved & VIRTIO_NET_RSS_HASH_TYPE_UDPv4) {
-			info->data = RXH_IP_SRC | RXH_IP_DST |
-						 RXH_L4_B_0_1 | RXH_L4_B_2_3;
-		} else if (vi->rss_hash_types_saved & VIRTIO_NET_RSS_HASH_TYPE_IPv4) {
-			info->data = RXH_IP_SRC | RXH_IP_DST;
-		}
-		break;
-	case UDP_V6_FLOW:
-		if (vi->rss_hash_types_saved & VIRTIO_NET_RSS_HASH_TYPE_UDPv6) {
-			info->data = RXH_IP_SRC | RXH_IP_DST |
-						 RXH_L4_B_0_1 | RXH_L4_B_2_3;
-		} else if (vi->rss_hash_types_saved & VIRTIO_NET_RSS_HASH_TYPE_IPv6) {
-			info->data = RXH_IP_SRC | RXH_IP_DST;
-		}
-		break;
-	case IPV4_FLOW:
-		if (vi->rss_hash_types_saved & VIRTIO_NET_RSS_HASH_TYPE_IPv4)
-			info->data = RXH_IP_SRC | RXH_IP_DST;
-
-		break;
-	case IPV6_FLOW:
-		if (vi->rss_hash_types_saved & VIRTIO_NET_RSS_HASH_TYPE_IPv6)
-			info->data = RXH_IP_SRC | RXH_IP_DST;
-
-		break;
-	default:
-		info->data = 0;
-		break;
-	}
-}
-
-static bool virtnet_set_hashflow(struct virtnet_info *vi, struct ethtool_rxnfc *info)
-{
-	u32 new_hashtypes = vi->rss_hash_types_saved;
-	bool is_disable = info->data & RXH_DISCARD;
-	bool is_l4 = info->data == (RXH_IP_SRC | RXH_IP_DST | RXH_L4_B_0_1 | RXH_L4_B_2_3);
-
-	/* supports only 'sd', 'sdfn' and 'r' */
-	if (!((info->data == (RXH_IP_SRC | RXH_IP_DST)) | is_l4 | is_disable))
-		return false;
-
-	switch (info->flow_type) {
-	case TCP_V4_FLOW:
-		new_hashtypes &= ~(VIRTIO_NET_RSS_HASH_TYPE_IPv4 | VIRTIO_NET_RSS_HASH_TYPE_TCPv4);
-		if (!is_disable)
-			new_hashtypes |= VIRTIO_NET_RSS_HASH_TYPE_IPv4
-				| (is_l4 ? VIRTIO_NET_RSS_HASH_TYPE_TCPv4 : 0);
-		break;
-	case UDP_V4_FLOW:
-		new_hashtypes &= ~(VIRTIO_NET_RSS_HASH_TYPE_IPv4 | VIRTIO_NET_RSS_HASH_TYPE_UDPv4);
-		if (!is_disable)
-			new_hashtypes |= VIRTIO_NET_RSS_HASH_TYPE_IPv4
-				| (is_l4 ? VIRTIO_NET_RSS_HASH_TYPE_UDPv4 : 0);
-		break;
-	case IPV4_FLOW:
-		new_hashtypes &= ~VIRTIO_NET_RSS_HASH_TYPE_IPv4;
-		if (!is_disable)
-			new_hashtypes = VIRTIO_NET_RSS_HASH_TYPE_IPv4;
-		break;
-	case TCP_V6_FLOW:
-		new_hashtypes &= ~(VIRTIO_NET_RSS_HASH_TYPE_IPv6 | VIRTIO_NET_RSS_HASH_TYPE_TCPv6);
-		if (!is_disable)
-			new_hashtypes |= VIRTIO_NET_RSS_HASH_TYPE_IPv6
-				| (is_l4 ? VIRTIO_NET_RSS_HASH_TYPE_TCPv6 : 0);
-		break;
-	case UDP_V6_FLOW:
-		new_hashtypes &= ~(VIRTIO_NET_RSS_HASH_TYPE_IPv6 | VIRTIO_NET_RSS_HASH_TYPE_UDPv6);
-		if (!is_disable)
-			new_hashtypes |= VIRTIO_NET_RSS_HASH_TYPE_IPv6
-				| (is_l4 ? VIRTIO_NET_RSS_HASH_TYPE_UDPv6 : 0);
-		break;
-	case IPV6_FLOW:
-		new_hashtypes &= ~VIRTIO_NET_RSS_HASH_TYPE_IPv6;
-		if (!is_disable)
-			new_hashtypes = VIRTIO_NET_RSS_HASH_TYPE_IPv6;
-		break;
-	default:
-		/* unsupported flow */
-		return false;
-	}
-
-	/* if unsupported hashtype was set */
-	if (new_hashtypes != (new_hashtypes & vi->rss_hash_types_supported))
-		return false;
-
-	if (new_hashtypes != vi->rss_hash_types_saved) {
-		vi->rss_hash_types_saved = new_hashtypes;
-		vi->ctrl->rss.hash_types = vi->rss_hash_types_saved;
-		if (vi->dev->features & NETIF_F_RXHASH)
-			return virtnet_commit_rss_command(vi);
-	}
-
-	return true;
-}
-
-static void virtnet_get_drvinfo(struct net_device *dev,
-				struct ethtool_drvinfo *info)
-{
-	struct virtnet_info *vi = netdev_priv(dev);
-	struct virtio_device *vdev = vi->vdev;
-
-	strscpy(info->driver, KBUILD_MODNAME, sizeof(info->driver));
-	strscpy(info->version, VIRTNET_DRIVER_VERSION, sizeof(info->version));
-	strscpy(info->bus_info, virtio_bus_name(vdev), sizeof(info->bus_info));
-
-}
-
-/* TODO: Eliminate OOO packets during switching */
-static int virtnet_set_channels(struct net_device *dev,
-				struct ethtool_channels *channels)
-{
-	struct virtnet_info *vi = netdev_priv(dev);
-	u16 queue_pairs = channels->combined_count;
-	int err;
-
-	/* We don't support separate rx/tx channels.
-	 * We don't allow setting 'other' channels.
-	 */
-	if (channels->rx_count || channels->tx_count || channels->other_count)
-		return -EINVAL;
-
-	if (queue_pairs > vi->max_queue_pairs || queue_pairs == 0)
-		return -EINVAL;
-
-	/* For now we don't support modifying channels while XDP is loaded
-	 * also when XDP is loaded all RX queues have XDP programs so we only
-	 * need to check a single RX queue.
-	 */
-	if (vi->rq[0].xdp_prog)
-		return -EINVAL;
-
-	cpus_read_lock();
-	err = _virtnet_set_queues(vi, queue_pairs);
-	if (err) {
-		cpus_read_unlock();
-		goto err;
-	}
-	virtnet_set_affinity(vi);
-	cpus_read_unlock();
-
-	netif_set_real_num_tx_queues(dev, queue_pairs);
-	netif_set_real_num_rx_queues(dev, queue_pairs);
- err:
-	return err;
-}
-
-static void virtnet_get_strings(struct net_device *dev, u32 stringset, u8 *data)
-{
-	struct virtnet_info *vi = netdev_priv(dev);
-	unsigned int i, j;
-	u8 *p = data;
-
-	switch (stringset) {
-	case ETH_SS_STATS:
-		for (i = 0; i < vi->curr_queue_pairs; i++) {
-			for (j = 0; j < VIRTNET_RQ_STATS_LEN; j++)
-				ethtool_sprintf(&p, "rx_queue_%u_%s", i,
-						virtnet_rq_stats_desc[j].desc);
-		}
-
-		for (i = 0; i < vi->curr_queue_pairs; i++) {
-			for (j = 0; j < VIRTNET_SQ_STATS_LEN; j++)
-				ethtool_sprintf(&p, "tx_queue_%u_%s", i,
-						virtnet_sq_stats_desc[j].desc);
-		}
-		break;
-	}
-}
-
-static int virtnet_get_sset_count(struct net_device *dev, int sset)
-{
-	struct virtnet_info *vi = netdev_priv(dev);
-
-	switch (sset) {
-	case ETH_SS_STATS:
-		return vi->curr_queue_pairs * (VIRTNET_RQ_STATS_LEN +
-					       VIRTNET_SQ_STATS_LEN);
-	default:
-		return -EOPNOTSUPP;
-	}
-}
-
-static void virtnet_get_ethtool_stats(struct net_device *dev,
-				      struct ethtool_stats *stats, u64 *data)
-{
-	struct virtnet_info *vi = netdev_priv(dev);
-	unsigned int idx = 0, start, i, j;
-	const u8 *stats_base;
-	size_t offset;
-
-	for (i = 0; i < vi->curr_queue_pairs; i++) {
-		struct virtnet_rq *rq = &vi->rq[i];
-
-		stats_base = (u8 *)&rq->stats;
-		do {
-			start = u64_stats_fetch_begin(&rq->stats.syncp);
-			for (j = 0; j < VIRTNET_RQ_STATS_LEN; j++) {
-				offset = virtnet_rq_stats_desc[j].offset;
-				data[idx + j] = *(u64 *)(stats_base + offset);
-			}
-		} while (u64_stats_fetch_retry(&rq->stats.syncp, start));
-		idx += VIRTNET_RQ_STATS_LEN;
-	}
-
-	for (i = 0; i < vi->curr_queue_pairs; i++) {
-		struct virtnet_sq *sq = &vi->sq[i];
-
-		stats_base = (u8 *)&sq->stats;
-		do {
-			start = u64_stats_fetch_begin(&sq->stats.syncp);
-			for (j = 0; j < VIRTNET_SQ_STATS_LEN; j++) {
-				offset = virtnet_sq_stats_desc[j].offset;
-				data[idx + j] = *(u64 *)(stats_base + offset);
-			}
-		} while (u64_stats_fetch_retry(&sq->stats.syncp, start));
-		idx += VIRTNET_SQ_STATS_LEN;
-	}
-}
-
-static void virtnet_get_channels(struct net_device *dev,
-				 struct ethtool_channels *channels)
-{
-	struct virtnet_info *vi = netdev_priv(dev);
-
-	channels->combined_count = vi->curr_queue_pairs;
-	channels->max_combined = vi->max_queue_pairs;
-	channels->max_other = 0;
-	channels->rx_count = 0;
-	channels->tx_count = 0;
-	channels->other_count = 0;
-}
-
-static int virtnet_set_link_ksettings(struct net_device *dev,
-				      const struct ethtool_link_ksettings *cmd)
-{
-	struct virtnet_info *vi = netdev_priv(dev);
-
-	return ethtool_virtdev_set_link_ksettings(dev, cmd,
-						  &vi->speed, &vi->duplex);
-}
-
-static int virtnet_get_link_ksettings(struct net_device *dev,
-				      struct ethtool_link_ksettings *cmd)
-{
-	struct virtnet_info *vi = netdev_priv(dev);
-
-	cmd->base.speed = vi->speed;
-	cmd->base.duplex = vi->duplex;
-	cmd->base.port = PORT_OTHER;
-
-	return 0;
-}
-
-static int virtnet_coal_params_supported(struct ethtool_coalesce *ec)
-{
-	/* usecs coalescing is supported only if VIRTIO_NET_F_NOTF_COAL
-	 * feature is negotiated.
-	 */
-	if (ec->rx_coalesce_usecs || ec->tx_coalesce_usecs)
-		return -EOPNOTSUPP;
-
-	if (ec->tx_max_coalesced_frames > 1 ||
-	    ec->rx_max_coalesced_frames != 1)
-		return -EINVAL;
-
-	return 0;
-}
-
-static int virtnet_set_coalesce(struct net_device *dev,
-				struct ethtool_coalesce *ec,
-				struct kernel_ethtool_coalesce *kernel_coal,
-				struct netlink_ext_ack *extack)
-{
-	struct virtnet_info *vi = netdev_priv(dev);
-	int ret, i, napi_weight;
-	bool update_napi = false;
-
-	/* Can't change NAPI weight if the link is up */
-	napi_weight = ec->tx_max_coalesced_frames ? NAPI_POLL_WEIGHT : 0;
-	if (napi_weight ^ vi->sq[0].napi.weight) {
-		if (dev->flags & IFF_UP)
-			return -EBUSY;
-		else
-			update_napi = true;
-	}
-
-	if (virtio_has_feature(vi->vdev, VIRTIO_NET_F_NOTF_COAL))
-		ret = virtnet_send_notf_coal_cmds(vi, ec);
-	else
-		ret = virtnet_coal_params_supported(ec);
-
-	if (ret)
-		return ret;
-
-	if (update_napi) {
-		for (i = 0; i < vi->max_queue_pairs; i++)
-			vi->sq[i].napi.weight = napi_weight;
-	}
-
-	return ret;
-}
-
-static int virtnet_get_coalesce(struct net_device *dev,
-				struct ethtool_coalesce *ec,
-				struct kernel_ethtool_coalesce *kernel_coal,
-				struct netlink_ext_ack *extack)
-{
-	struct virtnet_info *vi = netdev_priv(dev);
-
-	if (virtio_has_feature(vi->vdev, VIRTIO_NET_F_NOTF_COAL)) {
-		ec->rx_coalesce_usecs = vi->rx_usecs;
-		ec->tx_coalesce_usecs = vi->tx_usecs;
-		ec->tx_max_coalesced_frames = vi->tx_max_packets;
-		ec->rx_max_coalesced_frames = vi->rx_max_packets;
-	} else {
-		ec->rx_max_coalesced_frames = 1;
-
-		if (vi->sq[0].napi.weight)
-			ec->tx_max_coalesced_frames = 1;
-	}
-
-	return 0;
-}
-
 static void virtnet_init_settings(struct net_device *dev)
 {
 	struct virtnet_info *vi = netdev_priv(dev);
@@ -2495,117 +2043,6 @@ static void virtnet_update_settings(struct virtnet_info *vi)
 		vi->duplex = duplex;
 }
 
-static u32 virtnet_get_rxfh_key_size(struct net_device *dev)
-{
-	return ((struct virtnet_info *)netdev_priv(dev))->rss_key_size;
-}
-
-static u32 virtnet_get_rxfh_indir_size(struct net_device *dev)
-{
-	return ((struct virtnet_info *)netdev_priv(dev))->rss_indir_table_size;
-}
-
-static int virtnet_get_rxfh(struct net_device *dev, u32 *indir, u8 *key, u8 *hfunc)
-{
-	struct virtnet_info *vi = netdev_priv(dev);
-	int i;
-
-	if (indir) {
-		for (i = 0; i < vi->rss_indir_table_size; ++i)
-			indir[i] = vi->ctrl->rss.indirection_table[i];
-	}
-
-	if (key)
-		memcpy(key, vi->ctrl->rss.key, vi->rss_key_size);
-
-	if (hfunc)
-		*hfunc = ETH_RSS_HASH_TOP;
-
-	return 0;
-}
-
-static int virtnet_set_rxfh(struct net_device *dev, const u32 *indir, const u8 *key, const u8 hfunc)
-{
-	struct virtnet_info *vi = netdev_priv(dev);
-	int i;
-
-	if (hfunc != ETH_RSS_HASH_NO_CHANGE && hfunc != ETH_RSS_HASH_TOP)
-		return -EOPNOTSUPP;
-
-	if (indir) {
-		for (i = 0; i < vi->rss_indir_table_size; ++i)
-			vi->ctrl->rss.indirection_table[i] = indir[i];
-	}
-	if (key)
-		memcpy(vi->ctrl->rss.key, key, vi->rss_key_size);
-
-	virtnet_commit_rss_command(vi);
-
-	return 0;
-}
-
-static int virtnet_get_rxnfc(struct net_device *dev, struct ethtool_rxnfc *info, u32 *rule_locs)
-{
-	struct virtnet_info *vi = netdev_priv(dev);
-	int rc = 0;
-
-	switch (info->cmd) {
-	case ETHTOOL_GRXRINGS:
-		info->data = vi->curr_queue_pairs;
-		break;
-	case ETHTOOL_GRXFH:
-		virtnet_get_hashflow(vi, info);
-		break;
-	default:
-		rc = -EOPNOTSUPP;
-	}
-
-	return rc;
-}
-
-static int virtnet_set_rxnfc(struct net_device *dev, struct ethtool_rxnfc *info)
-{
-	struct virtnet_info *vi = netdev_priv(dev);
-	int rc = 0;
-
-	switch (info->cmd) {
-	case ETHTOOL_SRXFH:
-		if (!virtnet_set_hashflow(vi, info))
-			rc = -EINVAL;
-
-		break;
-	default:
-		rc = -EOPNOTSUPP;
-	}
-
-	return rc;
-}
-
-static const struct ethtool_ops virtnet_ethtool_ops = {
-	.supported_coalesce_params = ETHTOOL_COALESCE_MAX_FRAMES |
-		ETHTOOL_COALESCE_USECS,
-	.get_drvinfo = virtnet_get_drvinfo,
-	.get_link = ethtool_op_get_link,
-	.get_ringparam = virtnet_get_ringparam,
-	.set_ringparam = virtnet_set_ringparam,
-	.get_strings = virtnet_get_strings,
-	.get_sset_count = virtnet_get_sset_count,
-	.get_ethtool_stats = virtnet_get_ethtool_stats,
-	.set_channels = virtnet_set_channels,
-	.get_channels = virtnet_get_channels,
-	.get_ts_info = ethtool_op_get_ts_info,
-	.get_link_ksettings = virtnet_get_link_ksettings,
-	.set_link_ksettings = virtnet_set_link_ksettings,
-	.set_coalesce = virtnet_set_coalesce,
-	.get_coalesce = virtnet_get_coalesce,
-	.get_rxfh_key_size = virtnet_get_rxfh_key_size,
-	.get_rxfh_indir_size = virtnet_get_rxfh_indir_size,
-	.get_rxfh = virtnet_get_rxfh,
-	.set_rxfh = virtnet_set_rxfh,
-	.get_rxnfc = virtnet_get_rxnfc,
-	.set_rxnfc = virtnet_set_rxnfc,
-};
-
 static void virtnet_freeze_down(struct virtio_device *vdev)
 {
 	struct virtnet_info *vi = vdev->priv;
@@ -3352,7 +2789,7 @@ static int virtnet_probe(struct virtio_device *vdev)
 	dev->netdev_ops = &virtnet_netdev;
 	dev->features = NETIF_F_HIGHDMA;
 
-	dev->ethtool_ops = &virtnet_ethtool_ops;
+	dev->ethtool_ops = virtnet_get_ethtool_ops();
 	SET_NETDEV_DEV(dev, &vdev->dev);
 
 	/* Do we support "hardware" checksums? */
diff --git a/drivers/net/virtio/virtnet.h b/drivers/net/virtio/virtnet.h
index 669e0499f340..b889825c54d0 100644
--- a/drivers/net/virtio/virtnet.h
+++ b/drivers/net/virtio/virtnet.h
@@ -181,4 +181,7 @@ struct virtnet_info {
 	struct failover *failover;
 };
 
+int virtnet_rx_resize(struct virtnet_info *vi, struct virtnet_rq *rq, u32 ring_num);
+int virtnet_tx_resize(struct virtnet_info *vi, struct virtnet_sq *sq, u32 ring_num);
+int _virtnet_set_queues(struct virtnet_info *vi, u16 queue_pairs);
 #endif
diff --git a/drivers/net/virtio/virtnet_ethtool.c b/drivers/net/virtio/virtnet_ethtool.c
new file mode 100644
index 000000000000..ac0595744b4c
--- /dev/null
+++ b/drivers/net/virtio/virtnet_ethtool.c
@@ -0,0 +1,578 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+//
+#include <linux/netdevice.h>
+#include <linux/ethtool.h>
+#include <linux/cpu.h>
+#include <linux/virtio.h>
+#include <linux/virtio_net.h>
+
+#include "virtnet.h"
+#include "virtnet_ctrl.h"
+#include "virtnet_common.h"
+#include "virtnet_ethtool.h"
+
+struct virtnet_stat_desc {
+	char desc[ETH_GSTRING_LEN];
+	size_t offset;
+};
+
+#define VIRTNET_SQ_STAT(m)	offsetof(struct virtnet_sq_stats, m)
+#define VIRTNET_RQ_STAT(m)	offsetof(struct virtnet_rq_stats, m)
+
+static const struct virtnet_stat_desc virtnet_sq_stats_desc[] = {
+	{ "packets",		VIRTNET_SQ_STAT(packets) },
+	{ "bytes",		VIRTNET_SQ_STAT(bytes) },
+	{ "xdp_tx",		VIRTNET_SQ_STAT(xdp_tx) },
+	{ "xdp_tx_drops",	VIRTNET_SQ_STAT(xdp_tx_drops) },
+	{ "kicks",		VIRTNET_SQ_STAT(kicks) },
+	{ "tx_timeouts",	VIRTNET_SQ_STAT(tx_timeouts) },
+};
+
+static const struct virtnet_stat_desc virtnet_rq_stats_desc[] = {
+	{ "packets",		VIRTNET_RQ_STAT(packets) },
+	{ "bytes",		VIRTNET_RQ_STAT(bytes) },
+	{ "drops",		VIRTNET_RQ_STAT(drops) },
+	{ "xdp_packets",	VIRTNET_RQ_STAT(xdp_packets) },
+	{ "xdp_tx",		VIRTNET_RQ_STAT(xdp_tx) },
+	{ "xdp_redirects",	VIRTNET_RQ_STAT(xdp_redirects) },
+	{ "xdp_drops",		VIRTNET_RQ_STAT(xdp_drops) },
+	{ "kicks",		VIRTNET_RQ_STAT(kicks) },
+};
+
+#define VIRTNET_SQ_STATS_LEN	ARRAY_SIZE(virtnet_sq_stats_desc)
+#define VIRTNET_RQ_STATS_LEN	ARRAY_SIZE(virtnet_rq_stats_desc)
+
+void virtnet_rq_update_stats(struct virtnet_rq *rq, struct virtnet_rq_stats *stats)
+{
+	int i;
+
+	u64_stats_update_begin(&rq->stats.syncp);
+	for (i = 0; i < VIRTNET_RQ_STATS_LEN; i++) {
+		size_t offset = virtnet_rq_stats_desc[i].offset;
+		u64 *item;
+
+		item = (u64 *)((u8 *)&rq->stats + offset);
+		*item += *(u64 *)((u8 *)stats + offset);
+	}
+	u64_stats_update_end(&rq->stats.syncp);
+}
+
+static void virtnet_get_ringparam(struct net_device *dev,
+				  struct ethtool_ringparam *ring,
+				  struct kernel_ethtool_ringparam *kernel_ring,
+				  struct netlink_ext_ack *extack)
+{
+	struct virtnet_info *vi = netdev_priv(dev);
+
+	ring->rx_max_pending = vi->rq[0].vq->num_max;
+	ring->tx_max_pending = vi->sq[0].vq->num_max;
+	ring->rx_pending = virtqueue_get_vring_size(vi->rq[0].vq);
+	ring->tx_pending = virtqueue_get_vring_size(vi->sq[0].vq);
+}
+
+static int virtnet_set_ringparam(struct net_device *dev,
+				 struct ethtool_ringparam *ring,
+				 struct kernel_ethtool_ringparam *kernel_ring,
+				 struct netlink_ext_ack *extack)
+{
+	struct virtnet_info *vi = netdev_priv(dev);
+	u32 rx_pending, tx_pending;
+	struct virtnet_rq *rq;
+	struct virtnet_sq *sq;
+	int i, err;
+
+	if (ring->rx_mini_pending || ring->rx_jumbo_pending)
+		return -EINVAL;
+
+	rx_pending = virtqueue_get_vring_size(vi->rq[0].vq);
+	tx_pending = virtqueue_get_vring_size(vi->sq[0].vq);
+
+	if (ring->rx_pending == rx_pending &&
+	    ring->tx_pending == tx_pending)
+		return 0;
+
+	if (ring->rx_pending > vi->rq[0].vq->num_max)
+		return -EINVAL;
+
+	if (ring->tx_pending > vi->sq[0].vq->num_max)
+		return -EINVAL;
+
+	for (i = 0; i < vi->max_queue_pairs; i++) {
+		rq = vi->rq + i;
+		sq = vi->sq + i;
+
+		if (ring->tx_pending != tx_pending) {
+			err = virtnet_tx_resize(vi, sq, ring->tx_pending);
+			if (err)
+				return err;
+		}
+
+		if (ring->rx_pending != rx_pending) {
+			err = virtnet_rx_resize(vi, rq, ring->rx_pending);
+			if (err)
+				return err;
+		}
+	}
+
+	return 0;
+}
+
+static void virtnet_get_hashflow(const struct virtnet_info *vi, struct ethtool_rxnfc *info)
+{
+	info->data = 0;
+	switch (info->flow_type) {
+	case TCP_V4_FLOW:
+		if (vi->rss_hash_types_saved & VIRTIO_NET_RSS_HASH_TYPE_TCPv4) {
+			info->data = RXH_IP_SRC | RXH_IP_DST |
+						 RXH_L4_B_0_1 | RXH_L4_B_2_3;
+		} else if (vi->rss_hash_types_saved & VIRTIO_NET_RSS_HASH_TYPE_IPv4) {
+			info->data = RXH_IP_SRC | RXH_IP_DST;
+		}
+		break;
+	case TCP_V6_FLOW:
+		if (vi->rss_hash_types_saved & VIRTIO_NET_RSS_HASH_TYPE_TCPv6) {
+			info->data = RXH_IP_SRC | RXH_IP_DST |
+						 RXH_L4_B_0_1 | RXH_L4_B_2_3;
+		} else if (vi->rss_hash_types_saved & VIRTIO_NET_RSS_HASH_TYPE_IPv6) {
+			info->data = RXH_IP_SRC | RXH_IP_DST;
+		}
+		break;
+	case UDP_V4_FLOW:
+		if (vi->rss_hash_types_saved & VIRTIO_NET_RSS_HASH_TYPE_UDPv4) {
+			info->data = RXH_IP_SRC | RXH_IP_DST |
+						 RXH_L4_B_0_1 | RXH_L4_B_2_3;
+		} else if (vi->rss_hash_types_saved & VIRTIO_NET_RSS_HASH_TYPE_IPv4) {
+			info->data = RXH_IP_SRC | RXH_IP_DST;
+		}
+		break;
+	case UDP_V6_FLOW:
+		if (vi->rss_hash_types_saved & VIRTIO_NET_RSS_HASH_TYPE_UDPv6) {
+			info->data = RXH_IP_SRC | RXH_IP_DST |
+						 RXH_L4_B_0_1 | RXH_L4_B_2_3;
+		} else if (vi->rss_hash_types_saved & VIRTIO_NET_RSS_HASH_TYPE_IPv6) {
+			info->data = RXH_IP_SRC | RXH_IP_DST;
+		}
+		break;
+	case IPV4_FLOW:
+		if (vi->rss_hash_types_saved & VIRTIO_NET_RSS_HASH_TYPE_IPv4)
+			info->data = RXH_IP_SRC | RXH_IP_DST;
+
+		break;
+	case IPV6_FLOW:
+		if (vi->rss_hash_types_saved & VIRTIO_NET_RSS_HASH_TYPE_IPv6)
+			info->data = RXH_IP_SRC | RXH_IP_DST;
+
+		break;
+	default:
+		info->data = 0;
+		break;
+	}
+}
+
+static bool virtnet_set_hashflow(struct virtnet_info *vi, struct ethtool_rxnfc *info)
+{
+	u32 new_hashtypes = vi->rss_hash_types_saved;
+	bool is_disable = info->data & RXH_DISCARD;
+	bool is_l4 = info->data == (RXH_IP_SRC | RXH_IP_DST | RXH_L4_B_0_1 | RXH_L4_B_2_3);
+
+	/* supports only 'sd', 'sdfn' and 'r' */
+	if (!((info->data == (RXH_IP_SRC | RXH_IP_DST)) | is_l4 | is_disable))
+		return false;
+
+	switch (info->flow_type) {
+	case TCP_V4_FLOW:
+		new_hashtypes &= ~(VIRTIO_NET_RSS_HASH_TYPE_IPv4 | VIRTIO_NET_RSS_HASH_TYPE_TCPv4);
+		if (!is_disable)
+			new_hashtypes |= VIRTIO_NET_RSS_HASH_TYPE_IPv4
+				| (is_l4 ? VIRTIO_NET_RSS_HASH_TYPE_TCPv4 : 0);
+		break;
+	case UDP_V4_FLOW:
+		new_hashtypes &= ~(VIRTIO_NET_RSS_HASH_TYPE_IPv4 | VIRTIO_NET_RSS_HASH_TYPE_UDPv4);
+		if (!is_disable)
+			new_hashtypes |= VIRTIO_NET_RSS_HASH_TYPE_IPv4
+				| (is_l4 ? VIRTIO_NET_RSS_HASH_TYPE_UDPv4 : 0);
+		break;
+	case IPV4_FLOW:
+		new_hashtypes &= ~VIRTIO_NET_RSS_HASH_TYPE_IPv4;
+		if (!is_disable)
+			new_hashtypes = VIRTIO_NET_RSS_HASH_TYPE_IPv4;
+		break;
+	case TCP_V6_FLOW:
+		new_hashtypes &= ~(VIRTIO_NET_RSS_HASH_TYPE_IPv6 | VIRTIO_NET_RSS_HASH_TYPE_TCPv6);
+		if (!is_disable)
+			new_hashtypes |= VIRTIO_NET_RSS_HASH_TYPE_IPv6
+				| (is_l4 ? VIRTIO_NET_RSS_HASH_TYPE_TCPv6 : 0);
+		break;
+	case UDP_V6_FLOW:
+		new_hashtypes &= ~(VIRTIO_NET_RSS_HASH_TYPE_IPv6 | VIRTIO_NET_RSS_HASH_TYPE_UDPv6);
+		if (!is_disable)
+			new_hashtypes |= VIRTIO_NET_RSS_HASH_TYPE_IPv6
+				| (is_l4 ? VIRTIO_NET_RSS_HASH_TYPE_UDPv6 : 0);
+		break;
+	case IPV6_FLOW:
+		new_hashtypes &= ~VIRTIO_NET_RSS_HASH_TYPE_IPv6;
+		if (!is_disable)
+			new_hashtypes = VIRTIO_NET_RSS_HASH_TYPE_IPv6;
+		break;
+	default:
+		/* unsupported flow */
+		return false;
+	}
+
+	/* if unsupported hashtype was set */
+	if (new_hashtypes != (new_hashtypes & vi->rss_hash_types_supported))
+		return false;
+
+	if (new_hashtypes != vi->rss_hash_types_saved) {
+		vi->rss_hash_types_saved = new_hashtypes;
+		vi->ctrl->rss.hash_types = vi->rss_hash_types_saved;
+		if (vi->dev->features & NETIF_F_RXHASH)
+			return virtnet_commit_rss_command(vi);
+	}
+
+	return true;
+}
+
+static void virtnet_get_drvinfo(struct net_device *dev,
+				struct ethtool_drvinfo *info)
+{
+	struct virtnet_info *vi = netdev_priv(dev);
+	struct virtio_device *vdev = vi->vdev;
+
+	strscpy(info->driver, KBUILD_MODNAME, sizeof(info->driver));
+	strscpy(info->version, VIRTNET_DRIVER_VERSION, sizeof(info->version));
+	strscpy(info->bus_info, virtio_bus_name(vdev), sizeof(info->bus_info));
+}
+
+/* TODO: Eliminate OOO packets during switching */
+static int virtnet_set_channels(struct net_device *dev,
+				struct ethtool_channels *channels)
+{
+	struct virtnet_info *vi = netdev_priv(dev);
+	u16 queue_pairs = channels->combined_count;
+	int err;
+
+	/* We don't support separate rx/tx channels.
+	 * We don't allow setting 'other' channels.
+	 */
+	if (channels->rx_count || channels->tx_count || channels->other_count)
+		return -EINVAL;
+
+	if (queue_pairs > vi->max_queue_pairs || queue_pairs == 0)
+		return -EINVAL;
+
+	/* For now we don't support modifying channels while XDP is loaded
+	 * also when XDP is loaded all RX queues have XDP programs so we only
+	 * need to check a single RX queue.
+	 */
+	if (vi->rq[0].xdp_prog)
+		return -EINVAL;
+
+	cpus_read_lock();
+	err = _virtnet_set_queues(vi, queue_pairs);
+	if (err) {
+		cpus_read_unlock();
+		goto err;
+	}
+	virtnet_set_affinity(vi);
+	cpus_read_unlock();
+
+	netif_set_real_num_tx_queues(dev, queue_pairs);
+	netif_set_real_num_rx_queues(dev, queue_pairs);
+ err:
+	return err;
+}
+
+static void virtnet_get_strings(struct net_device *dev, u32 stringset, u8 *data)
+{
+	struct virtnet_info *vi = netdev_priv(dev);
+	unsigned int i, j;
+	u8 *p = data;
+
+	switch (stringset) {
+	case ETH_SS_STATS:
+		for (i = 0; i < vi->curr_queue_pairs; i++) {
+			for (j = 0; j < VIRTNET_RQ_STATS_LEN; j++)
+				ethtool_sprintf(&p, "rx_queue_%u_%s", i,
+						virtnet_rq_stats_desc[j].desc);
+		}
+
+		for (i = 0; i < vi->curr_queue_pairs; i++) {
+			for (j = 0; j < VIRTNET_SQ_STATS_LEN; j++)
+				ethtool_sprintf(&p, "tx_queue_%u_%s", i,
+						virtnet_sq_stats_desc[j].desc);
+		}
+		break;
+	}
+}
+
+static int virtnet_get_sset_count(struct net_device *dev, int sset)
+{
+	struct virtnet_info *vi = netdev_priv(dev);
+
+	switch (sset) {
+	case ETH_SS_STATS:
+		return vi->curr_queue_pairs * (VIRTNET_RQ_STATS_LEN +
+					       VIRTNET_SQ_STATS_LEN);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+static void virtnet_get_ethtool_stats(struct net_device *dev,
+				      struct ethtool_stats *stats, u64 *data)
+{
+	struct virtnet_info *vi = netdev_priv(dev);
+	unsigned int idx = 0, start, i, j;
+	const u8 *stats_base;
+	size_t offset;
+
+	for (i = 0; i < vi->curr_queue_pairs; i++) {
+		struct virtnet_rq *rq = &vi->rq[i];
+
+		stats_base = (u8 *)&rq->stats;
+		do {
+			start = u64_stats_fetch_begin(&rq->stats.syncp);
+			for (j = 0; j < VIRTNET_RQ_STATS_LEN; j++) {
+				offset = virtnet_rq_stats_desc[j].offset;
+				data[idx + j] = *(u64 *)(stats_base + offset);
+			}
+		} while (u64_stats_fetch_retry(&rq->stats.syncp, start));
+		idx += VIRTNET_RQ_STATS_LEN;
+	}
+
+	for (i = 0; i < vi->curr_queue_pairs; i++) {
+		struct virtnet_sq *sq = &vi->sq[i];
+
+		stats_base = (u8 *)&sq->stats;
+		do {
+			start = u64_stats_fetch_begin(&sq->stats.syncp);
+			for (j = 0; j < VIRTNET_SQ_STATS_LEN; j++) {
+				offset = virtnet_sq_stats_desc[j].offset;
+				data[idx + j] = *(u64 *)(stats_base + offset);
+			}
+		} while (u64_stats_fetch_retry(&sq->stats.syncp, start));
+		idx += VIRTNET_SQ_STATS_LEN;
+	}
+}
+
+static void virtnet_get_channels(struct net_device *dev,
+				 struct ethtool_channels *channels)
+{
+	struct virtnet_info *vi = netdev_priv(dev);
+
+	channels->combined_count = vi->curr_queue_pairs;
+	channels->max_combined = vi->max_queue_pairs;
+	channels->max_other = 0;
+	channels->rx_count = 0;
+	channels->tx_count = 0;
+	channels->other_count = 0;
+}
+
+static int virtnet_get_link_ksettings(struct net_device *dev,
+				      struct ethtool_link_ksettings *cmd)
+{
+	struct virtnet_info *vi = netdev_priv(dev);
+
+	cmd->base.speed = vi->speed;
+	cmd->base.duplex = vi->duplex;
+	cmd->base.port = PORT_OTHER;
+
+	return 0;
+}
+
+static int virtnet_set_link_ksettings(struct net_device *dev,
+				      const struct ethtool_link_ksettings *cmd)
+{
+	struct virtnet_info *vi = netdev_priv(dev);
+
+	return ethtool_virtdev_set_link_ksettings(dev, cmd,
+						  &vi->speed, &vi->duplex);
+}
+
+static int virtnet_coal_params_supported(struct ethtool_coalesce *ec)
+{
+	/* usecs coalescing is supported only if VIRTIO_NET_F_NOTF_COAL
+	 * feature is negotiated.
+	 */
+	if (ec->rx_coalesce_usecs || ec->tx_coalesce_usecs)
+		return -EOPNOTSUPP;
+
+	if (ec->tx_max_coalesced_frames > 1 ||
+	    ec->rx_max_coalesced_frames != 1)
+		return -EINVAL;
+
+	return 0;
+}
+
+static int virtnet_set_coalesce(struct net_device *dev,
+				struct ethtool_coalesce *ec,
+				struct kernel_ethtool_coalesce *kernel_coal,
+				struct netlink_ext_ack *extack)
+{
+	struct virtnet_info *vi = netdev_priv(dev);
+	int ret, i, napi_weight;
+	bool update_napi = false;
+
+	/* Can't change NAPI weight if the link is up */
+	napi_weight = ec->tx_max_coalesced_frames ? NAPI_POLL_WEIGHT : 0;
+	if (napi_weight ^ vi->sq[0].napi.weight) {
+		if (dev->flags & IFF_UP)
+			return -EBUSY;
+		else
+			update_napi = true;
+	}
+
+	if (virtio_has_feature(vi->vdev, VIRTIO_NET_F_NOTF_COAL))
+		ret = virtnet_send_notf_coal_cmds(vi, ec);
+	else
+		ret = virtnet_coal_params_supported(ec);
+
+	if (ret)
+		return ret;
+
+	if (update_napi) {
+		for (i = 0; i < vi->max_queue_pairs; i++)
+			vi->sq[i].napi.weight = napi_weight;
+	}
+
+	return ret;
+}
+
+static int virtnet_get_coalesce(struct net_device *dev,
+				struct ethtool_coalesce *ec,
+				struct kernel_ethtool_coalesce *kernel_coal,
+				struct netlink_ext_ack *extack)
+{
+	struct virtnet_info *vi = netdev_priv(dev);
+
+	if (virtio_has_feature(vi->vdev, VIRTIO_NET_F_NOTF_COAL)) {
+		ec->rx_coalesce_usecs = vi->rx_usecs;
+		ec->tx_coalesce_usecs = vi->tx_usecs;
+		ec->tx_max_coalesced_frames = vi->tx_max_packets;
+		ec->rx_max_coalesced_frames = vi->rx_max_packets;
+	} else {
+		ec->rx_max_coalesced_frames = 1;
+
+		if (vi->sq[0].napi.weight)
+			ec->tx_max_coalesced_frames = 1;
+	}
+
+	return 0;
+}
+
+static u32 virtnet_get_rxfh_key_size(struct net_device *dev)
+{
+	return ((struct virtnet_info *)netdev_priv(dev))->rss_key_size;
+}
+
+static u32 virtnet_get_rxfh_indir_size(struct net_device *dev)
+{
+	return ((struct virtnet_info *)netdev_priv(dev))->rss_indir_table_size;
+}
+
+static int virtnet_get_rxfh(struct net_device *dev, u32 *indir, u8 *key, u8 *hfunc)
+{
+	struct virtnet_info *vi = netdev_priv(dev);
+	int i;
+
+	if (indir) {
+		for (i = 0; i < vi->rss_indir_table_size; ++i)
+			indir[i] = vi->ctrl->rss.indirection_table[i];
+	}
+
+	if (key)
+		memcpy(key, vi->ctrl->rss.key, vi->rss_key_size);
+
+	if (hfunc)
+		*hfunc = ETH_RSS_HASH_TOP;
+
+	return 0;
+}
+
+static int virtnet_set_rxfh(struct net_device *dev, const u32 *indir, const u8 *key, const u8 hfunc)
+{
+	struct virtnet_info *vi = netdev_priv(dev);
+	int i;
+
+	if (hfunc != ETH_RSS_HASH_NO_CHANGE && hfunc != ETH_RSS_HASH_TOP)
+		return -EOPNOTSUPP;
+
+	if (indir) {
+		for (i = 0; i < vi->rss_indir_table_size; ++i)
+			vi->ctrl->rss.indirection_table[i] = indir[i];
+	}
+	if (key)
+		memcpy(vi->ctrl->rss.key, key, vi->rss_key_size);
+
+	virtnet_commit_rss_command(vi);
+
+	return 0;
+}
+
+static int virtnet_get_rxnfc(struct net_device *dev, struct ethtool_rxnfc *info, u32 *rule_locs)
+{
+	struct virtnet_info *vi = netdev_priv(dev);
+	int rc = 0;
+
+	switch (info->cmd) {
+	case ETHTOOL_GRXRINGS:
+		info->data = vi->curr_queue_pairs;
+		break;
+	case ETHTOOL_GRXFH:
+		virtnet_get_hashflow(vi, info);
+		break;
+	default:
+		rc = -EOPNOTSUPP;
+	}
+
+	return rc;
+}
+
+static int virtnet_set_rxnfc(struct net_device *dev, struct ethtool_rxnfc *info)
+{
+	struct virtnet_info *vi = netdev_priv(dev);
+	int rc = 0;
+
+	switch (info->cmd) {
+	case ETHTOOL_SRXFH:
+		if (!virtnet_set_hashflow(vi, info))
+			rc = -EINVAL;
+
+		break;
+	default:
+		rc = -EOPNOTSUPP;
+	}
+
+	return rc;
+}
+
+static const struct ethtool_ops virtnet_ethtool_ops = {
+	.supported_coalesce_params = ETHTOOL_COALESCE_MAX_FRAMES |
+		ETHTOOL_COALESCE_USECS,
+	.get_drvinfo = virtnet_get_drvinfo,
+	.get_link = ethtool_op_get_link,
+	.get_ringparam = virtnet_get_ringparam,
+	.set_ringparam = virtnet_set_ringparam,
+	.get_strings = virtnet_get_strings,
+	.get_sset_count = virtnet_get_sset_count,
+	.get_ethtool_stats = virtnet_get_ethtool_stats,
+	.set_channels = virtnet_set_channels,
+	.get_channels = virtnet_get_channels,
+	.get_ts_info = ethtool_op_get_ts_info,
+	.get_link_ksettings = virtnet_get_link_ksettings,
+	.set_link_ksettings = virtnet_set_link_ksettings,
+	.set_coalesce = virtnet_set_coalesce,
+	.get_coalesce = virtnet_get_coalesce,
+	.get_rxfh_key_size = virtnet_get_rxfh_key_size,
+	.get_rxfh_indir_size = virtnet_get_rxfh_indir_size,
+	.get_rxfh = virtnet_get_rxfh,
+	.set_rxfh = virtnet_set_rxfh,
+	.get_rxnfc = virtnet_get_rxnfc,
+	.set_rxnfc = virtnet_set_rxnfc,
+};
+
+const struct ethtool_ops *virtnet_get_ethtool_ops(void)
+{
+	return &virtnet_ethtool_ops;
+}
diff --git a/drivers/net/virtio/virtnet_ethtool.h b/drivers/net/virtio/virtnet_ethtool.h
new file mode 100644
index 000000000000..ed1b7a4877e0
--- /dev/null
+++ b/drivers/net/virtio/virtnet_ethtool.h
@@ -0,0 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+
+#ifndef __VIRNET_ETHTOOL_H__
+#define __VIRNET_ETHTOOL_H__
+
+void virtnet_rq_update_stats(struct virtnet_rq *rq, struct virtnet_rq_stats *stats);
+const struct ethtool_ops *virtnet_get_ethtool_ops(void);
+#endif
-- 
2.32.0.3.g01195cf9f

