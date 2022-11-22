Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6572063360D
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 08:44:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232496AbiKVHoE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 02:44:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232491AbiKVHn6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 02:43:58 -0500
Received: from out30-45.freemail.mail.aliyun.com (out30-45.freemail.mail.aliyun.com [115.124.30.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B0FA2FC1B;
        Mon, 21 Nov 2022 23:43:57 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046051;MF=hengqi@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0VVRAvuo_1669103031;
Received: from localhost(mailfrom:hengqi@linux.alibaba.com fp:SMTPD_---0VVRAvuo_1669103031)
          by smtp.aliyun-inc.com;
          Tue, 22 Nov 2022 15:43:52 +0800
From:   Heng Qi <hengqi@linux.alibaba.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Subject: [RFC PATCH 2/9] virtio_net: set up xdp for multi buffer packets
Date:   Tue, 22 Nov 2022 15:43:41 +0800
Message-Id: <20221122074348.88601-3-hengqi@linux.alibaba.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20221122074348.88601-1-hengqi@linux.alibaba.com>
References: <20221122074348.88601-1-hengqi@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the xdp program sets xdp.frags, which means it can process
multi-buffer packets, so we continue to open xdp support when
features such as GRO_HW are negotiated.

Signed-off-by: Heng Qi <hengqi@linux.alibaba.com>
Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 drivers/net/virtio_net.c | 30 +++++++++++++++++-------------
 1 file changed, 17 insertions(+), 13 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index c5046d21b281..8f7d207d58d6 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -3080,14 +3080,21 @@ static int virtnet_xdp_set(struct net_device *dev, struct bpf_prog *prog,
 	u16 xdp_qp = 0, curr_qp;
 	int i, err;
 
-	if (!virtio_has_feature(vi->vdev, VIRTIO_NET_F_CTRL_GUEST_OFFLOADS)
-	    && (virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_TSO4) ||
-	        virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_TSO6) ||
-	        virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_ECN) ||
-		virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_UFO) ||
-		virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_CSUM))) {
-		NL_SET_ERR_MSG_MOD(extack, "Can't set XDP while host is implementing GRO_HW/CSUM, disable GRO_HW/CSUM first");
-		return -EOPNOTSUPP;
+	if (!virtio_has_feature(vi->vdev, VIRTIO_NET_F_CTRL_GUEST_OFFLOADS)) {
+		if (virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_CSUM)) {
+			NL_SET_ERR_MSG_MOD(extack, "Can't set XDP without frags while guest is implementing GUEST_CSUM");
+			return -EOPNOTSUPP;
+		}
+
+		if (prog && !prog->aux->xdp_has_frags) {
+			if (virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_TSO4) ||
+			    virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_TSO6) ||
+			    virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_ECN) ||
+			    virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_UFO)) {
+				NL_SET_ERR_MSG_MOD(extack, "Can't set XDP without frags while guest is implementing GUEST_GRO_HW");
+				return -EOPNOTSUPP;
+			}
+		}
 	}
 
 	if (vi->mergeable_rx_bufs && !vi->any_header_sg) {
@@ -3095,8 +3102,8 @@ static int virtnet_xdp_set(struct net_device *dev, struct bpf_prog *prog,
 		return -EINVAL;
 	}
 
-	if (dev->mtu > max_sz) {
-		NL_SET_ERR_MSG_MOD(extack, "MTU too large to enable XDP");
+	if (prog && !prog->aux->xdp_has_frags && dev->mtu > max_sz) {
+		NL_SET_ERR_MSG_MOD(extack, "MTU too large to enable XDP without frags");
 		netdev_warn(dev, "XDP requires MTU less than %lu\n", max_sz);
 		return -EINVAL;
 	}
@@ -3218,9 +3225,6 @@ static int virtnet_set_features(struct net_device *dev,
 	int err;
 
 	if ((dev->features ^ features) & NETIF_F_GRO_HW) {
-		if (vi->xdp_enabled)
-			return -EBUSY;
-
 		if (features & NETIF_F_GRO_HW)
 			offloads = vi->guest_offloads_capable;
 		else
-- 
2.19.1.6.gb485710b

