Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5931526E249
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 19:24:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726426AbgIQRXl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 13:23:41 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:11040 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726448AbgIQRUp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 13:20:45 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f639a8c0001>; Thu, 17 Sep 2020 10:19:08 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Thu, 17 Sep 2020 10:20:37 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Thu, 17 Sep 2020 10:20:37 -0700
Received: from sw-mtx-036.mtx.labs.mlnx (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 17 Sep
 2020 17:20:36 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     Parav Pandit <parav@nvidia.com>, Jiri Pirko <jiri@nvidia.com>
Subject: [PATCH net-next v2 6/8] netdevsim: Simulate get/set hardware address of a PCI port
Date:   Thu, 17 Sep 2020 20:20:18 +0300
Message-ID: <20200917172020.26484-7-parav@nvidia.com>
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
        t=1600363148; bh=iHcxwDuKnwffefMnVImS2YPfehOunDT3K3S3AnH/MTA=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:
         Content-Type:X-Originating-IP:X-ClientProxiedBy;
        b=CTfnhaF1mmHMfky/fUTH8zsFZrUapzFUMP+X1wVJpdg3tjr/VRc2o1NqgwxvF0xf7
         y4rtsiDs8HN90JVc9viRWp7swCzOt8xxfgYd90K9f+tTw8phRk9PgF3AKIixRxBbKx
         RaAKYWrRQeY1DPFbYvHmfJrSWeBU+MI6pw2VsS4TG0fYCs1CLwt7tgw1MJOKrTf4oJ
         evE/Bm6wQd8svgFA+HC9kaEwOUEQyi1b8H8zUjmSk3//FZNkE3QpiaDE9nNBORNDMZ
         gSsG8m49DriowPZd/bAbF0UOe4btFxK2lLlmk0TKSjHndv5UYKPhYA90mjPkB2J0KY
         CGOxr8fU09NCA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow users to get/set hardware address for the PCI port.

Below example creates one devlink port, queries a port, sets a
hardware address.

Example of a PCI SF port which supports a port function hw_addr set:
Create a device with ID=3D10 and one physical port.
$ echo "10 1" > /sys/bus/netdevsim/new_device

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
index 4f3e9cc9489f..6feeeaf19ce8 100644
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

