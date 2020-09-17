Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB81126E238
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 19:22:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726514AbgIQRWX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 13:22:23 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:4967 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726470AbgIQRUt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 13:20:49 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f639abb0001>; Thu, 17 Sep 2020 10:19:55 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Thu, 17 Sep 2020 10:20:39 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Thu, 17 Sep 2020 10:20:39 -0700
Received: from sw-mtx-036.mtx.labs.mlnx (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 17 Sep
 2020 17:20:38 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     Parav Pandit <parav@nvidia.com>, Jiri Pirko <jiri@nvidia.com>
Subject: [PATCH net-next v2 8/8] netdevsim: Add support for add and delete PCI SF port
Date:   Thu, 17 Sep 2020 20:20:20 +0300
Message-ID: <20200917172020.26484-9-parav@nvidia.com>
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
        t=1600363195; bh=/AiavoDGmWDAXWAOOXL6PjYKYzFMPXnr8WU9tXlwyUI=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:
         Content-Type:X-Originating-IP:X-ClientProxiedBy;
        b=AIcJJbWqaDwmilJtlDkz7F+oGHAUvf5J4d8IrgYHJvv3+q/xHx7ekGZ3bbOnFBGBP
         xl/WrStHi7UFcOUxVt3JpZN4oJF0uSRkJPLgkO/5ndBu/7eFgHZfrZpCoReKkUMCzK
         0m1jEhs19im20eajtyFFypzWyckPuRMajC8j0QetCwzSsksrHxsXEbS7ohJIKOnfXh
         8lZFBA2y3/LDluvE05NGiolTBsw6neneqAXwjoGH1iz6WFaErZt4EgewTJq7XMY9/I
         h6tzHYg6bZQppjZIxnusrloJGm6wZtIGz1FT7NN2704UmmS1suOlvDpZ1SxJG3H4qU
         67PG50+hcxeog==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simulate PCI SF ports. Allow user to create one or more PCI SF ports.

Examples:

Create a PCI PF and PCI SF port.
$ devlink port add netdevsim/netdevsim10/10 flavour pcipf pfnum 0
$ devlink port add netdevsim/netdevsim10/11 flavour pcisf pfnum 0 sfnum 44
$ devlink port show netdevsim/netdevsim10/11
netdevsim/netdevsim10/11: type eth netdev eni10npf0sf44 flavour pcisf contr=
oller 0 pfnum 0 sfnum 44 external true splittable false
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
            "external": true,
            "splittable": false,
            "function": {
                "hw_addr": "00:11:22:33:44:55",
                "state": "active"
            }
        }
    }
}

Delete newly added devlink port
$ devlink port add netdevsim/netdevsim10/11

Add devlink port of flavour 'pcisf' where port index and sfnum are
auto assigned by driver.
$ devlink port add netdevsim/netdevsim10 flavour pcisf controller 0 pfnum 0

Signed-off-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 drivers/net/netdevsim/netdevsim.h     |  1 +
 drivers/net/netdevsim/port_function.c | 95 +++++++++++++++++++++++++--
 2 files changed, 92 insertions(+), 4 deletions(-)

diff --git a/drivers/net/netdevsim/netdevsim.h b/drivers/net/netdevsim/netd=
evsim.h
index 0ea9705eda38..c70782e444d5 100644
--- a/drivers/net/netdevsim/netdevsim.h
+++ b/drivers/net/netdevsim/netdevsim.h
@@ -222,6 +222,7 @@ struct nsim_dev {
 		struct list_head head;
 		struct ida ida;
 		struct ida pfnum_ida;
+		struct ida sfnum_ida;
 	} port_functions;
 };
=20
diff --git a/drivers/net/netdevsim/port_function.c b/drivers/net/netdevsim/=
port_function.c
index 99581d3d15fe..e1812acd55b4 100644
--- a/drivers/net/netdevsim/port_function.c
+++ b/drivers/net/netdevsim/port_function.c
@@ -13,10 +13,12 @@ struct nsim_port_function {
 	unsigned int port_index;
 	enum devlink_port_flavour flavour;
 	u32 controller;
+	u32 sfnum;
 	u16 pfnum;
 	struct nsim_port_function *pf_port; /* Valid only for SF port */
 	u8 hw_addr[ETH_ALEN];
 	u8 state; /* enum devlink_port_function_state */
+	int refcount; /* Counts how many sf ports are bound attached to this pf p=
ort. */
 };
=20
 void nsim_dev_port_function_init(struct nsim_dev *nsim_dev)
@@ -25,10 +27,13 @@ void nsim_dev_port_function_init(struct nsim_dev *nsim_=
dev)
 	INIT_LIST_HEAD(&nsim_dev->port_functions.head);
 	ida_init(&nsim_dev->port_functions.ida);
 	ida_init(&nsim_dev->port_functions.pfnum_ida);
+	ida_init(&nsim_dev->port_functions.sfnum_ida);
 }
=20
 void nsim_dev_port_function_exit(struct nsim_dev *nsim_dev)
 {
+	WARN_ON(!ida_is_empty(&nsim_dev->port_functions.sfnum_ida));
+	ida_destroy(&nsim_dev->port_functions.sfnum_ida);
 	WARN_ON(!ida_is_empty(&nsim_dev->port_functions.pfnum_ida));
 	ida_destroy(&nsim_dev->port_functions.pfnum_ida);
 	WARN_ON(!ida_is_empty(&nsim_dev->port_functions.ida));
@@ -119,9 +124,24 @@ nsim_devlink_port_function_alloc(struct nsim_dev *dev,=
 const struct devlink_port
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
@@ -137,6 +157,9 @@ static void nsim_devlink_port_function_free(struct nsim=
_dev *dev, struct nsim_po
 	case DEVLINK_PORT_FLAVOUR_PCI_PF:
 		ida_simple_remove(&dev->port_functions.pfnum_ida, port->pfnum);
 		break;
+	case DEVLINK_PORT_FLAVOUR_PCI_SF:
+		ida_simple_remove(&dev->port_functions.sfnum_ida, port->sfnum);
+		break;
 	default:
 		break;
 	}
@@ -170,6 +193,11 @@ nsim_dev_port_port_exists(struct nsim_dev *nsim_dev, c=
onst struct devlink_port_n
 		if (attrs->flavour =3D=3D DEVLINK_PORT_FLAVOUR_PCI_PF &&
 		    tmp->flavour =3D=3D DEVLINK_PORT_FLAVOUR_PCI_PF && tmp->pfnum =3D=3D=
 attrs->pfnum)
 			return true;
+
+		if (attrs->flavour =3D=3D DEVLINK_PORT_FLAVOUR_PCI_SF &&
+		    tmp->flavour =3D=3D DEVLINK_PORT_FLAVOUR_PCI_SF &&
+		    tmp->sfnum =3D=3D attrs->sfnum && tmp->pfnum =3D=3D attrs->pfnum)
+			return true;
 	}
 	return false;
 }
@@ -183,21 +211,71 @@ nsim_dev_devlink_port_index_lookup(const struct nsim_=
dev *nsim_dev, unsigned int
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
+static struct nsim_port_function *
+pf_port_get(struct nsim_dev *nsim_dev, struct nsim_port_function *port)
+{
+	struct nsim_port_function *tmp;
+
+	/* PF port addition doesn't need a parent. */
+	if (port->flavour =3D=3D DEVLINK_PORT_FLAVOUR_PCI_PF)
+		return NULL;
+
+	list_for_each_entry(tmp, &nsim_dev->port_functions.head, list) {
+		if (tmp->flavour !=3D DEVLINK_PORT_FLAVOUR_PCI_PF || tmp->pfnum !=3D por=
t->pfnum)
+			continue;
+
+		if (tmp->refcount + 1 =3D=3D INT_MAX)
+			return ERR_PTR(-ENOSPC);
+
+		port->pf_port =3D tmp;
+		tmp->refcount++;
+		return tmp;
+	}
+	return ERR_PTR(-ENOENT);
+}
+
+static void pf_port_put(struct nsim_port_function *port)
+{
+	if (port->pf_port) {
+		port->pf_port->refcount--;
+		WARN_ON(port->pf_port->refcount < 0);
+	}
+	port->refcount--;
+	WARN_ON(port->refcount !=3D 0);
+}
+
 static int nsim_devlink_port_function_add(struct devlink *devlink, struct =
nsim_dev *nsim_dev,
 					  struct nsim_port_function *port,
 					  struct netlink_ext_ack *extack)
 {
+	struct nsim_port_function *pf_port;
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
+	pf_port =3D pf_port_get(nsim_dev, port);
+	if (IS_ERR(pf_port)) {
+		NL_SET_ERR_MSG_MOD(extack, "Fail to get pf port");
+		err =3D PTR_ERR(pf_port);
+		goto pf_err;
+	}
=20
-	port->state =3D DEVLINK_PORT_FUNCTION_STATE_INACTIVE;
 	err =3D devlink_port_register(devlink, &port->dl_port, port->port_index);
 	if (err)
 		goto reg_err;
@@ -213,6 +291,8 @@ static int nsim_devlink_port_function_add(struct devlin=
k *devlink, struct nsim_d
 	devlink_port_type_clear(&port->dl_port);
 	devlink_port_unregister(&port->dl_port);
 reg_err:
+	pf_port_put(port);
+pf_err:
 	list_del(&port->list);
 	return err;
 }
@@ -224,12 +304,14 @@ static void nsim_devlink_port_function_del(struct nsi=
m_dev *nsim_dev,
 	unregister_netdev(port->netdev);
 	devlink_port_unregister(&port->dl_port);
 	list_del(&port->list);
+	pf_port_put(port);
 }
=20
 static bool nsim_dev_port_flavour_supported(const struct nsim_dev *nsim_de=
v,
 					    const struct devlink_port_new_attrs *attrs)
 {
-	return attrs->flavour =3D=3D DEVLINK_PORT_FLAVOUR_PCI_PF;
+	return attrs->flavour =3D=3D DEVLINK_PORT_FLAVOUR_PCI_PF ||
+	       attrs->flavour =3D=3D DEVLINK_PORT_FLAVOUR_PCI_SF;
 }
=20
 int nsim_dev_devlink_port_new(struct devlink *devlink, const struct devlin=
k_port_new_attrs *attrs,
@@ -266,7 +348,11 @@ int nsim_dev_devlink_port_new(struct devlink *devlink,=
 const struct devlink_port
 	       nsim_dev->switch_id.id_len);
 	port->dl_port.attrs.switch_id.id_len =3D nsim_dev->switch_id.id_len;
=20
-	devlink_port_attrs_pci_pf_set(&port->dl_port, port->controller, port->pfn=
um, false);
+	if (attrs->flavour =3D=3D DEVLINK_PORT_FLAVOUR_PCI_PF)
+		devlink_port_attrs_pci_pf_set(&port->dl_port, port->controller, port->pf=
num, false);
+	else
+		devlink_port_attrs_pci_sf_set(&port->dl_port, port->controller, port->pf=
num,
+					      port->sfnum, false);
=20
 	err =3D nsim_devlink_port_function_add(devlink, nsim_dev, port, extack);
 	if (err)
@@ -333,6 +419,7 @@ void nsim_dev_port_function_disable(struct nsim_dev *ns=
im_dev)
 	 * ports.
 	 */
=20
+	/* Remove SF ports first, followed by PF ports. */
 	list_for_each_entry_safe_reverse(port, tmp, &nsim_dev->port_functions.hea=
d, list) {
 		nsim_devlink_port_function_del(nsim_dev, port);
 		nsim_devlink_port_function_free(nsim_dev, port);
--=20
2.26.2

