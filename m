Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ABCE2FAB23
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 21:14:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388257AbhARUNs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 15:13:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:52824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394199AbhARUNa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Jan 2021 15:13:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F24FA22E01;
        Mon, 18 Jan 2021 20:12:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611000768;
        bh=rpOpVNFK47XAVtVXoj03P8w9A6Kqlmcx7ok9vv5zkzs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MhYkT9FtFMBY1NC8IUeNb5MwCpuIjzYWxNiu0kLrJxSSUysr1Zz9I2g0U4/7rXM+O
         jOdBhwRx+ruEooHXplpeCuvaYlx1j6z+nB/ZzuDpa0DD2n8TGdAXm0yDFcdLn2YvyV
         ErLE50W2Mw69GKTkVWT8hsejxskDekFpWGDUDrtumtOT0STGvAXQHv7kJcuSJ8TkYj
         nfd0mK0OlviRXpt5u2bOxBpsFUJ3xcQX0P/jlicQiEm3H0qgNC6MyJ4E6G7wC3L2Fw
         4glHmb8fqVOLHUokBHmSWjnW/e+D0mpLkNADreNkKyyPZ1nF8P2Jn/QGEFcpwZOjrZ
         ajAn2nTY8yNkw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        Parav Pandit <parav@nvidia.com>, Vu Pham <vuhuong@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next V7 03/14] devlink: Support add and delete devlink port
Date:   Mon, 18 Jan 2021 12:12:20 -0800
Message-Id: <20210118201231.363126-4-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210118201231.363126-1-saeed@kernel.org>
References: <20210118201231.363126-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@nvidia.com>

Extended devlink interface for the user to add and delete a port.
Extend devlink to connect user requests to driver to add/delete
a port in the device.

Driver routines are invoked without holding devlink instance lock.
This enables driver to perform several devlink objects registration,
unregistration such as (port, health reporter, resource etc) by using
existing devlink APIs.
This also helps to uniformly use the code for port unregistration
during driver unload and during port deletion initiated by user.

Examples of add, show and delete commands:
$ devlink dev eswitch set pci/0000:06:00.0 mode switchdev

$ devlink port show
pci/0000:06:00.0/65535: type eth netdev ens2f0np0 flavour physical port 0 splittable false

$ devlink port add pci/0000:06:00.0 flavour pcisf pfnum 0 sfnum 88
pci/0000:06:00.0/32768: type eth netdev eth6 flavour pcisf controller 0 pfnum 0 sfnum 88 external false splittable false
  function:
    hw_addr 00:00:00:00:00:00 state inactive opstate detached

$ devlink port show pci/0000:06:00.0/32768
pci/0000:06:00.0/32768: type eth netdev eth6 flavour pcisf controller 0 pfnum 0 sfnum 88 external false splittable false
  function:
    hw_addr 00:00:00:00:00:00 state inactive opstate detached

$ udevadm test-builtin net_id /sys/class/net/eth6
Load module index
Parsed configuration file /usr/lib/systemd/network/99-default.link
Created link configuration context.
Using default interface naming scheme 'v245'.
ID_NET_NAMING_SCHEME=v245
ID_NET_NAME_PATH=enp6s0f0npf0sf88
ID_NET_NAME_SLOT=ens2f0npf0sf88
Unload module index
Unloaded link configuration context.

Signed-off-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Vu Pham <vuhuong@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 include/net/devlink.h |  38 +++++++++++++
 net/core/devlink.c    | 121 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 159 insertions(+)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index dc3bf8000082..c048927c2621 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -152,6 +152,17 @@ struct devlink_port {
 	struct mutex reporters_lock; /* Protects reporter_list */
 };
 
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
@@ -1362,6 +1373,33 @@ struct devlink_ops {
 	int (*port_function_hw_addr_set)(struct devlink *devlink, struct devlink_port *port,
 					 const u8 *hw_addr, int hw_addr_len,
 					 struct netlink_ext_ack *extack);
+	/**
+	 * @port_new: Port add function.
+	 *
+	 * Should be used by device driver to let caller add new port of a
+	 * specified flavour with optional attributes.
+	 * Driver must return -EOPNOTSUPP if it doesn't support port addition
+	 * of a specified flavour or specified attributes. Driver should set
+	 * extack error message in case of failure. Driver callback is called
+	 * without holding the devlink instance lock. Driver must ensure
+	 * synchronization when adding or deleting a port. Driver must register
+	 * a port with devlink core.
+	 */
+	int (*port_new)(struct devlink *devlink,
+			const struct devlink_port_new_attrs *attrs,
+			struct netlink_ext_ack *extack,
+			unsigned int *new_port_index);
+	/**
+	 * @port_del: Port delete function.
+	 *
+	 * Should be used by device driver to let caller delete port which was
+	 * previously created using port_new() callback.
+	 * Driver must return -EOPNOTSUPP if it doesn't support port deletion.
+	 * Driver should set extack error message in case of failure. Driver
+	 * callback is called without holding the devlink instance lock.
+	 */
+	int (*port_del)(struct devlink *devlink, unsigned int port_index,
+			struct netlink_ext_ack *extack);
 };
 
 static inline void *devlink_priv(struct devlink *devlink)
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 4cbc02fb602d..541b5f549274 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -1147,6 +1147,111 @@ static int devlink_nl_cmd_port_unsplit_doit(struct sk_buff *skb,
 	return devlink_port_unsplit(devlink, port_index, info->extack);
 }
 
+static int devlink_port_new_notifiy(struct devlink *devlink,
+				    unsigned int port_index,
+				    struct genl_info *info)
+{
+	struct devlink_port *devlink_port;
+	struct sk_buff *msg;
+	int err;
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!msg)
+		return -ENOMEM;
+
+	mutex_lock(&devlink->lock);
+	devlink_port = devlink_port_get_by_index(devlink, port_index);
+	if (!devlink_port) {
+		err = -ENODEV;
+		goto out;
+	}
+
+	err = devlink_nl_port_fill(msg, devlink, devlink_port,
+				   DEVLINK_CMD_NEW, info->snd_portid,
+				   info->snd_seq, 0, NULL);
+	if (err)
+		goto out;
+
+	err = genlmsg_reply(msg, info);
+	mutex_unlock(&devlink->lock);
+	return err;
+
+out:
+	mutex_unlock(&devlink->lock);
+	nlmsg_free(msg);
+	return err;
+}
+
+static int devlink_nl_cmd_port_new_doit(struct sk_buff *skb,
+					struct genl_info *info)
+{
+	struct netlink_ext_ack *extack = info->extack;
+	struct devlink_port_new_attrs new_attrs = {};
+	struct devlink *devlink = info->user_ptr[0];
+	unsigned int new_port_index;
+	int err;
+
+	if (!devlink->ops->port_new || !devlink->ops->port_del)
+		return -EOPNOTSUPP;
+
+	if (!info->attrs[DEVLINK_ATTR_PORT_FLAVOUR] ||
+	    !info->attrs[DEVLINK_ATTR_PORT_PCI_PF_NUMBER]) {
+		NL_SET_ERR_MSG_MOD(extack, "Port flavour or PCI PF are not specified");
+		return -EINVAL;
+	}
+	new_attrs.flavour = nla_get_u16(info->attrs[DEVLINK_ATTR_PORT_FLAVOUR]);
+	new_attrs.pfnum =
+		nla_get_u16(info->attrs[DEVLINK_ATTR_PORT_PCI_PF_NUMBER]);
+
+	if (info->attrs[DEVLINK_ATTR_PORT_INDEX]) {
+		/* Port index of the new port being created by driver. */
+		new_attrs.port_index =
+			nla_get_u32(info->attrs[DEVLINK_ATTR_PORT_INDEX]);
+		new_attrs.port_index_valid = true;
+	}
+	if (info->attrs[DEVLINK_ATTR_PORT_CONTROLLER_NUMBER]) {
+		new_attrs.controller =
+			nla_get_u16(info->attrs[DEVLINK_ATTR_PORT_CONTROLLER_NUMBER]);
+		new_attrs.controller_valid = true;
+	}
+	if (new_attrs.flavour == DEVLINK_PORT_FLAVOUR_PCI_SF &&
+	    info->attrs[DEVLINK_ATTR_PORT_PCI_SF_NUMBER]) {
+		new_attrs.sfnum = nla_get_u32(info->attrs[DEVLINK_ATTR_PORT_PCI_SF_NUMBER]);
+		new_attrs.sfnum_valid = true;
+	}
+
+	err = devlink->ops->port_new(devlink, &new_attrs, extack,
+				     &new_port_index);
+	if (err)
+		return err;
+
+	err = devlink_port_new_notifiy(devlink, new_port_index, info);
+	if (err && err != -ENODEV) {
+		/* Fail to send the response; destroy newly created port. */
+		devlink->ops->port_del(devlink, new_port_index, extack);
+	}
+	return err;
+}
+
+static int devlink_nl_cmd_port_del_doit(struct sk_buff *skb,
+					struct genl_info *info)
+{
+	struct netlink_ext_ack *extack = info->extack;
+	struct devlink *devlink = info->user_ptr[0];
+	unsigned int port_index;
+
+	if (!devlink->ops->port_del)
+		return -EOPNOTSUPP;
+
+	if (!info->attrs[DEVLINK_ATTR_PORT_INDEX]) {
+		NL_SET_ERR_MSG_MOD(extack, "Port index is not specified");
+		return -EINVAL;
+	}
+	port_index = nla_get_u32(info->attrs[DEVLINK_ATTR_PORT_INDEX]);
+
+	return devlink->ops->port_del(devlink, port_index, extack);
+}
+
 static int devlink_nl_sb_fill(struct sk_buff *msg, struct devlink *devlink,
 			      struct devlink_sb *devlink_sb,
 			      enum devlink_command cmd, u32 portid,
@@ -7605,6 +7710,10 @@ static const struct nla_policy devlink_nl_policy[DEVLINK_ATTR_MAX + 1] = {
 	[DEVLINK_ATTR_RELOAD_ACTION] = NLA_POLICY_RANGE(NLA_U8, DEVLINK_RELOAD_ACTION_DRIVER_REINIT,
 							DEVLINK_RELOAD_ACTION_MAX),
 	[DEVLINK_ATTR_RELOAD_LIMITS] = NLA_POLICY_BITFIELD32(DEVLINK_RELOAD_LIMITS_VALID_MASK),
+	[DEVLINK_ATTR_PORT_FLAVOUR] = { .type = NLA_U16 },
+	[DEVLINK_ATTR_PORT_PCI_PF_NUMBER] = { .type = NLA_U16 },
+	[DEVLINK_ATTR_PORT_PCI_SF_NUMBER] = { .type = NLA_U32 },
+	[DEVLINK_ATTR_PORT_CONTROLLER_NUMBER] = { .type = NLA_U32 },
 };
 
 static const struct genl_small_ops devlink_nl_ops[] = {
@@ -7644,6 +7753,18 @@ static const struct genl_small_ops devlink_nl_ops[] = {
 		.flags = GENL_ADMIN_PERM,
 		.internal_flags = DEVLINK_NL_FLAG_NO_LOCK,
 	},
+	{
+		.cmd = DEVLINK_CMD_PORT_NEW,
+		.doit = devlink_nl_cmd_port_new_doit,
+		.flags = GENL_ADMIN_PERM,
+		.internal_flags = DEVLINK_NL_FLAG_NO_LOCK,
+	},
+	{
+		.cmd = DEVLINK_CMD_PORT_DEL,
+		.doit = devlink_nl_cmd_port_del_doit,
+		.flags = GENL_ADMIN_PERM,
+		.internal_flags = DEVLINK_NL_FLAG_NO_LOCK,
+	},
 	{
 		.cmd = DEVLINK_CMD_SB_GET,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
-- 
2.26.2

