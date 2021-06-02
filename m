Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D684397E8E
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 04:11:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230426AbhFBCM4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 22:12:56 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31128 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230372AbhFBCMu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 22:12:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622599868;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0N48jdl0LC6EEeO/MPQo8KIfakfiafpunndtsq1f0hA=;
        b=Pz7bb/k2d2V2NMvug7CvJq6Suw3ck9dLyfbfBHc8vnQxj9aLUJgFD7BstLxDYFkR0Njk9t
        q9baUc8DxTQ2FClBzGUcMIa+mI1LA11woT2GRM74O6k14oDWT3gft1bzExtF2rIpkD0yOm
        ed5zIkvmBCOkSyo9vMxVTDEF1vvZZ5E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-245-G_1Jy6gHMTWjKdguAy75MA-1; Tue, 01 Jun 2021 22:11:06 -0400
X-MC-Unique: G_1Jy6gHMTWjKdguAy75MA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 406F7501E0;
        Wed,  2 Jun 2021 02:11:05 +0000 (UTC)
Received: from localhost.localdomain (ovpn-12-99.pek2.redhat.com [10.72.12.99])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8BCD55D6CF;
        Wed,  2 Jun 2021 02:11:02 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     mst@redhat.com, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     eli@mellanox.com, Eli Cohen <elic@nvidia.com>
Subject: [PATCH V2 4/4] virtio/vdpa: clear the virtqueue state during probe
Date:   Wed,  2 Jun 2021 10:10:43 +0800
Message-Id: <20210602021043.39201-5-jasowang@redhat.com>
In-Reply-To: <20210602021043.39201-1-jasowang@redhat.com>
References: <20210602021043.39201-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eli Cohen <elic@nvidia.com>

Clear the available index as part of the initialization process to
clear and values that might be left from previous usage of the device.
For example, if the device was previously used by vhost_vdpa and now
probed by vhost_vdpa, you want to start with indices.

Fixes: c043b4a8cf3b ("virtio: introduce a vDPA based transport")
Signed-off-by: Eli Cohen <elic@nvidia.com>
Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/virtio/virtio_vdpa.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/virtio/virtio_vdpa.c b/drivers/virtio/virtio_vdpa.c
index e28acf482e0c..e1a141135992 100644
--- a/drivers/virtio/virtio_vdpa.c
+++ b/drivers/virtio/virtio_vdpa.c
@@ -142,6 +142,8 @@ virtio_vdpa_setup_vq(struct virtio_device *vdev, unsigned int index,
 	struct vdpa_callback cb;
 	struct virtqueue *vq;
 	u64 desc_addr, driver_addr, device_addr;
+	/* Assume split virtqueue, switch to packed if necessary */
+	struct vdpa_vq_state state = {0};
 	unsigned long flags;
 	u32 align, num;
 	int err;
@@ -191,6 +193,19 @@ virtio_vdpa_setup_vq(struct virtio_device *vdev, unsigned int index,
 		goto err_vq;
 	}
 
+	/* reset virtqueue state index */
+	if (virtio_has_feature(vdev, VIRTIO_F_RING_PACKED)) {
+		struct vdpa_vq_state_packed *s = &state.packed;
+
+		s->last_avail_counter = 1;
+		s->last_avail_idx = 0;
+		s->last_used_counter = 1;
+		s->last_used_idx = 0;
+	}
+	err = ops->set_vq_state(vdpa, index, &state);
+	if (err)
+		goto err_vq;
+
 	ops->set_vq_ready(vdpa, index, 1);
 
 	vq->priv = info;
-- 
2.25.1

