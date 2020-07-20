Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54329225A5F
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 10:51:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728044AbgGTIvB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 04:51:01 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:50620 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728024AbgGTIu6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 04:50:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595235057;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Y9alvxXRA5HGHZ+mBaUFBL6krSh1l8I0iweYECqaRAI=;
        b=JwbAu9PrIH9ldzdzBukxFqWWXhSu8kAPolV4efZUzbHckIjm1E5vC0SH+UzR4y/7QzTMGu
        WU292x1FRwC4JhAJALbGhAXZi8nsqHuztetZ6mBaLAy4cMb0roRYgGG8SGulDRY1B1Bw0p
        XWA2eI54S6DuwUsfzlQ2Tn/KjJYVET8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-159-OjPYk_K7ONe759fJWsHSAw-1; Mon, 20 Jul 2020 04:50:53 -0400
X-MC-Unique: OjPYk_K7ONe759fJWsHSAw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 103071932480;
        Mon, 20 Jul 2020 08:50:52 +0000 (UTC)
Received: from jason-ThinkPad-X1-Carbon-6th.redhat.com (ovpn-12-53.pek2.redhat.com [10.72.12.53])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E95181001B07;
        Mon, 20 Jul 2020 08:50:45 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     mst@redhat.com, jasowang@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     eli@mellanox.com, lulu@redhat.com
Subject: [PATCH] vhost: vdpa: remove per device feature whitelist
Date:   Mon, 20 Jul 2020 16:50:43 +0800
Message-Id: <20200720085043.16485-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We used to have a per device feature whitelist to filter out the
unsupported virtio features. But this seems unnecessary since:

- the main idea behind feature whitelist is to block control vq
  feature until we finalize the control virtqueue API. But the current
  vhost-vDPA uAPI is sufficient to support control virtqueue. For
  device that has hardware control virtqueue, the vDPA device driver
  can just setup the hardware virtqueue and let userspace to use
  hardware virtqueue directly. For device that doesn't have a control
  virtqueue, the vDPA device driver need to use e.g vringh to emulate
  a software control virtqueue.
- we don't do it in virtio-vDPA driver

So remove this limitation.

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vhost/vdpa.c | 37 -------------------------------------
 1 file changed, 37 deletions(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 77a0c9fb6cc3..f7f6ddd681ce 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -26,35 +26,6 @@
 
 #include "vhost.h"
 
-enum {
-	VHOST_VDPA_FEATURES =
-		(1ULL << VIRTIO_F_NOTIFY_ON_EMPTY) |
-		(1ULL << VIRTIO_F_ANY_LAYOUT) |
-		(1ULL << VIRTIO_F_VERSION_1) |
-		(1ULL << VIRTIO_F_IOMMU_PLATFORM) |
-		(1ULL << VIRTIO_F_RING_PACKED) |
-		(1ULL << VIRTIO_F_ORDER_PLATFORM) |
-		(1ULL << VIRTIO_RING_F_INDIRECT_DESC) |
-		(1ULL << VIRTIO_RING_F_EVENT_IDX),
-
-	VHOST_VDPA_NET_FEATURES = VHOST_VDPA_FEATURES |
-		(1ULL << VIRTIO_NET_F_CSUM) |
-		(1ULL << VIRTIO_NET_F_GUEST_CSUM) |
-		(1ULL << VIRTIO_NET_F_MTU) |
-		(1ULL << VIRTIO_NET_F_MAC) |
-		(1ULL << VIRTIO_NET_F_GUEST_TSO4) |
-		(1ULL << VIRTIO_NET_F_GUEST_TSO6) |
-		(1ULL << VIRTIO_NET_F_GUEST_ECN) |
-		(1ULL << VIRTIO_NET_F_GUEST_UFO) |
-		(1ULL << VIRTIO_NET_F_HOST_TSO4) |
-		(1ULL << VIRTIO_NET_F_HOST_TSO6) |
-		(1ULL << VIRTIO_NET_F_HOST_ECN) |
-		(1ULL << VIRTIO_NET_F_HOST_UFO) |
-		(1ULL << VIRTIO_NET_F_MRG_RXBUF) |
-		(1ULL << VIRTIO_NET_F_STATUS) |
-		(1ULL << VIRTIO_NET_F_SPEED_DUPLEX),
-};
-
 /* Currently, only network backend w/o multiqueue is supported. */
 #define VHOST_VDPA_VQ_MAX	2
 
@@ -79,10 +50,6 @@ static DEFINE_IDA(vhost_vdpa_ida);
 
 static dev_t vhost_vdpa_major;
 
-static const u64 vhost_vdpa_features[] = {
-	[VIRTIO_ID_NET] = VHOST_VDPA_NET_FEATURES,
-};
-
 static void handle_vq_kick(struct vhost_work *work)
 {
 	struct vhost_virtqueue *vq = container_of(work, struct vhost_virtqueue,
@@ -255,7 +222,6 @@ static long vhost_vdpa_get_features(struct vhost_vdpa *v, u64 __user *featurep)
 	u64 features;
 
 	features = ops->get_features(vdpa);
-	features &= vhost_vdpa_features[v->virtio_id];
 
 	if (copy_to_user(featurep, &features, sizeof(features)))
 		return -EFAULT;
@@ -279,9 +245,6 @@ static long vhost_vdpa_set_features(struct vhost_vdpa *v, u64 __user *featurep)
 	if (copy_from_user(&features, featurep, sizeof(features)))
 		return -EFAULT;
 
-	if (features & ~vhost_vdpa_features[v->virtio_id])
-		return -EINVAL;
-
 	if (ops->set_features(vdpa, features))
 		return -EINVAL;
 
-- 
2.20.1

