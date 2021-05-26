Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5D7839165D
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 13:40:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232537AbhEZLmF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 07:42:05 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:3976 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232141AbhEZLmF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 07:42:05 -0400
Received: from dggems706-chm.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Fqpnd4JYrzQrx0;
        Wed, 26 May 2021 19:36:53 +0800 (CST)
Received: from dggpemm500008.china.huawei.com (7.185.36.136) by
 dggems706-chm.china.huawei.com (10.3.19.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 26 May 2021 19:40:31 +0800
Received: from localhost (10.174.243.60) by dggpemm500008.china.huawei.com
 (7.185.36.136) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Wed, 26 May
 2021 19:40:30 +0800
From:   wangyunjian <wangyunjian@huawei.com>
To:     <netdev@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <mst@redhat.com>,
        <jasowang@redhat.com>, <virtualization@lists.linux-foundation.org>,
        <dingxiaoxiong@huawei.com>, Yunjian Wang <wangyunjian@huawei.com>
Subject: [PATCH net-next] virtio_net: set link state down when virtqueue is broken
Date:   Wed, 26 May 2021 19:39:51 +0800
Message-ID: <79907bf6c835572b4af92f16d9a3ff2822b1c7ea.1622028946.git.wangyunjian@huawei.com>
X-Mailer: git-send-email 1.9.5.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.243.60]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemm500008.china.huawei.com (7.185.36.136)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yunjian Wang <wangyunjian@huawei.com>

The NIC can't receive/send packets if a rx/tx virtqueue is broken.
However, the link state of the NIC is still normal. As a result,
the user cannot detect the NIC exception.

The driver can set the link state down when the virtqueue is broken.
If the state is down, the user can switch over to another NIC.

Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>
---
 drivers/net/virtio_net.c | 36 +++++++++++++++++++++++++++++++++++-
 1 file changed, 35 insertions(+), 1 deletion(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 073fec4c0df1..05a3cd1c589b 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -237,6 +237,10 @@ struct virtnet_info {
 
 	/* failover when STANDBY feature enabled */
 	struct failover *failover;
+
+	/* Work struct for checking vq status, stop NIC if vq is broken. */
+	struct delayed_work vq_check_work;
+	bool broken;
 };
 
 struct padded_vnet_hdr {
@@ -1407,6 +1411,27 @@ static void refill_work(struct work_struct *work)
 	}
 }
 
+static void virnet_vq_check_work(struct work_struct *work)
+{
+	struct virtnet_info *vi =
+		container_of(work, struct virtnet_info, vq_check_work.work);
+	struct net_device *netdev = vi->dev;
+	int i;
+
+	if (vi->broken)
+		return;
+
+	/* If virtqueue is broken, set link down and stop all queues */
+	for (i = 0; i < vi->max_queue_pairs; i++) {
+		if (virtqueue_is_broken(vi->rq[i].vq) || virtqueue_is_broken(vi->sq[i].vq)) {
+			netif_carrier_off(netdev);
+			netif_tx_stop_all_queues(netdev);
+			vi->broken = true;
+			break;
+		}
+	}
+}
+
 static int virtnet_receive(struct receive_queue *rq, int budget,
 			   unsigned int *xdp_xmit)
 {
@@ -1432,6 +1457,9 @@ static int virtnet_receive(struct receive_queue *rq, int budget,
 		}
 	}
 
+	if (unlikely(!virtqueue_is_broken(rq->vq)))
+		schedule_delayed_work(&vi->vq_check_work, HZ);
+
 	if (rq->vq->num_free > min((unsigned int)budget, virtqueue_get_vring_size(rq->vq)) / 2) {
 		if (!try_fill_recv(vi, rq, GFP_ATOMIC))
 			schedule_delayed_work(&vi->refill, 0);
@@ -1681,6 +1709,7 @@ static netdev_tx_t start_xmit(struct sk_buff *skb, struct net_device *dev)
 				 qnum, err);
 		dev->stats.tx_dropped++;
 		dev_kfree_skb_any(skb);
+		schedule_delayed_work(&vi->vq_check_work, HZ);
 		return NETDEV_TX_OK;
 	}
 
@@ -1905,6 +1934,7 @@ static int virtnet_close(struct net_device *dev)
 
 	/* Make sure refill_work doesn't re-enable napi! */
 	cancel_delayed_work_sync(&vi->refill);
+	cancel_delayed_work_sync(&vi->vq_check_work);
 
 	for (i = 0; i < vi->max_queue_pairs; i++) {
 		xdp_rxq_info_unreg(&vi->rq[i].xdp_rxq);
@@ -2381,6 +2411,7 @@ static void virtnet_freeze_down(struct virtio_device *vdev)
 	netif_device_detach(vi->dev);
 	netif_tx_unlock_bh(vi->dev);
 	cancel_delayed_work_sync(&vi->refill);
+	cancel_delayed_work_sync(&vi->vq_check_work);
 
 	if (netif_running(vi->dev)) {
 		for (i = 0; i < vi->max_queue_pairs; i++) {
@@ -2662,7 +2693,7 @@ static void virtnet_config_changed_work(struct work_struct *work)
 
 	vi->status = v;
 
-	if (vi->status & VIRTIO_NET_S_LINK_UP) {
+	if ((vi->status & VIRTIO_NET_S_LINK_UP) && !vi->broken) {
 		virtnet_update_settings(vi);
 		netif_carrier_on(vi->dev);
 		netif_tx_wake_all_queues(vi->dev);
@@ -2889,6 +2920,8 @@ static int virtnet_alloc_queues(struct virtnet_info *vi)
 		goto err_rq;
 
 	INIT_DELAYED_WORK(&vi->refill, refill_work);
+	INIT_DELAYED_WORK(&vi->vq_check_work, virnet_vq_check_work);
+
 	for (i = 0; i < vi->max_queue_pairs; i++) {
 		vi->rq[i].pages = NULL;
 		netif_napi_add(vi->dev, &vi->rq[i].napi, virtnet_poll,
@@ -3240,6 +3273,7 @@ static int virtnet_probe(struct virtio_device *vdev)
 	net_failover_destroy(vi->failover);
 free_vqs:
 	cancel_delayed_work_sync(&vi->refill);
+	cancel_delayed_work_sync(&vi->vq_check_work);
 	free_receive_page_frags(vi);
 	virtnet_del_vqs(vi);
 free:
-- 
2.23.0

