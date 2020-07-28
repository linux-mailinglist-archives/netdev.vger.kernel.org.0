Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B39702300C5
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 06:28:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726871AbgG1E2o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 00:28:44 -0400
Received: from mga05.intel.com ([192.55.52.43]:10281 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726854AbgG1E2o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 00:28:44 -0400
IronPort-SDR: 7HGj4vWYy+2TTnofkQULm4lUKFv/aJAnCC8AtTTlEJDPKTnzvFV0wfkzWVpQ3lhlwqIU/xjI6B
 eEyfNT8twB2g==
X-IronPort-AV: E=McAfee;i="6000,8403,9695"; a="236011099"
X-IronPort-AV: E=Sophos;i="5.75,405,1589266800"; 
   d="scan'208";a="236011099"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2020 21:28:42 -0700
IronPort-SDR: DQEtV0Uuq64u3nxApgGRC3gHaxgfOcfv1U8Lxs9a+syeYhReK2nEjzYiz0PrS2DJ82i03yLAaL
 M3XZUk/gWVQA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,405,1589266800"; 
   d="scan'208";a="290037317"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.192.131])
  by orsmga006.jf.intel.com with ESMTP; 27 Jul 2020 21:28:32 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, alex.williamson@redhat.com, mst@redhat.com,
        pbonzini@redhat.com, sean.j.christopherson@intel.com,
        wanpengli@tencent.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, eli@mellanox.com, shahafs@mellanox.com,
        parav@mellanox.com, Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V4 4/6] vhost_vdpa: implement IRQ offloading in vhost_vdpa
Date:   Tue, 28 Jul 2020 12:24:03 +0800
Message-Id: <20200728042405.17579-5-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.18.4
In-Reply-To: <20200728042405.17579-1-lingshan.zhu@intel.com>
References: <20200728042405.17579-1-lingshan.zhu@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch introduce a set of functions for setup/unsetup
and update irq offloading respectively by register/unregister
and re-register the irq_bypass_producer.

With these functions, this commit can setup/unsetup
irq offloading through setting DRIVER_OK/!DRIVER_OK, and
update irq offloading through SET_VRING_CALL.

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
Suggested-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vhost/Kconfig |  1 +
 drivers/vhost/vdpa.c  | 79 ++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 79 insertions(+), 1 deletion(-)

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
index df3cf386b0cd..1dccced321f8 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -115,6 +115,55 @@ static irqreturn_t vhost_vdpa_config_cb(void *private)
 	return IRQ_HANDLED;
 }
 
+static void vhost_vdpa_setup_vq_irq(struct vhost_vdpa *v, int qid)
+{
+	struct vhost_virtqueue *vq = &v->vqs[qid];
+	const struct vdpa_config_ops *ops = v->vdpa->config;
+	struct vdpa_device *vdpa = v->vdpa;
+	int ret, irq;
+
+	spin_lock(&vq->call_ctx.ctx_lock);
+	irq = ops->get_vq_irq(vdpa, qid);
+	if (!vq->call_ctx.ctx || irq == -EINVAL) {
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
+static void vhost_vdpa_unsetup_vq_irq(struct vhost_vdpa *v, int qid)
+{
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
@@ -155,11 +204,15 @@ static long vhost_vdpa_set_status(struct vhost_vdpa *v, u8 __user *statusp)
 {
 	struct vdpa_device *vdpa = v->vdpa;
 	const struct vdpa_config_ops *ops = vdpa->config;
-	u8 status;
+	u8 status, status_old;
+	int i, nvqs;
 
 	if (copy_from_user(&status, statusp, sizeof(status)))
 		return -EFAULT;
 
+	status_old = ops->get_status(vdpa);
+	nvqs = v->nvqs;
+
 	/*
 	 * Userspace shouldn't remove status bits unless reset the
 	 * status to 0.
@@ -167,6 +220,15 @@ static long vhost_vdpa_set_status(struct vhost_vdpa *v, u8 __user *statusp)
 	if (status != 0 && (ops->get_status(vdpa) & ~status) != 0)
 		return -EINVAL;
 
+	/* vq irq is not expected to be changed once DRIVER_OK is set */
+	if ((status & VIRTIO_CONFIG_S_DRIVER_OK) && !(status_old & VIRTIO_CONFIG_S_DRIVER_OK))
+		for (i = 0; i < nvqs; i++)
+			vhost_vdpa_setup_vq_irq(v, i);
+
+	if ((status_old & VIRTIO_CONFIG_S_DRIVER_OK) && !(status & VIRTIO_CONFIG_S_DRIVER_OK))
+		for (i = 0; i < nvqs; i++)
+			vhost_vdpa_unsetup_vq_irq(v, i);
+
 	ops->set_status(vdpa, status);
 
 	return 0;
@@ -332,6 +394,7 @@ static long vhost_vdpa_set_config_call(struct vhost_vdpa *v, u32 __user *argp)
 
 	return 0;
 }
+
 static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned int cmd,
 				   void __user *argp)
 {
@@ -390,6 +453,7 @@ static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned int cmd,
 			cb.private = NULL;
 		}
 		ops->set_vq_cb(vdpa, idx, &cb);
+		vhost_vdpa_update_vq_irq(vq);
 		break;
 
 	case VHOST_SET_VRING_NUM:
@@ -765,6 +829,18 @@ static int vhost_vdpa_open(struct inode *inode, struct file *filep)
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
@@ -777,6 +853,7 @@ static int vhost_vdpa_release(struct inode *inode, struct file *filep)
 	vhost_vdpa_iotlb_free(v);
 	vhost_vdpa_free_domain(v);
 	vhost_vdpa_config_put(v);
+	vhost_vdpa_clean_irq(v);
 	vhost_dev_cleanup(&v->vdev);
 	kfree(v->vdev.vqs);
 	mutex_unlock(&d->mutex);
-- 
2.18.4

