Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A025612A8
	for <lists+netdev@lfdr.de>; Sat,  6 Jul 2019 20:24:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727117AbfGFSYD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Jul 2019 14:24:03 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:34897 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726889AbfGFSYD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Jul 2019 14:24:03 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from parav@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 6 Jul 2019 21:23:58 +0300
Received: from sw-mtx-036.mtx.labs.mlnx (sw-mtx-036.mtx.labs.mlnx [10.12.150.149])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x66INsxZ019619;
        Sat, 6 Jul 2019 21:23:57 +0300
From:   Parav Pandit <parav@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     jiri@mellanox.com, saeedm@mellanox.com,
        jakub.kicinski@netronome.com, Parav Pandit <parav@mellanox.com>
Subject: [PATCH net-next v4 2/4] devlink: Introduce PCI PF port flavour and port attribute
Date:   Sat,  6 Jul 2019 13:23:48 -0500
Message-Id: <20190706182350.11929-3-parav@mellanox.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190706182350.11929-1-parav@mellanox.com>
References: <20190701122734.18770-1-parav@mellanox.com>
 <20190706182350.11929-1-parav@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In an eswitch, PCI PF may have port which is normally represented
using a representor netdevice.
To have better visibility of eswitch port, its association with
PF and a representor netdevice, introduce a PCI PF port
flavour and port attriute.

When devlink port flavour is PCI PF, fill up PCI PF attributes of the
port.

Extend port name creation using PCI PF number on best effort basis.
So that vendor drivers can skip defining their own scheme.

$ devlink port show
pci/0000:05:00.0/0: type eth netdev eth0 flavour pcipf pfnum 0

Signed-off-by: Parav Pandit <parav@mellanox.com>
---
Changelog:
v3->v4:
 - Addressed comments from Jiri.
 - Renamed phys_port to physical to be consistent with pci_pf.
 - Removed port_number from __devlink_port_attrs_set and moved
   assigment to caller function.
 - Used capital letter while moving old comment to new structure.
 - Removed helper function is_devlink_phy_port_num_supported().
v2->v3:
 - Address comments from Jakub.
 - Made port_number and split_port_number applicable only to
   physical port flavours by having in union.
v1->v2:
 - Limited port_num attribute to physical ports
 - Updated PCI PF attribute set API to not have port_number
---
 include/net/devlink.h        |  8 ++++++++
 include/uapi/linux/devlink.h |  5 +++++
 net/core/devlink.c           | 34 ++++++++++++++++++++++++++++++++++
 3 files changed, 47 insertions(+)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index c79a1370867a..2a8eaaff3d4b 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -46,6 +46,10 @@ struct devlink_port_phys_attrs {
 	u32 split_subport_number;
 };
 
+struct devlink_port_pci_pf_attrs {
+	u16 pf;	/* Associated PCI PF for this port. */
+};
+
 struct devlink_port_attrs {
 	u8 set:1,
 	   split:1,
@@ -54,6 +58,7 @@ struct devlink_port_attrs {
 	struct netdev_phys_item_id switch_id;
 	union {
 		struct devlink_port_phys_attrs physical;
+		struct devlink_port_pci_pf_attrs pci_pf;
 	};
 };
 
@@ -599,6 +604,9 @@ void devlink_port_attrs_set(struct devlink_port *devlink_port,
 			    u32 split_subport_number,
 			    const unsigned char *switch_id,
 			    unsigned char switch_id_len);
+void devlink_port_attrs_pci_pf_set(struct devlink_port *devlink_port,
+				   const unsigned char *switch_id,
+				   unsigned char switch_id_len, u16 pf);
 int devlink_sb_register(struct devlink *devlink, unsigned int sb_index,
 			u32 size, u16 ingress_pools_count,
 			u16 egress_pools_count, u16 ingress_tc_count,
diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index 5287b42c181f..f7323884c3fe 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -169,6 +169,10 @@ enum devlink_port_flavour {
 	DEVLINK_PORT_FLAVOUR_DSA, /* Distributed switch architecture
 				   * interconnect port.
 				   */
+	DEVLINK_PORT_FLAVOUR_PCI_PF, /* Represents eswitch port for
+				      * the PCI PF. It is an internal
+				      * port that faces the PCI PF.
+				      */
 };
 
 enum devlink_param_cmode {
@@ -337,6 +341,7 @@ enum devlink_attr {
 	DEVLINK_ATTR_FLASH_UPDATE_STATUS_DONE,	/* u64 */
 	DEVLINK_ATTR_FLASH_UPDATE_STATUS_TOTAL,	/* u64 */
 
+	DEVLINK_ATTR_PORT_PCI_PF_NUMBER,	/* u16 */
 	/* add new attributes above here, update the policy in devlink.c */
 
 	__DEVLINK_ATTR_MAX,
diff --git a/net/core/devlink.c b/net/core/devlink.c
index db6fa6bb9b33..3717eae8a502 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -515,6 +515,11 @@ static int devlink_nl_port_attrs_put(struct sk_buff *msg,
 		return 0;
 	if (nla_put_u16(msg, DEVLINK_ATTR_PORT_FLAVOUR, attrs->flavour))
 		return -EMSGSIZE;
+	if (devlink_port->attrs.flavour == DEVLINK_PORT_FLAVOUR_PCI_PF) {
+		if (nla_put_u16(msg, DEVLINK_ATTR_PORT_PCI_PF_NUMBER,
+				attrs->pci_pf.pf))
+			return -EMSGSIZE;
+	}
 	if (devlink_port->attrs.flavour == DEVLINK_PORT_FLAVOUR_PHYSICAL ||
 	    devlink_port->attrs.flavour == DEVLINK_PORT_FLAVOUR_CPU ||
 	    devlink_port->attrs.flavour == DEVLINK_PORT_FLAVOUR_DSA)
@@ -5801,6 +5806,32 @@ void devlink_port_attrs_set(struct devlink_port *devlink_port,
 }
 EXPORT_SYMBOL_GPL(devlink_port_attrs_set);
 
+/**
+ *	devlink_port_attrs_pci_pf_set - Set PCI PF port attributes
+ *
+ *	@devlink_port: devlink port
+ *	@pf: associated PF for the devlink port instance
+ *	@switch_id: if the port is part of switch, this is buffer with ID,
+ *	            otwerwise this is NULL
+ *	@switch_id_len: length of the switch_id buffer
+ */
+void devlink_port_attrs_pci_pf_set(struct devlink_port *devlink_port,
+				   const unsigned char *switch_id,
+				   unsigned char switch_id_len, u16 pf)
+{
+	struct devlink_port_attrs *attrs = &devlink_port->attrs;
+	int ret;
+
+	ret = __devlink_port_attrs_set(devlink_port,
+				       DEVLINK_PORT_FLAVOUR_PCI_PF,
+				       switch_id, switch_id_len);
+	if (ret)
+		return;
+
+	attrs->pci_pf.pf = pf;
+}
+EXPORT_SYMBOL_GPL(devlink_port_attrs_pci_pf_set);
+
 static int __devlink_port_phys_port_name_get(struct devlink_port *devlink_port,
 					     char *name, size_t len)
 {
@@ -5827,6 +5858,9 @@ static int __devlink_port_phys_port_name_get(struct devlink_port *devlink_port,
 		 */
 		WARN_ON(1);
 		return -EINVAL;
+	case DEVLINK_PORT_FLAVOUR_PCI_PF:
+		n = snprintf(name, len, "pf%u", attrs->pci_pf.pf);
+		break;
 	}
 
 	if (n >= len)
-- 
2.19.2

