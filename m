Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0A0630AE7D
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 18:54:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232354AbhBARxQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 12:53:16 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:3842 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232201AbhBARxO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 12:53:14 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B60183fe00000>; Mon, 01 Feb 2021 09:52:32 -0800
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 1 Feb
 2021 17:52:32 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server id 15.0.1473.3 via Frontend
 Transport; Mon, 1 Feb 2021 17:52:28 +0000
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <parav@nvidia.com>, <saeedm@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>, Jiri Pirko <jiri@nvidia.com>
Subject: [PATCH net-next 1/2] devlink: Expose port function commands to control roce
Date:   Mon, 1 Feb 2021 19:51:51 +0200
Message-ID: <20210201175152.11280-2-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20210201175152.11280-1-yishaih@nvidia.com>
References: <20210201175152.11280-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612201952; bh=gg3TaLcuR/sAi8vd/PuSrvnJhmvr+bbNiXTMVKyboAU=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type;
        b=IWLxjrHTAVX1heTOIsVOQTRbAxtgpZXY1yw3PXAZtsbkpViCsyIV4qVbYKXQx3x/X
         KjSyVbqjPoA+5WdpKVTMTkajKNuELVHapTeE219Rt9vBkZ3CaaOGOG/vsFyvjY/k5p
         wnjouyBJaQTbbtApxAKWDuuBKvn+O2/DuVOzphuAF+4bOKvrLUkKK29MWzvoZAhU2X
         wNJ2WFV+hyD40rJiYSuiSkbRmNX6yaJJlT4ribQQQ5pKAGu2yUEMzXF7Ir5pnNzolD
         X35elGVV7bld6jY7iG4jx0zef+bA7qpn8zXKYoACOUCNbm7dqyNRuwjgTD4F4SsmJ3
         sQKdf/0+w2T1A==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Expose port function commands to turn on / off roce, this is used to
control the port roce device capabilities.

When roce is disabled for a function of the port, function cannot create
any roce specific resources (e.g GID table).
It also saves system memory utilization. For example disabling roce on a
VF/SF saves 1 Mbytes of system memory per function.

Example of a PCI VF port which supports function configuration:
Set roce of the VF's port function.

$ devlink port show pci/0000:06:00.0/2
pci/0000:06:00.0/2: type eth netdev enp6s0pf0vf1 flavour pcivf pfnum 0 vfnu=
m 1
    function:
        hw_addr 00:00:00:00:00:00 roce on

$ devlink port function set pci/0000:06:00.0/2 roce off

$ devlink port show pci/0000:06:00.0/2
pci/0000:06:00.0/2: type eth netdev enp6s0pf0vf1 flavour pcivf pfnum 0 vfnu=
m 1
    function:
        hw_addr 00:11:22:33:44:55 roce off

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
Reviewed-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../networking/devlink/devlink-port.rst       |  5 +-
 include/net/devlink.h                         | 22 +++++++
 include/uapi/linux/devlink.h                  |  1 +
 net/core/devlink.c                            | 63 +++++++++++++++++++
 4 files changed, 90 insertions(+), 1 deletion(-)

diff --git a/Documentation/networking/devlink/devlink-port.rst b/Documentat=
ion/networking/devlink/devlink-port.rst
index e99b41599465..541e19f9d256 100644
--- a/Documentation/networking/devlink/devlink-port.rst
+++ b/Documentation/networking/devlink/devlink-port.rst
@@ -110,7 +110,7 @@ devlink ports for both the controllers.
 Function configuration
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=20
-A user can configure the function attribute before enumerating the PCI
+A user can configure one or more function attributes before enumerating th=
e PCI
 function. Usually it means, user should configure function attribute
 before a bus specific device for the function is created. However, when
 SRIOV is enabled, virtual function devices are created on the PCI bus.
@@ -122,6 +122,9 @@ A user may set the hardware address of the function usi=
ng
 'devlink port function set hw_addr' command. For Ethernet port function
 this means a MAC address.
=20
+A user may set also the roce capability of the function using
+'devlink port function set roce' command.
+
 Subfunction
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=20
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 47b4b063401b..055280212b58 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1451,6 +1451,28 @@ struct devlink_ops {
 				 struct devlink_port *port,
 				 enum devlink_port_fn_state state,
 				 struct netlink_ext_ack *extack);
+	/**
+	 * @port_fn_roce_get: Port function's roce get function.
+	 *
+	 * Should be used by device drivers to report the roce state of
+	 * a function managed by the devlink port. Driver should return
+	 * -EOPNOTSUPP if it doesn't support port function handling for
+	 * a particular port.
+	 */
+	int (*port_fn_roce_get)(struct devlink *devlink,
+				struct devlink_port *port, bool *on,
+				struct netlink_ext_ack *extack);
+	/**
+	 * @port_fn_roce_set: Port function's roce set function.
+	 *
+	 * Should be used by device drivers to enable/disable the roce state of
+	 * a function managed by the devlink port. Driver should return
+	 * -EOPNOTSUPP if it doesn't support port function handling for
+	 * a particular port.
+	 */
+	int (*port_fn_roce_set)(struct devlink *devlink,
+				struct devlink_port *port, bool on,
+				struct netlink_ext_ack *extack);
 };
=20
 static inline void *devlink_priv(struct devlink *devlink)
diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index f6008b2fa60f..77990b563d80 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -585,6 +585,7 @@ enum devlink_port_function_attr {
 	DEVLINK_PORT_FUNCTION_ATTR_HW_ADDR,	/* binary */
 	DEVLINK_PORT_FN_ATTR_STATE,	/* u8 */
 	DEVLINK_PORT_FN_ATTR_OPSTATE,	/* u8 */
+	DEVLINK_PORT_FN_ATTR_ROCE,	/* u8 */
=20
 	__DEVLINK_PORT_FUNCTION_ATTR_MAX,
 	DEVLINK_PORT_FUNCTION_ATTR_MAX =3D __DEVLINK_PORT_FUNCTION_ATTR_MAX - 1
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 737b61c2976e..d04318e79dc2 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -90,6 +90,7 @@ static const struct nla_policy devlink_function_nl_policy=
[DEVLINK_PORT_FUNCTION_
 	[DEVLINK_PORT_FN_ATTR_STATE] =3D
 		NLA_POLICY_RANGE(NLA_U8, DEVLINK_PORT_FN_STATE_INACTIVE,
 				 DEVLINK_PORT_FN_STATE_ACTIVE),
+	[DEVLINK_PORT_FN_ATTR_ROCE] =3D NLA_POLICY_RANGE(NLA_U8, 0, 1),
 };
=20
 static LIST_HEAD(devlink_list);
@@ -724,6 +725,34 @@ static int devlink_nl_port_attrs_put(struct sk_buff *m=
sg,
 	return 0;
 }
=20
+static int devlink_port_function_roce_fill(struct devlink *devlink,
+					   const struct devlink_ops *ops,
+					   struct devlink_port *port,
+					   struct sk_buff *msg,
+					   struct netlink_ext_ack *extack,
+					   bool *msg_updated)
+{
+	bool on;
+	int err;
+
+	if (!ops->port_fn_roce_get)
+		return 0;
+
+	err =3D ops->port_fn_roce_get(devlink, port, &on, extack);
+	if (err) {
+		if (err =3D=3D -EOPNOTSUPP)
+			return 0;
+		return err;
+	}
+
+	err =3D nla_put_u8(msg, DEVLINK_PORT_FN_ATTR_ROCE, on);
+	if (err)
+		return err;
+
+	*msg_updated =3D true;
+	return 0;
+}
+
 static int
 devlink_port_fn_hw_addr_fill(struct devlink *devlink, const struct devlink=
_ops *ops,
 			     struct devlink_port *port, struct sk_buff *msg,
@@ -820,6 +849,12 @@ devlink_nl_port_function_attrs_put(struct sk_buff *msg=
, struct devlink_port *por
 					   extack, &msg_updated);
 	if (err)
 		goto out;
+
+	err =3D devlink_port_function_roce_fill(devlink, ops, port, msg, extack,
+					      &msg_updated);
+	if (err)
+		goto out;
+
 	err =3D devlink_port_fn_state_fill(devlink, ops, port, msg, extack,
 					 &msg_updated);
 out:
@@ -1054,6 +1089,26 @@ static int devlink_port_type_set(struct devlink *dev=
link,
 	return -EOPNOTSUPP;
 }
=20
+static int
+devlink_port_fn_roce_set(struct devlink *devlink, struct devlink_port *por=
t,
+			 const struct nlattr *attr,
+			 struct netlink_ext_ack *extack)
+{
+	const struct devlink_ops *ops;
+	bool on;
+
+	on =3D nla_get_u8(attr);
+
+	ops =3D devlink->ops;
+	if (!ops->port_fn_roce_set) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Port doesn't support roce function attribute");
+		return -EOPNOTSUPP;
+	}
+
+	return ops->port_fn_roce_set(devlink, port, on, extack);
+}
+
 static int
 devlink_port_function_hw_addr_set(struct devlink *devlink, struct devlink_=
port *port,
 				  const struct nlattr *attr, struct netlink_ext_ack *extack)
@@ -1126,6 +1181,14 @@ devlink_port_function_set(struct devlink *devlink, s=
truct devlink_port *port,
 		if (err)
 			return err;
 	}
+
+	attr =3D tb[DEVLINK_PORT_FN_ATTR_ROCE];
+	if (attr) {
+		err =3D devlink_port_fn_roce_set(devlink, port, attr, extack);
+		if (err)
+			return err;
+	}
+
 	/* Keep this as the last function attribute set, so that when
 	 * multiple port function attributes are set along with state,
 	 * Those can be applied first before activating the state.
--=20
2.18.1

