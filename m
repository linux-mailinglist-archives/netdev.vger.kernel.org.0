Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1E4C10A50F
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 21:06:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726975AbfKZUGo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 15:06:44 -0500
Received: from mail-qk1-f196.google.com ([209.85.222.196]:34662 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726689AbfKZUGn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 15:06:43 -0500
Received: by mail-qk1-f196.google.com with SMTP id d202so8987716qkb.1
        for <netdev@vger.kernel.org>; Tue, 26 Nov 2019 12:06:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=yErNBZJ3BMj48GlZDTcCBW6uH6ys/UG+iWlxKIlw9U4=;
        b=WrO/Rc3F5J0oB2aJ7nqMWSUpuFCrO89z9xyfnb/QX97aNBEePtLcXk1oH1j6GXQKIe
         8H6CgIpvAsDZv4da0n+RHyxsze5sL9xxVVKuJ+2q0ZgJFfYZRd//6xNf66kmFdRUVGS8
         4NnOm2GhlGPvRNeF3cPfH1KlDUCC/ZeS/z2qVnMUSvGDKlh+Wl+0R/+RtAT5tl/q1fw3
         jqFyLJSzCt37lZSCQsr0CmmfCvTAPZ38TreWC6UCi1Ve3V8wCVWK6rAseTR2H0Z/FaTv
         9ih+nQw+T1aG88FLA1I0cPMs1Dq3CoJh+wf2vr0HuHO+3+Jsl9nSm7bBri/vqb5ftP4x
         EBxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=yErNBZJ3BMj48GlZDTcCBW6uH6ys/UG+iWlxKIlw9U4=;
        b=PBL3Op6ScY4VOd8n5mMFvGAbPEai7ao/XFsSJyAVkn8LTG+rcAtBrdV4oz90EoWDKK
         XAxUUK2htGhsJv7DxYnbxdsjjD9X0iypYwI5xz3g2hHR8W13JH/KBdw1+LYk8/ljAbpJ
         EBcv+2XDeyuDbIPi2o51qhYl7vGv/XxenOhiIS2gv8J/o+hx4c1pHyDc14Ryb0Z+lCGT
         juSaMahVnD3NaJZetfVBDSels4YQwi3ppCCslb5W3KPdBPe/cLvIa3qZGuP4ZEmnDYN9
         COH+cscYHKSUXXEy14MUIEdIuM9G0hGSZ+j3BXeMwrrWhhijrmwhsJKLzyWRR0dQvcQ7
         zeBw==
X-Gm-Message-State: APjAAAV9U47aQ6FqpawkV2yHwmulak9RtE3HIWId/qeOEnTCgrNpy6aC
        XwoqisX0wtzbarfxFkazoa40tVP9
X-Google-Smtp-Source: APXvYqx0WUbDMEVBS3kFTgQMyY1Vr9muPXEsTrMq73V9zvB4INdECuBDCqV8z5PKxRKrXYmUJOrcYQ==
X-Received: by 2002:ae9:e704:: with SMTP id m4mr176611qka.153.1574798802166;
        Tue, 26 Nov 2019 12:06:42 -0800 (PST)
Received: from ubuntu.default ([32.104.18.202])
        by smtp.gmail.com with ESMTPSA id d13sm6373562qta.67.2019.11.26.12.06.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Nov 2019 12:06:41 -0800 (PST)
From:   Julio Faracco <jcfaracco@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, mst@redhat.com, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org, dnmendes76@gmail.com
Subject: [net-next V3 2/2] drivers: net: virtio_net: Implement a dev_watchdog handler
Date:   Tue, 26 Nov 2019 17:06:28 -0300
Message-Id: <20191126200628.22251-3-jcfaracco@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191126200628.22251-1-jcfaracco@gmail.com>
References: <20191126200628.22251-1-jcfaracco@gmail.com>
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
reset all queues, including RX (because we don't have control of this).

Signed-off-by: Julio Faracco <jcfaracco@gmail.com>
Signed-off-by: Daiane Mendes <dnmendes76@gmail.com>
Cc: Jason Wang <jasowang@redhat.com>
---
 drivers/net/virtio_net.c | 83 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 82 insertions(+), 1 deletion(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 4d7d5434cc5d..fbe1dfde3a4b 100644
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
+	{ "tx_timeouts",        VIRTNET_SQ_STAT(tx_timeouts) },
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
@@ -2578,6 +2585,21 @@ static int virtnet_set_features(struct net_device *dev,
 	return 0;
 }
 
+static void virtnet_tx_timeout(struct net_device *dev, unsigned int txqueue)
+{
+	struct virtnet_info *vi = netdev_priv(dev);
+	struct send_queue *sq = &vi->sq[txqueue];
+
+	netdev_warn(dev, "TX timeout on queue: %d, sq: %s, vq: %d, name: %s\n",
+		    txqueue, sq->name, sq->vq->index, sq->vq->name);
+
+	u64_stats_update_begin(&sq->stats.syncp);
+	sq->stats.tx_timeouts++;
+	u64_stats_update_end(&sq->stats.syncp);
+
+	schedule_work(&vi->reset_work);
+}
+
 static const struct net_device_ops virtnet_netdev = {
 	.ndo_open            = virtnet_open,
 	.ndo_stop   	     = virtnet_close,
@@ -2593,6 +2615,7 @@ static const struct net_device_ops virtnet_netdev = {
 	.ndo_features_check	= passthru_features_check,
 	.ndo_get_phys_port_name	= virtnet_get_phys_port_name,
 	.ndo_set_features	= virtnet_set_features,
+	.ndo_tx_timeout         = virtnet_tx_timeout,
 };
 
 static void virtnet_config_changed_work(struct work_struct *work)
@@ -2982,6 +3005,62 @@ static int virtnet_validate(struct virtio_device *vdev)
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
@@ -3011,6 +3090,7 @@ static int virtnet_probe(struct virtio_device *vdev)
 	dev->netdev_ops = &virtnet_netdev;
 	dev->features = NETIF_F_HIGHDMA;
 
+	dev->watchdog_timeo = 5 * HZ;
 	dev->ethtool_ops = &virtnet_ethtool_ops;
 	SET_NETDEV_DEV(dev, &vdev->dev);
 
@@ -3068,6 +3148,7 @@ static int virtnet_probe(struct virtio_device *vdev)
 	vdev->priv = vi;
 
 	INIT_WORK(&vi->config_work, virtnet_config_changed_work);
+	INIT_WORK(&vi->reset_work, virtnet_reset);
 
 	/* If we can receive ANY GSO packets, we must allocate large ones. */
 	if (virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_TSO4) ||
-- 
2.17.1

