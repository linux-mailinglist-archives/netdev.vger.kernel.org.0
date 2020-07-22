Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBD652295C6
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 12:14:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732023AbgGVKNT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 06:13:19 -0400
Received: from mga07.intel.com ([134.134.136.100]:37373 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731984AbgGVKNS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Jul 2020 06:13:18 -0400
IronPort-SDR: 0Slf7fJO93+SUbTRTEC1chO0KDwPjik5GNcjPm+CwQhpOH2bECV4zsinFtL5+DC3Wm4UMtvU1i
 oLNUEz/IUWJQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9689"; a="214940309"
X-IronPort-AV: E=Sophos;i="5.75,381,1589266800"; 
   d="scan'208";a="214940309"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2020 03:13:17 -0700
IronPort-SDR: KZqrhpzUpf1PwftpmqbDsanRhVQG9CPgTI91BoRSX5JZOLCu1+OVNtJOLS+nF0qRjn0jH2j+/O
 azmf6FEIizgQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,381,1589266800"; 
   d="scan'208";a="392634935"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.192.131])
  by fmsmga001.fm.intel.com with ESMTP; 22 Jul 2020 03:13:14 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, alex.williamson@redhat.com, mst@redhat.com,
        pbonzini@redhat.com, sean.j.christopherson@intel.com,
        wanpengli@tencent.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V3 4/6] vhost_vdpa: implement IRQ offloading in vhost_vdpa
Date:   Wed, 22 Jul 2020 18:08:57 +0800
Message-Id: <20200722100859.221669-5-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.18.4
In-Reply-To: <20200722100859.221669-1-lingshan.zhu@intel.com>
References: <20200722100859.221669-1-lingshan.zhu@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch introduce a set of functions for setup/unsetup
and update irq offloading respectively by register/unregister
and re-register the irq_bypass_producer.

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
---
 drivers/vhost/Kconfig |  1 +
 drivers/vhost/vdpa.c  | 66 ++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 66 insertions(+), 1 deletion(-)

diff --git a/drivers/vhost/Kconfig b/drivers/vhost/Kconfig
index d3688c6afb87..587fbae06182 100644
--- a/drivers/vhost/Kconfig
+++ b/drivers/vhost/Kconfig
@@ -65,6 +65,7 @@ config VHOST_VDPA
 	tristate "Vhost driver for vDPA-based backend"
 	depends on EVENTFD
 	select VHOST
+	select IRQ_BYPASS_MANAGER
 	depends on VDPA
 	help
 	  This kernel module can be loaded in host kernel to accelerate
diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index df3cf386b0cd..558cf0863126 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -115,6 +115,54 @@ static irqreturn_t vhost_vdpa_config_cb(void *private)
 	return IRQ_HANDLED;
 }
 
+static void vhost_vdpa_setup_vq_irq(struct vdpa_device *dev, int qid, int irq)
+{
+	struct vhost_vdpa *v = vdpa_get_drvdata(dev);
+	struct vhost_virtqueue *vq = &v->vqs[qid];
+	int ret;
+
+	spin_lock(&vq->call_ctx.ctx_lock);
+	if (!vq->call_ctx.ctx) {
+		spin_unlock(&vq->call_ctx.ctx_lock);
+		return;
+	}
+
+	vq->call_ctx.producer.token = vq->call_ctx.ctx;
+	vq->call_ctx.producer.irq = irq;
+	ret = irq_bypass_register_producer(&vq->call_ctx.producer);
+	spin_unlock(&vq->call_ctx.ctx_lock);
+}
+
+static void vhost_vdpa_unsetup_vq_irq(struct vdpa_device *dev, int qid)
+{
+	struct vhost_vdpa *v = vdpa_get_drvdata(dev);
+	struct vhost_virtqueue *vq = &v->vqs[qid];
+
+	spin_lock(&vq->call_ctx.ctx_lock);
+	irq_bypass_unregister_producer(&vq->call_ctx.producer);
+	spin_unlock(&vq->call_ctx.ctx_lock);
+}
+
+static void vhost_vdpa_update_vq_irq(struct vhost_virtqueue *vq)
+{
+	spin_lock(&vq->call_ctx.ctx_lock);
+	/*
+	 * if it has a non-zero irq, means there is a
+	 * previsouly registered irq_bypass_producer,
+	 * we should update it when ctx (its token)
+	 * changes.
+	 */
+	if (!vq->call_ctx.producer.irq) {
+		spin_unlock(&vq->call_ctx.ctx_lock);
+		return;
+	}
+
+	irq_bypass_unregister_producer(&vq->call_ctx.producer);
+	vq->call_ctx.producer.token = vq->call_ctx.ctx;
+	irq_bypass_register_producer(&vq->call_ctx.producer);
+	spin_unlock(&vq->call_ctx.ctx_lock);
+}
+
 static void vhost_vdpa_reset(struct vhost_vdpa *v)
 {
 	struct vdpa_device *vdpa = v->vdpa;
@@ -122,7 +170,6 @@ static void vhost_vdpa_reset(struct vhost_vdpa *v)
 
 	ops->set_status(vdpa, 0);
 }
-
 static long vhost_vdpa_get_device_id(struct vhost_vdpa *v, u8 __user *argp)
 {
 	struct vdpa_device *vdpa = v->vdpa;
@@ -332,6 +379,7 @@ static long vhost_vdpa_set_config_call(struct vhost_vdpa *v, u32 __user *argp)
 
 	return 0;
 }
+
 static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned int cmd,
 				   void __user *argp)
 {
@@ -390,6 +438,7 @@ static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned int cmd,
 			cb.private = NULL;
 		}
 		ops->set_vq_cb(vdpa, idx, &cb);
+		vhost_vdpa_update_vq_irq(vq);
 		break;
 
 	case VHOST_SET_VRING_NUM:
@@ -765,6 +814,18 @@ static int vhost_vdpa_open(struct inode *inode, struct file *filep)
 	return r;
 }
 
+static void vhost_vdpa_clean_irq(struct vhost_vdpa *v)
+{
+	struct vhost_virtqueue *vq;
+	int i;
+
+	for (i = 0; i < v->nvqs; i++) {
+		vq = &v->vqs[i];
+		if (vq->call_ctx.producer.irq)
+			irq_bypass_unregister_producer(&vq->call_ctx.producer);
+	}
+}
+
 static int vhost_vdpa_release(struct inode *inode, struct file *filep)
 {
 	struct vhost_vdpa *v = filep->private_data;
@@ -777,6 +838,7 @@ static int vhost_vdpa_release(struct inode *inode, struct file *filep)
 	vhost_vdpa_iotlb_free(v);
 	vhost_vdpa_free_domain(v);
 	vhost_vdpa_config_put(v);
+	vhost_vdpa_clean_irq(v);
 	vhost_dev_cleanup(&v->vdev);
 	kfree(v->vdev.vqs);
 	mutex_unlock(&d->mutex);
@@ -951,6 +1013,8 @@ static struct vdpa_driver vhost_vdpa_driver = {
 	},
 	.probe	= vhost_vdpa_probe,
 	.remove	= vhost_vdpa_remove,
+	.setup_vq_irq = vhost_vdpa_setup_vq_irq,
+	.unsetup_vq_irq = vhost_vdpa_unsetup_vq_irq,
 };
 
 static int __init vhost_vdpa_init(void)
-- 
2.18.4

