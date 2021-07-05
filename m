Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C18BB3BB7AA
	for <lists+netdev@lfdr.de>; Mon,  5 Jul 2021 09:19:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229978AbhGEHWD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Jul 2021 03:22:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41162 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229925AbhGEHWC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Jul 2021 03:22:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625469566;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=vAxaFW9a7xpmG8B2uRDAj3X/DHOBu21mlVjLtanDQ7M=;
        b=UbG5KCYuHSXiXBGSwB3RLgfJ5+v/uupXdPlfLXdh+U3S+vagpZNzT10/0rUa1clYTiazH1
        qESzOP584r+SLgQaWqu0YbPKeHnrlUw1IBZKoLiLIVtCnC3qOfcArDugmlztzhAOkCjPnl
        ofJoARXbIgeHBAetk2Jqk3Q4NAAqK08=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-237-9nB3Jf5cMJyCjT3G0w6Ckg-1; Mon, 05 Jul 2021 03:19:24 -0400
X-MC-Unique: 9nB3Jf5cMJyCjT3G0w6Ckg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 68C0D801B0F;
        Mon,  5 Jul 2021 07:19:23 +0000 (UTC)
Received: from localhost.localdomain (ovpn-13-21.pek2.redhat.com [10.72.13.21])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B0B785D9DC;
        Mon,  5 Jul 2021 07:19:13 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     mst@redhat.com, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     netdev@vger.kernel.org, xieyongji@bytedance.com,
        stefanha@redhat.com
Subject: [PATCH 1/2] vdpa: support per virtqueue max queue size
Date:   Mon,  5 Jul 2021 15:19:09 +0800
Message-Id: <20210705071910.31965-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Virtio spec allows the device to specify the per virtqueue max queue
size. vDPA needs to adapt to this flexibility. E.g Qemu advertise a
small control virtqueue for virtio-net.

So this patch adds a index parameter to get_vq_num_max bus operations
for the device to report its per virtqueue max queue size.

Both VHOST_VDPA_GET_VRING_NUM and VDPA_ATTR_DEV_MAX_VQ_SIZE assume a
global maximum size. So we iterate all the virtqueues to return the
minimal size in this case. Actually, the VHOST_VDPA_GET_VRING_NUM is
not a must for the userspace. Userspace may choose to check the
VHOST_SET_VRING_NUM for proving or validating the maximum virtqueue
size. Anyway, we can invent a per vq version of
VHOST_VDPA_GET_VRING_NUM in the future if it's necessary.

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vdpa/ifcvf/ifcvf_main.c   |  2 +-
 drivers/vdpa/mlx5/net/mlx5_vnet.c |  2 +-
 drivers/vdpa/vdpa.c               | 22 +++++++++++++++++++++-
 drivers/vdpa/vdpa_sim/vdpa_sim.c  |  2 +-
 drivers/vdpa/virtio_pci/vp_vdpa.c |  2 +-
 drivers/vhost/vdpa.c              |  9 ++++++---
 drivers/virtio/virtio_vdpa.c      |  2 +-
 include/linux/vdpa.h              |  5 ++++-
 8 files changed, 36 insertions(+), 10 deletions(-)

diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
index ab0ab5cf0f6e..646b340db2af 100644
--- a/drivers/vdpa/ifcvf/ifcvf_main.c
+++ b/drivers/vdpa/ifcvf/ifcvf_main.c
@@ -254,7 +254,7 @@ static void ifcvf_vdpa_set_status(struct vdpa_device *vdpa_dev, u8 status)
 	ifcvf_set_status(vf, status);
 }
 
-static u16 ifcvf_vdpa_get_vq_num_max(struct vdpa_device *vdpa_dev)
+static u16 ifcvf_vdpa_get_vq_num_max(struct vdpa_device *vdpa_dev, u16 qid)
 {
 	return IFCVF_QUEUE_MAX;
 }
diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index dda5dc6f7737..afd6114d07b0 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -1584,7 +1584,7 @@ static void mlx5_vdpa_set_config_cb(struct vdpa_device *vdev, struct vdpa_callba
 }
 
 #define MLX5_VDPA_MAX_VQ_ENTRIES 256
-static u16 mlx5_vdpa_get_vq_num_max(struct vdpa_device *vdev)
+static u16 mlx5_vdpa_get_vq_num_max(struct vdpa_device *vdev, u16 idx)
 {
 	return MLX5_VDPA_MAX_VQ_ENTRIES;
 }
diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
index bb3f1d1f0422..d77d59811389 100644
--- a/drivers/vdpa/vdpa.c
+++ b/drivers/vdpa/vdpa.c
@@ -239,6 +239,26 @@ void vdpa_unregister_driver(struct vdpa_driver *drv)
 }
 EXPORT_SYMBOL_GPL(vdpa_unregister_driver);
 
+/**
+ * vdpa_get_vq_num_max - get the maximum virtqueue size
+ * @vdev: vdpa device
+ */
+u16 vdpa_get_vq_num_max(struct vdpa_device *vdev)
+{
+	const struct vdpa_config_ops *ops = vdev->config;
+	u16 s, size = ops->get_vq_num_max(vdev, 0);
+	int i;
+
+	for (i = 1; i < vdev->nvqs; i++) {
+		s = ops->get_vq_num_max(vdev, i);
+		if (s && s < size)
+			size = s;
+	}
+
+	return size;
+}
+EXPORT_SYMBOL_GPL(vdpa_get_vq_num_max);
+
 /**
  * vdpa_mgmtdev_register - register a vdpa management device
  *
@@ -502,7 +522,7 @@ vdpa_dev_fill(struct vdpa_device *vdev, struct sk_buff *msg, u32 portid, u32 seq
 
 	device_id = vdev->config->get_device_id(vdev);
 	vendor_id = vdev->config->get_vendor_id(vdev);
-	max_vq_size = vdev->config->get_vq_num_max(vdev);
+	max_vq_size = vdpa_get_vq_num_max(vdev);
 
 	err = -EMSGSIZE;
 	if (nla_put_string(msg, VDPA_ATTR_DEV_NAME, dev_name(&vdev->dev)))
diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vdpa_sim.c
index 98f793bc9376..49e29056f164 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
@@ -422,7 +422,7 @@ static void vdpasim_set_config_cb(struct vdpa_device *vdpa,
 	/* We don't support config interrupt */
 }
 
-static u16 vdpasim_get_vq_num_max(struct vdpa_device *vdpa)
+static u16 vdpasim_get_vq_num_max(struct vdpa_device *vdpa, u16 idx)
 {
 	return VDPASIM_QUEUE_MAX;
 }
diff --git a/drivers/vdpa/virtio_pci/vp_vdpa.c b/drivers/vdpa/virtio_pci/vp_vdpa.c
index c76ebb531212..2926641fb586 100644
--- a/drivers/vdpa/virtio_pci/vp_vdpa.c
+++ b/drivers/vdpa/virtio_pci/vp_vdpa.c
@@ -195,7 +195,7 @@ static void vp_vdpa_set_status(struct vdpa_device *vdpa, u8 status)
 		vp_vdpa_free_irq(vp_vdpa);
 }
 
-static u16 vp_vdpa_get_vq_num_max(struct vdpa_device *vdpa)
+static u16 vp_vdpa_get_vq_num_max(struct vdpa_device *vdpa, u16 qid)
 {
 	return VP_VDPA_QUEUE_MAX;
 }
diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index fb41db3da611..c9ec395b8c42 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -289,11 +289,14 @@ static long vhost_vdpa_set_features(struct vhost_vdpa *v, u64 __user *featurep)
 
 static long vhost_vdpa_get_vring_num(struct vhost_vdpa *v, u16 __user *argp)
 {
-	struct vdpa_device *vdpa = v->vdpa;
-	const struct vdpa_config_ops *ops = vdpa->config;
 	u16 num;
 
-	num = ops->get_vq_num_max(vdpa);
+	/*
+	 * VHOST_VDPA_GET_VRING_NUM asssumes a global max virtqueue
+	 * size. So we need to iterate all the virtqueue and return
+	 * the minimal one here.
+	 */
+	num = vdpa_get_vq_num_max(v->vdpa);
 
 	if (copy_to_user(argp, &num, sizeof(num)))
 		return -EFAULT;
diff --git a/drivers/virtio/virtio_vdpa.c b/drivers/virtio/virtio_vdpa.c
index e28acf482e0c..a43bd5ec5ac6 100644
--- a/drivers/virtio/virtio_vdpa.c
+++ b/drivers/virtio/virtio_vdpa.c
@@ -158,7 +158,7 @@ virtio_vdpa_setup_vq(struct virtio_device *vdev, unsigned int index,
 	if (!info)
 		return ERR_PTR(-ENOMEM);
 
-	num = ops->get_vq_num_max(vdpa);
+	num = ops->get_vq_num_max(vdpa, index);
 	if (num == 0) {
 		err = -ENOENT;
 		goto error_new_virtqueue;
diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
index f311d227aa1b..0f8977a54783 100644
--- a/include/linux/vdpa.h
+++ b/include/linux/vdpa.h
@@ -137,6 +137,7 @@ struct vdpa_iova_range {
  *				@cb: virtio-vdev interrupt callback structure
  * @get_vq_num_max:		Get the max size of virtqueue
  *				@vdev: vdpa device
+ *				@idx: virtqueue index
  *				Returns u16: max size of virtqueue
  * @get_device_id:		Get virtio device id
  *				@vdev: vdpa device
@@ -229,7 +230,7 @@ struct vdpa_config_ops {
 	int (*set_features)(struct vdpa_device *vdev, u64 features);
 	void (*set_config_cb)(struct vdpa_device *vdev,
 			      struct vdpa_callback *cb);
-	u16 (*get_vq_num_max)(struct vdpa_device *vdev);
+	u16 (*get_vq_num_max)(struct vdpa_device *vdev, u16 idx);
 	u32 (*get_device_id)(struct vdpa_device *vdev);
 	u32 (*get_vendor_id)(struct vdpa_device *vdev);
 	u8 (*get_status)(struct vdpa_device *vdev);
@@ -270,6 +271,8 @@ void vdpa_unregister_device(struct vdpa_device *vdev);
 int _vdpa_register_device(struct vdpa_device *vdev, int nvqs);
 void _vdpa_unregister_device(struct vdpa_device *vdev);
 
+u16 vdpa_get_vq_num_max(struct vdpa_device *vdev);
+
 /**
  * struct vdpa_driver - operations for a vDPA driver
  * @driver: underlying device driver
-- 
2.25.1

