Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14B332766DB
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 05:22:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726683AbgIXDV4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 23:21:56 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35215 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726637AbgIXDVz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 23:21:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600917713;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=c1vAH2sOnIecyBuC1bgws2niE0JgFrbZ244nIj8c+DU=;
        b=QfNmrvwJBadRabo8pG733x/M+caGWv6Rz4YK7j+/V5WcSZll9sJP3xp2sva0dbzJ3q2AOj
        L6g29iRyWkeBMUuvIMZQXGuJJsyw4GsQxsABtcdgUw+AX2y5vIy2sHjDwe4OIqqWp9U+uQ
        0xz5cyDe4lcGGxT7RNUBZk2qEsyP4tc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-437-XMWz49fsN5a-IB1C8BEtBQ-1; Wed, 23 Sep 2020 23:21:51 -0400
X-MC-Unique: XMWz49fsN5a-IB1C8BEtBQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 269FE801AF7;
        Thu, 24 Sep 2020 03:21:50 +0000 (UTC)
Received: from jason-ThinkPad-X1-Carbon-6th.redhat.com (ovpn-13-193.pek2.redhat.com [10.72.13.193])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BEC8855768;
        Thu, 24 Sep 2020 03:21:43 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     mst@redhat.com, jasowang@redhat.com
Cc:     lulu@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, rob.miller@broadcom.com,
        lingshan.zhu@intel.com, eperezma@redhat.com, hanand@xilinx.com,
        mhabets@solarflare.com, eli@mellanox.com, amorenoz@redhat.com,
        maxime.coquelin@redhat.com, stefanha@redhat.com,
        sgarzare@redhat.com, Eli Cohen <elic@nvidia.com>
Subject: [RFC PATCH 01/24] vhost-vdpa: fix backend feature ioctls
Date:   Thu, 24 Sep 2020 11:21:02 +0800
Message-Id: <20200924032125.18619-2-jasowang@redhat.com>
In-Reply-To: <20200924032125.18619-1-jasowang@redhat.com>
References: <20200924032125.18619-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 653055b9acd4 ("vhost-vdpa: support get/set backend features")
introduces two malfunction backend features ioctls:

1) the ioctls was blindly added to vring ioctl instead of vdpa device
   ioctl
2) vhost_set_backend_features() was called when dev mutex has already
   been held which will lead a deadlock

This patch fixes the above issues.

Cc: Eli Cohen <elic@nvidia.com>
Reported-by: Zhu Lingshan <lingshan.zhu@intel.com>
Fixes: 653055b9acd4 ("vhost-vdpa: support get/set backend features")
Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vhost/vdpa.c | 30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 3fab94f88894..796fe979f997 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -353,8 +353,6 @@ static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned int cmd,
 	struct vdpa_callback cb;
 	struct vhost_virtqueue *vq;
 	struct vhost_vring_state s;
-	u64 __user *featurep = argp;
-	u64 features;
 	u32 idx;
 	long r;
 
@@ -381,18 +379,6 @@ static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned int cmd,
 
 		vq->last_avail_idx = vq_state.avail_index;
 		break;
-	case VHOST_GET_BACKEND_FEATURES:
-		features = VHOST_VDPA_BACKEND_FEATURES;
-		if (copy_to_user(featurep, &features, sizeof(features)))
-			return -EFAULT;
-		return 0;
-	case VHOST_SET_BACKEND_FEATURES:
-		if (copy_from_user(&features, featurep, sizeof(features)))
-			return -EFAULT;
-		if (features & ~VHOST_VDPA_BACKEND_FEATURES)
-			return -EOPNOTSUPP;
-		vhost_set_backend_features(&v->vdev, features);
-		return 0;
 	}
 
 	r = vhost_vring_ioctl(&v->vdev, cmd, argp);
@@ -440,8 +426,20 @@ static long vhost_vdpa_unlocked_ioctl(struct file *filep,
 	struct vhost_vdpa *v = filep->private_data;
 	struct vhost_dev *d = &v->vdev;
 	void __user *argp = (void __user *)arg;
+	u64 __user *featurep = argp;
+	u64 features;
 	long r;
 
+	if (cmd == VHOST_SET_BACKEND_FEATURES) {
+		r = copy_from_user(&features, featurep, sizeof(features));
+		if (r)
+			return r;
+		if (features & ~VHOST_VDPA_BACKEND_FEATURES)
+			return -EOPNOTSUPP;
+		vhost_set_backend_features(&v->vdev, features);
+		return 0;
+	}
+
 	mutex_lock(&d->mutex);
 
 	switch (cmd) {
@@ -476,6 +474,10 @@ static long vhost_vdpa_unlocked_ioctl(struct file *filep,
 	case VHOST_VDPA_SET_CONFIG_CALL:
 		r = vhost_vdpa_set_config_call(v, argp);
 		break;
+	case VHOST_GET_BACKEND_FEATURES:
+		features = VHOST_VDPA_BACKEND_FEATURES;
+		r = copy_to_user(featurep, &features, sizeof(features));
+		break;
 	default:
 		r = vhost_dev_ioctl(&v->vdev, cmd, argp);
 		if (r == -ENOIOCTLCMD)
-- 
2.20.1

