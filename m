Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A20061B7186
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 12:07:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726881AbgDXKHj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 06:07:39 -0400
Received: from mga03.intel.com ([134.134.136.65]:53054 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726820AbgDXKHi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Apr 2020 06:07:38 -0400
IronPort-SDR: 3QRZn8TxDp9DC5PVJ2C/qmUf99k0VN7+bG99WQ/7gtLo+6EEoR+K3E3q70LBhJ9Hg/lOrXNNCm
 Jqyk32fPdC/Q==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2020 03:07:37 -0700
IronPort-SDR: ZUC3A8b3zI0M/td+Xxx0JTIdbdiYd9Jibxh6unfcbZhZLr1F2OykoIohhNPg0q5Zccu27FFXkx
 VWKaScT2L59w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,311,1583222400"; 
   d="scan'208";a="280755918"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.193.79])
  by fmsmga004.fm.intel.com with ESMTP; 24 Apr 2020 03:07:35 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     mst@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        jasowang@redhat.com
Cc:     lulu@redhat.com, dan.daly@intel.com, cunming.liang@intel.com,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH 1/2] vdpa: Support config interrupt in vhost_vdpa
Date:   Fri, 24 Apr 2020 18:04:18 +0800
Message-Id: <1587722659-1300-2-git-send-email-lingshan.zhu@intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1587722659-1300-1-git-send-email-lingshan.zhu@intel.com>
References: <1587722659-1300-1-git-send-email-lingshan.zhu@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit implements config interrupt support in
vhost_vdpa layer.

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
---
 drivers/vhost/vdpa.c             | 53 ++++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/vhost.h       |  2 ++
 include/uapi/linux/vhost_types.h |  2 ++
 3 files changed, 57 insertions(+)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 421f02a..f1f69bf 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -21,6 +21,7 @@
 #include <linux/nospec.h>
 #include <linux/vhost.h>
 #include <linux/virtio_net.h>
+#include <linux/kernel.h>
 
 #include "vhost.h"
 
@@ -70,6 +71,7 @@ struct vhost_vdpa {
 	int nvqs;
 	int virtio_id;
 	int minor;
+	struct eventfd_ctx *config_ctx;
 };
 
 static DEFINE_IDA(vhost_vdpa_ida);
@@ -101,6 +103,17 @@ static irqreturn_t vhost_vdpa_virtqueue_cb(void *private)
 	return IRQ_HANDLED;
 }
 
+static irqreturn_t vhost_vdpa_config_cb(void *private)
+{
+	struct vhost_vdpa *v = private;
+	struct eventfd_ctx *config_ctx = v->config_ctx;
+
+	if (config_ctx)
+		eventfd_signal(config_ctx, 1);
+
+	return IRQ_HANDLED;
+}
+
 static void vhost_vdpa_reset(struct vhost_vdpa *v)
 {
 	struct vdpa_device *vdpa = v->vdpa;
@@ -288,6 +301,42 @@ static long vhost_vdpa_get_vring_num(struct vhost_vdpa *v, u16 __user *argp)
 	return 0;
 }
 
+static void vhost_vdpa_config_put(struct vhost_vdpa *v)
+{
+	if (v->config_ctx)
+		eventfd_ctx_put(v->config_ctx);
+}
+
+static long vhost_vdpa_set_config_call(struct vhost_vdpa *v, u32 __user *argp)
+{
+	struct vdpa_callback cb;
+	vhost_config_file file;
+	struct eventfd_ctx *ctx;
+
+	cb.callback = vhost_vdpa_config_cb;
+	cb.private = v->vdpa;
+	if (copy_from_user(&file, argp, sizeof(file)))
+		return  -EFAULT;
+
+	if (file.fd == -1) {
+		vhost_vdpa_config_put(v);
+		v->config_ctx = NULL;
+		return PTR_ERR(v->config_ctx);
+	}
+
+	ctx = eventfd_ctx_fdget(file.fd);
+	swap(ctx, v->config_ctx);
+
+	if (!IS_ERR_OR_NULL(ctx))
+		eventfd_ctx_put(ctx);
+
+	if (IS_ERR(v->config_ctx))
+		return PTR_ERR(v->config_ctx);
+
+	v->vdpa->config->set_config_cb(v->vdpa, &cb);
+
+	return 0;
+}
 static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned int cmd,
 				   void __user *argp)
 {
@@ -398,6 +447,9 @@ static long vhost_vdpa_unlocked_ioctl(struct file *filep,
 	case VHOST_SET_LOG_FD:
 		r = -ENOIOCTLCMD;
 		break;
+	case VHOST_VDPA_SET_CONFIG_CALL:
+		r = vhost_vdpa_set_config_call(v, argp);
+		break;
 	default:
 		r = vhost_dev_ioctl(&v->vdev, cmd, argp);
 		if (r == -ENOIOCTLCMD)
@@ -734,6 +786,7 @@ static int vhost_vdpa_release(struct inode *inode, struct file *filep)
 	vhost_dev_stop(&v->vdev);
 	vhost_vdpa_iotlb_free(v);
 	vhost_vdpa_free_domain(v);
+	vhost_vdpa_config_put(v);
 	vhost_dev_cleanup(&v->vdev);
 	kfree(v->vdev.vqs);
 	mutex_unlock(&d->mutex);
diff --git a/include/uapi/linux/vhost.h b/include/uapi/linux/vhost.h
index 9fe72e4..c474a35 100644
--- a/include/uapi/linux/vhost.h
+++ b/include/uapi/linux/vhost.h
@@ -140,4 +140,6 @@
 /* Get the max ring size. */
 #define VHOST_VDPA_GET_VRING_NUM	_IOR(VHOST_VIRTIO, 0x76, __u16)
 
+/* Set event fd for config interrupt*/
+#define VHOST_VDPA_SET_CONFIG_CALL	_IOW(VHOST_VIRTIO, 0x77, vhost_config_file)
 #endif
diff --git a/include/uapi/linux/vhost_types.h b/include/uapi/linux/vhost_types.h
index 669457c..6759aefb 100644
--- a/include/uapi/linux/vhost_types.h
+++ b/include/uapi/linux/vhost_types.h
@@ -27,6 +27,8 @@ struct vhost_vring_file {
 
 };
 
+typedef struct vhost_vring_file vhost_config_file;
+
 struct vhost_vring_addr {
 	unsigned int index;
 	/* Option flags. */
-- 
1.8.3.1

