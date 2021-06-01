Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0168A396F3D
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 10:45:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233605AbhFAIrV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 04:47:21 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45717 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233595AbhFAIrO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 04:47:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622537132;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WrB6mvofF/eyGV52SKIt7JTVB1esFhxct19/WhmLXiU=;
        b=Xug6iZTJ4XlsKhRE8R42GN1EmB8O+sY1BlU/H064t/08WWhFm0hTlLjiWx1rd003duhGW1
        IFs6J60zl8AqAilkGP/NFFfXza15n41iwdTuNw+XQf7I/XqqhuhPEOA7hidXmtIOIZ6NWd
        t9FkM03bGenMEvC0ih+7Uum6Oq5y5OQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-325-p9zeVaMKOt2wE7gdk0fP-w-1; Tue, 01 Jun 2021 04:45:29 -0400
X-MC-Unique: p9zeVaMKOt2wE7gdk0fP-w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 29C14802E80;
        Tue,  1 Jun 2021 08:45:28 +0000 (UTC)
Received: from localhost.localdomain (ovpn-12-16.pek2.redhat.com [10.72.12.16])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AEBAC1037F21;
        Tue,  1 Jun 2021 08:45:25 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     mst@redhat.com, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     eli@mellanox.com
Subject: [PATCH 3/4] vp_vdpa: allow set vq state to initial state after reset
Date:   Tue,  1 Jun 2021 16:45:02 +0800
Message-Id: <20210601084503.34724-4-jasowang@redhat.com>
In-Reply-To: <20210601084503.34724-1-jasowang@redhat.com>
References: <20210601084503.34724-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We used to fail the set_vq_state() since it was not supported yet by
the virtio spec. But if the bus tries to set the state which is equal
to the device initial state after reset, we can let it go.

This is a must for virtio_vdpa() to set vq state during probe which is
required for some vDPA parents.

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vdpa/virtio_pci/vp_vdpa.c | 42 ++++++++++++++++++++++++++++---
 1 file changed, 39 insertions(+), 3 deletions(-)

diff --git a/drivers/vdpa/virtio_pci/vp_vdpa.c b/drivers/vdpa/virtio_pci/vp_vdpa.c
index c76ebb531212..18bf4a422772 100644
--- a/drivers/vdpa/virtio_pci/vp_vdpa.c
+++ b/drivers/vdpa/virtio_pci/vp_vdpa.c
@@ -210,13 +210,49 @@ static int vp_vdpa_get_vq_state(struct vdpa_device *vdpa, u16 qid,
 	return -EOPNOTSUPP;
 }
 
+static int vp_vdpa_set_vq_state_split(struct vdpa_device *vdpa,
+				      const struct vdpa_vq_state *state)
+{
+	const struct vdpa_vq_state_split *split = &state->split;
+
+	if (split->avail_index == 0)
+		return 0;
+
+	return -EOPNOTSUPP;
+}
+
+static int vp_vdpa_set_vq_state_packed(struct vdpa_device *vdpa,
+				       const struct vdpa_vq_state *state)
+{
+	const struct vdpa_vq_state_packed *packed = &state->packed;
+
+	if (packed->last_avail_counter == 1 &&
+	    packed->last_avail_idx == 0 &&
+	    packed->last_used_counter == 1 &&
+	    packed->last_used_idx == 0)
+		return 0;
+
+	return -EOPNOTSUPP;
+}
+
 static int vp_vdpa_set_vq_state(struct vdpa_device *vdpa, u16 qid,
 				const struct vdpa_vq_state *state)
 {
-	/* Note that this is not supported by virtio specification, so
-	 * we return -ENOPOTSUPP here. This means we can't support live
-	 * migration, vhost device start/stop.
+	struct virtio_pci_modern_device *mdev = vdpa_to_mdev(vdpa);
+
+	/* Note that this is not supported by virtio specification.
+	 * But if the state is by chance equal to the device initial
+	 * state, we can let it go.
 	 */
+	if ((vp_modern_get_status(mdev) & VIRTIO_CONFIG_S_FEATURES_OK) &&
+	    !vp_modern_get_queue_enable(mdev, qid)) {
+		if (vp_modern_get_driver_features(mdev) &
+		    BIT_ULL(VIRTIO_F_RING_PACKED))
+			return vp_vdpa_set_vq_state_packed(vdpa, state);
+		else
+			return vp_vdpa_set_vq_state_split(vdpa,	state);
+	}
+
 	return -EOPNOTSUPP;
 }
 
-- 
2.25.1

