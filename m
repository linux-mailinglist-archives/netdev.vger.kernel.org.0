Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC1BB2C4E1
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 12:56:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726799AbfE1K4j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 06:56:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60092 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726282AbfE1K4j (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 May 2019 06:56:39 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E2B8B3079B8F;
        Tue, 28 May 2019 10:56:38 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-117-13.ams2.redhat.com [10.36.117.13])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2E37560BE2;
        Tue, 28 May 2019 10:56:36 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Michael S . Tsirkin" <mst@redhat.com>
Subject: [PATCH 1/4] vsock/virtio: fix locking around 'the_virtio_vsock'
Date:   Tue, 28 May 2019 12:56:20 +0200
Message-Id: <20190528105623.27983-2-sgarzare@redhat.com>
In-Reply-To: <20190528105623.27983-1-sgarzare@redhat.com>
References: <20190528105623.27983-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Tue, 28 May 2019 10:56:39 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch protects the reading of 'the_virtio_vsock' taking the
mutex used when it is set.
We also move the 'the_virtio_vsock' assignment at the end of the
.probe(), when we finished all the initialization, and at the
beginning of .remove(), before to release resources, taking the
lock until the end of the function.

Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 net/vmw_vsock/virtio_transport.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
index 96ab344f17bb..d3ba7747aa73 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -68,7 +68,13 @@ struct virtio_vsock {
 
 static struct virtio_vsock *virtio_vsock_get(void)
 {
-	return the_virtio_vsock;
+	struct virtio_vsock *vsock;
+
+	mutex_lock(&the_virtio_vsock_mutex);
+	vsock = the_virtio_vsock;
+	mutex_unlock(&the_virtio_vsock_mutex);
+
+	return vsock;
 }
 
 static u32 virtio_transport_get_local_cid(void)
@@ -592,7 +598,6 @@ static int virtio_vsock_probe(struct virtio_device *vdev)
 	atomic_set(&vsock->queued_replies, 0);
 
 	vdev->priv = vsock;
-	the_virtio_vsock = vsock;
 	mutex_init(&vsock->tx_lock);
 	mutex_init(&vsock->rx_lock);
 	mutex_init(&vsock->event_lock);
@@ -614,6 +619,8 @@ static int virtio_vsock_probe(struct virtio_device *vdev)
 	virtio_vsock_event_fill(vsock);
 	mutex_unlock(&vsock->event_lock);
 
+	the_virtio_vsock = vsock;
+
 	mutex_unlock(&the_virtio_vsock_mutex);
 	return 0;
 
@@ -628,6 +635,9 @@ static void virtio_vsock_remove(struct virtio_device *vdev)
 	struct virtio_vsock *vsock = vdev->priv;
 	struct virtio_vsock_pkt *pkt;
 
+	mutex_lock(&the_virtio_vsock_mutex);
+	the_virtio_vsock = NULL;
+
 	flush_work(&vsock->loopback_work);
 	flush_work(&vsock->rx_work);
 	flush_work(&vsock->tx_work);
@@ -667,13 +677,10 @@ static void virtio_vsock_remove(struct virtio_device *vdev)
 	}
 	spin_unlock_bh(&vsock->loopback_list_lock);
 
-	mutex_lock(&the_virtio_vsock_mutex);
-	the_virtio_vsock = NULL;
-	mutex_unlock(&the_virtio_vsock_mutex);
-
 	vdev->config->del_vqs(vdev);
 
 	kfree(vsock);
+	mutex_unlock(&the_virtio_vsock_mutex);
 }
 
 static struct virtio_device_id id_table[] = {
-- 
2.20.1

