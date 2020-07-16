Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61DA9222163
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 13:29:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728332AbgGPL2B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 07:28:01 -0400
Received: from mga02.intel.com ([134.134.136.20]:52601 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728301AbgGPL15 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jul 2020 07:27:57 -0400
IronPort-SDR: zXOLfwsodUNoMPBV6+FbE37fA6NU2U7Fnkd61aiH+fWTUCvBKnj4tGzg7PrEGg8cSkRI5csTCe
 9gNrKI0HhDkg==
X-IronPort-AV: E=McAfee;i="6000,8403,9683"; a="137485061"
X-IronPort-AV: E=Sophos;i="5.75,359,1589266800"; 
   d="scan'208";a="137485061"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2020 04:27:56 -0700
IronPort-SDR: 5CYTLpDMdu4r0tYrvn+xGJes5rXL8XlAKMNj+dmsjZCFF0psOsA0e8rcpKyGFiobLR56ycykfP
 Bmrm2JSbRzKA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,359,1589266800"; 
   d="scan'208";a="460442850"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.192.131])
  by orsmga005.jf.intel.com with ESMTP; 16 Jul 2020 04:27:54 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     mst@redhat.com, alex.williamson@redhat.com, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, wanpengli@tencent.com,
        jasowang@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V2 4/6] vhost_vdpa: implement IRQ offloading in vhost_vdpa
Date:   Thu, 16 Jul 2020 19:23:47 +0800
Message-Id: <1594898629-18790-5-git-send-email-lingshan.zhu@intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1594898629-18790-1-git-send-email-lingshan.zhu@intel.com>
References: <1594898629-18790-1-git-send-email-lingshan.zhu@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch introduce a set of functions for setup/unsetup
and update irq offloading respectively by register/unregister
and re-register the irq_bypass_producer.

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
Suggested-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vhost/Kconfig |  1 +
 drivers/vhost/vdpa.c  | 48 ++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 49 insertions(+)

diff --git a/drivers/vhost/Kconfig b/drivers/vhost/Kconfig
index d3688c6..587fbae 100644
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
index 2fcc422..b9078d4 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -115,6 +115,43 @@ static irqreturn_t vhost_vdpa_config_cb(void *private)
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
+	irq_bypass_unregister_producer(&vq->call_ctx.producer);
+	vq->call_ctx.producer.token = vq->call_ctx.ctx;
+	irq_bypass_register_producer(&vq->call_ctx.producer);
+	spin_unlock(&vq->call_ctx.ctx_lock);
+}
+
 static void vhost_vdpa_reset(struct vhost_vdpa *v)
 {
 	struct vdpa_device *vdpa = v->vdpa;
@@ -332,6 +369,7 @@ static long vhost_vdpa_set_config_call(struct vhost_vdpa *v, u32 __user *argp)
 
 	return 0;
 }
+
 static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned int cmd,
 				   void __user *argp)
 {
@@ -390,6 +428,14 @@ static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned int cmd,
 			cb.private = NULL;
 		}
 		ops->set_vq_cb(vdpa, idx, &cb);
+		/*
+		 * if it has a non-zero irq, means there is a
+		 * previsouly registered irq_bypass_producer,
+		 * we should update it when ctx (its token)
+		 * changes.
+		 */
+		if (vq->call_ctx.producer.irq)
+			vhost_vdpa_update_vq_irq(vq);
 		break;
 
 	case VHOST_SET_VRING_NUM:
@@ -951,6 +997,8 @@ static void vhost_vdpa_remove(struct vdpa_device *vdpa)
 	},
 	.probe	= vhost_vdpa_probe,
 	.remove	= vhost_vdpa_remove,
+	.setup_vq_irq = vhost_vdpa_setup_vq_irq,
+	.unsetup_vq_irq = vhost_vdpa_unsetup_vq_irq,
 };
 
 static int __init vhost_vdpa_init(void)
-- 
1.8.3.1

