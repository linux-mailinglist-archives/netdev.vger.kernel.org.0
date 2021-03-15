Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC34233C269
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 17:46:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233644AbhCOQgz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 12:36:55 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20763 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234134AbhCOQgg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 12:36:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615826192;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TySZqS37bNSDf+nHbLxQcHvMalZAV5YycVxJe257EIo=;
        b=MVWd75gBXTD0M55mJTGoNnD1vhMbNPnYpxJUMC/rLNDNgJAbf+gULNZJfncF/xkKKt6ySq
        XUIMx4+24jgIwiqD++UGF7PlQZNKKVe9NhIVKuAfLGjjDAeYaP7ndNts/1EODkf5I1/AaU
        4K/7pZy7Myt5dss3TpfVWp7aTkVKu80=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-469-1Dj3RlHpPFGI1QjIc5EkxQ-1; Mon, 15 Mar 2021 12:36:27 -0400
X-MC-Unique: 1Dj3RlHpPFGI1QjIc5EkxQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A9213100C66A;
        Mon, 15 Mar 2021 16:36:25 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-114-1.ams2.redhat.com [10.36.114.1])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5E3FC5C8B3;
        Mon, 15 Mar 2021 16:36:23 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     virtualization@lists.linux-foundation.org
Cc:     netdev@vger.kernel.org, Xie Yongji <xieyongji@bytedance.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        linux-kernel@vger.kernel.org, Max Gurtovoy <mgurtovoy@nvidia.com>,
        Jason Wang <jasowang@redhat.com>,
        Parav Pandit <parav@nvidia.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org
Subject: [PATCH v4 10/14] vhost/vdpa: Remove the restriction that only supports virtio-net devices
Date:   Mon, 15 Mar 2021 17:34:46 +0100
Message-Id: <20210315163450.254396-11-sgarzare@redhat.com>
In-Reply-To: <20210315163450.254396-1-sgarzare@redhat.com>
References: <20210315163450.254396-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xie Yongji <xieyongji@bytedance.com>

Since the config checks are done by the vDPA drivers, we can remove the
virtio-net restriction and we should be able to support all kinds of
virtio devices.

<linux/virtio_net.h> is not needed anymore, but we need to include
<linux/slab.h> to avoid compilation failures.

Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 drivers/vhost/vdpa.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 7ae4080e57d8..850ed4b62942 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -16,12 +16,12 @@
 #include <linux/cdev.h>
 #include <linux/device.h>
 #include <linux/mm.h>
+#include <linux/slab.h>
 #include <linux/iommu.h>
 #include <linux/uuid.h>
 #include <linux/vdpa.h>
 #include <linux/nospec.h>
 #include <linux/vhost.h>
-#include <linux/virtio_net.h>
 
 #include "vhost.h"
 
@@ -1018,10 +1018,6 @@ static int vhost_vdpa_probe(struct vdpa_device *vdpa)
 	int minor;
 	int r;
 
-	/* Currently, we only accept the network devices. */
-	if (ops->get_device_id(vdpa) != VIRTIO_ID_NET)
-		return -ENOTSUPP;
-
 	v = kzalloc(sizeof(*v), GFP_KERNEL | __GFP_RETRY_MAYFAIL);
 	if (!v)
 		return -ENOMEM;
-- 
2.30.2

