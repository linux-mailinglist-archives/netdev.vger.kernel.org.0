Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A45A726D65E
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 10:23:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726410AbgIQIXf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 04:23:35 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:3215 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726327AbgIQIXA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 04:23:00 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f631b560002>; Thu, 17 Sep 2020 01:16:22 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Thu, 17 Sep 2020 01:17:51 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Thu, 17 Sep 2020 01:17:51 -0700
Received: from sw-mtx-036.mtx.labs.mlnx (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 17 Sep
 2020 08:17:50 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     Parav Pandit <parav@nvidia.com>, Jiri Pirko <jiri@nvidia.com>
Subject: [PATCH net-next 6/8] netdevsim: Simulate get/set hardware address of a PCI port
Date:   Thu, 17 Sep 2020 11:17:29 +0300
Message-ID: <20200917081731.8363-7-parav@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200917081731.8363-1-parav@nvidia.com>
References: <20200917081731.8363-1-parav@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1600330582; bh=J1uudAjTs8OjBTm8K5WqPWaeWin6JwWh6TZlCPZlrr8=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:
         Content-Type:X-Originating-IP:X-ClientProxiedBy;
        b=dB1KsLHGXV6x8h4SI2bgi12hrFq6RCDnggxClMdZALUGxcJx2t7XOCwyLqtmHW+0C
         FzazX1oQ21n3lS/nR6ake85+i5av5O7H/aHTDrs/fPuPoUwsDMrRQl2q5SuBQ/yrqy
         StyKkpnl9A7lWHAG5C/iNRtHgLPxeotenwCIsexdgib1uy92MlC7vlmtkI5fXoxxrj
         ONE6KnCoTiexMOyZzYm4s08X5UorPmQZf1Dk/v3eGdePRbE0bMiAqNjKyw7/HQQGor
         /Gw9GAcECHLls+Kv/Rgzg80SslF3WKoKAA0RYqbHPCSC7L4dM+1eBUyjWAkHQzoOv7
         73OxORZg2fhag==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow users to get/set hardware address for the PCI port.

Below example creates one devlink port, queries a port, sets a
hardware address.

Example of a PCI SF port which supports a port function hw_addr set:
Create a device with ID=3D10 and one physical port.
$ echo "10 1" > /sys/bus/netdevsim/new_device
$ devlink port show
netdevsim/netdevsim10/0: type eth netdev eni10np1 flavour physical port 1 s=
plittable false

$ devlink port add netdevsim/netdevsim10/10 flavour pcipf pfnum 0
$ devlink port show netdevsim/netdevsim10/10
netdevsim/netdevsim10/10: type eth netdev eni10npf0 flavour pcipf controlle=
r 0 pfnum 0 external false splittable false
  function:
    hw_addr 00:00:00:00:00:00 state inactive

$ devlink port function set netdevsim/netdevsim10/10 hw_addr 00:11:22:33:44=
:55

$ devlink port show netdevsim/netdevsim10/10 -jp
{
    "port": {
        "netdevsim/netdevsim10/11": {
            "type": "eth",
            "netdev": "eni10npf0",
            "flavour": "pcisf",
            "controller": 0,
            "pfnum": 0,
            "sfnum": 44,
            "external": true,
            "splittable": false,
            "function": {
                "hw_addr": "00:11:22:33:44:55"
            }
        }
    }
}

Signed-off-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 drivers/net/netdevsim/dev.c           |  2 ++
 drivers/net/netdevsim/netdevsim.h     |  6 ++++
 drivers/net/netdevsim/port_function.c | 44 +++++++++++++++++++++++++++
 3 files changed, 52 insertions(+)

diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index e3b81c8b5125..ef2e293f358b 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -886,6 +886,8 @@ static const struct devlink_ops nsim_dev_devlink_ops =
=3D {
 	.trap_policer_counter_get =3D nsim_dev_devlink_trap_policer_counter_get,
 	.port_new =3D nsim_dev_devlink_port_new,
 	.port_del =3D nsim_dev_devlink_port_del,
+	.port_function_hw_addr_get =3D nsim_dev_port_function_hw_addr_get,
+	.port_function_hw_addr_set =3D nsim_dev_port_function_hw_addr_set,
 };
=20
 #define NSIM_DEV_MAX_MACS_DEFAULT 32
diff --git a/drivers/net/netdevsim/netdevsim.h b/drivers/net/netdevsim/netd=
evsim.h
index aec3c4d5fda7..8dc8f4e5dcd8 100644
--- a/drivers/net/netdevsim/netdevsim.h
+++ b/drivers/net/netdevsim/netdevsim.h
@@ -302,3 +302,9 @@ int nsim_dev_devlink_port_new(struct devlink *devlink, =
const struct devlink_port
 			      struct netlink_ext_ack *extack);
 int nsim_dev_devlink_port_del(struct devlink *devlink, unsigned int port_i=
ndex,
 			      struct netlink_ext_ack *extack);
+int nsim_dev_port_function_hw_addr_get(struct devlink *devlink, struct dev=
link_port *port,
+				       u8 *hw_addr, int *hw_addr_len,
+				       struct netlink_ext_ack *extack);
+int nsim_dev_port_function_hw_addr_set(struct devlink *devlink, struct dev=
link_port *port,
+				       const u8 *hw_addr, int hw_addr_len,
+				       struct netlink_ext_ack *extack);
diff --git a/drivers/net/netdevsim/port_function.c b/drivers/net/netdevsim/=
port_function.c
index 9a1634898c7d..0053f6f6d530 100644
--- a/drivers/net/netdevsim/port_function.c
+++ b/drivers/net/netdevsim/port_function.c
@@ -15,6 +15,7 @@ struct nsim_port_function {
 	u32 controller;
 	u16 pfnum;
 	struct nsim_port_function *pf_port; /* Valid only for SF port */
+	u8 hw_addr[ETH_ALEN];
 };
=20
 void nsim_dev_port_function_init(struct nsim_dev *nsim_dev)
@@ -335,3 +336,46 @@ void nsim_dev_port_function_disable(struct nsim_dev *n=
sim_dev)
 		nsim_devlink_port_function_free(nsim_dev, port);
 	}
 }
+
+static struct nsim_port_function *nsim_dev_to_port_function(struct nsim_de=
v *nsim_dev,
+							    struct devlink_port *dl_port)
+{
+	if (nsim_dev_port_index_internal(nsim_dev, dl_port->index))
+		return ERR_PTR(-EOPNOTSUPP);
+	return container_of(dl_port, struct nsim_port_function, dl_port);
+}
+
+int nsim_dev_port_function_hw_addr_get(struct devlink *devlink, struct dev=
link_port *dl_port,
+				       u8 *hw_addr, int *hw_addr_len,
+				       struct netlink_ext_ack *extack)
+{
+	struct nsim_dev *nsim_dev =3D devlink_priv(devlink);
+	struct nsim_port_function *port;
+
+	port =3D nsim_dev_to_port_function(nsim_dev, dl_port);
+	if (IS_ERR(port))
+		return PTR_ERR(port);
+
+	memcpy(hw_addr, port->hw_addr, ETH_ALEN);
+	*hw_addr_len =3D ETH_ALEN;
+	return 0;
+}
+
+int nsim_dev_port_function_hw_addr_set(struct devlink *devlink, struct dev=
link_port *dl_port,
+				       const u8 *hw_addr, int hw_addr_len,
+				       struct netlink_ext_ack *extack)
+{
+	struct nsim_dev *nsim_dev =3D devlink_priv(devlink);
+	struct nsim_port_function *port;
+
+	if (hw_addr_len !=3D ETH_ALEN) {
+		NL_SET_ERR_MSG_MOD(extack, "Hardware address must be 6 bytes long");
+		return -EOPNOTSUPP;
+	}
+	port =3D nsim_dev_to_port_function(nsim_dev, dl_port);
+	if (IS_ERR(port))
+		return PTR_ERR(port);
+
+	memcpy(port->hw_addr, hw_addr, ETH_ALEN);
+	return 0;
+}
--=20
2.26.2

