Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FAEB382911
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 11:58:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236388AbhEQJ7S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 05:59:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236440AbhEQJ6p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 05:58:45 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E712DC06137D
        for <netdev@vger.kernel.org>; Mon, 17 May 2021 02:56:41 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id z4so648090plg.8
        for <netdev@vger.kernel.org>; Mon, 17 May 2021 02:56:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uvQCM34udD9y/BEMyK2IUMPFWxihVXap3X5rClX92zw=;
        b=m3ZJirVbYxOFq58UP6NVretKxNu2fW5w5HNYkOP+1MFixrArSrVrA2RUFxFEIlmepk
         KejC4zinwBG76DuM+CSJXc+pYAknTAAUx2VEiKoGiU1S3yot/Le3d2OIMUp47kZzonu9
         +gY9463WjphFYg6MS2QHRUH9iM+kiYglvAFgKAaDTpswIGVlcHqj1zXFCjY5OJk8DauX
         mg/yN0Xsc++olfMF3r5w3pI58zYKaxM/MiCDl1yhq9dLzBKjEeGkIIaCdtNtiSO2au2L
         mE/tSoCqHnEb4+sDL1kwIumxk5ckFR7a3Qwpk7Ss8fLbgY7bxidrccDsJ02atgVAXAww
         w4Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uvQCM34udD9y/BEMyK2IUMPFWxihVXap3X5rClX92zw=;
        b=hKvIpJQ/RjjZhH8sQE/U+2QYUiVj/Puf2SrPjzmEQsPtrdwK08DKZ5lgf1DI/SB2yR
         unFjOEpRSNN5KyQHQYlmHNXFKjRgjaXJBSvqmU/7Mze6Z5ErKuuN7sEkREGyWh82Jwij
         Ar+dNT6nYd2vT6EQ5sjP/R1dYwMJgS5ZLy4vIHR67eNFhqXH6f8jGW1EFRcIndpQKiJ7
         +0+xN2VGWLrZybH6XYHM82dGf/s2Sn5jUITQBdowSS78sy/4mn3bgcusBB8l3M8uhm2e
         V1YkfmfMY38fIyUEjfEJdxKbw1dpX7PuiKt9vXZF0i4AK4efs51SDJTIxB9LLzyRgjzQ
         EDgg==
X-Gm-Message-State: AOAM5330YSOoB/MiZAPSrAzaokgdUH3Pv7OTAGV1zoXWzOkLXDG3dOZI
        FBQmBYAfGlX+TwqUMW1locdg
X-Google-Smtp-Source: ABdhPJxrmztcgoOH36BKALLyLrLW2mTxhzyapG5fIplPuW0SZ+m9OizErfR3MLHSLcJT5389ltMtBA==
X-Received: by 2002:a17:902:7c0d:b029:ed:61b5:337a with SMTP id x13-20020a1709027c0db02900ed61b5337amr59313380pll.20.1621245401245;
        Mon, 17 May 2021 02:56:41 -0700 (PDT)
Received: from localhost ([139.177.225.253])
        by smtp.gmail.com with ESMTPSA id g21sm9959032pfh.81.2021.05.17.02.56.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 May 2021 02:56:40 -0700 (PDT)
From:   Xie Yongji <xieyongji@bytedance.com>
To:     mst@redhat.com, jasowang@redhat.com, stefanha@redhat.com,
        sgarzare@redhat.com, parav@nvidia.com, hch@infradead.org,
        christian.brauner@canonical.com, rdunlap@infradead.org,
        willy@infradead.org, viro@zeniv.linux.org.uk, axboe@kernel.dk,
        bcrl@kvack.org, corbet@lwn.net, mika.penttila@nextfour.com,
        dan.carpenter@oracle.com, joro@8bytes.org
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH v7 11/12] vduse: Introduce VDUSE - vDPA Device in Userspace
Date:   Mon, 17 May 2021 17:55:12 +0800
Message-Id: <20210517095513.850-12-xieyongji@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210517095513.850-1-xieyongji@bytedance.com>
References: <20210517095513.850-1-xieyongji@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This VDUSE driver enables implementing vDPA devices in userspace.
Both control path and data path of vDPA devices will be able to
be handled in userspace.

In the control path, the VDUSE driver will make use of message
mechnism to forward the config operation from vdpa bus driver
to userspace. Userspace can use read()/write() to receive/reply
those control messages.

In the data path, VDUSE_IOTLB_GET_FD ioctl will be used to get
the file descriptors referring to vDPA device's iova regions. Then
userspace can use mmap() to access those iova regions. Besides,
userspace can use ioctl() to inject interrupt and use the eventfd
mechanism to receive virtqueue kicks.

Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
---
 Documentation/userspace-api/ioctl/ioctl-number.rst |    1 +
 drivers/vdpa/Kconfig                               |   10 +
 drivers/vdpa/Makefile                              |    1 +
 drivers/vdpa/vdpa_user/Makefile                    |    5 +
 drivers/vdpa/vdpa_user/vduse_dev.c                 | 1453 ++++++++++++++++++++
 include/uapi/linux/vduse.h                         |  178 +++
 6 files changed, 1648 insertions(+)
 create mode 100644 drivers/vdpa/vdpa_user/Makefile
 create mode 100644 drivers/vdpa/vdpa_user/vduse_dev.c
 create mode 100644 include/uapi/linux/vduse.h

diff --git a/Documentation/userspace-api/ioctl/ioctl-number.rst b/Documentation/userspace-api/ioctl/ioctl-number.rst
index 599bd4493944..db44cdabed35 100644
--- a/Documentation/userspace-api/ioctl/ioctl-number.rst
+++ b/Documentation/userspace-api/ioctl/ioctl-number.rst
@@ -300,6 +300,7 @@ Code  Seq#    Include File                                           Comments
 'z'   10-4F  drivers/s390/crypto/zcrypt_api.h                        conflict!
 '|'   00-7F  linux/media.h
 0x80  00-1F  linux/fb.h
+0x81  00-1F  linux/vduse.h
 0x89  00-06  arch/x86/include/asm/sockios.h
 0x89  0B-DF  linux/sockios.h
 0x89  E0-EF  linux/sockios.h                                         SIOCPROTOPRIVATE range
diff --git a/drivers/vdpa/Kconfig b/drivers/vdpa/Kconfig
index a503c1b2bfd9..6e23bce6433a 100644
--- a/drivers/vdpa/Kconfig
+++ b/drivers/vdpa/Kconfig
@@ -33,6 +33,16 @@ config VDPA_SIM_BLOCK
 	  vDPA block device simulator which terminates IO request in a
 	  memory buffer.
 
+config VDPA_USER
+	tristate "VDUSE (vDPA Device in Userspace) support"
+	depends on EVENTFD && MMU && HAS_DMA
+	select DMA_OPS
+	select VHOST_IOTLB
+	select IOMMU_IOVA
+	help
+	  With VDUSE it is possible to emulate a vDPA Device
+	  in a userspace program.
+
 config IFCVF
 	tristate "Intel IFC VF vDPA driver"
 	depends on PCI_MSI
diff --git a/drivers/vdpa/Makefile b/drivers/vdpa/Makefile
index 67fe7f3d6943..f02ebed33f19 100644
--- a/drivers/vdpa/Makefile
+++ b/drivers/vdpa/Makefile
@@ -1,6 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 obj-$(CONFIG_VDPA) += vdpa.o
 obj-$(CONFIG_VDPA_SIM) += vdpa_sim/
+obj-$(CONFIG_VDPA_USER) += vdpa_user/
 obj-$(CONFIG_IFCVF)    += ifcvf/
 obj-$(CONFIG_MLX5_VDPA) += mlx5/
 obj-$(CONFIG_VP_VDPA)    += virtio_pci/
diff --git a/drivers/vdpa/vdpa_user/Makefile b/drivers/vdpa/vdpa_user/Makefile
new file mode 100644
index 000000000000..260e0b26af99
--- /dev/null
+++ b/drivers/vdpa/vdpa_user/Makefile
@@ -0,0 +1,5 @@
+# SPDX-License-Identifier: GPL-2.0
+
+vduse-y := vduse_dev.o iova_domain.o
+
+obj-$(CONFIG_VDPA_USER) += vduse.o
diff --git a/drivers/vdpa/vdpa_user/vduse_dev.c b/drivers/vdpa/vdpa_user/vduse_dev.c
new file mode 100644
index 000000000000..9ac4cf100ccd
--- /dev/null
+++ b/drivers/vdpa/vdpa_user/vduse_dev.c
@@ -0,0 +1,1453 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * VDUSE: vDPA Device in Userspace
+ *
+ * Copyright (C) 2020-2021 Bytedance Inc. and/or its affiliates. All rights reserved.
+ *
+ * Author: Xie Yongji <xieyongji@bytedance.com>
+ *
+ */
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/miscdevice.h>
+#include <linux/cdev.h>
+#include <linux/device.h>
+#include <linux/eventfd.h>
+#include <linux/slab.h>
+#include <linux/wait.h>
+#include <linux/dma-map-ops.h>
+#include <linux/poll.h>
+#include <linux/file.h>
+#include <linux/uio.h>
+#include <linux/vdpa.h>
+#include <linux/nospec.h>
+#include <uapi/linux/vduse.h>
+#include <uapi/linux/vdpa.h>
+#include <uapi/linux/virtio_config.h>
+#include <uapi/linux/virtio_ids.h>
+#include <linux/mod_devicetable.h>
+
+#include "iova_domain.h"
+
+#define DRV_VERSION  "1.0"
+#define DRV_AUTHOR   "Yongji Xie <xieyongji@bytedance.com>"
+#define DRV_DESC     "vDPA Device in Userspace"
+#define DRV_LICENSE  "GPL v2"
+
+#define VDUSE_DEV_MAX (1U << MINORBITS)
+
+struct vduse_virtqueue {
+	u16 index;
+	bool ready;
+	spinlock_t kick_lock;
+	spinlock_t irq_lock;
+	struct eventfd_ctx *kickfd;
+	struct vdpa_callback cb;
+	struct work_struct inject;
+};
+
+struct vduse_dev;
+
+struct vduse_vdpa {
+	struct vdpa_device vdpa;
+	struct vduse_dev *dev;
+};
+
+struct vduse_dev {
+	struct vduse_vdpa *vdev;
+	struct device dev;
+	struct cdev cdev;
+	struct vduse_virtqueue *vqs;
+	struct vduse_iova_domain *domain;
+	char *name;
+	struct mutex lock;
+	spinlock_t msg_lock;
+	atomic64_t msg_unique;
+	wait_queue_head_t waitq;
+	struct list_head send_list;
+	struct list_head recv_list;
+	struct list_head list;
+	struct vdpa_callback config_cb;
+	struct work_struct inject;
+	spinlock_t irq_lock;
+	unsigned long api_version;
+	bool connected;
+	int minor;
+	u16 vq_size_max;
+	u32 vq_num;
+	u32 vq_align;
+	u32 config_size;
+	u32 device_id;
+	u32 vendor_id;
+};
+
+struct vduse_dev_msg {
+	struct vduse_dev_request req;
+	struct vduse_dev_response resp;
+	struct list_head list;
+	wait_queue_head_t waitq;
+	bool completed;
+};
+
+struct vduse_control {
+	unsigned long api_version;
+};
+
+static unsigned long max_bounce_size = (64 * 1024 * 1024);
+module_param(max_bounce_size, ulong, 0444);
+MODULE_PARM_DESC(max_bounce_size, "Maximum bounce buffer size. (default: 64M)");
+
+static unsigned long max_iova_size = (128 * 1024 * 1024);
+module_param(max_iova_size, ulong, 0444);
+MODULE_PARM_DESC(max_iova_size, "Maximum iova space size (default: 128M)");
+
+static bool allow_unsafe_device_emulation;
+module_param(allow_unsafe_device_emulation, bool, 0444);
+MODULE_PARM_DESC(allow_unsafe_device_emulation, "Allow emulating unsafe device."
+	" We must make sure the userspace device emulation process is trusted."
+	" Otherwise, don't enable this option. (default: false)");
+
+static DEFINE_MUTEX(vduse_lock);
+static LIST_HEAD(vduse_devs);
+static DEFINE_IDA(vduse_ida);
+
+static dev_t vduse_major;
+static struct class *vduse_class;
+static struct workqueue_struct *vduse_irq_wq;
+
+static unsigned int allowed_device_id[] = {
+	VIRTIO_ID_NET, VIRTIO_ID_BLOCK,
+	VIRTIO_ID_SCSI, VIRTIO_ID_FS,
+};
+
+static inline struct vduse_dev *vdpa_to_vduse(struct vdpa_device *vdpa)
+{
+	struct vduse_vdpa *vdev = container_of(vdpa, struct vduse_vdpa, vdpa);
+
+	return vdev->dev;
+}
+
+static inline struct vduse_dev *dev_to_vduse(struct device *dev)
+{
+	struct vdpa_device *vdpa = dev_to_vdpa(dev);
+
+	return vdpa_to_vduse(vdpa);
+}
+
+static struct vduse_dev_msg *vduse_find_msg(struct list_head *head,
+					    uint32_t request_id)
+{
+	struct vduse_dev_msg *tmp, *msg = NULL;
+
+	list_for_each_entry(tmp, head, list) {
+		if (tmp->req.request_id == request_id) {
+			msg = tmp;
+			list_del(&tmp->list);
+			break;
+		}
+	}
+
+	return msg;
+}
+
+static struct vduse_dev_msg *vduse_dequeue_msg(struct list_head *head)
+{
+	struct vduse_dev_msg *msg = NULL;
+
+	if (!list_empty(head)) {
+		msg = list_first_entry(head, struct vduse_dev_msg, list);
+		list_del(&msg->list);
+	}
+
+	return msg;
+}
+
+static void vduse_enqueue_msg(struct list_head *head,
+			      struct vduse_dev_msg *msg)
+{
+	list_add_tail(&msg->list, head);
+}
+
+static int vduse_dev_msg_sync(struct vduse_dev *dev,
+			      struct vduse_dev_msg *msg)
+{
+	init_waitqueue_head(&msg->waitq);
+	spin_lock(&dev->msg_lock);
+	vduse_enqueue_msg(&dev->send_list, msg);
+	wake_up(&dev->waitq);
+	spin_unlock(&dev->msg_lock);
+	wait_event_killable(msg->waitq, msg->completed);
+	spin_lock(&dev->msg_lock);
+	if (!msg->completed) {
+		list_del(&msg->list);
+		msg->resp.result = VDUSE_REQUEST_FAILED;
+	}
+	spin_unlock(&dev->msg_lock);
+
+	return (msg->resp.result == VDUSE_REQUEST_OK) ? 0 : -1;
+}
+
+static u32 vduse_dev_get_request_id(struct vduse_dev *dev)
+{
+	return atomic64_fetch_inc(&dev->msg_unique);
+}
+
+static u64 vduse_dev_get_features(struct vduse_dev *dev)
+{
+	struct vduse_dev_msg msg = { 0 };
+
+	msg.req.type = VDUSE_GET_FEATURES;
+	msg.req.request_id = vduse_dev_get_request_id(dev);
+
+	if (WARN_ON(vduse_dev_msg_sync(dev, &msg) != 0))
+		return 0;
+
+	return msg.resp.f.features;
+}
+
+static int vduse_dev_set_features(struct vduse_dev *dev, u64 features)
+{
+	struct vduse_dev_msg msg = { 0 };
+
+	msg.req.type = VDUSE_SET_FEATURES;
+	msg.req.request_id = vduse_dev_get_request_id(dev);
+	msg.req.f.features = features;
+
+	return vduse_dev_msg_sync(dev, &msg);
+}
+
+static u8 vduse_dev_get_status(struct vduse_dev *dev)
+{
+	struct vduse_dev_msg msg = { 0 };
+
+	msg.req.type = VDUSE_GET_STATUS;
+	msg.req.request_id = vduse_dev_get_request_id(dev);
+
+	if (WARN_ON(vduse_dev_msg_sync(dev, &msg) != 0))
+		return 0;
+
+	return msg.resp.s.status;
+}
+
+static void vduse_dev_set_status(struct vduse_dev *dev, u8 status)
+{
+	struct vduse_dev_msg msg = { 0 };
+
+	msg.req.type = VDUSE_SET_STATUS;
+	msg.req.request_id = vduse_dev_get_request_id(dev);
+	msg.req.s.status = status;
+
+	WARN_ON(vduse_dev_msg_sync(dev, &msg) != 0);
+}
+
+static void vduse_dev_get_config(struct vduse_dev *dev, unsigned int offset,
+				 void *buf, unsigned int len)
+{
+	struct vduse_dev_msg msg = { 0 };
+	unsigned int sz;
+
+	while (len) {
+		sz = min_t(unsigned int, len, sizeof(msg.req.config.data));
+		msg.req.type = VDUSE_GET_CONFIG;
+		msg.req.request_id = vduse_dev_get_request_id(dev);
+		msg.req.config.offset = offset;
+		msg.req.config.len = sz;
+		if (WARN_ON(vduse_dev_msg_sync(dev, &msg) != 0))
+			break;
+
+		memcpy(buf, msg.resp.config.data, sz);
+		buf += sz;
+		offset += sz;
+		len -= sz;
+	}
+}
+
+static void vduse_dev_set_config(struct vduse_dev *dev, unsigned int offset,
+				 const void *buf, unsigned int len)
+{
+	struct vduse_dev_msg msg = { 0 };
+	unsigned int sz;
+
+	while (len) {
+		sz = min_t(unsigned int, len, sizeof(msg.req.config.data));
+		msg.req.type = VDUSE_SET_CONFIG;
+		msg.req.request_id = vduse_dev_get_request_id(dev);
+		msg.req.config.offset = offset;
+		msg.req.config.len = sz;
+		memcpy(msg.req.config.data, buf, sz);
+		if (WARN_ON(vduse_dev_msg_sync(dev, &msg) != 0))
+			break;
+
+		buf += sz;
+		offset += sz;
+		len -= sz;
+	}
+}
+
+static void vduse_dev_set_vq_num(struct vduse_dev *dev,
+				 struct vduse_virtqueue *vq, u32 num)
+{
+	struct vduse_dev_msg msg = { 0 };
+
+	msg.req.type = VDUSE_SET_VQ_NUM;
+	msg.req.request_id = vduse_dev_get_request_id(dev);
+	msg.req.vq_num.index = vq->index;
+	msg.req.vq_num.num = num;
+
+	WARN_ON(vduse_dev_msg_sync(dev, &msg) != 0);
+}
+
+static int vduse_dev_set_vq_addr(struct vduse_dev *dev,
+				 struct vduse_virtqueue *vq, u64 desc_addr,
+				 u64 driver_addr, u64 device_addr)
+{
+	struct vduse_dev_msg msg = { 0 };
+
+	msg.req.type = VDUSE_SET_VQ_ADDR;
+	msg.req.request_id = vduse_dev_get_request_id(dev);
+	msg.req.vq_addr.index = vq->index;
+	msg.req.vq_addr.desc_addr = desc_addr;
+	msg.req.vq_addr.driver_addr = driver_addr;
+	msg.req.vq_addr.device_addr = device_addr;
+
+	return vduse_dev_msg_sync(dev, &msg);
+}
+
+static void vduse_dev_set_vq_ready(struct vduse_dev *dev,
+				struct vduse_virtqueue *vq, bool ready)
+{
+	struct vduse_dev_msg msg = { 0 };
+
+	msg.req.type = VDUSE_SET_VQ_READY;
+	msg.req.request_id = vduse_dev_get_request_id(dev);
+	msg.req.vq_ready.index = vq->index;
+	msg.req.vq_ready.ready = ready;
+
+	WARN_ON(vduse_dev_msg_sync(dev, &msg) != 0);
+}
+
+static bool vduse_dev_get_vq_ready(struct vduse_dev *dev,
+				   struct vduse_virtqueue *vq)
+{
+	struct vduse_dev_msg msg = { 0 };
+
+	msg.req.type = VDUSE_GET_VQ_READY;
+	msg.req.request_id = vduse_dev_get_request_id(dev);
+	msg.req.vq_ready.index = vq->index;
+	if (WARN_ON(vduse_dev_msg_sync(dev, &msg)))
+		return false;
+
+	return msg.resp.vq_ready.ready;
+}
+
+static int vduse_dev_get_vq_state(struct vduse_dev *dev,
+				struct vduse_virtqueue *vq,
+				struct vdpa_vq_state *state)
+{
+	struct vduse_dev_msg msg = { 0 };
+	int ret;
+
+	msg.req.type = VDUSE_GET_VQ_STATE;
+	msg.req.request_id = vduse_dev_get_request_id(dev);
+	msg.req.vq_state.index = vq->index;
+
+	ret = vduse_dev_msg_sync(dev, &msg);
+	if (!ret)
+		state->avail_index = msg.resp.vq_state.avail_idx;
+
+	return ret;
+}
+
+static int vduse_dev_set_vq_state(struct vduse_dev *dev,
+				struct vduse_virtqueue *vq,
+				const struct vdpa_vq_state *state)
+{
+	struct vduse_dev_msg msg = { 0 };
+
+	msg.req.type = VDUSE_SET_VQ_STATE;
+	msg.req.request_id = vduse_dev_get_request_id(dev);
+	msg.req.vq_state.index = vq->index;
+	msg.req.vq_state.avail_idx = state->avail_index;
+
+	return vduse_dev_msg_sync(dev, &msg);
+}
+
+static int vduse_dev_update_iotlb(struct vduse_dev *dev,
+				u64 start, u64 last)
+{
+	struct vduse_dev_msg msg = { 0 };
+
+	if (last < start)
+		return -EINVAL;
+
+	msg.req.type = VDUSE_UPDATE_IOTLB;
+	msg.req.request_id = vduse_dev_get_request_id(dev);
+	msg.req.iova.start = start;
+	msg.req.iova.last = last;
+
+	return vduse_dev_msg_sync(dev, &msg);
+}
+
+static ssize_t vduse_dev_read_iter(struct kiocb *iocb, struct iov_iter *to)
+{
+	struct file *file = iocb->ki_filp;
+	struct vduse_dev *dev = file->private_data;
+	struct vduse_dev_msg *msg;
+	int size = sizeof(struct vduse_dev_request);
+	ssize_t ret;
+
+	if (iov_iter_count(to) < size)
+		return -EINVAL;
+
+	spin_lock(&dev->msg_lock);
+	while (1) {
+		msg = vduse_dequeue_msg(&dev->send_list);
+		if (msg)
+			break;
+
+		ret = -EAGAIN;
+		if (file->f_flags & O_NONBLOCK)
+			goto unlock;
+
+		spin_unlock(&dev->msg_lock);
+		ret = wait_event_interruptible_exclusive(dev->waitq,
+					!list_empty(&dev->send_list));
+		if (ret)
+			return ret;
+
+		spin_lock(&dev->msg_lock);
+	}
+	spin_unlock(&dev->msg_lock);
+	ret = copy_to_iter(&msg->req, size, to);
+	spin_lock(&dev->msg_lock);
+	if (ret != size) {
+		ret = -EFAULT;
+		vduse_enqueue_msg(&dev->send_list, msg);
+		goto unlock;
+	}
+	vduse_enqueue_msg(&dev->recv_list, msg);
+unlock:
+	spin_unlock(&dev->msg_lock);
+
+	return ret;
+}
+
+static ssize_t vduse_dev_write_iter(struct kiocb *iocb, struct iov_iter *from)
+{
+	struct file *file = iocb->ki_filp;
+	struct vduse_dev *dev = file->private_data;
+	struct vduse_dev_response resp;
+	struct vduse_dev_msg *msg;
+	size_t ret;
+
+	ret = copy_from_iter(&resp, sizeof(resp), from);
+	if (ret != sizeof(resp))
+		return -EINVAL;
+
+	spin_lock(&dev->msg_lock);
+	msg = vduse_find_msg(&dev->recv_list, resp.request_id);
+	if (!msg) {
+		ret = -ENOENT;
+		goto unlock;
+	}
+
+	memcpy(&msg->resp, &resp, sizeof(resp));
+	msg->completed = 1;
+	wake_up(&msg->waitq);
+unlock:
+	spin_unlock(&dev->msg_lock);
+
+	return ret;
+}
+
+static __poll_t vduse_dev_poll(struct file *file, poll_table *wait)
+{
+	struct vduse_dev *dev = file->private_data;
+	__poll_t mask = 0;
+
+	poll_wait(file, &dev->waitq, wait);
+
+	if (!list_empty(&dev->send_list))
+		mask |= EPOLLIN | EPOLLRDNORM;
+	if (!list_empty(&dev->recv_list))
+		mask |= EPOLLOUT | EPOLLWRNORM;
+
+	return mask;
+}
+
+static void vduse_dev_reset(struct vduse_dev *dev)
+{
+	int i;
+	struct vduse_iova_domain *domain = dev->domain;
+
+	/* The coherent mappings are handled in vduse_dev_free_coherent() */
+	if (domain->bounce_map) {
+		vduse_domain_reset_bounce_map(domain);
+		vduse_dev_update_iotlb(dev, 0ULL, domain->bounce_size - 1);
+	}
+
+	spin_lock(&dev->irq_lock);
+	dev->config_cb.callback = NULL;
+	dev->config_cb.private = NULL;
+	spin_unlock(&dev->irq_lock);
+
+	for (i = 0; i < dev->vq_num; i++) {
+		struct vduse_virtqueue *vq = &dev->vqs[i];
+
+		spin_lock(&vq->irq_lock);
+		vq->ready = false;
+		vq->cb.callback = NULL;
+		vq->cb.private = NULL;
+		spin_unlock(&vq->irq_lock);
+	}
+}
+
+static int vduse_vdpa_set_vq_address(struct vdpa_device *vdpa, u16 idx,
+				u64 desc_area, u64 driver_area,
+				u64 device_area)
+{
+	struct vduse_dev *dev = vdpa_to_vduse(vdpa);
+	struct vduse_virtqueue *vq = &dev->vqs[idx];
+
+	return vduse_dev_set_vq_addr(dev, vq, desc_area,
+					driver_area, device_area);
+}
+
+static void vduse_vdpa_kick_vq(struct vdpa_device *vdpa, u16 idx)
+{
+	struct vduse_dev *dev = vdpa_to_vduse(vdpa);
+	struct vduse_virtqueue *vq = &dev->vqs[idx];
+
+	spin_lock(&vq->kick_lock);
+	if (vq->ready && vq->kickfd)
+		eventfd_signal(vq->kickfd, 1);
+	spin_unlock(&vq->kick_lock);
+}
+
+static void vduse_vdpa_set_vq_cb(struct vdpa_device *vdpa, u16 idx,
+			      struct vdpa_callback *cb)
+{
+	struct vduse_dev *dev = vdpa_to_vduse(vdpa);
+	struct vduse_virtqueue *vq = &dev->vqs[idx];
+
+	spin_lock(&vq->irq_lock);
+	vq->cb.callback = cb->callback;
+	vq->cb.private = cb->private;
+	spin_unlock(&vq->irq_lock);
+}
+
+static void vduse_vdpa_set_vq_num(struct vdpa_device *vdpa, u16 idx, u32 num)
+{
+	struct vduse_dev *dev = vdpa_to_vduse(vdpa);
+	struct vduse_virtqueue *vq = &dev->vqs[idx];
+
+	vduse_dev_set_vq_num(dev, vq, num);
+}
+
+static void vduse_vdpa_set_vq_ready(struct vdpa_device *vdpa,
+					u16 idx, bool ready)
+{
+	struct vduse_dev *dev = vdpa_to_vduse(vdpa);
+	struct vduse_virtqueue *vq = &dev->vqs[idx];
+
+	vduse_dev_set_vq_ready(dev, vq, ready);
+	vq->ready = ready;
+}
+
+static bool vduse_vdpa_get_vq_ready(struct vdpa_device *vdpa, u16 idx)
+{
+	struct vduse_dev *dev = vdpa_to_vduse(vdpa);
+	struct vduse_virtqueue *vq = &dev->vqs[idx];
+
+	vq->ready = vduse_dev_get_vq_ready(dev, vq);
+
+	return vq->ready;
+}
+
+static int vduse_vdpa_set_vq_state(struct vdpa_device *vdpa, u16 idx,
+				const struct vdpa_vq_state *state)
+{
+	struct vduse_dev *dev = vdpa_to_vduse(vdpa);
+	struct vduse_virtqueue *vq = &dev->vqs[idx];
+
+	return vduse_dev_set_vq_state(dev, vq, state);
+}
+
+static int vduse_vdpa_get_vq_state(struct vdpa_device *vdpa, u16 idx,
+				struct vdpa_vq_state *state)
+{
+	struct vduse_dev *dev = vdpa_to_vduse(vdpa);
+	struct vduse_virtqueue *vq = &dev->vqs[idx];
+
+	return vduse_dev_get_vq_state(dev, vq, state);
+}
+
+static u32 vduse_vdpa_get_vq_align(struct vdpa_device *vdpa)
+{
+	struct vduse_dev *dev = vdpa_to_vduse(vdpa);
+
+	return dev->vq_align;
+}
+
+static u64 vduse_vdpa_get_features(struct vdpa_device *vdpa)
+{
+	struct vduse_dev *dev = vdpa_to_vduse(vdpa);
+
+	return vduse_dev_get_features(dev);
+}
+
+static int vduse_vdpa_set_features(struct vdpa_device *vdpa, u64 features)
+{
+	struct vduse_dev *dev = vdpa_to_vduse(vdpa);
+
+	if (!(features & (1ULL << VIRTIO_F_ACCESS_PLATFORM)))
+		return -EINVAL;
+
+	return vduse_dev_set_features(dev, features);
+}
+
+static void vduse_vdpa_set_config_cb(struct vdpa_device *vdpa,
+				  struct vdpa_callback *cb)
+{
+	struct vduse_dev *dev = vdpa_to_vduse(vdpa);
+
+	spin_lock(&dev->irq_lock);
+	dev->config_cb.callback = cb->callback;
+	dev->config_cb.private = cb->private;
+	spin_unlock(&dev->irq_lock);
+}
+
+static u16 vduse_vdpa_get_vq_num_max(struct vdpa_device *vdpa)
+{
+	struct vduse_dev *dev = vdpa_to_vduse(vdpa);
+
+	return dev->vq_size_max;
+}
+
+static u32 vduse_vdpa_get_device_id(struct vdpa_device *vdpa)
+{
+	struct vduse_dev *dev = vdpa_to_vduse(vdpa);
+
+	return dev->device_id;
+}
+
+static u32 vduse_vdpa_get_vendor_id(struct vdpa_device *vdpa)
+{
+	struct vduse_dev *dev = vdpa_to_vduse(vdpa);
+
+	return dev->vendor_id;
+}
+
+static u8 vduse_vdpa_get_status(struct vdpa_device *vdpa)
+{
+	struct vduse_dev *dev = vdpa_to_vduse(vdpa);
+
+	return vduse_dev_get_status(dev);
+}
+
+static void vduse_vdpa_set_status(struct vdpa_device *vdpa, u8 status)
+{
+	struct vduse_dev *dev = vdpa_to_vduse(vdpa);
+
+	vduse_dev_set_status(dev, status);
+
+	if (status == 0)
+		vduse_dev_reset(dev);
+}
+
+static size_t vduse_vdpa_get_config_size(struct vdpa_device *vdpa)
+{
+	struct vduse_dev *dev = vdpa_to_vduse(vdpa);
+
+	return dev->config_size;
+}
+
+static void vduse_vdpa_get_config(struct vdpa_device *vdpa, unsigned int offset,
+			     void *buf, unsigned int len)
+{
+	struct vduse_dev *dev = vdpa_to_vduse(vdpa);
+
+	vduse_dev_get_config(dev, offset, buf, len);
+}
+
+static void vduse_vdpa_set_config(struct vdpa_device *vdpa, unsigned int offset,
+			const void *buf, unsigned int len)
+{
+	struct vduse_dev *dev = vdpa_to_vduse(vdpa);
+
+	vduse_dev_set_config(dev, offset, buf, len);
+}
+
+static int vduse_vdpa_set_map(struct vdpa_device *vdpa,
+				struct vhost_iotlb *iotlb)
+{
+	struct vduse_dev *dev = vdpa_to_vduse(vdpa);
+	int ret;
+
+	ret = vduse_domain_set_map(dev->domain, iotlb);
+	vduse_dev_update_iotlb(dev, 0ULL, ULLONG_MAX);
+
+	return ret;
+}
+
+static void vduse_vdpa_free(struct vdpa_device *vdpa)
+{
+	struct vduse_dev *dev = vdpa_to_vduse(vdpa);
+
+	WARN_ON(!list_empty(&dev->send_list));
+	WARN_ON(!list_empty(&dev->recv_list));
+	dev->vdev = NULL;
+}
+
+static const struct vdpa_config_ops vduse_vdpa_config_ops = {
+	.set_vq_address		= vduse_vdpa_set_vq_address,
+	.kick_vq		= vduse_vdpa_kick_vq,
+	.set_vq_cb		= vduse_vdpa_set_vq_cb,
+	.set_vq_num             = vduse_vdpa_set_vq_num,
+	.set_vq_ready		= vduse_vdpa_set_vq_ready,
+	.get_vq_ready		= vduse_vdpa_get_vq_ready,
+	.set_vq_state		= vduse_vdpa_set_vq_state,
+	.get_vq_state		= vduse_vdpa_get_vq_state,
+	.get_vq_align		= vduse_vdpa_get_vq_align,
+	.get_features		= vduse_vdpa_get_features,
+	.set_features		= vduse_vdpa_set_features,
+	.set_config_cb		= vduse_vdpa_set_config_cb,
+	.get_vq_num_max		= vduse_vdpa_get_vq_num_max,
+	.get_device_id		= vduse_vdpa_get_device_id,
+	.get_vendor_id		= vduse_vdpa_get_vendor_id,
+	.get_status		= vduse_vdpa_get_status,
+	.set_status		= vduse_vdpa_set_status,
+	.get_config_size	= vduse_vdpa_get_config_size,
+	.get_config		= vduse_vdpa_get_config,
+	.set_config		= vduse_vdpa_set_config,
+	.set_map		= vduse_vdpa_set_map,
+	.free			= vduse_vdpa_free,
+};
+
+static dma_addr_t vduse_dev_map_page(struct device *dev, struct page *page,
+				     unsigned long offset, size_t size,
+				     enum dma_data_direction dir,
+				     unsigned long attrs)
+{
+	struct vduse_dev *vdev = dev_to_vduse(dev);
+	struct vduse_iova_domain *domain = vdev->domain;
+
+	return vduse_domain_map_page(domain, page, offset, size, dir, attrs);
+}
+
+static void vduse_dev_unmap_page(struct device *dev, dma_addr_t dma_addr,
+				size_t size, enum dma_data_direction dir,
+				unsigned long attrs)
+{
+	struct vduse_dev *vdev = dev_to_vduse(dev);
+	struct vduse_iova_domain *domain = vdev->domain;
+
+	return vduse_domain_unmap_page(domain, dma_addr, size, dir, attrs);
+}
+
+static void *vduse_dev_alloc_coherent(struct device *dev, size_t size,
+					dma_addr_t *dma_addr, gfp_t flag,
+					unsigned long attrs)
+{
+	struct vduse_dev *vdev = dev_to_vduse(dev);
+	struct vduse_iova_domain *domain = vdev->domain;
+	unsigned long iova;
+	void *addr;
+
+	*dma_addr = DMA_MAPPING_ERROR;
+	addr = vduse_domain_alloc_coherent(domain, size,
+				(dma_addr_t *)&iova, flag, attrs);
+	if (!addr)
+		return NULL;
+
+	*dma_addr = (dma_addr_t)iova;
+	vduse_dev_update_iotlb(vdev, iova, iova + size - 1);
+
+	return addr;
+}
+
+static void vduse_dev_free_coherent(struct device *dev, size_t size,
+					void *vaddr, dma_addr_t dma_addr,
+					unsigned long attrs)
+{
+	struct vduse_dev *vdev = dev_to_vduse(dev);
+	struct vduse_iova_domain *domain = vdev->domain;
+	unsigned long start = (unsigned long)dma_addr;
+	unsigned long last = start + size - 1;
+
+	vduse_domain_free_coherent(domain, size, vaddr, dma_addr, attrs);
+	vduse_dev_update_iotlb(vdev, start, last);
+}
+
+static size_t vduse_dev_max_mapping_size(struct device *dev)
+{
+	struct vduse_dev *vdev = dev_to_vduse(dev);
+	struct vduse_iova_domain *domain = vdev->domain;
+
+	return domain->bounce_size;
+}
+
+static const struct dma_map_ops vduse_dev_dma_ops = {
+	.map_page = vduse_dev_map_page,
+	.unmap_page = vduse_dev_unmap_page,
+	.alloc = vduse_dev_alloc_coherent,
+	.free = vduse_dev_free_coherent,
+	.max_mapping_size = vduse_dev_max_mapping_size,
+};
+
+static unsigned int perm_to_file_flags(u8 perm)
+{
+	unsigned int flags = 0;
+
+	switch (perm) {
+	case VDUSE_ACCESS_WO:
+		flags |= O_WRONLY;
+		break;
+	case VDUSE_ACCESS_RO:
+		flags |= O_RDONLY;
+		break;
+	case VDUSE_ACCESS_RW:
+		flags |= O_RDWR;
+		break;
+	default:
+		WARN(1, "invalidate vhost IOTLB permission\n");
+		break;
+	}
+
+	return flags;
+}
+
+static int vduse_kickfd_setup(struct vduse_dev *dev,
+			struct vduse_vq_eventfd *eventfd)
+{
+	struct eventfd_ctx *ctx = NULL;
+	struct vduse_virtqueue *vq;
+	u32 index;
+
+	if (eventfd->index >= dev->vq_num)
+		return -EINVAL;
+
+	index = array_index_nospec(eventfd->index, dev->vq_num);
+	vq = &dev->vqs[index];
+	if (eventfd->fd >= 0) {
+		ctx = eventfd_ctx_fdget(eventfd->fd);
+		if (IS_ERR(ctx))
+			return PTR_ERR(ctx);
+	} else if (eventfd->fd != VDUSE_EVENTFD_DEASSIGN)
+		return 0;
+
+	spin_lock(&vq->kick_lock);
+	if (vq->kickfd)
+		eventfd_ctx_put(vq->kickfd);
+	vq->kickfd = ctx;
+	spin_unlock(&vq->kick_lock);
+
+	return 0;
+}
+
+static void vduse_dev_irq_inject(struct work_struct *work)
+{
+	struct vduse_dev *dev = container_of(work, struct vduse_dev, inject);
+
+	spin_lock_irq(&dev->irq_lock);
+	if (dev->config_cb.callback)
+		dev->config_cb.callback(dev->config_cb.private);
+	spin_unlock_irq(&dev->irq_lock);
+}
+
+static void vduse_vq_irq_inject(struct work_struct *work)
+{
+	struct vduse_virtqueue *vq = container_of(work,
+					struct vduse_virtqueue, inject);
+
+	spin_lock_irq(&vq->irq_lock);
+	if (vq->ready && vq->cb.callback)
+		vq->cb.callback(vq->cb.private);
+	spin_unlock_irq(&vq->irq_lock);
+}
+
+static long vduse_dev_ioctl(struct file *file, unsigned int cmd,
+			    unsigned long arg)
+{
+	struct vduse_dev *dev = file->private_data;
+	void __user *argp = (void __user *)arg;
+	int ret;
+
+	switch (cmd) {
+	case VDUSE_IOTLB_GET_FD: {
+		struct vduse_iotlb_entry entry;
+		struct vhost_iotlb_map *map;
+		struct vdpa_map_file *map_file;
+		struct vduse_iova_domain *domain = dev->domain;
+		struct file *f = NULL;
+
+		ret = -EFAULT;
+		if (copy_from_user(&entry, argp, sizeof(entry)))
+			break;
+
+		ret = -EINVAL;
+		if (entry.start > entry.last)
+			break;
+
+		spin_lock(&domain->iotlb_lock);
+		map = vhost_iotlb_itree_first(domain->iotlb,
+					      entry.start, entry.last);
+		if (map) {
+			map_file = (struct vdpa_map_file *)map->opaque;
+			f = get_file(map_file->file);
+			entry.offset = map_file->offset;
+			entry.start = map->start;
+			entry.last = map->last;
+			entry.perm = map->perm;
+		}
+		spin_unlock(&domain->iotlb_lock);
+		ret = -EINVAL;
+		if (!f)
+			break;
+
+		ret = -EFAULT;
+		if (copy_to_user(argp, &entry, sizeof(entry))) {
+			fput(f);
+			break;
+		}
+		ret = receive_fd(f, perm_to_file_flags(entry.perm));
+		fput(f);
+		break;
+	}
+	case VDUSE_VQ_SETUP_KICKFD: {
+		struct vduse_vq_eventfd eventfd;
+
+		ret = -EFAULT;
+		if (copy_from_user(&eventfd, argp, sizeof(eventfd)))
+			break;
+
+		ret = vduse_kickfd_setup(dev, &eventfd);
+		break;
+	}
+	case VDUSE_INJECT_VQ_IRQ: {
+		u32 vq_index;
+
+		ret = -EFAULT;
+		if (copy_from_user(&vq_index, argp, sizeof(u32)))
+			break;
+
+		ret = -EINVAL;
+		if (vq_index >= dev->vq_num)
+			break;
+
+		ret = 0;
+		vq_index = array_index_nospec(vq_index, dev->vq_num);
+		queue_work(vduse_irq_wq, &dev->vqs[vq_index].inject);
+		break;
+	}
+	case VDUSE_INJECT_CONFIG_IRQ:
+		ret = 0;
+		queue_work(vduse_irq_wq, &dev->inject);
+		break;
+	default:
+		ret = -ENOIOCTLCMD;
+		break;
+	}
+
+	return ret;
+}
+
+static int vduse_dev_release(struct inode *inode, struct file *file)
+{
+	struct vduse_dev *dev = file->private_data;
+	struct vduse_dev_msg *msg;
+	int i;
+
+	for (i = 0; i < dev->vq_num; i++) {
+		struct vduse_virtqueue *vq = &dev->vqs[i];
+
+		spin_lock(&vq->kick_lock);
+		if (vq->kickfd)
+			eventfd_ctx_put(vq->kickfd);
+		vq->kickfd = NULL;
+		spin_unlock(&vq->kick_lock);
+	}
+
+	spin_lock(&dev->msg_lock);
+	/* Make sure the inflight messages can processed after reconncection */
+	while ((msg = vduse_dequeue_msg(&dev->recv_list)))
+		vduse_enqueue_msg(&dev->send_list, msg);
+	spin_unlock(&dev->msg_lock);
+
+	dev->connected = false;
+
+	return 0;
+}
+
+static int vduse_dev_open(struct inode *inode, struct file *file)
+{
+	struct vduse_dev *dev = container_of(inode->i_cdev,
+					struct vduse_dev, cdev);
+	int ret = -EBUSY;
+
+	mutex_lock(&dev->lock);
+	if (dev->connected)
+		goto unlock;
+
+	ret = 0;
+	dev->connected = true;
+	file->private_data = dev;
+unlock:
+	mutex_unlock(&dev->lock);
+
+	return ret;
+}
+
+static const struct file_operations vduse_dev_fops = {
+	.owner		= THIS_MODULE,
+	.open		= vduse_dev_open,
+	.release	= vduse_dev_release,
+	.read_iter	= vduse_dev_read_iter,
+	.write_iter	= vduse_dev_write_iter,
+	.poll		= vduse_dev_poll,
+	.unlocked_ioctl	= vduse_dev_ioctl,
+	.compat_ioctl	= compat_ptr_ioctl,
+	.llseek		= noop_llseek,
+};
+
+static struct vduse_dev *vduse_dev_create(void)
+{
+	struct vduse_dev *dev = kzalloc(sizeof(*dev), GFP_KERNEL);
+
+	if (!dev)
+		return NULL;
+
+	mutex_init(&dev->lock);
+	spin_lock_init(&dev->msg_lock);
+	INIT_LIST_HEAD(&dev->send_list);
+	INIT_LIST_HEAD(&dev->recv_list);
+	atomic64_set(&dev->msg_unique, 0);
+	spin_lock_init(&dev->irq_lock);
+
+	INIT_WORK(&dev->inject, vduse_dev_irq_inject);
+	init_waitqueue_head(&dev->waitq);
+
+	return dev;
+}
+
+static void vduse_dev_destroy(struct vduse_dev *dev)
+{
+	kfree(dev);
+}
+
+static struct vduse_dev *vduse_find_dev(const char *name)
+{
+	struct vduse_dev *tmp, *dev = NULL;
+
+	list_for_each_entry(tmp, &vduse_devs, list) {
+		if (!strcmp(tmp->name, name)) {
+			dev = tmp;
+			break;
+		}
+	}
+	return dev;
+}
+
+static int vduse_destroy_dev(char *name)
+{
+	struct vduse_dev *dev = vduse_find_dev(name);
+
+	if (!dev)
+		return -EINVAL;
+
+	mutex_lock(&dev->lock);
+	if (dev->vdev || dev->connected) {
+		mutex_unlock(&dev->lock);
+		return -EBUSY;
+	}
+	dev->connected = true;
+	mutex_unlock(&dev->lock);
+
+	list_del(&dev->list);
+	cdev_device_del(&dev->cdev, &dev->dev);
+	put_device(&dev->dev);
+	module_put(THIS_MODULE);
+
+	return 0;
+}
+
+static void vduse_release_dev(struct device *device)
+{
+	struct vduse_dev *dev =
+		container_of(device, struct vduse_dev, dev);
+
+	ida_simple_remove(&vduse_ida, dev->minor);
+	kfree(dev->vqs);
+	vduse_domain_destroy(dev->domain);
+	kfree(dev->name);
+	vduse_dev_destroy(dev);
+}
+
+static bool device_is_allowed(unsigned int device_id)
+{
+	int i;
+
+	if (allow_unsafe_device_emulation)
+		return true;
+
+	for (i = 0; i < ARRAY_SIZE(allowed_device_id); i++) {
+		if (allowed_device_id[i] == device_id)
+			return true;
+	}
+	return false;
+}
+
+static int vduse_create_dev(struct vduse_dev_config *config,
+			    unsigned long api_version)
+{
+	int i, ret = -ENOMEM;
+	struct vduse_dev *dev;
+
+	if (config->bounce_size > max_bounce_size)
+		return -EINVAL;
+
+	if (config->vq_align > PAGE_SIZE)
+		return -EINVAL;
+
+	if (!device_is_allowed(config->device_id))
+		return -EINVAL;
+
+	if (vduse_find_dev(config->name))
+		return -EEXIST;
+
+	dev = vduse_dev_create();
+	if (!dev)
+		return -ENOMEM;
+
+	dev->api_version = api_version;
+	dev->device_id = config->device_id;
+	dev->vendor_id = config->vendor_id;
+	dev->name = kstrdup(config->name, GFP_KERNEL);
+	if (!dev->name)
+		goto err_str;
+
+	dev->domain = vduse_domain_create(max_iova_size - 1,
+					config->bounce_size);
+	if (!dev->domain)
+		goto err_domain;
+
+	dev->config_size = config->config_size;
+	dev->vq_align = config->vq_align;
+	dev->vq_size_max = config->vq_size_max;
+	dev->vq_num = config->vq_num;
+	dev->vqs = kcalloc(dev->vq_num, sizeof(*dev->vqs), GFP_KERNEL);
+	if (!dev->vqs)
+		goto err_vqs;
+
+	for (i = 0; i < dev->vq_num; i++) {
+		dev->vqs[i].index = i;
+		INIT_WORK(&dev->vqs[i].inject, vduse_vq_irq_inject);
+		spin_lock_init(&dev->vqs[i].kick_lock);
+		spin_lock_init(&dev->vqs[i].irq_lock);
+	}
+
+	ret = ida_simple_get(&vduse_ida, 0, VDUSE_DEV_MAX, GFP_KERNEL);
+	if (ret < 0)
+		goto err_ida;
+
+	dev->minor = ret;
+	device_initialize(&dev->dev);
+	dev->dev.release = vduse_release_dev;
+	dev->dev.class = vduse_class;
+	dev->dev.devt = MKDEV(MAJOR(vduse_major), dev->minor);
+	ret = dev_set_name(&dev->dev, "%s", config->name);
+	if (ret)
+		goto err;
+
+	cdev_init(&dev->cdev, &vduse_dev_fops);
+	dev->cdev.owner = THIS_MODULE;
+
+	ret = cdev_device_add(&dev->cdev, &dev->dev);
+	if (ret)
+		goto err;
+
+	list_add(&dev->list, &vduse_devs);
+	__module_get(THIS_MODULE);
+
+	return 0;
+err_ida:
+	kfree(dev->vqs);
+err_vqs:
+	vduse_domain_destroy(dev->domain);
+err_domain:
+	kfree(dev->name);
+err_str:
+	vduse_dev_destroy(dev);
+	return ret;
+err:
+	put_device(&dev->dev);
+	return ret;
+}
+
+static long vduse_ioctl(struct file *file, unsigned int cmd,
+			unsigned long arg)
+{
+	int ret;
+	void __user *argp = (void __user *)arg;
+	struct vduse_control *control = file->private_data;
+
+	mutex_lock(&vduse_lock);
+	switch (cmd) {
+	case VDUSE_GET_API_VERSION:
+		ret = control->api_version;
+		break;
+	case VDUSE_SET_API_VERSION:
+		ret = -EINVAL;
+		if (arg > VDUSE_API_VERSION)
+			break;
+
+		ret = 0;
+		control->api_version = arg;
+		break;
+	case VDUSE_CREATE_DEV: {
+		struct vduse_dev_config config;
+
+		ret = -EFAULT;
+		if (copy_from_user(&config, argp, sizeof(config)))
+			break;
+
+		ret = vduse_create_dev(&config, control->api_version);
+		break;
+	}
+	case VDUSE_DESTROY_DEV: {
+		char name[VDUSE_NAME_MAX];
+
+		ret = -EFAULT;
+		if (copy_from_user(name, argp, VDUSE_NAME_MAX))
+			break;
+
+		ret = vduse_destroy_dev(name);
+		break;
+	}
+	default:
+		ret = -EINVAL;
+		break;
+	}
+	mutex_unlock(&vduse_lock);
+
+	return ret;
+}
+
+static int vduse_release(struct inode *inode, struct file *file)
+{
+	struct vduse_control *control = file->private_data;
+
+	kfree(control);
+	return 0;
+}
+
+static int vduse_open(struct inode *inode, struct file *file)
+{
+	struct vduse_control *control;
+
+	control = kmalloc(sizeof(struct vduse_control), GFP_KERNEL);
+	if (!control)
+		return -ENOMEM;
+
+	control->api_version = VDUSE_API_VERSION;
+	file->private_data = control;
+
+	return 0;
+}
+
+static const struct file_operations vduse_fops = {
+	.owner		= THIS_MODULE,
+	.open		= vduse_open,
+	.release	= vduse_release,
+	.unlocked_ioctl	= vduse_ioctl,
+	.compat_ioctl	= compat_ptr_ioctl,
+	.llseek		= noop_llseek,
+};
+
+static char *vduse_devnode(struct device *dev, umode_t *mode)
+{
+	return kasprintf(GFP_KERNEL, "vduse/%s", dev_name(dev));
+}
+
+static struct miscdevice vduse_misc = {
+	.fops = &vduse_fops,
+	.minor = MISC_DYNAMIC_MINOR,
+	.name = "vduse",
+	.nodename = "vduse/control",
+};
+
+static void vduse_mgmtdev_release(struct device *dev)
+{
+}
+
+static struct device vduse_mgmtdev = {
+	.init_name = "vduse",
+	.release = vduse_mgmtdev_release,
+};
+
+static struct vdpa_mgmt_dev mgmt_dev;
+
+static int vduse_dev_init_vdpa(struct vduse_dev *dev, const char *name)
+{
+	struct vduse_vdpa *vdev;
+	int ret;
+
+	if (dev->vdev)
+		return -EEXIST;
+
+	vdev = vdpa_alloc_device(struct vduse_vdpa, vdpa, &dev->dev,
+				 &vduse_vdpa_config_ops, name, true);
+	if (!vdev)
+		return -ENOMEM;
+
+	dev->vdev = vdev;
+	vdev->dev = dev;
+	vdev->vdpa.dev.dma_mask = &vdev->vdpa.dev.coherent_dma_mask;
+	ret = dma_set_mask_and_coherent(&vdev->vdpa.dev, DMA_BIT_MASK(64));
+	if (ret) {
+		put_device(&vdev->vdpa.dev);
+		return ret;
+	}
+	set_dma_ops(&vdev->vdpa.dev, &vduse_dev_dma_ops);
+	vdev->vdpa.dma_dev = &vdev->vdpa.dev;
+	vdev->vdpa.mdev = &mgmt_dev;
+
+	return 0;
+}
+
+static int vdpa_dev_add(struct vdpa_mgmt_dev *mdev, const char *name)
+{
+	struct vduse_dev *dev;
+	int ret;
+
+	mutex_lock(&vduse_lock);
+	dev = vduse_find_dev(name);
+	if (!dev) {
+		mutex_unlock(&vduse_lock);
+		return -EINVAL;
+	}
+	ret = vduse_dev_init_vdpa(dev, name);
+	mutex_unlock(&vduse_lock);
+	if (ret)
+		return ret;
+
+	ret = _vdpa_register_device(&dev->vdev->vdpa, dev->vq_num);
+	if (ret) {
+		put_device(&dev->vdev->vdpa.dev);
+		return ret;
+	}
+
+	return 0;
+}
+
+static void vdpa_dev_del(struct vdpa_mgmt_dev *mdev, struct vdpa_device *dev)
+{
+	_vdpa_unregister_device(dev);
+}
+
+static const struct vdpa_mgmtdev_ops vdpa_dev_mgmtdev_ops = {
+	.dev_add = vdpa_dev_add,
+	.dev_del = vdpa_dev_del,
+};
+
+static struct virtio_device_id id_table[] = {
+	{ VIRTIO_DEV_ANY_ID, VIRTIO_DEV_ANY_ID },
+	{ 0 },
+};
+
+static struct vdpa_mgmt_dev mgmt_dev = {
+	.device = &vduse_mgmtdev,
+	.id_table = id_table,
+	.ops = &vdpa_dev_mgmtdev_ops,
+};
+
+static int vduse_mgmtdev_init(void)
+{
+	int ret;
+
+	ret = device_register(&vduse_mgmtdev);
+	if (ret)
+		return ret;
+
+	ret = vdpa_mgmtdev_register(&mgmt_dev);
+	if (ret)
+		goto err;
+
+	return 0;
+err:
+	device_unregister(&vduse_mgmtdev);
+	return ret;
+}
+
+static void vduse_mgmtdev_exit(void)
+{
+	vdpa_mgmtdev_unregister(&mgmt_dev);
+	device_unregister(&vduse_mgmtdev);
+}
+
+static int vduse_init(void)
+{
+	int ret;
+
+	if (max_bounce_size >= max_iova_size)
+		return -EINVAL;
+
+	ret = misc_register(&vduse_misc);
+	if (ret)
+		return ret;
+
+	vduse_class = class_create(THIS_MODULE, "vduse");
+	if (IS_ERR(vduse_class)) {
+		ret = PTR_ERR(vduse_class);
+		goto err_class;
+	}
+	vduse_class->devnode = vduse_devnode;
+
+	ret = alloc_chrdev_region(&vduse_major, 0, VDUSE_DEV_MAX, "vduse");
+	if (ret)
+		goto err_chardev;
+
+	vduse_irq_wq = alloc_workqueue("vduse-irq",
+				WQ_HIGHPRI | WQ_SYSFS | WQ_UNBOUND, 0);
+	if (!vduse_irq_wq)
+		goto err_wq;
+
+	ret = vduse_domain_init();
+	if (ret)
+		goto err_domain;
+
+	ret = vduse_mgmtdev_init();
+	if (ret)
+		goto err_mgmtdev;
+
+	return 0;
+err_mgmtdev:
+	vduse_domain_exit();
+err_domain:
+	destroy_workqueue(vduse_irq_wq);
+err_wq:
+	unregister_chrdev_region(vduse_major, VDUSE_DEV_MAX);
+err_chardev:
+	class_destroy(vduse_class);
+err_class:
+	misc_deregister(&vduse_misc);
+	return ret;
+}
+module_init(vduse_init);
+
+static void vduse_exit(void)
+{
+	misc_deregister(&vduse_misc);
+	class_destroy(vduse_class);
+	unregister_chrdev_region(vduse_major, VDUSE_DEV_MAX);
+	destroy_workqueue(vduse_irq_wq);
+	vduse_domain_exit();
+	vduse_mgmtdev_exit();
+}
+module_exit(vduse_exit);
+
+MODULE_VERSION(DRV_VERSION);
+MODULE_LICENSE(DRV_LICENSE);
+MODULE_AUTHOR(DRV_AUTHOR);
+MODULE_DESCRIPTION(DRV_DESC);
diff --git a/include/uapi/linux/vduse.h b/include/uapi/linux/vduse.h
new file mode 100644
index 000000000000..2484b1f7d2ef
--- /dev/null
+++ b/include/uapi/linux/vduse.h
@@ -0,0 +1,178 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+#ifndef _UAPI_VDUSE_H_
+#define _UAPI_VDUSE_H_
+
+#include <linux/types.h>
+
+#define VDUSE_API_VERSION	0
+
+#define VDUSE_MAX_TRANSFER_LEN	256
+#define VDUSE_NAME_MAX	256
+
+/* the control messages definition for read/write */
+
+enum vduse_req_type {
+	/* Set the vring address of virtqueue. */
+	VDUSE_SET_VQ_NUM,
+	/* Set the vring address of virtqueue. */
+	VDUSE_SET_VQ_ADDR,
+	/* Set ready status of virtqueue */
+	VDUSE_SET_VQ_READY,
+	/* Get ready status of virtqueue */
+	VDUSE_GET_VQ_READY,
+	/* Set the state for virtqueue */
+	VDUSE_SET_VQ_STATE,
+	/* Get the state for virtqueue */
+	VDUSE_GET_VQ_STATE,
+	/* Set virtio features supported by the driver */
+	VDUSE_SET_FEATURES,
+	/* Get virtio features supported by the device */
+	VDUSE_GET_FEATURES,
+	/* Set the device status */
+	VDUSE_SET_STATUS,
+	/* Get the device status */
+	VDUSE_GET_STATUS,
+	/* Write to device specific configuration space */
+	VDUSE_SET_CONFIG,
+	/* Read from device specific configuration space */
+	VDUSE_GET_CONFIG,
+	/* Notify userspace to update the memory mapping in device IOTLB */
+	VDUSE_UPDATE_IOTLB,
+};
+
+struct vduse_vq_num {
+	__u32 index; /* virtqueue index */
+	__u32 num; /* the size of virtqueue */
+};
+
+struct vduse_vq_addr {
+	__u32 index; /* virtqueue index */
+	__u32 padding; /* padding */
+	__u64 desc_addr; /* address of desc area */
+	__u64 driver_addr; /* address of driver area */
+	__u64 device_addr; /* address of device area */
+};
+
+struct vduse_vq_ready {
+	__u32 index; /* virtqueue index */
+	__u8 ready; /* ready status of virtqueue */
+};
+
+struct vduse_vq_state {
+	__u32 index; /* virtqueue index */
+	__u32 avail_idx; /* virtqueue state (last_avail_idx) */
+};
+
+struct vduse_dev_config_data {
+	__u32 offset; /* offset from the beginning of config space */
+	__u32 len; /* the length to read/write */
+	__u8 data[VDUSE_MAX_TRANSFER_LEN]; /* data buffer used to read/write */
+};
+
+struct vduse_iova_range {
+	__u64 start; /* start of the IOVA range */
+	__u64 last; /* end of the IOVA range */
+};
+
+struct vduse_features {
+	__u64 features; /* virtio features */
+};
+
+struct vduse_status {
+	__u8 status; /* device status */
+};
+
+struct vduse_dev_request {
+	__u32 type; /* request type */
+	__u32 request_id; /* request id */
+	__u32 reserved[2]; /* for future use */
+	union {
+		struct vduse_vq_num vq_num; /* virtqueue num */
+		struct vduse_vq_addr vq_addr; /* virtqueue address */
+		struct vduse_vq_ready vq_ready; /* virtqueue ready status */
+		struct vduse_vq_state vq_state; /* virtqueue state */
+		struct vduse_dev_config_data config; /* virtio device config space */
+		struct vduse_iova_range iova; /* iova range for updating */
+		struct vduse_features f; /* virtio features */
+		struct vduse_status s; /* device status */
+		__u32 padding[128]; /* padding */
+	};
+};
+
+struct vduse_dev_response {
+	__u32 request_id; /* corresponding request id */
+#define VDUSE_REQUEST_OK	0x00
+#define VDUSE_REQUEST_FAILED	0x01
+	__u32 result; /* the result of request */
+	__u32 reserved[2]; /* for future use */
+	union {
+		struct vduse_vq_ready vq_ready; /* virtqueue ready status */
+		struct vduse_vq_state vq_state; /* virtqueue state */
+		struct vduse_dev_config_data config; /* virtio device config space */
+		struct vduse_features f; /* virtio features */
+		struct vduse_status s; /* device status */
+		__u32 padding[128]; /* padding */
+	};
+};
+
+/* ioctls */
+
+struct vduse_dev_config {
+	char name[VDUSE_NAME_MAX]; /* vduse device name */
+	__u32 vendor_id; /* virtio vendor id */
+	__u32 device_id; /* virtio device id */
+	__u64 bounce_size; /* bounce buffer size for iommu */
+	__u16 vq_size_max; /* the max size of virtqueue */
+	__u16 padding; /* padding */
+	__u32 vq_num; /* the number of virtqueues */
+	__u32 vq_align; /* the allocation alignment of virtqueue's metadata */
+	__u32 config_size; /* the size of the configuration space */
+	__u32 reserved[15]; /* for future use */
+};
+
+struct vduse_iotlb_entry {
+	__u64 offset; /* the mmap offset on fd */
+	__u64 start; /* start of the IOVA range */
+	__u64 last; /* last of the IOVA range */
+#define VDUSE_ACCESS_RO 0x1
+#define VDUSE_ACCESS_WO 0x2
+#define VDUSE_ACCESS_RW 0x3
+	__u8 perm; /* access permission of this range */
+};
+
+struct vduse_vq_eventfd {
+	__u32 index; /* virtqueue index */
+#define VDUSE_EVENTFD_DEASSIGN -1
+	int fd; /* eventfd, -1 means de-assigning the eventfd */
+};
+
+#define VDUSE_BASE	0x81
+
+/* Get the version of VDUSE API. This is used for future extension */
+#define VDUSE_GET_API_VERSION	_IO(VDUSE_BASE, 0x00)
+
+/* Set the version of VDUSE API. */
+#define VDUSE_SET_API_VERSION	_IO(VDUSE_BASE, 0x01)
+
+/* Create a vduse device which is represented by a char device (/dev/vduse/<name>) */
+#define VDUSE_CREATE_DEV	_IOW(VDUSE_BASE, 0x02, struct vduse_dev_config)
+
+/* Destroy a vduse device. Make sure there are no references to the char device */
+#define VDUSE_DESTROY_DEV	_IOW(VDUSE_BASE, 0x03, char[VDUSE_NAME_MAX])
+
+/*
+ * Get a file descriptor for the first overlapped iova region,
+ * -EINVAL means the iova region doesn't exist.
+ */
+#define VDUSE_IOTLB_GET_FD	_IOWR(VDUSE_BASE, 0x04, struct vduse_iotlb_entry)
+
+/* Setup an eventfd to receive kick for virtqueue */
+#define VDUSE_VQ_SETUP_KICKFD	_IOW(VDUSE_BASE, 0x05, struct vduse_vq_eventfd)
+
+/* Inject an interrupt for specific virtqueue */
+#define VDUSE_INJECT_VQ_IRQ	_IOW(VDUSE_BASE, 0x06, __u32)
+
+/* Inject a config interrupt */
+#define VDUSE_INJECT_CONFIG_IRQ	_IO(VDUSE_BASE, 0x07)
+
+#endif /* _UAPI_VDUSE_H_ */
-- 
2.11.0

