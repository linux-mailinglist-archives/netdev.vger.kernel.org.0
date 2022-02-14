Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C72D4B4397
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 09:15:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241687AbiBNIPK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 03:15:10 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241691AbiBNIPF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 03:15:05 -0500
Received: from out30-54.freemail.mail.aliyun.com (out30-54.freemail.mail.aliyun.com [115.124.30.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C14C15F8FF;
        Mon, 14 Feb 2022 00:14:57 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0V4O5xBg_1644826480;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0V4O5xBg_1644826480)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 14 Feb 2022 16:14:41 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>, bpf@vger.kernel.org
Subject: [PATCH v5 22/22] virtio_net: support set_ringparam
Date:   Mon, 14 Feb 2022 16:14:16 +0800
Message-Id: <20220214081416.117695-23-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20220214081416.117695-1-xuanzhuo@linux.alibaba.com>
References: <20220214081416.117695-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
X-Git-Hash: 24fd8391539b
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Support set_ringparam based on virtio queue reset.

The rx,tx_pending required to be passed must be power of 2.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 drivers/net/virtio_net.c | 50 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 50 insertions(+)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index f9bb760c6dbd..bf460ea87354 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -2308,6 +2308,55 @@ static void virtnet_get_ringparam(struct net_device *dev,
 	ring->tx_pending = virtqueue_get_vring_size(vi->sq[0].vq);
 }
 
+static int virtnet_set_ringparam(struct net_device *dev,
+				 struct ethtool_ringparam *ring,
+				 struct kernel_ethtool_ringparam *kernel_ring,
+				 struct netlink_ext_ack *extack)
+{
+	struct virtnet_info *vi = netdev_priv(dev);
+	u32 rx_pending, tx_pending;
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
+	if (ring->rx_pending > virtqueue_get_vring_max_size(vi->rq[0].vq))
+		return -EINVAL;
+
+	if (ring->tx_pending > virtqueue_get_vring_max_size(vi->sq[0].vq))
+		return -EINVAL;
+
+	if (!is_power_of_2(ring->rx_pending))
+		return -EINVAL;
+
+	if (!is_power_of_2(ring->tx_pending))
+		return -EINVAL;
+
+	for (i = 0; i < vi->max_queue_pairs; i++) {
+		if (ring->tx_pending != tx_pending) {
+			virtio_set_max_ring_num(vi->vdev, ring->tx_pending);
+			err = virtnet_tx_vq_reset(vi, i);
+			if (err)
+				return err;
+		}
+
+		if (ring->rx_pending != rx_pending) {
+			virtio_set_max_ring_num(vi->vdev, ring->rx_pending);
+			err = virtnet_rx_vq_reset(vi, i);
+			if (err)
+				return err;
+		}
+	}
+
+	return 0;
+}
 
 static void virtnet_get_drvinfo(struct net_device *dev,
 				struct ethtool_drvinfo *info)
@@ -2541,6 +2590,7 @@ static const struct ethtool_ops virtnet_ethtool_ops = {
 	.get_drvinfo = virtnet_get_drvinfo,
 	.get_link = ethtool_op_get_link,
 	.get_ringparam = virtnet_get_ringparam,
+	.set_ringparam = virtnet_set_ringparam,
 	.get_strings = virtnet_get_strings,
 	.get_sset_count = virtnet_get_sset_count,
 	.get_ethtool_stats = virtnet_get_ethtool_stats,
-- 
2.31.0

