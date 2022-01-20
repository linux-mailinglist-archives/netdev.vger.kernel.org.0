Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00A0A494790
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 07:44:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358783AbiATGnf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 01:43:35 -0500
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:52677 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1358806AbiATGnV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 01:43:21 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R941e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0V2KlUeA_1642660996;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0V2KlUeA_1642660996)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 20 Jan 2022 14:43:17 +0800
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
Subject: [PATCH v2 12/12] virtio-net: support pair disable/enable
Date:   Thu, 20 Jan 2022 14:43:03 +0800
Message-Id: <20220120064303.106639-13-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20220120064303.106639-1-xuanzhuo@linux.alibaba.com>
References: <20220120064303.106639-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch implements virtio-net rx/tx pair disable/enable functionality
based on virtio queue reset. The purpose of the current implementation
is to quickly recycle the buffer submitted to vq.

In the process of pair disable, in theory, as long as virtio supports
queue reset, there will be no exceptions.

However, in the process of pari enable, there may be exceptions due to
memory allocation. In this case, vq == NULL, but napi will still
be enabled. Because napi_disable is similar to a lock, napi_enable must
be called after calling napi_disable.

Since enable fails, the driver will not receive an interrupt from the
device to wake up napi, so the driver is safe. But we still need to add
vq checks in some places to ensure safety, such as refill_work().

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 drivers/net/virtio_net.c | 148 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 148 insertions(+)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index ea90a1a57c9e..dba95553247c 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -1369,6 +1369,9 @@ static void virtnet_napi_enable(struct virtqueue *vq, struct napi_struct *napi)
 {
 	napi_enable(napi);
 
+	if (!vq)
+		return;
+
 	/* If all buffers were filled by other side before we napi_enabled, we
 	 * won't get another interrupt, so process any outstanding packets now.
 	 * Call local_bh_enable after to trigger softIRQ processing.
@@ -1413,6 +1416,10 @@ static void refill_work(struct work_struct *work)
 		struct receive_queue *rq = &vi->rq[i];
 
 		napi_disable(&rq->napi);
+		if (!rq->vq) {
+			virtnet_napi_enable(rq->vq, &rq->napi);
+			continue;
+		}
 		still_empty = !try_fill_recv(vi, rq, GFP_KERNEL);
 		virtnet_napi_enable(rq->vq, &rq->napi);
 
@@ -2871,6 +2878,147 @@ static unsigned int mergeable_min_buf_len(struct virtnet_info *vi, struct virtqu
 		   (unsigned int)GOOD_PACKET_LEN);
 }
 
+static void virtnet_rq_free_unused_buf_cb(struct virtio_device *vdev,
+					  void *buf, void *data)
+{
+	virtnet_rq_free_unused_buf(vdev->priv, data, buf);
+}
+
+static void virtnet_sq_free_unused_buf_cb(struct virtio_device *vdev,
+					  void *buf, void *data)
+{
+	virtnet_rq_free_unused_buf(vdev->priv, data, buf);
+}
+
+static int __virtnet_rx_vq_disable(struct virtnet_info *vi,
+				   struct receive_queue *rq)
+{
+	int err, qnum;
+
+	qnum = rxq2vq(rq - vi->rq);
+
+	napi_disable(&rq->napi);
+
+	err = virtio_reset_vq(vi->vdev, qnum, virtnet_rq_free_unused_buf_cb, rq);
+	if (err) {
+		virtnet_napi_enable(rq->vq, &rq->napi);
+		return err;
+	}
+
+	rq->vq = NULL;
+
+	return err;
+}
+
+static int __virtnet_tx_vq_disable(struct virtnet_info *vi,
+				   struct send_queue *sq)
+{
+	struct netdev_queue *txq;
+	int err, qnum;
+
+	qnum = txq2vq(sq - vi->sq);
+
+	netif_stop_subqueue(vi->dev, sq - vi->sq);
+	virtnet_napi_tx_disable(&sq->napi);
+
+	/* wait xmit done */
+	txq = netdev_get_tx_queue(vi->dev, qnum);
+	__netif_tx_lock(txq, raw_smp_processor_id());
+	__netif_tx_unlock(txq);
+
+	err = virtio_reset_vq(vi->vdev, qnum, virtnet_sq_free_unused_buf_cb, sq);
+	if (err) {
+		virtnet_napi_tx_enable(vi, sq->vq, &sq->napi);
+		netif_start_subqueue(vi->dev, sq - vi->sq);
+		return err;
+	}
+
+	sq->vq = NULL;
+
+	return err;
+}
+
+static int virtnet_pair_disable(struct virtnet_info *vi, int i)
+{
+	int err;
+
+	err = __virtnet_rx_vq_disable(vi, vi->rq + i);
+	if (err)
+		return err;
+
+	return __virtnet_tx_vq_disable(vi, vi->sq + i);
+}
+
+static int virtnet_enable_resetq(struct virtnet_info *vi,
+				 struct receive_queue *rq,
+				 struct send_queue *sq)
+{
+	vq_callback_t *callback;
+	struct virtqueue *vq;
+	const char *name;
+	int vq_idx;
+	bool ctx;
+
+	if (rq) {
+		vq = rq->vq;
+		vq_idx = rxq2vq(rq - vi->rq);
+		callback = skb_recv_done;
+		name = rq->name;
+
+	} else {
+		vq = sq->vq;
+		vq_idx = txq2vq(sq - vi->sq);
+		callback = skb_xmit_done;
+		name = sq->name;
+	}
+
+	if (vq)
+		return -EBUSY;
+
+	if (!vi->big_packets || vi->mergeable_rx_bufs)
+		ctx = true;
+	else
+		ctx = false;
+
+	vq = virtio_enable_resetq(vi->vdev, vq_idx, callback, name, &ctx);
+	if (IS_ERR(vq))
+		return PTR_ERR(vq);
+
+	if (rq)
+		rq->vq = vq;
+	else
+		sq->vq = vq;
+
+	return 0;
+}
+
+static int virtnet_pair_enable(struct virtnet_info *vi, int i)
+{
+	struct receive_queue *rq;
+	struct send_queue *sq;
+	int err;
+
+	rq = vi->rq + i;
+	sq = vi->sq + i;
+
+	/* tx */
+	err = virtnet_enable_resetq(vi, NULL, sq);
+	if (err)
+		goto err;
+	else
+		netif_start_subqueue(vi->dev, sq - vi->sq);
+
+	/* rx */
+	err = virtnet_enable_resetq(vi, rq, NULL);
+	if (err)
+		return err;
+
+err:
+	virtnet_napi_tx_enable(vi, sq->vq, &sq->napi);
+	virtnet_napi_enable(rq->vq, &rq->napi);
+	return 0;
+}
+
 static int virtnet_find_vqs(struct virtnet_info *vi)
 {
 	vq_callback_t **callbacks;
-- 
2.31.0

