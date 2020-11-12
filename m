Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE4DD2B0DDF
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 20:25:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726878AbgKLTY4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 14:24:56 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:11879 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726648AbgKLTYw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 14:24:52 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fad8bfe0001>; Thu, 12 Nov 2020 11:24:46 -0800
Received: from sw-mtx-036.mtx.labs.mlnx (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 12 Nov
 2020 19:24:50 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <gregkh@linuxfoundation.org>
CC:     <jiri@nvidia.com>, <jgg@nvidia.com>, <dledford@redhat.com>,
        <leonro@nvidia.com>, <saeedm@nvidia.com>, <kuba@kernel.org>,
        <davem@davemloft.net>, Parav Pandit <parav@nvidia.com>,
        Vu Pham <vuhuong@nvidia.com>
Subject: [PATCH net-next 04/13] devlink: Support get and set state of port function
Date:   Thu, 12 Nov 2020 21:24:14 +0200
Message-ID: <20201112192424.2742-5-parav@nvidia.com>
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
        t=1605209086; bh=LGS78c0/HYZgm/YQsSGw/xFezP/poNpCmeTJPZRY3NY=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=LlYO5K1qqX8qJP9HoZMeoWno7JcJoR+ezBkNg/xbBUlItDBJsBMMJBgfg/CbL4IYO
         B8F4w1+g3nWki6dLiDO0GO6ISv3Vs9VE48LHOmh7kGbQgq93UmOto+90GHnixi/Hhh
         bYBuo22VbJb94xYJ9xN8/S3VdYkRqqMr7OMGcVjP2ryJq89Vm/EXf6e+SR6k2Ekkb8
         UX76KyPXt4s0KgyZCCjee6iUJ+a1KhsGImIHn9jH7hRIJWaIW9mSHe27wkcI2O+dEX
         oFT5CAKyRkkjn+xCZ2shBrwyFXs7YFcB91xezaWkxYG7VcCi/SnF1eGixskvLa3JIC
         MfmnbgQNbGSLw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

devlink port function can be in active or inactive state.
Allow users to get and set port function's state.

When the port function it activated, its operational state may change
after a while when the device is created and driver binds to it.
Similarly on deactivation flow.

To clearly describe the state of the port function and its device's
operational state in the host system, define state and opstate
attributes.

Example of a PCI SF port which supports a port function:
Create a device with ID=3D10 and one physical port.

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

$ devlink port function set pci/0000:06:00.0/32768 hw_addr 00:00:00:00:88:8=
8 state active

$ devlink port show pci/0000:06:00.0/32768 -jp
{
    "port": {
        "pci/0000:06:00.0/32768": {
            "type": "eth",
            "netdev": "eth0",
            "flavour": "pcisf",
            "controller": 0,
            "pfnum": 0,
            "sfnum": 88,
            "external": false,
            "splittable": false,
            "function": {
                "hw_addr": "00:00:00:00:88:88",
                "state": "active",
                "opstate": "attached"
            }
        }
    }
}

Signed-off-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Vu Pham <vuhuong@nvidia.com>
---
 include/net/devlink.h        | 21 +++++++++
 include/uapi/linux/devlink.h | 21 +++++++++
 net/core/devlink.c           | 89 +++++++++++++++++++++++++++++++++++-
 3 files changed, 130 insertions(+), 1 deletion(-)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index 3991345ef3e2..124bac130c22 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1371,6 +1371,27 @@ struct devlink_ops {
 	int (*port_function_hw_addr_set)(struct devlink *devlink, struct devlink_=
port *port,
 					 const u8 *hw_addr, int hw_addr_len,
 					 struct netlink_ext_ack *extack);
+	/**
+	 * @port_function_state_get: Port function's state get function.
+	 *
+	 * Should be used by device drivers to report the state of a function man=
aged
+	 * by the devlink port. Driver should return -EOPNOTSUPP if it doesn't su=
pport port
+	 * function handling for a particular port.
+	 */
+	int (*port_function_state_get)(struct devlink *devlink, struct devlink_po=
rt *port,
+				       enum devlink_port_function_state *state,
+				       enum devlink_port_function_opstate *opstate,
+				       struct netlink_ext_ack *extack);
+	/**
+	 * @port_function_state_set: Port function's state set function.
+	 *
+	 * Should be used by device drivers to set the state of a function manage=
d
+	 * by the devlink port. Driver should return -EOPNOTSUPP if it doesn't su=
pport port
+	 * function handling for a particular port.
+	 */
+	int (*port_function_state_set)(struct devlink *devlink, struct devlink_po=
rt *port,
+				       enum devlink_port_function_state state,
+				       struct netlink_ext_ack *extack);
 	/**
 	 * @port_new: Port add function.
 	 *
diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index 57065722b9c3..0c6eb3add736 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -581,9 +581,30 @@ enum devlink_resource_unit {
 enum devlink_port_function_attr {
 	DEVLINK_PORT_FUNCTION_ATTR_UNSPEC,
 	DEVLINK_PORT_FUNCTION_ATTR_HW_ADDR,	/* binary */
+	DEVLINK_PORT_FUNCTION_ATTR_STATE,	/* u8 */
+	DEVLINK_PORT_FUNCTION_ATTR_OPSTATE,	/* u8 */
=20
 	__DEVLINK_PORT_FUNCTION_ATTR_MAX,
 	DEVLINK_PORT_FUNCTION_ATTR_MAX =3D __DEVLINK_PORT_FUNCTION_ATTR_MAX - 1
 };
=20
+enum devlink_port_function_state {
+	DEVLINK_PORT_FUNCTION_STATE_INACTIVE,
+	DEVLINK_PORT_FUNCTION_STATE_ACTIVE,
+};
+
+/**
+ * enum devlink_port_function_opstate - indicates operational state of por=
t function
+ * @DEVLINK_PORT_FUNCTION_OPSTATE_ATTACHED: Driver is attached to the func=
tion of port, for
+ *					    gracefufl tear down of the function, after
+ *					    inactivation of the port function, user should wait
+ *					    for operational state to turn DETACHED.
+ * @DEVLINK_PORT_FUNCTION_OPSTATE_DETACHED: Driver is detached from the fu=
nction of port; it is
+ *					    safe to delete the port.
+ */
+enum devlink_port_function_opstate {
+	DEVLINK_PORT_FUNCTION_OPSTATE_DETACHED,
+	DEVLINK_PORT_FUNCTION_OPSTATE_ATTACHED,
+};
+
 #endif /* _UAPI_LINUX_DEVLINK_H_ */
diff --git a/net/core/devlink.c b/net/core/devlink.c
index dccdf36afba6..3e59ba73d5c4 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -87,6 +87,9 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(devlink_trap_report);
=20
 static const struct nla_policy devlink_function_nl_policy[DEVLINK_PORT_FUN=
CTION_ATTR_MAX + 1] =3D {
 	[DEVLINK_PORT_FUNCTION_ATTR_HW_ADDR] =3D { .type =3D NLA_BINARY },
+	[DEVLINK_PORT_FUNCTION_ATTR_STATE] =3D
+		NLA_POLICY_RANGE(NLA_U8, DEVLINK_PORT_FUNCTION_STATE_INACTIVE,
+				 DEVLINK_PORT_FUNCTION_STATE_ACTIVE),
 };
=20
 static LIST_HEAD(devlink_list);
@@ -729,6 +732,52 @@ devlink_port_function_hw_addr_fill(struct devlink *dev=
link, const struct devlink
 	return 0;
 }
=20
+static bool devlink_port_function_state_valid(enum devlink_port_function_s=
tate state)
+{
+	return state =3D=3D DEVLINK_PORT_FUNCTION_STATE_INACTIVE ||
+	       state =3D=3D DEVLINK_PORT_FUNCTION_STATE_ACTIVE;
+}
+
+static bool devlink_port_function_opstate_valid(enum devlink_port_function=
_opstate state)
+{
+	return state =3D=3D DEVLINK_PORT_FUNCTION_OPSTATE_DETACHED ||
+	       state =3D=3D DEVLINK_PORT_FUNCTION_OPSTATE_ATTACHED;
+}
+
+static int devlink_port_function_state_fill(struct devlink *devlink, const=
 struct devlink_ops *ops,
+					    struct devlink_port *port, struct sk_buff *msg,
+					    struct netlink_ext_ack *extack, bool *msg_updated)
+{
+	enum devlink_port_function_opstate opstate;
+	enum devlink_port_function_state state;
+	int err;
+
+	if (!ops->port_function_state_get)
+		return 0;
+
+	err =3D ops->port_function_state_get(devlink, port, &state, &opstate, ext=
ack);
+	if (err) {
+		if (err =3D=3D -EOPNOTSUPP)
+			return 0;
+		return err;
+	}
+	if (!devlink_port_function_state_valid(state)) {
+		WARN_ON_ONCE(1);
+		NL_SET_ERR_MSG_MOD(extack, "Invalid state value read from driver");
+		return -EINVAL;
+	}
+	if (!devlink_port_function_opstate_valid(opstate)) {
+		WARN_ON_ONCE(1);
+		NL_SET_ERR_MSG_MOD(extack, "Invalid operational state value read from dr=
iver");
+		return -EINVAL;
+	}
+	if (nla_put_u8(msg, DEVLINK_PORT_FUNCTION_ATTR_STATE, state) ||
+	    nla_put_u8(msg, DEVLINK_PORT_FUNCTION_ATTR_OPSTATE, opstate))
+		return -EMSGSIZE;
+	*msg_updated =3D true;
+	return 0;
+}
+
 static int
 devlink_nl_port_function_attrs_put(struct sk_buff *msg, struct devlink_por=
t *port,
 				   struct netlink_ext_ack *extack)
@@ -745,6 +794,12 @@ devlink_nl_port_function_attrs_put(struct sk_buff *msg=
, struct devlink_port *por
=20
 	ops =3D devlink->ops;
 	err =3D devlink_port_function_hw_addr_fill(devlink, ops, port, msg, extac=
k, &msg_updated);
+	if (err)
+		goto out;
+	err =3D devlink_port_function_state_fill(devlink, ops, port, msg, extack,=
 &msg_updated);
+	if (err)
+		goto out;
+out:
 	if (err || !msg_updated)
 		nla_nest_cancel(msg, function_attr);
 	else
@@ -1005,6 +1060,28 @@ devlink_port_function_hw_addr_set(struct devlink *de=
vlink, struct devlink_port *
 	return ops->port_function_hw_addr_set(devlink, port, hw_addr, hw_addr_len=
, extack);
 }
=20
+static int
+devlink_port_function_state_set(struct devlink *devlink, struct devlink_po=
rt *port,
+				const struct nlattr *attr, struct netlink_ext_ack *extack)
+{
+	enum devlink_port_function_state state;
+	const struct devlink_ops *ops;
+	int err;
+
+	state =3D nla_get_u8(attr);
+	ops =3D devlink->ops;
+	if (!ops->port_function_state_set) {
+		NL_SET_ERR_MSG_MOD(extack, "Port function does not support state setting=
");
+		return -EOPNOTSUPP;
+	}
+	err =3D ops->port_function_state_set(devlink, port, state, extack);
+	if (err)
+		return err;
+
+	devlink_port_notify(port, DEVLINK_CMD_PORT_NEW);
+	return 0;
+}
+
 static int
 devlink_port_function_set(struct devlink *devlink, struct devlink_port *po=
rt,
 			  const struct nlattr *attr, struct netlink_ext_ack *extack)
@@ -1020,8 +1097,18 @@ devlink_port_function_set(struct devlink *devlink, s=
truct devlink_port *port,
 	}
=20
 	attr =3D tb[DEVLINK_PORT_FUNCTION_ATTR_HW_ADDR];
-	if (attr)
+	if (attr) {
 		err =3D devlink_port_function_hw_addr_set(devlink, port, attr, extack);
+		if (err)
+			return err;
+	}
+	/* Keep this as the last function attribute set, so that when
+	 * multiple port function attributes are set along with state,
+	 * Those can be applied first before activating the state.
+	 */
+	attr =3D tb[DEVLINK_PORT_FUNCTION_ATTR_STATE];
+	if (attr)
+		err =3D devlink_port_function_state_set(devlink, port, attr, extack);
=20
 	if (!err)
 		devlink_port_notify(port, DEVLINK_CMD_PORT_NEW);
--=20
2.26.2

