Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74BC63122D3
	for <lists+netdev@lfdr.de>; Sun,  7 Feb 2021 09:45:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229615AbhBGIpJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Feb 2021 03:45:09 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:4338 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbhBGIpH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Feb 2021 03:45:07 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B601fa86a0002>; Sun, 07 Feb 2021 00:44:26 -0800
Received: from sw-mtx-036.mtx.labs.mlnx (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Sun, 7 Feb
 2021 08:44:26 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     Parav Pandit <parav@nvidia.com>
Subject: [PATCH net-next v2 1/7] netdevsim: Add support for add and delete of a PCI PF port
Date:   Sun, 7 Feb 2021 10:44:06 +0200
Message-ID: <20210207084412.252259-2-parav@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210207084412.252259-1-parav@nvidia.com>
References: <20210206125551.8616-1-parav@nvidia.com>
 <20210207084412.252259-1-parav@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612687466; bh=YWsKnYvpCxidwvvyILGnK+3NUyJvl4y2nWRuLWrnDm0=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=nqeeNs4F2GPvg15i+pL01oQ/zHZBPWEEolhVFGJNQj0EMQvMF71EBZOIVjrknWKcu
         guNdtY3tQu59+/dGjLeH5QIyHibCEZ1B9hPGH5dd5XdRobo0xLT4dnFmWxQT+Iv7Xc
         hnTIBvmWKkNxnL+tNQ9SVehc/mfQyvKzxwP17Pavaj2b1Xvu2YqVdGSlIxWMFhbAxE
         R+iyzgLwIXgGdvrKdrl1M+UXpy5XQcVOQWCO9boLy3h+N/XDAQO+mJgymyWAT+T4Ul
         bjIg2sZ9mEUVezSRyaBrGyQL3dW13W7iVXVT2J0vjpXS4Vo+Kh1ZOQ3a96kLy5tCWb
         zQgjD4yARzGNA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simulate PCI PF ports. Allow user to create one or more PCI PF ports.

Examples:

Create a device with ID=3D10 and one physical port.
$ echo "10 1" > /sys/bus/netdevsim/new_device

Add devlink port of flavour 'pcipf' for PF number 2:

$ devlink port add netdevsim/netdevsim10 flavour pcipf pfnum 2
netdevsim/netdevsim10/4: type eth netdev eth4 flavour pcipf controller 0 pf=
num 2 external false splittable false

Show the PCI PF port:
$ devlink port show netdevsim/netdevsim10/4
netdevsim/netdevsim10/4: type eth netdev eth4 flavour pcipf controller 0 pf=
num 2 external false splittable false

Delete newly added devlink port:
$ devlink port del netdevsim/netdevsim10/4

issue: 2241444
Signed-off-by: Parav Pandit <parav@nvidia.com>
---
changelog:
v1->v2:
 - fixed warning for unused err value

---
 drivers/net/netdevsim/Makefile        |   2 +-
 drivers/net/netdevsim/dev.c           |  10 +
 drivers/net/netdevsim/netdevsim.h     |  20 ++
 drivers/net/netdevsim/port_function.c | 340 ++++++++++++++++++++++++++
 4 files changed, 371 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/netdevsim/port_function.c

diff --git a/drivers/net/netdevsim/Makefile b/drivers/net/netdevsim/Makefil=
e
index ade086eed955..be2aefafc498 100644
--- a/drivers/net/netdevsim/Makefile
+++ b/drivers/net/netdevsim/Makefile
@@ -3,7 +3,7 @@
 obj-$(CONFIG_NETDEVSIM) +=3D netdevsim.o
=20
 netdevsim-objs :=3D \
-	netdev.o dev.o ethtool.o fib.o bus.o health.o udp_tunnels.o
+	netdev.o dev.o ethtool.o fib.o bus.o health.o udp_tunnels.o port_function=
.o
=20
 ifeq ($(CONFIG_BPF_SYSCALL),y)
 netdevsim-objs +=3D \
diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index 816af1f55e2c..806e387918fe 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -905,6 +905,8 @@ static const struct devlink_ops nsim_dev_devlink_ops =
=3D {
 	.trap_group_set =3D nsim_dev_devlink_trap_group_set,
 	.trap_policer_set =3D nsim_dev_devlink_trap_policer_set,
 	.trap_policer_counter_get =3D nsim_dev_devlink_trap_policer_counter_get,
+	.port_new =3D nsim_dev_devlink_port_new,
+	.port_del =3D nsim_dev_devlink_port_del,
 };
=20
 #define NSIM_DEV_MAX_MACS_DEFAULT 32
@@ -1039,6 +1041,8 @@ static int nsim_dev_reload_create(struct nsim_dev *ns=
im_dev,
 						      nsim_dev->ddir,
 						      nsim_dev,
 						&nsim_dev_take_snapshot_fops);
+
+	nsim_dev_port_fn_enable(nsim_dev);
 	return 0;
=20
 err_health_exit:
@@ -1073,6 +1077,7 @@ int nsim_dev_probe(struct nsim_bus_dev *nsim_bus_dev)
 	nsim_dev->max_macs =3D NSIM_DEV_MAX_MACS_DEFAULT;
 	nsim_dev->test1 =3D NSIM_DEV_TEST1_DEFAULT;
 	spin_lock_init(&nsim_dev->fa_cookie_lock);
+	nsim_dev_port_fn_init(nsim_dev);
=20
 	dev_set_drvdata(&nsim_bus_dev->dev, nsim_dev);
=20
@@ -1120,6 +1125,7 @@ int nsim_dev_probe(struct nsim_bus_dev *nsim_bus_dev)
 	if (err)
 		goto err_bpf_dev_exit;
=20
+	nsim_dev_port_fn_enable(nsim_dev);
 	devlink_params_publish(devlink);
 	devlink_reload_enable(devlink);
 	return 0;
@@ -1154,6 +1160,9 @@ static void nsim_dev_reload_destroy(struct nsim_dev *=
nsim_dev)
=20
 	if (devlink_is_reload_failed(devlink))
 		return;
+
+	/* Disable and destroy any user created devlink ports */
+	nsim_dev_port_fn_disable(nsim_dev);
 	debugfs_remove(nsim_dev->take_snapshot);
 	nsim_dev_port_del_all(nsim_dev);
 	nsim_dev_health_exit(nsim_dev);
@@ -1178,6 +1187,7 @@ void nsim_dev_remove(struct nsim_bus_dev *nsim_bus_de=
v)
 				  ARRAY_SIZE(nsim_devlink_params));
 	devlink_unregister(devlink);
 	devlink_resources_unregister(devlink, NULL);
+	nsim_dev_port_fn_exit(nsim_dev);
 	devlink_free(devlink);
 }
=20
diff --git a/drivers/net/netdevsim/netdevsim.h b/drivers/net/netdevsim/netd=
evsim.h
index 48163c5f2ec9..31beddede0f2 100644
--- a/drivers/net/netdevsim/netdevsim.h
+++ b/drivers/net/netdevsim/netdevsim.h
@@ -229,6 +229,15 @@ struct nsim_dev {
 		bool static_iana_vxlan;
 		u32 sleep;
 	} udp_ports;
+	struct {
+		struct list_head head;
+		struct ida ida;
+		struct ida pfnum_ida;
+		struct mutex disable_mutex; /* protects port deletion
+					     * by driver unload context
+					     */
+		bool enabled;
+	} port_functions;
 };
=20
 static inline struct net *nsim_dev_net(struct nsim_dev *nsim_dev)
@@ -299,3 +308,14 @@ struct nsim_bus_dev {
=20
 int nsim_bus_init(void);
 void nsim_bus_exit(void);
+
+void nsim_dev_port_fn_init(struct nsim_dev *nsim_dev);
+void nsim_dev_port_fn_exit(struct nsim_dev *nsim_dev);
+void nsim_dev_port_fn_enable(struct nsim_dev *nsim_dev);
+void nsim_dev_port_fn_disable(struct nsim_dev *nsim_dev);
+int nsim_dev_devlink_port_new(struct devlink *devlink,
+			      const struct devlink_port_new_attrs *attrs,
+			      struct netlink_ext_ack *extack,
+			      unsigned int *new_port_index);
+int nsim_dev_devlink_port_del(struct devlink *devlink, unsigned int port_i=
ndex,
+			      struct netlink_ext_ack *extack);
diff --git a/drivers/net/netdevsim/port_function.c b/drivers/net/netdevsim/=
port_function.c
new file mode 100644
index 000000000000..7df1ca5ad7b8
--- /dev/null
+++ b/drivers/net/netdevsim/port_function.c
@@ -0,0 +1,340 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/* Copyright (c) 2020 Mellanox Technologies Ltd. */
+
+#include <linux/etherdevice.h>
+#include <uapi/linux/devlink.h>
+
+#include "netdevsim.h"
+
+struct nsim_port_fn {
+	struct devlink_port dl_port;
+	struct net_device *netdev;
+	struct list_head list;
+	unsigned int port_index;
+	enum devlink_port_flavour flavour;
+	u16 pfnum;
+};
+
+static struct devlink_port *
+nsim_dev_port_fn_get_devlink_port(struct net_device *dev)
+{
+	struct nsim_port_fn *port =3D netdev_priv(dev);
+
+	return &port->dl_port;
+}
+
+static netdev_tx_t
+nsim_dev_port_fn_start_xmit(struct sk_buff *skb, struct net_device *dev)
+{
+	dev_kfree_skb(skb);
+	return NETDEV_TX_OK;
+}
+
+static const struct net_device_ops nsim_netdev_ops =3D {
+	.ndo_start_xmit =3D nsim_dev_port_fn_start_xmit,
+	.ndo_get_devlink_port =3D nsim_dev_port_fn_get_devlink_port,
+};
+
+static void nsim_port_fn_ndev_setup(struct net_device *dev)
+{
+	ether_setup(dev);
+	eth_hw_addr_random(dev);
+
+	dev->tx_queue_len =3D 0;
+	dev->flags |=3D IFF_NOARP;
+	dev->flags &=3D ~IFF_MULTICAST;
+	dev->max_mtu =3D ETH_MAX_MTU;
+}
+
+static struct nsim_port_fn *
+nsim_devlink_port_fn_alloc(struct nsim_dev *dev,
+			   const struct devlink_port_new_attrs *attrs)
+{
+	struct nsim_bus_dev *nsim_bus_dev =3D dev->nsim_bus_dev;
+	struct nsim_port_fn *port;
+	struct net_device *netdev;
+	int ret;
+
+	netdev =3D alloc_netdev(sizeof(*port), "eth%d", NET_NAME_UNKNOWN,
+			      nsim_port_fn_ndev_setup);
+	if (!netdev)
+		return ERR_PTR(-ENOMEM);
+
+	dev_net_set(netdev, nsim_dev_net(dev));
+	netdev->netdev_ops =3D &nsim_netdev_ops;
+	nsim_bus_dev =3D dev->nsim_bus_dev;
+	SET_NETDEV_DEV(netdev, &nsim_bus_dev->dev);
+
+	port =3D netdev_priv(netdev);
+	memset(port, 0, sizeof(*port));
+	port->netdev =3D netdev;
+	port->flavour =3D attrs->flavour;
+
+	if (attrs->port_index_valid)
+		ret =3D ida_alloc_range(&dev->port_functions.ida,
+				      attrs->port_index,
+				      attrs->port_index, GFP_KERNEL);
+	else
+		ret =3D ida_alloc_min(&dev->port_functions.ida,
+				    nsim_bus_dev->port_count, GFP_KERNEL);
+	if (ret < 0)
+		goto port_ida_err;
+
+	port->port_index =3D ret;
+
+	switch (port->flavour) {
+	case DEVLINK_PORT_FLAVOUR_PCI_PF:
+		ret =3D ida_alloc_range(&dev->port_functions.pfnum_ida,
+				      attrs->pfnum, attrs->pfnum,
+				      GFP_KERNEL);
+		if (ret < 0)
+			goto fn_ida_err;
+		port->pfnum =3D ret;
+		break;
+	default:
+		break;
+	}
+	return port;
+
+fn_ida_err:
+	ida_simple_remove(&dev->port_functions.ida, port->port_index);
+port_ida_err:
+	free_netdev(netdev);
+	return ERR_PTR(ret);
+}
+
+static void
+nsim_devlink_port_fn_free(struct nsim_dev *dev, struct nsim_port_fn *port)
+{
+	switch (port->flavour) {
+	case DEVLINK_PORT_FLAVOUR_PCI_PF:
+		ida_simple_remove(&dev->port_functions.pfnum_ida, port->pfnum);
+		break;
+	default:
+		break;
+	}
+	ida_simple_remove(&dev->port_functions.ida, port->port_index);
+	free_netdev(port->netdev);
+}
+
+static bool
+nsim_dev_port_index_internal(struct nsim_dev *nsim_dev, unsigned int port_=
index)
+{
+	struct nsim_bus_dev *nsim_bus_dev =3D nsim_dev->nsim_bus_dev;
+
+	return (port_index < nsim_bus_dev->port_count) ? true : false;
+}
+
+static bool
+nsim_dev_port_port_exists(struct nsim_dev *nsim_dev,
+			  const struct devlink_port_new_attrs *attrs)
+{
+	struct nsim_port_fn *tmp;
+
+	list_for_each_entry(tmp, &nsim_dev->port_functions.head, list) {
+		if (attrs->port_index_valid &&
+		    tmp->port_index =3D=3D attrs->port_index)
+			return true;
+		if (attrs->flavour =3D=3D DEVLINK_PORT_FLAVOUR_PCI_PF &&
+		    tmp->flavour =3D=3D DEVLINK_PORT_FLAVOUR_PCI_PF &&
+		    tmp->pfnum =3D=3D attrs->pfnum)
+			return true;
+	}
+	return false;
+}
+
+static struct nsim_port_fn *
+nsim_dev_devlink_port_index_lookup(const struct nsim_dev *nsim_dev,
+				   unsigned int port_index,
+				   struct netlink_ext_ack *extack)
+{
+	struct nsim_port_fn *port;
+
+	list_for_each_entry(port, &nsim_dev->port_functions.head, list) {
+		if (port->port_index !=3D port_index)
+			continue;
+		return port;
+	}
+	NL_SET_ERR_MSG_MOD(extack, "User created port not found");
+	return ERR_PTR(-ENOENT);
+}
+
+static int nsim_devlink_port_fn_add(struct devlink *devlink,
+				    struct nsim_dev *nsim_dev,
+				    struct nsim_port_fn *port,
+				    struct netlink_ext_ack *extack)
+{
+	int err;
+
+	list_add(&port->list, &nsim_dev->port_functions.head);
+
+	err =3D devlink_port_register(devlink, &port->dl_port, port->port_index);
+	if (err)
+		goto reg_err;
+
+	err =3D register_netdev(port->netdev);
+	if (err)
+		goto netdev_err;
+
+	devlink_port_type_eth_set(&port->dl_port, port->netdev);
+	return 0;
+
+netdev_err:
+	devlink_port_type_clear(&port->dl_port);
+	devlink_port_unregister(&port->dl_port);
+reg_err:
+	list_del(&port->list);
+	return err;
+}
+
+static void nsim_devlink_port_fn_del(struct nsim_dev *nsim_dev,
+				     struct nsim_port_fn *port)
+{
+	devlink_port_type_clear(&port->dl_port);
+	unregister_netdev(port->netdev);
+	devlink_port_unregister(&port->dl_port);
+	list_del(&port->list);
+}
+
+static bool
+nsim_dev_port_flavour_supported(const struct nsim_dev *nsim_dev,
+				const struct devlink_port_new_attrs *attrs)
+{
+	return attrs->flavour =3D=3D DEVLINK_PORT_FLAVOUR_PCI_PF;
+}
+
+int nsim_dev_devlink_port_new(struct devlink *devlink,
+			      const struct devlink_port_new_attrs *attrs,
+			      struct netlink_ext_ack *extack,
+			      unsigned int *new_port_index)
+{
+	struct nsim_dev *nsim_dev =3D devlink_priv(devlink);
+	struct nsim_bus_dev *nsim_bus_dev;
+	struct nsim_port_fn *port;
+	int err;
+
+	nsim_bus_dev =3D nsim_dev->nsim_bus_dev;
+	if (attrs->port_index_valid &&
+	    attrs->port_index < nsim_bus_dev->port_count) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Port with given port index already exist");
+		return -EEXIST;
+	}
+	if (!nsim_dev_port_flavour_supported(nsim_dev, attrs)) {
+		NL_SET_ERR_MSG_MOD(extack, "Unsupported port flavour specified");
+		return -EOPNOTSUPP;
+	}
+	mutex_lock(&nsim_dev->port_functions.disable_mutex);
+	if (!nsim_dev->port_functions.enabled) {
+		err =3D -ENODEV;
+		goto alloc_err;
+	}
+	if (nsim_dev_port_port_exists(nsim_dev, attrs)) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Port with given attributes already exists");
+		err =3D -EEXIST;
+		goto alloc_err;
+	}
+	port =3D nsim_devlink_port_fn_alloc(nsim_dev, attrs);
+	if (IS_ERR(port)) {
+		NL_SET_ERR_MSG_MOD(extack, "Fail to allocate port");
+		err =3D PTR_ERR(port);
+		goto alloc_err;
+	}
+	memcpy(port->dl_port.attrs.switch_id.id, nsim_dev->switch_id.id,
+	       nsim_dev->switch_id.id_len);
+	port->dl_port.attrs.switch_id.id_len =3D nsim_dev->switch_id.id_len;
+
+	devlink_port_attrs_pci_pf_set(&port->dl_port, 0, port->pfnum, false);
+
+	err =3D nsim_devlink_port_fn_add(devlink, nsim_dev, port, extack);
+	if (err)
+		goto add_err;
+	*new_port_index =3D port->port_index;
+	mutex_unlock(&nsim_dev->port_functions.disable_mutex);
+	return 0;
+
+add_err:
+	nsim_devlink_port_fn_free(nsim_dev, port);
+alloc_err:
+	mutex_unlock(&nsim_dev->port_functions.disable_mutex);
+	return err;
+}
+
+int nsim_dev_devlink_port_del(struct devlink *devlink, unsigned int port_i=
ndex,
+			      struct netlink_ext_ack *extack)
+{
+	struct nsim_dev *nsim_dev =3D devlink_priv(devlink);
+	struct nsim_port_fn *port;
+	int err;
+
+	if (nsim_dev_port_index_internal(nsim_dev, port_index)) {
+		NL_SET_ERR_MSG_MOD(extack, "Port index doesn't belong to user created po=
rt");
+		return -EINVAL;
+	}
+
+	mutex_lock(&nsim_dev->port_functions.disable_mutex);
+	if (!nsim_dev->port_functions.enabled) {
+		err =3D -ENODEV;
+		goto err;
+	}
+
+	port =3D nsim_dev_devlink_port_index_lookup(nsim_dev, port_index, extack)=
;
+	if (IS_ERR(port)) {
+		err =3D PTR_ERR(port);
+		goto err;
+	}
+	nsim_devlink_port_fn_del(nsim_dev, port);
+	nsim_devlink_port_fn_free(nsim_dev, port);
+	mutex_unlock(&nsim_dev->port_functions.disable_mutex);
+	return 0;
+
+err:
+	mutex_unlock(&nsim_dev->port_functions.disable_mutex);
+	return err;
+}
+
+void nsim_dev_port_fn_init(struct nsim_dev *nsim_dev)
+{
+	mutex_init(&nsim_dev->port_functions.disable_mutex);
+	INIT_LIST_HEAD(&nsim_dev->port_functions.head);
+	ida_init(&nsim_dev->port_functions.ida);
+	ida_init(&nsim_dev->port_functions.pfnum_ida);
+}
+
+void nsim_dev_port_fn_exit(struct nsim_dev *nsim_dev)
+{
+	WARN_ON(!ida_is_empty(&nsim_dev->port_functions.pfnum_ida));
+	ida_destroy(&nsim_dev->port_functions.pfnum_ida);
+	WARN_ON(!ida_is_empty(&nsim_dev->port_functions.ida));
+	ida_destroy(&nsim_dev->port_functions.ida);
+	WARN_ON(!list_empty(&nsim_dev->port_functions.head));
+	mutex_destroy(&nsim_dev->port_functions.disable_mutex);
+}
+
+void nsim_dev_port_fn_enable(struct nsim_dev *nsim_dev)
+{
+	mutex_lock(&nsim_dev->port_functions.disable_mutex);
+	nsim_dev->port_functions.enabled =3D true;
+	mutex_unlock(&nsim_dev->port_functions.disable_mutex);
+}
+
+void nsim_dev_port_fn_disable(struct nsim_dev *nsim_dev)
+{
+	struct nsim_port_fn *port;
+	struct nsim_port_fn *tmp;
+
+	mutex_lock(&nsim_dev->port_functions.disable_mutex);
+	nsim_dev->port_functions.enabled =3D false;
+	mutex_unlock(&nsim_dev->port_functions.disable_mutex);
+
+	/* At this point, no new user commands can start and any ongoing
+	 * commands have completed, so it is safe to delete all user created
+	 * ports.
+	 */
+	list_for_each_entry_safe_reverse(port, tmp,
+					 &nsim_dev->port_functions.head, list) {
+		nsim_devlink_port_fn_del(nsim_dev, port);
+		nsim_devlink_port_fn_free(nsim_dev, port);
+	}
+}
--=20
2.26.2

