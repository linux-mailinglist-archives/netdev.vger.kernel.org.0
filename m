Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D8A8105E4D
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 02:36:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726613AbfKVBgo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 20:36:44 -0500
Received: from mail-qt1-f196.google.com ([209.85.160.196]:33182 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726265AbfKVBgo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 20:36:44 -0500
Received: by mail-qt1-f196.google.com with SMTP id y39so6054143qty.0;
        Thu, 21 Nov 2019 17:36:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=j/rdj823c44COpV5cCERJMmYJupdnu4Z7k72/Pj6nfc=;
        b=qSCWEAf/Oq25XXc6GCeTD36O8i45C0HfRm0uyrEsaXcsOiov5e0aVxeBkVOixUvM8L
         HUUQKoqTZMF8wXSwjdueBDo4NjMgycaHrY4DSmsQwwQo/OvJ3bACYTuQaXUBbW79OjXW
         SNjNMxPDz6BCIgRhFsD/71hKWZg6w6fW8aP2Ee/in667aFydGJG9j/UdJrUOfnNXlABZ
         iqWBUjPNRdlcN+vkmerEMbBPyLhf+ZUCsNaK7IMJktmcNW/1SxiIEIZWgFEVZf4OTSUL
         DJYxY/Hes8TV9SmInbbK0rZZN0eeN7T8ISRb/zIiNc22XCdM3Y7Kz9/aNuGEZ1KBtflo
         FYog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=j/rdj823c44COpV5cCERJMmYJupdnu4Z7k72/Pj6nfc=;
        b=a2iIWCdZuhCd4nASb//jbPN3ZngAGDW9dSuef42Csp/6EPtiXAu2GfWYJCiSVcLT0Q
         zvdeKoaoLwuI4yGQZBaIJ8n9h5YIxr/wjGOkuuoySzFimYOOxhIz0nD0/WrgLLa5A10d
         NsuTAWVrnX+9+KEVHN6v/uQjuRAF5rPWxYF41zTh0DPyvd6O27+jLasJ5hlIHkTe/K35
         Dd9YHRhIG72gtXK6hPy0s3gE2ACjuzxYVr83ZNOGDnj79DSEm2O9hveF4pKP1KfXK8q/
         zfVl8WFcoQ0nJhsitsTKJueypL/P1zdjjNqWkmxGQRJsTEhE9cih2eGCOIbH59Py+3in
         Haqw==
X-Gm-Message-State: APjAAAVhEeJzIww7/Lab/SGAYP2o1P6gUOOGZoFVIebaf4XhIkcuMrqH
        2Z2HVdze6JZP3UOF7REX/KtncPs4
X-Google-Smtp-Source: APXvYqyPKeZrhMbgH8kJUD7OD1ngbGnzaM8S4gillMotJpVwQTjf7ylLCo8pDCds0mDFBg+mBkuY1A==
X-Received: by 2002:ac8:2441:: with SMTP id d1mr1579575qtd.386.1574386601064;
        Thu, 21 Nov 2019 17:36:41 -0800 (PST)
Received: from ubuntu.default ([191.254.197.220])
        by smtp.gmail.com with ESMTPSA id y28sm2485073qtk.65.2019.11.21.17.36.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Nov 2019 17:36:40 -0800 (PST)
From:   Julio Faracco <jcfaracco@gmail.com>
To:     netdev@vger.kernel.org
Cc:     dnmendes76@gmail.com, Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2] drivers: net: virtio_net: Implement a dev_watchdog handler
Date:   Thu, 21 Nov 2019 22:36:36 -0300
Message-Id: <20191122013636.1041-1-jcfaracco@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Driver virtio_net is not handling error events for TX provided by
dev_watchdog. This event is reached when transmission queue is having
problems to transmit packets. This could happen for any reason. To
enable it, driver should have .ndo_tx_timeout implemented.

This commit brings back virtnet_reset method to recover TX queues from a
error state. That function is called by schedule_work method and it puts
the reset function into work queue.

As the error cause is unknown at this moment, it would be better to
reset all queues.

Signed-off-by: Julio Faracco <jcfaracco@gmail.com>
Signed-off-by: Daiane Mendes <dnmendes76@gmail.com>
Cc: Jason Wang <jasowang@redhat.com>
---
v1-v2: Tag `net-next` was included to indentify where patch would be
applied.
---
 drivers/net/virtio_net.c | 95 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 94 insertions(+), 1 deletion(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 4d7d5434cc5d..31890d77eaf2 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -75,6 +75,7 @@ struct virtnet_sq_stats {
 	u64 xdp_tx;
 	u64 xdp_tx_drops;
 	u64 kicks;
+	u64 tx_timeouts;
 };
 
 struct virtnet_rq_stats {
@@ -98,6 +99,7 @@ static const struct virtnet_stat_desc virtnet_sq_stats_desc[] = {
 	{ "xdp_tx",		VIRTNET_SQ_STAT(xdp_tx) },
 	{ "xdp_tx_drops",	VIRTNET_SQ_STAT(xdp_tx_drops) },
 	{ "kicks",		VIRTNET_SQ_STAT(kicks) },
+	{ "tx_timeouts",	VIRTNET_SQ_STAT(tx_timeouts) },
 };
 
 static const struct virtnet_stat_desc virtnet_rq_stats_desc[] = {
@@ -211,6 +213,9 @@ struct virtnet_info {
 	/* Work struct for config space updates */
 	struct work_struct config_work;
 
+	/* Work struct for resetting the virtio-net driver. */
+	struct work_struct reset_work;
+
 	/* Does the affinity hint is set for virtqueues? */
 	bool affinity_hint_set;
 
@@ -1721,7 +1726,7 @@ static void virtnet_stats(struct net_device *dev,
 	int i;
 
 	for (i = 0; i < vi->max_queue_pairs; i++) {
-		u64 tpackets, tbytes, rpackets, rbytes, rdrops;
+		u64 tpackets, tbytes, terrors, rpackets, rbytes, rdrops;
 		struct receive_queue *rq = &vi->rq[i];
 		struct send_queue *sq = &vi->sq[i];
 
@@ -1729,6 +1734,7 @@ static void virtnet_stats(struct net_device *dev,
 			start = u64_stats_fetch_begin_irq(&sq->stats.syncp);
 			tpackets = sq->stats.packets;
 			tbytes   = sq->stats.bytes;
+			terrors  = sq->stats.tx_timeouts;
 		} while (u64_stats_fetch_retry_irq(&sq->stats.syncp, start));
 
 		do {
@@ -1743,6 +1749,7 @@ static void virtnet_stats(struct net_device *dev,
 		tot->rx_bytes   += rbytes;
 		tot->tx_bytes   += tbytes;
 		tot->rx_dropped += rdrops;
+		tot->tx_errors  += terrors;
 	}
 
 	tot->tx_dropped = dev->stats.tx_dropped;
@@ -2578,6 +2585,33 @@ static int virtnet_set_features(struct net_device *dev,
 	return 0;
 }
 
+static void virtnet_tx_timeout(struct net_device *dev)
+{
+	struct virtnet_info *vi = netdev_priv(dev);
+	u32 i;
+
+	netdev_warn(dev, "TX timeout stats:\n");
+	/* find the stopped queue the same way dev_watchdog() does */
+	for (i = 0; i < vi->curr_queue_pairs; i++) {
+		struct send_queue *sq = &vi->sq[i];
+
+		if (!netif_xmit_stopped(netdev_get_tx_queue(dev, i))) {
+			netdev_warn(dev, " Available send queue: %d, sq: %s, vq: %d, name: %s\n",
+				    i, sq->name, sq->vq->index, sq->vq->name);
+			continue;
+		}
+
+		u64_stats_update_begin(&sq->stats.syncp);
+		sq->stats.tx_timeouts++;
+		u64_stats_update_end(&sq->stats.syncp);
+
+		netdev_warn(dev, " Unavailable send queue: %d, sq: %s, vq: %d, name: %s\n",
+			    i, sq->name, sq->vq->index, sq->vq->name);
+	}
+
+	schedule_work(&vi->reset_work);
+}
+
 static const struct net_device_ops virtnet_netdev = {
 	.ndo_open            = virtnet_open,
 	.ndo_stop   	     = virtnet_close,
@@ -2593,6 +2627,7 @@ static const struct net_device_ops virtnet_netdev = {
 	.ndo_features_check	= passthru_features_check,
 	.ndo_get_phys_port_name	= virtnet_get_phys_port_name,
 	.ndo_set_features	= virtnet_set_features,
+	.ndo_tx_timeout		= virtnet_tx_timeout,
 };
 
 static void virtnet_config_changed_work(struct work_struct *work)
@@ -2982,6 +3017,62 @@ static int virtnet_validate(struct virtio_device *vdev)
 	return 0;
 }
 
+static void _remove_vq_common(struct virtnet_info *vi)
+{
+	vi->vdev->config->reset(vi->vdev);
+
+	/* Free unused buffers in both send and recv, if any. */
+	free_unused_bufs(vi);
+
+	_free_receive_bufs(vi);
+
+	free_receive_page_frags(vi);
+
+	virtnet_del_vqs(vi);
+}
+
+static int _virtnet_reset(struct virtnet_info *vi)
+{
+	struct virtio_device *vdev = vi->vdev;
+	int ret;
+
+	virtio_config_disable(vdev);
+	vdev->failed = vdev->config->get_status(vdev) & VIRTIO_CONFIG_S_FAILED;
+
+	virtnet_freeze_down(vdev);
+	_remove_vq_common(vi);
+
+	virtio_add_status(vdev, VIRTIO_CONFIG_S_ACKNOWLEDGE);
+	virtio_add_status(vdev, VIRTIO_CONFIG_S_DRIVER);
+
+	ret = virtio_finalize_features(vdev);
+	if (ret)
+		goto err;
+
+	ret = virtnet_restore_up(vdev);
+	if (ret)
+		goto err;
+
+	ret = _virtnet_set_queues(vi, vi->curr_queue_pairs);
+	if (ret)
+		goto err;
+
+	virtio_add_status(vdev, VIRTIO_CONFIG_S_DRIVER_OK);
+	virtio_config_enable(vdev);
+	return 0;
+err:
+	virtio_add_status(vdev, VIRTIO_CONFIG_S_FAILED);
+	return ret;
+}
+
+static void virtnet_reset(struct work_struct *work)
+{
+	struct virtnet_info *vi =
+		container_of(work, struct virtnet_info, reset_work);
+
+	_virtnet_reset(vi);
+}
+
 static int virtnet_probe(struct virtio_device *vdev)
 {
 	int i, err = -ENOMEM;
@@ -3011,6 +3102,7 @@ static int virtnet_probe(struct virtio_device *vdev)
 	dev->netdev_ops = &virtnet_netdev;
 	dev->features = NETIF_F_HIGHDMA;
 
+	dev->watchdog_timeo = 5 * HZ;
 	dev->ethtool_ops = &virtnet_ethtool_ops;
 	SET_NETDEV_DEV(dev, &vdev->dev);
 
@@ -3068,6 +3160,7 @@ static int virtnet_probe(struct virtio_device *vdev)
 	vdev->priv = vi;
 
 	INIT_WORK(&vi->config_work, virtnet_config_changed_work);
+	INIT_WORK(&vi->reset_work, virtnet_reset);
 
 	/* If we can receive ANY GSO packets, we must allocate large ones. */
 	if (virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_TSO4) ||
-- 
2.17.1

