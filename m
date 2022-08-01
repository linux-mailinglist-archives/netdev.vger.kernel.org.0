Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65AEE5864E6
	for <lists+netdev@lfdr.de>; Mon,  1 Aug 2022 08:44:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239654AbiHAGnP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 02:43:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238120AbiHAGmb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 02:42:31 -0400
Received: from out30-43.freemail.mail.aliyun.com (out30-43.freemail.mail.aliyun.com [115.124.30.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C97E1167D8;
        Sun, 31 Jul 2022 23:40:28 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R991e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045176;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=37;SR=0;TI=SMTPD_---0VL1cDPt_1659336021;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VL1cDPt_1659336021)
          by smtp.aliyun-inc.com;
          Mon, 01 Aug 2022 14:40:22 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     virtualization@lists.linux-foundation.org
Cc:     Richard Weinberger <richard@nod.at>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Gross <markgross@kernel.org>,
        Vadim Pasternak <vadimp@nvidia.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Vincent Whitchurch <vincent.whitchurch@axis.com>,
        linux-um@lists.infradead.org, netdev@vger.kernel.org,
        platform-driver-x86@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, bpf@vger.kernel.org,
        kangjie.xu@linux.alibaba.com
Subject: [PATCH v14 41/42] virtio_net: support tx queue resize
Date:   Mon,  1 Aug 2022 14:39:01 +0800
Message-Id: <20220801063902.129329-42-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20220801063902.129329-1-xuanzhuo@linux.alibaba.com>
References: <20220801063902.129329-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
X-Git-Hash: 0f12e405b061
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

This patch implements the resize function of the tx queues.
Based on this function, it is possible to modify the ring num of the
queue.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Acked-by: Jason Wang <jasowang@redhat.com>
---
 drivers/net/virtio_net.c | 47 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 47 insertions(+)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 1115a8b59a08..d1e6940b46d8 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -135,6 +135,9 @@ struct send_queue {
 	struct virtnet_sq_stats stats;
 
 	struct napi_struct napi;
+
+	/* Record whether sq is in reset state. */
+	bool reset;
 };
 
 /* Internal representation of a receive virtqueue */
@@ -279,6 +282,7 @@ struct padded_vnet_hdr {
 };
 
 static void virtnet_rq_free_unused_buf(struct virtqueue *vq, void *buf);
+static void virtnet_sq_free_unused_buf(struct virtqueue *vq, void *buf);
 
 static bool is_xdp_frame(void *ptr)
 {
@@ -1603,6 +1607,11 @@ static void virtnet_poll_cleantx(struct receive_queue *rq)
 		return;
 
 	if (__netif_tx_trylock(txq)) {
+		if (sq->reset) {
+			__netif_tx_unlock(txq);
+			return;
+		}
+
 		do {
 			virtqueue_disable_cb(sq->vq);
 			free_old_xmit_skbs(sq, true);
@@ -1868,6 +1877,44 @@ static int virtnet_rx_resize(struct virtnet_info *vi,
 	return err;
 }
 
+static int virtnet_tx_resize(struct virtnet_info *vi,
+			     struct send_queue *sq, u32 ring_num)
+{
+	struct netdev_queue *txq;
+	int err, qindex;
+
+	qindex = sq - vi->sq;
+
+	virtnet_napi_tx_disable(&sq->napi);
+
+	txq = netdev_get_tx_queue(vi->dev, qindex);
+
+	/* 1. wait all ximt complete
+	 * 2. fix the race of netif_stop_subqueue() vs netif_start_subqueue()
+	 */
+	__netif_tx_lock_bh(txq);
+
+	/* Prevent rx poll from accessing sq. */
+	sq->reset = true;
+
+	/* Prevent the upper layer from trying to send packets. */
+	netif_stop_subqueue(vi->dev, qindex);
+
+	__netif_tx_unlock_bh(txq);
+
+	err = virtqueue_resize(sq->vq, ring_num, virtnet_sq_free_unused_buf);
+	if (err)
+		netdev_err(vi->dev, "resize tx fail: tx queue index: %d err: %d\n", qindex, err);
+
+	__netif_tx_lock_bh(txq);
+	sq->reset = false;
+	netif_tx_wake_queue(txq);
+	__netif_tx_unlock_bh(txq);
+
+	virtnet_napi_tx_enable(vi, sq->vq, &sq->napi);
+	return err;
+}
+
 /*
  * Send command via the control virtqueue and check status.  Commands
  * supported by the hypervisor, as indicated by feature bits, should
-- 
2.31.0

