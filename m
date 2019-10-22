Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 297A3E0AE2
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 19:43:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732104AbfJVRnW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 13:43:22 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:55827 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1731906AbfJVRnW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 13:43:22 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from yuvalav@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 22 Oct 2019 19:43:18 +0200
Received: from sw-mtx-008.mtx.labs.mlnx (sw-mtx-008.mtx.labs.mlnx [10.9.150.35])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x9MHhHxU005575;
        Tue, 22 Oct 2019 20:43:18 +0300
Received: from sw-mtx-008.mtx.labs.mlnx (localhost [127.0.0.1])
        by sw-mtx-008.mtx.labs.mlnx (8.14.7/8.14.7) with ESMTP id x9MHhHOL023985;
        Tue, 22 Oct 2019 20:43:17 +0300
Received: (from yuvalav@localhost)
        by sw-mtx-008.mtx.labs.mlnx (8.14.7/8.14.7/Submit) id x9MHhHYB023984;
        Tue, 22 Oct 2019 20:43:17 +0300
From:   Yuval Avnery <yuvalav@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     jiri@mellanox.com, saeedm@mellanox.com, leon@kernel.org,
        davem@davemloft.net, jakub.kicinski@netronome.com,
        shuah@kernel.org, Yuval Avnery <yuvalav@mellanox.com>
Subject: [PATCH net-next 3/9] devlink: Add port with vdev register support
Date:   Tue, 22 Oct 2019 20:43:04 +0300
Message-Id: <1571766190-23943-4-git-send-email-yuvalav@mellanox.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1571766190-23943-1-git-send-email-yuvalav@mellanox.com>
References: <1571766190-23943-1-git-send-email-yuvalav@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A vdev may represent a network device, so it may be linked to
a devlink port.
Added devlink_port_register_with_vdev to allow vdev-port linkage.

Example:

$ devlink vdev show pci/0000:03:00.0/1 -jp
{
    "vdev": {
        "pci/0000:03:00.0/1": {
            "flavour": "pcivf",
            "pf": 0,
            "vf": 0,
            "port_index": 1
        }
    }
}
$ devlink vdev show pci/0000:03:00.0/1
pci/0000:03:00.0/1: flavour pcivf pf 0 vf 0 port_index 1

$ devlink port show pci/0000:03:00.0/1
pci/0000:03:00.0/1: type eth netdev ens2f0_0 flavour pcivf pfnum 0 vfnum 0 vdev_index 1

Signed-off-by: Yuval Avnery <yuvalav@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 include/net/devlink.h |  5 ++++
 net/core/devlink.c    | 53 +++++++++++++++++++++++++++++++++++++++----
 2 files changed, 54 insertions(+), 4 deletions(-)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index ab7e316ea758..138d33275963 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -90,6 +90,7 @@ struct devlink_port {
 	void *type_dev;
 	struct devlink_port_attrs attrs;
 	struct delayed_work type_warn_dw;
+	struct devlink_vdev *devlink_vdev; /* linked vdev */
 };
 
 struct devlink_vdev_pci_pf_attrs {
@@ -806,6 +807,10 @@ void devlink_free(struct devlink *devlink);
 int devlink_port_register(struct devlink *devlink,
 			  struct devlink_port *devlink_port,
 			  unsigned int port_index);
+int devlink_port_register_with_vdev(struct devlink *devlink,
+				    struct devlink_port *devlink_port,
+				    unsigned int port_index,
+				    struct devlink_vdev *devlink_vdev);
 void devlink_port_unregister(struct devlink_port *devlink_port);
 void devlink_port_type_eth_set(struct devlink_port *devlink_port,
 			       struct net_device *netdev);
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 0a201a373da9..2fffbd37e710 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -37,6 +37,7 @@ struct devlink_vdev {
 	unsigned int index;
 	const struct devlink_vdev_ops *ops;
 	struct devlink_vdev_attrs attrs;
+	struct devlink_port *devlink_port; /* linked port */
 	void *priv;
 };
 
@@ -664,6 +665,10 @@ static int devlink_nl_port_fill(struct sk_buff *msg, struct devlink *devlink,
 			goto nla_put_failure_type_locked;
 	}
 	spin_unlock_bh(&devlink_port->type_lock);
+	if (devlink_port->devlink_vdev)
+		if (nla_put_u32(msg, DEVLINK_ATTR_VDEV_INDEX,
+				devlink_port->devlink_vdev->index))
+			goto nla_put_failure;
 	if (devlink_nl_port_attrs_put(msg, devlink_port))
 		goto nla_put_failure;
 
@@ -738,6 +743,11 @@ static int devlink_nl_vdev_fill(struct sk_buff *msg, struct devlink *devlink,
 		break;
 	}
 
+	if (devlink_vdev->devlink_port)
+		if (nla_put_u32(msg, DEVLINK_ATTR_PORT_INDEX,
+				devlink_vdev->devlink_port->index))
+			goto nla_put_failure;
+
 	genlmsg_end(msg, hdr);
 	return 0;
 
@@ -6582,11 +6592,12 @@ static void devlink_port_type_warn_cancel(struct devlink_port *devlink_port)
 }
 
 /**
- *	devlink_port_register - Register devlink port
+ *	devlink_port_register_with_vdev - Register devlink port
  *
  *	@devlink: devlink
  *	@devlink_port: devlink port
  *	@port_index: driver-specific numerical identifier of the port
+ *	@devlink_vdev: vdev to link with the port
  *
  *	Register devlink port with provided port index. User can use
  *	any indexing, even hw-related one. devlink_port structure
@@ -6594,9 +6605,10 @@ static void devlink_port_type_warn_cancel(struct devlink_port *devlink_port)
  *	Note that the caller should take care of zeroing the devlink_port
  *	structure.
  */
-int devlink_port_register(struct devlink *devlink,
-			  struct devlink_port *devlink_port,
-			  unsigned int port_index)
+int devlink_port_register_with_vdev(struct devlink *devlink,
+				    struct devlink_port *devlink_port,
+				    unsigned int port_index,
+				    struct devlink_vdev *devlink_vdev)
 {
 	mutex_lock(&devlink->lock);
 	if (devlink_port_index_exists(devlink, port_index)) {
@@ -6606,15 +6618,42 @@ int devlink_port_register(struct devlink *devlink,
 	devlink_port->devlink = devlink;
 	devlink_port->index = port_index;
 	devlink_port->registered = true;
+	devlink_port->devlink_vdev = devlink_vdev;
 	spin_lock_init(&devlink_port->type_lock);
 	list_add_tail(&devlink_port->list, &devlink->port_list);
 	INIT_LIST_HEAD(&devlink_port->param_list);
 	mutex_unlock(&devlink->lock);
 	INIT_DELAYED_WORK(&devlink_port->type_warn_dw, &devlink_port_type_warn);
 	devlink_port_type_warn_schedule(devlink_port);
+	if (devlink_vdev) {
+		devlink_vdev->devlink_port = devlink_port;
+		devlink_vdev_notify(devlink_vdev, DEVLINK_CMD_VDEV_NEW);
+	}
 	devlink_port_notify(devlink_port, DEVLINK_CMD_PORT_NEW);
 	return 0;
 }
+EXPORT_SYMBOL_GPL(devlink_port_register_with_vdev);
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
+	return devlink_port_register_with_vdev(devlink, devlink_port,
+					       port_index, NULL);
+}
 EXPORT_SYMBOL_GPL(devlink_port_register);
 
 /**
@@ -6624,9 +6663,14 @@ EXPORT_SYMBOL_GPL(devlink_port_register);
  */
 void devlink_port_unregister(struct devlink_port *devlink_port)
 {
+	struct devlink_vdev *devlink_vdev = devlink_port->devlink_vdev;
 	struct devlink *devlink = devlink_port->devlink;
 
 	devlink_port_type_warn_cancel(devlink_port);
+	if (devlink_vdev) {
+		devlink_vdev->devlink_port = NULL;
+		devlink_vdev_notify(devlink_vdev, DEVLINK_CMD_VDEV_NEW);
+	}
 	devlink_port_notify(devlink_port, DEVLINK_CMD_PORT_DEL);
 	mutex_lock(&devlink->lock);
 	list_del(&devlink_port->list);
@@ -6926,6 +6970,7 @@ void devlink_vdev_destroy(struct devlink_vdev *devlink_vdev)
 {
 	struct devlink *devlink = devlink_vdev->devlink;
 
+	WARN_ON(devlink_vdev->devlink_port);
 	devlink_vdev_notify(devlink_vdev, DEVLINK_CMD_VDEV_DEL);
 	mutex_lock(&devlink->lock);
 	list_del(&devlink_vdev->list);
-- 
2.17.1

