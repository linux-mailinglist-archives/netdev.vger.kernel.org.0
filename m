Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F190310034B
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 12:01:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727168AbfKRLBY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 06:01:24 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:24635 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726759AbfKRLBY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 06:01:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574074882;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6DoQm74RSCpeQhI+YxCpZNVLKAnHbq31aGrQkfVfEos=;
        b=APYkbWxQvAuSWy6MOlutHq/SrTIn8J15r4FTii23BoU+NBSxyTUUSTvpE3JUyrwfmGpsrX
        QCLK06qaKTe/sjW/tBORWN3w1Z/D5YtJtsi6JjRIAmGL+dF6Uk1Az9OYALVLmI6gxbWDjY
        2TOwuhv8Miw1vBIgQ5dyk0p8vapUTCA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-350-wF7T_dpMNe6BGnaej4Vl5w-1; Mon, 18 Nov 2019 06:01:17 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 291E9107BABB;
        Mon, 18 Nov 2019 11:01:13 +0000 (UTC)
Received: from jason-ThinkPad-X1-Carbon-6th.redhat.com (ovpn-12-65.pek2.redhat.com [10.72.12.65])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5A86D60BE1;
        Mon, 18 Nov 2019 11:00:42 +0000 (UTC)
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
Subject: [PATCH V13 2/6] mdev: split out VFIO bus specific parent ops
Date:   Mon, 18 Nov 2019 18:59:19 +0800
Message-Id: <20191118105923.7991-3-jasowang@redhat.com>
In-Reply-To: <20191118105923.7991-1-jasowang@redhat.com>
References: <20191118105923.7991-1-jasowang@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: wF7T_dpMNe6BGnaej4Vl5w-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The only thing left for generalizing mdev is the VFIO specific parent
ops. This is basically the open/release/read/write/ioctl/mmap.

To support this, mdev core is extend to support a specific size
of structure during create, this will allow to compose mdev structure
into mdev vfio structure and place the VFIO specific callbacks there
like:

struct mdev_vfio {
       struct mdev_device mdev;
       const struct mdev_vfio_ops *ops;
};

Helpers for setting and getting the ops were introduced to support
mdev vfio device to set ops and vfio mdev driver to use the ops.

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 .../driver-api/vfio-mediated-device.rst       | 34 +++++++++------
 drivers/gpu/drm/i915/gvt/kvmgt.c              | 16 ++++---
 drivers/s390/cio/vfio_ccw_ops.c               | 17 +++++---
 drivers/s390/crypto/vfio_ap_ops.c             | 13 ++++--
 drivers/vfio/mdev/mdev_core.c                 |  5 ++-
 drivers/vfio/mdev/mdev_private.h              |  5 +++
 drivers/vfio/mdev/mdev_vfio.c                 | 30 ++++++++++++-
 drivers/vfio/mdev/vfio_mdev.c                 | 38 ++++++++--------
 include/linux/mdev.h                          | 37 ----------------
 include/linux/mdev_vfio.h                     | 43 +++++++++++++++++++
 samples/vfio-mdev/mbochs.c                    | 18 +++++---
 samples/vfio-mdev/mdpy.c                      | 19 +++++---
 samples/vfio-mdev/mtty.c                      | 16 ++++---
 13 files changed, 189 insertions(+), 102 deletions(-)

diff --git a/Documentation/driver-api/vfio-mediated-device.rst b/Documentat=
ion/driver-api/vfio-mediated-device.rst
index 1887d27a565e..9045584e4ea3 100644
--- a/Documentation/driver-api/vfio-mediated-device.rst
+++ b/Documentation/driver-api/vfio-mediated-device.rst
@@ -153,26 +153,36 @@ callbacks per mdev parent device, per mdev type, or a=
ny other categorization.
 Vendor drivers are expected to be fully asynchronous in this respect or
 provide their own internal resource protection.)
=20
-The callbacks in the mdev_parent_ops structure are as follows:
+A driver should use the mdev_parent_ops structure in the function call
+to register itself with the mdev core driver::
=20
-* open: open callback of mediated device
-* close: close callback of mediated device
-* ioctl: ioctl callback of mediated device
+=09extern int mdev_vfio_register_device(struct device *dev,
+                                             const struct mdev_parent_ops =
*ops);
+
+However, the mdev_parent_ops structure is not required in the function cal=
l
+that a driver should use to unregister itself with the mdev core driver::
+
+=09extern void mdev_vfio_unregister_device(struct device *dev);
+
+The VFIO specific callbacks is abstracted in mdev_vfio_ops structure
+are as follows:
+
+* open: open callback of VFIO mediated device
+* close: close callback of VFIO mediated device
+* ioctl: ioctl callback of VFIO mediated device
 * read : read emulation callback
 * write: write emulation callback
 * mmap: mmap emulation callback
=20
-A driver should use the mdev_parent_ops structure and bus type in the
-function call to register itself with the mdev core driver::
+During the creation of VFIO mediated device, mdev_vfio_ops need to be
+specified::
=20
-=09extern int  mdev_register_device(struct device *dev,
-=09                                 const struct mdev_parent_ops *ops,
-                                         struct bus_type *bus);
+=09 void mdev_vfio_set_ops(struct mdev_device *mdev,
+                                const struct mdev_vfio_ops *ops);
=20
-However, the mdev_parent_ops structure is not required in the function cal=
l
-that a driver should use to unregister itself with the mdev core driver::
+Those callbacks could be fetched by drivers through::
=20
-=09extern void mdev_unregister_device(struct device *dev);
+=09 const struct mdev_vfio_ops *mdev_vfio_get_ops(struct mdev_device *mdev=
);
=20
=20
 Mediated Device Management Interface Through sysfs
diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kv=
mgt.c
index afdb3de5ce2f..e72c36174035 100644
--- a/drivers/gpu/drm/i915/gvt/kvmgt.c
+++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
@@ -643,6 +643,8 @@ static void kvmgt_put_vfio_device(void *vgpu)
 =09vfio_device_put(((struct intel_vgpu *)vgpu)->vdev.vfio_device);
 }
=20
+static const struct mdev_vfio_ops intel_mdev_vfio_ops;
+
 static int intel_vgpu_create(struct kobject *kobj, struct mdev_device *mde=
v)
 {
 =09struct intel_vgpu *vgpu =3D NULL;
@@ -678,6 +680,7 @@ static int intel_vgpu_create(struct kobject *kobj, stru=
ct mdev_device *mdev)
 =09=09     dev_name(mdev_dev(mdev)));
 =09ret =3D 0;
=20
+=09mdev_vfio_set_ops(mdev, &intel_mdev_vfio_ops);
 out:
 =09return ret;
 }
@@ -1581,20 +1584,21 @@ static const struct attribute_group *intel_vgpu_gro=
ups[] =3D {
 =09NULL,
 };
=20
-static struct mdev_parent_ops intel_vgpu_ops =3D {
-=09.mdev_attr_groups       =3D intel_vgpu_groups,
-=09.create=09=09=09=3D intel_vgpu_create,
-=09.remove=09=09=09=3D intel_vgpu_remove,
-
+static const struct mdev_vfio_ops intel_mdev_vfio_ops =3D {
 =09.open=09=09=09=3D intel_vgpu_open,
 =09.release=09=09=3D intel_vgpu_release,
-
 =09.read=09=09=09=3D intel_vgpu_read,
 =09.write=09=09=09=3D intel_vgpu_write,
 =09.mmap=09=09=09=3D intel_vgpu_mmap,
 =09.ioctl=09=09=09=3D intel_vgpu_ioctl,
 };
=20
+static struct mdev_parent_ops intel_vgpu_ops =3D {
+=09.mdev_attr_groups       =3D intel_vgpu_groups,
+=09.create=09=09=09=3D intel_vgpu_create,
+=09.remove=09=09=09=3D intel_vgpu_remove,
+};
+
 static int kvmgt_host_init(struct device *dev, void *gvt, const void *ops)
 {
 =09struct attribute **kvm_type_attrs;
diff --git a/drivers/s390/cio/vfio_ccw_ops.c b/drivers/s390/cio/vfio_ccw_op=
s.c
index 791b8b0eb027..811f0a3b1903 100644
--- a/drivers/s390/cio/vfio_ccw_ops.c
+++ b/drivers/s390/cio/vfio_ccw_ops.c
@@ -110,6 +110,8 @@ static struct attribute_group *mdev_type_groups[] =3D {
 =09NULL,
 };
=20
+static const struct mdev_vfio_ops vfio_ccw_mdev_vfio_ops;
+
 static int vfio_ccw_mdev_create(struct kobject *kobj, struct mdev_device *=
mdev)
 {
 =09struct vfio_ccw_private *private =3D
@@ -129,6 +131,8 @@ static int vfio_ccw_mdev_create(struct kobject *kobj, s=
truct mdev_device *mdev)
 =09=09=09   private->sch->schid.ssid,
 =09=09=09   private->sch->schid.sch_no);
=20
+=09mdev_vfio_set_ops(mdev, &vfio_ccw_mdev_vfio_ops);
+
 =09return 0;
 }
=20
@@ -574,16 +578,19 @@ static ssize_t vfio_ccw_mdev_ioctl(struct mdev_device=
 *mdev,
 =09}
 }
=20
-static const struct mdev_parent_ops vfio_ccw_mdev_ops =3D {
-=09.owner=09=09=09=3D THIS_MODULE,
-=09.supported_type_groups  =3D mdev_type_groups,
-=09.create=09=09=09=3D vfio_ccw_mdev_create,
-=09.remove=09=09=09=3D vfio_ccw_mdev_remove,
+static const struct mdev_vfio_ops vfio_ccw_mdev_vfio_ops =3D {
 =09.open=09=09=09=3D vfio_ccw_mdev_open,
 =09.release=09=09=3D vfio_ccw_mdev_release,
 =09.read=09=09=09=3D vfio_ccw_mdev_read,
 =09.write=09=09=09=3D vfio_ccw_mdev_write,
 =09.ioctl=09=09=09=3D vfio_ccw_mdev_ioctl,
+}
+
+static const struct mdev_parent_ops vfio_ccw_mdev_ops =3D {
+=09.owner=09=09=09=3D THIS_MODULE,
+=09.supported_type_groups  =3D mdev_type_groups,
+=09.create=09=09=09=3D vfio_ccw_mdev_create,
+=09.remove=09=09=09=3D vfio_ccw_mdev_remove,
 };
=20
 int vfio_ccw_mdev_reg(struct subchannel *sch)
diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_a=
p_ops.c
index 78048e670374..0649c68287d7 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -321,6 +321,8 @@ static void vfio_ap_matrix_init(struct ap_config_info *=
info,
 =09matrix->adm_max =3D info->apxa ? info->Nd : 15;
 }
=20
+static const struct mdev_vfio_ops vfio_ap_matrix_mdev_ops;
+
 static int vfio_ap_mdev_create(struct kobject *kobj, struct mdev_device *m=
dev)
 {
 =09struct ap_matrix_mdev *matrix_mdev;
@@ -343,6 +345,8 @@ static int vfio_ap_mdev_create(struct kobject *kobj, st=
ruct mdev_device *mdev)
 =09list_add(&matrix_mdev->node, &matrix_dev->mdev_list);
 =09mutex_unlock(&matrix_dev->lock);
=20
+=09mdev_vfio_set_ops(mdev, &vfio_ap_matrix_mdev_ops);
+
 =09return 0;
 }
=20
@@ -1280,15 +1284,18 @@ static ssize_t vfio_ap_mdev_ioctl(struct mdev_devic=
e *mdev,
 =09return ret;
 }
=20
+static const struct mdev_vfio_ops vfio_ap_matrix_mdev_ops =3D {
+=09.open=09=09=09=3D vfio_ap_mdev_open,
+=09.release=09=09=3D vfio_ap_mdev_release,
+=09.ioctl=09=09=09=3D vfio_ap_mdev_ioctl,
+}
+
 static const struct mdev_parent_ops vfio_ap_matrix_ops =3D {
 =09.owner=09=09=09=3D THIS_MODULE,
 =09.supported_type_groups=09=3D vfio_ap_mdev_type_groups,
 =09.mdev_attr_groups=09=3D vfio_ap_mdev_attr_groups,
 =09.create=09=09=09=3D vfio_ap_mdev_create,
 =09.remove=09=09=09=3D vfio_ap_mdev_remove,
-=09.open=09=09=09=3D vfio_ap_mdev_open,
-=09.release=09=09=3D vfio_ap_mdev_release,
-=09.ioctl=09=09=09=3D vfio_ap_mdev_ioctl,
 };
=20
 int vfio_ap_mdev_register(void)
diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core.c
index e1272a40c521..c6bc67bf63fa 100644
--- a/drivers/vfio/mdev/mdev_core.c
+++ b/drivers/vfio/mdev/mdev_core.c
@@ -179,7 +179,7 @@ static struct class_compat *mdev_alloc_class_compat(str=
uct bus_type *bus)
  * Returns a negative value on error, otherwise 0.
  */
 int mdev_register_device(struct device *dev, const struct mdev_parent_ops =
*ops,
-=09=09=09 struct bus_type *bus)
+=09=09=09 struct bus_type *bus, size_t dev_size)
 {
 =09int ret;
 =09struct mdev_parent *parent;
@@ -217,6 +217,7 @@ int mdev_register_device(struct device *dev, const stru=
ct mdev_parent_ops *ops,
 =09parent->dev =3D dev;
 =09parent->ops =3D ops;
 =09parent->bus =3D bus;
+=09parent->dev_size =3D dev_size;
=20
 =09mutex_lock(&compat_list_lock);
 =09class_compat =3D mdev_alloc_class_compat(bus);
@@ -339,7 +340,7 @@ int mdev_device_create(struct kobject *kobj,
 =09=09}
 =09}
=20
-=09mdev =3D kzalloc(sizeof(*mdev), GFP_KERNEL);
+=09mdev =3D kzalloc(parent->dev_size, GFP_KERNEL);
 =09if (!mdev) {
 =09=09mutex_unlock(&mdev_list_lock);
 =09=09ret =3D -ENOMEM;
diff --git a/drivers/vfio/mdev/mdev_private.h b/drivers/vfio/mdev/mdev_priv=
ate.h
index 298d7a0f493a..012ab80719e9 100644
--- a/drivers/vfio/mdev/mdev_private.h
+++ b/drivers/vfio/mdev/mdev_private.h
@@ -20,6 +20,7 @@ struct mdev_parent {
 =09struct list_head type_list;
 =09/* Synchronize device creation/removal with parent unregistration */
 =09struct rw_semaphore unreg_sem;
+=09size_t dev_size;
 };
=20
 struct mdev_device {
@@ -66,4 +67,8 @@ int  mdev_device_create(struct kobject *kobj,
 =09=09=09struct device *dev, const guid_t *uuid);
 int  mdev_device_remove(struct device *dev);
=20
+int mdev_register_device(struct device *dev, const struct mdev_parent_ops =
*ops,
+=09=09=09 struct bus_type *bus, size_t dev_size);
+void mdev_unregister_device(struct device *dev);
+
 #endif /* MDEV_PRIVATE_H */
diff --git a/drivers/vfio/mdev/mdev_vfio.c b/drivers/vfio/mdev/mdev_vfio.c
index f9d1191b9982..44e116074f88 100644
--- a/drivers/vfio/mdev/mdev_vfio.c
+++ b/drivers/vfio/mdev/mdev_vfio.c
@@ -4,6 +4,8 @@
 #include <linux/device.h>
 #include <linux/mdev_vfio.h>
=20
+#include "mdev_private.h"
+
 #define DRIVER_VERSION=09=09"0.1"
 #define DRIVER_AUTHOR=09=09"Jason Wang"
 #define DRIVER_DESC=09=09"Mediated VFIO bus"
@@ -15,6 +17,31 @@ struct bus_type mdev_vfio_bus_type =3D {
 };
 EXPORT_SYMBOL(mdev_vfio_bus_type);
=20
+#define to_vfio_mdev_device(mdev) container_of(mdev, \
+=09=09=09=09=09       struct mdev_vfio_device, mdev)
+
+struct mdev_vfio_device {
+=09struct mdev_device mdev;
+=09const struct mdev_vfio_ops *ops;
+};
+
+void mdev_vfio_set_ops(struct mdev_device *mdev,
+=09=09       const struct mdev_vfio_ops *ops)
+{
+=09struct mdev_vfio_device *mdev_vfio =3D to_vfio_mdev_device(mdev);
+
+=09mdev_vfio->ops =3D ops;
+}
+EXPORT_SYMBOL(mdev_vfio_set_ops);
+
+const struct mdev_vfio_ops *mdev_vfio_get_ops(struct mdev_device *mdev)
+{
+=09struct mdev_vfio_device *mdev_vfio =3D to_vfio_mdev_device(mdev);
+
+=09return mdev_vfio->ops;
+}
+EXPORT_SYMBOL(mdev_vfio_get_ops);
+
 static int __init mdev_init(void)
 {
 =09return mdev_register_bus(&mdev_vfio_bus_type);
@@ -28,7 +55,8 @@ static void __exit mdev_exit(void)
 int mdev_vfio_register_device(struct device *dev,
 =09=09=09      const struct mdev_parent_ops *ops)
 {
-=09return mdev_register_device(dev, ops, &mdev_vfio_bus_type);
+=09return mdev_register_device(dev, ops, &mdev_vfio_bus_type,
+=09=09=09=09    sizeof(struct mdev_vfio_device));
 }
 EXPORT_SYMBOL(mdev_vfio_register_device);
=20
diff --git a/drivers/vfio/mdev/vfio_mdev.c b/drivers/vfio/mdev/vfio_mdev.c
index 16e9ebe30d4a..8b42a4b3f161 100644
--- a/drivers/vfio/mdev/vfio_mdev.c
+++ b/drivers/vfio/mdev/vfio_mdev.c
@@ -24,16 +24,16 @@
 static int vfio_mdev_open(void *device_data)
 {
 =09struct mdev_device *mdev =3D device_data;
-=09struct mdev_parent *parent =3D mdev->parent;
+=09const struct mdev_vfio_ops *ops =3D mdev_vfio_get_ops(mdev);
 =09int ret;
=20
-=09if (unlikely(!parent->ops->open))
+=09if (unlikely(!ops->open))
 =09=09return -EINVAL;
=20
 =09if (!try_module_get(THIS_MODULE))
 =09=09return -ENODEV;
=20
-=09ret =3D parent->ops->open(mdev);
+=09ret =3D ops->open(mdev);
 =09if (ret)
 =09=09module_put(THIS_MODULE);
=20
@@ -43,10 +43,10 @@ static int vfio_mdev_open(void *device_data)
 static void vfio_mdev_release(void *device_data)
 {
 =09struct mdev_device *mdev =3D device_data;
-=09struct mdev_parent *parent =3D mdev->parent;
+=09const struct mdev_vfio_ops *ops =3D mdev_vfio_get_ops(mdev);
=20
-=09if (likely(parent->ops->release))
-=09=09parent->ops->release(mdev);
+=09if (likely(ops->release))
+=09=09ops->release(mdev);
=20
 =09module_put(THIS_MODULE);
 }
@@ -55,47 +55,47 @@ static long vfio_mdev_unlocked_ioctl(void *device_data,
 =09=09=09=09     unsigned int cmd, unsigned long arg)
 {
 =09struct mdev_device *mdev =3D device_data;
-=09struct mdev_parent *parent =3D mdev->parent;
+=09const struct mdev_vfio_ops *ops =3D mdev_vfio_get_ops(mdev);
=20
-=09if (unlikely(!parent->ops->ioctl))
+=09if (unlikely(!ops->ioctl))
 =09=09return -EINVAL;
=20
-=09return parent->ops->ioctl(mdev, cmd, arg);
+=09return ops->ioctl(mdev, cmd, arg);
 }
=20
 static ssize_t vfio_mdev_read(void *device_data, char __user *buf,
 =09=09=09      size_t count, loff_t *ppos)
 {
 =09struct mdev_device *mdev =3D device_data;
-=09struct mdev_parent *parent =3D mdev->parent;
+=09const struct mdev_vfio_ops *ops =3D mdev_vfio_get_ops(mdev);
=20
-=09if (unlikely(!parent->ops->read))
+=09if (unlikely(!ops->read))
 =09=09return -EINVAL;
=20
-=09return parent->ops->read(mdev, buf, count, ppos);
+=09return ops->read(mdev, buf, count, ppos);
 }
=20
 static ssize_t vfio_mdev_write(void *device_data, const char __user *buf,
 =09=09=09       size_t count, loff_t *ppos)
 {
 =09struct mdev_device *mdev =3D device_data;
-=09struct mdev_parent *parent =3D mdev->parent;
+=09const struct mdev_vfio_ops *ops =3D mdev_vfio_get_ops(mdev);
=20
-=09if (unlikely(!parent->ops->write))
+=09if (unlikely(!ops->write))
 =09=09return -EINVAL;
=20
-=09return parent->ops->write(mdev, buf, count, ppos);
+=09return ops->write(mdev, buf, count, ppos);
 }
=20
 static int vfio_mdev_mmap(void *device_data, struct vm_area_struct *vma)
 {
 =09struct mdev_device *mdev =3D device_data;
-=09struct mdev_parent *parent =3D mdev->parent;
+=09const struct mdev_vfio_ops *ops =3D mdev_vfio_get_ops(mdev);
=20
-=09if (unlikely(!parent->ops->mmap))
+=09if (unlikely(!ops->mmap))
 =09=09return -EINVAL;
=20
-=09return parent->ops->mmap(mdev, vma);
+=09return ops->mmap(mdev, vma);
 }
=20
 static const struct vfio_device_ops vfio_mdev_dev_ops =3D {
@@ -110,7 +110,7 @@ static const struct vfio_device_ops vfio_mdev_dev_ops =
=3D {
=20
 static int vfio_mdev_probe(struct device *dev)
 {
-=09struct mdev_device *mdev =3D to_mdev_device(dev);
+=09struct mdev_device *mdev =3D mdev_from_dev(dev, &mdev_vfio_bus_type);
=20
 =09return vfio_add_group_dev(dev, &vfio_mdev_dev_ops, mdev);
 }
diff --git a/include/linux/mdev.h b/include/linux/mdev.h
index ee2410246b3c..25554e55bcee 100644
--- a/include/linux/mdev.h
+++ b/include/linux/mdev.h
@@ -48,30 +48,6 @@ struct device *mdev_get_iommu_device(struct device *dev)=
;
  *=09=09=09@mdev: mdev_device device structure which is being
  *=09=09=09       destroyed
  *=09=09=09Returns integer: success (0) or error (< 0)
- * @open:=09=09Open mediated device.
- *=09=09=09@mdev: mediated device.
- *=09=09=09Returns integer: success (0) or error (< 0)
- * @release:=09=09release mediated device
- *=09=09=09@mdev: mediated device.
- * @read:=09=09Read emulation callback
- *=09=09=09@mdev: mediated device structure
- *=09=09=09@buf: read buffer
- *=09=09=09@count: number of bytes to read
- *=09=09=09@ppos: address.
- *=09=09=09Retuns number on bytes read on success or error.
- * @write:=09=09Write emulation callback
- *=09=09=09@mdev: mediated device structure
- *=09=09=09@buf: write buffer
- *=09=09=09@count: number of bytes to be written
- *=09=09=09@ppos: address.
- *=09=09=09Retuns number on bytes written on success or error.
- * @ioctl:=09=09IOCTL callback
- *=09=09=09@mdev: mediated device structure
- *=09=09=09@cmd: ioctl command
- *=09=09=09@arg: arguments to ioctl
- * @mmap:=09=09mmap callback
- *=09=09=09@mdev: mediated device structure
- *=09=09=09@vma: vma structure
  * Parent device that support mediated device should be registered with md=
ev
  * module with mdev_parent_ops structure.
  **/
@@ -83,15 +59,6 @@ struct mdev_parent_ops {
=20
 =09int     (*create)(struct kobject *kobj, struct mdev_device *mdev);
 =09int     (*remove)(struct mdev_device *mdev);
-=09int     (*open)(struct mdev_device *mdev);
-=09void    (*release)(struct mdev_device *mdev);
-=09ssize_t (*read)(struct mdev_device *mdev, char __user *buf,
-=09=09=09size_t count, loff_t *ppos);
-=09ssize_t (*write)(struct mdev_device *mdev, const char __user *buf,
-=09=09=09 size_t count, loff_t *ppos);
-=09long=09(*ioctl)(struct mdev_device *mdev, unsigned int cmd,
-=09=09=09 unsigned long arg);
-=09int=09(*mmap)(struct mdev_device *mdev, struct vm_area_struct *vma);
 };
=20
 /* interface for exporting mdev supported type attributes */
@@ -133,10 +100,6 @@ void *mdev_get_drvdata(struct mdev_device *mdev);
 void mdev_set_drvdata(struct mdev_device *mdev, void *data);
 const guid_t *mdev_uuid(struct mdev_device *mdev);
=20
-int mdev_register_device(struct device *dev, const struct mdev_parent_ops =
*ops,
-=09=09=09 struct bus_type *bus);
-void mdev_unregister_device(struct device *dev);
-
 int mdev_register_driver(struct mdev_driver *drv, struct module *owner,
 =09=09=09 struct bus_type *bus);
 void mdev_unregister_driver(struct mdev_driver *drv);
diff --git a/include/linux/mdev_vfio.h b/include/linux/mdev_vfio.h
index 446a7537e3fb..243ad85019a6 100644
--- a/include/linux/mdev_vfio.h
+++ b/include/linux/mdev_vfio.h
@@ -13,6 +13,45 @@
=20
 extern struct bus_type mdev_vfio_bus_type;
=20
+/* VFIO mdev ops
+ *
+ * @open:=09=09Open mediated device.
+ *=09=09=09@mdev: mediated device.
+ *=09=09=09Returns integer: success (0) or error (< 0)
+ * @release:=09=09release mediated device
+ *=09=09=09@mdev: mediated device.
+ * @read:=09=09Read emulation callback
+ *=09=09=09@mdev: mediated device structure
+ *=09=09=09@buf: read buffer
+ *=09=09=09@count: number of bytes to read
+ *=09=09=09@ppos: address.
+ *=09=09=09Retuns number on bytes read on success or error.
+ * @write:=09=09Write emulation callback
+ *=09=09=09@mdev: mediated device structure
+ *=09=09=09@buf: write buffer
+ *=09=09=09@count: number of bytes to be written
+ *=09=09=09@ppos: address.
+ *=09=09=09Retuns number on bytes written on success or error.
+ * @ioctl:=09=09IOCTL callback
+ *=09=09=09@mdev: mediated device structure
+ *=09=09=09@cmd: ioctl command
+ *=09=09=09@arg: arguments to ioctl
+ * @mmap:=09=09mmap callback
+ *=09=09=09@mdev: mediated device structure
+ *=09=09=09@vma: vma structure
+ */
+struct mdev_vfio_ops {
+=09int     (*open)(struct mdev_device *mdev);
+=09void    (*release)(struct mdev_device *mdev);
+=09ssize_t (*read)(struct mdev_device *mdev, char __user *buf,
+=09=09=09size_t count, loff_t *ppos);
+=09ssize_t (*write)(struct mdev_device *mdev, const char __user *buf,
+=09=09=09 size_t count, loff_t *ppos);
+=09long=09(*ioctl)(struct mdev_device *mdev, unsigned int cmd,
+=09=09=09 unsigned long arg);
+=09int=09(*mmap)(struct mdev_device *mdev, struct vm_area_struct *vma);
+};
+
 int mdev_vfio_register_device(struct device *dev,
 =09=09=09      const struct mdev_parent_ops *ops);
 void mdev_vfio_unregister_device(struct device *dev);
@@ -22,4 +61,8 @@ static inline struct mdev_device *vfio_mdev_from_dev(stru=
ct device *dev)
 =09return mdev_from_dev(dev, &mdev_vfio_bus_type);
 }
=20
+void mdev_vfio_set_ops(struct mdev_device *mdev,
+=09=09       const struct mdev_vfio_ops *ops);
+const struct mdev_vfio_ops *mdev_vfio_get_ops(struct mdev_device *mdev);
+
 #endif
diff --git a/samples/vfio-mdev/mbochs.c b/samples/vfio-mdev/mbochs.c
index f041d58324b1..b2ba32b5fed2 100644
--- a/samples/vfio-mdev/mbochs.c
+++ b/samples/vfio-mdev/mbochs.c
@@ -516,6 +516,8 @@ static int mbochs_reset(struct mdev_device *mdev)
 =09return 0;
 }
=20
+static const struct mdev_vfio_ops mdev_ops;
+
 static int mbochs_create(struct kobject *kobj, struct mdev_device *mdev)
 {
 =09const struct mbochs_type *type =3D mbochs_find_type(kobj);
@@ -561,6 +563,7 @@ static int mbochs_create(struct kobject *kobj, struct m=
dev_device *mdev)
 =09mbochs_reset(mdev);
=20
 =09mbochs_used_mbytes +=3D type->mbytes;
+=09mdev_vfio_set_ops(mdev, &mdev_ops);
 =09return 0;
=20
 err_mem:
@@ -1418,12 +1421,7 @@ static struct attribute_group *mdev_type_groups[] =
=3D {
 =09NULL,
 };
=20
-static const struct mdev_parent_ops mdev_fops =3D {
-=09.owner=09=09=09=3D THIS_MODULE,
-=09.mdev_attr_groups=09=3D mdev_dev_groups,
-=09.supported_type_groups=09=3D mdev_type_groups,
-=09.create=09=09=09=3D mbochs_create,
-=09.remove=09=09=09=3D mbochs_remove,
+static const struct mdev_vfio_ops mdev_ops =3D {
 =09.open=09=09=09=3D mbochs_open,
 =09.release=09=09=3D mbochs_close,
 =09.read=09=09=09=3D mbochs_read,
@@ -1432,6 +1430,14 @@ static const struct mdev_parent_ops mdev_fops =3D {
 =09.mmap=09=09=09=3D mbochs_mmap,
 };
=20
+static const struct mdev_parent_ops mdev_fops =3D {
+=09.owner=09=09=09=3D THIS_MODULE,
+=09.mdev_attr_groups=09=3D mdev_dev_groups,
+=09.supported_type_groups=09=3D mdev_type_groups,
+=09.create=09=09=09=3D mbochs_create,
+=09.remove=09=09=09=3D mbochs_remove,
+};
+
 static const struct file_operations vd_fops =3D {
 =09.owner=09=09=3D THIS_MODULE,
 };
diff --git a/samples/vfio-mdev/mdpy.c b/samples/vfio-mdev/mdpy.c
index 9c32fe3795ad..d26fd94b4783 100644
--- a/samples/vfio-mdev/mdpy.c
+++ b/samples/vfio-mdev/mdpy.c
@@ -226,6 +226,8 @@ static int mdpy_reset(struct mdev_device *mdev)
 =09return 0;
 }
=20
+static const struct mdev_vfio_ops mdev_ops;
+
 static int mdpy_create(struct kobject *kobj, struct mdev_device *mdev)
 {
 =09const struct mdpy_type *type =3D mdpy_find_type(kobj);
@@ -269,6 +271,8 @@ static int mdpy_create(struct kobject *kobj, struct mde=
v_device *mdev)
 =09mdpy_reset(mdev);
=20
 =09mdpy_count++;
+
+=09mdev_vfio_set_ops(mdev, &mdev_ops);
 =09return 0;
 }
=20
@@ -725,12 +729,7 @@ static struct attribute_group *mdev_type_groups[] =3D =
{
 =09NULL,
 };
=20
-static const struct mdev_parent_ops mdev_fops =3D {
-=09.owner=09=09=09=3D THIS_MODULE,
-=09.mdev_attr_groups=09=3D mdev_dev_groups,
-=09.supported_type_groups=09=3D mdev_type_groups,
-=09.create=09=09=09=3D mdpy_create,
-=09.remove=09=09=09=3D mdpy_remove,
+static const struct mdev_vfio_ops mdev_ops =3D {
 =09.open=09=09=09=3D mdpy_open,
 =09.release=09=09=3D mdpy_close,
 =09.read=09=09=09=3D mdpy_read,
@@ -739,6 +738,14 @@ static const struct mdev_parent_ops mdev_fops =3D {
 =09.mmap=09=09=09=3D mdpy_mmap,
 };
=20
+static const struct mdev_parent_ops mdev_fops =3D {
+=09.owner=09=09=09=3D THIS_MODULE,
+=09.mdev_attr_groups=09=3D mdev_dev_groups,
+=09.supported_type_groups=09=3D mdev_type_groups,
+=09.create=09=09=09=3D mdpy_create,
+=09.remove=09=09=09=3D mdpy_remove,
+};
+
 static const struct file_operations vd_fops =3D {
 =09.owner=09=09=3D THIS_MODULE,
 };
diff --git a/samples/vfio-mdev/mtty.c b/samples/vfio-mdev/mtty.c
index 6e4e6339e0f1..3f0c6506199a 100644
--- a/samples/vfio-mdev/mtty.c
+++ b/samples/vfio-mdev/mtty.c
@@ -708,6 +708,8 @@ static ssize_t mdev_access(struct mdev_device *mdev, u8=
 *buf, size_t count,
 =09return ret;
 }
=20
+static const struct mdev_vfio_ops mdev_ops;
+
 static int mtty_create(struct kobject *kobj, struct mdev_device *mdev)
 {
 =09struct mdev_state *mdev_state;
@@ -755,6 +757,7 @@ static int mtty_create(struct kobject *kobj, struct mde=
v_device *mdev)
 =09list_add(&mdev_state->next, &mdev_devices_list);
 =09mutex_unlock(&mdev_list_lock);
=20
+=09mdev_vfio_set_ops(mdev, &mdev_ops);
 =09return 0;
 }
=20
@@ -1387,6 +1390,14 @@ static struct attribute_group *mdev_type_groups[] =
=3D {
 =09NULL,
 };
=20
+static const struct mdev_vfio_ops mdev_ops =3D {
+=09.open                   =3D mtty_open,
+=09.release                =3D mtty_close,
+=09.read                   =3D mtty_read,
+=09.write                  =3D mtty_write,
+=09.ioctl=09=09        =3D mtty_ioctl,
+};
+
 static const struct mdev_parent_ops mdev_fops =3D {
 =09.owner                  =3D THIS_MODULE,
 =09.dev_attr_groups        =3D mtty_dev_groups,
@@ -1394,11 +1405,6 @@ static const struct mdev_parent_ops mdev_fops =3D {
 =09.supported_type_groups  =3D mdev_type_groups,
 =09.create                 =3D mtty_create,
 =09.remove=09=09=09=3D mtty_remove,
-=09.open                   =3D mtty_open,
-=09.release                =3D mtty_close,
-=09.read                   =3D mtty_read,
-=09.write                  =3D mtty_write,
-=09.ioctl=09=09        =3D mtty_ioctl,
 };
=20
 static void mtty_device_release(struct device *dev)
--=20
2.19.1

