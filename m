Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDEE12B0DFA
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 20:26:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727045AbgKLTZ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 14:25:26 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:11329 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726812AbgKLTYu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 14:24:50 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fad8c090001>; Thu, 12 Nov 2020 11:24:57 -0800
Received: from sw-mtx-036.mtx.labs.mlnx (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 12 Nov
 2020 19:24:48 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <gregkh@linuxfoundation.org>
CC:     <jiri@nvidia.com>, <jgg@nvidia.com>, <dledford@redhat.com>,
        <leonro@nvidia.com>, <saeedm@nvidia.com>, <kuba@kernel.org>,
        <davem@davemloft.net>, Parav Pandit <parav@nvidia.com>,
        Vu Pham <vuhuong@nvidia.com>
Subject: [PATCH net-next 02/13] devlink: Introduce PCI SF port flavour and port attribute
Date:   Thu, 12 Nov 2020 21:24:12 +0200
Message-ID: <20201112192424.2742-3-parav@nvidia.com>
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
        t=1605209097; bh=qAAyHZbrk+w0mcub+q1sHLPG34iiL4uRk0ZQDzAVc2M=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=mPbMV2liF8U9ZVw4VgFXQfozW3yVZrSijFqz8YKkTZBYNkk67lLdFnE+KX5/hYPtR
         PvVBTO29vX7rUMVv+zh+JhYFkP842uaM3DAHsafNGgrbtcXScwmRCmQE4sPSW0oXDO
         BIEc6PQt6VLEPHlcUvyOjFz1qHo3agktKRz5ruYxl/WNj28wlIqoUqdpG8MvBr/umF
         vcwGiWAfM8b9UrQSm67VdoHywlROiUVr5o48SNLj2YfpvmUEct3Bc/QvRCGWkxwvOF
         n1gg27vFSAtqN/PAxmtON6Jp14xlANu8RwsHQg81oRE8nMRcmS8jVeVJBJmMupX8Pi
         +e8fqNCvv4u5A==
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
This is done as cApfNSfM, where A, N and M are controller, PCI PF and
PCI SF number respectively.
This is similar to existing naming for PCI PF and PCI VF ports.

An example view of a PCI SF port:

$ devlink port show pci/0000:06:00.0/32768
pci/0000:06:00.0/32768: type eth netdev eth0 flavour pcisf controller 0 pfn=
um 0 sfnum 88 external false splittable false
  function:
    hw_addr 00:00:00:00:88:88 state active opstate attached

$ devlink port show pci/0000:06:00.0/32768 -jp
{
    "port": {
        "pci/0000:06:00.0/32768": {
            "type": "eth",
            "netdev": "eth0",
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

Signed-off-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Vu Pham <vuhuong@nvidia.com>
---
 include/net/devlink.h        | 17 +++++++++++++
 include/uapi/linux/devlink.h |  5 ++++
 net/core/devlink.c           | 46 ++++++++++++++++++++++++++++++++++++
 3 files changed, 68 insertions(+)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index b01bb9bca5a2..1b7c9fbc607a 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -92,6 +92,20 @@ struct devlink_port_pci_vf_attrs {
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
@@ -113,6 +127,7 @@ struct devlink_port_attrs {
 		struct devlink_port_phys_attrs phys;
 		struct devlink_port_pci_pf_attrs pci_pf;
 		struct devlink_port_pci_vf_attrs pci_vf;
+		struct devlink_port_pci_sf_attrs pci_sf;
 	};
 };
=20
@@ -1401,6 +1416,8 @@ void devlink_port_attrs_pci_pf_set(struct devlink_por=
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
index 0113bc4db9f5..57065722b9c3 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -200,6 +200,10 @@ enum devlink_port_flavour {
 	DEVLINK_PORT_FLAVOUR_UNUSED, /* Port which exists in the switch, but
 				      * is not used in any way.
 				      */
+	DEVLINK_PORT_FLAVOUR_PCI_SF, /* Represents eswitch port
+				      * for the PCI SF. It is an internal
+				      * port that faces the PCI SF.
+				      */
 };
=20
 enum devlink_param_cmode {
@@ -527,6 +531,7 @@ enum devlink_attr {
 	DEVLINK_ATTR_RELOAD_STATS_VALUE,	/* u32 */
 	DEVLINK_ATTR_REMOTE_RELOAD_STATS,	/* nested */
=20
+	DEVLINK_ATTR_PORT_PCI_SF_NUMBER,	/* u32 */
 	/* add new attributes above here, update the policy in devlink.c */
=20
 	__DEVLINK_ATTR_MAX,
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 75cca9cbb9d9..b1e849b624a6 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -673,6 +673,15 @@ static int devlink_nl_port_attrs_put(struct sk_buff *m=
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
+		if (nla_put_u8(msg, DEVLINK_ATTR_PORT_EXTERNAL, attrs->pci_sf.external))
+			return -EMSGSIZE;
+		break;
 	case DEVLINK_PORT_FLAVOUR_PHYSICAL:
 	case DEVLINK_PORT_FLAVOUR_CPU:
 	case DEVLINK_PORT_FLAVOUR_DSA:
@@ -8330,6 +8339,33 @@ void devlink_port_attrs_pci_vf_set(struct devlink_po=
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
+	if (WARN_ON(devlink_port->registered))
+		return;
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
@@ -8378,6 +8414,16 @@ static int __devlink_port_phys_port_name_get(struct =
devlink_port *devlink_port,
 		n =3D snprintf(name, len, "pf%uvf%u",
 			     attrs->pci_vf.pf, attrs->pci_vf.vf);
 		break;
+	case DEVLINK_PORT_FLAVOUR_PCI_SF:
+		if (attrs->pci_sf.external) {
+			n =3D snprintf(name, len, "c%u", attrs->pci_sf.controller);
+			if (n >=3D len)
+				return -EINVAL;
+			len -=3D n;
+			name +=3D n;
+		}
+		n =3D snprintf(name, len, "pf%usf%u", attrs->pci_sf.pf, attrs->pci_sf.sf=
);
+		break;
 	}
=20
 	if (n >=3D len)
--=20
2.26.2

