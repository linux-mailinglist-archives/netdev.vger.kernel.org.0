Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E234E6CBAE2
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 11:31:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232804AbjC1J3p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 05:29:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232477AbjC1J3Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 05:29:24 -0400
Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C1CC6EA7;
        Tue, 28 Mar 2023 02:28:58 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046051;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0VesYnUJ_1679995734;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VesYnUJ_1679995734)
          by smtp.aliyun-inc.com;
          Tue, 28 Mar 2023 17:28:55 +0800
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
Subject: [PATCH 06/16] virtio_net: separate virtnet_ctrl_set_mac_address()
Date:   Tue, 28 Mar 2023 17:28:37 +0800
Message-Id: <20230328092847.91643-7-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.32.0.3.g01195cf9f
In-Reply-To: <20230328092847.91643-1-xuanzhuo@linux.alibaba.com>
References: <20230328092847.91643-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
X-Git-Hash: e880b402863c
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.0 required=5.0 tests=ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Separating the code setting MAC by cq to a function.

This is to facilitate separating cq-related functions into a separate
file.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 drivers/net/virtio/virtnet.c | 31 +++++++++++++++++++------------
 1 file changed, 19 insertions(+), 12 deletions(-)

diff --git a/drivers/net/virtio/virtnet.c b/drivers/net/virtio/virtnet.c
index 0196492f289b..6ad217af44d9 100644
--- a/drivers/net/virtio/virtnet.c
+++ b/drivers/net/virtio/virtnet.c
@@ -1982,13 +1982,29 @@ static bool virtnet_send_command(struct virtnet_info *vi, u8 class, u8 cmd,
 	return vi->ctrl->status == VIRTIO_NET_OK;
 }
 
+static int virtnet_ctrl_set_mac_address(struct virtnet_info *vi, const void *addr, int len)
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
 static int virtnet_set_mac_address(struct net_device *dev, void *p)
 {
 	struct virtnet_info *vi = netdev_priv(dev);
 	struct virtio_device *vdev = vi->vdev;
 	int ret;
 	struct sockaddr *addr;
-	struct scatterlist sg;
 
 	if (virtio_has_feature(vi->vdev, VIRTIO_NET_F_STANDBY))
 		return -EOPNOTSUPP;
@@ -2002,11 +2018,7 @@ static int virtnet_set_mac_address(struct net_device *dev, void *p)
 		goto out;
 
 	if (virtio_has_feature(vdev, VIRTIO_NET_F_CTRL_MAC_ADDR)) {
-		sg_init_one(&sg, addr->sa_data, dev->addr_len);
-		if (!virtnet_send_command(vi, VIRTIO_NET_CTRL_MAC,
-					  VIRTIO_NET_CTRL_MAC_ADDR_SET, &sg)) {
-			dev_warn(&vdev->dev,
-				 "Failed to set mac address by vq command.\n");
+		if (virtnet_ctrl_set_mac_address(vi, addr->sa_data, dev->addr_len)) {
 			ret = -EINVAL;
 			goto out;
 		}
@@ -3822,12 +3834,7 @@ static int virtnet_probe(struct virtio_device *vdev)
 	 */
 	if (!virtio_has_feature(vdev, VIRTIO_NET_F_MAC) &&
 	    virtio_has_feature(vi->vdev, VIRTIO_NET_F_CTRL_MAC_ADDR)) {
-		struct scatterlist sg;
-
-		sg_init_one(&sg, dev->dev_addr, dev->addr_len);
-		if (!virtnet_send_command(vi, VIRTIO_NET_CTRL_MAC,
-					  VIRTIO_NET_CTRL_MAC_ADDR_SET, &sg)) {
-			pr_debug("virtio_net: setting MAC address failed\n");
+		if (virtnet_ctrl_set_mac_address(vi, dev->dev_addr, dev->addr_len)) {
 			rtnl_unlock();
 			err = -EINVAL;
 			goto free_unregister_netdev;
-- 
2.32.0.3.g01195cf9f

