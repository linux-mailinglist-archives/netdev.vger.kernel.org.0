Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 573114907EC
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 12:56:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239484AbiAQL41 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 06:56:27 -0500
Received: from relay12.mail.gandi.net ([217.70.178.232]:56781 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239376AbiAQLzp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 06:55:45 -0500
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id 6394B200014;
        Mon, 17 Jan 2022 11:55:42 +0000 (UTC)
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Varka Bhadram <varkabhadram@gmail.com>,
        Xue Liu <liuxuenetmail@gmail.com>, Alan Ott <alan@signal11.us>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH v3 33/41] net: mac802154: Handle scan requests
Date:   Mon, 17 Jan 2022 12:54:32 +0100
Message-Id: <20220117115440.60296-34-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220117115440.60296-1-miquel.raynal@bootlin.com>
References: <20220117115440.60296-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement the core hooks in order to provide the softMAC layer support
for scan requests and aborts.

Changing the channels is prohibited during the scan.

As transceiver enter in a promiscuous mode during scans, they might stop
checking frame validity so we ensure this gets done at mac level.

The implementation uses a workqueue triggered at a certain interval
depending on the symbol duration for the current channel and the
duration order provided.

Received beacons during a passive scanning procedure are processed and
either registered in the list of known PANs or the existing entry gets
updated accordingly.

Active scanning is not supported yet.

Co-developed-by: David Girault <david.girault@qorvo.com>
Signed-off-by: David Girault <david.girault@qorvo.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 include/linux/ieee802154.h   |   4 +
 include/net/mac802154.h      |  14 ++
 net/mac802154/Makefile       |   2 +-
 net/mac802154/cfg.c          |  39 ++++++
 net/mac802154/ieee802154_i.h |  22 +++
 net/mac802154/main.c         |   2 +-
 net/mac802154/rx.c           |  21 ++-
 net/mac802154/scan.c         | 259 +++++++++++++++++++++++++++++++++++
 net/mac802154/tx.c           |   3 +
 net/mac802154/util.c         |  26 ++++
 10 files changed, 385 insertions(+), 7 deletions(-)
 create mode 100644 net/mac802154/scan.c

diff --git a/include/linux/ieee802154.h b/include/linux/ieee802154.h
index 41178c87c43c..57bf5317338e 100644
--- a/include/linux/ieee802154.h
+++ b/include/linux/ieee802154.h
@@ -47,6 +47,10 @@
 /* Duration in superframe order */
 #define IEEE802154_MAX_SCAN_DURATION	14
 #define IEEE802154_ACTIVE_SCAN_DURATION	15
+/* Superframe duration in slots */
+#define IEEE802154_SUPERFRAME_PERIOD	16
+/* Various periods expressed in symbols */
+#define IEEE802154_SLOT_PERIOD		60
 #define IEEE802154_LIFS_PERIOD		40
 #define IEEE802154_SIFS_PERIOD		12
 #define IEEE802154_MAX_SIFS_FRAME_SIZE	18
diff --git a/include/net/mac802154.h b/include/net/mac802154.h
index 13798867b8d3..a2eec8786628 100644
--- a/include/net/mac802154.h
+++ b/include/net/mac802154.h
@@ -471,4 +471,18 @@ void ieee802154_rx_irqsafe(struct ieee802154_hw *hw, struct sk_buff *skb,
 void ieee802154_xmit_complete(struct ieee802154_hw *hw, struct sk_buff *skb,
 			      bool ifs_handling);
 
+/**
+ * ieee802154_queue_delayed_work - add work onto the mac802154 workqueue
+ *
+ * Drivers and mac802154 use this to queue delayed work onto the mac802154
+ * workqueue.
+ *
+ * @hw: the hardware struct for the interface we are adding work for
+ * @dwork: delayable work to queue onto the mac802154 workqueue
+ * @delay: number of jiffies to wait before queueing
+ */
+void ieee802154_queue_delayed_work(struct ieee802154_hw *hw,
+				   struct delayed_work *dwork,
+				   unsigned long delay);
+
 #endif /* NET_MAC802154_H */
diff --git a/net/mac802154/Makefile b/net/mac802154/Makefile
index 4059295fdbf8..43d1347b37ee 100644
--- a/net/mac802154/Makefile
+++ b/net/mac802154/Makefile
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0-only
 obj-$(CONFIG_MAC802154)	+= mac802154.o
 mac802154-objs		:= main.o rx.o tx.o mac_cmd.o mib.o \
-			   iface.o llsec.o util.o cfg.o trace.o
+			   iface.o llsec.o util.o cfg.o scan.o trace.o
 
 CFLAGS_trace.o := -I$(src)
diff --git a/net/mac802154/cfg.c b/net/mac802154/cfg.c
index e2900c9b788c..958b609b8c1b 100644
--- a/net/mac802154/cfg.c
+++ b/net/mac802154/cfg.c
@@ -117,6 +117,10 @@ ieee802154_set_channel(struct wpan_phy *wpan_phy, u8 page, u8 channel)
 	    wpan_phy->current_channel == channel)
 		return 0;
 
+	/* Refuse to change channels during a scanning operation */
+	if (mac802154_scan_is_ongoing(local))
+		return -EBUSY;
+
 	ret = drv_set_channel(local, page, channel);
 	if (!ret) {
 		wpan_phy->current_page = page;
@@ -264,6 +268,39 @@ ieee802154_set_ackreq_default(struct wpan_phy *wpan_phy,
 	return 0;
 }
 
+static int mac802154_trigger_scan(struct wpan_phy *wpan_phy,
+				  struct cfg802154_scan_request *req)
+{
+	struct ieee802154_local *local = wpan_phy_priv(wpan_phy);
+	struct ieee802154_sub_if_data *sdata;
+	int ret;
+
+	sdata = IEEE802154_WPAN_DEV_TO_SUB_IF(req->wpan_dev);
+
+	ASSERT_RTNL();
+
+	mutex_lock(&local->scan_lock);
+	ret = mac802154_trigger_scan_locked(sdata, req);
+	mutex_unlock(&local->scan_lock);
+
+	return ret;
+}
+
+static int mac802154_abort_scan(struct wpan_phy *wpan_phy,
+				struct wpan_dev *wpan_dev)
+{
+	struct ieee802154_local *local = wpan_phy_priv(wpan_phy);
+	int ret;
+
+	ASSERT_RTNL();
+
+	mutex_lock(&local->scan_lock);
+	ret = mac802154_abort_scan_locked(local);
+	mutex_unlock(&local->scan_lock);
+
+	return ret;
+}
+
 #ifdef CONFIG_IEEE802154_NL802154_EXPERIMENTAL
 static void
 ieee802154_get_llsec_table(struct wpan_phy *wpan_phy,
@@ -471,6 +508,8 @@ const struct cfg802154_ops mac802154_config_ops = {
 	.set_max_frame_retries = ieee802154_set_max_frame_retries,
 	.set_lbt_mode = ieee802154_set_lbt_mode,
 	.set_ackreq_default = ieee802154_set_ackreq_default,
+	.trigger_scan = mac802154_trigger_scan,
+	.abort_scan = mac802154_abort_scan,
 #ifdef CONFIG_IEEE802154_NL802154_EXPERIMENTAL
 	.get_llsec_table = ieee802154_get_llsec_table,
 	.lock_llsec_table = ieee802154_lock_llsec_table,
diff --git a/net/mac802154/ieee802154_i.h b/net/mac802154/ieee802154_i.h
index 40195e2a6f1e..f7562f4cacdf 100644
--- a/net/mac802154/ieee802154_i.h
+++ b/net/mac802154/ieee802154_i.h
@@ -48,6 +48,15 @@ struct ieee802154_local {
 
 	struct hrtimer ifs_timer;
 
+	/* Scanning */
+	struct mutex scan_lock;
+	atomic_t scanning;
+	__le64 scan_addr;
+	int scan_channel_idx;
+	struct cfg802154_scan_request __rcu *scan_req;
+	struct ieee802154_sub_if_data __rcu *scan_sdata;
+	struct delayed_work scan_work;
+
 	bool started;
 	bool suspended;
 
@@ -197,6 +206,19 @@ static inline bool mac802154_queue_is_stopped(struct ieee802154_local *local)
 	return atomic_read(&local->phy->hold_txs);
 }
 
+/* scanning handling */
+void mac802154_scan_work(struct work_struct *work);
+int mac802154_trigger_scan_locked(struct ieee802154_sub_if_data *sdata,
+				  struct cfg802154_scan_request *request);
+int mac802154_abort_scan_locked(struct ieee802154_local *local);
+int mac802154_scan_process_beacon(struct ieee802154_local *local,
+				  struct sk_buff *skb);
+
+static inline bool mac802154_scan_is_ongoing(struct ieee802154_local *local)
+{
+	return atomic_read(&local->scanning);
+}
+
 /* interface handling */
 int ieee802154_iface_init(void);
 void ieee802154_iface_exit(void);
diff --git a/net/mac802154/main.c b/net/mac802154/main.c
index 43fd4cc13b66..bd453b1c0223 100644
--- a/net/mac802154/main.c
+++ b/net/mac802154/main.c
@@ -90,6 +90,7 @@ ieee802154_alloc_hw(size_t priv_data_len, const struct ieee802154_ops *ops)
 
 	INIT_LIST_HEAD(&local->interfaces);
 	mutex_init(&local->iflist_mtx);
+	mutex_init(&local->scan_lock);
 
 	tasklet_setup(&local->tasklet, ieee802154_tasklet_handler);
 
@@ -97,7 +98,6 @@ ieee802154_alloc_hw(size_t priv_data_len, const struct ieee802154_ops *ops)
 
 	INIT_WORK(&local->sync_tx_work, ieee802154_xmit_sync_worker);
 	INIT_DELAYED_WORK(&local->scan_work, mac802154_scan_work);
-	INIT_DELAYED_WORK(&local->beacons_work, mac802154_beacons_work);
 
 	/* init supported flags with 802.15.4 default ranges */
 	phy->supported.max_minbe = 8;
diff --git a/net/mac802154/rx.c b/net/mac802154/rx.c
index b8ce84618a55..f2f3eca9bc20 100644
--- a/net/mac802154/rx.c
+++ b/net/mac802154/rx.c
@@ -94,10 +94,15 @@ ieee802154_subif_frame(struct ieee802154_sub_if_data *sdata,
 
 	switch (mac_cb(skb)->type) {
 	case IEEE802154_FC_TYPE_BEACON:
-	case IEEE802154_FC_TYPE_ACK:
+		if (mac802154_scan_is_ongoing(sdata->local)) {
+			rc = mac802154_scan_process_beacon(sdata->local, skb);
+			if (!rc)
+				goto success;
+		}
+		goto fail;
 	case IEEE802154_FC_TYPE_MAC_CMD:
+	case IEEE802154_FC_TYPE_ACK:
 		goto fail;
-
 	case IEEE802154_FC_TYPE_DATA:
 		return ieee802154_deliver_skb(skb);
 	default:
@@ -109,6 +114,10 @@ ieee802154_subif_frame(struct ieee802154_sub_if_data *sdata,
 fail:
 	kfree_skb(skb);
 	return NET_RX_DROP;
+
+success:
+	kfree_skb(skb);
+	return NET_RX_SUCCESS;
 }
 
 static void
@@ -268,10 +277,12 @@ void ieee802154_rx(struct ieee802154_local *local, struct sk_buff *skb)
 
 	ieee802154_monitors_rx(local, skb);
 
-	/* Check if transceiver doesn't validate the checksum.
-	 * If not we validate the checksum here.
+	/* Check if the transceiver doesn't validate the checksum, or if the
+	 * check might have been disabled like during a scan. In these cases,
+	 * we validate the checksum here.
 	 */
-	if (local->hw.flags & IEEE802154_HW_RX_DROP_BAD_CKSUM) {
+	if (local->hw.flags & IEEE802154_HW_RX_DROP_BAD_CKSUM ||
+	    mac802154_scan_is_ongoing(local)) {
 		crc = crc_ccitt(0, skb->data, skb->len);
 		if (crc) {
 			rcu_read_unlock();
diff --git a/net/mac802154/scan.c b/net/mac802154/scan.c
new file mode 100644
index 000000000000..3129cc95157a
--- /dev/null
+++ b/net/mac802154/scan.c
@@ -0,0 +1,259 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * IEEE 802.15.4 scanning management
+ *
+ * Copyright (C) Qorvo, 2021
+ * Authors:
+ *   - David Girault <david.girault@qorvo.com>
+ *   - Miquel Raynal <miquel.raynal@bootlin.com>
+ */
+
+#include <linux/module.h>
+#include <linux/random.h>
+#include <linux/rtnetlink.h>
+#include <net/mac802154.h>
+
+#include "ieee802154_i.h"
+#include "driver-ops.h"
+#include "../ieee802154/nl802154.h"
+
+static bool mac802154_check_promiscuous(struct ieee802154_local *local)
+{
+	struct ieee802154_sub_if_data *sdata;
+	bool promiscuous_on = false;
+
+	/* Check if one subif is already in promiscuous mode. Since the list is
+	 * protected by its own mutex, take it here to ensure no modification
+	 * occurs during the check.
+	 */
+	mutex_lock(&local->iflist_mtx);
+	list_for_each_entry(sdata, &local->interfaces, list) {
+		if (ieee802154_sdata_running(sdata) &&
+		    sdata->wpan_dev.promiscuous_mode) {
+			/* At least one is in promiscuous mode */
+			promiscuous_on = true;
+			break;
+		}
+	}
+	mutex_unlock(&local->iflist_mtx);
+	return promiscuous_on;
+}
+
+static int mac802154_set_promiscuous_mode(struct ieee802154_local *local,
+					  bool state)
+{
+	bool promiscuous_on = mac802154_check_promiscuous(local);
+	int ret;
+
+	if ((state && promiscuous_on) || (!state && !promiscuous_on))
+		return 0;
+
+	ret = drv_set_promiscuous_mode(local, state);
+	if (ret)
+		pr_err("Failed to %s promiscuous mode for SW scanning",
+		       state ? "set" : "reset");
+
+	return ret;
+}
+
+static int mac802154_send_scan_done(struct ieee802154_local *local)
+{
+	struct cfg802154_registered_device *rdev;
+	struct cfg802154_scan_request *scan_req;
+	struct wpan_dev *wpan_dev;
+
+	scan_req = rcu_dereference_protected(local->scan_req,
+					     lockdep_is_held(&local->scan_lock));
+	rdev = wpan_phy_to_rdev(scan_req->wpan_phy);
+	wpan_dev = scan_req->wpan_dev;
+
+	return nl802154_send_scan_done(rdev, wpan_dev);
+}
+
+static int mac802154_end_of_scan(struct ieee802154_local *local)
+{
+	drv_set_channel(local, local->phy->current_page,
+			local->phy->current_channel);
+	ieee802154_configure_durations(local->phy);
+	atomic_dec(&local->phy->hold_txs);
+	atomic_set(&local->scanning, 0);
+	mac802154_set_promiscuous_mode(local, false);
+	ieee802154_wake_queue(&local->hw);
+
+	return mac802154_send_scan_done(local);
+}
+
+int mac802154_abort_scan_locked(struct ieee802154_local *local)
+{
+	lockdep_assert_held(&local->scan_lock);
+
+	if (!mac802154_scan_is_ongoing(local))
+		return -ESRCH;
+
+	cancel_delayed_work(&local->scan_work);
+
+	return mac802154_end_of_scan(local);
+}
+
+static unsigned int mac802154_scan_get_channel_time(u8 duration_order,
+						    u8 symbol_duration)
+{
+	u64 base_super_frame_duration = (u64)symbol_duration *
+		IEEE802154_SUPERFRAME_PERIOD * IEEE802154_SLOT_PERIOD;
+
+	return usecs_to_jiffies(base_super_frame_duration *
+				(BIT(duration_order) + 1));
+}
+
+void mac802154_scan_work(struct work_struct *work)
+{
+	struct ieee802154_local *local =
+		container_of(work, struct ieee802154_local, scan_work.work);
+	struct cfg802154_scan_request *scan_req;
+	struct ieee802154_sub_if_data *sdata;
+	unsigned int scan_duration;
+	bool end_of_scan = false;
+	unsigned long chan;
+	int ret;
+
+	mutex_lock(&local->scan_lock);
+
+	if (!mac802154_scan_is_ongoing(local))
+		goto unlock_mutex;
+
+	sdata = rcu_dereference_protected(local->scan_sdata,
+					  lockdep_is_held(&local->scan_lock));
+	scan_req = rcu_dereference_protected(local->scan_req,
+					     lockdep_is_held(&local->scan_lock));
+
+	if (local->suspended || !ieee802154_sdata_running(sdata))
+		goto queue_work;
+
+	do {
+		chan = find_next_bit((const unsigned long *)&scan_req->channels,
+				     IEEE802154_MAX_CHANNEL + 1,
+				     local->scan_channel_idx + 1);
+
+		/* If there are no more channels left, complete the scan */
+		if (chan > IEEE802154_MAX_CHANNEL) {
+			end_of_scan = true;
+			goto unlock_mutex;
+		}
+
+		/* Channel switch cannot be made atomic so hide the chan number
+		 * in order to prevent beacon processing during this timeframe.
+		 */
+		local->scan_channel_idx = -1;
+		/* Bypass the stack on purpose */
+		ret = drv_set_channel(local, scan_req->page, chan);
+		local->scan_channel_idx = chan;
+		ieee802154_configure_durations(local->phy);
+	} while (ret);
+
+queue_work:
+	scan_duration = mac802154_scan_get_channel_time(scan_req->duration,
+							local->phy->symbol_duration);
+	pr_debug("Scan channel %lu of page %u for %ums\n",
+		 chan, scan_req->page, jiffies_to_msecs(scan_duration));
+	ieee802154_queue_delayed_work(&local->hw, &local->scan_work,
+				      scan_duration);
+
+unlock_mutex:
+	if (end_of_scan)
+		mac802154_end_of_scan(local);
+
+	mutex_unlock(&local->scan_lock);
+}
+
+int mac802154_trigger_scan_locked(struct ieee802154_sub_if_data *sdata,
+				  struct cfg802154_scan_request *request)
+{
+	struct ieee802154_local *local = sdata->local;
+	int ret;
+
+	lockdep_assert_held(&local->scan_lock);
+
+	if (mac802154_scan_is_ongoing(local))
+		return -EBUSY;
+
+	/* TODO: support other scanning type */
+	if (request->type != NL802154_SCAN_PASSIVE)
+		return -EOPNOTSUPP;
+
+	/* Store scanning parameters */
+	rcu_assign_pointer(local->scan_req, request);
+	rcu_assign_pointer(local->scan_sdata, sdata);
+
+	/* Configure scan_addr to use net_device addr or random */
+	if (request->flags & NL802154_SCAN_FLAG_RANDOM_ADDR)
+		get_random_bytes(&local->scan_addr, sizeof(local->scan_addr));
+	else
+		local->scan_addr = cpu_to_le64(get_unaligned_be64(sdata->dev->dev_addr));
+
+	local->scan_channel_idx = -1;
+	atomic_set(&local->scanning, 1);
+
+	/* Software scanning requires to set promiscuous mode, so we need to
+	 * pause the Tx queue
+	 */
+	atomic_inc(&local->phy->hold_txs);
+	ieee802154_stop_queue(&local->hw);
+	ieee802154_sync_tx(local);
+
+	ret = mac802154_set_promiscuous_mode(local, true);
+	if (ret)
+		return mac802154_end_of_scan(local);
+
+	ieee802154_queue_delayed_work(&local->hw, &local->scan_work, 0);
+
+	return 0;
+}
+
+int mac802154_scan_process_beacon(struct ieee802154_local *local,
+				  struct sk_buff *skb)
+{
+	struct ieee802154_beacon_hdr *bh = (void *)skb->data;
+	struct ieee802154_addr *src = &mac_cb(skb)->source;
+	struct cfg802154_scan_request *scan_req;
+	struct ieee802154_pan_desc desc = {};
+	int ret;
+
+	/* Check the validity of the frame length */
+	if (skb->len < sizeof(*bh))
+		return -EINVAL;
+
+	if (unlikely(src->mode == IEEE802154_ADDR_NONE))
+		return -EINVAL;
+
+	if (unlikely(!bh->pan_coordinator))
+		return -ENODEV;
+
+	scan_req = rcu_dereference(local->scan_req);
+	if (unlikely(!scan_req))
+		return -EINVAL;
+
+	if (unlikely(local->scan_channel_idx < 0)) {
+		pr_info("Dropping beacon received during channel change\n");
+		return 0;
+	}
+
+	pr_debug("Beacon received on channel %d of page %d\n",
+		 local->scan_channel_idx, scan_req->page);
+
+	/* Parse beacon and create PAN information */
+	desc.coord = src;
+	desc.page = scan_req->page;
+	desc.channel = local->scan_channel_idx;
+	desc.link_quality = mac_cb(skb)->lqi;
+	desc.superframe_spec = get_unaligned_le16(skb->data);
+	desc.gts_permit = bh->gts_permit;
+
+	/* Create or update the PAN entry in the management layer */
+	ret = cfg802154_record_pan(local->phy, &desc);
+	if (ret) {
+		pr_err("Failed to save PAN descriptor\n");
+		return ret;
+	}
+
+	return 0;
+}
diff --git a/net/mac802154/tx.c b/net/mac802154/tx.c
index 334843f66ec4..1849e5cb5945 100644
--- a/net/mac802154/tx.c
+++ b/net/mac802154/tx.c
@@ -58,6 +58,9 @@ ieee802154_tx(struct ieee802154_local *local, struct sk_buff *skb)
 	struct net_device *dev = skb->dev;
 	int ret;
 
+	if (unlikely(mac802154_scan_is_ongoing(local)))
+		return NETDEV_TX_BUSY;
+
 	if (!(local->hw.flags & IEEE802154_HW_TX_OMIT_CKSUM)) {
 		struct sk_buff *nskb;
 		u16 crc;
diff --git a/net/mac802154/util.c b/net/mac802154/util.c
index 230fe3390df7..5642a45df548 100644
--- a/net/mac802154/util.c
+++ b/net/mac802154/util.c
@@ -100,3 +100,29 @@ void ieee802154_stop_device(struct ieee802154_local *local)
 	hrtimer_cancel(&local->ifs_timer);
 	drv_stop(local);
 }
+
+/* Nothing should have been stuffed into the workqueue during
+ * the suspend->resume cycle.
+ */
+static bool ieee802154_can_queue_work(struct ieee802154_local *local)
+{
+	if (local->suspended) {
+		pr_warn("queueing ieee802154 work while suspended\n");
+		return false;
+	}
+
+	return true;
+}
+
+void ieee802154_queue_delayed_work(struct ieee802154_hw *hw,
+				   struct delayed_work *dwork,
+				   unsigned long delay)
+{
+	struct ieee802154_local *local = hw_to_local(hw);
+
+	if (!ieee802154_can_queue_work(local))
+		return;
+
+	queue_delayed_work(local->workqueue, dwork, delay);
+}
+EXPORT_SYMBOL(ieee802154_queue_delayed_work);
-- 
2.27.0

