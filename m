Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 331A45BB75
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 14:27:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728339AbfGAM1r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 08:27:47 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:52131 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727645AbfGAM1r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 08:27:47 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from parav@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 1 Jul 2019 15:27:43 +0300
Received: from sw-mtx-036.mtx.labs.mlnx (sw-mtx-036.mtx.labs.mlnx [10.12.150.149])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x61CRerw003688;
        Mon, 1 Jul 2019 15:27:42 +0300
From:   Parav Pandit <parav@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     jiri@mellanox.com, saeedm@mellanox.com,
        jakub.kicinski@netronome.com, Parav Pandit <parav@mellanox.com>
Subject: [PATCH net-next 1/3] devlink: Introduce PCI PF port flavour and port attribute
Date:   Mon,  1 Jul 2019 07:27:32 -0500
Message-Id: <20190701122734.18770-2-parav@mellanox.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190701122734.18770-1-parav@mellanox.com>
References: <20190701122734.18770-1-parav@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In an eswitch, PCI PF may have port which is normally represented
using a representor netdevice.
To have better visibility of eswitch port, its association with
PF, a representor netdevice and port number, introduce a PCI PF port
flavour and port attriute.

When devlink port flavour is PCI PF, fill up PCI PF attributes of the
port.

Extend port name creation using PCI PF number on best effort basis.
So that vendor drivers can skip defining their own scheme.

$ devlink port show
pci/0000:05:00.0/0: type eth netdev eth0 flavour pcipf pfnum 0

Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Parav Pandit <parav@mellanox.com>
---
 include/net/devlink.h        | 11 ++++++
 include/uapi/linux/devlink.h |  5 +++
 net/core/devlink.c           | 71 +++++++++++++++++++++++++++++-------
 3 files changed, 73 insertions(+), 14 deletions(-)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index 6625ea068d5e..8db9c0e83fb5 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -38,6 +38,10 @@ struct devlink {
 	char priv[0] __aligned(NETDEV_ALIGN);
 };
 
+struct devlink_port_pci_pf_attrs {
+	u16 pf;	/* Associated PCI PF for this port. */
+};
+
 struct devlink_port_attrs {
 	u8 set:1,
 	   split:1,
@@ -46,6 +50,9 @@ struct devlink_port_attrs {
 	u32 port_number; /* same value as "split group" */
 	u32 split_subport_number;
 	struct netdev_phys_item_id switch_id;
+	union {
+		struct devlink_port_pci_pf_attrs pci_pf;
+	};
 };
 
 struct devlink_port {
@@ -590,6 +597,10 @@ void devlink_port_attrs_set(struct devlink_port *devlink_port,
 			    u32 split_subport_number,
 			    const unsigned char *switch_id,
 			    unsigned char switch_id_len);
+void devlink_port_attrs_pci_pf_set(struct devlink_port *devlink_port,
+				   u32 port_number,
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
index 89c533778135..001f9e2c96f0 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -517,6 +517,11 @@ static int devlink_nl_port_attrs_put(struct sk_buff *msg,
 		return -EMSGSIZE;
 	if (nla_put_u32(msg, DEVLINK_ATTR_PORT_NUMBER, attrs->port_number))
 		return -EMSGSIZE;
+	if (devlink_port->attrs.flavour == DEVLINK_PORT_FLAVOUR_PCI_PF) {
+		if (nla_put_u16(msg, DEVLINK_ATTR_PORT_PCI_PF_NUMBER,
+				attrs->pci_pf.pf))
+			return -EMSGSIZE;
+	}
 	if (!attrs->split)
 		return 0;
 	if (nla_put_u32(msg, DEVLINK_ATTR_PORT_SPLIT_GROUP, attrs->port_number))
@@ -5738,6 +5743,30 @@ void devlink_port_type_clear(struct devlink_port *devlink_port)
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
+	attrs->port_number = port_number;
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
@@ -5761,25 +5790,36 @@ void devlink_port_attrs_set(struct devlink_port *devlink_port,
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
 	attrs->split_subport_number = split_subport_number;
-	if (switch_id) {
-		attrs->switch_port = true;
-		if (WARN_ON(switch_id_len > MAX_PHYS_ITEM_ID_LEN))
-			switch_id_len = MAX_PHYS_ITEM_ID_LEN;
-		memcpy(attrs->switch_id.id, switch_id, switch_id_len);
-		attrs->switch_id.id_len = switch_id_len;
-	} else {
-		attrs->switch_port = false;
-	}
 }
 EXPORT_SYMBOL_GPL(devlink_port_attrs_set);
 
+/**
+ *	devlink_port_attrs_pci_pf_set - Set PCI PF port attributes
+ *
+ *	@devlink_port: devlink port
+ *	@port_number: number of the port that is facing a PF
+ *	@pf: associated PF for the devlink port instance
+ *	@switch_id: if the port is part of switch, this is buffer with ID,
+ *	            otwerwise this is NULL
+ *	@switch_id_len: length of the switch_id buffer
+ */
+void devlink_port_attrs_pci_pf_set(struct devlink_port *devlink_port,
+				   u32 port_number,
+				   const unsigned char *switch_id,
+				   unsigned char switch_id_len, u16 pf)
+{
+	struct devlink_port_attrs *attrs = &devlink_port->attrs;
+
+	__devlink_port_attrs_set(devlink_port, DEVLINK_PORT_FLAVOUR_PCI_PF,
+				 port_number, switch_id, switch_id_len);
+	attrs->pci_pf.pf = pf;
+}
+EXPORT_SYMBOL_GPL(devlink_port_attrs_pci_pf_set);
+
 static int __devlink_port_phys_port_name_get(struct devlink_port *devlink_port,
 					     char *name, size_t len)
 {
@@ -5804,6 +5844,9 @@ static int __devlink_port_phys_port_name_get(struct devlink_port *devlink_port,
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

