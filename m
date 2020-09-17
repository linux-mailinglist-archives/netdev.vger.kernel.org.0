Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5BD026E244
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 19:24:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726502AbgIQRXy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 13:23:54 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:19693 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726440AbgIQRUp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 13:20:45 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f639ad80001>; Thu, 17 Sep 2020 10:20:24 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Thu, 17 Sep 2020 10:20:37 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Thu, 17 Sep 2020 10:20:37 -0700
Received: from sw-mtx-036.mtx.labs.mlnx (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 17 Sep
 2020 17:20:36 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     Parav Pandit <parav@nvidia.com>, Jiri Pirko <jiri@nvidia.com>
Subject: [PATCH net-next v2 5/8] netdevsim: Add support for add and delete of a PCI PF port
Date:   Thu, 17 Sep 2020 20:20:17 +0300
Message-ID: <20200917172020.26484-6-parav@nvidia.com>
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
        t=1600363224; bh=65XMLc42P1oYsa7VBLr1ijWhx7VYy4lRDGJcYcmLhmw=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:
         Content-Type:X-Originating-IP:X-ClientProxiedBy;
        b=Y2eq5M2x2xqzSrI7V9bOq57bqp8cF6JneKv1FHXE2uwKyfa7ZS9UJkA7jGHuQfTZZ
         dpFLNyhq3OcIgWU+Gm5fmGqLLCTukA3NjniRnFjlCVRQeHuxN8iK6NdGa/Vpgd+zci
         C5DOTI7DaZlZcA4N8xghCAJgz5SHIzJyb5qD8LbOJRRkx76nCU1Ti4byi7/4t9Scth
         /jnNoH3xkUZqHq6UOM8wJwmbvJjxxucgTWA/zlENHITuPPaer7mHJ4UueUi7wx5wLc
         UOMNqK8Q3+eykIpPmz+0V33usNrfuhlknJYYx0W5Bu2VH1eYPZtk/GVQ+PJYtjozsG
         fVL+Cxv+1PwxA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simulate PCI PF ports. Allow user to create one or more PCI PF ports.

Examples:

Create a device with ID=3D10 and one physical port.
$ echo "10 1" > /sys/bus/netdevsim/new_device

Add and show devlink port of flavour 'pcipf' for PF number 0.

$ devlink port add netdevsim/netdevsim10/10 flavour pcipf pfnum 0

$ devlink port show netdevsim/netdevsim10/10
netdevsim/netdevsim10/10: type eth netdev eni10npf0 flavour pcipf controlle=
r 0 pfnum 0 external false splittable false
  function:
    hw_addr 00:00:00:00:00:00 state inactive

Delete newly added devlink port
$ devlink port add netdevsim/netdevsim10/10

Signed-off-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
Changelog:
v1->v2:
 - Fixed extra semicolon at end of switch case reportec by coccinelle
---
 drivers/net/netdevsim/Makefile        |   3 +-
 drivers/net/netdevsim/dev.c           |  10 +
 drivers/net/netdevsim/netdevsim.h     |  19 ++
 drivers/net/netdevsim/port_function.c | 337 ++++++++++++++++++++++++++
 4 files changed, 368 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/netdevsim/port_function.c

diff --git a/drivers/net/netdevsim/Makefile b/drivers/net/netdevsim/Makefil=
e
index ade086eed955..e69e895af62c 100644
--- a/drivers/net/netdevsim/Makefile
+++ b/drivers/net/netdevsim/Makefile
@@ -3,7 +3,8 @@
 obj-$(CONFIG_NETDEVSIM) +=3D netdevsim.o
=20
 netdevsim-objs :=3D \
-	netdev.o dev.o ethtool.o fib.o bus.o health.o udp_tunnels.o
+	netdev.o dev.o ethtool.o fib.o bus.o health.o udp_tunnels.o \
+	port_function.o
=20
 ifeq ($(CONFIG_BPF_SYSCALL),y)
 netdevsim-objs +=3D \
diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index 32f339fedb21..e3b81c8b5125 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -884,6 +884,8 @@ static const struct devlink_ops nsim_dev_devlink_ops =
=3D {
 	.trap_group_set =3D nsim_dev_devlink_trap_group_set,
 	.trap_policer_set =3D nsim_dev_devlink_trap_policer_set,
 	.trap_policer_counter_get =3D nsim_dev_devlink_trap_policer_counter_get,
+	.port_new =3D nsim_dev_devlink_port_new,
+	.port_del =3D nsim_dev_devlink_port_del,
 };
=20
 #define NSIM_DEV_MAX_MACS_DEFAULT 32
@@ -1017,6 +1019,8 @@ static int nsim_dev_reload_create(struct nsim_dev *ns=
im_dev,
 						      nsim_dev->ddir,
 						      nsim_dev,
 						&nsim_dev_take_snapshot_fops);
+
+	nsim_dev_port_function_enable(nsim_dev);
 	return 0;
=20
 err_health_exit:
@@ -1050,6 +1054,7 @@ int nsim_dev_probe(struct nsim_bus_dev *nsim_bus_dev)
 	nsim_dev->max_macs =3D NSIM_DEV_MAX_MACS_DEFAULT;
 	nsim_dev->test1 =3D NSIM_DEV_TEST1_DEFAULT;
 	spin_lock_init(&nsim_dev->fa_cookie_lock);
+	nsim_dev_port_function_init(nsim_dev);
=20
 	dev_set_drvdata(&nsim_bus_dev->dev, nsim_dev);
=20
@@ -1097,6 +1102,7 @@ int nsim_dev_probe(struct nsim_bus_dev *nsim_bus_dev)
 	if (err)
 		goto err_bpf_dev_exit;
=20
+	nsim_dev_port_function_enable(nsim_dev);
 	devlink_params_publish(devlink);
 	devlink_reload_enable(devlink);
 	return 0;
@@ -1131,6 +1137,9 @@ static void nsim_dev_reload_destroy(struct nsim_dev *=
nsim_dev)
=20
 	if (devlink_is_reload_failed(devlink))
 		return;
+
+	/* Disable and destroy any user created devlink ports */
+	nsim_dev_port_function_disable(nsim_dev);
 	debugfs_remove(nsim_dev->take_snapshot);
 	nsim_dev_port_del_all(nsim_dev);
 	nsim_dev_health_exit(nsim_dev);
@@ -1155,6 +1164,7 @@ void nsim_dev_remove(struct nsim_bus_dev *nsim_bus_de=
v)
 				  ARRAY_SIZE(nsim_devlink_params));
 	devlink_unregister(devlink);
 	devlink_resources_unregister(devlink, NULL);
+	nsim_dev_port_function_exit(nsim_dev);
 	devlink_free(devlink);
 }
=20
diff --git a/drivers/net/netdevsim/netdevsim.h b/drivers/net/netdevsim/netd=
evsim.h
index 0c86561e6d8d..aec3c4d5fda7 100644
--- a/drivers/net/netdevsim/netdevsim.h
+++ b/drivers/net/netdevsim/netdevsim.h
@@ -213,6 +213,16 @@ struct nsim_dev {
 		bool ipv4_only;
 		u32 sleep;
 	} udp_ports;
+	struct {
+		refcount_t refcount; /* refcount along with disable_complete serializes
+				      * port operations with port function disablement
+				      * during driver unload.
+				      */
+		struct completion disable_complete;
+		struct list_head head;
+		struct ida ida;
+		struct ida pfnum_ida;
+	} port_functions;
 };
=20
 static inline struct net *nsim_dev_net(struct nsim_dev *nsim_dev)
@@ -283,3 +293,12 @@ struct nsim_bus_dev {
=20
 int nsim_bus_init(void);
 void nsim_bus_exit(void);
+
+void nsim_dev_port_function_init(struct nsim_dev *nsim_dev);
+void nsim_dev_port_function_exit(struct nsim_dev *nsim_dev);
+void nsim_dev_port_function_enable(struct nsim_dev *nsim_dev);
+void nsim_dev_port_function_disable(struct nsim_dev *nsim_dev);
+int nsim_dev_devlink_port_new(struct devlink *devlink, const struct devlin=
k_port_new_attrs *attrs,
+			      struct netlink_ext_ack *extack);
+int nsim_dev_devlink_port_del(struct devlink *devlink, unsigned int port_i=
ndex,
+			      struct netlink_ext_ack *extack);
diff --git a/drivers/net/netdevsim/port_function.c b/drivers/net/netdevsim/=
port_function.c
new file mode 100644
index 000000000000..4f3e9cc9489f
--- /dev/null
+++ b/drivers/net/netdevsim/port_function.c
@@ -0,0 +1,337 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/* Copyright (c) 2020 Mellanox Technologies Ltd. */
+
+#include <linux/etherdevice.h>
+#include <uapi/linux/devlink.h>
+
+#include "netdevsim.h"
+
+struct nsim_port_function {
+	struct devlink_port dl_port;
+	struct net_device *netdev;
+	struct list_head list;
+	unsigned int port_index;
+	enum devlink_port_flavour flavour;
+	u32 controller;
+	u16 pfnum;
+	struct nsim_port_function *pf_port; /* Valid only for SF port */
+};
+
+void nsim_dev_port_function_init(struct nsim_dev *nsim_dev)
+{
+	refcount_set(&nsim_dev->port_functions.refcount, 0);
+	INIT_LIST_HEAD(&nsim_dev->port_functions.head);
+	ida_init(&nsim_dev->port_functions.ida);
+	ida_init(&nsim_dev->port_functions.pfnum_ida);
+}
+
+void nsim_dev_port_function_exit(struct nsim_dev *nsim_dev)
+{
+	WARN_ON(!ida_is_empty(&nsim_dev->port_functions.pfnum_ida));
+	ida_destroy(&nsim_dev->port_functions.pfnum_ida);
+	WARN_ON(!ida_is_empty(&nsim_dev->port_functions.ida));
+	ida_destroy(&nsim_dev->port_functions.ida);
+	WARN_ON(!list_empty(&nsim_dev->port_functions.head));
+	WARN_ON(refcount_read(&nsim_dev->port_functions.refcount));
+}
+
+static bool nsim_dev_port_function_try_get(struct nsim_dev *nsim_dev)
+{
+	return refcount_inc_not_zero(&nsim_dev->port_functions.refcount);
+}
+
+static void nsim_dev_port_function_put(struct nsim_dev *nsim_dev)
+{
+	if (refcount_dec_and_test(&nsim_dev->port_functions.refcount))
+		complete(&nsim_dev->port_functions.disable_complete);
+}
+
+static struct devlink_port *nsim_dev_port_function_get_devlink_port(struct=
 net_device *dev)
+{
+	struct nsim_port_function *port =3D netdev_priv(dev);
+
+	return &port->dl_port;
+}
+
+static netdev_tx_t nsim_dev_port_function_start_xmit(struct sk_buff *skb, =
struct net_device *dev)
+{
+	dev_kfree_skb(skb);
+	return NETDEV_TX_OK;
+}
+
+static const struct net_device_ops nsim_netdev_ops =3D {
+	.ndo_start_xmit =3D nsim_dev_port_function_start_xmit,
+	.ndo_get_devlink_port =3D nsim_dev_port_function_get_devlink_port,
+};
+
+static void nsim_port_function_ndev_setup(struct net_device *dev)
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
+static struct nsim_port_function *
+nsim_devlink_port_function_alloc(struct nsim_dev *dev, const struct devlin=
k_port_new_attrs *attrs)
+{
+	struct nsim_bus_dev *nsim_bus_dev =3D dev->nsim_bus_dev;
+	struct nsim_port_function *port;
+	struct net_device *netdev;
+	int ret;
+
+	netdev =3D alloc_netdev(sizeof(*port), "eth%d", NET_NAME_UNKNOWN,
+			      nsim_port_function_ndev_setup);
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
+		ret =3D ida_alloc_range(&dev->port_functions.ida, attrs->port_index,
+				      attrs->port_index, GFP_KERNEL);
+	else
+		ret =3D ida_alloc_min(&dev->port_functions.ida, nsim_bus_dev->port_count=
, GFP_KERNEL);
+	if (ret < 0)
+		goto port_ida_err;
+
+	port->port_index =3D ret;
+	port->controller =3D attrs->controller_valid ? attrs->controller : 0;
+
+	switch (port->flavour) {
+	case DEVLINK_PORT_FLAVOUR_PCI_PF:
+		ret =3D ida_alloc_range(&dev->port_functions.pfnum_ida, attrs->pfnum, at=
trs->pfnum,
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
+static void nsim_devlink_port_function_free(struct nsim_dev *dev, struct n=
sim_port_function *port)
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
+static bool nsim_dev_port_index_internal(struct nsim_dev *nsim_dev, unsign=
ed int port_index)
+{
+	struct nsim_bus_dev *nsim_bus_dev =3D nsim_dev->nsim_bus_dev;
+
+	return (port_index < nsim_bus_dev->port_count) ? true : false;
+}
+
+static bool
+nsim_dev_port_port_exists(struct nsim_dev *nsim_dev, const struct devlink_=
port_new_attrs *attrs)
+{
+	struct nsim_port_function *tmp;
+
+	list_for_each_entry(tmp, &nsim_dev->port_functions.head, list) {
+		if (attrs->port_index_valid && tmp->port_index =3D=3D attrs->port_index)
+			return true;
+		if (attrs->controller_valid && tmp->controller !=3D attrs->controller)
+			continue;
+		/* If controller is provided, and if the port is for a specific controll=
er,
+		 * skip them.
+		 */
+		if (!attrs->controller_valid && tmp->controller)
+			continue;
+
+		if (attrs->flavour =3D=3D DEVLINK_PORT_FLAVOUR_PCI_PF &&
+		    tmp->flavour =3D=3D DEVLINK_PORT_FLAVOUR_PCI_PF && tmp->pfnum =3D=3D=
 attrs->pfnum)
+			return true;
+	}
+	return false;
+}
+
+static struct nsim_port_function *
+nsim_dev_devlink_port_index_lookup(const struct nsim_dev *nsim_dev, unsign=
ed int port_index,
+				   struct netlink_ext_ack *extack)
+{
+	struct nsim_port_function *port;
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
+static int nsim_devlink_port_function_add(struct devlink *devlink, struct =
nsim_dev *nsim_dev,
+					  struct nsim_port_function *port,
+					  struct netlink_ext_ack *extack)
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
+static void nsim_devlink_port_function_del(struct nsim_dev *nsim_dev,
+					   struct nsim_port_function *port)
+{
+	devlink_port_type_clear(&port->dl_port);
+	unregister_netdev(port->netdev);
+	devlink_port_unregister(&port->dl_port);
+	list_del(&port->list);
+}
+
+static bool nsim_dev_port_flavour_supported(const struct nsim_dev *nsim_de=
v,
+					    const struct devlink_port_new_attrs *attrs)
+{
+	return attrs->flavour =3D=3D DEVLINK_PORT_FLAVOUR_PCI_PF;
+}
+
+int nsim_dev_devlink_port_new(struct devlink *devlink, const struct devlin=
k_port_new_attrs *attrs,
+			      struct netlink_ext_ack *extack)
+{
+	struct nsim_dev *nsim_dev =3D devlink_priv(devlink);
+	struct nsim_bus_dev *nsim_bus_dev;
+	struct nsim_port_function *port;
+	int err;
+
+	nsim_bus_dev =3D nsim_dev->nsim_bus_dev;
+	if (attrs->port_index_valid && attrs->port_index < nsim_bus_dev->port_cou=
nt) {
+		NL_SET_ERR_MSG_MOD(extack, "Port with given port index already exist");
+		return -EEXIST;
+	}
+	if (!nsim_dev_port_flavour_supported(nsim_dev, attrs)) {
+		NL_SET_ERR_MSG_MOD(extack, "Unsupported port flavour specified");
+		return -EOPNOTSUPP;
+	}
+	if (!nsim_dev_port_function_try_get(nsim_dev))
+		return -EPERM;
+	if (nsim_dev_port_port_exists(nsim_dev, attrs)) {
+		NL_SET_ERR_MSG_MOD(extack, "Port with given attributes already exists");
+		err =3D -EEXIST;
+		goto alloc_err;
+	}
+	port =3D nsim_devlink_port_function_alloc(nsim_dev, attrs);
+	if (IS_ERR(port)) {
+		NL_SET_ERR_MSG_MOD(extack, "Fail to allocate port");
+		err =3D PTR_ERR(port);
+		goto alloc_err;
+	}
+	memcpy(port->dl_port.attrs.switch_id.id, nsim_dev->switch_id.id,
+	       nsim_dev->switch_id.id_len);
+	port->dl_port.attrs.switch_id.id_len =3D nsim_dev->switch_id.id_len;
+
+	devlink_port_attrs_pci_pf_set(&port->dl_port, port->controller, port->pfn=
um, false);
+
+	err =3D nsim_devlink_port_function_add(devlink, nsim_dev, port, extack);
+	if (err)
+		goto add_err;
+
+	nsim_dev_port_function_put(nsim_dev);
+	return 0;
+
+add_err:
+	nsim_devlink_port_function_free(nsim_dev, port);
+alloc_err:
+	nsim_dev_port_function_put(nsim_dev);
+	return err;
+}
+
+int nsim_dev_devlink_port_del(struct devlink *devlink, unsigned int port_i=
ndex,
+			      struct netlink_ext_ack *extack)
+{
+	struct nsim_dev *nsim_dev =3D devlink_priv(devlink);
+	struct nsim_port_function *port;
+
+	if (nsim_dev_port_index_internal(nsim_dev, port_index)) {
+		NL_SET_ERR_MSG_MOD(extack, "Port index doesn't belong to user created po=
rt");
+		return -EINVAL;
+	}
+
+	if (!nsim_dev_port_function_try_get(nsim_dev))
+		return -EPERM;
+
+	port =3D nsim_dev_devlink_port_index_lookup(nsim_dev, port_index, extack)=
;
+	if (IS_ERR(port))
+		goto err;
+	nsim_devlink_port_function_del(nsim_dev, port);
+	nsim_devlink_port_function_free(nsim_dev, port);
+	nsim_dev_port_function_put(nsim_dev);
+	return 0;
+
+err:
+	nsim_dev_port_function_put(nsim_dev);
+	return PTR_ERR(port);
+}
+
+void nsim_dev_port_function_enable(struct nsim_dev *nsim_dev)
+{
+	init_completion(&nsim_dev->port_functions.disable_complete);
+	refcount_set(&nsim_dev->port_functions.refcount, 1);
+}
+
+void nsim_dev_port_function_disable(struct nsim_dev *nsim_dev)
+{
+	struct nsim_port_function *port;
+	struct nsim_port_function *tmp;
+
+	/* Balances with refcount_set(); drop the refcount so that
+	 * any new port new/del or port function get/set commands
+	 * cannot start.
+	 */
+	nsim_dev_port_function_put(nsim_dev);
+	/* Wait for any ongoing commands to complete. */
+	wait_for_completion(&nsim_dev->port_functions.disable_complete);
+
+	/* At this point, no new user commands can start and any ongoing
+	 * commands have completed, so it is safe to delete all user created
+	 * ports.
+	 */
+
+	list_for_each_entry_safe_reverse(port, tmp, &nsim_dev->port_functions.hea=
d, list) {
+		nsim_devlink_port_function_del(nsim_dev, port);
+		nsim_devlink_port_function_free(nsim_dev, port);
+	}
+}
--=20
2.26.2

