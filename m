Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5364E6CBADD
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 11:31:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232660AbjC1J3k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 05:29:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232699AbjC1J3D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 05:29:03 -0400
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FA516A41;
        Tue, 28 Mar 2023 02:28:54 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046056;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0VesZtVV_1679995730;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VesZtVV_1679995730)
          by smtp.aliyun-inc.com;
          Tue, 28 Mar 2023 17:28:50 +0800
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
Subject: [PATCH 02/16] virtio_net: move struct to header file
Date:   Tue, 28 Mar 2023 17:28:33 +0800
Message-Id: <20230328092847.91643-3-xuanzhuo@linux.alibaba.com>
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

Moving some structures and macros to header file.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 drivers/net/virtio/virtnet.c | 181 +---------------------------------
 drivers/net/virtio/virtnet.h | 184 +++++++++++++++++++++++++++++++++++
 2 files changed, 186 insertions(+), 179 deletions(-)
 create mode 100644 drivers/net/virtio/virtnet.h

diff --git a/drivers/net/virtio/virtnet.c b/drivers/net/virtio/virtnet.c
index e2560b6f7980..5ca354e29483 100644
--- a/drivers/net/virtio/virtnet.c
+++ b/drivers/net/virtio/virtnet.c
@@ -6,7 +6,6 @@
 //#define DEBUG
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
-#include <linux/ethtool.h>
 #include <linux/module.h>
 #include <linux/virtio.h>
 #include <linux/virtio_net.h>
@@ -16,13 +15,14 @@
 #include <linux/if_vlan.h>
 #include <linux/slab.h>
 #include <linux/cpu.h>
-#include <linux/average.h>
 #include <linux/filter.h>
 #include <linux/kernel.h>
 #include <net/route.h>
 #include <net/xdp.h>
 #include <net/net_failover.h>
 
+#include "virtnet.h"
+
 static int napi_weight = NAPI_POLL_WEIGHT;
 module_param(napi_weight, int, 0444);
 
@@ -35,26 +35,6 @@ module_param(napi_tx, bool, 0644);
 #define GOOD_PACKET_LEN (ETH_HLEN + VLAN_HLEN + ETH_DATA_LEN)
 #define GOOD_COPY_LEN	128
 
-#define VIRTNET_RX_PAD (NET_IP_ALIGN + NET_SKB_PAD)
-
-/* Amount of XDP headroom to prepend to packets for use by xdp_adjust_head */
-#define VIRTIO_XDP_HEADROOM 256
-
-/* Separating two types of XDP xmit */
-#define VIRTIO_XDP_TX		BIT(0)
-#define VIRTIO_XDP_REDIR	BIT(1)
-
-#define VIRTIO_XDP_FLAG	BIT(0)
-
-/* RX packet size EWMA. The average packet size is used to determine the packet
- * buffer size when refilling RX rings. As the entire RX ring may be refilled
- * at once, the weight is chosen so that the EWMA will be insensitive to short-
- * term, transient changes in packet size.
- */
-DECLARE_EWMA(pkt_len, 0, 64)
-
-#define VIRTNET_DRIVER_VERSION "1.0.0"
-
 static const unsigned long guest_offloads[] = {
 	VIRTIO_NET_F_GUEST_TSO4,
 	VIRTIO_NET_F_GUEST_TSO6,
@@ -78,28 +58,6 @@ struct virtnet_stat_desc {
 	size_t offset;
 };
 
-struct virtnet_sq_stats {
-	struct u64_stats_sync syncp;
-	u64 packets;
-	u64 bytes;
-	u64 xdp_tx;
-	u64 xdp_tx_drops;
-	u64 kicks;
-	u64 tx_timeouts;
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
 #define VIRTNET_SQ_STAT(m)	offsetof(struct virtnet_sq_stats, m)
 #define VIRTNET_RQ_STAT(m)	offsetof(struct virtnet_rq_stats, m)
 
@@ -126,57 +84,6 @@ static const struct virtnet_stat_desc virtnet_rq_stats_desc[] = {
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
-	char name[16];
-
-	struct virtnet_sq_stats stats;
-
-	struct napi_struct napi;
-
-	/* Record whether sq is in reset state. */
-	bool reset;
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
-	char name[16];
-
-	struct xdp_rxq_info xdp_rxq;
-};
-
 /* This structure can contain rss message with maximum settings for indirection table and keysize
  * Note, that default structure that describes RSS configuration virtio_net_rss_config
  * contains same info but can't handle table values.
@@ -207,90 +114,6 @@ struct control_buf {
 	struct virtio_net_ctrl_rss rss;
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
-	/* number of sg entries allocated for big packets */
-	unsigned int big_packets_num_skbfrags;
-
-	/* Host will merge rx buffers for big packets (shake it! shake it!) */
-	bool mergeable_rx_bufs;
-
-	/* Host supports rss and/or hash report */
-	bool has_rss;
-	bool has_rss_hash_report;
-	u8 rss_key_size;
-	u16 rss_indir_table_size;
-	u32 rss_hash_types_supported;
-	u32 rss_hash_types_saved;
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
-	/* Work struct for delayed refilling if we run low on memory. */
-	struct delayed_work refill;
-
-	/* Is delayed refill enabled? */
-	bool refill_enabled;
-
-	/* The lock to synchronize the access to refill_enabled */
-	spinlock_t refill_lock;
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
-	/* Interrupt coalescing settings */
-	u32 tx_usecs;
-	u32 rx_usecs;
-	u32 tx_max_packets;
-	u32 rx_max_packets;
-
-	unsigned long guest_offloads;
-	unsigned long guest_offloads_capable;
-
-	/* failover when STANDBY feature enabled */
-	struct failover *failover;
-};
-
 struct padded_vnet_hdr {
 	struct virtio_net_hdr_v1_hash hdr;
 	/*
diff --git a/drivers/net/virtio/virtnet.h b/drivers/net/virtio/virtnet.h
new file mode 100644
index 000000000000..778a0e6af869
--- /dev/null
+++ b/drivers/net/virtio/virtnet.h
@@ -0,0 +1,184 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef __VIRTNET_H__
+#define __VIRTNET_H__
+
+#include <linux/ethtool.h>
+#include <linux/average.h>
+
+#define VIRTNET_RX_PAD (NET_IP_ALIGN + NET_SKB_PAD)
+
+/* Amount of XDP headroom to prepend to packets for use by xdp_adjust_head */
+#define VIRTIO_XDP_HEADROOM 256
+
+/* Separating two types of XDP xmit */
+#define VIRTIO_XDP_TX		BIT(0)
+#define VIRTIO_XDP_REDIR	BIT(1)
+
+#define VIRTIO_XDP_FLAG	BIT(0)
+
+/* RX packet size EWMA. The average packet size is used to determine the packet
+ * buffer size when refilling RX rings. As the entire RX ring may be refilled
+ * at once, the weight is chosen so that the EWMA will be insensitive to short-
+ * term, transient changes in packet size.
+ */
+DECLARE_EWMA(pkt_len, 0, 64)
+
+#define VIRTNET_DRIVER_VERSION "1.0.0"
+
+struct virtnet_sq_stats {
+	struct u64_stats_sync syncp;
+	u64 packets;
+	u64 bytes;
+	u64 xdp_tx;
+	u64 xdp_tx_drops;
+	u64 kicks;
+	u64 tx_timeouts;
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
+struct send_queue {
+	/* Virtqueue associated with this send _queue */
+	struct virtqueue *vq;
+
+	/* TX: fragments + linear part + virtio header */
+	struct scatterlist sg[MAX_SKB_FRAGS + 2];
+
+	/* Name of the send queue: output.$index */
+	char name[16];
+
+	struct virtnet_sq_stats stats;
+
+	struct napi_struct napi;
+
+	/* Record whether sq is in reset state. */
+	bool reset;
+};
+
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
+	char name[16];
+
+	struct xdp_rxq_info xdp_rxq;
+};
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
+	/* number of sg entries allocated for big packets */
+	unsigned int big_packets_num_skbfrags;
+
+	/* Host will merge rx buffers for big packets (shake it! shake it!) */
+	bool mergeable_rx_bufs;
+
+	/* Host supports rss and/or hash report */
+	bool has_rss;
+	bool has_rss_hash_report;
+	u8 rss_key_size;
+	u16 rss_indir_table_size;
+	u32 rss_hash_types_supported;
+	u32 rss_hash_types_saved;
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
+	/* Work struct for delayed refilling if we run low on memory. */
+	struct delayed_work refill;
+
+	/* Is delayed refill enabled? */
+	bool refill_enabled;
+
+	/* The lock to synchronize the access to refill_enabled */
+	spinlock_t refill_lock;
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
+	/* Interrupt coalescing settings */
+	u32 tx_usecs;
+	u32 rx_usecs;
+	u32 tx_max_packets;
+	u32 rx_max_packets;
+
+	unsigned long guest_offloads;
+	unsigned long guest_offloads_capable;
+
+	/* failover when STANDBY feature enabled */
+	struct failover *failover;
+};
+
+#endif
-- 
2.32.0.3.g01195cf9f

