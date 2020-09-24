Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE53D2766E8
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 05:22:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726752AbgIXDWd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 23:22:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:25169 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726665AbgIXDWd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 23:22:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600917752;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/Wjy4504cstLZT/a9s8xAMUauA+PFi260PeYanPN/xQ=;
        b=PR16AKlX0v2uUFOiBm8WYbn55U9oJIUS6T86NQju87Uz4+0wNs+ktlWok1+TGkay75Y1cs
        n2QsSa/TxUsy0NsFl30K4taVFmrnNUWPts+KrRJ3q4EorFm3w+KDYPqr5egDDX7VoTQGs2
        HnJxteb/K8q94UguF+npANxbAWGRwyA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-500-Z9KOmGBVO_KxBQn3k61XmQ-1; Wed, 23 Sep 2020 23:22:30 -0400
X-MC-Unique: Z9KOmGBVO_KxBQn3k61XmQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EAABF81CAFC;
        Thu, 24 Sep 2020 03:22:28 +0000 (UTC)
Received: from jason-ThinkPad-X1-Carbon-6th.redhat.com (ovpn-13-193.pek2.redhat.com [10.72.13.193])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 65D1F55777;
        Thu, 24 Sep 2020 03:22:12 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     mst@redhat.com, jasowang@redhat.com
Cc:     lulu@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, rob.miller@broadcom.com,
        lingshan.zhu@intel.com, eperezma@redhat.com, hanand@xilinx.com,
        mhabets@solarflare.com, eli@mellanox.com, amorenoz@redhat.com,
        maxime.coquelin@redhat.com, stefanha@redhat.com,
        sgarzare@redhat.com
Subject: [RFC PATCH 04/24] virtio-vdpa: don't set callback if virtio doesn't need it
Date:   Thu, 24 Sep 2020 11:21:05 +0800
Message-Id: <20200924032125.18619-5-jasowang@redhat.com>
In-Reply-To: <20200924032125.18619-1-jasowang@redhat.com>
References: <20200924032125.18619-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
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
2.20.1

