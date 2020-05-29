Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 058A81E77B6
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 10:04:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726829AbgE2IDt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 04:03:49 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:57387 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726751AbgE2IDp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 04:03:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590739424;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HcTPYCfr5sCNE0h8qLNyyGd6WCD8Ts7vuwtEmnD7m9Y=;
        b=AD6ybSye3q/BG0vqcgWJir6q9uvG/yi2PFfG/n44UU16U6ShKkbbRaIHlIE7QfRRCGyv/B
        6FbRlErcdy6tnGZ+v5IyByYgQYvHoTprD4n57W8vnqWfKNqoBMf/saMnEFxQn8vZc/qj6t
        3Fx4ilU8U7nMN66yPRddK3dWpkGm7gM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-485-gUMe24RiOTij-A2w3OfVrg-1; Fri, 29 May 2020 04:03:42 -0400
X-MC-Unique: gUMe24RiOTij-A2w3OfVrg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 81F34464;
        Fri, 29 May 2020 08:03:40 +0000 (UTC)
Received: from jason-ThinkPad-X1-Carbon-6th.redhat.com (ovpn-13-231.pek2.redhat.com [10.72.13.231])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7F4BD99DE6;
        Fri, 29 May 2020 08:03:34 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     mst@redhat.com, jasowang@redhat.com
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        rob.miller@broadcom.com, lingshan.zhu@intel.com,
        eperezma@redhat.com, lulu@redhat.com, shahafs@mellanox.com,
        hanand@xilinx.com, mhabets@solarflare.com, gdawar@xilinx.com,
        saugatm@xilinx.com, vmireyno@marvell.com,
        zhangweining@ruijie.com.cn, eli@mellanox.com
Subject: [PATCH 3/6] vdpa: introduce get_vq_notification method
Date:   Fri, 29 May 2020 16:03:00 +0800
Message-Id: <20200529080303.15449-4-jasowang@redhat.com>
In-Reply-To: <20200529080303.15449-1-jasowang@redhat.com>
References: <20200529080303.15449-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch introduces a new method in the vdpa_config_ops which
reports the physical address and the size of the doorbell for a
specific virtqueue.

This will be used by the future patches that maps doorbell to
userspace.

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 include/linux/vdpa.h | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
index 5453af87a33e..239db794357c 100644
--- a/include/linux/vdpa.h
+++ b/include/linux/vdpa.h
@@ -17,6 +17,16 @@ struct vdpa_callback {
 	void *private;
 };
 
+/**
+ * vDPA notification area
+ * @addr: base address of the notification area
+ * @size: size of the notification area
+ */
+struct vdpa_notification_area {
+	resource_size_t addr;
+	resource_size_t size;
+};
+
 /**
  * vDPA device - representation of a vDPA device
  * @dev: underlying device
@@ -73,6 +83,10 @@ struct vdpa_device {
  *				@vdev: vdpa device
  *				@idx: virtqueue index
  *				Returns virtqueue state (last_avail_idx)
+ * @get_vq_notification: 	Get the notification area for a virtqueue
+ *				@vdev: vdpa device
+ *				@idx: virtqueue index
+ *				Returns the notifcation area
  * @get_vq_align:		Get the virtqueue align requirement
  *				for the device
  *				@vdev: vdpa device
@@ -162,6 +176,8 @@ struct vdpa_config_ops {
 	bool (*get_vq_ready)(struct vdpa_device *vdev, u16 idx);
 	int (*set_vq_state)(struct vdpa_device *vdev, u16 idx, u64 state);
 	u64 (*get_vq_state)(struct vdpa_device *vdev, u16 idx);
+	struct vdpa_notification_area
+	(*get_vq_notification)(struct vdpa_device *vdev, u16 idx);
 
 	/* Device ops */
 	u32 (*get_vq_align)(struct vdpa_device *vdev);
-- 
2.20.1

