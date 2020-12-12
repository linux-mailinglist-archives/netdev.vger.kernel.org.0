Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FD722D8511
	for <lists+netdev@lfdr.de>; Sat, 12 Dec 2020 07:17:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438380AbgLLGNk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Dec 2020 01:13:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:55100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730799AbgLLGNg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 12 Dec 2020 01:13:36 -0500
From:   Saeed Mahameed <saeed@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>,
        david.m.ertman@intel.com, dan.j.williams@intel.com,
        kiran.patil@intel.com, gregkh@linuxfoundation.org,
        Parav Pandit <parav@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Vu Pham <vuhuong@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next v3 04/14] devlink: Support get and set state of port function
Date:   Fri, 11 Dec 2020 22:12:15 -0800
Message-Id: <20201212061225.617337-5-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201212061225.617337-1-saeed@kernel.org>
References: <20201212061225.617337-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@nvidia.com>

devlink port function can be in active or inactive state.
Allow users to get and set port function's state.

When the port function it activated, its operational state may change
after a while when the device is created and driver binds to it.
Similarly on deactivation flow.

To clearly describe the state of the port function and its device's
operational state in the host system, define state and opstate
attributes.

Example of a PCI SF port which supports a port function:
Create a device with ID=10 and one physical port.

$ devlink dev eswitch set pci/0000:06:00.0 mode switchdev

$ devlink port show
pci/0000:06:00.0/65535: type eth netdev ens2f0np0 flavour physical port 0 splittable false

$ devlink port add pci/0000:06:00.0 flavour pcisf pfnum 0 sfnum 88

$ devlink port show pci/0000:06:00.0/32768
pci/0000:06:00.0/32768: type eth netdev ens2f0npf0sf88 flavour pcisf controller 0 pfnum 0 sfnum 88 external false splittable false
  function:
    hw_addr 00:00:00:00:88:88 state inactive opstate detached

$ devlink port function set pci/0000:06:00.0/32768 hw_addr 00:00:00:00:88:88 state active

$ devlink port show pci/0000:06:00.0/32768 -jp
{
    "port": {
        "pci/0000:06:00.0/32768": {
            "type": "eth",
            "netdev": "ens2f0npf0sf88",
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
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 include/net/devlink.h        | 23 +++++++++
 include/uapi/linux/devlink.h | 21 +++++++++
 net/core/devlink.c           | 90 +++++++++++++++++++++++++++++++++++-
 3 files changed, 133 insertions(+), 1 deletion(-)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index f8cff3e402da..18a7e66b7982 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1374,6 +1374,29 @@ struct devlink_ops {
 	int (*port_function_hw_addr_set)(struct devlink *devlink, struct devlink_port *port,
 					 const u8 *hw_addr, int hw_addr_len,
 					 struct netlink_ext_ack *extack);
+	/**
+	 * @port_function_state_get: Port function's state get function.
+	 *
+	 * Should be used by device drivers to report the state of a function
+	 * managed by the devlink port. Driver should return -EOPNOTSUPP if it
+	 * doesn't support port function handling for a particular port.
+	 */
+	int (*port_function_state_get)(struct devlink *devlink,
+				       struct devlink_port *port,
+				       enum devlink_port_function_state *state,
+				       enum devlink_port_function_opstate *opstate,
+				       struct netlink_ext_ack *extack);
+	/**
+	 * @port_function_state_set: Port function's state set function.
+	 *
+	 * Should be used by device drivers to set the state of a function
+	 * managed by the devlink port. Driver should return -EOPNOTSUPP if it
+	 * doesn't support port function handling for a particular port.
+	 */
+	int (*port_function_state_set)(struct devlink *devlink,
+				       struct devlink_port *port,
+				       enum devlink_port_function_state state,
+				       struct netlink_ext_ack *extack);
 	/**
 	 * @port_new: Port add function.
 	 *
diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index 6fe00f10eb3f..beeb30bb6b20 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -583,9 +583,30 @@ enum devlink_resource_unit {
 enum devlink_port_function_attr {
 	DEVLINK_PORT_FUNCTION_ATTR_UNSPEC,
 	DEVLINK_PORT_FUNCTION_ATTR_HW_ADDR,	/* binary */
+	DEVLINK_PORT_FUNCTION_ATTR_STATE,	/* u8 */
+	DEVLINK_PORT_FUNCTION_ATTR_OPSTATE,	/* u8 */
 
 	__DEVLINK_PORT_FUNCTION_ATTR_MAX,
 	DEVLINK_PORT_FUNCTION_ATTR_MAX = __DEVLINK_PORT_FUNCTION_ATTR_MAX - 1
 };
 
+enum devlink_port_function_state {
+	DEVLINK_PORT_FUNCTION_STATE_INACTIVE,
+	DEVLINK_PORT_FUNCTION_STATE_ACTIVE,
+};
+
+/**
+ * enum devlink_port_function_opstate - indicates operational state of port function
+ * @DEVLINK_PORT_FUNCTION_OPSTATE_ATTACHED: Driver is attached to the function of port, for
+ *					    gracefufl tear down of the function, after
+ *					    inactivation of the port function, user should wait
+ *					    for operational state to turn DETACHED.
+ * @DEVLINK_PORT_FUNCTION_OPSTATE_DETACHED: Driver is detached from the function of port; it is
+ *					    safe to delete the port.
+ */
+enum devlink_port_function_opstate {
+	DEVLINK_PORT_FUNCTION_OPSTATE_DETACHED,
+	DEVLINK_PORT_FUNCTION_OPSTATE_ATTACHED,
+};
+
 #endif /* _UAPI_LINUX_DEVLINK_H_ */
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 11043707f63f..b8acb8842aa1 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -87,6 +87,9 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(devlink_trap_report);
 
 static const struct nla_policy devlink_function_nl_policy[DEVLINK_PORT_FUNCTION_ATTR_MAX + 1] = {
 	[DEVLINK_PORT_FUNCTION_ATTR_HW_ADDR] = { .type = NLA_BINARY },
+	[DEVLINK_PORT_FUNCTION_ATTR_STATE] =
+		NLA_POLICY_RANGE(NLA_U8, DEVLINK_PORT_FUNCTION_STATE_INACTIVE,
+				 DEVLINK_PORT_FUNCTION_STATE_ACTIVE),
 };
 
 static LIST_HEAD(devlink_list);
@@ -746,6 +749,57 @@ devlink_port_function_hw_addr_fill(struct devlink *devlink, const struct devlink
 	return 0;
 }
 
+static bool
+devlink_port_function_state_valid(enum devlink_port_function_state state)
+{
+	return state == DEVLINK_PORT_FUNCTION_STATE_INACTIVE ||
+	       state == DEVLINK_PORT_FUNCTION_STATE_ACTIVE;
+}
+
+static bool
+devlink_port_function_opstate_valid(enum devlink_port_function_opstate state)
+{
+	return state == DEVLINK_PORT_FUNCTION_OPSTATE_DETACHED ||
+	       state == DEVLINK_PORT_FUNCTION_OPSTATE_ATTACHED;
+}
+
+static int
+devlink_port_function_state_fill(struct devlink *devlink,
+				 const struct devlink_ops *ops,
+				 struct devlink_port *port, struct sk_buff *msg,
+				 struct netlink_ext_ack *extack,
+				 bool *msg_updated)
+{
+	enum devlink_port_function_opstate opstate;
+	enum devlink_port_function_state state;
+	int err;
+
+	if (!ops->port_function_state_get)
+		return 0;
+
+	err = ops->port_function_state_get(devlink, port, &state, &opstate, extack);
+	if (err) {
+		if (err == -EOPNOTSUPP)
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
+		NL_SET_ERR_MSG_MOD(extack, "Invalid operational state value read from driver");
+		return -EINVAL;
+	}
+	if (nla_put_u8(msg, DEVLINK_PORT_FUNCTION_ATTR_STATE, state) ||
+	    nla_put_u8(msg, DEVLINK_PORT_FUNCTION_ATTR_OPSTATE, opstate))
+		return -EMSGSIZE;
+	*msg_updated = true;
+	return 0;
+}
+
 static int
 devlink_nl_port_function_attrs_put(struct sk_buff *msg, struct devlink_port *port,
 				   struct netlink_ext_ack *extack)
@@ -762,6 +816,13 @@ devlink_nl_port_function_attrs_put(struct sk_buff *msg, struct devlink_port *por
 
 	ops = devlink->ops;
 	err = devlink_port_function_hw_addr_fill(devlink, ops, port, msg, extack, &msg_updated);
+	if (err)
+		goto out;
+	err = devlink_port_function_state_fill(devlink, ops, port, msg, extack,
+					       &msg_updated);
+	if (err)
+		goto out;
+out:
 	if (err || !msg_updated)
 		nla_nest_cancel(msg, function_attr);
 	else
@@ -1027,6 +1088,22 @@ devlink_port_function_hw_addr_set(struct devlink *devlink, struct devlink_port *
 	return ops->port_function_hw_addr_set(devlink, port, hw_addr, hw_addr_len, extack);
 }
 
+static int
+devlink_port_function_state_set(struct devlink *devlink, struct devlink_port *port,
+				const struct nlattr *attr, struct netlink_ext_ack *extack)
+{
+	enum devlink_port_function_state state;
+	const struct devlink_ops *ops;
+
+	state = nla_get_u8(attr);
+	ops = devlink->ops;
+	if (!ops->port_function_state_set) {
+		NL_SET_ERR_MSG_MOD(extack, "Port function does not support state setting");
+		return -EOPNOTSUPP;
+	}
+	return ops->port_function_state_set(devlink, port, state, extack);
+}
+
 static int
 devlink_port_function_set(struct devlink *devlink, struct devlink_port *port,
 			  const struct nlattr *attr, struct netlink_ext_ack *extack)
@@ -1042,8 +1119,19 @@ devlink_port_function_set(struct devlink *devlink, struct devlink_port *port,
 	}
 
 	attr = tb[DEVLINK_PORT_FUNCTION_ATTR_HW_ADDR];
-	if (attr)
+	if (attr) {
 		err = devlink_port_function_hw_addr_set(devlink, port, attr, extack);
+		if (err)
+			return err;
+	}
+	/* Keep this as the last function attribute set, so that when
+	 * multiple port function attributes are set along with state,
+	 * Those can be applied first before activating the state.
+	 */
+	attr = tb[DEVLINK_PORT_FUNCTION_ATTR_STATE];
+	if (attr)
+		err = devlink_port_function_state_set(devlink, port, attr,
+						      extack);
 
 	if (!err)
 		devlink_port_notify(port, DEVLINK_CMD_PORT_NEW);
-- 
2.26.2

