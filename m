Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D47D310037A
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 12:03:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727039AbfKRLD2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 06:03:28 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:44315 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726728AbfKRLD1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 06:03:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574075005;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SdHwAl6nmIFJiPUAxWaicvNt5BNhq2Uln8CUP4rzSgM=;
        b=Z9oe8pLWiHXvKvmtnzyiNF/cnMl6mO/NxRjHlBoxLg6u8VYzHzjuvcEy2P+VSCViyt4YOA
        Gnx0Kj4TCGsV4uy9IzXC7ERlVetJIWjt7FJGHH2v5j6NfptA6wGKVnMGDaK7v3yAUCJt9E
        E52UUdpItDjHDeTAfEQvv4K/xEIRZAI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-163-HMZj_D1gPXCUF_tPyi6m_A-1; Mon, 18 Nov 2019 06:03:22 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EA5B08E083D;
        Mon, 18 Nov 2019 11:03:16 +0000 (UTC)
Received: from jason-ThinkPad-X1-Carbon-6th.redhat.com (ovpn-12-65.pek2.redhat.com [10.72.12.65])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 924B260BE1;
        Mon, 18 Nov 2019 11:02:37 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org, kwankhede@nvidia.com,
        alex.williamson@redhat.com, mst@redhat.com, tiwei.bie@intel.com,
        gregkh@linuxfoundation.org, jgg@mellanox.com
Cc:     netdev@vger.kernel.org, cohuck@redhat.com,
        maxime.coquelin@redhat.com, cunming.liang@intel.com,
        zhihong.wang@intel.com, rob.miller@broadcom.com,
        xiao.w.wang@intel.com, haotian.wang@sifive.com,
        zhenyuw@linux.intel.com, zhi.a.wang@intel.com,
        jani.nikula@linux.intel.com, joonas.lahtinen@linux.intel.com,
        rodrigo.vivi@intel.com, airlied@linux.ie, daniel@ffwll.ch,
        farman@linux.ibm.com, pasic@linux.ibm.com, sebott@linux.ibm.com,
        oberpar@linux.ibm.com, heiko.carstens@de.ibm.com,
        gor@linux.ibm.com, borntraeger@de.ibm.com, akrowiak@linux.ibm.com,
        freude@linux.ibm.com, lingshan.zhu@intel.com, eperezma@redhat.com,
        lulu@redhat.com, parav@mellanox.com,
        christophe.de.dinechin@gmail.com, kevin.tian@intel.com,
        stefanha@redhat.com, rdunlap@infradead.org, hch@infradead.org,
        aadam@redhat.com, jakub.kicinski@netronome.com, jiri@mellanox.com,
        jeffrey.t.kirsher@intel.com, Jason Wang <jasowang@redhat.com>
Subject: [PATCH V13 6/6] docs: sample driver to demonstrate how to implement virtio-mdev framework
Date:   Mon, 18 Nov 2019 18:59:23 +0800
Message-Id: <20191118105923.7991-7-jasowang@redhat.com>
In-Reply-To: <20191118105923.7991-1-jasowang@redhat.com>
References: <20191118105923.7991-1-jasowang@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: HMZj_D1gPXCUF_tPyi6m_A-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This sample driver creates mdev device that simulate virtio net device
over virtio mdev transport. The device is implemented through vringh
and workqueue. A device specific dma ops is to make sure HVA is used
directly as the IOVA. This should be sufficient for kernel virtio
driver to work.

Only 'virtio' type is supported right now. I plan to add 'vhost' type
on top which requires some virtual IOMMU implemented in this sample
driver.

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 MAINTAINERS                        |   1 +
 samples/Kconfig                    |  10 +
 samples/vfio-mdev/Makefile         |   1 +
 samples/vfio-mdev/mvnet_loopback.c | 690 +++++++++++++++++++++++++++++
 4 files changed, 702 insertions(+)
 create mode 100644 samples/vfio-mdev/mvnet_loopback.c

diff --git a/MAINTAINERS b/MAINTAINERS
index e1b57c84f249..36f9fe9034be 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17246,6 +17246,7 @@ F:=09net/vmw_vsock/virtio_transport.c
 F:=09drivers/net/vsockmon.c
 F:=09drivers/vhost/vsock.c
 F:=09tools/testing/vsock/
+F:=09samples/vfio-mdev/mvnet_loopback.c
=20
 VIRTIO CONSOLE DRIVER
 M:=09Amit Shah <amit@kernel.org>
diff --git a/samples/Kconfig b/samples/Kconfig
index c8dacb4dda80..1bef029cc977 100644
--- a/samples/Kconfig
+++ b/samples/Kconfig
@@ -131,6 +131,16 @@ config SAMPLE_VFIO_MDEV_MDPY
 =09  mediated device.  It is a simple framebuffer and supports
 =09  the region display interface (VFIO_GFX_PLANE_TYPE_REGION).
=20
+config SAMPLE_VIRTIO_MDEV_NET_LOOPBACK
+=09tristate "Build loopback VIRTIO net example mediated device sample code=
 -- loadable modules only"
+=09depends on MDEV_VIRTIO && VHOST_RING && m
+=09help
+=09  Build a networking sample device for use as a virtio
+=09  mediated device. The device cooperates with virtio-mdev bus
+=09  driver to present an virtio ethernet driver for
+=09  kernel. It simply loopbacks all packets from its TX
+=09  virtqueue to its RX virtqueue.
+
 config SAMPLE_VFIO_MDEV_MDPY_FB
 =09tristate "Build VFIO mdpy example guest fbdev driver -- loadable module=
 only"
 =09depends on FB && m
diff --git a/samples/vfio-mdev/Makefile b/samples/vfio-mdev/Makefile
index 10d179c4fdeb..817618569848 100644
--- a/samples/vfio-mdev/Makefile
+++ b/samples/vfio-mdev/Makefile
@@ -3,3 +3,4 @@ obj-$(CONFIG_SAMPLE_VFIO_MDEV_MTTY) +=3D mtty.o
 obj-$(CONFIG_SAMPLE_VFIO_MDEV_MDPY) +=3D mdpy.o
 obj-$(CONFIG_SAMPLE_VFIO_MDEV_MDPY_FB) +=3D mdpy-fb.o
 obj-$(CONFIG_SAMPLE_VFIO_MDEV_MBOCHS) +=3D mbochs.o
+obj-$(CONFIG_SAMPLE_VIRTIO_MDEV_NET_LOOPBACK) +=3D mvnet_loopback.o
diff --git a/samples/vfio-mdev/mvnet_loopback.c b/samples/vfio-mdev/mvnet_l=
oopback.c
new file mode 100644
index 000000000000..79059a177f39
--- /dev/null
+++ b/samples/vfio-mdev/mvnet_loopback.c
@@ -0,0 +1,690 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Mediated virtual virtio-net device driver.
+ *
+ * Copyright (c) 2019, Red Hat Inc. All rights reserved.
+ *     Author: Jason Wang <jasowang@redhat.com>
+ *
+ * Sample driver that creates mdev device that simulates ethernet loopback
+ * device.
+ *
+ * Usage:
+ *
+ * # modprobe virtio_mdev
+ * # modprobe mvnet_loopback
+ * # cd /sys/devices/virtual/mvnet_loopback/mvnet_loopback/ \
+ *      mdev_supported_types/mvnet_loopback-virtio
+ * # echo "83b8f4f2-509f-382f-3c1e-e6bfe0fa1001" > ./create
+ * # cd devices/83b8f4f2-509f-382f-3c1e-e6bfe0fa1001
+ * # ls -d virtio0
+ * virtio0
+ */
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/device.h>
+#include <linux/kernel.h>
+#include <linux/fs.h>
+#include <linux/poll.h>
+#include <linux/slab.h>
+#include <linux/sched.h>
+#include <linux/wait.h>
+#include <linux/uuid.h>
+#include <linux/iommu.h>
+#include <linux/sysfs.h>
+#include <linux/file.h>
+#include <linux/etherdevice.h>
+#include <linux/mdev.h>
+#include <linux/vringh.h>
+#include <linux/mdev_virtio.h>
+#include <uapi/linux/virtio_config.h>
+#include <uapi/linux/virtio_net.h>
+
+#define VERSION_STRING  "0.1"
+#define DRIVER_AUTHOR   "Red Hat Corporation"
+
+#define MVNET_CLASS_NAME "mvnet_loopback"
+#define MVNET_NAME       "mvnet_loopback"
+
+#define VIRTIO_MDEV_DEVICE_API_STRING "virtio-mdev"
+
+/*
+ * Global Structures
+ */
+
+static struct mvnet_dev {
+=09struct class=09*vd_class;
+=09struct idr=09vd_idr;
+=09struct device=09dev;
+} mvnet_dev;
+
+struct mvnet_virtqueue {
+=09struct vringh vring;
+=09struct vringh_kiov iov;
+=09unsigned short head;
+=09bool ready;
+=09u64 desc_addr;
+=09u64 device_addr;
+=09u64 driver_addr;
+=09u32 num;
+=09void *private;
+=09irqreturn_t (*cb)(void *data);
+};
+
+#define MVNET_QUEUE_ALIGN PAGE_SIZE
+#define MVNET_QUEUE_MAX 256
+#define MVNET_DEVICE_ID 0x1
+#define MVNET_VENDOR_ID 0
+
+u64 mvnet_features =3D (1ULL << VIRTIO_F_ANY_LAYOUT) |
+=09=09     (1ULL << VIRTIO_F_VERSION_1) |
+=09=09     (1ULL << VIRTIO_F_IOMMU_PLATFORM);
+
+/* State of each mdev device */
+struct mvnet_state {
+=09struct mvnet_virtqueue vqs[2];
+=09struct work_struct work;
+=09/* spinlock to synchronize virtqueue state */
+=09spinlock_t lock;
+=09struct mdev_device *mdev;
+=09struct virtio_net_config config;
+=09void *buffer;
+=09u32 status;
+=09u32 generation;
+=09u64 features;
+=09struct list_head next;
+};
+
+static struct mutex mdev_list_lock;
+static struct list_head mdev_devices_list;
+
+static void mvnet_queue_ready(struct mvnet_state *mvnet, unsigned int idx)
+{
+=09struct mvnet_virtqueue *vq =3D &mvnet->vqs[idx];
+=09int ret;
+
+=09ret =3D vringh_init_kern(&vq->vring, mvnet_features, MVNET_QUEUE_MAX,
+=09=09=09       false, (struct vring_desc *)vq->desc_addr,
+=09=09=09       (struct vring_avail *)vq->driver_addr,
+=09=09=09       (struct vring_used *)vq->device_addr);
+}
+
+static void mvnet_vq_reset(struct mvnet_virtqueue *vq)
+{
+=09vq->ready =3D 0;
+=09vq->desc_addr =3D 0;
+=09vq->driver_addr =3D 0;
+=09vq->device_addr =3D 0;
+=09vq->cb =3D NULL;
+=09vq->private =3D NULL;
+=09vringh_init_kern(&vq->vring, mvnet_features, MVNET_QUEUE_MAX,
+=09=09=09 false, 0, 0, 0);
+}
+
+static void mvnet_reset(struct mvnet_state *mvnet)
+{
+=09int i;
+
+=09for (i =3D 0; i < 2; i++)
+=09=09mvnet_vq_reset(&mvnet->vqs[i]);
+
+=09mvnet->features =3D 0;
+=09mvnet->status =3D 0;
+=09++mvnet->generation;
+}
+
+static void mvnet_work(struct work_struct *work)
+{
+=09struct mvnet_state *mvnet =3D container_of(work, struct
+=09=09=09=09=09=09 mvnet_state, work);
+=09struct mvnet_virtqueue *txq =3D &mvnet->vqs[1];
+=09struct mvnet_virtqueue *rxq =3D &mvnet->vqs[0];
+=09size_t read, write, total_write;
+=09int err;
+=09int pkts =3D 0;
+
+=09spin_lock(&mvnet->lock);
+
+=09if (!txq->ready || !rxq->ready)
+=09=09goto out;
+
+=09while (true) {
+=09=09total_write =3D 0;
+=09=09err =3D vringh_getdesc_kern(&txq->vring, &txq->iov, NULL,
+=09=09=09=09=09  &txq->head, GFP_ATOMIC);
+=09=09if (err <=3D 0)
+=09=09=09break;
+
+=09=09err =3D vringh_getdesc_kern(&rxq->vring, NULL, &rxq->iov,
+=09=09=09=09=09  &rxq->head, GFP_ATOMIC);
+=09=09if (err <=3D 0) {
+=09=09=09vringh_complete_kern(&txq->vring, txq->head, 0);
+=09=09=09break;
+=09=09}
+
+=09=09while (true) {
+=09=09=09read =3D vringh_iov_pull_kern(&txq->iov, mvnet->buffer,
+=09=09=09=09=09=09    PAGE_SIZE);
+=09=09=09if (read <=3D 0)
+=09=09=09=09break;
+
+=09=09=09write =3D vringh_iov_push_kern(&rxq->iov, mvnet->buffer,
+=09=09=09=09=09=09     read);
+=09=09=09if (write <=3D 0)
+=09=09=09=09break;
+
+=09=09=09total_write +=3D write;
+=09=09}
+
+=09=09/* Make sure data is wrote before advancing index */
+=09=09smp_wmb();
+
+=09=09vringh_complete_kern(&txq->vring, txq->head, 0);
+=09=09vringh_complete_kern(&rxq->vring, rxq->head, total_write);
+
+=09=09/* Make sure used is visible before rasing the interrupt. */
+=09=09smp_wmb();
+
+=09=09local_bh_disable();
+=09=09if (txq->cb)
+=09=09=09txq->cb(txq->private);
+=09=09if (rxq->cb)
+=09=09=09rxq->cb(rxq->private);
+=09=09local_bh_enable();
+
+=09=09if (++pkts > 4) {
+=09=09=09schedule_work(&mvnet->work);
+=09=09=09goto out;
+=09=09}
+=09}
+
+out:
+=09spin_unlock(&mvnet->lock);
+}
+
+static dma_addr_t mvnet_map_page(struct device *dev, struct page *page,
+=09=09=09=09 unsigned long offset, size_t size,
+=09=09=09=09 enum dma_data_direction dir,
+=09=09=09=09 unsigned long attrs)
+{
+=09/* Vringh can only use HVA */
+=09return (dma_addr_t)(page_address(page) + offset);
+}
+
+static void mvnet_unmap_page(struct device *dev, dma_addr_t dma_addr,
+=09=09=09     size_t size, enum dma_data_direction dir,
+=09=09=09     unsigned long attrs)
+{
+}
+
+static void *mvnet_alloc_coherent(struct device *dev, size_t size,
+=09=09=09=09  dma_addr_t *dma_addr, gfp_t flag,
+=09=09=09=09  unsigned long attrs)
+{
+=09void *addr =3D kmalloc(size, flag);
+
+=09if (!addr)
+=09=09*dma_addr =3D DMA_MAPPING_ERROR;
+=09else
+=09=09*dma_addr =3D (dma_addr_t)addr;
+
+=09return addr;
+}
+
+static void mvnet_free_coherent(struct device *dev, size_t size,
+=09=09=09=09void *vaddr, dma_addr_t dma_addr,
+=09=09=09=09unsigned long attrs)
+{
+=09kfree((void *)dma_addr);
+}
+
+static const struct dma_map_ops mvnet_dma_ops =3D {
+=09.map_page =3D mvnet_map_page,
+=09.unmap_page =3D mvnet_unmap_page,
+=09.alloc =3D mvnet_alloc_coherent,
+=09.free =3D mvnet_free_coherent,
+};
+
+static const struct mdev_virtio_ops mdev_virtio_ops;
+
+static int mvnet_create(struct kobject *kobj, struct mdev_device *mdev)
+{
+=09struct mvnet_state *mvnet;
+=09struct virtio_net_config *config;
+=09struct device *dev =3D mdev_dev(mdev);
+
+=09if (!mdev)
+=09=09return -EINVAL;
+
+=09mvnet =3D kzalloc(sizeof(*mvnet), GFP_KERNEL);
+=09if (!mvnet)
+=09=09return -ENOMEM;
+
+=09mvnet->buffer =3D kmalloc(PAGE_SIZE, GFP_KERNEL);
+=09if (!mvnet->buffer) {
+=09=09kfree(mvnet);
+=09=09return -ENOMEM;
+=09}
+
+=09config =3D &mvnet->config;
+=09config->mtu =3D 1500;
+=09config->status =3D VIRTIO_NET_S_LINK_UP;
+=09eth_random_addr(config->mac);
+
+=09INIT_WORK(&mvnet->work, mvnet_work);
+
+=09spin_lock_init(&mvnet->lock);
+=09mvnet->mdev =3D mdev;
+=09mdev_set_drvdata(mdev, mvnet);
+
+=09mutex_lock(&mdev_list_lock);
+=09list_add(&mvnet->next, &mdev_devices_list);
+=09mutex_unlock(&mdev_list_lock);
+
+=09dev->coherent_dma_mask =3D DMA_BIT_MASK(64);
+=09set_dma_ops(dev, &mvnet_dma_ops);
+
+=09mdev_virtio_set_ops(mdev, &mdev_virtio_ops);
+=09mdev_virtio_set_class_id(mdev, MDEV_VIRTIO_CLASS_ID_VIRTIO);
+
+=09return 0;
+}
+
+static int mvnet_remove(struct mdev_device *mdev)
+{
+=09struct mvnet_state *mds, *tmp_mds;
+=09struct mvnet_state *mvnet =3D mdev_get_drvdata(mdev);
+=09int ret =3D -EINVAL;
+
+=09mutex_lock(&mdev_list_lock);
+=09list_for_each_entry_safe(mds, tmp_mds, &mdev_devices_list, next) {
+=09=09if (mvnet =3D=3D mds) {
+=09=09=09list_del(&mvnet->next);
+=09=09=09mdev_set_drvdata(mdev, NULL);
+=09=09=09kfree(mvnet->buffer);
+=09=09=09kfree(mvnet);
+=09=09=09ret =3D 0;
+=09=09=09break;
+=09=09}
+=09}
+=09mutex_unlock(&mdev_list_lock);
+
+=09return ret;
+}
+
+static ssize_t
+sample_mvnet_dev_show(struct device *dev, struct device_attribute *attr,
+=09=09      char *buf)
+{
+=09if (mdev_virtio_from_dev(dev))
+=09=09return sprintf(buf, "This is MDEV %s\n", dev_name(dev));
+
+=09return sprintf(buf, "\n");
+}
+
+static DEVICE_ATTR_RO(sample_mvnet_dev);
+
+static struct attribute *mvnet_dev_attrs[] =3D {
+=09&dev_attr_sample_mvnet_dev.attr,
+=09NULL,
+};
+
+static const struct attribute_group mvnet_dev_group =3D {
+=09.name  =3D "mvnet_dev",
+=09.attrs =3D mvnet_dev_attrs,
+};
+
+static const struct attribute_group *mvnet_dev_groups[] =3D {
+=09&mvnet_dev_group,
+=09NULL,
+};
+
+static ssize_t
+sample_mdev_dev_show(struct device *dev, struct device_attribute *attr,
+=09=09     char *buf)
+{
+=09if (mdev_virtio_from_dev(dev))
+=09=09return sprintf(buf, "This is MDEV %s\n", dev_name(dev));
+
+=09return sprintf(buf, "\n");
+}
+
+static DEVICE_ATTR_RO(sample_mdev_dev);
+
+static struct attribute *mdev_dev_attrs[] =3D {
+=09&dev_attr_sample_mdev_dev.attr,
+=09NULL,
+};
+
+static const struct attribute_group mdev_dev_group =3D {
+=09.name  =3D "vendor",
+=09.attrs =3D mdev_dev_attrs,
+};
+
+static const struct attribute_group *mdev_dev_groups[] =3D {
+=09&mdev_dev_group,
+=09NULL,
+};
+
+#define MVNET_STRING_LEN 16
+
+static ssize_t
+name_show(struct kobject *kobj, struct device *dev, char *buf)
+{
+=09char name[MVNET_STRING_LEN];
+=09const char *name_str =3D "virtio-net";
+
+=09snprintf(name, MVNET_STRING_LEN, "%s", dev_driver_string(dev));
+=09if (!strcmp(kobj->name, name))
+=09=09return sprintf(buf, "%s\n", name_str);
+
+=09return -EINVAL;
+}
+
+static MDEV_TYPE_ATTR_RO(name);
+
+static ssize_t
+available_instances_show(struct kobject *kobj, struct device *dev, char *b=
uf)
+{
+=09return sprintf(buf, "%d\n", INT_MAX);
+}
+
+static MDEV_TYPE_ATTR_RO(available_instances);
+
+static ssize_t device_api_show(struct kobject *kobj, struct device *dev,
+=09=09=09       char *buf)
+{
+=09return sprintf(buf, "%s\n", VIRTIO_MDEV_DEVICE_API_STRING);
+}
+
+static MDEV_TYPE_ATTR_RO(device_api);
+
+static struct attribute *mdev_types_attrs[] =3D {
+=09&mdev_type_attr_name.attr,
+=09&mdev_type_attr_device_api.attr,
+=09&mdev_type_attr_available_instances.attr,
+=09NULL,
+};
+
+static struct attribute_group mdev_type_group =3D {
+=09.name  =3D "virtio",
+=09.attrs =3D mdev_types_attrs,
+};
+
+/* TBD: "vhost" type */
+
+static struct attribute_group *mdev_type_groups[] =3D {
+=09&mdev_type_group,
+=09NULL,
+};
+
+static int mvnet_set_vq_address(struct mdev_device *mdev, u16 idx,
+=09=09=09=09u64 desc_area, u64 driver_area, u64 device_area)
+{
+=09struct mvnet_state *mvnet =3D mdev_get_drvdata(mdev);
+=09struct mvnet_virtqueue *vq =3D &mvnet->vqs[idx];
+
+=09vq->desc_addr =3D desc_area;
+=09vq->driver_addr =3D driver_area;
+=09vq->device_addr =3D device_area;
+
+=09return 0;
+}
+
+static void mvnet_set_vq_num(struct mdev_device *mdev, u16 idx, u32 num)
+{
+=09struct mvnet_state *mvnet =3D mdev_get_drvdata(mdev);
+=09struct mvnet_virtqueue *vq =3D &mvnet->vqs[idx];
+
+=09vq->num =3D num;
+}
+
+static void mvnet_kick_vq(struct mdev_device *mdev, u16 idx)
+{
+=09struct mvnet_state *mvnet =3D mdev_get_drvdata(mdev);
+=09struct mvnet_virtqueue *vq =3D &mvnet->vqs[idx];
+
+=09if (vq->ready)
+=09=09schedule_work(&mvnet->work);
+}
+
+static void mvnet_set_vq_cb(struct mdev_device *mdev, u16 idx,
+=09=09=09    struct virtio_mdev_callback *cb)
+{
+=09struct mvnet_state *mvnet =3D mdev_get_drvdata(mdev);
+=09struct mvnet_virtqueue *vq =3D &mvnet->vqs[idx];
+
+=09vq->cb =3D cb->callback;
+=09vq->private =3D cb->private;
+}
+
+static void mvnet_set_vq_ready(struct mdev_device *mdev, u16 idx, bool rea=
dy)
+{
+=09struct mvnet_state *mvnet =3D mdev_get_drvdata(mdev);
+=09struct mvnet_virtqueue *vq =3D &mvnet->vqs[idx];
+
+=09spin_lock(&mvnet->lock);
+=09vq->ready =3D ready;
+=09if (vq->ready)
+=09=09mvnet_queue_ready(mvnet, idx);
+=09spin_unlock(&mvnet->lock);
+}
+
+static bool mvnet_get_vq_ready(struct mdev_device *mdev, u16 idx)
+{
+=09struct mvnet_state *mvnet =3D mdev_get_drvdata(mdev);
+=09struct mvnet_virtqueue *vq =3D &mvnet->vqs[idx];
+
+=09return vq->ready;
+}
+
+static int mvnet_set_vq_state(struct mdev_device *mdev, u16 idx, u64 state=
)
+{
+=09struct mvnet_state *mvnet =3D mdev_get_drvdata(mdev);
+=09struct mvnet_virtqueue *vq =3D &mvnet->vqs[idx];
+=09struct vringh *vrh =3D &vq->vring;
+
+=09spin_lock(&mvnet->lock);
+=09vrh->last_avail_idx =3D state;
+=09spin_unlock(&mvnet->lock);
+
+=09return 0;
+}
+
+static u64 mvnet_get_vq_state(struct mdev_device *mdev, u16 idx)
+{
+=09struct mvnet_state *mvnet =3D mdev_get_drvdata(mdev);
+=09struct mvnet_virtqueue *vq =3D &mvnet->vqs[idx];
+=09struct vringh *vrh =3D &vq->vring;
+
+=09return vrh->last_avail_idx;
+}
+
+static u16 mvnet_get_vq_align(struct mdev_device *mdev)
+{
+=09return MVNET_QUEUE_ALIGN;
+}
+
+static u64 mvnet_get_features(struct mdev_device *mdev)
+{
+=09return mvnet_features;
+}
+
+static int mvnet_set_features(struct mdev_device *mdev, u64 features)
+{
+=09struct mvnet_state *mvnet =3D mdev_get_drvdata(mdev);
+
+=09/* DMA mapping must be done by driver */
+=09if (!(features & (1ULL << VIRTIO_F_IOMMU_PLATFORM)))
+=09=09return -EINVAL;
+
+=09mvnet->features =3D features & mvnet_features;
+
+=09return 0;
+}
+
+static void mvnet_set_config_cb(struct mdev_device *mdev,
+=09=09=09=09struct virtio_mdev_callback *cb)
+{
+=09/* We don't support config interrupt */
+}
+
+static u16 mvnet_get_vq_num_max(struct mdev_device *mdev)
+{
+=09return MVNET_QUEUE_MAX;
+}
+
+static u32 mvnet_get_device_id(struct mdev_device *mdev)
+{
+=09return MVNET_DEVICE_ID;
+}
+
+static u32 mvnet_get_vendor_id(struct mdev_device *mdev)
+{
+=09return MVNET_VENDOR_ID;
+}
+
+static u8 mvnet_get_status(struct mdev_device *mdev)
+{
+=09struct mvnet_state *mvnet =3D mdev_get_drvdata(mdev);
+
+=09return mvnet->status;
+}
+
+static void mvnet_set_status(struct mdev_device *mdev, u8 status)
+{
+=09struct mvnet_state *mvnet =3D mdev_get_drvdata(mdev);
+
+=09mvnet->status =3D status;
+
+=09if (status =3D=3D 0) {
+=09=09spin_lock(&mvnet->lock);
+=09=09mvnet_reset(mvnet);
+=09=09spin_unlock(&mvnet->lock);
+=09}
+}
+
+static void mvnet_get_config(struct mdev_device *mdev, unsigned int offset=
,
+=09=09=09     void *buf, unsigned int len)
+{
+=09struct mvnet_state *mvnet =3D mdev_get_drvdata(mdev);
+
+=09if (offset + len < sizeof(struct virtio_net_config))
+=09=09memcpy(buf, &mvnet->config + offset, len);
+}
+
+static void mvnet_set_config(struct mdev_device *mdev, unsigned int offset=
,
+=09=09=09     const void *buf, unsigned int len)
+{
+=09/* No writable config supportted by mvnet */
+}
+
+static u32 mvnet_get_generation(struct mdev_device *mdev)
+{
+=09struct mvnet_state *mvnet =3D mdev_get_drvdata(mdev);
+
+=09return mvnet->generation;
+}
+
+static const struct mdev_virtio_ops mdev_virtio_ops =3D {
+=09.set_vq_address         =3D mvnet_set_vq_address,
+=09.set_vq_num             =3D mvnet_set_vq_num,
+=09.kick_vq                =3D mvnet_kick_vq,
+=09.set_vq_cb              =3D mvnet_set_vq_cb,
+=09.set_vq_ready           =3D mvnet_set_vq_ready,
+=09.get_vq_ready           =3D mvnet_get_vq_ready,
+=09.set_vq_state           =3D mvnet_set_vq_state,
+=09.get_vq_state           =3D mvnet_get_vq_state,
+=09.get_vq_align           =3D mvnet_get_vq_align,
+=09.get_features           =3D mvnet_get_features,
+=09.set_features           =3D mvnet_set_features,
+=09.set_config_cb          =3D mvnet_set_config_cb,
+=09.get_vq_num_max         =3D mvnet_get_vq_num_max,
+=09.get_device_id          =3D mvnet_get_device_id,
+=09.get_vendor_id          =3D mvnet_get_vendor_id,
+=09.get_status             =3D mvnet_get_status,
+=09.set_status             =3D mvnet_set_status,
+=09.get_config             =3D mvnet_get_config,
+=09.set_config             =3D mvnet_set_config,
+=09.get_generation         =3D mvnet_get_generation,
+};
+
+static const struct mdev_parent_ops mdev_fops =3D {
+=09.owner                  =3D THIS_MODULE,
+=09.dev_attr_groups        =3D mvnet_dev_groups,
+=09.mdev_attr_groups       =3D mdev_dev_groups,
+=09.supported_type_groups  =3D mdev_type_groups,
+=09.create                 =3D mvnet_create,
+=09.remove=09=09=09=3D mvnet_remove,
+};
+
+static void mvnet_device_release(struct device *dev)
+{
+=09dev_dbg(dev, "mvnet: released\n");
+}
+
+static int __init mvnet_dev_init(void)
+{
+=09int ret =3D 0;
+
+=09pr_info("mvnet_dev: %s\n", __func__);
+
+=09memset(&mvnet_dev, 0, sizeof(mvnet_dev));
+
+=09idr_init(&mvnet_dev.vd_idr);
+
+=09mvnet_dev.vd_class =3D class_create(THIS_MODULE, MVNET_CLASS_NAME);
+
+=09if (IS_ERR(mvnet_dev.vd_class)) {
+=09=09pr_err("Error: failed to register mvnet_dev class\n");
+=09=09ret =3D PTR_ERR(mvnet_dev.vd_class);
+=09=09goto failed1;
+=09}
+
+=09mvnet_dev.dev.class =3D mvnet_dev.vd_class;
+=09mvnet_dev.dev.release =3D mvnet_device_release;
+=09dev_set_name(&mvnet_dev.dev, "%s", MVNET_NAME);
+
+=09ret =3D device_register(&mvnet_dev.dev);
+=09if (ret)
+=09=09goto failed2;
+
+=09ret =3D mdev_virtio_register_device(&mvnet_dev.dev, &mdev_fops);
+=09if (ret)
+=09=09goto failed3;
+
+=09mutex_init(&mdev_list_lock);
+=09INIT_LIST_HEAD(&mdev_devices_list);
+
+=09goto all_done;
+
+failed3:
+
+=09device_unregister(&mvnet_dev.dev);
+failed2:
+=09class_destroy(mvnet_dev.vd_class);
+
+failed1:
+all_done:
+=09return ret;
+}
+
+static void __exit mvnet_dev_exit(void)
+{
+=09mvnet_dev.dev.bus =3D NULL;
+=09mdev_virtio_unregister_device(&mvnet_dev.dev);
+
+=09device_unregister(&mvnet_dev.dev);
+=09idr_destroy(&mvnet_dev.vd_idr);
+=09class_destroy(mvnet_dev.vd_class);
+=09mvnet_dev.vd_class =3D NULL;
+=09pr_info("mvnet_dev: Unloaded!\n");
+}
+
+module_init(mvnet_dev_init)
+module_exit(mvnet_dev_exit)
+
+MODULE_LICENSE("GPL v2");
+MODULE_INFO(supported, "Simulate loopback ethernet device over mdev");
+MODULE_VERSION(VERSION_STRING);
+MODULE_AUTHOR(DRIVER_AUTHOR);
--=20
2.19.1

