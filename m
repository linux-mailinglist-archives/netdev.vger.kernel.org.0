Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44AA8311D42
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 13:57:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229850AbhBFM5P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Feb 2021 07:57:15 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:16895 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229816AbhBFM4v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Feb 2021 07:56:51 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B601e91e90000>; Sat, 06 Feb 2021 04:56:09 -0800
Received: from sw-mtx-036.mtx.labs.mlnx (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Sat, 6 Feb
 2021 12:56:08 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     Parav Pandit <parav@nvidia.com>
Subject: [PATCH net-next 6/7] netdevsim: Simulate port function set state for a PCI port
Date:   Sat, 6 Feb 2021 14:55:50 +0200
Message-ID: <20210206125551.8616-7-parav@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210206125551.8616-1-parav@nvidia.com>
References: <20210206125551.8616-1-parav@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612616169; bh=gcpDPL8w2je/gqdmPrk4HwwoS/7BKh9oit9K83B6Tmk=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=K6jcSK1SdnQWVCSYP2QA/98FVgyEy/P7Z8HnL3zlepZ6KxYuXlBGtmi/JSO80tNj2
         RzWg9kycE5QTSvU2sDUCPFXsBt7ju9i6tUOb9VLt864YFNRU8vsDpNhifgT6qoHoRU
         EK+lB0OqBI19P2lgSZkxDllobIAzakGI7jXiQGqb3lNauqIn3cJDqGAwbb4sduw9+2
         OOB+2394st5bmF9CWRgkGvs4AKynZLbT+GFkLezbVN+wmxYA17mfvPVa3enO7MXpPW
         p0scsqeOpRcVSDAoCuS8N+mPT92SOcQ0eqyYrv+Thkbnj9zoZquxG3feAjlDQS3i3q
         nFNbKyelO03KQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simulate port function state of a PCI port.
This enables users to get and set the state of the PCI port function.

Example of a PCI SF port which supports a port function:

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

Set the MAC address and activate the function:
$ devlink port function set netdevsim/netdevsim10/2 hw_addr 00:11:22:33:44:=
55 state active

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
                "hw_addr": "00:11:22:33:44:55",
                "state": "active",
                "opstate": "attached"
            }
        }
    }
}

Signed-off-by: Parav Pandit <parav@nvidia.com>
---
 drivers/net/netdevsim/dev.c           |  1 +
 drivers/net/netdevsim/netdevsim.h     |  4 ++++
 drivers/net/netdevsim/port_function.c | 15 +++++++++++++++
 3 files changed, 20 insertions(+)

diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index 9f2164ea89cd..e8b6bd22fb1f 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -910,6 +910,7 @@ static const struct devlink_ops nsim_dev_devlink_ops =
=3D {
 	.port_function_hw_addr_get =3D nsim_dev_port_fn_hw_addr_get,
 	.port_function_hw_addr_set =3D nsim_dev_port_fn_hw_addr_set,
 	.port_fn_state_get =3D nsim_dev_port_fn_state_get,
+	.port_fn_state_set =3D nsim_dev_port_fn_state_set,
 };
=20
 #define NSIM_DEV_MAX_MACS_DEFAULT 32
diff --git a/drivers/net/netdevsim/netdevsim.h b/drivers/net/netdevsim/netd=
evsim.h
index c0544d93e1e8..93bfa3e946b2 100644
--- a/drivers/net/netdevsim/netdevsim.h
+++ b/drivers/net/netdevsim/netdevsim.h
@@ -333,3 +333,7 @@ int nsim_dev_port_fn_state_get(struct devlink *devlink,
 			       enum devlink_port_fn_state *state,
 			       enum devlink_port_fn_opstate *opstate,
 			       struct netlink_ext_ack *extack);
+int nsim_dev_port_fn_state_set(struct devlink *devlink,
+			       struct devlink_port *port,
+			       enum devlink_port_fn_state state,
+			       struct netlink_ext_ack *extack);
diff --git a/drivers/net/netdevsim/port_function.c b/drivers/net/netdevsim/=
port_function.c
index 10c692b8aea2..8e8e7d6df8a1 100644
--- a/drivers/net/netdevsim/port_function.c
+++ b/drivers/net/netdevsim/port_function.c
@@ -504,3 +504,18 @@ int nsim_dev_port_fn_state_get(struct devlink *devlink=
,
 		*opstate =3D DEVLINK_PORT_FN_OPSTATE_ATTACHED;
 	return 0;
 }
+
+int nsim_dev_port_fn_state_set(struct devlink *devlink,
+			       struct devlink_port *dl_port,
+			       enum devlink_port_fn_state state,
+			       struct netlink_ext_ack *extack)
+{
+	struct nsim_dev *nsim_dev =3D devlink_priv(devlink);
+	struct nsim_port_fn *port;
+
+	port =3D nsim_dev_to_port_fn(nsim_dev, dl_port, extack);
+	if (IS_ERR(port))
+		return PTR_ERR(port);
+	port->state =3D state;
+	return 0;
+}
--=20
2.26.2

