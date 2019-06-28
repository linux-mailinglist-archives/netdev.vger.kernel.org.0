Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52E1459B9C
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 14:37:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727017AbfF1MhY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 08:37:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42312 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726695AbfF1MhY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Jun 2019 08:37:24 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 687AA30C1AFD;
        Fri, 28 Jun 2019 12:37:18 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-117-102.ams2.redhat.com [10.36.117.102])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1E79E5D9CA;
        Fri, 28 Jun 2019 12:37:13 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     netdev@vger.kernel.org
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jason Wang <jasowang@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/3] vsock/virtio: stop workers during the .remove()
Date:   Fri, 28 Jun 2019 14:36:58 +0200
Message-Id: <20190628123659.139576-3-sgarzare@redhat.com>
In-Reply-To: <20190628123659.139576-1-sgarzare@redhat.com>
References: <20190628123659.139576-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Fri, 28 Jun 2019 12:37:23 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Before to call vdev->config->reset(vdev) we need to be sure that
no one is accessing the device, for this reason, we add new variables
in the struct virtio_vsock to stop the workers during the .remove().

This patch also add few comments before vdev->config->reset(vdev)
and vdev->config->del_vqs(vdev).

Suggested-by: Stefan Hajnoczi <stefanha@redhat.com>
Suggested-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 net/vmw_vsock/virtio_transport.c | 51 +++++++++++++++++++++++++++++++-
 1 file changed, 50 insertions(+), 1 deletion(-)

diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
index 7ad510ec12e0..1b44ec6f3f6c 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -38,6 +38,7 @@ struct virtio_vsock {
 	 * must be accessed with tx_lock held.
 	 */
 	struct mutex tx_lock;
+	bool tx_run;
 
 	struct work_struct send_pkt_work;
 	spinlock_t send_pkt_list_lock;
@@ -53,6 +54,7 @@ struct virtio_vsock {
 	 * must be accessed with rx_lock held.
 	 */
 	struct mutex rx_lock;
+	bool rx_run;
 	int rx_buf_nr;
 	int rx_buf_max_nr;
 
@@ -60,6 +62,7 @@ struct virtio_vsock {
 	 * vqs[VSOCK_VQ_EVENT] must be accessed with event_lock held.
 	 */
 	struct mutex event_lock;
+	bool event_run;
 	struct virtio_vsock_event event_list[8];
 
 	u32 guest_cid;
@@ -94,6 +97,10 @@ static void virtio_transport_loopback_work(struct work_struct *work)
 	spin_unlock_bh(&vsock->loopback_list_lock);
 
 	mutex_lock(&vsock->rx_lock);
+
+	if (!vsock->rx_run)
+		goto out;
+
 	while (!list_empty(&pkts)) {
 		struct virtio_vsock_pkt *pkt;
 
@@ -102,6 +109,7 @@ static void virtio_transport_loopback_work(struct work_struct *work)
 
 		virtio_transport_recv_pkt(pkt);
 	}
+out:
 	mutex_unlock(&vsock->rx_lock);
 }
 
@@ -130,6 +138,9 @@ virtio_transport_send_pkt_work(struct work_struct *work)
 
 	mutex_lock(&vsock->tx_lock);
 
+	if (!vsock->tx_run)
+		goto out;
+
 	vq = vsock->vqs[VSOCK_VQ_TX];
 
 	for (;;) {
@@ -188,6 +199,7 @@ virtio_transport_send_pkt_work(struct work_struct *work)
 	if (added)
 		virtqueue_kick(vq);
 
+out:
 	mutex_unlock(&vsock->tx_lock);
 
 	if (restart_rx)
@@ -323,6 +335,10 @@ static void virtio_transport_tx_work(struct work_struct *work)
 
 	vq = vsock->vqs[VSOCK_VQ_TX];
 	mutex_lock(&vsock->tx_lock);
+
+	if (!vsock->tx_run)
+		goto out;
+
 	do {
 		struct virtio_vsock_pkt *pkt;
 		unsigned int len;
@@ -333,6 +349,8 @@ static void virtio_transport_tx_work(struct work_struct *work)
 			added = true;
 		}
 	} while (!virtqueue_enable_cb(vq));
+
+out:
 	mutex_unlock(&vsock->tx_lock);
 
 	if (added)
@@ -361,6 +379,9 @@ static void virtio_transport_rx_work(struct work_struct *work)
 
 	mutex_lock(&vsock->rx_lock);
 
+	if (!vsock->rx_run)
+		goto out;
+
 	do {
 		virtqueue_disable_cb(vq);
 		for (;;) {
@@ -470,6 +491,9 @@ static void virtio_transport_event_work(struct work_struct *work)
 
 	mutex_lock(&vsock->event_lock);
 
+	if (!vsock->event_run)
+		goto out;
+
 	do {
 		struct virtio_vsock_event *event;
 		unsigned int len;
@@ -484,7 +508,7 @@ static void virtio_transport_event_work(struct work_struct *work)
 	} while (!virtqueue_enable_cb(vq));
 
 	virtqueue_kick(vsock->vqs[VSOCK_VQ_EVENT]);
-
+out:
 	mutex_unlock(&vsock->event_lock);
 }
 
@@ -619,12 +643,18 @@ static int virtio_vsock_probe(struct virtio_device *vdev)
 	INIT_WORK(&vsock->send_pkt_work, virtio_transport_send_pkt_work);
 	INIT_WORK(&vsock->loopback_work, virtio_transport_loopback_work);
 
+	mutex_lock(&vsock->tx_lock);
+	vsock->tx_run = true;
+	mutex_unlock(&vsock->tx_lock);
+
 	mutex_lock(&vsock->rx_lock);
 	virtio_vsock_rx_fill(vsock);
+	vsock->rx_run = true;
 	mutex_unlock(&vsock->rx_lock);
 
 	mutex_lock(&vsock->event_lock);
 	virtio_vsock_event_fill(vsock);
+	vsock->event_run = true;
 	mutex_unlock(&vsock->event_lock);
 
 	vdev->priv = vsock;
@@ -659,6 +689,24 @@ static void virtio_vsock_remove(struct virtio_device *vdev)
 	/* Reset all connected sockets when the device disappear */
 	vsock_for_each_connected_socket(virtio_vsock_reset_sock);
 
+	/* Stop all work handlers to make sure no one is accessing the device,
+	 * so we can safely call vdev->config->reset().
+	 */
+	mutex_lock(&vsock->rx_lock);
+	vsock->rx_run = false;
+	mutex_unlock(&vsock->rx_lock);
+
+	mutex_lock(&vsock->tx_lock);
+	vsock->tx_run = false;
+	mutex_unlock(&vsock->tx_lock);
+
+	mutex_lock(&vsock->event_lock);
+	vsock->event_run = false;
+	mutex_unlock(&vsock->event_lock);
+
+	/* Flush all device writes and interrupts, device will not use any
+	 * more buffers.
+	 */
 	vdev->config->reset(vdev);
 
 	mutex_lock(&vsock->rx_lock);
@@ -689,6 +737,7 @@ static void virtio_vsock_remove(struct virtio_device *vdev)
 	}
 	spin_unlock_bh(&vsock->loopback_list_lock);
 
+	/* Delete virtqueues and flush outstanding callbacks if any */
 	vdev->config->del_vqs(vdev);
 
 	mutex_unlock(&the_virtio_vsock_mutex);
-- 
2.20.1

