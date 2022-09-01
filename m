Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E1E45A947D
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 12:25:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233522AbiIAKZE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 06:25:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234132AbiIAKY5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 06:24:57 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23D1D767E;
        Thu,  1 Sep 2022 03:24:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662027895; x=1693563895;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9HjL/W+gmiSSE6abdxbrCjvq1RrEYFDNTS5WWx3pgq8=;
  b=O5bH6lSeSICePShjYlLL6xPzrY7X2vAYzfpHE7TPRCXg8LfhMiAJqOaZ
   wPd2Em1+nS7sHvJizbQWO1lWq4X3LBaaEwja8bcQMvSxPu6opoWCRYNMo
   U3a4VReViTEe0eGvoDFOO6dC7/QHNKF8SmZMp1mb8qVPChcQgNZgxIjB+
   Ma0QC39aQDMJvInx9en7PRM5QuXgkbXF8EG+cZM4njTdVYAVe8csxhJRu
   FlgaHioBOoce/tR2W4L9m/q0YzulrnX9S+NmzG123pmoag+zEZ/ubS+4b
   do9ZMT6Sof/Vn5E7wfgl2buKM2q2lSGc0hYcYwalFEMJFVvEnFAKztil4
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10456"; a="321825553"
X-IronPort-AV: E=Sophos;i="5.93,280,1654585200"; 
   d="scan'208";a="321825553"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2022 03:24:54 -0700
X-IronPort-AV: E=Sophos;i="5.93,280,1654585200"; 
   d="scan'208";a="642276426"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.193.73])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2022 03:24:53 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [RFC 1/4] vDPA/ifcvf: add get/set_vq_endian support for vDPA
Date:   Thu,  1 Sep 2022 18:15:58 +0800
Message-Id: <20220901101601.61420-2-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220901101601.61420-1-lingshan.zhu@intel.com>
References: <20220901101601.61420-1-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit introuduces new config operatoions for vDPA:
vdpa_config_ops.get_vq_endian: set vq endian-ness
vdpa_config_ops.set_vq_endian: get vq endian-ness

Because the endian-ness is a device wide attribute,
so seting a vq's endian-ness will result in changing
the device endian-ness, including all vqs and the config space.

These two operations are implemented in ifcvf in this commit.

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
---
 drivers/vdpa/ifcvf/ifcvf_base.h |  1 +
 drivers/vdpa/ifcvf/ifcvf_main.c | 15 +++++++++++++++
 include/linux/vdpa.h            | 13 +++++++++++++
 3 files changed, 29 insertions(+)

diff --git a/drivers/vdpa/ifcvf/ifcvf_base.h b/drivers/vdpa/ifcvf/ifcvf_base.h
index f5563f665cc6..640238b95033 100644
--- a/drivers/vdpa/ifcvf/ifcvf_base.h
+++ b/drivers/vdpa/ifcvf/ifcvf_base.h
@@ -19,6 +19,7 @@
 #include <uapi/linux/virtio_blk.h>
 #include <uapi/linux/virtio_config.h>
 #include <uapi/linux/virtio_pci.h>
+#include <uapi/linux/vhost.h>
 
 #define N3000_DEVICE_ID		0x1041
 #define N3000_SUBSYS_DEVICE_ID	0x001A
diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
index f9c0044c6442..270637d0f3a5 100644
--- a/drivers/vdpa/ifcvf/ifcvf_main.c
+++ b/drivers/vdpa/ifcvf/ifcvf_main.c
@@ -684,6 +684,19 @@ static struct vdpa_notification_area ifcvf_get_vq_notification(struct vdpa_devic
 	return area;
 }
 
+static u8 ifcvf_vdpa_get_vq_endian(struct vdpa_device *vdpa_dev, u16 idx)
+{
+	return VHOST_VRING_LITTLE_ENDIAN;
+}
+
+static int ifcvf_vdpa_set_vq_endian(struct vdpa_device *vdpa_dev, u16 idx, u8 endian)
+{
+	if (endian != VHOST_VRING_LITTLE_ENDIAN)
+		return -EFAULT;
+
+	return 0;
+}
+
 /*
  * IFCVF currently doesn't have on-chip IOMMU, so not
  * implemented set_map()/dma_map()/dma_unmap()
@@ -715,6 +728,8 @@ static const struct vdpa_config_ops ifc_vdpa_ops = {
 	.set_config	= ifcvf_vdpa_set_config,
 	.set_config_cb  = ifcvf_vdpa_set_config_cb,
 	.get_vq_notification = ifcvf_get_vq_notification,
+	.get_vq_endian	= ifcvf_vdpa_get_vq_endian,
+	.set_vq_endian	= ifcvf_vdpa_set_vq_endian,
 };
 
 static struct virtio_device_id id_table_net[] = {
diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
index d282f464d2f1..5eb83453ba86 100644
--- a/include/linux/vdpa.h
+++ b/include/linux/vdpa.h
@@ -174,6 +174,17 @@ struct vdpa_map_file {
  *				@idx: virtqueue index
  *				Returns int: irq number of a virtqueue,
  *				negative number if no irq assigned.
+ * @set_vq_endian:		set endian-ness for a virtqueue
+ *				@vdev: vdpa device
+ *				@idx: virtqueue index
+ *				@endian: the endian-ness to set,
+ *				can be VHOST_VRING_LITTLE_ENDIAN or VHOST_VRING_BIG_ENDIAN
+ *				Returns integer: success (0) or error (< 0)
+ * @get_vq_endian:		get the endian-ness of a virtqueue
+ *				@vdev: vdpa device
+ *				@idx: virtqueue index
+ *				Returns u8, the endian-ness of the virtqueue,
+ *				can be VHOST_VRING_LITTLE_ENDIAN or VHOST_VRING_BIG_ENDIAN
  * @get_vq_align:		Get the virtqueue align requirement
  *				for the device
  *				@vdev: vdpa device
@@ -306,6 +317,8 @@ struct vdpa_config_ops {
 	(*get_vq_notification)(struct vdpa_device *vdev, u16 idx);
 	/* vq irq is not expected to be changed once DRIVER_OK is set */
 	int (*get_vq_irq)(struct vdpa_device *vdev, u16 idx);
+	int (*set_vq_endian)(struct vdpa_device *vdev, u16 idx, u8 endian);
+	u8 (*get_vq_endian)(struct vdpa_device *vdev, u16 idx);
 
 	/* Device ops */
 	u32 (*get_vq_align)(struct vdpa_device *vdev);
-- 
2.31.1

