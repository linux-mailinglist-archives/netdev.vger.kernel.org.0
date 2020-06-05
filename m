Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 905A11EF565
	for <lists+netdev@lfdr.de>; Fri,  5 Jun 2020 12:31:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726678AbgFEKbM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jun 2020 06:31:12 -0400
Received: from mga18.intel.com ([134.134.136.126]:57119 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726683AbgFEKbI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Jun 2020 06:31:08 -0400
IronPort-SDR: 6M1SWJaT/0L2wSyyUwDQhacpoB2TIA9i9XD7T1NfAXfJX5HDzjB7qS8bnLiws7i5pvJ0kNUIwb
 izgaHz3YwH5g==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2020 03:31:08 -0700
IronPort-SDR: 9D/eu5/kTV9zPrMAKzBdAVqc09sqGRs4qTOpDW5uJWAstsuts9aslb8rZOngjQnKKmhYVyBTs0
 GSjKcFpyezTA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,476,1583222400"; 
   d="scan'208";a="305024947"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.192.131])
  by fmsmga002.fm.intel.com with ESMTP; 05 Jun 2020 03:31:05 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     mst@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        jasowang@redhat.com
Cc:     lulu@redhat.com, dan.daly@intel.com, cunming.liang@intel.com,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH RESEND 3/5] vhost_vdpa: Support config interrupt in vdpa
Date:   Fri,  5 Jun 2020 18:27:13 +0800
Message-Id: <1591352835-22441-4-git-send-email-lingshan.zhu@intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1591352835-22441-1-git-send-email-lingshan.zhu@intel.com>
References: <1591352835-22441-1-git-send-email-lingshan.zhu@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit implements config interrupt support in
vhost_vdpa layer.

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
Acked-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vhost/vdpa.c       | 47 ++++++++++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/vhost.h |  4 ++++
 2 files changed, 51 insertions(+)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 0968361..ffb41cf 100644
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
@@ -288,6 +301,36 @@ static long vhost_vdpa_get_vring_num(struct vhost_vdpa *v, u16 __user *argp)
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
+	int fd;
+	struct eventfd_ctx *ctx;
+
+	cb.callback = vhost_vdpa_config_cb;
+	cb.private = v->vdpa;
+	if (copy_from_user(&fd, argp, sizeof(fd)))
+		return  -EFAULT;
+
+	ctx = fd == VHOST_FILE_UNBIND ? NULL : eventfd_ctx_fdget(fd);
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
@@ -395,6 +438,9 @@ static long vhost_vdpa_unlocked_ioctl(struct file *filep,
 	case VHOST_SET_LOG_FD:
 		r = -ENOIOCTLCMD;
 		break;
+	case VHOST_VDPA_SET_CONFIG_CALL:
+		r = vhost_vdpa_set_config_call(v, argp);
+		break;
 	default:
 		r = vhost_dev_ioctl(&v->vdev, cmd, argp);
 		if (r == -ENOIOCTLCMD)
@@ -729,6 +775,7 @@ static int vhost_vdpa_release(struct inode *inode, struct file *filep)
 	vhost_dev_stop(&v->vdev);
 	vhost_vdpa_iotlb_free(v);
 	vhost_vdpa_free_domain(v);
+	vhost_vdpa_config_put(v);
 	vhost_dev_cleanup(&v->vdev);
 	kfree(v->vdev.vqs);
 	mutex_unlock(&d->mutex);
diff --git a/include/uapi/linux/vhost.h b/include/uapi/linux/vhost.h
index 9fe72e4..0c23496 100644
--- a/include/uapi/linux/vhost.h
+++ b/include/uapi/linux/vhost.h
@@ -15,6 +15,8 @@
 #include <linux/types.h>
 #include <linux/ioctl.h>
 
+#define VHOST_FILE_UNBIND -1
+
 /* ioctls */
 
 #define VHOST_VIRTIO 0xAF
@@ -140,4 +142,6 @@
 /* Get the max ring size. */
 #define VHOST_VDPA_GET_VRING_NUM	_IOR(VHOST_VIRTIO, 0x76, __u16)
 
+/* Set event fd for config interrupt*/
+#define VHOST_VDPA_SET_CONFIG_CALL	_IOW(VHOST_VIRTIO, 0x77, int)
 #endif
-- 
1.8.3.1

