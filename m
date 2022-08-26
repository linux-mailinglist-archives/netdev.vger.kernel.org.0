Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A7875A29C7
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 16:42:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344555AbiHZOlu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 10:41:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344559AbiHZOlf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 10:41:35 -0400
Received: from relay8-d.mail.gandi.net (relay8-d.mail.gandi.net [217.70.183.201])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A20CDD7586;
        Fri, 26 Aug 2022 07:41:24 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 415821BF20B;
        Fri, 26 Aug 2022 14:41:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1661524883;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MRxmk5U2NtM9dmjW2ZyDsahegM/fp9SMC4hkwCN2+Vs=;
        b=WnuKlg+4jz6I3wqfhq0pzx2PRF2IXVC9Z0+AT/uLuX84lpZqTKx6oft2Ht6RPPQcb5hqNu
        MM3huOC/JWE/NzInFelkZipJYXnp4I6JmaY3ETKBpPFeGYYmHIUT7NTNDdd+HhsWyVd1Qb
        vkeIRirorLCfjCMRAu8BJoUjJUcMSyf5PmgLJKDDRIC0sSUXbQ0/kUzACMruW0KF0DwzoW
        NiWrNd+S0QsjVUrMpoXMm9h4MTDUGGnTWFBHEp2YfNeRLswVrnFFdKg42HcJvdqTDGFEG6
        Z9L3kxTTFtDlrL11nrtS2/DIXzQuh1IriBfhyznoH9wQS2VpQA38MCaEVZYG6Q==
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
Subject: [PATCH wpan-next v2 11/11] net: mac802154: Handle passive scanning
Date:   Fri, 26 Aug 2022 16:40:49 +0200
Message-Id: <20220826144049.256134-12-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220826144049.256134-1-miquel.raynal@bootlin.com>
References: <20220826144049.256134-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement the core hooks in order to provide the softMAC layer support
for passive scans. Scans are requested by the user and can be aborted.

Changing the channels is prohibited during the scan.

As transceivers enter promiscuous mode during scans, they might stop
checking frame validity so we ensure this gets done at mac level.

The implementation uses a workqueue triggered at a certain interval
depending on the symbol duration for the current channel and the
duration order provided.

Received beacons during a passive scan are processed also in a work
queue and forwarded to the upper layer.

Active scanning is not supported yet.

Co-developed-by: David Girault <david.girault@qorvo.com>
Signed-off-by: David Girault <david.girault@qorvo.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 include/linux/ieee802154.h   |   4 +
 include/net/cfg802154.h      |  12 ++
 net/mac802154/Makefile       |   2 +-
 net/mac802154/cfg.c          |  39 +++++
 net/mac802154/ieee802154_i.h |  36 ++++-
 net/mac802154/iface.c        |   6 +
 net/mac802154/main.c         |  17 +-
 net/mac802154/rx.c           |  46 ++++++
 net/mac802154/scan.c         | 291 +++++++++++++++++++++++++++++++++++
 9 files changed, 448 insertions(+), 5 deletions(-)
 create mode 100644 net/mac802154/scan.c

diff --git a/include/linux/ieee802154.h b/include/linux/ieee802154.h
index 929d4e672575..94bfee22bd0a 100644
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
index bfd6d5725a40..d6b0195df3cd 100644
--- a/include/net/cfg802154.h
+++ b/include/net/cfg802154.h
@@ -303,6 +303,18 @@ struct cfg802154_scan_request {
 	struct wpan_phy *wpan_phy;
 };
 
+/**
+ * struct cfg802154_mac_pkt - MAC packet descriptor (beacon/command)
+ * @node: MAC packets to process list member
+ * @skb: the received sk_buff
+ * @sdata: the interface on which @skb was received
+ */
+struct cfg802154_mac_pkt {
+	struct list_head node;
+	struct sk_buff *skb;
+	struct ieee802154_sub_if_data *sdata;
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
index 4116a894c86e..1f532d93d870 100644
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
@@ -261,6 +265,39 @@ ieee802154_set_ackreq_default(struct wpan_phy *wpan_phy,
 	return 0;
 }
 
+static int mac802154_trigger_scan(struct wpan_phy *wpan_phy,
+				  struct cfg802154_scan_request *request)
+{
+	struct ieee802154_local *local = wpan_phy_priv(wpan_phy);
+	struct ieee802154_sub_if_data *sdata;
+	int ret;
+
+	sdata = IEEE802154_WPAN_DEV_TO_SUB_IF(request->wpan_dev);
+
+	ASSERT_RTNL();
+
+	mutex_lock(&local->scan_lock);
+	ret = mac802154_trigger_scan_locked(sdata, request);
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
@@ -468,6 +505,8 @@ const struct cfg802154_ops mac802154_config_ops = {
 	.set_max_frame_retries = ieee802154_set_max_frame_retries,
 	.set_lbt_mode = ieee802154_set_lbt_mode,
 	.set_ackreq_default = ieee802154_set_ackreq_default,
+	.trigger_scan = mac802154_trigger_scan,
+	.abort_scan = mac802154_abort_scan,
 #ifdef CONFIG_IEEE802154_NL802154_EXPERIMENTAL
 	.get_llsec_table = ieee802154_get_llsec_table,
 	.lock_llsec_table = ieee802154_lock_llsec_table,
diff --git a/net/mac802154/ieee802154_i.h b/net/mac802154/ieee802154_i.h
index b8775bcc9003..774e07236fd0 100644
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
@@ -43,15 +47,27 @@ struct ieee802154_local {
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
+	struct mutex scan_lock;
+	int scan_channel_idx;
+	struct cfg802154_scan_request __rcu *scan_req;
+	struct delayed_work scan_work;
+	bool was_promiscuous;
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
@@ -210,6 +226,20 @@ void mac802154_unlock_table(struct net_device *dev);
 
 int mac802154_wpan_update_llsec(struct net_device *dev);
 
+/* PAN management handling */
+void mac802154_scan_worker(struct work_struct *work);
+int mac802154_trigger_scan_locked(struct ieee802154_sub_if_data *sdata,
+				  struct cfg802154_scan_request *request);
+int mac802154_abort_scan_locked(struct ieee802154_local *local);
+int mac802154_process_beacon(struct ieee802154_local *local,
+			     struct sk_buff *skb);
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
index 29af3f80b4d0..97974466e894 100644
--- a/net/mac802154/iface.c
+++ b/net/mac802154/iface.c
@@ -315,6 +315,12 @@ static int mac802154_slave_close(struct net_device *dev)
 
 	ASSERT_RTNL();
 
+	if (mac802154_is_scanning(local)) {
+		mutex_lock(&local->scan_lock);
+		mac802154_abort_scan_locked(local);
+		mutex_unlock(&local->scan_lock);
+	}
+
 	mutex_lock(&local->device_lock);
 
 	netif_stop_queue(dev);
diff --git a/net/mac802154/main.c b/net/mac802154/main.c
index 7657fb46c9e1..a45055d475dd 100644
--- a/net/mac802154/main.c
+++ b/net/mac802154/main.c
@@ -89,14 +89,18 @@ ieee802154_alloc_hw(size_t priv_data_len, const struct ieee802154_ops *ops)
 	local->ops = ops;
 
 	INIT_LIST_HEAD(&local->interfaces);
+	INIT_LIST_HEAD(&local->rx_beacon_list);
 	mutex_init(&local->iflist_mtx);
 	mutex_init(&local->device_lock);
+	mutex_init(&local->scan_lock);
 
 	tasklet_setup(&local->tasklet, ieee802154_tasklet_handler);
 
 	skb_queue_head_init(&local->skb_queue);
 
 	INIT_WORK(&local->sync_tx_work, ieee802154_xmit_sync_worker);
+	INIT_DELAYED_WORK(&local->scan_work, mac802154_scan_worker);
+	INIT_WORK(&local->rx_beacon_work, mac802154_rx_beacon_worker);
 
 	/* init supported flags with 802.15.4 default ranges */
 	phy->supported.max_minbe = 8;
@@ -186,6 +190,7 @@ static void ieee802154_setup_wpan_phy_pib(struct wpan_phy *wpan_phy)
 int ieee802154_register_hw(struct ieee802154_hw *hw)
 {
 	struct ieee802154_local *local = hw_to_local(hw);
+	char mac_wq_name[IFNAMSIZ + 10] = {};
 	struct net_device *dev;
 	int rc = -ENOSYS;
 
@@ -196,6 +201,13 @@ int ieee802154_register_hw(struct ieee802154_hw *hw)
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
 
@@ -227,7 +239,7 @@ int ieee802154_register_hw(struct ieee802154_hw *hw)
 
 	rc = wpan_phy_register(local->phy);
 	if (rc < 0)
-		goto out_wq;
+		goto out_mac_wq;
 
 	rtnl_lock();
 
@@ -246,6 +258,8 @@ int ieee802154_register_hw(struct ieee802154_hw *hw)
 
 out_phy:
 	wpan_phy_unregister(local->phy);
+out_mac_wq:
+	destroy_workqueue(local->mac_wq);
 out_wq:
 	destroy_workqueue(local->workqueue);
 out:
@@ -266,6 +280,7 @@ void ieee802154_unregister_hw(struct ieee802154_hw *hw)
 
 	rtnl_unlock();
 
+	destroy_workqueue(local->mac_wq);
 	destroy_workqueue(local->workqueue);
 	wpan_phy_unregister(local->phy);
 }
diff --git a/net/mac802154/rx.c b/net/mac802154/rx.c
index ea5320411848..b28fbfff6e51 100644
--- a/net/mac802154/rx.c
+++ b/net/mac802154/rx.c
@@ -29,11 +29,37 @@ static int ieee802154_deliver_skb(struct sk_buff *skb)
 	return netif_receive_skb(skb);
 }
 
+void mac802154_rx_beacon_worker(struct work_struct *work)
+{
+	struct ieee802154_local *local =
+		container_of(work, struct ieee802154_local, rx_beacon_work);
+	struct cfg802154_mac_pkt *mac_pkt;
+
+	mutex_lock(&local->scan_lock);
+
+	if (list_empty(&local->rx_beacon_list))
+		goto unlock;
+
+	mac_pkt = list_first_entry(&local->rx_beacon_list,
+				   struct cfg802154_mac_pkt, node);
+
+	mac802154_process_beacon(local, mac_pkt->skb);
+
+	list_del(&mac_pkt->node);
+	kfree_skb(mac_pkt->skb);
+	kfree(mac_pkt);
+
+unlock:
+	mutex_unlock(&local->scan_lock);
+}
+
 static int
 ieee802154_subif_frame(struct ieee802154_sub_if_data *sdata,
 		       struct sk_buff *skb, const struct ieee802154_hdr *hdr)
 {
 	struct wpan_dev *wpan_dev = &sdata->wpan_dev;
+	struct wpan_phy *wpan_phy = sdata->local->hw.phy;
+	struct cfg802154_mac_pkt *mac_pkt;
 	__le16 span, sshort;
 	int rc;
 
@@ -42,6 +68,13 @@ ieee802154_subif_frame(struct ieee802154_sub_if_data *sdata,
 	span = wpan_dev->pan_id;
 	sshort = wpan_dev->short_addr;
 
+	/* Level 3 filtering: Only beacons are accepted during scans */
+	if (mac802154_is_scanning(sdata->local)) {
+		if (wpan_phy->filtering != IEEE802154_FILTERING_3_SCAN &&
+		    mac_cb(skb)->type != IEEE802154_FC_TYPE_BEACON)
+			goto fail;
+	}
+
 	switch (mac_cb(skb)->dest.mode) {
 	case IEEE802154_ADDR_NONE:
 		if (hdr->source.mode != IEEE802154_ADDR_NONE)
@@ -94,6 +127,19 @@ ieee802154_subif_frame(struct ieee802154_sub_if_data *sdata,
 
 	switch (mac_cb(skb)->type) {
 	case IEEE802154_FC_TYPE_BEACON:
+		if (!mac802154_is_scanning(sdata->local))
+			goto fail;
+
+		mac_pkt = kzalloc(sizeof(*mac_pkt), GFP_ATOMIC);
+		if (!mac_pkt)
+			goto fail;
+
+		mac_pkt->skb = skb_get(skb);
+		mac_pkt->sdata = sdata;
+		list_add_tail(&mac_pkt->node, &sdata->local->rx_beacon_list);
+		queue_work(sdata->local->mac_wq, &sdata->local->rx_beacon_work);
+		kfree_skb(skb);
+		return NET_RX_SUCCESS;
 	case IEEE802154_FC_TYPE_ACK:
 	case IEEE802154_FC_TYPE_MAC_CMD:
 		goto fail;
diff --git a/net/mac802154/scan.c b/net/mac802154/scan.c
new file mode 100644
index 000000000000..a2c08cd90a27
--- /dev/null
+++ b/net/mac802154/scan.c
@@ -0,0 +1,291 @@
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
+#include <linux/rtnetlink.h>
+#include <net/mac802154.h>
+
+#include "ieee802154_i.h"
+#include "driver-ops.h"
+#include "../ieee802154/nl802154.h"
+
+static bool mac802154_is_promiscuous(struct ieee802154_local *local)
+{
+	struct ieee802154_sub_if_data *sdata;
+	bool promiscuous = false;
+
+	/* Check if one subif is already in promiscuous mode. Since the list is
+	 * protected by its own mutex, take it here to ensure no modification
+	 * occurs during the check.
+	 */
+	rcu_read_lock();
+	list_for_each_entry(sdata, &local->interfaces, list) {
+		if (ieee802154_sdata_running(sdata) &&
+		    sdata->wpan_dev.promiscuous_mode) {
+			/* At least one is in promiscuous mode */
+			promiscuous = true;
+			break;
+		}
+	}
+	rcu_read_unlock();
+
+	return promiscuous;
+}
+
+static int mac802154_set_promiscuous_mode(struct ieee802154_local *local,
+					  bool state)
+{
+	int ret, ret_start;
+
+	drv_stop(local);
+	synchronize_net();
+
+	if (state)
+		local->hw.phy->filtering = IEEE802154_FILTERING_2_PROMISCUOUS;
+	else
+		local->hw.phy->filtering = IEEE802154_FILTERING_4_FRAME_FIELDS;
+
+	ret = drv_set_promiscuous_mode(local, state);
+	if (ret)
+		pr_err("Scan configuration failure: cannot %s promiscuous mode",
+		       state ? "set" : "reset");
+	ret_start = drv_start(local);
+
+	return ret ? ret : ret_start;
+}
+
+static int mac802154_send_scan_done(struct ieee802154_local *local, u8 cmd)
+{
+	struct cfg802154_scan_request *scan_req;
+	struct wpan_phy *wpan_phy;
+	struct wpan_dev *wpan_dev;
+
+	scan_req = rcu_dereference_protected(local->scan_req,
+					     lockdep_is_held(&local->scan_lock));
+	wpan_phy = scan_req->wpan_phy;
+	wpan_dev = scan_req->wpan_dev;
+
+	cfg802154_flush_known_coordinators(wpan_dev);
+
+	return nl802154_send_scan_done(wpan_phy, wpan_dev, scan_req, cmd);
+}
+
+static int mac802154_end_of_scan(struct ieee802154_local *local, bool aborted)
+{
+	u8 cmd;
+
+	drv_set_channel(local, local->phy->current_page,
+			local->phy->current_channel);
+	ieee802154_configure_durations(local->phy, local->phy->current_page,
+				       local->phy->current_channel);
+
+	clear_bit(IEEE802154_IS_SCANNING, &local->ongoing);
+	if (!local->was_promiscuous)
+		mac802154_set_promiscuous_mode(local, false);
+	ieee802154_mlme_op_post(local);
+	module_put(local->hw.parent->driver->owner);
+
+	cmd = aborted ? NL802154_CMD_ABORT_SCAN : NL802154_CMD_SCAN_DONE;
+
+	return mac802154_send_scan_done(local, cmd);
+}
+
+int mac802154_abort_scan_locked(struct ieee802154_local *local)
+{
+	lockdep_assert_held(&local->scan_lock);
+
+	if (!mac802154_is_scanning(local))
+		return -ESRCH;
+
+	cancel_delayed_work(&local->scan_work);
+
+	return mac802154_end_of_scan(local, true);
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
+void mac802154_flush_queued_beacons(struct ieee802154_local *local)
+{
+	struct cfg802154_mac_pkt *beacon, *tmp;
+
+	lockdep_assert_held(&local->scan_lock);
+
+	list_for_each_entry_safe(beacon, tmp, &local->rx_beacon_list, node) {
+		list_del(&beacon->node);
+		kfree_skb(beacon->skb);
+		kfree(beacon);
+	}
+}
+
+void mac802154_scan_worker(struct work_struct *work)
+{
+	struct ieee802154_local *local =
+		container_of(work, struct ieee802154_local, scan_work.work);
+	struct cfg802154_scan_request *scan_req;
+	struct ieee802154_sub_if_data *sdata;
+	unsigned int scan_duration;
+	unsigned long chan;
+	int ret;
+
+	/* In practice we don't really need the rtnl here, besides for the
+	 * drv_set_channel() operation. Unfortunately, as the rtnl is always
+	 * taken before any other lock, we must acquire it before scan_lock() to
+	 * avoid circular dependencies.
+	 */
+	rtnl_lock();
+	mutex_lock(&local->scan_lock);
+
+	if (!mac802154_is_scanning(local))
+		goto unlock_mutex;
+
+	scan_req = rcu_dereference_protected(local->scan_req,
+					     lockdep_is_held(&local->scan_lock));
+	sdata = IEEE802154_WPAN_DEV_TO_SUB_IF(scan_req->wpan_dev);
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
+			mac802154_end_of_scan(local, false);
+			goto unlock_mutex;
+		}
+
+		/* Bypass the stack on purpose. As the channel change cannot be
+		 * made atomic with regard to the incoming beacon flow, we flush
+		 * the beacons list after changing the channel and before
+		 * releasing the scan lock, to avoid processing beacons which
+		 * have been received during this time frame.
+		 */
+		ret = drv_set_channel(local, scan_req->page, chan);
+		local->scan_channel_idx = chan;
+		ieee802154_configure_durations(local->phy, scan_req->page, chan);
+		mac802154_flush_queued_beacons(local);
+	} while (ret);
+
+queue_work:
+	scan_duration = mac802154_scan_get_channel_time(scan_req->duration,
+							local->phy->symbol_duration);
+	pr_debug("Scan channel %lu of page %u for %ums\n",
+		 chan, scan_req->page, jiffies_to_msecs(scan_duration));
+	queue_delayed_work(local->mac_wq, &local->scan_work, scan_duration);
+
+unlock_mutex:
+	mutex_unlock(&local->scan_lock);
+	rtnl_unlock();
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
+	if (mac802154_is_promiscuous(local)) {
+		local->was_promiscuous = true;
+	} else {
+		local->was_promiscuous = false;
+		ret = mac802154_set_promiscuous_mode(local, true);
+		if (ret)
+			goto cancel_mlme;
+	}
+
+	local->scan_channel_idx = -1;
+	set_bit(IEEE802154_IS_SCANNING, &local->ongoing);
+
+	/* Starting a background job, ensure the module cannot be removed */
+	if (!try_module_get(local->hw.parent->driver->owner)) {
+		ret = -ENODEV;
+		goto cancel_promiscuous_mode;
+	}
+
+	queue_delayed_work(local->mac_wq, &local->scan_work, 0);
+
+	nl802154_send_start_scan(local->scan_req->wpan_phy,
+				 local->scan_req->wpan_dev);
+
+	return 0;
+
+cancel_promiscuous_mode:
+	clear_bit(IEEE802154_IS_SCANNING, &local->ongoing);
+	if (!local->was_promiscuous)
+		mac802154_set_promiscuous_mode(local, false);
+cancel_mlme:
+	ieee802154_mlme_op_post(local);
+	return ret;
+}
+
+int mac802154_process_beacon(struct ieee802154_local *local,
+			     struct sk_buff *skb)
+{
+	struct ieee802154_beacon_hdr *bh = (void *)skb->data;
+	struct ieee802154_addr *src = &mac_cb(skb)->source;
+	struct cfg802154_scan_request *scan_req;
+	struct ieee802154_coord_desc *desc;
+
+	/* Check the validity of the frame length */
+	if (skb->len < sizeof(*bh))
+		return -EINVAL;
+
+	if (unlikely(src->mode == IEEE802154_ADDR_NONE))
+		return -EINVAL;
+
+	scan_req = rcu_dereference_protected(local->scan_req,
+					     &local->scan_lock);
+	if (unlikely(!scan_req))
+		return -EINVAL;
+
+	pr_debug("Beacon received on channel %d of page %d\n",
+		 local->scan_channel_idx, scan_req->page);
+
+	/* Parse beacon, create PAN information and forward to upper layers */
+	desc = cfg802154_alloc_coordinator(src);
+	if (!desc)
+		return -ENOMEM;
+
+	desc->page = scan_req->page;
+	desc->channel = local->scan_channel_idx;
+	desc->link_quality = mac_cb(skb)->lqi;
+	desc->superframe_spec = get_unaligned_le16(skb->data);
+	desc->gts_permit = bh->gts_permit;
+	cfg802154_record_coordinator(scan_req->wpan_phy, scan_req->wpan_dev, desc);
+
+	return 0;
+}
-- 
2.34.1

