Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 870C52DBB7B
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 07:52:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725951AbgLPGuL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 01:50:11 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31832 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725910AbgLPGuK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 01:50:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608101324;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7QdgenDT2sMoh841L7AxSUPUzuu7jY2qzGd/VuJbSmY=;
        b=B1HsEwXLbH0R2EzwkDSkYUVRqQ5mFcHRmk2rrwhGltfgKtR3ePvqfLSYfoF/+YT5S2C4+i
        Oi62caLw1NDTVBRv3xk85KsjB2WjEBXCJNK6O69sNaPWagD04dWBV+N5sZiHZDQ7drwRBF
        cLtKpFSsMVpm8C36TXUK4ONvjlSwqj4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-413-MSAE3q5FMn2OtPX2mv_poQ-1; Wed, 16 Dec 2020 01:48:41 -0500
X-MC-Unique: MSAE3q5FMn2OtPX2mv_poQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 13A3C10054FF;
        Wed, 16 Dec 2020 06:48:40 +0000 (UTC)
Received: from jason-ThinkPad-X1-Carbon-6th.redhat.com (ovpn-12-210.pek2.redhat.com [10.72.12.210])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B93D610013C1;
        Wed, 16 Dec 2020 06:48:35 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     mst@redhat.com, jasowang@redhat.com
Cc:     eperezma@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lulu@redhat.com, eli@mellanox.com,
        lingshan.zhu@intel.com, rob.miller@broadcom.com,
        stefanha@redhat.com, sgarzare@redhat.com
Subject: [PATCH 02/21] virtio-vdpa: don't set callback if virtio doesn't need it
Date:   Wed, 16 Dec 2020 14:47:59 +0800
Message-Id: <20201216064818.48239-3-jasowang@redhat.com>
In-Reply-To: <20201216064818.48239-1-jasowang@redhat.com>
References: <20201216064818.48239-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There's no need for setting callbacks for the driver that doesn't care
about that.

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/virtio/virtio_vdpa.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/virtio/virtio_vdpa.c b/drivers/virtio/virtio_vdpa.c
index 4a9ddb44b2a7..af6ee677f319 100644
--- a/drivers/virtio/virtio_vdpa.c
+++ b/drivers/virtio/virtio_vdpa.c
@@ -175,7 +175,7 @@ virtio_vdpa_setup_vq(struct virtio_device *vdev, unsigned int index,
 	}
 
 	/* Setup virtqueue callback */
-	cb.callback = virtio_vdpa_virtqueue_cb;
+	cb.callback = callback ? virtio_vdpa_virtqueue_cb : NULL;
 	cb.private = info;
 	ops->set_vq_cb(vdpa, index, &cb);
 	ops->set_vq_num(vdpa, index, virtqueue_get_vring_size(vq));
-- 
2.25.1

