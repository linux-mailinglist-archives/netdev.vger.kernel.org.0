Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30B22619C8
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 06:16:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726391AbfGHEQA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 00:16:00 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:59640 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725781AbfGHEQA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 00:16:00 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from parav@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 8 Jul 2019 07:15:55 +0300
Received: from sw-mtx-036.mtx.labs.mlnx (sw-mtx-036.mtx.labs.mlnx [10.12.150.149])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x684Fol5028463;
        Mon, 8 Jul 2019 07:15:53 +0300
From:   Parav Pandit <parav@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     jiri@mellanox.com, saeedm@mellanox.com,
        jakub.kicinski@netronome.com, Parav Pandit <parav@mellanox.com>
Subject: [PATCH net-next v5 1/5] devlink: Refactor physical port attributes
Date:   Sun,  7 Jul 2019 23:15:45 -0500
Message-Id: <20190708041549.56601-2-parav@mellanox.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190708041549.56601-1-parav@mellanox.com>
References: <20190701122734.18770-1-parav@mellanox.com>
 <20190708041549.56601-1-parav@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To support additional devlink port flavours and to support few common
and few different port attributes, move physical port attributes to a
different structure.

Signed-off-by: Parav Pandit <parav@mellanox.com>
---
Changelog:
v4->v5:
 - Addressed comments from Jiri.
 - Moved check for physical port flavours check to separate patch.
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
 include/net/devlink.h | 13 ++++++++--
 net/core/devlink.c    | 59 ++++++++++++++++++++++++++++---------------
 2 files changed, 50 insertions(+), 22 deletions(-)

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
index 89c533778135..abe50a8e25c6 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -515,14 +515,16 @@ static int devlink_nl_port_attrs_put(struct sk_buff *msg,
 		return 0;
 	if (nla_put_u16(msg, DEVLINK_ATTR_PORT_FLAVOUR, attrs->flavour))
 		return -EMSGSIZE;
-	if (nla_put_u32(msg, DEVLINK_ATTR_PORT_NUMBER, attrs->port_number))
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
@@ -5738,6 +5740,29 @@ void devlink_port_type_clear(struct devlink_port *devlink_port)
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
@@ -5760,23 +5785,15 @@ void devlink_port_attrs_set(struct devlink_port *devlink_port,
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
 
@@ -5792,10 +5809,12 @@ static int __devlink_port_phys_port_name_get(struct devlink_port *devlink_port,
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

