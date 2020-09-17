Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5EF726E24B
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 19:25:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726401AbgIQRZU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 13:25:20 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:4959 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726434AbgIQRUp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 13:20:45 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f639ab80002>; Thu, 17 Sep 2020 10:19:52 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Thu, 17 Sep 2020 10:20:36 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Thu, 17 Sep 2020 10:20:36 -0700
Received: from sw-mtx-036.mtx.labs.mlnx (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 17 Sep
 2020 17:20:35 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     Parav Pandit <parav@nvidia.com>, Jiri Pirko <jiri@nvidia.com>
Subject: [PATCH net-next v2 4/8] devlink: Support get and set state of port function
Date:   Thu, 17 Sep 2020 20:20:16 +0300
Message-ID: <20200917172020.26484-5-parav@nvidia.com>
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
        t=1600363193; bh=0VV+T343EvRTzRSQ1+DMysLKVM10VNxPneonOi0VSKA=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:
         Content-Type:X-Originating-IP:X-ClientProxiedBy;
        b=dpt1azqr1dEwBXgRFh8VA7tzRR1H3OF4iQvSQFlcqK+48W/UvCzXU0mIjymrpmUYz
         lH0daVoGZOccUGGtc8auP1apCbJ8uJs3NeKUTeUO3z6oxtCWF3wc1DsYJrrD2iCEie
         p4jcpx92yQsEDaWe9aYmhLtqBIiQyRvDuZ9eyDEKoUCzq8hxGjuv7QHgnGwwTGDzaN
         sjM1uqN+NfhfRvvaAjuRQjgyxbV2zJGHOMq4S1Dyfmbk3uCLEUnHquFKM1BcSlvaXT
         BhSCasirq2A729g2P/+iMAMDFGnkqnbtqDB0+G6YKie3jc1Bpvf7mS7gw8ny6Yvsqv
         oOYEIL9Zx5A5g==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

devlink port function can be in active or inactive state.
Allow users to get and set port function's state.

Example of a PCI SF port which supports a port function:
Create a device with ID=3D10 and one physical port.
$ echo "10 1" > /sys/bus/netdevsim/new_device
$ devlink port show
netdevsim/netdevsim10/0: type eth netdev eth0 flavour physical port 1 split=
table false

$ devlink port add netdevsim/netdevsim10/10 flavour pcipf pfnum 0
$ devlink port add netdevsim/netdevsim10/11 flavour pcisf pfnum 0 sfnum 44
$ devlink port show netdevsim/netdevsim10/11
netdevsim/netdevsim10/11: type eth netdev eni10npf0sf44 flavour pcisf contr=
oller 0 pfnum 0 sfnum 44 external false splittable false
  function:
    hw_addr 00:00:00:00:00:00 state inactive

$ devlink port function set netdevsim/netdevsim10/11 hw_addr 00:11:22:33:44=
:55 state active

$ devlink port show netdevsim/netdevsim10/11 -jp
{
    "port": {
        "netdevsim/netdevsim10/11": {
            "type": "eth",
            "netdev": "eni10npf0sf44",
            "flavour": "pcisf",
            "controller": 0,
            "pfnum": 0,
            "sfnum": 44,
            "external": false,
            "splittable": false,
            "function": {
                "hw_addr": "00:11:22:33:44:55",
                "state": "active"
            }
        }
    }
}

Signed-off-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 include/net/devlink.h        | 20 ++++++++++
 include/uapi/linux/devlink.h |  6 +++
 net/core/devlink.c           | 77 +++++++++++++++++++++++++++++++++++-
 3 files changed, 101 insertions(+), 2 deletions(-)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index ebab2c0360d0..500c22835686 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1200,6 +1200,26 @@ struct devlink_ops {
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
index 09c41b9ce407..8e513f1cd638 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -518,9 +518,15 @@ enum devlink_resource_unit {
 enum devlink_port_function_attr {
 	DEVLINK_PORT_FUNCTION_ATTR_UNSPEC,
 	DEVLINK_PORT_FUNCTION_ATTR_HW_ADDR,	/* binary */
+	DEVLINK_PORT_FUNCTION_ATTR_STATE,	/* u8 */
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
 #endif /* _UAPI_LINUX_DEVLINK_H_ */
diff --git a/net/core/devlink.c b/net/core/devlink.c
index d152489e48da..c82098cb75da 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -87,6 +87,9 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(devlink_hwerr);
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
@@ -595,6 +598,40 @@ devlink_port_function_hw_addr_fill(struct devlink *dev=
link, const struct devlink
 	return 0;
 }
=20
+static bool devlink_port_function_state_valid(u8 state)
+{
+	return state =3D=3D DEVLINK_PORT_FUNCTION_STATE_INACTIVE ||
+	       state =3D=3D DEVLINK_PORT_FUNCTION_STATE_ACTIVE;
+}
+
+static int devlink_port_function_state_fill(struct devlink *devlink, const=
 struct devlink_ops *ops,
+					    struct devlink_port *port, struct sk_buff *msg,
+					    struct netlink_ext_ack *extack, bool *msg_updated)
+{
+	enum devlink_port_function_state state;
+	int err;
+
+	if (!ops->port_function_state_get)
+		return 0;
+
+	err =3D ops->port_function_state_get(devlink, port, &state, extack);
+	if (err) {
+		if (err =3D=3D -EOPNOTSUPP)
+			return 0;
+		return err;
+	}
+	if (!devlink_port_function_state_valid(state)) {
+		WARN_ON(1);
+		NL_SET_ERR_MSG_MOD(extack, "Invalid state value read from driver");
+		return -EINVAL;
+	}
+	err =3D nla_put_u8(msg, DEVLINK_PORT_FUNCTION_ATTR_STATE, state);
+	if (err)
+		return err;
+	*msg_updated =3D true;
+	return 0;
+}
+
 static int
 devlink_nl_port_function_attrs_put(struct sk_buff *msg, struct devlink_por=
t *port,
 				   struct netlink_ext_ack *extack)
@@ -611,6 +648,11 @@ devlink_nl_port_function_attrs_put(struct sk_buff *msg=
, struct devlink_port *por
=20
 	ops =3D devlink->ops;
 	err =3D devlink_port_function_hw_addr_fill(devlink, ops, port, msg, extac=
k, &msg_updated);
+	if (err)
+		goto out;
+	err =3D devlink_port_function_state_fill(devlink, ops, port, msg, extack,=
 &msg_updated);
+
+out:
 	if (err || !msg_updated)
 		nla_nest_cancel(msg, function_attr);
 	else
@@ -879,6 +921,28 @@ devlink_port_function_hw_addr_set(struct devlink *devl=
ink, struct devlink_port *
 	return 0;
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
@@ -894,9 +958,18 @@ devlink_port_function_set(struct devlink *devlink, str=
uct devlink_port *port,
 	}
=20
 	attr =3D tb[DEVLINK_PORT_FUNCTION_ATTR_HW_ADDR];
-	if (attr)
+	if (attr) {
 		err =3D devlink_port_function_hw_addr_set(devlink, port, attr, extack);
-
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
 	return err;
 }
=20
--=20
2.26.2

