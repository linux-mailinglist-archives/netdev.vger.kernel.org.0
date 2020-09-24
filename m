Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2ADB927671A
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 05:24:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726685AbgIXDYv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 23:24:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:21678 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727042AbgIXDYu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 23:24:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600917889;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AfueecD2nn0g5NX57haltefO9h8rHly/lmEeHDzFMsw=;
        b=ZiXk4SPpSZmT0gAUoSB51PkinVubnW37ZUAbgmKCxl5iaMcGzlBvQv/LfCmojhKzewNP72
        TKFLJ+/e9zXYQS6R4I7xWzcpamp3VvYGoLE/9bkYCxblDGO1oSnvW5tU/mGkyI0qWgcIXC
        DXsAO9p5Z6EN4jgBIgh4LsAJuL/IF+I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-186-wvmr4WtwMBW74W3C2qdSmg-1; Wed, 23 Sep 2020 23:24:47 -0400
X-MC-Unique: wvmr4WtwMBW74W3C2qdSmg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5C719106B3A1;
        Thu, 24 Sep 2020 03:24:46 +0000 (UTC)
Received: from jason-ThinkPad-X1-Carbon-6th.redhat.com (ovpn-13-193.pek2.redhat.com [10.72.13.193])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8578055777;
        Thu, 24 Sep 2020 03:24:34 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     mst@redhat.com, jasowang@redhat.com
Cc:     lulu@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, rob.miller@broadcom.com,
        lingshan.zhu@intel.com, eperezma@redhat.com, hanand@xilinx.com,
        mhabets@solarflare.com, eli@mellanox.com, amorenoz@redhat.com,
        maxime.coquelin@redhat.com, stefanha@redhat.com,
        sgarzare@redhat.com
Subject: [RFC PATCH 16/24] vhost-vdpa: uAPI to get virtqueue group id
Date:   Thu, 24 Sep 2020 11:21:17 +0800
Message-Id: <20200924032125.18619-17-jasowang@redhat.com>
In-Reply-To: <20200924032125.18619-1-jasowang@redhat.com>
References: <20200924032125.18619-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Follows the support for virtqueue group in vDPA. This patches
introduces uAPI to get the virtqueue group ID for a specific virtqueue
in vhost-vdpa.

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vhost/vdpa.c       | 8 ++++++++
 include/uapi/linux/vhost.h | 4 ++++
 2 files changed, 12 insertions(+)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 4d97a59824a1..a234d3783e16 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -433,6 +433,14 @@ static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned int cmd,
 			return -EFAULT;
 		ops->set_vq_ready(vdpa, idx, s.num);
 		return 0;
+	case VHOST_VDPA_GET_VRING_GROUP:
+		s.index = idx;
+		s.num = ops->get_vq_group(vdpa, idx);
+		if (s.num >= vdpa->ngroups)
+			return -EIO;
+		else if (copy_to_user(argp, &s, sizeof s))
+			return -EFAULT;
+		return 0;
 	case VHOST_GET_VRING_BASE:
 		r = ops->get_vq_state(v->vdpa, idx, &vq_state);
 		if (r)
diff --git a/include/uapi/linux/vhost.h b/include/uapi/linux/vhost.h
index 99bdf50efc50..d1c4b5561fee 100644
--- a/include/uapi/linux/vhost.h
+++ b/include/uapi/linux/vhost.h
@@ -147,4 +147,8 @@
 
 /* Get the number of address spaces. */
 #define VHOST_VDPA_GET_AS_NUM		_IOR(VHOST_VIRTIO, 0x79, unsigned int)
+
+/* Get the group for a virtqueue: read index, write group in num */
+#define VHOST_VDPA_GET_VRING_GROUP	_IOWR(VHOST_VIRTIO, 0x79,	\
+					      struct vhost_vring_state)
 #endif
-- 
2.20.1

