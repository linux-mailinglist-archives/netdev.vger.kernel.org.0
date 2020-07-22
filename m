Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D66142295C4
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 12:14:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731958AbgGVKNO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 06:13:14 -0400
Received: from mga07.intel.com ([134.134.136.100]:37342 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728599AbgGVKNN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Jul 2020 06:13:13 -0400
IronPort-SDR: c9wrcmQbiHWbhU8Mwcob8y+Y4YmEIGkzaky7BXCZp8WMC/xWxqBnwyzVX4zI3no3ggwJv8qtv3
 3d2KcxG8tGoQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9689"; a="214940302"
X-IronPort-AV: E=Sophos;i="5.75,381,1589266800"; 
   d="scan'208";a="214940302"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2020 03:13:13 -0700
IronPort-SDR: 0xQ8tLpPI6HEsgnLmW6Z6YgzwTdmrmEV3r4lla0CpbB/dI8fklPZA3DeDk5YR41wX5+zHVbmxF
 eCKh0bhQbB4A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,381,1589266800"; 
   d="scan'208";a="392634916"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.192.131])
  by fmsmga001.fm.intel.com with ESMTP; 22 Jul 2020 03:13:10 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, alex.williamson@redhat.com, mst@redhat.com,
        pbonzini@redhat.com, sean.j.christopherson@intel.com,
        wanpengli@tencent.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V3 3/6] vDPA: implement vq IRQ allocate/free helpers in vDPA core
Date:   Wed, 22 Jul 2020 18:08:56 +0800
Message-Id: <20200722100859.221669-4-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.18.4
In-Reply-To: <20200722100859.221669-1-lingshan.zhu@intel.com>
References: <20200722100859.221669-1-lingshan.zhu@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit implements vq IRQ allocate/free helpers in vDPA
core by introducing two couple of functions:

vdpa_devm_request_Irq() and vdpa_devm_free_irq(): request irq and free
irq, and setup irq offloading.

vdpa_setup_irq() and vdpa_unsetup_irq(): supportive functions,
will call vhost_vdpa helpers.

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
---
 drivers/vdpa/vdpa.c  | 49 ++++++++++++++++++++++++++++++++++++++++++++
 include/linux/vdpa.h | 13 ++++++++++++
 2 files changed, 62 insertions(+)

diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
index de211ef3738c..4dfc86eba0f6 100644
--- a/drivers/vdpa/vdpa.c
+++ b/drivers/vdpa/vdpa.c
@@ -163,6 +163,55 @@ void vdpa_unregister_driver(struct vdpa_driver *drv)
 }
 EXPORT_SYMBOL_GPL(vdpa_unregister_driver);
 
+static void vdpa_setup_irq(struct vdpa_device *vdev, int qid, int irq)
+{
+	struct vdpa_driver *drv = drv_to_vdpa(vdev->dev.driver);
+
+	if (drv->setup_vq_irq)
+		drv->setup_vq_irq(vdev, qid, irq);
+}
+
+static void vdpa_unsetup_irq(struct vdpa_device *vdev, int qid)
+{
+	struct vdpa_driver *drv = drv_to_vdpa(vdev->dev.driver);
+
+	if (drv && drv->unsetup_vq_irq)
+		drv->unsetup_vq_irq(vdev, qid);
+}
+
+/*
+ * Request irq for a vq, setup irq offloading if its a vhost_vdpa vq.
+ * This function should be only called through setting virtio DRIVER_OK.
+ * If you want to request irq during probe, you should use raw APIs
+ * like request_irq() or devm_request_irq().
+ */
+int vdpa_devm_request_irq(struct device *dev, struct vdpa_device *vdev,
+			  unsigned int irq, irq_handler_t handler,
+			  unsigned long irqflags, const char *devname, void *dev_id,
+			  int qid)
+{
+	int ret;
+
+	ret = devm_request_irq(dev, irq, handler, irqflags, devname, dev_id);
+	if (ret)
+		dev_err(dev, "Failed to request irq for vq %d\n", qid);
+	else
+		vdpa_setup_irq(vdev, qid, irq);
+
+	return ret;
+
+}
+EXPORT_SYMBOL_GPL(vdpa_devm_request_irq);
+
+/* free irq for a vq, unsetup irq offloading if its a vhost_vdpa vq */
+void vdpa_devm_free_irq(struct device *dev, struct vdpa_device *vdev, int irq,
+			int qid, void *dev_id)
+{
+	devm_free_irq(dev, irq, dev_id);
+	vdpa_unsetup_irq(vdev, qid);
+}
+EXPORT_SYMBOL_GPL(vdpa_devm_free_irq);
+
 static int vdpa_init(void)
 {
 	return bus_register(&vdpa_bus);
diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
index 239db794357c..9412e3b56589 100644
--- a/include/linux/vdpa.h
+++ b/include/linux/vdpa.h
@@ -220,17 +220,30 @@ struct vdpa_device *__vdpa_alloc_device(struct device *parent,
 
 int vdpa_register_device(struct vdpa_device *vdev);
 void vdpa_unregister_device(struct vdpa_device *vdev);
+int vdpa_devm_request_irq(struct device *dev, struct vdpa_device *vdev,
+			  unsigned int irq, irq_handler_t handler,
+			  unsigned long irqflags, const char *devname, void *dev_id,
+			  int qid);
+void vdpa_devm_free_irq(struct device *dev, struct vdpa_device *vdev, int irq,
+			int qid, void *dev_id);
+
 
 /**
  * vdpa_driver - operations for a vDPA driver
  * @driver: underlying device driver
  * @probe: the function to call when a device is found.  Returns 0 or -errno.
  * @remove: the function to call when a device is removed.
+ * @setup_vq_irq: the function to call after request irq for a vhost_vdpa vq,
+ * do setup works e.g irq offloading.
+ * @unsetup_vq_irq: the function to call after free irq for a vhost_vdpa vq,
+ * do unsetup works e.g relieve irq offloading.
  */
 struct vdpa_driver {
 	struct device_driver driver;
 	int (*probe)(struct vdpa_device *vdev);
 	void (*remove)(struct vdpa_device *vdev);
+	void (*setup_vq_irq)(struct vdpa_device *vdev, int qid, int irq);
+	void (*unsetup_vq_irq)(struct vdpa_device *vdev, int qid);
 };
 
 #define vdpa_register_driver(drv) \
-- 
2.18.4

