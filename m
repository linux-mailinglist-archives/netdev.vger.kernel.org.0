Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BCAA2D3C3B
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 08:32:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727449AbgLIHa4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 02:30:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:60312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725993AbgLIHaz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Dec 2020 02:30:55 -0500
From:   saeed@kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>,
        david.m.ertman@intel.com, dan.j.williams@intel.com,
        kiran.patil@intel.com, gregkh@linuxfoundation.org,
        Parav Pandit <parav@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Vu Pham <vuhuong@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH net-next v2 02/14] devlink: Introduce PCI SF port flavour and port attribute
Date:   Tue,  8 Dec 2020 23:29:22 -0800
Message-Id: <20201209072934.1272819-3-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201209072934.1272819-1-saeed@kernel.org>
References: <20201209072934.1272819-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@nvidia.com>

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
pci/0000:06:00.0/32768: type eth netdev ens2f0npf0sf88 flavour pcisf controller 0 pfnum 0 sfnum 88 external false splittable false
  function:
    hw_addr 00:00:00:00:88:88 state active opstate attached

$ devlink port show pci/0000:06:00.0/32768 -jp
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

Signed-off-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Vu Pham <vuhuong@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 include/net/devlink.h        | 17 +++++++++++++
 include/uapi/linux/devlink.h |  5 ++++
 net/core/devlink.c           | 46 ++++++++++++++++++++++++++++++++++++
 3 files changed, 68 insertions(+)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index f466819cc477..5bd43f0a79a8 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -93,6 +93,20 @@ struct devlink_port_pci_vf_attrs {
 	u8 external:1;
 };
 
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
@@ -114,6 +128,7 @@ struct devlink_port_attrs {
 		struct devlink_port_phys_attrs phys;
 		struct devlink_port_pci_pf_attrs pci_pf;
 		struct devlink_port_pci_vf_attrs pci_vf;
+		struct devlink_port_pci_sf_attrs pci_sf;
 	};
 };
 
@@ -1404,6 +1419,8 @@ void devlink_port_attrs_pci_pf_set(struct devlink_port *devlink_port, u32 contro
 				   u16 pf, bool external);
 void devlink_port_attrs_pci_vf_set(struct devlink_port *devlink_port, u32 controller,
 				   u16 pf, u16 vf, bool external);
+void devlink_port_attrs_pci_sf_set(struct devlink_port *devlink_port, u32 controller,
+				   u16 pf, u32 sf, bool external);
 int devlink_sb_register(struct devlink *devlink, unsigned int sb_index,
 			u32 size, u16 ingress_pools_count,
 			u16 egress_pools_count, u16 ingress_tc_count,
diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index 5203f54a2be1..6fe00f10eb3f 100644
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
 
 enum devlink_param_cmode {
@@ -529,6 +533,7 @@ enum devlink_attr {
 	DEVLINK_ATTR_RELOAD_ACTION_INFO,        /* nested */
 	DEVLINK_ATTR_RELOAD_ACTION_STATS,       /* nested */
 
+	DEVLINK_ATTR_PORT_PCI_SF_NUMBER,	/* u32 */
 	/* add new attributes above here, update the policy in devlink.c */
 
 	__DEVLINK_ATTR_MAX,
diff --git a/net/core/devlink.c b/net/core/devlink.c
index d812ed26a330..8a33b3150d1a 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -690,6 +690,15 @@ static int devlink_nl_port_attrs_put(struct sk_buff *msg,
 		if (nla_put_u8(msg, DEVLINK_ATTR_PORT_EXTERNAL, attrs->pci_vf.external))
 			return -EMSGSIZE;
 		break;
+	case DEVLINK_PORT_FLAVOUR_PCI_SF:
+		if (nla_put_u32(msg, DEVLINK_ATTR_PORT_CONTROLLER_NUMBER,
+				attrs->pci_sf.controller) ||
+		    nla_put_u16(msg, DEVLINK_ATTR_PORT_PCI_PF_NUMBER, attrs->pci_sf.pf) ||
+		    nla_put_u32(msg, DEVLINK_ATTR_PORT_PCI_SF_NUMBER, attrs->pci_sf.sf))
+			return -EMSGSIZE;
+		if (nla_put_u8(msg, DEVLINK_ATTR_PORT_EXTERNAL, attrs->pci_sf.external))
+			return -EMSGSIZE;
+		break;
 	case DEVLINK_PORT_FLAVOUR_PHYSICAL:
 	case DEVLINK_PORT_FLAVOUR_CPU:
 	case DEVLINK_PORT_FLAVOUR_DSA:
@@ -8378,6 +8387,33 @@ void devlink_port_attrs_pci_vf_set(struct devlink_port *devlink_port, u32 contro
 }
 EXPORT_SYMBOL_GPL(devlink_port_attrs_pci_vf_set);
 
+/**
+ *	devlink_port_attrs_pci_sf_set - Set PCI SF port attributes
+ *
+ *	@devlink_port: devlink port
+ *	@controller: associated controller number for the devlink port instance
+ *	@pf: associated PF for the devlink port instance
+ *	@sf: associated SF of a PF for the devlink port instance
+ *	@external: indicates if the port is for an external controller
+ */
+void devlink_port_attrs_pci_sf_set(struct devlink_port *devlink_port, u32 controller,
+				   u16 pf, u32 sf, bool external)
+{
+	struct devlink_port_attrs *attrs = &devlink_port->attrs;
+	int ret;
+
+	if (WARN_ON(devlink_port->registered))
+		return;
+	ret = __devlink_port_attrs_set(devlink_port, DEVLINK_PORT_FLAVOUR_PCI_SF);
+	if (ret)
+		return;
+	attrs->pci_sf.controller = controller;
+	attrs->pci_sf.pf = pf;
+	attrs->pci_sf.sf = sf;
+	attrs->pci_sf.external = external;
+}
+EXPORT_SYMBOL_GPL(devlink_port_attrs_pci_sf_set);
+
 static int __devlink_port_phys_port_name_get(struct devlink_port *devlink_port,
 					     char *name, size_t len)
 {
@@ -8426,6 +8462,16 @@ static int __devlink_port_phys_port_name_get(struct devlink_port *devlink_port,
 		n = snprintf(name, len, "pf%uvf%u",
 			     attrs->pci_vf.pf, attrs->pci_vf.vf);
 		break;
+	case DEVLINK_PORT_FLAVOUR_PCI_SF:
+		if (attrs->pci_sf.external) {
+			n = snprintf(name, len, "c%u", attrs->pci_sf.controller);
+			if (n >= len)
+				return -EINVAL;
+			len -= n;
+			name += n;
+		}
+		n = snprintf(name, len, "pf%usf%u", attrs->pci_sf.pf, attrs->pci_sf.sf);
+		break;
 	}
 
 	if (n >= len)
-- 
2.26.2

