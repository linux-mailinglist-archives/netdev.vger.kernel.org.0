Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9AF82C4E8
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 12:56:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726969AbfE1K4w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 06:56:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55006 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726912AbfE1K4r (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 May 2019 06:56:47 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 70E1CF74CF;
        Tue, 28 May 2019 10:56:47 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-117-13.ams2.redhat.com [10.36.117.13])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8F19260BE2;
        Tue, 28 May 2019 10:56:45 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Michael S . Tsirkin" <mst@redhat.com>
Subject: [PATCH 4/4] vsock/virtio: free used buffers during the .remove()
Date:   Tue, 28 May 2019 12:56:23 +0200
Message-Id: <20190528105623.27983-5-sgarzare@redhat.com>
In-Reply-To: <20190528105623.27983-1-sgarzare@redhat.com>
References: <20190528105623.27983-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Tue, 28 May 2019 10:56:47 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Before this patch, we only freed unused buffers, but there may
still be used buffers to be freed.

Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 net/vmw_vsock/virtio_transport.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
index ad093ce96693..6a2afb989562 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -669,6 +669,18 @@ static void virtio_vsock_flush_works(struct virtio_vsock *vsock)
 	flush_work(&vsock->send_pkt_work);
 }
 
+static void virtio_vsock_free_buf(struct virtqueue *vq)
+{
+	struct virtio_vsock_pkt *pkt;
+	unsigned int len;
+
+	while ((pkt = virtqueue_detach_unused_buf(vq)))
+		virtio_transport_free_pkt(pkt);
+
+	while ((pkt = virtqueue_get_buf(vq, &len)))
+		virtio_transport_free_pkt(pkt);
+}
+
 static void virtio_vsock_remove(struct virtio_device *vdev)
 {
 	struct virtio_vsock *vsock = vdev->priv;
@@ -702,13 +714,11 @@ static void virtio_vsock_remove(struct virtio_device *vdev)
 	vdev->config->reset(vdev);
 
 	mutex_lock(&vsock->rx_lock);
-	while ((pkt = virtqueue_detach_unused_buf(vsock->vqs[VSOCK_VQ_RX])))
-		virtio_transport_free_pkt(pkt);
+	virtio_vsock_free_buf(vsock->vqs[VSOCK_VQ_RX]);
 	mutex_unlock(&vsock->rx_lock);
 
 	mutex_lock(&vsock->tx_lock);
-	while ((pkt = virtqueue_detach_unused_buf(vsock->vqs[VSOCK_VQ_TX])))
-		virtio_transport_free_pkt(pkt);
+	virtio_vsock_free_buf(vsock->vqs[VSOCK_VQ_TX]);
 	mutex_unlock(&vsock->tx_lock);
 
 	spin_lock_bh(&vsock->send_pkt_list_lock);
-- 
2.20.1

