Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B8E96CBAE7
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 11:31:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232690AbjC1JaZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 05:30:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232689AbjC1J3d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 05:29:33 -0400
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D2566EB7;
        Tue, 28 Mar 2023 02:29:03 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046056;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0VeseIBi_1679995736;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VeseIBi_1679995736)
          by smtp.aliyun-inc.com;
          Tue, 28 Mar 2023 17:28:57 +0800
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
Subject: [PATCH 08/16] virtio_net: separating the APIs of cq
Date:   Tue, 28 Mar 2023 17:28:39 +0800
Message-Id: <20230328092847.91643-9-xuanzhuo@linux.alibaba.com>
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

Separating the APIs of cq into a file.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 drivers/net/virtio/Makefile       |   2 +-
 drivers/net/virtio/virtnet.c      | 299 +-----------------------------
 drivers/net/virtio/virtnet_ctrl.c | 272 +++++++++++++++++++++++++++
 drivers/net/virtio/virtnet_ctrl.h |  45 +++++
 4 files changed, 319 insertions(+), 299 deletions(-)
 create mode 100644 drivers/net/virtio/virtnet_ctrl.c
 create mode 100644 drivers/net/virtio/virtnet_ctrl.h

diff --git a/drivers/net/virtio/Makefile b/drivers/net/virtio/Makefile
index 3bef2b51876c..a2d80f95c921 100644
--- a/drivers/net/virtio/Makefile
+++ b/drivers/net/virtio/Makefile
@@ -5,4 +5,4 @@
 
 obj-$(CONFIG_VIRTIO_NET) += virtio_net.o
 
-virtio_net-y := virtnet.o virtnet_common.o
+virtio_net-y := virtnet.o virtnet_common.o virtnet_ctrl.o
diff --git a/drivers/net/virtio/virtnet.c b/drivers/net/virtio/virtnet.c
index 4a3b5efb674e..84b90333dc77 100644
--- a/drivers/net/virtio/virtnet.c
+++ b/drivers/net/virtio/virtnet.c
@@ -22,6 +22,7 @@
 
 #include "virtnet.h"
 #include "virtnet_common.h"
+#include "virtnet_ctrl.h"
 
 static int napi_weight = NAPI_POLL_WEIGHT;
 module_param(napi_weight, int, 0444);
@@ -84,36 +85,6 @@ static const struct virtnet_stat_desc virtnet_rq_stats_desc[] = {
 #define VIRTNET_SQ_STATS_LEN	ARRAY_SIZE(virtnet_sq_stats_desc)
 #define VIRTNET_RQ_STATS_LEN	ARRAY_SIZE(virtnet_rq_stats_desc)
 
-/* This structure can contain rss message with maximum settings for indirection table and keysize
- * Note, that default structure that describes RSS configuration virtio_net_rss_config
- * contains same info but can't handle table values.
- * In any case, structure would be passed to virtio hw through sg_buf split by parts
- * because table sizes may be differ according to the device configuration.
- */
-#define VIRTIO_NET_RSS_MAX_KEY_SIZE     40
-#define VIRTIO_NET_RSS_MAX_TABLE_LEN    128
-struct virtio_net_ctrl_rss {
-	u32 hash_types;
-	u16 indirection_table_mask;
-	u16 unclassified_queue;
-	u16 indirection_table[VIRTIO_NET_RSS_MAX_TABLE_LEN];
-	u16 max_tx_vq;
-	u8 hash_key_length;
-	u8 key[VIRTIO_NET_RSS_MAX_KEY_SIZE];
-};
-
-/* Control VQ buffers: protected by the rtnl lock */
-struct control_buf {
-	struct virtio_net_ctrl_hdr hdr;
-	virtio_net_ctrl_ack status;
-	struct virtio_net_ctrl_mq mq;
-	u8 promisc;
-	u8 allmulti;
-	__virtio16 vid;
-	__virtio64 offloads;
-	struct virtio_net_ctrl_rss rss;
-};
-
 struct padded_vnet_hdr {
 	struct virtio_net_hdr_v1_hash hdr;
 	/*
@@ -1932,73 +1903,6 @@ static int virtnet_tx_resize(struct virtnet_info *vi,
 	return err;
 }
 
-/*
- * Send command via the control virtqueue and check status.  Commands
- * supported by the hypervisor, as indicated by feature bits, should
- * never fail unless improperly formatted.
- */
-static bool virtnet_send_command(struct virtnet_info *vi, u8 class, u8 cmd,
-				 struct scatterlist *out)
-{
-	struct scatterlist *sgs[4], hdr, stat;
-	unsigned out_num = 0, tmp;
-	int ret;
-
-	/* Caller should know better */
-	BUG_ON(!virtio_has_feature(vi->vdev, VIRTIO_NET_F_CTRL_VQ));
-
-	vi->ctrl->status = ~0;
-	vi->ctrl->hdr.class = class;
-	vi->ctrl->hdr.cmd = cmd;
-	/* Add header */
-	sg_init_one(&hdr, &vi->ctrl->hdr, sizeof(vi->ctrl->hdr));
-	sgs[out_num++] = &hdr;
-
-	if (out)
-		sgs[out_num++] = out;
-
-	/* Add return status. */
-	sg_init_one(&stat, &vi->ctrl->status, sizeof(vi->ctrl->status));
-	sgs[out_num] = &stat;
-
-	BUG_ON(out_num + 1 > ARRAY_SIZE(sgs));
-	ret = virtqueue_add_sgs(vi->cvq, sgs, out_num, 1, vi, GFP_ATOMIC);
-	if (ret < 0) {
-		dev_warn(&vi->vdev->dev,
-			 "Failed to add sgs for command vq: %d\n.", ret);
-		return false;
-	}
-
-	if (unlikely(!virtqueue_kick(vi->cvq)))
-		return vi->ctrl->status == VIRTIO_NET_OK;
-
-	/* Spin for a response, the kick causes an ioport write, trapping
-	 * into the hypervisor, so the request should be handled immediately.
-	 */
-	while (!virtqueue_get_buf(vi->cvq, &tmp) &&
-	       !virtqueue_is_broken(vi->cvq))
-		cpu_relax();
-
-	return vi->ctrl->status == VIRTIO_NET_OK;
-}
-
-static int virtnet_ctrl_set_mac_address(struct virtnet_info *vi, const void *addr, int len)
-{
-	struct virtio_device *vdev = vi->vdev;
-	struct scatterlist sg;
-
-	sg_init_one(&sg, addr, len);
-
-	if (!virtnet_send_command(vi, VIRTIO_NET_CTRL_MAC,
-				  VIRTIO_NET_CTRL_MAC_ADDR_SET, &sg)) {
-		dev_warn(&vdev->dev,
-			 "Failed to set mac address by vq command.\n");
-		return -EINVAL;
-	}
-
-	return 0;
-}
-
 static int virtnet_set_mac_address(struct net_device *dev, void *p)
 {
 	struct virtnet_info *vi = netdev_priv(dev);
@@ -2081,24 +1985,6 @@ static void virtnet_stats(struct net_device *dev,
 	tot->rx_frame_errors = dev->stats.rx_frame_errors;
 }
 
-static void virtnet_ack_link_announce(struct virtnet_info *vi)
-{
-	if (!virtnet_send_command(vi, VIRTIO_NET_CTRL_ANNOUNCE,
-				  VIRTIO_NET_CTRL_ANNOUNCE_ACK, NULL))
-		dev_warn(&vi->dev->dev, "Failed to ack link announce.\n");
-}
-
-static int virtnet_ctrl_set_queues(struct virtnet_info *vi, u16 queue_pairs)
-{
-	struct scatterlist sg;
-
-	vi->ctrl->mq.virtqueue_pairs = cpu_to_virtio16(vi->vdev, queue_pairs);
-	sg_init_one(&sg, &vi->ctrl->mq, sizeof(vi->ctrl->mq));
-
-	return virtnet_send_command(vi, VIRTIO_NET_CTRL_MQ,
-				    VIRTIO_NET_CTRL_MQ_VQ_PAIRS_SET, &sg);
-}
-
 static int _virtnet_set_queues(struct virtnet_info *vi, u16 queue_pairs)
 {
 	struct net_device *dev = vi->dev;
@@ -2149,106 +2035,6 @@ static int virtnet_close(struct net_device *dev)
 	return 0;
 }
 
-static void virtnet_set_rx_mode(struct net_device *dev)
-{
-	struct virtnet_info *vi = netdev_priv(dev);
-	struct scatterlist sg[2];
-	struct virtio_net_ctrl_mac *mac_data;
-	struct netdev_hw_addr *ha;
-	int uc_count;
-	int mc_count;
-	void *buf;
-	int i;
-
-	/* We can't dynamically set ndo_set_rx_mode, so return gracefully */
-	if (!virtio_has_feature(vi->vdev, VIRTIO_NET_F_CTRL_RX))
-		return;
-
-	vi->ctrl->promisc = ((dev->flags & IFF_PROMISC) != 0);
-	vi->ctrl->allmulti = ((dev->flags & IFF_ALLMULTI) != 0);
-
-	sg_init_one(sg, &vi->ctrl->promisc, sizeof(vi->ctrl->promisc));
-
-	if (!virtnet_send_command(vi, VIRTIO_NET_CTRL_RX,
-				  VIRTIO_NET_CTRL_RX_PROMISC, sg))
-		dev_warn(&dev->dev, "Failed to %sable promisc mode.\n",
-			 vi->ctrl->promisc ? "en" : "dis");
-
-	sg_init_one(sg, &vi->ctrl->allmulti, sizeof(vi->ctrl->allmulti));
-
-	if (!virtnet_send_command(vi, VIRTIO_NET_CTRL_RX,
-				  VIRTIO_NET_CTRL_RX_ALLMULTI, sg))
-		dev_warn(&dev->dev, "Failed to %sable allmulti mode.\n",
-			 vi->ctrl->allmulti ? "en" : "dis");
-
-	uc_count = netdev_uc_count(dev);
-	mc_count = netdev_mc_count(dev);
-	/* MAC filter - use one buffer for both lists */
-	buf = kzalloc(((uc_count + mc_count) * ETH_ALEN) +
-		      (2 * sizeof(mac_data->entries)), GFP_ATOMIC);
-	mac_data = buf;
-	if (!buf)
-		return;
-
-	sg_init_table(sg, 2);
-
-	/* Store the unicast list and count in the front of the buffer */
-	mac_data->entries = cpu_to_virtio32(vi->vdev, uc_count);
-	i = 0;
-	netdev_for_each_uc_addr(ha, dev)
-		memcpy(&mac_data->macs[i++][0], ha->addr, ETH_ALEN);
-
-	sg_set_buf(&sg[0], mac_data,
-		   sizeof(mac_data->entries) + (uc_count * ETH_ALEN));
-
-	/* multicast list and count fill the end */
-	mac_data = (void *)&mac_data->macs[uc_count][0];
-
-	mac_data->entries = cpu_to_virtio32(vi->vdev, mc_count);
-	i = 0;
-	netdev_for_each_mc_addr(ha, dev)
-		memcpy(&mac_data->macs[i++][0], ha->addr, ETH_ALEN);
-
-	sg_set_buf(&sg[1], mac_data,
-		   sizeof(mac_data->entries) + (mc_count * ETH_ALEN));
-
-	if (!virtnet_send_command(vi, VIRTIO_NET_CTRL_MAC,
-				  VIRTIO_NET_CTRL_MAC_TABLE_SET, sg))
-		dev_warn(&dev->dev, "Failed to set MAC filter table.\n");
-
-	kfree(buf);
-}
-
-static int virtnet_vlan_rx_add_vid(struct net_device *dev,
-				   __be16 proto, u16 vid)
-{
-	struct virtnet_info *vi = netdev_priv(dev);
-	struct scatterlist sg;
-
-	vi->ctrl->vid = cpu_to_virtio16(vi->vdev, vid);
-	sg_init_one(&sg, &vi->ctrl->vid, sizeof(vi->ctrl->vid));
-
-	if (!virtnet_send_command(vi, VIRTIO_NET_CTRL_VLAN,
-				  VIRTIO_NET_CTRL_VLAN_ADD, &sg))
-		dev_warn(&dev->dev, "Failed to add VLAN ID %d.\n", vid);
-	return 0;
-}
-
-static int virtnet_vlan_rx_kill_vid(struct net_device *dev,
-				    __be16 proto, u16 vid)
-{
-	struct virtnet_info *vi = netdev_priv(dev);
-	struct scatterlist sg;
-
-	vi->ctrl->vid = cpu_to_virtio16(vi->vdev, vid);
-	sg_init_one(&sg, &vi->ctrl->vid, sizeof(vi->ctrl->vid));
-
-	if (!virtnet_send_command(vi, VIRTIO_NET_CTRL_VLAN,
-				  VIRTIO_NET_CTRL_VLAN_DEL, &sg))
-		dev_warn(&dev->dev, "Failed to kill VLAN ID %d.\n", vid);
-	return 0;
-}
-
 static void virtnet_get_ringparam(struct net_device *dev,
 				  struct ethtool_ringparam *ring,
 				  struct kernel_ethtool_ringparam *kernel_ring,
@@ -2309,37 +2095,6 @@ static int virtnet_set_ringparam(struct net_device *dev,
 	return 0;
 }
 
-static bool virtnet_commit_rss_command(struct virtnet_info *vi)
-{
-	struct net_device *dev = vi->dev;
-	struct scatterlist sgs[4];
-	unsigned int sg_buf_size;
-
-	/* prepare sgs */
-	sg_init_table(sgs, 4);
-
-	sg_buf_size = offsetof(struct virtio_net_ctrl_rss, indirection_table);
-	sg_set_buf(&sgs[0], &vi->ctrl->rss, sg_buf_size);
-
-	sg_buf_size = sizeof(uint16_t) * (vi->ctrl->rss.indirection_table_mask + 1);
-	sg_set_buf(&sgs[1], vi->ctrl->rss.indirection_table, sg_buf_size);
-
-	sg_buf_size = offsetof(struct virtio_net_ctrl_rss, key)
-			- offsetof(struct virtio_net_ctrl_rss, max_tx_vq);
-	sg_set_buf(&sgs[2], &vi->ctrl->rss.max_tx_vq, sg_buf_size);
-
-	sg_buf_size = vi->rss_key_size;
-	sg_set_buf(&sgs[3], vi->ctrl->rss.key, sg_buf_size);
-
-	if (!virtnet_send_command(vi, VIRTIO_NET_CTRL_MQ,
-				  vi->has_rss ? VIRTIO_NET_CTRL_MQ_RSS_CONFIG
-				  : VIRTIO_NET_CTRL_MQ_HASH_CONFIG, sgs)) {
-		dev_warn(&dev->dev, "VIRTIONET issue with committing RSS sgs\n");
-		return false;
-	}
-	return true;
-}
-
 static void virtnet_init_default_rss(struct virtnet_info *vi)
 {
 	u32 indir_val = 0;
@@ -2636,42 +2391,6 @@ static int virtnet_get_link_ksettings(struct net_device *dev,
 	return 0;
 }
 
-static int virtnet_send_notf_coal_cmds(struct virtnet_info *vi,
-				       struct ethtool_coalesce *ec)
-{
-	struct scatterlist sgs_tx, sgs_rx;
-	struct virtio_net_ctrl_coal_tx coal_tx;
-	struct virtio_net_ctrl_coal_rx coal_rx;
-
-	coal_tx.tx_usecs = cpu_to_le32(ec->tx_coalesce_usecs);
-	coal_tx.tx_max_packets = cpu_to_le32(ec->tx_max_coalesced_frames);
-	sg_init_one(&sgs_tx, &coal_tx, sizeof(coal_tx));
-
-	if (!virtnet_send_command(vi, VIRTIO_NET_CTRL_NOTF_COAL,
-				  VIRTIO_NET_CTRL_NOTF_COAL_TX_SET,
-				  &sgs_tx))
-		return -EINVAL;
-
-	/* Save parameters */
-	vi->tx_usecs = ec->tx_coalesce_usecs;
-	vi->tx_max_packets = ec->tx_max_coalesced_frames;
-
-	coal_rx.rx_usecs = cpu_to_le32(ec->rx_coalesce_usecs);
-	coal_rx.rx_max_packets = cpu_to_le32(ec->rx_max_coalesced_frames);
-	sg_init_one(&sgs_rx, &coal_rx, sizeof(coal_rx));
-
-	if (!virtnet_send_command(vi, VIRTIO_NET_CTRL_NOTF_COAL,
-				  VIRTIO_NET_CTRL_NOTF_COAL_RX_SET,
-				  &sgs_rx))
-		return -EINVAL;
-
-	/* Save parameters */
-	vi->rx_usecs = ec->rx_coalesce_usecs;
-	vi->rx_max_packets = ec->rx_max_coalesced_frames;
-
-	return 0;
-}
-
 static int virtnet_coal_params_supported(struct ethtool_coalesce *ec)
 {
 	/* usecs coalescing is supported only if VIRTIO_NET_F_NOTF_COAL
@@ -2922,22 +2641,6 @@ static int virtnet_restore_up(struct virtio_device *vdev)
 	return err;
 }
 
-static int virtnet_set_guest_offloads(struct virtnet_info *vi, u64 offloads)
-{
-	struct scatterlist sg;
-	vi->ctrl->offloads = cpu_to_virtio64(vi->vdev, offloads);
-
-	sg_init_one(&sg, &vi->ctrl->offloads, sizeof(vi->ctrl->offloads));
-
-	if (!virtnet_send_command(vi, VIRTIO_NET_CTRL_GUEST_OFFLOADS,
-				  VIRTIO_NET_CTRL_GUEST_OFFLOADS_SET, &sg)) {
-		dev_warn(&vi->dev->dev, "Fail to set guest offload.\n");
-		return -EINVAL;
-	}
-
-	return 0;
-}
-
 static int virtnet_clear_guest_offloads(struct virtnet_info *vi)
 {
 	u64 offloads = 0;
diff --git a/drivers/net/virtio/virtnet_ctrl.c b/drivers/net/virtio/virtnet_ctrl.c
new file mode 100644
index 000000000000..4b5ffa9eedd4
--- /dev/null
+++ b/drivers/net/virtio/virtnet_ctrl.c
@@ -0,0 +1,272 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+//
+#include <linux/netdevice.h>
+#include <linux/virtio_net.h>
+
+#include "virtnet.h"
+#include "virtnet_ctrl.h"
+
+/* Send command via the control virtqueue and check status.  Commands
+ * supported by the hypervisor, as indicated by feature bits, should
+ * never fail unless improperly formatted.
+ */
+static bool virtnet_send_command(struct virtnet_info *vi, u8 class, u8 cmd,
+				 struct scatterlist *out)
+{
+	struct scatterlist *sgs[4], hdr, stat;
+	unsigned int out_num = 0, tmp;
+	int ret;
+
+	/* Caller should know better */
+	BUG_ON(!virtio_has_feature(vi->vdev, VIRTIO_NET_F_CTRL_VQ));
+
+	vi->ctrl->status = ~0;
+	vi->ctrl->hdr.class = class;
+	vi->ctrl->hdr.cmd = cmd;
+	/* Add header */
+	sg_init_one(&hdr, &vi->ctrl->hdr, sizeof(vi->ctrl->hdr));
+	sgs[out_num++] = &hdr;
+
+	if (out)
+		sgs[out_num++] = out;
+
+	/* Add return status. */
+	sg_init_one(&stat, &vi->ctrl->status, sizeof(vi->ctrl->status));
+	sgs[out_num] = &stat;
+
+	BUG_ON(out_num + 1 > ARRAY_SIZE(sgs));
+	ret = virtqueue_add_sgs(vi->cvq, sgs, out_num, 1, vi, GFP_ATOMIC);
+	if (ret < 0) {
+		dev_warn(&vi->vdev->dev,
+			 "Failed to add sgs for command vq: %d\n.", ret);
+		return false;
+	}
+
+	if (unlikely(!virtqueue_kick(vi->cvq)))
+		return vi->ctrl->status == VIRTIO_NET_OK;
+
+	/* Spin for a response, the kick causes an ioport write, trapping
+	 * into the hypervisor, so the request should be handled immediately.
+	 */
+	while (!virtqueue_get_buf(vi->cvq, &tmp) &&
+	       !virtqueue_is_broken(vi->cvq))
+		cpu_relax();
+
+	return vi->ctrl->status == VIRTIO_NET_OK;
+}
+
+int virtnet_ctrl_set_mac_address(struct virtnet_info *vi, const void *addr, int len)
+{
+	struct virtio_device *vdev = vi->vdev;
+	struct scatterlist sg;
+
+	sg_init_one(&sg, addr, len);
+
+	if (!virtnet_send_command(vi, VIRTIO_NET_CTRL_MAC,
+				  VIRTIO_NET_CTRL_MAC_ADDR_SET, &sg)) {
+		dev_warn(&vdev->dev,
+			 "Failed to set mac address by vq command.\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+void virtnet_ack_link_announce(struct virtnet_info *vi)
+{
+	if (!virtnet_send_command(vi, VIRTIO_NET_CTRL_ANNOUNCE,
+				  VIRTIO_NET_CTRL_ANNOUNCE_ACK, NULL))
+		dev_warn(&vi->dev->dev, "Failed to ack link announce.\n");
+}
+
+int virtnet_ctrl_set_queues(struct virtnet_info *vi, u16 queue_pairs)
+{
+	struct scatterlist sg;
+
+	vi->ctrl->mq.virtqueue_pairs = cpu_to_virtio16(vi->vdev, queue_pairs);
+	sg_init_one(&sg, &vi->ctrl->mq, sizeof(vi->ctrl->mq));
+
+	return virtnet_send_command(vi, VIRTIO_NET_CTRL_MQ,
+				    VIRTIO_NET_CTRL_MQ_VQ_PAIRS_SET, &sg);
+}
+
+void virtnet_set_rx_mode(struct net_device *dev)
+{
+	struct virtnet_info *vi = netdev_priv(dev);
+	struct scatterlist sg[2];
+	struct virtio_net_ctrl_mac *mac_data;
+	struct netdev_hw_addr *ha;
+	int uc_count;
+	int mc_count;
+	void *buf;
+	int i;
+
+	/* We can't dynamically set ndo_set_rx_mode, so return gracefully */
+	if (!virtio_has_feature(vi->vdev, VIRTIO_NET_F_CTRL_RX))
+		return;
+
+	vi->ctrl->promisc = ((dev->flags & IFF_PROMISC) != 0);
+	vi->ctrl->allmulti = ((dev->flags & IFF_ALLMULTI) != 0);
+
+	sg_init_one(sg, &vi->ctrl->promisc, sizeof(vi->ctrl->promisc));
+
+	if (!virtnet_send_command(vi, VIRTIO_NET_CTRL_RX,
+				  VIRTIO_NET_CTRL_RX_PROMISC, sg))
+		dev_warn(&dev->dev, "Failed to %sable promisc mode.\n",
+			 vi->ctrl->promisc ? "en" : "dis");
+
+	sg_init_one(sg, &vi->ctrl->allmulti, sizeof(vi->ctrl->allmulti));
+
+	if (!virtnet_send_command(vi, VIRTIO_NET_CTRL_RX,
+				  VIRTIO_NET_CTRL_RX_ALLMULTI, sg))
+		dev_warn(&dev->dev, "Failed to %sable allmulti mode.\n",
+			 vi->ctrl->allmulti ? "en" : "dis");
+
+	uc_count = netdev_uc_count(dev);
+	mc_count = netdev_mc_count(dev);
+	/* MAC filter - use one buffer for both lists */
+	buf = kzalloc(((uc_count + mc_count) * ETH_ALEN) +
+		      (2 * sizeof(mac_data->entries)), GFP_ATOMIC);
+	mac_data = buf;
+	if (!buf)
+		return;
+
+	sg_init_table(sg, 2);
+
+	/* Store the unicast list and count in the front of the buffer */
+	mac_data->entries = cpu_to_virtio32(vi->vdev, uc_count);
+	i = 0;
+	netdev_for_each_uc_addr(ha, dev)
+		memcpy(&mac_data->macs[i++][0], ha->addr, ETH_ALEN);
+
+	sg_set_buf(&sg[0], mac_data,
+		   sizeof(mac_data->entries) + (uc_count * ETH_ALEN));
+
+	/* multicast list and count fill the end */
+	mac_data = (void *)&mac_data->macs[uc_count][0];
+
+	mac_data->entries = cpu_to_virtio32(vi->vdev, mc_count);
+	i = 0;
+	netdev_for_each_mc_addr(ha, dev)
+		memcpy(&mac_data->macs[i++][0], ha->addr, ETH_ALEN);
+
+	sg_set_buf(&sg[1], mac_data,
+		   sizeof(mac_data->entries) + (mc_count * ETH_ALEN));
+
+	if (!virtnet_send_command(vi, VIRTIO_NET_CTRL_MAC,
+				  VIRTIO_NET_CTRL_MAC_TABLE_SET, sg))
+		dev_warn(&dev->dev, "Failed to set MAC filter table.\n");
+
+	kfree(buf);
+}
+
+int virtnet_vlan_rx_add_vid(struct net_device *dev, __be16 proto, u16 vid)
+{
+	struct virtnet_info *vi = netdev_priv(dev);
+	struct scatterlist sg;
+
+	vi->ctrl->vid = cpu_to_virtio16(vi->vdev, vid);
+	sg_init_one(&sg, &vi->ctrl->vid, sizeof(vi->ctrl->vid));
+
+	if (!virtnet_send_command(vi, VIRTIO_NET_CTRL_VLAN,
+				  VIRTIO_NET_CTRL_VLAN_ADD, &sg))
+		dev_warn(&dev->dev, "Failed to add VLAN ID %d.\n", vid);
+	return 0;
+}
+
+int virtnet_vlan_rx_kill_vid(struct net_device *dev, __be16 proto, u16 vid)
+{
+	struct virtnet_info *vi = netdev_priv(dev);
+	struct scatterlist sg;
+
+	vi->ctrl->vid = cpu_to_virtio16(vi->vdev, vid);
+	sg_init_one(&sg, &vi->ctrl->vid, sizeof(vi->ctrl->vid));
+
+	if (!virtnet_send_command(vi, VIRTIO_NET_CTRL_VLAN,
+				  VIRTIO_NET_CTRL_VLAN_DEL, &sg))
+		dev_warn(&dev->dev, "Failed to kill VLAN ID %d.\n", vid);
+	return 0;
+}
+
+bool virtnet_commit_rss_command(struct virtnet_info *vi)
+{
+	struct net_device *dev = vi->dev;
+	struct scatterlist sgs[4];
+	unsigned int sg_buf_size;
+
+	/* prepare sgs */
+	sg_init_table(sgs, 4);
+
+	sg_buf_size = offsetof(struct virtio_net_ctrl_rss, indirection_table);
+	sg_set_buf(&sgs[0], &vi->ctrl->rss, sg_buf_size);
+
+	sg_buf_size = sizeof(uint16_t) * (vi->ctrl->rss.indirection_table_mask + 1);
+	sg_set_buf(&sgs[1], vi->ctrl->rss.indirection_table, sg_buf_size);
+
+	sg_buf_size = offsetof(struct virtio_net_ctrl_rss, key)
+			- offsetof(struct virtio_net_ctrl_rss, max_tx_vq);
+	sg_set_buf(&sgs[2], &vi->ctrl->rss.max_tx_vq, sg_buf_size);
+
+	sg_buf_size = vi->rss_key_size;
+	sg_set_buf(&sgs[3], vi->ctrl->rss.key, sg_buf_size);
+
+	if (!virtnet_send_command(vi, VIRTIO_NET_CTRL_MQ,
+				  vi->has_rss ? VIRTIO_NET_CTRL_MQ_RSS_CONFIG
+				  : VIRTIO_NET_CTRL_MQ_HASH_CONFIG, sgs)) {
+		dev_warn(&dev->dev, "VIRTIONET issue with committing RSS sgs\n");
+		return false;
+	}
+	return true;
+}
+
+int virtnet_send_notf_coal_cmds(struct virtnet_info *vi, struct ethtool_coalesce *ec)
+{
+	struct scatterlist sgs_tx, sgs_rx;
+	struct virtio_net_ctrl_coal_tx coal_tx;
+	struct virtio_net_ctrl_coal_rx coal_rx;
+
+	coal_tx.tx_usecs = cpu_to_le32(ec->tx_coalesce_usecs);
+	coal_tx.tx_max_packets = cpu_to_le32(ec->tx_max_coalesced_frames);
+	sg_init_one(&sgs_tx, &coal_tx, sizeof(coal_tx));
+
+	if (!virtnet_send_command(vi, VIRTIO_NET_CTRL_NOTF_COAL,
+				  VIRTIO_NET_CTRL_NOTF_COAL_TX_SET,
+				  &sgs_tx))
+		return -EINVAL;
+
+	/* Save parameters */
+	vi->tx_usecs = ec->tx_coalesce_usecs;
+	vi->tx_max_packets = ec->tx_max_coalesced_frames;
+
+	coal_rx.rx_usecs = cpu_to_le32(ec->rx_coalesce_usecs);
+	coal_rx.rx_max_packets = cpu_to_le32(ec->rx_max_coalesced_frames);
+	sg_init_one(&sgs_rx, &coal_rx, sizeof(coal_rx));
+
+	if (!virtnet_send_command(vi, VIRTIO_NET_CTRL_NOTF_COAL,
+				  VIRTIO_NET_CTRL_NOTF_COAL_RX_SET,
+				  &sgs_rx))
+		return -EINVAL;
+
+	/* Save parameters */
+	vi->rx_usecs = ec->rx_coalesce_usecs;
+	vi->rx_max_packets = ec->rx_max_coalesced_frames;
+
+	return 0;
+}
+
+int virtnet_set_guest_offloads(struct virtnet_info *vi, u64 offloads)
+{
+	struct scatterlist sg;
+	vi->ctrl->offloads = cpu_to_virtio64(vi->vdev, offloads);
+
+	sg_init_one(&sg, &vi->ctrl->offloads, sizeof(vi->ctrl->offloads));
+
+	if (!virtnet_send_command(vi, VIRTIO_NET_CTRL_GUEST_OFFLOADS,
+				  VIRTIO_NET_CTRL_GUEST_OFFLOADS_SET, &sg)) {
+		dev_warn(&vi->dev->dev, "Fail to set guest offload.\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
diff --git a/drivers/net/virtio/virtnet_ctrl.h b/drivers/net/virtio/virtnet_ctrl.h
new file mode 100644
index 000000000000..f5cd3099264b
--- /dev/null
+++ b/drivers/net/virtio/virtnet_ctrl.h
@@ -0,0 +1,45 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+
+#ifndef __VIRTNET_CTRL_H__
+#define __VIRTNET_CTRL_H__
+
+/* This structure can contain rss message with maximum settings for indirection table and keysize
+ * Note, that default structure that describes RSS configuration virtio_net_rss_config
+ * contains same info but can't handle table values.
+ * In any case, structure would be passed to virtio hw through sg_buf split by parts
+ * because table sizes may be differ according to the device configuration.
+ */
+#define VIRTIO_NET_RSS_MAX_KEY_SIZE     40
+#define VIRTIO_NET_RSS_MAX_TABLE_LEN    128
+struct virtio_net_ctrl_rss {
+	u32 hash_types;
+	u16 indirection_table_mask;
+	u16 unclassified_queue;
+	u16 indirection_table[VIRTIO_NET_RSS_MAX_TABLE_LEN];
+	u16 max_tx_vq;
+	u8 hash_key_length;
+	u8 key[VIRTIO_NET_RSS_MAX_KEY_SIZE];
+};
+
+/* Control VQ buffers: protected by the rtnl lock */
+struct control_buf {
+	struct virtio_net_ctrl_hdr hdr;
+	virtio_net_ctrl_ack status;
+	struct virtio_net_ctrl_mq mq;
+	u8 promisc;
+	u8 allmulti;
+	__virtio16 vid;
+	__virtio64 offloads;
+	struct virtio_net_ctrl_rss rss;
+};
+
+int virtnet_ctrl_set_mac_address(struct virtnet_info *vi, const void *addr, int len);
+void virtnet_ack_link_announce(struct virtnet_info *vi);
+int virtnet_ctrl_set_queues(struct virtnet_info *vi, u16 queue_pairs);
+void virtnet_set_rx_mode(struct net_device *dev);
+int virtnet_vlan_rx_add_vid(struct net_device *dev, __be16 proto, u16 vid);
+int virtnet_vlan_rx_kill_vid(struct net_device *dev, __be16 proto, u16 vid);
+bool virtnet_commit_rss_command(struct virtnet_info *vi);
+int virtnet_send_notf_coal_cmds(struct virtnet_info *vi, struct ethtool_coalesce *ec);
+int virtnet_set_guest_offloads(struct virtnet_info *vi, u64 offloads);
+#endif
-- 
2.32.0.3.g01195cf9f

