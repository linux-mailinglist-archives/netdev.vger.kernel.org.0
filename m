Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8E10222162
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 13:29:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728293AbgGPL14 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 07:27:56 -0400
Received: from mga02.intel.com ([134.134.136.20]:52601 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728255AbgGPL1x (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jul 2020 07:27:53 -0400
IronPort-SDR: Y8xTAenvpDPnKWZ+mXuKokqpDAyFI9JoVm8orpMrl3+4juLTlhiSdxPVcyHXLaMOGIOsHzayec
 2IF3DEKlUXOA==
X-IronPort-AV: E=McAfee;i="6000,8403,9683"; a="137485055"
X-IronPort-AV: E=Sophos;i="5.75,359,1589266800"; 
   d="scan'208";a="137485055"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2020 04:27:52 -0700
IronPort-SDR: /A56/4sZCfkt0U+dN4M/rUFafwosIzu0HOztA8bu9D5+1fnZtQlENURjrL1jL/7hQeVYOSH6ia
 h5yPk0oNHGOA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,359,1589266800"; 
   d="scan'208";a="460442838"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.192.131])
  by orsmga005.jf.intel.com with ESMTP; 16 Jul 2020 04:27:50 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     mst@redhat.com, alex.williamson@redhat.com, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, wanpengli@tencent.com,
        jasowang@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V2 3/6] vDPA: implement IRQ offloading helpers in vDPA core
Date:   Thu, 16 Jul 2020 19:23:46 +0800
Message-Id: <1594898629-18790-4-git-send-email-lingshan.zhu@intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1594898629-18790-1-git-send-email-lingshan.zhu@intel.com>
References: <1594898629-18790-1-git-send-email-lingshan.zhu@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit implements IRQ offloading helpers in vDPA core by
introducing two couple of functions:

vdpa_alloc_vq_irq() and vdpa_free_vq_irq(): request irq and free
irq, will setup irq offloading.

vdpa_setup_irq() and vdpa_unsetup_irq(): supportive functions,
will call vhost_vdpa helpers.

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
Suggested-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vdpa/vdpa.c  | 42 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/vdpa.h | 13 +++++++++++++
 2 files changed, 55 insertions(+)

diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
index ff6562f..cce4d91 100644
--- a/drivers/vdpa/vdpa.c
+++ b/drivers/vdpa/vdpa.c
@@ -163,6 +163,48 @@ void vdpa_unregister_driver(struct vdpa_driver *drv)
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
+	if (drv->unsetup_vq_irq)
+		drv->unsetup_vq_irq(vdev, qid);
+}
+
+int vdpa_alloc_vq_irq(struct device *dev, struct vdpa_device *vdev,
+		      unsigned int irq, irq_handler_t handler,
+		      unsigned long irqflags, const char *devname, void *dev_id,
+		      int qid)
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
+EXPORT_SYMBOL_GPL(vdpa_alloc_vq_irq);
+
+void vdpa_free_vq_irq(struct device *dev, struct vdpa_device *vdev, int irq,
+			 int qid, void *dev_id)
+{
+	devm_free_irq(dev, irq, dev_id);
+	vdpa_unsetup_irq(vdev, qid);
+}
+EXPORT_SYMBOL_GPL(vdpa_free_vq_irq);
+
 static int vdpa_init(void)
 {
 	return bus_register(&vdpa_bus);
diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
index 239db79..7d64d83 100644
--- a/include/linux/vdpa.h
+++ b/include/linux/vdpa.h
@@ -220,17 +220,30 @@ struct vdpa_device *__vdpa_alloc_device(struct device *parent,
 
 int vdpa_register_device(struct vdpa_device *vdev);
 void vdpa_unregister_device(struct vdpa_device *vdev);
+/* request irq for a vq, setup irq offloading if its a vhost_vdpa vq */
+int vdpa_alloc_vq_irq(struct device *dev, struct vdpa_device *vdev,
+		      unsigned int irq, irq_handler_t handler,
+		      unsigned long irqflags, const char *devname, void *dev_id,
+		      int qid);
+/* free irq for a vq, unsetup irq offloading if its a vhost_vdpa vq */
+void vdpa_free_vq_irq(struct device *dev, struct vdpa_device *vdev, int irq,
+		      int qid, void *dev_id);
+
 
 /**
  * vdpa_driver - operations for a vDPA driver
  * @driver: underlying device driver
  * @probe: the function to call when a device is found.  Returns 0 or -errno.
  * @remove: the function to call when a device is removed.
+ * @setup_vq_irq: setup irq offloading for a vhost_vdpa vq.
+ * @unsetup_vq_irq: unsetup offloading for a vhost_vdpa vq.
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
1.8.3.1

