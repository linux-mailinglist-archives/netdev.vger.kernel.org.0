Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA7A6311D3F
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 13:57:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230020AbhBFM45 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Feb 2021 07:56:57 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:8379 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229790AbhBFM4t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Feb 2021 07:56:49 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B601e91e70000>; Sat, 06 Feb 2021 04:56:07 -0800
Received: from sw-mtx-036.mtx.labs.mlnx (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Sat, 6 Feb
 2021 12:56:06 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     Parav Pandit <parav@nvidia.com>
Subject: [PATCH net-next 3/7] netdevsim: Simulate get hardware address of a PCI port
Date:   Sat, 6 Feb 2021 14:55:47 +0200
Message-ID: <20210206125551.8616-4-parav@nvidia.com>
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
        t=1612616167; bh=N+CBw14zSfRwF9ooD6N2Wn06g618uz2JEooYNW+FLtI=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=W+7dbAJgDPSbaaNT774dwwAPRK+2gXCipnop1Y3u6KuZK2cWTBg81HI26eshBkh8X
         SEUNAhtgP+oDktqC5kK7BsMiGBllycgFE7PSjiJt9Tb7KPG094TDcrOlmJdn9pTEsD
         WtB3dQBo3bMya9iehbORMP5bPs/loP54G5WHOI0mIxiYf/LkXL9Z5BJQjEZYznzfbb
         650XpHjZ0pL9Nr5TTzhrgPSFoq+iycvJDHJ5+DXFwazh2xlBtBdll2pErGbecqFvTK
         UZlZxYkd/9C2rN3Krwq2rF3bm7lcJq/GvgPcZL4Jo0x54GsydEL0P57IrSEOH26IIx
         U5kB4eyyY6KXg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow users to get hardware address for the PCI port.

Below example creates one devlink port, queries a port and its hardware
address.

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

Show devlink ports:
$ devlink port show
netdevsim/netdevsim10/0: type eth netdev eth0 flavour physical port 1 split=
table false
netdevsim/netdevsim10/1: type eth netdev eth1 flavour pcipf controller 0 pf=
num 2 external false splittable false
  function:
    hw_addr 00:00:00:00:00:00
netdevsim/netdevsim10/2: type eth netdev eth2 flavour pcisf controller 0 pf=
num 2 sfnum 0 splittable false
  function:
    hw_addr 00:00:00:00:00:00

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
                "hw_addr": "00:00:00:00:00:00"
            }
        }
    }
}

Signed-off-by: Parav Pandit <parav@nvidia.com>
---
 drivers/net/netdevsim/dev.c           |  1 +
 drivers/net/netdevsim/netdevsim.h     |  4 ++++
 drivers/net/netdevsim/port_function.c | 30 +++++++++++++++++++++++++++
 3 files changed, 35 insertions(+)

diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index 806e387918fe..6046906d6b85 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -907,6 +907,7 @@ static const struct devlink_ops nsim_dev_devlink_ops =
=3D {
 	.trap_policer_counter_get =3D nsim_dev_devlink_trap_policer_counter_get,
 	.port_new =3D nsim_dev_devlink_port_new,
 	.port_del =3D nsim_dev_devlink_port_del,
+	.port_function_hw_addr_get =3D nsim_dev_port_fn_hw_addr_get,
 };
=20
 #define NSIM_DEV_MAX_MACS_DEFAULT 32
diff --git a/drivers/net/netdevsim/netdevsim.h b/drivers/net/netdevsim/netd=
evsim.h
index efa7c08d842a..e910c3cf480d 100644
--- a/drivers/net/netdevsim/netdevsim.h
+++ b/drivers/net/netdevsim/netdevsim.h
@@ -320,3 +320,7 @@ int nsim_dev_devlink_port_new(struct devlink *devlink,
 			      unsigned int *new_port_index);
 int nsim_dev_devlink_port_del(struct devlink *devlink, unsigned int port_i=
ndex,
 			      struct netlink_ext_ack *extack);
+int nsim_dev_port_fn_hw_addr_get(struct devlink *devlink,
+				 struct devlink_port *port,
+				 u8 *hw_addr, int *hw_addr_len,
+				 struct netlink_ext_ack *extack);
diff --git a/drivers/net/netdevsim/port_function.c b/drivers/net/netdevsim/=
port_function.c
index a2f62a609e9b..4031598e2076 100644
--- a/drivers/net/netdevsim/port_function.c
+++ b/drivers/net/netdevsim/port_function.c
@@ -16,6 +16,7 @@ struct nsim_port_fn {
 	int refcount; /* Counts how many sf ports are bound attached to this pf p=
ort. */
 	u32 sfnum;
 	u16 pfnum;
+	u8 hw_addr[ETH_ALEN];
 };
=20
 static struct devlink_port *
@@ -431,3 +432,32 @@ void nsim_dev_port_fn_disable(struct nsim_dev *nsim_de=
v)
 		nsim_devlink_port_fn_free(nsim_dev, port);
 	}
 }
+
+static struct nsim_port_fn *
+nsim_dev_to_port_fn(struct nsim_dev *nsim_dev, struct devlink_port *dl_por=
t,
+		    struct netlink_ext_ack *extack)
+{
+	if (nsim_dev_port_index_internal(nsim_dev, dl_port->index)) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Port index doesn't belong to user created port");
+		return ERR_PTR(-EOPNOTSUPP);
+	}
+	return container_of(dl_port, struct nsim_port_fn, dl_port);
+}
+
+int nsim_dev_port_fn_hw_addr_get(struct devlink *devlink,
+				 struct devlink_port *dl_port,
+				 u8 *hw_addr, int *hw_addr_len,
+				 struct netlink_ext_ack *extack)
+{
+	struct nsim_dev *nsim_dev =3D devlink_priv(devlink);
+	struct nsim_port_fn *port;
+
+	port =3D nsim_dev_to_port_fn(nsim_dev, dl_port, extack);
+	if (IS_ERR(port))
+		return PTR_ERR(port);
+
+	memcpy(hw_addr, port->hw_addr, ETH_ALEN);
+	*hw_addr_len =3D ETH_ALEN;
+	return 0;
+}
--=20
2.26.2

