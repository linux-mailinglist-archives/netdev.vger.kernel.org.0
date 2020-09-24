Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A28B276722
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 05:25:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727044AbgIXDZG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 23:25:06 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:54542 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726854AbgIXDZC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 23:25:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600917901;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0f6y23j1rs6f2A5XlpC2214Hgw54YVYejH44+4fkrGA=;
        b=YENKFEUfgmK7LER5fvJBW9grguYvLQdlk2cvhovQu/QiTz+N14xM/nvtDpr/7hUDYcpzjH
        rRew4nez81E1uR6rhN7p4E3Jynas7xg4umWBH7VEcUV/qIaduqsUkEFgCCJeho8yhtYUrJ
        aFR+ey9BvxdmfVTdhwJf1FYNfqLqfYI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-190-9aoU-TjvMwKAW-cu8oHKZw-1; Wed, 23 Sep 2020 23:24:58 -0400
X-MC-Unique: 9aoU-TjvMwKAW-cu8oHKZw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A119A1891E94;
        Thu, 24 Sep 2020 03:24:55 +0000 (UTC)
Received: from jason-ThinkPad-X1-Carbon-6th.redhat.com (ovpn-13-193.pek2.redhat.com [10.72.13.193])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CC7273782;
        Thu, 24 Sep 2020 03:24:46 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     mst@redhat.com, jasowang@redhat.com
Cc:     lulu@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, rob.miller@broadcom.com,
        lingshan.zhu@intel.com, eperezma@redhat.com, hanand@xilinx.com,
        mhabets@solarflare.com, eli@mellanox.com, amorenoz@redhat.com,
        maxime.coquelin@redhat.com, stefanha@redhat.com,
        sgarzare@redhat.com
Subject: [RFC PATCH 17/24] vhost-vdpa: introduce uAPI to set group ASID
Date:   Thu, 24 Sep 2020 11:21:18 +0800
Message-Id: <20200924032125.18619-18-jasowang@redhat.com>
In-Reply-To: <20200924032125.18619-1-jasowang@redhat.com>
References: <20200924032125.18619-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Follows the vDPA support for associating ASID to a specific virtqueue
group. This patch adds a uAPI to support setting them from userspace.

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vhost/vdpa.c       | 8 ++++++++
 include/uapi/linux/vhost.h | 4 ++++
 2 files changed, 12 insertions(+)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index a234d3783e16..978cf97dc03a 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -441,6 +441,14 @@ static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned int cmd,
 		else if (copy_to_user(argp, &s, sizeof s))
 			return -EFAULT;
 		return 0;
+	case VHOST_VDPA_SET_GROUP_ASID:
+		if (copy_from_user(&s, argp, sizeof(s)))
+			return -EFAULT;
+		if (s.num >= vdpa->ngroups)
+			return -EINVAL;
+		if (!ops->set_group_asid)
+			return -ENOTSUPP;
+		return ops->set_group_asid(vdpa, idx, s.num);
 	case VHOST_GET_VRING_BASE:
 		r = ops->get_vq_state(v->vdpa, idx, &vq_state);
 		if (r)
diff --git a/include/uapi/linux/vhost.h b/include/uapi/linux/vhost.h
index d1c4b5561fee..f3de9e45c518 100644
--- a/include/uapi/linux/vhost.h
+++ b/include/uapi/linux/vhost.h
@@ -151,4 +151,8 @@
 /* Get the group for a virtqueue: read index, write group in num */
 #define VHOST_VDPA_GET_VRING_GROUP	_IOWR(VHOST_VIRTIO, 0x79,	\
 					      struct vhost_vring_state)
+/* Set the ASID for a virtqueue group. */
+#define VHOST_VDPA_SET_GROUP_ASID	_IOW(VHOST_VIRTIO, 0x7A, \
+					     struct vhost_vring_state)
+
 #endif
-- 
2.20.1

