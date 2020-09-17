Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53BC926E231
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 19:21:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726515AbgIQRVU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 13:21:20 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:11034 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726419AbgIQRUh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 13:20:37 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f639a8a0000>; Thu, 17 Sep 2020 10:19:06 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Thu, 17 Sep 2020 10:20:35 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Thu, 17 Sep 2020 10:20:35 -0700
Received: from sw-mtx-036.mtx.labs.mlnx (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 17 Sep
 2020 17:20:34 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     Parav Pandit <parav@nvidia.com>, Jiri Pirko <jiri@nvidia.com>
Subject: [PATCH net-next v2 2/8] devlink: Support add and delete devlink port
Date:   Thu, 17 Sep 2020 20:20:14 +0300
Message-ID: <20200917172020.26484-3-parav@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200917172020.26484-1-parav@nvidia.com>
References: <20200917081731.8363-8-parav@nvidia.com>
 <20200917172020.26484-1-parav@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1600363146; bh=8+IeAygN8LQfvxyOMQi39R0WowkWFUAU/fgHn5VcrpU=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:
         Content-Type:X-Originating-IP:X-ClientProxiedBy;
        b=Vdal5s2vdz95y61RxMBOm/9pRhv0PrNS2xN5j9NLBppQ+f9DQkrCA4xd09AJvCjxW
         U6IzXmVUjoN58XAzZHWeU+5TtAy3ogCd5MBsFNtSqhLisuKGfmYoYFHGWWcBa0SihJ
         ogwIOy9fxYaNJKkEP1+ciCooBOIxizLQXylvohRVk6hW2AAqgsqyQlGx8KA9pSKjln
         Y3YOCXgpNwcm/mUdu1zmckJa9SJ8agbqoLYoEKeOCmeb73KGVaiZOg23yMNorfSAXE
         SwlSZ0ASei2KWw/V3sw6dq+pqCQncsdWao5Yv5aN/IHMiszzLLbYg0/mguu12/ymHt
         8w1bAXdLNAqyg==
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
This also helps to uniformly used the code for port registration
during driver unload and during port deletion initiated by user.

Examples of add, show and delete commands:
Create a device with ID=3D10 and one physical port.
$ echo "10 1" > /sys/bus/netdevsim/new_device

$ devlink port show netdevsim/netdevsim10/0
netdevsim/netdevsim10/0: type eth netdev eni10np1 flavour physical port 1 s=
plittable false

$ devlink port add netdevsim/netdevsim10 flavour pcipf pfnum 0

$ devlink port show netdevsim/netdevsim10/1
netdevsim/netdevsim10/1: type eth netdev eni10npf0 flavour pcipf controller=
 0 pfnum 0 external false splittable false
  function:
    hw_addr 00:00:00:00:00:00 state inactive

$ devlink port show netdevsim/netdevsim10/1 -jp
{
    "port": {
        "netdevsim/netdevsim10/1": {
            "type": "eth",
            "netdev": "eni10npf0",
            "flavour": "pcipf",
            "controller": 0,
            "pfnum": 0,
            "external": false,
            "splittable": false,
            "function": {
                "hw_addr": "00:00:00:00:00:00",
                "state": "inactive"
            }
        }
    }
}

$ devlink port del netdevsim/netdevsim10/1

Signed-off-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 include/net/devlink.h | 38 ++++++++++++++++++++++++
 net/core/devlink.c    | 67 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 105 insertions(+)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index 1edb558125b0..ebab2c0360d0 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -142,6 +142,17 @@ struct devlink_port {
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
@@ -1189,6 +1200,33 @@ struct devlink_ops {
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
index fada660fd515..e93730065c57 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -991,6 +991,57 @@ static int devlink_nl_cmd_port_unsplit_doit(struct sk_=
buff *skb,
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
@@ -7078,6 +7129,10 @@ static const struct nla_policy devlink_nl_policy[DEV=
LINK_ATTR_MAX + 1] =3D {
 	[DEVLINK_ATTR_TRAP_POLICER_RATE] =3D { .type =3D NLA_U64 },
 	[DEVLINK_ATTR_TRAP_POLICER_BURST] =3D { .type =3D NLA_U64 },
 	[DEVLINK_ATTR_PORT_FUNCTION] =3D { .type =3D NLA_NESTED },
+	[DEVLINK_ATTR_PORT_FLAVOUR] =3D { .type =3D NLA_U16 },
+	[DEVLINK_ATTR_PORT_PCI_PF_NUMBER] =3D { .type =3D NLA_U16 },
+	[DEVLINK_ATTR_PORT_PCI_SF_NUMBER] =3D { .type =3D NLA_U32 },
+	[DEVLINK_ATTR_PORT_CONTROLLER_NUMBER] =3D { .type =3D NLA_U32 },
 };
=20
 static const struct genl_ops devlink_nl_ops[] =3D {
@@ -7117,6 +7172,18 @@ static const struct genl_ops devlink_nl_ops[] =3D {
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

