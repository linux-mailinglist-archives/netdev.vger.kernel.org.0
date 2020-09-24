Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99B22276714
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 05:24:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727032AbgIXDYf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 23:24:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55792 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727014AbgIXDY3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 23:24:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600917867;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VAOxTOHJZ6ojqD58K3kd7iNYbA07FzjnaSEIdokI3g8=;
        b=c64NObtD/M4Kg9S4m2P4T4deqzFjLDi0vui3z/zLlIk1XMGPf4yHlqEsi3KLzO3t+haJ+W
        u1VuaqNbxOUwxSz4bb7jddp0jLhFFqyLMBAzij5XuOgpabjLHETY8Tw7srgYH5WmO+/0jX
        /x5EgpUeOh+1VI7FCzBpvsZ+N/WLVmw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-351-XXCt9g9tOEqYIzUiYHxrOw-1; Wed, 23 Sep 2020 23:24:26 -0400
X-MC-Unique: XXCt9g9tOEqYIzUiYHxrOw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5AA45106B82C;
        Thu, 24 Sep 2020 03:24:24 +0000 (UTC)
Received: from jason-ThinkPad-X1-Carbon-6th.redhat.com (ovpn-13-193.pek2.redhat.com [10.72.13.193])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 402BB55777;
        Thu, 24 Sep 2020 03:24:11 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     mst@redhat.com, jasowang@redhat.com
Cc:     lulu@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, rob.miller@broadcom.com,
        lingshan.zhu@intel.com, eperezma@redhat.com, hanand@xilinx.com,
        mhabets@solarflare.com, eli@mellanox.com, amorenoz@redhat.com,
        maxime.coquelin@redhat.com, stefanha@redhat.com,
        sgarzare@redhat.com
Subject: [RFC PATCH 14/24] vhost-vdpa: introduce uAPI to get the number of virtqueue groups
Date:   Thu, 24 Sep 2020 11:21:15 +0800
Message-Id: <20200924032125.18619-15-jasowang@redhat.com>
In-Reply-To: <20200924032125.18619-1-jasowang@redhat.com>
References: <20200924032125.18619-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Follows the vDPA support for multiple address spaces, this patch
introduce uAPI for the userspace to know the number of virtqueue
groups supported by the vDPA device.

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vhost/vdpa.c       | 4 ++++
 include/uapi/linux/vhost.h | 4 ++++
 2 files changed, 8 insertions(+)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 1ba7e95619b5..4b8882f55bc9 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -528,6 +528,10 @@ static long vhost_vdpa_unlocked_ioctl(struct file *filep,
 	case VHOST_VDPA_GET_VRING_NUM:
 		r = vhost_vdpa_get_vring_num(v, argp);
 		break;
+	case VHOST_VDPA_GET_GROUP_NUM:
+		r = copy_to_user(argp, &v->vdpa->ngroups,
+				 sizeof(v->vdpa->ngroups));
+		break;
 	case VHOST_SET_LOG_BASE:
 	case VHOST_SET_LOG_FD:
 		r = -ENOIOCTLCMD;
diff --git a/include/uapi/linux/vhost.h b/include/uapi/linux/vhost.h
index c26452782882..19f1acdfe3ea 100644
--- a/include/uapi/linux/vhost.h
+++ b/include/uapi/linux/vhost.h
@@ -141,4 +141,8 @@
 
 /* Set event fd for config interrupt*/
 #define VHOST_VDPA_SET_CONFIG_CALL	_IOW(VHOST_VIRTIO, 0x77, int)
+
+/* Get the number of virtqueue groups. */
+#define VHOST_VDPA_GET_GROUP_NUM	_IOR(VHOST_VIRTIO, 0x78, unsigned int)
+
 #endif
-- 
2.20.1

