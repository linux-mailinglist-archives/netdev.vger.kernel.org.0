Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5868959BA0
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 14:37:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727077AbfF1Mha (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 08:37:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45224 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727023AbfF1MhZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Jun 2019 08:37:25 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C5146C059B9F;
        Fri, 28 Jun 2019 12:37:24 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-117-102.ams2.redhat.com [10.36.117.102])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CC67C5D98E;
        Fri, 28 Jun 2019 12:37:18 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     netdev@vger.kernel.org
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jason Wang <jasowang@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/3] vsock/virtio: fix flush of works during the .remove()
Date:   Fri, 28 Jun 2019 14:36:59 +0200
Message-Id: <20190628123659.139576-4-sgarzare@redhat.com>
In-Reply-To: <20190628123659.139576-1-sgarzare@redhat.com>
References: <20190628123659.139576-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Fri, 28 Jun 2019 12:37:24 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch moves the flush of works after vdev->config->del_vqs(vdev),
because we need to be sure that no workers run before to free the
'vsock' object.

Since we stopped the workers using the [tx|rx|event]_run flags,
we are sure no one is accessing the device while we are calling
vdev->config->reset(vdev), so we can safely move the workers' flush.

Before the vdev->config->del_vqs(vdev), workers can be scheduled
by VQ callbacks, so we must flush them after del_vqs(), to avoid
use-after-free of 'vsock' object.

Suggested-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 net/vmw_vsock/virtio_transport.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
index 1b44ec6f3f6c..96dafa978268 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -680,12 +680,6 @@ static void virtio_vsock_remove(struct virtio_device *vdev)
 	rcu_assign_pointer(the_virtio_vsock, NULL);
 	synchronize_rcu();
 
-	flush_work(&vsock->loopback_work);
-	flush_work(&vsock->rx_work);
-	flush_work(&vsock->tx_work);
-	flush_work(&vsock->event_work);
-	flush_work(&vsock->send_pkt_work);
-
 	/* Reset all connected sockets when the device disappear */
 	vsock_for_each_connected_socket(virtio_vsock_reset_sock);
 
@@ -740,6 +734,15 @@ static void virtio_vsock_remove(struct virtio_device *vdev)
 	/* Delete virtqueues and flush outstanding callbacks if any */
 	vdev->config->del_vqs(vdev);
 
+	/* Other works can be queued before 'config->del_vqs()', so we flush
+	 * all works before to free the vsock object to avoid use after free.
+	 */
+	flush_work(&vsock->loopback_work);
+	flush_work(&vsock->rx_work);
+	flush_work(&vsock->tx_work);
+	flush_work(&vsock->event_work);
+	flush_work(&vsock->send_pkt_work);
+
 	mutex_unlock(&the_virtio_vsock_mutex);
 
 	kfree(vsock);
-- 
2.20.1

