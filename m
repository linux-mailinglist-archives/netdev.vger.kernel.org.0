Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 609DF2B0DDE
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 20:25:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726854AbgKLTYx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 14:24:53 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:14152 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726826AbgKLTYv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 14:24:51 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fad8c060000>; Thu, 12 Nov 2020 11:24:54 -0800
Received: from sw-mtx-036.mtx.labs.mlnx (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 12 Nov
 2020 19:24:49 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <gregkh@linuxfoundation.org>
CC:     <jiri@nvidia.com>, <jgg@nvidia.com>, <dledford@redhat.com>,
        <leonro@nvidia.com>, <saeedm@nvidia.com>, <kuba@kernel.org>,
        <davem@davemloft.net>, Parav Pandit <parav@nvidia.com>,
        Vu Pham <vuhuong@nvidia.com>
Subject: [PATCH net-next 03/13] devlink: Support add and delete devlink port
Date:   Thu, 12 Nov 2020 21:24:13 +0200
Message-ID: <20201112192424.2742-4-parav@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201112192424.2742-1-parav@nvidia.com>
References: <20201112192424.2742-1-parav@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1605209095; bh=D4JZp5kVleCr5eF3o9evBl+V3rS5np4bBhWU/57b7mE=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=CxacRKt6bmjC54t3dJiI0b32E03UQgrzDHATkPkA2VQ7xLMceUMnIm5pSzqehX0GD
         N96SLyDteYGRpUO08CjYxjPwQyqYBiJoiZFGxH+77avsOzAWKrknxsjhGnxvvHqa2J
         Zu36loAk8+nGYFgXR7NY7RDNJrDlup4or4vC8TTF0qypdDl6mFadJxakEP1WQrP+AJ
         ADQSvnHiYwUg8vy1zh43otVgceT7spQ06czFDudRMv862Gn//uLc0AnrM8whs6Ja+R
         TADxaPZAJ8LjEFDrMLbTmlmCo/JnAKb1AMcP7TnebTL6DBd0vwj54GuFgULM0qOq6X
         TfDkMpVH0JA1Q==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extended devlink interface for the user to add and delete port.
Extend devlink to connect user requests to driver to add/delete
such port in the device.

When driver routines are invoked, devlink instance lock is not held.
This enables driver to perform several devlink objects registration,
unregistration such as (port, health reporter, resource etc)
by using exising devlink APIs.
This also helps to uniformly use the code for port unregistration
during driver unload and during port deletion initiated by user.

Examples of add, show and delete commands:
$ devlink dev eswitch set pci/0000:06:00.0 mode switchdev

$ devlink port show
pci/0000:06:00.0/65535: type eth netdev ens2f0np0 flavour physical port 0 s=
plittable false

$ devlink port add pci/0000:06:00.0 flavour pcisf pfnum 0 sfnum 88

$ devlink port show pci/0000:06:00.0/32768
pci/0000:06:00.0/32768: type eth netdev eth0 flavour pcisf controller 0 pfn=
um 0 sfnum 88 external false splittable false
  function:
    hw_addr 00:00:00:00:88:88 state inactive opstate detached

$ udevadm test-builtin net_id /sys/class/net/eth0
Load module index
Parsed configuration file /usr/lib/systemd/network/99-default.link
Created link configuration context.
Using default interface naming scheme 'v245'.
ID_NET_NAMING_SCHEME=3Dv245
ID_NET_NAME_PATH=3Denp6s0f0npf0sf88
ID_NET_NAME_SLOT=3Dens2f0npf0sf88
Unload module index
Unloaded link configuration context.

$ devlink port del netdevsim/netdevsim10/32768

Signed-off-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Vu Pham <vuhuong@nvidia.com>
---
 include/net/devlink.h | 38 ++++++++++++++++++++++++
 net/core/devlink.c    | 67 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 105 insertions(+)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index 1b7c9fbc607a..3991345ef3e2 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -152,6 +152,17 @@ struct devlink_port {
 	struct mutex reporters_lock; /* Protects reporter_list */
 };
=20
+struct devlink_port_new_attrs {
+	enum devlink_port_flavour flavour;
+	unsigned int port_index;
+	u32 controller;
+	u32 sfnum;
+	u16 pfnum;
+	u8 port_index_valid:1,
+	   controller_valid:1,
+	   sfnum_valid:1;
+};
+
 struct devlink_sb_pool_info {
 	enum devlink_sb_pool_type pool_type;
 	u32 size;
@@ -1360,6 +1371,33 @@ struct devlink_ops {
 	int (*port_function_hw_addr_set)(struct devlink *devlink, struct devlink_=
port *port,
 					 const u8 *hw_addr, int hw_addr_len,
 					 struct netlink_ext_ack *extack);
+	/**
+	 * @port_new: Port add function.
+	 *
+	 * Should be used by device driver to let caller add new port of a specif=
ied flavour
+	 * with optional attributes.
+	 * Driver should return -EOPNOTSUPP if it doesn't support port addition o=
f a specified
+	 * flavour or specified attributes. Driver should set extack error messag=
e in case of fail
+	 * to add the port.
+	 * devlink core does not hold a devlink instance lock when this callback =
is invoked.
+	 * Driver must ensures synchronization when adding or deleting a port. Dr=
iver must
+	 * register a port with devlink core.
+	 */
+	int (*port_new)(struct devlink *devlink, const struct devlink_port_new_at=
trs *attrs,
+			struct netlink_ext_ack *extack);
+	/**
+	 * @port_del: Port delete function.
+	 *
+	 * Should be used by device driver to let caller delete port which was pr=
eviously created
+	 * using port_new() callback.
+	 * Driver should return -EOPNOTSUPP if it doesn't support port deletion.
+	 * Driver should set extack error message in case of fail to delete the p=
ort.
+	 * devlink core does not hold a devlink instance lock when this callback =
is invoked.
+	 * Driver must ensures synchronization when adding or deleting a port. Dr=
iver must
+	 * register a port with devlink core.
+	 */
+	int (*port_del)(struct devlink *devlink, unsigned int port_index,
+			struct netlink_ext_ack *extack);
 };
=20
 static inline void *devlink_priv(struct devlink *devlink)
diff --git a/net/core/devlink.c b/net/core/devlink.c
index b1e849b624a6..dccdf36afba6 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -1124,6 +1124,57 @@ static int devlink_nl_cmd_port_unsplit_doit(struct s=
k_buff *skb,
 	return devlink_port_unsplit(devlink, port_index, info->extack);
 }
=20
+static int devlink_nl_cmd_port_new_doit(struct sk_buff *skb, struct genl_i=
nfo *info)
+{
+	struct netlink_ext_ack *extack =3D info->extack;
+	struct devlink_port_new_attrs new_attrs =3D {};
+	struct devlink *devlink =3D info->user_ptr[0];
+
+	if (!info->attrs[DEVLINK_ATTR_PORT_FLAVOUR] ||
+	    !info->attrs[DEVLINK_ATTR_PORT_PCI_PF_NUMBER]) {
+		NL_SET_ERR_MSG_MOD(extack, "Port flavour or PCI PF are not specified");
+		return -EINVAL;
+	}
+	new_attrs.flavour =3D nla_get_u16(info->attrs[DEVLINK_ATTR_PORT_FLAVOUR])=
;
+	new_attrs.pfnum =3D nla_get_u16(info->attrs[DEVLINK_ATTR_PORT_PCI_PF_NUMB=
ER]);
+
+	if (info->attrs[DEVLINK_ATTR_PORT_INDEX]) {
+		new_attrs.port_index =3D nla_get_u32(info->attrs[DEVLINK_ATTR_PORT_INDEX=
]);
+		new_attrs.port_index_valid =3D true;
+	}
+	if (info->attrs[DEVLINK_ATTR_PORT_CONTROLLER_NUMBER]) {
+		new_attrs.controller =3D
+			nla_get_u16(info->attrs[DEVLINK_ATTR_PORT_CONTROLLER_NUMBER]);
+		new_attrs.controller_valid =3D true;
+	}
+	if (info->attrs[DEVLINK_ATTR_PORT_PCI_SF_NUMBER]) {
+		new_attrs.sfnum =3D nla_get_u32(info->attrs[DEVLINK_ATTR_PORT_PCI_SF_NUM=
BER]);
+		new_attrs.sfnum_valid =3D true;
+	}
+
+	if (!devlink->ops->port_new)
+		return -EOPNOTSUPP;
+
+	return devlink->ops->port_new(devlink, &new_attrs, extack);
+}
+
+static int devlink_nl_cmd_port_del_doit(struct sk_buff *skb, struct genl_i=
nfo *info)
+{
+	struct netlink_ext_ack *extack =3D info->extack;
+	struct devlink *devlink =3D info->user_ptr[0];
+	unsigned int port_index;
+
+	if (!info->attrs[DEVLINK_ATTR_PORT_INDEX]) {
+		NL_SET_ERR_MSG_MOD(extack, "Port index is not specified");
+		return -EINVAL;
+	}
+	port_index =3D nla_get_u32(info->attrs[DEVLINK_ATTR_PORT_INDEX]);
+
+	if (!devlink->ops->port_del)
+		return -EOPNOTSUPP;
+	return devlink->ops->port_del(devlink, port_index, extack);
+}
+
 static int devlink_nl_sb_fill(struct sk_buff *msg, struct devlink *devlink=
,
 			      struct devlink_sb *devlink_sb,
 			      enum devlink_command cmd, u32 portid,
@@ -7565,6 +7616,10 @@ static const struct nla_policy devlink_nl_policy[DEV=
LINK_ATTR_MAX + 1] =3D {
 	[DEVLINK_ATTR_RELOAD_ACTION] =3D NLA_POLICY_RANGE(NLA_U8, DEVLINK_RELOAD_=
ACTION_DRIVER_REINIT,
 							DEVLINK_RELOAD_ACTION_MAX),
 	[DEVLINK_ATTR_RELOAD_LIMITS] =3D NLA_POLICY_BITFIELD32(DEVLINK_RELOAD_LIM=
ITS_VALID_MASK),
+	[DEVLINK_ATTR_PORT_FLAVOUR] =3D { .type =3D NLA_U16 },
+	[DEVLINK_ATTR_PORT_PCI_PF_NUMBER] =3D { .type =3D NLA_U16 },
+	[DEVLINK_ATTR_PORT_PCI_SF_NUMBER] =3D { .type =3D NLA_U32 },
+	[DEVLINK_ATTR_PORT_CONTROLLER_NUMBER] =3D { .type =3D NLA_U32 },
 };
=20
 static const struct genl_small_ops devlink_nl_ops[] =3D {
@@ -7604,6 +7659,18 @@ static const struct genl_small_ops devlink_nl_ops[] =
=3D {
 		.flags =3D GENL_ADMIN_PERM,
 		.internal_flags =3D DEVLINK_NL_FLAG_NO_LOCK,
 	},
+	{
+		.cmd =3D DEVLINK_CMD_PORT_NEW,
+		.doit =3D devlink_nl_cmd_port_new_doit,
+		.flags =3D GENL_ADMIN_PERM,
+		.internal_flags =3D DEVLINK_NL_FLAG_NO_LOCK,
+	},
+	{
+		.cmd =3D DEVLINK_CMD_PORT_DEL,
+		.doit =3D devlink_nl_cmd_port_del_doit,
+		.flags =3D GENL_ADMIN_PERM,
+		.internal_flags =3D DEVLINK_NL_FLAG_NO_LOCK,
+	},
 	{
 		.cmd =3D DEVLINK_CMD_SB_GET,
 		.validate =3D GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
--=20
2.26.2

