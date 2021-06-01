Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30079396F36
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 10:45:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233578AbhFAIrM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 04:47:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53550 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233165AbhFAIrH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 04:47:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622537126;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MPnz+bPdexG/R3nGKtBKfo8Ssf6HrlChuTyrsE87lfM=;
        b=h9lRA7/iM+y1dM8Dfjxeo3UKNuTKN1M2VT9tSMIbLdW8rAD6ex+Ly6fYOJlOzny8SRryWm
        jftt8x7VM/LpDiqdhcunKLubC33FEuoXfaOO3MpwD2OurvdE1qRfZijL5beMFVlxx0osmx
        FmbmLI2/sNWmpOLZ6KEU1rFPknCmsts=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-441-WL4LUiDoPOupO8q48SqqkQ-1; Tue, 01 Jun 2021 04:45:22 -0400
X-MC-Unique: WL4LUiDoPOupO8q48SqqkQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 27BE0104FB9B;
        Tue,  1 Jun 2021 08:45:21 +0000 (UTC)
Received: from localhost.localdomain (ovpn-12-16.pek2.redhat.com [10.72.12.16])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AD90D100763C;
        Tue,  1 Jun 2021 08:45:18 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     mst@redhat.com, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     eli@mellanox.com
Subject: [PATCH 1/4] vdpa: support packed virtqueue for set/get_vq_state()
Date:   Tue,  1 Jun 2021 16:45:00 +0800
Message-Id: <20210601084503.34724-2-jasowang@redhat.com>
In-Reply-To: <20210601084503.34724-1-jasowang@redhat.com>
References: <20210601084503.34724-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch extends the vdpa_vq_state to support packed virtqueue
state which is basically the device/driver ring wrap counters and the
avail and used index. This will be used for the virito-vdpa support
for the packed virtqueue and the future vhost/vhost-vdpa support for
the packed virtqueue.

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vdpa/ifcvf/ifcvf_main.c  |  4 ++--
 drivers/vdpa/vdpa_sim/vdpa_sim.c |  4 ++--
 drivers/vhost/vdpa.c             |  4 ++--
 include/linux/vdpa.h             | 25 +++++++++++++++++++++++--
 4 files changed, 29 insertions(+), 8 deletions(-)

diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
index ab0ab5cf0f6e..5d3891b1ca28 100644
--- a/drivers/vdpa/ifcvf/ifcvf_main.c
+++ b/drivers/vdpa/ifcvf/ifcvf_main.c
@@ -264,7 +264,7 @@ static int ifcvf_vdpa_get_vq_state(struct vdpa_device *vdpa_dev, u16 qid,
 {
 	struct ifcvf_hw *vf = vdpa_to_vf(vdpa_dev);
 
-	state->avail_index = ifcvf_get_vq_state(vf, qid);
+	state->split.avail_index = ifcvf_get_vq_state(vf, qid);
 	return 0;
 }
 
@@ -273,7 +273,7 @@ static int ifcvf_vdpa_set_vq_state(struct vdpa_device *vdpa_dev, u16 qid,
 {
 	struct ifcvf_hw *vf = vdpa_to_vf(vdpa_dev);
 
-	return ifcvf_set_vq_state(vf, qid, state->avail_index);
+	return ifcvf_set_vq_state(vf, qid, state->split.avail_index);
 }
 
 static void ifcvf_vdpa_set_vq_cb(struct vdpa_device *vdpa_dev, u16 qid,
diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vdpa_sim.c
index 98f793bc9376..14e024de5cbf 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
@@ -374,7 +374,7 @@ static int vdpasim_set_vq_state(struct vdpa_device *vdpa, u16 idx,
 	struct vringh *vrh = &vq->vring;
 
 	spin_lock(&vdpasim->lock);
-	vrh->last_avail_idx = state->avail_index;
+	vrh->last_avail_idx = state->split.avail_index;
 	spin_unlock(&vdpasim->lock);
 
 	return 0;
@@ -387,7 +387,7 @@ static int vdpasim_get_vq_state(struct vdpa_device *vdpa, u16 idx,
 	struct vdpasim_virtqueue *vq = &vdpasim->vqs[idx];
 	struct vringh *vrh = &vq->vring;
 
-	state->avail_index = vrh->last_avail_idx;
+	state->split.avail_index = vrh->last_avail_idx;
 	return 0;
 }
 
diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index fb41db3da611..210ab35a7ebf 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -383,7 +383,7 @@ static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned int cmd,
 		if (r)
 			return r;
 
-		vq->last_avail_idx = vq_state.avail_index;
+		vq->last_avail_idx = vq_state.split.avail_index;
 		break;
 	}
 
@@ -401,7 +401,7 @@ static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned int cmd,
 		break;
 
 	case VHOST_SET_VRING_BASE:
-		vq_state.avail_index = vq->last_avail_idx;
+		vq_state.split.avail_index = vq->last_avail_idx;
 		if (ops->set_vq_state(vdpa, idx, &vq_state))
 			r = -EINVAL;
 		break;
diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
index f311d227aa1b..3357ac98878d 100644
--- a/include/linux/vdpa.h
+++ b/include/linux/vdpa.h
@@ -28,13 +28,34 @@ struct vdpa_notification_area {
 };
 
 /**
- * struct vdpa_vq_state - vDPA vq_state definition
+ * struct vdpa_vq_state_split - vDPA split virtqueue state
  * @avail_index: available index
  */
-struct vdpa_vq_state {
+struct vdpa_vq_state_split {
 	u16	avail_index;
 };
 
+/**
+ * struct vdpa_vq_state_packed - vDPA packed virtqueue state
+ * @last_avail_counter: last driver ring wrap counter observed by device
+ * @last_avail_idx: device available index
+ * @last_used_counter: device ring wrap counter
+ * @last_used_idx: used index
+ */
+struct vdpa_vq_state_packed {
+        u16	last_avail_counter:1;
+        u16	last_avail_idx:15;
+        u16	last_used_counter:1;
+        u16	last_used_idx:15;
+};
+
+struct vdpa_vq_state {
+     union {
+          struct vdpa_vq_state_split split;
+          struct vdpa_vq_state_packed packed;
+     };
+};
+
 struct vdpa_mgmt_dev;
 
 /**
-- 
2.25.1

