Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E69F26E24C
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 19:25:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726472AbgIQRZp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 13:25:45 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:19696 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726467AbgIQRUp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 13:20:45 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f639ad90000>; Thu, 17 Sep 2020 10:20:25 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Thu, 17 Sep 2020 10:20:38 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Thu, 17 Sep 2020 10:20:38 -0700
Received: from sw-mtx-036.mtx.labs.mlnx (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 17 Sep
 2020 17:20:37 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     Parav Pandit <parav@nvidia.com>, Jiri Pirko <jiri@nvidia.com>
Subject: [PATCH net-next v2 7/8] netdevsim: Simulate port function state for a PCI port
Date:   Thu, 17 Sep 2020 20:20:19 +0300
Message-ID: <20200917172020.26484-8-parav@nvidia.com>
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
        t=1600363225; bh=7zbtMksJlUe+QCzGhSuPP6d3NskPns7dL9cfZ814AGo=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:
         Content-Type:X-Originating-IP:X-ClientProxiedBy;
        b=fsDfLpvBvfpBW2Sp9Et/t/SnbQ5vavW/fq301ZDUbUBIuRcKrteycgU4IzTNvWROF
         lTc/gV7/qNlYr75vgGnvm1FG7EnwaysM3D/X0W79fhAdd4Zl87CAh5fjok2MJp8ZWq
         2XF8X+30SqNsa4huoeh9GJTH0ZQIqR7S0iv+S2AB5xJ8O9O6LYB5NUdgW0ubd945ev
         mdEfldmV+GkysAGrAVPY7fu/G1TbydOXmJAEnVpu4cNRH1+odGsbcPgjdyBeMfMHQL
         WEENfcmM/H5f21s1Wf7/berWhMFpgq/hap44bf3pJ0Fz54kaowtpLFazyCgNQhXfmm
         x4aBW9KhO+2fg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simulate port function state of a PCI port.
This enables users to get and set the state of the PCI port function.

Example of a PCI SF port which supports a port function:
Create a device with ID=3D10 and one physical port.
$ echo "10 1" > /sys/bus/netdevsim/new_device

$ devlink port add netdevsim/netdevsim10/10 flavour pcipf pfnum 0
$ devlink port function set netdevsim/netdevsim10/10 hw_addr 00:11:22:33:44=
:55 state active

$ devlink port show netdevsim/netdevsim10/10
netdevsim/netdevsim10/10: type eth netdev eni10npf0 flavour pcipf controlle=
r 0 pfnum 0 external true splittable false
  function:
    hw_addr 00:00:00:00:00:00 state inactive

$ devlink port function set netdevsim/netdevsim10/10 hw_addr 00:11:22:33:44=
:55 state active

$ devlink port show  netdevsim/netdevsim10/10 -jp
{
    "port": {
        "netdevsim/netdevsim10/10": {
            "type": "eth",
            "netdev": "eni10npf0",
            "flavour": "pcipf",
            "controller": 0,
            "pfnum": 0,
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
 drivers/net/netdevsim/dev.c           |  2 ++
 drivers/net/netdevsim/netdevsim.h     |  6 ++++++
 drivers/net/netdevsim/port_function.c | 30 +++++++++++++++++++++++++++
 3 files changed, 38 insertions(+)

diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index ef2e293f358b..ec1e5dc74be1 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -888,6 +888,8 @@ static const struct devlink_ops nsim_dev_devlink_ops =
=3D {
 	.port_del =3D nsim_dev_devlink_port_del,
 	.port_function_hw_addr_get =3D nsim_dev_port_function_hw_addr_get,
 	.port_function_hw_addr_set =3D nsim_dev_port_function_hw_addr_set,
+	.port_function_state_get =3D nsim_dev_port_function_state_get,
+	.port_function_state_set =3D nsim_dev_port_function_state_set,
 };
=20
 #define NSIM_DEV_MAX_MACS_DEFAULT 32
diff --git a/drivers/net/netdevsim/netdevsim.h b/drivers/net/netdevsim/netd=
evsim.h
index 8dc8f4e5dcd8..0ea9705eda38 100644
--- a/drivers/net/netdevsim/netdevsim.h
+++ b/drivers/net/netdevsim/netdevsim.h
@@ -308,3 +308,9 @@ int nsim_dev_port_function_hw_addr_get(struct devlink *=
devlink, struct devlink_p
 int nsim_dev_port_function_hw_addr_set(struct devlink *devlink, struct dev=
link_port *port,
 				       const u8 *hw_addr, int hw_addr_len,
 				       struct netlink_ext_ack *extack);
+int nsim_dev_port_function_state_get(struct devlink *devlink, struct devli=
nk_port *port,
+				     enum devlink_port_function_state *state,
+				     struct netlink_ext_ack *extack);
+int nsim_dev_port_function_state_set(struct devlink *devlink, struct devli=
nk_port *port,
+				     enum devlink_port_function_state state,
+				     struct netlink_ext_ack *extack);
diff --git a/drivers/net/netdevsim/port_function.c b/drivers/net/netdevsim/=
port_function.c
index 6feeeaf19ce8..99581d3d15fe 100644
--- a/drivers/net/netdevsim/port_function.c
+++ b/drivers/net/netdevsim/port_function.c
@@ -16,6 +16,7 @@ struct nsim_port_function {
 	u16 pfnum;
 	struct nsim_port_function *pf_port; /* Valid only for SF port */
 	u8 hw_addr[ETH_ALEN];
+	u8 state; /* enum devlink_port_function_state */
 };
=20
 void nsim_dev_port_function_init(struct nsim_dev *nsim_dev)
@@ -196,6 +197,7 @@ static int nsim_devlink_port_function_add(struct devlin=
k *devlink, struct nsim_d
=20
 	list_add(&port->list, &nsim_dev->port_functions.head);
=20
+	port->state =3D DEVLINK_PORT_FUNCTION_STATE_INACTIVE;
 	err =3D devlink_port_register(devlink, &port->dl_port, port->port_index);
 	if (err)
 		goto reg_err;
@@ -379,3 +381,31 @@ int nsim_dev_port_function_hw_addr_set(struct devlink =
*devlink, struct devlink_p
 	memcpy(port->hw_addr, hw_addr, ETH_ALEN);
 	return 0;
 }
+
+int nsim_dev_port_function_state_get(struct devlink *devlink, struct devli=
nk_port *dl_port,
+				     enum devlink_port_function_state *state,
+				     struct netlink_ext_ack *extack)
+{
+	struct nsim_dev *nsim_dev =3D devlink_priv(devlink);
+	struct nsim_port_function *port;
+
+	port =3D nsim_dev_to_port_function(nsim_dev, dl_port);
+	if (IS_ERR(port))
+		return PTR_ERR(port);
+	*state =3D port->state;
+	return 0;
+}
+
+int nsim_dev_port_function_state_set(struct devlink *devlink, struct devli=
nk_port *dl_port,
+				     enum devlink_port_function_state state,
+				     struct netlink_ext_ack *extack)
+{
+	struct nsim_dev *nsim_dev =3D devlink_priv(devlink);
+	struct nsim_port_function *port;
+
+	port =3D nsim_dev_to_port_function(nsim_dev, dl_port);
+	if (IS_ERR(port))
+		return PTR_ERR(port);
+	port->state =3D state;
+	return 0;
+}
--=20
2.26.2

