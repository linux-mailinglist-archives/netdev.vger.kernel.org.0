Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39A352766FF
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 05:23:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726919AbgIXDXs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 23:23:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57624 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726880AbgIXDXs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 23:23:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600917826;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9g8dUxowjtsIBqRQgFTrTNkGNYlQerILKb8HbmSTNbI=;
        b=ILKFs1F5RdF2fMkEtWi4vvcwaVxxI6wO5PA7QtkwEgQKmff1SlTlvLCTlY8b6WCKOmZQPF
        i3iKDK9U4g/3xc3+606S+6D1cZV3Ls78RRGSmJ8xaynCY/QOzF/Rjs0StJCog5ddy9lOjG
        N2CEMzPk1hj+DjBoJQwqvboAmy2JqWI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-371-24y2e25GO8ijICAsU0WX4g-1; Wed, 23 Sep 2020 23:23:41 -0400
X-MC-Unique: 24y2e25GO8ijICAsU0WX4g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1F8A2186DD5A;
        Thu, 24 Sep 2020 03:23:40 +0000 (UTC)
Received: from jason-ThinkPad-X1-Carbon-6th.redhat.com (ovpn-13-193.pek2.redhat.com [10.72.13.193])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AEB7F5577D;
        Thu, 24 Sep 2020 03:23:21 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     mst@redhat.com, jasowang@redhat.com
Cc:     lulu@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, rob.miller@broadcom.com,
        lingshan.zhu@intel.com, eperezma@redhat.com, hanand@xilinx.com,
        mhabets@solarflare.com, eli@mellanox.com, amorenoz@redhat.com,
        maxime.coquelin@redhat.com, stefanha@redhat.com,
        sgarzare@redhat.com
Subject: [RFC PATCH 10/24] vdpa: introduce config operations for associating ASID to a virtqueue group
Date:   Thu, 24 Sep 2020 11:21:11 +0800
Message-Id: <20200924032125.18619-11-jasowang@redhat.com>
In-Reply-To: <20200924032125.18619-1-jasowang@redhat.com>
References: <20200924032125.18619-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch introduces a new bus operation to allow the vDPA bus driver
to associate an ASID to a virtqueue group.

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 include/linux/vdpa.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
index 1e1163daa352..e2394995a3cd 100644
--- a/include/linux/vdpa.h
+++ b/include/linux/vdpa.h
@@ -160,6 +160,12 @@ struct vdpa_device {
  * @get_generation:		Get device config generation (optional)
  *				@vdev: vdpa device
  *				Returns u32: device generation
+ * @set_group_asid:		Set address space identifier for a
+ *				virtqueue group
+ *				@vdev: vdpa device
+ *				@group: virtqueue group
+ *				@asid: address space id for this group
+ *				Returns integer: success (0) or error (< 0)
  * @set_map:			Set device memory mapping (optional)
  *				Needed for device that using device
  *				specific DMA translation (on-chip IOMMU)
@@ -237,6 +243,10 @@ struct vdpa_config_ops {
 		       u64 iova, u64 size, u64 pa, u32 perm);
 	int (*dma_unmap)(struct vdpa_device *vdev, unsigned int asid,
 			 u64 iova, u64 size);
+	int (*set_group_asid)(struct vdpa_device *vdev, unsigned int group,
+			      unsigned int asid);
+
+
 
 	/* Free device resources */
 	void (*free)(struct vdpa_device *vdev);
-- 
2.20.1

