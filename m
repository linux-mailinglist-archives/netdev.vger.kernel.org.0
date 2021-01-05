Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FDDB2EA8D8
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 11:34:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729209AbhAEKdH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 05:33:07 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:13528 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728460AbhAEKdF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 05:33:05 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5ff440390000>; Tue, 05 Jan 2021 02:32:25 -0800
Received: from sw-mtx-036.mtx.labs.mlnx (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 5 Jan
 2021 10:32:24 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     <virtualization@lists.linux-foundation.org>
CC:     <mst@redhat.com>, <jasowang@redhat.com>, <parav@nvidia.com>,
        <elic@nvidia.com>, <netdev@vger.kernel.org>
Subject: [PATCH linux-next v3 4/6] vdpa: Enable a user to add and delete a vdpa device
Date:   Tue, 5 Jan 2021 12:32:01 +0200
Message-ID: <20210105103203.82508-5-parav@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210105103203.82508-1-parav@nvidia.com>
References: <20201112064005.349268-1-parav@nvidia.com>
 <20210105103203.82508-1-parav@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1609842745; bh=wkdbaT79pbyJG3mlfG5sfwATHT28AJLLnK9Z0Kdx4dI=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=jgT/xUI8W9X4Y5RGlfGnWt55cAvbdkPNDi78SpSpSkta2p9j/Sj9cSl3wG0dWrIjZ
         tjPSarXVSK/xALxRamZI6iNFq4xjgy8d6DfkF4Fgev7Y7gtgYXs8YbnSTrywywdT9P
         ytfpAU9GPpGoAxo8y4bKEl/hetGouKLG0tzg6OusBjrsEbzz8KN3rElysldde8FE/7
         pb/VOL3oLgfEW2h5ytTHVjulL7VzJoztHG1Hnu3HIYP50zQxqp3bw2Km8wXnyVpmqs
         VJc2aXCc0uZ3WCv7TRpK/h9u00leWS1wMlJZsnDRFkuUU+qdh/+weiua85wBYuM+N3
         A/QojWVe3e9lw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the ability to add and delete a vdpa device.

Examples:
Create a vdpa device of type network named "foo2" from
the management device vdpasim:

$ vdpa dev add mgmtdev vdpasim_net name foo2

Delete the vdpa device after its use:
$ vdpa dev del foo2

Signed-off-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Eli Cohen <elic@nvidia.com>
Reviewed-by: Jason Wang <jasowang@redhat.com>

---
Changelog:
v1->v2:
 - using int return type for dev_add callback
 - removed device_id (type) as current drivers only supports single type
---
 drivers/vdpa/vdpa.c       | 143 +++++++++++++++++++++++++++++++++++---
 include/linux/vdpa.h      |   6 ++
 include/uapi/linux/vdpa.h |   4 ++
 3 files changed, 143 insertions(+), 10 deletions(-)

diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
index 319d09709dfc..dca67e4d32e5 100644
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
+ * Caller must invoke this routine in the management device dev_add()
+ * callback after setting up valid mgmtdev for this vdpa device.
+ * @vdev: the vdpa device to be registered to vDPA bus
+ *
+ * Returns an error when fail to add device to vDPA bus
+ */
+int _vdpa_register_device(struct vdpa_device *vdev)
+{
+	if (!vdev->mdev)
+		return -EINVAL;
+
+	return __vdpa_register_device(vdev);
+}
+EXPORT_SYMBOL_GPL(_vdpa_register_device);
+
 /**
  * vdpa_register_device - register a vDPA device
  * Callers must have a succeed call of vdpa_alloc_device() before.
@@ -145,24 +176,29 @@ static int vdpa_name_match(struct device *dev, const =
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
+ * Caller must invoke this routine as part of management device dev_del()
+ * callback.
+ * @vdev: the vdpa device to be unregisted from vDPA bus
+ */
+void _vdpa_unregister_device(struct vdpa_device *vdev)
+{
+	lockdep_assert_held(&vdpa_dev_mutex);
+	WARN_ON(!vdev->mdev);
+	device_unregister(&vdev->dev);
+}
+EXPORT_SYMBOL_GPL(_vdpa_unregister_device);
+
 /**
  * vdpa_unregister_device - unregister a vDPA device
  * @vdev: the vdpa device to be unregisted from vDPA bus
@@ -221,10 +257,25 @@ int vdpa_mgmtdev_register(struct vdpa_mgmt_dev *mdev)
 }
 EXPORT_SYMBOL_GPL(vdpa_mgmtdev_register);
=20
+static int vdpa_match_remove(struct device *dev, void *data)
+{
+	struct vdpa_device *vdev =3D container_of(dev, struct vdpa_device, dev);
+	struct vdpa_mgmt_dev *mdev =3D vdev->mdev;
+
+	if (mdev =3D=3D data)
+		mdev->ops->dev_del(mdev, vdev);
+	return 0;
+}
+
 void vdpa_mgmtdev_unregister(struct vdpa_mgmt_dev *mdev)
 {
 	mutex_lock(&vdpa_dev_mutex);
+
 	list_del(&mdev->list);
+
+	/* Filter out all the entries belong to this management device and delete=
 it. */
+	bus_for_each_dev(&vdpa_bus, NULL, mdev, vdpa_match_remove);
+
 	mutex_unlock(&vdpa_dev_mutex);
 }
 EXPORT_SYMBOL_GPL(vdpa_mgmtdev_unregister);
@@ -368,9 +419,69 @@ vdpa_nl_cmd_mgmtdev_get_dumpit(struct sk_buff *msg, st=
ruct netlink_callback *cb)
 	return msg->len;
 }
=20
+static int vdpa_nl_cmd_dev_add_set_doit(struct sk_buff *skb, struct genl_i=
nfo *info)
+{
+	struct vdpa_mgmt_dev *mdev;
+	const char *name;
+	int err =3D 0;
+
+	if (!info->attrs[VDPA_ATTR_DEV_NAME])
+		return -EINVAL;
+
+	name =3D nla_data(info->attrs[VDPA_ATTR_DEV_NAME]);
+
+	mutex_lock(&vdpa_dev_mutex);
+	mdev =3D vdpa_mgmtdev_get_from_attr(info->attrs);
+	if (IS_ERR(mdev)) {
+		NL_SET_ERR_MSG_MOD(info->extack, "Fail to find the specified management =
device");
+		err =3D PTR_ERR(mdev);
+		goto err;
+	}
+
+	err =3D mdev->ops->dev_add(mdev, name);
+err:
+	mutex_unlock(&vdpa_dev_mutex);
+	return err;
+}
+
+static int vdpa_nl_cmd_dev_del_set_doit(struct sk_buff *skb, struct genl_i=
nfo *info)
+{
+	struct vdpa_mgmt_dev *mdev;
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
+	if (!vdev->mdev) {
+		NL_SET_ERR_MSG_MOD(info->extack, "Only user created device can be delete=
d by user");
+		err =3D -EINVAL;
+		goto mdev_err;
+	}
+	mdev =3D vdev->mdev;
+	mdev->ops->dev_del(mdev, vdev);
+mdev_err:
+	put_device(dev);
+dev_err:
+	mutex_unlock(&vdpa_dev_mutex);
+	return err;
+}
+
 static const struct nla_policy vdpa_nl_policy[VDPA_ATTR_MAX] =3D {
 	[VDPA_ATTR_MGMTDEV_BUS_NAME] =3D { .type =3D NLA_NUL_STRING },
 	[VDPA_ATTR_MGMTDEV_DEV_NAME] =3D { .type =3D NLA_STRING },
+	[VDPA_ATTR_DEV_NAME] =3D { .type =3D NLA_STRING },
 };
=20
 static const struct genl_ops vdpa_nl_ops[] =3D {
@@ -380,6 +491,18 @@ static const struct genl_ops vdpa_nl_ops[] =3D {
 		.doit =3D vdpa_nl_cmd_mgmtdev_get_doit,
 		.dumpit =3D vdpa_nl_cmd_mgmtdev_get_dumpit,
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
index 6b8b4222bca6..4ab5494503a8 100644
--- a/include/linux/vdpa.h
+++ b/include/linux/vdpa.h
@@ -45,6 +45,8 @@ struct vdpa_mgmt_dev;
  * @index: device index
  * @features_valid: were features initialized? for legacy guests
  * @nvqs: maximum number of supported virtqueues
+ * @mdev: management device pointer; caller must setup when registering de=
vice as part
+ *	  of dev_add() mgmtdev ops callback before invoking _vdpa_register_devi=
ce().
  */
 struct vdpa_device {
 	struct device dev;
@@ -53,6 +55,7 @@ struct vdpa_device {
 	unsigned int index;
 	bool features_valid;
 	int nvqs;
+	struct vdpa_mgmt_dev *mdev;
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
index d44d82e567b1..bb4a1f00eb1c 100644
--- a/include/uapi/linux/vdpa.h
+++ b/include/uapi/linux/vdpa.h
@@ -14,6 +14,8 @@ enum vdpa_command {
 	VDPA_CMD_UNSPEC,
 	VDPA_CMD_MGMTDEV_NEW,
 	VDPA_CMD_MGMTDEV_GET,		/* can dump */
+	VDPA_CMD_DEV_NEW,
+	VDPA_CMD_DEV_DEL,
 };
=20
 enum vdpa_attr {
@@ -24,6 +26,8 @@ enum vdpa_attr {
 	VDPA_ATTR_MGMTDEV_DEV_NAME,		/* string */
 	VDPA_ATTR_MGMTDEV_SUPPORTED_CLASSES,	/* u64 */
=20
+	VDPA_ATTR_DEV_NAME,			/* string */
+
 	/* new attributes must be added above here */
 	VDPA_ATTR_MAX,
 };
--=20
2.26.2

