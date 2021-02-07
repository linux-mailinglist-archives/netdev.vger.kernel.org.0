Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 966D03122D7
	for <lists+netdev@lfdr.de>; Sun,  7 Feb 2021 09:45:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229702AbhBGIpW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Feb 2021 03:45:22 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:14525 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbhBGIpJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Feb 2021 03:45:09 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B601fa86d0000>; Sun, 07 Feb 2021 00:44:29 -0800
Received: from sw-mtx-036.mtx.labs.mlnx (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Sun, 7 Feb
 2021 08:44:28 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     Parav Pandit <parav@nvidia.com>
Subject: [PATCH net-next v2 5/7] netdevsim: Simulate port function state for a PCI port
Date:   Sun, 7 Feb 2021 10:44:10 +0200
Message-ID: <20210207084412.252259-6-parav@nvidia.com>
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
        t=1612687469; bh=I+Za4fGJu0Hwrbf3oi5ivQ4WDIg32epMIBugfJ8ZxuM=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=mkQtNNfwWrAWJYURMY/necrIGNYKrOOPzyxCVcQceXGOkUXjKTOFtLjk+OP80vVkK
         WPG0mPdWK91Zdy7pWCMTiO/OFLjV/y+5rIKWTRb1sPbHrMbladnZ11kmbF5M0JBw2n
         Q4ZaIzr92pr/Bi+LQorRVAwKvhMy3AqiyVvU5xaL0MTOc/gx/4Aish5B6coTp5uJqc
         D5wp9OKR9U3uxEH5Fmu2JfmhkP4K0EO3bA2hXQzyRX4vUhgnDeOGJT/Yguoy4zo4oo
         asJJELDV2cnZ+O7c3gcKGyrK9HHkU+M4+G5a1lBD0tmv+1tm68rOK6aqBO+s8VUDmW
         UiJNz2SEbSRAQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simulate port function state of a PCI port.
This enables users to get the state of the PCI port function.

Example of a PCI SF port which supports a port function hw_addr set:
Create a device with ID=3D10 and one physical port.
$ echo "10 1" > /sys/bus/netdevsim/new_device

Add PCI PF port:
$ devlink port add netdevsim/netdevsim10 flavour pcipf pfnum 2
netdevsim/netdevsim10/1: type eth netdev eth1 flavour pcipf controller 0 pf=
num 2 external false splittable false
  function:
    hw_addr 00:00:00:00:00:00

$ devlink port add netdevsim/netdevsim10 flavour pcisf pfnum 2
netdevsim/netdevsim10/2: type eth netdev eth2 flavour pcisf controller 0 pf=
num 2 sfnum 0 splittable false
  function:
    hw_addr 00:00:00:00:00:00

Show devlink port:
$ devlink port show netdevsim/netdevsim10/2
netdevsim/netdevsim10/2: type eth netdev eth2 flavour pcisf controller 0 pf=
num 2 sfnum 0 splittable false
  function:
    hw_addr 00:00:00:00:00:00 state inactive opstate detached

Show the port and function attributes in JSON format:
$ devlink port show netdevsim/netdevsim10/2 -jp
{
    "port": {
        "netdevsim/netdevsim10/2": {
            "type": "eth",
            "netdev": "eth2",
            "flavour": "pcisf",
            "controller": 0,
            "pfnum": 2,
            "sfnum": 0,
            "splittable": false,
            "function": {
                "hw_addr": "00:00:00:00:00:00",
                "state": "inactive",
                "opstate": "detached"
            }
        }
    }
}

Signed-off-by: Parav Pandit <parav@nvidia.com>
---
 drivers/net/netdevsim/dev.c           |  1 +
 drivers/net/netdevsim/netdevsim.h     |  5 +++++
 drivers/net/netdevsim/port_function.c | 22 ++++++++++++++++++++++
 3 files changed, 28 insertions(+)

diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index ab15b5f7e955..9f2164ea89cd 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -909,6 +909,7 @@ static const struct devlink_ops nsim_dev_devlink_ops =
=3D {
 	.port_del =3D nsim_dev_devlink_port_del,
 	.port_function_hw_addr_get =3D nsim_dev_port_fn_hw_addr_get,
 	.port_function_hw_addr_set =3D nsim_dev_port_fn_hw_addr_set,
+	.port_fn_state_get =3D nsim_dev_port_fn_state_get,
 };
=20
 #define NSIM_DEV_MAX_MACS_DEFAULT 32
diff --git a/drivers/net/netdevsim/netdevsim.h b/drivers/net/netdevsim/netd=
evsim.h
index aafe2027a112..c0544d93e1e8 100644
--- a/drivers/net/netdevsim/netdevsim.h
+++ b/drivers/net/netdevsim/netdevsim.h
@@ -328,3 +328,8 @@ int nsim_dev_port_fn_hw_addr_set(struct devlink *devlin=
k,
 				 struct devlink_port *port,
 				 const u8 *hw_addr, int hw_addr_len,
 				 struct netlink_ext_ack *extack);
+int nsim_dev_port_fn_state_get(struct devlink *devlink,
+			       struct devlink_port *port,
+			       enum devlink_port_fn_state *state,
+			       enum devlink_port_fn_opstate *opstate,
+			       struct netlink_ext_ack *extack);
diff --git a/drivers/net/netdevsim/port_function.c b/drivers/net/netdevsim/=
port_function.c
index 5d6c5a732546..a25c449e4559 100644
--- a/drivers/net/netdevsim/port_function.c
+++ b/drivers/net/netdevsim/port_function.c
@@ -17,6 +17,7 @@ struct nsim_port_fn {
 	u32 sfnum;
 	u16 pfnum;
 	u8 hw_addr[ETH_ALEN];
+	u8 state; /* enum devlink_port_fn_state */
 };
=20
 static struct devlink_port *
@@ -248,6 +249,7 @@ static int nsim_devlink_port_fn_add(struct devlink *dev=
link,
 		goto pf_err;
 	}
=20
+	port->state =3D DEVLINK_PORT_FN_STATE_INACTIVE;
 	err =3D devlink_port_register(devlink, &port->dl_port, port->port_index);
 	if (err)
 		goto reg_err;
@@ -482,3 +484,23 @@ int nsim_dev_port_fn_hw_addr_set(struct devlink *devli=
nk,
 	memcpy(port->hw_addr, hw_addr, ETH_ALEN);
 	return 0;
 }
+
+int nsim_dev_port_fn_state_get(struct devlink *devlink,
+			       struct devlink_port *dl_port,
+			       enum devlink_port_fn_state *state,
+			       enum devlink_port_fn_opstate *opstate,
+			       struct netlink_ext_ack *extack)
+{
+	struct nsim_dev *nsim_dev =3D devlink_priv(devlink);
+	struct nsim_port_fn *port;
+
+	port =3D nsim_dev_to_port_fn(nsim_dev, dl_port, extack);
+	if (IS_ERR(port))
+		return PTR_ERR(port);
+	*state =3D port->state;
+	if (port->state =3D=3D DEVLINK_PORT_FN_STATE_INACTIVE)
+		*opstate =3D DEVLINK_PORT_FN_OPSTATE_DETACHED;
+	else
+		*opstate =3D DEVLINK_PORT_FN_OPSTATE_ATTACHED;
+	return 0;
+}
--=20
2.26.2

