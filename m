Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 187852C4E4
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 12:56:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726887AbfE1K4q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 06:56:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53250 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726859AbfE1K4p (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 May 2019 06:56:45 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 350F5300502A;
        Tue, 28 May 2019 10:56:45 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-117-13.ams2.redhat.com [10.36.117.13])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1F2B67D59A;
        Tue, 28 May 2019 10:56:42 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Michael S . Tsirkin" <mst@redhat.com>
Subject: [PATCH 3/4] vsock/virtio: fix flush of works during the .remove()
Date:   Tue, 28 May 2019 12:56:22 +0200
Message-Id: <20190528105623.27983-4-sgarzare@redhat.com>
In-Reply-To: <20190528105623.27983-1-sgarzare@redhat.com>
References: <20190528105623.27983-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Tue, 28 May 2019 10:56:45 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We flush all pending works before to call vdev->config->reset(vdev),
but other works can be queued before the vdev->config->del_vqs(vdev),
so we add another flush after it, to avoid use after free.

Suggested-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 net/vmw_vsock/virtio_transport.c | 23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
index e694df10ab61..ad093ce96693 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -660,6 +660,15 @@ static int virtio_vsock_probe(struct virtio_device *vdev)
 	return ret;
 }
 
+static void virtio_vsock_flush_works(struct virtio_vsock *vsock)
+{
+	flush_work(&vsock->loopback_work);
+	flush_work(&vsock->rx_work);
+	flush_work(&vsock->tx_work);
+	flush_work(&vsock->event_work);
+	flush_work(&vsock->send_pkt_work);
+}
+
 static void virtio_vsock_remove(struct virtio_device *vdev)
 {
 	struct virtio_vsock *vsock = vdev->priv;
@@ -668,12 +677,6 @@ static void virtio_vsock_remove(struct virtio_device *vdev)
 	mutex_lock(&the_virtio_vsock_mutex);
 	the_virtio_vsock = NULL;
 
-	flush_work(&vsock->loopback_work);
-	flush_work(&vsock->rx_work);
-	flush_work(&vsock->tx_work);
-	flush_work(&vsock->event_work);
-	flush_work(&vsock->send_pkt_work);
-
 	/* Reset all connected sockets when the device disappear */
 	vsock_for_each_connected_socket(virtio_vsock_reset_sock);
 
@@ -690,6 +693,9 @@ static void virtio_vsock_remove(struct virtio_device *vdev)
 	vsock->event_run = false;
 	mutex_unlock(&vsock->event_lock);
 
+	/* Flush all pending works */
+	virtio_vsock_flush_works(vsock);
+
 	/* Flush all device writes and interrupts, device will not use any
 	 * more buffers.
 	 */
@@ -726,6 +732,11 @@ static void virtio_vsock_remove(struct virtio_device *vdev)
 	/* Delete virtqueues and flush outstanding callbacks if any */
 	vdev->config->del_vqs(vdev);
 
+	/* Other works can be queued before 'config->del_vqs()', so we flush
+	 * all works before to free the vsock object to avoid use after free.
+	 */
+	virtio_vsock_flush_works(vsock);
+
 	kfree(vsock);
 	mutex_unlock(&the_virtio_vsock_mutex);
 }
-- 
2.20.1

