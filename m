Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29A7E47D49C
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 16:59:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343852AbhLVP6Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 10:58:24 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:59117 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343849AbhLVP57 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 10:57:59 -0500
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id E1CC560012;
        Wed, 22 Dec 2021 15:57:56 +0000 (UTC)
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org
Cc:     David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        <linux-kernel@vger.kernel.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [net-next 08/18] net: ieee802154: Add support for internal PAN management
Date:   Wed, 22 Dec 2021 16:57:33 +0100
Message-Id: <20211222155743.256280-9-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211222155743.256280-1-miquel.raynal@bootlin.com>
References: <20211222155743.256280-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Let's introduce the basics of PAN management:
- structures defining PANs
- helpers for PANs registration
- helpers discarding old PANs

Co-developed-by: David Girault <david.girault@qorvo.com>
Signed-off-by: David Girault <david.girault@qorvo.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 include/net/cfg802154.h |  31 ++++++
 net/ieee802154/Makefile |   2 +-
 net/ieee802154/core.c   |   2 +
 net/ieee802154/core.h   |  20 ++++
 net/ieee802154/pan.c    | 208 ++++++++++++++++++++++++++++++++++++++++
 5 files changed, 262 insertions(+), 1 deletion(-)
 create mode 100644 net/ieee802154/pan.c

diff --git a/include/net/cfg802154.h b/include/net/cfg802154.h
index 4f36003bca98..4402f93cda32 100644
--- a/include/net/cfg802154.h
+++ b/include/net/cfg802154.h
@@ -48,6 +48,24 @@ struct ieee802154_addr {
 	};
 };
 
+/**
+ * struct ieee802154_pan_desc - PAN descriptor information
+ * @coord: PAN ID and coordinator address
+ * @page: page this PAN is on
+ * @channel: channel this PAN is on
+ * @superframe_spec: SuperFrame specification as received
+ * @link_quality: link quality indicator at which the beacon was received
+ * @gts_permit: the PAN coordinator accepts GTS requests
+ */
+struct ieee802154_pan_desc {
+	struct ieee802154_addr *coord;
+	u8 page;
+	u8 channel;
+	u16 superframe_spec;
+	u8 link_quality;
+	bool gts_permit;
+};
+
 struct cfg802154_ops {
 	struct net_device * (*add_virtual_intf_deprecated)(struct wpan_phy *wpan_phy,
 							   const char *name,
@@ -415,4 +433,17 @@ static inline const char *wpan_phy_name(struct wpan_phy *phy)
 	return dev_name(&phy->dev);
 }
 
+/**
+ * cfg802154_record_pan - Advertize a new PAN following a beacon's reception
+ * @wpan_phy: PHY receiving the beacon
+ * @pan: PAN descriptor
+ *
+ * Tells the internal pan management layer to either register this PAN if it is
+ * new or at least update its entry if already discovered.
+ *
+ * Returns 0 on success, a negative error code otherwise.
+ */
+int cfg802154_record_pan(struct wpan_phy *wpan_phy,
+			 struct ieee802154_pan_desc *pan);
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
index de259b5170ab..0f73e0571883 100644
--- a/net/ieee802154/core.c
+++ b/net/ieee802154/core.c
@@ -115,6 +115,8 @@ wpan_phy_new(const struct cfg802154_ops *ops, size_t priv_size)
 		kfree(rdev);
 		return NULL;
 	}
+	spin_lock_init(&rdev->pan_lock);
+	INIT_LIST_HEAD(&rdev->pan_list);
 
 	/* atomic_inc_return makes it start at 1, make it start at 0 */
 	rdev->wpan_phy_idx--;
diff --git a/net/ieee802154/core.h b/net/ieee802154/core.h
index 1c19f575d574..dea1d6f70489 100644
--- a/net/ieee802154/core.h
+++ b/net/ieee802154/core.h
@@ -22,6 +22,12 @@ struct cfg802154_registered_device {
 	struct list_head wpan_dev_list;
 	int devlist_generation, wpan_dev_id;
 
+	/* pan management */
+	spinlock_t pan_lock;
+	struct list_head pan_list;
+	int pan_entries;
+	int pan_generation;
+
 	/* must be last because of the way we do wpan_phy_priv(),
 	 * and it should at least be aligned to NETDEV_ALIGN
 	 */
@@ -39,6 +45,17 @@ wpan_phy_to_rdev(struct wpan_phy *wpan_phy)
 extern struct list_head cfg802154_rdev_list;
 extern int cfg802154_rdev_list_generation;
 
+struct cfg802154_internal_pan {
+	struct list_head list;
+	unsigned long discovery_ts;
+	struct ieee802154_pan_desc desc;
+};
+
+/* Always update the list by dropping the expired PANs before iterating */
+#define ieee802154_for_each_pan(pan, rdev)				\
+	cfg802154_expire_pans(rdev);					\
+	list_for_each_entry((pan), &(rdev)->pan_list, list)
+
 int cfg802154_switch_netns(struct cfg802154_registered_device *rdev,
 			   struct net *net);
 /* free object */
@@ -47,4 +64,7 @@ struct cfg802154_registered_device *
 cfg802154_rdev_by_wpan_phy_idx(int wpan_phy_idx);
 struct wpan_phy *wpan_phy_idx_to_wpan_phy(int wpan_phy_idx);
 
+void cfg802154_expire_pans(struct cfg802154_registered_device *rdev);
+void cfg802154_flush_pans(struct cfg802154_registered_device *rdev);
+
 #endif /* __IEEE802154_CORE_H */
diff --git a/net/ieee802154/pan.c b/net/ieee802154/pan.c
new file mode 100644
index 000000000000..c71a3664d5c3
--- /dev/null
+++ b/net/ieee802154/pan.c
@@ -0,0 +1,208 @@
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
+#include "core.h"
+
+/* Maximum number of PAN entries to store */
+static int max_pan_entries = 100;
+module_param(max_pan_entries, uint, 0644);
+MODULE_PARM_DESC(max_pan_entries,
+		 "Maximum number of PANs to discover per scan (default is 100)");
+
+static int pan_expiration = 60;
+module_param(pan_expiration, uint, 0644);
+MODULE_PARM_DESC(pan_expiration,
+		 "Expiration of the scan validity in seconds (default is 60s)");
+
+static struct cfg802154_internal_pan *
+cfg802154_alloc_pan(struct ieee802154_pan_desc *desc)
+{
+	struct cfg802154_internal_pan *new;
+	struct ieee802154_addr *coord;
+
+	new = kzalloc(sizeof(*new), GFP_KERNEL);
+	if (!new)
+		return ERR_PTR(-ENOMEM);
+
+	coord = kzalloc(sizeof(*coord), GFP_KERNEL);
+	if (!coord) {
+		kfree(new);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	new->discovery_ts = jiffies;
+	new->desc = *desc;
+
+	*coord = *desc->coord;
+	new->desc.coord = coord;
+
+	return new;
+}
+
+static void cfg802154_free_pan(struct cfg802154_internal_pan *pan)
+{
+	kfree(pan->desc.coord);
+	kfree(pan);
+}
+
+static void cfg802154_unlink_pan(struct cfg802154_registered_device *rdev,
+				 struct cfg802154_internal_pan *pan)
+{
+	lockdep_assert_held(&rdev->pan_lock);
+
+	list_del(&pan->list);
+	cfg802154_free_pan(pan);
+	rdev->pan_entries--;
+	rdev->pan_generation++;
+}
+
+static void cfg802154_link_pan(struct cfg802154_registered_device *rdev,
+			       struct cfg802154_internal_pan *pan)
+{
+	lockdep_assert_held(&rdev->pan_lock);
+
+	list_add_tail(&pan->list, &rdev->pan_list);
+	rdev->pan_entries++;
+	rdev->pan_generation++;
+}
+
+void cfg802154_expire_pans(struct cfg802154_registered_device *rdev)
+{
+	unsigned long expiration_time = jiffies - (pan_expiration * HZ);
+	struct cfg802154_internal_pan *pan, *tmp;
+
+	lockdep_assert_held(&rdev->pan_lock);
+
+	list_for_each_entry_safe(pan, tmp, &rdev->pan_list, list) {
+		if (!time_after(expiration_time, pan->discovery_ts))
+			continue;
+
+		cfg802154_unlink_pan(rdev, pan);
+	}
+}
+EXPORT_SYMBOL(cfg802154_expire_pans);
+
+static void cfg802154_expire_oldest_pan(struct cfg802154_registered_device *rdev)
+{
+	struct cfg802154_internal_pan *pan, *oldest;
+
+	lockdep_assert_held(&rdev->pan_lock);
+
+	if (WARN_ON(!max_pan_entries || list_empty(&rdev->pan_list)))
+		return;
+
+	oldest = list_first_entry(&rdev->pan_list,
+				  struct cfg802154_internal_pan, list);
+
+	list_for_each_entry(pan, &rdev->pan_list, list) {
+		if (!time_before(oldest->discovery_ts, pan->discovery_ts))
+			oldest = pan;
+	}
+
+	cfg802154_unlink_pan(rdev, oldest);
+}
+
+void cfg802154_flush_pans(struct cfg802154_registered_device *rdev)
+{
+	struct cfg802154_internal_pan *pan, *tmp;
+
+	lockdep_assert_held(&rdev->pan_lock);
+
+	list_for_each_entry_safe(pan, tmp, &rdev->pan_list, list)
+		cfg802154_unlink_pan(rdev, pan);
+}
+EXPORT_SYMBOL(cfg802154_flush_pans);
+
+static bool cfg802154_same_pan(struct ieee802154_pan_desc *a,
+			       struct ieee802154_pan_desc *b)
+{
+	int ret;
+
+	if (a->page != b->page)
+		return false;
+
+	if (a->channel != b->channel)
+		return false;
+
+	ret = memcmp(&a->coord->pan_id, &b->coord->pan_id,
+		     sizeof(a->coord->pan_id));
+	if (ret)
+		return false;
+
+	if (a->coord->mode != b->coord->mode)
+		return false;
+
+	if (a->coord->mode == IEEE802154_ADDR_SHORT)
+		ret = memcmp(&a->coord->short_addr, &b->coord->short_addr,
+			     IEEE802154_SHORT_ADDR_LEN);
+	else
+		ret = memcmp(&a->coord->extended_addr, &b->coord->extended_addr,
+			     IEEE802154_EXTENDED_ADDR_LEN);
+
+	return true;
+}
+
+static struct cfg802154_internal_pan *
+cfg802154_find_matching_pan(struct cfg802154_registered_device *rdev,
+			    struct cfg802154_internal_pan *tmp)
+{
+	struct cfg802154_internal_pan *pan;
+
+	list_for_each_entry(pan, &rdev->pan_list, list) {
+		if (cfg802154_same_pan(&pan->desc, &tmp->desc))
+			return pan;
+	}
+
+	return NULL;
+}
+
+static void cfg802154_pan_update(struct cfg802154_registered_device *rdev,
+				 struct cfg802154_internal_pan *new)
+{
+	struct cfg802154_internal_pan *found;
+
+	spin_lock_bh(&rdev->pan_lock);
+
+	found = cfg802154_find_matching_pan(rdev, new);
+	if (found)
+		cfg802154_unlink_pan(rdev, found);
+
+	if (unlikely(rdev->pan_entries >= max_pan_entries))
+		cfg802154_expire_oldest_pan(rdev);
+
+	cfg802154_link_pan(rdev, new);
+
+	spin_unlock_bh(&rdev->pan_lock);
+}
+
+int cfg802154_record_pan(struct wpan_phy *wpan_phy,
+			 struct ieee802154_pan_desc *desc)
+{
+	struct cfg802154_registered_device *rdev = wpan_phy_to_rdev(wpan_phy);
+	struct cfg802154_internal_pan *new;
+
+	new = cfg802154_alloc_pan(desc);
+	if (IS_ERR(new))
+		return (PTR_ERR(new));
+
+	cfg802154_pan_update(rdev, new);
+
+	return 0;
+}
+EXPORT_SYMBOL(cfg802154_record_pan);
-- 
2.27.0

