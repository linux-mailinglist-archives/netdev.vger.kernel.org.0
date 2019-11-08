Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D078EF50DF
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 17:19:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727477AbfKHQTC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 11:19:02 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:60270 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727352AbfKHQTC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 11:19:02 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from yuvalav@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 8 Nov 2019 18:18:59 +0200
Received: from sw-mtx-008.mtx.labs.mlnx (sw-mtx-008.mtx.labs.mlnx [10.9.150.35])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id xA8GIvmL003127;
        Fri, 8 Nov 2019 18:18:58 +0200
Received: from sw-mtx-008.mtx.labs.mlnx (localhost [127.0.0.1])
        by sw-mtx-008.mtx.labs.mlnx (8.14.7/8.14.7) with ESMTP id xA8GIurI030086;
        Fri, 8 Nov 2019 18:18:56 +0200
Received: (from yuvalav@localhost)
        by sw-mtx-008.mtx.labs.mlnx (8.14.7/8.14.7/Submit) id xA8GIuMp030085;
        Fri, 8 Nov 2019 18:18:56 +0200
From:   Yuval Avnery <yuvalav@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     jiri@mellanox.com, saeedm@mellanox.com, leon@kernel.org,
        davem@davemloft.net, jakub.kicinski@netronome.com,
        shuah@kernel.org, danielj@mellanox.com, parav@mellanox.com,
        andrew.gospodarek@broadcom.com, michael.chan@broadcom.com,
        Yuval Avnery <yuvalav@mellanox.com>
Subject: [PATCH net-next v2 03/10] devlink: Add port with subdev register support
Date:   Fri,  8 Nov 2019 18:18:39 +0200
Message-Id: <1573229926-30040-4-git-send-email-yuvalav@mellanox.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1573229926-30040-1-git-send-email-yuvalav@mellanox.com>
References: <1573229926-30040-1-git-send-email-yuvalav@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A subdev may represent a network device, so it may be linked to
a devlink port.
Added devlink_port_register_with_subdev to allow subdev-port linkage.

Example:

$ devlink subdev show pci/0000:03:00.0/1 -jp
{
    "subdev": {
        "pci/0000:03:00.0/1": {
            "flavour": "pcivf",
            "pf": 0,
            "vf": 0,
            "port_index": 1
        }
    }
}
$ devlink subdev show pci/0000:03:00.0/1
pci/0000:03:00.0/1: flavour pcivf pf 0 vf 0 port_index 1

$ devlink port show pci/0000:03:00.0/1
pci/0000:03:00.0/1: type eth netdev ens2f0_0 flavour pcivf pfnum 0 vfnum 0 subdev_index 1

Signed-off-by: Yuval Avnery <yuvalav@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 include/net/devlink.h |  5 ++++
 net/core/devlink.c    | 53 +++++++++++++++++++++++++++++++++++++++----
 2 files changed, 54 insertions(+), 4 deletions(-)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index 1e12a9be5c23..0cedd6d34ef8 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -90,6 +90,7 @@ struct devlink_port {
 	void *type_dev;
 	struct devlink_port_attrs attrs;
 	struct delayed_work type_warn_dw;
+	struct devlink_subdev *devlink_subdev; /* linked subdev */
 };
 
 struct devlink_subdev_pci_pf_attrs {
@@ -806,6 +807,10 @@ void devlink_free(struct devlink *devlink);
 int devlink_port_register(struct devlink *devlink,
 			  struct devlink_port *devlink_port,
 			  unsigned int port_index);
+int devlink_port_register_with_subdev(struct devlink *devlink,
+				    struct devlink_port *devlink_port,
+				    unsigned int port_index,
+				    struct devlink_subdev *devlink_subdev);
 void devlink_port_unregister(struct devlink_port *devlink_port);
 void devlink_port_type_eth_set(struct devlink_port *devlink_port,
 			       struct net_device *netdev);
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 76f5fba7d242..0c97c51dea0d 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -37,6 +37,7 @@ struct devlink_subdev {
 	unsigned int index;
 	const struct devlink_subdev_ops *ops;
 	struct devlink_subdev_attrs attrs;
+	struct devlink_port *devlink_port; /* linked port */
 	void *priv;
 };
 
@@ -664,6 +665,10 @@ static int devlink_nl_port_fill(struct sk_buff *msg, struct devlink *devlink,
 			goto nla_put_failure_type_locked;
 	}
 	spin_unlock_bh(&devlink_port->type_lock);
+	if (devlink_port->devlink_subdev)
+		if (nla_put_u32(msg, DEVLINK_ATTR_SUBDEV_INDEX,
+				devlink_port->devlink_subdev->index))
+			goto nla_put_failure;
 	if (devlink_nl_port_attrs_put(msg, devlink_port))
 		goto nla_put_failure;
 
@@ -738,6 +743,11 @@ static int devlink_nl_subdev_fill(struct sk_buff *msg, struct devlink *devlink,
 		break;
 	}
 
+	if (devlink_subdev->devlink_port)
+		if (nla_put_u32(msg, DEVLINK_ATTR_PORT_INDEX,
+				devlink_subdev->devlink_port->index))
+			goto nla_put_failure;
+
 	genlmsg_end(msg, hdr);
 	return 0;
 
@@ -6587,11 +6597,12 @@ static void devlink_port_type_warn_cancel(struct devlink_port *devlink_port)
 }
 
 /**
- *	devlink_port_register - Register devlink port
+ *	devlink_port_register_with_subdev - Register devlink port
  *
  *	@devlink: devlink
  *	@devlink_port: devlink port
  *	@port_index: driver-specific numerical identifier of the port
+ *	@devlink_subdev: subdev to link with the port
  *
  *	Register devlink port with provided port index. User can use
  *	any indexing, even hw-related one. devlink_port structure
@@ -6599,9 +6610,10 @@ static void devlink_port_type_warn_cancel(struct devlink_port *devlink_port)
  *	Note that the caller should take care of zeroing the devlink_port
  *	structure.
  */
-int devlink_port_register(struct devlink *devlink,
-			  struct devlink_port *devlink_port,
-			  unsigned int port_index)
+int devlink_port_register_with_subdev(struct devlink *devlink,
+				      struct devlink_port *devlink_port,
+				      unsigned int port_index,
+				      struct devlink_subdev *devlink_subdev)
 {
 	mutex_lock(&devlink->lock);
 	if (devlink_port_index_exists(devlink, port_index)) {
@@ -6611,15 +6623,42 @@ int devlink_port_register(struct devlink *devlink,
 	devlink_port->devlink = devlink;
 	devlink_port->index = port_index;
 	devlink_port->registered = true;
+	devlink_port->devlink_subdev = devlink_subdev;
 	spin_lock_init(&devlink_port->type_lock);
 	list_add_tail(&devlink_port->list, &devlink->port_list);
 	INIT_LIST_HEAD(&devlink_port->param_list);
 	mutex_unlock(&devlink->lock);
 	INIT_DELAYED_WORK(&devlink_port->type_warn_dw, &devlink_port_type_warn);
 	devlink_port_type_warn_schedule(devlink_port);
+	if (devlink_subdev) {
+		devlink_subdev->devlink_port = devlink_port;
+		devlink_subdev_notify(devlink_subdev, DEVLINK_CMD_SUBDEV_NEW);
+	}
 	devlink_port_notify(devlink_port, DEVLINK_CMD_PORT_NEW);
 	return 0;
 }
+EXPORT_SYMBOL_GPL(devlink_port_register_with_subdev);
+
+/**
+ *	devlink_port_register - Register devlink port
+ *
+ *	@devlink: devlink
+ *	@devlink_port: devlink port
+ *	@port_index: driver-specific numerical identifier of the port
+ *
+ *	Register devlink port with provided port index. User can use
+ *	any indexing, even hw-related one. devlink_port structure
+ *	is convenient to be embedded inside user driver private structure.
+ *	Note that the caller should take care of zeroing the devlink_port
+ *	structure.
+ */
+int devlink_port_register(struct devlink *devlink,
+			  struct devlink_port *devlink_port,
+			  unsigned int port_index)
+{
+	return devlink_port_register_with_subdev(devlink, devlink_port,
+					       port_index, NULL);
+}
 EXPORT_SYMBOL_GPL(devlink_port_register);
 
 /**
@@ -6629,9 +6668,14 @@ EXPORT_SYMBOL_GPL(devlink_port_register);
  */
 void devlink_port_unregister(struct devlink_port *devlink_port)
 {
+	struct devlink_subdev *devlink_subdev = devlink_port->devlink_subdev;
 	struct devlink *devlink = devlink_port->devlink;
 
 	devlink_port_type_warn_cancel(devlink_port);
+	if (devlink_subdev) {
+		devlink_subdev->devlink_port = NULL;
+		devlink_subdev_notify(devlink_subdev, DEVLINK_CMD_SUBDEV_NEW);
+	}
 	devlink_port_notify(devlink_port, DEVLINK_CMD_PORT_DEL);
 	mutex_lock(&devlink->lock);
 	list_del(&devlink_port->list);
@@ -6932,6 +6976,7 @@ void devlink_subdev_destroy(struct devlink_subdev *devlink_subdev)
 {
 	struct devlink *devlink = devlink_subdev->devlink;
 
+	WARN_ON(devlink_subdev->devlink_port);
 	devlink_subdev_notify(devlink_subdev, DEVLINK_CMD_SUBDEV_DEL);
 	mutex_lock(&devlink->lock);
 	list_del(&devlink_subdev->list);
-- 
2.17.1

