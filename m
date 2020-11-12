Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5700B2AFFBF
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 07:40:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726377AbgKLGki (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 01:40:38 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:15480 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725898AbgKLGkd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 01:40:33 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5facd8db0000>; Wed, 11 Nov 2020 22:40:27 -0800
Received: from sw-mtx-036.mtx.labs.mlnx (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 12 Nov
 2020 06:40:32 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     <virtualization@lists.linux-foundation.org>
CC:     <mst@redhat.com>, <jasowang@redhat.com>, <parav@nvidia.com>,
        <elic@nvidia.com>, <netdev@vger.kernel.org>
Subject: [PATCH 4/7] vdpa: Define vdpa parent device, ops and a netlink interface
Date:   Thu, 12 Nov 2020 08:40:02 +0200
Message-ID: <20201112064005.349268-5-parav@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201112064005.349268-1-parav@nvidia.com>
References: <20201112064005.349268-1-parav@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1605163227; bh=yC5mgzfv1lLHopRQpKqnz5FiMVMn9kXtHUZHvKGSVos=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=qY0qKh9Yg0CkuLWfJslhfafSvTpiTcjgDmDV6tQQSlbdLRb1F/rk2GjMPmPuCQe/G
         5A80XjJgsztSsYXTTg1ZeDjhm7bwhQ68KrPVjeW5BeQnZfdELkqMyAXBaH58lGsPPc
         3MbGzUW5sm+64cS7va7VI9zB8K0DeNR/DD1bHA43lePXFOxJsvCYl9sd60HBMr2mzl
         5ccj+VzABhG0OKC0LYjMt9/bZKRyVtTk+q/9RwdfYy5tyOdFZEqo5cmf3ajIEsMntu
         eR9q8cbCBi239hnbMtHnjG48+YQjkelfS17rHPgS6MkfvU8wldPaGkxuGGVbolQnHz
         wbRTVj5eP75Zg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To add one or more VDPA devices, define a parent device which allows
adding or removing vdpa device. A parent device defines set of callbacks
to manage vdpa devices.

To begin with, it defines add and remove callbacks through which a user
defined vdpa device can be added or removed.

A unique parent device is identified by its unique handle identified by
parent device name and optionally the bus name.

Hence, introduce routine through which driver can register a
parent device and its callback operations for adding and remove
a vdpa device.

Introduce vdpa netlink socket family so that user can query parent
device and its attributes.

Example of show vdpa parent device which allows creating vdpa device of
networking class (device id =3D 0x1) of virtio specification 1.1
section 5.1.1.

$ vdpa parentdev show
vdpasim:
  supported_classes:
    net

Example of showing vdpa parent device in JSON format.

$ vdpa parentdev show -jp
{
    "show": {
        "vdpasim": {
            "supported_classes": [ "net" ]
        }
    }
}

Signed-off-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Eli Cohen <elic@nvidia.com>
Reviewed-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vdpa/Kconfig      |   1 +
 drivers/vdpa/vdpa.c       | 213 +++++++++++++++++++++++++++++++++++++-
 include/linux/vdpa.h      |  32 ++++++
 include/uapi/linux/vdpa.h |  32 ++++++
 4 files changed, 277 insertions(+), 1 deletion(-)
 create mode 100644 include/uapi/linux/vdpa.h

diff --git a/drivers/vdpa/Kconfig b/drivers/vdpa/Kconfig
index d7d32b656102..8ae491a74ebb 100644
--- a/drivers/vdpa/Kconfig
+++ b/drivers/vdpa/Kconfig
@@ -1,6 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
 menuconfig VDPA
 	tristate "vDPA drivers"
+	depends on NET
 	help
 	  Enable this module to support vDPA device that uses a
 	  datapath which complies with virtio specifications with
diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
index 3c9cade05233..273639038851 100644
--- a/drivers/vdpa/vdpa.c
+++ b/drivers/vdpa/vdpa.c
@@ -11,11 +11,17 @@
 #include <linux/idr.h>
 #include <linux/slab.h>
 #include <linux/vdpa.h>
+#include <uapi/linux/vdpa.h>
+#include <net/genetlink.h>
+#include <linux/mod_devicetable.h>
=20
+static LIST_HEAD(pdev_head);
 /* A global mutex that protects vdpa parent and device level operations. *=
/
 static DEFINE_MUTEX(vdpa_dev_mutex);
 static DEFINE_IDA(vdpa_index_ida);
=20
+static struct genl_family vdpa_nl_family;
+
 static int vdpa_dev_probe(struct device *d)
 {
 	struct vdpa_device *vdev =3D dev_to_vdpa(d);
@@ -195,13 +201,218 @@ void vdpa_unregister_driver(struct vdpa_driver *drv)
 }
 EXPORT_SYMBOL_GPL(vdpa_unregister_driver);
=20
+/**
+ * vdpa_parentdev_register - register a vdpa parent device
+ *
+ * @pdev: Pointer to vdpa parent device
+ * vdpa_parentdev_register() register a vdpa parent device which supports
+ * vdpa device management.
+ */
+int vdpa_parentdev_register(struct vdpa_parent_dev *pdev)
+{
+	if (!pdev->device || !pdev->ops || !pdev->ops->dev_add || !pdev->ops->dev=
_del)
+		return -EINVAL;
+
+	INIT_LIST_HEAD(&pdev->list);
+	mutex_lock(&vdpa_dev_mutex);
+	list_add_tail(&pdev->list, &pdev_head);
+	mutex_unlock(&vdpa_dev_mutex);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(vdpa_parentdev_register);
+
+void vdpa_parentdev_unregister(struct vdpa_parent_dev *pdev)
+{
+	mutex_lock(&vdpa_dev_mutex);
+	list_del(&pdev->list);
+	mutex_unlock(&vdpa_dev_mutex);
+}
+EXPORT_SYMBOL_GPL(vdpa_parentdev_unregister);
+
+static bool parentdev_handle_match(const struct vdpa_parent_dev *pdev,
+				   const char *busname, const char *devname)
+{
+	/* Bus name is optional for simulated parent device, so ignore the parent
+	 * when bus is provided.
+	 */
+	if ((busname && !pdev->device->bus) || (!busname && pdev->device->bus))
+		return false;
+
+	if (!busname && strcmp(dev_name(pdev->device), devname) =3D=3D 0)
+		return true;
+
+	if (busname && (strcmp(pdev->device->bus->name, busname) =3D=3D 0) &&
+	    (strcmp(dev_name(pdev->device), devname) =3D=3D 0))
+		return true;
+
+	return false;
+}
+
+static struct vdpa_parent_dev *vdpa_parentdev_get_from_attr(struct nlattr =
**attrs)
+{
+	struct vdpa_parent_dev *pdev;
+	const char *busname =3D NULL;
+	const char *devname;
+
+	if (!attrs[VDPA_ATTR_PARENTDEV_DEV_NAME])
+		return ERR_PTR(-EINVAL);
+	devname =3D nla_data(attrs[VDPA_ATTR_PARENTDEV_DEV_NAME]);
+	if (attrs[VDPA_ATTR_PARENTDEV_BUS_NAME])
+		busname =3D nla_data(attrs[VDPA_ATTR_PARENTDEV_BUS_NAME]);
+
+	list_for_each_entry(pdev, &pdev_head, list) {
+		if (parentdev_handle_match(pdev, busname, devname))
+			return pdev;
+	}
+	return ERR_PTR(-ENODEV);
+}
+
+static int vdpa_nl_parentdev_handle_fill(struct sk_buff *msg, const struct=
 vdpa_parent_dev *pdev)
+{
+	if (pdev->device->bus &&
+	    nla_put_string(msg, VDPA_ATTR_PARENTDEV_BUS_NAME, pdev->device->bus->=
name))
+		return -EMSGSIZE;
+	if (nla_put_string(msg, VDPA_ATTR_PARENTDEV_DEV_NAME, dev_name(pdev->devi=
ce)))
+		return -EMSGSIZE;
+	return 0;
+}
+
+static int vdpa_parentdev_fill(const struct vdpa_parent_dev *pdev, struct =
sk_buff *msg,
+			       u32 portid, u32 seq, int flags)
+{
+	u64 supported_classes =3D 0;
+	void *hdr;
+	int i =3D 0;
+	int err;
+
+	hdr =3D genlmsg_put(msg, portid, seq, &vdpa_nl_family, flags, VDPA_CMD_PA=
RENTDEV_NEW);
+	if (!hdr)
+		return -EMSGSIZE;
+	err =3D vdpa_nl_parentdev_handle_fill(msg, pdev);
+	if (err)
+		goto msg_err;
+
+	while (pdev->id_table[i].device) {
+		supported_classes |=3D BIT(pdev->id_table[i].device);
+		i++;
+	}
+
+	if (nla_put_u64_64bit(msg, VDPA_ATTR_PARENTDEV_SUPPORTED_CLASSES,
+			      supported_classes, VDPA_ATTR_UNSPEC)) {
+		err =3D -EMSGSIZE;
+		goto msg_err;
+	}
+
+	genlmsg_end(msg, hdr);
+	return 0;
+
+msg_err:
+	genlmsg_cancel(msg, hdr);
+	return err;
+}
+
+static int vdpa_nl_cmd_parentdev_get_doit(struct sk_buff *skb, struct genl=
_info *info)
+{
+	struct vdpa_parent_dev *pdev;
+	struct sk_buff *msg;
+	int err;
+
+	msg =3D nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!msg)
+		return -ENOMEM;
+
+	mutex_lock(&vdpa_dev_mutex);
+	pdev =3D vdpa_parentdev_get_from_attr(info->attrs);
+	if (IS_ERR(pdev)) {
+		mutex_unlock(&vdpa_dev_mutex);
+		NL_SET_ERR_MSG_MOD(info->extack, "Fail to find the specified parent devi=
ce");
+		err =3D PTR_ERR(pdev);
+		goto out;
+	}
+
+	err =3D vdpa_parentdev_fill(pdev, msg, info->snd_portid, info->snd_seq, 0=
);
+	mutex_unlock(&vdpa_dev_mutex);
+	if (err)
+		goto out;
+	err =3D genlmsg_reply(msg, info);
+	return err;
+
+out:
+	nlmsg_free(msg);
+	return err;
+}
+
+static int
+vdpa_nl_cmd_parentdev_get_dumpit(struct sk_buff *msg, struct netlink_callb=
ack *cb)
+{
+	struct vdpa_parent_dev *pdev;
+	int start =3D cb->args[0];
+	int idx =3D 0;
+	int err;
+
+	mutex_lock(&vdpa_dev_mutex);
+	list_for_each_entry(pdev, &pdev_head, list) {
+		if (idx < start) {
+			idx++;
+			continue;
+		}
+		err =3D vdpa_parentdev_fill(pdev, msg, NETLINK_CB(cb->skb).portid,
+					  cb->nlh->nlmsg_seq, NLM_F_MULTI);
+		if (err)
+			goto out;
+		idx++;
+	}
+out:
+	mutex_unlock(&vdpa_dev_mutex);
+	cb->args[0] =3D idx;
+	return msg->len;
+}
+
+static const struct nla_policy vdpa_nl_policy[VDPA_ATTR_MAX] =3D {
+	[VDPA_ATTR_PARENTDEV_BUS_NAME] =3D { .type =3D NLA_NUL_STRING },
+	[VDPA_ATTR_PARENTDEV_DEV_NAME] =3D { .type =3D NLA_STRING },
+};
+
+static const struct genl_ops vdpa_nl_ops[] =3D {
+	{
+		.cmd =3D VDPA_CMD_PARENTDEV_GET,
+		.validate =3D GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
+		.doit =3D vdpa_nl_cmd_parentdev_get_doit,
+		.dumpit =3D vdpa_nl_cmd_parentdev_get_dumpit,
+	},
+};
+
+static struct genl_family vdpa_nl_family __ro_after_init =3D {
+	.name =3D VDPA_GENL_NAME,
+	.version =3D VDPA_GENL_VERSION,
+	.maxattr =3D VDPA_ATTR_MAX,
+	.policy =3D vdpa_nl_policy,
+	.netnsok =3D false,
+	.module =3D THIS_MODULE,
+	.ops =3D vdpa_nl_ops,
+	.n_ops =3D ARRAY_SIZE(vdpa_nl_ops),
+};
+
 static int vdpa_init(void)
 {
-	return bus_register(&vdpa_bus);
+	int err;
+
+	err =3D bus_register(&vdpa_bus);
+	if (err)
+		return err;
+	err =3D genl_register_family(&vdpa_nl_family);
+	if (err)
+		goto err;
+	return 0;
+
+err:
+	bus_unregister(&vdpa_bus);
+	return err;
 }
=20
 static void __exit vdpa_exit(void)
 {
+	genl_unregister_family(&vdpa_nl_family);
 	bus_unregister(&vdpa_bus);
 	ida_destroy(&vdpa_index_ida);
 }
diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
index 5700baa22356..3d6bc1fb909d 100644
--- a/include/linux/vdpa.h
+++ b/include/linux/vdpa.h
@@ -35,6 +35,8 @@ struct vdpa_vq_state {
 	u16	avail_index;
 };
=20
+struct vdpa_parent_dev;
+
 /**
  * vDPA device - representation of a vDPA device
  * @dev: underlying device
@@ -335,4 +337,34 @@ static inline void vdpa_get_config(struct vdpa_device =
*vdev, unsigned offset,
 	ops->get_config(vdev, offset, buf, len);
 }
=20
+/**
+ * vdpa_dev_ops - vdpa device ops
+ * @dev_add:	Add a vdpa device using alloc and register
+ *		@pdev: parent device to use for device addition
+ *		@name: name of the new vdpa device
+ *		@device_id: device id of the new vdpa device
+ *		Driver need to add a new device using vdpa_register_device() after
+ *		fully initializing the vdpa device. On successful addition driver
+ *		must return a valid pointer of vdpa device or ERR_PTR for the error.
+ * @dev_del:	Remove a vdpa device using unregister
+ *		@pdev: parent device to use for device removal
+ *		@dev: vdpa device to remove
+ *		Driver need to remove the specified device by calling vdpa_unregister_=
device().
+ */
+struct vdpa_dev_ops {
+	struct vdpa_device* (*dev_add)(struct vdpa_parent_dev *pdev, const char *=
name,
+				       u32 device_id);
+	void (*dev_del)(struct vdpa_parent_dev *pdev, struct vdpa_device *dev);
+};
+
+struct vdpa_parent_dev {
+	struct device *device;
+	const struct vdpa_dev_ops *ops;
+	const struct virtio_device_id *id_table; /* supported ids */
+	struct list_head list;
+};
+
+int vdpa_parentdev_register(struct vdpa_parent_dev *pdev);
+void vdpa_parentdev_unregister(struct vdpa_parent_dev *pdev);
+
 #endif /* _LINUX_VDPA_H */
diff --git a/include/uapi/linux/vdpa.h b/include/uapi/linux/vdpa.h
new file mode 100644
index 000000000000..6d88022f6a95
--- /dev/null
+++ b/include/uapi/linux/vdpa.h
@@ -0,0 +1,32 @@
+/* SPDX-License-Identifier: GPL-2.0+ WITH Linux-syscall-note */
+/*
+ * vdpa device management interface
+ * Copyright (c) 2020 Mellanox Technologies Ltd. All rights reserved.
+ */
+
+#ifndef _UAPI_LINUX_VDPA_H_
+#define _UAPI_LINUX_VDPA_H_
+
+#define VDPA_GENL_NAME "vdpa"
+#define VDPA_GENL_VERSION 0x1
+#define VDPA_GENL_MCGRP_CONFIG_NAME "config"
+
+enum vdpa_command {
+	VDPA_CMD_UNSPEC,
+	VDPA_CMD_PARENTDEV_NEW,
+	VDPA_CMD_PARENTDEV_GET,		/* can dump */
+};
+
+enum vdpa_attr {
+	VDPA_ATTR_UNSPEC,
+
+	/* bus name (optional) + dev name together make the parent device handle =
*/
+	VDPA_ATTR_PARENTDEV_BUS_NAME,		/* string */
+	VDPA_ATTR_PARENTDEV_DEV_NAME,		/* string */
+	VDPA_ATTR_PARENTDEV_SUPPORTED_CLASSES,	/* u64 */
+
+	/* new attributes must be added above here */
+	VDPA_ATTR_MAX,
+};
+
+#endif
--=20
2.26.2

