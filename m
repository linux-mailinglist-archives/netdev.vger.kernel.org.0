Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D94763C493
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 17:03:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236091AbiK2QDZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 11:03:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236087AbiK2QCf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 11:02:35 -0500
Received: from relay5-d.mail.gandi.net (relay5-d.mail.gandi.net [217.70.183.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A1DE663F0;
        Tue, 29 Nov 2022 08:01:06 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id AF5311C001C;
        Tue, 29 Nov 2022 16:01:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1669737665;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=G3W8He/vdKVnWmP91JIUA8DjOoJiFgZDIVh5xNi7tf4=;
        b=hm1W403J+IWlzsaEOmA+3PJghqpSfpNDH6zD43B4of94BCJCSuahmmfqrSHppW0GYq1qR/
        pwTkG3Y94Bj47xlP5SuvKKE/gujNsb1xF5tyIqETBekQlWl48ffZddf5fmxdqjiuEn0L/g
        X272YK80Pjz3MbLdDCUGu3aaLyAN/7L1b/lVvO4Z9b3F5m0k3Xwk0dlxTPplpVU6hmsTLm
        36KrJKQop7CYRuCdNGt2fmXmcDRQslm3O8/YAuBOO2MryDj2bGiBGWRkiuMUs22J9GD181
        0fuIfp8LZJdA2rlLAQd/fx5Ih35MxWyMl4w41dfxnJGFm37DZ1jGj9XUoto21w==
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
        Guilhem Imberton <guilhem.imberton@qorvo.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH wpan-next 6/6] mac802154: Handle passive scanning
Date:   Tue, 29 Nov 2022 17:00:46 +0100
Message-Id: <20221129160046.538864-7-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221129160046.538864-1-miquel.raynal@bootlin.com>
References: <20221129160046.538864-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement the core hooks in order to provide the softMAC layer support
for passive scans. Scans are requested by the user and can be aborted.

Changing channels manually is prohibited during scans.

The implementation uses a workqueue triggered at a certain interval
depending on the symbol duration for the current channel and the
duration order provided. More advanced drivers with internal scheduling
capabilities might require additional care but there is none mainline
yet.

Received beacons during a passive scan are processed in a work queue and
their result forwarded to the upper layer.

Active scanning is not supported yet.

Co-developed-by: David Girault <david.girault@qorvo.com>
Signed-off-by: David Girault <david.girault@qorvo.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 include/linux/ieee802154.h   |   4 +
 include/net/cfg802154.h      |  16 ++
 net/mac802154/Makefile       |   2 +-
 net/mac802154/cfg.c          |  31 ++++
 net/mac802154/ieee802154_i.h |  37 ++++-
 net/mac802154/iface.c        |   3 +
 net/mac802154/main.c         |  16 +-
 net/mac802154/rx.c           |  36 ++++-
 net/mac802154/scan.c         | 286 +++++++++++++++++++++++++++++++++++
 9 files changed, 425 insertions(+), 6 deletions(-)
 create mode 100644 net/mac802154/scan.c

diff --git a/include/linux/ieee802154.h b/include/linux/ieee802154.h
index b22e4147d334..140f61ec0f5f 100644
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
diff --git a/include/net/cfg802154.h b/include/net/cfg802154.h
index 5d4750d24f13..090e1ad64a55 100644
--- a/include/net/cfg802154.h
+++ b/include/net/cfg802154.h
@@ -314,6 +314,22 @@ struct cfg802154_scan_request {
 	struct wpan_phy *wpan_phy;
 };
 
+/**
+ * struct cfg802154_mac_pkt - MAC packet descriptor (beacon/command)
+ * @node: MAC packets to process list member
+ * @skb: the received sk_buff
+ * @sdata: the interface on which @skb was received
+ * @page: page configuration when @skb was received
+ * @channel: channel configuration when @skb was received
+ */
+struct cfg802154_mac_pkt {
+	struct list_head node;
+	struct sk_buff *skb;
+	struct ieee802154_sub_if_data *sdata;
+	u8 page;
+	u8 channel;
+};
+
 struct ieee802154_llsec_key_id {
 	u8 mode;
 	u8 id;
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
index 469d6e8dd2dd..187cebcaf233 100644
--- a/net/mac802154/cfg.c
+++ b/net/mac802154/cfg.c
@@ -114,6 +114,10 @@ ieee802154_set_channel(struct wpan_phy *wpan_phy, u8 page, u8 channel)
 	    wpan_phy->current_channel == channel)
 		return 0;
 
+	/* Refuse to change channels during a scanning operation */
+	if (mac802154_is_scanning(local))
+		return -EBUSY;
+
 	ret = drv_set_channel(local, page, channel);
 	if (!ret) {
 		wpan_phy->current_page = page;
@@ -261,6 +265,31 @@ ieee802154_set_ackreq_default(struct wpan_phy *wpan_phy,
 	return 0;
 }
 
+static int mac802154_trigger_scan(struct wpan_phy *wpan_phy,
+				  struct cfg802154_scan_request *request)
+{
+	struct ieee802154_sub_if_data *sdata;
+
+	sdata = IEEE802154_WPAN_DEV_TO_SUB_IF(request->wpan_dev);
+
+	ASSERT_RTNL();
+
+	return mac802154_trigger_scan_locked(sdata, request);
+}
+
+static int mac802154_abort_scan(struct wpan_phy *wpan_phy,
+				struct wpan_dev *wpan_dev)
+{
+	struct ieee802154_local *local = wpan_phy_priv(wpan_phy);
+	struct ieee802154_sub_if_data *sdata;
+
+	sdata = IEEE802154_WPAN_DEV_TO_SUB_IF(wpan_dev);
+
+	ASSERT_RTNL();
+
+	return mac802154_abort_scan_locked(local, sdata);
+}
+
 #ifdef CONFIG_IEEE802154_NL802154_EXPERIMENTAL
 static void
 ieee802154_get_llsec_table(struct wpan_phy *wpan_phy,
@@ -468,6 +497,8 @@ const struct cfg802154_ops mac802154_config_ops = {
 	.set_max_frame_retries = ieee802154_set_max_frame_retries,
 	.set_lbt_mode = ieee802154_set_lbt_mode,
 	.set_ackreq_default = ieee802154_set_ackreq_default,
+	.trigger_scan = mac802154_trigger_scan,
+	.abort_scan = mac802154_abort_scan,
 #ifdef CONFIG_IEEE802154_NL802154_EXPERIMENTAL
 	.get_llsec_table = ieee802154_get_llsec_table,
 	.lock_llsec_table = ieee802154_lock_llsec_table,
diff --git a/net/mac802154/ieee802154_i.h b/net/mac802154/ieee802154_i.h
index aeadee543a9c..0e4db967bd1d 100644
--- a/net/mac802154/ieee802154_i.h
+++ b/net/mac802154/ieee802154_i.h
@@ -21,6 +21,10 @@
 
 #include "llsec.h"
 
+enum ieee802154_ongoing {
+	IEEE802154_IS_SCANNING = BIT(0),
+};
+
 /* mac802154 device private data */
 struct ieee802154_local {
 	struct ieee802154_hw hw;
@@ -43,15 +47,26 @@ struct ieee802154_local {
 	struct list_head	interfaces;
 	struct mutex		iflist_mtx;
 
-	/* This one is used for scanning and other jobs not to be interfered
-	 * with serial driver.
-	 */
+	/* Data related workqueue */
 	struct workqueue_struct	*workqueue;
+	/* MAC commands related workqueue */
+	struct workqueue_struct	*mac_wq;
 
 	struct hrtimer ifs_timer;
 
+	/* Scanning */
+	u8 scan_page;
+	u8 scan_channel;
+	struct cfg802154_scan_request __rcu *scan_req;
+	struct delayed_work scan_work;
+
+	/* Asynchronous tasks */
+	struct list_head rx_beacon_list;
+	struct work_struct rx_beacon_work;
+
 	bool started;
 	bool suspended;
+	unsigned long ongoing;
 
 	struct tasklet_struct tasklet;
 	struct sk_buff_head skb_queue;
@@ -226,6 +241,22 @@ void mac802154_unlock_table(struct net_device *dev);
 
 int mac802154_wpan_update_llsec(struct net_device *dev);
 
+/* PAN management handling */
+void mac802154_scan_worker(struct work_struct *work);
+int mac802154_trigger_scan_locked(struct ieee802154_sub_if_data *sdata,
+				  struct cfg802154_scan_request *request);
+int mac802154_abort_scan_locked(struct ieee802154_local *local,
+				struct ieee802154_sub_if_data *sdata);
+int mac802154_process_beacon(struct ieee802154_local *local,
+			     struct sk_buff *skb,
+			     u8 page, u8 channel);
+void mac802154_rx_beacon_worker(struct work_struct *work);
+
+static inline bool mac802154_is_scanning(struct ieee802154_local *local)
+{
+	return test_bit(IEEE802154_IS_SCANNING, &local->ongoing);
+}
+
 /* interface handling */
 int ieee802154_iface_init(void);
 void ieee802154_iface_exit(void);
diff --git a/net/mac802154/iface.c b/net/mac802154/iface.c
index 7de2f843379c..a5958d323ea3 100644
--- a/net/mac802154/iface.c
+++ b/net/mac802154/iface.c
@@ -302,6 +302,9 @@ static int mac802154_slave_close(struct net_device *dev)
 
 	ASSERT_RTNL();
 
+	if (mac802154_is_scanning(local))
+		mac802154_abort_scan_locked(local, sdata);
+
 	netif_stop_queue(dev);
 	local->open_count--;
 
diff --git a/net/mac802154/main.c b/net/mac802154/main.c
index 12a13a850fdf..b1111279e06d 100644
--- a/net/mac802154/main.c
+++ b/net/mac802154/main.c
@@ -89,6 +89,7 @@ ieee802154_alloc_hw(size_t priv_data_len, const struct ieee802154_ops *ops)
 	local->ops = ops;
 
 	INIT_LIST_HEAD(&local->interfaces);
+	INIT_LIST_HEAD(&local->rx_beacon_list);
 	mutex_init(&local->iflist_mtx);
 
 	tasklet_setup(&local->tasklet, ieee802154_tasklet_handler);
@@ -96,6 +97,8 @@ ieee802154_alloc_hw(size_t priv_data_len, const struct ieee802154_ops *ops)
 	skb_queue_head_init(&local->skb_queue);
 
 	INIT_WORK(&local->sync_tx_work, ieee802154_xmit_sync_worker);
+	INIT_DELAYED_WORK(&local->scan_work, mac802154_scan_worker);
+	INIT_WORK(&local->rx_beacon_work, mac802154_rx_beacon_worker);
 
 	/* init supported flags with 802.15.4 default ranges */
 	phy->supported.max_minbe = 8;
@@ -185,6 +188,7 @@ static void ieee802154_setup_wpan_phy_pib(struct wpan_phy *wpan_phy)
 int ieee802154_register_hw(struct ieee802154_hw *hw)
 {
 	struct ieee802154_local *local = hw_to_local(hw);
+	char mac_wq_name[IFNAMSIZ + 10] = {};
 	struct net_device *dev;
 	int rc = -ENOSYS;
 
@@ -195,6 +199,13 @@ int ieee802154_register_hw(struct ieee802154_hw *hw)
 		goto out;
 	}
 
+	snprintf(mac_wq_name, IFNAMSIZ + 10, "%s-mac-cmds", wpan_phy_name(local->phy));
+	local->mac_wq =	create_singlethread_workqueue(mac_wq_name);
+	if (!local->mac_wq) {
+		rc = -ENOMEM;
+		goto out_wq;
+	}
+
 	hrtimer_init(&local->ifs_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
 	local->ifs_timer.function = ieee802154_xmit_ifs_timer;
 
@@ -224,7 +235,7 @@ int ieee802154_register_hw(struct ieee802154_hw *hw)
 
 	rc = wpan_phy_register(local->phy);
 	if (rc < 0)
-		goto out_wq;
+		goto out_mac_wq;
 
 	rtnl_lock();
 
@@ -243,6 +254,8 @@ int ieee802154_register_hw(struct ieee802154_hw *hw)
 
 out_phy:
 	wpan_phy_unregister(local->phy);
+out_mac_wq:
+	destroy_workqueue(local->mac_wq);
 out_wq:
 	destroy_workqueue(local->workqueue);
 out:
@@ -263,6 +276,7 @@ void ieee802154_unregister_hw(struct ieee802154_hw *hw)
 
 	rtnl_unlock();
 
+	destroy_workqueue(local->mac_wq);
 	destroy_workqueue(local->workqueue);
 	wpan_phy_unregister(local->phy);
 }
diff --git a/net/mac802154/rx.c b/net/mac802154/rx.c
index c2aae2a6d6a6..2b0a80571097 100644
--- a/net/mac802154/rx.c
+++ b/net/mac802154/rx.c
@@ -29,12 +29,31 @@ static int ieee802154_deliver_skb(struct sk_buff *skb)
 	return netif_receive_skb(skb);
 }
 
+void mac802154_rx_beacon_worker(struct work_struct *work)
+{
+	struct ieee802154_local *local =
+		container_of(work, struct ieee802154_local, rx_beacon_work);
+	struct cfg802154_mac_pkt *mac_pkt;
+
+	mac_pkt = list_first_entry_or_null(&local->rx_beacon_list,
+					   struct cfg802154_mac_pkt, node);
+	if (!mac_pkt)
+		return;
+
+	mac802154_process_beacon(local, mac_pkt->skb, mac_pkt->page, mac_pkt->channel);
+
+	list_del(&mac_pkt->node);
+	kfree_skb(mac_pkt->skb);
+	kfree(mac_pkt);
+}
+
 static int
 ieee802154_subif_frame(struct ieee802154_sub_if_data *sdata,
 		       struct sk_buff *skb, const struct ieee802154_hdr *hdr)
 {
-	struct wpan_dev *wpan_dev = &sdata->wpan_dev;
 	struct wpan_phy *wpan_phy = sdata->local->hw.phy;
+	struct wpan_dev *wpan_dev = &sdata->wpan_dev;
+	struct cfg802154_mac_pkt *mac_pkt;
 	__le16 span, sshort;
 	int rc;
 
@@ -106,6 +125,21 @@ ieee802154_subif_frame(struct ieee802154_sub_if_data *sdata,
 
 	switch (mac_cb(skb)->type) {
 	case IEEE802154_FC_TYPE_BEACON:
+		dev_dbg(&sdata->dev->dev, "BEACON received\n");
+		if (!mac802154_is_scanning(sdata->local))
+			goto fail;
+
+		mac_pkt = kzalloc(sizeof(*mac_pkt), GFP_ATOMIC);
+		if (!mac_pkt)
+			goto fail;
+
+		mac_pkt->skb = skb_get(skb);
+		mac_pkt->sdata = sdata;
+		mac_pkt->page = sdata->local->scan_page;
+		mac_pkt->channel = sdata->local->scan_channel;
+		list_add_tail(&mac_pkt->node, &sdata->local->rx_beacon_list);
+		queue_work(sdata->local->mac_wq, &sdata->local->rx_beacon_work);
+		return NET_RX_SUCCESS;
 	case IEEE802154_FC_TYPE_ACK:
 	case IEEE802154_FC_TYPE_MAC_CMD:
 		goto fail;
diff --git a/net/mac802154/scan.c b/net/mac802154/scan.c
new file mode 100644
index 000000000000..afe4e380058d
--- /dev/null
+++ b/net/mac802154/scan.c
@@ -0,0 +1,286 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * IEEE 802.15.4 scanning management
+ *
+ * Copyright (C) 2021 Qorvo US, Inc
+ * Authors:
+ *   - David Girault <david.girault@qorvo.com>
+ *   - Miquel Raynal <miquel.raynal@bootlin.com>
+ */
+
+#include <linux/module.h>
+#include <linux/rtnetlink.h>
+#include <net/mac802154.h>
+
+#include "ieee802154_i.h"
+#include "driver-ops.h"
+#include "../ieee802154/nl802154.h"
+
+/*
+ * mac802154_scan_cleanup_locked() must be called upon scan completion or abort.
+ * - Completions are asynchronous, not locked by the rtnl and decided by the
+ *   scan worker.
+ * - Aborts are decided by userspace, and locked by the rtnl.
+ *
+ * Concurrent modifications to the PHY, the interfaces or the hardware is in
+ * general prevented by the rtnl. So in most cases we don't need additional
+ * protection.
+ *
+ * However, the scan worker get's triggered without anybody noticing and thus we
+ * must ensure the presence of the devices as well as data consistency:
+ * - The sub-interface and device driver module get both their reference
+ *   counters incremented whenever we start a scan, so they cannot disappear
+ *   during operation.
+ * - Data consistency is achieved by the use of rcu protected pointers.
+ */
+static int mac802154_scan_cleanup_locked(struct ieee802154_local *local,
+					 struct ieee802154_sub_if_data *sdata,
+					 bool aborted)
+{
+	struct wpan_dev *wpan_dev = &sdata->wpan_dev;
+	struct wpan_phy *wpan_phy = local->phy;
+	struct cfg802154_scan_request *request;
+	u8 cmd;
+
+	/* Prevent any further use of the scan request */
+	clear_bit(IEEE802154_IS_SCANNING, &local->ongoing);
+	cancel_delayed_work(&local->scan_work);
+	request = rcu_replace_pointer(local->scan_req, NULL, 1);
+	if (!request)
+		return 0;
+	kfree_rcu(request);
+
+	/* Advertize first, while we know the devices cannot be removed */
+	cmd = aborted ? NL802154_CMD_ABORT_SCAN : NL802154_CMD_SCAN_DONE;
+	nl802154_scan_done(wpan_phy, wpan_dev, cmd);
+
+	/* Cleanup software stack */
+	ieee802154_mlme_op_post(local);
+
+	/* Set the hardware back in its original state */
+	drv_set_channel(local, wpan_phy->current_page,
+			wpan_phy->current_channel);
+	ieee802154_configure_durations(wpan_phy, wpan_phy->current_page,
+				       wpan_phy->current_channel);
+	drv_stop(local);
+	synchronize_net();
+	sdata->required_filtering = sdata->iface_default_filtering;
+	drv_start(local, sdata->required_filtering, &local->addr_filt);
+
+	return 0;
+}
+
+int mac802154_abort_scan_locked(struct ieee802154_local *local,
+				struct ieee802154_sub_if_data *sdata)
+{
+	ASSERT_RTNL();
+
+	if (!mac802154_is_scanning(local))
+		return -ESRCH;
+
+	return mac802154_scan_cleanup_locked(local, sdata, true);
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
+static void mac802154_flush_queued_beacons(struct ieee802154_local *local)
+{
+	struct cfg802154_mac_pkt *mac_pkt, *tmp;
+
+	list_for_each_entry_safe(mac_pkt, tmp, &local->rx_beacon_list, node) {
+		list_del(&mac_pkt->node);
+		kfree_skb(mac_pkt->skb);
+		kfree(mac_pkt);
+	}
+}
+
+static void
+mac802154_scan_get_next_channel(struct ieee802154_local *local,
+                                struct cfg802154_scan_request *scan_req,
+				u8 *channel)
+{
+	(*channel)++;
+        *channel = find_next_bit((const unsigned long *)&scan_req->channels,
+				 IEEE802154_MAX_CHANNEL + 1,
+				 *channel);
+}
+
+static int mac802154_scan_find_next_chan(struct ieee802154_local *local,
+                                         struct cfg802154_scan_request *scan_req,
+                                         u8 page, u8 *channel)
+{
+	mac802154_scan_get_next_channel(local, scan_req, channel);
+	if (*channel > IEEE802154_MAX_CHANNEL)
+		return -EINVAL;
+
+	return 0;
+}
+
+void mac802154_scan_worker(struct work_struct *work)
+{
+	struct ieee802154_local *local =
+		container_of(work, struct ieee802154_local, scan_work.work);
+	struct cfg802154_scan_request *scan_req;
+	struct ieee802154_sub_if_data *sdata;
+	unsigned int scan_duration = 0;
+	struct wpan_phy* wpan_phy;
+	u8 scan_req_duration;
+	u8 page, channel;
+	int ret;
+
+	/* Ensure the device receiver is turned off when changing channels
+	 * because there is no atomic way to change the channel and know on
+	 * which one a beacon might have been received.
+	 */
+	drv_stop(local);
+	synchronize_net();
+	mac802154_flush_queued_beacons(local);
+
+	rcu_read_lock();
+	scan_req = rcu_dereference(local->scan_req);
+	if (unlikely(!scan_req)) {
+		rcu_read_unlock();
+		return;
+	}
+
+	sdata = IEEE802154_WPAN_DEV_TO_SUB_IF(scan_req->wpan_dev);
+
+	/* Wait an arbitrary amount of time in case we cannot use the device */
+	if (local->suspended || !ieee802154_sdata_running(sdata)) {
+		rcu_read_unlock();
+		queue_delayed_work(local->mac_wq, &local->scan_work,
+				   msecs_to_jiffies(1000));
+		return;
+	}
+
+	wpan_phy = scan_req->wpan_phy;
+	scan_req_duration = scan_req->duration;
+
+	/* Look for the next valid chan */
+	page = local->scan_page;
+	channel = local->scan_channel;
+	do {
+                ret = mac802154_scan_find_next_chan(local, scan_req, page, &channel);
+                if (ret) {
+			rcu_read_unlock();
+                        goto end_scan;
+                }
+        } while (!ieee802154_chan_is_valid(scan_req->wpan_phy, page, channel));
+
+        rcu_read_unlock();
+
+	/* Bypass the stack on purpose when changing the channel */
+	rtnl_lock();
+	ret = drv_set_channel(local, page, channel);
+	rtnl_unlock();
+	if (ret) {
+                dev_err(&sdata->dev->dev,
+                        "Channel change failure during scan, aborting (%d)\n", ret);
+		goto end_scan;
+	}
+
+	local->scan_page = page;
+	local->scan_channel = channel;
+
+	rtnl_lock();
+	ret = drv_start(local, IEEE802154_FILTERING_3_SCAN, &local->addr_filt);
+	rtnl_unlock();
+	if (ret) {
+                dev_err(&sdata->dev->dev,
+                        "Restarting failure after channel change, aborting (%d)\n", ret);
+		goto end_scan;
+	}
+
+	ieee802154_configure_durations(wpan_phy, page, channel);
+	scan_duration = mac802154_scan_get_channel_time(scan_req_duration,
+							wpan_phy->symbol_duration);
+	dev_dbg(&sdata->dev->dev,
+		"Scan page %u channel %u for %ums\n",
+		page, channel, jiffies_to_msecs(scan_duration));
+	queue_delayed_work(local->mac_wq, &local->scan_work, scan_duration);
+	return;
+
+end_scan:
+	rtnl_lock();
+	mac802154_scan_cleanup_locked(local, sdata, false);
+	rtnl_unlock();
+}
+
+int mac802154_trigger_scan_locked(struct ieee802154_sub_if_data *sdata,
+				  struct cfg802154_scan_request *request)
+{
+	struct ieee802154_local *local = sdata->local;
+
+	ASSERT_RTNL();
+
+	if (mac802154_is_scanning(local))
+		return -EBUSY;
+
+	/* TODO: support other scanning type */
+	if (request->type != NL802154_SCAN_PASSIVE)
+		return -EOPNOTSUPP;
+
+	/* Store scanning parameters */
+	rcu_assign_pointer(local->scan_req, request);
+
+	/* Software scanning requires to set promiscuous mode, so we need to
+	 * pause the Tx queue during the entire operation.
+	 */
+	ieee802154_mlme_op_pre(local);
+
+	sdata->required_filtering = IEEE802154_FILTERING_3_SCAN;
+	local->scan_page = request->page;
+	local->scan_channel = -1;
+	set_bit(IEEE802154_IS_SCANNING, &local->ongoing);
+
+	nl802154_scan_started(request->wpan_phy, request->wpan_dev);
+
+	queue_delayed_work(local->mac_wq, &local->scan_work, 0);
+
+	return 0;
+}
+
+int mac802154_process_beacon(struct ieee802154_local *local,
+			     struct sk_buff *skb,
+			     u8 page, u8 channel)
+{
+	struct ieee802154_beacon_hdr *bh = (void *)skb->data;
+	struct ieee802154_addr *src = &mac_cb(skb)->source;
+	struct cfg802154_scan_request *scan_req;
+	struct ieee802154_coord_desc desc;
+
+	if (skb->len != sizeof(*bh))
+		return -EINVAL;
+
+	if (unlikely(src->mode == IEEE802154_ADDR_NONE))
+		return -EINVAL;
+
+	dev_dbg(&skb->dev->dev,
+		"BEACON received on page %u channel %u\n",
+		page, channel);
+
+	memcpy(&desc.addr, src, sizeof(desc.addr));
+	desc.page = page;
+	desc.channel = channel;
+	desc.link_quality = mac_cb(skb)->lqi;
+	desc.superframe_spec = get_unaligned_le16(skb->data);
+	desc.gts_permit = bh->gts_permit;
+
+	trace_802154_scan_event(&desc);
+
+	rcu_read_lock();
+	scan_req = rcu_dereference(local->scan_req);
+	if (likely(scan_req))
+		nl802154_scan_event(scan_req->wpan_phy, scan_req->wpan_dev, &desc);
+	rcu_read_unlock();
+
+	return 0;
+}
-- 
2.34.1

