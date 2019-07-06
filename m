Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C19DA60F35
	for <lists+netdev@lfdr.de>; Sat,  6 Jul 2019 08:16:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726038AbfGFGQi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Jul 2019 02:16:38 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:50600 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725973AbfGFGQh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Jul 2019 02:16:37 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from parav@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 6 Jul 2019 09:16:31 +0300
Received: from sw-mtx-036.mtx.labs.mlnx (sw-mtx-036.mtx.labs.mlnx [10.12.150.149])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x666GS6D028564;
        Sat, 6 Jul 2019 09:16:30 +0300
From:   Parav Pandit <parav@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     jiri@mellanox.com, saeedm@mellanox.com,
        jakub.kicinski@netronome.com, Parav Pandit <parav@mellanox.com>
Subject: [PATCH net-next v3 1/3] devlink: Introduce PCI PF port flavour and port attribute
Date:   Sat,  6 Jul 2019 01:16:24 -0500
Message-Id: <20190706061626.31440-2-parav@mellanox.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190706061626.31440-1-parav@mellanox.com>
References: <20190701122734.18770-1-parav@mellanox.com>
 <20190706061626.31440-1-parav@mellanox.com>
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
v2->v3:
 - Address comments from Jakub.
 - Made port_number and split_port_number applicable only to
   physical port flavours by having in union.
v1->v2:
 - Limited port_num attribute to physical ports
 - Updated PCI PF attribute set API to not have port_number
---
 include/net/devlink.h        | 21 +++++++-
 include/uapi/linux/devlink.h |  5 ++
 net/core/devlink.c           | 97 ++++++++++++++++++++++++++++--------
 3 files changed, 100 insertions(+), 23 deletions(-)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index 6625ea068d5e..1455f60e4069 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -38,13 +38,27 @@ struct devlink {
 	char priv[0] __aligned(NETDEV_ALIGN);
 };
 
+struct devlink_port_phys_attrs {
+	u32 port_number; /* same value as "split group".
+			  * A physical port which is visible to the user
+			  * for a given port flavour.
+			  */
+	u32 split_subport_number;
+};
+
+struct devlink_port_pci_pf_attrs {
+	u16 pf;	/* Associated PCI PF for this port. */
+};
+
 struct devlink_port_attrs {
 	u8 set:1,
 	   split:1,
 	   switch_port:1;
 	enum devlink_port_flavour flavour;
-	u32 port_number; /* same value as "split group" */
-	u32 split_subport_number;
+	union {
+		struct devlink_port_phys_attrs phys_port;
+		struct devlink_port_pci_pf_attrs pci_pf;
+	};
 	struct netdev_phys_item_id switch_id;
 };
 
@@ -590,6 +604,9 @@ void devlink_port_attrs_set(struct devlink_port *devlink_port,
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
index 89c533778135..9aa36104b471 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -506,6 +506,14 @@ static void devlink_notify(struct devlink *devlink, enum devlink_command cmd)
 				msg, 0, DEVLINK_MCGRP_CONFIG, GFP_KERNEL);
 }
 
+static bool
+is_devlink_phy_port_num_supported(const struct devlink_port *dl_port)
+{
+	return (dl_port->attrs.flavour == DEVLINK_PORT_FLAVOUR_PHYSICAL ||
+		dl_port->attrs.flavour == DEVLINK_PORT_FLAVOUR_CPU ||
+		dl_port->attrs.flavour == DEVLINK_PORT_FLAVOUR_DSA);
+}
+
 static int devlink_nl_port_attrs_put(struct sk_buff *msg,
 				     struct devlink_port *devlink_port)
 {
@@ -515,14 +523,23 @@ static int devlink_nl_port_attrs_put(struct sk_buff *msg,
 		return 0;
 	if (nla_put_u16(msg, DEVLINK_ATTR_PORT_FLAVOUR, attrs->flavour))
 		return -EMSGSIZE;
-	if (nla_put_u32(msg, DEVLINK_ATTR_PORT_NUMBER, attrs->port_number))
+	if (devlink_port->attrs.flavour == DEVLINK_PORT_FLAVOUR_PCI_PF) {
+		if (nla_put_u16(msg, DEVLINK_ATTR_PORT_PCI_PF_NUMBER,
+				attrs->pci_pf.pf))
+			return -EMSGSIZE;
+	}
+	if (!is_devlink_phy_port_num_supported(devlink_port))
+		return 0;
+	if (nla_put_u32(msg, DEVLINK_ATTR_PORT_NUMBER,
+			attrs->phys_port.port_number))
 		return -EMSGSIZE;
 	if (!attrs->split)
 		return 0;
-	if (nla_put_u32(msg, DEVLINK_ATTR_PORT_SPLIT_GROUP, attrs->port_number))
+	if (nla_put_u32(msg, DEVLINK_ATTR_PORT_SPLIT_GROUP,
+			attrs->phys_port.port_number))
 		return -EMSGSIZE;
 	if (nla_put_u32(msg, DEVLINK_ATTR_PORT_SPLIT_SUBPORT_NUMBER,
-			attrs->split_subport_number))
+			attrs->phys_port.split_subport_number))
 		return -EMSGSIZE;
 	return 0;
 }
@@ -5738,6 +5755,30 @@ void devlink_port_type_clear(struct devlink_port *devlink_port)
 }
 EXPORT_SYMBOL_GPL(devlink_port_type_clear);
 
+static void __devlink_port_attrs_set(struct devlink_port *devlink_port,
+				     enum devlink_port_flavour flavour,
+				     u32 port_number,
+				     const unsigned char *switch_id,
+				     unsigned char switch_id_len)
+{
+	struct devlink_port_attrs *attrs = &devlink_port->attrs;
+
+	if (WARN_ON(devlink_port->registered))
+		return;
+	attrs->set = true;
+	attrs->flavour = flavour;
+	attrs->phys_port.port_number = port_number;
+	if (switch_id) {
+		attrs->switch_port = true;
+		if (WARN_ON(switch_id_len > MAX_PHYS_ITEM_ID_LEN))
+			switch_id_len = MAX_PHYS_ITEM_ID_LEN;
+		memcpy(attrs->switch_id.id, switch_id, switch_id_len);
+		attrs->switch_id.id_len = switch_id_len;
+	} else {
+		attrs->switch_port = false;
+	}
+}
+
 /**
  *	devlink_port_attrs_set - Set port attributes
  *
@@ -5761,25 +5802,34 @@ void devlink_port_attrs_set(struct devlink_port *devlink_port,
 {
 	struct devlink_port_attrs *attrs = &devlink_port->attrs;
 
-	if (WARN_ON(devlink_port->registered))
-		return;
-	attrs->set = true;
-	attrs->flavour = flavour;
-	attrs->port_number = port_number;
+	__devlink_port_attrs_set(devlink_port, flavour, port_number,
+				 switch_id, switch_id_len);
 	attrs->split = split;
-	attrs->split_subport_number = split_subport_number;
-	if (switch_id) {
-		attrs->switch_port = true;
-		if (WARN_ON(switch_id_len > MAX_PHYS_ITEM_ID_LEN))
-			switch_id_len = MAX_PHYS_ITEM_ID_LEN;
-		memcpy(attrs->switch_id.id, switch_id, switch_id_len);
-		attrs->switch_id.id_len = switch_id_len;
-	} else {
-		attrs->switch_port = false;
-	}
+	attrs->phys_port.split_subport_number = split_subport_number;
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
+
+	__devlink_port_attrs_set(devlink_port, DEVLINK_PORT_FLAVOUR_PCI_PF,
+				 0, switch_id, switch_id_len);
+	attrs->pci_pf.pf = pf;
+}
+EXPORT_SYMBOL_GPL(devlink_port_attrs_pci_pf_set);
+
 static int __devlink_port_phys_port_name_get(struct devlink_port *devlink_port,
 					     char *name, size_t len)
 {
@@ -5792,10 +5842,12 @@ static int __devlink_port_phys_port_name_get(struct devlink_port *devlink_port,
 	switch (attrs->flavour) {
 	case DEVLINK_PORT_FLAVOUR_PHYSICAL:
 		if (!attrs->split)
-			n = snprintf(name, len, "p%u", attrs->port_number);
+			n = snprintf(name, len, "p%u",
+				     attrs->phys_port.port_number);
 		else
-			n = snprintf(name, len, "p%us%u", attrs->port_number,
-				     attrs->split_subport_number);
+			n = snprintf(name, len, "p%us%u",
+				     attrs->phys_port.port_number,
+				     attrs->phys_port.split_subport_number);
 		break;
 	case DEVLINK_PORT_FLAVOUR_CPU:
 	case DEVLINK_PORT_FLAVOUR_DSA:
@@ -5804,6 +5856,9 @@ static int __devlink_port_phys_port_name_get(struct devlink_port *devlink_port,
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

