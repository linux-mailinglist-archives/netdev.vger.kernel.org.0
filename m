Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6257260504
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 13:05:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728492AbfGELFI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 07:05:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55570 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726116AbfGELFG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Jul 2019 07:05:06 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1545A30842D1;
        Fri,  5 Jul 2019 11:05:06 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-117-149.ams2.redhat.com [10.36.117.149])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EECB41BC40;
        Fri,  5 Jul 2019 11:05:03 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        linux-kernel@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        virtualization@lists.linux-foundation.org,
        Stefan Hajnoczi <stefanha@redhat.com>
Subject: [PATCH v3 1/3] vsock/virtio: use RCU to avoid use-after-free on the_virtio_vsock
Date:   Fri,  5 Jul 2019 13:04:52 +0200
Message-Id: <20190705110454.95302-2-sgarzare@redhat.com>
In-Reply-To: <20190705110454.95302-1-sgarzare@redhat.com>
References: <20190705110454.95302-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Fri, 05 Jul 2019 11:05:06 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some callbacks used by the upper layers can run while we are in the
.remove(). A potential use-after-free can happen, because we free
the_virtio_vsock without knowing if the callbacks are over or not.

To solve this issue we move the assignment of the_virtio_vsock at the
end of .probe(), when we finished all the initialization, and at the
beginning of .remove(), before to release resources.
For the same reason, we do the same also for the vdev->priv.

We use RCU to be sure that all callbacks that use the_virtio_vsock
ended before freeing it. This is not required for callbacks that
use vdev->priv, because after the vdev->config->del_vqs() we are sure
that they are ended and will no longer be invoked.

We also take the mutex during the .remove() to avoid that .probe() can
run while we are resetting the device.

Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 net/vmw_vsock/virtio_transport.c | 70 +++++++++++++++++++++-----------
 1 file changed, 46 insertions(+), 24 deletions(-)

diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
index 9c287e3e393c..3eaec60aa64f 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -65,19 +65,22 @@ struct virtio_vsock {
 	u32 guest_cid;
 };
 
-static struct virtio_vsock *virtio_vsock_get(void)
-{
-	return the_virtio_vsock;
-}
-
 static u32 virtio_transport_get_local_cid(void)
 {
-	struct virtio_vsock *vsock = virtio_vsock_get();
+	struct virtio_vsock *vsock;
+	u32 ret;
 
-	if (!vsock)
-		return VMADDR_CID_ANY;
+	rcu_read_lock();
+	vsock = rcu_dereference(the_virtio_vsock);
+	if (!vsock) {
+		ret = VMADDR_CID_ANY;
+		goto out_rcu;
+	}
 
-	return vsock->guest_cid;
+	ret = vsock->guest_cid;
+out_rcu:
+	rcu_read_unlock();
+	return ret;
 }
 
 static void virtio_transport_loopback_work(struct work_struct *work)
@@ -197,14 +200,18 @@ virtio_transport_send_pkt(struct virtio_vsock_pkt *pkt)
 	struct virtio_vsock *vsock;
 	int len = pkt->len;
 
-	vsock = virtio_vsock_get();
+	rcu_read_lock();
+	vsock = rcu_dereference(the_virtio_vsock);
 	if (!vsock) {
 		virtio_transport_free_pkt(pkt);
-		return -ENODEV;
+		len = -ENODEV;
+		goto out_rcu;
 	}
 
-	if (le64_to_cpu(pkt->hdr.dst_cid) == vsock->guest_cid)
-		return virtio_transport_send_pkt_loopback(vsock, pkt);
+	if (le64_to_cpu(pkt->hdr.dst_cid) == vsock->guest_cid) {
+		len = virtio_transport_send_pkt_loopback(vsock, pkt);
+		goto out_rcu;
+	}
 
 	if (pkt->reply)
 		atomic_inc(&vsock->queued_replies);
@@ -214,6 +221,9 @@ virtio_transport_send_pkt(struct virtio_vsock_pkt *pkt)
 	spin_unlock_bh(&vsock->send_pkt_list_lock);
 
 	queue_work(virtio_vsock_workqueue, &vsock->send_pkt_work);
+
+out_rcu:
+	rcu_read_unlock();
 	return len;
 }
 
@@ -222,12 +232,14 @@ virtio_transport_cancel_pkt(struct vsock_sock *vsk)
 {
 	struct virtio_vsock *vsock;
 	struct virtio_vsock_pkt *pkt, *n;
-	int cnt = 0;
+	int cnt = 0, ret;
 	LIST_HEAD(freeme);
 
-	vsock = virtio_vsock_get();
+	rcu_read_lock();
+	vsock = rcu_dereference(the_virtio_vsock);
 	if (!vsock) {
-		return -ENODEV;
+		ret = -ENODEV;
+		goto out_rcu;
 	}
 
 	spin_lock_bh(&vsock->send_pkt_list_lock);
@@ -255,7 +267,11 @@ virtio_transport_cancel_pkt(struct vsock_sock *vsk)
 			queue_work(virtio_vsock_workqueue, &vsock->rx_work);
 	}
 
-	return 0;
+	ret = 0;
+
+out_rcu:
+	rcu_read_unlock();
+	return ret;
 }
 
 static void virtio_vsock_rx_fill(struct virtio_vsock *vsock)
@@ -565,7 +581,8 @@ static int virtio_vsock_probe(struct virtio_device *vdev)
 		return ret;
 
 	/* Only one virtio-vsock device per guest is supported */
-	if (the_virtio_vsock) {
+	if (rcu_dereference_protected(the_virtio_vsock,
+				lockdep_is_held(&the_virtio_vsock_mutex))) {
 		ret = -EBUSY;
 		goto out;
 	}
@@ -590,8 +607,6 @@ static int virtio_vsock_probe(struct virtio_device *vdev)
 	vsock->rx_buf_max_nr = 0;
 	atomic_set(&vsock->queued_replies, 0);
 
-	vdev->priv = vsock;
-	the_virtio_vsock = vsock;
 	mutex_init(&vsock->tx_lock);
 	mutex_init(&vsock->rx_lock);
 	mutex_init(&vsock->event_lock);
@@ -613,6 +628,9 @@ static int virtio_vsock_probe(struct virtio_device *vdev)
 	virtio_vsock_event_fill(vsock);
 	mutex_unlock(&vsock->event_lock);
 
+	vdev->priv = vsock;
+	rcu_assign_pointer(the_virtio_vsock, vsock);
+
 	mutex_unlock(&the_virtio_vsock_mutex);
 	return 0;
 
@@ -627,6 +645,12 @@ static void virtio_vsock_remove(struct virtio_device *vdev)
 	struct virtio_vsock *vsock = vdev->priv;
 	struct virtio_vsock_pkt *pkt;
 
+	mutex_lock(&the_virtio_vsock_mutex);
+
+	vdev->priv = NULL;
+	rcu_assign_pointer(the_virtio_vsock, NULL);
+	synchronize_rcu();
+
 	flush_work(&vsock->loopback_work);
 	flush_work(&vsock->rx_work);
 	flush_work(&vsock->tx_work);
@@ -666,12 +690,10 @@ static void virtio_vsock_remove(struct virtio_device *vdev)
 	}
 	spin_unlock_bh(&vsock->loopback_list_lock);
 
-	mutex_lock(&the_virtio_vsock_mutex);
-	the_virtio_vsock = NULL;
-	mutex_unlock(&the_virtio_vsock_mutex);
-
 	vdev->config->del_vqs(vdev);
 
+	mutex_unlock(&the_virtio_vsock_mutex);
+
 	kfree(vsock);
 }
 
-- 
2.20.1

