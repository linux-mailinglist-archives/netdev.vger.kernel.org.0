Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0388F564EFB
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 09:49:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231142AbiGDHtM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 03:49:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230344AbiGDHtM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 03:49:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2D79126FB
        for <netdev@vger.kernel.org>; Mon,  4 Jul 2022 00:49:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656920950;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=yKFpxcOCgFae6qHfwStp+rLvu7RTFplIbCOWu/O/vnE=;
        b=fvQFNASSlhOLz2Fo1btrY6dahs6GSEGkCYlS6o8CkaD5sKmyAQQHdQTTOteBfkYn9i+ot2
        ZxW1WNu8r+tXfdTlA6lsr+St+/iPvO1xPlEXZHY859391hUhMmzvXQ1tgdzUmzqyDKzrmX
        dhy+VqSBCE7+hX5zZuaqMRX2La7ELlM=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-561-9i-xJpUcNqKB4KJ_nAVUmw-1; Mon, 04 Jul 2022 03:49:07 -0400
X-MC-Unique: 9i-xJpUcNqKB4KJ_nAVUmw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8728C1C07828;
        Mon,  4 Jul 2022 07:49:06 +0000 (UTC)
Received: from localhost.localdomain (ovpn-13-251.pek2.redhat.com [10.72.13.251])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0C5B82166B26;
        Mon,  4 Jul 2022 07:49:01 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     mst@redhat.com, jasowang@redhat.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, xuanzhuo@linux.alibaba.com
Subject: [PATCH net V5] virtio-net: fix the race between refill work and close
Date:   Mon,  4 Jul 2022 15:48:59 +0800
Message-Id: <20220704074859.16912-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We try using cancel_delayed_work_sync() to prevent the work from
enabling NAPI. This is insufficient since we don't disable the source
of the refill work scheduling. This means an NAPI poll callback after
cancel_delayed_work_sync() can schedule the refill work then can
re-enable the NAPI that leads to use-after-free [1].

Since the work can enable NAPI, we can't simply disable NAPI before
calling cancel_delayed_work_sync(). So fix this by introducing a
dedicated boolean to control whether or not the work could be
scheduled from NAPI.

[1]
==================================================================
BUG: KASAN: use-after-free in refill_work+0x43/0xd4
Read of size 2 at addr ffff88810562c92e by task kworker/2:1/42

CPU: 2 PID: 42 Comm: kworker/2:1 Not tainted 5.19.0-rc1+ #480
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.16.0-0-gd239552ce722-prebuilt.qemu.org 04/01/2014
Workqueue: events refill_work
Call Trace:
 <TASK>
 dump_stack_lvl+0x34/0x44
 print_report.cold+0xbb/0x6ac
 ? _printk+0xad/0xde
 ? refill_work+0x43/0xd4
 kasan_report+0xa8/0x130
 ? refill_work+0x43/0xd4
 refill_work+0x43/0xd4
 process_one_work+0x43d/0x780
 worker_thread+0x2a0/0x6f0
 ? process_one_work+0x780/0x780
 kthread+0x167/0x1a0
 ? kthread_exit+0x50/0x50
 ret_from_fork+0x22/0x30
 </TASK>
...

Fixes: b2baed69e605c ("virtio_net: set/cancel work on ndo_open/ndo_stop")
Signed-off-by: Jason Wang <jasowang@redhat.com>
---
Changes since V4:
- Tweak the variable name (using delayed_refill)
Changes since V3:
- rebase to -net
Changes since V2:
- use spin_unlock()/lock_bh() in open/stop to synchronize with bh
Changes since V1:
- Tweak the changelog
---
 drivers/net/virtio_net.c | 35 +++++++++++++++++++++++++++++++++--
 1 file changed, 33 insertions(+), 2 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 356cf8dd4164..b9ac4431becb 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -245,6 +245,12 @@ struct virtnet_info {
 	/* Work struct for refilling if we run low on memory. */
 	struct delayed_work refill;
 
+	/* Is delayed refill enabled? */
+	bool delayed_refill_enabled;
+
+	/* The lock to synchronize the access to delayed_refill_enabled */
+	spinlock_t refill_lock;
+
 	/* Work struct for config space updates */
 	struct work_struct config_work;
 
@@ -348,6 +354,20 @@ static struct page *get_a_page(struct receive_queue *rq, gfp_t gfp_mask)
 	return p;
 }
 
+static void enable_delayed_refill(struct virtnet_info *vi)
+{
+	spin_lock_bh(&vi->refill_lock);
+	vi->delayed_refill_enabled = true;
+	spin_unlock_bh(&vi->refill_lock);
+}
+
+static void disable_delayed_refill(struct virtnet_info *vi)
+{
+	spin_lock_bh(&vi->refill_lock);
+	vi->delayed_refill_enabled = false;
+	spin_unlock_bh(&vi->refill_lock);
+}
+
 static void virtqueue_napi_schedule(struct napi_struct *napi,
 				    struct virtqueue *vq)
 {
@@ -1527,8 +1547,12 @@ static int virtnet_receive(struct receive_queue *rq, int budget,
 	}
 
 	if (rq->vq->num_free > min((unsigned int)budget, virtqueue_get_vring_size(rq->vq)) / 2) {
-		if (!try_fill_recv(vi, rq, GFP_ATOMIC))
-			schedule_delayed_work(&vi->refill, 0);
+		if (!try_fill_recv(vi, rq, GFP_ATOMIC)) {
+			spin_lock(&vi->refill_lock);
+			if (vi->delayed_refill_enabled)
+				schedule_delayed_work(&vi->refill, 0);
+			spin_unlock(&vi->refill_lock);
+		}
 	}
 
 	u64_stats_update_begin(&rq->stats.syncp);
@@ -1651,6 +1675,8 @@ static int virtnet_open(struct net_device *dev)
 	struct virtnet_info *vi = netdev_priv(dev);
 	int i, err;
 
+	enable_delayed_refill(vi);
+
 	for (i = 0; i < vi->max_queue_pairs; i++) {
 		if (i < vi->curr_queue_pairs)
 			/* Make sure we have some buffers: if oom use wq. */
@@ -2033,6 +2059,8 @@ static int virtnet_close(struct net_device *dev)
 	struct virtnet_info *vi = netdev_priv(dev);
 	int i;
 
+	/* Make sure NAPI doesn't schedule refill work */
+	disable_delayed_refill(vi);
 	/* Make sure refill_work doesn't re-enable napi! */
 	cancel_delayed_work_sync(&vi->refill);
 
@@ -2792,6 +2820,8 @@ static int virtnet_restore_up(struct virtio_device *vdev)
 
 	virtio_device_ready(vdev);
 
+	enable_delayed_refill(vi);
+
 	if (netif_running(vi->dev)) {
 		err = virtnet_open(vi->dev);
 		if (err)
@@ -3535,6 +3565,7 @@ static int virtnet_probe(struct virtio_device *vdev)
 	vdev->priv = vi;
 
 	INIT_WORK(&vi->config_work, virtnet_config_changed_work);
+	spin_lock_init(&vi->refill_lock);
 
 	/* If we can receive ANY GSO packets, we must allocate large ones. */
 	if (virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_TSO4) ||
-- 
2.25.1

