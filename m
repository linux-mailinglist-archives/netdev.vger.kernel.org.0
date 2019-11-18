Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6310F100339
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 12:01:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727075AbfKRLAx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 06:00:53 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:30496 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727039AbfKRLAx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 06:00:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574074851;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GW2I8rJWN+PV2Ds7/69tjjdp7rnxBA4D3F92LuzCKF4=;
        b=URUCVgVcNrFImhZ1qhSvKKTJA2HgYZoQP+8jyv4W4DzeINLloq8x9EQ+K5l3960ef2fT+l
        UdtittYhGbrBl8bebEVkzvjEbW9WT+4yOukhQQOCiR429nk0oyP6w1Rfi4UPKlY4SkohzA
        41H2O0udoN3jxsHNeVT5JIdEpe/SiMs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-33-AzOnWVXKMjqEvZxESlZV3Q-1; Mon, 18 Nov 2019 06:00:47 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CCE5B18A5DDC;
        Mon, 18 Nov 2019 11:00:41 +0000 (UTC)
Received: from jason-ThinkPad-X1-Carbon-6th.redhat.com (ovpn-12-65.pek2.redhat.com [10.72.12.65])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1644260BE1;
        Mon, 18 Nov 2019 10:59:58 +0000 (UTC)
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
Subject: [PATCH V13 1/6] mdev: make mdev bus agnostic
Date:   Mon, 18 Nov 2019 18:59:18 +0800
Message-Id: <20191118105923.7991-2-jasowang@redhat.com>
In-Reply-To: <20191118105923.7991-1-jasowang@redhat.com>
References: <20191118105923.7991-1-jasowang@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: AzOnWVXKMjqEvZxESlZV3Q-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Current mdev is tied to a VFIO specific "mdev" bus. This prevent mdev
from being used by other types of API/buses. So this patch tries to make
mdev bus agnostic through making a mdev core a thin module:

- decouple VFIO bus specific bits from mdev_core.c to mdev_vfio.c and
  introduce mdev_vfio module
- require to specify the type of bus when registering mdev device and
  mdev driver

With those modifications mdev become a generic module that could be
used by multiple types of virtual buses and devices.

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 .../driver-api/vfio-mediated-device.rst       |  68 ++++++------
 MAINTAINERS                                   |   1 +
 drivers/gpu/drm/i915/gvt/kvmgt.c              |   8 +-
 drivers/s390/cio/vfio_ccw_ops.c               |   6 +-
 drivers/s390/crypto/vfio_ap_ops.c             |  21 ++--
 drivers/s390/crypto/vfio_ap_private.h         |   2 +-
 drivers/vfio/mdev/Kconfig                     |  17 ++-
 drivers/vfio/mdev/Makefile                    |   4 +-
 drivers/vfio/mdev/mdev_core.c                 | 104 +++++++++++++-----
 drivers/vfio/mdev/mdev_driver.c               |  29 ++---
 drivers/vfio/mdev/mdev_private.h              |  13 ++-
 drivers/vfio/mdev/mdev_vfio.c                 |  48 ++++++++
 drivers/vfio/mdev/vfio_mdev.c                 |   5 +-
 drivers/vfio/vfio_iommu_type1.c               |   6 +-
 include/linux/mdev.h                          |  16 ++-
 include/linux/mdev_vfio.h                     |  25 +++++
 samples/vfio-mdev/mbochs.c                    |   8 +-
 samples/vfio-mdev/mdpy.c                      |   8 +-
 samples/vfio-mdev/mtty.c                      |   8 +-
 19 files changed, 269 insertions(+), 128 deletions(-)
 create mode 100644 drivers/vfio/mdev/mdev_vfio.c
 create mode 100644 include/linux/mdev_vfio.h

diff --git a/Documentation/driver-api/vfio-mediated-device.rst b/Documentat=
ion/driver-api/vfio-mediated-device.rst
index 25eb7d5b834b..1887d27a565e 100644
--- a/Documentation/driver-api/vfio-mediated-device.rst
+++ b/Documentation/driver-api/vfio-mediated-device.rst
@@ -49,35 +49,37 @@ devices as examples, as these devices are the first dev=
ices to use this module::
=20
      +---------------+
      |               |
-     | +-----------+ |  mdev_register_driver() +--------------+
-     | |           | +<------------------------+              |
-     | |  mdev     | |                         |              |
-     | |  bus      | +------------------------>+ vfio_mdev.ko |<-> VFIO us=
er
-     | |  driver   | |     probe()/remove()    |              |    APIs
-     | |           | |                         +--------------+
-     | +-----------+ |
+     |   MDEV CORE   |  mdev_register_driver() +--------------+
+     |    MODULE     +<------------------------+              |
+     |    mdev.ko    |                         |              |
+     |               +------------------------>+ vfio_mdev.ko |<-> VFIO us=
er
+     |               |     probe()/remove()    |              |    APIs
+     |               |                         +--------------+
+     +---+-------+---+
+         |      /|\
+         |       |
+callbacks|       | mdev_register_device()
+         |       | mdev_register_bus()
+        \|/      |
+     +---+-------+---+
+     |               |  mdev_vfio_register_device() +--------------+
+     |               +<-----------------------------+              |
+     |               |                              |  nvidia.ko   |<-> ph=
ysical
+     |               +----------------------------->+              |    de=
vice
+     |   MDEV VFIO   |        callbacks             +--------------+
+     |   Physical    |
+     |    device     |  mdev_vfio_register_device() +--------------+
+     |   interface   |<-----------------------------+              |
+     |               |                              |  i915.ko     |<-> ph=
ysical
+     | mdev_vfio.ko  +----------------------------->+              |    de=
vice
+     |               |        callbacks             +--------------+
+     |               |
+     |               |  mdev_vfio_register_device() +--------------+
+     |               +<-----------------------------+              |
+     |               |                              | ccw_device.ko|<-> ph=
ysical
+     |               +----------------------------->+              |    de=
vice
+     |               |        callbacks             +--------------+
      |               |
-     |  MDEV CORE    |
-     |   MODULE      |
-     |   mdev.ko     |
-     | +-----------+ |  mdev_register_device() +--------------+
-     | |           | +<------------------------+              |
-     | |           | |                         |  nvidia.ko   |<-> physica=
l
-     | |           | +------------------------>+              |    device
-     | |           | |        callbacks        +--------------+
-     | | Physical  | |
-     | |  device   | |  mdev_register_device() +--------------+
-     | | interface | |<------------------------+              |
-     | |           | |                         |  i915.ko     |<-> physica=
l
-     | |           | +------------------------>+              |    device
-     | |           | |        callbacks        +--------------+
-     | |           | |
-     | |           | |  mdev_register_device() +--------------+
-     | |           | +<------------------------+              |
-     | |           | |                         | ccw_device.ko|<-> physica=
l
-     | |           | +------------------------>+              |    device
-     | |           | |        callbacks        +--------------+
-     | +-----------+ |
      +---------------+
=20
=20
@@ -116,7 +118,8 @@ to register and unregister itself with the core driver:
 * Register::
=20
     extern int  mdev_register_driver(struct mdev_driver *drv,
-=09=09=09=09   struct module *owner);
+                                     struct module *owner,
+                                     struct bus_type *bus);
=20
 * Unregister::
=20
@@ -159,11 +162,12 @@ The callbacks in the mdev_parent_ops structure are as=
 follows:
 * write: write emulation callback
 * mmap: mmap emulation callback
=20
-A driver should use the mdev_parent_ops structure in the function call to
-register itself with the mdev core driver::
+A driver should use the mdev_parent_ops structure and bus type in the
+function call to register itself with the mdev core driver::
=20
 =09extern int  mdev_register_device(struct device *dev,
-=09                                 const struct mdev_parent_ops *ops);
+=09                                 const struct mdev_parent_ops *ops,
+                                         struct bus_type *bus);
=20
 However, the mdev_parent_ops structure is not required in the function cal=
l
 that a driver should use to unregister itself with the mdev core driver::
diff --git a/MAINTAINERS b/MAINTAINERS
index 34ef0cf30ece..6d590afb62c3 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17139,6 +17139,7 @@ S:=09Maintained
 F:=09Documentation/driver-api/vfio-mediated-device.rst
 F:=09drivers/vfio/mdev/
 F:=09include/linux/mdev.h
+F:=09include/linux/mdev_vfio.h
 F:=09samples/vfio-mdev/
=20
 VFIO PLATFORM DRIVER
diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kv=
mgt.c
index 04a5a0d90823..afdb3de5ce2f 100644
--- a/drivers/gpu/drm/i915/gvt/kvmgt.c
+++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
@@ -41,7 +41,7 @@
 #include <linux/uuid.h>
 #include <linux/kvm_host.h>
 #include <linux/vfio.h>
-#include <linux/mdev.h>
+#include <linux/mdev_vfio.h>
 #include <linux/debugfs.h>
=20
 #include <linux/nospec.h>
@@ -1554,7 +1554,7 @@ static ssize_t
 vgpu_id_show(struct device *dev, struct device_attribute *attr,
 =09     char *buf)
 {
-=09struct mdev_device *mdev =3D mdev_from_dev(dev);
+=09struct mdev_device *mdev =3D vfio_mdev_from_dev(dev);
=20
 =09if (mdev) {
 =09=09struct intel_vgpu *vgpu =3D (struct intel_vgpu *)
@@ -1606,12 +1606,12 @@ static int kvmgt_host_init(struct device *dev, void=
 *gvt, const void *ops)
 =09=09return -EFAULT;
 =09intel_vgpu_ops.supported_type_groups =3D kvm_vgpu_type_groups;
=20
-=09return mdev_register_device(dev, &intel_vgpu_ops);
+=09return mdev_vfio_register_device(dev, &intel_vgpu_ops);
 }
=20
 static void kvmgt_host_exit(struct device *dev)
 {
-=09mdev_unregister_device(dev);
+=09mdev_vfio_unregister_device(dev);
 }
=20
 static int kvmgt_page_track_add(unsigned long handle, u64 gfn)
diff --git a/drivers/s390/cio/vfio_ccw_ops.c b/drivers/s390/cio/vfio_ccw_op=
s.c
index f0d71ab77c50..791b8b0eb027 100644
--- a/drivers/s390/cio/vfio_ccw_ops.c
+++ b/drivers/s390/cio/vfio_ccw_ops.c
@@ -11,7 +11,7 @@
  */
=20
 #include <linux/vfio.h>
-#include <linux/mdev.h>
+#include <linux/mdev_vfio.h>
 #include <linux/nospec.h>
 #include <linux/slab.h>
=20
@@ -588,10 +588,10 @@ static const struct mdev_parent_ops vfio_ccw_mdev_ops=
 =3D {
=20
 int vfio_ccw_mdev_reg(struct subchannel *sch)
 {
-=09return mdev_register_device(&sch->dev, &vfio_ccw_mdev_ops);
+=09return mdev_vfio_register_device(&sch->dev, &vfio_ccw_mdev_ops);
 }
=20
 void vfio_ccw_mdev_unreg(struct subchannel *sch)
 {
-=09mdev_unregister_device(&sch->dev);
+=09mdev_vfio_unregister_device(&sch->dev);
 }
diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_a=
p_ops.c
index 5c0f53c6dde7..78048e670374 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -602,7 +602,7 @@ static ssize_t assign_adapter_store(struct device *dev,
 {
 =09int ret;
 =09unsigned long apid;
-=09struct mdev_device *mdev =3D mdev_from_dev(dev);
+=09struct mdev_device *mdev =3D vfio_mdev_from_dev(dev);
 =09struct ap_matrix_mdev *matrix_mdev =3D mdev_get_drvdata(mdev);
=20
 =09/* If the guest is running, disallow assignment of adapter */
@@ -668,7 +668,7 @@ static ssize_t unassign_adapter_store(struct device *de=
v,
 {
 =09int ret;
 =09unsigned long apid;
-=09struct mdev_device *mdev =3D mdev_from_dev(dev);
+=09struct mdev_device *mdev =3D vfio_mdev_from_dev(dev);
 =09struct ap_matrix_mdev *matrix_mdev =3D mdev_get_drvdata(mdev);
=20
 =09/* If the guest is running, disallow un-assignment of adapter */
@@ -748,7 +748,7 @@ static ssize_t assign_domain_store(struct device *dev,
 {
 =09int ret;
 =09unsigned long apqi;
-=09struct mdev_device *mdev =3D mdev_from_dev(dev);
+=09struct mdev_device *mdev =3D vfio_mdev_from_dev(dev);
 =09struct ap_matrix_mdev *matrix_mdev =3D mdev_get_drvdata(mdev);
 =09unsigned long max_apqi =3D matrix_mdev->matrix.aqm_max;
=20
@@ -810,7 +810,7 @@ static ssize_t unassign_domain_store(struct device *dev=
,
 {
 =09int ret;
 =09unsigned long apqi;
-=09struct mdev_device *mdev =3D mdev_from_dev(dev);
+=09struct mdev_device *mdev =3D vfio_mdev_from_dev(dev);
 =09struct ap_matrix_mdev *matrix_mdev =3D mdev_get_drvdata(mdev);
=20
 =09/* If the guest is running, disallow un-assignment of domain */
@@ -854,7 +854,7 @@ static ssize_t assign_control_domain_store(struct devic=
e *dev,
 {
 =09int ret;
 =09unsigned long id;
-=09struct mdev_device *mdev =3D mdev_from_dev(dev);
+=09struct mdev_device *mdev =3D vfio_mdev_from_dev(dev);
 =09struct ap_matrix_mdev *matrix_mdev =3D mdev_get_drvdata(mdev);
=20
 =09/* If the guest is running, disallow assignment of control domain */
@@ -903,7 +903,7 @@ static ssize_t unassign_control_domain_store(struct dev=
ice *dev,
 {
 =09int ret;
 =09unsigned long domid;
-=09struct mdev_device *mdev =3D mdev_from_dev(dev);
+=09struct mdev_device *mdev =3D vfio_mdev_from_dev(dev);
 =09struct ap_matrix_mdev *matrix_mdev =3D mdev_get_drvdata(mdev);
 =09unsigned long max_domid =3D  matrix_mdev->matrix.adm_max;
=20
@@ -933,7 +933,7 @@ static ssize_t control_domains_show(struct device *dev,
 =09int nchars =3D 0;
 =09int n;
 =09char *bufpos =3D buf;
-=09struct mdev_device *mdev =3D mdev_from_dev(dev);
+=09struct mdev_device *mdev =3D vfio_mdev_from_dev(dev);
 =09struct ap_matrix_mdev *matrix_mdev =3D mdev_get_drvdata(mdev);
 =09unsigned long max_domid =3D matrix_mdev->matrix.adm_max;
=20
@@ -952,7 +952,7 @@ static DEVICE_ATTR_RO(control_domains);
 static ssize_t matrix_show(struct device *dev, struct device_attribute *at=
tr,
 =09=09=09   char *buf)
 {
-=09struct mdev_device *mdev =3D mdev_from_dev(dev);
+=09struct mdev_device *mdev =3D vfio_mdev_from_dev(dev);
 =09struct ap_matrix_mdev *matrix_mdev =3D mdev_get_drvdata(mdev);
 =09char *bufpos =3D buf;
 =09unsigned long apid;
@@ -1295,10 +1295,11 @@ int vfio_ap_mdev_register(void)
 {
 =09atomic_set(&matrix_dev->available_instances, MAX_ZDEV_ENTRIES_EXT);
=20
-=09return mdev_register_device(&matrix_dev->device, &vfio_ap_matrix_ops);
+=09return mdev_vfio_register_device(&matrix_dev->device,
+=09=09=09=09=09 &vfio_ap_matrix_ops);
 }
=20
 void vfio_ap_mdev_unregister(void)
 {
-=09mdev_unregister_device(&matrix_dev->device);
+=09mdev_vfio_unregister_device(&matrix_dev->device);
 }
diff --git a/drivers/s390/crypto/vfio_ap_private.h b/drivers/s390/crypto/vf=
io_ap_private.h
index f46dde56b464..4e37e0e3433a 100644
--- a/drivers/s390/crypto/vfio_ap_private.h
+++ b/drivers/s390/crypto/vfio_ap_private.h
@@ -14,7 +14,7 @@
=20
 #include <linux/types.h>
 #include <linux/device.h>
-#include <linux/mdev.h>
+#include <linux/mdev_vfio.h>
 #include <linux/delay.h>
 #include <linux/mutex.h>
 #include <linux/kvm_host.h>
diff --git a/drivers/vfio/mdev/Kconfig b/drivers/vfio/mdev/Kconfig
index 5da27f2100f9..2e07ca915a96 100644
--- a/drivers/vfio/mdev/Kconfig
+++ b/drivers/vfio/mdev/Kconfig
@@ -1,15 +1,24 @@
-# SPDX-License-Identifier: GPL-2.0-only
=20
-config VFIO_MDEV
+config MDEV
 =09tristate "Mediated device driver framework"
-=09depends on VFIO
 =09default n
 =09help
 =09  Provides a framework to virtualize devices.
-=09  See Documentation/driver-api/vfio-mediated-device.rst for more detail=
s.
=20
 =09  If you don't know what do here, say N.
=20
+config VFIO_MDEV
+=09tristate "VFIO Mediated device driver"
+        depends on VFIO && MDEV
+        default n
+=09help
+=09  Proivdes a mediated BUS for userspace driver through VFIO
+=09  framework. See Documentation/vfio-mediated-device.txt for
+=09  more details.
+
+=09  If you don't know what do here, say N.
+
+
 config VFIO_MDEV_DEVICE
 =09tristate "VFIO driver for Mediated devices"
 =09depends on VFIO && VFIO_MDEV
diff --git a/drivers/vfio/mdev/Makefile b/drivers/vfio/mdev/Makefile
index 101516fdf375..e9675501271a 100644
--- a/drivers/vfio/mdev/Makefile
+++ b/drivers/vfio/mdev/Makefile
@@ -1,6 +1,6 @@
-# SPDX-License-Identifier: GPL-2.0-only
=20
 mdev-y :=3D mdev_core.o mdev_sysfs.o mdev_driver.o
=20
-obj-$(CONFIG_VFIO_MDEV) +=3D mdev.o
+obj-$(CONFIG_MDEV) +=3D mdev.o
+obj-$(CONFIG_VFIO_MDEV) +=3D mdev_vfio.o
 obj-$(CONFIG_VFIO_MDEV_DEVICE) +=3D vfio_mdev.o
diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core.c
index b558d4cfd082..e1272a40c521 100644
--- a/drivers/vfio/mdev/mdev_core.c
+++ b/drivers/vfio/mdev/mdev_core.c
@@ -22,11 +22,13 @@
=20
 static LIST_HEAD(parent_list);
 static DEFINE_MUTEX(parent_list_lock);
-static struct class_compat *mdev_bus_compat_class;
=20
 static LIST_HEAD(mdev_list);
 static DEFINE_MUTEX(mdev_list_lock);
=20
+static LIST_HEAD(class_compat_list);
+static DEFINE_MUTEX(compat_list_lock);
+
 struct device *mdev_parent_dev(struct mdev_device *mdev)
 {
 =09return mdev->parent->dev;
@@ -51,9 +53,9 @@ struct device *mdev_dev(struct mdev_device *mdev)
 }
 EXPORT_SYMBOL(mdev_dev);
=20
-struct mdev_device *mdev_from_dev(struct device *dev)
+struct mdev_device *mdev_from_dev(struct device *dev, struct bus_type *bus=
)
 {
-=09return dev_is_mdev(dev) ? to_mdev_device(dev) : NULL;
+=09return dev_is_mdev(dev, bus) ? to_mdev_device(dev) : NULL;
 }
 EXPORT_SYMBOL(mdev_from_dev);
=20
@@ -122,7 +124,9 @@ static void mdev_device_remove_common(struct mdev_devic=
e *mdev)
=20
 static int mdev_device_remove_cb(struct device *dev, void *data)
 {
-=09if (dev_is_mdev(dev)) {
+=09struct bus_type *bus =3D data;
+
+=09if (dev_is_mdev(dev, bus)) {
 =09=09struct mdev_device *mdev;
=20
 =09=09mdev =3D to_mdev_device(dev);
@@ -131,6 +135,41 @@ static int mdev_device_remove_cb(struct device *dev, v=
oid *data)
 =09return 0;
 }
=20
+static struct mdev_class_compat *get_class_compat(struct bus_type *bus)
+{
+=09struct mdev_class_compat *mdev_class_compat;
+
+=09list_for_each_entry(mdev_class_compat, &class_compat_list, next) {
+=09=09if (mdev_class_compat->bus =3D=3D bus)
+=09=09=09return mdev_class_compat;
+=09}
+
+=09return NULL;
+}
+
+static struct class_compat *mdev_alloc_class_compat(struct bus_type *bus)
+{
+=09struct mdev_class_compat *mdev_class_compat =3D get_class_compat(bus);
+=09char class_name[64];
+
+=09if (mdev_class_compat)
+=09=09return mdev_class_compat->class_compat;
+
+=09mdev_class_compat =3D kmalloc(sizeof(*mdev_class_compat), GFP_KERNEL);
+=09if (!mdev_class_compat)
+=09=09return NULL;
+=09snprintf(class_name, 64, "%s_bus", bus->name);
+=09mdev_class_compat->class_compat =3D class_compat_register(class_name);
+=09if (!mdev_class_compat->class_compat) {
+=09=09kfree(mdev_class_compat);
+=09=09return NULL;
+=09}
+=09mdev_class_compat->bus =3D bus;
+=09list_add(&mdev_class_compat->next, &class_compat_list);
+
+=09return mdev_class_compat->class_compat;
+}
+
 /*
  * mdev_register_device : Register a device
  * @dev: device structure representing parent device.
@@ -139,12 +178,14 @@ static int mdev_device_remove_cb(struct device *dev, =
void *data)
  * Add device to list of registered parent devices.
  * Returns a negative value on error, otherwise 0.
  */
-int mdev_register_device(struct device *dev, const struct mdev_parent_ops =
*ops)
+int mdev_register_device(struct device *dev, const struct mdev_parent_ops =
*ops,
+=09=09=09 struct bus_type *bus)
 {
 =09int ret;
 =09struct mdev_parent *parent;
 =09char *env_string =3D "MDEV_STATE=3Dregistered";
 =09char *envp[] =3D { env_string, NULL };
+=09struct class_compat *class_compat;
=20
 =09/* check for mandatory ops */
 =09if (!ops || !ops->create || !ops->remove || !ops->supported_type_groups=
)
@@ -175,20 +216,21 @@ int mdev_register_device(struct device *dev, const st=
ruct mdev_parent_ops *ops)
=20
 =09parent->dev =3D dev;
 =09parent->ops =3D ops;
+=09parent->bus =3D bus;
=20
-=09if (!mdev_bus_compat_class) {
-=09=09mdev_bus_compat_class =3D class_compat_register("mdev_bus");
-=09=09if (!mdev_bus_compat_class) {
-=09=09=09ret =3D -ENOMEM;
-=09=09=09goto add_dev_err;
-=09=09}
+=09mutex_lock(&compat_list_lock);
+=09class_compat =3D mdev_alloc_class_compat(bus);
+=09mutex_unlock(&compat_list_lock);
+=09if (!class_compat) {
+=09=09ret =3D -ENOMEM;
+=09=09goto add_dev_err;
 =09}
=20
 =09ret =3D parent_create_sysfs_files(parent);
 =09if (ret)
 =09=09goto add_dev_err;
=20
-=09ret =3D class_compat_create_link(mdev_bus_compat_class, dev, NULL);
+=09ret =3D class_compat_create_link(class_compat, dev, NULL);
 =09if (ret)
 =09=09dev_warn(dev, "Failed to create compatibility class link\n");
=20
@@ -223,6 +265,7 @@ void mdev_unregister_device(struct device *dev)
 =09struct mdev_parent *parent;
 =09char *env_string =3D "MDEV_STATE=3Dunregistered";
 =09char *envp[] =3D { env_string, NULL };
+=09struct mdev_class_compat *mdev_class_compat;
=20
 =09mutex_lock(&parent_list_lock);
 =09parent =3D __find_parent_device(dev);
@@ -238,9 +281,13 @@ void mdev_unregister_device(struct device *dev)
=20
 =09down_write(&parent->unreg_sem);
=20
-=09class_compat_remove_link(mdev_bus_compat_class, dev, NULL);
+=09mutex_lock(&compat_list_lock);
+=09mdev_class_compat =3D get_class_compat(parent->bus);
+=09WARN_ON(!mdev_class_compat);
+=09class_compat_remove_link(mdev_class_compat->class_compat, dev, NULL);
+=09mutex_unlock(&compat_list_lock);
=20
-=09device_for_each_child(dev, NULL, mdev_device_remove_cb);
+=09device_for_each_child(dev, parent->bus, mdev_device_remove_cb);
=20
 =09parent_remove_sysfs_files(parent);
 =09up_write(&parent->unreg_sem);
@@ -314,7 +361,7 @@ int mdev_device_create(struct kobject *kobj,
=20
 =09device_initialize(&mdev->dev);
 =09mdev->dev.parent  =3D dev;
-=09mdev->dev.bus     =3D &mdev_bus_type;
+=09mdev->dev.bus     =3D parent->bus;
 =09mdev->dev.release =3D mdev_device_release;
 =09dev_set_name(&mdev->dev, "%pUl", uuid);
 =09mdev->dev.groups =3D parent->ops->mdev_attr_groups;
@@ -404,24 +451,29 @@ struct device *mdev_get_iommu_device(struct device *d=
ev)
 }
 EXPORT_SYMBOL(mdev_get_iommu_device);
=20
-static int __init mdev_init(void)
+int mdev_register_bus(struct bus_type *bus)
 {
-=09return mdev_bus_register();
+=09return bus_register(bus);
 }
+EXPORT_SYMBOL(mdev_register_bus);
=20
-static void __exit mdev_exit(void)
+void mdev_unregister_bus(struct bus_type *bus)
 {
-=09if (mdev_bus_compat_class)
-=09=09class_compat_unregister(mdev_bus_compat_class);
-
-=09mdev_bus_unregister();
+=09struct mdev_class_compat *mdev_class_compat;
+
+=09mutex_lock(&compat_list_lock);
+=09mdev_class_compat =3D get_class_compat(bus);
+=09if (mdev_class_compat) {
+=09=09list_del(&mdev_class_compat->next);
+=09=09class_compat_unregister(mdev_class_compat->class_compat);
+=09=09kfree(mdev_class_compat);
+=09}
+=09bus_unregister(bus);
+=09mutex_unlock(&compat_list_lock);
 }
-
-module_init(mdev_init)
-module_exit(mdev_exit)
+EXPORT_SYMBOL(mdev_unregister_bus);
=20
 MODULE_VERSION(DRIVER_VERSION);
 MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR(DRIVER_AUTHOR);
 MODULE_DESCRIPTION(DRIVER_DESC);
-MODULE_SOFTDEP("post: vfio_mdev");
diff --git a/drivers/vfio/mdev/mdev_driver.c b/drivers/vfio/mdev/mdev_drive=
r.c
index 0d3223aee20b..c3a2ac023712 100644
--- a/drivers/vfio/mdev/mdev_driver.c
+++ b/drivers/vfio/mdev/mdev_driver.c
@@ -10,6 +10,7 @@
 #include <linux/device.h>
 #include <linux/iommu.h>
 #include <linux/mdev.h>
+#include <linux/mdev_vfio.h>
=20
 #include "mdev_private.h"
=20
@@ -37,7 +38,7 @@ static void mdev_detach_iommu(struct mdev_device *mdev)
 =09dev_info(&mdev->dev, "MDEV: detaching iommu\n");
 }
=20
-static int mdev_probe(struct device *dev)
+int mdev_probe(struct device *dev)
 {
 =09struct mdev_driver *drv =3D to_mdev_driver(dev->driver);
 =09struct mdev_device *mdev =3D to_mdev_device(dev);
@@ -55,8 +56,9 @@ static int mdev_probe(struct device *dev)
=20
 =09return ret;
 }
+EXPORT_SYMBOL(mdev_probe);
=20
-static int mdev_remove(struct device *dev)
+int mdev_remove(struct device *dev)
 {
 =09struct mdev_driver *drv =3D to_mdev_driver(dev->driver);
 =09struct mdev_device *mdev =3D to_mdev_device(dev);
@@ -68,26 +70,22 @@ static int mdev_remove(struct device *dev)
=20
 =09return 0;
 }
-
-struct bus_type mdev_bus_type =3D {
-=09.name=09=09=3D "mdev",
-=09.probe=09=09=3D mdev_probe,
-=09.remove=09=09=3D mdev_remove,
-};
-EXPORT_SYMBOL_GPL(mdev_bus_type);
+EXPORT_SYMBOL(mdev_remove);
=20
 /**
  * mdev_register_driver - register a new MDEV driver
  * @drv: the driver to register
  * @owner: module owner of driver to be registered
+ * @bus: but that the driver wants to attach
  *
  * Returns a negative value on error, otherwise 0.
  **/
-int mdev_register_driver(struct mdev_driver *drv, struct module *owner)
+int mdev_register_driver(struct mdev_driver *drv, struct module *owner,
+=09=09=09 struct bus_type *bus)
 {
 =09/* initialize common driver fields */
 =09drv->driver.name =3D drv->name;
-=09drv->driver.bus =3D &mdev_bus_type;
+=09drv->driver.bus =3D bus;
 =09drv->driver.owner =3D owner;
=20
 =09/* register with core */
@@ -105,12 +103,3 @@ void mdev_unregister_driver(struct mdev_driver *drv)
 }
 EXPORT_SYMBOL(mdev_unregister_driver);
=20
-int mdev_bus_register(void)
-{
-=09return bus_register(&mdev_bus_type);
-}
-
-void mdev_bus_unregister(void)
-{
-=09bus_unregister(&mdev_bus_type);
-}
diff --git a/drivers/vfio/mdev/mdev_private.h b/drivers/vfio/mdev/mdev_priv=
ate.h
index 7d922950caaf..298d7a0f493a 100644
--- a/drivers/vfio/mdev/mdev_private.h
+++ b/drivers/vfio/mdev/mdev_private.h
@@ -10,12 +10,10 @@
 #ifndef MDEV_PRIVATE_H
 #define MDEV_PRIVATE_H
=20
-int  mdev_bus_register(void);
-void mdev_bus_unregister(void);
-
 struct mdev_parent {
 =09struct device *dev;
 =09const struct mdev_parent_ops *ops;
+=09struct bus_type *bus;
 =09struct kref ref;
 =09struct list_head next;
 =09struct kset *mdev_types_kset;
@@ -35,8 +33,15 @@ struct mdev_device {
 =09bool active;
 };
=20
+struct mdev_class_compat {
+=09struct class_compat *class_compat;
+=09struct bus_type *bus;
+=09struct list_head next;
+};
+
+
 #define to_mdev_device(dev)=09container_of(dev, struct mdev_device, dev)
-#define dev_is_mdev(d)=09=09((d)->bus =3D=3D &mdev_bus_type)
+#define dev_is_mdev(d, bus)=09((d)->bus =3D=3D bus)
=20
 struct mdev_type {
 =09struct kobject kobj;
diff --git a/drivers/vfio/mdev/mdev_vfio.c b/drivers/vfio/mdev/mdev_vfio.c
new file mode 100644
index 000000000000..f9d1191b9982
--- /dev/null
+++ b/drivers/vfio/mdev/mdev_vfio.c
@@ -0,0 +1,48 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include <linux/module.h>
+#include <linux/uuid.h>
+#include <linux/device.h>
+#include <linux/mdev_vfio.h>
+
+#define DRIVER_VERSION=09=09"0.1"
+#define DRIVER_AUTHOR=09=09"Jason Wang"
+#define DRIVER_DESC=09=09"Mediated VFIO bus"
+
+struct bus_type mdev_vfio_bus_type =3D {
+=09.name=09=09=3D "mdev",
+=09.probe=09=09=3D mdev_probe,
+=09.remove=09=09=3D mdev_remove,
+};
+EXPORT_SYMBOL(mdev_vfio_bus_type);
+
+static int __init mdev_init(void)
+{
+=09return mdev_register_bus(&mdev_vfio_bus_type);
+}
+
+static void __exit mdev_exit(void)
+{
+=09mdev_unregister_bus(&mdev_vfio_bus_type);
+}
+
+int mdev_vfio_register_device(struct device *dev,
+=09=09=09      const struct mdev_parent_ops *ops)
+{
+=09return mdev_register_device(dev, ops, &mdev_vfio_bus_type);
+}
+EXPORT_SYMBOL(mdev_vfio_register_device);
+
+void mdev_vfio_unregister_device(struct device *dev)
+{
+=09return mdev_unregister_device(dev);
+}
+EXPORT_SYMBOL(mdev_vfio_unregister_device);
+
+module_init(mdev_init)
+module_exit(mdev_exit)
+
+MODULE_VERSION(DRIVER_VERSION);
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR(DRIVER_AUTHOR);
+MODULE_DESCRIPTION(DRIVER_DESC);
+MODULE_SOFTDEP("post: vfio_mdev");
diff --git a/drivers/vfio/mdev/vfio_mdev.c b/drivers/vfio/mdev/vfio_mdev.c
index 30964a4e0a28..16e9ebe30d4a 100644
--- a/drivers/vfio/mdev/vfio_mdev.c
+++ b/drivers/vfio/mdev/vfio_mdev.c
@@ -13,7 +13,7 @@
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/vfio.h>
-#include <linux/mdev.h>
+#include <linux/mdev_vfio.h>
=20
 #include "mdev_private.h"
=20
@@ -128,7 +128,8 @@ static struct mdev_driver vfio_mdev_driver =3D {
=20
 static int __init vfio_mdev_init(void)
 {
-=09return mdev_register_driver(&vfio_mdev_driver, THIS_MODULE);
+=09return mdev_register_driver(&vfio_mdev_driver, THIS_MODULE,
+=09=09=09=09    &mdev_vfio_bus_type);
 }
=20
 static void __exit vfio_mdev_exit(void)
diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type=
1.c
index d864277ea16f..f35523f822eb 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -34,7 +34,7 @@
 #include <linux/uaccess.h>
 #include <linux/vfio.h>
 #include <linux/workqueue.h>
-#include <linux/mdev.h>
+#include <linux/mdev_vfio.h>
 #include <linux/notifier.h>
 #include <linux/dma-iommu.h>
 #include <linux/irqdomain.h>
@@ -1405,10 +1405,10 @@ static bool vfio_bus_is_mdev(struct bus_type *bus)
 =09struct bus_type *mdev_bus;
 =09bool ret =3D false;
=20
-=09mdev_bus =3D symbol_get(mdev_bus_type);
+=09mdev_bus =3D symbol_get(mdev_vfio_bus_type);
 =09if (mdev_bus) {
 =09=09ret =3D (bus =3D=3D mdev_bus);
-=09=09symbol_put(mdev_bus_type);
+=09=09symbol_put(mdev_vfio_bus_type);
 =09}
=20
 =09return ret;
diff --git a/include/linux/mdev.h b/include/linux/mdev.h
index 0ce30ca78db0..ee2410246b3c 100644
--- a/include/linux/mdev.h
+++ b/include/linux/mdev.h
@@ -133,16 +133,22 @@ void *mdev_get_drvdata(struct mdev_device *mdev);
 void mdev_set_drvdata(struct mdev_device *mdev, void *data);
 const guid_t *mdev_uuid(struct mdev_device *mdev);
=20
-extern struct bus_type mdev_bus_type;
-
-int mdev_register_device(struct device *dev, const struct mdev_parent_ops =
*ops);
+int mdev_register_device(struct device *dev, const struct mdev_parent_ops =
*ops,
+=09=09=09 struct bus_type *bus);
 void mdev_unregister_device(struct device *dev);
=20
-int mdev_register_driver(struct mdev_driver *drv, struct module *owner);
+int mdev_register_driver(struct mdev_driver *drv, struct module *owner,
+=09=09=09 struct bus_type *bus);
 void mdev_unregister_driver(struct mdev_driver *drv);
=20
 struct device *mdev_parent_dev(struct mdev_device *mdev);
 struct device *mdev_dev(struct mdev_device *mdev);
-struct mdev_device *mdev_from_dev(struct device *dev);
+struct mdev_device *mdev_from_dev(struct device *dev, struct bus_type *bus=
);
+
+int mdev_probe(struct device *dev);
+int mdev_remove(struct device *dev);
+
+int mdev_register_bus(struct bus_type *bus);
+void mdev_unregister_bus(struct bus_type *bus);
=20
 #endif /* MDEV_H */
diff --git a/include/linux/mdev_vfio.h b/include/linux/mdev_vfio.h
new file mode 100644
index 000000000000..446a7537e3fb
--- /dev/null
+++ b/include/linux/mdev_vfio.h
@@ -0,0 +1,25 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * VFIO Mediated device definition
+ *
+ * Copyright (c) 2019, Red Hat. All rights reserved.
+ *     Author: Jason Wang <jasowang@redhat.com>
+ */
+
+#ifndef MDEV_VFIO_H
+#define MDEV_VFIO_H
+
+#include <linux/mdev.h>
+
+extern struct bus_type mdev_vfio_bus_type;
+
+int mdev_vfio_register_device(struct device *dev,
+=09=09=09      const struct mdev_parent_ops *ops);
+void mdev_vfio_unregister_device(struct device *dev);
+
+static inline struct mdev_device *vfio_mdev_from_dev(struct device *dev)
+{
+=09return mdev_from_dev(dev, &mdev_vfio_bus_type);
+}
+
+#endif
diff --git a/samples/vfio-mdev/mbochs.c b/samples/vfio-mdev/mbochs.c
index ac5c8c17b1ff..f041d58324b1 100644
--- a/samples/vfio-mdev/mbochs.c
+++ b/samples/vfio-mdev/mbochs.c
@@ -29,7 +29,7 @@
 #include <linux/vfio.h>
 #include <linux/iommu.h>
 #include <linux/sysfs.h>
-#include <linux/mdev.h>
+#include <linux/mdev_vfio.h>
 #include <linux/pci.h>
 #include <linux/dma-buf.h>
 #include <linux/highmem.h>
@@ -1332,7 +1332,7 @@ static ssize_t
 memory_show(struct device *dev, struct device_attribute *attr,
 =09    char *buf)
 {
-=09struct mdev_device *mdev =3D mdev_from_dev(dev);
+=09struct mdev_device *mdev =3D vfio_mdev_from_dev(dev);
 =09struct mdev_state *mdev_state =3D mdev_get_drvdata(mdev);
=20
 =09return sprintf(buf, "%d MB\n", mdev_state->type->mbytes);
@@ -1468,7 +1468,7 @@ static int __init mbochs_dev_init(void)
 =09if (ret)
 =09=09goto failed2;
=20
-=09ret =3D mdev_register_device(&mbochs_dev, &mdev_fops);
+=09ret =3D mdev_vfio_register_device(&mbochs_dev, &mdev_fops);
 =09if (ret)
 =09=09goto failed3;
=20
@@ -1487,7 +1487,7 @@ static int __init mbochs_dev_init(void)
 static void __exit mbochs_dev_exit(void)
 {
 =09mbochs_dev.bus =3D NULL;
-=09mdev_unregister_device(&mbochs_dev);
+=09mdev_vfio_unregister_device(&mbochs_dev);
=20
 =09device_unregister(&mbochs_dev);
 =09cdev_del(&mbochs_cdev);
diff --git a/samples/vfio-mdev/mdpy.c b/samples/vfio-mdev/mdpy.c
index cc86bf6566e4..9c32fe3795ad 100644
--- a/samples/vfio-mdev/mdpy.c
+++ b/samples/vfio-mdev/mdpy.c
@@ -25,7 +25,7 @@
 #include <linux/vfio.h>
 #include <linux/iommu.h>
 #include <linux/sysfs.h>
-#include <linux/mdev.h>
+#include <linux/mdev_vfio.h>
 #include <linux/pci.h>
 #include <drm/drm_fourcc.h>
 #include "mdpy-defs.h"
@@ -639,7 +639,7 @@ static ssize_t
 resolution_show(struct device *dev, struct device_attribute *attr,
 =09=09char *buf)
 {
-=09struct mdev_device *mdev =3D mdev_from_dev(dev);
+=09struct mdev_device *mdev =3D vfio_mdev_from_dev(dev);
 =09struct mdev_state *mdev_state =3D mdev_get_drvdata(mdev);
=20
 =09return sprintf(buf, "%dx%d\n",
@@ -775,7 +775,7 @@ static int __init mdpy_dev_init(void)
 =09if (ret)
 =09=09goto failed2;
=20
-=09ret =3D mdev_register_device(&mdpy_dev, &mdev_fops);
+=09ret =3D mdev_vfio_register_device(&mdpy_dev, &mdev_fops);
 =09if (ret)
 =09=09goto failed3;
=20
@@ -794,7 +794,7 @@ static int __init mdpy_dev_init(void)
 static void __exit mdpy_dev_exit(void)
 {
 =09mdpy_dev.bus =3D NULL;
-=09mdev_unregister_device(&mdpy_dev);
+=09mdev_vfio_unregister_device(&mdpy_dev);
=20
 =09device_unregister(&mdpy_dev);
 =09cdev_del(&mdpy_cdev);
diff --git a/samples/vfio-mdev/mtty.c b/samples/vfio-mdev/mtty.c
index ce84a300a4da..6e4e6339e0f1 100644
--- a/samples/vfio-mdev/mtty.c
+++ b/samples/vfio-mdev/mtty.c
@@ -26,7 +26,7 @@
 #include <linux/sysfs.h>
 #include <linux/ctype.h>
 #include <linux/file.h>
-#include <linux/mdev.h>
+#include <linux/mdev_vfio.h>
 #include <linux/pci.h>
 #include <linux/serial.h>
 #include <uapi/linux/serial_reg.h>
@@ -1285,7 +1285,7 @@ static ssize_t
 sample_mdev_dev_show(struct device *dev, struct device_attribute *attr,
 =09=09     char *buf)
 {
-=09if (mdev_from_dev(dev))
+=09if (vfio_mdev_from_dev(dev))
 =09=09return sprintf(buf, "This is MDEV %s\n", dev_name(dev));
=20
 =09return sprintf(buf, "\n");
@@ -1445,7 +1445,7 @@ static int __init mtty_dev_init(void)
 =09if (ret)
 =09=09goto failed2;
=20
-=09ret =3D mdev_register_device(&mtty_dev.dev, &mdev_fops);
+=09ret =3D mdev_vfio_register_device(&mtty_dev.dev, &mdev_fops);
 =09if (ret)
 =09=09goto failed3;
=20
@@ -1471,7 +1471,7 @@ static int __init mtty_dev_init(void)
 static void __exit mtty_dev_exit(void)
 {
 =09mtty_dev.dev.bus =3D NULL;
-=09mdev_unregister_device(&mtty_dev.dev);
+=09mdev_vfio_unregister_device(&mtty_dev.dev);
=20
 =09device_unregister(&mtty_dev.dev);
 =09idr_destroy(&mtty_dev.vd_idr);
--=20
2.19.1

