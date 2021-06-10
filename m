Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE7303A26D8
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 10:23:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231149AbhFJIZ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 04:25:26 -0400
Received: from out30-42.freemail.mail.aliyun.com ([115.124.30.42]:58401 "EHLO
        out30-42.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231187AbhFJIY7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 04:24:59 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=21;SR=0;TI=SMTPD_---0UbxH89w_1623313334;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0UbxH89w_1623313334)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 10 Jun 2021 16:22:14 +0800
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
Subject: [PATCH net-next v5 11/15] virtio-net: move to virtio_net.h
Date:   Thu, 10 Jun 2021 16:22:05 +0800
Message-Id: <20210610082209.91487-12-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210610082209.91487-1-xuanzhuo@linux.alibaba.com>
References: <20210610082209.91487-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move some structure definitions and inline functions into the
virtio_net.h file.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 drivers/net/virtio/virtio_net.c | 225 +------------------------------
 drivers/net/virtio/virtio_net.h | 230 ++++++++++++++++++++++++++++++++
 2 files changed, 232 insertions(+), 223 deletions(-)
 create mode 100644 drivers/net/virtio/virtio_net.h

diff --git a/drivers/net/virtio/virtio_net.c b/drivers/net/virtio/virtio_net.c
index 953739860563..395ec1f18331 100644
--- a/drivers/net/virtio/virtio_net.c
+++ b/drivers/net/virtio/virtio_net.c
@@ -4,24 +4,8 @@
  * Copyright 2007 Rusty Russell <rusty@rustcorp.com.au> IBM Corporation
  */
 //#define DEBUG
-#include <linux/netdevice.h>
-#include <linux/etherdevice.h>
-#include <linux/ethtool.h>
-#include <linux/module.h>
-#include <linux/virtio.h>
-#include <linux/virtio_net.h>
-#include <linux/bpf.h>
-#include <linux/bpf_trace.h>
-#include <linux/scatterlist.h>
-#include <linux/if_vlan.h>
-#include <linux/slab.h>
-#include <linux/cpu.h>
-#include <linux/average.h>
-#include <linux/filter.h>
-#include <linux/kernel.h>
-#include <net/route.h>
-#include <net/xdp.h>
-#include <net/net_failover.h>
+
+#include "virtio_net.h"
 
 static int napi_weight = NAPI_POLL_WEIGHT;
 module_param(napi_weight, int, 0444);
@@ -44,15 +28,6 @@ module_param(napi_tx, bool, 0644);
 #define VIRTIO_XDP_TX		BIT(0)
 #define VIRTIO_XDP_REDIR	BIT(1)
 
-#define VIRTIO_XDP_FLAG	BIT(0)
-
-/* RX packet size EWMA. The average packet size is used to determine the packet
- * buffer size when refilling RX rings. As the entire RX ring may be refilled
- * at once, the weight is chosen so that the EWMA will be insensitive to short-
- * term, transient changes in packet size.
- */
-DECLARE_EWMA(pkt_len, 0, 64)
-
 #define VIRTNET_DRIVER_VERSION "1.0.0"
 
 static const unsigned long guest_offloads[] = {
@@ -68,35 +43,6 @@ static const unsigned long guest_offloads[] = {
 				(1ULL << VIRTIO_NET_F_GUEST_ECN)  | \
 				(1ULL << VIRTIO_NET_F_GUEST_UFO))
 
-struct virtnet_stat_desc {
-	char desc[ETH_GSTRING_LEN];
-	size_t offset;
-};
-
-struct virtnet_sq_stats {
-	struct u64_stats_sync syncp;
-	u64 packets;
-	u64 bytes;
-	u64 xdp_tx;
-	u64 xdp_tx_drops;
-	u64 kicks;
-};
-
-struct virtnet_rq_stats {
-	struct u64_stats_sync syncp;
-	u64 packets;
-	u64 bytes;
-	u64 drops;
-	u64 xdp_packets;
-	u64 xdp_tx;
-	u64 xdp_redirects;
-	u64 xdp_drops;
-	u64 kicks;
-};
-
-#define VIRTNET_SQ_STAT(m)	offsetof(struct virtnet_sq_stats, m)
-#define VIRTNET_RQ_STAT(m)	offsetof(struct virtnet_rq_stats, m)
-
 static const struct virtnet_stat_desc virtnet_sq_stats_desc[] = {
 	{ "packets",		VIRTNET_SQ_STAT(packets) },
 	{ "bytes",		VIRTNET_SQ_STAT(bytes) },
@@ -119,54 +65,6 @@ static const struct virtnet_stat_desc virtnet_rq_stats_desc[] = {
 #define VIRTNET_SQ_STATS_LEN	ARRAY_SIZE(virtnet_sq_stats_desc)
 #define VIRTNET_RQ_STATS_LEN	ARRAY_SIZE(virtnet_rq_stats_desc)
 
-/* Internal representation of a send virtqueue */
-struct send_queue {
-	/* Virtqueue associated with this send _queue */
-	struct virtqueue *vq;
-
-	/* TX: fragments + linear part + virtio header */
-	struct scatterlist sg[MAX_SKB_FRAGS + 2];
-
-	/* Name of the send queue: output.$index */
-	char name[40];
-
-	struct virtnet_sq_stats stats;
-
-	struct napi_struct napi;
-};
-
-/* Internal representation of a receive virtqueue */
-struct receive_queue {
-	/* Virtqueue associated with this receive_queue */
-	struct virtqueue *vq;
-
-	struct napi_struct napi;
-
-	struct bpf_prog __rcu *xdp_prog;
-
-	struct virtnet_rq_stats stats;
-
-	/* Chain pages by the private ptr. */
-	struct page *pages;
-
-	/* Average packet length for mergeable receive buffers. */
-	struct ewma_pkt_len mrg_avg_pkt_len;
-
-	/* Page frag for packet buffer allocation. */
-	struct page_frag alloc_frag;
-
-	/* RX: fragments + linear part + virtio header */
-	struct scatterlist sg[MAX_SKB_FRAGS + 2];
-
-	/* Min single buffer size for mergeable buffers case. */
-	unsigned int min_buf_len;
-
-	/* Name of this receive queue: input.$index */
-	char name[40];
-
-	struct xdp_rxq_info xdp_rxq;
-};
-
 /* Control VQ buffers: protected by the rtnl lock */
 struct control_buf {
 	struct virtio_net_ctrl_hdr hdr;
@@ -178,67 +76,6 @@ struct control_buf {
 	__virtio64 offloads;
 };
 
-struct virtnet_info {
-	struct virtio_device *vdev;
-	struct virtqueue *cvq;
-	struct net_device *dev;
-	struct send_queue *sq;
-	struct receive_queue *rq;
-	unsigned int status;
-
-	/* Max # of queue pairs supported by the device */
-	u16 max_queue_pairs;
-
-	/* # of queue pairs currently used by the driver */
-	u16 curr_queue_pairs;
-
-	/* # of XDP queue pairs currently used by the driver */
-	u16 xdp_queue_pairs;
-
-	/* xdp_queue_pairs may be 0, when xdp is already loaded. So add this. */
-	bool xdp_enabled;
-
-	/* I like... big packets and I cannot lie! */
-	bool big_packets;
-
-	/* Host will merge rx buffers for big packets (shake it! shake it!) */
-	bool mergeable_rx_bufs;
-
-	/* Has control virtqueue */
-	bool has_cvq;
-
-	/* Host can handle any s/g split between our header and packet data */
-	bool any_header_sg;
-
-	/* Packet virtio header size */
-	u8 hdr_len;
-
-	/* Work struct for refilling if we run low on memory. */
-	struct delayed_work refill;
-
-	/* Work struct for config space updates */
-	struct work_struct config_work;
-
-	/* Does the affinity hint is set for virtqueues? */
-	bool affinity_hint_set;
-
-	/* CPU hotplug instances for online & dead */
-	struct hlist_node node;
-	struct hlist_node node_dead;
-
-	struct control_buf *ctrl;
-
-	/* Ethtool settings */
-	u8 duplex;
-	u32 speed;
-
-	unsigned long guest_offloads;
-	unsigned long guest_offloads_capable;
-
-	/* failover when STANDBY feature enabled */
-	struct failover *failover;
-};
-
 struct padded_vnet_hdr {
 	struct virtio_net_hdr_mrg_rxbuf hdr;
 	/*
@@ -249,21 +86,6 @@ struct padded_vnet_hdr {
 	char padding[4];
 };
 
-static bool is_xdp_frame(void *ptr)
-{
-	return (unsigned long)ptr & VIRTIO_XDP_FLAG;
-}
-
-static void *xdp_to_ptr(struct xdp_frame *ptr)
-{
-	return (void *)((unsigned long)ptr | VIRTIO_XDP_FLAG);
-}
-
-static struct xdp_frame *ptr_to_xdp(void *ptr)
-{
-	return (struct xdp_frame *)((unsigned long)ptr & ~VIRTIO_XDP_FLAG);
-}
-
 static char *virtnet_alloc_frag(struct receive_queue *rq, unsigned int len,
 				int gfp)
 {
@@ -280,30 +102,6 @@ static char *virtnet_alloc_frag(struct receive_queue *rq, unsigned int len,
 	return buf;
 }
 
-static void __free_old_xmit(struct send_queue *sq, bool in_napi,
-			    struct virtnet_sq_stats *stats)
-{
-	unsigned int len;
-	void *ptr;
-
-	while ((ptr = virtqueue_get_buf(sq->vq, &len)) != NULL) {
-		if (!is_xdp_frame(ptr)) {
-			struct sk_buff *skb = ptr;
-
-			pr_debug("Sent skb %p\n", skb);
-
-			stats->bytes += skb->len;
-			napi_consume_skb(skb, in_napi);
-		} else {
-			struct xdp_frame *frame = ptr_to_xdp(ptr);
-
-			stats->bytes += frame->len;
-			xdp_return_frame(frame);
-		}
-		stats->packets++;
-	}
-}
-
 /* Converting between virtqueue no. and kernel tx/rx queue no.
  * 0:rx0 1:tx0 2:rx1 3:tx1 ... 2N:rxN 2N+1:txN 2N+2:cvq
  */
@@ -359,15 +157,6 @@ static struct page *get_a_page(struct receive_queue *rq, gfp_t gfp_mask)
 	return p;
 }
 
-static void virtqueue_napi_schedule(struct napi_struct *napi,
-				    struct virtqueue *vq)
-{
-	if (napi_schedule_prep(napi)) {
-		virtqueue_disable_cb(vq);
-		__napi_schedule(napi);
-	}
-}
-
 static void virtqueue_napi_complete(struct napi_struct *napi,
 				    struct virtqueue *vq, int processed)
 {
@@ -1537,16 +1326,6 @@ static void free_old_xmit(struct send_queue *sq, bool in_napi)
 	u64_stats_update_end(&sq->stats.syncp);
 }
 
-static bool is_xdp_raw_buffer_queue(struct virtnet_info *vi, int q)
-{
-	if (q < (vi->curr_queue_pairs - vi->xdp_queue_pairs))
-		return false;
-	else if (q < vi->curr_queue_pairs)
-		return true;
-	else
-		return false;
-}
-
 static void virtnet_poll_cleantx(struct receive_queue *rq)
 {
 	struct virtnet_info *vi = rq->vq->vdev->priv;
diff --git a/drivers/net/virtio/virtio_net.h b/drivers/net/virtio/virtio_net.h
new file mode 100644
index 000000000000..931cc81f92fb
--- /dev/null
+++ b/drivers/net/virtio/virtio_net.h
@@ -0,0 +1,230 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+
+#ifndef __VIRTIO_NET_H__
+#define __VIRTIO_NET_H__
+#include <linux/netdevice.h>
+#include <linux/etherdevice.h>
+#include <linux/ethtool.h>
+#include <linux/module.h>
+#include <linux/virtio.h>
+#include <linux/virtio_net.h>
+#include <linux/bpf.h>
+#include <linux/bpf_trace.h>
+#include <linux/scatterlist.h>
+#include <linux/if_vlan.h>
+#include <linux/slab.h>
+#include <linux/cpu.h>
+#include <linux/average.h>
+#include <linux/filter.h>
+#include <linux/kernel.h>
+#include <net/route.h>
+#include <net/xdp.h>
+#include <net/net_failover.h>
+#include <net/xdp_sock_drv.h>
+
+#define VIRTIO_XDP_FLAG	BIT(0)
+
+struct virtnet_info {
+	struct virtio_device *vdev;
+	struct virtqueue *cvq;
+	struct net_device *dev;
+	struct send_queue *sq;
+	struct receive_queue *rq;
+	unsigned int status;
+
+	/* Max # of queue pairs supported by the device */
+	u16 max_queue_pairs;
+
+	/* # of queue pairs currently used by the driver */
+	u16 curr_queue_pairs;
+
+	/* # of XDP queue pairs currently used by the driver */
+	u16 xdp_queue_pairs;
+
+	/* xdp_queue_pairs may be 0, when xdp is already loaded. So add this. */
+	bool xdp_enabled;
+
+	/* I like... big packets and I cannot lie! */
+	bool big_packets;
+
+	/* Host will merge rx buffers for big packets (shake it! shake it!) */
+	bool mergeable_rx_bufs;
+
+	/* Has control virtqueue */
+	bool has_cvq;
+
+	/* Host can handle any s/g split between our header and packet data */
+	bool any_header_sg;
+
+	/* Packet virtio header size */
+	u8 hdr_len;
+
+	/* Work struct for refilling if we run low on memory. */
+	struct delayed_work refill;
+
+	/* Work struct for config space updates */
+	struct work_struct config_work;
+
+	/* Does the affinity hint is set for virtqueues? */
+	bool affinity_hint_set;
+
+	/* CPU hotplug instances for online & dead */
+	struct hlist_node node;
+	struct hlist_node node_dead;
+
+	struct control_buf *ctrl;
+
+	/* Ethtool settings */
+	u8 duplex;
+	u32 speed;
+
+	unsigned long guest_offloads;
+	unsigned long guest_offloads_capable;
+
+	/* failover when STANDBY feature enabled */
+	struct failover *failover;
+};
+
+/* RX packet size EWMA. The average packet size is used to determine the packet
+ * buffer size when refilling RX rings. As the entire RX ring may be refilled
+ * at once, the weight is chosen so that the EWMA will be insensitive to short-
+ * term, transient changes in packet size.
+ */
+DECLARE_EWMA(pkt_len, 0, 64)
+
+struct virtnet_stat_desc {
+	char desc[ETH_GSTRING_LEN];
+	size_t offset;
+};
+
+struct virtnet_sq_stats {
+	struct u64_stats_sync syncp;
+	u64 packets;
+	u64 bytes;
+	u64 xdp_tx;
+	u64 xdp_tx_drops;
+	u64 kicks;
+};
+
+struct virtnet_rq_stats {
+	struct u64_stats_sync syncp;
+	u64 packets;
+	u64 bytes;
+	u64 drops;
+	u64 xdp_packets;
+	u64 xdp_tx;
+	u64 xdp_redirects;
+	u64 xdp_drops;
+	u64 kicks;
+};
+
+#define VIRTNET_SQ_STAT(m)	offsetof(struct virtnet_sq_stats, m)
+#define VIRTNET_RQ_STAT(m)	offsetof(struct virtnet_rq_stats, m)
+
+/* Internal representation of a send virtqueue */
+struct send_queue {
+	/* Virtqueue associated with this send _queue */
+	struct virtqueue *vq;
+
+	/* TX: fragments + linear part + virtio header */
+	struct scatterlist sg[MAX_SKB_FRAGS + 2];
+
+	/* Name of the send queue: output.$index */
+	char name[40];
+
+	struct virtnet_sq_stats stats;
+
+	struct napi_struct napi;
+};
+
+/* Internal representation of a receive virtqueue */
+struct receive_queue {
+	/* Virtqueue associated with this receive_queue */
+	struct virtqueue *vq;
+
+	struct napi_struct napi;
+
+	struct bpf_prog __rcu *xdp_prog;
+
+	struct virtnet_rq_stats stats;
+
+	/* Chain pages by the private ptr. */
+	struct page *pages;
+
+	/* Average packet length for mergeable receive buffers. */
+	struct ewma_pkt_len mrg_avg_pkt_len;
+
+	/* Page frag for packet buffer allocation. */
+	struct page_frag alloc_frag;
+
+	/* RX: fragments + linear part + virtio header */
+	struct scatterlist sg[MAX_SKB_FRAGS + 2];
+
+	/* Min single buffer size for mergeable buffers case. */
+	unsigned int min_buf_len;
+
+	/* Name of this receive queue: input.$index */
+	char name[40];
+
+	struct xdp_rxq_info xdp_rxq;
+};
+
+static inline bool is_xdp_raw_buffer_queue(struct virtnet_info *vi, int q)
+{
+	if (q < (vi->curr_queue_pairs - vi->xdp_queue_pairs))
+		return false;
+	else if (q < vi->curr_queue_pairs)
+		return true;
+	else
+		return false;
+}
+
+static inline void virtqueue_napi_schedule(struct napi_struct *napi,
+					   struct virtqueue *vq)
+{
+	if (napi_schedule_prep(napi)) {
+		virtqueue_disable_cb(vq);
+		__napi_schedule(napi);
+	}
+}
+
+static inline bool is_xdp_frame(void *ptr)
+{
+	return (unsigned long)ptr & VIRTIO_XDP_FLAG;
+}
+
+static inline void *xdp_to_ptr(struct xdp_frame *ptr)
+{
+	return (void *)((unsigned long)ptr | VIRTIO_XDP_FLAG);
+}
+
+static inline struct xdp_frame *ptr_to_xdp(void *ptr)
+{
+	return (struct xdp_frame *)((unsigned long)ptr & ~VIRTIO_XDP_FLAG);
+}
+
+static inline void __free_old_xmit(struct send_queue *sq, bool in_napi,
+				   struct virtnet_sq_stats *stats)
+{
+	unsigned int len;
+	void *ptr;
+
+	while ((ptr = virtqueue_get_buf(sq->vq, &len)) != NULL) {
+		if (!is_xdp_frame(ptr)) {
+			struct sk_buff *skb = ptr;
+
+			pr_debug("Sent skb %p\n", skb);
+
+			stats->bytes += skb->len;
+			napi_consume_skb(skb, in_napi);
+		} else {
+			struct xdp_frame *frame = ptr_to_xdp(ptr);
+
+			stats->bytes += frame->len;
+			xdp_return_frame(frame);
+		}
+		stats->packets++;
+	}
+}
+
+#endif
-- 
2.31.0

