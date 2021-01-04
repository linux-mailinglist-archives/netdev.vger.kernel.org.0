Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A11B22E8F98
	for <lists+netdev@lfdr.de>; Mon,  4 Jan 2021 04:35:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728027AbhADDdE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jan 2021 22:33:04 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:12072 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727938AbhADDdD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Jan 2021 22:33:03 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5ff28c470001>; Sun, 03 Jan 2021 19:32:23 -0800
Received: from sw-mtx-036.mtx.labs.mlnx (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 4 Jan
 2021 03:32:22 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     <virtualization@lists.linux-foundation.org>
CC:     <mst@redhat.com>, <jasowang@redhat.com>, <parav@nvidia.com>,
        <elic@nvidia.com>, <netdev@vger.kernel.org>
Subject: [PATCH linux-next v2 6/7] vdpa: Enable user to query vdpa device info
Date:   Mon, 4 Jan 2021 05:31:40 +0200
Message-ID: <20210104033141.105876-7-parav@nvidia.com>
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
        t=1609731143; bh=G4YN24ZRtil1Q2t+OZA4XXpih9LUlcThycNeO/nlfr8=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=k6sAdp/fJB/4miwj346R+n9QOu3x6usvwEMaY+ekUc5ffGEPsSkAX2ONAqFiaBplW
         h71ZsDorDWfLUmuJyDHVSerVo07/iwGyHnAcqDp6NBV/+71ud/x6HZMCFtM36JGce7
         J4dN7PCy5eSUpteUBp52EPazGDdfPojbdrK5XHKU7c8EFkAXKnVhKoEQe14tow0ti+
         AxLOlqBX4wvqNRq5cEaNtR2r1HE+EjTTMwW4j8UMqzG5TirQqGuAP144VYS5q+KQx8
         9S3SFeZ48i+I+Ou8uQ2ROiPUoIU+rFyOxy7k02aqJ0fO1YpkW78xE10sBBSWaO3nLJ
         P1WOMD9WUUehw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Enable user to query vdpa device information.

$ vdpa dev add mgmtdev vdpasim_net name foo2

Show the newly created vdpa device by its name:
$ vdpa dev show foo2
foo2: type network mgmtdev vdpasim_net vendor_id 0 max_vqs 2 max_vq_size 25=
6

$ vdpa dev show foo2 -jp
{
    "dev": {
        "foo2": {
            "type": "network",
            "mgmtdev": "vdpasim_net",
            "vendor_id": 0,
            "max_vqs": 2,
            "max_vq_size": 256
        }
    }
}

Signed-off-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Eli Cohen <elic@nvidia.com>
Reviewed-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vdpa/vdpa.c       | 131 ++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/vdpa.h |   5 ++
 2 files changed, 136 insertions(+)

diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
index dca67e4d32e5..9700a0adcca0 100644
--- a/drivers/vdpa/vdpa.c
+++ b/drivers/vdpa/vdpa.c
@@ -478,6 +478,131 @@ static int vdpa_nl_cmd_dev_del_set_doit(struct sk_buf=
f *skb, struct genl_info *i
 	return err;
 }
=20
+static int
+vdpa_dev_fill(struct vdpa_device *vdev, struct sk_buff *msg, u32 portid, u=
32 seq,
+	      int flags, struct netlink_ext_ack *extack)
+{
+	u16 max_vq_size;
+	u32 device_id;
+	u32 vendor_id;
+	void *hdr;
+	int err;
+
+	hdr =3D genlmsg_put(msg, portid, seq, &vdpa_nl_family, flags, VDPA_CMD_DE=
V_NEW);
+	if (!hdr)
+		return -EMSGSIZE;
+
+	err =3D vdpa_nl_mgmtdev_handle_fill(msg, vdev->mdev);
+	if (err)
+		goto msg_err;
+
+	device_id =3D vdev->config->get_device_id(vdev);
+	vendor_id =3D vdev->config->get_vendor_id(vdev);
+	max_vq_size =3D vdev->config->get_vq_num_max(vdev);
+
+	err =3D -EMSGSIZE;
+	if (nla_put_string(msg, VDPA_ATTR_DEV_NAME, dev_name(&vdev->dev)))
+		goto msg_err;
+	if (nla_put_u32(msg, VDPA_ATTR_DEV_ID, device_id))
+		goto msg_err;
+	if (nla_put_u32(msg, VDPA_ATTR_DEV_VENDOR_ID, vendor_id))
+		goto msg_err;
+	if (nla_put_u32(msg, VDPA_ATTR_DEV_MAX_VQS, vdev->nvqs))
+		goto msg_err;
+	if (nla_put_u16(msg, VDPA_ATTR_DEV_MAX_VQ_SIZE, max_vq_size))
+		goto msg_err;
+
+	genlmsg_end(msg, hdr);
+	return 0;
+
+msg_err:
+	genlmsg_cancel(msg, hdr);
+	return err;
+}
+
+static int vdpa_nl_cmd_dev_get_doit(struct sk_buff *skb, struct genl_info =
*info)
+{
+	struct vdpa_device *vdev;
+	struct sk_buff *msg;
+	const char *devname;
+	struct device *dev;
+	int err;
+
+	if (!info->attrs[VDPA_ATTR_DEV_NAME])
+		return -EINVAL;
+	devname =3D nla_data(info->attrs[VDPA_ATTR_DEV_NAME]);
+	msg =3D nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!msg)
+		return -ENOMEM;
+
+	mutex_lock(&vdpa_dev_mutex);
+	dev =3D bus_find_device(&vdpa_bus, NULL, devname, vdpa_name_match);
+	if (!dev) {
+		mutex_unlock(&vdpa_dev_mutex);
+		NL_SET_ERR_MSG_MOD(info->extack, "device not found");
+		return -ENODEV;
+	}
+	vdev =3D container_of(dev, struct vdpa_device, dev);
+	if (!vdev->mdev) {
+		mutex_unlock(&vdpa_dev_mutex);
+		put_device(dev);
+		return -EINVAL;
+	}
+	err =3D vdpa_dev_fill(vdev, msg, info->snd_portid, info->snd_seq, 0, info=
->extack);
+	if (!err)
+		err =3D genlmsg_reply(msg, info);
+	put_device(dev);
+	mutex_unlock(&vdpa_dev_mutex);
+
+	if (err)
+		nlmsg_free(msg);
+	return err;
+}
+
+struct vdpa_dev_dump_info {
+	struct sk_buff *msg;
+	struct netlink_callback *cb;
+	int start_idx;
+	int idx;
+};
+
+static int vdpa_dev_dump(struct device *dev, void *data)
+{
+	struct vdpa_device *vdev =3D container_of(dev, struct vdpa_device, dev);
+	struct vdpa_dev_dump_info *info =3D data;
+	int err;
+
+	if (!vdev->mdev)
+		return 0;
+	if (info->idx < info->start_idx) {
+		info->idx++;
+		return 0;
+	}
+	err =3D vdpa_dev_fill(vdev, info->msg, NETLINK_CB(info->cb->skb).portid,
+			    info->cb->nlh->nlmsg_seq, NLM_F_MULTI, info->cb->extack);
+	if (err)
+		return err;
+
+	info->idx++;
+	return 0;
+}
+
+static int vdpa_nl_cmd_dev_get_dumpit(struct sk_buff *msg, struct netlink_=
callback *cb)
+{
+	struct vdpa_dev_dump_info info;
+
+	info.msg =3D msg;
+	info.cb =3D cb;
+	info.start_idx =3D cb->args[0];
+	info.idx =3D 0;
+
+	mutex_lock(&vdpa_dev_mutex);
+	bus_for_each_dev(&vdpa_bus, NULL, &info, vdpa_dev_dump);
+	mutex_unlock(&vdpa_dev_mutex);
+	cb->args[0] =3D info.idx;
+	return msg->len;
+}
+
 static const struct nla_policy vdpa_nl_policy[VDPA_ATTR_MAX] =3D {
 	[VDPA_ATTR_MGMTDEV_BUS_NAME] =3D { .type =3D NLA_NUL_STRING },
 	[VDPA_ATTR_MGMTDEV_DEV_NAME] =3D { .type =3D NLA_STRING },
@@ -503,6 +628,12 @@ static const struct genl_ops vdpa_nl_ops[] =3D {
 		.doit =3D vdpa_nl_cmd_dev_del_set_doit,
 		.flags =3D GENL_ADMIN_PERM,
 	},
+	{
+		.cmd =3D VDPA_CMD_DEV_GET,
+		.validate =3D GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
+		.doit =3D vdpa_nl_cmd_dev_get_doit,
+		.dumpit =3D vdpa_nl_cmd_dev_get_dumpit,
+	},
 };
=20
 static struct genl_family vdpa_nl_family __ro_after_init =3D {
diff --git a/include/uapi/linux/vdpa.h b/include/uapi/linux/vdpa.h
index bb4a1f00eb1c..66a41e4ec163 100644
--- a/include/uapi/linux/vdpa.h
+++ b/include/uapi/linux/vdpa.h
@@ -16,6 +16,7 @@ enum vdpa_command {
 	VDPA_CMD_MGMTDEV_GET,		/* can dump */
 	VDPA_CMD_DEV_NEW,
 	VDPA_CMD_DEV_DEL,
+	VDPA_CMD_DEV_GET,		/* can dump */
 };
=20
 enum vdpa_attr {
@@ -27,6 +28,10 @@ enum vdpa_attr {
 	VDPA_ATTR_MGMTDEV_SUPPORTED_CLASSES,	/* u64 */
=20
 	VDPA_ATTR_DEV_NAME,			/* string */
+	VDPA_ATTR_DEV_ID,			/* u32 */
+	VDPA_ATTR_DEV_VENDOR_ID,		/* u32 */
+	VDPA_ATTR_DEV_MAX_VQS,			/* u32 */
+	VDPA_ATTR_DEV_MAX_VQ_SIZE,		/* u16 */
=20
 	/* new attributes must be added above here */
 	VDPA_ATTR_MAX,
--=20
2.26.2

