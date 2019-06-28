Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD94859BA5
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 14:37:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726803AbfF1MhO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 08:37:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54362 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726578AbfF1MhO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Jun 2019 08:37:14 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B96B82F8BF0;
        Fri, 28 Jun 2019 12:37:13 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-117-102.ams2.redhat.com [10.36.117.102])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E2FAF5D9CA;
        Fri, 28 Jun 2019 12:37:10 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     netdev@vger.kernel.org
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jason Wang <jasowang@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/3] vsock/virtio: use RCU to avoid use-after-free on the_virtio_vsock
Date:   Fri, 28 Jun 2019 14:36:57 +0200
Message-Id: <20190628123659.139576-2-sgarzare@redhat.com>
In-Reply-To: <20190628123659.139576-1-sgarzare@redhat.com>
References: <20190628123659.139576-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Fri, 28 Jun 2019 12:37:13 +0000 (UTC)
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
 net/vmw_vsock/virtio_transport.c | 67 +++++++++++++++++++++-----------
 1 file changed, 44 insertions(+), 23 deletions(-)

diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
index 9c287e3e393c..7ad510ec12e0 100644
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
@@ -590,8 +606,6 @@ static int virtio_vsock_probe(struct virtio_device *vdev)
 	vsock->rx_buf_max_nr = 0;
 	atomic_set(&vsock->queued_replies, 0);
 
-	vdev->priv = vsock;
-	the_virtio_vsock = vsock;
 	mutex_init(&vsock->tx_lock);
 	mutex_init(&vsock->rx_lock);
 	mutex_init(&vsock->event_lock);
@@ -613,6 +627,9 @@ static int virtio_vsock_probe(struct virtio_device *vdev)
 	virtio_vsock_event_fill(vsock);
 	mutex_unlock(&vsock->event_lock);
 
+	vdev->priv = vsock;
+	rcu_assign_pointer(the_virtio_vsock, vsock);
+
 	mutex_unlock(&the_virtio_vsock_mutex);
 	return 0;
 
@@ -627,6 +644,12 @@ static void virtio_vsock_remove(struct virtio_device *vdev)
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
@@ -666,12 +689,10 @@ static void virtio_vsock_remove(struct virtio_device *vdev)
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

