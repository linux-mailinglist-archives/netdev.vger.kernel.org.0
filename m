Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99794F3441
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 17:09:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389642AbfKGQJY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 11:09:24 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:53616 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2389604AbfKGQJX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 11:09:23 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from parav@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 7 Nov 2019 18:09:18 +0200
Received: from sw-mtx-036.mtx.labs.mlnx (sw-mtx-036.mtx.labs.mlnx [10.9.150.149])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id xA7G8d4M007213;
        Thu, 7 Nov 2019 18:09:16 +0200
From:   Parav Pandit <parav@mellanox.com>
To:     alex.williamson@redhat.com, davem@davemloft.net,
        kvm@vger.kernel.org, netdev@vger.kernel.org
Cc:     saeedm@mellanox.com, kwankhede@nvidia.com, leon@kernel.org,
        cohuck@redhat.com, jiri@mellanox.com, linux-rdma@vger.kernel.org,
        Parav Pandit <parav@mellanox.com>
Subject: [PATCH net-next 12/19] devlink: Introduce mdev port flavour
Date:   Thu,  7 Nov 2019 10:08:27 -0600
Message-Id: <20191107160834.21087-12-parav@mellanox.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20191107160834.21087-1-parav@mellanox.com>
References: <20191107160448.20962-1-parav@mellanox.com>
 <20191107160834.21087-1-parav@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce a new mdev port flavour for mdev devices.
PF.
Prepare such port's phys_port_name using unique mdev alias.

An example output for eswitch ports with one physical port and
one mdev port:

$ devlink port show
pci/0000:06:00.0/65535: type eth netdev p0 flavour physical port 0
pci/0000:06:00.0/32768: type eth netdev p1b0348cf880a flavour mdev alias 1b0348cf880a

Signed-off-by: Parav Pandit <parav@mellanox.com>
---
 include/net/devlink.h        |  9 +++++++++
 include/uapi/linux/devlink.h |  5 +++++
 net/core/devlink.c           | 32 ++++++++++++++++++++++++++++++++
 3 files changed, 46 insertions(+)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index 6bf3b9e0595a..fcffc7f7cff2 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -60,6 +60,10 @@ struct devlink_port_pci_vf_attrs {
 	u16 vf;	/* Associated PCI VF for of the PCI PF for this port. */
 };
 
+struct devlink_port_mdev_attrs {
+	const char *mdev_alias; /* Unique mdev alias used for this port. */
+};
+
 struct devlink_port_attrs {
 	u8 set:1,
 	   split:1,
@@ -70,6 +74,7 @@ struct devlink_port_attrs {
 		struct devlink_port_phys_attrs phys;
 		struct devlink_port_pci_pf_attrs pci_pf;
 		struct devlink_port_pci_vf_attrs pci_vf;
+		struct devlink_port_mdev_attrs mdev;
 	};
 };
 
@@ -802,6 +807,10 @@ void devlink_port_attrs_pci_vf_set(struct devlink_port *devlink_port,
 				   const unsigned char *switch_id,
 				   unsigned char switch_id_len,
 				   u16 pf, u16 vf);
+void devlink_port_attrs_mdev_set(struct devlink_port *devlink_port,
+				 const unsigned char *switch_id,
+				 unsigned char switch_id_len,
+				 const char *mdev_alias);
 int devlink_sb_register(struct devlink *devlink, unsigned int sb_index,
 			u32 size, u16 ingress_pools_count,
 			u16 egress_pools_count, u16 ingress_tc_count,
diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index b558ea88b766..db803c0d0e9f 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -187,6 +187,10 @@ enum devlink_port_flavour {
 				      * for the PCI VF. It is an internal
 				      * port that faces the PCI VF.
 				      */
+	DEVLINK_PORT_FLAVOUR_MDEV, /* Represents eswitch port for the
+				    * mdev device. It is an internal
+				    * port that faces the mdev device.
+				    */
 };
 
 enum devlink_param_cmode {
@@ -424,6 +428,7 @@ enum devlink_attr {
 	DEVLINK_ATTR_NETNS_FD,			/* u32 */
 	DEVLINK_ATTR_NETNS_PID,			/* u32 */
 	DEVLINK_ATTR_NETNS_ID,			/* u32 */
+	DEVLINK_ATTR_PORT_MDEV_ALIAS,		/* string */
 
 	/* add new attributes above here, update the policy in devlink.c */
 
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 97e9a2246929..cb7b6ef5d520 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -542,6 +542,11 @@ static int devlink_nl_port_attrs_put(struct sk_buff *msg,
 				attrs->pci_vf.vf))
 			return -EMSGSIZE;
 		break;
+	case DEVLINK_PORT_FLAVOUR_MDEV:
+		if (nla_put_string(msg, DEVLINK_ATTR_PORT_MDEV_ALIAS,
+				   attrs->mdev.mdev_alias))
+			return -EMSGSIZE;
+		break;
 	case DEVLINK_PORT_FLAVOUR_PHYSICAL:
 	case DEVLINK_PORT_FLAVOUR_CPU:
 	case DEVLINK_PORT_FLAVOUR_DSA:
@@ -6617,6 +6622,30 @@ void devlink_port_attrs_pci_vf_set(struct devlink_port *devlink_port,
 }
 EXPORT_SYMBOL_GPL(devlink_port_attrs_pci_vf_set);
 
+/**
+ *	devlink_port_attrs_mdev_set - Set mdev port attributes
+ *
+ *	@devlink_port: devlink port
+ *	@switch_id: if the port is part of switch, this is buffer with ID,
+ *	            otherwise this is NULL
+ *	@switch_id_len: length of the switch_id buffer
+ *	@mdev_alias: unique mdev alias for this port used to form phys_port_name
+ */
+void devlink_port_attrs_mdev_set(struct devlink_port *devlink_port,
+				 const unsigned char *switch_id,
+				 unsigned char switch_id_len,
+				 const char *mdev_alias)
+{
+	struct devlink_port_attrs *attrs = &devlink_port->attrs;
+
+	if (__devlink_port_attrs_set(devlink_port,
+				     DEVLINK_PORT_FLAVOUR_MDEV,
+				     switch_id, switch_id_len))
+		return;
+	attrs->mdev.mdev_alias = mdev_alias;
+}
+EXPORT_SYMBOL_GPL(devlink_port_attrs_mdev_set);
+
 static int __devlink_port_phys_port_name_get(struct devlink_port *devlink_port,
 					     char *name, size_t len)
 {
@@ -6649,6 +6678,9 @@ static int __devlink_port_phys_port_name_get(struct devlink_port *devlink_port,
 		n = snprintf(name, len, "pf%uvf%u",
 			     attrs->pci_vf.pf, attrs->pci_vf.vf);
 		break;
+	case DEVLINK_PORT_FLAVOUR_MDEV:
+		n = snprintf(name, len, "p%s", attrs->mdev.mdev_alias);
+		break;
 	}
 
 	if (n >= len)
-- 
2.19.2

