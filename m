Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A6B6612A7
	for <lists+netdev@lfdr.de>; Sat,  6 Jul 2019 20:24:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727126AbfGFSYD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Jul 2019 14:24:03 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:34896 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727068AbfGFSYD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Jul 2019 14:24:03 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from parav@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 6 Jul 2019 21:23:57 +0300
Received: from sw-mtx-036.mtx.labs.mlnx (sw-mtx-036.mtx.labs.mlnx [10.12.150.149])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x66INsxY019619;
        Sat, 6 Jul 2019 21:23:56 +0300
From:   Parav Pandit <parav@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     jiri@mellanox.com, saeedm@mellanox.com,
        jakub.kicinski@netronome.com, Parav Pandit <parav@mellanox.com>
Subject: [PATCH net-next v4 1/4] devlink: Refactor physical port attributes
Date:   Sat,  6 Jul 2019 13:23:47 -0500
Message-Id: <20190706182350.11929-2-parav@mellanox.com>
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

To support additional devlink port flavours and to support few common
and few different port attributes, make following changes.

1. Move physical port attributes to a different structure
2. Return such attritubes in netlink response only for physical ports
(PHYSICAL, CPU and DSA)

Signed-off-by: Parav Pandit <parav@mellanox.com>
---
 include/net/devlink.h | 13 +++++++--
 net/core/devlink.c    | 63 +++++++++++++++++++++++++++++--------------
 2 files changed, 54 insertions(+), 22 deletions(-)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index 6625ea068d5e..c79a1370867a 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -38,14 +38,23 @@ struct devlink {
 	char priv[0] __aligned(NETDEV_ALIGN);
 };
 
+struct devlink_port_phys_attrs {
+	u32 port_number; /* Same value as "split group".
+			  * A physical port which is visible to the user
+			  * for a given port flavour.
+			  */
+	u32 split_subport_number;
+};
+
 struct devlink_port_attrs {
 	u8 set:1,
 	   split:1,
 	   switch_port:1;
 	enum devlink_port_flavour flavour;
-	u32 port_number; /* same value as "split group" */
-	u32 split_subport_number;
 	struct netdev_phys_item_id switch_id;
+	union {
+		struct devlink_port_phys_attrs physical;
+	};
 };
 
 struct devlink_port {
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 89c533778135..db6fa6bb9b33 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -515,14 +515,20 @@ static int devlink_nl_port_attrs_put(struct sk_buff *msg,
 		return 0;
 	if (nla_put_u16(msg, DEVLINK_ATTR_PORT_FLAVOUR, attrs->flavour))
 		return -EMSGSIZE;
-	if (nla_put_u32(msg, DEVLINK_ATTR_PORT_NUMBER, attrs->port_number))
+	if (devlink_port->attrs.flavour == DEVLINK_PORT_FLAVOUR_PHYSICAL ||
+	    devlink_port->attrs.flavour == DEVLINK_PORT_FLAVOUR_CPU ||
+	    devlink_port->attrs.flavour == DEVLINK_PORT_FLAVOUR_DSA)
+		return 0;
+	if (nla_put_u32(msg, DEVLINK_ATTR_PORT_NUMBER,
+			attrs->physical.port_number))
 		return -EMSGSIZE;
 	if (!attrs->split)
 		return 0;
-	if (nla_put_u32(msg, DEVLINK_ATTR_PORT_SPLIT_GROUP, attrs->port_number))
+	if (nla_put_u32(msg, DEVLINK_ATTR_PORT_SPLIT_GROUP,
+			attrs->physical.port_number))
 		return -EMSGSIZE;
 	if (nla_put_u32(msg, DEVLINK_ATTR_PORT_SPLIT_SUBPORT_NUMBER,
-			attrs->split_subport_number))
+			attrs->physical.split_subport_number))
 		return -EMSGSIZE;
 	return 0;
 }
@@ -5738,6 +5744,29 @@ void devlink_port_type_clear(struct devlink_port *devlink_port)
 }
 EXPORT_SYMBOL_GPL(devlink_port_type_clear);
 
+static int __devlink_port_attrs_set(struct devlink_port *devlink_port,
+				    enum devlink_port_flavour flavour,
+				    const unsigned char *switch_id,
+				    unsigned char switch_id_len)
+{
+	struct devlink_port_attrs *attrs = &devlink_port->attrs;
+
+	if (WARN_ON(devlink_port->registered))
+		return -EEXIST;
+	attrs->set = true;
+	attrs->flavour = flavour;
+	if (switch_id) {
+		attrs->switch_port = true;
+		if (WARN_ON(switch_id_len > MAX_PHYS_ITEM_ID_LEN))
+			switch_id_len = MAX_PHYS_ITEM_ID_LEN;
+		memcpy(attrs->switch_id.id, switch_id, switch_id_len);
+		attrs->switch_id.id_len = switch_id_len;
+	} else {
+		attrs->switch_port = false;
+	}
+	return 0;
+}
+
 /**
  *	devlink_port_attrs_set - Set port attributes
  *
@@ -5760,23 +5789,15 @@ void devlink_port_attrs_set(struct devlink_port *devlink_port,
 			    unsigned char switch_id_len)
 {
 	struct devlink_port_attrs *attrs = &devlink_port->attrs;
+	int ret;
 
-	if (WARN_ON(devlink_port->registered))
+	ret = __devlink_port_attrs_set(devlink_port, flavour,
+				       switch_id, switch_id_len);
+	if (ret)
 		return;
-	attrs->set = true;
-	attrs->flavour = flavour;
-	attrs->port_number = port_number;
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
+	attrs->physical.port_number = port_number;
+	attrs->physical.split_subport_number = split_subport_number;
 }
 EXPORT_SYMBOL_GPL(devlink_port_attrs_set);
 
@@ -5792,10 +5813,12 @@ static int __devlink_port_phys_port_name_get(struct devlink_port *devlink_port,
 	switch (attrs->flavour) {
 	case DEVLINK_PORT_FLAVOUR_PHYSICAL:
 		if (!attrs->split)
-			n = snprintf(name, len, "p%u", attrs->port_number);
+			n = snprintf(name, len, "p%u",
+				     attrs->physical.port_number);
 		else
-			n = snprintf(name, len, "p%us%u", attrs->port_number,
-				     attrs->split_subport_number);
+			n = snprintf(name, len, "p%us%u",
+				     attrs->physical.port_number,
+				     attrs->physical.split_subport_number);
 		break;
 	case DEVLINK_PORT_FLAVOUR_CPU:
 	case DEVLINK_PORT_FLAVOUR_DSA:
-- 
2.19.2

