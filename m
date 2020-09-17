Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C823D26E233
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 19:22:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726471AbgIQRVC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 13:21:02 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:4951 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726412AbgIQRUh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 13:20:37 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f639ab60000>; Thu, 17 Sep 2020 10:19:50 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Thu, 17 Sep 2020 10:20:34 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Thu, 17 Sep 2020 10:20:34 -0700
Received: from sw-mtx-036.mtx.labs.mlnx (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 17 Sep
 2020 17:20:33 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     Parav Pandit <parav@nvidia.com>, Jiri Pirko <jiri@nvidia.com>
Subject: [PATCH net-next v2 1/8] devlink: Introduce PCI SF port flavour and port attribute
Date:   Thu, 17 Sep 2020 20:20:13 +0300
Message-ID: <20200917172020.26484-2-parav@nvidia.com>
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
        t=1600363190; bh=jpeVIePcr4P/WgqPcPWzoK9/7uEOJGAmBj2FJlwT4cw=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:
         Content-Type:X-Originating-IP:X-ClientProxiedBy;
        b=h4jqnsWM68Cf5tZsjz12jwKB+WHz0dSqCjpAHih1PT+m1OwdWhoBWtrA6pmFa25+1
         V15V+QezArrjqMZsGfGxUGuqfzrMiGYZJOPUDg9SF7h+Nf1oTVHyBzQMpuqgvuqRIN
         TqZdzmroEZ8CrH9GREzQ2Vt03A1WkDzrJyBhhSF2jPt/IHjPeIH8cqTYsZDD0jkeG+
         WeaUGKmO3ZNjkxyX9mLINHCvYSDX99L1810svC4NksMplvQjgrIhYU2UfGVhAYhhVh
         C2EkEbA2nfzMqePPNzsHPeEV3SS9nXYX2bm4m195VbHO1KsKYF1fSlbm4lXVEoa8LJ
         SpAW8iuPF+guQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A PCI sub-function (SF) represents a portion of the device similar
to PCI VF.

In an eswitch, PCI SF may have port which is normally represented
using a representor netdevice.
To have better visibility of eswitch port, its association with SF,
and its representor netdevice, introduce a PCI SF port flavour.

When devlink port flavour is PCI SF, fill up PCI SF attributes of the
port.

Extend port name creation using PCI PF and SF number scheme on best
effort basis, so that vendor drivers can skip defining their own
scheme.

An example view of a PCI SF port.

$ devlink port show netdevsim/netdevsim10/2
netdevsim/netdevsim10/2: type eth netdev eni10npf0sf44 flavour pcisf contro=
ller 0 pfnum 0 sfnum 44 external false splittable false
  function:
    hw_addr 00:00:00:00:00:00

devlink port show netdevsim/netdevsim10/2 -jp
{
    "port": {
        "netdevsim/netdevsim10/2": {
            "type": "eth",
            "netdev": "eni10npf0sf44",
            "flavour": "pcisf",
            "controller": 0,
            "pfnum": 0,
            "sfnum": 44,
            "external": false,
            "splittable": false,
            "function": {
                "hw_addr": "00:00:00:00:00:00"
            }
        }
    }
}

Signed-off-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 include/net/devlink.h        | 17 +++++++++++++++++
 include/uapi/linux/devlink.h |  7 +++++++
 net/core/devlink.c           | 37 ++++++++++++++++++++++++++++++++++++
 3 files changed, 61 insertions(+)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index 48b1c1ef1ebd..1edb558125b0 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -83,6 +83,20 @@ struct devlink_port_pci_vf_attrs {
 	u8 external:1;
 };
=20
+/**
+ * struct devlink_port_pci_sf_attrs - devlink port's PCI SF attributes
+ * @controller: Associated controller number
+ * @pf: Associated PCI PF number for this port.
+ * @sf: Associated PCI SF for of the PCI PF for this port.
+ * @external: when set, indicates if a port is for an external controller
+ */
+struct devlink_port_pci_sf_attrs {
+	u32 controller;
+	u16 pf;
+	u32 sf;
+	u8 external:1;
+};
+
 /**
  * struct devlink_port_attrs - devlink port object
  * @flavour: flavour of the port
@@ -104,6 +118,7 @@ struct devlink_port_attrs {
 		struct devlink_port_phys_attrs phys;
 		struct devlink_port_pci_pf_attrs pci_pf;
 		struct devlink_port_pci_vf_attrs pci_vf;
+		struct devlink_port_pci_sf_attrs pci_sf;
 	};
 };
=20
@@ -1230,6 +1245,8 @@ void devlink_port_attrs_pci_pf_set(struct devlink_por=
t *devlink_port, u32 contro
 				   u16 pf, bool external);
 void devlink_port_attrs_pci_vf_set(struct devlink_port *devlink_port, u32 =
controller,
 				   u16 pf, u16 vf, bool external);
+void devlink_port_attrs_pci_sf_set(struct devlink_port *devlink_port, u32 =
controller,
+				   u16 pf, u32 sf, bool external);
 int devlink_sb_register(struct devlink *devlink, unsigned int sb_index,
 			u32 size, u16 ingress_pools_count,
 			u16 egress_pools_count, u16 ingress_tc_count,
diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index 631f5bdf1707..09c41b9ce407 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -195,6 +195,11 @@ enum devlink_port_flavour {
 				      * port that faces the PCI VF.
 				      */
 	DEVLINK_PORT_FLAVOUR_VIRTUAL, /* Any virtual port facing the user. */
+
+	DEVLINK_PORT_FLAVOUR_PCI_SF, /* Represents eswitch port
+				      * for the PCI SF. It is an internal
+				      * port that faces the PCI SF.
+				      */
 };
=20
 enum devlink_param_cmode {
@@ -462,6 +467,8 @@ enum devlink_attr {
=20
 	DEVLINK_ATTR_PORT_EXTERNAL,		/* u8 */
 	DEVLINK_ATTR_PORT_CONTROLLER_NUMBER,	/* u32 */
+
+	DEVLINK_ATTR_PORT_PCI_SF_NUMBER,	/* u32 */
 	/* add new attributes above here, update the policy in devlink.c */
=20
 	__DEVLINK_ATTR_MAX,
diff --git a/net/core/devlink.c b/net/core/devlink.c
index e5b71f3c2d4d..fada660fd515 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -539,6 +539,15 @@ static int devlink_nl_port_attrs_put(struct sk_buff *m=
sg,
 		if (nla_put_u8(msg, DEVLINK_ATTR_PORT_EXTERNAL, attrs->pci_vf.external))
 			return -EMSGSIZE;
 		break;
+	case DEVLINK_PORT_FLAVOUR_PCI_SF:
+		if (nla_put_u32(msg, DEVLINK_ATTR_PORT_CONTROLLER_NUMBER,
+				attrs->pci_sf.controller) ||
+		    nla_put_u16(msg, DEVLINK_ATTR_PORT_PCI_PF_NUMBER, attrs->pci_sf.pf) =
||
+		    nla_put_u32(msg, DEVLINK_ATTR_PORT_PCI_SF_NUMBER, attrs->pci_sf.sf))
+			return -EMSGSIZE;
+		if (nla_put_u8(msg, DEVLINK_ATTR_PORT_EXTERNAL, attrs->pci_vf.external))
+			return -EMSGSIZE;
+		break;
 	case DEVLINK_PORT_FLAVOUR_PHYSICAL:
 	case DEVLINK_PORT_FLAVOUR_CPU:
 	case DEVLINK_PORT_FLAVOUR_DSA:
@@ -7808,6 +7817,31 @@ void devlink_port_attrs_pci_vf_set(struct devlink_po=
rt *devlink_port, u32 contro
 }
 EXPORT_SYMBOL_GPL(devlink_port_attrs_pci_vf_set);
=20
+/**
+ *	devlink_port_attrs_pci_sf_set - Set PCI SF port attributes
+ *
+ *	@devlink_port: devlink port
+ *	@controller: associated controller number for the devlink port instance
+ *	@pf: associated PF for the devlink port instance
+ *	@sf: associated SF of a PF for the devlink port instance
+ *	@external: indicates if the port is for an external controller
+ */
+void devlink_port_attrs_pci_sf_set(struct devlink_port *devlink_port, u32 =
controller,
+				   u16 pf, u32 sf, bool external)
+{
+	struct devlink_port_attrs *attrs =3D &devlink_port->attrs;
+	int ret;
+
+	ret =3D __devlink_port_attrs_set(devlink_port, DEVLINK_PORT_FLAVOUR_PCI_S=
F);
+	if (ret)
+		return;
+	attrs->pci_sf.controller =3D controller;
+	attrs->pci_sf.pf =3D pf;
+	attrs->pci_sf.sf =3D sf;
+	attrs->pci_sf.external =3D external;
+}
+EXPORT_SYMBOL_GPL(devlink_port_attrs_pci_sf_set);
+
 static int __devlink_port_phys_port_name_get(struct devlink_port *devlink_=
port,
 					     char *name, size_t len)
 {
@@ -7855,6 +7889,9 @@ static int __devlink_port_phys_port_name_get(struct d=
evlink_port *devlink_port,
 		n =3D snprintf(name, len, "pf%uvf%u",
 			     attrs->pci_vf.pf, attrs->pci_vf.vf);
 		break;
+	case DEVLINK_PORT_FLAVOUR_PCI_SF:
+		n =3D snprintf(name, len, "pf%usf%u", attrs->pci_sf.pf, attrs->pci_sf.sf=
);
+		break;
 	}
=20
 	if (n >=3D len)
--=20
2.26.2

