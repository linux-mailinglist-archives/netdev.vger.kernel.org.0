Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 869C42E8F9A
	for <lists+netdev@lfdr.de>; Mon,  4 Jan 2021 04:35:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728055AbhADDdE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jan 2021 22:33:04 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:15018 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727058AbhADDdC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Jan 2021 22:33:02 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5ff28c450001>; Sun, 03 Jan 2021 19:32:21 -0800
Received: from sw-mtx-036.mtx.labs.mlnx (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 4 Jan
 2021 03:32:20 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     <virtualization@lists.linux-foundation.org>
CC:     <mst@redhat.com>, <jasowang@redhat.com>, <parav@nvidia.com>,
        <elic@nvidia.com>, <netdev@vger.kernel.org>
Subject: [PATCH linux-next v2 4/7] vdpa: Define vdpa mgmt device, ops and a netlink interface
Date:   Mon, 4 Jan 2021 05:31:38 +0200
Message-ID: <20210104033141.105876-5-parav@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210104033141.105876-1-parav@nvidia.com>
References: <20201112064005.349268-1-parav@nvidia.com>
 <20210104033141.105876-1-parav@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1609731141; bh=ofIJRA/b8xkFHNTdriHNFxuKWNDSf8eCy2FFZ0JcgK0=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=DT2FBhAb2yVjz2FUagYuV27YQ4ZhbHGD0imfXHGsHfq1FJBkmYUDBzBMI7yTDQxZQ
         CGB9yoDyFUQJ8Dy5jRo2pSHqOOUfq8uA4uQT24EE1TmTW3Yow4R/p93OFLPy4STGA6
         CTvxNEtVePW+e6V9hmugPHA4EdsRQe4aUBODO/gZtlvoMorFgdZXsCjQ5UVVr/+qWh
         aRCn/+Z3V2vS5SRkpVnuBP7K6q+DI4iMpACfNizhsK3ZvA08IWVF4N587ybeF7sB7w
         RyypdGkdHK4NCgo1eoGexQVM5KHbI3anoEcjPpnzZ+4fI/AiBEXttJvurQkMY3af5y
         BIrFcUj/Bpxtw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To add one or more VDPA devices, define a management device which
allows adding or removing vdpa device. A management device defines
set of callbacks to manage vdpa devices.

To begin with, it defines add and remove callbacks through which a user
defined vdpa device can be added or removed.

A unique management device is identified by its unique handle identified
by management device name and optionally the bus name.

Hence, introduce routine through which driver can register a
management device and its callback operations for adding and remove
a vdpa device.

Introduce vdpa netlink socket family so that user can query management
device and its attributes.

Example of show vdpa management device which allows creating vdpa device of
networking class (device id =3D 0x1) of virtio specification 1.1
section 5.1.1.

$ vdpa mgmtdev show
vdpasim_net:
  supported_classes:
    net

Example of showing vdpa management device in JSON format.

$ vdpa mgmtdev show -jp
{
    "show": {
        "vdpasim_net": {
            "supported_classes": [ "net" ]
        }
    }
}

Signed-off-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Eli Cohen <elic@nvidia.com>
Reviewed-by: Jason Wang <jasowang@redhat.com>
---
Changelog:
v1->v2:
 - rebased
 - updated commit log example for management device name from
   "vdpasim" to "vdpasim_net"
 - removed device_id as net and block management devices are separated
 - dev_add() return type is changed from struct vdpa_device to int
---
 drivers/vdpa/Kconfig      |   1 +
 drivers/vdpa/vdpa.c       | 213 +++++++++++++++++++++++++++++++++++++-
 include/linux/vdpa.h      |  31 ++++++
 include/uapi/linux/vdpa.h |  31 ++++++
 4 files changed, 275 insertions(+), 1 deletion(-)
 create mode 100644 include/uapi/linux/vdpa.h

diff --git a/drivers/vdpa/Kconfig b/drivers/vdpa/Kconfig
index 92a6396f8a73..ffd1e098bfd2 100644
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
index 7414bbd9057c..319d09709dfc 100644
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
+static LIST_HEAD(mdev_head);
 /* A global mutex that protects vdpa management device and device level op=
erations. */
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
+ * vdpa_mgmtdev_register - register a vdpa management device
+ *
+ * @mdev: Pointer to vdpa management device
+ * vdpa_mgmtdev_register() register a vdpa management device which support=
s
+ * vdpa device management.
+ */
+int vdpa_mgmtdev_register(struct vdpa_mgmt_dev *mdev)
+{
+	if (!mdev->device || !mdev->ops || !mdev->ops->dev_add || !mdev->ops->dev=
_del)
+		return -EINVAL;
+
+	INIT_LIST_HEAD(&mdev->list);
+	mutex_lock(&vdpa_dev_mutex);
+	list_add_tail(&mdev->list, &mdev_head);
+	mutex_unlock(&vdpa_dev_mutex);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(vdpa_mgmtdev_register);
+
+void vdpa_mgmtdev_unregister(struct vdpa_mgmt_dev *mdev)
+{
+	mutex_lock(&vdpa_dev_mutex);
+	list_del(&mdev->list);
+	mutex_unlock(&vdpa_dev_mutex);
+}
+EXPORT_SYMBOL_GPL(vdpa_mgmtdev_unregister);
+
+static bool mgmtdev_handle_match(const struct vdpa_mgmt_dev *mdev,
+				 const char *busname, const char *devname)
+{
+	/* Bus name is optional for simulated management device, so ignore the
+	 * device with bus if bus attribute is provided.
+	 */
+	if ((busname && !mdev->device->bus) || (!busname && mdev->device->bus))
+		return false;
+
+	if (!busname && strcmp(dev_name(mdev->device), devname) =3D=3D 0)
+		return true;
+
+	if (busname && (strcmp(mdev->device->bus->name, busname) =3D=3D 0) &&
+	    (strcmp(dev_name(mdev->device), devname) =3D=3D 0))
+		return true;
+
+	return false;
+}
+
+static struct vdpa_mgmt_dev *vdpa_mgmtdev_get_from_attr(struct nlattr **at=
trs)
+{
+	struct vdpa_mgmt_dev *mdev;
+	const char *busname =3D NULL;
+	const char *devname;
+
+	if (!attrs[VDPA_ATTR_MGMTDEV_DEV_NAME])
+		return ERR_PTR(-EINVAL);
+	devname =3D nla_data(attrs[VDPA_ATTR_MGMTDEV_DEV_NAME]);
+	if (attrs[VDPA_ATTR_MGMTDEV_BUS_NAME])
+		busname =3D nla_data(attrs[VDPA_ATTR_MGMTDEV_BUS_NAME]);
+
+	list_for_each_entry(mdev, &mdev_head, list) {
+		if (mgmtdev_handle_match(mdev, busname, devname))
+			return mdev;
+	}
+	return ERR_PTR(-ENODEV);
+}
+
+static int vdpa_nl_mgmtdev_handle_fill(struct sk_buff *msg, const struct v=
dpa_mgmt_dev *mdev)
+{
+	if (mdev->device->bus &&
+	    nla_put_string(msg, VDPA_ATTR_MGMTDEV_BUS_NAME, mdev->device->bus->na=
me))
+		return -EMSGSIZE;
+	if (nla_put_string(msg, VDPA_ATTR_MGMTDEV_DEV_NAME, dev_name(mdev->device=
)))
+		return -EMSGSIZE;
+	return 0;
+}
+
+static int vdpa_mgmtdev_fill(const struct vdpa_mgmt_dev *mdev, struct sk_b=
uff *msg,
+			     u32 portid, u32 seq, int flags)
+{
+	u64 supported_classes =3D 0;
+	void *hdr;
+	int i =3D 0;
+	int err;
+
+	hdr =3D genlmsg_put(msg, portid, seq, &vdpa_nl_family, flags, VDPA_CMD_MG=
MTDEV_NEW);
+	if (!hdr)
+		return -EMSGSIZE;
+	err =3D vdpa_nl_mgmtdev_handle_fill(msg, mdev);
+	if (err)
+		goto msg_err;
+
+	while (mdev->id_table[i].device) {
+		supported_classes |=3D BIT(mdev->id_table[i].device);
+		i++;
+	}
+
+	if (nla_put_u64_64bit(msg, VDPA_ATTR_MGMTDEV_SUPPORTED_CLASSES,
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
+static int vdpa_nl_cmd_mgmtdev_get_doit(struct sk_buff *skb, struct genl_i=
nfo *info)
+{
+	struct vdpa_mgmt_dev *mdev;
+	struct sk_buff *msg;
+	int err;
+
+	msg =3D nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!msg)
+		return -ENOMEM;
+
+	mutex_lock(&vdpa_dev_mutex);
+	mdev =3D vdpa_mgmtdev_get_from_attr(info->attrs);
+	if (IS_ERR(mdev)) {
+		mutex_unlock(&vdpa_dev_mutex);
+		NL_SET_ERR_MSG_MOD(info->extack, "Fail to find the specified mgmt device=
");
+		err =3D PTR_ERR(mdev);
+		goto out;
+	}
+
+	err =3D vdpa_mgmtdev_fill(mdev, msg, info->snd_portid, info->snd_seq, 0);
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
+vdpa_nl_cmd_mgmtdev_get_dumpit(struct sk_buff *msg, struct netlink_callbac=
k *cb)
+{
+	struct vdpa_mgmt_dev *mdev;
+	int start =3D cb->args[0];
+	int idx =3D 0;
+	int err;
+
+	mutex_lock(&vdpa_dev_mutex);
+	list_for_each_entry(mdev, &mdev_head, list) {
+		if (idx < start) {
+			idx++;
+			continue;
+		}
+		err =3D vdpa_mgmtdev_fill(mdev, msg, NETLINK_CB(cb->skb).portid,
+					cb->nlh->nlmsg_seq, NLM_F_MULTI);
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
+	[VDPA_ATTR_MGMTDEV_BUS_NAME] =3D { .type =3D NLA_NUL_STRING },
+	[VDPA_ATTR_MGMTDEV_DEV_NAME] =3D { .type =3D NLA_STRING },
+};
+
+static const struct genl_ops vdpa_nl_ops[] =3D {
+	{
+		.cmd =3D VDPA_CMD_MGMTDEV_GET,
+		.validate =3D GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
+		.doit =3D vdpa_nl_cmd_mgmtdev_get_doit,
+		.dumpit =3D vdpa_nl_cmd_mgmtdev_get_dumpit,
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
index 5700baa22356..6b8b4222bca6 100644
--- a/include/linux/vdpa.h
+++ b/include/linux/vdpa.h
@@ -35,6 +35,8 @@ struct vdpa_vq_state {
 	u16	avail_index;
 };
=20
+struct vdpa_mgmt_dev;
+
 /**
  * vDPA device - representation of a vDPA device
  * @dev: underlying device
@@ -335,4 +337,33 @@ static inline void vdpa_get_config(struct vdpa_device =
*vdev, unsigned offset,
 	ops->get_config(vdev, offset, buf, len);
 }
=20
+/**
+ * vdpa_mgmtdev_ops - vdpa device ops
+ * @dev_add:	Add a vdpa device using alloc and register
+ *		@mdev: parent device to use for device addition
+ *		@name: name of the new vdpa device
+ *		Driver need to add a new device using _vdpa_register_device()
+ *		after fully initializing the vdpa device. Driver must return 0
+ *		on success or appropriate error code.
+ * @dev_del:	Remove a vdpa device using unregister
+ *		@mdev: parent device to use for device removal
+ *		@dev: vdpa device to remove
+ *		Driver need to remove the specified device by calling
+ *		_vdpa_unregister_device().
+ */
+struct vdpa_mgmtdev_ops {
+	int (*dev_add)(struct vdpa_mgmt_dev *mdev, const char *name);
+	void (*dev_del)(struct vdpa_mgmt_dev *mdev, struct vdpa_device *dev);
+};
+
+struct vdpa_mgmt_dev {
+	struct device *device;
+	const struct vdpa_mgmtdev_ops *ops;
+	const struct virtio_device_id *id_table; /* supported ids */
+	struct list_head list;
+};
+
+int vdpa_mgmtdev_register(struct vdpa_mgmt_dev *mdev);
+void vdpa_mgmtdev_unregister(struct vdpa_mgmt_dev *mdev);
+
 #endif /* _LINUX_VDPA_H */
diff --git a/include/uapi/linux/vdpa.h b/include/uapi/linux/vdpa.h
new file mode 100644
index 000000000000..d44d82e567b1
--- /dev/null
+++ b/include/uapi/linux/vdpa.h
@@ -0,0 +1,31 @@
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
+
+enum vdpa_command {
+	VDPA_CMD_UNSPEC,
+	VDPA_CMD_MGMTDEV_NEW,
+	VDPA_CMD_MGMTDEV_GET,		/* can dump */
+};
+
+enum vdpa_attr {
+	VDPA_ATTR_UNSPEC,
+
+	/* bus name (optional) + dev name together make the parent device handle =
*/
+	VDPA_ATTR_MGMTDEV_BUS_NAME,		/* string */
+	VDPA_ATTR_MGMTDEV_DEV_NAME,		/* string */
+	VDPA_ATTR_MGMTDEV_SUPPORTED_CLASSES,	/* u64 */
+
+	/* new attributes must be added above here */
+	VDPA_ATTR_MAX,
+};
+
+#endif
--=20
2.26.2

