Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF2FE2DBB8D
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 07:52:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726031AbgLPGut (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 01:50:49 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39197 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725997AbgLPGut (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 01:50:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608101363;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5hpiTWff/q01n7aDyM8nOVVw88HssmeVscsZoNCXoO8=;
        b=Djr8avYpmafyeazJ7nsEL1UAqzHoy11MDg9XT4M3Nct1jPliw0vVDwT+1pxsxZ0au9MbAY
        ndvrJXe+DWIaBqe7fXKxspKERf4d+DVfdh8lFmuC40HxBhtYBWAGrB9X2B4FlXun96bJVJ
        MxzJ+8GoUhifhr1oxVpsarBY/z8lQI4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-279-e54YYSFSM-6haotVO9Vk0A-1; Wed, 16 Dec 2020 01:49:21 -0500
X-MC-Unique: e54YYSFSM-6haotVO9Vk0A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 29F39180A09B;
        Wed, 16 Dec 2020 06:49:20 +0000 (UTC)
Received: from jason-ThinkPad-X1-Carbon-6th.redhat.com (ovpn-12-210.pek2.redhat.com [10.72.12.210])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1887210016FF;
        Wed, 16 Dec 2020 06:49:15 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     mst@redhat.com, jasowang@redhat.com
Cc:     eperezma@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lulu@redhat.com, eli@mellanox.com,
        lingshan.zhu@intel.com, rob.miller@broadcom.com,
        stefanha@redhat.com, sgarzare@redhat.com
Subject: [PATCH 08/21] vdpa: introduce config operations for associating ASID to a virtqueue group
Date:   Wed, 16 Dec 2020 14:48:05 +0800
Message-Id: <20201216064818.48239-9-jasowang@redhat.com>
In-Reply-To: <20201216064818.48239-1-jasowang@redhat.com>
References: <20201216064818.48239-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
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
index 0a9a754f8180..2a8671f27b0b 100644
--- a/include/linux/vdpa.h
+++ b/include/linux/vdpa.h
@@ -174,6 +174,12 @@ struct vdpa_iova_range {
  *				@vdev: vdpa device
  *				Returns the iova range supported by
  *				the device.
+ * @set_group_asid:		Set address space identifier for a
+ *				virtqueue group
+ *				@vdev: vdpa device
+ *				@group: virtqueue group
+ *				@asid: address space id for this group
+ *				Returns integer: success (0) or error (< 0)
  * @set_map:			Set device memory mapping (optional)
  *				Needed for device that using device
  *				specific DMA translation (on-chip IOMMU)
@@ -252,6 +258,10 @@ struct vdpa_config_ops {
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
2.25.1

