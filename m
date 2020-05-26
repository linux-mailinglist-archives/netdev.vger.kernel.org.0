Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E7081BEE24
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 04:13:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726792AbgD3CN0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 22:13:26 -0400
Received: from foss.arm.com ([217.140.110.172]:47702 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726180AbgD3CN0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Apr 2020 22:13:26 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C31E61063;
        Wed, 29 Apr 2020 19:13:25 -0700 (PDT)
Received: from localhost.localdomain (entos-thunderx2-02.shanghai.arm.com [10.169.138.57])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 2019D3F68F;
        Wed, 29 Apr 2020 19:13:22 -0700 (PDT)
From:   Jia He <justin.he@arm.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kaly.Xin@arm.com, Jia He <justin.he@arm.com>
Subject: [PATCH] vhost: vsock: don't send pkt when vq is not started
Date:   Thu, 30 Apr 2020 10:13:14 +0800
Message-Id: <20200430021314.6425-1-justin.he@arm.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ning Bo reported an abnormal 2-second gap when booting Kata container [1].
The unconditional timeout is caused by VSOCK_DEFAULT_CONNECT_TIMEOUT of
connect at client side. The vhost vsock client tries to connect an
initlizing virtio vsock server.

The abnormal flow looks like:
host-userspace           vhost vsock                       guest vsock
==============           ===========                       ============
connect()     -------->  vhost_transport_send_pkt_work()   initializing
   |                     vq->private_data==NULL
   |                     will not be queued
   V
schedule_timeout(2s)
                         vhost_vsock_start()  <---------   device ready
                         set vq->private_data

wait for 2s and failed

connect() again          vq->private_data!=NULL          recv connecting pkt

1. host userspace sends a connect pkt, at that time, guest vsock is under
initializing, hence the vhost_vsock_start has not been called. So
vq->private_data==NULL, and the pkt is not been queued to send to guest.
2. then it sleeps for 2s
3. after guest vsock finishes initializing, vq->private_data is set.
4. When host userspace wakes up after 2s, send connecting pkt again,
everything is fine.

This fixes it by checking vq->private_data in vhost_transport_send_pkt,
and return at once if !vq->private_data. This makes user connect()
be returned with ECONNREFUSED.

After this patch, kata-runtime (with vsock enabled) boottime reduces from
3s to 1s on ThunderX2 arm64 server.

[1] https://github.com/kata-containers/runtime/issues/1917

Reported-by: Ning Bo <n.b@live.com>
Signed-off-by: Jia He <justin.he@arm.com>
---
 drivers/vhost/vsock.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index e36aaf9ba7bd..67474334dd88 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -241,6 +241,7 @@ vhost_transport_send_pkt(struct virtio_vsock_pkt *pkt)
 {
 	struct vhost_vsock *vsock;
 	int len = pkt->len;
+	struct vhost_virtqueue *vq;
 
 	rcu_read_lock();
 
@@ -252,6 +253,13 @@ vhost_transport_send_pkt(struct virtio_vsock_pkt *pkt)
 		return -ENODEV;
 	}
 
+	vq = &vsock->vqs[VSOCK_VQ_RX];
+	if (!vq->private_data) {
+		rcu_read_unlock();
+		virtio_transport_free_pkt(pkt);
+		return -ECONNREFUSED;
+	}
+
 	if (pkt->reply)
 		atomic_inc(&vsock->queued_replies);
 
-- 
2.17.1

