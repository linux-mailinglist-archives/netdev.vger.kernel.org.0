Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43435311D40
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 13:57:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230034AbhBFM47 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Feb 2021 07:56:59 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:16290 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229800AbhBFM4t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Feb 2021 07:56:49 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B601e91e70001>; Sat, 06 Feb 2021 04:56:07 -0800
Received: from sw-mtx-036.mtx.labs.mlnx (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Sat, 6 Feb
 2021 12:56:07 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     Parav Pandit <parav@nvidia.com>
Subject: [PATCH net-next 4/7] netdevsim: Simulate set hardware address of a PCI port
Date:   Sat, 6 Feb 2021 14:55:48 +0200
Message-ID: <20210206125551.8616-5-parav@nvidia.com>
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
        t=1612616167; bh=Qxb+rKzTtaYeE4AEV/y1s4JXFL2dMSFyoa2yfCWofa0=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=iIqargIiYrZg++CT2YB4zZKsS4ys+VzDDOCEqRpWZgUWgT6O05sc3nNbJYFSt0qBL
         8dU6CpizbQYztNdOCD6gSlC9qIT7BRZc4AABSDtveuigWupQTXvr0bdcIGirvVht7p
         BL0sOriUHrAOAqP4kYlz24d44VAH7W3hLx7JH+JwD/tKVIrxMuHfcL0WJ3wgdSeT4l
         buACgpREcHTFLmDUlIHWdTsGlWOdG19gN3RFV25Ij8iSx9AlfDzIw/CNad3wO+NDM3
         /fweDFwGuvSy4bcI2ySjw80YhAILE8ZHvfXM9+P1yjCXd0F0H2AWLM28SV+oYgLGwY
         YMQIxM2fsBSTA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow users to get/set hardware address for the PCI port.

Below example creates one devlink port, queries a port, sets a
hardware address.

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

Set the MAC address:
$ devlink port function set netdevsim/netdevsim10/2 hw_addr 00:11:22:33:44:=
55

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
    hw_addr 00:11:22:33:44:55

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
                "hw_addr": "00:11:22:33:44:55"
            }
        }
    }
}

Signed-off-by: Parav Pandit <parav@nvidia.com>
---
 drivers/net/netdevsim/dev.c           |  1 +
 drivers/net/netdevsim/netdevsim.h     |  4 ++++
 drivers/net/netdevsim/port_function.c | 21 +++++++++++++++++++++
 3 files changed, 26 insertions(+)

diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index 6046906d6b85..ab15b5f7e955 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -908,6 +908,7 @@ static const struct devlink_ops nsim_dev_devlink_ops =
=3D {
 	.port_new =3D nsim_dev_devlink_port_new,
 	.port_del =3D nsim_dev_devlink_port_del,
 	.port_function_hw_addr_get =3D nsim_dev_port_fn_hw_addr_get,
+	.port_function_hw_addr_set =3D nsim_dev_port_fn_hw_addr_set,
 };
=20
 #define NSIM_DEV_MAX_MACS_DEFAULT 32
diff --git a/drivers/net/netdevsim/netdevsim.h b/drivers/net/netdevsim/netd=
evsim.h
index e910c3cf480d..aafe2027a112 100644
--- a/drivers/net/netdevsim/netdevsim.h
+++ b/drivers/net/netdevsim/netdevsim.h
@@ -324,3 +324,7 @@ int nsim_dev_port_fn_hw_addr_get(struct devlink *devlin=
k,
 				 struct devlink_port *port,
 				 u8 *hw_addr, int *hw_addr_len,
 				 struct netlink_ext_ack *extack);
+int nsim_dev_port_fn_hw_addr_set(struct devlink *devlink,
+				 struct devlink_port *port,
+				 const u8 *hw_addr, int hw_addr_len,
+				 struct netlink_ext_ack *extack);
diff --git a/drivers/net/netdevsim/port_function.c b/drivers/net/netdevsim/=
port_function.c
index 4031598e2076..d47cdf44770a 100644
--- a/drivers/net/netdevsim/port_function.c
+++ b/drivers/net/netdevsim/port_function.c
@@ -461,3 +461,24 @@ int nsim_dev_port_fn_hw_addr_get(struct devlink *devli=
nk,
 	*hw_addr_len =3D ETH_ALEN;
 	return 0;
 }
+
+int nsim_dev_port_fn_hw_addr_set(struct devlink *devlink,
+				 struct devlink_port *dl_port,
+				 const u8 *hw_addr, int hw_addr_len,
+				 struct netlink_ext_ack *extack)
+{
+	struct nsim_dev *nsim_dev =3D devlink_priv(devlink);
+	struct nsim_port_fn *port;
+
+	if (hw_addr_len !=3D ETH_ALEN) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Hardware address must be 6 bytes long");
+		return -EOPNOTSUPP;
+	}
+	port =3D nsim_dev_to_port_fn(nsim_dev, dl_port, extack);
+	if (IS_ERR(port))
+		return PTR_ERR(port);
+
+	memcpy(port->hw_addr, hw_addr, ETH_ALEN);
+	return 0;
+}
--=20
2.26.2

