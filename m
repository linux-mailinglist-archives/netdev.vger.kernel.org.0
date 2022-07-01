Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0FC65635B2
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 16:36:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232950AbiGAOfw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 10:35:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232723AbiGAOfe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 10:35:34 -0400
Received: from relay9-d.mail.gandi.net (relay9-d.mail.gandi.net [217.70.183.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D20B33ED2B;
        Fri,  1 Jul 2022 07:31:05 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 55AA9FF809;
        Fri,  1 Jul 2022 14:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1656685862;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hro+/yn4O29eytxP479pwHSX2McvAziZg8oq3nohJQw=;
        b=pMou6wztBGcRttw97t7KO+T8Q1TEv73KfZB/BEwgMvbq6bZP7Roz+mykR4QZKQO2ZR9L6q
        bUUVLmeKRRq08CFe7KEd5GrNO6/KqIbDnvATIr8zXwPisfE7MNsUPzHKRAAXQ6wVeXT5Jb
        Sg8gOWHpXVMYp9tOgh7VeqrGXad/95XNqNoMGabNTDklItub0/KKCsf9HfnWdQgsRrSA6o
        RJy9K52bqjDrFYIqKX4Z5QsGsBDwT//zc33jDrZ1fwM445Uz+q/MyvmoYgqJMDcfxz4RZo
        XkDU1gp4z585bF39wm1l2bKJKrQGyWCd7qUoxGC2oglzMbkX98tXD5dskxGCGw==
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH wpan-next 03/20] net: ieee802154: Handle coordinators discovery
Date:   Fri,  1 Jul 2022 16:30:35 +0200
Message-Id: <20220701143052.1267509-4-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220701143052.1267509-1-miquel.raynal@bootlin.com>
References: <20220701143052.1267509-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Let's introduce helpers for giving the MAC layer a generic interface for
advertising discovered coordinators/PANs upon beacon reception. This
support requires the MAC layers to:
- Allocate a coordinator/PAN descriptor and fill it.
- Register this structure, giving the generic ieee802154 layer the
  necessary information about the coordinator/PAN the beacon originates
  from.
- To flush all the allocated structures once the scan is done.

The generic layer keeps a temporary list of the discovered coordinators
to avoid spamming the user with identical information. So only new
discoveries are forwarded to the user through netlink messages (already
implemented).

Co-developed-by: David Girault <david.girault@qorvo.com>
Signed-off-by: David Girault <david.girault@qorvo.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 include/net/cfg802154.h   |  11 ++++
 net/ieee802154/Makefile   |   2 +-
 net/ieee802154/core.c     |   2 +
 net/ieee802154/nl802154.c |   2 +
 net/ieee802154/pan.c      | 112 ++++++++++++++++++++++++++++++++++++++
 5 files changed, 128 insertions(+), 1 deletion(-)
 create mode 100644 net/ieee802154/pan.c

diff --git a/include/net/cfg802154.h b/include/net/cfg802154.h
index 1f1b275dcabd..895948b433de 100644
--- a/include/net/cfg802154.h
+++ b/include/net/cfg802154.h
@@ -398,6 +398,10 @@ struct wpan_dev {
 
 	/* fallback for acknowledgment bit setting */
 	bool ackreq;
+
+	/* Coordinators management during scans */
+	spinlock_t coord_list_lock;
+	struct list_head coord_list;
 };
 
 #define to_phy(_dev)	container_of(_dev, struct wpan_phy, dev)
@@ -446,4 +450,11 @@ static inline const char *wpan_phy_name(struct wpan_phy *phy)
 
 void ieee802154_configure_durations(struct wpan_phy *phy);
 
+struct ieee802154_coord_desc *
+cfg802154_alloc_coordinator(struct ieee802154_addr *coord);
+void cfg802154_record_coordinator(struct wpan_phy *wpan_phy,
+				  struct wpan_dev *wpan_dev,
+				  struct ieee802154_coord_desc *desc);
+void cfg802154_flush_known_coordinators(struct wpan_dev *wpan_dev);
+
 #endif /* __NET_CFG802154_H */
diff --git a/net/ieee802154/Makefile b/net/ieee802154/Makefile
index f05b7bdae2aa..6b7c66de730d 100644
--- a/net/ieee802154/Makefile
+++ b/net/ieee802154/Makefile
@@ -4,7 +4,7 @@ obj-$(CONFIG_IEEE802154_SOCKET) += ieee802154_socket.o
 obj-y += 6lowpan/
 
 ieee802154-y := netlink.o nl-mac.o nl-phy.o nl_policy.o core.o \
-                header_ops.o sysfs.o nl802154.o trace.o
+                header_ops.o sysfs.o nl802154.o pan.o trace.o
 ieee802154_socket-y := socket.o
 
 CFLAGS_trace.o := -I$(src)
diff --git a/net/ieee802154/core.c b/net/ieee802154/core.c
index 57546e07e06a..091eb467fde6 100644
--- a/net/ieee802154/core.c
+++ b/net/ieee802154/core.c
@@ -276,6 +276,8 @@ static int cfg802154_netdev_notifier_call(struct notifier_block *nb,
 		wpan_dev->identifier = ++rdev->wpan_dev_id;
 		list_add_rcu(&wpan_dev->list, &rdev->wpan_dev_list);
 		rdev->devlist_generation++;
+		spin_lock_init(&wpan_dev->coord_list_lock);
+		INIT_LIST_HEAD(&wpan_dev->coord_list);
 
 		wpan_dev->netdev = dev;
 		break;
diff --git a/net/ieee802154/nl802154.c b/net/ieee802154/nl802154.c
index 7c0aec10ef7f..8598767c0c0a 100644
--- a/net/ieee802154/nl802154.c
+++ b/net/ieee802154/nl802154.c
@@ -1368,6 +1368,8 @@ int nl802154_advertise_new_coordinator(struct wpan_phy *wpan_phy,
 	struct sk_buff *msg;
 	int ret;
 
+	lockdep_assert(&wpan_dev->coord_list_lock);
+
 	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_ATOMIC);
 	if (!msg)
 		return -ENOMEM;
diff --git a/net/ieee802154/pan.c b/net/ieee802154/pan.c
new file mode 100644
index 000000000000..134a13ff0a87
--- /dev/null
+++ b/net/ieee802154/pan.c
@@ -0,0 +1,112 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * IEEE 802.15.4 PAN management
+ *
+ * Copyright (C) Qorvo, 2021
+ * Authors:
+ *   - David Girault <david.girault@qorvo.com>
+ *   - Miquel Raynal <miquel.raynal@bootlin.com>
+ */
+
+#include <linux/slab.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/device.h>
+
+#include <net/cfg802154.h>
+#include <net/af_ieee802154.h>
+
+#include "ieee802154.h"
+#include "../ieee802154/nl802154.h"
+
+struct ieee802154_coord_desc *
+cfg802154_alloc_coordinator(struct ieee802154_addr *coord)
+{
+	struct ieee802154_coord_desc *desc;
+
+	desc = kzalloc(sizeof(*desc), GFP_ATOMIC);
+	if (!desc)
+		return ERR_PTR(-ENOMEM);
+
+	desc->addr = kzalloc(sizeof(*coord), GFP_ATOMIC);
+	if (!desc->addr) {
+		kfree(desc);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	memcpy(desc->addr, coord, sizeof(*coord));
+
+	return desc;
+}
+EXPORT_SYMBOL_GPL(cfg802154_alloc_coordinator);
+
+static void cfg802154_free_coordinator_desc(struct ieee802154_coord_desc *desc)
+{
+	kfree(desc->addr);
+	kfree(desc);
+}
+
+static bool
+cfg802154_is_same_coordinator(struct ieee802154_coord_desc *a,
+			      struct ieee802154_coord_desc *b)
+{
+	if (a->addr->pan_id != b->addr->pan_id)
+		return false;
+
+	if (a->addr->mode != b->addr->mode)
+		return false;
+
+	if (a->addr->mode == IEEE802154_ADDR_SHORT &&
+	    a->addr->short_addr == b->addr->short_addr)
+		return true;
+	else if (a->addr->mode == IEEE802154_ADDR_LONG &&
+		 a->addr->extended_addr == b->addr->extended_addr)
+		return true;
+
+	return false;
+}
+
+static bool
+cfg802154_coordinator_is_known(struct wpan_dev *wpan_dev,
+			       struct ieee802154_coord_desc *desc)
+{
+	struct ieee802154_coord_desc *item;
+
+	list_for_each_entry(item, &wpan_dev->coord_list, node)
+		if (cfg802154_is_same_coordinator(item, desc))
+			return true;
+
+	return false;
+}
+
+void cfg802154_record_coordinator(struct wpan_phy *wpan_phy,
+				  struct wpan_dev *wpan_dev,
+				  struct ieee802154_coord_desc *desc)
+{
+	spin_lock_bh(&wpan_dev->coord_list_lock);
+
+	if (cfg802154_coordinator_is_known(wpan_dev, desc)) {
+		cfg802154_free_coordinator_desc(desc);
+	} else {
+		list_add_tail(&desc->node, &wpan_dev->coord_list);
+		nl802154_advertise_new_coordinator(wpan_phy, wpan_dev, desc);
+	}
+
+	spin_unlock_bh(&wpan_dev->coord_list_lock);
+}
+EXPORT_SYMBOL_GPL(cfg802154_record_coordinator);
+
+void cfg802154_flush_known_coordinators(struct wpan_dev *wpan_dev)
+{
+	struct ieee802154_coord_desc *desc, *tmp;
+
+	spin_lock_bh(&wpan_dev->coord_list_lock);
+
+	list_for_each_entry_safe(desc, tmp, &wpan_dev->coord_list, node) {
+		list_del(&desc->node);
+		cfg802154_free_coordinator_desc(desc);
+	}
+
+	spin_unlock_bh(&wpan_dev->coord_list_lock);
+}
+EXPORT_SYMBOL_GPL(cfg802154_flush_known_coordinators);
-- 
2.34.1

