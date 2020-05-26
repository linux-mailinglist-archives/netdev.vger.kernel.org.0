Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D5131C0D79
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 06:39:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728237AbgEAEi5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 00:38:57 -0400
Received: from foss.arm.com ([217.140.110.172]:36242 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726153AbgEAEi4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 May 2020 00:38:56 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CB9871FB;
        Thu, 30 Apr 2020 21:38:55 -0700 (PDT)
Received: from localhost.localdomain (entos-thunderx2-02.shanghai.arm.com [10.169.138.57])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 29EC83F73D;
        Thu, 30 Apr 2020 21:38:52 -0700 (PDT)
From:   Jia He <justin.he@arm.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kaly Xin <Kaly.Xin@arm.com>,
        Jia He <justin.he@arm.com>
Subject: [PATCH v2] vhost: vsock: kick send_pkt worker once device is started
Date:   Fri,  1 May 2020 12:38:40 +0800
Message-Id: <20200501043840.186557-1-justin.he@arm.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ning Bo reported an abnormal 2-second gap when booting Kata container [1].
The unconditional timeout was caused by VSOCK_DEFAULT_CONNECT_TIMEOUT of
connecting from the client side. The vhost vsock client tries to connect
an initializing virtio vsock server.

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
connect() again          vq->private_data!=NULL         recv connecting pkt

Details:
1. Host userspace sends a connect pkt, at that time, guest vsock is under
   initializing, hence the vhost_vsock_start has not been called. So
   vq->private_data==NULL, and the pkt is not been queued to send to guest
2. Then it sleeps for 2s
3. After guest vsock finishes initializing, vq->private_data is set
4. When host userspace wakes up after 2s, send connecting pkt again,
   everything is fine.

As suggested by Stefano Garzarella, this fixes it by additional kicking the
send_pkt worker in vhost_vsock_start once the virtio device is started. This
makes the pending pkt sent again.

After this patch, kata-runtime (with vsock enabled) boot time is reduced
from 3s to 1s on a ThunderX2 arm64 server.

[1] https://github.com/kata-containers/runtime/issues/1917

Reported-by: Ning Bo <n.b@live.com>
Suggested-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Jia He <justin.he@arm.com>
---
v2: new solution suggested by Stefano Garzarella

 drivers/vhost/vsock.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index e36aaf9ba7bd..0716a9cdffee 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -543,6 +543,11 @@ static int vhost_vsock_start(struct vhost_vsock *vsock)
 		mutex_unlock(&vq->mutex);
 	}
 
+	/* Some packets may have been queued before the device was started,
+	 * let's kick the send worker to send them.
+	 */
+	vhost_work_queue(&vsock->dev, &vsock->send_pkt_work);
+
 	mutex_unlock(&vsock->dev.mutex);
 	return 0;
 
-- 
2.17.1

