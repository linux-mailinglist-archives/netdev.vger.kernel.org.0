Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28599211E44
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 10:23:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728554AbgGBIXM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 04:23:12 -0400
Received: from lelv0143.ext.ti.com ([198.47.23.248]:55304 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728550AbgGBIXJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 04:23:09 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 0628MwtA042318;
        Thu, 2 Jul 2020 03:22:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1593678178;
        bh=JPB+vJhEmEbr7wwXfNji0ZXjBCp2o1x06a2a2R9o46s=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=NTB4WUvWIwRjwR4PEyvNndWbHFmbpB3bHQ/bjfZA4D488oQ/PPwZMpG8QVgVEECfl
         GirS8Zv5wtU6kWNfh8qRzOwRe3jDX36NKWLH6IAzNFElVyTE8WUhGN+Gh+6mDie4th
         ehSVLDopPkGuaZZq1dslHla/kif2QjPpAYyNCWHw=
Received: from DFLE110.ent.ti.com (dfle110.ent.ti.com [10.64.6.31])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 0628Mw7t031199
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 2 Jul 2020 03:22:58 -0500
Received: from DFLE112.ent.ti.com (10.64.6.33) by DFLE110.ent.ti.com
 (10.64.6.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Thu, 2 Jul
 2020 03:22:58 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE112.ent.ti.com
 (10.64.6.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Thu, 2 Jul 2020 03:22:58 -0500
Received: from a0393678ub.india.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 0628LiYO006145;
        Thu, 2 Jul 2020 03:22:53 -0500
From:   Kishon Vijay Abraham I <kishon@ti.com>
To:     Ohad Ben-Cohen <ohad@wizery.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Jon Mason <jdmason@kudzu.us>,
        Dave Jiang <dave.jiang@intel.com>,
        Allen Hubbe <allenbh@gmail.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>
CC:     <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-remoteproc@vger.kernel.org>, <linux-ntb@googlegroups.com>,
        <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>
Subject: [RFC PATCH 12/22] virtio: Add ops to allocate and free buffer
Date:   Thu, 2 Jul 2020 13:51:33 +0530
Message-ID: <20200702082143.25259-13-kishon@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200702082143.25259-1-kishon@ti.com>
References: <20200702082143.25259-1-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add ops to allocate and free buffer in struct virtio_config_ops.
Certain vhost devices can have restriction on the range of memory
it can access on the virtio. The virtio drivers attached to
such vhost devices reserves memory that can be accessed by
vhost. This function allocates buffer for such reserved region.

For instance when virtio-vhost is used by two hosts connected to
NTB, the vhost can access only memory exposed by memory windows
and the size of the memory window can be limited. Here the NTB
virtio driver can reserve a small region (few MBs) and provide
buffer address from this pool whenever requested by virtio client
driver.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 include/linux/virtio_config.h | 42 +++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/include/linux/virtio_config.h b/include/linux/virtio_config.h
index bb4cc4910750..419f733017c2 100644
--- a/include/linux/virtio_config.h
+++ b/include/linux/virtio_config.h
@@ -65,6 +65,9 @@ struct irq_affinity;
  *      the caller can then copy.
  * @set_vq_affinity: set the affinity for a virtqueue (optional).
  * @get_vq_affinity: get the affinity for a virtqueue (optional).
+ * @alloc_buffer: Allocate and provide buffer addresses that can be
+ *      accessed by both virtio and vhost
+ * @free_buffer: Free the allocated buffer address
  */
 typedef void vq_callback_t(struct virtqueue *);
 struct virtio_config_ops {
@@ -88,6 +91,9 @@ struct virtio_config_ops {
 			       const struct cpumask *cpu_mask);
 	const struct cpumask *(*get_vq_affinity)(struct virtio_device *vdev,
 			int index);
+	void * (*alloc_buffer)(struct virtio_device *vdev, size_t size);
+	void (*free_buffer)(struct virtio_device *vdev, void *addr,
+			    size_t size);
 };
 
 /* If driver didn't advertise the feature, it will never appear. */
@@ -232,6 +238,42 @@ const char *virtio_bus_name(struct virtio_device *vdev)
 	return vdev->config->bus_name(vdev);
 }
 
+/**
+ * virtio_alloc_buffer - Allocate buffer from the reserved memory
+ * @vdev: Virtio device which manages the reserved memory
+ * @size: Size of the buffer to be allocated
+ *
+ * Certain vhost devices can have restriction on the range of memory
+ * it can access on the virtio. The virtio drivers attached to
+ * such vhost devices reserves memory that can be accessed by
+ * vhost. This function allocates buffer for such reserved region.
+ */
+static inline void *
+virtio_alloc_buffer(struct virtio_device *vdev, size_t size)
+{
+	if (!vdev->config->alloc_buffer)
+		return NULL;
+
+	return vdev->config->alloc_buffer(vdev, size);
+}
+
+/**
+ * virtio_free_buffer - Free the allocated buffer
+ * @vdev: Virtio device which manages the reserved memory
+ * @addr: Address returned by virtio_alloc_buffer()
+ * @size: Size of the buffer that has to be freed
+ *
+ * Free the allocated buffer address given by virtio_alloc_buffer().
+ */
+static inline void
+virtio_free_buffer(struct virtio_device *vdev, void *addr, size_t size)
+{
+	if (!vdev->config->free_buffer)
+		return;
+
+	return vdev->config->free_buffer(vdev, addr, size);
+}
+
 /**
  * virtqueue_set_affinity - setting affinity for a virtqueue
  * @vq: the virtqueue
-- 
2.17.1

