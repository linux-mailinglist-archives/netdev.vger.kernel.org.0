Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB2322AFFC9
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 07:40:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726532AbgKLGkq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 01:40:46 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:5890 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726233AbgKLGke (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 01:40:34 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5facd8e50000>; Wed, 11 Nov 2020 22:40:37 -0800
Received: from sw-mtx-036.mtx.labs.mlnx (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 12 Nov
 2020 06:40:32 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     <virtualization@lists.linux-foundation.org>
CC:     <mst@redhat.com>, <jasowang@redhat.com>, <parav@nvidia.com>,
        <elic@nvidia.com>, <netdev@vger.kernel.org>
Subject: [PATCH 5/7] vdpa: Enable a user to add and delete a vdpa device
Date:   Thu, 12 Nov 2020 08:40:03 +0200
Message-ID: <20201112064005.349268-6-parav@nvidia.com>
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
        t=1605163237; bh=FbnxGUSw/au84kScV+/AAWX3SShki3kIEmf9eO9tD+g=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=fGLNVK4+8D2P5VDceDq6TTWibmMjFl77ItsSzV4KIXJL8i1zY3V/UhKc9hGVBE/Jg
         SN0asuUIssD+8lok7OEnyZ7TI+PkK8LEMFqNd6HyMyc1PGdhwAKy5ZhYECXslY+on3
         DbYopCJFeTray830LsPibm7wsK1k4COs8ciwMS2AckhtHXDdrVbF9UPiywLo6aL48g
         CbhrseroAx4dffP9t1qrlpYzQPZoL+KOlbP2LeQaAigLGCtcVEXF/iPfqhVc36iOxw
         n22W4xpXUndDEZJm0tqbTeFLsgFoYVAgUjxfCQ+jyZ4XGCLJYcrNFQOCU1t00f5ad/
         OqBI735xyjntg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the ability to add and delete a vdpa device.

Examples:
Create a vdpa device of type network named "foo2" from
the parent device vdpasim:

$ vdpa dev add parentdev vdpasim type net name foo2

Delete the vdpa device after its use:
$ vdpa dev del foo2

Signed-off-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Eli Cohen <elic@nvidia.com>
Reviewed-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vdpa/vdpa.c       | 149 +++++++++++++++++++++++++++++++++++---
 include/linux/vdpa.h      |   6 ++
 include/uapi/linux/vdpa.h |   5 ++
 3 files changed, 150 insertions(+), 10 deletions(-)

diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
index 273639038851..fcbdc8f10206 100644
--- a/drivers/vdpa/vdpa.c
+++ b/drivers/vdpa/vdpa.c
@@ -136,6 +136,37 @@ static int vdpa_name_match(struct device *dev, const v=
oid *data)
 	return (strcmp(dev_name(&vdev->dev), data) =3D=3D 0);
 }
=20
+static int __vdpa_register_device(struct vdpa_device *vdev)
+{
+	struct device *dev;
+
+	lockdep_assert_held(&vdpa_dev_mutex);
+	dev =3D bus_find_device(&vdpa_bus, NULL, dev_name(&vdev->dev), vdpa_name_=
match);
+	if (dev) {
+		put_device(dev);
+		return -EEXIST;
+	}
+	return device_add(&vdev->dev);
+}
+
+/**
+ * _vdpa_register_device - register a vDPA device with vdpa lock held
+ * Caller must have a succeed call of vdpa_alloc_device() before.
+ * Caller must invoke this routine as part of parent device dev_add() call=
back
+ * after setting up valid parentdev for this vdpa device.
+ * @vdev: the vdpa device to be registered to vDPA bus
+ *
+ * Returns an error when fail to add device to vDPA bus
+ */
+int _vdpa_register_device(struct vdpa_device *vdev)
+{
+	if (!vdev->pdev)
+		return -EINVAL;
+
+	return __vdpa_register_device(vdev);
+}
+EXPORT_SYMBOL_GPL(_vdpa_register_device);
+
 /**
  * vdpa_register_device - register a vDPA device
  * Callers must have a succeed call of vdpa_alloc_device() before.
@@ -145,24 +176,28 @@ static int vdpa_name_match(struct device *dev, const =
void *data)
  */
 int vdpa_register_device(struct vdpa_device *vdev)
 {
-	struct device *dev;
 	int err;
=20
 	mutex_lock(&vdpa_dev_mutex);
-	dev =3D bus_find_device(&vdpa_bus, NULL, dev_name(&vdev->dev), vdpa_name_=
match);
-	if (dev) {
-		put_device(dev);
-		err =3D -EEXIST;
-		goto name_err;
-	}
-
-	err =3D device_add(&vdev->dev);
-name_err:
+	err =3D __vdpa_register_device(vdev);
 	mutex_unlock(&vdpa_dev_mutex);
 	return err;
 }
 EXPORT_SYMBOL_GPL(vdpa_register_device);
=20
+/**
+ * _vdpa_unregister_device - unregister a vDPA device
+ * Caller must invoke this routine as part of parent device dev_del() call=
back.
+ * @vdev: the vdpa device to be unregisted from vDPA bus
+ */
+void _vdpa_unregister_device(struct vdpa_device *vdev)
+{
+	lockdep_assert_held(&vdpa_dev_mutex);
+	WARN_ON(!vdev->pdev);
+	device_unregister(&vdev->dev);
+}
+EXPORT_SYMBOL_GPL(_vdpa_unregister_device);
+
 /**
  * vdpa_unregister_device - unregister a vDPA device
  * @vdev: the vdpa device to be unregisted from vDPA bus
@@ -221,10 +256,25 @@ int vdpa_parentdev_register(struct vdpa_parent_dev *p=
dev)
 }
 EXPORT_SYMBOL_GPL(vdpa_parentdev_register);
=20
+static int vdpa_match_remove(struct device *dev, void *data)
+{
+	struct vdpa_device *vdev =3D container_of(dev, struct vdpa_device, dev);
+	struct vdpa_parent_dev *pdev =3D vdev->pdev;
+
+	if (pdev =3D=3D data)
+		pdev->ops->dev_del(pdev, vdev);
+	return 0;
+}
+
 void vdpa_parentdev_unregister(struct vdpa_parent_dev *pdev)
 {
 	mutex_lock(&vdpa_dev_mutex);
+
 	list_del(&pdev->list);
+
+	/* Filter out all the entries belong to this parent device and delete it.=
 */
+	bus_for_each_dev(&vdpa_bus, NULL, pdev, vdpa_match_remove);
+
 	mutex_unlock(&vdpa_dev_mutex);
 }
 EXPORT_SYMBOL_GPL(vdpa_parentdev_unregister);
@@ -368,9 +418,76 @@ vdpa_nl_cmd_parentdev_get_dumpit(struct sk_buff *msg, =
struct netlink_callback *c
 	return msg->len;
 }
=20
+static int vdpa_nl_cmd_dev_add_set_doit(struct sk_buff *skb, struct genl_i=
nfo *info)
+{
+	struct vdpa_parent_dev *pdev;
+	struct vdpa_device *vdev;
+	const char *name;
+	u32 device_id;
+	int err =3D 0;
+
+	if (!info->attrs[VDPA_ATTR_DEV_NAME] || !info->attrs[VDPA_ATTR_DEV_ID])
+		return -EINVAL;
+
+	name =3D nla_data(info->attrs[VDPA_ATTR_DEV_NAME]);
+	device_id =3D nla_get_u32(info->attrs[VDPA_ATTR_DEV_ID]);
+
+	mutex_lock(&vdpa_dev_mutex);
+	pdev =3D vdpa_parentdev_get_from_attr(info->attrs);
+	if (IS_ERR(pdev)) {
+		NL_SET_ERR_MSG_MOD(info->extack, "Fail to find the specified parent devi=
ce");
+		err =3D PTR_ERR(pdev);
+		goto err;
+	}
+
+	vdev =3D pdev->ops->dev_add(pdev, name, device_id);
+	if (IS_ERR(vdev))
+		goto err;
+
+err:
+	mutex_unlock(&vdpa_dev_mutex);
+	return err;
+}
+
+static int vdpa_nl_cmd_dev_del_set_doit(struct sk_buff *skb, struct genl_i=
nfo *info)
+{
+	struct vdpa_parent_dev *pdev;
+	struct vdpa_device *vdev;
+	struct device *dev;
+	const char *name;
+	int err =3D 0;
+
+	if (!info->attrs[VDPA_ATTR_DEV_NAME])
+		return -EINVAL;
+	name =3D nla_data(info->attrs[VDPA_ATTR_DEV_NAME]);
+
+	mutex_lock(&vdpa_dev_mutex);
+	dev =3D bus_find_device(&vdpa_bus, NULL, name, vdpa_name_match);
+	if (!dev) {
+		NL_SET_ERR_MSG_MOD(info->extack, "device not found");
+		err =3D -ENODEV;
+		goto dev_err;
+	}
+	vdev =3D container_of(dev, struct vdpa_device, dev);
+	if (!vdev->pdev) {
+		NL_SET_ERR_MSG_MOD(info->extack, "Only user created device can be delete=
d by user");
+		err =3D -EINVAL;
+		goto pdev_err;
+	}
+	pdev =3D vdev->pdev;
+	pdev->ops->dev_del(pdev, vdev);
+pdev_err:
+	put_device(dev);
+dev_err:
+	mutex_unlock(&vdpa_dev_mutex);
+	return err;
+}
+
 static const struct nla_policy vdpa_nl_policy[VDPA_ATTR_MAX] =3D {
 	[VDPA_ATTR_PARENTDEV_BUS_NAME] =3D { .type =3D NLA_NUL_STRING },
 	[VDPA_ATTR_PARENTDEV_DEV_NAME] =3D { .type =3D NLA_STRING },
+	[VDPA_ATTR_DEV_NAME] =3D { .type =3D NLA_STRING },
+	[VDPA_ATTR_DEV_ID] =3D { .type =3D NLA_U32 },
 };
=20
 static const struct genl_ops vdpa_nl_ops[] =3D {
@@ -380,6 +497,18 @@ static const struct genl_ops vdpa_nl_ops[] =3D {
 		.doit =3D vdpa_nl_cmd_parentdev_get_doit,
 		.dumpit =3D vdpa_nl_cmd_parentdev_get_dumpit,
 	},
+	{
+		.cmd =3D VDPA_CMD_DEV_NEW,
+		.validate =3D GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
+		.doit =3D vdpa_nl_cmd_dev_add_set_doit,
+		.flags =3D GENL_ADMIN_PERM,
+	},
+	{
+		.cmd =3D VDPA_CMD_DEV_DEL,
+		.validate =3D GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
+		.doit =3D vdpa_nl_cmd_dev_del_set_doit,
+		.flags =3D GENL_ADMIN_PERM,
+	},
 };
=20
 static struct genl_family vdpa_nl_family __ro_after_init =3D {
diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
index 3d6bc1fb909d..cb5a3d847af3 100644
--- a/include/linux/vdpa.h
+++ b/include/linux/vdpa.h
@@ -45,6 +45,8 @@ struct vdpa_parent_dev;
  * @index: device index
  * @features_valid: were features initialized? for legacy guests
  * @nvqs: maximum number of supported virtqueues
+ * @pdev: parent device pointer; caller must setup when registering device=
 as part
+ *	  of dev_add() parentdev ops callback before invoking _vdpa_register_de=
vice().
  */
 struct vdpa_device {
 	struct device dev;
@@ -53,6 +55,7 @@ struct vdpa_device {
 	unsigned int index;
 	bool features_valid;
 	int nvqs;
+	struct vdpa_parent_dev *pdev;
 };
=20
 /**
@@ -260,6 +263,9 @@ struct vdpa_device *__vdpa_alloc_device(struct device *=
parent,
 int vdpa_register_device(struct vdpa_device *vdev);
 void vdpa_unregister_device(struct vdpa_device *vdev);
=20
+int _vdpa_register_device(struct vdpa_device *vdev);
+void _vdpa_unregister_device(struct vdpa_device *vdev);
+
 /**
  * vdpa_driver - operations for a vDPA driver
  * @driver: underlying device driver
diff --git a/include/uapi/linux/vdpa.h b/include/uapi/linux/vdpa.h
index 6d88022f6a95..c528a9cfd6c9 100644
--- a/include/uapi/linux/vdpa.h
+++ b/include/uapi/linux/vdpa.h
@@ -15,6 +15,8 @@ enum vdpa_command {
 	VDPA_CMD_UNSPEC,
 	VDPA_CMD_PARENTDEV_NEW,
 	VDPA_CMD_PARENTDEV_GET,		/* can dump */
+	VDPA_CMD_DEV_NEW,
+	VDPA_CMD_DEV_DEL,
 };
=20
 enum vdpa_attr {
@@ -25,6 +27,9 @@ enum vdpa_attr {
 	VDPA_ATTR_PARENTDEV_DEV_NAME,		/* string */
 	VDPA_ATTR_PARENTDEV_SUPPORTED_CLASSES,	/* u64 */
=20
+	VDPA_ATTR_DEV_NAME,			/* string */
+	VDPA_ATTR_DEV_ID,			/* u32 */
+
 	/* new attributes must be added above here */
 	VDPA_ATTR_MAX,
 };
--=20
2.26.2

