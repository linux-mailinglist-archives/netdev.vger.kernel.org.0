Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40227B4514
	for <lists+netdev@lfdr.de>; Tue, 17 Sep 2019 03:05:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391635AbfIQBFJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 21:05:09 -0400
Received: from mga04.intel.com ([192.55.52.120]:34819 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727996AbfIQBFD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Sep 2019 21:05:03 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Sep 2019 18:05:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,514,1559545200"; 
   d="scan'208";a="180611983"
Received: from dpdk-virtio-tbie-2.sh.intel.com ([10.67.104.71])
  by orsmga008.jf.intel.com with ESMTP; 16 Sep 2019 18:05:01 -0700
From:   Tiwei Bie <tiwei.bie@intel.com>
To:     mst@redhat.com, jasowang@redhat.com, alex.williamson@redhat.com,
        maxime.coquelin@redhat.com
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        dan.daly@intel.com, cunming.liang@intel.com,
        zhihong.wang@intel.com, lingshan.zhu@intel.com, tiwei.bie@intel.com
Subject: [RFC v4 2/3] vfio: support checking vfio driver by device ops
Date:   Tue, 17 Sep 2019 09:02:03 +0800
Message-Id: <20190917010204.30376-3-tiwei.bie@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190917010204.30376-1-tiwei.bie@intel.com>
References: <20190917010204.30376-1-tiwei.bie@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch introduces the support for checking the VFIO driver
by device ops. And vfio-mdev's device ops is also exported to
make it possible to check whether a VFIO device is based on a
mdev device.

Signed-off-by: Tiwei Bie <tiwei.bie@intel.com>
---
 drivers/vfio/mdev/vfio_mdev.c | 3 ++-
 drivers/vfio/vfio.c           | 7 +++++++
 include/linux/vfio.h          | 7 +++++++
 3 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/mdev/vfio_mdev.c b/drivers/vfio/mdev/vfio_mdev.c
index 30964a4e0a28..e0f31c5a5db2 100644
--- a/drivers/vfio/mdev/vfio_mdev.c
+++ b/drivers/vfio/mdev/vfio_mdev.c
@@ -98,7 +98,7 @@ static int vfio_mdev_mmap(void *device_data, struct vm_area_struct *vma)
 	return parent->ops->mmap(mdev, vma);
 }
 
-static const struct vfio_device_ops vfio_mdev_dev_ops = {
+const struct vfio_device_ops vfio_mdev_dev_ops = {
 	.name		= "vfio-mdev",
 	.open		= vfio_mdev_open,
 	.release	= vfio_mdev_release,
@@ -107,6 +107,7 @@ static const struct vfio_device_ops vfio_mdev_dev_ops = {
 	.write		= vfio_mdev_write,
 	.mmap		= vfio_mdev_mmap,
 };
+EXPORT_SYMBOL_GPL(vfio_mdev_dev_ops);
 
 static int vfio_mdev_probe(struct device *dev)
 {
diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 697fd079bb3f..1145110909e4 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -1806,6 +1806,13 @@ long vfio_external_check_extension(struct vfio_group *group, unsigned long arg)
 }
 EXPORT_SYMBOL_GPL(vfio_external_check_extension);
 
+bool vfio_device_ops_match(struct vfio_device *device,
+			   const struct vfio_device_ops *ops)
+{
+	return device->ops == ops;
+}
+EXPORT_SYMBOL_GPL(vfio_device_ops_match);
+
 /**
  * Sub-module support
  */
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index e75b24fd7c5c..741c5bb567a8 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -56,6 +56,8 @@ extern struct vfio_device *vfio_device_get_from_fd(struct vfio_group *group,
 						   int device_fd);
 extern void vfio_device_put(struct vfio_device *device);
 extern void *vfio_device_data(struct vfio_device *device);
+extern bool vfio_device_ops_match(struct vfio_device *device,
+				  const struct vfio_device_ops *ops);
 
 /**
  * struct vfio_iommu_driver_ops - VFIO IOMMU driver callbacks
@@ -199,4 +201,9 @@ extern int vfio_virqfd_enable(void *opaque,
 			      void *data, struct virqfd **pvirqfd, int fd);
 extern void vfio_virqfd_disable(struct virqfd **pvirqfd);
 
+/*
+ * VFIO device ops
+ */
+extern const struct vfio_device_ops vfio_mdev_dev_ops;
+
 #endif /* VFIO_H */
-- 
2.17.1

