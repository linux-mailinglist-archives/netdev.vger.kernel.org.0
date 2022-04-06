Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B1294F5DBC
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 14:22:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232847AbiDFMTB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 08:19:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233194AbiDFMSL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 08:18:11 -0400
Received: from out30-42.freemail.mail.aliyun.com (out30-42.freemail.mail.aliyun.com [115.124.30.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1D7B2963D1;
        Tue,  5 Apr 2022 20:45:01 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=34;SR=0;TI=SMTPD_---0V9KCOR._1649216693;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0V9KCOR._1649216693)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 06 Apr 2022 11:44:54 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     virtualization@lists.linux-foundation.org
Cc:     Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Gross <markgross@kernel.org>,
        Vadim Pasternak <vadimp@nvidia.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Vincent Whitchurch <vincent.whitchurch@axis.com>,
        linux-um@lists.infradead.org, netdev@vger.kernel.org,
        platform-driver-x86@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH v9 31/32] virtio_net: support rx/tx queue resize
Date:   Wed,  6 Apr 2022 11:43:45 +0800
Message-Id: <20220406034346.74409-32-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20220406034346.74409-1-xuanzhuo@linux.alibaba.com>
References: <20220406034346.74409-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
X-Git-Hash: 881cb3483d12
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch implements the resize function of the rx, tx queues.
Based on this function, it is possible to modify the ring num of the
queue.

There may be an exception during the resize process, the resize may
fail, or the vq can no longer be used. Either way, we must execute
napi_enable(). Because napi_disable is similar to a lock, napi_enable
must be called after calling napi_disable.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 drivers/net/virtio_net.c | 81 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 81 insertions(+)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index b8bf00525177..ba6859f305f7 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -251,6 +251,9 @@ struct padded_vnet_hdr {
 	char padding[4];
 };
 
+static void virtnet_sq_free_unused_buf(struct virtqueue *vq, void *buf);
+static void virtnet_rq_free_unused_buf(struct virtqueue *vq, void *buf);
+
 static bool is_xdp_frame(void *ptr)
 {
 	return (unsigned long)ptr & VIRTIO_XDP_FLAG;
@@ -1369,6 +1372,15 @@ static void virtnet_napi_enable(struct virtqueue *vq, struct napi_struct *napi)
 {
 	napi_enable(napi);
 
+	/* Check if vq is in reset state. The normal reset/resize process will
+	 * be protected by napi. However, the protection of napi is only enabled
+	 * during the operation, and the protection of napi will end after the
+	 * operation is completed. If re-enable fails during the process, vq
+	 * will remain unavailable with reset state.
+	 */
+	if (vq->reset)
+		return;
+
 	/* If all buffers were filled by other side before we napi_enabled, we
 	 * won't get another interrupt, so process any outstanding packets now.
 	 * Call local_bh_enable after to trigger softIRQ processing.
@@ -1413,6 +1425,15 @@ static void refill_work(struct work_struct *work)
 		struct receive_queue *rq = &vi->rq[i];
 
 		napi_disable(&rq->napi);
+
+		/* Check if vq is in reset state. See more in
+		 * virtnet_napi_enable()
+		 */
+		if (rq->vq->reset) {
+			virtnet_napi_enable(rq->vq, &rq->napi);
+			continue;
+		}
+
 		still_empty = !try_fill_recv(vi, rq, GFP_KERNEL);
 		virtnet_napi_enable(rq->vq, &rq->napi);
 
@@ -1523,6 +1544,10 @@ static void virtnet_poll_cleantx(struct receive_queue *rq)
 	if (!sq->napi.weight || is_xdp_raw_buffer_queue(vi, index))
 		return;
 
+	/* Check if vq is in reset state. See more in virtnet_napi_enable() */
+	if (sq->vq->reset)
+		return;
+
 	if (__netif_tx_trylock(txq)) {
 		do {
 			virtqueue_disable_cb(sq->vq);
@@ -1769,6 +1794,62 @@ static netdev_tx_t start_xmit(struct sk_buff *skb, struct net_device *dev)
 	return NETDEV_TX_OK;
 }
 
+static int virtnet_rx_resize(struct virtnet_info *vi,
+			     struct receive_queue *rq, u32 ring_num)
+{
+	int err;
+
+	napi_disable(&rq->napi);
+
+	err = virtqueue_resize(rq->vq, ring_num, virtnet_rq_free_unused_buf);
+	if (err)
+		goto err;
+
+	if (!try_fill_recv(vi, rq, GFP_KERNEL))
+		schedule_delayed_work(&vi->refill, 0);
+
+	virtnet_napi_enable(rq->vq, &rq->napi);
+	return 0;
+
+err:
+	netdev_err(vi->dev,
+		   "reset rx reset vq fail: rx queue index: %td err: %d\n",
+		   rq - vi->rq, err);
+	virtnet_napi_enable(rq->vq, &rq->napi);
+	return err;
+}
+
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
+	__netif_tx_lock_bh(txq);
+	netif_stop_subqueue(vi->dev, qindex);
+	__netif_tx_unlock_bh(txq);
+
+	err = virtqueue_resize(sq->vq, ring_num, virtnet_sq_free_unused_buf);
+	if (err)
+		goto err;
+
+	netif_start_subqueue(vi->dev, qindex);
+	virtnet_napi_tx_enable(vi, sq->vq, &sq->napi);
+	return 0;
+
+err:
+	netdev_err(vi->dev,
+		   "reset tx reset vq fail: tx queue index: %td err: %d\n",
+		   sq - vi->sq, err);
+	virtnet_napi_tx_enable(vi, sq->vq, &sq->napi);
+	return err;
+}
+
 /*
  * Send command via the control virtqueue and check status.  Commands
  * supported by the hypervisor, as indicated by feature bits, should
-- 
2.31.0

