Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 964DA10035E
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 12:02:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726962AbfKRLCS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 06:02:18 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:40999 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726690AbfKRLCS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 06:02:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574074936;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3ja26PSJK9ygpRuIQpXY0DayGYbCviriRvTlXBCNZRc=;
        b=IQV3/9jVahpx5ulmQj7W1LakbWfB9t4DfZ3+btAWmSPYDmwJSBFWhd+g0JPYE4nJ6S4isH
        b1vtEMp5qpjnJA8AUMs2/HcVsCza1tb7m8Ismw8GlxJKXmQcxSujIAWZDiUjyVPcfalstk
        yuEdjcHcF5DyBCTbTvCbJi8COcrtTKk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-57-tZBqeW2pONKR0-_5Ku4cEA-1; Mon, 18 Nov 2019 06:02:13 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E8FBB805319;
        Mon, 18 Nov 2019 11:02:07 +0000 (UTC)
Received: from jason-ThinkPad-X1-Carbon-6th.redhat.com (ovpn-12-65.pek2.redhat.com [10.72.12.65])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5B2D660BE1;
        Mon, 18 Nov 2019 11:01:42 +0000 (UTC)
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
Subject: [PATCH V13 4/6] mdev: introduce mediated virtio bus
Date:   Mon, 18 Nov 2019 18:59:21 +0800
Message-Id: <20191118105923.7991-5-jasowang@redhat.com>
In-Reply-To: <20191118105923.7991-1-jasowang@redhat.com>
References: <20191118105923.7991-1-jasowang@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: tZBqeW2pONKR0-_5Ku4cEA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch implements a mediated virtio bus over mdev framework. This
will be used by the future virtio-mdev and vhost-mdev on top to allow
driver from either userspace or kernel to control the device which is
capable of offloading virtio datapath.

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 MAINTAINERS                       |   2 +
 drivers/mdev/Kconfig              |  10 ++
 drivers/mdev/Makefile             |   2 +
 drivers/mdev/virtio.c             | 126 +++++++++++++++++++++++
 include/linux/mdev_virtio.h       | 163 ++++++++++++++++++++++++++++++
 include/linux/mod_devicetable.h   |   8 ++
 scripts/mod/devicetable-offsets.c |   3 +
 scripts/mod/file2alias.c          |  12 +++
 8 files changed, 326 insertions(+)
 create mode 100644 drivers/mdev/virtio.c
 create mode 100644 include/linux/mdev_virtio.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 5d7e8badf58c..e1b57c84f249 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17269,6 +17269,8 @@ F:=09include/linux/virtio*.h
 F:=09include/uapi/linux/virtio_*.h
 F:=09drivers/crypto/virtio/
 F:=09mm/balloon_compaction.c
+F:=09include/linux/mdev_virtio.h
+F:=09drivers/mdev/virtio.c
=20
 VIRTIO BLOCK AND SCSI DRIVERS
 M:=09"Michael S. Tsirkin" <mst@redhat.com>
diff --git a/drivers/mdev/Kconfig b/drivers/mdev/Kconfig
index 4561f2d4178f..cd84d4670552 100644
--- a/drivers/mdev/Kconfig
+++ b/drivers/mdev/Kconfig
@@ -17,3 +17,13 @@ config VFIO_MDEV
 =09  more details.
=20
 =09  If you don't know what do here, say N.
+
+config MDEV_VIRTIO
+       tristate "Mediated VIRTIO bus"
+       depends on VIRTIO && MDEV
+       default n
+       help
+=09  Proivdes a mediated BUS for virtio. It could be used by
+          either kenrel driver or userspace driver.
+
+=09  If you don't know what do here, say N.
diff --git a/drivers/mdev/Makefile b/drivers/mdev/Makefile
index 0b749e7f8ff4..eb14031c9944 100644
--- a/drivers/mdev/Makefile
+++ b/drivers/mdev/Makefile
@@ -1,5 +1,7 @@
=20
 mdev-y :=3D mdev_core.o mdev_sysfs.o mdev_driver.o
 mdev_vfio-y :=3D vfio.o
+mdev_virtio-y :=3D virtio.o
 obj-$(CONFIG_MDEV) +=3D mdev.o
 obj-$(CONFIG_VFIO_MDEV) +=3D mdev_vfio.o
+obj-$(CONFIG_MDEV_VIRTIO) +=3D mdev_virtio.o
diff --git a/drivers/mdev/virtio.c b/drivers/mdev/virtio.c
new file mode 100644
index 000000000000..25de329615c4
--- /dev/null
+++ b/drivers/mdev/virtio.c
@@ -0,0 +1,126 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Mediated VIRTIO bus
+ *
+ * Copyright (c) 2019, Red Hat. All rights reserved.
+ *     Author: Jason Wang <jasowang@redhat.com>
+ */
+
+#include <linux/module.h>
+#include <linux/uuid.h>
+#include <linux/device.h>
+#include <linux/mdev.h>
+#include <linux/mdev_virtio.h>
+#include <linux/mod_devicetable.h>
+
+#include "mdev_private.h"
+
+#define DRIVER_VERSION=09=09"0.1"
+#define DRIVER_AUTHOR=09=09"Jason Wang"
+#define DRIVER_DESC=09=09"Mediated VIRTIO bus"
+
+struct bus_type mdev_virtio_bus_type;
+
+struct mdev_virtio_device {
+=09struct mdev_device mdev;
+=09const struct mdev_virtio_ops *ops;
+=09u16 class_id;
+};
+
+#define to_mdev_virtio(mdev) container_of(mdev, \
+=09=09=09=09=09  struct mdev_virtio_device, mdev)
+#define to_mdev_virtio_drv(mdrv) container_of(mdrv, \
+=09=09=09=09=09      struct mdev_virtio_driver, drv)
+
+static int mdev_virtio_match(struct device *dev, struct device_driver *drv=
)
+{
+=09unsigned int i;
+=09struct mdev_device *mdev =3D mdev_from_dev(dev, &mdev_virtio_bus_type);
+=09struct mdev_virtio_device *mdev_virtio =3D to_mdev_virtio(mdev);
+=09struct mdev_driver *mdrv =3D to_mdev_driver(drv);
+=09struct mdev_virtio_driver *mdrv_virtio =3D to_mdev_virtio_drv(mdrv);
+=09const struct mdev_virtio_class_id *ids =3D mdrv_virtio->id_table;
+
+=09if (!ids)
+=09=09return 0;
+
+=09for (i =3D 0; ids[i].id; i++)
+=09=09if (ids[i].id =3D=3D mdev_virtio->class_id)
+=09=09=09return 1;
+=09return 0;
+}
+
+static int mdev_virtio_uevent(struct device *dev, struct kobj_uevent_env *=
env)
+{
+=09struct mdev_device *mdev =3D mdev_from_dev(dev, &mdev_virtio_bus_type);
+=09struct mdev_virtio_device *mdev_virtio =3D to_mdev_virtio(mdev);
+
+=09return add_uevent_var(env, "MODALIAS=3Dmdev_virtio:c%02X",
+=09=09=09      mdev_virtio->class_id);
+}
+
+struct bus_type mdev_virtio_bus_type =3D {
+=09.name=09=09=3D "mdev_virtio",
+=09.probe=09=09=3D mdev_probe,
+=09.remove=09=09=3D mdev_remove,
+=09.match=09        =3D mdev_virtio_match,
+=09.uevent=09=09=3D mdev_virtio_uevent,
+};
+EXPORT_SYMBOL(mdev_virtio_bus_type);
+
+void mdev_virtio_set_class_id(struct mdev_device *mdev, u16 class_id)
+{
+=09struct mdev_virtio_device *mdev_virtio =3D to_mdev_virtio(mdev);
+
+=09mdev_virtio->class_id =3D class_id;
+}
+EXPORT_SYMBOL(mdev_virtio_set_class_id);
+
+int mdev_virtio_register_device(struct device *dev,
+=09=09=09=09const struct mdev_parent_ops *ops)
+{
+=09return mdev_register_device(dev, ops, &mdev_virtio_bus_type,
+=09=09=09=09    sizeof(struct mdev_virtio_device));
+}
+EXPORT_SYMBOL(mdev_virtio_register_device);
+
+void mdev_virtio_unregister_device(struct device *dev)
+{
+=09return mdev_unregister_device(dev);
+}
+EXPORT_SYMBOL(mdev_virtio_unregister_device);
+
+void mdev_virtio_set_ops(struct mdev_device *mdev,
+=09=09=09 const struct mdev_virtio_ops *ops)
+{
+=09struct mdev_virtio_device *mdev_virtio =3D to_mdev_virtio(mdev);
+
+=09mdev_virtio->ops =3D ops;
+}
+EXPORT_SYMBOL(mdev_virtio_set_ops);
+
+const struct mdev_virtio_ops *mdev_virtio_get_ops(struct mdev_device *mdev=
)
+{
+=09struct mdev_virtio_device *mdev_virtio =3D to_mdev_virtio(mdev);
+
+=09return mdev_virtio->ops;
+}
+EXPORT_SYMBOL(mdev_virtio_get_ops);
+
+static int __init mdev_init(void)
+{
+=09return mdev_register_bus(&mdev_virtio_bus_type);
+}
+
+static void __exit mdev_exit(void)
+{
+=09mdev_unregister_bus(&mdev_virtio_bus_type);
+}
+
+module_init(mdev_init)
+module_exit(mdev_exit)
+
+MODULE_VERSION(DRIVER_VERSION);
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR(DRIVER_AUTHOR);
+MODULE_DESCRIPTION(DRIVER_DESC);
diff --git a/include/linux/mdev_virtio.h b/include/linux/mdev_virtio.h
new file mode 100644
index 000000000000..ef2dbb6c383a
--- /dev/null
+++ b/include/linux/mdev_virtio.h
@@ -0,0 +1,163 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * VIRTIO Mediated device definition
+ *
+ * Copyright (c) 2019, Red Hat. All rights reserved.
+ *     Author: Jason Wang <jasowang@redhat.com>
+ */
+
+#ifndef VIRTIO_MDEV_H
+#define VIRTIO_MDEV_H
+
+#include <linux/interrupt.h>
+#include <linux/mod_devicetable.h>
+#include <linux/mdev.h>
+
+extern struct bus_type mdev_virtio_bus_type;
+
+struct mdev_virtio_driver {
+=09struct mdev_driver drv;
+=09const struct mdev_virtio_class_id *id_table;
+};
+
+struct virtio_mdev_callback {
+=09irqreturn_t (*callback)(void *data);
+=09void *private;
+};
+
+/**
+ * struct mdev_virtio_device_ops - Structure to be registered for each
+ * mdev device to register the device for virtio/vhost drivers.
+ *
+ * The callbacks are mandatory unless explicitly mentioned.
+ *
+ * @set_vq_address:=09=09Set the address of virtqueue
+ *=09=09=09=09@mdev: mediated device
+ *=09=09=09=09@idx: virtqueue index
+ *=09=09=09=09@desc_area: address of desc area
+ *=09=09=09=09@driver_area: address of driver area
+ *=09=09=09=09@device_area: address of device area
+ *=09=09=09=09Returns integer: success (0) or error (< 0)
+ * @set_vq_num:=09=09=09Set the size of virtqueue
+ *=09=09=09=09@mdev: mediated device
+ *=09=09=09=09@idx: virtqueue index
+ *=09=09=09=09@num: the size of virtqueue
+ * @kick_vq:=09=09=09Kick the virtqueue
+ *=09=09=09=09@mdev: mediated device
+ *=09=09=09=09@idx: virtqueue index
+ * @set_vq_cb:=09=09=09Set the interrupt callback function for
+ *=09=09=09=09a virtqueue
+ *=09=09=09=09@mdev: mediated device
+ *=09=09=09=09@idx: virtqueue index
+ *=09=09=09=09@cb: virtio-mdev interrupt callback structure
+ * @set_vq_ready:=09=09Set ready status for a virtqueue
+ *=09=09=09=09@mdev: mediated device
+ *=09=09=09=09@idx: virtqueue index
+ *=09=09=09=09@ready: ready (true) not ready(false)
+ * @get_vq_ready:=09=09Get ready status for a virtqueue
+ *=09=09=09=09@mdev: mediated device
+ *=09=09=09=09@idx: virtqueue index
+ *=09=09=09=09Returns boolean: ready (true) or not (false)
+ * @set_vq_state:=09=09Set the state for a virtqueue
+ *=09=09=09=09@mdev: mediated device
+ *=09=09=09=09@idx: virtqueue index
+ *=09=09=09=09@state: virtqueue state (last_avail_idx)
+ *=09=09=09=09Returns integer: success (0) or error (< 0)
+ * @get_vq_state:=09=09Get the state for a virtqueue
+ *=09=09=09=09@mdev: mediated device
+ *=09=09=09=09@idx: virtqueue index
+ *=09=09=09=09Returns virtqueue state (last_avail_idx)
+ * @get_vq_align:=09=09Get the virtqueue align requirement
+ *=09=09=09=09for the device
+ *=09=09=09=09@mdev: mediated device
+ *=09=09=09=09Returns virtqueue algin requirement
+ * @get_features:=09=09Get virtio features supported by the device
+ *=09=09=09=09@mdev: mediated device
+ *=09=09=09=09Returns the virtio features support by the
+ *=09=09=09=09device
+ * @set_features:=09=09Set virtio features supported by the driver
+ *=09=09=09=09@mdev: mediated device
+ *=09=09=09=09@features: feature support by the driver
+ *=09=09=09=09Returns integer: success (0) or error (< 0)
+ * @set_config_cb:=09=09Set the config interrupt callback
+ *=09=09=09=09@mdev: mediated device
+ *=09=09=09=09@cb: virtio-mdev interrupt callback structure
+ * @get_vq_num_max:=09=09Get the max size of virtqueue
+ *=09=09=09=09@mdev: mediated device
+ *=09=09=09=09Returns u16: max size of virtqueue
+ * @get_device_id:=09=09Get virtio device id
+ *=09=09=09=09@mdev: mediated device
+ *=09=09=09=09Returns u32: virtio device id
+ * @get_vendor_id:=09=09Get id for the vendor that provides this device
+ *=09=09=09=09@mdev: mediated device
+ *=09=09=09=09Returns u32: virtio vendor id
+ * @get_status:=09=09=09Get the device status
+ *=09=09=09=09@mdev: mediated device
+ *=09=09=09=09Returns u8: virtio device status
+ * @set_status:=09=09=09Set the device status
+ *=09=09=09=09@mdev: mediated device
+ *=09=09=09=09@status: virtio device status
+ * @get_config:=09=09=09Read from device specific configuration space
+ *=09=09=09=09@mdev: mediated device
+ *=09=09=09=09@offset: offset from the beginning of
+ *=09=09=09=09configuration space
+ *=09=09=09=09@buf: buffer used to read to
+ *=09=09=09=09@len: the length to read from
+ *=09=09=09=09configration space
+ * @set_config:=09=09=09Write to device specific configuration space
+ *=09=09=09=09@mdev: mediated device
+ *=09=09=09=09@offset: offset from the beginning of
+ *=09=09=09=09configuration space
+ *=09=09=09=09@buf: buffer used to write from
+ *=09=09=09=09@len: the length to write to
+ *=09=09=09=09configration space
+ * @get_generation:=09=09Get device config generaton (optional)
+ *=09=09=09=09@mdev: mediated device
+ *=09=09=09=09Returns u32: device generation
+ */
+struct mdev_virtio_ops {
+=09/* Virtqueue ops */
+=09int (*set_vq_address)(struct mdev_device *mdev,
+=09=09=09      u16 idx, u64 desc_area, u64 driver_area,
+=09=09=09      u64 device_area);
+=09void (*set_vq_num)(struct mdev_device *mdev, u16 idx, u32 num);
+=09void (*kick_vq)(struct mdev_device *mdev, u16 idx);
+=09void (*set_vq_cb)(struct mdev_device *mdev, u16 idx,
+=09=09=09  struct virtio_mdev_callback *cb);
+=09void (*set_vq_ready)(struct mdev_device *mdev, u16 idx, bool ready);
+=09bool (*get_vq_ready)(struct mdev_device *mdev, u16 idx);
+=09int (*set_vq_state)(struct mdev_device *mdev, u16 idx, u64 state);
+=09u64 (*get_vq_state)(struct mdev_device *mdev, u16 idx);
+
+=09/* Device ops */
+=09u16 (*get_vq_align)(struct mdev_device *mdev);
+=09u64 (*get_features)(struct mdev_device *mdev);
+=09int (*set_features)(struct mdev_device *mdev, u64 features);
+=09void (*set_config_cb)(struct mdev_device *mdev,
+=09=09=09      struct virtio_mdev_callback *cb);
+=09u16 (*get_vq_num_max)(struct mdev_device *mdev);
+=09u32 (*get_device_id)(struct mdev_device *mdev);
+=09u32 (*get_vendor_id)(struct mdev_device *mdev);
+=09u8 (*get_status)(struct mdev_device *mdev);
+=09void (*set_status)(struct mdev_device *mdev, u8 status);
+=09void (*get_config)(struct mdev_device *mdev, unsigned int offset,
+=09=09=09   void *buf, unsigned int len);
+=09void (*set_config)(struct mdev_device *mdev, unsigned int offset,
+=09=09=09   const void *buf, unsigned int len);
+=09u32 (*get_generation)(struct mdev_device *mdev);
+};
+
+int mdev_virtio_register_device(struct device *dev,
+=09=09=09=09const struct mdev_parent_ops *ops);
+void mdev_virtio_unregister_device(struct device *dev);
+void mdev_virtio_set_ops(struct mdev_device *mdev,
+=09=09=09 const struct mdev_virtio_ops *ops);
+const struct mdev_virtio_ops *mdev_virtio_get_ops(struct mdev_device *mdev=
);
+void mdev_virtio_set_class_id(struct mdev_device *mdev, u16 class_id);
+
+static inline struct mdev_device *mdev_virtio_from_dev(struct device *dev)
+{
+=09return mdev_from_dev(dev, &mdev_virtio_bus_type);
+}
+
+#endif
diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetabl=
e.h
index 5714fd35a83c..59006c47ae8e 100644
--- a/include/linux/mod_devicetable.h
+++ b/include/linux/mod_devicetable.h
@@ -821,4 +821,12 @@ struct wmi_device_id {
 =09const void *context;
 };
=20
+/**
+ * struct mdev_class_id - MDEV VIRTIO device class identifier
+ * @id: Used to identify a specific class of device, e.g vfio-mdev device.
+ */
+struct mdev_virtio_class_id {
+=09__u16 id;
+};
+
 #endif /* LINUX_MOD_DEVICETABLE_H */
diff --git a/scripts/mod/devicetable-offsets.c b/scripts/mod/devicetable-of=
fsets.c
index 054405b90ba4..178fd7c70812 100644
--- a/scripts/mod/devicetable-offsets.c
+++ b/scripts/mod/devicetable-offsets.c
@@ -231,5 +231,8 @@ int main(void)
 =09DEVID(wmi_device_id);
 =09DEVID_FIELD(wmi_device_id, guid_string);
=20
+=09DEVID(mdev_virtio_class_id);
+=09DEVID_FIELD(mdev_virtio_class_id, id);
+
 =09return 0;
 }
diff --git a/scripts/mod/file2alias.c b/scripts/mod/file2alias.c
index c91eba751804..1a9c1f591951 100644
--- a/scripts/mod/file2alias.c
+++ b/scripts/mod/file2alias.c
@@ -1335,6 +1335,17 @@ static int do_wmi_entry(const char *filename, void *=
symval, char *alias)
 =09return 1;
 }
=20
+/* looks like: "mdev_virtio:cN" */
+static int do_mdev_virtio_entry(const char *filename, void *symval, char *=
alias)
+{
+=09DEF_FIELD(symval, mdev_virtio_class_id, id);
+
+=09sprintf(alias, "mdev_virtio:c%02X", id);
+=09add_wildcard(alias);
+=09return 1;
+}
+
+
 /* Does namelen bytes of name exactly match the symbol? */
 static bool sym_is(const char *name, unsigned namelen, const char *symbol)
 {
@@ -1407,6 +1418,7 @@ static const struct devtable devtable[] =3D {
 =09{"typec", SIZE_typec_device_id, do_typec_entry},
 =09{"tee", SIZE_tee_client_device_id, do_tee_entry},
 =09{"wmi", SIZE_wmi_device_id, do_wmi_entry},
+=09{"mdev_virtio", SIZE_mdev_virtio_class_id, do_mdev_virtio_entry},
 };
=20
 /* Create MODULE_ALIAS() statements.
--=20
2.19.1

