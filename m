Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A773B2DBBA5
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 07:52:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726051AbgLPGvo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 01:51:44 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:36336 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726090AbgLPGvn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 01:51:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608101417;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kt/cE0w0a40J98Cvje+1/tA4SIpHn2zjWKKNYN09V4Y=;
        b=G4KaZQdv9ODUWeYSp+VGzCrfS3zJccH/XxPw9PG1llCipNJNaUcEU89GPY1GMCWRrcUeEc
        y2eQV+X7fYETWRnW4sskyfZ32Va0FQlOdPJLDA0qhoAOHKSUvnYowDG2T8ME/EwD/vXf31
        6MNETO9mholbj08HlKaALJPG3tQr+0c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-238-A-pmfw7nNK-8Re4FjluaJQ-1; Wed, 16 Dec 2020 01:50:13 -0500
X-MC-Unique: A-pmfw7nNK-8Re4FjluaJQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 633C215726;
        Wed, 16 Dec 2020 06:50:12 +0000 (UTC)
Received: from jason-ThinkPad-X1-Carbon-6th.redhat.com (ovpn-12-210.pek2.redhat.com [10.72.12.210])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1EE9110013C1;
        Wed, 16 Dec 2020 06:50:01 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     mst@redhat.com, jasowang@redhat.com
Cc:     eperezma@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lulu@redhat.com, eli@mellanox.com,
        lingshan.zhu@intel.com, rob.miller@broadcom.com,
        stefanha@redhat.com, sgarzare@redhat.com
Subject: [PATCH 14/21] vhost-vdpa: uAPI to get virtqueue group id
Date:   Wed, 16 Dec 2020 14:48:11 +0800
Message-Id: <20201216064818.48239-15-jasowang@redhat.com>
In-Reply-To: <20201216064818.48239-1-jasowang@redhat.com>
References: <20201216064818.48239-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Follows the support for virtqueue group in vDPA. This patches
introduces uAPI to get the virtqueue group ID for a specific virtqueue
in vhost-vdpa.

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vhost/vdpa.c       | 8 ++++++++
 include/uapi/linux/vhost.h | 8 ++++++++
 2 files changed, 16 insertions(+)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index bff8aa214f78..e7023abda12c 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -442,6 +442,14 @@ static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned int cmd,
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
index 8762911a3cb8..99de06476fdc 100644
--- a/include/uapi/linux/vhost.h
+++ b/include/uapi/linux/vhost.h
@@ -150,4 +150,12 @@
 
 /* Get the number of address spaces. */
 #define VHOST_VDPA_GET_AS_NUM		_IOR(VHOST_VIRTIO, 0x7A, unsigned int)
+
+/* Get the group for a virtqueue: read index, write group in num,
+ * The virtqueue index is stored in the index field of
+ * vhost_vring_state. The group for this specific virtqueue is
+ * returned via num field of vhost_vring_state.
+ */
+#define VHOST_VDPA_GET_VRING_GROUP	_IOWR(VHOST_VIRTIO, 0x7B,	\
+					      struct vhost_vring_state)
 #endif
-- 
2.25.1

