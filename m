Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84BFB2B0DE7
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 20:25:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726610AbgKLTZE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 14:25:04 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:11377 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726930AbgKLTZB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 14:25:01 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fad8c150000>; Thu, 12 Nov 2020 11:25:09 -0800
Received: from sw-mtx-036.mtx.labs.mlnx (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 12 Nov
 2020 19:25:00 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <gregkh@linuxfoundation.org>
CC:     <jiri@nvidia.com>, <jgg@nvidia.com>, <dledford@redhat.com>,
        <leonro@nvidia.com>, <saeedm@nvidia.com>, <kuba@kernel.org>,
        <davem@davemloft.net>, Parav Pandit <parav@nvidia.com>,
        Vu Pham <vuhuong@nvidia.com>
Subject: [PATCH net-next 13/13] net/mlx5: SF, Port function state change support
Date:   Thu, 12 Nov 2020 21:24:23 +0200
Message-ID: <20201112192424.2742-14-parav@nvidia.com>
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
        t=1605209109; bh=BPkdJ1ifA/bO+m9fBGi+nxds8HnjhAL3G/KQIhHvcAk=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=OZk/cVCJmKcI2fb+0Z1Zi/h9ZLrga56KrZ1PPsPA/XOoZquIfCXKE3Yb89P4C+3Sj
         rvdYa/mgRK0gJTLj7pKFgL6tNhQvIcOkYm4f5W1m1w6GjD4zpDOoHTubxSgrxohRVG
         A0kmfjVR0TYRR+37fx93TK2GApcAXIHPs6My0knGuYne0okLUMkT5b9LG2LzRTkCLb
         xjI+GrOZ7J/f2YaD9Q/X9YdEUkygeEWfA00HFIcXUWsk0sKnehWtg79xc5jKwgvSpA
         +JaWRtdJ/z3g8IzTK2d7qEYcFqWPbVo+ocW0Sw2pE2lzNUhWRBgGM7IjdsS9SoH02G
         1g4oaVJdekcdg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Support changing the state of the SF port's function through devlink.
When activating the SF port's function, enable the hca in the device
followed by adding its auxiliary device.
When deactivating the SF port's function, delete its auxiliary device
followed by disabling the HCA.

Port function attributes get/set callbacks are invoked with devlink
instance lock held. Such callbacks need to synchronize with sf port
table getting disabled. These callbacks while operating on the devlink
port, synchronize with table disable context by holding table refcount.

$ devlink dev eswitch set pci/0000:06:00.0 mode switchdev

$ devlink port show
pci/0000:06:00.0/65535: type eth netdev ens2f0np0 flavour physical port 0 s=
plittable false

$ devlink port add pci/0000:06:00.0 flavour pcisf pfnum 0 sfnum 88

$ devlink port show ens2f0npf0sf88
pci/0000:06:00.0/32768: type eth netdev ens2f0npf0sf88 flavour pcisf contro=
ller 0 pfnum 0 sfnum 88 external false splittable false
  function:
    hw_addr 00:00:00:00:88:88 state inactive opstate detached

$ devlink port function set pci/0000:06:00.0/32768 hw_addr 00:00:00:00:88:8=
8 state active

$ devlink port show ens2f0npf0sf88 -jp
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

On port function activation, an auxiliary device is created in below
example.

$ devlink dev show
devlink dev show auxiliary/mlx5_core.sf.0

$ devlink port show auxiliary/mlx5_core.sf.0/1
auxiliary/mlx5_core.sf.0/1: type eth netdev p0sf88 flavour virtual port 0 s=
plittable false

Signed-off-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Vu Pham <vuhuong@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/devlink.c |   2 +
 .../net/ethernet/mellanox/mlx5/core/sf/sf.c   | 128 ++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/sf/sf.h   |   7 +
 3 files changed, 137 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/devlink.c
index 7ad8dc26cb74..22d22959e6f6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -192,6 +192,8 @@ static const struct devlink_ops mlx5_devlink_ops =3D {
 #ifdef CONFIG_MLX5_SF_MANAGER
 	.port_new =3D mlx5_devlink_sf_port_new,
 	.port_del =3D mlx5_devlink_sf_port_del,
+	.port_function_state_get =3D mlx5_devlink_sf_port_fn_state_get,
+	.port_function_state_set =3D mlx5_devlink_sf_port_fn_state_set,
 #endif
 	.flash_update =3D mlx5_devlink_flash_update,
 	.info_get =3D mlx5_devlink_info_get,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/sf.c b/drivers/net/=
ethernet/mellanox/mlx5/core/sf/sf.c
index dff44ab5057d..7e90629fd910 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sf/sf.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/sf.c
@@ -4,6 +4,7 @@
 #include <linux/mlx5/driver.h>
 #include "eswitch.h"
 #include "priv.h"
+#include "sf/dev/dev.h"
=20
 struct mlx5_sf {
 	struct devlink_port dl_port;
@@ -11,6 +12,7 @@ struct mlx5_sf {
 	u32 usr_sfnum;
 	u16 sw_id;
 	u16 hw_fn_id;
+	enum devlink_port_function_state state;
 };
=20
 struct mlx5_sf_table {
@@ -115,6 +117,7 @@ mlx5_sf_alloc(struct mlx5_sf_table *table, u32 sfnum, s=
truct netlink_ext_ack *ex
 	if (err)
 		goto id_err;
=20
+	sf->state =3D DEVLINK_PORT_FUNCTION_STATE_INACTIVE;
 	dl_port_index =3D mlx5_esw_vport_to_devlink_port_index(table->dev, sf->hw=
_fn_id);
 	sf->port_index =3D dl_port_index;
 	sf->usr_sfnum =3D sfnum;
@@ -156,6 +159,126 @@ static void mlx5_sf_table_put(struct mlx5_sf_table *t=
able)
 		complete(&table->disable_complete);
 }
=20
+static int
+mlx5_sf_state_get(struct mlx5_core_dev *dev, struct mlx5_sf *sf,
+		  enum devlink_port_function_state *state,
+		  enum devlink_port_function_opstate *opstate)
+{
+	int err =3D 0;
+
+	*state =3D sf->state;
+	switch (sf->state) {
+	case DEVLINK_PORT_FUNCTION_STATE_ACTIVE:
+		*opstate =3D DEVLINK_PORT_FUNCTION_OPSTATE_ATTACHED;
+		break;
+	case DEVLINK_PORT_FUNCTION_STATE_INACTIVE:
+		*opstate =3D DEVLINK_PORT_FUNCTION_OPSTATE_DETACHED;
+		break;
+	default:
+		err =3D -EINVAL;
+		break;
+	}
+	return err;
+}
+
+int mlx5_devlink_sf_port_fn_state_get(struct devlink *devlink, struct devl=
ink_port *dl_port,
+				      enum devlink_port_function_state *state,
+				      enum devlink_port_function_opstate *opstate,
+				      struct netlink_ext_ack *extack)
+{
+	struct mlx5_core_dev *dev =3D devlink_priv(devlink);
+	struct mlx5_sf_table *table;
+	int err =3D -EOPNOTSUPP;
+	struct mlx5_sf *sf;
+
+	table =3D mlx5_sf_table_try_get(dev);
+	if (!table)
+		return -EOPNOTSUPP;
+
+	sf =3D mlx5_sf_lookup_by_index(table, dl_port->index);
+	if (!sf)
+		goto sf_err;
+	err =3D mlx5_sf_state_get(dev, sf, state, opstate);
+sf_err:
+	mlx5_sf_table_put(table);
+	return err;
+}
+
+static int mlx5_sf_activate(struct mlx5_core_dev *dev, struct mlx5_sf *sf)
+{
+	int err;
+
+	err =3D mlx5_cmd_sf_enable_hca(dev, sf->hw_fn_id);
+	if (err)
+		return err;
+
+	err =3D mlx5_sf_dev_add(dev, sf->sw_id, sf->usr_sfnum);
+	if (err)
+		goto dev_err;
+
+	sf->state =3D DEVLINK_PORT_FUNCTION_STATE_ACTIVE;
+	return 0;
+
+dev_err:
+	mlx5_cmd_sf_disable_hca(dev, sf->hw_fn_id);
+	return err;
+}
+
+static int mlx5_sf_deactivate(struct mlx5_core_dev *dev, struct mlx5_sf *s=
f)
+{
+	int err;
+
+	mlx5_sf_dev_del(dev, sf->sw_id);
+	err =3D mlx5_cmd_sf_disable_hca(dev, sf->hw_fn_id);
+	if (err)
+		return err;
+	sf->state =3D DEVLINK_PORT_FUNCTION_STATE_INACTIVE;
+	return 0;
+}
+
+static int mlx5_sf_state_set(struct mlx5_core_dev *dev, struct mlx5_sf *sf=
,
+			     enum devlink_port_function_state state)
+{
+	int err;
+
+	if (sf->state =3D=3D state)
+		return 0;
+	if (state =3D=3D DEVLINK_PORT_FUNCTION_STATE_ACTIVE)
+		err =3D mlx5_sf_activate(dev, sf);
+	else if (state =3D=3D DEVLINK_PORT_FUNCTION_STATE_INACTIVE)
+		err =3D mlx5_sf_deactivate(dev, sf);
+	else
+		err =3D -EINVAL;
+	return err;
+}
+
+int mlx5_devlink_sf_port_fn_state_set(struct devlink *devlink, struct devl=
ink_port *dl_port,
+				      enum devlink_port_function_state state,
+				      struct netlink_ext_ack *extack)
+{
+	struct mlx5_core_dev *dev =3D devlink_priv(devlink);
+	struct mlx5_sf_table *table;
+	struct mlx5_sf *sf;
+	int err;
+
+	table =3D mlx5_sf_table_try_get(dev);
+	if (!table) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Port state set is only supported in eswitch switchdev mode or SF p=
orts are disabled.");
+		return -EOPNOTSUPP;
+	}
+	sf =3D mlx5_sf_lookup_by_index(table, dl_port->index);
+	if (!sf) {
+		err =3D -ENODEV;
+		goto out;
+	}
+
+	err =3D mlx5_sf_state_set(dev, sf, state);
+out:
+	mlx5_sf_table_put(table);
+	return err;
+}
+
 static int mlx5_sf_add(struct mlx5_core_dev *dev, struct mlx5_sf_table *ta=
ble,
 		       const struct devlink_port_new_attrs *new_attr,
 		       struct netlink_ext_ack *extack)
@@ -184,6 +307,10 @@ static void mlx5_sf_del(struct mlx5_core_dev *dev, str=
uct mlx5_sf_table *table,
 {
 	struct mlx5_eswitch *esw =3D dev->priv.eswitch;
=20
+	if (sf->state =3D=3D DEVLINK_PORT_FUNCTION_STATE_ACTIVE) {
+		mlx5_sf_dev_del(dev, sf->sw_id);
+		mlx5_cmd_sf_disable_hca(dev, sf->hw_fn_id);
+	}
 	mlx5_esw_offloads_sf_vport_disable(esw, sf->hw_fn_id);
 	mlx5_sf_free(table, sf);
 }
@@ -343,6 +470,7 @@ int mlx5_sf_table_init(struct mlx5_core_dev *dev)
=20
 	table->dev =3D dev;
 	ida_init(&table->fn_ida);
+	refcount_set(&table->refcount, 0);
 	dev->priv.sf_table =3D table;
 	table->esw_nb.notifier_call =3D mlx5_sf_esw_event;
 	err =3D mlx5_esw_event_notifier_register(dev->priv.eswitch, &table->esw_n=
b);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/sf.h b/drivers/net/=
ethernet/mellanox/mlx5/core/sf/sf.h
index 555b19a5880d..3d1c459b9936 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sf/sf.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/sf.h
@@ -25,6 +25,13 @@ int mlx5_devlink_sf_port_new(struct devlink *devlink, co=
nst struct devlink_port_
 			     struct netlink_ext_ack *extack);
 int mlx5_devlink_sf_port_del(struct devlink *devlink, unsigned int port_in=
dex,
 			     struct netlink_ext_ack *extack);
+int mlx5_devlink_sf_port_fn_state_get(struct devlink *devlink, struct devl=
ink_port *dl_port,
+				      enum devlink_port_function_state *state,
+				      enum devlink_port_function_opstate *opstate,
+				      struct netlink_ext_ack *extack);
+int mlx5_devlink_sf_port_fn_state_set(struct devlink *devlink, struct devl=
ink_port *dl_port,
+				      enum devlink_port_function_state state,
+				      struct netlink_ext_ack *extack);
=20
 #else
=20
--=20
2.26.2

