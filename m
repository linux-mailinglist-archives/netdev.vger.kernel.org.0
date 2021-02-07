Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 218F43122D4
	for <lists+netdev@lfdr.de>; Sun,  7 Feb 2021 09:45:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229631AbhBGIpM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Feb 2021 03:45:12 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:4341 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbhBGIpH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Feb 2021 03:45:07 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B601fa86b0000>; Sun, 07 Feb 2021 00:44:27 -0800
Received: from sw-mtx-036.mtx.labs.mlnx (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Sun, 7 Feb
 2021 08:44:26 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     Parav Pandit <parav@nvidia.com>, Jiri Pirko <jiri@nvidia.com>
Subject: [PATCH net-next v2 2/7] netdevsim: Add support for add and delete PCI SF port
Date:   Sun, 7 Feb 2021 10:44:07 +0200
Message-ID: <20210207084412.252259-3-parav@nvidia.com>
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
        t=1612687467; bh=USk+Ai2bvGhKmgDS3Of7pY4LSQ7WbOaICHX6RrCXhN8=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=NQTMXLii1gqAXYDY8ELIJFk75trjOuo6+HjwbfCDrD3j5g4omf9sGlLHXZs7uJ0hh
         4YpcGgsfCky5C1LEtllMAFnjAYwZ3EmRjlGkqY2kGQdGod8/+m0wV4bSXpaA4MxdVV
         0ahe5cEtcyLIg0EBy+uMPEuvTQx49lxw7ofldHc54Hl7qvhBX78whrsxHqBp/3X/3O
         0BOJH1Qcu91LoTyqbuAOKyOu8bzc3B2Fz5nPdxUab3paxWOFST6O4OhbQgq72U3ZMm
         cfw3Rt4ejy2LrAH8ePfYpwBf+CbaeK5XnFg4Ap8C+CZSze1e9z1t8nCzXyA9kNe++c
         VxdmSmP3qQoIA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simulate PCI SF ports. Allow user to create one or more PCI SF ports.

Examples:

echo "10 1" > /sys/bus/netdevsim/new_device

Add PCI PF port:
$ devlink port add netdevsim/netdevsim10 flavour pcipf pfnum 2
netdevsim/netdevsim10/1: type eth netdev eth1 flavour pcipf controller 0 pf=
num 2 external false splittable false

Add PCI SF port where port index and sfnum are auto assigned by driver.

$ devlink port add netdevsim/netdevsim10 flavour pcisf pfnum 2
netdevsim/netdevsim10/2: type eth netdev eth2 flavour pcisf controller 0 pf=
num 2 sfnum 0 splittable false

Show devlink ports:
$ devlink port show
netdevsim/netdevsim10/0: type eth netdev eth0 flavour physical port 1 split=
table false
netdevsim/netdevsim10/1: type eth netdev eth1 flavour pcipf controller 0 pf=
num 2 external false splittable false
netdevsim/netdevsim10/2: type eth netdev eth2 flavour pcisf controller 0 pf=
num 2 sfnum 0 splittable false

Create a PCI SF port whose port index and SF number are assigned by
the user.

$ devlink port add netdevsim/netdevsim10/66 flavour pcisf pfnum 2 sfnum 66
netdevsim/netdevsim10/66: type eth netdev eth3 flavour pcisf controller 0 p=
fnum 2 sfnum 66 splittable false

Delete PCI SF and PF ports:
$ devlink port del netdevsim/netdevsim10/66
$ devlink port del netdevsim/netdevsim10/2
$ devlink port del netdevsim/netdevsim10/1

Signed-off-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 drivers/net/netdevsim/netdevsim.h     |  1 +
 drivers/net/netdevsim/port_function.c | 99 ++++++++++++++++++++++++++-
 2 files changed, 97 insertions(+), 3 deletions(-)

diff --git a/drivers/net/netdevsim/netdevsim.h b/drivers/net/netdevsim/netd=
evsim.h
index 31beddede0f2..efa7c08d842a 100644
--- a/drivers/net/netdevsim/netdevsim.h
+++ b/drivers/net/netdevsim/netdevsim.h
@@ -233,6 +233,7 @@ struct nsim_dev {
 		struct list_head head;
 		struct ida ida;
 		struct ida pfnum_ida;
+		struct ida sfnum_ida;
 		struct mutex disable_mutex; /* protects port deletion
 					     * by driver unload context
 					     */
diff --git a/drivers/net/netdevsim/port_function.c b/drivers/net/netdevsim/=
port_function.c
index 7df1ca5ad7b8..86607d574930 100644
--- a/drivers/net/netdevsim/port_function.c
+++ b/drivers/net/netdevsim/port_function.c
@@ -9,9 +9,12 @@
 struct nsim_port_fn {
 	struct devlink_port dl_port;
 	struct net_device *netdev;
+	struct nsim_port_fn *pf_pfn;
 	struct list_head list;
 	unsigned int port_index;
 	enum devlink_port_flavour flavour;
+	int refcount; /* Counts how many sf ports are bound attached to this pf p=
ort. */
+	u32 sfnum;
 	u16 pfnum;
 };
=20
@@ -91,9 +94,24 @@ nsim_devlink_port_fn_alloc(struct nsim_dev *dev,
 			goto fn_ida_err;
 		port->pfnum =3D ret;
 		break;
+	case DEVLINK_PORT_FLAVOUR_PCI_SF:
+		if (attrs->sfnum_valid)
+			ret =3D ida_alloc_range(&dev->port_functions.sfnum_ida, attrs->sfnum,
+					      attrs->sfnum, GFP_KERNEL);
+		else
+			ret =3D ida_alloc(&dev->port_functions.sfnum_ida, GFP_KERNEL);
+		if (ret < 0)
+			goto fn_ida_err;
+		port->sfnum =3D ret;
+		port->pfnum =3D attrs->pfnum;
+		break;
 	default:
 		break;
 	}
+	/* refcount_t is not needed as port is protected by port_functions.mutex.
+	 * This count is to keep track of how many SF ports are attached a PF por=
t.
+	 */
+	port->refcount =3D 1;
 	return port;
=20
 fn_ida_err:
@@ -110,6 +128,9 @@ nsim_devlink_port_fn_free(struct nsim_dev *dev, struct =
nsim_port_fn *port)
 	case DEVLINK_PORT_FLAVOUR_PCI_PF:
 		ida_simple_remove(&dev->port_functions.pfnum_ida, port->pfnum);
 		break;
+	case DEVLINK_PORT_FLAVOUR_PCI_SF:
+		ida_simple_remove(&dev->port_functions.sfnum_ida, port->sfnum);
+		break;
 	default:
 		break;
 	}
@@ -139,6 +160,12 @@ nsim_dev_port_port_exists(struct nsim_dev *nsim_dev,
 		    tmp->flavour =3D=3D DEVLINK_PORT_FLAVOUR_PCI_PF &&
 		    tmp->pfnum =3D=3D attrs->pfnum)
 			return true;
+
+		if (attrs->flavour =3D=3D DEVLINK_PORT_FLAVOUR_PCI_SF &&
+		    tmp->flavour =3D=3D DEVLINK_PORT_FLAVOUR_PCI_SF &&
+		    attrs->sfnum_valid &&
+		    tmp->sfnum =3D=3D attrs->sfnum && tmp->pfnum =3D=3D attrs->pfnum)
+			return true;
 	}
 	return false;
 }
@@ -153,20 +180,72 @@ nsim_dev_devlink_port_index_lookup(const struct nsim_=
dev *nsim_dev,
 	list_for_each_entry(port, &nsim_dev->port_functions.head, list) {
 		if (port->port_index !=3D port_index)
 			continue;
+		if (port->refcount > 1) {
+			NL_SET_ERR_MSG_MOD(extack, "Port is in use");
+			return ERR_PTR(-EBUSY);
+		}
 		return port;
 	}
 	NL_SET_ERR_MSG_MOD(extack, "User created port not found");
 	return ERR_PTR(-ENOENT);
 }
=20
+static struct nsim_port_fn *
+pf_port_get(struct nsim_dev *nsim_dev, struct nsim_port_fn *port)
+{
+	struct nsim_port_fn *tmp;
+
+	/* PF port addition doesn't need a parent. */
+	if (port->flavour =3D=3D DEVLINK_PORT_FLAVOUR_PCI_PF)
+		return NULL;
+
+	list_for_each_entry(tmp, &nsim_dev->port_functions.head, list) {
+		if (tmp->flavour !=3D DEVLINK_PORT_FLAVOUR_PCI_PF ||
+		    tmp->pfnum !=3D port->pfnum)
+			continue;
+
+		if (tmp->refcount + 1 =3D=3D INT_MAX)
+			return ERR_PTR(-ENOSPC);
+
+		port->pf_pfn =3D tmp;
+		tmp->refcount++;
+		return tmp;
+	}
+	return ERR_PTR(-ENOENT);
+}
+
+static void pf_port_put(struct nsim_port_fn *port)
+{
+	if (port->pf_pfn) {
+		port->pf_pfn->refcount--;
+		WARN_ON(port->pf_pfn->refcount < 0);
+	}
+	port->refcount--;
+	WARN_ON(port->refcount !=3D 0);
+}
+
 static int nsim_devlink_port_fn_add(struct devlink *devlink,
 				    struct nsim_dev *nsim_dev,
 				    struct nsim_port_fn *port,
 				    struct netlink_ext_ack *extack)
 {
+	struct nsim_port_fn *pf_pfn;
 	int err;
=20
-	list_add(&port->list, &nsim_dev->port_functions.head);
+	/* Keep all PF ports at the start, so that when driver is unloaded
+	 * All SF ports from the end of the list can be removed first.
+	 */
+	if (port->flavour =3D=3D DEVLINK_PORT_FLAVOUR_PCI_PF)
+		list_add(&port->list, &nsim_dev->port_functions.head);
+	else
+		list_add_tail(&port->list, &nsim_dev->port_functions.head);
+
+	pf_pfn =3D pf_port_get(nsim_dev, port);
+	if (IS_ERR(pf_pfn)) {
+		NL_SET_ERR_MSG_MOD(extack, "Fail to get pf port");
+		err =3D PTR_ERR(pf_pfn);
+		goto pf_err;
+	}
=20
 	err =3D devlink_port_register(devlink, &port->dl_port, port->port_index);
 	if (err)
@@ -183,6 +262,8 @@ static int nsim_devlink_port_fn_add(struct devlink *dev=
link,
 	devlink_port_type_clear(&port->dl_port);
 	devlink_port_unregister(&port->dl_port);
 reg_err:
+	pf_port_put(port);
+pf_err:
 	list_del(&port->list);
 	return err;
 }
@@ -194,13 +275,15 @@ static void nsim_devlink_port_fn_del(struct nsim_dev =
*nsim_dev,
 	unregister_netdev(port->netdev);
 	devlink_port_unregister(&port->dl_port);
 	list_del(&port->list);
+	pf_port_put(port);
 }
=20
 static bool
 nsim_dev_port_flavour_supported(const struct nsim_dev *nsim_dev,
 				const struct devlink_port_new_attrs *attrs)
 {
-	return attrs->flavour =3D=3D DEVLINK_PORT_FLAVOUR_PCI_PF;
+	return attrs->flavour =3D=3D DEVLINK_PORT_FLAVOUR_PCI_PF ||
+	       attrs->flavour =3D=3D DEVLINK_PORT_FLAVOUR_PCI_SF;
 }
=20
 int nsim_dev_devlink_port_new(struct devlink *devlink,
@@ -245,7 +328,12 @@ int nsim_dev_devlink_port_new(struct devlink *devlink,
 	       nsim_dev->switch_id.id_len);
 	port->dl_port.attrs.switch_id.id_len =3D nsim_dev->switch_id.id_len;
=20
-	devlink_port_attrs_pci_pf_set(&port->dl_port, 0, port->pfnum, false);
+	if (attrs->flavour =3D=3D DEVLINK_PORT_FLAVOUR_PCI_PF)
+		devlink_port_attrs_pci_pf_set(&port->dl_port, 0,
+					      port->pfnum, false);
+	else
+		devlink_port_attrs_pci_sf_set(&port->dl_port, 0, port->pfnum,
+					      port->sfnum);
=20
 	err =3D nsim_devlink_port_fn_add(devlink, nsim_dev, port, extack);
 	if (err)
@@ -300,10 +388,13 @@ void nsim_dev_port_fn_init(struct nsim_dev *nsim_dev)
 	INIT_LIST_HEAD(&nsim_dev->port_functions.head);
 	ida_init(&nsim_dev->port_functions.ida);
 	ida_init(&nsim_dev->port_functions.pfnum_ida);
+	ida_init(&nsim_dev->port_functions.sfnum_ida);
 }
=20
 void nsim_dev_port_fn_exit(struct nsim_dev *nsim_dev)
 {
+	WARN_ON(!ida_is_empty(&nsim_dev->port_functions.sfnum_ida));
+	ida_destroy(&nsim_dev->port_functions.sfnum_ida);
 	WARN_ON(!ida_is_empty(&nsim_dev->port_functions.pfnum_ida));
 	ida_destroy(&nsim_dev->port_functions.pfnum_ida);
 	WARN_ON(!ida_is_empty(&nsim_dev->port_functions.ida));
@@ -332,6 +423,8 @@ void nsim_dev_port_fn_disable(struct nsim_dev *nsim_dev=
)
 	 * commands have completed, so it is safe to delete all user created
 	 * ports.
 	 */
+
+	/* Remove SF ports first, followed by PF ports. */
 	list_for_each_entry_safe_reverse(port, tmp,
 					 &nsim_dev->port_functions.head, list) {
 		nsim_devlink_port_fn_del(nsim_dev, port);
--=20
2.26.2

