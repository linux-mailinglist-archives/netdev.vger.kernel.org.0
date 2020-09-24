Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2724C276717
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 05:24:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727049AbgIXDYl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 23:24:41 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:24507 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727042AbgIXDYk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 23:24:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600917879;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OLZxxfoGFHwl3RRF/XeYrXw41P3lCMv/1i4VDUjzn8s=;
        b=UAmlXfUTmg27kZJLJlubc5mnYwGfjD7sUJdjc+jlrDscEhdNCwyefUfBVIudD/lX2sMCEO
        XKTuWF099RT3hSwPIVk2x8mxZfwYxiWMeDjrpLaWPh1YXU15k5ww8I5PGH4BsUMyyNxgYn
        H6LDPhkGY/0sRIZEcdRrmSTK8KDPheE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-312-d5JN6TEBMvaxNzeOc9QI4Q-1; Wed, 23 Sep 2020 23:24:35 -0400
X-MC-Unique: d5JN6TEBMvaxNzeOc9QI4Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E729E89154F;
        Thu, 24 Sep 2020 03:24:33 +0000 (UTC)
Received: from jason-ThinkPad-X1-Carbon-6th.redhat.com (ovpn-13-193.pek2.redhat.com [10.72.13.193])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2A1083782;
        Thu, 24 Sep 2020 03:24:24 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     mst@redhat.com, jasowang@redhat.com
Cc:     lulu@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, rob.miller@broadcom.com,
        lingshan.zhu@intel.com, eperezma@redhat.com, hanand@xilinx.com,
        mhabets@solarflare.com, eli@mellanox.com, amorenoz@redhat.com,
        maxime.coquelin@redhat.com, stefanha@redhat.com,
        sgarzare@redhat.com
Subject: [RFC PATCH 15/24] vhost-vdpa: introduce uAPI to get the number of address spaces
Date:   Thu, 24 Sep 2020 11:21:16 +0800
Message-Id: <20200924032125.18619-16-jasowang@redhat.com>
In-Reply-To: <20200924032125.18619-1-jasowang@redhat.com>
References: <20200924032125.18619-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A new uAPI is introduced for the userspace to know the address spaces
that is supported by a specific device.

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vhost/vdpa.c       | 3 +++
 include/uapi/linux/vhost.h | 2 ++
 2 files changed, 5 insertions(+)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 4b8882f55bc9..4d97a59824a1 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -532,6 +532,9 @@ static long vhost_vdpa_unlocked_ioctl(struct file *filep,
 		r = copy_to_user(argp, &v->vdpa->ngroups,
 				 sizeof(v->vdpa->ngroups));
 		break;
+	case VHOST_VDPA_GET_AS_NUM:
+		r = copy_to_user(argp, &v->vdpa->nas, sizeof(v->vdpa->nas));
+		break;
 	case VHOST_SET_LOG_BASE:
 	case VHOST_SET_LOG_FD:
 		r = -ENOIOCTLCMD;
diff --git a/include/uapi/linux/vhost.h b/include/uapi/linux/vhost.h
index 19f1acdfe3ea..99bdf50efc50 100644
--- a/include/uapi/linux/vhost.h
+++ b/include/uapi/linux/vhost.h
@@ -145,4 +145,6 @@
 /* Get the number of virtqueue groups. */
 #define VHOST_VDPA_GET_GROUP_NUM	_IOR(VHOST_VIRTIO, 0x78, unsigned int)
 
+/* Get the number of address spaces. */
+#define VHOST_VDPA_GET_AS_NUM		_IOR(VHOST_VIRTIO, 0x79, unsigned int)
 #endif
-- 
2.20.1

