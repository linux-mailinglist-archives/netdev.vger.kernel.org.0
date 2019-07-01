Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A735F5BB76
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 14:27:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728572AbfGAM1v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 08:27:51 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:52145 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728351AbfGAM1v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 08:27:51 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from parav@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 1 Jul 2019 15:27:45 +0300
Received: from sw-mtx-036.mtx.labs.mlnx (sw-mtx-036.mtx.labs.mlnx [10.12.150.149])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x61CRerx003688;
        Mon, 1 Jul 2019 15:27:44 +0300
From:   Parav Pandit <parav@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     jiri@mellanox.com, saeedm@mellanox.com,
        jakub.kicinski@netronome.com, Parav Pandit <parav@mellanox.com>
Subject: [PATCH net-next 2/3] devlink: Introduce PCI VF port flavour and port attribute
Date:   Mon,  1 Jul 2019 07:27:33 -0500
Message-Id: <20190701122734.18770-3-parav@mellanox.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190701122734.18770-1-parav@mellanox.com>
References: <20190701122734.18770-1-parav@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In an eswitch, PCI VF may have port which is normally represented using
a representor netdevice.
To have better visibility of eswitch port, its association with VF,
its representor netdevice and port number, introduce a PCI VF
port flavour.

When devlink port flavour is PCI VF, fill up PCI VF attributes of
the port.

Extend port name creation using PCI PF and VF number scheme on best
effort basis, so that vendor drivers can skip defining their own scheme.

$ devlink port show
pci/0000:05:00.0/0: type eth netdev eth0 flavour pcipf pfnum 0
pci/0000:05:00.0/1: type eth netdev eth1 flavour pcivf pfnum 0 vfnum 0
pci/0000:05:00.0/2: type eth netdev eth2 flavour pcivf pfnum 0 vfnum 1

Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Parav Pandit <parav@mellanox.com>
---
 include/net/devlink.h        | 11 +++++++++++
 include/uapi/linux/devlink.h |  6 ++++++
 net/core/devlink.c           | 36 ++++++++++++++++++++++++++++++++++++
 3 files changed, 53 insertions(+)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index 8db9c0e83fb5..dff7c7797f3e 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -42,6 +42,11 @@ struct devlink_port_pci_pf_attrs {
 	u16 pf;	/* Associated PCI PF for this port. */
 };
 
+struct devlink_port_pci_vf_attrs {
+	u16 pf;	/* Associated PCI PF for this port. */
+	u16 vf;	/* Associated PCI VF for of the PCI PF for this port. */
+};
+
 struct devlink_port_attrs {
 	u8 set:1,
 	   split:1,
@@ -52,6 +57,7 @@ struct devlink_port_attrs {
 	struct netdev_phys_item_id switch_id;
 	union {
 		struct devlink_port_pci_pf_attrs pci_pf;
+		struct devlink_port_pci_vf_attrs pci_vf;
 	};
 };
 
@@ -601,6 +607,11 @@ void devlink_port_attrs_pci_pf_set(struct devlink_port *devlink_port,
 				   u32 port_number,
 				   const unsigned char *switch_id,
 				   unsigned char switch_id_len, u16 pf);
+void devlink_port_attrs_pci_vf_set(struct devlink_port *devlink_port,
+				   u32 port_number,
+				   const unsigned char *switch_id,
+				   unsigned char switch_id_len,
+				   u16 pf, u16 vf);
 int devlink_sb_register(struct devlink *devlink, unsigned int sb_index,
 			u32 size, u16 ingress_pools_count,
 			u16 egress_pools_count, u16 ingress_tc_count,
diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index f7323884c3fe..ffc993256527 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -173,6 +173,10 @@ enum devlink_port_flavour {
 				      * the PCI PF. It is an internal
 				      * port that faces the PCI PF.
 				      */
+	DEVLINK_PORT_FLAVOUR_PCI_VF, /* Represents eswitch port
+				      * for the PCI VF. It is an internal
+				      * port that faces the PCI VF.
+				      */
 };
 
 enum devlink_param_cmode {
@@ -342,6 +346,8 @@ enum devlink_attr {
 	DEVLINK_ATTR_FLASH_UPDATE_STATUS_TOTAL,	/* u64 */
 
 	DEVLINK_ATTR_PORT_PCI_PF_NUMBER,	/* u16 */
+	DEVLINK_ATTR_PORT_PCI_VF_NUMBER,	/* u16 */
+
 	/* add new attributes above here, update the policy in devlink.c */
 
 	__DEVLINK_ATTR_MAX,
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 001f9e2c96f0..d62c4591351b 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -521,6 +521,12 @@ static int devlink_nl_port_attrs_put(struct sk_buff *msg,
 		if (nla_put_u16(msg, DEVLINK_ATTR_PORT_PCI_PF_NUMBER,
 				attrs->pci_pf.pf))
 			return -EMSGSIZE;
+	} else if (devlink_port->attrs.flavour == DEVLINK_PORT_FLAVOUR_PCI_VF) {
+		if (nla_put_u16(msg, DEVLINK_ATTR_PORT_PCI_PF_NUMBER,
+				attrs->pci_vf.pf) ||
+		    nla_put_u16(msg, DEVLINK_ATTR_PORT_PCI_VF_NUMBER,
+				attrs->pci_vf.vf))
+			return -EMSGSIZE;
 	}
 	if (!attrs->split)
 		return 0;
@@ -5820,6 +5826,32 @@ void devlink_port_attrs_pci_pf_set(struct devlink_port *devlink_port,
 }
 EXPORT_SYMBOL_GPL(devlink_port_attrs_pci_pf_set);
 
+/**
+ *	devlink_port_attrs_pci_vf_set - Set PCI VF port attributes
+ *
+ *	@devlink_port: devlink port
+ *	@port_number: number of the port that is facing a VF
+ *	@pf: associated PF for the devlink port instance
+ *	@vf: associated VF of a PF for the devlink port instance
+ *	@switch_id: if the port is part of switch, this is buffer with ID,
+ *	            otwerwise this is NULL
+ *	@switch_id_len: length of the switch_id buffer
+ */
+void devlink_port_attrs_pci_vf_set(struct devlink_port *devlink_port,
+				   u32 port_number,
+				   const unsigned char *switch_id,
+				   unsigned char switch_id_len,
+				   u16 pf, u16 vf)
+{
+	struct devlink_port_attrs *attrs = &devlink_port->attrs;
+
+	__devlink_port_attrs_set(devlink_port, DEVLINK_PORT_FLAVOUR_PCI_VF,
+				 port_number, switch_id, switch_id_len);
+	attrs->pci_vf.pf = pf;
+	attrs->pci_vf.vf = vf;
+}
+EXPORT_SYMBOL_GPL(devlink_port_attrs_pci_vf_set);
+
 static int __devlink_port_phys_port_name_get(struct devlink_port *devlink_port,
 					     char *name, size_t len)
 {
@@ -5847,6 +5879,10 @@ static int __devlink_port_phys_port_name_get(struct devlink_port *devlink_port,
 	case DEVLINK_PORT_FLAVOUR_PCI_PF:
 		n = snprintf(name, len, "pf%u", attrs->pci_pf.pf);
 		break;
+	case DEVLINK_PORT_FLAVOUR_PCI_VF:
+		n = snprintf(name, len, "pf%uvf%u",
+			     attrs->pci_vf.pf, attrs->pci_vf.vf);
+		break;
 	}
 
 	if (n >= len)
-- 
2.19.2

